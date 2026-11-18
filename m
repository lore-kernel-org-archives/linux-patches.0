Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041538;
	b=TxUDg05au6nW19uQdsFZnzoAiO7qoMj8+avVVhUBHsltx+Gh3api+NtXINULQ6cOv5ts
	 oRch1Dio2ShV+3yFyX/DyEU4aYCGCJD+ktomvdn2ufhRMmrUbKPgYi13cL7o4QyqLH0Ep
	 06/1oEWkFP4pYrNF1dxP82+Db+DeY5nlssaCxLGzFdyHJ5+BqtMGhF55pgDuuTV2FItel
	 74EMY8FvMKJzXJEkiUCAJMfGERrRm9BVuua656RxvGT3eemg3Q0lybyIRZwhn1F5YXlPz
	 O+KXYY5F+SYv+tOQE88rl69cWaLP9YMsv2f0n5Mx/YlRkK5QIaoaetJKK38vXRdXrgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6s17SLhL52v57T+yKA7mWhtlXmGbnIt1923iRlZwa0=;
	b=OV6cYY7SNSD91/hPQClg6sPPcrIzCrf3cMUTGyEnc9Vw8/VwkGjd8pEKLfGp7mxtqEt0
	 gBeGULNESkhnRVuOFjEDU6+lWIvp6AQbHnrTtlv2ugYWj/2sIvAuQQ/T/JS07hkptUIIS
	 VTFL6rZACmoBVz5FL+7g6gKrLerHvG7k6n5JwTpQbLjvYSIbkuLYqmqT88wA2TB9ZQ7wJ
	 gUxiVeW8NaXir67s6id/tVmV1MelA3vbxZ0hdJACyA4JAb+156YZ15WieLIqXpxenFb2b
	 MYthgAgGBPg+28Id3yoFdi9xVlsj4C/lAYWrtnY+3mu+uZdre+5yI3FCUhkkRpYdA9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpH90Dwb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B317606A32F;
	Wed, 18 Nov 2026 22:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpH90Dwb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B171F000C5;
	Wed, 18 Nov 2026 22:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041538;
	bh=x6s17SLhL52v57T+yKA7mWhtlXmGbnIt1923iRlZwa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpH90DwbyMKwfCqXJRpG1Mw4iwRZD6pPZPAGqFTwh+7LZUAPtJKqGqRTkxoGFiixt
	 /KoH5BjMoW2MkqL1gRKIgfjqgEflwPdVjCqypIgWXV1Dl9KzO4gX+Lyis145WDRrsn
	 fpmkQ86k2RfUYGKboKR95IdNW1g61007PaRDT+GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2808/3318] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 15:57:10 +0100
Message-ID: <20261118150444.908176067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 55c2c1e957c89..2b36df641d6b8 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -984,7 +984,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
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



