Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1DC40149C;
	Mon,  2 Mar 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467777; cv=none; b=YttWxscQ3i0eW8Oc7NUNIPQRQLvp5l0meOqjv0BemPoA3tZVAPObn+++Ie9est4fZUVcQ1L1Br4hvpXNnJiC54upcUEomfAq+LQWHjb1710RZv4WWdnb7Ic69liHjNJVQ8n/lDE4QeKMhFrvV8jnVcdvk4/O+0gXMJZ3m2bmbRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467777; c=relaxed/simple;
	bh=bXdVpyjUfRAoZw6xYxijTqpXlreaprWmt4m0q1BAgnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RF/Ddm9FPMiYl4rvSeZMYC3RRMI7R4923g1rgBZwdyqoa0rvxhsfbKN5SBUcnpouJCQrIWOG3LzAD7TwF4K9QAvMQYoJVs0GGsIanaPMN/AalceaUrS8gV7mFLYG+NlEZcLSEprMV+o8x2t2/HEOybAd3Vd13goupWIBPfuN7wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grxIYuha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grxIYuha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FDDC19423;
	Mon,  2 Mar 2026 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772467777;
	bh=bXdVpyjUfRAoZw6xYxijTqpXlreaprWmt4m0q1BAgnA=;
	h=From:To:Cc:Subject:Date:From;
	b=grxIYuha/ff3u9sqAjjXq7FdrlnzBWkiJjXRqYnguFxEwwGs+GxU6lUT2e8NESixy
	 aHq69QB68jIPtj+th6eq2LZWDvttivhqck3JkpZMO8M9HwJll8RrK3S2qQTt1vKVjH
	 TgmW5SqYWba9JL/3vQG16fEP1YBIEo2fj8H/rEYk5zwwOfRE7SuMRWnPnhh8Ytt0c+
	 6XDUjZqq6lJgVoPigvvybFc6rj5V75rS1/CDY/iOfGdXIBZz4HUbBxOm1dlJGaicSw
	 k5z6GmB7+FqwYkHOlEPgpd0CW3ycyV16PLwOpx2hpKsHUqf4XGW08Ac9Dul3BQzUz/
	 DiuWpOzTbLeag==
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
Subject: [PATCH 6.6 000/684] 6.6.128-rc2 review
Date: Mon,  2 Mar 2026 11:09:34 -0500
Message-ID: <20260302160934.2521545-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.128-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.128-rc2
X-KernelTest-Deadline: 2026-03-04T16:09+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.6.128 release.
There are 684 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar  4 04:09:32 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Abdun Nihaal (2):
  media: i2c/tw9903: Fix potential memory leak in tw9903_probe()
  media: i2c/tw9906: Fix potential memory leak in tw9906_probe()

Abhishek Bapat (1):
  quota: fix livelock between quotactl and freeze_super

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Adarsh Das (1):
  btrfs: replace BUG() with error handling in __btrfs_balance()

Adrian Hunter (1):
  i3c: master: Update hot-join flag only on success

Aleksandar Gerasimovski (1):
  phy: mvebu-cp110-utmi: fix dr_mode property read from dts

Aleksei Oladko (2):
  selftests: forwarding: vxlan_bridge_1d: fix test failure with
    br_netfilter enabled
  selftests: forwarding: vxlan_bridge_1d_ipv6: fix test failure with
    br_netfilter enabled

Alex Deucher (1):
  drm/amdgpu: avoid a warning in timedout job handler

Alex Elder (1):
  mfd: simple-mfd-i2c: Add SpacemiT P1 support

Alex Hung (1):
  drm/amd/display: Remove conditional for shaper 3DLUT power-on

Alex Williamson (1):
  PCI: Mark ASM1164 SATA controller to avoid bus reset

Alexander Egorenkov (1):
  s390/kexec: Make KEXEC_SIG available when CONFIG_MODULES=n

Alexander Grest (1):
  iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency

Alexander Koskovich (1):
  power: reset: nvmem-reboot-mode: respect cell size for
    nvmem_cell_write

Alexander Lobakin (1):
  cache: add __cacheline_group_{begin, end}_aligned() (+ couple more)

Alexander Stein (1):
  arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings

Alexandre Ferrieux (1):
  ASoC: codecs: aw88261: Fix erroneous bitmask logic in Awinic init

Alexey Simakov (1):
  ACPICA: Fix NULL pointer dereference in
    acpi_ev_address_space_dispatch()

Allison Henderson (1):
  net/rds: rds_sendmsg should not discard payload_len

Alok Tiwari (1):
  mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper

Alper Ak (3):
  tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
  tpm: st33zp24: Fix missing cleanup on get_burstcount() error
  media: qcom: camss: vfe: Fix out-of-bounds access in
    vfe_isr_reg_update()

Anders Grahn (1):
  netfilter: nft_counter: fix reset of counters on 32bit archs

Andrea Scian (1):
  mtd: rawnand: pl353: Fix software ECC support

Andreas Gruenbacher (3):
  gfs2: Retries missing in gfs2_{rename,exchange}
  gfs2: Add metapath_dibh helper
  gfs2: fiemap page fault fix

Andreas Larsson (1):
  sparc: Synchronize user stack on fork and clone

Andrey Vatoropin (1):
  fbcon: check return value of con2fb_acquire_newinfo()

André Draszik (1):
  regulator: core: move supply check earlier in
    set_machine_constraints()

Andy Shevchenko (1):
  platform/chrome: cros_typec_switch: Don't touch struct
    fwnode_handle::dev

AngeloGioacchino Del Regno (1):
  dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

Ankit Soni (1):
  iommu/amd: move wait_on_sem() out of spinlock

Anshumali Gaur (1):
  octeontx2-af: Fix PF driver crash with kexec kernel booting

Anthony Iliopoulos (2):
  nfsd: never defer requests during idmap lookup
  nfsd: fix return error code for nfsd_map_name_to_[ug]id

Anthony Pighin (Nokia) (1):
  rtc: interface: Alarm race handling should not discard preceding error

Antonio Borneo (1):
  coresight: etm3x: Fix cpulocked warning on cpuhp

Antoniu Miclaus (1):
  iio: gyro: itg3200: Fix unchecked return value in read_raw

Ard Biesheuvel (1):
  x86/kexec: Copy ACPI root pointer address from config table

Aristeu Rozanski (1):
  selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Armin Wolf (1):
  ACPICA: Abort AML bytecode execution when executing AML_FATAL_OP

Arnd Bergmann (4):
  scsi: ufs: host: mediatek: Require CONFIG_PM
  vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
  myri10ge: avoid uninitialized variable use
  scsi: buslogic: Reduce stack usage

Artem Shimko (1):
  serial: 8250_dw: handle clock enable errors in runtime_resume

Baochen Qiang (1):
  wifi: ath12k: fix preferred hardware mode calculation

Baokun Li (1):
  ext4: move ext4_percpu_param_init() before ext4_mb_init()

Barnabás Czémán (4):
  clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc
  clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
  backlight: qcom-wled: Support ovp values for PMI8994
  backlight: qcom-wled: Change PM8950 WLED configurations

Bartosz Golaszewski (1):
  clocksource/drivers/timer-integrator-ap: Add missing Kconfig
    dependency on OF

Baruch Siach (1):
  Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors

Ben Dooks (2):
  audit: move the compat_xxx_class[] extern declarations to audit_arch.h
  fs: add <linux/init_task.h> for 'init_fs'

Benjamin Gaignard (4):
  media: verisilicon: AV1: Fix enable cdef computation
  media: verisilicon: AV1: Fix tx mode bit setting
  media: verisilicon: AV1: Set IDR flag for intra_only frame type
  media: verisilicon: AV1: Fix tile info buffer size

Benjamin Marzinski (1):
  dm mpath: make pg_init_delay_msecs settable

Benson Leung (1):
  usb: typec: ucsi: psy: Fix voltage and current max for non-Fixed PDOs

Billy Tsai (2):
  i3c: Move device name assignment after i3c_bus_init
  gpio: aspeed-sgpio: Change the macro to support deferred probe

Bitterblue Smith (1):
  wifi: rtw88: 8822b: Avoid WARNING in rtw8822b_config_trx_mode()

Bjorn Helgaas (4):
  PCI: Move pci_read_bridge_windows() below individual window accessors
  PCI: Supply bridge device, not secondary bus, to read window details
  PCI: Log bridge windows conditionally
  PCI: Log bridge info when first enumerating bridge

Bo Sun (1):
  octeontx2-af: CGX: fix bitmap leaks

Boris Burkov (1):
  btrfs: fix block_group_tree dirty_list corruption

Breno Leitao (1):
  arm64: Disable branch profiling for all arm64 code

Brian Masney (2):
  openrisc: define arch-specific version of nop()
  clk: microchip: core: correct return value on *_get_parent()

Brian Norris (1):
  PCI/PM: Avoid redundant delays on D3hot->D3cold

Carl Lee (1):
  nfc: nxp-nci: remove interrupt trigger type

Casey Connolly (2):
  arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
  arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on

Ce Sun (1):
  drm/amdgpu: Adjust usleep_range in fence wait

Chaitanya Mishra (1):
  staging: greybus: lights: avoid NULL deref

Chen Jinghuang (1):
  sched/rt: Skip currently executing CPU in rto_next_cpu()

Chen Ni (2):
  ASoC: sunxi: sun50i-dmic: Add missing check for devm_regmap_init_mmio
  ASoC: codecs: max98390: Check return value of
    devm_gpiod_get_optional() in max98390_i2c_probe()

Chen-Yu Tsai (2):
  ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
  dmaengine: sun6i: Choose appropriate burst length under maxburst

Chengchang Tang (2):
  RDMA/hns: Fix WQ_MEM_RECLAIM warning
  RDMA/hns: Notify ULP of remaining soft-WCs during reset

Chenghai Huang (3):
  crypto: hisilicon/zip - adjust the way to obtain the req in the
    callback function
  crypto: hisilicon/trng - modifying the order of header files
  crypto: hisilicon/qm - move the barrier before writing to the mailbox
    register

Chin-Ting Kuo (1):
  spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end

Chin-Yen Lee (1):
  wifi: rtw89: wow: add reason codes for disassociation in WoWLAN mode

Chris Brandt (2):
  clk: renesas: rzg2l: Fix intin variable size
  clk: renesas: rzg2l: Select correct div round macro

Christian Loehle (1):
  cpuidle: menu: Cleanup after loadavg removal

Christoph Hellwig (1):
  iomap: fix submission side handling of completion side errors

Christophe Leroy (1):
  powerpc/uaccess: Move barrier_nospec() out of
    allow_read_{from/write}_user()

Chuck Lever (7):
  RDMA/core: Fix a couple of obvious typos in comments
  svcrdma: Remove queue-shortening warnings
  svcrdma: Clean up comment in svc_rdma_accept()
  svcrdma: Increase the per-transport rw_ctx count
  svcrdma: Reduce the number of rdma_rw contexts per-QP
  RDMA/core: add rdma_rw_max_sge() helper for SQ sizing
  SUNRPC: auth_gss: fix memory leaks in XDR decoding error paths

