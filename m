Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E978E41162B;
	Mon,  2 Mar 2026 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467811; cv=none; b=diUmjsY1NtqmXtU5/5kmHAPtbHhTwzjVO0hDvWd6l5QdZlAbLIKWLgplzo+NwCny4wymFFuXMgxZ9I0j7xlFM5viY8V/csdgUe6P7puP2dYOfP/Tq+z2ayiNIwoLZFossUHO6Epu2mivzVmn6T0+V67GJhSb1tmWQX1jGaIUbQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467811; c=relaxed/simple;
	bh=r3g0uyaSFXtHodlhDIPaLdAot4pHLPqzOqAEFRo4sF4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r9oS6w76ydgArCHUD1d6CgsCVBZDOAvdfFvWU1gtHrTSSigx7HOOfIybwVBMNmeWr2RNJHHqmnQs0zgraq+H/cInTQJpQ819XxG90vf3tCvvbLnXjUE2GowhgOK0cxKmV001olIlTeKz18uGCydp3mwWKMnStcmXQzU7hGgFlHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+WT1yP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+WT1yP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B907C19423;
	Mon,  2 Mar 2026 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772467810;
	bh=r3g0uyaSFXtHodlhDIPaLdAot4pHLPqzOqAEFRo4sF4=;
	h=From:To:Cc:Subject:Date:From;
	b=V+WT1yP8loMwvrqaGFjMcWZhGNOsPEHqKhvvjnKfeKZ7gWqhvE6ZSYfs/j22DlDni
	 qF2S9V1DoBV/vGda4umtLGns2JljLfTIuJ2ean7D9oUmegyz40UYs8E+eay2bPuncJ
	 T3fJN1S5bJbly32LjbT+TMaIhuOu9DHrK+KBNA0TIhq2SJ/PDmlwVnZh/cGx8TzdM4
	 S8gNZXBGy9os051PxSBrFk/bCHXGXX7Il0z8N3tVhXw+3bWr4a9fgyFT1IQEPCGZsq
	 nX5y9/nqAKFiQsLQPlI2UEuXcVxn68Dar11d/D2xnjsbSA8dOctdpBslewZa6EBE+8
	 2KnJR4pD0OoGw==
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
Subject: [PATCH 5.10 000/334] 5.10.252-rc2 review
Date: Mon,  2 Mar 2026 11:10:07 -0500
Message-ID: <20260302161007.2523181-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.252-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.252-rc2
X-KernelTest-Deadline: 2026-03-04T16:10+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 5.10.252 release.
There are 334 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Mar  4 04:10:05 PM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Abdun Nihaal (2):
  media: i2c/tw9903: Fix potential memory leak in tw9903_probe()
  media: i2c/tw9906: Fix potential memory leak in tw9906_probe()

Aboorva Devarajan (1):
  cpuidle: Skip governor when only one idle state is available

Aleksei Oladko (1):
  selftests: forwarding: vxlan_bridge_1d: fix test failure with
    br_netfilter enabled

Alex Deucher (1):
  drm/amdgpu: keep vga memory on MacBooks with switchable graphics

Alex Williamson (1):
  PCI: Mark ASM1164 SATA controller to avoid bus reset

Alexander Grest (1):
  iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency

Alexander Koskovich (1):
  power: reset: nvmem-reboot-mode: respect cell size for
    nvmem_cell_write

Allison Henderson (1):
  net/rds: rds_sendmsg should not discard payload_len

Alok Tiwari (1):
  mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper

Alper Ak (2):
  tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
  tpm: st33zp24: Fix missing cleanup on get_burstcount() error

Andreas Gruenbacher (6):
  gfs2: Add new gfs2_iomap_get helper
  gfs2: Turn gfs2_extent_map into gfs2_{get,alloc}_extent
  gfs2: Replace gfs2_lblk_to_dblk with gfs2_get_extent
  gfs2: Add wrapper for iomap_file_buffered_write
  gfs2: Move the inode glock locking to gfs2_file_buffered_write
  gfs2: Add metapath_dibh helper

Andreas Larsson (1):
  sparc: Synchronize user stack on fork and clone

André Draszik (1):
  regulator: core: move supply check earlier in
    set_machine_constraints()

AngeloGioacchino Del Regno (2):
  arm64: dts: qcom: sdm630: Add qfprom subnodes
  dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

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

Archie Pusaka (1):
  Bluetooth: Enforce key size of 16 bytes on FIPS level

Armin Wolf (1):
  ACPICA: Abort AML bytecode execution when executing AML_FATAL_OP

Arnd Bergmann (2):
  vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
  myri10ge: avoid uninitialized variable use

Artem Shimko (1):
  serial: 8250_dw: handle clock enable errors in runtime_resume

Bartosz Golaszewski (1):
  clocksource/drivers/timer-integrator-ap: Add missing Kconfig
    dependency on OF

Ben Dooks (1):
  fs: add <linux/init_task.h> for 'init_fs'

Benjamin Marzinski (1):
  dm mpath: make pg_init_delay_msecs settable

Billy Tsai (2):
  i3c: Move device name assignment after i3c_bus_init
  gpio: aspeed-sgpio: Change the macro to support deferred probe

Brian Masney (2):
  openrisc: define arch-specific version of nop()
  clk: microchip: core: correct return value on *_get_parent()

Carl Lee (1):
  nfc: nxp-nci: remove interrupt trigger type

Chaitanya Mishra (1):
  staging: greybus: lights: avoid NULL deref

Chen Jinghuang (1):
  sched/rt: Skip currently executing CPU in rto_next_cpu()

Chen-Yu Tsai (1):
  ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property

Chin-Ting Kuo (1):
  spi: spi-mem: Protect dirmap_create() with spi_mem_access_start/end

