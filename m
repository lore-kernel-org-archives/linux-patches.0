Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0391914EC59
	for <patches@lists.linux.dev>; Mon, 12 Aug 2024 21:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723498983; cv=none; b=uSqKQs+ne8gAdBiueeNOu6Nzg+qc2InPggtKi/XSPB8Scz2mNz7x10Ti8gynDv0ge7i/5Thu9EOFfXcmGR6nfdJgmBioBG8qzr01wlVu5d2nkYHjloyVAj+yATqtSkNffKhP56RBuU99hfEO/hSmr4lr1hrLGkQpYYEGW45YHPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723498983; c=relaxed/simple;
	bh=wBFeX6FPGRM45SSxmDuM+3/9hZ2b/QoAYqXwuvlW1kU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f40e1KqQi13uNiHAyEx+H4tW0zrGQDTYP3+5nS3sLPvDpQaSNDAi7uv7e3Twv2Vormunx3JYcoKqOi3PQ9nodsXL4K0bl/zf9vwTx8uw3UbHYg7goJXkN+qmrp6nBeArq2KhHZ3hVf6CwBaZ5mvSfpCed2iOVdvd/xpXOa0yZH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L5Z3JzLc; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L5Z3JzLc"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2cb5e0b020eso3748582a91.2
        for <patches@lists.linux.dev>; Mon, 12 Aug 2024 14:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723498981; x=1724103781; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rbp++JNvUR6aX3uiaZXnZPtpgQrZxet6aSiPIDTv52M=;
        b=L5Z3JzLchWWWd4MnPci1G7CWLumjYm3iI/nu1BHSyxgvNpu2/8jRbOz4nriqDHTaV4
         c8ttq3PDzd9aPyNgXyDuUpvNVludUyb3Q4q/RADI0sWAxMLiNGsatcuWXRa094CIG46K
         Xlgj79//OklmMHTlz5PhFKuEiGHO+sj1wD0Y4x7BdzoJ+73xxNrbmYTXZRnLVjcNFmqE
         fD/nIdOAOwAwWyQReSRI5qqeEkvyrjvPVM10omtaqIgtoausJjGW7SF8AWrjvPTCWrlu
         nCUVotBFaf3wSN9GVWO8RjAKnTodnIuwILl7jpUf1d47jI62lxhsKLgpVZ6ea3hH4pWv
         fi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723498981; x=1724103781;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbp++JNvUR6aX3uiaZXnZPtpgQrZxet6aSiPIDTv52M=;
        b=Ir+CiLQ8S3R1fQy8Y6+pGDSHWoXWk958ngAXXGbG1XzGO/U/R/gcI5tE73fgVeJ5PA
         /8Np5npiJWqFxcUlWDuRE6cqeB7z2h4qp64FWcNuI+XoDcu2gzBuGfVinhEMlJiPYCpe
         zhtvRJZGKHF18aJM2a9DCoHfv778k9XCc054vWPa3f6WlmSfZI0RN9r+RDXJgoZYL4qn
         kicFC4m/rsEUgdtLsvtZjVaMFT5uLHobJnH4NRz9bD8AdfQefDWztZHVu3uEbbq7q0gY
         TjPHupGwtAvz+u7H19u4Pg/5jExlTDZp3LPAvJAafBmjqSNRMmb6UFUNQL7FW9wzMLw4
         HbYQ==
X-Gm-Message-State: AOJu0Yx3YY+78uxYOKL9mNVjYj4os4fR2fnrMjjwrsd62ZtG2iu7mWJ6
	uRZ0IS6tvYHMORoO5487E0Af6aLs/iVNeARRpvuUSFJ0t3/Dy4Ct
X-Google-Smtp-Source: AGHT+IH1hD0/oBAF+L+6/VeKCppQioQJBRK7AMZZR8Mze68EcNdguNRWGeokVjdJ+6pW8HNS1k/3zw==
X-Received: by 2002:a17:90a:c914:b0:2c9:8891:e12a with SMTP id 98e67ed59e1d1-2d3925407fbmr1763845a91.23.1723498981115;
        Mon, 12 Aug 2024 14:43:01 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9daf76dsm8894653a91.36.2024.08.12.14.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 14:43:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f514502a-0e89-4fcb-95c4-986a3cba2342@roeck-us.net>
Date: Mon, 12 Aug 2024 14:42:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/150] 6.1.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org
References: <20240812160125.139701076@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 09:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Aug 2024 16:00:26 +0000.
> Anything received after that time might be too late.
> 

Building parisc64:C3700:smp:net=pcnet:initrd ... failed
------------
Error log:
In file included from /home/groeck/src/linux-stable/include/linux/fs.h:45,
                  from /home/groeck/src/linux-stable/include/linux/huge_mm.h:8,
                  from /home/groeck/src/linux-stable/include/linux/mm.h:745,
                  from /home/groeck/src/linux-stable/include/linux/pid_namespace.h:7,
                  from /home/groeck/src/linux-stable/include/linux/ptrace.h:10,
                  from /home/groeck/src/linux-stable/arch/parisc/kernel/asm-offsets.c:20:
/home/groeck/src/linux-stable/include/linux/slab.h:228: warning: "ARCH_KMALLOC_MINALIGN" redefined
   228 | #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN

In file included from /home/groeck/src/linux-stable/arch/parisc/include/asm/atomic.h:23,
                  from /home/groeck/src/linux-stable/include/linux/atomic.h:7,
                  from /home/groeck/src/linux-stable/include/linux/rcupdate.h:25,
                  from /home/groeck/src/linux-stable/include/linux/rculist.h:11,
                  from /home/groeck/src/linux-stable/include/linux/pid.h:5,
                  from /home/groeck/src/linux-stable/include/linux/sched.h:14,
                  from /home/groeck/src/linux-stable/arch/parisc/kernel/asm-offsets.c:18:
/home/groeck/src/linux-stable/arch/parisc/include/asm/cache.h:28: note: this is the location of the previous definition
    28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires 16-byte alignment */

Guenter

