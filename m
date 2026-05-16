Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93811246768
	for <patches@lists.linux.dev>; Sat, 16 May 2026 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778962833; cv=none; b=t7kiWT+sn9LYNQVojFdjZqPG3EqKwKsNfoZR/12aA5LEWIHWCIeCSCcP3s8wneHJ6UND7hp+93Zjc4KyfWT8Tfd4crOYDXgSeftuV9ObPsNDC39aeMnOkbPXKeEnf1u7GWXNee7+xTX1zPW77XcuT22G5m7BOoZfwUvi706PJX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778962833; c=relaxed/simple;
	bh=LglJJ9OIp8+ohVxToRs+s3JszhrdE8G6xx4i5lvqGTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZPNvcewIueIbTiXeAdwLZHZL+nQRVE1dIxUkqg/zqhipC+HYrY0gRIYC14G5V+RdOgaFC4oi3XvSv/bE50+PT6hgd8IernU8jEsfgOFiy8IJYKqFL+6p2HIVsOO9vF9C8mJvC8lrXopsK5UFiqZQV14kMlwM4UdSsAyJfSLKcxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=SjPG4rqZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SjPG4rqZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48d102471a4so6531025e9.2
        for <patches@lists.linux.dev>; Sat, 16 May 2026 13:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778962829; x=1779567629; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BFENqpptTunepZjrSFyTPYxIM1W/QMJyOTAEMQ2QQOU=;
        b=SjPG4rqZ+p5UVPTrRs9K9tC2EgX0wsfpdAYuW4wLVG1X9CkVGWZxH89X/XuPn2YsZx
         T/gegPDohpTUkitdKSI3sHLEz5GUCRceVrjNG+mdJMBKRdb7UfO68LRp8ywDracWcdlg
         HvMWatXGJCabH5qe96Sn7XFWTdozPSvm6w2MSQU2uO5NJgyHoXOVSXhwJToz+MeLjZTw
         7vwluLaUZwT+IMm6KgVWcaTTHo977esnsNrciTcM8bqVJIKeF5QIVI5YmNXcEi1r0S2r
         gll5ZxwszqmYd6GJbG2+A+dRvJeOAszQ2rB4LEPxjweDsaBuUmbWWKzxfZGsCsjcalPm
         dMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778962829; x=1779567629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFENqpptTunepZjrSFyTPYxIM1W/QMJyOTAEMQ2QQOU=;
        b=AWLF6e04G2O74ukQKH5YVFTgtyYRZWKSSxZ5fgEnfQHis1cn9w/u1iqKbuFjthKiqg
         Pu0kBnrt1sDlKcZJ44GP1gaEBh3jNBUvzE705yUTOoqA2+iG3ahFooCoDwEdCtlo+9Os
         6pDCo2ByYuHLs5SxoWA/I/Slg7Pkaqu/lB57jPR45wu6YAk3gkXyj/WwZK9xm4EXtujl
         dDBqdWYv3/k7+XZ8GS2woXqXjjzClhTVUa21xthW2igw8ok4L0a8J4iJgzFoHPi6RWIU
         8geNmUk30SAIcJI7SksxCfO8UEFJMM7z1u74DWHOolkEumpmEa1GJGrxEKDTa/Zx3epS
         dsKg==
X-Forwarded-Encrypted: i=1; AFNElJ+yLnhubSOM4POaHpUSjNA0WpdgrXdunvaO6VLgAn2Hal09djWEMmrQYWujudTGtM+/aHWtJmMR@lists.linux.dev
X-Gm-Message-State: AOJu0YyQkOdSvwvzDvpUvChB+esw8LrLzdpHsHhqCX02sq7ctepbWFJd
	N01TAQV24V7+/9NIDkdyuwXJuO4onDe1nfnOknqk+CRyN0yaMkXh8Ss=
X-Gm-Gg: Acq92OHWMEtW/DspuqTGg/0YHr/+xFU1Ifd45jFHpEO2RhRNEXKOUZznYHPVnBin6AM
	aL9I1V0u3LUQcQJDM7d/yCKPyTgFwiHObEkWy3C2S8wUjoq+PbFXge2Xgpo78algyrZqJr3IrRe
	/to/XGKS9tk/IJxqs0BZKjU5YIwIwIRjKLQa3/GVYr+uKmPVzYery/yYsRSyWY0OmMTL6N62GpJ
	G+qsi9fwQ5ruq0YDIQc9cxOEkzIKyjXMDYsphJMTbmNrCgsXJ927LqkOgodhDvIGsiaY2ar8OTO
	vNlT/qWK2c5usNli3/XBzrl+SHtS8Zot8EA6PucJPSOL2X9yrXoKNOcQ1OLCdh4aecmbaVmap8p
	a3iWmcmqLTBPnRU43ITHS/TzGI3TxeO87tN2NbKmXYIXXt4LCzdW5JB83/au1gr8YHaqWEgSFBd
	IvJ3bZ09U0p2k46Ds/bJFeCVP3v5oAmfUSifvKDkEuo1Y4ruZ5kFpCDAXku/XGnntHvpnPIlh0q
	UU=
