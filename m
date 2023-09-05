Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AD3DDD2
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 20:55:53 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-77dcff76e35so42058839f.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 13:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693947352; x=1694552152; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6/BDBNGJ+Ts/N2mHyKONcpknFcVfprrEzRLax22my7E=;
        b=VKwL/AYGYMSDyiweir8qThpBh8tisa7EtQo3cMos/274sdZoZ0Ne6iJP4s/9IyNIxe
         WNIjoccy/WJSb7oM/f0YBP9tQ4Qe8/Yn6kDbxsQiUjCPn81FKTyipiWj/RF6uocoWJDs
         3gy6bnNm6HzigOndylihsHSKlojjUXTYFUlvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693947352; x=1694552152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/BDBNGJ+Ts/N2mHyKONcpknFcVfprrEzRLax22my7E=;
        b=LVKi45Exsqd/IGokq5cyjr9U3qH0ZI5bfP3+de8ga1+F0vTZGFlt8vUClAMwvmxKKm
         dI619cUq8rQ9s6mchlsg64eTS1xp69j6RIR9s/B5ow7IETEz9DqHc2qrr92aJSHW7YbX
         Wz8JRC6pWXQC8l+OapW9tXgqM8+nzXtlSzg9U1WU6tWxTQfp9y5jQpDqUr/esqRUkQOq
         2zHEz7uFLxCtSK1PZYulkSkJBN5tGwXm6BnHKjesxcO1dnaYmgAqlvspCHrkFD69AvkC
         jnd265GBRKKRB9EZiKyZDxXNlcdZgmOweZcZ4JftqvKmvhQiuWLdrzfFdPP9eG/iAjw7
         Rlig==
X-Gm-Message-State: AOJu0YxFEOKWCJz7MXGmuLYAtn6aiUQnWLT4tfAELyiPpIZ7cBGr2Enu
	njuXuhVoYJZo1iIJ1ILVXgWHlw==
X-Google-Smtp-Source: AGHT+IG/gd5v9g5acFnEDrNk2qmxuZ27+UpxRK5gLxlSb+8t1or2tF3kHYKp2opEmEbtB8dWqFPjZw==
X-Received: by 2002:a92:c087:0:b0:345:e438:7381 with SMTP id h7-20020a92c087000000b00345e4387381mr12704337ile.2.1693947352511;
        Tue, 05 Sep 2023 13:55:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c8-20020a92cf08000000b0034bad471d1fsm4404809ilo.3.2023.09.05.13.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 13:55:52 -0700 (PDT)
Message-ID: <4ea02951-3ee4-65cf-4536-68bc281701c7@linuxfoundation.org>
Date: Tue, 5 Sep 2023 14:55:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 00/31] 6.1.52-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/23 12:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.52 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.52-rc1.gz
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
