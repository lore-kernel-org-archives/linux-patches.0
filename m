Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93C1D5141;
	Wed, 25 Feb 2026 01:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983461; cv=none; b=a8rV4cXHWHOkQAVBdU9ikfDpwteRKRal7AJ7ezR/0S5h69jbJqL69AhjybNBhPvluZNQ43uQ3ibU3vrVX6giwrzillGFn/AYzF4Yuad73qJ4lSDvRmZuQMr6pVUkqMq+MZahuL19yjzlp3deJagWxfbvZPblgufA6tF1eXXJ+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983461; c=relaxed/simple;
	bh=+paGgzIAyzeOrXROiGuzivurgDxdoCjqJBMNIFPJW5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKtyz1N+G7AR43A3U5GYX1vXKAl43MPFMgzcxEbd2x3AquHZy8zSyZiDkMQebwXhFMXkDgxY5tragIO3i+p6sxofLhCH7CeXSk+Md1AFyguqznzVfLADSNOw5k1wRUKyAOrLcj5xRVMjlpYG8MrdhE9nwxerYjg4QLxAjQz6Hnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDU/N5ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDU/N5ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F77BC19424;
	Wed, 25 Feb 2026 01:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983461;
	bh=+paGgzIAyzeOrXROiGuzivurgDxdoCjqJBMNIFPJW5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDU/N5ms1c10hmuyrcFvQ3k326in2MXz153FLu/KxwbaH/XPso7iiWnMFnVdJSAlV
	 90o+uAbE7oto0qsQo5JABJRmehdM6aOAUZCN7mG39+nTEQe8YcjHnqkgYXJpg6OVXC
	 ToUF2RYnEWAbnpb6ElWOWDlxsSfmpYdPu3xNjkiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 534/781] clk: qcom: regmap-divider: convert from divider_ro_round_rate() to divider_ro_determine_rate()
Date: Tue, 24 Feb 2026 17:20:43 -0800
Message-ID: <20260225012412.895429157@linuxfoundation.org>
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

[ Upstream commit 349f02c0f5d4ee147c582b89cadd553bd534028a ]

The divider_ro_round_rate() function is now deprecated, so let's migrate
to divider_ro_determine_rate() instead so that this deprecated API can
be removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: b6f90511c165 ("clk: qcom: regmap-divider: convert from round_rate() to determine_rate()")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260108-clk-divider-round-rate-v1-15-535a3ed73bf3@redhat.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-regmap-divider.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/clk-regmap-divider.c b/drivers/clk/qcom/clk-regmap-divider.c
index 4f5395f0ab6d0..af9c01dd78537 100644
--- a/drivers/clk/qcom/clk-regmap-divider.c
+++ b/drivers/clk/qcom/clk-regmap-divider.c
@@ -26,12 +26,8 @@ static int div_ro_determine_rate(struct clk_hw *hw,
 	val >>= divider->shift;
 	val &= BIT(divider->width) - 1;
 
-	req->rate = divider_ro_round_rate(hw, req->rate,
-					  &req->best_parent_rate, NULL,
-					  divider->width,
-					  CLK_DIVIDER_ROUND_CLOSEST, val);
-
-	return 0;
+	return divider_ro_determine_rate(hw, req, NULL, divider->width,
+					 CLK_DIVIDER_ROUND_CLOSEST, val);
 }
 
 static int div_determine_rate(struct clk_hw *hw, struct clk_rate_request *req)
-- 
2.51.0



