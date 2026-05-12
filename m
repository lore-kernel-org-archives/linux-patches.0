Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78363DB980;
	Tue, 12 May 2026 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607740; cv=none; b=ILBVpjp+A71sNwtUf6oAbshRSGsoMBNdh1Nx8d9dUScZcLecx+bbfqLuoSSB2HUIfCARkKeuAUbxlZhyMud2XFAIa9anbaFyn8yc17nDZJF74X2LP5eq1Jgoy0G24J0OCXOLkNQzJDVEScS4OYeXI8NRxOWzyoPWh6FTUvEytGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607740; c=relaxed/simple;
	bh=3elf2TCVllNrFrdwDDUuyA3bzAtKmwg7MxGBigbM9i4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WEhxYoE55pWnnDJ8glEk37fY3emyH4d5QXNky5anak79VlTiJPSCtjTsvF2czecoCaL5XJpXK36S4WtcLVPgaywT7rBYVONtqwGODaCrCRT8f6CzYQfRdbioorIArHQ6MCxco+VgUnJiNUxiVe9Q1KhMmZWcxYaXubasU6gKpks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JoXGx8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JoXGx8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C60FC2BCB0;
	Tue, 12 May 2026 17:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607740;
	bh=3elf2TCVllNrFrdwDDUuyA3bzAtKmwg7MxGBigbM9i4=;
	h=From:To:Cc:Subject:Date:From;
	b=0JoXGx8FEdNnJjWLIBtsVvKDzjhzZjPDEjpdUcH41w6nSQquWJTNYL1bQeX9Rd05a
	 zaiQM8fSBJcaEs3v2Q0PsY7MLHsj1YQ1HmFCVYP1CgCIZLBBiB6hRDPhfddo2coF4o
	 QsESrp8+nlR5ZdA3ZzRzGgK/5Ir31PUfmLJRbLdc=
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
Subject: [PATCH 6.12 000/206] 6.12.88-rc1 review
Date: Tue, 12 May 2026 19:37:32 +0200
Message-ID: <20260512173932.810559588@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.88-rc1
X-KernelTest-Deadline: 2026-05-14T17:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.88 release.
There are 206 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.88-rc1

Prathyushi Nangia <prathyushi.nangia@amd.com>
    x86/CPU/AMD: Prevent improper isolation of shared resources in Zen2's op cache

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Wake-up from WFI when iqrchip is in userspace

Gary Guo <gary@garyguo.net>
    rust: pin-init: fix incorrect accessor reference lifetime

David Carlier <devnexen@gmail.com>
    tracepoint: balance regfunc() on func_add() failure in tracepoint_add_func()

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: fix incorrect TLV length in CLC command

Sam Edwards <cfsworks@gmail.com>
    net: stmmac: Prevent NULL deref when RX memory exhausted

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: rename STMMAC_GET_ENTRY() -> STMMAC_NEXT_ENTRY()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: avoid shadowing global buf_sz

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aloop: Fix peer runtime UAF during format-change stop

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: caam - guard HMAC key hex dumps in hash_digest_key

Thorsten Blum <thorsten.blum@linux.dev>
    printk: add print_hex_dump_devel()

David Carlier <devnexen@gmail.com>
    gtp: disable BH before calling udp_tunnel_xmit_skb()

Junrui Luo <moonafterrain@outlook.com>
    erofs: fix unsigned underflow in z_erofs_lz4_handle_overlap()

Gao Xiang <xiang@kernel.org>
    erofs: tidy up z_erofs_lz4_handle_overlap()

Gao Xiang <xiang@kernel.org>
    erofs: move {in,out}pages into struct z_erofs_decompress_req

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx

Ard Biesheuvel <ardb@kernel.org>
    crypto: nx - Migrate to scomp API

Zilin Guan <zilin@seu.edu.cn>
    hfsplus: fix held lock freed on hfsplus_fill_super()

Deepanshu Kartikey <kartikey406@gmail.com>
    hfsplus: fix uninit-value by validating catalog record size

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: winbond: Declare the QE bit on W25NxxJW

