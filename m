Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210213;
	b=w0uPmwWP0A/ZoVJnH6/vdzJFZU58CFKtpGLyPb44mxhVd77Ne4PBpP90+XVvmuySxsso
	 4qbYtagUHGUL2WOzCTOKnds++SxjR9j2YzAstJAAaaKXBZZNsZ5YdEKxl3dLCFh7SVKzZ
	 sBuTFmc4S7xP73uxfFsKsdraMcKmABCXKYUriZSaQdAZDuYsGLNDv7w6vzyilogxSttH1
	 vlaAGB9lhyxDXEtjapc5dPLgD1gNBAljaxrGmAV0qMDw1qPDobB8Rsk43xDgEaXg2VKNu
	 kDIylycPj6HbdWaAjKFPmuiPWg3lHGju+Mf0O473t2MP3zbamWVqXzu/2ywaVCGdLAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=x+w/vPf5IiVzZwfQVLdRrXo3t23ZGGEzhPHo1o+Yx44=;
	b=TLApnRUgAVQ4naN9XnZ8UpR51FaZJdZRulYfZpi4od6U6VPdkuskfDZxnxy8/yrXQskc
	 +/B1mz/wa4C0Q4hGghGRyofzxx789MLE6oxwoMVh9/WqeOLLsZqaCD7fJzFUwkqved/VE
	 Ma1dZLMHp3NxLgLWEwUV2uPvMhQm+CPtR5dUDnVM9n0eTVN6ij/tW+fqnkMdQInMkg6Wj
	 KDTYo9Pt1JGY1btA3WkUU+ESpGPIx9HOcKpEC2Hpbd6B40BhSXtHiZPvTHIth6CNxNshz
	 CLGJn5FQFI0/1zCQo5Yy5KqyzT2L0XS3+BZWRB9IMeFdE8FaQKgU6Cc1zrxGBeJmQzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=weY0wCyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B2E606A31A;
	Wed, 28 Oct 2026 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=weY0wCyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4163B1F01825;
	Wed, 28 Oct 2026 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210212;
	bh=x+w/vPf5IiVzZwfQVLdRrXo3t23ZGGEzhPHo1o+Yx44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weY0wCyUEbsmOav0atlKTsLOVbobpnNIqSsEUBLgBtHhPha21AHlah+flw1kQ74gd
	 v7uVrPjNBRfllolMKKj0MLt/lITqsT3V2olTx+9EqsmIeGEftmun0PBbIOWVyE4oO8
	 Ip6c5RNMG2YGfe7IHHKK1iQiuhJS7Xxsp4FVP+1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/168] drm/exec: dont immediately add prelocked obj to array of locked objs
Date: Wed, 28 Oct 2026 18:00:35 +0100
Message-ID: <20261028165945.430147101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <ckoenig.leichtzumerken@gmail.com>

[ Upstream commit 26401a4999f1596a515b2e704e7066ac09306488 ]

When a contention is detected the drm_exec object grabs a reference to
the contended object, unlocks all other objects and pre-locks the
contended one before anything else.

The problem is that it is possible that this pre-locked object was about
to be destroyed and drm_exec is now holding the last reference to it.

So we never actually see this pre-locked object again to be explicitly
locked and so also never reserve a slot for a dma_fence object on it.

Should the driver now use drm_exec_for_each_locked_object() to add a new
fence to all locked objects we eventually see a warning or even a
BUG_ON() to prevent random memory corruption.

Fix this by keeping the prelocked object out of the array of locked objs
until it was explicitly mentioned by the driver again.

If the prelocked object is never mentioned again by the driver
just unlock and drop the reference at the end of the locking loop.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reported-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Fixes: 09593216bff1 ("drm: execution context for GEM buffers v7")
CC: stable@vger.kernel.org # v6.6+
Link: https://lore.kernel.org/r/20261007124657.9664-1-christian.koenig@amd.com
[ sashal: Adapted iterator documentation to preserve the existing explicit index parameter. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_exec.c | 73 ++++++++++++++++++++++----------------
 include/drm/drm_exec.h     |  9 ++---
 2 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/drm_exec.c b/drivers/gpu/drm/drm_exec.c
index d22d487a8356b..4947447598ef5 100644
--- a/drivers/gpu/drm/drm_exec.c
+++ b/drivers/gpu/drm/drm_exec.c
@@ -50,6 +50,16 @@
 /* Dummy value used to initially enter the retry loop */
 #define DRM_EXEC_DUMMY ((void *)~0)
 
+/* Unlock and put the prelocked obj */
+static void drm_exec_drop_prelocked(struct drm_exec *exec)
+{
+	if (exec->prelocked) {
+		dma_resv_unlock(exec->prelocked->resv);
+		drm_gem_object_put(exec->prelocked);
+		exec->prelocked = NULL;
+	}
+}
+
 /* Unlock all objects and drop references */
 static void drm_exec_unlock_all(struct drm_exec *exec)
 {
@@ -61,8 +71,7 @@ static void drm_exec_unlock_all(struct drm_exec *exec)
 		drm_gem_object_put(obj);
 	}
 
-	drm_gem_object_put(exec->prelocked);
-	exec->prelocked = NULL;
+	drm_exec_drop_prelocked(exec);
 }
 
 /**
@@ -114,6 +123,14 @@ EXPORT_SYMBOL(drm_exec_fini);
 bool drm_exec_cleanup(struct drm_exec *exec)
 {
 	if (likely(!exec->contended)) {
+
+		/*
+		 * The contended and prelocked object might never be passed to
+		 * drm_exec_lock_obj() again. This can happen when the object
+		 * is about to be cleaned up and we now hold the last reference
+		 * to it. Make sure that we don't unnecessarily keep it around.
+		 */
+		drm_exec_drop_prelocked(exec);
 		ww_acquire_done(&exec->ticket);
 		return false;
 	}
