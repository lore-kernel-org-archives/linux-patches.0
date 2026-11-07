Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064026;
	b=3wgfJARf/Qy2ANNj//3trKA93AybIiqmihGyE9JV/vnlmxvSFJ3/w8yxCVjaM2vV1WCM
	 xeFPuq9+/YBT8TdmF1Ph7T8rR4YB+e/FDVNs82p3lTAsNTa7Xz22GUqYjKoN5Ow26N8gS
	 t43KR2JCg7FPTwpqujddralnLz2BPGNp130To4JbEDv5emfJk0CNz9FgBFQ+Bbyp8Zuii
	 H2ovutWr0a244CsR2GvrYkITi6V1Wm6VmxHikZUDcSoJSz+GjnEZ3VCgpGdvL4HeWW1nI
	 h5KF4tgRIx+INDIAdIKbhWAuPahgV0+6WjijDQ9qlyDsALxjT7FLGIf+Q1+URIryepg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k6A+orx4hDOHeniJDnLis3af4qE4/vFNLxSjC+bXUv0=;
	b=UXYmrix2MiDKmYOmlnPzUOrr+79dzqClbymHx4MJQW4ASuqW5clJZHm9yzI9ULZncdGd
	 y6LfvYzi7bFCLgWaEidyvc5o41+EnDpFKzmHONWhcpPoedZHgqYb7x7jj5T+eCENkl36o
	 GbTGvSZN2P8sKPzgsnlHTBzcntepGeoXJ3piHMGZ6LEHGpYuhGzfAHf5yrdxAHim8EWzO
	 0YzZv7b45m4MKqLnUpljmUjg+HG712OR5yN8WJBQJi1/QaG+utEjdrYL4tEAvU4yWeBbu
	 m5sD+jzmT43qys1DfBTWzY+DtDeBmplsduqHf9Fgr8u3kRa3nYzpIX6Q2ciRsbl1lIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnME5Da8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8B860A3820;
	Sat,  7 Nov 2026 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnME5Da8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5351F008A1;
	Sat,  7 Nov 2026 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064026;
	bh=k6A+orx4hDOHeniJDnLis3af4qE4/vFNLxSjC+bXUv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnME5Da8B8b6b/O36KsJlkjIKjL1uxCzZbKfnBdk8BujUdmoowgy2y0zp/b121XQr
	 sxj5YHX/5J/CYpiGrybhb4pV0wcbnLVBel7AdPu192gLkt0qrV9CDDDS5HX8VdBnCC
	 6fNPVweh/RlzhQ5uhDVNnpmZzz2gfN9aLLIyqXhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0201/1257] crypto: zynqmp-sha - fix NULL pointer dereference in init_tfm
Date: Sat,  7 Nov 2026 08:41:37 -0500
Message-ID: <20261107134945.108449966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 016f22d2268e02df705868110fe4e402b51bfffc ]

zynqmp_sha_init_tfm() checks crypto_shash_statesize(tfm_ctx->fbk_tfm)
before assigning the fallback transform to it, which dereferences a NULL
pointer since the transform context is zero-initialized. Use the local
fallback_tfm pointer for the size check instead.

Fixes: c1dd353d18e5 ("crypto: zynqmp-sha - Make descsize an algorithm attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 5813017b6b79d..cd051e1f42753 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -59,7 +59,7 @@ static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 		return PTR_ERR(fallback_tfm);
 
 	if (crypto_shash_descsize(hash) <
-	    crypto_shash_statesize(tfm_ctx->fbk_tfm)) {
+	    crypto_shash_statesize(fallback_tfm)) {
 		crypto_free_shash(fallback_tfm);
 		return -EINVAL;
 	}
-- 
2.53.0



