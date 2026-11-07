Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059976;
	b=Xs0UBfwFj1dEPZtnw1NtYIKf/oWkOIEZAD46/e8wrH/l80vPjSljn93+ch1L6/29HYM6
	 f3QC+J+chsJUUDhYxKV2js8bnL7CTdYMploV74er7VPuyGo+hTx/iyaLaj2fnFG6sjNwP
	 cAeLpKsBIRy31lpbngIJdxhSlPo2SCUnIQ2U2l/17Y4bfT4Rq8mY/h/s4G1ANNPNnOMCW
	 5IHDu34HCNYO4XXGU5u4c8AAQ8ckIPoQgVwr9O8HLJG1HfJW3oYY/cvG6SxVWs3epPmMx
	 84I3v/4z1G8HwXacj+YCIFfAgIYABUL1a1y0sssgndFrV5DdZmelUcwVp4CHQfy6JCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=3nW4z+RE6tFsDwgIBjHbwTriGtV58ub9m+PXFUPK+is=;
	b=vlXUVW28Ga7e6+s/XMAvrlavKCHH76rOL4tol4HT1ndgzGp0TOYL6O3e0E3DTif1GD1I
	 rUC0p7kdZlw1nA9CBoi3F3hxymgkfonNm4faJIaF3YzrwK1PoeZCf42dNaUlx3t9PB2aq
	 s0A7zwhbBjcuxVT3xGr861s/LwEowIvjxWp2P/EwIChwubHbfQY5IUUHpMNf1KzjQvmeo
	 oY55VlA9tac10BFu3xOCaYZkpLalCJwDhQgtOnZzC6qdnlbiXcKfNbikSLuzemzCHlFb8
	 EUYb8CHwa/6ci9t4gAa1IYS8maShP2Xocl+5C5jFxPYsHtYNDRUbsTIfZ8JCWZYCNlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgFdldN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5732B606A326;
	Sat,  7 Nov 2026 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cgFdldN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5451F008A1;
	Sat,  7 Nov 2026 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059975;
	bh=3nW4z+RE6tFsDwgIBjHbwTriGtV58ub9m+PXFUPK+is=;
	h=From:To:Cc:Subject:Date;
	b=cgFdldN292z5riswi1WaxUf5PCcV8bLQwdpVwhXTmayBgrI+ADORDpsI5uCqxQQ5h
	 T/m91sCvT1XSV8JwSvGuA5DszqqGWaGkBCCNiuVNLtv2dvt+NaeV6p54EYgpGUVb3g
	 zz3o9fZztxnpwEG2djCvIz9wtPfOd+aZ2YVnmBow=
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
Subject: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
Date: Sat,  7 Nov 2026 08:33:36 -0500
Message-ID: <20261107134957.653319350@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.117-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.117-rc1
X-KernelTest-Deadline: 2026-11-09T13:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.117 release.
There are 1536 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.117-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.117-rc1

John Johansen <john.johansen@canonical.com>
    apparmor: on failed load ensure profile files are removed before parent

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: read the xattr entry hash before defragmenting the bucket

Scott Gauche <scott-dev@scottgauche.com>
    ALSA: hda/realtek: Fix audio after Windows reboot on ASUS Q423SA

Jason Perlow <jperlow@gmail.com>
    wifi: brcmfmac: map msgbuf RX packet IDs bidirectional

Avi Weiss <thnkslprpt@gmail.com>
    init/bootconfig: pass init arguments in documented order

Amir Goldstein <amir73il@gmail.com>
    fs: don't fail __d_obtain_alias() for unlinked inodes

Hungyu Lin <dennylin0707@gmail.com>
    fs: skip copy_file_range write limits when there is no data

Daehyeon Ko <4ncienth@gmail.com>
    splice: avoid stale f_pos writeback on error

Chris Mason <mason@kernel.org>
    aio: fix NULL deref when a fault races ring truncation

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: remove fs entries created by a failed policy load

Kyle Zeng <kylebot@openai.com>
    tcp: fix reordering addition overflow in MTU probing

Kyle Zeng <kylebot@openai.com>
    net/packet: check TX_RING fragments before memory accounting

John Johansen <john.johansen@canonical.com>
    apparmor: fix refcount leak in aa_get_newest_profile()

Zhiling Zou <zhilinz@nebusec.ai>
    tcp: check congestion control restriction first

Kunhai Dai <daikunhai@didiglobal.com>
    blk-iocost: abort weight transfer on invalid donation weights

Josef Bacik <josef@toxicpanda.com>
    mount: refuse setns() with a shared fs_struct again

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

Martin Belanger <martin.belanger@dell.com>
    nvme-tcp: start error recovery when read_sock fails

Guixin Liu <kanie@linux.alibaba.com>
    nvmet-fc: Tear down the association when the admin queue allocation fails

Shao Mingyin <shao.mingyin@zte.com.cn>
    nvmet-auth: fix error handling on CHALLENGE failure

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

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: evict the queues only once for CRIU PROCESS_INFO

Jiale Yao <yaojiale02@163.com>
    drm/amdkfd: validate SRAT subtables before parsing

Avi Weiss <thnkslprpt@gmail.com>
    drm/amd/display: Initialize missing TD-LUT programming inputs

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: split vram_pages of SVM ranges prefetched without a GPU mapping

Luigi Lauro <luigi.lauro@gmail.com>
    drm/amd/display: take a runtime PM reference only when a CRTC turns on

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    drm/amdkfd: stop restore retries on device unplug

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

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Balance the runtime PM disable in codec remove

Eric Dumazet <edumazet@kernel.org>
    ixgbe: reserve TX timestamp after skb preparation

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda: Reject codec reset on ASoC (ext_ops) buses

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
    ASoC: codecs: wsa884x: Accept temperatures across the full trim range

Val Packett <val@packett.cool>
    ASoC: qcom: qdsp6: q6afe: fix clk vote response type mismatch

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

Rik van Riel <riel@surriel.com>
    mm/page_alloc: count guard pages as free again when their buddy merges

Weilin Tong <tongweilin@linux.alibaba.com>
    ipc/shm: fix RSS accounting for hugetlb shared memory

Pedro Falcato <pfalcato@suse.de>
    mm/madvise: atomically clear the young bit on THP MADV_COLD

Harry Yoo (Meta) <harry@kernel.org>
    mm/percpu: account full object size for percpu memory allocations

Nickolai Zeldovich <nickolai@csail.mit.edu>
    mm/mlock: use a long for the page count in mlock_fixup()

Wei Yang <albinwyang@tencent.com>
    mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: remove zero-address nodes from IP tree on teardown

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: snapshot the dentry name while tracing file release

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

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: wait for a GPU reset before freeing a BO

Keita Morisaki <kmta1236@gmail.com>
    drm/amd/display: Fix swap in median3() for DSC rate control

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: don't drop an SVM CWSR reference that was never taken

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

Luigi Lauro <luigi.lauro@gmail.com>
    drm/amdgpu: require _PR3 for BOCO

Nirmoy Das <nirmoyd@nvidia.com>
    blk-mq: clear stale inactive flag on hctx reuse

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: pca953x: Handle direction register read errors in IRQ paths

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: davinci: Clear interrupt status in every bank on suspend

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    gpiolib: Free chip resources when allocating the label fails

Takashi Iwai <tiwai@suse.de>
    ALSA: emux: Stop voices before freeing zones in all cases

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

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (sht3x) Return the consumed count for heater writes

Ma Ke <make_ruc2021@163.com>
    platform/x86/amd/pmc: Fix RTC reference leak in amd_pmc_verify_czn_rtc()

Gregory Price <gourry@gourry.net>
    rtc: cmos: Disable ACPI RTC event before handling it

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

Nickolai Zeldovich <nickolai@csail.mit.edu>
    lib/buildid: reject file offsets that do not fit in pgoff_t

Sanan Hasanov <sanan.hasanov@ucf.edu>
    hwmon: (corsair-cpro) Make wait_input_report_lock IRQ safe

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

Tim Douglas <me@timdoug.com>
    power: supply: generic-adc-battery: fix status with no supplier

Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>
    ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Skip events until fully initialized

Quanye Yang <quanyeyang@proton.me>
    mptcp: reset msk state on early connect failure

Kees Cook <kees@kernel.org>
    ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again

Fan Wu <fanwu01@zju.edu.cn>
    virtio_fs: read the vring size under virtio_fs_mutex in ->get_tree

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
    KVM: arm64: Move OUTSIDE_GUEST_MODE publication past context being saved

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Don't replace an existing LINUX_EFI_MEMRESERVE table

Weibin Liu <liuwb@xiaopeng.com>
    spi: jcore: fix divide-by-zero when speed_hz is zero

Tal Zussman <tz2294@columbia.edu>
    gfs2: fix the escaped block copy in gfs2_before_commit()

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Correct return size of fill_rpn()

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

Stian Halseth <stian@itx.no>
    PCI: Set supported_speeds in set_pcie_port_type()

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9491/1: alignment: restore uaccess state on emulation fault

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9488/1: smp: set current pointer in assembly before jumping into C

Weibin Liu <liuwb@xiaopeng.com>
    spi: cadence-xspi: fix stack buffer overflow in the Marvell b0 path

Martin Belanger <martin.nvme.dev@gmail.com>
    nvme: make the DH-HMAC-CHAP secret attributes readable by root only

Tim Douglas <me@timdoug.com>
    serial: pmac_zilog: push received data to the port that received it

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

Aamir Ahmed <elb12345@hotmail.co.uk>
    lib: decompress_bunzip2: fix integer overflow in run-length decoding

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
    PCI: rockchip-host: Do not attempt 5.0 GT/s retraining

Daeho Jeong <daehojeong@google.com>
    f2fs: convert inline quota files when turning quota on

Andrea Parri <parri.andrea@gmail.com>
    nvmet: zns: don't leak stale memory in zone management receive

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet: free the bvec on file namespace range errors

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-auth: fail when the controller does not authenticate itself

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-rdma: don't complete a request after a bogus remote invalidation

Andrea Parri <parri.andrea@gmail.com>
    iomap: don't lose a fiemap iteration error when emitting the last extent

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    clk: qcom: ipq5332: add 24MHz rate for USB UTMI clock

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    clk: qcom: ipq5018: add 24MHz rate for USB UTMI clock

Samuel Thibault <samuel.thibault@ens-lyon.org>
    speakup: Fix NULL pointer dereference on VT switch + selection

Wentao Guan <guanwentao@uniontech.com>
    mei: vsc: Fix packet CRC computed over pointer size

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: fix a race leading to an unsigned integer underflow

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250_exar: store the GPIO platform device in struct exar8250

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

Guixiong Wei <weiguixiong@bytedance.com>
    platform/x86/intel-uncore-freq: Continue restoring limits on resume

Guangshuo Li <lgs201920130244@gmail.com>
    platform/x86: simatic-ipc: fix platform device leak on registration failure

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
    platform/x86/amd/pmf: Validate the APTS state index

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    mm/damon/core: charge only the part of a region the filter left

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

Wayne Chang <waynec@nvidia.com>
    usb: typec: ucsi_ccg: Add retry mechanism in ccg_read

Drobyshev Vladimir <enigma_137@icloud.com>
    USB: cdc-acm: add VeriFone VX820 device ID

Koichiro Den <den@valinux.co.jp>
    cxl/acpi: Convert QTG _DSM latencies to picoseconds

Koichiro Den <den@valinux.co.jp>
    cxl: Account for link width in latency calculation

Koichiro Den <den@valinux.co.jp>
    cxl/port: Convert PCIe link latency to nanoseconds

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

Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
    mm/nommu: reject wrapping ranges in access_remote_vm()

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

Hsiu-Hsien Lee <swinds24@gmail.com>
    ext4: fix fast commit replay failing on a read-only mount

Matthias Goergens <matthias.goergens@gmail.com>
    fanotify: report names longer than NAME_MAX

Daehyeon Ko <4ncienth@gmail.com>
    crypto: algif_skcipher - rewind rounded output bytes

Tristan Madani <tristan@talencesecurity.com>
    wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Pass the device name length in UTF-16 code units

Josef Bacik <josef@toxicpanda.com>
    aoe: pull in the headers each received packet type reads

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/digicolor: Fix clk reference leak on request_irq failure

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/fttmr010: Fix clk reference leak in error paths

Wentao Liang <vulab@iscas.ac.cn>
    wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: mt7615: cancel reset work during unregister

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

Gregory Price <gourry@gourry.net>
    mm/mempolicy: take a cpuset cookie for the interleave node count

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz

Darrick J. Wong <djwong@kernel.org>
    xfs: cross-reference the primary superblock

Priyank Rathod <rathodpriyank@google.com>
    PCI/AER: Fix memory leak in aer_recover_queue() on kfifo buffer overflow

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

Andrey Albershteyn <aalbersh@kernel.org>
    fsverity: hoist statx reporting of fs-verity flag

Tharit Tangkijwanichakul <tharitt97@gmail.com>
    media: hantro: disable runtime PM before hardware teardown

Jiawen Liu <1298662399@qq.com>
    media: amphion: fix runtime PM imbalance on probe failure

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

Runyu Xiao <runyu.xiao@seu.edu.cn>
    media: sti: delta: use unaligned accessors for MJPEG SOF fields

Nas Chung <nas.chung@chipsnmedia.com>
    media: v4l2-common: Fix P010 format info

Thorsten Blum <thorsten.blum@linux.dev>
    media: imagination: Fix value clamping in calculate_qp_tables

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: vgic-v3: Roll back assignments from the new region

Karl Mehltretter <kmehltretter@gmail.com>
    KVM: arm64: vgic-v3: Undo assignment on iodev registration failure

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

Vasileios Almpanis <vasileios.almpanis@virtuozzo.com>
    block: drop the cached plug time when blk_add_rq_to_plug() flushes

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

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi_bridge: Correct poweroff/audio cleanup order in post_disable

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    pwm: tiehrpwm: Clear period on disable to allow reconfiguration

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

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe: Fix VFE reset while another line is streaming

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
    iio: pressure: bmp280: validate SPI match data

Jiale Yao <yaojiale02@163.com>
    iio: potentiometer: x9250: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: frequency: adf4377: reject devices without match data

Jiale Yao <yaojiale02@163.com>
    iio: dac: ad5755: validate SPI match data

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: codecs: wcd9335: Fix SLIM interface device leak in wcd9335_slim_status()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Avoid out-of-range shift in qi_desc_dev_iotlb_pasid()

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region

David Heidelberg <david@ixit.cz>
    arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region

Piotr Kubik <piotr@kubik.pl>
    netfilter: ctnetlink: fix inverted IPv6 address match in dump filter

Orgad Shaneh <orgads@gmail.com>
    MIPS: mm: do not write a huge TLB entry when the probe misses

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

Michael J. Ruhl <michael.j.ruhl@intel.com>
    platform/x86/intel/pmt: Block mmap when callback is present

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

Hongyan Xu <getshell@seu.edu.cn>
    mfd: da903x: Cancel IRQ work during teardown

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: gcc-ipq5018: mark 'gpll0_main' clock as critical

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mp-verdin-yavia: fix external GPIOs

Guangshuo Li <lgs201920130244@gmail.com>
    media: atmel-isi: release unregistered video device on remove

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
    arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am625-beagleplay: Set MMC clock pins as OUTPUT

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

Myeonghun Pak <mhun512@gmail.com>
    leds: ktd2692: Pass context to regulator cleanup

Cong Nguyen <congnt264@gmail.com>
    staging: media: imx: csc-scaler: fix ipu_image_convert_run leak on queue error

Hui Peng <benquike@gmail.com>
    seccomp: restore knotif->state when SECCOMP_ADDFD_FLAG_SEND is interrupted

Oleg Nesterov <oleg@redhat.com>
    signalfd: don't dequeue the forced fatal signals

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

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix rdev reference leak in regulator_resolve_supply()

Wentao Liang <vulab@iscas.ac.cn>
    regulator: core: Fix c_rdev reference leak in regulator_resolve_coupling()

Shengming Hu <hu.shengming@zte.com.cn>
    cpufreq: conservative: Restrict deferred downscaling to low load

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

Shengzhuo Wei <me@cherr.cc>
    power: supply: bq27xxx: synchronize work cancellation on suspend

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: notify battery overvoltage recovery

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: fix float voltage selector

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: test battery health status bits

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: include base when petting watchdog

Karl Mehltretter <kmehltretter@gmail.com>
    ACPI: pfr_update: zero-initialize capability query result

Runyu Xiao <runyu.xiao@seu.edu.cn>
    dmaengine: altera-msgdma: initialize state before requesting IRQ

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Restore mandatory samsung DP DT properties

Fan Wu <fanwu01@zju.edu.cn>
    media: nuvoton: npcm-video: quiesce VCD IRQ before teardown

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: stv0900: bound DiSEqC reply length to msg[] size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: stv090x: bound DiSEqC reply length to msg[] size

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: adv7604: avoid negative array index in log_status when cp_read fails

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: reject ECC maximization on small pages

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

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: rtw89: cap firmware section_num before parsing

Yi Cong <yicong@kylinos.cn>
    wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields

イムティヤズ <reza1234khan1234@gmail.com>
    wifi: rtw88: fix out-of-bounds CAM write when key table is full

Justin Chen <justin.chen@broadcom.com>
    memory: brcmstb_dpfe: Bounds check DCPU-supplied MSG_ARG_COUNT

Justin Chen <justin.chen@broadcom.com>
    memory: brcmstb_dpfe: Fix out-of-bounds access due to DCPU offset

Sam Price <thesamprice@gmail.com>
    microblaze: preserve the MSR carry flags across signals

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: don't clobber r3/r4 restored by rt_sigreturn

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: reserve the ABI argument-home area in the signal frame

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

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/svm: drain fault handler before freeing svmm

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau: reject zero-size notifier object allocation

Sean Young <sean@mess.org>
    media: rc: Fix race between bpf(BPG_PROG_ATTACH) and device unregister

Fan Wu <fanwu01@zju.edu.cn>
    scsi: dc395x: sync the waiting_timer before freeing the host

Fan Wu <fanwu01@zju.edu.cn>
    media: s5p-mfc: use timer_shutdown_sync() for the self-rearming watchdog

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix swap entry value to folio_pfn()

Fan Wu <fanwu01@zju.edu.cn>
    ASoC: amd: ps: fix snd_acp63_remove() teardown ordering

Yibo Tan <lhfff@tju.edu.cn>
    media: ipu-bridge: Fix use-after-free in IVSC error path

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF

Marco Crivellari <marco.crivellari@suse.com>
    nvmet: replace use of system_wq with system_percpu_wq

Weiming Shi <bestswngs@gmail.com>
    virtio_net: atomically disable rx mode work

Ruide Cao <caoruide123@gmail.com>
    mptcp: hold MP_JOIN msk ref when cloning reqsk

Zhao Li <enderaoelyther@gmail.com>
    wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement

Tianchu Chen <flynnnchen@tencent.com>
    staging: rtl8723bs: fix protected RX frame validation in decrypt path

Khasar Munkh-Erdene <02khasar@gmail.com>
    staging: rtl8723bs: fix spacing around operators in rtw_recv.c

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Gracefully handle xarray errors when binding a memslot

Josef Bacik <josef@toxicpanda.com>
    mm/hugetlb: fix use-after-free of a new anon folio

Oscar Salvador <osalvador@suse.de>
    mm,hugetlb: sort out folio locking in the faulting path

Oscar Salvador <osalvador@suse.de>
    mm,hugetlb: change mechanism to detect a COW on private mapping

Peter Xu <peterx@redhat.com>
    mm/hugetlb: rename avoid_reserve to cow_from_owner

Peter Xu <peterx@redhat.com>
    mm/hugetlb: stop using avoid_reserve flag in fork()

Nirmoy Das <nirmoyd@nvidia.com>
    iommufd: Fix event queue release use-after-free

Honglei Huang <honghuan@amd.com>
    drm/amdgpu: drop retry loop in amdgpu_hmm_range_get_pages

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: fix buffer length underflow in RDMA transfers

Chris Mason <mason@kernel.org>
    ovl: do not copy up a dentry that was removed

Chris Mason <mason@kernel.org>
    ovl: hold a reference on the parent in readdir

Chris Mason <mason@kernel.org>
    ovl: check that the parents of volatile/dirty are dirs

Hyunwoo Kim <imv4bel@gmail.com>
    inet: reject unhashed sockets during established lookups

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: Use pr_warn() for early W^X warnings

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Formally define KVM's "0xdead" exit reason used for failed VM-Enter

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: fix named stream write and EOF handling

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: use the existing xattr name for a named stream

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix invalid pointer dereference when get_inode_acl() fails

Ian Bridges <icb@fastmail.org>
    ksmbd: fix session reference leak on compounded SESSION_SETUP

Mario Peter <mario.peter@leica-geosystems.com>
    driver core: take parent lock in async device attach

