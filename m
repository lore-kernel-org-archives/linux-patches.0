Received: from mail-il1-f195.google.com (mail-il1-f195.google.com [209.85.166.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC5525931
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 20:16:10 +0000 (UTC)
Received: by mail-il1-f195.google.com with SMTP id e9e14a558f8ab-348dfefd2d6so1415895ab.1
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 13:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1690316170; x=1690920970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PX7aW/22nYeI+mcs9H1DmcYS/0v8J0ILXVwKH0siU+U=;
        b=L6gBSwdNn4oeVWaIoXQeu3c8VyWxxI4RiYrg2vTatqt5GC5y5sd8H4Lyif0Z33tHQX
         x/pEzjAjiWmXykKukxfq/xNGfgFpvzv+E7s6C1Xa/F6CFUPvRquP6vXBTP+UEFRBfy7h
         1L8g21aozgirlY8rCz3wAef+bA6BwA2QWe3pY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690316170; x=1690920970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PX7aW/22nYeI+mcs9H1DmcYS/0v8J0ILXVwKH0siU+U=;
        b=jshcITkeeJ+eHej7mXRo58PCNpCrx1P0tbs6v3b+P5ZdFE+qM5lo7RP1J7GRGBgUd2
         kbw6lUn7j4oUvYy5Zf0QXWrWltis/auZ0oIVRd5SIFN4drL9jj7itWuZ/9yVYbeMUH75
         rT0S4aVoTeoXMWqh86B1yVqJC18B1RAZwPKbuhwTmuu2/nN/SaQHCcMgrvrgZutbk/qU
         J0dYmmCfsBJMUNoNMxdHgvuhs4AR3Odvm70d75CITggvRQxSPonGwwJ6jIqKxL6tuqmO
         8T/Kgk7oqO5cc7eksRdtauv7Sk9j5wdGl+oKFq5104nitt79/UD7dhyOfpLdTLWSHF0J
         IfYA==
X-Gm-Message-State: ABy/qLYa8w4FhyPbHP0YBpYwWXlXkS7j3QEyKDV3juBmx98s3bfHci4Y
	zufES5HbFhOjGpj57TiiKS4TqA==
X-Google-Smtp-Source: APBJJlEyfP4cesFT+wDNOCkHxDbidCbC3N2Xq83CBMkmTCGetKomjdP5lW1CYu4pagrsuDnlTMHVaQ==
X-Received: by 2002:a05:6e02:4c7:b0:346:3173:2374 with SMTP id f7-20020a056e0204c700b0034631732374mr114617ils.0.1690316170135;
        Tue, 25 Jul 2023 13:16:10 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n18-20020a92d9d2000000b00345950d7e94sm3924630ilq.20.2023.07.25.13.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 13:16:09 -0700 (PDT)
Message-ID: <c7578f9a-62e6-dbfa-7b3c-b33d9c5368a9@linuxfoundation.org>
Date: Tue, 25 Jul 2023 14:16:09 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/183] 6.1.42-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 04:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.42 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.42-rc1.gz
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
