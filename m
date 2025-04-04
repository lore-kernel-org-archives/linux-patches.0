Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0E1F3BA8
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743780974; cv=pass; b=izK9AClQKPp88+/aAs0x2RkTHsK09ruF/3RjcwaYOPEji5uSM9aGRB39zFKLhnIvgPCYtdEsBAI4FjNCsXalcxnEbA4ugVNKMaMAoVDqiH1pXXniSuWI069hZ+DDahKNqLy1TioUVbu4ehAIozJqQrQO0AqCzc0wVS0YkIhAM20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743780974; c=relaxed/simple;
	bh=qgrEEhq7y9Pr9eMCWZbKtuayL18sDE3ooipw5zhzi60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HhpNObBoZ/d8+HNH+3/5pnaTS/52ml4dq+Sp1Hckr014Aeg8O88VBK3xIu1CE6x6PUQ9q6boutWW7qhO6wA2q5aW6n9OaUmgnp2hMw8QKT4mEtMZuz4HuuG+xGriTJJVOXevatZ3bre5MSQuBs/eGSnBNMU3ftnvOnczGH6Vv3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=m9reA7jd; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="m9reA7jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A132C4CEDD
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="m9reA7jd"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Fri, 4 Apr 2025 08:36:12 -0700
Resent-Message-ID: <Z-_8bKDtE5gEOcKG@bombadil.infradead.org>
Resent-To: patches@lists.linux.dev
Envelope-to: mcgrof@infradead.org
Delivery-date: Fri, 04 Apr 2025 08:32:30 +0000
Received: from nyc.source.kernel.org ([2604:1380:45d1:ec00::3])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u0cTV-0000000B9vI-05VH
	for mcgrof@infradead.org;
	Fri, 04 Apr 2025 08:32:30 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 661BAA46E10;
	Fri,  4 Apr 2025 08:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id ED74AC4CEE5; Fri,  4 Apr 2025 08:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61B37C4CEDD
	for <mcgrof@kernel.org>; Fri,  4 Apr 2025 08:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 61B37C4CEDD
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 271211A5621;
	Fri,  4 Apr 2025 08:26:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a238.dreamhost.com (100-102-53-226.trex-nlb.outbound.svc.cluster.local [100.102.53.226])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B4A8E1A3BFD;
	Fri,  4 Apr 2025 08:26:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1743755165; a=rsa-sha256;
	cv=none;
	b=D0Iyj384eooprXig62uj9jz+vtgSnbXkx0ISr2dPB5E3XtK1jwdu/vS6CEIYC/K15CSude
	x8u9RdjqT5+yqRZmV80Ip3cT47pHLLpNUSjt9hxHF8Gawjt3vq8l6aRaA19a3qyqO79g5I
	Rz/4z+NoMhgFNWrI7H+0VwnRJZn/N497Ni4Vept3JLxw1sjA46Qw1/ZwAott8ExSt9sXSm
	0zxM1QTolgsgS36KoFfqqCr9C5EShB8TVixXfOFdfSZVJNL1Z8aNX9Yr+cnUJ91avQTOzX
	k4pLa7v4d2v6sRL2JFdvq3lol54boycPB8wiY2+UyBTmVBYcKheR+wGzuA/RPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1743755165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQgz7GYylvWa5aKbV6i4pp4eumyvGNfLH1U9v7AnMPo=;
	b=qK4tADwjJuW/wYraUPicSI2uqwBypgv7WTsrogOv3Gs5TBMSIDcSjP3WYwpBfCusPqSose
	XUabx7y6/tONTIaNUd/K8szZwVgthX1RVTCef481lTozkVIrnwXA99SSPrSNj9baju+t3x
	DDY9MH1hvY/ulhyR9jGPGDyg3ATe1Qn+N0ohNhK5lzisqrp2iW+C4eKwPWzU4Ix+qnGd3i
	Obzx3xBnsnBQmuzswTVkGPB//60UMtYIYStHMRQFfa1pFxOxRa+snCfFKFe9c2EEa7HFpc
	5A46a8ApvOKIsZS60E4Ir1rwDcWDpX1vcTrck3an7P6/UBVLFiFrtpetB7ZcIA==
ARC-Authentication-Results: i=1;
	rspamd-77c6b75dd6-slqzw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Hook-Battle: 2f16cde7733e2b2d_1743755165997_3727304523
