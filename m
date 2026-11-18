Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031787;
	b=j8u5EybW4Ag9QmRZ7YMYpPXWTyl2DeDM0vsMgr1OBHSyA8J2s/OUdsshWz2+gFq7LnpX
	 rEWhTGph73qzkNza7oKPnfMDfMm90Rfa2mqJatlAU99DGvzR30Psim8ZTUzXlEFTpB8G7
	 ZjXn4hwesIjucH4dEq8PRGKUF+naGo+P3tuhDUdW66jUXd7JhdUCf9p2eDusgDKjKUJj6
	 s4KXBsCACJ7NZrjYRUg25gp3jGxCAWcLCzTZV0tQSY0k1VK/WYJiMn+w7usiLTT7F+M5W
	 b6qgAdau7bQP/IrRKPFAc8a6TWKa96ZmS4pWkDyV7mjFqukOMt32bunrJ9dKfruDoBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BCoBTSj7v3971ftzTxhMbjbCyicAkztXiLcqVZjbth8=;
	b=u2CRs7mDY0SFEBPzwKGRVxRZMjJsHpZQ7fpAXIEkWSUvxk1bGFhHv5rDyEV2ZQNLqoVd
	 EL7r2aJqlquQ1jrDtAfQ0AWg6nwH1aVxpfxMc8VxOCtxdUZifZfG31yzw8x1/RL0kYuQC
	 OeiSWM9vrMhyFeObkVL+ojSsDAfKpVf8GWjRKH0Aci/hqwZc/FqWZmbJab/4A1rKvBy8/
	 WF8906uS4KLUZrNy5A8ffUI8TQISx67mSuEwVmucV2fHD4HT0UKcxGCf3Q0Io0deS6cV0
	 aSgCWQ7eelLhz1m9UuM/F/FzIEhUjog2iGm12QajxHkCI6OLHG9Y1sfV12S09QWK2bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6TkVHd0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470C606A32C;
	Wed, 18 Nov 2026 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6TkVHd0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A481F000C4;
	Wed, 18 Nov 2026 19:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031786;
	bh=BCoBTSj7v3971ftzTxhMbjbCyicAkztXiLcqVZjbth8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6TkVHd0ZqOTCY5BspIWl4iygcCoMuBR8QNaThcNP2Ie0nYYayX0QvNVwfYkwFalu
	 L6I3PyhVyRNDsH5vFl/PQ0mBpI6dt+OlBIWLWVO+vEvp234wCzY6SkrqHlGYEMiECP
	 3E7kP8Cq7QUiMTU5bGT95rFh023n2msvbsjmVUFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1180/1756] ALSA: usb-audio: Use fixed control index for us16x08 mixer elements
Date: Wed, 18 Nov 2026 15:55:07 +0100
Message-ID: <20261118150056.899360798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit a68a688ce220f1b359bec53fa38d1504314dc70f ]

The callbacks for us16x08 mixer elements assume that id.index points
to the channel to be operated, and the assumption is correct for now.
However, since the kctls are added via snd_usb_mixer_add_control() and
it looks for the empty slot if the same control name is already
present, in theory, the index can become more than the channel numbers
(if a conflicting name really happens).

Since the mixer code in us16x08 doesn't need the search for an empty
slot but requires the fixed index, this patch changes slightly how to
assign the kcontrols.  Now, a new argument is added to
snd_usb_mixer_add_list() in order to disable the empty slot search,
and use it in us16x08's add_new_ctl() helper function, instead.

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261014061406.162938-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c         | 13 +++++++++----
 sound/usb/mixer.h         |  5 +++--
 sound/usb/mixer_quirks.c  |  2 +-
 sound/usb/mixer_us16x08.c |  3 ++-
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 07c373822e2ee..ae311c95ac023 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -581,20 +581,25 @@ static int check_matrix_bitmap(unsigned char *bmap,
 
 /*
  * add an alsa control element
- * search and increment the index until an empty slot is found.
+ * when @look_for_empty is set, search and increment the index until an empty
+ * slot is found.
  *
  * if failed, give up and free the control instance.
  */
 
 int snd_usb_mixer_add_list(struct usb_mixer_elem_list *list,
 			   struct snd_kcontrol *kctl,
-			   bool is_std_info)
+			   bool is_std_info,
+			   bool look_for_empty)
 {
 	struct usb_mixer_interface *mixer = list->mixer;
 	int err;
 
-	while (snd_ctl_find_id(mixer->chip->card, &kctl->id))
-		kctl->id.index++;
+	if (look_for_empty) {
+		while (snd_ctl_find_id(mixer->chip->card, &kctl->id))
+			kctl->id.index++;
+	}
+
 	err = snd_ctl_add(mixer->chip->card, kctl);
 	if (err < 0) {
 		usb_audio_dbg(mixer->chip, "cannot add control (err = %d)\n",
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 08d472c5ef7b5..8e5e8da6d480f 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -110,10 +110,11 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 
 int snd_usb_mixer_add_list(struct usb_mixer_elem_list *list,
 			   struct snd_kcontrol *kctl,
-			   bool is_std_info);
+			   bool is_std_info,
+			   bool look_for_empty);
 
 #define snd_usb_mixer_add_control(list, kctl) \
-	snd_usb_mixer_add_list(list, kctl, true)
+	snd_usb_mixer_add_list(list, kctl, true, true)
 
 void snd_usb_mixer_elem_init_std(struct usb_mixer_elem_list *list,
 				 struct usb_mixer_interface *mixer,
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 18e41ea179565..8d4ca3e5f85fa 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -165,7 +165,7 @@ static int add_single_ctl_with_resume(struct usb_mixer_interface *mixer,
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
 	/* don't use snd_usb_mixer_add_control() here, this is a special list element */
-	return snd_usb_mixer_add_list(list, kctl, false);
+	return snd_usb_mixer_add_list(list, kctl, false, true);
 }
 
 /*
diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index 60565d5f113e3..83d4acf1a70e9 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -1128,7 +1128,8 @@ static int add_new_ctl(struct usb_mixer_interface *mixer,
 
 	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
-	err = snd_usb_mixer_add_control(&elem->head, kctl);
+	/* look_for_empty=false, as we want the fixed id.index as channel */
+	err = snd_usb_mixer_add_list(&elem->head, kctl, true, false);
 	if (err < 0)
 		return err;
 
-- 
2.53.0



