Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049372;
	b=2uucHlce5u/x0VxoIs7aO9OvO1lKzEI7m+42lGrJQAIAgULVckoQ61HUnZfvXpi9LBlR
	 79tVnXhhha9TnTKPVKW08Lt9Btq5/96Ve8LYvOpAWAPu3FPfu5bWokC1OqSbr+XJHLHBE
	 D2RtvxfZy4Up35WFlwkw2d4mFDsbf6K9la1MqeGLA2K9rhc5OEij5rburkUtmP+PxOwRk
	 tV8pXJxYjIQVE3KJWx2BURWgeVnBelYBSDicMoutpNw6QdVqxv4oZpa954Jx1wT83Y5pJ
	 3IbdnLtrowY9vpaPO4aZ9dfBNXguVK6znpCI/DnZ6HsH2xmDADhM9ChXLyC5TQxlXNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=touw3xGdh+RBlAIAabJVm07mf1mZuZmFqQnWmf2Q1zQ=;
	b=ShY3N2IIWSsnyKMZ4rvSggPv6GuJSR5qS9ShFhAKoFI2qWC5HR9+JgAnQU2oz/xr9tNk
	 Rh+G2EgteqTfpjnTaYZhn0nQFK6I10L5PspmSgcGMZz8aOrNBLufB4lXw85idLXJXlOyR
	 gJl7RCKDOtPdP+R3/p2SiN/W7cA6AZqbKajxP40IMP7kLetfkikhl6UI1k6cHGa+x3HUn
	 ZOU4R4Q8fjt3Hc8VrvlhSutVnne5NSuDe74wYgBgx/xCswDxAK9oJMq4TdcZqsb0bqiGk
	 iv2vsepGRseS7GYilpIXPRyld0SuhTMAwUi+TgPUW9A3UDvHADMg+UNUcx3EQ8bJ7/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztEOMy3n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550AB606A32C;
	Thu, 19 Nov 2026 00:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztEOMy3n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C111F000C5;
	Thu, 19 Nov 2026 00:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049372;
	bh=touw3xGdh+RBlAIAabJVm07mf1mZuZmFqQnWmf2Q1zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztEOMy3n4mgKv3TWXlsYcuK+rxIbfvECIHdl8V+/EhXur3rB9XI6K25HPDwiFZFmS
	 Il3nMo2n7ugcRm28jh+AVN9HGKL0q8sVjZTatEwSm0TIU7RhbTJmP63zFJfUpaAHxK
	 b0+UMmIw8p12ogV8Pk9ML3NXYzMuxTw/liQQhvFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2329/2857] crypto: talitos - use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:56:03 +0100
Message-ID: <20261118150325.394547985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9efe5533761c1..5a4f2322b183e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3424,7 +3424,6 @@ static int talitos_probe(struct platform_device *ofdev)
 	unsigned int num_channels;
 	int i, err;
 	int stride;
-	struct resource *res;
 
 	if (of_property_read_u32(np, "fsl,num-channels", &num_channels))
 		return -EINVAL;
@@ -3443,13 +3442,10 @@ static int talitos_probe(struct platform_device *ofdev)
 
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



