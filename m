Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056633;
	b=xHiLrPjSMz8hQK9JtbLtUcpaty54VkDIqFvLpXfuXN1+UNl2ebtDV6cCM6Cz8WJW/QGp
	 1jDd4dCkE807vv5YhiPUosBlYLarnW0nPKT5jqOe4F8ofQNd0BCzqFEi0swk/pmkN1tul
	 pSUz/TExio9wnmDN1NN6H9DK//pcKaxqmAfBHyawd8GUcENS/1HbE4K5NN2wKXCHMcTp9
	 f+/wvFdnecI5wjcxgJtK3MdS8J8iVXFp08z2nj48GJpHmm30Ovx/MuRjv6TnmAxTxiQgs
	 NSwb2i8lVSaHFgFKszT7iKmZYIi64VOuVAUyEaPx//+P7PM1/iu9ZmgcZAIT6BveajQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=derGJD20e1EZqz8PsO0mHe1crtF7MkT4MEs2Hu6+/TQ=;
	b=QpuBWdqvU+/VQLx8U6uXmRfCbUwi2ZJpc8LT1iurajVmlLdoOJLahJaEid6VgT9Yotrg
	 a2zRsWQEcMZ/wqiUqxfLdtrTf77Vm68XU3CsdRIWx6O0zzT0oJ7quMlUXN7BFQqV4EW0M
	 pMD7CGs27O0nn0Y5Cd1cRBiu0g/RYMgs/Cfla4DUjjrw9zck2Q5J9B2GHBzhqZFUjWUrt
	 LP275bNJYqdialRe/aM5Ypo/cDISpr+bsTvJsms18xS1K2ngSaqeG80jQqEglOcFph7SS
	 ahAlXp/b3Z2k9+h9gzP13VApPRytNBnqVGP2NoKKP00tVv1nIpy/IxZC3IBHU8qdylQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwWZewTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27DB606A325;
	Thu, 19 Nov 2026 02:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwWZewTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED801F000C4;
	Thu, 19 Nov 2026 02:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056633;
	bh=derGJD20e1EZqz8PsO0mHe1crtF7MkT4MEs2Hu6+/TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwWZewTJiUKbtrv7ba879eF8m4tNpJjFQ2TA/GPqzz80KgM66LcYcJ/XkmoYkL4fy
	 afZkFVcs7xNx1lYduEY9uWkeCQWwRSo8xXkQ8rTM80YJ77vd7SXdxj9yZwCPYXMabv
	 Cql249MDNJZmfp9PjbEPGPEyycN/OvHnrtSD3cDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2057/2214] RDMA/mlx5: Fix CQ resize destination index mask
Date: Wed, 18 Nov 2026 16:02:13 +0100
Message-ID: <20261118150132.967803167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc37994ef924d..f0a27f9ca4305 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1240,7 +1240,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) & (cq->resize_buf->nent - 1));
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.53.0



