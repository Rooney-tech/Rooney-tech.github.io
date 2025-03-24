use percent_encoding::{percent_encode, NON_ALPHANUMERIC};
use serde::{Deserialize, Deserializer};
use std::borrow::Cow;
use std::fmt;

pub struct URLParameters(String);

impl URLParameters {
    fn encode_and_push(&mut self, v: &str) {
        let val: Cow<str> = percent_encode(v.as_bytes(), NON_ALPHANUMERIC).into();
        self.0.push_str(&val);
    }
    fn push_kv(&mut self, key: &str, value: &str) {
        if !self.0.is_empty() {
            self.0.push('&');
        }
        self.encode_and_push(key);
        self.0.push('=');
        self.encode_and_push(value);
    }
    pub fn get(&self) -> &str {
        &self.0
    }
}

impl<'de> Deserialize<'de> for URLParameters {
    fn deserialize<D>(deserializer: D) -> Result<URLParameters, D::Error>
    where
        D: Deserializer<'de>,
    {
        // Visit an object and append keys and values to the string
        struct URLParametersVisitor;

        impl<'de> serde::de::Visitor<'de> for URLParametersVisitor {
            type Value = URLParameters;

            fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                formatter.write_str("a sequence")
            }

            fn visit_map<A>(self, mut map: A) -> Result<URLParameters, A::Error>
            where
                A: serde::de::MapAccess<'de>,
            {
                let mut out = URLParameters(String::new());
                while let Some((key, value)) =
                    map.next_entry::<Cow<str>, Cow<serde_json::value::RawValue>>()?
                {
                    let value = value.get();
                    if let Ok(str_val) = serde_json::from_str::<Cow<str>>(value) {
                        out.push_kv(&key, &str_val);
                    } else if let Ok(vec_val) =
                        serde_json::from_str::<Vec<serde_json::Value>>(value)
                    {
                        for val in vec_val {
                            if !out.0.is_empty() {
                                out.0.push('&');
                            }
                            out.encode_and_push(&key);
                            out.0.push_str("[]");
                            out.0.push('=');
                            out.encode_and_push(&val.to_string());
                        }
                    } else {
                        out.push_kv(&key, value);
                    }
                }

                Ok(out)
            }
        }

        deserializer.deserialize_map(URLParametersVisitor)
    }
}

#[test]
fn test_url_parameters_deserializer() {
    use serde_json::json;
    let json = json!({
        "x": "hello world",
        "num": 123,
        "arr": [1, 2, 3],
    });

    let url_parameters: URLParameters = serde_json::from_value(json).unwrap();
    assert_eq!(
        url_parameters.0,
        "x=hello%20world&num=123&arr[]=1&arr[]=2&arr[]=3"
    );
}
