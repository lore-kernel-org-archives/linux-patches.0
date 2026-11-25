Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623214;
	b=ZSdI9n8ZJ/XRvIV5HLM2p7qygP4nHfwOE/WpL5TCBH9iBpeFW7duq9OnkqkQVB8hyEvp
	 e/9zmrxuhdyh6I/Nn6sKXig0AY+zslk2JTYjc+iNCg6VfDLykHzDkqavhbInbGcQ7913M
	 PtBFsA7XjWr6IiWeHXUGiG7ZpUUjqE2SkgHxxHX6zFEf7yWyka/Qg5sDdwNAPUUCWyphD
	 JXdd8Ft1ZUZZ79lPaMMcJPz+9YFXBzvSbqsfIE1Sb2IsVZ4aXB/fUlpd4TSkUrdYh4WPW
	 C/TF2Brs+8AoHroHqEef3D9PlAL26oi1ktj1TFbmacWdh6/IOI6Vt6JPhLXYf5+zQcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8rlacibFq9JfzO/qP6EtpSyoPAlQGSGOkaIe0pjp7/o=;
	b=lOI1ttOhfiugo6+aCNz4SN/dgA228WtcHVNy/QMBbvjFqWakopwUFqqvJWms1sbYI1Xx
	 n2R0u5c9Kt6OkKiSERAR7UVqWRbpjydS75J12dK79lqN+7B/wAlj0K7pd1ph2VvlDYdjv
	 308sEQy4RZcCzY5ZgbLRN5BCEWfl9VqMaNkbzi0BskkSc8gxrJvXxIWSx5zKPH3OC5tIJ
	 DbRkVIkzUxezApbyzAR4cyKTxNtZRbXPH/XcAw2Na3IkE14YAOmBcPvnEK8cmSKh9xH34
	 SWY5XrUoKw0GL96pJrqn3zvUjl8bMl0GSgRbBaD26n8dvmqkHMqw4HV+on5kO2AnWyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxJgDwwJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BC0606A31E;
	Wed, 25 Nov 2026 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JxJgDwwJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C411F000C0;
	Wed, 25 Nov 2026 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623214;
	bh=8rlacibFq9JfzO/qP6EtpSyoPAlQGSGOkaIe0pjp7/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxJgDwwJXcqWD103ULjaJrLMl18TNIw6vxFeAOvxA4VEdcGq2X1f2S1F8Y3X1XkbJ
	 glsL/N8+C06kwsz4HS3dUb5x411SGqqxTkduQgbPgrnXC6cS+Lkq527SlVUMy3SM5Y
	 1N18WvkMH6xlcJNOhkwJuc++V80Q3/SCFyTYzTIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 742/990] crypto: caam - reject overlong RSA CRT parameters
Date: Wed, 25 Nov 2026 15:35:09 +0100
Message-ID: <20261125143839.444986745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 828c3b265b6df877dced3dde56ea41daa2e6181e upstream.

caam_read_rsa_crt() right-aligns dP, dQ, and qInv in buffers sized
from the corresponding prime. rsa_parse_priv_key() only bounds these
integers against n, so a malformed key can provide, for example, a
two-byte dP with a one-byte p. dstlen - nbytes then underflows and
memcpy() writes outside the allocation during set_priv_key(). KASAN
reports a slab-out-of-bounds write in caam_read_rsa_crt().

Reject empty or overlong CRT parameters after stripping leading zeros.
qInv is consumed by CAAM as a p-sized value, so size it from p rather
than q to match the DMA mapping in set_rsa_priv_f3_pdb(). Let the
top-level key cleanup handle partial form-3 allocations and return the
specific error to the caller.

Also test nbytes before dereferencing it while stripping zeros, so an
all-zero integer does not read one byte beyond its input.

