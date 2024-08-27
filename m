Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C66981745
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724780783; cv=none; b=SDyCvo2EC627OHF1ttOYEMRQ6LadbDQZFSybLwU0LIzB+JSNaWNBhqzj9ur0uVsg/JAXRuX/9RwPsgLMR3NfozoI15YbeguYYa4b+Xe2lYAXopMl1IJCn0C5C/k/tm8p2J+kJA6xQALi/B5Fgik062UMQEwaBlODNoWP10arc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724780783; c=relaxed/simple;
	bh=eOyNGEmTLD27An2vpi67uo7UjKLCKax+jWOJwOGKrOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LD86wyYzauBUm3hA1oIj/PmEY5CTCaBbesV9ft6HxJNAcEv4Oji+vvBfTriRHIbLSd88tC0Me0GDXhA8kVxWRFct3omJJMtOpYPpXGNGya1T9mBxNNAJ84/A06zqOrFnNvGUCvXcrO0P/peOXTCT2VwrvYPqRz5UseYNTOCgza4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDzL/M6J; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDzL/M6J"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2020e83eca1so54997705ad.2
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 10:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724780781; x=1725385581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5s3YAABYrMbP+Js2IaEndStvu7oMvLUb7JcLN3rS6YU=;
        b=BDzL/M6JkcXEgOp1tTO45ZyP9JRaw0y2LwIOgquWLKVPk4CARFTeQp05crfrgslSFf
         vZdFaPc8Em8kQKgjyQsNYAwxf9vfV2rrv4nJckgdh6BNncry43QeZzqe2qECyMig/ysq
         J+cojnrwDcuxDe80R9+sWUU9AwEeJEpE/pe+A8b3ue3vk2oF4Ez3g+hK0u7lg+jX0kni
         G5bziP/aDkrTtjEVfUebCrzl/2LhG6LkR0KPyZZdDKM4ArGAEOmub5zQG0NaccRVg/eU
         bDzP4pY5nDc5BgqMEmthMB/FD57G1+mH7oZWGtPCyEyFtXWMMfJab03XmLk5q0+bCla3
         U2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724780781; x=1725385581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5s3YAABYrMbP+Js2IaEndStvu7oMvLUb7JcLN3rS6YU=;
        b=YOB/jouIHCmVRaz2UGIpReXvfZ8IDS+VSi4VSXP3sEdRxn0BgtDFGyhlB+fou3Owwu
         C+1hEuDVhM8+PEkqIvd2COL35lQoJ6zdDha4FzJZo2yWMQsG+el3nqSiAQbK0Q4WBhuV
         26USr7N6ZGPBkyY6J+Nzu4OyAJy2b5Y/c9t/Z2v/d0FJkpJlua15kGEg9lUc9pSA/OoZ
         FrqXm3WUSZKVmOOxdVe48SheJd0AEuYSXYZoSoZl1XuDcXa3UFdg57pMNnaFQT7cYX30
         iRBh0UH6rmhN2no2lAAMHvXmiSL9Z9Z1BYK/K55d7jJB3x83Cj4X74nRaZVuYrBc3gcg
         JOHg==
X-Gm-Message-State: AOJu0YwYkyx8KVtp+cHSPZOe7EdN7J2viVuLmKodNKYwHUUxWSXM5w4C
	rrbzKkMklB5t8Z+mreitD/W7szbGEbEhrmh1eTXGtBrGQnwUvh7z
X-Google-Smtp-Source: AGHT+IGwgC5fluupGUSSSCBjGFmyd2CCuVbz0MB5XZL5BC5ZQZh3Ak+CPzHAQ5WagxrDBmLdBcvsPg==
X-Received: by 2002:a17:902:cecb:b0:1fb:8cab:ccc9 with SMTP id d9443c01a7336-2039e4e8468mr129533605ad.45.1724780781284;
        Tue, 27 Aug 2024 10:46:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-203859f0121sm85724665ad.246.2024.08.27.10.46.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2024 10:46:20 -0700 (PDT)
Message-ID: <45689fa1-ad89-4360-9d09-c99597e17595@gmail.com>
Date: Tue, 27 Aug 2024 10:46:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240827143838.192435816@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/24 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Loads and loads of the below warning plus linking failure building perf:

../include/linux/bitmap.h: In function 'bitmap_zero':
../include/linux/bitmap.h:28:34: warning: implicit declaration of 
function 'ALIGN' [-Wimplicit-function-declaration]
    28 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) / 
BITS_PER_BYTE)
       |                                  ^~~~~
../include/linux/bitmap.h:35:32: note: in expansion of macro 'bitmap_size'
    35 |                 memset(dst, 0, bitmap_size(nbits));
       |                                ^~~~~~~~~~~
   CC      /local/users/fainelli/buildroot/output/arm/build/li

/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `bitmap_zero':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:35: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o: 
in function `bitmap_zalloc':
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:121: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:121: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:121: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:121: 
undefined reference to `ALIGN'
/local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o:/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/../include/linux/bitmap.h:121: 
more undefined references to `ALIGN' follow
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:675: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf] 
Error 1
make[3]: *** [Makefile.perf:240: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:294: 
/local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built] 
Error 2
make: *** [Makefile:29: _all] Error 2

This was already reported here for 5.10.225-rc1:

https://lore.kernel.org/all/96ad9bc6-1cac-4ebf-8385-661c0d4f1b99@gmail.com/

and it is the same root cause.
--
Florian
