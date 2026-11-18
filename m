Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061581;
	b=AZujwsBot/qImmoQRcOUSPcEDzpi7Qz3xR0k/runxofgEwh9xV9xxll7S9Y1nvOXAhSf
	 k+DwKw1S6AhRHw1dAhHhwaClXqhlyYGJt8HMrbqf48i4GsxO+xl4IFd2clBxMKINM4E8t
	 g0yHN+llBRIwdAHkX1EqwfN01AcVjdqcRDSEaacf5Et/K5kqXHZ9oNfFGAS9sDvztnph1
	 af+swgm+RzsoVEZxo9qURk7iaOO7g0oHZX6/lgAiDmS/4RxXPJM3ODFE5tW/2QKaIiH6i
	 MQPTcDrRK/WgA7K1PrfvLBx1w3uEkBQC6Wg6EMhbqlz+F8oo1NCTGF0neNQXEpeKGPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9BcWKk4XWZTZs5iSRjzFHTNf2ROxBQJk6b8++Jx9KAE=;
	b=ghhorlOKQarNHB2FRd/4DGQVassRv2chMGZvWAcsZjwAKmPsfrBN49aVcgPhZXgRTxUY
	 vM+1HUaoXLIvyyi2/o13WH6ZXkVbesjkuZGRpJCtAtDYgZz8c66nFUFTx/G0zE4A/Syrd
	 nCkpLgbdZcDGRzL741O0DPmJGYzRacsX+7EKrUGHYZHL/25oPGF9/hj/T02D0cEdYaujr
	 e7BCno541mxUf9XGSjxjbyJVUjY2Ewr5vYYECgY4Lcoamcu5KAsHRLyZ1mNPdKIKUzp+b
	 4OUjLNdHZIfmxMN0d2NFt46viykLT00ZVKHy332Y/j76Q2771CT4gg+CL+0f73nyItw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E1/EyMCK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9CC60A2602;
	Thu, 19 Nov 2026 04:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1/EyMCK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE2D1F000C4;
	Thu, 19 Nov 2026 04:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061581;
	bh=9BcWKk4XWZTZs5iSRjzFHTNf2ROxBQJk6b8++Jx9KAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1/EyMCKqXFegNON28V18XLu8Q2F0bxkXWNwHW5yqiPXYzLvvkMejRMN8KNXMOHYc
	 Iz3RpbX6EhkEG7Fyoca19ZyABA1QZtzQcfeARB2jbvCfmMebN23Y0OzrYV5apzDP5Y
	 RFjPW4cH8UXuMAmmcxZGtJBCkVI67VRCDc9HlCwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1605/1848] clk: qcom: rcg2: Clear force enable after rate failure
Date: Wed, 18 Nov 2026 16:00:43 +0100
Message-ID: <20261118150026.750933696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit d4e8c6b9aef42d06cf5755543ad10097b2217990 ]

Shared RCG rate changes assert force-enable before programming the new
configuration. If programming fails, the function returns without
clearing force-enable, leaving the root running while CCF can release
temporary parent and resource references.

Attempt to clear force-enable on the configuration error path before
returning the original programming error. This restores the same cleanup
performed after a successful configuration while preserving the primary
failure for callers.

Fixes: 7ef6f11887bd ("clk: qcom: Configure the RCGs to a safe source as needed")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-3-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index fa86832b3f825..83669578d9866 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -860,8 +860,10 @@ clk_rcg2_shared_force_enable_clear(struct clk_hw *hw, const struct freq_tbl *f)
 		return ret;
 
 	ret = clk_rcg2_configure(rcg, f);
-	if (ret)
+	if (ret) {
+		clk_rcg2_clear_force_enable(hw);
 		return ret;
+	}
 
 	return clk_rcg2_clear_force_enable(hw);
 }
-- 
2.53.0



