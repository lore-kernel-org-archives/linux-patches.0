Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963BB31A8A
	for <patches@lists.linux.dev>; Fri,  5 Jan 2024 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SpEdQs+6"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6dc076e9e59so953918a34.2
        for <patches@lists.linux.dev>; Fri, 05 Jan 2024 09:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704474837; x=1705079637; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FoSEH3vzeewWEEBXUwt4hcYJy0s3NCTh3xogSfmtLsU=;
        b=SpEdQs+6p8oODfStZ3UrHSbjuvDEljHjw1riAPbs2toM4YlZHO0t1Oih5qILnaZ5Kz
         YVY4QS3Ds2iUloqez4y7d14rtQAEM3zn2LeSLs9mIMfOSY/9dxNwyJOF4d6EnACqENLT
         Q4QtgAQdOJTqs2rPL2AyudMBcdaz8OTBbQn5Vmc/wgjPrx3Fm5w6WsYbx0YSovKXqC5C
         OiJWk1sFKWaQvgOMYBLnGJZMpkwokrMYu0U377T87R3FKx4aJDMHaKmoPzPwYYudoHu8
         nOZmYlTjn2AgbW4Uv/Sjo+qT64iC8PF3rBCpHoypOxtLpEL8pGFlCeddljmHtGlLglwg
         RApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704474837; x=1705079637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FoSEH3vzeewWEEBXUwt4hcYJy0s3NCTh3xogSfmtLsU=;
        b=gpM0m5z6cIGiAdPv5skqiu81ngRKoXOQr9EDmTqLajEKZC8G54GoZ04AvcWI641Zcl
         FIVblk8gWhoVhmEoRKMYjkBMXh7JsQ4ySmNrpXrgxNBPxAKJcut5UjO541ctjyNva2He
         nGwXkhsyN1eKVUTzG5dSdeyToTYD7lAo6vN7Yjr1tuTKCF0KmL6J3SgKInOtiirz5lBF
         1zYWe2aDLhAAE8v4lX0sZPNufgVDnl1MP5sTOLl/MJUFhmuvESfVeQmqYamEolGOgFTr
         I+FUSZJ70I9VdvYIIQli91dxa1c4mbjFIH8yOObDovlwl1/CaCvu6WU4rzx40Ul/p47A
         vyJA==
X-Gm-Message-State: AOJu0YwdR5VZwoOLgIN99PjwVSXn01vSuPwBGKFmUSKwLhKoKrSkIQiQ
	viL3i07tHB7PJpLGuSungqWIiZKqLrHAmw==
X-Google-Smtp-Source: AGHT+IErwQIeChpkUh17c89rx6slDFUnzAwqeqHJfH3swAdkq1eftk5ymWZPLfUHb76Zd41XBJQUIw==
X-Received: by 2002:a05:6830:204c:b0:6db:c77d:8eab with SMTP id f12-20020a056830204c00b006dbc77d8eabmr2363641otp.33.1704474837693;
        Fri, 05 Jan 2024 09:13:57 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id f18-20020a9d5e92000000b006dc659f109csm437650otl.40.2024.01.05.09.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jan 2024 09:13:57 -0800 (PST)
Message-ID: <2948beff-a9f6-42b2-8bfb-534ec9188de6@linaro.org>
Date: Fri, 5 Jan 2024 11:13:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.14 00/21] 4.14.335-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 alexis.lothore@bootlin.com, liujian56@huawei.com
References: <20240105143811.536282337@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240105143811.536282337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 05/01/24 8:38 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.335 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jan 2024 14:38:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.335-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We are seeing build problems on Arm32 and Arm64. On Arm32, for the following configurations:

* clang-17-keystone_defconfig
* clang-17-lkftconfig
* clang-17-mini2440_defconfig
* clang-17-sama5_defconfig
* gcc-8-defconfig
* gcc-8-sama5_defconfig
* gcc-12-defconfig
* gcc-12-lkftconfig
* gcc-12-lkftconfig-debug
* gcc-12-lkftconfig-debug-kmemleak
* gcc-12-lkftconfig-kasan
* gcc-12-lkftconfig-kselftest-kernel
* gcc-12-lkftconfig-kunit
* gcc-12-lkftconfig-libgpiod
* gcc-12-lkftconfig-rcutorture
* gcc-12-sama5_defconfig

