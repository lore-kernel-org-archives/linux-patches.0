Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C95D70838;
	Mon, 23 Jun 2025 21:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713017; cv=none; b=s8ZatGTJpESwIxSY8CxyZfqxQilPl1KxFG1c4PJC+F+0fGqxVnx/TcCo58wF7fcawVOyy88jI45K76Yo4HTrGR39YKvi1ST6b0yrOIVRivmyeBi9dY38aPOXAQT1fqF4+w06lZ443mRXt34rl7DMdbFMv50QrpadI57UGr4qiSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713017; c=relaxed/simple;
	bh=/xsJUh9+gi7pFjav6nZ6Z/BTFxQzossEpplOU8Cmt2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLVCYmh4VjHTHuHGCz7NW6q04AW74EFq91TXtIDBqPePCJyyQ53Bxvv/oIBeIcx5/vUbDX4ye6Tgxv+6twsBz1nt+kw5tF8FrBgIq7qMojcurkxKJNAo2IoDRMmTXnMSaIoUvFJnAMLPkRvi5lLuJgcLoZkZnFrjc/yQJyeQZrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nL/7a/sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nL/7a/sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15168C4CEEA;
	Mon, 23 Jun 2025 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713017;
	bh=/xsJUh9+gi7pFjav6nZ6Z/BTFxQzossEpplOU8Cmt2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nL/7a/snYtLsG+473St9lefZTb9uezsQfO418DXC33nGs6qmFRirXSS0dl80xQnPx
	 3k/OI7BzA3vsHBGP9IO91Me+jHpAXewpRWksDmQXBpQxkszBs3PK7mBux14KxB7gK2
	 w2Q8diycVboYhchTvxqD9CfZkbtuNjoqI318qymE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/508] clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs
Date: Mon, 23 Jun 2025 15:01:57 +0200
Message-ID: <20250623130647.010207169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ddacb4f76eca5..ea98a63746f0f 100644
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



