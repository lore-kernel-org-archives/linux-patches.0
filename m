Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581897482;
	Mon, 23 Jun 2025 21:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713592; cv=none; b=VlYy9wPHAS88nYSNY/3Xx8zgXSdpFeIWDdQopm954PdSSC5hiBEJdeaAKYFAoFpX5MX3rI8o1eC/vRUmj+9qJWtbOZujXVLxtURrABOv/VbmqmWdpjKaZZ0Iej6+/An8y2Ot7nnOuNmZJqVpA0AVXZv9gLBJdHtFLMaK2ByqrMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713592; c=relaxed/simple;
	bh=k3rOPfotZi65lFnmV0B+om8IxC95Gt2xoXtju/xjbSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZpRCT9OosLiZrbqt+s31tngRlgbC9xSjlb1ZyzNLdRZIpJB2O5MRjBDqifBlb/1d0vYOBU4i6z1nkZDP1CPZS/RuKwr+lgrW4LEzGC6gijjbIoTUg/4tmUV/NHe3gj69zik7APHnPiEKy1SgQr4SH9aI1vT1848KUt2ZJZR0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU/Wx6S5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU/Wx6S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4890C4CEEA;
	Mon, 23 Jun 2025 21:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713592;
	bh=k3rOPfotZi65lFnmV0B+om8IxC95Gt2xoXtju/xjbSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tU/Wx6S5kFJ0D5oFgqx6ZZg639HF1Qr9vc1cX/BTfqll0WIeiFHEhoS2gS1Ok9vsg
	 lU+DQ7rfMI1+2rEtaTpaEquwg/QjKHVj27gjhzHxrLHMUg+tX9L4/zJulYZebi4Qrc
	 XfS2YIr23akp0ulRd1MBnLbdLwxHdbHiUct2IXB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 336/592] clk: qcom: gcc: Set FORCE_MEM_CORE_ON for gcc_ufs_axi_clk for 8650/8750
Date: Mon, 23 Jun 2025 15:04:54 +0200
Message-ID: <20250623130708.445250478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit da94a81ea6c6f1cd2f389c5631e33c145ac7b35b ]

Update the force mem core bit for UFS AXI clock to force the core on
signal to remain active during halt state of the clk. If force mem
core bit of the clock is not set, the memories of the subsystem will
not retain the logic across power states. This is required for the MCQ
feature of the UFS driver.

Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Imran Shaik <quic_imrashai@quicinc.com>
Link: https://lore.kernel.org/r/20250414-gcc_ufs_mem_core-v1-1-67b5529b9b5d@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8650.c | 2 ++
 drivers/clk/qcom/gcc-sm8750.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sm8650.c b/drivers/clk/qcom/gcc-sm8650.c
index fa1672c4e7d81..24f98062b9dd5 100644
--- a/drivers/clk/qcom/gcc-sm8650.c
+++ b/drivers/clk/qcom/gcc-sm8650.c
@@ -3817,7 +3817,9 @@ static int gcc_sm8650_probe(struct platform_device *pdev)
 	qcom_branch_set_clk_en(regmap, 0x32004); /* GCC_VIDEO_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0x32030); /* GCC_VIDEO_XO_CLK */
 
+	/* FORCE_MEM_CORE_ON for ufs phy ice core and gcc ufs phy axi clocks  */
 	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_ice_core_clk, true);
+	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_axi_clk, true);
 
 	/* Clear GDSC_SLEEP_ENA_VOTE to stop votes being auto-removed in sleep. */
 	regmap_write(regmap, 0x52150, 0x0);
diff --git a/drivers/clk/qcom/gcc-sm8750.c b/drivers/clk/qcom/gcc-sm8750.c
index b36d709760958..8092dd6b37b56 100644
--- a/drivers/clk/qcom/gcc-sm8750.c
+++ b/drivers/clk/qcom/gcc-sm8750.c
@@ -3244,8 +3244,9 @@ static int gcc_sm8750_probe(struct platform_device *pdev)
 	regmap_update_bits(regmap, 0x52010, BIT(20), BIT(20));
 	regmap_update_bits(regmap, 0x52010, BIT(21), BIT(21));
 
-	/* FORCE_MEM_CORE_ON for ufs phy ice core clocks */
+	/* FORCE_MEM_CORE_ON for ufs phy ice core and gcc ufs phy axi clocks  */
 	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_ice_core_clk, true);
+	qcom_branch_set_force_mem_core(regmap, gcc_ufs_phy_axi_clk, true);
 
 	return qcom_cc_really_probe(&pdev->dev, &gcc_sm8750_desc, regmap);
 }
-- 
2.39.5