Vincent Liu <vincent.liu@nutanix.com>
    driver core: Check drivers_autoprobe for all added devices

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: VMX: Preserve negative return value in vmx_handle_exit() with bus lock detected

Ian Bridges <icb@fastmail.org>
    ksmbd: fix use-after-free after a failed durable reconnect

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: verify transform SessionId matches the decrypted header

Ian Bridges <icb@fastmail.org>
    ksmbd: fix out-of-bounds read when padding the final compound response

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent share root removal through empty paths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent stale data from being written by SMB2 WRITE requests

Aamir Ahmed <elb12345@hotmail.co.uk>
    ksmbd: deny access for an empty DACL instead of granting the request

Zikang Gao <2715417602@qq.com>
    smb: client: do not pass a NULL buf to is_oplock_break()

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: fix early procfs exposure race

Zi Yan <ziy@nvidia.com>
    mm/rmap: don't discard lazyfree THPs at PMD level

David Woodhouse <dwmw@amazon.co.uk>
    tun: Require CAP_NET_ADMIN to attach to an ownerless device

Peter Griffin <peter.griffin@linaro.org>
    opp: fix use after free in _update_opp_table_clk()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: always lower timeout for non-closing RST packets

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/powerplay: Align get_tonga_state_array() header with prototype

Sean Young <sean@mess.org>
    media: rc: Fix build failure with CONFIG_LIRC disabled

Cheng Yongkang <teel4res@gmail.com>
    io_uring/timeout: count cancelled timeouts in cq_timeouts

Chris Mason <mason@kernel.org>
    io_uring/sqpoll: don't wait for the thread to exit

Chris Mason <mason@kernel.org>
    io_uring: free XArray nodes left by a failed store

Chris Mason <mason@kernel.org>
    io_uring: charge tctx nodes and personalities

Chris Mason <mason@kernel.org>
    io_uring/rsrc: charge buffer arrays and nodes to memcg

Josef Bacik <josef@toxicpanda.com>
    io_uring/io-wq: no new workers once the exit has begun

Daan De Meyer <daan@amutable.com>
    io_uring/net: don't retry a non-blocking connect() that fails with -EAGAIN

Yichong Chen <chenyichong@uniontech.com>
    io_uring/net: keep recvmsg buffer select length within MAX_RW_COUNT

Yichong Chen <chenyichong@uniontech.com>
    io_uring/kbuf: advance head when a pickup empties the buffer ring

Chris Mason <mason@kernel.org>
    ovl: set OVL_WHITEOUTS before publishing the upper dir

Jiale Yao <yaojiale02@163.com>
    HID: roccat: savu: reject short special reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: ryos: reject short special reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: pyra: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: kovaplus: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: konepure: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: koneplus: reject short button reports

Jiale Yao <yaojiale02@163.com>
    HID: roccat: isku: reject short button reports

Gabor Tanz <gabor.tanz@gmail.com>
    HID: quirks: Always poll the Anne Pro 2 with product ID a292

Jiale Yao <yaojiale02@163.com>
    HID: pxrc: reject short input reports

Jiale Yao <yaojiale02@163.com>
    HID: prodikeys: validate fixed-format MIDI reports

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    HID: picoLCD: check for fb_deferred_io_init() error

Jiale Yao <yaojiale02@163.com>
    HID: mcp2221: validate response report length

Jiale Yao <yaojiale02@163.com>
    HID: mcp2200: validate READ_ALL response length

Jiale Yao <yaojiale02@163.com>
    HID: logitech-dj: validate unnumbered keyboard reports

Jiale Yao <yaojiale02@163.com>
    HID: elo: reject short touchscreen reports

Jiale Yao <yaojiale02@163.com>
    HID: cp2112: validate response report lengths

Jiale Yao <yaojiale02@163.com>
    HID: cougar: reject short special-key reports

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Fix out-of-bounds left shift by 32 in s32ton()

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Use report type from request node

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Remove unsupported motion-state field from accelerometer report

Jiale Yao <yaojiale02@163.com>
    HID: zydacron: validate key report length

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Fix get_d_signext() 12-bit displacement for paired-single D-form

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add preempt_disable() around virtual-mode HPTE bit-lock users

Sean Christopherson <seanjc@google.com>
    KVM: x86: Zero reserved synic flags when delivering message to avoid stack leak

Chengfeng Ye <nicoyip.dev@gmail.com>
    KVM: x86: Take SRCU in kvm_zap_gfn_range()

Loc Nguyen <loc@ryzome.com>
    KVM: x86: Request event processing for exception VM-Exits

Sean Christopherson <seanjc@google.com>
    KVM: x86: Preserve DR6.BLD (Bus Lock Detect) when delivering #DB payload

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Take kvm->srcu in __kvm_xen_has_interrupt()

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Enforce 4-byte alignment of vcpu_info registration

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if KVM calcs a CPU role with EFER.LMA=1 && CR4.PAE=0

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has

Sean Christopherson <seanjc@google.com>
    KVM: Use goto to handle errors during memslot preparation

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore EFER.LMA if EFER.LME=0 when preparing L2 state

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Trigger new ASID allocation in both VMCBs on pCPU switch

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()

David Howells <dhowells@redhat.com>
    rxrpc: Fix return in rxrpc_recvmsg_data() for service calls

David Howells <dhowells@redhat.com>
    rxrpc: Fix double IRQ enablement

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Treat every TLS error alert as fatal

Ameer Hamza <ameer.hamza@truenas.com>
    sunrpc: treat empty auth.unix.gid replies as negative entries

Zhiling Zou <zhilinz@nebusec.ai>
    SUNRPC: trace an accepted transport before publishing it

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Resume receiving after a TLS control record

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject a TLS alert record that is not two octets

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject a socket that already has an svc_sock attached

Chris Mason <clm@meta.com>
    sunrpc: pin gss module across auth_domain RCU free

Jeff Layton <jlayton@kernel.org>
    SUNRPC: keep the first error in svc_register()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    SUNRPC: fix oversized GSS proxy token copy

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Do not credit control-record octets to the RPC stream

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Copy the deferred RPC Call from the head buffer

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: zero NFSv4 COMPOUND tag padding

Jeff Layton <jlayton@kernel.org>
    NFSD: validate transport name in listener_set before serv creation

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Set nn->cld_net before registering the cld pipe

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Return NFSERR_ISDIR for NFSv2 READ and WRITE on a non-regular file

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Resolve the recall-any mask names in the trace format

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reject an oversized principal hash from nfsdcld

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: propagate SETXATTR value decode errors

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nfsd: preflight SEQUENCE replies before accepting a slot

Chuck Lever <chuck.lever@oracle.com>
    NFSD: map fh_verify() status codes for NFS_ACLv3 replies

NeilBrown <neil@brown.name>
    nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    nfsd: hold cl_lock in client_has_openowners()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix out-of-bounds read in the rpc_status dump

Wentao Liang <vulab@iscas.ac.cn>
    nfsd: Fix id-to-name cache entry leak in idtoname_parse()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fail a pool_threads read whose reply does not fit

Ameer Hamza <ameer.hamza@truenas.com>
    nfsd: don't modify a session slot when replaying its cached reply

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Don't complete a cld upcall the daemon has not read

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Do not send CB_RECALL_ANY to NFSv4.0 clients

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    NFSD: copy SETXATTR data from all XDR buffer segments

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfsd: clear XDR padding in GETXATTR replies

Jeff Layton <jlayton@kernel.org>
    NFSD: cap the number of listeners accepted in listener_set

Benjamin Coddington <bcodding@hammerspace.com>
    NFSv4/flexfiles: fail I/O to the data server once a lock is lost

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/filelayout: Anchor page coalescing on pattern_offset

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET

Chuck Lever <chuck.lever@oracle.com>
    pnfs/blocklayout: Complete a device upcall when the pipe is closed

Chuck Lever <chuck.lever@oracle.com>
    pnfs/blocklayout: Complete a device upcall only on its own reply

Benjamin Coddington <ben.coddington@hammerspace.com>
    pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate NT transaction response layout and offsets

Dominik Maier <dmnk@google.com>
    smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: fix fiemap wild read on empty truncated response

Luxiao Xu <rakukuip@gmail.com>
    smb: client: fix buffer overflow in SMB2_tcon()

Paulo Alcantara <pc@manguebit.org>
    smb: client: don't resurrect an exiting tcon from cached dir workers

VeroFess <coderzeng@hotmail.com>
    smb: server: size directory name conversion buffer correctly

Darrick J. Wong <djwong@kernel.org>
    xfs: range-check bc_levels array access in scrub tracepoints

Darrick J. Wong <djwong@kernel.org>
    xfs: propagate errors while checking null siblings

Darrick J. Wong <djwong@kernel.org>
    xfs: opportunistically skip btree block checks

Darrick J. Wong <djwong@kernel.org>
    xfs: only written file data blocks can be shared

Darrick J. Wong <djwong@kernel.org>
    xfs: never reset the default quota timer

Darrick J. Wong <djwong@kernel.org>
    xfs: fix data fork block count check in xrep_inode_blockcounts

Darrick J. Wong <djwong@kernel.org>
    xfs: fix correction of unwritten extents in quota file data fork

Darrick J. Wong <djwong@kernel.org>
    xfs: don't subtract excess usage twice when computing agf_btreeblks

Darrick J. Wong <djwong@kernel.org>
    xfs: don't rescan ifree and icount when frozen

Darrick J. Wong <djwong@kernel.org>
    xfs: don't overrun incore inode when cleaning attr forks

Darrick J. Wong <djwong@kernel.org>
    xfs: don't clear COWEXTSIZE on directories on reflink filesystems

Darrick J. Wong <djwong@kernel.org>
    xfs: clear set[ug]id mode bits when zapping attr fork

Darrick J. Wong <djwong@kernel.org>
    xfs: clarify various parts of the bitmap API

Darrick J. Wong <djwong@kernel.org>
    xfs: check for termination during rmap btree walk

Darrick J. Wong <djwong@kernel.org>
    xfs: check for fragments when full-extent sharing matches

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: bound inode fork length against the fork size during log recovery

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: bound da-node entry count against the correct geometry

Darrick J. Wong <djwong@kernel.org>
    xfs: always zero the whole shortform header when zeroing attr fork

Darrick J. Wong <djwong@kernel.org>
    xfs: always report scrub errors in tracepoints

Darrick J. Wong <djwong@kernel.org>
    xfs: always report inode repair setup failures

Darrick J. Wong <djwong@kernel.org>
    xfs: always forget cached ACLs if the attr fork swap succeeds

Darrick J. Wong <djwong@kernel.org>
    xfs: abort directory tree repair whenever dl->aborted is set

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: reject remote xattr entries with an out-of-range value length

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value

Darrick J. Wong <djwong@kernel.org>
    xfs: reject absurdly large xattr value lengths in xchk_xattr_actor

Aleksandr Nogikh <nogikh@google.com>
    media: usbtv: fix null-pointer dereference on disconnect

Johan Hovold <johan@kernel.org>
    media: usbtv: drop redundant device reference

Al Viro <viro@zeniv.linux.org.uk>
    ufs: fix ufs_read_cylinder() failure handling

Jean Delvare <jdelvare@suse.de>
    EDAC/mc: Really fix error path ordering in edac_mc_alloc()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ksmbd: fix breaking_cnt leak on early return in oplock_break()

Yongjun Gwon <d3bugee@gmail.com>
    ksmbd: serialize directory emptiness checks with readdir

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use the right limit for PCM OOB check

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null

Darrick J. Wong <djwong@kernel.org>
    xfs: adjust checks for cross-AG reaping issues

Darrick J. Wong <djwong@kernel.org>
    xfs: jump out of xchk_bmap_check_rmap if fatal signals

Darrick J. Wong <djwong@kernel.org>
    xfs: mark overfull dabtree node blocks as corrupt

Darrick J. Wong <djwong@kernel.org>
    xfs: check fork type against dabtree block magic number

Darrick J. Wong <djwong@kernel.org>
    xfs: abort dirtree repair if the live update hook dies

Darrick J. Wong <djwong@kernel.org>
    xfs: fix revalidation of xchk_dquot_iter cached mappings

Darrick J. Wong <djwong@kernel.org>
    xfs: bail out of directory tree repairs on error

Darrick J. Wong <djwong@kernel.org>
    xfs: assign an owner to scrub_stats_fops

Darrick J. Wong <djwong@kernel.org>
    xfs: allow softlimit with no hardlimit in quota scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: fix lost errno returned from xfarray_foliosort

Darrick J. Wong <djwong@kernel.org>
    xfs: don't repair fs summary counters with garbage

Darrick J. Wong <djwong@kernel.org>
    xfs: fix skipped inode mask handling in iscan

Darrick J. Wong <djwong@kernel.org>
    xfs: don't proceed with xattr repair if the live update fails

Darrick J. Wong <djwong@kernel.org>
    xfs: don't fix the directory tree if live update fails

Darrick J. Wong <djwong@kernel.org>
    xfs: don't pass iget failures up when marking ondisk inodes

Darrick J. Wong <djwong@kernel.org>
    xfs: always reset incore attr fork buffer when resetting fork

Darrick J. Wong <djwong@kernel.org>
    xfs: fix inode btree repair when a cluster is larger than a chunk

Darrick J. Wong <djwong@kernel.org>
    xfs: actually report corrupt xattrs as XFAIL during cross-referencing

Darrick J. Wong <djwong@kernel.org>
    xfs: fix buffer overflow in corrupt inline attr structure

Darrick J. Wong <djwong@kernel.org>
    xfs: fix unnecessary dapos truncation in xchk_dir_walk

Darrick J. Wong <djwong@kernel.org>
    xfs: online quotacheck must dirty dquot if enforcement adjustments needed

Darrick J. Wong <djwong@kernel.org>
    xfs: fix buffer overruns in xfs_ioc_attr_list

Darrick J. Wong <djwong@kernel.org>
    xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xfs_rename_space_res for non-pptr filesystems

Darrick J. Wong <djwong@kernel.org>
    xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork

Darrick J. Wong <djwong@kernel.org>
    xfs: compute the correct fdblocks/frextents for repair when they're negative

Darrick J. Wong <djwong@kernel.org>
    xfs: clear the symlink zapped flag if inline symlink is ok

Amir Goldstein <amir73il@gmail.com>
    ovl: skip copy up of empty security.capability

Chris Mason <mason@kernel.org>
    ovl: set the revalidate flags after d_instantiate()

Chris Mason <mason@kernel.org>
    ovl: read the nlink xattr of every indexed non-dir

Amir Goldstein <amir73il@gmail.com>
    ovl: fortify ovl_copy_xattr() against underlying layer modifications

Chris Mason <mason@kernel.org>
    ovl: fix a torn path in ovl_get_redirect()

Chris Mason <mason@kernel.org>
    ovl: do not copy up an xattr value that was never read

Chris Mason <mason@kernel.org>
    ovl: always encode the origin fh when index is enabled

Chris Mason <mason@kernel.org>
    ovl: use the pinned upper dir in ovl_fix_origin()

Chris Mason <mason@kernel.org>
    ovl: take a snapshot of the name for copy up

Weiming Shi <bestswngs@gmail.com>
    smb: client: stop processing a read response after a receive error

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB last_entry pointer from unbounded LastNameOffset

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: snapshot dentry names in file and setattr traces

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: pin refcount trees before dropping the lookup lock

Jiaming Zhang <r772577952@gmail.com>
    ocfs2: fix chunk number of the first chunk in a local quota file

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: cancel quota sync work before freeing quota info

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2/dlm: hold the lookup reference across convert AST enqueue

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: hold a lock reference across grant AST enqueue

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/heartbeat: unlink live slots when their node is missing

Sean Young <sean@mess.org>
    media: rc: Fix ABBA deadlock by making locks more fine grained

Sean Young <sean@mess.org>
    media: rc: Fix use after free in bpf progs

Sean Young <sean@mess.org>
    media: rc: After rc_unregister_device() timers can be re-armed

Sean Young <sean@mess.org>
    media: rc: Use after free in ir_raw_event_handle()

Sean Young <sean@mess.org>
    media: rc: mce_kbd: Fix inconsistent locking of keylock

Weigang He <geoffreyhe2@gmail.com>
    media: rc: fintek-cir: process a full RX buffer instead of overflowing it

Sean Young <sean@mess.org>
    media: rc: Ensure registered is cleared in error path

Sean Young <sean@mess.org>
    media: rc: Ensure that rc_unregister_device() does not free input device

Janne Grunau <j@jannau.net>
    nvmem: core: Fix OOB read for bit offsets of more than one byte

Myeonghun Pak <mhun512@gmail.com>
    power: supply: sbs-battery: disable polling before supply teardown

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    phy: core: Fix race-condition between _of_phy_get() and try_module_get()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    resource: report a devm_request_resource() conflict under the lock

YANXIN LI <fadouse@pm.me>
    ufs: use u64 for directory size in ufs_last_byte

Nguyen Quang Le Kien <khiemtranzo532001@gmail.com>
    usb: gadget: fix refcount underflow in gadgetfs_bind() error path

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: delete channel-context timers on deinit

Yuchao Zhang <ndaugoing@gmail.com>
    xen-blkfront: unbind irq before tearing down ring and shadow requests

Igor Putko <igorpetindev@gmail.com>
    serial: core: shut down initialized port on removal

Vernon Yang <yanglincheng@kylinos.cn>
    mm: khugepaged: fix folio is used after folio_put/unlock()

Imre Kaloz <kaloz@kernel.org>
    mm/slab: sample slab_state once in kmem_cache_destroy()

Rik van Riel <riel@surriel.com>
    media: redrat3: fix UAF in probe error path leaving rc device registered

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: take a reference on the parsed endpoints

Cong Nguyen <congnt264@gmail.com>
    media: microchip-csi2dc: fix async notifier leak on probe error path

Fan Wu <fanwu01@zju.edu.cn>
    media: marvell: mcam: stop DMA and cancel s_bh_work before freeing DMA buffers

Fan Wu <fanwu01@zju.edu.cn>
    media: imx-jpeg: cancel timeout worker when streaming stops

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: gspca: use vb2_video_unregister_device() on disconnect

Myeonghun Pak <mhun512@gmail.com>
    media: cx23885: unregister DVB bus when SP2 CI setup fails

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: Add SRCU protection for virtual-mode HPT hcalls

Kyle Zeng <kylebot@openai.com>
    io_uring/io-wq: save worker type before dropping its reference

Yousef Alhouseen <alhouseenyousef@gmail.com>
    HID: hiddev: keep state alive through disconnect unlock

Richard Patel <ripatel@wii.dev>
    genirq: Move interrupt thread exit_work object to irqaction

Richard Patel <ripatel@wii.dev>
    genirq: Defer kfree(irqaction) until irq_thread_dtor() finishes

Ngoc Quy <ngocquy0700@gmail.com>
    fs/proc/task_mmu: pin mm_users in do_pagemap_scan()

Xiang Mei <xmei5@asu.edu>
    fbdev: udlfb: don't rebuild the mode list while the framebuffer is in use

Yibo Tan <lhfff@tju.edu.cn>
    fbdev: atmel_lcdfb: Prevent FIFO work after removal

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: Fix TOCTOU race between GROUP_REGISTERED check and erase

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: hci_vhci: Pin module for debugfs file operations

Sung Byeongchan <tjdqudcks0424@naver.com>
    ALSA: pcmtest: handle multiple wraps in random capture fill

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect

Andreas Hindborg <a.hindborg@kernel.org>
    rust: block: fix `Send` bound for `GenDisk`

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.101.0

Karl Mehltretter <kmehltretter@gmail.com>
    klist: avoid accesses after waking klist_remove()

Ping Cheng <ping.cheng@wacom.com>
    HID: wacom: Write shared touch initial status only once

Ping Cheng <ping.cheng@wacom.com>
    HID: wacom: Setup SW_MUTE_DEVICE according to the order of input registration

Lee Jones <lee@kernel.org>
    HID: wacom: Redesign shared sibling data lifecycle

Lee Jones <lee@kernel.org>
    HID: wacom: Fix Use-After-Free in wacom_bamboo_pad

Lee Jones <lee@kernel.org>
    HID: wacom: Fix Use-After-Free in wacom_intuos_pad

Lee Jones <lee@kernel.org>
    HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration

Lee Jones <lee@kernel.org>
    HID: wacom: Use hdev->product in wacom_setup_touch_input_capabilities

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix out-of-bounds ptr advance in cca_query_crypto_facility()

Heiko Carstens <hca@linux.ibm.com>
    s390/signal: Fix incorrect return address in signal frame

Heiko Carstens <hca@linux.ibm.com>
    s390/probes: Fix wrong opcode for cgrb fixup

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/cpum_cf: Check session mask before cpu offline

