Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A21AA1D8
	for <patches@lists.linux.dev>; Sat,  3 May 2025 13:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746277438; cv=none; b=nuHBuGn4LG21tO7QMx6kvJlwJxgxS7Br397VJ7buYlYupibdNUSmpMT0nfSyVrxrfBP15j/1bMhkfUemX4YJwzlejTq46iZQ/ICLS4Knt1p8HXwuVXtgqRFpNAip1jKcNWOhb3O2p8uZ7+rtrKacXYRaokFwbRh0WI+y0mOOIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746277438; c=relaxed/simple;
	bh=bc1H7G7SKC9hb+Zvw3wkuYkxicUKo7oDVTVJFB266CM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1vX1wBKqvkkCdGGgWHlz1fZ/Aez/sja0dM8nfBORAB+tyh2M0wJybMJ1VwxkPc/MBVkJDn5SbuLF05ig7mQFxxot8NQrTz5L9sZamLJ9ZeaVA+zJMUti0WJdrrj75K6imcCx+xs03mTk6w/fxVFpFleoGlpiYH3Vff9hroofjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEo9Ng0V; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEo9Ng0V"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22c33677183so35592355ad.2
        for <patches@lists.linux.dev>; Sat, 03 May 2025 06:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746277436; x=1746882236; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IIrDRchZvQGY9mZIZCkBaIRsdI4f6csmhNYM7f8RYQ8=;
        b=GEo9Ng0VtBUzK8olAyUz+gdtOm9Zx2d+pd69nGLQvzZNcThp2WZHl+Ls+Q41ryhmcN
         VzjzUfV2/q8jIGrfIWsRWwHt4XaDhS827yiWoAiNAqsd3xHbznczwAgLFUDpMh1pCslf
         R51zHIWQdrUujNEXXkyvqAudFgaWf7LlRcIm56RYayloIsHPeIDpnPGy6JNsLE462mI7
         Sce1Fyth3SByR7gpVu4Oq37oKsD/14uy4kfepoyEC4Oenhhs3dzvlg8vYI5FaJ3vToHA
         RcuMQAsC8bgjbD2bJn35yd3l4G0XOwKb2+1eyxLmAR4Wmn/AmbfY7GH3tTjbjOinqMtJ
         hs4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746277436; x=1746882236;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIrDRchZvQGY9mZIZCkBaIRsdI4f6csmhNYM7f8RYQ8=;
        b=fRT6V5TqPnn8XdUzkkOOg3RP2FgvmweeZq+hvThjTWVN0T9XcLEn+FP9oMb2rVVhCt
         tGKx7eily+VCCKCsVpQi1SaqYBX6sQYJTFXoSVSnnDjUfmcf3Nn04x8z8E+Blz0drgvh
         kPfJAooYtCtEdf5+cQ2/sOkwnbhzxXtqAD1/CdThRCHovysWwB+2CwR4ffSqYlx0JDaj
         bKl/xx05ObEIcYsa4l1BZQ12cD+/FXOrWJ3wVtRUm+m8rnMoYLvCCHjFbZr3bXk3136X
         +AnknQ8zxpzwvAIkDMMLh5Jv0xGgbmdmVROS3BKU2aWTCPQhz2UWmIaZPkfIvmdD+ZjO
         tj5Q==
X-Gm-Message-State: AOJu0YxwuZTKDzTSAb/7fhSFDnrKRBJ5+5667LhTMxJa7DBKJy7tNagM
	fXCQ6cTd9F9tT0w2Pwdmp2banbSbwk0yu2bFwvehSR5xgAsPkaUF
X-Gm-Gg: ASbGnculQzcvrXDhF5klwf04zW+JXz1QxqLz5v9Zg2g8fRNSlbu8uKwIXOU6vsHkqjc
	Y8RP8l+aSdp2PUv43NKwsLNlSmz5qhszjP+21agMPwShBjSMg2sTkDy8hKEnAFNeK9d7nV3qDXT
	MO54J+sepZfbezMNR5OPuM/W8jwMoPDjuVE3zv/DIGQOUY+xGv/i4hlEf56830dBSuFhaEDa/x5
	ifAclbLKiX+nVmbfMew8H/s5GcNASvi/hGk7fNs/LClWoEMo+rGih6uA9H3C3AiZ63npoyZbXFH
	34F8ZAfq6foGlf2DmY0PAwoWVEbKjHmkvjgm/Qe5e2nGCFdcae4EU0KV6Pm1AMFOljD2vmvg2vl
	e/BBDDEZwRh2joA==
X-Google-Smtp-Source: AGHT+IG3vnG8591JtW6TBou0vmfxH/iOyzUBh4p2XcUUz9bCtHb2wyRPKzrzPwfhJt04kYeTrBgVjQ==
X-Received: by 2002:a17:903:1904:b0:226:4764:1963 with SMTP id d9443c01a7336-22e1ec39ed5mr12653925ad.51.1746277435868;
        Sat, 03 May 2025 06:03:55 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fd4fsm23470175ad.146.2025.05.03.06.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 06:03:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f978ec9a-b103-40af-b116-6a9238197110@roeck-us.net>
Date: Sat, 3 May 2025 06:03:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250501080849.930068482@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20250501080849.930068482@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 01:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:08:16 +0000.
> Anything received after that time might be too late.
> 

Building loongarch:defconfig ... failed
--------------
Error log:
arch/loongarch/mm/hugetlbpage.c: In function 'huge_pte_offset':
arch/loongarch/mm/hugetlbpage.c:50:25: error: implicit declaration of function 'pmdp_get'; did you mean 'ptep_get'? [-Werror=implicit-function-declaration]
    50 |         return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
       |                         ^~~~~~~~
       |                         ptep_get
arch/loongarch/mm/hugetlbpage.c:50:25: error: incompatible type for argument 1 of 'pmd_none'
    50 |         return pmd_none(pmdp_get(pmd)) ? NULL : (pte_t *) pmd;
       |                         ^~~~~~~~~~~~~
       |                         |
       |                         int
In file included from arch/loongarch/include/asm/uaccess.h:17,
                  from include/linux/uaccess.h:11,
                  from include/linux/sched/task.h:11,
                  from include/linux/sched/signal.h:9,
                  from include/linux/rcuwait.h:6,
                  from include/linux/percpu-rwsem.h:7,
                  from include/linux/fs.h:33,
                  from arch/loongarch/mm/hugetlbpage.c:6:
arch/loongarch/include/asm/pgtable.h:198:34: note: expected 'pmd_t' but argument is of type 'int'
   198 | static inline int pmd_none(pmd_t pmd)
       |                            ~~~~~~^~~
arch/loongarch/mm/hugetlbpage.c:51:1: error: control reaches end of non-void function [-Werror=return-type]

Guenter

