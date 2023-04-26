Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D51ED1
	for <patches@lists.linux.dev>; Wed, 26 Apr 2023 00:24:07 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-760b6765f36so15003539f.0
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 17:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682468646; x=1685060646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xEkXql0myiwlSwKFESLcNnwEuA0avJTRSJrSoXaJZYo=;
        b=Na2/3KFVLVVwJ5u/up4JIUCZtHMgs5azVk82HBr0KUfunMnOFf1FogCIIFbr3QetTv
         pmjfzan0dkSUFAZb9a8nluijP9k0kqH+0FuKLqKYj7HKQw9bDM/b2rR6lYSxW+YTSvlY
         Tf4Uny2BQvTXS2RGDdOHmjltvAquCTsIHJtwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682468646; x=1685060646;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xEkXql0myiwlSwKFESLcNnwEuA0avJTRSJrSoXaJZYo=;
        b=iB/R+W0PsB5t0XSmQsK9y8fET+QO3vtiRNSDPNkKWjjSPom1kTi4MMtkzhBga6JmQ5
         2klE12ecOf6VWe/tLcKezD1vQsmzKyj0iLeUtOZwLTP64mXQ4iJMOyrsQoa4Bx7SJqJv
         sG3UxEY+BitSJwWFfJLIn8ls6FvigfPIWcj7q0lbrj+hLcCPVNeIz7FLOnoJ1fiuihdr
         WjL2BOs4VeEimoVMTCs4XizfQXfZWhfR8e61xnbGOYkcKwZWwKS5mBDmi4twiGKs+ygO
         MMWOLSKq2pYgDMxnTOR/FvZeOySU6C3pKPBv6lfOyxEUmjIX8c3PFD5hdfg1izz5S0lD
         aLpg==
X-Gm-Message-State: AAQBX9eeIJOEcJj7TX/6jsvqPrY5HDj5r1/U1as9U7/LxN1opkptHbKK
	CTFh+oKJffEKAZtXjB9qJ8ZMPA==
X-Google-Smtp-Source: AKy350Zz9fjE7yr8crVz8Do6VigsWw+sdnlMiEqHRz9MaXRVBr+gnwM3rgJr4LeEuBrEHNhSLAqVdg==
X-Received: by 2002:a05:6602:379a:b0:760:f7e4:7941 with SMTP id be26-20020a056602379a00b00760f7e47941mr10661654iob.0.1682468646567;
        Tue, 25 Apr 2023 17:24:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q31-20020a056638345f00b0040f91a65669sm4500839jav.21.2023.04.25.17.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 17:24:06 -0700 (PDT)
Message-ID: <02e6ac01-8ea4-320e-8d01-9019dd103d68@linuxfoundation.org>
Date: Tue, 25 Apr 2023 18:24:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.109-rc1.gz
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