Clément Le Goffic (1):
  dmaengine: stm32-mdma: initialize m2m_hw_period and ccr to fix
    warnings

Coco Li (2):
  cache: enforce cache groups
  netns-ipv4: reorganize netns_ipv4 fast path variables

Colin Ian King (1):
  scsi: csiostor: Fix dereference of null pointer rn

Colin Lord (1):
  tracing: Fix false sharing in hwlat get_sample()

Cristian Ciocaltea (3):
  ASoC: nau8821: Consistently clear interrupts before unmasking
  ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
  ASoC: nau8821: Fixup nau8821_enable_jack_detect()

Cupertino Miranda (1):
  bpf: verifier improvement in 32bit shift sign extension pattern

Damien Le Moal (1):
  ata: libata-scsi: refactor ata_scsi_translate()

Dan Carpenter (3):
  EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
  EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
  apparmor: use passed in gfp flags in aa_alloc_null()

Daniel Gomez (1):
  dm: replace -EEXIST with -EBUSY

Daniel Hodges (2):
  SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
  tipc: fix RCU dereference race in tipc_aead_users_dec()

Daniel Machon (2):
  net: sparx5/lan969x: fix DWRR cost max to match hardware register
    width
  net: sparx5/lan969x: fix PTP clock max_adj value

Daniel Palmer (1):
  m68k: nommu: fix memmove() with differently aligned src and dest for
    68000

Darrick J. Wong (4):
  xfs: mark data structures corrupt on EIO and ENODATA
  xfs: delete attr leaf freemap entries when empty
  xfs: fix freemap adjustments when adding xattrs to leaf blocks
  xfs: fix remote xattr valuelblk check

David Heidelberg (1):
  media: ccs: Accommodate C-PHY into the calculation

David Phillips (1):
  HID: elecom: Add support for ELECOM HUGE Plus M-HT1MRBK

David Plowman (3):
  media: i2c: ov5647: Correct pixel array offset
  media: i2c: ov5647: Correct minimum VBLANK value
  media: i2c: ov5647: Sensor should report RAW color space

Deepak Kumar (1):
  spi: stm32: fix Overrun issue at < 8bpw

Deepakkumar Karn (1):
  fs/buffer: add alert in try_to_free_buffers() for folios without
    buffers

Deepanshu Kartikey (1):
  gfs2: Fix use-after-free in iomap inline data write path

Denis Pauk (1):
  hwmon: (nct6775) Add ASUS Pro WS WRX90E-SAGE SE

Detlev Casanova (1):
  ASoC: rockchip: i2s-tdm: Use param rate if not provided by set_sysclk

Dian-Syuan Yang (1):
  wifi: rtw89: pci: restore LDO setting after device resume

Diksha Kumari (1):
  staging: rtl8723bs: fix memory leak on failure path

Dikshita Agarwal (1):
  media: venus: vdec: restrict EOS addr quirk to IRIS2 only

Ding Hui (1):
  dm: remove fake timeout to avoid leak request

Diogo Ivo (1):
  arm64: tegra: smaug: Add usb-role-switch support

Dmitry Baryshkov (6):
  arm64: dts: qcom: sdm630: fix gpu_speed_bin size
  arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
  arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
  drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x
  drm/msm/a2xx: fix pixel shader start on A225
  clk: qcom: gfx3d: add parent to parent request map

Dmytro Maluka (1):
  iommu/vt-d: Flush cache for PASID table before using it

Donet Tom (1):
  drm/amdkfd: Fix GART PTE for non-4K pagesize in svm_migrate_gart_map()

Douglas Anderson (1):
  mfd: core: Add locking around 'mfd_of_node_list'

Duoming Zhou (2):
  net: wan: farsync: Fix use-after-free bugs caused by unfinished
    tasklets
  atm: fore200e: fix use-after-free in tasklets during device removal

Dzmitry Sankouski (1):
  mfd: simple-mfd-i2c: Add MAX77705 support

Edward Adam Davis (1):
  fs/ntfs3: prevent infinite loops caused by the next valid being the
    same

Eric Biggers (1):
  dm-verity: correctly handle dm_bufio_client_create() failure

Eric Dumazet (14):
  tcp: tcp_tx_timestamp() must look at the rtx queue
  inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP
  ipv6: fix a race in ip6_sock_set_v6only()
  ping: annotate data-races in ping_lookup()
  macvlan: observe an RCU grace period in macvlan_common_newlink() error
    path
  icmp: move icmp_global.credit and icmp_global.stamp to per netns
    storage
  icmp: icmp_msgs_per_sec and icmp_msgs_burst sysctls become per netns
  icmp: prevent possible overflow in icmp_global_allow()
  tcp: defer regular ACK while processing socket backlog
  inet: move icmp_global_{credit,stamp} to a separate cache line
  ipv6: annotate data-races in ip6_multipath_hash_{policy,fields}()
  ipv6: exthdrs: annotate data-race over multiple sysctl
  gro: change the BUG_ON() in gro_pull_from_frag0()
  ipv4: igmp: annotate data-races around idev->mr_maxdelay

Eric Joyner (1):
  ionic: Rate limit unknown xcvr type messages

Ethan Nelson-Moore (3):
  net: usb: sr9700: remove code to drive nonexistent multicast filter
  net: ethernet: marvell: skge: remove incorrect conflicting PCI ID
  net: intel: fix PCI device ID conflict between i40e and ipw2200

Ethan Tidmore (2):
  x86/hyperv: Fix error pointer dereference
  staging: rtl8723bs: fix null dereference in find_network

Etienne AUJAMES (1):
  IB/cache: update gid cache on client reregister event

Felix Gu (4):
  fbdev: of_display_timing: Fix device node reference leak in
    of_get_display_timings()
  fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
  pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
  spi: wpcm-fiu: Fix potential NULL pointer dereference in
    wpcm_fiu_probe()

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Filipe Manana (2):
  btrfs: qgroup: return correct error when deleting qgroup relation item
  btrfs: fix invalid leaf access in btrfs_quota_enable() if ref key not
    found

Florian Westphal (5):
  netfilter: nf_tables: reset table validation state on abort
  netfilter: nft_compat: add more restrictions on netlink attributes
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
  netfilter: xt_tcpmss: check remaining length before reading optlen

Francesco Lavra (1):
  spi: tools: Add include folder to .gitignore

Frank Li (1):
  i3c: master: svc: Initialize 'dev' to NULL in svc_i3c_master_ibi_isr()

Frederic Weisbecker (2):
  rcu: s/boost_kthread_mutex/kthread_mutex
  rcu/exp: Move expedited kthread worker creation functions above
    rcutree_prepare_cpu()

Fredrik Markstrom (1):
  i3c: dw: Initialize spinlock to avoid upsetting lockdep

Geert Uytterhoeven (1):
  clk: Move clk_{save,restore}_context() to COMMON_CLK section

Geetha sowjanya (1):
  octeontx2-af: Workaround SQM/PSE stalls by disabling sticky

George Moussalem (1):
  clk: qcom: gcc-ipq5018: flag sleep clock as critical

Georgia Garcia (1):
  apparmor: fix invalid deref of rawdata when export_binary is unset

Gerd Rausch (1):
  net/rds: No shortcut out of RDS_CONN_ERROR

Giovanni Cabiddu (1):
  crypto: qat - fix warning on adf_pfvf_pf_proto.c

Govindarajulu Varadarajan (1):
  ublk: Validate SQE128 flag before accessing the cmd

Greg Kroah-Hartman (1):
  Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"

Greg Thelen (1):
  selftests/memfd: delete unused declarations

Guangshuo Li (1):
  powerpc/smp: Add check for kcalloc() failure in parse_thread_groups()

Guenter Roeck (1):
  Revert "hwmon: (ibmpex) fix use-after-free in high/low store"

Gui-Dong Han (2):
  PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
  rpmsg: core: fix race in driver_override_show() and use core helper

Gustavo Salvini (1):
  ASoC: amd: yc: Add DMI quirk for ASUS Vivobook Pro 15X M6501RR

Günther Noack (3):
  HID: magicmouse: Do not crash on missing msc->input
  HID: prodikeys: Check presence of pm->input_ep82
  HID: logitech-hidpp: Check maxfield in hidpp_get_report_length()

Haiyang Zhang (1):
  tcp: Set pingpong threshold via sysctl

Hangbin Liu (1):
  bonding: alb: fix UAF in rlb_arp_recv during bond up/down

Hans Verkuil (4):
  media: dvb-core: dmxdevfilter must always flush bufs
  media: omap3isp: isp_video_mbus_to_pix/pix_to_mbus fixes
  media: omap3isp: isppreview: always clamp in preview_try_format()
  media: omap3isp: set initial format

Hans de Goede (5):
  media: i2c: ov01a10: Fix the horizontal flip control
  media: i2c: ov01a10: Fix reported pixel-rate value
  media: i2c: ov01a10: Fix analogue gain range
  media: i2c: ov01a10: Add missing v4l2_subdev_cleanup() calls
  media: i2c: ov01a10: Fix test-pattern disabling

Haotian Zhang (9):
  clk: qcom: Return correct error code in qcom_cc_probe_by_index()
  soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in
    cmd_db_dev_probe
  HID: playstation: Add missing check for input_ff_create_memless
  PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
  power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
  clk: mediatek: Fix error handling in runtime PM setup
  mfd: arizona: Fix regulator resource leak on
    wm5102_clear_write_sequencer() failure
  leds: qcom-lpg: Check the return value of regmap_bulk_write()
  jfs: Add missing set_freezable() for freezable kthread

Haotien Hsu (1):
  usb: gadget: tegra-xudc: Add handling for BLCG_COREPLL_PWRDN

Haoxiang Li (11):
  PCI/MSI: Unmap MSI-X region on error
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

Hariprasad Kelam (2):
  octeontx2-pf: Unregister devlink on probe failure
  octeontx2-af: Fix default entries mcam entry action

Harshit Mogalapalli (2):
  iio: sca3000: Fix a resource leak in sca3000_probe()
  x86/kexec: add a sanity check on previous kernel's ima kexec buffer

Heiko Carstens (1):
  s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS

Helge Deller (1):
  parisc: Prevent interrupts during reboot

Heming Zhao (1):
  ocfs2: fix reflink preserve cleanup issue

Henrique Carvalho (2):
  smb: client: add proper locking around ses->iface_last_update
  smb: client: prevent races in ->query_interfaces()

Henry Tseng (1):
  ata: libata: avoid long timeouts on hot-unplugged SATA DAS

Honggang LI (1):
  RDMA/rtrs: server: remove dead code

Hou Tao (1):
  PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails

Hou Wenlong (1):
  x86/xen/pvh: Enable PAE mode for 32-bit guest only when CONFIG_X86_PAE
    is set

Hsieh Hung-En (1):
  ASoC: es8328: Add error unwind in resume

