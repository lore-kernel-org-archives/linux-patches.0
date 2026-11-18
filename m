Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034738;
	b=NGwzwEEnNIV9iBl3GfCuZZDvOioDmdI4b81i95TF4KqIW7Zx1lxvpfqGA/7WFcHPn+Gr
	 d4QT8KqGqW1Buj+iOtGJAAqJLBcVavdps+ZQ7hJ40jTQzGqAYc4gD+T23hOax6PNkLPmj
	 t6qx2fYv4sUFoUcKGvhmdqSMRgAW7GDATxi+4+XSPNhNUbcs0eynN4KK7X00HbAIjeF5G
	 EzBvn9EkBHlgh4eIhgNhQvyPFi3mA239qIqtvoEJfp2Gm8u4NdxXl9RC1oZXcU81j68BE
	 WuNrtlHyZFk0v4vxrr54LuHWUavYI/3z4Zpu2/ga9PzBL8Fzv/uYqSBuX5rD1+Vz8Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I4brx6xg+zfPvq+tvhTcc5jLZFzGG1UMs6VM0SPKsgg=;
	b=3/8EoE7i3A/dpFZUZlo3oI4lapbD0sk9s0CEvNPdxeUMj+Jlp7j6Yn1eYBCIvITMfzFd
	 idQlK5R1XbL2JrXtVcpWSv9gBJx0eBTCOxHjLPXXn1UUhr48CJq1vMj4PQV9yIIf9ByIU
	 LbhnEH0mFTHOURtU1QMnJyGRWFrW6oNzNiT0yludCz7rKbp31v+NAmrk1WcC1qR0tE/C8
	 fR4TWY0zxd+V7nzEQUiC6WUtG0OBJ7bQ7wKyIi/TqdDUpSN4cP2mXeDjEaYaHRQ6d3lop
	 szcgfQq1ofNSza2NlepoQsNe8sjqfCI+l3JRXWLzlEvn6ito9rIeaoMPMIkYUpgb1Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzgsF0jT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E5606A320;
	Wed, 18 Nov 2026 20:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzgsF0jT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E951F000C4;
	Wed, 18 Nov 2026 20:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034738;
	bh=I4brx6xg+zfPvq+tvhTcc5jLZFzGG1UMs6VM0SPKsgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzgsF0jTKpddZ7owTGFC8NwfFGeiBc3MxeSdmbdKEqJ5lt9PqH92YCyVCygdaGOC9
	 8jTq4a+HuKIDRMy6C7QQT4pRBt9FbZGvEfSW9MRPLltmMB2Rg/rxTs47cz6SS0/HOd
	 DWZ9Gcg4E5f1Bakv0Ly1CW44U1zOxdFgrI8wOLHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0474/3318] ALSA: core: Use guard() for locking
Date: Wed, 18 Nov 2026 15:18:16 +0100
Message-ID: <20261118150331.135355541@linuxfoundation.org>
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

[ Upstream commit 742ecf3ce1acdbcd0bc936178e1eaf346a0fd376 ]

We can simplify the code gracefully with new guard() macro and co for
automatic cleanup of locks.

