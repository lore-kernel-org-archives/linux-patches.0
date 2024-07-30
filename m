Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC53818C92A;
	Tue, 30 Jul 2024 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356061; cv=none; b=LOGxvHdmdniw49EL6XDKJ0+IIKIxX9qqCQGO9iFLljL3FZ3Nl7Keq2nwHn0BLx6lVG+UmYTdcwVy7WP49PHhJEJgKQrO1QgF6rzTBLoDPg89uoIfU3CVxSpgQZGcgP7/HM0ZEinxCI87fcOYdu94j0NMNQETf7MxroWKcPwB5Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356061; c=relaxed/simple;
	bh=NgFsJZuonOwYFRzu/+zVUhLA0Wos/dC7DymkNwNhPj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cwydu7rvr6iqf74ogWwSRkkJ1+vYfAWDR+A3MHuOTKPkWoyiG0oNPHAwLsb6Gc2Y1tSs4MR+fDFJkrjIuKQmyVR7cNlWMk8vJ8wCgLgs9oh8HCSKIjfemqDzgspbmY5f2c14PYma7MhCug/H/Wrj2+WTys/6XBKNdea3gzx/e/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdcNCHsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdcNCHsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4763C32782;
	Tue, 30 Jul 2024 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356061;
	bh=NgFsJZuonOwYFRzu/+zVUhLA0Wos/dC7DymkNwNhPj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdcNCHsIqfKbYlGuR/xqvrFUD7clqZ0yzQdNnGoSGruhhQVoX6Tdjv/DXB9axoFm1
	 CIq6VnJUtO1m1+J4V2WPqUnq2vlB3n8lEq2nrmLMP+98L/s7Y+u8btQ9ib99phjIG6
	 0ARAp42jU5x3p4mozhpEYJmzCDNJ7EsMAKphCIYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/440] drm/mediatek: Add OVL compatible name for MT8195
Date: Tue, 30 Jul 2024 17:46:25 +0200
Message-ID: <20240730151621.816762863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 6fb7a0985fd16868b5d72eb3e3de7524a6000e6e ]

Add OVL compatible name for MT8195.
Without this commit, DRM won't work after modifying the device tree.

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-7-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 25639fbfd374a..905275df09800 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -598,6 +598,8 @@ static const struct of_device_id mtk_ddp_comp_dt_ids[] = {
 	  .data = (void *)MTK_DISP_OVL },
 	{ .compatible = "mediatek,mt8192-disp-ovl",
 	  .data = (void *)MTK_DISP_OVL },
+	{ .compatible = "mediatek,mt8195-disp-ovl",
+	  .data = (void *)MTK_DISP_OVL },
 	{ .compatible = "mediatek,mt8183-disp-ovl-2l",
 	  .data = (void *)MTK_DISP_OVL_2L },
 	{ .compatible = "mediatek,mt8192-disp-ovl-2l",
-- 
2.43.0



