Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCFD1A6166;
	Tue, 30 Jul 2024 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358123; cv=none; b=C0FwcfuUiZp1RRAOs5f0OvHWESCMeT7VBXl7yzi/u2SaBO/P/oQkAYolnmYx+bPeFVfkbF3/OfLmnpOyCX4SbIrO/VuY24yBY7Dlg9sw1mA1a5WTNqnqKPYUBlLuvaTx61jxh6BV12m7Kc6QarT3plxFdtIIWFJjK87r7J/Ql/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358123; c=relaxed/simple;
	bh=fkU3gbX66wVHEkMgtsObgYFOETqeawzfdl/5c48QVOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv9P/Yws7vlMSCanQzf2izldkI7q/XTEO72QC5i3YwO7n9RSDu4AJytZRAuF1NtBAnE9SG7P62xyeseVAjuUHxdEGH3qxc3LPzmbXqa4U7tsoayqlwNOk7L9j5a2No7BAW6fSa0oAhzie+QbvbWpdYW5t9nj9UKCAqfXzDBt/Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns8irEWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns8irEWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20C2C32782;
	Tue, 30 Jul 2024 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358123;
	bh=fkU3gbX66wVHEkMgtsObgYFOETqeawzfdl/5c48QVOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ns8irEWjJOcz9EuKOMQk36uE55RTXCfX/sJwfg2krq1kISsEmwKIQYz1fDVeVbFY5
	 XU6RRVl6ht8RRtz+V+x40B5qwSUNq1cHrG0qhae3QIdMv+r5X+n9BYhgeN7agvp8WW
	 k7oPg357rVpZdR485JLEiZSYYVv3jkbkGLleZolg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 325/809] drm/mediatek: Use 8-bit alpha in ETHDR
Date: Tue, 30 Jul 2024 17:43:21 +0200
Message-ID: <20240730151737.441754233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 156c6ff547e86..d7d16482c9473 100644
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



