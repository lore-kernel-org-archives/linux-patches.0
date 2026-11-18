Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044041;
	b=5fqviEJ+6mMK6p7Z2akbtTKTQ+5xFn6dCo7jeHErc4QynlqvK6d8Vsu6tUbt8AWnphpL
	 byX9w2F8ztEjh4Lsjsgz3cFF2OTHNFUAvk027KfCLEaEn0kcNqw6XhJ3P2Fi+oWmORmr6
	 qUJTqr7eRV2mJrR9h5MEq0IrobxMif0Eak/elVnghSU/ouyP5y3Za4kTmmkPwrrmEqZlA
	 hLvh2aArGmbq/FbpmW/FURlWbipp/IiNobUXfqpdbsI5KPL9Kph1QOqnhj9El17KtrScd
	 KCS4zimq7CnosZzi5nvtiNPGc4cM9ZvaFSL5gU0rBdROzm0l50D4oR2VfqB+3+80Z/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XH8M+MgaDHVvmcU0938tWar+9FsaphuS1ozc2Ggi3ZY=;
	b=TD1uyY8C/8fMuM8YW9J9jCeQSx4I1f022TBLNhW5o7UNlMSGXftSZJCu51jGtV/A1QF5
	 9eG+Js0VlaqFjT6h/MlOqA6gzk9RHh2nUrzXeX5Zr5XGrBl/TlMowSwM3gdgi5Evahp78
	 09U7nSRaeWjqmrZ/giTG9Zpk0CZJw9TgnxFNgESASISD+BhlowfirWCzdcuuW+mMkfkYU
	 jsB2ZqHUabiowpw2RVoxqF0nH/HeUd4c07RezcAyhdy8JBmJFrhP4yKHLY5b8smRlMs7/
	 7BYwWM8ew4vWZjzP3MZaHJAjbWMQOqTX7HY/T/Cbvo6C8hF3BWLosoYxfkk2hUQPfbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSNRE2Lv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2BE606A325;
	Wed, 18 Nov 2026 23:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSNRE2Lv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6701F000C4;
	Wed, 18 Nov 2026 23:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044041;
	bh=XH8M+MgaDHVvmcU0938tWar+9FsaphuS1ozc2Ggi3ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSNRE2Lvn++ZChGy2+K2tjdYz2zZpFvvOOWuskh3STeLwmK+K13pxmzYza49Lc/5B
	 Nq3OUNRgeDSCip3iHJx9yM/k5WLlqcfC4TKKYDlw1jYq0HXbVF1oeqjrZ4pCYTIU4t
	 LcCykfJ1HcPP593jyJG/f3WLAE6GgSoCJ6wxQy2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0427/2857] ALSA: core: Use guard() for locking
Date: Wed, 18 Nov 2026 15:24:21 +0100
Message-ID: <20261118150216.759395701@linuxfoundation.org>
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
index 4258aef4f7a0a..ad7115f3af550 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -279,30 +279,31 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
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
@@ -381,11 +382,10 @@ struct snd_card *snd_card_ref(int idx)
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
@@ -393,12 +393,8 @@ EXPORT_SYMBOL_GPL(snd_card_ref);
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
@@ -422,15 +418,15 @@ static int snd_disconnect_release(struct inode *inode, struct file *file)
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
@@ -496,27 +492,24 @@ void snd_card_disconnect(struct snd_card *card)
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
@@ -552,10 +545,10 @@ void snd_card_disconnect(struct snd_card *card)
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
@@ -576,11 +569,10 @@ void snd_card_disconnect_sync(struct snd_card *card)
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
 
@@ -782,9 +774,8 @@ void snd_card_set_id(struct snd_card *card, const char *nid)
 	/* check if user specified own card->id */
 	if (card->id[0] != '\0')
 		return;
-	mutex_lock(&snd_card_mutex);
+	guard(mutex)(&snd_card_mutex);
 	snd_card_set_id_no_lock(card, nid, nid);
-	mutex_unlock(&snd_card_mutex);
 }
 EXPORT_SYMBOL(snd_card_set_id);
 
@@ -812,14 +803,11 @@ static ssize_t id_store(struct device *dev, struct device_attribute *attr,
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
@@ -912,26 +900,27 @@ int snd_card_register(struct snd_card *card)
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
@@ -952,7 +941,7 @@ static void snd_card_info_read(struct snd_info_entry *entry,
 	struct snd_card *card;
 
 	for (idx = count = 0; idx < SNDRV_CARDS; idx++) {
-		mutex_lock(&snd_card_mutex);
+		guard(mutex)(&snd_card_mutex);
 		card = snd_cards[idx];
 		if (card) {
 			count++;
@@ -964,7 +953,6 @@ static void snd_card_info_read(struct snd_info_entry *entry,
 			snd_iprintf(buffer, "                      %s\n",
 					card->longname);
 		}
-		mutex_unlock(&snd_card_mutex);
 	}
 	if (!count)
 		snd_iprintf(buffer, "--- no soundcards ---\n");
@@ -977,13 +965,12 @@ void snd_card_info_read_oss(struct snd_info_buffer *buffer)
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
@@ -1000,12 +987,11 @@ static void snd_card_module_info_read(struct snd_info_entry *entry,
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
@@ -1087,15 +1073,13 @@ int snd_card_file_add(struct snd_card *card, struct file *file)
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
@@ -1117,22 +1101,21 @@ int snd_card_file_remove(struct snd_card *card, struct file *file)
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



