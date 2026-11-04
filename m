Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831216;
	b=5mL5PUTXl3E2sEuFKb/w6S7V35K777awZYjuJPKoaPA93vtr5anrIaC5skXS6jrbyy3k
	 5VnPyKy7SucQZsJg1PmiM21un1fYVelL0njWmMZiDmsKhvMM1tkA8BMzgx01wfaYvHL0S
	 QMNtEZ4801yfuc7TM4FZINYutxERlwYJooCDLxMw2R0vDFcNJEb544zXP/YkPvbZjY7EY
	 pvNIG+zWjfw9qOvzmtnDgxKiWVaVuXOb32eUmhI/HsVunMRTIqbWA/B7bHBQ7yI33I95J
	 uBoqIFipjjscxawx6tifTj7iSXm1jhkXfByq1tYrncaswjKSfKU7Bb/Qo6Jljy1iGEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0dE8TJUjsFZ/zl1mZRX+SuDVUBb6neL0h2LNXOAUKTQ=;
	b=FXuEyPxusLxgu3D8IRT6m3AT6OZ5v3TghBxl2/P44fy+XB3Cz8qqQJvV/NbVYTM2lT5T
	 R7RdBUVjnZw4/jTiEv4SmPLQCbbLjVUfyhrUHcdkZgaNarlmQ3ruaC+k4jsDUoZElebLG
	 To/lIXHhYhMlHkxNgQWNh7yjo3feDhA4TjcLvJ78nmAXqGRHW6Hf4hxd9mVaIy0hj2/F+
	 OtDFf7ydvtGbLMbJjS7o4x78tC098/FkZsdALwbIy//YB8vnxirvwDb9oJNhxwlZ1Jxko
	 15kOVzyq0xrdsxLddMGV+X5YateSEaT2lMP1xrh+W5S07T2LtoAhbjh6iZUGrhEClQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfIFdl2T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF74606AB1D;
	Wed,  4 Nov 2026 22:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfIFdl2T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272131F000C1;
	Wed,  4 Nov 2026 22:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831216;
	bh=0dE8TJUjsFZ/zl1mZRX+SuDVUBb6neL0h2LNXOAUKTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfIFdl2Ti99Ko6wjVgI6PpF9fZvewlDPna0b6xyHxpR2IjfCmjILg7KaMsAF39TsU
	 /Te+lsstLJHGpImTUy6V1kFoM6+ciLK66eLFdwnAd+d3jlkfQy2bY/gkGzuJ219tIc
	 HyHMmUBDK4qK4pC6tEfqFOBG6E+KdsZpT+OCwjWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0570/1005] s390/crypto: Replace cond_resched() with msleep(1)
Date: Wed,  4 Nov 2026 16:05:03 -0500
Message-ID: <20261104211059.839682272@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e11733826f9779eb954abdcd2b60b273558f1a77 ]

With [1] cond_resched() is always compiled away and becomes a no-op.

The comments for all cond_resched() calls in crypto code however indicate
that the current process should be scheduled away to avoid instant
re-invocation of a callback. This is not what cond_resched() would do or
did.

Instead of just removing the cond_resched() calls, replace them with
msleep() calls, as suggested by Holger Dengler. This forces the current
task to be scheduled away (sleeps) like originally intended.

Holger provided information why this intended [2]:
"
Let me give a bit of background here: The protected key can only get
invalid, if the Linux instance (z/VM or KVM guest) is moved to another
hypervisor on a different machine (aka life guest relocation). In such a
case, the crypto accelerator card and the host has to exchange the "real
key", which is wrapped by the host and handed back to the guest as the
re-newed protected key. Unfortunately there is no asynchronous trigger
on completion, you have to re-try (and maybe get another "in progress"
return).

And as if that weren't bad enough, if this key exchange between card and
host is the first one, card and host has to instantiate a secure
communication channel (including a key exchange for the transport layer).
"

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
[2] https://lore.kernel.org/all/39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com/
[3] https://lore.kernel.org/all/20260731084027.GE776954@noisy.programming.kicks-ass.net/

