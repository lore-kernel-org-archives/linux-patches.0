Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABA933CC1
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 22:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QgISr98A"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6ce322b62aeso1239802a34.3
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 14:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700864375; x=1701469175; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sp6wT8+1Ad3Eo4gMX/t3SuQMVx12hWZwCAecs2be2uo=;
        b=QgISr98AIRSeq2UOxM3XxhfAyiaZDFIQxuoyHUwEigl4BfNAuhTZmeWgAzuWglX0/O
         l0Cv3kHG4eBX3bVIxp7gQjZ+4U/mQua8Ps3krhx8s5j95Pfjunq0apllUFRhZcllFNqf
         Lw6rtt1SFIZT+89d6Sxr8Pg8uEdve6Bv8Qt0VNqVnuQcL04u2/3mumsbAw3i3bkjShd8
         NG2vc2212ttSm/dQOSGTACjUwaQrP0wKKvvlUIISoAjrRyDRrbxanuDH2LjrYj27sbhn
         dL1RLAtUhSxxJMeBxl4YxpNLwmyOfG3q/cfcatL8e/pulpPgXfvlJ7P+w6V7dHie1o8X
         LOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700864375; x=1701469175;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sp6wT8+1Ad3Eo4gMX/t3SuQMVx12hWZwCAecs2be2uo=;
        b=cXx0in1VzTPoKdlGUS/uxEg1xLTpC/LA3ZNF97+kd3SBF5h76t01beL0WwuEK2Wv63
         Wij15U760RdxQvkWf+JyGRdPpEgM4LNhgxXHyQ5blJis/9S2A8yzsG5xtpBWSpmPpN75
         wEDugbNNw1hBF8rinu8LXi+xgfxxgJxs3+y1FSaVmil1x2sGjLM+U7G8Gxl6BMWF/Ow7
         iixAP/YhI4yn79GE596joWLKtUDpY4e7hgTV6bNgEuOuKlatTu57g4soBgb05kbWAgI3
         AqB3ktOsGXJ+QCa2n+bvjVXKhWlKKqUBLlXivaxtNJ5Y+4UoYNPQAT8x+69a2gDCGHB/
         mhsw==
X-Gm-Message-State: AOJu0YxPQbf/wdLzTt9cZ6v8kZJR1Pzu/suqh7gzrbfU74FDKLd6OlnC
	BdMFxHGCgTdHZrbS/7upvS97NA==
X-Google-Smtp-Source: AGHT+IE7Wly4lTbuJrB1YCqIigId5lil0OwTe9kyxlAvuqwIR2CSLE4zPWIuYf/aCLxJ7/EPCfJXXA==
X-Received: by 2002:a05:6830:6c18:b0:6d8:119d:a0a8 with SMTP id ds24-20020a0568306c1800b006d8119da0a8mr540159otb.13.1700864374790;
        Fri, 24 Nov 2023 14:19:34 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id f22-20020a9d6c16000000b006d7ed2ad9e8sm647219otq.12.2023.11.24.14.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Nov 2023 14:19:34 -0800 (PST)
Message-ID: <a67ec47c-6d4c-4a2f-a4c0-5284d895982a@linaro.org>
Date: Fri, 24 Nov 2023 16:19:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/193] 5.10.202-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hca@linux.ibm.com, mpe@ellerman.id.au
References: <20231124171947.127438872@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 24/11/23 11:52 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.202 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

System/390 fails here too:

