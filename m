Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00136370AEE;
	Wed, 20 May 2026 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302055; cv=none; b=Apn9mGptU0Q/r5y+Sh6dfjdhcfUqe1PrxNt5BWSBtDTGy407HhkbO/zggsPpkZVQsek6Ke1eQ1+kgFVkV/sjtP7a2poz8gIawWXslaGe14uEHWGCke5wouUH21YcxYc9zkhbTagb3ekOKX853HVeaNWiRSRc+Gxa/ieAKPcJQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302055; c=relaxed/simple;
	bh=0eqiMnkI3tkSFrP0xANNbPlOjfcHJpTqlbxtE2bGW6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOWQLD9I5PyzTu8ZVm0CtBBJK4vREE9FFJoeAI7s6zWzkKypkc6I3gKAs/5rrtgT8TUl7Cby4Z1riPJ3SmSFCbuM1Z6rMKsoKFFldfYBVyvclBYnq/hlXJZKPbTCDTBSCQUh0tJSTqTi8wOzN+qyLdVO6R2bDsfExfxk/0uS4Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az54V+x1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az54V+x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D6D1F000E9;
	Wed, 20 May 2026 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302053;
	bh=qQ+80lnGJQMnXys+0mHwTgQ2C9ehN5hIB5Vq2DMw36E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=az54V+x1DryWWHj3tk2ul7dwYN36GDdV2omQCTalce5YsRZqs0zCyjsvNWhjmEKpD
	 XUTpyWyF8MJbGhSiByriZIeOGQd0HRL2oL2wdvXxzzAj2ORWehJavzyQWGEf0iO9yO
	 qjvxJEttprQKQvvw73WtIlFn/c6+SeAOqGTzJ6ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/508] drm/panel: sharp-ls043t1le01: make use of prepare_prev_first
Date: Wed, 20 May 2026 18:19:02 +0200
Message-ID: <20260520162101.206195854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 855e64444daa6..58f201720e699 100644
--- a/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
+++ b/drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c
@@ -224,6 +224,7 @@ static int sharp_nt_panel_add(struct sharp_nt_panel *sharp_nt)
 
 	drm_panel_init(&sharp_nt->base, &sharp_nt->dsi->dev,
 		       &sharp_nt_panel_funcs, DRM_MODE_CONNECTOR_DSI);
+	sharp_nt->base.prepare_prev_first = true;
 
 	ret = drm_panel_of_backlight(&sharp_nt->base);
 	if (ret)
-- 
2.53.0



