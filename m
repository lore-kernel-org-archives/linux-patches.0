Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCDE17C238;
	Wed,  3 Jul 2024 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003373; cv=none; b=niz6KUaa55vXHMUwmDztmi6wNQxladcqosraUjRwvfWvnSWDoOUYjbcgpFaKUbIWDVE3cuUwTGZThqWZbsziHLrTpEC5pNTcrZW9MH801vEcaLGpyIJrYgkZfjRuzHw6CJ0BidHv8iGiD65LSzIeN0Q2J2bSh8fyz+K6XR3QGoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003373; c=relaxed/simple;
	bh=Qu4vhzkMVTf0nfyiKgDjIzUMZjCLdPpFX38lwdqnOa4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jb9d6iuK/5KHN6asTHAHkhtgLmBLAz4j1woSFRym40HdulmvW34uocXDWFzQ/PoZSk716LtW8CWJign+kOjfq6COZN7DZLQgggBvWTaclR8XfGixq432qGfDGpyVvU7EhmrwAFwmAE4d/WEl8UzlkySuMH0XRxqmN/XT/bCqgUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpkGTjuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpkGTjuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7A9C2BD10;
	Wed,  3 Jul 2024 10:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003373;
	bh=Qu4vhzkMVTf0nfyiKgDjIzUMZjCLdPpFX38lwdqnOa4=;
	h=From:To:Cc:Subject:Date:From;
	b=NpkGTjuTPoQxwdvQ24BSB8LiNdG9BMLC942dj704qKT7Bl64aYiynVpjeJq+ec2Dn
	 4+B6JL1MmZVHwtAidZ1DiMHAu9GactRg2oUox5Rf4kbBExsJMNLiYJoIlLWGYEuMJw
	 qLn32k74HZ2LmnWqPgMd2ETlT3eJ1nv6OkAft4TM=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 4.19 000/139] 4.19.317-rc1 review
Date: Wed,  3 Jul 2024 12:38:17 +0200
Message-ID: <20240703102830.432293640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.317-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.317-rc1
X-KernelTest-Deadline: 2024-07-05T10:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.317 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 05 Jul 2024 10:28:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.317-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.317-rc1

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Add sound-dai-cells for RK3368

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data races around icsk->icsk_af_ops.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Fix data races around sk->sk_prot.

Eric Dumazet <edumazet@google.com>
    ipv6: annotate some data-races around sk->sk_prot

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Refuse too small period requests

Arnd Bergmann <arnd@arndb.de>
    ftruncate: pass a signed offset

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix double free on error

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't accept TT entries for out-of-spec VIDs

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes

Arnd Bergmann <arnd@arndb.de>
    hexagon: fix fadvise64_64 calling conventions

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    tty: mcf: MCF54418 has 10 UARTS

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    serial: imx: set receiver level before starting uart

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usb: atm: cxacru: fix endpoint checking in cxacru_bind()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: musb: da8xx: fix a resource leak in probe()

Oliver Neukum <oneukum@suse.com>
    usb: gadget: printer: SS+ support

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: improve link status logs

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix sensor data read operation

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix overflows in compensate() functions

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix calibration data variable

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix pressure value output

Fernando Yang <hagisf@usp.br>
    iio: adc: ad7266: Fix variable checking bug

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mmc: sdhci-pci: Convert PCIBIOS_* return codes to errnos

Linus Torvalds <torvalds@linux-foundation.org>
    x86: stop playing stack games in profile_pc()

Grygorii Tertychnyi <grembeter@gmail.com>
    i2c: ocores: set IACK bit after core is enabled

Federico Vaga <federico.vaga@cern.ch>
    i2c: ocores: stop transfer on timeout

Aleksandr Mishin <amishin@t-argos.ru>
    gpio: davinci: Validate the obtained number of IRQs

Hannes Reinecke <hare@suse.de>
    nvme: fixup comment for nvme RDMA Provider Type

Andrew Davis <afd@ti.com>
    soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message

Ricardo Ribalda <ribalda@chromium.org>
    media: dvbdev: Initialize sbuf

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emux: improve patch ioctl data validation

