Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86AF430BA3;
	Sat, 28 Feb 2026 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300860; cv=none; b=HxvGJ0cNxNPOwXzh0EbHQv9vTL9uUaGmkh2Dz2oMYSKk8WAnbwtyFs78jJhfbpOhMmq8yLby3+t1NEq0BCNyO1Iw+PCqn9wf8GBd1+LYPjUKO2+jO4CWf4VZ7NF7dn7ehS4mn46QacJY32suiYdLtfW5TdtPkSUkI7+BFu6fFYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300860; c=relaxed/simple;
	bh=pIPkLozOioGwHQNAQSxl7jC6wjPcuhr0FZ+3Ss8KvKk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TBsmc6UvkT8xK9YHt6E/bZnf/UDx7mEhuYxyU3G8yw55YuOIQzvu1imlOsVTif3JblwJumeB/iBTyviXG0bsJBXezVr4aBrtBcUL+VY6KDXM4DWc1ZGDOxe+fzHXcmZFk1FlGaCuUnTucFSJ7GkVPMnYwYihAwMDlXIRaSEpM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOknz1Q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOknz1Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B08DC116D0;
	Sat, 28 Feb 2026 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300859;
	bh=pIPkLozOioGwHQNAQSxl7jC6wjPcuhr0FZ+3Ss8KvKk=;
	h=From:To:Cc:Subject:Date:From;
	b=nOknz1Q5S6ayxoaeoaOMTWPA6GbRGHBKMAKKPzHZU3fH343MeywSBkVuDm88RqT2q
	 w408RmTsSy8ozBnZrWQr2cn8o2HR0M3KoJaCkzB0IsqvixNQbt5b6GJE0jU463Ec3l
	 JMRoK6O4TxuiURrWa0N/gio4sIZV3NMb0qJOb2edrvxjaGHQYwFfJB6aGVuCwDG360
	 Jn60RI+NH4nAsR5imzdV/rKuU3iWQVUWNddHTLSMt9pFT+DraDNp5cC7+p2j+kaiRo
	 ntR3Del9x9WEWsr45LeESBafNNEpCrYhSIocYc3xAy4fmao3cpbmnrCdhPaYAqR+GE
	 Ae2raUSW3qsGg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	patches@lists.linux.dev,
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
Subject: [PATCH 6.18 000/752] 6.18.16-rc1 review
Date: Sat, 28 Feb 2026 12:47:35 -0500
Message-ID: <20260228174736.1542240-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.16-rc1
X-KernelTest-Deadline: 2026-03-02T17:46+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.18.16 release.
There are 752 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Mar  2 05:47:08 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Aaron Erhardt (1):
  ALSA: hda/hdmi: Add quirk for TUXEDO IBS14G6

Abdun Nihaal (2):
  media: i2c/tw9903: Fix potential memory leak in tw9903_probe()
  media: i2c/tw9906: Fix potential memory leak in tw9906_probe()

Abel Vesa (2):
  phy: qcom: edp: Make the number of clocks flexible
  arm64: dts: qcom: x1e80100: Add missing TCSR ref clock to the DP PHYs

Adarsh Das (1):
  btrfs: replace BUG() with error handling in __btrfs_balance()

Adrian Hunter (2):
  i3c: mipi-i3c-hci: Stop reading Extended Capabilities if capability ID
    is 0
  i3c: mipi-i3c-hci: Reset RING_OPERATION1 fields during init

Ai Chao (1):
  ACPI: resource: Add JWIPC JVC9100 to irq1_level_low_skip_override[]

Al Viro (1):
  ntfs: ->d_compare() must not block

Alain Volmat (3):
  media: stm32: dcmipp: avoid naming clock if only one is needed
  media: stm32: dcmipp: bytecap: clear all interrupts upon stream stop
  media: stm32: dcmipp: byteproc: disable compose for all bayers

Alan Maguire (1):
  kcsan, compiler_types: avoid duplicate type issues in BPF Type Format

Aleksandar Gerasimovski (1):
  phy: mvebu-cp110-utmi: fix dr_mode property read from dts

Alex Deucher (2):
  drm/amdgpu: avoid a warning in timedout job handler
  drm/amdgpu: keep vga memory on MacBooks with switchable graphics

Alex Hung (2):
  drm/amd/display: Fix writeback on DCN 3.2+
  drm/amd/display: Remove conditional for shaper 3DLUT power-on

Alex Williamson (1):
  PCI: Mark ASM1164 SATA controller to avoid bus reset

Alexander Aring (1):
  dlm: fix recovery pending middle conversion

Alexander Grest (1):
  iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency

Alexandre Courbot (1):
  rust: cpufreq: always inline functions using build_assert with
    arguments

Alexei Starovoitov (1):
  bpf: Recognize special arithmetic shift in the verifier

Alexey Charkov (1):
  arm64: dts: rockchip: Explicitly request UFS reset pin on RK3576

Alexey Klimov (1):
  gpu/panel-edp: add AUO panel entry for B140HAN06.4

Alexey Minnekhanov (1):
  arm64: dts: qcom: sdm630: Add missing MDSS reset

Alper Ak (2):
  media: rockchip: rga: Fix possible ERR_PTR dereference in
    rga_buf_init()
  media: qcom: camss: vfe: Fix out-of-bounds access in
    vfe_isr_reg_update()

Amelie Delaunay (1):
  dmaengine: stm32-dma3: use module_platform_driver

Andrea Scian (1):
  mtd: rawnand: pl353: Fix software ECC support

Andreas Gruenbacher (1):
  gfs2: fiemap page fault fix

Andreas Larsson (1):
  sparc: Synchronize user stack on fork and clone

Andrey Vatoropin (1):
  fbcon: check return value of con2fb_acquire_newinfo()

Andrii Nakryiko (1):
  procfs: fix possible double mmput() in do_procmap_query()

Anj Duvnjak (1):
  hwmon: (nct6683) Add customer ID for ASRock Z590 Taichi

Ankit Nautiyal (1):
  drm/i915/quirks: Fix device id for QUIRK_EDP_LIMIT_RATE_HBR2 entry

Ankit Soni (2):
  iommu/amd: move wait_on_sem() out of spinlock
  iommu/amd: serialize sequence allocation under concurrent TLB
    invalidations

Anthony Iliopoulos (1):
  nfsd: fix return error code for nfsd_map_name_to_[ug]id

Anthony Pighin (Nokia) (1):
  rtc: interface: Alarm race handling should not discard preceding error

Anton Protopopov (1):
  bpf: Properly mark live registers for indirect jumps

Antoniu Miclaus (1):
  iio: gyro: itg3200: Fix unchecked return value in read_raw

Ard Biesheuvel (1):
  x86/kexec: Copy ACPI root pointer address from config table

Armin Wolf (2):
  ACPICA: Abort AML bytecode execution when executing AML_FATAL_OP
  hwmon: (dell-smm) Add support for Dell OptiPlex 7080

Arnaldo Carvalho de Melo (1):
  perf annotate: Fix BUILD_NONDISTRO=1 missing args->ms conversions to
    pointer

Arnd Bergmann (4):
  vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
  myri10ge: avoid uninitialized variable use
  scsi: buslogic: Reduce stack usage
  arm64: hugetlbpage: avoid unused-but-set-parameter warning (gcc-16)

Artem Shimko (1):
  serial: 8250_dw: handle clock enable errors in runtime_resume

Asad Kamal (1):
  drm/amdgpu/ras: Move ras data alloc before bad page check

Asbjørn Sloth Tønnesen (1):
  io_uring/cmd_net: fix too strict requirement on ioctl

Ata İlhan Köktürk (1):
  ACPI: battery: fix incorrect charging status when current is zero

Balasubramani Vivekanandan (1):
  drm/xe/xe3_lpg: Apply Wa_16028005424

Baochen Qiang (2):
  wifi: ath12k: fix preferred hardware mode calculation
  wifi: ath12k: fix mac phy capability parsing

Baojun Xu (1):
  ALSA: hda/tas2781: Ignore reset check for SPI device

Baokun Li (1):
  ext4: move ext4_percpu_param_init() before ext4_mb_init()

Bard Liao (1):
  ASoC: soc-acpi-intel-arl-match: change rt722 amp endpoint to
    aggregated

Bartosz Golaszewski (4):
  clocksource/drivers/timer-integrator-ap: Add missing Kconfig
    dependency on OF
  pinctrl: meson: amlogic-a4: mark the GPIO controller as sleeping
  reset: gpio: suppress bind attributes in sysfs
  gpio: sysfs: fix chip removal with GPIOs exported over sysfs

Bastien Nocera (1):
  HID: logitech-hidpp: Add support for Logitech K980

Benjamin Gaignard (4):
  media: verisilicon: AV1: Fix enable cdef computation
  media: verisilicon: AV1: Fix tx mode bit setting
  media: verisilicon: AV1: Set IDR flag for intra_only frame type
  media: verisilicon: AV1: Fix tile info buffer size

Benjamin Marzinski (1):
  dm mpath: make pg_init_delay_msecs settable

Benno Lossin (2):
  rust: irq: add `'static` bounds to irq callbacks
  rust: pin-init: replace clippy `expect` with `allow`

Benson Leung (1):
  usb: typec: ucsi: psy: Fix voltage and current max for non-Fixed PDOs

Bharat Dev Burman (1):
  ALSA: hda/realtek: add HP Victus 16-e0xxx mute LED quirk

Bhavik Sachdev (1):
  statmount: permission check should return EPERM

Biju Das (1):
  clk: renesas: rzg2l: Deassert reset on assert timeout

Billy Tsai (1):
  gpio: aspeed-sgpio: Change the macro to support deferred probe

Bing Jiao (1):
  mm/vmscan: fix demotion targets checks in reclaim/demotion

Bingbu Cao (6):
  media: ipu6: Fix typo and wrong constant in ipu6-mmu.c
  media: ipu6: Fix RPM reference leak in probe error paths
  media: staging/ipu7: Ignore interrupts when device is suspended
  media: staging/ipu7: Call synchronous RPM suspend in probe failure
  media: staging/ipu7: Update CDPHY register settings
  media: staging/ipu7: Fix the loop bound in l2 table alloc

Bitterblue Smith (3):
  wifi: rtw88: 8822b: Avoid WARNING in rtw8822b_config_trx_mode()
  wifi: rtw88: Use devm_kmemdup() in rtw_set_supported_band()
  wifi: rtw88: Fix inadvertent sharing of struct
    ieee80211_supported_band data

Bjorn Andersson (1):
  regulator: core: Remove regulator supply_name length limit

Bluecross (1):
  Bluetooth: btusb: Add support for MediaTek7920 0489:e158

Bo Sun (1):
  octeontx2-af: CGX: fix bitmap leaks

Boris Brezillon (1):
  drm/panthor: Always wait after sending a command to an AS

Borislav Petkov (AMD) (1):
  x86/sev: Use kfree_sensitive() when freeing a SNP message descriptor

Brandon Brnich (2):
  media: chips-media: wave5: Fix conditional in start_streaming
  media: chips-media: wave5: Process ready frames when CMD_STOP sent to
    Encoder

Breno Leitao (2):
  arm64: Disable branch profiling for all arm64 code
  uprobes: Fix incorrect lockdep condition in filter_chain()

Brian Howard (1):
  HID: multitouch: add quirks for Lenovo Yoga Book 9i

Brian Masney (2):
  openrisc: define arch-specific version of nop()
  clk: microchip: core: correct return value on *_get_parent()

Brian Norris (1):
  PCI/PM: Prevent runtime suspend until devices are fully initialized

Carl Lee (1):
  nfc: nxp-nci: remove interrupt trigger type

Carlos López (1):
  mshv: clear eventfd counter on irqfd shutdown

Carlos Song (1):
  i2c: imx-lpi2c: fix SMBus block read NACK after byte count

Ce Sun (1):
  drm/amdgpu: Adjust usleep_range in fence wait

Charlene Liu (2):
  drm/amd/display: Fix dsc eDP issue
  drm/amd/display: Correct logic check error for fastboot

Chen Ni (2):
  ASoC: sunxi: sun50i-dmic: Add missing check for devm_regmap_init_mmio
  ASoC: codecs: max98390: Check return value of
    devm_gpiod_get_optional() in max98390_i2c_probe()

Chen-Yu Tsai (1):
  dmaengine: sun6i: Choose appropriate burst length under maxburst

Chenghai Huang (1):
  crypto: hisilicon/qm - move the barrier before writing to the mailbox
    register

Chia-I Wu (1):
  drm/panthor: fix for dma-fence safe access rules

Chih-Kang Chang (2):
  wifi: rtw89: setting TBTT AGG number when mac port initialization
  wifi: rtw89: mcc: reset probe counter when receiving beacon

Chin-Ting Kuo (1):
  spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end

Chin-Yen Lee (1):
  wifi: rtw89: wow: add reason codes for disassociation in WoWLAN mode

Chris Brandt (2):
  clk: renesas: rzg2l: Fix intin variable size
  clk: renesas: rzg2l: Select correct div round macro

Christian Brauner (1):
  fs: ensure that internal tmpfs mount gets mount id zero

Christoph Hellwig (1):
  xfs: remove xfs_attr_leaf_hasname

Chuan Liu (1):
  clk: amlogic: remove potentially unsafe flags from S4 video clocks

Clay King (1):
  drm/amd/display: bypass post csc for additional color spaces in dal

Clint George (1):
  kselftest/kublk: include message in _Static_assert for C11
    compatibility

Clément Le Goffic (1):
  dmaengine: stm32-mdma: initialize m2m_hw_period and ccr to fix
    warnings

Colin Lord (1):
  tracing: Fix false sharing in hwlat get_sample()

Cosmin Tanislav (1):
  pinctrl: renesas: rzt2h: Allow .get_direction() for IRQ function GPIOs

Cui Chao (1):
  mm: numa_memblks: Identify the accurate NUMA ID of CFMW

