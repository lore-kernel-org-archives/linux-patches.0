Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774056;
	b=S2+S/7/y5d2Vink6zlq7INLXYo58bkbZMUYIg7qtOvjQV7ySpUU1AoKzhYuG/odFAqWZ
	 khekgXFx1EHb0Hgq1sdeLAMLW6fp4zRC3P48PSZshMTTbNerss/xUZkY59pQQ0eMwpuLz
	 czE35/3je+H8oGBuQUyR4yNpZYIkp4UtqZucYJIsCypWxrnl4SgKgBCZoLuU+dbWwCc1U
	 ngbtcgGk86tdsxn3SyuPebZnCyT+uArLHG91M8DS5NxmY8vTo4quKnYHQ/4DH+Zw9mRm8
	 9aj+P3fZR1Vhj22r9Rvgaz8g4dFwsipPVpML+68oslYzmc29bWDPNH7lu2HN8kJ5PYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nh57ddiEG4OFCMp5QpnETkgBhxInxzIIFpSf6Wvd2Hk=;
	b=hfa2Uxny5fwj3XeAFDsITrne6zPXLvkQ5ms9/XpYFLU87bd6o9S6tAq0/pW1ymQYsZOM
	 LGr9y2W6tV56l0QVw2g+hp1HscsCWBZ6t64OrDwnUGwRNs7MhPbOF2JmLBTjQTJmG+hoz
	 YKwtOjeb012/XhUUhCkzUkuhlkjvKxb9CkdhUVDgpqKpya9X3FxKkcCJFJ4BHW4EpzLBi
	 p4/ziI0uW/LF3SZ5hwm3i5EkBYP40L6i2hxmZucmz2ulNbSSQHUm56s+wKBs0GEyQjolv
	 JrgPn1WwOKROmJeWNXJyezfdkIO16zif75hHpN806EEoP5zxbvjtjJsxsQ2D8OnXBwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gr5AIuXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FED1606A31B;
	Fri, 23 Oct 2026 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gr5AIuXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662371F01825;
	Fri, 23 Oct 2026 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774055;
	bh=nh57ddiEG4OFCMp5QpnETkgBhxInxzIIFpSf6Wvd2Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gr5AIuXE+DXHV7NDlNsKt21u4UbsMR9xpYSsh/lSs8goJJqrCmFX9DCMqZ4JLfoA6
	 ElMftHjCFH4WYDjqVUUmi1uxjgLqBfpwD3ZJUDpZuzBN7pQ3+iGKrlZpBT5DPXaCJ6
	 jK/bvBB4viyFvbRhSDn3YgDqmGZV7cu+CFZa8IrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>
Subject: [PATCH 6.18 107/193] drm/exec: dont immediately add prelocked obj to array of locked objs
Date: Fri, 23 Oct 2026 18:36:24 +0200
Message-ID: <20261023163716.738858748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Christian König <ckoenig.leichtzumerken@gmail.com>

commit 26401a4999f1596a515b2e704e7066ac09306488 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_exec.c |   75 ++++++++++++++++++++++++++-------------------
 include/drm/drm_exec.h     |   15 +++++----
 2 files changed, 53 insertions(+), 37 deletions(-)

--- a/drivers/gpu/drm/drm_exec.c
+++ b/drivers/gpu/drm/drm_exec.c
@@ -51,6 +51,16 @@
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
@@ -61,8 +71,7 @@ static void drm_exec_unlock_all(struct d
 		drm_gem_object_put(obj);
 	}
 
-	drm_gem_object_put(exec->prelocked);
-	exec->prelocked = NULL;
+	drm_exec_drop_prelocked(exec);
 }
 
 /**
@@ -121,6 +130,14 @@ EXPORT_SYMBOL(drm_exec_fini);
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
@@ -178,16 +195,16 @@ static int drm_exec_lock_contended(struc
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
@@ -215,35 +232,31 @@ int drm_exec_lock_obj(struct drm_exec *e
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
+
+		if (unlikely(ret == -EALREADY) &&
+		    exec->flags & DRM_EXEC_IGNORE_DUPLICATES)
+			return 0;
 
-	if (exec->flags & DRM_EXEC_INTERRUPTIBLE_WAIT)
-		ret = dma_resv_lock_interruptible(obj->resv, &exec->ticket);
-	else
-		ret = dma_resv_lock(obj->resv, &exec->ticket);
-
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
--- a/include/drm/drm_exec.h
+++ b/include/drm/drm_exec.h
@@ -67,13 +67,15 @@ drm_exec_obj(struct drm_exec *exec, unsi
 
 /* Helper for drm_exec_for_each_locked_object(). Internal use only. */
 #define __drm_exec_for_each_locked_object(exec, obj, __index)		\
-	for (unsigned long __index = 0; ((obj) = drm_exec_obj(exec, __index)); ++__index)
+	for (unsigned long __index = 0; ((obj) = drm_exec_obj(exec, __index)); \
+	     ++__index)
 /**
  * drm_exec_for_each_locked_object - iterate over all the locked objects
  * @exec: drm_exec object
  * @obj: the current GEM object
  *
- * Iterate over all the locked GEM objects inside the drm_exec object.
+ * Iterate over all the explicitly locked GEM objects inside the drm_exec
+ * container, except for the contended and implicit prelocked one.
  */
 #define drm_exec_for_each_locked_object(exec, obj)			\
 	__drm_exec_for_each_locked_object(exec, obj, __UNIQUE_ID(drm_exec))
@@ -88,12 +90,13 @@ drm_exec_obj(struct drm_exec *exec, unsi
  * @exec: drm_exec object
  * @obj: the current GEM object
  *
- * Iterate over all the locked GEM objects inside the drm_exec object in
- * reverse locking order. Note that the internal index may wrap around,
- * but that will be caught by drm_exec_obj(), returning a NULL object.
+ * Iterate over all the explicitly locked GEM objects inside the drm_exec
+ * container in reverse locking order. Note that the internal index may wrap
+ * around, but that will be caught by drm_exec_obj(), returning a NULL object.
  */
 #define drm_exec_for_each_locked_object_reverse(exec, obj)		\
-	__drm_exec_for_each_locked_object_reverse(exec, obj, __UNIQUE_ID(drm_exec))
+	__drm_exec_for_each_locked_object_reverse(exec, obj,		\
+						  __UNIQUE_ID(drm_exec))
 
 /**
  * drm_exec_until_all_locked - loop until all GEM objects are locked