Christian Kohlschütter (1):
  regulator: core: Fix off-on-delay-us for always-on/boot-on regulators

Christoph Hellwig (1):
  iomap: fix submission side handling of completion side errors

Chuck Lever (10):
  svcrdma: Add a batch Receive posting mechanism
  svcrdma: Use svc_rdma_refresh_recvs() in wc_receive
  svcrdma: Maintain a Receive water mark
  RDMA/core: Fix a couple of obvious typos in comments
  svcrdma: Remove queue-shortening warnings
  svcrdma: Clean up comment in svc_rdma_accept()
  svcrdma: Increase the per-transport rw_ctx count
  svcrdma: Reduce the number of rdma_rw contexts per-QP
  RDMA/core: add rdma_rw_max_sge() helper for SQ sizing
  SUNRPC: auth_gss: fix memory leaks in XDR decoding error paths

Colin Ian King (1):
  scsi: csiostor: Fix dereference of null pointer rn

Cupertino Miranda (1):
  bpf: verifier improvement in 32bit shift sign extension pattern

Dan Carpenter (2):
  EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
  EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()

Daniel Hodges (2):
  SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
  tipc: fix RCU dereference race in tipc_aead_users_dec()

Daniel Palmer (1):
  m68k: nommu: fix memmove() with differently aligned src and dest for
    68000

Darrick J. Wong (4):
  xfs: mark data structures corrupt on EIO and ENODATA
  xfs: delete attr leaf freemap entries when empty
  xfs: fix freemap adjustments when adding xattrs to leaf blocks
  xfs: fix remote xattr valuelblk check

Davide Caratti (1):
  selftests: forwarding: tc_actions: cleanup temporary files when test
    is aborted

Deepanshu Kartikey (1):
  gfs2: Fix use-after-free in iomap inline data write path

Ding Hui (1):
  dm: remove fake timeout to avoid leak request

Diogo Ivo (1):
  arm64: tegra: smaug: Add usb-role-switch support

Dmitry Baryshkov (3):
  arm64: dts: qcom: sdm630: fix gpu_speed_bin size
  arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
  clk: qcom: dispcc-sdm845: convert to parent data

Dmytro Maluka (1):
  iommu/vt-d: Flush cache for PASID table before using it

Douglas Anderson (1):
  regulator: core: Shorten off-on-delay-us for always-on/boot-on by time
    since booted

Duoming Zhou (2):
  net: wan: farsync: Fix use-after-free bugs caused by unfinished
    tasklets
  atm: fore200e: fix use-after-free in tasklets during device removal

Eric Biggers (1):
  dm-verity: correctly handle dm_bufio_client_create() failure

Eric Dumazet (3):
  tcp: tcp_tx_timestamp() must look at the rtx queue
  ipv6: fix a race in ip6_sock_set_v6only()
  macvlan: observe an RCU grace period in macvlan_common_newlink() error
    path

Eric Joyner (1):
  ionic: Rate limit unknown xcvr type messages

Ethan Nelson-Moore (3):
  net: usb: sr9700: remove code to drive nonexistent multicast filter
  net: ethernet: marvell: skge: remove incorrect conflicting PCI ID
  net: intel: fix PCI device ID conflict between i40e and ipw2200

Felix Gu (2):
  fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
  pinctrl: equilibrium: Fix device node reference leak in pinbank_init()

Fernando Fernandez Mancera (3):
  netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
  netfilter: nf_conncount: increase the connection clean up limit to 64
  netfilter: nf_conncount: fix tracking of connections from localhost

Filipe Manana (2):
  btrfs: qgroup: return correct error when deleting qgroup relation item
  btrfs: fix invalid leaf access in btrfs_quota_enable() if ref key not
    found

Florian Westphal (3):
  netfilter: nft_set_hash: fix get operation on big endian
  netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
  netfilter: xt_tcpmss: check remaining length before reading optlen

Francesco Lavra (1):
  spi: tools: Add include folder to .gitignore

Frédéric Danis (1):
  Bluetooth: l2cap: Check encryption key size on incoming connection

Geert Uytterhoeven (1):
  clk: Move clk_{save,restore}_context() to COMMON_CLK section

Geetha sowjanya (1):
  octeontx2-af: Workaround SQM/PSE stalls by disabling sticky

Georgia Garcia (1):
  apparmor: fix invalid deref of rawdata when export_binary is unset

Gerd Rausch (1):
  net/rds: No shortcut out of RDS_CONN_ERROR

Greg Kroah-Hartman (1):
  Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"

Guenter Roeck (1):
  Revert "hwmon: (ibmpex) fix use-after-free in high/low store"

Gui-Dong Han (2):
  PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races
  rpmsg: core: fix race in driver_override_show() and use core helper

Günther Noack (3):
  HID: magicmouse: Do not crash on missing msc->input
  HID: prodikeys: Check presence of pm->input_ep82
  HID: logitech-hidpp: Check maxfield in hidpp_get_report_length()

Hangbin Liu (1):
  bonding: alb: fix UAF in rlb_arp_recv during bond up/down

Hans Verkuil (4):
  media: dvb-core: dmxdevfilter must always flush bufs
  media: omap3isp: isp_video_mbus_to_pix/pix_to_mbus fixes
  media: omap3isp: isppreview: always clamp in preview_try_format()
  media: omap3isp: set initial format

Haotian Zhang (6):
  clk: qcom: Return correct error code in qcom_cc_probe_by_index()
  soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in
    cmd_db_dev_probe
  PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
  power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
  mfd: arizona: Fix regulator resource leak on
    wm5102_clear_write_sequencer() failure
  jfs: Add missing set_freezable() for freezable kthread

Haotien Hsu (1):
  usb: gadget: tegra-xudc: Add handling for BLCG_COREPLL_PWRDN