Niklas Cassel <cassel@kernel.org>
    ata: sata_fsl: Fix use-after-free of host_priv on probe() failure

Binbin Deng <18983559317@163.com>
    apparmor: fix a use-after-free in aa_lookupn_ns()

David Hildenbrand (Arm) <david@kernel.org>
    mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()

Deepanshu Kartikey <kartikey406@gmail.com>
    media: imon: fix use-after-free in display_close via dev_dbg

Anuj Bolewar <bolewara@gmail.com>
    media: hackrf: fix use-after-free in hackrf_alloc_urbs() error path

Pei Xiao <xiaopei01@kylinos.cn>
    media: cx23885: Fix use-after-free in cx23885_finidev due to race condition

Fan Wu <fanwu01@zju.edu.cn>
    media: au0828: fix use-after-free in bulk_timeout timer on disconnect

Chuck Lever <chuck.lever@oracle.com>
    lockd: Fix use-after-free in nlmsvc_retry_blocked

Günther Noack <gnoack@google.com>
    landlock: Fix superblock use-after-free in release_inode()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvmet-fc: fix use-after-free in nvmet_fc_ls_create_connection()

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in mport_mm_close()

Henry Martin <bsdhenrymartin@gmail.com>
    smb: client: fix use-after-free in cifs_ses_add_channel()

Diego Oliva <diego@bynar.io>
    smb: client: fix use-after-free infoleak via the readdir resume name

Zijing Yin <yzjaurora@gmail.com>
    SUNRPC: fix netns use-after-free in write_gssp()

Andreas Wendleder <gonsolo@gmail.com>
    wifi: b43: fix use-after-free in b43_bcma_remove()

Li RongQing <lirongqing@baidu.com>
    x86/ioperm: Prevent NULL dereference on theoretical missing IO bitmap

Kevin Cheng <chengkev@google.com>
    KVM: VMX: Synthesize nested EPT violation GVA_IS_VALID/GVA_TRANSLATED bits

Sean Christopherson <seanjc@google.com>
    KVM: x86: Tell ->inject_page_fault() whether or a fault came from hardware

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: pass PFERR_GUEST_PAGE/FINAL_MASK to kvm_translate_gpa

Christoph Zwerschke <cito@online.de>
    Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"

Christoph Zwerschke <cito@online.de>
    Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"

Eric Dumazet <edumazet@kernel.org>
    vlan: restore HW VLAN tag insertion with reorder_hdr off

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Fix potential UAF in reqsk_timer_handler().

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate security descriptor offsets before pointer arithmetic

Karl Mehltretter <kmehltretter@gmail.com>
    ksmbd: use u8 for SMB2 oplock level values

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: return end of file for reads past a named stream's data

Abdifatah Suruur <suruurism@gmail.com>
    ksmbd: reserve space for the UTF-16 terminator in stream info

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: preserve unreadable named streams on open

Jan Koester <j.koester@act-marketing.de>
    ksmbd: ignore network devices of other namespaces

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    ksmbd: fix parent dentry lifetime in directory enumeration

Giorgi Kobakhia <gkobakhi@asu.edu>
    ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()

Dairui Zhang <zhangdairui@gmail.com>
    ksmbd: fix OOB read and cross-share confusion in ksmbd_validate_name_reconnect()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix extended session security negotiation for raw NTLMSSP

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: avoid restoring only in-memory EOF after allocation change

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: accept share config responses from ksmbd-tools before 3.5.3

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix WLED3 brightness register stride

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix unbalanced OVP IRQ enable at probe

David Heidelberg <david@ixit.cz>
    backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()

Myeonghun Pak <mhun512@gmail.com>
    backlight: lm3630a: Cancel delayed work before destroying workqueue

Kameron Carr <kameroncarr@linux.microsoft.com>
    Drivers: hv: vmbus: Bounds check the shared ring buffer indices

Johan Hovold <johan@kernel.org>
    driver core: fix parent lock use-after-free on USB disconnect

Josef Bacik <josef@toxicpanda.com>
    driver core: Limit the messages on a refused uevent

Johan Hovold <johan@kernel.org>
    driver core: take parent lock on deferred probe

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: do not consume the inner header on egress

Antonio Quartulli <antonio@mandelbit.com>
    net/sched: fix packet reordering on requeue

owen kwan <owen@verialabs.com>
    net/sched: sch_teql: fix use-after-free on lower qdisc drop

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_teql: fix slaves_lock IRQ deadlock

Yuhang Zheng <z1652074432@gmail.com>
    net/sched: cls_flower: avoid stale mask references after delete

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_bpf: accept dev-bound programs on shared blocks

Hari Mishal <harimishal1@gmail.com>
    drm/amd/display: guard dc_sink dereferences in MST mode validation

Jiakai Xu <xujiakai2025@iscas.ac.cn>
    RISC-V: KVM: Fix double-free of sdata in kvm_pmu_clear_snapshot_area()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix NULL dereference when copying keys for a field variable

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Bound histogram expression strings with seq_buf

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Return ERR_PTR() from expr_str()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing: Use __free() for expr_str() buffer

Tom Zanussi <zanussi@kernel.org>
    tracing: Fix fully-qualified variable reference printing in histograms

Christian Brauner <brauner@kernel.org>
    ntfs3: free replaced mount options after a grace period

Christian Brauner <brauner@kernel.org>
    ipc: drop the mqueue mount with kern_unmount() on setup failure

Vlad Kulikov <vlad.kulikov.c@gmail.com>
    ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/dmc: Add sanity check for DMC load address

Bihaan Sen <stevewholikesthings@gmail.com>
    Input: xpad - add support for 8BitDo Pro 2 Wired Controller for Xbox

Weiming Shi <bestswngs@gmail.com>
    net: team: free skb when broadcast has no txable port

Alexey Charkov <alchark@flipper.net>
    regulator: of: fill in supply names in of_regulator_bulk_get_all()

Christian Brauner <brauner@kernel.org>
    namespace: never expire a locked mount

Theo Andersen Carton <andersen.theo@gmail.com>
    drm/amdgpu: skip the noirq suspend reset for a switcheroo-parked GPU

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc12: properly pass flush_type to gmc_v12_0_flush_vm_hub()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: remove gart_window_lock usage from gmc v12

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fast updates on DCE 6.x

Christian Brauner <brauner@kernel.org>
    namespace: check a recursive bind mount for mount namespace loops

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: validate the superblock on resume

Paulo Alcantara <pc@manguebit.org>
    smb: client: require stable pages for signed connections

Paulo Alcantara <pc@manguebit.org>
    smb: client: only require read lease for size-extending zero range

Paulo Alcantara <pc@manguebit.org>
    smb: client: drain and invalidate before server-side copy/clone

Paulo Alcantara <pc@manguebit.org>
    smb: client: flush dirty data before zeroing a range

Paulo Alcantara <pc@manguebit.org>
    smb: client: flush and commit data before querying allocated ranges

Paulo Alcantara <pc@manguebit.org>
    smb: client: discard post-EOF pagecache when extending a file via clone range

Paulo Alcantara <pc@manguebit.org>
    smb: client: clear post-EOF pagecache when extending a file via truncate

Yu-Hsiang Tseng <asas1asas200@gmail.com>
    ALSA: hda/realtek: Fix silent speaker on Higole F9B

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Update control fields on #VMEXIT if and only if VMRUN succeeded

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Preserve TLB control (i.e. pending TLB flush) on failed VMRUN

Hao Ge <hao.ge@linux.dev>
    netfs: Fix missing alloc tagging of direct mempool allocations

Christian Brauner <brauner@kernel.org>
    fs: don't silently unmount busy mounts

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: remove 'add_helper' dead code

Kendall Willis <k-willis@ti.com>
    serial: 8250_omap: fix wake irq cleared during suspend

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fill kvm_run exit fields in common get_nested_state_pages() error paths

Sean Christopherson <seanjc@google.com>
    KVM: x86: Re-pend GET_NESTED_STATE_PAGES if getting said pages fails

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Fix configuring TUs for a disconnected stream

Adarsh Das <adarshdas950@gmail.com>
    smb: client: delete compound mids on send failure before unlock

David Francis <David.Francis@amd.com>
    drm/amdkfd: Avoid integer underflow in EOP ring size calculation.

David Francis <David.Francis@amd.com>
    drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size

Darrick J. Wong <djwong@kernel.org>
    xfs: don't cross reference rmapbt with bitmaps if they're incomplete

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: rzv2h: Avoid division by zero

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    watchdog: rzv2h: Add support for configurable count clock source

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    watchdog: rzv2h: Obtain clock-divider and timeout values from OF match data

Zongmin Zhou <zhouzongmin@kylinos.cn>
    RISC-V: KVM: Fix sdata leak and stale snapshot_addr in snapshot_set_shmem

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Propagate interrupted G-stage faults

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix fattr leaking on wsl_to_fattr() failure

Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
    drm/msm: RCU-free the scheduler-containing ring and VM objects

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: fix gpu metrics energy accumulator for smu 13.0.0/13.0.7

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: skip gfx switch_power_profile during GPU reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: add workload profile pause helper

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Synchronize HID command and report handling

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file type corruption in posix_reparse_to_fattr()

Pali Rohár <pali@kernel.org>
    cifs: Rename struct reparse_posix_data to reparse_nfs_data_buffer and move to common/smb2pdu.h

Pali Rohár <pali@kernel.org>
    cifs: Remove struct reparse_posix_data from struct cifs_open_info_data

Pali Rohár <pali@kernel.org>
    cifs: Remove duplicate struct reparse_symlink_data and SYMLINK_FLAG_RELATIVE

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix WSL reparse point uid/gid override

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix uid/gid override in getattr with posix extensions

Théo Lebrun <theo.lebrun@bootlin.com>
    mips: select CONFIG_WEAK_REORDERING_BEYOND_LLSC from CONFIG_EYEQ

John Hubbard <jhubbard@nvidia.com>
    rust: allow `clippy::as_underscore` in the generated bindings

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix NULL pointer dereference when the 'R' flag is used

Ido Schimmel <idosch@nvidia.com>
    ipv6: udp: Create exceptions before socket matching

Ido Schimmel <idosch@nvidia.com>
    ipv6: Fix redirect exception creation for UDP/RAW sockets

Daehyeon Ko <4ncienth@gmail.com>
    vsock/vmci: validate packet source for connected sockets

Yunpeng Tian <shionthanatos@gmail.com>
    smb: client: reject SetEA requests that do not fit the request buffer

Janani Sunil <janani.sunil@analog.com>
    iio: adc: adi-axi-adc: Initialize state mutex

Guangshuo Li <lgs201920130244@gmail.com>
    i2c: qcom-cci: fix autosuspend cleanup

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    i2c: qcom-cci: Remove overcautious disable_irq() calls

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    i2c: qcom-cci: Do not check return value of cci_init()

Hui Su <sh_def@163.com>
    io_uring/waitid: honor task_work cancellation

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: bypass the reclaim and oom killer for dying tasks once oom_reaper is done

Breno Leitao <leitao@debian.org>
    mm/kmemleak: report RCU-tasks quiescent states during the scan

Breno Leitao <leitao@debian.org>
    mm/kmemleak: stop the task stack scan early when interrupted

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang X6SP45xU

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for TongFang X6xx45xU

Gary Guo <gary@garyguo.net>
    rust: cfi: disable function merging if CFI is enabled

Frank Sorenson <sorenson@redhat.com>
    cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: Disable runtime PM for externally attached dGPUs

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Expand module virtual address space to 2GB

fangqiurong <fangqiurong@kylinos.cn>
    sched_ext: Fix exit_task leak on fork failure during enable

Denis Batishchev <ii343hbka@gmail.com>
    ALSA: hda/realtek: Enable micmute LED on HP EliteBook 6 G1a p/n: AD3Q9ET#UUG

Jeff Layton <jlayton@kernel.org>
    nfsd: use test_and_clear_bit for somebody_reclaimed to prevent lost update

Thomas Gleixner <tglx@kernel.org>
    futex: Sanitize and document task_struct::futex::state transitions

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Deliver interrupt after IN_GUEST_MODE is set

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Check kvm_request_pending() in kvm_late_check_requests()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Skip PMU checking on vCPU context switch

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix potential UAF in i3c_device_uevent()

Guopeng Zhang <zhangguopeng@kylinos.cn>
    mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings

Keren Sun <kerensun@google.com>
    mm: remove unnecessary whitespace before a quoted newline

Thiébaud Weksteen <tweek@google.com>
    module: validate string table section types

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_cache_index_str

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_cache_index_sym

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_cache_index_mod

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_cache_index_info

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_cache_secstrings

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_cache_sechdrs

Matthew Maurer <mmaurer@google.com>
    module: Factor out elf_validity_ehdr

Stanislaw Gruszka <stf_xl@wp.pl>
    module/kallsyms: fix nextval for data symbol lookup

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    module: Use RCU in find_kallsyms_symbol().

Jose Villaseñor Montfort <pepemontfort@gmail.com>
    HID: input: read battery capacity from its actual report offset

Dev Jain <dev.jain@arm.com>
    mm/migrate: use huge_ptep_get() in remove_migration_pte()

Dev Jain <dev.jain@arm.com>
    mm/rmap: use huge_ptep_get() in try_to_migrate_one()

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Fix msg_port restoration in amd_stb_debugfs_open_v2()

Lukas Wunner <lukas@wunner.de>
    PCI/AER: Emit TLP Log only for unmasked errors

Lukas Wunner <lukas@wunner.de>
    PCI/AER: Fix mapping of errors to agent & layer

Yosry Ahmed <yosry@kernel.org>
    KVM: x86: Always initialize EFER reserved bits on vendor initialization

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Resume device before setting EOS flag

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Set inst->std during default format initialization

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Use split "zap all fast" helpers when invalidating memslot

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Mark vCPU RUNNABLE after AP_CREATE, even if VMSA is unusable

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Extract loading of guest-provided VMSA to a separate helper

Julian Haarmann <julian.haarmann@student.kit.edu>
    platform/x86: lenovo/ymc: Only match lower byte in WMI lid switch query response

Matthew Auld <matthew.auld@intel.com>
    drm/xe/display: skip FORCE_WC and vm_bound check for external dma-bufs

Qing Luo <luoqing@kylinos.cn>
    sctp: auth: discard auth_chunk when skb_clone fails

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: add and use nf_ct_expect_related_pair()

Bui Viet Dung <dungvn2345@gmail.com>
    wwan: wwan_hwsim: Pin module for debugfs file operations

Giorgi Kobakhia <gkobakhi@asu.edu>
    udf: fix return value for non-recorded-allocated extents in udf_map_block()

Jonathan Gopel <jgopel@gmail.com>
    thunderbolt: Do not RPM complete unrelated subtrees on unplug

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: publish the filecheck owner before adding sysfs attributes

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: pin owning modules for open debugfs files

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: drain quorum work before removing the cluster

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: drain join handlers before releasing module text

Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
    net: usb: pegasus: do not advance rx_skb->data on dropped frames

Kaho Jiang <kj2864@nyu.edu>
    net: ipv4: add zero check for snd_cwnd_clamp

Xiang Mei <xmei5@asu.edu>
    media: go7007: only set audio_enabled if go7007_snd_init() succeeded

Xiang Mei <xmei5@asu.edu>
    media: em28xx: reject audio endpoint with zero packet size

Myeonghun Pak <mhun512@gmail.com>
    media: cx88: Disable PCI device on MPEG initialization failure

Xiang Mei <xmei5@asu.edu>
    libceph: bound mon_command ack decode to front len

Andrea Parri <parri.andrea@gmail.com>
    kcsan: Avoid division by zero in kcsan_prandom_u32_max()

Fang Xieyan <fangxy@xiaopeng.com>
    kcov: ignore an out-of-range comparison count in write_comp_data()

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    ceph: fail readdir when the MDS reply carries no dirfrag

Baokun Li <libaokun@linux.alibaba.com>
    blk-crypto: fix NULL deref and UAF in __blk_crypto_evict_key()

Rohinthan P <rokinthanp03@gmail.com>
    media: em28xx: use video_unregister_device for radio_dev

Christian Brauner <brauner@kernel.org>
    Revert "namei: don't reveal overmounted entries in refwalk"

Petr Mladek <pmladek@suse.com>
    nbcon/reboot: Switch NBCON consoles into the emergency mode in emergency_restart()

Michael Reeves <michael.reeves077@gmail.com>
    regmap: Remove debugfs before cache teardown

Matus Gajdos <matuszpd@gmail.com>
    ALSA: usb-audio: Add native DSD support for Cambridge Audio streamers

Jaidheer Sirigineedi <jaidheer7@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg3xxx (103c:8bfd)

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix status polling with octal DTR chips

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Rolling Wireless RN947R

Vladimir Murzin <vladimir.murzin@arm.com>
    usb: mtu3: Fix double dereference in TP_printk

renpanpan <renpanpan@kylinos.cn>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 14-dv1001TU

Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>
    ALSA: hda/realtek: Fix speakers on ASUS PM3406CHA

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45

Tarun Noonemunthala <ntarun2000@gmail.com>
    ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx

Luis Banha <luisbanha26@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Lenovo ThinkBook G8+

KIM MinWoo <phrimm136@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo ThinkBook 16p Gen 3 ARH (21EK)

Tomasz Bojanowski <tomasz@bojanowski.me>
    ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI

Hernan Ganzo <gp@sneemgp.com>
    ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)

Jasper Firth <jasper.m.f@hotmail.com>
    ASoC: Intel: bytcr_rt5651: Add quirk for Chuwi Hi8 with generic DMI strings

Daniel Ortiz <letargopausado@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP

Andy Moreton <andy.moreton@amd.com>
    sfc: add X4D PF support

Rosen Penev <rosenp@gmail.com>
    gpio: mvebu: keep resume masks within the irqchip cache

Seiji Adachi <seiji_adachi@yahoo.co.jp>
    ASoC: amd: yc: Add Lenovo ThinkPad E16 Gen 2 (21JN) to quirks

Ewan D. Milne <emilne@redhat.com>
    scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC Symmetrix

Dmitry Antipov <dmantipov@yandex.ru>
    HID: roccat: fix locking in roccat_connect() and roccat_disconnect()

Maurizio Lombardi <mlombard@redhat.com>
    nvme-fc: do not warn on controller removal race

Youth Cao <cocoh2os08@gmail.com>
    HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle allocated range queries on dense files

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix use-after-dereference of NULL ci in __ceph_remove_cap()

Mehmet Aysel <mehmet4ysel@gmail.com>
    ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI quirk

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/conexant: Always enable the headset-mic pin on plugin

Xiubo Li <xiubo.li@clyso.com>
    ceph: do not cache negative dentries for snapped directories

Mehmet Aysel <mehmet4ysel@gmail.com>
    ASoC: amd: acp3x-es83xx: Add HVY-WXX9/M1060 DMI quirk

Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
    ALSA: usb-audio: Skip mixer creation on M-Audio Venom

Li Jun <lijun01@kylinos.cn>
    tpm: tpm_tis_spi: fix nodef CR50 tpm_tis_spi_resume is null

Dave Carey <carvsdriver@gmail.com>
    HID: multitouch: Fix stale MT slots when contact count drops to zero

Vadim Klishko <vadim@cirque.corp-partner.google.com>
    HID: i2c-hid: Add a quirk for a Cirque I2C device.

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI entry for Alienware m18 R1 AMD

Jimmy Zuber <jamz@amazon.com>
    fuse: zero the partial EOF page when extending a file

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8

Md Rabbani <rabbanyhmm@gmail.com>
    net: stmmac: fix device node reference leaks in stmmac_mtl_setup()

Sumeet Pawnikar <sumeet4linux@gmail.com>
    powercap: intel_rapl: Fix kernel panic during PMU unbind

Helge Deller <deller@gmx.de>
    fbcon: Fix KASAN slab-out-of-bounds Read in fbcon_prepare_logo

Shiji Yang <yangshiji66@outlook.com>
    net: ethernet: mtk_wed: increase WED v2 WDMA RESV_BUFF to 0x80

Jenson Johnathon Reggentin <mail@jregg.de>
    docs: block: fix dead http link in blk-mq.rst

Chen Changcheng <chenchangcheng@kylinos.cn>
    scsi: snic: Fix SCSI host leak on workqueue allocation failure

Will Porter <mrwillporter@gmail.com>
    ALSA: usb-audio: Add iD14 MkI to monitor-mix volume quirk

Csaba Budai <ilyr73@gmail.com>
    ALSA: hda/realtek: Fix ALC700 audio on Intel Hades Canyon

Daeho Jeong <daehojeong@google.com>
    f2fs: avoid setting SBI_NEED_FSCK on transient resize failure

Robin Everaars <robineveraars@pm.me>
    ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch

Tao Cui <cuitao@kylinos.cn>
    sched_ext/scx_flatcg: expire cached hweights on weight changes

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: enable TCP keepalive for accepted connections

