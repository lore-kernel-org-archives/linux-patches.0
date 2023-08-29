Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2020171B2
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 14:13:55 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-34914064ea9so3125685ab.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693318434; x=1693923234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Ow39PSVhrVA+5+BHUV50uZmTZe4SBqTcpP4XBrIksQ=;
        b=ESWvNKtrA0zKcqPbJVo1y/jobBHITJRjL+Ii+MmQbE+W4WFnCYUPIb/nMEjf1EUwfr
         Ux4BCPuKZQA9lHGOXTru+ditiR5sy5bfGxw/xIWXytACF91N1vyLdwSXa+7R87oNt50+
         DmCQcuUSOXli0gZarqlRDcyx4aIdH0Ovluhco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693318434; x=1693923234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Ow39PSVhrVA+5+BHUV50uZmTZe4SBqTcpP4XBrIksQ=;
        b=lhK1TX6Ed9mhF6jv5lK6RxqyXXGWbUGHBrTLx6QRsBroC7yclGlLffPhb9o9Uaibiv
         YPsSBma5TeBdTAdlRP7Zoc3NwySIMVuesz9ZXt63nnZhJBZo5cLiRYc/XWY03MKFfGDb
         imSUpZM2fZcMRlitJegw6lmtIelTRIy0GLIG+27FNGijyEkZbJcdVoh4q6MG1TDktb8G
         i76xa/+Nluy3ofDzQ4rXBM46ygdyEzjjXB3YY9swkI7fNIBn27sKPaOLXyFCqrb7K+ei
         jiqdIGox8baYWQ+HA3LuB4kpOenY3r3eDmtznvI8qrzQBJUXQ+WPMWSDOtlbz9JryI6Q
         TVkg==
X-Gm-Message-State: AOJu0YwiIRIzkdNaEGR3qM1Hd8SofuhXmRQf2Tb/k+2pFeRnQk5jfsq8
	wljABdknGyHTygeCSoXN3nxPgA==
X-Google-Smtp-Source: AGHT+IG5LZETuQ/5kLHg1MRWthIIJ9cqREwChDwJz8qqmvY69opkos+OlSNzQ3fSSkH7lbL8/HGqdA==
X-Received: by 2002:a05:6e02:110:b0:349:582c:a68d with SMTP id t16-20020a056e02011000b00349582ca68dmr24273193ilm.3.1693318434690;
        Tue, 29 Aug 2023 07:13:54 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i6-20020a92c946000000b0034cac5ced38sm3138213ilq.13.2023.08.29.07.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:13:54 -0700 (PDT)
Message-ID: <668c35cb-580a-e099-5f67-ec19e289bc42@linuxfoundation.org>
Date: Tue, 29 Aug 2023 08:13:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/89] 5.15.129-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230828101150.163430842@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 04:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.129 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.129-rc1.gz
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
