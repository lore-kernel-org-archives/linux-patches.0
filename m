Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D348C19D8A2
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040068; cv=pass; b=SETlzSLqe3M+DKWVLF7d+ev5Du6BRSCvMTfaIt3WIUvEmR2Yk1YGK6FmCoFO8wxrONUkBbwZLcD3BCm+cahE8wtN7lrmZZwronQqZT4It3ZahTmP8CbTGHWUzP1a5u75giaLcse2G5sFnlXJr7CmUQlMutVt4WUYO3WwaQXNLiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040068; c=relaxed/simple;
	bh=yd8pA9wvv8vCEh+1oHbfz/F+HTCocTEZMG8lCZQZd1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Af5+UmehgZzMa1JYjzk2VaPEKUu1fQojHjPh4+tui435PtZtUu2Pr6m1tMp9Ii16ck1lPvhwnSOxViZ9dPLfRauBS1uFNac7o55AjlajuIjdjAX+0IJqlsdoOfrDgfmBSNbY4T4iRlRFw/pedmG8/emyD6My6yO3iC/L1PgVC40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=aPbN3gxH; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="aPbN3gxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAACC4CEDD
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="aPbN3gxH"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:34:27 -0700
Resent-Message-ID: <Z_Pwg89nk-PD5Xk8@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 05:55:55 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1fSc-0000000GVOi-0XNG
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 05:55:55 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D604A5C5864;
	Mon,  7 Apr 2025 05:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id A9854C4CEDD; Mon,  7 Apr 2025 05:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADCF9C4CEEB
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 05:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org ADCF9C4CEEB
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id D46FC8A3922;
	Mon,  7 Apr 2025 05:55:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (trex-5.trex.outbound.svc.cluster.local [100.107.20.214])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 890C78A3284;
	Mon,  7 Apr 2025 05:55:44 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005344; a=rsa-sha256;
	cv=none;
	b=hNOne33IjaP2GJwoIdduWM9BJGsle1fNTvOfVav4VoJBBkw2LVn+4bLsLID+pCTKfpEuVx
	38/SgawF13njzcVVuw9h8Xm9iDy6jR59yukXsAAcSfSiesEqhsC6QPLjutVZYL1hKzGVlW
	WP66gvTABYJlWCBncA4HRoNeQ7qmtYEyeBIzSUukV+t0sWlonRZ1iWCL/hbpPI2HhEqGFb
	xvIwuBiy2RWfefgWBwQj0fA/Els34AIMgG2wJ7V6LuVgsMkSCYFVE/qJ9YQVAY5zy/N3kU
	BcNjNpEG3b5+MbHrHm+540lqAs7mxu7XUizdUpUqmE5IQG22D5hqLb+UyGnv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+osRztGM+64dw0HgKZ/KeIzIzsFSZuNqtIvDO3KsoUw=;
	b=WRprAvtt8X4cVCHEhdJS0uFNPQyD2PiDQg+6t0u93icC1v1AdA2ivDG6sDgdNckVVTLTlk
	FrEOtlh9Uk6GqHNqQzvAX2ricf+/yOSunjJf5jGdcjB2MvC6K+i5xFhcTTmn9iF+JwJFlm
	cc9DrFb4F9WljGaUzz+YMgNyevew6Fmv+v9Im7rT3yvQcKVoFmxp0JuqHqjuVBx2ljRbZ1
	xzGpMhTCR9sRSh6/N0qNFYP9GgwUwZVnp2bWUgVqAg7GUglqyA6Atk0L2TGvmwY8tMG2W6
	tje9xjI2VAT2mEDpfO2czdGCZtJnGT5PL9lPHK1DtwYgN4jY69Ye+FbkWH14Ug==
ARC-Authentication-Results: i=1;
	rspamd-7dd6dcd7db-2wrq9;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Illustrious-Abiding: 6f59548a2fe4ffd3_1744005344775_4259637749
X-MC-Loop-Signature: 1744005344775:3875656840
X-MC-Ingress-Time: 1744005344775
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.107.20.214 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:44 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNJ1VvxzdH;
	Sun,  6 Apr 2025 22:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005344;
	bh=+osRztGM+64dw0HgKZ/KeIzIzsFSZuNqtIvDO3KsoUw=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=aPbN3gxH/vDPb3qr+bSjjTCs+ESa6ogbt1CK9JXRuLpZ+wWuYXkaWn9RJiAH1i9X5
	 uGxDNygnfWjDQr9rZMyomzpbg0ufataj2z2Z4AhU8SmesvNyjDFqwkznovaY3g7Wzg
	 1pb9RAdeI1bdRHGfPhLk+J8HdYpG6AfnTbwJoSZrcmWTh1fJ6hYzIPxGyxmxmFOijC
	 UCpCNl01FVhB5xPswwKNrDRhTOn6NKEPPoAORr7IF8UPbaXYv4P3/fdA5tOOsNeFSG
	 Ktsl+Z6Rszv8sv8Ai7XhgYK9LwVgBnNu9xc0ZPMGwFY3t1l/jiBLsV2LyUOrN60VeV
	 8D5LRkgqMKLWg==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 6/6] mm/migrate: fix sleep in atomic for large folios and bh
