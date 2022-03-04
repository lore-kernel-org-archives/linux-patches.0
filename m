Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639EDA4D
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 11:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646394395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ObWgVceW+qaF094L/LrZKP/18J1+19p9ZMszIe3Wv+8=;
	b=G7XadozemUxxE70qY5UhpIa0440czo1eK7pUrrGn4Wvz8Pd3xtI3wAdPWZdoKPRlUUubmN
	uH1iMTcYsXJB4VLwB7RlDRA6EnAgOiKDVsv/FUzOXGVhEywKQCETkpsUIApXv2XkWLd4j9
	s1039YHuWGFWr5bf8kjiAb/XaNZrSU4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-jGNkCl5pMR6HWszYL_Gukg-1; Fri, 04 Mar 2022 06:46:34 -0500
X-MC-Unique: jGNkCl5pMR6HWszYL_Gukg-1
Received: by mail-ed1-f72.google.com with SMTP id b13-20020a056402278d00b0041311e02a9bso4404645ede.13
        for <patches@lists.linux.dev>; Fri, 04 Mar 2022 03:46:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ObWgVceW+qaF094L/LrZKP/18J1+19p9ZMszIe3Wv+8=;
        b=qVcp83ldVuhO2XG3K/vBWjl4AAuJ8QvnPspDrlRIli+f3TRtUZBhtKyB8zHB7ZItio
         AoSxUQd0A79Q7x+9sE5D/g+0gTZ18KKa0iFTCQ1Gb1ifuzbQVEFqB3ManWnu/V3TvFwi
         rVgbhvQS9De7+mbIMsF/TW34FiJ66ZI/KIdzqWqZG420vG8dGtHEGf/3V9gfylly2sz5
         7HrevPj68gaHKo/BwMoDhF34JOEOx/anbQzudmghNHhCB0fIMi+IkeX8muwMng8wV3ce
         NGuE2quVIc+FP9b5/LMDMgGFMoIde9jinao1am66Yb5I3rCB+sxtZuXqk43ZrKF4It1n
         uj8g==
X-Gm-Message-State: AOAM530zz4EU36EfRpfDnQBtHi+V81S7UhXqbawX8k8lWkwgyUiXiz00
	QalqcivYEbdanrUbnsze0zPyTNm3hWU/X7qydRtdmYCzgEwNkIuYNqzVSTgE3jfTs5K9rC/DXFn
	jUKLMP8UHVBAEcgmtVw==
X-Received: by 2002:a17:906:6a11:b0:6d7:76cc:12f6 with SMTP id qw17-20020a1709066a1100b006d776cc12f6mr11919990ejc.456.1646394392784;
        Fri, 04 Mar 2022 03:46:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEh+dczpDjjT+p5sWJXuZzWsG2sUcVmVuREh4s52hWozp5u84TEs+jg3XtYOLD63lQEHPEdA==
X-Received: by 2002:a17:906:6a11:b0:6d7:76cc:12f6 with SMTP id qw17-20020a1709066a1100b006d776cc12f6mr11919979ejc.456.1646394392597;
        Fri, 04 Mar 2022 03:46:32 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id k17-20020a1709062a5100b006d5c69301e4sm1677893eje.202.2022.03.04.03.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 03:46:32 -0800 (PST)
Message-ID: <b7f8ad61-4dcd-a7cd-94f5-2a37aa57fd6a@redhat.com>
Date: Fri, 4 Mar 2022 12:46:31 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH -next] i2c: designware: Mark
 dw_i2c_plat_{suspend,resume}() as __maybe_unused
To: Nathan Chancellor <nathan@kernel.org>, Wolfram Sang <wsa@kernel.org>,
 Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Jan Dabros <jsd@semihalf.com>, linux-i2c@vger.kernel.org,
 patches@lists.linux.dev
References: <20220303191713.2402461-1-nathan@kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220303191713.2402461-1-nathan@kernel.org>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/3/22 20:17, Nathan Chancellor wrote:
> When CONFIG_PM is set but CONFIG_PM_SLEEP is not, two compiler warnings
> appear:
> 
>   drivers/i2c/busses/i2c-designware-platdrv.c:444:12: error: unused function 'dw_i2c_plat_suspend' [-Werror,-Wunused-function]
>   static int dw_i2c_plat_suspend(struct device *dev)
>              ^
>   drivers/i2c/busses/i2c-designware-platdrv.c:465:12: error: unused function 'dw_i2c_plat_resume' [-Werror,-Wunused-function]
>   static int dw_i2c_plat_resume(struct device *dev)
>              ^
>   2 errors generated.
> 
> These functions are only used in SET_LATE_SYSTEM_SLEEP_PM_OPS(), which
> is defined as empty when CONFIG_PM_SLEEP is not defined. Mark the
> functions as __maybe_unused to make it clear that these functions might
> be unused in this configuration.
> 
> Fixes: c57813b8b288 ("i2c: designware: Lock the adapter while setting the suspended flag")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>  drivers/i2c/busses/i2c-designware-platdrv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 116a297d1f6b..70ade5306e45 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -441,7 +441,7 @@ static int dw_i2c_plat_runtime_suspend(struct device *dev)
>  	return 0;
>  }
>  
> -static int dw_i2c_plat_suspend(struct device *dev)
> +static int __maybe_unused dw_i2c_plat_suspend(struct device *dev)
>  {
>  	struct dw_i2c_dev *i_dev = dev_get_drvdata(dev);
>  
> @@ -462,7 +462,7 @@ static int dw_i2c_plat_runtime_resume(struct device *dev)
>  	return 0;
>  }
>  
> -static int dw_i2c_plat_resume(struct device *dev)
> +static int __maybe_unused dw_i2c_plat_resume(struct device *dev)
>  {
>  	struct dw_i2c_dev *i_dev = dev_get_drvdata(dev);
>  
> 
> base-commit: 1d366c2f9df8279df2adbb60471f86fc40a1c39e

