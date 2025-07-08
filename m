Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E552E6D2A;
	Tue,  8 Jul 2025 16:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993984; cv=none; b=O+Wf7d4o19p08am+/z94Hyyf8pP/dOgDlaWiFd+ToxSN7ntCJmurBz1UX+X6K3oQVc3uHIdk2X+hkxOFXW4hKQbTca2fMWM1dRLmvIrnmDxVjnynSrr/LG6SbHUkKex7gBZ70r7xfSEM9Rkp+NTESrW7Hp8teo+7n1VSWp9efFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993984; c=relaxed/simple;
	bh=5B1ZyrtmtA40612pWnqOptVc1XGN6IRSZ2iqlpluKZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7kqqKJHQ5ZhMtrmdQlGWLgbWhrEnxDyOTobYFMHbrBnMyTVGH0al5GSEU9rZJfFgBE3jxvv58iJoLtsOs90FIfK0rNWeYWr0+v17vN7KvP84tZpIV5M8zHkgaObIELztOCgGNrn6VIQE3vi41INjwimtJl4dLD4s4JFI1nqqZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nADmwMXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nADmwMXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A5AC4CEF5;
	Tue,  8 Jul 2025 16:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993983;
	bh=5B1ZyrtmtA40612pWnqOptVc1XGN6IRSZ2iqlpluKZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nADmwMXaZh4UMbl/udKFja4tyMAgeoV7Kr+H/C3g0qn1ZFTqCJ27Btaqbp7D5QsPu
	 MpC5VCOk52RtUuNZHgHOCvmAxsPcbOZL0jFH1Mc+GQXUTp0sblekDkslnH0sOG1B9m
	 DXJsHV5T3heMW1eXlV1dsOCiWB6NWLhOMykOKiK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.15 086/160] drm/bridge: cdns-dsi: Check return value when getting default PHY config
Date: Tue,  8 Jul 2025 18:22:03 +0200
Message-ID: <20250708162233.900786242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -615,9 +615,11 @@ static int cdns_dsi_check_conf(struct cd
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


