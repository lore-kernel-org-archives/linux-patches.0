Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA983BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zdNmuOmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05ABC433C8;
	Wed, 15 Nov 2023 19:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076203;
	bh=kJ+6qNT0jO1qXc9kqWug+yt55wNHOH2YOvbMt7C6Iro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zdNmuOmpMd/DXTUp/9RHikafLAZddzgsNYpJwhJ0ANtHvDU9ma19GCapB9nk21bSA
	 7Uwc8RxlskTykWjDWWql0yLuvZhMVSx/YxcdJXIkAvVx5umGLTL1m5ULxaAcrTaAxc
	 YS9WzUukV00+xmEEsm+Ec1BkE3d8JdJtNmik1Lis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 116/550] thermal/drivers/mediatek: Fix probe for THERMAL_V2
Date: Wed, 15 Nov 2023 14:11:40 -0500
Message-ID: <20231115191608.731494420@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 5055fadfa7e16f2427d5b3c40b2bf563ddfdab22 ]

Fix the probe function to call mtk_thermal_release_periodic_ts for
everything != MTK_THERMAL_V1. This was accidentally changed from V1
to V2 in the original patch.

Reported-by: Frank Wunderlich <frank-w@public-files.de>
Closes: https://lore.kernel.org/lkml/B0B3775B-B8D1-4284-814F-4F41EC22F532@public-files.de/
Reported-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Closes: https://lore.kernel.org/lkml/07a569b9-e691-64ea-dd65-3b49842af33d@linaro.org/
Fixes: 33140e668b10 ("thermal/drivers/mediatek: Control buffer enablement tweaks")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230918100706.1229239-1-msp@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/auxadc_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/mediatek/auxadc_thermal.c b/drivers/thermal/mediatek/auxadc_thermal.c
index f59d36de20a09..677ff04d91ea0 100644
--- a/drivers/thermal/mediatek/auxadc_thermal.c
+++ b/drivers/thermal/mediatek/auxadc_thermal.c
@@ -1268,7 +1268,7 @@ static int mtk_thermal_probe(struct platform_device *pdev)
 
 	mtk_thermal_turn_on_buffer(mt, apmixed_base);
 
-	if (mt->conf->version != MTK_THERMAL_V2)
+	if (mt->conf->version != MTK_THERMAL_V1)
 		mtk_thermal_release_periodic_ts(mt, auxadc_base);
 
 	if (mt->conf->version == MTK_THERMAL_V1)
-- 
2.42.0



