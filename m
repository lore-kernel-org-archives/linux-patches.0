Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9463D82
	for <patches@lists.linux.dev>; Tue, 12 Apr 2022 20:42:38 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id z6so23753026iot.0
        for <patches@lists.linux.dev>; Tue, 12 Apr 2022 13:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q+h04QniZy9JFOQoK0z9/PVBPK4EocYqj6rRLx+j0L0=;
        b=SMIgV8aLDiNeKnmDEIb0Inx08TYPHvQgnS+zOknfZE0gUH0ZFQ3H1dUPPJnEpjuINQ
         H3p7qQqcbUqSIHEuDAkLI20wHOcfbLenWoHzsQ8kY/MY4d4Lp6/rtZoWb7CWVyUX8/94
         MQjNGjiioQKb2uwTczKfJivg9TlEvPBDsSeQSjoos1HKfj3DhuCB3vTmHH6KkeSVXZSv
         L2EKgQc2Fr3VG+hSAIebU/2SRI+jbmUGzI3HA9sJf4J3nFA1zMP6faG5cVLOBXGarhpe
         QOuATxLwJDWBvdr/A/3E0ubrxZRnXzrlTHIUwg35KHPm4aW6cstT40J605DLoLT8hG9Q
         R36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q+h04QniZy9JFOQoK0z9/PVBPK4EocYqj6rRLx+j0L0=;
        b=l0cT+Tkq8B6ekdrD7ph75sobnCJCzC9E6d3fl5oXOj7ay8YNnm2DKA8suF1C8EBsUU
         i1iovgyb0pt5EnDHG/moa4pivoyJL0DN3RuFTuiuQoPl6/h9RVMcCv0LlwzuUcEUX2Gd
         opJcfrNEfeeyFhFchJb3Gu4M9y8ne2cHmOKDqP1qqh6EqxNoWvGFc7IZU/KDkVz9B0Qn
         tcZ/eQDvJLidZ8UAtK41E9zZgFUnFgcgTzzOXl6CRU70RKMge4aAvyyLtAtt3ipQKBDv
         gHe9+SqHzKkvhAI331ie9nOkZkneKSVCANwMPQBsqD9DtUTeDsuhzHXP+kVyzGLHsb9N
         avsQ==
X-Gm-Message-State: AOAM530WLYFZPc1lyiHc77GaP6zQERaAywvPdCFlU5LDIdZ/hjOrDM5f
	IGcKmOoJ3atWLz21HAvtz/CQaw==
X-Google-Smtp-Source: ABdhPJyHK84NQIavAf1tKxFEr0MsaqmU0Ke82mZQQrRn63U0+bN8oY1vPi9nSGHo0FSmPMVTmsqQfA==
X-Received: by 2002:a05:6638:d82:b0:323:9bb9:e62a with SMTP id l2-20020a0566380d8200b003239bb9e62amr18747267jaj.124.1649796157160;
        Tue, 12 Apr 2022 13:42:37 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id m7-20020a056e02158700b002c61541edd7sm22548667ilu.3.2022.04.12.13.42.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 13:42:36 -0700 (PDT)
Message-ID: <9af84dd7-75ed-3fa3-d1ea-f71a778bfaaf@linaro.org>
Date: Tue, 12 Apr 2022 15:42:35 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] clk: qcom: rpmh: Set wake/sleep state for BCM clks
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, patches@lists.linux.dev,
 Taniya Das <quic_tdas@quicinc.com>
References: <20220412194505.614002-1-swboyd@chromium.org>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <20220412194505.614002-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/22 2:45 PM, Stephen Boyd wrote:
> Set the wake and sleep state for BCM clks here, not just the active
> state, as the active only state is dropped when CPUs go to deep idle.
> This ensures the clk is always on when the driver thinks it is on.
> 
> This was found by inspection, and could very well be incorrect if the
> RPMh hardware copies over the active only state to the sleep and wake
> states.

I ran with this code and found no obvious errors.  And
it looks reasonable to me.

However someone (probably Taniya) needs to comment on
whether it's the right thing to do (based on Stephen's
second paragraph above), or if not, why not.  It might
warrant an additional comment also.

I can add a "Tested-by" but I'm going to wait for
some more input.

					-Alex

> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Fixes: 04053f4d23a4 ("clk: qcom: clk-rpmh: Add IPA clock support")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/clk/qcom/clk-rpmh.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
> index aed907982344..29da1ffd10cf 100644
> --- a/drivers/clk/qcom/clk-rpmh.c
> +++ b/drivers/clk/qcom/clk-rpmh.c
> @@ -260,6 +260,7 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
>   	struct tcs_cmd cmd = { 0 };
>   	u32 cmd_state;
>   	int ret = 0;
> +	enum rpmh_state state;
>   
>   	mutex_lock(&rpmh_clk_lock);
>   	if (enable) {
> @@ -274,15 +275,19 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
>   		cmd.addr = c->res_addr;
>   		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
>   
> -		ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
> -		if (ret) {
> -			dev_err(c->dev, "set active state of %s failed: (%d)\n",
> -				c->res_name, ret);
> -		} else {
> -			c->last_sent_aggr_state = cmd_state;
> +		for (state = RPMH_SLEEP_STATE; state <= RPMH_ACTIVE_ONLY_STATE; state++) {
> +			ret = clk_rpmh_send(c, state, &cmd, enable);
> +			if (ret) {
> +				dev_err(c->dev, "set %s state of %s failed: (%d)\n",
> +					!state ? "sleep" :
> +					state == RPMH_WAKE_ONLY_STATE	?
> +					"wake" : "active", c->res_name, ret);
> +				goto out;
> +			}
>   		}
> +		c->last_sent_aggr_state = cmd_state;
>   	}
> -
> +out:
>   	mutex_unlock(&rpmh_clk_lock);
>   
>   	return ret;
> 
> base-commit: 3123109284176b1532874591f7c81f3837bbdc17

