Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041114;
	b=TvqXn24dSIATragHyM2wzRkYYGkKFYAdS52wHQ/PtNCdQpm+EnpJeU2WRl2YtfpjP/rF
	 2b0c/3pamXl9VisJOala69M91KfZLUBqI1ccjkyhNUNq8X2mbYuXRgaPV/FjwjZcnDHe4
	 jX7KdM1DFZJaFqoX/Ktq9jUcsoXlN1gcrYlUBkvCLTum8ybUVkDwHjd93CNlhASB9SlEz
	 oo6aIvIBFTvaeVi4sOXPSZaT9zIQ1m62mIHQGs8SxUBSiy3TO8cWLlLG0SC5haeSgIOmI
	 Kha0HWvbRW1Z0+0Faly61lYhprDyxailvInGsXRztX8/jYDSDFJKoiNkBHW4Mmx4fsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zc/9d0SYKxbnk+RvXJ4YI5MBVN/CGOa7KbyxGGxx/gI=;
	b=GYMfVYwgg0CpLikgqyaQFJB2T7PzEhjAWkFgz2QWZ8BIFLARz8pH8PIh5DIaK2oYv4M5
	 RnpTpu0JQ4sL8lV/WsRluBdCfymVgNp4vnDAo0CIMGXDpztJtmbjTz6KOZndb4ZtmQPgv
	 N9JQrmNC5sJJ/1bCCYTB6TYnop7R3bRzba1JmL0D9pR3vWy9gJZn/XTcxSdTwZ4gpNz1U
	 nFc3A5nTYb7lqMAvXteC4OJzmVWGtDgoLuZ9UBIxdUdw2Pp87jJC2WatYnaRg40SvVv2+
	 VCh5yfygU3nsHthEcNGzLFn4HJ/rEDxjQU/tng5ppyCFxxsOj3jlw8KawDYMr+Ld25g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDTZG5ok;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C08606A325;
	Wed, 18 Nov 2026 22:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDTZG5ok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4491F000C4;
	Wed, 18 Nov 2026 22:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041114;
	bh=zc/9d0SYKxbnk+RvXJ4YI5MBVN/CGOa7KbyxGGxx/gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDTZG5okym1yr2iSzmEbhRzaUGHgHobA7+l8qerpowDt74SFe0A2a+CR4NxpbqBTd
	 eRUaFz9UmF4bVZfrtOSrSKPiavs0kUI9gwqqp+q8u2ASziYqCqdwQDVcR0ESWrzoZL
	 Sf28KqOtSNoj+eNElawaOt4Wadj1L3SyW8AKbAJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2698/3318] crypto: talitos - use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:55:20 +0100
Message-ID: <20261118150441.865874242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44909ca47d378..aaac6594147b9 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3415,7 +3415,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	unsigned int num_channels;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
@@ -3434,13 +3433,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
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



