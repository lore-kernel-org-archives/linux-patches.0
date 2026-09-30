Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D08F509EF9;
	Wed, 30 Sep 2026 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788151; cv=none; b=lBcGkyaNi+pf+TsWh+QmdUoY7lgb0rJUGb5wLd+6CQZv03SIk7jxoboZO/QOqYY9KV4xwKCPgXI+/relfuApq6WfN6JJUwAeSTUP/APecmt0U7R6zom6xCWtHh3N7NtOZbChNAJ3ZoeRbnblPJbMqbAPCAWb2R/B7vnEiehSRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788151; c=relaxed/simple;
	bh=TLfgqODDDTEouNFAIgTcdOq0XKzKPuzP4bwYWDIoJ4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rftpe5b0Fdnz1EltSehFe8BN7cgVC7pKD87ZP3p2GqpnQ15RSnf0iIaFiPowetGYWwQmdiGcrYiMucTvQOQ2luF+lCY8q+z9lE5zd7jUOeBtDeICHNf8S8A6+flp1h1WraDvFLmUVd9Hd3vlabl1t7c1II5DTMzYqmhTpo7NIbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHiSnUAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHiSnUAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949C51F00898;
	Wed, 30 Sep 2026 17:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788143;
	bh=QTpOM8bRKWjGpNAu7mqwbvPPHv1B5YmJKxfrsj3WgWM=;
	h=From:To:Cc:Subject:Date;
	b=KHiSnUARPJ7izEvKNOx3YIYoUWm4jFkqRGesF/7ZMh+amKzpYqK/s3IxL5KM+B+z1
	 bfxZX8w3SMvzssCxtMw6MfwvQTQcW2OAbNGeZ87YSdzkvTTbPWh6bFSgzGbktbC0K7
	 G2UHnVp1a+YC30dEOdMPqRCeYCcFj/tu+bN6YPdI=
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
Subject: [PATCH 6.12 000/877] 6.12.112-rc1 review
Date: Wed, 30 Sep 2026 17:15:11 +0200
Message-ID: <20260930152414.738996857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.112-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.112-rc1
X-KernelTest-Deadline: 2026-10-02T15:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.112 release.
There are 877 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.112-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.112-rc1

Longlong Xia <xialonglong@kylinos.cn>
    mm/hugetlb: keep max_huge_pages when dissolving surplus folios

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Reject key-less BTF for hash maps

Pei Xiao <xiaopei01@kylinos.cn>
    usb: dwc3: gadget: Fix use-after-free in dwc3_gadget_free_endpoints due to race condition

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Fix LPS0 and debugfs leaks when STB init fails

Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
    mtd: rawnand: pl353: Fix debug prints

Steven Rostedt <rostedt@goodmis.org>
    tracing: Move d_max_latency out of CONFIG_FSNOTIFY protection

Ben Hutchings <benh@debian.org>
    bootconfig: Fix negative seeks on 32-bit with LFS enabled

Christoph Hellwig <hch@lst.de>
    nvme: revert the cross-controller atomic write size validation

Lin.Cao <lincao12@amd.com>
    drm/amdgpu: fix ring timeout issue in gfx10 sr-iov environment

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: don't free fd-owned sockets when reaping in the heartbeat

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: clear neighbour pointer in rose_kill_by_device()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: cancel neighbour timers in rose_neigh_put() before freeing

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: drop CALL_REQUEST in loopback timer when device is not running

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: release netdev ref and destroy orphaned incoming sockets

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: fix netdev double-hold in rose_make_new()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: disconnect orphaned STATE_2 sockets when device is gone

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: fix notifier unregistered too early in rose_exit()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: fix netdev double-hold in rose_rx_call_request()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: guard rose_neigh_put() against NULL in timer expiry

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: clear neighbour pointer after rose_neigh_put() in state machines

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: fix race between loopback timer and module removal

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: hold loopback neighbour reference across timer callback

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: fix dev_put() leak in rose_loopback_timer()

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Serialize IMSIC attributes with vCPU migration

Jiakai Xu <jiakaipeanut@gmail.com>
    RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Update event constraints and cache_extra_regsfor ADL

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove incorrect LionCove PEBS data-source constraints

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Update event constraints and cache_extra_regsfor LNL

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Do cache maintenance on the source VM during intra-host migration

Zheyun Shen <szy0127@sjtu.edu.cn>
    KVM: SVM: Flush cache only on CPUs running SEV guest

Guangshuo Li <lgs201920130244@gmail.com>
    net: ena: fix MMIO read buffer leak on probe failure

Dr. David Alan Gilbert <linux@treblig.org>
    net: ena: Remove autopolling mode

Yuqi Xu <xuyuqiabc@gmail.com>
    net: ipconfig: bound DHCP option construction

Thorsten Blum <thorsten.blum@linux.dev>
    net: ipconfig: Remove outdated comment and indent code block

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: avoid modifying shared unconfirmed ct entry

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: fix helper UAF due to extensions realloc

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: unregister DualPoint Stick input device on remove

Bastien Nocera <hadess@hadess.net>
    HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM

Willem de Bruijn <willemb@google.com>
    packet: use ubuf_info completion for TX_RING packets

Liz Fong-Jones <lizf@honeycomb.io>
    PCI: Fix BAR resize for devices on a root bus

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix Resizable BAR restore order

Christian Brauner <brauner@kernel.org>
    super: make iterate_supers_type() deletion-safe

Longlong Xia <xialonglong@kylinos.cn>
    mm/hugetlb: do not dissolve gigantic pages without runtime support

Usama Arif <usamaarif642@gmail.com>
    mm/hugetlb: create hstate_is_gigantic_no_runtime helper

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix surplus pages in dissolve_free_huge_page()

SJ Park <sj@kernel.org>
    mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()

Matthew Auld <matthew.auld@intel.com>
    drm/xe/vm: nuke PTs only after unlinking contested VMAs

Jinjiang Tu <tujinjiang@huawei.com>
    mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/rmap: allocate anon_vma_chain objects unlocked when possible

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix configuring FEC for a disconnected stream

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mst: add mst sub-struct to struct intel_dp

shechenglong <shechenglong@xfusion.com>
    drm/client: fix restore of partially initialized client

Thomas Zimmermann <tzimmermann@suse.de>
    drm/client: Pass force parameter to client restore

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    i2c: qcom-geni: Fix hardcoded clock index in SE_GENI_CLK_SEL

Myeonghun Pak <mhun512@gmail.com>
    bna: prevent IOC timer rearm during teardown

Fan Wu <wufan@kernel.org>
    ipe: fix use-after-free when auditing a newly loaded policy

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: cdev: fix kernel stack leak to user-space in error path

Xiang Mei <xmei5@asu.edu>
    vlan: require the MAC header to be present in __vlan_insert_inner_tag()

Fuad Tabba <fuad.tabba@linux.dev>
    arm64/boot: Disable trapping of PMZR_EL0 writes to EL2

April Cardenas <april.cardenas@canonical.com>
    smb/client: send lease break ACKs thru correct session for multiuser mounts

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix reparse buffer bounds in cifs_query_reparse_point()

Mike Lothian <mike@fireburn.co.uk>
    drm/amdgpu: hold a runtime PM reference for P2P dma-buf attachments

Yunxiang Li <Yunxiang.Li@amd.com>
    drm: add drm_memory_stats_is_zero

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()

Chengjun Yao <Chengjun.Yao@amd.com>
    drm/amdgpu: fix rmmio iounmap skipped on device removal

Christian König <christian.koenig@amd.com>
    drm/amdgpu: use GFP_NOWAIT for memory allocations

Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
    drm/amdgpu/umsch: remove vpe test from umsch

Christian König <christian.koenig@amd.com>
    drm/amdgpu: set the VM pointer to NULL in amdgpu_job_prepare

Andrew Martin <Andrew.Martin@amd.com>
    drm/amdgpu: Failed to check various return code

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: fix use-after-free of iface in cifs_try_adding_channels()

Bharath SM <bharathsm@microsoft.com>
    smb: mark the new channel addition log as informational log with cifs_info

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mac80211: refuse to make a monitor active when it has no queue

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: track MU-MIMO configuration on disabled interfaces

Daehyeon Ko <4ncienth@gmail.com>
    wifi: libipw: reject TKIP frames without a full MIC

Saim Shujah <saimzst@gmail.com>
    drm/msm/dpu: clear pending peripheral flush state

Yibo Tan <lhfff@tju.edu.cn>
    hwmon: (pwm-fan) Stop RPM timer before freeing tach data

Fan Wu <fanwu01@zju.edu.cn>
    wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Runyu Xiao <runyu.xiao@seu.edu.cn>
    Input: hp_sdc - shut down kicker timer on module exit

Arun Easi <aeasi@cisco.com>
    scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU

Liu Zhenlong <dragonliu2018@gmail.com>
    i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    i2c: qcom-cci: Remove the unused variable cci_clk_rate

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    i2c: qcom-cci: Stop complaining about DT set clock rate

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix LSE operations on {8,16}-bit types

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Use load LSE atomics for the non-return per-CPU atomic operations

Hongling Zeng <zenghongling@kylinos.cn>
    btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()

Ahmed Naseef <naseefkm@gmail.com>
    net: phy: mediatek: do not report link and per-speed LED rules together

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    swiotlb: use the adjusted address for the highmem page lookup

Xiang Mei <xmei5@asu.edu>
    ALSA: usb-audio: Clamp implicit feedback packet count to URB capacity

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Avoid long delay in atomic context

David Howells <dhowells@redhat.com>
    9p: Fix v9fs_issue_write() to update i_size and remote_i_size

David Howells <dhowells@redhat.com>
    cifs: Fix specification of function pointers

Darrick J. Wong <djwong@kernel.org>
    xfs: fix backwards mergeability logic in refcount scrubber

Darrick J. Wong <djwong@kernel.org>
    xfs: fix under-reservation of blocks when repairing sf directories

Christoph Hellwig <hch@lst.de>
    xfs: remove the i_ino field in struct xfs_inode

Darrick J. Wong <djwong@kernel.org>
    xfs: strengthen the "is cow staging" helpers in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: fix short ifork reaping computation in xreap_bmapi_binval

Darrick J. Wong <djwong@kernel.org>
    xfs: report healthy filesystem events in scrub stats

Bjoern Doebel <doebel@amazon.de>
    smb: client: fail DACL rewrite when the new DACL exceeds 64K

Ralph Boehme <slow@samba.org>
    smb/client: fix security flag calculation when setting security descriptors

Ralph Boehme <slow@samba.org>
    smb: client: refactor ACL setting control flow in id_mode_to_cifs_acl()

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent race between disconnect() and rtx

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not reschedule the RTX timer for fallback sockets

Eric Dumazet <edumazet@google.com>
    tcp: introduce icsk->icsk_keepalive_timer

Kalpan Jani <kalpan.jani@mpiricsoftware.com>
    mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: rename add_entry structure to add_addr

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: use for_each_subflow helper

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset retrans_time when ADD_ADDR entry is reused

Joe Damato <joe@dama.to>
    bnxt_en: Don't free the live ring's TPA state on queue restart failure

Will Chen <will.chen.tty@gmail.com>
    bnxt: fix memory leak in bnxt_queue_mem_alloc error cases

Pavel Begunkov <asml.silence@gmail.com>
    eth: bnxt: store rx buffer size per queue

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: userspace: fix address ID overflow

Geliang Tang <geliang@kernel.org>
    mptcp: use sock_kmemdup for address entry

Geliang Tang <geliang@kernel.org>
    sock: add sock_kmemdup helper

Geliang Tang <geliang@kernel.org>
    mptcp: pm: drop match in userspace_pm_append_new_local_addr

Joe Damato <joe@dama.to>
    bnxt_en: Propagate TPA buffer allocation failures in bnxt_queue_mem_alloc()

Mina Almasry <almasrymina@google.com>
    page_pool: disable sync for cpu for dmabuf memory provider

Mina Almasry <almasrymina@google.com>
    net: page_pool: rename page_pool_alloc_netmem to *_netmems

Alexander Lobakin <aleksander.lobakin@intel.com>
    netmem: add a couple of page helper wrappers

Norbert Szetei <norbert@doyensec.com>
    landlock: Fix use-after-free of the source's parent directory

Günther Noack <gnoack3000@gmail.com>
    landlock: Clarify documentation for the IOCTL access right

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: flowlabel: cap duplicate leases per socket

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Move ipv6_fl_list from ipv6_pinfo to inet_sock.

Eric Dumazet <edumazet@google.com>
    ipv6: reorganise struct ipv6_pinfo

Eric Dumazet <edumazet@google.com>
    ipv6: make ipv6_pinfo.saddr_cache a boolean

Eric Dumazet <edumazet@google.com>
    ipv4: remove fib_info_devhash[]

Eric Dumazet <edumazet@google.com>
    ipv4: use rcu in ip_fib_check_default()

Eric Dumazet <edumazet@google.com>
    ipv4: remove fib_devindex_hashfn()

Myeonghun Pak <mhun512@gmail.com>
    idpf: disable DIM work before freeing q_vectors

Pavan Kumar Linga <pavan.kumar.linga@intel.com>
    idpf: introduce idpf_q_vec_rsrc struct and move vector resources to it

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    idpf: Fix kernel-doc descriptions to avoid warnings

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: add sysfs feature entry for xattr prefixes

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: macb: initialize PTP state before registering clock

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: unify device pointer naming convention

Kevin Hao <haokexin@gmail.com>
    net: macb: Use netif_napi_add_tx() instead of netif_napi_add() for TX NAPI

Kevin Hao <haokexin@gmail.com>
    net: macb: Replace open-coded implementation with napi_schedule()

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: cttimeout: prevent UAF during module unload

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Flush LSC untyped L1 dataport cache after rcs/ccs batches

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: use option bits for CFM/MRP frame handlers

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix integer overflow in initrd size check

Gabriel Krisman Bertazi <krisman@suse.de>
    io_uring/net: don't overconsume buffers when using MSG_TRUNC

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: end write accounting from ->ki_complete

Leonardo Costa <leonardo.costa@toradex.com>
    drm/bridge: tc358768: Enforce input bus flags via atomic_check

XingWang Xiang <v3rdant.xiang@gmail.com>
    genetlink: pin family module during policy dump

