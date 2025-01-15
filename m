Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E245248BA1;
	Wed, 15 Jan 2025 10:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938240; cv=none; b=RLxIdOrFuYOvPeOqkqjqjkHG4t6qPF78MfD8qe0uoHEnJACYxelzlJzj7bBccPYbbDnML+0h14eqe+nssB4UunTHQIi+p00iNmrshpOnEDaQCJaYFonJ++YyNo1NfuYi2xWwZT/Fs+J9wkyIFEN7RfnIKUJI9GgVZY38Nvg7rhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938240; c=relaxed/simple;
	bh=9dqZpp2uIf+EqDdt7RoPHbhmffBeRFgxnkEB9qcByd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEDRpnojBzmTeDZiOBkI+f4EBpIG7bYcP5RwH9G9jg72KpyMflqg7yS+PbA+tf8/Gqu6K5u+BCu04gucczG+mf+GVgj1cqpTYTtCcDC0x2uDEq58kUIVP1wh552KmHN+2cdOfbDyu50q2iso0faf9bvzWjZicEhNUD9yJsN1qcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtvBVFBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtvBVFBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85907C4CEDF;
	Wed, 15 Jan 2025 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938240;
	bh=9dqZpp2uIf+EqDdt7RoPHbhmffBeRFgxnkEB9qcByd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtvBVFBLiNayadf0CdSrYBfqs2PIssxsN/iPBD8Z6cxoJ2g7dbgkB+eTggvWAZ75O
	 dOylo5SHZdsuQO+VJvHL5MInCjKKqmkmD8AGoy1Ata6fpVF3e3aPeeLM9knuVSHM3S
	 0xelz3FG6/vuJZkG2PZlVKizb83C4V4fe+Qp7A0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 123/189] drm/amdkfd: fixed page fault when enable MES shader debugger
Date: Wed, 15 Jan 2025 11:36:59 +0100
Message-ID: <20250115103611.358185043@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.zhang@amd.com <Jesse.zhang@amd.com>

commit 9738609449c3e44d1afb73eecab4763362b57930 upstream.

Initialize the process context address before setting the shader debugger.

[  260.781212] amdgpu 0000:03:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:32 vmid:0 pasid:0)
[  260.781236] amdgpu 0000:03:00.0: amdgpu:   in page starting at address 0x0000000000000000 from client 10
[  260.781255] amdgpu 0000:03:00.0: amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00040A40
[  260.781270] amdgpu 0000:03:00.0: amdgpu:      Faulty UTCL2 client ID: CPC (0x5)
[  260.781284] amdgpu 0000:03:00.0: amdgpu:      MORE_FAULTS: 0x0
[  260.781296] amdgpu 0000:03:00.0: amdgpu:      WALKER_ERROR: 0x0
[  260.781308] amdgpu 0000:03:00.0: amdgpu:      PERMISSION_FAULTS: 0x4
[  260.781320] amdgpu 0000:03:00.0: amdgpu:      MAPPING_ERROR: 0x0
[  260.781332] amdgpu 0000:03:00.0: amdgpu:      RW: 0x1
[  260.782017] amdgpu 0000:03:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:32 vmid:0 pasid:0)
[  260.782039] amdgpu 0000:03:00.0: amdgpu:   in page starting at address 0x0000000000000000 from client 10
[  260.782058] amdgpu 0000:03:00.0: amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00040A41
[  260.782073] amdgpu 0000:03:00.0: amdgpu:      Faulty UTCL2 client ID: CPC (0x5)
[  260.782087] amdgpu 0000:03:00.0: amdgpu:      MORE_FAULTS: 0x1
[  260.782098] amdgpu 0000:03:00.0: amdgpu:      WALKER_ERROR: 0x0
[  260.782110] amdgpu 0000:03:00.0: amdgpu:      PERMISSION_FAULTS: 0x4
[  260.782122] amdgpu 0000:03:00.0: amdgpu:      MAPPING_ERROR: 0x0
[  260.782137] amdgpu 0000:03:00.0: amdgpu:      RW: 0x1
[  260.782155] amdgpu 0000:03:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:32 vmid:0 pasid:0)
[  260.782166] amdgpu 0000:03:00.0: amdgpu:   in page starting at address 0x0000000000000000 from client 10

Fixes: 438b39ac74e2 ("drm/amdkfd: pause autosuspend when creating pdd")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3849
Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5b231f5bc9ff02ec5737f2ec95cdf15ac95088e9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -350,10 +350,27 @@ int kfd_dbg_set_mes_debug_mode(struct kf
 {
 	uint32_t spi_dbg_cntl = pdd->spi_dbg_override | pdd->spi_dbg_launch_mode;
 	uint32_t flags = pdd->process->dbg_flags;
+	struct amdgpu_device *adev = pdd->dev->adev;
+	int r;
 
 	if (!kfd_dbg_is_per_vmid_supported(pdd->dev))
 		return 0;
 
+	if (!pdd->proc_ctx_cpu_ptr) {
+			r = amdgpu_amdkfd_alloc_gtt_mem(adev,
+				AMDGPU_MES_PROC_CTX_SIZE,
+				&pdd->proc_ctx_bo,
+				&pdd->proc_ctx_gpu_addr,
+				&pdd->proc_ctx_cpu_ptr,
+				false);
+		if (r) {
+			dev_err(adev->dev,
+			"failed to allocate process context bo\n");
+			return r;
+		}
+		memset(pdd->proc_ctx_cpu_ptr, 0, AMDGPU_MES_PROC_CTX_SIZE);
+	}
+
 	return amdgpu_mes_set_shader_debugger(pdd->dev->adev, pdd->proc_ctx_gpu_addr, spi_dbg_cntl,
 						pdd->watch_points, flags, sq_trap_en);
 }


