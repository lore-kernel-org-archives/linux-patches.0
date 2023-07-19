Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BD11FDF
	for <patches@lists.linux.dev>; Wed, 19 Jul 2023 04:59:04 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-997c4107d62so359529766b.0
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 21:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689742743; x=1690347543;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j73OOjIeRuMj/hW5XddSt0G2UN09Sqon0o8YRkFJAmE=;
        b=C6QsD5aFC42DjuaxIMMgTh6eb2ylX+i9k0fqTHh1mBmXoXrUwrtenoUsM5WkxgvoxY
         RjO4pCn8WHKV0vP+DPLLfBx4C0hFK4ReFAnhfLdILBfv7pQNHb4prj/XJlI/UrOnuFwS
         xRPwABovIWAL23UZnxMI3M7Sz/7slWkncB6uv6x5MLPOUKJu4ptPCqhB3qhx2ygvtSxs
         mKrnP+l6qjhf4OKRkZX86uCo1eXBdQ5cju/q4PcKM7nywHNDpy0078oSc5MZXZVXd2U2
         dl8tX4lmLxgKGOGjFiFhx7Or0jAck52dAxnd8pFDaWtfjlIY4ELLgd3Q/oomqLVJrBAv
         LZPQ==
X-Gm-Message-State: ABy/qLY7Wy/Jxdq74LeJOoj6MYCYnGhLqM/DM+uNRXZ50nF4ahA+3fV6
	KuS58NlpXKqjoAi43+piPmM=
X-Google-Smtp-Source: APBJJlE5FBhwnn+ttSshK5fDq37w5f5hotxC47JdDOGMCuEPnvDrPixrpDDiWdU9TUvzvExhUXBiSQ==
X-Received: by 2002:a17:906:2208:b0:993:f9b2:93c1 with SMTP id s8-20020a170906220800b00993f9b293c1mr1532542ejs.9.1689742742765;
        Tue, 18 Jul 2023 21:59:02 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709064a9a00b009893b06e9e3sm1775731eju.225.2023.07.18.21.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 21:59:02 -0700 (PDT)
Message-ID: <29a50d29-67f6-8b18-d0bb-278878f9ddac@kernel.org>
Date: Wed, 19 Jul 2023 06:59:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/801] 6.4.4-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230717201608.814406187@linuxfoundation.org>
From: Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230717201608.814406187@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17. 07. 23, 22:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.4 release.
> There are 801 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.4-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.

openSUSE configs¹⁾ mostly green -- arm is still building (our build 
systems have limited resourced due to move now). x86_64 runs fine in qemu.

Tested-by: Jiri Slaby <jirislaby@kernel.org>

¹⁾ armv6hl armv7hl arm64 i386 ppc64 ppc64le riscv64 s390x x86_64

-- 
js
suse labs

