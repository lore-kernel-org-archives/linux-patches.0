Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055233;
	b=oSJLNN9iBRVt6Dhm1L4QfwfpSrDUawV48OFT81cINr0cVa4FKmefkjKSsxR9hEnoILa/
	 GsvBlZZn6ciJ8kWd9IGTIubJ9iIVFkveA8v2w2bawBd+94nPSwYJCwcPflUs9d6soqv3b
	 9gydnAlz91azAYrcRGKTGmL9wic0pVAznw8JxDtP6b4/4/hNRqjqnm1k2hYqLeKwEz2Gm
	 yNPZFudp92dgv3Enz/HHkdmdVaNLGL8JFm0Z2jjGM9KSq8MvDk7cyX8xKxwMT5YkxBngr
	 x4HjRvskgF+wQdo/QO9ImDDmT71giuQwA0kSQaZSZMn9i0y9+WzcShKTX2zL/HJk6Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gdKrCCDVGdHDTVh/SXSyuk9vRT+W36F2nEOPouOiA7w=;
	b=tAQA1ENhqszmSPla6kYzcl4d14welS0F5YzreslVozbEkJ/Rk58YbPhF1Dl6hM0vqTuo
	 CW5F/5IUe74TjPXH2LIhsnMSBbTeGzzWanN6vjdlBszYJSaIO9KYs4f4l0jcWP3ows21E
	 wOp6luZ8r6oytpH01PqGUlXtjr89ORySyd/FksaJcJYenZlppJONKoA/h35gAHUfwnSd8
	 eKAZ6lRpWyV9u5PEJ9q3tvcE2kQefJKv3OiY7PgVUAxJ5ZiG44bLW7XOJ0HpXIKPtB03Q
	 kMuLeoe1MLNW59FuUWAb3/s3baVDiUWBrwRX0h5vp9LdKGGUzZaHUaKJbReCWrhsg1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YtWMkYb/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B656606A31C;
	Thu, 19 Nov 2026 02:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YtWMkYb/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D8C1F000C4;
	Thu, 19 Nov 2026 02:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055232;
	bh=gdKrCCDVGdHDTVh/SXSyuk9vRT+W36F2nEOPouOiA7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtWMkYb/+b3H7Hmr7VrKxmPWz3D/OicWfI+ncgcJ4dhD09GhyxBreZm4MUikZentR
	 C5t6kHIEMhMc9MfHzaza2AbfmPC02pfUlw14hKdqHXSnbSsmwoq+IcC42RyhilBjW4
	 Lxqn0X4bdIu+IUx2oHETVzXvH/lhzkCd5pGWElYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1559/2214] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150114.450406713@linuxfoundation.org>
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
index d77056178d7ff..204d559a9be54 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1438,8 +1438,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.53.0



