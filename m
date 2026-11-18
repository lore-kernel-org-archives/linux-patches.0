Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019324;
	b=jZleX5WBbgz+jSknZS6uSsiUNaP8sn8+yfNlCwwihy/eayck3u1HgPHABJ5vVAnbl3JQ
	 BdmSQAISjr2GIv1WcUh7Wyvqje8TnF7ZFDQOQbiSBTxLibS3GUM+a+cHDABhJ1i0G15bA
	 c2m9Ldtse5RHNdG3azzI3jmJevpM7PWhyziVkV/p3FxQKv1PoAzuoNFcdBI6STaGt0/M9
	 L9Dntyq8gsNLSFLTPsKMOvefKTEhO3BMK8fGeFKIY7O+TA63nRnxNHmkXccuqDxba5B1s
	 XNAdlqMt60BH7QjqhqrV4VKR9OE+EebX8Yu5omVq25wFN0lhH7lOEg/Bg1CEyRAsumg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pIjcDQqRxnRFQXAa/s9rAiBVRtAbtWOKcjNRDO27Ei0=;
	b=OKR/qMYsdv3/niF0CME9QZ+/KKBNHt27801WD0gqPP0S028uc2I10YCZIcpvjLe5R+o4
	 ISV3hUnw8zdFJ6PgJZZ8PvVZdcPb+9aGHbf3kzibUAzYlFAKX8WySWJZqdeZP3VVkuoAC
	 msAg5gu0WKe+4HS6E0eB9Kpqd8OvJHAlWfCRbiqZUxYWdVZ28TUJsB+YgvqpqQLnAg5Zg
	 SFMzqRJ8dbmSecMOjAFt0oGVuvFJ68P+Lm0Gb3oUJQQycqEu+8LYF2v5XfzfYmIxnTNoT
	 OBVZMajPKMmp4kmFS6FzL5+dwFypjwYqVDRpVb9pfirgVEUwRM/U1N3RJ9sy2msueCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sYxzVSqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB7460A2607;
	Wed, 18 Nov 2026 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sYxzVSqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF871F000C4;
	Wed, 18 Nov 2026 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019324;
	bh=pIjcDQqRxnRFQXAa/s9rAiBVRtAbtWOKcjNRDO27Ei0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sYxzVSqrDuT0dxaI09M5J4UmNYZ56KguK8NVQkV3OdszSEKFfpA4vFLFbl1OqsA6S
	 O7sZGJTB2Gr6Pt4LuEBob6zPkmaXloF+iHdgjWQCm1vJS4ULe6mVEF/PVafZm3LE5y
	 jPCGsCcFiLzoHfVrm56Xfb/3+Kl/58xRKRY32150=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1528/2651] ALSA: hda: Use linked list for jack table
Date: Wed, 18 Nov 2026 15:46:08 +0100
Message-ID: <20261118150342.993616881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5676e013f16ac4b616d433af24647d0ce4b067aa ]

So far we've used snd_array infrastructure for managing the
hda_jack_tbl elements, but it turned out that this may lead to a UAF
when a different order of destruction procedure is applied; namely,
each hda_jack_tbl object creates a snd_jack object and sets the
private_data pointing to the hda_jack_tbl, and private_free to release
it.  It looks harmless, but since snd_array may reallocate the whole
table at growing, the formerly referred jack pointer may become stale.

Fortunately, currently there is no call pattern that triggers this
issue, so it's only hypothetical, but we should address it in anyway.

There are several ways to address this, and at this time, we rather
redesign the hda_jack_tbl allocations: instead of snd_array(), do a
normal kmalloc() + linked list.  There will be more kmalloc calls than
the original code, but as the number of jacks are usually at most
handful, it must not be a problem.  This change allows us the
persistent jack pointer, so no stale pointer access can happen any
longer.

This also fixes another reported issue about the stale jack pointer
reference in snd_hda_jack_tbl_new(), too.

Fixes: 31ef22579302 ("ALSA: hda - Integrate input-jack stuff into kctl-jack")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007171057.7462-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h       |  6 ++-
 sound/hda/common/codec.c        |  1 -
 sound/hda/common/hda_jack.h     |  1 +
 sound/hda/common/jack.c         | 79 ++++++++++++++++++---------------
 sound/soc/sof/intel/hda-codec.c |  4 +-
 5 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 1d05f991f2ce7..c7f29ad64e02c 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -28,6 +28,7 @@ struct hda_codec;
 struct hda_pcm;
 struct hda_pcm_stream;
 struct hda_codec_ops;
+struct hda_jack_tbl;
 
 /*
  * codec bus
@@ -274,7 +275,8 @@ struct hda_codec {
 				 struct hda_codec *codec, hda_nid_t nid);
 
 	/* jack detection */
