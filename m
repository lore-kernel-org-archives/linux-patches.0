Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E535C1F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68245C433C8;
	Tue,  1 Aug 2023 09:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881922;
	bh=oURpJredoucDcEveexJXt0TQPG51YWuWX58XsNxKLPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BT12aSiSD8pdLMM0YPJVh0UfBbcIgvXV5SgdK2F7DQeM2uIL6Rcj9fFL50bTCGZL5
	 y2SD2hqvml3nH8/G8v6NQXvni4PIQeP8ScWp4diH2L9Y+mTzipDvaIokzeLFOivJbk
	 AfQdPggHmNjL0iZVtGhVZ7UJx5U0t/IiQOxXXCOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/155] phy: qcom-snps: correct struct qcom_snps_hsphy kerneldoc
Date: Tue,  1 Aug 2023 11:19:22 +0200
Message-ID: <20230801091911.977176934@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 2a881183dc5ab2474ef602e48fe7af34db460d95 ]

Update kerneldoc of struct qcom_snps_hsphy to fix:

  drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c:135: warning: Function parameter or member 'update_seq_cfg' not described in 'qcom_snps_hsphy'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230507144818.193039-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8a0eb8f9b9a0 ("phy: qcom-snps-femto-v2: properly enable ref clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c b/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
index 54846259405a9..136b45903c798 100644
--- a/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
+++ b/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
@@ -73,11 +73,11 @@ static const char * const qcom_snps_hsphy_vreg_names[] = {
  *
  * @cfg_ahb_clk: AHB2PHY interface clock
  * @ref_clk: phy reference clock
- * @iface_clk: phy interface clock
  * @phy_reset: phy reset control
  * @vregs: regulator supplies bulk data
  * @phy_initialized: if PHY has been initialized correctly
  * @mode: contains the current mode the PHY is in
+ * @update_seq_cfg: tuning parameters for phy init
  */
 struct qcom_snps_hsphy {
 	struct phy *phy;
-- 
2.39.2



