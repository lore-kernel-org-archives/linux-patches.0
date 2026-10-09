Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF7B2BE7CD;
	Fri,  9 Oct 2026 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556091; cv=none; b=csN1v5p6v6dxl12p8REGsw+h6Pa6zdmbYcqyWoL80JPIPdgr+fauE5iMkBtSBCkeOIxSLl0HLdU1dUulhDHQelrpKJoOQt+rYBg6NRREjiF2Q6VZ1bowxPlYlLsIwvnaA6g6ktob+AdKIv6xzpxVih6frkvr9O8baeywB3UkpTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556091; c=relaxed/simple;
	bh=KVqrlwzIEKlblMQheavIoKE1yNfuQEa5ZlbZVT5/E0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fO4IBbRN21+lV/MKFR2uK8lSF+goFwDzu1qnUNGa4QqIiWpiAscrSwgu4ZLbsjFItzWotDKhqnxpRSrmWl5gnihtWDcIt8AoFF+4Jp5vmYTrBAin8sZekc7A6Wjq4xTTLrI9l6j13WfvjqwwDDTh9NAY3YQ1uDtD9KorJSE6wX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHsNWLR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHsNWLR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5EE1F000FF;
	Fri,  9 Oct 2026 14:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556090;
	bh=MilS29canKjiI1Sv7n8FbFV0VuSoogM8dfdSJ0689hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHsNWLR2SVJj+1je4YaBjJB2c+r/5vs2dm9AsMV2s6b2cft39EcSnqXKbEKH2t/rw
	 qb7J6OldLiJEzUE2i0pIIgAwD4pj3AjJbd8STCdUp/qANuZSIR9B88w/g6dqMvvhhl
	 dE/lN5hQ46cZ8/Cv1VECDBpKiN8VhWb/RmgsB06w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Stephan <jstephan@baylibre.com>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 119/428] drm/mediatek: mtk_hdmi_v2: fix VID_DOWNSAMPLE_CONFIG register offset
Date: Fri,  9 Oct 2026 16:07:36 +0200
Message-ID: <20261009140948.808644194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julien Stephan <jstephan@baylibre.com>

[ Upstream commit 3e292c56bf5e338efcda7f9bfa603180855cd1be ]

According to the datasheet, VID_DOWNSAMPLE_CONFIG is at offset 0x8f0;
0x8d0 is the VID_CSC_COEFF_0 register.

Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT8188")
Signed-off-by: Julien Stephan <jstephan@baylibre.com>
Reviewed-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260828-mtk-hdmi-v2-fix-register-offset-v1-1-118ad5d7ebe3@baylibre.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_regs_v2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_regs_v2.h b/drivers/gpu/drm/mediatek/mtk_hdmi_regs_v2.h
index 521b35c7e14d3..bf3ebf5492d15 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_regs_v2.h
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_regs_v2.h
@@ -173,7 +173,7 @@
 #define  TPI_AUDIO_LOOKUP_EN		BIT(2)
 
 /* Video downsampling configuration */
-#define VID_DOWNSAMPLE_CONFIG		0x8d0
+#define VID_DOWNSAMPLE_CONFIG		0x8f0
 #define  C444_C422_CONFIG_ENABLE	BIT(0)
 #define  C422_C420_CONFIG_ENABLE	BIT(4)
 #define  C422_C420_CONFIG_BYPASS	BIT(5)
-- 
2.53.0



