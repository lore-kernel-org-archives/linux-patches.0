Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9755D3BB130;
	Tue, 12 May 2026 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608332; cv=none; b=EulfbHmZJUCAHtCeUY2FNLWDOXXtcvBePQ2YQiqI74AYYU+Z1j3wcPkUjMmhqR6E/+gXNsJYZnM71W6m6WXwwrcqAxwP5SHt/TrOaOGxt+a5GfWgjaEPbQzpoigwoZdhcB0y2xJO9UsDDmCxNvzngqe0Nieg9/eh8qQrg7m3A2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608332; c=relaxed/simple;
	bh=BgNlX+S3wA4X3maL66jUB9I1fng1JEHt1DY5HzyXiTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ntPcedFx0P/Ae61xf0xa2OepK1TsQZIPKyGJRZ6c0x8s9RDhTlyOjlSVwmKVqaaVEMxlGj7iQisNTYAQViLQ+DDBuG2MCic9ZbtCnz2naOP+x+od3tmfGzgEHpRdAFAs9zjUYjIgZY85iy+1ss3NGpZ7D65dN2/Sf/2v79ruPpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYnhiihf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYnhiihf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D0CC2BCB0;
	Tue, 12 May 2026 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608332;
	bh=BgNlX+S3wA4X3maL66jUB9I1fng1JEHt1DY5HzyXiTg=;
	h=From:To:Cc:Subject:Date:From;
	b=fYnhiihfFYLiUoliyShatN9i8jm+auZzo7+xeOIXZtgBGxLcH5Tr2GvWTlzKTnftk
	 5d2HQAzCyioiATpJW2aDkkdy/HXt5zPbnqfNKfy1OR+5MCBA3/FfItKi6wdfURzKt/
	 67yWnSfiiEcE4b9QAMvlTfmJmHRuC+WDwKn5ET58=
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
Subject: [PATCH 6.18 000/270] 6.18.30-rc1 review
Date: Tue, 12 May 2026 19:36:41 +0200
Message-ID: <20260512173938.452574370@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.30-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.30-rc1
X-KernelTest-Deadline: 2026-05-14T17:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.30 release.
There are 270 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 May 2026 17:38:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.30-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.30-rc1

Prathyushi Nangia <prathyushi.nangia@amd.com>
    x86/CPU/AMD: Prevent improper isolation of shared resources in Zen2's op cache

Gary Guo <gary@garyguo.net>
    rust: pin-init: fix incorrect accessor reference lifetime

Sam Edwards <cfsworks@gmail.com>
    net: stmmac: Prevent NULL deref when RX memory exhausted

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: rename STMMAC_GET_ENTRY() -> STMMAC_NEXT_ENTRY()

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: caam - guard HMAC key hex dumps in hash_digest_key

Thorsten Blum <thorsten.blum@linux.dev>
    printk: add print_hex_dump_devel()

Junrui Luo <moonafterrain@outlook.com>
    erofs: fix unsigned underflow in z_erofs_lz4_handle_overlap()

Gao Xiang <xiang@kernel.org>
    erofs: tidy up z_erofs_lz4_handle_overlap()

Zilin Guan <zilin@seu.edu.cn>
    hfsplus: fix held lock freed on hfsplus_fill_super()

Deepanshu Kartikey <kartikey406@gmail.com>
    hfsplus: fix uninit-value by validating catalog record size

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    firmware: exynos-acpm: Drop fake 'const' on handle pointer

Kairui Song <kasong@tencent.com>
    mm, swap: speed up hibernation allocation and writeout

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - fix firmware loading failure for GEN6 devices

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - fix indentation of macros in qat_hal.c

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: core: Optimize time for secure erase/trim for some Kingston eMMCs

Avri Altman <avri.altman@sandisk.com>
    mmc: core: Add quirk for incorrect manufacturing date

Avri Altman <avri.altman@sandisk.com>
    mmc: core: Adjust MDT beyond 2025

