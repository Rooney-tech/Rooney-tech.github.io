INSERT INTO component (name, description, icon, introduced_in_version)
VALUES (
        'tab',
        'Build a tabbed interface, with each tab being a link to a page. Each tab can be in two states: active or inactive.',
        'row-insert-bottom',
        '0.9.5'
    );
INSERT INTO parameter (
        component,
        name,
        description,
        type,
        top_level,
        optional
    )
VALUES (
        'tab',
        'title',
        'Text to display on the tab. If link is not set, the link will be the current page with a ''$tab'' parameter set to the tab''s title. If ''id'' is set, the page will be scrolled to the tab.',
        'TEXT',
        FALSE,
        FALSE
    ),
    (
        'tab',
        'link',
        'Link to the page to display when the tab is clicked. By default, the link refers to the current page, with a ''tab'' parameter set to the tab''s title and hash set to the id (if passed) - this brings us back to the location of the tab after submission.',
        'TEXT',
        FALSE,
        TRUE
    ),
    (
        'tab',
        'active',
        'Whether the tab is active or not. Defaults to false.',
        'BOOLEAN',
        FALSE,
        TRUE
    ),
    (
        'tab',
        'icon',
        'Name of the icon to display on the tab. See tabler-icons.io for a list of available icons.',
        'TEXT',
        FALSE,
        TRUE
    ),
    (
        'tab',
        'color',
        'Color of the tab. See preview.tabler.io/colors.html for a list of available colors.',
        'TEXT',
        FALSE,
        TRUE
    ),
    (
        'tab',
        'description',
        'Description of the tab. This is displayed when the user hovers over the tab.',
        'TEXT',
        FALSE,
        TRUE
    ),
    (
        'tab',
        'center',
        'Whether the tabs should be centered or not. Defaults to false.',
        'BOOLEAN',
        TRUE,
        TRUE
    )
    ;

INSERT INTO example (component, description, properties)
VALUES (
        'tab',
        'This example shows a very basic set of three tabs. The first tab is active. You could use this at the top of a page for easy navigation.

To implement contents that change based on the active tab, use the `tab` parameter in the page query string.
For example, if the page is `/my-page.sql`, then the first tab will have a link of `/my-page.sql?tab=My+First+tab`.

You could then for instance display contents coming from the database based on the value of the `tab` parameter.
For instance: `SELECT ''text'' AS component, contents_md FROM my_page_contents WHERE tab = $tab`.
Or you could write different queries for different tabs and use the `$tab` parameter with a static value in a where clause to switch between tabs:

```sql
select ''tab'' as component;
select ''Projects'' as title, $tab = ''Projects'' as active;
select ''Tasks''    as title, $tab = ''Tasks''    as active;

select ''table'' as component;

select * from my_projects where $tab = ''Projects'';
select * from my_tasks    where $tab = ''Tasks'';
```

Note that the example below is completely static, and does not use the `tab` parameter to actually switch between tabs.
View the [dynamic tabs example](/examples/tabs/).
',
        JSON(
            '[
            { "component": "tab" },
            { "title": "This tab does not exist", "active": true, "link": "?component=tab&tab=tab_1" },
            { "title": "I am not a true tab", "link": "?component=tab&tab=tab_2" },
            { "title": "Do not click here", "link": "?component=tab&tab=tab_3" }
        ]'
        )
    ),
    (
        'tab',
        'This example shows a more sophisticated set of tabs. The tabs are centered, the active tab has a different color, and all the tabs have a custom link and icon.',
        JSON(
            '[
            { "component": "tab", "center": true },
            { "title": "Hero", "link": "?component=hero#component", "icon": "home", "description": "The hero component is a full-width banner with a title and an image." },
            { "title": "Tab", "link": "?component=tab#component", "icon": "user", "color": "purple" },
            { "title": "Card", "link": "?component=card#component", "icon": "credit-card" }
        ]'
        )
    )
    ;
