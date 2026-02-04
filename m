Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A41426D02;
	Wed,  4 Feb 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217599; cv=none; b=OvzAzK5VnQES8hNM4OOKOdluugIB9en0914mLbCYz+pO1NTYKB3WPWrZ/aZfDRuW4ResbjH03V2neLULah4s4Qw+7T3vv9xT1DaQqQx0EDRrNjC9mKD42CShbNLcfoouX6zBH7nt3XRTx47UGVrgHk1KwvG8DwoajYJWvzKv6U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217599; c=relaxed/simple;
	bh=0XaFGF3nx2X+QMfECckchm5CJ93d9u+8T6L4I/sCp5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/CpZnOwdBF14gHzzgQcDNSh+JAdS+LMtLr9pmD2zdTc55SbLBu+sGPwIoEXpgSb5aJVAAcMmOl91tac4zi6Omv+DJ5UYOf4JUH7jlGL+/WpcUFgG28rsbsB0TONxKrdYssod2y3VUEMo7pvMIMhmplvASYtjWrZ6oZqw9cVI98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqQlGDea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqQlGDea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDB9C4CEF7;
	Wed,  4 Feb 2026 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217599;
	bh=0XaFGF3nx2X+QMfECckchm5CJ93d9u+8T6L4I/sCp5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqQlGDeaXC1WAX8joHrNwHt0Hu+V6B9GV95x6RTKNAOB98UTpTIv3bsCwOW3mpdsb
	 JoCuy/Dyif/xyLGdd9qjdFz5+P9TgHRJ78sHqbmRvynoCi9rG38N+9YayYUBm6j3+G
	 LLgoxj5mdvz3zhnrcbTvnMBu59rA5XTlYCkeJovo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 064/280] drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel
Date: Wed,  4 Feb 2026 15:37:18 +0100
Message-ID: <20260204143911.957946057@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit 6ab3d4353bf75005eaa375677c9fed31148154d6 upstream.

The connector type for the DataImage SCF0700C48GGU18 panel is missing and
devm_drm_panel_bridge_add() requires connector type to be set. This leads
to a warning and a backtrace in the kernel log and panel does not work:
"
WARNING: CPU: 3 PID: 38 at drivers/gpu/drm/bridge/panel.c:379 devm_drm_of_get_bridge+0xac/0xb8
"
The warning is triggered by a check for valid connector type in
devm_drm_panel_bridge_add(). If there is no valid connector type
set for a panel, the warning is printed and panel is not added.
Fill in the missing connector type to fix the warning and make
the panel operational once again.

Cc: stable@vger.kernel.org
Fixes: 97ceb1fb08b6 ("drm/panel: simple: Add support for DataImage SCF0700C48GGU18")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260110152750.73848-1-marex@nabladev.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-simple.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1518,6 +1518,7 @@ static const struct panel_desc dataimage
 	},
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
 static const struct display_timing dlc_dlc0700yzg_1_timing = {


