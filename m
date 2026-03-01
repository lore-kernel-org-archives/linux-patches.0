Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB7C2AF00
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 01:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772326835; cv=none; b=Zq+dPOY3Bqbsj5pJG9bGaM1tRd6J8+ie0/kumQhAHNeyh2eBb7Ncu4QVbEv1koEv6fHcB82SpvSFTnNd8raSXi7bEnu4C+Z14J+zSl6dpX18UIsWeyB/l10yUEi0gMcFAbHGa1bEx3O4KP7saoEA8amEotCBIMt4CHkpH8ck8xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772326835; c=relaxed/simple;
	bh=hARNZYBdOcg+7p4kGxj5hwQ3cw+7v/HGvxDt1cHaoL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cEKq73Aia1QhXmLZajCNN6i4nue6lGeHUaKF7F0N/lo2okcJR4fJ0a1a78O4wKnYA2+mB+/vrf5lJ8JzK0UoDIpF482CgVk7wIPWhwEs5jp3y4+8bSek4lZYeAFJjL2UlQjjlanMhJv7RYiIGRR3HRDjP9o/tMXOJRUUmPfasxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/ipT2YP; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/ipT2YP"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3590042fa8eso1871230a91.1
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772326833; x=1772931633; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=gG5T9131u1Fi9YHNQnsGHl13Nv403nyaPbmV84rbRR8=;
        b=E/ipT2YPj1wJ/MDZq49pgY1VQAQ2VDCD+NJTb1voeknVxfwJ8N8iOnRXx1rvLbl8Sd
         4/0YKcRr5Of0CbzeLGUjH6h/pO4WsIaSAHPMTtgznOJxYgi3EiTIUILGWXwjMkVupk8H
         zmineF8Yhqqec7GeD1oyVQH2RqA5Yi65j+UuO6g73e9RpYX4RfVwwqti4G/wJw4lWHtA
         G8Fa3nqOnO/kwAGRNS0Tc3qZwTb70RQ43COOQ//bOuzrE/a17XbGoeLYYB+nrBq9uiJj
         5wXZnovrQUNLHRAdaoyypE9qdRgH+ZirlrVs/W4UZQZ/+/dEPdP7/bRJWB5Y396AcSWd
         JW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772326833; x=1772931633;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gG5T9131u1Fi9YHNQnsGHl13Nv403nyaPbmV84rbRR8=;
        b=bby9XE8DgCKVjbLwkjknOkyU/iX/zsfvRIeXHBkIM5xC3Gxz0S41dtVkW2RvnYbdCX
         VZMO2g7t+U2/g60iR2stFwZ9THOkgeH2C/pEeae+kfVLDD+u08Ra5ytcl0rDunK7L69i
         nX1ePG9IS140MxpYDTSsRs6w6k2lZRlgRTZdYN2UOnSSN2Rl10UvvBxY8RwYSYGUjTpD
         DGatY6Ee88EcQyMISq78AVbZ3Z+xjg9cdMQ6F7bfgQIqoYsnSE8j0Lw5qA4CCMCfDuDp
         L3dtOx1qdFeaF5MUC+LYo2pLNZ9NrMyjDHqjfUW2crsnTLiZWUyX9yWZg+XsrkTv0eCe
         gqKQ==
X-Gm-Message-State: AOJu0YwwrksdHjZHnYmS8WQdkmRmBG0jzUjUwpoWC6KSDjY2XyDuavc+
	FmJ15da/JvRuJZvi2kQC6pSYFbD8AZf5Eo9Wk7aZS16AbUGdzNtTe/NG
X-Gm-Gg: ATEYQzyvrT4WceDssbp2O7PqgQNe6GMzjK1yR9ZyGepuydEaDSyVCDQHwUaNHh4yihI
	curkNpSfRC72OUuZHqGw04UzcSrLmeyUj0E7tya9o+3Ze+OdoPi1mCp14EC/76NOFOgV9hTBQXZ
	CK5XhCn2hLtF/aj9jXdDls7M5yINsSsnUbedBwDrHMnw8GpZ9BRWL4w9bEUH3mEUoI2tmARov8J
	a4wNefxXxhsIUQLx6VgCiYAPA49XB/x8Z7fTW08N5oxXF2BX4MD9HJiOdeXVs2apwBln4clCvV+
	0SCRINoOM4mL20w+vlgVZSHwC9PwUjVq2Yb+024d9spKaWUqoiYbM7IbNeOpzwJzXf2jr7Z4ISv
	aePCGadouqrKyJx5eHoDHxTkc1yw9zfmUD4we3JMuM9yxWWh+rc/eVqoEd+3X/MYPhSSbZSorHH
	7KgSnoE8xU70Wqkf4WmktfP4YzmMYmsOC6x+tjFJG/YZEkK+e//u9+OiM3NDJWWSa4Nc5iuLfV
