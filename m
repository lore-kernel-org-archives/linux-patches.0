Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FD51741E0
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 12:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724847751; cv=none; b=XNEEEf0NOsMdMHovOHpS8wYes2NqN0IwLUOssgKRh2MgfPIl6VQa1x0rBsxCcLeMvPwtW19GXqoD1SREXr8tOVlLdj/yOJBRC/tABx9pYFg+h8hI9kq5ER7ONvBubjNRlUufXsE99q5IGTXJhGNJTDQQE98wQao2vmc900VkoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724847751; c=relaxed/simple;
	bh=yGyZNEzp7fsulnrAoio0GZKMrQL6GJTqwmFm5pZgM5I=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=nzl5Mj9CMWOCGFw/HxoJxy46FxoTp2VCuxPa4pdnP/BzREkeUeUFh7t5GptP+yV6jEWq672Vfc+LpvHF8R6W3dzuq2S0XBCAZYKdA00cLsmgJZglTSuq/7Ci+OCtKejsIgnUdjwoJ/G7Ky+17MEiqhvMlCdZMR1McOc0dvt/JCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YTt1asru; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YTt1asru"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-428119da952so58511835e9.0
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 05:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724847747; x=1725452547; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ccK4+9RMhluOHsKR0Prfxb9h2mM63tHvTzyxTY1zL2w=;
        b=YTt1asruxp+/fjKK+jjAHjZOEdhyi2bZ+juv5FPQNRZITmQKkjB6Q6KwWTyR06ut4s
         Zj8kbbnrdE/VQD/vacglFzfUbupCVPkI6pilOnh+mPmfkO099AecKpS9yy+dLlq1hD+t
         SE6BblUk+ZShoN8jSYteilENwGHZFivxc7bFASoKu1oVBjgWiW7p8hZsCK1h2GL1wMho
         LF8EIbYom8KCDR+oQV7Gyo15DcWOC6l05GaxUVBMwX8LxHOTnYyoZ/F/JKr9aKWip7RM
         LgPwFvQXWbSGuN5WoousJDRxC/XY0V9Bth8VeMqGSu++3Zj5Dv+G1ya8uC8A4YeNmhZo
         x9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724847747; x=1725452547;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ccK4+9RMhluOHsKR0Prfxb9h2mM63tHvTzyxTY1zL2w=;
        b=xCUTvqtTEzklDzNaK9ufvi/PqKKpb9I1GpfDeoatkam6ng0KtozT1E3OvddFsASl0h
         D6fBd2g9dCoGqpm2h/xrV2jGseB2H97hqcMonpFLJX/HoFZzjYtgi/ltqzKH3p0e6ISE
         chYGS2Go2wZbWI8jdwI/4agZyE3UBybA6RlenlnBh2WMRqyTzSv0zCO4Sl1Qrjg1YO9d
         Gg+tb4nVahhaCzofhnNYcNwsYXGoczcPZKj99Q01wL0c3QvQEb/AoOex/KcdCU0ADgU2
         KW1oBaP48VzkeYRi4TZFYM6rsfZXZ1YWpQ/dYrXJLgLrh8Lmev1RZ6nJkHZg4auVagCl
         KCHg==
X-Forwarded-Encrypted: i=1; AJvYcCV2BT2vht+oSw8lC2c08b1z6DYr2fmuIGfTMo1WZHI2mmWs07+LHvH+QxUqFHCfBOBTeZQLrj+L@lists.linux.dev
X-Gm-Message-State: AOJu0YwxVMbtTtekGAUU7hOtCEkCt51MAF6jOklUbwT6cILGXDOteSHz
	pB3eJz87+UDjOGZ5bjz9bLF9xn5PtO+0TrJCEHDirWZpVREJD3K+4z3rTFyCyxI=
