Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061395;
	b=uImpmLSMhT6ofAVVdez9fBSllVGcvmvCBk+UBei/NuTcScoj58tfcVYV4VCtLeJiyvwf
	 mFQXifSccfdm6C0zUSu+5dV5UYo2PVbo50coj0fHRcyTxIHORrku6L5dlVQ0b+M6QRJ/R
	 eR2cGZczEBio5woCUf23BYXtkSts7UVnA2IdbwVwgeQVH3reXckq0Zf8VprZ3MA/dAgOQ
	 xzVavO1OeCXedhk1Z0QU3/xHQHj3jg3GJ1hEDE95LSKlWP4F36jftJCDSP1HHbrqpf9qi
	 mtTHnFI/l7mf0+eesWDl+NYhSnAVq2v3ODICjpXFuLOqVwXZ+O0WuZLipI/T4hMbQCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sut3LLmjSXqBsYOcOEYAbEQDIbekB/OqVKrElqXlNdY=;
	b=asyZdZg+jQVb9bx1OY0IqY97FQk67Ik/hBK7dQD6iN/LpoUL7etK/Frs4r5WKzMxJyZV
	 QqJXpY9zLGkl1XBSBA/L84tldTOE3l8IEQZoyjccWbwcQykF2f12DBO9smWyELW50oshn
	 ErJ29PyCHMWvqVq8z9pRk3bYl1rTdJllwpptsokNeFUl6iMnZC20A05q+lPWzrCt5Iq/W
	 O1QIR9FnWQlStLJH7J1bd34F8tlzHebfoegjb5CAL4v4elkCKKdPqdNd5sCh2nYePxnLe
	 zmJLT695I7AHBW9BNqcP1KqjxsdVG5cYbcVoWWyd4MOsiU2p3Tn5BiFK6s1hAlxYdzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8ZaZWmz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00035606A331;
	Sat,  7 Nov 2026 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8ZaZWmz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A321E1F0089F;
	Sat,  7 Nov 2026 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061394;
	bh=sut3LLmjSXqBsYOcOEYAbEQDIbekB/OqVKrElqXlNdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8ZaZWmzaHkhmw+GcVFhyv9+fVJEbXqve3xc54SWfRawIeSE4Olw11kS6WHUUy0g6
	 f0wDMej1uP5Mpthw/8JF7yZy6qTzul/HzQYsgFflAsI3askBXYpiirZPs35cookG7B
	 eHMWXSEor3xwf2xhuBUc3elQlWn74Rt+hxcUzHew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0514/1536] drm/amdgpu/pm: add workload profile pause helper
Date: Sat,  7 Nov 2026 08:42:10 -0500
Message-ID: <20261107135011.871878470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 19a48d98830a3..a97b03232c0b9 100644
--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -388,6 +388,7 @@ struct amd_pm_funcs {
 	int (*set_pp_table)(void *handle, const char *buf, size_t size);
 	void (*debugfs_print_current_performance_level)(void *handle, struct seq_file *m);
 	int (*switch_power_profile)(void *handle, enum PP_SMC_POWER_PROFILE type, bool en);
+	int (*pause_power_profile)(void *handle, bool pause);
 /* export to amdgpu */
 	struct amd_vce_state *(*get_vce_clock_state)(void *handle, u32 idx);
 	int (*dispatch_tasks)(void *handle, enum amd_pp_task task_id,
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 17c04963a7921..01ce378c36bca 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -340,6 +340,25 @@ int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
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
index 4d88c0a9f453b..3e27050ccd123 100644
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -405,6 +405,8 @@ int amdgpu_dpm_set_xgmi_pstate(struct amdgpu_device *adev,
 int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
 				    enum PP_SMC_POWER_PROFILE type,
 				    bool en);
+int amdgpu_dpm_pause_power_profile(struct amdgpu_device *adev,
+				   bool pause);
 
 int amdgpu_dpm_baco_reset(struct amdgpu_device *adev);
 
-- 
2.53.0



