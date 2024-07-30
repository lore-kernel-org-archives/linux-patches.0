Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2523C155CB3;
	Tue, 30 Jul 2024 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358234; cv=none; b=lSMTaMxNFkcb9g/f2g6NVQ2B3KXno8hNEoLED8W7HrdnZo233YlAXuaIFfmd3J3YpoecGFGKggwGMNUFDA15bx4A3PaZwzUClfNSG4m7YO1CGUI0SDAMyPGp/qCijl9n0RWu24qjIkqfkQ8WuJ4lC6HboB6PobYYlYbYBnEZptM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358234; c=relaxed/simple;
	bh=Ybyi2zcz2X+5sPTq9xhcD0nf2OeN0uNNjq9WGiXzRcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXpFjQj8+VMSQrIHQ9Iz8lLbGXRKnD3N7dA6T0YDbvpm8YBQHtJ7Q0KY0p1LGpxI2/2od/MYrNnwOP49PlG2+ZF8wJEwbdY7yJnZupoLFKwOosifDWhDa5DVRTkfYHWpcbhWsl+fRxSIw5CKfTQFKk3lmHIWSo3cBpvX13WdKfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKVq1FHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKVq1FHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319B3C4AF0E;
	Tue, 30 Jul 2024 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358234;
	bh=Ybyi2zcz2X+5sPTq9xhcD0nf2OeN0uNNjq9WGiXzRcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKVq1FHrKRqyDmm8THqFJR6x1DhC4bdRxlrtUeROTp5IBW7g2Vturtbv7IXe/dMky
	 Ugvko+FFeltnj2pADlVgwLi85kElvqkWZP+zLdYUUZ91V12iUe6cm/Ss0RpUdjIo+X
	 FcEKXIw8RErylJlxINK+Axzc8FKYQYEfVE8esXys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Jun Nie <jun.nie@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.10 337/809] drm/msm/dsi: set video mode widebus enable bit when widebus is enabled
Date: Tue, 30 Jul 2024 17:43:33 +0200
Message-ID: <20240730151737.930608286@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 007870b8eaf54739c7b417ddaf90bf364b7e4bc8 ]

The value returned by msm_dsi_wide_bus_enabled() doesn't match what the
driver is doing in video mode. Fix that by actually enabling widebus for
video mode.

Fixes: efcbd6f9cdeb ("drm/msm/dsi: Enable widebus for DSI")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Patchwork: https://patchwork.freedesktop.org/patch/596232/
Link: https://lore.kernel.org/r/20240530-msm-drm-dsc-dsi-video-upstream-4-v6-4-2ab1d334c657@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index a50f4dda59410..47f5858334f61 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -754,6 +754,8 @@ static void dsi_ctrl_enable(struct msm_dsi_host *msm_host,
 		data |= DSI_VID_CFG0_TRAFFIC_MODE(dsi_get_traffic_mode(flags));
 		data |= DSI_VID_CFG0_DST_FORMAT(dsi_get_vid_fmt(mipi_fmt));
 		data |= DSI_VID_CFG0_VIRT_CHANNEL(msm_host->channel);
+		if (msm_dsi_host_is_wide_bus_enabled(&msm_host->base))
+			data |= DSI_VID_CFG0_DATABUS_WIDEN;
 		dsi_write(msm_host, REG_DSI_VID_CFG0, data);
 
 		/* Do not swap RGB colors */
@@ -778,7 +780,6 @@ static void dsi_ctrl_enable(struct msm_dsi_host *msm_host,
 			if (cfg_hnd->minor >= MSM_DSI_6G_VER_MINOR_V1_3)
 				data |= DSI_CMD_MODE_MDP_CTRL2_BURST_MODE;
 
-			/* TODO: Allow for video-mode support once tested/fixed */
 			if (msm_dsi_host_is_wide_bus_enabled(&msm_host->base))
 				data |= DSI_CMD_MODE_MDP_CTRL2_DATABUS_WIDEN;
 
-- 
2.43.0