Failure looks like this:

-----8<-----
   /builds/linux/drivers/pinctrl/pinctrl-at91-pio4.c: In function 'atmel_pinctrl_probe':
   /builds/linux/drivers/pinctrl/pinctrl-at91-pio4.c:1054:3: error: too many arguments to function 'irq_set_lockdep_class'
      irq_set_lockdep_class(irq, &atmel_lock_key, &atmel_request_key);
      ^~~~~~~~~~~~~~~~~~~~~
   In file included from /builds/linux/include/linux/irq.h:517,
                    from /builds/linux/include/linux/gpio/driver.h:7,
                    from /builds/linux/drivers/pinctrl/pinctrl-at91-pio4.c:18:
   /builds/linux/include/linux/irqdesc.h:250:1: note: declared here
    irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
    ^~~~~~~~~~~~~~~~~~~~~
   make[3]: *** [/builds/linux/scripts/Makefile.build:330: drivers/pinctrl/pinctrl-at91-pio4.o] Error 1
----->8-----

Bisection points to:

   commit 6c47537ba008b3affe99360f65592ff5b797818f
   Author: Alexis Lothoré <alexis.lothore@bootlin.com>
   Date:   Fri Dec 15 22:34:24 2023 +0100

       pinctrl: at91-pio4: use dedicated lock class for IRQ
       
       [ Upstream commit 14694179e561b5f2f7e56a0f590e2cb49a9cc7ab ]

Reproducer:

   tuxmake --runtime podman --target-arch arm --toolchain clang-17 --kconfig defconfig LLVM_IAS=0

Then on Arm64 with Clang 17:

-----8<-----
   /builds/linux/net/8021q/vlan_core.c:332:39: error: incompatible integer to pointer conversion passing '__be16' (aka 'unsigned short') to parameter of type 'const struct vlan_vi
   d_info *' [-Wint-conversion]
     332 |                 if (!vlan_hw_filter_capable(by_dev, vid_info->proto))
         |                                                     ^~~~~~~~~~~~~~~
   /builds/linux/net/8021q/vlan_core.c:169:38: note: passing argument to parameter 'vid_info' here
     169 |                                      const struct vlan_vid_info *vid_info)
         |                                                                  ^
   /builds/linux/net/8021q/vlan_core.c:344:39: error: incompatible integer to pointer conversion passing '__be16' (aka 'unsigned short') to parameter of type 'const struct vlan_vi
   d_info *' [-Wint-conversion]
     344 |                 if (!vlan_hw_filter_capable(by_dev, vid_info->proto))
         |                                                     ^~~~~~~~~~~~~~~
   /builds/linux/net/8021q/vlan_core.c:169:38: note: passing argument to parameter 'vid_info' here
     169 |                                      const struct vlan_vid_info *vid_info)
         |                                                                  ^
   /builds/linux/net/8021q/vlan_core.c:366:39: error: incompatible integer to pointer conversion passing '__be16' (aka 'unsigned short') to parameter of type 'const struct vlan_vid_info *' [-Wint-conversion]
     366 |                 if (!vlan_hw_filter_capable(by_dev, vid_info->proto))
         |                                                     ^~~~~~~~~~~~~~~
   /builds/linux/net/8021q/vlan_core.c:169:38: note: passing argument to parameter 'vid_info' here
     169 |                                      const struct vlan_vid_info *vid_info)
         |                                                                  ^
   3 errors generated.
   make[3]: *** [/builds/linux/scripts/Makefile.build:329: net/8021q/vlan_core.o] Error 1
----->8-----

Bisection in this case points to:

   commit f33474044777425b3578d4e8b22a003f034ae214
   Author: Liu Jian <liujian56@huawei.com>
   Date:   Sat Dec 16 15:52:18 2023 +0800

       net: check vlan filter feature in vlan_vids_add_by_dev() and vlan_vids_del_by_dev()
       
       [ Upstream commit 01a564bab4876007ce35f312e16797dfe40e4823 ]

Reproducer:

   tuxmake --runtime podman --target-arch arm64 --toolchain clang-17 --kconfig defconfig LD=ld.lld LLVM_IAS=0

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

