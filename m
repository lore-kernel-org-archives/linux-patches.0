Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0542DAFA3;
	Tue,  8 Jul 2025 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993123; cv=none; b=uh8g059MVgU7uQDXn49OsuhVIg5W8O0OlqJEVoHEG1es8LQcr+1uPwH9Pcf0G+D5KLb2BrILS001cnHWVRg8kZBP874TdQBUy/JizCWRBRS8jqwD9mxk03LDoNN4NjGFKLuPypZPEUb25v5tf6tQ8NpX27aAsZveasQl+ly847g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993123; c=relaxed/simple;
	bh=kc6+0XXMMn9KNc2PX51QMTDbKGSEgXEHV40vAV3sbLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hraJqZSX49Bv2hs4H3wCOng2uywnCcxF1bWukazOJSBatYda//8U+Uh2bkO8xjDrrjG5kV+5jHFgiDLfndv7QAL9IxjgoFGG4hyMOvERLb1J8TqDne/TOi/owXqiJs2ofx5p3WK8ITXzm3EfzCrd254SE6S8C+H4j4J2jhM0d+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exlS6Oh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exlS6Oh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE24DC4CEED;
	Tue,  8 Jul 2025 16:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993123;
	bh=kc6+0XXMMn9KNc2PX51QMTDbKGSEgXEHV40vAV3sbLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exlS6Oh2QEdNesuKdZDSfqiDt/9klR+cDBYNrKBTBUFxGZKGFoVkZHd/PN/eFwkE5
	 9IMyGgouzWa3nhkvVpInq33YrPaD71RsrPPfp5ihB/7TepBNq78SMQtL6UrVCMVnK6
	 qM/yKmsQWz0CY3kyikxNdpEflaGSzfpZom3GiBHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 165/232] drm/amdgpu: add kicker fws loading for gfx11/smu13/psp13
Date: Tue,  8 Jul 2025 18:22:41 +0200
Message-ID: <20250708162245.755581547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Frank Min <Frank.Min@amd.com>

[ Upstream commit 854171405e7f093532b33d8ed0875b9e34fc55b4 ]

1. Add kicker firmwares loading for gfx11/smu13/psp13
2. Register additional MODULE_FIRMWARE entries for kicker fws
   - gc_11_0_0_rlc_kicker.bin
   - gc_11_0_0_imu_kicker.bin
   - psp_13_0_0_sos_kicker.bin
   - psp_13_0_0_ta_kicker.bin
   - smu_13_0_0_kicker.bin

Signed-off-by: Frank Min <Frank.Min@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fb5ec2174d70a8989bc207d257db90ffeca3b163)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c        | 10 ++++++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c         |  4 ++++
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c         |  6 +++++-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c         |  2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |  8 ++++++--
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 48e30e5f83389..3d42f6c3308ed 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3430,7 +3430,10 @@ int psp_init_sos_microcode(struct psp_context *psp, const char *chip_name)
 	uint8_t *ucode_array_start_addr;
 	int err = 0;
 
-	err = amdgpu_ucode_request(adev, &adev->psp.sos_fw, "amdgpu/%s_sos.bin", chip_name);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->psp.sos_fw, "amdgpu/%s_sos_kicker.bin", chip_name);
+	else
+		err = amdgpu_ucode_request(adev, &adev->psp.sos_fw, "amdgpu/%s_sos.bin", chip_name);
 	if (err)
 		goto out;
 
@@ -3672,7 +3675,10 @@ int psp_init_ta_microcode(struct psp_context *psp, const char *chip_name)
 	struct amdgpu_device *adev = psp->adev;
 	int err;
 
-	err = amdgpu_ucode_request(adev, &adev->psp.ta_fw, "amdgpu/%s_ta.bin", chip_name);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->psp.ta_fw, "amdgpu/%s_ta_kicker.bin", chip_name);
+	else
+		err = amdgpu_ucode_request(adev, &adev->psp.ta_fw, "amdgpu/%s_ta.bin", chip_name);
 	if (err)
 		return err;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 1f06b22dbe7c6..96e5c520af316 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -84,6 +84,7 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_0_pfp.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_me.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_rlc.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_0_rlc_kicker.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_rlc_1.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_toc.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_1_pfp.bin");
@@ -734,6 +735,9 @@ static int gfx_v11_0_init_microcode(struct amdgpu_device *adev)
 		    adev->pdev->revision == 0xCE)
 			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
 						   "amdgpu/gc_11_0_0_rlc_1.bin");
+		else if (amdgpu_is_kicker_fw(adev))
+			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
+						   "amdgpu/%s_rlc_kicker.bin", ucode_prefix);
 		else
 			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
 						   "amdgpu/%s_rlc.bin", ucode_prefix);
diff --git a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
index d4f72e47ae9e2..c4f5cbf1ecd7d 100644
--- a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
@@ -32,6 +32,7 @@
 #include "gc/gc_11_0_0_sh_mask.h"
 
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_imu.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_0_imu_kicker.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_1_imu.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_2_imu.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_imu.bin");
@@ -50,7 +51,10 @@ static int imu_v11_0_init_microcode(struct amdgpu_device *adev)
 	DRM_DEBUG("\n");
 
 	amdgpu_ucode_ip_version_decode(adev, GC_HWIP, ucode_prefix, sizeof(ucode_prefix));
-	err = amdgpu_ucode_request(adev, &adev->gfx.imu_fw, "amdgpu/%s_imu.bin", ucode_prefix);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->gfx.imu_fw, "amdgpu/%s_imu_kicker.bin", ucode_prefix);
+	else
+		err = amdgpu_ucode_request(adev, &adev->gfx.imu_fw, "amdgpu/%s_imu.bin", ucode_prefix);
 	if (err)
 		goto out;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
index bf00de763acb0..124f74e862d7f 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -42,7 +42,9 @@ MODULE_FIRMWARE("amdgpu/psp_13_0_5_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_8_toc.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_8_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_0_sos.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_0_sos_kicker.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_0_ta.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_0_ta_kicker.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_7_sos.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_7_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_10_sos.bin");
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 4f78c84da780c..c5bca3019de07 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -58,6 +58,7 @@
 
 MODULE_FIRMWARE("amdgpu/aldebaran_smc.bin");
 MODULE_FIRMWARE("amdgpu/smu_13_0_0.bin");
+MODULE_FIRMWARE("amdgpu/smu_13_0_0_kicker.bin");
 MODULE_FIRMWARE("amdgpu/smu_13_0_7.bin");
 MODULE_FIRMWARE("amdgpu/smu_13_0_10.bin");
 
@@ -92,7 +93,7 @@ const int pmfw_decoded_link_width[7] = {0, 1, 2, 4, 8, 12, 16};
 int smu_v13_0_init_microcode(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	char ucode_prefix[15];
+	char ucode_prefix[30];
 	int err = 0;
 	const struct smc_firmware_header_v1_0 *hdr;
 	const struct common_firmware_header *header;
@@ -103,7 +104,10 @@ int smu_v13_0_init_microcode(struct smu_context *smu)
 		return 0;
 
 	amdgpu_ucode_ip_version_decode(adev, MP1_HWIP, ucode_prefix, sizeof(ucode_prefix));
-	err = amdgpu_ucode_request(adev, &adev->pm.fw, "amdgpu/%s.bin", ucode_prefix);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->pm.fw, "amdgpu/%s_kicker.bin", ucode_prefix);
+	else
+		err = amdgpu_ucode_request(adev, &adev->pm.fw, "amdgpu/%s.bin", ucode_prefix);
 	if (err)
 		goto out;
 
-- 
2.39.5



