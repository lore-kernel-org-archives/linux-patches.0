Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031674;
	b=fqEpIYYc6Xeg+G7f/2xK7j+XiWbqvIEzPkceyEfoNa3m55TmFTzmBz3YOJhmGlC3awb3
	 jNDMVCN7SaDJ/yA8vs+CFWff1Jjhy0/tfNMw2f3wFHikDZJSxuU2hsceCM+F7pa0osdwG
	 2BU8CCQ888gFo9yp1Gq+Ue2WGP83Kst8AG4hGgcnEry4Zheg3xHhb0ToXfsWo9OzoDe92
	 0cAdT8lqeXchvrV+msSzZAySg0lbo7CAA6ytCUKKrphM5ouoPDwifkedN/ZvtHY3yeB6S
	 nsl2hs0h1m6yW2JJXsfeWY3brRCq7NUwlQote0nnfwKiZ4R1Su4NYX/0COxZiPa2nUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oj05cZczpZc1mvwgNDlMsHhQYNzwhVNN8HZpa+GahyQ=;
	b=20h6NX0nN7Pt7n8TxBIlsSwNC5tRMmNBOgrzmK6b6szW62wD1Nyn5QADD7B1nFWMoVnh
	 NlyvJ8Hoq2RIROeT8Yrte309Jt9eL1szCDEmqYwJEjTxKdWYdMzTpurX+wHZg3Xl2uqiy
	 UsElquTPsdqe85tH39OfC0OoLPuUYSYfrICUDNqAz8O0sGluMKLkWyfW0Nejx8nZ/uH2p
	 921Yv/WjOyU0VMOhdRR+1jo9G4cfFKm8cYYiUzZmkBuY5/6f3/dmtJRiC54rQFkzBgCOE
	 Gz8aw7oRg2oMChAPZH5lX+fttbuML466PibNwrUy/eJH1HJO4Ym71vaZCqowuuCSb7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFBumcAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A75560A2614;
	Wed, 18 Nov 2026 19:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFBumcAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41881F000C6;
	Wed, 18 Nov 2026 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031674;
	bh=Oj05cZczpZc1mvwgNDlMsHhQYNzwhVNN8HZpa+GahyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFBumcAWJdQOrsSrPhmldqtQ3CpTX2jVI1eLrfwQVqMmI2tEEO4IOu+3YrYisxiJ2
	 sMN6IDGs6VVYgVG5OOP3/SxGD0ZlMEXMlPZHf4J/XTgOZL5eWRacbB4y66pjw9F0qk
	 IUfbBUwfvCqhRLlFuK1QP+k/sqKzeAgZR5pkqK54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1140/1756] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 15:54:27 +0100
Message-ID: <20261118150055.431436702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 8c0f93e10fa9e34009817bd37bb75c1b5a691fa2 ]

clk_rcg2_is_enabled() returns either a hardware status or a negative
regmap error. The force-enable polling loop treats every nonzero return as
an enabled clock, so a failed status read is incorrectly reported as
success and clock reconfiguration can continue with unknown hardware
state.

Check for negative returns before testing the enabled status and propagate
the read error to the caller.

Fixes: 7ef6f11887bd ("clk: qcom: Configure the RCGs to a safe source as needed")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-2-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index c811ed72c26ca..8c6be8963c2b9 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1150,7 +1150,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
 	/* wait for RCG to turn ON */
 	for (count = 500; count > 0; count--) {
-		if (clk_rcg2_is_enabled(hw))
+		ret = clk_rcg2_is_enabled(hw);
+		if (ret < 0)
+			return ret;
+		if (ret)
 			return 0;
 
 		udelay(1);
-- 
2.53.0



