Received: from mail-io1-f65.google.com (mail-io1-f65.google.com [209.85.166.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7221F186
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 20:22:33 +0000 (UTC)
Received: by mail-io1-f65.google.com with SMTP id ca18e2360f4ac-77dcff76e35so72024439f.1
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 13:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1690316552; x=1690921352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bf2CNixqsX449C9tAWAb8hwMnIs0tbxQueKfU+PKFSM=;
        b=AGRnp16hEw+rhNrsrjyfBAnMMdrWNxchU0HAVM4VTwBmcpFvXOIgVabfCEPhUEp/75
         LRog49ZFOi3w1t6+DsePmQet8dXmjkG8BsbdiYoKrJO0Nj9eDwIZqsqJOepvRs0e9Xn8
         eYxuqu2J3L0IyDPVT8cbPRHGOJI4XouWWQLro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690316552; x=1690921352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bf2CNixqsX449C9tAWAb8hwMnIs0tbxQueKfU+PKFSM=;
        b=Bf+2F5CgXkjSeymT8VX0bVn0cuKG/t8c6cUwmJQD1BKTTLMtaJavFsDUyfTh+rodwO
         Bx7OsEM31O2Pilm2UNN2r+OFxZfICaocmwfFseIm+cjs0Wi2bXYlxFcIdLhe7G+zvgZt
         OqffcjIqMHrUmyy3/e4oi0SqLvZeZA4OH2V2ZDMS3vT382st0pHczOMPChlxXdxuc4eg
         87f+DUol2MQCFHL6ixQgVaje4RPX4wrJWEO5fTKEuJVbbAsOSnMmJg3pfLnMsKM3Ru8h
         nGIdPvu5MhgjSK0HyNUtahIQTqvZTbm4H8S5YnRUyP3gATMHWEl2yuxw1BLMJCA/yekj
         YUlA==
X-Gm-Message-State: ABy/qLaktck+JysKRYdSvACtp5Ow3I/aG+gJyxK6C4GVAgA4byYzHRBj
	JtawTmJs5MU9kdmsFmxpfaVl7Q==
X-Google-Smtp-Source: APBJJlGt4meFfqi4Y71Znubs6DO8N4/IGToe1sQM01yX2c3yoYaBm7GoGY8cRweCeMYwM2QD5T6WUQ==
X-Received: by 2002:a92:d08b:0:b0:348:d465:4a36 with SMTP id h11-20020a92d08b000000b00348d4654a36mr104889ilh.1.1690316552754;
        Tue, 25 Jul 2023 13:22:32 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l15-20020a92d8cf000000b003420dad3121sm3900851ilo.75.2023.07.25.13.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 13:22:32 -0700 (PDT)
Message-ID: <8f30620b-5543-86b1-e7de-47b356c01dc5@linuxfoundation.org>
Date: Tue, 25 Jul 2023 14:22:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 000/509] 5.10.188-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 04:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.188 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.188-rc1.gz
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