X-Google-Smtp-Source: AGHT+IGDJh9GdbQZDoGQE+xPYEKu2xk7RQdRY/5zNjmjEsUgJSCnMxEVcAKB1Z6iDdHBglSoeq8OKA==
X-Received: by 2002:a05:600c:1d17:b0:426:64a2:5375 with SMTP id 5b1f17b1804b1-42acc8d5247mr118993045e9.1.1724847746706;
        Wed, 28 Aug 2024 05:22:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:765d:64ff:5f38:550? ([2a01:e0a:982:cbb0:765d:64ff:5f38:550])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730821a9fcsm15295309f8f.94.2024.08.28.05.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 05:22:26 -0700 (PDT)
Message-ID: <8597375d-6c15-4d20-96fd-2598805c09d5@linaro.org>
Date: Wed, 28 Aug 2024 14:22:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 1/2] clk: qcom: dispcc-sc7180: Only park display clks
 at init
To: Stephen Boyd <swboyd@chromium.org>, Konrad Dybcio
 <konradybcio@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 patches@lists.linux.dev, linux-clk@vger.kernel.org,
 Taniya Das <quic_tdas@quicinc.com>, Amit Pundir <amit.pundir@linaro.org>
References: <20240827231237.1014813-1-swboyd@chromium.org>
 <20240827231237.1014813-2-swboyd@chromium.org>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <20240827231237.1014813-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/08/2024 01:12, Stephen Boyd wrote:
> Amit Pundir reports that audio and USB-C host mode stops working on
> sm8550 if the gcc_usb30_prim_master_clk_src clk is registered and
> clk_rcg2_shared_init() parks it on XO.

Why does it change the dispcc-sc7180 in this case ?

Neil

