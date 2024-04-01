Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CA4CE13
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 19:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711998250; cv=none; b=BVM5FeIGCKpL0ofY2Zj72NcX+KlhzLVyz68LHTUdGKHcnzyuN+Szo+9A9EHwgGFmtYhHQpxL+eHiAd5eNMio8lk92GoiDmKikFJY8AO1CjtsblnlFA5DWVly0FWvjQcrncTwxWI9Mogoa6SB1/w0YLemc+X7tEnIflMrvClPx+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711998250; c=relaxed/simple;
	bh=7YFzwRTLlPh301ibtaPdumqzzLLM37WL5MqJHvPd2iA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ji4a1o4DZTeqdtYCYAM35sS1mOo5P/49cnOeXfflABkF++rW4sR/oavMPz3mDMCi2QRruUzS/1AsCLLU986s7FunSV7vyiyZux8WUzyIjSZLuXbgFWCRee95eyY9WNy5nMg9WBWCxtVzNVSdl1DhkpvH2CrIEpADAwDyPfzPYNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wdTN8azE; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wdTN8azE"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5a7c3dd2556so443208eaf.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 12:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711998247; x=1712603047; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yYvO3v5OtgUEtXlnG8GDoLjAfRWwq7ns796AeG3oL58=;
        b=wdTN8azE8iL8yI3qRDETDXWDI1fBH9pA48fSBH6tzJrgbCQKvNbNQOcf82M2tMQYoA
         EwNivy8g43HM7VZrLwmQZ7TUH/rT7uRmdsMDKjTjXowJfjDPVIDj1/uj56bqxClG/Mp7
         gltKGdJfsULPqswqV8s+spgekC0xohrE9lO/1BVX5eujSAA36k6ZXC72Ylze+pwq1WYq
         ApLaTraC8BiUKIb5HjCgdHyKaj5Varry4jw2LgTTLwVin6KlajpcZnB9zyDVLOxj/hmk
         xJb+YC20kMkS1fAOOJy1mnTYcS+Mf0QEHCQ4XmhqyzU2daNKtsF3wuYWMWKci7DhiQg+
         mwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711998247; x=1712603047;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yYvO3v5OtgUEtXlnG8GDoLjAfRWwq7ns796AeG3oL58=;
        b=QGIfwY8oA/YmwvePw7++AAXJDONbw3clDhgxu8aGW5S7gnVx6ze1cd+j8BA2WI3Uzp
         3ycihYhHhIGE/SfMU27G/PnTUgWRD38GriA+8GslSXH6ImJDACy/WZ1SyhyFZ5i/W9qS
         LJpN9qjKiS3RPEUi/qhsBiTS8qRSgT0iC+7AEOzIvPKOGMbhQYZ+AVFQhY6/TPIlVEOS
         bf8AV/1sPBOaCqcJJ+sFKEbMQfXvlN10PqHZ9gbkNuJVVCOvyoGnQ0z6hWDHs7iROavQ
         UWgm5+W5cvs1ZUIHU2hwhipX0qTRlaEWhj6Q7Mnqrb6o4TQ8ZicAe+CdhWrqWt/aPZb0
         czkw==
X-Forwarded-Encrypted: i=1; AJvYcCX2rGDB/A9y2/nNxdmnAqaVbVuPfPM6n2473VVW6Rp6ycKUXWQhPXgWVfRcwRXEeBQLRPz0f6HaCcl7zZh5P0YYNMKj9jXTQg==
X-Gm-Message-State: AOJu0YzhweWKughxM084RIk+yigDimuFYOxwRD3Yngtw96u4EbuIFvde
	1O4IX3sFYanQybtS42YPMAKsK/TNtXIyXVm+FsFpUWhXO2DXZ2uyvMUuISAwrUZQg6C/eWJLrGx
	misiKFwGdE45T4GGoeMryCr9OSObrq9TCFN4aDg==
X-Google-Smtp-Source: AGHT+IFZnjA9wbTE9xX1zGLihZXyUphLjo+EmppgipT7ou4wJ7gElQqC1DGtC8501AbmNk8APlrrdsleR3G66uawajg=
X-Received: by 2002:a05:6808:2114:b0:3c4:ea03:81b with SMTP id
 r20-20020a056808211400b003c4ea03081bmr4330021oiw.2.1711998246673; Mon, 01 Apr
 2024 12:04:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152549.131030308@linuxfoundation.org>
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Apr 2024 00:33:55 +0530
Message-ID: <CA+G9fYs5MZaPV+tTukfUbJtdztQMExfixo=ZwbBr1A6Oga+OLQ@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Apr 2024 at 21:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following kernel warnings have been noticed on qemu-x86_64 while running LTP
cve ioctl_sg01 tests the kernel with stable-rc 6.6.24-rc1, 6.7.12-rc1 and
6.8.3-rc1.

We have started bi-secting this issue.
Always reproduced.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ioctl_sg01.c:81: TINFO: Found SCSI device /dev/sg0
------------[ cut here ]------------
[   36.606841] WARNING: CPU: 0 PID: 8 at drivers/scsi/sg.c:2237
sg_remove_sfp_usercontext+0x145/0x150
[   36.609445] Modules linked in:
[   36.610793] CPU: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.6.24-rc1 #1
[   36.611568] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
[   36.612872] Workqueue: events sg_remove_sfp_usercontext
[   36.613691] RIP: 0010:sg_remove_sfp_usercontext+0x145/0x150

<trim>

[   36.621539] Call Trace:
[   36.621953]  <TASK>
[   36.622444]  ? show_regs+0x69/0x80
[   36.622819]  ? __warn+0x8d/0x150
[   36.623078]  ? sg_remove_sfp_usercontext+0x145/0x150
[   36.623558]  ? report_bug+0x171/0x1a0
[   36.623881]  ? handle_bug+0x42/0x80
[   36.624070]  ? exc_invalid_op+0x1c/0x70
[   36.624491]  ? asm_exc_invalid_op+0x1f/0x30
[   36.624897]  ? sg_remove_sfp_usercontext+0x145/0x150
[   36.625408]  process_one_work+0x141/0x300
[   36.625769]  worker_thread+0x2f6/0x430
[   36.626073]  ? __pfx_worker_thread+0x10/0x10
[   36.626529]  kthread+0x105/0x140
[   36.626778]  ? __pfx_kthread+0x10/0x10
[   36.627059]  ret_from_fork+0x41/0x60
[   36.627441]  ? __pfx_kthread+0x10/0x10
[   36.627735]  ret_from_fork_asm+0x1b/0x30
[   36.628293]  </TASK>
[   36.628604] ---[ end trace 0000000000000000 ]---
ioctl_sg01.c:122: TPASS: Output buffer is empty, no data leaked

Suspecting commit:
-----
scsi: sg: Avoid sg device teardown race
commit 27f58c04a8f438078583041468ec60597841284d upstream.

 + WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);

Steps to reproduce:
- https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2eVWFlAeOUepfeFVkrOXFYNNAqI/reproducer

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.23-397-g75a2533b74d0/testrun/23255318/suite/log-parser-test/tests/
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2eVTitwVMagaiWhs5T2iKH390D5


--
Linaro LKFT
https://lkft.linaro.org
