Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059978;
	b=i9qJHngbmzh6BGXsvNfdy2NIM4Dljk3eKAAWHkVxETL0eHhxjS7fKHE+wx1OiQ6/Hsco
	 ehRBjpTCHRfMdmWOO+rtTpYyL+kgXAGAgbrHl6iA96NmFBR99oaIJtzkRaTjo77zI/fmZ
	 Wci4in6LdC2E9svVrdw/OF2EIulAIqrKzCLL2Sm4HvkdQsjzEiq0wbCRRresLfA4xrHuq
	 /4uA0zZHyLXpaUyb/nYH3LxIXohDK/VtJxrPk5G+hE8gE7oYAUI+a08FvhCK8OJU5S8P7
	 C8QON97plI70/YIFdOemC5xov+VMAizue00IHSSVAhoaE+eJzP2jJK6pQKQwz4iycbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=Zh/Ft9p6RjVCuJDW1anGQQHQbgauiUwleKKsQvD8MQ8=;
	b=sL0cOwd+273HZaC4M8D5owUp10f6JbYW+ZBDBXhRXXd/hW0hhYi6/GSIpzwQnX/406aB
	 1AqKfS2EpufHsxiMqQpLClWdYRBlOhPv0wMuHWsXboxWmzAi3MJNUf+ALDJs/vjUmiDCR
	 oXJqosvpCtBLBJtZfwoBdAEroqjwgbkkhHtUmgRrAVreevwgSTk/4fEfbAJPsMRe2AJS2
	 pUVJ5mamajMoCvVagFQqg1dR7XgdVhU3ZIQ1df++AOLRniVwprmUPG9vyRIcE+aQ19RfK
	 ho2uEE+jwIxI/FeTTam/P35TmQ8QwQTXHassCbaG+8S/pfmzUjyfznK8mZTZjtEnxng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LSbsqt68;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188C4606A335;
	Sat,  7 Nov 2026 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LSbsqt68
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3591F0089F;
	Sat,  7 Nov 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059976;
	bh=Zh/Ft9p6RjVCuJDW1anGQQHQbgauiUwleKKsQvD8MQ8=;
	h=From:To:Cc:Subject:Date;
	b=LSbsqt68uqs7YjvQeQ7tjiHwgxLk6uTddY/rlRzob42JVDZPvnBlAlMPu1mtTrmLg
	 t7sSzUbrHRCCQdsftyj5/UtvK0cAXG2UGgixsA1241AZ3WDT1LORIVXI2BsRkI26zX
	 L2sl509DzU8thjr185iALWw+kFCx+s/XuEbFpopE=
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
Subject: [PATCH 6.18 000/869] 6.18.63-rc1 review
Date: Sat,  7 Nov 2026 08:44:42 -0500
Message-ID: <20261107134852.069646174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.63-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.63-rc1
X-KernelTest-Deadline: 2026-11-09T13:49+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.63 release.
There are 869 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.63-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.63-rc1

John Johansen <john.johansen@canonical.com>
    apparmor: on failed load ensure profile files are removed before parent

John Johansen <john.johansen@canonical.com>
    apparmor: fix uninitialized variable warning in aa_inherit_files

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: read the xattr entry hash before defragmenting the bucket

Avi Weiss <thnkslprpt@gmail.com>
    init/bootconfig: pass init arguments in documented order

Amir Goldstein <amir73il@gmail.com>
    fs: don't fail __d_obtain_alias() for unlinked inodes

Hungyu Lin <dennylin0707@gmail.com>
    fs: skip copy_file_range write limits when there is no data

Edvard Conrad <edvard@tuta.io>
    fs: let backing files inherit FMODE_NONOTIFY from the user file

Daehyeon Ko <4ncienth@gmail.com>
    splice: avoid stale f_pos writeback on error

Chris Mason <mason@kernel.org>
    iov_iter: fix NULL deref in iov_iter_alignment()

Christian Brauner <brauner@kernel.org>
    backing-file: enforce append-only and immutable backing inodes

Chris Mason <mason@kernel.org>
    aio: fix NULL deref when a fault races ring truncation

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: remove fs entries created by a failed policy load

Kyle Zeng <kylebot@openai.com>
    tcp: fix reordering addition overflow in MTU probing

Kyle Zeng <kylebot@openai.com>
    net/packet: check TX_RING fragments before memory accounting

Guanglei Zhu <zhugl3@xiaopeng.com>
    apparmor: check accept index + 1 is in bounds

Li RongQing <lirongqing@baidu.com>
    apparmor: avoid potential double free when remapping DFA tables

John Johansen <john.johansen@canonical.com>
    apparmor: fix refcount leak in aa_get_newest_profile()

Zhiling Zou <zhilinz@nebusec.ai>
    tcp: check congestion control restriction first

Christian Brauner <brauner@kernel.org>
    proc: don't let an entry below /proc/<pid>/net be a mountpoint

Kunhai Dai <daikunhai@didiglobal.com>
    blk-iocost: abort weight transfer on invalid donation weights

Christian Brauner <brauner@kernel.org>
    userns: don't drop the exec securebits

Josef Bacik <josef@toxicpanda.com>
    mount: refuse setns() with a shared fs_struct again

Linmao Li <lilinmao@kylinos.cn>
    r8152: Use BMSR to detect the link state

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: don't revalidate inherited files under files->file_lock

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: fix NULL ctx->peer derefs in unix socket ctx updates

Yongjian Wang <echoowall@gmail.com>
    Revert "net: advertise TCP MSS from the configured MTU, not the learned PMTU"

Avi Weiss <thnkslprpt@gmail.com>
    irqchip/irq-msi-lib: Free wired MSI descriptors

Avi Weiss <thnkslprpt@gmail.com>
    irqchip/riscv-imsic: Report successful hardware retrigger

Eric Biggers <ebiggers@kernel.org>
    fsverity: Be more careful with return value of ->get_verity_descriptor()

Fang Xieyan <fangxy@xiaopeng.com>
    kgdb: Fix buffer overflow in the qRcmd packet handler

Fang Xieyan <fangxy@xiaopeng.com>
    kgdb: Fix buffer overflow in the 'M' and 'X' packet handlers

Fang Xieyan <fangxy@xiaopeng.com>
    kgdb: Fix buffer overflow in the 'm' packet handler

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: Free the old negotiation state when restarting authentication

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: Finish the blk plug when integrity allocation fails

Seiji Nishikawa <snishika@redhat.com>
    nvme-tcp: fix io_work priority inversion when send_mutex is held

Martin Belanger <martin.belanger@dell.com>
    nvme-tcp: start error recovery when read_sock fails

Guixin Liu <kanie@linux.alibaba.com>
    nvmet-fc: Tear down the association when the admin queue allocation fails

Shao Mingyin <shao.mingyin@zte.com.cn>
    nvmet-auth: fix error handling on CHALLENGE failure

Andrea Parri <parri.andrea@gmail.com>
    nvmet: pci-epf: require SGLs to match the command data length

Andrea Parri <parri.andrea@gmail.com>
    nvmet: pci-epf: report transport errors in command completions

Andrea Parri <parri.andrea@gmail.com>
    nvmet-fc: only send read data for successful commands

Weiming Shi <bestswngs@gmail.com>
    nvmet-rdma: reject short connection requests

Tristan Madani <tristan@talencesecurity.com>
    ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Keep runtime PM state in sync across codec remove/probe

Hongling Zeng <zenghongling@kylinos.cn>
    ntfs3: fix mapping pairs bounds check for alignment

Hyeontae Lee <wonju345@naver.com>
    fs/ntfs3: bound DeleteAttribute asize against rec->used in do_action

Hyeontae Lee <wonju345@naver.com>
    fs/ntfs3: bound CreateAttribute asize against record_size in do_action

David Yang <mmyangfl@gmail.com>
    net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring

Xia Yan <yanxia@cmss.chinamobile.com>
    macvlan: fix passthru promiscuity accounting while down

Kamil Sawicki <user148783812897@gmail.com>
    net: limit priority VLAN untag depth

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: evict the queues only once for CRIU PROCESS_INFO

Jiale Yao <yaojiale02@163.com>
    drm/amdkfd: validate SRAT subtables before parsing

Avi Weiss <thnkslprpt@gmail.com>
    drm/amd/display: Initialize missing TD-LUT programming inputs

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: split vram_pages of SVM ranges prefetched without a GPU mapping

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: reject CS chunks too large for kvmalloc()

Luigi Lauro <luigi.lauro@gmail.com>
    drm/amd/display: take a runtime PM reference only when a CRTC turns on

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    drm/amdkfd: stop restore retries on device unplug

lvyating <lv.yating@zte.com.cn>
    perf machine: Fix NULL deref in thread__resolve_callchain_sample()

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64/mm: restrict transparent contpte mappings to valid PTEs

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: stats: Fix potential out-of-bounds access in deferred reset

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix perf hardware breakpoint failure via installation

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Only send SIGTRAP signal if necessary in do_watch()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix architectural naming typo for CSR_FWPS_SKIP

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix bitmask corruption in update_bp_registers()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Remove redundant call in update_bp_registers()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Remove arch-specific __smp_mb__{before,after}_atomic()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use pa_to_nid()/nid_to_addrbase() rather than hard-code

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Call cpu_final_simd() with pure_initcall()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Balance the runtime PM disable in codec remove

Eric Dumazet <edumazet@kernel.org>
    ixgbe: reserve TX timestamp after skb preparation

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda: Reject codec reset on ASoC (ext_ops) buses

Sinan Turunc <enscrpt@pm.me>
    ALSA: usb-audio: Bound packet copies by the PCM buffer size

Dominik Maier <dmnk@google.com>
    loop: check for read-write open mode on LOOP_SET_STATUS in lo_compat_ioctl()

Paul Moses <p@1g4.org>
    xsk: restore UMEM flags after failed pool assignment

Yingjie Wang <1075151112@qq.com>
    tcp: limit tcp_tso_rtt_log to a valid shift count

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: clock: ma35d1: Document the missing crystal inputs

Ido Schimmel <idosch@nvidia.com>
    ipmr: fully initialize the synthetic IP header in ipmr_get_route()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bonding: fix out-of-bounds read of arp_ip_target

Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
    net: usb: pegasus: check rx pkt_len against the received length

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wsa883x: Accept temperatures across the full trim range

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wsa884x: Accept temperatures across the full trim range

Val Packett <val@packett.cool>
    ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch

Chao Yu <chao@kernel.org>
    f2fs: fix to update superblock crc in sanity_check_area_boundary()

Alex Markuze <amarkuze@redhat.com>
    ceph: fix uninitialized err in ceph_netfs_issue_read()

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: validate encoded xattr name lengths

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: validate MDS reply fragtree split array length

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: bound name skips in ceph_mdsmap_decode() by the message end

sung byeongchan <tjdqudcks0424@naver.com>
    ceph: validate fscrypt auth blob length

Venky Shankar <vshankar@redhat.com>
    ceph: don't fail write_begin with -EAGAIN after flushing old snapc

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    ceph: clamp MDS reply result code to the errno range

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    libceph: fix out-of-bounds reads from repeated CRUSH bucket entries

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ceph: fix 32-bit overflow in readdir reply count check

Wentao Liang <vulab@iscas.ac.cn>
    ceph: Fix mds session leak in __open_export_target_session()

Wentao Liang <vulab@iscas.ac.cn>
    ceph: Fix xattr buffer leak in __send_cap()

Xiang Mei <xmei5@asu.edu>
    ceph: fix integer overflow in the snap trace bounds check

Yogesh Gaur <yogeshgaur.83@gmail.com>
    libceph: reject an initial monmap with no monitors

Felix Hoffmann <f3lix.dev@gmx.de>
    libceph: reject mismatched CRUSH weight-set sizes

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix multiple unsafe decodes in ceph_oloc_decode()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix unsafe decode in ceph_redirect_decode()

Xiubo Li <xiubo.li@clyso.com>
    libceph: only set read_from_replica on read requests

Xiang Mei <xmei5@asu.edu>
    ceph: require the dentry lease record to cover struct ceph_mds_reply_lease

Xiang Mei <xmei5@asu.edu>
    ceph: reject mdsmaps that claim more than CEPH_MAX_MDS ranks

Guanglei Zhu <zhugl3@xiaopeng.com>
    ceph: fix out-of-bounds read in ceph_netfs_issue_op_inline()

Max Kellermann <max.kellermann@ionos.com>
    ceph: avoid pending truncate during nonblocking cap acquire

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Set HCR_EL2.BSU to Inner Shareable for guests

Hungyu Lin <dennylin0707@gmail.com>
    time/namespace: Fix overflow when converting absolute deadlines

Hungyu Lin <dennylin0707@gmail.com>
    timers/itimer: Keep a nonzero value at CPU timer expiry

Wang Haoran <haoranwangsec@gmail.com>
    fbdev: atmel_lcdfb: fix list_first_entry() on possibly empty modelist in probe

Baokun Li <libaokun@linux.alibaba.com>
    fscrypt: Fix missing barrier in fscrypt_find_mode_key()

Siddharth Chintamaneni <sidchintamaneni@gmail.com>
    mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline

Yunhui Cui <cuiyunhui@bytedance.com>
    riscv: mm: exclude invalid THP PMDs from page table check

Gregory Price (Meta) <gourry@gourry.net>
    mm/mempolicy: apply bind policies against the scoped allocation zone

Gregory Price (Meta) <gourry@gourry.net>
    mm/vmscan: reclaim every zone in per-node proactive reclaim

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: correctly uncharge accountable VMAs in error path

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: populate calculated fields in vrm state correctly

Nickolai Zeldovich <nickolai@csail.mit.edu>
    mm/truncate: fix the zeroing end of pagecache_isize_extended()

Rik van Riel <riel@surriel.com>
    mm/page_alloc: count guard pages as free again when their buddy merges

Jiayuan Chen <jiayuan.chen@shopee.com>
    mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache

Vernon Yang <yanglincheng@kylinos.cn>
    mm: vmscan: don't count per-node proactive reclaim as memory pressure

Weilin Tong <tongweilin@linux.alibaba.com>
    ipc/shm: fix RSS accounting for hugetlb shared memory

Pedro Falcato <pfalcato@suse.de>
    mm/madvise: atomically clear the young bit on THP MADV_COLD

Harry Yoo (Meta) <harry@kernel.org>
    mm/percpu: account full object size for percpu memory allocations

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references

Nickolai Zeldovich <nickolai@csail.mit.edu>
    mm/mlock: use a long for the page count in mlock_fixup()

Wei Yang <albinwyang@tencent.com>
    mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()

David Hildenbrand (Arm) <david@kernel.org>
    mm: disallow ioremap'ing ordinary RAM in generic_access_phys()

Hongfu Li <lihongfu@kylinos.cn>
    mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat

David Hildenbrand (Arm) <david@kernel.org>
    mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA

Josef Bacik <josef@toxicpanda.com>
    mm/hugetlb: don't clear the resv_map of a VMA whose lock is held

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: remove zero-address nodes from IP tree on teardown

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: snapshot the dentry name while tracing file release

Caleb Kan <ckan@cloudflare.com>
    stackdepot: stop preallocating after the final pool

Hungyu Lin <dennylin0707@gmail.com>
    compat: avoid double rounding in times()

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Remove completed-without-interrupt path in ufshcd_abort()

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Remove an always-false WARN_ONCE()

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    scsi: libiscsi_tcp: Prevent R2T range check overflow

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Clear stale UIC result byte before peer DME retries

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: bsg: Clear the reply buffer before use

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: bsg: Complete the job on error