> 
> Partially revert commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
> registration") by skipping the parking bit, and make that the default
> for shared RCGs, but keep the part where we cache the config register as
> that's still necessary to figure out the true parent of the clk at
> registration time. Move the logic from clk_rcg2_shared_init() to another
> clk_ops structure for use by the display clks on sc7180 to minimize the
> impact of that commit on other qcom SoCs that can't handle the parking
> part.
> 
> Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/clk/qcom/clk-rcg.h       |  1 +
>   drivers/clk/qcom/clk-rcg2.c      | 36 +++++++++++++++++++++++++++++---
>   drivers/clk/qcom/dispcc-sc7180.c |  8 +++----
>   3 files changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
> index d7414361e432..5f479a29d969 100644
> --- a/drivers/clk/qcom/clk-rcg.h
> +++ b/drivers/clk/qcom/clk-rcg.h
> @@ -198,6 +198,7 @@ extern const struct clk_ops clk_byte2_ops;
>   extern const struct clk_ops clk_pixel_ops;
>   extern const struct clk_ops clk_gfx3d_ops;
>   extern const struct clk_ops clk_rcg2_shared_ops;
> +extern const struct clk_ops clk_rcg2_shared_init_park_ops;
>   extern const struct clk_ops clk_dp_ops;
>   
>   struct clk_rcg_dfs_data {
> diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
> index 30b19bd39d08..5f0b729d7115 100644
> --- a/drivers/clk/qcom/clk-rcg2.c
> +++ b/drivers/clk/qcom/clk-rcg2.c
> @@ -1305,6 +1305,31 @@ clk_rcg2_shared_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
>   }
>   
>   static int clk_rcg2_shared_init(struct clk_hw *hw)
> +{
> +	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
> +
> +	/*
> +	 * Cache the cfg so that the parent is properly mapped at registration.
> +	 */
> +	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &rcg->parked_cfg);
> +
> +	return 0;
> +}
> +
> +const struct clk_ops clk_rcg2_shared_ops = {
> +	.init = clk_rcg2_shared_init,
> +	.enable = clk_rcg2_shared_enable,
> +	.disable = clk_rcg2_shared_disable,
> +	.get_parent = clk_rcg2_shared_get_parent,
> +	.set_parent = clk_rcg2_shared_set_parent,
> +	.recalc_rate = clk_rcg2_shared_recalc_rate,
> +	.determine_rate = clk_rcg2_determine_rate,
> +	.set_rate = clk_rcg2_shared_set_rate,
> +	.set_rate_and_parent = clk_rcg2_shared_set_rate_and_parent,
> +};
> +EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
> +
> +static int clk_rcg2_shared_init_park(struct clk_hw *hw)
>   {
>   	/*
>   	 * This does a few things:
> @@ -1335,8 +1360,13 @@ static int clk_rcg2_shared_init(struct clk_hw *hw)
>   	return 0;
>   }
>   
> -const struct clk_ops clk_rcg2_shared_ops = {
> -	.init = clk_rcg2_shared_init,
> +/*
> + * Like clk_rcg2_shared_ops but also park the clk at init to avoid the parent
> + * from being shutdown, getting the clk stuck when it is turned on
> + * automatically by the GDSC.
> + */
> +const struct clk_ops clk_rcg2_shared_init_park_ops = {
> +	.init = clk_rcg2_shared_init_park,
>   	.enable = clk_rcg2_shared_enable,
>   	.disable = clk_rcg2_shared_disable,
>   	.get_parent = clk_rcg2_shared_get_parent,
> @@ -1346,7 +1376,7 @@ const struct clk_ops clk_rcg2_shared_ops = {
>   	.set_rate = clk_rcg2_shared_set_rate,
>   	.set_rate_and_parent = clk_rcg2_shared_set_rate_and_parent,
>   };
> -EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
> +EXPORT_SYMBOL_GPL(clk_rcg2_shared_init_park_ops);
>   
>   /* Common APIs to be used for DFS based RCGR */
>   static void clk_rcg2_dfs_populate_freq(struct clk_hw *hw, unsigned int l,
> diff --git a/drivers/clk/qcom/dispcc-sc7180.c b/drivers/clk/qcom/dispcc-sc7180.c
> index 4710247be530..068af819f23e 100644
> --- a/drivers/clk/qcom/dispcc-sc7180.c
> +++ b/drivers/clk/qcom/dispcc-sc7180.c
> @@ -154,7 +154,7 @@ static struct clk_rcg2 disp_cc_mdss_ahb_clk_src = {
>   		.parent_data = disp_cc_parent_data_4,
>   		.num_parents = ARRAY_SIZE(disp_cc_parent_data_4),
>   		.flags = CLK_SET_RATE_PARENT,
> -		.ops = &clk_rcg2_shared_ops,
> +		.ops = &clk_rcg2_shared_init_park_ops,
>   	},
>   };
>   
> @@ -263,7 +263,7 @@ static struct clk_rcg2 disp_cc_mdss_mdp_clk_src = {
>   		.name = "disp_cc_mdss_mdp_clk_src",
>   		.parent_data = disp_cc_parent_data_3,
>   		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
> -		.ops = &clk_rcg2_shared_ops,
> +		.ops = &clk_rcg2_shared_init_park_ops,
>   	},
>   };
>   
> @@ -291,7 +291,7 @@ static struct clk_rcg2 disp_cc_mdss_rot_clk_src = {
>   		.name = "disp_cc_mdss_rot_clk_src",
>   		.parent_data = disp_cc_parent_data_3,
>   		.num_parents = ARRAY_SIZE(disp_cc_parent_data_3),
> -		.ops = &clk_rcg2_shared_ops,
> +		.ops = &clk_rcg2_shared_init_park_ops,
>   	},
>   };
>   
> @@ -305,7 +305,7 @@ static struct clk_rcg2 disp_cc_mdss_vsync_clk_src = {
>   		.name = "disp_cc_mdss_vsync_clk_src",
>   		.parent_data = disp_cc_parent_data_0,
>   		.num_parents = ARRAY_SIZE(disp_cc_parent_data_0),
> -		.ops = &clk_rcg2_shared_ops,
> +		.ops = &clk_rcg2_shared_init_park_ops,
>   	},
>   };
>   

