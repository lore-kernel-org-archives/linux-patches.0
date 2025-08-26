Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1214239573;
	Tue, 26 Aug 2025 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207419; cv=none; b=cSOsnxoGaLeK3us6SraboaeLb3qn8nqHqI4wUZV+dsMFgd5OJoX/lLg5BzYFv8+OZS0cXPSFItMwmsmWA9Y7T6o54zRUaXxWxv7p9n391wAyQm7sDgIsgB6k35fjFO1klBfE33l0YrEi5GzPQaOCd+Kum0toYI6LiU9YDs/5Pa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207419; c=relaxed/simple;
	bh=IsBV57kDg36M3Dok6IR68YxdEtgeCDPo1DkGGvme1Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSZ40HecQINdQfyPwx6S6hQ0KLe8AcDxPguEmc+EguQvRQ0Bh+GGIaVcVn/KKnam9Ja16dD83wAXQy2RZ7T0wabcqVKTtPozP90BtyAKkogYo37vScA1M8aNDF312VmSHOyveIuKeEDPBSI65lQGLTsRKMdtHcinCb/h60LUlq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dE90iQZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dE90iQZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC01CC4CEF1;
	Tue, 26 Aug 2025 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207416;
	bh=IsBV57kDg36M3Dok6IR68YxdEtgeCDPo1DkGGvme1Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dE90iQZXWUHJ0CE6zpDLMNhpNUhMXy6rXnr9dUXCC4N795uKdbbLNf/5ONbMmLZdy
	 4wzQm+mURIQYj6X/HvKc8MHCC+L318I/Gi1ccLsdX655CjWgEWDAaj3MF3L4mk+1nc
	 a9WxRAT+cNtH7b7227pMuq5aRj2cdbAkszHMEW/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Min <Frank.Min@amd.com>,
	Gui Chengming <Jack.Gui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 173/457] drm/amdgpu: add kicker fws loading for gfx12/smu14/psp14
Date: Tue, 26 Aug 2025 13:07:37 +0200
Message-ID: <20250826110941.650957656@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Min <Frank.Min@amd.com>

commit 0395cde08e1f7eee810b5799466e41635a21e599 upstream.

1. Add kicker firmwares loading for gfx12/smu14/psp14
2. Register additional MODULE_FIRMWARE entries for kicker fws
   - gc_12_0_1_rlc_kicker.bin
   - gc_12_0_1_imu_kicker.bin
   - psp_14_0_3_sos_kicker.bin
   - psp_14_0_3_ta_kicker.bin
   - smu_14_0_3_kicker.bin

Signed-off-by: Frank Min <Frank.Min@amd.com>
Reviewed-by: Gui Chengming <Jack.Gui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c      |    1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c         |   14 ++++++++++----
 drivers/gpu/drm/amd/amdgpu/imu_v12_0.c         |   11 ++++++++---
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c         |    2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c |   11 ++++++++---
 5 files changed, 29 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c
