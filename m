Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356403C03
	for <patches@lists.linux.dev>; Sat, 25 Jun 2022 20:00:40 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-fe023ab520so8126769fac.10
        for <patches@lists.linux.dev>; Sat, 25 Jun 2022 13:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GoHTL5pc7929tKgNPXg2nW2kzENqcme0/+lvG0VCiB8=;
        b=P9/d2vqi0S4nDX0/Q7iwQJQXtcSWzOF+75qBFEQXnxYG012L7l7Y6rZtrqpnV8sn/H
         g6rkxGsOBdw13y9r9b2vdilnR5zuwrJOXtyxuvDPJzKEf0Lbq+ZBVoAyKOKdkC/cB4XA
         62sQOQ5g6gDJMRDKtabVKkCKdTOvHdHeGBsPV9KIPRaS27ikp7AkPtt0Iup0UrRyTAx4
         Sm+rnL8iYjCrhJmFosCSClpgwoO51DrA9dEU3vmnEzFAZpUGk2Usoy/yg9y1Pe0Sf3qH
         wpM6zJpivs+tmMMYDJ1iK2sapz3k1ejoqNaNhp9r3IcEcRy66Hq93qfnhpX+EDBbrlS3
         XqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GoHTL5pc7929tKgNPXg2nW2kzENqcme0/+lvG0VCiB8=;
        b=fmVAhj3sRUbbs6tGv0Pdx5scaV1Vptc8oPRU9iSl0dAWAPlTFg8haHGvLtsBTz8GJK
         K0lv4VJ2Zq6lKx+WXZoY0kabm9PObnnQbee4/fbwCLmV3z4lXfpYkpwsCInQsvyGltPQ
         QeaIFQ1/uTeH9JOkf74Z2KvfXlGkIR6BGalX4f+ugmz/jJcV9Q+cFGrW1DVzM9v85QLO
         6d8BMuz4C0q33ZvR4aePwVRquzs6vR7GgfxQ0AlKYcHDJltNAa0yaJ+t0NN0NOAD2DqP
         0wnoSc57pSmz+9ihledvwCzyNyBngIVva/ayKXxQh5VSenJeeVwwRIRUfcnIV+/jftwD
         MssA==
X-Gm-Message-State: AJIora8rUXckQ+SpT/1cp8E1nJKmSRH7G7TuLzzzERQpjDMXzBMq5jEu
	pnr45z5ZL13PxFIwbaz4NEglZw==
X-Google-Smtp-Source: AGRyM1uS2g0J6WOPaAL2iqi0XdzNdGYJ9SATCQGmKDYOVVcrz9/DIH+EaNp3mGkr0Upk6fjqJEr4MQ==
X-Received: by 2002:a05:6870:3920:b0:101:d628:b053 with SMTP id b32-20020a056870392000b00101d628b053mr6084774oap.111.1656187239166;
        Sat, 25 Jun 2022 13:00:39 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id y21-20020a056870419500b000f3321caa73sm4160632oac.16.2022.06.25.13.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 13:00:38 -0700 (PDT)
Date: Sat, 25 Jun 2022 15:00:36 -0500
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>
Subject: Re: [PATCH] clk: qcom: rpmh: Add note about sleep/wake state for BCMs
Message-ID: <YrdpZHbsJ+2m/fI+@builder.lan>
References: <20220517190949.2922197-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517190949.2922197-1-swboyd@chromium.org>

On Tue 17 May 14:09 CDT 2022, Stephen Boyd wrote:

> The sleep/wake state doesn't need to be set here because of specific
> RPMh behavior that carries over the active state when sleep/wake state
> hasn't been modified. Add a note to the code so we aren't tempted to set
> the sleep/wake states.
> 
> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> This superseedes a previous patch[1] I sent that tried to fix this.
> 
>  drivers/clk/qcom/clk-rpmh.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
> index aed907982344..c07cab6905cb 100644
> --- a/drivers/clk/qcom/clk-rpmh.c
> +++ b/drivers/clk/qcom/clk-rpmh.c
> @@ -274,6 +274,11 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh *c, bool enable)
>  		cmd.addr = c->res_addr;
>  		cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
>  
> +		/*
> +		 * Send only an active only state request. RPMh continues to
> +		 * use the active state when we're in sleep/wake state as long
> +		 * as the sleep/wake state has never been set.
> +		 */
>  		ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
>  		if (ret) {
>  			dev_err(c->dev, "set active state of %s failed: (%d)\n",
> 
> base-commit: 42226c989789d8da4af1de0c31070c96726d990c
> -- 
> https://chromeos.dev
> [1] https://lore.kernel.org/r/20220412194505.614002-1-swboyd@chromium.org
