Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CE2596
	for <patches@lists.linux.dev>; Wed,  4 May 2022 16:53:58 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-ed9ac77cbbso1780267fac.1
        for <patches@lists.linux.dev>; Wed, 04 May 2022 09:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2klMetXGa1eUlKZSFzvlKnCFZIMh5g+h156STL277cU=;
        b=xwSoPZhK4O9KfF0E9rB8njkdJRtTwkZ4NR9LCTG0wMvOKwKndxeRPvixpmBIcXqHdY
         qnYVcoFOds+xnLyeSRi6JCoJvovK5Ont8ITuL89eG48BDLXzDfbI7+wpAhSS4VqLEciS
         /ExulmzKoBHM1in91h9JtnFioxJJ+rQ4dOTGBUTyPiyzOCm25ErpRvSq4X/7e5xg6frM
         hsHarDuHST1RgfinipAKy/JnsW5bKxiotUgLWcM9FS5fR3VZ2LAqpOXfbkI13sUKo+bm
         O6AUeLw1hRpkjAOw9PYtndBN0mDjRpFPXAzA4IvNiK6aP9CHCbcgb7OCexn1diIWIYGI
         x2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2klMetXGa1eUlKZSFzvlKnCFZIMh5g+h156STL277cU=;
        b=RIbTyHBxWXmcrQ6piuvRb2iAKvUX+rqAQkJEQlg4L8Pzo4PbSjt9eXuZe2Yrw3EaRf
         77OiYNVllVk4dnncigoiJF9Exxse6WpcSToMrxhT9FePh1yPfmicvg0nGb5k9tNk5vo2
         cSV6b9/xX2S03ogvyjSKmu4VpWhbtRDKpW67nkRpEdayGbQEWx7cALSmnjrcFIadaGBX
         zf+6mwzMFOkzRHpCtlY5DSp/W1PTbZuyeWLzIW9JxvEPJxjVTRPiDHc1efVL8wwx8ftl
         wQxqnzic2X1ZJ/ZlvwHyI0JlyVH6GxX+qrlZSyWLHWbnWcPJH1v9BkZzAMdVQB8SF2gP
         cYOA==
X-Gm-Message-State: AOAM530/H+UrNUTyLf+6gXjS2b/68Pp9CXsDTpi/fEoKLIOpLlgOJxaW
	kQkweMFL9XiY+k8wy2bF5wLN4w==
X-Google-Smtp-Source: ABdhPJyocyOzuasLctGeqNeBJMplgmBUpdNyW29oi9jqBr4TwlqaFgI/BnBfrAb7QdBgNToE3dbmIQ==
X-Received: by 2002:a05:6870:b6aa:b0:ed:a7de:cc26 with SMTP id cy42-20020a056870b6aa00b000eda7decc26mr169045oab.259.1651683237792;
        Wed, 04 May 2022 09:53:57 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id r42-20020a056808212a00b00325cda1ff85sm4484697oiw.4.2022.05.04.09.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 09:53:57 -0700 (PDT)
Date: Wed, 4 May 2022 11:53:54 -0500
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev, Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: Re: [PATCH] clk: qcom: rpmh: Set wake/sleep state for BCM clks
Message-ID: <YnKvoh+h07at8b65@builder.lan>
References: <20220412194505.614002-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412194505.614002-1-swboyd@chromium.org>

On Tue 12 Apr 14:45 CDT 2022, Stephen Boyd wrote:

> Set the wake and sleep state for BCM clks here, not just the active
> state, as the active only state is dropped when CPUs go to deep idle.
> This ensures the clk is always on when the driver thinks it is on.
> 
> This was found by inspection, and could very well be incorrect if the
> RPMh hardware copies over the active only state to the sleep and wake
> states.
> 

Taking another look at this patch and now it makes perfect sense to me.
Sorry for not grasping the problem earlier.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>


Will you take this in fixes, or do you want me to pick it for 5.19?

> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Fixes: 04053f4d23a4 ("clk: qcom: clk-rpmh: Add IPA clock support")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/clk/qcom/clk-rpmh.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
> index aed907982344..29da1ffd10cf 100644
> --- a/drivers/clk/qcom/clk-rpmh.c
> +++ b/drivers/clk/qcom/clk-rpmh.c
> @@ -260,6 +260,7 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
>  	struct tcs_cmd cmd = { 0 };
>  	u32 cmd_state;
>  	int ret = 0;
> +	enum rpmh_state state;
>  
>  	mutex_lock(&rpmh_clk_lock);
>  	if (enable) {
> @@ -274,15 +275,19 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
>  		cmd.addr = c->res_addr;
>  		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
>  
> -		ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
> -		if (ret) {
> -			dev_err(c->dev, "set active state of %s failed: (%d)\n",
> -				c->res_name, ret);
> -		} else {
> -			c->last_sent_aggr_state = cmd_state;
> +		for (state = RPMH_SLEEP_STATE; state <= RPMH_ACTIVE_ONLY_STATE; state++) {
> +			ret = clk_rpmh_send(c, state, &cmd, enable);

Nit. We only need to pass the positive enable on the last iteration here...

Regards,
Bjorn

> +			if (ret) {
> +				dev_err(c->dev, "set %s state of %s failed: (%d)\n",
> +					!state ? "sleep" :
> +					state == RPMH_WAKE_ONLY_STATE	?
> +					"wake" : "active", c->res_name, ret);
> +				goto out;
> +			}
>  		}
> +		c->last_sent_aggr_state = cmd_state;
>  	}
> -
> +out:
>  	mutex_unlock(&rpmh_clk_lock);
>  
>  	return ret;
> 
> base-commit: 3123109284176b1532874591f7c81f3837bbdc17
> -- 
> https://chromeos.dev
> 