Hsiu-Ming Chang (1):
  wifi: rtw88: rtw8821cu: Add ID for Mercusys MU6H

Huacai Chen (1):
  LoongArch: Prefer top-down allocation after arch_mem_init()

Håkon Bugge (4):
  PCI: Do not attempt to set ExtTag for VFs
  PCI: Initialize RCB from pci_configure_device()
  PCI/ACPI: Restrict program_hpx_type2() to AER bits
  net/rds: Clear reconnect pending bit

Ian Rogers (4):
  perf test stat: Update test expectations and events
  perf unwind-libdw: Fix invalid reference counts
  perf callchain: Fix srcline printing with inlines
  libperf build: Always place libperf includes first

Ido Schimmel (1):
  selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2

Ilpo Järvinen (1):
  PCI: Add defines for bridge window indexing

Ilya Dryomov (1):
  libceph: define and enforce CEPH_MAX_KEY_LEN

Inseo An (1):
  netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Ioana Ciornei (2):
  mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
  mfd: simple-mfd-i2c: Keep compatible strings in alphabetical order

Irui Wang (1):
  media: mediatek: encoder: Fix uninitialized scalar variable issue

Iuliana Prodan (1):
  remoteproc: imx_dsp_rproc: Skip RP_MBOX_SUSPEND_SYSTEM when mailbox TX
    channel is uninitialized

Jack Wang (1):
  md/bitmap: fix GPF in write_page caused by resize race

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

Jagadeesh Kona (3):
  clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
  clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops

Jai Luthra (2):
  media: i2c: ov5647: Initialize subdev before controls
  media: i2c: ov5647: Fix PIXEL_RATE value for VGA mode

Jakub Kicinski (2):
  bpftool: Fix truncated netlink dumps
  net: consume xmit errors of GSO frames

James Clark (1):
  libperf: Don't remove -g when EXTRA_CFLAGS are used

Jan Kara (1):
  ext4: use optimized mballoc scanning regardless of inode format

Jani Nikula (1):
  drm/i915/wakeref: clean up INTEL_WAKEREF_PUT_* flag macros

Janne Grunau (2):
  arm64: dts: apple: t8112-j473: Keep the HDMI port powered on
  clk: clk-apple-nco: Add "apple,t8103-nco" compatible

Jared Kangas (1):
  dmaengine: fsl-edma: don't explicitly disable clocks in .remove()

Jason Andryuk (1):
  xenbus: Use .freeze/.thaw to handle xenbus devices

Jason Gunthorpe (1):
  RDMA/efa: Fix typo in efa_alloc_mr()

Jeffrey Bencteux (2):
  audit: add fchmodat2() to change attributes class
  audit: add missing syscalls to read class

Jens Axboe (3):
  io_uring/sync: validate passed in offset
  io_uring/cancel: de-unionize file and user_data in struct
    io_cancel_data
  io_uring/filetable: clamp alloc_hint to the configured alloc range

Jerome Brunet (4):
  arm64: dts: amlogic: axg: assign the MMC signal clocks
  arm64: dts: amlogic: gx: assign the MMC signal clocks
  arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
  arm64: dts: amlogic: g12: assign the MMC A signal clock

Ji-Ze Hong (Peter Hong) (1):
  hwmon: (f71882fg) Add F81968 support

Jian Shen (1):
  net: hns3: fix double free issue for tx spare buffer

Jian Zhang (1):
  net: mctp-i2c: fix duplicate reception of old data

Jiasheng Jiang (3):
  RDMA/rxe: Fix double free in rxe_srq_from_init
  fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
  md-cluster: fix NULL pointer dereference in process_metadata_update

Jiaxun Yang (1):
  MIPS: rb532: Fix MMIO UART resource registration

Jiayuan Chen (6):
  bpf, sockmap: Fix incorrect copied_seq calculation
  bpf, sockmap: Fix FIONREAD for sockmap
  net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
  xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path
  serial: caif: fix use-after-free in caif_serial ldisc_close()
  xfrm6: fix uninitialized saddr in xfrm6_get_saddr()

Jijie Shao (1):
  net: hns3: extend HCLGE_FD_AD_QID to 11 bits

Jinhui Guo (2):
  iommu/vt-d: Flush dev-IOTLB only when PCIe device is accessible in
    scalable mode
  PCI: Fix pci_slot_trylock() error handling

Jinjie Ruan (3):
  spi: wpcm-fiu: Use devm_platform_ioremap_resource_byname()
  spi: wpcm-fiu: Fix uninitialized res
  spi: wpcm-fiu: Simplify with dev_err_probe()

Jinliang Zheng (1):
  procfs: fix missing RCU protection when reading real_parent in
    do_task_stat()

Jinqian Yang (1):
  arm64: Add support for TSV110 Spectre-BHB mitigation

Jinwang Li (1):
  Bluetooth: hci_qca: Cleanup on all setup failures

Jiri Pirko (1):
  RDMA/core: Fix stale RoCE GIDs during netdev events at registration

Jisheng Zhang (1):
  usb: dwc2: fix resume failure if dr_mode is host

Joel Fernandes (1):
  rcu: Refactor expedited handling check in rcu_read_unlock_special()

Joey Bednar (1):
  HID: apple: Add "SONiX KN85 Keyboard" to the list of non-apple
    keyboards

Johan Hovold (1):
  soc: ti: k3-socinfo: Fix regmap leak on probe failure

Johannes Berg (1):
  wifi: cfg80211: wext: fix IGTK key ID off-by-one

John Garry (2):
  MIPS: Loongson: Make cpumask_of_node() robust against NUMA_NO_NODE
  LoongArch: Make cpumask_of_node() robust against NUMA_NO_NODE

John Johansen (7):
  apparmor: fix NULL sock in aa_sock_file_perm
  apparmor: fix rlimit for posix cpu timers
  apparmor: provide separate audit messages for file and policy checks
  apparmor: refcount the pdb
  apparmor: remove apply_modes_to_perms from label_match
  apparmor: make label_match return a consistent value
  apparmor: fix aa_label to return state from compount and component
    match

Johnny-CC Chang (1):
  PCI: Mark Nvidia GB10 to avoid bus reset

Jonathan Kim (1):
  drm/amdkfd: fix debug watchpoints for logical devices

Jonathan Marek (2):
  spi-geni-qcom: initialize mode related registers to 0
  spi-geni-qcom: use xfer->bits_per_word for can_dma()

Jorge Ramirez-Ortiz (1):
  soc: qcom: smem: handle ENOMEM error during probe

Jori Koolstra (2):
  minix: Add required sanity checking to minix_check_superblock()
  jfs: nlink overflow in jfs_rename

Josh Poimboeuf (1):
  kbuild: Add objtool to top-level clean target

Juergen Gross (1):
  x86/xen: make some functions static

Jun Yan (1):
  arm64: dts: rockchip: Do not enable hdmi_sound node on Pinebook Pro

Junrui Luo (1):
  dpaa2-switch: validate num_ifs to prevent out-of-bounds write

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kaushlendra Kumar (3):
  drm/i915/acpi: free _DSM package when no connectors
  tools/power cpupower: Reset errno before strtoull()
  thermal: int340x: Fix sysfs group leak on DLVR registration failure

Kees Cook (1):
  media: solo6x10: Check for out of bounds chip_id

Keith Busch (1):
  PCI: Fix pci_slot_lock () device locking

Kery Qi (1):
  watchdog: starfive-wdt: Fix PM reference leak in probe error path

Kevin Hao (2):
  net: cpsw_new: Fix unnecessary netdev unregistration in cpsw_probe()
    error path
  net: macb: Fix tx/rx malfunction after phy link down and up

Kiryl Shutsemau (Meta) (1):
  efi: Fix reservation of unaccepted memory table

Koichiro Den (1):
  NTB: ntb_transport: Fix too small buffer for debugfs_name

Kommula Shiva Shankar (1):
  vhost: fix caching attributes of MMIO regions by setting them
    explicitly

Konrad Dybcio (2):
  arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions
  cpufreq: dt-platdev: Block the driver from probing on more QC
    platforms

Konstantin Andreev (2):
  smack: /smack/doi must be > 0
  smack: /smack/doi: accept previously used values

Konstantin Komarov (2):
  fs/ntfs3: drop preallocated clusters for sparse and compressed files
  fs/ntfs3: avoid calling run_get_entry() when run == NULL in
    ntfs_read_run_nb_ra()

Krishna Chaitanya Chundru (1):
  PCI: Add ACS quirk for Qualcomm Hamoa & Glymur

Krzysztof Kozlowski (1):
  nvmem: Drop OF node reference on nvmem_add_one_cell() failure

Kuniyuki Iwashima (2):
  ipv6: Fix out-of-bound access in fib6_add_rt2node().
  ipv4: fib: Annotate access to struct fib_alias.fa_state.

Kuppuswamy Sathyanarayanan (1):
  powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check

Lai Jiangshan (3):
  workqueue: Factor out assign_rescuer_work()
  workqueue: Only assign rescuer work when really needed
  workqueue: Process rescuer work items one-by-one using a cursor

Leo Yan (2):
  perf: arm_spe: Properly set hw.state on failures
  tools: Fix bitfield dependency failure

Leon Romanovsky (1):
  xfrm: skip templates check for packet offload tunnel mode

Li Chen (4):
  nvdimm: virtio_pmem: serialize flush requests
  ext4: mark group add fast-commit ineligible
  ext4: mark group extend fast-commit ineligible
  kexec: derive purgatory entry from symbol

Li Nan (1):
  md/raid10: fix any_working flag handling in raid10_sync_request

Li Wang (1):
  selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs

Li Zhijian (1):
  RDMA/rxe: Fix race condition in QP timer handlers

Liang Jie (1):
  staging: rtl8723bs: fix missing status update on sdio_alloc_irq()
    failure

Lianqin Hu (1):
  ALSA: usb-audio: Add iface reset and delay quirk for AB13X USB Audio

Linus Torvalds (1):
  Remove WARN_ALL_UNSEEDED_RANDOM kernel config option

Linus Walleij (2):
  ata: pata_ftide010: Fix some DMA timings
  net: ethernet: xscale: Check for PTP support properly

Longfang Liu (1):
  hisi_acc_vfio_pci: update status after RAS error

Luca Ceresoli (1):
  drm: of: drm_of_panel_bridge_remove(): fix device_node leak

Luca Weiss (1):
  pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition

Ludovic Desroches (3):
  drm/atmel-hlcdc: fix memory leak from the atomic_destroy_state
    callback
  drm/atmel-hlcdc: don't reject the commit if the src rect has
    fractional parts
  drm/atmel-hlcdc: fix use-after-free of drm_crtc_commit after release

Luiz Augusto von Dentz (4):
  Bluetooth: L2CAP: Fix invalid response to L2CAP_ECRED_RECONF_REQ
  Bluetooth: L2CAP: Fix response to L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix not checking output MTU is acceptable on
    L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix missing key size check for L2CAP_LE_CONN_REQ

Maciej Grochowski (2):
  ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
  ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut

