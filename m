Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E3B16B394;
	Tue,  2 Jul 2024 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941338; cv=none; b=pj71h33utqxV0rQZ2qNxhY7SoXNly+sWjmZS4TOL4auQoXESkF+mwPL8AkhwK/Vql5fAAcAGBvF6J8IMGI+nAcV2pMj5ANOBaGLeWvyIJpQGd8lxIZplCjMvwuSrP8G1lidhlk/xZYRCDYWiIVLEnqQ4TEj2JpLONPC9pOXDGII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941338; c=relaxed/simple;
	bh=nCrVbl3xfPe3+QYMf4gHdC7dsdeL/oAsFT+GyvYs34E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h6PhdJlpXjVC9v5vMwkVIFgZetEhd4Rnh/qWYR5jhnHj/4Z08j8uk0b22mZ5qSVndqaJTLNxV3XezkfaCtqjybNjBr2KluS6zyHAuSWuSOXf3Cbn3hN1XVmnRIblKkv+K3IMnvNRQC08iQcEtV2LJrWjN1VU4GvFi418ahAf3Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3SL1Jvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3SL1Jvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F14C116B1;
	Tue,  2 Jul 2024 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941337;
	bh=nCrVbl3xfPe3+QYMf4gHdC7dsdeL/oAsFT+GyvYs34E=;
	h=From:To:Cc:Subject:Date:From;
	b=g3SL1JvvPWF3LX7qg0aArlVPxxQvu6OT3CYVj2TzwtIMTdURc/Yku/he9cZxHYCz8
	 /JiCYoWrHv8itGImJCMt/YovWFwiXPUD4oeJ3BXyojWanCsvJw2ou+tfztAlGWnKyy
	 cKBiWEgVb/gYrgVVeDiq6Db9GXwkXjHhLptt+Ba4=
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
Subject: [PATCH 6.1 000/128] 6.1.97-rc1 review
Date: Tue,  2 Jul 2024 19:03:21 +0200
Message-ID: <20240702170226.231899085@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.97-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.97-rc1
X-KernelTest-Deadline: 2024-07-04T17:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.97 release.
There are 128 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.97-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.97-rc1

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Add sound-dai-cells for RK3368

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Rename LED related pinctrl nodes on rk3308-rock-pi-s

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Fix SD NAND and eMMC init on rk3308-rock-pi-s

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Free EFI memory map only when installing a new one.

Ard Biesheuvel <ardb@kernel.org>
    efi: xen: Set EFI_PARAVIRT for Xen dom0 boot on all architectures

Ard Biesheuvel <ardb@kernel.org>
    efi: memmap: Move manipulation routines into x86 arch tree

Juntong Deng <juntong.deng@outlook.com>
    gfs2: Fix slab-use-after-free in gfs2_qd_dealloc

yangge <yangge1116@126.com>
    mm/page_alloc: Separate THP PCP into movable and non-movable categories

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "cpufreq: amd-pstate: Fix the inconsistency in max frequency units"

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Refuse too small period requests

Arnd Bergmann <arnd@arndb.de>
    syscalls: fix sys_fanotify_mark prototype

Arnd Bergmann <arnd@arndb.de>
    syscalls: fix compat_sys_io_pgetevents_time64 usage

Arnd Bergmann <arnd@arndb.de>
    ftruncate: pass a signed offset

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix double free on error

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Clean up sysfs file on error

Vitor Soares <vitor.soares@toradex.com>
    can: mcp251xfd: fix infinite loop when xmit fails

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't accept TT entries for out-of-spec VIDs

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: fix parsing of vram_info

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix potential UAF by revoke of fence registers

Julia Zhang <julia.zhang@amd.com>
    drm/amdgpu: avoid using null object of framebuffer

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes

Arnd Bergmann <arnd@arndb.de>
    hexagon: fix fadvise64_64 calling conventions

Arnd Bergmann <arnd@arndb.de>
    csky, hexagon: fix broken sys_sync_file_range

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix initial free space detection

