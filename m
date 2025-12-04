Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2EC33ADB2
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858514; cv=none; b=dpVjG7S7mPZBLeFRpEC5vZE+Nmz4WQuqj41Q44RraSITYWeNnxkx4xRdyZ6xKWawnHMpO8qb0abPodsvbWmloEMw+C8LH8EyMIf4uPqc5IIJt1tweLx3Nrn84Y/hUTb35XoEoRwmkSGUMr/6oUsrffVVqGH98L4FypCyuzvaBmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858514; c=relaxed/simple;
	bh=ygGX5DRVdgd5dLe/iOuU6yem4lta/9b6Dvr2u0yD4QM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n42h6thDnVPheg3UQZzOYnloOpDwgVGMS6SRy/ishXP9T9vvXjo3IQEiSuYXjk+T/5whnIzqZTz7AEFvSAOr1feksZA4HHMYfxLub6tbrwJIsFdbXO2n3DwbZZgSFBDxqNp3qtEA8paL3SjKRGUFYB+f+G9bKCYLOMAFyW2qu1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hsZC+ffS; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hsZC+ffS"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so646750a12.0
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 06:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764858511; x=1765463311; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5up34gv2Eh3c5muVgE2++/qr8omKiRvDmGaTH+Q9zA=;
        b=hsZC+ffSv1dCMfJqm4k8F3pfkgGAG2if364frzooisJQ/oOxi8hZdXVDtG4lseXevi
         /xJ0Wz2UlZEHYeEey4Yq49GTfLrKP1ROku3pSsP0G25NBB1CLA1TEmiUQCbVcJKxMg7T
         bCArH/47QD2R+WZz2rTFfybnKBeAdY5V8rv2LB0hIbr1Hg8xkR04FjDB9j1knOYBsv0s
         4Z6B7QEnR8Cafl4dJPZ1kU/GuV4v7GIVnlUQwjL4PBG1v2yc4i+EQ4l1P4dqy+RKCvlz
         VcIUyxgHBNK+KQMfmqwExsg7SbRnxAK/eRPgfG6x+TjqYMjkAqeAo/saiyAQqZLirONS
         UmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764858511; x=1765463311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J5up34gv2Eh3c5muVgE2++/qr8omKiRvDmGaTH+Q9zA=;
        b=ghi+Ry0rlRFCNeDYj6AckIOaIf98KxjfmQ3+A5M0wQFJARsOgiBtvn9JHC+t6docEf
         sDK2Uxd1Rk9m6iAGYRTpAfgXzR9V23OsL4eGnBJOVbKQTnHYHfPwJ+/8DhXzdOXK4jTH
         oScpoujHY1U78yNP7it7nIbQ/UwaFVha4lkkXcbPLcL4v0lbr7sJMLsGAdowNXKNdidu
         t+ky4C/oy1Sjpzxr4cDILUl5eOqDRK9EtCN99YoYSZQRbAUjNAwC01s0j8gcXP6cGu7Z
         zd2Li67QticueHDFsYz1ld9JGxupv541UYJPFUm29V0okivn0SEi2hZXmm/ElR3I++oW
         1mKQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2kLRzNEzd+jIVn5ADp0kvoiNaBs76e/FqqlKmoLuCqxLYTTIW1554C+kCogD9fQKKOs0Xy4/F@lists.linux.dev
X-Gm-Message-State: AOJu0YyQbpVURxvkS5m/eyWIq6RVHA/A//nsOPFhB6phi+1FC5HNeCxB
	hQ/OPTULymsixLRTukNLAYFxJ7F2AFrUFNN4PMnbXss8ALxCtBSGBNaj/IXjj4lpUDxuvezvq65
	Ii3tjpmWMgIT49CjWp4WapEVZZTdywtvz3MTXxzmYcw==
