Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625303;
	b=URKO1VGYechB4fh0lZ7rGTFxrM7NdMXYGecCD05DkAgmC7gHSCGZkKYWF0oFDU6UTgh5
	 9iBXBzMKhKpMBCwR9nuCFjXImOlM2vCB8gW8jKLTLjJvuN/EfaAqs65fPWR8oaRMCem3K
	 TuuShyWkV0+h9rrX+4ouc6fMper6tLc+/bznf7Vd9ThM+5zAbtxHJru0MGfxS4xIWcr1U
	 1zGYwOMLkuqxevl+rEUOFWFbhK9dZdRFy55cparMXeMCwbiMz9UO9/kOQaDOKgFFnblah
	 cS/aGEVXHUBJu0h14iSbGs9tZrkvobu0qmoEHO//b/YPO64Rv+TKRZisEel8kjJ28Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5dnlg/UkKeNIhtsQC6PnODKlBV7BJIck6KTVWYg+ILQ=;
	b=lNJsgp/VxKNqB1Eozx1E4cV7GDkpFK0F+5IBwiTagpIUt3hAZNG7ss5jijqOGmJA1hgG
	 pxRwR3s09ZgtB4dg6BwN25g2ZiK2VGyKY4/gRoP9+Yz8wZzBPNBQMc6L1iuaaNfQ73vHm
	 riYDeFbB9QHyVvrRufa2Qwm0Q7qfPBfMrY6KgCLy1HS7S1vhSVDwrFiwisD9lVNniIsBy
	 Nd2czuPRMYZfcWNczqMCULTKx0vSCB9+/A2owoM7nO0PR8acyvHRk8rPohg2MnJoakNDV
	 n+CqNSENkbqNjfH0DHANptrM0T0DrWNJ4LqRPeW597C0wFc36lVSCmJuw5f4Qyag8GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GfTyxe7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F37D606A31E;
	Wed, 25 Nov 2026 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GfTyxe7y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8413B1F000CF;
	Wed, 25 Nov 2026 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625303;
	bh=5dnlg/UkKeNIhtsQC6PnODKlBV7BJIck6KTVWYg+ILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfTyxe7y1mo/BdjIiZqZb9ANNeBMgWHLU1jppYYy+vabIUDIrj8xOSuxpU+yFkiOF
	 kXE3JCA1eCO+/O+q7pk6YR1bpV804NiGy2ogVoH2wy7FGRvvhJHn1fHgX4uIibjq7N
	 0bPfbbv9yc+EBi24i7aAWLGYciPKnGhzGTlybxjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 473/816] ALSA: hda: Use linked list for jack table
Date: Wed, 25 Nov 2026 15:33:41 +0100
Message-ID: <20261125143900.149029301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Dropped the struct hda_codec_ops; context line from the forward-declaration hunk in hda_codec.h, since this tree lacks it, and kept only the added struct hda_jack_tbl;. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h       |  6 ++-
 sound/pci/hda/hda_codec.c       |  1 -
 sound/pci/hda/hda_jack.c        | 79 ++++++++++++++++++---------------
 sound/pci/hda/hda_jack.h        |  1 +
 sound/soc/sof/intel/hda-codec.c |  4 +-
 5 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 908258fb23eaf..ceeaafb146d84 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -27,6 +27,7 @@ struct hda_beep;
 struct hda_codec;
 struct hda_pcm;
 struct hda_pcm_stream;
+struct hda_jack_tbl;
 
 /*
  * codec bus
@@ -271,7 +272,8 @@ struct hda_codec {
 				 struct hda_codec *codec, hda_nid_t nid);
 
 	/* jack detection */
-	struct snd_array jacktbl;
+	struct hda_jack_tbl *jacktbl, *jacktbl_last; /* linked list head/tail */
+	int jacktbl_used; /* number of jacktbl elements */
 	unsigned long jackpoll_interval; /* In jiffies. Zero means no poll, rely on unsol events */
 	struct delayed_work jackpoll_work;
 
@@ -496,7 +498,7 @@ void snd_hda_update_power_acct(struct hda_codec *codec);
 
 static inline bool hda_codec_need_resume(struct hda_codec *codec)
 {
-	return !codec->relaxed_resume && codec->jacktbl.used;
+	return !codec->relaxed_resume && codec->jacktbl_used;
 }
 
 /*
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 791f3a3e8e258..670db66ef4e51 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -940,7 +940,6 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
 	snd_array_init(&codec->driver_pins, sizeof(struct hda_pincfg), 16);
 	snd_array_init(&codec->cvt_setups, sizeof(struct hda_cvt_setup), 8);
 	snd_array_init(&codec->spdif_out, sizeof(struct hda_spdif_out), 16);
-	snd_array_init(&codec->jacktbl, sizeof(struct hda_jack_tbl), 16);
 	snd_array_init(&codec->verbs, sizeof(struct hda_verb *), 8);
 	INIT_LIST_HEAD(&codec->conn_list);
 	INIT_LIST_HEAD(&codec->pcm_list_head);
diff --git a/sound/pci/hda/hda_jack.c b/sound/pci/hda/hda_jack.c
index 8c25c7d81128b..1cda9175fd7bf 100644
--- a/sound/pci/hda/hda_jack.c
+++ b/sound/pci/hda/hda_jack.c
@@ -70,12 +70,11 @@ static u32 read_pin_sense(struct hda_codec *codec, hda_nid_t nid, int dev_id)
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
@@ -92,12 +91,11 @@ struct hda_jack_tbl *
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
@@ -107,12 +105,11 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_tbl_get_from_tag);
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
@@ -136,12 +133,19 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 
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
 
@@ -152,7 +156,7 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 		 */
 		jack->jack_detect = existing_nid_jack->jack_detect;
 	} else {
-		jack->tag = codec->jacktbl.used;
+		jack->tag = codec->jacktbl_used;
 	}
 
 	return jack;
@@ -160,10 +164,9 @@ snd_hda_jack_tbl_new(struct hda_codec *codec, hda_nid_t nid, int dev_id)
 
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
@@ -171,22 +174,31 @@ void snd_hda_jack_tbl_disconnect(struct hda_codec *codec)
 
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
@@ -232,10 +244,9 @@ static void jack_detect_update(struct hda_codec *codec,
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
@@ -472,19 +483,17 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_set_button_state);
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
@@ -752,10 +761,10 @@ EXPORT_SYMBOL_GPL(snd_hda_jack_unsol_event);
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
diff --git a/sound/pci/hda/hda_jack.h b/sound/pci/hda/hda_jack.h
index ff7d289c034bf..26bfaae393568 100644
--- a/sound/pci/hda/hda_jack.h
+++ b/sound/pci/hda/hda_jack.h
@@ -44,6 +44,7 @@ struct hda_jack_tbl {
 	int type;
 	int button_state;
 	struct snd_jack *jack;
+	struct hda_jack_tbl *next;
 };
 
 struct hda_jack_keymap {
diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 57998d3d8d15b..57c3a4df5627a 100644
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
 EXPORT_SYMBOL_NS_GPL(hda_codec_jack_check, SND_SOC_SOF_HDA_AUDIO_CODEC);
-- 
2.53.0