-	struct snd_array jacktbl;
+	struct hda_jack_tbl *jacktbl, *jacktbl_last; /* linked list head/tail */
+	int jacktbl_used; /* number of jacktbl elements */
 	unsigned long jackpoll_interval; /* In jiffies. Zero means no poll, rely on unsol events */
 	struct delayed_work jackpoll_work;
 
@@ -519,7 +521,7 @@ void snd_hda_update_power_acct(struct hda_codec *codec);
 
 static inline bool hda_codec_need_resume(struct hda_codec *codec)
 {
-	return !codec->relaxed_resume && codec->jacktbl.used;
+	return !codec->relaxed_resume && codec->jacktbl_used;
 }
 
 /*
diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 7c2b967aebe95..652df589759d4 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -921,7 +921,6 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
 	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
 	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
 	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
-	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
 	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
 	INIT_LIST_HEAD(&codec->conn_list);
 	INIT_LIST_HEAD(&codec->pcm_list_head);
diff --git a/sound/hda/common/hda_jack.h b/sound/hda/common/hda_jack.h
index e9b9970c59ed4..a06b315e4b055 100644
--- a/sound/hda/common/hda_jack.h
+++ b/sound/hda/common/hda_jack.h
@@ -44,6 +44,7 @@ struct hda_jack_tbl {
 	int type;
 	int button_state;
 	struct snd_jack *jack;
+	struct hda_jack_tbl *next;
 };
 
 struct hda_jack_keymap {
diff --git a/sound/hda/common/jack.c b/sound/hda/common/jack.c
index c3efab3b5bfee..6b8aa1a6c0084 100644
--- a/sound/hda/common/jack.c
+++ b/sound/hda/common/jack.c
@@ -76,12 +76,11 @@ static u32 read_pin_sense(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 struct hda_jack_tbl *
 snd_hda_jack_tbl_get_mst(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i;
+	struct hda_jack_tbl *jack;
 
-	if (!nid || !jack)
+	if (!nid)
 		return NULL;
-	for (i = 0; i < codec->jacktbl.used; i++, jack++)
+	for (jack = codec->jacktbl; jack; jack = jack->next)
 		if (jack->nid == nid && jack->dev_id == dev_id)
 			return jack;
 	return NULL;
@@ -98,12 +97,11 @@ struct hda_jack_tbl *
 snd_hda_jack_tbl_get_from_tag(struct hda_codec *codec,
 			      unsigned char tag, int dev_id)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i;
+	struct hda_jack_tbl *jack;
 
-	if (!tag || !jack)
+	if (!tag)
 		return NULL;
-	for (i = 0; i < codec->jacktbl.used; i++, jack++)
+	for (jack = codec->jacktbl; jack; jack = jack->next)
 		if (jack->tag == tag && jack->dev_id == dev_id)
 			return jack;
 	return NULL;
@@ -113,12 +111,11 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_tbl_get_from_tag);
 static struct hda_jack_tbl *
 any_jack_tbl_get_from_nid(struct hda_codec *codec, hda_nid_t nid)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i;
+	struct hda_jack_tbl *jack;
 
-	if (!nid || !jack)
+	if (!nid)
 		return NULL;
-	for (i = 0; i < codec->jacktbl.used; i++, jack++)
+	for (jack = codec->jacktbl; jack; jack = jack->next)
 		if (jack->nid == nid)
 			return jack;
 	return NULL;
@@ -142,12 +139,19 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 
 	if (jack)
 		return jack;
-	jack = snd_array_new(&codec->jacktbl);
+	jack = kzalloc_obj(*jack);
 	if (!jack)
 		return NULL;
 	jack->nid = nid;
 	jack->dev_id = dev_id;
 	jack->jack_dirty = 1;
+	if (!codec->jacktbl)
+		codec->jacktbl = jack;
+	else
+		codec->jacktbl_last->next = jack;
+	codec->jacktbl_last = jack;
+	codec->jacktbl_used++;
+
 	if (existing_nid_jack) {
 		jack->tag = existing_nid_jack->tag;
 
@@ -158,7 +162,7 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 		 */
 		jack->jack_detect = existing_nid_jack->jack_detect;
 	} else {
-		jack->tag = codec->jacktbl.used;
+		jack->tag = codec->jacktbl_used;
 	}
 
 	return jack;
@@ -166,10 +170,9 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 
 void snd_hda_jack_tbl_disconnect(struct hda_codec *codec)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i;
+	struct hda_jack_tbl *jack;
 
