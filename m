Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2260D19F47A;
	Thu, 15 Aug 2024 13:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728487; cv=none; b=fztcdaTMOvTF5k5NBe0WcO1DUfdZXn4dHZZPm5D5CZl//TpsMZ1GUIs9vr2FTU6otA/BFWJyHOgGcI/M9fXarXkwvwOm6avX254YwrhIhIMVH242ngTa58IRFR26oNIa33Dc+e7k+4u4ey3N/lo9X18/JoSfSFzqEdrNOaMdcrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728487; c=relaxed/simple;
	bh=ZBvBVjQhG2VW/9HabIwELFKCSV1ubUNti3FecSfokeE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=miz6dCc6s5M1rBsohe0LkAnt4gM85n9KCo0ADBg9uPYtUKa0Wbbvs1H9cbaITVE6hHRrTMjg20YQ2lxewS6VsBrs94dp3r9UWSHC3+5u+JpAydf89HP6+qX35tuq9ncFz8FwiIVTlASDvUIwM6IjMJijCR6DWRFM0L3DllNlAEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYUIvTWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYUIvTWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27235C4AF0D;
	Thu, 15 Aug 2024 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728487;
	bh=ZBvBVjQhG2VW/9HabIwELFKCSV1ubUNti3FecSfokeE=;
	h=From:To:Cc:Subject:Date:From;
	b=pYUIvTWztbS2QpvCoj0lAlXrY+ecZ3s+ErwQXYS+Bh+VFO2RavIGyNIIW+LWnMDE8
	 awxzQXFP6ZOne3mDlPvc+d8l/cC12Pa6KlXn9SvJx+/rxYlBXt3FGtbXPTF2vkQ3VL
	 2BEpaKQSLAHJglcxUI9+j7n9zTRLlrrICthiphZo=
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
Subject: [PATCH 4.19 000/196] 4.19.320-rc1 review
Date: Thu, 15 Aug 2024 15:21:57 +0200
Message-ID: <20240815131852.063866671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.320-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.320-rc1
X-KernelTest-Deadline: 2024-08-17T13:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.320 release.
There are 196 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.320-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.320-rc1

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Fix Virtual Memory mapping boundaries calculation

Yunke Cao <yunkec@google.com>
    media: uvcvideo: Use entity get_cur in uvc_ctrl_set

Amit Daniel Kachhap <amit.kachhap@arm.com>
    arm64: cpufeature: Fix the visibility of compat hwcaps

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_chain_validate

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use timestamp to check for set element timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set element extended ACK reporting support

Nathan Chancellor <nathan@kernel.org>
    kbuild: Fix '-S -c' in x86 stack protector scripts

Thomas Zimmermann <tzimmermann@suse.de>
    drm/mgag200: Set DDC timeout in milliseconds

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: analogix_dp: properly handle zero sized AUX transactions

Andi Kleen <ak@linux.intel.com>
    x86/mtrr: Check if fixed MTRRs exist before saving them

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    tracing: Fix overflow in get_free_elt()

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Round constant_charge_voltage writes down

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Fix constant_charge_voltage writes

George Kennedy <george.kennedy@oracle.com>
    serial: core: check uartclk for zero to avoid divide by zero

Justin Stitt <justinstitt@google.com>
    ntp: Safeguard against time_constant overflow

Dan Williams <dan.j.williams@intel.com>
    driver core: Fix uevent_show() vs driver detach race

Justin Stitt <justinstitt@google.com>
    ntp: Clamp maxerror and esterror to operating range

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Move per CPU pointer access into the atomic section

Vamshi Gajjela <vamshigajjela@google.com>
    scsi: ufs: core: Fix hba->last_dme_cmd_tstamp timestamp updating logic

Chris Wulff <crwulff@gmail.com>
    usb: gadget: core: Check for unset descriptor

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    USB: serial: debug: do not echo input by default

Oliver Neukum <oneukum@suse.com>
    usb: vhci-hcd: Do not drop references before new references are gained

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix racy access to midibuf

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Fix scldiv calculation

Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
    spi: fsl-lpspi: remove unneeded array