Dinh Nguyen <dinguyen@kernel.org>
    EDAC/altera: Use parent device for devres in altr_portb_setup()

Rounak Das <rounakdas2025@gmail.com>
    EDAC/altera: Use ECC manager compatible to select A10/S10 IRQ layout

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Undo the registration when enabling the histogram trigger fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Take the reference before publishing the named histogram trigger

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening a tracer options file

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tools/bootconfig: Fix integer overflow and truncation in size checks

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tools/bootconfig: Cleanup bootconfig footer size calculations

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_mmio: disable IRQ wake before free_irq

Viresh Kumar <viresh.kumar@linaro.org>
    virtio-mmio: Remove virtqueue list from mmio device

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Set the trace clock before registering the histogram trigger

Steven Rostedt <rostedt@goodmis.org>
    tracing: Merge struct event_trigger_ops into struct event_command

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove get_trigger_ops() and add count_func() from trigger ops

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tracing: Constify struct event_trigger_ops

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: unhash the dentry before dropping the item in rmdir

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    reboot: fix cad_pid use-after-free race

Oleg Nesterov <oleg@redhat.com>
    sysctl: move the "cad_pid" entry from pid_table[] to kern_reboot_table[]

Zihan Xi <zihanx@nebusec.ai>
    ipmr: account multicast table and route memory

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from a "STACKTRACE" histogram key

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: pin the symlink target's dirent instead of chasing ->ci_dentry

Al Viro <viro@zeniv.linux.org.uk>
    configfs:get_target() - release path as soon as we grab configfs_item reference

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve framebuffer-size validation

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: sysfb: Move bpp-depth calculation into screen_info helper

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve stride validation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve panel-size validation

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Set gpuvm min page size to 4K on dcn35/36

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp/r535: Add scanline position support + head state support

Bob Zhou <bobzhou2@amd.com>
    drm/amdgpu: avoid force-completing uninitialized UVD rings

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: plumb timedout fence through to force completion

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add a helper to calculate ring distance

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix missing unwind in amdgpu_ib_schedule() error path

Daeho Jeong <daehojeong@google.com>
    f2fs: accurately adjust free_sections during free_segment_range

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty flag on folio in error path

Matthew Wilcox (Oracle) <willy@infradead.org>
    f2fs: Convert clear_node_page_dirty() to clear_node_folio_dirty()

Chao Yu <chao@kernel.org>
    f2fs: embed f2fs_gc_kthread in f2fs_sb_info

Guanghui Yang <3497809730@qq.com>
    f2fs: fix dentry folio leak in find_in_level

Wenjie Qi <qwjhust@gmail.com>
    f2fs: limit recovery filename logging to stored length

Joanne Chang <joannechien@google.com>
    f2fs: dirty directory inodes on mtime/ctime update

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential section-unaligned pinfile

wangzijie <wangzijie1@honor.com>
    f2fs: don't allow unaligned truncation to smaller/equal size on pinned file

wangzijie <wangzijie1@honor.com>
    f2fs: convert F2FS_I_SB to sbi in f2fs_setattr()

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate MOVE_RANGE destination size

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip vport under deletion in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Add timeout while stop_streaming

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Disallow EFER.LME and EFER.LMA if long mode is not supported

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize data structures for inject_pfault_token

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: rkvdec: Propagate platform_get_irq() errors

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: imx355: Avoid calling imx355_power_off twice in error path

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx355: Replace client->dev usage

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Check EFER validity on KVM_SET_SREGS*

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move the bulk of register specific code from x86.c to regs.c

Sean Christopherson <seanjc@google.com>
    KVM: x86: Rename __{g,s}et_sregs2() => kvm_vcpu_ioctl_x86_{g,s}et_sregs2()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Extract REGS and SREGS runtime sync code to helpers

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Split kvm_mmu_zap_all_fast() into "front" and "back" halves

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Dynamically allocate shadow MMU's hashed page list

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Fix the MIXER enable default value

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: tegra210_mixer: sort the register default table

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: Fix test_ctl_hi field for DEFAULT_EVO PLLs

Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
    mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses

Andrea Scian <andrea.scian@dave.eu>
    mtd: rawnand: pl353: Add message about ECC mode

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: refcount requests for token lifetime

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: use READ_ONCE()/WRITE_ONCE() for wait flags

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: always wake -ENOSPC waiters

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: stop allocating child flush bio

Li Chen <me@linux.beauty>
    nvdimm: pmem: keep PREFLUSH before data writes

Li Chen <me@linux.beauty>
    nvdimm: preserve flush callback -ENOMEM

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects

Chao Shi <coshi036@gmail.com>
    nvme: skip the zoned limits update if the zone info query failed

Christoph Hellwig <hch@lst.de>
    nvme: fix atomic write size validation

Christoph Hellwig <hch@lst.de>
    nvme: refactor the atomic write unit detection

Alan Adamson <alan.adamson@oracle.com>
    nvme: all namespaces in a subsystem must adhere to a common atomic write size

Tristan Madani <tristan@talencesecurity.com>
    nvme: add missing SRCU grace period in error path

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Allow splice reads on static buffers

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Show persistent buffer dropped events in trace_pipe file

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities

Yabin Cui <yabinc@google.com>
    perf/aux: Allocate non-contiguous AUX pages by default

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Provide rt_mutex_.*_schedule() equivalents for futex scheduling

Marco Elver <elver@google.com>
    compiler_types: Move lock checking attributes to compiler-context-analysis.h

Baineng Shou <shoubaineng@gmail.com>
    dma-buf: dma-heap: don't publish fd before copy_to_user() succeeds

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Take trace_array reference before accessing its ftrace_ops

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening options file

Steven Rostedt <rostedt@goodmis.org>
    tracing: Clean up use of trace_create_maxlat_file()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/secretmem: properly account locked pages

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix BTF kflag check for anonymous struct member access

Steven Rostedt <rostedt@goodmis.org>
    Documentation: tracing: Add documentation about eprobes

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix anon_stack check for unnamed bitfields in btf_find_struct_member

Muhammad Bilal <meatuni001@gmail.com>
    staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()

Vivek BalachandharTN <vivek.balachandhar@gmail.com>
    staging: rtl8723bs: fix spacing around operators

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()

Myeonghun Pak <mhun512@gmail.com>
    usb: storage: realtek_cr: fix use-after-free on disconnect

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix wakeup from S3 after controller context loss

Théo Lebrun <theo.lebrun@bootlin.com>
    usb: cdns3: rename hibernated argument of role->resume() to lost_power

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Cleanup Candence controller PCI device and vendor ID usage

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix debug accessory mode detection for sink ports

Yuhang.chen <yhchen312@gmail.com>
    wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Hide some errors when the device is unplugged

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: cleanup unused rtwdev::roc_work

Elson Serrao <elson.serrao@oss.qualcomm.com>
    usb: dwc3: clear forceRM when issuing EndTransfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reinitiate stream for all host NoStream behavior

Jan Kara <jack@suse.cz>
    udf: Fix data loss when converting inline inodes to out of line

Jan Kara <jack@suse.cz>
    udf: Move udf_map_block() up

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix use-after-free of master->this

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7915: set correct background radar capability

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Do not treat master device as a duplicate target

Can Peng <pengcan@kylinos.cn>
    hwrng: stm32 - Fix runtime PM cleanup on registration failure

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    hwrng: drivers - Switch back to struct platform_driver::remove()

Xu Rao <raoxu@uniontech.com>
    ALSA: hda/ext: preserve PPLCCTL bits when clearing reset

Glenn Judd <gmj@meta.com>
    net/mlx5e: do not HW-GRO coalesce small frames

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Always calculate page size

Hidayath Khan <hidayath@linux.ibm.com>
    net/smc: stop killed, freed and out_of_sync sharing a byte

Simon Horman <horms@kernel.org>
    net/smc: Address spelling errors

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: qcom_battmgr: fix use-after-free

Hui Su <sh_def@163.com>
    io_uring/waitid: avoid siginfo copy during ring teardown

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: have io_waitid_complete() remove wait queue entry

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Propagate SMU errors and validate S2D address

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Restore msg_port on amd_stb_s2d_init() error paths

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmc: Define enum for S2D/PMC msg_port and add helper function

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmc: Move STB functionality to a new file for better code organization

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmc: Move STB block into amd_pmc_s2d_init()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    platform/x86: int1092: Fix potential memory leak in sar_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: intel_sar: Check ACPI_HANDLE() against NULL

Thorsten Blum <thorsten.blum@linux.dev>
    platform/x86: think-lmi: Fix certificate thumbprint sysfs output

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: improve check if BIOS account security enabled

Thorsten Blum <thorsten.blum@linux.dev>
    platform/x86: think-lmi: Fix current password length check

Farhan Ali <alifm@linux.ibm.com>
    PCI: Allow per function PCI slots to fix slot reset on s390

Farhan Ali <alifm@linux.ibm.com>
    PCI: Introduce PCI_SLOT_PLACEHOLDER constant for slot_nr placeholder value

Fan Wu <fanwu01@zju.edu.cn>
    mmc: via-sdmmc: cancel card-detect work on remove

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate max level for set feature

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Check for admin capability for write commands

Peiyang He <peiyang_he@smail.nju.edu.cn>
    iommufd: Fix UAF in selftest IOPF reporting

Yi Liu <yi.l.liu@intel.com>
    iommufd: Pass @pasid through the device attach/replace path

Weimin Xiong <xiongwm2026@163.com>
    iommu/msm: Unwind probe state on registration failure

Zhang Heng <zhangheng@kylinos.cn>
    iommu/msm: Use helper function devm_clk_get_prepared()

Ali Tariq <alitariq45892@gmail.com>
    PCI: starfive: Fix resource leaks on error paths in host_init()

Hal Feng <hal.feng@starfivetech.com>
    PCI: starfive: Use regulator APIs to control the 3v3 power supply of PCIe slots

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: ab8500_fg: fix use-after-free on remove

Pan Chuang <panchuang@vivo.com>
    power: supply: ab8500_fg: Remove redundant dev_err()/dev_err_probe()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: qcom: pas: Guard dtb metadata release with dtb_pas_id check

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: pas: Replace metadata context with PAS context structure

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom_scm: Rename peripheral as pas_id

Oscar Ou <oscarou@synology.com>
    lockd: fix swapped arguments in nlmsvc_match_ip()

Ruoyu Wang <ruoyuw560@gmail.com>
    i2c: mxs: fix DMA channel leak on probe error

Bence Csókás <csokas.bence@prolan.hu>
    dmaengine: Add devm_dma_request_chan()

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Make cpu_buffer::free_page a buffer_data_read_page

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    ASoC: codecs: aw88261: only check PLL and clock state at power-up

Val Packett <val@packett.cool>
    ASoC: codecs: aw88261: reduce log spam

Tejun Heo <tj@kernel.org>
    sched/core: Make core-sched flips wait for in-flight selections

John Stultz <jstultz@google.com>
    sched: Rework prev_balance() to avoid stale prev references

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Fix subbuf resize race with ring_buffer_alloc_read_page()

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Add helper functions for allocations

James Clark <james.clark@linaro.org>
    perf test: Change all remaining #!/bin/sh to #!/bin/bash

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix silent data drop under pipe back-pressure

Darrick J. Wong <djwong@kernel.org>
    xfs: fix blockgc group quota scanning when usrquota isn't enforced

Darrick J. Wong <djwong@kernel.org>
    xfs: drop dquot flush lock when we can't find a buffer to flush

Darrick J. Wong <djwong@kernel.org>
    xfs: check di_forkoff correctly in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: don't call xfs_exchange_range_finish for a dry run

Darrick J. Wong <djwong@kernel.org>
    xfs: check padding field in xfs_ioc_commit_range

Darrick J. Wong <djwong@kernel.org>
    xfs: use correct jiffies comparison function in xchk_maybe_relax

Darrick J. Wong <djwong@kernel.org>
    xfs: release orphanage dir inode if chown fails

Darrick J. Wong <djwong@kernel.org>
    xfs: fix attr fork block count checks in xrep_inode_blockcounts

Darrick J. Wong <djwong@kernel.org>
    xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption

Zihan Xi <zihanx@nebusec.ai>
    smb: client: validate POSIX create context length

Zihan Xi <zihanx@nebusec.ai>
    smb: client: clean up failed cached directory opens

Zihan Xi <zihanx@nebusec.ai>
    smb: client: fix create context out-of-bounds reads

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: fix NULL dereference of dlc->session in RFCOMM_CONNINFO

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: mgmt: fix race in read_unconf_index_list()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: L2CAP: validate frame length before control and FCS access

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: ISO: balance the parent hold in hci_bind_bis()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: reject out-of-range OCF values

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: validate event length before filtering

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_conn: fix CIS hold ownership on reuse

Tan Chi <tanchi25@mails.ucas.ac.cn>
    RISC-V: KVM: Fix HSM hart status error propagation

Myeonghun Pak <mhun512@gmail.com>
    RISC-V: KVM: Synchronize hrtimer callback during teardown

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    KVM: arm64: Fix spurious warning for benign stage 2 teardown race

Zeng Chi <zengchi@kylinos.cn>
    KVM: Don't treat reserved xarray entries as having memory attributes

David Ballesteros <davimaba.v@proton.me>
    KVM: Ensure memory attributes xarray nodes are accounted to the caller's memcg

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix KVM GISC and page leak when queue removed from host config

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cmf: Fix virtual vs physical address confusion

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()

Ilya Titov <ilya.titov@wirenboard.com>
    pinctrl: sunxi: keep a shadow copy of the data register output latches

Myeonghun Pak <mhun512@gmail.com>
    pinctrl: single: free the IRQ on domain creation failure

Puranjay Mohan <puranjay@kernel.org>
    perf/core: Run sched_task() for PMUs with only CPU-wide events

Puranjay Mohan <puranjay@kernel.org>
    perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi_tcp: Check the data direction of a Data-In PDU

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: port100: reject frames whose declared length exceeds the received data

Aamir Ahmed <elb12345@hotmail.co.uk>
    nfc: llcp: drop truncated I/RR/RNR PDUs in nfc_llcp_recv_hdlc()

Luxiao Xu <rakukuip@gmail.com>
    nfc: fix use-after-free in nfc_get_local_general_bytes

Aohan Mei <henrymei@tencent.com>
    netfilter: nf_tables: skip expired catchall elements on insert and delete

