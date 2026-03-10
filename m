Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABFA37F007;
	Tue, 10 Mar 2026 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141573; cv=none; b=MevA1kJCWI8a/GzZaR2G12wH8/YX3RIu/khQIEgTozMYil5RJVapL+uDQxHMYmnwS/rMhmutsGpx6wX797Q5XvQCxC7Vx+kdO1/P3M1k9G17A7DZ/34Vaq+FqBLNf18KICMAQCp87F/45gMuOOzhj/7r8tVukEDUJsTiOpkSWGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141573; c=relaxed/simple;
	bh=9Yz6qV5p1FWUeNfIj0hD0mx10SIGEccRBnDvoc1kTkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RaFFwlKWGx+iKtnKIQPN1kECYUAAu8wW5ePohz9Xx2YY1cvigdBOkqTIqdYyHtVX/U92tfjKG9KAsO7L28qeqwIWr2PVzXgue7JZvsH2o7KeWm1sSMgOXjWmignykkj4d1RfLNz80Fs57MhSuDVC/Y1R2G0oMIbgeEKkkEEDqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OESIZM+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OESIZM+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153BEC2BC9E;
	Tue, 10 Mar 2026 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141573;
	bh=9Yz6qV5p1FWUeNfIj0hD0mx10SIGEccRBnDvoc1kTkA=;
	h=From:To:Cc:Subject:Date:From;
	b=OESIZM+gYOb+f/Z5V2Z0YZ49A08rTdPY3GWVXBW+IGCt899/+zJ0XYetQmZi4pMN8
	 LgImHtgpziQkEee0mH3g3VWzrj0AQDocDAf3HsyxwrrJIXs7hPJppgJ6gIRnCm7vwv
	 P/2juR939HVcF4Ql6zyJI5fN/ShD6x+vjudesPiXI6lE7s2sfKSetiRp6MChYaRHln
	 iFuw56e+OU2Fi7uh4oej/463VIY0BBxOdvCVhnM9Ixuuudg0meva72RkzvAJuMAFLp
	 l5VVLBQDLjUICQXPWYdU5ISKDH2S7b1mznTvpV5ZFlXH5oKbcpzodGHD91sEPDbGkN
	 s8bnXLzkPK5JA==
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
Subject: [PATCH 6.18 000/314] 6.18.17-rc1 review
Date: Tue, 10 Mar 2026 07:19:29 -0400
Message-ID: <cover.1773141554.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.17-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.17-rc1
X-KernelTest-Deadline: 2026-03-12T11:19+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit


This is the start of the stable review cycle for the 6.18.17 release.
There are 314 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.18.y&id2=v6.18.16
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Aaron Ma (1):
  ice: recap the VSI and QoS info after rebuild

Akhilesh Patil (1):
  hwmon: (aht10) Add support for dht20

Aksh Garg (1):
  PCI: dwc: ep: Fix resizable BAR support for multi-PF configurations

Alain Volmat (1):
  spi: stm32: fix missing pointer assignment in case of dma chaining

Alban Bedel (1):
  can: mcp251x: fix deadlock in error path of mcp251x_open

Alexander Stein (2):
  ASoC: fsl_xcvr: use dev_err_probe() replacing dev_err() + return
  ASoC: fsl_xcvr: provide regmap names

Alexandre Courbot (1):
  rust: kunit: fix warning when !CONFIG_PRINTK

Allison Henderson (1):
  net/rds: Fix circular locking dependency in rds_tcp_tune

Anand Moon (1):
  PCI: j721e: Use devm_clk_get_optional_enabled() to get and enable the
    clock

Andrew Cooper (1):
  x86/fred: Correct speculative safety in fred_extint()

Andrew Lunn (1):
  net: phy: register phy led_triggers during probe to avoid AB-BA
    deadlock

Ankit Garg (1):
  gve: fix incorrect buffer cleanup in gve_tx_clean_pending_packets for
    QPL

Ariel Silver (1):
  wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration

Bart Van Assche (5):
  drm/amdgpu: Unlock a mutex before destroying it
  drm/amdgpu: Fix locking bugs in error paths
  hwmon: (it87) Check the it87_lock() return value
  wifi: cw1200: Fix locking in error paths
  wifi: wlcore: Fix a locking bug

Bence Csókás (1):
  ARM: dts: imx53-usbarmory: Replace license text comment with SPDX
    identifier

Bjorn Helgaas (2):
  PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value
  PCI: dwc: Advertise L1 PM Substates only if driver requests it

Bobby Eshleman (1):
  net: devmem: use READ_ONCE/WRITE_ONCE on binding->dev

Brad Spengler (1):
  drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release

Brian Vazquez (1):
  idpf: change IRQ naming to match netdev and ethtool queue numbering

Catalin Marinas (1):
  arm64: gcs: Do not set PTE_SHARED on GCS mappings if FEAT_LPA2 is
    enabled

Charles Haithcock (1):
  i2c: i801: Revert "i2c: i801: replace acpi_lock with I2C bus lock"

Chen Ni (1):
  drm/imx: parallel-display: check return value of devm_drm_bridge_add()
    in imx_pd_probe()

Chintan Vankar (1):
  net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry
    handling in ALE table

Christian Brauner (1):
  namespace: fix proc mount iteration

Christoph Böhmwalder (1):
  drbd: fix null-pointer dereference on local read error

Christoph Hellwig (2):
  zloop: advertise a volatile write cache
  zloop: check for spurious options passed to remove

Conor Dooley (1):
  pinctrl: generic: move function to amlogic-am4 driver

Corey Minyard (1):
  ipmi: Fix use-after-free and list corruption on sender error

Daniel Hodges (1):
  wifi: libertas: fix use-after-free in lbs_free_adapter()

Daniil Dulov (1):
  wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()

Darrick J. Wong (1):
  xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure

Dave Jiang (2):
  cxl: Move devm_cxl_add_nvdimm_bridge() to cxl_pmem.ko
  cxl: Fix race of nvdimm_bus object when creating nvdimm objects

David Carlier (1):
  sched_ext: Fix SCX_EFLAG_INITIALIZED being a no-op flag

David Howells (1):
  netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict
    sequence

David Thomson (1):
  xen/acpi-processor: fix _CST detection using undersized evaluation
    buffer

Davide Caratti (1):
  net/sched: ets: fix divide by zero in the offload path

Deepanshu Kartikey (1):
  mm: thp: deny THP for files on anonymous inodes

Dikshita Agarwal (2):
  media: iris: remove v4l2_m2m_ioctl_{de,en}coder_cmd API usage during
    STOP handling
  media: iris: Add missing platform data entries for SM8750

