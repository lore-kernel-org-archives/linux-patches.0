Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025974;
	b=V0knXX8j67D5tVkxPYfVl5WlaFTE6oZw9XeDwdAXzQVqAkNQKgpnzbwMEtyp1u/L43ES
	 oYmfL9n1iQwwf7RadjkT9rcObwHWpOxgbZL1WThK7/ZViwVHqTh5qzvyRG+RPa2RTM1LO
	 Ewg3DVscMr36iKhOVnQ9A3/QsQXxuRJdFBzKSmxelGbvEpM5mSR5o+jsjF5fW2wHSMV1R
	 gjhhBGkCstyf6XrkKqb9t/196/QAlEIj0hKeMitIjDvEEZWH9zSHcDjaVU0uIVtojQ7HC
	 1X6GtpaDa4Fh8RSlxYhjq7UXE591Ojglvhjg8bPJlkPm4g+/NCtbbzCEa5wAL0jNMww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W9QM1G9sKmevFAQtx8HsmbUfTYAENP0wysyT02iRODk=;
	b=1VwB9Tw2FDAmEJan2UrmqW0hMUVSFDqxJw9oeN6Bn95zTmt9vOCnOX3mnhPCx5MpkNeK
	 dmXvGTHgDpSCZIq0VLDHpaP8h2g2ustlsY/zghjDD+5D0B8bbT/dw7bnhPZEx3Q+uHBrz
	 aHALUnR0EuvObCl2wyTbfnGXME9FDLjfJnJENbhEIuomeTcnhQJWeZQWXXiKcZV5UPd1s
	 LsguPcd5IZqbdUE0dHY80vZLVSuK1De0bR0D38a2EhQYzA4HaiE5i6TSKl6rHvbqJsS8G
	 +RKHPqqeMNNIquUMIZYxORYu+ale6FQSkJ8p3VoqYEv+qlKw7RJpFfsN2sjoATan+Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8ZBROxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7715606A31C;
	Wed, 18 Nov 2026 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f8ZBROxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C001F000C4;
	Wed, 18 Nov 2026 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025974;
	bh=W9QM1G9sKmevFAQtx8HsmbUfTYAENP0wysyT02iRODk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8ZBROxFL5LpOEqe7d/H5gmGfka3ZhbPAhRxcMXkvS/ffavRixxdSxpYcZTqwUrJ+
	 /Gb6SZ0aNE2rqs/aOe/PIO6LqcFnihEZ6QePnwsj20krflbPSgfh2mYerHToTJ74zo
	 3PeMo68Z5owewtPmuRE7CFpHoy8MarXHD2aHYXYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1270/2151] crypto: talitos - use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:50:05 +0100
Message-ID: <20261118150208.400855152@linuxfoundation.org>
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
index 2d69ee6086658..584508963241c 100644
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



