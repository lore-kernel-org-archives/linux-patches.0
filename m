Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E472145B0B
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743780983; cv=pass; b=d/AZRS/B/0sqALll1mkV9i+fheu84bnRcrHtFnGkNXudbzJxxj3tlQGfyVB2dRwLeuFeEgt5ekFMGJUg6Ox0qSdlMFlMew9mfSvoBFmNoQH1ka7QXwkxGR8NPJ6Per3jbNY0LpXYjxizK6TY3lmby3pskBuPQYfD5U/QDHk0xHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743780983; c=relaxed/simple;
	bh=NqvfcBagJhe5ko5fbpfCx11iCagq9LD6OAB0tol0xIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rSTRY4XPoC07P+Ri89dpqGxuYEDy7tq5dlKt1kkL+dIqGiJlYoshzq17yYo/lnbwA6zZtHpSi3ZTxkLh897u6cC8JAveLNiKQX3gU+U0M11H/OA9zn2GKM9KhZx7k6rcz1crIfFVg3ogvy3HrlmemXg8NMmmlbOBSmYmlIa4wFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=HHlkcMOu; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="HHlkcMOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDD9C4CEDD
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="HHlkcMOu"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Fri, 4 Apr 2025 08:36:21 -0700
Resent-Message-ID: <Z-_8dYLtWoXsBBTR@bombadil.infradead.org>
Resent-To: patches@lists.linux.dev
Envelope-to: mcgrof@infradead.org
Delivery-date: Fri, 04 Apr 2025 08:33:28 +0000
Received: from tor.source.kernel.org ([2600:3c04:e001:324:0:1991:8:25])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0cUS-0000000BA4a-1z4O
	for mcgrof@infradead.org;
	Fri, 04 Apr 2025 08:33:28 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ED7260010;
	Fri,  4 Apr 2025 08:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 9FC3BC4CEDD; Fri,  4 Apr 2025 08:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC6C1C4CEEA
	for <mcgrof@kernel.org>; Fri,  4 Apr 2025 08:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org DC6C1C4CEEA
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id BCF8C43C86;
	Fri,  4 Apr 2025 08:26:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (100-102-53-226.trex-nlb.outbound.svc.cluster.local [100.102.53.226])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 508CA43E94;
	Fri,  4 Apr 2025 08:26:06 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1743755166; a=rsa-sha256;
	cv=none;
	b=nOFamv/ArwMUqglE5vHlglC8jh7NQMhb1b+rkmJ62Fj4xrxCrYFyvdgB217Eb0V1FCs4XE
	L+o/L94BLZhzqDbANZWB5rJKuDlQR6c7O7VQEQw3zxXlzr6WnJZ9Vfffz2z2Gr8965CIHi
	L9v2I0ml4HcxD7LQc5+xJdE6zGCI+lT8lfXVI2tXhprSRUeoPK9JN4Uhha6EX0lnUOjiwB
	gW5iSbL9vbEYDo4A3xi/JFEbBJiwwmc9gfMk70UnX9kvKhLAX4C3kWRopAC6O9MHQHxCHH
	V6sskW2mFNUeQAxlXWe72tC1cqI2jDK/V82gYNQoJhO63VLyuTMJJ2DwDnyZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1743755166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBWr+DfrKzdGsjV9LW+lVAL88V7NJzsjp/HuPYvZ1oU=;
	b=tOZAFsbHA8AaM+f9TK/4HRQES7Zo/0r02jjUBEsLL6/ipFm3GwF4MO8mIJsUBoZ8wuOQn2
	9mzUbslhOLr8V2M+4ojW+ikWMsnmHkef9b/8dLQs63u3gexMEkLQd92rz45M36HZ4lx6nq
	FwlyEY6m1s0AR1aG5OHu9Jj+9S0z22fa6Y+wk6Nju+UcThNmF88OKn/vtPUDLz60sAw39z
	vzVySfY5W1k5sI0ZJMWGE4dueUMhivWcq1EX5dxgxaNRj0uE9YV1NvNjx+9uDFLv/fFBhu
	mwp9k4mjL8JO7XSoVN80/CXJedlIYWy3ysDuFAL3Z9LGFc6H1z/B6sMyfCYIyQ==
ARC-Authentication-Results: i=1;
	rspamd-77c6b75dd6-jdfhc;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Inform-Attack: 56f5aa857ef27e77_1743755166562_4062817515