Luxiao Xu <rakukuip@gmail.com>
    netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read

Weiming Shi <bestswngs@gmail.com>
    netfilter: ip6t_rpfilter: reject routes without inet6_dev

Wentao Liang <vulab@iscas.ac.cn>
    net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()

Ming Wang <wangming01@loongson.cn>
    net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist

Fourie Zhang <littleddfu@gmail.com>
    net: bridge: mdb: restart port group walk after deletion

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1e: fix soft lockup on out-of-range hw_next_to_clean read

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1c: fix soft lockup on out-of-range tpd_cons read

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: fix helper UAF due to extensions realloc

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: remove 'add_helper' dead code

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry

Wentao Liang <vulab@iscas.ac.cn>
    net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1: fix soft lockup on out-of-range cmb_tpd_next_to_clean read

Zijie Huang <milkory@outlook.com>
    net: arp: terminate device name before lookup

Weiming Shi <bestswngs@gmail.com>
    net/sched: reject IDR error pointers when deleting actions

Ralf Lici <ralf@mandelbit.com>
    net/mlx5e: advertise MACsec offload only when supported

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()

Wei Jie LAW <98lawweijie@gmail.com>
    HID: wacom: fix OOB read in wacom_wac_pen_serial_enforce()

Junjie Cao <junjie.cao@intel.com>
    HID: quirks: add ALWAYS_POLL quirk for SDINNOVATION gaming keyboard

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: fix use-after-free on input2 registration failure

Angel J <iamanaws@httpd.dev>
    PCI: of_property: Omit bus properties without a subordinate bus

Jaewook You <jaewook376@gmail.com>
    mm/hugetlb: preserve mremap address delta when skipping page tables

Karl Mehltretter <kmehltretter@gmail.com>
    gpio: tps65219: Fix GPIO input value reads

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/virtio: fix NULL pointer dereference on fence allocation failure

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/virtio: fix memory leak of fence event on execbuffer failure

Szymon Acedański <accek@invisiblethingslab.com>
    drm/xe: Limit sg segment size to PAGE_SIZE on Xen PV

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: don't bump pin count on failed re-pin in nouveau_bo_pin_locked()

Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
    drm/nouveau: RCU-free the scheduler-containing nouveau_sched

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix runtime PM leak in nouveau_connector_detect()

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix gem reference leak in validate_init()

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: fix double-free in nvif_vmm_dtor

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix bridge reference leak in nv1a_ram_new()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/nouveau: fix autosuspend cleanup during teardown

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau/uvmm: fix UAF in nouveau_uvmm_sm when BO is in TTM_PL_SYSTEM

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Bump frame warning limit for clang builds of dml

Wentao Liang <vulab@iscas.ac.cn>
    drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/i915: fix incorrect RCU teardown order

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Fix page count for page table for map() interface

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Propagate map failures correctly from pvr_mmu_map_sgl()

Dongliang Qin <cccccccccccc777777@gmail.com>
    rds: ib: Clear the sg list when mapping an MR fails

Hui Peng <benquike@gmail.com>
    mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()

Zixuan Chai <petalzu987@gmail.com>
    llc: reserve device headroom for allocated frames

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: zynq: fix runtime PM leak on request error path

Wentao Liang <vulab@iscas.ac.cn>
    gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()

Hui Peng <benquike@gmail.com>
    ipv6: sr: enforce exact attribute length for SEG6_ATTR_DST

Norbert Szetei <norbert@doyensec.com>
    ipv6: do not let ipv6_find_hdr() return an offset past the packet end

Fan Wu <wufan@kernel.org>
    ipe: protect the dm-verity root hash with RCU

Wentao Liang <vulab@iscas.ac.cn>
    fsl/fman: Fix clk reference leak in read_dts_node()

Josef Bacik <josef@toxicpanda.com>
    writeback: report a Tasks-RCU quiescent state per cgwb drain pass

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in flush dependency check

Patrick Lu (Anthropic) <perf.patrick.lu@gmail.com>
    writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes

Christian Brauner <brauner@kernel.org>
    fs/ntfs3: use d_instantiate_new() in ntfs_create_inode() and murder syzbot's "WARNING in do_new_mount" saga

Hui Peng <benquike@gmail.com>
    fou: reject omitted FOU_ATTR_IPPROTO on FOU_ENCAP_DIRECT

Guopeng Zhang <zhangguopeng@kylinos.cn>
    cgroup/pids: Restore pids.events notifications in local mode

Matthias Goergens <matthias.goergens@gmail.com>
    ata: libata-scsi: bound the ATA passthru sense descriptor writes

Dairui Zhang <zhangdairui@gmail.com>
    af_packet: fix integer overflow in prb_calc_retire_blk_tmo()

Aohan Mei <henrymei@tencent.com>
    sctp: discard the rest of the packet on a stale-cookie error

Willem de Bruijn <willemb@google.com>
    tcp: prevent collapsing skbs across boundary in rtx queue

Eric Dumazet <edumazet@google.com>
    tipc: reject invalid and unexpected GRP_ACK_MSG to prevent bc_ackers underflow

Willem de Bruijn <willemb@google.com>
    virtio_net: copy zerocopy frags in start_xmit without NAPI

Mario Limonciello <mario.limonciello@amd.com>
    x86/PCI: Disable enhanced atomics on AMD NBIO 7.7 and 7.11

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/mce: Fix hardware debug register corruption on task migration

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

Pablo Neira Ayuso <pablo@netfilter.org>
    rculist: add list_splice_rcu() for private lists

Mark Amirkan <markdamirkan@gmail.com>
    mptcp: return sk_wait_data() errors from recvmsg()

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Make @data a mandatory param for intel_guest_get_msrs()

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Don't pointlessly context switch DS_AREA (and PEBS config) if PEBS is unused

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Don't write PEBS_ENABLED on host<=>guest xfers if CPU has PEBS isolation, to fix stuck PEBS_ENABLED

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Ensure KVM guest PEBS path doesn't set unwanted PERF_GLOBAL_CTRL bits

Hui Peng <benquike@gmail.com>
    autofs: fix sbi->pipe file reference leak in autofs_kill_sb()

Eric Dumazet <edumazet@google.com>
    vlan: ensure sufficient headroom in vlan_dev_hard_header()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_teql: fix shadowed err in __teql_resolve()

Eric Dumazet <edumazet@google.com>
    bridge: check llc_mac_hdr_init() return value in br_send_bpdu()

Eric Dumazet <edumazet@google.com>
    llc: fix skb UAF and leaks on llc_mac_hdr_init() failure

Coia Prant <coiaprant@gmail.com>
    net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails

Ginger Li <ginger.jzllee@gmail.com>
    tipc: Fix a data race on mon->peer_cnt in mon_timeout()

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix UAF on lgr list traversal in smcr_port_err()

Sang-Hoon Choi <csh0052@gmail.com>
    nfp: hold IPsec RX state under the XArray lock

Yilin Zhang <yilinzhang@moonshot.ai>
    tcp: fix use-after-free of retransmit_skb_hint in tcp_send_synack()

Aleksei Sviridkin <f@lex.la>
    net: dsa: mt7530: fix NULL dereference on unbind of MT7531 and MT7621

Haseeb Malik <haseebulhaq55@gmail.com>
    macsec: initialize SecY before registering the netdevice

Sabrina Dubroca <sd@queasysnail.net>
    macsec: inherit lower device's TSO limits when offloading

Sabrina Dubroca <sd@queasysnail.net>
    macsec: add some of the lower device's features when offloading

David Dai <zdai@linux.ibm.com>
    bonding: crypto offload enabled, non-offload slave failover, rekey failed

Pengpeng Hou <hppiscas@163.com>
    drm/imagination: clamp freelist reconstruction requests

Norbert Szetei <norbert@doyensec.com>
    net: xps: reject an out of range traffic class

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ip_gre: Reject enabling collect metadata through changelink

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: mask DMA_TIMEOUT_MASK when reading DMA_RING0_TIMEOUT

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: do not skip WoL power up on GENET V1

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: allow return of power up status

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: move bcmgenet_power_up into resume_noirq

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: initialize u64 stats seq counter for all queues

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: fix 64-bit RTNL stats reading in ethtool on 32-bit systems

Ivan Delalande <colona@arista.com>
    tg3: use random MAC address when tg3_get_device_address fails

Dragan Simic <dsimic@manjaro.org>
    driver core: Add device probe log helper dev_warn_probe()

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf: Fix BSWAP 32 and 16 on MIPS64

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf: Fix immediate JMP JEQ/JNE on MIPS32

Ido Schimmel <idosch@nvidia.com>
    vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets

Shihuang Liu <shlomojune6@gmail.com>
    net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()

Jakub Kicinski <kuba@kernel.org>
    veth: manage XDP program pointers during channel resize

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_gate: budget the per-entry list in get_fill_size

Deepanshu Kartikey <kartikey406@gmail.com>
    nfc: pn533: fix OOB read in pn533_acr122_is_rx_frame_valid()

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix slab-out-of-bounds reads when logging service names

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix -ENOMEM on connect with zero-length service name

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: st21nfca: validate ISO15693 inventory length

Cong Nguyen <congnt264@gmail.com>
    nfc: llcp: fix sdreq TLV list leak on parse/alloc/send failure

Chris Gellermann <christian.gellermann@codasip.com>
    nfc: virtual_ncidev: Add missing ioctl compat handler

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/nci: Fix out-of-bounds store on thread join

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    selftests: nci: Fix uninitialized family ID on missing attribute

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix race condition in accept_queue lifecycle

Lei Zhu <zhulei@kylinos.cn>
    selftests: nci: Correct pthread_create return value check

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfc: llcp: Fix list corruption / refcount desync in nfc_llcp_recv_dm()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: st21nfca: validate received frame size

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: nfcmrvl: validate helper command length before pull

Weiming Shi <bestswngs@gmail.com>
    bpf: Reject dev-bound-only programs on other devices

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac4: Use the correct bufzise when the len is exactly 8K

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Capture all packets for vlan checks

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Check the dev->features for S-TAG offload testing

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Support running selftests on DSA conduits

Xin Long <lucien.xin@gmail.com>
    sctp: hold asoc or transport before mod_timer() in timer handlers

Bernardo Soares <bsoares.it@gmail.com>
    net/mlx5: Bridge, don't fail unlink of untracked/unsupported peer ports

Bernardo Soares <bsoares.it@gmail.com>
    net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports

Zhao Gongyi <zhaogongyi@BYTEDANCE.COM>
    bpf, sockmap: Reject max_entries > INT_MAX in sock_map_alloc

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix bpf_sock context code generation

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix bounds check for skb-backed dynptrs

Manaf Meethalavalappu Pallikunhi <manaf.pallikunhi@oss.qualcomm.com>
    thermal: gov_step_wise: Fix stale mitigation vote with non-zero lower bounds

Coia Prant <coiaprant@gmail.com>
    net: pcs: xpcs: fix clock reference leak on xpcs_init_clks failure

Jakub Kicinski <kuba@kernel.org>
    genetlink: report the real command id for dump-only ops in policy dumps

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Fix NULL pointer dereference in debug_info_copy()

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Do not register views for failed static debug areas

Nemesa Garg <nemesa.garg@intel.com>
    drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Add new SU area calculation helper to apply workarounds

Myeonghun Pak <mhun512@gmail.com>
    tg3: clean up PHYLIB resources on probe failure

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Fix dst leak for uncached routes.

Pengpeng Hou <hppiscas@163.com>
    net: usb: sr9700: include receive overhead in the length check

Ivan Vecera <ivecera@redhat.com>
    dpll: use exact lookup for reference sync pin id

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix memory scaling limitation in SR-IOV mode

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: Reject short EA=0 frames in rfcomm_recv_frame()

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: validate device-supplied DMA indices

Hui Peng <benquike@gmail.com>
    Bluetooth: bnep: fix out-of-bounds reads on short RX/TX frames and control fallthrough

Li Youhong <liyouhong@kylinos.cn>
    drm/bridge: samsung-dsim: fix TE GPIO lifetime for host attach

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: release the GEM object on virtio_gpu_vram_create() errors

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leak when drm_gem_handle_create() fails

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_hfsc: bound the classify inner-filter walk with a drift budget

Yuqi Xu <xuyuqiabc@gmail.com>
    bpf: Check params size before reading reserved fields

Aamir Ahmed <elb12345@hotmail.co.uk>
    net: usb: catc: bound the RX packet length in catc_rx_done()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Bound ownership depth through local kptrs and graph roots

Yiqi Sun <sunyiqixm@gmail.com>
    sctp: avoid livelock while updating retransmit path

Alexander Duyck <alexanderduyck@fb.com>
    eth: fbnic: Set AW_FLUSH_MODE alongside AW_FLUSH when flushing the mailbox

Björn Töpel <bjorn@kernel.org>
    eth: fbnic: Handle maximum standalone channels

Kuniyuki Iwashima <kuniyu@google.com>
    ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    net: gue: reject invalid REMCSUM offsets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    net/sched: act_ct: don't WARN on benign flow_offload_alloc() failure

Giuseppe Ranieri <giuseppe@ranieri.dev>
    drm/nouveau/disp: don't reject HDMI config on cards without SCDC

Francesco Magazzu <postadelmaga@gmail.com>
    drm/nouveau/clk: don't clobber reclock status when restoring volt/fan

Dan Carpenter <error27@gmail.com>
    drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: make ocfs2_calc_xattr_init() return void

Zeng Heng <zengheng4@huawei.com>
    arm64: io: Reject non-user protection in ioremap_prot()

Naman Gulati <namangulati@google.com>
    netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name

Julian Anastasov <ja@ssi.bg>
    ipvs: revalidate ihl before icmp_send

Karl Mehltretter <kmehltretter@gmail.com>
    netfilter: nft_synproxy: use the family-aware checksum helper

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: hold nfnl mutex in event notifier

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: flowtable: publish HW_DEAD after worker is done

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Reject truncated ldimm64 CO-RE relocations

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Restrict CO-RE poisoning to relocatable instructions

Shay Drory <shayd@nvidia.com>
    net/mlx5: devcom, Base component size on linked devices

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_u32: fix manual hash table handle IDR aliasing

Weiming Shi <bestswngs@gmail.com>
    bpf: Skip unsettled links in link iterator

