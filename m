Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A148F1A9B2A;
	Wed, 20 Nov 2024 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107530; cv=none; b=gKHAMgFVqYRj5ILeiPouDoP7jAzph3KRql6CmUVaFBmvciyIgBwhXwHHqmVY7ez7EsjEDRGvOS9DFAfLhJdxoRsqfBjPldM8KX9MwWaeYZk8efKLph0ZcT6FBXwLtRJQaGrD8vqlKDKmRyvEqtQm4iej5xC6jaatoJHGnmt/n8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107530; c=relaxed/simple;
	bh=xwoH31GqDcpTfBo4AsvGrm+bxZ3Y2rYlNlc933kWcTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKs7GkVybcqnMIYX+vqABADUpsMmtqKAkJCJUJfSVKYIEuvJRHgoGAWLrNNw2QeD71h3VWmTmB0WHowMFx6wKoCriLMBpPFDpTuNX34z8l86KJZn0exQKP7dxABUKQCYdo/nIqBKS0FMNYssva9pXtRxga9DHTCUCNGcfb2vSk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnYh1KcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnYh1KcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76749C4CED6;
	Wed, 20 Nov 2024 12:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107530;
	bh=xwoH31GqDcpTfBo4AsvGrm+bxZ3Y2rYlNlc933kWcTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnYh1KcPhB9ql/1DKUJcD/WBNO2QYFIAQcjiic4+p5LU4HJ4xJQafayk+j9rccafz
	 rCajjIh/7/++Ppex6QKCN1GVmnpXbPgeRJ3QuiznCcQkIe+i4ca0yAdQGqsySQijlV
	 XDMgZYplka63qRkVyV7u7VR2WrZBzGiYXaJVHfjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 063/107] ALSA: hda/realtek - update set GPIO3 to default for Thinkpad with ALC1318
Date: Wed, 20 Nov 2024 13:56:38 +0100
Message-ID: <20241120125631.097891404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 2143c8ae423dbc3f036cae8d18a5a3c272df3deb upstream.

If user no update BIOS, the speaker will no sound.
This patch support old BIOS to have sound from speaker.

Fixes: 1e707769df07 ("ALSA: hda/realtek - Set GPIO3 to default at S4 state for Thinkpad with ALC1318")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7436,7 +7436,6 @@ static void alc287_alc1318_playback_pcm_
 				   struct snd_pcm_substream *substream,
 				   int action)
 {
-	alc_write_coef_idx(codec, 0x10, 0x8806); /* Change MLK to GPIO3 */
 	switch (action) {
 	case HDA_GEN_PCM_ACT_OPEN:
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x954f); /* write gpio3 to high */
@@ -7450,7 +7449,6 @@ static void alc287_alc1318_playback_pcm_
 static void alc287_s4_power_gpio3_default(struct hda_codec *codec)
 {
 	if (is_s4_suspend(codec)) {
-		alc_write_coef_idx(codec, 0x10, 0x8806); /* Change MLK to GPIO3 */
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x554f); /* write gpio3 as default value */
 	}
 }
@@ -7459,9 +7457,17 @@ static void alc287_fixup_lenovo_thinkpad
 			       const struct hda_fixup *fix, int action)
 {
 	struct alc_spec *spec = codec->spec;
+	static const struct coef_fw coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC300),
+		WRITE_COEF(0x28, 0x0001), WRITE_COEF(0x29, 0xb023),
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC301),
+		WRITE_COEF(0x28, 0x0001), WRITE_COEF(0x29, 0xb023),
+	};
 
 	if (action != HDA_FIXUP_ACT_PRE_PROBE)
 		return;
+	alc_update_coef_idx(codec, 0x10, 1<<11, 1<<11);
+	alc_process_coef_fw(codec, coefs);
 	spec->power_hook = alc287_s4_power_gpio3_default;
 	spec->gen.pcm_playback_hook = alc287_alc1318_playback_pcm_hook;
 }