Clark Wang <xiaoning.wang@nxp.com>
    spi: lpspi: add the error info of transfer speed setting

Clark Wang <xiaoning.wang@nxp.com>
    spi: lpspi: Add i.MX8 boards support for lpspi

Clark Wang <xiaoning.wang@nxp.com>
    spi: lpspi: Let watermark change with send data length

Clark Wang <xiaoning.wang@nxp.com>
    spi: lpspi: Add slave mode support

Clark Wang <xiaoning.wang@nxp.com>
    spi: lpspi: Replace all "master" with "controller"

Menglong Dong <menglong8.dong@gmail.com>
    bpf: kprobe: remove unused declaring of bpf_kprobe_override

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Send alert notifications to all devices if source not found

Guenter Roeck <linux@roeck-us.net>
    i2c: smbus: Improve handling of stuck alerts

Corey Minyard <cminyard@mvista.com>
    i2c: smbus: Don't filter out duplicate alerts

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround (again)

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-A725 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X1C definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Unify speculative SSBS errata logic

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X925 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-A720 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X3 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Add workaround for Arm errata 3194386 and 3312417

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-V3 definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Cortex-X4 definitions

Besar Wicaksono <bwicaksono@nvidia.com>
    arm64: Add Neoverse-V2 part

James Morse <james.morse@arm.com>
    arm64: cpufeature: Force HWCAP to be based on the sysreg visible to user-space

Will Deacon <will.deacon@arm.com>
    arm64: Add support for SB barrier and patch in over DSB; ISB sequences

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: fix wrong unit use in ext4_mb_find_by_goal

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: Fix a race to wake a sync task

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Prevent release of buffer in I/O

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: avoid memleak in jbd2_journal_write_metadata_buffer

Michal Pecio <michal.pecio@gmail.com>
    media: uvcvideo: Fix the bandwdith quirk on USB 3.x

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Ignore empty TS packets

Filipe Manana <fdmanana@suse.com>
    btrfs: fix bitmap leak when loading free space cache on duplicate entry

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't give key data to userspace

Roman Smirnov <r.smirnov@omp.ru>
    udf: prevent integer overflow in udf_bitmap_free_blocks()

FUJITA Tomonori <fujita.tomonori@gmail.com>
    PCI: Add Edimax Vendor ID to pci_ids.h

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    clocksource/drivers/sh_cmt: Address race condition for clock events

Yu Kuai <yukuai3@huawei.com>
    md/raid5: avoid BUG_ON() while continue reshape after reassembling

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Stop PPS on driver remove

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()

Eric Dumazet <edumazet@google.com>
    net: linkwatch: use system_unbound_wq

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: fix memory leak for not ip packets

Peter Zijlstra <peterz@infradead.org>
    x86/mm: Fix pti_clone_pgtable() alignment assumption

Yipeng Zou <zouyipeng@huawei.com>
    irqchip/mbigen: Fix mbigen node address layout

Ma Ke <make24@iscas.ac.cn>
    net: usb: sr9700: fix uninitialized variable use in sr_mdio_read

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct surround channels in UAC1 channel map

Al Viro <viro@zeniv.linux.org.uk>
    protect the fetch of ->fd[fd] in do_dup2() from mispredictions

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix overlay when using Screen Targets

Aleksandr Mishin <amishin@t-argos.ru>
    remoteproc: imx_rproc: Skip over memory region when node value is NULL

Dong Aisheng <aisheng.dong@nxp.com>
    remoteproc: imx_rproc: Fix ignoring mapping vdev regions

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: ignore mapping vdev regions

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix a topa_entry base address calculation

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel/pt: Split ToPA metadata and page layout

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel/pt: Use pointer arithmetics instead in ToPA entry calculation

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    perf/x86/intel/pt: Use helpers to obtain ToPA entry size

Chao Peng <chao.p.peng@linux.intel.com>
    perf/x86/intel/pt: Export pt_cap_get()

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Fix memory leakage caused by driver API devm_free_percpu()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    driver core: Cast to (void *) with __force for __percpu pointer

