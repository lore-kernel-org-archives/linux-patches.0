Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6184E37CD21;
	Sat, 12 Sep 2026 07:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197876; cv=none; b=LKOF9WdziqRUHZxcla5o/uZwR2nE+qAKJ7q3PTKRdmDDriVvYwqojPrMv6u1wY88PzjbFoJjqWoXYciwog4FXEJ2OoivbrrknqHm0CJ9yUgjEyLKu8BxpAOAnumaIS1WgKg5qtfPiRYtG/mauE8sBYXkVhVFD1s1WSdjKPDR52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197876; c=relaxed/simple;
	bh=OBbHPmSq6BOkxCnugMULfKEH/DiC3Twq+fqYisBvJ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE+AFGcsU0gcolOwPu/xdExHJvZpnouBwobg60PG/1DwpKG/5OzAgWT4MMFwM2N+3cg9xd57QGQjiqoS7VgI5Ltic/GjM7SC3NZz9GrkclleFNiY+VlGFCQ17YqkJn7h9dfakcsLd+Iz11ZsuvXq0tXRRu3KHl9n0Fw7QmceI9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBh6wTrp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBh6wTrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CCD1F000FF;
	Sat, 12 Sep 2026 07:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197875;
	bh=6oIL77+1+9dT+AazCJ+OyLvSJfumyusdQ1xrXP+0o0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBh6wTrpuWNIvJuVk/P6aFHzfnSXdrNQj2gd+QnJj/RBGjDwTArZXe+M91QR1pV0c
	 1sllJL8YY1+gFDF0WlA19ErlPjE9V9UVzsQshTJio+KMomf87ALKBW3+jEx2Pvqk2B
	 7wXFulDeiAWP6IUWv94Xkc0FUXLjIkb3K3O8Rfd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0264/1815] clk: qcom: gcc-qcs8300: Use retention for PCIe power domains
Date: Sat, 12 Sep 2026 08:33:34 +0200
Message-ID: <20260912065655.170496719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 07218d9c96a7d..71c5a901715ff 100644
--- a/drivers/clk/qcom/gcc-qcs8300.c
+++ b/drivers/clk/qcom/gcc-qcs8300.c
@@ -3267,7 +3267,7 @@ static struct gdsc gcc_pcie_0_gdsc = {
 	.pd = {
 		.name = "gcc_pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
@@ -3281,7 +3281,7 @@ static struct gdsc gcc_pcie_1_gdsc = {
 	.pd = {
 		.name = "gcc_pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = VOTABLE | RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
-- 
2.53.0



