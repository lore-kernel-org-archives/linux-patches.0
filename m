Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1277BAD20
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 23:34:42 +0000 (UTC)
Received: by mail-il1-f170.google.com with SMTP id b12so3625014ils.8
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:34:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677195282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fC3HAx/KX1++Hn1KyFP5sOc2BiMUdLCRjvywyvE7h48=;
        b=hArscE9t4XpoYYS935ux1+IND3ASYeVW3+lFUDPMG6ZTtk0wg+CUC5tspXQCQgL0Yn
         zd//MNQcLGxjDka/uWJryIGbah9zAI+4yvj/4NwOKrXYsnrzJja3NXPJc8M2bBm+iZvt
         5mdU6fjBJwWT8Z0X18C04x2aNvrsXhcK5A7SI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677195282;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fC3HAx/KX1++Hn1KyFP5sOc2BiMUdLCRjvywyvE7h48=;
        b=HTctD4Befv6iyWNV4hIa3AJtKymIlpLRGuAJm8IEzd7pFAEtF8pXUDrc16kRyWhTpn
         rjqJlqxQttd6+Jsirkuv+4nQx8HbP6q9oxxGn09ls5awSu00zT+n6Zwm72anOSNUD0Ur
         XIRjqwTeS3jfzlYI+pISBIbrFbEYvGfbtSjIOKzeUcTOFKZKW5dZTKOTsXoDYFi+CEAh
         hygN+NWNuRuLn7YLGNDIr61pV4I1/TbXpGubhZNUwkKPZcfSqAWg8EGaqqKSuiDLMhFk
         K4or4aT5flv5wLlfEAJXXz6aEB97RjB7AThBiJ+FIhIiBFXmBYCbbdqecyqX0A6l+4gQ
         lN/g==
X-Gm-Message-State: AO0yUKV3cNzbMLDFX3OyuR/xgFPe9e9+Y0jofX0mIlKw57Hmf9cF3kMT
	uul07ZknKwJ0Spb0FxaVnvUwdw==
X-Google-Smtp-Source: AK7set8V6bYTfuYKvMYxOCxrmNoO8zZ1cqup75hhs2saykEZS2M4Hu2IxGaKCdi7AMZ7uYlH6cUTCg==
X-Received: by 2002:a05:6e02:1a06:b0:315:8bf9:53d8 with SMTP id s6-20020a056e021a0600b003158bf953d8mr9253021ild.2.1677195281985;
        Thu, 23 Feb 2023 15:34:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r18-20020a02c6d2000000b003adab954c5asm2173294jan.153.2023.02.23.15.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:34:41 -0800 (PST)
Message-ID: <2528fcc6-3b07-2506-6aa0-c0c4e5d61e51@linuxfoundation.org>
Date: Thu, 23 Feb 2023 16:34:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141542.672463796@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
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
