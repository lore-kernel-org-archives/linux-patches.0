Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049733;
	b=QNBXqbw2yKTysg2vBcrSrkkacr1dxyCZSE92peAorRneog8Q5Ju/HKrKYSqcWfvU6a9j
	 lU2QhBIqaaLcyBxOU9+geoyVU954zwB7xsglR/f0CD9tLD+1xH6IZfXYdJpaiu/b8EiPY
	 ZAAjAE2bO5oPEzl4TOPZGf1GdgwVTPeEfH2RjaJJuHFCPUf4yoJE1D/n2l45ZTdcXVGrc
	 bgWlIqVmFgm8PLNmD23HAHe6Gr8Y5HQfn5l2ir1xItrcHvo0puEZMygAsQm0j03JZVpbg
	 T818uyi4Oq2+3GfNyaGgvX7lo4Pql4HxkF6SoQ99ZsCjhD2yGMMAjrDGX1n8dGokIUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sw61pP5dyjEEsOXsYmIybK7Vn7NXsl6w8aqqDrulWk0=;
	b=S0umwucJNR4jCPvA1dwFH69fi7dP856AXtOtCI6zBta6JLoI5RMvE6p6Qp0IdBFtikt4
	 UxK0ei0ihb2CNsY5ELsdP4aiZhNAjzRvb/pQpG0HEVsVV+GC2scaI1RQ2keC+AvEhvwLK
	 +OlxJoAU0apEavcrGQC7Jx6MD0x3WbSwIKCYl9+WpGy1HB6glbIPLx5egBkrBroy9BFFZ
	 a23Up80v5z7xa8vx2tzU9v6/AjZDwkwDD/+YwSZaC/m1b4aqFOZiPNBZVy+jJD/Gfm1mQ
	 QmOItCbUfMZDXqiEBSar0ZhnPVNANImhXM5q109HXTCrcPQF5aGHlAa3Xjk3JzStdIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8Eb6OTE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E1E606A320;
	Thu, 19 Nov 2026 00:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8Eb6OTE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604B51F000C5;
	Thu, 19 Nov 2026 00:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049732;
	bh=Sw61pP5dyjEEsOXsYmIybK7Vn7NXsl6w8aqqDrulWk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8Eb6OTEkMWVK/oD29mAVgI9xXqES4qb6xf7QlUU4E37bX1rTdY/b+lvngZI/xDRQ
	 hxnEC2LX0+3MFRfxy76+SZ1hEhwuGgKLfzpdPchAAzC7dIiIIz58BwY7DUi+4hZRa5
	 cMIvKZtJg18dw56ekLee08FLX/zIgrpZgLUTycu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2458/2857] ALSA: usb-audio: Use fixed control index for us16x08 mixer elements
Date: Wed, 18 Nov 2026 15:58:12 +0100
Message-ID: <20261118150330.067849009@linuxfoundation.org>
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
index e247963d9fc61..9b61c8b45a842 100644
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