@@ -32,6 +32,7 @@
 
 static const struct kicker_device kicker_device_list[] = {
 	{0x744B, 0x00},
+	{0x7551, 0xC8}
 };
 
 static void amdgpu_ucode_print_common_hdr(const struct common_firmware_header *hdr)
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -79,6 +79,7 @@ MODULE_FIRMWARE("amdgpu/gc_12_0_1_pfp.bi
 MODULE_FIRMWARE("amdgpu/gc_12_0_1_me.bin");
 MODULE_FIRMWARE("amdgpu/gc_12_0_1_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_12_0_1_rlc.bin");
+MODULE_FIRMWARE("amdgpu/gc_12_0_1_rlc_kicker.bin");
 MODULE_FIRMWARE("amdgpu/gc_12_0_1_toc.bin");
 
 static const struct amdgpu_hwip_reg_entry gc_reg_list_12_0[] = {
@@ -586,7 +587,7 @@ out:
 
 static int gfx_v12_0_init_microcode(struct amdgpu_device *adev)
 {
-	char ucode_prefix[15];
+	char ucode_prefix[30];
 	int err;
 	const struct rlc_firmware_header_v2_0 *rlc_hdr;
 	uint16_t version_major;
@@ -613,9 +614,14 @@ static int gfx_v12_0_init_microcode(stru
 	amdgpu_gfx_cp_init_microcode(adev, AMDGPU_UCODE_ID_CP_RS64_ME_P0_STACK);
 
 	if (!amdgpu_sriov_vf(adev)) {
-		err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
-					   AMDGPU_UCODE_REQUIRED,
-					   "amdgpu/%s_rlc.bin", ucode_prefix);
+		if (amdgpu_is_kicker_fw(adev))
+			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
+						   AMDGPU_UCODE_REQUIRED,
+						   "amdgpu/%s_rlc_kicker.bin", ucode_prefix);
+		else
+			err = amdgpu_ucode_request(adev, &adev->gfx.rlc_fw,
+						   AMDGPU_UCODE_REQUIRED,
+						   "amdgpu/%s_rlc.bin", ucode_prefix);
 		if (err)
 			goto out;
 		rlc_hdr = (const struct rlc_firmware_header_v2_0 *)adev->gfx.rlc_fw->data;
--- a/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v12_0.c
@@ -34,12 +34,13 @@
 
 MODULE_FIRMWARE("amdgpu/gc_12_0_0_imu.bin");
 MODULE_FIRMWARE("amdgpu/gc_12_0_1_imu.bin");
+MODULE_FIRMWARE("amdgpu/gc_12_0_1_imu_kicker.bin");
 
 #define TRANSFER_RAM_MASK	0x001c0000
 
 static int imu_v12_0_init_microcode(struct amdgpu_device *adev)
 {
-	char ucode_prefix[15];
+	char ucode_prefix[30];
 	int err;
 	const struct imu_firmware_header_v1_0 *imu_hdr;
 	struct amdgpu_firmware_info *info = NULL;
@@ -47,8 +48,12 @@ static int imu_v12_0_init_microcode(stru
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
 
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -34,7 +34,9 @@
 MODULE_FIRMWARE("amdgpu/psp_14_0_2_sos.bin");
 MODULE_FIRMWARE("amdgpu/psp_14_0_2_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_14_0_3_sos.bin");
+MODULE_FIRMWARE("amdgpu/psp_14_0_3_sos_kicker.bin");
 MODULE_FIRMWARE("amdgpu/psp_14_0_3_ta.bin");
+MODULE_FIRMWARE("amdgpu/psp_14_0_3_ta_kicker.bin");
 MODULE_FIRMWARE("amdgpu/psp_14_0_5_toc.bin");
 MODULE_FIRMWARE("amdgpu/psp_14_0_5_ta.bin");
 
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -62,13 +62,14 @@ const int decoded_link_width[8] = {0, 1,
 
 MODULE_FIRMWARE("amdgpu/smu_14_0_2.bin");
 MODULE_FIRMWARE("amdgpu/smu_14_0_3.bin");
+MODULE_FIRMWARE("amdgpu/smu_14_0_3_kicker.bin");
 
 #define ENABLE_IMU_ARG_GFXOFF_ENABLE		1
 
 int smu_v14_0_init_microcode(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	char ucode_prefix[15];
+	char ucode_prefix[30];
 	int err = 0;
 	const struct smc_firmware_header_v1_0 *hdr;
 	const struct common_firmware_header *header;
@@ -79,8 +80,12 @@ int smu_v14_0_init_microcode(struct smu_
 		return 0;
 
 	amdgpu_ucode_ip_version_decode(adev, MP1_HWIP, ucode_prefix, sizeof(ucode_prefix));
-	err = amdgpu_ucode_request(adev, &adev->pm.fw, AMDGPU_UCODE_REQUIRED,
-				   "amdgpu/%s.bin", ucode_prefix);
+	if (amdgpu_is_kicker_fw(adev))
+		err = amdgpu_ucode_request(adev, &adev->pm.fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s_kicker.bin", ucode_prefix);
+	else
+		err = amdgpu_ucode_request(adev, &adev->pm.fw, AMDGPU_UCODE_REQUIRED,
+					   "amdgpu/%s.bin", ucode_prefix);
 	if (err)
 		goto out;
 


