Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E00143C58;
	Tue, 23 Apr 2024 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908717; cv=none; b=sAMYmny48WkwZrpXHeTtI2zqePVhSMX5GSp4Jeo17vRr6BrWobTCkJ8RtzM79bJpCo50c8ADV7JQuihTncbFUIIlsdJDnNnhDnxWj02b1NefgtfMwwutBR8NW4T2vk1Jnfq0KDhoCL2400kO+z05ak2+Nv6Fv8BHUE2W+FLN31k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908717; c=relaxed/simple;
	bh=Qa5Dd6HR1j1Vmv73R2DJ48XPBVjTgdYNt4SoJVEwi2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV9vD2+HbiJYEhmWuliZ6SvHg6ld2z7kD/NL4QuM5GevIxiLvdAsKYenRSbVKdu0Avn4DQbmJqIbkIrrTexffNRTB5+5RGd5UYjpHCxuMT8UscIsjjP8qnJQFWzb4cVOukuF3Dqwxj80kY1DolXFnzFIwDzLKcyaOdqHQASyFcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTFc1FeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTFc1FeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5543C4AF07;
	Tue, 23 Apr 2024 21:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908716;
	bh=Qa5Dd6HR1j1Vmv73R2DJ48XPBVjTgdYNt4SoJVEwi2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTFc1FeOfLuTSo0ZEQCxPyTM7Zixo8L8VTj6yxoAPgwaOvQe5G7jeHZQisZBR2Hme
	 AYoXHWNQH3lI4d+rXuwORmNovJ51ZnkP+Th+kAbE5DGEmIoCP5nmIp9bP0VXFjhEGe
	 doKeJzdUd6om8pSYmKhI5Z5ivKQ/TEQhQJ0rcTZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/141] ALSA: scarlett2: Add Focusrite Clarett 2Pre and 4Pre USB support
Date: Tue, 23 Apr 2024 14:39:04 -0700
Message-ID: <20240423213855.669891720@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit 2b17b489e47a956c8e93c8f1bcabb0343c851d90 ]

It has been confirmed that all devices in the Focusrite Clarett USB
series work the same as the devices in the Clarett+ series. Add the
missing PIDs to enable support for the Clarett 2Pre and 4Pre USB.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/ZSFB8EVTG1PK1eq/@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c        | 2 ++
 sound/usb/mixer_scarlett_gen2.c | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 3721d59a56809..a331732fed890 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3447,6 +3447,8 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x1235, 0x8213): /* Focusrite Scarlett 8i6 3rd Gen */
 	case USB_ID(0x1235, 0x8214): /* Focusrite Scarlett 18i8 3rd Gen */
 	case USB_ID(0x1235, 0x8215): /* Focusrite Scarlett 18i20 3rd Gen */
+	case USB_ID(0x1235, 0x8206): /* Focusrite Clarett 2Pre USB */
+	case USB_ID(0x1235, 0x8207): /* Focusrite Clarett 4Pre USB */
 	case USB_ID(0x1235, 0x8208): /* Focusrite Clarett 8Pre USB */
 	case USB_ID(0x1235, 0x820a): /* Focusrite Clarett+ 2Pre */
 	case USB_ID(0x1235, 0x820b): /* Focusrite Clarett+ 4Pre */
diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index e6088fdafe7a3..cbdef89ab987f 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -5,7 +5,7 @@
  *   Supported models:
  *   - 6i6/18i8/18i20 Gen 2
  *   - Solo/2i2/4i4/8i6/18i8/18i20 Gen 3
- *   - Clarett 8Pre USB
+ *   - Clarett 2Pre/4Pre/8Pre USB
  *   - Clarett+ 2Pre/4Pre/8Pre
  *
  *   Copyright (c) 2018-2023 by Geoffrey D. Bennett <g at b4.vu>
@@ -64,6 +64,8 @@
  * Gregory Rozzo for donating a 4Pre, and David Sherwood and Patrice
  * Peterson for usbmon output).
  *
+ * Support for Clarett 2Pre and 4Pre USB added in Oct 2023.
+ *
  * This ALSA mixer gives access to (model-dependent):
  *  - input, output, mixer-matrix muxes
  *  - mixer-matrix gain stages
@@ -999,6 +1001,8 @@ static const struct scarlett2_device_entry scarlett2_devices[] = {
 	{ USB_ID(0x1235, 0x8215), &s18i20_gen3_info, "Scarlett Gen 3" },
 
 	/* Supported Clarett USB/Clarett+ devices */
+	{ USB_ID(0x1235, 0x8206), &clarett_2pre_info, "Clarett USB" },
+	{ USB_ID(0x1235, 0x8207), &clarett_4pre_info, "Clarett USB" },
 	{ USB_ID(0x1235, 0x8208), &clarett_8pre_info, "Clarett USB" },
 	{ USB_ID(0x1235, 0x820a), &clarett_2pre_info, "Clarett+" },
 	{ USB_ID(0x1235, 0x820b), &clarett_4pre_info, "Clarett+" },
@@ -1197,7 +1201,7 @@ static const struct scarlett2_config
 	[SCARLETT2_CONFIG_TALKBACK_MAP] = {
 		.offset = 0xb0, .size = 16, .activate = 10 },
 
-/* Clarett+ 8Pre */
+/* Clarett USB and Clarett+ devices: 2Pre, 4Pre, 8Pre */
 }, {
 	[SCARLETT2_CONFIG_DIM_MUTE] = {
 		.offset = 0x31, .size = 8, .activate = 2 },
-- 
2.43.0



