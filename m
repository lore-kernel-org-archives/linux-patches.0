Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125F737DE8A;
	Wed, 20 May 2026 18:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302476; cv=none; b=ItF46Gcw56//OaHQZyc+9hku5cZ2BXPLjU1SGUoLAG3/UxixBvNhLt4RX/EHLqrq1v5HReEX3qJUwQRDMvt0MWgCzMtBHYAyjvVnK1EZa0NdbGIMqHz1wwdWiAsDFU92II6Xr8OLVOZe5ARt7PCy/qpuGM1i/s0IXNF2xNYS7fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302476; c=relaxed/simple;
	bh=yw+TELryf/EwL5d5NO2kTBXnqD33NuSHpmQpVuKvfZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4M7BLh5Mj+9TOhrqVto+Nty7DSfKTvMQm/W5SycwrrxwrM12gujL7VRiFKCpR7lcsFdOXYh0RNm33iFSribKircFQyDyHh/AS+E9KjXPo3labDlV3ANkpH/ZJ8kHbKdGlecYdLtXpYm5KS42215PZZz2DVB6iUgh3UmriIGnNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSyrIydV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSyrIydV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772571F000E9;
	Wed, 20 May 2026 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302474;
	bh=bEQIMQEwx6Vqg3+SVcDjTUr6ArPsz0QieUIon51teUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSyrIydVnNW8i4iatw1t36Sol9q+1DOSGrGIP/AfLXr5T8GJqTxkhuNQDpV0HXzfK
	 kyOqQ9ZwWMaUavVwbD646yDInrdSmNOvJlAtkDrhDmNCJ1IrViLLzSAFbQz/2TOnQn
	 CfKYuK8dc6T+uJA6O7F3ZPfDfNQwQyazN342uVx0=
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
Subject: [PATCH 6.6 281/508] clk: qcom: gcc-sc8180x: Use retention for PCIe power domains
Date: Wed, 20 May 2026 18:21:44 +0200
Message-ID: <20260520162104.733077073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 889c1ab6d63f2..dd21a5898c5a5 100644
--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -4132,7 +4132,7 @@ static struct gdsc pcie_0_gdsc = {
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4159,7 +4159,7 @@ static struct gdsc pcie_1_gdsc = {
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4168,7 +4168,7 @@ static struct gdsc pcie_2_gdsc = {
 	.pd = {
 		.name = "pcie_2_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
@@ -4186,7 +4186,7 @@ static struct gdsc pcie_3_gdsc = {
 	.pd = {
 		.name = "pcie_3_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
-- 
2.53.0