Cupertino Miranda (1):
  bpf: verifier improvement in 32bit shift sign extension pattern

Damien Dagorn (1):
  ALSA: hda/realtek: fix LG Gram Style 14 speakers

Daniel Gomez (1):
  dm: replace -EEXIST with -EBUSY

Daniel Hodges (1):
  tipc: fix RCU dereference race in tipc_aead_users_dec()

Daniel Palmer (1):
  m68k: nommu: fix memmove() with differently aligned src and dest for
    68000

Daniel Peng (1):
  HID: i2c-hid: Add FocalTech FT8112

Daniel Tang (1):
  powercap: intel_rapl: Add PL4 support for Ice Lake

Daniil Dulov (1):
  ring-buffer: Fix possible dereference of uninitialized pointer

Darrick J. Wong (9):
  xfs: mark data structures corrupt on EIO and ENODATA
  xfs: delete attr leaf freemap entries when empty
  xfs: fix freemap adjustments when adding xattrs to leaf blocks
  xfs: fix the xattr scrub to detect freemap/entries array collisions
  xfs: fix remote xattr valuelblk check
  xfs: get rid of the xchk_xfile_*_descr calls
  xfs: only call xf{array,blob}_destroy if we have a valid pointer
  xfs: check return value of xchk_scrub_create_subord
  xfs: check for deleted cursors when revalidating two btrees

David LaPorte (1):
  mtd: spinand: Disable continuous read during probe

David Phillips (1):
  HID: elecom: Add support for ELECOM HUGE Plus M-HT1MRBK

David Plowman (3):
  media: i2c: ov5647: Correct pixel array offset
  media: i2c: ov5647: Correct minimum VBLANK value
  media: i2c: ov5647: Sensor should report RAW color space

David Woodhouse (1):
  ptp: ptp_vmclock: add 'VMCLOCK' to ACPI device match

Deepak Kumar (1):
  spi: stm32: fix Overrun issue at < 8bpw

Deepakkumar Karn (1):
  fs/buffer: add alert in try_to_free_buffers() for folios without
    buffers

Deepanshu Kartikey (1):
  mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

Denis Pauk (1):
  hwmon: (nct6775) Add ASUS Pro WS WRX90E-SAGE SE

Derek J. Clark (1):
  iio: bmi270_i2c: Add MODULE_DEVICE_TABLE for BMI260/270

Dian-Syuan Yang (1):
  wifi: rtw89: pci: restore LDO setting after device resume

Diksha Kumari (1):
  staging: rtl8723bs: fix memory leak on failure path

Dikshita Agarwal (6):
  media: venus: vdec: restrict EOS addr quirk to IRIS2 only
  Revert "media: iris: Add sanity check for stop streaming"
  media: iris: Add buffer to list only after successful allocation
  media: iris: Skip resolution set on first IPSC
  media: iris: gen1: Destroy internal buffers after FW releases
  media: iris: gen2: Add sanity check for session stop

Dillon Varone (1):
  drm/amd/display: Guard FAMS2 configuration updates

Ding Hui (1):
  dm: remove fake timeout to avoid leak request

Diogo Ivo (1):
  arm64: tegra: smaug: Add usb-role-switch support

Dipayaan Roy (1):
  net: mana: Fix double destroy_workqueue on service rescan PCI path

Dirk Behme (1):
  drm/tyr: fix register name in error print

Dmitry Torokhov (1):
  net: phy: qcom: qca807x: normalize return value of gpio_get

Dmytro Laktyushkin (2):
  drm/amd/display: Add signal type check for dcn401 get_phyd32clk_src
  drm/amd/display: only power down dig on phy endpoints

Donet Tom (2):
  drm/amdkfd: Relax size checking during queue buffer get
  drm/amdkfd: Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()

Douglas Anderson (1):
  mfd: core: Add locking around 'mfd_of_node_list'

Duoming Zhou (2):
  net: wan: farsync: Fix use-after-free bugs caused by unfinished
    tasklets
  atm: fore200e: fix use-after-free in tasklets during device removal

Emanuele Ghidoli (1):
  power: reset: tdx-ec-poweroff: fix restart

Eric Biggers (2):
  dm-verity: correctly handle dm_bufio_client_create() failure
  dm: fix excessive blk-crypto operations for invalid keys

Eric Dumazet (9):
  ipv6: annotate data-races in ip6_multipath_hash_{policy,fields}()
  ipv6: annotate data-races over sysctl.flowlabel_reflect
  ipv6: annotate data-races in net/ipv6/route.c
  ipv6: exthdrs: annotate data-race over multiple sysctl
  gro: change the BUG_ON() in gro_pull_from_frag0()
  ipv4: igmp: annotate data-races around idev->mr_maxdelay
  tcp: fix potential race in tcp_v6_syn_recv_sock()
  psp: use sk->sk_hash in psp_write_headers()
  net: do not pass flow_id to set_rps_cpu()

Erik Sanjaya (1):
  ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14 UX3405MA

Ethan Nelson-Moore (3):
  net: usb: sr9700: remove code to drive nonexistent multicast filter
  net: ethernet: marvell: skge: remove incorrect conflicting PCI ID
  net: intel: fix PCI device ID conflict between i40e and ipw2200

Ethan Tidmore (3):
  proc: Fix pointer error dereference
  staging: rtl8723bs: fix null dereference in find_network
  gpio: nomadik: Add missing IS_ERR() check

Eugenio Pérez (1):
  vhost: move vdpa group bound check to vhost_vdpa

Evangelos Petrongonas (1):
  kho: skip memoryless NUMA nodes when reserving scratch areas

Ezrak1e (1):
  dlm: validate length in dlm_search_rsb_tree

Fabian Godehardt (1):
  spi: spidev: fix lock inversion between spi_lock and buf_lock

Felix Gu (4):
  hwmon: (emc2305) Fix a resource leak in emc2305_of_parse_pwm_child
  hwmon: (nct7363) Fix a resource leak in nct7363_present_pwm_fanin
  misc: ti_fpc202: fix a potential memory leak in probe function
  dpll: zl3073x: Remove redundant cleanup in devm_dpll_init()

Florian Westphal (1):
  netfilter: xt_tcpmss: check remaining length before reading optlen

Francesco Dolcini (1):
  arm64: dts: ti: am62p-verdin: Fix SD regulator startup delay

Francesco Lavra (1):
  iio: accel: adxl380: Avoid reading more entries than present in FIFO

Frank Li (1):
  i3c: master: svc: Initialize 'dev' to NULL in svc_i3c_master_ibi_isr()

Gangliang Xie (1):
  drm/amdgpu: return when ras table checksum is error

Gao Xiang (3):
  erofs: fix interlaced plain identification for encoded extents
  erofs: fix incorrect early exits for invalid metabox-enabled images
  erofs: fix incorrect early exits in volume label handling

Geetha sowjanya (1):
  octeontx2-af: Workaround SQM/PSE stalls by disabling sticky

Gerd Rausch (1):
  net/rds: No shortcut out of RDS_CONN_ERROR

Greg Kroah-Hartman (1):
  driver core: faux: stop using static struct device

Guangshuo Li (1):
  powerpc/smp: Add check for kcalloc() failure in parse_thread_groups()

Gui-Dong Han (1):
  rpmsg: core: fix race in driver_override_show() and use core helper

Gustavo Salvini (1):
  ASoC: amd: yc: Add DMI quirk for ASUS Vivobook Pro 15X M6501RR

Günther Noack (3):
  HID: magicmouse: Do not crash on missing msc->input
  HID: prodikeys: Check presence of pm->input_ep82
  HID: logitech-hidpp: Check maxfield in hidpp_get_report_length()

Hangbin Liu (2):
  net: add a common function to compute features for upper devices
  team: use common function to compute the features

Hans Verkuil (4):
  media: dvb-core: dmxdevfilter must always flush bufs
  media: omap3isp: isp_video_mbus_to_pix/pix_to_mbus fixes
  media: omap3isp: isppreview: always clamp in preview_try_format()
  media: omap3isp: set initial format

Hans de Goede (10):
  drm/panel: edp: add BOE NV140WUM-T08 panel
  media: mt9m114: Avoid a reset low spike during probe()
  media: mt9m114: Return -EPROBE_DEFER if no endpoint is found
  media: i2c: ov01a10: Fix the horizontal flip control
  media: i2c: ov01a10: Fix reported pixel-rate value
  media: i2c: ov01a10: Fix analogue gain range
  media: i2c: ov01a10: Add missing v4l2_subdev_cleanup() calls
  media: i2c: ov01a10: Fix passing stream instead of pad to
    v4l2_subdev_state_get_format()
  media: i2c: ov01a10: Fix test-pattern disabling
  fbdev: Use device_create_with_groups() to fix sysfs groups
    registration race

Haotian Zhang (1):
  jfs: Add missing set_freezable() for freezable kthread

Haotien Hsu (1):
  usb: gadget: tegra-xudc: Add handling for BLCG_COREPLL_PWRDN

Haoxiang Li (12):
  PCI/MSI: Unmap MSI-X region on error
  firmware: arm_ffa: Unmap Rx/Tx buffers on init failure
  media: cx25821: Fix a resource leak in cx25821_dev_setup()
  media: mtk-mdp: Fix error handling in probe function
  media: mtk-mdp: Fix a reference leak bug in mtk_mdp_remove()
  media: cx88: Add missing unmap in snd_cx88_hw_params()
  media: cx23885: Add missing unmap in snd_cx23885_hw_params()
  media: cx25821: Add missing unmap in snd_cx25821_hw_params()
  clk: tegra: tegra124-emc: Fix potential memory leak in
    tegra124_clk_register_emc()
  bus: fsl-mc: fix an error handling in fsl_mc_device_add()
  rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()
  parisc: kernel: replace kfree() with put_device() in
    create_tree_node()

Harry Yoo (4):
  mm/slab: avoid allocating slabobj_ext array from its own slab
  mm/slab: use unsigned long for orig_size to ensure proper metadata
    align
  mm/slab: do not access current->mems_allowed_seq if !allow_spin
  mm/page_alloc: skip debug_check_no_{obj,locks}_freed with FPI_TRYLOCK

Harshit Mogalapalli (3):
  ima: verify the previous kernel's IMA buffer lies in addressable RAM
  of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
  x86/kexec: add a sanity check on previous kernel's ima kexec buffer

Heiko Carstens (2):
  s390/boot: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS
  s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS

Heinz Mauelshagen (1):
  md raid: fix hang when stopping arrays with metadata through dm-raid

Helge Deller (1):
  parisc: Prevent interrupts during reboot

Heming Zhao (1):
  ocfs2: fix reflink preserve cleanup issue

Henrique Carvalho (2):
  smb: client: add proper locking around ses->iface_last_update
  smb: client: prevent races in ->query_interfaces()

Henry Tseng (1):
  ata: libata: avoid long timeouts on hot-unplugged SATA DAS

Himal Prasad Ghimiray (1):
  drm/xe/vm: Skip ufence association for CPU address mirror VMA during
    MAP

Hou Wenlong (1):
  x86/xen/pvh: Enable PAE mode for 32-bit guest only when CONFIG_X86_PAE
    is set

Hsieh Hung-En (1):
  ASoC: es8328: Add error unwind in resume

Hsiu-Ming Chang (1):
  wifi: rtw88: rtw8821cu: Add ID for Mercusys MU6H

Huacai Chen (1):
  LoongArch: Prefer top-down allocation after arch_mem_init()

Hugo Villeneuve (1):
  drm: renesas: rz-du: mipi_dsi: fix kernel panic when rebooting for
    some panels

Hyunwoo Kim (2):
  espintcp: Fix race condition in espintcp_close()
  tls: Fix race condition in tls_sw_cancel_work_tx()

Håkon Bugge (1):
  net/rds: Clear reconnect pending bit

Ian Rogers (9):
  perf test stat: Update test expectations and events
  perf unwind-libdw: Fix invalid reference counts
  perf callchain: Fix srcline printing with inlines
  perf symbol-elf: Fix leak of ELF files with GNU debugdata
  perf annotate: Fix args leak of map_symbol
  perf maps: Fix reference count leak in maps__find_ams()
  perf tests sched: Avoid error in cleanup on loaded machines
  perf build: Remove NO_LIBCAP that controls nothing
  libperf build: Always place libperf includes first

Ihor Solodrai (1):
  bpftool: Fix dependencies for static build

Ilan Peer (1):
  wifi: iwlwifi: mld: Handle rate selection for NAN interface

Illia Barbashyn (1):
  ALSA: hda/realtek - Enable mute LEDs on HP ENVY x360 15-es0xxx

Ilpo Järvinen (5):
  PCI/bwctrl: Disable BW controller on Intel P45 using a quirk
  mfd: intel-lpss: Add Intel Nova Lake-S PCI IDs
  PCI: Use resource_set_range() that correctly sets ->end
  PCI: Fix bridge window alignment with optional resources
  PCI: Don't claim disabled bridge windows

Ilya Dryomov (1):
  libceph: define and enforce CEPH_MAX_KEY_LEN

Imran Khan (1):
  genirq/cpuhotplug: Notify about affinity changes breaking the affinity
    mask

Irui Wang (1):
  media: mediatek: encoder: Fix uninitialized scalar variable issue

Iuliana Prodan (1):
  remoteproc: imx_dsp_rproc: Skip RP_MBOX_SUSPEND_SYSTEM when mailbox TX
    channel is uninitialized

Ivan Vecera (3):
  dpll: zl3073x: Cache reference monitor status
  dpll: zl3073x: Cache all reference properties in zl3073x_ref
  dpll: zl3073x: fix REF_PHASE_OFFSET_COMP register width for some chip
    IDs

Jack Wang (1):
  md/bitmap: fix GPF in write_page caused by resize race

Jack Yu (1):
  ASoC: rt721-sdca: Fix issue of fail to detect OMTP jack type

Jackson Lee (2):
  media: chips-media: wave5: Fix SError of kernel panic when closed
  media: chips-media: wave5: Fix Null reference while testing fluster

