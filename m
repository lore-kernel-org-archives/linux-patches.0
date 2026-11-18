Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029765;
	b=PUgRgEOOgQpH6F6aJniCYjY/xuIa764h7tqDs6ATv9fhtHv84I0N8nuT+yokoscXIxrt
	 kevyKyMF+tROPD+MtIgnusBtgIXeuhEqqgwqV3bhF3202low48wpAotxIZWNpp03olPqH
	 N3QSl4chGtnOTsjzFbiiwYWcN/KYse4gGrHMoKfu3RhoyjM7tHbRrlX6aHT7qcgmBiEe7
	 EhtPPV5jamTVzhvE1prKQ1mUXPICYadNxJnl9O76ZBI17QsXDKHjt9hbIgVX9ULE7tBpd
	 kloPGYVAW9zqOxsPAd80jJ7GVPT56rzelRtSJZgStM2ddCxTCNzAgdxiCFcqJlzrdlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BG7Jd2M2PRWHL/hOA7wwlpwWLJBjZEQYvxm6gU6hMUM=;
	b=Bfry4g3lsETw8ULaCvuOqXKQaVlGZ0mgObgw0rW25BHrjXznPDrTDTyn/xrwlS9P21n7
	 MrBLIDmCCjBRNZp1kJ9M+tKYOj2/mLVK19V42gABoa4Y3T7NA2S7ZHkgan2ZnL0J/EmJQ
	 rRIxmDvGTvf1yZtbjCl6Fz8/NtgXZJUKTGBwaSBrYsp7tSYUIz+ra5UsRZgQBknh68403
	 NQAjs+q8TGzsFR39SOvs/gl9uOG3vp3nWPEgbZ4rjC/F4RNvZG+rwmKpSDmo3EoslbZzZ
	 qizerHKtesgR+F7qCoDnQUwblfxYyXYBdYl+gH4FFHbJvMRbByj8xj6UZw6NTt6BmBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwkC4CPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FEF606A31C;
	Wed, 18 Nov 2026 19:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwkC4CPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30301F000C5;
	Wed, 18 Nov 2026 19:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029765;
	bh=BG7Jd2M2PRWHL/hOA7wwlpwWLJBjZEQYvxm6gU6hMUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwkC4CPGrYyvyghHGsW2dkxa40+FfecrOU8A8rVsCVVAvmlA8MYUTiBesmxy0YyGU
	 rqHEQSlaUDScC5PxGvE2xdi6AHo9XKPImUHe6u3kjkP90uer+MoHZNef/KR/lEaWla
	 6/7hsskSXYb5Zqp2ViMjLPsaeHv7wddCxBnlewPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0464/1756] RDMA/restrack: Dont set RESTRACK_DD mark after a failed xa_insert()
Date: Wed, 18 Nov 2026 15:43:11 +0100
Message-ID: <20261118150027.237909233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c03042dc1ca5a..c6ecc0d6628d4 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -246,8 +246,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
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



