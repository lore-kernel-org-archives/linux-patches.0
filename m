Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052447;
	b=zLyLCSDJ2E7MUtLSGamda0tWtf20itYp6VrmaErVthc28uppT3s1x872Plhk8uS23y95
	 aexyYiVUm5KZAOXoLggqioJSKx/ERTB4i60SHNfp3ZgsBrM9vmfAdFNCX361Ijjdzn8Q3
	 zrn9PeeeDPEF2DQX2L56BKAQkxNKd1OZCqej/JFnHjVBJCHXJxfRVNxB7o4sSh9V6Nl6V
	 ag30Q4XQtJEaWjd/FWpeqYicaZ537rC/n9lWJ8EMfxGemijuB3kIjDXZ83Bbxyd9Agm12
	 XyBr29aRC9n0wEs2mXF7/decyGihJjNhydHzvE+EZieSmEutxtGEiAaNTcYN5qCJtxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LS1NQBdN0vKjzdJLanjM3tF6LqVlvOBcAgmTwXhnkLc=;
	b=V3AnxMuMyEgu5ypbSz8DNLfySZXSD2T6xSO7he/KzAo2yDQqpEWk/hRzh4RxuZKptwB+
	 bXJ6ahXMTjz5Kiz/kqDFK6M/3en8r14upRUK8qFdDZIXeBlbYXsRooRwhzOzqgi6L4kac
	 VzF8aAwZgqM6iPSYtXk+ZK6U2sZRe8euOCH1YeH3J0fp67VGFv8IywWClwn8wYluZvNP1
	 eARPL6vsyRR7kqZKuuJ2DeNKvZSdtGGJgpEVB23yXxU0rK8LqvoevAJzV4DggArs+iIYQ
	 GjiAQtsFX+shxqLFGXcAAH7MuRSzNeZ4NCoatbI2mZXoWCwrfx6Luu2QHO2tdIVaBSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vl8XXIT9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48178606A31C;
	Thu, 19 Nov 2026 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vl8XXIT9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF201F000C4;
	Thu, 19 Nov 2026 01:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052447;
	bh=LS1NQBdN0vKjzdJLanjM3tF6LqVlvOBcAgmTwXhnkLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vl8XXIT9PHMAVF2ZqAv7w7xvi+aJP0GZvXvPlKb/MsnZxF2cDx6z0n92jPry4opG8
	 Vfn0VUVrLmGsssaqzIwd+rN2QyTGzP1BdaXhmE/QSib/GUfmLTKxcvMPXhxqJuZVfH
	 WSQfooAwpOosFSNth/PzysZQXhRp8SQTb9mWf3YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0565/2214] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Wed, 18 Nov 2026 15:37:21 +0100
Message-ID: <20261118150033.588363095@linuxfoundation.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit a91d9346a70b68f77884cba9d9ec3b70f96bf9d2 ]

caam_rsa_set_priv_key_form() frees the partially allocated key
components (p, q, tmp1, tmp2, dp, dq) with kfree_sensitive() on its
error path, but does not set those pointers to NULL afterward.

When the function returns an error, caam_rsa_set_priv_key() jumps to
its err label and calls caam_rsa_free_key(), which frees all of those
same pointers again, resulting in a double-free.

This is reachable when the allocation of q, tmp1, tmp2, dp, dq or qinv
fails, e.g. under memory pressure, or for a malformed key whose CRT
members decode to zero length and make caam_read_rsa_crt() return NULL.

Set each pointer to NULL right after freeing it so that the subsequent
caam_rsa_free_key() call becomes a no-op for the already-freed fields.

Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caampkc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 7881846651d12..677e0860aeec8 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1025,16 +1025,22 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
 free_dq:
 	kfree_sensitive(rsa_key->dq);
+	rsa_key->dq = NULL;
 free_dp:
 	kfree_sensitive(rsa_key->dp);
+	rsa_key->dp = NULL;
 free_tmp2:
 	kfree_sensitive(rsa_key->tmp2);
+	rsa_key->tmp2 = NULL;
 free_tmp1:
 	kfree_sensitive(rsa_key->tmp1);
+	rsa_key->tmp1 = NULL;
 free_q:
 	kfree_sensitive(rsa_key->q);
+	rsa_key->q = NULL;
 free_p:
 	kfree_sensitive(rsa_key->p);
+	rsa_key->p = NULL;
 	return -ENOMEM;
 }
 
-- 
2.53.0