-	for (i = 0; i < codec->jacktbl.used; i++, jack++) {
+	for (jack = codec->jacktbl; jack; jack = jack->next) {
 		if (!codec->bus->shutdown && jack->jack)
 			snd_device_disconnect(codec->card, jack->jack);
 	}
@@ -177,22 +180,31 @@ void snd_hda_jack_tbl_disconnect(struct hda_codec *codec)
 
 void snd_hda_jack_tbl_clear(struct hda_codec *codec)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i;
+	struct hda_jack_tbl *jack, *jack_next;
 
-	for (i = 0; i < codec->jacktbl.used; i++, jack++) {
+	for (jack = codec->jacktbl; jack; jack = jack_next) {
 		struct hda_jack_callback *cb, *next;
 
-		/* free jack instances manually when clearing/reconfiguring */
-		if (!codec->bus->shutdown && jack->jack)
-			snd_device_free(codec->card, jack->jack);
+		jack_next = jack->next;
+
+		if (jack->jack) {
+			/* fingers away from stale data */
+			jack->jack->private_data = NULL;
+			jack->jack->private_free = NULL;
+			/* free jack instances manually when clearing/reconfiguring */
+			if (!codec->bus->shutdown)
+				snd_device_free(codec->card, jack->jack);
+		}
 
 		for (cb = jack->callback; cb; cb = next) {
 			next = cb->next;
 			kfree(cb);
 		}
+		kfree(jack);
 	}
-	snd_array_free(&codec->jacktbl);
+
+	codec->jacktbl = codec->jacktbl_last = NULL;
+	codec->jacktbl_used = 0;
 }
 
 #define get_jack_plug_state(sense) !!(sense & AC_PINSENSE_PRESENCE)
@@ -238,10 +250,9 @@ static void jack_detect_update(struct hda_codec *codec,
  */
 void snd_hda_jack_set_dirty_all(struct hda_codec *codec)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i;
+	struct hda_jack_tbl *jack;
 
-	for (i = 0; i < codec->jacktbl.used; i++, jack++)
+	for (jack = codec->jacktbl; jack; jack = jack->next)
 		if (jack->nid)
 			jack->jack_dirty = 1;
 }
@@ -478,19 +489,17 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_set_button_state);
 void snd_hda_jack_report_sync(struct hda_codec *codec)
 {
 	struct hda_jack_tbl *jack;
-	int i, state;
+	int state;
 
 	/* update all jacks at first */
-	jack = codec->jacktbl.list;
-	for (i = 0; i < codec->jacktbl.used; i++, jack++)
+	for (jack = codec->jacktbl; jack; jack = jack->next)
 		if (jack->nid)
 			jack_detect_update(codec, jack);
 
 	/* report the updated jacks; it's done after updating all jacks
 	 * to make sure that all gating jacks properly have been set
 	 */
-	jack = codec->jacktbl.list;
-	for (i = 0; i < codec->jacktbl.used; i++, jack++)
+	for (jack = codec->jacktbl; jack; jack = jack->next)
 		if (jack->nid) {
 			if (!jack->jack || jack->block_report)
 				continue;
@@ -758,10 +767,10 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_unsol_event);
  */
 void snd_hda_jack_poll_all(struct hda_codec *codec)
 {
-	struct hda_jack_tbl *jack = codec->jacktbl.list;
-	int i, changes = 0;
+	struct hda_jack_tbl *jack;
+	int changes = 0;
 
-	for (i = 0; i < codec->jacktbl.used; i++, jack++) {
+	for (jack = codec->jacktbl; jack; jack = jack->next) {
 		unsigned int old_sense;
 		if (!jack->nid || !jack->jack_dirty || jack->phantom_jack)
 			continue;
diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 32fcc1cd3f923..a2b2ecf1e7e6d 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -87,7 +87,7 @@ void hda_codec_jack_wake_enable(struct snd_sof_dev *sdev, bool enable)
 		list_for_each_codec(codec, hbus) {
 			/* only set WAKEEN when needed for HDaudio codecs */
 			mask |= BIT(codec->core.addr);
-			if (codec->jacktbl.used)
+			if (codec->jacktbl_used)
 				val |= BIT(codec->core.addr);
 		}
 	} else {
@@ -116,7 +116,7 @@ void hda_codec_jack_check(struct snd_sof_dev *sdev)
 		 * Wake up all jack-detecting codecs regardless whether an event
 		 * has been recorded in STATESTS
 		 */
-		if (codec->jacktbl.used)
+		if (codec->jacktbl_used)
 			pm_request_resume(&codec->core.dev);
 }
 EXPORT_SYMBOL_NS_GPL(hda_codec_jack_check, "SND_SOC_SOF_HDA_AUDIO_CODEC");
-- 
2.53.0



