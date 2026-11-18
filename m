Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040666;
	b=QSr3mFsSCltk5R1Mh2ElIoF/lpDtM9w8TrvOlW7ye6ZeF+WpmPOXrGApinsyDVREfTiM
	 ZZ4E4a8lHPdBkCAUSoSTubggJidGYfmqf7bYhU1w3XG365ViP7BKErS3JGuz3gKrJ6vrB
	 jjMnFXAkhFWtaqCPHqaEW+40SYFiIXAguxYFH+DoRRqHD60XAVGm+zTk7HnbNDi4mtDv3
	 6J1ifeq8x9xvSYJ/qIcjjgBc0CtEU8k/0BPVsEZd0Un3qkbkohllG5EjE44SFLgQSk+71
	 01mO1dKdOjxqIYKDnvSenMhsuzeBGPQicoepxPZbQfbhhUPj95LhWjhbx+/rWeEa+Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GMLhALYt2wfxGXQ7mXw6j8vrN4xYpeN2iN1HHDGogS4=;
	b=DF+4+Yz7COeU1vkJqPnD10tuPJkfJYFq6egfKZ4NqdK65T7Dy48lxnX/eT34XwRyRqlk
	 4Amn+yTuubqXLtjKwNrUnJza4YyzAST2rn6SwxBSk7WRK3jF/U9gUmQC1R304MYzIdQQQ
	 ovCl5wy30+pDZ4ywnOvZsLbCHepr1aaVYHIFY6sTEcutFQuQmazf2qruOyvwgfw8vblwD
	 qCjJxkDY0XbXgdMBPvauDpsDCc8VXvK1+7M3UeRyE3rwThsjTM0zVk9M++lJEGtg76MVj
	 0QNipg0N68M+yagRGloseUwDGSUMt8+jSFgGjnEL8Ie9YKUG+w3+mT8Z1HZ6+7ggPuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltWKutI8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57935606A31C;
	Wed, 18 Nov 2026 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltWKutI8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7401F000C4;
	Wed, 18 Nov 2026 22:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040666;
	bh=GMLhALYt2wfxGXQ7mXw6j8vrN4xYpeN2iN1HHDGogS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltWKutI8H1Zr5akdcldj+4FzA0k/EXKuybKRXya0KhIsC7PyWurYOJW6OBZIj9Ean
	 OHf402NiKFc/3vNrzGXJ1pqvHWhLmKMv0U0YBKzdr69yS3xSJyQAatdKD9fcalqvP9
	 OurW08HdeoNPNFYVll0p/79LsH8JFJ5dychSsQQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com,
	Li Youhong <liyouhong@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2536/3318] md/raid5: drain released_stripes before destroying the cache
Date: Wed, 18 Nov 2026 15:52:38 +0100
Message-ID: <20261118150437.400799623@linuxfoundation.org>
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

From: Li Youhong <liyouhong@kylinos.cn>

[ Upstream commit af560e357a81964544be40c549e241b032ef7565 ]

grow_one_stripe() calls raid5_release_stripe() for each new stripe.
When mddev->thread is already set, that queues the stripe on
conf->released_stripes and wakes the thread. Only raid5d moves that
list onto inactive_list.

Takeover calls setup_conf() while mddev->thread still belongs to the
previous personality, so those stripes stay on released_stripes. If
setup_conf() then fails, shrink_stripes() only frees inactive_list and
kmem_cache_destroy() warns that objects remain.

Move stripes still queued on released_stripes onto inactive_list
before shrink_stripes() frees them.

Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
Reported-by: syzbot+6a132745caefcf42cb0d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-raid/6ab6b743.7eec07f4.c25c.0006.GAE@google.com/T/#t
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Link: https://patch.msgid.link/20260929083916.50620-1-dayou5941@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 52eec38f17c3b..9bfd9cdc363a9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2720,6 +2720,37 @@ static int drop_one_stripe(struct r5conf *conf)
 
 static void shrink_stripes(struct r5conf *conf)
 {
+	struct list_head temp[NR_STRIPE_HASH_LOCKS];
+	int i;
+
+	/*
+	 * grow_one_stripe() parks new stripes on released_stripes when
+	 * mddev->thread is already set. Takeover leaves the previous
+	 * personality's thread there, so raid5d never moves them to
+	 * inactive_list. Drain them before the cache is destroyed.
+	 * slab_cache is assigned only after device_lock and the hash
+	 * lists exist; earlier abort paths have nothing to drain.
+	 */
+	if (conf->slab_cache) {
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
+			INIT_LIST_HEAD(&temp[i]);
+
+		spin_lock_irq(&conf->device_lock);
+		release_stripe_list(conf, temp);
+		spin_unlock_irq(&conf->device_lock);
+
+		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++) {
+			if (list_empty(&temp[i]))
+				continue;
+			spin_lock_irq(conf->hash_locks + i);
+			if (list_empty(conf->inactive_list + i))
+				atomic_dec(&conf->empty_inactive_list_nr);
+			list_splice_tail_init(&temp[i],
+					      conf->inactive_list + i);
+			spin_unlock_irq(conf->hash_locks + i);
+		}
+	}
+
 	while (conf->max_nr_stripes &&
 	       drop_one_stripe(conf))
 		;
-- 
2.53.0



