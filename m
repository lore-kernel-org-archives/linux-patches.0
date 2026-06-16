Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED2726B0A9;
	Tue, 16 Jun 2026 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623477; cv=none; b=fy2Qtkcu0nWOjda+G2cDeWaECDvhlZZRP8unTx88Ub0s/SCyNfDEc6aDRTBY02t7GuspQ6fHW2aRFKKuUXtnM/5JyhuhEvh9IQmw4tv1jG+5WdSgh+y5n8bbOIE1ttktkwZkUnY6v51utUegUweCOb9bvMoU/OQuAQ7JTATD52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623477; c=relaxed/simple;
	bh=dMNc/uFGSEtAo2wGzv91/XivMAzp57JRgYz2qJCdZGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imC8XrVEvCF76H6LSAEU4BH6+lLTFpbasjCG3HZrE8uK6gQ8ZJmJo5cf28oXiXWT6R40dBB4GveZegL8NkNYNURZRQrlgHlyF+ek8xqALrU//gjOm97RGEerMUOh1YjpaQuKIPjFAyRqe0KzOPw5OgrhGmaEgf984hzWC4BmEbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Az5h3esr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Az5h3esr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EBE1F000E9;
	Tue, 16 Jun 2026 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623476;
	bh=hLv6pYNOnAX2/BderrNE/z6hGlSYBboRKvU5uAwQyLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Az5h3esreUXn7MYFVdeq58QNZ1lNvNJ1xKR/w2IjOCqigi2r3QsS+af9skfAGBtk/
	 2nZdoPnlEr14kxCVDiagDKFPwphRvkk3E2aRx0EodLwtQcQKs0kntNky70vMMsk/+V
	 KW+Xn076ivOUNoHLk96uNgiSNPh2t6heSkVJjZPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 156/378] clk: samsung: gs101: Fix missing USI7_USI DIV clock in peric0_clk_regs
Date: Tue, 16 Jun 2026 20:26:27 +0530
Message-ID: <20260616145118.457591243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 78ee734b36284d82454e87a92094fdb926985b47 ]

In the peric0_clk_regs array, the divider register offset for USI6 was
accidentally listed twice, while the divider for USI7 was omitted.

Missing this DIV register causes the USI7 clock divider setting to be
lost and reset to its hardware default value during a suspend/resume
cycle.

Replace the duplicated USI6 DIV entry with the correct USI7 DIV
register.

Fixes: 893f133a040b ("clk: samsung: gs101: add support for cmu_peric0")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://patch.msgid.link/20260505171457.1960837-1-visitorckw@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-gs101.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-gs101.c b/drivers/clk/samsung/clk-gs101.c
index 44a8ecd332fddc..b439b7ae30ea39 100644
--- a/drivers/clk/samsung/clk-gs101.c
+++ b/drivers/clk/samsung/clk-gs101.c
@@ -3921,7 +3921,7 @@ static const unsigned long peric0_clk_regs[] __initconst = {
 	CLK_CON_DIV_DIV_CLK_PERIC0_USI4_USI,
 	CLK_CON_DIV_DIV_CLK_PERIC0_USI5_USI,
 	CLK_CON_DIV_DIV_CLK_PERIC0_USI6_USI,
-	CLK_CON_DIV_DIV_CLK_PERIC0_USI6_USI,
+	CLK_CON_DIV_DIV_CLK_PERIC0_USI7_USI,
 	CLK_CON_DIV_DIV_CLK_PERIC0_USI8_USI,
 	CLK_CON_BUF_CLKBUF_PERIC0_IP,
 	CLK_CON_GAT_CLK_BLK_PERIC0_UID_PERIC0_CMU_PERIC0_IPCLKPORT_PCLK,
-- 
2.53.0