X-MC-Loop-Signature: 1743755166562:4167042683
X-MC-Ingress-Time: 1743755166562
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.102.53.226 (trex/7.0.3);
	Fri, 04 Apr 2025 08:26:06 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4ZTWs96qgTz9B;
	Fri,  4 Apr 2025 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1743755166;
	bh=cBWr+DfrKzdGsjV9LW+lVAL88V7NJzsjp/HuPYvZ1oU=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=HHlkcMOuhYFMdVs2WTE7K3C/8O0ShP+5misSt6xh6XkG5ZXe6+8HaItub9RbUTLsR
	 aUXoHETGaM2KFtTO3WwWHyCfk3NP5jP5c8R7VVh6DWYK3sWER/GaNA8bAPqsamhjF0
	 YGl+7IJBpJMpsf5e647/pd7V6EJXglG7+38drjLIrPRHCdxUNGaarbw98Xvyo6eeGW
	 TA+/AUfIhimmVlJbc017hwewFunrRnDsQTIpXrJ9NOxzo1AyEdVUZp6PbQaxT0einD
	 T8qqCGh2Kkq60egixfpoPET7eZLC25hdfZXI8IiC3ItRvl4NLuEFA6U7lHJtYhJ8hM
	 sX5fUq7ub7hmA==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 3/3] fs/buffer: introduce __find_get_block_nonatomic()
Date: Fri,  4 Apr 2025 01:25:20 -0700
Message-Id: <20250404082520.723838-4-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250404082520.723838-1-dave@stgolabs.net>
References: <20250404082520.723838-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Callers that do not require atomic context for pagecache
lookups can use this flavor to avoid the unnencesary
contention on the blockdev mapping i_private_lock as well
as waiting on noref migration.

Sprinkle some conversions. This could be separated into
different patches I suppose.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/buffer.c                 | 25 +++++++++++++++++++++----
 fs/jbd2/revoke.c            |  8 +++++---
 fs/ocfs2/journal.c          |  2 +-
 include/linux/buffer_head.h |  2 ++
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 0e81cf315d81..24d1a5476084 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -668,7 +668,8 @@ EXPORT_SYMBOL(generic_buffers_fsync);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize)
 {
-	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
+	struct buffer_head *bh = __find_get_block_nonatomic(bdev, bblock + 1,
+							    blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
 			write_dirty_buffer(bh, 0);
@@ -1135,8 +1136,10 @@ __getblk_slow(struct block_device *bdev, sector_t block,
 
 	for (;;) {
 		struct buffer_head *bh;
-
-		bh = __find_get_block(bdev, block, size);
+		if (gfpflags_allow_blocking(gfp))
+			bh = __find_get_block_nonatomic(bdev, block, size);
+		else
+			bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
 
@@ -1424,6 +1427,15 @@ __find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 }
 EXPORT_SYMBOL(__find_get_block);
 
+/* same as __find_get_block() but can sleep */
+struct buffer_head *
+__find_get_block_nonatomic(struct block_device *bdev, sector_t block,
+			   unsigned size)
+{
+	return __find_get_block_common(bdev, block, size, false);
+}
+EXPORT_SYMBOL(__find_get_block_nonatomic);
+
 /**
  * bdev_getblk - Get a buffer_head in a block device's buffer cache.
  * @bdev: The block device.
@@ -1441,7 +1453,12 @@ EXPORT_SYMBOL(__find_get_block);
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp)
 {
-	struct buffer_head *bh = __find_get_block(bdev, block, size);
+	struct buffer_head *bh;
+
+	if (gfpflags_allow_blocking(gfp))
+		bh = __find_get_block_nonatomic(bdev, block, size);
+	else
+		bh = __find_get_block(bdev, block, size);
 
 	might_alloc(gfp);
 	if (bh)
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 0cf0fddbee81..11d2128612a7 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -345,7 +345,8 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 	bh = bh_in;
 
 	if (!bh) {
-		bh = __find_get_block(bdev, blocknr, journal->j_blocksize);
+		bh = __find_get_block_nonatomic(bdev, blocknr,
+						journal->j_blocksize);
 		if (bh)
 			BUFFER_TRACE(bh, "found on hash");
 	}
@@ -464,7 +465,8 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * state machine will get very upset later on. */
 	if (need_cancel) {
 		struct buffer_head *bh2;
-		bh2 = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
+		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
+						 bh->b_size);
 		if (bh2) {
 			if (bh2 != bh)
 				clear_buffer_revoked(bh2);
@@ -492,7 +494,7 @@ void jbd2_clear_buffer_revoked_flags(journal_t *journal)
 			struct jbd2_revoke_record_s *record;
 			struct buffer_head *bh;
 			record = (struct jbd2_revoke_record_s *)list_entry;
-			bh = __find_get_block(journal->j_fs_dev,
+			bh = __find_get_block_nonatomic(journal->j_fs_dev,
 					      record->blocknr,
 					      journal->j_blocksize);
 			if (bh) {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f1b4b3e611cb..c7a9729dc9d0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1249,7 +1249,7 @@ static int ocfs2_force_read_journal(struct inode *inode)
 		}
 
 		for (i = 0; i < p_blocks; i++, p_blkno++) {
-			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
+			bh = __find_get_block_nonatomic(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
 			if (!bh)
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e87eb1b5eaa2..d51912fc59b2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -223,6 +223,8 @@ void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
 			unsigned size);
+struct buffer_head *__find_get_block_nonatomic(struct block_device *bdev,
+					       sector_t block, unsigned size);
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
-- 
2.39.5

