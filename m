Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034683;
	b=HOngVnf7OZlGDRo1Odz6ZIlDFWw3TU5m7O4NNjQ18hTHeQYxiHLjILcfLQYu5K/Mvnvy
	 +bwSbXXX97K3HKB1pAbrIgbjFQ4Mh+RMbO2HbtW5rBlR7u1tfBLF2sl1YtyXqKVdBzwGe
	 AS4bUHAxev/pudf5ye9NgxQDxttiAI181Of+s6KcpLd8i+RQU0bo5hh2lQBxbbed2h/hW
	 VfE8o4XrOkcDMFvNDBXREVG/I8rSJ+KljO6zm6spve9sIFVXqiyPKYs5pCcSHgQCIMZQ+
	 Fv8tCPyU9kzA2/1m+Wge3oEfw9QB4l8DxNN+HLMWo4BcT33wu49cdSYF6x0Hb/mAR4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lusGIjVRehRwygz/tRMUZifyQBLGl9L+OcsFRGWzHT0=;
	b=dyCDaysfJmvZImaNDFcetYdrO6kUrFiMsxrIMjDL5sf+rBCNVfL9ZdahVswWJigBHRol
	 35T2DDqGl5Kl5bANTRo4l87UGUj0VdlbqWadlkj+XekjS1YLrUZgBm7s8owFd1bNQ9t6s
	 r0banJsZqM4ofHODan71YPDsKD4+VDZXVA58qt8L0blhRKlshtxHof/wOESYm6JaG4QkO
	 kPWWO8BMGjTRW6shWjcTJxgfVQ3+SEuDtHZvCY8nghWTofm5NEcPGlRIdNL+mO/c5zHpD
	 89s+E20vMt0rjylE3U2bsshcFhu468ChsSSVZOyM9srdtyLUMkdK8lHgTpti6yT30JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wi8VXzi7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136D6606A31C;
	Wed, 18 Nov 2026 20:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wi8VXzi7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF681F000C4;
	Wed, 18 Nov 2026 20:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034682;
	bh=lusGIjVRehRwygz/tRMUZifyQBLGl9L+OcsFRGWzHT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wi8VXzi7oPC6dlMSgqfFtIx10T5HcLOMaBN2OTzHoJLIKmfjZrB/Z0Z30E7Fbhl8M
	 OBJgHpia/AfWXVWK01Bl4+n1dQ5rXGnt/sJeDbAZVkCnTiK+C2HCd0FUxUA4etxz4R
	 d7iVM8rurH25Xkvv+gB/YkNzuSSDcqwQpzwCWOsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0456/3318] s390/crypto: Fix use of mutex in atomic context
Date: Wed, 18 Nov 2026 15:17:58 +0100
Message-ID: <20261118150330.481767087@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit d1c44a7d085473173bb360b7218a43699c3f56c7 ]

The AES CTR implementation used a mutex to lock one page of exclusive
memory for fast CTR processing. Unfortunately a mutex is not save to
use in atomic or interrupt context. So use a binary semaphore instead
which is save to use in such environments.

Furthermore rework the code to get rid of conditional locking. So
restructure the AES CRT code by extracting the main loop into a
separate function and just give in information about the (locked) page
can be used or not (is not locked).

Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 63 +++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index aaf0afff80900..07b35da7943f3 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -28,14 +28,14 @@
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/init.h>
-#include <linux/mutex.h>
 #include <linux/fips.h>
+#include <linux/semaphore.h>
 #include <linux/string.h>
 #include <crypto/xts.h>
 #include <asm/cpacf.h>
 
 static u8 *ctrblk;
-static DEFINE_MUTEX(ctrblk_lock);
+static DEFINE_SEMAPHORE(ctrblk_sem, 1);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions,
 		    kma_functions;
@@ -562,46 +562,61 @@ static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
 	return n;
 }
 
+static int __ctr_aes_crypt(struct s390_aes_ctx *sctx,
+			   struct skcipher_walk *walk, bool locked)
+{
+	unsigned int n, nbytes;
+	int ret = 0;
+	u8 *ctrptr;
+
+	while (!ret && ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE)) {
+		n = AES_BLOCK_SIZE;
+		if (nbytes >= 2 * AES_BLOCK_SIZE && locked)
+			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
+		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
+		cpacf_kmctr(sctx->fc, sctx->key, walk->dst.virt.addr,
+			    walk->src.virt.addr, n, ctrptr);
+		if (ctrptr == ctrblk)
+			memcpy(walk->iv, ctrptr + n - AES_BLOCK_SIZE,
+			       AES_BLOCK_SIZE);
+		crypto_inc(walk->iv, AES_BLOCK_SIZE);
+		ret = skcipher_walk_done(walk, nbytes - n);
+	}
+
+	return ret;
+}
+
 static int ctr_aes_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct s390_aes_ctx *sctx = crypto_skcipher_ctx(tfm);
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	struct skcipher_walk walk;
-	unsigned int n, nbytes;
-	int ret, locked;
+	u8 buf[AES_BLOCK_SIZE];
+	int ret;
 
 	if (unlikely(!sctx->fc))
 		return fallback_skcipher_crypt(sctx, req, 0);
 
-	locked = mutex_trylock(&ctrblk_lock);
-
 	ret = skcipher_walk_virt(&walk, req, false);
-	while (!ret && ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE)) {
-		n = AES_BLOCK_SIZE;
+	if (ret)
+		return ret;
 
-		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
-		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
-		cpacf_kmctr(sctx->fc, sctx->key, walk.dst.virt.addr,
-			    walk.src.virt.addr, n, ctrptr);
-		if (ctrptr == ctrblk)
-			memcpy(walk.iv, ctrptr + n - AES_BLOCK_SIZE,
-			       AES_BLOCK_SIZE);
-		crypto_inc(walk.iv, AES_BLOCK_SIZE);
-		ret = skcipher_walk_done(&walk, nbytes - n);
+	if (down_trylock(&ctrblk_sem) == 0) {
+		ret = __ctr_aes_crypt(sctx, &walk, true);
+		up(&ctrblk_sem);
+	} else {
+		ret = __ctr_aes_crypt(sctx, &walk, false);
 	}
-	if (locked)
-		mutex_unlock(&ctrblk_lock);
+
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
-	if (!ret && nbytes) {
+	if (!ret && walk.nbytes > 0) {
 		memset(buf, 0, AES_BLOCK_SIZE);
-		memcpy(buf, walk.src.virt.addr, nbytes);
+		memcpy(buf, walk.src.virt.addr, walk.nbytes);
 		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
 			    AES_BLOCK_SIZE, walk.iv);
-		memcpy(walk.dst.virt.addr, buf, nbytes);
+		memcpy(walk.dst.virt.addr, buf, walk.nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
 		memzero_explicit(buf, sizeof(buf));
-- 
2.53.0



