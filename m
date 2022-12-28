Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A3187A
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9FAC433F0;
	Wed, 28 Dec 2022 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242957;
	bh=yNKJ/JeG4BRvN8dpUNfGYLvAJuWcMDBqAXq8Tf3Wt2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEDvYPN35aGBz9n86BVJY5GrcDyTPW+s6BON9Kdzoz1xZ/2KIoQ9K3cBTSc1gslG6
	 LBDAm3BobnijglM+KU4sJ0XGjb9MZPo1kqfyKhFjTYra2ZzY9YZUU6MFl5eMQXZOHQ
	 pMcnBGAlrRQvaYnpY70MfKhakFQtr9h3psff5IUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0434/1146] clk: mediatek: fix dependency of MT7986 ADC clocks
Date: Wed, 28 Dec 2022 15:32:53 +0100
Message-Id: <20221228144341.969581118@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit a46315295489933209e902638cd287aeb5f982ab ]

It seems like CLK_INFRA_ADC_FRC_CK always need to be enabled for
CLK_INFRA_ADC_26M_CK to work. Instead of adding this dependency to the
mtk-thermal and mt6577_auxadc drivers, add dependency to the clock
driver clk-mt7986-infracfg.c.

Fixes: ec97d23c8e22 ("clk: mediatek: add mt7986 clock support")
Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/5e55012567da74870e1fb2edc2dc513b5821e523.1666801017.git.daniel@makrotopia.org
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt7986-infracfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt7986-infracfg.c b/drivers/clk/mediatek/clk-mt7986-infracfg.c
index d90727a53283..49666047bf0e 100644
--- a/drivers/clk/mediatek/clk-mt7986-infracfg.c
+++ b/drivers/clk/mediatek/clk-mt7986-infracfg.c
@@ -153,7 +153,7 @@ static const struct mtk_gate infra_clks[] = {
 		    18),
 	GATE_INFRA1(CLK_INFRA_MSDC_66M_CK, "infra_msdc_66m", "infra_sysaxi_d2",
 		    19),
-	GATE_INFRA1(CLK_INFRA_ADC_26M_CK, "infra_adc_26m", "csw_f26m_sel", 20),
+	GATE_INFRA1(CLK_INFRA_ADC_26M_CK, "infra_adc_26m", "infra_adc_frc", 20),
 	GATE_INFRA1(CLK_INFRA_ADC_FRC_CK, "infra_adc_frc", "csw_f26m_sel", 21),
 	GATE_INFRA1(CLK_INFRA_FBIST2FPC_CK, "infra_fbist2fpc", "nfi1x_sel", 23),
 	/* INFRA2 */
-- 
2.35.1



