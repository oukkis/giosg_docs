Partnership API
===============

## Outgoing partnership invitations

You may build your giosg NETWORK by inviting them. This is done with invitation objects. When sending and managing invitations from your organization account to your partners, we use **outgoing invitations**. An outgoing invitation object has the following attributes:

Attribute | Type | Editable | Description
:---------|:-----|:---------|------------
`id` | [ID][] | read-only | Unique identifier of this invitation
`status` | integer | read-only | Status of the invitation, with the following possible values: `0`= Pending, `1`= Accepted by the received, `2`= Rejected by the received
`email` | string | **required** | A valid email address to which the invitation will be sent. Must be set on creation and cannot be changed later.
`message` | string | **optional** | Message to be sent with the invitation to your partner. May only be set on creation.
`partner_display_name` | string | **optional** | A display name that will be set to the new partner when they accept the invitation and the partnership is created. The display name is visible to your organization members. May be `null`, in which case the partner will be shown with their original name.
`partner_visibility` | string | **required** | This must be either `organization` (the partner will become visible to all your organization members) or `management` (visible only to your organization managers)
`room_shares` | array of objects | **optional** | You may **share rooms** to your partner when they accept your invitation. This should be an array of objects similar to [outgoing room share][] objects. On creation, the objects may contain attributes `room_id` and `share_name`. In responses these objects contain the attributes `room_id`, `room`, and `share_name`.
`team_shares` | array of objects | **optional** | You may **share teams** to your partner when they accept your invitation. This should be an array of objects similar to [outgoing team share][] objects. On creation, the objects may contain attributes `team_id` and `share_name`. In responses these objects contain the attributes `team_id`, `team`, and `share_name`.
`created_at` | [date/time][] | read-only | When this invitation was sent
`created_by_organization_id` | [ID][] | read-only | ID of the organization who sent this invitation
`created_by_organization` | object | read-only | The [organization][] resource who sent this invitation, with all of its attributes.
`created_by_user_id` | [ID][] | read-only | ID of the user who sent this invitation
`created_by_user` | object | read-only | The [user][] resource who sent this invitation, with all other attributes except `organization` and `organization_id`
`resolved_at` | [date/time][] | read-only | When this invitation was accepted or rejected, `null` if still pending
`resolved_by_organization_id` | [ID][] | read-only | ID of the organization who accepted/rejected this invitation, or `null` if still pending or unknown
`resolved_by_organization` | object | read-only | The [organization][] resource who accepted/rejected this invitation, or `null` if still pending or unknown
`resolved_by_user_id` | [ID][] | read-only | ID of the user who accepted/rejected this invitation, or `null` if still pending or unknown
`resolved_by_user` | object | read-only | The [user][] who accepted/rejected this invitation, or `null` if still pending or unknown
`partnership_id` | [ID][] | read-only | ID of the [partnership][] of the partner who accepted this invitation, or `null` if not accepted
`created_new_partnership` | boolean | read-only | This is `true` if the invitation was accepted by a new partner, `false` if it was accepted by an existing partner, or `null` if not yet accepted.

If your invitation is accepted by an existing partner, then any shared teams or rooms are added to that partner. No existing shares are removed in this case.

### Send an invitation
You may send an invitation to your partner's email address by creating a new [outgoing invitation][] object.

`POST https://service.giosg.com/api/v5/outgoing_invitations`

### Cancel an outgoing invitation
You may cancel a partnership invitation before it is accepted or rejected, by a given ID.

`DELETE https://service.giosg.com/api/v5/outgoing_invitations/<invitation_id>`

The endpoint returns a 404 status code if the invitation is not found or if you are not authenticated as the sender of this invitation or if the invitation has already been cancelled.

The endpoint returns a 403 status code if the invitation has already been accepted or rejected.

### Retrieve outgoing invitation details
Get a single [outgoing invitation][] object sent by your organization, by a given ID.

`GET https://service.giosg.com/api/v5/outgoing_invitations/<invitation_id>`

