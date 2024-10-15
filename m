Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64709474
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728976712; cv=none; b=Ng1TVqwHmKjN1rt2e47a8OOD5BGwg/vFemRngGOuFgr6yjXYNFvKmDopAVwuDfqYjCt4iW55+1plEZaJKiFlo6gVi++TO18dnUcwyQJRtGfs/nmaY/paYv7x8N1CTq80TSsL5UX9MSFo+E7hAWJ75hLFL7RqR3hBrY7IzbPzUOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728976712; c=relaxed/simple;
	bh=4OOZYkyFgO/AQycLeey45cxHQ8gT2wl0zTCH9ILQSJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OM8zUIKqjPaqH7UXehpXJyZXSC5D1SQ1msVUihCIbOBWP5lbZ38yz87CqDXyLlftHJHgcPXsXeU4Oq85VRNzJIh7e/f4MI0XW4/ALTIklmsaO1v9e6vzriYy962LF08ZMa+nybx5zQC6o3Jg3c/+fPXDvxyikRRnhjlOChTL7LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42f6bec84b5so48451075e9.1
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728976709; x=1729581509;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSFoFVl0g4CE4dcMqFm1QdG+UafZHTTYiUNagjWmSb0=;
        b=bU4rFAgDAWL6KBKS3gqcwIjUFb0zrCVUYBHEZFtLWx8p/QJyaQaF6ge2OTVQsuT6kb
         hjlx3gcdFJQwMfqKqDiyWa7z+XkijZiwX+n01FYJehZQEoAl9z0Y23zHFMvMFNY26XF+
         jc/0x1wmjT9t8UvTmVkZmhc6rcDkSQzUnxwmQUy4lKIfvQUJQXO3Fv5aH2aQ/ONkkioD
         aTsWeDtrsvOz2jA4DAYzAZYETSzuVQ9IjyF9n0lhOBAQbMhAsBrAtHC0M5N+Pro/d4Qj
         LEIHVRciVC03I1rSgIgurEv/D6B704ERaN2mb15IvH1wfFGeRvNe+3nBUEw/NQ2cL05U
         HQ9w==
X-Forwarded-Encrypted: i=1; AJvYcCXCD5Do/f2YR8YxAAg41JWUeipmhTWQ/ZlMii88GaHvJso+boCc8av0QuDuewnDfaetXWcS92f9@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5ma3IFQ+9sShIBVBHTr2ir1cZi1Nk4A1NFLVqB/tiQ98/s/Pd
	wYoNNx0L+xElkZ6n2kuGNDbo0eXtYHkmsTJmot8Azbs0Ro7rbQ7i
X-Google-Smtp-Source: AGHT+IHpVrAsFcjZGEwRS8xD8fiBE1LFGxoGCmzt/kXflsSU/3usgD1drRuzyHjtxJyV9uI8X3y4zg==
X-Received: by 2002:a05:600c:5021:b0:430:5356:ac92 with SMTP id 5b1f17b1804b1-4311deaea4dmr120428625e9.7.1728976708578;
        Tue, 15 Oct 2024 00:18:28 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4313f56998fsm9007985e9.16.2024.10.15.00.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 00:18:26 -0700 (PDT)
Message-ID: <cdb9391d-88ee-430c-8b3b-06b355f4087f@kernel.org>
Date: Tue, 15 Oct 2024 09:18:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org, Heiko Carstens
 <hca@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Thomas Richter <tmricht@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20241014141044.974962104@linuxfoundation.org>
 <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15. 10. 24, 9:05, Naresh Kamboju wrote:
> On Mon, 14 Oct 2024 at 19:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.11.4 release.
>> There are 214 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> The S390 build broke on the stable-rc linux-6.11.y branch due to
> following build warnings / errors.
> 
> First seen on v6.11.3-215-ga491a66f8da4
>    GOOD: v6.11.3
>    BAD: v6.11.3-215-ga491a66f8da4
> 
> List of regressions,
> * s390, build
>    - clang-19-allnoconfig
>    - clang-19-defconfig
>    - clang-nightly-allnoconfig
>    - clang-nightly-defconfig
>    - gcc-13-allmodconfig
>    - gcc-13-allnoconfig
>    - gcc-13-defconfig
>    - gcc-13-tinyconfig
>    - gcc-8-allnoconfig
>    - gcc-8-defconfig-fe40093d
>    - gcc-8-tinyconfig
> 
> Build log:
> -------
>    arch/s390/include/asm/cpu_mf.h: Assembler messages:
>    arch/s390/include/asm/cpu_mf.h:165: Error: Unrecognized opcode: `lpp'
>    make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/startup.o] Error 1
> 
>    arch/s390/include/asm/atomic_ops.h: Assembler messages:
>    arch/s390/include/asm/atomic_ops.h:83: Error: Unrecognized opcode: `laag'
>    arch/s390/include/asm/atomic_ops.h:83: Error: Unrecognized opcode: `laag'
>    make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/vmem.o] Error 1
> 
>    arch/s390/include/asm/bitops.h: Assembler messages:
>    arch/s390/include/asm/bitops.h:308: Error: Unrecognized opcode: `flogr'
>    make[3]: *** [scripts/Makefile.build:244:
> arch/s390/boot/pgm_check_info.o] Error 1
> 
>    arch/s390/include/asm/timex.h: Assembler messages:
>    arch/s390/include/asm/timex.h:192: Error: Unrecognized opcode: `stckf'
>    arch/s390/include/asm/timex.h:192: Error: Unrecognized opcode: `stckf'
>    make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/kaslr.o] Error 1
>    make[3]: Target 'arch/s390/boot/bzImage' not remade because of errors.
>    make[2]: *** [arch/s390/Makefile:137: bzImage] Error 2

The diff of cflags used for arch/s390/boot:
--- good        2024-10-15 09:13:59.769479783 +0200
+++ bad 2024-10-15 09:13:39.393060183 +0200
@@ -55,10 +55,10 @@
  -Wno
  -array
  -bounds
--march=z196
  -mtune=z13
  -Wa,
  -I/dev/shm/jslaby/linux/arch/s390/include
+-march=z900
  -I/dev/shm/jslaby/linux/arch/s390/boot
  -Iarch/s390/boot
  -DKBUILD_MODFILE='"arch/s390/boot/startup"'




Reverting of this makes it work again:
commit 51ab63c4cc8fbcfee58b8342a35006b45afbbd0d
Refs: v6.11.3-19-g51ab63c4cc8f
Author:     Heiko Carstens <hca@linux.ibm.com>
AuthorDate: Wed Sep 4 11:39:27 2024 +0200
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Mon Oct 14 16:10:09 2024 +0200

     s390/boot: Compile all files with the same march flag

     [ Upstream commit fccb175bc89a0d37e3ff513bb6bf1f73b3a48950 ]


If the above is to be really used in stable (REASONS?), I believe at 
least these are missing:
ebcc369f1891 s390: Use MARCH_HAS_*_FEATURES defines
697b37371f4a s390: Provide MARCH_HAS_*_FEATURES defines


thanks,
-- 
js
suse labs