yanxia <yanxia@cmss.chinamobile.com>
    veth: fix stale peer max_mtu on XDP program replacement

Igor Velkov <iav@iav.lv>
    genirq/kexec: Do not take the bus lock of an interrupt chip on the crash path

Aamir Ahmed <elb12345@hotmail.co.uk>
    gve: fix out-of-bounds read in gve_get_flow_rule_entry()

Sasha Levin <sashal@kernel.org>
    cgroup: don't kill migrated processes through their exiting threads

Thomas Weißschuh (Schneider Electric) <thomas.weissschuh@linutronix.de>
    timekeeping: Update offsets on sequence counter retry in ktime_get_update_offsets_now()

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() signal path

Pufan Jin <cyan2254650260@gmail.com>
    spi: zynq-qspi: fix address buffer corruption and support 4-byte address

Christian Marangi <ansuelsmth@gmail.com>
    i2c: mt7621: fix copying uninitialized kernel stack with reduced page_len

Alex Kazinsky <a.kazinsky@ideco.ru>
    ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks

Jean Delu <jeandelu@tutamail.com>
    parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer

Adrian Ambrozewicz <aambrozewicz@nvidia.com>
    gpiolib: don't report -ENOMEM for a requested line without a label

Pei Xiao <xiaopei01@kylinos.cn>
    tpm: fix zero-length read discarding the pending response

Pei Xiao <xiaopei01@kylinos.cn>
    tpm: tpm_nsc: stop using the cleanup callback as dev.release

Pei Xiao <xiaopei01@kylinos.cn>
    tpm: tpm_nsc: fix NULL pointer dereference on init failure

Navon John Lukose <navonjohnlukose@gmail.com>
    i2c: designware: queue only one read command for block reads

Ma Ke <make_ruc2021@163.com>
    i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()

Tristan Madani <tristan@talencesecurity.com>
    cpufreq: intel_pstate: cancel HWP notify work in driver cleanup

Nickolai Zeldovich <nickolai@csail.mit.edu>
    ucount: take the rlimit reference before checking the limit

Christian Brauner <brauner@kernel.org>
    listmount: don't wrap around with a U64_MAX cursor

Christian Brauner <brauner@kernel.org>
    statmount: don't copy the reserved empty string past the buffer

Chuck Lever <chuck.lever@oracle.com>
    exportfs: Release the get_name() directory file synchronously

Henry Martin <bsdhenrymartin@gmail.com>
    tipc: fix broadcast sender hang on last acker departure

Liu Chao <liuc63@xiaopeng.com>
    net: wwan: iosm: validate msg_head before indexing msg_ring

Yu Zhang <yuz08559@gmail.com>
    nvmet: take subsys->lock while force-reconnecting in nvmet_subsys_attr_qid_max_store()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    sh: maple: Use the matching IRQ cookie when invoking free_irq()

Henrik Enquist <henrik.enquist@gmail.com>
    ALSA: aloop: Update the PCM Slave controls for a matching playback

Julian Sun <sunjunchao@bytedance.com>
    writeback: clear old wb dirty state after inode switches

Julian Sun <sunjunchao@bytedance.com>
    writeback: reset dirtied_when when switching wbs

Bartu Alev <bartualev@gmail.com>
    platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming

Michael Kelley <mhkelley58@gmail.com>
    Documentation: hyperv: Update documentation for sending VMBus packets

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: initialize heartbeat regions before publishing them

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: deal with legacy signed xattr name hash values

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: use the stored hash when checking xattr bucket collision

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: deal with legacy signed dir index name hash values

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reserve value tree metadata when moving an xattr into the inode

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reserve metadata for a new xattr block and its value tree

Matt Turner <mattst88@gmail.com>
    alpha: determine tininess after rounding in the FP emulation

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: queue the copied chunk when smc_tx_sendmsg() faults

Yingjie Wang <1075151112@qq.com>
    net: unix: reject negative max_dgram_qlen values

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    net/rds: ib: don't enable IRQs in rds_ib_conn_free()

Guangshuo Li <lgs201920130244@gmail.com>
    PCI: qcom-ep: Deinitialize endpoint on remove

Tingjie Zhong <catme0w@live.cn>
    fbdev: bitblit: Fix glyph clipping when fbcon pans

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: do not restart DAD for a dead ifaddr

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: initialize temporary ifaddr before publication

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: serialize address publication with device teardown

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: remove ifaddr from hash during ifdown list cleanup

Zhen Han <Zhen.Han@amd.com>
    drm/amdkfd: correct vram_available calculation

Daniel Phillips <daniel.phillips@amd.com>
    amdkfd: Fix memory availability double accounting of kfd pinned objects

John Fisher <jfisher84@gmail.com>
    drm/amdgpu: wait for pending page table updates before switching a VM to CPU updates

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: wait for a GPU reset before freeing a BO

Keita Morisaki <kmta1236@gmail.com>
    drm/amd/display: Fix swap in median3() for DSC rate control

Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>
    drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: don't drop an SVM CWSR reference that was never taken

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: reapply umd profile state after recovery

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: don't WARN when removing an unallocated MST payload

Henry Martin <bsdhenrymartin@gmail.com>
    drm/amdkfd: fix doorbell allocation race creating duplicate allocations

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset VI ASIC on Apple boards with VRAM at 0

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset CIK ASIC on Apple boards with VRAM at 0

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset SI ASIC on MacBookPros with VRAM at 0

Luigi Lauro <luigi.lauro@gmail.com>
    drm/amdgpu: require _PR3 for BOCO

Nirmoy Das <nirmoyd@nvidia.com>
    blk-mq: clear stale inactive flag on hctx reuse

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: pca953x: Handle direction register read errors in IRQ paths

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: davinci: Clear interrupt status in every bank on suspend

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Handle period elapsed calls outside the locks

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    gpiolib: Free chip resources when allocating the label fails

Takashi Iwai <tiwai@suse.de>
    ALSA: emux: Stop voices before freeing zones in all cases

Wang Yan <wangyan01@kylinos.cn>
    ALSA: mtpav: restore negation dropped in guard() conversion

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: compress: reject restarting an ACTIVE task via origin_seqno

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: compress: add missing OPEN-state gate to SET_METADATA

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: compress: reject buffer geometry change on gapless next_track

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: compress: fix buffer leak on failed SET_PARAMS

Sorah Fukumori <her@sorah.jp>
    net: gro: don't chain linear parts larger than gso_size into frag_list

Jamal Hadi Salim <jhs@mojatatu.com>
    netdevsim: reject cls_bpf programs bound to another device

Kir Kolyshkin <kolyshkin@gmail.com>
    cgroup: fix cgroup.kill for exited thread group leader

Alexander Kochetkov <al.kochet@gmail.com>
    Revert "Input: matrix_keypad - force switch rows to input mode"

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: always accept EV_SYN in input_event()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (acpi_power_meter) Fix 18.45 TW bug

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (sht3x) Return the consumed count for heater writes

Igor Velkov <iav@iav.lv>
    rtc: pcf8563: pass the driver data to the alarm interrupt handler

Ma Ke <make_ruc2021@163.com>
    platform/x86/amd/pmc: Fix RTC reference leak in amd_pmc_verify_czn_rtc()

Gregory Price <gourry@gourry.net>
    rtc: cmos: Disable ACPI RTC event before handling it

Jianyun Gao <jianyungao89@gmail.com>
    dax: fix wrong error code returned from dax_dedupe_file_range_compare()

Seongjae Jeong <jsjlee1020@gmail.com>
    f2fs: fix submit accounting for IPU writeback

Wenjie Qi <qwjhust@gmail.com>
    f2fs: flush SIT journal during filesystem resize

Jiale Yao <yaojiale02@163.com>
    hwmon: (gigabyte_waterforce) reject short input reports

Ximing Zhang <xzhangjr@gmail.com>
    hwmon: (coretemp) Fix handling of isolated SMT siblings

Kyle Zeng <kylebot@openai.com>
    netfilter: nf_reject: initialize IPCB at inet ingress

George Christidis <gxristidis@gmail.com>
    ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14 UX3402VA

Adrian Ambrozewicz <aambrozewicz@nvidia.com>
    gpiolib: cdev: don't set GPIOD_FLAG_IS_OUT

Nickolai Zeldovich <nickolai@csail.mit.edu>
    lib/buildid: reject file offsets that do not fit in pgoff_t

Sanan Hasanov <sanan.hasanov@ucf.edu>
    hwmon: (corsair-cpro) Make wait_input_report_lock IRQ safe

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (sht4x) Reject incomplete heater command transfers

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (sht4x) Fix jiffies wraparound in heater-ready check

Weibin Liu <liuwb@xiaopeng.com>
    spi: ch341: handle transfers without a TX or RX buffer

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/via: Apply runtime PM workaround for ASUS X55A

Magnus Lindholm <linmag7@gmail.com>
    alpha: do not skip TLB shootdown IPIs for kthread-borrowed mms

Magnus Lindholm <linmag7@gmail.com>
    alpha: do not clear remote MMU contexts in migrate_flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: invalidate the local context in flush_icache_user_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: invalidate the local context in flush_tlb_mm()

Magnus Lindholm <linmag7@gmail.com>
    alpha: fix the local TLB invalidate in the UP flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: fix the local TLB invalidate in flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: invalidate the local context in flush_tlb_page()

Magnus Lindholm <linmag7@gmail.com>
    alpha: only use a targeted tbi() when the target mm is really current

Magnus Lindholm <linmag7@gmail.com>
    alpha: run check_mmu_context() from finish_arch_post_lock_switch()

Magnus Lindholm <linmag7@gmail.com>
    alpha: load the MMU context when switch_mm() switches the current task

Matt Turner <mattst88@gmail.com>
    alpha: handle VM_FAULT_HWPOISON in do_page_fault()

Brandon Williams <turbine.bmw@gmail.com>
    power: supply: qcom_battmgr: Notify charger supplies of online changes

Tim Douglas <me@timdoug.com>
    power: supply: generic-adc-battery: fix status with no supplier

Andrew Pam <andrew@fastmailteam.com>
    power: supply: cros_charge-control: restore EC state on resume

Fabricio Akio <fabricioakio@gmail.com>
    power: supply: qcom_smbx: set the charge enable after software control

Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>
    ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Skip events until fully initialized

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix subflow bitfield misuse

Quanye Yang <quanyeyang@proton.me>
    mptcp: reset msk state on early connect failure

Kees Cook <kees@kernel.org>
    ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again

sonotri <sono7ri@gmail.com>
    ublk: pin module while release work is pending

Chengfeng Ye <nicoyip.dev@gmail.com>
    fuse: fix copy_file_range reply handling race

Fan Wu <fanwu01@zju.edu.cn>
    virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree

Joanne Koong <joannelkoong@gmail.com>
    fuse: don't launder folios of a bad inode

Huacai Chen <chenhuacai@kernel.org>
    cpufreq: loongson3: Replace IOCSR read/write with MMIO ones

Huacai Chen <chenhuacai@kernel.org>
    cpufreq: loongson3: Use global physical CPU ID in get/target callbacks

Huacai Chen <chenhuacai@kernel.org>
    cpufreq: loongson3: Replace per-package mutex with per-node

Huacai Chen <chenhuacai@kernel.org>
    cpufreq: loongson3: Adjust the width of id and val in smc_message

Huacai Chen <chenhuacai@kernel.org>
    cpufreq: loongson3: Make this driver depend on MACH_LOONGSON64

Shubham Antil <shubham@octane.security>
    RDS/IB: validate receive fragment completions

Seung Min Shin <guncraft2000@naver.com>
    sctp: hold transport reference across connect wait

Zixuan Chai <petalzu987@gmail.com>
    ipv6: defrag: orphan skb before queuing

Josef Bacik <josef@toxicpanda.com>
    net: skbuff: don't BUG() on a bad csum_start in skb_copy_and_csum_dev()

Ming Lei <tom.leiming@gmail.com>
    ublk: reset the FETCH round under ub->mutex

Ming Lei <tom.leiming@gmail.com>
    ublk: reset the FETCH round in release also without a disk

Jianyun Gao <jianyungao89@gmail.com>
    dax: fix dax_range_compare_iter() to use correct size and address offset

Jianyun Gao <jianyungao89@gmail.com>
    dax: Return errors from dax_core_init()

David Carlier <devnexen@gmail.com>
    ring-buffer: Take cpus_read_lock() when changing the subbuf order

Gyokhan Kochmarla <gyokhan@amazon.de>
    erofs: use on-disk blkszbits for lz4 max pcluster bound

Weibin Liu <liuwb@xiaopeng.com>
    spi: amd: fix len==0 underflow and FIFO overflow

Keng-Yu Lin <keng-yu.lin@hpe.com>
    PCI/PM: Restore BARs after powering up during enumeration

Weibin Liu <liuwb@xiaopeng.com>
    spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op

Vladyslav Tymoshchuk <tvlad744@gmail.com>
    ASoC: qcom: q6apm: reset the hw pointer with the fragment queue

Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
    mfd: tps65217: Use devres for IRQ domain and wake teardown

Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
    mfd: tps65217: Check return value when masking interrupt sources

Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
    mfd: tps65217: Fix NULL pointer dereference on IRQ init failure

Weibin Liu <liuwb@xiaopeng.com>
    spi: npcm-fiu: limit UMA data_size to the 16-byte staging buffer

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Turn vcpu->arch.pause into a counter

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Don't replace an existing LINUX_EFI_MEMRESERVE table

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: arm64: Don't use the platform register x18

Weibin Liu <liuwb@xiaopeng.com>
    spi: jcore: fix divide-by-zero when speed_hz is zero

Tal Zussman <tz2294@columbia.edu>
    gfs2: fix the escaped block copy in gfs2_before_commit()

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Correct return size of fill_rpn()

Karl Mehltretter <kmehltretter@gmail.com>
    irqchip/atmel-aic[5]: Disable interrupts in the irq_pm_shutdown() callbacks

Wentao Liang <vulab@iscas.ac.cn>
    irqchip/mchp-eic: Fix clock reference leak in mchp_eic_probe()

Guangshuo Li <lgs201920130244@gmail.com>
    irqchip/imx-intmux: Fix runtime PM teardown on remove

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Don't clamp nvecs to zero when id_bits is 32

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - fix use of destroyed vf2pf_lock on VF restart

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - initialise state_lock on every path in adf_devmgr_add_dev()

Andrea Parri <parri.andrea@gmail.com>
    iommufd: Reject a zero-length dirty bitmap request

Nathan Chancellor <nathan@kernel.org>
    kbuild: AutoFDO: Update split machine function argument for upstream rename

Wentao Liang <vulab@iscas.ac.cn>
    PCI: xilinx-xdma: Fix device node reference leak in xilinx_pl_dma_pcie_init_irq_domain()

Hui Su <sh_def@163.com>
    cpufreq: schedutil: Serialize sugov_start() against rate limit updates

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Use default TxWindow for zero socket option

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject invalid TxWindow in configuration requests

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject mode changes on connected channels

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: hci_debugfs: Pin module for debugfs file operations

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file

Nikolaj Klitlund Børty <nbn@sj.dk>
    Bluetooth: btusb: Add device ID for Realtek RTL8761BUE (StarTech AV53C1)

Francesco Orlando <francesco.orlando99@libero.it>
    Input: xpad - add GameSir Nova Lite support

