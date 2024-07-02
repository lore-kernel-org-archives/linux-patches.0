Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B46178381;
	Tue,  2 Jul 2024 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939987; cv=none; b=O3l7XNk8I5Bp5Kj7Cc1bSIW0wW2LZ+P8eq2JMy2J1/7xHIrhyyBMqGhS3A5kGJZq3J10QhdVDaIWd97bk064R/bzV/MHdICG4XvNghEvsJzyFl84b7lGSnmjgPMH+PRb0AGgGkud+X3BuXqye8rpt6GaEyJVRI2dsitnjLSzylY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939987; c=relaxed/simple;
	bh=KL3eWp+5YHaenH/z4QUxwBEvqvMQTne6MuEAa1I+Q3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qg9xlgnD375uWfVWb0NReqzFQWS5m7cQy1DYnBnSEWdw27MQaIOVsaSS3NZWM2xjoFRHmAq6yM1DCz/QoNQ6RciT1LouusHizIOsQrauQ+5h/+aa9+Z/LG7MBIhfMVGfXBz4BjeZUZql0W3knCK4fOpRAQVsEnt5+7CGERJzoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvoSKc+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvoSKc+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE87C116B1;
	Tue,  2 Jul 2024 17:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939987;
	bh=KL3eWp+5YHaenH/z4QUxwBEvqvMQTne6MuEAa1I+Q3E=;
	h=From:To:Cc:Subject:Date:From;
	b=kvoSKc+N2XudXy0UOWthMmaosTcyFgr3d96xm+z1MJlEGw6rf7lmgLPEC4f7Gjgtl
	 bjsyKXrkc0bSHrtm286NMo67bCsjRBxbpFDvJVdfWFMShBDlaIhioUUZ+Ro6k0KBYY
	 xy8ci34LgbWArnNONUTeJYavSjp1e2j0X2Q5yiY4=
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
Subject: [PATCH 6.9 000/222] 6.9.8-rc1 review
Date: Tue,  2 Jul 2024 19:00:38 +0200
Message-ID: <20240702170243.963426416@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.8-rc1
X-KernelTest-Deadline: 2024-07-04T17:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.8 release.
There are 222 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.8-rc1

David Howells <dhowells@redhat.com>
    netfs: Fix netfs_page_mkwrite() to flush conflicting data, not wait

David Howells <dhowells@redhat.com>
    netfs: Fix netfs_page_mkwrite() to check folio->mapping is valid

Yao Xingtao <yaoxt.fnst@fujitsu.com>
    cxl/region: check interleave capability

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Avoid null pointer dereference in region lookup

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Move cxl_dpa_to_region() work to the region driver

Alex Bee <knaerzche@gmail.com>
    arm64: dts: rockchip: Add sound-dai-cells for RK3368

Andy Yan <andyshrk@163.com>
    arm64: dts: rockchip: Fix the i2c address of es8316 on Cool Pi 4B

Mark Brown <broonie@kernel.org>
    reset: gpio: Fix missing gpiolib dependency for GPIO reset controller

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: fix PMIC interrupt pin on ROCK Pi E

Li Ming <ming4.li@intel.com>
    cxl/mem: Fix no cxl_nvd during pmem region auto-assembling

Dan Williams <dan.j.williams@intel.com>
    cxl/region: Convert cxl_pmem_region_alloc to scope-based resource management

FUKAUMI Naoki <naoki@radxa.com>
    arm64: dts: rockchip: make poweroff(8) work on Radxa ROCK 5A

FUKAUMI Naoki <naoki@radxa.com>
    Revert "arm64: dts: rockchip: remove redundant cd-gpios from rk3588 sdmmc nodes"

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: rockchip: Fix the value of `dlg,jack-det-rate` mismatch on rk3399-gru

Heiko Stuebner <heiko.stuebner@cherry.de>
    arm64: dts: rockchip: set correct pwm0 pinctrl on rk3588-tiger

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Rename LED related pinctrl nodes on rk3308-rock-pi-s

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Fix SD NAND and eMMC init on rk3308-rock-pi-s

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Fix error message to not describe the previous error path

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Fix calculation of prescaler

