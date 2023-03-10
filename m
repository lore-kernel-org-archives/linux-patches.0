Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846AD847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB16C4339E;
	Fri, 10 Mar 2023 13:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456038;
	bh=jhaxRWmQKmtx8bWQQMmuBVSOH/DUlu+5uUz+dvRbf5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zV1tffSMy8NOGYLWWdajNhC5ImYDL/Gi67Y75KwN/D3IuMX8D7RYbISnIcCYYKbay
	 /TH/NjARNRRHJBQOWxpFgXKWXqBAZMy7SuoV3RbsV11qNuYaS+YcpP8CtX/g8vMGfT
	 /L9mSYB9V6iqummUqA1eZQiViz6YbxuKuP+7DUVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/193] drm/mediatek: Drop unbalanced obj unref
Date: Fri, 10 Mar 2023 14:37:21 +0100
Message-Id: <20230310133712.989190032@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 4deef811828e87e26a978d5d6433b261d4713849 ]

In the error path, mtk_drm_gem_object_mmap() is dropping an obj
reference that it doesn't own.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20230119231255.2883365-1-robdclark@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index f595ac816b555..1818980dafced 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -148,8 +148,6 @@ static int mtk_drm_gem_object_mmap(struct drm_gem_object *obj,
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
 			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
-	if (ret)
-		drm_gem_vm_close(vma);
 
 	return ret;
 }
-- 
2.39.2



