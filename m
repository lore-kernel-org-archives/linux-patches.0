Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036031;
	b=TasiEcRGaahNe+qvfj6apJ6FgI7+dHCKu0jiHnQ+bhN2cFxHByiiLCfIDCOqOMlC80sQ
	 g8M0/+i9Dl7FUXDUo9uiXAVQnvZ/5IhzX7ypaTPuV4bWmX3qxQ+ktWkipR7vTltdLoXtK
	 qcu/sb243CH++LiAVgM/Vlm9b/L2F2LJlLkeTeDeOdgCTxNjS7fl8HgvM+7Ral5ohuHdk
	 TUPO+Vzg+0ZwTkIHnVhYkx9/ozgjdMcwnjPPVBmNi87hQ9+2oMOepWPwuAkQG53FtXDMV
	 qLSRu4t9EJ9blYxs3ZhFeATv20IhSvSfH22IBoqJlhCvivG6dPbxlneHUWjMc+kEwCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gAcT6sSfnoaD3XWJIaxhZRjQ1xxLZ+Ba8jkS9w2EQ8A=;
	b=kEMLiDQB9YrTr7n2H/6MWkimR/vgs1PRr9wySh31DAu+/rsD9sJedRKag7zjPgWL1PTL
	 GDuZRwFpqQGdym4/Mnjpr2WvNKtJnMutb+yJt/ccZqdESgbDmnZKbajTP37+hwP/w1Rq8
	 C5XSgRvlIGVTddc022bAuIuRMXhZijix3a85OuPAY7PeLfIV8SZc+JHi6aOtzOhGcciUu
	 scE7V8Npklnib/BiyabNHQxmudDFrF+FGtjCIKnYETBQnNTv7JpaZ5O9ZwMuXxHw5SjHo
	 pEKJkw1qvvwssfNDEJnbgigUSOW3dg106qysM4vjHoe7tRyt20jdDr/cnNJ3L3dDjLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQWxfOpR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F372606A31C;
	Wed, 18 Nov 2026 21:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GQWxfOpR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63CA1F000C4;
	Wed, 18 Nov 2026 21:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036031;
	bh=gAcT6sSfnoaD3XWJIaxhZRjQ1xxLZ+Ba8jkS9w2EQ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQWxfOpRgGfI6waskz7DK74d9lSq6Z//nhXq1yy75klPSU94tKXpCIggXfQSZUuEk
	 T419sNlL6t6tnRti3tW/TuCg5Br8mb5b6XT/ezuGOd33HyPTcf9jDNbKJ0dDvOrA0K
	 8snvE5xXTmmPAMS0odBunynQQmtAavmOLJ9lBTpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0913/3318] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Wed, 18 Nov 2026 15:25:35 +0100
Message-ID: <20261118150346.903902113@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 232804a5ed70a8ace32c46d341d438aeba54bc67 ]

hpre_ecdh_msg_request_set() returns -EINVAL when the output buffer
is too small, after setting req->dst_len to the required size.
-EINVAL is misleading because the caller can retry with a larger
buffer. Return -EOVERFLOW as other kpp implementations do.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index e90807bc9d4ad..4ccd39780f929 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1504,7 +1504,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.53.0



