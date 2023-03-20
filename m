Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE3C7B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:08:24 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id s1so1368197ild.6
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353703; x=1681945703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=193ZdOl7SmXU5xeY7DK97JfDt7Ox2MJXhwHZJWEZhv0=;
        b=Ei4NGEDrdfbAmexe2XLEWXKkrttTK+tBPNy6BhvhSViPqVyVK2uDrXir2qrLOp1DCQ
         23gx0NOvw9hfNRI5xFN5P8n8a6a6jLGjyyH5mLfNvyKqF+jeIxCym7vz1VjGF91WgadU
         /lQQT/IiKeBbMuCKOjkSjA6Mo1DhbdbAR/0qQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353703; x=1681945703;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=193ZdOl7SmXU5xeY7DK97JfDt7Ox2MJXhwHZJWEZhv0=;
        b=nnajy1bmUebc4LAVj0a0vmDps1KFru9zdZZEmm/y8os3WkKEKdmoPjGA3xwMc0HSju
         GVOxvJLXyqv3Pe/hazcLtdoYgAoEO3s6I1/dwFgGrIiiaWXZIiNBMemf+wAuqFoLNNoO
         UGqINWoXX788WhkSdoPI0KUU/0fqhtmXaiMU3SUd8gu127MgL+6iZoOrsC52cAV2a9+J
         EBl7nrpiY8gwq+tcQLfMHU5JuyAO59tLzx7cdJGHCLISJBJ48TO+Ek9QGIs1QCrx6P/b
         6gK+wCElNO+LQxpW+Ho/ZD/0xlafgcnpIrEj4837Wb3MYJIoAwGIk6D2kKxofvWIY1Bv
         nuMQ==
X-Gm-Message-State: AO0yUKWqkOdnVPCkkieV8AjHahFRr7UGEtTSMrbov2uJbm6hMZ2WQEob
	UKQrhiOOc9dXkkXzScgJvpIdPg==
X-Google-Smtp-Source: AK7set95aLMy7g+Tk9W3WMdi8i2FWNkdvVdRafgY7l8+4MqpL62RhoOp8c1KBTH3hwOZXZnBezefnw==
X-Received: by 2002:a05:6e02:12c8:b0:317:2f8d:528f with SMTP id i8-20020a056e0212c800b003172f8d528fmr817655ilm.2.1679353703656;
        Mon, 20 Mar 2023 16:08:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p17-20020a927411000000b00317f477b039sm3154582ilc.4.2023.03.20.16.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:08:23 -0700 (PDT)
Message-ID: <2301a5b9-bfb0-07c0-5c1e-b92bbcd286a6@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:08:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
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
