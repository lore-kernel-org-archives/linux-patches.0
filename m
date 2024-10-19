Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4E26AFB
	for <patches@lists.linux.dev>; Sat, 19 Oct 2024 15:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729351057; cv=none; b=UewoVc61xBaqHwUQY1aGgHZI+gWmVgGN3w3ekxIeyjXVO8vU6FTsFBKwBpgL2VgZdUxn1TTtKQ0kvNjHm3iqtccNcDBsXzUAtbXi//EUHFd1WCF/jJjukCpkUsZxANsP8gtRX7YRX/iYE8LwPuUFcc1utOx3FZKv3B0/4a49YiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729351057; c=relaxed/simple;
	bh=qlYxZ/mutiFyZglQTOt+FaPUID/Hkn0Wn85xFGqh1rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGkn2Hbj2BWjuv0LlETmMm49Re6mwZLj428bzFajnVcxnf5K3yGjj2zl8TzTuVqCjSEOcSs9hoPQOEIeZBWaFWbdUY0IzALLtN2ghFCfiqzrqljyG96L/y7w9BGRqRBJzVxEJYXauw/FWeSy5+sX0WKGLkmEa37TqQR4iGzQ56o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cP2zdPrI; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cP2zdPrI"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e983487a1so2025066b3a.2
        for <patches@lists.linux.dev>; Sat, 19 Oct 2024 08:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729351054; x=1729955854; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=AaKPVphA6VOFY1TbMrOg1qFr2iQWaxZBWL1Sz95ALok=;
        b=cP2zdPrI16SBCfk6BExbgoTc5GPakrx86OEOXrb+KNcBGwr3FG+r322jO54t6Eio0t
         7UjrTxp/SrhotFgDB6sW2lCBIHtUrxoRwciD4oPI3W83FL2w5AcI7lReEDOBitGuJXip
         P5Pa2zrHWcE+miUJK+xZDyYj5JOCJOKhidmccsJz5Lr+2vyGLVqlAGCttQJ5VXid/krO
         +DSZkiOzcnqEvPKaaGy/P+6Wuk7PucGzZRqdnVSXNRJg8tqon5ZD0/L96HTO3S2zqE55
         q1SpV/cDz8xN0JtewdR5H/5kfhdONgdTs7Od0LoOhhvteVinxr1CdQHK3tfVw1iSCGOB
         +kPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729351054; x=1729955854;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AaKPVphA6VOFY1TbMrOg1qFr2iQWaxZBWL1Sz95ALok=;
        b=pLif7wLiL4/p+cyKsrHMHHnV5Plc9bb2ayxm5NM463zaVLMPBUjmq+3Bf4QTc1rRHq
         lhu8PtRaxJX/mx6ouV/yaxAxzvNaKV+D19wC1cmVJaoSvJaCl9EeyhmjryC4lu7HHzI8
         2A9Qzk4xiY9+8DV/UIzEsvmznvMC/z+OH7PkzyvCn8fJTzWeph9yNgc/gzcSofgZi/Ta
         ECKRlauqMvV0po5WbDv/RST+tLRflwf+b8WvndLGSBZY8CaEinPclCDq1RB3IiwfAiXY
         F/VMZ0pXPUsKgKrP6Jh7+YKfFeSbyyN8MhtPvyY6/uTu6n8I1kOXlBEkE1wnhREQ50LM
         Ac5g==
X-Gm-Message-State: AOJu0YxsORYfNVzDKurokfys4YCRyj8ry2dmg1UI2Ujg/FfsaK07Nfuh
	fI6LKlOAO7OMODLhp6HXg50lp0E3RCmA/8A0DGnhs/oYR7W67sw6