Arnd Bergmann <arnd@arndb.de>
    sh: rework sync_file_range ABI

Dragan Simic <dsimic@manjaro.org>
    kbuild: Install dtb files as 0644 in Makefile.dtbinst

Huacai Chen <chenhuacai@kernel.org>
    irqchip/loongson-liointc: Set different ISRs for different cores

Yuntao Wang <ytcoode@gmail.com>
    cpu/hotplug: Fix dynstate assignment in __cpuhp_setup_state_cpuslocked()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Use HWP to initialize ITMT if CPPC is missing

Oleksij Rempel <linux@rempel-privat.de>
    net: can: j1939: enhanced error handling for tightly received RTS messages in xtp_rx_rts_session_new

Oleksij Rempel <linux@rempel-privat.de>
    net: can: j1939: recover socket queue on CAN bus error during BAM transmission

Shigeru Yoshida <syoshida@redhat.com>
    net: can: j1939: Initialize unused data in j1939_send_one()

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    tty: mcf: MCF54418 has 10 UARTS

Dirk Su <dirk.su@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for EliteBook 645/665 G11.

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    serial: imx: set receiver level before starting uart

Udit Kumar <u-kumar1@ti.com>
    serial: 8250_omap: Implementation of Errata i2310

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: ucsi: stm32: fix command completion handling

Jeremy Kerr <jk@codeconstruct.com.au>
    usb: gadget: aspeed_udc: fix device address configuration

Meng Li <Meng.Li@windriver.com>
    usb: dwc3: core: remove lock of otg mode during gadget suspend/resume to avoid deadlock

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usb: atm: cxacru: fix endpoint checking in cxacru_bind()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: musb: da8xx: fix a resource leak in probe()

Oliver Neukum <oneukum@suse.com>
    usb: gadget: printer: fix races against disable

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

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    iio: accel: fxls8962af: select IIO_BUFFER & IIO_KFIFO_BUF

Fernando Yang <hagisf@usp.br>
    iio: adc: ad7266: Fix variable checking bug

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: discard write requests while old command is running

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: don't erase registers after STOP

David Lechner <dlechner@baylibre.com>
    counter: ti-eqep: enable clock at probe

Sean Anderson <sean.anderson@linux.dev>
    iio: xilinx-ams: Don't include ams_ctrl_channels in scan_mask

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Do not lock spinlock around mmc_gpio_get_ro()

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Do not invert write-protect twice

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mmc: sdhci-pci: Convert PCIBIOS_* return codes to errnos

Kamal Dasu <kamal.dasu@broadcom.com>
    mmc: sdhci-brcmstb: check R1_STATUS for erase/trim/discard

Christoph Hellwig <hch@lst.de>
    nfs: drop the incorrect assertion in nfs_swap_rw()

Jan Kara <jack@suse.cz>
    ocfs2: fix DIO failure due to insufficient transaction credits

Johan Hovold <johan+linaro@kernel.org>
    pinctrl: qcom: spmi-gpio: drop broken pm8008 support

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    Revert "MIPS: pci: lantiq: restore reset gpio polarity"

Arnd Bergmann <arnd@arndb.de>
    parisc: use generic sys_fanotify_mark implementation

Linus Torvalds <torvalds@linux-foundation.org>
    x86: stop playing stack games in profile_pc()

Stefan Berger <stefanb@linux.ibm.com>
    ima: Fix use-after-free on a dentry's dname.name

Kees Cook <kees@kernel.org>
    randomize_kstack: Remove non-functional per-arch entropy filtering

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Disallow reconfiguration without direction (uAPI v1)

Andy Chiu <andy.chiu@sifive.com>
    riscv: stacktrace: convert arch_stack_walk() to noinstr

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix pci state save during mode-1 reset

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/amdgpu: Fix style errors in amdgpu_drv.c & amdgpu_device.c

Aleksandr Mishin <amishin@t-argos.ru>
    gpio: davinci: Validate the obtained number of IRQs

