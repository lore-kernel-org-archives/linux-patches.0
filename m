Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18C78481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282C2C433D2;
	Fri, 10 Mar 2023 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457139;
	bh=++Tar65/IL/mM1cxN7n/aRBBTvtuMvpPnoG6fWLHT/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q18zqu49jeqTr0gAPYfWdP2072NBPn+n5gWS6gzD0gyuaYIBL3IgUaNn/imWSUDf
	 raRjvWvMRq9GFhUFyIC718tKkK2Rak6O2SqR/bOqx+NPSaNK/VQVznVH102KOrG1Mj
	 VHngPKfdRQbnOh1gH8UruNWwvv1MzfKuxBB1515w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tinghan Shen <tinghan.shen@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/200] soc: mediatek: mtk-pm-domains: Allow mt8186 ADSP default power on
Date: Fri, 10 Mar 2023 14:36:55 +0100
Message-Id: <20230310133717.307854047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tinghan Shen <tinghan.shen@mediatek.com>

[ Upstream commit 0d08c56d97a614f56d74f490d693faf8038db125 ]

In the use case of configuring the access permissions of the ADSP core,
the mt8186 SoC ADSP power will be switched on in the bootloader because
the permission control registers are located in the ADSP subsys.

Signed-off-by: Tinghan Shen <tinghan.shen@mediatek.com>
Fixes: 88590cbc1703 ("soc: mediatek: pm-domains: Add support for mt8186")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221012075434.30009-1-tinghan.shen@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8186-pm-domains.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/soc/mediatek/mt8186-pm-domains.h b/drivers/soc/mediatek/mt8186-pm-domains.h
index 108af61854a38..fce86f79c5055 100644
--- a/drivers/soc/mediatek/mt8186-pm-domains.h
+++ b/drivers/soc/mediatek/mt8186-pm-domains.h
@@ -304,7 +304,6 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 		.ctl_offs = 0x9FC,
 		.pwr_sta_offs = 0x16C,
 		.pwr_sta2nd_offs = 0x170,
-		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8186_POWER_DOMAIN_ADSP_INFRA] = {
 		.name = "adsp_infra",
@@ -312,7 +311,6 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 		.ctl_offs = 0x9F8,
 		.pwr_sta_offs = 0x16C,
 		.pwr_sta2nd_offs = 0x170,
-		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8186_POWER_DOMAIN_ADSP_TOP] = {
 		.name = "adsp_top",
@@ -332,7 +330,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 				MT8186_TOP_AXI_PROT_EN_3_CLR,
 				MT8186_TOP_AXI_PROT_EN_3_STA),
 		},
-		.caps = MTK_SCPD_SRAM_ISO | MTK_SCPD_KEEP_DEFAULT_OFF | MTK_SCPD_ACTIVE_WAKEUP,
+		.caps = MTK_SCPD_SRAM_ISO | MTK_SCPD_ACTIVE_WAKEUP,
 	},
 };
 
-- 
2.39.2



