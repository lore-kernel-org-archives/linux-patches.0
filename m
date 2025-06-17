Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB42C2EB10;
	Tue, 17 Jun 2025 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175681; cv=none; b=QyF7Lu37Q06sPl9kTNl1duortS73egvSP4Ld2v+uDJCmHeR7D4jIipA/3e1YKqxb6QHJoCeezSGhxjLPdaTwYQZIIzVvcugO9qAngs5cSFMNaaVDnPuoVyNHLwvookjRwkCXFPOR/nPkPX9JgK+4xd2QF7WvqY+STRdHiub6xCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175681; c=relaxed/simple;
	bh=2MqfDv0abWxMcTiTKTeUGnvGParP36vOrnxVD6vlNRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNEbe0zHtqTyVh3v5LnxFTs3Df0y7bDZMfd+9+x6xSH5+7H0UwajePDnngyV1IheTtIauCP7RLvUPzkBZh7Xz6I373iRWHiLT4y21isFuvMTdLFACBgUUU7/J+GFdiqnQRTbvdKr2FLpBtQ5B8DK91jT3/lQ3vIq30RZ9UzaHYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj3FSEBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj3FSEBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BE9C4CEE3;
	Tue, 17 Jun 2025 15:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175681;
	bh=2MqfDv0abWxMcTiTKTeUGnvGParP36vOrnxVD6vlNRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj3FSEBevu0KeE1eu5Tbb1FTZvQmnsg8Mq8u6PKA/G9OCcGjDGytC7E5iZ0Dikuaf
	 yjjpCsq/Rte+XM0fGLO0mZpnqiFIaLwEbUxbOfYlFmfTBkR4E1dEfNauJiBWTiYbzN
	 uhxdMWwKE3NkPAnb7ltXl0fMzofNNSV0vDoAIDt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/512] clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:21:59 +0200
Message-ID: <20250617152425.809337329@linuxfoundation.org>
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

[ Upstream commit 673989d27123618afab56df1143a75454178b4ae ]

Compared to the msm-4.19 driver the mainline GDSC driver always sets the
bits for en_rest, en_few & clk_dis, and if those values are not set
per-GDSC in the respective driver then the default value from the GDSC
driver is used. The downstream driver only conditionally sets
clk_dis_wait_val if qcom,clk-dis-wait-val is given in devicetree.

Correct this situation by explicitly setting those values. For all GDSCs
the reset value of those bits are used.

Fixes: 837519775f1d ("clk: qcom: Add display clock controller driver for SM6350")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20250425-sm6350-gdsc-val-v1-2-1f252d9c5e4e@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm6350.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/dispcc-sm6350.c b/drivers/clk/qcom/dispcc-sm6350.c
index 2bc6b5f99f572..d52fd4b49a02f 100644
--- a/drivers/clk/qcom/dispcc-sm6350.c
+++ b/drivers/clk/qcom/dispcc-sm6350.c
@@ -680,6 +680,9 @@ static struct clk_branch disp_cc_xo_clk = {
 
 static struct gdsc mdss_gdsc = {
 	.gdscr = 0x1004,
+	.en_rest_wait_val = 0x2,
+	.en_few_wait_val = 0x2,
+	.clk_dis_wait_val = 0xf,
 	.pd = {
 		.name = "mdss_gdsc",
 	},
-- 
2.39.5