Jacky Bai (1):
  mailbox: imx: Skip the suspend flag for i.MX7ULP

Jacob Moroni (1):
  RDMA/umem: Fix double dma_buf_unpin in failure path

Jacopo Scannella (1):
  Bluetooth: btusb: Add device ID for Realtek RTL8761BU

Jaehun Gou (3):
  fs: ntfs3: check return value of indx_find to avoid infinite loop
  fs: ntfs3: fix infinite loop in attr_load_runs_range on inconsistent
    metadata
  fs: ntfs3: fix infinite loop triggered by zero-sized ATTR_LIST

Jai Luthra (2):
  media: i2c: ov5647: Initialize subdev before controls
  media: i2c: ov5647: Fix PIXEL_RATE value for VGA mode

Jakob Riemenschneider (1):
  ACPI: x86: s2idle: Invoke Microsoft _DSM Function 9 (Turn On Display)

Jakub Kicinski (2):
  netconsole: avoid OOB reads, msg is not nul-terminated
  net: consume xmit errors of GSO frames

James Clark (1):
  perf cs-etm: Fix decoding for sparse CPU maps

Jan Remmet (1):
  gpio: pca953x: Add support for TCAL6408 TCAL6416

Janne Grunau (4):
  arm64: dts: apple: t8112-j473: Keep the HDMI port powered on
  clk: clk-apple-nco: Add "apple,t8103-nco" compatible
  mfd: macsmc: Initialize mutex
  spmi: apple: Add "apple,t8103-spmi" compatible

Jason Andryuk (1):
  xenbus: Use .freeze/.thaw to handle xenbus devices

Jason Gunthorpe (4):
  RDMA/efa: Fix typo in efa_alloc_mr()
  iommu/arm-smmu-v3: Add update_safe bits to fix STE update sequence
  iommu/arm-smmu-v3: Mark STE MEV safe when computing the update
    sequence
  iommu/arm-smmu-v3: Mark EATS_TRANS safe when computing the update
    sequence

Jeffrey Bencteux (2):
  audit: add fchmodat2() to change attributes class
  audit: add missing syscalls to read class

Jens Axboe (4):
  io_uring/timeout: annotate data race in io_flush_timeouts()
  io_uring/net: don't continue send bundle if poll was required for
    retry
  io_uring/filetable: clamp alloc_hint to the configured alloc range
  io_uring/openclose: fix io_pipe_fixed() slot tracking for specific
    slots

Jesse.Zhang (1):
  drm/amdgpu: validate user queue size constraints

Ji-Ze Hong (Peter Hong) (1):
  hwmon: (f71882fg) Add F81968 support

Jia Yao (1):
  drm/xe: Add bounds check on pat_index to prevent OOB kernel read in
    madvise

Jianbo Liu (1):
  net/mlx5e: Fix "scheduling while atomic" in IPsec MAC address query

Jiasheng Jiang (1):
  md-cluster: fix NULL pointer dereference in process_metadata_update

Jiaxun Yang (1):
  MIPS: rb532: Fix MMIO UART resource registration

Jiayuan Chen (2):
  xfrm6: fix uninitialized saddr in xfrm6_get_saddr()
  kcm: fix zero-frag skb in frag_list on partial sendmsg error

Jijie Shao (1):
  net: hns3: extend HCLGE_FD_AD_QID to 11 bits

Jing Zhou (1):
  drm/amd/display: Correct FIXED_VS Link Rate Toggle Condition

Jinhui Guo (2):
  iommu/vt-d: Flush dev-IOTLB only when PCIe device is accessible in
    scalable mode
  PCI: Fix pci_slot_trylock() error handling

Jinqian Yang (1):
  arm64: Add support for TSV110 Spectre-BHB mitigation

Jinwang Li (1):
  Bluetooth: hci_qca: Cleanup on all setup failures

Jiri Olsa (1):
  arm64/ftrace,bpf: Fix partial regs after bpf_prog_run

Jiri Pirko (2):
  dma-mapping: avoid random addr value print out on error path
  RDMA/core: Fix stale RoCE GIDs during netdev events at registration

Jisheng Zhang (1):
  usb: dwc2: fix resume failure if dr_mode is host

Joe Damato (1):
  bnxt_en: Allow ntuple filters for drops

Joel Fernandes (1):
  sched/debug: Fix updating of ppos on server write ops

Joey Bednar (1):
  HID: apple: Add "SONiX KN85 Keyboard" to the list of non-apple
    keyboards

Joey Gouly (1):
  arm64: poe: fix stale POR_EL0 values for ptrace

Johan Hovold (5):
  soc: ti: k3-socinfo: Fix regmap leak on probe failure
  bus: omap-ocp2scp: fix OF populate on driver rebind
  mfd: qcom-pm8xxx: Fix OF populate on driver rebind
  mfd: omap-usb-host: Fix OF populate on driver rebind
  mux: mmio: fix regmap leak on probe failure

Johannes Berg (2):
  wifi: iwlwifi: fix 22000 series SMEM parsing
  wifi: cfg80211: wext: fix IGTK key ID off-by-one

John Garry (2):
  MIPS: Loongson: Make cpumask_of_node() robust against NUMA_NO_NODE
  LoongArch: Make cpumask_of_node() robust against NUMA_NO_NODE

John Keeping (1):
  rtc: pcf8563: use correct of_node for output clock

Johnny-CC Chang (1):
  PCI: Mark Nvidia GB10 to avoid bus reset

Jonathan Marek (2):
  spi-geni-qcom: initialize mode related registers to 0
  spi-geni-qcom: use xfer->bits_per_word for can_dma()

Joonwon Kang (1):
  mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()

Jori Koolstra (2):
  minix: Add required sanity checking to minix_check_superblock()
  jfs: nlink overflow in jfs_rename

Jose Ignacio Tornos Martinez (1):
  wifi: rtw89: 8922a: set random mac if efuse contains zeroes

Joshua Hahn (1):
  mm/hugetlb: restore failed global reservations to subpool

Jouni Högander (1):
  drm/i915/psr: Don't enable Panel Replay on sink if globally disabled

Jun Yan (1):
  arm64: dts: rockchip: Do not enable hdmi_sound node on Pinebook Pro

Junrui Luo (1):
  dpaa2-switch: validate num_ifs to prevent out-of-bounds write

Kai Aizen (1):
  io_uring/zcrx: fix user_ref race between scrub and refill paths

Kamal Heib (1):
  RDMA/ionic: Fix potential NULL pointer dereference in ionic_query_port

Kaushlendra Kumar (3):
  tools/cpupower: Fix inverted APERF capability check
  tools/power cpupower: Reset errno before strtoull()
  thermal: int340x: Fix sysfs group leak on DLVR registration failure

Kees Cook (1):
  media: solo6x10: Check for out of bounds chip_id

Keita Morisaki (1):
  scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale() trace
    event

Keith Busch (1):
  PCI: Fix pci_slot_lock () device locking

Kevin Hao (4):
  net: cpsw_new: Fix unnecessary netdev unregistration in cpsw_probe()
    error path
  net: cpsw_new: Fix potential unregister of netdev that has not been
    registered yet
  net: ti: icssg-prueth: Add optional dependency on HSR
  net: macb: Fix tx/rx malfunction after phy link down and up

Koichiro Den (1):
  NTB: ntb_transport: Fix too small buffer for debugfs_name

Kommula Shiva Shankar (1):
  vhost: fix caching attributes of MMIO regions by setting them
    explicitly

Konrad Dybcio (1):
  cpufreq: dt-platdev: Block the driver from probing on more QC
    platforms

Konstantin Komarov (2):
  fs/ntfs3: drop preallocated clusters for sparse and compressed files
  fs/ntfs3: avoid calling run_get_entry() when run == NULL in
    ntfs_read_run_nb_ra()

Kory Maincent (TI.com) (1):
  mfd: tps65219: Implement LOCK register handling for TPS65214

Krishna Chaitanya Chundru (1):
  PCI: Add ACS quirk for Qualcomm Hamoa & Glymur

Krzysztof Kozlowski (2):
  arm64: dts: qcom: sm8750: Fix BAM DMA probing
  nvmem: Drop OF node reference on nvmem_add_one_cell() failure

Kuan-Chung Chen (1):
  wifi: rtw89: fix potential zero beacon interval in beacon tracking

Kuniyuki Iwashima (3):
  ipv4: fib: Annotate access to struct fib_alias.fa_state.
  ipv6: Move ipv6_fl_list from ipv6_pinfo to inet_sock.
  udplite: Fix null-ptr-deref in __udp_enqueue_schedule_skb().

Leo Li (1):
  drm/amd/display: Increase DCN35 SR enter/exit latency

Leo Yan (2):
  tools headers: Go back to include asm-generic/unistd.h for arm64
  tools: Fix bitfield dependency failure

Leon Romanovsky (1):
  xfrm: skip templates check for packet offload tunnel mode

Li Chen (3):
  ext4: mark group add fast-commit ineligible
  ext4: mark group extend fast-commit ineligible
  kexec: derive purgatory entry from symbol

Li Wang (1):
  selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs

Liang Jie (2):
  staging: rtl8723bs: fix missing status update on sdio_alloc_irq()
    failure
  pinctrl: mediatek: make devm allocations safer and clearer in
    mtk_eint_do_init()

Lianqin Hu (1):
  ALSA: usb-audio: Add iface reset and delay quirk for AB13X USB Audio

Lijo Lazar (1):
  drm/amdgpu: Skip vcn poison irq release on VF

Likun Gao (1):
  drm/amdgpu: fix NULL pointer issue buffer funcs

Lili Li (1):
  EDAC/igen6: Add more Intel Panther Lake-H SoCs support

LinCheng Ku (1):
  drm/amd/display: Add USB-C DP Alt Mode lane limitation in DCN32

Linus Torvalds (1):
  Remove WARN_ALL_UNSEEDED_RANDOM kernel config option

Linus Walleij (1):
  net: ethernet: xscale: Check for PTP support properly

Lizhi Hou (1):
  accel/amdxdna: Fix tail-pointer polling in mailbox_get_msg()

Loic Poulain (1):
  drm/bridge: anx7625: Fix invalid EDID size

Longfang Liu (3):
  hisi_acc_vfio_pci: resolve duplicate migration states
  hisi_acc_vfio_pci: fix the queue parameter anomaly issue
  hisi_acc_vfio_pci: update status after RAS error

Luca Ceresoli (1):
  drm: of: drm_of_panel_bridge_remove(): fix device_node leak

Ludovic Desroches (3):
  drm/atmel-hlcdc: fix memory leak from the atomic_destroy_state
    callback
  drm/atmel-hlcdc: don't reject the commit if the src rect has
    fractional parts
  drm/atmel-hlcdc: fix use-after-free of drm_crtc_commit after release

Luiz Augusto von Dentz (5):
  Bluetooth: L2CAP: Fix invalid response to L2CAP_ECRED_RECONF_REQ
  Bluetooth: L2CAP: Fix result of L2CAP_ECRED_CONN_RSP when MTU is too
    short
  Bluetooth: L2CAP: Fix response to L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix not checking output MTU is acceptable on
    L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix missing key size check for L2CAP_LE_CONN_REQ

Lukas Wunner (1):
  PCI/AER: Clear stale errors on reporting agents upon probe

Luke Wang (1):
  block: decouple secure erase size limit from discard size limit

Lyude Paul (1):
  rust/drm: Fix Registration::{new,new_foreign_owned}() docs

Maciej Grochowski (2):
  ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
  ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut

Maciej Strozek (1):
  soundwire: intel_auxdevice: add cs42l45 codec to wake_capable_list

Magnus Lindholm (1):
  alpha: fix user-space corruption during memory compaction

Manikanta Maddireddy (1):
  PCI: endpoint: Fix swapped parameters in
    pci_{primary/secondary}_epc_epf_unlink() functions

Manivannan Sadhasivam (2):
  PCI: dwc: Skip PME_Turn_Off broadcast and L2/L3 transition during
    suspend if link is not up
  PCI: Enable ACS after configuring IOMMU for OF platforms

Marc Zyngier (1):
  arm64: Force the use of CNTVCT_EL0 in __delay()

Marco Elver (1):
  arm64: Fix non-atomic __READ_ONCE() with CONFIG_LTO=y

Marcus Folkesson (1):
  Revert "mfd: da9052-spi: Change read-mask to write-mask"

Marek Behún (1):
  net: sfp: add quirk for Lantech 8330-265D

Marek Szyprowski (1):
  wifi: brcmfmac: Fix potential kernel oops when probe fails

Marek Vasut (1):
  clk: rs9: Reserve 8 struct clk_hw slots for for 9FGV0841

Mario Peter (1):
  usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()

Mark Brown (2):
  spi: cadence-quadspi: Parse DT for flashes with the rest of the DT
    parsing
  mailbox: pcc: Remove spurious IRQF_ONESHOT usage

Markus Perkins (1):
  misc: eeprom: Fix EWEN/EWDS/ERAL commands for 93xx56 and 93xx66

Martin Pålsson (1):
  net: usb: lan78xx: scan all MDIO addresses on LAN7801

Martin Schiller (3):
  perf/x86/msr: Add Airmont NP
  perf/x86/cstate: Add Airmont NP
  perf/x86/intel: Add Airmont NP

Masami Hiramatsu (Google) (3):
  tracing: Fix to set write permission to per-cpu buffer_size_kb
  tracing: Reset last_boot_info if ring buffer is reset
  tracing: ring-buffer: Fix to check event length before using

Matt Johnston (1):
  ipmi: ipmb: initialise event handler read bytes

Matt Roper (1):
  drm/xe/ggtt: Use scope-based runtime pm

Matt Whitlock (1):
  dm-unstripe: fix mapping bug when there are multiple targets in a
    table

