Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002172E8DFB;
	Tue, 17 Jun 2025 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176964; cv=none; b=dCCJEkcOl4ONpttsNrELBoYhnS6TrJvGKG4DPXS/r0liAr8Rykhi5rwFFSGo4yuRYJNLQaRk84+y1JqHatbmAPrpBp4IAhVqjePuyB6pfimhHVI67vp06JPhx/7kzVFKjIILBCuGVUhBcO7eNzN9NYY/z9Z7rtwSyvQ6EYAdev8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176964; c=relaxed/simple;
	bh=XakU2y/JdlNsh+zpj70IcLZnkFNL9x9OnfIJaRodjTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn4nk8hkmKISmajF0YmX1AnDs1ITpbHUpjL2HnHkN71XVqtCWeRsF2EKWrmRjOI8xLQ2a6bUtSpVVuW7NR52T8Clz+/6VVoO2j1grvftXpTid7RrWraDeio9ygA4DSVj3M9+v8ZKQKUFCkexpATxDuNlhT+xR6l6/mdZfh04uUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIE8KVwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIE8KVwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085F4C4CEE3;
	Tue, 17 Jun 2025 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176963;
	bh=XakU2y/JdlNsh+zpj70IcLZnkFNL9x9OnfIJaRodjTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIE8KVwvCxrR5vhX1OhHIXEAv4Rlh++rRdLMutQuLEUCPzXXOCPzMtcvgO6eNXBuc
	 aWZBnWW+pOqWtqDM+vrSvBMbwz7cm4OE4721dHD1JlVDwpW8PXEa/g26uiHEMcnGZv
	 LPbgb2alQGAF+muYxurhVQhQ5hi2LmrKgM7oV0lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 244/780] clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:19:12 +0200
Message-ID: <20250617152501.391927114@linuxfoundation.org>
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
index e703ecf00e440..b0bd163a449cc 100644
--- a/drivers/clk/qcom/dispcc-sm6350.c
+++ b/drivers/clk/qcom/dispcc-sm6350.c
@@ -681,6 +681,9 @@ static struct clk_branch disp_cc_xo_clk = {
 
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