Seohyeon Maeng <bioloidgp@gmail.com>
    udf: fix partition descriptor append bookkeeping

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: core: Optimize time for secure erase/trim for some Kingston eMMCs

David Carlier <devnexen@gmail.com>
    octeon_ep_vf: add NULL check for napi_build_skb()

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (powerz) Avoid cacheline sharing for DMA buffer

Michael S. Tsirkin <mst@redhat.com>
    dma-mapping: add __dma_from_device_group_begin()/end()

Christoph Hellwig <hch@lst.de>
    dma-mapping: drop unneeded includes from dma-mapping.h

Amir Goldstein <amir73il@gmail.com>
    fs: prepare for adding LSM blob to backing_file

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: defio: Disconnect deferred I/O from the lifetime of struct fb_info

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix use-after-free in arena_vm_close on fork

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use per-root-bridge PCIH flag to skip mem resource fixup

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Use kvm_set_pte() in kvm_flush_pte()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Move unconditional delay into timer clear scenery

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix HW timer interrupt lost when inject interrupt by software

Xianglai Li <lixianglai@loongson.cn>
    LoongArch: KVM: Fix "unreliable stack" for kvm_exc_entry

Qiang Ma <maqianga@uniontech.com>
    LoongArch: KVM: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Fix potential ADE in loongson_gpu_fixup_dma_hang()

Quentin Perret <qperret@google.com>
    KVM: arm64: Fix initialisation order in __pkvm_init_finalise()

David Woodhouse <dwmw@amazon.co.uk>
    KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value

Guangshuo Li <lgs201920130244@gmail.com>
    f2fs: fix uninitialized kobject put in f2fs_init_sysfs()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix node_cnt race between extent node destroy and writeback

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fiemap boundary handling when read extent cache is incomplete

Cen Zhang <zzzccc427@gmail.com>
    f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()

Gang Yan <yangang@kylinos.cn>
    mptcp: fix scheduling with atomic in timestamp sockopt

Gang Yan <yangang@kylinos.cn>
    mptcp: sockopt: set timestamp flags on subflow socket, not msk

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: use MPTCP_RST_EMPTCP for ACK HMAC validation failure

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: use MPJoinSynAckHMacFailure for SynAck HMAC failure

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fastclose msk when linger time is 0

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: restrict 'unknown' check to pm_nl_ctl

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: check output: catch cmd errors

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/vmw_pvrdma: Fix double free on pvrdma_alloc_ucontext() error path

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: Reject unknown opcodes before ICRC processing

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: Reject non-8-byte ATOMIC_WRITE payloads

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ocrdma: Don't NULL deref uctx on errors in ocrdma_copy_pd_uresp()

Junrui Luo <moonafterrain@outlook.com>
    RDMA/mlx5: Fix error path fall-through in mlx5_ib_dev_res_srq_init()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx4: Fix resource leak on error in mlx4_ib_create_srq()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Validate rx_hash_key_len

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Fix mana_destroy_wq_obj() cleanup in mana_ib_create_qp_rss()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Fix error unwind in mana_ib_create_qp_rss()

André Draszik <andre.draszik@linaro.org>
    power: supply: max17042: avoid overflow when determining health

Lukas Wunner <lukas@wunner.de>
    PCI/ASPM: Fix pci_clear_and_set_config_dword() usage

Lukas Wunner <lukas@wunner.de>
    PCI/AER: Stop ruling out unbound devices as error source

Shuai Xue <xueshuai@linux.alibaba.com>
    PCI/AER: Clear only error bits in PCIe Device Status

Lukas Wunner <lukas@wunner.de>
    PCI: Update saved_config_space upon resource assignment

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: check for nEPT/nNPT in slow flush hypercalls

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: validate dacloffset before building DACL pointers

Bjoern Doebel <doebel@amazon.de>
    smb: client: use kzalloc to zero-initialize security descriptor buffer

Zisen Ye <zisenye@stu.xidian.edu.cn>
    smb/client: fix out-of-bounds read in symlink_data()

Zisen Ye <zisenye@stu.xidian.edu.cn>
    smb/client: fix out-of-bounds read in smb2_compound_op()

