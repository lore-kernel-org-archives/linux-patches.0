Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E655D3ED5C5
	for <patches@lists.linux.dev>; Sat, 16 May 2026 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778951513; cv=none; b=S3QiPoSkOJf3zDwIAjpx4ETb1qEAzilpVuSxJdPnmqk5aSqeHjJD5VzIRUAd+qWFNiboJMxbRTUR9Iy8LkZdXQf2nZfKbldk+G7SkcAOW0SKZUXU8eiI+pcQ385kahmsUJnENquHfR0iXnF7WoSjHyrav4ifnAh2Gd+/zh8LssE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778951513; c=relaxed/simple;
	bh=oX33zzrhzx2wnBTO434znlc7XiOBQWwh4mIrmCX2a+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MXeROQZRYhiIbWzURkqqAa81VTNTUN0Fn23sbxW6Nv5XOQqrFkmcN/HDHHNveMxjWannny17qdSmuoIog3D6xJyMlDhKhfCQjaJgDI1jzju9t4cTiWCvQMaDTLLKZfQVOFyAYqCsB+bGwdPs+c/uekmxbJcYS4I9XOYrrUkHhdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=AeBodgcY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="AeBodgcY"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso6312845e9.2
        for <patches@lists.linux.dev>; Sat, 16 May 2026 10:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778951507; x=1779556307; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=daDGZ35CtqHe++jeBQ8nOe5orQydlheCaV35Ow+XAS4=;
        b=AeBodgcYj/cmWHOxbS6mUVqgiSp4SgBe+Lf2bI+SYrZVuKPBQPDBQ4gYWzko22ZiUq
         Bb5fnyiHx4Ev88CqIlPW639XO665so5Gbtrp5TPFoRvszq+z0xCHTMP380vIbacc1W1k
         +/3b0S/yb7ypQYelSA8johL44sX0Kwa0y7dYUA4zVHiu9UYd2mK62IWmCHtUsYKUMpmu
         ZJujFSmTEHbLWjUKaQGMB0zC7BxbW+O78Q8s1Y4NrtiMsNt//nyKnXlZ+2ccBzaNT1r6
         5uCaThVRmOIne1P+14FZMrhGm8No1gxCpmOnbqcUlQjSpbSVtUXFKl1GMWJY6HIuetgV
         ZO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778951507; x=1779556307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daDGZ35CtqHe++jeBQ8nOe5orQydlheCaV35Ow+XAS4=;
        b=lw2BTG0OiWK+mwibORaXIptORM+xd5A3AnyJHF5iUT5lzXdzJJCDySnU7G8FFcHjSK
         E2mG92d5CuGt1BKZnr3tjPMplh53eNa7G0Hab66bkYQha9CgnOEy5X9QXk1m3bHlcfwh
         fgiEm121cRjuB4mQj7ewCQxfDSuwEKw3rJMW/RWsJ+3XxDFYc9itAZUlwhXcbCz1jytf
         gWjYs+YKDD0Zb2LCDdf+OFI6OzJZGZHZqB+Uyw6Fzc+Q1XmVElq/hghSlCiJUA9Ks1Le
         nq8i6yQhFIwTEyzxt4J3ieMBYmElwr+d8S1pHqXQt1+3I7ODTb5HRDfQ7mgaTfZU/e+c
         ccAA==
X-Forwarded-Encrypted: i=1; AFNElJ/rcHAjf7/nZef2szOzTdVOGO2PnxXi3JO1ceC4T0C1ABVGfyW2+M2hgLMlcqrBaKm8pKroWOkQ@lists.linux.dev
X-Gm-Message-State: AOJu0YzaMg4NBQwvVjMoLRGXPwyBZwSibYdJWVOJIwi3eRgLytWfJM/Z
	VPeDLDdXZ+rqVCGkTeQy1tOT+e8LC07DgRwMxfdoAikpRFl5iSO7d+o=
