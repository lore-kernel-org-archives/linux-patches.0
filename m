Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E473C2D;
	Tue, 23 Jan 2024 00:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969603; cv=none; b=iR9S3gkQ13ROiPkB9QUb07ayi0oYXvphVUFaoTQLLpqKKckWLZ+YmFdYDwTqZQ0wWqbjOKbio3TumyLD2+kMJl1+8ve1BUPFf2/ZRTUA6o8TJ2ageFf1UpF5gTaq03AbHlpuYq9HnrSBi4dXoPN9H9X4XwpoJiBoUEdusQDV/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969603; c=relaxed/simple;
	bh=1XN5VIIqyK5QMMfTcacHFkmoyMhfGozVWLcttStw5is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1FqA93Hmv/d/i5XnJXk/rag3A5rdh/NwnwCs4T3FFercq3pFRsO+YYvEgwWhx7E6VT3Wt65tIF3PeOMMZdhV/qmQ6bIUUgLtq5XdkYpS6SwZDmCsHn5Yx/I0IwIfuzO2NPAvCrqZ0eIdZeIOz9XOsqDqSqeiXhU+Vh+Ca6kKdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya31UmMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya31UmMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C60DC433F1;
	Tue, 23 Jan 2024 00:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969602;
	bh=1XN5VIIqyK5QMMfTcacHFkmoyMhfGozVWLcttStw5is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya31UmMjPTe9mS5nWrQmL1ooBVxtWrPePnB1XpMv0R1BeOmBa5ahOIdytJVj59Pfa
	 4Or8ulbM8BZZQ+SYwiO+NNSXsuiSGe4UTiMw1Jvsab14KftYXgWcEF/YgqPZv4ynnS
	 Rwm4yOU+6QeC+6PhNy4OvPD/EVou1TI/czJw7/Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 351/641] clk: qcom: gpucc-sm8550: Update GPU PLL settings
Date: Mon, 22 Jan 2024 15:54:15 -0800
Message-ID: <20240122235828.910412062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 1d595972da12b5a78748eeb3ba1ff58bb0283b91 ]

The settings in the driver seem to have been taken from an older
release. Update them to match the latest values.

Fixes: bfae40744b33 ("clk: qcom: gpucc-sm8550: Add support for graphics clock controller")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-7-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sm8550.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sm8550.c b/drivers/clk/qcom/gpucc-sm8550.c
index 420dcb27b47d..2fa8673424d7 100644
--- a/drivers/clk/qcom/gpucc-sm8550.c
+++ b/drivers/clk/qcom/gpucc-sm8550.c
@@ -35,12 +35,12 @@ enum {
 };
 
 static const struct pll_vco lucid_ole_vco[] = {
-	{ 249600000, 2300000000, 0 },
+	{ 249600000, 2000000000, 0 },
 };
 
 static const struct alpha_pll_config gpu_cc_pll0_config = {
-	.l = 0x0d,
-	.alpha = 0x0,
+	.l = 0x1e,
+	.alpha = 0xbaaa,
 	.config_ctl_val = 0x20485699,
 	.config_ctl_hi_val = 0x00182261,
 	.config_ctl_hi1_val = 0x82aa299c,
-- 
2.43.0



