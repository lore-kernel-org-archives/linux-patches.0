Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051525;
	b=AKUFKwOEDcRbnMt7qLAVkdc7z8gqR5eEFOgKAS23kn+yhRv0eWP6fSxfFQyNsUnqcydm
	 heQ3dfJSVYqYVm+QJK+rwQm/GleQSk9RBqEDXrkxpKWMrx5x0nzg+aQ5FZ30w9U/4ljGC
	 3ujPqi6wd+bC8l1N9HpdrCZgBaSzo9baxQxxmFR7MVbnbx74D2HhKj9JaTYToNUB0+vw1
	 9egqtCrUH+rGFHljaiv59TE0DX8hWsqOuW9jmCO1G4xzNbn+YoWjnXnWuQ8i4bbP4UaVl
	 OFLUua8Rsjq3QjzRbiMDSFhN8UY1ItLyZHjzj2MDk118DzdOkZfxuMga0wzgWAFXhVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EgcSJ8mjwaMOUsLYc5URHIDRy+Mv2o1Mtl0Sdea/XTA=;
	b=JcveAw2e6fVYIkc7zttrTNGWpQah1jsepCfW31k8E+V3D+5i4cNYZnnkyc8CTqsKbdYF
	 jh2vex0F9Hdkb0qF3JN1HqCAC3t/oULuxoKaaDpZAxYhQNAOax6xp81IycTSo6YB0/d5S
	 ilp9BC2ndA+gs4h8hgKH5G0Avvocb5ZIIRnCAgEKTZxH5cAUsQ4FeyZNEqX7YnPzibaOG
	 JH4CYQFknOeImTEql+sucAHsOvjRdjX6lC87NK2KI2ENVQvNNsgXtwaoN6ijUlbUiIpaC
	 /726OHuGj4aNZ1Ys803rjAhvgqhP7bvBDswc3KPzPe8ZJW+R3CGPaB6DpYEW330OZUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kiaYCrx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46735606A31C;
	Thu, 19 Nov 2026 01:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kiaYCrx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC761F000C5;
	Thu, 19 Nov 2026 01:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051525;
	bh=EgcSJ8mjwaMOUsLYc5URHIDRy+Mv2o1Mtl0Sdea/XTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kiaYCrxwrLqr2kakk8Ys5OxUkpeO/eNbO4s4fJQHmjBP0IHRkXW2+6X0gOEXSXrE
	 vjniNrNT6Ny8M2EmPpNYJbVYLL+AyVoOLafM9aW8WhDSt1J3uTADdZPVrthJMkxKYs
	 XrxiGFzAH37FqYFHiK/mBdcVe47+le3kP+Gk9wvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0238/2214] ALSA: hda/conexant: Always enable the headset-mic pin on plugin
Date: Wed, 18 Nov 2026 15:31:54 +0100
Message-ID: <20261118150019.716573218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f631dc0650e4d..45abed135d3f3 100644
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



