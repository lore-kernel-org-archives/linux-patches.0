Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B52108
	for <patches@lists.linux.dev>; Sun, 26 Nov 2023 05:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lXrDPP4g"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-1fa1ec476f1so705030fac.2
        for <patches@lists.linux.dev>; Sat, 25 Nov 2023 21:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700977274; x=1701582074; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S36piAfzQvna+N9L6mM9OEWRABXZuCTabjbt1X/ibi8=;
        b=lXrDPP4ge+uvKbJy3KF84xwbMDOC9aPGxMqTObWV6uySsAH897xfadGOVF+g48nLMa
         vh87VPau2ppoeFfPGYpfVYlpcvxF1EDuEE7noGVhKnrBzQS1jD/bxndv2KLmAEu8/2VP
         VXj0o74h/wscTLdiH5jUR/mxdwAFuE7YY0HZJ4ofiLQR8jfl5KhehUYbXyCHC2ts8fEf
         7rPYZXj7OX4NN/0KyZbbgCt8kfmKMuA4xAgLqN95Rf9fd89alnAX4B+scVl1G0sm/G5v
         xbFwtN9iwXFM15AwqcMSLpm83aDxIRxL/sFLw96KmUdnErqHP6DnzKMDMep/4zo+GGxv
         HIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700977274; x=1701582074;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S36piAfzQvna+N9L6mM9OEWRABXZuCTabjbt1X/ibi8=;
        b=eU62bJyPupHnjVZnBbsgTbykMp+vSpW3UQdy9TQ4SGpXdlnOM8IIIbXVUUXS5pt5IZ
         Lp52X4K5H0tIEM/78vtCeFWz7Ox1FhEaHVuTWTbKSIBfht4+zZZzhXTWfJ27fxyJ7BdF
         YV7nJXbqFGAhd2679eD/5ZVVjiAHnDCNfFmVT4buyuaYuBYXJlWB/wH1tnpZJR4Q5KfC
         YF0vLRr9iTynLAVBLYoamwT8ntWG4T/gwA1e24rOKodvt+r9KD82sm8JqwI7cUsurn5i
         jBvNarOq3i6ZBY8aB5PTq78tOQjdGWkQ1xRfujGQRftvteLuecVANMYKMBNQbWYPovTr
         GNWQ==
X-Gm-Message-State: AOJu0Yz/iUJ3cS5EBG9F6U5+G8t+jg3XXW4zqU7oXEWXIMnpf+w87MNF
	h+cGQq3AOTXrrmXM/nE0jOdSxQ==
X-Google-Smtp-Source: AGHT+IEwHyJDJRMTkV7S100rGnvfONxHA5hf52RO0SaB0m0JAbk6ujmtCuS5LfT6Gb03rCZFYCmWdQ==
X-Received: by 2002:a05:6871:88d:b0:1fa:2ddf:d5c4 with SMTP id r13-20020a056871088d00b001fa2ddfd5c4mr3178526oaq.25.1700977274651;
        Sat, 25 Nov 2023 21:41:14 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id bn18-20020a0568300c9200b006ce2c31dd9bsm1012164otb.20.2023.11.25.21.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Nov 2023 21:41:14 -0800 (PST)
Message-ID: <a853e6f3-f658-4049-9c36-66835d144eac@linaro.org>
Date: Sat, 25 Nov 2023 23:41:11 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/368] 6.1.64-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, hca@linux.ibm.com,
 gbatra@linux.vnet.ibm.com
References: <20231125194359.201910779@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231125194359.201910779@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 25/11/23 1:45 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.64 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Nov 2023 19:43:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.64-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

The following configurations are failing for System/390:
* gcc-8-allmodconfig
* gcc-8-allnoconfig
* gcc-8-defconfig (+CONFIG_DEBUG_INFO_BTF=n)
* gcc-8-tinyconfig
* gcc-13-allmodconfig
* gcc-13-allnoconfig
* gcc-13-defconfig
* gcc-13-tinyconfig
* clang-17-allmodconfig
* clang-17-allnoconfig
* clang-17-defconfig
* clang-17-tinyconfig
* clang-nightly-allmodconfig
* clang-nightly-allnoconfig
* clang-nightly-defconfig
* clang-nightly-tinyconfig

