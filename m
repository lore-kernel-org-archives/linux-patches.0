Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048370;
	b=0sNRXa/nRvdqsEdX1+a1TaBvek1NLq9YjOWvFf8dLagmkDgah8k65UBez2ay9Fg70pop
	 JV5gKwy5v52zOSDwAA2qJ0oYP90sXHqqtx508XBr5kTKAcDqBEQeocp72/j6l++wRZ9An
	 C5/J+uTP+i6wnI6L6Wn0kmLde3IQlGqO1iwsUEp1HHhmxpneOr1G368A/nyJc+thks2s3
	 sAgGC5Eg8S+W1kqvBU73VT5oFmvA9RT9Py7GWgsNjlIsMpdeLrst5+6A4Nh+qs7blU0MF
	 ipofjKSS8u2w/MI7/JrYQyYVMx9PnEFqaSiDt3UyGQimvU8yP6/REyn0p8Qj72npBrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lKrKvQfi4Mh+hPYEXHZv87SuVGzAeeNPPoqfjwo28Bk=;
	b=aJD4DjIJP02lvb/hwB3AgF+nu1wJE4lBU9Y495eHOFKLPYJf+ixXYEPN74QTdME9oraZ
	 wHPywAmTFwL3TCW0qvEEx0unKNq6tY6caXn8BqoUrLOzy+cCsmqaMtTfzUIyAKxrd1++y
	 PPFB1L19UlLtvNkhXVddqCdc/VETKGB1gk8dJZnLVxIWlkhtUKTwpotqbM3LUNcYT2BEi
	 fHbyNHBW06+w0q3mv+NyxIYyjyVD+wIMZLrB6FZokdO1bFHWZqBptd8HyVnI+QuH1JCsD
	 RAaW+MfoBjHshDpVa9zAu/AjMA2TF58yS2BrzkkZ3PjoY1+HvHYGk32u+raNgZ8Htbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNyg0OBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A2E606A31C;
	Thu, 19 Nov 2026 00:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNyg0OBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7331F000C4;
	Thu, 19 Nov 2026 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048370;
	bh=lKrKvQfi4Mh+hPYEXHZv87SuVGzAeeNPPoqfjwo28Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNyg0OBDM+YOI/BKwWalvi6wUsEaYa8jMUtk7DGW3kF58Q1cx9aBnSRsKM29a7QRF
	 pe/DHy36ZbzatFC7K0naHH7RIBK8NkBqCtRhB1GJ+bYrk31hmmfceLDkLxOMGUfB1G
	 e3pvJKNTQh7MX3AcvyI38w4GhBIbG6AzJ/bS8/RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1970/2857] RDMA/restrack: Dont set RESTRACK_DD mark after a failed xa_insert()
Date: Wed, 18 Nov 2026 15:50:04 +0100
Message-ID: <20261118150312.328663060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



