Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036230;
	b=zuJzOI6eVRAvz+i4tQTY3baExjx2im6zcBFgKQzldQvyVu3d0OOCfhMdS5zHgD7JB2/E
	 9qSH2aJxdYrfEZAk6eb+liPk4QwDmca+zAa6DiA0QAr9lkOvMnXEB/ap80eY0pRB2j9Jd
	 lmJof7NJ87maZjqKuqzQruactd1W0mVdxCo7bf22zsuJrpHCblwOQlIv/ob6lOLCWlfpN
	 iTubwaosUtq5ZHtEABwCDNdIWeqPUhnMmX0Iq6H+/ctFPJNJ5rWmB3UD+0slmTEacnhCE
	 PEIEn4lyEBg7iKvbygMDoJRnHl0lPLKshCAYBBx/y3HxoMseVFr+Z/kxJqLDHSpLLxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rD7jZ8BFsjpLcgr2q42TdHlqJwywBHyYJnNldvEEpPY=;
	b=FGwBCfeMwbAY9cMfZBIjPNXKhKHWhhD7H8vqkJ+ccgkSuVZudG/Psz4SfxxxE9ZMt0Vl
	 0DmQjFOUMArQ9U76BwQQEEzTh7dx8gIB9twbr2w1t6c3FjPvZ+Z6jlI1iJrn3FQD9V8Ds
	 JF+sgasnYxPRBt8+RkDw70yyjMnIY6Qg5Rcj+G30EudYDqwTc0+VXgHe3oHW62gBTz57A
	 dJ0vy0ZKIYpK1sBWxi0mNISSM7/Nso/Xb+GVaack+wO8iqA3LzMD2/LbidJK8wpkNyyNZ
	 cofdEhkryRAG82vO5l3PLtnQa1WXrQ//TU4i0GRI+xSKQmj8pdvhen/1GeWHLknPSRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVmkmHnt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01790606A320;
	Wed, 18 Nov 2026 21:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VVmkmHnt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033111F000C7;
	Wed, 18 Nov 2026 21:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036229;
	bh=rD7jZ8BFsjpLcgr2q42TdHlqJwywBHyYJnNldvEEpPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVmkmHntrsRrzYreIcN5XvnRwHD5RZ8z252v8PRerVkELux4//wiS2baIa6k5GUE1
	 TTuofJR9S8uEDX+wiDVvQaORsJbT3IGXK5RRMQVvjya/st12VvygF63pfOyKoRmg9Z
	 c1fEFJ1bZxoe6wMjWxn4VtkkYjOzTD2qZi1z1lT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0986/3318] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Wed, 18 Nov 2026 15:26:48 +0100
Message-ID: <20261118150349.356671131@linuxfoundation.org>
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
index cb001aa1de661..ac515ed8c5755 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1033,16 +1033,22 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
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



