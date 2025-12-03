Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEC12857F0
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764787884; cv=none; b=WrDl54MiaVJsz5RduL5VDh9UNq/YRK2tGwV5M8eeTYLVg8xBlWkIPG3qjnM/SHKqLJmp0xijE9XzEMtypvtMeEeMUcIM89vhFCmBrWJVx2+Jg0Dvk53GA2pDAcbsY1ufL8dq+ElIdl+CAieLI00ufIwmo1ruoeU9TvgTTzdEURo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764787884; c=relaxed/simple;
	bh=QXm302+o5a0ZYeYH3FaCt6FMEyJjQFcbWTFDv7BUu+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lAqtk6f6mguIV7SO6TC+RKSoFAmBiXLpcdBnU8ZrHoBsUaLWgGNlLvoTlqvhzOXg04h5kXIKTJWj2zog4U6nX2MJHP3H32779rDKdVZ5BKIVG6qIwzPvwxJcsDQOMVbOhBa+2ZQkzJq2R3cDd0VVHJ7KlAhahE7XGWhxJWObgCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVEUT+4o; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVEUT+4o"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso1270151cf.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 10:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764787882; x=1765392682; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vneXqvh/pIxTidxgJq0zgl3mLEwdN7DCTjPVK1bMrl8=;
        b=eVEUT+4oCSntBX9k8lT4mPYnyBAU5zmMF5+Rv3KEtbbv48+jnKeRjJ2fXQZOOZWGXh
         5sUMSMkH8+TpIAGwUgjyJAT6MIueYv5TIZXRwtk18ZlzwoUcg2v85YiDoAP/PmiKYX86
         BVL9MZNSMENMYkiai7kP37QMPtMXYj1wgwgqw04R59dFwYBRIc04n/fuRS8fxX3u+GqR
         4wlAZXVPfslzwYsVwK68ttT6HnOychUh/NIOCrR2nIOpMohI9rXTI6lUbwvXXj8EuFhM
         75GvfOf/2oQvMkXR2metk3ahiuV5f96O6k+ptkNF5fOO53+IDJhkZ5xDA+IYJNn/Ci98
         uZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764787882; x=1765392682;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vneXqvh/pIxTidxgJq0zgl3mLEwdN7DCTjPVK1bMrl8=;
        b=UytOEA1FCbCZLNh/UCEcQ17byv78BMG3x3tx1mD/3BnSlP0fEtSIql/h84TDc349lR
         wDLNBgow3YlP63wyNZWt/PEmBPNDcksebnLWglGtXx3ZZA4ymSHAEHfHMHtWHSX2GpQS
         60+6NVelJdjx/Ot+I+jX/95gzfFUJH92sDLbxFLt5JDc9LGPq0Mgrg53kXoP5ZRQzhDh
         yOhMwQR2gk912riBLORAG8UXVHSUmiFfOE0+gXHEPbKl03aV1FNMsCsPGA5WBOoLt1JB
         FozpolEH1sScIHweJJRr4WVVVLuGB8mSpCbQn4xTwf94mXTUp3BHbqkGeTeadpBdDKtO
         Sl0g==
X-Forwarded-Encrypted: i=1; AJvYcCXAr5aAFkuwjIcynlzXlGF6PvuGm4rXPbQvmURXJovOunCdOVCouPeTXNi0RWnQ7gyNeshcD+GD@lists.linux.dev
X-Gm-Message-State: AOJu0YzP5afB0edlCY0wIcwM+7OEVIrfArKhbUe85XrTpmYuCkublgcZ
	KGOeUSZsEhdXSvcOeHvuoTU9DqBfaeNbT5UQmOn07jJL13Sa+w9dw0Jy
