Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE182E630
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 00:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734483506; cv=none; b=McwrpOi1OsUAKM/VEnl257IlriJr5/DgU8pbNRWDxB06v60IXe3x5g6cQk0GEBKR6EwNyLDuqkFqoItsK+jicjitaLxgBSzSZC36TkjRl4v1cpERo3SorIeMlu/IJ/Gb7zHrLyA51vDD3VAG8ura5ewLEHOaKnoNurTugDD1ocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734483506; c=relaxed/simple;
	bh=LtkxbSYucJHqzzNJJ9Zd02BUAgfyWSBno2HE3nLJ2No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XwPwuPvVUTsYgSnnT8Lg36PHRBCSD0K74y1e4J2vnlbd7PLuuWt9ueSvbEXgOFUdPVkWp8cX3KEm2XppRGq2sbjgLSdZvCnkCMnLTW5KxqWq73IIXXBdI/T/Z2aiQ2yf1//rq4lDRazhkNoFY8XNrkdxeKzht71uX74nFWbBVgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMHGyj/N; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMHGyj/N"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2167141dfa1so2223545ad.1
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 16:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734483504; x=1735088304; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=EfBvshGIgI6H6oqesdN6j1BTdra0NtGVRlFJMwaLpRc=;
        b=JMHGyj/NVlBCxBkZBRnIwsDBUzgXMXg2NBzqDbYwp8jx+afPyF2hx4jvsdAdiCVNJu
         zes7pK8op3h23biLZ07LTHgd+a9jRViazku7tADedhO9nPlQa7lVGrxpuv6cMHcTL9L0
         R/sqZCkN6iRQfjIuMtBopxTI6YR3TBFaXNdXf9mn89BHfb0Gni4WUFlNKun7s6qdXIDN
         xZLjCQmz3II+RpdddIdkSOR1dj7TM/NITRVbP4aexWH/zeLH/3xuKmg7hisKFrGr9Drx
         bNITYZ8W0/YKKhKFOwJE0+uDr2uNdZ+64ivIilCo8V3trF0/yLbf8qTLpjLUE2/sINFK
         f95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734483504; x=1735088304;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfBvshGIgI6H6oqesdN6j1BTdra0NtGVRlFJMwaLpRc=;
        b=xMDLqfTUyO65cvfi2QKVfp32fNOPVbo5e8uj5GGYFblT2VVoafJRmk5K7fKtcH2nMS
         1NMAuuEHO55XabY2Vg9CHzNKR2J8+RUvd5TzOoMfq+gGsVjRl/QSepfuFYuoStw+sLsw
         SlMYIOGWw6jJ52iICwCx8hHO1JOIUhbCxDYmh6F/ggTdp1nnUymgOlFw+SE7bWe+L9Ew
         oTrpj9VA9oLleHsD+kHIbXjbmSUhQClofYztWCGEJicqtEfva2mMwCxl6UFBnIe6OcYU
         CTSTX/Hpgjcp4IwM3gw+yXJk9KwBA0IOmFnngtch9DT++NbRmBx97HZnpyN7a2qs642R
         bQLA==
X-Forwarded-Encrypted: i=1; AJvYcCWHZ/WmsemovBtKxFJphYdZtuZrXNz0dXy6z8577AP0hwjeW5LU0d9vIdmHnJtHgfJL2QhfP9yl@lists.linux.dev
X-Gm-Message-State: AOJu0YxgfQaITWZAGXRDbIq2vOjNbRD+FAAIDzLy7wgQN52ufnYp85St
	mAXBG05pEYCW14xllTQpBDRTg+EGgCzcJA0siN1H0Xe711dm+00Z
X-Gm-Gg: ASbGncvf8CnmWFmtixTIMrZ41cnq90C/da8bbnIrz7PIWWuaP18f0MnWalpxGJLPTT6
	q0dZRcoftyE9jOchg2c4BhrtFFeBBl3J+Vegtaztfs3VwuLxvnD6dpYgQCA1ojfVjg1QDiR+hvp
	Lfeh9ya1OY9iH6abiRgxL2dYzv4DVV6xNnVVYS/zrneDvvLNjnV079qm2HVK2J8Nvo1LZBQNO0w
	KWPfPl2a+umnGMPXrx7eqzUrWAF7mAjagPbxg3imQhoxmh/c08o30lRpK5uj3xPG0tgODWF/YI2
	1xw6pSg9K2y2mE3xoFxB/5wSOIdW4g==
X-Google-Smtp-Source: AGHT+IHEYhdi7KGk/qTekImIW9C/2rhYQ3V8mRMkmV6Ii2jvKrK1Mvr/C3pHDPUaNERkuDlZ2eS+eg==
X-Received: by 2002:a17:903:32cf:b0:215:758c:52e8 with SMTP id d9443c01a7336-218d72940c3mr14491725ad.12.1734483503594;
        Tue, 17 Dec 2024 16:58:23 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e63896sm65301465ad.223.2024.12.17.16.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 16:58:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <20913178-9f85-4342-98bc-15ef7d1d9f3e@roeck-us.net>
