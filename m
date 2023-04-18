Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A38E15AC
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 22:32:19 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1a814fe0ddeso4120755ad.2
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 15:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681857138; x=1684449138;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QWumH5jSTQJEu5E26uuxjLhMaYa16981H9nAq/7awlg=;
        b=EmGEubnwDXGIytjygKwVWzMvy/p++gLjdLWieYdg8ogn5SJ5QMdF5jCLnRPZTKONz0
         /v4tKeOVWassklOfHy/f2KO4erJBXbYm5DTAaF1REno/h/hPG6T0S9OzTkvgn5OXEy/T
         jGgV8Dg1K0wOXrcYXEgcCMF+t8O/UOu4o0246Pzgrcd4vCs0yTlN2GF9XhVaeSi0Qnct
         gf+Su29hSlfFiw45pGx9MDur2WQei6Ri62y3j5a/+6ejNRc1LrZiZ8KM7symbmffx67S
         C/8SSj67aTReBUDamL1mfVvkb1OJE8mC2mqOfplinPhaG774lmlvHuol9eo15nsny+Vs
         Fi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681857138; x=1684449138;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWumH5jSTQJEu5E26uuxjLhMaYa16981H9nAq/7awlg=;
        b=fthGynz//JT8DW51MvO76aJ4TPXtq6gI+P7qZ0PvQC8QidUXfjrPckl770/Fs3vkLr
         PI99tR4b8+BPNNcmTUwr3HgPuG6R9A6PH3TADRFBxSYrWZ4EBp4X6j86n1nezVQKCvBs
         NREkrgRhuOm9m6RNwMG2Yt9ne33Ep/P86Jz83k5sAdRKxxTBf0ncIWb+rflza3PWSbWa
         p7ZGTXh1UItAr6/G7Irv6IK11zajCl6JD3mtnTQHa/yNDLq+3Ja09IeQbYna+Brq+6Aq
         FBYoEZsAkdk9EyfAWL9HwOt6lh6euMZRpqU4vLLg/CPwmm8rMNk2iBPwxHAqPFZd961O
         mAHw==
X-Gm-Message-State: AAQBX9ezXYEwL+QK+Aw6XWdJMCCarOyqmVGoVmePo4U7PQSGo/M+nDJX
	KFiByFp8aa1l/BnwM1eqY/4=
X-Google-Smtp-Source: AKy350ZEOEZfDbKRfmeepXRguKPu6pEtFsm9Xi5BcpK+zWcQnb805CHK23Vv/2C0tKw5m+pzO8sQmQ==
X-Received: by 2002:a17:902:c40a:b0:1a2:56f4:d369 with SMTP id k10-20020a170902c40a00b001a256f4d369mr4070373plk.19.1681857138646;
        Tue, 18 Apr 2023 15:32:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x19-20020a170902821300b001a6d781eda6sm4135319pln.120.2023.04.18.15.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 15:32:17 -0700 (PDT)
Message-ID: <19f316a5-1f8f-c929-2997-c72f84637906@gmail.com>
Date: Tue, 18 Apr 2023 15:32:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120313.001025904@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/2023 5:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