Dawei Li <dawei.li@shingroup.cn>
    net/iucv: Avoid explicit cpumask var allocation on stack

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
    ASoC: fsl-asoc-card: set priv->pdev before using it

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: validate family when identifying table via handle

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix UBSAN warning in kv_dpm.c

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO3-B pins

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO2-B pins

Hagar Hemdan <hagarhem@amazon.com>
    pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER

Stanislaw Gruszka <stf_xl@wp.pl>
    usb: xhci: do not perform Soft Retry for some xHCI hosts

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Set correct transferred length for cancelled bulk transfers

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Use soft retry to recover faster from transaction errors

Breno Leitao <leitao@debian.org>
    scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory

Suganath Prabu <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Gracefully handle online firmware update

Joe Perches <joe@perches.com>
    scsi: mpt3sas: Add ioc_<level> logging macros

Marc Ferland <marc.ferland@sonatest.com>
    iio: dac: ad5592r: fix temperature channel scaling value

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: dac: ad5592r: un-indent code-block for scale read

Sergiu Cuciurean <sergiu.cuciurean@analog.com>
    iio: dac: ad5592r-base: Replace indio_dev->mlock with own device lock

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Check for invalid SMN reads

Naveen Naidu <naveennaidu479@gmail.com>
    PCI: Add PCI_ERROR_RESPONSE and related definitions

Haifeng Xu <haifeng.xu@shopee.com>
    perf/core: Fix missing wakeup when waiting for context reference

Jeff Johnson <quic_jjohnson@quicinc.com>
    tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test

Masami Hiramatsu <mhiramat@kernel.org>
    selftests/ftrace: Fix checkbashisms errors

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdk4412: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: exynos4412-origen: fix keypad no-autorepeat

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: samsung: smdkv310: fix keypad no-autorepeat

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 14

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UBSAN warning in kv_dpm.c

Raju Rangoju <Raju.Rangoju@amd.com>
    ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix missing kmem_cache_destroy()

Biju Das <biju.das.jz@bp.renesas.com>
    regulator: core: Fix modpost error "regulator_get_regmap" undefined

Oliver Neukum <oneukum@suse.com>
    net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: checksum offloading handling fix

Eric Dumazet <edumazet@google.com>
    xfrm6: check ip6_dst_idev() return value in xfrm6_get_saddr()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL dereference in rt6_probe()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netrom: Fix a memory leak in nr_heartbeat_expiry()

Ondrej Mosnacek <omosnace@redhat.com>
    cipso: fix total option length computation

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    MIPS: Routerboard 532: Fix vendor retry check code

Songyang Li <leesongyang@outlook.com>
    MIPS: Octeon: Add PCIe link status check

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports

Roman Smirnov <r.smirnov@omp.ru>
    udf: udftime: prevent overflow in udf_disk_stamp_to_time()

Alex Henrie <alexhenrie24@gmail.com>
    usb: misc: uss720: check for incompatible versions of the Belkin F5U002

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/io: Avoid clang null pointer arithmetic warnings

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Enforce hcall result buffer validity and size

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Fix crash while reading debugfs attribute

Eric Dumazet <edumazet@google.com>
    batman-adv: bypass empty buckets in batadv_purge_orig_ref()

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment

Shichao Lai <shichaorai@gmail.com>
    usb-storage: alauda: Check whether the media is initialized

Matthias Goergens <matthias.goergens@gmail.com>
    hugetlb_encode.h: fix undefined behaviour (34 << 26)

Vineeth Pillai <viremana@linux.microsoft.com>
    hv_utils: drain the timesync packets on onchannelcallback

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential kernel bug due to lack of writeback flag waiting

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Lunar Lake support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Sapphire Rapids SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Granite Rapids SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Granite Rapids support

Nuno Sa <nuno.sa@analog.com>
    dmaengine: axi-dmac: fix possible race in remove()

Rick Wertenbroek <rick.wertenbroek@gmail.com>
    PCI: rockchip-ep: Remove wrong mask on subsys_vendor_id

Su Yue <glass.su@suse.com>
    ocfs2: fix races between hole punching and AIO+DIO

Su Yue <glass.su@suse.com>
    ocfs2: use coarse time for new created files

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore

Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
    vmci: prevent speculation leaks by sanitizing event in event_deliver()

Jani Nikula <jani.nikula@intel.com>
    drm/exynos/vidi: fix memory leak in .get_modes()

