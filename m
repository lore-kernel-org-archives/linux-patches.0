Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAD72472B7;
	Tue,  5 Aug 2025 13:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399537; cv=none; b=OVcaPIduiRRvv7PXo5QLBbpkMquzDvCNyCL+wTFzXqspglk5h/kTD6N8BGRtVxU8Nkmsz9w7tYq2gJ8VMQ1seEYH+8bWLO3CpHsrsYRxAq0mM6842DqeZnOOHjCBCO2r9K3jFankgPMUvHq4mVvWHrcKnOg0HEZ/G9xMTSTW86A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399537; c=relaxed/simple;
	bh=NUDxVI/ISSo7xW/2JfZ2/zNDbv9vF3Z/iUsO8DaozCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OHoFd2FGkFdMWrbXEdNuN1bBOZBK1zItX57YlJ2zZDORjfLrQI0oRUvvEer/JiuEZQHKDYFhdzTZrQEK5NSphEu8JMK20CKhY8EIdHDwtCJ/IwkD7CRepYBWzK/t9gLHZ5lDTAXCInUfJhevnthH3xuX7EKQEkeL1MTonjjp620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoCxYMiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoCxYMiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C4CC4CEF0;
	Tue,  5 Aug 2025 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399537;
	bh=NUDxVI/ISSo7xW/2JfZ2/zNDbv9vF3Z/iUsO8DaozCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoCxYMiFUTi5Ova91KVzRECPSwaBuHyuTITkDI71QBTDcvj3nAU4qLsahtD5dyvLr
	 fB8z94SMCjbQ/aCDEDp5doQCC3R6Kwm99G/C535pK1x+gHVZSSdkjKfKavoyqmpe6v
	 BLrMeGPkuvMo/55g4JBzXQ0nTbSMxsPzuOJGeUVfnJU0TZFKrzuBZjIebdLD5yLg00
	 KlsIB8a5LL6MTyc7+9EMmu99IlV7I9Lm54WeN6FzZ4po1jEGhFF8tssuUf2eHmQeIE
	 0goiE6iWRHfy2o3E2upUi1ehq/0V8FhHVq4lZufX0PyEjpwHeQE14ThT/T7faatwFO
	 GuXNzWBPg5diw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	hansg@kernel.org,
	ribalda@chromium.org,
	mchehab+huawei@kernel.org,
	dongcheng.yan@intel.com,
	peterz@infradead.org
Subject: [PATCH AUTOSEL 6.16-6.12] media: ipu-bridge: Add _HID for OV5670
Date: Tue,  5 Aug 2025 09:09:40 -0400
Message-Id: <20250805130945.471732-65-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit 484f8bec3ddb453321ef0b8621c25de6ce3d0302 ]

The OV5670 is found on Dell 7212 tablets paired with an IPU3 ISP
and needs to be connected by the ipu-bridge. Add it to the list
of supported devices.

Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my determination:

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Hardware Enablement Fix**
The commit adds missing ACPI HID (`INT3479`) for the OV5670 sensor to
the IPU bridge supported sensors list. This is a clear hardware
enablement fix that makes the Dell 7212 tablet's camera functional.
Without this entry, the OV5670 sensor on these tablets would not be
properly connected through the IPU bridge, rendering the camera non-
functional.

### 2. **Simple and Contained Change**
The code change is minimal and low-risk:
- It adds exactly one line to a static array:
  `IPU_SENSOR_CONFIG("INT3479", 1, 422400000)`
- The change follows the existing pattern in the array
- It maintains the alphabetical sorting as required by the comment
  ("Please keep the list sorted by ACPI HID")
- The position between `INT3474` and `INT347A` is correct alphabetically

### 3. **Existing Driver Support**
The OV5670 sensor driver already exists in the kernel
(`drivers/media/i2c/ov5670.c`) and already recognizes the `INT3479` ACPI
HID, as evidenced by:
```c
static const struct acpi_device_id ov5670_acpi_ids[] = {
    { "INT3479" },
    { /* sentinel */ }
};
```
This means the sensor driver is ready, but the IPU bridge was missing
the connection configuration.

### 4. **Pattern of Similar Fixes**
Looking at the commit history of `ipu-bridge.c`, there's a clear pattern
of adding sensor HIDs as hardware enablement fixes:
- `ec86a04bedb1` added ov01a10 for Dell XPS 9315
- `0065b9374633` added GalaxyCore GC0310
- `440de616e76e` added HIDs from out-of-tree IPU6 driver

These types of commits are typically backported as they fix broken
hardware functionality.

### 5. **No Architectural Changes**
The commit:
- Does not introduce new features
- Does not change any APIs or interfaces
- Does not modify existing functionality
- Simply adds configuration data to enable already-supported hardware

### 6. **User Impact**
Without this fix, users with Dell 7212 tablets running stable kernels
would have non-functional cameras, which is a significant usability
issue. The fix enables basic hardware functionality that users expect to
work.

### 7. **Minimal Risk**
The change cannot cause regressions for existing hardware because:
- It only adds a new entry to the array
- The entry is only used when matching the specific `INT3479` HID
- If the hardware isn't present, the entry is simply ignored
- The link frequency value (422400000) appears reasonable compared to
  other OV sensors

This is exactly the type of commit that stable kernel rules encourage: a
small, contained fix that enables broken hardware without risk of
regression.

 drivers/media/pci/intel/ipu-bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/intel/ipu-bridge.c b/drivers/media/pci/intel/ipu-bridge.c
index 83e682e1a4b7..73560c2c67c1 100644
--- a/drivers/media/pci/intel/ipu-bridge.c
+++ b/drivers/media/pci/intel/ipu-bridge.c
@@ -60,6 +60,8 @@ static const struct ipu_sensor_config ipu_supported_sensors[] = {
 	IPU_SENSOR_CONFIG("INT33BE", 1, 419200000),
 	/* Omnivision OV2740 */
 	IPU_SENSOR_CONFIG("INT3474", 1, 180000000),
+	/* Omnivision OV5670 */
+	IPU_SENSOR_CONFIG("INT3479", 1, 422400000),
 	/* Omnivision OV8865 */
 	IPU_SENSOR_CONFIG("INT347A", 1, 360000000),
 	/* Omnivision OV7251 */
-- 
2.39.5

