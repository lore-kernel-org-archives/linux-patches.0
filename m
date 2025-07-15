Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A72EA73B;
	Tue, 15 Jul 2025 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586886; cv=none; b=TKnXXlIlVmBnQxrj2dagrXSR3GU3jF+JSXXElqf/goDPW5RwUdPid9bn18FSaKiDM2HHjb9GGpnyp6xeqsORXeU6pVvhoRw6KvAQV2fYyGVStQP2eC9DN14IIHv9k06cadM0wsj0GMzN2lvgx19xGa0QINInSoBvtfyJvL7UFVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586886; c=relaxed/simple;
	bh=HtMwZfVwUk4pN47tEyf6a43vJ1ICAkEJBBm82jH8daU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hh8ScEMBYMKZ/t+OqoyAJoFrGtd24wbS6jlEHtIQqq5KKW6eI22EEBqxAUYEFN9bzKUrfezShhN+lzeW2TVfnDc8+o7fhkWXUXa8UCoryZ6so5ki2Y9TDdJrWWbhc9of32lXY4qjU8sb276AHf1RsMJNktqm8yBt4DpIniDOQbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1xnvtuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1xnvtuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD5DC4CEF8;
	Tue, 15 Jul 2025 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586886;
	bh=HtMwZfVwUk4pN47tEyf6a43vJ1ICAkEJBBm82jH8daU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1xnvtuf0eaTDdi+3Mt/9B8JAxs0BW4Jy5c9nXIN9h8qXxldwQ6QUeyjWCgfW/CWN
	 hGZjT5cX/Oqp7MIr/u1MhMdEhAjDFvvIgWBuHdeILNEq5KKZkCZqQs6jOi5jcKd1y9
	 18wAdGws3a4G8mMlYoH/mX7nebzASJNI4yLW0Ex8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Johl Brown <johlbrown@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 084/192] drm/amdkfd: add hqd_sdma_get_doorbell callbacks for gfx7/8
Date: Tue, 15 Jul 2025 15:12:59 +0200
Message-ID: <20250715130818.289491027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 34659c1a1f4fd4c148ab13e13b11fd64df01ffcd upstream.

These were missed when support was added for other generations.
The callbacks are called unconditionally so we need to make
sure all generations have them.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4304
Link: https://github.com/ROCm/ROCm/issues/4965
Fixes: bac38ca8c475 ("drm/amdkfd: implement per queue sdma reset for gfx 9.4+")
Cc: Jonathan Kim <jonathan.kim@amd.com>
Reported-by: Johl Brown <johlbrown@gmail.com>
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1e9d17a5dcf1242e9518e461d8e63ad35240e49e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c |    8 ++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c |    8 ++++++++
 2 files changed, 16 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c
@@ -561,6 +561,13 @@ static uint32_t read_vmid_from_vmfault_r
 	return REG_GET_FIELD(status, VM_CONTEXT1_PROTECTION_FAULT_STATUS, VMID);
 }
 
+static uint32_t kgd_hqd_sdma_get_doorbell(struct amdgpu_device *adev,
+					  int engine, int queue)
+
+{
+	return 0;
+}
+
 const struct kfd2kgd_calls gfx_v7_kfd2kgd = {
 	.program_sh_mem_settings = kgd_program_sh_mem_settings,
 	.set_pasid_vmid_mapping = kgd_set_pasid_vmid_mapping,
@@ -578,4 +585,5 @@ const struct kfd2kgd_calls gfx_v7_kfd2kg
 	.set_scratch_backing_va = set_scratch_backing_va,
 	.set_vm_context_page_table_base = set_vm_context_page_table_base,
 	.read_vmid_from_vmfault_reg = read_vmid_from_vmfault_reg,
+	.hqd_sdma_get_doorbell = kgd_hqd_sdma_get_doorbell,
 };
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c
@@ -582,6 +582,13 @@ static void set_vm_context_page_table_ba
 			lower_32_bits(page_table_base));
 }
 
+static uint32_t kgd_hqd_sdma_get_doorbell(struct amdgpu_device *adev,
+					  int engine, int queue)
+
+{
+	return 0;
+}
+
 const struct kfd2kgd_calls gfx_v8_kfd2kgd = {
 	.program_sh_mem_settings = kgd_program_sh_mem_settings,
 	.set_pasid_vmid_mapping = kgd_set_pasid_vmid_mapping,
@@ -599,4 +606,5 @@ const struct kfd2kgd_calls gfx_v8_kfd2kg
 			get_atc_vmid_pasid_mapping_info,
 	.set_scratch_backing_va = set_scratch_backing_va,
 	.set_vm_context_page_table_base = set_vm_context_page_table_base,
+	.hqd_sdma_get_doorbell = kgd_hqd_sdma_get_doorbell,
 };


