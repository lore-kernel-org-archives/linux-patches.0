Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4121DE3D6
	for <patches@lists.linux.dev>; Wed, 14 May 2025 20:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747255641; cv=none; b=XmoN9d5JrC8oySXfuZjfH5pyG/9w7cV202Rb+F3xJSPoPCRWUtwKE1uhrOtPiUF2hpw0YsD84apw45pFHVZ7uEM4AbR9/HTXl48bmfoM0QoeQoYTA+NrdPxda7eQiYG51KMnzxte8RAcvxrrFs99uXNPtw4Bn0MDSHcxW/C1SA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747255641; c=relaxed/simple;
	bh=8s4k0AuPpCeYnVbTJcNtLPjbu2CtKFkPiZBd7kxJuH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TerMbFb6/0b8wupwx4gt3a1S/tdHdJccoIbSEh/BnB3vyftABvSSAuu8iayrZq1HZMU3I8nEt6ZmfHlx4glRX2ku82cgCNxbhoekNCkTRF1NGC8LLtRmgdvLoxCol+wFSP65gPIr0URJ+RpRvlSHRoTnAC59oHDl8r/L7JgyK+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0cW7/fD; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0cW7/fD"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-30df7c98462so278970a91.3
        for <patches@lists.linux.dev>; Wed, 14 May 2025 13:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747255638; x=1747860438; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=yqZtoMhgtAkMYZTJ9JntJG1rUnS0RQTY7ZMyliu0Sq0=;
        b=Y0cW7/fDJaXASNLcsN7DYuEq2SKTS0nQk71cJTSBD5uZ6MZ+9ztApiuwzQVMN5kwUj
         +aI/xU0nxox+0cLJnbU5Y2MVnwDeMVhPKjd+dPtYoBpP7gTitLezX1acVpv/q4+/CCRS
         r4vL7hKXBLMy8rIj+TNX2zcLYEo1Gm8Elo0H0W0nXNEeEr55R1FUWJmdM9Yzx8NsyJiV
         sdvvFNnucNu7/HNjtDgOYZMLnoZfX5MtiwtsaTV86/t020jzBtm3nC9hMLkdwW0wZVzH
         XvJP7n5pm706WKomQ2W+uWWN9W+eYfDdKPKimyPgvLJTtkFnt5F3vCe1zqvZga/NnsTf
         sznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747255638; x=1747860438;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqZtoMhgtAkMYZTJ9JntJG1rUnS0RQTY7ZMyliu0Sq0=;
        b=woUhPLcPENbyC2NGA1+mLB+DgD39GQ3u0onWb5i7fk7ZFoZlfSdhzAoobx8BkyPwfM
         c1gYCRHqJ+jO2q+8Vtxb6XQrRwwumW2O3YB11qgW4ljFLhLMn8UhUo+MCBZUS753H3RE
         L8T5CHz+gjcjNi60ZBZbkn3slOx7LtSPMr02faieSaApdh2aiiWPx67g3K7OV92COOI/
         MY/dchAdlcQJ6VrYHI0MA/e5Nq7O0tw8aYNrz+zTjAO3TmBppIcuQBXQbDyt00AkTaN4
         pXfkVemnUnAoR+EmngJnCCF87XhRsx45T9s8T5iigZnQ2xtrBSDZifVp6KunO/DYTEwj
         CruQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyODkNbOcFVCfD/4ewzEN2ISMuosf7H741oNDvXu5hD2g1+XeMXpno6LkxmifiAH4zYfVekOvw@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd3HYiZH3jiDph3RcGZKoHTaQO0EhOZYwX8ptWvyg/bd55yXlZ
	RfAiPUO+i3wwXpnuqrHKbKQf6i+CLJV/1WgQtoQx/oS3GgscZa9p
X-Gm-Gg: ASbGnctqjxpBmg6qh8qfXCiHQblOMV1awI8HoKnSwsdumAX/2piP8bwfN5iIJafCZjS
	u5Wp3iuG4p1CIB0CYsL5cygl4oUZZjI0Ym38CTc5b465S6TsZOFfrNwblaBPO7g7eihgQ/Tqe9h
	gCvyXJZjxDKcG4HEps7dyOKUQTjQ9iJfmDXVuiNaCcNxGm9x4rIIt9OycZvdBLZJJLQyDsUUfxv
	nEO0uTm8w0OGwVedfFpzHel9MwR9v+8m5Ll/gRlCnuwcP95EluC3JQMzK7edjhHi9YJf185sCtx
	YOvP+3XFbcEo7GBvSmWrkxtpDD/afeBOY9P3ZWJH5JlwHbRs2nSrphRAPsiEmnCT8FHEbn1ofqw
	lqYXz1Znjc7Z1pXMtOH0SFaDgRVnSdFAA0KI=
X-Google-Smtp-Source: AGHT+IG9j6gSupit9bAat/jSXs7+pnKLnNEXVkwPrPgcaQAFYHuXV4S74wJV5w2etXtHakVW5rorbA==
X-Received: by 2002:a17:90b:1a89:b0:2fe:85f0:e115 with SMTP id 98e67ed59e1d1-30e2e65e6e3mr6039908a91.26.1747255638286;
        Wed, 14 May 2025 13:47:18 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e3345e60esm2017829a91.28.2025.05.14.13.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 13:47:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <54e21b79-a7bd-4e35-ae0f-268daeda5557@roeck-us.net>
Date: Wed, 14 May 2025 13:47:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Darren Kenny <darren.kenny@oracle.com>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <2025051440-sturdily-dragging-3843@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 13:05, Greg Kroah-Hartman wrote:
> On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
>> Hi Greg,
>> On 14/05/25 18:34, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.6.91 release.
>>> There are 113 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
>>> Anything received after that time might be too late.
>>
>> ld: vmlinux.o: in function `patch_retpoline':
>> alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
>> make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
>>
>> We see this build error in 6.6.91-rc2 tag.
> 
> What is odd about your .config?  Have a link to it?  I can't duplicate
> it here on my builds.
> 

Start with allnoconfig and add configuration flags until CONFIG_MITIGATION_ITS
is enabled while CONFIG_MODULES is still disabled. Adding

CONFIG_64BIT=y
CONFIG_CPU_MITIGATIONS=y
CONFIG_RETHUNK=y

followed by "make olddefconfig" should do.

Guenter

