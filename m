Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870E8130492;
	Tue, 14 May 2024 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682589; cv=none; b=FgT/zHKbB2PqR89h3SiDdSMUNn8pxZ8O+KH4sy6BK75RJzZ8ySgVWy2rmHshjHJC5vqji1lBReM7D3Y++bHSAVAq7EPEo5y8H9w6GWZTM7t9PvQfAvcdX2Pgam+P0i5/pzGkIUT4r534f6fHgcFfLjtXTQUQPxnL0ZBHfE0LDQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682589; c=relaxed/simple;
	bh=DekTzT/yMOVKw6IhvF7eR0nVF4KI39c9F4tJugZj9I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw8EYFvbXl2ircuepu7IIFSXs+cg2ysOKvM91LOUB/iT8HVQWGkOs12coL734LJPsFYAQV1PeVpJyYupCRyYXSqg/SPPlLABonF4duL4rLxOhqKof52OBoC8IaEjeOwKR31WSI0rLXJanyVnpdI9PSyGXYpgDDeODiitvMDWCpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8wCzVrQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8wCzVrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC825C32781;
	Tue, 14 May 2024 10:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682589;
	bh=DekTzT/yMOVKw6IhvF7eR0nVF4KI39c9F4tJugZj9I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8wCzVrQ2peaPYKSIy8zDXGGhMash+gpwVPjIonHRTCUJWkicpPP79QvBQhnkmbzk
	 Ws7DB3Km/vC2MlRWk+QtC5oO/aMWy7mGfe8SUYAJnr9f3Ea1LwSYrPKtsfKJTNB3SK
	 equgZhKiS4eWgZEvQlK6944eGjUkBasw9nJ4jvv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 087/336] clk: qcom: smd-rpm: Restore msm8976 num_clk
Date: Tue, 14 May 2024 12:14:51 +0200
Message-ID: <20240514101041.891832135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 0d4ce2458cd7d1d66a5ee2f3c036592fb663d5bc ]

During rework somehow msm8976 num_clk got removed, restore it.

Fixes: d6edc31f3a68 ("clk: qcom: smd-rpm: Separate out interconnect bus clocks")
Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240401171641.8979-1-a39.skl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-smd-rpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/clk-smd-rpm.c b/drivers/clk/qcom/clk-smd-rpm.c
index 8602c02047d04..45c5255bcd11b 100644
--- a/drivers/clk/qcom/clk-smd-rpm.c
+++ b/drivers/clk/qcom/clk-smd-rpm.c
@@ -768,6 +768,7 @@ static struct clk_smd_rpm *msm8976_clks[] = {
 
 static const struct rpm_smd_clk_desc rpm_clk_msm8976 = {
 	.clks = msm8976_clks,
+	.num_clks = ARRAY_SIZE(msm8976_clks),
 	.icc_clks = bimc_pcnoc_snoc_smmnoc_icc_clks,
 	.num_icc_clks = ARRAY_SIZE(bimc_pcnoc_snoc_smmnoc_icc_clks),
 };
-- 
2.43.0