David Carlier <devnexen@gmail.com>
    octeon_ep_vf: add NULL check for napi_build_skb()

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (powerz) Avoid cacheline sharing for DMA buffer

Michael S. Tsirkin <mst@redhat.com>
    dma-mapping: add __dma_from_device_group_begin()/end()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: defio: Disconnect deferred I/O from the lifetime of struct fb_info

SeongJae Park <sj@kernel.org>
    mm/damon/core: disallow non-power of two min_region_sz on damon_start()

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix use-after-free in arena_vm_close on fork

Jens Axboe <axboe@kernel.dk>
    io_uring/tw: serialize ctx->retry_llist with ->uring_lock

Martin Michaelis <code@mgjm.de>
    io_uring/kbuf: support min length left for incremental buffers

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

Fuad Tabba <tabba@google.com>
    KVM: arm64: Fix pin leak and publication ordering in __pkvm_init_vcpu()

Fuad Tabba <tabba@google.com>
    KVM: arm64: Fix FEAT_Debugv8p9 to check DebugVer, not PMUVer

Fuad Tabba <tabba@google.com>
    KVM: arm64: Fix FEAT_SPE_FnE to use PMSIDR_EL1.FnE, not PMSVer

Quentin Perret <qperret@google.com>
    KVM: arm64: Fix initialisation order in __pkvm_init_finalise()

David Woodhouse <dwmw@amazon.co.uk>
    KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Wake-up from WFI when iqrchip is in userspace

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by FGGC of node block

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix inline data not being written to disk in writeback path

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: refactor f2fs_move_node_folio function

Guangshuo Li <lgs201920130244@gmail.com>
    f2fs: fix uninitialized kobject put in f2fs_init_sysfs()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix node_cnt race between extent node destroy and writeback

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix incorrect multidevice info in trace_f2fs_map_blocks()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix incorrect file address mapping when inline inode is unwritten

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by incorrect nat_entry flag usage

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fiemap boundary handling when read extent cache is incomplete

Cen Zhang <zzzccc427@gmail.com>
    f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: return early if no retrans

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: free sk if last

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: always decrease sk refcount

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: fix potential data-race

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: allow ID 0

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: correctly retransmit ADD_ADDR ID 0

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: prio: skip closed subflows

Gang Yan <yangang@kylinos.cn>
    mptcp: fix scheduling with atomic in timestamp sockopt

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix rx timestamp corruption on fastopen

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: increase seq in mptcp_setsockopt_all_sf

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

David Carlier <devnexen@gmail.com>
    sched_ext: idle: Recheck prev_cpu after narrowing allowed mask

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
    RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Validate rx_hash_key_len

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Remove user triggerable WARN_ON() in mana_ib_create_qp_rss()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Fix mana_destroy_wq_obj() cleanup in mana_ib_create_qp_rss()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Fix error unwind in mana_ib_create_qp_rss()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/ionic: Fix typo in format string

Kai Zen <kai.aizen.dev@gmail.com>
    RDMA/ionic: bound node_desc sysfs read with %.64s

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Always reprogram ACR events to prevent stale masks

Nilay Shroff <nilay@linux.ibm.com>
    powerpc/xive: fix kmemleak caused by incorrect chip_data lookup

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

SeongJae Park <sj@kernel.org>
    mm/damon/stat: detect and use fresh enabled value

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Do IRR scan in __kvm_apic_update_irr even if PIR is empty

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

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Limit NVMe request size to 2 MiB

Pengpeng Hou <pengpeng@iscas.ac.cn>
    s390/debug: Reject zero-length input before trimming a newline

Vasily Gorbik <gor@linux.ibm.com>
    s390/debug: Reject zero-length input in debug_input_flush_fn()

Osama Abdelkader <osama.abdelkader@gmail.com>
    riscv: kvm: fix vector context allocation leak

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/hns: Fix unlocked call to hns_roce_qp_remove()

