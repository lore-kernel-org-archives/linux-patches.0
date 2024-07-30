Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6871A619E;
	Tue, 30 Jul 2024 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357324; cv=none; b=r9q61bvarMYdA9EYeuWvuGtIPcWrOdQ1sOXQIl4X/Zk6yws1wIYt4nNxoiYE8pPODA1P7P5WxkhIMLfG3SrxYnLw3JV8owARwVbI65N9B5pNQMsVSRA6ALSJCxDOAAvZ7b42w9OBx7x7Jsy1f4CLCXgx27+N74tafvlZ/qJqIUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357324; c=relaxed/simple;
	bh=DM1dKYG21kbJHoNYHcz2N/p6e738jfET+QXBzPsWsA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEH7NN2NP0MgxykljTgY/Yrj21T+PWmcdSqNmV9haRcblRbOMFLWEPmLTovaFDfFjT6te2ccXbO/Uv5yIrAGw+PL1CsR/Wgsr5PalVYHtPXYBJP9+A6hRCO6Dj8htVWAKngD3l25RO2gmE0rv9KlJ+oTHqhJu08V9RMFYgzZXZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIvQ239Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIvQ239Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BA8C32782;
	Tue, 30 Jul 2024 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357324;
	bh=DM1dKYG21kbJHoNYHcz2N/p6e738jfET+QXBzPsWsA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIvQ239QMkYbcMbw61C+BRaAy9KT4lWeXH6NZCeoqRUb29zFHh7a9R4Jt5Rj30/qp
	 wQRY2mBKYgiel8A94IYPUQAxYyOrZaTJkoUSfO1BnbrrVoL+jgT9qTQrsjRU1Uy0s4
	 udYceGXyeXEbSu7Z9eSKULtxQg7QlJj4G3k+4dyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jun Nie <jun.nie@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 222/568] drm/msm/dsi: set VIDEO_COMPRESSION_MODE_CTRL_WC
Date: Tue, 30 Jul 2024 17:45:29 +0200
Message-ID: <20240730151648.558544386@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 9ecd0ddd223b68b4603e4766a1d51f6c6cda346e ]

Video mode DSC won't work if this field is not set correctly. Set it to fix
video mode DSC (for slice_per_pkt==1 cases at least).

Fixes: 08802f515c3c ("drm/msm/dsi: Add support for DSC configuration")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/596234/
Link: https://lore.kernel.org/r/20240530-msm-drm-dsc-dsi-video-upstream-4-v6-5-2ab1d334c657@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index ab393bdaba6cd..77b805eacb1b1 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -832,6 +832,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	u32 slice_per_intf, total_bytes_per_intf;
 	u32 pkt_per_line;
 	u32 eol_byte_num;
+	u32 bytes_per_pkt;
 
 	/* first calculate dsc parameters and then program
 	 * compress mode registers
@@ -839,6 +840,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 	slice_per_intf = msm_dsc_get_slices_per_intf(dsc, hdisplay);
 
 	total_bytes_per_intf = dsc->slice_chunk_size * slice_per_intf;
+	bytes_per_pkt = dsc->slice_chunk_size; /* * slice_per_pkt; */
 
 	eol_byte_num = total_bytes_per_intf % 3;
 
@@ -876,6 +878,7 @@ static void dsi_update_dsc_timing(struct msm_dsi_host *msm_host, bool is_cmd_mod
 		dsi_write(msm_host, REG_DSI_COMMAND_COMPRESSION_MODE_CTRL, reg_ctrl);
 		dsi_write(msm_host, REG_DSI_COMMAND_COMPRESSION_MODE_CTRL2, reg_ctrl2);
 	} else {
+		reg |= DSI_VIDEO_COMPRESSION_MODE_CTRL_WC(bytes_per_pkt);
 		dsi_write(msm_host, REG_DSI_VIDEO_COMPRESSION_MODE_CTRL, reg);
 	}
 }
-- 
2.43.0



