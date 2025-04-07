Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A9C1FF619
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040052; cv=pass; b=K/rdtioTvRBrIfogPM+Lj3AUW+8Ox1PXXS5e6/4UtrUhSv5o6FGmyHPLDeNhGecClFLthFNkrHg9EgDVQ1vcNGM0ZwFBM02wM+rTS3RRxfO9BeGVPBptZdFNfJw8nf8dldud2BsrBiqey1rBnI2tbSoQSdCTf1dp9aiwsvmfqJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040052; c=relaxed/simple;
	bh=WpxQoezV+OhIjDieCkaMFnYSVD9lcBRI8gX5PwG3iXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ws6YtqFsFDYSzR4sWo6vtxsoxN6vxZ7IgwkQo4+KAMNBoafeT2omR3dgGY6p+Cl8J/N5wU/waJxrNHcOH16EQdsnAqnLpa0gaM4M/Ubl7DZtTMLcdkz18aKWIP2G5bWClt2lA42QwSUi66m0cHTeyUkIraMujNr0ZwJ8XoSYJjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=X18FerWU; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="X18FerWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6426AC4CEDD
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="X18FerWU"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:34:11 -0700
Resent-Message-ID: <Z_Pwc5_70oq-yLlh@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 05:56:00 +0000
Received: from sea.source.kernel.org ([172.234.252.31])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1fSh-0000000GVPV-1PrZ
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 05:56:00 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 258C1439FA;
	Mon,  7 Apr 2025 05:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id B622DC4CEE8; Mon,  7 Apr 2025 05:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 183B6C4CEDD
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 05:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 183B6C4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8CAFC2C2AEA;
	Mon,  7 Apr 2025 05:55:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (100-99-49-173.trex-nlb.outbound.svc.cluster.local [100.99.49.173])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3CE4E2C21A4;
	Mon,  7 Apr 2025 05:55:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005343; a=rsa-sha256;
	cv=none;
	b=MvcYJHV5jEuL/zREaKMyKH6qBNELrFBRwf5ccu2HGcJQCSLIj5a+bBST2xq/0dGvzsJ5Wh
	82UZnsupVIIODpSVR35j0TojTZ/ZcmIoaZiuhdDGU9edhLN5ndYLVCYKphIWj4O7th2nAn
	IY3D2GOO0AXhVaAWAwe7oV/bEKLiJKPw+icZvCZ82xn90bMhMwHFJzd0LQNAbW3DdokbG4
	sWsYU6gtJjwPhvmOxDZT+iWI19eW9sxGCSioa7Cr0GgJ0lHUgoep3GVSjL6rr/sqeVZNmb
	bg3mg5nDfzDEQIVtZ14tllfGPYYSAP0s902Obo8NL8Npfa2H8Dao10uEAivSpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9xQDHJxXkj14NnpZbmtmCR4vYw51Gh5fG8mcjTZu24=;
	b=nKTa1x0dRRmdFzU1logKKrdgR6f3I8IEp6vZ9kOxLzs5Tqdg6ijexnX8Sd73if5X4zmjSv
	NRxrohXolHO8K5whpM41pw+hKAl2SNKkNU4X1WFf/auT4diKFzMiClRQxqkbPcAlMeWdtl
	4LWLfIPondW9obu6y3SKK9LzroJ2d0sE+M9Rcy+6YOT4UuVuvOr2a9NlRUd9bqpMydP3Yw
	kAf/jWoe+KD7/IXwQT1PpZ1YfMe+L9dIiSzzthdN3pN1ApOne7o1ZNFJe2NDCFdPsQurj2
	4C3+/uBVfZKxxMyZJGq1YLibji+YA8Nge38JGhmuAO+Hy8tQXK7HtlEo1FTppQ==
ARC-Authentication-Results: i=1;
	rspamd-6c88b8f79f-kmgbt;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Callous-Wide-Eyed: 71ea07981da75c60_1744005343465_3941019495
