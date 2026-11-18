Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045258;
	b=sMjzLNVgd04O7Y/kDD22Kcgg5T0n0pQfa4MLXm3m9h8ocpUVNi1EOsHVpBJn+qPBRKdL
	 WhkvQt6Pt0SJTkAMv9/TdAMJr9wygI3xs1shGqh2yAOv5uPqfUOtsSSBYwgl+lkAQQi4J
	 xau1N3tQuibCHSrlQHAq0OkmotDTv7pBIG4VjRN0TqHTBC5LIptxflMAQOP09FXc8/QDe
	 yrn2lu2tUHuiavx0omoCFMxFJWFDua8BBYkzPrf1aLwaCRmVT5QcyS8Lkwydvsi91a3td
	 eJxFLOArpwPnI+HbkIC24WIhgbFp4mBU8D+x1SH/7mrK7K8gUZ6pXZHjGISmJoZb7Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UUPpPFc6/8qA28vq7/UVcf2nu0LhMgqtQtKR7ffwgtk=;
	b=lXsbUYsYHLQtqIk50c4kJLTGNfNuP1nO9iSoE/bfwfp30HDLNVRvFmRl/6rQ9VM3kK6n
	 3P+0iXf0IuYte0y6hgGMMIAzW1QePxjgcbJyFmOct0qmqLkGQdBR4cG3XmhOMoZgFalc1
	 qdeeA0HV+aT8n09pTtx24F2RXpQw/irdeTRzC1aZDpdRk8V/08S18UrnH/Z5hU70ga1NV
	 A4dCPJwrZaakYpu308NPczDipPoiPOqtbY+LufDcxs+28lDGEEqbXVIf8EeH+LDYKDLdU
	 spDCWcMow+MJ4+8kf99gRS8RQMucJnqjBVJyrt3BC8qcAnKWIjjLQ3MU5yXF94yhFFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUB2O0UY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E652606A325;
	Wed, 18 Nov 2026 23:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUB2O0UY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD4B1F000C4;
	Wed, 18 Nov 2026 23:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045258;
	bh=UUPpPFc6/8qA28vq7/UVcf2nu0LhMgqtQtKR7ffwgtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUB2O0UYYdeA0GjvDlHS3Q/kRA91Lfnn36z/9lWrgBNvlseibyJvU2+7I5hXs6S7Z
	 bmfq7c1VdKpbF7iDRx4ywKzTt3w2ZJo9LQASz1pgcYa7WW4KkhzoFBr4jtrooBLz0j
	 kHv6UsT9k4tDHAjun6iGDJ8JIyZj2LfvTXOLbvLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0859/2857] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Wed, 18 Nov 2026 15:31:33 +0100
Message-ID: <20261118150232.492592735@linuxfoundation.org>
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



