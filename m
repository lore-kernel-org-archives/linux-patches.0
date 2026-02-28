Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE72340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301059; cv=none; b=QA/0Y2Gu+sewXkNPiBjpyO7+0NvbEzD4XpkLP0+jedYTD4AD+NbjMFnus9Xap7b0Fa5M5z+9ZcnPoVW8XSaH3PbsReSmeA58is7wExK9P4oZgJHjKO+mKF8Bq70mybmj/VoXnD/NZXq5vy94e/Pduigv0d7IMfDJqsK2Ld5VSx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301059; c=relaxed/simple;
	bh=jKgCr0GAHW1qTym+61T91FFjvE2xRBzxxMtIV3wVZ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEG4GZ2tMpP5UTbSNkGpLv6CJQoTduJkVARFXqDQbRBp8aKd45uUwON2lWxlbcDEaXOOrh1yDU5u3EKVzdp8FPhOzjw3F+NkcSjHnfEYAXyX7i0S/xMmPt4pEh3+lm7i5xBPZZcegVA3nrHeCocQeIO4t82the8j+t8sSvpfBbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBQu7E1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBQu7E1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE3DC19423;
	Sat, 28 Feb 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301059;
	bh=jKgCr0GAHW1qTym+61T91FFjvE2xRBzxxMtIV3wVZ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBQu7E1ygkouCr+ux991lvRRFjaUJ9cRHzEEdOIRTxPb7ipFtoV+NWaoMEiGOKE4W
	 o20XJVL595Nyp2YJCFEL44PHG3HCUvHRtmwyOpjDmh/kwmRoTT+rIeOXTjjf1y/by2
	 BKzBd+JLNM1V8kNc2WmHs9wkUQaodYZKlaJ/IQbOiA4qERWR9b3ToXni7RXb7/tuKJ
	 czxYTbHz1QwG7L2iGBxKix/GyLm6wjij/r+NvzGPCboXGDW/1NdMD0K7Sq1wafzc09
	 iGxFhjWOaj+F4wzZjqmX1b/VELiFBnzoAB6LGYJ0PnrQwlAz9JOmx2YaMWdsjrUymk
	 lTtQMcBkBA5Xw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 201/752] HID: logitech-hidpp: Add support for Logitech K980
Date: Sat, 28 Feb 2026 12:38:32 -0500
Message-ID: <20260228174750.1542406-201-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 9b612f62d0fba..d117cf0b6de04 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4665,6 +4665,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb037) },
 	{ /* MX Anywhere 3SB mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb038) },
+	{ /* Slim Solar+ K980 Keyboard over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb391) },
 	{}
 };
 
-- 
2.51.0

