Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C71FE452
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040061; cv=pass; b=Z3Omu1hHBw/NyMr2EPMqmKD5sR0ifaCtKt6qbbocuNcWiUi3Bk487W/qX5rFaU/tJed309QHvJ+YMSuzFJ44ZQlOutXdH56YelXunxkilIGFdXL/+e/pep5Yc2P3hJRi183FYdtOFddYfG6ETHLiGNmbkEQhofCOGD37mBxd3kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040061; c=relaxed/simple;
	bh=RgMdCEw4XFNOn1b7+9MIZ2RxQMy6j7DMLvvcivhpSxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gVyRibIfBfM3GIZfYGwOTWQaBgxcOB5V6k3TvMdOa6NNJVO/4TgGlXh0MgJkRvYwdKAT9H30bNKVpseWaqqpHlnmy55IFq0QCnZFPZU5r0g7RFuosH9nvkzgMdM7064BMjKPDI+MVSAQOXPIWwarOFmocqZDrIC/bGAD4ee9Ohc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=R3WVSYAS; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="R3WVSYAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24791C4CEE7
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="R3WVSYAS"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:34:19 -0700
Resent-Message-ID: <Z_Pwe36-DrzSYsXQ@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 06:01:15 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1fXl-0000000GVvo-3R4p
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 06:01:15 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 138835C4D9F;
	Mon,  7 Apr 2025 05:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D9236C4CEE8; Mon,  7 Apr 2025 06:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23D82C4CEDD
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 06:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 23D82C4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 322C022819;
	Mon,  7 Apr 2025 05:55:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (100-126-123-60.trex-nlb.outbound.svc.cluster.local [100.126.123.60])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id D75E522B53;
	Mon,  7 Apr 2025 05:55:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005343; a=rsa-sha256;
	cv=none;
	b=PUabmpalA8Etu5PvYpqWmrmodOhdYm70rx/6X6OVnF1F93+va7BpRJvoCBfGIBdjC8KKN+
	o1RVu4de+HNqgibstxXi0hIUul9paneRIfdS8qZZ76UC+vGxTw2WT7qFBGv0hErRi9ES+v
	50SjVKC3wKAMQcSWFN+atJbwSGFWMJPYVx6pGX/M9feD/NO3B+OiSOHfGjSsAf1e5PHJEu
	HB/8bWSDfL95GBenZvVNmYKBZexCJFQ98m02MWpHehc8MJJZWCKn1c3iFh0lgmP0ran+s+
	MLhyA+7BRqTVr06/5nQTuzYsAsq9vrrLRO9FukVbXd2JwJdsaTCfmo/kgCBggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42nJL3ktkhMlgB9JSsJLBE5cHqIMjtCrybB5ye96je8=;
	b=u6fDMh4mlab1eE322acVQZttltvR6fHeliumZbFPFp7agUWgJXQDR83YImDA7/uSvSOl0q
	J6vTnyGNF1N+Asg2QVyrVi+Z0snlhl9dehRgQOgOFktbXWLDX6aqi5ouE3o/cMqp8c/JYV
	MgVOlZBSt8MVdDoucgUvUXF1qu1eMer1tZuFB4iIlst4YGqM5ojU9Oljspbxh+lBHbeA5R
	K1is1FIhKRnog4m270Rz6bML556yo6BJzOQt47ngH0xOXRgV92fGbJdkbZuzGkEnWflZRM
	ocTzKI4vjeac2Jg/FYk7BVJLH5u2pqucDCJOv3Wo3Q/PNuyII9EEvPhexkQB6A==
ARC-Authentication-Results: i=1;
	rspamd-6c88b8f79f-jqjl2;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Absorbed-Tart: 39438fe030fd6596_1744005344095_3095634946
