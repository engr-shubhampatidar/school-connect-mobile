# Leave Management API (UI-aligned)

Base URL: `https://school-connect-mgmt-backend.vercel.app/api`

Headers (all endpoints):

- `Authorization: Bearer <token>` (required)
- `Content-Type: application/json`

Note: this document uses camelCase keys to match the `NewLeaveManagementScreen` UI
and the app models (`_LeaveRequest`, `_StudentRequest`). If your backend returns
snake_case keys, use `ApiMappers.normalize(json)` from `api_keys.dart` to convert.

1. GET /leaves

- Purpose: Fetch current user's leaves (history/summary)
- Response (example):

```
{
	"leaves": [
		{
			"id": "abc123",
			"dateRange": "Oct 12 - Oct 14, 2023",
			"type": "Casual Leave",
			"appliedDate": "Oct 05",
			"reason": "Family function attendance",
			"status": "approved"
		}
	]
}
```

2. GET /requests

- Purpose: Fetch student leave requests (for teacher/admin)
- Response (example):

```
{
	"requests": [
		{
			"id": "req1",
			"name": "Marcus Thompson",
			"gradeRoll": "Grade 10 - B • Roll #42",
			"dateRange": "Oct 24 - Oct 25",
			"leaveType": "Sick Leave",
			"reason": "High fever...",
			"status": "pending"
		}
	]
}
```

3. POST /leaves

- Purpose: Submit a new leave request (user)
- Body (example):

```
{
	"startDate": "2023-10-12",
	"endDate": "2023-10-14",
	"type": "Casual Leave",
	"reason": "Family function attendance"
}
```

4. PATCH /requests/{id}

- Purpose: Approve or reject a student request (teacher/admin)
- Body (example):

```
{
	"status": "approved"  // or "rejected"
}
```

Keys: use `ApiKeys` from `lib/constants/api_keys.dart` for field names and `ApiStatus` for status values.
