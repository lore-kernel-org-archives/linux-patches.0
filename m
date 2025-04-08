Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CB7267B15;
	Tue,  8 Apr 2025 11:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111034; cv=none; b=KKFxDSLgIKora9oNWACU0yPJeI9sAc8+ur2umtV7NBLNXgOFKcZ24WxSlBiOYcWBDc9rGyWOf/GIywj+lGO0NMP49X8STC+uTr9VvlSq8KlpDmz4u5g4q6ItODcb4dVCFcrqIVujljdBIl6TeeXDlsEWXvm2Dag3eEnW4XxUfD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111034; c=relaxed/simple;
	bh=HxoDTrn30GADqhKSqtM32MSM/XyIA9eEM5GzcXLUSPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtCjMhm6ZEA0GEW4CxssA5Qj2+emknAv/aFY3M3B+eM6TCDJQ1sRODuoYQAxLopYOPzOktqtMG3NPznrubRO5dqCSa8pKWeXB2JNurORMrSAWtrzD/l5U/QdoaPeKIAEXs8Ils5GSKYIc2nM5b/e+mr8TKTAr68TwJxz73pHDkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhIlhoPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhIlhoPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A917AC4CEE5;
	Tue,  8 Apr 2025 11:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111034;
	bh=HxoDTrn30GADqhKSqtM32MSM/XyIA9eEM5GzcXLUSPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhIlhoPj3J1n+z5jSPBnK0P0JHBlPwPRiFGreh0SNjjNcHH53tocYVLo7xW/Cn7em
	 hP4UrMOr4KKRvzUT6SecirqWR8/EWTjzPUKJMiGiyXrfziZ+AQTeGeX5po0kA36lAt
	 7PJHDPZuBxXx8vc7K3IL0RfiaKB4rHHISrnzq+Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sonny Jiang <sonjiang@amd.com>,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 284/731] drm/amdgpu/vcn5.0.1: use correct dpm helper
Date: Tue,  8 Apr 2025 12:43:01 +0200
Message-ID: <20250408104920.884560519@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 0487f50310cfeec1bb4480a67294fc7081c5ed22 ]

The VCN and UVD helpers were split in
commit ff69bba05f08 ("drm/amd/pm: add inst to dpm_set_powergating_by_smu")
However, this happened in parallel to the vcn 5.0.1
development so it was missed there.

Fixes: 346492f30ce3 ("drm/amdgpu: Add VCN_5_0_1 support")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Sonny Jiang <sonjiang@amd.com>
Cc: Boyuan Zhang <boyuan.zhang@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
index 8b463c977d08f..8b0b3739a5377 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c
@@ -575,8 +575,10 @@ static int vcn_v5_0_1_start(struct amdgpu_device *adev)
 	uint32_t tmp;
 	int i, j, k, r, vcn_inst;
 
-	if (adev->pm.dpm_enabled)
-		amdgpu_dpm_enable_uvd(adev, true);
+	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
+		if (adev->pm.dpm_enabled)
+			amdgpu_dpm_enable_vcn(adev, true, i);
+	}
 
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		fw_shared = adev->vcn.inst[i].fw_shared.cpu_addr;
@@ -816,8 +818,10 @@ static int vcn_v5_0_1_stop(struct amdgpu_device *adev)
 		WREG32_SOC15(VCN, vcn_inst, regUVD_STATUS, 0);
 	}
 
-	if (adev->pm.dpm_enabled)
-		amdgpu_dpm_enable_uvd(adev, false);
+	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
+		if (adev->pm.dpm_enabled)
+			amdgpu_dpm_enable_vcn(adev, false, i);
+	}
 
 	return 0;
 }
-- 
2.39.5