Stian Halseth <stian@itx.no>
    PCI: Set supported_speeds in set_pcie_port_type()

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9523/1: topology: allocate the cacheinfo early on the boot CPU

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9522/1: cacheinfo: guard the CLIDR read in populate_cache_leaves()

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9521/1: cacheinfo: count external caches in early_cache_level()

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9520/1: cacheinfo: avoid out-of-bounds write in populate_cache_leaves()

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9491/1: alignment: restore uaccess state on emulation fault

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9488/1: smp: set current pointer in assembly before jumping into C

Weibin Liu <liuwb@xiaopeng.com>
    spi: cadence-xspi: fix stack buffer overflow in the Marvell b0 path

Martin Belanger <martin.nvme.dev@gmail.com>
    nvme: make the DH-HMAC-CHAP secret attributes readable by root only

Matt Fleming <mfleming@cloudflare.com>
    iommu/amd: Don't allocate kdump device table from DMA32

Matt Fleming <mfleming@cloudflare.com>
    iommu/amd: Program device table when kdump reuse fails

Tim Douglas <me@timdoug.com>
    serial: pmac_zilog: push received data to the port that received it

Nicolai Buchwitz <nb@tipi-net.de>
    serial: amba-pl011: keep transmitter enabled when disabling RS485

Nicolai Buchwitz <nb@tipi-net.de>
    serial: amba-pl011: honour delay_rts_before_send for every write

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_omap: set priv->line before enabling the IRQ

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_lpss: do not touch uninitialized line in ehl_serial_exit()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: NUL-terminate the SPM auth token

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: allow clearing current_password

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: return -E2BIG from validate_password_input()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix non-ASCII truncation in hp_get_string_from_buffer()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix OOB reads in hp_get_string_from_buffer()

Denis Arefev <arefev@swemel.ru>
    ALSA: cs46xx: fix unit mismatch in DSP code area bounds check

Aaron Erhardt <aer@tuxedocomputers.com>
    platform/x86/tuxedo: Fix keyboard LED map ordering

Gergo Koteles <soyer@irl.hu>
    ALSA: hda/tas2781: Skip invalid TAS2563 UEFI calibration data

Kazuki Hanai <hnkz.64@gmail.com>
    tmpfs: fix unicode_map leaks in casefold option handling

Aamir Ahmed <elb12345@hotmail.co.uk>
    lib: decompress_bunzip2: fix integer overflow in run-length decoding

Bradley Morgan <brads@mainlining.org>
    panic: flatten nmi_panic control flow

Matt Turner <mattst88@gmail.com>
    lib/decompress_bunzip2: fix off-by-one in run-length bounds check

Ma Ke <make_ruc2021@163.com>
    pinctrl: stm32: Fix fwnode reference leak in stm32_gpiolib_register_bank()

Weibin Liu <liuwb@xiaopeng.com>
    spi: ljca: validate the response length before copying the data

Daeho Jeong <daehojeong@google.com>
    f2fs: disallow mmap write and data-modifying fallocate on atomic files

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: fix defragment writeback range truncation on 32-bit

Kaixuan Li <kaixuanli0131@gmail.com>
    f2fs: check every cur_*_segno[] entry on readonly images

Nanzhe Zhao <zhaonanzhe@xiaomi.com>
    f2fs: read i_size once in f2fs_vm_page_mkwrite

Joanne Chang <joannechien@google.com>
    f2fs: allow pinning empty compressed files

Nanzhe Zhao <zhaonanzhe@xiaomi.com>
    f2fs: remove mappedtodisk flag usage in mmap write path

Karl Mehltretter <kmehltretter@gmail.com>
    sh: intc: Sort the prio and sense lists after filling them

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Drive at 2.5 GT/s, error other speeds

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip-host: Do not attempt 5.0 GT/s retraining

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip-ep: Do not attempt 5.0 GT/s retraining

Daeho Jeong <daehojeong@google.com>
    f2fs: convert inline quota files when turning quota on

Andrea Parri <parri.andrea@gmail.com>
    nvmet: zns: don't leak stale memory in zone management receive

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme: bound FDP config log reads to the received buffer

Sung Byeongchan <tjdqudcks0424@naver.com>
    nvmet: require authentication before property set

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet: free the bvec on file namespace range errors

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-auth: fail when the controller does not authenticate itself

Daejun Park <daejun7.park@samsung.com>
    nvmet: fix preempt of another registrant by the reservation holder

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-rdma: don't complete a request after a bogus remote invalidation

Andrea Parri <parri.andrea@gmail.com>
    iomap: don't lose a fiemap iteration error when emitting the last extent

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    clk: qcom: ipq5332: add 24MHz rate for USB UTMI clock

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    clk: qcom: ipq5018: add 24MHz rate for USB UTMI clock

Aamir Ahmed <elb12345@hotmail.co.uk>
    clk: qcom: ipq-cmn-pll: Assign .num before accessing .hws

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Fix NULL pointer dereference on VT switch + selection

Wentao Guan <guanwentao@uniontech.com>
    mei: vsc: Fix packet CRC computed over pointer size

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: fix a race leading to an unsigned integer underflow

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: fix non-working memory limit

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_exar: store the GPIO platform device in struct exar8250

Myeonghun Pak <mhun512@gmail.com>
    fbdev: kyro: Release WC setup on registration failure

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: smscufx: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: udlfb: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: xen-fbfront: check for fb_deferred_io_init() error

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fbdev: ssd1307fb: check for fb_deferred_io_init() error

David E. Box <david.e.box@linux.intel.com>
    platform/x86/intel/vsec: Fix inverted walk_header() test in get_features()

Guixiong Wei <weiguixiong@bytedance.com>
    platform/x86/intel-uncore-freq: Continue restoring limits on resume

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: hfi: Fix out-of-bounds reads when parsing ranking data

Guangshuo Li <lgs201920130244@gmail.com>
    platform/x86: simatic-ipc: fix platform device leak on registration failure

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Fix Apex charge limit control

Jack Boykin <jtboykin.jb@gmail.com>
    platform/x86/amd/pmf: Fix power_supply refcount leak in amd_pmf_get_battery_prop()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix 16-byte heap overflow for empty auth token

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: fix screenpad power state detection

Denis Benato <denis.benato@linux.dev>
    platform/x86: asus-wmi: fix unclear usage of bd->props.power

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: Stop counting intermediate cycles with metrics table

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmf: Validate the APTS state index

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    mm/damon/core: charge only the part of a region the filter left

Hao Ge <hao.ge@linux.dev>
    mm/alloc_tag: account for reserved tag ids in the kernel tag check

Breno Leitao <leitao@debian.org>
    mm/shmem: report RCU-tasks quiescent states while undoing a range

Hongfu Li <lihongfu@kylinos.cn>
    mm/hugetlb_cgroup: move per-node usage on cgroup reparenting

Hongfu Li <lihongfu@kylinos.cn>
    mm/hugetlb_cgroup: move per-node usage on cross node migration

Yuanhe Shu <xiangzao@linux.alibaba.com>
    mm/page_alloc: do not boost watermarks in kdump capture kernels

Gregory Price <gourry@gourry.net>
    mm/madvise: use folio_trylock() in the cold/pageout PMD split

Gregory Price <gourry@gourry.net>
    mm/madvise: reclaim isolated folios if PTE restart fails

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once

Imre Kaloz <kaloz@kernel.org>
    PCI: Avoid D3 on PLX PEX 8532/8533/8548 downstream ports

Yongjian Mu <ymu@everpuredata.com>
    xprtrdma: trim head iovec when the payload arrives via a Write chunk

Tim Menninger <tmenninger@everpuredata.com>
    xprtrdma: prevent disconnect feedback during endpoint teardown

Weigang He <geoffreyhe2@gmail.com>
    mtd: parsers: qcom: fix offset/size overflow on large partitions

Gabor Juhos <j4g8y7@gmail.com>
    mtd: rawnand: qcom: fix read location register usage in config_nand_cw_read()

Hengyu Liang <hengyul@cs.unc.edu>
    btrfs: return -ENOTTY for unknown ioctls on the control device

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()

Ard Biesheuvel <ardb@kernel.org>
    arm64/efi: Clear PTE_WRITE when applying EFI_MEMORY_RO

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: fix crash if dm_io_client_create fails

Johan Hovold <johan@kernel.org>
    USB: serial: sierra: fix urb leak on write completion

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: qcom-ipcc: Guard against NULL con_priv in send_data()

Wentao Liang <vulab@iscas.ac.cn>
    mailbox: mtk-cmdq: Fix runtime PM leak in cmdq_mbox_flush()

Florian Fainelli <florian.fainelli@broadcom.com>
    mailbox: bcm74110: Cap rx_svc_init_list growth to prevent PMC-induced OOM

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mailbox: altera: shut down RX polling timer on channel teardown

Wayne Chang <waynec@nvidia.com>
    usb: typec: ucsi_ccg: Add retry mechanism in ccg_read

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent invalid vdev dereference during sideband unregister

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix bounce buffer overflow

Seungjin Bae <eeodqql09@gmail.com>
    usb: typec: ucsi: ccg: Validate altmode index in GET_CURRENT_CAM response

Ali Resool Tuama <aliresool567@gmail.com>
    USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE

Drobyshev Vladimir <enigma_137@icloud.com>
    USB: cdc-acm: add VeriFone VX820 device ID

Adam Harshbarger <handyhandyman.adam@gmail.com>
    lib/plist: fix plist_requeue() corrupting order in the last bucket

Koichiro Den <den@valinux.co.jp>
    cxl/acpi: Convert QTG _DSM latencies to picoseconds

Koichiro Den <den@valinux.co.jp>
    cxl: Account for link width in latency calculation

Koichiro Den <den@valinux.co.jp>
    cxl/port: Convert PCIe link latency to nanoseconds

Guixin Liu <kanie@linux.alibaba.com>
    cxl/pci: Program the Port GPF timeouts before caching the DVSEC

Seongjun Hong <hsj0512@snu.ac.kr>
    vfio/mlx5: Fix boundary check in set_report_output()

Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>
    RISC-V: KVM: Fix IPI delivery for out-of-order vcpu_id

Ross Lagerwall <ross.lagerwall@citrix.com>
    xen-blkfront: Fix IO race during unplug

Zongmin Zhou <zhouzongmin@kylinos.cn>
    slimbus: messaging: fix leaked PM vote on tid allocation failure

Johan Hovold <johan@kernel.org>
    USB: serial: usb_wwan: fix urb leak on disconnect

Michael Wyraz <michael@wyraz.de>
    USB: serial: option: add support for ASR 1286:4e3c modem

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Rolling Wireless RN947R

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix urb leak on disconnect

Jiale Yao <yaojiale02@163.com>
    wifi: ath12k: validate MAC/PHY capability count before saving

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/ttm: return an error when kmapping a BO without pages

Krzysztof Karas <krzysztof.karas@intel.com>
    iommu/dma: Catch scatterlist length overflows

Wentao Liang <vulab@iscas.ac.cn>
    xen-pciback: Fix pcistub_device ref leak in pcistub_get_gsi_from_sbdf()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    xen/pcifront: check that an AER callback exists before calling it

Koichiro Den <den@valinux.co.jp>
    xen/privcmd: Only claim ioreqs matching an ioeventfd

Myeonghun Pak <mhun512@gmail.com>
    soc: fsl: dpio: Free the IRQ before releasing the I/O object

Myeonghun Pak <mhun512@gmail.com>
    soc: fsl: dpio: Fix cleanup on IRQ registration failure

Wentao Liang <vulab@iscas.ac.cn>
    soc: fsl: cpm1: tsa: Fix clock leak in tsa_of_parse_tdms()

Abdifatah Suruur <suruurism@gmail.com>
    xen/gntdev: prevent private mappings from becoming writable

Wentao Liang <vulab@iscas.ac.cn>
    clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()

Wentao Liang <vulab@iscas.ac.cn>
    clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()

Longlong Xia <xialonglong@kylinos.cn>
    mm/zswap: enable zswap_ever_enabled in zswap_pool_create()

Longlong Xia <xialonglong@kylinos.cn>
    mm/zswap: publish the initial pool with list_add_rcu()

Jinmeng Zhou <jinmengzhou22@gmail.com>
    mm/hugetlb: fix subpool minimum reservation rollback

Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
    mm/nommu: reject wrapping ranges in access_remote_vm()

Mike Rapoport (Microsoft) <rppt@kernel.org>
    mm/execmem: free ROX cache chunks only when they span an entire vm area

Luxiao Xu <rakukuip@gmail.com>
    mm/memory: constrain generic_access_phys() to page boundary

Yogesh Gaur <yogeshgaur.83@gmail.com>
    md: don't hand out the array before md_alloc() has added mddev->kobj

Jake Labelle <southampton.jake.labelle@gmail.com>
    nilfs2: validate directory position after llseek in readdir

Jinjie Ruan <ruanjinjie@huawei.com>
    ext4: fix out-of-bounds read in ext4_get_group_info()

Sergey Senozhatsky <senozhatsky@chromium.org>
    ext4: fix ABBA deadlock in ext4_rmdir()

Daejun Park <daejun7.park@samsung.com>
    ext4: don't report delalloc data as a hole on indirect-mapped inodes

Hemanth Selam <hemanth.selam@gmail.com>
    ext4: skip extra isize expansion while unmounting

Daejun Park <daejun7.park@samsung.com>
    jbd2: don't advance j_fc_off before the buffer is recorded

guzebing <guzebing1612@gmail.com>
    ext4: reject delalloc to nodelalloc before applying remount options

Hsiu-Hsien Lee <swinds24@gmail.com>
    ext4: fix fast commit replay failing on a read-only mount

guzebing <guzebing1612@gmail.com>
    ext4: only update tune mount options when requested

Matthias Goergens <matthias.goergens@gmail.com>
    fanotify: report names longer than NAME_MAX

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/hdmi: clamp sad_count in ELD proc write handler

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn

Daehyeon Ko <4ncienth@gmail.com>
    crypto: algif_skcipher - rewind rounded output bytes

Tristan Madani <tristan@talencesecurity.com>
    wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Pass the device name length in UTF-16 code units

Josef Bacik <josef@toxicpanda.com>
    aoe: pull in the headers each received packet type reads

Pin-Hao Chen <billy920225@gmail.com>
    spi: stm32: fix double free of SRAM buffer on MDMA fallback

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/fttmr010: Fix clk reference leak in error paths

Linlin Yang <yanglinlin@kylinos.cn>
    wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()

Wentao Liang <vulab@iscas.ac.cn>
    wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: mt7615: cancel reset work during unregister

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path

Myeonghun Pak <mhun512@gmail.com>
    wifi: mt76: mt7615: restore DBDC state after ext PHY failure

Eason Lai <eason.lai@mediatek.com>
    wifi: mt76: fix memory leak in USB TX path

Eason Lai <eason.lai@mediatek.com>
    wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes

Karl Mehltretter <kmehltretter@gmail.com>
    fork: honor task_struct's declared alignment

Konstantin Khorenko <khorenko@virtuozzo.com>
    selftests/core: fix unshare_test with large fs.nr_open

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: free replay slots in ocfs2_recovery_exit()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: exit recovery thread on mount error path

Thorsten Blum <blum@kernel.org>
    init: fix early boot crash with bare hostname parameter

Zi Yan <ziy@nvidia.com>
    USB: gadgetfs: do not WARN about excessively large memory allocations

Michael Liang <mliang@purestorage.com>
    fault-inject: fix dentry leak

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix fat_ent_write() for reverting the value

