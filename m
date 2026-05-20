Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305DE2D12EE;
	Wed, 20 May 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295199; cv=none; b=TaxX19b/3fuLfccQvTyfrq67vCpom+8p6cwdZluMSijCJ1vCV2DU836N+qSO2eNqI4uzeIM4Uo4FFLL+1uZW4OiXFXqD3vS0jPAvQSCyjqe/J63Jid82IyyR75ZLpYvRDik1kNyAmj+7N7VRsCi+4+zd0zqWl2qXEiE3MJxXU5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295199; c=relaxed/simple;
	bh=v48o751rr3O+FwnPZ5qIdK+LHRWhmJnWrclFOXm6img=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWGVps4t93bko2BUrVWiSIjGOboY5vGCwODdOlXK+6oMHJgyr9MaGNJb4jq/7SBZzqsyds9C4nwbtsOEJ+9dKswUICnupZDSwAYR3sUXjtv2qt/IeoYeTIE6DxuIkgkMZAUdwcNqUyfWOMpAVWl8tFmbOwsYjMj/svk8tvVMHoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdzE5ESW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdzE5ESW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961301F000E9;
	Wed, 20 May 2026 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295198;
	bh=flYoLhmuXMuEV0rkdjSlLdAio74FFWn6yZcKGkNvxnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdzE5ESWP6W1O2bz1C0woZRCOecW5mdUePLY0nsbUXfhbOkSIDLS9pmxdf9Qs7iMR
	 x4pA3POtTFZsSdFlg82Y5Q18VM076kpJza/0ltwb06sUGWcKn+jvpBikFhogLwfmQG
	 f2xxiTsqBdJIQThBdX0TOePK8gn8NDUus/xA4ADI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0327/1146] drm/panel: sharp-ls043t1le01: make use of prepare_prev_first
Date: Wed, 20 May 2026 18:09:37 +0200
Message-ID: <20260520162155.597783922@linuxfoundation.org>
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