Eduard Zingerman (1):
  bpf: collect only live registers in linked regs

Eric Dumazet (5):
  net: annotate data-races around sk->sk_{data_ready,write_space}
  inet: annotate data-races around isk->inet_num
  indirect_call_wrapper: do not reevaluate function pointer
  tcp: secure_seq: add back ports to TS offset
  net_sched: sch_fq: clear q->band_pkt_count[] in fq_reset()

Ethan Nelson-Moore (1):
  net: arcnet: com20020-pci: fix support for 2.5Mbit cards

Ethan Tidmore (2):
  drm/tiny: sharp-memory: fix pointer error dereference
  xfs: Fix error pointer dereference

Fabio M. De Francesco (1):
  ACPI: APEI: GHES: Add helper for CPER CXL protocol errors checks

Fedor Pchelkin (1):
  ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths

Felix Gu (4):
  drm/logicvc: Fix device node reference leak in
    logicvc_drm_config_parse()
  regulator: bq257xx: Fix device node reference leak in
    bq257xx_reg_dt_parse_gpio()
  pinctrl: meson: amlogic-a4: Fix device node reference leak in
    aml_dt_node_to_map_pinmux()
  pinctrl: cirrus: cs42l43: Fix double-put in cs42l43_pin_probe()

Fernando Fernandez Mancera (2):
  net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled
  net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled

Florian Eckert (2):
  pinctrl: equilibrium: rename irq_chip function callbacks
  pinctrl: equilibrium: fix warning trace on load

Florian Westphal (1):
  netfilter: nft_set_pipapo: split gc into unlink and reclaim phase

Francesco Lavra (1):
  drm/solomon: Fix page start when updating rectangle in page addressing
    mode

Fuad Tabba (3):
  KVM: arm64: Hide S1POE from guests when not supported by the host
  KVM: arm64: Fix ID register initialization for non-protected pKVM
    guests
  bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic
    tearing

Geoffrey D. Bennett (3):
  ALSA: scarlett2: Fix DSP filter control array handling
  ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
  ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP

Greg Kroah-Hartman (12):
  nfc: pn533: properly drop the usb interface reference on disconnect
  net: usb: kaweth: validate USB endpoints
  net: usb: kalmia: validate USB endpoints
  net: usb: pegasus: validate USB endpoints
  can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of
    a message
  can: usb: f81604: correctly anchor the urb in the read bulk callback
  can: ucan: Fix infinite loop from zero-length messages
  can: usb: etas_es58x: correctly anchor the urb in the read bulk
    callback
  can: usb: f81604: handle short interrupt urb messages properly
  can: usb: f81604: handle bulk write errors properly
  HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them
  Revert "netfilter: nft_set_rbtree: validate open interval overlap"

Guenter Roeck (3):
  dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ
    handler
  ata: libata-eh: Fix detection of deferred qc timeouts
  tracing: Add NULL pointer check to trigger_data_free()

Gui-Dong Han (1):
  hwmon: (max16065) Use READ/WRITE_ONCE to avoid compiler optimization
    induced race

Hao Yu (1):
  hwmon: (aht10) Fix initialization commands for AHT20

Haocheng Yu (1):
  perf/core: Fix refcount bug and potential UAF in perf_mmap

Harishankar Vishwanathan (1):
  bpf: Introduce tnum_step to step through tnum's members

Harry Yoo (1):
  mm/slab: use prandom if !allow_spin

Heiko Carstens (2):
  s390/idle: Fix cpu idle exit cpu time accounting
  s390/vtime: Fix virtual timer forwarding

Heitor Alves de Siqueira (1):
  Bluetooth: purge error queues in socket destructors

Henrique Carvalho (1):
  smb: client: fix cifs_pick_channel when channels are equally loaded

Ian Forbes (1):
  drm/vmwgfx: Return the correct value in vmw_translate_ptr functions

Ian Ray (2):
  HID: multitouch: new class MT_CLS_EGALAX_P80H84
  net: nfc: nci: Fix zero-length proprietary notifications

Imre Deak (2):
  drm/i915/dp: Fail state computation for invalid DSC source input BPP
    values
  drm/i915/dp: Fix pipe BPP clamping due to HDR

Ingo Molnar (3):
  sched/fair: Rename cfs_rq::avg_load to cfs_rq::sum_weight
  sched/fair: Rename cfs_rq::avg_vruntime to ::sum_w_vruntime, and
    helper functions
  sched/fair: Introduce and use the vruntime_cmp() and vruntime_op()
    wrappers for wrapped-signed aritmetics

Jakub Kicinski (6):
  tcp: give up on stronger sk_rcvbuf checks (for now)
  ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()
  nfc: nci: free skb on nci_transceive early error paths
  nfc: nci: complete pending data exchange on device close
  nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback
  nfc: rawsock: cancel tx_work before socket teardown

Jamal Hadi Salim (1):
  net/sched: act_ife: Fix metalist update behavior

Jan Stancek (1):
  x86/boot: Handle relative CONFIG_EFI_SBAT_FILE file paths

Jann Horn (1):
  eventpoll: Fix integer overflow in ep_loop_check_proc()

Jason Gunthorpe (3):
  IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()
  RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()
  RDMA/ionic: Fix kernel stack leak in ionic_create_cq()

Jens Axboe (1):
  media: dvb-core: fix wrong reinitialization of ringbuffer on reopen

Jiayuan Chen (5):
  bpf: Fix race in cpumap on PREEMPT_RT
  bpf: Fix race in devmap on PREEMPT_RT
  atm: lec: fix null-ptr-deref in lec_arp_clear_vccs
  bpf/bonding: reject vlan+srcmac xmit_hash_policy change when XDP is
    loaded
  net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop

Jinhui Guo (1):
  iommu/vt-d: Skip dev-iotlb flush for inaccessible PCIe device without
    scalable mode

Johan Hovold (4):
  memory: mtk-smi: fix device leaks on common probe
  memory: mtk-smi: fix device leak on larb probe
  drm/tegra: dsi: fix device leak on probe
  clk: tegra: tegra124-emc: fix device leak on set_rate()

Johannes Berg (1):
  wifi: radiotap: reject radiotap with unknown bits

Jonathan Cavitt (1):
  drm/client: Do not destroy NULL modes

Jonathan Teh (1):
  platform/x86: thinkpad_acpi: Fix errors reading battery thresholds

Josh Poimboeuf (1):
  unwind_user/x86: Enable frame pointer unwinding on x86

Juhyung Park (2):
  ALSA: hda/realtek: fix model name typo for Samsung Galaxy Book Flex
    (NT950QCG-X716)
  ALSA: hda/realtek: add quirk for Samsung Galaxy Book Flex
    (NT950QCT-A38A)