X-Gm-Gg: ASbGnct2JRWbGtUlDffwkO7oezWZ4v1VWLE2mJiwF6+T5QglvOK/jcNVjmc+DAafcee
	ZlE2TQ30eJZYPS2TIK0yBrFdQscS/blt+OgAhLxAgyAhLRjHjbPUzYM5bDDV/3VMDSdvw7Femv6
	+P4wsVaGm2i64RWa1xznA9Wye/IHVwE0Q9u0yzOa9vFqa6eDVFAoFz4Pbv9qB0yjEz4n+3W13LO
	PL2iQwmOzNL5YfmXW2Qn/KHvQi8ykQtUlfR/Z6duGtVFUpouQ+oQAcHnO0hiSYvEUsseQi2i4Jc
	85TrXG1X04PNP2IBCXAEt3I2RQqoABcueOLNuHFDKywGYwLraB4tXIgYXuZeh5s4w3+nwcjiX2J
	e0HzGkAcO9xw1QbUSbSDfdSCqP3fjp3crXei5MRqEZR+8tSbPuC0pX1lulJ3j0F8q872BM6XHwG
	acenjKnD/Ua2JOO7rZK2M2kt9w9HuUBtjfUffIMg==
X-Google-Smtp-Source: AGHT+IGab/pTxYMr3TuHQAKMESlS+5teSINCikkt17TTEDl6V4+8NTN45syRoK4GBSjTEsnDs4AjGA==
X-Received: by 2002:ac8:7d89:0:b0:4ee:4128:bec0 with SMTP id d75a77b69052e-4f023af7a5fmr3142921cf.69.1764787881872;
        Wed, 03 Dec 2025 10:51:21 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f018a76c0fsm17172641cf.14.2025.12.03.10.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 10:51:21 -0800 (PST)
Message-ID: <b4d4d33e-07d8-4868-abc5-4161a63bb948@gmail.com>
Date: Wed, 3 Dec 2025 10:51:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Mark Brown <broonie@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152414.082328008@linuxfoundation.org>
 <41e4124d-8cb3-44b9-871b-8fa64b54b303@sirena.org.uk>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <41e4124d-8cb3-44b9-871b-8fa64b54b303@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 10:46, Mark Brown wrote:
> On Wed, Dec 03, 2025 at 04:22:30PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.197 release.
>> There are 392 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> I'm seeing a build failure in the KVM selftests on arm64 with this, due
> to dddac591bc98 (tools bitmap: Add missing asm-generic/bitsperlong.h
> include):
> 
> aarch64-linux-gnu-gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu9
> 9 -fno-stack-protector -fno-PIE -I../../../../tools/include -I../../../../tools/
> arch/arm64/include -I../../../../usr/include/ -Iinclude -I. -Iinclude/aarch64 -I
> ..   -pthread  -no-pie    dirty_log_perf_test.c /build/stage/build-work/kselftes
> t/kvm/libkvm.a  -o /build/stage/build-work/kselftest/kvm/dirty_log_perf_test
> In file included from ../../../../tools/include/linux/bitmap.h:6,
>                   from dirty_log_perf_test.c:15:
> ../../../../tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsis
> tent word size. Check asm/bitsperlong.h
>     14 | #error Inconsistent word size. Check asm/bitsperlong.h
>        |  ^~~~~
> In file included from ../../../../usr/include/asm-generic/int-ll64.h:12,
>                   from ../../../../usr/include/asm-generic/types.h:7,
>                   from ../../../../usr/include/asm/types.h:1,
>                   from ../../../../tools/include/linux/bitops.h:5,
>                   from ../../../../tools/include/linux/bitmap.h:8:
> ../../../../usr/include/asm/bitsperlong.h:20:9: warning: "__BITS_PER_LONG" redefined
>     20 | #define __BITS_PER_LONG 64
>        |         ^~~~~~~~~~~~~~~
> In file included from ../../../../tools/include/asm-generic/bitsperlong.h:5:
> ../../../../tools/include/uapi/asm-generic/bitsperlong.h:12:9: note: this is the location of the previous definition
>     12 | #define __BITS_PER_LONG 32
>        |         ^~~~~~~~~~~~~~~

Yes this also affects building "perf".
-- 
Florian
