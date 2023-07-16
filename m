Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E618F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38991C433C8;
	Sun, 16 Jul 2023 20:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540087;
	bh=8HAJNczVHP92Z4BKrjpiWGM76WZ6OKvcaIJB8v7GkVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4KX5qVlamEkP8Z45h+Ik5GX/zo5KLP/b8IBVKFBXlks9JtxLBlsMeODUceNjMQ3k
	 6OcpYOvahf4UcztNhvIKbmNcPHd5YMbsC6aMj1bXACtQvMJk2nufui5de3oT1tjKwm
	 DT+Y1CQAyFobeaqc+zCRcTKPfnCH9HIyZsrg2BoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/591] soc: mediatek: SVS: Fix MT8192 GPU node name
Date: Sun, 16 Jul 2023 21:46:18 +0200
Message-ID: <20230716194930.052854013@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 95094495401bdf6a0649d220dfd095e6079b5e39 ]

Device tree node names should be generic. The planned device node name
for the GPU, according to the bindings and posted DT changes, is "gpu",
not "mali".

Fix the GPU node name in the SVS driver to follow.

Fixes: 0bbb09b2af9d ("soc: mediatek: SVS: add mt8192 SVS GPU driver")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://lore.kernel.org/r/20230531063532.2240038-1-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index e55fb16fdc5ac..f00cd5c723499 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2114,9 +2114,9 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
 		svsb = &svsp->banks[idx];
 
 		if (svsb->type == SVSB_HIGH)
-			svsb->opp_dev = svs_add_device_link(svsp, "mali");
+			svsb->opp_dev = svs_add_device_link(svsp, "gpu");
 		else if (svsb->type == SVSB_LOW)
-			svsb->opp_dev = svs_get_subsys_device(svsp, "mali");
+			svsb->opp_dev = svs_get_subsys_device(svsp, "gpu");
 
 		if (IS_ERR(svsb->opp_dev))
 			return dev_err_probe(svsp->dev, PTR_ERR(svsb->opp_dev),
-- 
2.39.2



