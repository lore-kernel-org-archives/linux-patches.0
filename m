Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5516C248BAF;
	Wed, 15 Jan 2025 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938848; cv=none; b=J+rQstQsHUzR6ox///nTcuqZHWH508tiRBS4uQdgu4wqa+VUVyfpyJXgfp14yOib0bHU+ir/qGOxQb4Wn840OeoNUD57F0BlzYOUvz6pLNqOrCYfHDRz/KRkcsVoygn45C3/SmiMDyAbwNcn2zZ4WX2xdy1Wt/+vQedJWrlTN0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938848; c=relaxed/simple;
	bh=Pp3lPTfY3d+ll2o2bACF6noe38xlzjjYR8Csgiv/igo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMoaz/Q3sT+GM7z2SlYe5Pyw2/O3Z2UrntpUdEf8hveEogFrZJO2fX9PzozM62Qbwo/M8ky4MjxlGC7y9OVw1n7W8d2nAH2ZZT4deMqjON7+npI7EbuaVnT5zn/KS5qJLGt6ce8JITJB+zFD6wqdKCy0vT0xYO7ND39cEaS9AiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N30Fr1LQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N30Fr1LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD46C4CEDF;
	Wed, 15 Jan 2025 11:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938847;
	bh=Pp3lPTfY3d+ll2o2bACF6noe38xlzjjYR8Csgiv/igo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N30Fr1LQcqt7jAnHqMQ6TwArmZZyvWUsmSmilMHkwrpsH4XwQzb5XB1dh1EzR25Ju
	 yG8f8IfDNDZy+fRxD1j0qYNunq6d73NPnekv348Uqb2ykBRWXgtKM7Rplis7YdaqQg
	 tHn9iSw9WadKEIHywBUHeDvbNg8JnCNC2PnOHPms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 074/129] drm/amdkfd: fixed page fault when enable MES shader debugger
Date: Wed, 15 Jan 2025 11:37:29 +0100
Message-ID: <20250115103557.324618837@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -349,10 +349,27 @@ int kfd_dbg_set_mes_debug_mode(struct kf
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


