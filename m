Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F43312825;
	Wed, 20 May 2026 17:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298857; cv=none; b=NwDUFfc+Hv0Zq3lL8fc2/zBZ8sGfhl1Np5cleJSXOIesDS4TEh1FS2faeSZYzuzJa4iSeDxKW+WDzzt6Vk220KzEjOC9pVcPADVFcoDL5EXGvigQI0xuezDI99IvoYWpzB2wjieufXzJYsYoaAoG3+GKvWXU291nt7jG7sVBCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298857; c=relaxed/simple;
	bh=zITMwGxhlhNq+XsSVOhx77Su+D145YbSSRpDo5n2XvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDt/lMtXVevWIUNzeR6lwpMQdgBVuDAK+AyDlY6g9bag7faqh/L3hB7qaAJNTk+Gbf5Zz+ITrQWIXS4QnHhgAO3pfyaaEB7sJdtzAupk+Tsn19lP1yLIocFiuUfHENHwA7HYXai478XopER3IZ0fX4sy4IKTL5czIN3Y0nCnpQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2cFFK+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2cFFK+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CC51F00893;
	Wed, 20 May 2026 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298856;
	bh=+OaiSXdQI2emhYbVd2Elc0JVxYgifFwQmz1c7H0r+1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2cFFK+jktWLc9+JpsxPr4tmbDFC5sfA4BmKqhciVbh4SumtAzT4Im4ga5sbCxznv
	 87XejV98AvDW136Jw/gcEVxRGXJm3t8I+mkN2V8fD0nUsAa9Ncao3GbiHlZQ+QbUZ0
	 PjS6xCsMHwNZ3EG5opPFxUS2WPYsTlQyKFmwsJm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 568/957] clk: qcom: gcc-sc8180x: Use retention for PCIe power domains
Date: Wed, 20 May 2026 18:17:31 +0200
Message-ID: <20260520162146.847358986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit ccb92c78b42edd26225b4d5920847dfee3e1b093 ]

As the PCIe host controller driver does not yet support dealing with the
loss of state during suspend, use retention for relevant GDSCs.

This fixes the link not surviving upon resume:

    nvme 0002:01:00.0: Unable to change power state from D3cold to D0, device inaccessible
    nvme nvme0: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS read failed (134)
    nvme 0002:01:00.0: Unable to change power state from D3cold to D0, device inaccessible
    nvme nvme0: Disabling device after reset failure: -19

Fixes: 4433594bbe5d ("clk: qcom: gcc: Add global clock controller driver for SC8180x")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20260312112321.370983-5-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8180x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc8180x.c b/drivers/clk/qcom/gcc-sc8180x.c
index b116a9c0b2d94..4095a1f54a099 100644
--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -4199,7 +4199,7 @@ static struct gdsc pcie_0_gdsc = {
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4226,7 +4226,7 @@ static struct gdsc pcie_1_gdsc = {
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4235,7 +4235,7 @@ static struct gdsc pcie_2_gdsc = {
 	.pd = {
 		.name = "pcie_2_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4253,7 +4253,7 @@ static struct gdsc pcie_3_gdsc = {
 	.pd = {
 		.name = "pcie_3_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
-- 
2.53.0



