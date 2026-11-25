Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626209;
	b=y6PD3Ej0TV8d8kvsbOHGS80kixbI36gHz9NO/61oryNmMafU+7lNS3RnoBj6hkJYztjp
	 naulcDLJOD2yXQ6L7Jdl1dnjAblDVBqLnx2dNHlV9kSV3d86xq2/xzSDqtZCbbegs86vV
	 RoD4s0lnOu2VXVsaBsSlWVJwNvEiLL68seaEtHKgB35TB/NJVnWn7CsBaF9rWpuzHf/77
	 D7lRouH0Vgtn59CLRuKr1LONHNF6cFonsojd9vN507L9dyBx4VQFNqV/q6HkHStBXY6OC
	 DinEZRSMmyLyK5bWTKTne5tXL0/bF67RxKPcIkaaIp3Fy9PtsDg3gVHo2db9LB8tM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GCD79Bm8RXAIGF0h2WOxKCI9hwycNHP2uw2cTlOevjg=;
	b=Xl+mUSnTNbPsph9kngh54Yyoh2yek4uMwEPvF1E4jJXBHkJdY2PYazyrjKYbmR7ECT6y
	 vE2cOmExtGZPjZxM/2MPdvLDE6aGxJYqcLb9rJhV3NHN34BeISoVyYfQesWy5HqoYu+2A
	 oYHlbcm+s/i2evLRhs55PSxI9msPI8fGJ999XzLVibT/iXh2Zj9Q5/0T2AtBqTzxAzFDC
	 vSi4PoufMQ/nk1HODieF/KmJKUQAOfYA+lqTPFm+R0zliwBVhGHSDUo5ZojikaCdUuH/Z
	 tKj6/HAY0790tCrbz4etOuyVBSs6w9bUrFfZAsnzg3Msc0dPdvQS7DhS4dos41ZozQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sI/6gVYs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54598606A323;
	Wed, 25 Nov 2026 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sI/6gVYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD7D1F000C4;
	Wed, 25 Nov 2026 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626209;
	bh=GCD79Bm8RXAIGF0h2WOxKCI9hwycNHP2uw2cTlOevjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sI/6gVYsaIE6KYV/uOOThhr42PsYXvxShpnqXT3+tW/gAYxUegAlyrxJLPmoKkdq1
	 dGldqvOgJpKB99/XYHoYUExVxaxuTyFcl//fCJMGiTNpitI/qFox16A4OGot0jTxJz
	 6Eo4roO/G3YgC5R7XSbHP3y2Uy7lO6nQgrwqRDKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 769/816] drm/amdgpu: fix the error handling of amdgpu_vm_init_entities()
Date: Wed, 25 Nov 2026 15:38:37 +0100
Message-ID: <20261125143906.972572742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,11 +400,15 @@ static int amdgpu_vm_init_entities(struc
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


