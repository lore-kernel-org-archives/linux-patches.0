Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA8B7E0
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 03:05:39 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-689f9576babso465454b3a.0
        for <patches@lists.linux.dev>; Thu, 24 Aug 2023 20:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692932739; x=1693537539;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AQkGcJig5Ikswh6ioX+MQ7H5V5XCWm0xtDWdzlqdViY=;
        b=kKVTY9AOkVCu3TWfXNgEVOCt/Ep9rzVd2+Vurpt/Baaun65HtxyMRRkUPGv9lOVPAi
         c6fvkJM4RcbBNx5Aj4bL668edDJ7UvBeUma5kBwa8hcPO3vfjLnoP0jM+L84/SZly0TT
         2chOFg1dul9kpp/qIxSpDvVGNL7oI7j+vt13rSxmLbT9fI2fF32KfWNOmkvsJIo9jv5S
         3TLnKvKZPEJE4uEALTDawCAURMXtsE1KHP5+IaflPBNN+TcdLil8tDvZZPYWXf4+qXrO
         7bzWGbDVmZoGYVbms46TUVe9K5C4zyE9Wjh79uvH817Tgh7AL33eesttM41sl7rE35nl
         yVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692932739; x=1693537539;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQkGcJig5Ikswh6ioX+MQ7H5V5XCWm0xtDWdzlqdViY=;
        b=V7mFeuiyjBMMQ+qK2cKtXoKbgYn5qMYhsJ45FwgyIlgt2cnKdYDYurM8zbyAvu8nPO
         aA6QICJ+raM2WazWLxKmI2mtGXGGhBPsKoVUwtNGnZGEUwI/RrWrosDrY8WZP/ybps5T
         nZcXVjVW1CYlDBFcBARgkzFrePt26Z7Froz7rSdW0FAeChlJX7VaoEKIEJJx45rYR/Gk
         iCF18BkOt8ciI3aycxdUmu8xevMT7y+LMQzy1WJxJOIz9hErBf8HCTCxMjmTk3Axbsin
         PSomIrajjvKqdTFZ6bJZDrbanvftn+mf+4+fEYKGDDlkaAjBv/w1SG8AiMmDWmZ1XWts
         PB5Q==
X-Gm-Message-State: AOJu0Yzq09NYylQ4nwCfZ/ahBRDDr05ui0GWzJ7bgTFJvEoMKLzDoOwj
	HZ5hJQ4I/4ov0GgjTS8dDTI=
X-Google-Smtp-Source: AGHT+IFw68O5htHpltbd+56TZqEPJaitCBUbaUfkWbjImd13dfj1kEaOSNa8foDtn1FDzHiMx+BskA==
X-Received: by 2002:a05:6a21:7786:b0:14c:84e6:1ab4 with SMTP id bd6-20020a056a21778600b0014c84e61ab4mr175291pzc.33.1692932739178;
        Thu, 24 Aug 2023 20:05:39 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:944f:2db6:2b1a:8d59? ([2600:8802:b00:4a48:944f:2db6:2b1a:8d59])
        by smtp.gmail.com with ESMTPSA id t20-20020a62ea14000000b006887b69f034sm444505pfh.102.2023.08.24.20.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 20:05:38 -0700 (PDT)
Message-ID: <2d9df2e0-bd6d-e07d-e01c-a6005905b1d4@gmail.com>
Date: Thu, 24 Aug 2023 20:05:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 00/15] 6.1.48-rc1 review
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230824141447.155846739@linuxfoundation.org>
 <dfab0ed3-2a7b-dee4-76a2-2619c8900f69@gmail.com>
In-Reply-To: <dfab0ed3-2a7b-dee4-76a2-2619c8900f69@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/24/2023 2:31 PM, Florian Fainelli wrote:
> On 8/24/23 07:14, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.48 release.
>> There are 15 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 26 Aug 2023 14:14:28 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.48-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> I was not testing system wide suspend resume until recently and am 
> seeing various issues with drivers that implement resume_noirq, but only 
> on a specific platform, see below. I will see about bisecting that at 
> some point.

This appears to be specific to drivers/rtc/rtc-brcmstb-waketimer.c 
nothing to be worried about for now.
-- 
Florian