tuhaowen <tuhaowen@uniontech.com>
    dev/parport: fix the array out-of-bounds risk

Joe Perches <joe@perches.com>
    parport: Standardize use of printmode

Joe Perches <joe@perches.com>
    parport: Convert printk(KERN_<LEVEL> to pr_<level>(

Gustavo A. R. Silva <gustavo@embeddedor.com>
    parport: parport_pc: Mark expected switch fall-through

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: rockchip: Use GPIOD_OUT_LOW flag while requesting ep_gpio

Chen-Yu Tsai <wens@csie.org>
    PCI: rockchip: Make 'ep-gpios' DT property optional

Jan Kara <jack@suse.cz>
    mm: avoid overflows in dirty throttling logic

Dan Carpenter <dan.carpenter@linaro.org>
    mISDN: Fix a use after free in hfcmulti_tx()

Shigeru Yoshida <syoshida@redhat.com>
    tipc: Return non-zero value from tipc_udp_addr2str() on error

Johannes Berg <johannes.berg@intel.com>
    net: bonding: correctly annotate RCU in bond_should_notify_peers()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix incorrect source address in Record Route option

Maciej Żenczykowski <maze@google.com>
    net: ip_rt_get_source() - use new style struct initializer instead of memset

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: SMP-CPS: Fix address for GCR_ACCESS register for CM3 and later

Lance Richardson <rlance@google.com>
    dma: fix call order in dmam_free_coherent

Jeongjun Park <aha310510@gmail.com>
    jfs: Fix array-index-out-of-bounds in diFree

Douglas Anderson <dianders@chromium.org>
    kdb: Use the passed prompt in kdb_position_cursor()

Arnd Bergmann <arnd@arndb.de>
    kdb: address -Wformat-security warnings

Wenlin Kang <wenlin.kang@windriver.com>
    kdb: Fix bound check compiler warning

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: handle inconsistent state in nilfs_btnode_create_block()

Michael Ellerman <mpe@ellerman.id.au>
    selftests/sigaltstack: Fix ppc64 GCC build

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a use-after-free related to destroying CM IDs

Jiaxun Yang <jiaxun.yang@flygoat.com>
    platform: mips: cpu_hwmon: Disable driver on unsupported hardware

Thomas Gleixner <tglx@linutronix.de>
    watchdog/perf: properly initialize the turbo mode timestamp and rearm counter

Marco Cavenati <cavenati.marco@gmail.com>
    perf/x86/intel/pt: Fix topa_entry base length

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: validate nvme_local_port correctly

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: During vport delete send async logout explicitly

Joy Chakraborty <joychakr@google.com>
    rtc: cmos: Fix return value of nvmem callbacks

Zijun Hu <quic_zijuhu@quicinc.com>
    kobject_uevent: Fix OOB access within zap_modalias_env()

Ross Lagerwall <ross.lagerwall@citrix.com>
    decompress_bunzip2: fix rare decompression failure

Fedor Pchelkin <pchelkin@ispras.ru>
    ubi: eba: properly rollback inside self_check_eba

Bastien Curutchet <bastien.curutchet@bootlin.com>
    clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use

Chao Yu <chao@kernel.org>
    f2fs: fix to don't dirty inode for readonly filesystem

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds

Carlos Llamas <cmllamas@google.com>
    binder: fix hang of unregistered readers

Wei Liu <wei.liu@kernel.org>
    PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    hwrng: amd - Convert PCIBIOS_* return codes to errnos

Alan Stern <stern@rowland.harvard.edu>
    tools/memory-model: Fix bug in lock.cat

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    leds: ss4200: Convert PCIBIOS_* return codes to errnos

Rafael Beims <rafael.beims@toradex.com>
    wifi: mwifiex: Fix interface type change

Baokun Li <libaokun1@huawei.com>
    ext4: make sure the first directory block is not a hole

Baokun Li <libaokun1@huawei.com>
    ext4: check dot and dotdot of dx_root before making dir indexed

Paolo Pisati <p.pisati@gmail.com>
    m68k: amiga: Turn off Warp1260 interrupts during boot

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in psb_intel_lvds_get_modes

Ma Ke <make24@iscas.ac.cn>
    drm/gma500: fix null pointer dereference in cdv_intel_lvds_get_modes

Chao Yu <chao@kernel.org>
    hfs: fix to initialize fields of hfs_inode_info after hfs_alloc_inode()

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: venus: fix use after free in vdec_close

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    char: tpm: Fix possible memory leak in tpm_bios_measurements_open()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: take care of scope when choosing the src addr

Chengen Du <chengen.du@canonical.com>
    af_packet: Handle outgoing VLAN packets without hardware offloading

Breno Leitao <leitao@debian.org>
    net: netconsole: Disable target before netpoll cleanup

Yu Liao <liaoyu15@huawei.com>
    tick/broadcast: Make takeover of broadcast hrtimer reliable

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro

Alex Shi <alex.shi@linux.alibaba.com>
    fs/nilfs2: remove some unused macros to tame gcc

Peng Fan <peng.fan@nxp.com>
    pinctrl: freescale: mxs: Fix refcount of child

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pinctrl: ti: ti-iodelay: Drop if block with always false condition

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: single: fix possible memory leak when pinctrl_enable() fails

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: core: fix possible memory leak when pinctrl_enable() fails

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: use helper function to calculate expect ID

Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
    ice: Rework flex descriptor programming

Jack Wang <jinpu.wang@ionos.com>
    bnxt_re: Fix imm_data endianness

Nick Bowler <nbowler@draconx.ca>
    macintosh/therm_windtunnel: fix module unload.

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/xmon: Fix disassembly CPU feature checks

Dominique Martinet <dominique.martinet@atmark-techno.com>
    MIPS: Octeron: remove source file executable bit

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: elan_i2c - do not leave interrupt disabled on suspend failure

Arnd Bergmann <arnd@arndb.de>
    mtd: make mtd_test.c a separate module

Honggang LI <honggangli@163.com>
    RDMA/rxe: Don't set BTH_ACK_MASK for UC or UD QPs

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Fix truncated output warning in alias_GUID.c

Leon Romanovsky <leonro@nvidia.com>
    RDMA/mlx4: Fix truncated output warning in mad.c

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix resource double counting on remove & rescan

Jon Derrick <jonathan.derrick@intel.com>
    PCI: Equalize hotplug memory and io for occupied and empty slots

Andreas Larsson <andreas@gaisler.com>
    sparc64: Fix incorrect function signature and add prototype for prom_cif_init

Jan Kara <jack@suse.cz>
    ext4: avoid writing unitialized memory to disk in EA inodes

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    mfd: omap-usb-tll: Use struct_size to allocate tll

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: fix DMA direction handling for cached RW buffers

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix condition in sort__sym_cmp()

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Unregister sysfs attributes before calling deactivate()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Store RPF partition configuration per RPF instance

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: renesas: vsp1: Fix _irqsave and _irq mix

Daniel Schaefer <dhs@frame.work>
    media: uvcvideo: Override default flags

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Allow entity-defined get_info and get_cur

Aleksandr Burakov <a.burakov@rosalinux.ru>
    saa7134: Unchecked i2c_transfer function result fixed

Ricardo Ribalda <ribalda@chromium.org>
    media: imon: Fix race getting ictx->lock

Amit Cohen <amcohen@nvidia.com>
    selftests: forwarding: devlink_lib: Wait for udev events after reloading

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    bna: adjust 'name' buf size of bna_tcb and bna_ccb structures

Adrian Hunter <adrian.hunter@intel.com>
    perf: Prevent passing zero nr_pages to rb_alloc_aux()

Adrian Hunter <adrian.hunter@intel.com>
    perf: Fix perf_aux_size() for greater-than 32-bit size

Ismael Luceno <iluceno@suse.de>
    ipvs: Avoid unnecessary calls to skb_is_gso_sctp

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Fix FEC_ECR_EN1588 being cleared on link-down

Csókás Bence <csokas.bence@prolan.hu>
    net: fec: Refactor: #define magic constants

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: handle 2x996 RU allocation in cfg80211_calculate_bitrate_he()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: cfg80211: fix typo in cfg80211_calculate_bitrate_he()

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Check length of recv in test_sockmap

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: set rmb's SG_MAX_SINGLE_ALLOC limitation only when CONFIG_ARCH_NO_SG_CHAIN is defined

Stefan Raspl <raspl@linux.ibm.com>
    net/smc: Allow SMC-D 1MB DMB allocations

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    wifi: brcmsmac: LCN PHY code is used for BCM4313 2G-only device

Thorsten Blum <thorsten.blum@toblux.com>
    m68k: cmpxchg: Fix return value for default case in __arch_xchg()

Chen Ni <nichen@iscas.ac.cn>
    x86/xen: Convert comma to semicolon

Eero Tamminen <oak@helsinkinet.fi>
    m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Increase VOP clk rate on RK3328

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix swapped temp{1,8} critical alarms

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Auto-convert to use SENSOR_DEVICE_ATTR_{RO, RW, WO}

Guenter Roeck <linux@roeck-us.net>
    hwmon: Introduce SENSOR_DEVICE_ATTR_{RO, RW, WO} and variants

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max6697) Fix underflow when writing limit attributes

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Always do lazy disabling

Wayne Tung <chineweff@gmail.com>
    hwmon: (adt7475) Fix default duty on fan is disabled

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/pci/xen: Fix PCIBIOS_* return code handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/pci/intel_mid_pci: Fix PCIBIOS_* return code handling

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    x86/of: Return consistent error type from x86_of_pci_irq_enable()

Chao Yu <chao@kernel.org>
    hfsplus: fix to avoid false alarm of circular locking

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_debugfs: fix wrong EC message version


-------------

Diffstat:

 Documentation/arm64/silicon-errata.txt             |  18 ++
 Documentation/hwmon/hwmon-kernel-api.txt           |  24 +-
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |  38 +++
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   4 +-
 arch/arm64/include/asm/assembler.h                 |  13 +
 arch/arm64/include/asm/barrier.h                   |   4 +
 arch/arm64/include/asm/cpucaps.h                   |   4 +-
 arch/arm64/include/asm/cputype.h                   |  16 ++
 arch/arm64/include/asm/sysreg.h                    |   6 +
 arch/arm64/include/asm/uaccess.h                   |   3 +-
 arch/arm64/include/uapi/asm/hwcap.h                |   1 +
 arch/arm64/kernel/cpu_errata.c                     |  43 ++++
 arch/arm64/kernel/cpufeature.c                     | 107 ++++++--
 arch/arm64/kernel/cpuinfo.c                        |   1 +
 arch/m68k/amiga/config.c                           |   9 +
 arch/m68k/atari/ataints.c                          |   6 +-
 arch/m68k/include/asm/cmpxchg.h                    |   2 +-
 arch/mips/include/asm/mips-cm.h                    |   4 +
 arch/mips/kernel/smp-cps.c                         |   5 +-
 arch/mips/pci/pcie-octeon.c                        |   0
 arch/powerpc/xmon/ppc-dis.c                        |  33 +--
 arch/sparc/include/asm/oplib_64.h                  |   1 +
 arch/sparc/prom/init_64.c                          |   3 -
 arch/sparc/prom/p1275.c                            |   2 +-
 arch/x86/events/intel/pt.c                         | 157 +++++++-----
 arch/x86/events/intel/pt.h                         |  25 +-
 arch/x86/include/asm/intel_pt.h                    |  23 ++
 arch/x86/kernel/cpu/mtrr/mtrr.c                    |   2 +-
 arch/x86/kernel/devicetree.c                       |   2 +-
 arch/x86/mm/pti.c                                  |   6 +-
 arch/x86/pci/intel_mid_pci.c                       |   4 +-
 arch/x86/pci/xen.c                                 |   4 +-
 arch/x86/platform/intel/iosf_mbi.c                 |   4 +-
 arch/x86/xen/p2m.c                                 |   4 +-
 drivers/android/binder.c                           |   4 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/devres.c                              |   8 +-
 drivers/base/module.c                              |   4 +
 drivers/char/hw_random/amd-rng.c                   |   4 +-
 drivers/char/tpm/eventlog/common.c                 |   2 +
 drivers/clk/davinci/da8xx-cfgchip.c                |   4 +-
 drivers/clocksource/sh_cmt.c                       |  13 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_reg.c  |   5 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |   6 +-
 drivers/gpu/drm/gma500/cdv_intel_lvds.c            |   3 +
 drivers/gpu/drm/gma500/psb_intel_lvds.c            |   3 +
 drivers/gpu/drm/i915/i915_gem.c                    |  47 +++-
 drivers/gpu/drm/mgag200/mgag200_i2c.c              |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/hwmon/adt7475.c                            |   2 +-
 drivers/hwmon/max6697.c                            | 125 ++++------
 drivers/i2c/i2c-smbus.c                            |  69 ++++-
 drivers/infiniband/core/iwcm.c                     |  11 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   6 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c            |   2 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   7 +-
 drivers/input/mouse/elan_i2c_core.c                |   2 +
 drivers/irqchip/irq-mbigen.c                       |  20 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   7 +-
 drivers/leds/led-triggers.c                        |   2 +-
 drivers/leds/leds-ss4200.c                         |   7 +-
 drivers/macintosh/therm_windtunnel.c               |   2 +-
 drivers/md/raid5.c                                 |  20 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   8 +-
 drivers/media/platform/qcom/venus/vdec.c           |   1 +
 drivers/media/platform/vsp1/vsp1_histo.c           |  20 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   8 +-
 drivers/media/rc/imon.c                            |   5 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  90 ++++---
 drivers/media/usb/uvc/uvc_video.c                  |  37 ++-
 drivers/media/usb/uvc/uvcvideo.h                   |   5 +
 drivers/mfd/omap-usb-tll.c                         |   3 +-
 drivers/mtd/tests/Makefile                         |  34 +--
 drivers/mtd/tests/mtd_test.c                       |   9 +
 drivers/mtd/ubi/eba.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   7 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |   2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |  11 +-
 drivers/net/ethernet/freescale/fec_main.c          |  52 ++--
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_common.c        | 102 ++++++--
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |  24 +-
 drivers/net/netconsole.c                           |   2 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/sr9700.c                           |  11 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  18 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   2 +
 drivers/nvme/host/pci.c                            |   7 +
 drivers/parport/daisy.c                            |   6 +-
 drivers/parport/ieee1284.c                         |   4 +-
 drivers/parport/ieee1284_ops.c                     |   3 +-
 drivers/parport/parport_amiga.c                    |   2 +-
 drivers/parport/parport_atari.c                    |   2 +-
 drivers/parport/parport_cs.c                       |   6 +-
 drivers/parport/parport_gsc.c                      |  15 +-
 drivers/parport/parport_ip32.c                     |  25 +-
 drivers/parport/parport_mfc3.c                     |   2 +-
 drivers/parport/parport_pc.c                       | 180 ++++++-------
 drivers/parport/parport_sunbpp.c                   |   2 +-
 drivers/parport/probe.c                            |   7 +-
 drivers/parport/procfs.c                           |  28 ++-
 drivers/parport/share.c                            |  24 +-
 drivers/pci/controller/pci-hyperv.c                |   4 +-
 drivers/pci/controller/pcie-rockchip.c             |  12 +-
 drivers/pci/setup-bus.c                            |  32 +--
 drivers/pinctrl/core.c                             |  12 +-
 drivers/pinctrl/freescale/pinctrl-mxs.c            |   4 +-
 drivers/pinctrl/pinctrl-single.c                   |   7 +-
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |  14 +-
 drivers/platform/chrome/cros_ec_debugfs.c          |   1 +
 drivers/platform/mips/cpu_hwmon.c                  |   3 +
 drivers/power/supply/axp288_charger.c              |  24 +-
 drivers/pwm/pwm-stm32.c                            |   5 +-
 drivers/remoteproc/imx_rproc.c                     |   5 +
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/s390/char/sclp_sd.c                        |  10 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   5 +-
 drivers/scsi/ufs/ufshcd.c                          |  11 +-
 drivers/spi/spi-fsl-lpspi.c                        | 277 ++++++++++++++-------
 drivers/tty/serial/serial_core.c                   |   8 +
 drivers/usb/gadget/udc/core.c                      |  10 +-
 drivers/usb/serial/usb_debug.c                     |   7 +
 drivers/usb/usbip/vhci_hcd.c                       |   9 +-
 fs/btrfs/free-space-cache.c                        |   1 +
 fs/exec.c                                          |   8 +-
 fs/ext4/mballoc.c                                  |   3 +-
 fs/ext4/namei.c                                    |  73 ++++--
 fs/ext4/xattr.c                                    |   6 +
 fs/f2fs/inode.c                                    |   3 +
 fs/file.c                                          |   1 +
 fs/hfs/inode.c                                     |   3 +
 fs/hfsplus/bfind.c                                 |  15 +-
 fs/hfsplus/extents.c                               |   9 +-
 fs/hfsplus/hfsplus_fs.h                            |  21 ++
 fs/jbd2/journal.c                                  |   1 +
 fs/jfs/jfs_imap.c                                  |   5 +-
 fs/nilfs2/btnode.c                                 |  25 +-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/segment.c                                |   7 +-
 fs/udf/balloc.c                                    |  36 +--
 include/linux/hwmon-sysfs.h                        |  39 +++
 include/linux/pci_ids.h                            |   2 +
 include/linux/trace_events.h                       |   1 -
 include/net/netfilter/nf_tables.h                  |  21 +-
 include/uapi/linux/zorro_ids.h                     |   3 +
 kernel/debug/kdb/kdb_io.c                          |   8 +-
 kernel/dma/mapping.c                               |   2 +-
 kernel/events/core.c                               |   2 +
 kernel/events/internal.h                           |   2 +-
 kernel/time/ntp.c                                  |   9 +-
 kernel/time/tick-broadcast.c                       |  24 ++
 kernel/trace/tracing_map.c                         |   6 +-
 kernel/watchdog_hld.c                              |  11 +-
 lib/decompress_bunzip2.c                           |   3 +-
 lib/kobject_uevent.c                               |  17 +-
 mm/page-writeback.c                                |  30 ++-
 net/bluetooth/l2cap_core.c                         |   1 +
 net/core/link_watch.c                              |   4 +-
 net/ipv4/route.c                                   |  21 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/ndisc.c                                   |  34 +--
 net/iucv/af_iucv.c                                 |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/nf_conntrack_netlink.c               |   3 +-
 net/netfilter/nf_tables_api.c                      | 128 ++--------
 net/netfilter/nft_set_hash.c                       |   8 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 net/packet/af_packet.c                             |  86 ++++++-
 net/smc/smc_core.c                                 |  32 +--
 net/sunrpc/sched.c                                 |   4 +-
 net/tipc/udp_media.c                               |   5 +-
 net/wireless/nl80211.c                             |  10 +-
 net/wireless/util.c                                |   8 +-
 scripts/gcc-x86_32-has-stack-protector.sh          |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh          |   2 +-
 sound/usb/line6/driver.c                           |   5 +
 sound/usb/stream.c                                 |   4 +-
 tools/memory-model/lock.cat                        |  20 +-
 tools/perf/util/sort.c                             |   2 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   3 +-
 .../selftests/net/forwarding/devlink_lib.sh        |   2 +
 .../selftests/sigaltstack/current_stack_pointer.h  |   2 +-
 188 files changed, 1966 insertions(+), 1079 deletions(-)


