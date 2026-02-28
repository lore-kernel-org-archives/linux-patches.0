Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94B3340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301028; cv=none; b=XIv7qT5x31vPlzxmQl2cknQxpaxfoq+9j66/uIr7hhkEXVRVny26l3zJyvme8K9xy3gextsdXUwIqpBg17aM6gM/LmyPKm8z+Gy/EAHw0etpSDZNzR5cacMnHJ3oubu+hYF14FZxE5bewR91yHG+lyQFcHwtjJIY/qXf1RWXAz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301028; c=relaxed/simple;
	bh=odQ+4/bj/EP9KkzmwwS1nhiZpaJpBM5UhNg2PTpCOCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMmY8kEBbX4NN/Q8G+Dd0AnJYoLttW3O042aoEzsmFQJMNmf2r3/Djq5dnL7i3YrHQRLZz7IcQ5gDcP3t3GAqDtZKpKNVTBxBn3dQV0KI1dzGG6TZtvhBjR9c45287k8WYehrKQgnKR+R+nVK1iRCzpf0eWT8StSU34vdfoD7IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfFfjCl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfFfjCl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AB5C116D0;
	Sat, 28 Feb 2026 17:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301028;
	bh=odQ+4/bj/EP9KkzmwwS1nhiZpaJpBM5UhNg2PTpCOCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfFfjCl29C5z3fD6MeA5/YT9aQ+oCOebk3FYeUUwnSV2zTCYVJiyM16tWSDjZamd/
	 Xl6TxBD6r+MducmIN3y+gR3iq5gvVMXjBNl1zxKy8A71Slb5KO663wjo/JqE5Sf6Fm
	 IFpzq+ogdl3iNzsRRn7TlZFyFx2yW01Rwu+0/i87K3ufsdCDROeiEIExzLlhdRTshy
	 niB3mb9QhSBkAd9i2z5uuX5xQzQ45crSj+sJuQNovlCkmEV6HMmPmyqWrbyNAq60T1
	 YO4PUyZN0K1/izVpA5tSrCMFauX8JizQd24TyCqRmaTfMsW3srYxsxjYZq/9o/u2lu
	 pYtZVmqWDxPFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: fenugrec <fenugrec@mail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/752] ALSA: usb-audio: presonus s18xx uses little-endian
Date: Sat, 28 Feb 2026 12:37:57 -0500
Message-ID: <20260228174750.1542406-166-sashal@kernel.org>
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

From: fenugrec <fenugrec@mail.com>

[ Upstream commit 3ce03297baff0ba116769044e4594fb324d4a551 ]

Use __le32 types for USB control transfers

Signed-off-by: fenugrec <fenugrec@mail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260111-preso_clean1-v2-1-44b4e5129a75@mail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_s1810c.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index 6e09e074c0e7f..93510aa0dc5ef 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -82,13 +82,13 @@
  * mixer and output but a different set for device.
  */
 struct s1810c_ctl_packet {
-	u32 a;
-	u32 b;
-	u32 fixed1;
-	u32 fixed2;
-	u32 c;
-	u32 d;
-	u32 e;
+	__le32 a;
+	__le32 b;
+	__le32 fixed1;
+	__le32 fixed2;
+	__le32 c;
+	__le32 d;
+	__le32 e;
 };
 
 #define SC1810C_CTL_LINE_SW	0
@@ -118,7 +118,7 @@ struct s1810c_ctl_packet {
  * being zero and different f1/f2.
  */
 struct s1810c_state_packet {
-	u32 fields[63];
+	__le32 fields[63];
 };
 
 #define SC1810C_STATE_48V_SW	58
@@ -140,14 +140,14 @@ snd_s1810c_send_ctl_packet(struct usb_device *dev, u32 a,
 	struct s1810c_ctl_packet pkt = { 0 };
 	int ret = 0;
 
-	pkt.fixed1 = SC1810C_CMD_F1;
-	pkt.fixed2 = SC1810C_CMD_F2;
+	pkt.fixed1 = __cpu_to_le32(SC1810C_CMD_F1);
+	pkt.fixed2 = __cpu_to_le32(SC1810C_CMD_F2);
 
-	pkt.a = a;
-	pkt.b = b;
-	pkt.c = c;
-	pkt.d = d;
-	pkt.e = e;
+	pkt.a = __cpu_to_le32(a);
+	pkt.b = __cpu_to_le32(b);
+	pkt.c = __cpu_to_le32(c);
+	pkt.d = __cpu_to_le32(d);
+	pkt.e = __cpu_to_le32(e);
 
 	ret = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
 			      SC1810C_CMD_REQ,
@@ -176,8 +176,8 @@ snd_sc1810c_get_status_field(struct usb_device *dev,
 	struct s1810c_state_packet pkt_in = { { 0 } };
 	int ret = 0;
 
-	pkt_out.fields[SC1810C_STATE_F1_IDX] = SC1810C_SET_STATE_F1;
-	pkt_out.fields[SC1810C_STATE_F2_IDX] = SC1810C_SET_STATE_F2;
+	pkt_out.fields[SC1810C_STATE_F1_IDX] = __cpu_to_le32(SC1810C_SET_STATE_F1);
+	pkt_out.fields[SC1810C_STATE_F2_IDX] = __cpu_to_le32(SC1810C_SET_STATE_F2);
 	ret = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0),
 			      SC1810C_SET_STATE_REQ,
 			      SC1810C_SET_STATE_REQTYPE,
@@ -197,7 +197,7 @@ snd_sc1810c_get_status_field(struct usb_device *dev,
 		return ret;
 	}
 
-	(*field) = pkt_in.fields[field_idx];
+	(*field) = __le32_to_cpu(pkt_in.fields[field_idx]);
 	(*seqnum)++;
 	return 0;
 }
-- 
2.51.0