Date: Sun,  6 Apr 2025 22:54:55 -0700
Message-Id: <20250407055455.785065-7-dave@stgolabs.net>
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
X-CRM114-CacheID: sfid-20250406_225554_252340_E6ECAD9D 
X-CRM114-Status: GOOD (  17.18  )
X-Spam-Score: -7.1 (-------)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  The large folio + buffer head noref migration scenarios are
    being naughty and blocking while holding a spinlock. As a consequence of
   the pagecache lookup path taking the folio lock this serializes against migration
    paths, so they can wait for each other. For the i_private_lock fallback case,
    a new BH_Migrate fla [...] 
 
 Content analysis details:   (-7.1 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -5.0 RCVD_IN_DNSWL_HI       RBL: Sender listed at https://www.dnswl.org/, high
                             trust
                             [139.178.84.217 listed in list.dnswl.org]
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
                             [139.178.84.217 listed in sa-accredit.habeas.com]
  0.0 RCVD_IN_VALIDITY_CERTIFIED_BLOCKED RBL: ADMINISTRATOR NOTICE: The
                             query to Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                         [139.178.84.217 listed in sa-trusted.bondedsender.org]
  0.0 RCVD_IN_VALIDITY_RPBL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                            [139.178.84.217 listed in bl.score.senderscore.com]

The large folio + buffer head noref migration scenarios are
being naughty and blocking while holding a spinlock.

As a consequence of the pagecache lookup path taking the
folio lock this serializes against migration paths, so
they can wait for each other. For the i_private_lock
fallback case, a new BH_Migrate flag is introduced which
enables the lookup to bail.

This allows the critical region of the i_private_lock on
the migration path to be reduced to the way it was before
ebdf4de5642fb6 ("mm: migrate: fix reference  check race
between __find_get_block() and migration").

The scope is always noref migration.

Co-developed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/buffer.c                 | 12 +++++++++++-
 fs/ext4/ialloc.c            |  3 ++-
 include/linux/buffer_head.h |  1 +
 mm/migrate.c                |  6 ++++--
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 07ec57ec100e..3e1df7779bc2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -211,6 +211,15 @@ __find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
 	head = folio_buffers(folio);
 	if (!head)
 		goto out_unlock;
+	/*
+	 * Upon a noref migration, the folio lock serializes here;
+	 * otherwise bail.
+	 */
+	if (test_bit_acquire(BH_Migrate, &head->b_state)) {
+		WARN_ON_ONCE(folio_locked);
+		goto out_unlock;
+	}
+
 	bh = head;
 	do {
 		if (!buffer_mapped(bh))
@@ -1393,7 +1402,8 @@ lookup_bh_lru(struct block_device *bdev, sector_t block, unsigned size)
 /*
  * Perform a pagecache lookup for the matching buffer.  If it's there, refresh
  * it in the LRU and mark it as accessed.  If it is not present then return
- * NULL
+ * NULL. Atomic context callers may also return NULL if the buffer is being
+ * migrated; similarly the page is not marked accessed either.
  */
 static struct buffer_head *
 find_get_block_common(struct block_device *bdev, sector_t block,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 38bc8d74f4cc..e7ecc7c8a729 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -691,7 +691,8 @@ static int recently_deleted(struct super_block *sb, ext4_group_t group, int ino)
 	if (!bh || !buffer_uptodate(bh))
 		/*
 		 * If the block is not in the buffer cache, then it
-		 * must have been written out.
+		 * must have been written out, or, most unlikely, is
+		 * being migrated - false failure should be OK here.
 		 */
 		goto out;
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 8db10ca288fc..5559b906b1de 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Meta,	/* Buffer contains metadata */
 	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
 	BH_Defer_Completion, /* Defer AIO completion to workqueue */
+	BH_Migrate,     /* Buffer is being migrated (norefs) */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
diff --git a/mm/migrate.c b/mm/migrate.c
index f3ee6d8d5e2e..7a3552adda5d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -848,6 +848,8 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 		bool busy;
 		bool invalidated = false;
 
+		VM_WARN_ON_ONCE(test_and_set_bit_lock(BH_Migrate,
+						      &head->b_state));
 recheck_buffers:
 		busy = false;
 		spin_lock(&mapping->i_private_lock);
@@ -859,12 +861,12 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 			}
 			bh = bh->b_this_page;
 		} while (bh != head);
+		spin_unlock(&mapping->i_private_lock);
 		if (busy) {
 			if (invalidated) {
 				rc = -EAGAIN;
 				goto unlock_buffers;
 			}
-			spin_unlock(&mapping->i_private_lock);
 			invalidate_bh_lrus();
 			invalidated = true;
 			goto recheck_buffers;
@@ -883,7 +885,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 
 unlock_buffers:
 	if (check_refs)
-		spin_unlock(&mapping->i_private_lock);
+		clear_bit_unlock(BH_Migrate, &head->b_state);
 	bh = head;
 	do {
 		unlock_buffer(bh);
-- 
2.39.5

