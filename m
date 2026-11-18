Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059825;
	b=W8jVASgsCaNrfkrXuTMC4xdz1LvdmJVBSvCoMoTlfZ363kQ+zfZbPV87Zw+W+JK/Ox8e
	 E2vCA7UrSO6NvAM4XPI9LkBj8wEyqwBFzz76sW27jN3xCGJgog7ckCZupSPYG6U9uiB22
	 /NI+U/QlZhUnYeUZUh6WpIJCvAREYxSAtyb+WbPJUFC/pgtRCUAP+xYxbbT9Lb2kbZPSB
	 QvfVIL5Zu6Xs8DsIakLh2Nn78OFHuQmR4Vv+37GLOfexvTgL2jrHrCsuJt/IzRtCoswZZ
	 F7H0qVk200AN3x49mrQZfFJ6WfIsvV0KH3RxIob0JMaM3U8ZdNh4ABk6UudZERGJ1Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iR0ptusAcAJ4OQxXAgIIDBR/PFho2snco8GIZqSqUeo=;
	b=MnYVCvzf4ooNAWQizgG/JV7gilPD7Qx/zqPV3vSWTUpq4JafipfZAz53gic8t/Rx++qD
	 OCno7v7APYhvHBDchvwV02GNGF3R88pBW13jdWKlggIgH6IkkbIeIEDXNKrbAjruOtDlA
	 Kln04ACxO/mVzec/UaKV6kXpw0Usd0NiWePPKHDTaf/YJNFU7kgCWKNnNxZZaB76caqQg
	 yv1uSXfSigOGaWjtlI6X/1cGmAj23cKqyRA57KLgBehKqnlHRFDqi9zr22mwQZagzVZ7h
	 oZC7urs7wu0pAp8e1huOesM4YEakgVkrUNvIbfD55Gj9/kmKFnaE4B6UmuxciaCXNTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BNSKb/h3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27E1606A320;
	Thu, 19 Nov 2026 03:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNSKb/h3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535A41F000C4;
	Thu, 19 Nov 2026 03:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059824;
	bh=iR0ptusAcAJ4OQxXAgIIDBR/PFho2snco8GIZqSqUeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNSKb/h3zF0JdmQ5Lmk8vNGpGB9Ab1InfWgqruyMfBtbziJln2aOyZz4KQeKALEcp
	 sXrbtNFuPtWtoSo3sMXtN8kTo347Ii4c6L+pvTx447SfN8nFJs7JyMzL8hJtlAG0pB
	 RhKMaIjq3ltWCZt/HPA0j68Qg41vgVlS1sdF0vNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0929/1848] ALSA: emux: centralize & improve patch info validation
Date: Wed, 18 Nov 2026 15:49:27 +0100
Message-ID: <20261118145955.659612410@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit de67aab120d4d5ba7d9e94ee5b25464ae0d1bd0e ]

This does several closely related things:
- Move the code from the drivers into the SoundFont loader, which
  de-duplicates it.
- Sort of explain the weird "recalculate address offset" feature. Note
  that I don't think it actually makes any sense - the calling user
  space code should do that. The background is certainly that the source
  data (the SoundFont format) uses pointers into a single wave block
  (and the API allows doing the same for on-board ROM), but the API
  expects the wave data from user space to be pre-chopped into
  individual patches anyway.
- Make sure that the specified offsets actually lie within the supplied
  wave data. Note that we don't validate ROM offsets, so one can play
  back anything within the sound card's address space.
- In load_guspatch(), don't call the sample_new callback anymore when
  the patch size is zero, as was already the case in load_data(). The
  callbacks would instantly return in that case anyway; these checks are
  now removed.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-7-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 8a5d87c2ba30 ("ALSA: emux: Stop voices before freeing zones in all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/emu8000_patch.c      | 13 -----------
 sound/pci/emu10k1/emu10k1_patch.c | 16 -------------
 sound/synth/emux/soundfont.c      | 37 ++++++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/sound/isa/sb/emu8000_patch.c b/sound/isa/sb/emu8000_patch.c
index 0cb94cafb4c9b..b8b9edd98ac6a 100644
--- a/sound/isa/sb/emu8000_patch.c
+++ b/sound/isa/sb/emu8000_patch.c
@@ -148,13 +148,6 @@ snd_emu8000_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 	if (snd_BUG_ON(!sp))
 		return -EINVAL;
 
-	if (sp->v.size == 0)
-		return 0;
-
-	/* be sure loop points start < end */
-	if (sp->v.loopstart > sp->v.loopend)
-		swap(sp->v.loopstart, sp->v.loopend);
-
 	/* compute true data size to be loaded */
 	truesize = sp->v.size;
 	if (sp->v.mode_flags & (SNDRV_SFNT_SAMPLE_BIDIR_LOOP|SNDRV_SFNT_SAMPLE_REVERSE_LOOP))
@@ -177,12 +170,6 @@ snd_emu8000_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 			return -EFAULT;
 	}
 
