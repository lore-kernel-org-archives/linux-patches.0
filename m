Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3161D15442C;
	Thu,  3 Jul 2025 15:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555299; cv=none; b=fwgCJ46cvFSMGKvdUuDZA20aK6IIkYkojRUnwe12B2tz/9/o/nU9BBq2QLLrrqpbUso8g6w7ds6xgNyth/fVUMs9N2izVQeDyRcFXDlh+bjlaaJi+Ugh17JslEk6TiqE91+aqvxEu6p8nyweUXA6lAvfLIZed5uJcVXwGC+DSfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555299; c=relaxed/simple;
	bh=VafeRBccrZTP7zhGrRMVdWgoYWH3eZ3wQ9NMID4jUbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOsKsK+RgDLhrIynRYclqG0ZQwO7i6wtcMPdBOc4pF6h1rtUv1uD57HGfR0QQ0Evcr5dumrMcOSyKyztnO0pVzUfgpWE7b3evr2wSkJ62zy+5zVxTaZKzTZlezkeAzSAqJTloC//B142fGRItP2QeLIR+UhJ0mHgl4FA4CNfqhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgGyKc3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgGyKc3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96367C4CEE3;
	Thu,  3 Jul 2025 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555299;
	bh=VafeRBccrZTP7zhGrRMVdWgoYWH3eZ3wQ9NMID4jUbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgGyKc3mJ/opFxiq50/HEF3XMcg2PfU+X9KTkVIvappfmzl+ZLFGRaiirZMWxjhUP
	 dL2IKBx6xqtiGdzFE4XOcsY65NvPcSInZQzFnSxkE54DzQYy7rSbhzykYbTCzVcdhI
	 j7+9VF1UjXkSAl0oZc3jBIWTp6riyIe80fsSATPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 236/263] drm/amdgpu: add kicker fws loading for gfx11/smu13/psp13
Date: Thu,  3 Jul 2025 16:42:36 +0200
Message-ID: <20250703144013.861124459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Frank Min <Frank.Min@amd.com>

commit 854171405e7f093532b33d8ed0875b9e34fc55b4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c        |   16 ++++++++++++----
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c         |    5 +++++
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c         |    9 +++++++--
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c         |    2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |   12 +++++++++---
 5 files changed, 35 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -3521,8 +3521,12 @@ int psp_init_sos_microcode(struct psp_co
 	uint8_t *ucode_array_start_addr;
 	int err = 0;
 
-	err = amdgpu_ucode_request(adev, &adev->psp.sos_fw, AMDGPU_UCODE_REQUIRED,
-				   "amdgpu/%s_sos.bin", chip_name);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->psp.sos_fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_sos_kicker.bin", chip_name);
+	else
+		err = amdgpu_ucode_request(adev, &adev->psp.sos_fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_sos.bin", chip_name);
 	if (err)
 		goto out;
 
@@ -3798,8 +3802,12 @@ int psp_init_ta_microcode(struct psp_con
 	struct amdgpu_device *adev = psp->adev;
 	int err;
 
-	err = amdgpu_ucode_request(adev, &adev->psp.ta_fw, AMDGPU_UCODE_REQUIRED,
-				   "amdgpu/%s_ta.bin", chip_name);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->psp.ta_fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_ta_kicker.bin", chip_name);
+	else
+		err = amdgpu_ucode_request(adev, &adev->psp.ta_fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_ta.bin", chip_name);
 	if (err)
 		return err;
 
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -83,6 +83,7 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_0_pfp.bi
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_me.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_rlc.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_0_rlc_kicker.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_rlc_1.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_toc.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_1_pfp.bin");
@@ -744,6 +745,10 @@ static int gfx_v11_0_init_microcode(stru
 			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
 						   AMDGPU_UCODE_REQUIRED,
 						   "amdgpu/gc_11_0_0_rlc_1.bin");
+		else if (amdgpu_is_kicker_fw(adev))
+			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
+						   AMDGPU_UCODE_REQUIRED,
+						   "amdgpu/%s_rlc_kicker.bin", ucode_prefix);
 		else
 			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
 						   AMDGPU_UCODE_REQUIRED,
--- a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
@@ -32,6 +32,7 @@
 #include "gc/gc_11_0_0_sh_mask.h"
 
 MODULE_FIRMWARE("amdgpu/gc_11_0_0_imu.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_0_imu_kicker.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_1_imu.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_2_imu.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_imu.bin");
@@ -51,8 +52,12 @@ static int imu_v11_0_init_microcode(stru
 	DRM_DEBUG("\n");
 
 	amdgpu_ucode_ip_version_decode(adev, GC_HWIP, ucode_prefix, sizeof(ucode_prefix));
-	err = amdgpu_ucode_request(adev, &adev->gfx.imu_fw, AMDGPU_UCODE_REQUIRED,
-				   "amdgpu/%s_imu.bin", ucode_prefix);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->gfx.imu_fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_imu_kicker.bin", ucode_prefix);
+	else
+		err = amdgpu_ucode_request(adev, &adev->gfx.imu_fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_imu.bin", ucode_prefix);
 	if (err)
 		goto out;
 
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -42,7 +42,9 @@ MODULE_FIRMWARE("amdgpu/psp_13_0_5_ta.bi
 MODULE_FIRMWARE("amdgpu/psp_13_0_8_toc.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_8_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_0_sos.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_0_sos_kicker.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_0_ta.bin");
+MODULE_FIRMWARE("amdgpu/psp_13_0_0_ta_kicker.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_7_sos.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_7_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_13_0_10_sos.bin");
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -58,6 +58,7 @@
 
 MODULE_FIRMWARE("amdgpu/aldebaran_smc.bin");
 MODULE_FIRMWARE("amdgpu/smu_13_0_0.bin");
+MODULE_FIRMWARE("amdgpu/smu_13_0_0_kicker.bin");
 MODULE_FIRMWARE("amdgpu/smu_13_0_7.bin");
 MODULE_FIRMWARE("amdgpu/smu_13_0_10.bin");
 
@@ -92,7 +93,7 @@ const int pmfw_decoded_link_width[7] = {
 int smu_v13_0_init_microcode(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	char ucode_prefix[15];
+	char ucode_prefix[30];
 	int err = 0;
 	const struct smc_firmware_header_v1_0 *hdr;
 	const struct common_firmware_header *header;
@@ -103,8 +104,13 @@ int smu_v13_0_init_microcode(struct smu_
 		return 0;
 
 	amdgpu_ucode_ip_version_decode(adev, MP1_HWIP, ucode_prefix, sizeof(ucode_prefix));
-	err = amdgpu_ucode_request(adev, &adev->pm.fw, AMDGPU_UCODE_REQUIRED,
-				   "amdgpu/%s.bin", ucode_prefix);
+
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->pm.fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_kicker.bin", ucode_prefix);
+	else
+		err = amdgpu_ucode_request(adev, &adev->pm.fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s.bin", ucode_prefix);
 	if (err)
 		goto out;
 


