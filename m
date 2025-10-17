Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC82F12A5;
	Fri, 17 Oct 2025 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714379; cv=none; b=mfIkvWMEfXeaoNWb5tRv4+t4+TatFnOMfLL6qIZsv7vZtHXSC+0XEcyoyLftzw78FOsCFXSr+4Cp8v0+uCNBt08ffPPUKcKTe+fwKvWkqjWrIV3cHtZhj1xY9v/hZt7uzHFMke3fA3zt8c4buBO1YgpxCaBVwJQnxvPS/i50pDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714379; c=relaxed/simple;
	bh=1bMu4CiifytBfQ2Dziwi/wgTsRq73sfg1Q1uPsdoQ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn/53DAYLBrAg0s4LeCOplFmUdEVKorK+Ko1VJhUKhHP6gQ9Ta6mBNMGxyuwiIHemqrqUl1mpR1JkZXz6yzr7oGEaGzqUfTSNqI6IxR6znlzLCdAt74YqpKXpVyWHdiIIfLMD6ryHgPNsJz8i/0YsTJEiq1cFjTo6ccCEXlUZ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRaHIdZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRaHIdZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C394C4CEE7;
	Fri, 17 Oct 2025 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714378;
	bh=1bMu4CiifytBfQ2Dziwi/wgTsRq73sfg1Q1uPsdoQ4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRaHIdZfnH6+YvOMfdXKcRxwlXLHSubNzysBBqiUa3At0sfoblBuHaOCH2itJf2SE
	 Ww1YmN86wTZN6vkTbRV8V7sS6bZzlQHPpQ18lJNeEFC/H8+c4IbvGX3UtbZq/fva7F
	 U0xpwEeMs5LnJp2a+UOCTotHYwGfi48VIndo8t68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 124/277] clk: qcom: tcsrcc-x1e80100: Set the bi_tcxo as parent to eDP refclk
Date: Fri, 17 Oct 2025 16:52:11 +0200
Message-ID: <20251017145151.652280269@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 57c8e9da3dfe606b918d8f193837ebf2213a9545 upstream.

All the other ref clocks provided by this driver have the bi_tcxo
as parent. The eDP refclk is the only one without a parent, leading
to reporting its rate as 0. So set its parent to bi_tcxo, just like
the rest of the refclks.

Cc: stable@vger.kernel.org # v6.9
Fixes: 06aff116199c ("clk: qcom: Add TCSR clock driver for x1e80100")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250730-clk-qcom-tcsrcc-x1e80100-parent-edp-refclk-v1-1-7a36ef06e045@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/tcsrcc-x1e80100.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/clk/qcom/tcsrcc-x1e80100.c
+++ b/drivers/clk/qcom/tcsrcc-x1e80100.c
@@ -29,6 +29,10 @@ static struct clk_branch tcsr_edp_clkref
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "tcsr_edp_clkref_en",
+			.parent_data = &(const struct clk_parent_data){
+				.index = DT_BI_TCXO_PAD,
+			},
+			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},


