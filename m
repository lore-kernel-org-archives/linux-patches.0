Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3CF8BF1
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 21:21:37 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id x18so917514ilp.10
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 13:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4pWtMDHlChNZpBVUhtxKeU61bbziVZ1L3zQXJ9Q/ELQ=;
        b=iGG49ZGHPzcvfk5FpC/wPCPjp3eRBlDLnfbucFVpWLpsl2Z8RzUxLQhMjaoGLnVgBq
         xjeqRsYNHx/x1cXl5gl7p7O8mwLBteNJy4e4Jt0xmGTfls523cXFG6Zp+e76SIzupePC
         DseNoGGv79jE/4Z6vcZzHYWFK5W0bjBjcgF6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4pWtMDHlChNZpBVUhtxKeU61bbziVZ1L3zQXJ9Q/ELQ=;
        b=cm1W5gB7W4SrG9OBHWNc1et4sRLJTp33M/PP6e4hVadpe11pDoYjfqxr+1Pi3MKyhp
         9qXsamRvjMu+4W+dManyQ4GgVtQmUX/xGJCOonvfYT7t900mPrYlcyQc5D2b1MHROopv
         kKJA8v41I2ghVunlUD1b/qaQmolmJfuagiolgVoQrgDUOYz1Yb1gUnC1ZkwMCzn2nxm7
         ngPKeDoSRI8C984OtmwLF7twRIcckhoQdavy6mmevFf29kCSrkUrL/9siKVoauPLKj+V
         xz3SL3cuMlZG2bV/8pCfX73A2UI2AAqX4C6wDilTeOEv8rPbQOYKeaBUmhz3KJY0KUd+
         oHMQ==
X-Gm-Message-State: AO0yUKUhGMKOT5xa0+wjk2QhAi0SRDmDpx4k9L+6v0wHHUXW784maGUB
	apVIi3FdpkH3MZyyl+xo2kGNxA==
X-Google-Smtp-Source: AK7set9iKHCEqTPRQ6Y+u1bMD/+Kbw88A5WZcUuyVysTNoY0Ai0/BDNKii8NCmibzYRgz4gqOf3llA==
X-Received: by 2002:a05:6e02:12a8:b0:313:d901:82e6 with SMTP id f8-20020a056e0212a800b00313d90182e6mr3726764ilr.2.1675804896995;
        Tue, 07 Feb 2023 13:21:36 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i15-20020a92c94f000000b00304ae88ebebsm4375569ilq.88.2023.02.07.13.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 13:21:36 -0800 (PST)
Message-ID: <8ca9283f-36ff-8e79-c168-c59f8e84f7dc@linuxfoundation.org>
Date: Tue, 7 Feb 2023 14:21:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/23 05:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