-	/* recalculate address offset */
-	sp->v.end -= sp->v.start;
-	sp->v.loopstart -= sp->v.start;
-	sp->v.loopend -= sp->v.start;
-	sp->v.start = 0;
-
 	/* dram position (in word) -- mem_offset is byte */
 	dram_offset = EMU8000_DRAM_OFFSET + (sp->block->offset >> 1);
 	dram_start = dram_offset;
diff --git a/sound/pci/emu10k1/emu10k1_patch.c b/sound/pci/emu10k1/emu10k1_patch.c
index 49214c2268084..47d69a0e44bc6 100644
--- a/sound/pci/emu10k1/emu10k1_patch.c
+++ b/sound/pci/emu10k1/emu10k1_patch.c
@@ -35,28 +35,12 @@ snd_emu10k1_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 	if (snd_BUG_ON(!sp || !hdr))
 		return -EINVAL;
 
-	if (sp->v.size == 0) {
-		dev_dbg(emu->card->dev,
-			"emu: rom font for sample %d\n", sp->v.sample);
-		return 0;
-	}
-
 	if (sp->v.mode_flags & (SNDRV_SFNT_SAMPLE_BIDIR_LOOP | SNDRV_SFNT_SAMPLE_REVERSE_LOOP)) {
 		/* should instead return -ENOTSUPP; but compatibility */
 		printk(KERN_WARNING "Emu10k1 wavetable patch %d with unsupported loop feature\n",
 		       sp->v.sample);
 	}
 
-	/* recalculate address offset */
-	sp->v.end -= sp->v.start;
-	sp->v.loopstart -= sp->v.start;
-	sp->v.loopend -= sp->v.start;
-	sp->v.start = 0;
-
-	/* be sure loop points start < end */
-	if (sp->v.loopstart >= sp->v.loopend)
-		swap(sp->v.loopstart, sp->v.loopend);
-
 	/* compute true data size to be loaded */
 	truesize = sp->v.size + BLANK_HEAD_SIZE;
 	if (sp->v.mode_flags & SNDRV_SFNT_SAMPLE_NO_BLANK)
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index ca3e100a637e4..f76c3b21401d6 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -685,6 +685,21 @@ find_sample(struct snd_soundfont *sf, int sample_id)
 }
 
 
+static int
+validate_sample_info(struct soundfont_sample_info *si)
+{
+	if (si->end < 0 || si->end > si->size)
+		return -EINVAL;
+	if (si->loopstart < 0 || si->loopstart > si->end)
+		return -EINVAL;
+	if (si->loopend < 0 || si->loopend > si->end)
+		return -EINVAL;
+	/* be sure loop points start < end */
+	if (si->loopstart > si->loopend)
+		swap(si->loopstart, si->loopend);
+	return 0;
+}
+
 /*
  * Load sample information, this can include data to be loaded onto
  * the soundcard.  It can also just be a pointer into soundcard ROM.
@@ -725,6 +740,21 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
 		return -EINVAL;
 	}
 
+	if (sample_info.size > 0) {
+		if (sample_info.start < 0)
+			return -EINVAL;
+
+		// Here we "rebase out" the start address, because the
+		// real start is the start of the provided sample data.
+		sample_info.end -= sample_info.start;
+		sample_info.loopstart -= sample_info.start;
+		sample_info.loopend -= sample_info.start;
+		sample_info.start = 0;
+
+		if (validate_sample_info(&sample_info) < 0)
+			return -EINVAL;
+	}
+
 	/* Allocate a new sample structure */
 	if ((sp = sf_sample_new(sflist, sf)) == NULL)
 		return -ENOMEM;
@@ -973,6 +1003,11 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
 	smp->v.loopend = patch.loop_end;
 	smp->v.size = patch.len;
 
+	if (validate_sample_info(&smp->v) < 0) {
+		sf_sample_delete(sflist, sf, smp);
+		return -EINVAL;
+	}
+
 	/* set up mode flags */
 	smp->v.mode_flags = 0;
 	if (!(patch.mode & WAVE_16_BITS))
@@ -1009,7 +1044,7 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
 	/*
 	 * load wave data
 	 */
-	if (sflist->callback.sample_new) {
+	if (smp->v.size > 0 && sflist->callback.sample_new) {
 		rc = sflist->callback.sample_new
 			(sflist->callback.private_data, smp, sflist->memhdr,
 			 data, count);
-- 
2.53.0



