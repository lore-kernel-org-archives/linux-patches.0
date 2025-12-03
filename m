Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0073446A5
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 17:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764783205; cv=none; b=I1yPdQ3hZ0Phd3IWmI5MniNVoB3kNFIHNbt3JMvQKoJ4lSRqzYvEViL1ZKTuy9+Dcu2WyffeOLqTuAH6gnRXEojPP2sOAH8lJf2aTeVmr+cnH2hu5h7JLFMvlS+Ai+ZOFsjSGxeI0t8gFY/zmf3X8UudDDFHRQsnPsm5z84oSBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764783205; c=relaxed/simple;
	bh=sjUmzhwrSpbGiFQFS+CfvvfSPMIH1gw++YX7SKEckOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MNh80sIPqd47Rw7EhGp7HYr5zkl9ehptSBVSTSzIFM+0aeifMj15jx3eZQdr8JviWun8JI2/Ic2RopUDpfXcE/uEdKVQT25dMV/J8Osy2GFY+DTCTAd1mGL+WFZOp4Vj1y9JFmdHYunchyFopMni98IflroYyMpJIgvd1gpmrAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXCagpCF; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXCagpCF"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2d32b9777so849801785a.2
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 09:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764783203; x=1765388003; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAySZyoVUYZcty/scbJ6Onf/leg2X+nER5+BrR1/QFw=;
        b=OXCagpCFuL8ibTrISk99dFFep+efq986gpj3P85wqs3O4Mket2NxY9ScC489BTBg8r
         u8OIZF2wqlzaRLUOqOsJar28ALJLbBvNEFH430CZQ05+MooUgKU6GSumBSci7WqY4KRm
         yuws8LelxHPXCDwHLMJn/ffgqQi3JHc8ybSN8wgx2ubXwwzyPGnRg+i6kNSQcHEibG7h
         Kc/H/5EZyTcQWiXjRLEvkKczDzS0ixZA7VI1v9AsxDmAPri0nKctDvQo81dxkVzHgWpY
         d8AbnuJkzUx+mttgyR0dMQ+I4bdeudw4NF2yg/eth6N2xXCAZ+fzSDgPDQ82VcRYateo
         eRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764783203; x=1765388003;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fAySZyoVUYZcty/scbJ6Onf/leg2X+nER5+BrR1/QFw=;
        b=wIPR++OkReRkIJD6JKteEEMs/WOp+HqeNxvQKN6kQGH3utTtDVGnPc/xKG4UmqBxyV
         gANrEroyScxkmEyg7C3Lm/KuzYUBDYyfGyvoGqLQEdb5YC1jImXssgafC970dLWY57Fm
         sUou3msC9PySdMegRrn6I4QWc1ptdiAIf3T8Q5VSxrf1HldmwNY1yw/PPPgTnH0BNERA
         S6pPFgYa0eIe+TLFL+ieZWAb7cRI03l06w7ZyF9Q829XEzZ05DVRkmjdoI5KRScX4IsQ
         zvHoaY+mMgzcP3R2ET90k8V4bYK4ApBZam+GIvJzUUsNH4HqLTIXJWH9ZsOZJWsAydKI
         ia4g==
X-Gm-Message-State: AOJu0Yz6yXlQffGXm2hhEmIwSOtLLINHuCjI1XdSRTO9CPSJzYt1zJw9
	aW2vnETgc2aGNUcoFW4WaHp5i6Bfv5kSILM+f89lN+2fHxmteGqbXjPtL2jGhg==
X-Gm-Gg: ASbGncuhTrz6MkxpjmtSUvFaVb99y+Cv4xvsEI/6l4Yxnv8iDBpOfvqX/6JDejyQ1hd
	jCQFsk0XyYgShDUSnLhEdE6CkWTUJWPg8yEaPH3UtNtAm1a0BbULJstx7Mmd3J11JIqYyDxy41P
	drD5nHuizu+Oz1dzrJctS4gHxQAhLw+9mSrc4yiqRSnv+3ubxE2Dy22TT1gozoTNxJ2AnMjZBmF
	t74Mq1w1hYz1Kc49u9BFYj1MeT0iA7PQ4Ub+SumR+Vr07zsyG3/rRsBN8JSepFTmXuGR4OdmTfB
	uEoBBXaUsYQjhoC7sainqS/6fJwYXdYYTS45d9dx/r2HGPcweHLOrnqjtMOeYQBj3UeHLI06Uaq
	poqYGKpepPh/1TrfqST1ZwkFv5RqhW/Osl4NWKWCvCg8HG8LPzQ9eI/stpMC8vdwJ796JqqPlCo
	j7oi2Hchu+n3fxnGB1JHriOGXd+f3vMNbqGCogzg==
X-Google-Smtp-Source: AGHT+IGr/13cEMHjcnMqt4Gm84Jo/I/ZJcPV6vXbwW6ARVpoUUQCSul2/FTG3CF5U56R7EkUSB7O+g==
X-Received: by 2002:a05:620a:7082:b0:8b2:effe:b4d4 with SMTP id af79cd13be357-8b5e7451300mr436873885a.78.1764783202619;
        Wed, 03 Dec 2025 09:33:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b6f72sm1342785585a.29.2025.12.03.09.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 09:33:21 -0800 (PST)
Message-ID: <139db995-0ff6-49f1-b7c9-9c213bf36e35@gmail.com>
Date: Wed, 3 Dec 2025 09:33:16 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/300] 5.10.247-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152400.447697997@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 07:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.247 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.247-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

MIPS fails to build with:

arch/mips/mm/tlb-r4k.c: In function 'r4k_tlb_uniquify':
arch/mips/mm/tlb-r4k.c:591:17: error: passing argument 1 of 
'memblock_free' makes integer from pointer without a cast 
[-Werror=int-conversion]
    memblock_free(tlb_vpns, tlb_vpn_size);
                  ^~~~~~~~
In file included from arch/mips/mm/tlb-r4k.c:15:
./include/linux/memblock.h:107:31: note: expected 'phys_addr_t' {aka 
'unsigned int'} but argument is of type 'long unsigned int *'
  int memblock_free(phys_addr_t base, phys_addr_t size);
                    ~~~~~~~~~~~~^~~~
cc1: all warnings being treated as errors
host-make[4]: *** [scripts/Makefile.build:286: arch/mips/mm/tlb-r4k.o] 
Error 1
host-make[4]: *** Waiting for unfinished jobs....

Caused by:

commit 97ddb0e2389b4a53d395ed47ea83540ff495d1b6
Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date:   Fri Nov 28 16:53:46 2025 +0000

     MIPS: mm: kmalloc tlb_vpn array to avoid stack overflow

It seems like we might have to cast to a phys_addr_t before passing that 
to memblock_free().
-- 
Florian