X-MC-Loop-Signature: 1744005343465:668959441
X-MC-Ingress-Time: 1744005343464
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.99.49.173 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:43 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNG5sXNzMN;
	Sun,  6 Apr 2025 22:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005343;
	bh=Q9xQDHJxXkj14NnpZbmtmCR4vYw51Gh5fG8mcjTZu24=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=X18FerWU8T+Jt9i56y31SJKnfK6v6c/jhmrZqVdSOQsbxeqt1Nrsw9Tzy+FKjuI9N
	 nO6Lt1TtDFsmnaKRkNz6r5PFzJZOkaTG8aXaKztuwuAP6myI6/BjPmU0RK3TjAi4SP
	 9i9dd3i4n8SWmSQ0sBI8noZJnfDBhNrunyYize6gFL/p6t4HfCQCMYnxYEaJIQ4npq
	 dMwWiL0fBqe3IWTSvWctTxX375Ws2I7K/U+evJ6+lJPhFqOf8w3IMrKV3JsGxfWJbI
	 SPYW7J1S8SYByQPSSodUeB8Wrw4+HOpgXZFHBHVUtwpD1lciuAgrdQpKxaHGEH94Eq
	 hlgwR1WoS8ZgA==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 2/6] fs/buffer: introduce __find_get_block_nonatomic()
Date: Sun,  6 Apr 2025 22:54:51 -0700
Message-Id: <20250407055455.785065-3-dave@stgolabs.net>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250407055455.785065-1-dave@stgolabs.net>
References: <20250407055455.785065-1-dave@stgolabs.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20250406_225559_418257_4107D593 
X-CRM114-Status: GOOD (  12.07  )
X-Spam-Score: -2.1 (--)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  Callers that do not require atomic context for pagecache lookups
    can use this flavor to avoid the unnencesary contention on the blockdev mapping
    i_private_lock as well as waiting on noref migration. Convert local caller
    write_boundary_block() which already takes the buffer lock as well as bdev_getblk()
    depending on the respective gpf flags. Either way there are no currently
   changes in semantics. 
 
 Content analysis details:   (-2.1 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.0 SPF_HELO_NONE          SPF: HELO does not publish an SPF Record
 -0.0 SPF_PASS               SPF: sender matches SPF record
  0.0 ARC_SIGNED             Message has a ARC signature
  0.1 DKIM_SIGNED            Message has a DKIM or DK signature, not necessarily valid
 -0.1 DKIM_VALID_AU          Message has a valid DKIM or DK signature from author's
                             domain
 -0.1 DKIM_VALID             Message has at least one valid DKIM or DK signature
 -0.1 ARC_VALID              Message has a valid ARC signature
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level mail
                             domains are different
  0.0 RCVD_IN_VALIDITY_SAFE_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                             [172.234.252.31 listed in sa-accredit.habeas.com]
  0.0 RCVD_IN_VALIDITY_CERTIFIED_BLOCKED RBL: ADMINISTRATOR NOTICE: The
                             query to Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                         [172.234.252.31 listed in sa-trusted.bondedsender.org]
  0.0 RCVD_IN_VALIDITY_RPBL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                            [172.234.252.31 listed in bl.score.senderscore.com]

Callers that do not require atomic context for pagecache
lookups can use this flavor to avoid the unnencesary
contention on the blockdev mapping i_private_lock as well
as waiting on noref migration.

Convert local caller write_boundary_block() which already
takes the buffer lock as well as bdev_getblk() depending
on the respective gpf flags. Either way there are no
currently changes in semantics.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/buffer.c                 | 19 +++++++++++++++++--
 include/linux/buffer_head.h |  2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 5a1a37a6840a..07ec57ec100e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -662,7 +662,8 @@ EXPORT_SYMBOL(generic_buffers_fsync);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize)
 {
-	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
+	struct buffer_head *bh = __find_get_block_nonatomic(bdev, bblock + 1,
+							    blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
 			write_dirty_buffer(bh, 0);
@@ -1418,6 +1419,15 @@ __find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 }
 EXPORT_SYMBOL(__find_get_block);
 
+/* same as __find_get_block() but allows sleeping contexts */
+struct buffer_head *
+__find_get_block_nonatomic(struct block_device *bdev, sector_t block,
+			   unsigned size)
+{
+	return find_get_block_common(bdev, block, size, false);
+}
+EXPORT_SYMBOL(__find_get_block_nonatomic);
+
 /**
  * bdev_getblk - Get a buffer_head in a block device's buffer cache.
  * @bdev: The block device.
@@ -1435,7 +1445,12 @@ EXPORT_SYMBOL(__find_get_block);
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
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f0a4ad7839b6..2b5458517def 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -222,6 +222,8 @@ void __wait_on_buffer(struct buffer_head *);
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
 			unsigned size);
+struct buffer_head *__find_get_block_nonatomic(struct block_device *bdev,
+		       sector_t block, unsigned size);
 struct buffer_head *bdev_getblk(struct block_device *bdev, sector_t block,
 		unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
-- 
2.39.5

