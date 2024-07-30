Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A501A6169;
	Tue, 30 Jul 2024 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357062; cv=none; b=seJxYulWleBQIncUvKLziExCIjeXb1gNNz/S6jdhLenC/GyjBUFlNdWeoQfWU/lcSfK4yMWbuv59KK3xRVc2uvG9hB5ZTU6Lter67CPOdWUbetufXcVda0dLOgMKKHWOoGQjda/bxIrFdrpO9yBBlvSPweJxXDdhdjqZxAr2k28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357062; c=relaxed/simple;
	bh=XPcws5S3cElPhUpNRqLMX91/O1sJw7YfedqdBmIquVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpumP1otKFztVRcMu495b9L0ZQGdgUIOQlmKbKsCw0dvoJ5LRsfgIc/+P1lH9xnw3v1P+zrcIuh6Pvs4jaXBpuXuuj5OqHrAlPC8yfnvm3cBiJeNIFOyXlsPurJMPdcVyfu/0LC2jx7beMEtGXDmT4CXCnbo8XPLj1lgN0lo6gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlMwk3Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlMwk3Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2C7C32782;
	Tue, 30 Jul 2024 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357062;
	bh=XPcws5S3cElPhUpNRqLMX91/O1sJw7YfedqdBmIquVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlMwk3XhB0gsQ8bQnsKf+u1WaWJeXk1ny+UVu/mG7fz+7XnUSa/XWXFp9ESP6bDT8
	 i7G8Nhz/XiP7qPnu6PKd5a7RpE6DS1Q/XzJ0uMbw7LZokO4FBcj/HTMurl9YrVzngb
	 7jwHru8F+R3TTaenxBkzlY4aaYbYUc+67xw2/Nvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/568] drm/mediatek: Use 8-bit alpha in ETHDR
Date: Tue, 30 Jul 2024 17:45:21 +0200
Message-ID: <20240730151648.236568911@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 231c020141cb150a59f5b28379cad82ff7bad899 ]

9-bit alpha (max=0x100) is designed for special HDR related
calculation, which should be disabled by default.
Change the alpha value from 0x100 to 0xff in 8-bit form.

Fixes: d886c0009bd0 ("drm/mediatek: Add ETHDR support for MT8195")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-2-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_ethdr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_ethdr.c b/drivers/gpu/drm/mediatek/mtk_ethdr.c
index db7ac666ec5e1..5b5a0e149e0a3 100644
--- a/drivers/gpu/drm/mediatek/mtk_ethdr.c
+++ b/drivers/gpu/drm/mediatek/mtk_ethdr.c
@@ -50,7 +50,6 @@
 
 #define MIXER_INX_MODE_BYPASS			0
 #define MIXER_INX_MODE_EVEN_EXTEND		1
-#define DEFAULT_9BIT_ALPHA			0x100
 #define	MIXER_ALPHA_AEN				BIT(8)
 #define	MIXER_ALPHA				0xff
 #define ETHDR_CLK_NUM				13
@@ -169,7 +168,7 @@ void mtk_ethdr_layer_config(struct device *dev, unsigned int idx,
 		alpha_con = MIXER_ALPHA_AEN | MIXER_ALPHA;
 
 	mtk_mmsys_mixer_in_config(priv->mmsys_dev, idx + 1, alpha_con ? false : true,
-				  DEFAULT_9BIT_ALPHA,
+				  MIXER_ALPHA,
 				  pending->x & 1 ? MIXER_INX_MODE_EVEN_EXTEND :
 				  MIXER_INX_MODE_BYPASS, align_width / 2 - 1, cmdq_pkt);
 
-- 
2.43.0



