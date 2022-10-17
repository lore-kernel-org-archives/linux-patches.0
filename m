Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4354E2568
	for <patches@lists.linux.dev>; Mon, 17 Oct 2022 14:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C02CC433C1
	for <patches@lists.linux.dev>; Mon, 17 Oct 2022 14:42:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SGw9SuvP"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 17 Oct 2022 15:42:11 +0100
Resent-Message-ID: <Y01pw7tOv00OGxNo@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 17 Oct 2022 15:26:50 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=zcFy=2S=linaro.org=neil.armstrong@kernel.org>)
	id 1okR4p-004Ke2-PK
	for broonie@sirena.co.uk; Mon, 17 Oct 2022 15:26:50 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id D11EBB81895
	for <broonie@sirena.co.uk>; Mon, 17 Oct 2022 14:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id AF426C433D7; Mon, 17 Oct 2022 14:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE123C433D6
	for <broonie@kernel.org>; Mon, 17 Oct 2022 14:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org AE123C433D6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id n12so18694850wrp.10
        for <broonie@kernel.org>; Mon, 17 Oct 2022 07:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gZOLQf1UPwtNviLV/qU6E4i1a2GMJgeju/g/q3GYhVI=;
        b=SGw9SuvPE38SzlaJFTwVftXKrEbpFR8csH2GDLjSwTZ0nvhXiMBNgTNTqelKA8c+1o
         2ZNrYHuczOMB6J53JYWM1MNYvWIx8cPlUcc97jbipTAsnSuBJLpUpLow9WkRno0YzEaD
         cltSzwpm4mQ/2RDDuMtgAPMWik4nzpMYf1oRk4vINxQVHlthZQWgJyiS+r6Q70iY9jB8
         cRZSKT7ubI7dqewNKoG1ocwkdTlNrIRCtWG77amuUREgOhzc3RD6cV2pgt8d36WGuefM
         Pd3AfTwkUOUWwxoFnDDcUEic9VpLj7VWzqDb7dlgGLld3af6EfttW+j6D+06ghYw5Eig
         Kowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gZOLQf1UPwtNviLV/qU6E4i1a2GMJgeju/g/q3GYhVI=;
        b=A50T0YE7KosjbViOF9F965Oqln+EqXHxNtiUtZtVeCXrzDZguJ3nLxi1RzS5rUATBt
         F60aKKphIEaWdnk1XMM95vX57xincC8Q9YOMcAic1JFwf8RKzzNiqVaV2bM626c1Ro4t
         VGE2AW0thgycBjcncVlFNIlW5kBx4N9L1QG5z7mqTZRXKZp6E+B5xQu1OrhUxJTlMwo+
         PWrdOqxrhUeedSlolxZ1ns8V9op6jP9VKwOI8/HE78XPGB/gjeoixVUBNjTl8/JiGXb7
         KjIy4QyvkEwqvO5Qlijiwb9fGKwf5bS1gKlxslPbRS9528tP/aRgkqzJSI52CVPET09n
         9/hg==
X-Gm-Message-State: ACrzQf2dP1fREkqkrWdF9CJdWPQcSEGpTwtsub2gVwo6GIqzey4CxiT0
	DsnlngQ/zTh4UBo4NDbolSwk6A==
X-Google-Smtp-Source: AMsMyM6kaUywtwsYLiENVVCVQUWp5VX/kOxg/UwfLdOADBvu7PMIJdwO8iuBZDJ8k+M7LFuBYsqImg==
X-Received: by 2002:a05:6000:184d:b0:22f:4ef4:47a7 with SMTP id c13-20020a056000184d00b0022f4ef447a7mr6284017wri.563.1666016803913;
        Mon, 17 Oct 2022 07:26:43 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:18de:9cc5:22bd:5fc6? ([2a01:e0a:982:cbb0:18de:9cc5:22bd:5fc6])
        by smtp.gmail.com with ESMTPSA id 20-20020a05600c021400b003b4c979e6bcsm15214552wmi.10.2022.10.17.07.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 07:26:42 -0700 (PDT)
Message-ID: <dc322023-e2f0-043a-b030-afc1ced0cae9@linaro.org>
Date: Mon, 17 Oct 2022 16:26:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Content-Language: en-US
To: Shaomin Deng <dengshaomin@cdjrlc.com>, jbrunet@baylibre.com,
 perex@perex.cz, tiwai@suse.com, khilman@baylibre.com
Cc: lgirdwood@gmail.com, broonie@kernel.org
References: <20221017141812.6867-1-dengshaomin@cdjrlc.com>
Organization: Linaro Developer Services
In-Reply-To: <20221017141812.6867-1-dengshaomin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=zcFy=2S=linaro.org=neil.armstrong@kernel.org
Subject: Re: [PATCH] ASoC: meson: axg-pdm: Fix double word in comments
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: sZLeTau9auKV

On 17/10/2022 16:18, Shaomin Deng wrote:
> Delete the doubled word "for" in comments.
> 
> Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
> ---
>   sound/soc/meson/axg-pdm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/meson/axg-pdm.c b/sound/soc/meson/axg-pdm.c
> index 88ac58272f95..ad43cb2a1e3f 100644
> --- a/sound/soc/meson/axg-pdm.c
> +++ b/sound/soc/meson/axg-pdm.c
> @@ -169,7 +169,7 @@ static int axg_pdm_set_sysclk(struct axg_pdm *priv, unsigned int os,
>   
>   	/*
>   	 * Set the default system clock rate unless it is too fast for
> -	 * for the requested sample rate. In this case, the sample pointer
> +	 * the requested sample rate. In this case, the sample pointer
>   	 * counter could overflow so set a lower system clock rate
>   	 */
>   	if (sys_rate < priv->cfg->sys_rate)

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
