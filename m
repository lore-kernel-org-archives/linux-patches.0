Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061402;
	b=THGhL9lCa5A6bWScOjiGoBB9EfayC8TKS1U/jOlX5lzWcIMJ+WIJ9jIoJv7BwYskbIjy
	 hNPqtPQPzw6S1RgvqTltaW20AvaFLKW98m3ngivJCWswJloIGuZviRcv8T2qPDNSQmBxX
	 kYNAfTkJkBxohLeUKQs9UEJRwuw01nOtzAsLIZ1HUxfKGi/tQC44ILHdvG0FPE9wVmdBv
	 Kb6+TR5XiBQ3xRE/eNHC/jLxlEikFQabialY4Zu4bQ8lEehjlwwYQsLlwfz/cJq3zb+lR
	 QP9WAcU8VlXPPfNKHcOR+0iHtYLlCgX6DNTPlZu1kVwM9sGLgO+eofuvtA5W+HkhcyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=50n+4M6tp0m9X3uU/Gl0/3fh1dwEPEK9KRLF0z9+Fec=;
	b=MIIvAc9zOH4QvGQMP5vFmCYYzIPbQqF0IBqlUWyf+OFf6iXgtB1a/sy84qc7I+Zs93YZ
	 CtPePbTMVdNJ6uyBqVCEGaolPr7LPob9mXE69Si4s5tiArBU6NhVvgloWPJR15TZsmg4G
	 hTAhYMSHZD7pb5NiVz0Fu6LQXrD7a/aQ+9kG0q8GweyTzB4QFEYCnONPvtD72UVUytF1d
	 VIdosIMbsl9+IWHC9Ai1laeeUfUURHwa1d81LEjWH+2WQMeawLgZ0X5bVjyr/HxKFPyLJ
	 6qwRDvatlOxGyFe7IvehZMxrGrzWU0rSmdd2JFfme9eogSAyFK6g9Tdl7SQZGjwVBKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srUkidfy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91958606A332;
	Thu, 19 Nov 2026 04:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srUkidfy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C641F000C5;
	Thu, 19 Nov 2026 04:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061402;
	bh=50n+4M6tp0m9X3uU/Gl0/3fh1dwEPEK9KRLF0z9+Fec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srUkidfy6Ax14SUfks+Yf+MQ6G0wpVCONieJRr3Q5M/BN12dXF79VO1s9QTq444Xj
	 Nf/Uif2p84aOJt8wNw9ThnHeaeB6AYjb+MhK8poNd5T9K9lTFckRLC1Doi3LwzMlW/
	 +2ZqGldFZo0QEeNoK7azGLVHZw3dXc4m8wW8fr7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1539/1848] ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118150023.931475952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a375578aa0aef..77e6a59dc9927 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2091,7 +2091,7 @@ static bool mixer_bitmap_overflow(struct uac_mixer_unit_descriptor *desc,
  */
 static void build_mixer_unit_ctl(struct mixer_build *state,
 				 struct uac_mixer_unit_descriptor *desc,
-				 int in_pin, int in_ch, int num_outs,
+				 int in_ch, int num_outs,
 				 int unitid, struct usb_audio_term *iterm)
 {
 	struct usb_mixer_elem_info *cval;
@@ -2176,34 +2176,13 @@ static int parse_audio_input_terminal(struct mixer_build *state, int unitid,
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
@@ -2222,25 +2201,90 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
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



