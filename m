Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042124;
	b=y+ApFpTc6mwjhHjGZ4Ic4iKl9NWj8KtNg9Wp8N7Ifheu+IFWlVMsA2O6CWJZof6RTLUq
	 ahEDAb6E/YKr1Bc98GFS58+9iWNmNU1k0h8jD3nTzi/iSfRxy+GG9QLi+EiJ8DCXw9T9t
	 ozz9LKalnwXyo660kXkC702cW6w+vXExb6h0RdNdkbhot7P9sq98OjsjZgCVZgWJoP4tQ
	 kEB0V4XJXvvePNtzvqLgNSIwhGeSZA/alQPwepN/0vYKvvoERVFgNG1pZIyi0pHaOagSP
	 xwLeZYVjbSyldT7tSFnD17/aKHPLElJSlhXvQ+mQMtdIIEpu+ekvrvC3Duv8aLOV4mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4hzHeyDUJ1rk9qdFZkZYO1I6NY0uBEkXpqHs+U3wWyk=;
	b=r4INEyXja8KnW/EOrvU/8uwbkHidJrGUQH5F/GEtcyeJ2iZvikFZRieit8Gd/BN3z/u7
	 fVVbHAInPBZjV1oCT9G/PszmylbvaLoelPPQtHxUJqElc4tVBrnAak5NRPdIZWBU32yc0
	 eFEsghpwQMv63C5bu6PGwb0VCaPpCKXSUZPUnLFUjmVaNPLfbpAozxzqtw6dyDLzN4TL/
	 e/UHTvY3D1uhGB/MFgO6aFfzC+h9XBE9zo0DTWNgRcnnhnkApsD5mZ34L9ik1YvoeSxMM
	 Wo0Hn2ezcGAo+REoCxrjGjJXTyR13fgFr/aS2nxeCvJRGAjn1DncTk6DvOoBtZSofOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYBrhIqI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69524606A320;
	Wed, 18 Nov 2026 22:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYBrhIqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC561F000C4;
	Wed, 18 Nov 2026 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042124;
	bh=4hzHeyDUJ1rk9qdFZkZYO1I6NY0uBEkXpqHs+U3wWyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYBrhIqIcA7RQBLCUTzSxnFGPXc31X8KCBglhN+i1UJa4Oc5S3oZR0XFBhcXdo9Js
	 jmqRQuJUnky9hKDlLwqp69YXdJMttbcm58CON+NlYSUKFchQOyt1RnuW7pkwf+37dY
	 g35stM/vC4eWAH0h0XvIdpL7oFprLaGn33RfZPKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3057/3318] RDMA/mlx5: Fix CQ resize destination index mask
Date: Wed, 18 Nov 2026 16:01:19 +0100
Message-ID: <20261118150451.850346509@linuxfoundation.org>
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

[ Upstream commit 0fe31052d948a3a993bb2f58cd5886f7ec279ea7 ]

In copy_resize_cqes, the destination CQE index is computed as
(i + 1) & cq->resize_buf->nent, but resize_buf->nent is produced by
roundup_pow_of_two(), so it is a power of two with exactly one bit set.
Masking with a single-bit value can only yield 0 or nent itself. The
buffer has nent entries, so valid indices are 0 .. nent - 1 and nent is
one past the last slot; whenever the masked result is nent the following
memcpy writes one entry out of bounds.

Use (nent - 1) as the wrap mask instead. For a power-of-two nent,
(i + 1) & (nent - 1) is the correct modulo-nent reduction, keeping the
index within [0, nent - 1]. This matches get_sw_cqe(), which addresses
the CQ buffer via n & cq->ibcq.cqe, where cq->ibcq.cqe == entries - 1 is
exactly the nent - 1 wrap mask.

Fixes: bde51583f49b ("IB/mlx5: Add support for resize CQ")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20261019050503.2313-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 6b14832173d4d..e146ef77f1cd1 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1253,7 +1253,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) & (cq->resize_buf->nent - 1));
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.53.0



