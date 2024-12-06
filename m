Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D356713D516;
	Fri,  6 Dec 2024 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496380; cv=none; b=knf/9UUfBZ2gDQvwPOD+bd8A0q7lPyGuMyaoGuI7VreGirlr03ZLXTqBTSG/Cy7xNkHdnawI4SoRKzl5faVHCx35S9ckSj02lnxUB3a3xCW1z2jNEVtiLnS0Bu7IlugUzYcOgGX8F109j7GRxtgJWIPUK8KL7K7B3gLd5+EOANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496380; c=relaxed/simple;
	bh=y60oWeMMLL0QdEkP/Ogy19tgRtBTpt3GXV0+DYcIrE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dq3SiXdx1oy6cdSTm5j4B+1drfgmjfZ43YkfY23TdbLXzCjVeyiGCtNrxC59tyYYzqSby7hBnffaXtnArpnYE5ORL/L7FW9PbOmCfUb2dEzEx+WZ7guqc5plLgzUvDtjrzsnNHxRDipW/7PsXuGtc9t4mu1b3aCAFZsw46tpVBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRVTAjay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRVTAjay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4228FC4CEDE;
	Fri,  6 Dec 2024 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496380;
	bh=y60oWeMMLL0QdEkP/Ogy19tgRtBTpt3GXV0+DYcIrE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRVTAjay05S923n2jVtu6DNc2UlccKUX4oaGBwwAL3I9T0exmZxKhC9lS4d3wM8Vb
	 GmvRS86ZptZUimgHcy7YWtOlDysNNXCXhrypYFkOfPGgRf4q4tJy6cgsTELLjH3YyZ
	 OOKb5hFVAYmCKI4eJaN7f5SnLSnIgZ3QHnXR19+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 135/146] drm/amdgpu/pm: add gen5 display to the user on smu v14.0.2/3
Date: Fri,  6 Dec 2024 15:37:46 +0100
Message-ID: <20241206143532.850068451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kenneth Feng <kenneth.feng@amd.com>

commit 6719ab8234ce4b0c0e9aa93aaa94961e5b2bc852 upstream.

add gen5 display to the user on smu v14.0.2/3

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c            |    8 ++++++--
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h         |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c       |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |    6 ++++--
 4 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1695,7 +1695,9 @@ static int smu_smc_hw_setup(struct smu_c
 		return ret;
 	}
 
-	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN4)
+	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN5)
+		pcie_gen = 4;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN4)
 		pcie_gen = 3;
 	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
 		pcie_gen = 2;
@@ -1708,7 +1710,9 @@ static int smu_smc_hw_setup(struct smu_c
 	 * Bit 15:8:  PCIE GEN, 0 to 3 corresponds to GEN1 to GEN4
 	 * Bit 7:0:   PCIE lane width, 1 to 7 corresponds is x1 to x32
 	 */
-	if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X16)
+	if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X32)
+		pcie_width = 7;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X16)
 		pcie_width = 6;
 	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X12)
 		pcie_width = 5;
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h
@@ -53,7 +53,7 @@
 #define CTF_OFFSET_MEM			5
 
 extern const int decoded_link_speed[5];
-extern const int decoded_link_width[7];
+extern const int decoded_link_width[8];
 
 #define DECODE_GEN_SPEED(gen_speed_idx)		(decoded_link_speed[gen_speed_idx])
 #define DECODE_LANE_WIDTH(lane_width_idx)	(decoded_link_width[lane_width_idx])
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -49,7 +49,7 @@
 #define regMP1_SMN_IH_SW_INT_CTRL_mp1_14_0_0_BASE_IDX   0
 
 const int decoded_link_speed[5] = {1, 2, 3, 4, 5};
-const int decoded_link_width[7] = {0, 1, 2, 4, 8, 12, 16};
+const int decoded_link_width[8] = {0, 1, 2, 4, 8, 12, 16, 32};
 /*
  * DO NOT use these for err/warn/info/debug messages.
  * Use dev_err, dev_warn, dev_info and dev_dbg instead.
--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1186,13 +1186,15 @@ static int smu_v14_0_2_print_clk_levels(
 					(pcie_table->pcie_gen[i] == 0) ? "2.5GT/s," :
 					(pcie_table->pcie_gen[i] == 1) ? "5.0GT/s," :
 					(pcie_table->pcie_gen[i] == 2) ? "8.0GT/s," :
-					(pcie_table->pcie_gen[i] == 3) ? "16.0GT/s," : "",
+					(pcie_table->pcie_gen[i] == 3) ? "16.0GT/s," :
+					(pcie_table->pcie_gen[i] == 4) ? "32.0GT/s," : "",
 					(pcie_table->pcie_lane[i] == 1) ? "x1" :
 					(pcie_table->pcie_lane[i] == 2) ? "x2" :
 					(pcie_table->pcie_lane[i] == 3) ? "x4" :
 					(pcie_table->pcie_lane[i] == 4) ? "x8" :
 					(pcie_table->pcie_lane[i] == 5) ? "x12" :
-					(pcie_table->pcie_lane[i] == 6) ? "x16" : "",
+					(pcie_table->pcie_lane[i] == 6) ? "x16" :
+					(pcie_table->pcie_lane[i] == 7) ? "x32" : "",
 					pcie_table->clk_freq[i],
 					(gen_speed == DECODE_GEN_SPEED(pcie_table->pcie_gen[i])) &&
 					(lane_width == DECODE_LANE_WIDTH(pcie_table->pcie_lane[i])) ?