Vasily Gorbik <gor@linux.ibm.com>
    s390/debug: Reject zero-length input in debug_input_flush_fn()

Osama Abdelkader <osama.abdelkader@gmail.com>
    riscv: kvm: fix vector context allocation leak

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/hns: Fix unlocked call to hns_roce_qp_remove()

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Fix detach procedure for virtual devices in genpd

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: vport: fix self-deadlock on release of tunnel ports

Chaitanya Kulkarni <kch@nvidia.com>
    nvmet: avoid recursive nvmet-wq flush in nvmet_ctrl_free

Chaitanya Kulkarni <kch@nvidia.com>
    nvmet-tcp: fix race between ICReq handling and queue teardown

Fedor Pchelkin <pchelkin@ispras.ru>
    nvme-apple: drop invalid put of admin queue reference count

Junrui Luo <moonafterrain@outlook.com>
    md/raid10: fix divide-by-zero in setup_geo() with zero far_copies

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix slab-out-of-bounds access in auth message processing

Christian A. Ehrhardt <lk@c--e.de>
    lib/scatterlist: fix temp buffer in extract_user_to_sg()

Christian A. Ehrhardt <lk@c--e.de>
    lib/scatterlist: fix length calculations in extract_kvec_to_sg

Lukas Wunner <lukas@wunner.de>
    lib/crypto: mpi: Fix integer underflow in mpi_read_raw_from_sgl()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Add a missing dma_wmb() for hitless STE update

Michael Bommarito <michael.bommarito@gmail.com>
    isofs: validate block number from NFS file handle in isofs_export_iget

Michael Bommarito <michael.bommarito@gmail.com>
    isofs: validate Rock Ridge CE continuation extent against volume size

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: correctly reject too-small hash devices

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: correctly reject too-small FEC devices

David Carlier <devnexen@gmail.com>
    eventfs: Hold eventfs_mutex and SRCU when remount walks events

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix a buffer overflow in ioctl processing

Mikulas Patocka <mpatocka@redhat.com>
    dm: don't report warning when doing deferred remove

Mikulas Patocka <mpatocka@redhat.com>
    dm-thin: fix metadata refcount underflow

Guangshuo Li <lgs201920130244@gmail.com>
    btrfs: fix double free in create_space_info() error path

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: remove child devices when apm is removed

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm-lpass-dai: Fix multiple graph opens

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm-dai: reset queue ptr on trigger stop

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: Intel: bytcr_wm5102: Fix MCLK leak on platform_clock_control error

Joseph Salisbury <joseph.salisbury@oracle.com>
    ASoC: fsl_easrc: fix comment typo

Tommaso Soncin <soncintommaso@gmail.com>
    ASoC: amd: yc: Add HP OMEN Gaming Laptop 16-ap0xxx product line in quirk table

Shrikanth Hegde <sshegde@linux.ibm.com>
    cpuidle: powerpc: avoid double clear when breaking snooze

Conor Dooley <conor.dooley@microchip.com>
    clk: microchip: mpfs-ccc: fix out of bounds access during output registration

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    clk: imx: imx8-acm: fix flags for acm clocks

Johan Hovold <johan@kernel.org>
    spi: topcliff-pch: fix use-after-free on unbind

Johan Hovold <johan@kernel.org>
    spi: topcliff-pch: fix controller deregistration

Thorsten Blum <thorsten.blum@linux.dev>
    thermal/drivers/sprd: Fix raw temperature clamping in sprd_thm_rawdata_to_temp

Thorsten Blum <thorsten.blum@linux.dev>
    thermal/drivers/sprd: Fix temperature clamping in sprd_thm_temp_to_rawdata

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Free thermal zone ID later during removal

Michael Bommarito <michael.bommarito@gmail.com>
    udf: reject descriptors with oversized CRC length

Johan Hovold <johan@kernel.org>
    spi: microchip-core-qspi: fix controller deregistration

Guangshuo Li <lgs201920130244@gmail.com>
    ice: fix double free in ice_sf_eth_activate() error path

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: Disable GSO for packets with small MSS

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    hv_sock: fix ARM64 support

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: of: clear OF_POPULATED on hog nodes in remove path

