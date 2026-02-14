Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A913115A1;
	Sat, 14 Feb 2026 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104359; cv=none; b=pOk2ho6p4U94Qpoy2VLiayPumPElBL9ODEUSvr70MnVXicLqUSznmXcjz+YLiuDfJqIRyDq61Qj/wuwfD+yUlvDA7zQlYXRXH4CasNmivkrIRKk7c/Flf1CvERD/uueQWVyXYZRaXhEO5p7CcbYVoWfhsKnNJXHcL0Vk02OIzYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104359; c=relaxed/simple;
	bh=zmXNR+SoQG64hQCVZ+q10o3m1kyeY4kDeEJbkisVVWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l5ONuu1y8pgxxnc0pnDjfrXzJWhu7GgycwvFUDWjWuAorV5uRHftsv7GaSSIDpdaBU8wFfyESG72ur5fUOkFHr77Ux1D5GPfSd1x5SQdBg6xxCZn6APxiIfrUz5mgy3Ii+3SrV3NafseKBj5ILz4WHSfC0yNKNz7OuI7ZgrHoOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnbjvOn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnbjvOn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975AAC16AAE;
	Sat, 14 Feb 2026 21:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104359;
	bh=zmXNR+SoQG64hQCVZ+q10o3m1kyeY4kDeEJbkisVVWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnbjvOn3LrYSEfjwPaCnTSLzBFvqg19Qvp7jT/ptYsEvdcTCzLvkkcMdLc6+Ykr3p
	 SbfXiOBIss9I0dEasc1jt2/jMsqQGyQzzkvpHmqFRjpDjw5Q6zFZtB/WfUKCdWkkMz
	 2b/Mhx2mZauIBw8/K21JStnheahSpn9Fn3+14FQGWOC7CbgDtNRP7bASunOKh59D2u
	 DhtDWYGOnji5UjfVagAOTUyEkHSwoW1+bNy39n/CwGdMpxLJB1P2w6DUJPR9f59fNb
	 DTf3znugSEBDHysgF6Kd9OGrVxbRkh1ngXBXW3nPaloSm9565A6VsR3Klk3YuXI5w5
	 aJ/wOBDUIBZGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Techie Ernie <techieernie@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] Bluetooth: btusb: Add USB ID 0489:e112 for Realtek 8851BE
Date: Sat, 14 Feb 2026 16:23:04 -0500
Message-ID: <20260214212452.782265-39-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
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

From: Techie Ernie <techieernie@gmail.com>

[ Upstream commit e07094a51ad8faf98ea64320799ce550828e97cd ]

Add USB ID 0489:e112 for the Realtek 8851BE Bluetooth adapter.
Without this entry, the device is not handled correctly by btusb and Bluetooth fails to initialise.
Adding the ID enables proper Realtek initialization for Bluetooth to work on various motherboards using this Bluetooth adapter.

The device identifies as:
  Bus 001 Device XXX: ID 0489:e112 Foxconn / Hon Hai Bluetooth Radio

Tested on Realtek 8851BE. Bluetooth works after this change is made.

Signed-off-by: Techie Ernie <techieernie@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: Bluetooth: btusb: Add USB ID 0489:e112 for Realtek 8851BE

### Commit Message Analysis
The commit adds a new USB device ID (0489:e112, Foxconn/Hon Hai) for the
Realtek 8851BE Bluetooth adapter to the btusb driver's quirks table. The
commit message clearly states that without this entry, "Bluetooth fails
to initialise" — the device simply doesn't work. The author tested it
and confirmed Bluetooth works after the change.

### Code Change Analysis
The change is a **two-line addition** to the `quirks_table[]` array in
`drivers/bluetooth/btusb.c`:

```c
{ USB_DEVICE(0x0489, 0xe112), .driver_info = BTUSB_REALTEK |
                                             BTUSB_WIDEBAND_SPEECH },
```

This is placed in the "Realtek 8851BE Bluetooth devices" section
alongside other existing 8851BE entries (0x0bda:0xb850, 0x13d3:0x3600,
0x13d3:0x3601). The flags used (`BTUSB_REALTEK | BTUSB_WIDEBAND_SPEECH`)
are consistent with nearly all other Realtek entries in this table, so
this is well-established pattern.

### Classification: New Device ID Addition
This falls squarely into the **"New Device IDs"** exception category for
stable backports. This is one of the most common and safest types of
stable patches:
- The btusb driver already exists in all stable trees
- The Realtek initialization path already exists
- Only a new USB vendor/product ID pair is being added to route a
  specific hardware variant through the correct initialization

### Scope and Risk Assessment
- **Lines changed**: 2 lines added (trivially small)
- **Files touched**: 1 file (`drivers/bluetooth/btusb.c`)
- **Risk**: Essentially zero. This only affects systems with USB device
  0489:e112 plugged in. It cannot regress any other hardware.
- **Complexity**: None — it's a table entry addition following an
  established pattern

### User Impact
- **Who is affected**: Users with motherboards that have the Foxconn/Hon
  Hai variant of the Realtek 8851BE Bluetooth adapter
- **Severity without the fix**: Complete Bluetooth failure — the device
  doesn't initialize at all
- **Benefit**: Bluetooth works properly on affected hardware

### Stability Indicators
- Tested by the author on the actual hardware
- Accepted by the Bluetooth subsystem maintainer (Luiz Augusto von
  Dentz)
- Follows the exact same pattern as dozens of other device ID entries in
  the same table

### Dependency Check
No dependencies. This is a self-contained table entry addition.

### Conclusion
This is a textbook stable backport candidate: a trivial device ID
addition to an existing driver that enables hardware that otherwise
doesn't work at all. It's obviously correct, fixes a real problem
(Bluetooth completely broken), is tiny in scope, and carries virtually
no regression risk.

**YES**

 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 646de80c7e7be..de9e484efef71 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -521,6 +521,8 @@ static const struct usb_device_id quirks_table[] = {
 	{ USB_DEVICE(0x0bda, 0xb850), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3600), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3601), .driver_info = BTUSB_REALTEK },
+	{ USB_DEVICE(0x0489, 0xe112), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8851BU Bluetooth devices */
 	{ USB_DEVICE(0x3625, 0x010b), .driver_info = BTUSB_REALTEK |
-- 
2.51.0