Julian Orth (1):
  drm/syncobj: Fix handle <-> fd ioctls with dirty stack

Jun Seo (1):
  ALSA: usb-audio: Use correct version for UAC3 header validation

Junxiao Bi (1):
  scsi: core: Fix refcount leak for tagset_refcnt

Justin Tee (1):
  nvmet-fcloop: Check remoteport port_state before calling done callback

Keith Busch (1):
  nvme-multipath: fix leak on try_module_get failure

Khushit Shah (1):
  KVM: x86: Add x2APIC "features" to control EOI broadcast suppression

Kim Phillips (1):
  x86/sev: Allow IBPB-on-Entry feature for SNP guests

Kohei Enju (2):
  bpf: Fix stack-out-of-bounds write in devmap
  iavf: fix netdev->max_mtu to respect actual hardware limit

Koichiro Den (1):
  net: sched: avoid qdisc_reset_all_tx_gt() vs dequeue race for lockless
    qdiscs

Kuen-Han Tsai (3):
  usb: gadget: u_ether: add gether_opts for config caching
  usb: gadget: u_ether: Add auto-cleanup helper for freeing net_device
  usb: gadget: f_ncm: align net_device lifecycle with bind/unbind

Kuniyuki Iwashima (2):
  nfsd: Fix cred ref leak in nfsd_nl_threads_set_doit().
  udp: Unhash auto-bound connected sk from 4-tuple hash table when
    disconnected.

Kurt Borja (2):
  platform/x86: alienware-wmi-wmax: Add G-Mode support to m18 laptops
  platform/x86: dell-wmi: Add audio/mic mute key codes

Lang Xu (1):
  bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim

Lars Ellenberg (1):
  drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()

Larysa Zaremba (7):
  ice: fix adding AQ LLDP filter for VF
  xdp: use modulo operation to calculate XDP frag tailroom
  xsk: introduce helper to determine rxq->frag_size
  i40e: fix registering XDP RxQ info
  i40e: use xdp.frame_sz as XDP RxQ info frag_size
  net: enetc: use truesize as XDP RxQ info frag_size
  xdp: produce a warning when calculated tailroom is negative

Li Li (1):
  idpf: increment completion queue next_to_clean in sw marker wait
    routine

Lijo Lazar (1):
  drm/amdgpu: Fix error handling in slot reset

Lizhi Hou (3):
  accel/amdxdna: Remove buffer size check when creating command BO
  accel/amdxdna: Prevent ubuf size overflow
  accel/amdxdna: Validate command buffer payload count

Lorenzo Bianconi (4):
  wifi: mt76: mt7996: Fix possible oob access in
    mt7996_mac_write_txwi_80211()
  wifi: mt76: mt7925: Fix possible oob access in
    mt7925_mac_write_txwi_80211()
  wifi: mt76: Fix possible oob access in
    mt76_connac2_mac_write_txwi_80211()
  net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of
    error in mtk_xdp_setup()

MD Danish Anwar (1):
  net: ti: icssg-prueth: Fix ping failure after offload mode setup when
    link speed is not 1G

Manivannan Sadhasivam (1):
  net: qrtr: Drop the MHI auto_queue feature for IPCR DL channels

Marco Crivellari (1):
  Input: synaptics_i2c - replace use of system_wq with system_dfl_wq

Mario Limonciello (2):
  drm/amd: Fix hang on amdgpu unload by using pci_dev_is_disconnected()
  platform/x86: hp-bioscfg: Support allocations of larger data

Mariusz Skamra (1):
  Bluetooth: Fix CIS host feature condition

Mark Harmstone (6):
  btrfs: fix error message order of parameters in
    btrfs_delete_delayed_dir_index()
  btrfs: fix incorrect key offset in error message in
    check_dev_extent_item()
  btrfs: fix objectid value in error message in check_extent_data_ref()
  btrfs: fix warning in scrub_verify_one_metadata()
  btrfs: print correct subvol num if active swapfile prevents deletion
  btrfs: fix compat mask in error messages in btrfs_check_features()

Mathias Krause (1):
  scsi: lpfc: Properly set WC for DPP mapping

Mathieu Desnoyers (1):
  rseq: Clarify rseq registration rseq_size bound check comment

Matt Roper (1):
  drm/xe/wa: Steer RMW of MCR registers while building default LRC

Matthew Brost (1):
  drm/xe: Do not preempt fence signaling CS instructions

Matthieu Baerts (NGI0) (4):
  mptcp: pm: avoid sending RM_ADDR over same subflow
  mptcp: pm: in-kernel: always mark signal+subflow endp as used
  selftests: mptcp: join: check RM_ADDR not sent over same subflow
  selftests: mptcp: join: check removing signal+subflow endp

Maulik Shah (1):
  pinctrl: qcom: qcs615: Add missing dual edge GPIO IRQ errata flag

Michal Swiatkowski (1):
  libie: don't unroll if fwlog isn't supported

Mieczyslaw Nalewaj (1):
  net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value

Mike Rapoport (Microsoft) (1):
  x86/efi: defer freeing of boot services memory

Ming Lei (2):
  nvme: fix admin queue leak on controller reset
  block: use trylock to avoid lockdep circular dependency in sysfs

Ming Qian (1):
  media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC

Minseong Kim (1):
  Input: synaptics_i2c - guard polling restart in resume

Miquel Sabaté Solà (2):
  btrfs: free pages on error in btrfs_uring_read_extent()
  btrfs: define the AUTO_KFREE/AUTO_KVFREE helper macros

Miroslav Lichvar (1):
  timekeeping: Fix timex status validation for auxiliary clocks

Nam Cao (1):
  irqchip/sifive-plic: Fix frozen interrupt due to affinity setting

Namhyung Kim (1):
  perf/core: Fix invalid wait context in ctx_sched_in()

Naohiro Aota (1):
  btrfs: zoned: fixup last alloc pointer after extent removal for
    RAID0/10

Natalie Vock (1):
  drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink

Nathan Chancellor (2):
  ACPI: APEI: GHES: Disable KASAN instrumentation when compile testing
    with clang < 18
  kbuild: Split .modinfo out from ELF_DETAILS

Nicolas Dufresne (1):
  media: v4l2-mem2mem: Add a kref to the v4l2_m2m_dev structure

Nikhil P. Rao (2):
  xsk: Fix fragment node deletion to prevent buffer leak
  xsk: Fix zero-copy AF_XDP fragment drop

Niklas Cassel (2):
  PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry
  Revert "PCI: dw-rockchip: Enumerate endpoints based on dll_link_up
    IRQ"

