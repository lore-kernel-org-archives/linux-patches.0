Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795154640;
	b=PCEfzl7sz6D0sbnWCaVdVJilyQEMraWGBKbeU00H8bTOmNcsBXj0XN5nFBHj9IFgt7qX
	 J5tYuyqdY7ShySklLP8XQTP1icxqfXrGAAp9fKvUf3vNBhZIYG917kIhZCrnUAYiWd9qZ
	 3sSvfCUo7wZ6rCT19tpWAisEgS3tP7O2qliKEOU3vtM+V0HLK4mxjTD2zxZ9AR7DqGBGy
	 RD3Mbh9qs37zbKRGBYg56DoOo1z+1MHuCwoe1A9M2BzvmktcvvDb+kwf4xENXK+s+WSBZ
	 8dAdzqsSia2QlKDvz83dKpxv02Eppns8nRt3/Ew9pELWFYEBERGAVVG9Yb0ZBsikPGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=aaVMvVz+rdDjIVfzCiKF9WHLHpAbjACZWd9qDkVWlVg=;
	b=CsGQh+nZgioTQ55YMGE0AmB9hIv3qp+xxDdtDYwVRLNxdu/X1TNt5A9EPEO2EEcZPlFX
	 HSOImuxetE3d1iTmesoqMCbz5uGvBR+lnEyJOIDGSt8hdZFvC5OlITf4eIA3LKP8if75b
	 1FjaCjVnSmIHo3eMNS/yczU40ZYuEWQvv6ylJjmzO3Cr/ppSnrYAkS3Kibqa7fW1gRZWc
	 ZCSuh2oXw/HXy+4x5QU3ELU0hFvlM7Hel44xAu8sjM7pZBnqgQX5RlLJv0pAsqO4/57Lm
	 gLNqvf3rEj3kN6zznXLzO3nXKbYBvmzycm/e1VWURvQIc9fkVONpPo8wJNmyL3f5SeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsBz4FK2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE8360A260D;
	Fri, 20 Nov 2026 06:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsBz4FK2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD23C1F000CF;
	Fri, 20 Nov 2026 06:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795154640;
	bh=aaVMvVz+rdDjIVfzCiKF9WHLHpAbjACZWd9qDkVWlVg=;
	h=From:To:Cc:Subject:Date;
	b=dsBz4FK2caq96cUSC89H+4lWQ9HfMgLG/gCOGtR3Ii81VmyuDwVYf5DeEeTbKYTJj
	 2cBrEHR9/x8lbHPasVu55yLY7QZEsopCDGEzzobwxQXtLqr+USr3g2gKm3jd+DqyCB
	 F0Y8Bn1RQqQbM6cML/PlsZos7NQXIkwSeiTq67p8=
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
Subject: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Date: Fri, 20 Nov 2026 06:58:20 +0100
Message-ID: <20261120055248.913352689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.3.6-rc2
X-KernelTest-Deadline: 2026-11-22T05:54+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.3.6 release.
There are 2642 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.3.6-rc2

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix race when restoring reset state in perfcnt

Brian Norris <briannorris@chromium.org>
    PM: runtime: Only queue an idle check for RPM-linked suppliers (part 2)

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    nvmet-auth: reject incomplete DHCHAP messages

Christoph Hellwig <hch@lst.de>
    zloop: fix block size query

Sasha Levin <sashal@kernel.org>
    rust: bindings: derive Zeroable for bindgen's opaque array wrappers

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: avoid READ_ONCE() on a kgid_t in kernfs_new_node()

Zhan Xusheng <zhanxusheng@xiaomi.com>
    erofs: fix disallowing superblock_share if device= is set

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct a typo in UMC404HD model comment

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: Fix additional sense code definition

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Decouple acpi_index from the optional device name element

Linus Torvalds <torvalds@linux-foundation.org>
    vdpa_sim: disable page faults around vringh_need_notify_iotlb()

Stian Halseth <stian@itx.no>
    sched/cputime: Don't warn when the tick period starts after idle exit

Imre Kaloz <kaloz@kernel.org>
    rtc: ds1685: do not sleep in the power-off handler

Imre Kaloz <kaloz@kernel.org>
    rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is set

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    minix: reject rmdir of a directory with a corrupted link count

Nickolai Zeldovich <nickolai@csail.mit.edu>
    fs_pin: do not trust the pin after a spurious wakeup in pin_kill()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    ucount: read the parent ucounts before dropping the rlimit count

Nickolai Zeldovich <nickolai@csail.mit.edu>
    splice: retry tee() instead of returning 0 when it races

Nickolai Zeldovich <nickolai@csail.mit.edu>
    pidfs: do not report fields that do not fit into the caller's struct

Zhiyu Zhang <zhiyuzhang999@gmail.com>
    watch_queue: keep info_id separate from rcu_head

Qu Wenruo <wqu@suse.com>
    iomap: only follow dio alignment requirement if specified

Xiao Liang <shaw.leon@gmail.com>
    tun: drop batched packets while the device is down

John Johansen <john.johansen@canonical.com>
    apparmor: advertise that sctp is being mediated

Jhonata Poma-Hansen <jhonata.poma@gmail.com>
    netlink: check sk_rcvbuf before charging the dump skb

Eric Dumazet <edumazet@kernel.org>
    openvswitch: use eth_type_trans_careful() in internal_dev_recv()

Eric Dumazet <edumazet@kernel.org>
    net: use eth_type_trans_careful() in __dev_forward_skb2()

Eric Dumazet <edumazet@kernel.org>
    loopback: use eth_type_trans_careful()

Eric Dumazet <edumazet@kernel.org>
    net: add eth_type_trans_careful()

Kyle Zeng <kylebot@openai.com>
    tcp: initialize mapped children before route lookup

John Johansen <john.johansen@canonical.com>
    apparmor: fix check SCTP bind, and connect permission checks

Kyle Zeng <kylebot@openai.com>
    tcp: avoid double destroy in tcp_abort() of an unaccepted child

Rosen Penev <rosenp@gmail.com>
    net: bgmac: fix TX DMA unmapping and slot cleanup

Kyle Zeng <kylebot@openai.com>
    gro: do not GRO GSO packets with inconsistent payload

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: hand XDP frags over to the copybreak skb

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: free XDP frags when xdp_do_redirect() fails

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: don't leak buffers when XDP agg buffer allocation fails

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: resize Rx head buffers when rx-copybreak changes

Jakub Kicinski <kuba@kernel.org>
    eth: bnxt: recycle agg buffers when Rx head buffer allocation fails

Naman Gulati <namangulati@google.com>
    netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    apparmor: check connect permission for SCTP

Wentao Liang <vulab@iscas.ac.cn>
    apparmor: Fix namespace reference leak in __aa_find_or_create_ns()

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: convert duplicated dfa transitions to match_char()

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: fix table_size() integer overflow on 32 bit

Christoph Hellwig <hch@lst.de>
    zloop: check that the zone backing file support ->{read,write}_iter

Christoph Hellwig <hch@lst.de>
    zloop: fput file after failed zone init

Christoph Hellwig <hch@lst.de>
    zloop: share more code for opening a zone backing file

Christoph Hellwig <hch@lst.de>
    zloop: remove a duplicate call to zloop_get_block_size

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: report a label allocation failure as -ENOMEM

Maxime Bélair <maxime.belair@canonical.com>
    apparmor: fix a leak on a rejected string table entry

John Johansen <john.johansen@canonical.com>
    apparmor: remove unconfined_profile() check in inet socket mediation

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    apparmor: check address length before reading AF_UNSPEC bind address

shaos <shawnq1@163.com>
    apparmor: mediate AF_UNSPEC socket disconnects

Jamie Nguyen <jamien@nvidia.com>
    selftests: net: txtimestamp: fix out-of-bounds read in raw UDP checksum

Kunhai Dai <daikunhai@didiglobal.com>
    blk-iocost: publish hweights as one atomic value

Chris Mason <mason@kernel.org>
    rnbd-srv: publish the sess_dev at the end of OPEN

Chris Mason <mason@kernel.org>
    rnbd-srv: fix use-after-free on two CLOSE messages

Josef Bacik <josef@toxicpanda.com>
    block/rnbd-srv: drop the sess_dev kobject unlocked

Josef Bacik <josef@toxicpanda.com>
    block/rnbd-srv: don't free the device on a sysfs error

Josef Bacik <josef@toxicpanda.com>
    drbd: take req_lock to skip the initial sync as peer

Josef Bacik <josef@toxicpanda.com>
    drbd: stop the start_resync timer of a dying device

Josef Bacik <josef@toxicpanda.com>
    block: apply the segment size to the integrity buffer

Josef Bacik <josef@toxicpanda.com>
    blk-mq: free the bitmaps of tags in the SRCU callback

Josef Bacik <josef@toxicpanda.com>
    block: partitions/mac: compute the sectors in 64 bits

Josef Bacik <josef@toxicpanda.com>
    blk-mq: set up a queue under tag_list_lock

Josef Bacik <josef@toxicpanda.com>
    blk-mq: exit the hctxs of a queue under tag_list_lock

Josef Bacik <josef@toxicpanda.com>
    blk-mq: quiesce a queue that joins a quiesced tag set

Josef Bacik <josef@toxicpanda.com>
    blk-mq-dma: initialize the dma state for P2P, too

Josef Bacik <josef@toxicpanda.com>
    blk-mq: don't forget a timer the driver has restarted

Josef Bacik <josef@toxicpanda.com>
    blk-mq: don't bring back flags of a completed request

Josef Bacik <josef@toxicpanda.com>
    blk-mq: keep sharing tags fairly after a queue update

Josef Bacik <josef@toxicpanda.com>
    blk-mq: don't trust the cookie in blk_mq_poll()

Josef Bacik <josef@toxicpanda.com>
    block: don't lose the status of a failed flush request

Josef Bacik <josef@toxicpanda.com>
    block: fix use-after-free of the disk in sync_bdevs()

Josef Bacik <josef@toxicpanda.com>
    namei: don't assert S_ISDIR on a stale rcu-walk inode

Amir Goldstein <amir73il@gmail.com>
    selftests/ovl: fix detached layer mountinfo expectations

Dominik Maier <dmnk@google.com>
    xattr: always invoke cap_convert_nscap() for security.capability writes

Sasha Levin <sashal@kernel.org>
    ASoC: SOF: Intel: hda: Stop the controller before freeing its DMA buffers

Josef Bacik <josef@toxicpanda.com>
    fork: Let nobody keep a task that may not come to life

Nicolai Buchwitz <nb@tipi-net.de>
    octeontx2-pf: pass the skb to otx2_dma_unmap_skb_frags()

Nicolai Buchwitz <nb@tipi-net.de>
    octeontx2-pf: fix skb use-after-free on ipsec transmit drop

Markus Probst <markus.probst@posteo.de>
    rtc: s35390a: Read 24-hour mode on access

Markus Probst <markus.probst@posteo.de>
    rtc: s35390a: Fix alarm not disabling

Markus Probst <markus.probst@posteo.de>
    rtc: s35390a: Add missing newline to dev_err

Joas Antonio dos Santos <joasantonio108@gmail.com>
    net: mctp: free reassembly head skb when key_add fails on SOM

Josef Bacik <josef@toxicpanda.com>
    writeback: don't kick a missing wb for dontcache writes

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Only set num_doorbells on a fully initialized SF

Linkui Xiao <xiaolinkui@kylinos.cn>
    net: bridge: netlink: do not clear the vlan info dump error

Karol Kolacinski <karol.kolacinski@intel.com>
    ice: E822: keep Tx timestamps disabled during offset calibration

Jacob Keller <jacob.e.keller@intel.com>
    ice: set in_use only after preparing Tx timestamp index

Jacob Keller <jacob.e.keller@intel.com>
    ice: use reference counting and SRCU for PTP port access

Dharmender Garg <dharmender.garg@broadcom.com>
    bnge: fix RSS table sizing for large RX ring counts

Dharmender Garg <dharmender.garg@broadcom.com>
    bnge: cap RSS contexts and RX rings to the RSS table size

Eric Dumazet <edumazet@kernel.org>
    ppp: linearize and segment bridged packets when required

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Protect multiple routes insertion by table lock.

Chuck Lever <cel@kernel.org>
    tls: Honor O_NONBLOCK in tls_sw_splice_read()

Joas Antonio dos Santos <joasantonio108@gmail.com>
    net: dcb: initialize PFC value before calling getpfccfg

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: restore the Tx coalescing setting when the rings are rebuilt

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: recover from a failed resume

Josef Bacik <josef@toxicpanda.com>
    block: don't enter reclaim under rq_qos_mutex

Josef Bacik <josef@toxicpanda.com>
    blk-throttle: make blkio.reset_stats reset I/O counts

Josef Bacik <josef@toxicpanda.com>
    blk-throttle: pass the I/O counts of a dead group on

Josef Bacik <josef@toxicpanda.com>
    blk-iolatency: flush enable_work after going offline

Josef Bacik <josef@toxicpanda.com>
    blk-cgroup: don't free a blkg with its punt work queued

Josef Bacik <josef@toxicpanda.com>
    blk-cgroup: fix root io.stat byte counts on 32-bit

Josef Bacik <josef@toxicpanda.com>
    blk-throttle: don't truncate the cgroup v1 iops limits

Josef Bacik <josef@toxicpanda.com>
    blk-iocost: free struct ioc after a grace period

Josef Bacik <josef@toxicpanda.com>
    blk-cgroup: keep the old blkg while reassociating a bio

Chris Mason <mason@kernel.org>
    nvmet: don't clear sq->ctrl for a Connect with sqsize 0

Chris Mason <mason@kernel.org>
    nvmet-rdma: fix double puts after a failed RDMA WRITE

Chris Mason <mason@kernel.org>
    nvmet-rdma: disable interrupts under rsp_wr_wait_lock

Chris Mason <mason@kernel.org>
    nvmet-rdma: flush nvmet-wq on module exit

Josef Bacik <josef@toxicpanda.com>
    nvme-loop: don't BUG() if a scan runs beside a reset

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: don't read a removed port at Connect time

Josef Bacik <josef@toxicpanda.com>
    nvmet: fix NULL dereference in debugfs host_traddr

Josef Bacik <josef@toxicpanda.com>
    nvmet-tcp: stop listening when a port is removed

Josef Bacik <josef@toxicpanda.com>
    nvmet: fix NULL dereference of PCI endpoint targets

Josef Bacik <josef@toxicpanda.com>
    nvmet-auth: take only AUTH_Negotiate for a negotiation

Josef Bacik <josef@toxicpanda.com>
    nvmet: don't truncate the length of big discards

Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
    kdb: unify CMD_BUFLEN definition into kdb_private.h

Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
    kdb: fix memory leak in kdb_setenv() when environment is full

Surabhi Gogte <sgogte@purestorage.com>
    nvme-tcp: refactor I/O queue setup path

Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
    nvme-rdma: fix NULL metadata_sgl dereference with T10-PI

Rongzheng Wang <testwrzwrz@gmail.com>
    nvmet: use the enabled transport when disabling a port

Qing Zhang <diasyzhang@tencent.com>
    nvmet: protect nvmet_ports_list with nvmet_config_sem

Maurizio Lombardi <mlombard@redhat.com>
    nvme-pci: fix early boot hang with nvme.quirks parameter

Avi Weiss <thnkslprpt@gmail.com>
    nvmet: prevent double-free after metadata SGL allocation failure

Andrea Parri <parri.andrea@gmail.com>
    nvmet: zns: reject a NUMD whose byte count wraps

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: xilinx: formatter_pcm: Fix read-modify-write of AUD_CTRL in hw_params

Sicong Huang <congei42@163.com>
    nfp: flower: fix use-after-free in neighbour update work

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return complete and aligned stream information

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: keep TX and RX hardware offload on the same device

Peter Morrow <pdmorrow@gmail.com>
    net/mlx4: always create the eth and ib auxiliary devices

Slawomir Stepien <sst@poczta.fm>
    fs/ntfs3: handle partial allocation in attr_data_get_block_locked()

Yun Zhou <yun.zhou@windriver.com>
    ntfs3: release ni_lock before dir_emit in ntfs_readdir to fix deadlocks

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: take ni_lock() once in ntfs_readdir()

Feng Yang <yangfeng@kylinos.cn>
    bpf: Fix out-of-bounds btf->types write for split BTF

Alexei Starovoitov <ast@kernel.org>
    bpf: Keep stack arguments in arch_bpf_timed_may_goto()

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Remap BPF_REG_0 and RV_REG_TCC

Chen Pei <cp0613@linux.alibaba.com>
    selftests/bpf: Enable arena LDSX tests for riscv64

Ömer Mete Kaya <omermetekaya0@gmail.com>
    usbnet: fix EVENT_RX_PAUSED race in usbnet_skb_return()

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: mv88e6xxx: fix 88E6171 statistics type

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: mv88e6xxx: fix 6351 family statistics snapshot

Daniel Machon <daniel.machon@microchip.com>
    net: lan966x: don't disable hardirqs in fdma tx clear path

Zhewei Yuan <yzwlhm@gmail.com>
    tcp: Fix fastreuse cache initialization on first bind

Wang Zhaolong <wangzhaolong3@outlook.com>
    ksmbd: fix named-pipe reply loss with small output buffers

Wang Zhaolong <wangzhaolong3@outlook.com>
    ksmbd: avoid races between named-pipe operations

Fernando Fernandez Mancera <fmancera@suse.de>
    devlink: region: fix snapshot id leak on kernel-allocated ids

Dudu Lu <phx0fer@gmail.com>
    net-sysfs: reject a one-entry RPS flow table

Daniel Machon <daniel.machon@microchip.com>
    net: microchip: fdma: fix DCB corruption under sustained load

Daniel Machon <daniel.machon@microchip.com>
    net: microchip: fdma: use little-endian types for descriptor fields

Daniel Machon <daniel.machon@microchip.com>
    net: lan966x: release the in-flight slot of a stale TX skb

Daniel Machon <daniel.machon@microchip.com>
    net: lan966x: fix the DB dataptr of frames from ndo_xdp_xmit

Harkirat Gill <harkirat.gill@amd.com>
    drm/amdgpu: re-enable GFXOFF for compute on GFX12

Florian Fainelli <florian.fainelli@broadcom.com>
    perf parse-events: Include errno.h before kernel headers

Florian Fainelli <florian.fainelli@broadcom.com>
    perf print_insn: Include sys/types.h for ssize_t

Paul Moses <p@1g4.org>
    perf mmap: Preserve the consumed cursor in forward mode

Paul Moses <p@1g4.org>
    perf mmap: Use the head selected by read_init

Ian Rogers <irogers@google.com>
    perf libdw: Optimize fallback logic for missing DWARF

Tejun Heo <tj@kernel.org>
    sched_ext: Reject scx_bpf_sub_grant/revoke() in tracing programs

Tejun Heo <tj@kernel.org>
    sched_ext: Fix a lone IMMED task waiting behind a kept prev

Tejun Heo <tj@kernel.org>
    sched_ext: Fix queued bypassed tasks stalling when the host loses SCX_CAP_BASE

Tejun Heo <tj@kernel.org>
    sched_ext: Let the bypass load balancer move tasks homed on other cpus

Tejun Heo <tj@kernel.org>
    sched_ext: Factor out bypass_lb_move() and insert with the donor DSQ unlocked

Tejun Heo <tj@kernel.org>
    sched_ext: Add ops.sub_child_ecaps_updated() to report a child's effective cap changes

Tejun Heo <tj@kernel.org>
    sched_ext: Add ops.sub_cid_sched_updated() to report the sched running on a cid

Andrea Righi <arighi@nvidia.com>
    sched_ext: Fix ops.running/stopping() pairing for proxy-exec donors

Andrea Righi <arighi@nvidia.com>
    sched: Add sched_ext hooks for proxy execution

Shubhang Kaushik (Ampere) <sh@gentwo.org>
    sched: Restart fair hrtick after same-task repicks

Tejun Heo <tj@kernel.org>
    sched_ext: Fix the bypass load balancer stranding tasks on cpus where the host lacks SCX_CAP_BASE

Tejun Heo <tj@kernel.org>
    sched_ext: Fix rescue served time disagreeing with the slice under proxy execution

Tejun Heo <tj@kernel.org>
    sched_ext: Fix bypassed tasks looping on a host without SCX_CAP_ENQ

Mani Tofigh <mt4022@columbia.edu>
    bpf: Fix bpf_timer callback running on a freed map

Len Brown <len.brown@intel.com>
    x86_energy_perf_policy: Cleanup: Check fseek() in VM path

Len Brown <len.brown@intel.com>
    x86_energy_perf_policy: Fix optarg keyword matching

Junbin Zhang <sprooc69@gmail.com>
    sched_ext: Reject rq-lock-taking kfuncs in tracing programs

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    LoongArch: BPF: Fix stack arguments for indirect trampolines

Zhenxian Ma <mzx199711@gmail.com>
    block: fix recursive i_rwsem locking in blkdev_write_iter()

Daniel Machon <daniel.machon@microchip.com>
    net: lan966x: do not warn on MAC entries that are not port destined

Daniel Machon <daniel.machon@microchip.com>
    net: lan966x: do not inject uninitialised bytes past skb->len

Dudu Lu <phx0fer@gmail.com>
    net: xps: bound the cleanup loop by the old map's num_tc

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: wait for RCU readers before reusing a socket

Hannes Laimer <h.laimer@proxmox.com>
    vxlan: keep reserved_bits across changelink

Allison Henderson <achender@kernel.org>
    net/rds: do not initialize transports after rds_init() failed

Allison Henderson <achender@kernel.org>
    net/rds: do not fail init when CONFIG_SYSCTL=n

Tao Gong <gongtao0607@gmail.com>
    net: dsa: mt7530: trap frames to conduit in MFC on EN7581 and AN7583

Ian Bridges <icb@fastmail.org>
    ksmbd: fix SMB2 CREATE response buffer overflow in compound requests

Cheng Yongkang <teel4res@gmail.com>
    net: tun: hold napi_mutex when deleting NAPI in tun_detach_all()

Denis Kulikov <dar1knessx@gmail.com>
    ksmbd: use the resolved share path for the share root

Gao Xiang <xiang@kernel.org>
    erofs: drop unnecessary .read_folio() checks for file-backed mounts

Giuseppe Scrivano <giuseppe@scrivano.org>
    erofs: reuse superblock for file-backed mounts

Giuseppe Scrivano <giuseppe@scrivano.org>
    fs: rename vfs_get_super() to get_tree_super() and export it

Sally Marcher <me@gry.sh>
    ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II

HyeongJun An <sammiee5311@gmail.com>
    ALSA: pcmtest: Honor the enable parameter

Nicolai Buchwitz <nb@tipi-net.de>
    net: usb: cdc_mbim: don't enable BHs in tx_fixup under netpoll

Nicolai Buchwitz <nb@tipi-net.de>
    net: usb: cdc_ncm: don't enable BHs in tx_fixup under netpoll

Binbin Deng <18983559317@163.com>
    net: atlantic: Unregister before clearing RXNFC rules

Paolo Abeni <pabeni@redhat.com>
    gtp: hold RCU in gtp_genl_send_echo_req()

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: drop discovery frames with no MAC header

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix refcount panic in tipc_rcv() when receiving shared skb

Jerome Brunet <jbrunet@baylibre.com>
    clk: cdce925: Size the PLL child name buffer for any int

Gabriel Fernandez <gabriel.fernandez@foss.st.com>
    clk: stm32: fix clock array size for STM32MP21

bui duc phuc <phucduc.bui@gmail.com>
    clk: lmk04832: Handle reset GPIO lookup errors

Eric Dumazet <edumazet@kernel.org>
    ipmr: clear skb->cb[] in reg_vif_xmit()

Eric Dumazet <edumazet@kernel.org>
    net: harden qdisc_pkt_len_segs_init() against malicious GSO packets

alex todadze <todadzealexi19@proton.me>
    net: stmmac: fix rx checksum offload with extended descriptors

Dudu Lu <phx0fer@gmail.com>
    net/sched: taprio: unwind the netdevice notifier if register_qdisc() fails

Alexandre Cassen <acassen@corp.free.fr>
    net/sched: act_api: inherit filter offload flags only on new actions

Prashant Sengar <prashantsengar25031@gmail.com>
    net: usb: lan78xx: avoid NULL PHY dereference in WoL setup

Dudu Lu <phx0fer@gmail.com>
    net/sched: gred: keep the qdisc lock while updating the table

Zhang Yi <zhangyi@everest-semi.com>
    ASoC: codecs: es*: Modify the maximum value of DMIC_GAIN

Zhang Yi <zhangyi@everest-semi.com>
    ASoC: codecs: es*: Modify the registers related to ALC RECOVERY

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: codecs: wsa881x: Fix shared powerdown GPIO handling

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    ASoC: codecs: wsa883x: Fix VI sense port channel count

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    ASoC: codecs: wsa884x: Fix VI sense port channel count

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wsa883x: disable runtime PM on unbind

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wsa884x: disable runtime PM on unbind

Hungyu Lin <dennylin0707@gmail.com>
    thermal: Fix CPU mask truncation in power limit trace event

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    PM: suspend: Do not call suspend_ops->begin()/end() for s2idle

Sasha Levin <sashal@kernel.org>
    selftests/thermal: allow cross builds of the Intel tests

Jérémie Rodon <jeremie.rodon@gmail.com>
    spi: cs42l43: Add speaker ID quirk for Dell XPS 13 DX13260 SKU 0E54

TJ Adams <tadamsjr@google.com>
    block: advance iterator after copy-in for SG_DXFER_TO_FROM_DEV

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Release invalid isolated CPUs with a shrunk root partition parent

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Release invalid isolated CPUs in compute_partition_effective_cpumask()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only called for valid partition

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix incorrect effective_cpus bug in update_cpumasks_hier()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Properly compute effective xcpus in update_parent_effective_cpumask()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Don't allow a child root partition under an isolated parent

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Find furthest isolated ancestor for invalidated isolated partition

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    libceph: reject bad connect_seq in msgr1 READY reply

Yogesh Gaur <yogeshgaur.83@gmail.com>
    ceph: don't keep a mon_addr string that failed to parse

Xiang Mei <xmei5@asu.edu>
    ceph: fix off-by-one NUL termination in decode_encrypted_symlink()

Tal Zussman <tz2294@columbia.edu>
    ceph: don't clear write_congested when collecting folios

Tal Zussman <tz2294@columbia.edu>
    ceph: fix writeback_count leak when a bounce page allocation fails

Tal Zussman <tz2294@columbia.edu>
    ceph: wait for pending fscache write in write_folio_nounlock()

Tal Zussman <tz2294@columbia.edu>
    ceph: fix error handling when the OSD client is stopping in ceph_submit_write()

Alex Markuze <amarkuze@redhat.com>
    ceph: fix page vector leak on encrypted netfs read EIO path

Xiubo Li <xiubo.li@clyso.com>
    ceph: mark the superblock active after mounting

Max Kellermann <max.kellermann@ionos.com>
    ceph: remove unused field `i_cap_migration_resv`

Henry Martin <bsdhenrymartin@gmail.com>
    netlink: fix out-of-bounds bitmap access clearing stale mc groups

HyeongJun An <sammiee5311@gmail.com>
    ALSA: pcmtest: Reject invalid fill_mode values

Weiming Shi <bestswngs@gmail.com>
    bpf: Validate stack arg reads against caller state

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    vdso/gettimeofday: Correct the read of tz_minuteswest and tz_dsttime

Hui Su <sh_def@163.com>
    sched/idle: Use hrtimer cleanup class in play_idle_precise()

Hui Su <sh_def@163.com>
    hrtimer: Add cleanup class for on-stack timers

Avi Weiss <thnkslprpt@gmail.com>
    kthread: Fall back when no preferred housekeeping CPU is online

Cen Zhang <zzzccc427@gmail.com>
    ALSA: ump: Drain sequencer callbacks before freeing their client

Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
    bpf: Track borrowed iterator results by default

Dimitris Charisis <dchar@cslab.ece.ntua.gr>
    maple_tree: fix maple_range_64 crashes in RCU mode

Liam R. Howlett (Google) <liam@infradead.org>
    tools/testing/shared: catch a failed posix_memalign()

Ren Tamura <ren.tamura.oss@gmail.com>
    tools/cgroup: sum shrinker object counts across NUMA nodes

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    ALSA: us122l: mark hwdep mappings VM_MIXEDMAP

Pooyan Azad <pooyan.azadparvar@gmail.com>
    zram: fix short reads from block_state

Ting-Han Hou <ue081723@gmail.com>
    scripts/gdb: fix stack depot out-of-bounds diagnostic

Ting-Han Hou <ue081723@gmail.com>
    scripts/gdb: fix radix tree lookup pointer handling

Avi Weiss <thnkslprpt@gmail.com>
    profiling: fix sampling step on 64-bit big-endian systems

Edward Adam Davis <eadavis@sina.com>
    kernel/reboot: avoid potential deadlocks during suspension

Aditya Sharma <adi.sharma@zohomail.in>
    bpf: Remove nmi_uaccess_okay() check in bpf_send_signal_common()

Ayushman Rout <ayushmanrout27@gmail.com>
    bpf: Use memmove() to load bytes from an skb and an xdp_buff

Feng Yang <yangfeng@kylinos.cn>
    bpf: Propagate btf_add_type() errors in btf_check_all_metas()

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Wait for the struct_ops map to be freed in assoc_in_timer

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Test freeing a struct_ops map under a running prog

Alexander Koskovich <akoskovich@pm.me>
    scsi: ufs: qcom: Power down UFS during system suspend on Milos

Haotian Zhang <vulab@iscas.ac.cn>
    scsi: elx: libefc: Fix resource leak in efcport_init() error path

Dudu Lu <phx0fer@gmail.com>
    net/sched: etf: initialise the sock_exterr_skb before filling it

Nandor Kracser <nandor@riptides.io>
    tls: avoid field-spanning write when copying crypto info

Greg Thelen <gthelen@google.com>
    selftests/net: tcp_mmap: remove unused -k option and keepflag

Allison Henderson <achender@kernel.org>
    net/rds: keep the connected peer's scope id apart from the bound one

Allison Henderson <achender@kernel.org>
    net/rds: include the scope id in the sendmsg connection cache check

Gal Pressman <gal@nvidia.com>
    net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: SHAMPO: Do not merge PSP packets

Eric Dumazet <edumazet@kernel.org>
    net: fix frag_list leak in skb_segment_list() error path

Jiayuan Chen <jiayuan.chen@linux.dev>
    tls: fix the open record check in the max payload size setsockopt

Hangbin Liu <liuhangbin@kylinos.cn>
    selftests: gro: remove unused variable total_data

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix tx DCB index drift in fdma xmit

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: do not read past skb->len when injecting a frame

Piotr Kubik <piotr@kubik.pl>
    net: pse-pd: si3474: validate the channels of a PI

Piotr Kubik <piotr@kubik.pl>
    net: pse-pd: si3474: keep detection enabled on the other PIs

Dimitri Daskalakis <daskald@meta.com>
    eth: fbnic: Correct packet header prefetch

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpts: fix support for PTP_EXTTS_REQUEST2 ioctl

Florian Fuchs <fuchsfl@gmail.com>
    ALSA: sh: aica: Fix spu_memset() stride

Gregory Price (Meta) <gourry@gourry.net>
    cgroup/cpuset: check effective mems for a movable-only configuration

Kaifeng Wang <kaifengw@google.com>
    tcp: reject devmem tx with fastopen and repair

Xingyuan Mo <hdthky0@gmail.com>
    sctp: reject forged cookie peer_addr with unknown address family

Jiale Yao <yaojiale02@163.com>
    regulator: irq: freeze deferred hardware access during suspend

Steven Rostedt <rostedt@goodmis.org>
    cpuidle: haltpoll: Only define guest_halt_poll_ns tracepoint when used

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: raven: Fix memory leak in acp3x_dma_close()

Lee Jia Jie <mkofdwu@gmail.com>
    perf: Fix UAF in attach_task_ctx_data()

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: select CRYPTO_AES

Ivan Hu <ivan.hu@canonical.com>
    ACPICA: Initialize parser_state.aml_end in acpi_install_method()

Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
    ACPI: platform_profile: Separate handler locking from sysfs lifetime

Nickolai Zeldovich <nickolai@csail.mit.edu>
    nsproxy: Fix cred leak in the error path of prepare_nsset()

Avi Weiss <thnkslprpt@gmail.com>
    signal: skip blocked signals in dequeue_synchronous_signal()

Karl Mehltretter <kmehltretter@gmail.com>
    fs: fix ramfs_fs_info leak when rootfs is unmounted

Christian Brauner <brauner@kernel.org>
    super: convert to plain hashtable

Karl Mehltretter <kmehltretter@gmail.com>
    netfs: Restore selective debug mask handling

Nickolai Zeldovich <nickolai@csail.mit.edu>
    nsfs: check the trailing bytes of a file handle in bytes, not words

Tianyi Chen <hi@tychen.cc>
    eventpoll: propagate wakeup source creation failure in ep_modify()

Nickolai Zeldovich <nickolai@csail.mit.edu>
    proc/kcore: advance the vmalloc retry by the last copy, not the total

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: follow AIF clock source changes in MCLK gating

Zhan Xusheng <zhanxusheng@xiaomi.com>
    ntfs: fix u16 truncation of the update sequence array count check

Hang Nan <2122295973@qq.com>
    ntfs: reject index blocks with a too small entries offset

Binbin Deng <18983559317@163.com>
    tipc: fix use-after-free of broadcast reception link at node release

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    gpiolib: Propagate emulated drive errors when setting arrays

Rand Deeb <rand.sec96@gmail.com>
    ata: libata-core: Ignore forced transfer modes the host does not support

Travis Howard <thoward@lafayetteinstrument.com>
    tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Stop asserting for RTNL when closing channels

Eric Dumazet <edumazet@kernel.org>
    net: shrink the payload-only part of skb dataref to one bit

Tianyi Gao <tianyi@cloudflare.com>
    veth: schedule the peer's NAPI after XDP_TX when only GRO is enabled

Daniel Machon <daniel.machon@microchip.com>
    net: lan969x: don't disable hardirqs in fdma tx clear

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: do not clobber the PSFP cycle timer update period

Daniel Machon <daniel.machon@microchip.com>
    net: lan969x: fix DSM calendar for empty taxis

Willem de Bruijn <willemb@google.com>
    virtio-net: fix frag overflow in big packets receive

Jijie Shao <shaojijie@huawei.com>
    net: hibmcge: set netdev_ops before hbg_init() to fix NULL pointer dereference

Eric Joyner <eric.joyner@amd.com>
    ionic: free port_info when probe fails after the port is set up

Nikhil P. Rao <nikhil.rao@amd.com>
    ionic: fix port_info use-after-free on firmware recovery

Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>
    mailbox: qcom-cpucp: read mbox hardware register using readq()

Ian Rogers <irogers@google.com>
    perf lock contention: Filter events before creating lock_stat

Hui Su <sh_def@163.com>
    sched_ext: Reject oversized automatic CID shards

Daniel Wagner <wagi@kernel.org>
    nvme-fabrics: clear the poll map if no poll queues are mapped

Daniel Wagner <wagi@kernel.org>
    nvme-fabrics: limit each queue type to the number of online CPUs

Daniel Wagner <wagi@kernel.org>
    nvme-fabrics: reset io_queues before computing the queue mapping

James Clark <james.clark@linaro.org>
    perf cs-etm: Don't add global v0 HW_IDs to unformatted queues

Namhyung Kim <namhyung@kernel.org>
    perf c2c: Fix memory leaks on output fields

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    PCI/pwrctrl: Power off child devices on power-on failure

Waldemar Brodkorb <wbx@openadk.org>
    sh: Select BINFMT_FLAT_NO_DATA_START_OFFSET for !MMU

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Time tc_edt from its first packet with data

Nicolás Antinori <nico.antinori.7@gmail.com>
    rust: i2c: remove TryFrom<&Device> implementation for &I2cClient

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: fix MCLK index used for setting MCLK rate

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: don't lose the AIF clock ratio when staying at 32kHz SYSCLK

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: fix MCLK gating for AIF clocks sourced from MCLK2

Ajanesh Lal <ajaneshlal3@gmail.com>
    ALSA: hda/realtek: Add mute and mic-mute LEDs for HP ENVY 16 (103c:8be5)

HyeongJun An <sammiee5311@gmail.com>
    selftests: ALSA: pcmtest: Compare all captured bytes in ni_capture

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, fix modify header pool match for copy actions

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, fix modify header pattern compare on big-endian

Anil Kaushik <anilkaushikwireless@gmail.com>
    gtp: hold RCU for the device lookup when adding a PDP context

Anil Kaushik <anilkaushikwireless@gmail.com>
    gtp: set a valid genl command in PDP context get and dump replies

HyeongJun An <sammiee5311@gmail.com>
    selftests: ALSA: pcmtest: Make room for the longest fill pattern

HyeongJun An <sammiee5311@gmail.com>
    selftests: ALSA: pcmtest: Check the frame count of each transfer

Takashi Iwai <tiwai@suse.de>
    platform/x86: ibm_rtl: Fix potential OOB read at signature search

Jiale Yao <yaojiale02@163.com>
    mshv_vtl: initialize poll file mutex before device registration

Shradha Gupta <shradhagupta@linux.microsoft.com>
    Drivers: hv: Run VMBus kexec cleanup from syscore shutdown

Shradha Gupta <shradhagupta@linux.microsoft.com>
    kexec: Add helper to report an active kexec reboot

Jiale Yao <yaojiale02@163.com>
    Drivers: hv: vmbus: Check ACPI companion before use

Sasha Levin <sashal@kernel.org>
    selftests/proc: proc-pid-vm: fix unused variable warning on non-x86

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: initialize status waiters before publishing them

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reserve xattr value tree metadata only once

Dmitry Antipov <dmantipov@yandex.ru>
    tcp_bpf: propagate error code in tcp_bpf_sendmsg()

Carolina Jubran <cjubran@nvidia.com>
    net: skbuff: don't copy alloc_cpu in skb header copies

Carlo Szelinsky <github@szelinsky.de>
    net: pse-pd: si3474: fix use-after-free in ancillary client error path

Michail Andreas Michalopoulos <mike.michalo@gmail.com>
    ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories

Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>
    ksmbd: reject foreign RPC pipe handles on IPC$ read and write

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix fd_limit accounting across durable reconnects

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: round SetAllocation to the advertised allocation unit

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: inherit FileIds in related compound requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: keep lease tables until their last lease is closed

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: don't WARN on an unexpected receive opcode

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix durable reconnects for root shares

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: cache the resolved share path for durable reconnects

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: disconnect on invalid encryption transform flags

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix trailing period in generated short names

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: print IPv6 client addresses correctly in procfs

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: fix AFP_AfpInfo header fields in synthesized xattr

Henry Hu <huhai@kylinos.cn>
    ksmbd: report IPv4 and IPv6 addresses independently in iface query

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix invalid Next offset in interface info replies

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()

Henry Hu <huhai@kylinos.cn>
    ksmbd: fix iface_list use-after-free during server reset

Danilo Krummrich <dakr@kernel.org>
    rust: workqueue: replace deprecated system_wq with system_{percpu,dfl}_wq

Nicolas Falesy <nicolas@nicolasfalesy.com>
    exfat: clean stale bdev buffers of newly allocated clusters

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: take bitmap_lock at the start of exfat_alloc_cluster()

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: fix used_clusters accounting during cluster allocation

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: check headers in the RX large send and checksum helpers

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: wait for the RX poll to return before freeing the RX queue

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: wait for in-flight transmits in ibmveth_close()

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: return the error when set_channels cannot add TX queues

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: release the pool kobjects when probe fails

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: step past bad RX correlators instead of spinning or oopsing

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: disable the reset work before unregister in remove

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: do not close twice after a failed reopen

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: fix netpoll races with RX replenish

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: stmmac: Track the TX DMA threshold per queue

Jiale Yao <yaojiale02@163.com>
    team: reject CAN, IEEE 802.15.4 and 6LoWPAN devices in team_port_add

Ido Schimmel <idosch@nvidia.com>
    ipv6: Hold RCU when emitting route hardware flags notification

Eric Dumazet <edumazet@kernel.org>
    ip6mr: clear skb->cb[] in reg_vif_xmit()

Dimitri Daskalakis <daskald@meta.com>
    net/mlx5e: Update netdev features only after a successful ringparam set

Rosen Penev <rosenp@gmail.com>
    net: phy: marvell: keep WOL_EIE across interrupt reconfiguration

Myeonghun Pak <mhun512@gmail.com>
    platform/x86: gpd pocket fan: Cancel work before releasing GPIOs

Eric Dumazet <edumazet@kernel.org>
    ipv6: account route exceptions to the netns of their dst

Sagi Maimon <maimon.sagi@gmail.com>
    net: axienet: release every RX buffer in axienet_dma_bd_release()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    PCI: qcom: Ignore -ENODEV after Root Port reset

Ido Schimmel <idosch@nvidia.com>
    bridge: mcast: Delete empty MDB entry when port group creation fails

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: fix network filter lookup and wake filter pair allocation

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: account for offload header in TX short packet padding

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: fix OF node reference leak for phy_dn

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: validate minimum RX packet size in bcmasp_rx_poll()

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: unmap previous DMA mappings on TX map failure

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmasp: fix mib counters struct alignment with ethtool stats

Myeonghun Pak <mhun512@gmail.com>
    net: hix5hd2: serialize timeout recovery with interface teardown

Karl Mehltretter <kmehltretter@gmail.com>
    net: phy: realtek: restore RTL8211F RGMII delays on resume

Anirudh Virdi <avirdi@redhat.com>
    net: qede: initialize extack in qede_flow_spec_to_rule()

Binbin Deng <18983559317@163.com>
    octeontx2: Fix use-after-free of qos node in delete path

Rishikesh Jethwani <rjethwani@purestorage.com>
    tls: device: protect async RX resync state during device-down

Eric Dumazet <edumazet@kernel.org>
    tcp: tcp_metrics: use the socket netns, not the dst device netns

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: drop IP fragments on SCTP set action

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions

Andrea Righi <arighi@nvidia.com>
    sched_ext: Use irq_work for deferred actions with proxy execution

Linus Torvalds <torvalds@linux-foundation.org>
    vhost: vringh: use get_user()/put_user() for IOTLB 16-bit accesses

Rob Herring (Arm) <robh@kernel.org>
    dt-bindings: clock: mediatek: Add MT8516 fallbacks

HyeongJun An <sammiee5311@gmail.com>
    ASoC: cs42l56: Remove the ADC Mute Switch control

Hui Su <sh_def@163.com>
    sched/mmcid: Fix affinity-triggered switch back to per-task mode

Liang Hao <haohlliang@gmail.com>
    timers: Clear pending_map on CPU hotplug

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix NULL deref in PTP TX timestamp recovery warn

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: DPLL, fix fractional frequency offset scaling

Karl Mehltretter <kmehltretter@gmail.com>
    rtc: class: Make the time32 hctosys limit configurable

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    rtc: mpfs: Fix alarm register word order

James Hilliard <james.hilliard1@gmail.com>
    net: stmmac: avoid duplicate XSK TX completions

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, fix modify header pool creation race

Alexandre Cassen <acassen@corp.free.fr>
    net/mlx5: HWS, fix reformat pool creation race

James Hilliard <james.hilliard1@gmail.com>
    xsk: freeze deferred pool teardown without blocking unregister

Sunny Tiwari <sunnytiwari@google.com>
    RDMA/irdma: Bound in-flight CQP ops across deferred completions

Yongzhao Chen <yongzhao.derek@gmail.com>
    net: phy: qca83xx: read resolved QCA8337 link status

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: fix NULL dereference on index allocation open failure

Zhan Xusheng <zhanxusheng1024@gmail.com>
    ntfs: widen the sub-block offsets in ntfs_decompress()

Zhan Xusheng <zhanxusheng@xiaomi.com>
    ntfs: reject direct I/O reads of encrypted files

Zhan Xusheng <zhanxusheng@xiaomi.com>
    ntfs: do not read ahead encrypted files

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: propagate EA truncate errors

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: clear stale pagecache on initialized-size extension

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: sync attribute inode size after resize

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: only require compressed size on first extent

Jiale Yao <yaojiale02@163.com>
    ntfs: drain in-flight DIO before buffered write fallback

Matthias Goergens <matthias.goergens@gmail.com>
    ntfs: do not give a contiguous cluster allocation a second run

Matthias Goergens <matthias.goergens@gmail.com>
    ntfs: do not refuse fallocate() when the MFT zone is empty

Matthias Goergens <matthias.goergens@gmail.com>
    ntfs: restart the zone search when the allocation hint fails

Matthias Goergens <matthias.goergens@gmail.com>
    ntfs: set the attribute list size before reserving space for it

Matthias Goergens <matthias.goergens@gmail.com>
    ntfs: reject non-resident attributes whose sizes exceed their allocation

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: accept standard sparse compression unit

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: avoid misclassifying directory reparse points

Xuewen Wang <wangxuewen@kylinos.cn>
    ntfs: account for direct MFT bitmap cluster allocation

Xuewen Wang <wangxuewen@kylinos.cn>
    ntfs: wait for the bitmap scan before MFT bitmap extension

pwngets <2605452642@qq.com>
    ntfs: fix runlist marker allocation and count

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: fix error handling in ntfs_extent_inode_open and propagate errors

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: propagate the ntfs_attr_iget() error in update_reparse_data()

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: propagate the map_mft_record() error in ntfs_attrlist_entry_add()

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: preserve the truncate error in ntfs_enlarge_attribute()

Baolin Liu <liubaolin@kylinos.cn>
    ntfs: return -EINVAL from ntfs_collate_ntofs_ulongs() on bad length

Xuewen Wang <wangxuewen@kylinos.cn>
    ntfs: preserve the 64-bit FITRIM minimum length

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: require page-aligned full-page attribute writes

Hyunchul Lee <hyc.lee@gmail.com>
    ntfs: fix FITRIM bitmap indexing for large pages

Marek Wesołowski <marek@wesolowski.eu.org>
    ntfs: fix directory lookup on large-page systems

Ivan Vecera <ivecera@redhat.com>
    selftests: tc-testing: use $IP in hfsc test 8c39 setup

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: dss: avoid printing uninit csum

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: mpc: avoid printing uninit data

Pengfei Zhang <zhangfeionline@gmail.com>
    net: stmmac: xgmac: do not treat TBU as a TX event

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/mlx5: Validate priority in STEERING_ANCHOR_CREATE handler

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Fix CQ resize destination index mask

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_api: reject duplicate actions in a batch

Fan Wu <wufan@kernel.org>
    ipe: fix enforcement audit

Manuel Ebner <manuelebner@mailbox.org>
    ipe: fix invalid sgid value in audit event documentation

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix arena race between page free and alloc leading to incoherency

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Revalidate faulted arena pages before installing user mappings

Sasha Levin <sashal@kernel.org>
    bpf: Fix ksock build with BPF_LSM=y and SECURITY_NETWORK=n

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Properly disabling partition when partition state switching fails

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Do housekeeping check before converting invalid partition to valid

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Consolidate isolated_cpus_can_update() into prstate_housekeeping_conflict()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()

Gregory Price (Meta) <gourry@gourry.net>
    cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Keep the fd_array fill index out of bpf_program__clone()

Li RongQing <lirongqing@baidu.com>
    block, bfq: initialize active lists for all actuators

Cen Zhang <zzzccc427@gmail.com>
    ALSA: aloop: Keep the timer source alive until card release

Cen Zhang <zzzccc427@gmail.com>
    ALSA: aloop: Keep shared timer callbacks alive through close

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Add missing PM ops

Jinpyo Lee <bint4b13@gmail.com>
    nfs/localio: pin UUIDs during global invalidation

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    pNFS/flexfiles: make pg_init retry loops killable

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    nfsv4/pnfs: use the MDS authflavor for data server connections

Wenjie Qi <qwjhust@gmail.com>
    f2fs: refresh pinned allocation boundary after resize

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Protect channel-map reads against runtime detach

Cen Zhang <zzzccc427@gmail.com>
    ALSA: jack: Pin the module while debugfs files are open

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid applying boot quirk for Behringer UMC204HD

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Remove channel-map controls before freeing substreams

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcmtest: Pin the module while pattern files are open

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    nios2: ksyms: Declare __mulsi3 export

Len Brown <len.brown@intel.com>
    tools/power turbostat: pmt: Improve sscanf() hygiene

Miklos Szeredi <mszeredi@redhat.com>
    dax: add fsdev_dax_from_file()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    netfilter: flowtable: reset transport header after nf_flow_encap_pop()

Sung Byeongchan <tjdqudcks0424@naver.com>
    netfilter: xt_dccp: handle reserved options as single-byte

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: narrow down range completion to anonymous sets

Shuangfeng He <huangya90@gmail.com>
    netfilter: flowtable: use the vlan id, not the full tci, in the tuple key

Julian Anastasov <ja@ssi.bg>
    ipvs: fix more races around the overload flag

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: nf_conntrack: avoid truncating IPv6 nexthdr offset

Karl Mehltretter <kmehltretter@gmail.com>
    mm/slub: initialize the free pointer of the bootstrap kmem_cache_node

Alok Tiwari <alok.a.tiwari@oracle.com>
    octeontx2-af: Fix CQ enable state tracking after AQ writes

Cen Zhang <zzzccc427@gmail.com>
    ALSA: oss: Keep emulation modules loaded until object teardown

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Protect the unregister notifier traversal

Adrian Ambrozewicz <aambrozewicz@nvidia.com>
    gpiolib: clear the event clock flags when a line is released

Kent Gibson <warthog618@gmail.com>
    gpiolib: fix memory leak in gpiod_set_array_value_complex() EPERM error path

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Run the cpumask map insert tests only for the test task

Masoud Aghasi <maghasi@disroot.org>
    bpf: Fix incorrect handling of user flags by percpu hash map updates

Masoud Aghasi <maghasi@disroot.org>
    bpf: Fix incorrect handling of user flags in bpf_percpu_array_update

KaFai Wan <kafai.wan@linux.dev>
    selftests/bpf: Use _exit() in uprobe_multi_test clone-ed child

KaFai Wan <kafai.wan@linux.dev>
    selftests/bpf: Fix stack arg pruning test JOIN log expectation

Matt Turner <mattst88@gmail.com>
    alpha: fix stale user_stack_pointer()

Troy Mitchell <troy.mitchell@linux.dev>
    dt-bindings: vendor-prefixes: Add Sensylink

Woojin Ji <random6.xyz@gmail.com>
    bpf: Zero-extend the index in inlined bpf_get_func_arg()

Sasha Levin <sashal@kernel.org>
    locking/atomic: arc, hexagon, openrisc: Define arch_cmpxchg_local()

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/usnic: Bound buffer size to sizeof(buf) in flowinfo_read()

Zhiwei Zhang <202275009@qq.com>
    RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()

HyeongJun An <sammiee5311@gmail.com>
    ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta350: Fix definition of limiter threshold controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta32x: Fix definition of limiter threshold controls

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Reject LAG selection when source MAC lookup fails

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Free unpublished port statistics after initial-read failure

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Preserve the selected source GID on failed AH modification

Igor Velkov <iav@iav.lv>
    power: supply: gpio-charger: Report discharging without input power

Aleksandr Nogikh <nogikh@google.com>
    usb: gadget: dummy_hcd: prevent unbind via sysfs

Igor Skalkin <igor.skalkin@oss.qualcomm.com>
    usb: gadget: dummy_hcd: fix SuperSpeed ep0 maxpacket

Alexei Starovoitov <ast@kernel.org>
    bpf: Use memmove() to store bytes in an xdp_buff

Josef Bacik <josef@toxicpanda.com>
    bpf: Use memmove() to store bytes in an skb

Josef Bacik <josef@toxicpanda.com>
    bpf: Follow the head if an skb is written from a slice

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't take a dynptr argument for a local dynptr

Josef Bacik <josef@toxicpanda.com>
    bpf: Let bpf_dynptr_write() mark a global function

Josef Bacik <josef@toxicpanda.com>
    bpf, cpumap: Hold the device of frames in the queue

Josef Bacik <josef@toxicpanda.com>
    bpf: Use the socket of a sk_lookup test run under RCU

Josef Bacik <josef@toxicpanda.com>
    bpf: Keep the symbols of a program until it has ended

Josef Bacik <josef@toxicpanda.com>
    bpf: Keep values of a dead owner for sleepable programs

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't let an extension reach further into the context than its target

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't take a program with a target program for an iterator

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: restrict raw table targets/matches

Florian Westphal <fw@strlen.de>
    selftests: netfilter: fix return value in zone subtest

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix unlikely UaF in gc worker

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    power: supply: qcom_battmgr: report full batteries

Josef Bacik <josef@toxicpanda.com>
    bpf: Free what map_free() unlinks for sleepable readers

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't take an extension for a writable raw tracepoint program

Josef Bacik <josef@toxicpanda.com>
    bpf: Assume no bounds for a writable tp with tail calls

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't take an extension for an iterator program

Josef Bacik <josef@toxicpanda.com>
    bpf: Assume no bounds for buffers behind a tail call

Josef Bacik <josef@toxicpanda.com>
    bpf: Check the maps that sleepable callbacks use

Josef Bacik <josef@toxicpanda.com>
    bpf: Count sleepable callbacks as sleepable map users

Josef Bacik <josef@toxicpanda.com>
    bpf: Keep a program until its bpf_wq callback has ended

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't bind a program to a netdev that goes away

Josef Bacik <josef@toxicpanda.com>
    bpf: Fix stale offload->prog pointer after realloc

Josef Bacik <josef@toxicpanda.com>
    bpf: Bound the nesting that the BTF show code follows

Josef Bacik <josef@toxicpanda.com>
    bpf: Hold the socket in the sk_storage map iterator

Alexei Starovoitov <ast@kernel.org>
    bpf: Link the first element after its storage is published

Josef Bacik <josef@toxicpanda.com>
    bpf: Fix NULL deref in the sk_storage map iterator

Alexei Starovoitov <ast@kernel.org>
    bpf: Clear sk_refcnt of a clone before its storage is linked

Josef Bacik <josef@toxicpanda.com>
    bpf: Update the SRH state if End.B6 fails late

Josef Bacik <josef@toxicpanda.com>
    bpf: Pull the inner header for End.DT6 in End.BPF

Josef Bacik <josef@toxicpanda.com>
    bpf: Validate the SRH which End.DT6 uncovers in End.BPF

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't saturate owner_refcnt on the last unpin

Josef Bacik <josef@toxicpanda.com>
    bpf: Read the probe of a perf event under event_mutex

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't let bpf_skb_adjust_room() use up the MSS

Josef Bacik <josef@toxicpanda.com>
    bpf: Look at all 64 bits of a BPF_JSET mask on 32-bit

Josef Bacik <josef@toxicpanda.com>
    bpf: Forbid sleeping in bpf_find_vma() callbacks

Josef Bacik <josef@toxicpanda.com>
    bpf: Reject sleepable programs for task_vma iterator

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't hand out a linked element as extra element

Josef Bacik <josef@toxicpanda.com>
    bpf: Don't leak the inode when token creation fails

Josef Bacik <josef@toxicpanda.com>
    bpf: Forbid sleeping in hash map for_each callbacks

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Report non-sleepable kfunc programs accurately

Josef Bacik <josef@toxicpanda.com>
    bpf: Use the frame mem type in devmap egress XDP

Joonhoe Kim <26rote@gmail.com>
    power: supply: qcom_battmgr: report the USB type from USB_ADAP_TYPE

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix verifier WARN on narrow read of bpf_tcp_sock u64 fields

Tejun Heo <tj@kernel.org>
    sched_ext: Fix a bypassed task stalling on a cpu its scheduler has no caps on

Tejun Heo <tj@kernel.org>
    sched_ext: Fix the running task keeping its protection into bypass

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evsel: Mark the event as supported when retrying an open

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test attr: Relax group checking for ungrouped expectations

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test attr: Fix default stat metrics expectations

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test attr: Fix legacy event encodings in group tests

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test attr: Fix record dwarf sample_type expectation

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Honor MSI-X selection

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Use a local epf pointer in interrupt setup

Cen Zhang <zzzccc427@gmail.com>
    ALSA: jack: Protect the index scan against control removal

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Don't echo user-supplied map info fields back to userspace

Brad Fitzpatrick <bradfitz@tailscale.com>
    gre: keep the UDP tunnel GSO type when completing GRO

Vincent Jardin <vjardin@free.fr>
    ptp: qoriq: fix support for PTP_EXTTS_REQUEST2 ioctl

Vincent Jardin <vjardin@free.fr>
    net: enetc: fix support for PTP_EXTTS_REQUEST2 ioctl

Vincent Jardin <vjardin@free.fr>
    dpaa2-ptp: fix support for PTP_EXTTS_REQUEST2 ioctl

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: notify sibling pin when shared output config changes

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: make embedded sync follow the output carrier frequency

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: reject output frequencies with too small divisor

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: reject inexact frequencies for N-divided outputs

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: do not offer 0 Hz as a supported pin frequency

Joas Antonio dos Santos <joasantonio108@gmail.com>
    calipso: update payload_len when removing the CALIPSO option

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta350: Fix definition of Ch2 and Ch3 Volume Bypass controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: sta32x: Fix definition of Ch2 and Ch3 Volume Bypass controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control

Yonghong Song <yonghong.song@linux.dev>
    bpf, x86: Pass a trampoline's stack arguments by the calling convention

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Claim the per-CPU send_signal irq_work before filling it

Sasha Levin <sashal@kernel.org>
    ARC: Strip libgcc debug information when generating BTF

Tal Zussman <tz2294@columbia.edu>
    btrfs: update the inode item when removing a free space inode

Tal Zussman <tz2294@columbia.edu>
    btrfs: drop the extent maps of the written part of a failed ordered extent

Piotr Gliźniewicz <p.glizniewicz@gmail.com>
    ALSA: 6fire: take stream_mutex in the Digital Thru control

Myeonghun Pak <mhun512@gmail.com>
    platform: cznic: turris-omnia-mcu: stop button emulation producers

Ömer Mete Kaya <omermetekaya0@gmail.com>
    usbnet: fix smp_processor_id() use in preemptible context

Yongzhao Chen <yongzhao.derek@gmail.com>
    net: phy: qcom: at803x: Apply IPQ5018 analog settings at probe

Fabrice Derepas <fabrice.derepas@canonical.com>
    ima: reject a kexec buffer whose declared size exceeds the buffer

Qiliang Yuan <odys.yuan@gmail.com>
    blk-mq: share one tags_srcu instance across all tag sets

Tao Cui <cuitao@kylinos.cn>
    blk-iocost: account zone append completions in latency stats

Tao Cui <cuitao@kylinos.cn>
    blk-iocost: charge zone appends as writes

Viktor Menshin <ripeeerr@gmail.com>
    ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)

Val Packett <val@packett.cool>
    power: sequencing: pcie-m2: Add Foxconn WCN7850 subsystem PCI ID

Colin Ian King <colin.i.king@gmail.com>
    selftests/bpf: Fix spelling mistakes in descr literal strings

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix inverted tracefs validation when scanning /proc/mounts

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Expect at least one kprobe miss in missed/perf_kprobe

Ju Nan <junan76@163.com>
    pinctrl: stm32: Fix the unit of the hwspinlock timeout

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fully disable the AS even if it's going to be re-assigned

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Don't invalidate OTHER caches

Adam Azuddin <azuddinadam@gmail.com>
    drm/appletbdrm: Fix incorrect error message on encoder attach failure

Hui Peng <benquike@gmail.com>
    fuse: validate folio state before pipe_buf_try_steal() in fuse_try_move_folio()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix NULL pointer dereference in fuse_request_find

Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
    HID: wacom: fix wacom_intuos_irq NULL pen_input deref

Dmitriy Geels <dmitriy.geels@gmail.com>
    HID: logitech-hidpp: cancel reset_hi_res_work on probe failure

Nehuen Lian Bova <nehuenlian.kernel@gmail.com>
    HID: magicmouse: fix null pointer dereference in magicmouse_event()

Denis Benato <denis.benato@linux.dev>
    HID: asus: document and harden the worker teardown

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Record only the test ICMP echo in tc8 of tc_netkit_scrub

Cen Zhang <zzzccc427@gmail.com>
    ALSA: vmaster: Protect follower lookup and setup

Vasilij Markin <vasilij.kernel@tototo.si>
    drm/appletbdrm: Add suspend and resume support

Jemmy Wong <jemmywong512@gmail.com>
    sched/cache: Avoid publishing partial LLC utilization

Stian Halseth <stian@itx.no>
    sched/cputime: Don't account idle time twice after dyntick-idle

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Unmount the bpffs that cgroup_hierarchical_stats mounted

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Keep the bpffs of cgroup_hierarchical_stats private

Eric Dumazet <edumazet@kernel.org>
    tcp: use the echoed source route in cookie_v4_check()

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
    net: use the full socket in sk_mc_loop()

Eric Dumazet <edumazet@kernel.org>
    ipv4: use RCU protection in inet_netconf_get_devconf()

George Melikov <mail@gmelikov.ru>
    bnx2x: fix header length calculation for encapsulated TSO

Muchun Song <muchun.song@linux.dev>
    dax/bus: Return errors for invalid mapping targets

Stefano Munari <stefanomunari.sm@gmail.com>
    net: usb: lan78xx: reject invalid EEPROM write requests

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    macsec: prevent AES-GCM nonce reuse after packet number wrap

Yun Lu <luyun@kylinos.cn>
    bpf: Prevent task work context reuse while irq_work is busy

Yun Lu <luyun@kylinos.cn>
    bpf: Fix NULL task dereference in task work cancellation

KaFai Wan <kafai.wan@linux.dev>
    selftests/bpf: Skip expected_msgs subtests when stdout is not saved

KaFai Wan <kafai.wan@linux.dev>
    selftests/bpf: Fix prog_tests framework subtest count checks

Li RongQing <lirongqing@baidu.com>
    ublk: use global index for reported zones

Ming Lei <tom.leiming@gmail.com>
    ublk: allow a NULL io->cmd in the cancel callback

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Print a signed histogram key as signed

Atharva Vartak <atharva.a.vartak@gmail.com>
    net/smc: hold a reference on net_device returned by pnet_find_base_ndev()

Jianan Huang <jnhuang95@gmail.com>
    f2fs: quota: fix quota flush failure during filesystem freeze

pengdonglin <pengdonglin@xiaomi.com>
    tracing: Avoid BTF lookup in atomic context

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Clamp the printed end of a histogram bucket at U64_MAX

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Only report the stacktrace modifier on a real field

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Print the bucket size as unsigned

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix ETDM probe error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix HDMI TX startup error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix ETDM startup error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix ETDM MCLK error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Propagate IRQ lookup errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix runtime resume error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Check paired MEMIF clock enable in FE trigger

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix FE startup error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix paired memif clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix main clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix timing system clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix register access clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8195: Fix tuner clock error handling

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-component: Fix return type of snd_soc_pcm_component_pointer()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-ac97: Fix error handling in snd_soc_new_ac97_component()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-card-test: Check return value of kunit_device_register()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-topology-test: Check return value of kunit_device_register()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: ops: Fix return value in snd_soc_limit_volume()

Amadeusz Sławiński <amade@asmblr.net>
    ASoC: soc-link: Correct stream stop operations in snd_soc_link_trigger

Abraham Zukor <abe@maticrobots.com>
    spi: tegra114: initialize native chip selects inactive

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog

Paolo Bertinetti <paolobertinetti200f4@proton.me>
    ublk: hold RCU read lock in ublk_try_buf_match()

Sasha Levin <sashal@kernel.org>
    selftests: keep the build status from wrapping to success

Michael Auer <mick@yoxcu.de>
    ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Prevent module info underflow

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Unprepare a stream when recovery occurs

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population

Serhat Kumral <serhatkumral1@gmail.com>
    IB/rdmavt: Fix error unwind path for qp_priv_init() in rvt_create_qp()

Sasha Levin <sashal@kernel.org>
    kselftest/arm64: signal: copy each test binary only once

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Accept unnamed dma-bufs in the dmabuf_iter default test

Yun Lu <luyun@kylinos.cn>
    selftests/bpf: Fix map fd leak in no-BTF wq test

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Serialize snd_refcount put and sync

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Create the vxlan devices of test_tunnel with their MAC

Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
    IB/mlx4: Avoid requeueing executing CM timeout work

Zhan Xusheng <zhanxusheng1024@gmail.com>
    vdso/vsyscall: Keep the CLOCK_AUX base scaled

Zhan Xusheng <zhanxusheng1024@gmail.com>
    vdso/math64: Add and use __iter_div64_u64_rem()

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Track link state from both sides

Jaewon Jung <jaewon8868@gmail.com>
    selftests/ftrace: Avoid unlink error on first run

Myeonghun Pak <mhun512@gmail.com>
    ASoC: rt5645: Shut down the button timer on removal

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix orig_mlen initialization in ext4_map_blocks()

Akash Goel <akash.goel@arm.com>
    drm/panthor: Fix handling of NO_MMAP BOs

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]

Honggang LI <honggangli@163.com>
    RDMA/rxe: Fix out-of-range unsigned-to-signed conversion for RDMA message in 2GiB size

xiongweimin <xiongweimin@kylinos.cn>
    RDMA/rxe: Hold netdev reference for transmit skbs

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()

Youngsung Ahn <ays511.kr@gmail.com>
    RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    spi: omap2-mcspi: handle DMA setup failures

Julian Sun <sunjunchao@bytedance.com>
    block: take the inode lock for buffered write fallback

Julian Sun <sunjunchao@bytedance.com>
    block: reject NOWAIT buffered write fallback

Ard Biesheuvel <ardb@kernel.org>
    efi/runtime-wrappers: Don't park the worker after a recovered firmware fault

zhoumin <teczm@foxmail.com>
    ata: ahci: preserve preset port masks

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Add refcount for races between drain and unlink

Benoît Monin <benoit.monin@bootlin.com>
    irqchip/mips-gic: Transfer interrupt mask state across clusters

Benoît Monin <benoit.monin@bootlin.com>
    irqchip/mips-gic: Fix recursive acquisition of gic_lock in gic_set_affinity()

Benoît Monin <benoit.monin@bootlin.com>
    irqchip/mips-gic: Fix unbalanced cm_core_lock in for_each_online_cpu_gic()

Zhu Ling <zhuling2709@phytium.com.cn>
    irqchip/gic: Fix UBSAN shift-out-of-bounds in GIC helpers

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3: Don't register a redistributor that was never counted

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Don't free the tables of an enabled ITS

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Don't free a vPE table shared with another ITS

Pengpeng Hou <hppiscas@163.com>
    irqchip/riscv-imsic: Reject overlapping group index fields

Pengpeng Hou <hppiscas@163.com>
    irqchip/sifive-plic: Avoid signed shift in interrupt enable mask

Pengpeng Hou <hppiscas@163.com>
    irqchip/mst-intc: Validate the DT interrupt range

Arnd Bergmann <arnd@arndb.de>
    irqchip/qcom-pdc: Fix linking against QCOM_SCM firmware

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    irqchip/qcom: Enable compile testing for QCOM_PDC and QCOM_MPM

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3-its: Clear vpt_page after freeing the pending table

Fuad Tabba <fuad.tabba@linux.dev>
    irqchip/gic-v3: Release the partition node in gic_irq_get_fwspec_info()

David Howells <dhowells@redhat.com>
    rxrpc: Fix sendmsg length

David Howells <dhowells@redhat.com>
    rxrpc: Fix aborting in rxperf test server

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxperf test rxgk key kvno to be 0

David Howells <dhowells@redhat.com>
    rxrpc: Revert "rxrpc: rxperf: Fix missing decoding of terminal magic cookie"

Carolina Jubran <cjubran@nvidia.com>
    IB/IPoIB: Cancel normal flush work on device stop

Jiayuan Chen <jiayuan.chen@linux.dev>
    veth: clear rx queue hint in veth_xmit

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Expect at least one tp_recursion miss in missed

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Report a failure to register the session key in test_progs

Qiliang Yuan <odys.yuan@gmail.com>
    selftests/bpf: Use its own netns in flow_dissector_skb_less_direct_attach

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Fix NO_FUA quirks shadowed by earlier quirk entries

Sagi Maimon <maimon.sagi@gmail.com>
    net: axienet: free outstanding TX buffers in axienet_dma_bd_release()

Kyrylo Biryuk <illofspeed@gmail.com>
    ata: libahci: re-enable FBS after error handling on a port multiplier

Miguel Ojeda <ojeda@kernel.org>
    rust: zerocopy: fix link to upstream `README.md`

Sasha Levin <sashal@kernel.org>
    selftests/exec: report the skipped binfmt_misc_bpf test on stderr

Long Zhao <longzhao@ambarella.com>
    dt-bindings: vendor-prefixes: add Ambarella

Wentao Liang <vulab@iscas.ac.cn>
    spmi: mtk-pmif: Fix clock reference leak in mtk_spmi_bus_probe()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    spmi: mtk-pmif: Add workaround for FSM lockup/error in read operation

Fenglin Wu <fenglin.wu@oss.qualcomm.com>
    spmi: pmic-arb: return 0 in spmi_pmic_arb_register_buses() on success

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    iommufd: Keep reserved IOVA ranges when a replace within one IOAS fails

Petr Pavlu <petr.pavlu@suse.com>
    resolve_btfids: Fix the --fatal_warnings exit status

Sasha Levin <sashal@kernel.org>
    selftests/nolibc: use the configured kernel header directory

Semih Baskan <strst.gs@gmail.com>
    PCI: iproc: Use the EROM outbound window on BCMA

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Expose devm_pci_alloc_host_bridge_release()

Nicolai Buchwitz <nb@tipi-net.de>
    net/mlx5e: use skb_share_check() in the loopback selftest hook

Nicolai Buchwitz <nb@tipi-net.de>
    net: stmmac: selftests: use skb_share_check() in the loopback receive hook

Nicolai Buchwitz <nb@tipi-net.de>
    net: selftests: use skb_share_check() in the loopback receive hook

Jiale Yao <yaojiale02@163.com>
    clocksource/drivers/timer-ti-dm: Handle runtime resume failure

Kyle Pepper <cochcoder@proton.me>
    Bluetooth: hci_sync: scan unfiltered for host-resolved RPAs

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix the LE Read Connection Interval response layout

Kevin Dewald <kevin@simpleble.org>
    Bluetooth: hci_event: Fix LE link drop on remote features command status

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: MSFT: Serialize handle map cleanup with event processing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Allow connection rate request as peripheral

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Zero version data before parsing TLVs

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: Protect IRK identity reads with RCU

Eric Dumazet <edumazet@kernel.org>
    Bluetooth: btmtk: fix skb double free on ISO padding failure

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: Drain RCU readers on registration failure

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: msft: Lock failed probe cleanup against feature readers

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: MGMT: Reject quality report requests during unregister

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: ISO: Hold the listener during disconnect notification

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: Serialize devcoredump reset during device open

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_core: Keep RCU protection through LTK filtering

Hitalo Souza <enghitalo@gmail.com>
    Bluetooth: Add missing newline to bt_dev_{err,warn}_ratelimited()

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6LoWPAN: Use RCU-safe device list removal

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix leaking instance on Add Extended Advertising Parameters

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix pending state of instances added without HCI traffic

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Fix tracking of instances sharing handle 0x00

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix advertising instances with Global Advertising

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: fix mesh adv timeout units

Kiran K <kiran.k@intel.com>
    Bluetooth: btusb: Preserve event and ACL packet ordering

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: clear the GP0 cause with a W1C write

Sergey Lebedev <lsa.uz@pm.me>
    Bluetooth: btintel_pcie: verify and serialize D-state transitions

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: sync mbox tlv parsing with GP0 alive interrupt

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: fix PM flow for S0ix, S3 and S4

Vladimir V. Kondratyev <vladimirkondratyev2@gmail.com>
    Bluetooth: btintel_pcie: fix stale cache in set_dxstate fallback check

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: Improve BT firmware logging

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: Validate the firmware layout before parsing it

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: remove duplicate BTINTEL_PCIE_MAGIC_NUM definition

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: parse FW memory addresses via mailbox TLV

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: hold chan in l2cap_ecred_conn_rsp()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: hold l2cap_conn::lock in l2cap_connect_cfm()

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Pass the hardware device id to mt79xx_setup()

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Remove redundant firmware filename override

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    PCI: Fix out-of-bounds MMIO read in nvme_disable_and_flr()

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9492/1: alignment: fix LSR #32 and ASR #32 offset decoding

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: 9486/1: set !LPAE MAX_PHYSMEM_BITS to 32 and remove supersection mappings

Atul Akella <atul.akella@gmail.com>
    rpmsg: virtio: fix error handling in TX buffer wait

Avi Weiss <thnkslprpt@gmail.com>
    rpmsg: mtk: release channel OF node on device teardown

Le Qi <le.qi@oss.qualcomm.com>
    ASoC: codecs: da7213: Get MCLK in I2C probe

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm5100: Fix definition of EQ3 Band 1 Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8737: Fix definition of zero cross switches

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8955: Fix definition of Treble Cutoff control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8983: Fix definition of ADC 128x Oversampling control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8991: Fix definition of right input PGA controls

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control

HyeongJun An <sammiee5311@gmail.com>
    ASoC: codecs: wm8990: Fix definition of right input PGA controls

Pengpeng Hou <hppiscas@163.com>
    PCI: eswin: Publish the platform driver OF alias

Tim Douglas <me@timdoug.com>
    serial: pmac_zilog: report received breaks

Karl Mehltretter <kmehltretter@gmail.com>
    serial: ma35d1: Do not force-enable an unselected console

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix oops on short integer attribute buffer

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: validate SPM state returned by firmware

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix off-by-one in password length check

Leon Romanovsky <leon@kernel.org>
    dma-debug: Skip cacheline tracking for MMIO mappings

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Unlink substreams before releasing them

Kohei Enju <enju.kohei@fujitsu.com>
    arm64: rsi: Correct type of realm_config::hash_algo

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: track SSID regardless of country data

Shang En Sim <sim@shangen.org>
    platform/x86: hp-wmi: Fix hwmon keep-alive teardown

Julian Anastasov <ja@ssi.bg>
    ipvs: fix buffer overflow when sending sync messages

Endrik Einberg <git@endrik.dev>
    wifi: iwlwifi: mld: include VI packets in low latency detection

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix the VHT MCS sent to a v1 firmware

Binbin Deng <18983559317@163.com>
    module: Fix uninitialized count read of unloaded taint tracking record

Kees Cook <kees@kernel.org>
    mm/slab: Mark the kmem_buckets_create() context as a Context: section

Pengpeng Hou <hppiscas@163.com>
    thermal/drivers/rzg3e: Propagate reset assertion failure from suspend

Karl Mehltretter <kmehltretter@gmail.com>
    thermal: ti-soc-thermal: Fix the return value in ti_bandgap_get_sensor_data() kernel-doc

Ronald Claveau <linux-kernel-dev@aliel.fr>
    thermal/drivers/amlogic: Switch to clk_bulk API to support multiple clocks

Ronald Claveau <linux-kernel-dev@aliel.fr>
    dt-bindings: thermal: amlogic: describe bus clock for t7-thermal

Florian Fainelli <florian.fainelli@broadcom.com>
    tools/thermal/tmon: Fix string truncation warning in optarg copy

Vitaliy Sochnev <sochnev.v.74@gmail.com>
    thermal/drivers/airoha: Fix AN7583 ADC mux field mapping

Weigang He <geoffreyhe2@gmail.com>
    thermal/drivers/sprd: validate the sensor id from the device tree

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use fixed control index for us16x08 mixer elements

Karl Mehltretter <kmehltretter@gmail.com>
    wifi: nxpwifi: return timeout error from nxpwifi_sdio_poll_card_status()

Cen Zhang <zzzccc427@gmail.com>
    ALSA: vmaster: Serialize hook registration with control callbacks

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Use kzalloc() for PCM buffer allocation

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Protect delay DMA sync in forward and rewind, too

Takashi Iwai <tiwai@suse.de>
    ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()

Amadeusz Sławiński <amade@asmblr.net>
    ALSA: pcm: Fix driver_tstamp value reporting

Bradley Morgan <brads@mainlining.org>
    watchdog/perf: one digit too short in the raw event config copy

Karl Mehltretter <kmehltretter@gmail.com>
    kcov: report spurious PCs in the interrupt selftest

Karl Mehltretter <kmehltretter@gmail.com>
    resource, kunit: stop selecting GET_FREE_REGION

Danish Khateeb <danishkhateeb03@gmail.com>
    kselftest/filelock: plan for the five ofdlocks tests

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ocfs2: validate chunk and block counts of the local quota file

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: retain all security xattrs during inode creation

Zhiling Zou <zhilinz@nebusec.ai>
    lib: validate in-memory LZ4 chunk length

Bart Van Assche <bvanassche@acm.org>
    scsi: scsi_debug: Fix a locking bug in resp_write_same()

Hongjian Dai <daihongjian@kylinsec.com.cn>
    spi: meson-spicc: fix invalid DMA unmap on mapping failure

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: codecs: wcd937x: request watchdog IRQs without devm

Priyanka Mani <priyankamani2100@gmail.com>
    ASoC: mediatek: mt8365: Fix out-of-bounds read in get_iir_coef()

Shuvam Pandey <shuvampandey1@gmail.com>
    accel/qaic: Protect perf stats BO state with bo->lock

Jonathan Santos <Jonathan.Santos@analog.com>
    spi: axi-spi-engine: fix stale SYNC IRQ pending in trigger_enable

Jonathan Santos <Jonathan.Santos@analog.com>
    spi: axi-spi-engine: fix stale SYNC IRQ pending

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Add missing symsrc__destroy() for libbfd

Namhyung Kim <namhyung@kernel.org>
    perf symbol: Fix symbol loading from libbfd

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: skip BBM copy on regular raw reads

Karl Mehltretter <kmehltretter@gmail.com>
    sh: sh7785lcr: Register the PCA9564 controller as I2C bus 0

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: propagate TDM clock errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: propagate I2S clock errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: fix runtime resume error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: propagate main clock errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: fix register access clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: fix MCK error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: fix APLL enable error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8196: fix APLL mux error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel-i2s: use optional API for gclk

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel-i2s: use optional API for muxclk

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel-i2s: fix MCK generator error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: renesas: msiof: Fix msiof_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: intel: atom: Fix .shutdown() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: imx-pcm-rpmsg: Fix imx_rpmsg_pcm_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: yc: Fix acp6x_pdm_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: vangogh: Fix acp5x_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: ps: Fix acp63_sdw_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: ps: Fix acp63_pdm_dma_close() being skipped on rollback

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: amd: acp: Fix .close() being skipped on rollback

Mingxuan Guo <gmx472@qq.com>
    firmware: cs_dsp: clear dsp->running on the cs_dsp_run() error path

Yao Sang <sangyao@kylinos.cn>
    nvme: pass partition flags to passthrough checks

Sung Byeongchan <tjdqudcks0424@naver.com>
    nvmet-auth: reject undersized AUTH_SEND payloads

Palla Raghunath <raghunathpalla.0209@gmail.com>
    nvmet-fc: don't drop the last assoc reference in nvmet_fc_delete_ctrl()

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: reject live migration on 64KB page with QM_HW_V3 hardware

Simon Song <xinmengs@nvidia.com>
    vfio/pci: Remove the core dependency on driver data

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: fix NULL dereference in reset_prepare on PF passthrough

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Unpublish QP table before freeing it

Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
    RDMA/bnxt_re: Use kvzalloc for QP table allocation

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Use asm_inline for arch_this_cpu_add()

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Rework to simplify percpu_entry() and percpu_exit()

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Use percpu code section for this_cpu_cmpxchg()

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Use percpu code section for this_cpu_xchg()

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Use percpu code section for this_cpu_cmpxchg128()

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Use __PCPU_BEGIN() and __PCPU_END() for inline assemblies

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Rename inline assembly symbolic names

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu/lowcore: Add and use LC_PERCPU lowcore offset defines

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Let MVIY_PERCPU() calculate alternative displacement

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: Add sanity check to GEN_MVIY macro

Heiko Carstens <hca@linux.ibm.com>
    s390/early: Fix early warning handling

Heiko Carstens <hca@linux.ibm.com>
    s390/uprobes: Fix off-by-one bug in emulated PER handling

Heiko Carstens <hca@linux.ibm.com>
    s390/ptrace: Preserve ILC when updating system call number

Qu Wenruo <wqu@suse.com>
    iomap: follow the alignment requirement for iomap_dio_hole_iter()

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: Fix camera rivian PLL configuration settings

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: rcg2: Clear force enable after rate failure

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: rcg2: Propagate force-enable status errors

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: rcg2: Initialize shared floor clock state

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: mmcc-msm8960: Configure PLL15 only on APQ8064

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: mmcc-sdm660: Fix MDSS AHB clock HWCG register offset

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: gcc-ipq5424: Fix TME reset register offsets

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: gcc-x1e80100: Don't poll the status bit of GCC_USB4_n_SYS_CLK

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Use clk_regmap_phy_mux_ops for GCC UFS muxes

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: rpmhcc: Add LNBB clocks support for Glymur

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gcc: Fix GPLL enable register offset for Nord SoC

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: gcc-kaanapali: Tie the CX power domain to controller

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: gcc-eliza: Tie the CX power domain to controller

Guangshuo Li <lgs201920130244@gmail.com>
    soc: mpfs: use kref cleanup on probe failure

Yuho Choi <oss.patchbox@gmail.com>
    bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()

Yuho Choi <oss.patchbox@gmail.com>
    bus: arm-cci: Drop CPU node reference in cci_ace_init_ports()

Linkai Gong <gonglinkai@kylinos.cn>
    char: scx200_gpio: check cdev_add() return value

Sasha Levin <sashal@kernel.org>
    tools: hv: remove unused rte_smp_mb()

Weigang He <geoffreyhe2@gmail.com>
    thermal/drivers/ti-soc-thermal: Cancel pending alert work on remove

Georgi Djakov <djakov@kernel.org>
    thermal/drivers/qcom-spmi-temp-alarm: Fix temp_map indexing

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test attr: Source setup_python.sh instead of calling python

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: pcmuio: validate the IRQs supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: pcmmio: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: dmm32at: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: dt2814: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: ni_atmio16d: validate the IRQ supplied by userspace

Yogesh Gaur <yogeshgaur.83@gmail.com>
    comedi: comedi_parport: validate the IRQ supplied by userspace

Thomas Fourier <fourier.thomas@gmail.com>
    net: alacritech: fix dma_free_coherent() in error path

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: do not mark frame pages uptodate on read error

liyouhong <liyouhong@kylinos.cn>
    fs/ntfs3: fix ntfs_fnd leak when compare function is missing

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: don't transmit while an RS485 reconfigure is pending

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: drive RTS in software when hardware delays are too short

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: support active-low RTS on the hardware path

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: don't power down the port mid-transmission on close

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: fix RS485 delays being programmed as bit-times

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: centralize the RS485 transceiver programming

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: fix breaks not reaching the wire in RS485 mode

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: don't clobber the TX break bit in set_termios

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp_cubic: fix divide by zero and endless loop on bad module params

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp_hybla: fix divide by zero on rtt0 == 0

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp_bic: fix divide by zero on max_increment == 0

David Heidelberg <david@ixit.cz>
    serial: qcom-geni: power the console back up on system resume

Jeff Chen <jeff.chen_1@nxp.com>
    wifi: mwifiex: append hotfix number to firmware version string

Chien Wong <m@xv97.com>
    wifi: mac80211: reserve MME tailroom for protected beacons

Chien Wong <m@xv97.com>
    wifi: mac80211: fix encryption tailroom

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Fix race between admin command timeout and completion

Haitam Lazaar <haitam@lazaarsec.com>
    RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for read responses

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    clocksource/drivers/timer-mediatek: Fix random crash at boot

Joas Antonio dos Santos <joasantonio108@gmail.com>
    calipso: hash the cache key, not the option start, in calipso_cache_add()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    PCI: qcom: Honor IOMMU provider's #iommu-cells in qcom_pcie_config_sid_1_9_0()

Vikas Gupta <vikas.gupta@broadcom.com>
    bnge: skip dev_addr when building the VNIC unicast list

Cen Zhang <zzzccc427@gmail.com>
    ALSA: pcm: Protect delay DMA sync against concurrent HW_FREE

Cen Zhang <zzzccc427@gmail.com>
    ALSA: rawmidi: Drain input work before freeing the runtime

Helge Deller <deller@gmx.de>
    fbdev: atafb: avoid cast when assigning buffer address pointer

Helge Deller <deller@gmx.de>
    fbdev: atafb: fix sparse warnings

Myeonghun Pak <mhun512@gmail.com>
    fbdev: gxt4500: Release WC setup on probe failure

Abel Vesa <abel.vesa@oss.qualcomm.com>
    platform: arm64: qcom-hamoa-ec: Disable the SCI IRQ during suspend

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmc: clear devm-managed pointers on remove to prevent stale reuse

Patryk Pilichowski <pat.pilichowski@gmail.com>
    platform/x86: msi-wmi: Fix hotkeys dropped with vendor backlight

Jiale Yao <yaojiale02@163.com>
    platform/olpc: Reserve space for a string terminator

Aleksandrova Alyona <aga@itb.spb.ru>
    platform/x86: intel_telemetry: initialize default trace verbosity

Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    platform/x86/intel: power-domains: Handle failed init in tpmi_get_linux_die_id()

Xi Pardee <xi.pardee@linux.intel.com>
    platform/x86/intel/pmc: Fix stale NVL PCD-S S0ix_LPM telemetry constants

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Drop scratch_reg from amd_1ah_m80_cpu_info

Daasaradhi Mannava <daasaradhimannava@gmail.com>
    platform/x86: msi-ec: Report valid charge thresholds when unset

Ahmed Yaseen <yaseen@ghoul.dev>
    platform/x86: asus-wmi: validate custom fan curves on enable

Dale Whinham <daleyo@gmail.com>
    platform/surface: aggregator_registry: Fix tablet-mode detection on Surface Pro 11

Dale Whinham <daleyo@gmail.com>
    platform/surface: aggregator_registry: Remove sensors device for Surface Pro 11

Arnd Bergmann <arnd@arndb.de>
    platform/x86/amd/pmf: fix compat ioctl handling

Ali Ahmet Memiş <aliamemis@disroot.org>
    ALSA: hda: intel: Don't free card in the probe work

Cen Zhang <zzzccc427@gmail.com>
    ALSA: jack: Remove debugfs before freeing unregistered jacks

Dan Carpenter <error27@gmail.com>
    mm/hmm/test: reject overflowing page counts

Harry Yoo (Meta) <harry@kernel.org>
    selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test

Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
    selftests/damon: stop kdamond on error exits of no-op commit test

Paulo Alcantara <pc@manguebit.org>
    smb: client: log the selected security type on session setup failure

Jiale Yao <yaojiale02@163.com>
    wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup

Jiale Yao <yaojiale02@163.com>
    wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup

Jiale Yao <yaojiale02@163.com>
    wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup

Jiale Yao <yaojiale02@163.com>
    wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup

Jiale Yao <yaojiale02@163.com>
    wifi: ath10k: avoid IDR mutation during TX cleanup

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths

Kunwu Chan <kunwu.chan@gmail.com>
    rcutorture: Fix divide-by-zero with fwd_progress_div=1

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    srcu: Use IRQ_WORK_INIT_HARD for srcu's irq_work

Joonhoe Kim <26rote@gmail.com>
    ASoC: codecs: wcd939x: read the SoundWire port switches per channel

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: codecs: rt5659: propagate GPIO errors

Niklas Cassel <cassel@kernel.org>
    PCI: Update saved Max Payload Size in pcie_set_mps()

Sidong Yang <sidong.yang@furiosa.ai>
    accel/rocket: Don't tear down the scheduler when drm_sched_init() fails

Roberto Bergantinos Corpas <rbergant@redhat.com>
    nfs: set gencount on protocol-specific remove

Haotian Zhang <vulab@iscas.ac.cn>
    mtd: rawnand: pl353: fix clk reference leak in pl35x_nfc_setup_interface()

bui duc phuc <phucduc.bui@gmail.com>
    power: supply: generic-adc-battery: Propagate charged GPIO errors

Filipe Manana <fdmanana@suse.com>
    btrfs: defrag: fix check to see if next extent can be defragged too

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix swapped blocks existence check when tracing after COW

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup

Filipe Manana <fdmanana@suse.com>
    btrfs: fix off-by-one end offset check in report_setget_bounds()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix duplicated code in fs state string in logged messages

Filipe Manana <fdmanana@suse.com>
    btrfs: fix incomplete iteration over fs state when logging messages

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info

Filipe Manana <fdmanana@suse.com>
    btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix off by one super block end offset calculation when writing super blocks

Qu Wenruo <wqu@suse.com>
    btrfs: refactor read_key_bytes() to remove the dest_folio parameter

Guanghui Yang <3497809730@qq.com>
    btrfs: roll back sprout setup after device add failure

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: align real_num_tx_queues to mqprio configuration

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: set real_num_tx_queues to max(offset + count)

David Zhang <yidong.zhang@amd.com>
    accel/amdxdna: Reject device heap BO when dev_mem_size is not set

Tal Zussman <tz2294@columbia.edu>
    block: unpin all pages of a bvec in bio_iov_iter_align_down()

Tal Zussman <tz2294@columbia.edu>
    block: don't fall back to buffered I/O for atomic writes

Tal Zussman <tz2294@columbia.edu>
    block: honor IOCB_NOWAIT in the block device buffered read path

Tal Zussman <tz2294@columbia.edu>
    block: take i_rwsem for the splice read path

Tal Zussman <tz2294@columbia.edu>
    block: take i_rwsem for the direct I/O write fallback

Zhenxian Ma <mzx199711@gmail.com>
    block: only use REQ_FUA for direct writes if the device supports it

Zhenxian Ma <mzx199711@gmail.com>
    block: skip redundant flush for O_DSYNC direct writes

Tal Zussman <tz2294@columbia.edu>
    block: use iomap_dirty_folio for block devices

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_hdmi_qp: Add missing newlines in dev_err_probe() messages

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_hdmi_qp: Cancel pending HPD work on suspend

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_hdmi_qp: Fix invalid drvdata access in PM ops

Jiale Yao <yaojiale02@163.com>
    ACPI: PCI: pci_link: clear driver_data before free

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix races between perfcnt and reset sequence

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Introduce a reset lock

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Skip cache flush/invalidate when enabling perfcnt

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Move perfcnt GPU disable sequence into a helper

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Move lock and modparam initialisations into their subsystems

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Explicitly enable MMU interrupts at device init

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Move shrinker initialization and unplug one level down

Ali Ahmet Memiş <aliamemis@disroot.org>
    ALSA: control_led: Fix deadlock between sysfs writes and card disconnect

Kaifeng Wang <kaifengw@google.com>
    net: devmem: check uid and netns in net_devmem_get_binding()

Stanislav Fomichev <sdf.kernel@gmail.com>
    net: devmem: embed net_iov_area in binding

Stanislav Fomichev <sdf.kernel@gmail.com>
    net: devmem: replace gen_pool with freelist

Mikulas Patocka <mpatocka@redhat.com>
    dm-snapshot: make the chunk list sorted by the chunk number

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix out-of-bounds read in kprobe_multi link info dump

Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
    selftests/namespaces: Wait for thread exit via pidfd in active-ref tests

Alexei Starovoitov <ast@kernel.org>
    bpf: Reject BTF ids with the same address in tracing_multi link

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    RDMA/mlx5: Cancel software CQ notifications before teardown

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    RDMA/mlx5: Cancel deferred page-fault EQ work before teardown

Ting-Han Hou <ue081723@gmail.com>
    ALSA: virtio: reset I/O message fill level on prepare

Cen Zhang <zzzccc427@gmail.com>
    ALSA: timer: Pin the module for userspace timer controllers

Kees Cook <kees@kernel.org>
    seq_buf: Do not pop from an overflowed seq_buf

Kees Cook <kees@kernel.org>
    seq_buf: Do not print an empty line from an overflowed seq_buf_do_printk()

Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
    powerpc/kasan: fix r2 corruption in mem*() on GENERIC_ENTRY with old compilers

Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
    powerpc: fix NMI exit ordering: restore soft masks after irqentry_nmi_exit()

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: qcom-ipcc: remove stray disable_irq_wake() call

Linkai Gong <gonglinkai@kylinos.cn>
    mailbox: arm_mhuv2: time out if the receiver never comes up

Beleswar Padhi <b-padhi@ti.com>
    mailbox: ti-msgmgr: Read exact number of trailing message bytes

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: arm_mhu_db: Remove redundant mbox_controller_unregister() on probe failure

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: qcom-ipcc: Remove redundant mbox_controller_unregister() on probe failure

Breno Leitao <leitao@debian.org>
    mailbox: pcc: Free the channel before unmapping the shared memory

Swark Yang <syang@axiado.com>
    mailbox: axiado: fix debugfs name truncation warning

Swark Yang <syang@axiado.com>
    mailbox: axiado: fix RX frame draining and error handling

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Preserve the LCPA I/O address space

Sang-Hoon Choi <csh0052@gmail.com>
    xhci: dbc: lock the minor IDR on registration failure

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf, riscv: Fix stack-passed arguments for indirect trampolines

Jacob Moroni <jmoroni@google.com>
    RDMA/core: Clear driver_udata before destroying objects in rdma_core

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Fix recv repost to satisfy ib_drain_rq

Maksim Krasutski <krasutskimaksim@gmail.com>
    ALSA: hda/realtek: Fix mute LEDs on HP ENVY 17-cr1xxx

Ali Ahmet Memiş <aliamemis@disroot.org>
    ALSA: seq: Wait for one RCU grace period when deleting all ports

Kees Cook <kees@kernel.org>
    kbuild: Mark the initcall ordering recipe as recursive

Rahul Pon <theflyingrahul@gmail.com>
    drm/msm/a8xx: report the GMEM size of the active slices

Binglei Wang <l3b2w1@gmail.com>
    erofs: fix xattrs handling when metadata compression is used

Matthew Wood <thepacketgeek@gmail.com>
    bpf, arm64: Fix racy plt target update in bpf_arch_text_poke()

Maxim Skokov <skokovmaksimevg@gmail.com>
    bpf: test_run: Fix false -EBADMSG after skb leaves CHECKSUM_COMPLETE

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: remove FRL GPIO for 100ASK DshanPi A1

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add NULL check for the driver pointer at unsol event work

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Stop unsol event and jack polling at hda-ext device removal, too

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Disable unsol event handling at error and shutdown paths

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Stop unsol events and jack polling before codec unbind

Tony Luck <tony.luck@intel.com>
    fs/resctrl: Ensure default group reports tasks on monitor-only systems

Guixin Liu <kanie@linux.alibaba.com>
    cxl/pci: Update only the Port GPF timeout fields

Dave Jiang <dave.jiang@intel.com>
    cxl/port: Attach endpoints to a dport under the lock that pins it

Dave Jiang <dave.jiang@intel.com>
    cxl/core: Hold the dport host lock across dport lookup and use

Ting-Han Hou <ue081723@gmail.com>
    scripts/make_fit: Ignore schema checks when decomposing DTBs

Ting-Han Hou <ue081723@gmail.com>
    clang-tools: Import os for broken pipe handling

Leizhen Zhang <lzsx618@gmail.com>
    kconfig: fix infinite loop in conf_choice() when no choice value is visible

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Save DFS postorder numbers for program instructions

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Fix arg_track_xfer() for atomic stack spills and fills

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Size liveness stack masks by the stack each frame uses

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Widen the stack slot index in the jump history

Jiale Yao <yaojiale02@163.com>
    vfio/pci: Drain eventfd RCU callbacks on module exit

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Gate the host bridge whitelist warning on verbose

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Safely terminate ACS redirect lists

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Wait for RCU readers before freeing state

Leon Romanovsky <leon@kernel.org>
    PCI/P2PDMA: Do not tear down the allocate attribute on registration failure

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-direct: Restore arch_dma_alloc() for the DMA_ATTR_NO_KERNEL_MAPPING case

Antoni Pokusinski <apokusinski01@gmail.com>
    rtc: abx80x: properly handle shared IRQs

Antoni Pokusinski <apokusinski01@gmail.com>
    rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()

Qiliang Yuan <odys.yuan@gmail.com>
    selftests: ublk: make the fault_inject delay a pure timeout

Qiliang Yuan <odys.yuan@gmail.com>
    selftests: ublk: don't keep the fault_inject timespec on the stack

Leo Cheng <leo-cheng@vip.qq.com>
    nvmem: layouts: onie-tlv: fix device_node reference leak in error path

Leo Cheng <leo-cheng@vip.qq.com>
    nvmem: layouts: sl28vpd: fix device_node reference leak in error path

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: use link address as TA for non-MLO 4-addr station on MLD AP

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: reg: protect regdb pointer with RCU

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix mbssid/rnr allocation in beacon data

Aloka Dixit <aloka.dixit@oss.qualcomm.com>
    wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: limit injected HT/VHT MCSes

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: init radiotap iter after length checks

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: reject zero RNR/MBSSID elements

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: kill wake_txqs_tasklet on unregistration

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: use hlist_add_head_rcu()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: clear fragment cache entry 'is_protected'

Johannes Berg <johannes.berg@intel.com>
    wifi: ath6kl: don't take RTNL in del_virtual_intf

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: intel: Cancel delayed work at shutdown, too

Takashi Iwai <tiwai@suse.de>
    ASoC: fsl_asrc_m2m: Fix bogus compress task pointer assignments

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Fix potential OOB write in line6_capture_copy()

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Reject too small max packet sizes

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: us16x08: Fix racy accesses of mixer elements

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix data race at mixer_ctl_feature_info()

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix races at MIDI URB and trigger accesses

Karl Mehltretter <kmehltretter@gmail.com>
    gpu: buddy: Drop the stale @p line from the gpu_buddy_print() kernel-doc

Jan Beulich <jbeulich@suse.com>
    x86/PVH: don't truncate initrd address/size

Gui-Dong Han <hanguidong02@gmail.com>
    xen/blkback: Prevent missed completion when draining I/O

Ruoyu Wang <ruoyuw560@gmail.com>
    xen/pcifront: Fix PCI device reference leak in AER handling

Yury Norov <ynorov@nvidia.com>
    lib: fix lock initialization in region allocation benchmark

Haotian Zhang <vulab@iscas.ac.cn>
    cpufreq: qcom-cpufreq-hw: fix device node refcount leak in phandle parsing

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: configure ENST registers for all queues

Eric Dumazet <edumazet@kernel.org>
    bng_en: pad short frames before sampling nr_frags

Jake Labelle <southampton.jake.labelle@gmail.com>
    nilfs2: reject non-regular inodes in dsync recovery

Michał Kopeć <michal@nozomi.space>
    ASoC: mediatek: mt8188: Constrain UL8 FE to its back end's capabilities

Michał Kopeć <michal@nozomi.space>
    ASoC: mediatek: Don't keep a freed topology name in the static card

Michał Kopeć <michal@nozomi.space>
    ASoC: mediatek: common: Keep codec references until the card is bound

Rosen Penev <rosenp@gmail.com>
    crypto: talitos - init tasklets before requesting IRQs

George Abraham P <george.abraham.p@intel.com>
    crypto: qat - force an edge when re-enabling all VF2PF interrupts

Vincent Jardin <vjardin@free.fr>
    crypto: caam/qi,qi2 - set plain_keylen for skcipher descriptors

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Don't free card at probe error in vga_switcheroo handler

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Avoid non-operational GPU warning at regular device removal

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use linked list for jack table

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix leaks at snd_card_init() error paths

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Avoid a bad mixure of guard() and goto

Takashi Iwai <tiwai@suse.de>
    ALSA: info: Fix memory leak at card removal

Takashi Iwai <tiwai@suse.de>
    ALSA: pcmtest: Fix leak at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing direction and ump_group handling in 32bit compat ioctl

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add missing barriers for power_ref vs card->shutdown

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix mixer bitmap cache over 32 channels

Takashi Iwai <tiwai@suse.de>
    ALSA: pcmtest: Fix a bogus pointer read in snd_pcmtst_pcm_pointer()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix potential UAF for gating jack

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Drop the bogus RCU guard from clientptr()

Marek Maslanka <mmaslanka@google.com>
    platform/chrome: cros_ec_typec: Poll for role swap completion

Chen-Yu Yeh <chenyou910331@gmail.com>
    riscv: dts: sophgo: cv180x: Fix internal ephy node name

Felix Hoffmann <f3lix.dev@gmx.de>
    wifi: mm81x: validate YAPS receive framing

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TX coalesce race and div-by-zero in XDP/legacy path

Dmitry Morgun <d.morgun@ispras.ru>
    fs/ntfs3: check return values in indx_delete_entry()

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Handle a malformed _DSM result in acpi_attr_is_visible()

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Stop reporting _DSM failures as -EPERM

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8365: Handle constraint return value in FE startup

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Handle constraint return value in FE startup

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: Handle constraint return value in FE startup

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: common: Handle constraint return value in FE startup

Melissa Wen <mwen@igalia.com>
    drm/amd/display: copy function name into dcn_optc_lock_unlock_state trace event

Melissa Wen <mwen@igalia.com>
    drm/amd/display: copy function name into dcn_fpu trace event

Melissa Wen <mwen@igalia.com>
    drm/amd/display: use right type for amdgpu_dc_performance event entries

Melissa Wen <mwen@igalia.com>
    drm/amd/display: declare amdgpu_dm_atomic_state_template as an event class

Melissa Wen <mwen@igalia.com>
    drm/amd/display: fix vready offset assignment in dcn_optc_lock_unlock_state

Melissa Wen <mwen@igalia.com>
    drm/amd/display: remove duplicated prev_p_state_change_support assignment

Melissa Wen <mwen@igalia.com>
    drm/amd/display: assign missing trace entry in amdgpu_dm_dc_clocks_state

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Fix TAS2781/TAS5825 PPC version logic conflict

Wentao Liang <vulab@iscas.ac.cn>
    clocksource/drivers/timer-econet-en751221: Fix clock reference leak

Ting-Han Hou <ue081723@gmail.com>
    checkkconfigsymbols.py: Parse Git status output line by line

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: keep beacons from queueing the scan work during an abort

John Crispin <john@phrozen.org>
    wifi: mt76: scan all radios of a request at the same time

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt792x: compute the assoc RSSI from the chain signals

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7921: fix of_node reference leaks in regd update

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: report an aborted scan or ROC to mac80211 during a reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: refuse scan and ROC until the hardware restart is done

Karl Mehltretter <kmehltretter@gmail.com>
    kobject: Fix the kobj_set_name reference in kset_register() kernel-doc

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_i2s: Handle runtime PM resume failures in set_fmt

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_sai: Handle runtime PM resume failures in set_fmt

John Crispin <john@phrozen.org>
    wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix the hw-queues debugfs queue requests

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: fix PLE free page and AC queue register offsets

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7996: do not add a station link in disconnected state

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: keep 4-address and decap state per station

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: add the station BMC entry as new once per BSSID

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: keep a returning link when adding station links fails

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: do not reuse the deflink of a removed station link

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: make a returning link primary if a station has none

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: pick the secondary link from links with driver state

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: free the WTBL index if a link allocation fails

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: clear all link wcid entries in sta_pre_rcu_remove

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: report station statistics from the primary link

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: upload only the keys of the link being set up

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: find the last MLD link among the links torn down

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: size the MLD setup TLV by the links it describes

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: update the address of an AP link that is added again

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: set sniffer mode on a radio that is already running

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: enable the SKU power limit table

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: abort a scan only for a link change on the scanning radio

Eason Lai <eason.lai@mediatek.com>
    wifi: mt76: mt7925: Fix MCU command timeouts during module unload

Mahesh Saran <maheshsaran477@gmail.com>
    wifi: mt76: mt7921: clear WM2 from MT7902 RX all_complete_mask

Cristian Papa <pcristian292@gmail.com>
    wifi: mt76: feed the station RSSI average from the chain signals

Slavin Liu <bolin.liu@seu.edu.cn>
    wifi: mt76: mt7996: guard station-only MLO TX handling

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: mt76: mt7615: validate MCU response lengths

Ahmed Naseef <naseefkm@gmail.com>
    wifi: mt76: mt7615: read MT7663 temperature from the correct offset

Ethan Tidmore <ethantidmore06@gmail.com>
    wifi: mt76: mt7925: Remove useless condition

Ryan Leung <untilscour@protonmail.com>
    wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()

Chris Scott <gilroyscott1970@gmail.com>
    wifi: mt76: mt7996: refresh the tx BA session timer on NPU devices

Cristian Papa <pcristian292@gmail.com>
    wifi: mt76: mt7603: don't drop short frames looped back on PS entry

Ryan Leung <untilscour@protonmail.com>
    wifi: mt76: mt7915: fix thermal zone use-after-free

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: usb: fix source overread in mt76u_copy

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt792x: defer the MCU shutdown past unregister on USB

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt7925: keep the join ROC until the station is authorized

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt7921: keep the join ROC until the station is authorized

Andrei Rusu de Castro <arc@empyreal.works>
    wifi: mt76: mt7925: keep MLD membership consistent during link add

Arnd Bergmann <arnd@arndb.de>
    wifi: mt76: mt7996: add NET_AIROHA dependency

Jiale Yao <yaojiale02@163.com>
    wifi: mt76: mt76x02: validate RX padding before use

Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
    wifi: mt76: connac2: fill TXD spe_idx for connac2 fixed-rate frames

Ryan Leung <untilscour@protonmail.com>
    wifi: mt76: fix wcid teardown ordering in mt76_reset_device()

Ryan Leung <untilscour@protonmail.com>
    wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()

Ryan Leung <untilscour@protonmail.com>
    wifi: mt76: mt7915: publish wcid before MCU add commands

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: honour FIF_FCSFAIL instead of hardcoding drop_err

Mark Anthony Agarro <markanthonyagarro@gmail.com>
    wifi: mt76: mt7925: honour mac80211's FIF_FCSFAIL instead of hardcoding drop_err

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: fix the lock inversion in suspend and resume

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: fix the lock inversion in suspend and resume

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx

Jacobs Wu <jacobs.wu@mediatek.com>
    wifi: mt76: mt7925: fix HT/VHT caps and rates for NAN NDP peers

Jacobs Wu <jacobs.wu@mediatek.com>
    wifi: mt76: mt7925: support deferred NAN schedule update and cluster events

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: configure NAN PHY setting on enable

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: add ULW event handling and peer ULW update

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: clear CRB before deactivating NAN peer record

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: fill all DW intervals in NAN avail_map

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: replace NAN DW end event with DW start

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: share TLV setup for NAN enable command

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: use OFDM-only PHY mode for NAN STA records

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: drop deferred NAN local schedule update handling

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: drop unused NAN 2.4/5 GHz support config

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: report only 2.4 GHz NAN supported band

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: fix NAN committed CRB timeline layout

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: fix NAN start failure

Stella Liu <yu-ching.liu@mediatek.com>
    wifi: mt76: mt7925: fix NAN NDP STA record role index

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: bound RRO session id before indexing addr_elem[]

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: guard firmware memory dump write on disabled memdump

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: validate firmware event lengths before parsing

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: check default EEPROM firmware size before copying

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: clear offchannel state if a scan has no channel to restore

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: check the owner of a remain-on-channel request

Jiale Yao <yaojiale02@163.com>
    pinctrl: sprd: free maps on DT map failure

Leizhen Zhang <lzsx618@gmail.com>
    gen_init_cpio: stop parsing on lines with a missing argument list

Michael Petlan <mpetlan@redhat.com>
    perf test attr: Fix wrong size expectation for events

Michael Petlan <mpetlan@redhat.com>
    perf test attr: Propagate the return value from the test to the wrapper

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Allow zero-length packet handling for EP1

Priyank Rathod <rathodpriyank@google.com>
    PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()

Muhammad Bilal <meatuni001@gmail.com>
    wifi: mm81x: check bytes_remaining before reading delimiter

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: mm81x: validate n_channels in disabled channels response

Samuele Yang <samuele.yang@morsemicro.com>
    wifi: mm81x: start beaconing on beacon enable not interface add

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mm81x: move beacon work and init below the tx op

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: reject inconsistent xattr bucket during defrag

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: allow xattr bucket entries to span multiple blocks

Andrei Vagin <avagin@google.com>
    proc: report SIGEV_NONE in /proc/pid/timers if target task has died

Wilson Felipe Pereira <wfelipe@google.com>
    init/main: fix false-positive kernel panic on environment variable overwrite

Wilson Felipe Pereira <wfelipe@google.com>
    init/main: fix off-by-one in argv_init cleanup

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: defer suballocator block group reclaim to workqueue

Florian Schmaus <florian.schmaus@codasip.com>
    selftests/epoll: fix race condition in multi-waiter wakeup tests

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix deadlock in inline-data truncate transactions

Petr Vorel <pvorel@suse.cz>
    checkpatch: skip CamelCase cache for --no-tree without root

Wilson Felipe Pereira <wfelipe@google.com>
    selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass

Tejun Heo <tj@kernel.org>
    sched_ext: Clear a sub-scheduler's caps before ops.sub_detach()

Karl Mehltretter <kmehltretter@gmail.com>
    rcuref: Fix the rcuread_is_dead reference in rcuref_read() kernel-doc

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/ACPI: Centralize pcie_ports_native checking

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/ACPI: Tidy _OSC control bit checking

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix link count underflow when removing corrupted directory

Georgios Androutsopoulos <georgeandrout13@gmail.com>
    rust: bitmap: document panics in `next_bit` and `next_zero_bit`

Georgios Androutsopoulos <georgeandrout13@gmail.com>
    rust: id_pool: document panics in `find_unused_id` and `release_id`

Roberto Bergantinos Corpas <rbergant@redhat.com>
    NFS: return DENIED in decode_lock_denied if we cannot decode owner

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun4i: sun4i_spi_handler(): fix race condition between transfer completion and RX FIFO interrupt

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun4i: sun4i_spi_transfer_one(): fix setting of clock rate

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun4i: sun4i_spi_fill_fifo(): always apply A10 FIFO fill level workaround

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-sun4i: sun4i_spi_transfer_one(): fix transfers for SUN4I_FIFO_DEPTH

Daniel Drake <dan@reactivated.net>
    drm/vc4: Set DRM DMA device directly from HVS and V3D

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Drop the undocumented brcm,vc4-v3d compatible

Linus Walleij <linusw@kernel.org>
    dt-bindings: dma: dma40: Restore disabled-channels

Jason Gunthorpe <jgg@ziepe.ca>
    efi/libstub: Free cmdline_ptr in efi_pe_entry

Vincent Mailhol <mailhol@kernel.org>
    efi/libstub: make local GUID variables static

Jason Gunthorpe <jgg@ziepe.ca>
    efi/riscv: libstub: Don't set image_size in handle_kernel_image()

Jason Gunthorpe <jgg@ziepe.ca>
    efi/libstub: Fix error unwind freeing fdt in allocate_new_fdt_and_exit_boot()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    sh: defconfig: Enable the current M66592 UDC symbol

Florian Fuchs <fuchsfl@gmail.com>
    sh: uaccess: Require offsettable operands for 64-bit user access

Florian Fuchs <fuchsfl@gmail.com>
    sh: Fix built-in DTB build with generic rule

Aurelien Jarno <aurelien@aurel32.net>
    riscv: fix RVG_SYSTEM_CSR_MASK width mask

Xu Yunxiang <xyx2021@mail.ustc.edu.cn>
    bpf: Destroy callee-local dynptrs on subprog return

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: psp: test that rx-assoc fails on closed and listen socks

Daniel Zahka <daniel.zahka@gmail.com>
    net: psp: drop psp assoc clear in sk_clone()

Daniel Zahka <daniel.zahka@gmail.com>
    net: psp: require an established connection for association setup

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: psp: swap closed for connected sockets in assoc tests

Eric Dumazet <edumazet@kernel.org>
    ipv4: reserve one IP ID per segment for UDP GSO packets

Eric Dumazet <edumazet@kernel.org>
    ipv4: fix IP ID reuse in ip_select_ident_segs()

Chen-Yu Tsai <wens@kernel.org>
    arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine

Chen-Yu Tsai <wens@kernel.org>
    arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine

Mike Snitzer <snitzer@kernel.org>
    pNFS/flexfiles: don't reset to MDS for v4 error when previous layout forbid it

Mike Snitzer <snitzer@kernel.org>
    pNFS/flexfiles: don't read through MDS when previous layout forbid it

Mike Snitzer <snitzer@kernel.org>
    pNFS/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS over the mdsthreshold hint

Scott Gauche <scott-dev@scottgauche.com>
    ALSA: hda/realtek: Fix audio after Windows reboot on ASUS Q423SA

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Validate memcpy configuration

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Validate fixed physical channel indexes

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix V4B event group mapping

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix event group bounds

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix logical channel bounds check

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Reject direction changes after allocation

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Validate DMA specifier length

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Validate disabled channel indexes

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix memcpy channel parsing

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Put the LCPA SRAM node

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix probe LCLA free

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix LCLA allocation order

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix DMA registration unwind

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix probe IRQ leak

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Init hardware before registration

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Return IRQ_NONE when no interrupt is pending

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Handle runtime PM resume errors

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Check runtime PM in IRQ

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix probe runtime PM disable

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix failed start cleanup

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Recover coalesced cyclic callbacks

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix cyclic transfer residue

Linus Walleij <linusw@kernel.org>
    dmaengine: ste_dma40: Fix physical cyclic capability

Roman Demidov <roman.demidov.nn@gmail.com>
    drm/msm/a6xx: check pm_runtime_resume_and_get during resume

Roman Demidov <roman.demidov.nn@gmail.com>
    drm/msm/a6xx: fix use-after-free of OPP in a6xx_pm_resume

Jiale Yao <yaojiale02@163.com>
    wifi: ath12k: Reserve space for a string terminator

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume

Guangshuo Li <lgs201920130244@gmail.com>
    floppy: unregister platform device on add_disk failure

Yang Xiuwei <yangxiuwei@kylinos.cn>
    floppy: avoid NULL deref in reset_interrupt when cont is cleared

Qing Ming <a0yami@mailbox.org>
    dlm: validate node weights before building member array

Karl Mehltretter <kmehltretter@gmail.com>
    floppy: flush pending work before releasing resources on init failure

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: nxpwifi: validate variable IE lengths in beacon parser

Jeff Chen <jeff.chen_1@nxp.com>
    wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    NFS: filelayout: calculate dense stripe width in 64 bits

Chuck Lever <cel@kernel.org>
    SUNRPC: treat every client-side TLS error alert as fatal

Chuck Lever <cel@kernel.org>
    SUNRPC: reject a client-side TLS alert record that is not two octets

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: plx_dma: fix NULL pointer deref in plx_dma_isr()

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: ioat: disable relaxed ordering before registering the device

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: switchtec-dma: fix channel leak on registration failure

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: switchtec-dma: fix resource leak in alloc_chan_resources

Logan Gunthorpe <logang@deltatee.com>
    dmaengine: switchtec-dma: fix double-free in switchtec_dma_free_desc()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/a5xx: don't read the GPMU registers on GPUs without a GPMU

Aloka Dixit <aloka.dixit@oss.qualcomm.com>
    Revert "wifi: mac80211: do not use old MBSSID elements"

Dan Carpenter <error27@gmail.com>
    wifi: carl9170: NUL terminate string in debugfs

Dan Carpenter <error27@gmail.com>
    wifi: b43legacy: debugfs: NUL terminate string in debugfs

Dan Carpenter <error27@gmail.com>
    wifi: b43: don't pass unterminated string to sscanf()

Dominic White <github@singe.za.net>
    wifi: cfg80211: allow zero HE OBSS PD offsets

Karl Mehltretter <kmehltretter@gmail.com>
    ASoC: codecs: es8375: use devm_clk_get_optional() for mclk

Yibo Tan <lhfff@tju.edu.cn>
    soc: qcom: pmic_pdcharger_ulog: prevent work requeue during remove

Neil Armstrong <neil.armstrong@linaro.org>
    soc: qcom: geni-se: provide PROG_RAM_DEPTH for I2C HUB Serial Engines

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    soc: qcom: pmic_glink: Avoid losing early rpmsg probe

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom_scm: align PAS resource table retry

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom_scm: handle empty PAS resource table

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: tzmem: Use DO_ONCE_SLEEPABLE() in qcom_tzmem_enable()

Joonhoe Kim <26rote@gmail.com>
    drm/msm/dpu: round up the compressed INTF width

Xueqin Luo <luoxueqin@kylinos.cn>
    cpufreq: sti: avoid NULL dereference in dev_err()

Xueqin Luo <luoxueqin@kylinos.cn>
    cpufreq: tegra194: fix double-pointer error in get_cpu_ndiv

Xueqin Luo <luoxueqin@kylinos.cn>
    cpufreq: sparc-us2e: fix frequency table index copy-paste error

Karl Mehltretter <kmehltretter@gmail.com>
    svcrdma: Fix svc_rdma_recv_cid_init() kernel-doc

hpp.iscas <hppiscas@163.com>
    perf/marvell: cn10k_tad: Publish the OF module alias

Dennis Gilmore <dennis@ausil.us>
    arm64: dts: rockchip: Use GPIO function for PCIe reset on Orange Pi 5 Pro

Hongyan Xu <getshell@seu.edu.cn>
    ASoC: mt6359-accdet: manage private workqueues with devres

Yaozhong Li <yaozhonguwl@gmail.com>
    arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly

Yaozhong Li <yaozhonguwl@gmail.com>
    arm64: dts: rockchip: fix analog headphone output on rk3399-firefly

Joachim Eastwood <joachim.eastwood@gmail.com>
    arm64: dts: rockchip: fix missing pcie rst pinctrl on rk3588s-nanopi-r6

Joachim Eastwood <joachim.eastwood@gmail.com>
    arm64: dts: rockchip: fix missing sdmmc cd pinctrl on rk3588s-nanopi-r6

Detlev Casanova <detlev.casanova@collabora.com>
    arm64: dts: rockchip: Rename rk3588 HDMI audio cards

Detlev Casanova <detlev.casanova@collabora.com>
    arm64: dts: rockchip: Rename rk3576 HDMI audio card

Detlev Casanova <detlev.casanova@collabora.com>
    arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards

Linus Walleij <linusw@kernel.org>
    ARM: dts: ux500: Use AB8505 charger compatible

Detlev Casanova <detlev.casanova@collabora.com>
    arm64: dts: rockchip: Rename rk3328 HDMI audio card

Jiale Yao <yaojiale02@163.com>
    ASoC: rt722-sdca: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt721-sdca: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt712-sdca: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt711-sdca: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt711-sdw: always cancel jack work on remove

Jiale Yao <yaojiale02@163.com>
    ASoC: rt5682-sdw: always cancel jack work on remove

Marco Giunta <marco_giunta@outlook.it>
    ASoC: aw88399: skip BSTS check when boost converter is bypassed

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_fg: Finalize current measurements

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Recover inactive AB8505 charger

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Retry AB8505 USB detection

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Skip absent AB8505 main charger

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Handle detection errors

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Respect AB8505 register layout

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Decode AB8505 USB status

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_charger: Fix AC charger re-enable

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500: Preserve battery termination current

Linus Walleij <linusw@kernel.org>
    power: supply: ab8500_btemp: Fix event temperature reporting

HyeongJun An <sammiee5311@gmail.com>
    selftests/alsa: Do not take another control's event as our own

Guangshuo Li <lgs201920130244@gmail.com>
    spi: bcm63xx-hsspi: Disable runtime PM on remove

Guangshuo Li <lgs201920130244@gmail.com>
    spi: fsl: unmap immr_spi_cs on remove

Arnd Bergmann <arnd@arndb.de>
    perf: marvell: avoid large stack variables

Ruoyu Wang <ruoyuw560@gmail.com>
    perf/dwc_pcie: Fix PCI device reference leak in probe

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Clear stale overflow status before using a counter

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Don't log through pmu.dev in the overflow interrupt handler

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Validate the hardware-reported counter width

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Unfreeze counters after handling an overflow interrupt

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Don't share the overflow interrupt, and keep it pinned

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Accept an overflow interrupt on MSI message number 0

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Fix the counter overflow delta fixup

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Clear stale event fields before reprogramming a counter

Dave Jiang <dave.jiang@intel.com>
    perf/cxl: Program the requested event group on configurable counters

Alexey Charkov <alchark@flipper.net>
    power: supply: bq257xx: Use psy directly instead of driver data

Jan Stancek <jstancek@redhat.com>
    .gitignore: drop Module.markers

Liviu Nicoara <lnicoara@thinkoid.org>
    power: supply: qcom_battmgr: Report capacity on X1E80100

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Don't rb_erase() a never-inserted stream node

Linus Walleij <linusw@kernel.org>
    dt-bindings: power: supply: ab8500: Add AB8505 charger

Zhihao Cheng <chengzhihao1@huawei.com>
    md: Fix the null-ptr-deref of 'mddev->private' while submitting IO

Ryan Brue <ryanbrue.dev@gmail.com>
    power: supply: bq24190_charger: don't reset registers across system suspend

Chen-Yu Tsai <wens@kernel.org>
    dt-bindings: media: sun4i-a10-video-engine: Fix IOMMU count for H6

Sang-Hoon Choi <csh0052@gmail.com>
    md/raid5: protect big_stripe_tree lookup with RCU

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Handle PHY config after module reload

Linkai Gong <gonglinkai@kylinos.cn>
    clk: imx: composite-93: return timeout from gate enable

Li Youhong <liyouhong@kylinos.cn>
    md/raid5: drain released_stripes before destroying the cache

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    md: take reconfig_mutex when enabling PPL on an inactive array

Shawn Lin <shawn.lin@rock-chips.com>
    phy: rockchip: naneng-combphy: Fix TX detect RX termination errata

David Carlier <devnexen@gmail.com>
    phy: qcom: qmp-pcie: Check clock-output-names count in the multi-PHY driver

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    phy: qcom: qmp-pcie: Refactor common multiphy handling

David Carlier <devnexen@gmail.com>
    phy: qcom: qmp-pcie: Select MFD_SYSCON for the multi-PHY driver

Bruno Banelli <bbanelli@gmail.com>
    phy: spacemit: fix K1 USB 2.0 PHY Kconfig dependencies

Jason Yang <jason98166@gmail.com>
    phy: rockchip-samsung-dcphy: Enable runtime PM at PHY core level

Laurence Oberman <loberman@redhat.com>
    scsi: st: Record the tape position after a successful MTLOAD

Laurence Oberman <loberman@redhat.com>
    scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Advance the write pointer over the data written

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Enforce physical block alignment of zoned writes

Damien Le Moal <dlemoal@kernel.org>
    scsi: scsi_debug: Use combined sense codes

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: Prepare for using combined sense codes

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: Rename sense field of struct scsi_failure

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: Define all additional sense codes and their qualifiers

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Avoid 32-bit overflow in WRITE SCATTERED offsets

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Take the zone metadata lock before the data lock

Niklas Cassel <cassel@kernel.org>
    scsi: scsi_debug: Refuse a negative physblk_exp

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Only enable USB3 when not in high-speed mode

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Handle rk_udphy_reset_deassert errors

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Avoid xHCI SErrors

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Rename mode_change to phy_needs_reinit

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Hold mutex in DP PHY configure

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STATE_USB

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Drop DP HPD handling

Zhang Yubing <yubing.zhang@rock-chips.com>
    phy: rockchip: usbdp: Support single-lane DP

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Add missing mode_change update

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Limit DP lane count to muxed lanes

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Drop seamless DP takeover

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Handle missing clock-names DT property gracefully

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Fix devm_clk_bulk_get_all check

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Do not lose USB3 PHY status

Sebastian Reichel <sebastian.reichel@collabora.com>
    phy: rockchip: usbdp: Update mode_change after error handling

Akash Sukhavasi <akash.sukhavasi@gmail.com>
    phy: HiSilicon: Fix error handling in hi3670_pcie_allclk_ctrl()

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Roll back freplace link state when bpf_arch_text_poke() fails

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm3x: fix inconsistencies with sysfs configuration

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm3x: Prohibit modifying cntr_val while session is enabled

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix inconsistencies with sysfs configuration

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: prohibit modifying cntr_val while session is enabled

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: Prohibit TRCSEQSTR modifications while tracing enabled

Joonhoe Kim <26rote@gmail.com>
    drm/msm/dpu: compute the CRTC bandwidth from the state being checked

Joonhoe Kim <26rote@gmail.com>
    drm/msm/dpu: disable the slave encoder before the master

Oleg Keri <okerixx@gmail.com>
    drm/msm/dp: don't report link training success after a reinit

Yuho Choi <dbgh9129@gmail.com>
    soc/tegra: flowctrl: Release OF node reference on error

Igor Velkov <iav@iav.lv>
    arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz

Igor Velkov <iav@iav.lv>
    arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins

Hal Feng <hal.feng@starfivetech.com>
    riscv: dts: starfive: Correct pwm nodes

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: resctrl: Don't stop early when tearing down a class

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Switch to kvzmalloc_objs() for allocation of component cfg

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Don't loop forever if there is the maximum possible amount of PARTIDs

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: resctrl: Make read_mon_cdp_safe() self consistent

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: resctrl: Correct check that existing class is L3

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Initialize all of struct mon_read in mpam_restore_mbwu_state()

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Use __ris_msmon_read() for saving MBWU state

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Ensure MBWU counters are reset on restore

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Add missing mon_sel locking in MBWU save and restore

Ben Horgan <ben.horgan@arm.com>
    arm_mpam: Set mpam_feat_msmon_mbwu_31counter when there are bandwidth counters

James Clark <james.clark@linaro.org>
    perf python: Track linked libraries as extension dependencies

Mostafa Saleh <smostafa@google.com>
    iommu/arm-smmu-v3-test: Fix UBSAN error

Mostafa Saleh <smostafa@google.com>
    iommu/arm-smmu-v3-test: Fix OOB in arm_smmu_v3_invs_test_verify()

Mostafa Saleh <smostafa@google.com>
    iommu/arm-smmu-v3-test: Add missing error checks for inv array

Mostafa Saleh <smostafa@google.com>
    iommu/arm-smmu-v3-test: Fix arm_smmu_v3_test_debug_print_used_bits()

Mostafa Saleh <smostafa@google.com>
    iommu/arm-smmu-v3: Ensure L2 tables are visible before L1 ptrs

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Add sleepable arena page allocation path

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Add sleepable argument to bpf_alloc_pages()

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Use an llist for page allocations

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: arena: Allocate the fault-in page outside the lock

Yuri Zaporozhets <yuriz@vodafonemail.de>
    ASoC: dwc: Use OF match data again for StarFive JH7110

Junhui Liu <junhui.liu@pigmoral.tech>
    riscv: dts: spacemit: k3: Replace incorrect CLINT node with ACLINT nodes

Junhui Liu <junhui.liu@pigmoral.tech>
    dt-bindings: timer: sifive,clint: Remove spacemit,k3-clint

James Morris <jmorris@namei.org>
    riscv: dts: spacemit: k3-com260: keep dldo4 enabled

Aurelien Jarno <aurelien@aurel32.net>
    riscv: dts: spacemit: k3: move USB3 phy to board level

Matthias Goergens <matthias.goergens@gmail.com>
    isofs: return long Joliet names whole

Jennifer Berringer <jberring@redhat.com>
    riscv: dts: spacemit: set console baud rate on OrangePi RV2

Slavin Liu <bolin.liu@seu.edu.cn>
    clocksource/drivers/dbx500-prcmu: Check timer register mapping

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    clocksource/drivers/timer-ti-dm: Register clocksource/event only for am654

Thorsten Blum <blum@kernel.org>
    hwrng: intel - return -ENOMEM when ioremap() fails

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Avoid dereference with max_src_size=0

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: ftrtc010: fix integer overflow in time calculation

Arnd Bergmann <arnd@arndb.de>
    drm/panel: fix novatek-nt36536 dependencies

Thorsten Blum <blum@kernel.org>
    hwrng: intel - return -ENOMEM when kmalloc_obj() fails

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: tcrypt - Avoid reading req->base after submission

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: atmel - handle authenc requests without plaintext

Bartosz Szpila <bszpila@google.com>
    platform/chrome: cros_ec_typec: Validate SVID and mode counts in discovery data

Hemanth Selam <hemanth.selam@gmail.com>
    nvdimm/pmem: Release gendisk on probe failure

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Rework the BMC state pulled from the capabilities message

Kris Pan <kris.pan@intel.com>
    net: iterate online nodes in skb_defer_free_flush()

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    arm64: dts: ti: var-som-am62p: Fix wkup R5F memory region size

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    arm64: dts: ti: k3-am62p5-sk: Fix wkup R5F memory region size

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    arm64: dts: ti: k3-am62p-verdin: Fix wkup R5F memory region size

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    arm64: dts: ti: k3-am62a7-sk: Fix wkup R5F memory region size

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    arm64: dts: ti: k3-am62d2-evm: Fix wkup R5F memory region size

Markus Schneider-Pargmann (TI) <msp@baylibre.com>
    arm64: dts: ti: k3-am62a-phycore-som: Fix wkup R5F memory region size

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Drop reference on postfence

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Don't pass an ERR_PTR to drm_syncobj_replace_fence()

Mikko Perttunen <mperttunen@nvidia.com>
    drm/tegra: Fix syncobj_in wait return value check

Mikko Perttunen <mperttunen@nvidia.com>
    ARM: tegra: Add core supply for Tegra114 boards

Lance Yang <lance.yang@linux.dev>
    mm/memory_hotplug: fix missing rollback in __add_pages()

Chuanhong Guo <gch981213@gmail.com>
    pinctrl: mediatek: mt7629: fix the 2.4 GHz Wi-Fi pin mode array

Kate Hsuan <hpa@redhat.com>
    media: i2c: imx471: Fix register size for IMX471_REG_DPGA_USE_GLOBAL_GAIN

Thiébaud Weksteen <tweek@google.com>
    rust: macros: allow non-ASCII characters in `authors`

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq: amd-pstate: Propagate cppc_set_auto_sel() errors on mode change

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq: amd-pstate: Restore previous mode when changing driver mode fails

Bjorn Helgaas <bhelgaas@google.com>
    PCI: tegra264: Fix Link Capabilities register offset

Arnd Bergmann <arnd@arndb.de>
    drm/amd/display: fix unused function warnings

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amd/ras: use __le32 pointer type to resolve the sparse warnings

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/userq: fix reading the WPTR at a non-zero BO offset

Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
    drm/amd/display: Enable dcn42 pstate pmo

Bjoern Doebel <doebel@amazon.de>
    selftests/rdma: Skip rxe_sent_rcvd_bytes when rdma_rxe is missing

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Fix zero dlg_reg write to program_ext_vblank

Ian Rogers <irogers@google.com>
    perf thread_map: Add thread_map__tgid()

Ian Rogers <irogers@google.com>
    perf trace: Copy sockaddr arguments by their length

Lu Yao <yaolu@kylinos.cn>
    drm/amdkfd: drop KFD_QUEUE_TYPE_DIQ note

Danish Khateeb <danishkhateeb03@gmail.com>
    pps: generators: wake up PPS_GEN_FETCHEVENT readers on unregister

Shuming Fan <shumingf@realtek.com>
    ASoC: rt712: avoid duplicate reset in io_init

Yichong Chen <chenyichong@uniontech.com>
    debugfs: make debugfs_create_str() read-only

Yichong Chen <chenyichong@uniontech.com>
    soundwire: debugfs: replace writable string helper

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mei: vsc-tp: initialize IRQ state before requesting interrupt

Ruoyu Wang <ruoyuw560@gmail.com>
    misc: nsm: fix CBOR short-length decoding

Jasper Wise <jaspwise@amazon.co.uk>
    misc: nsm: mark device ready before registering the hwrng and misc device

Linkai Gong <gonglinkai@kylinos.cn>
    misc: enclosure: fix UAF on device_register() failure

Sechang Lim <rhkrqnwk98@gmail.com>
    sched: Set TIF_NEED_RESCHED before calling __trace_set_need_resched()

Nam Cao <namcao@linutronix.de>
    rv/rtapp/wakeup: Use "rv_this" the rv_monitor variable

Wen Yang <wen.yang@linux.dev>
    rv: Use LD_WAIT_SPIN as the reactor lockdep wait type

Omar Ramadan <omar@blockcast.net>
    amt: pull the AMT header behind the transport header in amt_parse_type()

Yuya Kusakabe <yuya.kusakabe@gmail.com>
    seg6: fix HMAC validation when an extension header precedes the SRH

Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
    media: rcar-isp: ispcore: Fix inconsistent step sizes

Christopher Snowhill <chris@kode54.net>
    media: em28xx: hold the vb2 queue lock when releasing the queue on close

Cong Nguyen <congnt264@gmail.com>
    staging: media: tegra-video: fix syncpoint leak in tegra20 channel init

Mateusz Nowicki <mateusz.nowicki@posteo.net>
    arm64: dts: st: fix sai3b unit address on stm32mp231

Mateusz Nowicki <mateusz.nowicki@posteo.net>
    arm64: dts: st: fix sai3b unit address on stm32mp251

Danish Khateeb <danishkhateeb03@gmail.com>
    serial: 8250: Fix section mismatch with CONFIG_MODULES=n

Nathan Chancellor <nathan@kernel.org>
    serial: 8250_mid: Add missing module namespace import for SERIAL_8250

Weigang He <geoffreyhe2@gmail.com>
    ARM: vexpress: fix device_node refcount leak in vexpress_smp_dt_prepare_cpus()

Weigang He <geoffreyhe2@gmail.com>
    ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: ftrtc010: use devm clock APIs to fix use-after-disable in remove

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: ftrtc010: fix clock resource leak on probe failure

Chancel Liu <chancel.liu@nxp.com>
    pinctrl: pinctrl-generic-mux: Fix provider resource leak on re-parse

Ze Huang <ze.huang@oss.qualcomm.com>
    drm/imx/lcdc: avoid duplicate clk_per enable

Karl Mehltretter <kmehltretter@gmail.com>
    OPP: Fix the return value in dev_pm_opp_get_of_node() kernel-doc

Lucas Costa <2000.costalucas@gmail.com>
    staging: sm750fb: free cmap on framebuffer release

Xilin Wu <sophon@radxa.com>
    drm/msm/dp: Initialize the debugfs connector pointer

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/mdp5: drop cursor pipe for msm8x76

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    dt-bindings: display/msm: hdmi: Correct name of disallowed supplies

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    drm/msm: Properly handle msm_ioremap() without name

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: Zerorize dmb at allocation

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Use drm_timeout_rel_to_jiffies()

Maíra Canal <mcanal@igalia.com>
    drm: Add drm_timeout_rel_to_jiffies()

Maíra Canal <mcanal@igalia.com>
    drm: Move drm_timeout_abs_to_jiffies() to drm_timeout.c

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: kaanapali: Add GCC CX power domain

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: size ring stats arrays from the final queue count

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: rebuild ring stats arrays instead of reallocating them in place

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: extract ice_vsi_get_num_qs()

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: extract ice_vsi_new_stat_arrays()

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: extract __ice_vsi_free_stats()

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: skip stats handling for channel VSIs on rebuild

Lu Yao <yaolu@kylinos.cn>
    drm/amd/display: Fix wrong plane index in dcn6 writeback latency loop

Qingfang Deng <qingfang.deng@linux.dev>
    ARM: mvebu: fix Cortex-A9 errata selection for Armada 38x

Matthias Goergens <matthias.goergens@gmail.com>
    x86/hibernate: Ignore page-zero RAM in E820 checksum

Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
    dt-bindings: vendor-prefixes: Add Sophos

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: check for overflow in malloc()

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: stop rounding malloc() sizes up to 4096 bytes

Tianyi Chen <hi@tychen.cc>
    perf sched stats: Reject mismatched or incomplete snapshots

Leo Yan <leo.yan@arm.com>
    perf build: Build the Python extension before pylint consumers

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Use cpuset_v2() in cpuset_num_cpus()

Michal Pluta <michalpl2003@gmail.com>
    perf symbol: Don't return an unterminated Rust demangle buffer

Michal Pluta <michalpl2003@gmail.com>
    perf test demangle: Fail when demangling fails

Seongjae Jeong <jsjlee1020@gmail.com>
    f2fs: reject device aliasing without a multi-device configuration

Arnd Bergmann <arnd@arndb.de>
    f2fs: quota: fix unused-label warning

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: set 'qpic_version2' flag

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix UAC2 mixer unit request handling

Andreas Kemnade <andreas@kemnade.info>
    rtc: bd70528: properly enable wakeup

Nguyễn Văn Cao Nguyên <nguyennvc@greennode.ai>
    RDMA/irdma: Do not move a fresh RoCE QP to ERROR on RESET

Nicolas Schier <n.schier@fritz.com>
    kconfig: tests: Provide defconfig outfile for savedefconfig

Nicolas Schier <n.schier@fritz.com>
    kconfig: tests: Reset all KCONFIG_* env variables by default

Wentao Liang <vulab@iscas.ac.cn>
    pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()

Wentao Liang <vulab@iscas.ac.cn>
    pinctrl: nuvoton: Fix clock reference leak in ma35_get_bank_data()

Hongyan Xu <getshell@seu.edu.cn>
    RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit

Hongyan Xu <getshell@seu.edu.cn>
    RDMA/hfi1: shut down the trap timer before unregistering

Crystal Wood <crwood@redhat.com>
    rtla/tests: Use absolute path for $RTLA

Sasha Levin <sashal@kernel.org>
    RDMA/selftests: Fix the kernel config fragment

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/siw: Fix length of first chunk in siw_try_1seg()

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Validate peer-supplied IO completion msg_id

Alireza Haghdoost <haghdoost@uber.com>
    perf symbols: Don't let a module's last symbol overlap the next module

Nicolas Schier <nsc@kernel.org>
    kbuild: Mark usr_gen_init_cpio as no-dot-config-target

Qingshuang Fu <fuqingshuang@kylinos.cn>
    selftests/timers: clocksource-switch: Fix unchecked open()/read()

Abdifatah Suruur <suruurism@gmail.com>
    vfio/cdx: prevent read-only region mappings from becoming writable

Abdifatah Suruur <suruurism@gmail.com>
    vfio/fsl-mc: prevent read-only region mappings from becoming writable

Abdifatah Suruur <suruurism@gmail.com>
    vfio/platform: prevent read-only region mappings from becoming writable

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Don't WARN on unexpected info-response opcode

Karl Mehltretter <kmehltretter@gmail.com>
    time: Prevent time64_to_tm() day truncation on 32-bit

Jiale Yao <yaojiale02@163.com>
    RDMA/cxgb4: Do not allow userspace to write the status page

Jiale Yao <yaojiale02@163.com>
    RDMA/mlx4: Do not allow the user to write to the clock page

Jiale Yao <yaojiale02@163.com>
    RDMA/mad: Reject receive completions shorter than GRH

Ian Rogers <irogers@google.com>
    perf pmu: Fix race with concurrent tracepoint creation and removal in perf list

Ian Rogers <irogers@google.com>
    perf python: Initialize debug output on module load

Ian Rogers <irogers@google.com>
    perf evsel: Clamp sample_id size for ksymbol, bpf, and text_poke events

Abhijit Gangurde <abhijit.gangurde@amd.com>
    RDMA/ionic: Fix double removal of CMB mmap entries in create QP error path

Abhijit Gangurde <abhijit.gangurde@amd.com>
    RDMA/ionic: Fix XArray initialization to use XArray flags

Norbert Szetei <norbert@doyensec.com>
    RDMA/rxe: Reject prefetch of a non-ODP MR

Binbin Deng <18983559317@163.com>
    RDMA/rxe: unpublish the per-net tunnel socket before

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Reject invalid queue_depth from the peer

Yili Zhang <zhangyili01@baidu.com>
    RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE

Pengpeng Hou <hppiscas@163.com>
    clk: si5351: fail prepare when PLL reset times out

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: validate spread spectrum configuration

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    powerpc/interrupt: Use early_radix_enabled() in NMI real-mode guard

Abhishek Dubey <adubey@linux.ibm.com>
    powerpc/bpf: Move out dummy_tramp_addr after Long branch stub

Abhishek Dubey <adubey@linux.ibm.com>
    powerpc64/bpf: fix compare instruction emitted for tailcall

Myeonghun Pak <mhun512@gmail.com>
    clk: ti: adpll: unregister OF clock provider on remove

Danish Khateeb <danishkhateeb03@gmail.com>
    pwm: Allow 32-bit tasks to use the character device

Dairui Zhang <zhangdairui@gmail.com>
    IB/mad: fix UAF and double-free in RMPP receive reassembly

Sachin Kumar Garg <sachin.garg@oss.qualcomm.com>
    media: iris: cache work mode after computing it in iris_set_stage

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: reference count video instances

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: reject open() when the session limit is reached

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: guard against a NULL hfi_sys_ops in the interrupt handler

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: take core lock when scanning the instance list

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    media: iris: fail firmware boot on invalid uc_region

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    Revert "media: iris: Add Gen2 firmware autodetect and fallback"

Malte Wechter <maltewechter@gmail.com>
    rnull: configfs: add power to configfs features

Hungyu Lin <dennylin0707@gmail.com>
    media: iris: cancel sys error work on driver removal

Ruoyu Wang <ruoyuw560@gmail.com>
    media: venus: Drop session events without an instance

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the PD and DPI table size

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Serialize dcb_wq access against async notifier

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Validate SRQ max_sge at create time

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Detect wrong sge_len passed for inline

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix integer overflow in send payload size computation

Jeff Chen <jeff.chen_1@nxp.com>
    wifi: nxpwifi: fix return value check in change_vif_to_sta/ap

Finn Thain <fthain@linux-m68k.org>
    swim3: Fix FDEJECT ioctl for exclusive open

Finn Thain <fthain@linux-m68k.org>
    swim: Fix FDEJECT ioctl for exclusive open

Finn Thain <fthain@linux-m68k.org>
    swim: Return -EROFS when opened with BLK_OPEN_WRITE flag

Logan Odell <loganodell@google.com>
    PCI/IOV: Read VF config values that need not match PF

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx95-15x15-frdm: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93-11x11-evk: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8dxl-sr-som: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93-9x9-qsb: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93-14x14-evk: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93-11x11-frdm: fix reserved memory node names for remoteproc

Joseph Guo <qijian.guo@nxp.com>
    arm64: dts: imx93-11x11-frdm: factor out common parts into dtsi

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8ulp-evk: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8qxp-mek: fix dsp reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8qxp-mek: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8qm-mek: fix dsp reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8qm-mek: fix reserved memory node names for remoteproc

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8dxl-evk: fix reserved memory node names for remoteproc

Li RongQing <lirongqing@baidu.com>
    IB/isert: Don't share drop_cmd_list across concurrent connection teardowns

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: fix read location register usage in qcom_spi_config_cw_read()

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only

Xiang Mei (Microsoft) <xmei5@asu.edu>
    fs/ntfs3: fix slab-out-of-bounds write in attr_insert_range()

Karl Mehltretter <kmehltretter@gmail.com>
    soc: ti: k3-ringacc: Fix DMA ring initialization kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    soc: ti: k3-ringacc: Correct ring API kernel-doc

Ian Rogers <irogers@google.com>
    perf vendor events intel: Fix snowridgex umask encoding.

Ian Rogers <irogers@google.com>
    perf vendor events intel: Fix skylakex umask encoding.

Ian Rogers <irogers@google.com>
    perf vendor events intel: Fix sierraforest umask encoding.

Ian Rogers <irogers@google.com>
    perf vendor events intel: Fix lunarlake umask encoding.

Ian Rogers <irogers@google.com>
    perf vendor events intel: Fix clearwaterforest umask encoding.

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin-zinnia: Fix main_gpio0/main_gpio1 line names size

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin-ivy: Fix main_gpio0/main_gpio1 line names size

Ian Rogers <irogers@google.com>
    perf build: Clean libperf-gtk.so in 'make clean'

Ian Rogers <irogers@google.com>
    perf test code-reading: Fix duplicate kernel maps and machine leak

Benoît Monin <benoit.monin@bootlin.com>
    perf build: Improve fix for "argument list too long" error

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192-mt6359: Fix error handling in MTKAIF calibration

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate errors in I2S DAI DAPM event handlers

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate errors in TDM DAI DAPM event handlers

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate mt8192_afe_gpio_request() errors in ADDA DAI

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: switch to devm_clk_get_optional()

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix MCK clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix error handling in APLL enable functions

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix AFE clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8192: fix APLL mux error handling

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    spi: rspi: Fix DMA mode when the DMA controller is built as a module

Leo Yan <leo.yan@arm.com>
    perf test: Record kcore for the CoreSight callchain test

Niko Huuskonen <niko.huuskonen.00@gmail.com>
    ALSA: caiaq: Fix the Kore controller key map

Niko Huuskonen <niko.huuskonen.00@gmail.com>
    ALSA: caiaq: Serialize access to the EP1 command buffer

Arka Mondal <arka@arkamondal.net>
    iio: dac: ad5758: Fix the offset calculation

Arka Mondal <arka@arkamondal.net>
    iio: dac: ad5758: Reject out-of-range raw values

Arka Mondal <arka@arkamondal.net>
    iio: dac: ad5758: Fix alignment for DMA safety

Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
    staging: iio: adc: ad7816: Protect sysfs attributes with mutex

Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
    staging: iio: adc: ad7816: Serialize SPI operations

Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
    staging: iio: adc: ad7816: Sort headers alphabetically

Ariana Lazar <ariana.lazar@microchip.com>
    iio: dac: mcp47feb02: protect EEPROM store sequence with mutex

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    dt-bindings: iio: adc: renesas,r9a09g077-adc: Drop unwired interrupts

Yilin Chen <1479826151@qq.com>
    rust: configfs: require thread-safe callback data

Andreas Hindborg <a.hindborg@kernel.org>
    rust: block: implement `Send` and `Sync` for `TagSet`

Fuad Tabba <fuad.tabba@linux.dev>
    of/irq: Fix device node refcount leak in of_check_msi_parent()

Chen-Yu Tsai <wenst@chromium.org>
    drm/exynos/fimd: fix register offset type in fimd_trigger()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: via82xx: use helper to activate DXS controls

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: oxygen: use helper to activate the SPDIF PCM control

Yibo Tan <lhfff@tju.edu.cn>
    ASoC: amd: acp3x-es83xx: Keep an owned codec device reference

Yibo Tan <lhfff@tju.edu.cn>
    ASoC: amd: acp-es8336: Use an owned codec device reference

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set QP event handler before firmware QPC insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set RQ event handler for raw-packet QP

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set SRQ event handler before xarray insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Set WQ event handler before firmware RQ insertion

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent

Yishai Hadas <yishaih@nvidia.com>
    RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access

Yishai Hadas <yishaih@nvidia.com>
    RDMA/hns: Pin CQ buffer writable to match device DMA write access

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/irdma: Free IRQ when CEQ vector mapping fails

Ginger Li <ginger.jzllee@gmail.com>
    wifi: mac80211: Fix a race when expiring a mesh path

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    wifi: mac80211: implement NAN non-evacuable channels

Andrei Otcheretianski <andrei.otcheretianski@intel.com>
    wifi: cfg80211: add NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS

Mateusz Nowicki <mateusz.nowicki@posteo.net>
    arm64: dts: st: fix arm,smc-id of the SMC watchdog on stm32mp2

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix IQE handling to cover all descriptors in submission range

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Drop old iopf ref only after attach succeeds

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix iopf refcount leak in nested attach

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Reserve scalable-mode DIDs from PASID entries during copy

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Handle DID reservation errors when copying context tables

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Do not ignore context table copy failures

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Fix page table level calculation in compute_vasz_lg2_ss()

Johannes Berg <johannes.berg@intel.com>
    um: time-travel: fix sched_yield() behaviour

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: glymur-asus-zenbook-a16: Remove RTC-through-EFIvars

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: sm8150: Use SM8150_CX for the SDHC power domain

Myeonghun Pak <mhun512@gmail.com>
    PCI: aardvark: Disable PHY on probe failures

Xin Liu <xin.liu@oss.qualcomm.com>
    arm64: dts: qcom: hamoa-iot-evk: use on-board crystal for PS8830 retimers

Xin Liu <xin.liu@oss.qualcomm.com>
    arm64: dts: qcom: purwa-iot-evk: use on-board crystal for PS8830 retimers

Phil Sutter <phil@nwl.cc>
    netfilter: nfnetlink: Fix for interrupted hook dumps

Linus Walleij <linusw@kernel.org>
    ARM: dts: gemini: Use a level-high interrupt for TVE200

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: fix reset of ct seqadj when reopening a connection

Sasha Levin <sashal@kernel.org>
    kbuild: keep .modinfo when vmlinux is linked with --gc-sections

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    kbuild: do not allocate .modinfo in vmlinux

Nathan Chancellor <nathan@kernel.org>
    kbuild: Remove alignment on .modinfo section

Sam Day <me@samcday.com>
    drm/msm/a3xx: fix VBIF halt mask for A306/A306A

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix RPMH dependency votes

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix secondary rail vote in ARC votes

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Honor perfmode_bw threshold on A8x

Daniel Palmer <daniel@0x0f.com>
    m68k: apollo: Fix interrupt setup

Hui Su <sh_def@163.com>
    perf synthetic-events: Check schedstat domain allocation failure

Jie Zhang <jie.zhang@oss.qualcomm.com>
    dt-bindings: display/msm/gmu: Fix Glymur's compatible

Shashank Mohan Jain <jain.sm@gmail.com>
    bitmap: bitmap_parselist(): don't wrap around on a huge group size

Shashank Mohan Jain <jain.sm@gmail.com>
    bitmap: bitmap_parselist(): reject trailing characters after group size

Shashank Mohan Jain <jain.sm@gmail.com>
    bitmap: bitmap_parse(): reject non-hex character before 8 digits

Alexandra Lu <alexandra.lu@nokia.com>
    bus: mhi: host: pci_generic: Fix runtime PM imbalance for no_m3 devices

WangYuli <wangyuli@uniontech.com>
    MIPS: dec: Add missing <linux/interrupt.h> inclusion to reset.h

WangYuli <wangyuli@uniontech.com>
    MIPS: Only check -msym32 when need-compiler

Orgad Shaneh <orgads@gmail.com>
    MIPS: Octeon: size the swiotlb for a modular OHCI platform driver

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: fix FD_SET(), FD_CLR() and FD_ISSET() on 64-bit

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: fix readdir_r() with 64-bit directory offsets

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Serialize AHIT register access between sysfs and host driver

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Always notify POST_CHANGE even on gear switch failure

Tony Luck <tony.luck@intel.com>
    x86/resctrl: Update documented unit for the "activity" event

Eric Dumazet <edumazet@kernel.org>
    net: synchronize proc_do_rss_key() with netdev_rss_key_fill()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Skip zero-length stream writes

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Clear the insn array used flag with release semantics

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Clear insn array jitted pointers on map reuse

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Don't remove indirect jump targets in the nop removal pass

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Leave out the hidden exit edge of a subprogram without an exit

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Rebase the exception callback subprog when dead subprogs are removed

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Bound the number of indirect jump edges in a program

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Avoid quadratic successor rescan in bpf_compute_scc

Vinayak Katoch <vinayak.katoch@oss.qualcomm.com>
    arm64: dts: qcom: agatti: Add memory-region for audio PD

Aaron Kling <webgeek1234@gmail.com>
    dt-bindings: vendor-prefixes: Add Retroid Pocket

Adam Skladowski <a39.skl@gmail.com>
    dt-bindings: vendor-prefixes: Add LeEco

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: msm8974: add MDSS reset

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    arm64: dts: qcom: qcs8300-ride: fix SerDes PHY regulator supplies

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    arm64: dts: qcom: monaco-evk: fix SerDes PHY regulator supplies

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    arm64: dts: qcom: lemans-ride-common: fix SerDes PHY regulator supplies

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    arm64: dts: qcom: lemans-evk: fix SerDes PHY regulator supplies

Andrei Vagin <avagin@google.com>
    x86/fpu: Fix potential underflow in xstate_calculate_size()

Bruno Produit <bruno.produit@trailofbits.com>
    hfs/hfsplus: serialize B-tree close against folio release

Paul Sajna <sajattack@postmarketos.org>
    arm64: dts: qcom: sdm845-lg: fix sdcard pinctrl nodes

Aaron Kling <webgeek1234@gmail.com>
    dt-bindings: vendor-prefixes: Add Chip Wealth Technology

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8183: Fix APLL enable error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8183: Fix clock handling in mux disable path

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure

Sudeep Holla <sudeep.holla@kernel.org>
    ACPI: PCC: Free channel on OpRegion deactivation

Sudeep Holla <sudeep.holla@kernel.org>
    ACPI: PCC: Preserve shared memory signature in OpRegion handler

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate-data: Resolve type DIEs in the debug file they came from

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dwarf-aux: Add die_same_file() and die_get_type_die()

Sudeep Holla <sudeep.holla@kernel.org>
    ACPICA: Fix PCC OperationRegion command offsets

Breno Leitao <leitao@debian.org>
    ACPICA: Fix memory leak in acpi_ds_create_field()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test workload: Use unsigned int in code_with_type instead of uint

Abel Vesa <abel.vesa@oss.qualcomm.com>
    dt-bindings: clock: qcom: sm8750-gcc: Add CX power domain

Xin Yin <yinxin.x@bytedance.com>
    writeback: size foreign flushes by target wb dirty pages

Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
    wifi: ath12k: fix out-of-bounds access on TX stats arrays

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: avoid double DMA unmap of held monitor RX buffers

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix skb leak on monitor PPDU ID wraparound

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: free pending MSDUs on duplicate mon link descriptor

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop

Arnd Bergmann <arnd@arndb.de>
    ASoC: amd: acp: add EFI dependency for selecting TAS2783

Abel Vesa <abel.vesa@oss.qualcomm.com>
    clk: qcom: gcc-qcs615: Fix GCC_CPUSS_GNOC_CBCR offset

Qingfang Deng <qingfang.deng@linux.dev>
    mtd: block: prevent reclaim I/O during request processing

Nia Su <nia.su@sifive.com>
    perf evlist: Don't restrict uncore events to PMU CPUs

Jiebin Sun <jiebin.sun@intel.com>
    perf tests c2c: Report skip when the workload fails

Jiebin Sun <jiebin.sun@intel.com>
    perf c2c: Fix documented default coalesce fields

Muzaffer Kadir <muzafferkadir@mainlining.org>
    dt-bindings: vendor-prefixes: Add General Mobile

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1p42100-thinkbook-16: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-hp-omnibook-x14: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-dell-thena: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-asus-zenbook-a14: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-asus-vivobook-s15: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1e80100-qcp: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: medion-sprchrgd-14-s1: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1e80100-yoga-slim7x: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: honor-magicbook-art-14: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1e80100-dell-xps13-9345: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1e78100-t14s: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1e001de-devkit: Mark the EC reset gpio as reserved

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: x1-crd: Mark the EC reset gpio as reserved

Charlie Garner <charlie@akao.au>
    arm64: dts: qcom: x1e80100-dell-inspiron-14-plus-7441: fix touchscreen i2c address

Alex Williamson <alex.williamson@nvidia.com>
    vfio: Reject a second cdev open before mutating shared device state

Ian Rogers <irogers@google.com>
    perf machine: Add session back pointer to fix out of bounds read

Yibo Tan <lhfff@tju.edu.cn>
    sysctl: unregister tables before freeing bitmap

Michael J. Ruhl <michael.j.ruhl@intel.com>
    platform/x86/intel/pmt: complete pcidev to device update

Sandipan Das <sandipan.das@amd.com>
    perf jevents: Limit the number of JSON reading workers

Joanne Koong <joannelkoong@gmail.com>
    fuse: zero the correct range on a short read reply

Tengda Wu <wutengda@huaweicloud.com>
    perf llvm: Fix memory leak of args->fileloc in symbol__disassemble_llvm()

Hao Sun <sunhao.th@gmail.com>
    bpf: Fix uninit read for helper mem args on partially spilled slots

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/ftrace: Don't restore r13 during ftrace_regs_caller

Hao Sun <sunhao.th@gmail.com>
    bpf: Fix uninit read for non-fetch atomics on partially spilled slots

Rob Herring (Arm) <robh@kernel.org>
    dt-bindings: arm: mediatek: Fix MT6779 audsys compatible

Pengpeng Hou <hppiscas@163.com>
    iio: accel: bma220: publish the SPI driver ACPI alias

Alexei Starovoitov <ast@kernel.org>
    bpf: Don't converge a loop on an iterator that was created anew

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Add accessors for verifier stack slots

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix overflow of jump offset in may_goto expansion

Alexei Starovoitov <ast@kernel.org>
    bpf: Adjust pc-relative insn copied into its own patch

Alexei Starovoitov <ast@kernel.org>
    bpf, x86: Fix timed may_goto with private stack

Myeonghun Pak <mhun512@gmail.com>
    spi: rockchip-sfc: skip DMA cleanup in PIO mode

Jiawen Liu <1298662399@qq.com>
    spi: rockchip-sfc: disable runtime PM in remove

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: fsl_asrc_m2m: fix pm_runtime usage counter leak on error

James Clark <james.clark@linaro.org>
    perf buildid-list: Fix empty output for AUX data

Jens Remus <jremus@linux.ibm.com>
    perf evsel: Improve callchain warning for s390

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: fix clk leak on error in audsys_clk_register

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: mt8188-afe-pcm: Handle runtime resume errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: mt8188-afe-clk: Handle clock enable errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: mt8188-afe-clk: Propagate regmap update errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8188: mt8188-afe-clk: Handle tuner clock enable errors

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5665: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5660: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5659: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt5616: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1318: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1308: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1305: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1016: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1011: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: nau8540: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: es8323: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: es8316: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: ak4642: return cache sync errors from resume

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: adau17x1: return cache sync errors from resume

Slavin Liu <bolin.liu@seu.edu.cn>
    ASoC: fsl_asrc: check the second front-end DMA channel

Pu Lehui <pulehui@huawei.com>
    bpf: Adjust bpf_func to account for CFI offset in bpf_jit_free on riscv

Puranjay Mohan <puranjay@kernel.org>
    bpf: Look at frame 0 when telling async callback entries apart

Wei Huang <wei.huang2@amd.com>
    PCI/TPH: Validate the firmware Steering Tag response

Chuck Lever <cel@kernel.org>
    NFS: use TCP for MOUNT when xprtsec= selects TLS

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: fix verrx() and errx() message formatting

Syed Saba Kareem <Syed.SabaKareem@amd.com>
    ASoC: amd: acp: fix TAS2783 SoundWire codec unmet dependencies

Thomas Falcon <thomas.falcon@intel.com>
    perf mem: Fix size tracking for mem_lvl's in perf_script__meminfo_scnprintf()

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: use regmap_write_bits to update clock source registers

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check fastcall stack contract once for all stack accesses

Dmitrii Tulnov <tulnov.dl@gmail.com>
    kconfig: warn about malformed KCONFIG_PROBABILITY values

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Preallocate hardware context schedulers

Matteo Kloiber <kernel@matt3o12.de>
    rust: scatterlist: honor the device's maximum segment size

Florian Fainelli <florian.fainelli@broadcom.com>
    um: Add definition of __NR_close_range for older host OSs

Myeonghun Pak <mhun512@gmail.com>
    mfd: da9150: Balance IRQ wake on teardown

Myeonghun Pak <mhun512@gmail.com>
    mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock

Eric Anderson <ejona86@gmail.com>
    mfd: rk8xx: Register poweroff handler in atomic phase

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: cs42l43: Move cancel_work_sync() into remove

Jiale Yao <yaojiale02@163.com>
    ext2: drain in-flight DIO before buffered write fallback

Karl Mehltretter <kmehltretter@gmail.com>
    iommufd: Fix iommufd_hw_capabilities reference in kernel-doc

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a09g087: Drop unwired ADC interrupts

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a09g077: Drop unwired ADC interrupts

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: ironhide: Align inline ECC carveout sizes with bootloader settings

Rong Zhang <i@rong.moe>
    leds: class: Remove hardware control trigger when writing brightness

Rong Zhang <i@rong.moe>
    leds: trigger: Move led_trigger_is_hw_controlled() to the right place

Rong Zhang <i@rong.moe>
    leds: class: Always protect brightness_show() with led_access

Hui Su <sh_def@163.com>
    bpftool: Fix sparse CPU IDs in prog profile

Mykyta Yatsenko <yatsenko@meta.com>
    bpftool: Scale counters and report cycles per run

Mykyta Yatsenko <yatsenko@meta.com>
    bpftool: Group profile events by CPU

Mykyta Yatsenko <yatsenko@meta.com>
    bpftool: Accept zero perf counter snapshots

Hui Su <sh_def@163.com>
    bpftool: Fix CPU IDs in per-CPU map output

Yuan Chen <chenyuan@kylinos.cn>
    bpf: Keep target extended until its last freplace link detaches

Danish Khateeb <danishkhateeb03@gmail.com>
    tools/nolibc: fix WIFSIGNALED() for status 0

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    clk: qcom: fix SM6115 lpasscc register offset

Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>
    clk: qcom: Fix CLK_GLYMUR_GPUCC default and CLK_GLYMUR_EVACC duplicate

Esteban Urrutia <esteuwu@proton.me>
    clk: qcom: alpha-pll: Check Lucid Ole PLL status before configuring

Esteban Urrutia <esteuwu@proton.me>
    clk: qcom: dispcc-sm8450: Fix disp_cc_mdss_mdp_clk_src ops

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: nwgcc-nord: Add video axi clock resets for Nord

Oualid Derouiche <oualid.derouiche@kontron.de>
    arm64: dts: imx8mp-kontron: Fix LVDS clock frequency for DL device

Vincent Jardin <vjardin@free.fr>
    dt-bindings: vendor-prefixes: add Free Mobile

Georgios Androutsopoulos <georgeandrout13@gmail.com>
    rust: clk: document overflow panics in `Hertz` constructors

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix null deref of link_enc in dce110_enable_tmds_link_output

Fangzhi Zuo <jerry.zuo@amd.com>
    drm/amd/display: Restore FreeSync VCP code check for HDMI/PCON sinks

Fangzhi Zuo <jerry.zuo@amd.com>
    drm/amd/display: Force FreeSync range minimum on quirky panels

Linus Walleij <linusw@kernel.org>
    ARM: dts: ux500: Convert HREF audio to audio-graph-card2

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Move GC v12.1 spm vmid init to hw init

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add workaround to enable GCv12.1 MGCG

Le Ma <le.ma@amd.com>
    drm/amdgpu: disable GFX clockgating for GC 12.1.0

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-quickspi: Use hid_safe_input_report()

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-quicki2c: Use hid_safe_input_report()

Varun Gupta <varun.gupta@intel.com>
    drm/pagemap: Drop ratelimiting from dev_unhold_work debug trace

Zongmin Zhou <zhouzongmin@kylinos.cn>
    serial: sifive: fix off-by-one in console port bounds check

Malathi A <malathi.a2000@gmail.com>
    serial: 8250_uniphier: Use devm_clk_get_enabled()

Myeonghun Pak <mhun512@gmail.com>
    serial: sh-sci: Unregister UART on sysfs setup failure

Stefan Wahren <wahrenst@gmx.net>
    dt-bindings: phy: ti,tcan104x-can: Fix property constrains

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow attributes

Linmao Li <lilinmao@kylinos.cn>
    serial: 8250_mxpcie: take the line settings from the new termios

Linmao Li <lilinmao@kylinos.cn>
    serial: 8250_mxpcie: only unregister the ports that were registered

Linmao Li <lilinmao@kylinos.cn>
    serial: 8250_mxpcie: set the driver data before registering ports

Tate Whiteberg <whiteberg@arista.com>
    serial: 8250_mid: wait for LSR tx empty before setting termios

Tate Whiteberg <whiteberg@arista.com>
    serial: 8250: export and rename wait_for_xmitr()

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    serial: 8250: hub6: Add cleanup code

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    serial: 8250: Fix corner case for port matching

Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
    serial: txx9: Drop noop probe function and dangerous remove callback

Dmitry Sinyavin <sinyavin@gmail.com>
    serial: msm: select PM_OPP

Guangshuo Li <lgs201920130244@gmail.com>
    media: staging/ipu7: release ISYS firmware resources on remove

Ginger Li <ginger.jzllee@gmail.com>
    media: i2c: ov5648: Fix a data race on state->streaming

Finn Thain <fthain@linux-m68k.org>
    swim: Don't search beyond the first data mark

Finn Thain <fthain@linux-m68k.org>
    swim: Revisit delays

Finn Thain <fthain@linux-m68k.org>
    swim: Check drive ready bit

Finn Thain <fthain@linux-m68k.org>
    swim: Deduplicate polling loops

Finn Thain <fthain@linux-m68k.org>
    swim: Remove redundant RELAX actions

Finn Thain <fthain@linux-m68k.org>
    swim: Convert to blocking queue

Finn Thain <fthain@linux-m68k.org>
    swim: Fix buffer overflow

Finn Thain <fthain@linux-m68k.org>
    swim: Don't use the mark register to read data

Finn Thain <fthain@linux-m68k.org>
    swim: Check error register during sector read

Finn Thain <fthain@linux-m68k.org>
    swim: Simplify return value initialization

Finn Thain <fthain@linux-m68k.org>
    swim: Check for CRC errors

Finn Thain <fthain@linux-m68k.org>
    swim: Handle FIFO timeout error

Finn Thain <fthain@linux-m68k.org>
    swim: Add track zero recalibration delay

Finn Thain <fthain@linux-m68k.org>
    swim: Recalibrate when drive is probed

Finn Thain <fthain@linux-m68k.org>
    swim: Don't start motor until medium is present

Finn Thain <fthain@linux-m68k.org>
    swim: Enable clock divider only where appropriate

Finn Thain <fthain@linux-m68k.org>
    swim: Refactor SWIM setup

Finn Thain <fthain@linux-m68k.org>
    swim: Configure parameter memory

Finn Thain <fthain@linux-m68k.org>
    swim: Perform ISM/IWM mode switching according to specs

Finn Thain <fthain@linux-m68k.org>
    swim: Don't disable drive after every sector

Finn Thain <fthain@linux-m68k.org>
    swim: Enable the drive when probing

Finn Thain <fthain@linux-m68k.org>
    swim: Select appropriate drive once only

Finn Thain <fthain@linux-m68k.org>
    swim: Assert strobe with stable outputs

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Guard steering anchor resource destruction on create error

Jiale Yao <yaojiale02@163.com>
    crypto: ccp - kill v5 IRQ tasklet during teardown

Jiale Yao <yaojiale02@163.com>
    crypto: ccp - kill v3 IRQ tasklet during teardown

Muhammad Bilal <meatuni001@gmail.com>
    crypto: ccp - fix SFS ioctl race against device teardown

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - hold cfg->lock when accessing config sections

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix DUP_FIRST crash on unregister

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: starfive - propagate clock and reset errors

Jiawen Liu <1298662399@qq.com>
    crypto: starfive - handle clock enable failures

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwrng: starfive - propagate clock and reset errors

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: asymmetric_keys/pkcs7 - Check all signers before waiving authattrs rejection

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: asymmetric_keys/x509 - copy X.509 TBS for data signature algorithms

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/siw: Fix qp use-after-free in siw_get_base_qp()

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/cxgb4: Fix skb reference leak in rx_pkt()

Wentao Liang <vulab@iscas.ac.cn>
    RDMA/cxgb4: Fix neigh reference leak in rx_pkt()

Slavin Liu <bolin.liu@seu.edu.cn>
    RDMA/irdma: check vport device allocation

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: unwind incomplete receive startup

Kim Wooseok <5mghybrid@khu.ac.kr>
    wifi: rtl8xxxu: free RX skb when URB submission fails

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: correct dependency of the multicolor LED

Mauricio Faria de Oliveira <mfo@igalia.com>
    x86/pvh: Really inline memcmp() and memset() to fix unbootable VMs

Mauricio Faria de Oliveira <mfo@igalia.com>
    x86/asm: Group inline string functions

Mauricio Faria de Oliveira <mfo@igalia.com>
    x86/asm, x86/boot: Carve out inline memcmp() into a separate header

Mauricio Faria de Oliveira <mfo@igalia.com>
    x86/boot: Remove redundant "cc" clobber in memcmp() and document it

Hisam Mehboob <hisamshar@gmail.com>
    vfio: selftests: Include <libgen.h> for basename() on non-glibc builds

Cheng-Yang Chou <yphbchou0911@gmail.com>
    selftests/sched_ext: Fix rt_stall runner abort

Xueqin Luo <luoxueqin@kylinos.cn>
    cpufreq/amd-pstate: Restore previous EPP if profile_name allocation fails

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ASoC: amd: acp3x-es83xx: Switch to use acpi_bus_get_primary_device()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()

Zhijian Han <hanzhijian1991@gmail.com>
    PCI: imx6: Fix resource leaks in probe error paths

Pei Xiao <xiaopei01@kylinos.cn>
    ata: pata_parport: fix parport attach idr_alloc for

Jeremy Bongio <jbongio@google.com>
    RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names size

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am69-aquila: fix AQUILA_B73 gpio-line-names typo

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62l-evm: Remove unnecessary internal pullups for MMC0

Jisheng Zhang <jszhang@kernel.org>
    regulator: mp886x: fix pontential division by zero

Jisheng Zhang <jszhang@kernel.org>
    regulator: mp886x: check get_voltage_sel() return value

Dmitry Antipov <dmantipov@yandex.ru>
    leds: flash: Prevent using uninitialized variable in flash_fault_show()

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Cap the channel current in st1202_led_set()

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Honour max_brightness when blinking

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Clear unused pattern slots in blink_set()

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Do not set brightness from atomic context

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Take a reference on the LED firmware node

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Program the channel current for hardware patterns

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Spell out the phase-shift configuration bit

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Add hardware-accelerated blink support

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Scale pattern brightness to the 12-bit PWM range

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Name pattern index variables consistently

Manuel Fombuena <fombuena@outlook.com>
    leds: st1202: Clear unused pattern slots in pattern_set()

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix erroneous -ENOMEM for large MR registration

Li RongQing <lirongqing@baidu.com>
    RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate-data: Show the sample count in the data-type browser

Cong Nguyen <congnt264@gmail.com>
    leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure

Ian Rogers <irogers@google.com>
    perf build: Remove leftovers of removed build options

Ian Rogers <irogers@google.com>
    perf build: Check the version of the compiler that is used

Ian Rogers <irogers@google.com>
    perf build: Use the given CC rather than clang in clang builds

Ian Rogers <irogers@google.com>
    perf build: Only pass clang flags to CXX when CXX is clang

Ian Rogers <irogers@google.com>
    perf symbol: Fix the build when demangling with libbfd

Ian Rogers <irogers@google.com>
    perf libbfd: Fix the clang -Wthread-safety build failure

Chen Pei <cp0613@linux.alibaba.com>
    perf test: Fix a leaked map reference in the arch dwarf unwind tests

Hui Su <sh_def@163.com>
    perf synthetic-events: Fix schedstat event lifetime handling

Haibo Chen <haibo.chen@nxp.com>
    leds: pca9532: Check i2c_smbus_read_byte_data() return value

Christian Brauner <brauner@kernel.org>
    selftests/coredump: discard the right amount after the coredump request

Miles Krause <mileskrause5200@gmail.com>
    leds: lp8860: Fix device_node leak in lp8860_probe()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()

Yogesh Gaur <yogeshgaur.83@gmail.com>
    md/raid5: give the io_unit slab caches per-array names

Kees Cook <kees@kernel.org>
    randstruct: fix container_of() false positives after __mptr removal

Arnd Bergmann <arnd@arndb.de>
    KMSAN: fix memset() when using fortify-source, again

Jack Wang <jinpu.wang@cloud.ionos.com>
    md: fix mddev_unlock() called without holding lock in lbs_store()

Arnd Bergmann <arnd@arndb.de>
    sfc: fix CONFIG_CXL_MEM dependency

Andrea Parri <parri.andrea@gmail.com>
    pstore: reject persistent RAM zones too small for the buffer header

Andrea Parri <parri.andrea@gmail.com>
    pstore: don't leave an ERR_PTR in the ramoops zone pointer

Adrian Hunter <adrian.hunter@intel.com>
    i3c: Restrict HDR modes to those supported by the bus and target

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Stop rings gracefully when suspending

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Move DMA suspend/resume callbacks

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Process multiple IBIs per interrupt

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix runtime PM violation in i3c_hci_free_ibi()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Restore controller state if i3c_hci_enable_ibi() returns an error

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Match ACPI targets to the correct bus controller instance

Yun Lu <luyun@kylinos.cn>
    selftests/bpf: Clean up child when task_work__open() fails

Arnd Bergmann <arnd@arndb.de>
    bpf: Add printf attributes

Leon Hwang <leon.hwang@linux.dev>
    bpftool: Compute map size of light skeletons at runtime

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    thermal/drivers/renesas/rzg3e: Fix race between set_trips() and get_temp()

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    thermal/drivers/renesas/rzg3e: Fix runtime PM handling of compare irq

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    drivers/thermal/renesas/rzg3e: Fix signed integer overflow in temp_to_code()

Neil Armstrong <neil.armstrong@linaro.org>
    dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.

Geert Uytterhoeven <geert+renesas@glider.be>
    pmdomain: renesas: r8a78000: Fix lockdep false positive

Pengpeng Hou <hppiscas@163.com>
    pmdomain: imx: Propagate SCU provider registration failures

Xiang Mei <xmei5@asu.edu>
    fs/ntfs3: validate $SDH entry size in ntfs_insert_security

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    fs/ntfs3: check INDEX_ROOT resident size before use in ntfs_read_mft()

Frank Wunderlich <frank-w@public-files.de>
    arm64: dts: mediatek: mt7988a-bpi-r4pro: label gpio-hogs

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: SDCA: Check return value on a missing FDL_Set_Index Range

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: SDCA: Improve scanning the SWFT during FDL

Andrew Gaylard <ag@ffroot.co.za>
    pinctrl: fix PINCTRL_SPPCTL=m

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/connector: hdmi: Handle reset() state allocation failure

Daniel Borkmann <daniel@iogearbox.net>
    bpf, lsm: Reject writes into the BPF LSM program context

Slavin Liu <bolin.liu@seu.edu.cn>
    clk: starfive: jh7110: reject oscillator lookup errors

Wentao Liang <vulab@iscas.ac.cn>
    clk: versatile: clk-icst: Fix node reference leak in of_syscon_icst_setup()

Triet Hoang <triet.hoang.dev@gmail.com>
    clk: raspberrypi: Handle cpufreq device registration failure

Karl Asseily <karl@asseily.com>
    dt-bindings: vendor-prefixes: add ESS Technology

Ian Rogers <irogers@google.com>
    perf libbfd: Report success when an address is found

Ian Rogers <irogers@google.com>
    perf dso: Separate libbfd and cmd addr2line caches to fix confusion

Ian Rogers <irogers@google.com>
    perf libdw: Fix Dwfl discovery with split files

Zide Chen <zide.chen@intel.com>
    perf topdown: Don't require config1==0 for a slots event

Alejandro Lucero <alucerop@amd.com>
    ACPI: HMAT: preserve hmat_adist_nb notifier block

Guixin Liu <kanie@linux.alibaba.com>
    cxl/memdev: Fix deadlock between poison debugfs and cxl_mem unbind

Guixin Liu <kanie@linux.alibaba.com>
    driver core: Add conditional guard support for device_trylock()

Felix Gu <ustc.gu@gmail.com>
    spi: mxic: fix ps_clk leak in runtime resume

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Skip digital microphone support on AB8505

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Validate the _CPC package header

Guixin Liu <kanie@linux.alibaba.com>
    cxl/core: Skip einj_inject creation when devm_add_action_or_reset() fails

Guixin Liu <kanie@linux.alibaba.com>
    cxl/region: Create node access attributes for CFMWS-only NUMA nodes

Varun Gupta <varun.gupta@intel.com>
    drm/pagemap: Prevent CPU stalls during unbounded pagemap teardown

Li RongQing <lirongqing@baidu.com>
    RDMA/uverbs: Drop restrack ref on ib_init_ucontext() failure in GET_CONTEXT

Li RongQing <lirongqing@baidu.com>
    RDMA/restrack: Don't set RESTRACK_DD mark after a failed xa_insert()

Li RongQing <lirongqing@baidu.com>
    RDMA/core: Fix swapped list_add_tail() arguments in ib_add_sub_device()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: use 64-bit SMD RPM bus votes

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: msm8976: Configure auxiliary GPU QoS port

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: msm8996: Configure auxiliary Venus QoS port

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: icc-rpm: Program SMD RPM auxiliary QoS ports

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: icc-rpm: Handle icc_link_create() failures

Myeonghun Pak <mhun512@gmail.com>
    interconnect: exynos: Remove the PM QoS request on unbind

Slavin Liu <bolin.liu@seu.edu.cn>
    crypto: atmel-sha - reject initialization without a device

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - fix active_devs leak on crypto alg registration failure

Vitaliy Sochnev <sochnev.v.74@gmail.com>
    thermal/drivers/airoha: Request the EN7581 IRQ after zone registration

Greg Ociepka <greg@ferrisoft.com>
    arm64: dts: qcom: glymur: Mark USB controllers dma-coherent

Guixin Liu <kanie@linux.alibaba.com>
    cxl/region: Unregister the pmem region when the bridge is unbound

Guixin Liu <kanie@linux.alibaba.com>
    cxl/core: Fix dport use-after-free via the einj_inject debugfs file

Guixin Liu <kanie@linux.alibaba.com>
    cxl/port: Fix uninitialized coordinates reported for RCDs

Guixin Liu <kanie@linux.alibaba.com>
    cxl/cdat: Fix uninitialized stack use in bandwidth gathering

Guixin Liu <kanie@linux.alibaba.com>
    cxl/pci: Skip reset detection for DVSEC emulated decoders

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: devlink: describe the netns id in the parent-dev nest

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: devlink: describe DEVLINK_ATTR_NESTED_DEVLINK

Julian Braha <julianbraha@gmail.com>
    kconfig: fix extra output from savedefconfig on out-of-range defaults

Felix Gu <ustc.gu@gmail.com>
    PCI: dra7xx: Fix clock enable leak on probe failure

vladimir.oltean@nxp.com <vladimir.oltean@nxp.com>
    PCI: dra7xx: Remove device links to PHY

Longlong Xia <xialonglong@kylinos.cn>
    rcu: fix shrink budget underflow in lazy_rcu_shrink_scan

Mingpei CAO <caomingpei@gmail.com>
    libbpf: Reject local struct_ops bitfields before data access

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: interrupt-controller: chrp,open-pic: Fix dangling reference

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: interrupt-controller: chrp,open-pic: Typo s/pci/pic/

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: do not fail a sync for a BO with no debug context

Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
    accel/amdxdna: do not warn when a sync request is rejected

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Set HMM_PFN_REQ_WRITE for writable BO faults

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix race between unmap and free BO

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fully initialize map structure before registering notifier

Sean Chang <seanwascoding@gmail.com>
    drm: bridge: dw_hdmi: Fix constant truncation warning on phy_mask

Wentao Liang <vulab@iscas.ac.cn>
    media: ivsc: Fix csi_dev use-after-free in mei_ace_setup_dev_link()

Nikolay Borisov <nik.borisov@suse.com>
    ata: sata_dwc_460ex: Don't enable interrupt if libATA core registration fails

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix redundant NULL check on dc->clk_mgr in dcn42_prepare_bandwidth

Hari Mishal <harimishal1@gmail.com>
    drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters

Hari Mishal <harimishal1@gmail.com>
    drm/amd/pm: bound SCLK FCW range entries to the table size

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: reserve eviction-fence slot at WPTR caller

James Lin <PingLei.Lin@amd.com>
    drm/amd/display: Cast DP DTO pixel clock math to avoid overflow and narrowing

Ian Rogers <irogers@google.com>
    perf record: Fix unhandled POLLHUP on non_perf_event descriptors

Karl Mehltretter <kmehltretter@gmail.com>
    clk: aspeed: ast2700: select AUXILIARY_BUS

Pengpeng Hou <hppiscas@163.com>
    clk: milbeaut: Return divider update timeouts

Pengpeng Hou <pengpeng@iscas.ac.cn>
    clk: si521xx: correct the SI52147 OF output enable map

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf test: Skip data_type_profiling when the PMU cannot record memory events

Francesco Valla <francesco@valla.it>
    spi: virtio: fix max frequency setting

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Validate TDM MCLK frequency

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate TDM clock errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Validate sysclk frequency

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate MCLK errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate APLL errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate runtime resume errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate reg_rw clock errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Validate MCK ID

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate MCK enable errors

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8189: Propagate APLL enable errors

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: fix amd_sof_acp_probe() error unwind ordering

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: fix amd_sof_acp_remove() teardown ordering

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: return -EINVAL for unknown PCI revision in acp7x suspend

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: don't hold kernfs_rwsem across dir_emit()

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: don't repeat or skip an entry when readdir resumes

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: don't hold kernfs_rwsem across notification delivery

Zizhi Wo <wozizhi@huawei.com>
    md/raid5: reject a per-device size smaller than one chunk

Zhihao Cheng <chengzhihao1@huawei.com>
    md/raid5: setup_conf: Fix null-ptr-def in error handling path

Chen Cheng <chencheng@fnnas.com>
    md/raid5: reject raid4/5 arrays with too few disks

Yogesh Gaur <yogeshgaur.83@gmail.com>
    md/raid5: don't BUG() on an inconsistent reshape state from the superblock

Chandradhar Kumar <chandradhar.2003@gmail.com>
    md/raid0: validate device count before allocating devlist

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    md: reject v0.90 arrays with too many devices

Zizhi Wo <wozizhi@huawei.com>
    md/raid10: fix missing wakeup in wait_barrier_nolock

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Wait for links to come up in lwt_ip_encap

Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
    staging: iio: adc: ad7816: Fix DMA safety issues in SPI transfers

Bart Van Assche <bvanassche@acm.org>
    scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp

Ihor Solodrai <ihor.solodrai@linux.dev>
    x86/cpu: Don't transiently clear the boot CPU's capabilities

Ihor Solodrai <ihor.solodrai@linux.dev>
    x86/cpu: Inline generic_identify() into identify_cpu()

Ihor Solodrai <ihor.solodrai@linux.dev>
    x86/cpu: Factor init_cpu_info() out of identify_cpu()

Ștefan Ghețu <stefanghetu9@gmail.com>
    ASoC: SOF: imx: Prevent stack OOB read in DSP panic dump

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: rt1015: make control calibration failures observable

Karl Mehltretter <kmehltretter@gmail.com>
    pinctrl: stm32: Drop the nonexistent CONFIG_MACH_STM32MP25 from the STM32MP257 default

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Bound switch decoder target array access by nr_targets

Alison Schofield <alison.schofield@intel.com>
    cxl/hdm: Restore commit_end when decoder enumeration fails

Alison Schofield <alison.schofield@intel.com>
    cxl/hdm: Make switch decoder target parsing endian-safe

Alison Schofield <alison.schofield@intel.com>
    cxl/hdm: Reject switch decoder interleave ways that overflow targets

Slavin Liu <bolin.liu@seu.edu.cn>
    ACPI: tables: handle failed initrd override mappings

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: eip93 - fix ssl mac bit field definition

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: icc-rpm: Don't skip small votes

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: Move bcm_div() to common code

Sarthak Sharma <sarthak.sharma@arm.com>
    mm/gup_test: report actual pinned bytes

Sarthak Sharma <sarthak.sharma@arm.com>
    mm/gup_test: safely calculate GUP batch size

Baolin Liu <liubaolin@kylinos.cn>
    fs/ntfs3: reject FS_IOC_SETFSLABEL on readonly mounts

Weiming Shi <bestswngs@gmail.com>
    ntfs3: fix out-of-bounds read in ntfs_read_mft()

Nitesh Venkatesh <nitesh.venkatesh@intel.com>
    crypto: qat - allow KPT disable when service is not asym

Luka Gejak <luka.gejak@linux.dev>
    wifi: rtw88: sdio: zero the padding added to a TX transfer

Xueqin Luo <luoxueqin@kylinos.cn>
    platform/x86: Add ACPI_COMPANION() NULL check in topstar_acpi_probe

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-armoury: Prevent disabling dGPU when in use

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: Add ASUS_WMI_DEVID_DGPU_POWER_STATE define

Guangshuo Li <lgs201920130244@gmail.com>
    platform/x86/intel/vsec: reset state before re-enumerating

Karl Mehltretter <kmehltretter@gmail.com>
    loadpin: Fix stale KEXEC_VERIFY_SIG reference in documentation

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: kill tasklet on channel add error path

Yonghao Zhang <hyz3367@gmail.com>
    remoteproc: core: Set trace buffer name for diagnostics

Mika Penttilä <mpenttil@redhat.com>
    drm/tests: hdmi: fix infoframes tests

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix the use of uninitialized variable

Karl Mehltretter <kmehltretter@gmail.com>
    block: Fix the thaw_bdev reference in bdev_freeze() kernel-doc

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: t4ka3: drop unmatched runtime PM put

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: ar0521: remove duplicate media entity cleanup

Maxime Ripard <mripard@kernel.org>
    drm/atmel-hlcdc: Drop spurious csc_init call from reset

Li RongQing <lirongqing@baidu.com>
    RDMA/uverbs: Make CQ handle mandatory for WQ creation

Nicolas Morey <nmorey@suse.com>
    RDMA/rxe: Use validated num_sge in local buffer

Miles Krause <mileskrause5200@gmail.com>
    memory: emif: fix device_node reference leak on np_ddr

Pengpeng Hou <pengpeng@iscas.ac.cn>
    phy: samsung: usbdrd: propagate GS101 PIPE3 lock failures

Gregory CLEMENT <gregory.clement@bootlin.com>
    phy: cadence: Sierra: Do not modify register when getting parent clock

Haotian Zhang <vulab@iscas.ac.cn>
    phy: hisilicon: hi3670: Fix OF node and device reference leaks

Nemesa Garg <nemesa.garg@intel.com>
    drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable

Sang-Heon Jeon <ekffu200098@gmail.com>
    memblock: reject non-page-aligned reserve_mem regions

Linkai Gong <gonglinkai@kylinos.cn>
    firmware: imx: dsp: fix mailbox channel leak on kasprintf failure

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to record both APPEND and UPDATE ino entries

Jianan Huang <jnhuang95@gmail.com>
    f2fs: quota: fix stale lock holder on remount failure

Jérôme Pouiller <jerome.pouiller@silabs.com>
    wifi: wfx: fix use-after-free of the cooling work on device removal

Takahiro Kuwano <takahiro.kuwano@infineon.com>
    mtd: spi-nor: spansion: Remove s25fs256s0

Julius Bairaktaris <julius@bairaktaris.de>
    wifi: mac80211: don't reset the TXQ scheduling round number

Karl Mehltretter <kmehltretter@gmail.com>
    wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc

Christoph Hellwig <hch@lst.de>
    block,iomap: fix protection information verification with initial bvec offset

Karl Mehltretter <kmehltretter@gmail.com>
    dma-fence: Fix dma_fence_enable_signaling() reference in kernel-doc

Conor Dooley <conor.dooley@microchip.com>
    pinctrl: mpfs-mssio: fix whitespace in debugfs output

Fuad Tabba <fuad.tabba@linux.dev>
    arm64: pi: Run the source checker on the libfdt objects under C=2

Thomas Weißschuh <linux@weissschuh.net>
    microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS

Thomas Weißschuh <linux@weissschuh.net>
    microblaze: uaccess: Zero out destination on failed get_user()

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: zero frame pages on read error

Baolin Liu <liubaolin@kylinos.cn>
    fs/ntfs3: update ctime only on successful setxattr

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: take run_lock when freeing offs_folio in ni_decompress_file

Mahe Tardy <mahe.tardy@gmail.com>
    libbpf: fix log level propagation for light skeleton loaders

Karl Mehltretter <kmehltretter@gmail.com>
    regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc

Ian Rogers <irogers@google.com>
    perf header: Fix potential memory corruption in cpu_cache_level__read

Junhui Liu <junhui.liu@pigmoral.tech>
    clk: sunxi-ng: sun55i-a523-r-ccu: Use P-only clocks for timers

Junhui Liu <junhui.liu@pigmoral.tech>
    clk: sunxi-ng: sun55i-a523-ccu: Use P-only clocks for high-speed timers

Junhui Liu <junhui.liu@pigmoral.tech>
    clk: sunxi-ng: sun55i-a523-ccu: Use M-only clocks for MBUS, IOMMU and DRAM

Junhui Liu <junhui.liu@pigmoral.tech>
    clk: sunxi-ng: div: Add feature support to M clock macro

Karl Mehltretter <kmehltretter@gmail.com>
    cgroup/dmem: Fix eviction helper reference in dmem_cgroup_try_charge()

Yonghong Song <yonghong.song@linux.dev>
    bpf: Read a kfunc's __sz argument only when it is in a register

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: video: Fix backlight unregistration ordering

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: fan: Fix memory leak due to leftover devm_kcalloc() argument

Karl Mehltretter <kmehltretter@gmail.com>
    ALSA: control: Fix virtual master creation reference in kernel-doc

Michael S. Tsirkin <mst@redhat.com>
    virtio_pci_modern: move avq cleanup from reset to del_vqs

Michael S. Tsirkin <mst@redhat.com>
    virtio: synchronize callbacks after device reset

Karl Mehltretter <kmehltretter@gmail.com>
    gfs2: Fix the return value in gfs2_get_link() kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    ata: libata-scsi: Fix ata_scsi_hotplug() reference in kernel-doc

Karl Mehltretter <kmehltretter@gmail.com>
    spi: Fix the return value in spi_new_ancillary_device() kernel-doc

Pengpeng Hou <hppiscas@163.com>
    clk: s2mps11: Propagate OF provider registration failures

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: rs9: Add clock index range check to rs9_of_clk_get()

Karl Mehltretter <kmehltretter@gmail.com>
    clk: mediatek: reset: Fix device registration kernel-doc

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    x86/svm: Avoid sign extension of SVM_EVTINJ_VALID in 64-bit expressions

Jared McArthur <j-mcarthur@ti.com>
    arm64: dts: ti: k3-j784s4-j742s2-evm-common: Set ACSPCIe refclk to MAIN_PLL2_HSDIV4 for pcie1

Nora Schiffer <nora.schiffer@ew.tq-group.com>
    ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints

Roshan Kumar <roshaen09@gmail.com>
    drm/pl111: drop alpha formats the hardware cannot scan out

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix program BTF use-after-free in sleepable programs

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp135f-dk

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp157c-ev1

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    ARM: dts: stm32: fix vdda supply for onboard hub on stm32mp15 DK boards

Justin Yeh <justin.yeh@mediatek.com>
    HID: i2c-hid: Unfollow the panel on shutdown

Marek Vasut <marex@nabladev.com>
    ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix unsafe use of handle_mm_fault()

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix potential deadlock in BO open and close callbacks

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Disable BO import via flink

Brian Norris <briannorris@chromium.org>
    PM: runtime: Only queue an idle check for RPM-linked suppliers

Xueqin Luo <luoxueqin@kylinos.cn>
    cpuidle: teo: Do not return a disabled idle state

Aiman Najjar <aiman.najjar@hurranet.com>
    HID: nintendo: add support for PDP Afterglow controller

Alain Volmat <alain.volmat@foss.st.com>
    ARM: dts: stm32: add LTDC / DCMIPP access controller for STM32MP135

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: dts: stm32: fairytux2: change stdout-path baud rate from 9600 to 115200

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: dts: stm32: lxa-tac: change stdout-path baud rate from 9600 to 115200

Ahmad Fatoum <a.fatoum@pengutronix.de>
    ARM: dts: stm32: lxa-mc1: change stdout-path baud rate from 9600 to 115200

Xueqin Luo <luoxueqin@kylinos.cn>
    cpuidle: menu: Do not return a disabled idle state

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: remove unused link field in fw_packet structure

Karl Mehltretter <kmehltretter@gmail.com>
    firewire: cdev: Fix FW_CDEV_IOC_CREATE_ISO_CONTEXT references in kernel-doc

Sumeet Pawnikar <sumeet4linux@gmail.com>
    thermal: gov_power_allocator: Fix NULL pointer dereference in update_tz()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Fix up and adjust acpi_unbind_one()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Rearrange acpi_bind_one() to avoid breakage

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Carry out companion lookup under bus_type_sem

Christoph Hellwig <hch@lst.de>
    block: improve aligning down bios in bio_iov_iter_bounce_write

Christoph Hellwig <hch@lst.de>
    block: cap atomic write size by PI buffer size constraints

Christoph Hellwig <hch@lst.de>
    block: avoid integer overflows in max_integrity_io_size

Jan Kara <jack@suse.cz>
    gfs2: Fix journaled truncate range end offset

Jiawen Liu <1298662399@qq.com>
    memory: exynos5422-dmc: handle clock enable failures

Karl Mehltretter <kmehltretter@gmail.com>
    crypto: lskcipher - preserve state across unaligned chunks

Linmao Li <lilinmao@kylinos.cn>
    crypto: mxs-dcp - handle zero-length skcipher requests

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: rsassa-pkcs1 - reject undersized keys when verifying

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: rsassa-pkcs1 - reject undersized keys when signing

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - release instance on DH fallback allocation failure

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - avoid OOB read when stripping RSA leading zeros

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    crypto: amlogic - Fix DMA memory leak in cipher error path

Thomas Huth <thuth@redhat.com>
    crypto: inside-secure - Zeroize temporary arrays on stack with sensitive data

Eric Dumazet <edumazet@kernel.org>
    ip_tunnel: use WRITE_ONCE in ip_tunnel_encap_setup

Eric Dumazet <edumazet@kernel.org>
    sit: charge ip_tunnel_prl_entry allocations to memcg

Eric Dumazet <edumazet@kernel.org>
    sit: fix UAF in ipip6_tunnel_del_prl()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath9k: use rcu_dereference_bh() for sta->rates in ath_merge_ratetbl()

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: eliza: Connect USB3 PHY pipe clock to GCC

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Disable PMK8350 PON

Karl Mehltretter <kmehltretter@gmail.com>
    cpufreq/amd-pstate: Remove obsolete amd_dynamic_epp documentation

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Propagate mode enable read errors

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Test dedicated enable bits only

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Treat cut 1.0 VAUX3 as fixed

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Handle AB8505 VINTCORE selector 7

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Add AB8505 VAUX3 3.05 V setting

Linus Walleij <linusw@kernel.org>
    regulator: ab8500: Fix AB8505 VANA voltage selectors

Fangzhi Zuo <jerry.zuo@amd.com>
    drm/amd/display: Exit IPS before connector detection on resume

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: glymur-asus-zenbook-a16: Fix up the mic sample rate

Jia Wang <wangjia@ultrarisc.com>
    dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position

Jia Wang <wangjia@ultrarisc.com>
    dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access

Jia Wang <wangjia@ultrarisc.com>
    dmaengine: dw-axi-dmac: Fix AXI burst length encoding

Rosen Penev <rosenp@gmail.com>
    dmaengine: fsl_raid: zero CF descriptor pool allocations

Keisuke Tsukuda <catnyaaan@outlook.com>
    usb: gadget: f_mass_storage: ignore class requests while inactive

Keisuke Tsukuda <catnyaaan@outlook.com>
    usb: gadget: composite: avoid warning on aborted delayed status

Roland Dreier <rolanddreier@rivian.com>
    firmware: arm_scmi: Fix error path leak in scmi_raw_message_send()

Roland Dreier <rolanddreier@rivian.com>
    firmware: arm_scmi: Don't reuse raw xfers with async_done still armed

Roland Dreier <rolanddreier@rivian.com>
    firmware: arm_scmi: Protect xfer->async_done with xfer->lock

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    dmaengine: sprd: use clk_bulk API to fix clock imbalance

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: musb: da8xx: depopulate OF children on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    usb: musb: da8xx: depopulate OF children on remove

Arka Mondal <arka@arkamondal.net>
    usb-storage: alauda: fix out-of-bounds zone index

Arka Mondal <arka@arkamondal.net>
    usb-storage: alauda: check the return value of alauda_read_map()

Arka Mondal <arka@arkamondal.net>
    usb-storage: alauda: do not do DMA from the stack

Binbin Zhou <zhoubinbin@loongson.cn>
    dmaengine: loongson: loongson2-apb-cmc: Fix signedness bug in irq handling

Yuho Choi <dbgh9129@gmail.com>
    USB: pci-quirks: Release EHCI device reference

Jiangong.Han <jiangong.han@windriver.com>
    USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    usb: image: microtek: stop SG processing after transfer errors

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix GID capacity loss in 64K system

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Limit gmv_entry_num to avoid memory waste

Yuho Choi <dbgh9129@gmail.com>
    PCI: xgene: Use managed clock for PCIe controller

Justin Yeh <justin.yeh@mediatek.com>
    arm64: dts: mediatek: mt8188-geralt: Enlarge SCP core0 memory region

Shakeel Butt <shakeel.butt@linux.dev>
    kernfs: fix up the unlocked attribute reads on the creation paths

Karl Mehltretter <kmehltretter@gmail.com>
    efi/libstub: Fix efi_set_event_at() parameter documentation

Salah Triki <salah.triki@gmail.com>
    iio: imu: adis16400: Check return value of spi_setup()

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: accel: kionix-kx022a: Fix IPOL macro name

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix NULL pointer dereference on PCI error recovery

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix use-after-free of the firmware event workqueue

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: zero out diagnostic buffer status memory

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix buffer overflow in the BSG target device map

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds phy array access on link change

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds read of event data

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix target device reference leak in device removal handshake

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds sense buffer access

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds reply frame access

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix buffer overflow when caching log data

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix target device reference leak in BSG task management

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix I/O block counter leak on admin request post failure

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix out-of-bounds read when copying BSG MPI requests

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy

Linmao Li <lilinmao@kylinos.cn>
    power: supply: bq2515x: Propagate charge-enable read errors

Henrik Grimler <henrik.grimler@axis.com>
    dt-bindings: power: bq27xxx: bq27z561: allow interrupts property

Ryan Brue <ryanbrue.dev@gmail.com>
    power: supply: bq24190_charger: use the wake irq API

hpp.iscas <hppiscas@163.com>
    power: supply: mm8013: Publish the OF module alias

Karl Mehltretter <kmehltretter@gmail.com>
    power: supply: mp2629: Use the full batt_impedance_compensation name in the ABI document

Zongmin Zhou <zhouzongmin@kylinos.cn>
    power: supply: s2mu005-battery: return errors from dev_err_probe() in probe

K Prateek Nayak <kprateek.nayak@amd.com>
    cpufreq/amd-pstate-ut: Fix amd_pstate_ut_check_freq failure with 'Requested CPU Min frequency' BIOS option

Willem de Bruijn <willemb@google.com>
    selftests: net: csum: filter packets by source address and port

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: preserve PPDU state across monitor status buffers

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Free allocated external IRQs on request_irq() failure

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Free allocated CE IRQs on request_irq() failure

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix stale skb pointers after aligned TX payload shift

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath12k: fix DMA unwind for ext MSDU descriptor retry

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()

Shuming Fan <shumingf@realtek.com>
    ASoC: rt1320: avoid re-initialize in advanced mode

Qinyun Tan <qinyuntan@linux.alibaba.com>
    iommufd/selftest: Return dmabuf fd from IOMMU_TEST_OP_DMABUF_GET again

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: utils: Adjust message printing macros for ACPI objects

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Rework the success message in acpi_device_notify()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: glue: Reduce debug noise from acpi_device_notify()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: scan: Stop calling acpi_bus_init_power() early

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: Drop parent state update from acpi_device_get_power()

Ian Gallagher <cdine@cdine.org>
    ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: nau8822: keep regcache offline while supplies are off

Vinod Koul <vkoul@kernel.org>
    dmaengine: zynqmp_dma: drop redundant label

Srinivas Neeli <srinivas.neeli@amd.com>
    dmaengine: xilinx_dma: Move descriptors to done list based on completion bit

Srinivas Neeli <srinivas.neeli@amd.com>
    dmaengine: xilinx_dma: Fix MCDMA descriptor fields based on DMA direction

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    dmaengine: dw-axi-dmac: convert clock handling to clk_bulk API

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Fix chan probe/remove error handling

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Free sw_desc_pool on desc_pool_v alloc failure

Golla Nagendra <nagendra.golla@amd.com>
    dmaengine: zynqmp_dma: Fix PM rollback on sw_desc_pool alloc failure

Ruoyu Wang <ruoyuw560@gmail.com>
    dmaengine: img-mdc: Fix runtime PM usage counter leak

Myeonghun Pak <mhun512@gmail.com>
    dmaengine: mediatek: hsdma: fix runtime PM leak on init failure

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: at_hdmac: Fix use-after-free by proper tasklet cleanup

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix use-after-free in error handling paths

Li Youhong <liyouhong@kylinos.cn>
    spi: amlogic-spisg: check clk_prepare_enable() return value

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: sta32x: make power restoration transactional

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: codecs: sma1307: validate setting firmware layout

Ian Rogers <irogers@google.com>
    perf stat: Avoid uninitialized memory read on error

Karl Mehltretter <kmehltretter@gmail.com>
    mtd: spinand: Fix spinand_manufacturer_ops kernel-doc

Mingpei CAO <caomingpei@gmail.com>
    libbpf: Fix array comparison in BTF dedup

Ian Rogers <irogers@google.com>
    perf test: Avoid call to missing cleanup function

Matt Turner <mattst88@gmail.com>
    perf thread: Fix live-session detection in thread__e_machine()

Thomas Richter <tmricht@linux.ibm.com>
    perf test: perf stat tests fails on s390

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/i10nm: Fix Granite Rapids ADXL MC mapping

Tejun Heo <tj@kernel.org>
    cgroup: Make the offline drain interruptible

Tejun Heo <tj@kernel.org>
    cgroup: Return ERR_PTR from cgroup_kn_lock_live()

Tejun Heo <tj@kernel.org>
    cgroup: Return -ENODEV consistently for a dead cgroup

Tianyi Chen <hi@tychen.cc>
    selftests/sched_ext: Handle CPU hotplug write failures

Tianyi Chen <hi@tychen.cc>
    selftests/sched_ext: Fail interrupted test runs

Manush Prajwal <manushprajwal555@gmail.com>
    pwm: lp3943: fix NULL pointer dereference for an unconfigured channel

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt6797: fix wrong unwind order and error code in enable_clock

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8186: Fix MCK error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8186: Fix APLL enable error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8186: Fix AFE clock error handling

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8186: Fix clock handling in mux disable path

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: mediatek: mt8186: Fix APLL mux setting error handling

Bert Karwatzki <spasswolf@web.de>
    mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()

Chen-Yu Tsai <wenst@chromium.org>
    pwm: mtk-disp: Fix period readback

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_ccw: always take irq_lock in the classic interrupt handler

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_ccw: fix synchronize_cbs() after interrupt fallback

Igor Belwon <igor.belwon@mentallysanemainliners.org>
    arm64: dts: mediatek: mt6893-pinfunc: Fix pinctrl header path

Igor Belwon <igor.belwon@mentallysanemainliners.org>
    arm64: dts: mediatek: mt6878-pinfunc: Fix pinctrl header path

Brian Norris <briannorris@chromium.org>
    arm64: dts: mediatek: Add #{address,size}-cells to Chromium-based /firmware

Pengpeng Hou <hppiscas@163.com>
    ASoC: fs210x: report register restore errors

Pengpeng Hou <hppiscas@163.com>
    ASoC: es8389: report resume restore errors

Pengpeng Hou <hppiscas@163.com>
    ASoC: es8375: report resume restore errors

Pengpeng Hou <hppiscas@163.com>
    ASoC: es8326: report resume restore errors

Karl Mehltretter <kmehltretter@gmail.com>
    irqchip/gic-v3-its: Don't WARN on LPI free allocation failure

Linkai Gong <gonglinkai@kylinos.cn>
    drivers/base/node: fix UAF on device_register() failure

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: ma35d1-qspi: Allow DTR operations with the regular SPI API

Varun Gupta <varun.gupta@intel.com>
    drm/xe: Guard page-fault worker with runtime PM check

Surendra Singh Chouhan <kr494167@gmail.com>
    pwm: ipq: Prevent potential 32-bit integer overflow in hi_div calculation

Keguang Zhang <keguang.zhang@gmail.com>
    pwm: loongson: Reload PWM configuration through counter reset

Junhui Liu <junhui.liu@pigmoral.tech>
    riscv: dts: spacemit: k3: Drop guest properties from M-level IMSIC

Karl Mehltretter <kmehltretter@gmail.com>
    ABI: sysfs-class-infiniband: Drop the entries of the removed qib driver

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpio: crystalcove: add missing MODULE_ALIAS()

Leon Romanovsky <leon@kernel.org>
    RDMA/irdma: Preserve fast-registration IOVA on 32-bit

Li RongQing <lirongqing@baidu.com>
    RDMA/nldev: Put the device when dellink fails

Mark Amirkan <markdamirkan@gmail.com>
    perf evsel: Validate RAW sample before byte swapping

Mark Amirkan <markdamirkan@gmail.com>
    perf evsel: Validate branch stack before byte swapping

Aaron Tomlin <atomlin@atomlin.com>
    perf trace: Fix error checking in btf_struct_scnprintf()

Marcel Hofmann <marcel.hofmann@ingenics-digital.com>
    remoteproc: imx_rproc: Allow mappings ending at region boundary

Felix Gu <ustc.gu@gmail.com>
    spi: mtk-nor: fix runtime PM usage count leak in probe error path

Dave Jiang <dave.jiang@intel.com>
    ACPI: APEI: GHES: Bound AER info copy and sanitize software metadata

Dave Jiang <dave.jiang@intel.com>
    ACPI: APEI: GHES: Validate memory error section length before payload access

Dave Jiang <dave.jiang@intel.com>
    efi/cper: Read only validated fields in cper_mem_err_pack()

Dave Jiang <dave.jiang@intel.com>
    ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy

Dave Jiang <dave.jiang@intel.com>
    ACPI: extlog: Defer CXL protocol error handling to avoid lock inversion

Dave Jiang <dave.jiang@intel.com>
    ACPI: APEI: GHES: Bound CXL event record copy to the firmware section length

Dave Jiang <dave.jiang@intel.com>
    ACPI: extlog: Fix CONFIG_ACPI_APEI_PCIEAER guard typo

Dave Jiang <dave.jiang@intel.com>
    ACPI: extlog: Validate PCIe error section length before payload access

Dave Jiang <dave.jiang@intel.com>
    ACPI: extlog: Avoid populating software AER metadata from raw hardware buffer

Dave Jiang <dave.jiang@intel.com>
    ACPI: extlog: Validate elog record length before walking sections

Dave Jiang <dave.jiang@intel.com>
    efi/cper: Reject an error status block length that wraps a u32

Dave Jiang <dave.jiang@intel.com>
    efi/cper: Reject CPER records with an out-of-range error_data_length

Li Youhong <liyouhong@kylinos.cn>
    spi: ma35d1-qspi: assert reset on probe error paths

Jisheng Zhang <jszhang@kernel.org>
    regulator: mp886x: fix vsel_mask

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: use a stack buffer for BBM randomization

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: reserve a full user-data word for BBM

James Hilliard <james.hilliard1@gmail.com>
    mtd: rawnand: sunxi: propagate user-data allocation errors

Sunny Luo <sunny.luo@amlogic.com>
    spi: amlogic: spisg: Fix the incorrect keep_ss of the last descriptor

Xianwei Zhao <xianwei.zhao@amlogic.com>
    spi: amlogic: spisg: Fix transfer size limit and timeout handling

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: make cmdline_contains stricter

Richard Cheng <icheng@nvidia.com>
    cxl/fwctl: Propagate feature RPC delivery errors

Richard Cheng <icheng@nvidia.com>
    cxl/features: Reject feature offset that overflows 16-bit field

Jared McArthur <j-mcarthur@ti.com>
    arm64: dts: ti: k3-j722s-evm: Switch audio codec clock from audio_refclk1 to external clock

Maulik Shah <maulik.shah@oss.qualcomm.com>
    arm64: dts: qcom: purwa: Drop the Hamoa workaround for PDC

Pengpeng Hou <pengpeng@iscas.ac.cn>
    memory: brcmstb_dpfe: validate firmware section sizes

Pengpeng Hou <pengpeng@iscas.ac.cn>
    irqchip/riscv-imsic: Use GENMASK for base address masks

Julius Bairaktaris <julius@bairaktaris.de>
    wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs

Fabrice Derepas <fabrice.derepas@canonical.com>
    crypto: asymmetric_keys - fix OOB read in pefile_parse_binary

Ruoyu Wang <ruoyuw560@gmail.com>
    hwrng: cctrng - Fix runtime PM usage counter leak

Jérôme Pouiller <jerome.pouiller@silabs.com>
    wifi: wfx: fix possible device hang during init

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: drop encap offload frames with a tainted key

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't send encap offload frames unencrypted

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix key selection for encap offload frames

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix unauthorised port check for encap offload

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: don't seed an S1G sta's last_rate

Paul Dolan <paul.dolan.dev@gmail.com>
    selftests/pidfd: fix PPID values in error message

Paul Dolan <paul.dolan.dev@gmail.com>
    selftests/clone3: tighten CLONE_CLEAR_SIGHAND conflict test

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    regulator: pf1550: fix division by zero in the ramp rate selection

Gregor Herburger <gregor.herburger@linutronix.de>
    arm64: dts: broadcom: bcm2712-d-rpi-5-b: add compatible

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: broadcom: bcm2712: adjust display status

Abel Vesa <abel.vesa@oss.qualcomm.com>
    PCI/pwrctrl: tc9563: Allow RESX reset assertion to sleep

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: unregister PM notifier on QMI init failure path

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: fix sporadic WLAN initialization failures

Julius Bairaktaris <julius@bairaktaris.de>
    wifi: ath11k: disable interrupts during firmware crash recovery

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: signal regd update completion when reg event is dropped

Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
    clk: Use the generic OF phandle parsing in only one place

Wenjie Qi <qwjhust@gmail.com>
    f2fs: wait for inode record work before clearing ino bitmaps

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix missing CQE when UD QP use different SL

Manush Prajwal <manushprajwal555@gmail.com>
    leds: max77705: Use fwnode_for_each_child_node_scoped() in max77705_add_led()

Alex Elder <elder@riscstar.com>
    arm64: dts: qcom: qcs8550-rb5gen2: clean up PCI function nodes

Alex Elder <elder@riscstar.com>
    arm64: dts: qcom: qcs6490-thundercomm-minipc-g1iot: clean up PCI function nodes

Alex Elder <elder@riscstar.com>
    arm64: dts: qcom: monaco-evk-ifp-mezzanine: clean up PCI function nodes

Alex Elder <elder@riscstar.com>
    arm64: dts: qcom: lemans-evk-ifp-mezzanine: clean up PCI function nodes

Alex Elder <elder@riscstar.com>
    arm64: dts: qcom: qcs6490-rb3gen2-industrial-mezzanine: clean up PCI function nodes

Alex Elder <elder@riscstar.com>
    arm64: dts: qcom: qcs6490-rb3gen2: clean up PCI function nodes

Rosen Penev <rosenp@gmail.com>
    dmaengine: at_hdmac: fix sparse '__iomem' cast warning in memset helpers

Rosen Penev <rosenp@gmail.com>
    dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources

Rosen Penev <rosenp@gmail.com>
    dmaengine: fsl_raid: don't invoke client callback under desc_lock

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Pass PF/VF number when BAR programming

David Yang <mmyangfl@gmail.com>
    net: dsa: yt921x: Check lock status with lockdep_assert_held_once()

Toke Høiland-Jørgensen <toke@redhat.com>
    libbpf: Move section-defined program flags to prog_flags

Toke Høiland-Jørgensen <toke@redhat.com>
    bpftool: Set BPF_F_XDP_DEV_BOUND_ONLY flag non-destructively

Ionut Nechita <ionut.nechita@windriver.com>
    x86/crash: Reserve elfcorehdr for CONFIG_NR_CPUS, not CONFIG_NR_CPUS_DEFAULT

Melissa Wen <mwen@igalia.com>
    drm/amd/display: use translate_curve_to_degamma_hw_format on DCN30

Tomasz Siemek <Tomasz.Siemek@amd.com>
    drm/amd/display: Refactor DPP_SET_INPUT_TRANSFER_FUNC to drop pipe_ctx

Tomasz Siemek <tomasz.siemek@amd.com>
    drm/amd/display: Refactor HUBP_WAIT_FOR_DCC_META_PROP to drop pipe_ctx

Gaghik Khachatrian <gaghik.khachatrian@amd.com>
    drm/amd/display: gate DCE ASIC code behind CONFIG_DRM_AMD_DC_DCE

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx943: Avoid 32-bit PCIe window System RAM overlap

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx94: Avoid 32-bit PCIe window System RAM overlap

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx95: Avoid 32-bit PCIe window System RAM overlap

Pengpeng Hou <pengpeng@iscas.ac.cn>
    remoteproc: imx_dsp: Acquire runtime PM before adding carveouts

Alexander Aring <aahringo@redhat.com>
    dlm: fix variable key length lookup

Joseph Qi <joseph.qi@linux.alibaba.com>
    dlm: fix buffer overflow from negative len in dlm_search_rsb_tree

Danila Chernetsov <listdansp@mail.ru>
    dlm: fix NULL pointer dereference in dlm_dump_rsb_name()

Danila Chernetsov <listdansp@mail.ru>
    dlm: validate lock modes in recovery messages

Linmao Li <lilinmao@kylinos.cn>
    wifi: mm81x: do not discard a failed firmware segment write

Linmao Li <lilinmao@kylinos.cn>
    wifi: mm81x: free the firmware scratch buffer on parse failures

John Stultz <jstultz@google.com>
    sched: Switch rq->next_class in proxy_reset_donor()

Vasily Gorbik <gor@linux.ibm.com>
    sched/core: Don't proxy-exec unmatched cookie lock owners

Vasily Gorbik <gor@linux.ibm.com>
    sched/core: Don't steal a proxy-exec donor

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fall back to copy_splice_read() on FOPEN_DIRECT_IO

Jingbo Xu <jefflexu@linux.alibaba.com>
    fuse: don't bump attr_version for async direct read completion

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't fill in.h.pid in case args->nocreds is set

Tao Cui <cuitao@kylinos.cn>
    sched_ext/scx_flatcg: Make cgv_node_less() wraparound-safe

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
    wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured

Dan Carpenter <error27@gmail.com>
    wifi: mm81x: fix type bugs handling sdio_readl/writel()

Gongwei Li <ligongwei@kylinos.cn>
    wifi: rtw89: coex: Fix wrong constant check of GPIO MUX signal

Dave Jiang <dave.jiang@intel.com>
    cxl/ras: Pass the PCI device's struct device to match_memdev_by_parent()

Chris Morgan <macromorgan@hotmail.com>
    arm64: dts: rockchip: Correct Device Orientation on Gameforce Ace

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix possible use-after-free when freeing device BO

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix unexpected wait when flushing notifier_wq

Boris Faure <boris@fau.re>
    soundwire: intel: initialise quirk_mask before reading it

Davidlohr Bueso <dave@stgolabs.net>
    cxl/test: Map mock device nodes to an online node

Hans Zhang <18255117159@163.com>
    PCI: cadence: Fix enum type mismatch warning in LTSSM debugfs

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    microblaze: prevent ptrace writes to MSR and pt_mode

Alexander A. Klimov <grandmaster@al2klimov.de>
    microblaze: CCF: fix refcount leak

Jerome Brunet <jbrunet@baylibre.com>
    clk: fix self-consuming provider module pinning

Orgad Shaneh <orgads@gmail.com>
    staging: octeon: schedule the TX cleanup tasklet every 1024th packet

Myeonghun Pak <mhun512@gmail.com>
    staging: rtl8723bs: disable SDIO function on block size failure

Rob Barnes <robbarnes@google.com>
    platform/chrome: cros_ec_proto: Fix deferred response

Hongyan Xu <getshell@seu.edu.cn>
    soc: qcom: apr: clean up failed service registrations

Dan Carpenter <error27@gmail.com>
    soc: qcom: smem: Fix signedness bug in smem_dram_parse()

Felix Gu <ustc.gu@gmail.com>
    spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls

Ruoyu Wang <ruoyuw560@gmail.com>
    pwm: renesas-tpu: Fix runtime PM reference leak

David Heidelberg <david@ixit.cz>
    ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos

Cai Xinchen <caixinchen1@huawei.com>
    lsm: don't call security_backing_file_free() multiple times

Taniya Das <taniya.das@oss.qualcomm.com>
    dt-bindings: clock: qcom: Add GCC video axi reset clocks for Nord

Taniya Das <taniya.das@oss.qualcomm.com>
    arm64: dts: qcom: milos: Add power-domains for camcc and videocc

Taniya Das <taniya.das@oss.qualcomm.com>
    dt-bindings: clock: qcom,milos-videocc: Add missing power-domains support

Taniya Das <taniya.das@oss.qualcomm.com>
    dt-bindings: clock: qcom,milos-camcc: Add missing power-domains support

Runyu Xiao <runyu.xiao@seu.edu.cn>
    remoteproc: xlnx: Initialize mailbox work before requesting channels

Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
    cxl/mce: Avoid alias page retirement for corrected errors

Shujath Mohd <shujath@outlook.in>
    arm64: dts: qcom: sdm845-sony-xperia-tama: Fix Bluetooth UART pinctrl

Greg Ociepka <greg@ferrisoft.com>
    arm64: dts: qcom: glymur: Add missing USB clock, power and bandwidth votes

Linmao Li <lilinmao@kylinos.cn>
    soc: qcom: smem: Fix byte order in v3 14-frequency parser

Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
    soc: qcom: smem: fix 32-bit overflow in DDR frequency calculation

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    remoteproc: qcom_q6v5_adsp: Fix double jiffies conversion in adsp_start()

Primoz Fiser <primoz.fiser@norik.com>
    arm64: dts: imx8mp-phyboard-pollux-peb-av-10: Fix SAI master assignment

Abel Vesa <abel.vesa@oss.qualcomm.com>
    arm64: dts: qcom: glymur-crd: Mark the EC reset gpio as reserved

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: imx95-15x15-frdm: fix duplicated can-phy node names

Sven Peter <sven@kernel.org>
    arm64: dts: apple: t6032: Fix cpus node indentation

Sven Peter <sven@kernel.org>
    arm64: dts: apple: t6030: Fix cpus node indentation

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    dt-bindings: display: panel: samsung,s6e8aa5x01: Allow common properties

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate unwinding sizes against record payload

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate sym string NUL-termination in code load

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate debug entries on native (non-swap) path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Use dirname() return value in jit_open()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Free event in jit_repipe_code_move()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Fix funlockfile on unlocked stream in jit_open() error path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Check snprintf return before computing header size

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Bounds-check debug entry byte-swap loop

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Prevent integer underflow in debug info size calculation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Validate code_size against total_size in code load

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Fix debug_data and unwinding_data leaks

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf jitdump: Fix extended header read that always fails

Breno Leitao <leitao@debian.org>
    kexec_file: stop the top-down search before it underflows

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: fix spi1 location

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: fix vbus-supply for USB2 PHY

Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
    selftests/filesystems: Add .gitignore for fscontext_ns_test

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada-388-helios4: fix vmmc property name

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency

Rosen Penev <rosenp@gmail.com>
    ARM: dts: armada-385-clearfog-gtr: fix vmmc property name

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: fix lm75 supply name

Pei Xiao <xiaopei01@kylinos.cn>
    ata: pata_parport: Fix use-after-free in new_device_store

Lucas Tanure <tanure@linux.com>
    clk: meson: t7: keep the memory fabric clocks running

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: pressure: rohm-bm1390: Fix AVE_NUM initialization

Salah Triki <salah.triki@gmail.com>
    iio: temperature: tmp117: fix calibbias cache update on I2C write failure

Esben Haabendal <esben@geanix.com>
    dt-bindings: iio: light: ltr501: Add missing ltr303 compatible

Esben Haabendal <esben@geanix.com>
    dt-bindings: iio: light: ltr501: Sort compatible enum array

Adi Nata <adinata.softwareengineer@gmail.com>
    iio: humidity: hts221: report available values via read_avail()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    spi: sh-msiof: propagate setup runtime-PM errors

Chandradhar Kumar <chandradhar.2003@gmail.com>
    regulator: fixed: reject incompatible platform devices

Ihor Solodrai <ihor.solodrai@linux.dev>
    bpftool: Don't drop a type in the sorted C dump

Ihor Solodrai <ihor.solodrai@linux.dev>
    selftests/bpf: Add tests for bpftool btf dump format c

Ihor Solodrai <ihor.solodrai@linux.dev>
    selftests/bpf: NUL-terminate bpftool command output

Raag Jadav <raag.jadav@intel.com>
    drm/ras: Cancel and free message on get counter failure

Leon Hwang <leon.hwang@linux.dev>
    selftests/bpf: Avoid flaky resize value test for percpu data

Yuan Chen <chenyuan_fl@163.com>
    bpftool: Fix spurious batch file read error

Harry Wentland <harry.wentland@amd.com>
    drm/vkms: Fix limited-range YCbCr to RGB conversion scaling

Tapio Reijonen <tapio.reijonen@vaisala.com>
    gpio: pcf857x: implement get_direction()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/pm: Remove unused functions in smu_v15_0

Jiayuan Chen <jiayuan.chen@linux.dev>
    libbpf: Fix usdt attach failure when nop10 crosses page boundary

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject oversized stream read buffers

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/panthor: Take reqs_lock in soft_reset for clearing pending_reqs

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/panthor: Revisit reqs_lock handling in flush/reset paths

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/panthor: Add tracepoint for cache flushing

Jianlin Shi <shijianlin11@foxmail.com>
    bpf: Reject oversized bpf_stream_vprintk output with -E2BIG

Jianlin Shi <shijianlin11@foxmail.com>
    bpf: Return partial progress from bpf_stream_read on fault

Jianlin Shi <shijianlin11@foxmail.com>
    bpf: Fix stream capacity leak in staging path

Jianlin Shi <shijianlin11@foxmail.com>
    bpf: Roll back stream capacity when allocation fails

Timur Tabi <ttabi@nvidia.com>
    gpu: nova-core: write initial RPCs before booting GSP-RM

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    selftests/bpf: Allocate a larger timeout for connection

Darren Carreras <carrerasdarren@gmail.com>
    libbpf: Avoid overflow in BTF.ext bounds check

Marek Vasut <marek.vasut+renesas@mailbox.org>
    drm: of: Fix drm_of_get_data_lanes_count_ep() return value documentation

Andreas Kemnade <andreas@kemnade.info>
    drm/omap: dsi: avoid sending bta sync all the time in writes

Tejun Heo <tj@kernel.org>
    bpf: sched_ext: Mark ops argument container pointer fields as trusted

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Prevent division by 0

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Check another bo field for cache option query

Chen-Yu Tsai <wenst@chromium.org>
    drm/verisilicon: Switch to drm_fb_dma_get_addr() for framebuffer addresses

Icenowy Zheng <zhengxingda@iscas.ac.cn>
    drm: verisilicon: fix cursor offset field update

Hao-Qun Huang <alvinhuang0603@gmail.com>
    accel/qaic: reject BO sizes that overflow page count

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Add <linux/device-id/mhi.h> to qaic_ssr.c

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Add <linux/device-id/mhi.h> to qaic_ras.c

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Add <linux/device-id/mhi.h> to qaic_debugfs.c

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Add <linux/device-id/mhi.h> to qaic_drv.c

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Add missing <linux/device-id/mhi.h> to sahara and timesync

Raveendra Talabattula <raveendra.talabattula@arm.com>
    drm/komeda: Fix bits parsing of GLB_CORE_ID

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: schedule tx_work directly from the IRQ handler

Pei Xiao <xiaopei01@kylinos.cn>
    comedi: dt2811: fix shift-out-of-bounds in IRQ check

Yang Zi <2959243019@qq.com>
    comedi: addi_apci_3xxx: fix subdevice count underallocation

Amir Goldstein <amir73il@gmail.com>
    ovl: inherit FMODE_NONOTIFY when reading directory layers

Amir Goldstein <amir73il@gmail.com>
    ovl: add assertions in dir cache code

Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
    ASoC: qcom: q6apm: clear g_apm on driver removal

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    fs/proc/task_mmu: fix missed VMAs when reading /proc/PID/maps and friends

YouYou Yu <youyouyu@amazon.com>
    quota: initialize dquot cache before mounting rootfs

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: SDCA: re-enable IRQ on pm_runtime_force_suspend failure

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: SDCA: export PM helpers keyed on sdca_class_drv

David Hildenbrand (Arm) <david@kernel.org>
    mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: avoid losing atomic VMA flags when setting sticky VMA flags

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Fix 32-bit jiffies wraparound in show_temp()

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    hwmon: (coretemp) Read TjMax only when refreshing the temperature

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows

Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
    nvme-tcp: fix use-after-free in nvme_tcp_free_ctrl()

Jann Horn <jannh@google.com>
    cipso: stop modifying live ip_options_rcu

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: do not verify the content if there is no data checksum

Qu Wenruo <wqu@suse.com>
    btrfs: remove on-stack paddrs[] array usage

Qu Wenruo <wqu@suse.com>
    btrfs: use a shared helper to calculate data checksum for a bio

Qu Wenruo <wqu@suse.com>
    btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration

Qu Wenruo <wqu@suse.com>
    btrfs: replace btrfs_repair_io_failure() to use bio for page iteration

Eva Kurchatova <eva.kurchatova@virtuozzo.com>
    hugetlbfs: enforce F_SEAL_EXEC in setattr

Leo Liu <leo.liu@amd.com>
    drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg

Sonny Jiang <sonny.jiang@amd.com>
    drm/amdgpu: VCN 5_0_2 disable VCN_RRMT

Sonny Jiang <sonny.jiang@amd.com>
    drm/amdgpu: Correct VCN V5_0_2 doorbell index setting

Sonny Jiang <sonjiang@amd.com>
    drm/amdgpu: Config VCN instance for soc_v1_0"

Calvin Owens <calvin@wbinvd.org>
    Revert "drm/amd/display: Allocate DCN32/1 dmub memory to GTT"

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: Use a dedicated flag to track disabled napi instances

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Prevent O_APPEND open on OSS streams

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Optimize cpu_latency_qos_*() calls

Junjie Cao <junjie.cao@intel.com>
    Bluetooth: btusb: drop BROKEN_EXT_SCAN quirk for 0bda:a728

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Build the driver from multiple source files

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Move H:4 reassembly into the Bluetooth core

Matt Turner <mattst88@gmail.com>
    alpha: select SYSCTL_EXCEPTION_TRACE

Gregory Price <gourry@gourry.net>
    mm/userfaultfd: compare exact registration modes before skipping

Eric Dumazet <edumazet@kernel.org>
    inet: frags: bound the wmem charge of the socket completing a reassembly

Ciro Pedrini <ciro.pedrini@gmail.com>
    platform/x86: hp-wmi: Add OMEN board 8A17 thermal profile support

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs

Chao Yu <chao@kernel.org>
    f2fs: fix to fetch ino via ino_of_node() under cache lock

Sahil Chandna <sahilchandna@linux.microsoft.com>
    net: mana: Add support to process throttled EQEs

Manish Awasthi <mawasthi@linux.microsoft.com>
    net: mana: Introduce gdma_bus_ops for bus-specific operations

HOYOUNG SEO <hy50.seo@samsung.com>
    scsi: ufs: core: Change the error check sequence for auto hibern8

David Hildenbrand (Arm) <david@kernel.org>
    mm/userfaultfd: wake waiters when registration modes are removed

Ali Ahmet Memiş <aliamemis@disroot.org>
    platform/x86: ideapad-laptop: Evaluate ACPI methods exclusively

Eklavya Singh <eklavyasingh2106@gmail.com>
    ocfs2/heartbeat: serialize concurrent writes to a region's dev attribute

Karl Mehltretter <kmehltretter@gmail.com>
    ocfs2/cluster: hold a reference on the heartbeat thread

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm: do not unintentionally overwrite atomic VMA flags

Priyank Rathod <rathodpriyank@google.com>
    PCI/AER: Fix memory leak in aer_recover_work_func() when pci_dev is missing

Josef Bacik <josef@toxicpanda.com>
    mm/shmem: hold off eviction in shmem_writeout()

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    9p/xen: drain response work after unbinding IRQ

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Check validity of vmcs01 save area copied from SMRAM on RSM

Shivansh Dhiman <shivansh.dhiman@amd.com>
    KVM: SVM: Add a vCPU-aware helper to get supported DEBUGCTL bits


-------------

Diffstat:

 .gitignore                                         |   1 -
 Documentation/ABI/stable/sysfs-class-infiniband    | 118 ---
 Documentation/ABI/testing/sysfs-bus-pci            |  14 +-
 Documentation/ABI/testing/sysfs-class-led          |   4 +-
 Documentation/ABI/testing/sysfs-class-power-mp2629 |   2 +-
 Documentation/admin-guide/LSM/LoadPin.rst          |  10 +-
 Documentation/admin-guide/LSM/ipe.rst              |   4 +-
 Documentation/admin-guide/cgroup-v2.rst            |   4 +-
 Documentation/admin-guide/kernel-parameters.txt    |  10 +-
 Documentation/admin-guide/pm/amd-pstate.rst        |   6 -
 Documentation/bpf/bpf_iterators.rst                |  10 +
 .../bindings/arm/mediatek/mediatek,audsys.yaml     |   2 +-
 .../bindings/clock/mediatek,apmixedsys.yaml        |   2 +-
 .../bindings/clock/mediatek,topckgen.yaml          |   2 +-
 .../bindings/clock/qcom,milos-camcc.yaml           |  19 +
 .../bindings/clock/qcom,milos-videocc.yaml         |  19 +
 .../devicetree/bindings/clock/qcom,sm8750-gcc.yaml |   7 +
 .../devicetree/bindings/display/msm/gmu.yaml       |   2 +-
 .../devicetree/bindings/display/msm/hdmi.yaml      |   4 +-
 .../panel/samsung,s6e8aa5x01-ams561ra01.yaml       |   2 +-
 .../devicetree/bindings/dma/stericsson,dma40.yaml  |  14 +
 .../bindings/iio/adc/renesas,r9a09g077-adc.yaml    |  10 +-
 .../bindings/iio/light/liteon,ltr501.yaml          |   3 +-
 .../interrupt-controller/chrp,open-pic.yaml        |   7 +-
 .../media/allwinner,sun4i-a10-video-engine.yaml    |  21 +-
 .../devicetree/bindings/phy/ti,tcan104x-can.yaml   |   9 +-
 .../devicetree/bindings/power/supply/bq27xxx.yaml  |   1 -
 .../power/supply/stericsson,ab8500-charger.yaml    |  76 +-
 .../bindings/thermal/amlogic,thermal.yaml          |  29 +-
 .../devicetree/bindings/timer/sifive,clint.yaml    |   1 -
 .../devicetree/bindings/vendor-prefixes.yaml       |  20 +
 Documentation/filesystems/erofs.rst                |   7 +
 Documentation/filesystems/f2fs.rst                 |   3 +-
 Documentation/filesystems/resctrl.rst              |   2 +-
 Documentation/leds/leds-st1202.rst                 |   5 +
 Documentation/mm/process_addrs.rst                 |  14 +-
 Documentation/netlink/specs/devlink.yaml           |  64 +-
 Documentation/networking/psp.rst                   |   8 +
 Documentation/networking/tls-offload.rst           |  16 +-
 Documentation/rust/testing.rst                     |   2 +-
 Documentation/trace/histogram.rst                  |   3 +
 Documentation/translations/zh_CN/rust/testing.rst  |   2 +-
 Documentation/virt/hyperv/overview.rst             |  12 +-
 Makefile                                           |   5 +-
 arch/alpha/Kconfig                                 |   1 +
 arch/alpha/include/asm/ptrace.h                    |   7 +-
 arch/alpha/kernel/ptrace.c                         |  12 +
 arch/alpha/mm/fault.c                              |  29 +
 arch/arc/Makefile                                  |   9 +-
 arch/arc/include/asm/cmpxchg.h                     |   4 +
 arch/arc/lib/Makefile                              |   8 +
 arch/arm/boot/dts/gemini/gemini.dtsi               |   2 +-
 .../boot/dts/marvell/armada-385-clearfog-gtr.dtsi  |   2 +-
 arch/arm/boot/dts/marvell/armada-388-helios4.dts   |  23 +-
 arch/arm/boot/dts/marvell/armada-395-gp.dts        |   1 -
 arch/arm/boot/dts/nvidia/tegra114-dalmore.dts      |   4 +-
 arch/arm/boot/dts/nvidia/tegra114-roth.dts         |   4 +-
 arch/arm/boot/dts/nvidia/tegra114-tn7.dts          |   4 +-
 arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi          |  40 +-
 arch/arm/boot/dts/qcom/qcom-msm8974.dtsi           |   3 +
 arch/arm/boot/dts/st/ste-ab8500.dtsi               |   6 -
 arch/arm/boot/dts/st/ste-ab8505.dtsi               |  23 +-
 arch/arm/boot/dts/st/ste-dbx5x0.dtsi               |   5 -
 arch/arm/boot/dts/st/ste-href-ab8500.dtsi          | 104 +++
 arch/arm/boot/dts/st/ste-href-ab8505.dtsi          | 118 ++-
 arch/arm/boot/dts/st/stm32mp135.dtsi               |  44 +-
 arch/arm/boot/dts/st/stm32mp135f-dk.dts            |   1 +
 .../arm/boot/dts/st/stm32mp153c-lxa-fairytux2.dtsi |   2 +-
 arch/arm/boot/dts/st/stm32mp157c-ev1.dts           |   1 +
 arch/arm/boot/dts/st/stm32mp157c-lxa-mc1.dts       |   2 +-
 arch/arm/boot/dts/st/stm32mp157f-dk2-scmi.dtsi     |   1 +
 arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi      |   2 +-
 arch/arm/boot/dts/st/stm32mp15xx-dhcom-som.dtsi    |   2 +
 arch/arm/boot/dts/st/stm32mp15xx-dkx.dtsi          |   1 +
 arch/arm/include/asm/domain.h                      |  17 -
 arch/arm/include/asm/memory.h                      |   4 +-
 arch/arm/include/asm/pgtable-2level-hwdef.h        |   1 -
 arch/arm/include/asm/pgtable-2level.h              |   7 -
 arch/arm/include/asm/sparsemem.h                   |   4 +
 arch/arm/kernel/efi.c                              |  13 +
 arch/arm/mach-mvebu/Kconfig                        |   4 +-
 arch/arm/mach-versatile/platsmp-vexpress.c         |   4 +-
 arch/arm/mach-versatile/v2m.c                      |   4 +-
 arch/arm/mm/Kconfig                                |   7 -
 arch/arm/mm/alignment.c                            |  10 +-
 arch/arm/mm/dma-mapping.c                          |   5 +-
 arch/arm/mm/ioremap.c                              |  53 +-
 arch/arm/mm/mmu.c                                  |  76 +-
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi       |   4 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   9 +
 .../boot/dts/amlogic/meson-sm1-odroid-hc4.dts      |   4 +-
 arch/arm64/boot/dts/apple/t6030.dtsi               |   2 +-
 arch/arm64/boot/dts/apple/t6032.dtsi               |   2 +-
 arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts |   5 +
 .../boot/dts/broadcom/bcm2712-rpi-5-b-base.dtsi    |  35 +
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          |  11 +
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts      |  14 +-
 arch/arm64/boot/dts/freescale/imx8dxl-sr-som.dtsi  |  14 +-
 .../boot/dts/freescale/imx8mp-kontron-dl.dtso      |  11 +
 .../imx8mp-phyboard-pollux-peb-av-10.dtsi          |   5 +-
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |  32 +-
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts      |  20 +-
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts      |   4 +-
 .../boot/dts/freescale/imx93-11x11-evk-common.dtsi |   4 +-
 .../dts/freescale/imx93-11x11-frdm-common.dtsi     | 680 ++++++++++++++
 arch/arm64/boot/dts/freescale/imx93-11x11-frdm.dts | 679 +-------------
 arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts  |   4 +-
 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts    |   4 +-
 arch/arm64/boot/dts/freescale/imx94.dtsi           |   2 +-
 arch/arm64/boot/dts/freescale/imx943.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts |  16 +-
 arch/arm64/boot/dts/freescale/imx95.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt6878-pinfunc.h      |   2 +-
 arch/arm64/boot/dts/mediatek/mt6893-pinfunc.h      |   2 +-
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso |   1 +
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso |   1 +
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-cn15.dtso |   1 +
 .../mediatek/mt7988a-bananapi-bpi-r4-pro-cn18.dtso |   1 +
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |   5 +
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |   5 +
 arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi   |   5 +
 arch/arm64/boot/dts/mediatek/mt8188-geralt.dtsi    |   7 +-
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   5 +
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |   5 +
 arch/arm64/boot/dts/qcom/agatti.dtsi               |  11 +
 arch/arm64/boot/dts/qcom/eliza.dtsi                |   2 +-
 .../dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts  |   3 +-
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi           |   3 +-
 arch/arm64/boot/dts/qcom/glymur.dtsi               |  59 ++
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts         |  16 +-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi            |   2 +
 .../boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso    |  15 +-
 arch/arm64/boot/dts/qcom/lemans-evk.dts            |   3 +-
 arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi   |   8 +-
 arch/arm64/boot/dts/qcom/milos.dtsi                |  10 +
 .../boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso    |  12 +-
 arch/arm64/boot/dts/qcom/monaco-evk.dts            |   3 +-
 arch/arm64/boot/dts/qcom/purwa-iot-evk.dts         |  27 +-
 arch/arm64/boot/dts/qcom/purwa.dtsi                |   5 +
 .../qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso |  24 +-
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |  12 +-
 .../dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts  |  12 +-
 arch/arm64/boot/dts/qcom/qcs8300-ride.dts          |   4 +-
 arch/arm64/boot/dts/qcom/qcs8550-rb5gen2.dts       |  12 +-
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi     |  13 +-
 .../boot/dts/qcom/sdm845-sony-xperia-tama.dtsi     |   2 +
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   4 +
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/x1-asus-vivobook-s15.dtsi |   1 +
 arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi  |   1 +
 arch/arm64/boot/dts/qcom/x1-crd.dtsi               |   1 +
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi        |   1 +
 arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi   |   1 +
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts       |   3 +-
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi    |   1 +
 .../qcom/x1e80100-dell-inspiron-14-plus-7441.dts   |   4 +-
 .../boot/dts/qcom/x1e80100-dell-xps13-9345.dts     |   1 +
 .../dts/qcom/x1e80100-honor-magicbook-art-14.dts   |   3 +-
 .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   1 +
 .../dts/qcom/x1e80100-medion-sprchrgd-14-s1.dts    |   1 +
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   1 +
 .../boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts |   1 +
 arch/arm64/boot/dts/renesas/r8a78000-ironhide.dts  |  12 +-
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi         |  18 +-
 arch/arm64/boot/dts/renesas/r9a09g087.dtsi         |  18 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts    |  32 +-
 arch/arm64/boot/dts/rockchip/rk3566-base.dtsi      |   4 +
 arch/arm64/boot/dts/rockchip/rk3568.dtsi           |   4 +
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi      |   1 -
 .../boot/dts/rockchip/rk3576-100ask-dshanpi-a1.dts |   9 -
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi     |   2 +-
 .../boot/dts/rockchip/rk3588s-gameforce-ace.dts    |   7 +-
 .../arm64/boot/dts/rockchip/rk3588s-nanopi-r6.dtsi |  20 +
 .../boot/dts/rockchip/rk3588s-orangepi-5-pro.dts   |  14 +-
 arch/arm64/boot/dts/st/stm32mp231.dtsi             |   4 +-
 arch/arm64/boot/dts/st/stm32mp251.dtsi             |   4 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin-ivy.dtsi     |  41 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin-zinnia.dtsi  |  41 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  41 +-
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi   |   2 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   2 +-
 arch/arm64/boot/dts/ti/k3-am62d2-evm.dts           |   2 +-
 arch/arm64/boot/dts/ti/k3-am62l3-evm.dts           |   4 +-
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi        |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts            |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi      |   2 +-
 arch/arm64/boot/dts/ti/k3-am69-aquila.dtsi         |   2 +-
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts            |  25 +-
 .../boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi   |   2 +
 arch/arm64/include/asm/rsi_smc.h                   |   2 +-
 arch/arm64/kernel/pi/Makefile                      |   1 +
 arch/arm64/net/bpf_jit_comp.c                      |  32 +-
 arch/arm64/net/bpf_timed_may_goto.S                |  10 +-
 arch/hexagon/include/asm/cmpxchg.h                 |   6 +
 arch/loongarch/net/bpf_jit.c                       |   8 +-
 arch/m68k/apollo/dn_ints.c                         |   6 +
 arch/m68k/mac/config.c                             |  31 +-
 arch/microblaze/Makefile                           |   6 +-
 arch/microblaze/include/asm/uaccess.h              |   3 +-
 arch/microblaze/kernel/cpu/cpuinfo.c               |   1 +
 arch/microblaze/kernel/ptrace.c                    |   3 +
 arch/mips/Makefile                                 |  22 +-
 arch/mips/cavium-octeon/dma-octeon.c               |   2 +-
 arch/mips/include/asm/dec/reset.h                  |   1 +
 arch/nios2/kernel/nios2_ksyms.c                    |   1 +
 arch/openrisc/include/asm/cmpxchg.h                |   2 +
 arch/powerpc/include/asm/interrupt.h               |   7 +-
 arch/powerpc/include/asm/kasan.h                   |  15 -
 arch/powerpc/include/asm/string.h                  |  21 +-
 arch/powerpc/kernel/cputable.c                     |  14 +-
 arch/powerpc/kernel/prom_init.c                    |  10 +-
 arch/powerpc/kernel/prom_init_check.sh             |  15 +-
 arch/powerpc/kernel/trace/ftrace_entry.S           |   6 +
 arch/powerpc/lib/copy_32.S                         |  10 +-
 arch/powerpc/lib/mem_64.S                          |   7 +-
 arch/powerpc/lib/memcpy_64.S                       |   4 +-
 arch/powerpc/net/bpf_jit.h                         |   6 +
 arch/powerpc/net/bpf_jit_comp.c                    |  46 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |   8 +-
 arch/riscv/boot/dts/sophgo/cv180x.dtsi             |   2 +-
 arch/riscv/boot/dts/spacemit/k1-orangepi-rv2.dts   |   2 +-
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi        |   1 +
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts       |   2 +
 arch/riscv/boot/dts/spacemit/k3.dtsi               |  48 +-
 arch/riscv/boot/dts/starfive/jh7100-common.dtsi    |  28 +-
 arch/riscv/boot/dts/starfive/jh7100.dtsi           |  67 +-
 arch/riscv/boot/dts/starfive/jh7110-common.dtsi    |  27 +-
 arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts |   6 +-
 .../boot/dts/starfive/jh7110-milkv-marscm.dtsi     |   6 +-
 .../boot/dts/starfive/jh7110-pine64-star64.dts     |   6 +-
 .../jh7110-starfive-visionfive-2-lite.dtsi         |   6 +-
 .../dts/starfive/jh7110-starfive-visionfive-2.dtsi |   6 +-
 arch/riscv/boot/dts/starfive/jh7110.dtsi           |  67 +-
 arch/riscv/include/asm/insn.h                      |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  24 +-
 arch/riscv/net/bpf_jit_core.c                      |   1 +
 arch/riscv/net/bpf_timed_may_goto.S                |  33 +-
 arch/s390/include/asm/entry-percpu.h               |  71 +-
 arch/s390/include/asm/lowcore.h                    |   3 +
 arch/s390/include/asm/percpu.h                     | 356 +++++---
 arch/s390/kernel/early.c                           |  15 +-
 arch/s390/kernel/irq.c                             |  10 +-
 arch/s390/kernel/nmi.c                             |   4 +-
 arch/s390/kernel/ptrace.c                          |   9 +-
 arch/s390/kernel/traps.c                           |   4 +-
 arch/s390/kernel/uprobes.c                         |   2 +-
 arch/sh/Kconfig                                    |   1 +
 arch/sh/boards/board-sh7785lcr.c                   |   2 +-
 arch/sh/boot/dts/Makefile                          |   2 +-
 arch/sh/configs/migor_defconfig                    |   2 +-
 arch/sh/configs/sdk7786_defconfig                  |   2 +-
 arch/sh/configs/shx3_defconfig                     |   2 +-
 arch/sh/include/asm/uaccess_32.h                   |   8 +-
 arch/um/include/shared/skas/stub-data.h            |   9 +
 arch/um/kernel/skas/syscall.c                      |   5 +-
 arch/x86/boot/string.c                             |  13 +-
 arch/x86/include/asm/cpuid/api.h                   |   2 +-
 arch/x86/include/asm/shared/string.h               |  52 ++
 arch/x86/include/asm/string.h                      |  21 +-
 arch/x86/include/asm/svm.h                         |   4 +-
 arch/x86/kernel/cpu/common.c                       |  76 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  27 +-
 arch/x86/kernel/crash.c                            |   6 +-
 arch/x86/kernel/fpu/xstate.c                       |   7 +-
 arch/x86/kvm/svm/nested.c                          |  31 +-
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/kvm/svm/svm.h                             |   9 +-
 arch/x86/net/bpf_jit_comp.c                        |  34 +-
 arch/x86/net/bpf_timed_may_goto.S                  |  13 +-
 arch/x86/platform/pvh/enlighten.c                  |   5 +-
 arch/x86/power/hibernate.c                         |  51 +-
 block/bdev.c                                       |  14 +-
 block/bfq-iosched.c                                |   4 +-
 block/bio-integrity-fs.c                           |  13 +-
 block/bio.c                                        |  50 +-
 block/blk-cgroup.c                                 |  39 +-
 block/blk-cgroup.h                                 |   6 +-
 block/blk-flush.c                                  |   8 +-
 block/blk-iocost.c                                 | 120 ++-
 block/blk-iolatency.c                              |   6 +-
 block/blk-map.c                                    |   1 +
 block/blk-mq-dma.c                                 |   2 +
 block/blk-mq-tag.c                                 |  25 +-
 block/blk-mq.c                                     |  93 +-
 block/blk-mq.h                                     |   2 +
 block/blk-settings.c                               |   6 +
 block/blk-throttle.c                               |  28 +-
 block/blk-timeout.c                                |   3 +-
 block/blk.h                                        |  14 +
 block/fops.c                                       | 117 ++-
 block/partitions/mac.c                             |   4 +-
 crypto/algapi.c                                    |  23 +-
 crypto/asymmetric_keys/pkcs7_parser.c              |   6 +
 crypto/asymmetric_keys/verify_pefile.c             |   5 +
 crypto/asymmetric_keys/x509_public_key.c           |   6 +-
 crypto/lskcipher.c                                 |   6 +-
 crypto/rsassa-pkcs1.c                              |   4 +-
 crypto/tcrypt.c                                    | 182 ++--
 drivers/accel/amdxdna/aie2_ctx.c                   | 126 ++-
 drivers/accel/amdxdna/aie2_pci.c                   |  15 +-
 drivers/accel/amdxdna/aie2_pci.h                   |   6 +-
 drivers/accel/amdxdna/amdxdna_gem.c                | 465 +++++++---
 drivers/accel/amdxdna/amdxdna_gem.h                |   6 +-
 drivers/accel/ethosu/ethosu_drv.c                  |   2 +-
 drivers/accel/ivpu/ivpu_gem.c                      |   2 +-
 drivers/accel/qaic/qaic_data.c                     |  22 +-
 drivers/accel/qaic/qaic_debugfs.c                  |   1 +
 drivers/accel/qaic/qaic_drv.c                      |   1 +
 drivers/accel/qaic/qaic_ras.c                      |   1 +
 drivers/accel/qaic/qaic_ssr.c                      |   1 +
 drivers/accel/qaic/qaic_timesync.c                 |   1 +
 drivers/accel/qaic/sahara.c                        |   1 +
 drivers/accel/rocket/rocket_gem.c                  |   2 +-
 drivers/accel/rocket/rocket_job.c                  |   2 -
 drivers/acpi/acpi_extlog.c                         |  64 +-
 drivers/acpi/acpi_pcc.c                            |  33 +-
 drivers/acpi/acpi_video.c                          |  12 +-
 drivers/acpi/acpica/dsfield.c                      |   3 +-
 drivers/acpi/acpica/exfield.c                      |  11 +-
 drivers/acpi/acpica/nsxfname.c                     |   1 +
 drivers/acpi/apei/ghes.c                           |  92 +-
 drivers/acpi/apei/ghes_helpers.c                   |  18 +-
 drivers/acpi/button.c                              |  12 +
 drivers/acpi/cppc_acpi.c                           |  22 +-
 drivers/acpi/device_pm.c                           |  77 +-
 drivers/acpi/fan_core.c                            |   9 +-
 drivers/acpi/glue.c                                | 142 ++-
 drivers/acpi/numa/hmat.c                           |   2 +-
 drivers/acpi/pci_link.c                            |   1 +
 drivers/acpi/pci_root.c                            |  76 +-
 drivers/acpi/platform_profile.c                    |  82 +-
 drivers/acpi/scan.c                                |  40 +-
 drivers/acpi/tables.c                              |   3 +
 drivers/android/binder/process.rs                  |   4 +-
 drivers/ata/ahci.c                                 |  31 +-
 drivers/ata/libahci.c                              |  15 +
 drivers/ata/libata-core.c                          |  21 +-
 drivers/ata/libata-scsi.c                          |   2 +-
 drivers/ata/pata_parport/pata_parport.c            |   9 +-
 drivers/ata/sata_dwc_460ex.c                       |   5 +-
 drivers/base/node.c                                |  17 +-
 drivers/base/power/runtime.c                       |   6 +-
 drivers/block/drbd/drbd_main.c                     |   1 +
 drivers/block/drbd/drbd_receiver.c                 |   2 +
 drivers/block/floppy.c                             |  10 +-
 drivers/block/rnbd/rnbd-srv-sysfs.c                |  28 +-
 drivers/block/rnbd/rnbd-srv.c                      |  36 +-
 drivers/block/rnull/configfs.rs                    |   2 +-
 drivers/block/swim.c                               | 287 +++---
 drivers/block/swim3.c                              |   8 +-
 drivers/block/swim_asm.S                           | 136 +--
 drivers/block/ublk_drv.c                           |   9 +-
 drivers/block/xen-blkback/blkback.c                |   7 +
 drivers/block/zloop.c                              |  80 +-
 drivers/block/zram/zram_drv.c                      | 110 +--
 drivers/bluetooth/Makefile                         |   2 +
 drivers/bluetooth/btintel.c                        |   8 +
 drivers/bluetooth/btintel.h                        |   1 +
 drivers/bluetooth/btintel_pcie.c                   | 530 +++++++++--
 drivers/bluetooth/btintel_pcie.h                   |  64 +-
 drivers/bluetooth/btmtk.c                          |  88 +-
 drivers/bluetooth/btmtksdio.c                      |  13 +-
 drivers/bluetooth/{btusb.c => btusb_main.c}        |  13 +-
 drivers/bluetooth/hci_h4.c                         | 123 +--
 drivers/bluetooth/hci_uart.h                       |  39 +-
 drivers/bluetooth/virtio_bt.c                      |   4 +-
 drivers/bus/arm-cci.c                              |   6 +-
 drivers/bus/mhi/host/pci_generic.c                 |   5 +-
 drivers/char/hw_random/cctrng.c                    |   7 +-
 drivers/char/hw_random/intel-rng.c                 |   5 +-
 drivers/char/hw_random/jh7110-trng.c               |  39 +-
 drivers/char/scx200_gpio.c                         |   8 +-
 drivers/clk/aspeed/Kconfig                         |   1 +
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +
 drivers/clk/clk-cdce925.c                          |   9 +-
 drivers/clk/clk-lmk04832.c                         |   3 +
 drivers/clk/clk-milbeaut.c                         |  10 +-
 drivers/clk/clk-renesas-pcie.c                     |   5 +
 drivers/clk/clk-s2mps11.c                          |  12 +-
 drivers/clk/clk-si521xx.c                          |   2 +-
 drivers/clk/clk-si5351.c                           |  20 +-
 drivers/clk/clk.c                                  |  65 +-
 drivers/clk/clk.h                                  |   5 +-
 drivers/clk/clk_test.c                             |  12 +-
 drivers/clk/clkdev.c                               |   4 +-
 drivers/clk/imx/clk-composite-93.c                 |  11 +-
 drivers/clk/kunit_clk_assigned_rates.h             |   4 +-
 drivers/clk/mediatek/reset.h                       |   6 +-
 drivers/clk/meson/t7-peripherals.c                 |  13 +-
 drivers/clk/qcom/Kconfig                           |   2 +-
 drivers/clk/qcom/cambistmclkcc-kaanapali.c         |   7 +
 drivers/clk/qcom/cambistmclkcc-sm8750.c            |   7 +
 drivers/clk/qcom/camcc-glymur.c                    |   7 +
 drivers/clk/qcom/clk-alpha-pll.c                   |   9 +
 drivers/clk/qcom/clk-rcg2.c                        |  35 +-
 drivers/clk/qcom/clk-rpmh.c                        |   5 +
 drivers/clk/qcom/dispcc-sm8450.c                   |   2 +-
 drivers/clk/qcom/gcc-eliza.c                       |   1 +
 drivers/clk/qcom/gcc-glymur.c                      |  69 +-
 drivers/clk/qcom/gcc-ipq5424.c                     |   4 +-
 drivers/clk/qcom/gcc-kaanapali.c                   |   1 +
 drivers/clk/qcom/gcc-qcs615.c                      |   2 +-
 drivers/clk/qcom/gcc-x1e80100.c                    |   6 +-
 drivers/clk/qcom/lpasscc-sm6115.c                  |   4 +-
 drivers/clk/qcom/mmcc-msm8960.c                    |   3 +-
 drivers/clk/qcom/mmcc-msm8996.c                    |   4 +-
 drivers/clk/qcom/mmcc-sdm660.c                     |   2 +-
 drivers/clk/qcom/negcc-nord.c                      |   4 +-
 drivers/clk/qcom/nwgcc-nord.c                      |   5 +-
 drivers/clk/qcom/segcc-nord.c                      |   8 +-
 drivers/clk/starfive/clk-starfive-jh7110-sys.c     |   3 +
 drivers/clk/stm32/clk-stm32mp21.c                  |   4 +-
 drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c           |  37 +-
 drivers/clk/sunxi-ng/ccu-sun55i-a523.c             | 128 ++-
 drivers/clk/sunxi-ng/ccu_div.h                     |  18 +-
 drivers/clk/ti/adpll.c                             |   1 +
 drivers/clk/versatile/clk-icst.c                   |   4 +
 drivers/clocksource/clksrc-dbx500-prcmu.c          |   2 +
 drivers/clocksource/timer-econet-en751221.c        |   1 +
 drivers/clocksource/timer-mediatek.c               |   4 +-
 drivers/clocksource/timer-ti-dm.c                  |  10 +-
 drivers/comedi/drivers/addi_apci_3xxx.c            |   2 +-
 drivers/comedi/drivers/comedi_parport.c            |   3 +-
 drivers/comedi/drivers/dmm32at.c                   |   3 +-
 drivers/comedi/drivers/dt2811.c                    |   2 +-
 drivers/comedi/drivers/dt2814.c                    |   3 +-
 drivers/comedi/drivers/ni_atmio16d.c               |   4 +-
 drivers/comedi/drivers/pcmmio.c                    |   3 +-
 drivers/comedi/drivers/pcmuio.c                    |   5 +-
 drivers/cpufreq/amd-pstate-ut.c                    |  23 +-
 drivers/cpufreq/amd-pstate.c                       |  37 +-
 drivers/cpufreq/amd-pstate.h                       |  14 +
 drivers/cpufreq/qcom-cpufreq-hw.c                  |   3 +
 drivers/cpufreq/sparc-us2e-cpufreq.c               |  11 +-
 drivers/cpufreq/sti-cpufreq.c                      |   4 +-
 drivers/cpufreq/tegra194-cpufreq.c                 |   2 +-
 drivers/cpuidle/governors/menu.c                   |   8 +-
 drivers/cpuidle/governors/teo.c                    |  11 +
 drivers/crypto/amlogic/amlogic-gxl-cipher.c        |  25 +-
 drivers/crypto/atmel-aes.c                         |   2 +
 drivers/crypto/atmel-sha.c                         |  17 +
 drivers/crypto/caam/caamalg_qi.c                   |   2 +
 drivers/crypto/caam/caamalg_qi2.c                  |   2 +
 drivers/crypto/ccp/ccp-dev-v3.c                    |   4 +
 drivers/crypto/ccp/ccp-dev-v5.c                    |   4 +
 drivers/crypto/ccp/sfs.c                           |   9 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |   2 -
 drivers/crypto/inside-secure/eip93/eip93-regs.h    |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   3 +
 drivers/crypto/intel/qat/qat_common/adf_cfg.c      |  49 +-
 drivers/crypto/intel/qat/qat_common/adf_init.c     |  24 +-
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |  15 +-
 .../crypto/intel/qat/qat_common/adf_sysfs_kpt.c    |  24 +-
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |  15 +-
 .../crypto/intel/qat/qat_common/qat_asym_algs.c    |  38 +-
 drivers/crypto/mxs-dcp.c                           |   3 +
 drivers/crypto/starfive/jh7110-cryp.c              |  20 +-
 drivers/crypto/talitos.c                           |  54 +-
 drivers/cxl/core/cdat.c                            |   8 +-
 drivers/cxl/core/core.h                            |  14 +-
 drivers/cxl/core/edac.c                            |  30 +-
 drivers/cxl/core/features.c                        |  56 +-
 drivers/cxl/core/hdm.c                             |  62 +-
 drivers/cxl/core/mce.c                             |   8 +-
 drivers/cxl/core/pci.c                             |  21 +-
 drivers/cxl/core/port.c                            | 218 +++--
 drivers/cxl/core/ras.c                             |   6 +-
 drivers/cxl/core/ras_rch.c                         |  12 +-
 drivers/cxl/core/region.c                          |  15 +-
 drivers/cxl/core/region_pmem.c                     |   6 +-
 drivers/cxl/cxl.h                                  |  24 +-
 drivers/cxl/mem.c                                  |  28 +-
 drivers/cxl/pci.c                                  |  11 +-
 drivers/dax/bus.c                                  |   8 +-
 drivers/dax/fsdev.c                                |  23 +
 drivers/dax/super.c                                |   3 +-
 drivers/dma/at_hdmac.c                             |  44 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  37 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |   5 +-
 drivers/dma/fsl_raid.c                             |  32 +-
 drivers/dma/img-mdc-dma.c                          |   2 +-
 drivers/dma/ioat/init.c                            |  18 +-
 drivers/dma/loongson/loongson2-apb-cmc-dma.c       |   2 +-
 drivers/dma/mediatek/mtk-hsdma.c                   |  26 +-
 drivers/dma/mv_xor.c                               |   1 +
 drivers/dma/plx_dma.c                              |  10 +-
 drivers/dma/sprd-dma.c                             |  45 +-
 drivers/dma/ste_dma40.c                            | 587 ++++++++++---
 drivers/dma/ste_dma40_ll.c                         |   8 +-
 drivers/dma/ste_dma40_ll.h                         |   4 +-
 drivers/dma/sun6i-dma.c                            |  31 +-
 drivers/dma/switchtec_dma.c                        |  56 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  37 +-
 drivers/dma/xilinx/zynqmp_dma.c                    |  48 +-
 drivers/dpll/zl3073x/dpll.c                        | 241 +++--
 drivers/dpll/zl3073x/out.h                         |  36 +
 drivers/dpll/zl3073x/prop.c                        |  56 +-
 drivers/edac/i10nm_base.c                          |   1 +
 drivers/firmware/arm_scmi/common.h                 |  22 +
 drivers/firmware/arm_scmi/driver.c                 |  38 +-
 drivers/firmware/arm_scmi/protocols.h              |   9 +-
 drivers/firmware/arm_scmi/raw_mode.c               |  30 +-
 drivers/firmware/cirrus/cs_dsp.c                   |   2 +
 drivers/firmware/efi/cper.c                        |  51 +-
 drivers/firmware/efi/libstub/efi-stub-entry.c      |   4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |  10 +-
 drivers/firmware/efi/libstub/efi-stub.c            |   2 +-
 drivers/firmware/efi/libstub/efistub.h             |   4 +-
 drivers/firmware/efi/libstub/fdt.c                 |   6 +-
 drivers/firmware/efi/libstub/file.c                |   8 +-
 drivers/firmware/efi/libstub/kaslr.c               |   2 +-
 drivers/firmware/efi/libstub/mem.c                 |   2 +-
 drivers/firmware/efi/libstub/pci.c                 |   2 +-
 drivers/firmware/efi/libstub/random.c              |   8 +-
 drivers/firmware/efi/libstub/riscv-stub.c          |   7 +-
 drivers/firmware/efi/libstub/riscv.c               |   2 +-
 drivers/firmware/efi/libstub/tpm.c                 |   8 +-
 drivers/firmware/efi/libstub/unaccepted_memory.c   |   2 +-
 drivers/firmware/efi/libstub/x86-stub.c            |  10 +-
 drivers/firmware/efi/runtime-wrappers.c            |  14 +-
 drivers/firmware/imx/imx-dsp.c                     |   6 +-
 drivers/firmware/qcom/qcom_scm.c                   |  16 +-
 drivers/firmware/qcom/qcom_tzmem.c                 |   2 +-
 drivers/gpio/gpio-crystalcove.c                    |   1 +
 drivers/gpio/gpio-pcf857x.c                        |  16 +-
 drivers/gpio/gpiolib.c                             |  20 +-
 drivers/gpu/buddy.c                                |   1 -
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |   7 +-
 drivers/gpu/drm/amd/amdgpu/atom.c                  |  29 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c             |  72 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_2.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/soc_v1_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v5_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vce_v1_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vce_v4_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |  11 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   8 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c            |  14 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   2 -
 drivers/gpu/drm/amd/display/Kconfig                |   9 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   4 +
 .../amd/display/amdgpu_dm/amdgpu_dm_connector.c    |  18 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_dmub.c |  11 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  18 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h    |  94 +-
 .../amdgpu_dm/tests/amdgpu_dm_helpers_test.c       |  17 +
 .../drm/amd/display/dc/bios/command_table_helper.c |   7 +-
 .../amd/display/dc/bios/command_table_helper2.c    |   2 +
 drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile    |   8 +
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   4 +
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    | 115 ---
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.h    |   8 +-
 .../amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.c |  59 --
 .../amd/display/dc/clk_mgr/dce112/dce112_clk_mgr.h |   4 +-
 .../amd/display/dc/clk_mgr/dcn10/dcn10_clk_mgr.c   | 181 ++++
 .../amd/display/dc/clk_mgr/dcn10/dcn10_clk_mgr.h   |  29 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   4 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  | 113 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  79 ++
 drivers/gpu/drm/amd/display/dc/dc_types.h          |   1 +
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |   6 +-
 .../src/dml2_core/dml2_core_dcn6_calcs_dchub.c     |   2 +-
 drivers/gpu/drm/amd/display/dc/gpio/hw_factory.c   |   4 +
 drivers/gpu/drm/amd/display/dc/gpio/hw_translate.c |   4 +
 .../drm/amd/display/dc/hubbub/dcn42/dcn42_hubbub.h |   7 +-
 drivers/gpu/drm/amd/display/dc/hwss/Makefile       |   6 +
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  25 +-
 .../drm/amd/display/dc/hwss/dce60/dce60_hwseq.c    |   3 +-
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  35 +-
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.h    |   3 +-
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |  63 +-
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.h    |   7 +-
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |  51 +-
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.h    |   8 +-
 .../drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c    |  60 +-
 .../drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.h    |  10 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |  53 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h  |   9 +-
 .../drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c    |  51 +-
 .../drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.h    |  12 +-
 drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h |  23 +-
 .../drm/amd/display/dc/hwss/hw_sequencer_private.h |  18 +-
 drivers/gpu/drm/amd/display/dc/irq/Makefile        |   2 +
 .../amd/display/dc/irq/dce110/irq_service_dce110.c |  21 -
 .../amd/display/dc/irq/dce110/irq_service_dce110.h |   9 -
 drivers/gpu/drm/amd/display/dc/irq/irq_service.c   |  28 +
 drivers/gpu/drm/amd/display/dc/irq/irq_service.h   |   9 +
 drivers/gpu/drm/amd/display/dc/resource/Makefile   |   4 +
 .../display/dc/resource/dce112/dce112_resource.c   |  62 --
 .../display/dc/resource/dcn42b/dcn42b_resource.c   |   2 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   3 +
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v15_0.h       |   6 -
 drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0.c     | 166 ----
 drivers/gpu/drm/amd/ras/core/eeprom.c              |   6 +-
 .../gpu/drm/arm/display/include/malidp_product.h   |  10 +-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    |   5 -
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   2 +-
 drivers/gpu/drm/drm_connector.c                    |   2 +
 drivers/gpu/drm/drm_of.c                           |   8 +-
 drivers/gpu/drm/drm_pagemap.c                      |   3 +-
 drivers/gpu/drm/drm_ras.c                          |  19 +-
 drivers/gpu/drm/drm_syncobj.c                      |  35 +-
 drivers/gpu/drm/drm_timeout.c                      |  95 ++
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  13 +
 drivers/gpu/drm/imx/lcdc/imx-lcdc.c                |   3 +-
 drivers/gpu/drm/lima/lima_gem.c                    |   2 +-
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c              |  12 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |  49 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  20 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  40 +-
 drivers/gpu/drm/msm/adreno/a8xx_gpu.c              |   3 +
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   3 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.h            |   7 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |  17 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  10 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cfg.c           |   9 -
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   3 +
 drivers/gpu/drm/msm/dp/dp_debug.c                  |   1 +
 drivers/gpu/drm/msm/msm_io_utils.c                 |   6 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |  63 +-
 drivers/gpu/drm/panel/Kconfig                      |   2 +
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |   2 +-
 drivers/gpu/drm/panfrost/panfrost_device.c         |  19 +-
 drivers/gpu/drm/panfrost/panfrost_device.h         |   1 +
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  43 +-
 drivers/gpu/drm/panfrost/panfrost_drv.h            |   9 -
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  35 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   7 +-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c   |   9 +-
 drivers/gpu/drm/panfrost/panfrost_gpu.c            |   2 +
 drivers/gpu/drm/panfrost/panfrost_job.c            |   2 +
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  14 +-
 drivers/gpu/drm/panfrost/panfrost_perfcnt.c        | 315 ++++---
 drivers/gpu/drm/panfrost/panfrost_perfcnt.h        |   1 +
 drivers/gpu/drm/panthor/panthor_gem.c              |   3 +
 drivers/gpu/drm/panthor/panthor_gpu.c              |  89 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |  28 +-
 drivers/gpu/drm/panthor/panthor_trace.h            |  38 +
 drivers/gpu/drm/pl111/pl111_display.c              |   6 -
 drivers/gpu/drm/pl111/pl111_drv.c                  |  16 -
 drivers/gpu/drm/pl111/pl111_versatile.c            |  18 -
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c     |  18 +-
 drivers/gpu/drm/tegra/submit.c                     |  12 +-
 drivers/gpu/drm/tegra/uapi.c                       |   2 +-
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c |  54 --
 drivers/gpu/drm/tiny/appletbdrm.c                  |  48 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   3 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |  29 -
 drivers/gpu/drm/vc4/vc4_gem.c                      |   3 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |  10 +
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   8 +-
 drivers/gpu/drm/verisilicon/vs_cursor_plane.c      |   8 +-
 drivers/gpu/drm/verisilicon/vs_plane.c             |  20 -
 drivers/gpu/drm/verisilicon/vs_plane.h             |   2 -
 drivers/gpu/drm/verisilicon/vs_primary_plane.c     |   7 +-
 drivers/gpu/drm/vkms/tests/gen_yuv_conversion.py   |  87 ++
 drivers/gpu/drm/vkms/tests/vkms_format_test.c      |  38 +-
 drivers/gpu/drm/vkms/vkms_formats.c                |  55 +-
 drivers/gpu/drm/xe/xe_pagefault.c                  |   7 +
 drivers/gpu/drm/xe/xe_wait_user_fence.c            |   2 +-
 drivers/gpu/nova-core/gsp/boot.rs                  |  10 +-
 drivers/hid/hid-asus.c                             |  28 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   1 +
 drivers/hid/hid-magicmouse.c                       |   4 +
 drivers/hid/hid-nintendo.c                         |  14 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  11 +-
 .../intel-thc-hid/intel-quicki2c/pci-quicki2c.c    |   4 +-
 .../intel-thc-hid/intel-quicki2c/quicki2c-dev.h    |   2 +
 .../intel-thc-hid/intel-quicki2c/quicki2c-hid.c    |   6 +-
 .../intel-thc-hid/intel-quicki2c/quicki2c-hid.h    |   2 +-
 .../intel-thc-hid/intel-quickspi/pci-quickspi.c    |   2 +
 .../intel-thc-hid/intel-quickspi/quickspi-dev.h    |   2 +
 .../intel-thc-hid/intel-quickspi/quickspi-hid.c    |   6 +-
 .../intel-thc-hid/intel-quickspi/quickspi-hid.h    |   2 +-
 .../intel-quickspi/quickspi-protocol.c             |   2 +-
 drivers/hid/wacom_wac.c                            |  14 +-
 drivers/hv/hv_common.c                             |  10 -
 drivers/hv/mshv_vtl_main.c                         |   4 +-
 drivers/hv/vmbus_drv.c                             |  30 +-
 drivers/hwmon/coretemp.c                           |  15 +-
 drivers/hwtracing/coresight/coresight-config.c     |  18 +-
 drivers/hwtracing/coresight/coresight-config.h     |  22 +
 drivers/hwtracing/coresight/coresight-etm.h        |   4 +-
 drivers/hwtracing/coresight/coresight-etm3x-core.c |  68 +-
 .../hwtracing/coresight/coresight-etm3x-sysfs.c    |  83 +-
 drivers/hwtracing/coresight/coresight-etm4x-cfg.c  |  13 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 123 +--
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   6 +
 drivers/hwtracing/coresight/coresight-etm4x.h      |   4 +-
 drivers/i3c/device.c                               |  15 +-
 drivers/i3c/internals.h                            |   2 +
 drivers/i3c/master.c                               |  76 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |  16 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              | 134 ++-
 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c |   1 +
 drivers/iio/accel/bma220_spi.c                     |   3 +-
 drivers/iio/accel/kionix-kx022a.h                  |   2 +-
 drivers/iio/dac/ad5758.c                           |   8 +-
 drivers/iio/dac/mcp47feb02.c                       |   4 +-
 drivers/iio/humidity/hts221_core.c                 | 106 +--
 drivers/iio/imu/adis16400.c                        |   5 +-
 drivers/iio/pressure/rohm-bm1390.c                 |   4 +-
 drivers/iio/temperature/tmp117.c                   |   9 +-
 drivers/infiniband/core/device.c                   |   2 +-
 drivers/infiniband/core/ib_core_uverbs.c           |  12 -
 drivers/infiniband/core/lag.c                      |  14 +-
 drivers/infiniband/core/mad.c                      |   2 +
 drivers/infiniband/core/mad_rmpp.c                 |   7 +-
 drivers/infiniband/core/nldev.c                    |   9 +-
 drivers/infiniband/core/rdma_core.c                |   2 +
 drivers/infiniband/core/rdma_core.h                |  17 +-
 drivers/infiniband/core/restrack.c                 |   3 +-
 drivers/infiniband/core/sysfs.c                    |   9 +-
 drivers/infiniband/core/uverbs_std_types_device.c  |   1 +
 drivers/infiniband/core/uverbs_std_types_wq.c      |   2 +-
 drivers/infiniband/core/verbs.c                    |   6 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   4 +
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |   6 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  58 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  26 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  23 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   5 +-
 drivers/infiniband/hw/cxgb4/provider.c             |   5 +
 drivers/infiniband/hw/efa/efa_com.c                |  28 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   3 +
 drivers/infiniband/hw/hfi1/verbs.c                 |   4 +
 drivers/infiniband/hw/hns/hns_roce_bond.c          |   4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |   1 +
 drivers/infiniband/hw/hns/hns_roce_device.h        |   1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  55 +-
 drivers/infiniband/hw/ionic/ionic_controlpath.c    |  16 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c          |   4 +-
 drivers/infiniband/hw/irdma/ctrl.c                 |  14 +-
 drivers/infiniband/hw/irdma/hw.c                   |  14 +-
 drivers/infiniband/hw/irdma/main.c                 |   2 +
 drivers/infiniband/hw/irdma/pble.c                 |   8 +-
 drivers/infiniband/hw/irdma/type.h                 |   4 +-
 drivers/infiniband/hw/irdma/verbs.c                |  13 +-
 drivers/infiniband/hw/mlx4/cm.c                    |  10 +
 drivers/infiniband/hw/mlx4/main.c                  |   4 +
 drivers/infiniband/hw/mlx5/cq.c                    |   5 +-
 drivers/infiniband/hw/mlx5/fs.c                    |  48 +-
 drivers/infiniband/hw/mlx5/main.c                  |  54 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   2 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  30 +-
 drivers/infiniband/hw/mlx5/qpc.c                   |  18 +-
 drivers/infiniband/hw/mlx5/srq.c                   |   3 +-
 drivers/infiniband/hw/mlx5/wr.c                    |   1 +
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |   2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c       |   6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c      |   3 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |   8 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  12 +-
 drivers/infiniband/sw/rxe/rxe_mw.c                 |   3 +
 drivers/infiniband/sw/rxe/rxe_net.c                |  73 +-
 drivers/infiniband/sw/rxe/rxe_odp.c                |   9 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  10 +
 drivers/infiniband/sw/rxe/rxe_recv.c               |   9 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  11 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  23 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   1 +
 drivers/infiniband/sw/siw/siw_main.c               |   5 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  20 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   7 +
 drivers/infiniband/ulp/isert/ib_isert.c            |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |  77 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   2 +-
 drivers/interconnect/qcom/bcm-voter.c              |  25 +-
 drivers/interconnect/qcom/icc-common.h             |   9 +
 drivers/interconnect/qcom/icc-rpm.c                | 101 ++-
 drivers/interconnect/qcom/icc-rpm.h                |   6 +-
 drivers/interconnect/qcom/msm8976.c                |   3 +-
 drivers/interconnect/qcom/msm8996.c                |   1 +
 drivers/interconnect/qcom/smd-rpm.c                |   8 +-
 drivers/interconnect/samsung/exynos.c              |   1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c   |  19 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  20 +-
 drivers/iommu/intel/dmar.c                         |  70 +-
 drivers/iommu/intel/iommu.c                        | 152 +++-
 drivers/iommu/intel/nested.c                       |   2 +
 drivers/iommu/iommufd/device.c                     |   8 +-
 drivers/iommu/iommufd/selftest.c                   |   6 +-
 drivers/irqchip/Kconfig                            |   4 +-
 drivers/irqchip/irq-gic-common.c                   |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  20 +-
 drivers/irqchip/irq-gic-v3.c                       |  22 +-
 drivers/irqchip/irq-gic.c                          |   4 +-
 drivers/irqchip/irq-mips-gic.c                     |  59 +-
 drivers/irqchip/irq-mst-intc.c                     |   3 +
 drivers/irqchip/irq-riscv-imsic-state.c            |  21 +-
 drivers/irqchip/irq-sifive-plic.c                  |   2 +-
 drivers/leds/led-class-flash.c                     |   2 +-
 drivers/leds/led-class.c                           |  25 +-
 drivers/leds/led-triggers.c                        |  28 +
 drivers/leds/leds-lm3692x.c                        |   4 +-
 drivers/leds/leds-lp8860.c                         |   5 +-
 drivers/leds/leds-max77705.c                       |   3 +-
 drivers/leds/leds-pca9532.c                        |   9 +-
 drivers/leds/leds-st1202.c                         | 225 ++++-
 drivers/mailbox/arm_mhu_db.c                       |   4 +-
 drivers/mailbox/arm_mhuv2.c                        |   9 +-
 drivers/mailbox/axiado-mailbox.c                   | 116 ++-
 drivers/mailbox/pcc.c                              |   5 +-
 drivers/mailbox/qcom-cpucp-mbox.c                  |   2 +-
 drivers/mailbox/qcom-ipcc.c                        |   6 +-
 drivers/mailbox/ti-msgmgr.c                        |  12 +-
 drivers/md/dm-snap.c                               |  18 +-
 drivers/md/md.c                                    |  33 +-
 drivers/md/raid0.c                                 |  16 +-
 drivers/md/raid10.c                                |   3 +-
 drivers/md/raid5-cache.c                           |  14 +-
 drivers/md/raid5-ppl.c                             |  12 +-
 drivers/md/raid5.c                                 |  65 +-
 drivers/media/i2c/ar0521.c                         |   1 -
 drivers/media/i2c/imx471.c                         |   2 +-
 drivers/media/i2c/ov5648.c                         |   4 +-
 drivers/media/i2c/t4ka3.c                          |   1 -
 drivers/media/pci/intel/ivsc/mei_ace.c             |   4 +-
 drivers/media/platform/qcom/iris/iris_ctrls.c      |   2 +
 drivers/media/platform/qcom/iris/iris_firmware.c   | 119 +--
 drivers/media/platform/qcom/iris/iris_hfi_common.c |   3 +-
 .../platform/qcom/iris/iris_hfi_gen1_response.c    |   2 +
 .../platform/qcom/iris/iris_hfi_gen2_response.c    |   1 +
 drivers/media/platform/qcom/iris/iris_instance.h   |   4 +
 .../platform/qcom/iris/iris_platform_common.h      |   6 +-
 .../media/platform/qcom/iris/iris_platform_vpu2.c  |  13 +-
 .../media/platform/qcom/iris/iris_platform_vpu3x.c |  10 +-
 drivers/media/platform/qcom/iris/iris_probe.c      |   6 +
 drivers/media/platform/qcom/iris/iris_utils.c      |   6 +
 drivers/media/platform/qcom/iris/iris_utils.h      |   1 +
 drivers/media/platform/qcom/iris/iris_vb2.c        |   6 +-
 drivers/media/platform/qcom/iris/iris_vidc.c       |  45 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.c |   2 +-
 drivers/media/platform/qcom/venus/hfi_msgs.c       |   3 +
 drivers/media/platform/renesas/rcar-isp/core-io.c  |  40 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   3 +-
 drivers/memory/brcmstb_dpfe.c                      |  17 +-
 drivers/memory/emif.c                              |   3 +
 drivers/memory/samsung/exynos5422-dmc.c            |  11 +-
 drivers/mfd/cs42l43-i2c.c                          |   8 +
 drivers/mfd/cs42l43-sdw.c                          |   8 +
 drivers/mfd/cs42l43.c                              |  12 +-
 drivers/mfd/cs42l43.h                              |   1 +
 drivers/mfd/da9150-core.c                          |   8 +-
 drivers/mfd/intel_quark_i2c_gpio.c                 |  52 +-
 drivers/mfd/rk8xx-core.c                           |   2 +-
 drivers/misc/enclosure.c                           |   3 +-
 drivers/misc/mei/vsc-tp.c                          |  17 +-
 drivers/misc/nsm.c                                 |   7 +-
 drivers/mtd/mtd_blkdevs.c                          |   5 +
 drivers/mtd/nand/raw/pl35x-nand-controller.c       |   1 +
 drivers/mtd/nand/raw/sunxi_nand.c                  |  32 +-
 drivers/mtd/spi-nor/spansion.c                     |   7 -
 drivers/net/amt.c                                  |   8 +-
 drivers/net/dsa/mt7530.c                           |   7 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  10 +-
 drivers/net/dsa/yt921x.c                           |   4 +-
 drivers/net/ethernet/alacritech/slicoss.c          |   2 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   2 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        | 121 +--
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |   4 -
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |  32 +-
 drivers/net/ethernet/broadcom/bgmac.c              |  51 +-
 drivers/net/ethernet/broadcom/bnge/bnge_netdev.c   |  28 +-
 drivers/net/ethernet/broadcom/bnge/bnge_resc.c     |   6 +-
 drivers/net/ethernet/broadcom/bnge/bnge_resc.h     |   9 +-
 drivers/net/ethernet/broadcom/bnge/bnge_txrx.c     |   6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  58 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   1 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 102 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |   6 +
 drivers/net/ethernet/cadence/macb.h                |   2 -
 drivers/net/ethernet/cadence/macb_main.c           |  20 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |   1 +
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c   |   1 +
 drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c  |   2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |  12 +-
 drivers/net/ethernet/ibm/ibmveth.c                 | 670 ++++++++++++--
 drivers/net/ethernet/ibm/ibmveth.h                 |   5 +
 drivers/net/ethernet/intel/ice/ice.h               |   8 +-
 drivers/net/ethernet/intel/ice/ice_adapter.c       |  17 +-
 drivers/net/ethernet/intel/ice/ice_adapter.h       |  17 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 343 +++++---
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 174 +++-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |  10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   4 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_ipsec.c   |   5 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   5 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  10 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   2 +
 drivers/net/ethernet/mellanox/mlx4/intf.c          |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/dpll.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   6 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 +
 .../mellanox/mlx5/core/en_accel/psp_rxtx.h         |  13 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   4 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |  66 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws.h       |   1 +
 .../mellanox/mlx5/core/steering/hws/fs_hws_pools.c |  11 +-
 .../mellanox/mlx5/core/steering/hws/pat_arg.c      |  12 +-
 .../mellanox/mlx5/core/steering/hws/pat_arg.h      |   5 +
 drivers/net/ethernet/meta/fbnic/fbnic.h            |   7 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |  78 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h         |  15 +-
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c        |  24 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   2 +-
 drivers/net/ethernet/microchip/fdma/fdma_api.c     |  45 +-
 drivers/net/ethernet/microchip/fdma/fdma_api.h     |  20 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  17 +-
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |   4 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  19 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |  10 +-
 .../microchip/sparx5/lan969x/lan969x_calendar.c    |   8 +-
 .../microchip/sparx5/lan969x/lan969x_fdma.c        |   5 +-
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |   3 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |  15 +-
 .../net/ethernet/microchip/sparx5/sparx5_psfp.c    |  10 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    | 975 +++++++++++++--------
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   9 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  32 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |  19 +-
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c  |   2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   2 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  24 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |   1 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  13 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   2 +-
 drivers/net/ethernet/sfc/Kconfig                   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/descs.h        |   6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  25 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   7 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 115 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  16 +-
 drivers/net/ethernet/ti/am65-cpts.c                |   1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  86 +-
 drivers/net/gtp.c                                  |  51 +-
 drivers/net/loopback.c                             |   8 +-
 drivers/net/macsec.c                               |   5 +
 drivers/net/phy/marvell.c                          |  97 +-
 drivers/net/phy/qcom/at803x.c                      |  96 +-
 drivers/net/phy/qcom/qca83xx.c                     |  58 ++
 drivers/net/phy/realtek/realtek_main.c             |   2 +-
 drivers/net/ppp/ppp_generic.c                      |  95 +-
 drivers/net/ppp/pppoe.c                            |   8 +
 drivers/net/pse-pd/si3474.c                        |  27 +-
 drivers/net/team/team_core.c                       |  11 +
 drivers/net/tun.c                                  |  10 +
 drivers/net/usb/cdc_mbim.c                         |   5 +-
 drivers/net/usb/cdc_ncm.c                          |   7 +-
 drivers/net/usb/lan78xx.c                          |  18 +-
 drivers/net/usb/usbnet.c                           |  32 +-
 drivers/net/veth.c                                 |   7 +-
 drivers/net/virtio_net.c                           |  12 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |  12 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |   3 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   7 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath11k/core.c             |  11 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  19 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  33 +-
 drivers/net/wireless/ath/ath11k/mac.h              |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   9 +
 drivers/net/wireless/ath/ath12k/ahb.c              |  41 +-
 drivers/net/wireless/ath/ath12k/core.c             |   3 +-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |   2 +-
 drivers/net/wireless/ath/ath12k/dp.c               |   9 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  15 +-
 drivers/net/wireless/ath/ath12k/dp_mon.h           |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  40 +-
 drivers/net/wireless/ath/ath12k/mac.h              |   2 +-
 drivers/net/wireless/ath/ath12k/pci.c              |  55 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  45 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |  30 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  11 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   2 -
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/ath/carl9170/debug.c          |   5 +-
 drivers/net/wireless/broadcom/b43/debugfs.c        |   2 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c  |   2 +-
 .../net/wireless/intel/iwlwifi/mld/low_latency.c   |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   4 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  10 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   6 +
 drivers/net/wireless/marvell/mwifiex/init.c        |   1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |   1 +
 drivers/net/wireless/mediatek/mt76/channel.c       |  21 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  17 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  27 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  13 +
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |  17 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  20 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  11 +-
 .../net/wireless/mediatek/mt76/mt7915/coredump.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   6 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  47 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   5 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   1 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regd.c   |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   | 113 ++-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  67 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c    | 694 +++++++++------
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h    | 103 ++-
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |   5 +-
 .../net/wireless/mediatek/mt76/mt7925/pci_mac.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h        |  10 +
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |   1 +
 .../net/wireless/mediatek/mt76/mt7996/coredump.c   |   7 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    | 319 ++++---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  15 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 379 +++++---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 120 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |  23 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   7 +
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |  38 +-
 drivers/net/wireless/mediatek/mt76/scan.c          | 227 +++--
 drivers/net/wireless/mediatek/mt76/tx.c            |   7 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  16 +-
 drivers/net/wireless/morsemicro/mm81x/fw.c         |   9 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c        |  94 +-
 drivers/net/wireless/morsemicro/mm81x/sdio.c       |   9 +-
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c    |  14 +-
 drivers/net/wireless/nxp/nxpwifi/11ax.c            |   2 +
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c        |   6 +-
 drivers/net/wireless/nxp/nxpwifi/main.c            |  10 +-
 drivers/net/wireless/nxp/nxpwifi/scan.c            |  18 +
 drivers/net/wireless/nxp/nxpwifi/sdio.c            |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       | 154 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   2 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   5 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |  12 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |   2 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |   2 +-
 drivers/net/wireless/silabs/wfx/bh.c               |   6 +-
 drivers/net/wireless/silabs/wfx/bus_sdio.c         |   1 +
 drivers/net/wireless/silabs/wfx/main.c             |  36 +-
 drivers/nvdimm/pmem.c                              |   6 +-
 drivers/nvme/host/fabrics.c                        |  30 +-
 drivers/nvme/host/ioctl.c                          |   2 +-
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/rdma.c                           |   2 +-
 drivers/nvme/host/tcp.c                            |  35 +-
 drivers/nvme/target/configfs.c                     |  24 +-
 drivers/nvme/target/core.c                         |  16 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |   9 +-
 drivers/nvme/target/fabrics-cmd.c                  |   3 +-
 drivers/nvme/target/fc.c                           |  15 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   3 +-
 drivers/nvme/target/loop.c                         |   2 -
 drivers/nvme/target/nvmet.h                        |   3 +-
 drivers/nvme/target/rdma.c                         |  26 +-
 drivers/nvme/target/tcp.c                          |   7 +-
 drivers/nvme/target/zns.c                          |  12 +-
 drivers/nvmem/layouts/onie-tlv.c                   |   1 +
 drivers/nvmem/layouts/sl28vpd.c                    |   1 +
 drivers/of/irq.c                                   |   2 +-
 drivers/opp/of.c                                   |   2 +-
 .../pci/controller/cadence/pcie-cadence-debugfs.c  |  15 +-
 drivers/pci/controller/dwc/pci-dra7xx.c            |  22 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  54 +-
 drivers/pci/controller/dwc/pcie-eswin.c            |   1 +
 drivers/pci/controller/dwc/pcie-qcom.c             |  93 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |  27 +
 drivers/pci/controller/pci-aardvark.c              |  31 +-
 drivers/pci/controller/pci-xgene.c                 |  11 +-
 drivers/pci/controller/pcie-iproc-bcma.c           |  40 +-
 drivers/pci/controller/pcie-tegra264.c             |   9 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      | 160 +++-
 drivers/pci/hotplug/pciehp_core.c                  |   2 +-
 drivers/pci/iov.c                                  |  25 -
 drivers/pci/p2pdma.c                               |  23 +-
 drivers/pci/pci-acpi.c                             |   3 -
 drivers/pci/pci-label.c                            |  92 +-
 drivers/pci/pci.c                                  |  24 +-
 drivers/pci/pci.h                                  |   5 +-
 drivers/pci/pcie/aer.c                             |  17 +-
 drivers/pci/pcie/aer_cxl_rch.c                     |   2 +-
 drivers/pci/pcie/err.c                             |   2 +-
 drivers/pci/pcie/portdrv.c                         |   6 +-
 drivers/pci/pcie/portdrv.h                         |   2 -
 drivers/pci/probe.c                                |  18 +-
 drivers/pci/pwrctrl/core.c                         |  19 +-
 drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c           |   4 +-
 drivers/pci/quirks.c                               |   2 +-
 drivers/pci/tph.c                                  |   6 +-
 drivers/pci/xen-pcifront.c                         |   5 +-
 drivers/perf/cxl_pmu.c                             | 100 ++-
 drivers/perf/dwc_pcie_pmu.c                        |  11 +-
 drivers/perf/marvell_cn10k_ddr_pmu.c               |  85 +-
 drivers/perf/marvell_cn10k_tad_pmu.c               |   1 +
 drivers/phy/cadence/phy-cadence-sierra.c           |  11 +-
 drivers/phy/hisilicon/phy-hi3670-pcie.c            |   4 +-
 drivers/phy/qualcomm/Kconfig                       |   1 +
 drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c  | 103 +--
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |  19 +
 drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c  |   8 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |   8 +-
 drivers/phy/rockchip/phy-rockchip-usbdp.c          | 248 ++----
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  78 +-
 drivers/phy/spacemit/Kconfig                       |   2 +
 drivers/pinctrl/mediatek/pinctrl-mt7629.c          |   2 +-
 drivers/pinctrl/microchip/pinctrl-mpfs-mssio.c     |   2 +-
 drivers/pinctrl/nuvoton/pinctrl-ma35.c             |   8 +-
 drivers/pinctrl/pinctrl-generic-mux.c              |  76 +-
 drivers/pinctrl/sprd/pinctrl-sprd.c                |   3 +
 drivers/pinctrl/stm32/Kconfig                      |   2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  19 +-
 drivers/pinctrl/sunplus/Kconfig                    |   8 +-
 drivers/platform/arm64/qcom-hamoa-ec.c             |  19 +-
 drivers/platform/chrome/cros_ec_proto.c            |  32 +-
 drivers/platform/chrome/cros_ec_proto_test.c       | 158 +++-
 drivers/platform/chrome/cros_ec_typec.c            | 104 ++-
 drivers/platform/cznic/turris-omnia-mcu-gpio.c     |  31 +-
 drivers/platform/olpc/olpc-ec.c                    |   2 +-
 .../platform/surface/surface_aggregator_registry.c |   3 +-
 drivers/platform/x86/amd/pmc/pmc.c                 |   5 +-
 drivers/platform/x86/amd/pmf/util.c                |   1 +
 drivers/platform/x86/asus-armoury.c                |  26 +-
 drivers/platform/x86/asus-wmi.c                    |  32 +
 drivers/platform/x86/gpd-pocket-fan.c              |   9 +-
 .../platform/x86/hp/hp-bioscfg/int-attributes.c    |   7 +-
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |   2 +-
 .../platform/x86/hp/hp-bioscfg/spmobj-attributes.c |   7 +
 drivers/platform/x86/hp/hp-wmi.c                   |  23 +-
 drivers/platform/x86/ibm_rtl.c                     |   8 +-
 drivers/platform/x86/intel/pmc/core.h              |   2 +-
 drivers/platform/x86/intel/pmc/nvl.c               |   2 +-
 drivers/platform/x86/intel/pmt/class.c             |   5 +-
 drivers/platform/x86/intel/pmt/class.h             |   3 +-
 drivers/platform/x86/intel/pmt/discovery.c         |   2 +-
 drivers/platform/x86/intel/telemetry/core.c        |   4 +
 drivers/platform/x86/intel/tpmi_power_domains.c    |   9 +
 drivers/platform/x86/intel/vsec.c                  |  15 +
 drivers/platform/x86/lenovo/ideapad-laptop.c       |  12 +-
 drivers/platform/x86/msi-ec.c                      |   9 +
 drivers/platform/x86/msi-wmi.c                     |   6 +-
 drivers/platform/x86/topstar-laptop.c              |   6 +-
 drivers/pmdomain/imx/scu-pd.c                      |  10 +-
 drivers/pmdomain/renesas/r8a78000-mdlc.c           |   6 +-
 drivers/power/sequencing/pwrseq-pcie-m2.c          |   2 +
 drivers/power/supply/ab8500_bmdata.c               |   2 +-
 drivers/power/supply/ab8500_btemp.c                |  28 +-
 drivers/power/supply/ab8500_chargalg.c             |   9 +-
 drivers/power/supply/ab8500_charger.c              | 402 +++++++--
 drivers/power/supply/ab8500_fg.c                   |  27 +-
 drivers/power/supply/bq24190_charger.c             |  39 +-
 drivers/power/supply/bq2515x_charger.c             |  15 +-
 drivers/power/supply/bq257xx_charger.c             |   2 +-
 drivers/power/supply/generic-adc-battery.c         |   3 +
 drivers/power/supply/gpio-charger.c                |   5 +-
 drivers/power/supply/mm8013.c                      |   1 +
 drivers/power/supply/qcom_battmgr.c                |  27 +-
 drivers/power/supply/s2mu005-battery.c             |   4 +-
 drivers/pps/generators/pps_gen.c                   |  10 +-
 drivers/ptp/ptp_qoriq.c                            |   1 +
 drivers/pwm/core.c                                 |   1 +
 drivers/pwm/pwm-ipq.c                              |   2 +-
 drivers/pwm/pwm-loongson.c                         |   2 +
 drivers/pwm/pwm-lp3943.c                           |   3 +
 drivers/pwm/pwm-mtk-disp.c                         |   4 +-
 drivers/pwm/pwm-renesas-tpu.c                      |  23 +-
 drivers/regulator/ab8500.c                         | 158 +++-
 drivers/regulator/fixed.c                          |   4 +
 drivers/regulator/irq_helpers.c                    |  38 +-
 drivers/regulator/mp886x.c                         |  13 +-
 drivers/regulator/pf1550-regulator.c               |  19 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   2 +-
 drivers/remoteproc/imx_dsp_rproc.c                 |   7 +-
 drivers/remoteproc/imx_rproc.c                     |  18 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |   2 +-
 drivers/remoteproc/remoteproc_core.c               |   3 +
 drivers/remoteproc/xlnx_r5_remoteproc.c            |   8 +-
 drivers/resctrl/mpam_devices.c                     | 119 ++-
 drivers/resctrl/mpam_resctrl.c                     |  13 +-
 drivers/rpmsg/mtk_rpmsg.c                          |   1 +
 drivers/rpmsg/virtio_rpmsg_bus.c                   |   5 +-
 drivers/rtc/Kconfig                                |  21 +
 drivers/rtc/class.c                                |   8 +-
 drivers/rtc/rtc-abx80x.c                           |  58 +-
 drivers/rtc/rtc-bd70528.c                          |   5 +
 drivers/rtc/rtc-ds1685.c                           |  20 +-
 drivers/rtc/rtc-ftrtc010.c                         |  74 +-
 drivers/rtc/rtc-mpfs.c                             |   4 +-
 drivers/rtc/rtc-s35390a.c                          | 109 ++-
 drivers/s390/net/ism_drv.c                         |   3 +-
 drivers/s390/virtio/virtio_ccw.c                   |   6 +-
 drivers/scsi/ch.c                                  |   2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c        |   4 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |  10 +-
 drivers/scsi/elx/libefc/efclib.c                   |   2 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |   3 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  43 +
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   4 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   4 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  13 +-
 drivers/scsi/libsas/sas_task.c                     |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  43 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  17 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |  95 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |   7 +
 drivers/scsi/pm8001/pm8001_defs.h                  |  98 +++
 drivers/scsi/pm8001/pm8001_hwi.c                   |   2 +-
 drivers/scsi/pm8001/pm8001_hwi.h                   |   4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                   | 100 +--
 drivers/scsi/scsi_debug.c                          | 409 +++++----
 drivers/scsi/scsi_lib.c                            |   6 +-
 drivers/scsi/scsi_lib_test.c                       |  25 +-
 drivers/scsi/scsi_scan.c                           |   8 +-
 drivers/scsi/scsi_transport_spi.c                  |   2 +-
 drivers/scsi/sd.c                                  |  20 +-
 drivers/scsi/ses.c                                 |   8 +-
 drivers/scsi/st.c                                  |  75 ++
 drivers/soc/microchip/mpfs-sys-controller.c        |   7 +-
 drivers/soc/qcom/apr.c                             |  50 +-
 drivers/soc/qcom/pmic_glink.c                      |   3 +-
 drivers/soc/qcom/pmic_pdcharger_ulog.c             |   2 +-
 drivers/soc/qcom/qcom-geni-se.c                    |  14 +-
 drivers/soc/qcom/smem_dramc.c                      |  17 +-
 drivers/soc/tegra/flowctrl.c                       |   7 +-
 drivers/soundwire/debugfs.c                        |  63 +-
 drivers/soundwire/intel_auxdevice.c                |   2 +-
 drivers/spi/spi-amlogic-spisg.c                    |  43 +-
 drivers/spi/spi-axi-spi-engine.c                   |  20 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   1 +
 drivers/spi/spi-cs42l43.c                          |   8 +
 drivers/spi/spi-fsl-spi.c                          |   8 +
 drivers/spi/spi-ma35d1-qspi.c                      |  27 +-
 drivers/spi/spi-meson-spicc.c                      |  11 +-
 drivers/spi/spi-mtk-nor.c                          |   1 +
 drivers/spi/spi-mxic.c                             |   8 +-
 drivers/spi/spi-omap2-mcspi.c                      | 242 +++--
 drivers/spi/spi-qpic-snand.c                       |  30 +-
 drivers/spi/spi-rockchip-sfc.c                     |  21 +-
 drivers/spi/spi-rspi.c                             |  49 +-
 drivers/spi/spi-sh-msiof.c                         |   5 +-
 drivers/spi/spi-sun4i.c                            |  56 +-
 drivers/spi/spi-tegra114.c                         |  49 ++
 drivers/spi/spi-virtio.c                           |   4 +-
 drivers/spi/spi.c                                  |   2 +-
 drivers/spmi/spmi-mtk-pmif.c                       |  42 +-
 drivers/spmi/spmi-pmic-arb.c                       |   2 +-
 drivers/staging/iio/adc/ad7816.c                   |  33 +-
 drivers/staging/media/ipu7/ipu7-isys.c             |   1 +
 drivers/staging/media/tegra-video/tegra20.c        |   7 +-
 drivers/staging/octeon/ethernet-tx.c               |   2 +-
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   4 +-
 drivers/staging/sm750fb/sm750.c                    |  10 +-
 drivers/thermal/airoha_thermal.c                   |  34 +-
 drivers/thermal/amlogic_thermal.c                  |  14 +-
 drivers/thermal/gov_power_allocator.c              |   7 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |   8 +-
 drivers/thermal/renesas/rzg3e_thermal.c            |  38 +-
 drivers/thermal/sprd_thermal.c                     |   6 +
 drivers/thermal/thermal_trace.h                    |   4 +-
 drivers/thermal/ti-soc-thermal/ti-bandgap.c        |  10 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   4 +
 drivers/tty/serial/8250/8250.h                     |  11 +-
 drivers/tty/serial/8250/8250_hub6.c                |  11 +-
 drivers/tty/serial/8250/8250_mid.c                 |  16 +-
 drivers/tty/serial/8250/8250_mxpcie.c              |  30 +-
 drivers/tty/serial/8250/8250_platform.c            |   9 +-
 drivers/tty/serial/8250/8250_port.c                |  13 +-
 drivers/tty/serial/8250/8250_uniphier.c            |  10 +-
 drivers/tty/serial/8250/Kconfig                    |   4 +-
 drivers/tty/serial/8250/Makefile                   |   2 +-
 drivers/tty/serial/Kconfig                         |   1 +
 drivers/tty/serial/ma35d1_serial.c                 |   2 +-
 drivers/tty/serial/max310x.c                       | 632 ++++++++++++-
 drivers/tty/serial/pmac_zilog.c                    |   1 +
 drivers/tty/serial/qcom_geni_serial.c              |   6 +
 drivers/tty/serial/serial_txx9.c                   |  55 +-
 drivers/tty/serial/sh-sci.c                        |   8 +-
 drivers/tty/serial/sifive.c                        |   2 +-
 drivers/ufs/core/ufshcd.c                          |  40 +-
 drivers/ufs/host/ufs-exynos.c                      |   4 +-
 drivers/ufs/host/ufs-mediatek.c                    |  16 +-
 drivers/ufs/host/ufs-qcom.c                        |   5 +
 drivers/ufs/host/ufshcd-pci.c                      |   3 +-
 drivers/usb/gadget/composite.c                     |   2 +-
 drivers/usb/gadget/function/f_mass_storage.c       |   7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   4 +-
 drivers/usb/host/pci-quirks.c                      |   1 +
 drivers/usb/host/xhci-dbgtty.c                     |   2 +
 drivers/usb/image/microtek.c                       |   1 +
 drivers/usb/mon/mon_main.c                         |   3 +
 drivers/usb/musb/da8xx.c                           |   8 +-
 drivers/usb/storage/alauda.c                       |  95 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |   9 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c               |   9 +-
 drivers/vfio/cdx/main.c                            |  10 +-
 drivers/vfio/device_cdev.c                         |  12 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |  10 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  73 +-
 drivers/vfio/pci/ism/main.c                        |  19 +-
 drivers/vfio/pci/mlx5/main.c                       |  13 +-
 drivers/vfio/pci/nvgrace-gpu/main.c                |  19 +-
 drivers/vfio/pci/pds/pci_drv.c                     |   8 +-
 drivers/vfio/pci/pds/vfio_dev.c                    |   5 +-
 drivers/vfio/pci/qat/main.c                        |  12 +-
 drivers/vfio/pci/vfio_pci.c                        |  33 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  37 +-
 drivers/vfio/pci/virtio/main.c                     |   8 +-
 drivers/vfio/pci/xe/main.c                         |   8 +-
 drivers/vfio/platform/vfio_platform_common.c       |  10 +-
 drivers/vfio/vfio_main.c                           |   7 -
 drivers/vhost/vringh.c                             |   4 +-
 drivers/video/fbdev/atafb.c                        |  28 +-
 drivers/video/fbdev/gxt4500.c                      |   1 +
 drivers/virtio/virtio.c                            |   2 +
 drivers/virtio/virtio_pci_modern.c                 |  12 +-
 fs/btrfs/accessors.c                               |   2 +-
 fs/btrfs/bio.c                                     | 141 ++-
 fs/btrfs/bio.h                                     |   5 +-
 fs/btrfs/block-group.c                             |   6 +-
 fs/btrfs/btrfs_inode.h                             |  12 +-
 fs/btrfs/ctree.h                                   |   2 +-
 fs/btrfs/defrag.c                                  |   2 +-
 fs/btrfs/disk-io.c                                 |  31 +-
 fs/btrfs/extent-tree.c                             |   3 +-
 fs/btrfs/file-item.c                               |  19 +-
 fs/btrfs/free-space-cache.c                        |  10 +
 fs/btrfs/inode.c                                   | 118 +--
 fs/btrfs/messages.c                                |   9 +-
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/btrfs/raid56.c                                  |  57 +-
 fs/btrfs/tree-mod-log.c                            |  13 +-
 fs/btrfs/verity.c                                  |  31 +-
 fs/btrfs/volumes.c                                 |  37 +
 fs/btrfs/zoned.c                                   |   8 +-
 fs/ceph/addr.c                                     |  67 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/ceph/super.c                                    |  18 +-
 fs/ceph/super.h                                    |   1 -
 fs/dcache.c                                        |   2 +
 fs/debugfs/file.c                                  |  81 +-
 fs/dlm/config.c                                    |  39 +-
 fs/dlm/dlm_internal.h                              |   5 +
 fs/dlm/lock.c                                      |  18 +-
 fs/dlm/lock.h                                      |   4 +-
 fs/dlm/member.c                                    |  17 +-
 fs/erofs/data.c                                    |   5 +-
 fs/erofs/internal.h                                |   1 +
 fs/erofs/super.c                                   |  63 +-
 fs/eventpoll.c                                     |  18 +-
 fs/exfat/fatent.c                                  |  46 +-
 fs/ext2/file.c                                     |   7 +
 fs/ext4/inode.c                                    |   3 +-
 fs/f2fs/checkpoint.c                               |  14 +-
 fs/f2fs/gc.c                                       |   6 +-
 fs/f2fs/inode.c                                    |   4 +-
 fs/f2fs/node.c                                     |   4 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/f2fs/segment.h                                  |  11 +
 fs/f2fs/super.c                                    |  48 +-
 fs/fs-writeback.c                                  |  20 +-
 fs/fs_pin.c                                        |  15 +-
 fs/fuse/dev.c                                      | 105 ++-
 fs/fuse/dev.h                                      |   2 +-
 fs/fuse/file.c                                     |   7 +-
 fs/fuse/notify.c                                   |   2 +-
 fs/fuse/req.c                                      |   7 +-
 fs/gfs2/bmap.c                                     |   2 +-
 fs/gfs2/inode.c                                    |   2 +-
 fs/hfs/btree.c                                     |   7 +-
 fs/hfsplus/btree.c                                 |   7 +-
 fs/hugetlbfs/inode.c                               |   5 +
 fs/internal.h                                      |   1 -
 fs/iomap/bio.c                                     |   4 +-
 fs/iomap/direct-io.c                               |  21 +-
 fs/iomap/ioend.c                                   |  14 +-
 fs/isofs/dir.c                                     |   4 +-
 fs/isofs/isofs.h                                   |  11 +-
 fs/isofs/joliet.c                                  |  27 +-
 fs/isofs/namei.c                                   |   3 +-
 fs/kernfs/dir.c                                    |  67 +-
 fs/kernfs/file.c                                   |  25 +-
 fs/kernfs/symlink.c                                |  17 +-
 fs/minix/namei.c                                   |   4 +
 fs/namei.c                                         |  10 +-
 fs/namespace.c                                     |   2 -
 fs/netfs/internal.h                                |  32 +-
 fs/nfs/client.c                                    |   2 +-
 fs/nfs/dir.c                                       |  13 +-
 fs/nfs/filelayout/filelayout.c                     |   5 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  81 +-
 fs/nfs/fs_context.c                                |   1 +
 fs/nfs/internal.h                                  |  31 +
 fs/nfs/nfs3proc.c                                  |   8 +
 fs/nfs/nfs4client.c                                |   7 +-
 fs/nfs/nfs4proc.c                                  |   5 +
 fs/nfs/nfs4xdr.c                                   |   3 +-
 fs/nfs/pnfs.c                                      |  12 +-
 fs/nfs/proc.c                                      |   8 +
 fs/nfs_common/nfslocalio.c                         | 101 ++-
 fs/nilfs2/namei.c                                  |   8 +-
 fs/nilfs2/recovery.c                               |  17 +
 fs/nsfs.c                                          |   4 +-
 fs/ntfs/aops.c                                     |   7 +-
 fs/ntfs/attrib.c                                   |  10 +-
 fs/ntfs/attrlist.c                                 |   9 +-
 fs/ntfs/bitmap.c                                   |  19 +-
 fs/ntfs/collate.c                                  |   2 +-
 fs/ntfs/compress.c                                 |   4 +-
 fs/ntfs/dir.c                                      |  15 +-
 fs/ntfs/ea.c                                       |   2 +-
 fs/ntfs/file.c                                     |  22 +-
 fs/ntfs/index.c                                    |  27 +-
 fs/ntfs/inode.c                                    | 132 ++-
 fs/ntfs/layout.h                                   |  13 +-
 fs/ntfs/lcnalloc.c                                 |  35 +-
 fs/ntfs/logfile.c                                  |   2 +-
 fs/ntfs/mft.c                                      |  14 +-
 fs/ntfs/mst.c                                      |   4 +-
 fs/ntfs/reparse.c                                  |   2 +-
 fs/ntfs/runlist.c                                  |   5 +-
 fs/ntfs3/attrib.c                                  |  10 +-
 fs/ntfs3/dir.c                                     |  62 +-
 fs/ntfs3/file.c                                    |   3 +
 fs/ntfs3/frecord.c                                 |  11 +-
 fs/ntfs3/fsntfs.c                                  |   3 +
 fs/ntfs3/index.c                                   |  19 +-
 fs/ntfs3/inode.c                                   |   9 +-
 fs/ntfs3/xattr.c                                   |   8 +-
 fs/ocfs2/cluster/heartbeat.c                       |  52 +-
 fs/ocfs2/cluster/tcp.c                             |   8 +-
 fs/ocfs2/dlmglue.c                                 |  29 +-
 fs/ocfs2/dlmglue.h                                 |   5 +-
 fs/ocfs2/export.c                                  |  10 +-
 fs/ocfs2/inode.c                                   |   5 +-
 fs/ocfs2/namei.c                                   |   6 +-
 fs/ocfs2/ocfs2.h                                   |   5 +
 fs/ocfs2/quota_local.c                             |  24 +
 fs/ocfs2/suballoc.c                                | 202 ++++-
 fs/ocfs2/suballoc.h                                |   2 +-
 fs/ocfs2/super.c                                   |  16 +
 fs/ocfs2/xattr.c                                   | 266 ++++--
 fs/ocfs2/xattr.h                                   |  12 +-
 fs/overlayfs/readdir.c                             |  54 +-
 fs/pidfs.c                                         |   8 +
 fs/proc/base.c                                     |   8 +-
 fs/proc/internal.h                                 |   1 +
 fs/proc/kcore.c                                    |   8 +-
 fs/proc/task_mmu.c                                 |   9 +-
 fs/pstore/ram.c                                    |   1 +
 fs/pstore/ram_core.c                               |   6 +
 fs/quota/dquot.c                                   |  10 +-
 fs/resctrl/rdtgroup.c                              |   2 +-
 fs/smb/client/connect.c                            |   6 +-
 fs/smb/server/Kconfig                              |   1 +
 fs/smb/server/connection.c                         |   2 +-
 fs/smb/server/connection.h                         |   3 +
 fs/smb/server/ksmbd_work.h                         |   9 +-
 fs/smb/server/mgmt/share_config.c                  |  43 +-
 fs/smb/server/mgmt/share_config.h                  |   2 +
 fs/smb/server/mgmt/user_session.c                  | 138 ++-
 fs/smb/server/mgmt/user_session.h                  |  18 +
 fs/smb/server/oplock.c                             |  46 +-
 fs/smb/server/oplock.h                             |   3 +-
 fs/smb/server/server.c                             |   8 +-
 fs/smb/server/smb2pdu.c                            | 862 ++++++++++++------
 fs/smb/server/smb2pdu.h                            |   1 +
 fs/smb/server/smb_common.c                         |   4 +-
 fs/smb/server/transport_ipc.c                      |  45 +-
 fs/smb/server/transport_ipc.h                      |  14 +-
 fs/smb/server/transport_tcp.c                      |   8 +-
 fs/smb/server/vfs.c                                |   9 +-
 fs/smb/server/vfs_cache.c                          |  31 +-
 fs/smb/smbdirect/accept.c                          |   2 +-
 fs/smb/smbdirect/connect.c                         |   2 +-
 fs/smb/smbdirect/connection.c                      |   2 +-
 fs/splice.c                                        |  43 +-
 fs/super.c                                         | 365 ++++----
 fs/xattr.c                                         |   2 +-
 include/acpi/acpi_bus.h                            |   2 +-
 include/acpi/ghes.h                                |   4 +
 include/asm-generic/mshyperv.h                     |   2 -
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/cxl/event.h                                |   4 +-
 include/drm/drm_timeout.h                          |  17 +
 include/drm/drm_utils.h                            |   2 -
 include/dt-bindings/clock/qcom,nord-nwgcc.h        |   3 +
 include/linux/acpi.h                               |  24 +-
 include/linux/bio-integrity.h                      |   3 +-
 include/linux/blk-mq.h                             |   9 +-
 include/linux/blkdev.h                             |   7 +-
 include/linux/bpf.h                                |  49 +-
 include/linux/bpf_local_storage.h                  |  13 +
 include/linux/bpf_verifier.h                       | 115 ++-
 include/linux/btf.h                                |   1 +
 include/linux/clk-provider.h                       |  22 +-
 include/linux/dax.h                                |   3 +-
 include/linux/device.h                             |   1 +
 include/linux/dibs.h                               |   6 +-
 include/linux/dma-fence.h                          |   2 +-
 include/linux/etherdevice.h                        |  28 +
 include/linux/firewire.h                           |   1 -
 include/linux/fortify-string.h                     |   2 -
 include/linux/fs/super_types.h                     |  11 +-
 include/linux/fs_context.h                         |   4 +
 include/linux/ftrace.h                             |   1 +
 include/linux/hrtimer.h                            |  24 +
 include/linux/i3c/master.h                         |   3 +
 include/linux/iomap.h                              |  11 +-
 include/linux/kernel_stat.h                        |   7 +-
 include/linux/kexec.h                              |   2 +
 include/linux/leds.h                               |  10 +
 include/linux/mfd/da9150/core.h                    |   1 +
 include/linux/mm.h                                 | 172 ++--
 include/linux/mm_types.h                           |  12 +-
 include/linux/mmap_lock.h                          |  54 +-
 include/linux/mtd/spinand.h                        |   2 +-
 include/linux/netdevice.h                          |   7 +
 include/linux/nfslocalio.h                         |  12 +
 include/linux/pci.h                                |   2 +
 include/linux/platform_data/dmtimer-omap.h         |   2 +
 include/linux/platform_data/mipi-i3c-hci.h         |   4 +
 include/linux/platform_data/x86/asus-wmi.h         |   3 +-
 include/linux/ppp_channel.h                        |   1 +
 include/linux/quotaops.h                           |   5 +
 include/linux/rcuref.h                             |   2 +-
 include/linux/sched.h                              |   5 +-
 include/linux/sched/ext.h                          |   1 +
 include/linux/seq_buf.h                            |   4 +-
 include/linux/skbuff.h                             |  12 +-
 include/linux/soc/ti/k3-ringacc.h                  |  31 +-
 include/linux/sunrpc/svc_rdma.h                    |   2 +-
 include/linux/trace_seq.h                          |   5 +-
 include/linux/vfio_pci_core.h                      |  41 +-
 include/linux/watch_queue.h                        |   6 +-
 include/net/bluetooth/bluetooth.h                  |   4 +-
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_h4.h                     |  60 ++
 include/net/bluetooth/hci_sync.h                   |   1 +
 include/net/cfg80211.h                             |  36 +-
 include/net/cipso_ipv4.h                           |  11 +-
 include/net/ip.h                                   |   2 +-
 include/net/ip_vs.h                                |  50 +-
 include/net/mac80211.h                             |   2 +
 include/net/mana/gdma.h                            | 121 ++-
 include/net/mana/mana.h                            |   1 +
 include/net/netfilter/nf_conntrack_seqadj.h        |   1 +
 include/net/netlabel.h                             |  11 +-
 include/net/netns/netfilter.h                      |   2 +
 include/net/seg6_hmac.h                            |   3 +-
 include/net/xsk_buff_pool.h                        |   3 +
 include/scsi/scsi_cmnd.h                           |   7 +
 include/scsi/scsi_common.h                         |  31 +-
 include/scsi/scsi_device.h                         |  37 +-
 include/scsi/scsi_proto.h                          |  20 +-
 include/scsi/scsi_sense.h                          | 950 ++++++++++++++++++++
 include/sound/aw88399.h                            |   5 +
 include/sound/control.h                            |   4 +-
 include/sound/core.h                               |   4 +-
 include/sound/hda_codec.h                          |   6 +-
 include/sound/hdaudio.h                            |   2 +
 include/sound/pcm.h                                |   2 +
 include/sound/pcm_oss.h                            |   1 +
 {sound/soc/sdca => include/sound}/sdca_class.h     |  14 +
 include/sound/soc-component.h                      |   2 +-
 include/sound/ump.h                                |   5 +
 include/trace/events/iocost.h                      |   7 +-
 include/trace/events/power.h                       |   3 +
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/drm/panfrost_drm.h                    |  29 +-
 include/uapi/linux/amd-pmf.h                       |   3 +
 include/uapi/linux/firewire-cdev.h                 |   4 +-
 include/uapi/linux/iommufd.h                       |   2 +-
 include/uapi/linux/nl80211.h                       |  31 +
 include/ufs/ufshcd.h                               |   8 +
 include/vdso/math64.h                              |  20 +
 init/do_mounts.c                                   |  10 +-
 init/main.c                                        |   8 +-
 kernel/bpf/arena.c                                 | 410 +++++----
 kernel/bpf/arraymap.c                              |   8 +-
 kernel/bpf/backtrack.c                             |  18 +-
 kernel/bpf/bpf_insn_array.c                        |  15 +-
 kernel/bpf/bpf_iter.c                              |  24 +-
 kernel/bpf/bpf_local_storage.c                     |  51 +-
 kernel/bpf/bpf_lsm.c                               |   4 +-
 kernel/bpf/btf.c                                   |  40 +-
 kernel/bpf/cfg.c                                   | 111 ++-
 kernel/bpf/const_fold.c                            |   2 +
 kernel/bpf/core.c                                  |  56 +-
 kernel/bpf/cpumap.c                                |  35 +-
 kernel/bpf/devmap.c                                |   1 +
 kernel/bpf/diagnostics.c                           |  37 +-
 kernel/bpf/fixups.c                                | 135 ++-
 kernel/bpf/hashtab.c                               |  32 +-
 kernel/bpf/helpers.c                               |  74 +-
 kernel/bpf/liveness.c                              | 586 ++++++++-----
 kernel/bpf/log.c                                   |  13 +-
 kernel/bpf/map_in_map.c                            |   7 +-
 kernel/bpf/offload.c                               |  25 +-
 kernel/bpf/states.c                                | 109 ++-
 kernel/bpf/stream.c                                |  64 +-
 kernel/bpf/syscall.c                               |  92 +-
 kernel/bpf/task_iter.c                             |  12 +-
 kernel/bpf/token.c                                 |   5 +-
 kernel/bpf/trampoline.c                            |  29 +-
 kernel/bpf/verifier.c                              | 590 +++++++++----
 kernel/cgroup/cgroup-internal.h                    |   2 +-
 kernel/cgroup/cgroup-v1.c                          |  16 +-
 kernel/cgroup/cgroup.c                             |  98 ++-
 kernel/cgroup/cpuset-internal.h                    |   6 +
 kernel/cgroup/cpuset.c                             | 502 +++++++----
 kernel/cgroup/debug.c                              |  10 +-
 kernel/cgroup/dmem.c                               |   4 +-
 kernel/debug/kdb/kdb_io.c                          |   1 -
 kernel/debug/kdb/kdb_main.c                        |   7 +-
 kernel/debug/kdb/kdb_private.h                     |   3 +-
 kernel/dma/debug.c                                 |   7 +-
 kernel/dma/direct.c                                |  22 +-
 kernel/events/core.c                               |   3 +
 kernel/fork.c                                      |  12 +-
 kernel/kcov.c                                      |  35 +-
 kernel/kexec_core.c                                |   7 +
 kernel/kexec_file.c                                |   4 +-
 kernel/kthread.c                                   |   2 +-
 kernel/module/tracking.c                           |   2 +-
 kernel/nsproxy.c                                   |   2 +-
 kernel/power/suspend.c                             |  20 +-
 kernel/profile.c                                   |   2 +-
 kernel/rcu/rcutorture.c                            |   2 +-
 kernel/rcu/srcutree.c                              |   7 +-
 kernel/rcu/tree_nocb.h                             |   3 +-
 kernel/reboot.c                                    |   4 +-
 kernel/resource_kunit.c                            |   3 +
 kernel/sched/core.c                                |  37 +-
 kernel/sched/cputime.c                             |  44 +-
 kernel/sched/deadline.c                            |   7 +-
 kernel/sched/ext/cid.c                             |   6 +
 kernel/sched/ext/ext.c                             | 459 +++++++---
 kernel/sched/ext/ext.h                             |   7 +
 kernel/sched/ext/inlines.h                         |  15 +-
 kernel/sched/ext/internal.h                        |  86 +-
 kernel/sched/ext/sub.c                             | 320 ++++++-
 kernel/sched/ext/sub.h                             |  12 +-
 kernel/sched/fair.c                                |  29 +-
 kernel/sched/idle.c                                |  21 +-
 kernel/sched/rt.c                                  |   7 +-
 kernel/sched/sched.h                               |  20 +-
 kernel/sched/stop_task.c                           |   5 +-
 kernel/signal.c                                    |   5 +-
 kernel/time/hrtimer.c                              |   8 +-
 kernel/time/tick-sched.c                           |  22 +-
 kernel/time/timeconv.c                             |   6 +-
 kernel/time/timer.c                                |   2 +
 kernel/time/vsyscall.c                             |  26 +-
 kernel/trace/bpf_trace.c                           |  29 +-
 kernel/trace/rv/monitors/wakeup/wakeup.c           |   6 +-
 kernel/trace/rv/rv_reactors.c                      |  10 +-
 kernel/trace/trace.h                               |   3 -
 kernel/trace/trace_btf.c                           |   3 +
 kernel/trace/trace_events_hist.c                   |  25 +-
 kernel/ucount.c                                    |   7 +-
 kernel/watch_queue.c                               |   2 +-
 kernel/watchdog_perf.c                             |   4 +-
 lib/Kconfig.debug                                  |   1 -
 lib/bitmap-str.c                                   |  24 +-
 lib/decompress_unlz4.c                             |   4 +
 lib/kobject.c                                      |   2 +-
 lib/maple_tree.c                                   |  43 +-
 lib/region_alloc_benchmark.c                       |   8 +-
 lib/seq_buf.c                                      |   2 +-
 lib/test_hmm.c                                     |   2 +
 lib/test_sysctl.c                                  |   2 +-
 lib/tests/seq_buf_kunit.c                          | 174 ++++
 lib/vdso/gettimeofday.c                            |   4 +-
 mm/gup.c                                           |  17 +-
 mm/gup_test.c                                      |  11 +-
 mm/madvise.c                                       |  10 +-
 mm/memblock.c                                      |   9 +-
 mm/memory_hotplug.c                                |   6 +-
 mm/mlock.c                                         |   6 +-
 mm/mmap_lock.c                                     | 150 +++-
 mm/mprotect.c                                      |   2 +-
 mm/shmem.c                                         |  22 +-
 mm/slab_common.c                                   |   4 +-
 mm/slub.c                                          |   1 +
 mm/userfaultfd.c                                   |  23 +-
 mm/vma.c                                           |  77 +-
 net/9p/trans_xen.c                                 |   4 +-
 net/Kconfig                                        |   1 -
 net/bluetooth/6lowpan.c                            |   3 +-
 net/bluetooth/Makefile                             |   2 +-
 net/bluetooth/hci_core.c                           |   4 +-
 net/bluetooth/hci_event.c                          | 104 ++-
 net/bluetooth/hci_h4.c                             | 160 ++++
 net/bluetooth/hci_sync.c                           |  66 +-
 net/bluetooth/iso.c                                |   3 +
 net/bluetooth/l2cap_core.c                         |   9 +
 net/bluetooth/mgmt.c                               | 122 ++-
 net/bluetooth/msft.c                               |   6 +
 net/bpf/test_run.c                                 |  27 +-
 net/bridge/br_mdb.c                                |  16 +-
 net/bridge/br_multicast.c                          |   9 +
 net/bridge/br_netlink.c                            |   2 +-
 net/bridge/br_private.h                            |   1 +
 net/ceph/messenger_v1.c                            |   8 +-
 net/core/bpf_ksock.c                               |   7 +-
 net/core/bpf_sk_storage.c                          |  79 +-
 net/core/dev.c                                     |  48 +-
 net/core/dev.h                                     |   1 +
 net/core/devmem.c                                  | 174 ++--
 net/core/devmem.h                                  |  41 +-
 net/core/filter.c                                  |  71 +-
 net/core/gro.c                                     |   5 +-
 net/core/net-sysfs.c                               |   7 +
 net/core/netdev-genl.c                             |  11 +-
 net/core/selftests.c                               |   2 +-
 net/core/skbuff.c                                  |  11 +-
 net/core/sock.c                                    |   3 +-
 net/core/sysctl_net_core.c                         |   7 +-
 net/dcb/dcbnl.c                                    |   2 +
 net/devlink/region.c                               |   5 +
 net/ethtool/ioctl.c                                |   7 +
 net/ipv4/cipso_ipv4.c                              |  16 +-
 net/ipv4/devinet.c                                 |  35 +-
 net/ipv4/gre_offload.c                             |   2 +-
 net/ipv4/inet_connection_sock.c                    |   3 +-
 net/ipv4/inet_fragment.c                           |  61 +-
 net/ipv4/ip_fragment.c                             |  13 +-
 net/ipv4/ip_output.c                               |  15 +-
 net/ipv4/ip_tunnel.c                               |  14 +-
 net/ipv4/ipmr.c                                    |   5 +
 net/ipv4/syncookies.c                              |  12 +-
 net/ipv4/tcp.c                                     |  26 +-
 net/ipv4/tcp_bic.c                                 |  14 +-
 net/ipv4/tcp_bpf.c                                 |   1 +
 net/ipv4/tcp_cubic.c                               |  14 +-
 net/ipv4/tcp_hybla.c                               |  16 +-
 net/ipv4/tcp_ipv4.c                                |  17 +-
 net/ipv4/tcp_metrics.c                             |  20 +-
 net/ipv4/tcp_offload.c                             |  12 +-
 net/ipv6/calipso.c                                 |   6 +-
 net/ipv6/exthdrs.c                                 |   2 +-
 net/ipv6/ip6_fib.c                                 |   4 -
 net/ipv6/ip6mr.c                                   |   6 +
 net/ipv6/netfilter/nf_conntrack_reasm.c            |  15 +-
 net/ipv6/reassembly.c                              |  13 +-
 net/ipv6/route.c                                   |  37 +-
 net/ipv6/seg6_hmac.c                               |   5 +-
 net/ipv6/seg6_local.c                              |   6 +-
 net/ipv6/sit.c                                     |   6 +-
 net/ipv6/tcp_ipv6.c                                |   9 +-
 net/mac80211/cfg.c                                 |  62 +-
 net/mac80211/debugfs.c                             |   2 +-
 net/mac80211/ieee80211_i.h                         |   6 +-
 net/mac80211/main.c                                |   2 +
 net/mac80211/mesh_pathtbl.c                        |  17 +-
 net/mac80211/mlme.c                                |  14 +-
 net/mac80211/nan.c                                 |  33 +
 net/mac80211/rate.c                                |   1 -
 net/mac80211/rx.c                                  |   1 +
 net/mac80211/s1g.c                                 |   8 -
 net/mac80211/tx.c                                  | 216 +++--
 net/mctp/route.c                                   |  10 +-
 net/mptcp/options.c                                |   9 +-
 net/netfilter/core.c                               |  18 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   8 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  38 +-
 net/netfilter/ipvs/ip_vs_dh.c                      |  16 +-
 net/netfilter/ipvs/ip_vs_fo.c                      |   2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   8 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |   2 +-
 net/netfilter/ipvs/ip_vs_mh.c                      |   2 +-
 net/netfilter/ipvs/ip_vs_nq.c                      |   2 +-
 net/netfilter/ipvs/ip_vs_ovf.c                     |   2 +-
 net/netfilter/ipvs/ip_vs_rr.c                      |   2 +-
 net/netfilter/ipvs/ip_vs_sed.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_sh.c                      |   2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |  23 +-
 net/netfilter/ipvs/ip_vs_twos.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_wlc.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_wrr.c                     |   2 +-
 net/netfilter/nf_conntrack_core.c                  |   5 +
 net/netfilter/nf_conntrack_seqadj.c                |  17 +
 net/netfilter/nf_flow_table_ip.c                   |   6 +-
 net/netfilter/nf_nat_core.c                        |  11 +
 net/netfilter/nf_synproxy_core.c                   |   4 +-
 net/netfilter/nfnetlink_hook.c                     |  74 +-
 net/netfilter/nft_compat.c                         |  15 +
 net/netfilter/nft_set_rbtree.c                     |   3 +-
 net/netfilter/xt_dccp.c                            |   2 +-
 net/netlabel/netlabel_kapi.c                       |  24 +-
 net/netlink/af_netlink.c                           |  12 +-
 net/openvswitch/actions.c                          |   9 +
 net/openvswitch/vport-internal_dev.c               |   8 +-
 net/psp/psp_sock.c                                 |  12 +
 net/rds/af_rds.c                                   |  29 +-
 net/rds/bind.c                                     |   4 +-
 net/rds/ib_sysctl.c                                |   2 +-
 net/rds/rdma_transport.c                           |   3 +
 net/rds/rds.h                                      |   3 +
 net/rds/recv.c                                     |  11 +-
 net/rds/send.c                                     |   9 +-
 net/rds/sysctl.c                                   |   2 +-
 net/rds/tcp.c                                      |   5 +-
 net/rxrpc/rxperf.c                                 |  25 +-
 net/rxrpc/sendmsg.c                                |  17 +-
 net/sched/act_api.c                                |  24 +-
 net/sched/sch_etf.c                                |   1 +
 net/sched/sch_gred.c                               |  16 +-
 net/sched/sch_taprio.c                             |   6 +-
 net/sctp/ipv6.c                                    |   6 +-
 net/sctp/sm_make_chunk.c                           |  24 +-
 net/sctp/sm_statefuns.c                            |   2 +-
 net/smc/smc_pnet.c                                 |  29 +-
 net/sunrpc/xprtsock.c                              |  34 +-
 net/tipc/bearer.c                                  |   4 +
 net/tipc/node.c                                    |   2 +-
 net/tls/tls_device.c                               |  45 +-
 net/tls/tls_main.c                                 |  26 +-
 net/tls/tls_sw.c                                   |   9 +-
 net/wireless/core.c                                |  35 +
 net/wireless/core.h                                |   4 +
 net/wireless/nl80211.c                             |  84 +-
 net/wireless/rdev-ops.h                            |  17 +
 net/wireless/reg.c                                 |  41 +-
 net/wireless/sme.c                                 |  38 +-
 net/wireless/trace.h                               |  25 +
 net/xdp/xsk.c                                      |   5 +
 net/xdp/xsk_buff_pool.c                            |  46 +-
 rust/Makefile                                      |   9 +-
 rust/helpers/dma.c                                 |   5 +
 rust/kernel/bitmap.rs                              |  17 +-
 rust/kernel/block/mq/tag_set.rs                    |   7 +
 rust/kernel/clk.rs                                 |  15 +
 rust/kernel/configfs.rs                            |  63 +-
 rust/kernel/i2c.rs                                 |  21 -
 rust/kernel/id_pool.rs                             |  15 +-
 rust/kernel/scatterlist.rs                         |  12 +-
 rust/kernel/sync/completion.rs                     |   2 +-
 rust/kernel/sync/lock/spinlock.rs                  |   2 +-
 rust/kernel/workqueue.rs                           |  52 +-
 rust/macros/lib.rs                                 |   2 +-
 rust/macros/module.rs                              |   2 +-
 rust/zerocopy-derive/README.md                     |   2 +-
 rust/zerocopy/README.md                            |   2 +-
 scripts/Makefile.vmlinux                           |  20 +-
 scripts/Makefile.vmlinux_o                         |   2 +-
 scripts/checkkconfigsymbols.py                     |   2 +-
 scripts/checkpatch.pl                              |   2 +
 scripts/clang-tools/run-clang-tools.py             |   1 +
 scripts/gcc-plugins/randomize_layout_plugin.c      |  61 +-
 scripts/gdb/linux/radixtree.py                     |  72 +-
 scripts/gdb/linux/stackdepot.py                    |   2 +-
 scripts/kconfig/conf.c                             |  19 +-
 scripts/kconfig/symbol.c                           |  39 +-
 scripts/kconfig/tests/conftest.py                  |  20 +-
 .../kconfig/tests/randconfig_probability/Kconfig   |  12 +
 .../tests/randconfig_probability/__init__.py       | 130 +++
 scripts/kconfig/tests/savedefconfig_range/Kconfig  |  60 ++
 .../kconfig/tests/savedefconfig_range/__init__.py  |   8 +
 scripts/kconfig/tests/savedefconfig_range/config   |   7 +
 .../tests/savedefconfig_range/expected_defconfig   |   0
 scripts/make_fit.py                                |   3 +-
 security/apparmor/af_inet.c                        |   5 +-
 security/apparmor/include/match.h                  |  11 +-
 security/apparmor/label.c                          |  14 +-
 security/apparmor/lsm.c                            |  19 +
 security/apparmor/match.c                          |  58 +-
 security/apparmor/net.c                            |   4 +-
 security/apparmor/policy_ns.c                      |   6 +-
 security/apparmor/policy_unpack.c                  |  10 +-
 security/integrity/ima/ima_template.c              |   5 +
 security/ipe/audit.c                               |   8 -
 security/security.c                                |   3 +-
 security/selinux/netlabel.c                        |   5 +-
 security/smack/smack_lsm.c                         |  14 +-
 sound/core/control_led.c                           |  62 +-
 sound/core/ctljack.c                               |   1 +
 sound/core/info.c                                  |   3 +-
 sound/core/init.c                                  |  47 +-
 sound/core/jack.c                                  |  11 +-
 sound/core/misc.c                                  |   5 +-
 sound/core/oss/mixer_oss.c                         |  36 +-
 sound/core/oss/pcm_oss.c                           |  12 +
 sound/core/pcm.c                                   |  13 +-
 sound/core/pcm_compat.c                            |   4 +-
 sound/core/pcm_lib.c                               |  16 +-
 sound/core/pcm_local.h                             |   6 +
 sound/core/pcm_native.c                            | 122 +--
 sound/core/rawmidi.c                               |   3 +
 sound/core/seq/seq_clientmgr.c                     |  21 +-
 sound/core/seq/seq_compat.c                        |  15 +-
 sound/core/seq/seq_ports.c                         |  41 +-
 sound/core/seq/seq_ports.h                         |   1 +
 sound/core/seq/seq_ump_client.c                    |   5 +-
 sound/core/timer.c                                 |   1 +
 sound/core/ump.c                                   |  61 +-
 sound/core/vmaster.c                               |  10 +-
 sound/drivers/aloop.c                              |  39 +-
 sound/drivers/pcmtest.c                            |  94 +-
 sound/hda/codecs/realtek/alc269.c                  |  64 +-
 sound/hda/common/bind.c                            |  15 +-
 sound/hda/common/codec.c                           |   4 +-
 sound/hda/common/hda_jack.h                        |   1 +
 sound/hda/common/jack.c                            |  88 +-
 sound/hda/controllers/intel.c                      |  33 +-
 sound/hda/core/bus.c                               |  30 +-
 sound/pci/oxygen/oxygen_pcm.c                      |  37 +-
 sound/pci/via82xx.c                                |  11 +-
 sound/sh/aica.c                                    |   2 +-
 sound/soc/amd/acp-es8336.c                         |   5 +-
 sound/soc/amd/acp/Kconfig                          |   4 +-
 sound/soc/amd/acp/acp-platform.c                   |   2 +-
 sound/soc/amd/acp/acp3x-es83xx/acp3x-es83xx.c      |  14 +-
 sound/soc/amd/ps/ps-pdm-dma.c                      |   2 +-
 sound/soc/amd/ps/ps-sdw-dma.c                      |   2 +-
 sound/soc/amd/raven/acp3x-pcm-dma.c                |   4 +-
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/amd/vangogh/acp5x-pcm-dma.c              |   2 +-
 sound/soc/amd/yc/acp6x-pdm-dma.c                   |   2 +-
 sound/soc/atmel/atmel-i2s.c                        |  43 +-
 sound/soc/atmel/atmel-pcm-pdc.c                    |   2 +
 sound/soc/codecs/ab8500-codec.c                    | 144 +--
 sound/soc/codecs/adau17x1.c                        |   4 +-
 sound/soc/codecs/ak4642.c                          |   3 +-
 sound/soc/codecs/aw88399-lib.c                     |  13 +
 sound/soc/codecs/cs42l56.c                         |   1 -
 sound/soc/codecs/da7213.c                          |  23 +-
 sound/soc/codecs/da732x.c                          |   2 +-
 sound/soc/codecs/es8316.c                          |   4 +-
 sound/soc/codecs/es8323.c                          |   4 +-
 sound/soc/codecs/es8326.c                          |  26 +-
 sound/soc/codecs/es8375.c                          |  20 +-
 sound/soc/codecs/es8375.h                          |   2 +-
 sound/soc/codecs/es8389.c                          |  20 +-
 sound/soc/codecs/fs210x.c                          |   5 +-
 sound/soc/codecs/mt6359-accdet.c                   |  50 +-
 sound/soc/codecs/nau8540.c                         |   4 +-
 sound/soc/codecs/nau8822.c                         |  15 +-
 sound/soc/codecs/rt1011.c                          |   4 +-
 sound/soc/codecs/rt1015.c                          |  81 +-
 sound/soc/codecs/rt1016.c                          |   4 +-
 sound/soc/codecs/rt1305.c                          |   4 +-
 sound/soc/codecs/rt1308.c                          |   4 +-
 sound/soc/codecs/rt1318.c                          |   3 +-
 sound/soc/codecs/rt1320-sdw.c                      |   2 +-
 sound/soc/codecs/rt5616.c                          |   3 +-
 sound/soc/codecs/rt5645.c                          |   7 +-
 sound/soc/codecs/rt5659.c                          |  10 +-
 sound/soc/codecs/rt5660.c                          |   4 +-
 sound/soc/codecs/rt5665.c                          |   4 +-
 sound/soc/codecs/rt5682-sdw.c                      |   3 +-
 sound/soc/codecs/rt711-sdca-sdw.c                  |   6 +-
 sound/soc/codecs/rt711-sdw.c                       |   8 +-
 sound/soc/codecs/rt712-sdca-sdw.c                  |   6 +-
 sound/soc/codecs/rt712-sdca.c                      |   5 +-
 sound/soc/codecs/rt721-sdca-sdw.c                  |   6 +-
 sound/soc/codecs/rt722-sdca-sdw.c                  |   6 +-
 sound/soc/codecs/sma1307.c                         |  14 +-
 sound/soc/codecs/sta32x.c                          | 121 ++-
 sound/soc/codecs/sta350.c                          |  20 +-
 sound/soc/codecs/tas2781-fmwlib.c                  |   6 +-
 sound/soc/codecs/tlv320adc3xxx.c                   |   2 +-
 sound/soc/codecs/tlv320aic32x4.c                   |   2 +-
 sound/soc/codecs/tlv320aic32x4.h                   |   1 +
 sound/soc/codecs/wcd-mbhc-v2.c                     |   8 +-
 sound/soc/codecs/wcd937x.c                         |  44 +-
 sound/soc/codecs/wcd939x.c                         |  10 +-
 sound/soc/codecs/wcd939x.h                         |   1 -
 sound/soc/codecs/wm5100.c                          |   2 +-
 sound/soc/codecs/wm8510.c                          |   2 +-
 sound/soc/codecs/wm8737.c                          |   8 +-
 sound/soc/codecs/wm8750.c                          |   2 +-
 sound/soc/codecs/wm8955.c                          |   2 +-
 sound/soc/codecs/wm8983.c                          |   2 +-
 sound/soc/codecs/wm8985.c                          |   2 +-
 sound/soc/codecs/wm8990.c                          |  10 +-
 sound/soc/codecs/wm8991.c                          |  10 +-
 sound/soc/codecs/wm8994.c                          | 159 ++--
 sound/soc/codecs/wm8994.h                          |   2 +
 sound/soc/codecs/wm_hubs.c                         |   2 +-
 sound/soc/codecs/wsa881x.c                         |  18 +-
 sound/soc/codecs/wsa883x.c                         |   8 +-
 sound/soc/codecs/wsa884x.c                         |   8 +-
 sound/soc/dwc/dwc-i2s.c                            |   6 +-
 sound/soc/fsl/fsl_asrc.c                           |   8 +-
 sound/soc/fsl/fsl_asrc_dma.c                       |   5 +
 sound/soc/fsl/fsl_asrc_m2m.c                       |   4 +-
 sound/soc/fsl/imx-pcm-rpmsg.c                      |   2 +-
 sound/soc/intel/atom/sst-mfld-platform-pcm.c       |   2 +-
 sound/soc/intel/avs/pcm.c                          |   2 +
 sound/soc/intel/avs/utils.c                        |   6 +-
 sound/soc/mediatek/common/mtk-afe-fe-dai.c         |   8 +-
 sound/soc/mediatek/common/mtk-soundcard-driver.c   |  67 +-
 sound/soc/mediatek/mt6797/mt6797-afe-clk.c         |  14 +-
 sound/soc/mediatek/mt8183/mt8183-afe-clk.c         |  22 +-
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c         |  95 +-
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c         | 104 ++-
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c         |  24 +-
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c      |  12 +-
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |   3 +
 sound/soc/mediatek/mt8189/mt8189-afe-clk.c         | 127 ++-
 sound/soc/mediatek/mt8189/mt8189-afe-pcm.c         |  40 +-
 sound/soc/mediatek/mt8189/mt8189-dai-i2s.c         |  18 +-
 sound/soc/mediatek/mt8189/mt8189-dai-tdm.c         |  19 +-
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c         | 139 +--
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c        |  86 +-
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |   6 +-
 sound/soc/mediatek/mt8192/mt8192-dai-adda.c        |  44 +-
 sound/soc/mediatek/mt8192/mt8192-dai-i2s.c         |  20 +-
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c         |  18 +-
 .../mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c  |  37 +-
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c         |  77 +-
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c         | 102 ++-
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c        |  99 ++-
 sound/soc/mediatek/mt8196/mt8196-afe-clk.c         | 138 ++-
 sound/soc/mediatek/mt8196/mt8196-afe-pcm.c         |  18 +-
 sound/soc/mediatek/mt8196/mt8196-dai-i2s.c         |  17 +-
 sound/soc/mediatek/mt8196/mt8196-dai-tdm.c         |  16 +-
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c         |   7 +-
 sound/soc/mediatek/mt8365/mt8365-dai-i2s.c         |   2 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   1 +
 sound/soc/qcom/sdm845.c                            |  19 +-
 sound/soc/renesas/rcar/msiof.c                     |   6 +-
 sound/soc/rockchip/rk3288_hdmi_analog.c            |  42 +-
 sound/soc/rockchip/rockchip_i2s.c                  |   4 +-
 sound/soc/rockchip/rockchip_sai.c                  |   4 +-
 sound/soc/samsung/midas_wm1811.c                   |  14 +-
 sound/soc/sdca/sdca_class.c                        |  82 +-
 sound/soc/sdca/sdca_class_function.c               |   2 +-
 sound/soc/sdca/sdca_fdl.c                          |  18 +-
 sound/soc/soc-ac97.c                               |   4 +-
 sound/soc/soc-card-test.c                          |   7 +-
 sound/soc/soc-component.c                          |   2 +-
 sound/soc/soc-link.c                               |   2 +-
 sound/soc/soc-ops.c                                |  10 +-
 sound/soc/soc-topology-test.c                      |   8 +-
 sound/soc/sof/amd/acp.c                            |  11 +-
 sound/soc/sof/imx/imx-common.c                     |   1 +
 sound/soc/sof/intel/hda-codec.c                    |   4 +-
 sound/soc/sof/intel/hda-ctrl.c                     |   1 +
 sound/soc/sof/intel/hda.c                          |   4 +
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  18 +-
 sound/usb/6fire/control.c                          |   7 +
 sound/usb/caiaq/device.c                           |   9 +-
 sound/usb/caiaq/device.h                           |   6 +-
 sound/usb/caiaq/input.c                            |  29 +-
 sound/usb/caiaq/midi.c                             |   2 +
 sound/usb/line6/capture.c                          |   3 +-
 sound/usb/line6/pcm.c                              |   8 +-
 sound/usb/mixer.c                                  | 172 +++-
 sound/usb/mixer.h                                  |  10 +-
 sound/usb/mixer_quirks.c                           |   2 +-
 sound/usb/mixer_scarlett.c                         |  18 +-
 sound/usb/mixer_us16x08.c                          |  39 +-
 sound/usb/quirks-table.h                           |   2 +
 sound/usb/quirks.c                                 |   9 +-
 sound/usb/usx2y/us122l.c                           |   2 +-
 sound/virtio/virtio_pcm.h                          |   2 +
 sound/virtio/virtio_pcm_msg.c                      |  19 +
 sound/virtio/virtio_pcm_ops.c                      |   1 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  11 +-
 tools/bpf/bpftool/btf.c                            |   6 +-
 tools/bpf/bpftool/common.c                         |  40 +
 tools/bpf/bpftool/gen.c                            |  26 +-
 tools/bpf/bpftool/link.c                           |   4 +-
 tools/bpf/bpftool/main.c                           |  16 +-
 tools/bpf/bpftool/main.h                           |   1 +
 tools/bpf/bpftool/map.c                            |  95 +-
 tools/bpf/bpftool/prog.c                           | 240 +++--
 tools/bpf/bpftool/skeleton/profiler.bpf.c          |  29 +-
 tools/bpf/bpftool/tracelog.c                       |   2 +-
 tools/bpf/resolve_btfids/main.c                    |   3 +-
 tools/build/feature/test-libdw.c                   |  10 +-
 tools/cgroup/iocost_monitor.py                     |   7 +-
 tools/cgroup/memcg_shrinker.py                     |   2 +-
 tools/hv/vmbus_bufring.c                           |   6 -
 tools/include/nolibc/dirent.h                      |   7 +-
 tools/include/nolibc/err.h                         |   2 +-
 tools/include/nolibc/stdlib.h                      |   8 +-
 tools/include/nolibc/sys/select.h                  |   6 +-
 tools/include/nolibc/types.h                       |   2 +-
 tools/lib/api/fd/array.c                           |   4 +
 tools/lib/bpf/btf.c                                |  16 +-
 tools/lib/bpf/libbpf.c                             |  53 +-
 tools/lib/bpf/skel_internal.h                      |  48 +-
 tools/lib/bpf/usdt.c                               |   4 +
 tools/lib/perf/evlist.c                            |   5 +-
 tools/lib/perf/include/internal/evsel.h            |   2 +
 tools/lib/perf/mmap.c                              |   2 +-
 tools/perf/Build                                   |   4 +-
 tools/perf/Documentation/perf-c2c.txt              |   2 +-
 tools/perf/Documentation/perf-record.txt           |   7 +-
 tools/perf/Documentation/perf-sched.txt            |   6 +-
 tools/perf/Makefile.config                         |  15 +-
 tools/perf/Makefile.perf                           |  25 +-
 tools/perf/arch/arm/tests/dwarf-unwind.c           |   1 +
 tools/perf/arch/arm64/tests/dwarf-unwind.c         |   1 +
 tools/perf/arch/powerpc/tests/dwarf-unwind.c       |   1 +
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  |   4 +-
 tools/perf/arch/x86/tests/topdown.c                |  30 +
 tools/perf/arch/x86/util/topdown.c                 |   3 +-
 tools/perf/builtin-buildid-list.c                  |  17 +-
 tools/perf/builtin-c2c.c                           |  16 +-
 tools/perf/builtin-inject.c                        |   3 +
 tools/perf/builtin-lock.c                          |  61 +-
 tools/perf/builtin-record.c                        |  15 +
 tools/perf/builtin-sched.c                         | 195 +++--
 tools/perf/builtin-stat.c                          |   4 +-
 tools/perf/builtin-trace.c                         |   9 +-
 tools/perf/pmu-events/Build                        |   6 +-
 .../arch/x86/clearwaterforest/pipeline.json        |   3 +-
 .../arch/x86/clearwaterforest/uncore-cache.json    |   5 +
 .../x86/clearwaterforest/uncore-interconnect.json  |   2 +
 .../perf/pmu-events/arch/x86/lunarlake/cache.json  |   3 +
 .../pmu-events/arch/x86/lunarlake/pipeline.json    |   2 +
 .../arch/x86/sierraforest/uncore-cache.json        |   5 +
 .../arch/x86/sierraforest/uncore-interconnect.json |   2 +
 .../arch/x86/skylakex/uncore-interconnect.json     |   6 +
 .../arch/x86/snowridgex/uncore-cache.json          |  68 ++
 .../arch/x86/snowridgex/uncore-interconnect.json   |  10 +
 tools/perf/pmu-events/jevents.py                   |  11 +-
 tools/perf/tests/Build                             |   4 +-
 tools/perf/tests/code-reading.c                    |  12 +-
 tools/perf/tests/demangle-java-test.c              |   1 +
 tools/perf/tests/demangle-rust-v0-test.c           |   1 +
 tools/perf/tests/fdarray.c                         |  32 +
 tools/perf/tests/hists_cumulate.c                  |   2 +-
 tools/perf/tests/hists_filter.c                    |   2 +-
 tools/perf/tests/hists_link.c                      |   2 +-
 tools/perf/tests/hists_output.c                    |   2 +-
 tools/perf/tests/make                              |   3 -
 tools/perf/tests/pe-file-parsing.c                 |   2 +-
 tools/perf/tests/sample-parsing.c                  | 109 +++
 tools/perf/tests/shell/attr.sh                     |   7 +-
 tools/perf/tests/shell/attr/README                 |  10 +-
 tools/perf/tests/shell/attr/base-record            |   2 +-
 tools/perf/tests/shell/attr/base-stat              |   2 +-
 tools/perf/tests/shell/attr/base-stat-group        |  45 +
 tools/perf/tests/shell/attr/system-wide-dummy      |   2 +-
 tools/perf/tests/shell/attr/test-record-dummy-C0   |   2 +-
 .../perf/tests/shell/attr/test-record-graph-dwarf  |   2 +-
 .../tests/shell/attr/test-record-group-sampling    |   4 +-
 .../tests/shell/attr/test-record-group-sampling1   |   4 +-
 .../tests/shell/attr/test-record-group-sampling2   |   4 +-
 tools/perf/tests/shell/attr/test-record-group1     |   2 +-
 tools/perf/tests/shell/attr/test-record-group2     |   2 +-
 tools/perf/tests/shell/attr/test-record-group3     |   2 +-
 tools/perf/tests/shell/attr/test-stat-default      |  90 +-
 tools/perf/tests/shell/attr/test-stat-detailed-1   |  98 ++-
 tools/perf/tests/shell/attr/test-stat-detailed-2   | 110 ++-
 tools/perf/tests/shell/attr/test-stat-detailed-3   | 114 ++-
 tools/perf/tests/shell/attr/test-stat-group1       |   2 +-
 tools/perf/tests/shell/c2c.sh                      |   1 +
 tools/perf/tests/shell/coresight/callchain.sh      |   7 +-
 tools/perf/tests/shell/data_type_profiling.sh      |  46 +-
 tools/perf/tests/shell/lib/attr.py                 |  11 +-
 tools/perf/tests/shell/schedstat_snapshots.sh      | 155 ++++
 tools/perf/tests/shell/stat.sh                     |   5 +
 tools/perf/tests/shell/test_event_open_fallback.sh |   2 -
 tools/perf/tests/symbols.c                         |  96 +-
 tools/perf/tests/thread-maps-share.c               |   3 +-
 tools/perf/tests/workloads/code_with_type.c        |   2 +-
 tools/perf/ui/browsers/annotate-data.c             |   2 +-
 tools/perf/util/Build                              |   2 +-
 tools/perf/util/addr2line.c                        |  68 +-
 tools/perf/util/annotate-data.c                    |  21 +-
 tools/perf/util/aslr.c                             |  10 +-
 tools/perf/util/aslr.h                             |   2 +
 tools/perf/util/bpf-filter.c                       |  29 +-
 tools/perf/util/cs-etm.c                           |  12 +-
 tools/perf/util/debug.c                            |   2 +-
 tools/perf/util/dso.c                              |  61 +-
 tools/perf/util/dso.h                              |  26 +-
 tools/perf/util/dwarf-aux.c                        |  56 +-
 tools/perf/util/dwarf-aux.h                        |  13 +
 tools/perf/util/evlist.c                           |   6 +-
 tools/perf/util/evsel.c                            |  92 +-
 tools/perf/util/evsel.h                            |   1 +
 tools/perf/util/header.c                           |  18 +-
 tools/perf/util/jitdump.c                          | 126 ++-
 tools/perf/util/libbfd.c                           |  76 +-
 tools/perf/util/libbfd.h                           |   9 +
 tools/perf/util/libdw.c                            |  54 +-
 tools/perf/util/libdw.h                            |   5 +-
 tools/perf/util/llvm-c-helpers.cpp                 |  66 +-
 tools/perf/util/llvm.c                             |  16 +-
 tools/perf/util/machine.c                          |   4 +-
 tools/perf/util/machine.h                          |  10 +-
 tools/perf/util/mem-events.c                       |   2 +-
 tools/perf/util/mmap.c                             |   3 +-
 tools/perf/util/parse-events.c                     |   3 +-
 tools/perf/util/pmus.c                             |  21 +-
 tools/perf/util/print_insn.h                       |   1 +
 tools/perf/util/python.c                           |   1 +
 tools/perf/util/session.c                          |   2 +-
 tools/perf/util/setup.py                           |   1 +
 tools/perf/util/srcline.c                          |  83 +-
 tools/perf/util/symbol.c                           |  40 +-
 tools/perf/util/synthetic-events.c                 |  16 +-
 tools/perf/util/thread.c                           |   8 +-
 tools/perf/util/thread_map.c                       |  26 +
 tools/perf/util/thread_map.h                       |   1 +
 tools/perf/util/tp_pmu.c                           |   8 +-
 tools/perf/util/unwind-libdw.c                     |   2 +
 tools/perf/util/unwind-libunwind.c                 |  62 +-
 tools/power/x86/turbostat/turbostat.c              |   8 +-
 .../x86_energy_perf_policy.c                       |  18 +-
 tools/sched_ext/include/scx/enum_defs.autogen.h    |   1 +
 tools/sched_ext/scx_flatcg.bpf.c                   |   2 +-
 tools/testing/cxl/test/cxl.c                       |   8 +-
 tools/testing/selftests/Makefile                   |   4 +-
 tools/testing/selftests/alsa/mixer-test.c          |   2 +
 tools/testing/selftests/alsa/test-pcmtest-driver.c |  27 +-
 tools/testing/selftests/arm64/signal/Makefile      |   4 +-
 tools/testing/selftests/bpf/Makefile               |   8 +-
 .../selftests/bpf/bpftool_btf_dump_sorted.expected |  48 +
 .../bpf/bpftool_btf_dump_unsorted.expected         |  48 +
 tools/testing/selftests/bpf/bpftool_helpers.c      |   7 +-
 tools/testing/selftests/bpf/network_helpers.c      |  46 +-
 .../selftests/bpf/prog_tests/bpftool_btf_dump.c    | 178 ++++
 .../bpf/prog_tests/cgroup_hierarchical_stats.c     |   4 +-
 .../testing/selftests/bpf/prog_tests/dmabuf_iter.c |   5 +-
 tools/testing/selftests/bpf/prog_tests/empty_skb.c |  19 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   2 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |  96 +-
 .../selftests/bpf/prog_tests/lwt_ip_encap.c        |  53 ++
 tools/testing/selftests/bpf/prog_tests/missed.c    |   8 +-
 .../bpf/prog_tests/prog_tests_framework.c          |  16 +-
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |   4 +-
 .../bpf/prog_tests/test_struct_ops_assoc.c         |  37 +-
 .../selftests/bpf/prog_tests/test_task_work.c      |   2 +-
 .../testing/selftests/bpf/prog_tests/test_tc_edt.c |  13 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |  13 +-
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   |   4 +-
 tools/testing/selftests/bpf/prog_tests/wq.c        |   5 +-
 .../testing/selftests/bpf/progs/cpumask_success.c  |   6 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |   4 +-
 .../bpf/progs/struct_ops_assoc_in_timer.c          |  16 +
 .../selftests/bpf/progs/test_global_percpu_data.c  |  10 +-
 tools/testing/selftests/bpf/progs/test_tc_edt.c    |  13 +-
 tools/testing/selftests/bpf/progs/test_tc_link.c   |  10 +
 .../selftests/bpf/progs/verifier_jit_inline.c      |   2 +-
 tools/testing/selftests/bpf/progs/verifier_ldsx.c  |  17 +
 .../selftests/bpf/progs/verifier_stack_arg.c       |   4 +-
 tools/testing/selftests/bpf/test_progs.c           |   5 +-
 tools/testing/selftests/bpf/unpriv_helpers.c       |   9 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |  54 +-
 tools/testing/selftests/cgroup/test_zswap.c        |  22 +-
 .../selftests/clone3/clone3_clear_sighand.c        |   6 +-
 .../selftests/coredump/coredump_test_helpers.c     |   8 +-
 .../selftests/damon/sysfs_no_op_commit_break.py    |  35 +-
 tools/testing/selftests/drivers/net/psp.py         |  56 +-
 tools/testing/selftests/exec/Makefile              |   2 +-
 tools/testing/selftests/filelock/ofdlocks.c        |   2 +-
 .../filesystems/epoll/epoll_wakeup_test.c          |  32 +-
 .../selftests/filesystems/fscontext_ns/.gitignore  |   2 +
 .../filesystems/overlayfs/set_layers_via_fds.c     |  18 +-
 tools/testing/selftests/ftrace/ftracetest          |   2 +-
 .../selftests/namespaces/ns_active_ref_test.c      |  29 +
 tools/testing/selftests/net/lib/csum.c             |  55 +-
 tools/testing/selftests/net/lib/gro.c              |   2 -
 .../selftests/net/netfilter/conntrack_vrf.sh       |  25 +-
 tools/testing/selftests/net/tcp_mmap.c             |   6 +-
 tools/testing/selftests/net/txtimestamp.c          |  23 +-
 tools/testing/selftests/nolibc/Makefile            |   2 +-
 tools/testing/selftests/pidfd/pidfd_open_test.c    |   2 +-
 tools/testing/selftests/proc/proc-pid-vm.c         |  14 +-
 tools/testing/selftests/rdma/config                |  12 +-
 .../testing/selftests/rdma/rxe_sent_rcvd_bytes.sh  |   6 +
 tools/testing/selftests/sched_ext/hotplug.c        |  34 +-
 tools/testing/selftests/sched_ext/rt_stall.c       |  80 +-
 tools/testing/selftests/sched_ext/runner.c         |   2 +-
 .../selftests/tc-testing/tc-tests/qdiscs/hfsc.json |   2 +-
 .../selftests/thermal/intel/power_floor/Makefile   |  12 +-
 .../selftests/thermal/intel/workload_hint/Makefile |  12 +-
 .../testing/selftests/timers/clocksource-switch.c  |  23 +-
 tools/testing/selftests/ublk/fault_inject.c        |  14 +-
 tools/testing/selftests/vfio/lib/sysfs.c           |   1 +
 tools/testing/shared/linux.c                       |   4 +-
 tools/testing/vma/include/dup.h                    |  82 +-
 tools/testing/vma/include/stubs.h                  |   2 +-
 tools/testing/vma/shared.c                         |   8 +-
 tools/testing/vma/shared.h                         |  16 +-
 tools/thermal/tmon/tmon.c                          |   2 +-
 tools/tracing/rtla/tests/engine.sh                 |   2 +-
 usr/gen_init_cpio.c                                |   1 +
 2345 files changed, 39802 insertions(+), 17994 deletions(-)


