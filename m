Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE1DEA1
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 02:04:23 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id w4so4097182ilv.0
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 18:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BAaz3T7EVMYtAYEFCO97m9rG/0Se1MKw2KAFy05ZZU8=;
        b=H3v3AJHg4K6M8J29+tkbgIvgN1+7N7xmQ//Fa2NyLVnb8AEOWWXNCRrpmptrAbMFuN
         LJ317IkjBtYk0BI/6Mg8pRbAJn/pJTIKl2POU+l2DyjlQJTseWbJS0NsGUEjN3BP2A4Y
         rz20WwyhIlWli8CUE9O/NAJSIH0TxNnijYyQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BAaz3T7EVMYtAYEFCO97m9rG/0Se1MKw2KAFy05ZZU8=;
        b=h80SPf/vDmJrRoNN+ydSVfVrx/YTx463wFlHBFPIvKaO1lTtDMXIQG9qcIDgsQtZGU
         WzV100XD1vPtAejF+YXt29UNo7BznGWiPMUaFe8eRyHhZnIegYuyhnHKFwVYkbeMvpvv
         c5nMm23v0X7pghT6GVn85p6hK88nYlznPo9FcbsQAbbQXkXVIGAqUDjtQxGKNFvPYGF6
         UtwHBymrtRu88OO8CBlhBbcdw//MzNomNfOYjyPJsrX5zJfW8Ox2HyM+iEHoR36aTU0B
         EtKQ0TJ+wPH1LPHnF/r5xc0JSwMc9ChUUclwyff0z5ohXhAImf4x3Yyr5KqcmaEnMP6n
         k74Q==
X-Gm-Message-State: AO0yUKUeW3TarT3kbCnbSmb3e9r0hv/FxU5blrBDVyiTrruLSU+NI6KA
	t4tqKgV/pqpf4sY+LgGqB7Zyp3TADE4vd+tVvieP7g==
X-Google-Smtp-Source: AK7set+Dai32Wj82NJWlW9hFd7xUMX2tvvddwKywlDBlWfZ4l1YlPafpHJEGcYzib1mKMCqKAUuQow==
X-Received: by 2002:a05:6e02:1c86:b0:317:16bc:dc97 with SMTP id w6-20020a056e021c8600b0031716bcdc97mr6545777ill.3.1678500262780;
        Fri, 10 Mar 2023 18:04:22 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i16-20020a056e020d9000b00315d1153ffcsm451641ilj.65.2023.03.10.18.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:04:22 -0800 (PST)
Message-ID: <9dab07e5-46fc-2aeb-65bb-5f695cad527e@linuxfoundation.org>
Date: Fri, 10 Mar 2023 19:04:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 000/529] 5.10.173-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 06:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.173 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