yangge <yangge1116@126.com>
    mm/page_alloc: Separate THP PCP into movable and non-movable categories

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: sfp: enhance quirk for Fibrestore 2.5G copper SFP module"

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: btree_gc can now handle unknown btrees

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Fix setting of downgrade recovery passes/errors

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Fix bch2_sb_downgrade_update()

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Fix sb-downgrade validation

Kent Overstreet <kent.overstreet@linux.dev>
    bcachefs: Fix sb_field_downgrade validation

Arnd Bergmann <arnd@arndb.de>
    syscalls: fix sys_fanotify_mark prototype

Arnd Bergmann <arnd@arndb.de>
    syscalls: fix compat_sys_io_pgetevents_time64 usage

Arnd Bergmann <arnd@arndb.de>
    ftruncate: pass a signed offset

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix double free on error

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Add ATA_HORKAGE_NOLPM for all Crucial BX SSD1 models

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Clean up sysfs file on error

Vitor Soares <vitor.soares@toradex.com>
    can: mcp251xfd: fix infinite loop when xmit fails

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't accept TT entries for out-of-spec VIDs

Jens Axboe <axboe@kernel.dk>
    io_uring: signal SQPOLL task_work with TWA_SIGNAL_NO_IPI

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
    cpu: Fix broken cmdline "nosmp" and "maxcpus=0"

Huacai Chen <chenhuacai@kernel.org>
    irqchip/loongson-eiointc: Use early_cpu_to_node() instead of cpu_to_node()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Use HWP to initialize ITMT if CPPC is missing

Nathan Chancellor <nathan@kernel.org>
    nvmet-fc: Remove __counted_by from nvmet_fc_tgt_queue.fod[]

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

Nathan Chancellor <nathan@kernel.org>
    tty: mxser: Remove __counted_by from mxser_board.ports[]

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

Crescent Hsieh <crescentcy.hsieh@moxa.com>
    tty: serial: 8250: Fix port count mismatch with the device

Doug Brown <doug@schmorgal.com>
    Revert "serial: core: only stop transmit when HW fifo is empty"

Jos Wang <joswang@lenovo.com>
    usb: dwc3: core: Workaround for CSR read timeout

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: ucsi: stm32: fix command completion handling

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: gadget: u_ether: Replace netif_stop_queue with netif_device_detach"

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: gadget: u_ether: Re-attach netif device to mirror detachment"

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

Dimitri Fedrau <dima.fedrau@gmail.com>
    iio: humidity: hdc3020: fix hysteresis representation

Niklas Cassel <cassel@kernel.org>
    ata,scsi: libata-core: Do not leak memory for ata_port struct members

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix null pointer dereference on error

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: discard write requests while old command is running

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: don't erase registers after STOP

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: rpm-pkg: fix build error with CONFIG_MODULES=n

Thayne Harbaugh <thayne@mastodonlabs.com>
    kbuild: Fix build target deb-pkg: ln: failed to create hard link

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    kbuild: doc: Update default INSTALL_MOD_DIR from extra to updates

David Lechner <dlechner@baylibre.com>
    counter: ti-eqep: enable clock at probe

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix backchannel reply, again

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

Linus Walleij <linus.walleij@linaro.org>
    Revert "mmc: moxart-mmc: Use sg_miter for PIO"

Andrew Bresticker <abrestic@rivosinc.com>
    mm/memory: don't require head page for do_set_pmd()

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: fix incorrect vbq reference in purge_fragmented_block

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: fix bad call to unpoison_slab_object

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

David Arcari <darcari@redhat.com>
    tools/power turbostat: option '-n' is ambiguous

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Ignore reconfiguration without direction

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: Disallow reconfiguration without direction (uAPI v1)

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix GT feature enablement again

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Invalidate cache before removing device from domain list

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Introduce per device DTE update function

Andy Chiu <andy.chiu@sifive.com>
    riscv: stacktrace: convert arch_stack_walk() to noinstr

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix pci state save during mode-1 reset

Jesse Taube <jesse@rivosinc.com>
    RISC-V: fix vector insn load/store width mask

NeilBrown <neilb@suse.de>
    nfsd: initialise nfsd_info.mutex early.

Zenghui Yu <yuzenghui@huawei.com>
    arm64: Clear the initial ID map correctly before remapping

Aleksandr Mishin <amishin@t-argos.ru>
    gpio: davinci: Validate the obtained number of IRQs

