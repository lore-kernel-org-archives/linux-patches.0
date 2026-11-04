Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831218;
	b=1em6w0wMyNMFDgE/pycB0kzB2GDkwqPg1LUHuW1WLfKJ9XF1SxyPugnNik2Jm2Ove/cK
	 oyF6kzSg5LpiRYmOxHz4Pa3qw/TSeFuQi9TT4txdtze7UTFsWvGOx639V1XtpPPGreRgY
	 QME4A5001KLdS/4bmcvfVOjNLFxbsdb+SDIhfnr23ZbTXZUgWwwS81mydKlfwcJJTBXrG
	 e3EtyphnAN4rUUC9jbyQnRjJ2oqTueukz42Q2ldZ7TRxNwq7W8H/1Haxc0Xlb/hp0iQfM
	 0l1nCqzp/GLVOtFHBrFAAtn+XDdi6oFrVcVAOFwxTLBxYHwSn1mtIzRhDpwvOx6skvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=opoEokt16Mv485o+iQVcr2jmoFJjJpqbEFVFhtV9ivM=;
	b=i8PV6Cre0Lo5ZTxCD7dnlqj9P8P2zoVZ9okWv4N42VFjfV0k6mAZBP9m9X8OdjQY1Fl7
	 Tjx9tecDDrcHPrFcL2A/un0PVzh5SId5HnvgUcjJBN5U268ldYvPxhhuOOufEiXtGq5gX
	 z5LRHfTYe5OnzTk6xlxj+jR4PtqEQtIexgyP1PfgZ1O1EC+hNg9k6Awkf5ApSiMk93zTJ
	 n+xK6dr9mmolDHxwzinTqIVmi+dyDdJ217IP/jlsKIlphBk9WE+1vaVg6EGeD6A/RTuob
	 3vNYzAdPjhUcxCZ0IvuHzABr9Rs2wrsZ4FaWXEZlHhE8JOl01Hv9stp2bWcYUJ8ScNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkCHvg1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAE1606AB2A;
	Wed,  4 Nov 2026 22:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mkCHvg1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB34D1F000C1;
	Wed,  4 Nov 2026 22:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831218;
	bh=opoEokt16Mv485o+iQVcr2jmoFJjJpqbEFVFhtV9ivM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkCHvg1Pi4i6ws70i8mL69CgWVQ3WKpZzqnvBR8UoFHEpXAvN0pWRMBXr92v+28LS
	 Cxl4YdSny6+9CqRWAGO1NNAsFgPQuynYTMzMiOrLZbu8F5WV2o89rStLBcQhIBLnK0
	 B75Hf065AXP+wIwMo5Ed7yPu4wJlfg0NSXakyNWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0571/1005] s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms
Date: Wed,  4 Nov 2026 16:05:04 -0500
Message-ID: <20261104211059.865002980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 403648373816ae8eb76fe4a393836b0d65fa8f85 ]

All the 4 PAES cipher processing loops were not checking the return
value of skcipher_walk_done() immediately after calling it. This could
lead to error masking when both the walk operation failed and a
subsequent key conversion was needed (k < n condition).

Add immediate error checks after skcipher_walk_done() in all main
processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
properly propagated and not masked by subsequent operations.

With that comes a slight rework around the skcipher_walk_done()
invocation. It is now necessary to check if the walk has already been
finalized (walk->nbytes is then 0) or not to avoid double
de-allocation of resources held by the walk.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/paes_s390.c | 38 +++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index b9cc0c25ba8c3..02bcac750a722 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -428,8 +428,11 @@ static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | req_ctx->modifier, param,
 			     walk->dst.virt.addr, walk->src.virt.addr, n);
-		if (k)
+		if (k) {
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
+		}
 		if (k < n) {
 			if (!maysleep) {
 				rc = -EKEYEXPIRED;
@@ -490,7 +493,7 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -543,7 +546,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = ecb_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -684,6 +687,8 @@ static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
 		if (k) {
 			memcpy(walk->iv, param->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
 		}
 		if (k < n) {
 			if (!maysleep) {
@@ -745,7 +750,7 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -798,7 +803,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = cbc_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -960,6 +965,11 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 				       AES_BLOCK_SIZE);
 			crypto_inc(walk->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc) {
+				if (locked)
+					mutex_unlock(&ctrblk_lock);
+				goto out;
+			}
 		}
 		if (k < n) {
 			if (!maysleep) {
@@ -1053,7 +1063,7 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -1096,7 +1106,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = ctr_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
@@ -1274,8 +1284,11 @@ static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | req_ctx->modifier, param->key + offset,
 			     walk->dst.virt.addr, walk->src.virt.addr, n);
-		if (k)
+		if (k) {
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
+		}
 		if (k < n) {
 			if (!maysleep) {
 				rc = -EKEYEXPIRED;
@@ -1367,8 +1380,11 @@ static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | req_ctx->modifier, param->key + offset,
 			     walk->dst.virt.addr, walk->src.virt.addr, n);
-		if (k)
+		if (k) {
 			rc = skcipher_walk_done(walk, nbytes - k);
+			if (rc)
+				goto out;
+		}
 		if (k < n) {
 			if (!maysleep) {
 				rc = -EKEYEXPIRED;
@@ -1474,7 +1490,7 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 			atomic_dec(&ctx->via_engine_ctr);
 	}
 
-	if (rc != -EINPROGRESS)
+	if (rc != -EINPROGRESS && walk->nbytes)
 		skcipher_walk_done(walk, rc);
 
 out:
@@ -1527,7 +1543,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 	rc = xts_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
 		return pkey_handle_expired();
-	} else if (rc) {
+	} else if (rc && walk->nbytes) {
 		skcipher_walk_done(walk, rc);
 	}
 
-- 
2.53.0



