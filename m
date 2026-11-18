Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038557;
	b=hS9kx19HFALuwS5FiUz+VojnaxlFI9DqaakZoIVRSvikx45DUqOadr9ce87E82ZaBeUP
	 8FwsOgsezoM4cfUd663Vt7n7yPIqWZWmyCnN8Iig8ZbCEwSqZPCWlSo1I41ba8THCplzs
	 dnualTm0ard+joSlduoeAZyI0Sv70WuRTUoCyRxweVaDZw7Rh8mjnajUgdEi8XizNiVoG
	 fDWVMARJyLbwI9pUHehM99iHw+YeAU7PckWuNV/pVgV9cW1ZV+QXFOKvV8is5e/t9rFXn
	 mGqLyevwSI6oTTy8o3zAOjaK+XZmQzAgLXp7YMBGW2LHHWCTbCHiMlKsWTob3fUklBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmC4Pe0RL20oQCKA5rHWF8I2+fMdRpz81Jp330x5RVg=;
	b=s8UW153Ji4Q4zUNC/WJHRYTInsmt3a8tLlchYJ170W/YOpGO1iwW3gNqP8b+pVEZpbgd
	 2vxuCqRy3r9aOWZ9KAF9uD73Q3vjtqiQu9A9KRIti7eOMEyNdrPoGAeehFS5Ex3b8GDTE
	 9S8Aj0BhP4ekmmf1X+DDDRQZCLhTIsSpkG7Ml7+rcab+Zz8G0akwwK6ureVmi+ip8wZiH
	 RkQLUGmgecj6WMsATm2NFQu/dXbyzutU3yAKTJJQL+hBL8TX8TlwSe87nkRsweOmcuN9Y
	 MipEAO195AciRKVA/LkN1UXrpidYWzs5YrFFyD4oF8jFvKKjHqII2Xg2WsMfAroE/1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y9IVRK9/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567B9606A320;
	Wed, 18 Nov 2026 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9IVRK9/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903361F000C4;
	Wed, 18 Nov 2026 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038557;
	bh=kmC4Pe0RL20oQCKA5rHWF8I2+fMdRpz81Jp330x5RVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9IVRK9/9g7tF0OGbqk1Of7/07lQDmWEZ+0KkAaebxvBwjAekW17TP0fUTWwCQV9w
	 R/46dmhCa1uRy/EH8ZBF6vXBMEgmLT6zo68StcU4oZN1sxlEobb29tnkG6OeD3wypv
	 MlSfYrSycJa3RG/NIBpdOZO8MzUiOgDcdmpNtBUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1743/3318] block: introduce bio_in_atomic()
Date: Wed, 18 Nov 2026 15:39:25 +0100
Message-ID: <20261118150414.151369418@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 8ed0831b5263e1aa48d99063795a1f20e4e69b50 ]

Move the atomic context detection logic from erofs's z_erofs_in_atomic()
into the block layer as bio_in_atomic(). This helper returns true when
the current context is unsafe for sleeping bio completion handlers (e.g.,
hard/soft IRQ, preempt-disabled).

The logic was originally added to erofs in commit c99fab6e80b7 ("erofs:
fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC"). A
subsequent patch will use it in the block layer's bio completion
infrastructure, so move it to include/linux/bio.h where both subsystems
can share it.

Convert erofs to call the new bio_in_atomic() directly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260730-blk-dontcache-v7-1-3e8e6850068d@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: a605d5d71a6d ("f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c    | 11 +----------
 include/linux/bio.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index ede86dd93b5dd..1a8c4a068db8e 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1404,15 +1404,6 @@ static void z_erofs_decompressqueue_kthread_work(struct kthread_work *work)
 }
 #endif
 
-/* Use (kthread_)work in atomic contexts to minimize scheduling overhead */
-static inline bool z_erofs_in_atomic(void)
-{
-	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
-		return true;
-	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
-		return true;
-	return !preemptible();
-}
 
 static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 				       int bios)
@@ -1429,7 +1420,7 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 
 	if (atomic_add_return(bios, &io->pending_bios))
 		return;
-	if (z_erofs_in_atomic()) {
+	if (bio_in_atomic()) {
 		/* See `sync_decompress` in sysfs-fs-erofs for more details */
 		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
 			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f193aef4fac08..089008d1d21ef 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -438,6 +438,21 @@ static inline struct bio *bio_alloc(struct block_device *bdev,
 
 void submit_bio(struct bio *bio);
 
+/**
+ * bio_in_atomic - check if the current context is unsafe for bio completion
+ *
+ * Return: %true in atomic contexts (e.g. hard/soft IRQ, preempt-disabled);
+ * %false when a bio can be safely completed in the current context.
+ */
+static inline bool bio_in_atomic(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
+		return true;
+	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
+		return true;
+	return !preemptible();
+}
+
 extern void bio_endio(struct bio *);
 
 static inline void bio_io_error(struct bio *bio)
-- 
2.53.0



