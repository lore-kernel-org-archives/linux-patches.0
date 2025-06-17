Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82B62EE5E3;
	Tue, 17 Jun 2025 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177271; cv=none; b=NajZrPGlfp0hRCgEq525SP/VsgY2lCv8HJEnsDliiJFeqPD/uzKfyczfiTmrqOaNqlNzeU9orTzydWzb0hOe29BSm9/8IQZ7OUKDmzQRUeptrlFkoWS+bdBqYW7OGma6FGJZA038su2CjhgDiaEOstVYjdqgznwrT88bxJZlrGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177271; c=relaxed/simple;
	bh=O23iAVF3D8lIaFEB8mjbKzJvNcXlQryY44kEVWpqh4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=corhvbBfweMXAIY6DDTB1q4Aks1oaSmW4NCizw8jjMub8Ayx4uM4hwvjhPpIki9NGXLpENBEKb8D4dd8WvCE+XxTxQXUBIQ6wFbSYIYTlKF/K0Bg0+Cvf1uBuFKwjUpaN8qZItgS464LxYKqqydHF+DklECvc1yvmMhJoHo7rAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC2XWIcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC2XWIcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3D6C4CEE3;
	Tue, 17 Jun 2025 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177271;
	bh=O23iAVF3D8lIaFEB8mjbKzJvNcXlQryY44kEVWpqh4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC2XWIcmgUIM1t7zVAIySa83/3bJhXlBb/Q7q03GapvOgTotTeOLvW4V3S8qSBnH2
	 cOPggKrDETJ7D5HdYD3rITNx/I0xrlbs0qiJlyZbUoUbLXlQqDkYJcBFlTGIqsjcKx
	 clVfAw/Lxs0pwLIYaLtBbDpJ4iBu/L/lCZwzU6Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lijuan Gao <quic_lijuang@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 261/780] pinctrl: qcom: correct the ngpios entry for QCS8300
Date: Tue, 17 Jun 2025 17:19:29 +0200
Message-ID: <20250617152502.082998983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijuan Gao <quic_lijuang@quicinc.com>

[ Upstream commit 32b5361a0d10627343b2ded76f05e5d591627fd6 ]

Correct the ngpios entry to account for the UFS_RESET pin, which is
expected to be wired to the reset pin of the primary UFS memory and is
exported as GPIOs in addition to the real GPIOs, allowing the UFS driver
to toggle it.

Fixes: 0c4cd2cc87c8 ("pinctrl: qcom: add the tlmm driver for QCS8300 platforms")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Lijuan Gao <quic_lijuang@quicinc.com>
Link: https://lore.kernel.org/20250506-correct_gpio_ranges-v3-4-49a7d292befa@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs8300.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs8300.c b/drivers/pinctrl/qcom/pinctrl-qcs8300.c
index ba6de944a859a..5f5f7c4ac644c 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs8300.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs8300.c
@@ -1204,7 +1204,7 @@ static const struct msm_pinctrl_soc_data qcs8300_pinctrl = {
 	.nfunctions = ARRAY_SIZE(qcs8300_functions),
 	.groups = qcs8300_groups,
 	.ngroups = ARRAY_SIZE(qcs8300_groups),
-	.ngpios = 133,
+	.ngpios = 134,
 	.wakeirq_map = qcs8300_pdc_map,
 	.nwakeirq_map = ARRAY_SIZE(qcs8300_pdc_map),
 	.egpio_func = 11,
-- 
2.39.5



