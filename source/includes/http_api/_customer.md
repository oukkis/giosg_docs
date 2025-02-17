Customer API
============

## Users

A user represents a giosg user account. A user resource has the following attributes.

Attribute | Type | Editable | Description
:---------|:-----|:---------|------------
`id` | [ID][] | read-only | Unique identifier
`email` | string | read-only | Email address
`organization_id` | [ID][] | read-only | ID of the organization to which the user belongs to
`organization` | object | read-only | The [organization][] resource to which the user belongs to
`first_name` | string | **required** | First name. Must be a non-blank string.
`last_name`| string | **required** | Last name. Must be a non-blank string.
`is_manager` | boolean | **required** | Whether the user is a manager. You cannot change this for yourself. You may change the value for the other members of your organization, if you are a manager.
`alias` | string | **optional** | Display name, used when chatting. May be `null` but not a blank string
`gender` | integer | **optional** | Gender with three options: `"male"`, `"female"`, `null` (unknown)
`birthday` | [date][] | **optional** | Date of birth in format `YYYY-MM-DD`, e.g. `1980-06-19`
`phone` | string | **optional** | Contact phone number
`title` | title | **optional** | Title of the user. May be `null` but not a blank string
`created_at` | [date/time][] | read-only | When the user resource was created
`updated_at` | [date/time][] | read-only | When the user resource was updated last time
`avatar` | object | read-only | The avatar of the user as an object. It contains attributes `id`and `url`. This is `null` if the user has no avatar.
`is_online_enabled` | boolean | **optional** | Whether or not the user wants to serve online as an operator. This determines if the `is_online` can be true.
`is_online` | boolean | read-only | Whether the user is currently in online status as an operator, based on the most recent information about the user. This can only be `true` if `is_online_enabled` is `true` *and* the user is considered signed in. Otherwise this is `false`. See [user clients][user client] for more information.
`is_present` | boolean | read-only | Whether the user is currenlty present, based on the most recent information about the user. See [user clients][user client] for more information.
`current_chat_count` | integer | read-only | The number of chats the user has currently, based on the most recent information about the user.
`is_deleted` | boolean | read-only | Whether this user exists no more. If `true`, the resource exists only for historical purposes and cannot be used in any other context!
`team_memberships` | array of objects | read-only | The [team membership][] resources, listing the teams this user belongs to. Each object in the array has the attributes `id`, `team_id`, `team`, `is_admin`

### Get your own user

<aside class="success">
It is a common use case to first find out your own user or your organization's information, and then perform further actions on it.
</aside>

There is a special API endpoint that returns the [user][] resource depending on who is [authenticated][authentication].

`GET https://service.giosg.com/api/v5/users/me`

To find out your organization's ID, just use the `organization_id` attribute of the returned resource. Alternatively you can use the nested [organization][] resource for more details).

This API endpoint returns a 401 response if you are not being currently authenticated. It returns a 403 response if your authentication token is not directly related to one specific user.

### Get a collection of organization members

Get a [paginated collection][] of users who belong to a given organization (`<organization_id>`)

`GET https://service.giosg.com/api/v5/orgs/<organization_id>/users`

Parameter | Type | Default | Description
----------|------|---------|------------
`ordering` | [ordering][] | `created_at` | Ordering of results with options `created_at` or `email` (with or without `-`)
`include_deleted` | boolean | false | If `true`, include deleted users to results. If `false` (default), excludes any deleted users.
`is_manager` | boolean | (none) | If `true`, only include managers. If `false`, exclude all managers.

### Retrieve details of an organization member
Get a single [user][] object by its ID (`<user_id>`) that belongs to an organization (`<organization_id>`)

`GET https://service.giosg.com/api/v5/orgs/<organization_id>/users/<user_id>`

This endpoint accepts the following GET parameters.

Parameter | Type | Default | Description
----------|------|---------|------------
`include_deleted` | boolean | false | If `true`, does not return 404 for deleted resources.

If you try to get a user that has been deleted, the endpoint results in 404 response by default. You may access the removed users of your organization for historical purposes by adding `include_deleted=true` to the GET parameters.

This endpoint returns a 403 response if you do not have permissions for this organization. It returns a 404 response if the user does not exists **or** they doesn't belong to the organization.

### Update details of an organization member

> **Example request and payload**: Switch user to online

    PATCH https://service.giosg.com/api/v5/orgs/2577ef72-efa0-4b4c-b5b6-0fc3a73e818f/users/fb993c84-1591-41f1-8d36-3804117f64e0

