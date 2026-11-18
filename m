Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038501;
	b=NDUNkmk7qfm1hISMtXZXNA6JxLv9CTmilehRbjcNJwCzaCTw1sQ+1q9aq58qD+9T6VMM
	 1CFlEpQlzc156Ju6o20Mv2lkmN1VR4OOsj+jd5hprfG2s6uSJTf0/2DZYtdw5ND+h61/U
	 5+1hQcmtG5Ynle7kuIW8pz+b/Okx85krJCOboGGK3p8C5FmasmKsFJcShRkKrxuzdYTDh
	 0fEpl5mDvxDgy8zMD7F4TlFAg0pUmIj4cyZ4SBwuugI9IVE8zd6qsjuaZUF4Er8uIxB4+
	 ZbZvnSFENlm/Btr7k3+Z/e3ZkmqmpORzcVV/dh7GdtAU7E6gY874h8glouF6gI9XDPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AljFDUIsY37VmB/IgcWzXg9/TDvEReDuP5Sd2XliKzc=;
	b=VhaS+mbTp8dA1UCnD1faClovChPHF40lF58bFKgXrgDTRMFy8jTN1Qr/JoQTfrOWMZQd
	 O4ZT0RrVgcOTH80xrlT6V3diRxyGPhegvcIubcTt+9trBmQ9VvTiyqgHgFP5UR+dVv9eM
	 iaEdR664i++flMNzHPjPH7pjCgx0yFLj14+bjVARkIPpoTEFVrSpJdc98xUuMKF5g6nsT
	 ajm5xQ3L9Qma2rxx4Z5M2bJ4cP+ch7QoIqeMHMUiZOl/sBzrsCCBRFIiNx7hr3tWdxolU
	 owsFdWsUgwOR34GMr8mNix23oStWSpJ99vQOdqc3d7T55Y2JvDluUJkp7cHIo1km8ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5T56c8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC68F606A32A;
	Wed, 18 Nov 2026 21:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5T56c8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D9B1F000C4;
	Wed, 18 Nov 2026 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038500;
	bh=AljFDUIsY37VmB/IgcWzXg9/TDvEReDuP5Sd2XliKzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5T56c8j4/z8tM4djtwHcKztee33uAeAOHYUr8gN7zciZqDIkCZShiT1Sm6tDaNwi
	 UX5qXYPXH8jIEoLCEWOUI6IgT2PmmSMh76kf4xOdXQPdX1z5E0W+fyOWL0WD9hCW87
	 Z2pyZCKWOoi4GPm2QnmrH9wWT366Q9ny4/2/RVFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1765/3318] ALSA: emu10k1: prune vestiges of SNDRV_SFNT_SAMPLE_{BIDIR,REVERSE}_LOOP support
Date: Wed, 18 Nov 2026 15:39:47 +0100
Message-ID: <20261118150414.804118747@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 1edeac6555e9df008b1729ca445868c1177baa8b ]

This is required only to implement WAVE_BIDIR_LOOP and WAVE_LOOP_BACK in
the GUS patch loader. It has not worked on emu10k1 since before ALSA hit
mainline, yet nobody appears to have complained. And as it isn't super
easy to implement, just admit defeat and clean up the code.

If somebody wanted to resurrect the feature, the emu8k driver could
serve as a template, but the code would be quite different. But
arguably, this should be done in user space in the first place, as this
doesn't represent a hardware feature (somewhat ironically, the actual
GUS driver has no synth support, and therefore no GUS patch loader).

