Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B383190
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 02:40:36 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id n63so4467102iod.7
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 18:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C11bscbOmfUbhUvDY9IHufEbXEW6Jlvs+hg8vJ4XBWQ=;
        b=f59DNAZDv+rfnYq/BEXcLH/B/MQhjC0omavNBDw+annfUJyQJAWvnSu3+WdD7NbAw8
         tAfq8Fi8S/PUUaEfUc3hXJ20OkZcfFsGgKwNhqHDNrj9uDU8K/Qo6oPreqvdCrtJBy1h
         9FFZfq9H2BaFX7onn5O1jYE8S6iLWzSjwHi+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C11bscbOmfUbhUvDY9IHufEbXEW6Jlvs+hg8vJ4XBWQ=;
        b=uEKXFxGMVsXrRSOlGV9Z3PI6Hi9ogtNe3VJxa4yfjmq7lXwUkrlfBApU1W3ZlYMZHx
         JTVgC/6R9w6rK7qgVYJhzOUGQTVw9dTRZxf6wlKn3k9tHGGN2N2xG5QxkOJCVt0AO6oN
         xoBZITR74Zk6z4+Z0s0lAQMiS+Bgon0rrjtZkaNrdVKYsCFUJRG2QNLOwN5G1bBZIkaD
         nNUhf7zeSdxW13tVgvg64lRvd3R35HvNhK87JkKzufHFYPsnGPz8i3YLef/61RnwAAtr
         hf+sqCSj56v7kqwTY6T6ao2Q8L7B6Tqo5UDK6IE1//IVdorXQICu3dkVsU5rD222yKQe
         ugTg==
X-Gm-Message-State: ANoB5pk2yLOBb2mp9A5JOKTV3wLmkKJ3JL8lua8PlMGnfwkN2yjP/+Nl
	jXg07mrWlQR4g0TsvclT8uSlhg==
X-Google-Smtp-Source: AA0mqf4YJZkgLRAm/eqUjaca7IMExUKaYAKkSir++EWeQ1/+b3ePm4WZrqEU/RxxN00PMn6NhEQ+yA==
X-Received: by 2002:a05:6638:440b:b0:374:fbbe:2da6 with SMTP id bp11-20020a056638440b00b00374fbbe2da6mr19160646jab.163.1670294436002;
        Mon, 05 Dec 2022 18:40:36 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p18-20020a056638217200b00363da904602sm1549786jak.13.2022.12.05.18.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:40:35 -0800 (PST)
Message-ID: <91eadab1-92bb-6361-7c43-193a8e348045@linuxfoundation.org>
Date: Mon, 5 Dec 2022 19:40:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/153] 5.4.226-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc1.gz
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