```json
{
    "is_online_enabled": true
}
```

You may update some of the attributes of a user (`<user_id>`) that belongs to an organization (`<organization_id>`) by making a `PATCH` request:

`PATCH https://service.giosg.com/api/v5/orgs/<organization_id>/users/<user_id>`

You may also update the whole user resource with a `PUT` request. In this case, you need to define all the required attributes and any omitted optional attributes will be set to their defaults:

`PUT https://service.giosg.com/api/v5/orgs/<organization_id>/users/<user_id>`

<aside class="warning">
You are allowed to update your own details. You may only change other users' details if you have management rights for the organization. Otherwise this endpoint will result in a 403 response.
</aside>

### Channels

Changes to users will be broadcasted to following [channels][]:

Channels    | Description
------------|---------------
`api/v5/orgs/<organization_id>/users` | Changes to any user in the organization
`api/v5/orgs/<organization_id>/users/<user_id>` | Changes to a single user in the organization

## User clients

Users have two special attributes that depends of whether or not the user has announced his presence: `is_online` and `is_present`. Their values may only be `true` if there is at least one *user client* we have heard about. The system remembers when the client has last time announced about themselves and automatically determines if the related user is present. Also, user may only be online if they are also present.

What is a "client" depends on the type of the app:

- For web browser (either mobile or desktop) each browser *tab* or *window* is their own "client". It is recommended that each page load is a new client, so you only need to keep the client ID in memory while the page is running. There is no need to persist the ID, e.g. in a web storage. The client will be automatically forgotten when expired. Therefore, you should keep the expiration time relatively short.
- For mobile apps each app installation is their own "client". You register the client when the user signs in and then persist the client ID until uninstallation or sign-out. Mobile apps rarely get chances to announce their presence so their expiration time should be relatively long.

A user client has the following attributes:

Attribute | Type | Editable | Description
:---------|:-----|:---------|------------
`id` | [ID][] | read-only | An unique identifier for the client, generated by the system.
`rooms` | array of [IDs][ID] | **required** | An array of [room IDs][room] at which this client is currently present at. The user must have access for each of the listed rooms. The list may be empty, indicating that the user is not serving online at any room, but is still available e.g. for other organization members.
`expires_in` | integer | **required** | The number of seconds the system should keep this client present. This also defines how often you need to refresh the client's presence status. Longer timeout allows you to make less refresh requests. On the other hand, with longer timeouts it takes longer to notice that your client has been closed, shut down, or disconnected from the network. We recommend shorter timeouts for browsers (e.g. 60 seconds) and longer timeouts for mobile apps. You may change this value for the client. Only the latest expiration time applies.
`expires_at` | [date/time][] | read-only | When the client will expire, calculated from the `expires_in`.


### Make user client present

When a user starts using a client (e.g. opens a giosg app web page or signs in on a mobile app) they should annouonce its presence to the server:

`POST /api/v5/orgs/<organization_id>/users/<user_id>/clients`

You must a payload object with the `rooms` attribute, describing at which rooms your client is currently present. **You can only be online at the rooms that you list here!**

You must also provide the `expires_in` attribute. Please note that **you should refresh the client presence again before this number of seconds have elapsed** in order to keep your client online. You should consider your client devices performance for this.

- Returns 201 status if the client was set present successfully.
- Returns 403 status if the you have no access to the organization or to the user.

You should store the returned client ID attribute while the client is being used.


### Refresh user client presence

<aside class="info">
You need to frequently tell the server about the presence of your client, otherwise the user will be automatiaclly switched to "not present" and "offline" state.
</aside>

You refresh one of your clients' presence:

`PUT /api/v5/orgs/<organization_id>/users/<user_id>/clients/<client_id>`

The `<client_id>` is the ID returned when first time announcing the client with `POST`.

Again, you must provide a payload object with the `rooms` and `expires_in` attributes, which overwrite any previously set values.

- Returns 201 status if the client with the provided ID was previously expired but is not set again as present.
- Returns 200 status if the client was already present and its presence is now refreshed.
- Returns 403 if the you have no access to the organization or to the user.

### Remove user client presence

Sometimes you might want to "expire" a client immediately, e.g. when a user signs out:

`DELETE /api/v5/orgs/<organization_id>/users/<user_id>/clients/<client_id>`


### Listening presence refresh requests

