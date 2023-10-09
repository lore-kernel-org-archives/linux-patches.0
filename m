Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9524A1A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2nr3X4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035A0C433C7;
	Mon,  9 Oct 2023 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857865;
	bh=DEbUJJerDezDjOBdZH0mMfoI9eiOd4jV3m6u/Pl0ukU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2nr3X4W0dSHjyW17sLuFxloa1U2SUJslwwUXOyOVehw3vKBhto/cBec+5d3KTZ5X
	 oeM2iR05dH4oQADCDfVS0Yp63FoNTTp/EiIaf4CgQJNTxEgLPY/fMZOextsWZvKX04
	 +jSRkza+mZMJHDFi49GtacUdnuCFyJbj9pCYI7dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>
Subject: [PATCH 5.15 18/75] Revert "clk: imx: pll14xx: dynamically configure PLL for 393216000/361267200Hz"
Date: Mon,  9 Oct 2023 15:01:40 +0200
Message-ID: <20231009130111.872245192@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a8474506c9127048c058fdfe466ccbadf7524048 which is
commit 72d00e560d10665e6139c9431956a87ded6e9880 upstream.

Marek writes:
	The commit message states 'Cc: stable@vger.kernel.org # v5.18+'
	and the commit should only be applied to Linux 5.18.y and newer,
	on anything older it breaks PLL configuration due to missing
	prerequisite patches.

Reported-by: Marek Vasut <marex@denx.de>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/4e5fa5b2-66b8-8f0b-ccb9-c2b774054e4e@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/imx/clk-pll14xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -60,6 +60,8 @@ static const struct imx_pll14xx_rate_tab
 	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
 	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
 	PLL_1443X_RATE(519750000U, 173, 2, 2, 16384),
+	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
+	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
 };
 
 struct imx_pll14xx_clk imx_1443x_pll = {


