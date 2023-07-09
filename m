Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05E1522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60241C433C9;
	Sun,  9 Jul 2023 11:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902240;
	bh=CCKfym+fiLtsILFWoSv+t8YHrlFmku2HNQmOSNs71Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w76FASqdCIfXhzN1LxZZfDGJC/NvZ1eOphe1ZL0AJ9FMDr3KdjN5mdhRE3bO/efXC
	 qbdviWXp4vmtV7rhq9UtRj/gLiiRrdH1yagEbRCXjzLD4FE+LO4OCMHiJDGAofh2/Q
	 lwLeZVZRlXkFiVxsws3SG16aL5LnNXzzv7C6jaVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 278/431] soc: mediatek: SVS: Fix MT8192 GPU node name
Date: Sun,  9 Jul 2023 13:13:46 +0200
Message-ID: <20230709111457.662237534@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index f26eb2f637d52..77d6299774427 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -2101,9 +2101,9 @@ static int svs_mt8192_platform_probe(struct svs_platform *svsp)
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