DAI RENJIE <drj19981414013@gmail.com>
    resource: fix lost wakeup when waiting for a muxed region

SJ Park <sj@kernel.org>
    mm/damon/sysfs: set next refresh jiffies per sysfs context

SJ Park <sj@kernel.org>
    mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()

SJ Park <sj@kernel.org>
    mm/damon/vaddr: respect folio end for DAMOS_STAT

SJ Park <sj@kernel.org>
    mm/damon/paddr: respect folio end for DAMOS actions except STAT

SJ Park <sj@kernel.org>
    mm/damon/paddr: respect folio end for DAMOS_STAT

Zhiling Zou <roxy520tt@gmail.com>
    mm/page_table_check: skip zero pages

Joe Damato <joe@dama.to>
    mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming

Gregory Price <gourry@gourry.net>
    mm/mempolicy: take a cpuset cookie for the interleave node count

Qi Xi <xiqi2@huawei.com>
    mm/page_isolation: guard compound_order() against racing

Qi Xi <xiqi2@huawei.com>
    mm/page_isolation: fix UBSAN shift-out-of-bounds warning

Chengfeng Ye <nicoyip.dev@gmail.com>
    mm/ksm: mark migration stores with WRITE_ONCE()

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz

Darrick J. Wong <djwong@kernel.org>
    xfs: cross-reference the primary superblock

Priyank Rathod <rathodpriyank@google.com>
    PCI/AER: Fix memory leak in aer_recover_queue() on kfifo buffer overflow

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    PCI/DOE: Fix double free of a duplicate feature's sysfs name

Eric Dumazet <edumazet@kernel.org>
    dlm: fix send buffer backpressure handling

Denis Efremov (Oracle) <efremov@linux.com>
    floppy: return the drive state flags from the 32-bit FDGETDRVSTAT

Denis Efremov (Oracle) <efremov@linux.com>
    floppy: don't store a stack buffer in timeout_message

Myeonghun Pak <mhun512@gmail.com>
    ASoC: codecs: rt5682s: disable jack detection work on shutdown

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Grant credits from the clamped sc_max_requests

Runyu Xiao <runyu.xiao@seu.edu.cn>
    perf: xgene: initialize lock before requesting IRQ

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_fg: Report sub-percent charge changes

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_fg: Accept status from supplied power

Henrik Enquist <henrik.enquist@gmail.com>
    ALSA: aloop: Don't constrain playback params in notify mode

Andrey Albershteyn <aalbersh@kernel.org>
    fsverity: hoist statx reporting of fs-verity flag

Maurizio Casciano <mauriziocasciano7@gmail.com>
    power: supply: core: Honor supplied-from with CONFIG_OF=y

Tharit Tangkijwanichakul <tharitt97@gmail.com>
    media: hantro: disable runtime PM before hardware teardown

Jiawen Liu <1298662399@qq.com>
    media: amphion: fix runtime PM imbalance on probe failure

Tharit Tangkijwanichakul <tharitt97@gmail.com>
    media: hantro: release runtime resources when device_run fails

Tharit Tangkijwanichakul <tharitt97@gmail.com>
    media: hantro: Harden MPEG-2 control access against NULL

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: fix NULL deref on oversized frame

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: mediatek: jpeg: retry HW selection after successful wait

Michail Tatas <michail.tatas@gmail.com>
    media: verisilicon: rockchip: Fix leaks in init

Guangshuo Li <lgs201920130244@gmail.com>
    media: mediatek: vpu: release reserved memory on remove

Guangshuo Li <lgs201920130244@gmail.com>
    media: mediatek: vcodec: destroy core workqueue on remove

Wentao Liang <vulab@iscas.ac.cn>
    media: mtk-jpeg: Fix runtime PM leak in mtk_jpegenc_worker()

Wentao Liang <vulab@iscas.ac.cn>
    media: mtk-jpeg: Fix runtime PM leak in mtk_jpegdec_worker()

Wentao Liang <vulab@iscas.ac.cn>
    media: platform: mtk-mdp3: Fix device reference leak in mdp_comp_init()

Fan Wu <fanwu01@zju.edu.cn>
    media: mediatek: vpu: free IRQ before destroying watchdog workqueue

Myeonghun Pak <mhun512@gmail.com>
    media: amphion: prevent unbind while video instances are open

Myeonghun Pak <mhun512@gmail.com>
    media: amphion: drain message work before releasing core state

Michael Freidkin <freidkin@gmail.com>
    media: meson: vdec: size capture planes from the aligned canvas

Guangshuo Li <lgs201920130244@gmail.com>
    media: chips-media: wave5: Check decoder qbuf runtime resume

Linmao Li <lilinmao@kylinos.cn>
    media: chips-media: wave5: Balance runtime PM on encoder close errors

Linmao Li <lilinmao@kylinos.cn>
    media: chips-media: wave5: Handle polling IRQ thread failure

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: sti: delta: use unaligned accessors for MJPEG SOF fields

Nas Chung <nas.chung@chipsnmedia.com>
    media: v4l2-common: Fix P010 format info

Thorsten Blum <thorsten.blum@linux.dev>
    media: imagination: Fix value clamping in calculate_qp_tables

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: vgic-v3: Roll back assignments from the new region

Alexey Klimov <alexey.klimov@linaro.org>
    soc: samsung: exynos-pmu: fix error paths in cpuhotplug/idle states setup

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: vgic-v3: Undo assignment on iodev registration failure

Kim Phillips <kim.phillips@amd.com>
    x86/bugs: Fix CONFIG_MITIGATION_RETPOLINE=n mitigation reporting

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Validate the host vCPU's VM before reading it under pKVM

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: ecc - Handle exceptional points in Shamir multiplication

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    crypto: nx - validate 'ignore' before subtracting in decompress

Thorsten Blum <blum@kernel.org>
    hwrng: core - reject unknown RNG names

Thorsten Blum <blum@kernel.org>
    hwrng: ba431 - fix reported byte count

Thorsten Blum <blum@kernel.org>
    hwrng: amd - report partial reads in non-blocking mode

ZhaoJinming <zhaojinming@uniontech.com>
    crypto: caam - fix double-free in caam_rsa_set_priv_key_form()

Wei Jie Law <98lawweijie@gmail.com>
    media: uvcvideo: Fix NULL deref on events for uninitialized controls

Imre Kaloz <kaloz@kernel.org>
    PCI: Disable MSI for ULi M1575 EHCI controller

Runyu Xiao <runyu.xiao@seu.edu.cn>
    block: amiflop: synchronize flush timer before track flush

Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>
    block: drop the cached plug time when blk_add_rq_to_plug() flushes

Danish Khateeb <danishkhateeb03@gmail.com>
    pps: generators: stop the generator on unregister

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix REQ_FUA processing

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix uncommitted_blocks underflow

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix a crash if we attempt to use non-dax device

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: fix a quirk in statistics

Mikulas Patocka <mpatocka@redhat.com>
    dm-writecache: report I/O error if flush failed

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix a bug in dm_accept_partial_bio

Kaho Jiang <kj2864@nyu.edu>
    media: em28xx: fix double free in em28xx_alloc_urbs

Ginger Li <ginger.jzllee@gmail.com>
    media: exynos4-is: Fix a race between s_stream(0) and the interrupt handler

Guangshuo Li <lgs201920130244@gmail.com>
    media: rtl28xxu: fix SDR platform device leak

Wentao Liang <vulab@iscas.ac.cn>
    media: pvrusb2: Fix USB parent device leak in class_dev_create()

Guangshuo Li <lgs201920130244@gmail.com>
    media: tw686x: fix V4L2 device lifetime on probe failure

Tianchu Chen <flynnnchen@tencent.com>
    staging: rtl8723bs: fix RX buffer OOB write from device-reported length

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix racy TIOCMIWAIT implementation

Wentao Liang <vulab@iscas.ac.cn>
    drm/msm/dsi: Fix VM leak in dsi_tx_buf_alloc_6g()

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi: Handle msm_hdmi_power_on() errors during .atomic_pre_enable()

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure

Fan Wu <fanwu01@zju.edu.cn>
    i3c: master: adi: free the IRQ before unregistering the master

Runyu Xiao <runyu.xiao@seu.edu.cn>
    IB/hfi1: Shutdown self-rearming timers before freeing

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    pwm: tiehrpwm: Clear period on disable to allow reconfiguration

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: ignore non-fatal signals during synchronous log write wait

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: clear dirty flag on bdev buffers on log write failure

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: pcm6240: do not free an unrequested IRQ

Srish Srinivasan <ssrish@linux.ibm.com>
    pseries/plpks: clear SED key data after use

Srish Srinivasan <ssrish@linux.ibm.com>
    pseries/plpks: clear signed update authentication buffer

Srish Srinivasan <ssrish@linux.ibm.com>
    pseries/plpks: clear sensitive PLPKS buffers

Srish Srinivasan <ssrish@linux.ibm.com>
    pseries/plpks: validate input to plpks_signed_update_var()

Srish Srinivasan <ssrish@linux.ibm.com>
    pseries/plpks: fix error handling in plpks_read_var()

Wentao Liang <vulab@iscas.ac.cn>
    clk: starfive: jh7110-isp: fix refcount leak in jh7110_ispcrg_probe()

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Check shutdown flag at D0 power-state, too

Runyu Xiao <runyu.xiao@seu.edu.cn>
    m68k: dmasound: Keep the Q40 IRQ handler registered

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: sgio2audio: Only free successfully requested IRQs

Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
    media: iris: Fix frame interval enumeration for non-divisor framerates

Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
    media: iris: Fix bus_info prefix in VIDIOC_QUERYCAP

Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
    media: venus: Fix iova allocation from restrict region

Hans de Goede <johannes.goede@oss.qualcomm.com>
    media: qcom: camss: Add "gcc_axi_hf" to 8775p VFE lite clock lists

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe: Fix VFE reset while another line is streaming

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe-17x: Fix write master selection for RDI lines

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe-17x: Fix write master buffer done being dropped

Jiale Yao <yaojiale02@163.com>
    cxl/acpi: Check ACPI companion before use

Ibrahim Hashimov <security@auditcode.ai>
    fs/ntfs3: fix integer overflow in find_log_rec() causing OOB read

Lucas Costa <2000.costalucas@gmail.com>
    spi: bcm2835: fix device_node reference leak in bcm2835_spi_setup()

Cheick Traore <cheick.traore-ext@st.com>
    iio: adc: stm32: fix minimum sampling time values

Jiale Yao <yaojiale02@163.com>
    iio: accel: adxl380: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: accel: adxl313: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: adc: ti-adc128s052: validate SPI match data

Jiale Yao <yaojiale02@163.com>
    iio: adc: mcp3911: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: adc: max11205: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: adc: ad7606: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: pressure: bmp280: validate SPI match data

Jiale Yao <yaojiale02@163.com>
    iio: potentiometer: x9250: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: imu: adis16400: validate SPI match data

Jiale Yao <yaojiale02@163.com>
    iio: frequency: adf4377: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: dac: ad5755: validate SPI match data

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: codecs: wcd9335: Fix SLIM interface device leak in wcd9335_slim_status()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mpu401: shut down timer before freeing MPU

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Avoid out-of-range shift in qi_desc_dev_iotlb_pasid()

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    arm64: dts: qcom: ipq9574: Wire up USB3 PHY PIPE clock to GCC

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region

Piotr Kubik <piotr@kubik.pl>
    netfilter: ctnetlink: fix inverted IPv6 address match in dump filter

Orgad Shaneh <orgads@gmail.com>
    MIPS: mm: do not write a huge TLB entry when the probe misses

Orgad Shaneh <orgads@gmail.com>
    MIPS: mm: align hugetlb mappings in arch_get_unmapped_area()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    peci: npcm: Initialize state before requesting IRQ

Runyu Xiao <runyu.xiao@seu.edu.cn>
    peci: aspeed: Initialize state before requesting IRQ

Ma Ke <make_ruc2021@163.com>
    ASoC: wcd9335: Fix device reference leak in wcd9335_slim_status()

David Cemin <dcemin@nvidia.com>
    ASoC: sdw_utils: clear stale RT711 device reference on exit

Breno Leitao <leitao@debian.org>
    dcache: report a Tasks-RCU quiescent state in dentry_kill()

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    hwmon: (coretemp) Refresh the temperature on the first read

Richard Weinberger <richard@nod.at>
    mtd: Call get_wunit() on the master partition

Wentao Liang <vulab@iscas.ac.cn>
    mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: maps: l440gx: Fix double put of the PM device in init_l440gx()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: maps: l440gx: Fix double put of the ISA bridge in init_l440gx()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: amd76xrom: Fix PCI device reference leak in amd76xrom_init_one()

Orgad Shaneh <orgads@gmail.com>
    mtd: cfi_cmdset_0002: cap the write-buffer chunk at 256 bytes on an x8 device

Myeonghun Pak <mhun512@gmail.com>
    mtd: maps: pci: balance PCI enable on cleanup

Wentao Liang <vulab@iscas.ac.cn>
    mtd: rawnand: atmel: Fix MCK clock leak in atmel_nand_controller_init()

Guangshuo Li <lgs201920130244@gmail.com>
    mtd: rawnand: nuvoton: fix clock cleanup on probe failure

Michael J. Ruhl <michael.j.ruhl@intel.com>
    platform/x86/intel/pmt: Block mmap when callback is present

Joanne Koong <joannelkoong@gmail.com>
    fuse: don't drop destination page cache on a zero byte copy reply

Ridham Khurana <khurana.ridham222@gmail.com>
    hwmon: (lm95245) Fix negative temperature conversion

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix coupled regulators reference leak on removal

Aamir Ahmed <elb12345@hotmail.co.uk>
    clk: mvebu: ap-cpu-clk: Assign .num before accessing .hws

Junjie Cao <junjie.cao@intel.com>
    ASoC: rt712-sdca-dmic: fix drvdata type in the gain controls

Guangshuo Li <lgs201920130244@gmail.com>
    ASoC: Intel: atom: Fix platform device leak on probe failure

Jiacheng Xu <stitch@zju.edu.cn>
    kobject: fix out-of-bounds access in kobject_action_type()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock between nilfs_evict_inode() and find_inode()

Tiezhu Yang <yangtiezhu@loongson.cn>
    perf loongarch: Fix discarded const qualifier in _get_field()

Lin Wang <wanglin@open-hieco.net>
    hwmon: (k10temp) Stop matching Hygon devices

David Heidelberg <david@ixit.cz>
    mfd: wcd934x: Fix NULL pointer dereference on IRQ probe deferral

David Heidelberg <david@ixit.cz>
    mfd: wcd934x: set DMA mask on parent to silence "DMA mask not set"

David Heidelberg <david@ixit.cz>
    mfd: Fix MAX77705 dependency on regmap

Hongyan Xu <getshell@seu.edu.cn>
    mfd: da903x: Cancel IRQ work during teardown

Casey Connolly <casey.connolly@linaro.org>
    drm/panel: ebbg-ft8719: Set prepare_prev_first

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: gcc-ipq5018: mark 'gpll0_main' clock as critical

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mp-verdin-yavia: fix external GPIOs

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mp-toradex-smarc: fix SMARC_SLEEP# gpio-line-names typo

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mp-verdin-ivy: fix DIGI_1/DIGI_2 gpio-line-names

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mm-verdin-ivy: fix DIGI_1/DIGI_2 gpio-line-names

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    memory: stm32_omm: fix child clock leak on set_amcr() error path

