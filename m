Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EC930BB88
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 12:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771417068; cv=pass; b=uXyPgdUwt+AUUDdsGiwD9ho81bMGNzvzVWj9YAtxodiODYCw4x/CXnDuP92tgmmHrKtp1YF6v2/Yy6Tiu432v3GDa0ndfFEosRKivUZTsGT6WNitZRE3rm8Y78Zkn3T3fWzKqwbc/RDUAfzArez5p3ZS2sniQwWIJPI69mmx+yA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771417068; c=relaxed/simple;
	bh=hDMNd74Pxc2U5r6cQ0S83TyLQHXk1qYR0EipkoSEDh0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YaUZ5pXEnk6a6j5boG9EYxxrABi0OjxxhCrh17Pjl9OrgBsGhqCIjwYdDLGyyeHRJnxtSKjJ0bGn33xv7bjNGfRySudEJxwBn0kjrC/tLlS8VElKfL/2OG7KJX6/s2gcpPk3OIkwx3FKzS3H6V4nVUktAFKUoH/g3b3xdiuw3dE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e/BP/IHm; arc=pass smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/BP/IHm"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b6b0500e06so6135100eec.1
        for <patches@lists.linux.dev>; Wed, 18 Feb 2026 04:17:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771417066; cv=none;
        d=google.com; s=arc-20240605;
        b=WXbdk3VMWvamH+VVcCEkXZ5jvy5XHhyEeSlEPkTXIEoQEzA8K2HxOQnYvm/zixeJNZ
         3HedopatbpfJI22H53HVHIoe+YboNmL9oFLjvZwX9cWJGr2nlifgdl+nuR4zS4rgAOr+
         TauM+DnWUW4UGSb9RyJNRKVEKUCO0g4w61RzhSFFBEFWG3h8pRT/mgsIA0CMA3yamtHa
         XiXpytOyHs0S1V2X7TbO7l8SpMkxSKgWatFqYGNpxmLNHZpgCDMBKfrbkFm3akHKed4h
         EjQUzKrfuPm6B/AZOQ2fwUC+3KrWt0RiwdhdBBf6gfMpgFwjorcl4hqJzVpmJD9C39UA
         Lj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hlcD4mBl619MgaHciYViGbfD9oWOmC4uxOrCB3gT72Q=;
        fh=JTY3AJdCMe3gp4A7iBOWifndmKSdTfJ5AUR6GhkPqMU=;
        b=VVKafmVDlSzvjtgALtXqtyd5Xwnb7J4mO8SIa8PI9DILDk0Aw4PtbdauZaVWUqJKZd
         p7CvM9K375VKAr42SAevGFCcl2iVfh2na4FsT4u/oyfb3iTUt9A+yQ6IEprEzQXJrfoZ
         jgtcvkAUePzZK7cE+6VkjteSNXe/iw5svguhIGPj+Lm5FSeKw3pGgv5+fb/L69X12m2x
         0ts1GwZLov9ZQb/Jgt4XYPKn+Hrls2CDnwLzxRQVM4npyclbFN2VI4TC8IEWcl5b9xdD
         YsjhIAt8Pp1tDEGaviV2ECIFgWHy/TeMQys8kT29EEGFuyPsoBmfwSdaJ7j5aIFYd1tW
         bXTQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771417066; x=1772021866; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hlcD4mBl619MgaHciYViGbfD9oWOmC4uxOrCB3gT72Q=;
        b=e/BP/IHmrvQ8Q1JR/HN5VZ66p4SFxFKwntInzVwbCnzSIdbr0dPv4goFR/PRh+4ewx
         3hXmAPFrNCYNXyUlNoq63vWnBPRfBHLYpgQ/GlLCMDMNnNhZQQGjwF5NQu9SF/GxUcPi
         wpGSt8VMNDcXkuJIDjLmRTHiDFv7MagPk8MF4J6Mg+RJNUJmn3hfUNusss0yAj+TvAhM
         bC4WfO+0/vKZE96NdCw+zB2/VWB/+KRYeM+XRR31E0aPzmGPzdMtlcbT7Y9r+QR7cMZp
         pGcfLeQFfU2fpMrrhK8a38OKD4vih5DaAZPquhEBVjU695Jsn6joWNZnfedEoIKng7em
         X71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771417066; x=1772021866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hlcD4mBl619MgaHciYViGbfD9oWOmC4uxOrCB3gT72Q=;
        b=TWyBc2tMUUxl9nRlMLU9QtYyP8C4YaM0uoRQ/jwWO7ulonuBVmZh2wP9wE4J8sC3/y
         JSd2fWGjD6jW0Z52OtxTdzOAV1Bm7qsZcAZbm883oB5oLtxp2BEqAw32P50odXxCX236
         +tjDxec3H9or6+TVwUwL4QW99TNBwSKLgbdyPRijLLOvdwPoC0bsN3CW/G0Fs/y8v09U
         5d9PrLYfkQvpfiGl6QEFktQEhUIGAFNuwYtMn04yz5hLtGFtx/8P7LpQ6zunsmyM8niE
         VtxGq4nvTkTKcmgsjq2+wS8t1SnIeax26IOCcROycor/G37H7zaLmWsFjctcaG/4w09I
         OtuA==
