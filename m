Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052208;
	b=PAyU573mcQCxF8w1DtOw7FbFLgkclPRlbwKx9VMmMm8XhpbYkl4NoQI84hIFYRS//IT7
	 jSrIQ5+V1FN58UAuF29oAgfHKTBgTtfpNYsbgDsEC+R29FVZvOjsetL62/Em44vaFrCxb
	 8of8UU2nZU0pd7QyHlaT5/0bdDN81HgswWxyOgeuQC0tNhW1ZzLzGgd0g1Yu7BGxB/ZIC
	 /OIAWhUS/2PsSxykKYIt1r0yy9gvu/ZQSPRxIzscZ/citL7b5cvisO8TE8yhwUvsRol5n
	 wiMTC8UPCql4ezJVFKoooIFinUpP/LOz2PxzCi+4wXOW57+w5AEAO2ubtRTGLN7UBmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k09+RQuUEYIhhQTJaKqsaD9ddyKqIwjK1QgB4ohfM9w=;
	b=OZCDU978Ehn7NIpxOUotjPxdRJNYL3U7zFJ/CBDBsVy6/kWHH/Ek0VqPmNEe0GdeXx5P
	 PVc2nZAV6vOQUeasP3XGH+reDbiiGLbRyBpjzNIjPsktuOPYNINeSXau9G7zloGIX0vzf
	 /69kgf+eLt1t8GkM9CynIABM9cBB74S0hna26VQU4Q7XJCz9ujtHsPNN7clfzl1RhWdkB
	 cxw1pSK43s4TcLdbjsZcizkAna98gL8GI7RlKnRS9HgOznwpLxwT/ULwT30CeIf4mVnGv
	 D3kwKwH61l1gSjhMPZeLmksEY8BIPlUrOsUBQy57B8SX9Y5T4cWe6zHAp9wHLVwqVKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YF9FcYFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83C3606A325;
	Thu, 19 Nov 2026 01:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YF9FcYFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD3F1F000C4;
	Thu, 19 Nov 2026 01:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052208;
	bh=k09+RQuUEYIhhQTJaKqsaD9ddyKqIwjK1QgB4ohfM9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YF9FcYFiqmQ0D9OKCG8bcY23thXxBSw8L3e1MdQSjq5TN0/7hAMqgEy4BYqnDCUU2
	 T3d1hCGW9OlETwkRTHz64dS30EQzoOBSxXk/mFznU1Cdwz8Z3zrA/+wHor86eqs8O3
	 ZyqYsvAGuShD1fNHk+hxmXYS7rU/AKbitNQ62gqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0483/2214] crypto: atmel-tdes - zero-initialize device state
Date: Wed, 18 Nov 2026 15:35:59 +0100
Message-ID: <20261118150030.515126936@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit dbe70508d507acd677e67eaf029040f5e3a3b2b3 ]

Commit c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of
kzalloc") accidentally replaced kzalloc() with devm_kmalloc(), so the
device state is no longer zeroed.

atmel_tdes_hw_init() tests dd->flags during probe: a stale TDES_FLAGS_INIT
skips the hardware reset, and a stale TDES_FLAGS_BUSY makes
atmel_tdes_handle_queue() treat the engine as permanently busy, leaving
every request queued and never dispatched.

Seen on a SAM9X75 Curiosity: the first TDES request after boot never
completes and the TDES interrupt count stays at zero, while the AES and
SHA engines on the same SoC work normally.

Switch to devm_kzalloc(), matching the Atmel AES and SHA drivers.

Fixes: c659d07f11a3 ("crypto: atmel-tdes - Switch to managed version of kzalloc")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index a44ea6fec000d..3bd5703bcfbfb 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1157,7 +1157,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	struct resource *tdes_res;
 	int err;
 
-	tdes_dd = devm_kmalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
+	tdes_dd = devm_kzalloc(&pdev->dev, sizeof(*tdes_dd), GFP_KERNEL);
 	if (!tdes_dd)
 		return -ENOMEM;
 
-- 
2.53.0



