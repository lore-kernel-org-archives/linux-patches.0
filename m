Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A782339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0mS+Opr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4E9C433C8;
	Mon,  9 Oct 2023 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859035;
	bh=gu5b5mkkGSlls58gAllmLVUAaxbd0Sq2s+D3S9a+1tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0mS+OpruNjGs8ROECP3BivvvZaENsA0ekjrjbAAV587GXJDPeSfKQKMkSFtAt4q3
	 kTibG2E+5RcAjG7oFG6VroU66sTCwL8wrkc2ZU3Y4dMreKDuAVq2fYXkZHl/Cb8zn2
	 Wf1s7/+uNlw+x/N4VQcTGfFv6lUf+lJFcBnzRrDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>
Subject: [PATCH 5.10 177/226] Revert "clk: imx: pll14xx: dynamically configure PLL for 393216000/361267200Hz"
Date: Mon,  9 Oct 2023 15:02:18 +0200
Message-ID: <20231009130131.263594775@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 972acd701b1982da9cdbeb892bf17eeef2094508 which is
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


