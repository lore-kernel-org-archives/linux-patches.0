Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7070E30DED0
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 12:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771417025; cv=pass; b=mM/bED5F3MVw01+9bYgFyNgbMCaJdsKr/k9Ve06P8UkDGTy9DXN+Qk5tiB9o2zrXUHcrVIYMrtWSBSZh0AtleQBEcUvTY/SW8tN/QikNQVDZA3Ad/iqELPIaNnGHjmW6ijN97QifsrlrHKklCxsNNc8DI9M7mK4Pe3B9slJ40TM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771417025; c=relaxed/simple;
	bh=Q52a4UJfvIsleI0KiLJqmKoW253Zn7XVEUEx+gL2Nbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tjWILI6KLB0BR5AArFW2Its3YGtKzf0BNm4OF/gXdhopmP7gOBYrLaOiWaKdFa3l7B7G3Jq/yMT2I2rKwx3N6B/83yOIXSCOJzTSBbhXl8gcNmz8mS5KkLAJ9dY3ANc8zPJEhRFhzyHdqIVJNMo5h3KFsUbLthj0lyoaGmgZTK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nixaEdwm; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nixaEdwm"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2b785801c93so369510eec.0
        for <patches@lists.linux.dev>; Wed, 18 Feb 2026 04:17:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771417022; cv=none;
        d=google.com; s=arc-20240605;
        b=ewxlZGQABOiPMuAZn6N1DOxXEdZZnXsTYLhHWHRK6os4GPkhak0M/KJOOa0qp3BaZt
         xiQ+IKxrfpgfOzyAvK/Ne2ZmEV+esfT+O7mHDJNFIrRd6Rptuayx6tD+N7d8gGMMmHVF
         rr51GO+T816GqozJ28YNFgXyNaUkNViA/uG2BX9pe2/HTyu2IIbw6ImE9lqAFnLNKkYB
         gLnQaKINrC+kCLylzDTQ1KMHi/xfozeTzLPS+paDCRXNPP9RoN03NDcnmpmBDhrkrcvO
         CgptM3r4KiVE+7wcnwunEwRKupxUY28NSFjBslaO4eP+LZ89vkypSKPPlKPQY3JX2q05
         t+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ozglTU0/5jdL+iGl35JF4KdKCYTgtwfXNxsYuR40g5k=;
        fh=GCGbCmyMzrNC+4F6l0N3yPjtLXPiuffSD3+ZSCUyCdM=;
        b=fMb7Yif0vs4esZr7pYcmYW/hbUidPD+BTKGBP22U/awyjZbxHwoXoSoMCuBdk8XcP6
         WTYtHYmQzb514gETrVkzeX9COJs5OgT+Mb0TSVnqHk/XGQe1zIZ3ifXArMhsDDDpSqB6
         FnCw7AkpjdSvMIYlDajFkKMvDpwFo838pKyAdG4rl0nRjflKM408cWJn5wLat4QMNYMr
         vO+ySJtu8yFQ986YlO+9TD9OXrkjEyyZ9L9qwPGSPrvyQhFHnyIataheMchwOLTeT6C4
         7vUrUgbY7VNTqWcb8CC+FJU656OSVLfN/Tlq6RxQuEsYEDdB6wBDAfJ/xvBOpzf5P0xS
         pptA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771417022; x=1772021822; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozglTU0/5jdL+iGl35JF4KdKCYTgtwfXNxsYuR40g5k=;
        b=nixaEdwmvrJtOkBzvM6c0/vLhOVOgpamD92WCn4iS92RwLG1DSIH1zgixJGATbOoMW
         B5fhQnOb68OvCWP4PBeK3sr9tYIgpDgA3cnI09gY1f09xOqlzdT6Jn5GxxcOaRQUqqeT
         0Ex5P3Swre9IHoAqkSvPpctp1vO8OfPATmYO+xZOuITvKT14WzwCFlsrmurZqLTOIM4f
         sWGNrXKsnZSnqIMwXDDe3OWDFfAfDCfLYGxJVCkk+RRqECCt2ziCtZsElDhlD1gmKiZY
         YrgkC/odu6VWTh6O7F6eWyrOoWYsTeDP7dqYboVJO3ZtvNONqoZfXzDHvRrxVGc+T808
         EBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771417022; x=1772021822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ozglTU0/5jdL+iGl35JF4KdKCYTgtwfXNxsYuR40g5k=;
        b=gbNgFUyd1sncNQL0nqOi+ZlM5LhCjDj8SuItZFo2qDsHJaz6HlpB4Dd7/LlnltzeYz
         Iqx7wuAiHTBntJRWbZhj23aIbPYoyHgvluTHzOy7/jyGvVkCNMf0pXm+MHEnsNMpp1oC
         dg1FKo0EU9lJsRr2c51lQH+svvcdLjH4fj5AFOSRwhbfynTesC7vVtUag1cbsXnK+iUs
         qky0YT0TIP1yHYOV+rvxs2lKRVOYvq0mj5zzdJ1qW3SwcoeOtCEDo99SyUCzqlLvipi0
         JrQHaeiDwY/+eAzCVRpewqyDvzK+PwQfA2ZgYFqLPjBs81yQSFlFc9p3G69yIMrO/IWm
         E3Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWp31HL7LikrHVrFjJ01K1ksjHeoQF9oxTNO7rZkEF8hNSXJ+5pFRohanfQPLsJgQQaA3x4IGkk@lists.linux.dev
