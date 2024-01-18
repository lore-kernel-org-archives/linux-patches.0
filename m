Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686CD1774B;
	Thu, 18 Jan 2024 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575391; cv=none; b=ijIeqHOB4aZFuygvk4nuiKdomg1ByKkq6VW+y7/wkVBihjAjmZPPXneHsquOLFk3+f/AUGhYTIN1m6H/rdvucxNjKJAr5tbU2J75vy3LRf0R6+fWDzmn3S3TLdFto3sslS+22W/UloKY1YNtfVNsZxRUUstvbbTF51/Jn3KgZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575391; c=relaxed/simple;
	bh=BEuutCHUELKNrBeoHcHtCy4pCkuUIPcfaeDo3K8+jUs=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=GEzgbUwU30YurFVm2ZCiWuvFKKyoCnuJEbRNjIKCrPCxqy/L556fGa+Kl58FhBycFc8Nlhyf3bW/X5kK6bHRsGGw8XR+plKmq2guymAGt07G+6XyG+hAZsYUy03t90A4aG3K+lAUYGRDokuPSkkVxM3MRzE+pukCuIK52CR7shQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yl4UzFVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yl4UzFVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7D3C433C7;
	Thu, 18 Jan 2024 10:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575390;
	bh=BEuutCHUELKNrBeoHcHtCy4pCkuUIPcfaeDo3K8+jUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yl4UzFVxBIbn6RPE29jk/jf+JHrzJ/OXyEA4jWBRDuIEyykn7eOJiOiPlANdNlV2n
	 /Xo5sbyZD2ufz+baSndFy5peTfCklLdGoufD4gTdWHJA8tpxqLgOaroCiyoGN2wcDq
	 TdiClhVeaVmW5GOYGx5foxt/0BLNPz9cNvjD3t5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/150] drm/amd/display: get dprefclk ss info from integration info table
Date: Thu, 18 Jan 2024 11:48:57 +0100
Message-ID: <20240118104325.377592093@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <charlene.liu@amd.com>

[ Upstream commit 51e7b64690776a9981355428b537af9048308a95 ]

[why & how]
we have two SSC_En:
we get ssc_info from dce_info for MPLL_SSC_EN.
we used to call VBIOS cmdtbl's smu_info's SS persentage for DPRECLK SS info,
is used for DP AUDIO and VBIOS' smu_info table was from systemIntegrationInfoTable.

since dcn35 VBIOS removed smu_info, driver need to use integrationInfotable directly.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Charlene Liu <charlene.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c          |   19 ++++++++----
 drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h |    2 +
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -1015,13 +1015,20 @@ static enum bp_result get_ss_info_v4_5(
 		DC_LOG_BIOS("AS_SIGNAL_TYPE_HDMI ss_percentage: %d\n", ss_info->spread_spectrum_percentage);
 		break;
 	case AS_SIGNAL_TYPE_DISPLAY_PORT:
-		ss_info->spread_spectrum_percentage =
+		if (bp->base.integrated_info) {
+			DC_LOG_BIOS("gpuclk_ss_percentage (unit of 0.001 percent): %d\n", bp->base.integrated_info->gpuclk_ss_percentage);
+			ss_info->spread_spectrum_percentage =
+					bp->base.integrated_info->gpuclk_ss_percentage;
+			ss_info->type.CENTER_MODE =
+					bp->base.integrated_info->gpuclk_ss_type;
+		} else {
+			ss_info->spread_spectrum_percentage =
 				disp_cntl_tbl->dp_ss_percentage;
-		ss_info->spread_spectrum_range =
+			ss_info->spread_spectrum_range =
 				disp_cntl_tbl->dp_ss_rate_10hz * 10;
-		if (disp_cntl_tbl->dp_ss_mode & ATOM_SS_CENTRE_SPREAD_MODE)
-			ss_info->type.CENTER_MODE = true;
-
+			if (disp_cntl_tbl->dp_ss_mode & ATOM_SS_CENTRE_SPREAD_MODE)
+				ss_info->type.CENTER_MODE = true;
+		}
 		DC_LOG_BIOS("AS_SIGNAL_TYPE_DISPLAY_PORT ss_percentage: %d\n", ss_info->spread_spectrum_percentage);
 		break;
 	case AS_SIGNAL_TYPE_GPU_PLL:
@@ -2826,6 +2833,8 @@ static enum bp_result get_integrated_inf
 	info->ma_channel_number = info_v2_2->umachannelnumber;
 	info->dp_ss_control =
 		le16_to_cpu(info_v2_2->reserved1);
+	info->gpuclk_ss_percentage = info_v2_2->gpuclk_ss_percentage;
+	info->gpuclk_ss_type = info_v2_2->gpuclk_ss_type;
 
 	for (i = 0; i < NUMBER_OF_UCHAR_FOR_GUID; ++i) {
 		info->ext_disp_conn_info.gu_id[i] =
--- a/drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h
+++ b/drivers/gpu/drm/amd/display/include/grph_object_ctrl_defs.h
@@ -417,6 +417,8 @@ struct integrated_info {
 	/* V2.1 */
 	struct edp_info edp1_info;
 	struct edp_info edp2_info;
+	uint32_t gpuclk_ss_percentage;
+	uint32_t gpuclk_ss_type;
 };
 
 /*


