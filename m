Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61611F3FD0
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743780978; cv=pass; b=rYX5p9TQh0nRrWXuHPfzwFFs0a6Wa4Iz4mzEo3dsqWR7hvDde6coZPyjLjSLu5Aju/8hLCMI87Slcp2f3H7x0yePwOPHMypPiyg3mQoLwCtBdd8gVO7MQbk679sou8HkyA/hOb8CCeURT1Lf5hdbFJBopRrlne0LygFkLXIt5Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743780978; c=relaxed/simple;
	bh=9giDaTWvBzEgQGi2XXCp/Flw3h2Y4NKuVILlv6DZ584=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=msg/2D/vn2f5M85S9wHIar1eeX8eBl7EMlr4bThB/KR3SFyw/e+wkqdrBQ7lMlxRT6T72lwwb13HBZ2ilJ9wL+s7N5DfPjeygcwQWqa1Q+1LSYLIlLCjIt7DrnJVPtUALaKpy3Dna/Cf4BJLs75SZ7E2qIO2hgkrNIXBY9yylIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=BcFstSpJ; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="BcFstSpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B0EC4CEDD
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="BcFstSpJ"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Fri, 4 Apr 2025 08:36:16 -0700
Resent-Message-ID: <Z-_8cOuYLzDEnjWt@bombadil.infradead.org>
Resent-To: patches@lists.linux.dev
Envelope-to: mcgrof@infradead.org
Delivery-date: Fri, 04 Apr 2025 08:26:18 +0000
Received: from nyc.source.kernel.org ([2604:1380:45d1:ec00::3])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0cNU-0000000B8Ho-3EVU
	for mcgrof@infradead.org;
	Fri, 04 Apr 2025 08:26:18 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8EEACA46DFC;
	Fri,  4 Apr 2025 08:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 22B5BC4CEE5; Fri,  4 Apr 2025 08:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E95DC4CEDD
	for <mcgrof@kernel.org>; Fri,  4 Apr 2025 08:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 8E95DC4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 4B369845A4A;
	Fri,  4 Apr 2025 08:26:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (trex-9.trex.outbound.svc.cluster.local [100.97.47.23])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id EFF6D845747;
	Fri,  4 Apr 2025 08:26:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1743755166; a=rsa-sha256;
	cv=none;
	b=laEbdp2Tahp9XQ/eZnYGfqFvf8SCSiavCQ2sRx6iKKdq1k06UnExiMPvb1rgvqE2EqvD3F
	g6qpyU4prs1Sdw2aX2lNpqM607X5CuLcRfKmT92UyoyxrGTXwIG1JOlB6Yvll4r558vmii
	Sqyp4Sns6CRqJvtx6Z0/HUKNjhTscRv4QFWAHEK3sy/oY9XR+lcXScmeWiIYQZ0z2ny2Ns
	sNjkV4Am3xF0oHJJ4ZDCK3zA8rStudCkjhT1oWkxtDuQ+4DzTo7F+8VWPHTbFEh73nQFt/
	ds9USkcGTHcrLL9KkQM/excVy7EibWeYUgival0weOkhNVQMgOMSIagnW/d3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1743755166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UTyCWGbnpgW28L6tomHc6g7AVK3tDriJSdTu/jV2ic=;
	b=gkU4IwCoi66BODnB7dAR+EeAxwT7gFlgBaNxNQxAf6dv6QhnUvPMFwmiQaWrrQb+PzG3tZ
	2OGfzC7cgKJXQS4JysLBZlOFJASXj6/vliEdN7fHbHkm7xiY58g+LNJUiPZf2PtQofM2rv
	9yHkiUFwCH3ImLlYVKwMSIacQKN7flTbmHP/8ZUvouwjZ8RWxuorSHjNA8bIdHr95lHSCr
	/kDH/22TezdgCN2szLRr4MWoSKII5HwOdPkbgnqAO4ZCO5iMySDk+StKbKm0hAbslW2eEk
	yT7OE02aXmvI3NfdwRv2U5k9zcpUSDuHjzFPyoryMD8HGZA/4V/zX6ZPCZ0dSA==
ARC-Authentication-Results: i=1;
	rspamd-77c6b75dd6-xjgvb;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Tasty-Broad: 6a2c45e41eff921d_1743755166195_4235401025