Oleg Nesterov (1):
  x86/uprobes: Fix XOL allocation failure for 32-bit tasks

Oliver Hartkopp (1):
  can: bcm: fix locking for bcm_op runtime updates

Olivier Sobrie (1):
  hwmon: (max6639) fix inverted polarity

Ovidiu Panait (4):
  net: stmmac: Fix error handling in VLAN add and delete paths
  net: stmmac: Improve double VLAN handling
  net: stmmac: Fix VLAN HW state restore
  net: stmmac: Defer VLAN HW configuration when interface is down

Pablo Neira Ayuso (2):
  netfilter: nf_tables: unconditionally bump set->nelems before
    insertion
  netfilter: nf_tables: clone set on flush only

Panagiotis Foliadis (2):
  ALSA: hda/intel: increase default bdl_pos_adj for Nvidia controllers
  ALSA: hda/realtek: Add quirk for Acer Aspire V3-572G

Paolo Abeni (1):
  selftests: mptcp: more stable simult_flows tests

Paul Chaignon (1):
  bpf: Improve bounds when tnum has a single possible value

Paulo Alcantara (2):
  smb: client: fix broken multichannel with krb5+signing
  smb: client: fix oops due to uninitialised var in smb2_unlink()

Peter Wang (1):
  scsi: ufs: core: Move link recovery for hibern8 exit failure to
    wl_resume

Peter Zijlstra (8):
  x86/cfi: Fix CFI rewrite for odd alignments
  sched/fair: Fix zero_vruntime tracking
  sched/fair: Only set slice protection at pick time
  sched/fair: Fix lag clamp
  perf: Fix __perf_event_overflow() vs perf_remove_from_context() race
  unwind: Simplify unwind_user_next_fp() alignment check
  unwind: Implement compat fp unwind
  unwind_user/x86: Teach FP unwind about start of function

Petr Pavlu (1):
  module: Remove duplicate freeing of lockdep classes

Phillip Lougher (1):
  Squashfs: check metadata block offset is within range

Prithvi Tambewagh (1):
  scsi: target: Fix recursive locking in __configfs_open_file()

Qiang Yu (3):
  PCI: Add preceding capability position support in PCI_FIND_NEXT_*_CAP
    macros
  PCI: dwc: Add new APIs to remove standard and extended Capability
  PCI: dwc: Remove duplicate dw_pcie_ep_hide_ext_capability() function

Qing Wang (1):
  tracing: Fix WARN_ON in tracing_buffers_mmap_close

Quentin Schulz (2):
  accel/rocket: fix unwinding in error path in rocket_core_init
  accel/rocket: fix unwinding in error path in rocket_probe

Raju Rangoju (2):
  amd-xgbe: fix MAC_TCR_SS register width for 2.5G and 10M speeds
  amd-xgbe: fix sleep while atomic on suspend/resume

Richard Fitzgerald (1):
  ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()

Rong Zhang (1):
  ALSA: doc: usb-audio: Add doc for QUIRK_FLAG_SKIP_IFACE_SETUP

Russell King (Oracle) (1):
  net: stmmac: remove support for lpi_intr_o

Salomon Dushimirimana (1):
  scsi: pm8001: Fix use-after-free in pm8001_queue_command()

Sasha Levin (1):
  Linux 6.18.17-rc1

Sean Christopherson (1):
  KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()

Sebastian Andrzej Siewior (1):
  net: Provide a PREEMPT_RT specific check for netdev_queue::_xmit_lock

Sebastian Krzyszkowiak (1):
  wifi: rsi: Don't default to -EOPNOTSUPP in rsi_mac80211_config

Shawn Lin (5):
  PCI: dw-rockchip: Configure L1SS support
  PCI: dwc: Add L1 Substates context to ltssm_status of debugfs
  PCI: dw-rockchip: Change get_ltssm() to provide L1 Substates info
  arm64: dts: rockchip: Fix rk356x PCIe range mappings
  arm64: dts: rockchip: Fix rk3588 PCIe range mappings

Shuicheng Lin (2):
  drm/xe/configfs: Free ctx_restore_mid_bb in release
  drm/xe/reg_sr: Fix leak on xa_store failure

Shuvam Pandey (1):
  kunit: tool: copy caller args in run_kernel to prevent mutation

Siddharth Vadapalli (1):
  PCI: j721e: Add config guards for Cadence Host and Endpoint library
    APIs

Simon Ser (1):
  drm/fourcc: fix plane order for 10/12/16-bit YCbCr formats

Sreedevi Joshi (1):
  idpf: Fix flow rule delete failure due to invalid validation

Srinivas Pandruvada (1):
  cpufreq: intel_pstate: Fix crash during turbo disable

Stefan Hajnoczi (1):
  nvme: reject invalid pr_read_keys() num_keys values

Sun Jian (1):
  selftests/harness: order TEST_F and XFAIL_ADD constructors

Sungwoo Kim (1):
  nvme: fix memory allocation in nvme_pr_read_keys()

T.J. Mercier (1):
  selftests/bpf: Fix OOB read in dmabuf_collector

Takashi Iwai (4):
  ALSA: usb-audio: Cap the packet size pre-calculations
  ALSA: usb-audio: Use inclusive terms
  ALSA: usb: qcom: Correct parameter comment for
    uaudio_transfer_buffer_setup()
  ASoC: SDCA: Fix comments for sdca_irq_request()

Thomas Gleixner (2):
  debugobject: Make it work with deferred page initialization - again
  i40e: Fix preempt count leak in napi poll tracepoint

Thomas Weißschuh (1):
  ARM: clean up the memset64() C wrapper

Thorsten Blum (2):
  platform/x86: dell-wmi-sysman: Don't hex dump plaintext password data
  smb: client: Don't log plaintext credentials in cifs_set_cifscreds

Tianci Cao (1):
  bpf: Add bitwise tracking for BPF_END

Tiezhu Yang (3):
  LoongArch: Remove unnecessary checks for ORC unwinder
  LoongArch: Handle percpu handler address for ORC unwinder
  LoongArch: Remove some extern variables in source files

Tom Lendacky (1):
  x86/boot/sev: Move SEV decompressor variables into the .data section

Tomasz Pakuła (1):
  HID: pidff: Fix condition effect bit clearing

Tvrtko Ursulin (1):
  drm/amdgpu/userq: Do not allow userspace to trivially triger kernel
    warnings

Vahagn Vardanian (1):
  wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()

Vimlesh Kumar (4):
  octeon_ep: Relocate counter updates before NAPI
  octeon_ep: avoid compiler and IQ/OQ reordering
  octeon_ep_vf: Relocate counter updates before NAPI
  octeon_ep_vf: avoid compiler and IQ/OQ reordering