X-Gm-Gg: Acq92OHTwdFeJC9O38Wx9ZKM4i4joTQrMA6sTP0XWgPxVv/fACdr6kzxhGiU1jQD7uf
	FNVXPryMwRXXf/TewMYut9SS8Ocko9IVxAbdTj5tZTpA0nZvkHhzUWWCbOpgevK16/QEOTULcg7
	vks9ZmoLD0RTUhgw6pzqFPSgRIE7wdIKz450Jbamk12Ob0sJdWm4WV7OPYNGtK0htEe2bPb5RTM
	jmuysTPgQPI2A+cS3DxkDnCG5w5dtQyii/fLoZS92Bmm2ufzJZv8Ban9xbcsmgC2nt2xPgqIT6s
	nopi4ZwoBVNTB8/9jWIqZvBPp6w6Ofs98mE8rlBPcZMovqJCihEo+4XFb6Vnkv6cc4P2Kx6ORMI
	OmFpAeDJdTkLzWMlP2uBomm6b2ldB40nLOXXuVJIk+LomJwaJLxdwq9VwMGX/8AV5ovHW+NP+v9
	ezWV6z1QXsQZS2S9lPNOBqPP1/zwM+HvOMB54e9OqN1kP5jtAbJo9QtQbVjH6l5P98h1V5/Irjh
	9M=
X-Received: by 2002:a05:600c:a00f:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48fe63263dfmr124480665e9.16.1778951506303;
        Sat, 16 May 2026 10:11:46 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4b92.dip0.t-ipconnect.de. [91.43.75.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febf81970sm56216295e9.8.2026.05.16.10.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 10:11:45 -0700 (PDT)
Message-ID: <a56911f8-9c02-464e-b61c-0d565a5dbd43@googlemail.com>
Date: Sat, 16 May 2026 19:11:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
To: Greg KH <gregkh@linuxfoundation.org>,
 Wentao Guan <guanwentao@uniontech.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <20260515154653.469907118@linuxfoundation.org>
 <20260515190713.620177-1-guanwentao@uniontech.com>
 <2026051658-affront-uplifting-095b@gregkh>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <2026051658-affront-uplifting-095b@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.05.2026 um 12:09 schrieb Greg KH:
> On Sat, May 16, 2026 at 03:07:14AM +0800, Wentao Guan wrote:
>> Build failed, you can drop the commit to build ok, same as 6.18.30-rc1:
>> git revert 14d9ce90cf4855d638ecbcdb0c208a144d6f991b..
>> Revert "sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect isolcpus= domain isolation"
>>
>> Tested-by: Wentao Guan <guanwentao@uniontech.com>
>>
>> BRs
>> Wentao Guan
>>
>> defconfigs:
>> https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9
>>
>> Log:
>> In file included from kernel/sched/build_policy.c:63:
>> kernel/sched/ext.c: In function ‘scx_ops_enable’:
>> kernel/sched/ext.c:5524:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean ‘HK_TYPE_DOMAIN’?
>>   5524 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>>        |                                  ^~~~~~~~~~~~~~~~~~~
>>        |                                  HK_TYPE_DOMAIN
>>
>> missed HK_TYPE_DOMAIN_BOOT is introduced in this commit:
>>
>> commit 4fca0e550d506e1c95504c2d9247bc92bf621bf6
>> Author: Frederic Weisbecker <frederic@kernel.org>
>> Date:   Mon May 26 13:06:21 2025 +0200
>>
>>      sched/isolation: Save boot defined domain flags
>>
>>      HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
>>      but also cpuset isolated partitions.
>>
>>      Housekeeping still needs a way to record what was initially passed
>>      to isolcpus= in order to keep these CPUs isolated after a cpuset
>>      isolated partition is modified or destroyed while containing some of
>>      them.
>>
>>      Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
>>
>>      Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>      Reviewed-by: Phil Auld <pauld@redhat.com>
>>      Reviewed-by: Waiman Long <longman@redhat.com>
>>      Cc: Ingo Molnar <mingo@redhat.com>
>>      Cc: Marco Crivellari <marco.crivellari@suse.com>
>>      Cc: Michal Hocko <mhocko@suse.com>
>>      Cc: Peter Zijlstra <peterz@infradead.org>
>>      Cc: Tejun Heo <tj@kernel.org>
>>      Cc: Thomas Gleixner <tglx@linutronix.de>
>>      Cc: Vlastimil Babka <vbabka@suse.cz>
>>      Cc: Waiman Long <longman@redhat.com>
>>
> 
> Also dropped from here, thanks.  My fault, I should have only backported
> this to 7.0.y as the commit itself said to.
> 
> greg k-h


Now I really wonder why I didn't hit this build error with that patch included in 6.12.90-rc1...
Because I hit it in 6.18.32-rc!

Let me check my .config ...

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
