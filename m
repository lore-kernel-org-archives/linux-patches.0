Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047029;
	b=Rq4QR/VwYsxaNgCtEuvEreDNS3l5k/CUMFBKP+JBa/DDDW9ccVG3ISQvfYi/WQBpBG0P
	 1c2XMbRWiJ0ZJM0tRQpOG+oyUfv2LReLCuI+zDOoPemfAGCrjTr0OrNXptU9kfokdATRs
	 WqGsjQfkj/+wQFNAAtAcmmblOO51+nifA9TGmZq/p7Uy+7aEM780ahvqKiOa0kdkrGcSE
	 Tjit/a+jqGtkudc1lq7Kr5GXb7UY+3+BIS3VhuBcwSE0+evNjSqq3U0mbo8Hqq+sCjOam
	 ww+JtejHvDkn3k6wHm6goUZ81wRbwICVe3MjbsUIOQriJbDMaaXLoffM8jvLYoXQRCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=juxB2VMJHEoVdLIXNIwOPglR5tCgxuvdp0qAVpOm2rM=;
	b=g7UpsS5CzdHuLqOmPow2zNF6D6Tapdu2tqlwaXNxhNwdyL4rfYDlXVKNWvvv5aOYPZJW
	 VknLrDADbwagtzLfI499EMCHzIxBP1Ec47tGuiIbPJU74LpV91w5XP8TPjVhuEomCXtWn
	 KrI4cYjokM1qvBEwd66na7SAFWwhvrtAp2zjQgz8WjdmNpsj0H4j3Tw6l3D3ZAW8FqYGG
	 Qdc841mlvs0JR35ucHuzIS9vPhCPFBd0gLWhi7q8YlkUB9aHUzUjrfS84BED++cU/NY9W
	 0NMcCnVtMvr65kVl+fZ0RxuhorJNRND1jSUDksK5oFhw9r8UFc4Ch/x8PkFN5l37+5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSbjQmoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2953C60A381F;
	Thu, 19 Nov 2026 00:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SSbjQmoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7953C1F000C8;
	Thu, 19 Nov 2026 00:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047029;
	bh=juxB2VMJHEoVdLIXNIwOPglR5tCgxuvdp0qAVpOm2rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSbjQmoSc8u3D4o2zgF8fuP6ZC2ZVG1wNpQ9wZNy1SACEDQalpePOdlKTdlIS+/PT
	 j6kTiHeO7/9GIIAS/Ndsj4v3KOd5nOOwH419kTwsW78kxd80benANLwJCfACddlxDd
	 phxG9txXpLrjIATWvQekfFGVCsY5W6pzHjd0GuaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1492/2857] ALSA: emux: Use standard print API
Date: Wed, 18 Nov 2026 15:42:06 +0100
Message-ID: <20261118150255.050136464@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fea1510719dd2a33e0ffa1eae6118c5437f7071d ]

Use the standard print API with dev_*() instead of the old house-baked
one.  It gives better information and allows dynamically control of
debug prints.

Some functions are changed to receive snd_card object for calling
dev_*() functions, too.

Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240807133452.9424-44-tiwai@suse.de
Stable-dep-of: 34e3e04b8a17 ("ALSA: emux: Fix UAF of soundfont zones at note-on")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soundfont.h     |  6 ++--
 sound/synth/emux/emux_hwdep.c |  6 ++--
 sound/synth/emux/emux_oss.c   | 11 +++---
 sound/synth/emux/emux_seq.c   | 13 ++++---
 sound/synth/emux/emux_synth.c | 12 +++----
 sound/synth/emux/soundfont.c  | 67 +++++++++++++++++++----------------
 6 files changed, 63 insertions(+), 52 deletions(-)

diff --git a/include/sound/soundfont.h b/include/sound/soundfont.h
index 98ed98d89d6de..8a40cc15f66db 100644
--- a/include/sound/soundfont.h
+++ b/include/sound/soundfont.h
@@ -86,9 +86,11 @@ struct snd_sf_list {
 };
 
 /* Prototypes for soundfont.c */