### Get a collection of outgoing invitations
Get a [paginated collection][] of all sent [outgoing invitation][] objects.

`GET https://service.giosg.com/api/v5/outgoing_invitations`

This endpoint accepts the following GET parameters.

Parameter | Type | Default | Description
----------|------|---------|------------
`ordering` | [ordering][] | `created_at` | Ordering of results with options `created_at` or `-created_at`
`status` | integer | (none) | Filter the results by the `status` attribute

## Incoming partnership invitations

When you are a receiving party of a partnership invitation then you handle the invitation objects as **incoming partnership invitations**. An incoming invitation has the following attributes:

Attribute | Type | Editable | Description
:---------|:-----|:---------|------------
`key` | string | read-only | Unique key for this invitation. You need to use this to identify *incoming* invitations.
`id` | [ID][] | read-only | Unique identifier of this invitation
`status` | integer | read-only | Status of the invitation, with the following possible values: `0`= Pending, `1`= Accepted by the received, `2`= Rejected by the received
`email` | string | read-only | The email address to which this invitation was sent
`message` | string | read-only | Message to be sent with the invitation to your partner.
`room_shares` | array of objects | read-only | The rooms that will be shared when the invitation is accepted. An array where each item has the following attributes of an [incoming room share][] objects: `room_id` and `room`
`team_shares` | array of objects | read-only | The teams that will be shared when the invitation is accepted. An array where each item has the following attributes of an [incoming team share][] object: `team_id` and `team`
`created_at` | [date/time][] | read-only | When this invitation was sent
`created_by_organization_id` | [ID][] | read-only | ID of the organization who sent this invitation
`created_by_organization` | object | read-only | The [organization][] who sent this invitation, with all of its attributes.
`created_by_user_id` | [ID][] | read-only | ID of the user who sent this invitation
`created_by_user` | object | read-only | The [user][] who sent this invitation, with all other attributes except `organization` and `organization_id`
`resolved_at` | [date/time][] | read-only | When this invitation was accepted or rejected, `null` if still pending
`resolved_by_organization_id` | [ID][] | read-only | ID of the organization who accepted/rejected this invitation, or `null` if still pending or unknown
`resolved_by_organization` | object | read-only | The [organization][] resource who accepted/rejected this invitation, or `null` if still pending or unknown
`resolved_by_user_id` | [ID][] | read-only | ID of the user who accepted/rejected this invitation, or `null` if still pending or unknown
`resolved_by_user` | object | read-only | The [user][] who accepted/rejected this invitation, or `null` if still pending or unknown

### Retrieve incoming invitation details
Retrieve a [incoming invitation][] resource by its **invitation key**. Incoming invitations are identified by their automatically generated, random key strings, instead of integer IDs.

`GET https://service.giosg.com/api/v5/incoming_invitations/<invitation_key>`

### Get a collection of incoming invitations
Get a [paginated collection][] of all received [incoming invitation][] objects. This endpoint returns invitations accepted or rejected by your organization. It also returns those invitations that are sent to one of your organization's email address. **NOTE** that the organization who sends the invitation does not know if this email address actually exists in giosg system.

`GET https://service.giosg.com/api/v5/incoming_invitations`

This endpoint accepts the following GET parameters.

Parameter | Type | Default | Description
----------|------|---------|------------
`ordering` | [ordering][] | `created_at` | Ordering of results with options `created_at`, `-created_at`
`status` | integer | (none) | Filter the results by the `status` attribute

### Accept an incoming invitation
You need to accept an invitation to become partners with the sender. In order to accept the invitation, you need the invitation key.

`POST https://service.giosg.com/api/v5/incoming_invitations/<invitation_key>/accept`

As soon as you accept the invitation, the partnership will be created. Also, any shared rooms and teams will become available to your organization.

You should send an object as a payload with the following attributes, matching the attributes on a [partnership][] resource. They may be omitted, see below.

