Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030529;
	b=pqpVDrS/jrrz34oTb7mC5yjiH94k/DD7HZsn06MJHp2PRrTKzMIhwiw5ABMZKn92G2Vg
	 O+8wrr26lowA+4tQ1haWyrZ06alulmRTvZv+Z710s2PuerUpoIoT6KHmu8Y19HiZlOtKd
	 421GZExDALOWfXPqEux4b+AE3Y37SoYgzkJi6idKjXxG/NsvjUX3KIJvwa3wB4292QUOW
	 f3aToxWXuOiR2nS5FHPzbu6FB2c14bBlBHYys0huuG1qAME8l+Hsp3LM2aHanTFCXnz+P
	 BjLU5gWJSHIFO66Ja2X1cz7w//7qk2rdXNkZEb/HjoIZ/i2k26XbL6QzefFI5QtHR8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P5lEGZRBOcTQKy7NIdFNQjsoxKFByiAX+uRx/LOYcIE=;
	b=Z/5ZpaymCubN46fH7z4aFmzeJt2kmt1oWaFgt6TYluOA5cPq2lqfIsLHbVE947cZ/R7x
	 s4FuDri8u4r5pJz3shiojKzcI9c//snQxfPy+F3ohjBqbXjdCFWpc/dqnnQ1/P+3RRaZW
	 edlmwMVrbrEv0F1d3Up6nbxkpgrXcz77T8hEA8o0hNbLYfowM0NYNbT9gnx7/NTALFA8z
	 IBJq8tLr/DKYwMjLexcjwPh0jKawj/T0h14OamAsl2E6rrw80ZYkjOgvQQWlhbk1pMHym
	 WnIzamTcStC1CfIJekabbga1UajHw2zXuqAzZ5IVoVilsNJoFHWn149yIs5puOiNJvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P04stPvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE3C606C419;
	Wed, 18 Nov 2026 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P04stPvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C481F000C6;
	Wed, 18 Nov 2026 19:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030529;
	bh=P5lEGZRBOcTQKy7NIdFNQjsoxKFByiAX+uRx/LOYcIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P04stPvI9nCqSujVDau4cEE+IdOPfFlyoDq5RRu+lfDAiM0gZRL2+ay0FfAnkP/7p
	 Kvr8T2y6o4jSMaAj4StVpWopAMAcDm6A8Yx+vFrgGkR6t9p+SL6mP0CANY5z5WNvYs
	 eqklU0CZXX0MikQjzaAD7wNyEd52RcLtTlTSnrm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0696/1756] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:47:03 +0100
Message-ID: <20261118150036.904861454@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2dc2126e690203d6adbddc7675927a242d810e43 ]

ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
size from wc->byte_len without ensuring the receive completion covers
the GRH. If it is shorter, the subtraction wraps before the result is
stored in mad_len and an invalid length can be passed downstream.

Reject receive completions shorter than the GRH before inspecting the
MAD header or deriving the MAD length.

Fixes: 8e4349d13f33 ("IB/mad: Add final OPA MAD processing")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926105927.3183294-1-yaojiale02@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 21f482e0243f2..d68803faa336d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2084,6 +2084,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			    recv->header.mapping,
 			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
+	if (unlikely(wc->byte_len < sizeof(struct ib_grh)))
+		goto out;
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
-- 
2.53.0



