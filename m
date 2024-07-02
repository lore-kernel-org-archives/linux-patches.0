Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF0178381;
	Tue,  2 Jul 2024 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940696; cv=none; b=qqruPBSB1TeMo8GAgdejeUnftrqyrm+fDto4lGhA2AAA1ye5lR0Qlhmsezx++Wi/rHSw3lKxvRxfdFLexsG9Vhnch/BTYwR2qzG8HqBxED+NslSRj0t7MLra1dvzyH3DkMms8k4Gr7smCDaQhh/oHTLin5eDVWmTptD8A73MO9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940696; c=relaxed/simple;
	bh=9sjNuuKzPOp+iuLHDXu+9rvO6eKQ+zESW+CULymlRJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GcuUyuuyyMzJ4KhUHcuzCyuFGgg+zpEzgNfj/tSovHvBIe/DeaBA8sxvtoYEdY+44JfATvlKtxpV6230MhRX5HYslOAUoQlu5YYbLZSHbC1mtptH3EgcCwevs/GLmZhpGGVVNkhEwRNhRSCdZAvqGHwarUOuN5cI9hhcd1pjgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXIdOBg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXIdOBg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD03C116B1;
	Tue,  2 Jul 2024 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940696;
	bh=9sjNuuKzPOp+iuLHDXu+9rvO6eKQ+zESW+CULymlRJY=;
	h=From:To:Cc:Subject:Date:From;
	b=mXIdOBg1xO8ffLe3JEf+k8N1KAwnO+7QZ0UTu939vpdMbMISCEdAbG+1KsS0FDVPL
	 vgS0Q2KOOEekpluxxn8da228bdgMblb8q7IGaSGCRETrcnplpFePL9IypxysFCrzmi
	 cbxxRd2MBiv1CnvwOZsTDHJWM8JjQhTPv7HQNok0=
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
Subject: [PATCH 6.6 000/163] 6.6.37-rc1 review
Date: Tue,  2 Jul 2024 19:01:54 +0200
Message-ID: <20240702170233.048122282@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.37-rc1
X-KernelTest-Deadline: 2024-07-04T17:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.37 release.
There are 163 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.37-rc1

Yao Xingtao <yaoxt.fnst@fujitsu.com>
    cxl/region: check interleave capability

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Avoid null pointer dereference in region lookup

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Move cxl_dpa_to_region() work to the region driver

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Add sound-dai-cells for RK3368

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: make poweroff(8) work on Radxa ROCK 5A

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: rockchip: Fix the value of `dlg,jack-det-rate` mismatch on rk3399-gru

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Rename LED related pinctrl nodes on rk3308-rock-pi-s

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Fix SD NAND and eMMC init on rk3308-rock-pi-s

yangge <yangge1116@126.com>
    mm/page_alloc: Separate THP PCP into movable and non-movable categories

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "cpufreq: amd-pstate: Fix the inconsistency in max frequency units"

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Refuse too small period requests

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: fix NULL dereference of dif->bdev_handle in fscache mode

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

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Send DP_TOTAL_LTTPR_CNT during detection if LTTPR is present

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_hd_modes

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix potential UAF by revoke of fence registers

Julia Zhang <julia.zhang@amd.com>
    drm/amdgpu: avoid using null object of framebuffer

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fbdev-dma: Only set smem_start is enable per module option

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes

Jann Horn <jannh@google.com>
    drm/drm_file: Fix pid refcounting race

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

Huacai Chen <chenhuacai@kernel.org>
    irqchip/loongson-eiointc: Use early_cpu_to_node() instead of cpu_to_node()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Use HWP to initialize ITMT if CPPC is missing

Mostafa Saleh <smostafa@google.com>
    PCI/MSI: Fix UAF in msi_capability_init

Oleksij Rempel <o.rempel@pengutronix.de>
    net: can: j1939: enhanced error handling for tightly received RTS messages in xtp_rx_rts_session_new

Oleksij Rempel <o.rempel@pengutronix.de>
    net: can: j1939: recover socket queue on CAN bus error during BAM transmission

Shigeru Yoshida <syoshida@redhat.com>
    net: can: j1939: Initialize unused data in j1939_send_one()

Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
    tty: mcf: MCF54418 has 10 UARTS

Dirk Su <dirk.su@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for EliteBook 645/665 G11.

Jonas Gorski <jonas.gorski@gmail.com>
    serial: bcm63xx-uart: fix tx after conversion to uart_port_tx_limited()

Jonas Gorski <jonas.gorski@gmail.com>
    serial: core: introduce uart_port_tx_limited_flags()

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    serial: imx: set receiver level before starting uart

