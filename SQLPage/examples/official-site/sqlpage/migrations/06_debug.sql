-- Insert the http_header component into the component table
INSERT INTO component (name, description, icon)
VALUES (
        'debug',
        'Visualize any set of values as JSON.
Can be used to display all the parameters passed to the component.
Useful for debugging: just replace the name of the component you want to debug with ''debug'', and see all the top-level and row-level parameters that are passed to it, and their types.',
        'bug'
    );
-- Insert an example usage of the http_header component into the example table
INSERT INTO example (component, description, properties)
VALUES (
        'debug',
        'At any time, if you are confused about what data you are passing to a component, just replace the component name with ''debug'' to see all the parameters that are passed to it.',
        JSON('[{"component": "debug", "my_top_level_property": true}, {"x": "y", "z": 42}, {"a": "b", "c": null}]')
    ),
    (
        'debug',
        'Show the result of a SQLPage function:
        
```sql
select ''debug'' as component, sqlpage.environment_variable(''HOME'');
```',
        NULL
    );