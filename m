Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028407;
	b=1+u0uDtdM+1blRWEYr4AsMgsjUgqUEuuL6oEKrjjgyC7tqX+crh20RFGvBoly18FvvLe
	 p/Fa8CIFr40u0tJaEGUN6E92pc8z7YigCso5KmFPSc73J4LqrHZVcjJPEzHttCQWhc5QE
	 XWk4eYigw5Oc7+yBtgVgwAhoXht/hfYfnElatLsiy+hDDI5J1T7RQyZcM9GRpe0rzo2wB
	 sxd779V0bTptRSYclDNgSaCnI5RWN+f8sml4TIrH6jIJevjfYILGwr/5SssqD1ar3/byW
	 7RjW+GikTcIHleEVio/DnZ0gP4ekjDhtgmVg9WIPMkik8fzyivcucaAQzfmXr6t/gfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FYYNTGUgaUIZZNeealoTo6NE5VBcX0jdtmYVPtCMN3o=;
	b=ja73IitmGA7kSeU7G2+by1obDQnfG1H9ecntUw5awzB0z0ngZKKtyQIKFTCMIsa5pGY6
	 DvPW23udQf3KqtIOcNoR5ivpwxHUrisCPvi//FgOqsm+wH59RqqUtMYiHV95sBuLPWtcQ
	 5lC0vaDrdIwJXwahX2xlSamABghVQ3FUdizmuGMU9eLsmoBIUlKDMTIxyGuMjjsCyj4aq
	 LjE4p4UdIGDbFbI4LxTD/GDpF7n/2zGHd8ya4gSzhDwWQfw/tVhoXvGANn4jnJsSwbSNF
	 A199F637XehPyg7jDcIbvVtywrEKgYcd+D1iZiNhBAy/4+bksboxlhdI2qbFWYs3Xvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNf8cZxa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66109606A32A;
	Wed, 18 Nov 2026 19:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNf8cZxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0486D1F000C4;
	Wed, 18 Nov 2026 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028406;
	bh=FYYNTGUgaUIZZNeealoTo6NE5VBcX0jdtmYVPtCMN3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNf8cZxanao4l5f+5rSohOe3geOsNJUh+v9jcx4xcbF55KR4oe+nLpsY0jK8h3AHE
	 y/iOCH1jpPwXoYx9Nwg9M4ZS1fs1XNKt1UWXJGNHIwUyCK4HcnUAzGwqJomwgO1yQ2
	 PF8pjsMJxIO2FBjUXTOVI210lRPHmgfxJoC28iSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2092/2151] zloop: remove a duplicate call to zloop_get_block_size
Date: Wed, 18 Nov 2026 16:03:47 +0100
Message-ID: <20261118150237.907849282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0835f4909553e78a97d1ac59ed6eb776b4f78c92 ]

The sequential zone path has two calls to zloop_get_block_size, one
conditional on not having a block size, and one unconditionally.

Remove the latter as the block size only needs to be queried once.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index bbb6de58d916c..b1ec6d6a30242 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -887,8 +887,6 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 			return ret;
 	}
 
-	zloop_get_block_size(zlo, zone);
-
 	mutex_lock(&zone->lock);
 	ret = zloop_update_seq_zone(zlo, zone_no);
 	mutex_unlock(&zone->lock);
-- 
2.53.0



