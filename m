Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029945;
	b=5BzrAMf2DwzJp1Vly0QWzl7HnlXzwJ59ZBD9hPrJr60zhoFIYwLgYy3YK6tBdFznSFit
	 dTu/mGF1W4HRsrKowFNLVPuX/rhef0rfnsCj+bVRc8bYYC2mTuaYAD8IBMt3j+++GVK+z
	 7kMh8q4MpSfbt9xNaJqugWrwjJDCx5MMgPCZ4Nu/48MD0FWtEulppxIIPq4FoveOMyNpT
	 tHgEMfFxaNno6Dazils51nYm+sN+JjVN7Ey9UzlD0VjDN7mNDSsIG8Axd9xIJSO81spAU
	 bI4PBMQHJN9GDFyhfZYpVuYBZEvW1U5NbARQc1ApWSek7PRiDZ8dt6RVZqMn79F0cgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L9Kkh1CujFPbsppys5NwRhTs7ZF0sX79PxlfcWo70yw=;
	b=OJBSAGyCW+RGbOMtfJRZ50RJXZK6/FNS0WRhv+jTvawIyWRz2KTjlKWToqFlQDsR/A1M
	 R7u//C0FyQf/US556Otj5MLGp4VdRC0T2YjYYWEjkGHPVmm43Sqd65MZk+LN6m6p9o6Le
	 RqeAgUsFX6wPqbgoDjH7XImtCnIhMNBNe61y2M3mYX8knaYML1I6q+SmhLWiKz/yZhIMI
	 KOGqyvjLZVA3R1JLxQv2FWDxzHoEudHaBR/L2iX5Yr/sDApin7SPAqMbnB2xuorbND84k
	 +DqXwlJsPd/SVFdO752Nkg4zueGuSnl8vmRvPbKQ62m0oanBspgynugANjyUwRnRmkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9ZumSrq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AAF606A31C;
	Wed, 18 Nov 2026 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9ZumSrq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B2E1F000C4;
	Wed, 18 Nov 2026 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029945;
	bh=L9Kkh1CujFPbsppys5NwRhTs7ZF0sX79PxlfcWo70yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9ZumSrqH2gqvoKuDs9HjuGo50VTq/uBua/T+xMdHMhpec2YxnevneymPzdq2fEKX
	 OxueAfHUtNINyIEi+7Gc3SVF3f3dmfSKoaLtk4GEXVtlV1Fa+AIBGAYKoaO55NIIMK
	 XPOoGYIdw1irJfIV7aXD7SAO1nS0zxaCBXnaDjmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0513/1756] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118150029.600861241@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 5b87f619cc5c0a55dcd85ce97974e3f5b9333b7b ]

In hpre_ecdh_hw_data_clr_all(), req->dst is always NULL because
hpre_ecdh_dst_data_init() sets hpre_req->dst = NULL before mapping
the user buffer with dma_map_single(). The dma_free_coherent() call
on req->dst is therefore dead code. Remove it.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index e704b62d8beed..91232d2dd4ba4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1467,8 +1467,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.53.0



