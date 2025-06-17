Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C01423771C;
	Tue, 17 Jun 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176953; cv=none; b=ocxbILaHK9zKTJCboZ85B8tqMlcY7k+LZrTNccr5KJK4Qq/VSTntk0gj+f1J7VFnoh29gm4brvU/KlteID15cc6uICK7qEyS0B8gZ/MU66/GwaOBCcMdJI0MOi+ZzgsWg3TEvjZRVJ9PkFjkoPuCHE7Gr1iqDIjX6D/3LdlxZqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176953; c=relaxed/simple;
	bh=F5AP8wTXUhI8i/FwbAzgdt/nYSZo5cVDiKqgMRbrbJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmcJ+kq+oSCaVHLjpTmIx0bV6yT6QfAaxJjuG9jv4aKF+CqVPqx+fsNKQ2hbNlh99u9VWpWXLQbwdk85D+lINno55xzxI04m8cREYFdbyV4FBeKI+fNglVN4BLyojyCSIX58bHNEiJcveIT/DGfOKRN5UEuLA5yHr0V9Qbh0CnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kZ/9PFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kZ/9PFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC7AC4CEE3;
	Tue, 17 Jun 2025 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176953;
	bh=F5AP8wTXUhI8i/FwbAzgdt/nYSZo5cVDiKqgMRbrbJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kZ/9PFOpUua9RKScf1Zsljb7xZvWVvkMTb/sz7SIVR0FvQhjQpVBo5buO9IzFALW
	 uNw/HUtvb7M6rvYtk4V1ukPffA/KJJxIikEGkDvPhc7Q1fkha9xHIrtlfpaQyQxXwD
	 mGNNMep/QY463/O05pJK1P5F0Hj9DvkkVLIz7H4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 243/780] clk: qcom: camcc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:19:11 +0200
Message-ID: <20250617152501.347405325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit e7b1c13280ad866f3b935f6c658713c41db61635 ]

Compared to the msm-4.19 driver the mainline GDSC driver always sets the
bits for en_rest, en_few & clk_dis, and if those values are not set
per-GDSC in the respective driver then the default value from the GDSC
driver is used. The downstream driver only conditionally sets
clk_dis_wait_val if qcom,clk-dis-wait-val is given in devicetree.

Correct this situation by explicitly setting those values. For all GDSCs
the reset value of those bits are used.

Fixes: 80f5451d9a7c ("clk: qcom: Add camera clock controller driver for SM6350")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20250425-sm6350-gdsc-val-v1-1-1f252d9c5e4e@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sm6350.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/clk/qcom/camcc-sm6350.c b/drivers/clk/qcom/camcc-sm6350.c
index 1871970fb046d..8aac97d29ce3f 100644
--- a/drivers/clk/qcom/camcc-sm6350.c
+++ b/drivers/clk/qcom/camcc-sm6350.c
@@ -1695,6 +1695,9 @@ static struct clk_branch camcc_sys_tmr_clk = {
 
 static struct gdsc bps_gdsc = {
 	.gdscr = 0x6004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "bps_gdsc",
 	},
@@ -1704,6 +1707,9 @@ static struct gdsc bps_gdsc = {
 
 static struct gdsc ipe_0_gdsc = {
 	.gdscr = 0x7004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ipe_0_gdsc",
 	},
@@ -1713,6 +1719,9 @@ static struct gdsc ipe_0_gdsc = {
 
 static struct gdsc ife_0_gdsc = {
 	.gdscr = 0x9004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ife_0_gdsc",
 	},
@@ -1721,6 +1730,9 @@ static struct gdsc ife_0_gdsc = {
 
 static struct gdsc ife_1_gdsc = {
 	.gdscr = 0xa004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ife_1_gdsc",
 	},
@@ -1729,6 +1741,9 @@ static struct gdsc ife_1_gdsc = {
 
 static struct gdsc ife_2_gdsc = {
 	.gdscr = 0xb004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ife_2_gdsc",
 	},
@@ -1737,6 +1752,9 @@ static struct gdsc ife_2_gdsc = {
 
 static struct gdsc titan_top_gdsc = {
 	.gdscr = 0x14004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "titan_top_gdsc",
 	},
-- 
2.39.5



