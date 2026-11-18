Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053957;
	b=dcXcEtr0T3RCu3SqgaJ9PLRo5Nzglsv8aIweswxrsg8vMl8E4p73B/tfBn4G9eddSXtc
	 BWLcSXQTwftSea2jR/9a1H/hMnI26CNgEo1QzdM26zAVrhYd6WSH8+vh4uRy/g8AMS/bP
	 DiO6exMOObbtDBNC+FRWlrsDBvIZvfB8/+vbhPssvBSHVX9OQVLyClj0VN90NM2tGQUfU
	 yo/IVESW70V3POYEHCZV3Cwshpi3zLyNAQJppeMVIUIoIKy30fVbAUIc12CEiXH0xUVdE
	 L8Eo5NS/DI/lAZXoU+2PuDLJ2XDobAO2Icjy56uF1drpNO4SeR3hlDelv1FgzobaTlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Cx84FVAARyGGg9VNZMRT9VJxVPDusM4zKJ4/acTArg=;
	b=L0WmQpSlNF6r7e/vgDEEFWm5JawKEW2+AZyRqutDNOdzdyKn1FO0ClJQwBpMjCLLU0uk
	 mA0cZf5oFqOwTgGh7XUXl05w6o98A79qmC+6Tcs+mBBI6jQww4fKTq80reFnbzvpSL7YC
	 EmAwZyhwpOtFp19pq5S4C2krumIWIRARAavtcnfiWxFiJrvnjOby+QuU3KVYcGQMTwK+5
	 ld61Bylebkhp8YR3V99O82XS3dyR1RICCcg+mySj+ENY8MrkJZ+3QwO/5h0DFc9BkZfmh
	 f8KSTOX+Lj/PPvEgRQSN/j/gP2b8nPpJF+jPV2WharP7/q8ArMqD+qkZt+XJ1vMxS0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXWEOJHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5639606A330;
	Thu, 19 Nov 2026 02:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXWEOJHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A3D1F000C5;
	Thu, 19 Nov 2026 02:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053957;
	bh=7Cx84FVAARyGGg9VNZMRT9VJxVPDusM4zKJ4/acTArg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXWEOJHgAvEieum1/7vMOYCsajwlwVRss0ofhZfKsGWvqWnAkfZLslFDshcuLapdv
	 uQVDH7egezvWXv50ASAwW2rHVJIyTcjycGyfIW58As+19QtVFAmauCrPd+eyGHAzIa
	 UPTpeU+nOpGWPOakJd5+3qEErdQzDbKe+IrlSy4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1103/2214] ALSA: emu10k1: prune vestiges of SNDRV_SFNT_SAMPLE_{BIDIR,REVERSE}_LOOP support
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118150056.301567847@linuxfoundation.org>
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



