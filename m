Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016079;
	b=i1aYgDICy7uSNu3GWpcN3qu3RMhzuEtq86TtiBhfcyt+e3UiDAQVhFtYHaLak4cUKt20
	 BgvCBzqXZrdnkaBUgtiV5CA6CEpMk0vbAs1bkNO+QL2AOJGL4M9e+FqpKbYiJfMlFR5ZF
	 yJVEsuWLJd/tG8Y90TGTXHpqQgxNjP3g75SEEuyO1OCaQuolXxGtVfPKjE9Qy4mpm0tOt
	 7I7DaxHlHOfrQiSgKr7F9xR6YlVe/oGiAmxBRfN7wky7o4MHs0wEdUMLv4mirVg0Rchnz
	 e/zkv36nGGDk7Tbjo2kUjrHf2/USheFKCa11Scy1lATcTqc69m8QP9RWoM+BUqBRi9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3RBKTaSXiHrILfsm9ZRWqL7KWOviq363MXEYr9GQN9Q=;
	b=1+4xsBm2pvNH5Ez/WmALRCptX/4j6H7mwVyI1YSTEeLibx4B/YINyphM1InJd2n1ghO7
	 o8Wk8iJO9l1EoZIoq2RlUT2+mtvbRExQVD6ZAKYvfUAzLlCrqBi2bG6ePMgHC9cUrbzOP
	 TEddDz6atj7syHXtK+YXg/QcZZQ/j5s2iR64ocfHn4XCRIreRUELbCDSPdKVmjeSrMeZt
	 6Xk87ujdQTFY+QvP9HQvC/JKETtAgBQlufpp6ns9Rn38dt3Oywl7HSNmHU0UXO1pmPjDe
	 TDYGznxdutFKdXGjOKWaKHoNcXFbNSV1ZCHt4EqoEWvZSHQSNpaJry9GENlwX7+FUNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKYd31rt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB35606A325;
	Wed, 18 Nov 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKYd31rt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3A51F000C4;
	Wed, 18 Nov 2026 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016078;
	bh=3RBKTaSXiHrILfsm9ZRWqL7KWOviq363MXEYr9GQN9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKYd31rtituVZjRdofy0PCsMkwSAY/ozhKsTxqxx1O8PwtC7vDvhBkVF71+ISFm/c
	 y00FohxtGlo1XbOnBKxic5esNe9kH8GA5biZ0a1P7ThI5H+k++nmwwswdFxp7t7BO+
	 NNyXgF7xAwaYWW4bERZhwNqxqvFW6C7EujNk37po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0401/2651] block: cap atomic write size by PI buffer size constraints
Date: Wed, 18 Nov 2026 15:27:21 +0100
Message-ID: <20261118150302.274205570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1418b5633ca973723fd20db5c394e5b031f2bd85 ]

As Sashiko points out, limiting the I/O size by the size of the available
PI buffer can cause inconsistencies for atomic writes.  This also limit
atomic_write_max_sectors in blk_validate_integrity_limits.

Fixes: ec7f31b2a2d3 ("block: make bio auto-integrity deadlock safe")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Link: https://patch.msgid.link/20260907074111.721054-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8274631290dbf..e469baa1f08b7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -206,6 +206,12 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 	lim->max_sectors = min(lim->max_sectors,
 		max_integrity_io_size(lim) >> SECTOR_SHIFT);
 
+	if (lim->features & BLK_FEAT_ATOMIC_WRITES) {
+		lim->atomic_write_max_sectors =
+			min(lim->atomic_write_max_sectors,
+				max_integrity_io_size(lim) >> SECTOR_SHIFT);
+	}
+
 	return 0;
 }
 
-- 
2.53.0



