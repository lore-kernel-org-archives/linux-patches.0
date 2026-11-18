Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061411;
	b=Xjp8d7O5gnyPxxNP3YwN+eNNoA6ftuFudRuCU0SfTZkzUFZg8u2AYCjTTZ+7BKPc+mwd
	 RTqXReGr6JaxQDHXV26e6P/ix0BGHZuPfOu5dqUU4Zg755Vj4aP5LABdtHjGiPJgHSCLo
	 khDwF6ilNqdwh+tc18az8OwZ69zKHt6N/zZ8cm0RcPH7B0IHFL8fIT8B+i1AVJyl4fqwD
	 AC/SHKGSQseZXqi5BgaGmhRzfMu91FwH8qenQk+euRphWBMCQmWsrdoKQGzPzM3SHMpYF
	 WRTn29+Wu5RDDTHupbi1yC824IHnMu4j3w93oWCfohNkJbYuQwk59/KdFlvleJ/aTXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Me9UrWq+nRiWOTi6F4aUZ2UzDwD7sFt4tnKfeAhdRW0=;
	b=2df1Eq6nW1p4x3uRAmZ/Y8P7VIWKRz7ttHtt6HLEthjky53smL2zdStpi62uMcuxJ2Gg
	 n0Wy99Bt4yip8YlRYRz5jM5dWQuSZhX/g9m3eJbl4rob6kmmexylMNjz+GPoF6Qc9X1Bv
	 vWhQMqE0o09cs3e+MvSMfr9EQwTIYEGo6Ny0YEFqdtkfZSLeIcu3SmdvelDPT63v8cGKW
	 8atwYeKxr9vJIBWAQGH96p2pwGRSViXof7N/Iuxviexhnmc+7R9k89dBxPVGgsSe+wOjc
	 kRPIwhe/60C4NYIb85slJpeR9WK2wCcFoaayZD5O+lh0e6EPTVIvnz9jpXv4uqt+xTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piM6N4yy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8161606A325;
	Thu, 19 Nov 2026 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=piM6N4yy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961341F000C4;
	Thu, 19 Nov 2026 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061411;
	bh=Me9UrWq+nRiWOTi6F4aUZ2UzDwD7sFt4tnKfeAhdRW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piM6N4yymtnYzCWZ/jc7BPSZQECBkloFGO40f7BoNHsLEjozWU7MalH+bVEFqYRhg
	 LomOOPnna5Y9ZC8kx6JrpYhWUyEjXfEthwM2gDGg+eMDZfbFIXznKcWv2SspPGjMJj
	 rvv/AO8DvhsLkOExrTpXNEV/ZWgE5lWxa3aALOUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1542/1848] crypto: talitos - use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150024.095881965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d4184d8c46b4..0715884f88af7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3344,7 +3344,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	unsigned int num_channels;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
@@ -3363,13 +3362,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
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