Haoxiang Li (10):
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

Harshit Mogalapalli (1):
  iio: sca3000: Fix a resource leak in sca3000_probe()

Heiko Carstens (1):
  s390/purgatory: Add -Wno-default-const-init-unsafe to KBUILD_CFLAGS

Helge Deller (1):
  parisc: Prevent interrupts during reboot

Heming Zhao (1):
  ocfs2: fix reflink preserve cleanup issue

Honggang LI (1):
  RDMA/rtrs: server: remove dead code

Hou Wenlong (1):
  x86/xen/pvh: Enable PAE mode for 32-bit guest only when CONFIG_X86_PAE
    is set

Hsieh Hung-En (1):
  ASoC: es8328: Add error unwind in resume

Håkon Bugge (3):
  PCI: Do not attempt to set ExtTag for VFs
  PCI: Initialize RCB from pci_configure_device()
  net/rds: Clear reconnect pending bit

Ian Rogers (1):
  perf callchain: Fix srcline printing with inlines

Ido Schimmel (2):
  selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2
  selftests: forwarding: tc_actions: Use ncat instead of nc

Jack Wang (1):
  md/bitmap: fix GPF in write_page caused by resize race

Jacopo Scannella (1):
  Bluetooth: btusb: Add device ID for Realtek RTL8761BU

Jakub Kicinski (1):
  net: consume xmit errors of GSO frames

Jamie Iles (1):
  i3c: remove i2c board info from i2c_dev_desc

Jason Andryuk (1):
  xenbus: Use .freeze/.thaw to handle xenbus devices

Jason Gunthorpe (1):
  RDMA/efa: Fix typo in efa_alloc_mr()

Jeffrey Bencteux (2):
  audit: add fchmodat2() to change attributes class
  audit: add missing syscalls to read class

Jerome Brunet (4):
  arm64: dts: amlogic: axg: assign the MMC signal clocks
  arm64: dts: amlogic: gx: assign the MMC signal clocks
  arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
  arm64: dts: amlogic: g12: assign the MMC A signal clock

Jiasheng Jiang (1):
  RDMA/rxe: Fix double free in rxe_srq_from_init

Jiaxun Yang (1):
  MIPS: rb532: Fix MMIO UART resource registration

Jiayuan Chen (3):
  net: atm: fix crash due to unvalidated vcc pointer in sigd_send()
  serial: caif: fix use-after-free in caif_serial ldisc_close()
  xfrm6: fix uninitialized saddr in xfrm6_get_saddr()

Jinhui Guo (2):
  iommu/vt-d: Flush dev-IOTLB only when PCIe device is accessible in
    scalable mode
  PCI: Fix pci_slot_trylock() error handling

Jinliang Zheng (1):
  procfs: fix missing RCU protection when reading real_parent in
    do_task_stat()

Jinqian Yang (1):
  arm64: Add support for TSV110 Spectre-BHB mitigation

Jiri Pirko (1):
  RDMA/core: Fix stale RoCE GIDs during netdev events at registration

Jisheng Zhang (1):
  usb: dwc2: fix resume failure if dr_mode is host

Johan Hovold (1):
  soc: ti: k3-socinfo: Fix regmap leak on probe failure

Johannes Berg (1):
  wifi: cfg80211: wext: fix IGTK key ID off-by-one

John Efstathiades (3):
  lan78xx: Remove unused pause frame queue
  lan78xx: Fix race condition in disconnect handling
  lan78xx: Fix memory allocation bug

John Garry (1):
  MIPS: Loongson: Make cpumask_of_node() robust against NUMA_NO_NODE

John Johansen (2):
  apparmor: fix NULL sock in aa_sock_file_perm
  apparmor: fix rlimit for posix cpu timers

Johnny-CC Chang (1):
  PCI: Mark Nvidia GB10 to avoid bus reset

Jori Koolstra (2):
  minix: Add required sanity checking to minix_check_superblock()
  jfs: nlink overflow in jfs_rename

Jun Yan (1):
  arm64: dts: rockchip: Do not enable hdmi_sound node on Pinebook Pro

Justin Chen (1):
  usb: bdc: fix sleep during atomic

Jörg Wedekind (1):
  PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Kaushlendra Kumar (2):
  drm/i915/acpi: free _DSM package when no connectors
  tools/power cpupower: Reset errno before strtoull()

Kees Cook (1):
  media: solo6x10: Check for out of bounds chip_id

Keith Busch (1):
  PCI: Fix pci_slot_lock () device locking

Kevin Hao (1):
  net: cpsw_new: Fix unnecessary netdev unregistration in cpsw_probe()
    error path

Koichiro Den (1):
  NTB: ntb_transport: Fix too small buffer for debugfs_name

Konstantin Andreev (2):
  smack: /smack/doi must be > 0
  smack: /smack/doi: accept previously used values

Krishna Chaitanya Chundru (1):
  PCI: Add ACS quirk for Qualcomm Hamoa & Glymur

Krzysztof Kozlowski (1):
  arm64: dts: qcom: sdm630: correct QFPROM byte offsets

Kuniyuki Iwashima (1):
  ipv4: fib: Annotate access to struct fib_alias.fa_state.

Lee Jones (1):
  RDMA/core: device: Fix formatting in worthy kernel-doc header and
    demote another

Li Chen (2):
  nvdimm: virtio_pmem: serialize flush requests
  kexec: derive purgatory entry from symbol

Li Nan (1):
  md/raid10: fix any_working flag handling in raid10_sync_request

Li Wang (1):
  selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs

Linus Walleij (2):
  power: supply: wm97xx_battery: Convert to GPIO descriptor
  ata: pata_ftide010: Fix some DMA timings

Luca Ceresoli (1):
  drm: of: drm_of_panel_bridge_remove(): fix device_node leak

