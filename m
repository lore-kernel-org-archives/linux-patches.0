Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025B31876
	for <patches@lists.linux.dev>; Thu, 23 Jun 2022 12:04:53 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id c13so23744745eds.10
        for <patches@lists.linux.dev>; Thu, 23 Jun 2022 05:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ufu6yT18j4D0NeIusttCIlZORKdSbmeJGdvOSn9RpAw=;
        b=o8SClQWJV5Ru/Zc8kpIdfbB9MMcgpPbzPeoQuTiYHI9bPc2WZepmmWOwVWQQrgclFP
         5aDdGr27KalRWPaO+mKs3hfrgcMUKaPg/kzjca8NDYWw/i9nND4yxHp09pxi2wZY04m2
         MCqW0M+I7QMoGibNDx3wIiwS9squIMpJKDwGJptwEnySzboWicpD9TgG4VYwIcOz3kxK
         IQD4cWsli6o92xPDAME4MK5M1VCRqnCZnRJYCVfu1s65Jr/YhnnPuHSDBsllxgGLuI3/
         RhAoudSBfC2M4M2O5Ox1dX+VdeLdQaVEk3HcT3ck0g9P74AH0jD1q80UMa6ZXAmHWeV8
         2kVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ufu6yT18j4D0NeIusttCIlZORKdSbmeJGdvOSn9RpAw=;
        b=4lOMg+abLItuFx33rqiyXRx8EHg1QzNwRuMrcb16LEQf9gmPjh5vQeKPUZJwMKiIAW
         eBSK6y0SUy+muWjFH6Zk7g6zAe2zgsEco2MHFP3vuPFNXP5bFwfD4+Z2B/XtF6RcCMc7
         j4d1VwsfrGDuV75i7Pepdej9Z6Gtyc1tVOSgITeexRFe/2adosCS2Xbpb+osXPqI8mk8
         IlOWAVcbqb7p90w1ySZ7yCqITi/uGDgLDpXmsffBQmbLoW/0eRAOsHX2HwWmwYCWdxMY
         WZu+ug7zY/AIMMekQO5Z8Zx1chkN43h73GAXmBgWoesqDX7hSFTsBfXOknTwDOKb6Fqx
         ZIjA==
X-Gm-Message-State: AJIora+o3NjtbBzqx/DPTgjJiTKCCjIhBv3ncwPRVOYmSrbwKVjxCFRc
	vSeoUpPWvjxIqub5opHy9I4=
X-Google-Smtp-Source: AGRyM1usXBmH5/fwpNd06qO/yWn2NlL7QH0bfQAJrMesDu49vzDOCQ4mmdd+Px7FI9LJ81NuOg/r/Q==
X-Received: by 2002:a05:6402:5388:b0:435:71b:5d44 with SMTP id ew8-20020a056402538800b00435071b5d44mr10080480edb.364.1655985892157;
        Thu, 23 Jun 2022 05:04:52 -0700 (PDT)
Received: from [192.168.1.145] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id g15-20020a1709063b0f00b007246492658asm979759ejf.117.2022.06.23.05.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 05:04:51 -0700 (PDT)
Message-ID: <92d0d361-7d04-150c-97f2-3e073945a210@gmail.com>
Date: Thu, 23 Jun 2022 14:04:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] soc: mediatek: SVS: Use DEFINE_SIMPLE_DEV_PM_OPS for
 svs_pm_ops
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>
Cc: Roger Lu <roger.lu@mediatek.com>, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, patches@lists.linux.dev,
 Jin Xiaoyun <jinxiaoyun2@huawei.com>
References: <20220622175649.1856337-1-nathan@kernel.org>
From: Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20220622175649.1856337-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 22/06/2022 19:56, Nathan Chancellor wrote:
> When building this driver for an architecture that does not support
> CONFIG_PM_SLEEP, such as hexagon, the following warnings occur:
> 
>    drivers/soc/mediatek/mtk-svs.c:1481:12: error: unused function 'svs_suspend' [-Werror,-Wunused-function]
>    static int svs_suspend(struct device *dev)
>               ^
>    drivers/soc/mediatek/mtk-svs.c:1515:12: error: unused function 'svs_resume' [-Werror,-Wunused-function]
>    static int svs_resume(struct device *dev)
>               ^
>    2 errors generated.
> 
> This happens because SIMPLE_DEV_PM_OPS uses SET_SYSTEM_SLEEP_PM_OPS,
> which evaluates to nothing when CONFIG_PM_SLEEP is not set, leaving the
> functions unused in the eyes of the compiler.
> 
> This problem was rectified in commit 1a3c7bb08826 ("PM: core: Add new
> *_PM_OPS macros, deprecate old ones") with new macros. Use
> DEFINE_SIMPLE_DEV_PM_OPS to fix the warning while not changing
> svs_pm_ops when CONFIG_PM_SLEEP is set.
> 
> Fixes: 681a02e95000 ("soc: mediatek: SVS: introduce MTK SVS engine")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for the patch. The same issue was addressed by Jin Xiayun here:
https://lore.kernel.org/linux-mediatek/20220623030931.2816013-1-jinxiaoyun2@huawei.com/T/#u

I'm happy for any review help.

Regards,
Matthias

> ---
>   drivers/soc/mediatek/mtk-svs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
> index 606a00a2e57d..d70903f45ddf 100644
> --- a/drivers/soc/mediatek/mtk-svs.c
> +++ b/drivers/soc/mediatek/mtk-svs.c
> @@ -2381,7 +2381,7 @@ static int svs_probe(struct platform_device *pdev)
>   	return ret;
>   }
>   
> -static SIMPLE_DEV_PM_OPS(svs_pm_ops, svs_suspend, svs_resume);
> +static DEFINE_SIMPLE_DEV_PM_OPS(svs_pm_ops, svs_suspend, svs_resume);
>   
>   static struct platform_driver svs_driver = {
>   	.probe	= svs_probe,
> 
> base-commit: 71eaf1887203d0a59c92fd9dd3436b8d8489d68c
