Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831220;
	b=uN2eWIU+ygDIMPhw6LxYnUXg55iuztG75FXevXv8+ovhxX3+sWMx/P9LFzDFvDT6VgFu
	 GsTUHw4pCPSDyP8LM77Gafiyr6q50sopw0zU3hBP5xIsQJNjBPT4Oi/3pyEnFh8pp0H/l
	 NBiB72yC5cLgyUSY4Py67r4bs1HQ5Sk6ZMVjr46JB0eIbnUpRsXqYCjbVlkzZPbVRP3KU
	 YR+pZNPNeRVOlZOf2fh7N+Irfmgn/U+B/mamJczlu6ipALcR/dnMPVhdAhM+7e8VFycZY
	 CE3gg4V1VkrvdCKbzm1rAvYKGfYM3mntl11153hXPpbgIy41/yacbC6gNFLsPH+yn/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zB6ohieiYv9zJ26vKWnUxs3PCSoiA1/G/I8XOsnhqt0=;
	b=cJfMflrs1ejAqRCjAcVQpRUPcJQagkzzOBoEPU7HI4xo2IRkk6GNkdXRHbnwaQbzKTq8
	 Nqe/PXM4LOZ26vsIuSfCmwumoOzAmj4EQfK5bxhakKLQB8uqCjJ8J500xxCdg02kvwumH
	 iJDbuMAbbUGwYto1uSu9Qlqik/9J7se1oW8SiJ/1ablH+rIl46Ss2Wo3pav3BUduQJWin
	 Pv1RsbnN5vBxskOfjQ1vjidQtLtFvO3bIpJLIzrykztZYj/cDk5bQpyn9G6MEJ8jOhNvJ
	 LrbBKFmJTmK0X3BOu91qNGn2nzukNzGGXdH5792/maZhnYpa+OAn6AH1WJUV1cd5K4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKEkVltA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5248606AB30;
	Wed,  4 Nov 2026 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKEkVltA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424221F000C1;
	Wed,  4 Nov 2026 22:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831219;
	bh=zB6ohieiYv9zJ26vKWnUxs3PCSoiA1/G/I8XOsnhqt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKEkVltAWmPXK1bxBXIm83/SdSQPTD5Fh0ZuXjaLE7zyC89O6cyQ8CKW/y6GFRDKq
	 SCcejvxRrM+qMzL9KzSSfacy5F+FwbbUY+QvDXs7jHGDi1RRtwXQUXTtEgz3QGV/Gc
	 4FoXscRAZIUt0BWxEfQQPw6h3VhDrGuBgb7cF964=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0572/1005] s390/crypto: Fix use of mutex in atomic context in PAES
Date: Wed,  4 Nov 2026 16:05:05 -0500
Message-ID: <20261104211059.893671742@linuxfoundation.org>
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

[ Upstream commit 749990db95d45cc3d96aab999ac7f110259b200c ]

The PAES CTR implementation used a mutex to lock one page of exclusive
memory for fast CTR processing. Unfortunately a mutex is not save to
use in atomic or interrupt context. So use a binary semaphore instead
which is save to use in such environments.

Furthermore rework the code to get rid of conditional locking. So
restructure the PAES CRT code by extracting the main loop into a
separate function and just give in information about the (locked) page
can be used or not (is not locked).

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[ sashal: Dropped the tested parameter from __ctr_paes_do_crypt(), its callers and the paes_convert_key() calls, since this tree's API lacks it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/paes_s390.c | 107 +++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 50 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 02bcac750a722..5198a99ec30ef 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -20,7 +20,7 @@
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
+#include <linux/semaphore.h>
 #include <linux/spinlock.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
@@ -42,7 +42,7 @@
 #define PXTS_256_PROTKEY_SIZE	(32 + 32 + 32)	/* k1 + k2 + verification pattern */
 
 static u8 *ctrblk;
-static DEFINE_MUTEX(ctrblk_lock);
+static DEFINE_SEMAPHORE(ctrblk_sem, 1);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
 
@@ -911,41 +911,14 @@ static inline unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes
 	return n;
 }
 
