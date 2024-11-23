Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5EA22EED
	for <patches@lists.linux.dev>; Sat, 23 Nov 2024 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732376836; cv=none; b=pmJcs+EGmF/sNtaq0f3iOpzjrIin+E5JaIe9HBVS/x3YxYwCLKfW0vPWZhMz8YQz2KNuU95PFV/jraKMm60U++N/cZo+UQvdFZn2ep4wGF5H023O2O5+E0YvQRWDe8sg+39MheiyCzdPOG1EcnioJ4GhySM5omcETY1ZqZHgV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732376836; c=relaxed/simple;
	bh=dM+5ko50bGiW4wHpFwr20fCurV0azlaaaFZSbdSB3Tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzTXu9OS2VO730jNK4r8yhborcXXqqXjbXfIqMNSDJyFCnfWaweaHLMGjHqn7BGD0JOCRl2KT7divxL3WDxdlmPSdDSh3VZeKJyPUufiMckkddYmpfFfykCFZxJRN/tl9FeyxgsmOw2NMD8DPnGpFoeTvdyygOZxYYdSmI80yRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QuDc12g8; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuDc12g8"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-724f41d550cso298170b3a.2
        for <patches@lists.linux.dev>; Sat, 23 Nov 2024 07:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732376834; x=1732981634; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2Zoc3uOg+1Kbv5BtwHRLLwZziawPdUmTdDZwLPRtzZQ=;
        b=QuDc12g8rNTuCMjoCZ0VJcbc/ZbhqIleZ6STJ4UYWu4UCUFYEUWPb+tf0aQJznnusD
         4AlrIfCt2Wj9rDoKN+v7YkEwbJ0HbKgakciIFvox7jTGcVEg8o5DK7rEgfJlcfMPS76u
         zsJrj2Hy/72UOAHQrVscd1zJekGvkfKy96MLmsfB2F7Mb8qep254uP6lpiVaHtBlT0QY
         51plLC3S3frBCW70raYLWl1AJzbTe1uHjxfmRIwgfOsJIGdFOo78RGWsBjzmfr3WijyD
         xFYWmAEch//d61va2ENERSaBTvDHEerCvEWqwon1yIfn9IyPLNrUvEr0Tl2deHwo+uqx
         MjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732376834; x=1732981634;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Zoc3uOg+1Kbv5BtwHRLLwZziawPdUmTdDZwLPRtzZQ=;
        b=wJIISKy87aabiBbENapmBGbcyfZFQn+xh/LThan3FGhDU32HGOLiZ5y5WLei1KMII/
         jCJfueJuXHYzD+Z4XszOWn9r+WFBe/mc35AFzPzJZcORhAeONqN6iogk8XnwfQe/7p5+
         t4SKf8ImTTQ+IgIwo6t2VQi95U/RSCYCl9Z2LbmX04WJoYlH8bvdIDO5TCFlcxd3rku3
         MzLbwgAy2QW0a8XF9kNPlpJyYBvcbuEAM7PN4lFdmYbZEL6j41/fz+z9yvJCZro4nwhA
         EC/tZlvKHWdMbV+UydO5shFDbgy8iJN5HxwwnePiad7utd/ZPAc2aSiJd/9qLHWbAMY/
         Tw3w==
X-Gm-Message-State: AOJu0Yw8CjhMN878+YW+cZLuwlv+0YYiKqE8/xeDqHEF/x/FMv185OHk
	Vg/FV0qqiJxb6nbPuHxS/EKUk3W1pMKQZFIB4fp3dJM6J/5yTMom
X-Gm-Gg: ASbGncuwX9IGAA38aFGEyTY2lD2iXev4SoR1oAX7ohCj48GYJX7Vab1qRmHoQiR4MVR
	MsAtJxj03ovzOibxrLF6ZA5oobh8C9VqTgw20J2Yy97ggAbUrk7PTxgIQLJa66zGZAHMy+D6DkV
	MmV3jZ5wwwCVwqSsFzFWD47p/VR8fYDRP0fqnv/tl3RgDY89mXZu4gVv0roeWfN4NLQV78ALjPC
	n3LEUtJg3veFDZZAO3bN8CJkFHvFFuzfITQYeL1Dq+fODk8NZ3CteinaS4mMuyI8gnJdaz65Xmh
	E+GiYlmmel0cfkbeqvy9Gg8=
X-Google-Smtp-Source: AGHT+IF12Jep8KG9jUE9XRJlTG32rmbBK46bF+i8nvM0V2w3eR7Y4Lmk7oegrh8wwIzZuS3cqEaFNg==
X-Received: by 2002:a05:6a00:23cc:b0:71e:4c18:8e3b with SMTP id d2e1a72fcca58-724df3cd479mr9893050b3a.2.1732376832465;
        Sat, 23 Nov 2024 07:47:12 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de57a9a7sm3376142b3a.200.2024.11.23.07.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2024 07:47:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <eda70745-0ea2-43bd-bee3-8905e3a1d3cc@roeck-us.net>
Date: Sat, 23 Nov 2024 07:47:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20241120125809.623237564@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 04:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.119 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:57:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 6.1.119-rc1
> 
> Michal Luczaj <mhal@rbox.co>
>      net: Make copy_safe_from_sockptr() match documentation
> 
> Eli Billauer <eli.billauer@gmail.com>
>      char: xillybus: Fix trivial bug with mutex
> 
> Mikulas Patocka <mpatocka@redhat.com>
>      parisc: fix a possible DMA corruption
> 

This results in:

include/linux/slab.h:229: warning: "ARCH_KMALLOC_MINALIGN" redefined
   229 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
       |
In file included from include/linux/cache.h:6,
                  from include/linux/mmzone.h:12,
                  from include/linux/gfp.h:7,
                  from include/linux/mm.h:7:
arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
    28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */

because commit 4ab5f8ec7d71a ("mm/slab: decouple ARCH_KMALLOC_MINALIGN
from ARCH_DMA_MINALIGN") was not applied as well.

Then there is

include/linux/dma-mapping.h:546:47: error: macro "cache_line_size" passed 1 arguments, but takes just 0
   546 | static inline int dma_get_cache_alignment(void)
       |                                               ^
arch/parisc/include/asm/cache.h:31: note: macro "cache_line_size" defined here
    31 | #define cache_line_size()       dcache_stride
       |
include/linux/dma-mapping.h:547:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token

because commit 8c57da28dc3df ("dma: allow dma_get_cache_alignment()
to be overridden by the arch code") is missing as well.

Those two patches fix the compile errors. I have not tested if the resulting
images boot.

Guenter