The error looks like this:
-----8<-----
   In file included from /builds/linux/arch/s390/include/asm/page.h:208,
                    from /builds/linux/arch/s390/include/asm/thread_info.h:26,
                    from /builds/linux/include/linux/thread_info.h:60,
                    from /builds/linux/arch/s390/include/asm/preempt.h:6,
                    from /builds/linux/include/linux/preempt.h:78,
                    from /builds/linux/include/linux/spinlock.h:56,
                    from /builds/linux/include/linux/mmzone.h:8,
                    from /builds/linux/include/linux/gfp.h:7,
                    from /builds/linux/include/linux/mm.h:7,
                    from /builds/linux/arch/s390/mm/page-states.c:13:
   /builds/linux/arch/s390/mm/page-states.c: In function 'cmma_init_nodat':
   /builds/linux/arch/s390/mm/page-states.c:198:30: error: 'invalid_pg_dir' undeclared (first use in this function)
     198 |         page = virt_to_page(&invalid_pg_dir);
         |                              ^~~~~~~~~~~~~~
   /builds/linux/include/asm-generic/memory_model.h:25:45: note: in definition of macro '__pfn_to_page'
      25 | #define __pfn_to_page(pfn)      (vmemmap + (pfn))
         |                                             ^~~
   /builds/linux/arch/s390/include/asm/page.h:198:34: note: in expansion of macro 'phys_to_pfn'
     198 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                  ^~~~~~~~~~~
   /builds/linux/arch/s390/include/asm/page.h:198:46: note: in expansion of macro '__pa'
     198 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                              ^~~~
   /builds/linux/arch/s390/include/asm/page.h:201:45: note: in expansion of macro 'virt_to_pfn'
     201 | #define virt_to_page(kaddr)     pfn_to_page(virt_to_pfn(kaddr))
         |                                             ^~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c:198:16: note: in expansion of macro 'virt_to_page'
     198 |         page = virt_to_page(&invalid_pg_dir);
         |                ^~~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c:198:30: note: each undeclared identifier is reported only once for each function it appears in
     198 |         page = virt_to_page(&invalid_pg_dir);
         |                              ^~~~~~~~~~~~~~
   /builds/linux/include/asm-generic/memory_model.h:25:45: note: in definition of macro '__pfn_to_page'
      25 | #define __pfn_to_page(pfn)      (vmemmap + (pfn))
         |                                             ^~~
   /builds/linux/arch/s390/include/asm/page.h:198:34: note: in expansion of macro 'phys_to_pfn'
     198 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                  ^~~~~~~~~~~
   /builds/linux/arch/s390/include/asm/page.h:198:46: note: in expansion of macro '__pa'
     198 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                              ^~~~
   /builds/linux/arch/s390/include/asm/page.h:201:45: note: in expansion of macro 'virt_to_pfn'
     201 | #define virt_to_page(kaddr)     pfn_to_page(virt_to_pfn(kaddr))
         |                                             ^~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c:198:16: note: in expansion of macro 'virt_to_page'
     198 |         page = virt_to_page(&invalid_pg_dir);
         |                ^~~~~~~~~~~~
   make[4]: *** [/builds/linux/scripts/Makefile.build:250: arch/s390/mm/page-states.o] Error 1
----->8-----

Bisection points to:

   commit 1a5dd59623dc206de30df2d13316a3ce9be6821a
   Author: Heiko Carstens <hca@linux.ibm.com>
   Date:   Tue Oct 24 10:15:20 2023 +0200

       s390/cmma: fix handling of swapper_pg_dir and invalid_pg_dir
       
       commit 84bb41d5df48868055d159d9247b80927f1f70f9 upstream.


Reverting that commit made the build pass.

Reproducer:
   tuxmake --runtime podman --target-arch s390 --toolchain gcc-13 --kconfig tinyconfig


Then, there's a PowerPC failure too on the following configurations:
* gcc-8-allmodconfig
* gcc-8-defconfig
* gcc-13-allmodconfig
* gcc-13-defconfig
* clang-17-defconfig
* clang-nightly-defconfig

That looks like this:
-----8<-----
   /builds/linux/arch/powerpc/platforms/pseries/iommu.c: In function 'find_existing_ddw':
   /builds/linux/arch/powerpc/platforms/pseries/iommu.c:926:49: error: 'struct dma_win' has no member named 'direct'
     926 |                         *direct_mapping = window->direct;
         |                                                 ^~
   make[5]: *** [/builds/linux/scripts/Makefile.build:250: arch/powerpc/platforms/pseries/iommu.o] Error 1
----->8-----

I guess it might be due to this:

   commit fd018dfa8f0b963d65700d518596f9d834844fca
   Author: Gaurav Batra <gbatra@linux.vnet.ibm.com>
   Date:   Mon Oct 2 22:08:02 2023 -0500

       powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping for SR-IOV device
       
       commit 3bf983e4e93ce8e6d69e9d63f52a66ec0856672e upstream.


Reverting that commit does make the build pass again.

Reproducer:
   tuxmake --runtime podman --target-arch powerpc --toolchain gcc-13 --kconfig defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

