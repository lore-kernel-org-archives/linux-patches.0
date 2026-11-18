Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026280;
	b=rHK74liJd7dcMxaqLEPVVhT6WO/KVkFzL1p045+wNP/OQ3bw99ooAzxxZymVJ2sCESgp
	 6RnDFBH5HNEAXNBYATQTiAmHnpW2QvxA6dR9+bbN/XsShGsTvq5B8jnBfHsSkWwHikOZM
	 VVyDTUYVg711aQOUg7HN1AEIGVLwLBU3IIeKc/SySGQggpDBLLhSbDR93MACFd5wLQB/9
	 F3fxx7Fwc3Xxq4pXuAeHU3u+d8cWRwycNDhieAUCPZF4jypk/v9VzFzEF4zJN+kpL2uni
	 juQi5rMuULsaidL09+wzWhwDBgONXHo1qnpmWOJv/GXZ+6aYLjPZc4Qj6z8XEdgFFkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w5S20wO0ULMot7EUVyT7EfmbegQsuZhfTQg8m5/2oq8=;
	b=kWKHgrSYyEoTGVFNb75Vh/IrOPTBdGQ3kbtWXOlfKitLeu1PodWZBnXn2rjQjH8GlwQw
	 rBkoWRI6XwffMEmEBDZAgLrW98H9o+5A4Kkbxw3mddIqwRj/1HsuOoLvL0xgAdQfMP6ZW
	 6FmGFWsfb1LiPdrFNUFuO/sqlHuwigOpiCX6TFc3qb7OK9nTHQBPpy9s4Fb/luk84ihC5
	 uY97AK0qeS1+vtG2DwjdSLKvIaQEXvELQuOwz+yq0aRAcfYLZS6gajgzHKZpCMIe+JAog
	 eMoKlwcM0RroM0Fa0DU9OwGTwk71Bukx28SlzTPp6nKsaXPrW2bnCLFb0r0MtlvV2Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tst1tFok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76378606A32C;
	Wed, 18 Nov 2026 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tst1tFok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49FE1F000C4;
	Wed, 18 Nov 2026 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026280;
	bh=w5S20wO0ULMot7EUVyT7EfmbegQsuZhfTQg8m5/2oq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tst1tFok8/XEIEC6TUSMm7xUdySlp+6eh0nf7XOVkyY2WYz2eNQJA6/89G4qCAyHB
	 3L5J9+gLssCusaV5jvQoUEL+7mMCWgrx9AtexCZOetVG4weOZSli+2AtDGDd7LQwBx
	 4Bwk3Mr9EVbfwFy+Zs2Tnhh5ONBMMaPMMxgia23k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1337/2151] ALSA: control: Relax __free() variable declarations
Date: Wed, 18 Nov 2026 15:51:12 +0100
Message-ID: <20261118150210.762409643@linuxfoundation.org>
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

