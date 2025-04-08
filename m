Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABB6264614;
	Tue,  8 Apr 2025 11:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110655; cv=none; b=gei3mP8xJBZyC+7OKsNOEhvu9ZbkmwqT7qPmVQM+h1zEgnhEWLef3UD+MC0jz1aWOyNvT2qlFCmuLpdkL2Ty80KFgUQ0q68RT/DrZj/5SH/z1PBhEiQjaR/rq8VbUzzEnMisqwlyLWZCuoBBA7tVeD9/neqt4lsOyRDsrNz4xFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110655; c=relaxed/simple;
	bh=4A11iAZDtffd5QPqzrMtSepz23dwVt3psFzxiJjFyLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzk1QforGifRwIDxLF5qRIg9kpwU96JlsEEVzqOzaDEpsmgKGnEPr9JT4gqYVl2XdRfieDsP8KAVE2Q8di0WFgFJ8DkIYCRacgCfFA0v7c8jRXjdBrZ6k54DeBq2gEWbTRCvVSbzMpt8jrYZeH/o6r+USvy23S/bxZAB0eo1IRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRUMB2CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRUMB2CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF571C4CEE7;
	Tue,  8 Apr 2025 11:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110655;
	bh=4A11iAZDtffd5QPqzrMtSepz23dwVt3psFzxiJjFyLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRUMB2CB0DWr2RcGOMInc0NyXTnJqTs8XS8+akVNKHRME2+tBXr141320HpZ7b6HC
	 1aGmSVL34mwDWpmysM7F0gFNZpA72b/KjLATDjTmmVPFK5I2ZepqMlZOlvvUEhThx0
	 lqkMnzGeniz96Fg4vTAPAhAUcTE0g/w5VkJE+R5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 144/731] soc: mediatek: mt8167-mmsys: Fix missing regval in all entries
Date: Tue,  8 Apr 2025 12:40:41 +0200
Message-ID: <20250408104917.624173832@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 5424793452d134ec1a173bd748c757144f25b1e2 ]

The mmsys routing table for this SoC was effectively missing
initialization of the val variable of struct mtk_mmsys_routes:
this means that `val` was incorrectly initialized to zero,
hence the registers were wrongly initialized.

Add the required regval to all of the entries of the routing
table for this SoC to fix display controller functionality.

Fixes: 060f7875bd23 ("soc: mediatek: mmsys: Add support for MT8167 SoC")
Link: https://lore.kernel.org/r/20250212100012.33001-6-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8167-mmsys.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/mediatek/mt8167-mmsys.h b/drivers/soc/mediatek/mt8167-mmsys.h
index f7a35b3656bb1..655ef962abe9f 100644
--- a/drivers/soc/mediatek/mt8167-mmsys.h
+++ b/drivers/soc/mediatek/mt8167-mmsys.h
@@ -17,18 +17,23 @@ static const struct mtk_mmsys_routes mt8167_mmsys_routing_table[] = {
 	{
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
 		MT8167_DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0,
+		OVL0_MOUT_EN_COLOR0
 	}, {
 		DDP_COMPONENT_DITHER0, DDP_COMPONENT_RDMA0,
-		MT8167_DISP_REG_CONFIG_DISP_DITHER_MOUT_EN, MT8167_DITHER_MOUT_EN_RDMA0
+		MT8167_DISP_REG_CONFIG_DISP_DITHER_MOUT_EN, MT8167_DITHER_MOUT_EN_RDMA0,
+		MT8167_DITHER_MOUT_EN_RDMA0
 	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_COLOR0,
-		MT8167_DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0
+		MT8167_DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0,
+		COLOR0_SEL_IN_OVL0
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI0,
-		MT8167_DISP_REG_CONFIG_DISP_DSI0_SEL_IN, MT8167_DSI0_SEL_IN_RDMA0
+		MT8167_DISP_REG_CONFIG_DISP_DSI0_SEL_IN, MT8167_DSI0_SEL_IN_RDMA0,
+		MT8167_DSI0_SEL_IN_RDMA0
 	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_DSI0,
-		MT8167_DISP_REG_CONFIG_DISP_RDMA0_SOUT_SEL_IN, MT8167_RDMA0_SOUT_DSI0
+		MT8167_DISP_REG_CONFIG_DISP_RDMA0_SOUT_SEL_IN, MT8167_RDMA0_SOUT_DSI0,
+		MT8167_RDMA0_SOUT_DSI0
 	},
 };
 
-- 
2.39.5



