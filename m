Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041089;
	b=tIZlOQ7rhf194FOOuL/lQWK3T08QUny3F2EryZfqqqMnxXYgplvuH8m8JOBlc7Vl7n4n
	 zHqNMXB/8ahQZdOFdSs7BeRE/tWj1sWXw/T336zqvBLpdznoJQDUhkcQ0627IIBbi8D1K
	 lsYU5+HU6FnZvpnsdOh3vdCm29Wbs6kPtbUGnvouVQf2qMc+I/luXNVArpmXn7wgm1xJf
	 P/Cw/vAA2lnumf6ZiORB1QDmoO5XE5DQWu53YMcPFPGC4of0PXSizYBERV7466z1CPa4t
	 Tgk+JqbjWhMxmXscJyxd2kHXr3R9hAO5A1cSIBVhvXHK0v14gERqWeLKVUIg+Um64DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7N0sof7I7tBoKyEk12fYkTzoWWqkyJeCTKOyFqUO0PI=;
	b=vXyv+XwgkOAw5MQiYM4fVeMySjg/aPFvio2abTFcxVa+XtMJ6bDkmvWGS0F4HgI+9EFX
	 3TIzj+Tbti3ygZl02RzDT+J21s8uoilFMmi/rvdFvWS6XzN85HO7qX+tG9PuNdaJTfMXg
	 YwtLhfaTaEraKG2H8gaaAmTLdHmMQCxbqjCswoEx44hkya0w8BFG5ajFP+Qf80FwHzc/v
	 ZnDw1T20ziWr5UOsmoTuFmWM9hXiwYS4P5RJs7hvFb7GPadfmkbI2O745Sn/NEoUXUJm9
	 JxKRXi8skS+3666DBLoILG3FkuINaPl5e3xjNwzI+GyBBbgsLbLi1S/6a/EPqkimsEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aejUGpP6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78159606A320;
	Wed, 18 Nov 2026 22:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aejUGpP6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13621F000C4;
	Wed, 18 Nov 2026 22:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041089;
	bh=7N0sof7I7tBoKyEk12fYkTzoWWqkyJeCTKOyFqUO0PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aejUGpP6v4yamFU8oTVJgLcdrgESykT/N9556chEeytg+laC4xeMcji4RcU1J+bCh
	 nSS0YeVuuFshUUJliIQ3ZvLWMZxOhb3WNxf2T7ldpAZn/XP7kd2q27vk6Pq4ZcqNp5
	 xo3bLQTNhT2QQTYhgwPmAMf1fM8wqIv/nkPW+Oc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2689/3318] ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150441.629901143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c01fb2ed90c0770560ea9cc1644f205956b26a70 ]

The bitmap matrix in the mixer unit descriptor for UAC2 and UAC3 has
rather the size of input-pins x output-pins, while the current
USB-audio driver code wrongly assumes the UAC1 bitmap matrix size,
which is input-channels x output-pins.  That is, when input pins have
multiple channels, the column size differs and it leads to the
accesses at a wrong position.