Only the code refactoring, and no functional changes.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240227085306.9764-12-tiwai@suse.de
Stable-dep-of: fd95e68df6fe ("ALSA: core: Fix potential UAF after asynchronous card release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c      | 193 +++++++++++++++++++----------------------
 sound/core/sound.c     |  28 +++---
 sound/core/sound_oss.c |  17 ++--
 3 files changed, 104 insertions(+), 134 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index bc6d7a79b0c6e..9b718f7b381d3 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -284,30 +284,31 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
 	if (xid)
 		strscpy(card->id, xid, sizeof(card->id));
 	err = 0;
-	mutex_lock(&snd_card_mutex);
-	if (idx < 0) /* first check the matching module-name slot */
-		idx = get_slot_from_bitmask(idx, module_slot_match, module);
-	if (idx < 0) /* if not matched, assign an empty slot */
-		idx = get_slot_from_bitmask(idx, check_empty_slot, module);
-	if (idx < 0)
-		err = -ENODEV;
-	else if (idx < snd_ecards_limit) {
-		if (test_bit(idx, snd_cards_lock))
-			err = -EBUSY;	/* invalid */
-	} else if (idx >= SNDRV_CARDS)
-		err = -ENODEV;
+	scoped_guard(mutex, &snd_card_mutex) {
+		if (idx < 0) /* first check the matching module-name slot */
+			idx = get_slot_from_bitmask(idx, module_slot_match, module);
+		if (idx < 0) /* if not matched, assign an empty slot */
+			idx = get_slot_from_bitmask(idx, check_empty_slot, module);
+		if (idx < 0)
+			err = -ENODEV;
+		else if (idx < snd_ecards_limit) {
+			if (test_bit(idx, snd_cards_lock))
+				err = -EBUSY;	/* invalid */
+		} else if (idx >= SNDRV_CARDS)
+			err = -ENODEV;
+		if (!err) {
+			set_bit(idx, snd_cards_lock);		/* lock it */
+			if (idx >= snd_ecards_limit)
+				snd_ecards_limit = idx + 1; /* increase the limit */
+		}
+	}
 	if (err < 0) {
-		mutex_unlock(&snd_card_mutex);
 		dev_err(parent, "cannot find the slot for index %d (range 0-%i), error: %d\n",
-			 idx, snd_ecards_limit - 1, err);
+			idx, snd_ecards_limit - 1, err);
 		if (!card->managed)
 			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
-	set_bit(idx, snd_cards_lock);		/* lock it */
-	if (idx >= snd_ecards_limit)
-		snd_ecards_limit = idx + 1; /* increase the limit */
-	mutex_unlock(&snd_card_mutex);
 	card->dev = parent;
 	card->number = idx;
 #ifdef MODULE
@@ -386,11 +387,10 @@ struct snd_card *snd_card_ref(int idx)
 {
 	struct snd_card *card;
 
-	mutex_lock(&snd_card_mutex);
+	guard(mutex)(&snd_card_mutex);
 	card = snd_cards[idx];
 	if (card)
 		get_device(&card->card_dev);
-	mutex_unlock(&snd_card_mutex);
 	return card;
 }
 EXPORT_SYMBOL_GPL(snd_card_ref);
@@ -398,12 +398,8 @@ EXPORT_SYMBOL_GPL(snd_card_ref);
 /* return non-zero if a card is already locked */
 int snd_card_locked(int card)
 {
-	int locked;
-
-	mutex_lock(&snd_card_mutex);
-	locked = test_bit(card, snd_cards_lock);
-	mutex_unlock(&snd_card_mutex);
-	return locked;
+	guard(mutex)(&snd_card_mutex);
+	return test_bit(card, snd_cards_lock);
 }
 
 static loff_t snd_disconnect_llseek(struct file *file, loff_t offset, int orig)
@@ -427,15 +423,15 @@ static int snd_disconnect_release(struct inode *inode, struct file *file)
 {
 	struct snd_monitor_file *df = NULL, *_df;
 
-	spin_lock(&shutdown_lock);
-	list_for_each_entry(_df, &shutdown_files, shutdown_list) {
-		if (_df->file == file) {
-			df = _df;
-			list_del_init(&df->shutdown_list);
-			break;
+	scoped_guard(spinlock, &shutdown_lock) {
+		list_for_each_entry(_df, &shutdown_files, shutdown_list) {
+			if (_df->file == file) {
+				df = _df;
+				list_del_init(&df->shutdown_list);
+				break;
+			}
 		}
 	}
-	spin_unlock(&shutdown_lock);
 
 	if (likely(df)) {
 		if ((file->f_flags & FASYNC) && df->disconnected_f_op->fasync)
@@ -501,27 +497,24 @@ void snd_card_disconnect(struct snd_card *card)
 	if (!card)
 		return;
 
-	spin_lock(&card->files_lock);
-	if (card->shutdown) {
-		spin_unlock(&card->files_lock);
-		return;
-	}
-	card->shutdown = 1;
+	scoped_guard(spinlock, &card->files_lock) {
+		if (card->shutdown)
+			return;
+		card->shutdown = 1;
 
-	/* replace file->f_op with special dummy operations */
-	list_for_each_entry(mfile, &card->files_list, list) {
-		/* it's critical part, use endless loop */
-		/* we have no room to fail */
-		mfile->disconnected_f_op = mfile->file->f_op;
+		/* replace file->f_op with special dummy operations */
+		list_for_each_entry(mfile, &card->files_list, list) {
+			/* it's critical part, use endless loop */
+			/* we have no room to fail */
+			mfile->disconnected_f_op = mfile->file->f_op;
 
-		spin_lock(&shutdown_lock);
-		list_add(&mfile->shutdown_list, &shutdown_files);
-		spin_unlock(&shutdown_lock);
+			scoped_guard(spinlock, &shutdown_lock)
+				list_add(&mfile->shutdown_list, &shutdown_files);
 
-		mfile->file->f_op = &snd_shutdown_f_ops;
-		fops_get(mfile->file->f_op);
+			mfile->file->f_op = &snd_shutdown_f_ops;
+			fops_get(mfile->file->f_op);
+		}
 	}
-	spin_unlock(&card->files_lock);	
 
 #ifdef CONFIG_PM
 	/* wake up sleepers here before other callbacks for avoiding potential
@@ -557,10 +550,10 @@ void snd_card_disconnect(struct snd_card *card)
 	}
 
 	/* disable fops (user space) operations for ALSA API */
-	mutex_lock(&snd_card_mutex);
-	snd_cards[card->number] = NULL;
-	clear_bit(card->number, snd_cards_lock);
-	mutex_unlock(&snd_card_mutex);
+	scoped_guard(mutex, &snd_card_mutex) {
+		snd_cards[card->number] = NULL;
+		clear_bit(card->number, snd_cards_lock);
+	}
 
 #ifdef CONFIG_PM
 	snd_power_sync_ref(card);
@@ -581,11 +574,10 @@ void snd_card_disconnect_sync(struct snd_card *card)
 {
 	snd_card_disconnect(card);
 
-	spin_lock_irq(&card->files_lock);
+	guard(spinlock_irq)(&card->files_lock);
 	wait_event_lock_irq(card->remove_sleep,
 			    list_empty(&card->files_list),
 			    card->files_lock);
-	spin_unlock_irq(&card->files_lock);
 }
 EXPORT_SYMBOL_GPL(snd_card_disconnect_sync);
 
@@ -783,9 +775,8 @@ void snd_card_set_id(struct snd_card *card, const char *nid)
 	/* check if user specified own card->id */
 	if (card->id[0] != '\0')
 		return;
-	mutex_lock(&snd_card_mutex);
+	guard(mutex)(&snd_card_mutex);
 	snd_card_set_id_no_lock(card, nid, nid);
-	mutex_unlock(&snd_card_mutex);
 }
 EXPORT_SYMBOL(snd_card_set_id);
 
@@ -813,14 +804,11 @@ static ssize_t id_store(struct device *dev, struct device_attribute *attr,
 	}
 	memcpy(buf1, buf, copy);
 	buf1[copy] = '\0';
-	mutex_lock(&snd_card_mutex);
-	if (!card_id_ok(NULL, buf1)) {
-		mutex_unlock(&snd_card_mutex);
+	guard(mutex)(&snd_card_mutex);
+	if (!card_id_ok(NULL, buf1))
 		return -EEXIST;
-	}
 	strcpy(card->id, buf1);
 	snd_info_card_id_change(card);
-	mutex_unlock(&snd_card_mutex);
 
 	return count;
 }
@@ -913,26 +901,27 @@ int snd_card_register(struct snd_card *card)
 	err = snd_device_register_all(card);
 	if (err < 0)
 		return err;
-	mutex_lock(&snd_card_mutex);
-	if (snd_cards[card->number]) {
-		/* already registered */
-		mutex_unlock(&snd_card_mutex);
-		return snd_info_card_register(card); /* register pending info */
-	}
-	if (*card->id) {
-		/* make a unique id name from the given string */
-		char tmpid[sizeof(card->id)];
-		memcpy(tmpid, card->id, sizeof(card->id));
-		snd_card_set_id_no_lock(card, tmpid, tmpid);
-	} else {
-		/* create an id from either shortname or longname */
-		const char *src;
-		src = *card->shortname ? card->shortname : card->longname;
-		snd_card_set_id_no_lock(card, src,
-					retrieve_id_from_card_name(src));
+	scoped_guard(mutex, &snd_card_mutex) {
+		if (snd_cards[card->number]) {
+			/* already registered */
+			return snd_info_card_register(card); /* register pending info */
+		}
+		if (*card->id) {
+			/* make a unique id name from the given string */
+			char tmpid[sizeof(card->id)];
+
+			memcpy(tmpid, card->id, sizeof(card->id));
+			snd_card_set_id_no_lock(card, tmpid, tmpid);
+		} else {
+			/* create an id from either shortname or longname */
+			const char *src;
+
+			src = *card->shortname ? card->shortname : card->longname;
+			snd_card_set_id_no_lock(card, src,
+						retrieve_id_from_card_name(src));
+		}
+		snd_cards[card->number] = card;
 	}
-	snd_cards[card->number] = card;
-	mutex_unlock(&snd_card_mutex);
 	err = snd_info_card_register(card);
 	if (err < 0)
 		return err;
@@ -953,7 +942,7 @@ static void snd_card_info_read(struct snd_info_entry *entry,
 	struct snd_card *card;
 
 	for (idx = count = 0; idx < SNDRV_CARDS; idx++) {
-		mutex_lock(&snd_card_mutex);
+		guard(mutex)(&snd_card_mutex);
 		card = snd_cards[idx];
 		if (card) {
 			count++;
@@ -965,7 +954,6 @@ static void snd_card_info_read(struct snd_info_entry *entry,
 			snd_iprintf(buffer, "                      %s\n",
 					card->longname);
 		}
-		mutex_unlock(&snd_card_mutex);
 	}
 	if (!count)
 		snd_iprintf(buffer, "--- no soundcards ---\n");
@@ -978,13 +966,12 @@ void snd_card_info_read_oss(struct snd_info_buffer *buffer)
 	struct snd_card *card;
 
 	for (idx = count = 0; idx < SNDRV_CARDS; idx++) {
-		mutex_lock(&snd_card_mutex);
+		guard(mutex)(&snd_card_mutex);
 		card = snd_cards[idx];
 		if (card) {
 			count++;
 			snd_iprintf(buffer, "%s\n", card->longname);
 		}
-		mutex_unlock(&snd_card_mutex);
 	}
 	if (!count) {
 		snd_iprintf(buffer, "--- no soundcards ---\n");
@@ -1001,12 +988,11 @@ static void snd_card_module_info_read(struct snd_info_entry *entry,
 	struct snd_card *card;
 
 	for (idx = 0; idx < SNDRV_CARDS; idx++) {
-		mutex_lock(&snd_card_mutex);
+		guard(mutex)(&snd_card_mutex);
 		card = snd_cards[idx];
 		if (card)
 			snd_iprintf(buffer, "%2i %s\n",
 				    idx, card->module->name);
-		mutex_unlock(&snd_card_mutex);
 	}
 }
 #endif
@@ -1088,15 +1074,13 @@ int snd_card_file_add(struct snd_card *card, struct file *file)
 	mfile->file = file;
 	mfile->disconnected_f_op = NULL;
 	INIT_LIST_HEAD(&mfile->shutdown_list);
-	spin_lock(&card->files_lock);
+	guard(spinlock)(&card->files_lock);
 	if (card->shutdown) {
-		spin_unlock(&card->files_lock);
 		kfree(mfile);
 		return -ENODEV;
 	}
 	list_add(&mfile->list, &card->files_list);
 	get_device(&card->card_dev);
-	spin_unlock(&card->files_lock);
 	return 0;
 }
 EXPORT_SYMBOL(snd_card_file_add);
@@ -1118,22 +1102,21 @@ int snd_card_file_remove(struct snd_card *card, struct file *file)
 {
 	struct snd_monitor_file *mfile, *found = NULL;
 
-	spin_lock(&card->files_lock);
-	list_for_each_entry(mfile, &card->files_list, list) {
-		if (mfile->file == file) {
-			list_del(&mfile->list);
-			spin_lock(&shutdown_lock);
-			list_del(&mfile->shutdown_list);
-			spin_unlock(&shutdown_lock);
-			if (mfile->disconnected_f_op)
-				fops_put(mfile->disconnected_f_op);
-			found = mfile;
-			break;
+	scoped_guard(spinlock, &card->files_lock) {
+		list_for_each_entry(mfile, &card->files_list, list) {
+			if (mfile->file == file) {
+				list_del(&mfile->list);
+				scoped_guard(spinlock, &shutdown_lock)
+					list_del(&mfile->shutdown_list);
+				if (mfile->disconnected_f_op)
+					fops_put(mfile->disconnected_f_op);
+				found = mfile;
+				break;
+			}
 		}
+		if (list_empty(&card->files_list))
+			wake_up_all(&card->remove_sleep);
 	}
-	if (list_empty(&card->files_list))
-		wake_up_all(&card->remove_sleep);
-	spin_unlock(&card->files_lock);
 	if (!found) {
 		dev_err(card->dev, "card file remove problem (%p)\n", file);
 		return -ENOENT;
diff --git a/sound/core/sound.c b/sound/core/sound.c
index f3bb0adf37cce..6644fbe1bd256 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -103,7 +103,7 @@ void *snd_lookup_minor_data(unsigned int minor, int type)
 
 	if (minor >= ARRAY_SIZE(snd_minors))
 		return NULL;
-	mutex_lock(&sound_mutex);
+	guard(mutex)(&sound_mutex);
 	mreg = snd_minors[minor];
 	if (mreg && mreg->type == type) {
 		private_data = mreg->private_data;
@@ -111,7 +111,6 @@ void *snd_lookup_minor_data(unsigned int minor, int type)
 			get_device(&mreg->card_ptr->card_dev);
 	} else
 		private_data = NULL;
-	mutex_unlock(&sound_mutex);
 	return private_data;
 }
 EXPORT_SYMBOL(snd_lookup_minor_data);
@@ -150,17 +149,15 @@ static int snd_open(struct inode *inode, struct file *file)
 
 	if (minor >= ARRAY_SIZE(snd_minors))
 		return -ENODEV;
-	mutex_lock(&sound_mutex);
-	mptr = snd_minors[minor];
-	if (mptr == NULL) {
-		mptr = autoload_device(minor);
-		if (!mptr) {
-			mutex_unlock(&sound_mutex);
-			return -ENODEV;
+	scoped_guard(mutex, &sound_mutex) {
+		mptr = snd_minors[minor];
+		if (mptr == NULL) {
+			mptr = autoload_device(minor);
+			if (!mptr)
+				return -ENODEV;
 		}
+		new_fops = fops_get(mptr->f_ops);
 	}
-	new_fops = fops_get(mptr->f_ops);
-	mutex_unlock(&sound_mutex);
 	if (!new_fops)
 		return -ENODEV;
 	replace_fops(file, new_fops);
@@ -276,7 +273,7 @@ int snd_register_device(int type, struct snd_card *card, int dev,
 	preg->f_ops = f_ops;
 	preg->private_data = private_data;
 	preg->card_ptr = card;
-	mutex_lock(&sound_mutex);
+	guard(mutex)(&sound_mutex);
 	minor = snd_find_free_minor(type, card, dev);
 	if (minor < 0) {
 		err = minor;
@@ -291,7 +288,6 @@ int snd_register_device(int type, struct snd_card *card, int dev,
 
 	snd_minors[minor] = preg;
  error:
-	mutex_unlock(&sound_mutex);
 	if (err < 0)
 		kfree(preg);
 	return err;
@@ -312,7 +308,7 @@ int snd_unregister_device(struct device *dev)
 	int minor;
 	struct snd_minor *preg;
 
-	mutex_lock(&sound_mutex);
+	guard(mutex)(&sound_mutex);
 	for (minor = 0; minor < ARRAY_SIZE(snd_minors); ++minor) {
 		preg = snd_minors[minor];
 		if (preg && preg->dev == dev) {
@@ -322,7 +318,6 @@ int snd_unregister_device(struct device *dev)
 			break;
 		}
 	}
-	mutex_unlock(&sound_mutex);
 	if (minor >= ARRAY_SIZE(snd_minors))
 		return -ENOENT;
 	return 0;
@@ -362,7 +357,7 @@ static void snd_minor_info_read(struct snd_info_entry *entry, struct snd_info_bu
 	int minor;
 	struct snd_minor *mptr;
 
-	mutex_lock(&sound_mutex);
+	guard(mutex)(&sound_mutex);
 	for (minor = 0; minor < SNDRV_OS_MINORS; ++minor) {
 		mptr = snd_minors[minor];
 		if (!mptr)
@@ -380,7 +375,6 @@ static void snd_minor_info_read(struct snd_info_entry *entry, struct snd_info_bu
 			snd_iprintf(buffer, "%3i:        : %s\n", minor,
 				    snd_device_type_name(mptr->type));
 	}
-	mutex_unlock(&sound_mutex);
 }
 
 int __init snd_minor_info_init(void)
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index 2751bf2ff61bc..d65cc6fee2e60 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -29,7 +29,7 @@ void *snd_lookup_oss_minor_data(unsigned int minor, int type)
 
 	if (minor >= ARRAY_SIZE(snd_oss_minors))
 		return NULL;
-	mutex_lock(&sound_oss_mutex);
+	guard(mutex)(&sound_oss_mutex);
 	mreg = snd_oss_minors[minor];
 	if (mreg && mreg->type == type) {
 		private_data = mreg->private_data;
@@ -37,7 +37,6 @@ void *snd_lookup_oss_minor_data(unsigned int minor, int type)
 			get_device(&mreg->card_ptr->card_dev);
 	} else
 		private_data = NULL;
-	mutex_unlock(&sound_oss_mutex);
 	return private_data;
 }
 EXPORT_SYMBOL(snd_lookup_oss_minor_data);
@@ -106,7 +105,7 @@ int snd_register_oss_device(int type, struct snd_card *card, int dev,
 	preg->f_ops = f_ops;
 	preg->private_data = private_data;
 	preg->card_ptr = card;
-	mutex_lock(&sound_oss_mutex);
+	guard(mutex)(&sound_oss_mutex);
 	snd_oss_minors[minor] = preg;
 	minor_unit = SNDRV_MINOR_OSS_DEVICE(minor);
 	switch (minor_unit) {
@@ -130,7 +129,6 @@ int snd_register_oss_device(int type, struct snd_card *card, int dev,
 			goto __end;
 		snd_oss_minors[track2] = preg;
 	}
-	mutex_unlock(&sound_oss_mutex);
 	return 0;
 
       __end:
@@ -139,7 +137,6 @@ int snd_register_oss_device(int type, struct snd_card *card, int dev,
       	if (register1 >= 0)
       		unregister_sound_special(register1);
 	snd_oss_minors[minor] = NULL;
-	mutex_unlock(&sound_oss_mutex);
 	kfree(preg);
       	return -EBUSY;
 }
@@ -156,12 +153,10 @@ int snd_unregister_oss_device(int type, struct snd_card *card, int dev)
 		return 0;
 	if (minor < 0)
 		return minor;
-	mutex_lock(&sound_oss_mutex);
+	guard(mutex)(&sound_oss_mutex);
 	mptr = snd_oss_minors[minor];
-	if (mptr == NULL) {
-		mutex_unlock(&sound_oss_mutex);
+	if (mptr == NULL)
 		return -ENOENT;
-	}
 	switch (SNDRV_MINOR_OSS_DEVICE(minor)) {
 	case SNDRV_MINOR_OSS_PCM:
 		track2 = SNDRV_MINOR_OSS(cidx, SNDRV_MINOR_OSS_AUDIO);
@@ -176,7 +171,6 @@ int snd_unregister_oss_device(int type, struct snd_card *card, int dev)
 	if (track2 >= 0)
 		snd_oss_minors[track2] = NULL;
 	snd_oss_minors[minor] = NULL;
-	mutex_unlock(&sound_oss_mutex);
 
 	/* call unregister_sound_special() outside sound_oss_mutex;
 	 * otherwise may deadlock, as it can trigger the release of a card
@@ -220,7 +214,7 @@ static void snd_minor_info_oss_read(struct snd_info_entry *entry,
 	int minor;
 	struct snd_minor *mptr;
 
-	mutex_lock(&sound_oss_mutex);
+	guard(mutex)(&sound_oss_mutex);
 	for (minor = 0; minor < SNDRV_OSS_MINORS; ++minor) {
 		mptr = snd_oss_minors[minor];
 		if (!mptr)
@@ -233,7 +227,6 @@ static void snd_minor_info_oss_read(struct snd_info_entry *entry,
 			snd_iprintf(buffer, "%3i:       : %s\n", minor,
 				    snd_oss_device_type_name(mptr->type));
 	}
-	mutex_unlock(&sound_oss_mutex);
 }
 
 
-- 
2.53.0