Attribute | Type | Editable | Description
----------|------|----------|------------
`display_name` | string | **optional** | A display name that will be set to the newly created partner. The display name is visible to your organization members. May be `null`, in which case the partner will be shown with their original name.
`visibility` | string | **required** | This must be either `organization` (the partner will become visible to all your organization members) or `management` (visible only to your organization managers)

It is possible to accept an invitation from an existing partner. In this case, no new partnership is created. The `display_name` and `visibility` will overwrite the corresponding attributes of the existing [partnership][] resource, **unless they are omitted**, in which case the old values are preserved.

If you are accepting the invitation with [shared rooms][incoming room share] or [teams][incoming team share] from an existing partner, then the rooms and teams will become available to you.

After accepting an invitation, its status will become `1`.

The request will result in 404 response if the invitation was not found, has been cancelled, or has already been accepted/rejected by some other organization. The request will result in 403 response if the invitation has already been accepted or rejected by your organization, or if you are not allowed to accept/reject the invitation, e.g. you are the original creator of this invitation.

A successful response will result in the updated [incoming invitation][] resource.

### Reject an invitation
You may reject an invitation by its invitation key.

`POST https://service.giosg.com/api/v5/incoming_invitations/<invitation_key>/reject`

No request payload is required. After rejecting an invitation, its status will become `2`.

The request will result in 404 response if the invitation was not found, has been cancelled, or has already been accepted/rejected by some other organization. The request will result in 403 response if the invitation has already been accepted or rejected by your organization, or if you are not allowed to accept/reject the invitation, e.g. you are the original creator of this invitation.

A successful response will result in the updated [incoming invitation][] resource.

## Partnerships

A partnership object describes a connection between your organization and one of your partner organizations. Partnerships can only be created with [partnership invitation][outgoing invitation] resources.

Attribute | Type | Editable | Description
:---------|:-----|:---------|------------
`partner_organization_id` | [ID][] | read-only | ID of the partner organization
`partner_organization` | object | read-only | The partner [organization][] resource, with all of its available attributes
`organization_id` | [ID][] | read-only | ID of your organization, for convenience (matching the `<organization_id>` in the URL)
`dislay_name` | string | **optional** | Name that is shown to your organization members for this partner. May be `null`, in which case the original name is shown
`visibility` | string | **required** | If `organization` then the partner is visible to all your organization members. If `management`, it is visible only to your organization managers
`created_at` | [date/time][] | read-only | When you became partners

### Get a collection of partnerships
Get a [paginated collection][] of all the known partnerships.

`GET https://service.giosg.com/api/v5/orgs/<organization_id>/partnerships`

This end-point accepts the following GET parameters.

Parameter | Type | Default | Description
----------|------|---------|------------
`ordering` | [ordering][] | `created_at` | Ordering of results with options `created_at` and `-created_at`

### Retrieve partnership details
Retrieve a single [partnership][] resource for your organization (`<organization_id>`) by the partner organization's ID (`<partner_organization_id>`).

`GET https://service.giosg.com/api/v5/orgs/<organization_id>/partnerships/<partner_organization_id>`

### Remove a partnership

<aside class="warning">
<strong>WARNING!</strong>
This will immediately remove the organization from your partners and remove your partner's access to your shared resources. You cannot undo this action! You need to invite your partner again and re-share all your rooms/teams and re-set any permissions.
</aside>

Being aware of this, you may remove another organization (`<partner_organization_id>`) from your organization's (`<organization_id>`) partners.

`DELETE https://service.giosg.com/api/v5/orgs/<organization_id>/partnerships/<partner_organization_id>`


### Update a partnership
You may update the editable attributes of a partnership for your organization (`<organization_id>`) by the given partner organization's ID (`<partner_organization_id>`).

`PUT https://service.giosg.com/api/v5/orgs/<organization_id>/partnerships/<partner_organization_id>`

`PATCH https://service.giosg.com/api/v5/orgs/<organization_id>/partnerships/<partner_organization_id>`

When using `PUT` you need to provide an object as a request payload that contains the changed attributes of the [partnership][]. When using `PATCH`, you may omit those attributes that you do not want to change.
