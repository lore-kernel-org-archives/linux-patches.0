Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4668320C
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 22:24:52 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-32e74139877so206435ab.0
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 15:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682720692; x=1685312692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GSa5C8E2SSwvtXOZwEpISMIP6D9rG0L5OGPU9rvOevs=;
        b=ajL+QEPgpYNE/ZKmEbXLNEHYE3KPm8MVfR7XdDnwFhRJFsEOfi/DpdnnO3bfMoOZhb
         H/yVjchU3lGio3YeOP0TQT/6Md2CF0SK0BUrvnhTurm9WFyt3XMYDm7+im1+OqciNboz
         cgvQWNMdTS6vnqe0eGciT5uBpqYhSs7qxaBGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682720692; x=1685312692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GSa5C8E2SSwvtXOZwEpISMIP6D9rG0L5OGPU9rvOevs=;
        b=Bxljof33oCiJpl665BFzRou1x3KqQcPsS5V+8GRxLjPEOfeyCQjyuNNqzCDr48uXMy
         lZGWIVyl6x+UUe1vfU4jkGLtNp/pQCzP64pmwX4sAG0sCm3HPpq5uNdljm42p6+gnh8r
         w8IVjhuTkpwMFZoTtBKB2jbBkLnY4HFXAmReayoaxqD/onzVT1VdqE81gg5w/1ZNjK1Q
         Bz5RhZ0BiFNpGexCJnY5Ec6TYubjJaRq7JzwooTq74QSD48qz5Gy/5lEYE9z2ukkekRj
         RittbaY608giQmtyvTllEH1NfrG6AZu8PcF5glbU352FrNPmEXRsYQt0aV3rxcdIpXBZ
         V4bw==
X-Gm-Message-State: AC+VfDy2YdrkZocqUug2G8NSH3L9Q/JLZ3OPgaw3+a+ZDWmDBMjdf3RW
	NJDxlMOOnR9twTpMi3EASwjtIg==
X-Google-Smtp-Source: ACHHUZ4Ja6I1jRQPtE/UAHztRHGhUOjd7MUxetmgc7IDRvXMw4BgJ6SErt1GVfNc91GwFa7gA1NpZA==
X-Received: by 2002:a05:6602:3425:b0:760:f7e4:7941 with SMTP id n37-20020a056602342500b00760f7e47941mr3561634ioz.0.1682720691718;
        Fri, 28 Apr 2023 15:24:51 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t32-20020a05663836e000b0041284223319sm2772267jau.88.2023.04.28.15.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 15:24:51 -0700 (PDT)
Message-ID: <5995e300-1b3e-eab8-a258-beb667504cec@linuxfoundation.org>
Date: Fri, 28 Apr 2023 16:24:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.3 00/11] 6.3.1-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230428112039.886496777@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230428112039.886496777@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/23 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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
