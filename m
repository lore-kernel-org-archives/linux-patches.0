Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056060;
	b=Pmfiw2CcW3ce+1AfhvAFiHFXOGATZ14FaYESK+lFFEcQ1R1n/T+RqFQSeI3ySO0CVbOD
	 Ghyj8OCdzw+WESW2sJ/7MzycEl02NAdlTAnQXaFABT4EivlHTyq/+RZiEDdfM4pqp9eVh
	 fkRM3w9f34gZDeQwvXBCYGkwMlD17FaOJLanGGyef4L4CNc+qeWbAlgiOeaiiY+O0oRX3
	 rASJSWsNgYnSfsWg9As7MuPUjZ1BDOQ1aSXqPwDstg+vBXaGF1L/dcH+V5HKqr/+sR6hv
	 S1CZsRcG77GcYWl+snXodhUv+MSs1i2kHtPixgiGfiCFK22MZbH9gIIEeIPUixw6bgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ij/srz4813XK3Eb4fDWAk5BUXjgM29V1Smd3C3i6pc8=;
	b=ScUSgb3webRadXnFR/MGBBnwXGJ36ur15pr1YjwUbk5SDs65V/vLqLAmlphCs4X04kTJ
	 2o7gemWdzkobuXImk/IeIYRaKFFq9oHerVDP4hHcFQq9oPCLuGJpI5vS0skPNVUe/uGKp
	 QtFTxr1Z4F5EexqgpAfkVYO9p4oATZRFngS+gXhC9nsCLKSLcCOwlWFqT9V230vGes2Rf
	 7lzXEwyLqaKFB0Yx67BuCOqa97DDBlq8eivdwVO9z0CBsQF3kdSFuMH0m8Nn8mGgpno4M
	 sgrD3dANNv2hafVf4dEe/0t3qiYyV2ms85pi+kG2AvMkNwEKPEHW4IPqYzXbmuhIMng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1G0uq6q+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698FA606A31C;
	Thu, 19 Nov 2026 02:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1G0uq6q+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9A31F000C5;
	Thu, 19 Nov 2026 02:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056060;
	bh=Ij/srz4813XK3Eb4fDWAk5BUXjgM29V1Smd3C3i6pc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1G0uq6q+syUmAamu5IBwujNvHLJ3KKow+SXsl1AL/LxMuXzAzXykGyAzrMlt/BhPl
	 crBmSRr/I6esbaayr6KJpUGWZnyrm0oXgbR/G8LfEVA1Q4bluymxR/LExrrSkXBgsa
	 G373FwKyzocJspA2+VMmemIqb9H4DDQM+1/dOT9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1816/2214] crypto: talitos - use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:58:12 +0100
Message-ID: <20261118150124.120341809@linuxfoundation.org>
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
index dcc73423eb6a0..78fbf8b457bd4 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3345,7 +3345,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	unsigned int num_channels;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
@@ -3364,13 +3363,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
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



