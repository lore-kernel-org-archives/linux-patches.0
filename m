Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062885;
	b=1Eeby5N6MHODOaO6tYDkcz/zK1G3kNryy+EVwads6E2sEuSfqKPdwczwWkiomn6AY8rU
	 qVvAnXkgA/xDJsunhFwhkLcwHr/MaOVuSPW1pCpt2hZX3JYI/ra3SQJZ85c3PBm13Pm4q
	 mfdI7CBzqliYMa/CHYmdm66TszBTHN6vIYCMb/ONHTdAEK8LuH3Ne5b8bgEGBBg8y9jhM
	 0PObVjy/JtlLzlcLTXMJNjahdzWn4GOMuTViw+D55HVTnrHvmfxV9Qpk0ysj2Z6c+JO9t
	 Dqwhc2cx9feKC52cRp7b+n+pOpQd434NbyoRcWIqDpkgrb1OZcHIF2wf7iHgvB0DC9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gn634J/7olAmzweYuKZb2v/WKk/jTtLeMlIod6FbBs0=;
	b=RfPfYvZxCPJR2F1T3tmzWbGkriVf4tfBck6lqYybjzzvrFEGDFTBc9Pifpx6+fBw82Z1
	 sk7fDU9P5eZqBbXkzKE585CgCXoIvbYOKUgTVtPrwes4GZ0cVV1Rc7iNLplRdvDvXjRUb
	 69VwBWdGnXlZYzJ0QMcz2dcb7e6OQrE1qdYEnREgvDrf0n4Sd69SaqGd46Ch96L4sHOCL
	 7Blv7IfVmx+DbMeYBWNNgon4qsFWImrV+W3H73G9V4tBhrh6X6lm2ml3TZO2T86nULDX6
	 vAmCzvgAFl9Nj5PTKKHtxiWMc762YxF95t+SygRcUqowsNj8rJBfb33UrJj+jBVw6bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4xPmFMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E103606A32C;
	Sat,  7 Nov 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4xPmFMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C7D1F0089F;
	Sat,  7 Nov 2026 14:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062885;
	bh=gn634J/7olAmzweYuKZb2v/WKk/jTtLeMlIod6FbBs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4xPmFMaB+5mbFExjVIVFBYfFDJQ856dqIPwLiPGXKqJqLEUDe04dD/g4aHHny9sX
	 KF+SbdssNpGxe0VzYtUPqSBWub8Szz1zsjGTzJTLhAfKJSYf8KPoPGX855yyuFfNYT
	 7mUwduM6rCnqROwvoL0kkbVnVfa3PWGZ1Yv3n1O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/869] crypto: zynqmp-sha - fix NULL pointer dereference in init_tfm
Date: Sat,  7 Nov 2026 08:47:26 -0500
Message-ID: <20261107134857.819146464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



