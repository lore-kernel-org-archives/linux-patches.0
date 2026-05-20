Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B882348C55;
	Wed, 20 May 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301092; cv=none; b=pYswcvAEAXlt6RaXh3EF+kPvBeCReHnC4hqLNhQkgPMtC8ZUmbJ2jEDKBsI+7O6meSZwH5knwx1ZPI7tllP8rjBXS3LoQzmj2ucz+JPsxTU7ywlWBIbftIua185eXn/5FNbiSePKvbNnXHX6NTLXsjaoCMLcuJKbnnVCs/ehqeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301092; c=relaxed/simple;
	bh=2YN7SNDJ3wkJuvPzqGe8mU9nNJpV8LY6AH20e2h5vyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7K+YflvRycbtYZgC1c3nH9WWZW0pbliXf0XZok9Vl1c37365ugsrxuuhvskS8hef4mb3w4zkAb0uvcvmUK4F3wip4W5zkUIVGSN1xVe8nLPBfIp3XJGUF8gnkv98OtAIXJcelVziOxOe3ByusKYC09kwa1rpcaW+rHEoKDrReE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7JqQK9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7JqQK9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DBE1F000E9;
	Wed, 20 May 2026 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301091;
	bh=bHvphwy5nDeHjn6Rpb/BDqgYvus55zIXNJiRvVmbWaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7JqQK9yKBbWbCyHG4ulqTsSVea4fCmcUibHJgfn3mLF838jnERjpdzLycQC9R2pr
	 v5h7jOC8UpgkYb6PvZenBBTlj5j11hsBsU6sIFCkYAFjhLb3YZPugbTZovOkRsejco
	 NN/73jLlHt3UPqxWoxYx8N+9rQ8h0VkMwOt0J9Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 422/666] clk: qcom: gcc-x1e80100: Keep GCC USB QTB clock always ON
Date: Wed, 20 May 2026 18:20:33 +0200
Message-ID: <20260520162120.414615471@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 05566ebcc0cd170bd4f50c907ee3ed8e106251e3 ]

In Hamoa, SMMU invalidation requires the GCC_AGGRE_USB_NOC_AXI_CLK
to be on for the USB QTB to be functional. This is currently
explicitly enabled by the DWC3 glue driver, so an invalidation
happening while the USB controller is suspended will fault.

Solve this by voting for the GCC MMU USB QTB clock.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260327-hamoa-usb-qtb-clk-always-on-v2-1-7d8a406e650f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index 0c49f0461ae32..e96faa529d3c4 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -7413,6 +7413,7 @@ static int gcc_x1e80100_probe(struct platform_device *pdev)
 	qcom_branch_set_clk_en(regmap, 0x32004); /* GCC_VIDEO_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0x32030); /* GCC_VIDEO_XO_CLK */
 	qcom_branch_set_clk_en(regmap, 0x71004); /* GCC_GPU_CFG_AHB_CLK */
+	qcom_branch_set_clk_en(regmap, 0x7d01c); /* GCC_HLOS1_VOTE_AGGRE_NOC_MMU_USB_QTB_CLK */
 
 	/* Clear GDSC_SLEEP_ENA_VOTE to stop votes being auto-removed in sleep. */
 	regmap_write(regmap, 0x52224, 0x0);
-- 
2.53.0



