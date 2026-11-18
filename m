Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026574;
	b=UBxkrxJ/xWizpIbb6CfQjKK5E/K9b0wCdCrLC7vk6hmmv09US2j+UNZFH69ALzNegM5J
	 tb7Y1A7kd3OThgrGcDQFwjMg51gJZNSwBAM3xrvLe51S3OvvEfORMCGnbUHjYcG8LObM9
	 I312QMQTDlfSY59A6tSR9kxmDW5QDZqjsbpWXlqAPY2RdmBrKF8ga72ROVawVb3nBjT0M
	 EQUHqse6tL+HpI3q5z6lqzRdE6b6lVbwx61exTpGYxb90QCh0DyObjswy71VlNLaicqdN
	 ZVuvebtZSH3gt1a0e9seimL0ARfd4K2/h+AIp+LdPYWjsp+2BihWWEigdex1Y/J2CtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1FArYp4+lDM/Wqb8Eylqz1cT6YIn02Ky5DPPJcD8x8=;
	b=wBDp33nJErE3QWPU3uK++elMlISvkNFk1/Gns8m6pOYHQ5He/jbLcUVRYGO9ejAHlBlB
	 gVj5ZcNXJg6K/hhjB1co84PKOtGecAHlWWn2csuRy2VTzFIJt+qus6wpCqSgpZP0gFqmJ
	 uHGedw6FIjfqI96d8pnUFtyydHZWDOT99pMN6cq8Hyrnz5wB8az+KjcAAZ7ZkVlMX7hZ0
	 2KGJwlIl+yYrOo//0glYDIdWoJ143s6DHzlmA23jiTYYKW4q8Knq0Tdkdp0GMDHU4QJFd
	 HaJRHCJ1j6Ja5JzTZuS38KQgMWDCTatqyTBvDGLYUS4x3Xu93Iz72hRd9gTJpV9wpZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIB1Iyw7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E8606A31C;
	Wed, 18 Nov 2026 18:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIB1Iyw7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824C51F000C4;
	Wed, 18 Nov 2026 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026574;
	bh=b1FArYp4+lDM/Wqb8Eylqz1cT6YIn02Ky5DPPJcD8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIB1Iyw7n5hT3pT/PS2ehQJwvF1LBjlBb3kUHdJgMHwsSNQcOZo0dz3nGAX7sDFAB
	 Eg7t/M2SB3L9VhWdGwNHlymnlkiHR21ayB2WPSPUJ0zboO1uhmb9+6+7yo384rhB1Q
	 H3nfUz4vi6Hsf3Euc2t6NxWpXNKWT1yfOp8Nh77E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1484/2151] ALSA: usb-audio: Use fixed control index for us16x08 mixer elements
Date: Wed, 18 Nov 2026 15:53:39 +0100
Message-ID: <20261118150215.943984666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0f6ced6bb8cec..f4e44c31111cd 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -572,20 +572,25 @@ static int check_matrix_bitmap(unsigned char *bmap,
 
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
index ce057bbb2e116..2d0d0d6c4047f 100644
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
index 3040192feb61e..de6bd41b8c58a 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -1127,7 +1127,8 @@ static int add_new_ctl(struct usb_mixer_interface *mixer,
 
 	strscpy(kctl->id.name, name, sizeof(kctl->id.name));
 
-	err = snd_usb_mixer_add_control(&elem->head, kctl);
+	/* look_for_empty=false, as we want the fixed id.index as channel */
+	err = snd_usb_mixer_add_list(&elem->head, kctl, true, false);
 	if (err < 0)
 		return err;
 
-- 
2.53.0



