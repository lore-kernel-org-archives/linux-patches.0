Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8091A617E;
	Tue, 30 Jul 2024 16:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357104; cv=none; b=d+4ir/6lsVXf43skA527VtTa4VTfWUyO5KURr1W/jDeveFllfllqXnchfpcyrjxf5vbXt3F5qpKBE+pICXEUIOPmRNsJ4ournIOwmTk7t3Oxukc+rebjYCNSBxHA28cwTbKv7BFcGybScxcB4n33P7nOZZLa91o2FAyzQXbFV/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357104; c=relaxed/simple;
	bh=1cKGQcO8tGFhbgtU6AdfBX8ji7iCaGXcTYMDKOrnaTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiwZFFCMYuHxKAI8Rn/s7JCYEPNhgoGJv5XxK14b8MjcpvGgqz20N9ELceCeaSdiuoDFSVSsV+W41p0C0hyTraaQW74QAyN2udym16g9CoMLxeO3IF0YxCZxkpkdSAdM4ETrVXWeeNjIvEzUSrakUI0DzJqGTDW0Puclsrdof70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqXutzjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqXutzjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74C0C4AF11;
	Tue, 30 Jul 2024 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357104;
	bh=1cKGQcO8tGFhbgtU6AdfBX8ji7iCaGXcTYMDKOrnaTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqXutzjBo1ZSoA5dZw3ifmHtL8DTN7dNxD2DNGEr4qv5m2liWL+zr/+NY8+Egxrt8
	 CIXO1MR6CbITRDKJ36xaCus0FFtQvu79W/B6X0wvY7sZj8bNvUsbqVqxCYYGrKNA8G
	 VBzpI+Pvqcz5FiXMREF63aIyEM1b4CH/sweCmN3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/568] drm/mediatek: Turn off the layers with zero width or height
Date: Tue, 30 Jul 2024 17:45:25 +0200
Message-ID: <20240730151648.390652129@linuxfoundation.org>
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

[ Upstream commit 6b9946f4550d8dad8bc1af2db97286ca449af786 ]

We found that IGT (Intel GPU Tool) will try to commit layers with
zero width or height and lead to undefined behaviors in hardware.
Disable the layers in such a situation.

Fixes: 453c3364632a ("drm/mediatek: Add ovl_adaptor support for MT8195")
Fixes: d886c0009bd0 ("drm/mediatek: Add ETHDR support for MT8195")
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240620-igt-v3-6-a9d62d2e2c7e@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c | 2 +-
 drivers/gpu/drm/mediatek/mtk_ethdr.c            | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
index 6bf6367853fba..8f0c47e868748 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c
@@ -111,7 +111,7 @@ void mtk_ovl_adaptor_layer_config(struct device *dev, unsigned int idx,
 	merge = ovl_adaptor->ovl_adaptor_comp[OVL_ADAPTOR_MERGE0 + idx];
 	ethdr = ovl_adaptor->ovl_adaptor_comp[OVL_ADAPTOR_ETHDR0];
 
-	if (!pending->enable) {
+	if (!pending->enable || !pending->width || !pending->height) {
 		mtk_merge_stop_cmdq(merge, cmdq_pkt);
 		mtk_mdp_rdma_stop(rdma_l, cmdq_pkt);
 		mtk_mdp_rdma_stop(rdma_r, cmdq_pkt);
diff --git a/drivers/gpu/drm/mediatek/mtk_ethdr.c b/drivers/gpu/drm/mediatek/mtk_ethdr.c
index 5a740d85bea65..0cf8c88994156 100644
--- a/drivers/gpu/drm/mediatek/mtk_ethdr.c
+++ b/drivers/gpu/drm/mediatek/mtk_ethdr.c
@@ -160,7 +160,12 @@ void mtk_ethdr_layer_config(struct device *dev, unsigned int idx,
 	if (idx >= 4)
 		return;
 
-	if (!pending->enable) {
+	if (!pending->enable || !pending->width || !pending->height) {
+		/*
+		 * instead of disabling layer with MIX_SRC_CON directly
+		 * set the size to 0 to avoid screen shift due to mixer
+		 * mode switch (hardware behavior)
+		 */
 		mtk_ddp_write(cmdq_pkt, 0, &mixer->cmdq_base, mixer->regs, MIX_L_SRC_SIZE(idx));
 		return;
 	}
-- 
2.43.0