X-MC-Loop-Signature: 1743755166195:527255684
X-MC-Ingress-Time: 1743755166194
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.47.23 (trex/7.0.3);
	Fri, 04 Apr 2025 08:26:06 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4ZTWs94fTRzLr;
	Fri,  4 Apr 2025 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1743755165;
	bh=+UTyCWGbnpgW28L6tomHc6g7AVK3tDriJSdTu/jV2ic=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=BcFstSpJStobNGv9oQuFowCE+mRiCC+TeIRGr32zOCfSiNvR+gtQvGiZVl9Ykl23z
	 kliirsn/Im2pUOer4wolcD0+svU1SHjfoBAVKPV9pfcmZU2mZWiHLNkLodbtdNeetB
	 QUOmQIgDcEHjFDB9hzF1AtMWaR5b1LPIqPtSGYubND5rcgJyiom6RZS8IJYATO+1fH
	 tjL2la5pRZDoU7UqRKNDSrU4xmlARZJ2JpTAt03CErFD3trTtNA7QhEwk7OBfQhF99
	 yDRLHaEQwoHsyvmh9oC5PtHNUb++UQcCHdRKfYDzObqflvSbgRNJ5ikJ+4QhT4Qy8S
	 YSxKVyDtlEQQg==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 2/3] mm/migrate: fix blocking in atomic for large folios and bh
Date: Fri,  4 Apr 2025 01:25:19 -0700
Message-Id: <20250404082520.723838-3-dave@stgolabs.net>
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
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20250404_012616_985990_A5AFC8FA 
X-CRM114-Status: GOOD (  13.89  )
X-Spam-Score: -2.0 (--)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  The large folio + buffer head noref migration scenarios have
    been caught being naughty and blocking while holding a spinlock. Fix this
    by replacing the scope of the current i_private_lock in the buffer migration
    with the folio lock, and reducing the spinlock's critical region to only
   checking the count. Further a new BH_Migr [...] 
 
 Content analysis details:   (-2.0 points, 5.0 required)
 
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 SPF_PASS               SPF: sender matches SPF record
  0.0 SPF_HELO_NONE          SPF: HELO does not publish an SPF Record
 -0.1 DKIM_VALID             Message has at least one valid DKIM or DK signature
 -0.1 DKIM_VALID_AU          Message has a valid DKIM or DK signature from author's
                             domain
  0.1 DKIM_SIGNED            Message has a DKIM or DK signature, not necessarily valid
  0.0 ARC_SIGNED             Message has a ARC signature
  0.0 ARC_VALID              Message has a valid ARC signature
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level mail
                             domains are different

The large folio + buffer head noref migration scenarios have
been caught being naughty and blocking while holding a spinlock.

Fix this by replacing the scope of the current i_private_lock
in the buffer migration with the folio lock, and reducing the
spinlock's critical region to only checking the count. Further
a new BH_Migrate flag is added to serialize entirely across
__buffer_migrate_folio().

Currently there are no blocking users of pagecache lookups.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/buffer.c                 | 6 ++++++
 include/linux/buffer_head.h | 1 +
 mm/migrate.c                | 8 ++++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 66ff84bb3956..0e81cf315d81 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -211,6 +211,12 @@ __find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
 	head = folio_buffers(folio);
 	if (!head)
 		goto out_unlock;
+	/*
+	 * Upon a noref migration, the folio lock serialize here;
+	 * otherwise bail.
+	 */
+	if (!folio_locked && test_bit(BH_Migrate, &head->b_state))
+		goto out_unlock;
 	bh = head;
 	do {
 		if (!buffer_mapped(bh))
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f0a4ad7839b6..e87eb1b5eaa2 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -34,6 +34,7 @@ enum bh_state_bits {
 	BH_Meta,	/* Buffer contains metadata */
 	BH_Prio,	/* Buffer should be submitted with REQ_PRIO */
 	BH_Defer_Completion, /* Defer AIO completion to workqueue */
+	BH_Migrate,     /* Buffer is being migrated */
 
 	BH_PrivateStart,/* not a state bit, but the first bit available
 			 * for private allocation by other entities
diff --git a/mm/migrate.c b/mm/migrate.c
index f3ee6d8d5e2e..6a250462b800 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -844,10 +844,13 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 	if (!buffer_migrate_lock_buffers(head, mode))
 		return -EAGAIN;
 
+	set_bit(BH_Migrate, &head->b_state);
+
 	if (check_refs) {
 		bool busy;
 		bool invalidated = false;
 
+		folio_lock(src);
 recheck_buffers:
 		busy = false;
 		spin_lock(&mapping->i_private_lock);
@@ -859,12 +862,12 @@ static int __buffer_migrate_folio(struct address_space *mapping,
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
@@ -882,8 +885,9 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 	} while (bh != head);
 
 unlock_buffers:
+	clear_bit(BH_Migrate, &head->b_state);
 	if (check_refs)
-		spin_unlock(&mapping->i_private_lock);
+		folio_unlock(src);
 	bh = head;
 	do {
 		unlock_buffer(bh);
-- 
2.39.5

