Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CD8388890;
	Tue, 21 Jul 2026 19:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662534; cv=none; b=N4jZVvjzesX7eYGsjPsK2lOUtEOAGtG2T4yXWM1oqB+Fh6XjNW26Hq5ljjLk42M2JWMSMwdZwNECjQhNQ0oQR4fgmexIrZoOLdlaZpM3583c87V+AZrWxkFVGfeOvbeIIW8WS56hqnvVmUI3TUnaKnGRRL09NJ49zSp4HpmUrpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662534; c=relaxed/simple;
	bh=NHdzrBpYr4ZZx4tsEPeP7AUY/ckFiChPFvP0ONu87iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPVUbJYAPjhHSFPyEq39FnaujtnevYkjkCxtyyyClLnzo5PrKnGjG4dsLQeDBc0DvTkP/JQ85xqbMccCE9fuL91b/wftTal5fDxcA4YwscguTd+rc+0Su5z4AoBWpXzlMAJ9mFiO86ICsp7uQPvuVo7lU1J1qzUR/1NoU4Q3gaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6gRNO7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6gRNO7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351441F000E9;
	Tue, 21 Jul 2026 19:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662533;
	bh=6YrS39rBrWl2EwzuYrqEXRZaJtFayk6lPOiziTZVSIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6gRNO7RExSeew+9Px8eLXKBYMfJA1h6X/Ak7YtrBfkPRVuXH4ybPxN/dnJm+AU8+
	 YzpP8LY8p5gIhNTF9V0RJiZ0DG4oj67lIz3UyYZASwLtBRrJ/QvP7UQNNN9i0CIULl
	 lk+jdRSFGxsnApe6sh3O3PI+4FfIGWjZx66meEDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Varney <pbvarney@protonmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0481/1276] clk: qcom: a53: Corrected frequency multiplier for 1152MHz
Date: Tue, 21 Jul 2026 17:15:24 +0200
Message-ID: <20260721152456.866889213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Phillip Varney <pbvarney@protonmail.com>

[ Upstream commit bb56147ea9fce98ebde1d367335ba006cba61fbd ]

The 1152MHz frequency entry for the a53 currently selects a multiplier of 62, giving 1190MHz. This changes the mulitiplier to 60 giving the intended 1152MHz.

Signed-off-by: Phillip Varney <pbvarney@protonmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 0c6ab1b8f894 ("clk: qcom: Add A53 PLL support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260605005502.313928-1-pbvarney@protonmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/a53-pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/a53-pll.c b/drivers/clk/qcom/a53-pll.c
index f43d455ab4b84e..05581a10bea54f 100644
--- a/drivers/clk/qcom/a53-pll.c
+++ b/drivers/clk/qcom/a53-pll.c
@@ -20,7 +20,7 @@
 static const struct pll_freq_tbl a53pll_freq[] = {
 	{  998400000, 52, 0x0, 0x1, 0 },
 	{ 1094400000, 57, 0x0, 0x1, 0 },
-	{ 1152000000, 62, 0x0, 0x1, 0 },
+	{ 1152000000, 60, 0x0, 0x1, 0 },
 	{ 1209600000, 63, 0x0, 0x1, 0 },
 	{ 1248000000, 65, 0x0, 0x1, 0 },
 	{ 1363200000, 71, 0x0, 0x1, 0 },
-- 
2.53.0



