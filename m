Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9F06FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06073C433C8;
	Sun, 17 Sep 2023 20:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982949;
	bh=fnlPCh6ZFNY/oe3agZbtdrIIjfmq9rgK9vW1odpEFaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMw/pUVOOC3+GdmsYiMivmcqVf0BWzaVfQa8NDdZsxJPHUKim7Z1n6zAHPm2Fj+h7
	 ZQ/8C8SUE+Xmytd5WD+jTCzhraOn4wuay0njUToN+TNUYFDHl34FjhU8+s0bMV76ov
	 xqCsbzukH3hnTJ+fo83TnjMgnn7nT6H4H6wJQMFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 400/511] clk: qcom: gcc-mdm9615: use proper parent for pll0_vote clock
Date: Sun, 17 Sep 2023 21:13:47 +0200
Message-ID: <20230917191123.450043409@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 1583694bb4eaf186f17131dbc1b83d6057d2749b upstream.

The pll0_vote clock definitely should have pll0 as a parent (instead of
pll8).

Fixes: 7792a8d6713c ("clk: mdm9615: Add support for MDM9615 Clock Controllers")
Cc: stable@kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230512211727.3445575-7-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9615.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-mdm9615.c
+++ b/drivers/clk/qcom/gcc-mdm9615.c
@@ -58,7 +58,7 @@ static struct clk_regmap pll0_vote = {
 	.enable_mask = BIT(0),
 	.hw.init = &(struct clk_init_data){
 		.name = "pll0_vote",
-		.parent_names = (const char *[]){ "pll8" },
+		.parent_names = (const char *[]){ "pll0" },
 		.num_parents = 1,
 		.ops = &clk_pll_vote_ops,
 	},