X-MC-Loop-Signature: 1744005344095:1940942583
X-MC-Ingress-Time: 1744005344095
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.126.123.60 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:44 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNH3lW2zdH;
	Sun,  6 Apr 2025 22:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005343;
	bh=42nJL3ktkhMlgB9JSsJLBE5cHqIMjtCrybB5ye96je8=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=R3WVSYASGmKbuwV3KosCgQKxjINCnM0U/imSM5c+BmGz4yK+mJbbAUrDOs4hDyoP/
	 whNCaUNUV5ZxNYjXUJdSDG/006OY2rRqCggDzo6wO8XUX44SE7yNp/5B2oC/WBvE2a
	 4SrGjIwrrOGosNpSaCuC9QBiCqZRw4Fc+4cvvtZlTTXlDwmV7Rf1MF/3LqZ4QqY0Hp
	 EbQCbFles3MdwBWpRvL2SyU7t8BYU1JwIfSiO4SMqG3XL/U0SMgqIZJD7KakVk6La7
	 r5aSQ6l82AATAG8c0NTK2ey/a/jlTiGS7r1EXqRwzck7Zqr7mhRLv+iH0O9SDB+yMu
	 qwmxbktazwhug==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 4/6] fs/jbd2: use sleeping version of __find_get_block()
Date: Sun,  6 Apr 2025 22:54:53 -0700
Message-Id: <20250407055455.785065-5-dave@stgolabs.net>
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
X-CRM114-CacheID: sfid-20250406_230114_109714_D935814C 
X-CRM114-Status: GOOD (  11.96  )
X-Spam-Score: -7.1 (-------)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  Convert to the new nonatomic flavor to benefit from potential
    performance benefits and adapt in the future vs migration such that semantics
    are kept. - jbd2_journal_revoke(): can sleep (has might_sleep() in the beginning)
    
 
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
  0.0 RCVD_IN_VALIDITY_CERTIFIED_BLOCKED RBL: ADMINISTRATOR NOTICE: The
                             query to Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                         [139.178.84.217 listed in sa-trusted.bondedsender.org]
  0.0 RCVD_IN_VALIDITY_SAFE_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                             [139.178.84.217 listed in sa-accredit.habeas.com]
  0.0 RCVD_IN_VALIDITY_RPBL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
                              Validity was blocked.  See
                             https://knowledge.validity.com/hc/en-us/articles/20961730681243
                              for more information.
                            [139.178.84.217 listed in bl.score.senderscore.com]

Convert to the new nonatomic flavor to benefit from potential
performance benefits and adapt in the future vs migration such
that semantics are kept.

- jbd2_journal_revoke(): can sleep (has might_sleep() in the beginning)

- jbd2_journal_cancel_revoke(): only used from do_get_write_access() and
    do_get_create_access() which do sleep. So can sleep.

- jbd2_clear_buffer_revoked_flags() - only called from journal commit code
    which sleeps. So can sleep.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/jbd2/revoke.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 0cf0fddbee81..1467f6790747 100644
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
@@ -355,7 +356,8 @@ int jbd2_journal_revoke(handle_t *handle, unsigned long long blocknr,
 
 		/* If there is a different buffer_head lying around in
 		 * memory anywhere... */
-		bh2 = __find_get_block(bdev, blocknr, journal->j_blocksize);
+		bh2 = __find_get_block_nonatomic(bdev, blocknr,
+						 journal->j_blocksize);
 		if (bh2) {
 			/* ... and it has RevokeValid status... */
 			if (bh2 != bh && buffer_revokevalid(bh2))
@@ -464,7 +466,8 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * state machine will get very upset later on. */
 	if (need_cancel) {
 		struct buffer_head *bh2;
-		bh2 = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
+		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
+						 bh->b_size);
 		if (bh2) {
 			if (bh2 != bh)
 				clear_buffer_revoked(bh2);
@@ -492,9 +495,9 @@ void jbd2_clear_buffer_revoked_flags(journal_t *journal)
 			struct jbd2_revoke_record_s *record;
 			struct buffer_head *bh;
 			record = (struct jbd2_revoke_record_s *)list_entry;
-			bh = __find_get_block(journal->j_fs_dev,
-					      record->blocknr,
-					      journal->j_blocksize);
+			bh = __find_get_block_nonatomic(journal->j_fs_dev,
+							record->blocknr,
+							journal->j_blocksize);
 			if (bh) {
 				clear_buffer_revoked(bh);
 				__brelse(bh);
-- 
2.39.5

