Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061073;
	b=Xdi3eqJdHxx87MdY/JlsvYg4Am89Hx08a8VwIfnm5zZ/0cZvvhBPfJY2ZvG9B9R6kdZn
	 aVjTsljxRtEEFUussU2VrXQ4/N9/C+rDzWUPLDd0HQUx2eXOaIgN4shTbMwezzvEXLu7d
	 xT9lUpPeYPNA0UGBKwQHD1UKSm5qlcWNyARs8d+e51LFFRG6kiXyPeaHP9FiXoW7xR3Jf
	 L+pw4reO6gJKsHL27OYaCTR9RXjK+h1zNuM3h/eVM63PAepLp2uqqiuMkgQWQif/kX74Y
	 XE97c0z6a/7ZcP9xL6LtuwiRU2onjlMHOKne892XI2LFlkSEStLnw32zgrpj+SyrZYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/byLz1wPodOf2azukHDgZ8q6TzmJj95DXWy/c5AoFY=;
	b=VXw7INCVYuXGk2SiLR/N5LbM99sUfpfA2f+vR51XSZMqvBCXpe1PZVkCwo99rIS4eNod
	 6kE7sTfuiaD3d8pZWO5cU2p5PhMLcd1dWcQkqyZOjId+89zIYSTaCjzZaBpFeislwg2tn
	 HnXYwVGaa8uxi6VTnGpl4ry9MK8bjT2mIP0hrrPi5PqMQBhkbW+hCtX4DTK8CuYaEzVQe
	 4S9PLCoXGqtwI6he/giACedBtIiWq9XfdgWeKO54Qa4aNl/04lITRfrgpBcAAA4x/VT2C
	 KyJefTJCxtitDmK8k65Ue7gYcwcBu1flVRsCDWHYqmm3Egn+olf3fAmQaGppOfj36Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBAULcLt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0D1606D80D;
	Sat,  7 Nov 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBAULcLt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FED1F0089F;
	Sat,  7 Nov 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061071;
	bh=V/byLz1wPodOf2azukHDgZ8q6TzmJj95DXWy/c5AoFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBAULcLtcbnuK/0kbJ8NjDK2VUGlINu/nbiQumuhYbA9McMZh2D8jYzrxW+Uv/Lo+
	 +7Mf+HVFBK7ehDR2eiE/Vu1MlgPpmq/2A1gw7bIPA3/K27X0ndo8woSZLSfT82LnlP
	 Wd2hz1KbhWhPDNeOWYYy27nqSuJPpfBXVPAZPmR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0398/1536] ALSA: hda/conexant: Always enable the headset-mic pin on plugin
Date: Sat,  7 Nov 2026 08:40:14 -0500
Message-ID: <20261107135008.769535667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 6b688832d71d4..4e72ddde7165e 100644
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
 
 static int cx_auto_suspend(struct hda_codec *codec)
-- 
2.53.0