@@ -172,16 +189,16 @@ static int drm_exec_lock_contended(struct drm_exec *exec)
 		dma_resv_lock_slow(obj->resv, &exec->ticket);
 	}
 
-	ret = drm_exec_obj_locked(exec, obj);
-	if (unlikely(ret))
-		goto error_unlock;
+	/*
+	 * It is perfectly possible that we see another contention before the
+	 * first one is fully handled.
+	 */
+	drm_exec_drop_prelocked(exec);
 
+	/* We move the reference from contended to prelocked here */
 	exec->prelocked = obj;
 	return 0;
 
-error_unlock:
-	dma_resv_unlock(obj->resv);
-
 error_dropref:
 	drm_gem_object_put(obj);
 	return ret;
@@ -209,35 +226,31 @@ int drm_exec_lock_obj(struct drm_exec *exec, struct drm_gem_object *obj)
 	if (exec->prelocked == obj) {
 		drm_gem_object_put(exec->prelocked);
 		exec->prelocked = NULL;
-		return 0;
-	}
+	} else {
+		if (exec->flags & DRM_EXEC_INTERRUPTIBLE_WAIT)
+			ret = dma_resv_lock_interruptible(obj->resv,
+							  &exec->ticket);
+		else
+			ret = dma_resv_lock(obj->resv, &exec->ticket);
+
+		if (unlikely(ret == -EDEADLK)) {
+			drm_gem_object_get(obj);
+			exec->contended = obj;
+			return -EDEADLK;
+		}
 
-	if (exec->flags & DRM_EXEC_INTERRUPTIBLE_WAIT)
-		ret = dma_resv_lock_interruptible(obj->resv, &exec->ticket);
-	else
-		ret = dma_resv_lock(obj->resv, &exec->ticket);
+		if (unlikely(ret == -EALREADY) &&
+		    exec->flags & DRM_EXEC_IGNORE_DUPLICATES)
+			return 0;
 
-	if (unlikely(ret == -EDEADLK)) {
-		drm_gem_object_get(obj);
-		exec->contended = obj;
-		return -EDEADLK;
+		if (unlikely(ret))
+			return ret;
 	}
 
-	if (unlikely(ret == -EALREADY) &&
-	    exec->flags & DRM_EXEC_IGNORE_DUPLICATES)
-		return 0;
-
-	if (unlikely(ret))
-		return ret;
-
 	ret = drm_exec_obj_locked(exec, obj);
 	if (ret)
-		goto error_unlock;
-
-	return 0;
+		dma_resv_unlock(obj->resv);
 
-error_unlock:
-	dma_resv_unlock(obj->resv);
 	return ret;
 }
 EXPORT_SYMBOL(drm_exec_lock_obj);
diff --git a/include/drm/drm_exec.h b/include/drm/drm_exec.h
index b5bf0b6da791c..fe2f21f4f066f 100644
--- a/include/drm/drm_exec.h
+++ b/include/drm/drm_exec.h
@@ -71,7 +71,8 @@ drm_exec_obj(struct drm_exec *exec, unsigned long index)
  * @index: unsigned long index for the iteration
  * @obj: the current GEM object
  *
- * Iterate over all the locked GEM objects inside the drm_exec object.
+ * Iterate over all the explicitly locked GEM objects inside the drm_exec
+ * container, except for the contended and implicit prelocked one.
  */
 #define drm_exec_for_each_locked_object(exec, index, obj)		\
 	for ((index) = 0; ((obj) = drm_exec_obj(exec, index)); ++(index))
@@ -83,9 +84,9 @@ drm_exec_obj(struct drm_exec *exec, unsigned long index)
  * @index: unsigned long index for the iteration
  * @obj: the current GEM object
  *
- * Iterate over all the locked GEM objects inside the drm_exec object in
- * reverse locking order. Note that @index may go below zero and wrap,
- * but that will be caught by drm_exec_obj(), returning a NULL object.
+ * Iterate over all the explicitly locked GEM objects inside the drm_exec
+ * container in reverse locking order. Note that @index may go below zero and wrap
+ * around, but that will be caught by drm_exec_obj(), returning a NULL object.
  */
 #define drm_exec_for_each_locked_object_reverse(exec, index, obj)	\
 	for ((index) = (exec)->num_objects - 1;				\
-- 
2.53.0



