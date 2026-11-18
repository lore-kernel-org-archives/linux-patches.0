Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041524;
	b=Mn/x57gyYNVH6ysobNsvr2Nbcp0LtAJrFgRIOMvrxgxRnqaTjKD7hPZ1AdK2bYtlZLif
	 ZrgYQZZORPVprlcHMbpwTW+wJhpmsnqze9GLjjfAmX18yVCIsI9Az2s3c53c5uI3LLWWb
	 Nkwrov0BUxDE66Myd/9Y/keDNDnV8MHiUGQG7jqH7Cf4CdLY3NppsnN4WszY7EcP98J6h
	 oiML9U19VZmhKAxR70/98GX8V7mVzvnL5hGYPY0mKaqjIg5PqhwuBIknTvfgv+awgqf0O
	 iBo38aLUM7so1570XanC5cv1NsvEwjmar8VMSWTF2duvZhW6mr/fLuqxV3c3tJ+4QgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPyCirAwbMKNBUv4MJ+BVZv2oiG14kUJxWGnLihqSLY=;
	b=xVrKDCyIGWv79i9KrKkLzyifJqDceL0Smiy5+YRQdASwJfO0opEHgf9uoPq21qTfzL15
	 u2zy2YyUBqwPLkeEzxSLmdbyPoOhIlpXgtIELOiAdxMC5CyI5lr+qsFUuUUhXn/BJ1rEm
	 BPK1XUywWKCidpCFXUbNAQPQb7eqXtoDDQqviqjXp83xVlKeMgpDAxz1xz+aAHbE9hPcc
	 K5VSD1FHGUswel4z0VRtkPWlfTBsJz3Cjof6quYNEIW0ZpzsmvMOrFZTG39gU1do2PfBR
	 IVqImvBQ00UPF6zr8LcQcZVpqOprFF6+tfMJNlWcCl3G5zuVCxM9kqVLCstDnzBbO0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgzdvxDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BEC606A32C;
	Wed, 18 Nov 2026 22:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgzdvxDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638451F000C4;
	Wed, 18 Nov 2026 22:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041523;
	bh=HPyCirAwbMKNBUv4MJ+BVZv2oiG14kUJxWGnLihqSLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgzdvxDn1XdeebgbIrMkR1HUx2NC0wL9eOVSTs+NP39JIN2g4NBimxEifSvcvF0QN
	 dVvxlSAM2gVbls5k7taxbVl7IY4qojfFPf1aVhwlAkgKSQOE1D+NcepGpHfd1QfI11
	 1y7jk3lbaGD+m+e7WdMMJYzXzxH6QpVo3ScbeLGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2842/3318] ALSA: usb-audio: Use fixed control index for us16x08 mixer elements
Date: Wed, 18 Nov 2026 15:57:44 +0100
Message-ID: <20261118150445.875199973@linuxfoundation.org>
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
index 29ccf7a4ec348..5487657ece939 100644
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
index 167fbfcf01ace..36cb4f7daee58 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -107,10 +107,11 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 
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
index e3fda32bac1cb..a89f0cc915a17 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -162,7 +162,7 @@ static int add_single_ctl_with_resume(struct usb_mixer_interface *mixer,
 	}
 	kctl->private_free = snd_usb_mixer_elem_free;
 	/* don't use snd_usb_mixer_add_control() here, this is a special list element */
-	return snd_usb_mixer_add_list(list, kctl, false);
+	return snd_usb_mixer_add_list(list, kctl, false, true);
 }
 
 /*
diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index b74e198c365c3..0ff44c615886f 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -1112,7 +1112,8 @@ static int add_new_ctl(struct usb_mixer_interface *mixer,
 
 	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
-	err = snd_usb_mixer_add_control(&elem->head, kctl);
+	/* look_for_empty=false, as we want the fixed id.index as channel */
+	err = snd_usb_mixer_add_list(&elem->head, kctl, true, false);
 	if (err < 0)
 		return err;
 
-- 
2.53.0