<aside class="warning">
<strong>TODO:</strong> Describe the channel and the message that the client should listen and then make a user client refresh reqeust.
</aside>


## User preferences

Each user always has a single preferences resource containing private settings conserning the user account. A user prefernces resource has the following attributes.

Attribute       | Type    | Editable  | Default | Description
:---------------|:--------|:----------|---------|------------
`chat_capacity` | integer | **required**  | 5       | An estimate about the maximum number of people the user is willing to chat with simultaneously. The system uses this value in its algorithms to determine how many messages are sent in the name of the user.
`desktop_message_sound` | string  | **required**  | `visitor_message` | Identifier for the message sound used when a visitor sends a message.
`is_desktop_message_sound_continuous` | boolean | **required** | `true` | Whether or not to play the message sound continuously until the user interacts with the UI.
`desktop_visitor_added_sound` | string | **required**  | `visitor_connect` | Identifier for the message sound played when a new visitor becomes present.
`is_desktop_visitor_added_sound_continuous` | boolean | **required** | `true` | Whether or not to play the visitor added sound continuously until the user interacts with the UI.
`ui_language_code` | string | **required** | `en` | Preferred UI Language in ISO 639-1 code.
`is_muted_offline` | boolean | **required** | `false` | Whether or not to disable the sounds while the user is offline.
`is_statistics_email_enabled` | boolean | **required** | `true` | Whether or not to send statistic emails to the user.
`is_desktop_notification_enabled` | boolean | **required** | `false` | Whether or not to use desktop notifcations (if supported by the browser)
`is_spellcheck_enabled` | boolean | **required** | `false` | Whether or not to enable spellchecking when composing messages (if supported by the browser)

<aside class="info">
User preferences are created and deleted with the user. They can only be updated. The preference attributes are initially set to their default values.
</aside>

### Retrieve user preferences

You can get the preferences of the user:

`GET /api/v5/orgs/<organization_id>/users/<user_id>/preferences`


### Update user preferences

You can update *some or all* your preferenes with a `PATCH` request:

`PATCH /api/v5/orgs/<organization_id>/users/<user_id>/preferences`

Any omitted preference attributes are kept in their previous values.

You can also make a `PUT` request, but in this case you need to provide *all* the preference attributes, otherwise a 400 response is returned:

`PUT /api/v5/orgs/<organization_id>/users/<user_id>/preferences`


## Organizations

An organization represents any organization account on giosg system. An organization consists of a number of users with their own user accounts. A user always belongs to exactly one organization.

Please note that despite its name a "organization" in this context means any organization or group. It can even consists of only one user.

An organization object contains the following attributes. Note that the contact information is public.

Attribute | Type | Editable | Description
:---------|:-----|:---------|------------
`id` | [ID][] | read-only | Unique identifier for this organization
`name` | string | **required?** | The name of the organization. Required, if your organization is using Network features, such as [partnerships](#partnership-api) or [sharing](#sharing-api).
`email` | string | **optional** | Contact email address, or `null`
`phone` | string | **optional** | Contact phone number, or `null`
`street` | string | **optional** | Contact street address, or `null`
`postal_code` | string | **optional** | Contact address postal code, or `null`
`city` | string | **optional** | Contact address city, or `null`
`country` | string | **optional** | Country as a two-letter, lowercase ISO 3166-1 code, or `null`
`business_id` | string | **optional** | Business ID of the organization, if any, or `null`
`is_online` | boolean | read-only | Whether any user from the organization is online. See [user clients][user client] for more information.
`is_present` | boolean | read-only | Whether any user from the organization currently present. See [user clients][user client] for more information.
`created_at` | [date/time][] | read-only | When this organization account was created. **Available only for your own organization.**
`updated_at` | [date/time][] | read-only | When organization details were changed last time. **Available only for your own organization.**

### Retrieve organization details
Get a single [organization][] object by its ID.

`GET https://service.giosg.com/api/v5/orgs/<organization_id>`

### Update organization details
You may update some of the attributes a organization, if you have permissions to do so.

`PUT https://service.giosg.com/api/v5/orgs/<organization_id>`

`PATCH https://service.giosg.com/api/v5/orgs/<organization_id>`

When using `PUT` you need to provide an object as a request payload that contains the changed attributes the [organization][]. When using `PATCH`, you may omit those attributes that you do not want to change.

### Channels

Changes to organizations will be broadcasted to following [channels][]:

Channels    | Description
------------|---------------
`/api/v5/orgs/<organization_id>` | Changes to a single organization