BingKun Yue <yuebingkun@kylinos.cn>
    fbdev: platinumfb: add error checking for ioremap calls

Randy Dunlap <rdunlap@infradead.org>
    fbdev: maxine: fix 64-bit build error

Carlos Song <carlos.song@nxp.com>
    i2c: imx-lpi2c: properly unwind resources on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()

Robert Leussler <robert.leussler@leica-geosystems.com>
    rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode

Jack Yu <jack.yu@realtek.com>
    ASoC: rt712-sdca: Pull high JD2 to prevent from entering TV mode

Jinqian Yang <yangjinqian1@huawei.com>
    virtio_ring: fix infinite loop in virtnet_poll_cleantx when device is broken

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()

Denis V. Lunev <den@openvz.org>
    virtio_balloon: warn on failed buffer add in tell_host()

Weimin Xiong <xiongwm2026@163.com>
    vdpa/mlx5: roll back MR update after VQ setup failure

Gilles Risch <gilles.risch@gmail.com>
    drm/radeon: fix internal display on iMac11, 1 (RV770/DCE3.1)

Xiong Weimin <xiongweimin@kylinos.cn>
    vdpa_sim: hold iommu_lock across dma_unmap passthrough transition

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: codec: max98926: fixup invert setup mask

Andrew Onyshchuk <andryk.rv@gmail.com>
    platform/x86: thinkpad_acpi: Fix fan speed reporting on Edge E330

Yaroslav Dudkov <aroslavdudkov622@gmail.com>
    platform/x86: msi-ec: Add MSI Katana GF76 11UEK EC firmware

Alex Elder <elder@riscstar.com>
    net: stmmac: use dma_addr_t for DMA addresses

Jia Zhu <zhujia.zj@bytedance.com>
    NFSv4: pin the superblock for active state owners

ZhangGuoDong <zhangguodong@kylinos.cn>
    NFS: Verify symlink inode before caching target

Thomas Huth <thuth@redhat.com>
    smb: server: Free session data in user_session.c with kfree_sensitive()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: notify parent directory leases on child create

Benjamin Coddington <ben.coddington@hammerspace.com>
    pNFS: honor clora_changed when recalling a layout

Thomas Huth <thuth@redhat.com>
    smb: server: Make sure that passkey is not leaked on the heap in user_config.c

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: honor client signing-required in all modes

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject blocking compound lock requests

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix SMB2 byte-range lock end offset

Yashraj Ghule <yashrajghule.221@gmail.com>
    ALSA: hda/realtek: Fix mute LED for HP Victus 15-fa1xxx (MB 8C3F)

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: cancel async requests when closing connection

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: report actual xattr value length in stream enumeration

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow FSCTL_SET_SPARSE without input buffer

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: honor byte-range locks for zero data

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle empty QUERY_ALLOCATED_RANGES output

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return buffer too small for short security queries

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject SMB3.1.1 binding with mismatched cipher

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix durable handle v2 default timeout units (60 -> 60000)

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow I/O on directory named streams

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: preserve access denied status for copychunk

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: protect private extended attributes

David C.C.M. Gall <david.ccm.gall@googlemail.com>
    crypto: keembay - use crypto_memneq() to compare CCM AEAD tags

Israel Téllez García <i.tellez@btesa.com>
    libbpf: Fix ring buffer consumer loop on 32-bit position wrap

David C.C.M. Gall <david.ccm.gall@googlemail.com>
    crypto: sa2ul - use crypto_memneq() to compare AEAD tag

David C.C.M. Gall <david.ccm.gall@googlemail.com>
    crypto: keembay - use crypto_memneq() to compare GCM AEAD tags

Eric Dumazet <edumazet@google.com>
    gre: fix ERSPAN o_flags race/corruption in xmit and fill_info

Yang Wen <anmuxixixi@gmail.com>
    exfat: keep FITRIM within the requested range

Anuj Bolewar <bolewara@gmail.com>
    drm/virtio: reclaim pending vbufs before tearing down vqs

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Serialize access to the shared emp2 pointer

Neil Andrews <neil@androos.io>
    ALSA: usb-audio: Rename the Audient iD14 monitor mix volume control

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/intel: Add sanity check for BAR0 size

Farhan Ali <alifm@linux.ibm.com>
    PCI: Avoid saving config space state if inaccessible

Michail Tatas <michail.tatas@gmail.com>
    ipmi: Fix leak in __ipmi_bmc_register

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo

Arash Golgol <arash.golgol@gmail.com>
    regulator: fan53555: Add support for FAN53555BUC23X type

Jiaming Zhang <r772577952@gmail.com>
    hfsplus: validate extent record length before writing it back

Dmytro Moroziuk <dmorozyk1@gmail.com>
    ALSA: hda/conexant: Add mute LED quirk for HP ProBook 440 G5

Matt Turner <mattst88@gmail.com>
    alpha: run the remote RTC access in a worker, not an IPI callback

Chao Shi <coshi036@gmail.com>
    nvme: ratelimit the completion-path messages driven by device data

Griffin Kroah-Hartman <griffin@kroah.com>
    nfc: nxp-nci: Add remove on IRQ error

Griffin Kroah-Hartman <griffin@kroah.com>
    nfc: mrvl: spi: Unregister dev on allocation fail

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix missing CMD_COMPLETE_PPR response for invalid PPR requests

Feng Tang <feng.tang@linux.alibaba.com>
    selftests: net: reuseport_bpf_numa: consider cpuless numa node

John Johansen <john.johansen@canonical.com>
    apparmor: fix auditing of mount binary data

Rongguang Wei <weirongguang@kylinos.cn>
    tap: fix incorrect variable used for USO check in set_offload()

Geliang Tang <geliang@kernel.org>
    nvme-tcp: look up host_iface in the current netns

Zhe Liu <liuzhe1@kylinos.cn>
    docs: cgroup-v2: fix stale "io" controller introduction

Brian Grech <bgrech@redhat.com>
    selftests/net: fin_ack_lat: fix latency threshold typo

Hari Mishal <harimishal1@gmail.com>
    nvmet: passthru: fix OOB reads when parsing ns id descriptor list

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86: Free hybrid state on PMU init failure

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86: Unregister PMI handler on PMU init failure

Michal Pecio <michal.pecio@gmail.com>
    ALSA: usx2y: Stop clearing urb->hcpriv before submission

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix CACHE_TAG_NESTING_DEVTLB polluting shared variables in flush loop

Pengpeng Hou <pengpeng@iscas.ac.cn>
    fbdev: udlfb: validate vendor descriptor items

Andreas Kemnade <andreas@kemnade.info>
    fbdev: omap2: dsi: do not copy isr table

Atish Patra <atishp@meta.com>
    RISC-V: perf: fix resource cleanup on driver probe failure

Rui Qi <qirui.001@bytedance.com>
    riscv: kprobes: Prevent probes in breakpoint handlers

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: check CORE_PLL_GROUP4 access in mt7531_setup()

Daniel Golle <daniel@makrotopia.org>
    net: pcs: mtk-lynxi: check regmap reads in mtk_pcs_lynxi_get_state()

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: check bus->read() error in core_rmw()

Laxman Acharya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed PHY_IAC command writes

Muhammad Saheed <muhammad.saheed.iam@gmail.com>
    Bluetooth: hci_sync: Disable legacy instance's ext adv before setup snapshot

Li Qiang <liqiang01@kylinos.cn>
    Bluetooth: hci_bcsp: validate received packet lengths

Chen Changcheng <chenchangcheng@kylinos.cn>
    Bluetooth: btrsi: Move set_bt_context after successful HCI registration

Garrett Blackmon <garrett@blackmon.dev>
    ALSA: hda/realtek: Fix speakers on ASUS ROG Zephyrus G14 GA403UM

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA

Junhao He <hejunhao3@h-partners.com>
    ACPI: APEI: Handle repeated SEA error storms

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add DCN6 register headers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory barrier order in reloc_root_is_dead()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: hci_nokia: validate firmware packet bounds

Pavel Zverev <playximik29@gmail.com>
    Bluetooth: btusb: Add support for 1357:c123 Realtek 8852BE device

Rui Qi <qirui.001@bytedance.com>
    selftests/ftrace: Force C locale in ftracetest

Andreas Haufler <andreas@haufler.info>
    tools/lib/thermal: Fix misplaced extern "C" closing brace

Yunye Zhao <yunye.zhao@linux.alibaba.com>
    md: add cond_resched() to md_do_sync()'s skip path

Yu Kuai <yukuai@fygo.io>
    md/raid5: reject zero-sector reshape chunks

Shang En Sim <sim@shangen.org>
    ALSA: hda/realtek: Enable mute LEDs on HP Spectre x360 16-aa0xxx

Junzhe Yu <junzheyu1@gmail.com>
    ext4: guard against NULL s_group_info in ext4_get_group_info

Pengpeng Hou <pengpeng@iscas.ac.cn>
    HID: rmi: check report length before trimming sentinel bytes

liulhong617 <liulhong617@gmail.com>
    arm64: mm: fix accidental linear mapping of no-map reserved memory

Stefan Hansson <newbyte@postmarketos.org>
    wifi: rsi: Fix types to appease CFI

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus Zenbook Duo

Praveen Talari <praveen.talari@oss.qualcomm.com>
    opp: Use clk_get_optional() to avoid leaving opp_table->clk as an error pointer

Carl Quist <equalizerjr@gmail.com>
    ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx

Zihan Xi <zihanx@nebusec.ai>
    xsk: account ring allocations to memcg

Jinhui Guo <guojinhui.liam@bytedance.com>
    net: usb: cdc_ether: add quirk for AMI BMC stale link events

Johan Alvarado <contact@c127.dev>
    net: stmmac: raise TX completion interrupt at the end of an xmit burst

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211

Marcos Paulo Medeiros <maarcospm1996@gmail.com>
    ACPI: video: force native backlight on Acer Nitro AN515-46

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Snapshot intrc before freeing the request block

Simon Glass <sjg@chromium.org>
    kconfig: abort rather than loop for ever on EOF

Allison Henderson <achender@kernel.org>
    net/rds: unpin MR pages with unpin_user_pages_dirty_lock()

Sharath Srinivasan <sharath.srinivasan@oracle.com>
    net/rds: fix rds_message leak in the rds_send_xmit() drop path

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: hold the socket while an rds_mr references it

Allison Henderson <achender@kernel.org>
    net/rds: don't use unpin_user_pages_dirty_lock() from atomic context

Wahid Khan <wahidzk0091@gmail.com>
    HID: intel-ish-hid: ignore post-init ENUM_DEVICES from firmware

Yuxiang Lin <mclyxfdw@gmail.com>
    HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle

Aaron Ma <mapengyu@gmail.com>
    HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle

Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
    HID: logitech-hidpp: Add support for G502 X Plus USB mouse

Mauricio Orozco <maudob@live.com>
    ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP

Mariano Baragiola <mbaragiola@linux.com>
    wifi: wilc1000: validate monitor transmit frame headers

Can Peng <pengcan@kylinos.cn>
    wifi: brcmfmac: validate msgbuf flowring IDs before use

Can Peng <pengcan@kylinos.cn>
    wifi: brcmfmac: Set DMA direction for msgbuf packet IDs

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: fix U-APSD service period termination

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: set the EOSP bit in the QoS header of the last released frame

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Power down DSP if it is left enabled in pre_fw_run()

ZhaoJinming <zhaojinming@uniontech.com>
    wifi: ath11k: fix resource leak on error in ext IRQ setup

Geetha sowjanya <gakula@marvell.com>
    perf: marvell: Cancel CN10K DDR PMU hrtimer on device remove

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: call skb_valid_dst() before skb_dst()

Minghao Zhang <zhangmh25@mails.tsinghua.edu.cn>
    netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets

Ahmed Naseef <naseefkm@gmail.com>
    wifi: mt76: mt7603: add 0x7592 EEPROM chip ID

Prashant Rahul <prashantrahul23@gmail.com>
    wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7915: configure noise floor reporting on reset

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt76x02: report rx FCS errors to mac80211

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7603: free beacon SKB on error

Hari Mishal <harimishal1@gmail.com>
    virtio_console: take a kref in find_port_by_vq() to fix port UAF

Rosen Penev <rosenp@gmail.com>
    nvmem: brcm_nvram: fix out-of-bounds access on malformed flash data

Rosen Penev <rosenp@gmail.com>
    nvmem: brcm_nvram: reject empty NVRAM partition

이상호 <kudo3228@gmail.com>
    romfs: detect hard link cycles

bui duc phuc <phucduc.bui@gmail.com>
    regulator: rt6245: Restore state on enable failure

Oleg Proshkin <oleg.pro171@gmail.com>
    mfd: axp20x: Preserve other control bits when powering off

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/realtek: add missing error checks for COEF index reads in alc269

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix memory leak in indx_find_sort()

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda/realtek: add missing NULL check for codec->bus->pci

Yichong Chen <chenyichong@uniontech.com>
    exfat: free new directory cluster if zeroing fails

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-smbios-wmi: Fix chardev resource management

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: hda/conexant: Add NULL check for dc_mode_path

Yichong Chen <chenyichong@uniontech.com>
    exfat: clean up new entry on add entry failure

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Add new PCI device-ids

Gary Guo <gary@garyguo.net>
    ata: ata_generic: Don't store pci_device_id

Dmitry Osipenko <digetx@gmail.com>
    clk: tegra: support 48MHz clock for pll_p_out1

Chen Changcheng <chenchangcheng@kylinos.cn>
    media: cx88: fix memory leak in cx8802_register_driver() error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Rate-limit the error ISR's log message

Yichong Chen <chenyichong@uniontech.com>
    exfat: write moved entry before removing source

Jay Vadayath <jay@artiphishell.com>
    udf: bound lengthAllocDescs from unallocated space entry

Jan Kara <jack@suse.cz>
    udf: Fix bh leak for unallocated space entries

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: free ibmvfc_target allocations with mempool_free

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvfc: check for NULL evt in implicit LOGO and target delete path

Jiaxing Hu <gahing@gahingwoo.com>
    iommu/rockchip: Clear stale page faults before enabling stall

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hsi: omap_ssi: remove debugfs on port creation failure

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: move GPIO IRQ setup into request_resources

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: fix debounce register selection

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: clear pending GPIO events during init

Tomer Maimon <tmaimon77@gmail.com>
    pinctrl: npcm8xx: enable RMII outputs from RMII groups

Pengpeng Hou <pengpeng@iscas.ac.cn>
    firmware: imx: scu: manage mailbox channels and global handle

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    platform/x86: int1092: Fix info leak in parse_package()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records

Senjin <senjin@hatchling.org>
    fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    ntfs3: fix info-leak in ntfs_rename()

Kyle Zeng <kylebot@openai.com>
    fs/ntfs3: reserve NUL byte when converting UTF-16 names

Brian Norris <briannorris@chromium.org>
    PCI/portdrv: Allow probing even without child services

Ruoyu Wang <ruoyuw560@gmail.com>
    ntfs3: initialize err in attr_wof_frame_info

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: ixp4xx: qmgr: add missing MODULE_DEVICE_TABLE()

Randolph Sapp <rs@ti.com>
    drm/etnaviv: force flush on power register ops

Rosen Penev <rosenp@gmail.com>
    ata: pata_ep93xx: fix PIO fallback when DMA init fails

Benjamin Marzinski <bmarzins@redhat.com>
    bitops: make the *_bit_le functions use unsigned long

Zhang Yi <yi.zhang@huawei.com>
    ext4: use FGP_WRITEBEGIN for tail block zeroing

Zhang Yi <yi.zhang@huawei.com>
    ext4: check return value of ext4_get_block() in ext4_load_tail_bh()

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    wifi: ath12k: fix scan command endianness on big endian

Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
    wifi: ath10k: trigger hardware recovery upon rx failures

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: ath11k: validate regulatory capability phy_id

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Publish pgtbl_ops before releasing init_mutex

Pengpeng Hou <pengpeng@iscas.ac.cn>
    thermal: intel: int340x: clean up RFIM groups on DVFS failure

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Enable clocks before hardware access in qcom_iommu_ctx_probe()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Check pm_runtime_resume_and_get() return in probe

Heiko Schocher <hs@nabladev.com>
    drm/panel: simple: Add Kyocera tcg070wvlq panel

Esteban Urrutia <esteuwu@proton.me>
    iommu/arm-smmu-qcom: Add SM8450 MDSS compatible

Baokun Li <libaokun@linux.alibaba.com>
    ext4: reject mount if clusters/inodes per group are not 8-aligned

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: cfg80211: include cf1 offset when sending chandef

Kuan-Wei Chiu <visitorckw@gmail.com>
    riscv, bpf: Add support for BPF_MOVSX in RV32 JIT

Pengpeng Hou <pengpeng@iscas.ac.cn>
    power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()

Yuyang Huang <yuyanghuang@google.com>
    net: prestera: ignore duplicate RIF destruction events

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: sfp: add quirk for HORACO copper SFP+ module

Pengpeng Hou <pengpeng@iscas.ac.cn>
    power: supply: cros_pchg: unregister EC notifier

Kuan-Wei Chiu <visitorckw@gmail.com>
    riscv, bpf: Add support for BPF_SDIV and BPF_SMOD in RV32 JIT

Thomas Renninger <trenn@suse.de>
    ACPI: sysfs: Properly map BERT and CCEL data to their ACPI tables

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211_hwsim: clear PMSR request state on abort

Shahar Tzarfati <shahar.tzarfati@intel.com>
    wifi: mac80211: ibss: read deauth reason_code after frame length check

Yun Zhou <yun.zhou@windriver.com>
    ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode

Ali Alaei <ali.alaei.tabatabaei@gmail.com>
    PCI: vmd: Handle BUS_RESTRICT_CFG value 3 for Arrow Lake-HX

Baokun Li <libaokun@linux.alibaba.com>
    ext4: reduce max cluster size to match documented 256MB limit

Kate Hsuan <hpa@redhat.com>
    ACPI: battery: Sanitise model_number by dropping unprintable characters

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ACPI: FPDT: validate table and record lengths

Bob Song <songxiebing@kylinos.cn>
    ALSA: hda: Check snd_hda_power_pm construct error before executing verb

Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
    platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3

Yousef Alhouseen <alhouseenyousef@gmail.com>
    media: go7007: s2250: propagate control I/O failures

Rituparna Warwatkar <rwarwatkar@gmail.com>
    media: dvb-core: fix feed leak on failed DMX_ADD_PID

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: ignore sync frames when sync is disabled

Aditya Sherawat <asherawa@qti.qualcomm.com>
    drm/msm/adreno: Add support for A704 GPU

Yuho Choi <dbgh9129@gmail.com>
    driver core: attribute_container: Unwind device_add() on attr failure

Logan Gunthorpe <logang@deltatee.com>
    PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk

Logan Gunthorpe <logang@deltatee.com>
    PCI: switchtec: Add Microchip PCI1008 device ID

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: ibmvmc: reject oversized inbound messages

Pei Xiao <xiaopei01@kylinos.cn>
    ipack: ipoctal: add rwsem to guard against TOCTOU in remove path

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: ibmvmc: release send buffer on write errors

Pengpeng Hou <pengpeng@iscas.ac.cn>
    greybus: manifest: validate string descriptor header

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: hpilo: validate device queue entries before use

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: genwqe: handle a first DMA address of zero

Yousef Alhouseen <alhouseenyousef@gmail.com>
    misc: bcm-vk: validate write size before allocation

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcmuio: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm816: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcmmio: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: aio_iiro_16: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm711: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: dt2811: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: das6402: Add sanity check to interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: quatech_daqp_cs: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcm818: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_at_a2150: Fix sanity check in interrupt handler

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_atmio16d: Add sanity check to interrupt handler

Pengpeng Hou <pengpeng@iscas.ac.cn>
    uio: sercos3: add missing MODULE_DEVICE_TABLE()

Michail Tatas <michail.tatas@gmail.com>
    USB: misc: uss720: Fix leak in get_1284_register

Oliver Neukum <oneukum@suse.com>
    usb: misc: cypress_cy7c63: check result of IO

Lucas Martins Alves <lucas.alves@lumal21.com.br>
    usb: musb: host: clear stale RX interrupt on three-strikes error

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec/core: drop cec_post_state_event call

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: cec: tegra_cec: don't break off msg on NACK

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    scsi: qla2xxx: Handle INTx not connected while passing through

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Wait for timeout worker completion on channel free

Namhyung Kim <namhyung@kernel.org>
    tools/lib/api: Fix potential double-free from fdarray__grow()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: cancel crash_handler work in rproc_add() error path

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: qcom: Check subdev start status in rproc_stop()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    media: go7007: avoid undefined shifts in MPEG-4 headers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cx18: stop VBI start-code scan before short tail

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: ivtv: stop VBI start-code scan before short tail

