Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFBF19904
	for <patches@lists.linux.dev>; Tue,  9 May 2023 21:18:38 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6439bbc93b6so4282543b3a.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 14:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683667118; x=1686259118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pUcq0bug0o4ImBs4oiU3OPIPZpm1xhF2eAPPTNrxkAk=;
        b=mTO1MOwZVXwTCILT7ASs1bZbgAz5iAd7xvGJizQL0B8U2kO/HmzCLBXh+OYgLzBugH
         VkCIe6nd1zPaJUCJ+rpEXWCcE30llVcBnc4wRcOemUHCt2q+P9Y1tvvWjPLy6sLfELoA
         y5g8GqzcfJsgpwcvhvegCCDAdaw/5fJdXK7583EEnCcoO1smzhIHKNRb5A0ZubQKl7Oa
         ccdsKBMNqJA6B/bLljJr0iTdMyiMopYYg8Lu/l+LIQ26LExUJHJETCwLrdxk8he1Ii4L
         YzHAPpWqFmaQ03l0gJTN5ER4IsI/XiZdVqRtqjqNkCu0crrkuuXelujdTITj45mNGfPY
         jIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683667118; x=1686259118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUcq0bug0o4ImBs4oiU3OPIPZpm1xhF2eAPPTNrxkAk=;
        b=a9ed/I8bj4P5V+3lQwv3BBoVmXgmuzfhVSf/yYvtmj/i+ol/dYcn//m/RgjDbVdqFQ
         +5W1ouzdvE8u7LV5egy3CEw+ugCcfqClaTH+04/+XLl+uxoOQvhT2eR505QtDzoKDJyx
         UrRwqkj4gzc+X3y2Hfp3107jLp/Qu530rHmNZAY2k7NBC3ZKD5A//hXOLlnQtKinfXxk
         V0CQZZHlSaGNe/8bLugFhb6xtFqv+YEdsITpB8sZ301ws9pcejRWBkwMb0VJrFYQyibH
         1YmJs7tVgXzIc/H/4L1zgclz7LKUxIiQweHu8Ib8dEWAzGwFt6CLyQLwa3EFSl7UcY+C
         vVAA==
X-Gm-Message-State: AC+VfDyyNKy+NoGFfRrM6B3Fa7EVIP/snPtpHGaqvf+4TK/w9Gj+dUbM
	Qh8v5EHpDbIJPG5JEJMobtA=
X-Google-Smtp-Source: ACHHUZ7hEN0mp51juiLovr+ikP4KMSZgmvgdBGzf8gnANj9xgf9K2fhXTO480NE8bSqYE0dXkhGuKA==
X-Received: by 2002:a05:6a20:72a1:b0:100:6a95:c289 with SMTP id o33-20020a056a2072a100b001006a95c289mr11390356pzk.5.1683667117935;
        Tue, 09 May 2023 14:18:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p19-20020a63f453000000b005287b22ea8esm1800306pgk.88.2023.05.09.14.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 14:18:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 9 May 2023 14:18:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Conor Dooley <conor@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
Message-ID: <ce667220-5803-4b6a-a2d2-f538289af584@roeck-us.net>
References: <20230509030653.039732630@linuxfoundation.org>
 <0837e157-8615-418a-a3d3-1c14af11aba5@roeck-us.net>
 <20230509-robust-crate-5fe128d00e6d@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509-robust-crate-5fe128d00e6d@spud>

On Tue, May 09, 2023 at 09:41:42PM +0100, Conor Dooley wrote:
> On Tue, May 09, 2023 at 12:57:58PM -0700, Guenter Roeck wrote:
> > On Tue, May 09, 2023 at 05:26:31AM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.1.28 release.
> > > There are 610 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 155 pass: 155 fail: 0
> > Qemu test results:
> > 	total: 519 pass: 519 fail: 0
> > 
> > New persistent runtime warning when booting riscv32/64 images:
> 
> You sure this is new? I seem to be able to reproduce for QEMU (which I

New for my tests, yes.

> don't usually test) in several versions of 6.1. Don't see it in (my)
> hardware though, as the particular platform doesn't end up calling the
> offending function. Out of curiosity, what's your QEMU invocation?

Example boot from initrd:

qemu-system-riscv64 -M virt -m 512M \
     -no-reboot -kernel arch/riscv/boot/Image \
     -initrd rootfs.cpio \
     -device e1000,netdev=net0 \
     -netdev user,id=net0 -bios default \
     -append "panic=-1 rdinit=/sbin/init console=ttyS0,115200 earlycon=uart8250,mmio,0x10000000,115200" \
     -nographic -monitor none

qemu version is 8.0, but I don't think that makes a difference.
What does your command line look like ?

> 
> Anyways, looks like a partial backport is the cause. How's it look with:
> 
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 694267d1fe81..fd1238df6149 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -9,6 +9,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/ctype.h>
>  #include <linux/libfdt.h>
> +#include <linux/memory.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <asm/alternative.h>
> @@ -316,8 +317,11 @@ void __init_or_module riscv_cpufeature_patch_func(struct alt_entry *begin,
>  		}
>  
>  		tmp = (1U << alt->errata_id);
> -		if (cpu_req_feature & tmp)
> +		if (cpu_req_feature & tmp) {
> +			mutex_lock(&text_mutex);
>  			patch_text_nosync(alt->old_ptr, alt->alt_ptr, alt->alt_len);
> +			mutex_unlock(&text_mutex);
> +		}
>  	}
>  }
>  #endif
> 

This fixes the problem for me.

Thanks,
Guenter
