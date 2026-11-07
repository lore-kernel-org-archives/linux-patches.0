Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064345;
	b=iASNDptG31xh3SF3iLvSXgs4b9NGyGA7/DhwbyBtVHVSgNu3tgoSWgvZFLeSq9D267f4
	 mxukMcu7OZJ/99ndp3J81EyL/jr8DrN4gmLnRPdHzN+G951awJgde0cc/F9R6xjcJFdwq
	 KtUjyh8uxvKf0Y0YV9vy3Njov1qgXBfuzk2QdVI0sdRR5OkBcSYjfV0ms1pPA4mbEaNiR
	 5pyzqBt6+f/FSA2xyxE9mnMeaWGx0WXAGa+36+36Uy5B/lWWEYhzqaORotC21pl1Xf4Uw
	 0rBIvA2XbOe27WqFYjrtXacyfesrTUjmZYMfPHBhpMR9nZ2GNNkyOpBK9n0f0LFWbOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g/c9yvf9Xn3UUWI6/k3mthZkzAmlh2+HD0/gsEpk8QU=;
	b=m/0KCOYDreer9OInMZZP3DakWbBrCs6PSl6NMQkHprkIMGlasbV/RxVjUDo66h6gGa7P
	 nsv6xb+p7BT3ai2kuj8Z30gymAw3JWfzxZ7uLR1MXOj4Neo2WLgkE3rK8nqXOgVQAhOVo
	 +5PDULTz4cCpp01dUrB+zM/InrFdAm4zo11P03T3czkTGoqmMdiSKA7znqoqIfOXElxEC
	 f749VssEl37CcvtBs/hf2UZ5rl2bVigNWuL+9EPP7IUPWmVlSkXmleG0FYX9gKZ5FySbW
	 Mo65pzmg4X4GMEyTkInEXoKwBVLHKKIDfrAjGzpYHeJzgQAsc80HDXmFvvAL9+57Zuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIS2KBDg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D365B606CE6E;
	Sat,  7 Nov 2026 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TIS2KBDg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD1D1F0089F;
	Sat,  7 Nov 2026 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064344;
	bh=g/c9yvf9Xn3UUWI6/k3mthZkzAmlh2+HD0/gsEpk8QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIS2KBDgJvzfJGne8mlMO9pnq0wVv7chQa2svYdGmtNLjW7dvG9Tiv8HOKBfnSL7v
	 lKO8vxPndN8yLrZqV5wAvPxPZDdTS02fA0zEMpOm5OQBgJxJZRHfZE/rIkEckZCcGk
	 L9+YWADXiGqqMr5tG5cJEnKFVxLEYv59djyxtAVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0430/1257] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Sat,  7 Nov 2026 08:45:26 -0500
Message-ID: <20261107134951.363679315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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



