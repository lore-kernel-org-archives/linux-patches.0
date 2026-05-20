Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F178E36A376;
	Wed, 20 May 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298016; cv=none; b=V2EzqcxQX+7CFJriLcXrKLg1D2nI68v1si3euZg/98P0qr1Ntvyi0r8bzikIcKcQSr8DGVe9opdPX8B+mzpssGXaHlmyC0fURTgafdAmBxPj+VYKC+SvBu4qRL2odcSDNB6kRUpxxWGm52hsoZH8YK1GQk2BIZ4PnWJmkEZg06M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298016; c=relaxed/simple;
	bh=5697+wn7isz1c78Gidnv9XybDAC3dFum00y5HLD7kiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duh7I8RNZNdcaUZVk1ow1obDZ/6X9vI2TRKKrzfigUI4CHKhyzsUNYar+sX4919CmjOcz1WOuyWN9V3MjUK8D2Bwk1WxIiyg+PaHtRdXyjPfcIRxQ4W7OJIu8HpXyzjvjDLzqySnzki6zuJMdkv36a4qyfUOc43oFjtHgYvGvUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx2YjHKD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx2YjHKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632711F000E9;
	Wed, 20 May 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298014;
	bh=PXhz9n0aDodIPOZM2s+pCXvWX87hHTbk14HmACcKxz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gx2YjHKDmG4mmpvWHCkwjnZ0O5lKNHrca2j9CVtlFVjcLb8QPa1ouuUGDwcVk5kCw
	 DtiSbC8Zne8yh3VCjBFV7YBzfC8xUXGHLZ4avDZTrMCeHHfyAySYPxrncmDiy7sSDg
	 QypJQ3EJUThkntBYmUGSvRjuLPtD8uSt+/4yvA7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/957] drm/panel: sharp-ls043t1le01: make use of prepare_prev_first
Date: Wed, 20 May 2026 18:12:12 +0200
Message-ID: <20260520162139.943774757@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit c222177d7c7e1b2e0433d9e47ec2da7015345d50 ]

The DSI link must be powered up to let panel driver to talk to the panel
during prepare() callback execution. Set the prepare_prev_first flag to
guarantee this.

Fixes: 9e15123eca79 ("drm/msm/dsi: Stop unconditionally powering up DSI hosts at modeset")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260323-panel-fix-v1-1-9f12b09161e8@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
index 36abfa2e65e96..dd1eaba23ad3c 100644
--- a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
+++ b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
@@ -201,6 +201,7 @@ static int sharp_nt_panel_add(struct sharp_nt_panel *sharp_nt)
 
 	drm_panel_init(&sharp_nt->base, &sharp_nt->dsi->dev,
 		       &sharp_nt_panel_funcs, DRM_MODE_CONNECTOR_DSI);
+	sharp_nt->base.prepare_prev_first = true;
 
 	ret = drm_panel_of_backlight(&sharp_nt->base);
 	if (ret)
-- 
2.53.0



