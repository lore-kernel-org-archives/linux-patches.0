Received: from relay05.th.seeweb.it (relay05.th.seeweb.it [5.144.164.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1F433D9
	for <patches@lists.linux.dev>; Tue,  4 Oct 2022 17:42:12 +0000 (UTC)
Received: from [IPV6:2a00:f41:188c:1c74:b0eb:eb78:b659:16a2] (unknown [IPv6:2a00:f41:188c:1c74:b0eb:eb78:b659:16a2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by m-r2.th.seeweb.it (Postfix) with ESMTPSA id 62E923F479;
	Tue,  4 Oct 2022 19:42:10 +0200 (CEST)
Message-ID: <1d020f9b-c348-8875-b538-878db2838411@somainline.org>
Date: Tue, 4 Oct 2022 19:42:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.1
Subject: Re: [PATCH] clk: qcom: gcc-sm6375: Ensure unsigned long type
To: Stephen Boyd <sboyd@kernel.org>,
 Michael Turquette <mturquette@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev
References: <20221004172507.1599130-1-sboyd@kernel.org>
From: Konrad Dybcio <konrad.dybcio@somainline.org>
In-Reply-To: <20221004172507.1599130-1-sboyd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 04/10/2022 19:25, Stephen Boyd wrote:
> This PLL frequency needs a UL postfix to avoid compiler warnings on
> 32-bit architectures.
>
> Fixes: 184fdd873d83 ("clk: qcom: Add global clock controller driver for SM6375")
> Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Not sure if this SoC can even boot 32bit kernels, however I like it for

the sake of correctness.


Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>


Konrad

>   drivers/clk/qcom/gcc-sm6375.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/qcom/gcc-sm6375.c b/drivers/clk/qcom/gcc-sm6375.c
> index a3188c462a8b..89a1cc90b145 100644
> --- a/drivers/clk/qcom/gcc-sm6375.c
> +++ b/drivers/clk/qcom/gcc-sm6375.c
> @@ -54,7 +54,7 @@ static struct pll_vco lucid_vco[] = {
>   };
>   
>   static struct pll_vco zonda_vco[] = {
> -	{ 595200000, 3600000000, 0 },
> +	{ 595200000, 3600000000UL, 0 },
>   };
>   
>   static struct clk_alpha_pll gpll0 = {
>
> base-commit: c3db5128e80e1437cb08d0d41aeb7163004897e7
> prerequisite-patch-id: eac168caa320346ed78dc95c27117106fc8dbc7f