Ludovic Desroches (2):
  drm/atmel-hlcdc: fix memory leak from the atomic_destroy_state
    callback
  drm/atmel-hlcdc: fix use-after-free of drm_crtc_commit after release

Luiz Augusto von Dentz (4):
  Bluetooth: L2CAP: Fix invalid response to L2CAP_ECRED_RECONF_REQ
  Bluetooth: L2CAP: Fix response to L2CAP_ECRED_CONN_REQ
  Bluetooth: L2CAP: Fix not checking l2cap_chan security level
  Bluetooth: L2CAP: Fix missing key size check for L2CAP_LE_CONN_REQ

Maciej Grochowski (2):
  ntb: ntb_hw_switchtec: Fix array-index-out-of-bounds access
  ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut

Manivannan Sadhasivam (1):
  PCI: Enable ACS after configuring IOMMU for OF platforms

Marcus Folkesson (1):
  Revert "mfd: da9052-spi: Change read-mask to write-mask"

Mario Limonciello (AMD) (1):
  crypto: ccp - Add an S4 restore flow

Mark Brown (1):
  regulator: Flag uncontrollable regulators as always_on

Martin Blumenstingl (1):
  clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Martin Pålsson (1):
  net: usb: lan78xx: scan all MDIO addresses on LAN7801

Matt Whitlock (1):
  dm-unstripe: fix mapping bug when there are multiple targets in a
    table

Matthew Schwartz (1):
  mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Matthias Kaehlcke (1):
  regulator: core: Use ktime_get_boottime() to determine how long a
    regulator was off

Mauro Carvalho Chehab (3):
  EFI/CPER: don't dump the entire memory region
  APEI/GHES: ensure that won't go past CPER allocated record
  EFI/CPER: don't go past the ARM processor CPER record buffer

Md Haris Iqbal (1):
  rnbd-srv: Zero the rsp buffer before using it

Michael Liang (1):
  dm: clear cloned request bio pointer when last clone bio completes

Mikulas Patocka (1):
  dm-integrity: fix a typo in the code for write/discard race

Mingj Ye (1):
  net: usb: r8152: fix transmit queue timeout

Miri Korenblit (1):
  wifi: cfg80211: stop NAN and P2P in cfg80211_leave

Moteen Shah (1):
  serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA
    termination is done

Narayana Murty N (1):
  powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event
    handling

Niklas Schnelle (2):
  Revert "PCI/IOV: Add PCI rescan-remove locking when enabling/disabling
    SR-IOV"
  PCI/IOV: Fix race between SR-IOV enable/disable and hotplug

Niklas Söderlund (1):
  clocksource/drivers/sh_tmu: Always leave device running after probe

Nuno Sá (1):
  dma: dma-axi-dmac: fix SW cyclic transfers

Olga Kornievskaia (1):
  pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Oliver Neukum (2):
  usbb: catc: use correct API for MAC addresses
  HID: hid-pl: handle probe errors

Ondrej Mosnacek (1):
  ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Otto Pflüger (1):
  mailbox: sprd: clear delivery flag before handling TX done

Pablo Neira Ayuso (1):
  netfilter: nft_set_rbtree: check for partial overlaps in anonymous
    sets

Paul Cercueil (2):
  PM: core: Redefine pm_ptr() macro
  PM: core: Add new *_PM_OPS macros, deprecate old ones

Petr Hodina (1):
  clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Phil Sutter (1):
  include: uapi: netfilter_bridge.h: Cover for musl libc

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

Randy Dunlap (2):
  serial: imx: change SERIAL_IMX_CONSOLE to bool
  serial: SH_SCI: improve "DMA support" prompt

Renjiang Han (1):
  media: venus: vdec: fix error state assignment for zero bytesused

René Rebe (3):
  modpost: Amend ppc64 save/restfpr symnames for -Os build
  fix it87_wdt early reboot by reporting running timer
  fbdev: ffb: fix corrupted video output on Sun FFB1

Rui Feng (1):
  misc: rtsx: Add SD Express mode support for RTS5261

Ruipeng Qi (1):
  pstore: ram_core: fix incorrect success return when vmap() fails

Sai Ritvik Tanksalkar (1):
  pstore/ram: fix buffer overflow in persistent_ram_save_old()

Salah Triki (1):
  s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Sam James (1):
  sparc: don't reference obsolete termio struct for TC* constants

Samuel Wu (1):
  PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Sasha Levin (1):
  Linux 5.10.252-rc2

Sebastian Andrzej Siewior (4):
  EDAC/altera: Remove IRQF_ONESHOT
  mfd: wm8350-core: Use IRQF_ONESHOT
  mailbox: bcm-ferxrm-mailbox: Use default primary handler
  iio: magnetometer: Remove IRQF_ONESHOT

Sebastian Krzyszkowiak (2):
  ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
  ASoC: wm8962: Don't report a microphone if it's shorted to ground on
    plug

Shardul Bankar (1):
  hfsplus: return error when node already exists in hfs_bnode_create

Shaurya Rane (1):
  media: radio-keene: fix memory leak in error path

Srinivasan Shanmugam (1):
  drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init

Stefan Sørensen (1):
  Bluetooth: hci_conn: use mod_delayed_work for active mode timeout

Steven Rostedt (1):
  tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR
    macros

Sunday Clement (1):
  drm/amdkfd: Fix out-of-bounds write in kfd_event_page_set()

Svyatoslav Ryhel (1):
  drivers: iio: mpu3050: use dev_err_probe for regulator request

Szymon Wilczek (2):
  media: pvrusb2: fix URB leak in pvr2_send_request_ex
  wifi: libertas: fix WARNING in usb_tx_block

Tetsuo Handa (1):
  hfsplus: pretend special inodes as regular files

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

