Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795242DFF1D;
	Tue, 17 Jun 2025 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175691; cv=none; b=mYWu3E0Y0EVBlyJUtrnxa+ajJM/XjR4pySgIpzYiRiRWQuxwNWVrgYDrclWv0EGmOScmesefrPqT4ub8SPqsjNZhrf0l1uGlJzgtc6XLb5UuPUFBNfWJOKxc+xjNAx4vPWO/lG/3fQSK52yTI8pznzshe/zLuM4oY0Y/3esfGk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175691; c=relaxed/simple;
	bh=TN9zV3kugQAhTLcV9Yf/N84tuBoMkPLZoRIbyjHfamU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXMPpTPXZd5wgSNmfaOaHCT7fspNmDcGBo0szNdSG4VC8ktxaJTL/9sdvpAOu6FKWV2pLcXICph/sOkbu1bPoLZWCGqJCe4lQu0mj+qB+ykGlPM86xxYdd8xJkoA0kbY47FF576TOEFgSGomsMqv7/H4w0kDd+A/R2vQY6xyocY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDtQ8Vbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDtQ8Vbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB638C4CEE3;
	Tue, 17 Jun 2025 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175691;
	bh=TN9zV3kugQAhTLcV9Yf/N84tuBoMkPLZoRIbyjHfamU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDtQ8VbxM02RPecoeRzGgXBbhiTtE727e00UjTYaTR2l+rY3grPjEkFJfL4Oc2gWW
	 QRWPDTBTAq7dCOnw0DMVzhBX7iyPrlTRof8mI5/iQvHy5E1+z2fOplaEc2XJq9ME4C
	 IfeUzjsgmSLnHVVuIrOja6Dc9HtIgornxHpM6v+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/512] clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:22:00 +0200
Message-ID: <20250617152425.848881972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit afdfd829a99e467869e3ca1955fb6c6e337c340a ]

Compared to the msm-4.19 driver the mainline GDSC driver always sets the
bits for en_rest, en_few & clk_dis, and if those values are not set
per-GDSC in the respective driver then the default value from the GDSC
driver is used. The downstream driver only conditionally sets
clk_dis_wait_val if qcom,clk-dis-wait-val is given in devicetree.

Correct this situation by explicitly setting those values. For all GDSCs
the reset value of those bits are used.

Fixes: 131abae905df ("clk: qcom: Add SM6350 GCC driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20250425-sm6350-gdsc-val-v1-3-1f252d9c5e4e@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm6350.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sm6350.c b/drivers/clk/qcom/gcc-sm6350.c
index 74346dc026068..a4d6dff9d0f7f 100644
--- a/drivers/clk/qcom/gcc-sm6350.c
+++ b/drivers/clk/qcom/gcc-sm6350.c
@@ -2320,6 +2320,9 @@ static struct clk_branch gcc_video_xo_clk = {
 
 static struct gdsc usb30_prim_gdsc = {
 	.gdscr = 0x1a004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "usb30_prim_gdsc",
 	},
@@ -2328,6 +2331,9 @@ static struct gdsc usb30_prim_gdsc = {
 
 static struct gdsc ufs_phy_gdsc = {
 	.gdscr = 0x3a004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "ufs_phy_gdsc",
 	},
-- 
2.39.5