Dirk Behme <dirk.behme@de.bosch.com>
    drivers: core: synchronize really_probe() and dev_uevent()

Petr Pavlu <petr.pavlu@suse.com>
    net/ipv6: Fix the RT cache flush via sysctl using a previous delay

Aditya Pakki <pakki001@umn.edu>
    ipv6/route: Add a missing check on proc_dointvec

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix rejecting L2CAP_CONN_PARAM_UPDATE_REQ

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_v6_syn_recv_sock()

Adam Miotk <adam.miotk@arm.com>
    drm/bridge/panel: Fix runtime warning on panel bridge release

Aleksandr Mishin <amishin@t-argos.ru>
    liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet

Kun(llfl) <llfl@linux.alibaba.com>
    iommu/amd: Fix sysfs leak in iommu init

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    HID: core: remove unnecessary WARN_ON() in implement()

Eric Dumazet <edumazet@google.com>
    xsk: validate user input for XDP_{UMEM|COMPLETION}_FILL_RING

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: try trimming too long modalias strings

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply broken streams quirk to Etron EJ188 xHCI host

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply reset resume quirk to Etron EJ188 xHCI host

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    jfs: xattr: fix buffer overflow for invalid xattr

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: release irq in mei_me_pci_resume error path

Alan Stern <stern@rowland.harvard.edu>
    USB: class: cdc-wdm: Fix CPU lockup caused by excessive log messages

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: return the mapped address from nilfs_get_page()

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: Remove check for PageError

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix bogus test success on Aarch64

Mark Brown <broonie@kernel.org>
    selftests/mm: log a consistent test name for check_compaction

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/mm: conform test to TAP format output

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: mc: mark the media devnode as registered from the, start

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: replace hardcoded divisor value with BIT() macro

George Shen <george.shen@amd.com>
    drm/amd/display: Handle Y carry-over in VCP X.Y calculation

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in unix_write_space() and poll().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_inq_len().

Karol Kolacinski <karol.kolacinski@intel.com>
    ptp: Fix error message on failed pin verification

