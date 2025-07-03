Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3227B1D5CE5;
	Thu,  3 Jul 2025 15:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556219; cv=none; b=RG1gHPingY2ao7RrlycGVH7pbA0W06oVl3BkVzYV+rpvhmnbgWxDm/nyEk2CRvR9Rh/xYy4tYPHVCcxn0C+9c/7RxyAzOjgozjGMRcJwrkH96kgBEdCntKENyjWnM4vdnpSL6kO+/BgMihY7SCG3YrC5uhTM8b/mjBKVKr1ONHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556219; c=relaxed/simple;
	bh=a9+hZGKvQqfHQRz6J71P+7dOdAy7jhaNx442ENwmLYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG7QasDJjqgVhdQRH42LoD+Jr1LIapEzmhswOjO9YaR6tWLuo/dyBx4q3cqFdQb1sWnDHELagLMAMXSK/pcZhfeEyHW3S5/VDXEly73K3tFGqdFXngmQLJCvUbL9L6Yo8bY2xkmUPrJ2okOlqyfmRafc1a+NvpqTlRHvfs6Za9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxvcP8pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxvcP8pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B18C4CEEE;
	Thu,  3 Jul 2025 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556218;
	bh=a9+hZGKvQqfHQRz6J71P+7dOdAy7jhaNx442ENwmLYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxvcP8pm+em2OqSv2I95xJnwkt7AkeAX3ks1voymvCILhHR+KPnLLxOaRdfzuks6+
	 0Yu/onX93lT3cpi62K9I4Wpx+Kk84qsAhKDhILXJ1mbTwRPFkSVhYUoNwE1U6AVqLk
	 7TrKppa7F64b7oNDCMchsylWuMNfCV0V6QnkEoWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 6.1 111/132] drm/bridge: cdns-dsi: Check return value when getting default PHY config
Date: Thu,  3 Jul 2025 16:43:20 +0200
Message-ID: <20250703143943.749298670@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aradhya Bhatia <a-bhatia1@ti.com>

commit c6a7ef0d4856b9629df390e9935d7fd67fe39f81 upstream.

Check for the return value of the phy_mipi_dphy_get_default_config()
call, and in case of an error, return back the same.

Fixes: fced5a364dee ("drm/bridge: cdns: Convert to phy framework")
Cc: stable@vger.kernel.org
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Link: https://lore.kernel.org/r/20250329113925.68204-5-aradhya.bhatia@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -616,9 +616,11 @@ static int cdns_dsi_check_conf(struct cd
 	if (ret)
 		return ret;
 
-	phy_mipi_dphy_get_default_config(mode_clock * 1000,
-					 mipi_dsi_pixel_format_to_bpp(output->dev->format),
-					 nlanes, phy_cfg);
+	ret = phy_mipi_dphy_get_default_config(mode_clock * 1000,
+					       mipi_dsi_pixel_format_to_bpp(output->dev->format),
+					       nlanes, phy_cfg);
+	if (ret)
+		return ret;
 
 	ret = cdns_dsi_adjust_phy_config(dsi, dsi_cfg, phy_cfg, mode, mode_valid_check);
 	if (ret)