Liu Ying <victor.liu@nxp.com>
    drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA

Hannes Reinecke <hare@kernel.org>
    nvmet: make 'tsas' attribute idempotent for RDMA

Hannes Reinecke <hare@suse.de>
    nvme: fixup comment for nvme RDMA Provider Type

Hannes Reinecke <hare@kernel.org>
    nvmet: do not return 'reserved' for empty TSAS values

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Check pat.ops before dumping PAT settings

Erick Archer <erick.archer@outlook.com>
    drm/radeon/radeon_display: Decrease the size of allocated memory

Stefan Berger <stefanb@linux.ibm.com>
    evm: Enforce signatures on unsupported filesystem for EVM_INIT_X509

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix NULL pointer dereference in gfs2_log_flush

Andrew Davis <afd@ti.com>
    soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong PASID

Tiezhu Yang <yangtiezhu@loongson.cn>
    irqchip/loongson: Select GENERIC_IRQ_EFFECTIVE_AFF_MASK if SMP for IRQ_LOONGARCH_CPU

Ricardo Ribalda <ribalda@chromium.org>
    media: dvbdev: Initialize sbuf

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emux: improve patch ioctl data validation

Joachim Vandersmissen <git@jvdsn.com>
    crypto: ecdh - explicitly zeroize private_key

Chia-Yuan Li <leo.li@realtek.com>
    wifi: rtw89: download firmware with five times retry

Dawei Li <dawei.li@shingroup.cn>
    net/dpaa2: Avoid explicit cpumask var allocation on stack

Dawei Li <dawei.li@shingroup.cn>
    net/iucv: Avoid explicit cpumask var allocation on stack

Wenchao Hao <haowenchao2@huawei.com>
    RDMA/restrack: Fix potential invalid address access

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/xe_devcoredump: Check NULL before assignments

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Mark bpf prog stack with kmsan_unposion_memory in interpreter mode

Anton Protopopov <aspsk@isovalent.com>
    bpf: Add a check for struct bpf_fib_lookup size

Muhammad Ahmed <ahmed.ahmed@amd.com>
    drm/amd/display: Skip pipe if the pipe idx not set properly

Johannes Berg <johannes.berg@intel.com>
    wifi: ieee80211: check for NULL in ieee80211_mle_size_ok()

Denis Arefev <arefev@swemel.ru>
    mtd: partitions: redboot: Added conversion of operands to a larger type

Sherry Wang <Yao.Wang1@amd.com>
    drm/amd/display: correct hostvm flag

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe: Add a NULL check in xe_ttm_stolen_mgr_init

Uros Bizjak <ubizjak@gmail.com>
    x86/fpu: Fix AMD X86_BUG_FXSAVE_LEAK fixup

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: Temporarily fail if control queue feature requested

Maxime Coquelin <maxime.coquelin@redhat.com>
    vduse: validate block features only with block devices

Nirmoy Das <nirmoy.das@intel.com>
    drm/xe: Fix potential integer overflow in page size calculation

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    drm/panel: ilitek-ili9881c: Fix warning with GPIO controllers that sleep

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_rox() into account with bpf_jit_binary_lock_ro()

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()

Ma Ke <make24@iscas.ac.cn>
    net: mana: Fix possible double free in error handling path

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Fix wrong ioctl(SIOCATMARK) when consumed OOB skb is at the head.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Don't stop recv() at consumed ex-OOB skb.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Don't stop recv(MSG_DONTWAIT) if consumed OOB skb is at the head.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Stop recv(MSG_PEEK) at consumed OOB skb.

Yunseong Kim <yskelg@gmail.com>
    tracing/net_sched: NULL pointer dereference in perf_trace_qdisc_reset()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fully validate NFT_DATA_VALUE on store to data registers

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing MSB in MIDI2 SPP conversion

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_rcv_fastopen_synack() to enter TCP_CA_Loss for failed TFO

Shannon Nelson <shannon.nelson@amd.com>
    ionic: use dev_consume_skb_any outside of napi

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

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: mt8195: Add platform entry for ETDM1_OUT_BE dai link

Daniil Dulov <d.dulov@aladdin.ru>
    xdp: Remove WARN() from __xdp_reg_mem_model()

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix may_goto with negative offset.

