Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C4EA1
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:51:45 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id q6so6197619iot.2
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 17:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3hETqS31jtez34Vx+PJneRBWTwEiHVpbkTOh45XfvhU=;
        b=PSWpq600DFbrfyZl5Hz3u2UNcx/xhDiKTnVJrBfY4Rlme0afK7zmljqwzXOKszhF+T
         atptjPitVtPkjZ4+9GJyOagquRRUu5fgutr84qZlkjat0OI3HTpHnSJ9213YTssUbMgJ
         aGdc+ekbcoE7sUSlh7eZd4lDUrQHeekrpAmsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hETqS31jtez34Vx+PJneRBWTwEiHVpbkTOh45XfvhU=;
        b=v6zBNllpU6UJ0EdHhr5LQ1Z6d5mWW4RgUN4JHVeMR8s5gDuG4VeLvpceyiNpQ/Pccz
         jSDud7ORM0G92IcN8qngHN9dKNMHEVDq0EG47YrP2izvvIequZdBaYyGBQFOXhUSKUCG
         pPLdZWTDWPiAJl7Sj7ngjOW6aI4BzRGOzo9DQe7VeJHYGWdMKojMs6vTOTbUchH/6O4d
         UWezC94eyD3xhtHtWxCvqw2RrgYPMlqQIgp9EuVIPNVGJ5XXv9BROvaOSheSfNQNKEuH
         ZJsi51OZ0uI0DCI6/BgwbZwl9v5z6SwmGJg3CGQvm0KqZUEyQSeaGhtwIDmB8FknKOhC
         wE9Q==
X-Gm-Message-State: AO0yUKWlSVmhb/cS+7JFlO9SmuoOpgdOICH/1aFB+wabmh1jyfrDQdyw
	RRBMmk1TytvwapbO0m0zzZ8CWA==
X-Google-Smtp-Source: AK7set88HYv0gRNcGf53HnxRXgV7y8VJpc2bcM3djSJoEIOCR+rTD9Nfpr6PfRUtvbgk0XaPR64I7w==
X-Received: by 2002:a5d:840d:0:b0:74c:99e8:7f44 with SMTP id i13-20020a5d840d000000b0074c99e87f44mr5158648ion.2.1677721904307;
        Wed, 01 Mar 2023 17:51:44 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k20-20020a5e8914000000b007407ea5d07csm4226997ioj.51.2023.03.01.17.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:51:43 -0800 (PST)
Message-ID: <e62e64bd-d4a8-a2fd-ff85-27d85dbdaa5c@linuxfoundation.org>
Date: Wed, 1 Mar 2023 18:51:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180650.395562988@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/23 11:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.275-rc1.gz
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