X-Received: by 2002:a17:90b:588d:b0:353:356c:6821 with SMTP id 98e67ed59e1d1-35965c3d12dmr6437415a91.8.1772326832941;
        Sat, 28 Feb 2026 17:00:32 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359037af167sm12651126a91.15.2026.02.28.17.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 17:00:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0dc5bd34-639f-4240-ab69-9cc6f396f3a5@roeck-us.net>
Date: Sat, 28 Feb 2026 17:00:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260225151847.709818960@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 2/25/26 07:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
...
> 
> Petr Mladek <pmladek@suse.com>
>      kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
> 

Unfortunately, this patch does a bit more than it advertises:
The shim function it removes used to set *modname to NULL if
the module name was not found. This code is no longer necessary upstream
since commit fda024fb6476 ("kallsyms: clean up modname and modbuildid
initialization in kallsyms_lookup_buildid()") unconditionally initializes
*modname to NULL.

Unfortunately, commit fda024fb6476 was not back-ported to v6.18.y or v6.19.y.
This results in kernel crashes if the symbol is a bpf address.

[ 5393.147564] Oops: general protection fault, probably for non-canonical address 0x776d477193e1c300: 0000 [#1] SMP NOPTI
[ 5393.147567] CPU: 7 UID: 0 PID: 489696 Comm: step_worker Kdump: loaded Tainted: P S   U     O     N  6.18.14-smp-DEV #1 NONE
[ 5393.147570] Tainted: [P]=PROPRIETARY_MODULE, [S]=CPU_OUT_OF_SPEC, [U]=USER, [O]=OOT_MODULE, [N]=TEST
[ 5393.147571] Hardware name: Google LLC Indus/Indus_QC_03, BIOS 30.116.4 08/29/2025
[ 5393.147571] RIP: 0010:string+0xbc/0x100
[ 5393.147574] Code: 44 88 11 eb e0 31 f6 81 f9 00 00 01 00 73 05 e9 0a 1e 00 00 89 ce c1 fe 10 45 31 c9 eb 08 49 ff c1 44 39 ce 74 39 4e 8d 04 0f <46> 0f b6 14 08 45 84 d2 74 20 49 39 d0 73 e5 45 88 10 eb e0 44 89
[ 5393.147575] RSP: 0018:ffff9709489fc498 EFLAGS: 00010046
[ 5393.147576] RAX: 776d477193e1c300 RBX: ffffffff973ae731 RCX: ffffffffffff0a00
[ 5393.147577] RDX: ffff9709c89fc5df RSI: 00000000ffffffff RDI: ffff9709489fc5e2
[ 5393.147578] RBP: 0000000000000405 R08: ffff9709489fc5e2 R09: 0000000000000000
[ 5393.147579] R10: 0000000000000036 R11: 0000000000000002 R12: ffff9709489fc5e2
[ 5393.147580] R13: ffffffff973ae72f R14: ffff9709c89fc5df R15: ffff9709489fc530
[ 5393.147580] FS:  0000000000000000(0000) GS:ffff935966f63000(0000) knlGS:0000000000000000
[ 5393.147582] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5393.147583] CR2: 0000562833e138a8 CR3: 00000006c94f5006 CR4: 00000000007726f0
[ 5393.147584] PKRU: 55555554
[ 5393.147584] Call Trace:
[ 5393.147585]  <IRQ>
[ 5393.147587]  [<ffffffff96c5d1c8>] vsnprintf+0x2f8/0x410
[ 5393.147591]  [<ffffffff96c5e736>] sprintf+0x66/0x90

Please apply commit fda024fb6476 to v6.18.y and v6.19.y to fix the problem.

Thanks,
Guenter

