Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AD0340A57;
	Wed, 20 May 2026 18:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300079; cv=none; b=TR377N+DU0FF8E6spoNHkquSQ2gJl1qZPBUKOuq/6cUVLvx86+HI3hWCbqB7iJVynF8dU3FMgKoKG4OStigD1UufBVMlyu+6AK6NZCJT4B7zCYe7LanUHn7vDCr4xV18RwyDfEH1LX8tJhyEA4E1WZuchq6+7gtSrkqt5of0rqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300079; c=relaxed/simple;
	bh=9woQD4PMuAsuxOaHsEs+MI6mM58q+qAYBzptgAWmEAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YJ7E8eXzhMSiBB48l9ASE/9sl8LoqmNucwIRKXQ7kjWv938wkVevJH5JPSGlw5v6gSfKw3GORZfET3RUdphsuL/QHm3d1AaJB+o9RRusEAFYRmXhJDuNuJTY5c6Pb9sy0M0rJS0gWLQnRXNnKGn9JqkanmjfbS0iwSg9jvNmT9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqZgNI6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqZgNI6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C651F000E9;
	Wed, 20 May 2026 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300071;
	bh=QeqvqeKziXtthterjDoj/KRWNKZ+s4yNe7OVxxewNP4=;
	h=From:To:Cc:Subject:Date;
	b=uqZgNI6GdaDV1bktBPCkVv4+J2KD6Ymx1RYNJzqaKpKhNUugmJDJTkm41YAbkAu3a
	 Mze8ursOTGxirieszsTUERm1mjIp03m6Q7uju/QvXVbAy3Yv5UZZ8VOVjSeZVFZ1mA
	 mzLnLp0f1vgPceDPWaP/icmSF9gMWGHIiamDiTsw=
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
Subject: [PATCH 6.12 000/666] 6.12.91-rc1 review
Date: Wed, 20 May 2026 18:13:31 +0200
Message-ID: <20260520162111.222830634@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.91-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.91-rc1
X-KernelTest-Deadline: 2026-05-22T16:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.91 release.
There are 666 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.91-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.91-rc1

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: resched blocked ADD_ADDR quicker

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: fix potential data-race

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: correctly retransmit ADD_ADDR ID 0

Johan Hovold <johan@kernel.org>
    spi: sifive: fix controller deregistration

Pei Xiao <xiaopei01@kylinos.cn>
    spi: sifive: Simplify clock handling with devm_clk_get_enabled()

Chao Yu <chao@kernel.org>
    f2fs: fix false alarm of lockdep on cp_global_sem lock

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix incorrect file address mapping when inline inode is unwritten

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix rx timestamp corruption on fastopen

Paolo Abeni <pabeni@redhat.com>
    mptcp: drop __mptcp_fastopen_gen_msk_ackseq()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: prio: skip closed subflows

Tejun Heo <tj@kernel.org>
    sched_ext: Guard scx_dsq_move() against NULL kit->dsq after failed iter_new

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mana: Remove user triggerable WARN_ON() in mana_ib_create_qp_rss()

Qu Wenruo <wqu@suse.com>
    btrfs: do not mark inode incompressible after inline attempt fails

Piyush Sachdeva <s.piyush1024@gmail.com>
    smb: client: Use FullSessionKey for AES-256 encryption key derivation

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing last_unlink_trans update when removing a directory

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs inodes in btrfs_rmdir() to avoid so much usage of BTRFS_I()

Filipe Manana <fdmanana@suse.com>
    btrfs: use inode already stored in local variable at btrfs_rmdir()

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/v3d: Reject empty multisync extension to prevent infinite loop

David Carlier <devnexen@gmail.com>
    eventfs: Use list_add_tail_rcu() for SRCU-protected children list

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommufd: Fix return value of iommufd_fault_fops_write()

Johan Hovold <johan@kernel.org>
    drm/gma500/oaktrail_lvds: fix i2c adapter leaks on init

Johan Hovold <johan@kernel.org>
    drm/gma500/oaktrail_lvds: fix hang on init failure

Johan Hovold <johan@kernel.org>
    drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup

Matthew Auld <matthew.auld@intel.com>
    drm/xe/dma-buf: handle empty bo and UAF races

Gyeyoung Baek <gye976@gmail.com>
    drm/panfrost: Fix wait_bo ioctl leaking positive return from dma_resv_wait_timeout()

Sebastian Brzezinka <sebastian.brzezinka@intel.com>
    drm/i915: skip __i915_request_skip() for already signaled requests

Naval Alcalá <ari@naval.cat>
    iommu/vt-d: Disable DMAR for Intel Q35 IGFX

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: handle rbtree insertion error in decode_choose_args()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in crush_decode()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential null-ptr-deref in decode_choose_args()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in osdmap_decode()

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    irqchip/riscv-imsic: Clear interrupt move state during CPU offlining

Paulo Alcantara <pc@manguebit.org>
    netfs: fix error handling in netfs_extract_user_iter()

Ma Ke <make24@iscas.ac.cn>
    powerpc/warp: Fix error handling in pika_dtm_thread

Nicholas Carlini <nicholas@carlini.com>
    io-wq: check that the predecessor is hashed in io_wq_remove_pending()

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix BUG_ON in __ceph_build_xattrs_blob() due to stale blob size

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix a buffer leak in __ceph_setxattr()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Bound MIDI endpoint descriptor scans

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Bound MIDI 2.0 endpoint descriptor scans

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/dp: Fix VSC dynamic range signaling for RGB formats

Myeonghun Pak <mhun512@gmail.com>
    drm/loongson: Use managed KMS polling

Ye Bin <yebin10@huawei.com>
    smb/client: fix possible infinite loop and oob read in symlink_data()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: btmtk: accept too short WMT FUNC_CTRL events

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: fix requeue of deferred ATA PASS-THROUGH commands

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: unconditionally bump set->nelems before insertion

Qiang Ma <maqianga@uniontech.com>
    KVM: x86: Fix Xen hypercall tracepoint argument assignment

Junrui Luo <moonafterrain@outlook.com>
    KVM: s390: pci: fix GAIT table indexing due to double-scaling pointer arithmetic

Aaron Sacks <contact@xchglabs.com>
    KVM: Reject wrapped offset in kvm_reset_dirty_gfn()

Sergio Correia <scorreia@redhat.com>
    audit: enforce AUDIT_LOCKED for AUDIT_TRIM and AUDIT_MAKE_EQUIV

Zoran Ilievski <goodboy@rexbytes.com>
    net: atlantic: preserve PCI wake-from-D3 on shutdown when WOL enabled

Li Xiasong <lixiasong1@huawei.com>
    netfilter: nft_ct: fix missing expect put in obj eval

Mario Limonciello <mario.limonciello@amd.com>
    Revert "ACPI: CPPC: Adjust debug messages in amd_set_max_freq_ratio() to warn"

Sergio Correia <scorreia@redhat.com>
    audit: fix incorrect inheritable capability in CAPSET records

Li Xiasong <lixiasong1@huawei.com>
    netfilter: nf_conntrack_sip: get helper before allocating expectation

Breno Leitao <leitao@debian.org>
    workqueue: Fix wq->cpu_pwq leak in alloc_and_link_pwqs() WQ_UNBOUND path

Matt Vollrath <tactii@gmail.com>
    i40e: Cleanup PTP pins on probe failure

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Cap AEAD AD length to 0x80000000

Mina Almasry <almasrymina@google.com>
    page_pool: fix incorrect mp_ops error handling

Breno Leitao <leitao@debian.org>
    netpoll: pass buffer size to egress_dev() to avoid MAC truncation

Breno Leitao <leitao@debian.org>
    netpoll: Extract IPv6 address retrieval function

Eric Dumazet <edumazet@google.com>
    net/sched: sch_pie: annotate more data-races in pie_dump_stats()

Ian Rogers <irogers@google.com>
    perf tool_pmu: Fix aggregation on duration_time

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/amd: Put list_add/del(dev_data) back under the domain->lock

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Reorder attach device code

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: fix leaking free_bds

Ryo Takakura <ryotkkr98@gmail.com>
    net: bcmgenet: Initialize u64 stats seq counter

Gao Xiang <xiang@kernel.org>
    erofs: fix offset truncation when shifting pgoff on 32-bit platforms

Samiullah Khawaja <skhawaja@google.com>
    PCI: Initialize temporary device in new_id_store()

Al Viro <viro@zeniv.linux.org.uk>
    ntfs: ->d_compare() must not block

Xianglai Li <lixianglai@loongson.cn>
    LoongArch: KVM: Compile switch.S directly into the kernel

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    smb: client: fix OOB reads parsing symlink error response

Liang Jie <liangjie@lixiang.com>
    smb: client: correctly handle ErrorContextData as a flexible array

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    arm64: Reserve an extra page for early kernel mapping

Paolo Abeni <pabeni@redhat.com>
    net/sched: cls_flower: revert unintended changes

Dan Carpenter <error27@gmail.com>
    sfc: fix error code in efx_devlink_info_running_versions()

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix strparser anchor skb leak on offload RX setup failure

Petr Oros <poros@redhat.com>
    ice: fix NULL pointer dereference in ice_reset_all_vfs()

Petr Oros <poros@redhat.com>
    iavf: add VIRTCHNL_OP_ADD_VLAN to success completion handler

Petr Oros <poros@redhat.com>
    iavf: wait for PF confirmation before removing VLAN filters

Petr Oros <poros@redhat.com>
    iavf: stop removing VLAN filters from PF on interface down

Petr Oros <poros@redhat.com>
    iavf: rename IAVF_VLAN_IS_NEW to IAVF_VLAN_ADDING

Hasan Basbunar <basbunarhasan@gmail.com>
    page_pool: fix memory-provider leak in page_pool_create_percpu() error path

Pavel Begunkov <asml.silence@gmail.com>
    net: page_pool: create hooks for custom memory providers

Samiullah Khawaja <skhawaja@google.com>
    page_pool: Set `dma_sync` to false for devmem memory provider

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/gsc: Fix BO leak on error in query_compatibility_version()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Fix error cleanup in xe_exec_queue_create_ioctl()

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/debugfs: Correct printing of register whitelist ranges

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Read EDID from VBIOS embedded panel info

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Allow DCE link encoder without AUX registers

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Prevent lockup in requeue-PI during signal/ timeout wakeup

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix uninitialized value in cs35l56_hda_read_acpi()

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/conexant: Fix missing error check for jack detection

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/conexant: Renaming the codec with device ID 0x1f86 and 0x1f87

Breno Leitao <leitao@debian.org>
    netconsole: propagate device name truncation in dev_name_store()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_cake: annotate data-races in cake_dump_stats() (V)

Weiming Shi <bestswngs@gmail.com>
    bareudp: fix NULL pointer dereference in bareudp_fill_metadata_dst()

Xin Long <lucien.xin@gmail.com>
    sctp: discard stale INIT after handshake completion

Xin Long <lucien.xin@gmail.com>
    netfilter: skip recording stale or retransmitted INIT

Christian A. Ehrhardt <christian.ehrhardt@codasip.com>
    ASoC: codecs: ab8500: Fix casting of private data

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v5.0.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.5 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.3 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v5.0.0 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0.5 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0.3 enc ring

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v2.5 enc/dec rings

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v2.0 enc/dec rings

Heiko Schocher <hs@nabladev.com>
    net: phy: dp83869: fix setting CLK_O_SEL field.

William A. Kennington III <william@wkennington.com>
    net: mctp i2c: check length before marking flow active

Zicheng Qu <quzicheng@huawei.com>
    sched/fair: Clear rel_deadline when initializing forked entities

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential leak of pd at parsing UAC3 streams

Breno Leitao <leitao@debian.org>
    netpoll: fix IPv6 local-address corruption

Breno Leitao <leitao@debian.org>
    netpoll: extract IPv4 address retrieval into helper function

Breno Leitao <leitao@debian.org>
    netpoll: Extract carrier wait function

