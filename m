Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117B553AB
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 15:21:55 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-17aa62d0a4aso6473258fac.4
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 08:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678893715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzYV/7XeWGA5a2Jcg195Nwebw3aHdye3PaYXj1dHESE=;
        b=umPdG7TKKpYKVTy71PPX37zak1MBhfpa8hlhiMWKXvz8vnQAz9fPkLjtMGMnpIfFSZ
         v0jhdlcA0JU6dywjKfBWh7dpTorCUGlYip8w2GOX2Dvo8BDsknGAe09BgxOF7JmHCGHg
         Qv5UArHReujDJrrCCj/dNNBvRegDExV375e8kkrWziGOsCBvW5aO0hV/J0b9hFcGnlO6
         b/FboecwWyBzdcz520hiHX4JVRy73S9vIJTRUcSD+7WOSFmYzdeWtgdCwzsT7kk06LBY
         +4nGQmeCmWTrLEOmCpDfbl1vkQ1//ur99CgcpEi93QrFJ/TqxAzqLTFtvUSRR5HgtyRf
         ygwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gzYV/7XeWGA5a2Jcg195Nwebw3aHdye3PaYXj1dHESE=;
        b=BP7PH2JFVnn4s4xpSKzN6PVb0vo6Q7YXG64protkSui7GV+8Ahpd26OmhxEKOW0WtU
         xCSoMKfyJEp4VnG8sfZT8NXSam9cxebI0wejYr3UvDBBWhYG/2A/Nw++sj70nQ7m3lsx
         /3hiN8MKWL4xnbzazutP0wOjpFa2V+8haWXeG5W1gYplcI/k/ZWEYsl96FTlp5OR4V09
         CZGTsKKeXYuCC1On5Y1T1tsmPoG1K90K9coMHBrQFDF6wg0n65YOWZdKDn7NJPVpRS/5
         R1KZw1+wg8NavFN7zvz/RxITGKBkgfRgeh2gka6PLF6/1L7e8KnMnkep75x7hu1QvIFN
         YXdg==
X-Gm-Message-State: AO0yUKWzWcIo0p3ZKC3ntacw3oDCgjWZkyP0GC+wdbH3fBHZBeTRYkYB
	zVRN2T5168lImP4KmM3de52xVg==
X-Google-Smtp-Source: AK7set/khWLrD0uM5c2BK68glSdWzCW7UfCoaN1mGRH+UB4Zb9Opn6kqLfmrRWmWoCWHMxLh5q9hRA==
X-Received: by 2002:a05:6870:2404:b0:177:90dc:1529 with SMTP id n4-20020a056870240400b0017790dc1529mr8684347oap.40.1678893715056;
        Wed, 15 Mar 2023 08:21:55 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id an36-20020a056871b1a400b00177c314a358sm2335207oac.22.2023.03.15.08.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:21:54 -0700 (PDT)
Message-ID: <b97c4328-54fd-0461-5fa9-323a0d2ba1f4@linaro.org>
Date: Wed, 15 Mar 2023 09:21:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230315115740.429574234@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

Build failures on PowerPC (GCC-8, GCC-12, Clang-16, Clang-nightly) on:
* cell_defconfig
* mpc83xx_defconfig

-----8<-----
In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1253:
/builds/linux/drivers/usb/host/ohci-ppc-of.c: In function 'ohci_hcd_ppc_of_probe':
/builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
   if (irq == NO_IRQ) {
              ^~~~~~
              NR_IRQS
----->8-----


PowerPC with GCC-8 and GCC-12, for ppc6xx_defconfig:

-----8<-----
/builds/linux/drivers/ata/pata_mpc52xx.c: In function 'mpc52xx_ata_probe':
/builds/linux/drivers/ata/pata_mpc52xx.c:734:17: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
   if (ata_irq == NO_IRQ) {
                  ^~~~~~
                  NR_IRQS
/builds/linux/drivers/ata/pata_mpc52xx.c:734:17: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [/builds/linux/scripts/Makefile.build:250: drivers/ata/pata_mpc52xx.o] Error 1
make[4]: Target 'drivers/ata/' not remade because of errors.
make[3]: *** [/builds/linux/scripts/Makefile.build:500: drivers/ata] Error 2
In file included from /builds/linux/drivers/usb/host/ehci-hcd.c:1321:
/builds/linux/drivers/usb/host/ehci-ppc-of.c: In function 'ehci_hcd_ppc_of_probe':
/builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
   if (irq == NO_IRQ) {
              ^~~~~~
              NR_IRQS
/builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: note: each undeclared identifier is reported only once for each function it appears in
make[5]: *** [/builds/linux/scripts/Makefile.build:250: drivers/usb/host/ehci-hcd.o] Error 1
In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1253:
/builds/linux/drivers/usb/host/ohci-ppc-of.c: In function 'ohci_hcd_ppc_of_probe':
/builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
   if (irq == NO_IRQ) {
              ^~~~~~
              NR_IRQS
/builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: note: each undeclared identifier is reported only once for each function it appears in
----->8-----


PowerPC with GCC-8 and GCC-12, for ppc64e_defconfig:

-----8<-----
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:238: arch/powerpc/boot/div64.o] Error 1
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:234: arch/powerpc/boot/devtree.o] Error 1
[...]
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_sw.o] Error 1
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_wip.o] Error 1
make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:238: __sub-make] Error 2
make: Target '__all' not remade because of errors.
----->8-----


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