Liu Ying <victor.liu@nxp.com>
    drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA

Hannes Reinecke <hare@suse.de>
    nvme: fixup comment for nvme RDMA Provider Type

Erick Archer <erick.archer@outlook.com>
    drm/radeon/radeon_display: Decrease the size of allocated memory

Andrew Davis <afd@ti.com>
    soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message

Ricardo Ribalda <ribalda@chromium.org>
    media: dvbdev: Initialize sbuf

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emux: improve patch ioctl data validation

Joachim Vandersmissen <git@jvdsn.com>
    crypto: ecdh - explicitly zeroize private_key

Dawei Li <dawei.li@shingroup.cn>
    net/dpaa2: Avoid explicit cpumask var allocation on stack

Dawei Li <dawei.li@shingroup.cn>
    net/iucv: Avoid explicit cpumask var allocation on stack

Wenchao Hao <haowenchao2@huawei.com>
    RDMA/restrack: Fix potential invalid address access

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Mark bpf prog stack with kmsan_unposion_memory in interpreter mode

Anton Protopopov <aspsk@isovalent.com>
    bpf: Add a check for struct bpf_fib_lookup size

Johannes Berg <johannes.berg@intel.com>
    wifi: ieee80211: check for NULL in ieee80211_mle_size_ok()

Denis Arefev <arefev@swemel.ru>
    mtd: partitions: redboot: Added conversion of operands to a larger type

Uros Bizjak <ubizjak@gmail.com>
    x86/fpu: Fix AMD X86_BUG_FXSAVE_LEAK fixup

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: Temporarily fail if control queue feature requested

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: validate block features only with block devices

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()

Yunseong Kim <yskelg@gmail.com>
    tracing/net_sched: NULL pointer dereference in perf_trace_qdisc_reset()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_rcv_fastopen_synack() to enter TCP_CA_Loss for failed TFO

Arnd Bergmann <arnd@arndb.de>
    powerpc: restore some missing spu syscalls

Arnd Bergmann <arnd@arndb.de>
    parisc: use correct compat recv/recvfrom syscalls

Arnd Bergmann <arnd@arndb.de>
    sparc: fix compat recv/recvfrom syscalls

Arnd Bergmann <arnd@arndb.de>
    sparc: fix old compat_sys_select()

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix wrong register write when masking interrupt

luoxuanqiang <luoxuanqiang@kylinos.cn>
    Fix race for duplicate reqsk on identical SYN

Daniil Dulov <d.dulov@aladdin.ru>
    xdp: Remove WARN() from __xdp_reg_mem_model()

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: dsa: microchip: use collision based back pressure mode

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: phy: micrel: add Microchip KSZ 9477 to the device table

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Free any outstanding tx skbs during scrq reset

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix overrunning reservations in ringbuf

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_buffers: Fix memory corruptions on Spectrum-4 systems

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix initial port flush problem

Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
    ASoC: fsl-asoc-card: set priv->pdev before using it

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: remove i2s configuration check in acp_i2s_probe()

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Add missing virt_to_phys() for directed DIBV

Alibek Omarov <a1ba.omarov@gmail.com>
    ASoC: rockchip: i2s-tdm: Fix trcm mode by setting clock on right mclk

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use timestamp to check for set element timeout

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema

Rob Herring <robh@kernel.org>
    dt-bindings: i2c: Drop unneeded quotes

Martin Schiller <ms@dev.tdt.de>
    MIPS: pci: lantiq: restore reset gpio polarity

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux reset in rockchip_pmx_set

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: use dedicated pinctrl type for RK3328

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO3-B pins

Huang-Huang Bao <i@eh5.me>
    pinctrl: rockchip: fix pinmux bits for RK3328 GPIO2-B pins

Hagar Hemdan <hagarhem@amazon.com>
    pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER

John Keeping <jkeeping@inmusicbrands.com>
    Input: ili210x - fix ili251x_read_touch_data() return value

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Force StorageD3Enable on more products

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: utils: Add Picasso to the list for forcing StorageD3Enable