Jason Xing <kernelxing@tencent.com>
    tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Eric Dumazet <edumazet@google.com>
    ipv6: sr: block BH in seg6_output_core() and seg6_input_core()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't read past the mfuart notifcation

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Fix deadlock in ieee80211_sta_ps_deliver_wakeup()

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: Fix leak of mesh_preq_queue objects


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |   2 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |   2 +-
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   2 +-
 arch/arm64/boot/dts/rockchip/rk3368.dtsi           |   3 +
 arch/hexagon/include/asm/syscalls.h                |   6 ++
 arch/hexagon/kernel/syscalltab.c                   |   7 ++
 arch/mips/pci/ops-rc32434.c                        |   4 +-
 arch/mips/pci/pcie-octeon.c                        |   6 ++
 arch/powerpc/include/asm/hvcall.h                  |   8 +-
 arch/powerpc/include/asm/io.h                      |  24 ++---
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/x86/kernel/time.c                             |  21 +---
 drivers/acpi/acpica/exregion.c                     |  23 +----
 drivers/ata/libata-core.c                          |   8 +-
 drivers/base/core.c                                |   3 +
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/dma/ioat/init.c                            |   1 +
 drivers/gpio/gpio-davinci.c                        |   5 +
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c                |   2 +
 .../amd/display/dc/dcn10/dcn10_stream_encoder.c    |   6 ++
 drivers/gpu/drm/bridge/panel.c                     |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   7 +-
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c          |   6 ++
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c      |   6 +-
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   2 +
 drivers/hid/hid-core.c                             |   1 -
 drivers/hv/hv_util.c                               |  19 +++-
 drivers/hwtracing/intel_th/pci.c                   |  25 +++++
 drivers/i2c/busses/i2c-ocores.c                    |  56 +++++++++--
 drivers/iio/adc/ad7266.c                           |   2 +
 drivers/iio/chemical/bme680.h                      |   2 +
 drivers/iio/chemical/bme680_core.c                 |  62 ++++++++++--
 drivers/iio/dac/ad5592r-base.c                     |  62 ++++++------
 drivers/iio/dac/ad5592r-base.h                     |   1 +
 drivers/input/input.c                              | 105 ++++++++++++++++---
 drivers/iommu/amd_iommu_init.c                     |   9 ++
 drivers/media/dvb-core/dvbdev.c                    |   2 +-
 drivers/media/media-devnode.c                      |   5 +-
 drivers/misc/mei/pci-me.c                          |   4 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   6 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  11 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  |  11 +-
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/usb/rtl8150.c                          |   3 +-
 drivers/net/virtio_net.c                           |  11 +-
 drivers/net/vxlan.c                                |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 --
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   9 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   6 +-
 drivers/pci/pci.c                                  |  12 +++
 drivers/pinctrl/core.c                             |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  63 ++++++++++--
 drivers/ptp/ptp_chardev.c                          |   3 +-
 drivers/pwm/pwm-stm32.c                            |   3 +
 drivers/regulator/core.c                           |   1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                | 112 +++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  11 ++
 drivers/scsi/qedi/qedi_debugfs.c                   |  12 +--
 drivers/soc/ti/wkup_m3_ipc.c                       |   7 +-
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/mcf.c                           |   2 +-
 drivers/tty/serial/sc16is7xx.c                     |  25 +++--
 drivers/usb/atm/cxacru.c                           |  14 +++
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +
 drivers/usb/gadget/function/f_printer.c            |   1 +
 drivers/usb/host/xhci-pci.c                        |  12 +++
 drivers/usb/host/xhci-ring.c                       |  25 ++++-
 drivers/usb/host/xhci.h                            |   3 +
 drivers/usb/misc/uss720.c                          |  22 ++--
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/storage/alauda.c                       |   9 +-
 fs/jfs/xattr.c                                     |   4 +-
 fs/nilfs2/dir.c                                    |  59 ++++++-----
 fs/nilfs2/segment.c                                |   3 +
 fs/ocfs2/file.c                                    |   2 +
 fs/ocfs2/namei.c                                   |   2 +-
 fs/open.c                                          |   4 +-
 fs/proc/vmcore.c                                   |   2 +
 fs/udf/udftime.c                                   |  11 +-
 include/linux/compat.h                             |   2 +-
 include/linux/nvme.h                               |   4 +-
 include/linux/pci.h                                |   9 ++
 include/linux/syscalls.h                           |   2 +-
 include/net/bluetooth/hci_core.h                   |  36 ++++++-
 include/net/netfilter/nf_tables.h                  |   5 +
 include/uapi/asm-generic/hugetlb_encode.h          |  24 ++---
 kernel/events/core.c                               |  13 +++
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/rcu/rcutorture.c                            |   3 +-
 kernel/trace/preemptirq_delay_test.c               |   1 +
 net/batman-adv/originator.c                        |  29 ++++++
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/af_inet.c                                 |  38 +++++--
 net/ipv4/cipso_ipv4.c                              |  12 ++-
 net/ipv4/tcp.c                                     |  16 ++-
 net/ipv6/af_inet6.c                                |  14 ++-
 net/ipv6/ipv6_sockglue.c                           |   9 +-
 net/ipv6/route.c                                   |   8 +-
 net/ipv6/seg6_iptunnel.c                           |  14 ++-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/ipv6/xfrm6_policy.c                            |   8 +-
 net/iucv/iucv.c                                    |  26 +++--
 net/mac80211/mesh_pathtbl.c                        |  13 +++
 net/mac80211/sta_info.c                            |   4 +-
 net/netfilter/nf_tables_api.c                      |  13 +--
 net/netfilter/nft_lookup.c                         |   3 +-
 net/netrom/nr_timer.c                              |   3 +-
 net/unix/af_unix.c                                 |  47 ++++-----
 net/unix/diag.c                                    |  12 +--
 net/xdp/xsk.c                                      |   4 +
 sound/soc/fsl/fsl-asoc-card.c                      |   3 +-
 sound/synth/emux/soundfont.c                       |  17 ++--
 tools/include/asm-generic/hugetlb_encode.h         |  20 ++--
 .../trigger/trigger-trace-marker-snapshot.tc       |   4 +-
 tools/testing/selftests/vm/compaction_test.c       | 108 +++++++++++---------
 118 files changed, 1141 insertions(+), 464 deletions(-)


