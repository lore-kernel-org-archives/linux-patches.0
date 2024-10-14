Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF81AB517;
	Mon, 14 Oct 2024 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917984; cv=none; b=ZRQqeoeTPSXEIr6LOghh0Y3MBcbO+8u7AXesPaca8jLphZ5E+g84692nXv9+UYZTUwA2sr9Bks5NWHTTO1ACYQN4Hj4q7i1HMn8epKk5C3s1yMfWeusLkQOF6QhXgInpfTcD2A7vms2SjKnJ9nzkMEVFdEmyvGKxHzAR1sTPEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917984; c=relaxed/simple;
	bh=M2mKc1UHDqT7BVT83Ii6UsEhuKLonDE0Yn5S0NgWXf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwsYnEtFsw046UOGQ/6f7Ei7dgGTO3hVEbIsYLBHKj+AUA9ZxMXoQCu7QzDBW9B9Bk6oVA+3z04QC0bWWZyLlT1bTXvknZCCkIV/rBM/+TlAAJN65Faf4tAqXexPAo1hfkORkP3Ny4rwdGTiZtNFa+IJm+pTEdA4ZuNJBRX60cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEnoE3CC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEnoE3CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F75EC4CEC3;
	Mon, 14 Oct 2024 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917984;
	bh=M2mKc1UHDqT7BVT83Ii6UsEhuKLonDE0Yn5S0NgWXf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEnoE3CCzzT66w6Jh/BRXgDNQhdUGp9/Rvs0086b6QwVJiNFfkeLCvRT5qLmexjCK
	 oHjZASDh4D/eIBxnV6Vn3G4gZYqZFAbkez1KrQV2ERVavU8jgP30zxYUwUnMFeod/v
	 fRe5SHqU+5kr0QUBfhSs1vfjFG1e129pJhOJC6Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/798] clk: imx: fracn-gppll: fix fractional part of PLL getting lost
Date: Mon, 14 Oct 2024 16:12:21 +0200
Message-ID: <20241014141225.280970829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengfei Li <pengfei.li_1@nxp.com>

[ Upstream commit 7622f888fca125ae46f695edf918798ebc0506c5 ]

Fractional part of PLL gets lost after re-enabling the PLL. the
MFN can NOT be automatically loaded when doing frac PLL enable/disable,
So when re-enable PLL, configure mfn explicitly.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240607133347.3291040-5-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index e2633ad94640f..421a78e295ee4 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -289,6 +289,10 @@ static int clk_fracn_gppll_prepare(struct clk_hw *hw)
 	if (val & POWERUP_MASK)
 		return 0;
 
+	if (pll->flags & CLK_FRACN_GPPLL_FRACN)
+		writel_relaxed(readl_relaxed(pll->base + PLL_NUMERATOR),
+			       pll->base + PLL_NUMERATOR);
+
 	val |= CLKMUX_BYPASS;
 	writel_relaxed(val, pll->base + PLL_CTRL);
 
-- 
2.43.0



