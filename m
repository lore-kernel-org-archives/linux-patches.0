Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F37D516
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 19:20:39 +0000 (UTC)
Received: by mail-qt1-f171.google.com with SMTP id fg19so2655813qtb.6
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 12:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679426438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4A1X8DSIXCYAuOVZx3RnCB5u8at26anAgkpP7Mq9w28=;
        b=fsdsLU8DCXjJVvgFV85Ke4ZB7uwjYESWn4NK2Grj772hkmFIsvvJpZxP29vNUanffA
         pSYuR62rztsntYmQdyJQIZ+5a5bxZA+Cc9wZT+ioPlslSZcx5RjakzHxiLAisIL6YJVW
         vPQw+H2cYMK203jM5zenY2eeKbYNlA5AbTtet2vVjDWTUBQEJFDej/SeOSxjeq7b+9yr
         d078vyjbtTbK3tCOBk0m0AgFsh4pFmskHtGNC8mKJdsOMvd4ZEY/G6dsT1oXCMt7F/1I
         jdvUL/sl42crEAOY7wpWRySDvRvNQBWEUxNQzmuppqxoE+JClRMt4ck3YChHrqpoU42Z
         E/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4A1X8DSIXCYAuOVZx3RnCB5u8at26anAgkpP7Mq9w28=;
        b=YbV0qQUq22S8qcc11lyz7Ho4QDaNAOLNAECqSIiRUDkKLlli4qz0Zck8vd4d2z309j
         XyflV7uCJK3E1cKW8r//pvjKltsP+3IYrvbwL5bzYTinw0Z61H24rWNSJxT00ZrvUZ9e
         dwl03VJSifHq8RwB+Z+sBBCHx9F9jmYcDFT6FYwlyYpx4tewgM4StT2msXiQADJ6lCcp
         wffnALULWFivBjYaIbgNS01thjcuQLrAifCCFZqeQf1DoumDfkE/jcP6d/q39SaJgQGO
         9ob5pASpwleJtMaj8eikKgw5GrR9QMxHO66CuuZWKGG5nOq7kLQ/u0p3JdCR7M7UG9gr
         WIMg==
X-Gm-Message-State: AO0yUKVJCI+8EBcF2UjVA8wd0ceCXnC5Bxuq+jxleQDxF6LJB+1SNN0+
	XkWJfjOs0chxY8MINgEIIM0=
X-Google-Smtp-Source: AK7set8loF1+hW+VViWeDj7w2xu00cQHiNQqltuCYAYPi2E5wn965efpgQpenrkn6vyIk508/ACg/A==
X-Received: by 2002:ac8:7f10:0:b0:3ba:18c2:99e7 with SMTP id f16-20020ac87f10000000b003ba18c299e7mr1726278qtk.45.1679426438541;
        Tue, 21 Mar 2023 12:20:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16-20020ac86990000000b003bf9f9f1844sm8701774qtq.71.2023.03.21.12.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:20:37 -0700 (PDT)
Message-ID: <8f95d89f-ce6d-5067-bcdd-158fffb8f0ab@gmail.com>
Date: Tue, 21 Mar 2023 12:20:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230321180749.921141176@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/21/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 18:07:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