Udit Kumar <u-kumar1@ti.com>
    serial: 8250_omap: Implementation of Errata i2310

Doug Brown <doug@schmorgal.com>
    Revert "serial: core: only stop transmit when HW fifo is empty"

Jos Wang <joswang@lenovo.com>
    usb: dwc3: core: Workaround for CSR read timeout

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: dwc3: core: Add DWC31 version 2.00a controller

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: ucsi: stm32: fix command completion handling

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: typec: ucsi: glink: fix child node release in probe function

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

Niklas Cassel <cassel@kernel.org>
    ata,scsi: libata-core: Do not leak memory for ata_port struct members

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix null pointer dereference on error

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: discard write requests while old command is running

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: don't erase registers after STOP

Thayne Harbaugh <thayne@mastodonlabs.com>
    kbuild: Fix build target deb-pkg: ln: failed to create hard link

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    kbuild: doc: Update default INSTALL_MOD_DIR from extra to updates

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

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mmc: sdhci-pci-o2micro: Convert PCIBIOS_* return codes to errnos

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: fix incorrect vbq reference in purge_fragmented_block

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

Kees Cook <kees@kernel.org>
    randomize_kstack: Remove non-functional per-arch entropy filtering

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Disallow reconfiguration without direction (uAPI v1)

Andy Chiu <andy.chiu@sifive.com>
    riscv: stacktrace: convert arch_stack_walk() to noinstr

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix pci state save during mode-1 reset

Jesse Taube <jesse@rivosinc.com>
    RISC-V: fix vector insn load/store width mask

Aleksandr Mishin <amishin@t-argos.ru>
    gpio: davinci: Validate the obtained number of IRQs

Liu Ying <victor.liu@nxp.com>
    drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA

Hannes Reinecke <hare@suse.de>
    nvme: fixup comment for nvme RDMA Provider Type

Erick Archer <erick.archer@outlook.com>
    drm/radeon/radeon_display: Decrease the size of allocated memory

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix NULL pointer dereference in gfs2_log_flush

Andrew Davis <afd@ti.com>
    soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message

Tiezhu Yang <yangtiezhu@loongson.cn>
    irqchip/loongson: Select GENERIC_IRQ_EFFECTIVE_AFF_MASK if SMP for IRQ_LOONGARCH_CPU

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
    bpf: Take return from set_memory_rox() into account with bpf_jit_binary_lock_ro()

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()

Ma Ke <make24@iscas.ac.cn>
    net: mana: Fix possible double free in error handling path

Yunseong Kim <yskelg@gmail.com>
    tracing/net_sched: NULL pointer dereference in perf_trace_qdisc_reset()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing MSB in MIDI2 SPP conversion

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

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing channel at encoding RPN/NRPN MIDI2 messages

luoxuanqiang <luoxuanqiang@kylinos.cn>
    Fix race for duplicate reqsk on identical SYN

Filipe Manana <fdmanana@suse.com>
    btrfs: use NOFS context when getting inodes during logging and log replay

Jianguo Wu <wujianguo@chinatelecom.cn>
    netfilter: fix undefined reference to 'netfilter_lwtunnel_*' when CONFIG_SYSCTL=n

Daniil Dulov <d.dulov@aladdin.ru>
    xdp: Remove WARN() from __xdp_reg_mem_model()

Jan Sokolowski <jan.sokolowski@intel.com>
    ice: Rebuild TC queues on VSI queue reconfiguration

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

Xin Long <lucien.xin@gmail.com>
    openvswitch: get related ct labels from its master if it is not confirmed

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix initial port flush problem

Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
    ASoC: fsl-asoc-card: set priv->pdev before using it

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: remove i2s configuration check in acp_i2s_probe()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: add a null check for chip_pdev structure

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Add missing virt_to_phys() for directed DIBV

Yonghong Song <yonghong.song@linux.dev>
    bpf: Add missed var_off setting in coerce_subreg_to_size_sx()

Yonghong Song <yonghong.song@linux.dev>
    bpf: Add missed var_off setting in set_sext32_default_val()

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-lpass-dai: close graph on prepare errors

Wenchao Hao <haowenchao22@gmail.com>
    workqueue: Increase worker desc's length to 32

Andrei Simion <andrei.simion@microchip.com>
    ASoC: atmel: atmel-classd: Re-add dai_link->platform to fix card init

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: atmel: convert not to use asoc_xxx()

Hsin-Te Yuan <yuanhsinte@chromium.org>
    ASoC: mediatek: mt8183-da7219-max98357: Fix kcontrol name collision

