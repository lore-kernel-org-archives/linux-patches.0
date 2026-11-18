Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039896;
	b=EB2QjzinJTk6ZCqFxOK63KEM8F7eEkOVqgIx2G2mE2mdEixgDMQGjJOMupJCYqUdwwea
	 45fwj8p+dTJsUVujSfpeAfRac0KH+TO5V8am5kkv080reqgWViwKsOhFsdijx31DV3KoX
	 mVa4xDJ58IUEMYiFF6IhdEX6JOfNR2kXqL/2GgvpzHsdbXW69UQwBUBPxlQ7+LpJDbdB6
	 MNrpKwwJu8Z9klErQXzGiFgYx+MkQ3AO14/C8LngpbxHXfTqxrfCCb6jttvLp7n2WAO25
	 TjtRJWfQn6hD0dzcJEyCETVUBU/DyawgYVtr6GsD3YGzEJDqOVfNCfxwaVI/yX5SDCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I2M7+c8Rn4FRPwrxYbiDqneCZIgfLFYVs1RjJKp/40o=;
	b=z/UoC6pgST9/ycESQbi4iZPLKDXQ8IsWiO/py0Az+Zlh1JcZc4qqlIb9q+s7rZrTgcPc
	 YOCxSJ36ztwoF3UIHPViewreyN+8ND8EeS/6sVT6JJ2GbCOYOw0Ed9ce6715zOCyr3BDj
	 hF5CAGl9EA1epeV1nVBkEPE0urLbSqz9G6UK5drdX1lVwamOZ08xjPEV6z6pWRHLc2PMj
	 gIFgRYGcTWiLwtmOpCsBJeKogYm9J8xo2zCWwwNLSw58O+pvaBz+Pz643GHGZVEjvB2xv
	 YptABMP8XBRUij6kmU61aR+lHICb8dZz0lv49Q+yQ7doye9pcJZSCgAg3WQxCXkuYYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H20OC1Vt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CBB606A31C;
	Wed, 18 Nov 2026 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H20OC1Vt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8AE1F000C5;
	Wed, 18 Nov 2026 22:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039895;
	bh=I2M7+c8Rn4FRPwrxYbiDqneCZIgfLFYVs1RjJKp/40o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H20OC1VtYXBuCaT5XDywX9V1iVHCausLI7tq5o7SPxFqrrT1smwpf8tU5Bf+4E22v
	 wo4AYMucX1uP6NB2djAMD+8keUyykUAXon3eNRkhiGI9VpJAaH5bqmrLP/tdkc7Qcf
	 xUZcsiXrVloKYYfx4IoPwNN39iWWftW5D5oW+vE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2263/3318] RDMA/restrack: Dont set RESTRACK_DD mark after a failed xa_insert()
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118150429.702796767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



