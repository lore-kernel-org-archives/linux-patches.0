Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BAF35A957;
	Tue, 16 Dec 2025 12:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886717; cv=none; b=QTyTc4+ckhofQDc47tdx4jnd4jdl2Nj1WxqdXnlHrjMvPeqna/7TbQ4EnQCIMYnI1vRIYEjZF1UIIDSK6HoGSGCd1EPzs3A6/MFnIg6oO9Jf5V4saBf/puvmBsaFs//lfsdzvEjAb3AE9G1SVLwLQBtHuNEWTlQJPcncnlmnqUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886717; c=relaxed/simple;
	bh=13iwRFsfkrX5jSAKhZqz8QtDEdg8qOhC8TsIDI/jIOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPMjUPjEylEcIZshUGLR4yFSDyJwigsYk13eJHgZ7En3JCSwWqSW1EKUWQF9owFlFSnH8PbDC3gCl6AtM0PF4vbaK1eaO4k/ax9y/UEIt4e5OPJ+SlCD1jgArQArVNiz7GYzshkVfXI1NoJvxg/BKdF2yr+fQ+QCKD659pXo9xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUQ0dD1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUQ0dD1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF4C4CEF5;
	Tue, 16 Dec 2025 12:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886717;
	bh=13iwRFsfkrX5jSAKhZqz8QtDEdg8qOhC8TsIDI/jIOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUQ0dD1G2JAW1DYPBgac17iS7dRGuKU+MC6tPiNTA6fDOCysXHiLINxfH5ii93UXC
	 2dX3BMBb0mzY+ZnfTkMUMuIu1x4BwaGuc+Yl5M8P0HmoGnJT3TAzu1Op+CUAGEMPz+
	 7BHQyHCj0vCOaOY91zECq+anxj/mEwaFXTNpeMBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/614] drm/panel: visionox-rm69299: Fix clock frequency for SHIFT6mq
Date: Tue, 16 Dec 2025 12:06:19 +0100
Message-ID: <20251216111401.743830549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guido Günther <agx@sigxcpu.org>

[ Upstream commit d298062312724606855294503acebc7ee55ffbca ]

Make the clock frequency match what the sdm845 downstream kernel
uses. Otherwise the panel stays black.

Fixes: 783334f366b18 ("drm/panel: visionox-rm69299: support the variant found in the SHIFT6mq")
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250910-shift6mq-panel-v3-1-a7729911afb9@sigxcpu.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-visionox-rm69299.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-visionox-rm69299.c b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
index 909c280eab1fb..5491d601681cf 100644
--- a/drivers/gpu/drm/panel/panel-visionox-rm69299.c
+++ b/drivers/gpu/drm/panel/panel-visionox-rm69299.c
@@ -247,7 +247,7 @@ static const struct drm_display_mode visionox_rm69299_1080x2248_60hz = {
 };
 
 static const struct drm_display_mode visionox_rm69299_1080x2160_60hz = {
-	.clock = 158695,
+	.clock = (2160 + 8 + 4 + 4) * (1080 + 26 + 2 + 36) * 60 / 1000,
 	.hdisplay = 1080,
 	.hsync_start = 1080 + 26,
 	.hsync_end = 1080 + 26 + 2,
-- 
2.51.0



