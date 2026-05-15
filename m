Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078943FF1D5;
	Fri, 15 May 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860436; cv=none; b=hTTf+hJkJ8Ac9TBATbCTWBVca7ImcY0a8y/K/4s/w4sVQM/EiaLNxI4SQ9ALhD1mvCR2ElHh+QGczlFvQ3oMioxW2LX8iyRo5HDwnYXiUpD3Tn1MKwEem9JPd7yiVIWGzRWzp9q3RJJ0kXB5x971a2ET5NuludKlCJD+zQK/V+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860436; c=relaxed/simple;
	bh=Zrj3yu+HYKQBrbHFm0CPOTe96AQ0uiZI0FYx5YMv/ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNWG7RdRNRGYu7oUpsxaXrUr4o9jcMuhztaGDuPe/yMVtLQJ/3I0sWLGdSkdrUFOdfbxWtI9cu3xjNGib8/cwPPgx1hQkkqCb9FaF3FzWmxMvhvi4WjxTJFUrYSBUXbs/qDBsUHNNKvf3oWdS1y2bh2R62K4KL/xW1zh5IZJN8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLKe6L3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLKe6L3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC0C2BCB0;
	Fri, 15 May 2026 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860435;
	bh=Zrj3yu+HYKQBrbHFm0CPOTe96AQ0uiZI0FYx5YMv/ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLKe6L3bes4oQPDCR0OVr/ezwDWiC8i5rC3skoZ+SlYjmZV0xOdLL4aQ3On4x5lvd
	 1VWVDhGCJ3II2aCVqp50w9Va30B7mJkci6hH/AKd14CUdwRdIykodNbcQZpjf4ByG9
	 UJ4uLeIGkRnOcdSzfKr5iPl6vruYxxkvKqkr926Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.12 088/144] drm/panel: boe-tv101wum-nl6: restore MODE_LPM after sending disable cmds
Date: Fri, 15 May 2026 17:48:34 +0200
Message-ID: <20260515154655.561842451@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

commit 570cf799e87ae805eacfab3b4ba66676b5fccdb6 upstream.

When preparing the panel, it seems that it always expects commands to be
transferred in LP mode. However, the disable function removes the
MIPI_DSI_MODE_LPM flag, and no other function re-adds it.

As the unprepare function contains no DSI commands, re-adding the flag
just after disabling the panel should be safe. Add the code re-adding
the flag after the two commands for disabling the panel are sent.

This fixes error messages shown in kernel log when unblanking on
mt8183-kukui-kodama-sku32 device.

Cc: stable@vger.kernel.org
Fixes: a869b9db7adf ("drm/panel: support for boe tv101wum-nl6 wuxga dsi video mode panel")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260503091708.1079962-1-zhengxingda@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1324,6 +1324,8 @@ static int boe_panel_disable(struct drm_
 	mipi_dsi_dcs_set_display_off_multi(&ctx);
 	mipi_dsi_dcs_enter_sleep_mode_multi(&ctx);
 
+	boe->dsi->mode_flags |= MIPI_DSI_MODE_LPM;
+
 	mipi_dsi_msleep(&ctx, 150);
 
 	return ctx.accum_err;


