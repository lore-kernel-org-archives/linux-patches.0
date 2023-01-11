Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7D115A7
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 00:40:38 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id i17so2426121ila.9
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 16:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DoXC0RF5LPtMrYzqBEQuK1VB+5yAJ5xRxFUwIGUCwM=;
        b=bkITCjagCoFTLuFMDnm+DcPYqrginswcZ6lEFxoexAXPQuydFtnx8shBNA88+/UDpS
         UYYKspqp8GnV5Vz8m0IXfPUR7a/EKYRw8pMFHifQLdMDiMZD87sER8zgURLojpZsL7r2
         +2OysFC1FKiK08qcrOvg+zJleHCSE7bItc3Zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2DoXC0RF5LPtMrYzqBEQuK1VB+5yAJ5xRxFUwIGUCwM=;
        b=HagVtaJOaDgkpQ2qHH346lMgOhNYHOT9c5Lu1f43hmGvcmG1PP7Hn3fR/zss0b1Vky
         dPvRg1KNv3U99Hgh+z4B+7YsikDpixsEO7iBAh7giWNJQ6xeNyNAyJva3C7JQlqgKzaj
         lRDwwfALlPKpfKRdJe0tpkoWml6lSwegTe2Ay4SvWKCiPFYYKld5ZM9D8mm3j4YoAzL0
         jhdAqYJesojMDBlnlmu40Th7CI15X6wY94mF1nGMyXGSlJTEKKmXU/hZKMPLRaaNEiXg
         Uf/GwMtUQdxJSQXW3AAru5wtz73kqN9+VzoT7O/UJM13YILFIcH1qXCvltvtGXioeQ3P
         wdiQ==
X-Gm-Message-State: AFqh2koPlaDc2DvYqDJUlp6G+nNGKW2YW/HEy4BKoTBraFLvsmmvnC6q
	AyJDxBsfmg2L4wG4/jn9JiSVDw==
X-Google-Smtp-Source: AMrXdXsSzWtkzpEvHECNk5QilwNBn1vNy4Q2toNogv2oyW3wyfW9GnNn8inX+7DLAuGTmpPsUuFQhg==
X-Received: by 2002:a92:ce03:0:b0:30d:bf1a:b174 with SMTP id b3-20020a92ce03000000b0030dbf1ab174mr230748ilo.1.1673397638021;
        Tue, 10 Jan 2023 16:40:38 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j21-20020a023215000000b003748d3552e1sm4054531jaa.154.2023.01.10.16.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 16:40:37 -0800 (PST)
Message-ID: <5035a51d-2fb3-9044-7b70-1df33af37e5f@linuxfoundation.org>
Date: Tue, 10 Jan 2023 17:40:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/23 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.87-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