Matthew Brost (2):
  drm/xe: Covert return of -EBUSY to -ENOMEM in VM bind IOCTL
  drm/xe: Only toggle scheduling in TDR if GuC is running

Matthew Stewart (1):
  drm/amd/display: Fix GFX12 family constant checks

Matthieu Baerts (NGI0) (1):
  mptcp: pm: in-kernel: always set ID as avail when rm endp

Mauro Carvalho Chehab (5):
  EFI/CPER: don't dump the entire memory region
  APEI/GHES: ensure that won't go past CPER allocated record
  APEI/GHES: ARM processor Error: don't go past allocated memory
  EFI/CPER: don't go past the ARM processor CPER record buffer
  docs: kdoc: avoid error_count overflows

Md Haris Iqbal (2):
  rnbd-srv: Zero the rsp buffer before using it
  RDMA/rtrs-clt: For conn rejection use actual err number

Mehdi Ben Hadj Khelifa (1):
  hfsplus: ensure sb->s_fs_info is always cleaned up

Mehdi Djait (1):
  media: i2c: ov01a10: Fix digital gain range

Michael Liang (1):
  dm: clear cloned request bio pointer when last clone bio completes

Michael Thalmeier (1):
  net: nfc: nci: Fix parameter validation for packet data

Michal Pecio (1):
  media: uvcvideo: Return queued buffers on start_streaming() failure

Mickaël Salaün (1):
  kbuild: Fix CC_CAN_LINK detection

Miguel Ojeda (1):
  rust: kbuild: pass `-Zunstable-options` for Rust 1.95.0

Mikhail Gavrilov (1):
  mm/page_alloc: clear page->private in free_pages_prepare()

Mikulas Patocka (2):
  dm-integrity: fix a typo in the code for write/discard race
  dm-integrity: fix recalculation in bitmap mode

Ming Qian (2):
  media: amphion: Clear last_buffer_dequeued flag for DEC_CMD_START
  media: amphion: Drop min_queued_buffers assignment

Mingj Ye (1):
  net: usb: r8152: fix transmit queue timeout

Miquel Raynal (1):
  spi: spi-mem: Limit octal DTR constraints to octal DTR situations

Miquel Raynal (Schneider Electric) (1):
  spi: cadence-qspi: Try hard to disable the clocks

Miri Korenblit (3):
  wifi: cfg80211: allow only one NAN interface, also in multi radio
  wifi: iwlwifi: mvm: check the validity of noa_len
  wifi: iwlwifi: mld: fix chandef start calculation

Moteen Shah (2):
  serial: 8250: 8250_omap.c: Add support for handling UART error
    conditions
  serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA
    termination is done

Nam Cao (1):
  powerpc/pseries: Fix MSI-X allocation failure when quota is exceeded

Namhyung Kim (2):
  perf tools: Get debug info of DSO properly
  perf/core: Fix slow perf_event_task_exit() with LBR callstacks

Naohiro Aota (2):
  btrfs: zoned: fixup last alloc pointer after extent removal for RAID1
  btrfs: zoned: fixup last alloc pointer after extent removal for DUP

Nathan Chancellor (6):
  compiler-clang.h: require LLVM 19.1.0 or higher for __typeof_unqual__
  kbuild: rpm-pkg: Restrict manual debug package creation
  kernel: rpm-pkg: Restore find-debuginfo.sh approach to -debuginfo
    package
  kbuild: rpm-pkg: Fix manual debuginfo generation when using .src.rpm
  kbuild: rpm-pkg: Disable automatic requires for manual debuginfo
    package
  ALSA: pcm: Revert bufs move in snd_pcm_xfern_frames_ioctl()

Navaneeth K (1):
  most: core: fix resource leak in most_register_interface error paths

Nicholas Carlini (1):
  ksmbd: fix signededness bug in smb_direct_prepare_negotiation()

Nicholas Kazlauskas (1):
  drm/amd/display: Ensure link output is disabled in backend reset for
    PLL_ON

Nick Hu (1):
  irqchip/riscv-imsic: Add a CPU pm notifier to restore the IMSIC on
    exit

Nicolas Dufresne (1):
  media: mediatek: vcodec: Don't try to decode 422/444 VP9

Nicolas Schier (1):
  perf build: Raise minimum shellcheck version to 0.7.2

Nicolin Chen (1):
  iommu/arm-smmu-v3: Do not set disable_ats unless vSTE is Translate

Nidhish A N (1):
  wifi: iwlwifi: mld: Fix primary link selection logic

Niklas Cassel (6):
  Revert "PCI: dw-rockchip: Don't wait for link since we can detect Link
    Up"
  Revert "PCI: qcom: Don't wait for link if we can detect Link Up"
  Revert "PCI: qcom: Enable MSI interrupts together with Link up if
    'Global IRQ' is supported"
  Revert "PCI: qcom: Enumerate endpoints based on Link up event in
    'global_irq' interrupt"
  Revert "PCI: dwc: Don't wait for link up if driver can detect Link Up
    event"
  PCI: dwc: Fix msg_atu_index assignment

Niklas Schnelle (3):
  s390/pci: Handle futile config accesses of disabled devices directly
  Revert "PCI/IOV: Add PCI rescan-remove locking when enabling/disabling
    SR-IOV"
  PCI/IOV: Fix race between SR-IOV enable/disable and hotplug

Niklas Söderlund (1):
  clocksource/drivers/sh_tmu: Always leave device running after probe

Ojaswin Mujoo (1):
  ext4: propagate flags to convert_initialized_extent()

Oleksandr Suvorov (1):
  watchdog: imx7ulp_wdt: handle the nowayout option

Olga Kornievskaia (1):
  NFSD: fix setting FMODE_NOCMTIME in nfs4_open_delegation

Oliver Neukum (1):
  HID: hid-pl: handle probe errors

Otto Pflüger (2):
  mailbox: sprd: mask interrupts that are not handled
  mailbox: sprd: clear delivery flag before handling TX done

Ovidiu Bunea (1):
  drm/amd/display: Disable FEC when powering down encoders

Pavan Chebbi (2):
  bnxt_en: Fix RSS context delete logic
  bnxt_en: Fix deleting of Ntuple filters

Pavel Begunkov (1):
  io_uring/zcrx: fix sgtable leak on mapping failures

Peichen Huang (1):
  drm/amd/display: Don't disable DPCD mst_en if sink connected

Peng Fan (2):
  soc: imx8m: Fix error handling for clk_prepare_enable()
  remoteproc: imx_rproc: Fix invalid loaded resource table detection

Peter Ujfalusi (7):
  ASoC: SOF: ipc4: Support for sending payload along with
    LARGE_CONFIG_GET
  PCI: Add Intel Nova Lake audio Device ID
  soundwire: dmi-quirks: add mapping for Avell B.ON (OEM rebranded of
    NUC15)
  ASoC: SOF: ipc4-control: If there is no data do not send bytes update
  ASoC: SOF: ipc4-topology: Correct the allocation size for bytes
    controls
  ASoC: SOF: ipc4-control: Use the correct size for
    scontrol->ipc_control_data
  ASoC: SOF: ipc4-control: Keep the payload size up to date

Petr Pavlu (2):
  tracing: Fix checking of freed trace_event_file for hist files
  tracing: Wake up poll waiters for hist files when removing an event

Phil Sutter (1):
  include: uapi: netfilter_bridge.h: Cover for musl libc

Philip Yang (1):
  drm/amdkfd: Handle GPU reset and drain retry fault race

Philipp Stanner (1):
  rust: list: Add unsafe blocks for container_of and safety comments

Pierre-Eric Pelloux-Prayer (1):
  drm/amdgpu: fix sync handling in amdgpu_dma_buf_move_notify

Ping-Ke Shih (4):
  wifi: rtw89: pci: validate sequence number of TX release report
  wifi: rtw89: mac: correct page number for CSI response
  wifi: rtw89: disable EHT protocol by chip capabilities
  wifi: rtw89: pci: validate release report content before using for
    RTL8922DE

Po-Hao Huang (2):
  wifi: rtw89: fix unable to receive probe responses under MLO
    connection
  wifi: rtw89: 8922a: add digital compensation for 2GHz

Prashanth K (1):
  usb: dwc3: gadget: Move vbus draw to workqueue context

Praveen Talari (1):
  spi: geni-qcom: Fix abort sequence execution for serial engine errors

Qanux (1):
  ipv6: ioam: fix heap buffer overflow in __ioam6_fill_trace_data()

Qian Zhang (1):
  wifi: ath11k: Fix failure to connect to a 6 GHz AP

Qiuxu Zhuo (1):
  EDAC/igen6: Add two Intel Amston Lake SoCs support

Qu Wenruo (1):
  btrfs: fallback to buffered IO if the data profile has duplication

Raag Jadav (1):
  pinctrl: intel: Add code name documentation

Rafael J. Wysocki (1):
  watchdog: rzv2h_wdt: Discard pm_runtime_put() return value

Ralf Lici (1):
  ovpn: tcp - fix packet extraction from stream

Randy Dunlap (1):
  rtc: max31335: use correct CONFIG symbol in IS_REACHABLE()

Ranjani Sridharan (1):
  ASoC: SOF: Intel: hda: Fix NULL pointer dereference

Renjiang Han (1):
  media: venus: vdec: fix error state assignment for zero bytesused

René Rebe (3):
  modpost: Amend ppc64 save/restfpr symnames for -Os build
  fix it87_wdt early reboot by reporting running timer
  fbdev: ffb: fix corrupted video output on Sun FFB1

Ricardo Ribalda (4):
  media: uvcvideo: Create an ID namespace for streaming output terminals
  media: uvcvideo: Fix support for V4L2_CTRL_FLAG_HAS_WHICH_MIN_MAX
  media: dw9714: Fix powerup sequence
  media: iris: Fix fps calculation

Richard Zhu (2):
  PCI: imx6: Add CLKREQ# override to enable REFCLK for i.MX95 PCIe
  PCI: dwc: Skip waiting for L2/L3 Ready if dw_pcie_rp::skip_l23_wait is
    true

Robin Murphy (2):
  perf/arm-cmn: Support CMN-600AE
  perf/arm-cmn: Reject unsupported hardware configurations

Romain Gantois (1):
  fpga: of-fpga-region: Fail if any bridge is missing

Roman Peshkichev (1):
  wifi: rtw88: fix DTIM period handling when conf->dtim_period is zero

Rong Zhang (2):
  MIPS: Loongson2ef: Register PCI controller in early stage
  MIPS: Loongson2ef: Use pcibios_align_resource() to block io range

Ross Vandegrift (1):
  wifi: ath11k: add pm quirk for Thinkpad Z13/Z16 Gen1

Rui Wang (1):
  media: rkisp1: Fix filter mode register configuration

Ruipeng Qi (1):
  pstore: ram_core: fix incorrect success return when vmap() fails

Ruitong Liu (1):
  net/sched: act_skbedit: fix divide-by-zero in tcf_skbedit_hash()

Sakari Ailus (6):
  media: v4l2-async: Fix error handling on steps after finding a match
  media: ipu6: Ensure stream_mutex is acquired when dealing with node
    list
  media: ipu6: Close firmware streams on streaming enable failure
  media: ipu6: Always close firmware stream
  media: ccs: Avoid possible division by zero
  media: ccs: Fix setting initial sub-device state

Sam Day (2):
  usb: gadget: f_fs: fix DMA-BUF OUT queues
  usb: gadget: f_fs: Fix ioctl error handling

Sam Edwards (2):
  ceph: do not propagate page array emplacement errors as batch errors
  ceph: fix write storm on fscrypted files

Sam James (1):
  sparc: don't reference obsolete termio struct for TC* constants

Sami Tolvanen (3):
  gendwarfksyms: Fix build on 32-bit hosts
  bpf: crypto: Use the correct destructor kfunc type
  bpf: net_sched: Use the correct destructor kfunc type

Sandipan Das (1):
  perf vendor events amd: Fix Zen 5 MAB allocation events

Sanjay Yadav (1):
  drm/buddy: Prevent BUG_ON by validating rounded allocation

Sasha Levin (2):
  Revert "ACPI: processor: Update cpuidle driver check in
    __acpi_processor_start()"
  Linux 6.18.16-rc1

Sean Christopherson (2):
  KVM: x86: Return "unsupported" instead of "invalid" on access to
    unsupported PV MSR
  KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3()
    succeeding

Sebastian Andrzej Siewior (6):
  perf/cxlpmu: Replace IRQF_ONESHOT with IRQF_NO_THREAD
  mailbox: bcm-ferxrm-mailbox: Use default primary handler
  char: tpm: cr50: Remove IRQF_ONESHOT
  iio: Use IRQF_NO_THREAD
  iio: magnetometer: Remove IRQF_ONESHOT
  net: Drop the lock in skb_may_tx_timestamp()

Sebastian Krzyszkowiak (2):
  ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
  ASoC: wm8962: Don't report a microphone if it's shorted to ground on
    plug

Sergey Matyukevich (1):
  riscv: vector: init vector context with proper vlenb

Shaurya Rane (1):
  media: radio-keene: fix memory leak in error path

Shawn Lin (4):
  PCI: dw-rockchip: Disable BAR 0 and BAR 1 for Root Port
  soc: rockchip: grf: Fix wrong RK3576_IOCGRF_MISC_CON definition
  soc: rockchip: grf: Support multiple grf to be handled
  arm64: dts: rockchip: Fix SD card support for RK3576 EVB1

Shay Drory (4):
  net/mlx5: DR, Fix circular locking dependency in dump
  net/mlx5: LAG, disable MPESW in lag_disable_change()
  net/mlx5: E-switch, Clear legacy flag when moving to switchdev
  net/mlx5: Fix missing devlink lock in SRIOV enable error path

Shell Chen (1):
  Bluetooth: btusb: Add new VID/PID for RTL8852CE

Shengming Hu (2):
  watchdog/softlockup: fix sample ring index wrap in
    need_counting_irqs()
  function_graph: Restore direct mode when callbacks drop to one

