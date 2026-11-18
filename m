Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020082;
	b=sN/MvJEbmA0K6lU5qKeHlCPuN0K131XtRfmfetl9e+bizq5G95LMyfgQkOt3e4J2cOQE
	 isyfJsf49yRQYwEB67Axa+ql26AjjcXUloqy7kjk7OFh7ldVjOX42LX7x2v6lMCZJVEHD
	 jMaOQECO5rwDw74tD6Ldl3VmJ+5HKUCbrXmpN/rHtkLEMZCiwI6XSM2N2Afc0nnlXOq+s
	 TMBFs0aCwv7SD9oymJmw7vXqlqj4NTyw8BW2eqVD7e3SKx26fKKlG85G/vDMCsn/rTvmL
	 ZasuMtX3vmhEy4YcG5bMU6KQcezadejD9XQRn3ZAjYzG0zTkwGM4t0UkAoHbYI0jZGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wFanFfhQmSbQBgIpb1sHhcV/uXsNIPOIQOC5t12gjk=;
	b=JUtyJ/s6qpWgMhdGjFc1VRSfcZNXD4Fd1ikKtT3oC6yuBeb0byVCObHN3AXZkP/KQ/aI
	 lLS/7hYiFB9kayafNLdin5gyN9rU8b25t62Nq86RedgQlmT/rxjRGYkDq+UkZRKV5xVKv
	 mc2fzXp4k02GmGcn1NVo+3rTsIBAV5rLbjX0dh4AZ125L1NjTy1YmHAhPIqG2UDYqUVVA
	 jy3qTzq5vnXZwd1Xi5q5prF4lGYEPhlET5+oyNmtQ89BbHIVqirb5NEqTfXUz/Wr8Cw2G
	 2bGxDsSRV46Mna6LvQM1c0W7Zt3zh5aqM/0NLVqFwQDeJGe1JOAgtm0AqO6O8L0WfFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGG7Lo+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C251606A31C;
	Wed, 18 Nov 2026 16:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGG7Lo+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685031F000CC;
	Wed, 18 Nov 2026 16:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020082;
	bh=9wFanFfhQmSbQBgIpb1sHhcV/uXsNIPOIQOC5t12gjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGG7Lo+wDBrqKN9R67SwSvnyBhrffW9bpCTABvGn2xT0/yXlVPV9WR02VU+0yLCvM
	 AI1lfOLpVqWNNlsRaH3d/Tf/KHLmPOUIzNUraW+k8HLwailk51xB5OFfQGgOhzp0uM
	 H81bq1V/ZrkwkN9th/wV9HPOLP0YGCOqqpOeEOhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1824/2651] ALSA: usb-audio: Use fixed control index for us16x08 mixer elements
Date: Wed, 18 Nov 2026 15:51:04 +0100
Message-ID: <20261118150352.828077090@linuxfoundation.org>
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
index 8460ad8ab01a9..9d0c5665639ee 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -596,20 +596,25 @@ static int check_matrix_bitmap(unsigned char *bmap,
 
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
index 0d0a8b343756a..c40f832852be1 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -113,10 +113,11 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 
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
index fc622eb95dc58..5755771247f9a 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -166,7 +166,7 @@ static int add_single_ctl_with_resume(struct usb_mixer_interface *mixer,
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
 	/* don't use snd_usb_mixer_add_control() here, this is a special list element */
-	return snd_usb_mixer_add_list(list, kctl, false);
+	return snd_usb_mixer_add_list(list, kctl, false, true);
 }
 
 /*
diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index b447c4f7a161d..18e8c2bd26783 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -1134,7 +1134,8 @@ static int add_new_ctl(struct usb_mixer_interface *mixer,
 
 	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
-	err = snd_usb_mixer_add_control(&elem->head, kctl);
+	/* look_for_empty=false, as we want the fixed id.index as channel */
+	err = snd_usb_mixer_add_list(&elem->head, kctl, true, false);
 	if (err < 0)
 		return err;
 
-- 
2.53.0



