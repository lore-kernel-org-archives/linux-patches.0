Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4914B26FDB2
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755700576; cv=none; b=Vgy+kf0dU3R0JpCDP3/JoYQHgpnKpHurTkuqglfj6JAWi8i+Vg2eZA8OE9fVd0LLBnNyqbf4Pnz9aI3QzJ8hH1V4hXrzOqLwJm7jBC6LQ4ihC+1k5lA4sMuVlL+mFaaE45ppunJoySpZFCUnGJ/OPcJ3GZcCR548j8dP1qSoUvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755700576; c=relaxed/simple;
	bh=4hBT+buiES17wXgKl6UMMYEyTZ1Pb3414IbE2VoRNAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J9NKIXKhs2ijWzut61a8Ea3GQd7YO7aH1b5CkOUBaKjjv7H2oXRDFYEW1SV8cIHlX9WQBZEq3KkHspnxy36yqnQszoBQB93rxM7lkvEtkDpeAUNobCWlvfcjcLBfyeIhHaU2+kca+7CY8q9o6PH1xAhkALgSLSEDA78k7dNNHVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x/XcIeYl; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x/XcIeYl"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32326e8005bso6598631a91.3
        for <patches@lists.linux.dev>; Wed, 20 Aug 2025 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755700573; x=1756305373; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PbJBv/3H5428xs4cdRW4AQdn6v112iL6mkHWnmkXwqE=;
        b=x/XcIeYl33NXH5tetSe9CH8JYJfiIKTEY+SB/WjxN5A4/YfObtZbT2TazB7m2GjsIp
         d3i80mQXvveOm/pMivnbKEhw6rVEqp3yHLrTLo708xpexEj8gvQy/aNkMn9YLraFHkr9
         Dyn214K7aC0Pt7hfDj+kZJttIfvMmRHMff/zfC8IWOOahP2Dt0KD3SszSc9p2PA95e6x
         wvRDYJn+RSJTMLAjF7OKn/5WoaJ37LkJjTdyy7OcHxMJNGkfk/JNrMeEKis91gMPL3ub
         8DWX737/cIpX76QKCC5v/h2Vawuqk/M4tEzJr2ZHDXL6hzgcni0405TnlEjZJPaW+2hZ
         lWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755700573; x=1756305373;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PbJBv/3H5428xs4cdRW4AQdn6v112iL6mkHWnmkXwqE=;
        b=DWbCM3aXF8Vb+NSvdVqoe92ZgqS5s2C8vldpnicX3s5Ub7EdU29QH7/VR3LNw6zIIl
         9hmGspaE4Z9uFYSuBnPgLmBZxUcln9bq0i0/SQDCTd0VwiBc8eMGgMj6z44CjHz0FgMF
         IH+dJdHy11R5BbvF58g9djyGGCMt2oTJrHiEJum/tYXjyJ4lI1Xyi90Vjy5+CoF+dqyc
         gSWPVijHxpKomsUxsGKoi3Yq3Y8r1XqiUq0jgZLY/3Gv1zIlmYPiM31PeglNho/6OpGG
         RvQg2zZ6hs8MrHIVvMt/Q6kiYx/YbneHx8JyD0p7BkPT2K08dpZ9DedyFoTJb9XVOGGy
         nBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTYk0frz58plhnxNy3fNeh7PqRNiNvr+HWQCgJV5GhYO4kzAqMqkhlE91P9yNZz0yx2H84fIHv@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9txF6FQBBe/n18fS/JYsX4WO3L5x3aJ3V5/HshiaK8K30NwEN
	LiFof1A9NNDB9v+J02HWDAwbdXhRKGsPhY6LzCVog9InZhGzMdQPeZVSm2Ck4xLft0v2/OOGsdS
	IdfAEuo7eSjWkpKFzqD7IYQaimdj6BWMkdzWwucV2gQ==
X-Gm-Gg: ASbGncv5WFuFEZqzOvnYcY7evT5wBAQ9DSnbZc6WwNnFxjnj1DjICIvWrVEU0lAakGq
	SvxRbGIXWYc1CdXT1UyQksRiFq8E1X/anbhto5XEa0xWBmSUIzBPPcQFMPLy7eNhxRVDpzBa13s
	tBz1AkN+K6Jn4GznT5NlVHaRoU9HdX8BPloV+OVHGn4Z0DvZXHGMDjWf2GJP4ZblTZ2Ivtx23E2
	lM/JTKcVn5vukxldGqVA6dC+o9OPRNevPwfqH4=
