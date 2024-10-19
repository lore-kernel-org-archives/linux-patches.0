Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCDC645
	for <patches@lists.linux.dev>; Sat, 19 Oct 2024 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729364002; cv=none; b=n77LVFEY4DKUZyeKk8auAmfamsSro1puuNuQaVNQ+v87UYZdCygrIBipOHlFFP5WkIRwJ7tyB6o3dS6H97HpUr8X+xrmz9o6XANUg4yITgYnDdPELaRkqwUPT6vGtGFi+VBq/uRjf/Sz3PWTWx62Oq3LPWUGKUrLZOY5y9AcfnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729364002; c=relaxed/simple;
	bh=1PhY70V8GOUc+TLmLYSJrrntcDdtq1eG3y2frVI08Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yn3nqX9iBONgK30ehaEvu+DR88hLHrraM/Y1DFEHvQoDNBRP65VV7f0ni1rsXtOUpApWvwQZUC3dqcMDc5dZFEPN0JMx/cWOhbWW/5TkYyVFuE9s282Loe6Vx7qJ0pf61Ov/w/eYTQIu48R6/uscoQXnRRENiN8Uqv46IdDPd/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAtQRQ7O; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAtQRQ7O"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7ea784aea63so1578978a12.3
        for <patches@lists.linux.dev>; Sat, 19 Oct 2024 11:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729363999; x=1729968799; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=DjpGM9T6CWreh9wg2H5SjyS9PX1h20Do3Kr4hgqqd4g=;
        b=CAtQRQ7OmYsjs+QAgiBGem+C5Do00F4AjfdFg3PkxAck7lrXwq7xEi1m/8ic92DyW4
         M6Zx1sebWpvZUw9pjYYhksDN2MiSZfws+aaxYtgrsiPobCu8LUVdjPSuJ++z4OTKM2Yf
         MtUf2yXS40MHicOOMrT9o91cMyDAtCLc5mQJ7FkOJ+WZNMi8s4rvmhH2DNyi+2kBAkjC
         lwK5E3M+LT+L/8xges9TXdTEseO51PuVR5sn94UDtdfMsy1crcW+pikU+EACdKdgvF25
         yJSjhdYHxcOs9+BwtXyLbdLIkoT21dMNkWW9qdDPIML0ZFhXqZ9yYwY7dk3B0CLTy3F2
         hqbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729363999; x=1729968799;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjpGM9T6CWreh9wg2H5SjyS9PX1h20Do3Kr4hgqqd4g=;
        b=klIdzkC/XYnECjtMyWri/BucIKtSs1BnlQna1gXAISW/3uba7PemseKMxx+cxDvSD8
         9+nKFSNsQDZJ3HNdQx8hq5JJYLNbSePaZ+xit/2jnaA2g3P8IF46BbaN7eqJPW4I+2re
         6sDRQTsh+0GsUF4AuuhjVKd2/4CMtnrfSLNkPFguRwLj5+DS+pvIRrl0qRGq4CQjsPIK
         6EOpt5AAkSI7wSWAt3tl21Uhfz/qQLmTVQGop6Bd8PHjqlQgOpMevTCOMNutFsUGvgh6
         U57aMIvJYCWuecECI/IsCXdcj/tZ69cYvYD+2c9LVtoJOVBgUQqAYmVj/jz1lR6D7+71
         gMnQ==
X-Gm-Message-State: AOJu0YyLKbK4RcqLOWXZEt8ZQ1k8e0RqXWku9AQsZDKRhkh1ql45qHCe
	EaAy0pyPyJijlKAb9tJqU/PerdHppA12qL+TceELbIY9yEKegvDS
X-Google-Smtp-Source: AGHT+IGhomoq7YA3Lcbm4z7G96mwgHXtfACfJ6DXFPiHy6cItNFe+jAxkrGIRMlYaoMY24koRAgO9g==
X-Received: by 2002:a05:6a21:670f:b0:1d8:ae90:c647 with SMTP id adf61e73a8af0-1d92c5abfd9mr9249286637.42.1729363998312;
        Sat, 19 Oct 2024 11:53:18 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec13d7525sm65086b3a.103.2024.10.19.11.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Oct 2024 11:53:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <f46542ec-bb43-4a30-900b-d3c9d1763753@roeck-us.net>
Date: Sat, 19 Oct 2024 11:53:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 allen.lkml@gmail.com, broonie@kernel.org,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Michael Ellerman <mpe@ellerman.id.au>
References: <20241015112440.309539031@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 10/15/24 04:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.168 release.
> There are 691 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
> 
...
> Christophe Leroy <christophe.leroy@csgroup.eu>
>      powerpc/mm: Fix boot warning with hugepages and CONFIG_DEBUG_VIRTUAL
> 

This patch triggers a crash when trying to boot various powerpc images.