David Carlier <devnexen@gmail.com>
    psp: strip variable-length PSP header in psp_dev_rcv()

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

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Block PASID attachment to nested domain with dirty tracking

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommufd: Fix return value of iommufd_fault_fops_write()

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing last_unlink_trans update when removing a directory

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

Li Jian <lazycat-xiao@foxmail.com>
    ASoC: ES8389: convert to devm_clk_get_optional() to get clock

Tommaso Soncin <soncintommaso@gmail.com>
    ASoC: amd: yc: Add HP OMEN Gaming Laptop 16-ap0xxx product line in quirk table

Shrikanth Hegde <sshegde@linux.ibm.com>
    cpuidle: powerpc: avoid double clear when breaking snooze

Conor Dooley <conor.dooley@microchip.com>
    clk: microchip: mpfs-ccc: fix out of bounds access during output registration

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    clk: imx: imx8-acm: fix flags for acm clocks

Steven Rostedt <rostedt@goodmis.org>
    tracing/probes: Limit size of event probe to 3K

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

David Carlier <devnexen@gmail.com>
    tracefs: Fix default permissions not being applied on initial mount

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: control built-in cs manually

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: don't attempt to transmit during emulated read-only dual/quad operations

Johan Hovold <johan@kernel.org>
    spi: microchip-core-qspi: fix controller deregistration

Guangshuo Li <lgs201920130244@gmail.com>
    ice: fix double free in ice_sf_eth_activate() error path

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: Disable GSO for packets with small MSS

Dexuan Cui <decui@microsoft.com>
    hv_sock: Return -EIO for malformed/short packets

Dexuan Cui <decui@microsoft.com>
    hv_sock: Report EOF instead of -EIO for FIN

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    hv_sock: fix ARM64 support

Thomas Zimmermann <tzimmermann@suse.de>
    hv: Select CONFIG_SYSFB only for CONFIG_HYPERV_VMBUS

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: of: clear OF_POPULATED on hog nodes in remove path

Xu Yang <xu.yang_2@nxp.com>
    extcon: ptn5150: handle pending IRQ events during system resume

Shyam Prasad N <sprasad@microsoft.com>
    cifs: change_conf needs to be called for session setup

Shyam Prasad N <sprasad@microsoft.com>
    cifs: abort open_cached_dir if we don't request leases

Jens Axboe <axboe@kernel.dk>
    block: only read from sqe on initial invocation of blkdev_uring_cmd()

Naman Jain <namjain@linux.microsoft.com>
    block: add pgmap check to biovec_phys_mergeable

Wentao Liang <vulab@iscas.ac.cn>
    pmdomain: mediatek: fix use-after-free in scpsys_get_bus_protection_legacy()

Breno Leitao <leitao@debian.org>
    arm64/fpsimd: ptrace: zero target's fpsimd_state, not the tracer's

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

Ivan Hu <ivan.hu@canonical.com>
    x86/efi: Fix graceful fault handling after FPU softirq changes

Hongling Zeng <zenghongling@kylinos.cn>
    parisc: Fix IRQ leak in LASI driver

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_typec: Init mutex in Thunderbolt registration

Pavitra Jha <jhapavitra98@gmail.com>
    net: wwan: t7xx: validate port_count against message length in t7xx_port_enum_msg_handler

Nan Li <tonanli66@gmail.com>
    net/rds: handle zerocopy send cleanup before the message is queued

Breno Leitao <leitao@debian.org>
    netpoll: pass buffer size to egress_dev() to avoid MAC truncation

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: use request_irq for VF misc interrupt

Maoyi Xie <maoyixie.tju@gmail.com>
    ip6_gre: Use cached t->net in ip6erspan_changelink().

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix VF illegal register access

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    pseries/papr-hvpipe: Fix the usage of copy_to_user()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    pseries/papr-hvpipe: Fix & simplify error handling in papr_hvpipe_init()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    pseries/papr-hvpipe: Prevent kernel stack memory leak to userspace