Uday Shankar <ushankar@purestorage.com>
    netconsole: allow selection of egress interface via MAC address

Uday Shankar <ushankar@purestorage.com>
    net, treewide: define and use MAC_ADDR_STR_LEN

Altan Hacigumus <ahacigu.linux@gmail.com>
    tcp: make probe0 timer handle expired user timeout

Florian Westphal <fw@strlen.de>
    neigh: let neigh_xmit take skb ownership

Weiming Shi <bestswngs@gmail.com>
    net/sched: taprio: fix NULL pointer dereference in class dump

Paul Geurts <paul.geurts@prodrive-technologies.com>
    NFC: trf7970a: Ignore antenna noise when checking for RF field

Morduan Zang <zhangdandan@uniontech.com>
    net: usb: rtl8150: free skb on usb_submit_urb() failure in xmit

Zhan Jun <zhanjun@uniontech.com>
    net: usb: rtl8150: fix use-after-free in rtl8150_start_xmit()

Ido Schimmel <idosch@nvidia.com>
    vrf: Fix a potential NPD when removing a port from a VRF

Eric Dumazet <edumazet@google.com>
    net/sched: sch_fq_pie: annotate data-races in fq_pie_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_choke: annotate data-races in choke_dump_stats()

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: check for negative latency and jitter

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: fix slot delay calculation overflow

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: validate slot configuration

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: only reseed PRNG when seed is explicitly provided

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: fix queue limit check to include reordered packets

Stephen Hemminger <stephen@networkplumber.org>
    net/sched: netem: fix probability gaps in 4-state loss model

Nikola Z. Ivanov <zlatistiv@gmail.com>
    netdevsim: zero initialize struct iphdr in dummy sk_buff

Daan De Meyer <daan@amutable.com>
    cdrom, scsi: sr: propagate read-only status to block layer via set_disk_ro()

Wentao Guan <guanwentao@uniontech.com>
    arm64/scs: Fix potential sign extension issue of advance_loc4

Yuho Choi <dbgh9129@gmail.com>
    drm/sysfb: ofdrm: fix PCI device reference leaks

John Madieu <john.madieu@gmail.com>
    spi: rockchip: Read ISR, not IMR, to detect cs-inactive IRQ

Guilherme G. Piccoli <gpiccoli@igalia.com>
    ASoC: amd: acp: Add DMI quirk for Valve Steam Deck OLED

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_sip: don't use simple_strtoul

