Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCFF16EB4C
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 08:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731658607; cv=none; b=MKO0arHox6um9PILnuMTLCuo64X9EiybhTx6/Hkr4ksAls77L3cU/yohZCd/WrMagULQcMzSJrHwVm/HdrNwS6Ccb1n4O1KrVbH8mySbFQn8uiFJz0hWJyFqXAlUSPVSJ1ZMG91uXdnbC+9kjOBeuAQkt/QszblU+E4UBNj3Feg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731658607; c=relaxed/simple;
	bh=Y+Vqnb+ztVvpNqlKhZ8mJnKqScnAkM2qBF0AfcC8388=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZoAgfAPOORImUU5dct+e2w6QPuIf4kPEqzvZrsErY6j+WtjWoSghGQM8wOzebQx1PsbbVDQzEb6oddq0X/xsHlLh0QKN/zxOKXl6Ax7UjJf1016edNajg5tjSWGtBpuQrf2EqQRKN/dILgnmLZPr+VF5YNZVuxfpossqTrCHgXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ezACorgG; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ezACorgG"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-723db2798caso1355478b3a.0
        for <patches@lists.linux.dev>; Fri, 15 Nov 2024 00:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731658605; x=1732263405; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGZF6N3/pmMpF8j/jWulN5WaeUPbK5MzBQJo41d0xWQ=;
        b=ezACorgGvTl9N/wnTrZ4Vf+6uTyfVJm3sWDhSpm9oKqxoCc2FptIe7oLgYF9hAKEs8
         mEl3/9c72X0m0dwyoGroG6dOF2BZb1ZMHbL1xgTyxhrTqq9h6lT0lrdjDrgkZSUupN3a
         nAM0WxtdIZhMLasHylYadEYm6lhtBZ43Xd0FkN1jCsDbgINXiTvPXb+ZCgDeFyRJl+Oe
         VKkUT8he9oXJeWWbj3XjooXJSiecSPGtWQrFU4Tv0uiW56Q9w1LGJXA6gITDszWjsfo0
         63XPMQ1CjNJqmRhExZCmSq5Jd/zMQ71gw/IuSkwJc+vpb1fMEfABgSO5WyPS1c7hVBfu
         O/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731658605; x=1732263405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WGZF6N3/pmMpF8j/jWulN5WaeUPbK5MzBQJo41d0xWQ=;
        b=kqFLPttrCwU4ibJUfvnIhN/uMDskqdWOXctPCfBsfu0mH3iAZEqmNwXX/x+194tXyS
         xgWadQCobY0cTom/INRckFu6OWz4X0DMZ6PETQfzxiknBcfXeGy6Ldt4gPytJoDFdmAp
         zxRwStnDcCMpJZpK3UreQijYaVE+EFh0ADSi9IbvrUfkzLmHFDMFIA/Htg6yvAHtZASs
         mWsm9YgmkqENhm/yG1voPU1Ec2RFw9wwK1ZyOLLelwNGu3UZlBYg36nYcNfFRiR8H+a+
         WFsUzkOAaBl+ByuPOyqIcVkn+bYIigDp2MpJiY+rakYIL44tvrk8PYyHV9OEbIPuw6RA
         RW8A==
X-Forwarded-Encrypted: i=1; AJvYcCUS3VVGqMro79UZOyJHl0fYIBLniGS5eIk9mB85DCvqYYHjYaL2vgnIbHZJ3J3EaljxCVACSSw4@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2Gx9I+dJo037pF0kVvC4SRDno/4tqpQ3KhFGnON3fm5+YKZQ5
	Irm19uQ2ovDy2D0ys2x26G5TW8JMKvF1IB2c2BRxNM6ioxWGXMZm78+8YcD62DDRh8ACr5a9JVh
	67U6aLC+G6O1gJY5fSU1gdl/vLis=
X-Google-Smtp-Source: AGHT+IFfJc06IFrDBRy4tXJOWYNxG+uqUeX4nHUkEk2HDPIBbYg1BbxEFKblCFuZzokCR9PK0kZz1LhjYXA0wtfe1aQ=
X-Received: by 2002:a05:6a00:1703:b0:71e:7674:4cf6 with SMTP id
 d2e1a72fcca58-72476b96cfbmr2708472b3a.8.1731658604484; Fri, 15 Nov 2024
 00:16:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063725.892410236@linuxfoundation.org>
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Fri, 15 Nov 2024 09:16:31 +0100
Message-ID: <CADo9pHhc_JALkYdOGS1ZG5H3nc=4tz9GcR752Mx07ycPFy3Weg@mail.gmail.com>
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
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

