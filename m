Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438BF1353F6;
	Tue, 23 Jan 2024 00:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969635; cv=none; b=cH4fgcNnbAuUtQSLYncZeJ1Y6qrHv6OcS/cqjG1Rengh0CGIcFdbCS5dayseAhOx9YyCYINf4+7Crb97GhEI846ghthtKBS7d4HuljjYC0pq9Atfa/dd8tTQ6BQph2fPDSHIiGvyw/MdXaA1tOaZgPwWfQe4DTKS2vgaNOaQIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969635; c=relaxed/simple;
	bh=J+6ITcS1p3cujqK6IMaeWEehf1IgazOV9oa5qWAUVwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS3PLrDpIpxqblMWdGgcfhoGYCOWXrJoknlPsJocoxTcYUOBZ2NYwghONiSE5WqEPuzgCXDgs8YIGfUtOSuWNps2VGbSjqZ7+685YqVEQoSXgMIEECcOPMxnJk9HCVIY+Q9UMkll28EdsUuZ6uB60+W79IxlnHHga7F3LuS+0Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3zz3mAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3zz3mAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C6AC433C7;
	Tue, 23 Jan 2024 00:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969635;
	bh=J+6ITcS1p3cujqK6IMaeWEehf1IgazOV9oa5qWAUVwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3zz3mAn5KWWGhiuhRt08xWU5A8sX1WBYC+5DjTS1R31Jpv/eWAMe/neIBs11NVGC
	 3KIiXn651yVczcWWqI03GStksjpDpPk4OClUGLTr0TInBpj6wBIooyGfpoenUtNRRX
	 z30uB2gYuWMOzSXfJo+l+i/35pPUzlOG6ns46pY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 348/641] clk: qcom: gcc-sm8550: Mark the PCIe GDSCs votable
Date: Mon, 22 Jan 2024 15:54:12 -0800
Message-ID: <20240122235828.815238101@linuxfoundation.org>
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

[ Upstream commit e7fe73fc6b68ee97b1e8f124a66a5ee50d8d5e5b ]

The PCIe GDSCs on most Qualcomm platforms expect the OS to always
consider collapse requests as successful. This also concerns SM8550.

Add the VOTABLE flag to the GDSCs in question to comply with these
expectations.

Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-4-ce1272d77540@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8550.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index 1c3d78500392..a16d07426b71 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -3002,7 +3002,7 @@ static struct gdsc pcie_0_gdsc = {
 		.name = "pcie_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
+	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_0_phy_gdsc = {
@@ -3011,7 +3011,7 @@ static struct gdsc pcie_0_phy_gdsc = {
 		.name = "pcie_0_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
+	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_1_gdsc = {
@@ -3020,7 +3020,7 @@ static struct gdsc pcie_1_gdsc = {
 		.name = "pcie_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
+	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_1_phy_gdsc = {
@@ -3029,7 +3029,7 @@ static struct gdsc pcie_1_phy_gdsc = {
 		.name = "pcie_1_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
+	.flags = VOTABLE | POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc ufs_phy_gdsc = {
-- 
2.43.0