Note that instead of properly rejecting affected samples, we continue to
just pretend that the feature wasn't requested. This is extremely
questionable behavior, but avoids that possibly unused instruments
suddenly prevent loading the entire file, which would break backwards
compatibility. But at least we log a warning now.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-6-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 8a5d87c2ba30 ("ALSA: emux: Stop voices before freeing zones in all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/emu10k1/emu10k1_patch.c | 73 ++++---------------------------
 1 file changed, 8 insertions(+), 65 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_patch.c b/sound/pci/emu10k1/emu10k1_patch.c
index 89890f24509f0..49214c2268084 100644
--- a/sound/pci/emu10k1/emu10k1_patch.c
+++ b/sound/pci/emu10k1/emu10k1_patch.c
@@ -28,8 +28,6 @@ snd_emu10k1_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 {
 	int offset;
 	int truesize, size, blocksize;
-	__maybe_unused int loopsize;
-	int loopend, sampleend;
 	unsigned int start_addr;
 	struct snd_emu10k1 *emu;
 
@@ -43,32 +41,24 @@ snd_emu10k1_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 		return 0;
 	}
 
+	if (sp->v.mode_flags & (SNDRV_SFNT_SAMPLE_BIDIR_LOOP | SNDRV_SFNT_SAMPLE_REVERSE_LOOP)) {
+		/* should instead return -ENOTSUPP; but compatibility */
+		printk(KERN_WARNING "Emu10k1 wavetable patch %d with unsupported loop feature\n",
+		       sp->v.sample);
+	}
+
 	/* recalculate address offset */
 	sp->v.end -= sp->v.start;
 	sp->v.loopstart -= sp->v.start;
 	sp->v.loopend -= sp->v.start;
 	sp->v.start = 0;
 
-	/* some samples have invalid data.  the addresses are corrected in voice info */
-	sampleend = sp->v.end;
-	if (sampleend > sp->v.size)
-		sampleend = sp->v.size;
-	loopend = sp->v.loopend;
-	if (loopend > sampleend)
-		loopend = sampleend;
-
 	/* be sure loop points start < end */
 	if (sp->v.loopstart >= sp->v.loopend)
 		swap(sp->v.loopstart, sp->v.loopend);
 
 	/* compute true data size to be loaded */
 	truesize = sp->v.size + BLANK_HEAD_SIZE;
-	loopsize = 0;
-#if 0 /* not supported */
-	if (sp->v.mode_flags & (SNDRV_SFNT_SAMPLE_BIDIR_LOOP|SNDRV_SFNT_SAMPLE_REVERSE_LOOP))
-		loopsize = sp->v.loopend - sp->v.loopstart;
-	truesize += loopsize;
-#endif
 	if (sp->v.mode_flags & SNDRV_SFNT_SAMPLE_NO_BLANK)
 		truesize += BLANK_LOOP_SIZE;
 
@@ -96,8 +86,8 @@ snd_emu10k1_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 	snd_emu10k1_synth_bzero(emu, sp->block, offset, size);
 	offset += size;
 
-	/* copy start->loopend */
-	size = loopend;
+	/* copy provided samples */
+	size = sp->v.size;
 	if (! (sp->v.mode_flags & SNDRV_SFNT_SAMPLE_8BITS))
 		size *= 2;
 	if (offset + size > blocksize)
@@ -108,53 +98,6 @@ snd_emu10k1_sample_new(struct snd_emux *rec, struct snd_sf_sample *sp,
 		return -EFAULT;
 	}
 	offset += size;
-	data += size;
-
-#if 0 /* not supported yet */
-	/* handle reverse (or bidirectional) loop */
-	if (sp->v.mode_flags & (SNDRV_SFNT_SAMPLE_BIDIR_LOOP|SNDRV_SFNT_SAMPLE_REVERSE_LOOP)) {
-		/* copy loop in reverse */
-		if (! (sp->v.mode_flags & SNDRV_SFNT_SAMPLE_8BITS)) {
-			int woffset;
-			unsigned short *wblock = (unsigned short*)block;
-			woffset = offset / 2;
-			if (offset + loopsize * 2 > blocksize)
-				return -EINVAL;
-			for (i = 0; i < loopsize; i++)
-				wblock[woffset + i] = wblock[woffset - i -1];
-			offset += loopsize * 2;
-		} else {
-			if (offset + loopsize > blocksize)
-				return -EINVAL;
-			for (i = 0; i < loopsize; i++)
-				block[offset + i] = block[offset - i -1];
-			offset += loopsize;
-		}
-
-		/* modify loop pointers */
-		if (sp->v.mode_flags & SNDRV_SFNT_SAMPLE_BIDIR_LOOP) {
-			sp->v.loopend += loopsize;
-		} else {
-			sp->v.loopstart += loopsize;
-			sp->v.loopend += loopsize;
-		}
-		/* add sample pointer */
-		sp->v.end += loopsize;
-	}
-#endif
-
-	/* loopend -> sample end */
-	size = sp->v.size - loopend;
-	if (size < 0)
-		return -EINVAL;
-	if (! (sp->v.mode_flags & SNDRV_SFNT_SAMPLE_8BITS))
-		size *= 2;
-	if (snd_emu10k1_synth_copy_from_user(emu, sp->block, offset, data, size)) {
-		snd_emu10k1_synth_free(emu, sp->block);
-		sp->block = NULL;
-		return -EFAULT;
-	}
-	offset += size;
 
 	/* clear rest of samples (if any) */
 	if (offset < blocksize)
-- 
2.53.0



