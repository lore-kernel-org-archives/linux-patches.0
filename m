Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023589;
	b=twzGc7oBCeiqLPssEieoHjtNl+uD5wTKyuD1Llghb2H0aGktKZDWwHdKeAn+Coxnv7WX
	 r3MO/v8TYgtvHT6zm0wwRrHBamHVH1SAcL5JBNVSByF1GH7JdSN6zXdbnJQX4niof5F8y
	 uKa99B3IEzjPLE667eLLdkVGaCmT1SjHDgrMoF48lfhVdppdhMcB5oDMUQRCHPDjFH421
	 WwLRq9QEnsGfLjMkgT2aoNSyZ4BDTavJNaOze8Pyk+LCRdI57oUnzXa7uyBnFhENZuszg
	 y5zHl/6rBIu1ULF3yixMZj+XLBH36q8joZYqC+htp1ozr2eSJraMNCwqMIpgD81bK0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSSsHMdJd9sPAmxJpAvu76fteV6OGwL3D5AEWeRly3Q=;
	b=qC5UiclAaZfe3udpa9gUtw3O2MVPfwIVpf0k2vWxLq7ijIfvI44fUsLpl28CBD2ri4pA
	 IU/NwbHXbs1Za/YQIuSaKCTptsWUKK77pauh0lHr3DTkAh1Eb/t1FLhPIiXjL/mpl02vj
	 hNlTDgNuhTK3ObNu3+hm0B4dHc2Sl1BaIkG+xqhulnsfDBfSGW4LVoQ7ZybXF9eDWi+WY
	 n7mKLzaOOxwt1AJVzFiRqL75ETk1wjVICtawqObZApUY8p7MuG4/CfCfKErUr7d1BlpsK
	 OYdlqZ6ZSW8PS7zonWORQvs0cNtuo5goJ4AA+KC//L5nyG2UY/20yb7y/EURv5AdJQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJhRPned;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD599606A325;
	Wed, 18 Nov 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJhRPned
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE951F000C4;
	Wed, 18 Nov 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023589;
	bh=tSSsHMdJd9sPAmxJpAvu76fteV6OGwL3D5AEWeRly3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJhRPnedbren5xc9T91le3Xao5grWeJTQ2MnDsHzMuDgBj49/6HTD7dWV9K4PnGyj
	 9aiCt4miCdc5dLfJaawbNGFu58zDacKoC83Pf+BESpbHJJWNat29g/FV5PSOh736BX
	 xtvT+RsLzRNa82DL0cdhzzQMVe3SbSxBsHsu/KfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0386/2151] crypto: mxs-dcp - handle zero-length skcipher requests
Date: Wed, 18 Nov 2026 15:35:21 +0100
Message-ID: <20261118150136.135448521@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit ac1d6a65a1e1f069f119df42c6b57dbdff5f6be8 ]

Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.
When such a request reaches the worker, last_out_len remains zero. The
CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
value when updating the IV, causing the offset to underflow. On
decryption, the resulting source address precedes aes_in_buf.

Return success before enqueueing zero-length requests. This avoids the
invalid source access and leaves the IV unchanged for a no-op.

Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 595b2fd84667e..cbbac70d15ca4 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
 		return mxs_dcp_block_fallback(req, enc);
 
-- 
2.53.0



