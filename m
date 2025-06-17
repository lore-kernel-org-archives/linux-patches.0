Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A412DFF39;
	Tue, 17 Jun 2025 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176973; cv=none; b=gkTxB6m3a8QK1TRTAIDGKG85g4MfmYvjI9A1hd+i5sZ+4SkFnlFvS4taOd+XdqUq2MVI6HJNQkLsjsu4Wr84rNNrMiAgtFMlvALy7mGeTK1KhOS8PuNJXA3DyzrNsArxtxFCgyUOWpWmXOD5lqfNHpuHxfnqyjciKb2P0Y2AUbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176973; c=relaxed/simple;
	bh=BWn6eRPU8cmafJas5QhUMrAM/ykd7htAb3iqnnLVHqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XG7XHeFjvcClOa8BjwLv5WT5iRULV5J4pcJ4MPnX3N+2ye0vEMyOBvlAcWlUbDL6CAStcwi8rnplTH6PVFCdsUE7Qjcyy+YXlmOT/OfskfVaUrvC6HIJtxq+k1TiaJHvtPu4K2CUtVT0IOzb1zt231fFcgGe+fC1gUXSl9FmIQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdiYoF40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdiYoF40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB1DC4CEE3;
	Tue, 17 Jun 2025 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176973;
	bh=BWn6eRPU8cmafJas5QhUMrAM/ykd7htAb3iqnnLVHqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdiYoF40I9yE6Kqe6Nf5Ss49w1ajbd4wM90VFEcEz3FGD5vm863tsRMhKmjv2M3fn
	 J1nk7APIm2nhZ9u8+VQ3rg2g3OiBY9DzpxKyHuRigPqf/4m0qdxDCywbNSACFQGumx
	 ZBsCHI95ov3tvSYFpzrCOcaQ+miiHHJZAOZCXlRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 245/780] clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:19:13 +0200
Message-ID: <20250617152501.432235052@linuxfoundation.org>
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