X-Forwarded-Encrypted: i=1; AJvYcCVRtapM7kje6sueYngwjhmUHlhf86sMltrEXwPjX/uLz36a+cllUM4UJl+8TQDO3VR/yDqNYg2G@lists.linux.dev
X-Gm-Message-State: AOJu0YxG8uovZZUWtdhqifzb00OObzUrNM16TfsMa066RdHbWJ3FlXqm
	f2TZQU2wxAjHXvOSs5G8O1auP9XybPUiqnZ8kCYcx1BWwdOcIrdggSsV8h4c/2qatkKKmAiONNh
	xV5PjfmV5FTPH+4XxvXLgojUNV7cTykE=
X-Gm-Gg: AZuq6aL9U6YagqvLHeRgNIznIJCmaV0LdavN7/GZl26svNb/07P7AFIZ3LeXM50MX0U
	2WnqyHzlp31G19NkXw+mwQsUyzyg47brKPfjKkOEwpSgio3CF+nwEVTluWWBffmD/Res3foGkcl
	KBgPYLoSkhGsN/1oUUkQ15lMRIDSkma1S2vd/dCQNAMiaThIBqOaYGu6Mha+XGjWJiqd30Dt8sw
	FAKKKrkESM3nppXZbnkzX+H76StXmItkzrno4PtYJAmC0Vb2l1/hlVU40/6oaBtrUr7u5Hvt3hz
	ORS8xRA4NfINv+iLu8F56Odcgksguk18YUIU1YhOjxWCnLI8IF3yXgkX+8WRHMId2iVYLDfTyYK
	HacOzFYvh1rpyz+uAfrJmyXHFzB6WEo8hCBQUhFuw8Ns/7jEhhs8j54PbWJ87IAr7Akajs79tyL
	0z4TS3alXASi6nnd8bCESVaIc5PqD7prbKbQMxMg==
X-Received: by 2002:a05:7300:23cc:b0:2ba:769b:813e with SMTP id
 5a478bee46e88-2baba13689dmr6737357eec.38.1771417057499; Wed, 18 Feb 2026
 04:17:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260217200006.470920131@linuxfoundation.org>
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 18 Feb 2026 13:17:24 +0100
X-Gm-Features: AaiRm50U6OECfKkNegrsfdYjbIrz9JKTIu4dsD8NtGlz0cAT1gG99TY7AZgdDj0
Message-ID: <CADo9pHiSp3BrQs15Dc-E4TZTx9aHWpsnT1ZQseh222ZH0XdAzQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/43] 6.18.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested on: Arch Linux Machine a Dell Micro 3050 with a
model name    : Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
and works as it should


Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den tis 17 feb. 2026 kl 21:52 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.18.13 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
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
>     Linux 6.18.13-rc1
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
> Chen Ridong <chenridong@huawei.com>
>     cpuset: Fix missing adaptation for cpuset_is_populated
>
> Tiezhu Yang <yangtiezhu@loongson.cn>
>     LoongArch: Rework KASAN initialization for PTW-enabled systems
>
> David Hildenbrand (Red Hat) <david@kernel.org>
>     mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables us=
ing mmu_gather
>
> Otto Pfl=C3=BCger <otto.pflueger@abscue.de>
>     arm64: dts: mediatek: mt8183: Add missing endpoint IDs to display gra=
ph
>
> Alban Bedel <alban.bedel@lht.dlh.de>
>     gpiolib: acpi: Fix gpio count with string references
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/fdinfo: be a bit nicer when looping a lot of SQEs/CQEs
>
> Ziyi Guo <n7l8m4@u.northwestern.edu>
>     ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()
>
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: remove assert around dpp_base replacement
>
> Melissa Wen <mwen@igalia.com>
>     drm/amd/display: extend delta clamping logic to CM3 LUT helper
>
> Deepanshu Kartikey <kartikey406@gmail.com>
>     tracing/dma: Cap dma_map_sg tracepoint arrays to prevent buffer overf=
low
>
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: cs42l43: Correct handling of 3-pole jack load detection
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     platform/x86: panasonic-laptop: Fix sysfs group leak in error path
>
> Maciej Strozek <mstrozek@opensource.cirrus.com>
>     ASoC: sof_sdw: Add a quirk for Lenovo laptop using sidecar amps with =
cs42l43
>
> gongqi <550230171hxy@gmail.com>
>     platform/x86/amd/pmc: Add quirk for MECHREVO Wujie 15X Pro
>
> Breno Baptista <brenomb07@gmail.com>
>     ALSA: hda/realtek: Enable headset mic for Acer Nitro 5
>
> Dirk Su <dirk.su@canonical.com>
>     ASoC: amd: yc: Add quirk for HP 200 G2a 16
>
> Tagir Garaev <tgaraev653@gmail.com>
>     ASoC: Intel: sof_es8336: Add DMI quirk for Huawei BOD-WXX9
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     platform/x86: classmate-laptop: Add missing NULL pointer checks
>
> Brahmajit Das <listout@listout.xyz>
>     drm/tegra: hdmi: sor: Fix error: variable =E2=80=98j=E2=80=99 set but=
 not used