Mahadevan P (1):
  drm/msm/disp/dpu: add merge3d support for sc7280

Malaya Kumar Rout (1):
  tools/power/x86/intel-speed-select: Fix file descriptor leak in
    isolate_cpus()

Manikanta Maddireddy (1):
  PCI: endpoint: Fix swapped parameters in
    pci_{primary/secondary}_epc_epf_unlink() functions

Manivannan Sadhasivam (1):
  PCI: Enable ACS after configuring IOMMU for OF platforms

Marc Zyngier (2):
  arm64: Force the use of CNTVCT_EL0 in __delay()
  arm64: Fix sampling the "stable" virtual counter in preemptible
    section

Marco Elver (1):
  arm64: Fix non-atomic __READ_ONCE() with CONFIG_LTO=y

Marcus Folkesson (1):
  Revert "mfd: da9052-spi: Change read-mask to write-mask"

Mario Kleiner (1):
  drm/amd/display: Use same max plane scaling limits for all 64 bpp
    formats

Mario Limonciello (AMD) (3):
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Mark Brown (1):
  mailbox: pcc: Remove spurious IRQF_ONESHOT usage

Markus Perkins (1):
  misc: eeprom: Fix EWEN/EWDS/ERAL commands for 93xx56 and 93xx66

Martin Blumenstingl (1):
  clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Martin Pålsson (1):
  net: usb: lan78xx: scan all MDIO addresses on LAN7801

Masami Hiramatsu (Google) (1):
  tracing: Fix to set write permission to per-cpu buffer_size_kb

Matt Johnston (2):
  mctp i2c: initialise event handler read bytes
  ipmi: ipmb: initialise event handler read bytes

Matt Whitlock (1):
  dm-unstripe: fix mapping bug when there are multiple targets in a
    table

Matthew Schwartz (1):
  mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Mauro Carvalho Chehab (3):
  EFI/CPER: don't dump the entire memory region
  APEI/GHES: ensure that won't go past CPER allocated record
  EFI/CPER: don't go past the ARM processor CPER record buffer

Md Haris Iqbal (2):
  rnbd-srv: Zero the rsp buffer before using it
  RDMA/rtrs-clt: For conn rejection use actual err number

Mehdi Djait (1):
  media: i2c: ov01a10: Fix digital gain range

Miaoqian Lin (1):
  tracing: Properly process error handling in event_hist_trigger_parse()

Michael Liang (1):
  dm: clear cloned request bio pointer when last clone bio completes

Michael Thalmeier (1):
  net: nfc: nci: Fix parameter validation for packet data

Mikulas Patocka (3):
  dm: use bio_clone_blkg_association
  dm-integrity: fix a typo in the code for write/discard race
  dm-integrity: fix recalculation in bitmap mode

Ming Qian (1):
  media: amphion: Clear last_buffer_dequeued flag for DEC_CMD_START

Mingj Ye (1):
  net: usb: r8152: fix transmit queue timeout

Miquel Raynal (2):
  mtd: spinand: Fix kernel doc
  spi: spi-mem: Limit octal DTR constraints to octal DTR situations

Miri Korenblit (2):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave
  wifi: iwlwifi: mvm: check the validity of noa_len

Moteen Shah (1):
  serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA
    termination is done

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Nicholas Kazlauskas (1):
  drm/amd/display: Ensure link output is disabled in backend reset for
    PLL_ON

Nicolas Cavallari (1):
  PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]

Nicolas Dufresne (1):
  media: mediatek: vcodec: Don't try to decode 422/444 VP9

Niklas Schnelle (3):
  s390/pci: Handle futile config accesses of disabled devices directly
  Revert "PCI/IOV: Add PCI rescan-remove locking when enabling/disabling
    SR-IOV"
  PCI/IOV: Fix race between SR-IOV enable/disable and hotplug

Niklas Söderlund (1):
  clocksource/drivers/sh_tmu: Always leave device running after probe

Nikolay Aleksandrov (1):
  net: bridge: mcast: always update mdb_n_entries for vlan contexts

Nuno Sá (1):
  dma: dma-axi-dmac: fix SW cyclic transfers

Oleksandr Suvorov (1):
  watchdog: imx7ulp_wdt: handle the nowayout option

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Oliver Neukum (1):
  HID: hid-pl: handle probe errors

Ondrej Mosnacek (2):
  ipc: don't audit capability check in ipc_permissions()
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Otto Pflüger (2):
  mailbox: sprd: mask interrupts that are not handled
  mailbox: sprd: clear delivery flag before handling TX done

Pablo Neira Ayuso (2):
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous
    sets
  net: remove WARN_ON_ONCE when accessing forward path array

Paolo Abeni (1):
  mptcp: fix receive space timestamp initialization

Paul Chaignon (1):
  bpf: Fix bpf_xdp_store_bytes proto for read-only arg

Paulo Alcantara (1):
  smb: client: fix potential UAF and double free in smb2_open_file()

Peng Fan (1):
  remoteproc: imx_rproc: Fix invalid loaded resource table detection

Peter Ujfalusi (5):
  soundwire: dmi-quirks: add mapping for Avell B.ON (OEM rebranded of
    NUC15)
  ASoC: SOF: ipc4-control: If there is no data do not send bytes update
  ASoC: SOF: ipc4-topology: Correct the allocation size for bytes
    controls
  ASoC: SOF: ipc4-control: Use the correct size for
    scontrol->ipc_control_data
  ASoC: SOF: ipc4-control: Keep the payload size up to date

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Petr Mladek (2):
  module: add helper function for reading module_buildid()
  kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()

Petr Pavlu (2):
  tracing: Fix checking of freed trace_event_file for hist files
  tracing: Wake up poll waiters for hist files when removing an event

Petre Rodan (1):
  iio: pressure: mprls0025pa: fix scan_type struct

Phil Sutter (1):
  include: uapi: netfilter_bridge.h: Cover for musl libc

Prashanth K (1):
  usb: dwc3: gadget: Move vbus draw to workqueue context

Puranjay Mohan (1):
  selftests/bpf: veristat: fix printing order in output_stats()

Purva Yeshi (1):
  Documentation: trace: Refactor toctree

Qanux (1):
  ipv6: ioam: fix heap buffer overflow in __ioam6_fill_trace_data()

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Rafael J. Wysocki (1):
  cpuidle: governors: menu: Always check timers with tick stopped

Randy Dunlap (2):
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

Renjiang Han (1):
  media: venus: vdec: fix error state assignment for zero bytesused

René Rebe (4):
  net: sunhme: Fix sbus regression
  modpost: Amend ppc64 save/restfpr symnames for -Os build
  fix it87_wdt early reboot by reporting running timer
  fbdev: ffb: fix corrupted video output on Sun FFB1

Ricardo Ribalda (1):
  media: uvcvideo: Fix allocation for small frame sizes

Robert Marko (1):
  mfd: simple-mfd-i2c: Add Delta TN48M CPLD support

Robin Murphy (2):
  perf/arm-cmn: Support CMN-600AE
  perf/arm-cmn: Reject unsupported hardware configurations

Roger Pau Monne (1):
  Partial revert "x86/xen: fix balloon target initialization for PVH
    dom0"

Romain Gantois (1):
  fpga: of-fpga-region: Fail if any bridge is missing

Roman Penyaev (1):
  RDMA/rtrs-srv: fix SG mapping

Roman Peshkichev (1):
  wifi: rtw88: fix DTIM period handling when conf->dtim_period is zero

Ross Vandegrift (1):
  wifi: ath11k: add pm quirk for Thinkpad Z13/Z16 Gen1

Rui Wang (1):
  media: rkisp1: Fix filter mode register configuration

Ruipeng Qi (1):
  pstore: ram_core: fix incorrect success return when vmap() fails

Ruitong Liu (1):
  net/sched: act_skbedit: fix divide-by-zero in tcf_skbedit_hash()

Ryan Lee (1):
  apparmor: return -ENOMEM in unpack_perms_table upon alloc failure

Sagi Grimberg (1):
  fs/nfs: Fix readdir slow-start regression

Sai Ritvik Tanksalkar (1):
  pstore/ram: fix buffer overflow in persistent_ram_save_old()

Sakari Ailus (2):
  media: v4l2-async: Fix error handling on steps after finding a match
  media: ccs: Avoid possible division by zero

Salah Triki (1):
  s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Sam James (1):
  sparc: don't reference obsolete termio struct for TC* constants

Samuel Wu (1):
  PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Sasha Levin (1):
  Linux 6.6.128-rc2

Sean Christopherson (1):
  KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3()
    succeeding

Sean V Kelley (1):
  ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Sebastian Andrzej Siewior (8):
  scsi: efct: Use IRQF_ONESHOT and default primary handler
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT
  perf/cxlpmu: Replace IRQF_ONESHOT with IRQF_NO_THREAD
  mailbox: bcm-ferxrm-mailbox: Use default primary handler
  char: tpm: cr50: Remove IRQF_ONESHOT
  iio: Use IRQF_NO_THREAD
  iio: magnetometer: Remove IRQF_ONESHOT

Sebastian Krzyszkowiak (2):
  ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
  ASoC: wm8962: Don't report a microphone if it's shorted to ground on
    plug

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

Shaurya Rane (1):
  media: radio-keene: fix memory leak in error path

Shawn Lin (1):
  PCI: dw-rockchip: Disable BAR 0 and BAR 1 for Root Port

Shay Drory (3):
  net/mlx5: Fix multiport device check over light SFs
  net/mlx5: DR, Fix circular locking dependency in dump
  net/mlx5: Fix missing devlink lock in SRIOV enable error path

Shell Chen (1):
  Bluetooth: btusb: Add new VID/PID for RTL8852CE

Shengjiu Wang (3):
  ASoC: dt-bindings: asahi-kasei,ak4458: set unevaluatedProperties:false
  ASoC: dt-bindings: asahi-kasei,ak4458: Fix the supply names
  ASoC: dt-bindings: asahi-kasei,ak5558: Fix the supply names

Shinas Rasheed (4):
  octeon_ep: support to fetch firmware info
  octeon_ep: restructured interrupt handlers
  octeon_ep: support Octeon CN10K devices
  octeon_ep: set backpressure watermark for RX queues

Shuai Xue (1):
  Documentation: tracing: Add PCI tracepoint documentation

Shyam Prasad N (2):
  cifs: Fix locking usage for tcon fields
  cifs: some missing initializations on replay

Sri Jayaramappa (1):
  libsubcmd: Fix null intersection case in exclude_cmds()

Srinivasan Shanmugam (2):
  drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init
  drm/amdkfd: Fix watch_id bounds checking in debug address watch v2

Stanislav Fomichev (2):
  net: Add skb_dstref_steal and skb_dstref_restore
  net: Switch to skb_dstref_steal/skb_dstref_restore for ip_route_input
    callers

Stefan Metzmacher (1):
  smb: client: correct value for smbd_max_fragmented_recv_size

Stefan Sørensen (2):
  Bluetooth: hci_conn: Set link_policy on incoming ACL connections
  Bluetooth: hci_conn: use mod_delayed_work for active mode timeout

