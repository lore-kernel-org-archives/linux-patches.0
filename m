Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0937418E37C;
	Mon, 28 Oct 2024 06:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097229; cv=none; b=AJZDxgYlZ/wp0wsBCZ4QbPUDAvKr8cp0NtCKpUOqw9CFYbOBmEoWuEkCLJbIONa/1ecRELcggqT7VbD2Rn2blxgC7v1PfnR+ZukW48IP6bX4HtdPl3PFeyFveM9xixhsp9YFN94teic/j+Gk6i/iS8FCUfavCHJKBzB5mzrxxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097229; c=relaxed/simple;
	bh=aFcWet4muh65XQ7BB1W9u+I8XiuOcLq9rJW2UIsGH6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nheLjQh4lvNJRMz2leUmDJBtdahN8o2lNUfWhZrBd+5PLSNk9eUfS1T6DNMuYwStlPIr0exjrzTSzpF4g0EyxGYW7Md/W7gTg8E5CnTXWSDE0hlALJe9bacXfPSKxtIanAz1XHKNwkdEBC/u5TR0a73UrVytzu8O8g5Gk8G1EWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNh7Psur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNh7Psur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9CCC4CEC7;
	Mon, 28 Oct 2024 06:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097228;
	bh=aFcWet4muh65XQ7BB1W9u+I8XiuOcLq9rJW2UIsGH6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNh7PsurtG7Qi+/HdeZBZiQQmQFzU2P9iWJwpAu9Yn5sdTrMwYbPciNczIzIu7iqU
	 DyuMA9ggJq4n9PFMbL/EL59c0ZHDvOe+n0aFfYh9vhiR6eILeJYVAL90JeEmN6ELBy
	 C5CrOIvolPFjp+CEvAVzCEBKi4kdQfrB8C1LZyJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/137] drm/msm/dpu: Wire up DSC mask for active CTL configuration
Date: Mon, 28 Oct 2024 07:24:37 +0100
Message-ID: <20241028062259.842939133@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit cda3774c242e156cdcc279bd36b404af89f744c6 ]

Active CTLs have to configure what DSC block(s) have to be enabled, and
what DSC block(s) have to be flushed; this value was initialized to zero
resulting in the necessary register writes to never happen (or would
write zero otherwise).  This seems to have gotten lost in the DSC v4->v5
series while refactoring how the combination with merge_3d was handled.

Fixes: 58dca9810749 ("drm/msm/disp/dpu1: Add support for DSC in encoder")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/515693/
Link: https://lore.kernel.org/r/20221221231943.1961117-2-marijn.suijten@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: f87f3b80abaf ("drm/msm/dpu: don't always program merge_3d block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c | 1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index ce58d97818bcd..e05c3ccf07f8e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -61,6 +61,7 @@ static void _dpu_encoder_phys_cmd_update_intf_cfg(
 	intf_cfg.intf_mode_sel = DPU_CTL_MODE_SEL_CMD;
 	intf_cfg.stream_sel = cmd_enc->stream_sel;
 	intf_cfg.mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
+	intf_cfg.dsc = dpu_encoder_helper_get_dsc(phys_enc);
 	ctl->ops.setup_intf_cfg(ctl, &intf_cfg);
 
 	/* setup which pp blk will connect to this intf */
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index 2baade1cd4876..9232c646747dc 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -276,6 +276,7 @@ static void dpu_encoder_phys_vid_setup_timing_engine(
 	intf_cfg.intf_mode_sel = DPU_CTL_MODE_SEL_VID;
 	intf_cfg.stream_sel = 0; /* Don't care value for video mode */
 	intf_cfg.mode_3d = dpu_encoder_helper_get_3d_blend_mode(phys_enc);
+	intf_cfg.dsc = dpu_encoder_helper_get_dsc(phys_enc);
 	if (phys_enc->hw_pp->merge_3d)
 		intf_cfg.merge_3d = phys_enc->hw_pp->merge_3d->idx;
 
-- 
2.43.0



