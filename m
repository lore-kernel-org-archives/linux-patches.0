Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1A0261B70;
	Tue, 17 Feb 2026 20:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361514; cv=none; b=AlfcOSJJ1qPhm0lD2ISM8LUnanq3Emp9/nhJwBJKUBpfP2mGtPMqU7m4g8DW0dnUPR9lWY/ht7KZ0E5Z0oIE0XRA93PDscaRaP4/PvlDcIQWbtXBIKXl6ZplZjxxs0vqz+gAdr6l6Wv9XFcwEpxYpPzx+OhoOPNSuvRh7kaTwo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361514; c=relaxed/simple;
	bh=IlZ9nycSdH1faeylTXtqRUWy9q82Tprd+DwAXBmQg0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EBcYY6469XAxDyr1oaXQOs5QzfIGgwUM45XN7r4RnjZueb2WFP1jOKePDEdaKwWYU3mohvWJMYa6H0PPEokpaOmWzXbPev8OqWBAIYuvIdKNEscH4bLT4VipbOehdxm52KYS7FgPsx9Oxqng9ywMdUBoPH8crMn4ZDuBCPIr1Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHP2pH0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHP2pH0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C6AC19421;
	Tue, 17 Feb 2026 20:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361514;
	bh=IlZ9nycSdH1faeylTXtqRUWy9q82Tprd+DwAXBmQg0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=GHP2pH0tk0UroYp+m7mqQs9Q9brcYARlSueB3yCaAwVSs2SUHazMBpP4/aX2x/6pO
	 zfksFrYHbbfpQlCH7hkEONIz3r5XKJvkSTG71kPltgCMXs83p5NCVXCYUtPGKDJ7pZ
	 Jq117iuJCa13FE3/3g6ZD01yKF16WNzcvJmx2TtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 00/43] 6.18.13-rc1 review
Date: Tue, 17 Feb 2026 21:31:40 +0100
Message-ID: <20260217200006.470920131@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.13-rc1
X-KernelTest-Deadline: 2026-02-19T20:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.13 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.13-rc1

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node footer in {read,write}_end_io

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node footer in __write_node_folio()

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit FN920C04 RNDIS compositions

Danilo Krummrich <dakr@kernel.org>
    iommu/arm-smmu-qcom: do not register driver in probe()

Yeongjin Gil <youngjin.gil@samsung.com>
    f2fs: optimize f2fs_overwrite_io() for f2fs_iomap_begin

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid mapping wrong physical block for swapfile

Daeho Jeong <daehojeong@google.com>
    f2fs: support non-4KB block size without packed_ssa feature

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_write_end_io()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix out-of-bounds access in sysfs attribute read/write

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix IS_CHECKPOINTED flag inconsistency issue caused by concurrent atomic commit and checkpoint writes

Chao Yu <chao@kernel.org>
    f2fs: fix to check sysfs filename w/ gc_pin_file_thresh correctly

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to add gc count stat in f2fs_gc_range

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: smscufx: properly copy ioctl memory to kernelspace

Guangshuo Li <lgs201920130244@gmail.com>
    fbdev: rivafb: fix divide error in nv3_arb()

Chen Ridong <chenridong@huawei.com>
    cpuset: Fix missing adaptation for cpuset_is_populated

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Rework KASAN initialization for PTW-enabled systems

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather

Otto Pflüger <otto.pflueger@abscue.de>
    arm64: dts: mediatek: mt8183: Add missing endpoint IDs to display graph

Alban Bedel <alban.bedel@lht.dlh.de>
    gpiolib: acpi: Fix gpio count with string references

Jens Axboe <axboe@kernel.dk>
    io_uring/fdinfo: be a bit nicer when looping a lot of SQEs/CQEs

Ziyi Guo <n7l8m4@u.northwestern.edu>
    ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()

Melissa Wen <mwen@igalia.com>
    drm/amd/display: remove assert around dpp_base replacement

Melissa Wen <mwen@igalia.com>
    drm/amd/display: extend delta clamping logic to CM3 LUT helper

Deepanshu Kartikey <kartikey406@gmail.com>
    tracing/dma: Cap dma_map_sg tracepoint arrays to prevent buffer overflow

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Correct handling of 3-pole jack load detection

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: panasonic-laptop: Fix sysfs group leak in error path

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: sof_sdw: Add a quirk for Lenovo laptop using sidecar amps with cs42l43

