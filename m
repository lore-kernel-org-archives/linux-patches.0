Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499B51643E
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 18:07:47 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-68a6f6a66e1so3430992b3a.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693332466; x=1693937266; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HHqHaW4KwaaV6z2LCLOETVk7sy6B6NzFH3inU6ye2zw=;
        b=V54xuYD8wTXFugvSkLWFwcel5046Xjd2ITJamjyoj8MZP/f/sNuhlo23nfEPKTnbth
         kpW8BRWFaEWmMNcFgz6VNI5ERfekD1ATrzdfR+zX71ipuFB3h/2Gsz2+/FVjH6rnW+pS
         JcVppimSD5hO0TUn9p4RaKTRuHIMlJKKEAr75kRgx7H2gi3e0jSHn/k3h8A4e255VKlA
         F7con8JWb4IEZmpxyLa23QUZwC5mzd9EhiP4q+J6WgDNOB6fdCahhTk+XxlqBAZCAvyi
         xjJaAdT/JPLjQ5JQ5QwqHuUK6VMMOk7jwpsUh/ikqGFvudpWHOUFj/AuIyxof3s1JZ10
         +2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693332466; x=1693937266;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHqHaW4KwaaV6z2LCLOETVk7sy6B6NzFH3inU6ye2zw=;
        b=KkUTAVdMqlSJ83Hr8GrNj0DxPd+GtkeindOqYpdrA1FdqQx4m3Imr6qeAkyXH143Sw
         ngEc/RRyPnTdGRpXSKjQDCZV2vPJ+UBy61b5QZAXYcUW/jEzRzleBriATsUtPiXYTHL1
         P5NwwalmCWNHtHzIBpKT5meGFxXd3nFGQqH5rO5arNncN9ohHSEJJPt/NSfdsj1VnHoc
         zZ4sPVkbJ+KqbCisEpU4X5lYVrtQ1/1CFCm5rFS+DBT03RlG3Yogfc0B3D3O5ET/H8K6
         B6cmvcDcdEo5x55ilW0ZWeITarpQPRqMyK2R3NpYcMR6YmY3T07S6OWFXbJpgracBqKk
         J7Pg==
X-Gm-Message-State: AOJu0YzeGCVCuCN5ipyKG1MSH7pLq9ja9mPATJ94Qgwb8ZLhZE0Q0tQX
	C6fXjDdB+qC6snUTdxIffbk=
X-Google-Smtp-Source: AGHT+IH6MH7k4ug7I5ZRMawMDH0VR/q8VbMH6uQ19gZnP7/JRPEznb631iIMkAIcHs3g+SO57yK0lA==
X-Received: by 2002:a05:6a21:6d95:b0:13b:b4bb:8b18 with SMTP id wl21-20020a056a216d9500b0013bb4bb8b18mr86334pzb.1.1693332466360;
        Tue, 29 Aug 2023 11:07:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z37-20020a056a001da500b00686bef8e55csm1384388pfw.39.2023.08.29.11.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 11:07:45 -0700 (PDT)
Message-ID: <ecb75e57-438c-fb29-41dd-5921899ee743@gmail.com>
Date: Tue, 29 Aug 2023 11:07:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/84] 5.10.193-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230828101149.146126827@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/23 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.193 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

