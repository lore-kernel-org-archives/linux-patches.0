Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9829A22E3E0;
	Mon,  2 Jun 2025 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876936; cv=none; b=W1+vmslZquJvyQxCxFUoIUaKuFHCwHL+oOHizzHuKJdOczpnvH025ekWuUfkZJhyqaKnORIkufuxMiVeQiPGIcV2o1L1lYyPr5qVyowifeQAevqbiZB+Sp7gY4UBPcif7rtRtaH0LILXfH0cZFVlxOXj8S6ryqxOtZJhZLSchKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876936; c=relaxed/simple;
	bh=SUdE98KJ7VKw1VGhU7bh8eDK2B28w/VEruk0Q349Pvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebjmgw5eGS7K1ah3YHbZtO+gT96VJ3kS+hYLJWjcu7/q6D3izBF/OzpOfqDKJtWj3vmsRICK6USFDzF771EK6uqxziQeyUeRS/Xwxc0oWes51f9SyOG0rKybj8lgoSwA2VrLV+aMxed/9S9rC1Li1sV1WG7hV+wO5RRCRRKBrBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSfYRju+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSfYRju+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C6EC4CEEB;
	Mon,  2 Jun 2025 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876936;
	bh=SUdE98KJ7VKw1VGhU7bh8eDK2B28w/VEruk0Q349Pvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSfYRju+M29xS4wwR7P8hNi4eZm8tXFI/IrYY2LBI8vFD7mPKm0dUjTqAfUxFthKC
	 QX0jpse8dHbBATtkQo7/jeeS38qR+PB1uGW4qGgVbhBq6UfC5KWgRW4SFTWaqEbn3i
	 gECYjMKfoFU+zvljkDoMAHl1asc9xbQRJShjpU0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/325] drm/mediatek: mtk_dpi: Add checks for reg_h_fre_con existence
Date: Mon,  2 Jun 2025 15:46:37 +0200
Message-ID: <20250602134324.704874074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 8c9da7cd0bbcc90ab444454fecf535320456a312 ]

In preparation for adding support for newer DPI instances which
do support direct-pin but do not have any H_FRE_CON register,
like the one found in MT8195 and MT8188, add a branch to check
if the reg_h_fre_con variable was declared in the mtk_dpi_conf
structure for the probed SoC DPI version.

As a note, this is useful specifically only for cases in which
the support_direct_pin variable is true, so mt8195-dpintf is
not affected by any issue.

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250217154836.108895-6-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 1fa958e8c40a1..5ad9c384046cb 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -406,12 +406,13 @@ static void mtk_dpi_config_swap_input(struct mtk_dpi *dpi, bool enable)
 
 static void mtk_dpi_config_2n_h_fre(struct mtk_dpi *dpi)
 {
-	mtk_dpi_mask(dpi, dpi->conf->reg_h_fre_con, H_FRE_2N, H_FRE_2N);
+	if (dpi->conf->reg_h_fre_con)
+		mtk_dpi_mask(dpi, dpi->conf->reg_h_fre_con, H_FRE_2N, H_FRE_2N);
 }
 
 static void mtk_dpi_config_disable_edge(struct mtk_dpi *dpi)
 {
-	if (dpi->conf->edge_sel_en)
+	if (dpi->conf->edge_sel_en && dpi->conf->reg_h_fre_con)
 		mtk_dpi_mask(dpi, dpi->conf->reg_h_fre_con, 0, EDGE_SEL_EN);
 }
 
-- 
2.39.5



