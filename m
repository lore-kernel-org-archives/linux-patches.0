Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059705;
	b=th1JGGbRc3PIrpCA/uhSjy1/OAO+NBLopf6/msu9HZYxh2IRRghgcqqffBFmi6hHU++9
	 XVlqMB/U03m4tZE2tRly12XlvugGsvMmoAyUrgxydvJuXUN2ymbZcu/+SjpAxHDfqJJde
	 7vf1XOvDxtqgDeZYxZPGT8iVrpF/zLm+H8dye35kXnr8JYVsRrPTN3qXEma10i/P47D17
	 9EuO6sx5RZ6frdR5I9eHYCa51O8o8Xnq9v+zBVqBPq4PlkCSjUWlKX4r2bqrytLA+YeNL
	 xylWFi/6EFvo8JOA+uriwlJ7B2rVSm8S9VrCuUWpn/+leLnORTnvggl0eYUXOxqyQXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBQNYwK3U/v/Hwmtuzi8ndiF5fSdK5BoSb7ZJofz6Bg=;
	b=5nUlBd4hv2itx3D7Dxw6UyC3CtUD8e1eYKQ50OYbuVrWEtVFQ9VQGuYqbBjkgjuthO3u
	 1dphchBf50nG4mV2EZI7xQTOTfzv8PPqJLMtY//D1MISK9L3rN/4iF0GB51EEOFXjnxAj
	 7tFcPKy+P3BAgtxLfnM1HcCGHFxSmZUo6Pm2O0YKNFY1iBT2pgPY6wM/ybCugJhDxNPIF
	 CEU0RFAeqiCiJQu9vdev3/chE3Qbih61VW4em8iOIf+KyeadEg+wacXyJjCIJHRyI9FZV
	 VB9mGQsVmvNwqpG71pD1zOQL53PetlQZbfa4x8u6FM3Ot3LanCP1g7L2aCULQOE7nOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrc+1fbR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9547606A32C;
	Thu, 19 Nov 2026 03:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrc+1fbR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDC21F000C4;
	Thu, 19 Nov 2026 03:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059705;
	bh=BBQNYwK3U/v/Hwmtuzi8ndiF5fSdK5BoSb7ZJofz6Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrc+1fbR7iXMK7br8c6/sATiJVoDTkHSw7PZ3KpzSb+BpPwe+UAvZYCjsLFNS3M+E
	 +DAUO700gIeIgl0B4J5vxcCJWYyW7WND7b1NkCmw68qxJlLVHAUaWR6qnYYU/slfbi
	 /Izkj8KsWrsnZ32pfXNW+TCRD5XZw0f76RI0E8cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0930/1848] ALSA: emux: simplify snd_sf_list.callback handling
Date: Wed, 18 Nov 2026 15:49:28 +0100
Message-ID: <20261118145955.696050348@linuxfoundation.org>
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

[ Upstream commit 4c4cbe66828f185903d2127aed6ac9b7302e9d3a ]

Both drivers provide both sample_new and sample_free, and it makes no
sense to pretend that they could not. In fact, load_data() would already
crash if sample_new was null. So remove the remaining null checks.

Contrary to that, the emu10k1 driver actually has a null sample_reset,
though I'm not convinced that this inconsistency is justified.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-18-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 8a5d87c2ba30 ("ALSA: emux: Stop voices before freeing zones in all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux.c      |  6 ++----
 sound/synth/emux/soundfont.c | 12 +++++-------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index c60ff81390a44..8e080a4bcd16f 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -94,10 +94,8 @@ int snd_emux_register(struct snd_emux *emu, struct snd_card *card, int index, ch
 	/* create soundfont list */
 	memset(&sf_cb, 0, sizeof(sf_cb));
 	sf_cb.private_data = emu;
-	if (emu->ops.sample_new)
-		sf_cb.sample_new = sf_sample_new;
-	if (emu->ops.sample_free)
-		sf_cb.sample_free = sf_sample_free;
+	sf_cb.sample_new = sf_sample_new;
+	sf_cb.sample_free = sf_sample_free;
 	if (emu->ops.sample_reset)
 		sf_cb.sample_reset = sf_sample_reset;
 	emu->sflist = snd_sf_new(&sf_cb, emu->memhdr);
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index f76c3b21401d6..1266604cf33be 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -1044,7 +1044,7 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data,
 	/*
 	 * load wave data
 	 */
-	if (smp->v.size > 0 && sflist->callback.sample_new) {
+	if (smp->v.size > 0) {
 		rc = sflist->callback.sample_new
 			(sflist->callback.private_data, smp, sflist->memhdr,
 			 data, count);
@@ -1405,9 +1405,8 @@ snd_sf_clear(struct snd_sf_list *sflist)
 		}
 		for (sp = sf->samples; sp; sp = nextsp) {
 			nextsp = sp->next;
-			if (sflist->callback.sample_free)
-				sflist->callback.sample_free(sflist->callback.private_data,
-							     sp, sflist->memhdr);
+			sflist->callback.sample_free(sflist->callback.private_data,
+						     sp, sflist->memhdr);
 			kfree(sp);
 		}
 		kfree(sf);
@@ -1508,9 +1507,8 @@ snd_soundfont_remove_unlocked(struct snd_sf_list *sflist)
 			nextsp = sp->next;
 			sf->samples = nextsp;
 			sflist->mem_used -= sp->v.truesize;
-			if (sflist->callback.sample_free)
-				sflist->callback.sample_free(sflist->callback.private_data,
-							     sp, sflist->memhdr);
+			sflist->callback.sample_free(sflist->callback.private_data,
+						     sp, sflist->memhdr);
 			kfree(sp);
 		}
 	}
-- 
2.53.0



