Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831111;
	b=VOMh8oXZJ703l3buTTdceDS+s4lP28IcvKIT980/7CJo/geEudhFe4yxQXLbysGPKQoG
	 VsdIgjpieFoos7tSt+1gL7OgTkFJw9/0PnOZ8JZxNKEjOkOyDnHJgpJJqEdQlzkxXeVBz
	 9EmQ9haEAGphIsPD8XRZ+fBYBxNf2z5LCXS1IeXZl6fl0Ecb1uzpLdpcwIBaBdcdlBl/J
	 OIx41v+4nbu2nVyuFMyjcltezY11d4MjZkNWhwRgStZyu1s1QeNDNV6HyHq58y+yfIgoo
	 HcZw/Kvio9SZrCJmXbrc64pOhsc++DZXesdf8o/R9XQgbEEvfoTldyEWz6NciATwIfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U6l/282c11Rgn8nBg50GF4HyRXkd6vY2+LwIR91LyEg=;
	b=RxTAGvnWpd9U+iNh83fl0B/x/bTd3puGddkG8kMhvogco7InNp+WGx+zOuAFGLvkLPRd
	 8xocVkHsaYrkXC4xqX0U5aUxN3pGx7dYwBd0a9r/TP7+f8NUANhoqMtTFTA8sV22VYwtk
	 lPsDjV6qmagNMhf0pu8JrGO9+0VrBQ44drNqtPHVLHXtfbXdfOv91yfKmad5uFIo3PrO6
	 EhOTFjj1L48M5x8oyRtaBkMWa+A4C167N9VtOdXo/v/zqdTSFfpyJqKLvuclS0DjZEu89
	 5OYH4x671o5lo/c6viRhgmnsA/1pSXpnVliqBOgqe71LROS7sIDe2TP+S74PTSwEwIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qtsoCzx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFCD606B2D8;
	Wed,  4 Nov 2026 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qtsoCzx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448521F000C1;
	Wed,  4 Nov 2026 22:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831110;
	bh=U6l/282c11Rgn8nBg50GF4HyRXkd6vY2+LwIR91LyEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qtsoCzx+7g4zbs3sqfDE0cSBt+UrfdnYkOugYLv9jr33ZupOGHqru9TOXb1HkQwbO
	 7D1wUdoyYhGv8gIJ5xcNfo29SX+9WXbxLR8jlKmDY9uMS73eCTHhdg2UtOQ2Y0SrEi
	 x8bMLWRo8B+wSnTZ3Q4MSMkrhKotzQm0fea86VQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0470/1005] ALSA: hda/conexant: Always enable the headset-mic pin on plugin
Date: Wed,  4 Nov 2026 16:03:23 -0500
Message-ID: <20261104211057.180161668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 9642a5e843758686e02a7f0d1df9eb0f7f96603c ]

Rename the function to cx_process_headset_detect_plug_type() to reflect
that it only reports the detected plug type, and move the pin control
write into cx_update_headset_mic_vref() so that node 0x19 is always set
to enable the headset mic with the 80% VREF whenever the mic is
present, regardless of the type detection result.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260826115344.2128835-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/conexant.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index 862fcbe74e4f0..faaabc326f560 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -213,7 +213,7 @@ static void cx_remove(struct hda_codec *codec)
 	snd_hda_gen_remove(codec);
 }
 
-static void cx_process_headset_plugin(struct hda_codec *codec)
+static void cx_process_headset_detect_plug_type(struct hda_codec *codec)
 {
 	unsigned int val;
 	unsigned int count = 0;
@@ -249,10 +249,12 @@ static void cx_update_headset_mic_vref(struct hda_codec *codec, struct hda_jack_
 	 * Check hp&mic tag to process headset plugin & plugout.
 	 */
 	mic_present = snd_hda_codec_read(codec, 0x19, 0, AC_VERB_GET_PIN_SENSE, 0x0);
-	if (!(mic_present & AC_PINSENSE_PRESENCE)) /* mic plugout */
+	if (!(mic_present & AC_PINSENSE_PRESENCE)) { /* mic plugout */
 		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20);
-	else
-		cx_process_headset_plugin(codec);
+	} else {
+		cx_process_headset_detect_plug_type(codec);
+		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24);
+	}
 }
 
 static int cx_suspend(struct hda_codec *codec)
-- 
2.53.0