X-Google-Smtp-Source: AGHT+IGVmd48wCb4OfOnkBW4/lrP8cPYon+iJQwsqlHmHRPSx7svPiI5fzsxZphXuazsL46X/CdWFA==
X-Received: by 2002:a05:6a00:1913:b0:71e:4c01:b3da with SMTP id d2e1a72fcca58-71ea31d28dfmr8098510b3a.5.1729351054222;
        Sat, 19 Oct 2024 08:17:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eacc2a5c9esm2992255a12.94.2024.10.19.08.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2024 08:17:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f035e6ef-32e1-45a2-962e-dc27fa54271b@roeck-us.net>
Date: Sat, 19 Oct 2024 08:17:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org
References: <20241015112501.498328041@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/24 04:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
...

> Nicholas Piggin <npiggin@gmail.com>
>      powerpc/64: Option to build big-endian with ELFv2 ABI
> 

With this patch in the tree, trying to build ppc:allmodconfig
with gcc version 13.3 and binutils version 2.42 results in:

Error log:
/tmp/cccUl45i.s: Assembler messages:
/tmp/cccUl45i.s: Error: .size expression for gcm_init_p8 does not evaluate to a constant

and many other similar messages. The problem affects various drivers in
drivers/crypto/vmx/. The problem afects all configurations with CRYPTO_DEV_VMX_ENCRYPT
enabled.

Reverting the patch doesn't work because this patch is part of a larger series. However,
I found that applying upstream commit 505ea33089dc ("powerpc/64: Add big-endian ELFv2
flavour to crypto VMX asm generation") fixes the problem.

Guenter

---
# bad: [54d90d17e8cee20b163d395829162cec92b583f4] Linux 6.1.113
# good: [aa4cd140bba57b7064b4c7a7141bebd336d32087] Linux 6.1.112
git bisect start 'HEAD' 'v6.1.112'
# bad: [2bf4c101d7c99483b8b15a0c8f881e3f399f7e18] net: ethernet: lantiq_etop: fix memory disclosure
git bisect bad 2bf4c101d7c99483b8b15a0c8f881e3f399f7e18
# good: [f88f1145e134fe1da3966d86adb5d813ce2d7c1a] PCI/PM: Increase wait time after resume
git bisect good f88f1145e134fe1da3966d86adb5d813ce2d7c1a
# good: [12aea49495d99bebf185275e7ff33deee4d849a9] fs: Create a generic is_dot_dotdot() utility
git bisect good 12aea49495d99bebf185275e7ff33deee4d849a9
# bad: [f8a29300150e2b18405ff62cc4ed1554bc9c431d] usb: yurex: Replace snprintf() with the safer scnprintf() variant
git bisect bad f8a29300150e2b18405ff62cc4ed1554bc9c431d
# good: [5410d1529047dd32039a2796ea9bd955c6f38b1d] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
git bisect good 5410d1529047dd32039a2796ea9bd955c6f38b1d
# good: [85868884298a81078f5be51be75ad46c14c6e831] hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume
git bisect good 85868884298a81078f5be51be75ad46c14c6e831
# good: [41fbdd452460341399757b4db3cd12a67951fb83] EDAC/igen6: Fix conversion of system address to physical memory address
git bisect good 41fbdd452460341399757b4db3cd12a67951fb83
# good: [b986ec200f9fb5c4d863d789e28f45cd2f253656] soc: versatile: realview: fix soc_dev leak during device remove
git bisect good b986ec200f9fb5c4d863d789e28f45cd2f253656
# bad: [9eb76d5168c10a46647df5514acc863039a44885] powerpc/64: Add support to build with prefixed instructions
git bisect bad 9eb76d5168c10a46647df5514acc863039a44885
# bad: [8b9f7d8d71bf9b91ad4cb1ff589d7cdf4bc0673a] powerpc/64: Option to build big-endian with ELFv2 ABI
git bisect bad 8b9f7d8d71bf9b91ad4cb1ff589d7cdf4bc0673a
# first bad commit: [8b9f7d8d71bf9b91ad4cb1ff589d7cdf4bc0673a] powerpc/64: Option to build big-endian with ELFv2 ABI