Fixes: 4a651b122adb ("crypto: caam - add support for RSA key form 3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Sahil Malhotra <sahil.malhotra@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/caam/caampkc.c |   79 +++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 47 deletions(-)

--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -880,7 +880,7 @@ static void caam_rsa_free_key(struct caa
 
 static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
 {
-	while (!**ptr && *nbytes) {
+	while (*nbytes && !**ptr) {
 		(*ptr)++;
 		(*nbytes)--;
 	}
@@ -896,22 +896,22 @@ static void caam_rsa_drop_leading_zeros(
  * @ptr   : pointer to {dP, dQ, qInv} CRT member
  * @nbytes: length in bytes of {dP, dQ, qInv} CRT member
  * @dstlen: length in bytes of corresponding p or q prime factor
+ * @dst   : pointer to the zero-padded output buffer
  */
-static u8 *caam_read_rsa_crt(const u8 *ptr, size_t nbytes, size_t dstlen)
+static int caam_read_rsa_crt(const u8 *ptr, size_t nbytes, size_t dstlen,
+			     u8 **dst)
 {
-	u8 *dst;
-
 	caam_rsa_drop_leading_zeros(&ptr, &nbytes);
-	if (!nbytes)
-		return NULL;
+	if (!nbytes || nbytes > dstlen)
+		return -EINVAL;
 
-	dst = kzalloc(dstlen, GFP_KERNEL);
-	if (!dst)
-		return NULL;
+	*dst = kzalloc(dstlen, GFP_KERNEL);
+	if (!*dst)
+		return -ENOMEM;
 
-	memcpy(dst + (dstlen - nbytes), ptr, nbytes);
+	memcpy(*dst + (dstlen - nbytes), ptr, nbytes);
 
-	return dst;
+	return 0;
 }
 
 /**
@@ -991,6 +991,7 @@ static int caam_rsa_set_priv_key_form(st
 	size_t p_sz = raw_key->p_sz;
 	size_t q_sz = raw_key->q_sz;
 	unsigned aligned_size;
+	int ret;
 
 	rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
 	if (!rsa_key->p)
@@ -999,57 +1000,39 @@ static int caam_rsa_set_priv_key_form(st
 
 	rsa_key->q = caam_read_raw_data(raw_key->q, &q_sz);
 	if (!rsa_key->q)
-		goto free_p;
+		return -ENOMEM;
 	rsa_key->q_sz = q_sz;
 
 	aligned_size = ALIGN(raw_key->p_sz, dma_get_cache_alignment());
 	rsa_key->tmp1 = kzalloc(aligned_size, GFP_KERNEL);
 	if (!rsa_key->tmp1)
-		goto free_q;
+		return -ENOMEM;
 
 	aligned_size = ALIGN(raw_key->q_sz, dma_get_cache_alignment());
 	rsa_key->tmp2 = kzalloc(aligned_size, GFP_KERNEL);
 	if (!rsa_key->tmp2)
-		goto free_tmp1;
+		return -ENOMEM;
 
 	rsa_key->priv_form = FORM2;
 
-	rsa_key->dp = caam_read_rsa_crt(raw_key->dp, raw_key->dp_sz, p_sz);
-	if (!rsa_key->dp)
-		goto free_tmp2;
-
-	rsa_key->dq = caam_read_rsa_crt(raw_key->dq, raw_key->dq_sz, q_sz);
-	if (!rsa_key->dq)
-		goto free_dp;
-
-	rsa_key->qinv = caam_read_rsa_crt(raw_key->qinv, raw_key->qinv_sz,
-					  q_sz);
-	if (!rsa_key->qinv)
-		goto free_dq;
+	ret = caam_read_rsa_crt(raw_key->dp, raw_key->dp_sz, p_sz,
+				&rsa_key->dp);
+	if (ret)
+		return ret;
+
+	ret = caam_read_rsa_crt(raw_key->dq, raw_key->dq_sz, q_sz,
+				&rsa_key->dq);
+	if (ret)
+		return ret;
+
+	ret = caam_read_rsa_crt(raw_key->qinv, raw_key->qinv_sz, p_sz,
+				&rsa_key->qinv);
+	if (ret)
+		return ret;
 
 	rsa_key->priv_form = FORM3;
 
 	return 0;
-
-free_dq:
-	kfree_sensitive(rsa_key->dq);
-	rsa_key->dq = NULL;
-free_dp:
-	kfree_sensitive(rsa_key->dp);
-	rsa_key->dp = NULL;
-free_tmp2:
-	kfree_sensitive(rsa_key->tmp2);
-	rsa_key->tmp2 = NULL;
-free_tmp1:
-	kfree_sensitive(rsa_key->tmp1);
-	rsa_key->tmp1 = NULL;
-free_q:
-	kfree_sensitive(rsa_key->q);
-	rsa_key->q = NULL;
-free_p:
-	kfree_sensitive(rsa_key->p);
-	rsa_key->p = NULL;
-	return -ENOMEM;
 }
 
 static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
@@ -1067,6 +1050,8 @@ static int caam_rsa_set_priv_key(struct
 	if (ret)
 		return ret;
 
+	ret = -ENOMEM;
+
 	/* Copy key in DMA zone */
 	rsa_key->d = kmemdup(raw_key.d, raw_key.d_sz, GFP_KERNEL);
 	if (!rsa_key->d)
@@ -1103,7 +1088,7 @@ static int caam_rsa_set_priv_key(struct
 
 err:
 	caam_rsa_free_key(rsa_key);
-	return -ENOMEM;
+	return ret;
 }
 
 static unsigned int caam_rsa_max_size(struct crypto_akcipher *tfm)