Shuai Zhang (1):
  Bluetooth: hci_qca: Fix SSR (SubSystem Restart) fail when BT_EN is
    pulled up by hw

Shyam Prasad N (3):
  netfs: when subreq is marked for retry, do not check if it faced an
    error
  cifs: Fix locking usage for tcon fields
  cifs: some missing initializations on replay

Simon Baatz (1):
  tcp: re-enable acceptance of FIN packets when RWIN is 0

Slark Xiao (1):
  net: wwan: mhi: Add network support for Foxconn T99W760

Sri Jayaramappa (1):
  libsubcmd: Fix null intersection case in exclude_cmds()

Srinivas Pandruvada (2):
  platform/x86: ISST: Add missing write block check
  platform/x86: ISST: Store and restore all domains data

Srinivasan Shanmugam (1):
  drm/amdgpu: Refactor amdgpu_gem_va_ioctl for Handling Last Fence
    Update and Timeline Management v4

Stefan Sørensen (2):
  Bluetooth: hci_conn: Set link_policy on incoming ACL connections
  Bluetooth: hci_conn: use mod_delayed_work for active mode timeout

Stefano Stabellini (1):
  9p/xen: protect xen_9pfs_front_free against concurrent calls

Steven Rostedt (1):
  fgraph: Do not call handlers direct when not using ftrace_ops

Suchit Karunakaran (1):
  perf annotate: Fix memcpy size in arch__grow_instructions()

Sun YangKai (1):
  btrfs: fix periodic reclaim condition

Sunday Clement (1):
  drm/amdkfd: Fix out-of-bounds write in kfd_event_page_set()

Suraj Kandpal (1):
  drm/display/dp_mst: Add protection against 0 vcpi

Szymon Wilczek (3):
  media: pvrusb2: fix URB leak in pvr2_send_request_ex
  wifi: libertas: fix WARNING in usb_tx_block
  ntfs3: fix circular locking dependency in run_unpack_ex

Takashi Iwai (3):
  ALSA: mixer: oss: Add card disconnect checkpoints
  ALSA: usb-audio: Update the number of packets properly at receiving
  ALSA: usb-audio: Add sanity check for OOB writes at silencing

Tao Zhou (1):
  drm/amdgpu: fix the calculation of RAS bad page number

Techie Ernie (1):
  Bluetooth: btusb: Add USB ID 0489:e112 for Realtek 8851BE

Tetsuo Handa (3):
  hfsplus: pretend special inodes as regular files
  xfrm: always flush state and policy upon NETDEV_UNREGISTER event
  team: avoid NETDEV_CHANGEMTU event when unregistering slave

Thadeu Lima de Souza Cascardo (1):
  fpga: dfl: use subsys_initcall to allow built-in drivers to be added

Thomas Fourier (3):
  net: wan/fsl_ucc_hdlc: Fix dma_free_coherent() in uhdlc_memclean()
  fbdev: vt8500lcdfb: fix missing dma_free_coherent()
  net: ethernet: ec_bhf: Fix dma_free_coherent() dma handle

Thomas Richard (TI.com) (2):
  phy: ti: phy-j721e-wiz: restore mux selection during resume
  phy: cadence-torrent: restore parent clock for refclk during resume

Thomas Richter (3):
  perf test stat tests: Fix for virtualized machines
  perf test: Fix test case perftool-testsuite_report for s390
  s390/perf: Disable register readout on sampling events

Thomas Weissschuh (1):
  ARM: 9467/1: mm: Don't use %pK through printk

Thomas Weißschuh (3):
  hyper-v: Mark inner union in hv_kvp_exchg_msg_value as packed
  virt: vbox: uapi: Mark inner unions in packed structs as packed
  binder: don't use %pK through printk

Thomas Yen (1):
  scsi: ufs: core: Flush exception handling work when RPM level is zero

Thomas Zimmermann (6):
  drm/tests: shmem: Swap names of export tests
  drm/tests: shmem: Add clean-up action to unpin pages
  drm/tests: shmem: Hold reservation lock around vmap/vunmap
  drm/tests: shmem: Hold reservation lock around madvise
  drm/tests: shmem: Hold reservation lock around purge
  fbcon: Remove struct fbcon_display.inverse

Thorsten Schmelzer (2):
  media: adv7180: fix frame interval in progressive mode
  HID: multitouch: add eGalaxTouch EXC3188 support

Tiezhu Yang (3):
  LoongArch: Use %px to print unmodified unwinding address
  LoongArch: Guard percpu handler under !CONFIG_PREEMPT_RT
  LoongArch: Disable instrumentation for setup_ptwalker()

Tim Huang (1):
  drm/amdgpu: add support for HDP IP version 6.1.1

Tiwei Bie (1):
  um: Preserve errno within signal handler

Tom Chung (1):
  drm/amd/display: Fix system resume lag issue

Tomas Melin (2):
  Revert "arm64: zynqmp: Add an OP-TEE node to the device tree"
  rtc: zynqmp: correct frequency value

Tomasz Pakuła (1):
  HID: pidff: Do not set out of range trigger button

Tung Nguyen (1):
  tipc: fix duplicate publication key in tipc_service_insert_publ()

Tuo Li (3):
  ACPI: processor: Fix NULL-pointer dereference in
    acpi_processor_errata_piix4()
  drm/panel: Fix a possible null-pointer dereference in
    jdi_panel_dsi_remove()
  misc: bcm_vk: Fix possible null-pointer dereferences in bcm_vk_read()

Tvrtko Ursulin (1):
  drm/xe: Fix ggtt fb alignment

Tzung-Bi Shih (1):
  remoteproc: mediatek: Break lock dependency to `prepare_lock`

Vahagn Vardanian (1):
  netfilter: nf_conntrack_h323: fix OOB read in decode_choice()

Val Packett (2):
  drm/panel-edp: Add AUO B140QAX01.H panel
  media: iris: use fallback size when S_FMT is called without
    width/height

Valentina Fernandez (2):
  mailbox: mchp-ipc-sbi: fix out-of-bounds access in
    mchp_ipc_get_cluster_aggr_irq()
  mailbox: mchp-ipc-sbi: fix uninitialized symbol and other smatch
    warnings

Vasiliy Kovalev (1):
  KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()

Vasily Gorbik (1):
  crash_dump: fix dm_crypt keys locking and ref leak

Viacheslav Dubeyko (2):
  hfsplus: fix volume corruption issue for generic/480
  hfsplus: fix volume corruption issue for generic/498

Victor Zhao (1):
  drm/amdgpu: avoid sdma ring reset in sriov

Vijendar Mukunda (1):
  ASoC: amd: amd_sdw: add machine driver quirk for Lenovo models

Vishnu Reddy (2):
  media: iris: Fix ffmpeg corrupted frame error
  media: iris: Prevent output buffer queuing before stream-on completes

Vladimir Zapolskiy (1):
  media: qcom: camss: Do not enable cpas fast ahb clock for SM8550 VFE
    lite

Vlastimil Babka (2):
  mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP
    allocations
  mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()

Waiman Long (1):
  cgroup/cpuset: Don't fail cpuset.cpus change in v2

Wander Lairson Costa (1):
  rtla: Fix NULL pointer dereference in actions_parse

Wang, Sung-huai (1):
  drm/amd/display: Revert "init dispclk from bootup clock for DCN315"

Wayne Chang (1):
  usb: host: tegra: Remove manual wake IRQ disposal

Wayne Lin (1):
  drm/amd/display: Avoid updating surface with the same surface under
    MPO

Weigang He (1):
  fbdev: of: display_timing: fix refcount leak in
    of_get_display_timings()

Wentao Liang (2):
  ARM: omap2: Fix reference count leaks in omap_control_init()
  soc: ti: pruss: Fix double free in pruss_clk_mux_setup()

William Tambe (1):
  mm/highmem: fix __kmap_to_page() build error

Xiao Kan (1):
  drm: Account property blob allocations to memcg

Xiaolei Wang (2):
  drm/v3d: Set DMA segment size to avoid debug warnings
  media: i2c: ov5647: use our own mutex for the ctrl lock

Xu Yang (2):
  phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature
  phy: fsl-imx8mq-usb: set platform driver data

Xulin Sun (3):
  media: chips-media: wave5: Fix PM runtime usage count underflow
  media: chips-media: wave5: Fix kthread worker destruction in polling
    mode
  media: chips-media: wave5: Fix device cleanup order to prevent kernel
    panic

Yauhen Kharuzhy (1):
  ACPI: x86: Force enabling of PWM2 on the Yogabook YB1-X90

Yeoreum Yun (1):
  arm64: kernel: initialize missing kexec_buf->random field

Yi Liu (1):
  iommu/vt-d: Flush piotlb for SVM and Nested domain

Yifan Zhang (1):
  drm/amdgpu: Protect GPU register accesses in powergated state in some
    paths

Yosry Ahmed (1):
  KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation

Yu Kuai (2):
  blk-mq-debugfs: add missing debugfs_mutex in
    blk_mq_debugfs_register_hctxs()
  blk-mq-sched: unify elevators checking for async requests

YuBiao Wang (1):
  drm/amdgpu: Skip loading SDMA_RS64 in VF

Yuto Hamaguchi (1):
  netfilter: nf_conntrack: Add allow_clash to generic protocol handler

Zenghui Yu (Huawei) (1):
  KVM: arm64: nv: Return correct RES0 bits for FGT registers

Zenm Chen (1):
  wifi: rtw89: Add support for MSI AX1800 Nano (GUAX18N)

Zhang Yi (1):
  ext4: use reserved metadata blocks when splitting extent on endio

Zhongwei (1):
  drm/amd/display: avoid dig reg access timeout on usb4 link training
    fail

Ziyi Guo (7):
  power: sequencing: fix missing state_lock in pwrseq_power_on() error
    path
  ASoC: fsl: imx-rpmsg: use snd_soc_find_dai_with_mutex() in probe
  wifi: iwlegacy: add missing mutex protection in
    il4965_store_tx_power()
  wifi: iwlegacy: add missing mutex protection in
    il3945_store_measurement()
  wifi: ath10k: fix lock protection in
    ath10k_wmi_event_peer_sta_ps_state_chg()
  net: usb: kaweth: remove TX queue manipulation in kaweth_set_rx_mode
  net: usb: pegasus: enable basic endpoint checking

Zong-Zhe Yang (2):
  wifi: rtw89: ser: enable error IMR after recovering from L1
  wifi: rtw89: regd: 6 GHz power type marks default when inactive

decce6 (2):
  drm/amdgpu: Add HAINAN clock adjustment
  drm/radeon: Add HAINAN clock adjustment

ethanwu (2):
  ceph: supply snapshot context in ceph_uninline_data()
  ceph: supply snapshot context in ceph_zero_partial_object()

fenugrec (1):
  ALSA: usb-audio: presonus s18xx uses little-endian

gongqi (1):
  ALSA: hda/conexant: Add headset mic fix for MECHREVO Wujie 15X Pro