Jiexun Wang <wangjiexun2025@gmail.com>
    netfilter: xt_policy: fix strict mode inbound policy matching

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Support harvested SI chips with disabled TCCs (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd3.1: Don't validate the firmware when already validated

Alexandre Demers <alexandre.f.demers@gmail.com>
    drm/amdgpu: fix spelling typos

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix AMDGPU_INFO_READ_MMR_REG

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gmc: Fix AMDGPU_GART_PLACEMENT_LOW to not overlap with VRAM

Keith Busch <kbusch@kernel.org>
    nvme-pci: fix missed admin queue sq doorbell write

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: arp_tables: fix IEEE1394 ARP payload parsing

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: propagate nvmet_tcp_build_pdu_iovec() errors to its callers

Breno Leitao <leitao@debian.org>
    tracing: branch: Fix inverted check on stat tracer registration

Petr Malat <oss@malat.biz>
    cgroup: Increment nr_dying_subsys_* from rmdir context

Mark Harmstone <mark@harmstone.com>
    btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix inode reference leak in fsnotify_recalc_mask()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: make data_ready a per-instance variable

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: initialize struct earlier

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: don't free the reused channel

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: add sanity check for channel array

cuitao <cuitao@kylinos.cn>
    cgroup/rdma: fix integer overflow in rdmacg_try_charge()

Edward Adam Davis <eadavis@qq.com>
    sched/psi: fix race between file release and pressure write

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mailbox: mailbox-test: free channels on probe error

Jason-JH Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Fix CURR and END addr for task insert case

Yuho Choi <dbgh9129@gmail.com>
    fbdev: offb: fix PCI device reference leak on probe failure

Mathias Krause <minipli@grsecurity.net>
    kbuild: builddeb - avoid recompiles for non-cross-compiles

Anthony Pighin (Nokia) <anthony.pighin@nokia.com>
    rtc: abx80x: Disable alarm feature if no interrupt attached

Bae Yeonju <iwasbaeyz@gmail.com>
    fs/adfs: validate nzones in adfs_validate_bblk()

Kohei Enju <kohei@enjuk.jp>
    vhost_net: fix sleeping with preempt-disabled in vhost_net_busy_poll()

Lee Jones <lee@kernel.org>
    tipc: fix double-free in tipc_buf_append()

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    nfp: fix swapped arguments in nfp_encode_basic_qdr() calls

Brett Creeley <brett.creeley@amd.com>
    virtio_net: sync rss_trailer.max_tx_vq on queue_pairs change via VQ_PAIRS_SET

Akihiko Odaki <akihiko.odaki@daynix.com>
    virtio_net: Use new RSS config structs

Akihiko Odaki <akihiko.odaki@daynix.com>
    virtio_net: Fix endian with virtio_net_ctrl_rss

Akihiko Odaki <akihiko.odaki@daynix.com>
    virtio_net: Split struct virtio_net_rss_config

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Move ndesc initialization at end of airoha_qdma_init_rx_queue()

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: fix mode mask calculation

Eric Dumazet <edumazet@google.com>
    net/sched: sch_sfb: annotate data-races in sfb_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_red: annotate data-races in red_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_pie: annotate data-races in pie_dump_stats()

Eric Dumazet <edumazet@google.com>
    net_sched: sch_hhf: annotate data-races in hhf_dump_stats()

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix ice_ptp_read_tx_hwtstamp_status_eth56g

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix timestamp interrupt configuration for E825C

Michael Bommarito <michael.bommarito@gmail.com>
    net/rds: zero per-item info buffer before handing it to visitors

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: scope conn->binding slowpath to bound sessions only

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: fix durable fd leak on ClientGUID mismatch in durable v2 open

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: destroy async_ida in ksmbd_conn_free()

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()

Sangyun Kim <sangyun.kim@snu.ac.kr>
    pwm: atmel-tcb: Cache clock rates and mark chip as atomic

Jun Yan <jerrysteve1101@gmail.com>
    arm64: dts: meson-gxl-p230: fix ethernet PHY interrupt number

Weiming Shi <bestswngs@gmail.com>
    slip: bound decode() reads against the compressed packet length

Weiming Shi <bestswngs@gmail.com>
    slip: reject VJ receive packets on instances with no rstate array

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nfnetlink_osf: fix out-of-bounds read on option matching

Yingnan Zhang <342144303@qq.com>
    ipvs: fix MTU check for GSO packets in tunnel mode

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xtables: restrict several matches to inet family

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: remove sprintf usage

Xiang Mei <xmei5@asu.edu>
    netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_osf: restrict it to ipv4

Weiming Shi <bestswngs@gmail.com>
    openvswitch: cap upcall PID array size and pre-size vport replies

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    net/mlx5: Fix HCA caps leak on notifier init failure

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: drop PFC frames

Michael Bommarito <michael.bommarito@gmail.com>
    sctp: fix OOB write to userspace in sctp_getsockopt_peer_auth_chunks

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible UAF in icmpv6_rcv()

Matt Vollrath <tactii@gmail.com>
    e1000e: Unroll PTP in probe error handling

Kohei Enju <kohei@enjuk.jp>
    i40e: don't advertise IFF_SUPP_NOFCS

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix ICE_AQ_LINK_SPEED_M for 200G

Michal Schmidt <mschmidt@redhat.com>
    ice: fix double-free of tx_buf skb

Alice Mikityanska <alice@isovalent.com>
    ice: Remove jumbo_remove step from TX path

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: update PCS latency settings for E825 10G/25Gb modes

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->plb_rehash

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->dsack_dups

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->bytes_retrans

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->bytes_sent

Eric Dumazet <edumazet@google.com>
    tcp: add data-race annotations for TCP_NLA_SNDQ_SIZE

Eric Dumazet <edumazet@google.com>
    tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    net/sched: taprio: fix use-after-free in advance_sched() on schedule switch

Jiayuan Chen <jiayuan.chen@linux.dev>
    nexthop: fix IPv6 route referencing IPv4 nexthop

Dudu Lu <phx0fer@gmail.com>
    net/sched: sch_cake: fix NAT destination port not being updated in cake_update_flowkeys

Dudu Lu <phx0fer@gmail.com>
    macvlan: fix macvlan_get_size() not reserving space for IFLA_MACVLAN_BC_CUTOFF

Dudu Lu <phx0fer@gmail.com>
    net/sched: act_mirred: fix wrong device for mac_header_xmit check in tcf_blockcast_redir

Gabor Juhos <j4g8y7@gmail.com>
    arm64: dts: marvell: armada-37xx: use 'usb2-phy' in USB3 controller's phy-names

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-tqma8mqml: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mn-tqma8mqnl: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mm-emtop-som: Correct PAD settings for PMIC_nINT

René Rebe <rene@exactco.de>
    PCMCIA: Fix garbled log messages for KERN_CONT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-data-modul-edm-sbc: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-dhcom-som: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-icore-mx8mp: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-navqp: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-debix-som-a: Correct PAD settings for PMIC_nINT

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-debix-model-a: Correct PAD settings for PMIC_nINT

Gao Xiang <xiang@kernel.org>
    erofs: unify lcn as u64 for 32-bit platforms

Gao Xiang <xiang@kernel.org>
    erofs: avoid infinite loops due to corrupted subpage compact indexes

Chao Yu <chao@kernel.org>
    erofs: do sanity check on m->type in z_erofs_load_compact_lcluster()

Gao Xiang <xiang@kernel.org>
    erofs: add encoded extent on-disk definition

Paul Moses <p@1g4.org>
    crypto: ccp - copy IV using skcipher ivsize

T Pratham <t-pratham@ti.com>
    crypto: sa2ul - Fix AEAD fallback algorithm names

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/wm: Verify the correct plane DDB entry

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Relocate the SKL wm sanitation code

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: protect extension_list reading with sb_lock in f2fs_sbi_show()

Brian Masney <bmasney@redhat.com>
    clk: visconti: pll: initialize clk_init_data to zero

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-x1e80100: Keep GCC USB QTB clock always ON

Geert Uytterhoeven <geert+renesas@glider.be>
    lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc-sc7180: Add missing MDSS resets

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: clock: qcom,dispcc-sc7180: Define MDSS resets

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: xgene: Fix mapping leak in xgene_pllclk_init()

Arnd Bergmann <arnd@arndb.de>
    clk: qoriq: avoid format string warning

Thomas Weißschuh <linux@weissschuh.net>
    x86/um: fix vDSO installation

Thomas Weißschuh <linux@weissschuh.net>
    x86/um/vdso: Drop VDSO64-y from Makefile

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    clk: imx8mq: Correct the CSI PHY sels

Felix Gu <ustc.gu@gmail.com>
    clk: imx: imx6q: Fix device node reference leak in of_assigned_ldb_sels()

Felix Gu <ustc.gu@gmail.com>
    clk: imx: imx6q: Fix device node reference leak in pll6_bypassed()

Val Packett <val@packett.cool>
    clk: qcom: dispcc-sm8250: Enable parents for pixel clocks

Val Packett <val@packett.cool>
    clk: qcom: dispcc-sm8250: Use shared ops on the mdss vsync clk

Val Packett <val@packett.cool>
    clk: qcom: gcc-sc8180x: Use retention for PCIe power domains

Val Packett <val@packett.cool>
    clk: qcom: gcc-sc8180x: Use retention for USB power domains

Val Packett <val@packett.cool>
    clk: qcom: gcc-sc8180x: Add missing GDSCs

Val Packett <val@packett.cool>
    dt-bindings: clock: qcom,gcc-sc8180x: Add missing GDSCs

Junrui Luo <moonafterrain@outlook.com>
    scsi: target: core: Fix integer overflow in UNMAP bounds check

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: dispcc-sm4450: Fix DSI byte clock rate setting

White Lewis <liu224806@gmail.com>
    clk: qcom: dispcc-sc8280xp: remove CLK_SET_RATE_PARENT from byte_div_clk_src dividers

Yang Erkun <yangerkun@huawei.com>
    scsi: sg: Resolve soft lockup issue when opening /dev/sgX

Yang Erkun <yangerkun@huawei.com>
    scsi: sg: Fix sysctl sg-big-buff register during sg_init()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    clk: qcom: dispcc-sm8450: use RCG2 ops for DPTX1 AUX clock source

Florian Westphal <fw@strlen.de>
    RDMA/core: Prefer NLA_NUL_STRING

Pengpeng Hou <pengpeng@iscas.ac.cn>
    platform/x86: dell-wmi-sysman: bound enumeration string aggregation

Fedor Pchelkin <pchelkin@ispras.ru>
    platform/x86: dell_rbu: avoid uninit value usage in packet_size_write()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    fs/ntfs3: terminate the cached volume label after UTF-8 conversion

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    tty: serial: ip22zilog: Fix section mispatch warning

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: fix screenpad brightness range

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: adjust screenpad power/brightness handling

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nfs/blocklayout: Fix compilation error (`make W=1`) in bl_write_pagelist()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    mfd: mc13xxx-core: Fix memory leak in mc13xxx_add_subdevice_pdata()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: panasonic-laptop: Fix OPTD notifier registration and cleanup

Randy Dunlap <rdunlap@infradead.org>
    tty: hvc_iucv: fix off-by-one in number of supported devices

Chen Ni <nichen@iscas.ac.cn>
    leds: lgm-sso: Remove duplicate assignments for priv->mmap

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/surface: surfacepro3_button: Drop wakeup source on remove

Chen Ni <nichen@iscas.ac.cn>
    backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()

Billy Tsai <billy_tsai@aspeedtech.com>
    i3c: mipi-i3c-hci: fix IBI payload length calculation for final status

Jorge Marques <jorge.marques@analog.com>
    i3c: master: Fix error codes at send_ccc_cmd

Felix Gu <ustc.gu@gmail.com>
    i3c: dw: Fix memory leak in dw_i3c_master_i3c_xfers()

Felix Gu <ustc.gu@gmail.com>
    i3c: master: dw-i3c: Fix missing reset assertion in remove() callback

Philipp Zabel <p.zabel@pengutronix.de>
    reset: Add devres helpers to request pre-deasserted reset controls

Philipp Zabel <p.zabel@pengutronix.de>
    reset: replace boolean parameters with flags parameter

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf util: Kill die() prototype, dead for a long time

Ian Rogers <irogers@google.com>
    perf maps: Fix copy_from that can break sorted by name order

Ian Rogers <irogers@google.com>
    perf cgroup: Update metric leader in evlist__expand_cgroup

Ian Rogers <irogers@google.com>
    perf python: Add parse_events function

Ian Rogers <irogers@google.com>
    perf tool_pmu: Factor tool events into their own PMU

Ian Rogers <irogers@google.com>
    perf evsel: Add alternate_hw_config and use in evsel__match

Jian Zhang <zhangjian.3032@bytedance.com>
    ipmi: ssif_bmc: change log level to dbg in irq callback

Jian Zhang <zhangjian.3032@bytedance.com>
    ipmi: ssif_bmc: fix message desynchronization after truncated response

Jian Zhang <zhangjian.3032@bytedance.com>
    ipmi: ssif_bmc: fix missing check for copy_to_user() partial failure

Leo Yan <leo.yan@arm.com>
    perf expr: Return -EINVAL for syntax error in expr__find_ids()

Chuck Lever <chuck.lever@oracle.com>
    perf tools: Fix module symbol resolution for non-zero .text sh_addr

Ian Rogers <irogers@google.com>
    perf stat: Fix opt->value type for parse_cache_level

Ian Rogers <irogers@google.com>
    perf lock: Fix option value type in parse_max_stack

Biju Das <biju.das.jz@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix save/restore of {IOLH,IEN,PUPD,SMT} registers

Yu-Chun Lin <eleanor15x@gmail.com>
    pinctrl: abx500: Fix type of 'argument' variable

Yu-Chun Lin <eleanor.lin@realtek.com>
    pinctrl: realtek: Fix function signature for config argument

Mike Leach <mike.leach@arm.com>
    perf: tools: cs-etm: Fix print issue for Coresight debug in ETE/TRBE trace

Ian Rogers <irogers@google.com>
    perf branch: Avoid incrementing NULL

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: Avoid returning positive values to user space

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: Unify messages with help of dev_err_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: remove duplicate error message

Ethan Tidmore <ethantidmore06@gmail.com>
    pinctrl: pinctrl-pic32: Fix resource leak

Puranjay Mohan <puranjay@kernel.org>
    bpf, arm32: Reject BPF-to-BPF calls and callbacks in the JIT

Puranjay Mohan <puranjay@kernel.org>
    bpf: Validate node_id in arena_alloc_pages()

Jiri Olsa <jolsa@kernel.org>
    libbpf: Prevent double close and leak of btf objects

Mykyta Yatsenko <yatsenko@meta.com>
    libbpf: Stringify errno in log messages in libbpf.c

Ihor Solodrai <ihor.solodrai@pm.me>
    libbpf: Change log level of BTF loading error message

Yihan Ding <dingyihan@uniontech.com>
    bpf: allow UTF-8 literals in bpf_bprintf_prepare()

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Fix NULL deref in map_kptr_match_type for scalar regs

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix precedence bug in convert_bpf_ld_abs alignment check

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Take state lock for af_unix iter

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix af_unix null-ptr-deref in proto update

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix af_unix iter deadlock

Puranjay Mohan <puranjay@kernel.org>
    bpf, riscv: Remove redundant bpf_flush_icache() after pack allocator finalize

Daniel Borkmann <daniel@iogearbox.net>
    bpf, arm64: Fix off-by-one in check_imm signed range check

Ye Bin <yebin10@huawei.com>
    ext4: fix possible null-ptr-deref in mbt_kunit_exit()

Oliver Neukum <oneukum@suse.com>
    HID: usbhid: fix deadlock in hid_post_reset()

Richard Genoud <richard.genoud@bootlin.com>
    mtd: rawnand: sunxi: fix sunxi_nfc_hw_ecc_read_extra_oob

Li Ming <ming.li@zohomail.com>
    cxl/pci: Check memdev driver binding status in cxl_reset_done()

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    mtd: parsers: ofpart: call of_node_get() for dedicated subpartitions

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    mtd: parsers: ofpart: call of_node_put() only in ofpart_fail path

Shiji Yang <yangshiji66@outlook.com>
    mtd: spi-nor: swp: check SR_TB flag when getting tb_mask

Jonas Gorski <jonas.gorski@gmail.com>
    mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: introduce smpt_map_id fixup hook

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: sfdp: introduce smpt_read_dummy fixup hook

Haibo Chen <haibo.chen@nxp.com>
    mtd: spi-nor: core: correct the op.dummy.nbytes when check read operations

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: interrupt-controller: arm,gic-v3: Fix EPPI range

Dmitry Safonov <0x7f454c46@gmail.com>
    ima_fs: Correctly create securityfs files for unsupported hash algos

Al Viro <viro@zeniv.linux.org.uk>
    ima_fs: get rid of lookup-by-dentry stuff

Al Viro <viro@zeniv.linux.org.uk>
    ima_fs: don't bother with removal of files in directory we'll be removing

Chen Ni <nichen@iscas.ac.cn>
    mtd: physmap_of_gemini: Fix disabled pinctrl state check

Denis Benato <denis.benato@linux.dev>
    HID: asus: do not abort probe when not necessary

Denis Benato <denis.benato@linux.dev>
    HID: asus: make asus_resume adhere to linux kernel coding standards

Daniel Hodges <hodgesd@meta.com>
    ima: check return value of crypto_shash_final() in boot aggregate

Tim Michals <tcmichals@yahoo.com>
    remoteproc: xlnx: Fix sram property parsing

Francesco Lavra <flavra@baylibre.com>
    hte: tegra194: remove Kconfig dependency on Tegra194 SoC

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Rebuild full_name on each hist_field_name() call

Richard Fitzgerald <rf@opensource.cirrus.com>
    soundwire: cadence: Clear message complete before signaling waiting thread

Frank Li <Frank.Li@nxp.com>
    dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()

Cole Leavitt <cole@unwrap.rs>
    soundwire: bus: demote UNATTACHED state warnings to dev_dbg()

Khairul Anuar Romli <karom.9560@gmail.com>
    dmaengine: dw-axi-dmac: Remove unnecessary return statement from void function

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate group add input before caching

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate bg_bits during freefrag scan

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: fix listxattr handling when the buffer is full

Sebastian Ene <sebastianene@google.com>
    firmware: arm_ffa: Use the correct buffer size during RXTX_MAP

Frank Li <Frank.Li@nxp.com>
    ARM: dts: imx27-eukrea: replace interrupts with interrupts-extended

Christoph Hellwig <hch@lst.de>
    arm64/xor: fix conflicting attributes for xor_block_template

Aaro Koskinen <aaro.koskinen@iki.fi>
    ARM: OMAP1: Fix DEBUG_LL and earlyprintk on OMAP16XX

Alexander Koskovich <AKoskovich@pm.me>
    arm64: dts: qcom: sm8250: Add missing CPU7 3.09GHz OPP

Alok Tiwari <alok.a.tiwari@oracle.com>
    soc: qcom: aoss: compare against normalized cooling state

Alok Tiwari <alok.a.tiwari@oracle.com>
    soc: qcom: llcc: fix v1 SB syndrome register offset

Junrui Luo <moonafterrain@outlook.com>
    ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison

Junrui Luo <moonafterrain@outlook.com>
    ocfs2/dlm: validate qr_numregions in dlm_match_regions()

Michal Grzedzicki <mge@meta.com>
    unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() failure

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Set ERD on resume for err interrupt

Xu Yang <xu.yang_2@nxp.com>
    arm64: dts: imx8qxp-mek: switch Type-C connector power-role to dual

Xu Yang <xu.yang_2@nxp.com>
    arm64: dts: imx8qm-mek: switch Type-C connector power-role to dual

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: complete pinmux for rcwsr12 configuration word

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: change zeros to hexadecimal in pinmux nodes

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: add sda gpio references for i2c bus recovery

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: rename pinmux nodes for readability

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: remove duplicate pinmux nodes

Josua Mayer <josua@solid-run.com>
    arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit

Nora Schiffer <nora.schiffer@ew.tq-group.com>
    arm64: dts: freescale: imx8mp-tqma8mpql-mba8mp-ras314: fix UART1 RTS/CTS muxing

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Fix SPI_1 GPIO CS pinctrl label

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-lp-sk: Enable internal pulls for MMC0 data pins

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62p5-sk: Disable MMC1 internal pulls on data pins

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: Mark l1a regulator as powered during boot

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix conflicting bias pinctrl

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8650: Enable UHS-I SDR50 and SDR104 SD card modes

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8550: Enable UHS-I SDR50 and SDR104 SD card modes

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8450: Enable UHS-I SDR50 and SDR104 SD card modes

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8650: Fix xo clock supply of SD host controller

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8550: Fix xo clock supply of platform SD host controller

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8650: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Fix GIC_ITS range length

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Fix GIC_ITS range length

Gatien Chevallier <gatien.chevallier@foss.st.com>
    bus: rifsc: fix RIF configuration check for peripherals

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ocmem: return -EPROBE_DEFER is ocmem is not available

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ocmem: register reasons for probe deferrals

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ocmem: make the core clock optional

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: Correct Joystick Axes on Gameforce Ace

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: Correct Fan Supply for Gameforce Ace

Ming Wang <wangming5719@gmail.com>
    arm64: dts: rockchip: Fix Bluetooth stability on LCKFB TaiShan Pi

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: msm8953-xiaomi-daisy: fix backlight

Barnabás Czémán <barnabas.czeman@mainlining.org>
    arm64: dts: qcom: msm8953-xiaomi-vince: correct wled ovp value

Akari Tsuyukusa <akkun11.open@gmail.com>
    arm64: dts: mediatek: mt7986a: Fix gpio-ranges pin count

Akari Tsuyukusa <akkun11.open@gmail.com>
    arm64: dts: mediatek: mt7981b: Fix gpio-ranges pin count

Akari Tsuyukusa <akkun11.open@gmail.com>
    arm64: dts: mediatek: mt6795: Fix gpio-ranges pin count

Jacob Pan <jacob.pan@linux.microsoft.com>
    iommufd: vfio compatibility extension check for noiommu mode

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8mp-evk: Enable pull select bit for PCIe regulator GPIO (M.2 W_DISABLE1)

Heiko Stuebner <heiko.stuebner@cherry.de>
    arm64: dts: rockchip: Make Jaguar PCIe-refclk pin use pull-up config

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: imx8-apalis: Fix LEDs name collision

Mikko Perttunen <mperttunen@nvidia.com>
    memory: tegra30-emc: Fix dll_change check

Mikko Perttunen <mperttunen@nvidia.com>
    memory: tegra124-emc: Fix dll_change check

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: mediatek: mt7623: fix efuse fallback compatible

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mediatek: mt8365: Describe infracfg-nao as a pure syscon

Joshua Klinesmith <joshuaklinesmith@gmail.com>
    ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine

Thomas Huth <thuth@redhat.com>
    efi/capsule-loader: fix incorrect sizeof in phys array reallocation

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: prevent NULL pointer dereference during unmount

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: add some missing log locking

Jan Kara <jack@suse.cz>
    quota: Fix race of dquot_scan_active() with quota deactivation

Ricardo B. Marlière <rbm@suse.com>
    ktest: Run POST_KTEST hooks on failure and cancellation

Ricardo B. Marlière <rbm@suse.com>
    ktest: Honor empty per-test option overrides

Ricardo B. Marlière <rbm@suse.com>
    ktest: Avoid undef warning when WARNINGS_FILE is unset

Ondrej Mosnacek <omosnace@redhat.com>
    fanotify: call fanotify_events_supported() before path_permission() and security_path_notify()

Al Viro <viro@zeniv.linux.org.uk>
    fdget(), trivial conversions

Al Viro <viro@zeniv.linux.org.uk>
    net/socket.c: switch to CLASS(fd)

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Call unlock_new_inode before d_instantiate

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - fixed speaker no sound update

Haixin Xu <jerryxucs@gmail.com>
    crypto: jitterentropy - replace long-held spinlock with mutex

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix missing return in invalidate_committed's error path

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: sc6000: Keep the programmed board state in card-private data

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mtk-snfi: unregister ECC engine on probe failure and remove() callback

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Fix CBB timeout caused by DBI access before core power-on

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: dwc: Apply ECRC workaround to DesignWare 5.00a as well

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Use DWC IP core version

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Free up Endpoint resources during remove()

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Allow system suspend when the Endpoint link is not up

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Set LTR message request before PCIe link up in Endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Disable direct speed change for Endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Use devm_gpiod_get_optional() to parse "nvidia,refclk-select"

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Disable PERST# IRQ only in Endpoint mode

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Don't force the device into the D0 state before L2

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: tegra194: Rename 'root_bus' to 'root_port_bus' in tegra_pcie_downstream_dev_to_D0()

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Disable LTSSM after transition to Detect on surprise link down

Manikanta Maddireddy <mmaddireddy@nvidia.com>
    PCI: tegra194: Increase LTSSM poll time on surprise link down

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix polling delay for L2 state

Richard Cheng <icheng@nvidia.com>
    PCI/NPEM: Set LED_HW_PLUGGABLE for hotplug-capable ports

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: SOF: compress: return the configured codec from get_params

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    ALSA: scarlett2: Add missing sentinel initializer field

Waiman Long <longman@redhat.com>
    selftest: memcg: skip memcg_sock test if address family not supported

Jane Chu <jane.chu@oracle.com>
    Documentation: fix a hugetlbfs reservation statement

AnishMulay <anishm7030@gmail.com>
    selftests/mm: skip migration tests if NUMA is unavailable

Chen-Yu Tsai <wenst@chromium.org>
    PCI: mediatek-gen3: Prevent leaking IRQ domains when IRQ not found

Gerd Bayer <gbayer@linux.ibm.com>
    PCI: Enable AtomicOps only if Root Port supports them

Denis Rastyogin <gerben@altlinux.org>
    ASoC: rsnd: Fix potential out-of-bounds access of component_dais[]

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use swab32 macro

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix type mismatch in RAS sysfs show functions

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - disable 420xx AE cluster when lead engine is fused off

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - disable 4xxx AE cluster when lead engine is fused off

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - introduce fuse array

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: qdsp6: topology: check widget type before accessing data

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix clone_alias() to use the original device's devid

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Introduce helper function get_dte256()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Introduce helper function to update 256-bit DTE

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Convert dev_data lock from spinlock to mutex

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Rearrange attach device code

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Reduce domain lock scope in attach device path

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Do not detach devices in domain free path

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: xarray to track protection_domain->iommu list

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Remove protection_domain.dev_cnt variable

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: Change the type for iec958 channel status controls

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_mode_put()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_arc_mode_put()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in micfil_quality_set()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in micfil_put_dc_remover_state()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in hwvad_put_init_mode()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Fix event generation in hwvad_put_enable()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_micfil: Add access property for "VAD Detected"

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    PM: domains: De-constify fields in struct dev_pm_domain_attach_data

Felix Gu <ustc.gu@gmail.com>
    pmdomain: imx: scu-pd: Fix device_node reference leak during ->probe()

Felix Gu <gu_0233@qq.com>
    pmdomain: ti: omap_prm: Fix a reference leak on device node

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Use barriers while updating HFI Q headers

Connor Abbott <cwabbott0@gmail.com>
    drm/msm/a6xx: Fix dumping A650+ debugbus blocks

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/shrinker: Fix can_block() logic

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm/a6xx: Fix HLSQ register dumping

Ethan Tidmore <ethantidmore06@gmail.com>
    ASoC: SOF: Intel: hda: Place check before dereference

Lei Huang <huanglei@kylinos.cn>
    ALSA: hda/realtek: fix code style (ERROR: else should follow close brace '}')

Billy Tsai <billy_tsai@aspeedtech.com>
    hwmon: (aspeed-g6-pwm-tach): remove redundant driver remove callback

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    hwmon: Switch back to struct platform_driver::remove()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd4.2: Don't initialize UVD 4.2 when DPM is disabled

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: update the handle ptr in early_init

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: update the handle ptr in dump_ip_state

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: add amdgpu_device reference in ip block

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/smu7: Add SCLK cap for quirky Hawaii board

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Fill DW8 fields from SMC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Clear EnabledForActivity field for memory levels

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Fix powertune defaults for Hawaii 0x67B0

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/smu7: Fix SMU7 voltage dependency on display clock

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Disable MCLK DPM on problematic CI ASICs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Use highest MCLK on CI when MCLK DPM is disabled

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: core: Validate compress device numbers without dynamic minors

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI: qcom: Advertise Hotplug Slot Capability with no Command Completion support

Sebastian Reichel <sebastian.reichel@collabora.com>
    drm/panel: simple: Correct G190EAN01 prepare timing

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/panel: sharp-ls043t1le01: make use of prepare_prev_first

Alexander Koskovich <akoskovich@pm.me>
    drm/msm/dsi: rename MSM8998 DSI version from V2_2_0 to V2_0_0

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix hdisplay calculation for CMD mode panel

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: fix bits_per_pclk

Pengyu Luo <mitltlatltl@gmail.com>
    drm/msm/dsi: add the missing parameter description

Yuanjie Yang <yuanjie.yang@oss.qualcomm.com>
    drm/msm/dpu: fix mismatch between power and frequency

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Set supports_cmd op in tegra241_vcmdq_hw_init()

Alexandru Dadu <alexandru.dadu@imgtec.com>
    drm/imagination: Switch reset_reason fields from enum to u32

Pei Xiao <xiaopei01@kylinos.cn>
    spi: hisi-kunpeng: prevent infinite while() loop in hisi_spi_flush_fifo

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: look at the right prop for gfx queue priority

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: look at the right prop for gfx queue priority

Koichiro Den <den@valinux.co.jp>
    PCI: dwc: rcar-gen4: Change EPC BAR alignment to 4K as per the documentation

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Put CPU offline callback in ONLINE section to allow failure

Chuyi Zhou <zhouchuyi@bytedance.com>
    padata: Remove cpu online check from cpu add and removal

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel - Use unregister_{aeads,ahashes,skciphers}

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: tegra - Disable softirqs before finalizing request

Akhil R <akhilrajeev@nvidia.com>
    crypto: tegra - Reserve keyslots to allocate dynamically

Akhil R <akhilrajeev@nvidia.com>
    crypto: tegra - Transfer HASH init function to crypto engine

Akhil R <akhilrajeev@nvidia.com>
    crypto: tegra - finalize crypto req on error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbdev: matroxfb: Mark variable with __maybe_unused to avoid W=1 build break

Guillaume Gonnet <ggonnet.linux@gmail.com>
    dm init: ensure device probing has finished in dm-mod.waitfor=

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Add default case in DVI mode validation

Ethan Tidmore <ethantidmore06@gmail.com>
    drm/sun4i: Fix resource leaks

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Handle error from drm_sched_entity_init()

David Carlier <devnexen@gmail.com>
    selftests/sched_ext: Add missing error check for exit__load()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Fix V4L2 subdevice data initialization on probe

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: og01a1b: Replace client->dev usage

Felix Gu <ustc.gu@gmail.com>
    spi: fsl-qspi: Use reinit_completion() for repeated operations

Felix Gu <ustc.gu@gmail.com>
    spi: nxp-fspi: Use reinit_completion() for repeated operations

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: enable runtime pm for fspi

Harikrishna Shenoy <h-shenoy@ti.com>
    drm/bridge: cadence: cdns-mhdp8546-core: Handle HDCP state in bridge atomic check

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: cadence: cdns-mhdp8546-core: Add mode_valid hook to drm_bridge_funcs

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: cadence: cdns-mhdp8546-core: Set the mhdp connector earlier in atomic_enable()

Junrui Luo <moonafterrain@outlook.com>
    dm log: fix out-of-bounds write due to region_count overflow

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache metadata: fix memory leak on metadata abort retry

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: dwc: Perform cleanup in the error path of dw_pcie_resume_noirq()

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: dwc: Invoke post_init in dw_pcie_resume_noirq()

Aksh Garg <a-garg7@ti.com>
    PCI: dwc: ep: Fix MSI-X Table Size configuration in dw_pcie_ep_set_msix()

Niklas Cassel <cassel@kernel.org>
    PCI: endpoint: Align pci_epc_set_msix(), pci_epc_ops::set_msix() nr_irqs encoding

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/chrome: chromeos_tbmc: Drop wakeup source on remove

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix dirty mapping checking in passthrough mode switching

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: support shrinking the origin device

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix concurrent write failure in passthrough mode

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache policy smq: fix missing locks in invalidating cache blocks

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix write hang in passthrough mode

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix write path cache coherency in passthrough mode

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix null-deref with concurrent writes in passthrough mode

Sander Vanheule <sander@svanheule.net>
    ASoC: sti: use managed regmap_field allocations

Sander Vanheule <sander@svanheule.net>
    ASoC: sti: Return errors from regmap_field_alloc()

Ethan Tidmore <ethantidmore06@gmail.com>
    drm/sun4i: backend: fix error pointer dereference

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-compress: use function to clear symmetric params

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: add symmetric_ prefix for dai->rate/channels/sample_bits

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: SOF: ipc3: Use standard dev_dbg API

Alexander Konyukhov <Alexander.Konyukhov@kaspersky.com>
    drm/komeda: fix integer overflow in AFBC framebuffer size check

Jiayuan Chen <jiayuan.chen@linux.dev>
    net, bpf: fix null-ptr-deref in xdp_master_redirect() for down master

Xin Long <lucien.xin@gmail.com>
    sctp: fix missing encap_port propagation for GSO fragments

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Don't set treq->req_usec_ts in cookie_tcp_reqsk_init().

Gabriel Krisman Bertazi <krisman@suse.de>
    udp: Force compute_score to always inline

Alok Tiwari <alok.a.tiwari@oracle.com>
    ipv6: udp: fix typos in comments

Alok Tiwari <alok.a.tiwari@oracle.com>
    ipv4: udp: fix typos in comments

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: phy: qcom: at803x: Use the correct bit to disable extended next page

Stefan Metzmacher <metze@samba.org>
    Bluetooth: SCO: check for codecs->num_codecs == 1 before assigning to sco_pi(sk)->codec

Dudu Lu <phx0fer@gmail.com>
    Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp

Pauli Virtanen <pav@iki.fi>
    Bluetooth: fix locking in hci_conn_request_evt() with HCI_PROTO_DEFER

Jonathan Rissanen <jonathan.rissanen@axis.com>
    Bluetooth: hci_ldisc: Clear HCI_UART_PROTO_INIT on error

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix printing wrong information if SDU length exceeds MTU

Sun Jian <sun.jian.kdev@gmail.com>
    bpf: reject short IPv4/IPv6 inputs in bpf_prog_test_run_skb

Gal Pressman <gal@nvidia.com>
    net/mlx5e: IPsec, fix ASO poll timeout with read_poll_timeout_atomic()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix features not applied during netdev registration

Charles Perry <charles.perry@microchip.com>
    net: phy: fix a return path in get_phy_c45_ids()

Josua Mayer <josua@solid-run.com>
    dt-bindings: net: dsa: nxp,sja1105: make spi-cpol optional for sja1110

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Fix decoding EV_PER_EE for IPA v5.0+

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: Fix programming of QTIME_TIMESTAMP_CFG

Taegu Ha <hataegu0826@gmail.com>
    ppp: require CAP_NET_ADMIN in target netns for unattached ioctls

Lang Xu <xulang@uniontech.com>
    bpf: Fix OOB in pcpu_init_value

Greg Jumper <greg.jumper@oracle.com>
    net/rds: Restrict use of RDS/IB to the initial network namespace

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: Optimize rds_ib_laddr_check

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Allow instructions with arena source and non-arena dest registers

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add missing RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Implement BQL support

Florian Westphal <fw@strlen.de>
    selftests: netfilter: nft_tproxy.sh: adjust to socat changes

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ct: Only release RCU read lock after ct_ft

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: fix __jited_unpriv tag name

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Enforce regsafe base id consistency for BPF_ADD_CONST scalars

Puranjay Mohan <puranjay@kernel.org>
    bpf: Relax scalar id equivalence for state pruning

Mashiro Chen <mashiro.chen@mailbox.org>
    net: hamradio: 6pack: fix uninit-value in sixpack_receive_buf

Sechang Lim <rhkrqnwk98@gmail.com>
    bpf: Fix RCU stall in bpf_fd_array_map_clear()

Puranjay Mohan <puranjay@kernel.org>
    bpf: return VMA snapshot from task_vma iterator

Puranjay Mohan <puranjay@kernel.org>
    bpf: switch task_vma iterator from mmap_lock to per-VMA locks

Puranjay Mohan <puranjay@kernel.org>
    bpf: fix mm lifecycle in open-coded task_vma iterator

Florian Westphal <fw@strlen.de>
    netfilter: nft_fwd_netdev: check ttl/hl before forwarding

Florian Westphal <fw@strlen.de>
    netfilter: xt_socket: enable defrag after all other checks

Mohsin Bashir <hmohsin@meta.com>
    eth: fbnic: Use wake instead of start

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: fix racing timeout handler

Zak Kemble <zakkemble@gmail.com>
    net: bcmgenet: switch to use 64bit statistics

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: support reclaiming unsent Tx packets

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: move DESC_INDEX flow to ring 0

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: add bcmgenet_has_* helpers

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: fix off-by-one in bcmgenet_put_txcb

Wang Wensheng <wsw9603@163.com>
    arm64: kexec: Remove duplicate allocation for trans_pgd

Haoyu Lu <hechushiguitu666@gmail.com>
    ACPI: AGDI: fix missing newline in error message

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath10k: fix station lookup failure during disconnect

Weiming Shi <bestswngs@gmail.com>
    bpf: reject negative CO-RE accessor indices in bpf_core_parse_spec()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: handle VHT EXT NSS in ieee80211_determine_our_sta_mode()

Ethan Tidmore <ethantidmore06@gmail.com>
    wifi: brcmfmac: Fix error pointer dereference

MingTao Huang <mintaohuang@tencent.com>
    bpf: Fix stale offload->prog pointer after constant blinding

Weiming Shi <bestswngs@gmail.com>
    bpf: fix end-of-list detection in cgroup_storage_get_next_key()

Eric Dumazet <edumazet@google.com>
    macvlan: annotate data-races around port->bc_queue_len_used

Amit Machhiwal <amachhiw@linux.ibm.com>
    selftests/powerpc: Suppress -Wmaybe-uninitialized with GCC 15

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: Update backup region offset in elfcorehdr on memory hotplug

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: fix backup region offset update to elfcorehdr

Chih Kai Hsu <hsu.chih.kai@realtek.com>
    r8152: fix incorrect register write to USB_UPHY_XTAL

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    wifi: rtw89: phy: fix uninitialized variable access in rtw89_phy_cfo_set_crystal_cap()

haoyu.lu <hechushiguitu666@gmail.com>
    bpf,arc_jit: Fix missing newline in pr_err messages

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix variable length stack write over spilled pointers

David Carlier <devnexen@gmail.com>
    bpf: Use RCU-safe iteration in dev_map_redirect_multi() SKB path

Michael Lo <michael.lo@mediatek.com>
    wifi: mt76: mt7921: fix 6GHz regulatory update on connection

Duoming Zhou <duoming@zju.edu.cn>
    wifi: mt76: mt7996: fix use-after-free bugs in mt7996_mac_dump_work()

Duoming Zhou <duoming@zju.edu.cn>
    wifi: mt76: mt7915: fix use-after-free bugs in mt7915_mac_dump_work()

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: fix struct mt7996_mcu_uni_event

James Clark <james.clark@linaro.org>
    arm64: cpufeature: Make PMUVer and PerfMon unsigned

Rory Little <rory@candelatech.com>
    wifi: mt76: mt7921: Place upper limit on station AID

Alok Tiwari <alok.a.tiwari@oracle.com>
    wifi: mt76: mt7996: fix FCS error flag check in RX descriptor

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: prevent NULL vif dereference in mt7925_mac_write_txwi

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: prevent NULL pointer dereference in mt7925_tx_check_aggr()

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7915: fix use_cts_prot support

Ryder Lee <ryder.lee@mediatek.com>
    wifi: mt76: mt7615: fix use_cts_prot support

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7925: Fix incorrect MLO mode in firmware control

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7921: Reset ampdu_state state in case of failure in mt76_connac2_tx_check_aggr()

Petr Pavlu <petr.pavlu@suse.com>
    module: Fix freeing of charp module parameters when CONFIG_SYSFS=n

Petr Pavlu <petr.pavlu@suse.com>
    params: Replace __modinit with __init_or_module

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Zero-extend bpf prog return values and kfunc arguments

Cai Xinchen <caixinchen1@huawei.com>
    dpaa2: compile dpaa2 even CONFIG_FSL_DPAA2_ETH=n

Cai Xinchen <caixinchen1@huawei.com>
    dpaa2: add independent dependencies for FSL_DPAA2_SWITCH

Feng Yang <yangfeng@kylinos.cn>
    bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmit_push_encap

Duoming Zhou <duoming@zju.edu.cn>
    wifi: rtlwifi: pci: fix possible use-after-free caused by unfinished irq_prepare_bcn_tasklet

Zilin Guan <zilin@seu.edu.cn>
    wifi: mwifiex: Fix memory leak in mwifiex_11n_aggregate_pkt()

Mario Limonciello (AMD) <superm1@kernel.org>
    firmware: dmi: Correct an indexing error in dmi.h

Bart Van Assche <bvanassche@acm.org>
    locking: Fix rwlock support in <linux/spinlock_up.h>

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    sparc64: vdso: Link with -z noexecstack

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    sparc/vdso: Always reject undefined references during linking

Thomas Gleixner <tglx@kernel.org>
    hrtimer: Reduce trace noise in hrtimer_start()

Peter Zijlstra <peterz@infradead.org>
    hrtimer: Avoid pointless reprogramming in __hrtimer_start_range_ns()

Richard Clark <richard.xnu.clark@gmail.com>
    hrtimers: Update the return type of enqueue_hrtimer()

Brian Masney <bmasney@redhat.com>
    irqchip/irq-pic32-evic: Address warning related to wrong printf() formatter

Danilo Krummrich <dakr@kernel.org>
    bus: fsl-mc: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    s390/cio: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    platform/wmi: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    PCI: use generic driver_override infrastructure

Gui-Dong Han <hanguidong02@gmail.com>
    soundwire: debugfs: initialize firmware_file to empty string

Gui-Dong Han <hanguidong02@gmail.com>
    debugfs: fix placement of EXPORT_SYMBOL_GPL for debugfs_create_str()

Gui-Dong Han <hanguidong02@gmail.com>
    debugfs: check for NULL pointer in debugfs_create_str()

Gopi Krishna Menon <krishnagopi487@gmail.com>
    thermal/drivers/spear: Fix error condition for reading st,thermal-flags

Danilo Krummrich <dakr@kernel.org>
    devres: fix missing node debug info in devm_krealloc()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: cmos_rtc: Improve coordination with ACPI TAD driver

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: x86: cmos_rtc: Clean up address space handler driver

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock between reflink and transaction commit when using flushoncommit

David Sterba <dsterba@suse.com>
    btrfs: pass struct btrfs_inode to clone_copy_inline_extent()

Yu Kuai <yukuai@fnnas.com>
    md: wake raid456 reshape waiters before suspend

Gao Xiang <xiang@kernel.org>
    erofs: verify metadata accesses for file-backed mounts

Cole Leavitt <cole@unwrap.rs>
    pstore/ram: fix resource leak when ioremap() fails

Jackie Liu <liuyun01@kylinos.cn>
    blk-cgroup: fix disk reference leak in blkcg_maybe_throttle_current()

Deepanshu Kartikey <kartikey406@gmail.com>
    nilfs2: reject zero bd_oblocknr in nilfs_ioctl_mark_blocks_dirty()

Daan De Meyer <daan.j.demeyer@gmail.com>
    loop: fix partition scan race between udev and loop_reread_partitions()

Bart Van Assche <bvanassche@acm.org>
    drbd: Balance RCU calls in drbd_adm_dump_devices()

Xiao Ni <xni@redhat.com>
    md/raid1: fix the comparing region of interval tree

HyungJung Joo <jhj140711@gmail.com>
    fs/mbcache: cancel shrink work before destroying the cache

HyungJung Joo <jhj140711@gmail.com>
    fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START

Ming Lei <ming.lei@redhat.com>
    blk-cgroup: wait for blkcg cleanup before initializing new disk

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: use mem_is_zero()


-------------

Diffstat:

 .../bindings/interrupt-controller/arm,gic-v3.yaml  |   2 +-
 .../devicetree/bindings/net/dsa/nxp,sja1105.yaml   |   2 -
 Documentation/mm/hugetlbfs_reserv.rst              |   2 +-
 Documentation/networking/netconsole.rst            |   6 +-
 Makefile                                           |   4 +-
 arch/arc/net/bpf_jit_arcv2.c                       |   8 +-
 arch/arm/boot/dts/mediatek/mt7623.dtsi             |   2 +-
 .../boot/dts/nxp/imx/imx27-eukrea-cpuimx27.dtsi    |   8 +-
 .../nxp/imx/imx27-eukrea-mbimxsd27-baseboard.dts   |   2 +-
 arch/arm/mach-omap1/clock_data.c                   |   4 +-
 arch/arm/net/bpf_jit_32.c                          |   6 +
 .../boot/dts/amlogic/meson-gxl-s905d-p230.dts      |   3 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     | 161 +++--
 .../boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi |   4 +
 .../boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi |   4 +
 .../arm64/boot/dts/freescale/imx8mm-emtop-som.dtsi |   4 +-
 .../arm64/boot/dts/freescale/imx8mm-tqma8mqml.dtsi |   2 +-
 .../arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi |   2 +-
 .../dts/freescale/imx8mp-data-modul-edm-sbc.dts    |   2 +-
 .../boot/dts/freescale/imx8mp-debix-model-a.dts    |   2 +-
 .../dts/freescale/imx8mp-debix-som-a-bmb-08.dts    |   2 +-
 .../boot/dts/freescale/imx8mp-debix-som-a.dtsi     |   2 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |   2 +-
 .../boot/dts/freescale/imx8mp-icore-mx8mp.dtsi     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp-navqp.dts     |   2 +-
 .../freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts   |   4 +-
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |  10 +-
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts      |  10 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   2 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/arm64/boot/dts/mediatek/mt6795.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt7981b.dtsi          |   2 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |   2 +-
 arch/arm64/boot/dts/mediatek/mt8365.dtsi           |   5 +-
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-daisy.dts  |   2 +-
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts  |   2 +-
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |   1 +
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   4 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   5 +
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   5 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   7 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |   7 +-
 arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts |   4 +-
 arch/arm64/boot/dts/rockchip/rk3588-jaguar.dts     |   2 +-
 .../boot/dts/rockchip/rk3588s-gameforce-ace.dts    |  12 +-
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |  14 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts            |   6 +-
 arch/arm64/include/asm/kernel-pgtable.h            |   7 +-
 arch/arm64/include/asm/xor.h                       |   2 +-
 arch/arm64/kernel/cpufeature.c                     |   4 +-
 arch/arm64/kernel/machine_kexec.c                  |   3 -
 arch/arm64/kernel/pi/patch-scs.c                   |   4 +-
 arch/arm64/net/bpf_jit_comp.c                      |   4 +-
 arch/loongarch/Kbuild                              |   2 +-
 arch/loongarch/include/asm/asm-prototypes.h        |  20 +
 arch/loongarch/include/asm/kvm_host.h              |   3 -
 arch/loongarch/kvm/Makefile                        |   3 +-
 arch/loongarch/kvm/main.c                          |  35 +-
 arch/loongarch/kvm/switch.S                        |  19 +-
 arch/powerpc/include/asm/kexec.h                   |  14 +-
 arch/powerpc/kexec/crash.c                         |  64 ++
 arch/powerpc/kexec/file_load_64.c                  |  29 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  21 +-
 arch/powerpc/kvm/powerpc.c                         |  24 +-
 arch/powerpc/platforms/44x/warp.c                  |   2 +
 arch/powerpc/platforms/cell/spu_syscalls.c         |   6 +-
 arch/riscv/net/bpf_jit.h                           |   6 -
 arch/riscv/net/bpf_jit_core.c                      |   7 -
 arch/s390/kvm/interrupt.c                          |   3 +-
 arch/s390/kvm/pci.c                                |   6 +-
 arch/s390/net/bpf_jit_comp.c                       |  39 +-
 arch/sparc/vdso/Makefile                           |   7 +-
 arch/sparc/vdso/checkundef.sh                      |  10 -
 arch/x86/Makefile.um                               |   2 +
 arch/x86/kernel/acpi/cppc.c                        |   6 +-
 arch/x86/kernel/cpu/sgx/main.c                     |  10 +-
 arch/x86/kvm/svm/sev.c                             |  39 +-
 arch/x86/kvm/trace.h                               |   2 +-
 arch/x86/um/vdso/Makefile                          |   7 +-
 block/blk-cgroup.c                                 |  16 +
 block/disk-events.c                                |   3 +-
 crypto/af_alg.c                                    |   2 +
 crypto/jitterentropy-kcapi.c                       |  14 +-
 drivers/acpi/arm64/agdi.c                          |   2 +-
 drivers/acpi/x86/cmos_rtc.c                        |  79 ++-
 drivers/ata/libata-scsi.c                          |   4 +-
 drivers/base/devres.c                              |   2 +
 drivers/block/drbd/drbd_nl.c                       |   8 +-
 drivers/bluetooth/btmtk.c                          |   4 +-
 drivers/bluetooth/hci_ldisc.c                      |   3 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  43 +-
 drivers/bus/stm32_rifsc.c                          |  52 +-
 drivers/cdrom/cdrom.c                              |  73 ++-
 drivers/char/ipmi/ssif_bmc.c                       |  34 +-
 drivers/clk/clk-qoriq.c                            |  17 +-
 drivers/clk/clk-xgene.c                            |   2 +
 drivers/clk/imx/clk-imx6q.c                        |  12 +-
 drivers/clk/imx/clk-imx8mq.c                       |   4 +-
 drivers/clk/qcom/dispcc-sc7180.c                   |   8 +
 drivers/clk/qcom/dispcc-sc8280xp.c                 |   4 -
 drivers/clk/qcom/dispcc-sm4450.c                   |   1 -
 drivers/clk/qcom/dispcc-sm8250.c                   |   6 +-
 drivers/clk/qcom/dispcc-sm8450.c                   |   2 +-
 drivers/clk/qcom/gcc-sc8180x.c                     |  64 +-
 drivers/clk/qcom/gcc-x1e80100.c                    |   1 +
 drivers/clk/visconti/pll.c                         |   2 +-
 drivers/crypto/atmel-aes.c                         |  23 +-
 drivers/crypto/atmel-sha.c                         |  27 +-
 drivers/crypto/atmel-tdes.c                        |  25 +-
 drivers/crypto/ccp/ccp-crypto-aes.c                |   7 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |  20 +-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c       |   2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |  14 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   2 +-
 .../crypto/intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c |   4 +-
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c       |   2 +-
 .../crypto/intel/qat/qat_c62x/adf_c62x_hw_data.c   |   4 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c        |   4 +-
 .../intel/qat/qat_common/adf_accel_devices.h       |  12 +-
 .../crypto/intel/qat/qat_common/adf_gen2_hw_data.c |   2 +-
 .../intel/qat/qat_common/adf_sysfs_ras_counters.c  |  12 +-
 .../intel/qat/qat_common/icp_qat_hw_20_comp.h      |  10 +-
 .../intel/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |   6 +-
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |   2 +-
 drivers/crypto/sa2ul.c                             |   4 +-
 drivers/crypto/tegra/tegra-se-aes.c                | 257 ++++++--
 drivers/crypto/tegra/tegra-se-hash.c               | 104 +--
 drivers/crypto/tegra/tegra-se-key.c                |  19 +-
 drivers/crypto/tegra/tegra-se.h                    |  33 +-
 drivers/cxl/pci.c                                  |   3 +
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   2 -
 drivers/dma/mxs-dma.c                              |   1 +
 drivers/firmware/arm_ffa/driver.c                  |   2 +-
 drivers/firmware/efi/capsule-loader.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_isp.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |  57 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c          |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c       |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/cik.c                   |   4 +-
 drivers/gpu/drm/amd/amdgpu/cik_ih.c                |   4 +-
 drivers/gpu/drm/amd/amdgpu/cik_sdma.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/cz_ih.c                 |   4 +-
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |  70 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/iceland_ih.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |   4 +-
 drivers/gpu/drm/amd/amdgpu/ih_v6_1.c               |   4 +-
 drivers/gpu/drm/amd/amdgpu/ih_v7_0.c               |   4 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.h             |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v2_4.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/si.c                    |   4 +-
 drivers/gpu/drm/amd/amdgpu/si_dma.c                |   4 +-
 drivers/gpu/drm/amd/amdgpu/si_ih.c                 |   4 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   4 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   4 +-
 drivers/gpu/drm/amd/amdgpu/soc24.c                 |   4 +-
 drivers/gpu/drm/amd/amdgpu/tonga_ih.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  20 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vce_v4_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  11 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/vega10_ih.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |   4 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |  62 ++
 .../gpu/drm/amd/display/dc/dce/dce_link_encoder.c  |   4 +-
 .../amd/display/include/grph_object_ctrl_defs.h    |   4 +
 drivers/gpu/drm/amd/include/amd_shared.h           |   6 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |   4 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   4 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   5 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c     |  15 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    | 118 +++-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.h    |   1 +
 drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h       |   1 +
 .../gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c    |  15 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   4 +-
 .../drm/arm/display/komeda/komeda_framebuffer.c    |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |  72 ++-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.h    |   1 +
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-hdcp.c    |  18 +-
 drivers/gpu/drm/drm_syncobj.c                      |   9 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   1 +
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |   9 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   9 +-
 drivers/gpu/drm/i915/display/skl_watermark.c       | 420 ++++++-------
 drivers/gpu/drm/i915/gt/intel_reset.c              |   3 +-
 drivers/gpu/drm/imagination/pvr_rogue_fwif.h       |   8 +-
 .../gpu/drm/imagination/pvr_rogue_fwif_shared.h    |   6 +-
 drivers/gpu/drm/loongson/lsdc_drv.c                |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |  14 +-
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c              |  14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   2 -
 drivers/gpu/drm/msm/dsi/dsi_cfg.c                  |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_cfg.h                  |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  16 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |   5 +-
 drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c    |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   2 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |   2 +
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   6 +-
 drivers/gpu/drm/tiny/ofdrm.c                       |   2 +
 drivers/gpu/drm/v3d/v3d_drv.c                      |  16 +-
 drivers/gpu/drm/v3d/v3d_submit.c                   |   5 +
 drivers/gpu/drm/xe/xe_dma_buf.c                    |  31 +-
 drivers/gpu/drm/xe/xe_exec_queue.c                 |   7 +-
 drivers/gpu/drm/xe/xe_gsc.c                        |   2 +-
 drivers/gpu/drm/xe/xe_reg_whitelist.c              |   2 +-
 drivers/hid/hid-asus.c                             |  28 +-
 drivers/hid/usbhid/hid-core.c                      |   2 +-
 drivers/hte/Kconfig                                |   6 +-
 drivers/hwmon/abituguru.c                          |   2 +-
 drivers/hwmon/abituguru3.c                         |   4 +-
 drivers/hwmon/aspeed-g6-pwm-tach.c                 |   8 -
 drivers/hwmon/da9052-hwmon.c                       |   2 +-
 drivers/hwmon/dme1737.c                            |   2 +-
 drivers/hwmon/f71805f.c                            |   2 +-
 drivers/hwmon/f71882fg.c                           |   2 +-
 drivers/hwmon/i5k_amb.c                            |   2 +-
 drivers/hwmon/max197.c                             |   2 +-
 drivers/hwmon/mc13783-adc.c                        |   2 +-
 drivers/hwmon/occ/p9_sbe.c                         |   4 +-
 drivers/hwmon/pc87360.c                            |   2 +-
 drivers/hwmon/pc87427.c                            |   2 +-
 drivers/hwmon/sch5636.c                            |   2 +-
 drivers/hwmon/sht15.c                              |   2 +-
 drivers/hwmon/sis5595.c                            |   2 +-
 drivers/hwmon/smsc47m1.c                           |   2 +-
 drivers/hwmon/ultra45_env.c                        |   2 +-
 drivers/hwmon/via-cputemp.c                        |   2 +-
 drivers/hwmon/via686a.c                            |   2 +-
 drivers/hwmon/vt1211.c                             |   2 +-
 drivers/hwmon/vt8231.c                             |   4 +-
 drivers/hwmon/w83627hf.c                           |   2 +-
 drivers/hwmon/w83781d.c                            |   2 +-
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/i3c/master.c                               |  32 +-
 drivers/i3c/master/dw-i3c-master.c                 |  16 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   5 +-
 drivers/infiniband/core/iwpm_msg.c                 |   6 +-
 drivers/infiniband/hw/mana/cq.c                    |   5 +-
 drivers/iommu/amd/amd_iommu_types.h                |  21 +-
 drivers/iommu/amd/iommu.c                          | 463 +++++++++-----
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   7 +-
 drivers/iommu/intel/iommu.c                        |   3 +
 drivers/iommu/iommufd/fault.c                      |   5 +-
 drivers/iommu/iommufd/vfio_compat.c                |   2 +-
 drivers/irqchip/irq-pic32-evic.c                   |   2 +-
 drivers/irqchip/irq-riscv-imsic-early.c            |   2 +
 drivers/leds/blink/leds-lgm-sso.c                  |   2 -
 drivers/mailbox/mailbox-test.c                     |  39 +-
 drivers/mailbox/mailbox.c                          |   3 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   8 +-
 drivers/md/dm-cache-metadata.c                     |  24 +-
 drivers/md/dm-cache-metadata.h                     |   5 -
 drivers/md/dm-cache-policy-smq.c                   |   4 +
 drivers/md/dm-cache-target.c                       | 143 ++++-
 drivers/md/dm-init.c                               |   4 +-
 drivers/md/dm-log.c                                |   6 +-
 drivers/md/md.c                                    |  11 +
 drivers/md/raid1.c                                 |   4 +-
 drivers/media/i2c/og01a1b.c                        |  93 +--
 drivers/media/rc/lirc_dev.c                        |  13 +-
 drivers/memory/tegra/tegra124-emc.c                |   2 +-
 drivers/memory/tegra/tegra30-emc.c                 |   6 +-
 drivers/mfd/mc13xxx-core.c                         |   2 +-
 drivers/mtd/maps/physmap-gemini.c                  |   2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   6 +-
 drivers/mtd/parsers/ofpart_core.c                  |   4 +-
 drivers/mtd/spi-nor/core.c                         |   2 +-
 drivers/mtd/spi-nor/core.h                         |   8 +-
 drivers/mtd/spi-nor/sfdp.c                         |  30 +-
 drivers/mtd/spi-nor/swp.c                          |   4 +-
 drivers/net/bareudp.c                              |   3 +
 drivers/net/dsa/realtek/rtl8365mb.c                |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 698 ++++++++++-----------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  68 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   6 +-
 drivers/net/ethernet/freescale/Makefile            |   3 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |   4 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   1 +
 drivers/net/ethernet/intel/i40e/i40e.h             |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   3 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  52 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  76 ++-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |  12 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |  46 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   7 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   7 +-
 drivers/net/ethernet/mediatek/airoha_eth.c         |  27 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   8 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   2 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_target.c    |  17 +-
 drivers/net/ethernet/sfc/efx_devlink.c             |   2 +-
 drivers/net/hamradio/6pack.c                       |   9 +-
 drivers/net/ipa/gsi.c                              |   1 +
 drivers/net/ipa/ipa_main.c                         |   6 +-
 drivers/net/macvlan.c                              |   9 +-
 drivers/net/mctp/mctp-i2c.c                        |   4 +-
 drivers/net/netconsole.c                           |   9 +-
 drivers/net/netdevsim/dev.c                        |   2 +-
 drivers/net/phy/dp83869.c                          |  13 +-
 drivers/net/phy/phy_device.c                       |   4 +-
 drivers/net/phy/qcom/at803x.c                      |   2 +-
 drivers/net/ppp/ppp_generic.c                      |   5 +-
 drivers/net/ppp/pppoe.c                            |   8 +-
 drivers/net/slip/slhc.c                            |  49 +-
 drivers/net/usb/r8152.c                            |   2 +-
 drivers/net/usb/rtl8150.c                          |  12 +-
 drivers/net/virtio_net.c                           | 125 ++--
 drivers/net/vrf.c                                  |  15 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  26 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  15 +
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  15 -
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  47 ++
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   2 -
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  13 -
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  62 ++
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |  11 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   4 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   2 +-
 drivers/nfc/trf7970a.c                             |   3 +-
 drivers/nvme/host/pci.c                            |   1 +
 drivers/nvme/target/tcp.c                          |  51 +-
 drivers/nvmem/brcm_nvram.c                         |   2 +-
 drivers/nvmem/layouts/u-boot-env.c                 |   2 +-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   8 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   9 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  18 +-
 drivers/pci/controller/dwc/pcie-designware.c       |  16 +-
 drivers/pci/controller/dwc/pcie-designware.h       |   2 +
 drivers/pci/controller/dwc/pcie-qcom.c             |  17 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |   2 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         | 183 +++---
 drivers/pci/controller/pcie-mediatek-gen3.c        |   8 +-
 drivers/pci/endpoint/pci-epc-core.c                |  11 +-
 drivers/pci/npem.c                                 |   2 +-
 drivers/pci/pci-driver.c                           |  20 +-
 drivers/pci/pci-sysfs.c                            |  28 -
 drivers/pci/pci.c                                  |  41 +-
 drivers/pci/probe.c                                |   1 -
 drivers/pcmcia/rsrc_nonstatic.c                    |   6 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |   2 +-
 drivers/pinctrl/pinctrl-cy8c95x0.c                 |  27 +-
 drivers/pinctrl/pinctrl-pic32.c                    |  20 +-
 drivers/pinctrl/realtek/pinctrl-rtd.c              |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   7 +
 drivers/platform/chrome/chromeos_tbmc.c            |   6 +
 drivers/platform/surface/surfacepro3_button.c      |   1 +
 drivers/platform/x86/asus-wmi.c                    |  50 +-
 .../x86/dell/dell-wmi-sysman/enum-attributes.c     |  34 +-
 drivers/platform/x86/dell/dell_rbu.c               |   6 +-
 drivers/platform/x86/panasonic-laptop.c            |   5 +-
 drivers/platform/x86/wmi.c                         |  36 +-
 drivers/pmdomain/imx/scu-pd.c                      |   1 +
 drivers/pmdomain/ti/omap_prm.c                     |   1 +
 drivers/pwm/pwm-atmel-tcb.c                        |  38 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |   2 +-
 drivers/reset/core.c                               | 119 +++-
 drivers/rtc/rtc-abx80x.c                           |   2 +
 drivers/s390/cio/cio.h                             |   5 -
 drivers/s390/cio/css.c                             |  34 +-
 drivers/scsi/sg.c                                  |  31 +-
 drivers/scsi/sr.c                                  |  11 +-
 drivers/scsi/sr.h                                  |   1 -
 drivers/soc/qcom/llcc-qcom.c                       |   2 +-
 drivers/soc/qcom/ocmem.c                           |  17 +-
 drivers/soc/qcom/qcom_aoss.c                       |   2 +-
 drivers/soc/tegra/cbb/tegra234-cbb.c               |   4 +
 drivers/soundwire/bus.c                            |   8 +-
 drivers/soundwire/cadence_master.c                 |   8 +
 drivers/soundwire/debugfs.c                        |   9 +-
 drivers/spi/spi-fsl-qspi.c                         |   3 +-
 drivers/spi/spi-hisi-kunpeng.c                     |  12 +-
 drivers/spi/spi-mtk-snfi.c                         |  14 +
 drivers/spi/spi-nxp-fspi.c                         | 102 ++-
 drivers/spi/spi-rockchip.c                         |   3 +-
 drivers/spi/spi-sifive.c                           |  29 +-
 drivers/target/target_core_sbc.c                   |   3 +-
 drivers/thermal/spear_thermal.c                    |   2 +-
 drivers/tty/hvc/hvc_iucv.c                         |   2 +-
 drivers/tty/serial/ip22zilog.c                     |   2 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |   4 +-
 drivers/vfio/pci/vfio_pci_core.c                   |   5 +-
 drivers/vhost/net.c                                |   4 +-
 drivers/video/backlight/sky81452-backlight.c       |   3 +
 drivers/video/fbdev/matrox/g450_pll.c              |   2 +-
 drivers/video/fbdev/offb.c                         |   7 +-
 drivers/xen/xen-pciback/pci_stub.c                 |   6 +-
 fs/adfs/super.c                                    |   3 +
 fs/btrfs/inode.c                                   |  42 +-
 fs/btrfs/ioctl.c                                   |   5 +-
 fs/btrfs/reflink.c                                 |  73 ++-
 fs/ceph/xattr.c                                    |  17 +
 fs/debugfs/file.c                                  |   7 +-
 fs/erofs/data.c                                    |  14 +
 fs/erofs/erofs_fs.h                                |  99 ++-
 fs/erofs/internal.h                                |   2 +-
 fs/erofs/zdata.c                                   |   2 +-
 fs/erofs/zmap.c                                    | 166 +++--
 fs/eventfd.c                                       |   9 +-
 fs/eventpoll.c                                     |  23 +-
 fs/ext4/mballoc-test.c                             |   6 +-
 fs/f2fs/f2fs.h                                     |   3 +
 fs/f2fs/inline.c                                   |  13 +-
 fs/f2fs/super.c                                    |  11 +
 fs/f2fs/sysfs.c                                    |   7 +-
 fs/fhandle.c                                       |   5 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/gfs2/log.c                                      |  33 +-
 fs/ioctl.c                                         |  23 +-
 fs/kernel_read_file.c                              |  12 +-
 fs/mbcache.c                                       |   1 +
 fs/netfs/iterator.c                                |  13 +-
 fs/nfs/blocklayout/blocklayout.c                   |   4 +-
 fs/nilfs2/ioctl.c                                  |   6 +
 fs/notify/fanotify/fanotify_user.c                 |  40 +-
 fs/notify/inotify/inotify_user.c                   |  17 +-
 fs/notify/mark.c                                   |  39 +-
 fs/ntfs3/dir.c                                     |   5 +-
 fs/ntfs3/fsntfs.c                                  |   4 +-
 fs/ntfs3/inode.c                                   |  13 +-
 fs/ntfs3/namei.c                                   |  17 +-
 fs/ntfs3/super.c                                   |   7 +-
 fs/ntfs3/xattr.c                                   |   5 +-
 fs/ocfs2/dlm/dlmdomain.c                           |  10 +-
 fs/ocfs2/ioctl.c                                   |  18 +-
 fs/ocfs2/resize.c                                  |  12 +-
 fs/ocfs2/xattr.c                                   |   4 +-
 fs/omfs/inode.c                                    |   6 +
 fs/open.c                                          |  36 +-
 fs/pstore/ram_core.c                               |   4 +
 fs/quota/dquot.c                                   |  38 +-
 fs/read_write.c                                    |  28 +-
 fs/signalfd.c                                      |   9 +-
 fs/smb/client/ioctl.c                              |   2 +-
 fs/smb/client/smb2file.c                           |  27 +-
 fs/smb/client/smb2pdu.h                            |   2 +-
 fs/smb/client/smb2transport.c                      |  32 +-
 fs/smb/server/auth.c                               |  11 +-
 fs/smb/server/connection.c                         |   9 +
 fs/smb/server/mgmt/user_session.c                  |  12 +-
 fs/smb/server/smb2pdu.c                            |   2 +
 fs/sync.c                                          |  29 +-
 fs/tracefs/event_inode.c                           |   2 +-
 include/dt-bindings/clock/qcom,dispcc-sc7180.h     |   7 +-
 include/dt-bindings/clock/qcom,gcc-sc8180x.h       |   5 +
 include/linux/cdrom.h                              |   1 +
 include/linux/cpuhotplug.h                         |   1 -
 include/linux/dmi.h                                |   5 +
 include/linux/file.h                               |   6 -
 include/linux/fsl/mc.h                             |   4 -
 include/linux/if_ether.h                           |   3 +
 include/linux/moduleparam.h                        |  11 +-
 include/linux/netpoll.h                            |   6 +
 include/linux/padata.h                             |   8 +-
 include/linux/pci-epc.h                            |   6 +-
 include/linux/pci.h                                |   6 -
 include/linux/pm_domain.h                          |   4 +-
 include/linux/ppp_defs.h                           |  16 +
 include/linux/printk.h                             |   5 +-
 include/linux/quotaops.h                           |   9 +-
 include/linux/reset.h                              | 274 ++++++--
 include/linux/spinlock_up.h                        |  20 +-
 include/linux/wmi.h                                |   4 -
 include/net/page_pool/memory_provider.h            |  15 +
 include/net/page_pool/types.h                      |   4 +
 include/net/pie.h                                  |   2 +-
 include/sound/soc-dai.h                            |   6 +-
 include/sound/soc.h                                |   3 +
 include/trace/events/timer.h                       |  11 +-
 include/uapi/linux/mii.h                           |   3 +-
 include/uapi/linux/virtio_net.h                    |  13 +
 io_uring/io-wq.c                                   |   3 +-
 io_uring/kbuf.c                                    |  14 +-
 io_uring/sqpoll.c                                  |  29 +-
 kernel/audit.c                                     |   4 +
 kernel/auditsc.c                                   |   2 +-
 kernel/bpf/arena.c                                 |   4 +
 kernel/bpf/arraymap.c                              |   4 +-
 kernel/bpf/bpf_lsm.c                               |   3 -
 kernel/bpf/core.c                                  |   2 +
 kernel/bpf/devmap.c                                |   5 +-
 kernel/bpf/hashtab.c                               |   2 +-
 kernel/bpf/helpers.c                               |  17 +-
 kernel/bpf/local_storage.c                         |   2 +-
 kernel/bpf/task_iter.c                             | 151 ++++-
 kernel/bpf/verifier.c                              | 127 +++-
 kernel/cgroup/cgroup.c                             |  46 +-
 kernel/cgroup/rdma.c                               |   2 +-
 kernel/events/core.c                               |  14 +-
 kernel/fork.c                                      |  11 +-
 kernel/futex/requeue.c                             |  13 +-
 kernel/module/main.c                               |   4 +-
 kernel/nsproxy.c                                   |   5 +-
 kernel/padata.c                                    | 130 ++--
 kernel/params.c                                    |  42 +-
 kernel/pid.c                                       |   7 +-
 kernel/sched/core.c                                |   1 +
 kernel/sched/ext.c                                 |   8 +
 kernel/sys.c                                       |  15 +-
 kernel/time/hrtimer.c                              |  56 +-
 kernel/trace/trace_branch.c                        |   8 +-
 kernel/trace/trace_events_hist.c                   |  12 +-
 kernel/watch_queue.c                               |   6 +-
 kernel/workqueue.c                                 |   4 +-
 lib/net_utils.c                                    |   4 +-
 mm/fadvise.c                                       |  10 +-
 mm/readahead.c                                     |  17 +-
 net/bluetooth/hci_event.c                          |   3 -
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/bluetooth/sco.c                                |   3 +-
 net/bpf/test_run.c                                 |  35 +-
 net/ceph/crush/crush.c                             |   6 +-
 net/ceph/osdmap.c                                  |  14 +-
 net/core/devmem.c                                  |  24 +-
 net/core/filter.c                                  |   4 +-
 net/core/neighbour.c                               |  10 +-
 net/core/net_namespace.c                           |  10 +-
 net/core/netpoll.c                                 | 219 ++++---
 net/core/page_pool.c                               |  34 +-
 net/ipv4/netfilter/arp_tables.c                    |  18 +-
 net/ipv4/netfilter/arpt_mangle.c                   |   8 +
 net/ipv4/nexthop.c                                 |   4 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp.c                                     |  22 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_output.c                              |  15 +-
 net/ipv4/tcp_plb.c                                 |   2 +-
 net/ipv4/tcp_timer.c                               |   5 +-
 net/ipv4/udp.c                                     |  16 +-
 net/ipv6/icmp.c                                    |  10 +-
 net/ipv6/udp.c                                     |  17 +-
 net/mac80211/debugfs_sta.c                         |   7 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mptcp/fastopen.c                               |  28 +-
 net/mptcp/pm_netlink.c                             |  26 +-
 net/mptcp/protocol.c                               |   4 +-
 net/mptcp/protocol.h                               |   5 +-
 net/mptcp/subflow.c                                |   3 -
 net/netfilter/ipvs/ip_vs_xmit.c                    |  19 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  10 +-
 net/netfilter/nf_conntrack_sip.c                   | 160 +++--
 net/netfilter/nf_nat_amanda.c                      |   2 +-
 net/netfilter/nf_nat_sip.c                         |  34 +-
 net/netfilter/nf_tables_api.c                      |  30 +-
 net/netfilter/nfnetlink_osf.c                      |  45 +-
 net/netfilter/nft_ct.c                             |   2 +
 net/netfilter/nft_fwd_netdev.c                     |  10 +
 net/netfilter/nft_osf.c                            |   6 +-
 net/netfilter/xt_mac.c                             |  34 +-
 net/netfilter/xt_owner.c                           |  37 +-
 net/netfilter/xt_physdev.c                         |  29 +-
 net/netfilter/xt_policy.c                          |   2 +-
 net/netfilter/xt_realm.c                           |   2 +-
 net/netfilter/xt_socket.c                          |  23 +-
 net/openvswitch/datapath.c                         |  35 +-
 net/openvswitch/vport.c                            |   3 +
 net/rds/af_rds.c                                   |  10 +-
 net/rds/connection.c                               |  14 +
 net/rds/ib.c                                       |  24 +-
 net/rds/ib.h                                       |   1 +
 net/rds/ib_rdma.c                                  |   2 +-
 net/sched/act_ct.c                                 |   8 +-
 net/sched/act_mirred.c                             |   2 +-
 net/sched/sch_cake.c                               |  15 +-
 net/sched/sch_choke.c                              |  26 +-
 net/sched/sch_fq_codel.c                           |   3 +-
 net/sched/sch_fq_pie.c                             |  19 +-
 net/sched/sch_hhf.c                                |  19 +-
 net/sched/sch_netem.c                              |  76 ++-
 net/sched/sch_pie.c                                |  52 +-
 net/sched/sch_red.c                                |  31 +-
 net/sched/sch_sfb.c                                |  54 +-
 net/sched/sch_taprio.c                             |  22 +-
 net/sctp/inqueue.c                                 |   1 +
 net/sctp/sm_statefuns.c                            |   6 +
 net/sctp/socket.c                                  |   2 +-
 net/socket.c                                       | 301 ++++-----
 net/tipc/msg.c                                     |  14 +-
 net/tls/tls.h                                      |   1 +
 net/tls/tls_strp.c                                 |   6 +
 net/tls/tls_sw.c                                   |   4 +
 net/unix/af_unix.c                                 |   9 +-
 net/unix/unix_bpf.c                                |   3 +
 scripts/package/builddeb                           |   8 +-
 security/integrity/ima/ima_crypto.c                |   2 +-
 security/integrity/ima/ima_fs.c                    | 153 ++---
 security/landlock/syscalls.c                       |  26 +-
 sound/core/compress_offload.c                      |   7 -
 sound/core/sound.c                                 |   7 +
 sound/isa/sc6000.c                                 | 152 +++--
 sound/pci/hda/cs35l56_hda.c                        |  12 +-
 sound/pci/hda/cs35l56_hda.h                        |   1 +
 sound/pci/hda/patch_conexant.c                     |  20 +-
 sound/pci/hda/patch_realtek.c                      |  20 +-
 sound/soc/amd/acp/acp-legacy-mach.c                |   2 +-
 sound/soc/amd/acp/acp-mach-common.c                |  22 +-
 sound/soc/amd/acp/acp-mach.h                       |   4 +
 sound/soc/amd/acp/acp-sof-mach.c                   |   2 +-
 sound/soc/codecs/ab8500-codec.c                    |   6 +-
 sound/soc/fsl/fsl_easrc.c                          | 123 ++--
 sound/soc/fsl/fsl_micfil.c                         |  60 +-
 sound/soc/fsl/fsl_xcvr.c                           |  22 +-
 sound/soc/mediatek/mt8188/mt8188-dai-pcm.c         |   2 +-
 sound/soc/mediatek/mt8195/mt8195-dai-pcm.c         |   2 +-
 sound/soc/mediatek/mt8365/mt8365-dai-dmic.c        |   6 +-
 sound/soc/mediatek/mt8365/mt8365-dai-pcm.c         |   2 +-
 sound/soc/qcom/qdsp6/topology.c                    |   8 +-
 sound/soc/sh/rcar/core.c                           |   2 +-
 sound/soc/soc-compress.c                           |   4 +-
 sound/soc/soc-pcm.c                                |  33 +-
 sound/soc/sof/compress.c                           |   8 +-
 sound/soc/sof/intel/hda-stream.c                   |  10 +-
 sound/soc/sof/ipc3.c                               |   2 +-
 sound/soc/sof/sof-priv.h                           |   2 +
 sound/soc/sti/uniperif_player.c                    |   9 +-
 sound/usb/midi.c                                   |  12 +-
 sound/usb/midi2.c                                  |  12 +-
 sound/usb/mixer_scarlett2.c                        |   2 +-
 sound/usb/quirks.c                                 |   2 +-
 sound/usb/stream.c                                 |  58 +-
 sound/usb/stream.h                                 |   3 +-
 tools/lib/bpf/libbpf.c                             | 384 +++++-------
 tools/lib/bpf/relo_core.c                          |   2 +
 tools/perf/builtin-diff.c                          |   6 +-
 tools/perf/builtin-list.c                          |  13 +-
 tools/perf/builtin-lock.c                          |   2 +-
 tools/perf/builtin-stat.c                          |  44 +-
 tools/perf/util/Build                              |   1 +
 tools/perf/util/branch.h                           |   3 +
 tools/perf/util/cgroup.c                           |  30 +-
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c    |  51 +-
 tools/perf/util/evsel.c                            | 296 ++-------
 tools/perf/util/evsel.h                            |  49 +-
 tools/perf/util/expr.c                             |   3 +-
 tools/perf/util/maps.c                             |  13 +-
 tools/perf/util/metricgroup.c                      |   1 +
 tools/perf/util/parse-events.c                     |  94 ++-
 tools/perf/util/parse-events.h                     |  11 +-
 tools/perf/util/parse-events.l                     |  11 -
 tools/perf/util/parse-events.y                     |  18 +-
 tools/perf/util/pmu.c                              |  26 +-
 tools/perf/util/pmu.h                              |   4 +-
 tools/perf/util/pmus.c                             |   9 +
 tools/perf/util/print-events.c                     |  36 +-
 tools/perf/util/print-events.h                     |   1 -
 tools/perf/util/python.c                           |  61 ++
 tools/perf/util/stat-display.c                     |   6 +-
 tools/perf/util/stat-shadow.c                      |   1 +
 tools/perf/util/symbol-elf.c                       |   8 +-
 tools/perf/util/tool_pmu.c                         | 417 ++++++++++++
 tools/perf/util/tool_pmu.h                         |  51 ++
 tools/perf/util/util.h                             |   1 -
 tools/testing/ktest/ktest.pl                       |  35 +-
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |   3 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |   2 +-
 .../selftests/bpf/progs/verifier_scalar_ids.c      |   8 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |  11 +-
 tools/testing/selftests/mm/migration.c             |   3 +-
 .../selftests/net/netfilter/nft_tproxy_udp.sh      |  14 +-
 tools/testing/selftests/powerpc/vphn/Makefile      |   2 +-
 tools/testing/selftests/sched_ext/exit.c           |   2 +-
 virt/kvm/dirty_ring.c                              |   3 +-
 virt/kvm/vfio.c                                    |   8 +-
 748 files changed, 8358 insertions(+), 5520 deletions(-)


