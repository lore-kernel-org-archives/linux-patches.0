Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B7E3232;
	Wed,  2 Oct 2024 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879977; cv=none; b=hBUzQzDK16RmgL8pAEmISUas+EWxngRbMDNFlKPjNd1F0dUjllUZ8+YfiGspmnkFkcnsRxOae1JpXSv1dNaqhCgxwpAPUUuW6hB2QKX2HKB/Lf5MflTs27c5GBvFGcFLX0snzak2ZxgcT4aTSzJKqGB6htM7EpV2/b35AfDcWTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879977; c=relaxed/simple;
	bh=yuIQbYZQf1SxQ03zs96XcWltSpB8OBn15JRLDCv5eVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpR+FaNE3UaUKDMCH37Z0/6xAw7Hp4u2eVZ3R/MtSW9Qnx0Fr0JpX4Yx9/c3sMaZj4yah5PDBSe0rIwhAbdbC0c6gbLKcc6i074zgfyRduwStgyIjjFmf2QWpG+TrJ9+8Xa4SQL24E0DZs7rCDPzmUclrX4t5Ix/3Cd19hr1S8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pca2WtJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pca2WtJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4120AC4CEC2;
	Wed,  2 Oct 2024 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879977;
	bh=yuIQbYZQf1SxQ03zs96XcWltSpB8OBn15JRLDCv5eVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pca2WtJmxGTuT1pY3noBcOQi1pUjT+NXYMJPx3SPMBFmrAaHBRVA9LKMdKTNaNUWE
	 ZHyYfQaJ7czcAKb19p+qBUAUDvWB8NcdOQvvhigykgFOcgx3e2RoOT0JOC55QkflCn
	 I9NKNKZEWFq8W6cDqljsWONshXbY05wdN2UcGNus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/538] clk: qcom: dispcc-sm8550: use rcg2_ops for mdss_dptx1_aux_clk_src
Date: Wed,  2 Oct 2024 14:58:30 +0200
Message-ID: <20241002125802.955001950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit cb4c00698f2f27d99a69adcce659370ca286cf2a ]

clk_dp_ops should only be used for DisplayPort pixel clocks. Use
clk_rcg2_ops for disp_cc_mdss_dptx1_aux_clk_src.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-2-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index e868c5c426096..72558ef25e9e8 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -400,7 +400,7 @@ static struct clk_rcg2 disp_cc_mdss_dptx1_aux_clk_src = {
 		.parent_data = disp_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_dp_ops,
+		.ops = &clk_rcg2_ops,
 	},
 };
 
-- 
2.43.0