Steven Rostedt (1):
  tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR
    macros

Sunday Clement (1):
  drm/amdkfd: Fix out-of-bounds write in kfd_event_page_set()

Suraj Kandpal (1):
  drm/display/dp_mst: Add protection against 0 vcpi

SurajSonawane2415 (1):
  docs: fix WARNING document not included in any toctree

Svyatoslav Ryhel (1):
  drivers: iio: mpu3050: use dev_err_probe for regulator request

Szymon Wilczek (2):
  media: pvrusb2: fix URB leak in pvr2_send_request_ex
  wifi: libertas: fix WARNING in usb_tx_block

Takashi Iwai (2):
  ALSA: usb-audio: Update the number of packets properly at receiving
  ALSA: usb-audio: Add sanity check for OOB writes at silencing

Taniya Das (1):
  clk: qcom: rcg2: compute 2d using duty fraction directly

Teddy Astie (1):
  xen/virtio: Don't use grant-dma-ops when running as Dom0

Tetsuo Handa (2):
  hfsplus: pretend special inodes as regular files
  xfrm: always flush state and policy upon NETDEV_UNREGISTER event

Thadeu Lima de Souza Cascardo (1):
  fpga: dfl: use subsys_initcall to allow built-in drivers to be added

Thomas Bogendoerfer (1):
  bonding: only set speed/duplex to unknown, if getting speed failed

Thomas Fourier (6):
  auxdisplay: arm-charlcd: fix release_mem_region() size
  crypto: cavium - fix dma_free_coherent() size
  crypto: octeontx - fix dma_free_coherent() size
  net: wan/fsl_ucc_hdlc: Fix dma_free_coherent() in uhdlc_memclean()
  fbdev: vt8500lcdfb: fix missing dma_free_coherent()
  net: ethernet: ec_bhf: Fix dma_free_coherent() dma handle

Thomas Gleixner (1):
  hrtimer: Fix trace oddity

Thomas Richter (2):
  perf test stat tests: Fix for virtualized machines
  s390/perf: Disable register readout on sampling events

Thomas Weissschuh (1):
  ARM: 9467/1: mm: Don't use %pK through printk

Thomas Weißschuh (4):
  ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
  hyper-v: Mark inner union in hv_kvp_exchg_msg_value as packed
  virt: vbox: uapi: Mark inner unions in packed structs as packed
  binder: don't use %pK through printk

Thomas Yen (1):
  scsi: ufs: core: Flush exception handling work when RPM level is zero

Thomas Zimmermann (1):
  fbcon: Remove struct fbcon_display.inverse

Thorsten Schmelzer (2):
  media: adv7180: fix frame interval in progressive mode
  HID: multitouch: add eGalaxTouch EXC3188 support

Tiezhu Yang (2):
  LoongArch: Guard percpu handler under !CONFIG_PREEMPT_RT
  LoongArch: Disable instrumentation for setup_ptwalker()

Tim Huang (1):
  drm/amdgpu: add support for HDP IP version 6.1.1

Tom Lendacky (1):
  crypto: ccp - Move direct access to some PSP registers out of TEE

Tomas Melin (1):
  rtc: zynqmp: correct frequency value

Tung Nguyen (1):
  tipc: fix duplicate publication key in tipc_service_insert_publ()

Tuo Li (3):
  of: unittest: fix possible null-pointer dereferences in
    of_unittest_property_copy()
  ACPI: processor: Fix NULL-pointer dereference in
    acpi_processor_errata_piix4()
  misc: bcm_vk: Fix possible null-pointer dereferences in bcm_vk_read()

Tzung-Bi Shih (2):
  platform/chrome: cros_ec_lightbar: Fix response size initialization
  remoteproc: mediatek: Break lock dependency to `prepare_lock`

Uwe Kleine-König (2):
  PCI/portdrv: Fix potential resource leak
  dmaengine: fsl-edma-main: Convert to platform remove callback
    returning void

Vahagn Vardanian (1):
  netfilter: nf_conntrack_h323: fix OOB read in decode_choice()

Val Packett (1):
  power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer

Varun R Mallya (1):
  libbpf: Fix OOB read in btf_dump_get_bitfield_value

Vasiliy Kovalev (1):
  KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()

Viacheslav Dubeyko (1):
  hfsplus: fix volume corruption issue for generic/498

Vimlesh Kumar (2):
  octeon_ep: disable per ring interrupts
  octeon_ep: ensure dbell BADDR updation

Vincent Donnefort (1):
  Documentation: tracing: Add ring-buffer mapping

Vladimir Oltean (1):
  net: ixp4xx_eth: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()

Vladimir Zapolskiy (3):
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node
  clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs

Vlastimil Babka (1):
  mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP
    allocations

Votokina Victoria (1):
  nfc: hci: shdlc: Stop timers and work before freeing context

Waqar Hameed (9):
  power: supply: ab8500: Fix use-after-free in power_supply_changed()
  power: supply: act8945a: Fix use-after-free in power_supply_changed()
  power: supply: bq256xx: Fix use-after-free in power_supply_changed()
  power: supply: bq25980: Fix use-after-free in power_supply_changed()
  power: supply: cpcap-battery: Fix use-after-free in
    power_supply_changed()
  power: supply: goldfish: Fix use-after-free in power_supply_changed()
  power: supply: rt9455: Fix use-after-free in power_supply_changed()
  power: supply: sbs-battery: Fix use-after-free in
    power_supply_changed()
  power: supply: wm97xx: Fix NULL pointer dereference in
    power_supply_changed()

Wayne Lin (1):
  drm/amd/display: Avoid updating surface with the same surface under
    MPO

Wei Li (1):
  pinctrl: single: fix refcount leak in pcs_add_gpio_func()

Weigang He (2):
  mtd: parsers: ofpart: fix OF node refcount leak in
    parse_fixed_partitions()
  fbdev: of: display_timing: fix refcount leak in
    of_get_display_timings()

Weili Qian (1):
  crypto: hisilicon/trng - support tfms sharing the device

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

Xu Yang (1):
  phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature

Yang Shen (2):
  crypto: hisilicon/zip - support deflate algorithm
  crypto: hisilicon/zip - remove zlib and gzip

Yao Kai (1):
  rcu: Fix rcu_read_unlock() deadloop due to softirq

Yao Zi (1):
  MIPS: Work around LLVM bug when gp is used as global register variable

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Yoshihiro Shimoda (1):
  PCI: Add PCIE_MSG_CODE_ASSERT_INTx message macros

Yosry Ahmed (1):
  KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation

Yu Kuai (1):
  blk-mq-debugfs: add missing debugfs_mutex in
    blk_mq_debugfs_register_hctxs()

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuto Hamaguchi (1):
  netfilter: nf_conntrack: Add allow_clash to generic protocol handler

Yuxiong Wang (1):
  cxl: Fix premature commit_end increment on decoder commit failure

Zhai Can (1):
  ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO

Zhang Yi (1):
  ext4: don't cache extent during splitting extent

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zilin Guan (6):
  soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()
  mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()
  scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()
  drm/amdgpu: Fix memory leak in amdgpu_acpi_enumerate_xcc()
  drm/amdgpu: Fix memory leak in amdgpu_ras_init()
  ext4: fix memory leak in ext4_ext_shift_extents()

Ziyi Guo (12):
  wifi: ath10k: sdio: add missing lock protection in
    ath10k_sdio_fw_crashed_dump()
  net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
  net: mscc: ocelot: split xmit into FDMA and register injection paths
  net: mscc: ocelot: add missing lock protection in
    ocelot_port_xmit_inj()
  net: usb: catc: enable basic endpoint checking
  xen-netback: reject zero-queue configuration from guest
  ASoC: fsl_xcvr: Revert fix missing lock in fsl_xcvr_mode_put()
  wifi: iwlegacy: add missing mutex protection in
    il4965_store_tx_power()
  wifi: iwlegacy: add missing mutex protection in
    il3945_store_measurement()
  wifi: ath10k: fix lock protection in
    ath10k_wmi_event_peer_sta_ps_state_chg()
  net: usb: kaweth: remove TX queue manipulation in kaweth_set_rx_mode
  net: usb: pegasus: enable basic endpoint checking

Zqiang (1):
  rcu: Remove local_irq_save/restore() in
    rcu_preempt_deferred_qs_handler()

decce6 (2):
  drm/amdgpu: Add HAINAN clock adjustment
  drm/radeon: Add HAINAN clock adjustment

ethanwu (2):
  ceph: supply snapshot context in ceph_uninline_data()
  ceph: supply snapshot context in ceph_zero_partial_object()

gongqi (1):
  ALSA: hda/conexant: Add headset mic fix for MECHREVO Wujie 15X Pro

