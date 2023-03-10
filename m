Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859F78489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054C5C433EF;
	Fri, 10 Mar 2023 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457854;
	bh=NcwJ6vA85FbkYaWlA0Fly12yASk8zbKCCk3RyGr+RBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJ2rbzijcXnqatI2UeXrn3he/QwhxAjqxzaxMlMh8eDSTbiE4kJK5yJ5z8lkqoZu2
	 rwuQtGtUwhG67KSlgvlyyJ6wLiquuZfREGqDxU3PoqnYQLixJ4ub+cVs0896uSgkYk
	 eYefVdY7qWW7hD7vVyKAad2pfNGcUYtmbtXTwYm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/252] drm/mediatek: Drop unbalanced obj unref
Date: Fri, 10 Mar 2023 14:37:30 +0100
Message-Id: <20230310133721.245797489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
index 259b7b0de1d22..b09a37a38e0ae 100644
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