X-Received: by 2002:a05:600c:c096:b0:48f:d1b8:9aad with SMTP id 5b1f17b1804b1-48fe5fd5357mr93453995e9.2.1778962828770;
        Sat, 16 May 2026 13:20:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4b92.dip0.t-ipconnect.de. [91.43.75.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48feaf14d22sm61734025e9.3.2026.05.16.13.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 13:20:28 -0700 (PDT)
Message-ID: <382baa32-8fe2-4c3e-bbb9-87955fb2d0dc@googlemail.com>
Date: Sat, 16 May 2026 22:20:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
To: Wentao Guan <guanwentao@uniontech.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
 hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
 linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org,
 patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
 shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
 sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
References: <a56911f8-9c02-464e-b61c-0d565a5dbd43@googlemail.com>
 <20260516180941.704379-1-guanwentao@uniontech.com>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260516180941.704379-1-guanwentao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.05.2026 um 20:09 schrieb Wentao Guan:
>> Am 16.05.2026 um 12:09 schrieb Greg KH:
>>> On Sat, May 16, 2026 at 03:07:14AM +0800, Wentao Guan wrote:
>>>> Build failed, you can drop the commit to build ok, same as 6.18.30-rc1:
>>>> git revert 14d9ce90cf4855d638ecbcdb0c208a144d6f991b..
>>>> Revert "sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation"
>>>>
>>>> Tested-by: Wentao Guan <guanwentao@uniontech.com>
>>>>
>>>> BRs
>>>> Wentao Guan
>>>>
>>>> defconfigs:
>>>> https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9
>>>>
>>>> Log:
>>>> In file included from kernel/sched/build_policy.c:63:
>>>> kernel/sched/ext.c: In function ‘scx_ops_enable’:
>>>> kernel/sched/ext.c:5524:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
>>>>    5524 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>>>>         |                                  ^~~~~~~~~~~~~~~~~~~
>>>>         |                                  HK_TYPE_DOMAIN
>>>>
>>>> missed HK_TYPE_DOMAIN_BOOT is introduced in this commit:
>>>>
>>>> commit 4fca0e550d506e1c95504c2d9247bc92bf621bf6
>>>> Author: Frederic Weisbecker <frederic@kernel.org>
>>>> Date:   Mon May 26 13:06:21 2025 +0200
>>>>
>>>>       sched/isolation: Save boot defined domain flags
>>>>
>>>>       HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
>>>>       but also cpuset isolated partitions.
>>>>
>>>>       Housekeeping still needs a way to record what was initially passed
>>>>       to isolcpus= in order to keep these CPUs isolated after a cpuset
>>>>       isolated partition is modified or destroyed while containing some of
>>>>       them.
>>>>
>>>>       Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
>>>>
>>>>       Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>>>       Reviewed-by: Phil Auld <pauld@redhat.com>
>>>>       Reviewed-by: Waiman Long <longman@redhat.com>
>>>>       Cc: Ingo Molnar <mingo@redhat.com>
>>>>       Cc: Marco Crivellari <marco.crivellari@suse.com>
>>>>       Cc: Michal Hocko <mhocko@suse.com>
>>>>       Cc: Peter Zijlstra <peterz@infradead.org>
>>>>       Cc: Tejun Heo <tj@kernel.org>
>>>>       Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>       Cc: Vlastimil Babka <vbabka@suse.cz>
>>>>       Cc: Waiman Long <longman@redhat.com>
>>>>
>>>
>>> Also dropped from here, thanks.  My fault, I should have only backported
>>> this to 7.0.y as the commit itself said to.
>>>
>>> greg k-h
>>
>>
>> Now I really wonder why I didn't hit this build error with that patch included in 6.12.90-rc1...
>> Because I hit it in 6.18.32-rc!
>>
>> Let me check my .config ...
>>
>> Beste Grüße,
>> Peter Schneider
> 
> Hello,
> 
> I thought that 'CONFIG_SCHED_CLASS_EXT' is what you found,
> and it is depends include 'DEBUG_INFO_BTF' which depend pahole (maybe missed).
> 
> BRs
> Wentao Guan


Yes, you are absolutely right!

I do all my tests on one of my Proxmox maschines which by default run some x.y.z-pve Kernel, and I always use the 
.config of the closest PVE kernel as template for the .config of the kernel I want to test.

So for 6.12.90-rc1 I copied config-6.11.11-2-pve and did a "make olddefconfig", and 6.11 did not have 
CONFIG_SCHED_CLASS_EXT yet at all, so I ended up testing with CONFIG_SCHED_CLASS_EXT not set.

While for 6.18.32-rc1, I copied config-6.17.13-9-pve and did "make olddefconfig", and 6.17 already had that 
functionality (I guess since mainline 6.12), and so for that version, I had CONFIG_SCHED_CLASS_EXT=y


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