Vitaly Lifshits (1):
  e1000e: clear DPG_EN after reset to avoid autonomous power-gating

Vivek Behera (1):
  igb: Fix trigger of incorrect irq in igb_xsk_wakeup

Vlastimil Babka (1):
  slub: remove CONFIG_SLUB_TINY specific code paths

Waiman Long (1):
  cgroup/cpuset: Fix incorrect use of cpuset_update_tasks_cpumask() in
    update_cpumasks_hier()

Wake Liu (1):
  kselftest/harness: Use helper to avoid zero-size memset warning

Wang Tao (1):
  sched/eevdf: Update se->vprot in reweight_entity()

Werner Sembach (1):
  HID: multitouch: Keep latency normal on deactivate for reactivation
    gesture

Will Deacon (2):
  arm64: io: Rename ioremap_prot() to __ioremap_prot()
  arm64: io: Extract user memory type in ioremap_prot()

Xuewen Yan (1):
  PM: sleep: core: Avoid bit field races related to work_in_progress

Yang Erkun (1):
  ext4: correct the comments place for EXT4_EXT_MAY_ZEROOUT

Yazen Ghannam (1):
  x86/acpi/boot: Correct acpi_is_processor_usable() check again

Yifan Wu (1):
  selftest/arm64: Fix sve2p1_sigill() to hwcap test

Yujie Liu (1):
  drm/sched: Fix kernel-doc warning for drm_sched_job_done()

Yung Chih Su (1):
  net: ipv4: fix ARM64 alignment fault in multipath hash seed

Zhang Heng (1):
  ALSA: hda/realtek: Add quirk for HP Pavilion 15-eh1xxx to enable mute
    LED

Zhang Yi (1):
  ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before
    submitting I/O

ZhangGuoDong (2):
  smb/client: fix buffer size for smb311_posix_qinfo in
    smb2_compound_op()
  smb/client: fix buffer size for smb311_posix_qinfo in
    SMB311_posix_query_info()

Zhanjun Dong (1):
  drm/xe/gsc: Fix GSC proxy cleanup on early initialization failure

Zide Chen (1):
  perf/x86/intel/uncore: Add per-scheduler IMC CAS count events