X-Gm-Message-State: AOJu0YwgpR5rHFFfIb5InAu98104LjHtH+oW5bB/GZhRhETewsMdjb7i
	uMgabaIqEQIBhFygyUopS8svICzRZ4rJWk0BR2GLkt+F/thq4GmU2px3O4vjNPJuU9s5+PersKi
	FTNQMtLmG1uaWYYpEKZmnp4H2PVSMxIk=
X-Gm-Gg: AZuq6aIRkHAmWN0tohk8PdtRXDq8tI8Famsr9EhrxQYWvWlPNqmjhPbsMVdPrc5Yhxp
	0PNDl/LVg7v3w8rj752aXMPd5493EwswhUbkyElU21poxCbDOyGZzolZqYjrZYNARuNIHVBzxFa
	/76WifbxLuNBuK+ND+Y5YHefTFdbZO7Jm0/3SI8Zc6m8Q3/iruuA+ba7h2MAh5X3vwuH0nvLBey
	38kroCEB3mRHNbpyi3mrfe/MMfFO2UGqmFS5e6nIUC9HZf4hqdjc4tTVewKdOKjTAzz4J7BYPjb
	Mw9IwMjMmtFKsIGLF1iD1omhL+HSt5OFYsMXkRhoc5h5dc5T0I9oq3H/9CRPfxhaNyxxqv/h7K7
	iP4sKB39N3ZCCsTicPKkf2+qOICJ8QhvE8E6QK0EBWWLrWz0yRE4uiIv8FOpq5poVljNMwymguu
	XjSw+C0mkWcq4DL8p6BZkAsIyXicCgqlxahzxpeQ==
