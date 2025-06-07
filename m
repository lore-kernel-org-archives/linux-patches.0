Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBA321A444;
	Sat,  7 Jun 2025 10:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290953; cv=none; b=qASA43MM/TdLknNmBG/cKTiXxzJ1EjRf1jIyd5UGBK6obMKkGhW4zLiSy6tNjqbn8hRno2A64hq1CIQ2rjvv99PmW3nHjoweTEfXtfxwj3+kUWiXBsgS4cpsi7gtTU50cZALVZnsGLA+ZsJUCnjYE+HDJHMwWr6lxT+E6uPGseY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290953; c=relaxed/simple;
	bh=w7YjNrlsiuCZe5Kkf+uwxTTOPyH9xSQWTDiT/3CRoHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiEElk256Tm9OkXuQKCgXtTntncot5ddDt88oYGeFEspLVTRFxCYqrIOhPDhiDC/1OgyxfOwnYMyhnfZBBzK8bjU8VwTbnEoYbLFPrtjLFBHcdpBwFz9GXwL0ZejVToE+hUqve7DKArTI8jZs/cWC4OLV8rG3DqbWKViqPy3590=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktjS+BNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktjS+BNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B523C4CEE4;
	Sat,  7 Jun 2025 10:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290953;
	bh=w7YjNrlsiuCZe5Kkf+uwxTTOPyH9xSQWTDiT/3CRoHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktjS+BNv5zHugxELPejs+iiReL4xdCmZ4tFjcDNSZXr9GR4HNdbHqrhi5NNbLtvOL
	 fPc33r9EUqP357+2RU/Gm2T42WmJ5xSA2tAKr1uu+9hJTjm05NMYQfP9Z2vPtBpexS
	 1jBbaKPzD3M10dw4IjERRycQ9VaLOACqbBWtDprs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 10/24] accel/ivpu: Update power island delays
Date: Sat,  7 Jun 2025 12:07:41 +0200
Message-ID: <20250607100718.312680730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@intel.com>

commit 88bdd1644ca28d48591b2a1e6e8b8c2b13f4bd3f upstream.

Apply Hardware Architecture Specification compatible delays
for main island power delivery for 50xx and above.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241004162505.1695605-3-maciej.falkowski@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw_40xx_reg.h |    2 +
 drivers/accel/ivpu/ivpu_hw_ip.c       |   49 ++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 17 deletions(-)

--- a/drivers/accel/ivpu/ivpu_hw_40xx_reg.h
+++ b/drivers/accel/ivpu/ivpu_hw_40xx_reg.h
@@ -115,6 +115,8 @@
 
 #define VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY			0x00030068u
 #define VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY_POST_DLY_MASK	GENMASK(7, 0)
+#define VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY_POST1_DLY_MASK	GENMASK(15, 8)
+#define VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY_POST2_DLY_MASK	GENMASK(23, 16)
 
 #define VPU_50XX_HOST_SS_AON_PWR_ISLAND_STATUS_DLY			0x0003006cu
 #define VPU_50XX_HOST_SS_AON_PWR_ISLAND_STATUS_DLY_STATUS_DLY_MASK	GENMASK(7, 0)
--- a/drivers/accel/ivpu/ivpu_hw_ip.c
+++ b/drivers/accel/ivpu/ivpu_hw_ip.c
@@ -8,15 +8,12 @@
 #include "ivpu_hw.h"
 #include "ivpu_hw_37xx_reg.h"
 #include "ivpu_hw_40xx_reg.h"
+#include "ivpu_hw_btrs.h"
 #include "ivpu_hw_ip.h"
 #include "ivpu_hw_reg_io.h"
 #include "ivpu_mmu.h"
 #include "ivpu_pm.h"
 
-#define PWR_ISLAND_EN_POST_DLY_FREQ_DEFAULT 0
-#define PWR_ISLAND_EN_POST_DLY_FREQ_HIGH    18
-#define PWR_ISLAND_STATUS_DLY_FREQ_DEFAULT  3
-#define PWR_ISLAND_STATUS_DLY_FREQ_HIGH	    46
 #define PWR_ISLAND_STATUS_TIMEOUT_US        (5 * USEC_PER_MSEC)
 
 #define TIM_SAFE_ENABLE		            0xf1d0dead
@@ -268,20 +265,15 @@ void ivpu_hw_ip_idle_gen_disable(struct
 		idle_gen_drive_40xx(vdev, false);
 }
 
-static void pwr_island_delay_set_50xx(struct ivpu_device *vdev)
+static void
+pwr_island_delay_set_50xx(struct ivpu_device *vdev, u32 post, u32 post1, u32 post2, u32 status)
 {
-	u32 val, post, status;
-
-	if (vdev->hw->pll.profiling_freq == PLL_PROFILING_FREQ_DEFAULT) {
-		post = PWR_ISLAND_EN_POST_DLY_FREQ_DEFAULT;
-		status = PWR_ISLAND_STATUS_DLY_FREQ_DEFAULT;
-	} else {
-		post = PWR_ISLAND_EN_POST_DLY_FREQ_HIGH;
-		status = PWR_ISLAND_STATUS_DLY_FREQ_HIGH;
-	}
+	u32 val;
 
 	val = REGV_RD32(VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY);
 	val = REG_SET_FLD_NUM(VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY, POST_DLY, post, val);
+	val = REG_SET_FLD_NUM(VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY, POST1_DLY, post1, val);
+	val = REG_SET_FLD_NUM(VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY, POST2_DLY, post2, val);
 	REGV_WR32(VPU_50XX_HOST_SS_AON_PWR_ISLAND_EN_POST_DLY, val);
 
 	val = REGV_RD32(VPU_50XX_HOST_SS_AON_PWR_ISLAND_STATUS_DLY);
@@ -686,13 +678,36 @@ static void dpu_active_drive_37xx(struct
 	REGV_WR32(VPU_37XX_HOST_SS_AON_DPU_ACTIVE, val);
 }
 
+static void pwr_island_delay_set(struct ivpu_device *vdev)
+{
+	bool high = vdev->hw->pll.profiling_freq == PLL_PROFILING_FREQ_HIGH;
+	u32 post, post1, post2, status;
+
+	if (ivpu_hw_ip_gen(vdev) < IVPU_HW_IP_50XX)
+		return;
+
+	switch (ivpu_device_id(vdev)) {
+	case PCI_DEVICE_ID_PTL_P:
+		post = high ? 18 : 0;
+		post1 = 0;
+		post2 = 0;
+		status = high ? 46 : 3;
+		break;
+
+	default:
+		dump_stack();
+		ivpu_err(vdev, "Unknown device ID\n");
+		return;
+	}
+
+	pwr_island_delay_set_50xx(vdev, post, post1, post2, status);
+}
+
 int ivpu_hw_ip_pwr_domain_enable(struct ivpu_device *vdev)
 {
 	int ret;
 
-	if (ivpu_hw_ip_gen(vdev) == IVPU_HW_IP_50XX)
-		pwr_island_delay_set_50xx(vdev);
-
+	pwr_island_delay_set(vdev);
 	pwr_island_enable(vdev);
 
 	ret = wait_for_pwr_island_status(vdev, 0x1);


