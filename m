Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031284;
	b=HeqJlJL+nJi8CpBvzhuHB8/ah7vupJnQ80gvPawajOh+/sXwCNHeMcbZjG6wzomeFrWv
	 O3QdCiNJL++K5al0HVsbzAsk2TbNgl/mBkH67aslQfeQd55yRNg1PIzseW4Ue9MLzXhzF
	 zkr/62YK5GNK1AxNC1lKG2NFI9w8F+qNr27yo/aNgL0KDa3YPH5bl2xDKZsBZGx04XZAi
	 NogRiTE0LFn10YBfy2DS/R2h/I/sZjoQglH3Vtz7Re/SBiAFtqzmG/VFIG3FcoAUVo38U
	 zoObeF6HKej4U3StRirHDLmSS2GA1gcFSv4XWgAgG3GXS7/FabhCdwp+OeLDKB7shGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=79nDyURDLDh9DylOD09u3M3MuQ1+nKWURiczJHcmEic=;
	b=uYoJIY1x5QOKjYguQmCPXmj0MEK7tynZKSSh+eN4H5AFXYkWNLoRTP4W6RrpQoi5Q21+
	 EK5FCS2My7UirAR4jNJmmSN5zA8T0gWVGGn05uvNV8EP+3FvVIahq/3+ZmrIoHgI3dNvJ
	 Qv/eXHjmrGXR/dRqrtmeoySsCUXwTua22vooiK8FMX8OjpTDiZX4p6VQgE9fSik2VymmF
	 tAbiQda0Y3/JMFfjHffMJWtyPbPDuyytdWSNvu1N6cP6Sj3aGeIT8Hzbk+bq7dhL9vycd
	 Hx9aotMz1pGtnA7M9j/gbAt4gBppHi1IyW/KhH8Tea6Mg7ILLNTU4pbLiiKf4FDeGPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiQmFS9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8913606A32C;
	Wed, 18 Nov 2026 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiQmFS9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED561F000C6;
	Wed, 18 Nov 2026 19:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031284;
	bh=79nDyURDLDh9DylOD09u3M3MuQ1+nKWURiczJHcmEic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiQmFS9P8T6NQOCrKf+XfP0U1hCGBfPDiLR7Y8GdjnQ3WHNJRI9wyW5+XW2kg8X91
	 Oaw9b6OPHHnlY+lUv1aRX15Kio9kcgIhrBefuyVq7eiH3UE5eW1HWxnlA/s3aNplvA
	 s8QACOD5rTS9U5sOvkUoN1IT/rLJxl1bvMqm8F94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1003/1756] crypto: talitos - use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:52:10 +0100
Message-ID: <20261118150050.082909087@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 463be1c718fb9f07bdce3d51363a17eac4522538 ]

platform_get_resource and devm_ioremap effectively open codes this.

The return type of devm_platform_ioremap_resource() is also nice as it
has multiple errors that it can return.

Because it internally calls devm_request_mem_region(), reg values and
sizes cannot overlap. This was manually verified to be the case for all
talitos users.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 666d66df2525 ("crypto: talitos - init tasklets before requesting IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b121b009a13e6..335a0ccc63e01 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3413,7 +3413,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	unsigned int num_channels;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
@@ -3432,13 +3431,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
 	spin_lock_init(&priv->reg_lock);
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-	priv->reg = devm_ioremap(dev, res->start, resource_size(res));
-	if (!priv->reg) {
+	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(priv->reg)) {
 		dev_err(dev, "failed to of_iomap\n");
-		err = -ENOMEM;
+		err = PTR_ERR(priv->reg);
 		goto err_out;
 	}
 
-- 
2.53.0