Jurison Murati <eng.juri@gmail.com>
    media: i2c: ov8865: Program the sensor on stream start

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: check all modules for idle after reset

Jurison Murati <eng.juri@gmail.com>
    media: i2c: ov8865: Drop the runtime PM usage count on stream failure

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    iwlwifi: dvm: add missing cleaup for on error path

Hari Mishal <harimishal1@gmail.com>
    nvme: bound ns descriptor header and body to identify buffer

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: intel_auxdevice: Add cs42l44 to wake_capable_list

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: dmi-quirks: add a global ghost list

Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
    drm/xe: only resume exec queues that were actually suspended

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: use vb2_video_unregister_device

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: requeue buffers if start_streaming fails

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: em28xx: dev_info->pr_info since dev has been freed

Mike Tipton <mike.tipton@oss.qualcomm.com>
    pmdomain: qcom: rpmhpd: Skip retention by default

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: vf610: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: keembay - add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: inode: fix mm lifetime handling

David Laight <david.laight.linux@gmail.com>
    usb_string_copy: Use kzalloc() to avoid leaking old data

Xu Rao <raoxu@uniontech.com>
    usb: gadget: u_audio: clean up capture endpoint on feedback failure

Haoxiang Li <haoxiang_li2024@163.com>
    usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()

Aniket Randive <aniket.randive@oss.qualcomm.com>
    serial: qcom_geni: Disable closing_wait for console to prevent shutdown timeout

Haoxiang Li <haoxiang_li2024@163.com>
    tty: serial: pch_uart: add check for pci_get_slot()

Rahul Bukte <rahul.bukte@sony.com>
    serial: 8250: force synchronous probe for the ISA and PNP drivers

Xu Rao <raoxu@uniontech.com>
    mmc: block: reject invalid perdev_minors before division

Arnd Bergmann <arnd@arndb.de>
    media: v4l2-tpg: reduce stack usage for kasan builds

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cec: tegra: add missing MODULE_DEVICE_TABLE()

Chris Lew <christopher.lew@oss.qualcomm.com>
    rpmsg: char: Check for ongoing chrdev destroy

Pranjal Shrivastava <praan@google.com>
    PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: codecs: max98396: Unwind supplies on resume failure

Qingtao Cao <qingtao.cao.au@gmail.com>
    bus: mhi: core: Fix sys error transition latency

John Garry <john.g.garry@oracle.com>
    nvme: don't reference NS after unlocking in nvme_ns_head_ctrl_ioctl()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: WARN() rather than BUG()

Deepanshu Kartikey <kartikey406@gmail.com>
    udf: avoid recursive s_alloc_mutex deadlock when freeing AED blocks

Kyle Zeng <kylebot@openai.com>
    udf: validate extent partition references in udf_current_aext()

Devansh Soni <devanshsoni874@gmail.com>
    staging: rtl8723bs: fix missing unregister_netdev on sdio_alloc_irq failure

Xixin Liu <liuxixin@kylinos.cn>
    nvme: zns: cap zone report nr_zones by DMA buffer size

Xixin Liu <liuxixin@kylinos.cn>
    nvme-auth: use crypto_memneq for DH-HMAC-CHAP response comparison

John Garry <john.g.garry@oracle.com>
    nvme: handle positive error codes in nuse_show()

Tanmay Shah <tanmay.shah@amd.com>
    remoteproc: core: Full attach detach during recovery

Jerome Brunet <jbrunet@baylibre.com>
    clk: sunxi-ng: fix ccu probe clock unregister on error

Marek Szyprowski <m.szyprowski@samsung.com>
    mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mmc: sdhci-of-ma35d1: add missing MODULE_DEVICE_TABLE()

Ben Dooks <ben.dooks@codethink.co.uk>
    mmc: cqhci: fix to missed endian conversions

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mmc: moxart: report DMA completion timeout

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: sifive: add missing MODULE_DEVICE_TABLE()

David Heidelberg <david@ixit.cz>
    dt-bindings: arm: qcom,ids: Add SoC ID for Snapdragon SDM 850

Zhiwei Zhang <202275009@qq.com>
    RDMA/rxe: Check PDs for memory window binds

David Heidelberg <david@ixit.cz>
    soc: qcom: socinfo: Add SoC ID for SDM850

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: max1241: add missing MODULE_DEVICE_TABLE()

Yun Zhou <yun.zhou@windriver.com>
    block: reject block device inodes with i_rdev == 0 in lookup_bdev()

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO

William Hansen-Baird <william.hansen.baird@gmail.com>
    wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode

William Hansen-Baird <william.hansen.baird@gmail.com>
    wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()

Ben Dooks <ben.dooks@codethink.co.uk>
    dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID

Yun Zhou <yun.zhou@windriver.com>
    net: mvneta_bm: add suspend/resume support to prevent crash after resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    dmaengine: pl330: remove debugfs file on teardown

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook

Jiayuan Chen <jiayuan.chen@linux.dev>
    netfilter: ebtables: bound num_counters like nentries in do_replace()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    net: usb: rtl8150: handle link status read failures

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Skip bpf_object__probe_loading() when BPF token is in use

Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>
    drm/panel-edp: Support MB116AS01'3 edp panel

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: add sanity check in svm_range_is_valid

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate legacy hwmgr PP table offsets

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Vega10 PPTable subtable bounds

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Tonga PPTable subtable bounds

Xiang Liu <xiang.liu@amd.com>
    drm/amd/pm: Guard VBIOS AC timing table walk

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Tonga PowerPlay state array bounds

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Use uploaded size for legacy custom PPTable

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate pp_table header before reading size

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Guard reads in pcie state readout

Matthew Jacob <mjacob@feralsw.com>
    drm/amdgpu: Support some Barco AMD based graphics adapters

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: validate vega10 profile mode inputs

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Validate ATIF buffer length before use

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add checks to vbios fetch through ATRM

Abhijeeth Babu <babu.jeeth@gmail.com>
    i2c: acpi: Force ELAN1300 touchpads to 100 kHz

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath12k: avoid setting 320MHz support on non 6GHz band

Jiawen Liu <1298662399@qq.com>
    spi: bcmbca-hsspi: return error from failed controller suspend

Jiawen Liu <1298662399@qq.com>
    spi: nxp-fspi: disable runtime PM on probe failures

Damon Ding <damon.ding@rock-chips.com>
    drm/panel-edp: Add BOE NE160QDM-NY1 panel

Jiawen Liu <1298662399@qq.com>
    spi: bcm63xx-hsspi: return error from failed controller suspend

Jiawen Liu <1298662399@qq.com>
    spi: bcm63xx: return error from failed controller suspend

Jiawen Liu <1298662399@qq.com>
    spi: bcm-qspi: return error from failed controller suspend

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix PCI PMU cleanup on setup failure

Zizhi Wo <wozizhi@huawei.com>
    fat: reject name longer than NAME_MAX in msdos_format_name()

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fallback to sw branch type decoding if no hw decoding

Bryam Vargas <hexlabsecurity@proton.me>
    iio: accel: fxls8962af: clamp the device-reported FIFO sample count

Mithil Bavishi <bavishimithil@gmail.com>
    ARM: OMAP2+: Add CFI type for omap4_finish_suspend

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    regmap: maple: Workaround for another false-positive compiler warning

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hdmi: Fix resource cleanup on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: tlv320aic26: remove keyclick sysfs file

William Theesfeld <william@theesfeld.net>
    clk: zynq: handle kasprintf() failure in periph_clk registration

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: sma1303: remove fault-check sysfs group on remove

Kemeng Shi <shikemeng@huaweicloud.com>
    irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cec: stm32: return an error when log-address wait times out

Kryštof Černý <cleverline1mc@gmail.com>
    w1: ds2482: add OF device match table

Pengpeng Hou <pengpeng@iscas.ac.cn>
    gpio: pca9570: Use I2C match data

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: add bounds check to prevent array overflow

Gangliang Xie <ganglxie@amd.com>
    drm/amdgpu: add buf length check

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/radeon: avoid double free in r600 DPM cleanup

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: fix max dispclk_khz/dppclk_khz double 1000

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: Gate debugfs MMIO access on kernel lockdown

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: Validate OD DPM triples before mutating tables

Jonas Karlman <jonas@kwiboo.se>
    drm/rockchip: dw_hdmi: Use resume_early pm ops for system suspend

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: line6: Clear prev_fbuf on capture buffer release

Yao Kai <yaokai34@huawei.com>
    ext4: validate readdir offset before accessing dirent

Zihan Xi <zihanx@nebusec.ai>
    net: gso: limit recursive IP-in-IP segmentation

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state

Christian Brauner <brauner@kernel.org>
    fork: don't create io threads once PF_POSTCOREDUMP is set

Christian Brauner <brauner@kernel.org>
    fork: move the coredump and exec checks into create_io_thread()

Christian Brauner <brauner@kernel.org>
    exec: cancel io_uring requests before de_thread()

André Draszik <andre.draszik@linaro.org>
    kbuild: link-vmlinux.sh: improve detection of third pass requirement

Ridham Khurana <khurana.ridham222@gmail.com>
    platform: cznic: turris-omnia-mcu: Add missing MODULE_DEVICE_TABLE()

Daniel Schaefer <dhs@frame.work>
    iio: hid-sensor: als: scale each channel individually

SJ Park <sj@kernel.org>
    mm/damon/sysfs: put target pids for apply_inputs() failure

SJ Park <sj@kernel.org>
    mm/damon/sysfs: put target pids for damon_start() failure

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU

SJ Park <sj@kernel.org>
    mm/damon/core: error damos_commit_quota_goal() for zero target_value

Sasha Levin <sashal@kernel.org>
    Revert "KVM: s390: move pv gmap functions into kvm"

Sasha Levin <sashal@kernel.org>
    Revert "KVM: s390: use __kvm_faultin_pfn()"

Sasha Levin <sashal@kernel.org>
    Revert "KVM: s390: move gmap_shadow_pgt_lookup() into kvm"

Sasha Levin <sashal@kernel.org>
    Revert "KVM: s390: pv: fix race when making a page secure"

Sasha Levin <sashal@kernel.org>
    Revert "KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion"

Sasha Levin <sashal@kernel.org>
    Revert "s390/uv: Don't return 0 from make_hva_secure() if the operation was not successful"

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Transfer the hyp stack pages out of the host stage-2

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: wait for negotiation before receiving another PDU