-int snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
+int snd_soundfont_load(struct snd_card *card,
+		       struct snd_sf_list *sflist, const void __user *data,
 		       long count, int client);
-int snd_soundfont_load_guspatch(struct snd_sf_list *sflist, const char __user *data,
+int snd_soundfont_load_guspatch(struct snd_card *card,
+				struct snd_sf_list *sflist, const char __user *data,
 				long count);
 int snd_soundfont_close_check(struct snd_sf_list *sflist, int client);
 
diff --git a/sound/synth/emux/emux_hwdep.c b/sound/synth/emux/emux_hwdep.c
index fd8f978cde1c6..9e98c4c73fd1e 100644
--- a/sound/synth/emux/emux_hwdep.c
+++ b/sound/synth/emux/emux_hwdep.c
@@ -26,12 +26,14 @@ snd_emux_hwdep_load_patch(struct snd_emux *emu, void __user *arg)
 		return -EFAULT;
 
 	if (patch.key == GUS_PATCH)
-		return snd_soundfont_load_guspatch(emu->sflist, arg,
+		return snd_soundfont_load_guspatch(emu->card, emu->sflist, arg,
 						   patch.len + sizeof(patch));
 
 	if (patch.type >= SNDRV_SFNT_LOAD_INFO &&
 	    patch.type <= SNDRV_SFNT_PROBE_DATA) {
-		err = snd_soundfont_load(emu->sflist, arg, patch.len + sizeof(patch), TMP_CLIENT_ID);
+		err = snd_soundfont_load(emu->card, emu->sflist, arg,
+					 patch.len + sizeof(patch),
+					 TMP_CLIENT_ID);
 		if (err < 0)
 			return err;
 	} else {
diff --git a/sound/synth/emux/emux_oss.c b/sound/synth/emux/emux_oss.c
index 04df46b269d37..5f98d5201ba25 100644
--- a/sound/synth/emux/emux_oss.c
+++ b/sound/synth/emux/emux_oss.c
@@ -115,7 +115,7 @@ snd_emux_open_seq_oss(struct snd_seq_oss_arg *arg, void *closure)
 	p = snd_emux_create_port(emu, tmpname, 32,
 				 1, &callback);
 	if (p == NULL) {
-		snd_printk(KERN_ERR "can't create port\n");
+		dev_err(emu->card->dev, "can't create port\n");
 		snd_emux_dec_count(emu);
 		return -ENOMEM;
 	}
@@ -205,7 +205,7 @@ snd_emux_load_patch_seq_oss(struct snd_seq_oss_arg *arg, int format,
 		return -ENXIO;
 
 	if (format == GUS_PATCH)
-		rc = snd_soundfont_load_guspatch(emu->sflist, buf, count);
+		rc = snd_soundfont_load_guspatch(emu->card, emu->sflist, buf, count);
 	else if (format == SNDRV_OSS_SOUNDFONT_PATCH) {
 		struct soundfont_patch_info patch;
 		if (count < (int)sizeof(patch))
@@ -214,10 +214,13 @@ snd_emux_load_patch_seq_oss(struct snd_seq_oss_arg *arg, int format,
 			return -EFAULT;
 		if (patch.type >= SNDRV_SFNT_LOAD_INFO &&
 		    patch.type <= SNDRV_SFNT_PROBE_DATA)
-			rc = snd_soundfont_load(emu->sflist, buf, count, SF_CLIENT_NO(p->chset.port));
+			rc = snd_soundfont_load(emu->card, emu->sflist, buf,
+						count,
+						SF_CLIENT_NO(p->chset.port));
 		else {
 			if (emu->ops.load_fx)
-				rc = emu->ops.load_fx(emu, patch.type, patch.optarg, buf, count);
+				rc = emu->ops.load_fx(emu, patch.type,
+						      patch.optarg, buf, count);
 			else
 				rc = -EINVAL;
 		}
diff --git a/sound/synth/emux/emux_seq.c b/sound/synth/emux/emux_seq.c
index 1adaa75df2f6a..9daced0e6c59d 100644
--- a/sound/synth/emux/emux_seq.c
+++ b/sound/synth/emux/emux_seq.c
@@ -61,16 +61,17 @@ snd_emux_init_seq(struct snd_emux *emu, struct snd_card *card, int index)
 	emu->client = snd_seq_create_kernel_client(card, index,
 						   "%s WaveTable", emu->name);
 	if (emu->client < 0) {
-		snd_printk(KERN_ERR "can't create client\n");
+		dev_err(card->dev, "can't create client\n");
 		return -ENODEV;
 	}
 
 	if (emu->num_ports <= 0) {
-		snd_printk(KERN_WARNING "seqports must be greater than zero\n");
+		dev_warn(card->dev, "seqports must be greater than zero\n");
 		emu->num_ports = 1;
 	} else if (emu->num_ports > SNDRV_EMUX_MAX_PORTS) {
-		snd_printk(KERN_WARNING "too many ports. "
-			   "limited max. ports %d\n", SNDRV_EMUX_MAX_PORTS);
+		dev_warn(card->dev,
+			 "too many ports. limited max. ports %d\n",
+			 SNDRV_EMUX_MAX_PORTS);
 		emu->num_ports = SNDRV_EMUX_MAX_PORTS;
 	}
 
@@ -87,7 +88,7 @@ snd_emux_init_seq(struct snd_emux *emu, struct snd_card *card, int index)
 		p = snd_emux_create_port(emu, tmpname, MIDI_CHANNELS,
 					 0, &pinfo);
 		if (!p) {
-			snd_printk(KERN_ERR "can't create port\n");
+			dev_err(card->dev, "can't create port\n");
 			return -ENOMEM;
 		}
 
@@ -376,12 +377,10 @@ int snd_emux_init_virmidi(struct snd_emux *emu, struct snd_card *card)
 			goto __error;
 		}
 		emu->vmidi[i] = rmidi;
-		/* snd_printk(KERN_DEBUG "virmidi %d ok\n", i); */
 	}
 	return 0;
 
 __error:
-	/* snd_printk(KERN_DEBUG "error init..\n"); */
 	snd_emux_delete_virmidi(emu);
 	return -ENOMEM;
 }
diff --git a/sound/synth/emux/emux_synth.c b/sound/synth/emux/emux_synth.c
index a5385efcedb6c..ebf672cdbc31b 100644
--- a/sound/synth/emux/emux_synth.c
+++ b/sound/synth/emux/emux_synth.c
@@ -941,9 +941,9 @@ void snd_emux_lock_voice(struct snd_emux *emu, int voice)
 	if (emu->voices[voice].state == SNDRV_EMUX_ST_OFF)
 		emu->voices[voice].state = SNDRV_EMUX_ST_LOCKED;
 	else
-		snd_printk(KERN_WARNING
-			   "invalid voice for lock %d (state = %x)\n",
-			   voice, emu->voices[voice].state);
+		dev_warn(emu->card->dev,
+			 "invalid voice for lock %d (state = %x)\n",
+			 voice, emu->voices[voice].state);
 	spin_unlock_irqrestore(&emu->voice_lock, flags);
 }
 
@@ -959,9 +959,9 @@ void snd_emux_unlock_voice(struct snd_emux *emu, int voice)
 	if (emu->voices[voice].state == SNDRV_EMUX_ST_LOCKED)
 		emu->voices[voice].state = SNDRV_EMUX_ST_OFF;
 	else
-		snd_printk(KERN_WARNING
-			   "invalid voice for unlock %d (state = %x)\n",
-			   voice, emu->voices[voice].state);
+		dev_warn(emu->card->dev,
+			 "invalid voice for unlock %d (state = %x)\n",
+			 voice, emu->voices[voice].state);
 	spin_unlock_irqrestore(&emu->voice_lock, flags);
 }
 
diff --git a/sound/synth/emux/soundfont.c b/sound/synth/emux/soundfont.c
index 77144fe221cf2..03f70cceb4a86 100644
--- a/sound/synth/emux/soundfont.c
+++ b/sound/synth/emux/soundfont.c
@@ -38,7 +38,8 @@ static struct snd_sf_sample *sf_sample_new(struct snd_sf_list *sflist,
 static void sf_sample_delete(struct snd_sf_list *sflist,
 			     struct snd_soundfont *sf, struct snd_sf_sample *sp);
 static int load_map(struct snd_sf_list *sflist, const void __user *data, int count);
-static int load_info(struct snd_sf_list *sflist, const void __user *data, long count);
+static int load_info(struct snd_card *card, struct snd_sf_list *sflist,
+		     const void __user *data, long count);
 static int remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
 		       int bank, int instr);
 static void init_voice_info(struct soundfont_voice_info *avp);
@@ -113,7 +114,8 @@ snd_soundfont_close_check(struct snd_sf_list *sflist, int client)
  * it wants to do with it.
  */
 int
-snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
+snd_soundfont_load(struct snd_card *card,
+		   struct snd_sf_list *sflist, const void __user *data,
 		   long count, int client)
 {
 	struct soundfont_patch_info patch;
@@ -121,7 +123,7 @@ snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
 	int  rc;
 
 	if (count < (long)sizeof(patch)) {
-		snd_printk(KERN_ERR "patch record too small %ld\n", count);
+		dev_err(card->dev, "patch record too small %ld\n", count);
 		return -EINVAL;
 	}
 	if (copy_from_user(&patch, data, sizeof(patch)))
@@ -131,16 +133,16 @@ snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
 	data += sizeof(patch);
 
 	if (patch.key != SNDRV_OSS_SOUNDFONT_PATCH) {
-		snd_printk(KERN_ERR "The wrong kind of patch %x\n", patch.key);
+		dev_err(card->dev, "The wrong kind of patch %x\n", patch.key);
 		return -EINVAL;
 	}
 	if (count < patch.len) {
-		snd_printk(KERN_ERR "Patch too short %ld, need %d\n",
-			   count, patch.len);
+		dev_err(card->dev, "Patch too short %ld, need %d\n",
+			count, patch.len);
 		return -EINVAL;
 	}
 	if (patch.len < 0) {
-		snd_printk(KERN_ERR "poor length %d\n", patch.len);
+		dev_err(card->dev, "poor length %d\n", patch.len);
 		return -EINVAL;
 	}
 
@@ -164,7 +166,7 @@ snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
 	rc = -EINVAL;
 	switch (patch.type) {
 	case SNDRV_SFNT_LOAD_INFO:
-		rc = load_info(sflist, data, count);
+		rc = load_info(card, sflist, data, count);
 		break;
 	case SNDRV_SFNT_LOAD_DATA:
 		rc = load_data(sflist, data, count);
@@ -184,8 +186,8 @@ snd_soundfont_load(struct snd_sf_list *sflist, const void __user *data,
 	case SNDRV_SFNT_REMOVE_INFO:
 		/* patch must be opened */
 		if (!sflist->currsf) {
-			snd_printk(KERN_ERR "soundfont: remove_info: "
-				   "patch not opened\n");
+			dev_err(card->dev,
+				"soundfont: remove_info: patch not opened\n");
 			rc = -EINVAL;
 		} else {
 			int bank, instr;
@@ -509,7 +511,8 @@ remove_info(struct snd_sf_list *sflist, struct snd_soundfont *sf,
  * open soundfont.
  */
 static int
-load_info(struct snd_sf_list *sflist, const void __user *data, long count)
+load_info(struct snd_card *card,
+	  struct snd_sf_list *sflist, const void __user *data, long count)
 {
 	struct snd_soundfont *sf;
 	struct snd_sf_zone *zone;
@@ -525,7 +528,7 @@ load_info(struct snd_sf_list *sflist, const void __user *data, long count)
 		return -EINVAL;
 
 	if (count < (long)sizeof(hdr)) {
-		printk(KERN_ERR "Soundfont error: invalid patch zone length\n");
+		dev_err(card->dev, "Soundfont error: invalid patch zone length\n");
 		return -EINVAL;
 	}
 	if (copy_from_user((char*)&hdr, data, sizeof(hdr)))
@@ -535,15 +538,15 @@ load_info(struct snd_sf_list *sflist, const void __user *data, long count)
 	count -= sizeof(hdr);
 
 	if (hdr.nvoices <= 0 || hdr.nvoices >= 100) {
-		printk(KERN_ERR "Soundfont error: Illegal voice number %d\n",
-		       hdr.nvoices);
+		dev_err(card->dev, "Soundfont error: Illegal voice number %d\n",
+			hdr.nvoices);
 		return -EINVAL;
 	}
 
 	if (count < (long)sizeof(struct soundfont_voice_info) * hdr.nvoices) {
-		printk(KERN_ERR "Soundfont Error: "
-		       "patch length(%ld) is smaller than nvoices(%d)\n",
-		       count, hdr.nvoices);
+		dev_err(card->dev,
+			"Soundfont Error: patch length(%ld) is smaller than nvoices(%d)\n",
+			count, hdr.nvoices);
 		return -EINVAL;
 	}
 
@@ -944,7 +947,8 @@ int snd_sf_vol_table[128] = {
 
 /* load GUS patch */
 static int
-load_guspatch(struct snd_sf_list *sflist, const char __user *data, long count)
+load_guspatch(struct snd_card *card,
+	      struct snd_sf_list *sflist, const char __user *data, long count)
 {
 	struct patch_info patch;
 	struct snd_soundfont *sf;
@@ -954,7 +958,7 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data, long count)
 	int rc;
 
 	if (count < (long)sizeof(patch)) {
-		snd_printk(KERN_ERR "patch record too small %ld\n", count);
+		dev_err(card->dev, "patch record too small %ld\n", count);
 		return -EINVAL;
 	}
 	if (copy_from_user(&patch, data, sizeof(patch)))
@@ -1041,10 +1045,10 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data, long count)
 	/* panning position; -128 - 127 => 0-127 */
 	zone->v.pan = (patch.panning + 128) / 2;
 #if 0
-	snd_printk(KERN_DEBUG
-		   "gus: basefrq=%d (ofs=%d) root=%d,tune=%d, range:%d-%d\n",
-		   (int)patch.base_freq, zone->v.rate_offset,
-		   zone->v.root, zone->v.tune, zone->v.low, zone->v.high);
+	pr_debug(
+		 "gus: basefrq=%d (ofs=%d) root=%d,tune=%d, range:%d-%d\n",
+		 (int)patch.base_freq, zone->v.rate_offset,
+		 zone->v.root, zone->v.tune, zone->v.low, zone->v.high);
 #endif
 
 	/* detuning is ignored */
@@ -1076,12 +1080,12 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data, long count)
 		zone->v.parm.volrelease = 0x8000 | snd_sf_calc_parm_decay(release);
 		zone->v.attenuation = calc_gus_attenuation(patch.env_offset[0]);
 #if 0
-		snd_printk(KERN_DEBUG
-			   "gus: atkhld=%x, dcysus=%x, volrel=%x, att=%d\n",
-			   zone->v.parm.volatkhld,
-			   zone->v.parm.voldcysus,
-			   zone->v.parm.volrelease,
-			   zone->v.attenuation);
+		dev_dbg(card->dev,
+			"gus: atkhld=%x, dcysus=%x, volrel=%x, att=%d\n",
+			zone->v.parm.volatkhld,
+			zone->v.parm.voldcysus,
+			zone->v.parm.volrelease,
+			zone->v.attenuation);
 #endif
 	}
 
@@ -1125,12 +1129,13 @@ load_guspatch(struct snd_sf_list *sflist, const char __user *data, long count)
 
 /* load GUS patch */
 int
-snd_soundfont_load_guspatch(struct snd_sf_list *sflist, const char __user *data,
+snd_soundfont_load_guspatch(struct snd_card *card,
+			    struct snd_sf_list *sflist, const char __user *data,
 			    long count)
 {
 	int rc;
 	lock_preset(sflist);
-	rc = load_guspatch(sflist, data, count);
+	rc = load_guspatch(card, sflist, data, count);
 	unlock_preset(sflist);
 	return rc;
 }
-- 
2.53.0



