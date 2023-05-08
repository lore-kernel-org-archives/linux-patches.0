Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300041549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3F5C433D2;
	Mon,  8 May 2023 09:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539970;
	bh=7yAbatqgq7LIvEWfrKnftoaGmhpPFDRJmzZFO4NpaqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+2wbzUEPY6IBZ7UOPUryDj3+HB8veTTFvABdoLWcn1/HO1u6YL0ylqcMVFlgfMdy
	 01h/hOBgMfLFY6Qle0z27ImNpceA0GcZyNQf59lSYCARSN3Codd8eWg93bo7s67ckt
	 4Nqm666wnw4JESXlL6qtzXlJoTBXzIZhcDFyF0PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Wei Chang <jia-wei.chang@mediatek.com>,
	Nick Hainke <vincent@systemli.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/611] cpufreq: mediatek: raise proc/sram max voltage for MT8516
Date: Mon,  8 May 2023 11:40:38 +0200
Message-Id: <20230508094428.746679005@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jia-Wei Chang <jia-wei.chang@mediatek.com>

[ Upstream commit d3296bb4cafd4bad4a5cf2eeab9d19cc94f9e30e ]

Since the upper boundary of proc/sram voltage of MT8516 is 1300 mV,
which is greater than the value of MT2701 1150 mV, we fix it by adding
the corresponding platform data and specify proc/sram_max_volt to
support MT8516.

Signed-off-by: Jia-Wei Chang <jia-wei.chang@mediatek.com>
Fixes: ead858bd128d ("cpufreq: mediatek: Move voltage limits to platform data")
Fixes: 6a17b3876bc8 ("cpufreq: mediatek: Refine mtk_cpufreq_voltage_tracking()")
Reported-by: Nick Hainke <vincent@systemli.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
index 6dc225546a8d6..764e4fbdd536c 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -711,20 +711,29 @@ static const struct mtk_cpufreq_platform_data mt8186_platform_data = {
 	.ccifreq_supported = true,
 };
 
+static const struct mtk_cpufreq_platform_data mt8516_platform_data = {
+	.min_volt_shift = 100000,
+	.max_volt_shift = 200000,
+	.proc_max_volt = 1310000,
+	.sram_min_volt = 0,
+	.sram_max_volt = 1310000,
+	.ccifreq_supported = false,
+};
+
 /* List of machines supported by this driver */
 static const struct of_device_id mtk_cpufreq_machines[] __initconst = {
 	{ .compatible = "mediatek,mt2701", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt2712", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt7622", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt7623", .data = &mt2701_platform_data },
-	{ .compatible = "mediatek,mt8167", .data = &mt2701_platform_data },
+	{ .compatible = "mediatek,mt8167", .data = &mt8516_platform_data },
 	{ .compatible = "mediatek,mt817x", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt8173", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt8176", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt8183", .data = &mt8183_platform_data },
 	{ .compatible = "mediatek,mt8186", .data = &mt8186_platform_data },
 	{ .compatible = "mediatek,mt8365", .data = &mt2701_platform_data },
-	{ .compatible = "mediatek,mt8516", .data = &mt2701_platform_data },
+	{ .compatible = "mediatek,mt8516", .data = &mt8516_platform_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mtk_cpufreq_machines);
-- 
2.39.2