Myeonghun Pak <mhun512@gmail.com>
    ASoC: fsl_xcvr: free IRQ before canceling reset work

Guangshuo Li <lgs201920130244@gmail.com>
    media: atmel-isi: release unregistered video device on remove

Lucas Sinn <lucas.sinn@wolfvision.net>
    media: synopsys: hdmirx: fetch colordepth before calculating pixelclock

Wentao Liang <vulab@iscas.ac.cn>
    media: vpif_display: Fix i2c adapter reference leak in vpif_probe()

Wentao Liang <vulab@iscas.ac.cn>
    media: vpif_capture: Fix i2c adapter reference leak in vpif_probe()

Wentao Liang <vulab@iscas.ac.cn>
    media: au0828: Fix media device leak in au0828_usb_probe()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: adv7180: Initialize mutex before ancillary clients

Myeonghun Pak <mhun512@gmail.com>
    media: tw68: balance PCI enable on cleanup

Myeonghun Pak <mhun512@gmail.com>
    media: cx18: Disable PCI device on probe failure

Myeonghun Pak <mhun512@gmail.com>
    media: go7007: unregister the I2C adapter on USB probe failure

Myeonghun Pak <mhun512@gmail.com>
    media: marvell: manage the MMP camera clock provider

Rohinthan P <rokinthanp03@gmail.com>
    media: v4l2-ctrls: do nothing if controls[0] == NULL in cluster functions

Pengpeng Hou <hppiscas@163.com>
    media: cec: extron: clear response tail before dispatch

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: qat - zero the VF migration state buffer on save

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix ECDH destination DMA mapping

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - fix pointer dereference before length check

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    crypto: amlogic - Fix IRQ handler return value and fallthrough logic

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - fix error source for QAT GEN6 transmit interface faults

Yuchao Zhang <ndaugoing@gmail.com>
    md: validate bblog_size when loading v1.x badblocks metadata

Wentao Liang <vulab@iscas.ac.cn>
    EDAC/i10nm: Fix mdev reference leak in i10nm_get_ddr_munits()

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nilfs2: fix checkpoint root lifetime on sysfs errors

Wentao Guan <guanwentao@uniontech.com>
    cpufreq/amd-pstate: Skip auto_sel write when it already matches the mode

Wentao Liang <vulab@iscas.ac.cn>
    drm/mali-dp: Fix runtime PM leak in malidp_crtc_atomic_enable()

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62x-phyboard-lyra: Set SD clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-phycore-som: Set eMMC clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am625-beagleplay: Set MMC clock pins as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-pocketbeagle2: Set SD clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-lp-sk: Set eMMC clock pins as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62a-phycore-som: Set eMMC clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62a7-sk: Set SD clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62a7-sk: Set eMMC clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62a: Fix MMC0_CLK register address

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: ti: davinci-mcasp: Fix runtime PM imbalance in __davinci_mcasp_set_clkdiv()

Sean Young <sean@mess.org>
    media: meson-ir-tx: Prevent divide by zero in meson_irtx_prepare_pulse()

Sean Young <sean@mess.org>
    media: ir_toy: Validate the maximum tx carrier

Sean Young <sean@mess.org>
    media: serial_ir: Fix race condition where timer can be re-armed

Sean Young <sean@mess.org>
    media: ene_ir: Ensure teardown is done in the correct order

Myeonghun Pak <mhun512@gmail.com>
    leds: ktd2692: Pass context to regulator cleanup

Cong Nguyen <congnt264@gmail.com>
    staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error

Hui Peng <benquike@gmail.com>
    seccomp: restore knotif->state when SECCOMP_ADDFD_FLAG_SEND is interrupted

Oleg Nesterov <oleg@redhat.com>
    signalfd: don't dequeue the forced fatal signals

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Bounce short reads irrespective of the IOMMU

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix out-of-bounds read in DMA bounce buffer setup

Runyu Xiao <runyu.xiao@seu.edu.cn>
    PCI: pciehp: Make 'pciehp_poll_mode' parameter read-only

Hui Peng <benquike@gmail.com>
    ata: libata-scsi: abort multi-sector pass-through commands when multi_count is 0

Tsz Shan Chan <tsz.chan.dev@gmail.com>
    iio: light: apds9306: fix default sampling frequency definition

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: force accel odr change when switching power mode

Shehryar Ahmad <shehryar.amd@gmail.com>
    iio: accel: adis16201: fix channel order for buffer mode

Wentao Liang <vulab@iscas.ac.cn>
    regulator: rt6190: Fix runtime PM imbalance in rt6190_out_enable()

Karl Mehltretter <kmehltretter@gmail.com>
    fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: omap-des - fix crypto engine cleanup

Thorsten Blum <blum@kernel.org>
    crypto: zynqmp-sha - fix NULL pointer dereference in init_tfm

Maciej W. Rozycki <macro@orcam.me.uk>
    PCI: Skip Target Speed quirk on clamped ports with no link

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix rdev reference leak in regulator_resolve_supply()

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()

Jiaming Zhang <r772577952@gmail.com>
    nilfs2: force clear dirty state when restoring from the shadow map

Shengming Hu <hu.shengming@zte.com.cn>
    cpufreq: conservative: Restrict deferred downscaling to low load

Johan Alvarado <contact@c127.dev>
    spi: spi-qpic-snand: publish the ECC context to snandc->qspi

Thomas Zimmermann <tzimmermann@suse.de>
    drm/panic: Test address from kmap op for NULL

Thomas Zimmermann <tzimmermann@suse.de>
    drm/panic: Do not use un-escaped URL as format string

Martin Wilck <martin.wilck@suse.com>
    md/raid5: validate payload size before calculating payload_len

Cao Guanghui <caoguanghui@kylinos.cn>
    md/raid5: fix NULL pointer dereference in raid5_free_percpu

Cao Guanghui <caoguanghui@kylinos.cn>
    md/raid5: track disks array size to fix extra_page leak on error paths

Guangshuo Li <lgs201920130244@gmail.com>
    iio: adc: at91-sama5d2: disable autosuspend on remove

Guangshuo Li <lgs201920130244@gmail.com>
    iio: accel: mma9553: disable autosuspend on remove

Guangshuo Li <lgs201920130244@gmail.com>
    iio: accel: mma9551: disable autosuspend on remove

Guangshuo Li <lgs201920130244@gmail.com>
    iio: accel: kxcjk-1013: Disable autosuspend on remove

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: arizona-jack: Fix runtime PM imbalance in arizona_start_hpdet_acc_id()

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()

Liu Chao <liuc63@xiaopeng.com>
    usb: fotg210: validate endpoint index in ep0 handlers

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel-tdes - sync output bounce buffer before DMA

Yousef Alhouseen <alhouseenyousef@gmail.com>
    ntfs3: bound index head insertions by buffer capacity

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix slab-out-of-bounds write in hp_convert_hexstr_to_str()

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: ov2735: fix power cleanup on remove

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: alvium-csi2: balance runtime PM usage count on remove

Niklas Cassel <cassel@kernel.org>
    ata: libata: Do not leave ata_host_stop() registered when activation fails

Niklas Cassel <cassel@kernel.org>
    ata: libahci: Free the IRQs when activating a multi-IRQ host fails

Niklas Cassel <cassel@kernel.org>
    ata: ahci_st: Assert the power down reset in the probe() error path

Niklas Cassel <cassel@kernel.org>
    ata: ahci_st: Do not ignore errors when getting the reset controls

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to handle race between truncate and writeback

Jiucheng Xu <jiucheng.xu@amlogic.com>
    f2fs: force out-place update for all writes on compressed file

Matthew Sakai <msakai@redhat.com>
    dm vdo indexer: validate record page numbers better

Matthew Sakai <msakai@redhat.com>
    dm vdo indexer: prevent delta list overflow on load

Kyle Zeng <kylebot@openai.com>
    affs: validate blocks before freeing them

Bradley Morgan <include@grrlz.net>
    PM: CPU: Restore synchronize_rcu() to cpu_pm_unregister_notifier()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    crypto: ccp - Initialize DBC ioctl mutex before registering device

Karl Mehltretter <kmehltretter@gmail.com>
    lib/842: require a complete history block for repeat templates

Karl Mehltretter <kmehltretter@gmail.com>
    lib/842: reject output overflows from index and short data

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel-aes - fix AADLENR for standalone GHASH

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel-tdes - zero-initialize device state

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: zero-initialize stateful decoder heap buffers

Fan Wu <fanwu01@zju.edu.cn>
    media: vivid: cancel svid ctrl work on release

Juan Perdomo <jcperdomo100@gmail.com>
    media: cx231xx: preserve I2C transfer length

Maxim Skokov <skokovmaksimevg@gmail.com>
    media: vivid: round the height down to the vertical subsampling factor

Eric Kim <seohyun.kim@outlook.kr>
    sched/fair: Reset NUMA fault locality after scan period update

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr change not caught in certain cases

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: bq27xxx: Ensure poll work is cancelled on remove

Shengzhuo Wei <me@cherr.cc>
    power: supply: bq27xxx: synchronize work cancellation on suspend

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: notify battery overvoltage recovery

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: validate battery float voltage

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: fix float voltage selector

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: test battery health status bits

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: include base when petting watchdog

Runyu Xiao <runyu.xiao@seu.edu.cn>
    hte: tegra194-test: shut down timer before GPIO release

Karl Mehltretter <kmehltretter@gmail.com>
    ACPI: pfr_update: zero-initialize capability query result

Runyu Xiao <runyu.xiao@seu.edu.cn>
    dmaengine: altera-msgdma: initialize state before requesting IRQ

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Restore mandatory samsung DP DT properties

Fan Wu <fanwu01@zju.edu.cn>
    media: nuvoton: npcm-video: quiesce VCD IRQ before teardown

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: synopsys: hdmirx: use request_any_context_irq() for 5V detection IRQ

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: stv0900: bound DiSEqC reply length to msg[] size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: stv090x: bound DiSEqC reply length to msg[] size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: adv7604: avoid negative array index in log_status when cp_read fails

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: reject ECC maximization on small pages

Myeonghun Pak <mhun512@gmail.com>
    media: stm32: csi: unregister async notifier on cleanup

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: csi: correct remote pad retrieval

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: don't sleep in the clk .is_enabled callback

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix PM runtime leak in AWB work handler

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: do not touch WB registers when not streaming

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: disable histogram and flush AWB work on teardown

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: synchronize the IRQ before disabling clocks on stop

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix awb_mutex and lock lifecycle

Wang Yan <wangyan01@kylinos.cn>
    perf powerpc-vpadtl: Fix off-by-one in auxtrace_info minimum size check

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: lpass-wsa-macro: use v2.5 Compander1 addresses on v2.5+

Xu Rao <raoxu@uniontech.com>
    media: m2m-deinterlace: fix default capture field

Punnay Sharma <punnaysharma805@gmail.com>
    staging: media: av7110: fix sp8870 initialization failure state

Punnay Sharma <punnaysharma805@gmail.com>
    staging: media: av7110: fix corrupted BER reporting in sp8870

Julian Braha <julianbraha@gmail.com>
    media: marvell-cam: fix unmet dependency for VIDEO_MMP_CAMERA

Jeffin Philip <jeffinphilip14@gmail.com>
    media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail

Piyush Patle <piyushpatle228@gmail.com>
    media: vidtv: fix frontend reference leak on unbind

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: make encoder CAPTURE dimensions read-only

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: fix out-of-bounds write on under-rounded coded dimensions

Younho Choi <gdool88@mju.ac.kr>
    media: vim2m: keep transaction buffer count stable while streaming

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: saa7146: Initialize interrupt lock before requesting IRQ

Shengzhuo Wei <me@cherr.cc>
    media: go7007: bound EZ-USB I2C transfers to the usb_buf size

Linkai Gong <gonglinkai@kylinos.cn>
    media: i2c: tc358743: add missing color-space strings

Ruoyu Wang <ruoyuw560@gmail.com>
    media: au0828: Free URBs when starting DVB streaming fails

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix source bus ID detection for AT context in big-endian systems

Andi Shyti <andi.shyti@kernel.org>
    media: cx231xx: Fix cleanup path on failure

Fan Wu <fanwu01@zju.edu.cn>
    media: cx231xx-audio: drain wq_trigger before audio fini

Andrea Pesaresi <andreapesaresi82@gmail.com>
    arm64: dts: mediatek: mt7986: correct timer frequency

Baolin Liu <liubaolin@kylinos.cn>
    isofs: fix Rock Ridge CE extent validation on multisession media

Thorsten Blum <blum@kernel.org>
    thermal: intel: int340x: Fix temperature selection around 0 C

Thorsten Blum <thorsten.blum@linux.dev>
    thermal: intel: powerclamp: Reject invalid window_size values

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Set MMC clock pins as OUTPUT

Amir Goldstein <amir73il@gmail.com>
    fs: make sure to call fsnotify_inoderemove() only once when inode is dead

Karl Mehltretter <kmehltretter@gmail.com>
    fs_pin: publish pins with RCU list helpers

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spi-nor: Unprepare legacy controllers upon RWW wait interruption

HyeongJun An <sammiee5311@gmail.com>
    mtd: spi-nor: sfdp: check the length of the SCCR map

HyeongJun An <sammiee5311@gmail.com>
    mtd: spi-nor: sfdp: check the length of the xSPI Profile 1.0 table

Serin Yeh <serin.yeh@intel.com>
    media: i2c: ov8856: fix debug message to report actual CSI-2 lane count

Serin Yeh <serin.yeh@intel.com>
    media: i2c: ov8856 : remove ACPI node bypass mechanism

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    hte: tegra194: Initialize slice locks before registering chip

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Fix queue/stack map u32 index overflow

Yo'av Moshe <linux@yoavmoshe.com>
    ARM: imx: Fix suspend/resume crash with Clang CFI

hanzhijian <hanzhijian1991@gmail.com>
    clk: mstar: msc313-mpll: fix off-by-one in clock array allocation

Sakari Ailus <sakari.ailus@linux.intel.com>
    platform/x86: int3472: Fix uninitialised variable warning

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: rtw89: cap firmware section_num before parsing

Yi Cong <yicong@kylinos.cn>
    wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields

イムティヤズ <reza1234khan1234@gmail.com>
    wifi: rtw88: fix out-of-bounds CAM write when key table is full

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    memory: renesas-rpc-if: Mark XSPI_CDD1BUF0 as volatile

Justin Chen <justin.chen@broadcom.com>
    memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT

Justin Chen <justin.chen@broadcom.com>
    memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset

Sam Price <thesamprice@gmail.com>
    microblaze: preserve the MSR carry flags across signals

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: restore the ABI argument home area below pt_regs (PTO)

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: don't clobber r3/r4 restored by rt_sigreturn

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: reserve the ABI argument-home area in the signal frame

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Fix write to read-only firmware buffer

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Fix fw_end computed before round-up; propagate size to caller

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Widen fw_size to u32 to prevent wrap-around

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Fix endian conversion for serial_protocol comparison

HyeongJun An <sammiee5311@gmail.com>
    remoteproc: elf_loader: Bound the section header table

Daehyeon Ko <4ncienth@gmail.com>
    ipc/mqueue: release notification resources during inode eviction

Daehyeon Ko <4ncienth@gmail.com>
    aio: prevent eventfd/epoll recursion on poll

Jan Kara <jack@suse.cz>
    udf: Make sure there's enough space for LVID implementation use field

