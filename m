Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2811519AA;
	Wed,  5 Feb 2025 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764151; cv=none; b=lMxaO5qaADWOV2Yg2qCpFWflDNqtURK2Yx3IoBFjca4YUb4vYKsHpx3g88bkO5Nvn7bcj8j4Jgy0EBJZD+NLgLi5dt1+KvYueFVKu0aWvSwvMyHoIVi8MCJPHMVeuDa3ssbXGVfbKVj7SkTJG8bGMYK4SeKaQbQt24fOXqlpEEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764151; c=relaxed/simple;
	bh=rG2FPAYK60pBFcwVvqKpprHElkwfs/s2fVw2sWlcPCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF0AuSx2MiQPrsblcSdmAxoYVcraWBju2wTYp2qD0Ka+30DUF3D8XYyKpYLTTi/vFMCzluPdreJQd9wMHrV0GDqbATDwBAq6p9a2zhZBS9aQRDkDWI+KQvXvAajpu7spJdxUULmosQXpmb/ZvZfxwygTYjIUW+xhijzur4VW5H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfSe5qwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfSe5qwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3CCC4CED6;
	Wed,  5 Feb 2025 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764151;
	bh=rG2FPAYK60pBFcwVvqKpprHElkwfs/s2fVw2sWlcPCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfSe5qwT0w7JU0zeUmfM2UJUET4g5bGZk4PNlY4GpyYiaTGW3tWu/mEuP8OqOCDit
	 8o+cNjUxYCwBJWOI5DxSHvimb4V07dE/9EOBoeXqr/nMkRrTXHcvFP0WmCxKptEeN0
	 rW3pQ/vDvDVu3VjMSUOF2xARzpfd28AID41/aOL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 052/623] drm/msm/dp: dont call dp_catalog_ctrl_mainlink_ctrl in dp_ctrl_configure_source_params()
Date: Wed,  5 Feb 2025 14:36:34 +0100
Message-ID: <20250205134458.220491666@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 50e608d166ba68faacf81a5ce17c09b0c697eefd ]

Once the link has already been setup there is no need to call
dp_catalog_ctrl_mainlink_ctrl() as this does a reset on the mainlink
thereby tearing down the link briefly.

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/627479/
Link: https://lore.kernel.org/r/20241205-dp_mst-v1-1-f8618d42a99a@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index bc2ca8133b790..a8069f7c4773f 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -178,7 +178,6 @@ static void msm_dp_ctrl_configure_source_params(struct msm_dp_ctrl_private *ctrl
 	u32 cc, tb;
 
 	msm_dp_catalog_ctrl_lane_mapping(ctrl->catalog);
-	msm_dp_catalog_ctrl_mainlink_ctrl(ctrl->catalog, true);
 	msm_dp_catalog_setup_peripheral_flush(ctrl->catalog);
 
 	msm_dp_ctrl_config_ctrl(ctrl);
-- 
2.39.5



