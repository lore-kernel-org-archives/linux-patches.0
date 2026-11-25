Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620542;
	b=0e1s2dBtsPUh0/VlrCLoFhVjhaJ2UyazRpSeTzrq29VSPN8arHMXyEXWknUqvlJ9BRWu
	 li5C/hJzFab+GKBLa9oTvcn3zrrL+bZKq0q+6OYuWrZQbs4qX/Fso6lSu6LMg3AeInsS/
	 tBc0oR8jaAcpJqannvrkATI5tvRQez/RV8mcgHWU+yPAfaajfp5vTwTWVg93FA6eue46l
	 qUWvicouOQcvDbEsFuFg8zDgM2VUvio6pmi9falvSnaA7a7arSwcsZZP+t+CuEw+66oGn
	 vTjB9hUI1x6lwoHNq0J9gI/jr+gs+Fp5FSOAt2PwEbKOT0qWDLUxsGbgQXnZfyC868Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=H91TIJN9zQNCHfN+vsso7En9rBuY9B4hBFERwUt2zdQ=;
	b=cjrUc3DRLvGwey8rLIqgPy2cR2Cm1x9i/rnr0WvsAElOBF49CMzH5XVHNvUgzsRB5ugl
	 HWLKxiuLghxZq/1d0f6RjqP9VmQ9dK1OHN4Ew67gosao0uNYkQqgXhds9G1bcXLWSzuA4
	 e1t9g4KulO5R0qFwp24nabEB5Qsso/9lA3ruK+JwU2lwWSWGEMlGIlwbh3m6eKx+/6s59
	 UXBaSisgqjDTkNsaWi5r0N+CWYroznZpTPaf9q8xZKgleoy2wVEw+LsFtY0/27mHhTR/i
	 yPjccUXBkZG3kXud/0Ii/2xTdQJ7xFqAnwYLYNt75cnHFBL5XyBRhHM5M5nmLENKE3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfnrwEWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D66606A31E;
	Wed, 25 Nov 2026 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfnrwEWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECC81F000C0;
	Wed, 25 Nov 2026 15:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620542;
	bh=H91TIJN9zQNCHfN+vsso7En9rBuY9B4hBFERwUt2zdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfnrwEWESkTeP4uT+LHhYaSQ4OkoYrMM7IKWKegNJOSFQkqwRMVjoKIYMvv3Pn+up
	 LU4TJuqYiZaAaEBy+1Jq7bDjxLa0qeQt4WKbglZd0XQvFrhg/WJkDfRrOkRox0WNQc
	 3dShMj+hLsXHXKueFOsv6w4z70c0cTMBcdkqaHEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.3 0952/1005] drm/amdgpu: fix the error handling of amdgpu_vm_init_entities()
Date: Wed, 25 Nov 2026 15:38:10 +0100
Message-ID: <20261125143843.975407841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit de0f2a6eabd019a3129025862bffca934a5d7180 upstream.

When initializing the immediate entity fails, amdgpu_vm_init_entities()
destroys that entity which was never set up, and when initializing the
delayed entity fails, it returns without destroying the immediate one.

On navi48, with the allocation of the immediate entity's scheduler list
failing through failslab while opening the render node:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:do_raw_spin_lock+0x7b/0x280
   _raw_spin_lock+0x3c/0x50
   drm_sched_rq_remove_entity+0x90/0x2a0 [gpu_sched]
   drm_sched_entity_kill+0x86/0x5a0 [gpu_sched]
   drm_sched_entity_fini+0x23/0x270 [gpu_sched]
   drm_sched_entity_destroy+0x24/0x30 [gpu_sched]
   amdgpu_vm_init_entities+0xc7/0x100 [amdgpu]
   amdgpu_vm_init+0x5d1/0x1480 [amdgpu]
   amdgpu_driver_open_kms+0x2b1/0xd10 [amdgpu]

Only destroy the immediate entity once it exists and the delayed one
failed.

Fixes: 55bf196f60df ("drm/amdgpu: reset VM when an error is detected")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2f538f57501a71baeb7116ff7485f9a7025e4fb9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -532,11 +532,15 @@ static int amdgpu_vm_init_entities(struc
 				  adev->vm_manager.vm_pte_scheds,
 				  adev->vm_manager.vm_pte_num_scheds, NULL);
 	if (r)
+		return r;
+
+	r = drm_sched_entity_init(&vm->delayed, DRM_SCHED_PRIORITY_NORMAL,
+				  adev->vm_manager.vm_pte_scheds,
+				  adev->vm_manager.vm_pte_num_scheds, NULL);
+	if (r)
 		goto error;
 
-	return drm_sched_entity_init(&vm->delayed, DRM_SCHED_PRIORITY_NORMAL,
-				     adev->vm_manager.vm_pte_scheds,
-				     adev->vm_manager.vm_pte_num_scheds, NULL);
+	return 0;
 
 error:
 	drm_sched_entity_destroy(&vm->immediate);