Zilin Guan (1):
  media: tegra-video: Fix memory leak in __tegra_channel_try_format()

 Documentation/hwmon/aht10.rst                 |  10 +-
 Documentation/sound/alsa-configuration.rst    |   4 +
 Documentation/virt/kvm/api.rst                |  28 ++-
 Makefile                                      |   4 +-
 arch/alpha/kernel/vmlinux.lds.S               |   1 +
 arch/arc/kernel/vmlinux.lds.S                 |   1 +
 arch/arm/boot/compressed/vmlinux.lds.S        |   1 +
 arch/arm/boot/dts/nxp/imx/imx53-usbarmory.dts |  39 +--
 arch/arm/include/asm/string.h                 |  14 +-
 arch/arm/kernel/vmlinux-xip.lds.S             |   1 +
 arch/arm/kernel/vmlinux.lds.S                 |   1 +
 arch/arm64/boot/dts/rockchip/rk3568.dtsi      |   4 +-
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |   4 +-
 .../arm64/boot/dts/rockchip/rk3588-extra.dtsi |   6 +-
 arch/arm64/include/asm/io.h                   |  26 +-
 arch/arm64/include/asm/pgtable-prot.h         |   3 -
 arch/arm64/kernel/acpi.c                      |   2 +-
 arch/arm64/kernel/vmlinux.lds.S               |   1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  35 ++-
 arch/arm64/kvm/sys_regs.c                     |   3 +
 arch/arm64/mm/ioremap.c                       |   6 +-
 arch/arm64/mm/mmap.c                          |   8 +-
 arch/arm64/net/bpf_jit_comp.c                 |   2 +-
 arch/csky/kernel/vmlinux.lds.S                |   1 +
 arch/hexagon/kernel/vmlinux.lds.S             |   1 +
 arch/loongarch/include/asm/setup.h            |   3 +
 arch/loongarch/kernel/unwind_orc.c            |  28 ++-
 arch/loongarch/kernel/unwind_prologue.c       |   4 -
 arch/loongarch/kernel/vmlinux.lds.S           |   1 +
 arch/loongarch/mm/tlb.c                       |   1 -
 arch/m68k/kernel/vmlinux-nommu.lds            |   1 +
 arch/m68k/kernel/vmlinux-std.lds              |   1 +
 arch/m68k/kernel/vmlinux-sun3.lds             |   1 +
 arch/mips/kernel/vmlinux.lds.S                |   1 +
 arch/nios2/kernel/vmlinux.lds.S               |   1 +
 arch/openrisc/kernel/vmlinux.lds.S            |   1 +
 arch/parisc/boot/compressed/vmlinux.lds.S     |   1 +
 arch/parisc/kernel/vmlinux.lds.S              |   1 +
 arch/powerpc/kernel/vmlinux.lds.S             |   1 +
 arch/riscv/kernel/vmlinux.lds.S               |   1 +
 arch/s390/include/asm/idle.h                  |   1 +
 arch/s390/kernel/idle.c                       |  13 +-
 arch/s390/kernel/irq.c                        |  10 +-
 arch/s390/kernel/vmlinux.lds.S                |   1 +
 arch/s390/kernel/vtime.c                      |  18 +-
 arch/sh/kernel/vmlinux.lds.S                  |   1 +
 arch/sparc/kernel/vmlinux.lds.S               |   1 +
 arch/um/kernel/dyn.lds.S                      |   1 +
 arch/um/kernel/uml.lds.S                      |   1 +
 arch/x86/Kconfig                              |   1 +
 arch/x86/boot/compressed/Makefile             |   1 +
 arch/x86/boot/compressed/sev.c                |   9 +-
 arch/x86/boot/compressed/vmlinux.lds.S        |   2 +-
 arch/x86/boot/startup/sev-shared.c            |   2 +-
 arch/x86/coco/sev/core.c                      |   1 +
 arch/x86/entry/entry_fred.c                   |   5 +-
 arch/x86/events/core.c                        |  40 ---
 arch/x86/events/intel/uncore_snbep.c          |  28 ++-
 arch/x86/include/asm/cfi.h                    |  12 +-
 arch/x86/include/asm/efi.h                    |   2 +-
 arch/x86/include/asm/kvm_host.h               |   7 +
 arch/x86/include/asm/linkage.h                |   4 +-
 arch/x86/include/asm/msr-index.h              |   5 +-
 arch/x86/include/asm/unwind_user.h            |  37 +++
 arch/x86/include/asm/uprobes.h                |   9 +
 arch/x86/include/uapi/asm/kvm.h               |   6 +-
 arch/x86/kernel/acpi/boot.c                   |  12 +-
 arch/x86/kernel/alternative.c                 |  29 ++-
 arch/x86/kernel/cpu/topology.c                |  15 --
 arch/x86/kernel/uprobes.c                     |  56 +++++
 arch/x86/kernel/vmlinux.lds.S                 |   1 +
 arch/x86/kvm/ioapic.c                         |   2 +-
 arch/x86/kvm/lapic.c                          |  76 +++++-
 arch/x86/kvm/lapic.h                          |   2 +
 arch/x86/kvm/x86.c                            |  24 +-
 arch/x86/net/bpf_jit_comp.c                   |  13 +-
 arch/x86/platform/efi/efi.c                   |   2 +-
 arch/x86/platform/efi/quirks.c                |  55 +++-
 block/blk-sysfs.c                             |   8 +-
 block/elevator.c                              |  12 +-
 drivers/accel/amdxdna/amdxdna_ctx.c           |   5 +-
 drivers/accel/amdxdna/amdxdna_gem.c           |  38 +--
 drivers/accel/amdxdna/amdxdna_ubuf.c          |   6 +-
 drivers/accel/qaic/mhi_controller.c           |  44 ----
 drivers/accel/rocket/rocket_core.c            |   7 +-
 drivers/accel/rocket/rocket_drv.c             |  15 +-
 drivers/acpi/apei/Makefile                    |   5 +
 drivers/acpi/apei/ghes.c                      |  18 +-
 drivers/acpi/apei/ghes_helpers.c              |  33 +++
 drivers/ata/libata-eh.c                       |   2 +-
 drivers/block/drbd/drbd_actlog.c              |  53 ++--
 drivers/block/drbd/drbd_interval.h            |   5 +-
 drivers/block/drbd/drbd_req.c                 |   3 +-
 drivers/block/zloop.c                         |  31 ++-
 drivers/bus/mhi/host/pci_generic.c            |  20 +-
 drivers/char/ipmi/ipmi_msghandler.c           |  11 +-
 drivers/clk/tegra/clk-tegra124-emc.c          |   2 +-
 drivers/cpufreq/intel_pstate.c                |  10 +-
 drivers/cxl/core/pmem.c                       |  42 +++-
 drivers/cxl/cxl.h                             |   7 +
 drivers/cxl/pmem.c                            |  22 +-
 drivers/firmware/efi/mokvar-table.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c       |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c    |  12 +-
 .../gpu/drm/amd/amdgpu/amdgpu_userq_fence.c   |   8 +-
 .../gpu/drm/amd/display/dc/core/dc_stream.c   |   2 +-
 drivers/gpu/drm/drm_client_modeset.c          |   3 +-
 drivers/gpu/drm/drm_syncobj.c                 |   4 +-
 drivers/gpu/drm/i915/display/intel_dp.c       |  48 +++-
 drivers/gpu/drm/imx/ipuv3/parallel-display.c  |   4 +-
 drivers/gpu/drm/logicvc/logicvc_drm.c         |   4 +-
 drivers/gpu/drm/scheduler/sched_main.c        |   1 +
 drivers/gpu/drm/solomon/ssd130x.c             |   6 +-
 drivers/gpu/drm/tegra/dsi.c                   |   6 +-
 drivers/gpu/drm/tiny/sharp-memory.c           |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c       |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c    |   9 +-
 drivers/gpu/drm/xe/regs/xe_engine_regs.h      |   6 +
 drivers/gpu/drm/xe/xe_configfs.c              |   1 +
 drivers/gpu/drm/xe/xe_gsc_proxy.c             |  43 +++-
 drivers/gpu/drm/xe/xe_gsc_types.h             |   2 +
 drivers/gpu/drm/xe/xe_gt.c                    |  66 ++++-
 drivers/gpu/drm/xe/xe_reg_sr.c                |   4 +-
 drivers/gpu/drm/xe/xe_ring_ops.c              |   9 +
 drivers/hid/hid-cmedia.c                      |   2 +-
 drivers/hid/hid-creative-sb0540.c             |   2 +-
 drivers/hid/hid-multitouch.c                  |  43 +++-
 drivers/hid/hid-zydacron.c                    |   2 +-
 drivers/hid/usbhid/hid-pidff.c                |  11 +-
 drivers/hwmon/Kconfig                         |   6 +-
 drivers/hwmon/aht10.c                         |  21 +-
 drivers/hwmon/it87.c                          |   5 +-
 drivers/hwmon/max16065.c                      |  26 +-
 drivers/hwmon/max6639.c                       |   2 +-
 drivers/i2c/busses/i2c-i801.c                 |  14 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   |   2 +-
 drivers/infiniband/hw/irdma/verbs.c           |   2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |   5 +-
 drivers/input/mouse/synaptics_i2c.c           |  13 +-
 drivers/iommu/intel/pasid.c                   |   8 +
 drivers/irqchip/irq-sifive-plic.c             |   7 +-
 drivers/media/dvb-core/dmxdev.c               |   4 +-
 .../platform/qcom/iris/iris_platform_gen2.c   |   2 +
 drivers/media/platform/qcom/iris/iris_vidc.c  |  10 +-
 drivers/media/platform/verisilicon/hantro.h   |   2 +
 .../media/platform/verisilicon/hantro_drv.c   |  42 +++-
 .../media/platform/verisilicon/imx8m_vpu_hw.c |   8 +
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  23 ++
 drivers/memory/mtk-smi.c                      |   3 +
 drivers/net/arcnet/com20020-pci.c             |  16 +-
 drivers/net/bonding/bond_main.c               |   9 +-
 drivers/net/bonding/bond_options.c            |   2 +
 drivers/net/can/spi/mcp251x.c                 |  15 +-
 drivers/net/can/usb/ems_usb.c                 |   7 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c   |   8 +-
 drivers/net/can/usb/f81604.c                  |  45 +++-
 drivers/net/can/usb/ucan.c                    |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c           |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h   |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  10 -
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h          |   3 -
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  56 ++---
 drivers/net/ethernet/intel/e1000e/defines.h   |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c   |   9 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  41 +--
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  17 +-
 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_idc.c      |  44 +++-
 drivers/net/ethernet/intel/ice/ice_main.c     |   7 +-
 .../net/ethernet/intel/idpf/idpf_ethtool.c    |   3 -
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   |   8 +-
 drivers/net/ethernet/intel/igb/igb_xsk.c      |  38 ++-
 drivers/net/ethernet/intel/libie/fwlog.c      |   4 +
 .../ethernet/marvell/octeon_ep/octep_main.c   |  40 ++-
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |  27 +-
 .../marvell/octeon_ep_vf/octep_vf_main.c      |  38 ++-
 .../marvell/octeon_ep_vf/octep_vf_rx.c        |  28 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  15 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   1 -
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |   4 -
 .../ethernet/stmicro/stmmac/dwmac-loongson.c  |   7 -
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  89 +++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   8 -
 .../net/ethernet/stmicro/stmmac/stmmac_vlan.c |  60 ++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   2 +-
 drivers/net/ethernet/ti/cpsw_ale.c            |   9 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c  |   8 +
 drivers/net/phy/phy_device.c                  |  25 +-
 drivers/net/usb/kalmia.c                      |   7 +
 drivers/net/usb/kaweth.c                      |  13 +
 drivers/net/usb/pegasus.c                     |  13 +-
 drivers/net/vxlan/vxlan_core.c                |   5 +
 drivers/net/wireless/ath/ath11k/mhi.c         |   4 -
 drivers/net/wireless/ath/ath12k/mhi.c         |   4 -
 drivers/net/wireless/marvell/libertas/main.c  |   4 +-
 .../wireless/mediatek/mt76/mt76_connac_mac.c  |   1 +
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |   1 +
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |   1 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c   |   2 +-
 drivers/net/wireless/st/cw1200/pm.c           |   2 +
 drivers/net/wireless/ti/wlcore/main.c         |   4 +-
 drivers/nfc/pn533/usb.c                       |   1 +
 drivers/nvme/host/core.c                      |   7 +
 drivers/nvme/host/multipath.c                 |  12 +-
 drivers/nvme/host/pr.c                        |  10 +-
 drivers/nvme/target/fcloop.c                  |  15 +-
 drivers/pci/controller/cadence/pci-j721e.c    |  57 +++--
 drivers/pci/controller/cadence/pcie-cadence.c |   4 +-
 .../controller/dwc/pcie-designware-debugfs.c  |   2 +
 .../pci/controller/dwc/pcie-designware-ep.c   |  86 +++----
 .../pci/controller/dwc/pcie-designware-host.c |   2 +
 drivers/pci/controller/dwc/pcie-designware.c  |  83 +++++-
 drivers/pci/controller/dwc/pcie-designware.h  |  15 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c | 130 +++++-----
 drivers/pci/controller/dwc/pcie-qcom.c        |   2 +
 drivers/pci/controller/dwc/pcie-tegra194.c    |   3 +
 drivers/pci/pci.c                             |   8 +-
 drivers/pci/pci.h                             |  23 +-
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c      |   5 +-
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c    |  70 +++++-
 drivers/pinctrl/pinconf-generic.c             |  69 -----
 drivers/pinctrl/pinctrl-equilibrium.c         |  31 ++-
 drivers/pinctrl/qcom/pinctrl-qcs615.c         |   1 +
 .../platform/x86/dell/alienware-wmi-wmax.c    |   2 +-
 drivers/platform/x86/dell/dell-wmi-base.c     |   6 +
 .../dell-wmi-sysman/passwordattr-interface.c  |   1 -
 .../x86/hp/hp-bioscfg/enum-attributes.c       |   9 +-
 drivers/platform/x86/lenovo/thinkpad_acpi.c   |   6 +-
 drivers/regulator/bq257xx-regulator.c         |   3 +-
 drivers/scsi/lpfc/lpfc_init.c                 |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                  |  36 ++-
 drivers/scsi/lpfc/lpfc_sli4.h                 |   3 +
 drivers/scsi/pm8001/pm8001_sas.c              |   5 +-
 drivers/scsi/scsi_scan.c                      |   1 +
 drivers/spi/spi-stm32.c                       |   3 +
 drivers/staging/media/tegra-video/vi.c        |  13 +-
 drivers/target/target_core_configfs.c         |  15 +-
 drivers/ufs/core/ufshcd.c                     |  18 +-
 drivers/usb/gadget/function/f_ncm.c           | 128 +++++-----
 drivers/usb/gadget/function/u_ether.c         |  45 ++++
 drivers/usb/gadget/function/u_ether.h         |  30 +++
 .../usb/gadget/function/u_ether_configfs.h    | 176 +++++++++++++
 drivers/usb/gadget/function/u_ncm.h           |   4 +-
 drivers/xen/xen-acpi-processor.c              |   7 +-
 fs/btrfs/delayed-inode.c                      |   2 +-
 fs/btrfs/disk-io.c                            |   6 +-
 fs/btrfs/inode.c                              |   2 +-
 fs/btrfs/ioctl.c                              |   7 +-
 fs/btrfs/misc.h                               |   7 +
 fs/btrfs/scrub.c                              |   2 +-
 fs/btrfs/tree-checker.c                       |   4 +-
 fs/btrfs/zoned.c                              | 194 ++++++++++++--
 fs/eventpoll.c                                |   5 +-
 fs/ext4/extents.c                             |  20 +-
 fs/namespace.c                                |  20 +-
 fs/netfs/direct_write.c                       | 228 +++++++++++++++--
 fs/netfs/internal.h                           |   4 +-
 fs/netfs/write_collect.c                      |  21 --
 fs/netfs/write_issue.c                        |  41 +--
 fs/nfsd/nfsctl.c                              |   2 +-
 fs/smb/client/connect.c                       |   1 -
 fs/smb/client/smb2inode.c                     |   8 +-
 fs/smb/client/smb2pdu.c                       |  24 +-
 fs/smb/client/transport.c                     |  21 +-
 fs/smb/server/smb2pdu.c                       |   4 +-
 fs/squashfs/cache.c                           |   3 +
 fs/xfs/scrub/orphanage.c                      |   7 +-
 fs/xfs/xfs_notify_failure.c                   |   4 +-
 include/asm-generic/vmlinux.lds.h             |   4 +-
 include/cxl/event.h                           |  10 +
 include/linux/indirect_call_wrapper.h         |  18 +-
 include/linux/netdevice.h                     |  27 +-
 include/linux/pinctrl/pinconf-generic.h       |   5 -
 include/linux/pm.h                            |   2 +-
 include/linux/ring_buffer.h                   |   1 +
 include/linux/sched.h                         |   1 +
 include/linux/stmmac.h                        |   1 -
 include/linux/tnum.h                          |   8 +
 include/linux/unwind_user_types.h             |   2 +
 include/linux/uprobes.h                       |   1 +
 include/media/v4l2-mem2mem.h                  |  21 ++
 include/net/bonding.h                         |   1 +
 include/net/inet6_hashtables.h                |   2 +-
 include/net/inet_hashtables.h                 |   2 +-
 include/net/ip.h                              |   2 +-
 include/net/ip_fib.h                          |   2 +-
 include/net/netfilter/nf_tables.h             |  11 +-
 include/net/sch_generic.h                     |  10 +
 include/net/secure_seq.h                      |  45 +++-
 include/net/tc_act/tc_ife.h                   |   4 +-
 include/net/tcp.h                             |   6 +-
 include/net/xdp_sock_drv.h                    |  16 +-
 include/trace/events/netfs.h                  |   4 +-
 include/uapi/drm/drm_fourcc.h                 |  12 +-
 include/uapi/linux/pci_regs.h                 |   2 +-
 kernel/bpf/cpumap.c                           |  17 +-
 kernel/bpf/devmap.c                           |  47 +++-
 kernel/bpf/tnum.c                             |  72 ++++++
 kernel/bpf/trampoline.c                       |   4 +-
 kernel/bpf/verifier.c                         | 103 +++++++-
 kernel/cgroup/cpuset.c                        |   2 +-
 kernel/events/core.c                          |  83 ++++--
 kernel/events/uprobes.c                       |  10 +-
 kernel/module/main.c                          |   6 -
 kernel/rseq.c                                 |   5 +-
 kernel/sched/ext_internal.h                   |   2 +-
 kernel/sched/fair.c                           | 238 +++++++++++++-----
 kernel/sched/sched.h                          |   4 +-
 kernel/time/timekeeping.c                     |   6 +-
 kernel/trace/ring_buffer.c                    |  21 ++
 kernel/trace/trace.c                          |  13 +
 kernel/trace/trace_events_trigger.c           |   3 +
 kernel/unwind/user.c                          |  59 ++++-
 lib/Kconfig.debug                             |   1 +
 lib/debugobjects.c                            |  19 +-
 mm/huge_memory.c                              |   3 +
 mm/slab.h                                     |   2 -
 mm/slub.c                                     | 133 ++--------
 net/atm/lec.c                                 |  26 +-
 net/bluetooth/hci_sock.c                      |   1 +
 net/bluetooth/hci_sync.c                      |   2 +-
 net/bluetooth/iso.c                           |   1 +
 net/bluetooth/l2cap_sock.c                    |   1 +
 net/bluetooth/sco.c                           |   1 +
 net/bridge/br_device.c                        |   2 +-
 net/bridge/br_input.c                         |   2 +-
 net/can/bcm.c                                 |   1 +
 net/core/dev.c                                |   7 +-
 net/core/devmem.c                             |   6 +-
 net/core/filter.c                             |   6 +-
 net/core/netpoll.c                            |   2 +-
 net/core/secure_seq.c                         |  80 +++---
 net/core/skmsg.c                              |  14 +-
 net/ipv4/inet_hashtables.c                    |   8 +-
 net/ipv4/syncookies.c                         |  11 +-
 net/ipv4/sysctl_net_ipv4.c                    |   5 +-
 net/ipv4/tcp.c                                |   4 +-
 net/ipv4/tcp_bpf.c                            |   2 +-
 net/ipv4/tcp_diag.c                           |   2 +-
 net/ipv4/tcp_input.c                          |  38 ++-
 net/ipv4/tcp_ipv4.c                           |  37 ++-
 net/ipv4/tcp_minisocks.c                      |   2 +-
 net/ipv4/udp.c                                |  27 +-
 net/ipv4/udp_bpf.c                            |   2 +-
 net/ipv6/inet6_hashtables.c                   |   3 +-
 net/ipv6/route.c                              |  11 +-
 net/ipv6/syncookies.c                         |  11 +-
 net/ipv6/tcp_ipv6.c                           |  37 ++-
 net/mac80211/mesh.c                           |   3 +
 net/mac80211/mlme.c                           |   3 +
 net/mptcp/pm.c                                |  55 +++-
 net/mptcp/pm_kernel.c                         |   9 +
 net/netfilter/nf_tables_api.c                 |  66 +++--
 net/netfilter/nft_set_hash.c                  |   1 +
 net/netfilter/nft_set_pipapo.c                |  62 ++++-
 net/netfilter/nft_set_pipapo.h                |   2 +
 net/netfilter/nft_set_rbtree.c                |  79 ++----
 net/nfc/nci/core.c                            |  30 ++-
 net/nfc/nci/data.c                            |  12 +-
 net/nfc/rawsock.c                             |  11 +
 net/qrtr/mhi.c                                |  69 ++++-
 net/rds/tcp.c                                 |  14 +-
 net/sched/act_ife.c                           |  93 ++++---
 net/sched/sch_ets.c                           |  12 +-
 net/sched/sch_fq.c                            |   1 +
 net/unix/af_unix.c                            |   8 +-
 net/wireless/core.c                           |   1 +
 net/wireless/radiotap.c                       |   4 +-
 net/xdp/xsk.c                                 |  26 +-
 rust/kernel/kunit.rs                          |   8 +
 sound/hda/codecs/realtek/alc269.c             |   5 +-
 sound/hda/codecs/side-codecs/cs35l56_hda.c    |   2 +-
 sound/hda/controllers/intel.c                 |   2 +
 sound/soc/fsl/fsl_xcvr.c                      |  89 +++----
 sound/soc/sdca/sdca_interrupts.c              |   4 +-
 sound/usb/endpoint.c                          |   9 +-
 sound/usb/mixer_scarlett2.c                   |  10 +-
 sound/usb/qcom/qc_audio_offload.c             |   2 +-
 sound/usb/quirks.c                            |   3 +-
 sound/usb/stream.c                            |   3 +
 sound/usb/usbaudio.h                          |   6 +
 sound/usb/validate.c                          |   2 +-
 tools/testing/kunit/kunit_kernel.py           |   6 +-
 tools/testing/kunit/kunit_tool_test.py        |  26 ++
 tools/testing/selftests/arm64/abi/hwcap.c     |   4 +-
 .../testing/selftests/bpf/progs/dmabuf_iter.c |   2 +-
 .../selftests/bpf/progs/exceptions_assert.c   |  34 +--
 .../selftests/bpf/progs/verifier_scalar_ids.c |  56 +++--
 .../testing/selftests/bpf/verifier/precise.c  |   8 +-
 tools/testing/selftests/kselftest_harness.h   |  15 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh |  49 ++++
 .../selftests/net/mptcp/simult_flows.sh       |  11 +-
 401 files changed, 4500 insertions(+), 2112 deletions(-)
 create mode 100644 arch/x86/include/asm/unwind_user.h
 create mode 100644 drivers/acpi/apei/ghes_helpers.c

-- 
2.51.0

