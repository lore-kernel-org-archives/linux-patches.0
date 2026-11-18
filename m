Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044145;
	b=lia+xw9YIQgXniCKxYbTZfT+VmZEnV5R8WSbTDev2NYSnOxCo0p6x8cwcRyQnQyjCrl1
	 +FlOuIGjjm97QRFz9CaacXDXaA8aZ+7Qv+Y0oydOTH+e+jc9t871l2mg4whYOOVvHOJ03
	 2HoTCis+syh6gI6sRFtjghwtuZsmSYCY/SZf33S7sfojD7Nnoh9ZNAf3iJSU5kNV1+gET
	 yxKeluS6XbZM7J6bmPAJCQTmxhmGESzYnvsSxZjpbZypLlA0SvXTTPRytqlN4cuXGGKoP
	 kKj9kzmKnPgnHmBPyayNUcQ3+EY4mTmtducVkEb32Scu1qnQkxoy0ZrqDJxzjSEittQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bkNzp5xgPMwZkzDRuOjAvNMUeMwEZbgfhlLxj/RuX4Y=;
	b=0C/BwsdRfcBCwmYGSbn67a3pftSmxB3rO/96bMHnxAal+yojvjepg9eLMnJ9CyLtD3jG
	 CRmOB40l9W0fqgIJYkN6Co+FxmARqAuzq63M8TBSEkQjoIBrsE+Wb7xhNdSs2TfHMoyyX
	 TrUb/UMeQ5/cykasovpYUVrs2gm6SfZEPPdpVwuYwOAqInPhbe0gwxyHaif2tAyAFsC/j
	 qDbpvbfBnCtd+mt67URMfGc6H9Dp9kthS92zAUholCm85StWczq+XT2K+c/NtQcI21VFA
	 /y+AC1hRO0e1d1Gt3klXcFxnjMLts95aZCj3jjDLq1NWEbBAv4OPYhDHghGHDFxU0gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehtnAOfF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA08E606A320;
	Wed, 18 Nov 2026 23:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehtnAOfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4EB1F000C4;
	Wed, 18 Nov 2026 23:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044144;
	bh=bkNzp5xgPMwZkzDRuOjAvNMUeMwEZbgfhlLxj/RuX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehtnAOfFGfM/OemjbPNGXnYnS/uAnqdp7wMkcne+Y++l4DOhyHwSOK/aYyfHJE7aB
	 8KgxWSirlKhGERdnrXUtuH2iTh8E0aNMPguUZ1QiKOryIm+oe3MwtM5RJG7tNw1g4W
	 dC3NJWvdhCWE4LurAWY/K3DFWGENNJ97wlGke7ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0416/2857] drm/amdgpu/pm: add workload profile pause helper
Date: Wed, 18 Nov 2026 15:24:10 +0100
Message-ID: <20261118150216.361571181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3d64c78feaa8..fa57a383df4c9 100644
--- a/drivers/gpu/drm/amd/include/kgd_pp_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_pp_interface.h
@@ -340,6 +340,7 @@ struct amd_pm_funcs {
 	int (*set_pp_table)(void *handle, const char *buf, size_t size);
 	void (*debugfs_print_current_performance_level)(void *handle, struct seq_file *m);
 	int (*switch_power_profile)(void *handle, enum PP_SMC_POWER_PROFILE type, bool en);
+	int (*pause_power_profile)(void *handle, bool pause);
 /* export to amdgpu */
 	struct amd_vce_state *(*get_vce_clock_state)(void *handle, u32 idx);
 	int (*dispatch_tasks)(void *handle, enum amd_pp_task task_id,
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 19faee31f6c89..52c179e2fb702 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -301,6 +301,25 @@ int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
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
index 0a4c829ae7e37..eaeac97636253 100644
--- a/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
+++ b/drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h
@@ -384,6 +384,8 @@ int amdgpu_dpm_set_xgmi_pstate(struct amdgpu_device *adev,
 int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
 				    enum PP_SMC_POWER_PROFILE type,
 				    bool en);
+int amdgpu_dpm_pause_power_profile(struct amdgpu_device *adev,
+				   bool pause);
 
 int amdgpu_dpm_baco_reset(struct amdgpu_device *adev);
 
-- 
2.53.0