Jan Sokolowski <jan.sokolowski@intel.com>
    ice: Rebuild TC queues on VSI queue reconfiguration

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: dsa: microchip: use collision based back pressure mode

Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
    net: phy: micrel: add Microchip KSZ 9477 to the device table

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Free any outstanding tx skbs during scrq reset

Guillaume Nault <gnault@redhat.com>
    vxlan: Pull inner IP header in vxlan_xmit_one().

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix overrunning reservations in ringbuf

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix the corner case with may_goto and jump to the 1st insn.

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_buffers: Fix memory corruptions on Spectrum-4 systems

Ido Schimmel <idosch@nvidia.com>
    mlxsw: pci: Fix driver initialization with Spectrum-4

Taehee Yoo <ap420073@gmail.com>
    ionic: fix kernel panic due to multi-buffer handling

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix incorrect software timestamping report

Xin Long <lucien.xin@gmail.com>
    openvswitch: get related ct labels from its master if it is not confirmed

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix initial port flush problem

Elinor Montmasson <elinor.montmasson@savoirfairelinux.com>
    ASoC: fsl-asoc-card: set priv->pdev before using it

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: move chip->flag variable assignment

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: remove i2s configuration check in acp_i2s_probe()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: add a null check for chip_pdev structure

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix remap of arena.

Halil Pasic <pasic@linux.ibm.com>
    s390/virtio_ccw: Fix config change notifications

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

Hsin-Te Yuan <yuanhsinte@chromium.org>
    ASoC: mediatek: mt8183-da7219-max98357: Fix kcontrol name collision

Alibek Omarov <a1ba.omarov@gmail.com>
    ASoC: rockchip: i2s-tdm: Fix trcm mode by setting clock on right mclk

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: cs42l43: Increase default type detect time and button delay

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: stm32: Refuse too small period requests

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32: Calculate prescaler with a division instead of a loop

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32: Fix for settings using period > UINT32_MAX

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: stm32: Improve precision of calculation in .apply()

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

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Use spin_{lock,unlock}_irq{save,restore}

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Ack also failed Get Error commands

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Never send a lone connector change ack


-------------