------------[ cut here ]------------
kernel BUG at include/linux/scatterlist.h:143!
Oops: Exception in kernel mode, sig: 5 [#1]
BE PAGE_SIZE=4K MMU=Hash PREEMPT SMP NR_CPUS=32 NUMA PowerMac
Modules linked in:
CPU: 0 PID: 25 Comm: cryptomgr_test Not tainted 5.15.167-00018-g00ef1de6d646 #1
NIP:  c00000000082c6c0 LR: c00000000082f460 CTR: 0000000000000000
REGS: c00000000962b540 TRAP: 0700   Not tainted  (5.15.167-00018-g00ef1de6d646)
MSR:  8000000000028032 <SF,EE,IR,DR,RI>  CR: 84000440  XER: 20000000
IRQMASK: 0
GPR00: c00000000082f44c c00000000962b7e0 c000000001ef6c00 c00000000962b9e8
GPR04: c0000000096e2000 0000000000000008 c00000000962ba48 0000000000000200
GPR08: 000000003e2a5000 c000000000000000 0000000000000000 0000000000000001
GPR12: 0000000024000440 c000000002b62000 c00000000011e6b0 c0000000096c8e40
GPR16: 0000000000000000 c00000000148c300 c00000000148c2f0 0000000000000008
GPR20: 0000000000000040 c00000000147ddf8 0000000000000040 c00000000956f4a8
GPR24: c000000002a23c98 c000000001417d18 c0000000096e2000 0000000000000001
GPR28: 0000000000000008 c00000000962b9e8 00000000000096e2 c0000000096e2000
NIP [c00000000082c6c0] .sg_set_buf+0x50/0x350
LR [c00000000082f460] .test_akcipher_one+0x280/0x860
Call Trace:
[c00000000962b7e0] [c00000000956f4f3] 0xc00000000956f4f3 (unreliable)
[c00000000962b890] [c00000000082f44c] .test_akcipher_one+0x26c/0x860
[c00000000962bad0] [c00000000082fb14] .alg_test_akcipher+0xd4/0x150
[c00000000962bb70] [c00000000082bcac] .alg_test+0x15c/0x640
[c00000000962bcd0] [c000000000829850] .cryptomgr_test+0x40/0x70
[c00000000962bd50] [c00000000011e880] .kthread+0x1d0/0x1e0
[c00000000962be10] [c00000000000cc60] .ret_from_kernel_thread+0x58/0x60
Instruction dump:
fbe1fff8 6129ffff fb61ffd8 7c244840 7c9f2378 91810008 7c7d1b78 f821ff51
7cbc2b78 789ea402 41810078 3b600001 <0b1b0000> 3d220007 7bde3664 39492f20
---[ end trace fdddc57d958f029f ]---

The problem affects v5.15.168 and v5.10.227. Reverting the offending patch
fixes the problem in both branches.

My test images do not have hugepages or CONFIG_DEBUG_VIRTUAL enabled.

Bisect log is attached. I copied the author and Michael for comments.

Guenter

---
# bad: [584a40a22cb9bf5a03135869f11c3106b6200453] Linux 5.15.168
# good: [3a5928702e7120f83f703fd566082bfb59f1a57e] Linux 5.15.167
git bisect start 'HEAD' 'v5.15.167'
# bad: [62356668d855deb075a93fdf9f26888c4f80b7d6] nfs: fix memory leak in error path of nfs4_do_reclaim
git bisect bad 62356668d855deb075a93fdf9f26888c4f80b7d6
# bad: [791b3d66d2ef3a64de517651d606afb9521b5d39] drm/bridge: lontium-lt8912b: Validate mode in drm_bridge_funcs::mode_valid()
git bisect bad 791b3d66d2ef3a64de517651d606afb9521b5d39
# bad: [4318608dc28ef184158b4045896740716bea23f0] inet: inet_defrag: prevent sk release while still in use
git bisect bad 4318608dc28ef184158b4045896740716bea23f0
# bad: [25cf67f8ff2ff04607b556fe4d8d4a402b133d29] ice: fix accounting for filters shared by multiple VSIs
git bisect bad 25cf67f8ff2ff04607b556fe4d8d4a402b133d29
# bad: [10c111760128351b2b5ce72bb5345b0e0c89dc36] Input: synaptics - enable SMBus for HP Elitebook 840 G2
git bisect bad 10c111760128351b2b5ce72bb5345b0e0c89dc36
# good: [020f5c53c17f66c0a8f2d37dad27ace301b8d8a1] ocfs2: reserve space for inline xattr before attaching reflink tree
git bisect good 020f5c53c17f66c0a8f2d37dad27ace301b8d8a1
# good: [d71c5e8cbcf9ced0765f99fd669da2610088e08e] usbnet: ipheth: fix carrier detection in modes 1 and 4
git bisect good d71c5e8cbcf9ced0765f99fd669da2610088e08e
# bad: [00ef1de6d64654e069849e79a9878318ad37a093] powerpc/mm: Fix boot warning with hugepages and CONFIG_DEBUG_VIRTUAL
git bisect bad 00ef1de6d64654e069849e79a9878318ad37a093
# good: [be4e5f5bdc19cbb6568509d1af1d94cc82537a95] net: phy: vitesse: repair vsc73xx autonegotiation
git bisect good be4e5f5bdc19cbb6568509d1af1d94cc82537a95
# first bad commit: [00ef1de6d64654e069849e79a9878318ad37a093] powerpc/mm: Fix boot warning with hugepages and CONFIG_DEBUG_VIRTUAL