X-Received: by 2002:a05:7301:1e8c:b0:2ba:7404:f587 with SMTP id
 5a478bee46e88-2bac9795cfamr6303886eec.21.1771417022413; Wed, 18 Feb 2026
 04:17:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260217200002.683975158@linuxfoundation.org>
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 18 Feb 2026 13:16:49 +0100
X-Gm-Features: AaiRm53lbHi9bNe7QArcmodc7DyAzejdocLDCI6dCZ7KtSzzGkFgRK0hE6V-8Dg
Message-ID: <CADo9pHjy5ZhNJb2i00GmunPWb3HpYmbqDWiKu+tKJ5AWkYbjNQ@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tis 17 feb. 2026 kl 21:51 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.19.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.19.3-rc1
>
> Chao Yu <chao@kernel.org>
>     f2fs: fix to do sanity check on node footer in {read,write}_end_io
>
> Chao Yu <chao@kernel.org>
>     f2fs: fix to do sanity check on node footer in __write_node_folio()
>
> Fabio Porcedda <fabio.porcedda@gmail.com>
>     USB: serial: option: add Telit FN920C04 RNDIS compositions
>
> Chao Yu <chao@kernel.org>
>     Revert "f2fs: block cache/dio write during f2fs_enable_checkpoint()"
>
> Danilo Krummrich <dakr@kernel.org>
>     iommu/arm-smmu-qcom: do not register driver in probe()
>
> Yeongjin Gil <youngjin.gil@samsung.com>
>     f2fs: optimize f2fs_overwrite_io() for f2fs_iomap_begin
>
> Chao Yu <chao@kernel.org>
>     f2fs: fix to avoid mapping wrong physical block for swapfile
>
> Daeho Jeong <daehojeong@google.com>
>     f2fs: support non-4KB block size without packed_ssa feature
>
> Chao Yu <chao@kernel.org>
>     f2fs: fix to avoid UAF in f2fs_write_end_io()
>
> Yongpeng Yang <yangyongpeng@xiaomi.com>
>     f2fs: fix out-of-bounds access in sysfs attribute read/write
>
> Yongpeng Yang <yangyongpeng@xiaomi.com>
>     f2fs: fix IS_CHECKPOINTED flag inconsistency issue caused by concurre=
nt atomic commit and checkpoint writes
>
> Chao Yu <chao@kernel.org>
>     f2fs: fix to check sysfs filename w/ gc_pin_file_thresh correctly
>
> Zhiguo Niu <zhiguo.niu@unisoc.com>
>     f2fs: fix to add gc count stat in f2fs_gc_range
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     fbdev: smscufx: properly copy ioctl memory to kernelspace
>
> Guangshuo Li <lgs201920130244@gmail.com>
>     fbdev: rivafb: fix divide error in nv3_arb()
>
> Tiezhu Yang <yangtiezhu@loongson.cn>
>     LoongArch: Rework KASAN initialization for PTW-enabled systems
>
> Otto Pfl=C3=BCger <otto.pflueger@abscue.de>
>     arm64: dts: mediatek: mt8183: Add missing endpoint IDs to display gra=
ph
>
> Anil Gurumurthy <agurumurthy@marvell.com>
>     scsi: qla2xxx: Fix bsg_done() causing double free
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                   |  4 +-
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi   | 37 ++++++++++---
>  arch/loongarch/mm/kasan_init.c             | 80 +++++++++++++-----------=
---
>  drivers/iommu/arm/arm-smmu/arm-smmu-impl.c | 14 +++++
>  drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 14 +++--
>  drivers/iommu/arm/arm-smmu/arm-smmu.c      | 24 ++++++++-
>  drivers/iommu/arm/arm-smmu/arm-smmu.h      |  5 ++
>  drivers/scsi/qla2xxx/qla_bsg.c             | 28 ++++++----
>  drivers/usb/serial/option.c                |  6 +++
>  drivers/video/fbdev/riva/riva_hw.c         |  3 ++
>  drivers/video/fbdev/smscufx.c              |  8 ++-
>  fs/f2fs/data.c                             | 53 ++++++++++++------
>  fs/f2fs/f2fs.h                             | 67 +++++++++++++++++------
>  fs/f2fs/gc.c                               | 24 +++++----
>  fs/f2fs/node.c                             | 50 ++++++++++-------
>  fs/f2fs/node.h                             |  8 ---
>  fs/f2fs/recovery.c                         |  6 +--
>  fs/f2fs/segment.c                          | 86 ++++++++++++++++--------=
------
>  fs/f2fs/segment.h                          |  9 ++--
>  fs/f2fs/super.c                            | 64 +++++++---------------
>  fs/f2fs/sysfs.c                            | 62 +++++++++++++++++----
>  include/linux/f2fs_fs.h                    | 73 +++++++++++++++---------=
-
>  22 files changed, 460 insertions(+), 265 deletions(-)
>
>
>
