Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050227;
	b=zL92Myjfmb5vBrR6G5iKKp8dBzMCZjdewBLXIbkJ1WBMeL9WsxeV5GMOR3+Pw9fjN6NJ
	 rPGxOWFlz3o1p9RhUrahqceTcED4WNM1rfIM5FAQos0PqcY2kYbqqyYvVe/G2Hrff387r
	 DiKnkcu1mJpAKtXQ4Gbh7Rcc8KVg/x5ROz0XdxXkri8mU/rHELz977nBqH7hGczPE7BY3
	 rRFLi+PaUbVS1Ctr0fqWx0/Dv6KuNePY5VLm271IcbYA4op6AwDGgq/YztIL/qS0eEHV9
	 RtbR4T4ASfxR4xBDX/oixJUGo9Tp98CqbxGnp7yLdJ9Q92RfYMoMBQ6TBFm7e/7aEeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MVrKNhMgVkRoenc3mTJ0F5EwxdFhqIP2eiINn/Rj/EM=;
	b=Cl3Gcb7ftt2cCi7N5R0VgZLWpxhV7SKnQVYKYaz/B76a2MavO5XXbdB5uEnZLUIubKv/
	 NfO+vDd7jq4I2Ckixk5YybwdKHIzOZKPWg458HuajU9eDnAMkNVyKXuVoWu+ig+eTjSEU
	 NobmblZu9ub4+k3Cp55Q86WBeoERdAtqj6nOU0u3vWyrpME0rXNi+J/CM6GhdO9tEbVvw
	 Wsu+zDCdZKHu5qC/cHVOVaOEDkmL6kBye+jcuqVFlmCpsOBe8wWVd0Mc3vXPMHbPj+QZm
	 7GlYwsZ29pabMP2ydYVUTN+OtVtcKPEOyGUqso2I2Ap2cpuAizSVeY4oRBFKE6oYhdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s6xakxIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56533606A32A;
	Thu, 19 Nov 2026 01:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s6xakxIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A51F000C4;
	Thu, 19 Nov 2026 01:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050227;
	bh=MVrKNhMgVkRoenc3mTJ0F5EwxdFhqIP2eiINn/Rj/EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6xakxIxGpXvRVoCMR2UbWG2KXxzdbgTs91h7ihzzSV+kogWYbAWC3uD07h0NZy2T
	 pE7T/Oznj9uesDogpwgUGePVuoV2euz5T6WABNr/2NXi5Zp56hHXpHNVbFxvWoHmvs
	 wQEsSWPUbhYNgSt6ifqbx4fWY9I6ohb8tBTSQSgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2634/2857] RDMA/mlx5: Fix CQ resize destination index mask
Date: Wed, 18 Nov 2026 16:01:08 +0100
Message-ID: <20261118150336.431819453@linuxfoundation.org>
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
index 997bb9e245979..ec39b26c45d7d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1250,7 +1250,7 @@ static int copy_resize_cqes(struct mlx5_ib_cq *cq)
 
 	while (get_cqe_opcode(scqe64) != MLX5_CQE_RESIZE_CQ) {
 		dcqe = mlx5_frag_buf_get_wqe(&cq->resize_buf->fbc,
-					     (i + 1) & cq->resize_buf->nent);
+					     (i + 1) & (cq->resize_buf->nent - 1));
 		dcqe64 = dsize == 64 ? dcqe : dcqe + 64;
 		sw_own = sw_ownership_bit(i + 1, cq->resize_buf->nent);
 		memcpy(dcqe, scqe, dsize);
-- 
2.53.0



