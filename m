Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A206254B03;
	Wed, 25 Feb 2026 01:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983463; cv=none; b=VEf7nLUNpGzOKJD4SJG4PBWiGNXCSoUF8+CLYKNIVhf1RyAK6RSFZcZBJyoJSL9Q55tx1mSXOSt6DXQI3T9l71ODlp4CbYr6gN6AU5XGte9f98dnnOkR25r/imSLUvqRMGwbgH7u8rx47RoKCmFVS7tK73PdBWVngKcqKlgMwgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983463; c=relaxed/simple;
	bh=JTwuJhBrHgvAjJ0eoq+14Emib3h4injhWhI8YTlfdsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkwEB8hrlSSB2hIkpfSUZDd40qkAB2BGzzcozFtfCDPijQ46P93HIsc5cd+RZWxc8u4KlK9+lGA839Yz0p/Wo35Wfotm9mgmYGG8ZRpEg/66eqgM/oa3bq9pYFQjBsmTGGzW6G/ETR4X3Bqyp/4VM7PESkebf6RFimb718CFukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlfN8A2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlfN8A2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C41C116D0;
	Wed, 25 Feb 2026 01:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983463;
	bh=JTwuJhBrHgvAjJ0eoq+14Emib3h4injhWhI8YTlfdsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlfN8A2yqRypys6iVBL58F0r786eIw3xkK8fBWNgNsIaB72N0IHx+iXEZ57cc0TVs
	 LBjknUiYWE0EHN6t8Y7lzWzB8/RXQ9C1OGMnhn7zC+cgiDKBcVDuIckE/bpWH+mpFs
	 WMrkqgf/kr787M2g/rww2h0V/4mIP4viFx9wf4u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 535/781] clk: qcom: regmap-divider: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:44 -0800
Message-ID: <20260225012412.919404359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit d8300e6e078a3a44ac0c75c6d8ba46d78ab94035 ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: b6f90511c165 ("clk: qcom: regmap-divider: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260108-clk-divider-round-rate-v1-16-535a3ed73bf3@redhat.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-regmap-divider.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/clk-regmap-divider.c b/drivers/clk/qcom/clk-regmap-divider.c
index af9c01dd78537..672e82caf2050 100644
--- a/drivers/clk/qcom/clk-regmap-divider.c
+++ b/drivers/clk/qcom/clk-regmap-divider.c
@@ -34,12 +34,8 @@ static int div_determine_rate(struct clk_hw *hw, struct clk_rate_request *req)
 {
 	struct clk_regmap_div *divider = to_clk_regmap_div(hw);
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       NULL,
-				       divider->width,
-				       CLK_DIVIDER_ROUND_CLOSEST);
-
-	return 0;
+	return divider_determine_rate(hw, req, NULL, divider->width,
+				      CLK_DIVIDER_ROUND_CLOSEST);
 }
 
 static int div_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



