Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C1732ABC0;
	Thu, 28 May 2026 20:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998991; cv=none; b=hqavumxaId2UXDd5kuN5Kfgr9mrkMzzEAAzZX7efy2u4GfzY1lnaGMNrO11IkG3CqPTSUC40NHMTSQgS+kIM5zFuQnSLx3hhQn3wAhXwRHv8hPINL8oIOWsGwxu/pmPWEJaBJxZOn2/dCZlV2NzoBTB6XxdKbycDOR5VhoUfWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998991; c=relaxed/simple;
	bh=6EPvoQhRVNjeasYA98TS1UhvnXI5ETL9cSjUraPEDtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6k7JC6XUJKYzjRjmnJG3nwJ9LcKugGFvLy8e+Yote02lXRNU4X/01OuOHFLMZ7EWYR+4jjt6H4NeDfW6xT1yjB8X50i2CuWpFl2jo3a6lNaoRgEgl92icF9yOjrWE8MGQIac9Q9YGmVNFvIwh2QNzEMg4I9FV62w7xYRhxvgGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auTy0Beg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auTy0Beg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21281F000E9;
	Thu, 28 May 2026 20:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998990;
	bh=zgWVkeTZFAAIQuUVssLTYVZoz8qoDDphcS07vFyOATI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auTy0BegW0N6qcuo3ykBrX2pDVHWEsV0hY0NAzuenpIPD5OhpaxEgs2cmbMXRs7/9
	 u4HvinDEQAT3ycaSxceRLouRI8fuV51C4x9rIzGXQCLtEtTMy6bfogydjK76+CX0Vc
	 Q8I5RBqOgFxhs9HkzHj9J9+sCj7gUhV+OPIiTFa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 370/461] drm/mediatek: mtk_hdmi_v2: Fix non-static global variable
Date: Thu, 28 May 2026 21:48:19 +0200
Message-ID: <20260528194658.154024865@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit dc245d9a7f1b06f86271d4e524d6e5634c5ce312 ]

The struct 'mtk_hdmi_v2_clk_names' is not used outside of the
mtk_hdmi_v2.c file, so make it static to silence sparse warning:
```
drivers/gpu/drm/mediatek/mtk_hdmi_v2.c:53:12: sparse: warning: symbol
'mtk_hdmi_v2_clk_names' was not declared. Should it be static?
```

Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT8188")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604132044.fcYjEcU8-lkp@intel.com/
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20260429-mediatek-drm-fix-sparse-warnings-v1-2-d95c4d118b83@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c b/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
index 279ca896b0a2a..6cdad4415475b 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
@@ -50,7 +50,7 @@ enum mtk_hdmi_v2_clk_id {
 	MTK_HDMI_V2_CLK_COUNT,
 };
 
-const char *const mtk_hdmi_v2_clk_names[MTK_HDMI_V2_CLK_COUNT] = {
+static const char *const mtk_hdmi_v2_clk_names[MTK_HDMI_V2_CLK_COUNT] = {
 	[MTK_HDMI_V2_CLK_HDMI_APB_SEL] = "bus",
 	[MTK_HDMI_V2_CLK_HDCP_SEL] = "hdcp",
 	[MTK_HDMI_V2_CLK_HDCP_24M_SEL] = "hdcp24m",
-- 
2.53.0



