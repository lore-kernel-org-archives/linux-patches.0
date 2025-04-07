Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FFD1FF602
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744040047; cv=pass; b=gru+P6B3jOTaUJy6WQNQbApAocKvNz+qLzIOzc4b5RKvnV3IUP9DtyapJQYabo7qbCr0auUnCIEisNC45gtTsgYaI+yQ4u64rEm7zHL8Kg+VGxjc50Lsi+/IVHOVIyDi6zciCrxntkQiSmoDmctjvtmp/hRaaNWPsyiDJASD/R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744040047; c=relaxed/simple;
	bh=wqgiz7AL2oDtFk752IJq+3AMhmmyoq4gofjsYlgI3qI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jFHkvcFdGKt+w5zXO5Klo9a7NPZm818eOu8Lgluf5mp60cf8YsUuDqw50iewZQm27rEGvR6+0uVoL7jbkiOcYPT0yi8oBjbx12AOcp7mkmPEBR3VtrtqT8uUqDr1mxUeYYoGA0XCxlhCW+qwD9AURf85+KPPWEApY3qS6ZysjDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=lLcoJNNj; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="lLcoJNNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F1DC4CEDD
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="lLcoJNNj"
Resent-From: Luis Chamberlain <mcgrof@kernel.org>
Resent-Date: Mon, 7 Apr 2025 08:34:05 -0700
Resent-Message-ID: <Z_PwbUxCTu3EDtYi@bombadil.infradead.org>
Resent-To: patches <patches@lists.linux.dev>
Envelope-to: mcgrof@infradead.org
Delivery-date: Mon, 07 Apr 2025 05:56:00 +0000
Received: from tor.source.kernel.org ([172.105.4.254])
	by bombadil.infradead.org with esmtps (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u1fSi-0000000GVPk-1Brx
	for mcgrof@infradead.org;
	Mon, 07 Apr 2025 05:56:00 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F5A61129;
	Mon,  7 Apr 2025 05:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id BA2EBC4CEDD; Mon,  7 Apr 2025 05:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2498FC4CEEA
	for <mcgrof@kernel.org>; Mon,  7 Apr 2025 05:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 2498FC4CEEA
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2DF382C2BE6;
	Mon,  7 Apr 2025 05:55:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a256.dreamhost.com (100-125-203-154.trex-nlb.outbound.svc.cluster.local [100.125.203.154])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id D03432C27E3;
	Mon,  7 Apr 2025 05:55:42 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1744005342; a=rsa-sha256;
	cv=none;
	b=c8ecv4BcvcW3CaN3edPsVRg5EIMY2tf4UsfX4kJk9PScq/5tqJ+gDcojTQfHMWV16B736D
	1XPmaia5nf0OGef1Ls8+sRBeNtajOjHv5RFM1BTZa7vvv8b6DB5+UDfLKyjQPZmx2barD7
	FfTd3iBLI8pT074kJgNBxwg9bMH9CxtUXt8SavGuhgyy0t889deBSFLoy3xS6Y0huNZB3v
	I+qiTOQJXPQ1qCBdaYqIgNkm58jTAXD+LQzsz6ZA0p6BshKUSxUVvA1E7L+Fz1Hb/CsDSq
	vf2GRAfMTpuoo5dW0511kmF442aT9/ioHa8CXxcKNVJAOiyv4OqpxJr5KGVYVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1744005342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5vwC8qlEQYlYnI/B9Io9Hkm7VMYd8zEe/UQ58/HH0s=;
	b=9JicUvmn1+aJvt7+aMZ3zDKDpjVWwx5Dx3WbSNRx/D3cIpc34Vej/wsZn7PVDzTgiYDgJ0
	+nkIimPpwnUtv+JBG+yLYUvSVe+rdNafUU7hngq+58AHcWZEWl9pBt9g3r+H2KqU+OGruu
	mKVM4KGNwl/IjidbFVib8um9zzp0xA/1WOxkt+T+Rbj15ganyVASKwCLp9Ih2uQNb2d728
	FC2octw7tloQhD855Xzh26eCESgHGt1cfHhpKsuADL5yaIZLy9gwo7l/5nrAMSpWhcyUQ0
	3lPBjbxjKhihC/YDPvU3eFK5PfMZ6B0hFSELWk0yHlbyvoRdv8HA+JJmwp7fxQ==
ARC-Authentication-Results: i=1;
	rspamd-6c88b8f79f-fqf6v;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Blushing-Coil: 07edaefd1002630f_1744005343068_3107088295
X-MC-Loop-Signature: 1744005343068:1754247259
X-MC-Ingress-Time: 1744005343068
Received: from pdx1-sub0-mail-a256.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.125.203.154 (trex/7.0.3);
	Mon, 07 Apr 2025 05:55:43 +0000
Received: from localhost.localdomain (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a256.dreamhost.com (Postfix) with ESMTPSA id 4ZWJNG36j7z1y;
	Sun,  6 Apr 2025 22:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1744005342;
	bh=m5vwC8qlEQYlYnI/B9Io9Hkm7VMYd8zEe/UQ58/HH0s=;
	h=From:To:Cc:Subject:Date:Content-Transfer-Encoding;
	b=lLcoJNNjeWAZVOzFfWIVG2FCOh8AsI3HufcHc6BbVrKYfVNddndvKr1xt7alE3BcD
	 ufWUS+g2ej/ImcOVzk6e7QVrSDK7rd6w10xPfSY5B/hLtQptcfNeKk+tYkgWmbxCu6
	 SrRVY2efvuMX0rHvdl07lA/b5FNpE/wdNcWYvngJCHNQuQDTZYuJ7PUXhBa3zEz9s/
	 VLemBDnhs3TaShNiFYu3VLsKLOwaFJn0/T9KWVZ62CJ/MkqA/c0KImRjZLd7a3S3/W
	 31UTiPTjKLvPtv9oKs7GJV3ptIKEZbV0TBf7cBzkfT/u83jHnEFHFpMBXTqYTKjfV3
	 8c0MS5vat8jDw==
From: Davidlohr Bueso <dave@stgolabs.net>
To: mcgrof@kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 1/6] fs/buffer: try to use folio lock for pagecache lookups
Date: Sun,  6 Apr 2025 22:54:50 -0700
Message-Id: <20250407055455.785065-2-dave@stgolabs.net>
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

Callers of __find_get_block() may or may not allow for blocking
semantics, and is currently assumed that it will not. Layout
two paths based on this. Ultimately the i_private_lock scheme will
be used as a fallback in non-blocking contexts. Otherwise
always take the folio lock instead. The suggested trylock idea
is implemented, thereby potentially reducing i_private_lock
contention in addition to later addressing issues around
large folios and noref migration.

No change in semantics. All lookup users are non-blocking.

Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
---
 fs/buffer.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c7abb4a029dc..5a1a37a6840a 100644
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
+find_get_block_common(struct block_device *bdev, sector_t block,
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
+	return find_get_block_common(bdev, block, size, true);
+}
 EXPORT_SYMBOL(__find_get_block);
 
 /**
-- 
2.39.5