jinbaohong (2):
  btrfs: handle user interrupt properly in btrfs_trim_fs()
  btrfs: continue trimming remaining devices on failure

 Documentation/PCI/endpoint/pci-vntb-howto.rst |  14 +-
 .../bindings/sound/asahi-kasei,ak4458.yaml    |   6 +-
 .../bindings/sound/asahi-kasei,ak5558.yaml    |   4 +-
 .../ethernet/marvell/octeon_ep.rst            |   4 +
 Documentation/networking/ip-sysctl.rst        |  20 +
 Documentation/trace/events-pci.rst            |  74 ++
 Documentation/trace/index.rst                 |  95 +-
 Documentation/trace/ring-buffer-map.rst       | 106 ++
 Makefile                                      |  15 +-
 .../boot/dts/allwinner/sun5i-a13-utoo-p66.dts |   1 +
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi        |   3 +-
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm/mach-omap2/control.c                 |  14 +-
 arch/arm/mm/physaddr.c                        |   2 +-
 arch/arm64/Kbuild                             |   4 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 arch/arm64/boot/dts/apple/t8112-j473.dts      |  19 +
 .../freescale/imx8mp-tqma8mpql-mba8mpxl.dts   |   2 +-
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts |   2 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |   4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   8 +-
 .../boot/dts/qcom/sdm845-oneplus-common.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi          |   8 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts |   4 -
 arch/arm64/include/asm/rwonce.h               |   2 +-
 arch/arm64/kernel/proton-pack.c               |   1 +
 arch/arm64/lib/delay.c                        |  23 +-
 arch/loongarch/include/asm/topology.h         |   2 +-
 arch/loongarch/kernel/setup.c                 |   1 +
 arch/loongarch/kernel/unwind_prologue.c       |   2 +-
 arch/loongarch/mm/tlb.c                       |   2 +-
 arch/m68k/lib/memmove.c                       |  18 +
 .../include/asm/mach-loongson64/topology.h    |   2 +-
 arch/mips/kernel/relocate.c                   |  13 +
 arch/mips/rb532/devices.c                     |   5 +-
 arch/openrisc/include/asm/barrier.h           |   2 +
 arch/parisc/kernel/drivers.c                  |   2 +-
 arch/parisc/kernel/process.c                  |   3 +
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/include/asm/kup.h                |   2 -
 arch/powerpc/include/asm/uaccess.h            |   4 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 +-
 arch/powerpc/kernel/smp.c                     |   2 +
 arch/s390/Kconfig                             |   3 +-
 arch/s390/kernel/perf_cpum_sf.c               |   2 +-
 arch/s390/pci/pci.c                           |  25 +-
 arch/s390/purgatory/Makefile                  |   1 +
 arch/sparc/include/uapi/asm/ioctls.h          |   8 +-
 arch/sparc/kernel/process.c                   |  38 +-
 arch/x86/hyperv/hv_vtl.c                      |   8 +-
 arch/x86/kernel/kexec-bzimage64.c             |   7 +
 arch/x86/kernel/setup.c                       |   6 +
 arch/x86/kvm/svm/nested.c                     |   3 +-
 arch/x86/kvm/svm/svm.c                        |   5 +-
 arch/x86/kvm/x86.c                            |   2 +
 arch/x86/platform/pvh/head.S                  |   2 +
 arch/x86/xen/enlighten.c                      |   2 +-
 arch/x86/xen/mmu.h                            |   4 -
 arch/x86/xen/mmu_pv.c                         |  11 +-
 arch/x86/xen/xen-ops.h                        |   1 -
 block/blk-mq-debugfs.c                        |   2 +
 drivers/acpi/acpi_processor.c                 |  28 +-
 drivers/acpi/acpica/evregion.c                |   4 +-
 drivers/acpi/acpica/exoparg3.c                |  46 +-
 drivers/acpi/apei/ghes.c                      |   6 +-
 drivers/acpi/cppc_acpi.c                      |   4 +-
 drivers/acpi/power.c                          |  13 +
 drivers/android/binder.c                      |   2 +-
 drivers/android/binder_alloc.c                |   6 +-
 drivers/ata/libata-core.c                     |  24 +
 drivers/ata/libata-eh.c                       |   3 +-
 drivers/ata/libata-scsi.c                     |  84 +-
 drivers/ata/libata.h                          |   1 +
 drivers/ata/pata_ftide010.c                   |   6 +-
 drivers/atm/fore200e.c                        |   4 +
 drivers/auxdisplay/arm-charlcd.c              |   2 +-
 drivers/base/power/wakeirq.c                  |   9 +-
 drivers/base/power/wakeup.c                   |   4 +-
 drivers/block/rnbd/rnbd-srv.c                 |   3 +
 drivers/block/ublk_drv.c                      |   6 +-
 drivers/bluetooth/btusb.c                     |   3 +
 drivers/bluetooth/hci_qca.c                   |  24 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c               |   6 +-
 drivers/char/ipmi/ipmi_ipmb.c                 |   5 +
 drivers/char/random.c                         |  12 +-
 drivers/char/tpm/st33zp24/st33zp24.c          |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |   6 +-
 drivers/char/tpm/tpm_tis_i2c_cr50.c           |   3 +-
 drivers/char/tpm/tpm_tis_spi_cr50.c           |   2 +-
 drivers/clk/clk-apple-nco.c                   |   1 +
 drivers/clk/mediatek/clk-mtk.c                |  12 +-
 drivers/clk/meson/gxbb.c                      |  17 +-
 drivers/clk/microchip/clk-core.c              |  25 +-
 drivers/clk/qcom/clk-rcg2.c                   |   7 +-
 drivers/clk/qcom/common.c                     |   2 +-
 drivers/clk/qcom/dispcc-sdm845.c              |   4 +-
 drivers/clk/qcom/gcc-ipq5018.c                |   1 +
 drivers/clk/qcom/gcc-msm8917.c                |   1 -
 drivers/clk/qcom/gcc-msm8953.c                |   1 -
 drivers/clk/qcom/gcc-qdu1000.c                |   4 +-
 drivers/clk/qcom/gcc-sdx75.c                  |   4 +-
 drivers/clk/qcom/gcc-sm8450.c                 |   4 +-
 drivers/clk/qcom/gcc-sm8550.c                 |   4 +-
 drivers/clk/renesas/rzg2l-cpg.c               |   6 +-
 drivers/clk/tegra/clk-tegra124-emc.c          |   4 +-
 drivers/clocksource/Kconfig                   |   1 +
 drivers/clocksource/sh_tmu.c                  |  18 -
 drivers/cpufreq/cpufreq-dt-platdev.c          |   3 +
 drivers/cpuidle/cpuidle.c                     |  10 +
 drivers/cpuidle/governors/menu.c              |  39 +-
 drivers/crypto/cavium/cpt/cptvf_main.c        |   3 +-
 drivers/crypto/ccp/psp-dev.c                  |  71 ++
 drivers/crypto/ccp/psp-dev.h                  |  18 +
 drivers/crypto/ccp/sp-dev.c                   |  12 +
 drivers/crypto/ccp/sp-dev.h                   |   6 +
 drivers/crypto/ccp/sp-pci.c                   |  34 +-
 drivers/crypto/ccp/tee-dev.c                  |  95 +-
 drivers/crypto/ccp/tee-dev.h                  |  16 +-
 drivers/crypto/hisilicon/qm.c                 |   6 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |  62 +-
 drivers/crypto/hisilicon/trng/trng.c          | 123 ++-
 drivers/crypto/hisilicon/zip/zip_crypto.c     | 302 +-----
 drivers/crypto/hisilicon/zip/zip_main.c       |   4 +-
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |  10 +
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |   3 +-
 drivers/cxl/core/hdm.c                        |   3 +-
 drivers/dma/dma-axi-dmac.c                    |   3 +-
 drivers/dma/fsl-edma-main.c                   |   7 +-
 drivers/dma/mediatek/mtk-uart-apdma.c         |  10 +-
 drivers/dma/stm32-mdma.c                      |   2 +-
 drivers/dma/sun6i-dma.c                       |  26 +-
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/firmware/efi/cper-arm.c               |  12 +-
 drivers/firmware/efi/cper.c                   |   8 +-
 drivers/firmware/efi/efi.c                    |   8 +-
 drivers/fpga/dfl.c                            |   2 +-
 drivers/fpga/of-fpga-region.c                 |   8 +-
 drivers/gpio/gpio-aspeed-sgpio.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c      |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c       |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c       |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c        |  38 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c       |   5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c      |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |   8 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_plane.c   |   5 +
 .../drm/amd/display/dc/dcn31/dcn31_hwseq.c    |  16 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_mpc.c  |   3 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c    |   5 +
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   |  25 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   3 +-
 drivers/gpu/drm/drm_property.c                |   2 +-
 drivers/gpu/drm/i915/display/intel_acpi.c     |   1 +
 drivers/gpu/drm/i915/intel_wakeref.c          |   2 +-
 drivers/gpu/drm/i915/intel_wakeref.h          |  14 +-
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c         |   5 +-
 .../msm/disp/dpu1/catalog/dpu_7_2_sc7280.h    |  14 +-
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  |   7 +-
 drivers/gpu/drm/radeon/si_dpm.c               |   5 +
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +
 drivers/hid/Kconfig                           |   1 +
 drivers/hid/hid-apple.c                       |   1 +
 drivers/hid/hid-elecom.c                      |  16 +
 drivers/hid/hid-ids.h                         |   4 +
 drivers/hid/hid-logitech-hidpp.c              |   2 +-
 drivers/hid/hid-magicmouse.c                  |   5 +
 drivers/hid/hid-multitouch.c                  |   3 +
 drivers/hid/hid-pl.c                          |   7 +-
 drivers/hid/hid-playstation.c                 |   4 +-
 drivers/hid/hid-prodikeys.c                   |   4 +
 drivers/hid/hid-quirks.c                      |   3 +
 drivers/hwmon/f71882fg.c                      |   6 +-
 drivers/hwmon/ibmpex.c                        |   9 +-
 drivers/hwmon/nct6775-platform.c              |   1 +
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |   6 +-
 drivers/i3c/master/dw-i3c-master.c            |   2 +
 drivers/i3c/master/svc-i3c-master.c           |   4 +-
 drivers/iio/accel/bma180.c                    |   5 +-
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/adc/ad7766.c                      |   2 +-
 drivers/iio/gyro/itg3200_buffer.c             |   8 +-
 drivers/iio/gyro/itg3200_core.c               |   2 +
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/iio/light/si1145.c                    |   2 +-
 drivers/iio/magnetometer/ak8975.c             |   2 +-
 drivers/iio/pressure/mprls0025pa.c            |   4 +-
 drivers/infiniband/core/cache.c               |  16 +-
 drivers/infiniband/core/core_priv.h           |   3 +
 drivers/infiniband/core/device.c              |  34 +-
 drivers/infiniband/core/rw.c                  |  53 +-
 drivers/infiniband/core/umem_dmabuf.c         |   4 +-
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  26 +-
 drivers/infiniband/sw/rxe/rxe_comp.c          |   3 +
 drivers/infiniband/sw/rxe/rxe_req.c           |   3 +
 drivers/infiniband/sw/rxe/rxe_srq.c           |   6 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |   4 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |  33 +-
 drivers/iommu/amd/iommu.c                     |  25 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  31 +-
 drivers/iommu/intel/pasid.c                   |   9 +-
 drivers/leds/rgb/leds-qcom-lpg.c              |   8 +-
 drivers/mailbox/bcm-flexrm-mailbox.c          |  14 +-
 drivers/mailbox/imx-mailbox.c                 |   8 +-
 drivers/mailbox/pcc.c                         |   2 +-
 drivers/mailbox/sprd-mailbox.c                |  20 +-
 drivers/md/dm-exception-store.c               |   2 +-
 drivers/md/dm-integrity.c                     |  15 +-
 drivers/md/dm-log.c                           |   2 +-
 drivers/md/dm-mpath.c                         |   2 +-
 drivers/md/dm-path-selector.c                 |   2 +-
 drivers/md/dm-rq.c                            |  16 +-
 drivers/md/dm-target.c                        |   2 +-
 drivers/md/dm-unstripe.c                      |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/dm.c                               |   2 +
 drivers/md/md-bitmap.c                        |   3 +-
 drivers/md/md-cluster.c                       |   7 +-
 drivers/md/raid10.c                           |   2 +-
 drivers/media/dvb-core/dmxdev.c               |   8 +-
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/i2c/adv7180.c                   |   7 +
 drivers/media/i2c/ccs/ccs-core.c              |  18 +-
 drivers/media/i2c/ov01a10.c                   |  44 +-
 drivers/media/i2c/ov5647.c                    |  24 +-
 drivers/media/i2c/tw9903.c                    |   1 +
 drivers/media/i2c/tw9906.c                    |   1 +
 drivers/media/pci/cx23885/cx23885-alsa.c      |   4 +-
 drivers/media/pci/cx25821/cx25821-alsa.c      |   1 +
 drivers/media/pci/cx25821/cx25821-core.c      |   1 +
 drivers/media/pci/cx88/cx88-alsa.c            |   4 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c    |   8 +-
 drivers/media/platform/amphion/vdec.c         |   1 +
 .../platform/mediatek/mdp/mtk_mdp_core.c      |  17 +-
 .../vcodec/decoder/mtk_vcodec_dec_stateless.c |   6 +
 .../mediatek/vcodec/encoder/mtk_vcodec_enc.c  |   6 +-
 .../media/platform/qcom/camss/camss-vfe-480.c |   6 +-
 drivers/media/platform/qcom/venus/vdec.c      |  14 +-
 .../platform/rockchip/rkisp1/rkisp1-params.c  |   6 -
 .../media/platform/ti/omap3isp/isppreview.c   |  21 +-
 drivers/media/platform/ti/omap3isp/ispvideo.c |  14 +-
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c  |  43 +-
 drivers/media/radio/radio-keene.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c       |   5 +
 drivers/media/usb/uvc/uvc_video.c             |   3 +-
 drivers/media/v4l2-core/v4l2-async.c          |  45 +-
 drivers/mfd/Kconfig                           |  24 +
 drivers/mfd/arizona-core.c                    |   2 +-
 drivers/mfd/da9052-spi.c                      |   2 +-
 drivers/mfd/mfd-core.c                        |  36 +-
 drivers/mfd/simple-mfd-i2c.c                  |  33 +-
 drivers/misc/bcm-vk/bcm_vk_msg.c              |  12 +-
 drivers/misc/eeprom/eeprom_93xx46.c           |  11 +-
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/mtd/nand/raw/pl35x-nand-controller.c  |   1 +
 drivers/mtd/parsers/ofpart_core.c             |  16 +-
 drivers/mtd/parsers/tplink_safeloader.c       |   1 +
 drivers/net/bonding/bond_main.c               |  21 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 drivers/net/ethernet/cadence/macb_main.c      |  11 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   7 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  11 +-
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |   5 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   8 +-
 .../net/ethernet/marvell/octeon_ep/Makefile   |   3 +-
 .../marvell/octeon_ep/octep_cn9k_pf.c         | 189 +++-
 .../marvell/octeon_ep/octep_cnxk_pf.c         | 935 ++++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_config.h |  32 +-
 .../marvell/octeon_ep/octep_ctrl_net.c        |  24 +-
 .../marvell/octeon_ep/octep_ctrl_net.h        |  18 +
 .../ethernet/marvell/octeon_ep/octep_main.c   | 233 ++++-
 .../ethernet/marvell/octeon_ep/octep_main.h   |  21 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   5 +
 .../marvell/octeon_ep/octep_regs_cnxk_pf.h    | 404 ++++++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |   8 +-
 .../net/ethernet/marvell/octeontx2/af/cgx.c   |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  12 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |  41 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   1 +
 drivers/net/ethernet/marvell/skge.c           |   1 -
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   2 +
 .../mellanox/mlx5/core/steering/dr_dbg.c      |   4 +-
 .../ethernet/microchip/sparx5/sparx5_ptp.c    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_qos.h    |   2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  75 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  28 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   7 +-
 drivers/net/ethernet/sun/sunhme.c             |   3 +
 drivers/net/ethernet/ti/cpsw_new.c            |  12 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  60 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c      |   3 +
 drivers/net/macvlan.c                         |   5 +
 drivers/net/mctp/mctp-i2c.c                   |   9 +
 drivers/net/usb/Kconfig                       |   1 -
 drivers/net/usb/catc.c                        |  37 +-
 drivers/net/usb/kaweth.c                      |   2 -
 drivers/net/usb/lan78xx.c                     |   2 -
 drivers/net/usb/pegasus.c                     |  35 +-
 drivers/net/usb/r8152.c                       |   2 +
 drivers/net/usb/sr9700.c                      |  25 +-
 drivers/net/usb/sr9700.h                      |   7 +-
 drivers/net/wan/farsync.c                     |   2 +
 drivers/net/wan/fsl_ucc_hdlc.c                |   8 +-
 drivers/net/wireless/ath/ath10k/sdio.c        |   6 +
 drivers/net/wireless/ath/ath10k/wmi.c         |   4 +-
 drivers/net/wireless/ath/ath11k/core.c        |  28 +
 drivers/net/wireless/ath/ath12k/wmi.c         |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   8 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  14 +
 .../net/wireless/marvell/libertas/if_usb.c    |   2 +
 drivers/net/wireless/realtek/rtw88/main.c     |   4 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   2 +-
 .../net/wireless/realtek/rtw88/rtw8821cu.c    |   2 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   3 +-
 drivers/net/wireless/realtek/rtw89/pci.c      |   1 +
 drivers/net/wireless/realtek/rtw89/wow.c      |   4 +
 drivers/net/wireless/realtek/rtw89/wow.h      |   1 +
 drivers/net/xen-netback/xenbus.c              |   5 +-
 drivers/nfc/nxp-nci/i2c.c                     |   2 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c        |  12 +-
 drivers/ntb/ntb_transport.c                   |   4 +-
 drivers/nvdimm/nd_virtio.c                    |   3 +-
 drivers/nvdimm/virtio_pmem.c                  |   1 +
 drivers/nvdimm/virtio_pmem.h                  |   4 +
 drivers/nvmem/core.c                          |   1 +
 drivers/of/unittest.c                         |   6 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |   8 +
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/endpoint/pci-ep-cfs.c             |   8 +-
 drivers/pci/iov.c                             |   9 +-
 drivers/pci/msi/msi.c                         |   4 +-
 drivers/pci/p2pdma.c                          |   1 +
 drivers/pci/pci-acpi.c                        |  59 +-
 drivers/pci/pci-driver.c                      |   8 +
 drivers/pci/pci.c                             |  40 +-
 drivers/pci/pci.h                             |  26 +
 drivers/pci/pcie/aer.c                        |   3 -
 drivers/pci/pcie/portdrv.c                    |   6 +-
 drivers/pci/probe.c                           | 189 ++--
 drivers/pci/quirks.c                          |  27 +
 drivers/perf/arm-cmn.c                        |  19 +-
 drivers/perf/arm_spe_pmu.c                    |  18 +-
 drivers/perf/cxl_pmu.c                        |   2 +-
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c    |   1 +
 drivers/phy/marvell/phy-mvebu-cp110-utmi.c    |   2 +-
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 .../pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c   |   2 +-
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/platform/chrome/cros_typec_switch.c   |   6 +-
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
 drivers/power/supply/ab8500_charger.c         |  40 +-
 drivers/power/supply/act8945a_charger.c       |  16 +-
 drivers/power/supply/bq256xx_charger.c        |  12 +-
 drivers/power/supply/bq25980_charger.c        |  12 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/cpcap-battery.c          |   8 +-
 drivers/power/supply/goldfish_battery.c       |  12 +-
 drivers/power/supply/qcom_battmgr.c           |   3 +-
 drivers/power/supply/rt9455_charger.c         |  17 +-
 drivers/power/supply/sbs-battery.c            |  36 +-
 drivers/power/supply/wm97xx_battery.c         |  34 +-
 drivers/powercap/intel_rapl_tpmi.c            |   2 +-
 drivers/rapidio/rio-scan.c                    |   3 +-
 drivers/regulator/core.c                      |  55 +-
 drivers/remoteproc/imx_dsp_rproc.c            |   9 +
 drivers/remoteproc/imx_rproc.c                |   4 +
 drivers/remoteproc/mtk_scp.c                  |  39 +-
 drivers/remoteproc/mtk_scp_ipi.c              |   4 +-
 drivers/rpmsg/rpmsg_core.c                    |  66 +-
 drivers/rtc/interface.c                       |   2 +-
 drivers/rtc/rtc-zynqmp.c                      |   3 +
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/BusLogic.c                       |   6 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/scsi/elx/efct/efct_driver.c           |   8 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |  13 +-
 drivers/soc/mediatek/mtk-svs.c                |   5 +-
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/qcom/smem.c                       |   4 +-
 drivers/soc/ti/k3-socinfo.c                   |   2 +-
 drivers/soc/ti/pruss.c                        |   6 +-
 drivers/soundwire/dmi-quirks.c                |  11 +
 drivers/spi/spi-geni-qcom.c                   |  14 +-
 drivers/spi/spi-mem.c                         |  26 +-
 drivers/spi/spi-stm32.c                       |   9 +-
 drivers/spi/spi-wpcm-fiu.c                    |  19 +-
 drivers/staging/greybus/light.c               |   8 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c     |   6 +-
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   3 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c  |   3 +-
 .../int340x_thermal/processor_thermal_rfim.c  |   5 +-
 drivers/tty/serial/8250/8250_dw.c             |  11 +-
 drivers/tty/serial/8250/8250_omap.c           |   2 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/ufs/core/ufshcd.c                     |   2 +
 drivers/ufs/host/Kconfig                      |   1 +
 drivers/ufs/host/ufs-mediatek.c               |  12 +-
 drivers/usb/dwc2/core.c                       |   1 +
 drivers/usb/dwc3/core.c                       |  19 +-
 drivers/usb/dwc3/core.h                       |   4 +
 drivers/usb/dwc3/gadget.c                     |   8 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/usb/gadget/udc/tegra-xudc.c           |  12 +-
 drivers/usb/typec/ucsi/psy.c                  |  30 +-
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   3 +-
 drivers/vhost/vdpa.c                          |   1 +
 drivers/video/backlight/qcom-wled.c           |  42 +-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/video/fbdev/core/fbcon.c              |   3 +-
 drivers/video/fbdev/core/fbcon.h              |   1 -
 drivers/video/fbdev/ffb.c                     |  14 +-
 drivers/video/fbdev/vt8500lcdfb.c             |   5 +-
 drivers/video/of_display_timing.c             |  10 +-
 drivers/watchdog/imx7ulp_wdt.c                |   1 +
 drivers/watchdog/it87_wdt.c                   |  12 +
 drivers/watchdog/starfive-wdt.c               |   2 +-
 drivers/xen/balloon.c                         |  19 +-
 drivers/xen/grant-dma-ops.c                   |   3 +-
 drivers/xen/unpopulated-alloc.c               |   3 +
 drivers/xen/xenbus/xenbus_probe_frontend.c    |   4 +-
 fs/btrfs/extent-tree.c                        |  13 +-
 fs/btrfs/qgroup.c                             |  15 +-
 fs/btrfs/transaction.c                        |   7 -
 fs/btrfs/volumes.c                            |  10 +-
 fs/buffer.c                                   |   4 +
 fs/ceph/addr.c                                |  24 +-
 fs/ceph/file.c                                |  17 +-
 fs/ext4/extents.c                             |   9 +-
 fs/ext4/ioctl.c                               |   3 +
 fs/ext4/mballoc.c                             |   2 -
 fs/ext4/super.c                               |  10 +-
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                |  21 +-
 fs/gfs2/glock.c                               |  36 +-
 fs/gfs2/glock.h                               |   3 +-
 fs/gfs2/inode.c                               |  34 +-
 fs/hfsplus/bnode.c                            |   2 +-
 fs/hfsplus/inode.c                            |  12 +-
 fs/hfsplus/super.c                            |   6 +
 fs/iomap/direct-io.c                          |  10 +-
 fs/jfs/jfs_logmgr.c                           |   1 +
 fs/jfs/namei.c                                |   6 +-
 fs/minix/inode.c                              |  50 +-
 fs/nfs/dir.c                                  |   4 +-
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs4idmap.c                           |  52 +-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 +
 fs/ntfs3/attrib.c                             |  19 +-
 fs/ntfs3/attrlist.c                           |   9 +
 fs/ntfs3/file.c                               |   8 +-
 fs/ntfs3/fslog.c                              |   3 +
 fs/ntfs3/fsntfs.c                             |   6 +
 fs/ntfs3/index.c                              |   7 +-
 fs/ocfs2/xattr.c                              |   4 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/pstore/ram_core.c                          |  18 +
 fs/quota/quota.c                              |   1 +
 fs/smb/client/cached_dir.c                    |   4 +-
 fs/smb/client/connect.c                       |   2 +
 fs/smb/client/smb2file.c                      |   2 +
 fs/smb/client/smb2misc.c                      |   6 +-
 fs/smb/client/smb2ops.c                       |  29 +-
 fs/smb/client/smb2pdu.c                       |   3 +
 fs/smb/client/smbdirect.c                     |  19 +-
 fs/smb/client/trace.h                         |   1 +
 fs/xfs/libxfs/xfs_attr_leaf.c                 |  49 +-
 fs/xfs/scrub/attr.c                           |   5 +-
 fs/xfs/scrub/btree.c                          |   2 +
 fs/xfs/scrub/common.c                         |   4 +
 fs/xfs/scrub/dabtree.c                        |   2 +
 include/acpi/ghes.h                           |   1 +
 include/asm-generic/audit_change_attr.h       |   3 +
 include/asm-generic/audit_read.h              |   6 +
 include/drm/drm_of.h                          |   3 +
 include/linux/audit.h                         |   6 -
 include/linux/audit_arch.h                    |   7 +
 include/linux/cache.h                         |  84 ++
 include/linux/capability.h                    |   6 +
 include/linux/clk.h                           |  48 +-
 include/linux/cper.h                          |   3 +-
 include/linux/ftrace.h                        |   6 +-
 include/linux/inetdevice.h                    |   2 +-
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/linux/mlx5/driver.h                   |   4 +-
 include/linux/module.h                        |   9 +
 include/linux/mtd/spinand.h                   |   2 +-
 include/linux/psp.h                           |   1 +
 include/linux/skbuff.h                        |  32 +
 include/linux/skmsg.h                         |  70 +-
 include/linux/tcp.h                           |  14 +-
 include/linux/trace_events.h                  |   5 +
 include/linux/u64_stats_sync.h                |  10 +
 include/media/dvb_vb2.h                       |   6 +-
 include/net/bluetooth/l2cap.h                 |   2 +
 include/net/inet_connection_sock.h            |  16 +-
 include/net/ioam6.h                           |   2 +
 include/net/ip.h                              |   7 +-
 include/net/ipv6.h                            |  15 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/net/netns/ipv4.h                      |  58 +-
 include/rdma/ib_verbs.h                       |   2 +-
 include/rdma/rw.h                             |   2 +
 include/uapi/linux/hyperv.h                   |   2 +-
 include/uapi/linux/netfilter_bridge.h         |   4 +
 include/uapi/linux/vbox_vmmdev_types.h        |   4 +-
 include/ufs/ufshcd.h                          |   4 -
 include/xen/xen.h                             |   2 +
 io_uring/cancel.h                             |   6 +-
 io_uring/filetable.c                          |   4 +
 io_uring/sync.c                               |   2 +
 ipc/ipc_sysctl.c                              |   2 +-
 kernel/bpf/verifier.c                         |  18 +-
 kernel/configs/debug.config                   |   1 -
 kernel/kallsyms.c                             |   4 +-
 kernel/kexec_file.c                           | 131 +--
 kernel/module/kallsyms.c                      |   9 +-
 kernel/rcu/tree.c                             |  98 +-
 kernel/rcu/tree.h                             |   4 +-
 kernel/rcu/tree_plugin.h                      | 109 +-
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/trace/ftrace.c                         |   5 +-
 kernel/trace/trace.c                          |   2 +-
 kernel/trace/trace_events.c                   |   8 +-
 kernel/trace/trace_events_hist.c              |   6 +-
 kernel/trace/trace_hwlat.c                    |  15 +-
 kernel/ucount.c                               |   2 +-
 kernel/workqueue.c                            |  92 +-
 lib/Kconfig.debug                             |  27 -
 mm/highmem.c                                  |   3 +-
 mm/page_alloc.c                               |  14 +
 net/atm/signaling.c                           |  56 +-
 net/bluetooth/hci_conn.c                      |   5 +-
 net/bluetooth/hci_sync.c                      |   2 -
 net/bluetooth/l2cap_core.c                    |  81 +-
 net/bluetooth/l2cap_sock.c                    |  15 +-
 net/bridge/br_multicast.c                     |  45 +-
 net/ceph/crypto.c                             |   8 +-
 net/ceph/crypto.h                             |   2 +-
 net/ceph/messenger_v2.c                       |   2 +-
 net/core/dev.c                                |  25 +-
 net/core/filter.c                             |   2 +-
 net/core/gro.c                                |   2 +-
 net/core/net_namespace.c                      |  45 +
 net/core/skmsg.c                              |  30 +-
 net/ipv4/fib_lookup.h                         |   6 +-
 net/ipv4/fib_trie.c                           |   4 +-
 net/ipv4/icmp.c                               |  72 +-
 net/ipv4/igmp.c                               |   4 +-
 net/ipv4/ip_options.c                         |   5 +-
 net/ipv4/ping.c                               |  31 +-
 net/ipv4/sysctl_net_ipv4.c                    |  49 +-
 net/ipv4/tcp.c                                |   3 +
 net/ipv4/tcp_bpf.c                            |  25 +-
 net/ipv4/tcp_input.c                          |   8 +
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/tcp_output.c                         |   9 +-
 net/ipv4/udp_bpf.c                            |  23 +-
 net/ipv6/exthdrs.c                            |  15 +-
 net/ipv6/icmp.c                               |  10 +-
 net/ipv6/ioam6.c                              |  14 +
 net/ipv6/ioam6_iptunnel.c                     |  10 +-
 net/ipv6/ip6_fib.c                            |   2 +-
 net/ipv6/xfrm6_policy.c                       |   7 +-
 net/mptcp/protocol.c                          |   8 +-
 net/mptcp/protocol.h                          |   5 +
 net/netfilter/nf_conncount.c                  |  54 +-
 net/netfilter/nf_conntrack_h323_asn1.c        |   2 +-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_conntrack_proto_generic.c    |   1 +
 net/netfilter/nf_tables_api.c                 |   8 +
 net/netfilter/nft_compat.c                    |  13 +-
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_counter.c                   |   4 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  30 +-
 net/netfilter/xt_tcpmss.c                     |   2 +-
 net/nfc/hci/llc_shdlc.c                       |   8 +
 net/nfc/nci/ntf.c                             | 159 ++-
 net/rds/connection.c                          |   4 +
 net/rds/send.c                                |   6 +-
 net/rds/tcp_listen.c                          |   5 -
 net/sched/act_skbedit.c                       |   6 +-
 net/sunrpc/auth_gss/auth_gss.c                |   3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c             |  82 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |  43 +-
 net/tipc/crypto.c                             |   2 +-
 net/tipc/name_table.c                         |   6 +-
 net/vmw_vsock/vmci_transport.c                |   2 +-
 net/wireless/core.c                           |   4 +-
 net/wireless/wext-compat.c                    |   2 +-
 net/xfrm/xfrm_device.c                        |  12 +-
 net/xfrm/xfrm_policy.c                        |  11 +-
 scripts/kernel-doc                            |   5 +
 scripts/mod/modpost.c                         |   4 +
 security/apparmor/apparmorfs.c                |  27 +-
 security/apparmor/domain.c                    |  60 +-
 security/apparmor/file.c                      |  12 +-
 security/apparmor/include/lib.h               |   2 +
 security/apparmor/include/match.h             |   6 -
 security/apparmor/include/policy.h            |  49 +-
 security/apparmor/ipc.c                       |   4 +-
 security/apparmor/label.c                     |  51 +-
 security/apparmor/lib.c                       |   4 +-
 security/apparmor/lsm.c                       |  63 ++
 security/apparmor/match.c                     |  44 -
 security/apparmor/mount.c                     |  20 +-
 security/apparmor/net.c                       |  10 +-
 security/apparmor/policy.c                    |  58 +-
 security/apparmor/policy_unpack.c             | 122 ++-
 security/apparmor/resource.c                  |   5 +
 security/smack/smackfs.c                      |  79 +-
 sound/pci/hda/patch_conexant.c                |   1 +
 sound/soc/amd/yc/acp6x-mach.c                 |   8 +-
 sound/soc/codecs/aw88261.c                    |   3 +-
 sound/soc/codecs/es8328.c                     |  10 +-
 sound/soc/codecs/max98390.c                   |   3 +
 sound/soc/codecs/nau8821.c                    |  85 +-
 sound/soc/codecs/nau8821.h                    |   3 +-
 sound/soc/codecs/wm8962.c                     |  12 +-
 sound/soc/fsl/fsl_xcvr.c                      |   3 -
 sound/soc/rockchip/rockchip_i2s_tdm.c         |  10 +
 sound/soc/sof/ipc4-control.c                  |  41 +-
 sound/soc/sof/ipc4-topology.c                 |  35 +-
 sound/soc/sunxi/sun50i-dmic.c                 |   3 +
 sound/usb/endpoint.c                          |  40 +-
 sound/usb/quirks.c                            |   2 +
 tools/bpf/bpftool/net.c                       |   5 +-
 tools/include/linux/bitfield.h                |   1 +
 tools/lib/bpf/btf_dump.c                      |   9 +
 tools/lib/bpf/netlink.c                       |   4 +-
 tools/lib/perf/Makefile                       |  14 +-
 tools/lib/subcmd/help.c                       |  10 +-
 tools/objtool/Makefile                        |   2 +
 tools/perf/tests/shell/stat.sh                |   6 +-
 tools/perf/util/evsel_fprintf.c               |   8 +-
 tools/perf/util/unwind-libdw.c                |   7 +-
 tools/power/cpupower/lib/cpuidle.c            |   1 +
 .../x86/intel-speed-select/isst-config.c      |   2 +
 tools/spi/.gitignore                          |   1 +
 tools/testing/selftests/bpf/veristat.c        |   2 +-
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 tools/testing/selftests/memfd/memfd_test.c    | 123 ++-
 .../selftests/mm/charge_reserved_hugetlb.sh   |   4 +-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh    |   2 +-
 671 files changed, 7951 insertions(+), 2927 deletions(-)
 create mode 100644 Documentation/trace/events-pci.rst
 create mode 100644 Documentation/trace/ring-buffer-map.rst
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h

-- 
2.51.0

