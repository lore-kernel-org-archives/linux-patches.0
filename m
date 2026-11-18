Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047150;
	b=QpgA9usWHUnnxxglbS6t2JwuBDhVR2/KQJf64yOL1ZnhWFqqjipFpq0sryYaIV/Ah0Xm
	 mGZpouFqfdW+1+9qIGlw06Hc0VLxfOIX1/pVi2crMzltYPZmdVmQQx8pQSljR+wtRORgV
	 SuNzdW4IGEUIm4vJ3QW4a7qf7J/hgSJn0EQipxzVzyj6ElZbxSWBzFZFqZdgDrW5xLc0k
	 MB+UDUc1Rxw49ez9Z4hI2CK73tz133dVg+FwYfT/NIgxzBn6uCuYPKIPaM+3vRMy6NY7s
	 httJRS1lxLr1sCR7nQYUaLvp5bwGi+2B4LJpCdYK5soc1iK9K7EeKy5IQASV0w1Wfjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=katE0KlPG8ea4nBf+AqK3eE0/4yMWMV3KjSWcc0a5cc=;
	b=O/+/XS6BsBggcC7gY2qk+kVCzHlduSEtCeeMWq/DvBp2JB19MgMtKjDe1hLgTj07a2Db
	 gOQ6aWuTj3MhceMEU/J5Gb4zTsuk58rilBDuIRXiroaoxZTe8a/JjXOUXS+x50K4EU68A
	 Oq/NlPzLgo0EktkCo92L7Jf1W38F/EhkJno8Y09RqjPlIZ5Td6GDXxViPiPdG0Irts3o3
	 7DXCs2gqIlwt1Krw/ekQgczdko0d3PUkEfF4MA8L5IG0liEhF1PaJng0GUs46uXQ8qcEz
	 NqiJgHCGBCAGzz5WDdXvBUjuwvS6Pewu3Igay/Gq8b9R3r5pUkswJbDEKkUocoetfng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNCZ9vyG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DC7606A325;
	Thu, 19 Nov 2026 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UNCZ9vyG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85FB1F000C4;
	Thu, 19 Nov 2026 00:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047150;
	bh=katE0KlPG8ea4nBf+AqK3eE0/4yMWMV3KjSWcc0a5cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNCZ9vyGeXgPnjDBlnGFPKkm567uydxt0QOk7cuWjafVFihWjPdwkheIifqdSp9uy
	 vAV31BDNu5mHUbgN7Ra+2GliVZ68NRQKwsHuuzLYcXksOguUxbaYP+yBJowg/M81od
	 79QN8jpt657D8g+fP1sxzFcPB9lIcf79oRKC23cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1509/2857] ALSA: emux: centralize & improve patch info validation
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118150255.667319799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8c1e7f2bfc34a..ab4f988f080dc 100644
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
index 2e37d91153a05..968c8d3f16cb0 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -677,6 +677,21 @@ find_sample(struct snd_soundfont *sf, int sample_id)
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
@@ -718,6 +733,21 @@ load_data(struct snd_sf_list *sflist, const void __user *data, long count)
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
 	sp = sf_sample_new(sflist, sf);
 	if (!sp)
@@ -968,6 +998,11 @@ load_guspatch(struct snd_card *card,
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
@@ -1005,7 +1040,7 @@ load_guspatch(struct snd_card *card,
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



