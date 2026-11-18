Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056144;
	b=ChOHfPq4EtxypGHbsshQUZ859VSzWxMlIZQWMRP9oGqmZp9Ezu9jLg5SZPxYrp0Lan3V
	 Myip0winfi0ozPMD6nm74QkPLm3C40KpWCkq2562+a55tCR6CNDqonbvjPWC3VlNW+mbx
	 EZekMB8+b7kuCofmj3GMJTzUo6Jvr6RUzjSyYmkYD45zq/4kiYqnufQIUzY5tRmJRQAjX
	 ZYn84QNMvQPPu9bpibJhbXgyUC4zLAkV9dYKVIqmWncKAxJ9XmCO3Ru06qGRGNx5kPxdq
	 1g479we4P29RijGYZ5H9j1Nfl1t379qiYiRBhDGuqUPUtj6d4mrVisRtNxVELhuxVgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ex4EQOViOv2tYScwzmdb/ktUIjQ1Bs/rNprOw/5tn8g=;
	b=pebVQnLZPYWd68w4MOwdWFwr3kYlnjHnJ8BQJwbL/oo5aBbIBmoel/Zz1jXwDJ9/qtcL
	 fsx7R57xZOeZwP4wS8RSpNVsFN84MmxqrktagzBSJ1fer8iC0nBU7J0184/jwFeNHMOB4
	 PIEIwVWjjcyApWpwnZtEFMbRySR86Bqsz/KxSaauABN9bpMNuDWXcFzBWdojjec5I10Cv
	 NooQL7FfE+PsA/4esr4UQJOvKA+zoFju/ttL11mu6uQtb8NLj/kF7wTnTMoqIP1viYYJu
	 lYcrn4ZOvL3+ttzu5S3ui03uddmQdC76TW3H8n+tr0jo9YcOyven/RaCNt1VXUvvntg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HALbl9jp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBFB606A320;
	Thu, 19 Nov 2026 02:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HALbl9jp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECB41F000C4;
	Thu, 19 Nov 2026 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056144;
	bh=Ex4EQOViOv2tYScwzmdb/ktUIjQ1Bs/rNprOw/5tn8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HALbl9jpFjJReyMuhbZBA749DyTArQSF444fGBTmHZeGPIGMegVxpnqDl/T55ukKy
	 3H3oWJi57A+cLgfHUQvC0Lu123NaY7cBIk4Sj14OmGmR2U/9aswRYUwhr9/QEDFAAY
	 ruNbaq890h3GW3C2BJrSd55ybX+38aDH03V/XFDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1883/2214] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 15:59:19 +0100
Message-ID: <20261118150126.567071968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 05aa831ac7a44..d72e6424ea1b1 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -933,7 +933,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
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



