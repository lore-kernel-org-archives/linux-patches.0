Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E22267B01;
	Tue, 25 Mar 2025 12:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905839; cv=none; b=aSPc2lpyF+MsEVortnFcEmfm5GnOe06wTpBoKL3jQBz6UjoVxQ2XR2h/c4Md04KyCbiO61a009oZI3uqwGDRFS00BDasOHkMfxceQcYCqChereg02gBFcXvln1O4+BDlogqkP6FQfkFMzioN0SqMTq1DQVXjj2Z+r9qD1+l2cj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905839; c=relaxed/simple;
	bh=A4ZbTQ2FdbW2s5/ZKy++UrgTrKUzc/Ytw0ZPQF/MQvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI0CJsrukUr+I+JR0rbBqV5wO2O4EhkQb2In0X2lpeAuoH9sbMNODXfpArJjsrRXsXX6uJzF3Wy4Cg/1NKSokPelMY+idElS56M74CN/AcR4FVBCYupk5ip6Z1PnEGDcbCujEq2vUAILxk1vx77TvZRNNq1yoi4raMLI9s20nMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hk9Rlzs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hk9Rlzs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE09FC4CEED;
	Tue, 25 Mar 2025 12:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905839;
	bh=A4ZbTQ2FdbW2s5/ZKy++UrgTrKUzc/Ytw0ZPQF/MQvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hk9Rlzs3VGg3wdeMv7sjmR9hGdJExjlnMX1HxohQEhuMSPE3qJTGTga9l1BDMONdW
	 U0RC/v1ZIJL5/qTZgeGPRRDgOgZ6Qsyw6n1fMuTPMn5CVcPJ7XRcWln0y7iakYaKqE
	 BH/BdoZcwcuE/xJ0abs3Q+urgPNnQ2955ghcDOrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 191/198] drm/mediatek: Fix coverity issue with unintentional integer overflow
Date: Tue, 25 Mar 2025 08:22:33 -0400
Message-ID: <20250325122201.660162861@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

commit b0b0d811eac6b4c52cb9ad632fa6384cf48869e7 upstream.

1. Instead of multiplying 2 variable of different types. Change to
assign a value of one variable and then multiply the other variable.

2. Add a int variable for multiplier calculation instead of calculating
different types multiplier with dma_addr_t variable directly.

Fixes: 1a64a7aff8da ("drm/mediatek: Fix cursor plane no update")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20230907091425.9526-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
[ For certain code segments with coverity issue do not exist in
  function mtk_plane_update_new_state(), those not present in v6.1 are
  not back ported. ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c   |    9 ++++++++-
 drivers/gpu/drm/mediatek/mtk_drm_plane.c |   13 +++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -119,7 +119,14 @@ int mtk_drm_gem_dumb_create(struct drm_f
 	int ret;
 
 	args->pitch = DIV_ROUND_UP(args->width * args->bpp, 8);
-	args->size = args->pitch * args->height;
+
+	/*
+	 * Multiply 2 variables of different types,
+	 * for example: args->size = args->spacing * args->height;
+	 * may cause coverity issue with unintentional overflow.
+	 */
+	args->size = args->pitch;
+	args->size *= args->height;
 
 	mtk_gem = mtk_drm_gem_create(dev, args->size, false);
 	if (IS_ERR(mtk_gem))
--- a/drivers/gpu/drm/mediatek/mtk_drm_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
@@ -120,6 +120,7 @@ static void mtk_plane_update_new_state(s
 	struct mtk_drm_gem_obj *mtk_gem;
 	unsigned int pitch, format;
 	dma_addr_t addr;
+	int offset;
 
 	gem = fb->obj[0];
 	mtk_gem = to_mtk_gem_obj(gem);
@@ -127,8 +128,16 @@ static void mtk_plane_update_new_state(s
 	pitch = fb->pitches[0];
 	format = fb->format->format;
 
-	addr += (new_state->src.x1 >> 16) * fb->format->cpp[0];
-	addr += (new_state->src.y1 >> 16) * pitch;
+	/*
+	 * Using dma_addr_t variable to calculate with multiplier of different types,
+	 * for example: addr += (new_state->src.x1 >> 16) * fb->format->cpp[0];
+	 * may cause coverity issue with unintentional overflow.
+	 */
+	offset = (new_state->src.x1 >> 16) * fb->format->cpp[0];
+	addr += offset;
+	offset = (new_state->src.y1 >> 16) * pitch;
+	addr += offset;
+
 
 	mtk_plane_state->pending.enable = true;
 	mtk_plane_state->pending.pitch = pitch;