Thomas Richter (1):
  s390/perf: Disable register readout on sampling events

Thomas Weissschuh (1):
  ARM: 9467/1: mm: Don't use %pK through printk

Thomas Weißschuh (4):
  ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
  hyper-v: Mark inner union in hv_kvp_exchg_msg_value as packed
  virt: vbox: uapi: Mark inner unions in packed structs as packed
  binder: don't use %pK through printk

Thorsten Schmelzer (2):
  media: adv7180: fix frame interval in progressive mode
  HID: multitouch: add eGalaxTouch EXC3188 support

Tzung-Bi Shih (1):
  platform/chrome: cros_ec_lightbar: Fix response size initialization

Ulf Hansson (1):
  mmc: core: Initial support for SD express card/host

Uwe Kleine-König (1):
  PCI/portdrv: Fix potential resource leak

Vahagn Vardanian (1):
  netfilter: nf_conntrack_h323: fix OOB read in decode_choice()

Viacheslav Dubeyko (1):
  hfsplus: fix volume corruption issue for generic/498

Vincent Whitchurch (2):
  regulator: core: Respect off_on_delay at startup
  regulator: core: Fix off_on_delay handling

Vladimir Zapolskiy (2):
  ARM: dts: lpc32xx: Set motor PWM #pwm-cells property value to 3 cells
  arm: dts: lpc32xx: add clocks property to Motor Control PWM device
    tree node

Vlastimil Babka (1):
  mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP
    allocations

Waqar Hameed (7):
  power: supply: act8945a: Fix use-after-free in power_supply_changed()
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

Weigang He (1):
  fbdev: of: display_timing: fix refcount leak in
    of_get_display_timings()

Wentao Liang (1):
  soc: ti: pruss: Fix double free in pruss_clk_mux_setup()

Xiao Kan (1):
  drm: Account property blob allocations to memcg

Xu Yang (1):
  phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature

Yao Zi (1):
  MIPS: Work around LLVM bug when gp is used as global register variable

Yi Liu (2):
  RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send
  RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Yu Kuai (1):
  blk-mq-debugfs: add missing debugfs_mutex in
    blk_mq_debugfs_register_hctxs()

YunJe Shin (2):
  RDMA/siw: Fix potential NULL pointer dereference in header processing
  RDMA/umad: Reject negative data_len in ib_umad_write

Yuto Hamaguchi (1):
  netfilter: nf_conntrack: Add allow_clash to generic protocol handler

Zhang Yi (1):
  ext4: don't cache extent during splitting extent

Zhiyu Zhang (1):
  fat: avoid parent link count underflow in rmdir

Zilin Guan (1):
  ext4: fix memory leak in ext4_ext_shift_extents()

Ziyi Guo (8):
  wifi: ath10k: sdio: add missing lock protection in
    ath10k_sdio_fw_crashed_dump()
  net: usb: catc: enable basic endpoint checking
  xen-netback: reject zero-queue configuration from guest
  wifi: iwlegacy: add missing mutex protection in
    il4965_store_tx_power()
  wifi: iwlegacy: add missing mutex protection in
    il3945_store_measurement()
  wifi: ath10k: fix lock protection in
    ath10k_wmi_event_peer_sta_ps_state_chg()
  net: usb: kaweth: remove TX queue manipulation in kaweth_set_rx_mode
  net: usb: pegasus: enable basic endpoint checking

decce6 (2):
  drm/amdgpu: Add HAINAN clock adjustment
  drm/radeon: Add HAINAN clock adjustment

ethanwu (1):
  ceph: supply snapshot context in ceph_zero_partial_object()