Zhiling Zou <zhilinz@nebusec.ai>
    xsk: Use a 32-bit compare in xsk_map_gen_lookup

Julian Sun <sunjunchao@bytedance.com>
    fs: avoid repeated scans in evict_inodes()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Guard PMCW field accesses with dnv check

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Check pmcw.dnv before pmcw.ena in I/O entry points

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Fix cio_update_schib() to not cache invalid schib

Karl Mehltretter <kmehltretter@gmail.com>
    s390/pci/docs: Fix sriov_numvfs attribute name

Niklas Schnelle <schnelle@linux.ibm.com>
    docs: s390/pci: Improve and update PCI documentation

Bart Van Assche <bvanassche@acm.org>
    scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()

Eva Kurchatova <eva.kurchatova@virtuozzo.com>
    selftests: cgroup: give the O_TMPFILE open in get_temp_fd() a mode

Sean Christopherson <seanjc@google.com>
    cgroup: selftests: Move memcontrol specific helpers out of common cgroup_util.c

Lee Jones <lee@kernel.org>
    Bluetooth: mgmt: Dequeue pending mesh_send_sync entries on cancel

Christiano Amora <christiano.amora@gmail.com>
    Bluetooth: SMP: reject Security Request over BR/EDR

ZHOU Jiaxiang <me@fxti.xyz>
    scsi: sd_zbc: Reject disks with too many zones

Ran Hongyun <ranhongyun1@huawei.com>
    squashfs: Add dictionary size range check to prevent shift-out-of-bounds

Mark Brown <broonie@kernel.org>
    KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: Return -EINVAL for an empty SMCCC filter range at base 0

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Skip unreachable devices instead of failing the save

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-its: Add stronger type-checking to the ITS entry sizes

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Free the caches when GITS_BASER changes

SeungJu Cheon <suunj1331@gmail.com>
    RISC-V: KVM: Fix perf-backed counter accounting across stop and read

SeungJu Cheon <suunj1331@gmail.com>
    RISC-V: KVM: Report snapshot write failure to the guest

SeungJu Cheon <suunj1331@gmail.com>
    RISC-V: KVM: Preserve firmware counter value across stop/start

Benjamin Tissoires <bentiss@kernel.org>
    HID: bpf: fix __hid_bpf_hw_check_params report length

Slawomir Stepien <sst@poczta.fm>
    HID: amd_sfh: Validate PCI BAR size before mapping

Sean Anderson <sanderson@brivo.com>
    pinctrl: meson: Fix typo in s4 group name

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    bpf, arm64: set up the frame pointer for the exception callback

Geliang Tang <geliang@kernel.org>
    bpf, sockmap: Fix self-redirect copied_seq double-counting

Pu Lehui <pulehui@huawei.com>
    bpf: Fix UAF due to concurrent consumption of ttrace lists in alloc_bulk

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Register dtor for freeing special fields

Hou Tao <houtao1@huawei.com>
    bpf: Factor out htab_elem_value helper()

Hou Tao <houtao1@huawei.com>
    bpf: Bail out early in __htab_map_lookup_and_delete_elem()

Hou Tao <houtao1@huawei.com>
    bpf: Remove migrate_{disable|enable} in ->map_for_each_callback

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix out-of-bounds read of rtt_min in sock_ops

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: Avoid soft lockup in __htab_map_lookup_and_delete_batch()

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Move Intel PMU global MSRs to intel_is_valid_msr()

Oscar Priego Verdugo <oscar.priegov@gmail.com>
    HID: elecom: fix bus type for M-XGL20DLBK

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: Skip cond_resched() in inet_csk_listen_stop() under BPF context

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix out-of-bounds read of sk_protocol in bpf_sock_destroy()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix divide-by-zero in btf_struct_walk()

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc

Weiming Shi <bestswngs@gmail.com>
    bpf: Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix bpf_skb_change_tail wrt csum partial skbs

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix IRQ injection with SIGP Stop and Store Status

Mostafa Saleh <smostafa@google.com>
    remoteproc: qcom_q6v5_adsp: Fix iommu_unmap() usage

Zhiling Zou <zhilinz@nebusec.ai>
    xfrm: save input state data before secpath resets

Dong Chenchen <dongchenchen2@huawei.com>
    xfrm: Fix dev use-after-free in xfrm async resumption

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Refactor xfrm_input lock to reduce contention with RSS

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Simplify chain netdev notifier

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Tolerate chains with no remaining hooks

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Add StarFighter HDA SSID

Sean Rhodes <sean@starlabs.systems>
    ALSA: hda/realtek: Limit Star Labs internal mic boost

Wenwu Hou <hwenwur@gmail.com>
    erofs: fix large folio race in erofs_fscache_req_complete

Darrick J. Wong <djwong@kernel.org>
    xfs: don't stash removename operations with unknown ftype

Zizhi Wo <wozizhi@huawei.com>
    smb: client: fix busy dentry warning on unmount after DIO

Itai Handler <itai.handler@gmail.com>
    spi: spi-zynqmp-gqspi: stop the controller on shutdown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix partial normalized name responses

Antheas Kapenekakis <lkml@antheas.dev>
    HID: asus: fortify keyboard handshake

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix missing iov bounds check in parse_posix_sids()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix missing lower-bound check on DFS referral string offsets

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix server->total_read for compound encrypted PDUs

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix potential OOB read in smb3_enum_snapshots()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix unaligned access in WSL reparse point parser

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix smbd_connection leak on cifs_get_tcp_session() error

Frank Sorenson <sorenson@redhat.com>
    smb: client: reject short Next offsets in parse_server_interfaces()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix rlist race and missing initialization

Paulo Alcantara <pc@manguebit.org>
    smb: client: cancel reconnect work in clean_demultiplex_info()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/hdmi_phy: fix runtime PM cleanup on probe failure

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/adreno: fix autosuspend cleanup during teardown

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: fix out-of-bounds write in gud_plane_atomic_check()

Rik van Riel <riel@surriel.com>
    wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: validate action frame fixed fields

Linmao Li <lilinmao@kylinos.cn>
    wifi: mwifiex: prevent authentication frame length truncation

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: mwifiex: validate scan response extents

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length

Shengzhuo Wei <me@cherr.cc>
    wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST

Shengzhuo Wei <me@cherr.cc>
    wifi: p54: validate curve data length in the calibration curve converters

Tianchu Chen <flynnnchen@tencent.com>
    wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()

Ali Ahmet Memis <ali@iusegentoo.com>
    wifi: wilc1000: fix out-of-bounds read in P2P public action frames

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: wlcore: release runtime PM ref on regdomain config failure

Tianchu Chen <flynnnchen@tencent.com>
    wifi: rsi: fix heap OOB write on key removal

Jiangshan Yi <yijiangshan@kylinos.cn>
    wifi: libertas_tf: fix UAF in lbtf_free_adapter()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: fix broadcast stations deallocation

Jiangshan Yi <yijiangshan@kylinos.cn>
    wifi: brcmsmac: fix UAF in brcms_free_timer()

Wentao Liang <vulab@iscas.ac.cn>
    watchdog: starfive-wdt: Fix runtime PM leak in starfive_wdt_pm_start()

Wentao Liang <vulab@iscas.ac.cn>
    watchdog: sp5100_tco: Fix pci_dev reference leak in sp5100_tco_init()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: rtd119x: Avoid division by zero

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Propagate error code in resume()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix premature reset during timeout update

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: digicolor: Avoid division by zero

Li Jun <lijun01@kylinos.cn>
    watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83793) release probe data through kref

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/tps53679) Fix TPS53676 phase page decoding

Nuno Sá <nuno.sa@analog.com>
    hwmon: (pmbus/core) increase number of phases and add new mask

Muhammad Bilal <meatuni001@gmail.com>
    hwmon: (hp-wmi-sensors) Fix use-after-free in fungible_show()

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    Input: zero ff_effect before compat copy in input_ff_effect_from_user

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - fix GPF in suspend and resume when unbound

Raphaël Larocque <rlarocque@disroot.org>
    Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)

Hans de Goede <johannes.goede@oss.qualcomm.com>
    Input: soc_button_array - check btns_desc->package.count

Hans de Goede <johannes.goede@oss.qualcomm.com>
    Input: soc_button_array - fix MS Surface Pro 11 probe failure

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: rmi_smbus - fix out-of-bounds read in rmi_smb_write_block()

Chris Sommers <chris.sommers@icloud.com>
    Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    Input: evdev - zero absinfo before partial copy in EVIOCSABS

Linkai Gong <gonglinkai@kylinos.cn>
    Input: cyttsp5 - clamp the HID report size before memcpy

Alexei Turtanov <9alexei9@gmail.com>
    Input: atkbd - skip deactivate for Xiaomi Redmi Book Pro 16 2026

Alvin Šipraga <alvin.sipraga@analog.com>
    Input: adp5588-keys - cache GPIO state before registering the gpiochip

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Fallback to DT-provided itap delay on DDR50 tuning failure

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Clear ITAPDLY on tuning failure

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Reset command and data lines on failed tuning

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Move tuning_loop to local variable

Xu Rao <raoxu@uniontech.com>
    mmc: spi: reset bytes_xfered before retrying CRC failures

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt

Felix Gu <ustc.gu@gmail.com>
    mmc: sdio_uart: fix xmit_fifo leak when the port table is full

Myeonghun Pak <mhun512@gmail.com>
    mmc: sdhci-of-aspeed: Remove children before releasing SDC resources

Florian Maillard <florian.maillard@mailoo.org>
    mmc: rtsx_pci_sdmmc: ignore broken write-protect on ThinkPad X260

Fan Wu <fanwu01@zju.edu.cn>
    mmc: mxcmmc: cancel data work and watchdog on remove

Fan Wu <fanwu01@zju.edu.cn>
    mmc: mmci: Fix use-after-free in busy-timeout work

Fan Wu <fanwu01@zju.edu.cn>
    mmc: hsq: Fix use-after-free in retry work

Zhu Ling <zhuling0805@qq.com>
    mmc: core: Fix OF node reference leak on card add failure

Fan Wu <fanwu01@zju.edu.cn>
    mmc: core: Cancel SDIO IRQ work before freeing host

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: fix NULL-pointer dereference in pwrseq_device_register()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: fix NULL-pointer dereference in pwrseq_unit_new()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: don't call .post_enable() if pwrseq_unit_enable() failed

Christian Göttsche <cgzones@googlemail.com>
    selinux: always fill AVC decision in avc_has_perm_noaudit()

Karl Mehltretter <kmehltretter@gmail.com>
    selinux: recheck intermediate backing files on mprotect()

Karl Mehltretter <kmehltretter@gmail.com>
    selinux: preserve user SID across nested backing files

Shuhei Takeshita <jyohuku.alterego@gmail.com>
    IB/hfi1: Fix the PIO_CRED credit-return mmap

Shuhei Takeshita <jyohuku.alterego@gmail.com>
    IB/hfi1: Resolve the credit-return buffer through the send context's node

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    IB/mlx4: Fix use-after-free on pkey sysfs registration failure

Guangshuo Li <lgs201920130244@gmail.com>
    i2c: imx: disable autosuspend on remove

Shengzhuo Wei <me@cherr.cc>
    i2c: imx: release DMA channels on probe error

Linkai Gong <gonglinkai@kylinos.cn>
    i2c: atr: fix dangling adapter pointer on add failure

Shengzhuo Wei <me@cherr.cc>
    i2c: at91: release DMA channels on remove and probe error

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix tpm2_load_cmd() boundary check

Maoyi Xie <maoyixie.tju@gmail.com>
    keys: translate request_key_auth pid for the reading procfs instance

Cen Zhang <cenzhang@linux.microsoft.com>
    KEYS: encrypted: fix integer overflow of datablob_len

Shakeel Butt <shakeel.butt@linux.dev>
    mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()

Yifei Gao <gyf161023@gmail.com>
    memstick: ms_block: destroy io_queue workqueue on removal

Siwei Zhang <fourdizhang@tencent.com>
    xfrm: use hlist_del_init_rcu for state_cache and state_cache_input

Chengfeng Ye <nicoyip.dev@gmail.com>
    xfrm: serialize state GC with device state flush

Alberto Carboneri <acarboneri@drivesec.com>
    scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: avoid truncating TPACKET_V3 private size

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: clear RX owner on VNET header error

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: cap hh_flows_limit at change time

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release tail references on DELACTION failure

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: mhi_wwan_mbim: check skb_copy_bits() return value

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: mhi_wwan_mbim: guard against a cyclic NDP chain

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()

Mark Amirkan <markdamirkan@gmail.com>
    net: lan743x: fix RX checksum use-after-free

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: xfrm: use full sockets in local error paths

Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
    dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix non-atomic read of DMA position registers

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Serialize local codec list cleanup

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_codec: validate vendor codec count length

Aamir Ahmed <elb12345@hotmail.co.uk>
    Bluetooth: eir: validate service data length before reading UUID

Nicolas Thibert <nithibert@gmail.com>
    Bluetooth: btusb: fix NXP IW610 composite device handling

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_and() mask generation

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_write() casting

Koichiro Den <den@valinux.co.jp>
    arm64: dts: renesas: r8a779f0: Set UFS lane count

Bradley Morgan <include@grrlz.net>
    arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc

Thomas Huth <thuth@redhat.com>
    kselftest/arm64: Fix size of thread_data values for pthread_join()

Benoît Sevens <bsevens@google.com>
    HID: logitech-hidpp: fix race condition when accessing stale stack pointer

Wyatt Feng <wf.kernel.dev@gmail.com>
    net: xfrm: reject unrepresentable espintcp transport headers

Zhiling Zou <zhilinz@nebusec.ai>
    openvswitch: avoid reallocating confirmed conntrack labels

Jeffin Philip <jeffinphilip14@gmail.com>
    RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()

Quanye Yang <quanyeyang@proton.me>
    RDMA/ucma: Serialize join and leave on copy_to_user failure

Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>
    tcp: exclude old ACKs from tcp fast path

Chang S. Bae <chang.seok.bae@intel.com>
    x86/microcode/intel: Reject problematic loading on Granite Rapids systems

Aohan Mei <henrymei@tencent.com>
    rds: ib: use rds_conn_drop() on protocol version mismatch

Hyunwoo Kim <imv4bel@gmail.com>
    exec: Cleanup POSIX timers right after de_thread()