[ Upstream commit 7b4721ca3159bce6338dbdf9188b785083571ed4 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: 7dba48a474e6 ("ALSA: control_led: Use guard() for locking")
Fixes: 1052d9882269 ("ALSA: control: Use automatic cleanup of kfree()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-3-tiwai@suse.de
Stable-dep-of: 682d6bb5f783 ("ALSA: control_led: Fix deadlock between sysfs writes and card disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c        | 12 ++++++------
 sound/core/control_compat.c | 21 +++++++++++----------
 sound/core/control_led.c    | 12 ++++++------
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 750bb3f52d26d..cf601ad1a70be 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -867,9 +867,9 @@ EXPORT_SYMBOL(snd_ctl_find_id);
 static int snd_ctl_card_info(struct snd_card *card, struct snd_ctl_file * ctl,
 			     unsigned int cmd, void __user *arg)
 {
-	struct snd_ctl_card_info *info __free(kfree) = NULL;
+	struct snd_ctl_card_info *info __free(kfree) =
+		kzalloc(sizeof(*info), GFP_KERNEL);
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (! info)
 		return -ENOMEM;
 	scoped_guard(rwsem_read, &snd_ioctl_rwsem) {
@@ -1244,10 +1244,10 @@ static int snd_ctl_elem_read(struct snd_card *card,
 static int snd_ctl_elem_read_user(struct snd_card *card,
 				  struct snd_ctl_elem_value __user *_control)
 {
-	struct snd_ctl_elem_value *control __free(kfree) = NULL;
 	int result;
+	struct snd_ctl_elem_value *control __free(kfree) =
+		memdup_user(_control, sizeof(*control));
 
-	control = memdup_user(_control, sizeof(*control));
 	if (IS_ERR(control))
 		return PTR_ERR(control);
 
@@ -1320,11 +1320,11 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 static int snd_ctl_elem_write_user(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_value __user *_control)
 {
-	struct snd_ctl_elem_value *control __free(kfree) = NULL;
 	struct snd_card *card;
 	int result;
+	struct snd_ctl_elem_value *control __free(kfree) =
+		memdup_user(_control, sizeof(*control));
 
-	control = memdup_user(_control, sizeof(*control));
 	if (IS_ERR(control))
 		return PTR_ERR(control);
 
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 6459809ed3648..b8988a4bcd9b5 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -80,10 +80,10 @@ static int snd_ctl_elem_info_compat(struct snd_ctl_file *ctl,
 				    struct snd_ctl_elem_info32 __user *data32)
 {
 	struct snd_card *card = ctl->card;
-	struct snd_ctl_elem_info *data __free(kfree) = NULL;
 	int err;
+	struct snd_ctl_elem_info *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (! data)
 		return -ENOMEM;
 
@@ -169,14 +169,15 @@ static int get_ctl_type(struct snd_card *card, struct snd_ctl_elem_id *id,
 			int *countp)
 {
 	struct snd_kcontrol *kctl;
-	struct snd_ctl_elem_info *info __free(kfree) = NULL;
 	int err;
 
 	guard(rwsem_read)(&card->controls_rwsem);
 	kctl = snd_ctl_find_id(card, id);
 	if (!kctl)
 		return -ENOENT;
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+
+	struct snd_ctl_elem_info *info __free(kfree) =
+		kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
 	info->id = *id;
@@ -280,10 +281,10 @@ static int copy_ctl_value_to_user(void __user *userdata,
 static int __ctl_elem_read_user(struct snd_card *card,
 				void __user *userdata, void __user *valuep)
 {
-	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	int err, type, count;
+	struct snd_ctl_elem_value *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -314,11 +315,11 @@ static int ctl_elem_read_user(struct snd_card *card,
 static int __ctl_elem_write_user(struct snd_ctl_file *file,
 				 void __user *userdata, void __user *valuep)
 {
-	struct snd_ctl_elem_value *data __free(kfree) = NULL;
 	struct snd_card *card = file->card;
 	int err, type, count;
+	struct snd_ctl_elem_value *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -378,9 +379,9 @@ static int snd_ctl_elem_add_compat(struct snd_ctl_file *file,
 				   struct snd_ctl_elem_info32 __user *data32,
 				   int replace)
 {
-	struct snd_ctl_elem_info *data __free(kfree) = NULL;
+	struct snd_ctl_elem_info *data __free(kfree) =
+		kzalloc(sizeof(*data), GFP_KERNEL);
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (! data)
 		return -ENOMEM;
 
diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index ae903af93dd32..f76a2f7ac7366 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -243,12 +243,12 @@ static void snd_ctl_led_notify(struct snd_card *card, unsigned int mask,
 static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 			      unsigned int group, bool set)
 {
-	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_kcontrol_volatile *vd;
 	unsigned int ioff, access, new_access;
+	struct snd_card *card __free(snd_card_unref) =
+		snd_card_ref(card_number);
 
-	card = snd_card_ref(card_number);
 	if (!card)
 		return -ENXIO;
 	guard(rwsem_write)(&card->controls_rwsem);
@@ -302,13 +302,13 @@ static void snd_ctl_led_clean(struct snd_card *card)
 
 static int snd_ctl_led_reset(int card_number, unsigned int group)
 {
-	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ctl_led_ctl *lctl, *_lctl;
 	struct snd_ctl_led *led;
 	struct snd_kcontrol_volatile *vd;
 	bool change = false;
+	struct snd_card *card __free(snd_card_unref) =
+		snd_card_ref(card_number);
 
-	card = snd_card_ref(card_number);
 	if (!card)
 		return -ENXIO;
 
@@ -598,11 +598,11 @@ static ssize_t list_show(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct snd_ctl_led_card *led_card = container_of(dev, struct snd_ctl_led_card, dev);
-	struct snd_card *card __free(snd_card_unref) = NULL;
 	struct snd_ctl_led_ctl *lctl;
 	size_t l = 0;
+	struct snd_card *card __free(snd_card_unref) =
+		snd_card_ref(led_card->number);
 
-	card = snd_card_ref(led_card->number);
 	if (!card)
 		return -ENXIO;
 	guard(rwsem_read)(&card->controls_rwsem);
-- 
2.53.0