-static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
-			     struct s390_pctr_req_ctx *req_ctx,
-			     bool maysleep)
+static int __ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
+			       struct ctr_param *param,
+			       struct skcipher_walk *walk,
+			       bool maysleep, bool locked)
 {
-	struct ctr_param *param = &req_ctx->param;
-	struct skcipher_walk *walk = &req_ctx->walk;
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
 	unsigned int nbytes, n, k;
-	int pk_state, locked, rc = 0;
-
-	if (!req_ctx->param_init_done) {
-		/* fetch and check protected key state */
-		spin_lock_bh(&ctx->pk_lock);
-		pk_state = ctx->pk_state;
-		switch (pk_state) {
-		case PK_STATE_NO_KEY:
-			rc = -ENOKEY;
-			break;
-		case PK_STATE_CONVERT_IN_PROGRESS:
-			rc = -EKEYEXPIRED;
-			break;
-		case PK_STATE_VALID:
-			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
-			req_ctx->param_init_done = true;
-			break;
-		default:
-			rc = pk_state < 0 ? pk_state : -EIO;
-			break;
-		}
-		spin_unlock_bh(&ctx->pk_lock);
-	}
-	if (rc)
-		goto out;
-
-	locked = mutex_trylock(&ctrblk_lock);
+	u8 *ctrptr;
+	int rc = 0;
 
 	/*
 	 * Note that in case of partial processing or failure the walk
@@ -965,37 +938,71 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 				       AES_BLOCK_SIZE);
 			crypto_inc(walk->iv, AES_BLOCK_SIZE);
 			rc = skcipher_walk_done(walk, nbytes - k);
-			if (rc) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
+			if (rc)
 				goto out;
-			}
 		}
 		if (k < n) {
 			if (!maysleep) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
 				rc = -EKEYEXPIRED;
 				goto out;
 			}
 			rc = paes_convert_key(ctx);
-			if (rc) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
+			if (rc)
 				goto out;
-			}
 			spin_lock_bh(&ctx->pk_lock);
 			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
 			spin_unlock_bh(&ctx->pk_lock);
 		}
 	}
-	if (locked)
-		mutex_unlock(&ctrblk_lock);
+
+out:
+	return rc;
+}
+
+static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
+			     struct s390_pctr_req_ctx *req_ctx,
+			     bool maysleep)
+{
+	struct ctr_param *param = &req_ctx->param;
+	struct skcipher_walk *walk = &req_ctx->walk;
+	u8 buf[AES_BLOCK_SIZE];
+	int pk_state, rc = 0;
+
+	if (!req_ctx->param_init_done) {
+		/* fetch and check protected key state */
+		spin_lock_bh(&ctx->pk_lock);
+		pk_state = ctx->pk_state;
+		switch (pk_state) {
+		case PK_STATE_NO_KEY:
+			rc = -ENOKEY;
+			break;
+		case PK_STATE_CONVERT_IN_PROGRESS:
+			rc = -EKEYEXPIRED;
+			break;
+		case PK_STATE_VALID:
+			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
+			req_ctx->param_init_done = true;
+			break;
+		default:
+			rc = pk_state < 0 ? pk_state : -EIO;
+			break;
+		}
+		spin_unlock_bh(&ctx->pk_lock);
+	}
+	if (rc)
+		goto out;
+
+	if (down_trylock(&ctrblk_sem) == 0) {
+		rc = __ctr_paes_do_crypt(ctx, param, walk, maysleep, true);
+		up(&ctrblk_sem);
+	} else {
+		rc = __ctr_paes_do_crypt(ctx, param, walk, maysleep, false);
+	}
 
 	/* final block may be < AES_BLOCK_SIZE, copy only nbytes */
-	if (nbytes) {
+	if (!rc && walk->nbytes > 0) {
 		memset(buf, 0, AES_BLOCK_SIZE);
-		memcpy(buf, walk->src.virt.addr, nbytes);
+		memcpy(buf, walk->src.virt.addr, walk->nbytes);
 		while (1) {
 			if (cpacf_kmctr(ctx->fc, param, buf,
 					buf, AES_BLOCK_SIZE,
@@ -1012,7 +1019,7 @@ static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
 			memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
 			spin_unlock_bh(&ctx->pk_lock);
 		}
-		memcpy(walk->dst.virt.addr, buf, nbytes);
+		memcpy(walk->dst.virt.addr, buf, walk->nbytes);
 		crypto_inc(walk->iv, AES_BLOCK_SIZE);
 		rc = skcipher_walk_done(walk, 0);
 	}
-- 
2.53.0



