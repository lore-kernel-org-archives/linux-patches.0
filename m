Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831401;
	b=gEUXYJnEImCIlL3EHIKZs/qbREfBsStb0S1gGVnxl/3gOrMX9y2f54o69n0tBOgWXuqc
	 +tHWO7mm9MH5irEvAXbfOWspdSMU9Rki2gVqzAzH/k+oafU3znEypn9IR+mKPE2Gcs0DH
	 amedxZg0MsDO4V9ngAQEuw4/GjAGSv2TFirMS32FVmoDcVChFbKV84mKBdrCoj999j8IK
	 G5VizEPMSzeoILSCRXqgC67LuXXbTgOtXRlrGa7C5qNfKGd8IEY6NvUVxTWe0/s5oAw4R
	 Gye2yGBaVFReYO1A3rfDcmEfa5leOYK7M6kfARk6WiNb3tpB4AtRJoQed3INNgm+zQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zgeiTgHDw8J3WA7t7ps184zXeY5AboWkGO16ZYTzeuA=;
	b=YSKS/O+GnN3OkiH/FGoitODc6vJNo01FUqa/T41q70ZSc7M/q04mcOTPVFjHMVlHyywp
	 ronO4w+btSM7GanNhIS+vZyPVkx9IP4Hc4dX2yLa5+tephOnxtoqOBGbhPSvLQIU8v67N
	 nTVYz4wtsZyUsx0pcRMWJeU5b8XjNelsJtJ2Ggvav08r2v20PylE3aKLb9+qDdLDUpXV/
	 joKEOFPLrlz2VBimz5AAbSvxEmiGAGdoiNbp6dljg86uKarE9WWCF0ATZzw9XX9UzW6nt
	 wL6DhUSClZ8+5LSdnc3wffL0mxNKcPzfnZMCiK8dcRk9C8jmijJkfuYY0VGrgwxmfsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmzBHq+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E81606AB19;
	Wed,  4 Nov 2026 22:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmzBHq+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEA51F00A02;
	Wed,  4 Nov 2026 22:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831401;
	bh=zgeiTgHDw8J3WA7t7ps184zXeY5AboWkGO16ZYTzeuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmzBHq+t6C5mMYP+JTXam5Azg8wHD5Y+tvaJPTq4bwkRj8GxBtK7gCLZ0JWNMiJ9S
	 cx2CbH59Pyqr3z4+DDv2g0kz1C2UCpEzqmQ6nF2qx2w3Y7RbH15Oxn/lLpuTbCWsSE
	 EkHHw2HhU6/GfQq76JepRP+WcDl1v7LCxjXr7UMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 0683/1005] drm/msm: Fix vm_bo use-after-free in with_vm_locks()
Date: Wed,  4 Nov 2026 16:06:56 -0500
Message-ID: <20261104211102.760291060@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 81878aa1a2f551f51a3d3aef2a9509503ec34d8b upstream.

The unwind loop drops the vm_bo reference taken while locking before
advancing to the next entry.  drm_gpuvm_bo_put() may drop the last
reference, removing and freeing the vm_bo, after which the plain list
iterator dereferences freed memory to advance.

Use the safe iterator, which saves the next entry before the body runs.

Fixes: fe4952b5f27cca5d ("drm/msm: Convert vm locking")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Patchwork: https://patchwork.freedesktop.org/patch/754331/
Message-ID: <20260916175548.2089821-1-vulab@iscas.ac.cn>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem_shrinker.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index 9d2788f79ace..a626fbb869db 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -51,6 +51,7 @@ with_vm_locks(void (*fn)(struct drm_gem_object *obj),
 	 * success paths
 	 */
 	struct drm_gpuvm_bo *vm_bo, *last_locked = NULL;
+	struct drm_gpuvm_bo *next;
 	bool locked = true;
 
 	drm_gem_for_each_gpuvm_bo (vm_bo, obj) {
@@ -82,7 +83,7 @@ with_vm_locks(void (*fn)(struct drm_gem_object *obj),
 
 out_unlock:
 	if (last_locked) {
-		drm_gem_for_each_gpuvm_bo (vm_bo, obj) {
+		drm_gem_for_each_gpuvm_bo_safe(vm_bo, next, obj) {
 			struct dma_resv *resv = drm_gpuvm_resv(vm_bo->vm);
 
 			if (resv == obj->resv)
-- 
2.56.0