jinbaohong (1):
  btrfs: continue trimming remaining devices on failure

 Makefile                                      |   4 +-
 arch/arm/boot/dts/lpc32xx.dtsi                |   3 +-
 arch/arm/boot/dts/sun5i-a13-utoo-p66.dts      |   1 +
 arch/arm/kernel/vdso.c                        |   1 +
 arch/arm/mach-pxa/mioa701.c                   |   1 -
 arch/arm/mach-pxa/palm27x.c                   |   1 -
 arch/arm/mach-pxa/palmte2.c                   |   1 -
 arch/arm/mm/physaddr.c                        |   2 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   6 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi   |   9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   9 +
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts |   2 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |  10 +
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts    |   7 +
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts |   4 -
 arch/arm64/kernel/proton-pack.c               |   1 +
 arch/m68k/lib/memmove.c                       |  18 ++
 .../include/asm/mach-loongson64/topology.h    |   2 +-
 arch/mips/kernel/relocate.c                   |  13 +
 arch/mips/rb532/devices.c                     |   5 +-
 arch/openrisc/include/asm/barrier.h           |   2 +
 arch/parisc/kernel/drivers.c                  |   2 +-
 arch/parisc/kernel/process.c                  |   3 +
 arch/powerpc/include/asm/eeh.h                |   2 +
 arch/powerpc/kernel/eeh_driver.c              |  11 +-
 arch/powerpc/kernel/eeh_pe.c                  |  74 +++++-
 arch/s390/kernel/perf_cpum_sf.c               |   2 +-
 arch/s390/purgatory/Makefile                  |   1 +
 arch/sparc/include/uapi/asm/ioctls.h          |   8 +-
 arch/sparc/kernel/process.c                   |  38 +--
 arch/x86/platform/pvh/head.S                  |   2 +
 block/blk-mq-debugfs.c                        |   2 +
 drivers/acpi/acpica/exoparg3.c                |  46 ++--
 drivers/acpi/apei/ghes.c                      |   6 +-
 drivers/android/binder.c                      |   2 +-
 drivers/android/binder_alloc.c                |   6 +-
 drivers/ata/pata_ftide010.c                   |   6 +-
 drivers/atm/fore200e.c                        |   4 +
 drivers/auxdisplay/arm-charlcd.c              |   2 +-
 drivers/base/power/wakeirq.c                  |   9 +-
 drivers/base/power/wakeup.c                   |   4 +-
 drivers/block/rnbd/rnbd-srv.c                 |   3 +
 drivers/bluetooth/btusb.c                     |   1 +
 drivers/bus/fsl-mc/fsl-mc-bus.c               |   6 +-
 drivers/char/tpm/st33zp24/st33zp24.c          |   6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |   6 +-
 drivers/clk/meson/gxbb.c                      |  17 +-
 drivers/clk/microchip/clk-core.c              |  25 +-
 drivers/clk/qcom/common.c                     |   2 +-
 drivers/clk/qcom/dispcc-sdm845.c              | 220 ++++++++---------
 drivers/clk/tegra/clk-tegra124-emc.c          |   4 +-
 drivers/clocksource/Kconfig                   |   1 +
 drivers/clocksource/sh_tmu.c                  |  18 --
 drivers/cpuidle/cpuidle.c                     |  10 +
 drivers/crypto/cavium/cpt/cptvf_main.c        |   3 +-
 drivers/crypto/ccp/psp-dev.c                  |  11 +
 drivers/crypto/ccp/sp-dev.c                   |  12 +
 drivers/crypto/ccp/sp-dev.h                   |   3 +
 drivers/crypto/ccp/sp-pci.c                   |  16 +-
 drivers/crypto/ccp/tee-dev.c                  |   5 +
 drivers/crypto/ccp/tee-dev.h                  |   1 +
 .../crypto/marvell/octeontx/otx_cptvf_main.c  |   3 +-
 drivers/dma/dma-axi-dmac.c                    |   3 +-
 drivers/dma/mediatek/mtk-uart-apdma.c         |  10 +-
 drivers/edac/altera_edac.c                    |  11 +-
 drivers/edac/i5000_edac.c                     |   1 +
 drivers/edac/i5400_edac.c                     |   2 +-
 drivers/firmware/efi/cper-arm.c               |  12 +-
 drivers/firmware/efi/cper.c                   |   8 +-
 drivers/fpga/dfl.c                            |   2 +-
 drivers/gpio/gpio-aspeed-sgpio.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c       |  10 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c         |  45 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |   6 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   2 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c     |   5 +
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   |   6 +-
 drivers/gpu/drm/drm_property.c                |   2 +-
 drivers/gpu/drm/i915/display/intel_acpi.c     |   1 +
 drivers/gpu/drm/radeon/si_dpm.c               |   5 +
 drivers/hid/hid-ids.h                         |   1 +
 drivers/hid/hid-logitech-hidpp.c              |   2 +-
 drivers/hid/hid-magicmouse.c                  |   5 +
 drivers/hid/hid-multitouch.c                  |   3 +
 drivers/hid/hid-pl.c                          |   7 +-
 drivers/hid/hid-prodikeys.c                   |   4 +
 drivers/hwmon/ibmpex.c                        |   9 +-
 .../coresight/coresight-etm3x-core.c          |  12 +-
 drivers/i3c/master.c                          |  21 +-
 drivers/iio/accel/sca3000.c                   |   6 +-
 drivers/iio/gyro/itg3200_core.c               |   2 +
 drivers/iio/gyro/mpu3050-core.c               |   6 +-
 drivers/iio/magnetometer/ak8975.c             |   2 +-
 drivers/infiniband/core/cache.c               |  13 +
 drivers/infiniband/core/core_priv.h           |   3 +
 drivers/infiniband/core/device.c              |  40 ++-
 drivers/infiniband/core/rw.c                  |  53 ++--
 drivers/infiniband/core/user_mad.c            |   8 +-
 drivers/infiniband/core/uverbs_cmd.c          |   7 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/sw/rxe/rxe_srq.c           |   3 +
 drivers/infiniband/sw/siw/siw_qp_rx.c         |   3 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c        |   8 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  31 ++-
 drivers/iommu/intel/pasid.c                   |   9 +-
 drivers/mailbox/bcm-flexrm-mailbox.c          |  14 +-
 drivers/mailbox/sprd-mailbox.c                |  10 +-
 drivers/md/dm-integrity.c                     |   2 +-
 drivers/md/dm-mpath.c                         |   2 +-
 drivers/md/dm-rq.c                            |  16 +-
 drivers/md/dm-unstripe.c                      |   2 +-
 drivers/md/dm-verity-fec.c                    |   4 +-
 drivers/md/md-bitmap.c                        |   3 +-
 drivers/md/raid10.c                           |   2 +-
 drivers/media/dvb-core/dmxdev.c               |   8 +-
 drivers/media/dvb-core/dvb_vb2.c              |   5 +-
 drivers/media/i2c/adv7180.c                   |   7 +
 drivers/media/i2c/tw9903.c                    |   1 +
 drivers/media/i2c/tw9906.c                    |   1 +
 drivers/media/pci/cx23885/cx23885-alsa.c      |   4 +-
 drivers/media/pci/cx25821/cx25821-alsa.c      |   1 +
 drivers/media/pci/cx25821/cx25821-core.c      |   1 +
 drivers/media/pci/cx88/cx88-alsa.c            |   4 +-
 drivers/media/pci/solo6x10/solo6x10-tw28.c    |   8 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c |  17 +-
 drivers/media/platform/omap3isp/isppreview.c  |  21 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  14 +-
 drivers/media/platform/qcom/venus/vdec.c      |   6 +-
 drivers/media/radio/radio-keene.c             |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c       |   5 +
 drivers/mfd/arizona-core.c                    |   2 +-
 drivers/mfd/da9052-spi.c                      |   2 +-
 drivers/misc/cardreader/rts5261.c             |   4 +
 drivers/misc/cardreader/rts5261.h             |  23 --
 drivers/misc/cardreader/rtsx_pcr.c            |   5 +
 drivers/mmc/core/core.c                       |  15 +-
 drivers/mmc/core/host.h                       |   6 +
 drivers/mmc/core/sd_ops.c                     |  49 +++-
 drivers/mmc/core/sd_ops.h                     |   1 +
 .../mtd/nand/raw/cadence-nand-controller.c    |   2 +-
 drivers/net/bonding/bond_main.c               |  21 +-
 drivers/net/caif/caif_serial.c                |   5 +-
 drivers/net/ethernet/ec_bhf.c                 |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |  11 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  12 +-
 drivers/net/ethernet/marvell/skge.c           |   1 -
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  28 ++-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   7 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  12 +-
 drivers/net/macvlan.c                         |   5 +
 drivers/net/usb/Kconfig                       |   1 -
 drivers/net/usb/catc.c                        |  59 ++++-
 drivers/net/usb/kaweth.c                      |   2 -
 drivers/net/usb/lan78xx.c                     | 115 ++++++---
 drivers/net/usb/pegasus.c                     |  35 ++-
 drivers/net/usb/r8152.c                       |   2 +
 drivers/net/usb/sr9700.c                      |  25 +-
 drivers/net/usb/sr9700.h                      |   7 +-
 drivers/net/wan/farsync.c                     |   2 +
 drivers/net/wan/fsl_ucc_hdlc.c                |   8 +-
 drivers/net/wireless/ath/ath10k/sdio.c        |   6 +
 drivers/net/wireless/ath/ath10k/wmi.c         |   4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c  |   8 +-
 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +
 .../net/wireless/marvell/libertas/if_usb.c    |   2 +
 drivers/net/xen-netback/xenbus.c              |   5 +-
 drivers/nfc/nxp-nci/i2c.c                     |   2 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c        |  12 +-
 drivers/ntb/ntb_transport.c                   |   4 +-
 drivers/nvdimm/nd_virtio.c                    |   3 +-
 drivers/nvdimm/virtio_pmem.c                  |   1 +
 drivers/nvdimm/virtio_pmem.h                  |   4 +
 drivers/pci/controller/pcie-mediatek.c        |   4 +-
 drivers/pci/iov.c                             |   9 +-
 drivers/pci/pci-driver.c                      |   8 +
 drivers/pci/pci.c                             |  37 +--
 drivers/pci/pci.h                             |   1 +
 drivers/pci/pcie/portdrv_core.c               |   6 +-
 drivers/pci/probe.c                           |  35 ++-
 drivers/pci/quirks.c                          |  23 ++
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c    |   1 +
 drivers/pinctrl/pinctrl-equilibrium.c         |   1 +
 drivers/pinctrl/pinctrl-single.c              |   2 +
 drivers/platform/chrome/cros_ec_lightbar.c    |   2 +-
 drivers/power/reset/nvmem-reboot-mode.c       |  15 +-
 drivers/power/supply/act8945a_charger.c       |  16 +-
 drivers/power/supply/bq25980_charger.c        |  12 +-
 drivers/power/supply/bq27xxx_battery.c        |   6 +-
 drivers/power/supply/cpcap-battery.c          |   8 +-
 drivers/power/supply/goldfish_battery.c       |  12 +-
 drivers/power/supply/rt9455_charger.c         |  17 +-
 drivers/power/supply/sbs-battery.c            |  36 +--
 drivers/power/supply/wm97xx_battery.c         |  69 +++---
 drivers/rapidio/rio-scan.c                    |   3 +-
 drivers/regulator/core.c                      |  68 +++---
 drivers/rpmsg/rpmsg_core.c                    |  66 +++--
 drivers/rtc/interface.c                       |   2 +-
 drivers/s390/cio/css.c                        |   2 +-
 drivers/scsi/csiostor/csio_scsi.c             |   3 +-
 drivers/soc/qcom/cmd-db.c                     |   7 +-
 drivers/soc/ti/k3-socinfo.c                   |   2 +-
 drivers/soc/ti/pruss.c                        |   6 +-
 drivers/spi/spi-mem.c                         |  11 +-
 drivers/staging/greybus/light.c               |   8 +-
 drivers/tty/serial/8250/8250_dw.c             |  11 +-
 drivers/tty/serial/8250/8250_omap.c           |   2 +-
 drivers/tty/serial/Kconfig                    |   8 +-
 drivers/usb/dwc2/core.c                       |   1 +
 drivers/usb/gadget/udc/bdc/bdc_core.c         |   4 +-
 drivers/usb/gadget/udc/tegra-xudc.c           |  12 +-
 drivers/video/fbdev/au1200fb.c                |   6 +-
 drivers/video/fbdev/ffb.c                     |  14 +-
 drivers/video/fbdev/vt8500lcdfb.c             |   5 +-
 drivers/video/of_display_timing.c             |   4 +-
 drivers/watchdog/it87_wdt.c                   |  12 +
 drivers/xen/xenbus/xenbus_probe_frontend.c    |   4 +-
 fs/btrfs/extent-tree.c                        |   2 +-
 fs/btrfs/qgroup.c                             |  15 +-
 fs/ceph/file.c                                |  17 +-
 fs/ext4/extents.c                             |   9 +-
 fs/fat/namei_msdos.c                          |   7 +-
 fs/fat/namei_vfat.c                           |   7 +-
 fs/fs_struct.c                                |   1 +
 fs/gfs2/bmap.c                                | 227 +++++++-----------
 fs/gfs2/bmap.h                                |  13 +-
 fs/gfs2/dir.c                                 |  13 +-
 fs/gfs2/file.c                                |  59 ++++-
 fs/gfs2/log.c                                 |   6 +-
 fs/gfs2/quota.c                               |   4 +-
 fs/gfs2/recovery.c                            |   4 +-
 fs/hfsplus/bnode.c                            |   2 +-
 fs/hfsplus/inode.c                            |  12 +-
 fs/hfsplus/super.c                            |   6 +
 fs/iomap/direct-io.c                          |  10 +-
 fs/jfs/jfs_logmgr.c                           |   1 +
 fs/jfs/namei.c                                |   6 +-
 fs/minix/inode.c                              |  50 ++--
 fs/nfs/pnfs.c                                 |   3 +-
 fs/nfsd/nfs4idmap.c                           |  52 +++-
 fs/nfsd/nfs4proc.c                            |   2 -
 fs/nfsd/nfs4xdr.c                             |  16 ++
 fs/ocfs2/xattr.c                              |   4 +
 fs/overlayfs/readdir.c                        |   2 +-
 fs/proc/array.c                               |   2 +-
 fs/pstore/ram_core.c                          |  18 ++
 fs/xfs/libxfs/xfs_attr_leaf.c                 |  49 +++-
 fs/xfs/scrub/attr.c                           |   5 +-
 fs/xfs/scrub/btree.c                          |   2 +
 fs/xfs/scrub/common.c                         |   4 +
 fs/xfs/scrub/dabtree.c                        |   2 +
 include/acpi/ghes.h                           |   1 +
 include/asm-generic/audit_change_attr.h       |   3 +
 include/asm-generic/audit_read.h              |   6 +
 include/drm/drm_of.h                          |   3 +
 include/linux/clk.h                           |  48 ++--
 include/linux/cper.h                          |   3 +-
 include/linux/i3c/master.h                    |   1 -
 include/linux/mfd/wm8350/core.h               |   2 +-
 include/linux/mmc/host.h                      |   7 +
 include/linux/pm.h                            |  80 +++---
 include/linux/regulator/driver.h              |   2 +-
 include/linux/rtsx_pci.h                      |  23 ++
 include/linux/sunrpc/svc_rdma.h               |   2 +
 include/linux/wm97xx.h                        |   1 -
 include/media/dvb_vb2.h                       |   6 +-
 include/net/bluetooth/l2cap.h                 |   2 +
 include/net/ipv6.h                            |  11 +-
 include/net/netfilter/nf_conntrack_count.h    |   1 +
 include/rdma/ib_verbs.h                       |   2 +-
 include/rdma/rw.h                             |   2 +
 include/uapi/linux/hyperv.h                   |   2 +-
 include/uapi/linux/netfilter_bridge.h         |   4 +
 include/uapi/linux/vbox_vmmdev_types.h        |   4 +-
 kernel/bpf/verifier.c                         |  18 +-
 kernel/kexec_file.c                           | 131 +++++-----
 kernel/sched/rt.c                             |   5 +
 kernel/time/hrtimer.c                         |   2 +-
 kernel/trace/trace_events.c                   |   5 -
 kernel/ucount.c                               |   2 +-
 mm/page_alloc.c                               |  14 ++
 net/atm/signaling.c                           |  56 ++++-
 net/bluetooth/hci_conn.c                      |   4 +-
 net/bluetooth/l2cap_core.c                    |  95 ++++++--
 net/core/dev.c                                |  23 +-
 net/ipv4/fib_lookup.h                         |   6 +-
 net/ipv4/fib_trie.c                           |   4 +-
 net/ipv4/tcp.c                                |   3 +
 net/ipv6/xfrm6_policy.c                       |   7 +-
 net/netfilter/nf_conncount.c                  |  54 +++--
 net/netfilter/nf_conntrack_h323_asn1.c        |   2 +-
 net/netfilter/nf_conntrack_h323_main.c        |  10 +-
 net/netfilter/nf_conntrack_proto_generic.c    |   1 +
 net/netfilter/nft_connlimit.c                 |   7 +-
 net/netfilter/nft_set_hash.c                  |   9 +-
 net/netfilter/nft_set_rbtree.c                |  30 ++-
 net/netfilter/xt_tcpmss.c                     |   2 +-
 net/rds/connection.c                          |   4 +
 net/rds/send.c                                |   6 +-
 net/rds/tcp_listen.c                          |   5 -
 net/sunrpc/auth_gss/auth_gss.c                |   3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c             |  82 +++++--
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c       |  89 ++++---
 net/sunrpc/xprtrdma/svc_rdma_transport.c      |  46 ++--
 net/tipc/crypto.c                             |   2 +-
 net/vmw_vsock/vmci_transport.c                |   2 +-
 net/wireless/core.c                           |   4 +-
 net/wireless/wext-compat.c                    |   2 +-
 scripts/mod/modpost.c                         |   4 +
 security/apparmor/apparmorfs.c                |   9 +
 security/apparmor/net.c                       |   6 +-
 security/apparmor/resource.c                  |   5 +
 security/smack/smackfs.c                      |  79 +++---
 sound/soc/codecs/es8328.c                     |  10 +-
 sound/soc/codecs/wm8962.c                     |  12 +-
 tools/perf/util/evsel_fprintf.c               |   8 +-
 tools/power/cpupower/lib/cpuidle.c            |   1 +
 tools/spi/.gitignore                          |   1 +
 .../drivers/net/mlxsw/tc_restrictions.sh      |   4 +-
 .../selftests/net/forwarding/tc_actions.sh    |  18 +-
 .../net/forwarding/vxlan_bridge_1d.sh         |  26 +-
 .../selftests/vm/charge_reserved_hugetlb.sh   |   4 +-
 324 files changed, 2762 insertions(+), 1391 deletions(-)

-- 
2.51.0

