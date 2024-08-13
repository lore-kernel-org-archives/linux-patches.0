Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E32D03B
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 05:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723527943; cv=none; b=iIaUJLo+c5RU5SAIIyJeIKu1k8QBwB/zPIr2EGzIJjysEoz+eoNtRIOdZWQJCJJZvtENqV2q2/LFihrnABTegFy7szMg8rx8xW3evfAqiv7tnIdySchtsPXOh6kCPoBXoHmjcw4wTYrUiKLkVm9YZBsZ3gPSY5ZMVthDuePu1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723527943; c=relaxed/simple;
	bh=cdoNnInjoIDLOcYyF3TpIBPak0pH9QVzrl2rJ1+P1j4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KxGNX2bk0hWwHDlXXuTScoZOrAEbp8yedgTpBj9gLE8yL50xIfF8B8hR9j8TyxGdNe6fLDu0BYcRow9S6Sb3oUrPgNJP0Ap6B7Khgg4Uvy+htXmnWktCnzb8zAd57LgdhmVr8vRpU4nvhON5iOxiMPLy6CHVR1qUEQS3s4ljjJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=caL0snTD; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="caL0snTD"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4f524fa193aso3478746e0c.0
        for <patches@lists.linux.dev>; Mon, 12 Aug 2024 22:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723527940; x=1724132740; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WT/CbsEouBetlgF7QeJxWQVQU9e4IrXwmq96Le/w1ag=;
        b=caL0snTD/Rq/6O4vivNeiWhdpBd+HrEvY69cns1MUUgJ3KNIT8ifzvF+eZMyyjCBXK
         EdaNNED1HPzo5zo4+n16bCc3gNipI3UKPnjd7hNuct0pNjiNtbTpokLFIZ3Du4EzgJC0
         gkxJJ8iiEc7GQZ8ozTz1I0EB+4Pk3wUpz3PFEbX0SD3Ipi0RjGJ1wAQN1bkbar+pdqWa
         SqROMa8A+RiGJWq5iBaoOMzBZkiVleZ/GNPWvcYqGcfjWNdYHDsZC9dnDIIBH0ystilt
         M8/0bwLYbve0NPu6L9T0xQMp/GoBZChqBZV+eVrOFO505S6t9vkamU7HF2dMvFCHtY4X
         XrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723527940; x=1724132740;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WT/CbsEouBetlgF7QeJxWQVQU9e4IrXwmq96Le/w1ag=;
        b=NTMdYvKD49VAM8obJQVopQ+Ysae0ZzSgfL77PaBH80ZoaO9u8S3plsMSupkgNUiBI6
         aY/wbalMtHd0NGEkp08pa1y2tYuoSOcZsFyAKZneGwvJaVkZw+aXZHb+8WOnSm0o2QnI
         We2TW+2XgOHtiBF6q1O1wcb4YWdGHrEdmpYOcwau1gCr8DYWxhsZj0Wzbb4U02/NjeK4
         ropNhag02Of8UwK+fmwb7s0DEBKNw9PJU23hh4rjrRfDDZp2qf6E85E6kbhWMPcFSNlp
         o5ESnJVLjTTnwwbBYRigpD6fz5CDFtnR/lZ0N3XnTqocIZ6sEuwVH/6X0rSV83/binya
         C4Mw==
X-Forwarded-Encrypted: i=1; AJvYcCWvfR9hkh+I/AVqFOR5K8yTlPN/8n4eXlvPovbMJGZanyG899h/1q12RFiqibDVKcZqraIzXW8tn+17oZhatUeXiWu8oE+CqQ==
X-Gm-Message-State: AOJu0YwAE0mFojhNInVxAplV4ngy4hUmFEZQtd96/4e5vyWXa650g02r
	YdJNpqTtlNGVaFNkqcgjzrqaRwN168brzvF7LE/jhwFrvBCFkI+bUduHmzR874nneQXpC8VCEuE
	A6UyIteflci5lfivs3kF8UL53wuNv8786C9x2Ow==
X-Google-Smtp-Source: AGHT+IENesLG4K4Ju9cg8WUlmWLdmGq9gf869Rf3CwWmTmy3QIsoXCSMZMN0dJOClRuFlKsU5XQeLs3bBYpB5bHdlnw=
X-Received: by 2002:a05:6122:3b1a:b0:4ef:54dd:c806 with SMTP id
 71dfb90a1353d-4fac1a87d45mr1092536e0c.7.1723527940317; Mon, 12 Aug 2024
 22:45:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240812160125.139701076@linuxfoundation.org> <f514502a-0e89-4fcb-95c4-986a3cba2342@roeck-us.net>
In-Reply-To: <f514502a-0e89-4fcb-95c4-986a3cba2342@roeck-us.net>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Aug 2024 11:15:28 +0530
Message-ID: <CA+G9fYt5DQbDEEtC8Oq+ja+vbTRxQVcabsoxfz35nSQDS27KRw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/150] 6.1.105-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Aug 2024 at 03:13, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 8/12/24 09:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.105 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> > Anything received after that time might be too late.
> >
>
> Building parisc64:C3700:smp:net=pcnet:initrd ... failed

As Guenter reported,
Parisc builds failed.

* parisc, build
  - gcc-11-allnoconfig
  - gcc-11-defconfig
  - gcc-11-tinyconfig

> ------------
> Error log:
> In file included from /home/groeck/src/linux-stable/include/linux/fs.h:45,
>                   from /home/groeck/src/linux-stable/include/linux/huge_mm.h:8,
>                   from /home/groeck/src/linux-stable/include/linux/mm.h:745,
>                   from /home/groeck/src/linux-stable/include/linux/pid_namespace.h:7,
>                   from /home/groeck/src/linux-stable/include/linux/ptrace.h:10,
>                   from /home/groeck/src/linux-stable/arch/parisc/kernel/asm-offsets.c:20:
> /home/groeck/src/linux-stable/include/linux/slab.h:228: warning: "ARCH_KMALLOC_MINALIGN" redefined
>    228 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
>
> In file included from /home/groeck/src/linux-stable/arch/parisc/include/asm/atomic.h:23,
>                   from /home/groeck/src/linux-stable/include/linux/atomic.h:7,
>                   from /home/groeck/src/linux-stable/include/linux/rcupdate.h:25,
>                   from /home/groeck/src/linux-stable/include/linux/rculist.h:11,
>                   from /home/groeck/src/linux-stable/include/linux/pid.h:5,
>                   from /home/groeck/src/linux-stable/include/linux/sched.h:14,
>                   from /home/groeck/src/linux-stable/arch/parisc/kernel/asm-offsets.c:18:
> /home/groeck/src/linux-stable/arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
>     28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */
>

Thanks for the report.

> Guenter
>
