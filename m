Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DD415A7
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 00:37:51 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id y205so2432402iof.0
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 16:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nf79i4kFYNjvkaViMxUA+Wevatn6h1yiqkK+1eISKPg=;
        b=Mn7Kiyli+tUpKDurXXj/ueqz+GrUBetMGrndmeWHOKhlDtaLi0LeOnW6LZVwGG/rPm
         gc3UhuUyu1pVmXRtEM7mtrHDIHlmXLM7AZ59f64J3BTUvBKRizFj+DXCtHVV+fHZhLsj
         KwBVENeEGY7Rdvm+PQRuoT2ovC2szyV5Hs4Kc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nf79i4kFYNjvkaViMxUA+Wevatn6h1yiqkK+1eISKPg=;
        b=cf7Fr+BloJyUe07qR30t+X8ueGHaH8tpwYQUm1eZ/TEdbiEVugd6c5KwIkQM7yb0EA
         8rVAsddHm6pQxEqOiOhRVFOijBr5QkfNrQ38ERmP+wKb+jftdlok+oOZX6Q19a/vjmYe
         kfLCVLR5TJHN8FkKxPwrXXb0cXS5A/e81LhL/MrsS+c1mRrsgb1+DKdyCCXG95hsKnsU
         4OJMaMJ/QqS6NtcUzo0B+vB96HH54xZO64MC8Uy0s6fxYcXuancTfh5uXRXzSyYs6T9+
         ilrAQd3+V15O2gcpX1IooM2IUzXibv4QPq1gnjf2WNHla77JSqTsBFxAJHtEMvdJbIFe
         e5pQ==
X-Gm-Message-State: AFqh2krCAYmo1PfXhZS1Iq8iCc0AyfvvEiO0xXPb1/eP+1HMqqcoK4nq
	5IX0DjOAO8+TulkPf5RPbpqhJw==
X-Google-Smtp-Source: AMrXdXuqTgeYvvMdXOJyAWi71olRqUT1f2Med2xoF4IWRl+GEC6xHU97LDGYEk40HwHddJlFxCBjMg==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr10498373ioq.0.1673397470566;
        Tue, 10 Jan 2023 16:37:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z10-20020a056602080a00b006f8b45e858asm4561046iow.29.2023.01.10.16.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 16:37:49 -0800 (PST)
Message-ID: <d5509667-da54-d5fb-4258-8f7931f10bf8@linuxfoundation.org>
Date: Tue, 10 Jan 2023 17:37:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/23 11:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
