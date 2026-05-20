Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E92433A9CF;
	Wed, 20 May 2026 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295179; cv=none; b=BRKo96jT3RHw41LtVoADctIrPYWhYcxyexcL0YyJsm0A4dlA5o+HYy9wThgufNt4p63LA/eWwT8kkPiL2/UcULuU/k2UHGHVLyBzsi5L4VGbV2DZmpW6eDZV3OShXWRQgnCY5dpCkITw5GK70roa7Oe+bYPo9sSQub7M6oJhJGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295179; c=relaxed/simple;
	bh=i0YPtSDERGGcIP/4nN3c2+7WR3abBL7jPPB00kO073k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzwbcLS8efh/8ILivQqbF4t2HpMB2YkPcwm0yhncX2Eps2KY6ZX4+RYDEv7qKOvN+AT67gVSNk2O+4yfysEikUzeYZyfO1pSH65oERl2Xn3cW7qibaIVqUcxNvHovTWAc80Ali3MJbeOlbSdolX2xE3fu3jTJ7CrZsQ88qiKf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UozjPxU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UozjPxU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C3F1F00893;
	Wed, 20 May 2026 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295177;
	bh=6F1ddngqQFFCUkbQiaAj1XQhPHsSDAr5V4+KdHXzZ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UozjPxU3Gcd3d6b8Bb5I+2xCml9dH0HFMVpdgq0WD8Htp3NLGqYiHEU3brhYN9mIA
	 Zr24yRmETHdVR7o5ApXNZoXQbTqG+dl8yFOLyC/ejWGAUYyOohDwUq0O9H5hfxl55j
	 GnfMFhp2U/x995dzOzhc98zdWEh+lgf29e7c0keo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0320/1146] drm/msm/dsi: add the missing parameter description
Date: Wed, 20 May 2026 18:09:30 +0200
Message-ID: <20260520162155.440030420@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 958adefc4c0fddee3b12269da5dd7cb49bac953f ]

Add a description for is_bonded_dsi in dsi_adjust_pclk_for_compression
to match the existing kernel-doc comment.

Fixes: e4eb11b34d6c ("drm/msm/dsi: fix pclk rate calculation for bonded dsi")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603080314.XeqyRZ7A-lkp@intel.com/
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/710112/
Link: https://lore.kernel.org/r/20260309100254.877801-1-mitltlatltl@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index db6da99375a18..6cb634590e7a7 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -569,6 +569,7 @@ void dsi_link_clk_disable_v2(struct msm_dsi_host *msm_host)
  * dsi_adjust_pclk_for_compression() - Adjust the pclk rate for compression case
  * @mode: The selected mode for the DSI output
  * @dsc: DRM DSC configuration for this DSI output
+ * @is_bonded_dsi: True if two DSI controllers are bonded
  *
  * Adjust the pclk rate by calculating a new hdisplay proportional to
  * the compression ratio such that:
-- 
2.53.0



