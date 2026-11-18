Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055942;
	b=yc4xi6fMZQzSYT0h0NA/wdIZRImy3tcpVe+9LNy/w+PNZqt145GhQ959XeXofh0KC/Rq
	 ymWXU7SpSYiRlcgnGQCM7XJ49IOE51wwll6+CSePZ8gtPjdBsakwz1NgY2FQvmU+kXXIK
	 epxXV3Wcyr79MMLteo3Pnp9edKQ/gss0fY2L+YIzs65sXS6pR79Co+z/cABfRAaMJVC1q
	 vueV0EAeYGShU0ed91nFQR9tcYJ1Y5bK/N5oa3Yzm5JLTZ9SMyj//HbL/QPMsi+ciLv0b
	 30i7G3DXmYT6qW3+E/+4VuW90NABu4hXiKFSha2f6LnHvnYuchPQX8JLV/gs0j2CLUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pk5N5RiobHdAEOHQWvjOm/sygJIbYTAh9iGzLHO/54U=;
	b=tyL+sQ4ir4Xg0IiW0Shz7YM0jaftXCOes62lHYEMQsLijXD6vzymQixAojFGLZpPS6ug
	 09dId6RqypL0zMEWdzA/CI1qrQFyQhPgs+Xa0ZlSlSVVzG4MkEKqaCj+O/mU3VVvhq3wg
	 L07pzxnCt7lNEODg2OUnVWz0yomgxzV+sp7IobQIiuQuMU8opU/V2or12fIHHdnewbnOF
	 qjAQSrLZ1BIwCvgB+urI/EPSbPLwzLvYMjhjYcoDET3AazFeyys+6ldt8GVh9JON/I5GA
	 IOOpjvU6TMdMNOGwTZPrbYwcnUL7/BdbwUJqJSntAuu1CM9NMV3Zhtf8Zx+/ILtg57w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TvWvN/69";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D68D606A31C;
	Thu, 19 Nov 2026 02:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvWvN/69
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4171F000C4;
	Thu, 19 Nov 2026 02:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055942;
	bh=pk5N5RiobHdAEOHQWvjOm/sygJIbYTAh9iGzLHO/54U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvWvN/69oBZoXaMQ+Q3WLjo5OAhoF7x9tKX23sD9Q+Jty/4bMWc+JrzBFVed9qbdm
	 m4ybDuEanOne8QzHGJlzOBn/4CfnnHOyX/N0phujpAQi1+N3uTv2MViBIyLNze83hX
	 bRqpoKZzuSAl6Z4XAxKyTEf3kzGhOPOYmO4efwsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Geoff Levand <geoff@infradead.org>,
	Thierry Reding <treding@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1809/2214] ALSA: core: Make snd_card_disconnect() return void
Date: Wed, 18 Nov 2026 15:58:05 +0100
Message-ID: <20261118150123.855173712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 663f922fd7a9e9342dca512db339c7fb2b59b8e6 ]

All callers from other files ignore the return value of this function.
And it can only ever return a non-zero value if the parameter card is NULL.

Move the check for card being NULL into snd_card_free_when_closed() to keep
the previous behaviour. Note this isn't necessary for
snd_card_disconnect_sync() because if card was NULL in there the dereference
of card for dev_err() would oops the kernel. Replace this by an oops
triggered by the dereference of card for spin_lock_irq().

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Acked-by: Geoff Levand <geoff@infradead.org>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20230207191907.467756-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h |  2 +-
 sound/core/init.c    | 24 ++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 39cee40ac22e0..5f6a6dde20303 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -280,7 +280,7 @@ int snd_devm_card_new(struct device *parent, int idx, const char *xid,
 		      struct module *module, size_t extra_size,
 		      struct snd_card **card_ret);
 
-int snd_card_disconnect(struct snd_card *card);
+void snd_card_disconnect(struct snd_card *card);
 void snd_card_disconnect_sync(struct snd_card *card);
 int snd_card_free(struct snd_card *card);
 int snd_card_free_when_closed(struct snd_card *card);
diff --git a/sound/core/init.c b/sound/core/init.c
index e9465b31f9fda..b915f4461ec23 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -479,17 +479,17 @@ static const struct file_operations snd_shutdown_f_ops =
  *  Note: The current implementation replaces all active file->f_op with special
  *        dummy file operations (they do nothing except release).
  */
-int snd_card_disconnect(struct snd_card *card)
+void snd_card_disconnect(struct snd_card *card)
 {
 	struct snd_monitor_file *mfile;
 
 	if (!card)
-		return -EINVAL;
+		return;
 
 	spin_lock(&card->files_lock);
 	if (card->shutdown) {
 		spin_unlock(&card->files_lock);
-		return 0;
+		return;
 	}
 	card->shutdown = 1;
 
@@ -545,7 +545,6 @@ int snd_card_disconnect(struct snd_card *card)
 #ifdef CONFIG_PM
 	snd_power_sync_ref(card);
 #endif
-	return 0;	
 }
 EXPORT_SYMBOL(snd_card_disconnect);
 
@@ -560,15 +559,7 @@ EXPORT_SYMBOL(snd_card_disconnect);
  */
 void snd_card_disconnect_sync(struct snd_card *card)
 {
-	int err;
-
-	err = snd_card_disconnect(card);
-	if (err < 0) {
-		dev_err(card->dev,
-			"snd_card_disconnect error (%d), skipping sync\n",
-			err);
-		return;
-	}
+	snd_card_disconnect(card);
 
 	spin_lock_irq(&card->files_lock);
 	wait_event_lock_irq(card->remove_sleep,
@@ -616,9 +607,10 @@ static int snd_card_do_free(struct snd_card *card)
  */
 int snd_card_free_when_closed(struct snd_card *card)
 {
-	int ret = snd_card_disconnect(card);
-	if (ret)
-		return ret;
+	if (!card)
+		return -EINVAL;
+
+	snd_card_disconnect(card);
 	put_device(&card->card_dev);
 	return 0;
 }
-- 
2.53.0



