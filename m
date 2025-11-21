Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7856E346E72;
	Fri, 21 Nov 2025 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733307; cv=none; b=YAcBadWx9Xj6zmtTwRZQZcaswM33pnIus5ZqFGH8PFPAxFhZVAxd8bNGiFDI6/5YEtVKJiK/7LjdKvgQXiImWAXJ426ZZfDOsnbOF/gJejAkCX0IXodnpI/1mtWnv3SorpP/YmSGHoMPdhT0zKMVGLpXWxsyzAAzIRskn0MZQ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733307; c=relaxed/simple;
	bh=2DAzQZM5BhV1DDS5A8hY3Kv9CVqYz/YJKocrnVat6rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGDs0reoby7q8HK0MD0nX/KQpRxZRA/FwZ/HwyXI097pda1A9CQJoyK7YdZAprglfP2XbHK6yYzpk+d5wUVuRjo94v9ebmUxSguqKJXXKMi0edukvZrt31efQyVFlr1IgJdzXPI+HS71+TpmVqwJbC1iwOFC02UlHjMXCB9nXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWQ3zW13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWQ3zW13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A778C116C6;
	Fri, 21 Nov 2025 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733307;
	bh=2DAzQZM5BhV1DDS5A8hY3Kv9CVqYz/YJKocrnVat6rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWQ3zW137O1j6Op/79HEUKVfeJcmBgzXeUCDMLYJ9q/BBTQOx4Li4lRjG/5RYj4NX
	 rh/o4YmTAlEQXmMwB7FKkS6OVYTIu343wPKmJ27bQ+WeNsLK45HH2cyMK2Pa8ZtWjp
	 t0FL7abMWPGZ8zBvfAxtbupRtp7q01Y6ZsLbJZ8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 390/529] HID: quirks: Add ALWAYS_POLL quirk for VRS R295 steering wheel
Date: Fri, 21 Nov 2025 14:11:29 +0100
Message-ID: <20251121130244.898889626@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be24029782b10..fbbab353f040a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1403,6 +1403,7 @@
 
 #define USB_VENDOR_ID_VRS	0x0483
 #define USB_DEVICE_ID_VRS_DFP	0xa355
+#define USB_DEVICE_ID_VRS_R295	0xa44c
 
 #define USB_VENDOR_ID_VTL		0x0306
 #define USB_DEVICE_ID_VTL_MULTITOUCH_FF3F	0xff3f
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 468a47de96b10..75480ec3c15a2 100644
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



