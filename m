Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8693B2DF3C9;
	Tue, 17 Jun 2025 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174772; cv=none; b=fKwO9qOzYBkyds7g4yE6IGejkX2cbentOYiQiRdI21PzMIVKKklHbuP8wbtbFUJ/kuZOAFC49S4BEBfbOd+pxb9cGvejbvjFfy3Ke9irF/yCfwybEIjCddBHMQupjeIdqu+qmLu0O9IvvSVCuAVo/EUs9rghRfgn0hJRbUaNhBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174772; c=relaxed/simple;
	bh=KCfGsJCxq+lm9faYP7Bc/YYvqTQQ66R4gltilFK9oI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXaH75dBcSF/dqK52L7xjd5UOnaJ7leGG+Ky6czsoC3yqou5+g6Kq2EQQ/ZpIT6EOdUdBlCbl76DfIvELrg36TXbFhzQwab/z8a/cnBM7iODAbVbpzYJbiZGhkG82gzTdehHKH/yCGsQiFa8eCBByjU4z4xGaofXjivdsfe4DMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNf0Z+5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNf0Z+5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8085C4CEE3;
	Tue, 17 Jun 2025 15:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174772;
	bh=KCfGsJCxq+lm9faYP7Bc/YYvqTQQ66R4gltilFK9oI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNf0Z+5mBwwOJDaJSU8djTHHvJOWuRbu+tlOQz2FKIluU/+AjGJnbjq7Mskw9QHo/
	 ZtmOn173bbTTjSqWNiJA8LU5gyF6OEfKhd51SSh9rxH/Jm8ae/hcXiVN1r99gjobH+
	 AMinV6zR3s39gZFm/rVZetmjJi9PDPSkSqw29+7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/356] clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs
Date: Tue, 17 Jun 2025 17:23:47 +0200
Message-ID: <20250617152342.726472477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



