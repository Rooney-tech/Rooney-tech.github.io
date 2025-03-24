-- Insert the 'variables' function into sqlpage_functions table
INSERT INTO sqlpage_functions (
    "name",
    "introduced_in_version",
    "icon",
    "description_md"
)
VALUES (
    'uploaded_file_path',
    '0.17.0',
    'upload',
    'Returns the path to a temporary file containing the contents of an uploaded file.

## Example: handling a picture upload

### Making a form

```sql
select ''form'' as component, ''handle_picture_upload.sql'' as action;
select ''myfile'' as name, ''file'' as type, ''Picture'' as label;
select ''title'' as name, ''text'' as type, ''Title'' as label;
```

### Handling the form response

### Inserting an image file as a [data URL](https://en.wikipedia.org/wiki/Data_URI_scheme) into the database

In `handle_picture_upload.sql`, one can process the form results like this:

```sql
insert into pictures (title, path) values (:title, sqlpage.read_file_as_data_url(sqlpage.uploaded_file_path(''myfile'')));
```

> *Note*: Data URLs are larger than the original file, so it is not recommended to use them for large files.

### Inserting file contents as text into the database

When the uploaded file is a simple raw text file (e.g. a `.txt` file),
one can use the [`sqlpage.read_file_as_text`](?function=read_file_as_text#function)
function to insert the contents of the file into the database like this:

```sql
insert into text_documents (title, path) values (:title, sqlpage.read_file_as_text(sqlpage.uploaded_file_path(''my_text_file'')));
```

### Saving the uploaded file to a permanent location

When the uploaded file is larger than a few megabytes, it is not recommended to store it in the database.
Instead, one can save the file to a permanent location on the server, and store the path to the file in the database.

You can move the file to a permanent location using the [`sqlpage.persist_uploaded_file`](?function=persist_uploaded_file#function) function.
### Advanced file handling

For more advanced file handling, such as uploading files to a cloud storage service,
you can write a small script in your favorite programming language,
and call it using the [`sqlpage.exec`](?function=exec#function) function.

For instance, one could save the following small bash script to `/usr/local/bin/upload_to_s3`:

```bash
#!/bin/bash
aws s3 cp "$1" s3://your-s3-bucket-name/
echo "https://your-s3-bucket-url/$(basename "$1")"
```

Then, you can call it from SQL like this:

```sql
set url = sqlpage.exec(''upload_to_s3'', sqlpage.uploaded_file_path(''myfile''));
insert into uploaded_files (title, path) values (:title, $url);
```
'
),
(
    'uploaded_file_mime_type',
    '0.18.0',
    'file-settings',
    'Returns the MIME type of an uploaded file.

## Example: handling a picture upload

When letting the user upload a picture, you may want to check that the uploaded file is indeed an image.

```sql
select ''redirect'' as component, 
       ''invalid_file.sql'' as link
where sqlpage.uploaded_file_mime_type(''myfile'') not like ''image/%'';
```

In `invalid_file.sql`, you can display an error message to the user:

```sql
select ''alert'' as component, ''Error'' as title,
    ''Invalid file type'' as description,
    ''alert-circle'' as icon, ''red'' as color;
```

## Example: white-listing file types

You could have a database table containing the allowed MIME types, and check that the uploaded file is of one of those types:

```sql
select ''redirect'' as component, 
       ''invalid_file.sql'' as link
where sqlpage.uploaded_file_mime_type(''myfile'') not in (select mime_type from allowed_mime_types);
```
'
),
(
    'uploaded_file_name',
    '0.23.0',
    'file-description',
    'Returns the `filename` value in the `content-disposition` header.

## Example: saving uploaded file metadata for later download

### Making a form

```sql
select ''form'' as component, ''handle_file_upload.sql'' as action;
select ''myfile'' as name, ''file'' as type, ''File'' as label;
```

### Handling the form response

### Inserting an arbitrary file as a [data URL](https://en.wikipedia.org/wiki/Data_URI_scheme) into the database

In `handle_file_upload.sql`, one can process the form results like this:

```sql
insert into uploaded_files (fname, content, uploaded) values (
  sqlpage.uploaded_file_name(''myfile''),
  sqlpage.read_file_as_data_url(sqlpage.uploaded_file_path(''myfile'')),
  CURRENT_TIMESTAMP
);
```

> *Note*: Data URLs are larger than the original file, so it is not recommended to use them for large files.

### Downloading the uploaded files

The file can be downloaded by clicking a link like this:
```sql
select ''button'' as component;
select name as title, content as link from uploaded_files where name = $file_name limit 1;
```

> *Note*: because the file is ecoded as a data uri, the file is transferred to the client whether or not the link is clicked

### Large files

See the [`sqlpage.uploaded_file_path`](?function=uploaded_file_path#function) function.

See the [`sqlpage.persist_uploaded_file`](?function=persist_uploaded_file#function) function.
'
);

INSERT INTO sqlpage_function_parameters (
    "function",
    "index",
    "name",
    "description_md",
    "type"
)
VALUES (
    'uploaded_file_path',
    1,
    'name',
    'Name of the file input field in the form.',
    'TEXT'
), 
(
    'uploaded_file_path',
    2,
    'allowed_mime_type',
    'Makes the function return NULL if the uploaded file is not of the specified MIME type.
    If omitted, any MIME type is allowed.
    This makes it possible to restrict the function to only accept certain file types.',
    'TEXT'
),
(
    'uploaded_file_mime_type',
    1,
    'name',
    'Name of the file input field in the form.',
    'TEXT'
),
(
    'uploaded_file_name',
    1,
    'name',
    'Name of the file input field in the form.',
    'TEXT'
)
;
