Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D022101
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 18:33:03 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id ml12so12906794qvb.0
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 10:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMY7PupaY7AZJjDpU6LlRsSZwx2BK6otcOqvPzvh8zI=;
        b=HalMxlAJq4g4Sfsn6Fa0+SPtqdbL7YjWjVMQ+bOPuGWhhi/TIWdK6eD4KAHxW46Xil
         hXI0SOcPYPzlgVBVWY7VmHWm8rJ/M/eHHPWG4/ZIVtOO1yfQMp1Ljp/9LijIk9SyD8z1
         kssi1QU2S+ggTdpjvnfU+fum1viU9REywIgc7yESWLCK5yVj1cDLNtsIlOh7hPfkU9Mz
         ej9OPWvt0C6HsPwFAhuYLH2TDX+2RqUCylAO4KvWPwzMylx+jRiOFRP+vSpJQK+hOnen
         nsYfq6P5bsD7X28/26op6khhvHiC8kBGxyPA2QNzFDzHggHKahZpCA5clNH2iJjDlbuE
         6ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sMY7PupaY7AZJjDpU6LlRsSZwx2BK6otcOqvPzvh8zI=;
        b=4CXQGwgP2X9b+U0OGK5u5WKc6dEhaQhXcSnydX6YX6oEt2ZtEbGzA5XAsA96NfNokG
         x7Gk9ZdznRq2AhxNh0VSVECuDrgRRmfSFBbHMi+onisQ6C0aeWZI4IokGFPWpe23KkHs
         wIQnE/TlhModMUxEn8+qZE0DfBsgLjI4uXFh4fJQsmRUfgNF72/BIazntCrQtUtrsY9i
         jjJdMeyZQi8KoPE1G2NJqTgIhcxYCVyJdU1FtfPHTCQXZeLwo5P6RzAQAKZHD+oqOxTW
         ihMTHUS6VdQxyQ9kp7hXn2YlmqcrHjp3BkwG+KBN9/AgeKtYOvKIvVC1wbb5zEsG4a6Z
         qA2g==
X-Gm-Message-State: ACrzQf21uZJcOhDGLr6Fh8COmDi/9/bTUvXkNXEY2G4HXSqfnw6Dc+Ob
	Bbiq493MGP4mY8NawX9L11I=
X-Google-Smtp-Source: AMsMyM7izbtZBEaCtvBqW1849eyHVHe6zFq4aajTAz/1C6e4+RnYKL5+rBgUBMwQat+Pz1t3emfvDg==
X-Received: by 2002:a05:6214:ac7:b0:4bb:61e7:18eb with SMTP id g7-20020a0562140ac700b004bb61e718ebmr55694952qvi.55.1668018782275;
        Wed, 09 Nov 2022 10:33:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bt12-20020ac8690c000000b003999d25e772sm10117236qtb.71.2022.11.09.10.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 10:33:01 -0800 (PST)
Message-ID: <1279d213-93bb-6faa-5697-f56d6d8aa293@gmail.com>
Date: Wed, 9 Nov 2022 10:32:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221109082223.141145957@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/22 00:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested with 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