Xu Yang <xu.yang_2@nxp.com>
    extcon: ptn5150: handle pending IRQ events during system resume

Shyam Prasad N <sprasad@microsoft.com>
    cifs: change_conf needs to be called for session setup

Shyam Prasad N <sprasad@microsoft.com>
    cifs: abort open_cached_dir if we don't request leases

Naman Jain <namjain@linux.microsoft.com>
    block: add pgmap check to biovec_phys_mergeable

Jiexun Wang <wangjiexun2025@gmail.com>
    af_unix: Reject SIOCATMARK on non-stream sockets

Myeonghun Pak <mhun512@gmail.com>
    hwmon: (corsair-psu) Close HID device on probe errors

Johan Hovold <johan@kernel.org>
    clk: rk808: fix OF node reference imbalance

Sanman Pradhan <psanman@juniper.net>
    hwmon: (ltc2992) Fix u32 overflow in power read path

Sanman Pradhan <psanman@juniper.net>
    hwmon: (ltc2992) Clamp threshold writes to hardware range

Hongling Zeng <zenghongling@kylinos.cn>
    parisc: Fix IRQ leak in LASI driver

Pavitra Jha <jhapavitra98@gmail.com>
    net: wwan: t7xx: validate port_count against message length in t7xx_port_enum_msg_handler

Nan Li <tonanli66@gmail.com>
    net/rds: handle zerocopy send cleanup before the message is queued

Maoyi Xie <maoyixie.tju@gmail.com>
    ip6_gre: Use cached t->net in ip6erspan_changelink().

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix VF illegal register access

SeungJu Cheon <suunj1331@gmail.com>
    sound: ua101: fix division by zero at probe

Kai Zen <kai.aizen.dev@gmail.com>
    net: rtnetlink: zero ifla_vf_broadcast to avoid stack infoleak in rtnl_fill_vfinfo

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix SYM_SIGFUNC_START definition for 32BIT

Tudor Ambarus <tudor.ambarus@linaro.org>
    mtd: spi-nor: debugfs: fix out-of-bounds read in spi_nor_params_show()

Fuad Tabba <tabba@google.com>
    KVM: arm64: Fix kvm_vcpu_initialized() macro parameter

Miklos Szeredi <mszeredi@redhat.com>
    fanotify: fix false positive on permission events

Johan Hovold <johan@kernel.org>
    staging: vme_user: fix root device leak on init failure

Johan Hovold <johan@kernel.org>
    spi: s3c64xx: fix NULL-deref on driver unbind

Johan Hovold <johan@kernel.org>
    spi: zynqmp-gqspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sun6i: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: ti-qspi: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: sun4i: fix controller deregistration

Johan Hovold <johan@kernel.org>
    spi: syncuacer: fix controller deregistration

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix OOB read and infinite loop in hci_le_create_big_complete_evt

Tristan Madani <tristan@talencesecurity.com>
    Bluetooth: btmtk: validate WMT event SKB length before struct access

Michael Bommarito <michael.bommarito@gmail.com>
    Bluetooth: virtio_bt: validate rx pkt_type header length

Michael Bommarito <michael.bommarito@gmail.com>
    Bluetooth: virtio_bt: clamp rx length before skb_put

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Fix missing EMULATE_FAIL in kvm_emu_mmio_read()

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: prune /sys/fs/selinux/disable

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: shrink critical section in sel_write_load()

David Windsor <dwindsor@gmail.com>
    selinux: don't reserve xattr slot when we won't fill it

Michael Bommarito <michael.bommarito@gmail.com>
    xfrm: ah: account for ESN high bits in async callbacks

Yilin Zhu <zylzyl2333@gmail.com>
    ipv6: xfrm6: release dst on error in xfrm6_rcv_encap()

Michal Kosiorek <mkosiorek121@gmail.com>
    xfrm: defensively unhash xfrm_state lists in __xfrm_state_delete

