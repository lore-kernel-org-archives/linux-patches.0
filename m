Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C596729AB02;
	Tue, 17 Feb 2026 20:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360768; cv=none; b=S2WTzDxoOpI+wG1sulA1TeY0GsKWJ/J3BvZibxBku+wQE6aKnhK3lfne7vRzHcj6Mfsx31HzlbqbkQTr330t4rBzrYibRYEg2k3y4PRFuBtkuL3POdCJ5eMHe0CN953cslm+egV33e7PM/pSiMAF6qpbMFEzkubeBldHajgbxpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360768; c=relaxed/simple;
	bh=n8yPzMiT6rhZE5JsJARmhvMIGHybLR4bzQ3Q6XixiGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ctShXDDd8R3Iyn9Ho6qslKpglpcCJjy0CFE5I9F8808f4S4YUHpP8vLC1ydc4Yo1MOi3uZqJo2bL7l/KKS0Z9STMTv0pBPmayYCL4Ys/9o+c902j9RfZ7jUtiAhPPjpwrTIAIJ33Yf+CqHhcEWN1jCQYMsI1NO8zx+/EqKp6h+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYoSNP1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYoSNP1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7110C4CEF7;
	Tue, 17 Feb 2026 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360768;
	bh=n8yPzMiT6rhZE5JsJARmhvMIGHybLR4bzQ3Q6XixiGQ=;
	h=From:To:Cc:Subject:Date:From;
	b=oYoSNP1zz3aRnl5USMB/GTAGysXNLFsqMKpEdEvQkvVSUIpJ9nqGRa8Nfc9O3+PhP
	 qEL4YHlZZXfIQhU+70Yu+jGPDb8lK+TVM6UAlFIIybTfodfsnrd7pMkFIyh2kd6Og5
	 RSTNP7oXV+LWOjcdtoWhPCXc+y2402Su196d2evc=
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
Subject: [PATCH 6.6 00/39] 6.6.127-rc1 review
Date: Tue, 17 Feb 2026 21:30:22 +0100
Message-ID: <20260217200004.221651386@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.127-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.127-rc1
X-KernelTest-Deadline: 2026-02-19T20:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.127 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.127-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.127-rc1

Menglong Dong <menglong8.dong@gmail.com>
    net: tunnel: make skb_vlan_inet_prepare() return drop reasons

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit FN920C04 RNDIS compositions

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid mapping wrong physical block for swapfile

Wenjie Qi <qwjhust@gmail.com>
    f2fs: fix zoned block device information initialization

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_write_end_io()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix IS_CHECKPOINTED flag inconsistency issue caused by concurrent atomic commit and checkpoint writes

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix out-of-bounds access in sysfs attribute read/write

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to add gc count stat in f2fs_gc_range

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: smscufx: properly copy ioctl memory to kernelspace

Guangshuo Li <lgs201920130244@gmail.com>
    fbdev: rivafb: fix divide error in nv3_arb()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Add writecombine support for DMW-based ioremap()

Chen Ridong <chenridong@huawei.com>
    cpuset: Fix missing adaptation for cpuset_is_populated

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix two comments related to huge_pmd_unshare()

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix hugetlb_pmd_shared()

Jane Chu <jane.chu@oracle.com>
    mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Daniel Borkmann <daniel@iogearbox.net>
    Revert "wireguard: device: enable threaded NAPI"

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Rework KASAN initialization for PTW-enabled systems

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Add WriteCombine shadow mapping in KASAN

Alban Bedel <alban.bedel@lht.dlh.de>
    gpiolib: acpi: Fix gpio count with string references

Ziyi Guo <n7l8m4@u.northwestern.edu>
    ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Correct handling of 3-pole jack load detection

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: panasonic-laptop: Fix sysfs group leak in error path

gongqi <550230171hxy@gmail.com>
    platform/x86/amd/pmc: Add quirk for MECHREVO Wujie 15X Pro

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

Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
    ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Inspur S14-G1

Xuewen Yan <xuewen.yan@unisoc.com>
    gpio: sprd: Change sprd_gpio lock to raw_spin_lock

Anatolii Shirykalov <pipocavsobake@gmail.com>
    ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU

Gui-Dong Han <hanguidong02@gmail.com>
    bus: fsl-mc: fix use-after-free in driver_override_show()

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    bus: fsl-mc: Replace snprintf and sprintf with sysfs_emit in sysfs show functions

Liu Song <liu.song13@zte.com.cn>
    PCI: endpoint: Avoid creating sub-groups asynchronously

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: endpoint: Remove unused field in struct pci_epf_group

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Fix bsg_done() causing double free


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/loongarch/include/asm/addrspace.h    |   4 +
 arch/loongarch/include/asm/io.h           |  10 +-
 arch/loongarch/include/asm/kasan.h        |  11 ++-
 arch/loongarch/include/asm/loongarch.h    |  10 +-
 arch/loongarch/include/asm/stackframe.h   |  11 +++
 arch/loongarch/kernel/head.S              |  11 +--
 arch/loongarch/mm/kasan_init.c            |  78 +++++++++-------
 arch/loongarch/power/suspend_asm.S        |   6 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c           |  10 +-
 drivers/firmware/efi/libstub/loongarch.c  |   2 +
 drivers/gpio/gpio-sprd.c                  |   8 +-
 drivers/gpio/gpiolib-acpi.c               |   1 +
 drivers/gpu/drm/tegra/hdmi.c              |   4 +-
 drivers/gpu/drm/tegra/sor.c               |   4 +-
 drivers/net/bareudp.c                     |   4 +-
 drivers/net/geneve.c                      |   4 +-
 drivers/net/wireguard/device.c            |   1 -
 drivers/pci/endpoint/pci-ep-cfs.c         |  16 +---
 drivers/platform/x86/amd/pmc/pmc-quirks.c |   7 ++
 drivers/platform/x86/classmate-laptop.c   |  32 +++++++
 drivers/platform/x86/panasonic-laptop.c   |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c            |  28 +++---
 drivers/usb/serial/option.c               |   6 ++
 drivers/video/fbdev/riva/riva_hw.c        |   3 +
 drivers/video/fbdev/smscufx.c             |   8 +-
 fs/f2fs/data.c                            |  26 ++++--
 fs/f2fs/f2fs.h                            |   1 +
 fs/f2fs/gc.c                              |   1 +
 fs/f2fs/node.c                            |  14 ++-
 fs/f2fs/super.c                           |  27 ++++++
 fs/f2fs/sysfs.c                           |  60 ++++++++++--
 fs/romfs/super.c                          |   5 +-
 include/asm-generic/tlb.h                 |  77 +++++++++++++++-
 include/linux/hugetlb.h                   |  17 ++--
 include/linux/mm_types.h                  |   6 ++
 include/net/ip_tunnels.h                  |  13 ++-
 kernel/cgroup/cpuset.c                    |   2 +-
 mm/hugetlb.c                              | 146 ++++++++++++++++--------------
 mm/mmu_gather.c                           |  33 +++++++
 mm/rmap.c                                 |  25 +++--
 sound/pci/hda/patch_realtek.c             |   5 +
 sound/soc/amd/yc/acp6x-mach.c             |  14 +++
 sound/soc/codecs/cs35l45.c                |   2 +-
 sound/soc/codecs/cs42l43-jack.c           |  37 ++++++--
 sound/soc/fsl/fsl_xcvr.c                  |   3 +
 sound/soc/intel/boards/sof_es8336.c       |   9 ++
 47 files changed, 593 insertions(+), 217 deletions(-)


