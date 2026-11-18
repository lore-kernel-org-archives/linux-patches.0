Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044039;
	b=tvONcG2DXTaDSpc6ejgPFbTt46wxWDndjuCBK5wHz/M6JrgKyP1pKHTY4AzdcRo/1e9x
	 9KlgvDehOr/C5x2bn8qzZBV1xSeaJ1oDgX6OTbL4TuqyXfmtKJdl/P/hzyHJKiEPF7WGW
	 WWv+tVgirK0+cKZnrMVeOMKvEM1Nh/p/aIuzoGRq0dzBQkihanY1rGbIYnrHaOUBd7vrQ
	 wyEK+6vIGXBF/IMkVuDAN8kw8Vn2eTHjKKhPCaR0TKtIW0O0kV5NnDlNlJLQCJcobFo3b
	 NmgNCVMKQ/fipxpKQbaKOKhcesNRvvCfSEeBYPygp1jncAqA09ArObzbH312tHOC/jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=y0OcTdRQsqaKk4MD6I4tln4E4t7MobVkJTOKZkwOadg=;
	b=q40eowbsyxJfZpxVcrN7EF8SjO04RGM7A4PFJ0Ey95BDXxbsru+el3po2EmY8BT/vC6Y
	 y3DMt7D3sqFmoswaH2xISvmpYeLfOG2GoaMHhJEAeeiFcF+9Aaaqb4BzqGgJ5coM1f5Qz
	 OELXXiCqIeuKFYO+KBVBF1CL1Bp63lJ0ToIubhFCRJtcQApaH6hAGykX/Y2KRu0X/f25a
	 ovl3efJVanJclpAGWNw5yLD9KhnPjfRrOlyeVsa1EQJv1JklfZEBruHuVMbj2ZH03ywyQ
	 Fb4k1/skH5aIzh0qiM8DJqoSs83mA6oPwxjnsg0Lr8jgXl60qiaQ22RVLNfXUgV90tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7mB468W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE72606A339;
	Wed, 18 Nov 2026 23:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7mB468W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748441F000C4;
	Wed, 18 Nov 2026 23:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044038;
	bh=y0OcTdRQsqaKk4MD6I4tln4E4t7MobVkJTOKZkwOadg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7mB468WfnBP4XTrMVyKj2yrocZSoP1wX5oxKBA4oKiPyOeWBt/1RYl3frpBJF3B+
	 snOOovoZNdyAvEWfBlL+3W0XmsDf8YEEoOmPDOHi0glAMAJRtHakWRpR26N1rs+cLl
	 Kbotg7wA6EKH6vaNdhzU1luEezJehA7Ive5+d/D0=
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
Subject: [PATCH 6.1 0426/2857] ALSA: core: Make snd_card_disconnect() return void
Date: Wed, 18 Nov 2026 15:24:20 +0100
Message-ID: <20261118150216.723816981@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: fd95e68df6fe ("ALSA: core: Fix potential UAF after asynchronous card release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h |  2 +-
 sound/core/init.c    | 24 ++++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 4365c35d038b4..9a73c60b6f1ea 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -286,7 +286,7 @@ int snd_devm_card_new(struct device *parent, int idx, const char *xid,
 		      struct module *module, size_t extra_size,
 		      struct snd_card **card_ret);
 
-int snd_card_disconnect(struct snd_card *card);
+void snd_card_disconnect(struct snd_card *card);
 void snd_card_disconnect_sync(struct snd_card *card);
 int snd_card_free(struct snd_card *card);
 int snd_card_free_when_closed(struct snd_card *card);
diff --git a/sound/core/init.c b/sound/core/init.c
index 2cb554b393fce..4258aef4f7a0a 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -489,17 +489,17 @@ static const struct file_operations snd_shutdown_f_ops =
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
 
@@ -560,7 +560,6 @@ int snd_card_disconnect(struct snd_card *card)
 #ifdef CONFIG_PM
 	snd_power_sync_ref(card);
 #endif
-	return 0;	
 }
 EXPORT_SYMBOL(snd_card_disconnect);
 
@@ -575,15 +574,7 @@ EXPORT_SYMBOL(snd_card_disconnect);
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
@@ -629,9 +620,10 @@ static int snd_card_do_free(struct snd_card *card)
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



