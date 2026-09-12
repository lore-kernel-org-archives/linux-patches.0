Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899720ED;
	Sat, 12 Sep 2026 09:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206715; cv=none; b=O6ACFMAgTMn3+dFafLc0+2c2Y6+JBZofg2S+eNu0af2ePBxAh5v8/rL+b+uXn2Bup94FkL7era6sx8VXUSS5IOg7avAyl3dFuA7efpbZRcl8F7RhMDWsCTiuScHey44uIfzq6ebTk3ZU71br4tvvOX2Eu7q6iJ1LOmdo4RrYncY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206715; c=relaxed/simple;
	bh=/i/3A6hhJeZBKuHJDDlUV0adEJsJETUdYnuDznrHrIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfUihmx/fW/4F/n8jOaOZW9qvMrEpU5jUJPSjDUGM5ne6QQyw3RZrjX12/ASMfCllsUAaAb404+PKyI8NANLo+15Y2xOiYvwt2OUuQv2smgZovH/d0vndoF5+TlL9I+2Nm99l39gINX6f0q1a3gOmeB7FUC71CFk1gM/3sgyc3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkhlEmiM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkhlEmiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F41F000FF;
	Sat, 12 Sep 2026 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206714;
	bh=sl3y3QTag1mw75VvybUKm6h9egpl62iMOmeB5TnM5Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkhlEmiMPWhm0kjA0HWR9mGQx6mMC7ju37305twZ/vkOOIUDUZsbodWR655w4Ia8G
	 10ubZcn+t0DchA2ekFSv8YYEK6KPmw3hhvNUW5AqjQb466fgo+R5w1UOpdZflVMJs2
	 GY8w6c+IWFfcCphiHaGs8ZV0CaT8sVduvRK8JWTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0263/1518] clk: qcom: gcc-qcs8300: Use retention for PCIe power domains
Date: Sat, 12 Sep 2026 08:40:32 +0200
Message-ID: <20260912065629.436841182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 11b170abe4d324cac0d15a410282d1ec2b6bafa0 ]

As the PCIe host controller driver does not yet support dealing with the
loss of state during suspend, use retention for relevant GDSCs.

Fix the PCIe link not surviving upon resume, and GDSC error:
  gcc_pcie_0_gdsc status stuck at 'off'

Fixes: 95eeb2ffce73 ("clk: qcom: Add support for Global Clock Controller on QCS8300")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260629-monza-suspend-v1-1-b601d8a2f2f8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs8300.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcs8300.c b/drivers/clk/qcom/gcc-qcs8300.c
index 80831c7dea3bc..009672b75fb90 100644
--- a/drivers/clk/qcom/gcc-qcs8300.c
+++ b/drivers/clk/qcom/gcc-qcs8300.c
@@ -3268,7 +3268,7 @@ static struct gdsc gcc_pcie_0_gdsc = {
 	.pd = {
 		.name = "gcc_pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
@@ -3282,7 +3282,7 @@ static struct gdsc gcc_pcie_1_gdsc = {
 	.pd = {
 		.name = "gcc_pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
-- 
2.53.0



