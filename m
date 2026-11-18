Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049646;
	b=nXxdIOMPoSdl7DpmHtF7qIZNvmWnrCpNaPA42RWnkNxpd8fXSbUmJzA/dmF/CDvOcUvR
	 DQT7eN4sL318B+c0oZryQhImGf5ZoRI3f+uHCezxC0pG0ZXo3b7mdtCXk+EmLKL4cnnly
	 tipmtAPEgUIpP9QfWx6fQlf8uRVt63P/ixXm6eHqx5CeYIrE4On3XVnN781u2NQX55ePV
	 eicKRsMBMz2WI9nAidj+TqBmL1wRCclrGustE96cKPF3UPb1rfpXlO1Yyj22Nc8soPftY
	 PSphLChi8jFRAezA6Dv6kVlrFuziWT/ZHwVQOjMru0un6jDypSrUdE+TRoW8UkSi5Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pCfZYRndLNA9JXvuoLlQM1rLjZlKMyPqHCKh7aVKFXs=;
	b=kMTRyrt19bvWXngO9JCFRU2Si/0pUhOCI94f2XcoQGtgUER2QWR7pzWL/+/rJRAaNoB3
	 UwA8DhsPrj/x8AYjVXdH9XgDxtSVQhDZvIze+IPs/ZCu/ndwKODwfGW4MYA5ZPb+047Aq
	 EVP4zkIZEe/w55QHVzJQQjFKJs6c8Gg4DEVG5tPEZqWz73eP+FFivy7dzJ/bgnnjQ5zQ4
	 SozCx4LGrNw6p/eb6SjOEQRZqx/CSmuRna5uMAfbX0uyrviB8sgU9sRdUIcAXqCwHlKl8
	 togOxmxVvzbDyYgxevhbkVnVaMoEXNX4XimS7yhuTJuB+mU66YglicrvjrfD6cFI5PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rc7/dxCI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A4606A31C;
	Thu, 19 Nov 2026 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc7/dxCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2165E1F000C4;
	Thu, 19 Nov 2026 00:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049646;
	bh=pCfZYRndLNA9JXvuoLlQM1rLjZlKMyPqHCKh7aVKFXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rc7/dxCIjb/qmr1ZT4gi7LftmdWf7LKeGrrhZP5tD1sCtloKfpyIfutZp0HM1rcvH
	 XqcxuhB+6CN/K8DdB+ROAqDvZQem0AgoMLxfZVBhgdFjwriDCwo/qsrNgzBceS/ty1
	 2KVTxoeHGF1L9/PvHKZbw+5oliOrw3+eTmYuHTRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2426/2857] clk: qcom: rcg2: Propagate force-enable status errors
Date: Wed, 18 Nov 2026 15:57:40 +0100
Message-ID: <20261118150328.904913662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9560d4254e4f9..b74f5e65265b1 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -982,7 +982,10 @@ static int clk_rcg2_set_force_enable(struct clk_hw *hw)
 
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



