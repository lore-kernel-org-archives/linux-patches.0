Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2539D
	for <patches@lists.linux.dev>; Thu,  7 Jul 2022 08:25:49 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id i128-20020a1c3b86000000b003a2ce31b4f8so621933wma.1
        for <patches@lists.linux.dev>; Thu, 07 Jul 2022 01:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=ZUcILjU05md1B2NfaElYe4uchnCp46FPLcmqNORjJrE=;
        b=HKQ8SC+cJ0al4Lw44hNe4JkWTVj4SU/Ck+/6qZwc4m44JnE3ZSohU+1BnIRe2UVkNu
         xlBVlK0kNxTuWvdkTC8fhlh6Lv8auVqQZMzDI/avsvT8C2otxzOeNerzr2YlJk6U688y
         I3xVQHBv+kU9WzGrO6k0f32aFdu5NWBUBd+6HHQ5lEIaOlf7rnGCMwXatDntMtFXAf8V
         D7GjPbpPMTt6WRspXuu7wiDFddp9ITCerDuc3X97nNDs/piy61Uy/CW/O+aOc3TfXNVw
         9xY3J0hMNaJeh80jLCjZltTxgIuz5HihVhEGoYW0OZgwatKXTsKl19Mnengktel50jgZ
         kjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ZUcILjU05md1B2NfaElYe4uchnCp46FPLcmqNORjJrE=;
        b=gyg2O8r8mVRFLAmTxCBac0uLFoHUbF68GQ5yYQ8E1b/8HKF7fSEAaQ4yn0BDkagtKK
         xrui+MlB2UC9VOiOQseO9QDdyWNuo8bTpkrSLgrHKsahg+bK10L96W5ol0x8q04P2JJS
         Uf0MXmET/2gnzO+YMKQPRZh+G17qp9sEhzcDweObcREXA2PAyq2GJ4F1iOKDhllG4zku
         lU0WWQtd+qjluGwsdW9ZECFqEX6WB9TA31KlFml59SPrjsT+uT8Kblc00SlAJwD5KH08
         3NZbS3hU2635LnF84bpJMuytmuVTZHwq+scYZgdAjVnoTGjI2SW7VvKWdJrhqJyXMgup
         cxCg==
X-Gm-Message-State: AJIora/HnG1TrP85taWvjO3jWe8GZHNo0qBFn6ZjFGnp4Uyggt9nOeIg
	szY6PYPhCsw9gqPTZtGuM34=
X-Google-Smtp-Source: AGRyM1t4ZZhJso9Y8L5ePctxxoWGaSr2UMTxX6k5aIkfnbLkMlsQHWfCVBQRikMdjHbzOfcgGWkSRQ==
X-Received: by 2002:a05:600c:3ba7:b0:3a1:6c19:fa8c with SMTP id n39-20020a05600c3ba700b003a16c19fa8cmr2996907wms.120.1657182347619;
        Thu, 07 Jul 2022 01:25:47 -0700 (PDT)
Received: from [192.168.2.177] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id u18-20020adfdd52000000b002185d79dc7fsm14554361wrm.75.2022.07.07.01.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 01:25:46 -0700 (PDT)
Message-ID: <782e345f-1f15-c65b-9ff1-3da3e0ecd7fc@gmail.com>
Date: Thu, 7 Jul 2022 10:25:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] soc: mediatek: SVS: Use DEFINE_SIMPLE_DEV_PM_OPS for
 svs_pm_ops
Content-Language: en-US
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Roger Lu <roger.lu@mediatek.com>, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, patches@lists.linux.dev,
 Jin Xiaoyun <jinxiaoyun2@huawei.com>
References: <20220622175649.1856337-1-nathan@kernel.org>
 <92d0d361-7d04-150c-97f2-3e073945a210@gmail.com>
In-Reply-To: <92d0d361-7d04-150c-97f2-3e073945a210@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 23/06/2022 14:04, Matthias Brugger wrote:
> 
> 
> On 22/06/2022 19:56, Nathan Chancellor wrote:
>> When building this driver for an architecture that does not support
>> CONFIG_PM_SLEEP, such as hexagon, the following warnings occur:
>>
>>    drivers/soc/mediatek/mtk-svs.c:1481:12: error: unused function 
>> 'svs_suspend' [-Werror,-Wunused-function]
>>    static int svs_suspend(struct device *dev)
>>               ^
>>    drivers/soc/mediatek/mtk-svs.c:1515:12: error: unused function 'svs_resume' 
>> [-Werror,-Wunused-function]
>>    static int svs_resume(struct device *dev)
>>               ^
>>    2 errors generated.
>>
>> This happens because SIMPLE_DEV_PM_OPS uses SET_SYSTEM_SLEEP_PM_OPS,
>> which evaluates to nothing when CONFIG_PM_SLEEP is not set, leaving the
>> functions unused in the eyes of the compiler.
>>
>> This problem was rectified in commit 1a3c7bb08826 ("PM: core: Add new
>> *_PM_OPS macros, deprecate old ones") with new macros. Use
>> DEFINE_SIMPLE_DEV_PM_OPS to fix the warning while not changing
>> svs_pm_ops when CONFIG_PM_SLEEP is set.
>>
>> Fixes: 681a02e95000 ("soc: mediatek: SVS: introduce MTK SVS engine")
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks for the patch. The same issue was addressed by Jin Xiayun here:
> https://lore.kernel.org/linux-mediatek/20220623030931.2816013-1-jinxiaoyun2@huawei.com/T/#u 
> 
> 
> I'm happy for any review help.
> 

As there was no progress on the other patch, I now applied yours.

Thanks!
Matthias

> Regards,
> Matthias
> 
>> ---
>>   drivers/soc/mediatek/mtk-svs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
>> index 606a00a2e57d..d70903f45ddf 100644
>> --- a/drivers/soc/mediatek/mtk-svs.c
>> +++ b/drivers/soc/mediatek/mtk-svs.c
>> @@ -2381,7 +2381,7 @@ static int svs_probe(struct platform_device *pdev)
>>       return ret;
>>   }
>> -static SIMPLE_DEV_PM_OPS(svs_pm_ops, svs_suspend, svs_resume);
>> +static DEFINE_SIMPLE_DEV_PM_OPS(svs_pm_ops, svs_suspend, svs_resume);
>>   static struct platform_driver svs_driver = {
>>       .probe    = svs_probe,
>>
>> base-commit: 71eaf1887203d0a59c92fd9dd3436b8d8489d68c
