Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8BB386
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 00:01:44 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id be16so4259110oib.0
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 16:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678233704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gp5ksp/tysG8+d5KykH4cu77+0Kh4J8KV752xYRk5No=;
        b=c08INiNViJ8tYRuoNRc6bC2exreDd5cZQxqOTujemRAGZymzjp8mlmmfcj3w4/19k+
         OqUNrM9U1TXrwZ3cLDOJqxTtYpWZmEzUtTregTOFVnkg2JVgR0cGknnAFuOSvuqK+CHL
         bhH3nV4efgkLtzMu5NDir5GJcTWlMcNK7QzzsitPgjjBEhFCEGCCHg5bCY1uoXp/abmn
         xz/u/fZbJAjLe6zrf6Z+dRmpF+mYKa2z9j1gJbFeHPWxmX6lR2+6r9XrNfiYbmgSZKTM
         8UwzCa1n1fVgOcxfpXD/2NHRQRZcg+UFsSUPE5zRawKr8ZTMHgwpsWZtPGw1KY5G4y3x
         fswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678233704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gp5ksp/tysG8+d5KykH4cu77+0Kh4J8KV752xYRk5No=;
        b=RDR22+CzLbSjVpZvQeEOCNAx4cVtXT/li3HoXMQP5lFi4mqxqy6PI6/+D7xGjV3Yww
         xN+7dZwoLhKi1djccpHiGvE/xRMHT8WTkfO1fDnlCITxMCQYnX+nxjl4u3iXtY/VtHc6
         FIfutu/ibXDQrbWTEHKS+SY+4NHFgUMvdGBjWZJGiiNSPR+0h1Yh2BM9/FfGvqNIRLvv
         QpkBG0niwUrZm5doz3ofLcU3f+tumlQlPezuzAYHaJcQZAuvk+XCR+C9epAoH7PsnCDm
         k4FKRRuD1Sd50U0NPg4plE29ghrn6IBY/xPnA2mw61c2m1dK92utNUGgOHaB2pZ1+B9A
         i1sg==
X-Gm-Message-State: AO0yUKUztsmFK6dMVxHBqM7HPeYKT5V44gmsWmwJW2PIbieB76neFZ2d
	1i/WZkMDumh7Wdk/wYjH9W143Q==
X-Google-Smtp-Source: AK7set86bb7gNMGeM3o1zRl3Vl4jsax9tlj4FdaQC216JIcwhuFq8FUYTFWGQvOSkvU/29O0HZRYMA==
X-Received: by 2002:a05:6808:274e:b0:37f:acd5:20ff with SMTP id eh14-20020a056808274e00b0037facd520ffmr6409040oib.43.1678233703945;
        Tue, 07 Mar 2023 16:01:43 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id n4-20020acaef04000000b00383b8011881sm5763332oih.18.2023.03.07.16.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 16:01:43 -0800 (PST)
Message-ID: <81cd2720-0414-1213-3826-31bd240d5c75@linaro.org>
Date: Tue, 7 Mar 2023 18:01:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, pali@kernel.org, christophe.leroy@csgroup.eu,
 mpe@ellerman.id.au
References: <20230307170022.094103862@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 07/03/23 10:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1001 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see a regression with PowerPC's ppc64e_defconfig, using GCC 8 and GCC 12:
-----8<-----
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
[...]
make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:242: __sub-make] Error 2
make: Target '__all' not remade because of errors.
----->8-----

Bisection points to "powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage" (upstream ff7c76f66d8bad4e694c264c789249e1d3a8205d).

Reproducer:
   tuxmake \
     --runtime podman \
     --target-arch powerpc \
     --toolchain gcc-8 \
     --kconfig ppc64e_defconfig \
     config debugkernel dtbs kernel modules xipkernel

Greetings!

Daniel Díaz
daniel.diaz@linaro.org