X-Gm-Gg: ASbGncumBK11GTtvPvJGvbiV7kz3lVXjAbTkPRJQx704MudufnXxDxUSEyFIR5xgdBN
	mvhIawMIAyarHqjsgywFPC7643anYePJLCo/xAvhJzzw3TzeQ0UTnCVOkGvBdVflnw9cLCH3jZk
	mFZTmYdCgZOCFqzUpW76HZygUhy8GjhzXCLg/EVsjR8jDFyhHoa9EHz+676UCkQDuYsa9bqKN6c
	FN+XKGh0/MjxIi2h8vVVykaXEro/OBaxNyPhI6QZL/w+tklGtOv7VrXAWzJGDpjpg385QvxUyqz
	2w+Jf/soZnKSC2wjfdOoivKZeEjd
X-Google-Smtp-Source: AGHT+IGvf+0II+wCeaY/bk6moaweTqQfAx9HpwRUNg9PFuETthocLz+dz0I6QUZFETK+n517X8mTaGfxo8rZn98tvdY=
X-Received: by 2002:a05:693c:2c09:b0:2a4:3594:72d5 with SMTP id
 5a478bee46e88-2ab92d545d2mr4733118eec.4.1764858510778; Thu, 04 Dec 2025
 06:28:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152440.645416925@linuxfoundation.org> <bae0cb4e-9498-4ceb-945c-55a00725d10e@sirena.org.uk>
In-Reply-To: <bae0cb4e-9498-4ceb-945c-55a00725d10e@sirena.org.uk>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Dec 2025 19:58:19 +0530
X-Gm-Features: AWmQ_bm3taM1NWauArG_gpQ8u40YrUi0hDis2k3qrsTCqWX97CPc3VDwIDYXxvU
Message-ID: <CA+G9fYuhFziYBuXS1URXVgFmUahMVfL5uaT0a75yFOTjZsOPvg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	Mark Brown <broonie@kernel.org>, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com, 
	Kiryl Shutsemau <kas@kernel.org>, Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Dec 2025 at 17:36, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Dec 03, 2025 at 04:20:02PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.159 release.
> > There are 568 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> I'm seeing a bunch of systems start failing with this release, they
> start OOMing when previously they ran OK.  Most of them aren't exactly
> overburned with memory.  These failures bisect to 61717acddadf66
> (mm/memory: do not populate page table entries beyond i_size), sample
> bisect from one of the systems including links to test jobs (the bisects
> for other systems/test sets look very similar):

As Mark=E2=80=99s reported, the LKFT reproduced the same regression on Juno=
-r2,
FVP and qemu-arm64 during boot.

### boot log
<0>[   42.433802] Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP"}
<4>[   42.434147] Modules linked in: fuse drm ip_tables x_tables"}
<4>[   42.434573] CPU: 1 PID: 374 Comm: skipgen Not tainted 6.1.159-rc1 #1"=
}
<4>[   42.435344] Hardware name: linux,dummy-virt (DT)"}
<4>[   42.436140] pstate: 42402009 (nZcv daif +PAN -UAO +TCO -DIT
-SSBS BTYPE=3D--)"}
<4>[   42.437004] pc : _raw_spin_lock+0x3c/0x8c"}
<4>[   42.438173] lr : _raw_spin_lock+0x28/0x8c"}

Boot regression: Juno-r2, FVP, Internal error: Oops: _raw_spin_lock
filemap_map_pages
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## commit point to,
  mm/memory: do not populate page table entries beyond i_size
  [ Upstream commit 74207de2ba10c2973334906822dc94d2e859ffc5 ]

### Links,
 - https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.1.y/v6.1.158=
-569-gabd89c70c938/log-parser-test/internal-error-oops-Oops_PREEMPT_SMP___r=
aw_spin_lock-a94221fb/
 - https://lkft.validation.linaro.org/scheduler/job/8540690#L1835
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/36LJeld=
PNf0LMr3PSr7WYaPqCFa

--
Linaro LKFT
https://lkft.linaro.org
