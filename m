Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034376;
	b=YequRC21fFW+G2PMl97oX9f361+2RFmMMDRLd4lvMDQoQdeXtRW3ktlxPtnkPoRDJlOn
	 4LcxH2oy/d/a4PTFay+EUxRK8vAQjvrOUo3Lou3Y74stNoTSPQrJeF0aVvWipOUhhBMir
	 agclHIG9WCzpDqcbyMVvse6d6wExSS2m+MnCuLDT2OG6ql+OR7LEFLK6k7oBYthF//YNA
	 AqW9Jyouz2/7JhKx/Q8VR3dHivSwMKGSqiwaWK9cYgdUKY0q2ITnmvZN9oCCYPXkElife
	 ntSnQwI61u2/Eykc0XVEat7gMqFrvtwqpyIt4NsUNYJmZiT4yVqhGMrdteiF78Q15Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jyvEuwbx/w69VZ35r4fg0DdQxFaY5DHkyNDXKcHghaQ=;
	b=iITbdyk+1jcDElg4C8fR/sa0YOAUmMcdrINMK51pGw7FOgAIedY+Ea+hq8IYldGYVst1
	 zgpWgzUe4gro2OcyfgP7tl1jCL7GUXKuMpZKu7QkdKLaVI+n9O761E3RM8ySzJRHwUZ5C
	 k1GqyLZ1ZVXjkuGiCX5329xykRszXe6H67k5f4rp2IZID1IiQBOCB95Ur5Ltezq16dc/q
	 PaIuIzG7WH0qEVLoXgPl5uQvEVz5jpXCOLnAQ+0oqoes6euV03SYZbebtaolQwvC2li8W
	 Hp+riBxO6LwzoAGsFCN6badIsceQfHqbn64Sq3+3ZqeUzNPtILetu1bBoO9pFk6a8Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VoKh6bPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9FF606A325;
	Wed, 18 Nov 2026 20:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VoKh6bPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB391F000C4;
	Wed, 18 Nov 2026 20:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034376;
	bh=jyvEuwbx/w69VZ35r4fg0DdQxFaY5DHkyNDXKcHghaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoKh6bPUOtHjIoYJSwSjFtX9qsfqjxO6C4EgRKgmFfwtfiwSispKQ9zdSf1/NNfUG
	 F1eEbfRLgqE08kcK1009Fd8gftBd4sFzk4Sl8YmAvbiW8YNYgjlvQ/4vKBIDwI/Gu4
	 +299fl6o1ZkhMzcbTtL9qrCDNKiMnaOvedg8um8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0330/3318] ALSA: hda/conexant: Always enable the headset-mic pin on plugin
Date: Wed, 18 Nov 2026 15:15:52 +0100
Message-ID: <20261118150325.821062373@linuxfoundation.org>
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
 sound/pci/hda/patch_conexant.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 8674ef6edf04d..b128fa6613813 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -213,7 +213,7 @@ static void cx_auto_free(struct hda_codec *codec)
 	snd_hda_gen_free(codec);
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
 
 #ifdef CONFIG_PM
-- 
2.53.0