Date: Tue, 17 Dec 2024 16:58:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
To: Christian Heusel <christian@heusel.eu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Xinhui Pan <Xinhui.Pan@amd.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org
References: <20241217170546.209657098@linuxfoundation.org>
 <6177fdae-91f3-4170-a6ee-41c46d5703a5@heusel.eu>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <6177fdae-91f3-4170-a6ee-41c46d5703a5@heusel.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 15:43, Christian Heusel wrote:
> On 24/12/17 06:05PM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.6 release.
>> There are 172 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
>> Anything received after that time might be too late.
> 
> Hey everyone,
> 
> when testing the 6.12.6-rc1 release candidate on my Steam Deck I have
> found that the following issue came up (once). On my laptop everything
> works fine and even though the issue below came up the device was ususal
> like always.
> 
> I added the relevant Maintainers into CC so they can judge if it's
> something serious or not. I have also added a full dmesg as an
> attachment. If anybody has idea about possible reproducers I would be
> interested in that aswell, as I only saw the issue once so far.
> 

You might hit

https://gitlab.freedesktop.org/drm/amd/-/issues/3799

Guenter

> Cheers,
> Chris
> 
> kernel: CPU: 4 UID: 0 PID: 436 Comm: kworker/u32:4 Not tainted 6.12.6-rc1-1home #1 c49ee701ad1a1a28c82c80281ff6159df069d19b
> kernel: Hardware name: Valve Jupiter/Jupiter, BIOS F7A0131 01/30/2024
> kernel: Workqueue: sdma0 drm_sched_run_job_work [gpu_sched]
> kernel: RIP: 0010:check_flush_dependency+0xfc/0x120
> kernel: Code: 8b 45 18 48 8d b2 c0 00 00 00 49 89 e8 48 8d 8b c0 00 00 00 48 c7 c7 e0 a1 ae a8 c6 05 29 03 16 02 01 48 89 c2 e8 04 8e fd ff <0f> 0b e9 1f ff ff ff 80 3d 14 03 16 02 00 75 93 e9 4a ff ff ff 66
> kernel: RSP: 0018:ffffa65802707c60 EFLAGS: 00010082
> kernel: RAX: 0000000000000000 RBX: ffff958c80050800 RCX: 0000000000000027
> kernel: RDX: ffff958fb00218c8 RSI: 0000000000000001 RDI: ffff958fb00218c0
> kernel: RBP: ffffffffc0a2eb00 R08: 0000000000000000 R09: ffffa65802707ae0
> kernel: R10: ffffffffa92b54e8 R11: 0000000000000003 R12: ffff958c899b3580
> kernel: R13: ffff958c8cc71c00 R14: ffffa65802707c90 R15: 0000000000000001
> kernel: FS:  0000000000000000(0000) GS:ffff958fb0000000(0000) knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 00007f764c0d5000 CR3: 00000001b6222000 CR4: 0000000000350ef0
> kernel: Call Trace:
> kernel:  <TASK>
> kernel:  ? check_flush_dependency+0xfc/0x120
> kernel:  ? __warn.cold+0x93/0xf6
> kernel:  ? check_flush_dependency+0xfc/0x120
> kernel:  ? report_bug+0xff/0x140
> kernel:  ? handle_bug+0x58/0x90
> kernel:  ? exc_invalid_op+0x17/0x70
> kernel:  ? asm_exc_invalid_op+0x1a/0x20
> kernel:  ? __pfx_amdgpu_device_delay_enable_gfx_off+0x10/0x10 [amdgpu 857aca8165f9b9ab3793f37419bdc9a45d24aff0]
> kernel:  ? check_flush_dependency+0xfc/0x120
> kernel:  __flush_work+0x110/0x2c0
> kernel:  cancel_delayed_work_sync+0x5e/0x80
> kernel:  amdgpu_gfx_off_ctrl+0xad/0x140 [amdgpu 857aca8165f9b9ab3793f37419bdc9a45d24aff0]
> kernel:  amdgpu_ring_alloc+0x43/0x60 [amdgpu 857aca8165f9b9ab3793f37419bdc9a45d24aff0]
> kernel:  amdgpu_ib_schedule+0xf0/0x730 [amdgpu 857aca8165f9b9ab3793f37419bdc9a45d24aff0]
> kernel:  amdgpu_job_run+0x8c/0x170 [amdgpu 857aca8165f9b9ab3793f37419bdc9a45d24aff0]
> kernel:  ? mod_delayed_work_on+0xa4/0xb0
> kernel:  drm_sched_run_job_work+0x25c/0x3f0 [gpu_sched da7f9c92395781c75e4ac0d605a4cf839a336d2f]
> kernel:  ? srso_return_thunk+0x5/0x5f
> kernel:  process_one_work+0x17e/0x330
> kernel:  worker_thread+0x2ce/0x3f0
> kernel:  ? __pfx_worker_thread+0x10/0x10
> kernel:  kthread+0xd2/0x100
> kernel:  ? __pfx_kthread+0x10/0x10
> kernel:  ret_from_fork+0x34/0x50
> kernel:  ? __pfx_kthread+0x10/0x10
> kernel:  ret_from_fork_asm+0x1a/0x30
> kernel:  </TASK>
> kernel: ---[ end trace 0000000000000000 ]---
> 