Zizhen Liu <pointerliu@126.com>
    net: skbuff: propagate shared-frag marker in skb_zerocopy()


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v2.rst            |    10 +-
 Documentation/block/blk-mq.rst                     |     2 +-
 .../bindings/clock/nuvoton,ma35d1-clk.yaml         |    16 +-
 Documentation/hwmon/k10temp.rst                    |     8 +-
 Documentation/networking/ip-sysctl.rst             |     5 +-
 Documentation/networking/rxrpc.rst                 |    13 +-
 Documentation/virt/hyperv/vmbus.rst                |    17 +-
 Makefile                                           |     7 +-
 arch/alpha/include/asm/mmu_context.h               |    35 +-
 arch/alpha/include/asm/sfp-machine.h               |     4 +
 arch/alpha/include/asm/switch_to.h                 |     1 -
 arch/alpha/include/asm/tlbflush.h                  |     3 +-
 arch/alpha/kernel/rtc.c                            |    37 +-
 arch/alpha/kernel/smp.c                            |    67 +-
 arch/alpha/mm/fault.c                              |    23 +-
 arch/alpha/mm/tlbflush.c                           |    18 +-
 arch/arm/include/asm/linkage.h                     |    29 +
 arch/arm/include/asm/smp.h                         |     2 +-
 arch/arm/kernel/head-nommu.S                       |     1 +
 arch/arm/kernel/head.S                             |     1 +
 arch/arm/kernel/smp.c                              |    15 +-
 arch/arm/mach-imx/pm-imx6.c                        |    26 +-
 arch/arm/mach-imx/suspend-imx6.S                   |     6 +-
 arch/arm/mach-omap2/sleep44xx.S                    |     5 +-
 arch/arm/mm/alignment.c                            |    51 +-
 .../boot/dts/freescale/imx8mp-verdin-yavia.dtsi    |     7 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |     1 +
 .../dts/qcom/sdm845-xiaomi-beryllium-common.dtsi   |     6 +
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts |     6 +
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |     2 +-
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi    |     2 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |     6 +-
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts     |     6 +-
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi   |     2 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |     5 +-
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi |     2 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |     2 +-
 arch/arm64/crypto/poly1305-armv8.pl                |     2 +-
 arch/arm64/include/asm/kvm_host.h                  |     7 +-
 arch/arm64/include/asm/pgtable.h                   |     3 +
 arch/arm64/kernel/efi.c                            |     8 +-
 arch/arm64/kvm/arm.c                               |    31 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |    10 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |    33 +-
 arch/arm64/mm/contpte.c                            |     4 +-
 arch/arm64/mm/mmu.c                                |    14 +
 arch/loongarch/include/asm/barrier.h               |     3 -
 arch/loongarch/include/asm/hw_breakpoint.h         |     4 +-
 arch/loongarch/include/asm/loongarch.h             |     4 +-
 arch/loongarch/include/asm/numa.h                  |     2 +-
 arch/loongarch/include/asm/pgtable.h               |     2 +-
 arch/loongarch/kernel/hw_breakpoint.c              |    27 +-
 arch/loongarch/kernel/irq.c                        |     3 +-
 arch/loongarch/kernel/traps.c                      |    13 +-
 arch/loongarch/kvm/vcpu.c                          |    38 +-
 arch/loongarch/mm/init.c                           |    17 +-
 arch/loongarch/pci/pci.c                           |     3 +-
 arch/microblaze/kernel/entry.S                     |    19 +-
 arch/microblaze/kernel/signal.c                    |    26 +
 arch/mips/Kconfig                                  |     1 +
 arch/mips/mm/tlb-r4k.c                             |    21 +-
 arch/powerpc/kvm/book3s_hv.c                       |    76 +-
 arch/powerpc/kvm/book3s_paired_singles.c           |     7 +-
 arch/powerpc/platforms/pseries/plpks.c             |    27 +-
 arch/powerpc/platforms/pseries/plpks_sed_ops.c     |    12 +-
 arch/riscv/include/asm/pgtable.h                   |     9 +-
 arch/riscv/kernel/traps.c                          |     3 +
 arch/riscv/kvm/mmu.c                               |     2 +
 arch/riscv/kvm/vcpu_exit.c                         |     2 +-
 arch/riscv/kvm/vcpu_pmu.c                          |     9 +
 arch/riscv/kvm/vcpu_sbi_replace.c                  |    12 +-
 arch/riscv/net/bpf_jit_comp32.c                    |    47 +-
 arch/s390/include/asm/gmap.h                       |     3 +-
 arch/s390/include/asm/uv.h                         |     6 +-
 arch/s390/kernel/perf_cpum_cf.c                    |     3 +
 arch/s390/kernel/process.c                         |    12 +-
 arch/s390/kernel/signal.c                          |     6 +-
 arch/s390/kernel/uv.c                              |   401 +-
 arch/s390/kvm/Makefile                             |     2 +-
 arch/s390/kvm/gaccess.c                            |    42 +-
 arch/s390/kvm/gmap.c                               |   121 -
 arch/s390/kvm/gmap.h                               |    19 -
 arch/s390/kvm/intercept.c                          |     3 +-
 arch/s390/kvm/kvm-s390.c                           |   156 +-
 arch/s390/kvm/kvm-s390.h                           |     6 -
 arch/s390/kvm/pv.c                                 |    21 -
 arch/s390/lib/probes.c                             |     2 +-
 arch/s390/mm/gmap.c                                |    45 +-
 arch/x86/events/core.c                             |    19 +-
 arch/x86/events/intel/lbr.c                        |     2 +-
 arch/x86/events/intel/uncore.c                     |     5 +-
 arch/x86/include/asm/kvm_host.h                    |    18 +-
 arch/x86/include/asm/vmx.h                         |     8 +
 arch/x86/kernel/process.c                          |     1 +
 arch/x86/kvm/hyperv.c                              |     5 +-
 arch/x86/kvm/mmu/mmu.c                             |    29 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    39 +-
 arch/x86/kvm/regs.c                                |     3 +-
 arch/x86/kvm/svm/nested.c                          |    15 +-
 arch/x86/kvm/svm/sev.c                             |    73 +-
 arch/x86/kvm/svm/svm.c                             |    35 +-
 arch/x86/kvm/svm/svm.h                             |     1 +
 arch/x86/kvm/vmx/nested.c                          |    41 +-
 arch/x86/kvm/vmx/vmx.c                             |     9 +-
 arch/x86/kvm/x86.c                                 |    82 +-
 arch/x86/kvm/xen.c                                 |    18 +
 arch/x86/mm/pat/set_memory.c                       |    23 +-
 block/bdev.c                                       |    12 +
 block/blk-crypto-fallback.c                        |     6 +
 block/blk-iocost.c                                 |     2 +
 block/blk-mq.c                                     |     2 +
 crypto/algif_skcipher.c                            |     8 +-
 drivers/accessibility/speakup/selection.c          |     6 +
 drivers/acpi/acpi_fpdt.c                           |    55 +-
 drivers/acpi/apei/ghes.c                           |    10 +-
 drivers/acpi/battery.c                             |    14 +
 drivers/acpi/button.c                              |    11 +
 drivers/acpi/pfr_update.c                          |     2 +-
 drivers/acpi/sysfs.c                               |     9 +-
 drivers/acpi/video_detect.c                        |     8 +
 drivers/ata/ahci_st.c                              |    78 +-
 drivers/ata/ata_generic.c                          |     6 +-
 drivers/ata/libahci.c                              |    28 +-
 drivers/ata/libahci_platform.c                     |     4 +
 drivers/ata/libata-core.c                          |    75 +-
 drivers/ata/libata-scsi.c                          |     5 +
 drivers/ata/libata-sff.c                           |     5 +
 drivers/ata/pata_ep93xx.c                          |    30 +-
 drivers/ata/sata_fsl.c                             |    26 +-
 drivers/ata/sata_qstor.c                           |     8 +-
 drivers/base/attribute_container.c                 |     7 +-
 drivers/base/base.h                                |     1 +
 drivers/base/bus.c                                 |    45 +-
 drivers/base/core.c                                |     4 +-
 drivers/base/dd.c                                  |    92 +-
 drivers/base/regmap/regcache-maple.c               |     2 +-
 drivers/base/regmap/regmap-debugfs.c               |     1 +
 drivers/base/regmap/regmap.c                       |    15 +-
 drivers/block/aoe/aoenet.c                         |    14 +-
 drivers/block/floppy.c                             |     8 +-
 drivers/block/loop.c                               |     6 +-
 drivers/block/xen-blkfront.c                       |    16 +-
 drivers/bluetooth/btrsi.c                          |     3 +-
 drivers/bluetooth/btusb.c                          |     8 +-
 drivers/bluetooth/hci_bcsp.c                       |     5 +-
 drivers/bluetooth/hci_nokia.c                      |    20 +
 drivers/bluetooth/hci_vhci.c                       |     4 +
 drivers/bus/mhi/host/pm.c                          |    14 +-
 drivers/char/hw_random/amd-rng.c                   |     2 +-
 drivers/char/hw_random/ba431-rng.c                 |     2 +-
 drivers/char/hw_random/core.c                      |     1 +
 drivers/char/ipmi/ipmi_msghandler.c                |     1 +
 drivers/char/tpm/tpm-dev-common.c                  |     3 +
 drivers/char/tpm/tpm_nsc.c                         |     8 +-
 drivers/char/tpm/tpm_tis_spi.h                     |     8 +-
 drivers/char/virtio_console.c                      |    13 +-
 drivers/clk/imx/clk-imx8qxp-lpcg.c                 |     1 +
 drivers/clk/imx/clk-imx8qxp.c                      |     1 +
 drivers/clk/imx/clk.c                              |    15 +-
 drivers/clk/mstar/clk-msc313-mpll.c                |     2 +-
 drivers/clk/mvebu/ap-cpu-clk.c                     |     4 +-
 drivers/clk/qcom/gcc-ipq5018.c                     |    10 +
 drivers/clk/qcom/gcc-ipq5332.c                     |     1 +
 drivers/clk/starfive/clk-starfive-jh7110-isp.c     |     2 +-
 drivers/clk/sunxi-ng/ccu_common.c                  |    12 +-
 drivers/clk/tegra/clk-pll.c                        |     1 +
 drivers/clk/zynq/clkc.c                            |     8 +
 drivers/clocksource/timer-digicolor.c              |     2 +
 drivers/clocksource/timer-fttmr010.c               |     2 +
 drivers/comedi/drivers/aio_iiro_16.c               |     3 +
 drivers/comedi/drivers/das6402.c                   |    10 +-
 drivers/comedi/drivers/dt2811.c                    |     7 +-
 drivers/comedi/drivers/ni_at_a2150.c               |    13 +-
 drivers/comedi/drivers/ni_atmio16d.c               |     3 +
 drivers/comedi/drivers/pcl711.c                    |     3 +-
 drivers/comedi/drivers/pcl816.c                    |     3 +-
 drivers/comedi/drivers/pcl818.c                    |     3 +-
 drivers/comedi/drivers/pcmmio.c                    |     3 +
 drivers/comedi/drivers/pcmuio.c                    |     5 +-
 drivers/comedi/drivers/quatech_daqp_cs.c           |     4 +-
 drivers/cpufreq/Kconfig                            |     1 +
 drivers/cpufreq/amd-pstate.c                       |     6 +-
 drivers/cpufreq/cpufreq_conservative.c             |     8 +-
 drivers/cpufreq/cpufreq_governor.c                 |    29 +-
 drivers/cpufreq/cpufreq_governor.h                 |     2 +
 drivers/cpufreq/cpufreq_stats.c                    |     4 +
 drivers/cpufreq/intel_pstate.c                     |     2 +
 drivers/cpufreq/loongson3_cpufreq.c                |    73 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |     7 +-
 drivers/crypto/atmel-aes.c                         |     2 +-
 drivers/crypto/atmel-tdes.c                        |     6 +-
 drivers/crypto/caam/caampkc.c                      |     6 +
 drivers/crypto/ccp/dbc.c                           |     4 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    20 +-
 .../crypto/intel/keembay/keembay-ocs-aes-core.c    |     3 +-
 drivers/crypto/intel/keembay/keembay-ocs-ecc.c     |     1 +
 drivers/crypto/intel/keembay/ocs-aes.c             |     3 +-
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c  |    10 +-
 .../crypto/intel/qat/qat_common/adf_gen4_vf_mig.c  |     5 +
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c   |     2 -
 drivers/crypto/nx/nx-842.c                         |     2 +
 drivers/crypto/sa2ul.c                             |     3 +-
 drivers/cxl/acpi.c                                 |    20 +-
 drivers/cxl/core/pci.c                             |    20 +-
 drivers/cxl/core/port.c                            |     3 +
 drivers/dax/super.c                                |     2 +-
 drivers/dma/altera-msgdma.c                        |    10 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |     2 +-
 drivers/dma/pl330.c                                |    19 +-
 drivers/edac/edac_mc.c                             |     6 +-
 drivers/edac/i10nm_base.c                          |     1 +
 drivers/firewire/ohci-serdes-test.c                |     4 +-
 drivers/firewire/ohci.h                            |     2 +-
 drivers/firmware/efi/libstub/efi-stub.c            |     8 +
 drivers/firmware/imx/imx-scu.c                     |    25 +-
 drivers/fpga/fpga-mgr.c                            |     2 +-
 drivers/gpio/gpio-davinci.c                        |     6 +-
 drivers/gpio/gpio-mvebu.c                          |    33 +-
 drivers/gpio/gpio-pca953x.c                        |    14 +-
 drivers/gpio/gpio-pca9570.c                        |     2 +-
 drivers/gpio/gpio-sifive.c                         |     1 +
 drivers/gpio/gpio-vf610.c                          |     1 +
 drivers/gpio/gpiolib.c                             |    12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    68 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c |     3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c   |     2 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |    10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |     7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    13 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |     9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |     5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |     7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |     3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |     5 +
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |    57 +-
 drivers/gpu/drm/amd/amdgpu/cik.c                   |    10 +
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c             |     4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |     2 +-
 drivers/gpu/drm/amd/amdgpu/vi.c                    |    10 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |    36 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |    35 +-
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c          |    23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |     6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |     7 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |     4 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |     4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |    23 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |    29 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    11 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |     2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |     3 +
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |     7 +
 .../gpu/drm/amd/display/dc/dml/dsc/rc_calc_fpu.c   |     2 +-
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |     8 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |     2 +
 .../drm/amd/display/modules/color/color_gamma.c    |     3 +-
 .../amd/include/asic_reg/dcn/dcn_6_0_0_offset.h    | 15799 +++++
 .../amd/include/asic_reg/dcn/dcn_6_0_0_sh_mask.h   | 58556 +++++++++++++++++++
 .../amd/include/asic_reg/dpcs/dpcs_6_0_0_offset.h  |    47 +
 .../amd/include/asic_reg/dpcs/dpcs_6_0_0_sh_mask.h |    55 +
 .../include/asic_reg/mmhub/mmhub_5_0_1_offset.h    |    17 +
 .../include/asic_reg/mmhub/mmhub_5_0_1_sh_mask.h   |    17 +
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |     1 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |    23 +-
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |     2 +
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |    21 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |    28 +-
 .../amd/pm/powerplay/hwmgr/process_pptables_v1_0.c |   673 +-
 .../drm/amd/pm/powerplay/hwmgr/processpptables.c   |   446 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |    36 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |    48 +-
 .../pm/powerplay/hwmgr/vega10_processpptables.c    |   623 +-
 .../pm/powerplay/hwmgr/vega12_processpptables.c    |     7 +
 .../pm/powerplay/hwmgr/vega20_processpptables.c    |     7 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |    19 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |     2 -
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |     4 +-
 drivers/gpu/drm/arm/malidp_crtc.c                  |     1 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |    13 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |    16 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h              |     6 +
 drivers/gpu/drm/i915/display/intel_dmc.c           |    55 +
 drivers/gpu/drm/i915/display/intel_dmc_regs.h      |    12 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |    21 +
 drivers/gpu/drm/i915/display/intel_dp_mst.h        |     2 +
 drivers/gpu/drm/i915/display/intel_link_bw.c       |     4 +-
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |     2 +-
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c             |     2 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |    16 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |     2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |     1 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |     4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |     1 +
 drivers/gpu/drm/nouveau/nouveau_dp.c               |     4 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |     2 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |    13 +
 drivers/gpu/drm/panel/panel-edp.c                  |     2 +
 drivers/gpu/drm/panel/panel-simple.c               |     3 +
 drivers/gpu/drm/panthor/panthor_sched.c            |    14 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |     5 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |    23 +-
 drivers/gpu/drm/radeon/r600_dpm.c                  |    21 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |     7 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    11 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |     1 +
 drivers/gpu/drm/virtio/virtgpu_kms.c               |     1 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |    15 +
 drivers/gpu/drm/xe/display/intel_fb_bo.c           |     3 +-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |     3 +-
 drivers/gpu/drm/xe/xe_exec_queue_types.h           |    12 +
 drivers/gpu/drm/xe/xe_preempt_fence.c              |     7 +
 drivers/gpu/drm/xe/xe_vm.c                         |    18 +-
 drivers/gpu/host1x/hw/cdma_hw.c                    |     2 +-
 drivers/greybus/manifest.c                         |     2 +
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |     4 +-
 .../amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h  |     2 -
 .../hid_descriptor/amd_sfh_hid_report_desc.h       |     7 -
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c |     6 +
 drivers/hid/hid-core.c                             |     4 +-
 drivers/hid/hid-cougar.c                           |     3 +
 drivers/hid/hid-cp2112.c                           |     9 +-
 drivers/hid/hid-elo.c                              |     3 +
 drivers/hid/hid-ids.h                              |     6 +
 drivers/hid/hid-input.c                            |    17 +-
 drivers/hid/hid-logitech-dj.c                      |     3 +
 drivers/hid/hid-logitech-hidpp.c                   |     2 +
 drivers/hid/hid-mcp2200.c                          |     5 +
 drivers/hid/hid-mcp2221.c                          |     2 +-
 drivers/hid/hid-multitouch.c                       |    19 +-
 drivers/hid/hid-picolcd_fb.c                       |    12 +-
 drivers/hid/hid-prodikeys.c                        |     7 +-
 drivers/hid/hid-pxrc.c                             |     3 +
 drivers/hid/hid-quirks.c                           |     4 +
 drivers/hid/hid-rmi.c                              |     2 +-
 drivers/hid/hid-roccat-isku.c                      |     3 +
 drivers/hid/hid-roccat-koneplus.c                  |     3 +
 drivers/hid/hid-roccat-konepure.c                  |     3 +
 drivers/hid/hid-roccat-kovaplus.c                  |     3 +
 drivers/hid/hid-roccat-pyra.c                      |     3 +
 drivers/hid/hid-roccat-ryos.c                      |     3 +
 drivers/hid/hid-roccat-savu.c                      |     3 +
 drivers/hid/hid-roccat.c                           |     8 +-
 drivers/hid/hid-zydacron.c                         |     3 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |     4 +-
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |     5 +-
 drivers/hid/usbhid/hiddev.c                        |    37 +-
 drivers/hid/wacom_sys.c                            |   198 +-
 drivers/hid/wacom_wac.c                            |    99 +-
 drivers/hid/wacom_wac.h                            |     6 +-
 drivers/hsi/controllers/omap_ssi_core.c            |     3 +
 drivers/hte/hte-tegra194.c                         |    10 +-
 drivers/hv/ring_buffer.c                           |    29 +-
 drivers/hwmon/asus_rog_ryujin.c                    |    22 +-
 drivers/hwmon/coretemp.c                           |    31 +-
 drivers/hwmon/corsair-cpro.c                       |     9 +-
 drivers/hwmon/gigabyte_waterforce.c                |     5 +
 drivers/hwmon/k10temp.c                            |     5 +-
 drivers/hwmon/lm95245.c                            |     6 +-
 drivers/hwmon/sht3x.c                              |     5 +-
 drivers/i2c/busses/i2c-designware-master.c         |     8 +
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |    21 +-
 drivers/i2c/busses/i2c-mt7621.c                    |     9 +-
 drivers/i2c/busses/i2c-qcom-cci.c                  |    24 +-
 drivers/i2c/i2c-core-acpi.c                        |     7 +-
 drivers/i3c/master.c                               |     3 +-
 drivers/iio/accel/adis16201.c                      |    10 +-
 drivers/iio/accel/adxl313_spi.c                    |     2 +
 drivers/iio/accel/adxl380_spi.c                    |     2 +
 drivers/iio/accel/fxls8962af-core.c                |     2 +
 drivers/iio/accel/kxcjk-1013.c                     |     1 +
 drivers/iio/accel/mma9551.c                        |     1 +
 drivers/iio/accel/mma9553.c                        |     1 +
 drivers/iio/adc/adi-axi-adc.c                      |     4 +
 drivers/iio/adc/at91-sama5d2_adc.c                 |     1 +
 drivers/iio/adc/max11205.c                         |     2 +
 drivers/iio/adc/max1241.c                          |     1 +
 drivers/iio/adc/mcp3911.c                          |     2 +
 drivers/iio/adc/stm32-adc.c                        |     4 +-
 drivers/iio/adc/ti-adc128s052.c                    |     8 +-
 drivers/iio/dac/ad5755.c                           |     3 +
 drivers/iio/frequency/adf4377.c                    |     3 +
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |     1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |    17 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |     2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |     9 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |     8 +-
 drivers/iio/light/apds9306.c                       |     2 +-
 drivers/iio/light/hid-sensor-als.c                 |    22 +-
 drivers/iio/potentiometer/x9250.c                  |     7 +-
 drivers/iio/pressure/bmp280-spi.c                  |     2 +
 drivers/infiniband/hw/hfi1/fault.c                 |     1 -
 drivers/infiniband/sw/rxe/rxe_mw.c                 |    20 +-
 drivers/input/joystick/xpad.c                      |     1 +
 drivers/input/keyboard/matrix_keypad.c             |     3 -
 drivers/iommu/amd/amd_iommu_types.h                |     1 +
 drivers/iommu/amd/iommu.c                          |    38 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |    16 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |     1 +
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |    18 +-
 drivers/iommu/dma-iommu.c                          |    20 +-
 drivers/iommu/intel/cache.c                        |     5 +-
 drivers/iommu/intel/iommu.h                        |    17 +-
 drivers/iommu/iommufd/fault.c                      |     4 +-
 drivers/iommu/iommufd/io_pagetable.c               |     3 +
 drivers/iommu/rockchip-iommu.c                     |    13 +
 drivers/ipack/devices/ipoctal.c                    |    16 +-
 drivers/irqchip/irq-gic-v3-its.c                   |     2 +-
 drivers/irqchip/irq-imx-intmux.c                   |    15 +-
 drivers/irqchip/irq-mchp-eic.c                     |     4 +-
 drivers/irqchip/irq-msi-lib.c                      |     1 +
 drivers/irqchip/irq-riscv-imsic-platform.c         |     2 +-
 drivers/leds/flash/leds-ktd2692.c                  |    10 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |     7 +-
 drivers/mailbox/qcom-ipcc.c                        |     6 +
 drivers/md/dm-bufio.c                              |     4 +-
 drivers/md/dm-integrity.c                          |    55 +
 drivers/md/dm-snap-persistent.c                    |     7 +-
 drivers/md/dm-vdo/indexer/chapter-index.c          |    15 +-
 drivers/md/dm-vdo/indexer/delta-index.c            |    17 +-
 drivers/md/dm-vdo/indexer/volume.c                 |     6 -
 drivers/md/dm-writecache.c                         |    54 +-
 drivers/md/dm.c                                    |     2 +-
 drivers/md/md.c                                    |    21 +-
 drivers/md/raid5-cache.c                           |    34 +-
 drivers/md/raid5.c                                 |    13 +-
 drivers/md/raid5.h                                 |     1 +
 drivers/media/cec/core/cec-adap.c                  |     1 -
 drivers/media/cec/platform/stm32/stm32-cec.c       |    16 +-
 drivers/media/cec/platform/tegra/tegra_cec.c       |    14 +-
 .../extron-da-hd-4k-plus/extron-da-hd-4k-plus.c    |     4 +-
 drivers/media/common/saa7146/saa7146_core.c        |     3 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |    14 +-
 drivers/media/dvb-core/dmxdev.c                    |    11 +-
 drivers/media/dvb-frontends/stv0900_core.c         |     2 +
 drivers/media/dvb-frontends/stv090x.c              |     2 +
 drivers/media/i2c/adv7180.c                        |     2 +-
 drivers/media/i2c/adv7604.c                        |     3 +-
 drivers/media/i2c/alvium-csi2.c                    |     1 +
 drivers/media/i2c/ov8856.c                         |     3 +-
 drivers/media/i2c/ov8865.c                         |    48 +-
 drivers/media/i2c/tc358743.c                       |     3 +-
 drivers/media/pci/cx18/cx18-driver.c               |     9 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |     2 +-
 drivers/media/pci/cx23885/cx23885-core.c           |     4 +
 drivers/media/pci/cx23885/cx23885-dvb.c            |    14 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |    10 +-
 drivers/media/pci/intel/ipu-bridge.c               |     2 +-
 drivers/media/pci/ivtv/ivtv-vbi.c                  |     2 +-
 drivers/media/pci/tw68/tw68-core.c                 |     2 +-
 drivers/media/pci/tw686x/tw686x-core.c             |    10 +
 drivers/media/platform/amphion/vpu_core.c          |    19 +-
 drivers/media/platform/amphion/vpu_drv.c           |     1 +
 drivers/media/platform/atmel/atmel-isi.c           |     7 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |    24 +
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |     6 +-
 .../media/platform/imagination/e5010-jpeg-enc.c    |     4 +-
 drivers/media/platform/m2m-deinterlace.c           |     2 +-
 drivers/media/platform/marvell/Kconfig             |     1 +
 drivers/media/platform/marvell/mcam-core.c         |    14 +-
 drivers/media/platform/marvell/mmp-driver.c        |     5 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |    17 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-comp.c   |    14 +-
 .../mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c   |     2 +
 drivers/media/platform/mediatek/vpu/mtk_vpu.c      |     2 +
 .../media/platform/microchip/microchip-csi2dc.c    |     1 +
 .../media/platform/microchip/microchip-isc-base.c  |    62 +-
 .../media/platform/microchip/microchip-isc-clk.c   |     7 +-
 drivers/media/platform/microchip/microchip-isc.h   |     1 +
 .../platform/microchip/microchip-sama5d2-isc.c     |    28 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |    28 +-
 drivers/media/platform/nuvoton/npcm-video.c        |     9 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |    23 +-
 drivers/media/platform/qcom/camss/camss-vfe-17x.c  |     5 +-
 drivers/media/platform/qcom/camss/camss-vfe.c      |    14 +-
 .../media/platform/samsung/exynos4-is/fimc-lite.c  |     3 +-
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c   |     4 +-
 .../media/platform/st/sti/delta/delta-mjpeg-hdr.c  |     7 +-
 drivers/media/platform/ti/davinci/vpif_capture.c   |     5 +-
 drivers/media/platform/ti/davinci/vpif_display.c   |     3 +
 drivers/media/platform/verisilicon/hantro_drv.c    |     9 +-
 .../platform/verisilicon/hantro_g1_mpeg2_dec.c     |     5 +
 .../verisilicon/rockchip_vpu981_hw_av1_dec.c       |    68 +-
 drivers/media/rc/bpf-lirc.c                        |    18 +-
 drivers/media/rc/fintek-cir.c                      |     4 +
 drivers/media/rc/imon.c                            |     5 -
 drivers/media/rc/ir-hix5hd2.c                      |     5 +-
 drivers/media/rc/ir-mce_kbd-decoder.c              |     5 +-
 drivers/media/rc/ir_toy.c                          |     2 +-
 drivers/media/rc/lirc_dev.c                        |     3 +
 drivers/media/rc/meson-ir-tx.c                     |    20 +-
 drivers/media/rc/rc-ir-raw.c                       |    66 +-
 drivers/media/rc/rc-main.c                         |    42 +-
 drivers/media/rc/redrat3.c                         |    21 +
 drivers/media/rc/streamzap.c                       |     1 +
 drivers/media/rc/sunxi-cir.c                       |     2 +-
 drivers/media/test-drivers/vicodec/codec-fwht.h    |     2 +-
 drivers/media/test-drivers/vicodec/vicodec-core.c  |    16 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |     4 +
 drivers/media/test-drivers/vidtv/vidtv_demod.c     |     9 -
 drivers/media/test-drivers/vim2m.c                 |    29 +-
 drivers/media/test-drivers/vivid/vivid-core.c      |     1 +
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |    13 +
 drivers/media/usb/au0828/au0828-core.c             |     4 +
 drivers/media/usb/au0828/au0828-dvb.c              |    20 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c          |    15 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |     2 +-
 drivers/media/usb/cx231xx/cx231xx.h                |     2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    14 +-
 drivers/media/usb/em28xx/em28xx-audio.c            |     7 +
 drivers/media/usb/em28xx/em28xx-cards.c            |     2 +-
 drivers/media/usb/em28xx/em28xx-core.c             |     3 -
 drivers/media/usb/em28xx/em28xx-video.c            |    26 +-
 drivers/media/usb/go7007/go7007-driver.c           |     5 +-
 drivers/media/usb/go7007/go7007-fw.c               |    28 +-
 drivers/media/usb/go7007/go7007-usb.c              |     8 +
 drivers/media/usb/go7007/s2250-board.c             |    54 +-
 drivers/media/usb/gspca/gspca.c                    |     3 +-
 drivers/media/usb/hackrf/hackrf.c                  |     7 +-
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          |     1 +
 drivers/media/usb/usbtv/usbtv-core.c               |     6 +-
 drivers/media/usb/usbtv/usbtv-video.c              |     4 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |     2 +-
 drivers/media/v4l2-core/v4l2-common.c              |     2 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |    12 +-
 drivers/memory/brcmstb_dpfe.c                      |    24 +-
 drivers/mfd/axp20x.c                               |     2 +-
 drivers/mfd/da903x.c                               |    34 +-
 drivers/mfd/ipaq-micro.c                           |     2 +-
 drivers/mfd/tps65217.c                             |    69 +-
 drivers/mfd/wcd934x.c                              |     8 +-
 drivers/misc/bcm-vk/bcm_vk_msg.c                   |    18 +-
 drivers/misc/genwqe/card_utils.c                   |     2 +-
 drivers/misc/hpilo.c                               |     7 +-
 drivers/misc/ibmvmc.c                              |    17 +-
 drivers/misc/mei/vsc-tp.c                          |     2 +-
 drivers/mmc/core/block.c                           |     5 +
 drivers/mmc/host/cqhci-core.c                      |    14 +-
 drivers/mmc/host/dw_mmc.c                          |     1 +
 drivers/mmc/host/moxart-mmc.c                      |    11 +-
 drivers/mmc/host/sdhci-of-ma35d1.c                 |     1 +
 drivers/mtd/chips/cfi_cmdset_0002.c                |    15 +
 drivers/mtd/maps/amd76xrom.c                       |     2 +
 drivers/mtd/maps/l440gx.c                          |     2 -
 drivers/mtd/maps/pci.c                             |     2 +-
 drivers/mtd/mtdcore.c                              |     2 +-
 drivers/mtd/mtdsuper.c                             |     4 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |     6 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |     3 +
 drivers/mtd/parsers/qcomsmempart.c                 |     4 +-
 drivers/mtd/spi-nor/core.c                         |     9 +
 drivers/mtd/spi-nor/sfdp.c                         |     8 +
 drivers/net/bonding/bond_main.c                    |     2 +-
 drivers/net/dsa/mt7530.c                           |    44 +-
 drivers/net/ethernet/google/gve/gve_flow_rule.c    |     1 +
 drivers/net/ethernet/hisilicon/hisi_femac.c        |     1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    40 +-
 drivers/net/ethernet/marvell/mvneta.c              |    18 +
 drivers/net/ethernet/marvell/mvneta_bm.c           |    72 +
 .../ethernet/marvell/prestera/prestera_router.c    |     6 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |     5 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h       |     1 +
 drivers/net/ethernet/sfc/efx.c                     |     4 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |     3 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |     3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |     4 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |     6 +-
 drivers/net/macvlan.c                              |     3 +-
 drivers/net/netdevsim/bpf.c                        |    11 +
 drivers/net/pcs/pcs-mtk-lynxi.c                    |     7 +-
 drivers/net/phy/sfp.c                              |     3 +
 drivers/net/ppp/ppp_generic.c                      |     1 +
 drivers/net/tap.c                                  |     5 +-
 drivers/net/team/team_mode_broadcast.c             |     2 +
 drivers/net/tun.c                                  |    14 +-
 drivers/net/usb/cdc_ether.c                        |    16 +
 drivers/net/usb/pegasus.c                          |    16 +-
 drivers/net/usb/qmi_wwan.c                         |     1 +
 drivers/net/usb/rtl8150.c                          |     4 +-
 drivers/net/veth.c                                 |     5 +-
 drivers/net/virtio_net.c                           |    25 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |     6 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    79 +-
 drivers/net/wireless/ath/ath11k/dp.c               |     2 +
 drivers/net/wireless/ath/ath11k/wmi.c              |     6 +
 drivers/net/wireless/ath/ath12k/wmi.c              |    37 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |    10 +
 drivers/net/wireless/ath/ath9k/channel.c           |     2 +
 drivers/net/wireless/broadcom/b43/main.c           |     5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    49 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |     2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h |     4 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    17 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |     2 +
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |     1 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    76 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    17 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |     6 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |     1 +
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |     5 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |     5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    22 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |     9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    18 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    31 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |    30 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    39 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |     6 -
 drivers/net/wireless/realtek/rtw88/mac80211.c      |     2 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |    63 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |     4 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |     9 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |     3 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |     7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |     3 +-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |     7 +-
 drivers/net/wireless/rsi/rsi_common.h              |     2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |     2 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |     2 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |    10 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |     5 +
 drivers/net/wwan/wwan_hwsim.c                      |     4 +
 drivers/nfc/nfcmrvl/spi.c                          |     4 +
 drivers/nfc/nxp-nci/i2c.c                          |     4 +-
 drivers/nvme/host/auth.c                           |    18 +-
 drivers/nvme/host/core.c                           |     4 +
 drivers/nvme/host/fc.c                             |     2 +-
 drivers/nvme/host/ioctl.c                          |     2 +-
 drivers/nvme/host/nvme.h                           |     6 +-
 drivers/nvme/host/pci.c                            |     6 +-
 drivers/nvme/host/rdma.c                           |     1 +
 drivers/nvme/host/sysfs.c                          |    18 +-
 drivers/nvme/host/tcp.c                            |    16 +-
 drivers/nvme/host/zns.c                            |     8 +-
 drivers/nvme/target/admin-cmd.c                    |     2 +-
 drivers/nvme/target/auth.c                         |     2 +
 drivers/nvme/target/configfs.c                     |     2 +
 drivers/nvme/target/fabrics-cmd-auth.c             |    45 +-
 drivers/nvme/target/fc.c                           |    18 +-
 drivers/nvme/target/io-cmd-bdev.c                  |     5 +-
 drivers/nvme/target/io-cmd-file.c                  |     4 +-
 drivers/nvme/target/nvmet.h                        |     2 +
 drivers/nvme/target/passthru.c                     |     9 +
 drivers/nvme/target/rdma.c                         |     2 +-
 drivers/nvme/target/zns.c                          |    10 +
 drivers/nvmem/brcm_nvram.c                         |    15 +-
 drivers/nvmem/core.c                               |     4 +-
 drivers/opp/core.c                                 |    54 +-
 drivers/parisc/eisa_enumerator.c                   |    15 +-
 drivers/pci/ats.c                                  |     7 +-
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |     2 +
 drivers/pci/controller/pcie-rockchip-host.c        |    20 -
 drivers/pci/controller/pcie-xilinx-dma-pl.c        |    10 +-
 drivers/pci/controller/vmd.c                       |     3 +
 drivers/pci/hotplug/pciehp_core.c                  |     2 +-
 drivers/pci/pci-label.c                            |     2 +-
 drivers/pci/pci.c                                  |    48 +-
 drivers/pci/pcie/aer.c                             |    35 +-
 drivers/pci/pcie/portdrv.c                         |    28 +-
 drivers/pci/probe.c                                |     5 +-
 drivers/pci/quirks.c                               |    21 +
 drivers/pci/switch/switchtec.c                     |     1 +
 drivers/pci/xen-pcifront.c                         |    11 +-
 drivers/peci/controller/peci-aspeed.c              |     6 +-
 drivers/peci/controller/peci-npcm.c                |     6 +-
 drivers/perf/marvell_cn10k_ddr_pmu.c               |     6 +
 drivers/perf/riscv_pmu_sbi.c                       |    33 +-
 drivers/perf/xgene_pmu.c                           |     4 +-
 drivers/phy/phy-core.c                             |    45 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c          |    96 +-
 drivers/pinctrl/pinctrl-sx150x.c                   |     1 +
 drivers/pinctrl/stm32/pinctrl-stm32.c              |     6 +-
 drivers/platform/cznic/turris-omnia-mcu-base.c     |     1 +
 drivers/platform/x86/amd/pmc/mp1_stb.c             |    23 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |     5 +-
 drivers/platform/x86/amd/pmf/spc.c                 |     8 +-
 drivers/platform/x86/amd/pmf/sps.c                 |    10 +-
 drivers/platform/x86/asus-nb-wmi.c                 |     1 +
 drivers/platform/x86/asus-wmi.c                    |    42 +-
 drivers/platform/x86/dell/dell-smbios-wmi.c        |    69 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |    82 +-
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |    16 +-
 .../platform/x86/hp/hp-bioscfg/spmobj-attributes.c |     5 +-
 drivers/platform/x86/hp/hp-wmi.c                   |     7 +-
 drivers/platform/x86/intel/int1092/intel_sar.c     |     8 +-
 drivers/platform/x86/intel/pmt/class.c             |     9 +-
 .../x86/intel/uncore-frequency/uncore-frequency.c  |     2 +-
 drivers/platform/x86/lenovo-ymc.c                  |     8 +-
 drivers/platform/x86/msi-ec.c                      |     1 +
 drivers/platform/x86/siemens/simatic-ipc.c         |    21 +-
 drivers/platform/x86/thinkpad_acpi.c               |     1 +
 drivers/pmdomain/qcom/rpmhpd.c                     |    14 +-
 drivers/power/reset/piix4-poweroff.c               |     1 +
 drivers/power/supply/ab8500_fg.c                   |    69 +-
 drivers/power/supply/bq27xxx_battery.c             |     2 +-
 drivers/power/supply/cros_peripheral_charger.c     |    13 +-
 drivers/power/supply/generic-adc-battery.c         |     2 +-
 drivers/power/supply/qcom_pmi8998_charger.c        |    41 +-
 drivers/power/supply/sbs-battery.c                 |    11 +
 drivers/powercap/intel_rapl_common.c               |     4 +-
 drivers/pwm/pwm-tiehrpwm.c                         |     3 +
 drivers/rapidio/devices/rio_mport_cdev.c           |     5 +-
 drivers/regulator/core.c                           |     4 +
 drivers/regulator/fan53555.c                       |     6 +
 drivers/regulator/of_regulator.c                   |    26 +-
 drivers/regulator/rt6190-regulator.c               |    18 +-
 drivers/regulator/rt6245-regulator.c               |     5 +-
 drivers/remoteproc/remoteproc_core.c               |    23 +-
 drivers/remoteproc/remoteproc_elf_loader.c         |    23 +-
 drivers/rpmsg/rpmsg_char.c                         |     5 +
 drivers/rtc/rtc-ab-eoz9.c                          |     1 +
 drivers/rtc/rtc-brcmstb-waketimer.c                |     1 +
 drivers/rtc/rtc-cmos.c                             |     6 +-
 drivers/rtc/rtc-ds1307.c                           |     2 +-
 drivers/s390/block/dasd.c                          |    10 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |    22 +-
 drivers/scsi/dc395x.c                              |    10 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |    10 +-
 drivers/scsi/libiscsi_tcp.c                        |     3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    15 +-
 drivers/scsi/scsi_devinfo.c                        |     2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |    36 +
 drivers/scsi/snic/snic_main.c                      |     1 +
 drivers/sh/intc/core.c                             |    11 +-
 drivers/sh/maple/maple.c                           |     4 +-
 drivers/slimbus/messaging.c                        |     2 +-
 drivers/soc/fsl/dpio/dpio-driver.c                 |     9 +-
 drivers/soc/fsl/qe/tsa.c                           |    16 +-
 drivers/soc/ixp4xx/ixp4xx-qmgr.c                   |     1 +
 drivers/soc/qcom/socinfo.c                         |     1 +
 drivers/soundwire/dmi-quirks.c                     |    42 +-
 drivers/soundwire/intel_auxdevice.c                |     1 +
 drivers/spi/spi-amd.c                              |    17 +
 drivers/spi/spi-bcm-qspi.c                         |     9 +-
 drivers/spi/spi-bcm2835.c                          |     4 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |     6 +-
 drivers/spi/spi-bcm63xx.c                          |     5 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |     6 +-
 drivers/spi/spi-cadence-quadspi.c                  |     3 +-
 drivers/spi/spi-cadence-xspi.c                     |    16 +-
 drivers/spi/spi-ch341.c                            |     6 +
 drivers/spi/spi-jcore.c                            |     2 +
 drivers/spi/spi-ljca.c                             |     7 +-
 drivers/spi/spi-npcm-fiu.c                         |     8 +
 drivers/spi/spi-nxp-fspi.c                         |    31 +-
 drivers/spi/spi-zynq-qspi.c                        |    13 +-
 drivers/staging/greybus/uart.c                     |    32 +-
 drivers/staging/media/av7110/sp8870.c              |     5 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |     1 +
 drivers/staging/media/meson/vdec/vdec.c            |     2 +-
 drivers/staging/rtl8723bs/core/rtw_recv.c          |   101 +-
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |     7 +
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |     5 +-
 .../int340x_thermal/processor_thermal_device.c     |    10 +-
 .../intel/int340x_thermal/processor_thermal_rfim.c |    11 +-
 drivers/thermal/intel/intel_powerclamp.c           |     3 +-
 drivers/thunderbolt/icm.c                          |     6 +-
 drivers/tty/serial/8250/8250_exar.c                |    36 +-
 drivers/tty/serial/8250/8250_lpss.c                |     7 +-
 drivers/tty/serial/8250/8250_omap.c                |    15 +-
 drivers/tty/serial/8250/8250_platform.c            |     1 +
 drivers/tty/serial/8250/8250_pnp.c                 |     1 +
 drivers/tty/serial/pch_uart.c                      |     5 +
 drivers/tty/serial/pmac_zilog.c                    |     4 +-
 drivers/tty/serial/qcom_geni_serial.c              |     8 +
 drivers/tty/serial/serial_core.c                   |     7 +
 drivers/ufs/core/ufs_bsg.c                         |    10 +-
 drivers/ufs/core/ufshcd.c                          |    21 +-
 drivers/uio/uio_sercos3.c                          |     1 +
 drivers/usb/class/cdc-acm.c                        |     6 +-
 drivers/usb/core/driver.c                          |     1 -
 drivers/usb/core/message.c                         |     1 +
 drivers/usb/fotg210/fotg210-udc.c                  |    17 +-
 drivers/usb/gadget/configfs.c                      |     4 +-
 drivers/usb/gadget/function/u_audio.c              |    12 +-
 drivers/usb/gadget/legacy/inode.c                  |    24 +-
 drivers/usb/gadget/udc/fsl_qe_udc.c                |     8 +-
 drivers/usb/misc/cypress_cy7c63.c                  |     8 +-
 drivers/usb/misc/uss720.c                          |     1 +
 drivers/usb/mtu3/mtu3_trace.h                      |     4 +-
 drivers/usb/musb/musb_host.c                       |    14 +-
 drivers/usb/serial/option.c                        |     5 +
 drivers/usb/serial/sierra.c                        |     3 +-
 drivers/usb/serial/usb_wwan.c                      |     3 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |    15 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    23 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |     3 +-
 drivers/vfio/pci/mlx5/cmd.c                        |     2 +-
 drivers/video/backlight/lm3630a_bl.c               |     1 +
 drivers/video/backlight/qcom-wled.c                |    35 +-
 drivers/video/fbdev/atmel_lcdfb.c                  |    24 +-
 drivers/video/fbdev/core/bitblit.c                 |     7 +-
 drivers/video/fbdev/core/fbcon.c                   |     7 +
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c         |     9 +-
 drivers/video/fbdev/platinumfb.c                   |    35 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |     6 +-
 drivers/video/fbdev/smscufx.c                      |     9 +-
 drivers/video/fbdev/ssd1307fb.c                    |     6 +-
 drivers/video/fbdev/udlfb.c                        |    36 +-
 drivers/video/fbdev/xen-fbfront.c                  |     7 +-
 drivers/virtio/virtio_balloon.c                    |     6 +-
 drivers/virtio/virtio_ring.c                       |     8 +
 drivers/w1/masters/ds2482.c                        |     8 +
 drivers/watchdog/rzv2h_wdt.c                       |    59 +-
 drivers/xen/gntdev.c                               |     7 +
 drivers/xen/privcmd.c                              |    47 +-
 drivers/xen/xen-pciback/pci_stub.c                 |     7 +-
 fs/affs/bitmap.c                                   |     2 +-
 fs/afs/rxrpc.c                                     |     4 +-
 fs/aio.c                                           |    18 +-
 fs/btrfs/inode.c                                   |     3 -
 fs/btrfs/relocation.c                              |    13 +-
 fs/btrfs/super.c                                   |     3 +
 fs/btrfs/volumes.c                                 |     6 +-
 fs/ceph/addr.c                                     |    15 +-
 fs/ceph/caps.c                                     |    23 +-
 fs/ceph/crypto.c                                   |     3 +
 fs/ceph/dir.c                                      |    14 +-
 fs/ceph/inode.c                                    |     3 +-
 fs/ceph/mds_client.c                               |    28 +-
 fs/ceph/mdsmap.c                                   |    12 +-
 fs/ceph/snap.c                                     |     7 +-
 fs/ceph/xattr.c                                    |    10 +
 fs/crypto/keysetup.c                               |     8 +-
 fs/dax.c                                           |    12 +-
 fs/dcache.c                                        |    16 +-
 fs/dlm/lowcomms.c                                  |     6 +-
 fs/erofs/decompressor.c                            |     2 +-
 fs/exec.c                                          |    11 +-
 fs/exfat/balloc.c                                  |    31 +-
 fs/exfat/dir.c                                     |     8 +-
 fs/exfat/namei.c                                   |    27 +-
 fs/exportfs/expfs.c                                |     6 +-
 fs/ext4/balloc.c                                   |     6 +-
 fs/ext4/dir.c                                      |    20 +-
 fs/ext4/ext4.h                                     |     5 +-
 fs/ext4/extents.c                                  |    26 +-
 fs/ext4/indirect.c                                 |    17 +
 fs/ext4/inode.c                                    |    20 +-
 fs/ext4/namei.c                                    |    11 +-
 fs/ext4/super.c                                    |    24 +-
 fs/f2fs/compress.c                                 |    10 +-
 fs/f2fs/data.c                                     |    11 +-
 fs/f2fs/file.c                                     |    49 +-
 fs/f2fs/gc.c                                       |     9 +-
 fs/f2fs/segment.c                                  |     3 +-
 fs/f2fs/super.c                                    |    42 +-
 fs/fat/fat.h                                       |     2 +-
 fs/fat/fatent.c                                    |    21 +-
 fs/fat/file.c                                      |     3 +-
 fs/fat/misc.c                                      |     6 +-
 fs/fat/namei_msdos.c                               |     3 +
 fs/fs-writeback.c                                  |     7 +-
 fs/fs_pin.c                                        |     9 +-
 fs/fuse/dir.c                                      |     3 +
 fs/fuse/file.c                                     |     9 +
 fs/fuse/virtio_fs.c                                |    21 +-
 fs/gfs2/lops.c                                     |     4 +-
 fs/hfsplus/extents.c                               |     2 +
 fs/hugetlbfs/inode.c                               |     2 +-
 fs/iomap/fiemap.c                                  |     8 +-
 fs/isofs/inode.c                                   |     2 +
 fs/isofs/isofs.h                                   |     2 +
 fs/isofs/rock.c                                    |    11 +-
 fs/jbd2/journal.c                                  |     2 +-
 fs/lockd/svclock.c                                 |     2 +
 fs/namei.c                                         |    29 -
 fs/namespace.c                                     |    20 +-
 fs/netfs/objects.c                                 |     4 +-
 fs/netfs/rolling_buffer.c                          |     2 +-
 fs/nfs/blocklayout/blocklayout.h                   |     5 -
 fs/nfs/blocklayout/rpc_pipefs.c                    |    79 +-
 fs/nfs/callback_proc.c                             |     3 +-
 fs/nfs/callback_xdr.c                              |     2 +-
 fs/nfs/dir.c                                       |     6 +
 fs/nfs/filelayout/filelayout.c                     |     8 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    25 +-
 fs/nfs/netns.h                                     |     5 +-
 fs/nfs/nfs4_fs.h                                   |     2 +
 fs/nfs/nfs4proc.c                                  |     8 +
 fs/nfs/nfs4state.c                                 |    78 +-
 fs/nfs/pnfs.c                                      |    24 +-
 fs/nfs/pnfs.h                                      |     2 +-
 fs/nfsd/nfs3acl.c                                  |    15 +
 fs/nfsd/nfs4idmap.c                                |     4 +-
 fs/nfsd/nfs4proc.c                                 |     4 +-
 fs/nfsd/nfs4recover.c                              |    42 +-
 fs/nfsd/nfs4state.c                                |    43 +-
 fs/nfsd/nfs4xdr.c                                  |    26 +-
 fs/nfsd/nfsctl.c                                   |    73 +-
 fs/nfsd/nfsproc.c                                  |    19 +-
 fs/nfsd/xdr4.h                                     |     1 +
 fs/nilfs2/dir.c                                    |    34 +
 fs/nilfs2/inode.c                                  |     6 -
 fs/nilfs2/segment.c                                |     2 +
 fs/nilfs2/sysfs.c                                  |     5 +-
 fs/nilfs2/the_nilfs.c                              |    34 +-
 fs/notify/fanotify/fanotify.c                      |     7 +-
 fs/notify/fanotify/fanotify.h                      |    21 +-
 fs/ntfs3/attrib.c                                  |     2 +-
 fs/ntfs3/dir.c                                     |    14 +-
 fs/ntfs3/fslog.c                                   |    29 +-
 fs/ntfs3/index.c                                   |    14 +-
 fs/ntfs3/inode.c                                   |    10 +-
 fs/ntfs3/namei.c                                   |     9 +-
 fs/ntfs3/ntfs_fs.h                                 |     2 +
 fs/ntfs3/super.c                                   |    18 +-
 fs/ocfs2/cluster/heartbeat.c                       |    39 +-
 fs/ocfs2/cluster/netdebug.c                        |     4 +
 fs/ocfs2/cluster/nodemanager.c                     |    10 +-
 fs/ocfs2/cluster/quorum.c                          |     7 +-
 fs/ocfs2/cluster/quorum.h                          |     1 +
 fs/ocfs2/dir.c                                     |    76 +-
 fs/ocfs2/dlm/dlmconvert.c                          |    10 +-
 fs/ocfs2/dlm/dlmdebug.c                            |     5 +
 fs/ocfs2/dlm/dlmdomain.c                           |     3 +-
 fs/ocfs2/dlm/dlmlock.c                             |     8 +-
 fs/ocfs2/dlmglue.c                                 |     6 +
 fs/ocfs2/file.c                                    |   118 +-
 fs/ocfs2/filecheck.c                               |     5 +-
 fs/ocfs2/journal.c                                 |     3 +-
 fs/ocfs2/journal.h                                 |     1 -
 fs/ocfs2/quota_local.c                             |    12 +-
 fs/ocfs2/refcounttree.c                            |    15 +-
 fs/ocfs2/super.c                                   |    17 +-
 fs/ocfs2/xattr.c                                   |   142 +-
 fs/overlayfs/copy_up.c                             |   112 +-
 fs/overlayfs/dir.c                                 |    22 +-
 fs/overlayfs/inode.c                               |    14 +-
 fs/overlayfs/namei.c                               |     8 +-
 fs/overlayfs/overlayfs.h                           |     8 +-
 fs/overlayfs/readdir.c                             |    29 +-
 fs/overlayfs/super.c                               |    17 +-
 fs/pnode.c                                         |   125 +-
 fs/proc/task_mmu.c                                 |     9 +-
 fs/read_write.c                                    |     8 +-
 fs/romfs/super.c                                   |     8 +
 fs/signalfd.c                                      |    28 +-
 fs/smb/client/cached_dir.c                         |    30 +-
 fs/smb/client/cifsacl.c                            |     9 +-
 fs/smb/client/cifsfs.c                             |    61 +-
 fs/smb/client/cifsfs.h                             |     4 +-
 fs/smb/client/cifsglob.h                           |     5 +-
 fs/smb/client/cifspdu.h                            |    30 -
 fs/smb/client/cifssmb.c                            |    69 +-
 fs/smb/client/connect.c                            |     4 +-
 fs/smb/client/inode.c                              |    46 +-
 fs/smb/client/readdir.c                            |     3 +
 fs/smb/client/reparse.c                            |    67 +-
 fs/smb/client/sess.c                               |     6 +-
 fs/smb/client/smb2ops.c                            |   122 +-
 fs/smb/client/smb2pdu.c                            |    12 +-
 fs/smb/client/transport.c                          |     6 +
 fs/smb/common/smb2pdu.h                            |    14 +-
 fs/smb/server/auth.c                               |     3 +-
 fs/smb/server/connection.c                         |    22 +
 fs/smb/server/mgmt/user_config.c                   |     6 +-
 fs/smb/server/mgmt/user_session.c                  |     4 +-
 fs/smb/server/misc.c                               |     8 +-
 fs/smb/server/oplock.c                             |    16 +-
 fs/smb/server/server.c                             |    21 +
 fs/smb/server/smb2pdu.c                            |   426 +-
 fs/smb/server/smb2pdu.h                            |     1 +
 fs/smb/server/smb_common.c                         |     6 +-
 fs/smb/server/smbacl.c                             |    53 +-
 fs/smb/server/transport_ipc.c                      |    16 +-
 fs/smb/server/transport_rdma.c                     |     1 -
 fs/smb/server/transport_tcp.c                      |    15 +
 fs/smb/server/vfs.c                                |   133 +-
 fs/smb/server/vfs.h                                |     3 +-
 fs/smb/server/vfs_cache.c                          |    46 +-
 fs/smb/server/vfs_cache.h                          |     2 +
 fs/splice.c                                        |    12 +-
 fs/stat.c                                          |     6 +-
 fs/udf/balloc.c                                    |    12 +-
 fs/udf/inode.c                                     |    33 +-
 fs/udf/super.c                                     |     5 +-
 fs/udf/truncate.c                                  |     2 +-
 fs/udf/udfdecl.h                                   |     3 +-
 fs/ufs/cylinder.c                                  |    31 +-
 fs/ufs/dir.c                                       |     2 +-
 fs/verity/open.c                                   |    38 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    13 +
 fs/xfs/libxfs/xfs_da_btree.c                       |    14 +
 fs/xfs/libxfs/xfs_inode_fork.c                     |     4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                 |     8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |     2 +-
 fs/xfs/libxfs/xfs_trans_space.c                    |     6 +-
 fs/xfs/scrub/agheader.c                            |    15 +-
 fs/xfs/scrub/agheader_repair.c                     |     6 +-
 fs/xfs/scrub/alloc_repair.c                        |    11 +-
 fs/xfs/scrub/attr.c                                |    17 +-
 fs/xfs/scrub/attr_repair.c                         |    18 +-
 fs/xfs/scrub/bitmap.c                              |    20 +
 fs/xfs/scrub/bmap.c                                |     7 +
 fs/xfs/scrub/btree.c                               |    16 +-
 fs/xfs/scrub/common.c                              |     7 +-
 fs/xfs/scrub/dabtree.c                             |    27 +-
 fs/xfs/scrub/dir.c                                 |     2 +
 fs/xfs/scrub/dirtree_repair.c                      |    76 +-
 fs/xfs/scrub/dqiterate.c                           |     1 +
 fs/xfs/scrub/fscounters.c                          |    14 +-
 fs/xfs/scrub/ialloc_repair.c                       |     8 +-
 fs/xfs/scrub/inode.c                               |     2 +-
 fs/xfs/scrub/inode_repair.c                        |    39 +-
 fs/xfs/scrub/iscan.c                               |     2 +-
 fs/xfs/scrub/newbt.c                               |    13 -
 fs/xfs/scrub/newbt.h                               |     1 -
 fs/xfs/scrub/parent_repair.c                       |     4 +
 fs/xfs/scrub/quota.c                               |     8 +-
 fs/xfs/scrub/quota_repair.c                        |    39 +-
 fs/xfs/scrub/quotacheck_repair.c                   |    54 +-
 fs/xfs/scrub/readdir.c                             |     2 +-
 fs/xfs/scrub/reap.c                                |     2 +-
 fs/xfs/scrub/refcount.c                            |    17 +-
 fs/xfs/scrub/repair.h                              |     2 +-
 fs/xfs/scrub/rmap.c                                |    20 +-
 fs/xfs/scrub/stats.c                               |     5 +-
 fs/xfs/scrub/symlink.c                             |    17 +-
 fs/xfs/scrub/trace.c                               |    13 +
 fs/xfs/scrub/trace.h                               |    10 +-
 fs/xfs/scrub/xfarray.c                             |     4 +-
 fs/xfs/xfs_dquot.c                                 |    20 +-
 fs/xfs/xfs_dquot.h                                 |     2 +-
 fs/xfs/xfs_handle.c                                |     2 +-
 fs/xfs/xfs_inode_item_recover.c                    |    20 +-
 fs/xfs/xfs_qm.c                                    |     6 +-
 fs/xfs/xfs_trans_dquot.c                           |     6 +-
 include/asm-generic/bitops/le.h                    |    18 +-
 include/dt-bindings/arm/qcom,ids.h                 |     1 +
 include/linux/device.h                             |     5 +
 include/linux/device/bus.h                         |     3 -
 include/linux/fault-inject.h                       |    10 +-
 include/linux/fs.h                                 |     4 +-
 include/linux/hid.h                                |     1 +
 include/linux/hiddev.h                             |     2 +
 include/linux/hugetlb.h                            |     4 +-
 include/linux/interrupt.h                          |     2 +
 include/linux/libata.h                             |     1 +
 include/linux/mempool.h                            |     7 +
 include/linux/pci.h                                |     2 +-
 include/linux/remoteproc.h                         |     2 +
 include/linux/rtc.h                                |     2 +
 include/math-emu/op-common.h                       |    23 +-
 include/math-emu/soft-fp.h                         |     8 +
 include/media/v4l2-ctrls.h                         |     6 +
 include/net/addrconf.h                             |     3 +
 include/net/gso.h                                  |     8 +
 include/net/mptcp.h                                |     9 +
 include/net/netfilter/nf_conntrack_expect.h        |     3 +
 include/trace/events/huge_memory.h                 |    12 +-
 include/trace/misc/nfs.h                           |    10 +
 include/uapi/linux/pci_regs.h                      |     6 +
 include/video/maxinefb.h                           |     4 +-
 init/main.c                                        |     6 +-
 init/version.c                                     |     3 +
 io_uring/io-wq.c                                   |    14 +-
 io_uring/io_uring.c                                |     3 +-
 io_uring/kbuf.c                                    |     4 +-
 io_uring/net.c                                     |    12 +
 io_uring/rsrc.c                                    |     4 +-
 io_uring/sqpoll.c                                  |    28 +-
 io_uring/sqpoll.h                                  |     3 +-
 io_uring/tctx.c                                    |     6 +-
 io_uring/timeout.c                                 |     3 +
 io_uring/waitid.c                                  |     5 +
 ipc/mqueue.c                                       |     7 +
 ipc/msgutil.c                                      |     3 +-
 ipc/namespace.c                                    |     9 +-
 ipc/shm.c                                          |    23 +-
 kernel/bpf/queue_stack_maps.c                      |     3 +
 kernel/cgroup/cgroup.c                             |     2 +-
 kernel/cpu_pm.c                                    |     9 +-
 kernel/debug/gdbstub.c                             |    55 +-
 kernel/fork.c                                      |     4 +
 kernel/futex/core.c                                |     8 +-
 kernel/futex/pi.c                                  |   100 +-
 kernel/irq/internals.h                             |     2 +
 kernel/irq/irqdomain.c                             |     4 +-
 kernel/irq/manage.c                                |    31 +-
 kernel/kcov.c                                      |     8 +
 kernel/kcsan/core.c                                |     7 +-
 kernel/module/kallsyms.c                           |    31 +-
 kernel/module/main.c                               |   612 +-
 kernel/reboot.c                                    |     9 +
 kernel/resource.c                                  |    11 +-
 kernel/sched/cpufreq_schedutil.c                   |    14 +-
 kernel/sched/ext.c                                 |     2 +-
 kernel/sched/fair.c                                |     7 +-
 kernel/seccomp.c                                   |     7 +-
 kernel/sys.c                                       |     3 +
 kernel/time/itimer.c                               |     2 +-
 kernel/time/namespace.c                            |     2 +-
 kernel/time/posix-cpu-timers.c                     |     4 +-
 kernel/time/timekeeping.c                          |     3 +-
 kernel/trace/ring_buffer.c                         |     2 +
 kernel/trace/trace_events_hist.c                   |   105 +-
 kernel/ucount.c                                    |    21 +-
 lib/842/842_decompress.c                           |     7 +-
 lib/buildid.c                                      |     4 +
 lib/decompress_bunzip2.c                           |     6 +-
 lib/fault-inject.c                                 |     7 +-
 lib/klist.c                                        |    16 +-
 lib/kobject_uevent.c                               |     8 +-
 mm/damon/core.c                                    |    19 +-
 mm/damon/sysfs-schemes.c                           |     6 +-
 mm/damon/sysfs.c                                   |    21 +
 mm/damon/tests/core-kunit.h                        |   316 +
 mm/hugetlb.c                                       |   153 +-
 mm/hugetlb_cgroup.c                                |    33 +
 mm/khugepaged.c                                    |    11 +-
 mm/kmemleak.c                                      |    32 +-
 mm/madvise.c                                       |    12 +-
 mm/memcontrol-v1.c                                 |    12 +-
 mm/memcontrol.c                                    |    13 +
 mm/mempolicy.c                                     |    14 +-
 mm/migrate.c                                       |     6 +-
 mm/mlock.c                                         |     2 +-
 mm/nommu.c                                         |     6 +-
 mm/page_alloc.c                                    |    18 +-
 mm/percpu.c                                        |     5 +-
 mm/rmap.c                                          |    11 +-
 mm/shmem.c                                         |     4 +-
 mm/slab_common.c                                   |    17 +-
 mm/vmscan.c                                        |    19 +-
 mm/zswap.c                                         |     3 +-
 net/8021q/vlan_dev.c                               |    33 +-
 net/bluetooth/6lowpan.c                            |     1 +
 net/bluetooth/hci_debugfs.c                        |     9 +
 net/bluetooth/hci_event.c                          |     7 +
 net/bluetooth/hci_sync.c                           |    30 +
 net/bluetooth/l2cap_core.c                         |    41 +-
 net/bluetooth/l2cap_sock.c                         |     4 +
 net/bridge/netfilter/ebtables.c                    |    12 +-
 net/ceph/mon_client.c                              |     5 +-
 net/ceph/osd_client.c                              |    13 +-
 net/ceph/osdmap.c                                  |    16 +-
 net/core/gro.c                                     |     4 +
 net/core/gso.c                                     |     1 +
 net/core/skbuff.c                                  |    15 +-
 net/ipv4/af_inet.c                                 |     3 +
 net/ipv4/inet_connection_sock.c                    |    16 +-
 net/ipv4/inet_hashtables.c                         |     5 +-
 net/ipv4/ip_gre.c                                  |    42 +-
 net/ipv4/ipmr.c                                    |     1 +
 net/ipv4/metrics.c                                 |     5 +
 net/ipv4/netfilter/nf_nat_h323.c                   |    22 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |    11 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |     2 +-
 net/ipv4/syncookies.c                              |     2 +
 net/ipv4/sysctl_net_ipv4.c                         |     2 +
 net/ipv4/tcp_cong.c                                |     4 +-
 net/ipv4/tcp_input.c                               |     4 +-
 net/ipv4/tcp_output.c                              |     2 +-
 net/ipv6/addrconf.c                                |    46 +-
 net/ipv6/inet6_hashtables.c                        |     4 +-
 net/ipv6/ip6_gre.c                                 |     5 +-
 net/ipv6/ip6_offload.c                             |     4 +
 net/ipv6/netfilter/nf_reject_ipv6.c                |    13 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |     2 +-
 net/ipv6/reassembly.c                              |     1 +
 net/ipv6/route.c                                   |     2 +-
 net/ipv6/udp.c                                     |    13 +
 net/mac80211/ibss.c                                |     4 +-
 net/mptcp/protocol.c                               |     9 +-
 net/mptcp/subflow.c                                |    35 +-
 net/netfilter/nf_conntrack_expect.c                |    35 +-
 net/netfilter/nf_conntrack_netlink.c               |     8 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |     6 +-
 net/netfilter/nf_nat_sip.c                         |    20 +-
 net/netfilter/nft_meta.c                           |     6 +-
 net/netfilter/nft_rt.c                             |     6 +-
 net/netfilter/nft_xfrm.c                           |     9 +-
 net/packet/af_packet.c                             |    12 +-
 net/rds/ib_cm.c                                    |     6 +-
 net/rds/ib_rdma.c                                  |     4 +-
 net/rds/ib_recv.c                                  |    13 +-
 net/rds/message.c                                  |    26 +
 net/rds/rdma.c                                     |    63 +-
 net/rds/rds.h                                      |    15 +-
 net/rds/send.c                                     |    18 +-
 net/rxrpc/recvmsg.c                                |    22 +-
 net/rxrpc/rxperf.c                                 |    16 +-
 net/sched/act_ct.c                                 |     5 +-
 net/sched/act_ife.c                                |     4 +
 net/sched/cls_bpf.c                                |    28 +-
 net/sched/cls_flower.c                             |    50 +-
 net/sched/sch_generic.c                            |    10 +-
 net/sched/sch_teql.c                               |    60 +-
 net/sctp/associola.c                               |     4 +
 net/sctp/endpointola.c                             |     4 +
 net/sctp/socket.c                                  |    26 +-
 net/smc/smc_tx.c                                   |     7 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |    29 +-
 net/sunrpc/svc.c                                   |     9 +-
 net/sunrpc/svc_xprt.c                              |    24 +-
 net/sunrpc/svcauth_unix.c                          |     7 +
 net/sunrpc/svcsock.c                               |    86 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |    27 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |     3 +-
 net/sunrpc/xprtrdma/verbs.c                        |     9 +-
 net/tipc/group.c                                   |    19 +-
 net/tipc/socket.c                                  |    12 +-
 net/unix/sysctl_net_unix.c                         |     4 +-
 net/vmw_vsock/vmci_transport.c                     |    34 +-
 net/wireless/nl80211.c                             |     4 +
 net/xdp/xsk_buff_pool.c                            |     2 +
 net/xdp/xsk_queue.c                                |    12 +-
 rust/bindings/lib.rs                               |     1 +
 rust/kernel/block/mq/gen_disk.rs                   |    10 +-
 rust/uapi/lib.rs                                   |     1 +
 scripts/kconfig/conf.c                             |    17 +
 scripts/link-vmlinux.sh                            |    20 +-
 security/apparmor/include/label.h                  |     6 +-
 security/apparmor/include/policy_ns.h              |    16 +
 security/apparmor/label.c                          |     1 -
 security/apparmor/mount.c                          |     4 +-
 security/apparmor/policy.c                         |    16 +
 security/apparmor/policy_ns.c                      |     2 +-
 security/landlock/fs.c                             |    10 +-
 sound/core/compress_offload.c                      |    28 +-
 sound/core/control.c                               |     2 +
 sound/core/init.c                                  |    12 +-
 sound/core/seq/oss/seq_oss_device.h                |     1 +
 sound/core/seq/oss/seq_oss_event.c                 |     3 +
 sound/core/seq/oss/seq_oss_init.c                  |     2 +
 sound/core/ump_convert.c                           |     2 +-
 sound/drivers/aloop.c                              |    11 +-
 sound/drivers/pcmtest.c                            |    42 +-
 sound/mips/sgio2audio.c                            |    13 +-
 sound/oss/dmasound/dmasound_q40.c                  |    65 +-
 sound/pci/cs46xx/dsp_spos.c                        |     2 +-
 sound/pci/hda/hda_codec.c                          |    12 +
 sound/pci/hda/hda_intel.c                          |     9 +
 sound/pci/hda/hda_sysfs.c                          |     4 +
 sound/pci/hda/patch_conexant.c                     |    17 +-
 sound/pci/hda/patch_realtek.c                      |    98 +-
 sound/pci/hda/patch_via.c                          |     1 +
 sound/soc/amd/acp-config.c                         |    14 +
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |     8 +
 sound/soc/amd/ps/pci-ps.c                          |     2 +
 sound/soc/amd/yc/acp6x-mach.c                      |    21 +
 sound/soc/codecs/arizona-jack.c                    |     1 +
 sound/soc/codecs/hdac_hda.c                        |    16 +
 sound/soc/codecs/hdac_hdmi.c                       |    10 +-
 sound/soc/codecs/lpass-wsa-macro.c                 |    42 +-
 sound/soc/codecs/max98396.c                        |    24 +-
 sound/soc/codecs/max98926.c                        |     2 +-
 sound/soc/codecs/pcm6240.c                         |     2 -
 sound/soc/codecs/rt5682s.c                         |     4 +-
 sound/soc/codecs/rt712-sdca-dmic.c                 |     4 +-
 sound/soc/codecs/rt712-sdca.c                      |     1 +
 sound/soc/codecs/rt712-sdca.h                      |     1 +
 sound/soc/codecs/sma1303.c                         |     2 +
 sound/soc/codecs/tlv320aic26.c                     |     6 +
 sound/soc/codecs/tlv320aic32x4-clk.c               |     8 +-
 sound/soc/codecs/wcd9335.c                         |    25 +-
 sound/soc/codecs/wm8994.c                          |     3 +
 sound/soc/codecs/wsa884x.c                         |    11 +-
 sound/soc/intel/atom/sst/sst_acpi.c                |    14 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |    17 +
 sound/soc/qcom/qdsp6/q6afe.c                       |    10 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |     1 +
 sound/soc/sdw_utils/soc_sdw_rt711.c                |     1 +
 sound/soc/sof/intel/mtl.c                          |    23 +
 sound/soc/ti/davinci-mcasp.c                       |     1 +
 sound/synth/emux/emux.c                            |    10 +-
 sound/synth/emux/soundfont.c                       |     9 +
 sound/usb/line6/pcm.c                              |     8 +
 sound/usb/mixer_maps.c                             |    27 +
 sound/usb/pcm.c                                    |     3 +-
 sound/usb/quirks-table.h                           |    22 +
 sound/usb/quirks.c                                 |     2 +
 sound/usb/usx2y/usbusx2yaudio.c                    |     1 -
 tools/lib/api/fd/array.c                           |     5 +-
 tools/lib/bpf/libbpf.c                             |    10 +-
 tools/lib/bpf/ringbuf.c                            |     2 +-
 tools/lib/thermal/include/thermal.h                |     4 +-
 tools/objtool/check.c                              |     1 +
 tools/perf/arch/loongarch/util/header.c            |     2 +-
 tools/sched_ext/scx_flatcg.bpf.c                   |     3 +
 tools/testing/selftests/core/unshare_test.c        |    19 +-
 tools/testing/selftests/ftrace/ftracetest          |     3 +
 tools/testing/selftests/net/fin_ack_lat.c          |     2 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c   |    24 +
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   179 +
 virt/kvm/guest_memfd.c                             |     8 +-
 virt/kvm/kvm_main.c                                |    31 +-
 1298 files changed, 89658 insertions(+), 5679 deletions(-)


