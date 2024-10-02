Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426161D04BE;
	Wed,  2 Oct 2024 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878164; cv=none; b=aKPSabbzZTn/lXLg96Qwp0UvIqhFplrJXiwUyi1NIZJOgha8UGGhZFNR0Wh1jh+u4liG6T29cK0Hb5q3wkSi7pQo2BGQKFiJGbId0ELrWjfK5Cv79d5qAA5EjIyh1WfmvQ5WLjrRAyagGEjjP7GNMfnJFzLhOEzGwkrbNjypNf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878164; c=relaxed/simple;
	bh=y06K/m4q+5FdSWiNJ42WDRN4ga8i2zPdF9yMlN8afog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0aLXOCyJvAtDddefvr8blqlOKP3+u8m+crlbqKk/b8cOUQAheSf59HfDObZtbijEOoFZ0wZKuOiACvmfGEp27+bAVRXYM6BVYyovqQc5u0antlZLiSwlrwwwunixLDmI5kQDfPPEDLiZm4WOyd2UQEZxIgE9eI+X2+IMiVmEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caAKr0xb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caAKr0xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2D4C4CEC2;
	Wed,  2 Oct 2024 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878164;
	bh=y06K/m4q+5FdSWiNJ42WDRN4ga8i2zPdF9yMlN8afog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caAKr0xb9kSSHjC3uLtyaYNx9cKTB2vDcJKQl/OxqGbivuIb0wWUYCousclmGChKQ
	 GSvYno9q6LmypY20F55Di4kgAiAwv1T6AsxfbiAmf+bhXXPmwyvJzSwWFdjvJYNbAX
	 nPUP45W5GM8txJV8E7Tu3BcQpD+sedWIBv4ncZn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 321/634] clk: qcom: dispcc-sm8550: fix several supposed typos
Date: Wed,  2 Oct 2024 14:57:01 +0200
Message-ID: <20241002125823.774423184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 7b6a4b907297b28727933493b9e0c95494504634 ]

Fix seveal odd-looking places in SM8550's dispcc driver:

- duplicate entries in disp_cc_parent_map_4 and disp_cc_parent_map_5
- using &disp_cc_mdss_dptx0_link_div_clk_src as a source for
  disp_cc_mdss_dptx1_usb_router_link_intf_clk

The SM8650 driver has been used as a reference.

Fixes: 90114ca11476 ("clk: qcom: add SM8550 DISPCC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240717-dispcc-sm8550-fixes-v2-1-5c4a3128c40b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sm8550.c b/drivers/clk/qcom/dispcc-sm8550.c
index 38ecea805503d..56918e2a7734d 100644
--- a/drivers/clk/qcom/dispcc-sm8550.c
+++ b/drivers/clk/qcom/dispcc-sm8550.c
@@ -196,7 +196,7 @@ static const struct clk_parent_data disp_cc_parent_data_3[] = {
 static const struct parent_map disp_cc_parent_map_4[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_DP0_PHY_PLL_LINK_CLK, 1 },
-	{ P_DP1_PHY_PLL_VCO_DIV_CLK, 2 },
+	{ P_DP0_PHY_PLL_VCO_DIV_CLK, 2 },
 	{ P_DP3_PHY_PLL_VCO_DIV_CLK, 3 },
 	{ P_DP1_PHY_PLL_VCO_DIV_CLK, 4 },
 	{ P_DP2_PHY_PLL_VCO_DIV_CLK, 6 },
@@ -213,7 +213,7 @@ static const struct clk_parent_data disp_cc_parent_data_4[] = {
 
 static const struct parent_map disp_cc_parent_map_5[] = {
 	{ P_BI_TCXO, 0 },
-	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 4 },
+	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 2 },
 	{ P_DSI1_PHY_PLL_OUT_BYTECLK, 4 },
 };
 
-- 
2.43.0