X-MC-Loop-Signature: 1743755165997:4210079636
X-MC-Ingress-Time: 1743755165997
Received: from pdx1-sub0-mail-a238.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.102.53.226 (trex/7.0.3);
	Fri, 04 Apr 2025 08:26:05 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a238.dreamhost.com (Postfix) with ESMTPSA id 4ZTWs92Wf0zJX;
	Fri,  4 Apr 2025 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1743755165;
	bh=HQgz7GYylvWa5aKbV6i4pp4eumyvGNfLH1U9v7AnMPo=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=m9reA7jd4A3Ef5aZLMQt9X17Rk57I48ERvsRh186TVxhFDf2EN9kROXkOF34c1Sel
	 l1aMyMHX8whAT5WeyF6/RmVrCzPh/92FyHBdyw/JoLuB6x4OToE6eeLcJIK45lV1ke
	 icJdEliwIS/KVPkGpcnPMEZr9DQiNh+dxV7ODA3YUIPSvJdU7wHnTF2LGoQ6EVRDBO
	 bucMkK0c+g1v0PuSml9MiZzu2XW1pLeeAq3+uDU+DYTeMQCi3HsTQmS88c6Jx+TpPr
	 q8QcxSs0+rAsbZcnagfJLEKK2gM4xXJYjfRI4H92Ogf++F/kqTrp5X/Y5Y6axd3Ry2
	 IzVfD6BW3YIxg==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 1/3] fs/buffer: rely on the folio lock for lookups when possible
Date: Fri,  4 Apr 2025 01:25:18 -0700
Message-Id: <20250404082520.723838-2-dave@stgolabs.net>
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
X-CRM114-CacheID: sfid-20250404_013229_229537_694C3DE8 
X-CRM114-Status: GOOD (  17.51  )
X-Spam-Score: -2.0 (--)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 
 Content preview:  Callers of __find_get_block() may or may not allow for blocking
    semantics, and is currently assumed that it will not. Layout two paths for
    which ultimately the i_private_lock scheme will be used as a [...] 
 
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

Callers of __find_get_block() may or may not allow for blocking
semantics, and is currently assumed that it will not. Layout
two paths for which ultimately the i_private_lock scheme will
be used as a fallback. The suggested trylock idea is implemented.

No change in semantics.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/buffer.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c7abb4a029dc..66ff84bb3956 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -176,18 +176,8 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 }
 EXPORT_SYMBOL(end_buffer_write_sync);
 
-/*
- * Various filesystems appear to want __find_get_block to be non-blocking.
- * But it's the page lock which protects the buffers.  To get around this,
- * we get exclusion from try_to_free_buffers with the blockdev mapping's
- * i_private_lock.
- *
- * Hack idea: for the blockdev mapping, i_private_lock contention
- * may be quite high.  This code could TryLock the page, and if that
- * succeeds, there is no need to take i_private_lock.
- */
 static struct buffer_head *
-__find_get_block_slow(struct block_device *bdev, sector_t block)
+__find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
 {
 	struct address_space *bd_mapping = bdev->bd_mapping;
 	const int blkbits = bd_mapping->host->i_blkbits;
@@ -197,6 +187,7 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	struct buffer_head *head;
 	struct folio *folio;
 	int all_mapped = 1;
+	bool folio_locked = true;
 	static DEFINE_RATELIMIT_STATE(last_warned, HZ, 1);
 
 	index = ((loff_t)block << blkbits) / PAGE_SIZE;
@@ -204,7 +195,19 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	if (IS_ERR(folio))
 		goto out;
 
-	spin_lock(&bd_mapping->i_private_lock);
+	/*
+	 * Folio lock protects the buffers. Callers that cannot block
+	 * will fallback to serializing vs try_to_free_buffers() via
+	 * the i_private_lock.
+	 */
+	if (!folio_trylock(folio)) {
+		if (atomic) {
+			spin_lock(&bd_mapping->i_private_lock);
+			folio_locked = false;
+		} else
+			folio_lock(folio);
+	}
+
 	head = folio_buffers(folio);
 	if (!head)
 		goto out_unlock;
@@ -236,7 +239,10 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 		       1 << blkbits);
 	}
 out_unlock:
-	spin_unlock(&bd_mapping->i_private_lock);
+	if (folio_locked)
+		folio_unlock(folio);
+	else
+		spin_unlock(&bd_mapping->i_private_lock);
 	folio_put(folio);
 out:
 	return ret;
@@ -1388,14 +1394,15 @@ lookup_bh_lru(struct block_device *bdev, sector_t block, unsigned size)
  * it in the LRU and mark it as accessed.  If it is not present then return
  * NULL
  */
-struct buffer_head *
-__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
+static struct buffer_head *
+__find_get_block_common(struct block_device *bdev, sector_t block,
+			unsigned size, bool atomic)
 {
 	struct buffer_head *bh = lookup_bh_lru(bdev, block, size);
 
 	if (bh == NULL) {
 		/* __find_get_block_slow will mark the page accessed */
-		bh = __find_get_block_slow(bdev, block);
+		bh = __find_get_block_slow(bdev, block, atomic);
 		if (bh)
 			bh_lru_install(bh);
 	} else
@@ -1403,6 +1410,12 @@ __find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 
 	return bh;
 }
+
+struct buffer_head *
+__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
+{
+	return __find_get_block_common(bdev, block, size, true);
+}
 EXPORT_SYMBOL(__find_get_block);
 
 /**
-- 
2.39.5

