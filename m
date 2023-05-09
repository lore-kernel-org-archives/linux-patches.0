Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74578F9C4
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:42:35 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64115eef620so44270776b3a.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683654155; x=1686246155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hVrRM6t63wczk3TNwqKqHozYg9+Yq707IC/VhQqlcDM=;
        b=FVIqwJD5INIUupnJgMP/w49DfVU3UW4lv8nZZeOoLApCRAgKZkuXq17x8JD72FIsFx
         MKMNVjOUPwmu/chZyNNBe3q8BkfwGfMQ9QwS3NOcoae/F8mQ8aIbFvLxE6AOEk70+VJX
         NEHeEXDG1OBsjks9YJcL39Ql8KSEdNQVNJ8BaB7VIWFkgDwKkPYj1t9+uk4KLUqfbxCI
         IEZUEld9cJ+oiooWHUlD8uYx46fPcIDfpfUKhP58pJ4gc2H/WUCt79Fa9URpOY4Gr8Q9
         e1b3fX+UrdoAhlqOgG6yy8sN3JYnYhpWqsWszJYkUCP58z9gxrnLRL5RpQ4dNQh6wVT6
         p/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683654155; x=1686246155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hVrRM6t63wczk3TNwqKqHozYg9+Yq707IC/VhQqlcDM=;
        b=RUE7aPwEYGHP2JVyzRmoC8dYbiLj90P/4lPvpnwtJUzh/1HWyIMNn0AHo4B9MHfnC+
         NVxqfoN6PJE7GilxwEh6pACDCrNSqI1vCwZFQyqoNSdVipNgfaYQPU+u7n28VYlu/o59
         PRqw+xQ2rmrFL0yAbJDglZQ4+x3p7nXDccXSdiKuOuFHCoIMBTeY87jldYBwRFZMyKyi
         giUu0dzkexQOMbo0nTpBqmK+JQoHU9F0zYkM7GoSUsxu5GU21Qsjhei28ueTBWb3hjbU
         GYB0DGIu4qMj1G1s/U2KpxE4/H8hvyoOG9mhauRy8C9cM6/dbkPEOzRppDpxwS/ZZKqT
         aq9w==
X-Gm-Message-State: AC+VfDyQIqvetnCHkFqgs1a7j3stfheM/lQ5ammmT0oC0hdSXiNvMDer
	m345e+1VrgeQEQ1xR+IWtaY=
X-Google-Smtp-Source: ACHHUZ7hW1T9SKfm2LfZZwC5xAIrgkt49N5GQM1NQm6WPyKlfNYq/Pce+GS+QQVN3NxdhGWMVlLrGA==
X-Received: by 2002:a17:902:db08:b0:1a6:7b71:e64b with SMTP id m8-20020a170902db0800b001a67b71e64bmr26249165plx.15.1683654154619;
        Tue, 09 May 2023 10:42:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g7-20020a170902868700b001aad4be4503sm1903387plo.2.2023.05.09.10.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 10:42:34 -0700 (PDT)
Message-ID: <3f5db313-496a-71f5-7970-be7a112b9959@gmail.com>
Date: Tue, 9 May 2023 10:42:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/662] 6.2.15-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230509030701.507375024@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230509030701.507375024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 20:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 662 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

