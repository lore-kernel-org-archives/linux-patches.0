Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C1C10FF
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:04:42 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id l128so2626455iof.2
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pEiHHmlJSzJPx9D+kEWk3DrlaKBm5JKbFkxKskYpgM0=;
        b=OOrGrY5SzRYWa2GOMolAOdtd9Cg9icVaoG4FLxfREIKbbZj6AAQxqLashDieu2Re+e
         X1Dfn8mHHYsKxi9pQU4vobVG58U/fzYu9UzXj8Jrex/grJAo5aLEtWBGTYTfZdGA+7gf
         zv1diuthFKOHnGa0V3Nc6Q/dVRjHET/eV2gQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pEiHHmlJSzJPx9D+kEWk3DrlaKBm5JKbFkxKskYpgM0=;
        b=K8sSyEBiw+K7H/1BR2tOCV8CPc16Xtuq0hKchOYxC0t2f/mhwc0D5D02IrA3a49Lus
         pZWaZAv59Hv6u94Zl+ndJrInflSnOVMsIb0GpWzUCZFdeRKGNHAfeFLqEVzI2OGs4C8/
         efWfT4LdSngU8u96NOXoCcDY+LHW8EKBDgzwuEGXiCxgji42SguMM82rKBJKPl5NPoiu
         dB3cGNg9QVJwN4I9zOGysLAbi3rVBW+oBUGvIBAeQ0FgXW0cAiywvfpqcqSRT4JxxV/a
         ZBtxRuo/xT34KdlZbof1JXKx4kAE5GMcsDl9AUU6j3jMqPtsK9j6bzboxzqzXqQeggoV
         9sJA==
X-Gm-Message-State: AO0yUKW7n8WFFUdDuffMMO/4AnwQ6cF8QnrFAQX04+zoXYWxv0ZPbJT7
	ZibRuhEqZuThvA87S99hj34lew==
X-Google-Smtp-Source: AK7set/KM7BVz+ZipCrscdb43Q3Z/bGz4avXrcHLm/gozrthyz0wZme6CloNW83PhjeyFk4tEOagjw==
X-Received: by 2002:a5e:8307:0:b0:707:6808:45c0 with SMTP id x7-20020a5e8307000000b00707680845c0mr8256875iom.1.1675472681339;
        Fri, 03 Feb 2023 17:04:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c15-20020a02c9cf000000b0035a40af60fcsm1340823jap.86.2023.02.03.17.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 17:04:40 -0800 (PST)
Message-ID: <8ec8c5a0-8935-631c-fb44-864c6d1b9fa5@linuxfoundation.org>
Date: Fri, 3 Feb 2023 18:04:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 03:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
