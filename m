Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016555;
	b=NQ6FlA+vWtQIFZac+p0/Y2gWWHkXZ2wo9dk70hWsuR5EIYuXkhFL7MVTq1NZHETAn8QK
	 QUMyL3ud5mfNesR8JvRzc3zh23XUVz0JQ12LdheomQZwkdr6oZmcD5pOEZRm5gWQx/y7T
	 qhEEq9sGUzxPdOf5/eqR+d27xNuc+k6xmPfdvhJZuMFJPLQOOUQIhK+CTlRBigR5rJhD2
	 4BEAXTuYZr664GgIXWzUHTpXIIZCol4wHSiz2nxn/lyhdJpcAbFqi3dD9z0O9zwT3Jok+
	 vPVfjV0zfqAlMJzHhofBeXNf76POUEDEhO2kPxPN7SQ+gkdFkUIbpVG01MBi6JWjUhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ilFBacFuMGS/GxbYB6onKSIzcaI8vE2RbNInmdaZvDM=;
	b=v/pmT/I9dSxRoNMN+g+ToFeC4ERl7Nv+e8l5ULQQukbeSrtbBpm00oqwwCAXWKqomvqk
	 2O3nEBMNUa71lRjAcd15MawbSQjydeSVr91QZnUp9BII3x7ayEEA8GZdEGRPnst4lr2qw
	 Ixgsbfdy2zn9ivFX0ts9/eZvX7vn6yAhIldxmPpjiVg1qqVwvZe2TjaMOtOVf+N/OQBbJ
	 TFQAMC7v7uneLXa1dvrCzxzjXRMcwbnGm5zO5yStgXSg/TikfumbUsiSuHPfxjtsBstBk
	 dbaRJPJTDiWur2vWtumb9yh/COINJHvgedKd+7fMSl5DPr6O+iXnlD9jdjM2KrVQ8yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drIa7fai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCA60A2600;
	Wed, 18 Nov 2026 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drIa7fai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCBA1F000C4;
	Wed, 18 Nov 2026 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016555;
	bh=ilFBacFuMGS/GxbYB6onKSIzcaI8vE2RbNInmdaZvDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drIa7faiQozairFzCsUDimkGgkbqXL5nGV6xnzVM+KGBZ6Ygc/ywRNHP9iYkw+8n4
	 L/3IllL/lRpczTG4ENvj96M3dHXaSlKqL5rPogGvz33JvDsCYhIHFNf2aKBT3VS+xs
	 yQnGRJ0UzBL7QJHhFMtHlw20o5JnXSG+YH4O7P/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0571/2651] crypto: atmel-sha - reject initialization without a device
Date: Wed, 18 Nov 2026 15:30:11 +0100
Message-ID: <20261118150308.293443401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit a9a2152d292fd0bc73814eb4a127278ee7dd3f6a ]

A transform may be initialized for the first time after the last
device has been removed from the driver list. Return -ENODEV when the
lookup is empty, before the debug message reads dd->dev.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: ebc82efa1cd6 ("crypto: atmel - add Atmel SHA1/SHA256 driver")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-sha.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 48f54b6155042..d2338e731d566 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -422,6 +422,9 @@ static int atmel_sha_init(struct ahash_request *req)
 	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
 	struct atmel_sha_dev *dd = atmel_sha_find_dev(tctx);
 
+	if (!dd)
+		return -ENODEV;
+
 	ctx->dd = dd;
 
 	ctx->flags = 0;
-- 
2.53.0



