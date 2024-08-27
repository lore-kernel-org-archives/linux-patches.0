Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551351D1739
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724780879; cv=none; b=Cd8sZrBcMb9Xsd2KkpiFM6SQLboRg5U72LwJXDcy/x8r/kA/gxGDF5eo5gNosa9UqWz2hcBqCF/63O7nNerQUfMUT1Q0mUoYIhxrx2t1ZWJe9IcNs+pRzFZNCkvgy6KuFytO7SvyzIk1dhcmoUe8JDaPVWOCOQkEtKZmOhs2FkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724780879; c=relaxed/simple;
	bh=dYHoc8tAXja1j/gy+quwz+VAVNvuZkG5hw3yiikQ1eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OB1wfOTCsPQYH0Ci426bO/4mEa1CZ8PJ2+aSjLwDZofMY3vMhAj3VyWyjVNggFGLcf9Bs+t2YUjfoTNbNG6UrExKclH9KGM2thtn89HnF2twoEIvksHHgJbMMHbw3+xzfyD3YHxs0wFferRG6p1hmK86qQQwLqn+1FZI7LdFVy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TzrJi3R0; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TzrJi3R0"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-714263cb074so4039533b3a.1
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 10:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724780876; x=1725385676; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HCUSrgJ+TJUnurxjMntJCkv6+wXwXOpsEspjhz3H0Yw=;
        b=TzrJi3R0EpiHDDNOsQffbyNuQq48bkq7vtPV3P+dJTYdp+/OsYvMibO4UOveybdKvA
         Gi3d+yijwInyx6Sj4DAfto5JWG0p6n25YZGRxba8G/43ILbXjkzxm1mpjJrwc2aaxrNW
         FbSZsNaXVAx5QD91j1+UCZP+dboZfd7u5+ZDguG3GfvzvWygJO671bUxCykDOzsy5Ssu
         dR10MgQj4bvt0mWXKtlcL2BVx9RwuEr/1lG474G69XQUbWZHEz19fIEnuHWMhf7WsGFH
         WT9FYly7ShJcYXPwMdGlvFuZm7fNuWR2PiowQYTFzwKOf6GJCKPprtu3h0WTDQV+IcVk
         LoFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724780876; x=1725385676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCUSrgJ+TJUnurxjMntJCkv6+wXwXOpsEspjhz3H0Yw=;
        b=O4ZCHCpX56oB6uLCnpr4G6evxql4GkrQqG0WJtGzhI/UbgHq+o3xcuKXGaLA6qpDrl
         XaSF1mRuYKjxo3uRfhFA/kLFokeIhT7aBGG7oZdK4zzpRFIzUTATOcJE2szD8NPSF8Bm
         yURv549BYvNkrj3sIkYO1f8prEvC1QFWgoTVYkCat7CIEPBuYjrhlTBl0g3cp+WcePR8
         HenzBR/VyLq90MTr2csf5YE4TKsBbnjI/UvsCifQlCpA957GgdwBdqGK8mw3vft4S6ME
         7upm6NrTe17Y+pq5Tgt6lHPyoh8AcgeKjByrEBLs/HSpVrqu4Sm4lrrWEBOcqUivZDfd
         CeEA==
X-Gm-Message-State: AOJu0YwVGL6l5N4ebo97l+VdwF9HI2Me/SocmO82PEgepLGiHQpaGnf3
	re2C5S/U2TnbcV34o3d7ERoHSAE+YfZGytOETu5X6NuItdshARdG
X-Google-Smtp-Source: AGHT+IES6okLZnfj/yTGFxwPWh7nsD/tI3mz++Ei4dyFWneiXSsFd3im9erE2HEYmM+cxnd9sViCiA==
X-Received: by 2002:a05:6a20:4f18:b0:1cc:9f24:3d with SMTP id adf61e73a8af0-1cc9f240253mr7540278637.25.1724780876432;
        Tue, 27 Aug 2024 10:47:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2038556686asm86076995ad.40.2024.08.27.10.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 10:47:55 -0700 (PDT)
Message-ID: <ffd773a0-d71c-4647-b7de-b22a008849ab@gmail.com>
Date: Tue, 27 Aug 2024 10:47:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143843.399359062@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/24 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.48 release.
> There are 341 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same problem as with the 6.1-rc, perf fails to build with:

In file included from ./util/header.h:10,
                  from pmu-events/pmu-events.c:9:
../include/linux/bitmap.h: In function 'bitmap_zero':
../include/linux/bitmap.h:28:34: warning: implicit declaration of 
function 'ALIGN' [-Wimplicit-function-declaration]
    28 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) / 
BITS_PER_BYTE)
       |                                  ^~~~~
../include/linux/bitmap.h:35:32: note: in expansion of macro 'bitmap_size'
    35 |                 memset(dst, 0, bitmap_size(nbits));
       |                                ^~~~~~~~~~~
   LD 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o
   LINK 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `record__mmap_read_evlist':
builtin-record.c:(.text+0x13578): undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `record__init_thread_masks_spec.constprop.0':
builtin-record.c:(.text+0x13b10): undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
builtin-record.c:(.text+0x13b68): undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
builtin-record.c:(.text+0x13b9c): undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
builtin-record.c:(.text+0x13bd8): undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o:builtin-record.c:(.text+0x13c14): 
more undefined references to `ALIGN' follow
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:672: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1
make[3]: *** [Makefile.perf:242: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:294: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:29: _all] Error 2
-- 
Florian

