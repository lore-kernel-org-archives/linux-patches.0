Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C297B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:15:52 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id f14so6206988iow.5
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679354152; x=1681946152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CtAxNqWOHwLE7yS51A5Odfdi6tRaNsIBNbTA+Awvbiw=;
        b=gmXoMlyrRZWnoT4iQk9DZz5ZraHN2NdE7axHAxJSesQXGmlw3Cr6Lz2F0muj2gdh1U
         lM80APvBr+nT13x4E6cInaKAjMDeu2N411zee2x5VwoRj3D/Lo9dM332gAzMK6yZPgg1
         REwbsI/vMYVrSQuQdgjfz2PO3hyaqzwoMKulA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679354152; x=1681946152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtAxNqWOHwLE7yS51A5Odfdi6tRaNsIBNbTA+Awvbiw=;
        b=57nXcCGB+2XBgBPqH373DJ7cqp2Lei6KmHp9Y7i/5SM+PIBNEO+vKubfgO8gxTLRNL
         fstZoemyS7a+LJXJBH10CrXxQzGCX1BjIpGjzM9WbLbTTF6xVWLLi8V1bfk1RcKEiGpL
         V9lT+Hy9euKBAqbxAqZ5Si/MXH9EODU5UW/ycSMj4E14S6q36bNM76GBB/DVDymgYLx4
         OwEHuNAm+gk0cLfwmxc9HcEhX3lglDMPNA0xwe8nSx0bgtx6BZXjckTlwIt1dkYYkxQt
         YkZjDjTzyDsaX1/oLHdDUlCpvSqo1rG5uvpTztvPUKEUAMqngqV/5tJLoXNu+74bA2Z5
         REzA==
X-Gm-Message-State: AO0yUKUmjv+JprglLTt4CK8/eig8vujloGA99wknL3kQqqeFsN4Wzh7s
	mmnniqk6wcxgoz78SBDF4TKlBgUw0ibbPmGGfh7qPQ==
X-Google-Smtp-Source: AK7set/zjBPDnMBvyuINBNDZgvU8wFXwpesmr0R+3/eILHVMsS7RDiWwUqJuAFgRxcQ/8IIUfS4l/g==
X-Received: by 2002:a05:6602:2a42:b0:719:6a2:99d8 with SMTP id k2-20020a0566022a4200b0071906a299d8mr1130485iov.0.1679354152132;
        Mon, 20 Mar 2023 16:15:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c22-20020a5ea916000000b0074c80aa17f0sm3276618iod.0.2023.03.20.16.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:15:51 -0700 (PDT)
Message-ID: <e3ea7b81-73e8-9ca5-4588-d7aaf9f2dbc1@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:15:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.19 00/36] 4.19.279-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145424.191578432@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.279-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