This patch corrects the access of the bitmap matrix for UAC2/UAC3.
For making the code cleaner, split the parser to UAC1 and UAC2/3, too.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 23caaf19b11e ("ALSA: usb-mixer: Add support for Audio Class v2.0")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-5-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 112 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 34 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 5f0a122fde8c9..29ccf7a4ec348 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2180,7 +2180,7 @@ static bool mixer_bitmap_overflow(struct uac_mixer_unit_descriptor *desc,
  */
 static void build_mixer_unit_ctl(struct mixer_build *state,
 				 struct uac_mixer_unit_descriptor *desc,
-				 int in_pin, int in_ch, int num_outs,
+				 int in_ch, int num_outs,
 				 int unitid, struct usb_audio_term *iterm)
 {
 	struct usb_mixer_elem_info *cval;
@@ -2265,34 +2265,13 @@ static int parse_audio_input_terminal(struct mixer_build *state, int unitid,
 /*
  * parse a mixer unit
  */
-static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
-				  void *raw_desc)
+/* UAC1 mixer unit */
+static int parse_audio_mixer_unit_v1(struct mixer_build *state, int unitid,
+				     int input_pins, int num_outs,
+				     struct uac_mixer_unit_descriptor *desc)
 {
-	struct uac_mixer_unit_descriptor *desc = raw_desc;
 	struct usb_audio_term iterm;
-	int input_pins, num_ins, num_outs;
-	int pin, ich, err;
-
-	err = uac_mixer_unit_get_channels(state, desc);
-	if (err < 0) {
-		usb_audio_err(state->chip,
-			      "invalid MIXER UNIT descriptor %d\n",
-			      unitid);
-		return err;
-	}
-
-	num_outs = err;
-	input_pins = desc->bNrInPins;
-
-	if (state->mixer->protocol == UAC_VERSION_2 ||
-	    state->mixer->protocol == UAC_VERSION_3) {
-		if (input_pins * num_outs > 256) {
-			usb_audio_err(state->chip,
-				      "invalid channels for MIXER UNIT %d: input=%d, output=%d\n",
-				      unitid, input_pins, num_outs);
-			return -EINVAL;
-		}
-	}
+	int num_ins, pin, ich, och, err;
 
 	num_ins = 0;
 	ich = 0;
@@ -2311,25 +2290,90 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 					  num_ins, num_outs))
 			break;
 		for (; ich < num_ins; ich++) {
-			int och, ich_has_controls = 0;
-
 			for (och = 0; och < num_outs; och++) {
 				__u8 *c = uac_mixer_unit_bmControls(desc,
 						state->mixer->protocol);
 
-				if (check_matrix_bitmap(c, ich, och, num_outs)) {
-					ich_has_controls = 1;
+				if (check_matrix_bitmap(c, ich, och, num_outs))
 					break;
-				}
 			}
-			if (ich_has_controls)
-				build_mixer_unit_ctl(state, desc, pin, ich, num_outs,
+			if (och < num_outs)
+				build_mixer_unit_ctl(state, desc, ich, num_outs,
 						     unitid, &iterm);
 		}
 	}
 	return 0;
 }
 
+/* UAC2/UAC3 mixer unit */
+static int parse_audio_mixer_unit_v2(struct mixer_build *state, int unitid,
+				     int input_pins, int num_outs,
+				     struct uac_mixer_unit_descriptor *desc)
+{
+	struct usb_audio_term iterm;
+	int pin, och, err;
+
+	if (input_pins * num_outs > 256 ||
+	    mixer_bitmap_overflow(desc, state->mixer->protocol,
+				  input_pins, num_outs)) {
+		usb_audio_err(state->chip,
+			      "invalid channels for MIXER UNIT %d: input=%d, output=%d\n",
+			      unitid, input_pins, num_outs);
+		return -EINVAL;
+	}
+
+	for (pin = 0; pin < input_pins; pin++) {
+		err = parse_audio_unit(state, desc->baSourceID[pin]);
+		if (err < 0)
+			continue;
+		if (!num_outs)
+			continue;
+		err = check_input_term(state, desc->baSourceID[pin], &iterm);
+		if (err < 0)
+			return err;
+
+		for (och = 0; och < num_outs; och++) {
+			__u8 *c = uac_mixer_unit_bmControls(desc,
+						state->mixer->protocol);
+
+			if (check_matrix_bitmap(c, pin, och, num_outs))
+				break;
+		}
+		if (och < num_outs)
+			build_mixer_unit_ctl(state, desc, pin, num_outs,
+					     unitid, &iterm);
+	}
+	return 0;
+}
+
+static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
+				  void *raw_desc)
+{
+	struct uac_mixer_unit_descriptor *desc = raw_desc;
+	int num_outs;
+
+	num_outs = uac_mixer_unit_get_channels(state, desc);
+	if (num_outs < 0) {
+		usb_audio_err(state->chip,
+			      "invalid MIXER UNIT descriptor %d\n",
+			      unitid);
+		return num_outs;
+	}
+
+	switch (state->mixer->protocol) {
+	case UAC_VERSION_1:
+	default:
+		return parse_audio_mixer_unit_v1(state, unitid,
+						 desc->bNrInPins, num_outs,
+						 desc);
+	case UAC_VERSION_2:
+	case UAC_VERSION_3:
+		return parse_audio_mixer_unit_v2(state, unitid,
+						 desc->bNrInPins, num_outs,
+						 desc);
+	}
+}
+
 /*
  * Processing Unit / Extension Unit
  */
-- 
2.53.0



