Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB67D2DC350;
	Mon, 12 Jan 2026 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229931; cv=none; b=NhtlSTYGtLfHuX5J6nQxjgk6AozzLHo56B8rxfSfQPkgj/8CR1tp3tPewrwndFT4FuEYRPVj0QhyF6YBe7MSYC84Irp18y/vJpMjA4CEokfsMI6c8PAdBBjXZN5eBDrJJ4+L3Nh37x4276CnARgZ32uL2ySxHNtmmoQQsdqXukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229931; c=relaxed/simple;
	bh=bx4wf6AN3E67U2DceUgAupNZMhxJl5I2M+lQOV1EcYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3AV8111FwZJXRer2YiMSwhf1Xt3lwyg6DuKAILHQAoCp7DkwICqPL5JsvyvhrNtDAMKGtEJyxoFj6YPp/TyiwXKsDavlrih5x9wfiX76dNrOT1S5TsSHup6O94QpLQit5J+vfIUOJ62x9RTqKNV9tW3FkDq9Mba8H84QSrPUqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEGs5VTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEGs5VTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC53C19422;
	Mon, 12 Jan 2026 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768229930;
	bh=bx4wf6AN3E67U2DceUgAupNZMhxJl5I2M+lQOV1EcYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEGs5VTcjvoKMV4Og9DAK75hlV3WtdcMNewcllUDK9UBr9U0x47Ent49pp4OVJDBE
	 ViVVrXWExXqhblVmz1sirB9/6GGetnWcFtUocgF2w3OFbMAMdGt9P66eMBvxEPLIUw
	 XU05l78QVrYEGPPLWeJ+hI3E9WxTgDxLr/jgC6Iwu3OKuCYI5uGDO2hBATwkEVKBJK
	 iTaoPSD1oF11rYZYi7S3m1JAWm4nh+MN47toqP4kZ4g/Y/TuNavZ4p4OZDW/e8ZOyF
	 WyKy4gmTOKFCJ6JVjjScsZofbjnqARltUn06Gh+FyBNl9UVCY+LQ/mhD0mP2rqZZGw
	 Gbft9iyKgYKGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	andriy.shevchenko@intel.com
Subject: [PATCH AUTOSEL 6.18-6.1] HID: intel-ish-hid: Update ishtp bus match to support device ID table
Date: Mon, 12 Jan 2026 09:58:08 -0500
Message-ID: <20260112145840.724774-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112145840.724774-1-sashal@kernel.org>
References: <20260112145840.724774-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.5
Content-Transfer-Encoding: 8bit

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit daeed86b686855adda79f13729e0c9b0530990be ]

The ishtp_cl_bus_match() function previously only checked the first entry
in the driver's device ID table. Update it to iterate over the entire
table, allowing proper matching for drivers with multiple supported
protocol GUIDs.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: HID: intel-ish-hid: Update ishtp bus match to
support device ID table

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes:
- **The problem**: The `ishtp_cl_bus_match()` function only checked the
  first entry (`id[0]`) in the driver's device ID table
- **The fix**: Iterate over the entire ID table
- **The purpose**: Allow proper matching for drivers with multiple
  supported protocol GUIDs

No "Fixes:" tag or "Reported-by:" tag is present (expected for commits
under manual review).

### 2. CODE CHANGE ANALYSIS

**Before (buggy code):**
```c
return(device->fw_client ? guid_equal(&driver->id[0].guid,
       &device->fw_client->props.protocol_name) : 0);
```
Only checks the **first entry** (`driver->id[0]`) in the device ID
table.

**After (fixed code):**
```c
if (client) {
    for (id = driver->id; !guid_is_null(&id->guid); id++) {
        if (guid_equal(&id->guid, &client->props.protocol_name))
            return 1;
    }
}
return 0;
```
Properly iterates through **all entries** until finding a match or
hitting the null GUID terminator.

**Root cause**: Logic error - incomplete iteration through device ID
table. This is objectively incorrect behavior for a bus match function.
Standard Linux bus matching iterates through all device IDs in a
driver's table.

**Technical mechanism**: When a device with a protocol GUID that matches
the 2nd, 3rd, or later entry in a driver's ID table is enumerated, the
old code would fail to match, leaving the device without a driver.

### 3. CLASSIFICATION

- **Bug fix**: Yes - this fixes fundamentally broken device matching
  logic
- **New feature**: No - it corrects existing functionality to work as
  designed
- **Exception category**: Not needed - it's a straightforward bug fix

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~10 lines of actual code
- **Files touched**: 1 (drivers/hid/intel-ish-hid/ishtp/bus.c)
- **Complexity**: Low - simple loop structure following standard
  patterns
- **Subsystem**: Intel ISH (Integrated Sensor Hub) HID driver
- **Risk**: Very low - if wrong, devices wouldn't match (no
  crashes/corruption)

The change follows the standard Linux bus matching pattern used across
the kernel (iterate until null terminator).

### 5. USER IMPACT

- **Affected users**: Intel ISH users with drivers supporting multiple
  protocol GUIDs
- **Severity**: Medium - affected devices simply wouldn't work (wouldn't
  bind to their driver)
- **Real bug**: Yes - the code was objectively wrong

### 6. STABILITY INDICATORS

- **Acked-by**: Srinivas Pandruvada (Intel ISH maintainer)
- **Signed-off-by**: Benjamin Tissoires (HID subsystem maintainer)
- Pattern follows well-established Linux driver matching conventions

### 7. DEPENDENCY CHECK

- Self-contained, no dependencies on other commits
- The `ishtp_cl_bus_match()` function exists in stable trees
- No new APIs or infrastructure required

### RISK VS BENEFIT TRADE-OFF

**Benefits:**
- Fixes obviously incorrect code in bus matching
- Enables proper device/driver matching for drivers with multiple IDs
- Small, surgical, low-risk change
- Follows standard kernel patterns

**Risks:**
- Minimal - only affects ISH device matching
- Failure mode is "device doesn't match" not crash/corruption

**Concerns:**
- No explicit bug report showing users hitting this
- Could be seen as enabling new functionality if no drivers currently
  use multiple IDs

### CONCLUSION

This commit fixes objectively incorrect behavior in the ISHTP bus
matching function. The old code only checking `id[0]` is clearly wrong
for a device ID table that's designed to hold multiple entries. The fix
is small, surgical, follows standard kernel patterns, and has low risk.
Even without an explicit user report, fixing fundamentally broken
matching logic is appropriate for stable trees. The change is acked by
the Intel maintainer and the HID subsystem maintainer.

The fix is self-contained, doesn't introduce new APIs, and corrects a
logic error that would prevent devices from working if their GUID wasn't
first in the table.

**YES**

 drivers/hid/intel-ish-hid/ishtp/bus.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index 93a0432e70581..8e9f5a28e62ec 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -240,9 +240,17 @@ static int ishtp_cl_bus_match(struct device *dev, const struct device_driver *dr
 {
 	struct ishtp_cl_device *device = to_ishtp_cl_device(dev);
 	struct ishtp_cl_driver *driver = to_ishtp_cl_driver(drv);
+	struct ishtp_fw_client *client = device->fw_client;
+	const struct ishtp_device_id *id;
 
-	return(device->fw_client ? guid_equal(&driver->id[0].guid,
-	       &device->fw_client->props.protocol_name) : 0);
+	if (client) {
+		for (id = driver->id; !guid_is_null(&id->guid); id++) {
+			if (guid_equal(&id->guid, &client->props.protocol_name))
+				return 1;
+		}
+	}
+
+	return 0;
 }
 
 /**
-- 
2.51.0