SeungJu Cheon <suunj1331@gmail.com>
    sound: ua101: fix division by zero at probe

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Improve validation and configuration of ACR masks

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: skip inactive subflows

Kai Zen <kai.aizen.dev@gmail.com>
    net: rtnetlink: zero ifla_vf_broadcast to avoid stack infoleak in rtnl_fill_vfinfo

Xianglai Li <lixianglai@loongson.cn>
    LoongArch: KVM: Compile switch.S directly into the kernel

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix SYM_SIGFUNC_START definition for 32BIT

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/hugetlb_cma: round up per_node before logging it

Kevin Brodsky <kevin.brodsky@arm.com>
    arm64: signal: Preserve POR_EL0 if poe_context is missing

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

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `clippy::collapsible_if` globally

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `clippy::collapsible_match` globally

Eliot Courtney <ecourtney@nvidia.com>
    rust: drm: gem: clean up GEM state in init failure case

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()

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
    selinux: prune /sys/fs/selinux/user

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: prune /sys/fs/selinux/disable

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: prune /sys/fs/selinux/checkreqprot

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: shrink critical section in sel_write_load()

David Windsor <dwindsor@gmail.com>
    selinux: don't reserve xattr slot when we won't fill it

Zongyao Chen <ZongYao.Chen@linux.alibaba.com>
    selinux: use sk blob accessor in socket permission helpers

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: fix avdcache auditing

Michael Bommarito <michael.bommarito@gmail.com>
    xfrm: ah: account for ESN high bits in async callbacks

Yilin Zhu <zylzyl2333@gmail.com>
    ipv6: xfrm6: release dst on error in xfrm6_rcv_encap()

Michal Kosiorek <mkosiorek121@gmail.com>
    xfrm: defensively unhash xfrm_state lists in __xfrm_state_delete

Ruijie Li <ruijieli51@gmail.com>
    xfrm: provide message size for XFRM_MSG_MAPPING

Ard Biesheuvel <ardb@kernel.org>
    x86/efi: Restore IRQ state in EFI page fault handler

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kdump: fix KASAN sanitization flag for core_$(BITS).o

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: Fix UMP group 16 filtering

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: core: Serialize deferred fasync state checks

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: firewire-tascam: Do not drop unread control events

Yuriy Padlyak <yuriypadlyak@gmail.com>
    ALSA: hda/realtek: Fix speaker silence after S3 resume on Xiaomi Mi Laptop Pro 15

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix data race at accessing runtime.oss.trigger

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda: cs35l56: Propagate ASP TX source control errors

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix debug accessory mode detection for sink ports

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

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_red: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: stmmac: Disable EEE RX clock stop when VLAN is enabled

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: check validity of VMCB controls when returning from SMM

Zhengchuan Liang <zcliangcn@gmail.com>
    net: af_key: zero aligned sockaddr tail in PF_KEY exports

Yi Kuo <yi@yikuo.dev>
    smb: client/smbdirect: fix MR registration for coalesced SG lists

Gang Yan <yangang@kylinos.cn>
    mptcp: sync the msk->sndbuf at accept() time

Qingfang Deng <qingfang.deng@linux.dev>
    flow_dissector: do not dissect PPPoE PFC frames

Sam Edwards <cfsworks@gmail.com>
    ceph: fix num_ops off-by-one when crypto allocation fails

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fix shadow paging use-after-free due to unexpected GFN

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: rewrite stop_sessions() with restartable iteration

Johan Hovold <johan@kernel.org>
    spi: rockchip: fix controller deregistration

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: fix incorrect TLV length in CLC command

Mark Brown <broonie@kernel.org>
    ASoC: SOF: Don't allow pointer operations on unconfigured streams

