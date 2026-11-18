Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019990;
	b=e1k0nH9Lhwe72qbxxTiTjK4k5HQ0KYNkLfWi3Xu5423vJnhFJ6ToMZCtZKklqTlASydu
	 YpZoPnVjboFpucl7CEY2mP4U0y8hSnWuHTghi0ElN6cmBM120SaVUrzdbkze9H4JnLI3F
	 FgYkTOobEgIzSgrysX6eFLfD1DOUTJ7vGP6d12AHy4bMJt7Aw/xBOBCz9RCN9qz8xmjz9
	 NwE2VoBr7DMKHuQazeoLkHc7ZY2v/oDNUKohCvdJZMpjzC/ZPuDMojwxJlJtlatwGcXX3
	 G5qp3LHdWXJtPstkaD5EWEN5TT8kr2WMutccuYxj1lnV+QCZODNRS/uGqgMq2cufMLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3E0rRximManpqbyT9NAe7NVmlpfgnyRhlIC6ObysKE=;
	b=1JQLg2ZWBKSfl3F20/KV/Zg4TReTk/RZD2HIb/5Dswq2xUKs6tZi54SlYa2dU7DF6lr4
	 4F2OypjG+h9XiY3+1cfRRlQy0isZPsogobzBvV7gjmAQzXiYJXKShK53341T/frgoyqOa
	 ykUBUm29SvVlqUREfRXrtGav/58muW6ENuTvamWsbrlm4McQ4aE/2WHjIw5LdM0S+DICO
	 BSaDRB4Zfv975RVNrPY5moMoBjm+hO0hl/ve8GKV4hFSoydHERKSjvrndF6Yrga8ZnUZ4
	 yLhRl+uwfZzFa1CUVPbBfXEOoO8RQQdg5zYr/OKkXtJAgLcKoQVXTq6ixTA3oXfLUkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZ1ghNAn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C10606A332;
	Wed, 18 Nov 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BZ1ghNAn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6B61F000D0;
	Wed, 18 Nov 2026 16:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019990;
	bh=Y3E0rRximManpqbyT9NAe7NVmlpfgnyRhlIC6ObysKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZ1ghNAnOJIbkTFv99E+IJ+2L/7DBt1wIW0NyRdX7bq74mpQQFTdZq8OdWaL2Wnor
	 klrG6vw03aPgsbs15ETAxfDinnoksJAJOpL/r8Dcey7rP67plmhoIMhdfi5VOSgVp0
	 DoJCBJTnRgpbaPSYcXUctcYVtnMiVdDYscZRQPlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1751/2651] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 15:49:51 +0100
Message-ID: <20261118150350.544437169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index adb03c3aa0dc0..54d122e2e0d60 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1332,7 +1332,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
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



