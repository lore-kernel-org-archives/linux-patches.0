Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061396;
	b=Er72HQ4mDOcz7D3Wo53yGNfCyDF51wLvIkg6tjmmnmJ1dDLIqTlvCbZ+KXOUF70kw4hs
	 g1v2XK/d7S7xbmvOnhrGX8fu+/mHcTzO+Brk/4sQq/+xF37MpcXOBkAXXZIk+TBokgpjZ
	 4jtf2RGfONuMtHM3jwOEN3EN3qFjA7bvTAT+lfo/k0POmWQMHOSCPqMhS8F5hW752+InF
	 vuyk53Hlldn7AtOvTvA3NgEWNvkrTkVWPtJiRTl5zVQ0fgN9f4v9miT+SaBkiC4ezhUow
	 zODt+ynxBKgQRYulgXX62dhvFUh9zBCQHlDZMQyG6N86Pjg785VrH+iPR2z2yFw2WOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uNyAP0qSZzlXPelCFI88AJ45qjM60vHYpijqyQVE6YI=;
	b=mlIIDtwFzlXPgiUSO3DPL7KSdNiv4rVm2F9Z6fv4VP78rOdSHEidQ+d9vKrTn9JTQuOD
	 /oVHUycr3TLZsx7HrQjHiEZf47OVimXJhcxev1mQYRHpZNA+Jq8GpjyKE16kGylwNkL6Y
	 0txaKTxxFeE1N7UAhHnpzh5s0+RQdYHp95MU+oOtEqrrUrn1z/siZ2I5VablQJs2MclO/
	 +u90ksorFZezYgHV6w9hjE3+1Wfq4BNOAvw6wQ3ib+S86kfUk7Bi6gDoZB5//pJqWt9H8
	 0OIXWoRGK3nmeD8ruJPzYdaSSl8MhH2MoX/Pzj883c4UW54+9+RRsJsBAiVuq1Xlszw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSmz5kcN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905C2606A33E;
	Sat,  7 Nov 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSmz5kcN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB8F1F0089F;
	Sat,  7 Nov 2026 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061396;
	bh=uNyAP0qSZzlXPelCFI88AJ45qjM60vHYpijqyQVE6YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSmz5kcN+dgMX99jnkORa+d2sZmyHUKpSdjcIUm41hwuaPIrsvlNzwanbZ2lv0yZp
	 N9+AqMjQ6II9zxx8wlOkv41c+LfH9ESQIOsAZuFSCmILrYaSHZv1Mo9+eD0TARxloc
	 0zQbEUGyEikAyw8CAJt1bfFXEcKcsWOs64/2ny14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0515/1536] drm/amdgpu: skip gfx switch_power_profile during GPU reset
Date: Sat,  7 Nov 2026 08:42:11 -0500
Message-ID: <20261107135011.898575321@linuxfoundation.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 1f1d43418d61c8511779e0f63a954a78b9433b43 ]

During resume from GPU reset, the gfx idle work may invoke switch_power_profile
before the reset completes. This causes the following assert error because the
register access occurs without first releasing the GPU reset semaphore:

[ 1576.768935] CR2: 0000559ea133ead0 CR3: 00000002e6c42000 CR4: 0000000000350ef0
[ 1576.768940] Call Trace:
[ 1576.768944]  <TASK>
[ 1576.768953]  amdgpu_device_rreg+0x21/0x50 [amdgpu]
[ 1576.769158]  smu_msg_v1_send_msg+0x1a4/0x6e0 [amdgpu]
[ 1576.769437]  smu_cmn_send_smc_msg_with_params_ext+0xba/0x120 [amdgpu]
[ 1576.769721]  smu_cmn_send_smc_msg_with_param+0x33/0x40 [amdgpu]
[ 1576.769993]  smu_v13_0_0_set_power_profile_mode+0x192/0x2b0 [amdgpu]
[ 1576.770267]  smu_bump_power_profile_mode+0x5d/0x80 [amdgpu]
[ 1576.770538]  smu_switch_power_profile+0xa4/0xf0 [amdgpu]
[ 1576.770839]  amdgpu_dpm_switch_power_profile+0x6f/0x90 [amdgpu]
[ 1576.771210]  amdgpu_gfx_profile_idle_work_handler+0xe9/0x130 [amdgpu]
[ 1576.771460]  process_one_work+0x23e/0x6f0
[ 1576.771491]  worker_thread+0x1c4/0x380
[ 1576.771506]  kthread+0x10c/0x150
[ 1576.771512]  ? __pfx_worker_thread+0x10/0x10
[ 1576.771518]  ? __pfx_kthread+0x10/0x10
[ 1576.771530]  ret_from_fork+0x314/0x390
[ 1576.771537]  ? __pfx_kthread+0x10/0x10
[ 1576.771546]  ret_from_fork_asm+0x1a/0x30

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d93b1ff538ce9750c01e0dd0aa62575579c0fc08)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 01ce378c36bca..0f37d5ccf246f 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -327,7 +327,8 @@ int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev) ||
+		amdgpu_in_reset(adev))
 		return 0;
 
 	if (pp_funcs && pp_funcs->switch_power_profile) {
@@ -346,7 +347,8 @@ int amdgpu_dpm_pause_power_profile(struct amdgpu_device *adev,
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev) ||
+		amdgpu_in_reset(adev))
 		return 0;
 
 	if (pp_funcs && pp_funcs->pause_power_profile) {
-- 
2.53.0



