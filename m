Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC357FC
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 00:22:21 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so802097pjf.0
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 17:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/T3Gfhb5CSWhS7QaQyFowl3g2EEqiZwzzNcN5K4b934=;
        b=mr5hjsKLWIaVgCMHEJew99IYxMNEuaOWASs5DrU5g9iF9JUPbyLmBJrgEFkHYXV5mB
         Ywc8DKuhcX/wLw8r1PlYG4VOgA9xdCdouf9XkQEutQpiYY/5Ge9Lya6T5n7gBwABKK4K
         5ADNap9+GO8fzEL/0xBODMvWl1xvRKFCS4mQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/T3Gfhb5CSWhS7QaQyFowl3g2EEqiZwzzNcN5K4b934=;
        b=HhyIfy09p2gEJmb+dhAaVn9+Ry1Tw94Amcn0xc3jTai8peYo0tZdh9lAbfdfRXRe3H
         TU0c8gyx7XKAYAtp8uRKDxj+KQLO6tLwb5HLWvFvJ52iAfK4KxKRMn5TSIxa89DMWw/q
         Jy1kB2iyOJdmrd1LALbskoHDc6A5UJoh6ivfzQ17qUvtpNeBbzZTZmNOUAdzEg3ZYd85
         Yljf9zwbigndy0I46e1J3sebX7HL39j3b7fKnVgZ7CpA0AcfcKzj/SoA5mZTuPLhs2o0
         eslmoDzj7WLaAXVE8L02zMxEnTz70RZTdn8DVu49EzkbCvfkyEHYSPD5II+5fU4SoOwY
         HEpg==
X-Gm-Message-State: AOAM5305npPtvjl0kkUHSP7BWNWnVum/UyK3nRmYovA9DOsSHKHZny1q
	gX8t/aJ7ulTbTces7cDdX92Grw==
X-Google-Smtp-Source: ABdhPJz1Uune6rls+uYCQI8xlokCjnbrs+GKB5C70SiB731oO+AVHbTwXu6E34kzN8S1R/sAPKlcWw==
X-Received: by 2002:a17:902:d70a:b0:158:7f07:e7c9 with SMTP id w10-20020a170902d70a00b001587f07e7c9mr13176936ply.109.1650327740972;
        Mon, 18 Apr 2022 17:22:20 -0700 (PDT)
Received: from chromium.org (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ay13-20020a056a00300d00b0050a5af3fbc7sm8685963pfb.220.2022.04.18.17.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:22:20 -0700 (PDT)
Date: Tue, 19 Apr 2022 00:22:19 +0000
From: Prashant Malani <pmalani@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
Message-ID: <Yl4Au/O/am/ZbX9J@chromium.org>
References: <20220419000408.3202635-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419000408.3202635-1-swboyd@chromium.org>

Hey Stephen,

On Apr 18 17:04, Stephen Boyd wrote:
> Don't create a device for the peripheral charger (PCHG) if there aren't
> any peripheral charger ports. This removes a device on most ChromeOS
> systems, because the peripheral charger functionality isn't always
> present.
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: Daisuke Nojiri <dnojiri@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <chrome-platform@lists.linux.dev>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
FWIW:
Reviewed-by: Prashant Malani <pmalani@chromium.org>

> ---
> 
> Changes from v1 (https://lore.kernel.org/r/20220415003253.1973106-1-swboyd@chromium.org):
>  * Use cros_ec_command()
>  * Drop the other patches that aren't needed anymore
> 
>  drivers/mfd/cros_ec_dev.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
> index 546feef851ab..596731caf407 100644
> --- a/drivers/mfd/cros_ec_dev.c
> +++ b/drivers/mfd/cros_ec_dev.c
> @@ -114,6 +114,9 @@ static const struct mfd_cell cros_ec_platform_cells[] = {
>  	{ .name = "cros-ec-chardev", },
>  	{ .name = "cros-ec-debugfs", },
>  	{ .name = "cros-ec-sysfs", },
> +};
> +
> +static const struct mfd_cell cros_ec_pchg_cells[] = {
>  	{ .name = "cros-ec-pchg", },
>  };
>  
> @@ -137,6 +140,7 @@ static int ec_device_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct cros_ec_platform *ec_platform = dev_get_platdata(dev);
>  	struct cros_ec_dev *ec = kzalloc(sizeof(*ec), GFP_KERNEL);
> +	struct ec_response_pchg_count pchg_count;
>  	int i;
>  
>  	if (!ec)
> @@ -242,6 +246,21 @@ static int ec_device_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	/*
> +	 * The PCHG device cannot be detected by sending EC_FEATURE_GET_CMD, but
> +	 * it can be detected by querying the number of peripheral chargers.
> +	 */
> +	retval = cros_ec_command(ec->ec_dev, 0, EC_CMD_PCHG_COUNT, NULL, 0,
> +				 &pchg_count, sizeof(pchg_count));
> +	if (retval >= 0 && pchg_count.port_count) {
> +		retval = mfd_add_hotplug_devices(ec->dev,
> +					cros_ec_pchg_cells,
> +					ARRAY_SIZE(cros_ec_pchg_cells));
> +		if (retval)
> +			dev_warn(ec->dev, "failed to add pchg: %d\n",
> +				 retval);
Tiny nit: Can this fit in 1 line (100 chars[1])?


BR,

-Prashant

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bdc48fa11e46f867ea4d75fa59ee87a7f48be144
