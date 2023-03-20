Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F3D7B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 23:14:29 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id r4so7311093ilt.8
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 16:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679354068; x=1681946068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wp9Ma1tXiomJIM+Ccb5K6YpKhjZGXmIfWaW8gLzKl4g=;
        b=eH/EfirbNVoFw/M9nI2MrjyBdBoXhcbFlHWxVsVXqUY8yrehDxzPmuj8CKfDRNa742
         C6bxo9pxEPt+C4Ee53vmachwZeurPtp0T0zlHVplqSTvFfBsW5+OcKGBn6Qr0f8hRejR
         y3QZcCEwacgWY7J0fsC4sB50hsYUo+LMn4pQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679354068; x=1681946068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wp9Ma1tXiomJIM+Ccb5K6YpKhjZGXmIfWaW8gLzKl4g=;
        b=AJ3ziB9zrjdN0q5gZ+xf3F4U2lqOobO7eJOzBtI5Qp/UYRbSyR1rSg7KHEO1UvPkVr
         zXpKJwdHTBS3V5ZJIecgTsbRAaQHofhhwPpT0hMZiJEli8N+Re7HqOjNJnFc8vK8ONjE
         CV9nRhqk9eRObLn2+AjZjgcvtzpz4TPtmvZYogTOn4+oQoWX1H470OM7jY4UpYy/JIrm
         42YMFXHV8ZvJ9xHEOxbuhfSUrAcA3ozyQi1a8aFsZ8rHwDY0MG0BGpYokJ8RqceJ+x6W
         aQ6XkfLQmpEgmxUCmQVJiN5sQbpHDRCNlVDz1eAJ6/Z2EnmN17s6u2rsp8H5D6r9Pcrb
         +ZuA==
X-Gm-Message-State: AO0yUKXt8VUpLoQl1oBb+AOuUJnfCkYPZh+OeSP0lmn2tITLkSZtRGqd
	Q5cZo7zw2dQV5EXhQhg+GE6mcxYzpLiDPf9f5M0Crg==
X-Google-Smtp-Source: AK7set+I3uVCBqzyU8Lu237ZB3b5GNNfmxHdjKmghf5RbckgpSFCEvPqT6Fx6ORVGok9AqogCqbO+g==
X-Received: by 2002:a92:7b06:0:b0:317:36d8:cfc6 with SMTP id w6-20020a927b06000000b0031736d8cfc6mr564522ilc.3.1679354068654;
        Mon, 20 Mar 2023 16:14:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ay24-20020a056638411800b00406633b7dddsm1593250jab.68.2023.03.20.16.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:14:28 -0700 (PDT)
Message-ID: <79ce03fc-84f7-b343-5054-2e7d6533107b@linuxfoundation.org>
Date: Mon, 20 Mar 2023 17:14:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
