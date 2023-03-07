Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CABBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E790C433EF;
	Tue,  7 Mar 2023 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212869;
	bh=bgJat9e200h2YSsyIdzGEs6f6MG3hxGIJfbxabKFI2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igqvCew5DzzZGe+8+RZaRDyJN/87ZS6rkL1lFG/yknyQVyo42SGSwkrOYV84dIXC3
	 Lxz43Ye9t+rapIAiWnfLw4TkI9ltMPnys9lhcLFcu6hYRU1Q5EbyxqO629VKjbl+0o
	 8sv0Lwk/+0hYV46YYuuCueFdqhgg8hZ5ruwQiP8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Chen <miles.chen@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 324/885] drm/mediatek: Use NULL instead of 0 for NULL pointer
Date: Tue,  7 Mar 2023 17:54:18 +0100
Message-Id: <20230307170016.250086110@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit 4744cde06f57dd6fbaac468663b1fe2f653eaa16 ]

Use NULL for NULL pointer to fix the following sparse warning:
drivers/gpu/drm/mediatek/mtk_drm_gem.c:265:27: sparse: warning: Using plain integer as NULL pointer

Fixes: 3df64d7b0a4f ("drm/mediatek: Implement gem prime vmap/vunmap function")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20230111024443.24559-1-miles.chen@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index 47e96b0289f98..06aadd5e7f5ba 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -262,6 +262,6 @@ void mtk_drm_gem_prime_vunmap(struct drm_gem_object *obj,
 		return;
 
 	vunmap(vaddr);
-	mtk_gem->kvaddr = 0;
+	mtk_gem->kvaddr = NULL;
 	kfree(mtk_gem->pages);
 }
-- 
2.39.2



