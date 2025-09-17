Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649F231A7EE;
	Wed, 17 Sep 2025 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112736; cv=none; b=gGIGflM/FQjOv2YjzN0qZ1XzR48441Yr9Qfglqgavqsp1dsbiRNpzqqje3Opm+3rAXS4crv9ubSKjDymfPOkI2wYU/WN7D0l+uzSVISQxUHhSbFq1lTt/rc2gnmHSPbqAcSrW12vIkvrydL/0pGTsnOzrE1ZcolqeB07iJhcBlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112736; c=relaxed/simple;
	bh=Jf2If6eJZBDphR0eNd3UI0hQ8Pa2YTvvcvQA/vIVkkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkYz0KnW74YldO3WJybCyCQ5g58hKDK3URacdoo0dFWOE8FotgLJva3mTHpW2qFawq2dxJFmDKkXpR9vjlRHUykfvlPnT0b5RXKX2E8rGHp+AHSuiu+S8kDo4DltFIxEpAsqhZ1mA8Pb2vT6vo9wtMsatG/Fuzil3zBMVfsA/rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Snn/acy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Snn/acy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2D1C4CEF0;
	Wed, 17 Sep 2025 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112736;
	bh=Jf2If6eJZBDphR0eNd3UI0hQ8Pa2YTvvcvQA/vIVkkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snn/acy8r0eKLDin86zzDST8jqShlsc/Pu7ZTPV29Yh/uUPpzHULg2l+05tuO4+sW
	 glxB3ynxtgWhgua76TaSCAu2gE+kKuTDrcB4vEJ2Xv6PBs306uZ6THtw/oiP0U6ifK
	 ElRw7x7q7H2MQCQ+NlYvmx5p6wyfN3NNupRiiKO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 016/189] Revert "drm/amdgpu: Add more checks to PSP mailbox"
Date: Wed, 17 Sep 2025 14:32:06 +0200
Message-ID: <20250917123352.245948687@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 165a69a87d6bde85cac2c051fa6da611ca4524f6 which is
commit 8345a71fc54b28e4d13a759c45ce2664d8540d28 upstream.

This commit is not applicable for stable kernels and results in the
driver failing to load on some chips on kernel 6.16.x.  Revert from
6.16.x.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.16.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c  |    4 ----
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h  |   11 -----------
 drivers/gpu/drm/amd/amdgpu/psp_v10_0.c   |    4 ++--
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c   |   31 ++++++++++++-------------------
 drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c |   25 ++++++++++---------------
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c   |   18 +++++++-----------
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c   |   25 ++++++++++---------------
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c |   25 ++++++++++---------------
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c   |   25 ++++++++++---------------
 9 files changed, 61 insertions(+), 107 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -596,10 +596,6 @@ int psp_wait_for(struct psp_context *psp
 		udelay(1);
 	}
 
-	dev_err(adev->dev,
-		"psp reg (0x%x) wait timed out, mask: %x, read: %x exp: %x",
-		reg_index, mask, val, reg_val);
-
 	return -ETIME;
 }
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h
@@ -51,17 +51,6 @@
 #define C2PMSG_CMD_SPI_GET_ROM_IMAGE_ADDR_HI 0x10
 #define C2PMSG_CMD_SPI_GET_FLASH_IMAGE 0x11
 
-/* Command register bit 31 set to indicate readiness */
-#define MBOX_TOS_READY_FLAG (GFX_FLAG_RESPONSE)
-#define MBOX_TOS_READY_MASK (GFX_CMD_RESPONSE_MASK | GFX_CMD_STATUS_MASK)
-
-/* Values to check for a successful GFX_CMD response wait. Check against
- * both status bits and response state - helps to detect a command failure
- * or other unexpected cases like a device drop reading all 0xFFs
- */
-#define MBOX_TOS_RESP_FLAG (GFX_FLAG_RESPONSE)
-#define MBOX_TOS_RESP_MASK (GFX_CMD_RESPONSE_MASK | GFX_CMD_STATUS_MASK)
-
 extern const struct attribute_group amdgpu_flash_attr_group;
 
 enum psp_shared_mem_size {
--- a/drivers/gpu/drm/amd/amdgpu/psp_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v10_0.c
@@ -94,7 +94,7 @@ static int psp_v10_0_ring_create(struct
 
 	/* Wait for response flag (bit 31) in C2PMSG_64 */
 	ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			   MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+			   0x80000000, 0x8000FFFF, false);
 
 	return ret;
 }
@@ -115,7 +115,7 @@ static int psp_v10_0_ring_stop(struct ps
 
 	/* Wait for response flag (bit 31) in C2PMSG_64 */
 	ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			   MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+			   0x80000000, 0x80000000, false);
 
 	return ret;
 }
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0.c
@@ -277,13 +277,11 @@ static int psp_v11_0_ring_stop(struct ps
 
 	/* Wait for response flag (bit 31) */
 	if (amdgpu_sriov_vf(adev))
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
 	else
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 
 	return ret;
 }
@@ -319,15 +317,13 @@ static int psp_v11_0_ring_create(struct
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x8000FFFF, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for sOS ready for ring creation\n");
 			return ret;
@@ -351,9 +347,8 @@ static int psp_v11_0_ring_create(struct
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x8000FFFF, false);
 	}
 
 	return ret;
@@ -386,8 +381,7 @@ static int psp_v11_0_mode1_reset(struct
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64);
 
