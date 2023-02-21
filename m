Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A4A937
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 23:48:22 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id s8so2434244ilv.10
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G0Zj9qsPEta1dJVgHoolt9moRX61OkvAGX+yWAl5/d8=;
        b=JPexqCfts0gatHhRq6QS/9ZpsZt742wfnp5Ki/v3rA08jkIoakkD+lnr12v8IPqmBl
         8FOEH2meNj54mRjkPBNsBrxHf7AQJtTqzqnpqViqX+Md7tWd2VVGSRUugGFifiSBVmyf
         aySYIEFJZQJM7Qndr2CK7nYS2gK9h3Exw3o8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G0Zj9qsPEta1dJVgHoolt9moRX61OkvAGX+yWAl5/d8=;
        b=eWvz6xC0mkPBcD2y/cAnXKMJnIxvha98nEzd8vNHGamuyRvknwy+TuoPyXGhnM+EeE
         1HZigj7bYgjur4AdJL9jBI3s763TTtvy6u4Q4/IgrGJKBHhgtlHNyayYIxDLK7Jei5Nt
         9nBy1Y73UtT2ZyxRALikgurScPyLcCbP0sXN1kDzMBZdEHYCn4UY1PVVK5S5x+Pw/0if
         WTdM/L0txRu1vacTu6Lx2uRMpAfv4TO6G7CyRyazz6sj3UQVzkUgon22jgWOcHaslxKU
         UG3KmR6sEYuMq1tvNTngjOq/4Qx/H5LiWlaoJ5AWpb1/t1zlcrNBSolAZSkb18cfQVfm
         KeZw==
X-Gm-Message-State: AO0yUKXxXSzOdE8Q6UVYzRUxH6u8qaDpu1pWGvSWxF8YhccsiraJVJy7
	frAcqXsuQAyvXO3z1vg+DNzeUQ==
X-Google-Smtp-Source: AK7set+yh5GqjoklnZ8UoLLM6gr18wbzYtUm8b2tDmJNTTOp3AoWYpXYCp5gW93z7YKEELn7hMCF1Q==
X-Received: by 2002:a05:6e02:2165:b0:314:1579:be2c with SMTP id s5-20020a056e02216500b003141579be2cmr3477310ilv.0.1677023301911;
        Tue, 21 Feb 2023 15:48:21 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k9-20020a02a709000000b003b443977af0sm54720jam.7.2023.02.21.15.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:48:21 -0800 (PST)
Message-ID: <0b0f9456-85ba-45c7-1466-946414a28e80@linuxfoundation.org>
Date: Tue, 21 Feb 2023 16:48:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.95-rc1.gz
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
