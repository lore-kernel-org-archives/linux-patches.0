Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034716;
	b=HF45q2EFX3LSD4cnWaiZFr9wcV/KOhf6gJgtxMi4+NSk56wQoxNA1H9dq9m65YogaraH
	 Vb3Smz2XcXzwhFwfzeOewESbE08YmE3FvSln9ORUupCrfUdNgN4zqq/9FdiK5ufAvVmhZ
	 NFENjmZ+CQDKk7gE5oBJYx7MYaTPxAcpUqatXPuH4JnoreC+Qsm2wEUi814OZ9JTyikks
	 WxbsFC+CSq/OJubpyjqW51y4D/TmmVjj6bxP3FQ2f8R5Axx8Xwev2DHYENc2f4SM3+pCW
	 tuCuH5pt105iqJxPXUC22aXF5c/ODip6ygC233wyqJH5RQ+3KTsw0v2f6ICaLt66xlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SipFwijtC9EoBeTzbTZhRVjRDIQLXKd7ml+bdK2cqYE=;
	b=b6Ea+h1UEa5TuFUGnfiLtSU/xFZPCyY5eC7noQZSLCvM504ln8njB+vwpQDqRneKwdPp
	 gqBA62+M7y23tr3ttIEyi3pv60qqz+of7NlXTvNIUQy03aektp8oZfd91Fz7zcsKS/6ER
	 pnXFiyY7SenQGZQRlhSySnXpUfp/NWw0c2ep3ytFeuuhVGoIX5yP26y8m13y8Eb6Vss76
	 jZntRpNh4Y6osoi1OJENes3GtqLsHodJUbgSVBKKSIq7twp9DuboyvPxRVCoC1AJFHiJU
	 N/hQVaoMxsdJcX2Wbo11HsIFYiK5ufB/8DVB19Ao5kJTaWxo9HhM2NE9pX2Qxp50Jog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVqlZvO7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A1606A325;
	Wed, 18 Nov 2026 20:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVqlZvO7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4691F000C4;
	Wed, 18 Nov 2026 20:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034716;
	bh=SipFwijtC9EoBeTzbTZhRVjRDIQLXKd7ml+bdK2cqYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVqlZvO7DtiFpB5n7hx4NVbYC4+QqdXdztIelamXqh0aJaGdYfQaGKWcBZ06Q+hm3
	 Cp5fqwxj7KVPYYSCSNf2HZnLHhZIQGvcTV/1b94nGJQK4deKHG/E/XLc09jlVvynDV
	 3P8wMbNaaOowsIIVCv8/8vgM2KmrTPGVMbvy88V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0467/3318] drm/amdgpu: skip gfx switch_power_profile during GPU reset
Date: Wed, 18 Nov 2026 15:18:09 +0100
Message-ID: <20261118150330.873864980@linuxfoundation.org>
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
index dfd455a1b9549..9d82bc16f171e 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -306,7 +306,8 @@ int amdgpu_dpm_switch_power_profile(struct amdgpu_device *adev,
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev) ||
+		amdgpu_in_reset(adev))
 		return 0;
 
 	if (pp_funcs && pp_funcs->switch_power_profile) {
@@ -325,7 +326,8 @@ int amdgpu_dpm_pause_power_profile(struct amdgpu_device *adev,
 	const struct amd_pm_funcs *pp_funcs = adev->powerplay.pp_funcs;
 	int ret = 0;
 
-	if (amdgpu_sriov_vf(adev))
+	if (amdgpu_sriov_vf(adev) ||
+		amdgpu_in_reset(adev))
 		return 0;
 
 	if (pp_funcs && pp_funcs->pause_power_profile) {
-- 
2.53.0