-	ret = psp_wait_for(psp, offset, MBOX_TOS_READY_FLAG,
-			   MBOX_TOS_READY_MASK, false);
+	ret = psp_wait_for(psp, offset, 0x80000000, 0x8000FFFF, false);
 
 	if (ret) {
 		DRM_INFO("psp is not working correctly before mode1 reset!\n");
@@ -401,8 +395,7 @@ static int psp_v11_0_mode1_reset(struct
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_33);
 
-	ret = psp_wait_for(psp, offset, MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK,
-			   false);
+	ret = psp_wait_for(psp, offset, 0x80000000, 0x80000000, false);
 
 	if (ret) {
 		DRM_INFO("psp mode 1 reset failed!\n");
--- a/drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v11_0_8.c
@@ -41,9 +41,8 @@ static int psp_v11_0_8_ring_stop(struct
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, mmMP0_SMN_C2PMSG_64,
@@ -51,9 +50,8 @@ static int psp_v11_0_8_ring_stop(struct
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 	}
 
 	return ret;
@@ -89,15 +87,13 @@ static int psp_v11_0_8_ring_create(struc
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x8000FFFF, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -121,9 +117,8 @@ static int psp_v11_0_8_ring_create(struc
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x8000FFFF, false);
 	}
 
 	return ret;
--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -163,7 +163,7 @@ static int psp_v12_0_ring_create(struct
 
 	/* Wait for response flag (bit 31) in C2PMSG_64 */
 	ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			   MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+			   0x80000000, 0x8000FFFF, false);
 
 	return ret;
 }
@@ -184,13 +184,11 @@ static int psp_v12_0_ring_stop(struct ps
 
 	/* Wait for response flag (bit 31) */
 	if (amdgpu_sriov_vf(adev))
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
 	else
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 
 	return ret;
 }
@@ -221,8 +219,7 @@ static int psp_v12_0_mode1_reset(struct
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_64);
 
-	ret = psp_wait_for(psp, offset, MBOX_TOS_READY_FLAG,
-			   MBOX_TOS_READY_MASK, false);
+	ret = psp_wait_for(psp, offset, 0x80000000, 0x8000FFFF, false);
 
 	if (ret) {
 		DRM_INFO("psp is not working correctly before mode1 reset!\n");
@@ -236,8 +233,7 @@ static int psp_v12_0_mode1_reset(struct
 
 	offset = SOC15_REG_OFFSET(MP0, 0, mmMP0_SMN_C2PMSG_33);
 
-	ret = psp_wait_for(psp, offset, MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK,
-			   false);
+	ret = psp_wait_for(psp, offset, 0x80000000, 0x80000000, false);
 
 	if (ret) {
 		DRM_INFO("psp mode 1 reset failed!\n");
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0.c
@@ -384,9 +384,8 @@ static int psp_v13_0_ring_stop(struct ps
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_64,
@@ -394,9 +393,8 @@ static int psp_v13_0_ring_stop(struct ps
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 	}
 
 	return ret;
@@ -432,15 +430,13 @@ static int psp_v13_0_ring_create(struct
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x8000FFFF, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -464,9 +460,8 @@ static int psp_v13_0_ring_create(struct
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x8000FFFF, false);
 	}
 
 	return ret;
--- a/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c
@@ -204,9 +204,8 @@ static int psp_v13_0_4_ring_stop(struct
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, regMP0_SMN_C2PMSG_64,
@@ -214,9 +213,8 @@ static int psp_v13_0_4_ring_stop(struct
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 	}
 
 	return ret;
@@ -252,15 +250,13 @@ static int psp_v13_0_4_ring_create(struc
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_101),
+				   0x80000000, 0x8000FFFF, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -284,9 +280,8 @@ static int psp_v13_0_4_ring_create(struc
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMP0_SMN_C2PMSG_64),
+				   0x80000000, 0x8000FFFF, false);
 	}
 
 	return ret;
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -250,9 +250,8 @@ static int psp_v14_0_ring_stop(struct ps
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
+				   0x80000000, 0x80000000, false);
 	} else {
 		/* Write the ring destroy command*/
 		WREG32_SOC15(MP0, 0, regMPASP_SMN_C2PMSG_64,
@@ -260,9 +259,8 @@ static int psp_v14_0_ring_stop(struct ps
 		/* there might be handshake issue with hardware which needs delay */
 		mdelay(20);
 		/* Wait for response flag (bit 31) */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 	}
 
 	return ret;
@@ -298,15 +296,13 @@ static int psp_v14_0_ring_create(struct
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_101 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_101),
+				   0x80000000, 0x8000FFFF, false);
 
 	} else {
 		/* Wait for sOS ready for ring creation */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
-			MBOX_TOS_READY_FLAG, MBOX_TOS_READY_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
+				   0x80000000, 0x80000000, false);
 		if (ret) {
 			DRM_ERROR("Failed to wait for trust OS ready for ring creation\n");
 			return ret;
@@ -330,9 +326,8 @@ static int psp_v14_0_ring_create(struct
 		mdelay(20);
 
 		/* Wait for response flag (bit 31) in C2PMSG_64 */
-		ret = psp_wait_for(
-			psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
-			MBOX_TOS_RESP_FLAG, MBOX_TOS_RESP_MASK, false);
+		ret = psp_wait_for(psp, SOC15_REG_OFFSET(MP0, 0, regMPASP_SMN_C2PMSG_64),
+				   0x80000000, 0x8000FFFF, false);
 	}
 
 	return ret;


