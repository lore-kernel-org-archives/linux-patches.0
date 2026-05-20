Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C222B3EEAED;
	Wed, 20 May 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296343; cv=none; b=GN7b9/6uj/ZDjErB/X6NJJk1M0j6QljY3DKE9uVX8OBqQ0wB8K54oPBvFX1PIGu75riu3guliizS21IHG0TY6VZBUbIHF1up2Z0HLilBQCGHHiX4oc/6/r9mL7edms230B2J38112NiQJ6V+12RDfoCt95ahLyN7GgCvyKPklho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296343; c=relaxed/simple;
	bh=PyK1fQPTP1FmqyoIB8IUgSA4ZZ4hx2uzwjuIkf2jYSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zvg7FRnVIXlJR6YiXJUQmAuagq+hoQpQR1EzUs8vwsLI0kXaAxIqSsL3+kZlX6eZkFrYpAG3oKOVq2vu0mxyqaDvbLX3ie97tcd3MGAgk5wVNjwIkNXciFzJKJmMqoyWOVxIYVzXyTf+9jDNpc8k8/D6b2Ql+UE2VLc1s5vfnks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlIRQCRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlIRQCRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E241F00893;
	Wed, 20 May 2026 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296342;
	bh=sZM5ZnddiV8VcQ48rt1Q4Y5Oep5mipVtPAAufdeZYaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlIRQCRm4Fqcsun0x0ZwHxtPMhANK5B56UWv68+xo+Gg3JJ4X1XHIAKCCE24t1cEO
	 1bRACF6xxgSCkAFGQe4CR8c5pOYetPTigOrwrPt0Gu8XjkmppEt7rpUv4oR7EdlmHg
	 +6xH5E3MUcC3/ZfKE437wnBlQYcvkaz1MdBvY9zA=
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
Subject: [PATCH 7.0 0736/1146] clk: qcom: gcc-x1e80100: Keep GCC USB QTB clock always ON
Date: Wed, 20 May 2026 18:16:26 +0200
Message-ID: <20260520162204.862950694@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 74afd12c158c0..73a2a5112623e 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -7480,6 +7480,7 @@ static int gcc_x1e80100_probe(struct platform_device *pdev)
 	qcom_branch_set_clk_en(regmap, 0x32004); /* GCC_VIDEO_AHB_CLK */
 	qcom_branch_set_clk_en(regmap, 0x32030); /* GCC_VIDEO_XO_CLK */
 	qcom_branch_set_clk_en(regmap, 0x71004); /* GCC_GPU_CFG_AHB_CLK */
+	qcom_branch_set_clk_en(regmap, 0x7d01c); /* GCC_HLOS1_VOTE_AGGRE_NOC_MMU_USB_QTB_CLK */
 
 	/* Clear GDSC_SLEEP_ENA_VOTE to stop votes being auto-removed in sleep. */
 	regmap_write(regmap, 0x52224, 0x0);
-- 
2.53.0



