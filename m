Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889A0168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3D2C433EF;
	Mon,  8 May 2023 10:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541016;
	bh=Jhab4T1IZVUorMxITNTHoSKD2GLUOVE9BUlEJWAVXhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqdrwldxpwYEybcClkF64am2uE995uERTIsPgs+0UIy3w7NNblqItRXX8yTCVMq0B
	 euMCACx0qse2tOk913QDmlnlWbtZxb+s/SRal9kWc6KRGeaI4S/wrGFXRzY4Bj1BsX
	 MVQ3rxHau/pmOf2w00JvFDEPnnJlxGZRlonGD+0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 583/611] clk: rockchip: rk3399: allow clk_cifout to force clk_cifout_src to reparent
Date: Mon,  8 May 2023 11:47:05 +0200
Message-Id: <20230508094440.869636877@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

commit 933bf364e152cd60902cf9585c2ba310d593e69f upstream.

clk_cifout is derived from clk_cifout_src through an integer divider
limited to 32. clk_cifout_src is a child of either cpll, gpll or npll
without any possibility of a divider of any sort. The default clock
parent is cpll.

Let's allow clk_cifout to ask its parent clk_cifout_src to reparent in
order to find the real closest possible rate for clk_cifout and not one
derived from cpll only.

Cc: stable@vger.kernel.org # 4.10+
Fixes: fd8bc829336a ("clk: rockchip: fix the rk3399 cifout clock")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20221117-rk3399-cifout-set-rate-parent-v1-0-432548d04081@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk-rk3399.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/rockchip/clk-rk3399.c
+++ b/drivers/clk/rockchip/clk-rk3399.c
@@ -1263,7 +1263,7 @@ static struct rockchip_clk_branch rk3399
 			RK3399_CLKSEL_CON(56), 6, 2, MFLAGS,
 			RK3399_CLKGATE_CON(10), 7, GFLAGS),
 
-	COMPOSITE_NOGATE(SCLK_CIF_OUT, "clk_cifout", mux_clk_cif_p, 0,
+	COMPOSITE_NOGATE(SCLK_CIF_OUT, "clk_cifout", mux_clk_cif_p, CLK_SET_RATE_PARENT,
 			 RK3399_CLKSEL_CON(56), 5, 1, MFLAGS, 0, 5, DFLAGS),
 
 	/* gic */


