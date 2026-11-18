Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031253;
	b=CVVRModCT/NElP1NkVWLPv68tuGp2k3iuERl31SAWLGqnRWxoGGmyKzYJ9Uz75KSD/hL
	 CP6gXfrZfEC79AllWOxIB2k2ENfnDem0/uOGkGsQQBJhoP5UxiSsXFOSoIGLYivonCJXQ
	 BrpAfPPFitbXXvrm1MGHAAK9Z5z4nSVhupUS1A80dgR4g5tf2vh68zNZGx5jfUPpyOZ1a
	 8edojr1v4NOJRu98qm8kTM4YOLhXe/DxmRziQ2UJ7p/Xj2TaPwm2HjxmqLTweb9QjQU8W
	 MY/OKp4YiW3wwjUyy9Q2RclL6lqoEvRfemsLzqjGGS34ihZveDDoeUI3vkf1+59b6OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ETEYJEyO0TBLXQ5tq7pZSxZJFOYkKDHbtYOdT7pzXk=;
	b=kpLkN3tzA0FO5fqxJAl0wl+NFKiKKsXOwKkCF/cF/IIrdWh6Av9E7MkhLDeSTdaIcQnc
	 HTsE/LAHBI+2f98yX3YHpY0PWUDgTlKu069jT/VMXM6xN0Q05hx8WiROYYVR2yf3Spfy0
	 D8beTpyjt7P8JErktZaxuFbwXpvKxfU4Vy0HYTMFopZpr+fkWXw8gDPvYo+KscrsVtzI9
	 GDxD8dTzIJMEKhwfglX3DlUwyz9gqK5xLH3wS1u8KJNNMt4qYEGJfgPPFrGwqqmCcfWjs
	 rQno39AcpuacoY6PzXoumviTz2SY7kVDS7N7MtoXI/8OfpFkc1fN0QTfiJ+krDzj7gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nLgIWKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74CE606A31C;
	Wed, 18 Nov 2026 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1nLgIWKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C70C1F000C4;
	Wed, 18 Nov 2026 19:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031253;
	bh=3ETEYJEyO0TBLXQ5tq7pZSxZJFOYkKDHbtYOdT7pzXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nLgIWKKxHsDjQlm8r4wXkDGNYkAEiFsfzMxAC1w2Zs1NqvpoJMTpcPRD61BdbeYm
	 fDIeKQ15GjGOni9JlTs/Zs06x6pZXRERm9oDG9OOKc9SIKLO6ek45rotr1qUtRQ0Ao
	 z6p1wMJoH6gwK553lBokSdQKFeIGqH2J8mANiB+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0993/1756] ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation
Date: Wed, 18 Nov 2026 15:52:00 +0100
Message-ID: <20261118150049.714598171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cb685fa0e03ea..b69b04777c6a3 100644
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