[hca@linux.ibm.com: took Peter's patch [3] and provided commit message]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 403648373816 ("s390/crypto: Fix return code handling at skcipher_walk_done in PAES algorithms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/paes_s390.c  | 44 ++++-------------------------------
 arch/s390/crypto/phmac_s390.c | 25 +++-----------------
 arch/s390/include/asm/pkey.h  | 16 +++++++++++++
 3 files changed, 23 insertions(+), 62 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 15ac83e521615..b9cc0c25ba8c3 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -542,16 +542,7 @@ static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = ecb_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -806,16 +797,7 @@ static int cbc_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = cbc_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -1113,16 +1095,7 @@ static int ctr_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = ctr_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
@@ -1553,16 +1526,7 @@ static int xts_paes_do_one_request(struct crypto_engine *engine, void *areq)
 
 	rc = xts_paes_do_crypt(ctx, req_ctx, true);
 	if (rc == -EKEYEXPIRED) {
-		/*
-		 * Protected key expired, conversion is in process.
-		 * Trigger a re-schedule of this request by returning
-		 * -ENOSPC ("hardware queue is full") to the crypto engine.
-		 * To avoid immediately re-invocation of this callback,
-		 * tell the scheduler to voluntarily give up the CPU here.
-		 */
-		cond_resched();
-		pr_debug("rescheduling request\n");
-		return -ENOSPC;
+		return pkey_handle_expired();
 	} else if (rc) {
 		skcipher_walk_done(walk, rc);
 	}
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
index ecb1af4b82105..68ef96e0d4449 100644
--- a/arch/s390/crypto/phmac_s390.c
+++ b/arch/s390/crypto/phmac_s390.c
@@ -893,16 +893,7 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 	case OP_FINUP:
 		rc = phmac_kmac_update(req, true);
 		if (rc == -EKEYEXPIRED) {
-			/*
-			 * Protected key expired, conversion is in process.
-			 * Trigger a re-schedule of this request by returning
-			 * -ENOSPC ("hardware queue full") to the crypto engine.
-			 * To avoid immediately re-invocation of this callback,
-			 * tell scheduler to voluntarily give up the CPU here.
-			 */
-			pr_debug("rescheduling request\n");
-			cond_resched();
-			return -ENOSPC;
+			return pkey_handle_expired();
 		} else if (rc) {
 			hwh_advance(hwh, rc);
 			goto out;
@@ -913,18 +904,8 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
 		fallthrough;
 	case OP_FINAL:
 		rc = phmac_kmac_final(req, true);
-		if (rc == -EKEYEXPIRED) {
-			/*
-			 * Protected key expired, conversion is in process.
-			 * Trigger a re-schedule of this request by returning
-			 * -ENOSPC ("hardware queue full") to the crypto engine.
-			 * To avoid immediately re-invocation of this callback,
-			 * tell scheduler to voluntarily give up the CPU here.
-			 */
-			pr_debug("rescheduling request\n");
-			cond_resched();
-			return -ENOSPC;
-		}
+		if (rc == -EKEYEXPIRED)
+			return pkey_handle_expired();
 		break;
 	default:
 		/* unknown/unsupported/unimplemented asynch op */
diff --git a/arch/s390/include/asm/pkey.h b/arch/s390/include/asm/pkey.h
index b7b59faf16f49..3f47d496496fa 100644
--- a/arch/s390/include/asm/pkey.h
+++ b/arch/s390/include/asm/pkey.h
@@ -13,6 +13,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 #include <uapi/asm/pkey.h>
 
 /*
@@ -38,4 +39,19 @@ int pkey_key2protkey(const u8 *key, u32 keylen,
  */
 #define PKEY_XFLAG_NOMEMALLOC 0x0001
 
+static inline int pkey_handle_expired(void)
+{
+	/*
+	 * Protected key expired due to relocation to another host. The long
+	 * running re-wrap has no asynchronous completion notification, so
+	 * polling is required. Trigger a re-schedule of this request by
+	 * returning -ENOSPC ("hardware queue full") to the crypto engine.
+	 * To avoid immediately re-invocation of this callback,
+	 * tell the scheduler to voluntarily give up the CPU here.
+	 */
+	msleep(1);
+	pr_debug("rescheduling request\n");
+	return -ENOSPC;
+}
+
 #endif /* _KAPI_PKEY_H */
-- 
2.53.0