Ruijie Li <ruijieli51@gmail.com>
    xfrm: provide message size for XFRM_MSG_MAPPING

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kdump: fix KASAN sanitization flag for core_$(BITS).o

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: firewire-tascam: Do not drop unread control events

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix data race at accessing runtime.oss.trigger

Felix Gu <ustc.gu@gmail.com>
    usb: ulpi: fix memory leak on ulpi_register() error paths

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion LE910Cx compositions

Aaro Koskinen <aaro.koskinen@iki.fi>
    USB: omap_udc: DMA: Don't enable burst 4 mode

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: reset internal port states on soft reset AMS

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Fix UAC3 cluster descriptor size check

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: midi2: Restart output URBs on resume

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: usblp: fix uninitialized heap leak via LPGETSTATUS ioctl

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: usblp: fix heap leak in IEEE 1284 device ID via short response

Marek Szyprowski <m.szyprowski@samsung.com>
    wifi: brcmfmac: Fix potential use-after-free issue when stopping watchdog task

Tristan Madani <tristan@talencesecurity.com>
    wifi: b43: enforce bounds check on firmware key index in b43_rx()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove station if connection prep fails

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    wifi: ath5k: do not access array OOB

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: use safe list iteration in radar detect work

Jeongjun Park <aha310510@gmail.com>
    wifi: rsi: fix kthread lifetime race between self-exit and external-stop

Catherine <enderaoelyther@gmail.com>
    wifi: mac80211: drop stray 'static' from fast-RX rx_result

Tristan Madani <tristan@talencesecurity.com>
    wifi: b43legacy: enforce bounds check on firmware key index in RX path

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7921: fix ROC abort flow interruption in mt7921_roc_work

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7921: fix a potential clc buffer length underflow

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: fix incorrect length field in txpower command

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: fix AMPDU state handling in mt7925_tx_check_aggr

Jann Horn <jannh@google.com>
    exit: prevent preemption of oopsing TASK_DEAD task

Hyunwoo Kim <imv4bel@gmail.com>
    rxrpc: Also unshare DATA/RESPONSE packets when paged frags are present

David Howells <dhowells@redhat.com>
    rxrpc: Fix conn-level packet handling to unshare RESPONSE packets

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Fix deadlock in l2cap_conn_del()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_red: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: check validity of VMCB controls when returning from SMM

Zhengchuan Liang <zcliangcn@gmail.com>
    net: af_key: zero aligned sockaddr tail in PF_KEY exports

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix RTNL assertion warning when remove module

Qingfang Deng <qingfang.deng@linux.dev>
    flow_dissector: do not dissect PPPoE PFC frames

Ankit Soni <Ankit.Soni@amd.com>
    iommu/amd: serialize sequence allocation under concurrent TLB invalidations

Uros Bizjak <ubizjak@gmail.com>
    iommu/amd: Use atomic64_inc_return() in iommu.c

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fix shadow paging use-after-free due to unexpected GFN

Rick Edgecombe <rick.p.edgecombe@intel.com>
    x86/shstk: Prevent deadlock during shstk sigreturn

Linus Torvalds <torvalds@linux-foundation.org>
    x86: shadow stacks: proper error handling for mmap lock

Suren Baghdasaryan <surenb@google.com>
    mm: convert mm_lock_seq to a proper seqcount

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: rewrite stop_sessions() with restartable iteration

Johan Hovold <johan@kernel.org>
    spi: rockchip: fix controller deregistration

Mark Brown <broonie@kernel.org>
    ASoC: SOF: Don't allow pointer operations on unconfigured streams

Sina Hassani <sina@openai.com>
    iommufd: Fix a race with concurrent allocation and unmap

Shivam Kalra <shivamkalra98@zohomail.in>
    ACPI: video: force native backlight on HP OMEN 16 (8A44)

Jinjie Ruan <ruanjinjie@huawei.com>
    ACPI: CPPC: Fix related_cpus inconsistency during CPU hotplug

Jan Schär <jan@jschaer.ch>
    ACPI: video: Add backlight=native quirk for Dell OptiPlex 7770 AIO

Guangshuo Li <lgs201920130244@gmail.com>
    ACPI: scan: Use acpi_dev_put() in object add error paths