>
> Deepanshu Kartikey <kartikey406@gmail.com>
>     romfs: check sb_set_blocksize() return value
>
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek - fixed speaker no sound
>
> Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
>     ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel
>
> Zhang Heng <zhangheng@kylinos.cn>
>     ALSA: hda/realtek: Add quirk for Inspur S14-G1
>
> Xuewen Yan <xuewen.yan@unisoc.com>
>     gpio: sprd: Change sprd_gpio lock to raw_spin_lock
>
> Anatolii Shirykalov <pipocavsobake@gmail.com>
>     ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list
>
> Alice Ryhl <aliceryhl@google.com>
>     rust: driver: fix broken intra-doc links to example driver types
>
> FUJITA Tomonori <fujita.tomonori@gmail.com>
>     rust: dma: fix broken intra-doc links
>
> FUJITA Tomonori <fujita.tomonori@gmail.com>
>     rust: device: fix broken intra-doc links
>
> Anil Gurumurthy <agurumurthy@marvell.com>
>     scsi: qla2xxx: Fix bsg_done() causing double free
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  37 ++++++-
>  arch/loongarch/mm/kasan_init.c                     |  80 +++++++-------
>  drivers/gpio/gpio-sprd.c                           |   8 +-
>  drivers/gpio/gpiolib-acpi-core.c                   |   1 +
>  .../gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |  30 ++++-
>  .../drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h |   2 +-
>  .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |   9 +-
>  .../drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c    |  18 +--
>  .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |  16 +--
>  drivers/gpu/drm/tegra/hdmi.c                       |   4 +-
>  drivers/gpu/drm/tegra/sor.c                        |   4 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu-impl.c         |  14 +++
>  drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  14 ++-
>  drivers/iommu/arm/arm-smmu/arm-smmu.c              |  24 +++-
>  drivers/iommu/arm/arm-smmu/arm-smmu.h              |   5 +
>  drivers/platform/x86/amd/pmc/pmc-quirks.c          |   7 ++
>  drivers/platform/x86/classmate-laptop.c            |  32 ++++++
>  drivers/platform/x86/panasonic-laptop.c            |   4 +-
>  drivers/scsi/qla2xxx/qla_bsg.c                     |  28 +++--
>  drivers/usb/serial/option.c                        |   6 +
>  drivers/video/fbdev/riva/riva_hw.c                 |   3 +
>  drivers/video/fbdev/smscufx.c                      |   8 +-
>  fs/f2fs/data.c                                     |  51 ++++++---
>  fs/f2fs/f2fs.h                                     |  64 ++++++++---
>  fs/f2fs/gc.c                                       |  24 ++--
>  fs/f2fs/node.c                                     |  50 +++++----
>  fs/f2fs/node.h                                     |   8 --
>  fs/f2fs/recovery.c                                 |   6 +-
>  fs/f2fs/segment.c                                  |  86 +++++++-------
>  fs/f2fs/segment.h                                  |   9 +-
>  fs/f2fs/super.c                                    |  26 ++---
>  fs/f2fs/sysfs.c                                    |  62 +++++++++--
>  fs/romfs/super.c                                   |   5 +-
>  include/asm-generic/tlb.h                          |  77 ++++++++++++-
>  include/linux/f2fs_fs.h                            |  73 +++++++-----
>  include/linux/hugetlb.h                            |  15 ++-
>  include/linux/mm_types.h                           |   1 +
>  include/trace/events/dma.h                         |  25 ++++-
>  io_uring/fdinfo.c                                  |  11 +-
>  kernel/cgroup/cpuset.c                             |   2 +-
>  mm/hugetlb.c                                       | 123 ++++++++++++---=
------
>  mm/mmu_gather.c                                    |  33 ++++++
>  mm/rmap.c                                          |  25 +++--
>  rust/kernel/device.rs                              |   6 +-
>  rust/kernel/dma.rs                                 |   5 +-
>  rust/kernel/driver.rs                              |  12 +-
>  sound/hda/codecs/realtek/alc269.c                  |  13 +++
>  sound/soc/amd/yc/acp6x-mach.c                      |  14 +++
>  sound/soc/codecs/cs35l45.c                         |   2 +-
>  sound/soc/codecs/cs42l43-jack.c                    |  37 ++++++-
>  sound/soc/fsl/fsl_xcvr.c                           |   3 +
>  sound/soc/intel/boards/sof_es8336.c                |   9 ++
>  sound/soc/intel/boards/sof_sdw.c                   |   1 +
>  54 files changed, 877 insertions(+), 359 deletions(-)
>
>
>
