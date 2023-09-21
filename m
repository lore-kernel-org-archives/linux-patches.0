Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A421C14
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 07:03:17 +0000 (UTC)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1qjDiQ-0005Le-9r; Thu, 21 Sep 2023 09:03:10 +0200
Message-ID: <6e3ad25c-1042-f786-6f0e-f71ae85aed6b@pengutronix.de>
Date: Thu, 21 Sep 2023 09:03:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 296/367] clk: imx: pll14xx: dynamically configure PLL
 for 393216000/361267200Hz
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Marco Felsch <m.felsch@pengutronix.de>,
 Abel Vesa <abel.vesa@linaro.org>, Sasha Levin <sashal@kernel.org>,
 Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20230920112858.471730572@linuxfoundation.org>
 <20230920112906.208711780@linuxfoundation.org>
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20230920112906.208711780@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: patches@lists.linux.dev

On 20.09.23 13:31, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.

[snip]

> Cc: stable@vger.kernel.org # v5.18+

Objection: This fix is only applicable starting with v5.18, as before
commit b09c68dc57c9 ("clk: imx: pll14xx: Support dynamic rates"), there
was no dynamic rate calculation that would substitute the hardcoded
parameters removed by my patch.

Cheers,
Ahmad

> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Link: https://lore.kernel.org/r/20230807084744.1184791-2-m.felsch@pengutronix.de
> Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/clk/imx/clk-pll14xx.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
> index e7bf6babc28b4..0dbe8c05af478 100644
> --- a/drivers/clk/imx/clk-pll14xx.c
> +++ b/drivers/clk/imx/clk-pll14xx.c
> @@ -57,8 +57,6 @@ static const struct imx_pll14xx_rate_table imx_pll1443x_tbl[] = {
>  	PLL_1443X_RATE(650000000U, 325, 3, 2, 0),
>  	PLL_1443X_RATE(594000000U, 198, 2, 2, 0),
>  	PLL_1443X_RATE(519750000U, 173, 2, 2, 16384),
> -	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
> -	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
>  };
>  
>  struct imx_pll14xx_clk imx_1443x_pll = {

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

