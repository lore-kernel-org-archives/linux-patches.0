Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023874;
	b=CrqGTfoLh9R7kOYcruHaIeYR3AhFnK6qDExhDuQKoeZTVpK/PIDIzR12K8lBmPGZqe7v
	 m2ELixnCyIq3CnkRQnyx3wWN5Ui5dkWnXNiAqHDZVgpQW3xzedPgSVFOWaLcEK+GTGXCc
	 Vv12rEquxfx0Y5wYh/ZIQELHA30gG0zCIWKDDZDwGSspkhj3KO0gMsZRxcFr/1oiuINBW
	 LIZb7fE6pZGrWinyiHbG9wdGTrWdgNtyZBjYrogA0xM5L6psacGc4wr399AShNDViRyI8
	 ZBxoipeiTVl6jZXF25v3hvS89YK+mvL8OiePsJQDcHZfdyHyesbgC/sPKNQ0yRt0ywQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9fq7otwGyt3aGLl0f7MkEekp7tGjBBg2EahRX0jf0I=;
	b=Sq+c9lDQunhpG7XIQSr8AWGwfK84iqOOZhRp7VgXOsvVZYZ4LGXKk5w6XfQq7J5CTia5
	 C6mRFugiihRMKpaSycteov7Q6iEBB5jCBDAf6GW92YaSAd7Qy/CGCSBFjMM69q1OdOQQp
	 ENP9tq+CHjneLzmxjvBkuc9kgqyldiQ3ecMkxt/Kifyj4gfLJ0asK6umANxAqNe7pAyI6
	 Io4QIrw8GIKyR90enWIBiSK3u+g2nY2pA/8BInkT+Z7pzC5D2roii3hEAN6Ai8Te5jkbP
	 ISxSXlA9H9jtyAgZEhAcUVpJRomL+1d76grOihonqadECi3l8XMzdb7UQL7MdqsgllQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dpqrLiVe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC79606A31C;
	Wed, 18 Nov 2026 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dpqrLiVe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9711F000C4;
	Wed, 18 Nov 2026 17:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023874;
	bh=W9fq7otwGyt3aGLl0f7MkEekp7tGjBBg2EahRX0jf0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpqrLiVevF5LiAJ/OwuDGXKKjfcYjJE5iKlxP21ivDWNiqNyrwzz4+D+SmJBDBWtS
	 BL7Ys0FK4R4QIDTJi4NjWy4NRxs5IEBzcR+am4fafY4dnm+xp+EB7b3znRGpqnQdDv
	 VrlC4FY3VdiI8oGtVl5x48cBvpLunmOibmFRZdGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0525/2151] RDMA/restrack: Dont set RESTRACK_DD mark after a failed xa_insert()
Date: Wed, 18 Nov 2026 15:37:40 +0100
Message-ID: <20261118150141.155105809@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 391c5d826fd0a5dacad54613dbef74c50e966f5c ]

When adding a QP to the restrack xarray, rdma_restrack_add() does:

	ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
	if (ret)
		res->id = 0;

	if (qp->qp_type >= IB_QPT_DRIVER)
		xa_set_mark(&rt->xa, res->id, RESTRACK_DD);

The xa_set_mark() call is not guarded by "!ret".  When xa_insert() fails
(possible on a qp_num collision or memory pressure), res->id is reset to
0, yet the mark is still applied to index 0.  If a legitimate QP whose
qp_num is 0 already occupies that slot - e.g. a normal QP or the SMI QP
- it is spuriously tagged as driver-private (RESTRACK_DD), and the
netlink dump path res_get_common_dumpit() then hides it from "rdma res"
output whenever the caller does not request driver details.

Only set the mark when the insertion actually succeeded by folding the
mark into the non-failure branch.

Fixes: e18fa0bbcedf8 ("RDMA/core: Add an option to display driver-specific QPs in the rdmatool")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916073042.1746-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 56aa1def56fac..97fdfca1cd8c5 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -248,8 +248,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 		ret = xa_insert(&rt->xa, res->id, res, GFP_KERNEL);
 		if (ret)
 			res->id = 0;
-
-		if (qp->qp_type >= IB_QPT_DRIVER)
+		else if (qp->qp_type >= IB_QPT_DRIVER)
 			xa_set_mark(&rt->xa, res->id, RESTRACK_DD);
 	} else if (res->type == RDMA_RESTRACK_COUNTER) {
 		/* Special case to ensure that cntn points to right counter */
-- 
2.53.0