-----8<-----
   In function 'setup_lowcore_dat_off',
       inlined from 'setup_arch' at /builds/linux/arch/s390/kernel/setup.c:1165:2:
   /builds/linux/arch/s390/kernel/setup.c:410:9: warning: 'memcpy' reading 128 bytes from a region of size 0 [-Wstringop-overread]
     410 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     411 |                sizeof(lc->stfle_fac_list));
         |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   /builds/linux/arch/s390/kernel/setup.c:412:9: warning: 'memcpy' reading 128 bytes from a region of size 0 [-Wstringop-overread]
     412 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     413 |                sizeof(lc->alt_stfle_fac_list));
         |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c: In function 'mark_kernel_pgd':
   /builds/linux/arch/s390/mm/page-states.c:175:45: error: request for member 'val' in something not a structure or union
     175 |         max_addr = (S390_lowcore.kernel_asce.val & _ASCE_TYPE_MASK) >> 2;
         |                                             ^
   In file included from /builds/linux/arch/s390/include/asm/page.h:186,
                    from /builds/linux/arch/s390/include/asm/thread_info.h:26,
                    from /builds/linux/include/linux/thread_info.h:39,
                    from /builds/linux/arch/s390/include/asm/preempt.h:6,
                    from /builds/linux/include/linux/preempt.h:78,
                    from /builds/linux/include/linux/spinlock.h:51,
                    from /builds/linux/include/linux/mmzone.h:8,
                    from /builds/linux/include/linux/gfp.h:6,
                    from /builds/linux/include/linux/mm.h:10,
                    from /builds/linux/arch/s390/mm/page-states.c:13:
   /builds/linux/arch/s390/mm/page-states.c: In function 'cmma_init_nodat':
   /builds/linux/arch/s390/mm/page-states.c:204:30: error: 'invalid_pg_dir' undeclared (first use in this function)
     204 |         page = virt_to_page(&invalid_pg_dir);
         |                              ^~~~~~~~~~~~~~
   /builds/linux/include/asm-generic/memory_model.h:54:45: note: in definition of macro '__pfn_to_page'
      54 | #define __pfn_to_page(pfn)      (vmemmap + (pfn))
         |                                             ^~~
   /builds/linux/arch/s390/include/asm/page.h:176:34: note: in expansion of macro 'phys_to_pfn'
     176 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                  ^~~~~~~~~~~
   /builds/linux/arch/s390/include/asm/page.h:176:46: note: in expansion of macro '__pa'
     176 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                              ^~~~
   /builds/linux/arch/s390/include/asm/page.h:179:45: note: in expansion of macro 'virt_to_pfn'
     179 | #define virt_to_page(kaddr)     pfn_to_page(virt_to_pfn(kaddr))
         |                                             ^~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c:204:16: note: in expansion of macro 'virt_to_page'
     204 |         page = virt_to_page(&invalid_pg_dir);
         |                ^~~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c:204:30: note: each undeclared identifier is reported only once for each function it appears in
     204 |         page = virt_to_page(&invalid_pg_dir);
         |                              ^~~~~~~~~~~~~~
   /builds/linux/include/asm-generic/memory_model.h:54:45: note: in definition of macro '__pfn_to_page'
      54 | #define __pfn_to_page(pfn)      (vmemmap + (pfn))
         |                                             ^~~
   /builds/linux/arch/s390/include/asm/page.h:176:34: note: in expansion of macro 'phys_to_pfn'
     176 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                  ^~~~~~~~~~~
   /builds/linux/arch/s390/include/asm/page.h:176:46: note: in expansion of macro '__pa'
     176 | #define virt_to_pfn(kaddr)      (phys_to_pfn(__pa(kaddr)))
         |                                              ^~~~
   /builds/linux/arch/s390/include/asm/page.h:179:45: note: in expansion of macro 'virt_to_pfn'
     179 | #define virt_to_page(kaddr)     pfn_to_page(virt_to_pfn(kaddr))
         |                                             ^~~~~~~~~~~
   /builds/linux/arch/s390/mm/page-states.c:204:16: note: in expansion of macro 'virt_to_page'
     204 |         page = virt_to_page(&invalid_pg_dir);
         |                ^~~~~~~~~~~~
   make[3]: *** [/builds/linux/scripts/Makefile.build:286: arch/s390/mm/page-states.o] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:503: arch/s390/mm] Error 2
   In file included from /builds/linux/arch/s390/kernel/lgr.c:13:
   In function '__stfle',
       inlined from 'stfle' at /builds/linux/arch/s390/include/asm/facility.h:99:2,
       inlined from 'lgr_info_get' at /builds/linux/arch/s390/kernel/lgr.c:122:2:
   /builds/linux/arch/s390/include/asm/facility.h:87:9: warning: 'memcpy' reading 4 bytes from a region of size 0 [-Wstringop-overread]
      87 |         memcpy(stfle_fac_list, &S390_lowcore.stfl_fac_list, 4);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In function 'pcpu_prepare_secondary',
       inlined from '__cpu_up' at /builds/linux/arch/s390/kernel/smp.c:911:2:
   /builds/linux/arch/s390/kernel/smp.c:277:9: warning: 'memcpy' reading 128 bytes from a region of size 0 [-Wstringop-overread]
     277 |         memcpy(lc->stfle_fac_list, S390_lowcore.stfle_fac_list,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     278 |                sizeof(lc->stfle_fac_list));
         |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   /builds/linux/arch/s390/kernel/smp.c:279:9: warning: 'memcpy' reading 128 bytes from a region of size 0 [-Wstringop-overread]
     279 |         memcpy(lc->alt_stfle_fac_list, S390_lowcore.alt_stfle_fac_list,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     280 |                sizeof(lc->alt_stfle_fac_list));
         |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   make[2]: Target '__build' not remade because of errors.
----->8-----

That was allnoconfig with GCC 12. Bisection pointed to:

   commit 2e530ad14d778a089d8ec190a7e2a70421a8a71a
   Author: Heiko Carstens <hca@linux.ibm.com>
   Date:   Tue Oct 17 21:07:03 2023 +0200

       s390/cmma: fix initial kernel address space page table walk
       
       commit 16ba44826a04834d3eeeda4b731c2ea3481062b7 upstream.


Then there's also a PowerPC failure on allmodconfig:

-----8<-----
   /builds/linux/arch/powerpc/platforms/powernv/opal-prd.c:30:17: error: expected specifier-qualifier-list before 'DECLARE_FLEX_ARRAY'
      30 |                 DECLARE_FLEX_ARRAY(u8, data);
         |                 ^~~~~~~~~~~~~~~~~~
   /builds/linux/arch/powerpc/platforms/powernv/opal-prd.c: In function 'opal_prd_msg_notifier':
   /builds/linux/arch/powerpc/platforms/powernv/opal-prd.c:365:26: error: 'struct opal_prd_msg' has no member named 'data'
     365 |         memcpy(&item->msg.data, msg->params, msg_size);
         |                          ^
   make[4]: *** [/builds/linux/scripts/Makefile.build:286: arch/powerpc/platforms/powernv/opal-prd.o] Error 1
----->8-----

I didn't bisect this one but would suspect this commit:

   commit 2342ac1ed7704304605e29e337ce073f00f75d1e
   Author: Michael Ellerman <mpe@ellerman.id.au>
   Date:   Tue Aug 22 00:28:19 2023 +1000

       powerpc/powernv: Fix fortify source warnings in opal-prd.c
       
       commit feea65a338e52297b68ceb688eaf0ffc50310a83 upstream.


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