Diffstat:

 Documentation/kbuild/modules.rst                   |   8 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/rockchip/rk3066a.dtsi            |   1 +
 arch/arm/net/bpf_jit_32.c                          |  25 +-
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts  |  18 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock-pi-e.dts  |   4 +-
 arch/arm64/boot/dts/rockchip/rk3368.dtsi           |   3 +
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |   2 +-
 .../boot/dts/rockchip/rk3588-orangepi-5-plus.dts   |   1 +
 .../arm64/boot/dts/rockchip/rk3588-quartzpro64.dts |   1 +
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts    |   1 +
 arch/arm64/boot/dts/rockchip/rk3588-tiger.dtsi     |   5 +
 arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts |   4 +-
 arch/arm64/boot/dts/rockchip/rk3588s-rock-5a.dts   |   2 +
 arch/arm64/include/asm/unistd32.h                  |   2 +-
 arch/arm64/kernel/pi/map_kernel.c                  |   2 +-
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
 arch/sparc/kernel/sys32.S                          | 221 --------------
 arch/sparc/kernel/syscalls/syscall.tbl             |   8 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |   6 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   2 +-
 arch/x86/include/asm/entry-common.h                |  15 +-
 arch/x86/kernel/fpu/core.c                         |   4 +-
 arch/x86/kernel/time.c                             |  20 +-
 arch/x86/net/bpf_jit_comp32.c                      |   3 +-
 crypto/ecdh.c                                      |   2 +
 drivers/ata/ahci.c                                 |  17 +-
 drivers/ata/libata-core.c                          |  32 +-
 drivers/counter/ti-eqep.c                          |   6 +
 drivers/cpufreq/intel_pstate.c                     |  13 +-
 drivers/cxl/core/core.h                            |   7 +
 drivers/cxl/core/hdm.c                             |  13 +
 drivers/cxl/core/memdev.c                          |  44 ---
 drivers/cxl/core/pmem.c                            |  16 +-
 drivers/cxl/core/region.c                          | 182 ++++++++++--
 drivers/cxl/cxl.h                                  |   6 +-
 drivers/cxl/cxlmem.h                               |  10 +
 drivers/cxl/mem.c                                  |  17 +-
 drivers/gpio/gpio-davinci.c                        |   5 +
 drivers/gpio/gpiolib-cdev.c                        |  28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |  18 +-
 drivers/gpu/drm/amd/display/dc/dml2/dml2_utils.c   |   5 +
 .../display/dc/link/protocols/link_dp_capability.c |  10 +-
 .../amd/display/dc/resource/dcn31/dcn31_resource.c |   2 +-
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
 drivers/gpu/drm/xe/xe_devcoredump.c                |  10 +-
 drivers/gpu/drm/xe/xe_pat.c                        |   2 +-
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c             |   5 +
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c               |   2 +-
 drivers/i2c/i2c-slave-testunit.c                   |   5 +-
 drivers/iio/accel/Kconfig                          |   2 +
 drivers/iio/adc/ad7266.c                           |   2 +
 drivers/iio/adc/xilinx-ams.c                       |   8 +-
 drivers/iio/chemical/bme680.h                      |   2 +
 drivers/iio/chemical/bme680_core.c                 |  62 +++-
 drivers/iio/humidity/hdc3020.c                     | 323 ++++++++++++++++-----
 drivers/infiniband/core/restrack.c                 |  51 +---
 drivers/input/touchscreen/ili210x.c                |   4 +-
 drivers/iommu/amd/amd_iommu.h                      |   1 +
 drivers/iommu/amd/init.c                           |   1 +
 drivers/iommu/amd/iommu.c                          |  34 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   3 +
 drivers/irqchip/Kconfig                            |   2 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   5 +-
 drivers/irqchip/irq-loongson-liointc.c             |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |   2 +-
 drivers/mmc/host/moxart-mmc.c                      |  78 ++---
 drivers/mmc/host/sdhci-brcmstb.c                   |   4 +
 drivers/mmc/host/sdhci-pci-core.c                  |  11 +-
 drivers/mmc/host/sdhci-pci-o2micro.c               |  41 +--
 drivers/mmc/host/sdhci.c                           |  25 +-
 drivers/mtd/parsers/redboot.c                      |   2 +-
 drivers/net/bonding/bond_main.c                    |   3 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  14 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c       |  55 +++-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   5 +
 drivers/net/dsa/microchip/ksz9477.c                |  10 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   1 +
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  14 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   6 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |  18 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |  20 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   2 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  55 ++--
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/phy/sfp.c                              |  18 +-
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/vxlan/vxlan_core.c                     |   9 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  27 +-
 drivers/nvme/target/configfs.c                     |  41 ++-
 drivers/nvme/target/fc.c                           |   2 +-
 drivers/pci/msi/msi.c                              |  10 +-
 drivers/pinctrl/core.c                             |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  68 ++++-
 drivers/pinctrl/pinctrl-rockchip.h                 |   1 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |   1 -
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   4 +-
 drivers/pwm/pwm-stm32.c                            |  62 ++--
 drivers/reset/Kconfig                              |   1 +
 drivers/s390/virtio/virtio_ccw.c                   |   4 +-
 drivers/scsi/libsas/sas_ata.c                      |   6 +-
 drivers/scsi/libsas/sas_discover.c                 |   2 +-
 drivers/soc/ti/wkup_m3_ipc.c                       |   7 +-
 drivers/tty/mxser.c                                |   2 +-
 drivers/tty/serial/8250/8250_omap.c                |  25 +-
 drivers/tty/serial/8250/8250_pci.c                 |  13 +-
 drivers/tty/serial/bcm63xx_uart.c                  |   7 +-
 drivers/tty/serial/imx.c                           |   4 +-
 drivers/tty/serial/mcf.c                           |   2 +-
 drivers/usb/atm/cxacru.c                           |  14 +
 drivers/usb/dwc3/core.c                            |  26 +-
 drivers/usb/gadget/function/f_printer.c            |  40 ++-
 drivers/usb/gadget/function/u_ether.c              |   4 +-
 drivers/usb/gadget/udc/aspeed_udc.c                |   4 +-
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  55 ++--
 drivers/usb/typec/ucsi/ucsi_glink.c                |   5 +-
 drivers/usb/typec/ucsi/ucsi_stm32g0.c              |  19 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  14 +-
 fs/bcachefs/bcachefs.h                             |  44 +--
 fs/bcachefs/btree_gc.c                             |  15 +-
 fs/bcachefs/btree_gc.h                             |  48 ++-
 fs/bcachefs/btree_gc_types.h                       |  29 ++
 fs/bcachefs/ec.c                                   |   2 +-
 fs/bcachefs/sb-downgrade.c                         |  17 +-
 fs/bcachefs/super-io.c                             |  12 +-
 fs/btrfs/free-space-cache.c                        |   2 +-
 fs/btrfs/tree-log.c                                |  43 ++-
 fs/gfs2/log.c                                      |   3 +-
 fs/gfs2/super.c                                    |   4 +
 fs/netfs/buffered_write.c                          |  12 +-
 fs/nfs/direct.c                                    |   2 -
 fs/nfsd/nfsctl.c                                   |   2 +
 fs/nfsd/nfssvc.c                                   |   1 -
 fs/ocfs2/aops.c                                    |   5 +
 fs/ocfs2/journal.c                                 |  17 ++
 fs/ocfs2/journal.h                                 |   2 +
 fs/ocfs2/ocfs2_trace.h                             |   2 +
 fs/open.c                                          |   4 +-
 include/linux/compat.h                             |   2 +-
 include/linux/filter.h                             |  10 +-
 include/linux/ieee80211.h                          |   2 +-
 include/linux/libata.h                             |   1 +
 include/linux/mmzone.h                             |   9 +-
 include/linux/nvme.h                               |   6 +-
 include/linux/serial_core.h                        |  21 +-
 include/linux/syscalls.h                           |   8 +-
 include/linux/workqueue.h                          |   2 +-
 include/net/inet_connection_sock.h                 |   2 +-
 include/net/netfilter/nf_tables.h                  |   5 +
 include/trace/events/qdisc.h                       |   2 +-
 include/uapi/asm-generic/unistd.h                  |   2 +-
 io_uring/io_uring.c                                |   4 +-
 kernel/bpf/arena.c                                 |  16 +-
 kernel/bpf/core.c                                  |   6 +-
 kernel/bpf/ringbuf.c                               |  31 +-
 kernel/bpf/verifier.c                              |  69 ++++-
 kernel/cpu.c                                       |  11 +-
 kernel/sys_ni.c                                    |   2 +-
 mm/kasan/common.c                                  |   2 +-
 mm/memory.c                                        |   3 +-
 mm/page_alloc.c                                    |   9 +-
 mm/vmalloc.c                                       |  21 +-
 net/batman-adv/originator.c                        |  27 ++
 net/can/j1939/main.c                               |   6 +-
 net/can/j1939/transport.c                          |  21 +-
 net/core/filter.c                                  |   3 +
 net/core/xdp.c                                     |   4 +-
 net/dccp/ipv4.c                                    |   7 +-
 net/dccp/ipv6.c                                    |   7 +-
 net/ipv4/inet_connection_sock.c                    |  17 +-
 net/ipv4/tcp_input.c                               |  45 ++-
 net/iucv/iucv.c                                    |  26 +-
 net/netfilter/nf_hooks_lwtunnel.c                  |   3 +
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nft_lookup.c                         |   3 +-
 net/openvswitch/conntrack.c                        |   7 +-
 net/sunrpc/svc.c                                   |   5 +-
 net/unix/af_unix.c                                 |  37 ++-
 scripts/Makefile.dtbinst                           |   2 +-
 scripts/Makefile.package                           |   2 +-
 scripts/package/kernel.spec                        |   8 +-
 security/integrity/evm/evm_main.c                  |  12 +-
 sound/core/seq/seq_ump_convert.c                   |  10 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/amd/acp/acp-i2s.c                        |   8 -
 sound/soc/amd/acp/acp-pci.c                        |  12 +-
 sound/soc/atmel/atmel-classd.c                     |   7 +-
 sound/soc/codecs/cs42l43-jack.c                    |   4 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   3 +-
 sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c |  10 +-
 sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |  32 +-
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  13 +-
 sound/synth/emux/soundfont.c                       |  17 +-
 tools/power/x86/turbostat/turbostat.c              |   2 +-
 tools/testing/cxl/test/cxl.c                       |   4 +
 234 files changed, 2103 insertions(+), 1184 deletions(-)