jinbaohong (2):
  btrfs: handle user interrupt properly in btrfs_trim_fs()
  btrfs: continue trimming remaining devices on failure

 Documentation/admin-guide/cgroup-v2.rst       |   8 +-
 Documentation/hwmon/nct6683.rst               |   1 +
 .../networking/net_cachelines/inet_sock.rst   |  79 ++--
 Makefile                                      |   4 +-
 arch/alpha/include/asm/pgtable.h              |  33 +-
 arch/alpha/include/asm/tlbflush.h             |   4 +-
 arch/alpha/mm/Makefile                        |   2 +-
 arch/alpha/mm/tlbflush.c                      | 112 +++++
 arch/arm/mach-omap2/control.c                 |  14 +-
 arch/arm/mm/physaddr.c                        |   2 +-
 arch/arm64/Kbuild                             |   4 +
 arch/arm64/boot/dts/apple/t8112-j473.dts      |  19 +
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts |   2 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   1 +
 arch/arm64/boot/dts/qcom/sm8750.dtsi          |   2 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi        |  12 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts |   4 -
 .../boot/dts/rockchip/rk3576-evb1-v10.dts     |  22 +
 .../boot/dts/rockchip/rk3576-pinctrl.dtsi     |   7 +
 arch/arm64/boot/dts/rockchip/rk3576.dtsi      |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi   |   2 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        |   5 -
 arch/arm64/include/asm/pgtable.h              |   9 +-
 arch/arm64/include/asm/rwonce.h               |   2 +-
 arch/arm64/kernel/kexec_image.c               |   2 +-
 arch/arm64/kernel/proton-pack.c               |   1 +
 arch/arm64/kernel/ptrace.c                    |   3 +
 arch/arm64/kvm/emulate-nested.c               |   2 +-
 arch/arm64/lib/delay.c                        |  19 +-
 arch/loongarch/include/asm/topology.h         |   2 +-
 arch/loongarch/kernel/setup.c                 |   1 +
 arch/loongarch/kernel/unwind_orc.c            |   2 +-
 arch/loongarch/kernel/unwind_prologue.c       |   2 +-
 arch/loongarch/mm/tlb.c                       |   2 +-
 arch/m68k/lib/memmove.c                       |  18 +
 .../include/asm/mach-loongson2ef/loongson.h   |   6 +
 .../include/asm/mach-loongson64/topology.h    |   2 +-
 arch/mips/loongson2ef/common/pci.c            |  18 +-
 arch/mips/loongson2ef/common/setup.c          |   1 +
 arch/mips/rb532/devices.c                     |   5 +-
 arch/openrisc/include/asm/barrier.h           |   2 +
 arch/parisc/kernel/drivers.c                  |   2 +-
 arch/parisc/kernel/process.c                  |   3 +
 arch/powerpc/kernel/smp.c                     |   2 +
 arch/powerpc/platforms/pseries/msi.c          |  44 +-
 arch/riscv/kernel/vector.c                    |  12 +-
 arch/s390/boot/Makefile                       |   1 +
 arch/s390/kernel/perf_cpum_sf.c               |   2 +-
 arch/s390/pci/pci.c                           |  25 +-
 arch/s390/purgatory/Makefile                  |   1 +
 arch/sparc/include/uapi/asm/ioctls.h          |   8 +-
 arch/sparc/kernel/process.c                   |  38 +-
 arch/um/os-Linux/signal.c                     |   6 +-
 arch/x86/coco/sev/core.c                      |   3 +-
 arch/x86/events/intel/core.c                  |   1 +
 arch/x86/events/intel/cstate.c                |   1 +
 arch/x86/events/msr.c                         |   1 +
 arch/x86/kernel/kexec-bzimage64.c             |   7 +
 arch/x86/kernel/setup.c                       |   6 +
 arch/x86/kvm/svm/nested.c                     |   3 +-
 arch/x86/kvm/svm/svm.c                        |   5 +-
 arch/x86/kvm/x86.c                            |  42 +-
 arch/x86/platform/pvh/head.S                  |   2 +
 block/bfq-iosched.c                           |   2 +-
 block/blk-merge.c                             |  21 +-
 block/blk-mq-debugfs.c                        |   2 +
 block/blk-mq-sched.h                          |   5 +
 block/blk.h                                   |   6 +-
 block/kyber-iosched.c                         |   2 +-
 block/mq-deadline.c                           |   2 +-
 drivers/accel/amdxdna/amdxdna_mailbox.c       |  19 +-
 drivers/acpi/acpi_processor.c                 |  28 +-
 drivers/acpi/acpica/exoparg3.c                |  46 +-
 drivers/acpi/apei/ghes.c                      |  38 +-
 drivers/acpi/battery.c                        |   9 +-
 drivers/acpi/processor_driver.c               |   2 +-
 drivers/acpi/resource.c                       |   8 +
 drivers/acpi/x86/s2idle.c                     |   6 +
 drivers/acpi/x86/utils.c                      |  12 +
 drivers/android/binder.c                      |   2 +-
 drivers/android/binder_alloc.c                |   6 +-
 drivers/ata/libata-core.c                     |  24 ++
 drivers/ata/libata-eh.c                       |   3 +-
 drivers/ata/libata-scsi.c                     |   3 +
 drivers/ata/libata.h                          |   1 +
 drivers/atm/fore200e.c                        |   4 +
 drivers/base/faux.c                           |  18 +-
 drivers/block/rnbd/rnbd-srv.c                 |   3 +
 drivers/bluetooth/btusb.c                     |   7 +
 drivers/bluetooth/hci_qca.c                   |  57 ++-
 drivers/bus/fsl-mc/fsl-mc-bus.c               |   6 +-
 drivers/bus/omap-ocp2scp.c                    |  13 +-
 drivers/char/ipmi/ipmi_ipmb.c                 |   5 +
 drivers/char/random.c                         |  12 +-
 drivers/char/tpm/tpm_tis_i2c_cr50.c           |   3 +-
 drivers/char/tpm/tpm_tis_spi_cr50.c           |   2 +-
 drivers/clk/clk-apple-nco.c                   |   1 +
 drivers/clk/clk-renesas-pcie.c                |   2 +-
 drivers/clk/meson/s4-peripherals.c            |   4 -
 drivers/clk/microchip/clk-core.c              |  25 +-
 drivers/clk/renesas/rzg2l-cpg.c               |  15 +-
 drivers/clk/tegra/clk-tegra124-emc.c          |   4 +-
 drivers/clocksource/Kconfig                   |   1 +
 drivers/clocksource/sh_tmu.c                  |  18 -
 drivers/cpufreq/cpufreq-dt-platdev.c          |   3 +
 drivers/crypto/hisilicon/qm.c                 |   6 +-
 drivers/dma/stm32/stm32-dma3.c                |   7 +-
 drivers/dma/stm32/stm32-mdma.c                |   2 +-
 drivers/dma/sun6i-dma.c                       |  26 +-
 drivers/dpll/zl3073x/core.c                   |  25 +-
 drivers/dpll/zl3073x/core.h                   |  58 +++
 drivers/dpll/zl3073x/dpll.c                   | 395 +++++-------------
 drivers/dpll/zl3073x/ref.c                    | 109 ++++-
 drivers/dpll/zl3073x/ref.h                    |  68 +++
 drivers/dpll/zl3073x/regs.h                   |   1 +
 drivers/edac/igen6_edac.c                     |  24 ++
 drivers/firmware/arm_ffa/driver.c             |   1 +
 drivers/firmware/efi/cper-arm.c               |  12 +-
 drivers/firmware/efi/cper.c                   |   8 +-
 drivers/fpga/dfl.c                            |   2 +-
 drivers/fpga/of-fpga-region.c                 |   8 +-
 drivers/gpio/Kconfig                          |   4 +-
 drivers/gpio/gpio-aspeed-sgpio.c              |   5 +-
 drivers/gpio/gpio-nomadik.c                   |   3 +
 drivers/gpio/gpio-pca953x.c                   |   6 +
 drivers/gpio/gpiolib-sysfs.c                  | 106 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c   |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c       | 135 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c       |  10 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c       |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c       |  14 +-
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c      |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c     |  11 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c      |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c         |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c      |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c        |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c          |   7 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  33 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   |   4 +-
 .../dc/clk_mgr/dcn315/dcn315_clk_mgr.c        |   3 +-
 .../display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c  |  16 +-
 .../dc/dio/dcn32/dcn32_dio_link_encoder.c     |  15 +-
 .../drm/amd/display/dc/dml/dcn35/dcn35_fpu.c  |   4 +-
 .../drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c  |  21 +-
 .../drm/amd/display/dc/dpp/dcn30/dcn30_dpp.h  |   4 +
 .../amd/display/dc/dpp/dcn401/dcn401_dpp.c    |   6 +-
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c |  40 +-
 .../amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |  12 +-
 .../amd/display/dc/hwss/dcn31/dcn31_hwseq.c   |  16 +-
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c |  15 +-
 .../gpu/drm/amd/display/dc/link/link_dpms.c   |  16 +-
 .../link_dp_training_fixed_vs_pe_retimer.c    |   2 +-
 .../drm/amd/display/dc/mpc/dcn32/dcn32_mpc.c  |   3 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c    |   5 +
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   |  25 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c     |   2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   3 +-
 drivers/gpu/drm/drm_buddy.c                   |   9 +
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  63 +++
 drivers/gpu/drm/drm_property.c                |   2 +-
 drivers/gpu/drm/i915/display/intel_psr.c      |   7 +-
 drivers/gpu/drm/i915/display/intel_quirks.c   |   2 +-
 drivers/gpu/drm/panel/panel-edp.c             |   9 +
 drivers/gpu/drm/panel/panel-jdi-lpm102a188a.c |   4 +-
 drivers/gpu/drm/panthor/panthor_mmu.c         |  27 +-
 drivers/gpu/drm/panthor/panthor_sched.c       |   4 +
 drivers/gpu/drm/radeon/si_dpm.c               |   5 +
 .../gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c    |   8 +
 drivers/gpu/drm/tests/drm_gem_shmem_test.c    |  30 +-
 drivers/gpu/drm/tyr/driver.rs                 |   2 +-
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +
 drivers/gpu/drm/xe/display/xe_fb_pin.c        |   2 +-
 drivers/gpu/drm/xe/regs/xe_guc_regs.h         |   3 +
 drivers/gpu/drm/xe/xe_ggtt.c                  |   3 +-
 drivers/gpu/drm/xe/xe_guc_submit.c            |   3 +-
 drivers/gpu/drm/xe/xe_vm.c                    |  14 +-
 drivers/gpu/drm/xe/xe_vm_madvise.c            |   7 +-
 drivers/gpu/drm/xe/xe_wa.c                    |   5 +
 drivers/hid/Kconfig                           |   1 +
 drivers/hid/hid-apple.c                       |   1 +
 drivers/hid/hid-elecom.c                      |  16 +
 drivers/hid/hid-ids.h                         |   5 +
 drivers/hid/hid-logitech-hidpp.c              |   4 +-
 drivers/hid/hid-magicmouse.c                  |   5 +
 drivers/hid/hid-multitouch.c                  |  75 ++++
 drivers/hid/hid-pl.c                          |   7 +-
 drivers/hid/hid-prodikeys.c                   |   4 +
 drivers/hid/hid-quirks.c                      |   3 +
 drivers/hid/i2c-hid/i2c-hid-of-elan.c         |   8 +
 drivers/hid/usbhid/hid-pidff.c                |  16 +-
 drivers/hv/mshv_eventfd.c                     |   5 +-
 drivers/hv/mshv_eventfd.h                     |   1 -
 drivers/hwmon/dell-smm-hwmon.c                |   7 +
 drivers/hwmon/emc2305.c                       |   1 +
 drivers/hwmon/f71882fg.c                      |   6 +-
 drivers/hwmon/nct6683.c                       |   3 +
 drivers/hwmon/nct6775-platform.c              |   1 +
 drivers/hwmon/nct7363.c                       |   1 +
 drivers/i2c/busses/i2c-imx-lpi2c.c            | 107 +++--
 drivers/i3c/master/mipi-i3c-hci/dma.c         |   8 +
 drivers/i3c/master/mipi-i3c-hci/ext_caps.c    |   2 +-
 drivers/i3c/master/svc-i3c-master.c           |   4 +-
 drivers/iio/accel/adxl380.c                   |   1 +
 drivers/iio/accel/bma180.c                    |   5 +-
 drivers/iio/adc/ad7766.c                      |   2 +-
 drivers/iio/gyro/itg3200_buffer.c             |   8 +-
 drivers/iio/gyro/itg3200_core.c               |   2 +
 drivers/iio/imu/bmi270/bmi270_i2c.c           |   3 +
 drivers/iio/light/si1145.c                    |   2 +-
 drivers/iio/magnetometer/ak8975.c             |   2 +-
 drivers/infiniband/core/cache.c               |  13 +
 drivers/infiniband/core/core_priv.h           |   3 +
 drivers/infiniband/core/device.c              |  34 +-
 drivers/infiniband/core/umem_dmabuf.c         |   4 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |   2 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |   4 +-
 drivers/iommu/amd/amd_iommu_types.h           |   2 +-
 drivers/iommu/amd/init.c                      |   2 +-
 drivers/iommu/amd/iommu.c                     |  41 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |   4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  31 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  95 ++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   4 +
 drivers/iommu/intel/cache.c                   |   9 +-
 drivers/iommu/intel/pasid.c                   |   2 +-
 drivers/irqchip/irq-riscv-imsic-early.c       |  39 +-
 drivers/mailbox/bcm-flexrm-mailbox.c          |  14 +-
 drivers/mailbox/imx-mailbox.c                 |   8 +-
 drivers/mailbox/mailbox-mchp-ipc-sbi.c        |  41 +-
 drivers/mailbox/mailbox.c                     |   6 +-
 drivers/mailbox/pcc.c                         |   2 +-
 drivers/mailbox/sprd-mailbox.c                |  20 +-
 drivers/md/dm-exception-store.c               |   2 +-
 drivers/md/dm-integrity.c                     |  15 +-
 drivers/md/dm-log.c                           |   2 +-
 drivers/md/dm-mpath.c                         |   2 +-
 drivers/md/dm-path-selector.c                 |   2 +-
 drivers/md/dm-rq.c                            |  16 +-
 drivers/md/dm-table.c                         |  12 +-
 drivers/md/dm-target.c                        |   2 +-
 drivers/md/dm-unstripe.c                      |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/md-bitmap.c                        |   3 +-
 drivers/md/md-cluster.c                       |   7 +-
 drivers/md/md.c                               |  14 +-
 drivers/media/dvb-core/dmxdev.c               |   8 +-
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/i2c/adv7180.c                   |   7 +
 drivers/media/i2c/ccs/ccs-core.c              |  12 +-
 drivers/media/i2c/dw9714.c                    |   2 +-
 drivers/media/i2c/mt9m114.c                   |  16 +-
 drivers/media/i2c/ov01a10.c                   |  46 +-
 drivers/media/i2c/ov5647.c                    |  24 +-
 drivers/media/i2c/tw9903.c                    |   1 +
 drivers/media/i2c/tw9906.c                    |   1 +
 drivers/media/pci/cx23885/cx23885-alsa.c      |   4 +-
 drivers/media/pci/cx25821/cx25821-alsa.c      |   1 +
 drivers/media/pci/cx25821/cx25821-core.c      |   1 +
 drivers/media/pci/cx88/cx88-alsa.c            |   4 +-
 .../media/pci/intel/ipu6/ipu6-isys-queue.c    |   8 +-
 .../media/pci/intel/ipu6/ipu6-isys-video.c    |   6 +-
 drivers/media/pci/intel/ipu6/ipu6-mmu.c       |   4 +-
 drivers/media/pci/intel/ipu6/ipu6.c           |  10 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c    |   8 +-
 drivers/media/platform/amphion/vdec.c         |   1 +
 drivers/media/platform/amphion/vpu_v4l2.c     |   2 -
 .../platform/chips-media/wave5/wave5-helper.c |  28 +-
 .../platform/chips-media/wave5/wave5-helper.h |   1 +
 .../chips-media/wave5/wave5-vpu-dec.c         |  10 +-
 .../chips-media/wave5/wave5-vpu-enc.c         |  13 +-
 .../platform/chips-media/wave5/wave5-vpu.c    | 111 ++++-
 .../platform/chips-media/wave5/wave5-vpuapi.c |  15 -
 .../platform/chips-media/wave5/wave5-vpuapi.h |   6 +
 .../platform/mediatek/mdp/mtk_mdp_core.c      |  17 +-
 .../vcodec/decoder/mtk_vcodec_dec_stateless.c |   6 +
 .../mediatek/vcodec/encoder/mtk_vcodec_enc.c  |   6 +-
 .../media/platform/qcom/camss/camss-vfe-480.c |   6 +-
 drivers/media/platform/qcom/camss/camss.c     |   6 +-
 .../media/platform/qcom/iris/iris_buffer.c    |   7 +-
 .../qcom/iris/iris_hfi_gen1_command.c         |   6 +-
 .../qcom/iris/iris_hfi_gen2_command.c         |   3 +
 drivers/media/platform/qcom/iris/iris_vb2.c   |  18 +-
 drivers/media/platform/qcom/iris/iris_vdec.c  |   8 +
 drivers/media/platform/qcom/iris/iris_venc.c  |  15 +-
 drivers/media/platform/qcom/venus/vdec.c      |  14 +-
 drivers/media/platform/rockchip/rga/rga-buf.c |   3 +
 .../platform/rockchip/rkisp1/rkisp1-params.c  |   6 -
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c    |   3 +
 .../st/stm32/stm32-dcmipp/dcmipp-byteproc.c   |   7 +-
 .../st/stm32/stm32-dcmipp/dcmipp-core.c       |   7 +-
 .../media/platform/ti/omap3isp/isppreview.c   |  21 +-
 drivers/media/platform/ti/omap3isp/ispvideo.c |  14 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c  |  43 +-
 drivers/media/radio/radio-keene.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c       |   5 +
 drivers/media/usb/uvc/uvc_ctrl.c              |  14 +-
 drivers/media/usb/uvc/uvc_driver.c            |  54 ++-
 drivers/media/usb/uvc/uvc_queue.c             |  12 +-
 drivers/media/usb/uvc/uvc_v4l2.c              |  10 +-
 drivers/media/usb/uvc/uvcvideo.h              |   5 +-
 drivers/media/v4l2-core/v4l2-async.c          |  45 +-
 drivers/mfd/da9052-spi.c                      |   2 +-
 drivers/mfd/intel-lpss-pci.c                  |  13 +
 drivers/mfd/macsmc.c                          |   1 +
 drivers/mfd/mfd-core.c                        |  36 +-
 drivers/mfd/omap-usb-host.c                   |   6 +-
 drivers/mfd/qcom-pm8xxx.c                     |   8 +-
 drivers/mfd/tps65219.c                        |   9 +
 drivers/misc/bcm-vk/bcm_vk_msg.c              |  12 +-
 drivers/misc/eeprom/eeprom_93xx46.c           |  11 +-
 drivers/misc/ti_fpc202.c                      |   3 +-
 drivers/most/core.c                           |   6 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c  |   1 +
 drivers/mtd/nand/spi/core.c                   |   8 +
 drivers/mux/mmio.c                            |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  13 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  13 +-
 drivers/net/ethernet/cadence/macb_main.c      |  11 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |   4 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   7 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   5 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  12 +-
 drivers/net/ethernet/marvell/skge.c           |   1 -
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   3 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   2 +
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |   8 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   |   8 +-
 .../ethernet/mellanox/mlx5/core/lag/mpesw.h   |   5 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   2 +
 .../mellanox/mlx5/core/steering/sws/dr_dbg.c  |   4 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |   5 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |   4 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  28 +-
 drivers/net/ethernet/ti/Kconfig               |   1 +
 drivers/net/ethernet/ti/cpsw_new.c            |  15 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |   5 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c      |   3 +
 drivers/net/netconsole.c                      |   3 +-
 drivers/net/ovpn/tcp.c                        |  53 ++-
 drivers/net/phy/qcom/qca807x.c                |   2 +-
 drivers/net/phy/sfp.c                         |   8 +-
 drivers/net/team/team_core.c                  | 101 +----
 drivers/net/usb/Kconfig                       |   1 -
 drivers/net/usb/kaweth.c                      |   2 -
 drivers/net/usb/lan78xx.c                     |   2 -
 drivers/net/usb/pegasus.c                     |  35 +-
 drivers/net/usb/r8152.c                       |   2 +
 drivers/net/usb/sr9700.c                      |  25 +-
 drivers/net/usb/sr9700.h                      |   7 +-
 drivers/net/wan/farsync.c                     |   2 +
 drivers/net/wan/fsl_ucc_hdlc.c                |   8 +-
 drivers/net/wireless/ath/ath10k/wmi.c         |   4 +-
 drivers/net/wireless/ath/ath11k/core.c        |  28 ++
 drivers/net/wireless/ath/ath11k/reg.c         |   9 +-
 drivers/net/wireless/ath/ath12k/wmi.c         |  24 +-
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |   7 +-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |   7 +-
 .../broadcom/brcm80211/brcmfmac/sdio.h        |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   8 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/smem.c  |   8 +-
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  23 +-
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c   |   5 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  14 +
 .../net/wireless/marvell/libertas/if_usb.c    |   2 +
 drivers/net/wireless/realtek/rtw88/main.c     |  47 ++-
 drivers/net/wireless/realtek/rtw88/main.h     |   2 +-
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   3 +-
 drivers/net/wireless/realtek/rtw89/chan.c     |   5 +-
 drivers/net/wireless/realtek/rtw89/core.c     |  16 +-
 drivers/net/wireless/realtek/rtw89/core.h     |   1 +
 drivers/net/wireless/realtek/rtw89/fw.c       |   3 +
 drivers/net/wireless/realtek/rtw89/fw.h       |   4 +
 drivers/net/wireless/realtek/rtw89/mac.c      |  18 +
 drivers/net/wireless/realtek/rtw89/mac.h      |   1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c |   1 +
 drivers/net/wireless/realtek/rtw89/mac_be.c   |   3 +-
 drivers/net/wireless/realtek/rtw89/pci.c      |  12 +-
 drivers/net/wireless/realtek/rtw89/regd.c     |   1 +
 .../net/wireless/realtek/rtw89/rtw8852bu.c    |   2 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |  79 +++-
 drivers/net/wireless/realtek/rtw89/ser.c      |  10 +
 drivers/net/wireless/realtek/rtw89/wow.c      |   4 +
 drivers/net/wireless/realtek/rtw89/wow.h      |   1 +
 drivers/net/wwan/mhi_wwan_mbim.c              |   3 +-
 drivers/nfc/nxp-nci/i2c.c                     |   2 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c        |  12 +-
 drivers/ntb/ntb_transport.c                   |   4 +-
 drivers/nvmem/core.c                          |   1 +
 drivers/of/kexec.c                            |  15 +-
 drivers/pci/bus.c                             |   8 +
 drivers/pci/controller/dwc/pci-imx6.c         |  25 ++
 .../pci/controller/dwc/pcie-designware-host.c |  35 +-
 drivers/pci/controller/dwc/pcie-designware.h  |   2 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |   9 +-
 drivers/pci/controller/dwc/pcie-qcom.c        |  63 +--
 drivers/pci/endpoint/pci-ep-cfs.c             |   8 +-
 drivers/pci/iov.c                             |   9 +-
 drivers/pci/msi/msi.c                         |   4 +-
 drivers/pci/pci-driver.c                      |   8 +
 drivers/pci/pci.c                             |  45 +-
 drivers/pci/pci.h                             |   1 +
 drivers/pci/pcie/aer.c                        |  26 +-
 drivers/pci/pcie/bwctrl.c                     |   3 +
 drivers/pci/probe.c                           |   6 +-
 drivers/pci/quirks.c                          |  32 ++
 drivers/pci/setup-bus.c                       |  12 +-
 drivers/perf/arm-cmn.c                        |  19 +-
 drivers/perf/cxl_pmu.c                        |   2 +-
 drivers/phy/cadence/phy-cadence-torrent.c     |  23 +
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c    |   3 +
 drivers/phy/marvell/phy-mvebu-cp110-utmi.c    |   2 +-
 drivers/phy/qualcomm/phy-qcom-edp.c           |  16 +-
 drivers/phy/ti/phy-j721e-wiz.c                |  19 +-
 drivers/pinctrl/intel/Kconfig                 |  21 +-
 drivers/pinctrl/mediatek/mtk-eint.c           |  29 +-
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c    |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzt2h.c       |  21 +-
 .../intel/speed_select_if/isst_tpmi_core.c    |  57 ++-
 drivers/power/reset/tdx-ec-poweroff.c         |  19 +
 drivers/power/sequencing/core.c               |   6 +-
 drivers/powercap/intel_rapl_msr.c             |   1 +
 drivers/ptp/ptp_vmclock.c                     |   1 +
 drivers/rapidio/rio-scan.c                    |   3 +-
 drivers/ras/ras.c                             |   6 +-
 drivers/regulator/core.c                      |  12 +-
 drivers/remoteproc/imx_dsp_rproc.c            |   9 +
 drivers/remoteproc/imx_rproc.c                |   4 +
 drivers/remoteproc/mtk_scp.c                  |  39 +-
 drivers/remoteproc/mtk_scp_ipi.c              |   4 +-
 drivers/reset/reset-gpio.c                    |   1 +
 drivers/rpmsg/rpmsg_core.c                    |  66 ++-
 drivers/rtc/interface.c                       |   2 +-
 drivers/rtc/rtc-max31335.c                    |   6 +-
 drivers/rtc/rtc-pcf8563.c                     |   2 +-
 drivers/rtc/rtc-zynqmp.c                      |   3 +
 drivers/scsi/BusLogic.c                       |   6 +-
 drivers/soc/imx/soc-imx8m.c                   |   6 +-
 drivers/soc/rockchip/grf.c                    |  57 ++-
 drivers/soc/ti/k3-socinfo.c                   |   2 +-
 drivers/soc/ti/pruss.c                        |   6 +-
 drivers/soundwire/dmi-quirks.c                |  11 +
 drivers/soundwire/intel_auxdevice.c           |   1 +
 drivers/spi/spi-cadence-quadspi.c             |  19 +-
 drivers/spi/spi-geni-qcom.c                   |  38 +-
 drivers/spi/spi-mem.c                         |  26 +-
 drivers/spi/spi-stm32.c                       |   9 +-
 drivers/spi/spidev.c                          |  63 +--
 drivers/spmi/spmi-apple-controller.c          |   1 +
 drivers/staging/media/ipu7/ipu7-buttress.c    |  17 +-
 .../staging/media/ipu7/ipu7-isys-csi-phy.c    |  13 +-
 drivers/staging/media/ipu7/ipu7-mmu.c         |   2 +-
 drivers/staging/media/ipu7/ipu7.c             |   6 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c     |   6 +-
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   3 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c  |   3 +-
 .../int340x_thermal/processor_thermal_rfim.c  |   5 +-
 drivers/tty/serial/8250/8250_dw.c             |  11 +-
 drivers/tty/serial/8250/8250_omap.c           |  25 +-
 drivers/ufs/core/ufshcd.c                     |   2 +
 drivers/ufs/host/ufs-mediatek-trace.h         |   6 +-
 drivers/usb/chipidea/udc.c                    |   7 +
 drivers/usb/dwc2/core.c                       |   1 +
 drivers/usb/dwc3/core.c                       |  19 +-
 drivers/usb/dwc3/core.h                       |   4 +
 drivers/usb/dwc3/gadget.c                     |   8 +-
 drivers/usb/gadget/function/f_fs.c            |  24 +-
 drivers/usb/gadget/udc/tegra-xudc.c           |  12 +-
 drivers/usb/host/xhci-tegra.c                 |  21 +-
 drivers/usb/typec/ucsi/psy.c                  |  30 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |   3 -
 drivers/vdpa/vdpa_sim/vdpa_sim.c              |   6 -
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   6 +-
 drivers/vhost/vdpa.c                          |   3 +-
 drivers/video/fbdev/core/fbcon.c              |   3 +-
 drivers/video/fbdev/core/fbcon.h              |   1 -
 drivers/video/fbdev/core/fbsysfs.c            |  36 +-
 drivers/video/fbdev/ffb.c                     |  14 +-
 drivers/video/fbdev/vt8500lcdfb.c             |   5 +-
 drivers/video/of_display_timing.c             |   4 +-
 drivers/watchdog/imx7ulp_wdt.c                |   1 +
 drivers/watchdog/it87_wdt.c                   |  12 +
 drivers/watchdog/rzv2h_wdt.c                  |   4 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c    |   4 +-
 fs/btrfs/block-group.c                        |   6 +-
 fs/btrfs/direct-io.c                          |  12 +
 fs/btrfs/extent-tree.c                        |  13 +-
 fs/btrfs/space-info.c                         |  21 +-
 fs/btrfs/volumes.c                            |  10 +-
 fs/btrfs/zoned.c                              |  29 ++
 fs/buffer.c                                   |   4 +
 fs/ceph/addr.c                                |  28 +-
 fs/ceph/file.c                                |  17 +-
 fs/dlm/lock.c                                 |  22 +-
 fs/erofs/super.c                              |  11 +-
 fs/erofs/zmap.c                               |   9 +-
 fs/ext4/extents.c                             |  11 +-
 fs/ext4/ioctl.c                               |   3 +
 fs/ext4/super.c                               |  10 +-
 fs/gfs2/inode.c                               |  16 +
 fs/hfsplus/dir.c                              |  46 +-
 fs/hfsplus/inode.c                            |  17 +-
 fs/hfsplus/super.c                            |  19 +-
 fs/jfs/jfs_logmgr.c                           |   1 +
 fs/jfs/namei.c                                |   6 +-
 fs/minix/inode.c                              |  50 ++-
 fs/namespace.c                                |   4 +-
 fs/netfs/read_collect.c                       |  10 +
 fs/netfs/read_retry.c                         |   4 +-
 fs/netfs/write_collect.c                      |   8 +-
 fs/netfs/write_issue.c                        |   1 +
 fs/nfsd/nfs4idmap.c                           |   4 +
 fs/nfsd/nfs4state.c                           |   3 +-
 fs/ntfs3/attrib.c                             |  19 +-
 fs/ntfs3/attrlist.c                           |   9 +
 fs/ntfs3/dir.c                                |   5 +-
 fs/ntfs3/fsntfs.c                             |  10 +-
 fs/ntfs3/index.c                              |   7 +-
 fs/ntfs3/inode.c                              |  13 +-
 fs/ntfs3/namei.c                              |  17 +-
 fs/ntfs3/run.c                                |  13 +-
 fs/ntfs3/xattr.c                              |   5 +-
 fs/ocfs2/xattr.c                              |   4 +
 fs/proc/base.c                                |   3 +
 fs/proc/task_mmu.c                            |   3 +-
 fs/pstore/ram_core.c                          |   7 +
 fs/smb/client/cached_dir.c                    |   4 +-
 fs/smb/client/connect.c                       |   2 +
 fs/smb/client/smb2misc.c                      |   6 +-
 fs/smb/client/smb2ops.c                       |  29 +-
 fs/smb/client/smb2pdu.c                       |   3 +
 fs/smb/client/trace.h                         |   1 +
 fs/smb/server/transport_rdma.c                |   4 +-
 fs/xfs/libxfs/xfs_attr.c                      |  75 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c                 |  49 ++-
 fs/xfs/scrub/agheader_repair.c                |  21 +-
 fs/xfs/scrub/alloc_repair.c                   |  20 +-
 fs/xfs/scrub/attr.c                           |  59 +--
 fs/xfs/scrub/attr_repair.c                    |  26 +-
 fs/xfs/scrub/bmap_repair.c                    |   6 +-
 fs/xfs/scrub/btree.c                          |   2 +
 fs/xfs/scrub/common.c                         |   7 +
 fs/xfs/scrub/common.h                         |  25 --
 fs/xfs/scrub/dabtree.c                        |   2 +
 fs/xfs/scrub/dir.c                            |  13 +-
 fs/xfs/scrub/dir_repair.c                     |  19 +-
 fs/xfs/scrub/dirtree.c                        |  19 +-
 fs/xfs/scrub/ialloc_repair.c                  |  25 +-
 fs/xfs/scrub/nlinks.c                         |   9 +-
 fs/xfs/scrub/parent.c                         |  11 +-
 fs/xfs/scrub/parent_repair.c                  |  23 +-
 fs/xfs/scrub/quotacheck.c                     |  13 +-
 fs/xfs/scrub/refcount_repair.c                |  13 +-
 fs/xfs/scrub/repair.c                         |   3 +
 fs/xfs/scrub/rmap_repair.c                    |   5 +-
 fs/xfs/scrub/rtbitmap_repair.c                |   6 +-
 fs/xfs/scrub/rtrefcount_repair.c              |  15 +-
 fs/xfs/scrub/rtrmap_repair.c                  |   5 +-
 fs/xfs/scrub/rtsummary.c                      |   7 +-
 fs/xfs/scrub/scrub.c                          |   2 +-
 include/acpi/ghes.h                           |   1 +
 include/asm-generic/audit_change_attr.h       |   3 +
 include/asm-generic/audit_read.h              |   6 +
 include/drm/drm_gem_shmem_helper.h            |  11 +
 include/drm/drm_of.h                          |   3 +
 include/linux/compiler-clang.h                |   2 +-
 include/linux/compiler_types.h                |  23 +-
 include/linux/cper.h                          |   3 +-
 include/linux/cpuset.h                        |   6 +-
 include/linux/fb.h                            |   1 -
 include/linux/ftrace.h                        |  13 +-
 include/linux/ftrace_regs.h                   |  25 ++
 include/linux/ima.h                           |   1 +
 include/linux/inetdevice.h                    |   2 +-
 include/linux/ipv6.h                          |   1 -
 include/linux/memcontrol.h                    |   6 +-
 include/linux/mfd/tps65219.h                  |   2 +
 include/linux/netdev_features.h               |  18 +
 include/linux/netdevice.h                     |   1 +
 include/linux/pci.h                           |   1 +
 include/linux/pci_ids.h                       |   1 +
 include/linux/trace_events.h                  |   5 +
 include/media/dvb_vb2.h                       |   6 +-
 include/net/bluetooth/l2cap.h                 |   8 +-
 include/net/inet_connection_sock.h            |   4 +-
 include/net/inet_sock.h                       |   1 +
 include/net/ioam6.h                           |   2 +
 include/net/ipv6.h                            |   4 +-
 include/net/sock.h                            |   2 +-
 include/net/tcp.h                             |   4 +-
 include/uapi/linux/hyperv.h                   |   2 +-
 include/uapi/linux/netfilter_bridge.h         |   4 +
 include/uapi/linux/vbox_vmmdev_types.h        |   4 +-
 io_uring/cmd_net.c                            |   9 +-
 io_uring/filetable.c                          |   4 +
 io_uring/net.c                                |   6 +-
 io_uring/openclose.c                          |   9 +-
 io_uring/timeout.c                            |   2 +-
 io_uring/zcrx.c                               |  13 +-
 kernel/bpf/crypto.c                           |   8 +-
 kernel/bpf/verifier.c                         |  63 ++-
 kernel/cgroup/cpuset.c                        |  84 ++--
 kernel/configs/debug.config                   |   1 -
 kernel/crash_dump_dm_crypt.c                  |  17 +-
 kernel/dma/direct.h                           |   2 +-
 kernel/events/core.c                          |  20 +-
 kernel/events/uprobes.c                       |   2 +-
 kernel/irq/cpuhotplug.c                       |   6 +-
 kernel/irq/internals.h                        |   2 +-
 kernel/irq/manage.c                           |  26 +-
 kernel/kexec_file.c                           | 131 +++---
 kernel/kexec_handover.c                       |   8 +-
 kernel/sched/debug.c                          |   7 +-
 kernel/trace/bpf_trace.c                      |   1 +
 kernel/trace/fgraph.c                         |  14 +-
 kernel/trace/ring_buffer.c                    |   9 +-
 kernel/trace/trace.c                          |   8 +-
 kernel/trace/trace_events.c                   |   3 +
 kernel/trace/trace_events_hist.c              |   4 +-
 kernel/trace/trace_hwlat.c                    |  15 +-
 kernel/watchdog.c                             |   2 +-
 lib/Kconfig.debug                             |  27 --
 mm/highmem.c                                  |   3 +-
 mm/hugetlb.c                                  |   9 +
 mm/memcontrol.c                               |  16 +-
 mm/numa_memblks.c                             |   9 +-
 mm/page_alloc.c                               |  32 +-
 mm/slab_common.c                              |   5 +-
 mm/slub.c                                     |  87 +++-
 mm/vmalloc.c                                  |   8 +
 mm/vmscan.c                                   |  34 +-
 net/9p/trans_xen.c                            |  85 ++--
 net/bluetooth/hci_conn.c                      |   5 +-
 net/bluetooth/hci_sync.c                      |   2 -
 net/bluetooth/l2cap_core.c                    |  95 +++--
 net/bluetooth/l2cap_sock.c                    |  15 +-
 net/ceph/crypto.c                             |   8 +-
 net/ceph/crypto.h                             |   2 +-
 net/ceph/messenger_v2.c                       |   2 +-
 net/core/dev.c                                | 123 +++++-
 net/core/gro.c                                |   2 +-
 net/core/skbuff.c                             |  23 +-
 net/ipv4/fib_lookup.h                         |   6 +-
 net/ipv4/fib_trie.c                           |   4 +-
 net/ipv4/igmp.c                               |   4 +-
 net/ipv4/syncookies.c                         |   2 +-
 net/ipv4/tcp_fastopen.c                       |   2 +-
 net/ipv4/tcp_input.c                          |  18 +-
 net/ipv4/tcp_ipv4.c                           |   8 +-
 net/ipv4/tcp_minisocks.c                      |   2 +-
 net/ipv4/udplite.c                            |   3 +-
 net/ipv6/af_inet6.c                           |   4 +-
 net/ipv6/exthdrs.c                            |  15 +-
 net/ipv6/icmp.c                               |   3 +-
 net/ipv6/ioam6.c                              |  14 +
 net/ipv6/ioam6_iptunnel.c                     |  10 +-
 net/ipv6/ip6_flowlabel.c                      |  44 +-
 net/ipv6/route.c                              |  24 +-
 net/ipv6/tcp_ipv6.c                           | 108 +++--
 net/ipv6/udplite.c                            |   3 +-
 net/ipv6/xfrm6_policy.c                       |   7 +-
 net/kcm/kcmsock.c                             |  21 +-
 net/mptcp/pm_kernel.c                         |  20 +-
 net/mptcp/subflow.c                           |   6 +-
 net/netfilter/nf_conntrack_h323_asn1.c        |   2 +-
 net/netfilter/nf_conntrack_proto_generic.c    |   1 +
 net/netfilter/xt_tcpmss.c                     |   2 +-
 net/nfc/nci/ntf.c                             | 159 ++++++-
 net/psp/psp_main.c                            |  39 +-
 net/rds/connection.c                          |   4 +
 net/rds/tcp_listen.c                          |   5 -
 net/sched/act_skbedit.c                       |   6 +-
 net/sched/bpf_qdisc.c                         |   8 +-
 net/sctp/ipv6.c                               |   8 +-
 net/smc/af_smc.c                              |   6 +-
 net/socket.c                                  |   2 +-
 net/tipc/crypto.c                             |   2 +-
 net/tipc/name_table.c                         |   6 +-
 net/tls/tls_sw.c                              |   2 +-
 net/vmw_vsock/vmci_transport.c                |   2 +-
 net/wireless/core.c                           |   8 +-
 net/wireless/wext-compat.c                    |   2 +-
 net/xfrm/espintcp.c                           |   2 +-
 net/xfrm/xfrm_device.c                        |  12 +-
 net/xfrm/xfrm_policy.c                        |  11 +-
 rust/Makefile                                 |   3 +
 rust/kernel/cpufreq.rs                        |   2 +
 rust/kernel/drm/driver.rs                     |   6 +-
 rust/kernel/irq/request.rs                    |  12 +-
 rust/kernel/list/impl_list_item_mod.rs        |  25 +-
 rust/pin-init/src/lib.rs                      |   4 +-
 scripts/cc-can-link.sh                        |   2 +-
 scripts/gendwarfksyms/dwarf.c                 |   4 +-
 scripts/gendwarfksyms/symbols.c               |   5 +-
 scripts/kernel-doc.py                         |  26 +-
 scripts/mod/modpost.c                         |   4 +
 scripts/package/kernel.spec                   |  64 ++-
 scripts/package/mkspec                        |  38 +-
 security/integrity/ima/ima_kexec.c            |  35 ++
 sound/core/oss/mixer_oss.c                    |  16 +
 sound/core/pcm_native.c                       |   4 +-
 sound/hda/codecs/conexant.c                   |   1 +
 sound/hda/codecs/hdmi/hdmi.c                  |   1 +
 sound/hda/codecs/realtek/alc269.c             | 217 +++++++++-
 .../hda/codecs/side-codecs/tas2781_hda_spi.c  |  20 +-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c       |  16 +
 sound/soc/amd/yc/acp6x-mach.c                 |   8 +-
 sound/soc/codecs/es8328.c                     |  10 +-
 sound/soc/codecs/max98390.c                   |   3 +
 sound/soc/codecs/rt721-sdca.c                 |   4 +-
 sound/soc/codecs/wm8962.c                     |  12 +-
 sound/soc/fsl/imx-rpmsg.c                     |   2 +-
 .../intel/common/soc-acpi-intel-arl-match.c   |  23 +-
 sound/soc/sof/intel/hda-dai.c                 |  14 +-
 sound/soc/sof/ipc4-control.c                  |  41 +-
 sound/soc/sof/ipc4-topology.c                 |  35 +-
 sound/soc/sof/ipc4.c                          |  44 +-
 sound/soc/sunxi/sun50i-dmic.c                 |   3 +
 sound/usb/endpoint.c                          |  40 +-
 sound/usb/mixer_s1810c.c                      |  36 +-
 sound/usb/quirks.c                            |   2 +
 tools/arch/arm64/include/uapi/asm/unistd.h    |  24 +-
 tools/bpf/bpftool/Makefile                    |   4 +-
 tools/include/linux/bitfield.h                |   1 +
 tools/lib/perf/Makefile                       |   2 +-
 tools/lib/subcmd/help.c                       |  10 +-
 tools/perf/Makefile.perf                      |   9 +-
 .../arch/loongarch/annotate/instructions.c    |  14 +-
 tools/perf/arch/s390/annotate/instructions.c  |  11 +-
 .../arch/x86/amdzen5/load-store.json          |   6 +-
 tools/perf/tests/make                         |   2 +-
 tools/perf/tests/shell/sched.sh               |   2 +-
 tools/perf/tests/shell/stat.sh                |   6 +-
 tools/perf/util/addr2line.c                   |   4 +-
 tools/perf/util/annotate.c                    |   2 +-
 tools/perf/util/capstone.c                    |  14 +-
 tools/perf/util/cs-etm.c                      |   3 +-
 tools/perf/util/disasm.c                      |  38 +-
 tools/perf/util/disasm.h                      |   2 +-
 tools/perf/util/dso.c                         |  63 ++-
 tools/perf/util/dso.h                         |  11 +-
 tools/perf/util/evsel_fprintf.c               |   8 +-
 tools/perf/util/libbfd.c                      |   6 +-
 tools/perf/util/llvm.c                        |   6 +-
 tools/perf/util/maps.c                        |   1 +
 tools/perf/util/symbol-elf.c                  |   2 +-
 tools/perf/util/unwind-libdw.c                |   7 +-
 tools/power/cpupower/lib/cpuidle.c            |   1 +
 tools/power/cpupower/utils/cpufreq-info.c     |   2 +-
 .../selftests/mm/charge_reserved_hugetlb.sh   |   4 +-
 tools/testing/selftests/ublk/kublk.h          |   2 +-
 tools/tracing/rtla/src/actions.c              |   2 +
 766 files changed, 7014 insertions(+), 3314 deletions(-)
 create mode 100644 arch/alpha/mm/tlbflush.c

-- 
2.51.0