Rajat Gupta <rajgupt@qti.qualcomm.com>
    fbdev: udlfb: add vm_ops to dlfb_ops_mmap to prevent use-after-free

Corey Minyard <corey@minyard.net>
    ipmi:si: Return state to normal if message allocation fails

Corey Minyard <corey@minyard.net>
    ipmi: Check event message buffer response for bad data

Corey Minyard <corey@minyard.net>
    ipmi: Add limits to event and receive message requests

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: target: configfs: Bound snprintf() return in tg_pt_gp_members_show()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/kvm/arm.c                               |   5 +
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   8 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   2 +-
 arch/loongarch/include/asm/linkage.h               |   2 +-
 arch/loongarch/kvm/exit.c                          |   1 +
 arch/loongarch/kvm/interrupt.c                     |  14 ++
 arch/loongarch/kvm/mmu.c                           |   2 +-
 arch/loongarch/kvm/switch.S                        |   2 +-
 arch/loongarch/kvm/timer.c                         |  10 +-
 arch/loongarch/kvm/vm.c                            |   2 +-
 arch/loongarch/pci/acpi.c                          |   5 +
 arch/loongarch/pci/pci.c                           |   3 +
 arch/powerpc/kexec/Makefile                        |   2 +-
 arch/powerpc/platforms/pseries/svm.c               |   1 +
 arch/riscv/kvm/vcpu_vector.c                       |   5 +-
 arch/s390/kernel/debug.c                           |   5 +
 arch/x86/include/asm/msr-index.h                   |   3 +-
 arch/x86/kernel/cpu/amd.c                          |   3 +
 arch/x86/kernel/shstk.c                            |  45 ++++--
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  35 ++--
 arch/x86/kvm/svm/nested.c                          |  12 +-
 arch/x86/kvm/svm/svm.c                             |   4 +
 arch/x86/kvm/svm/svm.h                             |   1 +
 block/blk.h                                        |   2 +
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/power.c                               |   2 +-
 drivers/acpi/scan.c                                |   2 +-
 drivers/acpi/video_detect.c                        |  16 ++
 drivers/bluetooth/btmtk.c                          |  15 +-
 drivers/bluetooth/virtio_bt.c                      |  39 ++++-
 drivers/char/ipmi/ipmi_si_intf.c                   |  70 ++++++--
 drivers/char/ipmi/ipmi_ssif.c                      |  23 ++-
 drivers/clk/clk-rk808.c                            |   2 +-
 drivers/clk/imx/clk-imx8-acm.c                     |   3 +-
 drivers/clk/microchip/clk-mpfs-ccc.c               |   6 +-
 drivers/cpuidle/cpuidle-powernv.c                  |   5 +-
 drivers/cpuidle/cpuidle-pseries.c                  |   5 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   4 +-
 drivers/crypto/caam/caamhash.c                     |   4 +-
 drivers/crypto/nx/nx-842.c                         |  41 ++---
 drivers/crypto/nx/nx-842.h                         |  15 +-
 drivers/crypto/nx/nx-common-powernv.c              |  31 ++--
 drivers/crypto/nx/nx-common-pseries.c              |  33 ++--
 drivers/extcon/extcon-ptn5150.c                    |  14 ++
 drivers/gpio/gpiolib-of.c                          |   9 +-
 drivers/hwmon/corsair-psu.c                        |   4 +-
 drivers/hwmon/ltc2992.c                            |  41 +++--
 drivers/hwmon/powerz.c                             |   5 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   7 +
 drivers/infiniband/hw/mana/qp.c                    |  16 +-
 drivers/infiniband/hw/mlx4/srq.c                   |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |   2 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |  11 ++
 drivers/infiniband/sw/rxe/rxe_resp.c               |  14 +-
 drivers/iommu/amd/amd_iommu_types.h                |   2 +-
 drivers/iommu/amd/init.c                           |   2 +-
 drivers/iommu/amd/iommu.c                          |  18 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   7 +
 drivers/iommu/iommufd/io_pagetable.c               |  10 ++
 drivers/md/dm-ioctl.c                              |   6 +-
 drivers/md/dm-verity-fec.c                         |   8 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   8 +
 drivers/md/raid10.c                                |   2 +
 drivers/mmc/core/card.h                            |   5 +
 drivers/mmc/core/queue.c                           |   9 +-
 drivers/mmc/core/quirks.h                          |   9 ++
 drivers/mtd/nand/spi/winbond.c                     |   4 +-
 drivers/mtd/spi-nor/debugfs.c                      |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  22 +++
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 +
 drivers/net/ethernet/intel/ice/ice_sf_eth.c        |   2 +
 .../ethernet/marvell/octeon_ep_vf/octep_vf_rx.c    |  36 ++++-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  47 +++---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   7 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c     |   2 +
 drivers/net/gtp.c                                  |   2 +
 drivers/net/wireless/ath/ath5k/base.c              |   3 +-
 drivers/net/wireless/broadcom/b43/xmit.c           |   3 +-
 drivers/net/wireless/broadcom/b43legacy/xmit.c     |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   4 +-
 drivers/net/wireless/rsi/rsi_common.h              |   5 +-
 drivers/net/wwan/t7xx/t7xx_modem_ops.c             |  20 ++-
 drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c         |  18 ++-
 drivers/net/wwan/t7xx/t7xx_port_proxy.h            |   2 +-
 drivers/nvme/host/apple.c                          |   6 +-
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/tcp.c                          |  26 +++
 drivers/parisc/lasi.c                              |  12 +-
 drivers/pci/pci.c                                  |   7 +-
 drivers/pci/pcie/aer.c                             |   2 -
 drivers/pci/pcie/aspm.c                            |  17 +-
 drivers/pci/setup-res.c                            |   2 +
 drivers/pmdomain/core.c                            |  10 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/spi/spi-microchip-core-qspi.c              |  12 +-
 drivers/spi/spi-rockchip.c                         |   4 +-
 drivers/spi/spi-s3c64xx.c                          |   5 -
 drivers/spi/spi-sun4i.c                            |  10 +-
 drivers/spi/spi-sun6i.c                            |   8 +-
 drivers/spi/spi-synquacer.c                        |   8 +-
 drivers/spi/spi-ti-qspi.c                          |  14 +-
 drivers/spi/spi-topcliff-pch.c                     |  11 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |   4 +-
 drivers/staging/vme_user/vme_fake.c                |   2 +
 drivers/target/target_core_configfs.c              |   2 +-
 drivers/thermal/sprd_thermal.c                     |   4 +-
 drivers/thermal/thermal_core.c                     |   6 +-
 drivers/usb/class/usblp.c                          |   3 +-
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/gadget/udc/omap_udc.c                  |   4 -
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +
 drivers/video/fbdev/core/fb_defio.c                | 179 ++++++++++++++++-----
 drivers/video/fbdev/udlfb.c                        |  31 +++-
 fs/btrfs/space-info.c                              |   2 +-
 fs/erofs/compress.h                                |   2 +-
 fs/erofs/decompressor.c                            | 163 +++++++++----------
 fs/erofs/decompressor_deflate.c                    |   8 +-
 fs/erofs/decompressor_lzma.c                       |   8 +-
 fs/erofs/decompressor_zstd.c                       |   8 +-
 fs/erofs/zdata.c                                   |   2 +
 fs/f2fs/data.c                                     |  28 +++-
 fs/f2fs/extent_cache.c                             |  17 +-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/sysfs.c                                    |  10 +-
 fs/file_table.c                                    |  22 ++-
 fs/hfsplus/bfind.c                                 |  51 ++++++
 fs/hfsplus/catalog.c                               |   4 +-
 fs/hfsplus/dir.c                                   |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   9 ++
 fs/hfsplus/super.c                                 |   6 +-
 fs/isofs/export.c                                  |   2 +-
 fs/isofs/rock.c                                    |   9 ++
 fs/notify/fsnotify.c                               |   2 +-
 fs/notify/mark.c                                   |  18 ++-
 fs/smb/client/cached_dir.c                         |   8 +
 fs/smb/client/cifsacl.c                            |  37 ++++-
 fs/smb/client/smb2inode.c                          |  12 +-
 fs/smb/client/smb2misc.c                           |   3 +-
 fs/smb/client/smb2ops.c                            |  11 ++
 fs/smb/server/connection.c                         |  48 ++++--
 fs/smb/server/connection.h                         |   1 +
 fs/tracefs/event_inode.c                           |  14 ++
 fs/tracefs/inode.c                                 |   5 +-
 fs/tracefs/internal.h                              |   3 +
 fs/udf/misc.c                                      |   8 +-
 fs/udf/super.c                                     |   4 +-
 include/linux/dma-mapping.h                        |  17 +-
 include/linux/fb.h                                 |   4 +-
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/mm.h                                 |  12 +-
 include/linux/mm_types.h                           |   7 +-
 include/linux/mmap_lock.h                          | 101 +++++++-----
 include/linux/mmc/card.h                           |   1 +
 include/linux/printk.h                             |  13 ++
 include/trace/events/rxrpc.h                       |   1 +
 include/video/udlfb.h                              |   1 +
 kernel/bpf/arena.c                                 |  19 ++-
 kernel/exit.c                                      |   1 +
 kernel/fork.c                                      |   5 +-
 kernel/tracepoint.c                                |   2 +
 lib/crypto/mpi/mpicoder.c                          |   2 +-
 lib/scatterlist.c                                  |   8 +-
 mm/damon/sysfs-schemes.c                           |  12 +-
 mm/init-mm.c                                       |   2 +-
 net/bluetooth/hci_event.c                          |  29 +++-
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/bluetooth/l2cap_sock.c                         |   6 +
 net/ceph/auth.c                                    |   2 +-
 net/ceph/mon_client.c                              |   2 +
 net/core/flow_dissector.c                          |  13 +-
 net/core/rtnetlink.c                               |   1 +
 net/ipv4/ah4.c                                     |  14 +-
 net/ipv6/ah6.c                                     |  14 +-
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/xfrm6_protocol.c                          |   4 +-
 net/key/af_key.c                                   |  52 +++---
 net/mac80211/mlme.c                                |   9 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mac80211/util.c                                |   4 +-
 net/mptcp/protocol.c                               |   3 +-
 net/mptcp/sockopt.c                                |  12 +-
 net/mptcp/subflow.c                                |   4 +-
 net/openvswitch/vport-netdev.c                     |   6 +-
 net/rds/message.c                                  |  20 ++-
 net/rxrpc/call_event.c                             |   4 +-
 net/rxrpc/conn_event.c                             |  30 +++-
 net/sched/sch_red.c                                |   2 +-
 net/unix/af_unix.c                                 |   3 +
 net/vmw_vsock/hyperv_transport.c                   |   4 +-
 net/xfrm/xfrm_state.c                              |  12 +-
 net/xfrm/xfrm_user.c                               |   1 +
 rust/kernel/init/__internal.rs                     |  28 ++--
 rust/kernel/init/macros.rs                         |  91 ++++++-----
 security/selinux/hooks.c                           |   3 +-
 security/selinux/selinuxfs.c                       |  54 ++-----
 sound/core/oss/pcm_oss.c                           |  29 +++-
 sound/drivers/aloop.c                              |  44 +++--
 sound/firewire/tascam/tascam-hwdep.c               |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |  14 ++
 sound/soc/fsl/fsl_easrc.c                          |   2 +-
 sound/soc/intel/boards/bytcr_wm5102.c              |   1 +
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   2 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   3 +
 sound/soc/sof/compress.c                           |   3 +
 sound/usb/midi2.c                                  |   9 +-
 sound/usb/misc/ua101.c                             |   7 +
 sound/usb/stream.c                                 |   4 +-
 tools/arch/x86/include/asm/msr-index.h             |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  16 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |  20 ++-
 tools/testing/vma/vma.c                            |   4 +-
 tools/testing/vma/vma_internal.h                   |   4 +-
 227 files changed, 1903 insertions(+), 785 deletions(-)