Alibek Omarov <a1ba.omarov@gmail.com>
    ASoC: rockchip: i2s-tdm: Fix trcm mode by setting clock on right mclk

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: mac80211: Use flexible array in struct ieee80211_tim_ie

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: userspace_pm: fixed subtest names

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: print_test out of verify_listener_events

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

Jan Beulich <jbeulich@suse.com>
    x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Ack also failed Get Error commands

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Never send a lone connector change ack

Adam Rizkalla <ajarizzo@gmail.com>
    iio: pressure: bmp280: Fix BMP580 temperature reading

Li peiyu <579lpy@gmail.com>
    iio: pressure: fix some word spelling errors


-------------

Diffstat:

 Documentation/kbuild/modules.rst                   |   8 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rockchip/rk3066a.dtsi            |   1 +
 arch/arm/net/bpf_jit_32.c                          |  25 ++-
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts  |  18 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   4 +-
 arch/arm64/boot/dts/rockchip/rk3368.dtsi           |   3 +
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts   |   1 +
 arch/arm64/include/asm/unistd32.h                  |   2 +-
 arch/arm64/kernel/syscall.c                        |  16 +-
 arch/csky/include/uapi/asm/unistd.h                |   1 +
 arch/hexagon/include/asm/syscalls.h                |   6 +
 arch/hexagon/include/uapi/asm/unistd.h             |   1 +
 arch/hexagon/kernel/syscalltab.c                   |   7 +
 arch/loongarch/net/bpf_jit.c                       |  22 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   2 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   2 +-
 arch/mips/net/bpf_jit_comp.c                       |   3 +-
 arch/parisc/Kconfig                                |   1 +
 arch/parisc/kernel/sys_parisc32.c                  |   9 -
 arch/parisc/kernel/syscalls/syscall.tbl            |   6 +-
 arch/parisc/net/bpf_jit_core.c                     |   8 +-
 arch/powerpc/kernel/syscalls/syscall.tbl           |   6 +-
 arch/riscv/include/asm/insn.h                      |   2 +-
 arch/riscv/kernel/stacktrace.c                     |   2 +-
 arch/s390/include/asm/entry-common.h               |   2 +-
 arch/s390/kernel/syscalls/syscall.tbl              |   2 +-
 arch/s390/net/bpf_jit_comp.c                       |   6 +-
 arch/s390/pci/pci_irq.c                            |   2 +-
 arch/sh/kernel/sys_sh32.c                          |  11 +
 arch/sh/kernel/syscalls/syscall.tbl                |   3 +-
 arch/sparc/kernel/sys32.S                          | 221 ---------------------
 arch/sparc/kernel/syscalls/syscall.tbl             |   8 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |   6 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   2 +-
 arch/x86/include/asm/entry-common.h                |  15 +-
 arch/x86/kernel/fpu/core.c                         |   4 +-
 arch/x86/kernel/time.c                             |  20 +-
 arch/x86/mm/numa.c                                 |   6 +-
 arch/x86/net/bpf_jit_comp32.c                      |   3 +-
 crypto/ecdh.c                                      |   2 +
 drivers/ata/ahci.c                                 |  17 +-
 drivers/ata/libata-core.c                          |  29 ++-
 drivers/counter/ti-eqep.c                          |   6 +
 drivers/cpufreq/amd-pstate.c                       |   2 +-
 drivers/cpufreq/intel_pstate.c                     |  13 +-
 drivers/cxl/core/core.h                            |   7 +
 drivers/cxl/core/hdm.c                             |  13 ++
 drivers/cxl/core/memdev.c                          |  44 ----
 drivers/cxl/core/region.c                          | 137 +++++++++++++
 drivers/cxl/cxl.h                                  |   2 +
 drivers/cxl/cxlmem.h                               |  10 +
 drivers/gpio/gpio-davinci.c                        |   5 +
 drivers/gpio/gpiolib-cdev.c                        |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |  18 +-
 .../display/dc/link/protocols/link_dp_capability.c |  10 +-
 drivers/gpu/drm/amd/display/include/dpcd_defs.h    |   5 +
 drivers/gpu/drm/drm_fb_helper.c                    |   6 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    |   5 +-
 drivers/gpu/drm/drm_file.c                         |   8 +-
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
 drivers/iio/chemical/bme680_core.c                 |  62 +++++-
 drivers/iio/pressure/bmp280-core.c                 |  14 +-
 drivers/iio/pressure/bmp280.h                      |   2 +-
 drivers/infiniband/core/restrack.c                 |  51 +----
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/irqchip/Kconfig                            |   2 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
 drivers/irqchip/irq-loongson-liointc.c             |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |   2 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |   4 +
 drivers/mmc/host/sdhci-pci-core.c                  |  11 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |  41 ++--
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
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |  20 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   2 +
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/pci/msi/msi.c                              |  10 +-
 drivers/pinctrl/core.c                             |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  68 ++++++-
 drivers/pinctrl/pinctrl-rockchip.h                 |   1 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |   1 -
 drivers/pwm/pwm-stm32.c                            |   3 +
 drivers/scsi/libsas/sas_ata.c                      |   6 +-
 drivers/scsi/libsas/sas_discover.c                 |   2 +-
 drivers/soc/ti/wkup_m3_ipc.c                       |   7 +-
 drivers/tty/serial/8250/8250_omap.c                |  25 ++-
 drivers/tty/serial/bcm63xx_uart.c                  |   7 +-
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/mcf.c                           |   2 +-
 drivers/usb/atm/cxacru.c                           |  14 ++
 drivers/usb/dwc3/core.c                            |  26 ++-
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/gadget/function/f_printer.c            |  40 +++-
 drivers/usb/gadget/udc/aspeed_udc.c                |   4 +-
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  55 +++--
 drivers/usb/typec/ucsi/ucsi_glink.c                |   5 +-
 drivers/usb/typec/ucsi/ucsi_stm32g0.c              |  19 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  14 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/btrfs/tree-log.c                                |  43 ++--
 fs/erofs/data.c                                    |   5 +-
 fs/gfs2/log.c                                      |   3 +-
 fs/gfs2/super.c                                    |   4 +
 fs/nfs/direct.c                                    |   2 -
 fs/ocfs2/aops.c                                    |   5 +
 fs/ocfs2/journal.c                                 |  17 ++
 fs/ocfs2/journal.h                                 |   2 +
 fs/ocfs2/ocfs2_trace.h                             |   2 +
 fs/open.c                                          |   4 +-
 include/linux/compat.h                             |   2 +-
 include/linux/filter.h                             |  10 +-
 include/linux/ieee80211.h                          |  15 +-
 include/linux/libata.h                             |   1 +
 include/linux/mmzone.h                             |   9 +-
 include/linux/nvme.h                               |   4 +-
 include/linux/serial_core.h                        |  21 +-
 include/linux/syscalls.h                           |   8 +-
 include/linux/workqueue.h                          |   2 +-
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/netfilter/nf_tables.h                  |   5 +
 include/trace/events/qdisc.h                       |   2 +-
 include/uapi/asm-generic/unistd.h                  |   2 +-
 kernel/bpf/core.c                                  |   6 +-
 kernel/bpf/ringbuf.c                               |  31 ++-
 kernel/bpf/verifier.c                              |  10 +-
 kernel/cpu.c                                       |   8 +-
 kernel/sys_ni.c                                    |   2 +-
 mm/page_alloc.c                                    |   9 +-
 mm/vmalloc.c                                       |  21 +-
 net/batman-adv/originator.c                        |  27 +++
 net/can/j1939/main.c                               |   6 +-
 net/can/j1939/transport.c                          |  21 +-
 net/core/xdp.c                                     |   4 +-
 net/dccp/ipv4.c                                    |   7 +-
 net/dccp/ipv6.c                                    |   7 +-
 net/ipv4/inet_connection_sock.c                    |  17 +-
 net/ipv4/tcp_input.c                               |  45 +++--
 net/iucv/iucv.c                                    |  26 ++-
 net/netfilter/nf_hooks_lwtunnel.c                  |   3 +
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nft_lookup.c                         |   3 +-
 net/openvswitch/conntrack.c                        |   7 +-
 scripts/Makefile.dtbinst                           |   2 +-
 scripts/Makefile.package                           |   2 +-
 sound/core/seq/seq_ump_convert.c                   |  10 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/amd/acp/acp-i2s.c                        |   8 -
 sound/soc/amd/acp/acp-pci.c                        |  10 +-
 sound/soc/atmel/atmel-classd.c                     |  17 +-
 sound/soc/atmel/atmel-pcm-dma.c                    |   8 +-
 sound/soc/atmel/atmel-pcm-pdc.c                    |   4 +-
 sound/soc/atmel/atmel-pdmic.c                      |  12 +-
 sound/soc/atmel/atmel_wm8904.c                     |   4 +-
 sound/soc/atmel/mikroe-proto.c                     |   2 +-
 sound/soc/atmel/sam9g20_wm8731.c                   |   2 +-
 sound/soc/atmel/sam9x5_wm8731.c                    |   2 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   3 +-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |  10 +-
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |  32 +--
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  13 +-
 sound/synth/emux/soundfont.c                       |  17 +-
 tools/testing/cxl/test/cxl.c                       |   4 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  50 +++--
 189 files changed, 1374 insertions(+), 859 deletions(-)


