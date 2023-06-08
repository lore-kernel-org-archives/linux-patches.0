Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E06ECF
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 03:06:39 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-777a9ca9112so718639f.1
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 20:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686193598; x=1688785598;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i/A8b6iF5sDA3+NoxQXVIUbsxw4l3iTn+tTmjMZOtLo=;
        b=VAWd+EgzvfPSWbzp2m3+zw/d4oi/GznSJnYpQch+bSWRGmBupUwVeUMJoVYjI/rTSS
         dC0iH7IlZyQ4qb1y8i/rKKZ1Cs/sDiGZDOWu6G++KqQMezz8FUN0Nno42otdfl2ILyRk
         iNz4pX4sBQfqh+cz1VZ9oN7VBtzzy6nfOnvNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686193598; x=1688785598;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/A8b6iF5sDA3+NoxQXVIUbsxw4l3iTn+tTmjMZOtLo=;
        b=DtETK8W80DvREaXs965DycPHg2o/wnF7ifmZ0WkxnpPUGKT5bsOx2Kc5CISOdht+/B
         zOw6Z3cUqR0oi+1uT7sH/2Vg4vl1SubMlOjYnc9dnJ6a7tddCW8TToNl5OXDYxWsLrIK
         ZfTrEn3W2CTye0XBOentlnm5KQD6f4l3gbr5Nuc+KB5rrWVcxIBASoisLvcX+laDztHb
         XkB2i79bGNXieJegIiIXQilBS+gBoZcZZxlpjtogGDIMlFzIYc/REA5tCN+A/rMWkcnh
         9xH26Z1d7TNO1PgC7x5FPd3try5sfv6HnbtPtOmzO5bmqh6i3pXloQ97I4tIiSibPNdN
         Nwzg==
X-Gm-Message-State: AC+VfDxcnL96LqI85ghDuhC3GtA4IFYiAmMnioy1lusBmT4MamyR5FmK
	dNyAoKcy7MmBw+lWedyYkyYIEg==
X-Google-Smtp-Source: ACHHUZ7z2yhs8NP/M1HRy2LLVSiEVgweThLUygA3O/SFZAA2gmzDg4fgwSs0PNR1/1MjJsHpzRqu+Q==
X-Received: by 2002:a5e:df48:0:b0:777:a94d:a362 with SMTP id g8-20020a5edf48000000b00777a94da362mr2559580ioq.2.1686193598348;
        Wed, 07 Jun 2023 20:06:38 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c5-20020a02a405000000b0041848ea6594sm12972jal.34.2023.06.07.20.06.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 20:06:37 -0700 (PDT)
Message-ID: <c2d8bcad-cb59-7f6a-591a-3fbb15586bf2@linuxfoundation.org>
Date: Wed, 7 Jun 2023 21:06:37 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 000/120] 5.10.183-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 14:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.183 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.183-rc1.gz
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

