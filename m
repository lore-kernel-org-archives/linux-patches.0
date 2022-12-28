Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59931863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5029DC433D2;
	Wed, 28 Dec 2022 15:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241974;
	bh=tEIvPMp4kMwLUPXD94BTnRMBf26PojhQFnfwSWUfszU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLr1WSXOP572CZxhctcxCf6cPg54/xBXOKF95Iyf2OOfIYMKuwW115q6TcdC41xOW
	 ghMnPhzFCAqgDzrJzK9KjCn/ODNIFPX5jE2AxZnrMQvOQqzJYAUkjqgz0+UOzb+8EJ
	 SJFVhIH/LnRzNsv9WMNZBPDWE5YAI9Vv1gCZeQzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0311/1146] drm: rcar-du: Drop leftovers dependencies from Kconfig
Date: Wed, 28 Dec 2022 15:30:50 +0100
Message-Id: <20221228144338.602451184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 1760eb547276299ab0c6a6cd3d29469e54ade615 ]

Commit 841281fe52a7 ("drm: rcar-du: Drop LVDS device tree backward
compatibility") has removed device tree overlay sources used for
backward compatibility with old bindings, but forgot to remove related
dependencies from Kconfig. Fix it.

Fixes: 841281fe52a7 ("drm: rcar-du: Drop LVDS device tree backward compatibility")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index fd2c2eaee26b..a5518e90d689 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -41,8 +41,6 @@ config DRM_RCAR_LVDS
 	depends on DRM_RCAR_USE_LVDS
 	select DRM_KMS_HELPER
 	select DRM_PANEL
-	select OF_FLATTREE
-	select OF_OVERLAY
 
 config DRM_RCAR_USE_MIPI_DSI
 	bool "R-Car DU MIPI DSI Encoder Support"
-- 
2.35.1