Wentao Liang <vulab@iscas.ac.cn>
    cifs: Fix server use-after-free in cifs_chan_skip_or_disable()

Wentao Liang <vulab@iscas.ac.cn>
    ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()

Niklas Cassel <cassel@kernel.org>
    ata: libahci: clear PxCLBU and PxFBU for AHCI_HFLAG_32BIT_ONLY

Jiangshan Yi <yijiangshan@kylinos.cn>
    ASoC: codecs: rt712-sdca-dmic: fix uninitialized stream_config->type

Yuho Choi <oss.patchbox@gmail.com>
    ALSA: virtio: reset device before deleting virtqueues

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix potential UAF after asynchronous card release

Jeremy Nyberg <slickstretch3.0@gmail.com>
    Input: xpad - fix PDP Marvel Xbox 360 controller

Roberts Kursitis <roberts.kursitis@azeron.eu>
    Input: xpad - add support for Azeron devices

Erich Sartison <byt.es@mailbox.org>
    Input: xpad - add support for Victrix Pro BFG Controller

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix the random "error beacon valid" messages for USB

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: TX QOS Null data the same way as Null data

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: use folio's memcg inside __folio_split()

Matthew Schwartz <matthew.schwartz@linux.dev>
    x86/fred: Reconstruct the #GP context for rejected INT instructions

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on failure to update inode for hole punching and reflinking

Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>
    drm/amdgpu: check ras and obj before dereference

Eric Dumazet <edumazet@google.com>
    net: skbuff: do not leave stale header offsets after pskb_carve()

Dmitriy Okunev <dokunevdmitriy@gmail.com>
    net: mvpp2: prevent buffer overflow in page_pool allocation

James Clark <jjc@jclark.com>
    net: macb: fix ordering around PTP timestamp read

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: propagate FPE preemption-class mapping errors

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Ack RX overrun interrupt correctly

Eric Dumazet <edumazet@google.com>
    net: lock the socket in sock_gettstamp()

Yige Jiang <yigejiang86@gmail.com>
    net: netsec: fix device_node reference leak on phy_np

HyeongJun An <sammiee5311@gmail.com>
    ASoC: hdmi-codec: Report a change when the channel status moves

Sasha Levin <sashal@kernel.org>
    ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: do not overwrite phc_index when no PTP clock is registered

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix out-of-bounds write in reset_per_cpu_data()

Eric Dumazet <edumazet@google.com>
    drop_monitor: synchronize tracepoint unregistration on error path

Eric Dumazet <edumazet@google.com>
    pppoatm: ensure a writable skb header and linear data

Juan Perdomo <jcperdomo100@gmail.com>
    Bluetooth: RFCOMM: avoid socket lock inversion in listener cleanup

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel_pcie: fix off-by-one bounds check in RX submit

Tzung-Bi Shih <tzungbi@kernel.org>
    Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: fix wrong status for short WMT FUNC_CTRL events

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: set BT_LISTEN before requesting a BIG sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix parent socket leak in iso_conn_ready()

Weiming Shi <bestswngs@gmail.com>
    Bluetooth: coredump: Quiesce dump work on unregister

ThangNN99 <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Print number of packets in conn->data_q

Baineng Shou <shoubaineng@gmail.com>
    dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: keep compound responses on query info errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix partial file information responses

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return buffer overflow for partial filesystem info

Eric Dumazet <edumazet@google.com>
    tcp: do not let tcp_rmem be set below 4096

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Don't call skb_clone_and_charge_r() for close()d listener in tcp_v6_do_rcv().

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: move switchdev call outside rcu

Karl Mehltretter <kmehltretter@gmail.com>
    wifi: brcmfmac: fix lost 802.1x TX completion wakeup

Hohyun Sim <tlaghgus0425@korea.ac.kr>
    net: fddi: skfp: fix NULL deref when setting the MAC address while down

Dong Chenchen <dongchenchen2@huawei.com>
    ipv4: icmp: reject RTN_UNREACHABLE input routes in icmp_route_lookup

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: set IPSKB_L3SLAVE from IP6SKB_L3SLAVE on IPIP decapsulation

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dsi: round the byte clock rate after reparenting to the PHY PLL

Filipe Manana <fdmanana@suse.com>
    btrfs: tree-checker: print dev extent offset in error message

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()

Slavin Liu <bolin.liu@seu.edu.cn>
    ALSA: hda: trace PCM open only after assigning a stream

Karl Mehltretter <kmehltretter@gmail.com>
    drm/vc4: Use managed KMS polling to fix UAF on unbind

Zihan Xi <zihanx@nebusec.ai>
    wifi: virt_wifi: don't transfer operstate before register

Xiang Mei <xmei5@asu.edu>
    ALSA: 6fire: fix OOB write from device-reported iso length

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: 6fire: Avoid embedded URBs

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Clean ups with guard()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    gpio: virtuser: skip free_irq when no IRQ is installed

Karl Mehltretter <kmehltretter@gmail.com>
    Input: trackpoint - fix the inertia attribute name in the ABI document

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Add codec_ch_mask to snd_soc_dai_link_ch_map

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Rename snd_soc_dai_link_ch_map.ch_mask to cpu_ch_mask

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: pcm: set timer->private_data before registering the PCM timer

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    phy: mediatek: phy-mtk-hdmi-mt8195: Fix TMDS clk bit ratio setting

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    phy: mediatek: phy-mtk-hdmi-mt8195: Fix PLL calc divisor overflow

Takashi Iwai <tiwai@suse.de>
    ALSA: bcd2000: Fix race between rawmidi and disconnect

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Skip default parms when resumed in neightbl_dump_info().

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Add missing RCU annotation for neightbl_dump_info().

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Convert RTM_GETNEIGHTBL to RCU.

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Convert RTM_GETNEIGH to RCU.

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Move neigh_find_table() to neigh_get().

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Allocate skb in neigh_get().

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Move two validations from neigh_get() to neigh_valid_get_req().

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Make neigh_valid_get_req() return ndmsg.

Kuniyuki Iwashima <kuniyu@amazon.com>
    neighbour: Use rtnl_register_many().

Karl Mehltretter <kmehltretter@gmail.com>
    keys: fix lost wakeup when reaping a dead key type

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr

Breno Leitao <leitao@debian.org>
    arm64: hibernate: clone only the linear map that exists at runtime

Shouping Wang <allen.wang@hj-micro.com>
    perf/arm-cmn: Fix wp_dev_sel2 setting for multi-DTM configurations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: hold reference on ct until flow is released

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_nat: fully initialise new_addr in netmap setup

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    RDMA/siw: Bound fragmented header copies by the remaining length

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Keep EQ resources alive while IRQ is registered

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Keep admin queues alive while IRQ is registered

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order

Karl Mehltretter <kmehltretter@gmail.com>
    scsi: qla2xxx: Fix the ql2xfc2target parameter description

Meijing Zhao <zhaomeijing@lixiang.com>
    mm: memblock: show all region flags in debugfs

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: set up the TX info early to fix failure paths

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: release the channel if start fails

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: reset the CSA state when leaving

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: add HE 6 GHz capability in the scan elems len

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't access the TSF of a down interface

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't RCU-dereference the mesh CSA settings we just set

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't allow link changes when iface is down

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: require a peer station for TDLS setup confirm

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't allow injecting frames wider than the chanctx

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: expose cfg80211_chandef_get_width()

Kavita Kavita <quic_kkavita@quicinc.com>
    wifi: cfg80211: skip regulatory for punctured subchannels

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: unlist vifs when their netdev is unregistered

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset state when starting AP fails

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: abort chanswitch when leaving a mesh

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: suppress chanctx warning for debugfs reset

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't offload TC setup on AP_VLAN interfaces

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't warn when an IBSS has no channel to scan

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: use vif radio mask to limit ibss scan frequencies

Felix Fietkau <nbd@nbd.name>
    wifi: cfg80211: add option for vif allowed radios

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't start a ROC while scanning

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't filter by BSS type when removing stale entries

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: only group hidden BSSes with beacon entries

Shivank Garg <shivankg@amd.com>
    dmaengine: wait for RCU readers before releasing dma_device

Shivank Garg <shivankg@amd.com>
    dmaengine: fix use-after-free in dma_chan_put() and dma_release_channel()

Shivank Garg <shivankg@amd.com>
    dmaengine: Fix device kref underflow in dma_chan_put()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    dma-coherent: report a failed reserved memory assignment

Chen-Yu Tsai <wenst@chromium.org>
    dma-coherent: Warn if OF reserved memory is beyond current coherent DMA mask

Orgad Shaneh <orgads@gmail.com>
    MIPS: Octeon: apply USB FDT fixups also when USB is modular

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: cadence_master: wait and cancel cdns->work before clock stop

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: check IP header size in cfg80211_classify8021d()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't get the radio mask for netdev-less wdevs

Carolina Jubran <cjubran@nvidia.com>
    IB/IPoIB: Avoid restoring OPER_UP after multicast flush

Shmulik Cohen <anuk909@gmail.com>
    wifi: libipw: reject too-short association responses

Shmulik Cohen <anuk909@gmail.com>
    wifi: libipw: reject too-short beacon and probe responses

Peng Hao <flyingpenghao@gmail.com>
    wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path

Mariano Baragiola <mbaragiola@linux.com>
    wifi: virt_wifi: free skb when disconnected

Ruoyu Wang <ruoyuw560@gmail.com>
    dmaengine: sprd: Fix runtime PM reference leak in probe

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Enforce local fence for IB_WR_REG_MR

Li RongQing <lirongqing@baidu.com>
    RDMA/mad: Fix receive buffer leak when PKey enforcement fails

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: wait for deferred control PDU completions before releasing the connection

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/iser: reject a remote invalidation of an unregistered direction

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    RDMA/core: Reject unregistering netdevs in ib_get_eth_speed

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: insert mcg into mcg_tree only after rxe_mcast_add() succeeds

Xixin Liu <liuxixin@kylinos.cn>
    clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate

Xixin Liu <liuxixin@kylinos.cn>
    firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS

Gang Yan <yangang@kylinos.cn>
    RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access

Norbert Szetei <norbert@doyensec.com>
    RDMA/rxe: validate access flags before swapping the MR's PD

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ARM: socfpga: select the PL310 erratum 753970 workaround

Maher Azzouzi <maherazz04@gmail.com>
    esp: downgrade zerocopy managed frags before mutating skb frags

Eric Dumazet <edumazet@google.com>
    xfrm: add missing rcu_read_lock(), skb_dst_force() and dev_hold() for xfrm_trans_reinject()

Kyle Zeng <kylebot@openai.com>
    xfrm: fix compat ALLOCSPI request use-after-free

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: avoid RCU warnings around the per-netns netlink socket

Chen Linxuan <me@black-desk.cn>
    pidfd: hold exec_update_lock around namespace ioctl

Ido Schimmel <idosch@nvidia.com>
    ipv6: Honor oif when choosing nexthop for locally generated traffic

Ido Schimmel <idosch@nvidia.com>
    ipv6: Select best matching nexthop object in fib6_table_lookup()

Arash Golgol <arash.golgol@gmail.com>
    media: video-i2c: fix buffer queue ordering

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use copy-on-write RCU updates in ip6_mc_source()

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Don't hold RTNL for MCAST_ socket options.

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Don't hold RTNL for IPV6_DROP_MEMBERSHIP and MCAST_LEAVE_GROUP.

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Don't hold RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP.

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Use in6_dev_get() in ipv6_dev_mc_dec().

Kevin Hao <haokexin@gmail.com>
    net: cpsw: Execute ndo_set_rx_mode callback in a work queue

Kevin Hao <haokexin@gmail.com>
    net: cpsw_new: Execute ndo_set_rx_mode callback in a work queue

Jens Axboe <axboe@kernel.dk>
    sunvdc: fix -EIO issue due to lack of retries

Günther Noack <gnoack@google.com>
    selftests/landlock: Add tests for whiteout object creation

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: Avoid IPL parameter append past command line

Vasily Gorbik <gor@linux.ibm.com>
    s390/boot: Add sized_strscpy() to enable strscpy() usage

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add disconnected leafs and branch test suites

Tingmao Wang <m@maowtm.org>
    selftests/landlock: Add tests for access through disconnected paths

Matthieu Buffet <matthieu@buffet.re>
    selftests/landlock: Add missing connect(minimal AF_UNSPEC) test

Matthieu Buffet <matthieu@buffet.re>
    selftests/landlock: Add test for TCP fast open

Matthieu Buffet <matthieu@buffet.re>
    landlock: Fix TCP Fast Open connection bypass

Sasha Levin <sashal@kernel.org>
    Revert "hwmon: (emc1403) Rely on subsystem locking"

Sasha Levin <sashal@kernel.org>
    Revert "hwmon: (emc1403) Drop hysteresis for low limit temperature"


-------------

