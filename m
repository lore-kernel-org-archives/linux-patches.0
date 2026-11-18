Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034713;
	b=ji/+zgSI4jTyxAYbkWt3IFyCUHjoVNSo2WQPg7Kecrs18q1Mk97Os1cXomGPZFKen97d
	 W5JUIaAxUIXSUXf2NngL8rH/pPGsTD48yosE8HBhoZuThfMOj85AiTrHOpf0B9Pn/ZN4P
	 9dJfx3iYtii58nmyeEjQAAW9ozVbe8ygpjtiI8Zl3liQHmo3d65xmIrSF0WHJhqblrtJE
	 0fFgSogrVrt9uG54FTdIl1Pl1Jgy4U/hLBIHhBrZaABoKT/m0Kkq0ZCEhJnVi1ftTiQbq
	 AqUzumoVY6ABye7wNAjUL9zcbf07XQePS64Xoj2XhS7jN1zDoiJpmj+ngDyAWn7Wq2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D3/+ICn/uddnv1C6NxPHuRTHkvF6+OHKBJ1cbWJ5Kl4=;
	b=fFcbEYRFwDMytUF9jldUu3J51Bchh3jkfr1rp0KBVChJV21sSXGXusysSRkMWreqHh4M
	 Au+AtRWeXB+v03eqpz5M3/yHrxN9eFoJedoC45KhxZE7Y4CK5o0fwHeqHoJPu1OmW3wTf
	 exako2HbwsQ6PKtGYoa/LZsbJx5fNZAbdI29t1zuukOpU+PIMVau8pb1xP0tFDTA1WDb6
	 TDYdHcHUoMimC4t7Ilc4VhnI5Sj1aLYbIjSMZplBR/Hl/1gLOy+a3Rou7oEGwInBzjZ/f
	 9lmOBxkcjL9mG8UaoBXBExU6EcE7DEZGfsBG+IuSTkrHYkaShwsCM7RcJqw0YKgWoIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3dVPKG2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B2B606A333;
	Wed, 18 Nov 2026 20:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3dVPKG2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175351F000C4;
	Wed, 18 Nov 2026 20:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034713;
	bh=D3/+ICn/uddnv1C6NxPHuRTHkvF6+OHKBJ1cbWJ5Kl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3dVPKG2e8FBX9lJ5jVMsGv6xbPeJXco23UXPDJj89qdKxUJGyvid1XBZ19X7vF/s
	 xEeemqCxEJ8opPTSe6bJhu/rWRbfj5zGsyCmrKOQmmXmxmy6fnfXLx9nAXmxVl6Pkt
	 qA3F8yYyPiZi0H/lFzIMbfY7rzTVZ41apzYBeZuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0466/3318] drm/amdgpu/pm: add workload profile pause helper
Date: Wed, 18 Nov 2026 15:18:08 +0100
Message-ID: <20261118150330.837400574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7f991dd3641ef52e0a25b43f27cc61440c4bdcb4 ]

To be used for display idle optimizations when
we want to pause non-default profiles.

Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6dafb5d4c7cdfc8f994e789d050e29e0d5ca6efd)
Stable-dep-of: 1f1d43418d61 ("drm/amdgpu: skip gfx switch_power_profile during GPU reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/include/kgd_pp_interface.h    |  1 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c           | 19 +++++++++++++++++++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h       |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/amd/include/kgd_pp_interface.h b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
index 84c5224d994c4..2fd3aa80f939d 100644
--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -347,6 +347,7 @@ struct amd_pm_funcs {
 	int (*set_pp_table)(void *handle, const char *buf, size_t size);
 	void (*debugfs_print_current_performance_level)(void *handle, struct seq_file *m);
 	int (*switch_power_profile)(void *handle, enum PP_SMC_POWER_PROFILE type, bool en);
+	int (*pause_power_profile)(void *handle, bool pause);
 /* export to amdgpu */
 	struct amd_vce_state *(*get_vce_clock_state)(void *handle, u32 idx);
 	int (*dispatch_tasks)(void *handle, enum amd_pp_task task_id,
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 6bc1f4b381c2e..dfd455a1b9549 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -319,6 +319,25 @@ int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
 	return ret;
 }
 
+int amdgpu_dpm_pause_power_profile(struct amdgpu_device *adev,
+				   bool pause)
+{
+	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
+	int ret = 0;
+
+	if (amdgpu_sriov_vf(adev))
+		return 0;
+
+	if (pp_funcs && pp_funcs->pause_power_profile) {
+		mutex_lock(&adev->pm.mutex);
+		ret = pp_funcs->pause_power_profile(
+			adev->powerplay.pp_handle, pause);
+		mutex_unlock(&adev->pm.mutex);
+	}
+
+	return ret;
+}
+
 int amdgpu_dpm_set_xgmi_pstate(struct amdgpu_device *adev,
 			       uint32_t pstate)
 {
diff --git a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
index cb4d33555feee..744c0c8d61ad4 100644
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -387,6 +387,8 @@ int amdgpu_dpm_set_xgmi_pstate(struct amdgpu_device *adev,
 int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
 				    enum PP_SMC_POWER_PROFILE type,
 				    bool en);
+int amdgpu_dpm_pause_power_profile(struct amdgpu_device *adev,
+				   bool pause);
 
 int amdgpu_dpm_baco_reset(struct amdgpu_device *adev);
 
-- 
2.53.0



