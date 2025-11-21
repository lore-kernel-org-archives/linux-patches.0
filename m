Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814EA190477;
	Fri, 21 Nov 2025 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731621; cv=none; b=kt6Tt0uF+xopDUpJ9Ra8E+9PvSxK3ZOlDGgsxhQZ9M5miUaqbHgbZz9g5/0uITEHH95MNQ86V+fVeEPWkPb3tVFjsjnxyRJs+rShYRPYv6sM/Wf1pwLW8yDk3R03YOV7ziLp9nZtT8wUzBLDGkvsg0dIQhl3yfeDUDBSoBAFARk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731621; c=relaxed/simple;
	bh=r+NlQhpyhTuFCJLUeLcOtjTMRZGxJCyIoGKAa16bCFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgXfsLgMhe+iO1tjuyOEE6oo+yI9+0spu3Xp51az1vKA2llbIEEJhuwL0MCSMSVPW0qQgKdH4356CIJFMexsZU1GlaXJLQ9C4p3S/2H3LpTzxurmC316VAr5mG6J9sNdhfPeRZTaNXp93h04n75rqOVzWZ5V92ruMjsRTnC5Zo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEqWJz4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEqWJz4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39DBC4CEF1;
	Fri, 21 Nov 2025 13:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731621;
	bh=r+NlQhpyhTuFCJLUeLcOtjTMRZGxJCyIoGKAa16bCFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEqWJz4UjwihP+DeO7yAA9B0QsjNytlLsrZlqMy1Gg5JCOxyv7nAqdMuPMSprahYS
	 CH2D0B2CLEba7BJfqZq/oedGYtOrBu4oulBNsb4WhCB1GSSx03ILEEMIHpDTjy9u1i
	 aoOVJz5nqPQZnNXhD/uAavFW3vtzJUEqqcc8Atg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/185] HID: quirks: Add ALWAYS_POLL quirk for VRS R295 steering wheel
Date: Fri, 21 Nov 2025 14:10:51 +0100
Message-ID: <20251121130144.747683130@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63eb60effcaaf..4b85d9088a61b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1420,6 +1420,7 @@
 
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



