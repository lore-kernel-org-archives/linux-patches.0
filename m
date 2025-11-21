Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FF8275B18;
	Fri, 21 Nov 2025 13:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730949; cv=none; b=Bitg6LcyUDKdDFr8e3/6CUQF3D1+cXP3K7G8MmRLajHSJ3/FCLMM5rmdHvaq4ENmHYABXYl3sFA47BFMukoos4fG7DtNuBmwqyAX40rT1NQWGHYrcJcukDtVzrdvF3MJP0CmnvJPCWavaVNloEhfrrQWqs/N7ZNDVrxQB1eKeIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730949; c=relaxed/simple;
	bh=s/DNfGB/gGh9UmMy/EbAcAbeMeWtdzjMu2QQjLn3/tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPFKIaFypLXyM8i/oC/KxLQ02bow4lChdd4/NxJmIuuMaw1MqXEpE0FPSNfgj0DgQke9iPViyo+6IObZSZRkgTEenCDi/bpTv1VmU2YAR6okrg6GODJ0FIDXjBIP7T1I3HszjOPIZFdY7GyHFJIm/F40uuznhgeceQzy0Rvp/64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idtiaAVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idtiaAVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9D9C4CEF1;
	Fri, 21 Nov 2025 13:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730947;
	bh=s/DNfGB/gGh9UmMy/EbAcAbeMeWtdzjMu2QQjLn3/tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idtiaAVED8m8w3gKsxzdzhPLHnDpoTSdPbs5wSsZoOv0sdDJjsTVhM9qxzMsfE8RQ
	 B3zLLKRHsMUWM/JAn30UZCsiniBG2OOy5XH7hR00cNoVeQCeJAZg5if6whLW6NSTmI
	 1V/CaOn4F4sa+yQfXwTmUflfy0JKW1QCw3EN6+48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 037/247] HID: quirks: Add ALWAYS_POLL quirk for VRS R295 steering wheel
Date: Fri, 21 Nov 2025 14:09:44 +0100
Message-ID: <20251121130155.935684919@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Makarenko <oleg@makarenk.ooo>

[ Upstream commit 1141ed52348d3df82d3fd2316128b3fc6203a68c ]

This patch adds ALWAYS_POLL quirk for the VRS R295 steering wheel joystick.
This device reboots itself every 8-10 seconds if it is not polled.

Signed-off-by: Oleg Makarenko <oleg@makarenk.ooo>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d05a62bbafffb..0723b4b1c9eca 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1435,6 +1435,7 @@
 
 #define USB_VENDOR_ID_VRS	0x0483
 #define USB_DEVICE_ID_VRS_DFP	0xa355
+#define USB_DEVICE_ID_VRS_R295	0xa44c
 
 #define USB_VENDOR_ID_VTL		0x0306
 #define USB_DEVICE_ID_VTL_MULTITOUCH_FF3F	0xff3f
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index d7105a8395982..bcd4bccf1a7ce 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -207,6 +207,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_KNA5), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UCLOGIC, USB_DEVICE_ID_UCLOGIC_TABLET_TWA60), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGTIZER, USB_DEVICE_ID_UGTIZER_TABLET_WP5540), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_VRS, USB_DEVICE_ID_VRS_R295), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_10_6_INCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_MEDIA_TABLET_14_1_INCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SIRIUS_BATTERY_FREE_TABLET), HID_QUIRK_MULTI_INPUT },
-- 
2.51.0