gongqi <550230171hxy@gmail.com>
    platform/x86/amd/pmc: Add quirk for MECHREVO Wujie 15X Pro

Breno Baptista <brenomb07@gmail.com>
    ALSA: hda/realtek: Enable headset mic for Acer Nitro 5

Dirk Su <dirk.su@canonical.com>
    ASoC: amd: yc: Add quirk for HP 200 G2a 16

Tagir Garaev <tgaraev653@gmail.com>
    ASoC: Intel: sof_es8336: Add DMI quirk for Huawei BOD-WXX9

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: classmate-laptop: Add missing NULL pointer checks

Brahmajit Das <listout@listout.xyz>
    drm/tegra: hdmi: sor: Fix error: variable ‘j’ set but not used

Deepanshu Kartikey <kartikey406@gmail.com>
    romfs: check sb_set_blocksize() return value

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed speaker no sound

Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
    ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Inspur S14-G1

Xuewen Yan <xuewen.yan@unisoc.com>
    gpio: sprd: Change sprd_gpio lock to raw_spin_lock

Anatolii Shirykalov <pipocavsobake@gmail.com>
    ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list

Alice Ryhl <aliceryhl@google.com>
    rust: driver: fix broken intra-doc links to example driver types

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: dma: fix broken intra-doc links

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: device: fix broken intra-doc links

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Fix bsg_done() causing double free


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  37 ++++++-
 arch/loongarch/mm/kasan_init.c                     |  80 +++++++-------
 drivers/gpio/gpio-sprd.c                           |   8 +-
 drivers/gpio/gpiolib-acpi-core.c                   |   1 +
 .../gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |  30 ++++-
 .../drm/amd/display/dc/dwb/dcn30/dcn30_cm_common.h |   2 +-
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |   9 +-
 .../drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c    |  18 +--
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |  16 +--
 drivers/gpu/drm/tegra/hdmi.c                       |   4 +-
 drivers/gpu/drm/tegra/sor.c                        |   4 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-impl.c         |  14 +++
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |  14 ++-
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |  24 +++-
 drivers/iommu/arm/arm-smmu/arm-smmu.h              |   5 +
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |   7 ++
 drivers/platform/x86/classmate-laptop.c            |  32 ++++++
 drivers/platform/x86/panasonic-laptop.c            |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  28 +++--
 drivers/usb/serial/option.c                        |   6 +
 drivers/video/fbdev/riva/riva_hw.c                 |   3 +
 drivers/video/fbdev/smscufx.c                      |   8 +-
 fs/f2fs/data.c                                     |  51 ++++++---
 fs/f2fs/f2fs.h                                     |  64 ++++++++---
 fs/f2fs/gc.c                                       |  24 ++--
 fs/f2fs/node.c                                     |  50 +++++----
 fs/f2fs/node.h                                     |   8 --
 fs/f2fs/recovery.c                                 |   6 +-
 fs/f2fs/segment.c                                  |  86 +++++++-------
 fs/f2fs/segment.h                                  |   9 +-
 fs/f2fs/super.c                                    |  26 ++---
 fs/f2fs/sysfs.c                                    |  62 +++++++++--
 fs/romfs/super.c                                   |   5 +-
 include/asm-generic/tlb.h                          |  77 ++++++++++++-
 include/linux/f2fs_fs.h                            |  73 +++++++-----
 include/linux/hugetlb.h                            |  15 ++-
 include/linux/mm_types.h                           |   1 +
 include/trace/events/dma.h                         |  25 ++++-
 io_uring/fdinfo.c                                  |  11 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 mm/hugetlb.c                                       | 123 ++++++++++++---------
 mm/mmu_gather.c                                    |  33 ++++++
 mm/rmap.c                                          |  25 +++--
 rust/kernel/device.rs                              |   6 +-
 rust/kernel/dma.rs                                 |   5 +-
 rust/kernel/driver.rs                              |  12 +-
 sound/hda/codecs/realtek/alc269.c                  |  13 +++
 sound/soc/amd/yc/acp6x-mach.c                      |  14 +++
 sound/soc/codecs/cs35l45.c                         |   2 +-
 sound/soc/codecs/cs42l43-jack.c                    |  37 ++++++-
 sound/soc/fsl/fsl_xcvr.c                           |   3 +
 sound/soc/intel/boards/sof_es8336.c                |   9 ++
 sound/soc/intel/boards/sof_sdw.c                   |   1 +
 54 files changed, 877 insertions(+), 359 deletions(-)


