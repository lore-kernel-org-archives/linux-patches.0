Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0C21D5ABA;
	Sat, 14 Feb 2026 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031051; cv=none; b=OsvKstuGZ2qPvyZnK1iTq8OeujZl431E2IooJkMAlMswhmgMGlvc46OmpvEiUh7Io7M5DCMrwDZ+NjNdI/TDR83ANeH9pew5tlBIYCJ3w81PHv9VrZrQGC/6auTo0JcJ4ziSnEa26Ca/VgyogOnkRRWiwTDygPRtHAqz8H7TEQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031051; c=relaxed/simple;
	bh=kTWA4gX1yEijun13zNQWvDhZry+uXNZ6fiz16U9J+uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ap40+WtrmyZ2t56GmUH2KAkVFgDMhoKx+hrQ4JJ/qnGTAF2ABqXrKYka3VjkzDkMVrt41xaZfkDndm5/0FbCEvJ0lutTWk9JXzL6nEmzSa/rha+gsq3WONA2IvIoQVKm12nMLdMG/xeTLx4Inzd51Odpx8M9SLExvCAn0tZzJdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7o3srYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7o3srYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AF5C116C6;
	Sat, 14 Feb 2026 01:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031051;
	bh=kTWA4gX1yEijun13zNQWvDhZry+uXNZ6fiz16U9J+uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7o3srYUBO/Mj36kxeRD0hp7kMiE39U+lCsGbS/TjoBHHmQ0RV0MoZhhWiPn/bgtu
	 wkdm6S3us/zhkt84lgwkUaK9ltOtQDtwM8fipn3dEp5rqMBa1/LgjTcW0qfEThW6ce
	 VIHFX8LwQ9NBbjgtoxNRKHjl8nVYSq0yPrpKau9s0F0i+JqoxVB+Uw7dvWPhE1IsPv
	 sPSTDX0u20Sx0N6AZ1wiVUSNJPMc9nhrbcRpY6gbDeLAvPBTmQ1/Hv5mPWecG1IQjU
	 gCdOHA3hPRtZtYqocmD6QtNx3cyLfrxlTS/6OWXRAClze/KK3nrkxZKHfRbKvpd09q
	 mVsHet6cvqTbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] HID: logitech-hidpp: Add support for Logitech K980
Date: Fri, 13 Feb 2026 19:58:39 -0500
Message-ID: <20260214010245.3671907-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit af4fe07a9d963a72438ade96cf090e84b3399d0c ]

Add support for the solar-charging Logitech K980 keyboard, over
Bluetooth. Bolt traffic doesn't get routed through logitech-dj, so
this code isn't triggered when Bolt is used.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of HID: logitech-hidpp: Add support for Logitech K980

### Commit Message Analysis
The commit adds support for the Logitech K980 (Slim Solar+ keyboard)
over Bluetooth by adding its device ID to the `hidpp_devices` table in
the logitech-hidpp HID driver.

### Code Change Analysis
The change is a **two-line addition** of a new `HID_BLUETOOTH_DEVICE`
entry to the existing `hidpp_devices[]` table:
```c
{ /* Slim Solar+ K980 Keyboard over Bluetooth */
  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
```

This is the textbook definition of a **new device ID addition** to an
existing driver. The driver (`hid-logitech-hidpp`) already exists in all
stable trees, and this just adds a Bluetooth product ID (0xb391) so the
kernel recognizes and properly handles this keyboard.

### Exception Category: New Device ID
This falls squarely into the "NEW DEVICE IDs" exception category for
stable backports:
- The driver already exists in stable trees
- Only a device ID is being added (no new code paths, no new functions)
- It's a trivial two-line addition to an ID table
- It enables an existing, well-tested driver to work with a specific
  piece of hardware

### Risk Assessment
- **Risk: Extremely low.** Adding an entry to a device ID table cannot
  break any existing functionality. The new entry only matches a
  specific Logitech Bluetooth device (vendor 0x046d, product 0xb391). No
  existing device matching is affected.
- **Scope: Minimal.** Two lines added, one file changed.
- **Dependencies: None.** This is completely self-contained.

### User Impact
Without this patch, users of the Logitech K980 keyboard over Bluetooth
won't get the hidpp driver's features (which for a solar keyboard
includes battery/charging status reporting). With this patch, the
keyboard is properly recognized and handled by the specialized Logitech
HID++ driver.

### Stability Considerations
- The commit was reviewed and applied by the HID subsystem maintainer
  (Jiri Kosina)
- The pattern is identical to dozens of other device ID entries in the
  same table
- Zero chance of regression for existing users

### Conclusion
This is a classic device ID addition — one of the most common and safest
types of stable backports. It enables hardware support for a specific
Logitech keyboard with zero risk to existing functionality. It meets all
stable criteria: obviously correct, small, tested, and fixes a real
issue (device not working with the appropriate driver).

**YES**

 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index e871f1729d4b3..ca96102121b85 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4666,6 +4666,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb037) },
 	{ /* MX Anywhere 3SB mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
+	{ /* Slim Solar+ K980 Keyboard over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
 	{}
 };
 
-- 
2.51.0

