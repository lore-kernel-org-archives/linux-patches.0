Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99A346F495;
	Tue, 21 Jul 2026 18:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659451; cv=none; b=u8sJjO6/40c7LTHeUY4diWVr5mD1mS9IHCyp/97JM5AtVJ+g4UeIsKZ9YOnDLts2yMVGMXPWDc6DftGnmk04ZVUYqpBaNjsR36oLrtb04bqG1fF6cLgxcz9XFG2lJXM2kz7IwBzIe/vJWf1Lx8l/GtOyBbucUKo+ryOK3SmKijw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659451; c=relaxed/simple;
	bh=x7/gbbAGG9S8rCyntYe/BzfVabCP1ebpfC0B6ChjbRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tD/jSIQzyB6RNnWeBfGOksHadLv2iP8dxy8qiYvo6qmYPb02A3/SaHkgncE3cKKvTtJhkCylXaeqbOjBYlPnKqauSgJjpelMgtFv5XlfqlTkULo3gsGbnnF4GpB92u+S2istFOeVjQrTDTdbjKKdasSCzVBcaRjxofPFFGL0xSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voEeg6Tq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voEeg6Tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36E71F000E9;
	Tue, 21 Jul 2026 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659449;
	bh=k4bM6M5MDP0y/wjsczIuzbGzZTBrmuf6xBseDRcU8D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=voEeg6TqQmSoweeDmVGOt4YoitihuPl7vCZEInN84EUwuQR9o/AEGncY0riLEEPHQ
	 JPf5pCVRpiFypJEEXpjRrPPcK0SMw0icQSPFBUL49EiQPQ7JiT0lEwNBOQH2xj98YD
	 ORhYD8Yac8RKIZ5oeYl/JHos9/j5BXl/gfNwNe2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1523/1611] ALSA: scarlett2: Update offsets for 2i2 Gen 4 firmware 2417
Date: Tue, 21 Jul 2026 17:27:19 +0200
Message-ID: <20260721152549.702259310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 3ca15754b561483aa7a1bce51677d6389f8ff5bb ]

Firmware 2417 for the Scarlett 4th Gen 2i2 moved the direct monitor gain
parameters, so add a second config_set with the shifted offset and
select it for firmware versions >= 2417.

Fixes: 4e809a299677 ("ALSA: scarlett2: Add support for Solo, 2i2, and 4i4 Gen 4")
Cc: stable@vger.kernel.org # ALSA: scarlett2: Allow selecting config_set by firmware version
Cc: stable@vger.kernel.org # ALSA: scarlett2: Fold min_firmware_version into config_sets
Cc: stable@vger.kernel.org
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/ad0fc5a131e76eb656a24e0e198382f7134068fe.1777151532.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |   58 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -937,6 +937,63 @@ static const struct scarlett2_config_set
 	}
 };
 
+/* 2i2 Gen 4, firmware version 2417 and above
+ *
+ * Firmware 2417 shifted DIRECT_MONITOR_GAIN by 4 bytes; all other
+ * offsets are unchanged from scarlett2_config_set_gen4_2i2.
+ */
+static const struct scarlett2_config_set scarlett2_config_set_gen4_2i2_2417 = {
+	.notifications = scarlett4_2i2_notifications,
+	.param_buf_addr = 0xfc,
+	.input_gain_tlv = db_scale_gen4_gain,
+	.autogain_status_texts = scarlett2_autogain_status_gen4,
+	.items = {
+		[SCARLETT2_CONFIG_MSD_SWITCH] = {
+			.offset = 0x49, .size = 8, .activate = 4 },
+
+		[SCARLETT2_CONFIG_DIRECT_MONITOR] = {
+			.offset = 0x14a, .size = 8, .activate = 16, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_AUTOGAIN_SWITCH] = {
+			.offset = 0x135, .size = 8, .activate = 10, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_AUTOGAIN_STATUS] = {
+			.offset = 0x137, .size = 8 },
+
+		[SCARLETT2_CONFIG_AG_MEAN_TARGET] = {
+			.offset = 0x131, .size = 8, .activate = 29, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_AG_PEAK_TARGET] = {
+			.offset = 0x132, .size = 8, .activate = 30, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_PHANTOM_SWITCH] = {
+			.offset = 0x48, .size = 8, .activate = 11, .pbuf = 1,
+			.mute = 1 },
+
+		[SCARLETT2_CONFIG_INPUT_GAIN] = {
+			.offset = 0x4b, .size = 8, .activate = 12, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_LEVEL_SWITCH] = {
+			.offset = 0x3c, .size = 8, .activate = 13, .pbuf = 1,
+			.mute = 1 },
+
+		[SCARLETT2_CONFIG_SAFE_SWITCH] = {
+			.offset = 0x147, .size = 8, .activate = 14, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_AIR_SWITCH] = {
+			.offset = 0x3e, .size = 8, .activate = 15, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_INPUT_SELECT_SWITCH] = {
+			.offset = 0x14b, .size = 8, .activate = 17, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_INPUT_LINK_SWITCH] = {
+			.offset = 0x14e, .size = 8, .activate = 18, .pbuf = 1 },
+
+		[SCARLETT2_CONFIG_DIRECT_MONITOR_GAIN] = {
+			.offset = 0x2a4, .size = 16, .activate = 36 }
+	}
+};
+
 /* 4i4 Gen 4 */
 static const struct scarlett2_config_set scarlett2_config_set_gen4_4i4 = {
 	.notifications = scarlett4_4i4_notifications,
@@ -1999,6 +2056,7 @@ static const struct scarlett2_device_inf
 static const struct scarlett2_device_info s2i2_gen4_info = {
 	.config_sets = (const struct scarlett2_config_set_entry[]) {
 		{ 2115, &scarlett2_config_set_gen4_2i2 },
+		{ 2417, &scarlett2_config_set_gen4_2i2_2417 },
 		{ }
 	},
 	.min_firmware_version = 2115,