X-Google-Smtp-Source: AGHT+IEdMY4xh4BhwPScUhIgPWf9ZcAB/0weEpDIJ55eNjWwG2Sd0rlo1FnkJtUF8wfhxGfuA4mblTlPnIw0NgaRkjk=
X-Received: by 2002:a17:90a:ec88:b0:31a:9004:899d with SMTP id
 98e67ed59e1d1-324e143e583mr4420576a91.18.1755700573433; Wed, 20 Aug 2025
 07:36:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819122844.483737955@linuxfoundation.org>
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 20 Aug 2025 20:06:01 +0530
X-Gm-Features: Ac12FXyUQdvOPLI9LVSLZtfZIlbJBJH9mNkCOuEMZ2eMxjtxG5PAQO0-gm_8dGI
Message-ID: <CA+G9fYsjac=SLhzVCZqVHnHGADv1KmTAnTdfcrnhnhcLuko+SQ@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, Zhang Yi <yi.zhang@huaweicloud.com>, 
	linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Aug 2025 at 18:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 564 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Aug 2025 12:27:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As I have reported last week on 6.16.1-rc1 as regression is
still noticed on 6.16.2-rc2.

WARNING: CPU: 0 PID: 7012 at fs/jbd2/transaction.c:334 start_this_handle

Full test log:
------------[ cut here ]------------
[  153.965287] WARNING: CPU: 0 PID: 7012 at fs/jbd2/transaction.c:334
start_this_handle+0x4df/0x500
[  153.966304] Modules linked in: tun fuse
[  153.967547] CPU: 0 UID: 0 PID: 7012 Comm: quotacheck Not tainted
6.16.2-rc2 #1 PREEMPT(voluntary)
[  153.968294] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  153.969408] RIP: 0010:start_this_handle+0x4df/0x500
[  153.970243] Code: e9 5b fc ff ff 90 0f 0b 8b 4d a4 65 48 8b 05 a0
27 17 02 48 c7 c7 70 f2 87 ac 8b 55 a0 48 8d b0 c0 07 00 00 e8 a2 09
c7 ff 90 <0f> 0b 90 41 b8 e4 ff ff ff e9 a7 fc ff ff e8 0e c9 e2 00 0f
1f 00
[  153.971734] RSP: 0018:ffffabfb0112bb60 EFLAGS: 00010246
[  153.972336] RAX: 0000000000000049 RBX: ffff93cf8706a800 RCX: 0000000000000000
[  153.973157] RDX: 0000000000000000 RSI: ffffffffaae64a70 RDI: ffffffffaae64a70
[  153.973347] RBP: ffffabfb0112bbd0 R08: 00000000ffffdfff R09: ffffffffacc7c880
[  153.973513] R10: 0000000000000003 R11: ffffffffacc7c880 R12: ffff93cf8706a800
[  153.974263] R13: ffff93cf8044f6c8 R14: 0000000000000000 R15: 0000000000000002
[  153.975058] FS:  00007f245e2d5780(0000) GS:ffff93d04e8ae000(0000)
knlGS:0000000000000000
[  153.975933] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  153.976641] CR2: 00007ff069065690 CR3: 0000000106a0a000 CR4: 00000000000006f0
[  153.977841] Call Trace:
[  153.978279]  <TASK>
[  153.978748]  ? kmem_cache_alloc_noprof+0x119/0x3d0
[  153.979180]  ? __folio_batch_add_and_move+0xb5/0x100
[  153.979691]  jbd2__journal_start+0xfd/0x1f0
[  153.980154]  __ext4_journal_start_sb+0x10d/0x1a0
[  153.980642]  ext4_write_begin+0x17e/0x510
[  153.981132]  generic_perform_write+0x95/0x290
[  153.981569]  ext4_buffered_write_iter+0x6d/0x120
[  153.982014]  ext4_file_write_iter+0xab/0x820
[  153.982315]  ? selinux_file_permission+0x12d/0x1a0
[  153.982754]  ? trace_preempt_on+0x1e/0x70
[  153.983393]  vfs_write+0x2a8/0x4b0
[  153.983886]  ksys_write+0x7b/0xf0
[  153.984248]  __x64_sys_write+0x1d/0x30
[  153.984510]  x64_sys_call+0x2ab/0x20c0
[  153.985107]  do_syscall_64+0xb2/0x2b0
[  153.985513]  entry_SYSCALL_64_after_hwframe+0x77/0x7f


Lore link:
- https://lore.kernel.org/all/CA+G9fYsyYQ3ZL4xaSg1-Tt5Evto7Zd+hgNWZEa9cQLbahA1+xg@mail.gmail.com/
- https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.16.y/v6.16-1186-gb81166f7d590/log-parser-test/exception-warning-cpu-pid-at-fsjbd2transaction-start_this_handle/

--
Linaro LKFT
https://lkft.linaro.org