Diffstat:

 .../ABI/testing/sysfs-devices-platform-trackpoint  |    2 +-
 Documentation/ABI/testing/sysfs-fs-erofs           |    2 +-
 Documentation/arch/arm64/booting.rst               |    1 +
 Documentation/arch/s390/pci.rst                    |  144 +-
 Documentation/hwmon/emc1403.rst                    |    8 +-
 Documentation/networking/ip-sysctl.rst             |    2 +
 .../net_cachelines/inet_connection_sock.rst        |    1 +
 .../networking/net_cachelines/inet_sock.rst        |    1 +
 .../networking/net_cachelines/net_device.rst       |    1 +
 Documentation/trace/eprobetrace.rst                |  269 ++++
 Documentation/trace/index.rst                      |    1 +
 Makefile                                           |    4 +-
 arch/arm/mach-socfpga/Kconfig                      |    2 +-
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |    1 +
 arch/arm64/include/asm/el2_setup.h                 |    8 +-
 arch/arm64/include/asm/io.h                        |    3 +-
 arch/arm64/include/asm/percpu.h                    |   33 +-
 arch/arm64/kernel/hibernate-asm.S                  |    2 +
 arch/arm64/kernel/hibernate.c                      |    4 +-
 arch/arm64/kvm/emulate-nested.c                    |    2 +-
 arch/arm64/kvm/hypercalls.c                        |    3 +-
 arch/arm64/kvm/mmu.c                               |   15 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  108 +-
 arch/arm64/kvm/vgic/vgic.h                         |   23 -
 arch/arm64/net/bpf_jit_comp.c                      |    2 +
 arch/mips/cavium-octeon/octeon-platform.c          |    4 +-
 arch/mips/net/bpf_jit_comp32.c                     |    2 +-
 arch/mips/net/bpf_jit_comp64.c                     |    3 +-
 arch/powerpc/kernel/iommu.c                        |    2 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |    2 +
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |    5 +-
 arch/riscv/kvm/aia_imsic.c                         |   11 +-
 arch/riscv/kvm/vcpu_pmu.c                          |   33 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |    4 +-
 arch/riscv/kvm/vcpu_timer.c                        |    5 +-
 arch/s390/boot/ipl_parm.c                          |   26 +-
 arch/s390/boot/string.c                            |   12 +
 arch/s390/include/asm/debug.h                      |    8 +-
 arch/s390/kernel/debug.c                           |   15 +-
 arch/s390/kvm/interrupt.c                          |   72 +-
 arch/s390/kvm/kvm-s390.c                           |    4 +-
 arch/x86/entry/entry_fred.c                        |   11 +-
 arch/x86/events/intel/core.c                       |   89 +-
 arch/x86/events/intel/ds.c                         |   36 +-
 arch/x86/events/intel/pt.c                         |    2 +
 arch/x86/events/perf_event.h                       |    2 +-
 arch/x86/include/asm/kvm_host.h                    |    4 +-
 arch/x86/kernel/cpu/mce/core.c                     |   27 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   26 +
 arch/x86/kvm/Makefile                              |    2 +-
 arch/x86/kvm/mmu/mmu.c                             |   60 +-
 arch/x86/kvm/pmu.c                                 |    8 -
 arch/x86/kvm/regs.c                                |  872 ++++++++++
 arch/x86/kvm/svm/sev.c                             |   77 +-
 arch/x86/kvm/svm/svm.h                             |    1 +
 arch/x86/kvm/vmx/pmu_intel.c                       |    3 +
 arch/x86/kvm/x86.c                                 |  900 +----------
 arch/x86/kvm/x86.h                                 |   28 +
 arch/x86/pci/fixup.c                               |   99 ++
 drivers/ata/libahci.c                              |   15 +-
 drivers/ata/libahci_platform.c                     |    2 +-
 drivers/ata/libata-scsi.c                          |   10 +-
 drivers/base/core.c                                |  131 +-
 drivers/block/sunvdc.c                             |    9 +-
 drivers/bluetooth/btintel_pcie.c                   |   18 +-
 drivers/bluetooth/btmtk.c                          |    7 +-
 drivers/bluetooth/btmtksdio.c                      |    4 +-
 drivers/bluetooth/btusb.c                          |   17 +
 drivers/char/hw_random/atmel-rng.c                 |    2 +-
 drivers/char/hw_random/cctrng.c                    |    2 +-
 drivers/char/hw_random/exynos-trng.c               |    2 +-
 drivers/char/hw_random/ingenic-rng.c               |    2 +-
 drivers/char/hw_random/ks-sa-rng.c                 |    2 +-
 drivers/char/hw_random/mxc-rnga.c                  |    2 +-
 drivers/char/hw_random/n2-drv.c                    |    2 +-
 drivers/char/hw_random/npcm-rng.c                  |    2 +-
 drivers/char/hw_random/omap-rng.c                  |    2 +-
 drivers/char/hw_random/stm32-rng.c                 |   11 +-
 drivers/char/hw_random/timeriomem-rng.c            |    2 +-
 drivers/char/hw_random/xgene-rng.c                 |    2 +-
 drivers/clk/clk-scpi.c                             |    2 +-
 drivers/clk/qcom/gcc-qcm2290.c                     |    6 +-
 drivers/clk/qcom/gcc-sm6115.c                      |    6 +-
 drivers/dma-buf/dma-heap.c                         |   80 +-
 drivers/dma/dmaengine.c                            |   40 +-
 drivers/dma/mmp_pdma.c                             |    2 +-
 drivers/dma/sprd-dma.c                             |    3 +-
 drivers/dma/sun6i-dma.c                            |    9 +-
 drivers/dma/ti/k3-udma-glue.c                      |    5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   26 +-
 drivers/dpll/dpll_netlink.c                        |    3 +-
 drivers/edac/altera_edac.c                         |  115 +-
 drivers/edac/altera_edac.h                         |    1 +
 drivers/firmware/arm_scpi.c                        |    4 +-
 drivers/firmware/qcom/qcom_scm.c                   |   44 +-
 drivers/firmware/sysfb_simplefb.c                  |   31 +-
 drivers/gpio/gpio-arizona.c                        |    8 +-
 drivers/gpio/gpio-tps65219.c                       |    2 +-
 drivers/gpio/gpio-virtuser.c                       |    3 +-
 drivers/gpio/gpio-zynq.c                           |   10 +-
 drivers/gpio/gpiolib-cdev.c                        |   30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   20 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   36 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |   11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |    9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |   21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c           |   11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h           |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umsch_mm.c       |  459 +-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |    1 +
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c             |    2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    4 +-
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |    6 +-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |    1 +
 drivers/gpu/drm/armada/armada_fbdev.c              |    4 +-
 drivers/gpu/drm/bridge/samsung-dsim.c              |    2 +-
 drivers/gpu/drm/bridge/tc358768.c                  |   15 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   13 +-
 drivers/gpu/drm/drm_client.c                       |    4 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   24 +-
 drivers/gpu/drm/drm_fbdev_client.c                 |   14 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    |    4 +-
 drivers/gpu/drm/drm_fbdev_shmem.c                  |    4 +-
 drivers/gpu/drm/drm_fbdev_ttm.c                    |    4 +-
 drivers/gpu/drm/drm_file.c                         |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |    4 +-
 drivers/gpu/drm/gma500/fbdev.c                     |    4 +-
 drivers/gpu/drm/gud/gud_pipe.c                     |    4 +-
 drivers/gpu/drm/i915/display/intel_connector.c     |    4 +-
 drivers/gpu/drm/i915/display/intel_cursor.c        |    7 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |    4 +-
 .../gpu/drm/i915/display/intel_display_debugfs.c   |    8 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   20 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   36 +-
 drivers/gpu/drm/i915/display/intel_dp_hdcp.c       |    6 +-
 .../gpu/drm/i915/display/intel_dp_link_training.c  |    4 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |  155 +-
 drivers/gpu/drm/i915/display/intel_fbdev.c         |    8 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |    8 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |   39 +-
 drivers/gpu/drm/i915/display/skl_universal_plane.c |    9 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |    2 +-
 drivers/gpu/drm/imagination/pvr_free_list.c        |   15 +-
 drivers/gpu/drm/imagination/pvr_mmu.c              |   19 +-
 drivers/gpu/drm/imagination/pvr_mmu.h              |    2 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |    4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |    2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |    1 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   36 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |    8 +-
 drivers/gpu/drm/msm/msm_fbdev.c                    |    4 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    3 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |    5 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    2 +
 drivers/gpu/drm/nouveau/nouveau_sched.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_sched.h            |    1 +
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   13 +-
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |    1 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/gv100.c   |    4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/head.h    |    2 +
 drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c    |    8 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/uoutp.c   |    3 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |   23 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c   |    2 +
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |    4 +-
 drivers/gpu/drm/radeon/radeon_fbdev.c              |    4 +-
 drivers/gpu/drm/tegra/fbdev.c                      |    4 +-
 drivers/gpu/drm/tiny/ofdrm.c                       |    8 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |   61 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |    2 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |    2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |    6 +-
 drivers/gpu/drm/virtio/virtgpu_submit.c            |   11 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c              |   17 +-
 drivers/gpu/drm/xe/instructions/xe_gpu_commands.h  |    1 +
 drivers/gpu/drm/xe/xe_bo.h                         |   19 +
 drivers/gpu/drm/xe/xe_ring_ops.c                   |   16 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   29 +-
 drivers/hid/amd-sfh-hid/amd_sfh_common.h           |    4 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   10 +
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   12 +-
 drivers/hid/hid-alps.c                             |   31 +-
 drivers/hid/hid-asus.c                             |   34 +-
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/hid-logitech-hidpp.c                   |   24 +-
 drivers/hid/hid-quirks.c                           |    3 +-
 drivers/hid/wacom_sys.c                            |    5 +-
 drivers/hwmon/emc1403.c                            |   73 +-
 drivers/hwmon/hp-wmi-sensors.c                     |    2 +
 drivers/hwmon/pmbus/pmbus.h                        |    3 +-
 drivers/hwmon/pmbus/tps53679.c                     |   11 +-
 drivers/hwmon/pwm-fan.c                            |   13 +-
 drivers/hwmon/w83791d.c                            |    1 +
 drivers/hwmon/w83793.c                             |    4 +-
 drivers/i2c/busses/i2c-at91-core.c                 |    3 +
 drivers/i2c/busses/i2c-at91-master.c               |   12 +-
 drivers/i2c/busses/i2c-at91.h                      |    1 +
 drivers/i2c/busses/i2c-imx.c                       |    3 +
 drivers/i2c/busses/i2c-mxs.c                       |    5 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |   37 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   33 +-
 drivers/i2c/i2c-atr.c                              |    1 +
 drivers/i3c/master.c                               |   20 +-
 drivers/infiniband/core/iwpm_util.c                |    9 +-
 drivers/infiniband/core/mad.c                      |    3 +-
 drivers/infiniband/core/ucma.c                     |    7 +-
 drivers/infiniband/core/verbs.c                    |   12 +-
 drivers/infiniband/hw/efa/efa_com.c                |    7 +-
 drivers/infiniband/hw/efa/efa_com.h                |    1 +
 drivers/infiniband/hw/efa/efa_main.c               |   35 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |   23 +-
 drivers/infiniband/hw/irdma/verbs.c                |    2 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |    4 +
 drivers/infiniband/sw/rxe/rxe_mcast.c              |   50 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |    3 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   13 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |    7 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    7 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   12 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   16 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   16 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   22 +
 drivers/infiniband/ulp/isert/ib_isert.h            |    2 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |    8 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.h             |    2 +
 drivers/input/evdev.c                              |    2 +
 drivers/input/input-compat.c                       |    2 +
 drivers/input/joystick/xpad.c                      |   10 +-
 drivers/input/keyboard/adp5588-keys.c              |   12 +-
 drivers/input/keyboard/atkbd.c                     |    8 +
 drivers/input/misc/soc_button_array.c              |   16 +-
 drivers/input/mouse/synaptics.c                    |    8 +
 drivers/input/rmi4/rmi_driver.c                    |   13 +
 drivers/input/rmi4/rmi_smbus.c                     |   10 +-
 drivers/input/serio/hp_sdc.c                       |    2 +-
 drivers/input/serio/i8042-acpipnpio.h              |    7 +
 drivers/input/touchscreen/cyttsp5.c                |    1 +
 drivers/iommu/iommufd/device.c                     |   70 +-
 drivers/iommu/iommufd/hw_pagetable.c               |   13 +-
 drivers/iommu/iommufd/iommufd_private.h            |    8 +-
 drivers/iommu/iommufd/selftest.c                   |   20 +
 drivers/iommu/msm_iommu.c                          |   55 +-
 drivers/media/i2c/imx355.c                         |   62 +-
 drivers/media/i2c/video-i2c.c                      |    5 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |   12 +-
 .../platform/chips-media/wave5/wave5-vpuconfig.h   |    1 +
 drivers/memstick/core/ms_block.c                   |    2 +
 drivers/mmc/core/bus.c                             |    2 +-
 drivers/mmc/core/host.c                            |    1 +
 drivers/mmc/core/sdio_uart.c                       |    3 +
 drivers/mmc/host/mmc_hsq.c                         |    8 +-
 drivers/mmc/host/mmc_spi.c                         |    1 +
 drivers/mmc/host/mmci.c                            |    3 +
 drivers/mmc/host/mxcmmc.c                          |    4 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |    5 +
 drivers/mmc/host/sdhci-of-aspeed.c                 |    5 +-
 drivers/mmc/host/sdhci_am654.c                     |   43 +-
 drivers/mmc/host/sh_mmcif.c                        |    3 +-
 drivers/mmc/host/via-sdmmc.c                       |    4 +
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   10 +-
 drivers/net/bonding/bond_main.c                    |    2 +-
 drivers/net/dsa/mt7530-mdio.c                      |   18 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   25 +-
 drivers/net/ethernet/amazon/ena/ena_com.h          |   14 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    1 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    3 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    3 +
 drivers/net/ethernet/atheros/atlx/atl1.c           |    3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   82 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |    2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   63 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |    5 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   20 +-
 drivers/net/ethernet/broadcom/tg3.c                |   15 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   16 +-
 drivers/net/ethernet/cadence/macb_main.c           |   13 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |   20 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |    4 +-
 drivers/net/ethernet/cortina/gemini.c              |    2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |    1 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    3 +
 drivers/net/ethernet/intel/idpf/idpf.h             |   24 +-
 drivers/net/ethernet/intel/idpf/idpf_dev.c         |   10 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   35 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  301 ++--
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   14 +-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c      |   10 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   20 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |    3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   45 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |    6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   45 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    3 +
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   39 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   15 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |    2 +
 .../net/ethernet/mellanox/mlx5/core/lib/devcom.c   |    5 +-
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h        |    1 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |    9 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |    2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |    2 +-
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |    3 +-
 drivers/net/ethernet/socionext/netsec.c            |    2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |    4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |    4 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |    4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    2 -
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  106 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   19 +-
 drivers/net/ethernet/ti/cpsw.c                     |   41 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   35 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |    1 +
 drivers/net/ethernet/ti/netcp_core.c               |    2 +-
 drivers/net/fddi/skfp/skfddi.c                     |    3 +-
 drivers/net/macsec.c                               |  123 +-
 drivers/net/pcs/pcs-xpcs.c                         |    4 +-
 drivers/net/phy/mediatek/mtk-ge-soc.c              |   23 +-
 drivers/net/usb/catc.c                             |   15 +-
 drivers/net/usb/cdc_mbim.c                         |    5 +
 drivers/net/usb/lan78xx.c                          |    2 +
 drivers/net/usb/sr9700.c                           |    3 +-
 drivers/net/veth.c                                 |    2 +
 drivers/net/virtio_net.c                           |    9 +
 drivers/net/vrf.c                                  |    2 -
 drivers/net/vxlan/vxlan_core.c                     |    6 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   25 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    2 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |    4 +
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    6 +
 drivers/net/wireless/intel/iwlegacy/common.c       |    2 +-
 drivers/net/wireless/intersil/p54/eeprom.c         |   22 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   12 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   54 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |   10 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    5 +
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   33 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |    8 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   14 +
 drivers/net/wireless/microchip/wilc1000/wlan.c     |    9 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    8 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    2 +-
 drivers/net/wireless/realtek/rtw89/core.h          |    3 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   13 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    3 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   13 +
 drivers/net/wireless/realtek/rtw89/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |    3 +-
 drivers/net/wireless/realtek/rtw89/rtw8851be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852bte.c    |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c     |    1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    2 -
 drivers/net/wireless/ti/wlcore/main.c              |    4 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   39 +-
 drivers/net/wireless/virtual/virt_wifi.c           |    4 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   28 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c                |    4 +
 drivers/nfc/microread/microread.c                  |    6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |   11 +-
 drivers/nfc/pn533/pn533.c                          |   14 +-
 drivers/nfc/pn533/pn533.h                          |    4 +-
 drivers/nfc/pn533/usb.c                            |    4 +-
 drivers/nfc/pn544/pn544.c                          |    7 +-
 drivers/nfc/port100.c                              |    7 +
 drivers/nfc/st21nfca/core.c                        |   12 +-
 drivers/nfc/st21nfca/i2c.c                         |   29 +-
 drivers/nfc/virtual_ncidev.c                       |    3 +-
 drivers/nvdimm/nd_virtio.c                         |  125 +-
 drivers/nvdimm/pmem.c                              |   15 +-
 drivers/nvdimm/region_devs.c                       |    5 +-
 drivers/nvdimm/virtio_pmem.c                       |   14 +-
 drivers/nvdimm/virtio_pmem.h                       |    6 +
 drivers/nvme/host/core.c                           |   83 +-
 drivers/nvme/host/nvme.h                           |    2 +-
 drivers/pci/controller/plda/pcie-starfive.c        |   36 +-
 drivers/pci/hotplug/pnv_php.c                      |    2 +-
 drivers/pci/hotplug/rpaphp_slot.c                  |    2 +-
 drivers/pci/of_property.c                          |   11 +-
 drivers/pci/pci.c                                  |    5 +-
 drivers/pci/rebar.c                                |   19 +-
 drivers/pci/setup-bus.c                            |   56 +-
 drivers/pci/slot.c                                 |   67 +-
 drivers/perf/arm-cmn.c                             |   10 +-
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c         |    4 +-
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h         |    3 +
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  302 +++-
 drivers/pinctrl/meson/pinctrl-meson-s4.c           |    2 +-
 drivers/pinctrl/pinctrl-single.c                   |    3 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   76 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              |    7 +
 drivers/platform/x86/amd/pmc/Makefile              |    2 +-
 drivers/platform/x86/amd/pmc/mp1_stb.c             |  316 ++++
 drivers/platform/x86/amd/pmc/pmc.c                 |  314 +---
 drivers/platform/x86/amd/pmc/pmc.h                 |   18 +-
 drivers/platform/x86/intel/int1092/intel_sar.c     |   39 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   14 +-
 drivers/platform/x86/think-lmi.c                   |   45 +-
 drivers/platform/x86/think-lmi.h                   |    2 +-
 drivers/power/sequencing/core.c                    |   11 +-
 drivers/power/supply/ab8500_fg.c                   |   32 +-
 drivers/power/supply/qcom_battmgr.c                |    8 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |    8 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   93 +-
 drivers/rtc/rtc-rzn1.c                             |   16 +-
 drivers/s390/cio/chp.c                             |    3 +
 drivers/s390/cio/cio.c                             |   11 +-
 drivers/s390/cio/cio.h                             |    5 +-
 drivers/s390/cio/cmf.c                             |    2 +-
 drivers/s390/cio/device.c                          |    9 +-
 drivers/s390/cio/device_fsm.c                      |    3 +
 drivers/s390/cio/device_ops.c                      |   23 +
 drivers/s390/cio/vfio_ccw_fsm.c                    |    2 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   44 +-
 drivers/scsi/fnic/fnic.h                           |    2 +-
 drivers/scsi/fnic/fnic_isr.c                       |   13 +-
 drivers/scsi/fnic/fnic_main.c                      |   33 +-
 drivers/scsi/libiscsi_tcp.c                        |    3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |    4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   47 +-
 drivers/scsi/qla2xxx/qla_def.h                     |    2 +
 drivers/scsi/qla2xxx/qla_fw.h                      |    4 +
 drivers/scsi/qla2xxx/qla_init.c                    |   14 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   23 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   33 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |    6 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   49 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   10 +
 drivers/scsi/qla2xxx/qla_os.c                      |   17 +-
 drivers/scsi/scsi.c                                |   24 +-
 drivers/scsi/sd_zbc.c                              |    8 +-
 drivers/soc/qcom/mdt_loader.c                      |    4 +-
 drivers/soundwire/cadence_master.c                 |    7 +
 drivers/spi/spi-zynqmp-gqspi.c                     |   34 +
 drivers/staging/media/rkvdec/rkvdec.c              |    4 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |    5 +-
 drivers/staging/sm750fb/sm750.c                    |    2 +-
 drivers/staging/sm750fb/sm750.h                    |    2 +-
 drivers/staging/sm750fb/sm750_accel.c              |    6 +-
 drivers/staging/sm750fb/sm750_accel.h              |    4 +-
 drivers/thermal/gov_step_wise.c                    |   10 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |    4 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  112 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |    1 +
 drivers/usb/cdns3/cdnsp-mem.c                      |   98 +-
 drivers/usb/cdns3/core.h                           |    2 +-
 drivers/usb/dwc3/core.h                            |    3 +-
 drivers/usb/dwc3/ep0.c                             |    2 +-
 drivers/usb/dwc3/gadget.c                          |  129 +-
 drivers/usb/gadget/function/f_mass_storage.c       |    3 +
 drivers/usb/host/xhci-pci.c                        |    8 +-
 drivers/usb/storage/realtek_cr.c                   |    9 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   39 +-
 drivers/video/screen_info_generic.c                |   36 +
 drivers/virtio/virtio_mmio.c                       |   66 +-
 drivers/watchdog/da9063_wdt.c                      |    4 +-
 drivers/watchdog/digicolor_wdt.c                   |   13 +-
 drivers/watchdog/msc313e_wdt.c                     |   16 +-
 drivers/watchdog/rtd119x_wdt.c                     |    7 +-
 drivers/watchdog/sp5100_tco.c                      |    6 +-
 drivers/watchdog/starfive-wdt.c                    |    2 +-
 fs/9p/vfs_addr.c                                   |   12 +
 fs/autofs/inode.c                                  |    4 +
 fs/btrfs/dev-replace.c                             |    1 +
 fs/btrfs/file.c                                    |    4 +-
 fs/btrfs/tree-checker.c                            |    2 +-
 fs/configfs/dir.c                                  |   13 +-
 fs/configfs/symlink.c                              |   51 +-
 fs/erofs/fscache.c                                 |    2 +
 fs/erofs/sysfs.c                                   |    2 +
 fs/exec.c                                          |   29 +-
 fs/f2fs/debug.c                                    |    4 -
 fs/f2fs/dir.c                                      |    7 +-
 fs/f2fs/f2fs.h                                     |   29 +-
 fs/f2fs/file.c                                     |   47 +-
 fs/f2fs/gc.c                                       |   51 +-
 fs/f2fs/gc.h                                       |   25 -
 fs/f2fs/inline.c                                   |    2 +-
 fs/f2fs/namei.c                                    |    6 +-
 fs/f2fs/node.c                                     |   22 +-
 fs/f2fs/recovery.c                                 |   41 +-
 fs/f2fs/segment.c                                  |    9 +-
 fs/f2fs/super.c                                    |    4 +-
 fs/f2fs/sysfs.c                                    |   18 +-
 fs/fs-writeback.c                                  |   25 +-
 fs/inode.c                                         |   11 +-
 fs/kernfs/mount.c                                  |    4 +-
 fs/lockd/svcsubs.c                                 |    2 +-
 fs/ntfs3/inode.c                                   |    7 +-
 fs/ocfs2/namei.c                                   |    9 +-
 fs/ocfs2/xattr.c                                   |   13 +-
 fs/ocfs2/xattr.h                                   |    8 +-
 fs/pidfs.c                                         |   43 +-
 fs/smb/client/cached_dir.c                         |   32 +-
 fs/smb/client/cifs_fs_sb.h                         |    1 +
 fs/smb/client/cifsacl.c                            |   69 +-
 fs/smb/client/cifsfs.c                             |   12 +
 fs/smb/client/cifsglob.h                           |   12 +-
 fs/smb/client/cifsproto.h                          |    8 +-
 fs/smb/client/cifssmb.c                            |    2 +-
 fs/smb/client/connect.c                            |   10 +
 fs/smb/client/file.c                               |   11 +-
 fs/smb/client/misc.c                               |   12 +-
 fs/smb/client/reparse.c                            |    4 +-
 fs/smb/client/reparse.h                            |    7 +-
 fs/smb/client/sess.c                               |  106 +-
 fs/smb/client/smb2inode.c                          |   11 +
 fs/smb/client/smb2ops.c                            |   78 +-
 fs/smb/client/smb2pdu.c                            |   64 +-
 fs/smb/client/transport.c                          |    4 +-
 fs/smb/server/smb2pdu.c                            |   89 +-
 fs/smb/server/smb2pdu.h                            |    1 +
 fs/squashfs/xz_wrapper.c                           |    6 +-
 fs/super.c                                         |   43 +-
 fs/udf/inode.c                                     |  129 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |    2 +-
 fs/xfs/libxfs/xfs_da_btree.h                       |    2 +
 fs/xfs/scrub/attr_repair.c                         |    4 +-
 fs/xfs/scrub/dir_repair.c                          |   23 +-
 fs/xfs/scrub/health.c                              |    6 +-
 fs/xfs/scrub/inode.c                               |    2 +-
 fs/xfs/scrub/inode_repair.c                        |    2 +-
 fs/xfs/scrub/orphanage.c                           |    6 +-
 fs/xfs/scrub/reap.c                                |    2 +-
 fs/xfs/scrub/refcount.c                            |    8 +-
 fs/xfs/scrub/scrub.h                               |    2 +-
 fs/xfs/scrub/stats.c                               |    1 +
 fs/xfs/scrub/tempfile.c                            |   29 +-
 fs/xfs/xfs_exchrange.c                             |   13 +-
 fs/xfs/xfs_icache.c                                |    2 +-
 fs/xfs/xfs_inode.h                                 |    3 +
 fs/xfs/xfs_qm.c                                    |   10 +-
 include/drm/drm_client.h                           |   10 +-
 include/drm/drm_fb_helper.h                        |   11 +-
 include/drm/drm_file.h                             |    1 +
 include/keys/request_key_auth-type.h               |    2 +-
 include/linux/bpf_mem_alloc.h                      |    6 +
 include/linux/compiler-context-analysis.h          |   32 +
 include/linux/compiler_types.h                     |   18 +-
 include/linux/dev_printk.h                         |    1 +
 include/linux/dmaengine.h                          |    7 +
 include/linux/firmware/qcom/qcom_scm.h             |   20 +-
 include/linux/ftrace.h                             |    5 +-
 include/linux/if_vlan.h                            |    3 +
 include/linux/ipv6.h                               |   40 +-
 include/linux/libnvdimm.h                          |    9 +
 include/linux/lockd/lockd.h                        |    2 +-
 include/linux/netdevice.h                          |    3 +
 include/linux/pci.h                                |   14 +-
 include/linux/perf_event.h                         |    1 +
 include/linux/rculist.h                            |   29 +
 include/linux/sched.h                              |   16 +-
 include/linux/sched/rt.h                           |    2 +
 include/linux/sched/signal.h                       |    5 +-
 include/linux/sched/user.h                         |    3 +-
 include/linux/screen_info.h                        |    2 +
 include/linux/skbuff.h                             |   24 +-
 include/linux/soc/qcom/mdt_loader.h                |    6 +-
 include/linux/virtio.h                             |    2 +-
 include/net/bluetooth/coredump.h                   |    2 +
 include/net/cfg80211.h                             |   25 +
 include/net/gue.h                                  |   19 +-
 include/net/if_inet6.h                             |    2 -
 include/net/inet_connection_sock.h                 |   11 +-
 include/net/inet_sock.h                            |    1 +
 include/net/ip6_route.h                            |    8 +-
 include/net/mac80211.h                             |    5 +-
 include/net/netfilter/nf_conntrack.h               |    5 +
 include/net/netfilter/nf_conntrack_timeout.h       |   27 +-
 include/net/netfilter/nf_tables.h                  |    2 -
 include/net/netmem.h                               |   78 +-
 include/net/netns/xfrm.h                           |    2 +-
 include/net/nfc/hci.h                              |    2 +-
 include/net/nfc/nfc.h                              |    3 +-
 include/net/page_pool/helpers.h                    |   35 +-
 include/net/page_pool/types.h                      |    5 +-
 include/net/rose.h                                 |   12 +
 include/net/sock.h                                 |    8 +-
 include/net/tcp.h                                  |    4 +-
 include/sound/soc.h                                |    3 +-
 include/uapi/linux/landlock.h                      |   37 +-
 include/uapi/linux/nl80211.h                       |    5 +
 init/main.c                                        |   27 +-
 io_uring/net.c                                     |   41 +-
 io_uring/rw.c                                      |   32 +-
 io_uring/waitid.c                                  |   44 +-
 kernel/bpf/arraymap.c                              |    6 +-
 kernel/bpf/btf.c                                   |  140 +-
 kernel/bpf/crypto.c                                |    5 +-
 kernel/bpf/hashtab.c                               |  236 ++-
 kernel/bpf/memalloc.c                              |  106 +-
 kernel/bpf/offload.c                               |    2 +
 kernel/bpf/syscall.c                               |    5 +-
 kernel/cgroup/pids.c                               |    5 +
 kernel/dma/coherent.c                              |   13 +-
 kernel/dma/swiotlb.c                               |    4 +-
 kernel/events/core.c                               |   15 +-
 kernel/events/ring_buffer.c                        |   29 +-
 kernel/futex/pi.c                                  |   10 -
 kernel/locking/rtmutex_api.c                       |    2 +
 kernel/reboot.c                                    |   55 +-
 kernel/sched/core.c                                |   77 +-
 kernel/sched/sched.h                               |    9 +-
 kernel/signal.c                                    |   24 +-
 kernel/sysctl.c                                    |   31 -
 kernel/trace/ftrace.c                              |   57 +-
 kernel/trace/ring_buffer.c                         |  135 +-
 kernel/trace/trace.c                               |  155 +-
 kernel/trace/trace.h                               |  131 +-
 kernel/trace/trace_btf.c                           |   31 +-
 kernel/trace/trace_btf.h                           |    3 +-
 kernel/trace/trace_eprobe.c                        |   19 +-
 kernel/trace/trace_events_hist.c                   |  167 +-
 kernel/trace/trace_events_trigger.c                |  344 ++--
 kernel/trace/trace_functions.c                     |    2 +-
 kernel/trace/trace_probe.c                         |    5 +-
 kernel/trace/trace_stack.c                         |    2 +-
 kernel/workqueue.c                                 |    2 +-
 mm/backing-dev.c                                   |    5 +-
 mm/damon/vaddr.c                                   |    1 +
 mm/huge_memory.c                                   |   10 +
 mm/hugetlb.c                                       |   55 +-
 mm/khugepaged.c                                    |    6 -
 mm/madvise.c                                       |    8 +
 mm/memblock.c                                      |   18 +-
 mm/mlock.c                                         |    2 +-
 mm/mremap.c                                        |   12 +-
 mm/rmap.c                                          |   23 +-
 mm/secretmem.c                                     |  117 +-
 mm/vma.c                                           |    8 +
 net/8021q/vlan_dev.c                               |    5 +
 net/atm/pppoatm.c                                  |   42 +-
 net/bluetooth/bnep/core.c                          |   17 +-
 net/bluetooth/bnep/netdev.c                        |    8 +-
 net/bluetooth/coredump.c                           |   65 +-
 net/bluetooth/eir.c                                |   10 +-
 net/bluetooth/hci_codec.c                          |   36 +-
 net/bluetooth/hci_conn.c                           |   14 +-
 net/bluetooth/hci_core.c                           |   26 +-
 net/bluetooth/hci_sock.c                           |   20 +-
 net/bluetooth/hci_sync.c                           |    2 +
 net/bluetooth/iso.c                                |   53 +-
 net/bluetooth/l2cap_core.c                         |   10 +-
 net/bluetooth/mgmt.c                               |   27 +-
 net/bluetooth/rfcomm/core.c                        |    3 +-
 net/bluetooth/rfcomm/sock.c                        |   19 +-
 net/bluetooth/smp.c                                |   17 +
 net/bridge/br_cfm.c                                |   11 +-
 net/bridge/br_device.c                             |    1 -
 net/bridge/br_input.c                              |   35 +-
 net/bridge/br_mdb.c                                |    2 +
 net/bridge/br_mrp.c                                |   13 +-
 net/bridge/br_mst.c                                |   20 +-
 net/bridge/br_private.h                            |   26 +-
 net/bridge/br_stp_bpdu.c                           |    5 +-
 net/core/dev.c                                     |    2 +-
 net/core/devmem.c                                  |    1 +
 net/core/drop_monitor.c                            |    4 +-
 net/core/filter.c                                  |   46 +-
 net/core/neighbour.c                               |  241 ++-
 net/core/page_pool.c                               |    9 +-
 net/core/skbuff.c                                  |   41 +-
 net/core/skmsg.c                                   |    4 +
 net/core/sock.c                                    |   25 +-
 net/core/sock_map.c                                |    1 +
 net/dccp/ipv6.c                                    |    4 +-
 net/dccp/timer.c                                   |    4 +-
 net/ipv4/arp.c                                     |    1 +
 net/ipv4/esp4.c                                    |    6 +
 net/ipv4/fib_semantics.c                           |   59 +-
 net/ipv4/fou_core.c                                |    4 +
 net/ipv4/icmp.c                                    |   17 +-
 net/ipv4/inet_connection_sock.c                    |   13 +-
 net/ipv4/inet_diag.c                               |    4 +-
 net/ipv4/ip_gre.c                                  |   12 +
 net/ipv4/ipconfig.c                                |   90 +-
 net/ipv4/ipmr.c                                    |    3 +-
 net/ipv4/ipmr_base.c                               |    2 +-
 net/ipv4/sysctl_net_ipv4.c                         |    4 +-
 net/ipv4/tcp_input.c                               |    3 +-
 net/ipv4/tcp_ipv4.c                                |    4 +-
 net/ipv4/tcp_output.c                              |    3 +
 net/ipv4/tcp_timer.c                               |    5 +-
 net/ipv4/xfrm4_input.c                             |    2 -
 net/ipv6/addrconf.c                                |    3 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/esp6.c                                    |    6 +
 net/ipv6/exthdrs_core.c                            |    3 +
 net/ipv6/inet6_connection_sock.c                   |    2 +-
 net/ipv6/ip6_flowlabel.c                           |   67 +-
 net/ipv6/ip6_gre.c                                 |    2 +-
 net/ipv6/ip6_output.c                              |    3 +-
 net/ipv6/ip6mr.c                                   |    2 +-
 net/ipv6/ipv6_sockglue.c                           |    9 -
 net/ipv6/mcast.c                                   |  253 +--
 net/ipv6/netfilter/ip6t_rpfilter.c                 |    2 +-
 net/ipv6/netfilter/ip6t_rt.c                       |   11 +-
 net/ipv6/route.c                                   |   33 +-
 net/ipv6/seg6.c                                    |    4 +-
 net/ipv6/seg6_local.c                              |    3 +
 net/ipv6/tcp_ipv6.c                                |   21 +-
 net/ipv6/xfrm6_input.c                             |    2 -
 net/ipv6/xfrm6_output.c                            |   10 +-
 net/llc/llc_c_ac.c                                 |    2 +-
 net/llc/llc_s_ac.c                                 |    4 +
 net/llc/llc_sap.c                                  |    8 +-
 net/mac80211/cfg.c                                 |   55 +-
 net/mac80211/debugfs.c                             |    2 +-
 net/mac80211/debugfs_netdev.c                      |    9 +
 net/mac80211/ieee80211_i.h                         |    5 +-
 net/mac80211/iface.c                               |   76 +-
 net/mac80211/main.c                                |    4 +
 net/mac80211/mesh.c                                |   34 +-
 net/mac80211/offchannel.c                          |    7 +
 net/mac80211/pm.c                                  |    8 +-
 net/mac80211/scan.c                                |   24 +-
 net/mac80211/tdls.c                                |   19 +-
 net/mac80211/tx.c                                  |   66 +-
 net/mac80211/util.c                                |    3 +-
 net/mctp/route.c                                   |    2 +-
 net/mptcp/Makefile                                 |    2 +-
 net/mptcp/ctrl.c                                   |    4 +-
 net/mptcp/mib.c                                    |    5 +
 net/mptcp/mib.h                                    |    5 +
 net/mptcp/options.c                                |    6 +-
 net/mptcp/{pm_netlink.c => pm_kernel.c}            |   71 +-
 net/mptcp/pm_userspace.c                           |   32 +-
 net/mptcp/protocol.c                               |   95 +-
 net/mptcp/protocol.h                               |   36 +-
 net/mptcp/subflow.c                                |   10 +-
 net/netfilter/ipvs/ip_vs_core.c                    |    6 +
 net/netfilter/nf_conntrack_core.c                  |    6 +-
 net/netfilter/nf_conntrack_netlink.c               |    3 +-
 net/netfilter/nf_conntrack_timeout.c               |   27 +-
 net/netfilter/nf_flow_table_core.c                 |   12 +-
 net/netfilter/nf_flow_table_offload.c              |    7 +-
 net/netfilter/nf_tables_api.c                      |   59 +-
 net/netfilter/nfnetlink_cttimeout.c                |  114 +-
 net/netfilter/nfnetlink_queue.c                    |    8 +-
 net/netfilter/nft_chain_filter.c                   |   50 +-
 net/netfilter/nft_ct.c                             |    7 +-
 net/netfilter/nft_nat.c                            |    2 +-
 net/netfilter/nft_synproxy.c                       |    3 +-
 net/netfilter/xt_CT.c                              |    2 +-
 net/netlink/genetlink.c                            |   29 +-
 net/nfc/core.c                                     |   15 +-
 net/nfc/digital_dep.c                              |    8 +-
 net/nfc/llcp.h                                     |    1 +
 net/nfc/llcp_commands.c                            |    2 +-
 net/nfc/llcp_core.c                                |  173 +-
 net/nfc/llcp_sock.c                                |   67 +-
 net/nfc/nci/core.c                                 |   10 +-
 net/nfc/netlink.c                                  |    7 +-
 net/nfc/nfc.h                                      |    3 +-
 net/openvswitch/conntrack.c                        |   39 +-
 net/packet/af_packet.c                             |  108 +-
 net/packet/internal.h                              |    2 +-
 net/rds/ib_cm.c                                    |    2 +-
 net/rds/ib_frmr.c                                  |   11 +-
 net/rose/af_rose.c                                 |   49 +-
 net/rose/rose_in.c                                 |    6 +
 net/rose/rose_loopback.c                           |   61 +-
 net/rose/rose_timer.c                              |   87 +-
 net/sched/act_api.c                                |   13 +-
 net/sched/act_ct.c                                 |   41 +-
 net/sched/act_gate.c                               |   30 +-
 net/sched/cls_u32.c                                |   12 +-
 net/sched/sch_hfsc.c                               |   22 +
 net/sched/sch_hhf.c                                |    9 +-
 net/sched/sch_teql.c                               |    7 +-
 net/sctp/associola.c                               |   15 +-
 net/sctp/input.c                                   |    7 +-
 net/sctp/ipv6.c                                    |    8 +-
 net/sctp/sm_sideeffect.c                           |   37 +-
 net/sctp/sm_statefuns.c                            |    2 +
 net/smc/smc.h                                      |    6 +-
 net/smc/smc_clc.h                                  |    2 +-
 net/smc/smc_core.c                                 |    4 +-
 net/smc/smc_core.h                                 |    4 +-
 net/smc/smc_ib.c                                   |   10 +-
 net/tipc/group.c                                   |    4 +-
 net/tipc/monitor.c                                 |    3 +-
 net/tls/tls_sw.c                                   |    6 +-
 net/wireless/chan.c                                |  389 ++---
 net/wireless/core.c                                |    2 +
 net/wireless/lib80211_crypt_tkip.c                 |   13 +-
 net/wireless/nl80211.c                             |   60 +-
 net/wireless/scan.c                                |   22 +-
 net/wireless/util.c                                |   68 +-
 net/xdp/xskmap.c                                   |    2 +-
 net/xfrm/espintcp.c                                |    6 +-
 net/xfrm/xfrm_input.c                              |   63 +-
 net/xfrm/xfrm_state.c                              |    9 +-
 net/xfrm/xfrm_user.c                               |   37 +-
 security/ipe/eval.c                                |   12 +-
 security/ipe/eval.h                                |    2 +-
 security/ipe/fs.c                                  |    4 -
 security/ipe/hooks.c                               |   22 +-
 security/ipe/policy_fs.c                           |    4 +
 security/keys/encrypted-keys/encrypted.c           |   20 +-
 security/keys/gc.c                                 |    4 +-
 security/keys/request_key_auth.c                   |   12 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   12 +-
 security/landlock/fs.c                             |   18 +-
 security/landlock/net.c                            |   14 +
 security/selinux/avc.c                             |    5 +-
 security/selinux/hooks.c                           |  158 +-
 security/selinux/include/objsec.h                  |   10 +-
 sound/core/init.c                                  |    3 +-
 sound/core/pcm_timer.c                             |    7 +-
 sound/hda/ext/hdac_ext_stream.c                    |    4 +-
 sound/pci/hda/hda_controller.c                     |    2 +-
 sound/pci/hda/patch_realtek.c                      |    9 +
 sound/soc/codecs/aw88261.c                         |   30 +-
 sound/soc/codecs/aw88261.h                         |    6 -
 sound/soc/codecs/hdmi-codec.c                      |    6 +-
 sound/soc/codecs/rt712-sdca-dmic.c                 |   14 +-
 sound/soc/sdw_utils/soc_sdw_utils.c                |    2 +-
 sound/soc/soc-pcm.c                                |   18 +-
 sound/soc/tegra/tegra210_mixer.c                   |   10 +-
 sound/soc/ux500/ux500_msp_i2s.h                    |    4 +-
 sound/usb/6fire/chip.c                             |   40 +-
 sound/usb/6fire/comm.c                             |   42 +-
 sound/usb/6fire/comm.h                             |    2 +-
 sound/usb/6fire/midi.c                             |   64 +-
 sound/usb/6fire/midi.h                             |    2 +-
 sound/usb/6fire/pcm.c                              |  221 +--
 sound/usb/6fire/pcm.h                              |    5 +-
 sound/usb/bcd2000/bcd2000.c                        |   33 +-
 sound/usb/card.h                                   |    3 +-
 sound/usb/endpoint.c                               |   16 +-
 sound/virtio/virtio_card.c                         |    4 +-
 tools/bootconfig/main.c                            |   32 +-
 tools/lib/bpf/libbpf.c                             |    7 +
 tools/lib/bpf/relo_core.c                          |   58 +-
 tools/perf/tests/shell/stat_bpf_counters.sh        |    2 +-
 .../selftests/arm64/mte/check_gcr_el1_cswitch.c    |    2 +-
 .../testing/selftests/bpf/prog_tests/linked_list.c |    4 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    4 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |    4 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   82 +-
 tools/testing/selftests/cgroup/cgroup_util.h       |    8 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   78 +
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |    2 +-
 tools/testing/selftests/landlock/fs_test.c         | 1679 +++++++++++++++++++-
 tools/testing/selftests/landlock/net_test.c        |  169 +-
 tools/testing/selftests/mm/memfd_secret.c          |   30 +-
 tools/testing/selftests/nci/nci_dev.c              |   45 +-
 virt/kvm/kvm_main.c                                |   30 +-
 875 files changed, 14469 insertions(+), 7651 deletions(-)