Karl Mehltretter <kmehltretter@gmail.com>
    microblaze: Fix MB_MANAGER build with older binutils

Fan Wu <fanwu01@zju.edu.cn>
    media: imx-jpeg: finish the job on device_run() error paths

Sean Young <sean@mess.org>
    media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled

Sean Young <sean@mess.org>
    media: meson-ir-tx: Ensure probe error is propagated

Sean Young <sean@mess.org>
    media: meson-ir-tx: Ensure rc_free_device() is called on unbind

Sean Young <sean@mess.org>
    media: meson-ir-tx: Ensure clock is disabled on unbind

Sean Young <sean@mess.org>
    media: sunxi-cir: Ensure no more interrupts can occur before free

Sean Young <sean@mess.org>
    media: redrat3: Ensure all urbs are suspended

Sean Young <sean@mess.org>
    media: redrat3: Ensure we don't read beyond the end of the packet

Sean Young <sean@mess.org>
    media: streamzap: Add missing rc_unregister_device()

Daniel Schwierzeck <daniel.schwierzeck@gmail.com>
    cpufreq: airoha: fix probe failure with correct error check

Jakub Szczudlo <jakubszczudlo40@gmail.com>
    iio: adc: ti-ads1100: Fix incorrect reading when datarate changed in single mode

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Force GAMCOR for subsampled surfaces with PQ/Gamma22/HLG

YuBiao Wang <YuBiao.Wang@amd.com>
    drm/amdgpu: recompute the dw estimate after allocating a new VM update job

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: don't dereference outp before checking it in nouveau_dp_irq

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: cancel the DP IRQ work before freeing the connector

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: disable the fence uevent work instead of just cancelling it

Marek Czernohous <marek@czernohous.de>
    drm/nouveau/pci: use config-space MSI rearm on MCP79/MCP7A (NVAC)

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/svm: drain fault handler before freeing svmm

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau: reject zero-size notifier object allocation

Miguel Ojeda <ojeda@kernel.org>
    rust: bitmap: fix intra-doc link

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix swap entry value to folio_pfn()

Sami Tolvanen <samitolvanen@google.com>
    rust: dma: declare cfi_encoding for dma_data_direction

Sami Tolvanen <samitolvanen@google.com>
    rust: hrtimer: declare cfi_encoding for hrtimer_restart

Sami Tolvanen <samitolvanen@google.com>
    rust: irq: declare cfi_encoding for irqreturn

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF

Marco Crivellari <marco.crivellari@suse.com>
    nvmet: replace use of system_wq with system_percpu_wq

Danish Khateeb <danishkhateeb03@gmail.com>
    pps: generators: don't use the driver's info after unregister

Weiming Shi <bestswngs@gmail.com>
    virtio_net: atomically disable rx mode work

Ruide Cao <caoruide123@gmail.com>
    mptcp: hold MP_JOIN msk ref when cloning reqsk

Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
    tcp: accecn: unset ECT if receive or send ACE=0 in AccECN negotiaion

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Remove timeout arg from reqsk_timeout().

Tianchu Chen <flynnnchen@tencent.com>
    staging: rtl8723bs: fix protected RX frame validation in decrypt path

Khasar Munkh-Erdene <02khasar@gmail.com>
    staging: rtl8723bs: fix spacing around operators in rtw_recv.c

Zhang Yi <yi.zhang@huawei.com>
    mm/truncate: look up the end-edge straddler by index

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Gracefully handle xarray errors when binding a memslot

Honglei Huang <honghuan@amd.com>
    drm/amdgpu: drop retry loop in amdgpu_hmm_range_get_pages

Hyunwoo Kim <imv4bel@gmail.com>
    inet: reject unhashed sockets during established lookups

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: Use pr_warn() for early W^X warnings

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Formally define KVM's "0xdead" exit reason used for failed VM-Enter


-------------