Jan Beulich <jbeulich@suse.com>
    x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Ack also failed Get Error commands

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Never send a lone connector change ack


-------------

Diffstat:

 .../bindings/i2c/amlogic,meson6-i2c.yaml           |   4 +-
 .../devicetree/bindings/i2c/apple,i2c.yaml         |   4 +-
 .../devicetree/bindings/i2c/atmel,at91sam-i2c.yaml |   2 +-
 .../devicetree/bindings/i2c/cdns,i2c-r1p10.yaml    |   4 +-
 .../devicetree/bindings/i2c/i2c-mux-gpio.yaml      |   4 +-
 .../bindings/i2c/qcom,i2c-geni-qcom.yaml           |   4 +-
 .../devicetree/bindings/i2c/st,stm32-i2c.yaml      |   2 +-
 .../bindings/i2c/xlnx,xps-iic-2.00.a.yaml          |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3066a.dtsi                     |   1 +
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts  |  18 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   4 +-
 arch/arm64/boot/dts/rockchip/rk3368.dtsi           |   3 +
 arch/arm64/include/asm/unistd32.h                  |   2 +-
 arch/arm64/kernel/syscall.c                        |  16 +-
 arch/csky/include/uapi/asm/unistd.h                |   1 +
 arch/hexagon/include/asm/syscalls.h                |   6 +
 arch/hexagon/include/uapi/asm/unistd.h             |   1 +
 arch/hexagon/kernel/syscalltab.c                   |   7 +
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   2 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   2 +-
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/kernel/sys_parisc32.c                  |   9 -
 arch/parisc/kernel/syscalls/syscall.tbl            |   6 +-
 arch/powerpc/kernel/syscalls/syscall.tbl           |   6 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/s390/include/asm/entry-common.h               |   2 +-
 arch/s390/kernel/syscalls/syscall.tbl              |   2 +-
 arch/s390/pci/pci_irq.c                            |   2 +-
 arch/sh/kernel/sys_sh32.c                          |  11 +
 arch/sh/kernel/syscalls/syscall.tbl                |   3 +-
 arch/sparc/kernel/sys32.S                          | 221 ------------------
 arch/sparc/kernel/syscalls/syscall.tbl             |   8 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   2 +-
 arch/x86/include/asm/efi.h                         |  11 +
 arch/x86/include/asm/entry-common.h                |  15 +-
 arch/x86/kernel/fpu/core.c                         |   4 +-
 arch/x86/kernel/time.c                             |  20 +-
 arch/x86/mm/numa.c                                 |   6 +-
 arch/x86/platform/efi/Makefile                     |   3 +-
 arch/x86/platform/efi/efi.c                        |   8 +-
 arch/x86/platform/efi/memmap.c                     | 249 +++++++++++++++++++++
 crypto/ecdh.c                                      |   2 +
 drivers/acpi/x86/utils.c                           |  23 +-
 drivers/ata/ahci.c                                 |  17 +-
 drivers/ata/libata-core.c                          |   8 +-
 drivers/counter/ti-eqep.c                          |   6 +
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/cpufreq/intel_pstate.c                     |  13 +-
 drivers/firmware/efi/fdtparams.c                   |   4 +
 drivers/firmware/efi/memmap.c                      | 238 +-------------------
 drivers/gpio/gpio-davinci.c                        |   5 +
 drivers/gpio/gpiolib-cdev.c                        |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  68 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |  18 +-
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c       |   1 +
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c          |   6 +
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c      |   6 +-
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/radeon/radeon.h                    |   1 -
 drivers/gpu/drm/radeon/radeon_display.c            |   8 +-
 drivers/i2c/i2c-slave-testunit.c                   |   5 +-
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/adc/ad7266.c                           |   2 +
 drivers/iio/adc/xilinx-ams.c                       |   8 +-
 drivers/iio/chemical/bme680.h                      |   2 +
 drivers/iio/chemical/bme680_core.c                 |  62 ++++-
 drivers/infiniband/core/restrack.c                 |  51 +----
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/irqchip/irq-loongson-liointc.c             |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |   2 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |   4 +
 drivers/mmc/host/sdhci-pci-core.c                  |  11 +-
 drivers/mmc/host/sdhci.c                           |  25 ++-
 drivers/mtd/parsers/redboot.c                      |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  14 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c       |  55 ++++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   5 +
 drivers/net/dsa/microchip/ksz9477.c                |  10 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   1 +
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  14 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |  20 +-
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/pinctrl/core.c                             |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  68 +++++-
 drivers/pinctrl/pinctrl-rockchip.h                 |   1 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |   1 -
 drivers/pwm/pwm-stm32.c                            |   3 +
 drivers/soc/ti/wkup_m3_ipc.c                       |   7 +-
 drivers/tty/serial/8250/8250_omap.c                |  25 ++-
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/mcf.c                           |   2 +-
 drivers/usb/atm/cxacru.c                           |  14 ++
 drivers/usb/dwc3/core.c                            |   6 -
 drivers/usb/gadget/function/f_printer.c            |  40 +++-
 drivers/usb/gadget/udc/aspeed_udc.c                |   4 +-
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  55 +++--
 drivers/usb/typec/ucsi/ucsi_stm32g0.c              |  19 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  14 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/gfs2/super.c                                    |   2 +
 fs/nfs/direct.c                                    |   2 -
 fs/ocfs2/aops.c                                    |   5 +
 fs/ocfs2/journal.c                                 |  17 ++
 fs/ocfs2/journal.h                                 |   2 +
 fs/ocfs2/ocfs2_trace.h                             |   2 +
 fs/open.c                                          |   4 +-
 include/linux/compat.h                             |   2 +-
 include/linux/efi.h                                |  10 +-
 include/linux/filter.h                             |   5 +-
 include/linux/ieee80211.h                          |   2 +-
 include/linux/mmzone.h                             |   9 +-
 include/linux/nvme.h                               |   4 +-
 include/linux/syscalls.h                           |   8 +-
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/netfilter/nf_tables.h                  |  21 +-
 include/trace/events/qdisc.h                       |   2 +-
 include/uapi/asm-generic/unistd.h                  |   2 +-
 kernel/bpf/core.c                                  |   6 +-
 kernel/bpf/ringbuf.c                               |  31 ++-
 kernel/bpf/verifier.c                              |   8 +-
 kernel/cpu.c                                       |   8 +-
 kernel/sys_ni.c                                    |   2 +-
 mm/page_alloc.c                                    |   8 +-
 net/batman-adv/originator.c                        |  27 +++
 net/can/j1939/main.c                               |   6 +-
 net/can/j1939/transport.c                          |  21 +-
 net/core/filter.c                                  |   3 +
 net/core/xdp.c                                     |   4 +-
 net/dccp/ipv4.c                                    |   7 +-
 net/dccp/ipv6.c                                    |   7 +-
 net/ipv4/inet_connection_sock.c                    |  17 +-
 net/ipv4/tcp_input.c                               |  45 +++-
 net/iucv/iucv.c                                    |  26 ++-
 net/netfilter/nf_tables_api.c                      |  12 +-
 net/netfilter/nft_lookup.c                         |   3 +-
 net/netfilter/nft_set_hash.c                       |   8 +-
 net/netfilter/nft_set_pipapo.c                     |  18 +-
 net/netfilter/nft_set_rbtree.c                     |   6 +-
 scripts/Makefile.dtbinst                           |   2 +-
 security/integrity/ima/ima_api.c                   |  16 +-
 security/integrity/ima/ima_template_lib.c          |  17 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/amd/acp/acp-i2s.c                        |   8 -
 sound/soc/fsl/fsl-asoc-card.c                      |   3 +-
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  13 +-
 sound/synth/emux/soundfont.c                       |  17 +-
 153 files changed, 1232 insertions(+), 947 deletions(-)


