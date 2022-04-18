Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF403D61
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 23:08:42 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 203so2516482pgb.3
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 16:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pl4a1fMymhH/XaPiTy1w0Dc08PXzaBVwflpLSOoW8Yk=;
        b=jy1VZlNcq/9U5Ar0F5s7yclwR/2ytq2kRRt4Ot66e+/0Rjaq862/Zkd9XN88f4dXsF
         UUgCogzKzwuZt0iOzB+5xfW6FC+NLWYzAs6P5wItYRAb6fcHWKkRHSLtPZxo0HtkF+/z
         EXs89xdD8yLcudimZPW2W7TGRJpdOCmg9Nw8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pl4a1fMymhH/XaPiTy1w0Dc08PXzaBVwflpLSOoW8Yk=;
        b=6Mwb5Y3XTgbaP9/KED8cB9pz7JyZssNpKF2WPp3sNMwV7tYdbHDobKQPWu6CoizYZf
         XxsMucUfwS6NwwTaMJu9EvX5PnrixwINzv9CT9FBdlQZ3F/GUVgxifvTPETlQ85DiRRU
         0/jaDYijxMU/krXcXls8Mm6Kms/chKQbicJakSUZXpl6d9Xlkxv3YL0odUFGWYXZ/10t
         3qtFn7vuPAdIBp5TYW1rZHvs846qa+Vc2hy87CnHsdxtw37oiiUQ1j01Igf2fVnwCnA5
         lU/u8eUmc73kZ51EsHpzASUHakkZfRnbkPPwsf32ssoRthK2ux0FmtQUrNeDw11OrWJU
         Ys5w==
X-Gm-Message-State: AOAM531bZOKW7AdtNKesjulGmjscFzww6CRX9DFpfWcdAHgsvrY78RqB
	Ovy17xV2dozB1poEuBRIelIyZQ==
X-Google-Smtp-Source: ABdhPJzrMMgiVgnGS1tb2dOQcYsLll9fc4XWRYNTU66SXevGjIRh1B/3P0/A/mZpsI05/pWOguDuNg==
X-Received: by 2002:aa7:9ad8:0:b0:50a:49e1:164c with SMTP id x24-20020aa79ad8000000b0050a49e1164cmr14593991pfp.8.1650323321628;
        Mon, 18 Apr 2022 16:08:41 -0700 (PDT)
Received: from chromium.org (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y9-20020a62ce09000000b0050a6516573esm6959461pfg.67.2022.04.18.16.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:08:41 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:08:39 +0000
From: Prashant Malani <pmalani@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH 1/3] platform/chrome: cros_ec_proto: Add peripheral
 charger count API
Message-ID: <Yl3vd4kfgwJXMs/w@chromium.org>
References: <20220415003253.1973106-1-swboyd@chromium.org>
 <20220415003253.1973106-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415003253.1973106-2-swboyd@chromium.org>

Hey Stephen,

On Apr 14 17:32, Stephen Boyd wrote:
> Add a peripheral charger count API similar to the one implemented in the
> ChromeOS PCHG driver so we can use it to decide whether or not to
> register the PCHG device in the cros_ec MFD driver.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daisuke Nojiri <dnojiri@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <chrome-platform@lists.linux.dev>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/platform/chrome/cros_ec_proto.c     | 31 +++++++++++++++++++++
>  include/linux/platform_data/cros_ec_proto.h |  1 +
>  2 files changed, 32 insertions(+)
> 
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> index c4caf2e2de82..42269703ca6c 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -832,6 +832,37 @@ bool cros_ec_check_features(struct cros_ec_dev *ec, int feature)
>  }
>  EXPORT_SYMBOL_GPL(cros_ec_check_features);
>  
> +/**
> + * cros_ec_pchg_port_count() - Return the number of peripheral charger ports.
> + * @ec: EC device.
> + *
> + * Return: Number of peripheral charger ports, or 0 in case of error.
> + */
> +unsigned int cros_ec_pchg_port_count(struct cros_ec_dev *ec)
> +{
> +	struct cros_ec_command *msg;
> +	const struct ec_response_pchg_count *rsp;
> +	struct cros_ec_device *ec_dev = ec->ec_dev;
> +	int ret, count = 0;
> +
> +	msg = kzalloc(sizeof(*msg) + sizeof(*rsp), GFP_KERNEL);
> +	if (!msg)
> +		return 0;
> +
> +	msg->command = EC_CMD_PCHG_COUNT + ec->cmd_offset;
> +	msg->insize = sizeof(*rsp);
> +
> +	ret = cros_ec_cmd_xfer_status(ec_dev, msg);
> +	if (ret >= 0) {
> +		rsp = (const struct ec_response_pchg_count *)msg->data;
> +		count = rsp->port_count;
> +	}
> +	kfree(msg);

Can we use the wrapper function cros_ec_command() [1] here, which does
the kzalloc and msg construction?

Best regards,

-Prashant

[1] https://elixir.bootlin.com/linux/latest/source/drivers/platform/chrome/cros_ec_proto.c#L914
