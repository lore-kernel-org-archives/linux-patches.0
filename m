Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837E71CDFBC;
	Wed,  2 Oct 2024 13:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876156; cv=none; b=e1bdsIMm0Z8OwxisRpjeaQ3K4Ticngb35p/ysFzMMc6NfP6HJxwRHffSjgrXXXDJsO0wM/4H85kjliYTk6UvS9Fgayhj9GGd/C3dsYa9P2G/w5Y960cLKYFl+DThR9E+qL5mKM9OpE9E7kvEUt1JpoSwBFRM9PbNMmWmluPsA98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876156; c=relaxed/simple;
	bh=17XUkSK2MDk+p57i7MaRLEbziwGywU5ESvwIdSf5fkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tru67Lh49pWaMqSVt8QtFyncBpH3ln2SOvE//Gz+Vxe2qDPROjC4p7PmEA7PMkQkIIllKSiz4olFjPwXMdePUOE/sY2uW8tx4jpWfOb81vpbW+OtoIpOSeUIwPdSIq3i2ljH5fCycyK/ZQu2/WB4HyhvNTowUMeNes3MXDCziBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTBFF3IT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTBFF3IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098E2C4CEC5;
	Wed,  2 Oct 2024 13:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876156;
	bh=17XUkSK2MDk+p57i7MaRLEbziwGywU5ESvwIdSf5fkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTBFF3ITxVjfLkQ49kJqNSpJ3tZdlvlcMBEtaCYyS3cZ01sy3BgTJtXMPXhfP73rq
	 6D0u7Vu46lgBdobeoB2zRDbBw4au2JadAeqkTN1xtt8SkUjcLUlqg9fxHl3fL/p7q8
	 4Tg6ulVCzAxPApTu6sS23+6CCE9iQAz2m78NIAAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 347/695] clk: imx: fracn-gppll: fix fractional part of PLL getting lost
Date: Wed,  2 Oct 2024 14:55:45 +0200
Message-ID: <20241002125836.300189366@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 44462ab50e513..1becba2b62d0b 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -291,6 +291,10 @@ static int clk_fracn_gppll_prepare(struct clk_hw *hw)
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



