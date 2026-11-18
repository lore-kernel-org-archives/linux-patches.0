Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058368;
	b=wYyxqDnwPB3Mkhh8RIjK4UJNeYXdFbbpsT6JjY0nBzOh9fOhKo+VLBNWeMIiLGJKUksa
	 qlbqfESvC5QEwdoUSYTU/ejOYcXqUgGf8CLb3IN/xP37J7sMMkPJ1/d5OZ6NFUuXvZn4l
	 DQm5HY+s053S+REwIyYQlAlWJr65ex6jameMM9rTe68ChLXU6j/qIJyPkLSMZSTUsRTNX
	 VGeOegtGjGR9LNTH/hS8Npaqs77Ibg2+9PQlNxDpGRvqsXsqSIyuDlyATClKyvKCaj8uw
	 rfNYPl3ozkkLzk2/JQYwW8qeSAQKSCnmjMiw6WyTS70AuppBDucwGHDlW7Bo5SPtSOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSdPfWTGdMIj0y1cJonjTXyA1hA85+//iVhjGKhvQUU=;
	b=Lh4NItDdcosRmKvO3glWuOUcOBsrytksPLlZrYzuMjhXc0yFA9aQ8B737huln4TNcg8l
	 TO/7k+uPTIvH69PtYn8+SVBu3uQsUP8BTWnSEmEiY8s9dkyUPDWN6kStvAmUaBMhaWImI
	 q/+5xqZZ9ZlXb7A9jpMKU9c4ruDt5XS7Sj5kAZaLCtnrV+CDOgwrOXSDqZr2Ho1UQXagP
	 ArUqW1777qkzBCDN1i8gryQD5Anul2bk3gxRuFetlagQkG0+nN5lDXwm+ooRCfyZKpKs5
	 jzKnoZYKW1OzGUYQwKorXStjGDEwGfRbFNG3NXPx7w/6DhwGOHRX4y0jKFbNxtJeImg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+EB+p8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8D6606A31C;
	Thu, 19 Nov 2026 03:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+EB+p8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF0B1F000C4;
	Thu, 19 Nov 2026 03:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058367;
	bh=PSdPfWTGdMIj0y1cJonjTXyA1hA85+//iVhjGKhvQUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+EB+p8CxFqYewsaLCBuUlgLp5O4GbeVT6R2YdMBdcDmypo8PJLuzRtt21D6qPxfb
	 YWFU9hH44+/E6O93hkudTiz8bDDRX9s4sIWioIC9ayHwSEH7r9JizFYrAivRgILWJI
	 qNyYBwaaL2uvKufCbx66Ct+iYM45UEwSx57eszFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0460/1848] crypto: caam - fix double-free in caam_rsa_set_priv_key_form()
Date: Wed, 18 Nov 2026 15:41:38 +0100
Message-ID: <20261118145933.692454250@linuxfoundation.org>
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
index c3c47756f25fe..b4af79d73ba54 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -1021,16 +1021,22 @@ static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
 
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