Den fre 15 nov. 2024 kl 07:47 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y
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
>     Linux 6.11.9-rc1
>
> Linus Torvalds <torvalds@linux-foundation.org>
>     9p: fix slab cache name creation for real
>
> Qun-Wei Lin <qun-wei.lin@mediatek.com>
>     mm: krealloc: Fix MTE false alarm in __do_krealloc
>
> Nirmoy Das <nirmoy.das@intel.com>
>     drm/xe: Don't restart parallel queues multiple times on GT reset
>
> Nirmoy Das <nirmoy.das@intel.com>
>     drm/xe/ufence: Prefetch ufence addr to catch bogus address
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe: Handle unreliable MMIO reads during forcewake
>
> Badal Nilawar <badal.nilawar@intel.com>
>     drm/xe/guc/ct: Flush g2h worker in case of g2h response timeout
>
> Shuicheng Lin <shuicheng.lin@intel.com>
>     drm/xe: Enlarge the invalidation timeout from 150 to 500
>
> Hou Tao <houtao1@huawei.com>
>     bpf: Check validity of link->type in bpf_link_show_fdinfo()
>
> Reinhard Speyerer <rspmn@arcor.de>
>     net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition
>
> Huacai Chen <chenhuacai@kernel.org>
>     LoongArch: KVM: Mark hrtimer to expire in hard interrupt context
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: fsl_micfil: Add sample rate constraint
>
> Yanteng Si <siyanteng@cqsoftware.com.cn>
>     LoongArch: Use "Exception return address" to comment ERA
>
> Jack Yu <jack.yu@realtek.com>
>     ASoC: rt722-sdca: increase clk_stop_timeout to fix clock stop issue
>
> Cyan Yang <cyan.yang@sifive.com>
>     RISCV: KVM: use raw_spinlock for critical section in imsic
>
> Alexey Klimov <alexey.klimov@linaro.org>
>     ASoC: codecs: lpass-rx-macro: fix RXn(rx,n) macro for DSM_CTL and SEC=
7 regs
>
> Hans de Goede <hdegoede@redhat.com>
>     HID: lenovo: Add support for Thinkpad X1 Tablet Gen 3 keyboard
>
> Kenneth Albanowski <kenalba@chromium.org>
>     HID: multitouch: Add quirk for Logitech Bolt receiver w/ Casa touchpa=
d
>
> Bart=C5=82omiej Mary=C5=84czak <marynczakbartlomiej@gmail.com>
>     HID: i2c-hid: Delayed i2c resume wakeup for 0x0d42 Goodix touchpad
>
> David Howells <dhowells@redhat.com>
>     afs: Fix lock recursion
>
> Alessandro Zanni <alessandro.zanni87@gmail.com>
>     fs: Fix uninitialized value issue in from_kuid and from_kgid
>
> David Howells <dhowells@redhat.com>
>     netfs: Downgrade i_rwsem for a buffered write
>
> Derek Fang <derek.fang@realtek.com>
>     ASoC: Intel: soc-acpi: lnl: Add match entry for TM2 laptops
>
> Ilya Dudikov <ilyadud@mail.ru>
>     ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA
>
> Christian Heusel <christian@heusel.eu>
>     ASoC: amd: yc: Add quirk for ASUS Vivobook S15 M3502RA
>
> Zhu Jun <zhujun2@cmss.chinamobile.com>
>     ASoC: codecs: Fix error handling in aw_dev_get_dsp_status function
>
> Amadeusz S=C5=82awi=C5=84ski <amadeuszx.slawinski@linux.intel.com>
>     ASoC: Intel: avs: Update stream status in a separate thread
>
> Jiawei Ye <jiawei.ye@foxmail.com>
>     bpf: Fix mismatched RCU unlock flavour in bpf_out_neigh_v6
>
> Zijian Zhang <zijianzhang@bytedance.com>
>     bpf: Add sk_is_inet and IS_ICSK check in tls_sw_has_ctx_tx/rx
>
> Feng Liu <feliu@nvidia.com>
>     virtio_pci: Fix admin vq cleanup by using correct info pointer
>
> Yuan Can <yuancan@huawei.com>
>     vDPA/ifcvf: Fix pci_read_config_byte() return code handling
>
> Matthieu Buffet <matthieu@buffet.re>
>     samples/landlock: Fix port parsing in sandboxer
>
> Nilay Shroff <nilay@linux.ibm.com>
>     nvme: make keep-alive synchronous operation
>
> Nilay Shroff <nilay@linux.ibm.com>
>     nvme-loop: flush off pending I/O while shutting down loop controller
>
> Lucas De Marchi <lucas.demarchi@intel.com>
>     drm/xe/query: Increase timestamp width
>
> Linus Walleij <linus.walleij@linaro.org>
>     net: phy: mdio-bcm-unimac: Add BCM6846 support
>
> Michael Ellerman <mpe@ellerman.id.au>
>     powerpc/powernv: Free name on error in opal_event_init()
>
> Philip Yang <Philip.Yang@amd.com>
>     drm/amdkfd: Accounting pdd vram_usage for svm
>
> Keith Busch <kbusch@kernel.org>
>     nvme-multipath: defer partition scanning
>
> Will Deacon <will@kernel.org>
>     kasan: Disable Software Tag-Based KASAN with GCC
>
> Baojun Xu <baojun.xu@ti.com>
>     ALSA: hda/tas2781: Add new quirk for Lenovo, ASUS, Dell projects
>
> Showrya M N <showrya@chelsio.com>
>     RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES
>
> Tyrone Wu <wudevelops@gmail.com>
>     selftests/bpf: Assert link info uprobe_multi count & path_size if uns=
et
>
> Ian Forbes <ian.forbes@broadcom.com>
>     drm/vmwgfx: Limit display layout ioctl array size to VMWGFX_NUM_DISPL=
AY_UNITS
>
> Julian Vetter <jvetter@kalrayinc.com>
>     sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML
>
> Harald Freudenberger <freude@linux.ibm.com>
>     s390/ap: Fix CCA crypto card behavior within protected execution envi=
ronment
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: marvell/cesa - Disable hash algorithms
>
> Herbert Xu <herbert@gondor.apana.org.au>
>     crypto: api - Fix liveliness check in crypto_alg_tested
>
> Rik van Riel <riel@surriel.com>
>     bpf: use kvzmalloc to allocate BPF verifier environment
>
> Greg Joyce <gjoyce@linux.ibm.com>
>     nvme: disable CC.CRIME (NVME_CC_CRIME)
>
> Robin Murphy <robin.murphy@arm.com>
>     iommu/arm-smmu: Clarify MMU-500 CPRE workaround
>
> WangYuli <wangyuli@uniontech.com>
>     HID: multitouch: Add quirk for HONOR MagicBook Art 14 touchpad
>
> Stefan Blum <stefanblum2004@gmail.com>
>     HID: multitouch: Add support for B2402FVA track point
>
> SurajSonawane2415 <surajsonawane0215@gmail.com>
>     block: Fix elevator_get_default() checking for NULL q->tag_set
>
> Hannes Reinecke <hare@suse.de>
>     nvme: tcp: avoid race between queue_lock lock and destroy
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     pinctrl: intel: platform: Add Panther Lake to the list of supported
>
> Rosen Penev <rosenp@gmail.com>
>     pinctrl: aw9523: add missing mutex_destroy
>
> Sergey Matsievskiy <matsievskiysv@gmail.com>
>     irqchip/ocelot: Fix trigger register address
>
> Nilay Shroff <nilay@linux.ibm.com>
>     nvmet-passthru: clear EUID/NGUID/UUID while using loop target
>
> Eduard Zingerman <eddyz87@gmail.com>
>     selftests/bpf: Verify that sync_linked_regs preserves subreg_def
>
> Pedro Falcato <pedro.falcato@gmail.com>
>     9p: Avoid creating multiple slab caches with the same name
>
> Dominique Martinet <asmadeus@codewreck.org>
>     9p: v9fs_fid_find: also lookup by inode if not found dentry
>
> Breno Leitao <leitao@debian.org>
>     nvme/host: Fix RCU list traversal to use SRCU primitive
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     smb: client: Fix use-after-free of network namespace.
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |  4 +-
>  arch/loongarch/include/asm/loongarch.h             |  2 +-
>  arch/loongarch/kvm/timer.c                         |  7 +-
>  arch/loongarch/kvm/vcpu.c                          |  2 +-
>  arch/powerpc/platforms/powernv/opal-irqchip.c      |  1 +
>  arch/riscv/kvm/aia_imsic.c                         |  8 +--
>  block/elevator.c                                   |  4 +-
>  crypto/algapi.c                                    |  2 +-
>  drivers/crypto/marvell/cesa/hash.c                 | 12 ++--
>  drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  6 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  2 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  4 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_svm.c               | 26 +++++++
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |  3 -
>  drivers/gpu/drm/xe/xe_device.c                     |  2 +-
>  drivers/gpu/drm/xe/xe_force_wake.c                 | 12 +++-
>  drivers/gpu/drm/xe/xe_guc_ct.c                     | 18 +++++
>  drivers/gpu/drm/xe/xe_guc_submit.c                 | 14 +++-
>  drivers/gpu/drm/xe/xe_query.c                      |  6 +-
>  drivers/gpu/drm/xe/xe_sync.c                       |  3 +-
>  drivers/hid/hid-ids.h                              |  2 +
>  drivers/hid/hid-lenovo.c                           |  8 +++
>  drivers/hid/hid-multitouch.c                       | 13 ++++
>  drivers/hid/i2c-hid/i2c-hid-core.c                 | 10 +++
>  drivers/infiniband/sw/siw/siw_qp_tx.c              |  2 +
>  drivers/iommu/arm/arm-smmu/arm-smmu-impl.c         |  4 +-
>  drivers/irqchip/irq-mscc-ocelot.c                  |  4 +-
>  drivers/net/mdio/mdio-bcm-unimac.c                 |  1 +
>  drivers/net/usb/qmi_wwan.c                         |  1 +
>  drivers/nvme/host/core.c                           | 52 ++++++++------
>  drivers/nvme/host/multipath.c                      | 33 +++++++++
>  drivers/nvme/host/nvme.h                           |  1 +
>  drivers/nvme/host/tcp.c                            |  7 +-
>  drivers/nvme/target/loop.c                         | 13 ++++
>  drivers/nvme/target/passthru.c                     |  6 +-
>  drivers/pinctrl/intel/Kconfig                      |  1 +
>  drivers/pinctrl/pinctrl-aw9523.c                   |  6 +-
>  drivers/s390/crypto/ap_bus.c                       |  3 +-
>  drivers/s390/crypto/ap_bus.h                       |  2 +-
>  drivers/s390/crypto/ap_queue.c                     | 28 +++++---
>  drivers/vdpa/ifcvf/ifcvf_base.c                    |  2 +-
>  drivers/virtio/virtio_pci_common.c                 | 24 +++++--
>  drivers/virtio/virtio_pci_common.h                 |  1 +
>  drivers/virtio/virtio_pci_modern.c                 | 12 +---
>  fs/9p/fid.c                                        |  5 +-
>  fs/afs/internal.h                                  |  2 +
>  fs/afs/rxrpc.c                                     | 83 +++++++++++++++-=
------
>  fs/netfs/locking.c                                 |  3 +-
>  fs/ocfs2/file.c                                    |  9 ++-
>  fs/smb/client/connect.c                            | 14 +++-
>  include/net/tls.h                                  | 12 +++-
>  kernel/bpf/syscall.c                               | 14 ++--
>  kernel/bpf/verifier.c                              |  4 +-
>  lib/Kconfig.kasan                                  |  7 +-
>  mm/slab_common.c                                   |  2 +-
>  net/9p/client.c                                    | 12 +++-
>  net/core/filter.c                                  |  2 +-
>  samples/landlock/sandboxer.c                       | 32 ++++++++-
>  sound/Kconfig                                      |  2 +-
>  sound/pci/hda/patch_realtek.c                      | 29 ++++++++
>  sound/soc/amd/yc/acp6x-mach.c                      | 14 ++++
>  sound/soc/codecs/aw88399.c                         |  2 +-
>  sound/soc/codecs/lpass-rx-macro.c                  | 15 ++--
>  sound/soc/codecs/rt722-sdca-sdw.c                  |  2 +-
>  sound/soc/fsl/fsl_micfil.c                         | 38 ++++++++++
>  sound/soc/intel/avs/core.c                         |  3 +-
>  sound/soc/intel/avs/pcm.c                          | 19 +++++
>  sound/soc/intel/avs/pcm.h                          | 16 +++++
>  sound/soc/intel/common/soc-acpi-intel-lnl-match.c  | 38 ++++++++++
>  .../selftests/bpf/prog_tests/fill_link_info.c      |  9 +++
>  .../selftests/bpf/progs/verifier_scalar_ids.c      | 67 ++++++++++++++++=
+
>  73 files changed, 670 insertions(+), 167 deletions(-)
>
>
>