Diffstat:

 .../bindings/clock/nuvoton,ma35d1-clk.yaml         |  16 +-
 Documentation/hwmon/k10temp.rst                    |   8 +-
 Documentation/networking/ip-sysctl.rst             |   5 +-
 Documentation/userspace-api/check_exec.rst         |   4 +
 Documentation/virt/hyperv/vmbus.rst                |  17 +-
 Makefile                                           |   4 +-
 arch/alpha/include/asm/mmu_context.h               |  35 ++-
 arch/alpha/include/asm/sfp-machine.h               |   4 +
 arch/alpha/include/asm/switch_to.h                 |   1 -
 arch/alpha/include/asm/tlbflush.h                  |   3 +-
 arch/alpha/kernel/smp.c                            |  67 ++--
 arch/alpha/mm/fault.c                              |  23 +-
 arch/alpha/mm/tlbflush.c                           |  18 +-
 arch/arm/include/asm/linkage.h                     |  29 ++
 arch/arm/include/asm/smp.h                         |   2 +-
 arch/arm/kernel/cacheinfo.c                        |  51 +--
 arch/arm/kernel/head-nommu.S                       |   1 +
 arch/arm/kernel/head.S                             |   1 +
 arch/arm/kernel/smp.c                              |  15 +-
 arch/arm/kernel/topology.c                         |  13 +
 arch/arm/mach-imx/pm-imx6.c                        |  26 +-
 arch/arm/mach-imx/suspend-imx6.S                   |   6 +-
 arch/arm/mm/alignment.c                            |  51 ++-
 .../boot/dts/freescale/imx8mm-verdin-ivy.dtsi      |   4 +-
 .../boot/dts/freescale/imx8mp-toradex-smarc.dtsi   |   2 +-
 .../boot/dts/freescale/imx8mp-verdin-ivy.dtsi      |   4 +-
 .../boot/dts/freescale/imx8mp-verdin-yavia.dtsi    |   7 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |   1 +
 arch/arm64/boot/dts/qcom/ipq9574.dtsi              |   2 +-
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |   6 +
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |   6 +
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi    |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts   |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   6 +-
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts     |   6 +-
 arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi     |   2 +-
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi   |   2 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   5 +-
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi |   2 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |   2 +-
 arch/arm64/include/asm/kvm_arm.h                   |   2 +-
 arch/arm64/include/asm/kvm_host.h                  |   7 +-
 arch/arm64/include/asm/pgtable.h                   |   3 +
 arch/arm64/kernel/efi.c                            |   8 +-
 arch/arm64/kvm/arm.c                               |  49 +--
 arch/arm64/kvm/hyp/exception.c                     |   5 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |  28 ++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   2 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  37 +++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   3 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  33 +-
 arch/arm64/mm/contpte.c                            |   4 +-
 arch/loongarch/include/asm/barrier.h               |   3 -
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/include/asm/loongarch.h             |   4 +-
 arch/loongarch/include/asm/numa.h                  |   2 +-
 arch/loongarch/kernel/cpu-probe.c                  |   2 +-
 arch/loongarch/kernel/hw_breakpoint.c              |  27 +-
 arch/loongarch/kernel/irq.c                        |   3 +-
 arch/loongarch/kernel/traps.c                      |  13 +-
 arch/loongarch/pci/pci.c                           |   3 +-
 arch/microblaze/include/asm/entry.h                |  13 +
 arch/microblaze/include/asm/processor.h            |   2 +-
 arch/microblaze/kernel/entry.S                     | 348 +++++++++++----------
 arch/microblaze/kernel/hw_exception_handler.S      |   5 +
 arch/microblaze/kernel/process.c                   |   5 +-
 arch/microblaze/kernel/signal.c                    |  26 ++
 arch/mips/mm/mmap.c                                |   6 +-
 arch/mips/mm/tlb-r4k.c                             |  21 +-
 arch/powerpc/platforms/pseries/plpks.c             |  27 +-
 arch/powerpc/platforms/pseries/plpks_sed_ops.c     |  12 +-
 arch/riscv/include/asm/pgtable.h                   |   9 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  12 +-
 arch/x86/include/asm/vmx.h                         |   8 +
 arch/x86/kernel/cpu/bugs.c                         |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   4 +-
 arch/x86/mm/pat/set_memory.c                       |  15 +
 block/blk-iocost.c                                 |   2 +
 block/blk-mq.c                                     |   2 +
 crypto/algif_skcipher.c                            |   8 +-
 crypto/ecc.c                                       |  33 +-
 crypto/testmgr.c                                   |  11 +-
 crypto/testmgr.h                                   | 327 ++++++++++++++++++-
 drivers/accessibility/speakup/selection.c          |   6 +
 drivers/acpi/pfr_update.c                          |   2 +-
 drivers/ata/ahci_st.c                              |  78 ++---
 drivers/ata/libahci.c                              |  28 +-
 drivers/ata/libahci_platform.c                     |   4 +
 drivers/ata/libata-core.c                          |  75 ++++-
 drivers/ata/libata-scsi.c                          |   5 +
 drivers/ata/libata-sff.c                           |   5 +
 drivers/ata/sata_fsl.c                             |   6 +-
 drivers/ata/sata_qstor.c                           |   8 +-
 drivers/block/amiflop.c                            |  71 ++++-
 drivers/block/aoe/aoenet.c                         |  14 +-
 drivers/block/floppy.c                             |   8 +-
 drivers/block/loop.c                               |   6 +-
 drivers/block/ublk_drv.c                           |  27 +-
 drivers/block/xen-blkfront.c                       |   4 +-
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/char/hw_random/amd-rng.c                   |   2 +-
 drivers/char/hw_random/ba431-rng.c                 |   2 +-
 drivers/char/hw_random/core.c                      |   1 +
 drivers/char/tpm/tpm-dev-common.c                  |   3 +
 drivers/char/tpm/tpm_nsc.c                         |   8 +-
 drivers/clk/imx/clk.c                              |  15 +-
 drivers/clk/mstar/clk-msc313-mpll.c                |   2 +-
 drivers/clk/mvebu/ap-cpu-clk.c                     |   4 +-
 drivers/clk/qcom/gcc-ipq5018.c                     |  10 +
 drivers/clk/qcom/gcc-ipq5332.c                     |   1 +
 drivers/clk/qcom/ipq-cmn-pll.c                     |   3 +-
 drivers/clk/starfive/clk-starfive-jh7110-isp.c     |   2 +-
 drivers/clocksource/timer-digicolor.c              |   2 +
 drivers/clocksource/timer-fttmr010.c               |   2 +
 drivers/cpufreq/Kconfig                            |   1 +
 drivers/cpufreq/airoha-cpufreq.c                   |   2 +-
 drivers/cpufreq/amd-pstate.c                       |   6 +-
 drivers/cpufreq/cpufreq_conservative.c             |   8 +-
 drivers/cpufreq/cpufreq_governor.c                 |  29 +-
 drivers/cpufreq/cpufreq_governor.h                 |   2 +
 drivers/cpufreq/cpufreq_stats.c                    |   4 +
 drivers/cpufreq/intel_pstate.c                     |   2 +
 drivers/cpufreq/loongson3_cpufreq.c                |  73 +++--
 drivers/crypto/amlogic/amlogic-gxl-core.c          |   7 +-
 drivers/crypto/atmel-aes.c                         |   2 +-
 drivers/crypto/atmel-tdes.c                        |   6 +-
 drivers/crypto/caam/caampkc.c                      |   6 +
 drivers/crypto/ccp/dbc.c                           |   4 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  20 +-
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c  |  10 +-
 .../crypto/intel/qat/qat_common/adf_gen4_vf_mig.c  |   5 +
 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c |  20 +-
 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h |  24 +-
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |   2 -
 drivers/crypto/nx/nx-842.c                         |   2 +
 drivers/crypto/omap-des.c                          |   2 +
 drivers/crypto/xilinx/zynqmp-sha.c                 |   2 +-
 drivers/cxl/acpi.c                                 |  20 +-
 drivers/cxl/core/pci.c                             |  50 +--
 drivers/cxl/core/port.c                            |   3 +
 drivers/dax/super.c                                |   2 +-
 drivers/dma/altera-msgdma.c                        |  10 +-
 drivers/edac/i10nm_base.c                          |   1 +
 drivers/firewire/ohci-serdes-test.c                |   4 +-
 drivers/firewire/ohci.h                            |   2 +-
 drivers/firmware/efi/libstub/Makefile              |   2 +-
 drivers/firmware/efi/libstub/efi-stub.c            |   8 +
 drivers/fpga/fpga-mgr.c                            |   2 +-
 drivers/gpio/gpio-davinci.c                        |   6 +-
 drivers/gpio/gpio-pca953x.c                        |  14 +-
 drivers/gpio/gpiolib-cdev.c                        |   5 -
 drivers/gpio/gpiolib.c                             |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |  19 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   | 105 ++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  14 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  33 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   5 +
 drivers/gpu/drm/amd/amdgpu/cik.c                   |  10 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  18 +-
 drivers/gpu/drm/amd/amdgpu/si.c                    |  10 +
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  10 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  48 +--
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |  35 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |  23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   4 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |  23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  21 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  11 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   2 +-
 .../gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c   |   2 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |   2 +
 .../drm/amd/display/modules/color/color_gamma.c    |   3 +-
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   2 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |  85 +++++
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |   1 +
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |  33 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  87 +++++-
 drivers/gpu/drm/arm/malidp_crtc.c                  |   1 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  13 +-
 drivers/gpu/drm/drm_panic.c                        |   5 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |  32 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |  16 +-
 drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h  |   1 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 +
 drivers/gpu/drm/nouveau/nouveau_dp.c               |   4 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |  13 +
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild     |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c    |  35 +++
 drivers/gpu/drm/panel/panel-ebbg-ft8719.c          |   2 +
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |  11 +-
 drivers/hte/hte-tegra194-test.c                    |   2 +-
 drivers/hte/hte-tegra194.c                         |  10 +-
 drivers/hwmon/acpi_power_meter.c                   |  10 +-
 drivers/hwmon/coretemp.c                           |  31 +-
 drivers/hwmon/corsair-cpro.c                       |   9 +-
 drivers/hwmon/gigabyte_waterforce.c                |   5 +
 drivers/hwmon/k10temp.c                            |   5 +-
 drivers/hwmon/lm95245.c                            |   6 +-
 drivers/hwmon/sht3x.c                              |   5 +-
 drivers/hwmon/sht4x.c                              |  22 +-
 drivers/i2c/busses/i2c-designware-master.c         |   8 +
 drivers/i2c/busses/i2c-mt7621.c                    |   9 +-
 drivers/i2c/i2c-core-acpi.c                        |   6 +-
 drivers/i3c/master.c                               |   7 +-
 drivers/i3c/master/adi-i3c-master.c                |   4 +
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   2 +-
 drivers/iio/accel/adis16201.c                      |  10 +-
 drivers/iio/accel/adxl313_spi.c                    |   2 +
 drivers/iio/accel/adxl380_spi.c                    |   2 +
 drivers/iio/accel/kxcjk-1013.c                     |   1 +
 drivers/iio/accel/mma9551.c                        |   1 +
 drivers/iio/accel/mma9553.c                        |   1 +
 drivers/iio/adc/ad7606_spi.c                       |   6 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   1 +
 drivers/iio/adc/max11205.c                         |   2 +
 drivers/iio/adc/mcp3911.c                          |   2 +
 drivers/iio/adc/stm32-adc.c                        |   4 +-
 drivers/iio/adc/ti-adc128s052.c                    |   8 +-
 drivers/iio/adc/ti-ads1100.c                       | 107 ++++++-
 drivers/iio/dac/ad5755.c                           |   3 +
 drivers/iio/frequency/adf4377.c                    |   3 +
 drivers/iio/imu/adis16400.c                        |   3 +
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |  17 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   9 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   8 +-
 drivers/iio/light/apds9306.c                       |   2 +-
 drivers/iio/potentiometer/x9250.c                  |   7 +-
 drivers/iio/pressure/bmp280-spi.c                  |   2 +
 drivers/infiniband/hw/hfi1/chip.c                  |   4 +-
 drivers/infiniband/hw/hfi1/fault.c                 |   1 -
 drivers/input/input.c                              |   4 +-
 drivers/input/joystick/xpad.c                      |   1 +
 drivers/input/keyboard/matrix_keypad.c             |   3 -
 drivers/iommu/amd/init.c                           |  23 +-
 drivers/iommu/dma-iommu.c                          |  20 +-
 drivers/iommu/intel/iommu.h                        |  17 +-
 drivers/iommu/iommufd/io_pagetable.c               |   3 +
 drivers/irqchip/irq-atmel-aic.c                    |   2 +-
 drivers/irqchip/irq-atmel-aic5.c                   |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 +-
 drivers/irqchip/irq-imx-intmux.c                   |  15 +-
 drivers/irqchip/irq-mchp-eic.c                     |   4 +-
 drivers/irqchip/irq-msi-lib.c                      |   1 +
 drivers/irqchip/irq-riscv-imsic-platform.c         |   2 +-
 drivers/leds/flash/leds-ktd2692.c                  |  10 +-
 drivers/mailbox/bcm74110-mailbox.c                 |  13 +
 drivers/mailbox/mailbox-altera.c                   |   2 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   7 +-
 drivers/mailbox/qcom-ipcc.c                        |   6 +
 drivers/md/dm-bufio.c                              |  45 ++-
 drivers/md/dm-snap-persistent.c                    |   7 +-
 drivers/md/dm-vdo/indexer/chapter-index.c          |  15 +-
 drivers/md/dm-vdo/indexer/delta-index.c            |  17 +-
 drivers/md/dm-vdo/indexer/volume.c                 |   6 -
 drivers/md/dm-writecache.c                         |  54 +++-
 drivers/md/dm.c                                    |   2 +-
 drivers/md/md.c                                    |  17 +-
 drivers/md/raid5-cache.c                           |  34 +-
 drivers/md/raid5.c                                 |   8 +-
 drivers/md/raid5.h                                 |   1 +
 .../extron-da-hd-4k-plus/extron-da-hd-4k-plus.c    |   4 +-
 drivers/media/common/saa7146/saa7146_core.c        |   3 +-
 drivers/media/dvb-frontends/stv0900_core.c         |   2 +
 drivers/media/dvb-frontends/stv090x.c              |   2 +
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/adv7604.c                        |   3 +-
 drivers/media/i2c/alvium-csi2.c                    |   1 +
 drivers/media/i2c/ov2735.c                         |   1 +
 drivers/media/i2c/ov8856.c                         |  32 +-
 drivers/media/i2c/tc358743.c                       |   3 +-
 drivers/media/pci/cx18/cx18-driver.c               |   9 +-
 drivers/media/pci/tw68/tw68-core.c                 |   2 +-
 drivers/media/pci/tw686x/tw686x-core.c             |  10 +
 drivers/media/platform/amphion/vpu_core.c          |  19 +-
 drivers/media/platform/amphion/vpu_drv.c           |   1 +
 drivers/media/platform/atmel/atmel-isi.c           |   7 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |   8 +-
 .../media/platform/chips-media/wave5/wave5-vpu.c   |   7 +
 .../platform/chips-media/wave5/wave5-vpuapi.c      |  15 +-
 .../media/platform/imagination/e5010-jpeg-enc.c    |   4 +-
 drivers/media/platform/m2m-deinterlace.c           |   2 +-
 drivers/media/platform/marvell/Kconfig             |   1 +
 drivers/media/platform/marvell/mmp-driver.c        |   5 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |  17 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-comp.c   |  14 +-
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c   |   2 +
 drivers/media/platform/mediatek/vpu/mtk_vpu.c      |   2 +
 .../media/platform/microchip/microchip-isc-base.c  |  56 ++--
 .../media/platform/microchip/microchip-isc-clk.c   |   7 +-
 drivers/media/platform/microchip/microchip-isc.h   |   1 +
 .../platform/microchip/microchip-sama5d2-isc.c     |  11 +
 .../platform/microchip/microchip-sama7g5-isc.c     |  11 +
 drivers/media/platform/nuvoton/npcm-video.c        |   9 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |  21 +-
 drivers/media/platform/qcom/camss/camss-vfe-17x.c  |  46 +--
 drivers/media/platform/qcom/camss/camss-vfe.c      |  14 +-
 drivers/media/platform/qcom/camss/camss.c          |  25 +-
 drivers/media/platform/qcom/iris/iris_vidc.c       |   6 +-
 drivers/media/platform/qcom/venus/core.c           |  66 +++-
 drivers/media/platform/qcom/venus/core.h           |   6 +
 .../media/platform/samsung/exynos4-is/fimc-lite.c  |   3 +-
 .../media/platform/st/sti/delta/delta-mjpeg-hdr.c  |   7 +-
 drivers/media/platform/st/stm32/stm32-csi.c        |   5 +-
 .../media/platform/synopsys/hdmirx/snps_hdmirx.c   |  80 ++---
 drivers/media/platform/ti/davinci/vpif_capture.c   |   5 +-
 drivers/media/platform/ti/davinci/vpif_display.c   |   3 +
 drivers/media/platform/verisilicon/hantro_drv.c    |  75 +++--
 .../platform/verisilicon/hantro_g1_mpeg2_dec.c     |   5 +
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |  68 +++-
 drivers/media/rc/ene_ir.c                          |   4 +-
 drivers/media/rc/ir-hix5hd2.c                      |   5 +-
 drivers/media/rc/ir_toy.c                          |   2 +-
 drivers/media/rc/meson-ir-tx.c                     |  20 +-
 drivers/media/rc/redrat3.c                         |  17 +
 drivers/media/rc/serial_ir.c                       |   2 +-
 drivers/media/rc/streamzap.c                       |   1 +
 drivers/media/rc/sunxi-cir.c                       |   2 +-
 drivers/media/test-drivers/vicodec/codec-fwht.h    |   2 +-
 drivers/media/test-drivers/vicodec/vicodec-core.c  |  16 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +
 drivers/media/test-drivers/vidtv/vidtv_demod.c     |   9 -
 drivers/media/test-drivers/vim2m.c                 |  29 +-
 drivers/media/test-drivers/vivid/vivid-core.c      |   1 +
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  13 +
 drivers/media/usb/au0828/au0828-core.c             |   4 +
 drivers/media/usb/au0828/au0828-dvb.c              |  19 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c          |  15 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |   2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |  14 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   3 -
 drivers/media/usb/go7007/go7007-usb.c              |   8 +
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          |   1 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |   2 +-
 drivers/media/v4l2-core/v4l2-common.c              |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  12 +-
 drivers/memory/brcmstb_dpfe.c                      |  24 +-
 drivers/memory/renesas-rpc-if.c                    |   1 +
 drivers/memory/stm32_omm.c                         |   2 +
 drivers/mfd/Kconfig                                |   2 +
 drivers/mfd/da903x.c                               |  34 +-
 drivers/mfd/tps65217.c                             |  69 ++--
 drivers/mfd/wcd934x.c                              |   8 +-
 drivers/misc/mei/vsc-tp.c                          |   2 +-
 drivers/mtd/chips/cfi_cmdset_0002.c                |  15 +
 drivers/mtd/maps/amd76xrom.c                       |   2 +
 drivers/mtd/maps/l440gx.c                          |   2 -
 drivers/mtd/maps/pci.c                             |   2 +-
 drivers/mtd/mtdcore.c                              |   2 +-
 drivers/mtd/mtdsuper.c                             |   4 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   6 +-
 .../mtd/nand/raw/nuvoton-ma35d1-nand-controller.c  |   1 -
 drivers/mtd/nand/raw/qcom_nandc.c                  |   8 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   3 +
 drivers/mtd/parsers/qcomsmempart.c                 |   4 +-
 drivers/mtd/spi-nor/core.c                         |   9 +
 drivers/mtd/spi-nor/sfdp.c                         |   8 +
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/ethernet/google/gve/gve_flow_rule.c    |   1 +
 drivers/net/ethernet/hisilicon/hisi_femac.c        |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  40 ++-
 drivers/net/macvlan.c                              |   3 +-
 drivers/net/netdevsim/bpf.c                        |  11 +
 drivers/net/ppp/ppp_generic.c                      |   1 +
 drivers/net/usb/pegasus.c                          |  12 +-
 drivers/net/usb/r8152.c                            |  10 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/virtio_net.c                           |  25 +-
 drivers/net/wireless/ath/ath11k/dp.c               |   2 +
 drivers/net/wireless/ath/ath12k/wmi.c              |  17 +
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  17 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  17 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  19 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  31 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  32 ++
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |   4 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |   6 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |   5 +
 drivers/nvme/host/auth.c                           |  15 +-
 drivers/nvme/host/core.c                           |  15 +-
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/nvme/host/sysfs.c                          |  14 +-
 drivers/nvme/host/tcp.c                            |  24 +-
 drivers/nvme/target/admin-cmd.c                    |   2 +-
 drivers/nvme/target/auth.c                         |   2 +
 drivers/nvme/target/configfs.c                     |   2 +
 drivers/nvme/target/fabrics-cmd-auth.c             |  42 ++-
 drivers/nvme/target/fabrics-cmd.c                  |   4 +
 drivers/nvme/target/fc.c                           |  10 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   5 +-
 drivers/nvme/target/io-cmd-file.c                  |   4 +-
 drivers/nvme/target/nvmet.h                        |   2 +
 drivers/nvme/target/pci-epf.c                      |  30 +-
 drivers/nvme/target/pr.c                           |   2 +-
 drivers/nvme/target/rdma.c                         |   2 +-
 drivers/nvme/target/zns.c                          |  10 +
 drivers/parisc/eisa_enumerator.c                   |  15 +-
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   2 +
 drivers/pci/controller/pcie-rockchip-ep.c          |  13 -
 drivers/pci/controller/pcie-rockchip-host.c        |  20 --
 drivers/pci/controller/pcie-rockchip.c             |  14 +-
 drivers/pci/controller/pcie-rockchip.h             |   3 -
 drivers/pci/controller/pcie-xilinx-dma-pl.c        |  10 +-
 drivers/pci/doe.c                                  |   5 +-
 drivers/pci/hotplug/pciehp_core.c                  |   2 +-
 drivers/pci/pci-label.c                            |   2 +-
 drivers/pci/pci.c                                  |  33 +-
 drivers/pci/pcie/aer.c                             |   7 +-
 drivers/pci/probe.c                                |   5 +-
 drivers/pci/quirks.c                               |  26 +-
 drivers/pci/xen-pcifront.c                         |  11 +-
 drivers/peci/controller/peci-aspeed.c              |   6 +-
 drivers/peci/controller/peci-npcm.c                |   6 +-
 drivers/perf/xgene_pmu.c                           |   4 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   6 +-
 drivers/platform/x86/amd/hfi/hfi.c                 |  20 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |  20 +-
 drivers/platform/x86/amd/pmf/spc.c                 |   8 +-
 drivers/platform/x86/amd/pmf/sps.c                 |  10 +-
 drivers/platform/x86/asus-wmi.c                    |  42 ++-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |  82 ++---
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |  16 +-
 .../platform/x86/hp/hp-bioscfg/spmobj-attributes.c |   5 +-
 drivers/platform/x86/hp/hp-wmi.c                   |   7 +-
 drivers/platform/x86/intel/int3472/discrete.c      |  25 +-
 drivers/platform/x86/intel/pmt/class.c             |   9 +-
 .../x86/intel/uncore-frequency/uncore-frequency.c  |   2 +-
 drivers/platform/x86/intel/vsec.c                  |   2 +-
 drivers/platform/x86/oxpec.c                       |  68 +++-
 drivers/platform/x86/siemens/simatic-ipc.c         |  21 +-
 drivers/platform/x86/tuxedo/nb04/wmi_ab.c          |   8 +-
 drivers/power/supply/ab8500_fg.c                   |  69 ++--
 drivers/power/supply/bq27xxx_battery.c             |  12 +-
 drivers/power/supply/cros_charge-control.c         |  29 +-
 drivers/power/supply/generic-adc-battery.c         |   2 +-
 drivers/power/supply/power_supply_core.c           |  84 ++---
 drivers/power/supply/qcom_battmgr.c                |  26 +-
 drivers/power/supply/qcom_smbx.c                   | 109 +++++--
 drivers/pps/generators/pps_gen.c                   |  40 ++-
 drivers/pwm/pwm-tiehrpwm.c                         |   3 +
 drivers/regulator/core.c                           |   4 +
 drivers/regulator/rt6190-regulator.c               |  18 +-
 drivers/remoteproc/remoteproc_elf_loader.c         |  23 +-
 drivers/rtc/rtc-cmos.c                             |   6 +-
 drivers/rtc/rtc-pcf8563.c                          |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   3 +-
 drivers/sh/intc/core.c                             |  11 +-
 drivers/sh/maple/maple.c                           |   4 +-
 drivers/slimbus/messaging.c                        |   2 +-
 drivers/soc/fsl/dpio/dpio-driver.c                 |   9 +-
 drivers/soc/fsl/qe/tsa.c                           |  16 +-
 drivers/soc/qcom/qcom-geni-se.c                    |  49 +--
 drivers/soc/samsung/exynos-pmu.c                   |  61 +++-
 drivers/spi/spi-amd.c                              |  17 +
 drivers/spi/spi-bcm-qspi.c                         |   3 +-
 drivers/spi/spi-bcm2835.c                          |   4 +-
 drivers/spi/spi-cadence-xspi.c                     |  16 +-
 drivers/spi/spi-ch341.c                            |   6 +
 drivers/spi/spi-jcore.c                            |   2 +
 drivers/spi/spi-ljca.c                             |   7 +-
 drivers/spi/spi-npcm-fiu.c                         |   8 +
 drivers/spi/spi-qpic-snand.c                       |   3 +
 drivers/spi/spi-stm32.c                            |   3 +-
 drivers/spi/spi-zynq-qspi.c                        |  13 +-
 drivers/staging/greybus/uart.c                     |  32 +-
 drivers/staging/media/av7110/sp8870.c              |   5 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   1 +
 drivers/staging/media/meson/vdec/vdec.c            |   2 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          | 103 +++---
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |   7 +
 .../int340x_thermal/processor_thermal_device.c     |  10 +-
 drivers/thermal/intel/intel_powerclamp.c           |   3 +-
 drivers/tty/serial/8250/8250_exar.c                |  36 +--
 drivers/tty/serial/8250/8250_lpss.c                |   7 +-
 drivers/tty/serial/8250/8250_omap.c                |   3 +
 drivers/tty/serial/amba-pl011.c                    |  37 ++-
 drivers/tty/serial/pmac_zilog.c                    |   4 +-
 drivers/ufs/core/ufs_bsg.c                         |  10 +-
 drivers/ufs/core/ufshcd.c                          |  21 +-
 drivers/usb/class/cdc-acm.c                        |   6 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/fotg210/fotg210-udc.c                  |  17 +-
 drivers/usb/gadget/legacy/inode.c                  |   4 +-
 drivers/usb/host/xhci-ring.c                       |   9 +-
 drivers/usb/host/xhci.c                            |  11 +-
 drivers/usb/serial/option.c                        |   5 +
 drivers/usb/serial/sierra.c                        |   3 +-
 drivers/usb/serial/usb_wwan.c                      |   3 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |  37 ++-
 drivers/vfio/pci/mlx5/cmd.c                        |   2 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |  13 +-
 drivers/video/fbdev/core/bitblit.c                 |   7 +-
 drivers/video/fbdev/kyro/fbdev.c                   |   4 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   6 +-
 drivers/video/fbdev/smscufx.c                      |   9 +-
 drivers/video/fbdev/ssd1307fb.c                    |   6 +-
 drivers/video/fbdev/udlfb.c                        |   9 +-
 drivers/video/fbdev/xen-fbfront.c                  |   7 +-
 drivers/xen/gntdev.c                               |   7 +
 drivers/xen/privcmd.c                              |  47 ++-
 drivers/xen/xen-pciback/pci_stub.c                 |   7 +-
 fs/affs/bitmap.c                                   |   2 +-
 fs/aio.c                                           |  18 +-
 fs/backing-file.c                                  |  39 +++
 fs/btrfs/inode.c                                   |   3 -
 fs/btrfs/super.c                                   |   3 +
 fs/btrfs/volumes.c                                 |   6 +-
 fs/ceph/addr.c                                     |  15 +-
 fs/ceph/caps.c                                     |   6 +
 fs/ceph/crypto.c                                   |   3 +
 fs/ceph/mds_client.c                               |  28 +-
 fs/ceph/mdsmap.c                                   |  12 +-
 fs/ceph/snap.c                                     |   7 +-
 fs/ceph/xattr.c                                    |  10 +
 fs/crypto/keysetup.c                               |   8 +-
 fs/dax.c                                           |  14 +-
 fs/dcache.c                                        |  16 +-
 fs/dlm/lowcomms.c                                  |   6 +-
 fs/erofs/decompressor.c                            |   2 +-
 fs/exportfs/expfs.c                                |   6 +-
 fs/ext4/balloc.c                                   |   2 +-
 fs/ext4/ext4.h                                     |   3 +
 fs/ext4/extents.c                                  |  26 +-
 fs/ext4/indirect.c                                 |  17 +
 fs/ext4/inode.c                                    |  13 +-
 fs/ext4/ioctl.c                                    |   3 +-
 fs/ext4/namei.c                                    |  11 +-
 fs/ext4/super.c                                    |  29 +-
 fs/f2fs/compress.c                                 |  10 +-
 fs/f2fs/data.c                                     |  11 +-
 fs/f2fs/file.c                                     |  49 +--
 fs/f2fs/segment.c                                  |   3 +-
 fs/f2fs/super.c                                    |  48 ++-
 fs/fat/fat.h                                       |   2 +-
 fs/fat/fatent.c                                    |  21 +-
 fs/fat/file.c                                      |   3 +-
 fs/fat/misc.c                                      |   6 +-
 fs/fs-writeback.c                                  |   7 +-
 fs/fs_pin.c                                        |   9 +-
 fs/fuse/file.c                                     |  15 +-
 fs/fuse/virtio_fs.c                                |  21 +-
 fs/gfs2/lops.c                                     |   4 +-
 fs/iomap/fiemap.c                                  |   8 +-
 fs/isofs/inode.c                                   |   2 +
 fs/isofs/isofs.h                                   |   2 +
 fs/isofs/rock.c                                    |  11 +-
 fs/jbd2/journal.c                                  |   2 +-
 fs/namespace.c                                     |   7 +-
 fs/nilfs2/dir.c                                    |  34 ++
 fs/nilfs2/inode.c                                  |   8 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/mdt.c                                    |   6 +-
 fs/nilfs2/page.c                                   |  50 +--
 fs/nilfs2/page.h                                   |   4 +-
 fs/nilfs2/recovery.c                               |   2 +-
 fs/nilfs2/segment.c                                |  12 +-
 fs/nilfs2/sysfs.c                                  |   5 +-
 fs/nilfs2/the_nilfs.c                              |  34 +-
 fs/notify/fanotify/fanotify.c                      |   7 +-
 fs/notify/fanotify/fanotify.h                      |  21 +-
 fs/ntfs3/fslog.c                                   |  29 +-
 fs/ntfs3/index.c                                   |  13 +-
 fs/ocfs2/cluster/heartbeat.c                       |  26 +-
 fs/ocfs2/cluster/nodemanager.c                     |   7 +-
 fs/ocfs2/dir.c                                     |  76 ++++-
 fs/ocfs2/dlmglue.c                                 |   4 +
 fs/ocfs2/file.c                                    |  18 +-
 fs/ocfs2/inode.c                                   |  37 ++-
 fs/ocfs2/journal.c                                 |   3 +-
 fs/ocfs2/journal.h                                 |   1 -
 fs/ocfs2/super.c                                   |  16 +-
 fs/ocfs2/xattr.c                                   | 142 +++++++--
 fs/proc/generic.c                                  |   5 +-
 fs/read_write.c                                    |   8 +-
 fs/signalfd.c                                      |  28 +-
 fs/splice.c                                        |  12 +-
 fs/stat.c                                          |   6 +-
 fs/udf/super.c                                     |   5 +-
 fs/verity/open.c                                   |  38 +--
 fs/xfs/scrub/agheader.c                            |  15 +-
 include/linux/fault-inject.h                       |  10 +-
 include/linux/fs.h                                 |   4 +-
 include/linux/libata.h                             |   1 +
 include/linux/pci.h                                |   2 +-
 include/linux/pps_gen_kernel.h                     |   2 +
 include/linux/rtc.h                                |   2 +
 include/math-emu/op-common.h                       |  23 +-
 include/math-emu/soft-fp.h                         |   8 +
 include/media/v4l2-ctrls.h                         |   6 +
 include/net/addrconf.h                             |   3 +
 include/net/inet_connection_sock.h                 |   8 -
 include/net/ip.h                                   |  25 --
 include/net/ip6_route.h                            |  37 ---
 include/net/mptcp.h                                |   9 +
 include/net/tcp.h                                  |   7 +
 include/trace/events/huge_memory.h                 |   6 +-
 init/main.c                                        |   6 +-
 init/version.c                                     |   3 +
 ipc/mqueue.c                                       |   7 +
 ipc/msgutil.c                                      |   3 +-
 ipc/shm.c                                          |  23 +-
 kernel/bpf/queue_stack_maps.c                      |   3 +
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/cpu_pm.c                                    |   9 +-
 kernel/debug/gdbstub.c                             |  55 +++-
 kernel/fork.c                                      |   3 +-
 kernel/irq/internals.h                             |   1 +
 kernel/irq/kexec.c                                 |   2 +-
 kernel/irq/manage.c                                |  43 +--
 kernel/panic.c                                     |   3 +-
 kernel/resource.c                                  |   2 +-
 kernel/sched/cpufreq_schedutil.c                   |  14 +-
 kernel/sched/fair.c                                |   7 +-
 kernel/seccomp.c                                   |   7 +-
 kernel/sys.c                                       |   3 +
 kernel/time/itimer.c                               |   2 +-
 kernel/time/namespace.c                            |   2 +-
 kernel/time/posix-cpu-timers.c                     |   4 +-
 kernel/time/timekeeping.c                          |   3 +-
 kernel/trace/ring_buffer.c                         |   2 +
 kernel/ucount.c                                    |  21 +-
 kernel/user_namespace.c                            |   5 +-
 lib/842/842_decompress.c                           |   7 +-
 lib/alloc_tag.c                                    |   2 +-
 lib/buildid.c                                      |   4 +
 lib/decompress_bunzip2.c                           |   6 +-
 lib/fault-inject.c                                 |   7 +-
 lib/iov_iter.c                                     |   4 +
 lib/kobject_uevent.c                               |   2 +-
 lib/plist.c                                        |   7 +
 lib/stackdepot.c                                   |   2 +-
 mm/damon/core.c                                    |   8 +
 mm/damon/paddr.c                                   |   8 +-
 mm/damon/sysfs-schemes.c                           |   6 +-
 mm/damon/sysfs.c                                   |  11 +-
 mm/damon/tests/core-kunit.h                        | 316 +++++++++++++++++++
 mm/damon/vaddr.c                                   |   5 +-
 mm/execmem.c                                       |   4 +-
 mm/hugetlb.c                                       |  66 ++--
 mm/hugetlb_cgroup.c                                |  33 ++
 mm/khugepaged.c                                    |   7 +-
 mm/ksm.c                                           |   5 +-
 mm/madvise.c                                       |  12 +-
 mm/memcontrol.c                                    |  28 +-
 mm/memory.c                                        |  24 +-
 mm/mempolicy.c                                     |  14 +-
 mm/mlock.c                                         |   2 +-
 mm/mremap.c                                        |  33 +-
 mm/nommu.c                                         |   6 +-
 mm/page_alloc.c                                    |  18 +-
 mm/page_isolation.c                                |  40 ++-
 mm/page_table_check.c                              |   4 +-
 mm/percpu.c                                        |   5 +-
 mm/shmem.c                                         |  11 +-
 mm/swap_state.c                                    |  16 +-
 mm/truncate.c                                      |  33 +-
 mm/userfaultfd.c                                   |   6 +-
 mm/vmscan.c                                        |  10 +-
 mm/zswap.c                                         |   5 +-
 net/bluetooth/6lowpan.c                            |   1 +
 net/bluetooth/hci_debugfs.c                        |   9 +
 net/bluetooth/l2cap_core.c                         |  41 ++-
 net/bluetooth/l2cap_sock.c                         |   4 +
 net/ceph/mon_client.c                              |   3 +
 net/ceph/osd_client.c                              |  13 +-
 net/ceph/osdmap.c                                  |  16 +-
 net/core/dev.c                                     |   8 +
 net/core/gro.c                                     |   4 +
 net/core/skbuff.c                                  |  13 +-
 net/ipv4/inet_connection_sock.c                    |  19 +-
 net/ipv4/inet_hashtables.c                         |   5 +-
 net/ipv4/ipmr.c                                    |   1 +
 net/ipv4/netfilter/nf_reject_ipv4.c                |   5 +
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/syncookies.c                              |   2 +
 net/ipv4/sysctl_net_ipv4.c                         |   2 +
 net/ipv4/tcp_cong.c                                |   4 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/ipv4/tcp_minisocks.c                           |  35 ++-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv4/tcp_timer.c                               |   3 +
 net/ipv6/addrconf.c                                |  46 ++-
 net/ipv6/inet6_hashtables.c                        |   4 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   5 +
 net/ipv6/reassembly.c                              |   1 +
 net/ipv6/route.c                                   |   2 +-
 net/mptcp/protocol.c                               |   9 +-
 net/mptcp/protocol.h                               |   6 +-
 net/mptcp/subflow.c                                |  35 ++-
 net/netfilter/nf_conntrack_netlink.c               |   8 +-
 net/packet/af_packet.c                             |  12 +-
 net/rds/ib_cm.c                                    |   6 +-
 net/rds/ib_recv.c                                  |  13 +-
 net/sctp/socket.c                                  |  26 +-
 net/smc/smc_tx.c                                   |   7 +
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  27 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   3 +-
 net/sunrpc/xprtrdma/verbs.c                        |   9 +-
 net/tipc/group.c                                   |  19 +-
 net/tipc/socket.c                                  |  12 +-
 net/unix/sysctl_net_unix.c                         |   4 +-
 net/xdp/xsk_buff_pool.c                            |   2 +
 rust/Makefile                                      |   5 +-
 rust/bindgen_parameters                            |   5 +
 rust/bindings/lib.rs                               |   1 +
 rust/kernel/bitmap.rs                              |   2 +-
 rust/kernel/dma.rs                                 |  21 +-
 rust/kernel/irq/request.rs                         |  22 +-
 rust/kernel/time/hrtimer.rs                        |   6 +-
 scripts/Makefile.autofdo                           |   2 +-
 security/apparmor/af_unix.c                        |  20 +-
 security/apparmor/file.c                           |  59 ++--
 security/apparmor/include/label.h                  |   6 +-
 security/apparmor/label.c                          |   1 -
 security/apparmor/match.c                          |   3 +-
 security/apparmor/policy.c                         |  16 +
 security/apparmor/policy_unpack.c                  |   9 +
 sound/core/compress_offload.c                      |  32 +-
 sound/core/init.c                                  |  12 +-
 sound/core/seq/oss/seq_oss_device.h                |   1 +
 sound/core/seq/oss/seq_oss_event.c                 |   3 +
 sound/core/seq/oss/seq_oss_init.c                  |   2 +
 sound/core/ump_convert.c                           |   2 +-
 sound/drivers/aloop.c                              |  31 +-
 sound/drivers/mpu401/mpu401_uart.c                 |   8 +-
 sound/drivers/mtpav.c                              |   2 +-
 sound/hda/codecs/hdmi/eld.c                        |   6 +-
 sound/hda/codecs/hdmi/hdmi.c                       |   3 +-
 sound/hda/codecs/realtek/alc269.c                  |   3 +-
 sound/hda/codecs/side-codecs/tas2781_hda_i2c.c     |   5 +
 sound/hda/codecs/via.c                             |   1 +
 sound/hda/common/codec.c                           |   6 +
 sound/hda/common/sysfs.c                           |   4 +
 sound/mips/sgio2audio.c                            |  13 +-
 sound/oss/dmasound/dmasound_q40.c                  |  65 ++--
 sound/pci/cs46xx/dsp_spos.c                        |   2 +-
 sound/soc/codecs/arizona-jack.c                    |   1 +
 sound/soc/codecs/hdac_hda.c                        |  16 +
 sound/soc/codecs/lpass-wsa-macro.c                 |  42 ++-
 sound/soc/codecs/pcm6240.c                         |   2 -
 sound/soc/codecs/rt5682s.c                         |   4 +-
 sound/soc/codecs/rt712-sdca-dmic.c                 |   4 +-
 sound/soc/codecs/tlv320aic32x4-clk.c               |   8 +-
 sound/soc/codecs/wcd9335.c                         |  25 +-
 sound/soc/codecs/wm8994.c                          |   3 +
 sound/soc/codecs/wsa883x.c                         |  13 +-
 sound/soc/codecs/wsa884x.c                         |  11 +-
 sound/soc/fsl/fsl_xcvr.c                           |  28 +-
 sound/soc/intel/atom/sst/sst_acpi.c                |  14 +-
 sound/soc/qcom/qdsp6/q6afe.c                       |  10 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   1 +
 sound/soc/sdw_utils/soc_sdw_rt711.c                |   1 +
 sound/soc/ti/davinci-mcasp.c                       |   1 +
 sound/synth/emux/emux.c                            |  10 +-
 sound/synth/emux/soundfont.c                       |   9 +
 sound/usb/line6/capture.c                          |  25 +-
 sound/usb/line6/capture.h                          |   2 +-
 sound/usb/line6/playback.c                         |  31 +-
 sound/usb/pcm.c                                    |  20 +-
 sound/usb/quirks.c                                 |   2 +
 tools/perf/arch/loongarch/util/header.c            |   2 +-
 tools/perf/util/machine.c                          |   2 +-
 tools/perf/util/powerpc-vpadtl.c                   |   2 +-
 tools/testing/selftests/core/unshare_test.c        |  19 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      | 179 +++++++++++
 virt/kvm/guest_memfd.c                             |  12 +-
 789 files changed, 8003 insertions(+), 2923 deletions(-)