Sina Hassani <sina@openai.com>
    iommufd: Fix a race with concurrent allocation and unmap

David Carlier <devnexen@gmail.com>
    tracepoint: balance regfunc() on func_add() failure in tracepoint_add_func()

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

 .../ABI/{obsolete => removed}/sysfs-selinux-user   |   0
 Makefile                                           |   6 +-
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/kernel/ptrace.c                         |   4 +-
 arch/arm64/kernel/signal.c                         |  54 +++++--
 arch/arm64/kvm/arm.c                               |   4 +
 arch/arm64/kvm/config.c                            |  17 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  38 +++--
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   8 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   2 +-
 arch/loongarch/Kbuild                              |   2 +-
 arch/loongarch/include/asm/asm-prototypes.h        |  20 +++
 arch/loongarch/include/asm/kvm_host.h              |   3 -
 arch/loongarch/include/asm/linkage.h               |   2 +-
 arch/loongarch/kvm/Makefile                        |   3 +-
 arch/loongarch/kvm/exit.c                          |   1 +
 arch/loongarch/kvm/interrupt.c                     |  14 ++
 arch/loongarch/kvm/main.c                          |  35 +---
 arch/loongarch/kvm/mmu.c                           |   2 +-
 arch/loongarch/kvm/switch.S                        |  22 ++-
 arch/loongarch/kvm/timer.c                         |  10 +-
 arch/loongarch/kvm/vm.c                            |   2 +-
 arch/loongarch/pci/acpi.c                          |   5 +
 arch/loongarch/pci/pci.c                           |   3 +
 arch/powerpc/kexec/Makefile                        |   2 +-
 arch/powerpc/platforms/pseries/papr-hvpipe.c       |  53 +++---
 arch/powerpc/sysdev/xive/common.c                  |  16 +-
 arch/riscv/kvm/vcpu_vector.c                       |   5 +-
 arch/s390/kernel/debug.c                           |   8 +
 arch/x86/events/core.c                             |  13 +-
 arch/x86/events/intel/core.c                       |  32 +++-
 arch/x86/include/asm/efi.h                         |   3 +-
 arch/x86/include/asm/msr-index.h                   |   3 +-
 arch/x86/kernel/cpu/amd.c                          |   3 +
 arch/x86/kvm/hyperv.c                              |   2 +-
 arch/x86/kvm/lapic.c                               |   8 +-
 arch/x86/kvm/mmu/mmu.c                             |  35 ++--
 arch/x86/kvm/svm/nested.c                          |  12 +-
 arch/x86/kvm/svm/svm.c                             |   4 +
 arch/x86/kvm/svm/svm.h                             |   1 +
 arch/x86/mm/fault.c                                |   2 +-
 arch/x86/platform/efi/quirks.c                     |  13 +-
 block/blk.h                                        |   2 +
 block/ioctl.c                                      |  24 +--
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/power.c                               |   2 +-
 drivers/acpi/scan.c                                |   2 +-
 drivers/acpi/video_detect.c                        |  16 ++
 drivers/android/binder/range_alloc/array.rs        |   1 -
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
 .../crypto/intel/qat/qat_common/adf_accel_engine.c |   7 +
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |   1 +
 drivers/crypto/intel/qat/qat_common/qat_hal.c      |  27 ++--
 drivers/extcon/extcon-ptn5150.c                    |  14 ++
 drivers/firmware/samsung/exynos-acpm-pmic.c        |  10 +-
 drivers/firmware/samsung/exynos-acpm-pmic.h        |  10 +-
 drivers/firmware/samsung/exynos-acpm.c             |  16 +-
 drivers/firmware/samsung/exynos-acpm.h             |   2 +-
 drivers/gpio/gpiolib-of.c                          |   9 +-
 drivers/hv/Kconfig                                 |   2 +-
 drivers/hwmon/corsair-psu.c                        |   4 +-
 drivers/hwmon/ltc2992.c                            |  41 +++--
 drivers/hwmon/powerz.c                             |   5 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   7 +
 drivers/infiniband/hw/ionic/ionic_ibdev.c          |   2 +-
 drivers/infiniband/hw/mana/cq.c                    |   5 +-
 drivers/infiniband/hw/mana/qp.c                    |  16 +-
 drivers/infiniband/hw/mlx4/srq.c                   |   4 +-
 drivers/infiniband/hw/mlx5/main.c                  |   1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   4 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c    |   2 +-
 drivers/infiniband/sw/rxe/rxe_recv.c               |  11 ++
 drivers/infiniband/sw/rxe/rxe_resp.c               |  14 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   7 +
 drivers/iommu/intel/nested.c                       |   6 +-
 drivers/iommu/iommufd/eventq.c                     |   5 +-
 drivers/iommu/iommufd/io_pagetable.c               |  10 ++
 drivers/md/dm-ioctl.c                              |   6 +-
 drivers/md/dm-verity-fec.c                         |   8 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   8 +
 drivers/md/raid10.c                                |   2 +
 drivers/mfd/sec-acpm.c                             |  10 +-
 drivers/mmc/core/card.h                            |  11 ++
 drivers/mmc/core/mmc.c                             |  12 ++
 drivers/mmc/core/queue.c                           |   9 +-
 drivers/mmc/core/quirks.h                          |  12 ++
 drivers/mtd/spi-nor/debugfs.c                      |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  22 +++
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 +
 drivers/net/ethernet/intel/ice/ice_sf_eth.c        |   2 +
 .../ethernet/marvell/octeon_ep_vf/octep_vf_rx.c    |  36 ++++-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |  13 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  47 +++---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   7 +-
 drivers/net/ethernet/wangxun/libwx/wx_vf_common.c  |   4 +-
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
 drivers/platform/chrome/cros_typec_altmode.c       |   1 +
 drivers/pmdomain/core.c                            |  10 +-
 drivers/pmdomain/mediatek/mtk-pm-domains.c         |  10 +-
 drivers/power/supply/max17042_battery.c            |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  14 +-
 drivers/spi/spi-microchip-core-qspi.c              | 103 +++++++++---
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
 drivers/usb/typec/tcpm/tcpm.c                      |  27 ++--
 drivers/video/fbdev/core/fb_defio.c                | 178 ++++++++++++++++-----
 drivers/video/fbdev/udlfb.c                        |  31 +++-
 fs/btrfs/inode.c                                   |   2 +
 fs/btrfs/space-info.c                              |   2 +-
 fs/ceph/addr.c                                     |   4 +
 fs/erofs/decompressor.c                            |  86 +++++-----
 fs/f2fs/data.c                                     |  28 +++-
 fs/f2fs/extent_cache.c                             |  17 +-
 fs/f2fs/f2fs.h                                     |   2 +
 fs/f2fs/inline.c                                   |  22 ++-
 fs/f2fs/inode.c                                    |   2 +-
 fs/f2fs/node.c                                     |  95 +++++------
 fs/f2fs/sysfs.c                                    |  10 +-
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
 fs/smb/client/smbdirect.c                          |  21 +--
 fs/smb/server/connection.c                         |  48 ++++--
 fs/smb/server/connection.h                         |   1 +
 fs/tracefs/event_inode.c                           |  14 ++
 fs/tracefs/inode.c                                 |   6 +-
 fs/tracefs/internal.h                              |   3 +
 fs/udf/misc.c                                      |   8 +-
 include/linux/dma-mapping.h                        |  13 ++
 include/linux/fb.h                                 |   4 +-
 .../linux/firmware/samsung/exynos-acpm-protocol.h  |  29 ++--
 include/linux/fsnotify_backend.h                   |   1 +
 include/linux/mmc/card.h                           |   2 +
 include/linux/printk.h                             |  13 ++
 include/uapi/linux/io_uring.h                      |   3 +-
 include/video/udlfb.h                              |   1 +
 io_uring/io_uring.c                                |  12 +-
 io_uring/kbuf.c                                    |  12 +-
 io_uring/kbuf.h                                    |   7 +
 kernel/bpf/arena.c                                 |  19 ++-
 kernel/exit.c                                      |   1 +
 kernel/sched/ext_idle.c                            |  12 +-
 kernel/trace/trace_probe.c                         |   6 +
 kernel/trace/trace_probe.h                         |   4 +-
 kernel/tracepoint.c                                |   2 +
 lib/crypto/mpi/mpicoder.c                          |   2 +-
 lib/scatterlist.c                                  |   8 +-
 mm/damon/core.c                                    |   5 +
 mm/damon/stat.c                                    |  30 ++--
 mm/damon/sysfs-schemes.c                           |  12 +-
 mm/hugetlb_cma.c                                   |   1 +
 mm/swapfile.c                                      |  21 ++-
 net/bluetooth/hci_event.c                          |  29 +++-
 net/bluetooth/l2cap_sock.c                         |   9 ++
 net/ceph/auth.c                                    |   2 +-
 net/ceph/mon_client.c                              |   2 +
 net/core/flow_dissector.c                          |  13 +-
 net/core/netpoll.c                                 |  23 +--
 net/core/rtnetlink.c                               |   1 +
 net/ipv4/ah4.c                                     |  14 +-
 net/ipv6/ah6.c                                     |  14 +-
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/xfrm6_protocol.c                          |   4 +-
 net/key/af_key.c                                   |  52 +++---
 net/mac80211/mlme.c                                |   9 +-
 net/mac80211/rx.c                                  |   2 +-
 net/mac80211/util.c                                |   4 +-
 net/mptcp/fastopen.c                               |   4 +-
 net/mptcp/pm.c                                     |  62 ++++---
 net/mptcp/pm_kernel.c                              |  13 +-
 net/mptcp/protocol.c                               |   6 +-
 net/mptcp/sockopt.c                                |  16 +-
 net/mptcp/subflow.c                                |   4 +-
 net/openvswitch/vport-netdev.c                     |   6 +-
 net/psp/psp_main.c                                 |  42 +++--
 net/rds/message.c                                  |  20 ++-
 net/sched/sch_red.c                                |   2 +-
 net/unix/af_unix.c                                 |   3 +
 net/vmw_vsock/hyperv_transport.c                   |  33 +++-
 net/xfrm/xfrm_state.c                              |  12 +-
 net/xfrm/xfrm_user.c                               |   1 +
 rust/kernel/drm/gem/mod.rs                         |  13 +-
 rust/pin-init/src/__internal.rs                    |  28 ++--
 rust/pin-init/src/macros.rs                        |  91 ++++++-----
 security/selinux/hooks.c                           |  38 ++---
 security/selinux/include/objsec.h                  |   4 +-
 security/selinux/include/security.h                |   2 -
 security/selinux/selinuxfs.c                       | 169 ++++---------------
 security/selinux/ss/services.c                     | 125 ---------------
 sound/core/misc.c                                  |   8 +-
 sound/core/oss/pcm_oss.c                           |  29 +++-
 sound/core/seq/seq_clientmgr.c                     |   2 +-
 sound/core/seq/seq_clientmgr.h                     |   5 +-
 sound/core/seq/seq_ump_client.c                    |   2 +-
 sound/firewire/tascam/tascam-hwdep.c               |   1 +
 sound/hda/codecs/realtek/alc269.c                  |  19 +++
 sound/hda/codecs/side-codecs/cs35l56_hda.c         |  19 ++-
 sound/soc/amd/yc/acp6x-mach.c                      |  14 ++
 sound/soc/codecs/es8389.c                          |   2 +-
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
 269 files changed, 2440 insertions(+), 1165 deletions(-)


