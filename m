Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985393368B8;
	Tue, 21 Jul 2026 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655766; cv=none; b=AyHvlfXSLzYlmtP/ungsIjyvcVVN+DXlXMmaxgTAoDZKfrLTQKeIIU9vGAYEXtGRbPuoeoXOofxoRdhuqouqjP8XZnEO2ZzQpe51Sx/2A1Un1Qjh/rphcmYLhhYAIDYQgUTzlPROTuLtSRmwVKaGb2SEomAvREBrFC9uvuipICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655766; c=relaxed/simple;
	bh=Yul6ZHS7B230MeD2n3tnkGx5TSZ18B1FRJzxcJqLCcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6esAO/bI+lcInZvCjE5wTvqj3Gd2gh/ICrTDHyH9xEQwfGl3ZOzu8Uwetj9EsP63e3aLuPa8HFjzKtR5bcCuqEjp9gB/aQsMf0ECYoC2dBrijfL3My5fCsUHFE6QZDfnVI3RBMQljOToZg4vtPNyhXfUQYNp+CXzLexlao8ODo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKpVNhct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKpVNhct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC861F000E9;
	Tue, 21 Jul 2026 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655765;
	bh=4bWV+BmpWGP/QB2dZCoOu1iLpSR2iSVYcmhXRdc2Br4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKpVNhct+ubf+jB62CJGcutiodaHE3e1LzZhoAntAhAi1cbtYIcWEWPQe++KkLGWD
	 DL3tLVv2rF4d2ghvpu3EbQU7LtEOLBZWI+N+n9oOjHYgXwG9uEJEaIcOVRnKCUpHop
	 OHcE8oYix9tKycR0S18VVgRyRn4TVdFx9GFVI+ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Leonardo Scorcia <l.scorcia@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0132/1611] soc: mediatek: mtk-mmsys: Restore MT8167 routing masks lost during merge
Date: Tue, 21 Jul 2026 17:04:08 +0200
Message-ID: <20260721152517.841336189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Leonardo Scorcia <l.scorcia@gmail.com>

[ Upstream commit 7d462de9f65b002b439b1b168bf3b5579b0de48b ]

The original patch that was sent to the mailing lists included the values
for the route masks, but they got lost during merge: add back the full
register masks where missing.

Fixes: 060f7875bd23 ("soc: mediatek: mmsys: Add support for MT8167 SoC")
Signed-off-by: Luca Leonardo Scorcia <l.scorcia@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8167-mmsys.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/mediatek/mt8167-mmsys.h b/drivers/soc/mediatek/mt8167-mmsys.h
index c468926561b475..eef14083c47b5a 100644
--- a/drivers/soc/mediatek/mt8167-mmsys.h
+++ b/drivers/soc/mediatek/mt8167-mmsys.h
@@ -10,24 +10,29 @@
 #define MT8167_DISP_REG_CONFIG_DISP_RDMA0_SOUT_SEL_IN	0x06c
 
 #define MT8167_DITHER_MOUT_EN_RDMA0			0x1
+#define MT8167_DITHER_MOUT_EN_MASK			0x7
+
 #define MT8167_RDMA0_SOUT_DSI0				0x2
+#define MT8167_RDMA0_SOUT_MASK				0x3
+
 #define MT8167_DSI0_SEL_IN_RDMA0			0x1
+#define MT8167_DSI0_SEL_IN_MASK				0x3
 
 static const struct mtk_mmsys_routes mt8167_mmsys_routing_table[] = {
 	MMSYS_ROUTE(OVL0, COLOR0,
 		    MT8167_DISP_REG_CONFIG_DISP_OVL0_MOUT_EN, OVL0_MOUT_EN_COLOR0,
 		    OVL0_MOUT_EN_COLOR0),
 	MMSYS_ROUTE(DITHER0, RDMA0,
-		    MT8167_DISP_REG_CONFIG_DISP_DITHER_MOUT_EN, MT8167_DITHER_MOUT_EN_RDMA0,
+		    MT8167_DISP_REG_CONFIG_DISP_DITHER_MOUT_EN, MT8167_DITHER_MOUT_EN_MASK,
 		    MT8167_DITHER_MOUT_EN_RDMA0),
 	MMSYS_ROUTE(OVL0, COLOR0,
 		    MT8167_DISP_REG_CONFIG_DISP_COLOR0_SEL_IN, COLOR0_SEL_IN_OVL0,
 		    COLOR0_SEL_IN_OVL0),
 	MMSYS_ROUTE(RDMA0, DSI0,
-		    MT8167_DISP_REG_CONFIG_DISP_DSI0_SEL_IN, MT8167_DSI0_SEL_IN_RDMA0,
+		    MT8167_DISP_REG_CONFIG_DISP_DSI0_SEL_IN, MT8167_DSI0_SEL_IN_MASK,
 		    MT8167_DSI0_SEL_IN_RDMA0),
 	MMSYS_ROUTE(RDMA0, DSI0,
-		    MT8167_DISP_REG_CONFIG_DISP_RDMA0_SOUT_SEL_IN, MT8167_RDMA0_SOUT_DSI0,
+		    MT8167_DISP_REG_CONFIG_DISP_RDMA0_SOUT_SEL_IN, MT8167_RDMA0_SOUT_MASK,
 		    MT8167_RDMA0_SOUT_DSI0),
 };
 
-- 
2.53.0



