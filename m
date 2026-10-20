Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792483075;
	b=pHDHfZx7GeIGl1yDKF8+dp6tdkAOCMv/DYl7XAS0kb2vVmNgfv5A/CMASSQCrDx3ooTE
	 MrlCu31+E6+WiYFRt/rUG1zj71TEjVHBQoZ6655UPaEAekAL1MWu0Q7Sif36zklfaXD14
	 UXYt+Z7IOjAtR1SExWZeip3VsPMX9EwbvVDWYOS4UFTNWMMYcFK9ujGgk+YH2zbW+bI88
	 +ltJZvoH6m38Ixn/sysK7qEPwliCGfj+IhfkBblDd8khLn61bcowxdFt0rEOeqqhbzwIv
	 l5qV1JGwoos+mpCsq73t0QPB/Sp34hjsrZ8n2gIx9Wlgum6FgSsdEBJ3q7wJumx9vAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792483075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=/BswfU8RkqmLremjMCfcnYFrXqy1jLgg9acWPoP9Ezs=;
	b=1v9clgGmlPHAh0tvd8evIq1GZJINMOAvw+dJu6lHwVIL3tNQXJrMdROZQ8UJPaPqJWbm
	 b5CFRRVegHGMTMoiBezz7AEGqY0qGwn7agGGD0yuuGGUvXpSInxo14QG8elyRpPVcP0nd
	 UvzdatzoKHA3QY5gR398Ck22cy2ROzsFgW5wejmxIR/8mduKRwnIh6H2mFGfcYng/kGvL
	 5G1X3LJ3IMoQMpbteBJl0mU5iyQo1rgBdxPlVDLqwfz1dZvyDTUxEhl3VQRQ1dSO9GgG+
	 teoTlFiYkstpkeQtaRTSSfOSpixpwg6xNHVFvBHpsqkN3tNDsojzm15lZsAtjtf8/zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITprceSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B927606A320;
	Tue, 20 Oct 2026 07:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITprceSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4811F000C8;
	Tue, 20 Oct 2026 07:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792483073;
	bh=/BswfU8RkqmLremjMCfcnYFrXqy1jLgg9acWPoP9Ezs=;
	h=From:To:Cc:Subject:Date;
	b=ITprceSBxKBxICkXf4+BmPjYOq6jyUOvlkTQj1NXdpsrnw6GJ21yhXGwUrf5HWjqs
	 RVFXrL7DDdfAi+9sd+mP1XlhBJM1BxiWuDTBJCFap3vd/64bKyxntPTjD1k7Ro5uqa
	 lkEQEVzCnVKRJZewDq2xZvDhGkzqfMZHj/5O8u7Y=
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
Subject: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
Date: Tue, 20 Oct 2026 09:57:46 +0200
Message-ID: <20261020075535.084584701@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.160-rc2
X-KernelTest-Deadline: 2026-10-22T07:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.160 release.
There are 1651 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 22 Oct 2026 07:53:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.160-rc2

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86: Use active memslots for the per-vCPU MMIO cache

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: fix heap out-of-bounds write in krb5_authenticate()

Mattia Meleleo <mattia.meleleo@coralogix.com>
    bpf, sockmap: Account for receive queue in FIONREAD without a verdict program

Dave Chinner <dchinner@redhat.com>
    xfs: fix unmount hang with unflushable inodes stuck in the AIL

Dave Chinner <dchinner@redhat.com>
    xfs: factor out stale buffer item completion

Dave Chinner <dchinner@redhat.com>
    xfs: rearrange code in xfs_buf_item.c

Dave Chinner <dchinner@redhat.com>
    xfs: catch stale AGF/AGF metadata

Dave Chinner <dchinner@redhat.com>
    xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock

Eduard Zingerman <eddyz87@gmail.com>
    bpf: abort verification if env->cur_state->loop_entry != NULL

ThangNN99 <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained

Baokun Li <libaokun1@huawei.com>
    Revert "mm/filemap: avoid buffered read/write race to read inconsistent data"

Namjae Jeon <linkinjeon@kernel.org>
    Revert "ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: remove original workaround for RTL8125 broken rx issue

Ze Tan <tanze@kylinos.cn>
    smb/server: fix tree connection leak in smb2_tree_connect()

Li Chen <me@linux.beauty>
    nvdimm: pmem: keep PREFLUSH before data writes

Benjamin Leggett <benjamin@edera.io>
    drm/virtio: use the DMA API for resource backing on Xen

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: validate GUD_ROTATION_0 is present in supported rotations

Eduard Zingerman <eddyz87@gmail.com>
    bpf: check_cond_jmp_op(): properly infer if register is null

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for insert range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: validate new EOF for zero range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: fix stale page cache in insert/collapse range

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: invalidate fscache for fallocate range operations

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: propagate DACL parsing errors

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix out-of-bounds write in l2cap_ecred_connect

Eric Dumazet <edumazet@google.com>
    igmp: convert struct ip_sf_list to RCU

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use rcu_assign_pointer() for __rcu list updates

David Laight <david.laight.linux@gmail.com>
    tipc: Dont send random pad bytes in RESET/ACTIVATE messages

Eduard Zingerman <eddyz87@gmail.com>
    bpf: backtrack_insn(): Handle ld_{abs,ind} subprog exit edge

Eduard Zingerman <eddyz87@gmail.com>
    bpf: backtracking shouldn't clear outer frame R1-R5 for callbacks

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: finish active block group cleanup if call_zone_finish() fails

FAN YE <fy15309206903@gmail.com>
    btrfs: zstd: fix lost wakeup when waiting for a workspace

Kuniyuki Iwashima <kuniyu@google.com>
    net: Remove conflicting altnames for dying netns in __dev_change_net_namespace().

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    net: plumb extack in __dev_change_net_namespace()

Gao Xiang <xiang@kernel.org>
    erofs: disable LZ4 rolling decompression for now

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark syscall helpers as sleepable

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvme: remove stale namespaces by NSID range during scan

Stuart Hayes <stuart.w.hayes@gmail.com>
    nvme_core: scan namespaces asynchronously

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't infer non-NULL from a pointer with an unbounded offset

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't predict JMP32 pointer vs zero comparisons

Andrii Nakryiko <andrii@kernel.org>
    bpf: generalize is_scalar_branch_taken() logic

Andrii Nakryiko <andrii@kernel.org>
    bpf: unify 32-bit and 64-bit is_branch_taken logic

Andrii Nakryiko <andrii@kernel.org>
    bpf: generalize is_branch_taken to handle all conditional jumps in one place

Andrii Nakryiko <andrii@kernel.org>
    bpf: move is_branch_taken() down

Andrii Nakryiko <andrii@kernel.org>
    bpf: generalize is_branch_taken() to work with two registers

Andrii Nakryiko <andrii@kernel.org>
    bpf: rename is_branch_taken reg arguments to prepare for the second one

Andrii Nakryiko <andrii@kernel.org>
    bpf: Improve JEQ/JNE branch taken logic

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark NULL kptr stores precise

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Preserve inner map identity in callback frames

Jamal Hadi Salim <jhs@mojatatu.com>
    net: reject oversized tx_queue_len at netlink parse time

Eduard Zingerman <eddyz87@gmail.com>
    bpf: mark a NULL call argument precise

Karl Mehltretter <kmehltretter@gmail.com>
    iommu/amd: Do not reallocate GA log buffers on resume

Alexander Graf <graf@amazon.com>
    virtio_ring: fix stale descriptor flags after a failed packed add

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: protect config_ctx from being freed under the config callback

Christian Brauner <brauner@kernel.org>
    eventfd: simplify eventfd_signal()

Jia Jia <physicalmtea@gmail.com>
    vduse: validate virtqueue alignment

Jia Jia <physicalmtea@gmail.com>
    vhost: invalidate vring access on IOTLB transitions

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Update last skb marker in manage_oob().

Jakub Kicinski <kuba@kernel.org>
    eth: ice: don't dereference pointers from TP_printk()

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()

Eric Dumazet <edumazet@google.com>
    vxlan: initialize _md in vxlan_xmit_one()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Move representor vnic reporter to eswitch devlink port

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Prevent drain_pebs() reentry

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TX descriptor availability check for TSO traffic

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: pin the symlink target's dirent instead of chasing ->ci_dentry

Al Viro <viro@zeniv.linux.org.uk>
    configfs:get_target() - release path as soon as we grab configfs_item reference

Christian Brauner <brauner@kernel.org>
    path: add cleanup helper

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    configfs: unhash the dentry before dropping the item in rmdir

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    reboot: fix cad_pid use-after-free race

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening a tracer options file

Tristan Madani <tristan@talencesecurity.com>
    ALSA: usbusx2y: validate URB actual_length in interrupt callback

Takashi Iwai <tiwai@suse.de>
    ALSA: usx2y: Use standard print API

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Take the reference before publishing the named histogram trigger

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Undo the registration when enabling the histogram trigger fails

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate full buffer range in ivpu_to_cpu_addr

Magdalena Schulfer <magdalena.schulfer@intel.com>
    accel/ivpu: Validate firmware log buffer metadata

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    accel/ivpu: Limit firmware log name prints to field size

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix integer overflow in initrd size check

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: cttimeout: prevent UAF during module unload

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: flowlabel: cap duplicate leases per socket

Xixin Liu <liuxixin@kylinos.cn>
    perf: RISC-V: store available counter mask as bitmap

Kalpan Jani <kalpan.jani@mpiricsoftware.com>
    mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0

Paulo Alcantara <pc@manguebit.org>
    smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid

Bjoern Doebel <doebel@amazon.de>
    smb: client: fail DACL rewrite when the new DACL exceeds 64K

Paulo Alcantara <pc@manguebit.org>
    smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

Daeho Jeong <daehojeong@google.com>
    f2fs: accurately adjust free_sections during free_segment_range

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip vport under deletion in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: cfg80211: reject duplicate wiphy cipher suite entries

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate external xattr entries when reading metadata

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix memory leak in error path of build_tree()

Jeff Layton <jlayton@kernel.org>
    nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Validate Read chunk positions before reconstruction

Shuai Xue <xueshuai@linux.alibaba.com>
    iommu/sva: Set handle->dev before the SVA handle is visible

Yi Liu <yi.l.liu@intel.com>
    iommu: Pass domain to remove_dev_pasid() op

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix error-path detection with md_cloned_bio()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix bio accounting for split md cloned bios

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock cloning inline extent when using flushoncommit

Jordan Walters <jaggyaur@gmail.com>
    Bluetooth: hci_core: Fix UAF in hci_unregister_dev()

Dan Williams <djbw@kernel.org>
    cxl/region: Resolve region deletion races

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: hand off the pinned file reference to accept_doit

Gao Xiang <xiang@kernel.org>
    erofs: fix use-after-free on sbi->sync_decompress

Florian Westphal <fw@strlen.de>
    netfilter: revalidate bridge ports

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free if write is called after disconnect

Sam Edwards <cfsworks@gmail.com>
    ceph: fix num_ops off-by-one when crypto allocation fails

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Add missing save/restore handling of LBR MSRs

Lianjie Wang <karin0.zst@gmail.com>
    hwrng: core - use RCU and work_struct to fix race condition

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation

Ming Qian <ming.qian@oss.nxp.com>
    media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: v4l2-mem2mem: Add a kref to the v4l2_m2m_dev structure

Sebastian Reichel <sebastian.reichel@collabora.com>
    media: hantro: Disable multicore support

Cédric Bellegarde <cedric.bellegarde@adishatz.org>
    ASoC: qcom: q6asm: drop DSP responses for closed data streams

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm: handle the responses after closing

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Fix use of completion ctx after free

Eric Dumazet <edumazet@google.com>
    ip_tunnel: adapt iptunnel_xmit_stats() to NETDEV_PCPU_STAT_DSTATS

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Recover HW before retire hung submit

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: platform: Use acpi_bus_get_primary_device()

Duoming Zhou <duoming@zju.edu.cn>
    net: mscc: ocelot: Fix use-after-free caused by cyclic delayed work

Al Viro <viro@zeniv.linux.org.uk>
    xen: fix UAF in dmabuf_exp_from_pages()

Daniel J. Ogorchock <djogorchock@gmail.com>
    HID: nintendo: avoid bluetooth suspend/resume stalls

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable EEE on bcm63xx

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Disable iocc if dma-coherent property isn't set

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark raw_tp arguments with PTR_MAYBE_NULL

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI/sysfs: Demacrofy pci_dev_resource_resize_attr(n) functions

Pengpeng Hou <pengpeng@iscas.ac.cn>
    genirq/proc: Size interrupt directory names for 10-digit interrupt numbers

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate and share PSP fw_pri_buf copies via psp_copy_fw

Candice Li <candice.li@amd.com>
    drm/amdgpu: Bound GPIO I2C table entry count from VBIOS

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework i2c init and fini

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atombios: drop empty function

Dr. David Alan Gilbert <linux@treblig.org>
    drm/amdgpu: Remove unused amdgpu_i2c functions

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't call ieee80211_handle_reconfig_failure when not needed

Stepan Ionichev <sozdayvek@gmail.com>
    tty: serial: 8250: protect against NULL uart->port.dev in register

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250: invert serial8250_register_8250_port() CIR condition

Herve Codina <herve.codina@bootlin.com>
    driver core: Avoid warning when removing a device while its supplier is unbinding

Sicong Huang <congei42@163.com>
    virt: acrn: Fix irqfd use-after-free during eventfd shutdown

Tao Cui <cuitao@kylinos.cn>
    RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix P2P-Device binding handling

Stanley.Yang <Stanley.Yang@amd.com>
    drm/amdgpu: harden FRU PIA parsing with bounded helpers

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Refactor FRU product information

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu/ras: add ras_suspend callback and use it for cp_ecc_error_irq

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: fix SMI event cross-process information leak

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: quiesce DMA before freeing resources

David Timber <dxdt@dev.snart.me>
    exfat: fix handling of damaged volume in exfat_create_upcase_table()

Daniel Yang <danielyangkang@gmail.com>
    exfat: resolve memory leak from exfat_create_upcase_table()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix addr_filter_ranges lifetime

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: mac80211: ibss: wait for in-flight TX on disconnect

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: zero-initialize stack-allocated cifs_open_info_data

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: pcie: null RX pointers after free

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: validate TX_CMD response layout

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: remove mvm prefix from iwl_mvm_tx_resp*

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix maximum allowed access checks

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    ksmbd: remove redundant DACL check in smb_check_perm_dacl

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix stop/start with no update

Val Packett <val@packett.cool>
    remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: propagate IPI init errors to prevent use-after-free

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: add error return value to xive_smp_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: bus: Introduce acpi_bus_get_primary_device()

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: make the v1 soft limit knob inert

Chris Mason <clm@meta.com>
    svcrdma: Reject Write/Reply chunks with segcount 0

Chris Mason <clm@meta.com>
    nfsd: convert nfsd_net boolean flags to unsigned long flags word

Ye Liu <ye.liu@linux.dev>
    mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()

Shameer Kolothum <skolothumtho@nvidia.com>
    iommu/arm-smmu-v3: Manage teardown with devm

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix recursive locking during device registration

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: refcount requests for token lifetime

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Clear queue->active_job when v3d_fence_create() fails

Richard Cheng <icheng@nvidia.com>
    cxl/mbox: Clamp mailbox output allocation to the payload size

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: rework runtime PM handling in probe

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in plane reset function

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in CRTC reset function

Gregory Price <gourry@gourry.net>
    mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

Gregory Price <gourry@gourry.net>
    mm: name the anonymous MMOP enum as enum mmop

Israel Batista <linux@israelbatista.dev.br>
    mm: change type of state in struct memory_block

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout

Manos Pitsidianakis <manos@pitsidianak.is>
    hwrng: core - fix rng list on registration error

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Make nr_deadline_tasks an atomic_t

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: move common code to cpuset-internal.h

Chen Ridong <chenridong@huawei.com>
    cgroup/cpuset: introduce cpuset-v1.c

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Reject MEM_ALLOC BTF accesses past object bounds

Malaya Kumar Rout <malayarout91@gmail.com>
    time/namespace: Validate nanosecond field in proc_timens_set_offset()

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject writes through untrusted BTF pointers

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi-base: Fix handling of ultra performance key

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Fix LED resource handling

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max

Qing Ming <a0yami@mailbox.org>
    usb: gadget: uac: validate rate list length before storing

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: fix resource leaks on probe failure

Luke D. Jones <luke@ljones.dev>
    platform/x86: asus-wmi: disable USB0 hub on ROG Ally before suspend

Maher Azzouzi <maherazz04@gmail.com>
    esp: do not unref managed frag pages in esp_ssg_unref()

Leon Romanovsky <leon@kernel.org>
    RDMA/rvt: Return NULL after port allocation failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Clean up channels on setup failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix SCMI device destroy lifetimes

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/msm: Only fini scheduler after successful init

Philipp Stanner <phasta@kernel.org>
    drm/sched: Use struct for drm_sched_init() params

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Zero queue and stack outputs on lock failure

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix memory leak in bpf_jit_free

Rafael Passos <rafael@rcpassos.me>
    bpf: remove unused parameter in bpf_jit_binary_pack_finalize

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/bpf: rename powerpc64_jit_data to powerpc_jit_data

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()

Leon Romanovsky <leon@kernel.org>
    RDMA/erdma: complete object teardown when the destroy command fails

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix WARNING in bpf_tracing_link_release

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: core: Validate string descriptors

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: Convert string descriptor format macros to enum

Fan Wu <fanwu01@zju.edu.cn>
    spi: oc-tiny: switch to managed controller allocation

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    clk: mediatek: pllfh: Fix IO remapping leak in register_pllfhs error path

Gary Guo <gary@garyguo.net>
    PCI: Fix UAF when probe runs concurrent to dyn ID removal

Gary Guo <gary@garyguo.net>
    PCI: Fix dyn_id add TOCTOU

Gary Guo <gary@garyguo.net>
    PCI: Make pci_match_one_device() match on ID instead of device

Samiullah Khawaja <skhawaja@google.com>
    PCI: Initialize temporary device in new_id_store()

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published

Martin Wilck <mwilck@suse.com>
    md/raid1: create serial pool adding rdev to array with serialize_policy=1

Muhammad Usama Anjum <usama.anjum@arm.com>
    misc: sgi-gru: remove interrupt-context page-table walks

Peter Xu <peterx@redhat.com>
    mm/treewide: replace pmd_large() with pmd_leaf()

Michael-CY Lee <michael-cy.lee@mediatek.com>
    wifi: mt76: fix non-AQL packet accounting for MLO stations

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unwind state on add_interface failure

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interface()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: allocate vif wcid in the same range as stations

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: cancel reset and rc work on device unregister

Yonghong Song <yonghong.song@linux.dev>
    bpf, x86: Fix trampoline stack size for 128-bit arguments

Will Deacon <will@kernel.org>
    arm64: ptrace: Keep 'orig_x0' in-sync with x0 on syscall entry

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: clean up color-change beacon data on errors

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: check link is beaconing for color change

Jason Huang <jason.huang2@infineon.com>
    wifi: brcmfmac: fix P2P action frame handling without device vif

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: stop PMSR before P2P and NAN teardown

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: do fallible allocations before the console can be registered

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: clear freed pointers on uart_register_driver() failure

Karl Mehltretter <kmehltretter@gmail.com>
    tty: skip cdev_del() when no cdev is registered

Haoxiang Li <haoxiang_li2024@163.com>
    HID: logitech-hidpp: Fix FF device cleanup on init failure

Vicki Pfau <vi@endrift.com>
    HID: steam: Reject short reads

Zheng Qixing <zhengqixing@huawei.com>
    blk-cgroup: fix race between policy activation and blkg destruction

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check import_ubuf() return value

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate inline xattrs during inode block validation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: hwmon: Remove hwmon class device along with its parent

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Hold QP references for AE and CM processing

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: o2hb: quiesce negotiate handlers and timeout work

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: keep heartbeat local node stable

Yufan Chen <ericterminal@gmail.com>
    ocfs2/heartbeat: fix slot mapping rollback leaks on error paths

Jiri Olsa <jolsa@kernel.org>
    bpf: Clear buf on error in __bpf_get_task_stack

Petr Pavlu <petr.pavlu@suse.com>
    module/dups: Fix use-after-free in kmod_dup_req lifetime handling

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Resize MST HDCP per-connector arrays to 32

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails

Filipe Manana <fdmanana@suse.com>
    btrfs: defrag: fix deadlock between defrag and delalloc space reservation

Qu Wenruo <wqu@suse.com>
    btrfs: always wait for ordered extents to avoid OE races

Sun YangKai <sunyangkai@fnnas.com>
    btrfs: check if root is readonly when setting posix acl

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix race of kfree vs kref_get_unless_zero

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix storage null-ptr-deref after replacing prog

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix mmap_lock leak in irq_work path

Chuck Lever <cel@kernel.org>
    NFS: Return a delegation the client fails to record

Kuniyuki Iwashima <kuniyu@google.com>
    amt: Don't support cross-netns setup.

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/samsung_pwm: Switch to raw_spinlock_t type

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: fix max_qid race between configfs and controller allocation

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate orphan slot during inode read

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate DIO orphan slot during inode read

Zizhi Wo <wozizhi@huawei.com>
    null_blk: free zones array on device power-off

Usama Arif <usama.arif@linux.dev>
    blk-iolatency: clear delay state when freeing policy data

Usama Arif <usama.arif@linux.dev>
    blk-iocost: clear delay state when freeing policy data

Yu Kuai <yukuai@fygo.io>
    blk-cgroup: delay freeing policy data after rcu grace period

John Johansen <john.johansen@canonical.com>
    apparmor: fix deadlock in complain-mode change_hat

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: fix slab-out-of-bounds read in ksmbd_alloc_user()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: serialize oplock close with pending break ownership

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: defer publishing granted locks to prevent UAF/double-free race

Gao Xiang <xiang@kernel.org>
    erofs: fix interlaced ztailpacking pclusters

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: safely discard unregistered deferred locks

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: detach blocked lock requests before freeing

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: scope session state changes to bound connections

Ze Tan <tanze@kylinos.cn>
    smb/server: fix session leak in ksmbd_session_register()

ZhangGuoDong <zhangguodong@kylinos.cn>
    pnfs/blocklayout: Fix device leaks on parse failure

Jeuk Kim <jeuk20.kim@gmail.com>
    NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers

Zhansong Gao <zhsgao@hotmail.com>
    NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()

Jeff Layton <jlayton@kernel.org>
    filelock: add some new helper functions

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: don't check the listener's sk_err in vsock_accept()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mtpav: shut down output timer before card teardown

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qlcnic: validate unified ROM sections before loading

Eric Dumazet <edumazet@google.com>
    ip6mr: do not clone dst in ip6mr_cache_report()

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fifo: implement lockless __fifo_dump()

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: arp/nd proxy: fix reading neigh ha

Nikolay Aleksandrov <razor@blackwall.org>
    vxlan: fix reading neigh ha

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    NFSv4.1: zero referring call lists before decoding

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: account classifier filter allocations to memcg

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: access chan->conn safely in get/setsockopt

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: do not leak an hci_conn when a second LE connect is rejected

Anshumali Gaur <agaur@marvell.com>
    octeontx2-vf: fix workqueue and netdev race in probe/remove

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_ife: Only operate on Ethernet frames

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq: add overflow bounds to quantum and initial quantum

Eric Dumazet <edumazet@google.com>
    net_sched: export pfifo_fast prio2band[]

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: change how @inactive is tracked

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: struct sched_data reorg

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip double clone set expressions on element insert

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: clean up device list on probe failure

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during close_lru reaping

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during blocked-lock reaping

Elson Serrao <elson.serrao@oss.qualcomm.com>
    usb: dwc3: clear forceRM when issuing EndTransfer

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Reinitiate stream for all host NoStream behavior

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_midi: initialize work in f_midi_alloc()

Kees Cook <keescook@chromium.org>
    usb: gadget: f_midi: Annotate struct f_midi with __counted_by

Steven Rostedt <rostedt@goodmis.org>
    tracing: Take trace_array reference when opening options file

Baineng Shou <shoubaineng@gmail.com>
    dma-buf: dma-heap: don't publish fd before copy_to_user() succeeds

Usama Arif <usama.arif@linux.dev>
    mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Jinjie Ruan <ruanjinjie@huawei.com>
    powerpc/kexec_file: Prevent kexec range truncation

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix missing lock required to access list of ap_matrix_mdev objects

Vidhu Sarwal <vidhu.linux@gmail.com>
    iio: light: ltrf216a: fix runtime PM reference leak in error path

Shreeya Patel <shreeya.patel@collabora.com>
    iio: light: ltrf216a: Return floating point values

Yosry Ahmed <yosry@kernel.org>
    KVM: nVM: Ensure INVVPID is emulated on the correct physical CPU

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory corruption by not reinjecting CK machine checks

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Refactor jump offset calculation in tail call

Wenjie Qi <qwjhust@gmail.com>
    f2fs: avoid NULL checkpoint thread access in sysfs

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: use new ioprio Macro to get ckpt thread ioprio level

Daeho Jeong <daehojeong@google.com>
    f2fs: fix to migrate all curseg types during free_segment_range

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty flag on folio in error path

Bob Zhou <bobzhou2@amd.com>
    drm/amdgpu: avoid force-completing uninitialized UVD rings

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: force complete the KIQ ring fences on reset

Priya Hosur <Priya.Hosur@amd.com>
    drm/amdkfd: Add TLB flush after MES queue eviction/suspension

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix error path at svm_migrate_copy_to_ram

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram

Marek Czernohous <marek@czernohous.de>
    drm/nouveau: unsubscribe the channel-kill event before the fence context

Ben Skeggs <bskeggs@nvidia.com>
    drm/nouveau: remove chan->drm

Ben Skeggs <bskeggs@nvidia.com>
    drm/nouveau: remove nouveau_chan.device

Danilo Krummrich <dakr@redhat.com>
    drm/gpuvm: rename struct drm_gpuva_manager to struct drm_gpuvm

Jiri Olsa <jolsa@kernel.org>
    bpf: Disable preemption in bpf_get_stackid

Farhan Ali <alifm@linux.ibm.com>
    PCI: Allow per function PCI slots to fix slot reset on s390

Farhan Ali <alifm@linux.ibm.com>
    PCI: Introduce PCI_SLOT_PLACEHOLDER constant for slot_nr placeholder value

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: zero pipe read compound padding

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    ksmbd: fix tree connection use-after-free in smb2_tree_connect()

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid soft lockup when scanning task stacks

Kairui Song <kasong@tencent.com>
    mm/mglru: fix and remove redundant unevictable folio handling

Arvind Yadav <arvind.yadav@intel.com>
    mm/migrate_device: clear stale mapping after freeing swapcache

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in writeback_store()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: set default primary compressor in zram_destroy_comps()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: check truncate permission under inode lock

NeilBrown <neilb@suse.de>
    nfsd: Pass 'cred' instead of 'rqstp' to some functions.

Jeff Layton <jlayton@kernel.org>
    lockd, nfsd: RCU-protect nlmsvc_ops dispatch

Jeff Layton <jlayton@kernel.org>
    nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke

NeilBrown <neilb@suse.de>
    nfsd: split sc_status out of sc_type

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd4_encode_layoutreturn()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clean up nfsd4_encode_stateid()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Add simple u32, u64, and bool encoders

Jeff Layton <jlayton@kernel.org>
    nfsd: fix stale s2s_cp_stateids IDR entry for async COPY

Robbie Ko <robbieko@synology.com>
    nfsd: reject out-of-range nseconds in NFSv3 SETATTR and create ops

Chuck Lever <cel@kernel.org>
    NFSD: Prevent client use-after-free during delegation revoke

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix UAF in check_new_map() on session freed during unlock

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: cap delegated inode count in ceph_parse_deleg_inos()

Max Kellermann <max.kellermann@ionos.com>
    ceph: do not repeat ceph_trim_dentries() if no progress possible

Guanghui Yang <3497809730@qq.com>
    btrfs: drop recovered reloc root refs on recovery failure

Anand Jain <anand.jain@oracle.com>
    btrfs: rename err to ret in btrfs_recover_relocation()

Anand Jain <anand.jain@oracle.com>
    btrfs: rename ret to ret2 in btrfs_recover_relocation()

Anand Jain <anand.jain@oracle.com>
    btrfs: rename ret to err in btrfs_recover_relocation()

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    btrfs: fix extent map leak in NOCOW direct I/O write

Frank Sorenson <sorenson@redhat.com>
    cifs: call pagecache_isize_extended() in cifs_setsize() when extending

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix use-before-check of ReparseDataLength in reparse_buf_ptr()

Bryam Vargas <hexlabsecurity@proton.me>
    smb: client: reject a tree connect response whose byte count is too small

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes

Florian Pradines <florian.pradines@gmail.com>
    HID: mcp2221: fix OOB write in mcp2221_raw_event()

Jan Kara <jack@suse.cz>
    ext2: Fix lost inode updates for IS_SYNC inodes

Daniel Borkmann <borkmann@iogearbox.net>
    bpf: Disable preemption in __bpf_get_stack

Bryam Vargas <hexlabsecurity@proton.me>
    dm array: validate array block headers on read

Ye Bin <yebin10@huawei.com>
    jbd2: use shrink_type type instead of bool type for __jbd2_journal_clean_checkpoint_list()

Zhiling Zou <zhilinz@nebusec.ai>
    ip: orphan prefetched skbs before multicast forwarding

Andrea Mayer <andrea.mayer@uniroma2.it>
    ipv6: rpl: fix NULL dereference of idev in ipv6_rpl_srh_rcv()

Yue Haibing <yuehaibing@huawei.com>
    ipv6: annotate data-races around devconf->rpl_seg_enabled

Luxiao Xu <rakukuip@gmail.com>
    sunrpc: fix use-after-free in __rpc_clnt_handle_event and __rpc_clnt_remove_pipedir

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject connection when transport allocation fails

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Handle ADDR_CHANGE CM event properly

Chuck Lever <cel@kernel.org>
    svcrdma: Reject inline replies that overflow the pull-up buffer

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject Read lists that exceed the page budget

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Use svc_xprt_put to free listener on create failure

Yan Zhen <yanzhen@vivo.com>
    sunrpc: xprtrdma: Use ERR_CAST() to return

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Refactor the creation of listener CMA ID

Tejun Heo <tj@kernel.org>
    sched/core: Make core-sched flips wait for in-flight selections

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    lockd: fix NULL dereference on lockowner allocation failure

Jeff Layton <jlayton@kernel.org>
    lockd: adapt to breakup of struct file_lock

Jeff Layton <jlayton@kernel.org>
    filelock: split common fields into struct file_lock_core

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: charger-manager: register regulators before exposing sysfs

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: charger-manager: Convert to platform remove callback returning void

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: lp8788-charger: fix use-after-free on remove

Andrew Davis <afd@ti.com>
    power: supply: lp8788: Use devm_power_supply_register() helper

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: lp8788-charger: Convert to platform remove callback returning void

Jianing Li <m13940358460@163.com>
    power: supply: max17040: propagate register read errors

Weimin Xiong <xiongwm2026@163.com>
    iommu/msm: Unwind probe state on registration failure

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Add a NULL check for sst_inst[]

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    platform/x86: int1092: Fix potential memory leak in sar_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: intel_sar: Check ACPI_HANDLE() against NULL

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Propagate SMU errors and validate S2D address

Zihan Xi <zihanx@nebusec.ai>
    net: l2tp: do not propagate multicast notification errors

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net: ravb: serialize PTP clock teardown

Hidayath Khan <hidayath@linux.ibm.com>
    net/smc: stop killed, freed and out_of_sync sharing a byte

Simon Horman <horms@kernel.org>
    net/smc: Address spelling errors

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    mfd: sm501: Fix potential memory leaks during remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mfd: sm501: Convert to platform remove callback returning void

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: dvm: pair transport op-mode enter/leave

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7915: set correct background radar capability

Jens Axboe <axboe@kernel.dk>
    io_uring: defer eventfd signaling when queued from a wakeup handler

Wei Fang <wei.fang@nxp.com>
    net: tap: fix wrong transport_header when sending VLAN-tagged frame

Akihiko Odaki <akihiko.odaki@daynix.com>
    tap: Keep hdr_len in tap_get_user()

Leon Romanovsky <leon@kernel.org>
    ntb: Store original DMA address for future release

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_transport: Use ntb_get_dma_dev() for DMA buffers

Koichiro Den <den@valinux.co.jp>
    NTB: core: Add .get_dma_dev() callback to ntb_dev_ops

Eric Dumazet <edumazet@google.com>
    tipc: avoid busy looping in tipc_exit_net()

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Fix responder UAF on IB_QP_MAX_DEST_RD_ATOMIC modify_qp

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Merge request and complete tasks

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Remove redundant scheduling of rxe_completer

Yong Wang <edragain@163.com>
    tcp: clamp route advmss to TCP_MIN_MSS

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Wrap user-invoked calls to fb_set_var() in helper

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: ISO: zero the sockaddr before returning it in getname

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject a permission value exceeding the class permission count

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: Add bounds check for CRAT subtype length

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length

Luxiao Xu <rakukuip@gmail.com>
    bpf: Check sk_state before sk_protocol in bpf_tcp_*_syncookie

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    drm/amd/display: use proper context for logging

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix double free of wq, engine, and group structs

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht3x) Fix unaligned accesses

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_acl/le_sync() callbacks

Danilo Krummrich <dakr@kernel.org>
    Drivers: hv: vmbus: use generic driver_override infrastructure

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

Terry Bowman <terry.bowman@amd.com>
    cxl: Fix CXL_HEADERLOG_SIZE to match RAS Capability size

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    soc: xilinx: Shutdown and free rx mailbox channel

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    soc/xilinx: zynqmp_power: Convert to platform remove callback returning void

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add slave_destroy interface for v3 hw

Yuho Choi <dbgh9129@gmail.com>
    media: atomisp: gc2235: fix UAF and memory leak

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix call trace due to missing release()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: fix unaligned memory access in timestamp adjustment

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: adjust duplicate timestamp options

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: synproxy: drop packets if timestamp adjustment fails

Florian Westphal <fw@strlen.de>
    netfilter: make nftables drops visible in net dropmonitor

David Carlier <devnexen@gmail.com>
    netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag

Weiming Shi <bestswngs@gmail.com>
    btrfs: lzo: reject compressed segment that overflows the compressed input

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: npc: Fix size of entry2cntr_map

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: oss: Serialize readq reset state with q->lock

James Clark <james.clark@linaro.org>
    coresight: ete: Always save state on power down

Ivan Abramov <i.abramov@mt-integration.ru>
    ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg

Candice Li <candice.li@amd.com>
    drm/amdgpu: reject oversized IBs with per-ring packet limits

Hongjie Fang <hongjiefang@asrmicro.com>
    scsi: core: pair EH runtime PM get and put

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    sctp: validate cookie AUTH state before use

Julian Anastasov <ja@ssi.bg>
    ipvs: revalidate ihl to prevent out-of-bounds access

Eric Dumazet <edumazet@google.com>
    l2tp: fix tunnel and session refcount leak on seq_file release

Aleksandr Nogikh <nogikh@google.com>
    firewire: ohci: fix NULL pointer dereference in ar_context_release

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock

Karthikeyan KS <karthiproffesional@gmail.com>
    soc: aspeed: lpc-snoop: Fix usercopy overflow in snoop_file_read

David Lee <david.lee@trailofbits.com>
    btrfs: lzo: reject inline extents without valid headers

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf: Fix netns reference imbalance in conntrack kfuncs

Linfeng Sun  <linfeng.sun.dev@gamil.com>
    vhost_iotlb: bound map allocation in add_range

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix type confusion in notification logic

Eric Dumazet <edumazet@google.com>
    netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: Fix UAF of sba and ieq during ism_dev_exit()

Hongyan Xu <getshell@seu.edu.cn>
    watchdog: at91sam9_wdt: prevent timer rearm during teardown

Dongli Zhang <dongli.zhang@oracle.com>
    net: tap: set skb->dev before parsing virtio net header in tap_get_user_xdp()

Ryan Wilbur <rwilbur633@gmail.com>
    serial: 8250_of: clear stuck empty-FIFO RX-timeout on LPC32xx

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tls: rx: restore msg_iter before TLS 1.3 optimistic retry

Sabrina Dubroca <sd@queasysnail.net>
    selftests: tls: add rekey tests

Sabrina Dubroca <sd@queasysnail.net>
    selftests: tls: add test with a partially invalid iov

Steven Rostedt <rostedt@goodmis.org>
    eventfs: Use children field for rcu head and add memory barriers

Zhiling Zou <zhilinz@nebusec.ai>
    mm/page_table_check: skip special zero mappings

Dongjiang Zhu <zhudongjiang@fnnas.com>
    btrfs: skip global block reserve accounting for rescue mounts

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: make nft_object rhltable per table

Jason Xing <kernelxing@tencent.com>
    xsk: fix buffer leak in xsk_drop_skb() for AF_XDP multi-buffer Tx

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: fix memory leak in udp_tunnel_nic_unregister()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: hold sk properly in iso_conn_ready

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Block VFs from clobbering special CGX PKIND state

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Close speculative mem read possibility

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath11k: cancel SSR work items during PCI shutdown

Di Shen <di.shen@unisoc.com>
    OPP: Fix race between OPP addition and lookup

Lianfa Weng <wenglianfa@huawei.com>
    RDMA/hns: Fix log flood after cmd_mbox failure

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix UAF at handling events with embedded SysEx data

Geliang Tang <tanggeliang@kylinos.cn>
    nvmet-tcp: fix page fragment cache leak in error path

Yunsheng Lin <linyunsheng@huawei.com>
    net: introduce page_frag_cache_drain()

Hannes Reinecke <hare@suse.de>
    nvmet-tcp: allocate socket file

Hannes Reinecke <hare@suse.de>
    nvmet-tcp: make nvmet_tcp_alloc_queue() a void function

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix deadlock in read error recovery path

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix memory leak in ath12k_wifi7_dp_rx_h_verify_tkip_mic()

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix vhost_get_avail_idx for a non empty ring

Michael S. Tsirkin <mst@redhat.com>
    vhost: move smp_rmb() into vhost_get_avail_idx()

Xianting Tian <xianting.tian@linux.alibaba.com>
    vhost: correct misleading printing information

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: validate fast symlink target during inode read

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add extra consistency checks for chain allocator dinodes

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: cttimeout: detach dataplane timeout policy and repurpose refcount

Bernard Metzler <bernard.metzler@linux.dev>
    RDMA/siw: Fix endpoint/socket association handling

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Introduce siw_destroy_cep_sock

Kaitao Cheng <chengkaitao@kylinos.cn>
    bpf: Clear rb node linkage when freeing bpf_rb_root

David Windsor <dwindsor@gmail.com>
    bpf: Reject sleepable BPF_LSM_CGROUP programs at load time

Larysa Zaremba <larysa.zaremba@intel.com>
    ixgbe: do not configure xps for XDP queues

Yun Zhou <yun.zhou@windriver.com>
    ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT

HanQuan <eilaimemedsnaimel@gmail.com>
    ALSA: seq: Fix kernel heap address leak in bounce_error_event()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Drop superfluous filter argument of get_event_dest_client()

Dan Williams <djbw@kernel.org>
    cxl/region: Block region delete during region creation

Joe Damato <joe@dama.to>
    bnxt: fix head underflow on XDP head-grow

Eric Dumazet <edumazet@google.com>
    net: watchdog: fix refcount tracking races

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: avoid stale FIFO cells during resize

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Clean up fifo locking with guard

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: fifo: Use guard() for locking

Kuniyuki Iwashima <kuniyu@google.com>
    sockmap: Fix use-after-free in udp_bpf_recvmsg()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Initialize dpi variable to zero

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid repeated requests to allocate WC pages

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Replace waitqueue and flag with completion

Baoli.Zhang <baoli.zhang@linux.intel.com>
    soundwire: fix bug in sdw_add_element_group_count found by syzkaller

Chris Mason <clm@meta.com>
    xprtrdma: Fix ep kref imbalance on ADDR_CHANGE

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: fix writes_pending and barrier reference leaks on write failures

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending leak on write request failures

John Garry <john.g.garry@oracle.com>
    md/raid10: Handle bio_split() errors

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending and barrier reference leaks on discard failures

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Guard conntrack opts error writes

Puranjay Mohan <puranjay@kernel.org>
    bpf: net: netfilter: drop dead NULL checks

Chen Cheng <chencheng@fnnas.com>
    md/raid5: avoid R5_Overlap races while breaking stripe batches

Eric Dumazet <edumazet@google.com>
    net: udp_tunnel: prevent double queueing in udp_tunnel_nic_device_sync

Eric Dumazet <edumazet@google.com>
    tipc: fix UAF in cleanup_bearer() due to premature dst_cache_destroy()

Xin Long <lucien.xin@gmail.com>
    sctp: add INIT verification after cookie unpacking

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/core) honor vrm_version in pmbus_data2reg_vid()

Xin Long <lucien.xin@gmail.com>
    sctp: fix addr_wq_timer race in sctp_free_addr_wq()

Michael Bommarito <michael.bommarito@gmail.com>
    xen/pvcalls: bound backend response req_id before indexing rsp[]

David Howells <dhowells@redhat.com>
    afs: Fix reinitialisation of the inode, in particular ->lock_work

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    HID: bpf: Fix hid_bpf_get_data() range check

Feng Liu <feliu@nvidia.com>
    net/mlx5e: Fix publication race for priv->channel_stats[]

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: avoid untracked enable work

Yuho Choi <dbgh9129@gmail.com>
    net/liquidio: drop cached VF pci_dev LUT

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/core: Avoid enabling BRS from the SVM reload path

Rosen Penev <rosenp@gmail.com>
    gpio: mvebu: free generic chips on unbind

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()

Tamaki Yanagawa <ty@000ty.net>
    netfilter: nft_lookup: fix catchall element handling with inverted lookups

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling

Deepanshu Kartikey <kartikey406@gmail.com>
    mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs: Remove NTFS classic

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Ian Bridges <icb@fastmail.org>
    ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: validate i_refcount_loc when refcount flag is set

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add suballoc slot check in ocfs2_validate_inode_block()

Julian Sun <sunjunchao2870@gmail.com>
    ocfs2: correct l_next_free_rec in online check

Michael Bommarito <michael.bommarito@gmail.com>
    nvmet-auth: reject short AUTH_RECEIVE buffers

Damien Le Moal <dlemoal@kernel.org>
    nvmet: Introduce nvmet_req_transfer_len()

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix buffer overflow in FEC calculation

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Zhao Li <enderaoelyther@gmail.com>
    wifi: ieee80211: validate MLE common info length

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix buffer over-read in cca_cipher2protkey

Amir Goldstein <amir73il@gmail.com>
    ovl: check access to copy_file_range source with src mounter creds

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Handle TC_ACT_REDIRECT from qdisc filter chains

George Guo <guodongtai@kylinos.cn>
    LoongArch: Fix address space mismatch in kexec command line lookup

Baoquan He <bhe@redhat.com>
    loongarch, kexec: change dependency of object files

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: fix stale skb->prev after async crypto steals a GSO segment

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Prevent user-triggered null deref on QP create

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: mac80211: defer link RX stats percpu free to RCU

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: cfg80211: add link_station_info structure to support MLO statistics

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: mac80211: refactor populating mesh related fields in sinfo

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: convert pmsr_free_wk to wiphy_work to fix deadlock

Cen Zhang <zzzccc427@gmail.com>
    wifi: cfg80211: use wiphy work for socket owner autodisconnect

Mostafa Saleh <smostafa@google.com>
    firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Fix UAF in sock clone early bailouts

Fushuai Wang <wangfushuai@baidu.com>
    bpf: Use rcu_read_lock_dont_migrate in bpf_sk_storage.c

Menglong Dong <menglong8.dong@gmail.com>
    rcu: add rcu_read_lock_dont_migrate()

Hou Tao <houtao1@huawei.com>
    bpf: Disable migration when cloning sock storage

Hou Tao <houtao1@huawei.com>
    bpf: Disable migration when destroying sock storage

David Jeffery <djeffery@redhat.com>
    scsi: core: wake eh reliably when using scsi_schedule_eh

Weiming Shi <bestswngs@gmail.com>
    tipc: serialize udp bearer replicast list updates

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: fix use-after-free on workqueue during remove

Brett Creeley <brett.creeley@amd.com>
    pds_core: Clean up init/uninit flows to be more readable

Brett Creeley <brett.creeley@amd.com>
    pds_core: Don't assign interrupt index/bound_intr to notifyq

Frank Sorenson <sorenson@redhat.com>
    cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths

Frank Sorenson <sorenson@redhat.com>
    cifs: prevent readdir from changing file size due to stale directory metadata

Gregor Herburger <gregor.herburger@linutronix.de>
    drm/vc4: hvs/v3d: Fix null dereference in unbind

Gal Pressman <gal@nvidia.com>
    net/mlx5: Fix MCIA register buffer overflow on 32 dword reads

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Fix context pstate override handling

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on CRIU restore queue type and mqd size

Jani Nikula <jani.nikula@intel.com>
    drm/i915/bios: range check LFP Data Block panel_type2

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gt: Fix NULL deref on sched_engine alloc failure

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mst: limit DP MST ESI service loop

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Release VFCT ACPI table reference

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add wrapper for freeing vbios memory

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Use dbg level for VBIOS check messages

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Shut down BO cache timer before teardown

Guangshuo Li <lgs201920130244@gmail.com>
    media: vivid: fix cleanup bugs in vivid_init()

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Move jump_label_init() before parse_early_param()

Davide Ornaghi <d.ornaghi97@gmail.com>
    ksmbd: fix path resolution in ksmbd_vfs_kern_path_create

Jori Koolstra <jkoolstra@xs4all.nl>
    vfs: make LAST_XXX private to fs/namei.c

Al Viro <viro@zeniv.linux.org.uk>
    ksmbd_vfs_rename(): vfs_path_parent_lookup() accepts ERR_PTR() as name

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state

Weiming Shi <bestswngs@gmail.com>
    Bluetooth: eir: Fix stack OOB write when prepending the Flags AD

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Take a long-lived file reference at submit

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda/cs35l41: Fix firmware load work teardown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent path traversal bypass by restricting caseless retry

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use opener credentials for ADS I/O

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: validate NTLMv2 response before updating session key

Ralph Boehme <slow@samba.org>
    smb/client: fix chown/chgrp with SMB3 POSIX Extensions

Guangshuo Li <lgs201920130244@gmail.com>
    cpufreq: qcom-cpufreq-hw: Fix possible double free

Lizhe <sensor1010@163.com>
    cpufreq: Make cpufreq_driver->exit() return void

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: pcc: Remove empty exit() callback

Johan Hovold <johan@kernel.org>
    USB: iowarrior: fix use-after-free on disconnect race

Bryam Vargas <hexlabsecurity@proton.me>
    nvmet: fix pre-auth out-of-bounds heap read in Discovery Get Log Page

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - protect service table iterations with service_lock

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Add lock protection to lm90_alert

Felix Gu <ustc.gu@gmail.com>
    drm/msm/adreno: Fix a reference leak in a6xx_gpu_init()

Jia Zhu <zhujia.zj@bytedance.com>
    erofs: fix metabuf leak in inode xattr initialization

Junyi Liu <moss80199@gmail.com>
    ksmbd: validate SID in parent security descriptor during ACL inheritance

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb

Sarika Sharma <sarika.sharma@oss.qualcomm.com>
    wifi: mac80211: fix missing RX bitrate update for mesh forwarding path

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: allocate hook ops while under mutex

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: allow initial table replace without emitting audit log message

Yan Zhen <yanzhen@vivo.com>
    netfilter: Use kmemdup_array instead of kmemdup for multiple allocation

Kartik <kkartik@nvidia.com>
    mm/util: Introduce kmemdup_array()

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: move to two-stage removal scheme

Florian Westphal <fw@strlen.de>
    netfilter: bridge: eb_tables: close module init race

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Stop work before releasing hwmon device

Qing Ming <a0yami@mailbox.org>
    cgroup/rstat: validate cpu before css_rstat_cpu() access

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix indir_table and hkey leak on get_rxfh failure

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Drain pending requests at net namespace exit

Heitor Alves de Siqueira <halves@igalia.com>
    Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Ignore Port I/O requests of length '0'

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix amdgpu_hmm_range_get_pages

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring

Konstantin Khorenko <khorenko@virtuozzo.com>
    gcov: use atomic counter updates to fix concurrent access crashes

Mikhail Lobanov <m.lobanov@rosa.ru>
    f2fs: read COW data with the original inode during atomic write

Hongling Zeng <zenghongling@kylinos.cn>
    fbdev: omap2: fix use-after-free in omapfb_mmap

Hongling Zeng <zenghongling@kylinos.cn>
    fbdev: omap2: fix inconsistent lock returns in omapfb_mmap

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: always recover the gpu

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()

Rory Little <rory@candelatech.com>
    wifi: mt76: mt7921: Place upper limit on station AID

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Guard mana_remove against double invocation

Morduan Zang <zhangdandan@uniontech.com>
    net: phonet: do not BUG_ON() in pn_socket_autobind() on failed bind

Qu Wenruo <wqu@suse.com>
    btrfs: only release the dirty pages io tree after successful writes

Lee Jones <lee@kernel.org>
    l2tp: pppol2tp: hold reference to session in pppol2tp_ioctl()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: fix leak if split 6 GHz scanning fails

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure

Stanislav Fomichev <sdf@google.com>
    tools: ynl: extend netdev sample to dump xdp-rx-metadata-features

Stanislav Fomichev <sdf@google.com>
    bpf: make it easier to add new metadata kfunc

Xin Long <lucien.xin@gmail.com>
    sctp: validate embedded INIT chunk and address list lengths in cookie

Salman Alghamdi <me@cipherat.com>
    staging: rtl8723bs: fix buffer over-read in rtw_update_protection

Vivek BalachandharTN <vivek.balachandhar@gmail.com>
    staging: rtl8723bs: clean up redundant & parentheses

Meir Elisha <meir6264@gmail.com>
    Staging: rtl8723bs: Delete dead code from update_current_network()

Meir Elisha <meir6264@gmail.com>
    Staging: rtl8723bs: Remove dead code from _rtw_free_network()

Salman Alghamdi <me@cipherat.com>
    staging: rtl8723bs: rtw_mlme: add bounds checks before ie_length subtraction

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    nvmem: core: fix use-after-free bugs in error paths

Miquel Raynal <miquel.raynal@bootlin.com>
    nvmem: core: Rework layouts to become regular devices

Miquel Raynal <miquel.raynal@bootlin.com>
    nvmem: Move of_nvmem_layout_get_container() in another header

Miquel Raynal <miquel.raynal@bootlin.com>
    of: device: Export of_device_make_bus_id()

HyungJung Joo <jhj140711@gmail.com>
    fs/mbcache: cancel shrink work before destroying the cache

Filipe Manana <fdmanana@suse.com>
    btrfs: fix deadlock between reflink and transaction commit when using flushoncommit

Danilo Krummrich <dakr@kernel.org>
    PCI: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    vdpa: use generic driver_override infrastructure

Danilo Krummrich <dakr@kernel.org>
    bus: fsl-mc: use generic driver_override infrastructure

Zilin Guan <zilin@seu.edu.cn>
    wifi: ath11k: fix memory leaks in beacon template setup

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s: Fix unmap race with PMD migration entries

Zilin Guan <zilin@seu.edu.cn>
    wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()

Duoming Zhou <duoming@zju.edu.cn>
    wifi: mt76: mt7996: fix use-after-free bugs in mt7996_mac_dump_work()

Eric Dumazet <edumazet@google.com>
    net: pull headers in qdisc_pkt_len_segs_init()

Xin Long <lucien.xin@gmail.com>
    sctp: disable BH before calling udp_tunnel_xmit_skb()

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix clone_alias() to use the original device's devid

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free on cdev close

Jianan Huang <huangjianan@xiaomi.com>
    f2fs: avoid reading already updated pages during GC

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix data loss caused by incorrect use of nat_entry flag

Michal Schmidt <mschmidt@redhat.com>
    ice: fix double-free of tx_buf skb

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nat: use kfree_rcu to release ops

Edward Adam Davis <eadavis@qq.com>
    sched/psi: fix race between file release and pressure write

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix inode reference leak in fsnotify_recalc_mask()

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()

Weiming Shi <bestswngs@gmail.com>
    tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR

D. Wythe <alibuda@linux.alibaba.com>
    Revert "net/smc: Introduce TCP ULP support"

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: use list_del_rcu for netlink hooks

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: allow multiple opens of /sys/fs/selinux/policy

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: admv1013: fix NULL pointer dereference on str

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: admv1013: add dev variable

David Lechner <dlechner@baylibre.com>
    iio: frequency: admv1013: Use devm_regulator_get_enable_read_voltage()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Add fwnode_property_match_property_string()

Yicong Yang <yangyicong@hisilicon.com>
    coresight: tmc-etr: Fix race condition between sysfs and perf mode

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix dc_link NULL handling in HPD init

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix use-after-free on registration failure

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: fix controller deregistration

Yang Yingliang <yangyingliang@huawei.com>
    spi: mpc52xx: switch to use modern name

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by FGGC of node block

Osama Abdelkader <osama.abdelkader@gmail.com>
    riscv: kvm: fix vector context allocation leak

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: control built-in cs manually

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: fix reading parity bytes split across blocks (take 3)

Kevin Cheng <chengkev@google.com>
    KVM: nSVM: Raise #UD if unhandled VMMCALL isn't intercepted by L1

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Fix UMR hang in LAG error state unload

Deepanshu Kartikey <kartikey406@gmail.com>
    gfs2: fix memory leaks in gfs2_fill_super error path

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down context entry

Gao Xiang <xiang@kernel.org>
    erofs: fix inline data read failure for ztailpacking pclusters

Jie Zhang <jzhang918@gmail.com>
    net: stmmac: fix oops when split header is enabled

Boris Burkov <boris@bur.io>
    btrfs: fix EEXIST abort due to non-consecutive gaps in chunk allocation

Guillaume Gonnet <ggonnet.linux@gmail.com>
    bpf: Fix tcx/netkit detach permissions when prog fd isn't given

Julian Anastasov <ja@ssi.bg>
    ipvs: do not keep dest_dst if dev is going down

Brian Witte <brianwitte@mailfence.com>
    netfilter: nf_tables: revert commit_mutex usage in reset path

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down PASID entry

Ryan Lin <ryan.lin@intel.com>
    HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients

Even Xu <even.xu@intel.com>
    HID: Intel-ish-hid: Ishtp: Fix sensor reads after ACPI S3 suspend

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix slab-use-after-free in qd_put

Nhat Pham <nphamcs@gmail.com>
    list_lru: allow explicit memcg and NUMA node selection

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mm: list_lru: Update kernel documentation to follow the requirements

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: RX, Fix XDP multi-buf frag counting for striding RQ

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: RX, Fix XDP multi-buf frag counting for legacy RQ

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp-mach-common: Add missing error check for clock acquisition

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    scsi: qla2xxx: Completely fix fcport double free

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix race in DMA ring dequeue

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue

Filipe Manana <fdmanana@suse.com>
    btrfs: reserve enough transaction items for qgroup ioctls

Filipe Manana <fdmanana@suse.com>
    btrfs: don't BUG() on unexpected delayed ref type in run_one_delayed_ref()

Qu Wenruo <wqu@suse.com>
    btrfs: do not ASSERT() when the fs flips RO inside btrfs_repair_io_failure()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Skip vcn poison irq release on VF

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    drm: renesas: rz-du: mipi_dsi: fix kernel panic when rebooting for some panels

Magnus Lindholm <linmag7@gmail.com>
    alpha: fix user-space corruption during memory compaction

Arnd Bergmann <arnd@arndb.de>
    arch: turn off -Werror for architectures with known warnings

Mario Peter <mario.peter@leica-geosystems.com>
    usb: chipidea: udc: fix DMA and SG cleanup in _ep_nuke()

Stefano Stabellini <stefano.stabellini@amd.com>
    9p/xen: protect xen_9pfs_front_free against concurrent calls

Eugenio Pérez <eperezma@redhat.com>
    vhost: move vdpa group bound check to vhost_vdpa

Jiayuan Chen <jiayuan.chen@shopee.com>
    kcm: fix zero-frag skb in frag_list on partial sendmsg error

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    team: avoid NETDEV_CHANGEMTU event when unregistering slave

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: validate sequence number of TX release report

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix "scheduling while atomic" in IPsec MAC address query

Jakub Kicinski <kuba@kernel.org>
    netconsole: avoid OOB reads, msg is not nul-terminated

Nicholas Carlini <nicholas@carlini.com>
    ksmbd: fix signededness bug in smb_direct_prepare_negotiation()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix 22000 series SMEM parsing

Christoph Hellwig <hch@lst.de>
    xfs: remove xfs_attr_leaf_hasname

Szymon Wilczek <swilczek.lx@gmail.com>
    ntfs3: fix circular locking dependency in run_unpack_ex

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Accumulated refactoring changes

Filipe Manana <fdmanana@suse.com>
    btrfs: fix zero size inode with non-zero size after log replay

David Sterba <dsterba@suse.com>
    btrfs: tree-log: don't use token set/get accessors in fill_inode_item()

Jeff Layton <jlayton@kernel.org>
    btrfs: convert to new timestamp accessors

Joel Fernandes <joelagnelf@nvidia.com>
    srcu: Use irq_work to start GP in tiny SRCU

Thomas Gleixner <tglx@linutronix.de>
    irqwork: Move data struct to a types header

Suren Baghdasaryan <surenb@google.com>
    types: move struct rcuwait into types.h

Keenan Dong <keenanat2000@gmail.com>
    xfrm: account XFRMA_IF_ID in aevent size calculation

Eric Dumazet <edumazet@google.com>
    ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()

Justin Iurman <justin.iurman@gmail.com>
    net: ioam6: fix OOB and missing lock

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64: rename misleadingly named '__copy_user_nocache()' function

Wang Tao <wangtao554@huawei.com>
    Bluetooth: MGMT: Fix list corruption and UAF in command complete handlers

Lee Jones <lee@kernel.org>
    HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure

Lee Jones <lee@kernel.org>
    HID: core: Mitigate potential OOB by removing bogus memset()

Li Chen <chenl311@chinatelecom.cn>
    HID: rate-limit hid_warn to prevent log flooding

Tatsuya S <tatsuya.s2862@gmail.com>
    HID: core: Add reserved item tag for main items

Sabrina Dubroca <sd@queasysnail.net>
    mpls: add seqcount to protect the platform_label{,s} pair

Guoyu Su <yss2813483011xxl@gmail.com>
    net: use skb_header_pointer() for TCPv4 GSO frag_off check

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect pruning due to atomic fetch precision tracking

Oleh Konko <security@1seal.org>
    Bluetooth: hci_event: move wake reason storage into validated event handlers

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dsi: Don't do DSC horizontal timing adjustments in command mode

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_eem: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_subset: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Fix net_device lifecycle with device_move

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()

Douya Le <ldy3087146292@gmail.com>
    crypto: af_alg - limit RX SG extraction by receive buffer budget

Qi Tang <tpluszz77@gmail.com>
    xfrm: hold dev ref until after transport_finish NF_HOOK

Jianbo Liu <jianbol@nvidia.com>
    xfrm: hold device only for the asynchronous decryption

Eric Dumazet <edumazet@google.com>
    net: adopt skb_network_offset() and similar helpers

David Carlier <devnexen@gmail.com>
    net: lan966x: fix page pool leak in error paths

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rxrpc: proc: size address buffers for %pISpc output

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: don't call cdev_init while cdev in use

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock

Ge Yang <yangge1116@126.com>
    KVM: SEV: Use long-term pin when registering encrypted memory regions

Janosch Frank <frankja@linux.ibm.com>
    s390/mm: Add missing secure storage access fixups for donated memory

Vladimir Yakovlev <vovchkir@gmail.com>
    spi: spi-dw-dma: fix print error log when wait finish transaction

Chaitanya Kulkarni <kch@nvidia.com>
    nvmet: move async event work off nvmet-wq

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv4: nexthop: allocate skb dynamically in rtm_get_nexthop()

Alison Schofield <alison.schofield@intel.com>
    cxl/port: Fix use after free of parent_port in cxl_detach_ep()

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix double free of WoL irq

Kohei Enju <kohei@enjuk.jp>
    iavf: fix out-of-bounds writes in iavf_get_ethtool_stats()

Danilo Krummrich <dakr@kernel.org>
    spi: use generic driver_override infrastructure

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdgpu: prevent immediate PASID reuse case

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/amdgpu: Remove usage of the deprecated ida_simple_xx() API

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION

Kent Overstreet <kent.overstreet@linux.dev>
    fs: super_set_uuid()

Jiayuan Chen <jiayuan.chen@shopee.com>
    serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN

Fuad Tabba <tabba@google.com>
    bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing

Hou Tao <houtao1@huawei.com>
    bpf, arm64: Enable the inline of bpf_kptr_xchg()

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry

Davidlohr Bueso <dave@stgolabs.net>
    cxl/mbox: validate payload size before accessing contents in cxl_payload_from_user_allowed()

Weiming Shi <bestswngs@gmail.com>
    net: add xmit recursion limit to tunnel xmit functions

Eric Dumazet <edumazet@google.com>
    tcp: secure_seq: add back ports to TS offset

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add chann_lock to protect ksmbd_chann_list xarray

Qu Wenruo <wqu@suse.com>
    btrfs: reject new transactions if the fs is fully read-only

Perry Yuan <perry.yuan@amd.com>
    drm/amd/pm: Disable MMIO access during SMU Mode 1 reset

Edward Adam Davis <eadavis@qq.com>
    ALSA: usb-audio: Prevent excessive number of frames

Breno Leitao <leitao@debian.org>
    spi: tegra210-quad: Protect curr_xfer check in IRQ handler

Zilin Guan <zilin@seu.edu.cn>
    of: unittest: Fix memory leak in unittest_data_add()

Cong Nguyen <congnt264@gmail.com>
    staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark bpf_refcount field as unique

Haotian Zhang <vulab@iscas.ac.cn>
    PCI: endpoint: Add missing NULL check for alloc_workqueue()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: Drop the MHI auto_queue feature for IPCR DL channels

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Use devm_kmemdup() in rtw_set_supported_band()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: debugfs: support multiple adapters debugging

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't WARN for connections on invalid channels

FengWei Shih <dannyshih@synology.com>
    md: suspend array while updating raid_disks via sysfs

Yu Kuai <yukuai3@huawei.com>
    md: add new helpers to suspend/resume and lock/unlock array

Yu Kuai <yukuai3@huawei.com>
    md: add new helpers to suspend/resume array

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits

Al Viro <viro@zeniv.linux.org.uk>
    functionfs: fix the open/removal races

Al Viro <viro@zeniv.linux.org.uk>
    functionfs, gadgetfs: use simple_recursive_removal()

Paul Cercueil <paul@crapouillou.net>
    usb: gadget: functionfs: Factorize wait-for-endpoint code

Paul Cercueil <paul@crapouillou.net>
    usb: gadget: Support already-mapped DMA SGs

Minseong Kim <ii4gsp@gmail.com>
    Input: lkkbd - disable pending work before freeing device

Al Viro <viro@zeniv.linux.org.uk>
    shmem: fix recovery on rename failures

Duoming Zhou <duoming@zju.edu.cn>
    Input: alps - fix use-after-free bugs caused by dev3_register_work

Duoming Zhou <duoming@zju.edu.cn>
    usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Clear cmds after chip reset

Sarika Sharma <sarika.sharma@oss.qualcomm.com>
    wifi: ath12k: Fix MSDU buffer types handling in RX error path

Arnaud Lecomte <contact@arnaud-lcm.com>
    bpf: Fix stackmap overflow check in __bpf_get_stackid()

Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>
    coresight: ETR: Fix ETR buffer use-after-free issue

Yun Zhou <yun.zhou@windriver.com>
    md: fix rcu protection in md_wakeup_thread

Yu Kuai <yukuai3@huawei.com>
    md: fix stopping sync thread

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Prevent recursive memory reclaim

Duoming Zhou <duoming@zju.edu.cn>
    scsi: imm: Fix use-after-free bug caused by unfinished delayed work

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    tty: serial: ip22zilog: Use platform device for probing

Thomas Gleixner <tglx@linutronix.de>
    serial: ip22zilog: Use port lock wrappers

Nitin Rawat <nitin.rawat@oss.qualcomm.com>
    scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: qcom : Refactor phy_power_on/off calls

Samuel Zhang <guoqing.zhang@amd.com>
    drm/amdgpu: fix gpu page fault after hibernation on PF passthrough

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Restore partition mode after reset

Akiva Goldberger <agoldberger@nvidia.com>
    mlx5: Fix default values in create CQ

Christian König <christian.koenig@amd.com>
    drm/amdgpu: remove two invalid BUG_ON()s

Eric Dumazet <edumazet@google.com>
    tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()

Richard Leitner <richard.leitner@linux.dev>
    media: nxp: imx8-isi: Fix streaming cleanup on release

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not share the name pointer between components

Xiao Ni <xni@redhat.com>
    md/raid10: wait barrier before returning discard request with REQ_NOWAIT

Christian König <christian.koenig@amd.com>
    drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Show vram vendor only if available

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete

Harini T <harini.t@amd.com>
    mailbox: zynqmp-ipi: Fix out-of-bounds access in mailbox cleanup loop

Ben Levinsky <ben.levinsky@amd.com>
    mailbox: zynqmp: Move buffered IPI setup to of_match selected routine

Ben Levinsky <ben.levinsky@amd.com>
    mailbox: zynqmp: Move of_match structure closer to usage

Randy Dunlap <rdunlap@infradead.org>
    mailbox: zynqmp-ipi: fix an Excess struct member kernel-doc warning

Eric Dumazet <edumazet@google.com>
    net: use dst_dev_rcu() in sk_setup_caps()

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_output()

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - request reserved interrupt for virtual function

Eric Dumazet <edumazet@google.com>
    tcp_metrics: use dst_dev_net_rcu()

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    RISC-V: KVM: Write hgatp register with valid mode bits

I Viswanath <viswanathiyyappan@gmail.com>
    ptp: Add a upper bound on max_vclocks

Xabier Marquiegui <reibax@gmail.com>
    ptp: Replace timestamp event queue with linked list

Jiri Olsa <olsajiri@gmail.com>
    bpf: Check the helper function is valid in get_helper_proto

Eduard Zingerman <eddyz87@gmail.com>
    bpf: add a get_helper_proto() utility function

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: improve error message for unsupported helper

Niklas Schnelle <schnelle@linux.ibm.com>
    iommu/s390: Make attach succeed when the device was surprise removed

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix Rx page leak on multi-buffer frames

Mikulas Patocka <mpatocka@redhat.com>
    dm-stripe: fix a possible integer overflow

John Garry <john.g.garry@oracle.com>
    dm-stripe: limit chunk_sectors to the stripe size

Christoph Hellwig <hch@lst.de>
    dm: stop using blk_limits_io_{min,opt}

Eric Biggers <ebiggers@kernel.org>
    dm-verity: provide dma_alignment limit in io_hints

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done verify data_offset, data_length and remaining_data_length

Alex Markuze <amarkuze@redhat.com>
    ceph: fix race condition validating r_parent before applying state

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix list corruption after hardware restart

Duoming Zhou <duoming@zju.edu.cn>
    ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix NPD when refreshing an FDB entry with a nexthop object

Ido Schimmel <idosch@nvidia.com>
    vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects

Ye Weihua <yeweihua4@huawei.com>
    trace/fgraph: Fix the warning caused by missing unregister notifier

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    bnxt_en: Fix memory corruption when FW resources change during ifdown

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aegis - Add missing error checks

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - improve assembly function prototypes

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - optimize length block preparation using SSE4.1

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - eliminate some indirect calls

Jinjiang Tu <tujinjiang@huawei.com>
    mm/smaps: fix race between smaps_hugetlb_range and migration

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix sleeping-in-atomic in ath11k_mac_op_set_bitrate_mask()

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath11k: mac: fix struct ieee80211_sband_iftype_data handling

Siyang Liu <Security@tencent.com>
    drm/amd/display: fix a Null pointer dereference vulnerability

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: switch DC over to the new DRM logging macros

William Liu <will@willsroot.io>
    net/sched: Fix backlog accounting in qdisc_dequeue_internal

Al Viro <viro@zeniv.linux.org.uk>
    habanalabs: fix UAF in export_dmabuf()

Umio Yasuno <coelacanth_dream@protonmail.com>
    drm/amd/pm: fix null pointer access

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: return ERR_PTR from opmode start()

Gabriele Monaco <gmonaco@redhat.com>
    rv: Use strings in da monitors tracepoints

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: Pass ab pointer directly to ath12k_dp_tx_get_encap_type()

Heiko Stuebner <heiko@sntech.de>
    drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix double destruction of rsv_qp

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix GCC_GCC_PCIE_HOT_RST definition for WCN7850

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix in_atomic() handling in do_secure_storage_access()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: eir: Fix possible crashes on eir_create_adv_data

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: fix invalid access to memory

Yonghong Song <yonghong.song@linux.dev>
    bpf: Do not include stack ptr register in precision backtracking bookkeeping

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: save the SR_SUM status over switches

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: holding cscfg_csdev_lock while removing cscfg from csdev

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: don't warn when if there is a FW error

Christian Bruel <christian.bruel@foss.st.com>
    PCI: endpoint: pci-epf-test: Fix double free that causes kernel to oops

Michael S. Tsirkin <mst@redhat.com>
    virtio: break and reset virtio devices on device_shutdown()

Daniel Wagner <wagi@kernel.org>
    virtio: hookup irq_get_affinity callback

Daniel Wagner <wagi@kernel.org>
    driver core: bus: add irq_get_affinity callback to bus_type

Ricardo B. Marliere <ricardo@marliere.net>
    virtio: make virtio_bus const

Eduard Zingerman <eddyz87@gmail.com>
    bpf: copy_verifier_state() should copy 'loop_entry' field

Roger Quadros <rogerq@kernel.org>
    dmaengine: ti: k3-udma-glue: Drop skip_fdq argument from k3_udma_glue_reset_rx_chn

Philippe Simons <simons.philippe@gmail.com>
    clk: sunxi-ng: h616: Reparent GPU clock during frequency changes

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h616: Reparent CPU clock during frequency changes

Alexander Gordeev <agordeev@linux.ibm.com>
    kasan: avoid sleepable page allocation from atomic context

Benjamin Berg <benjamin.berg@intel.com>
    um: work around sched_yield not yielding in time-travel mode

Johannes Berg <johannes.berg@intel.com>
    um: fix time-travel syscall scheduling hack

Brendan Tam <Brendan.Tam@amd.com>
    drm/amd/display: prevent hang on link training fail

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Debug ability improvements

Hannes Reinecke <hare@suse.de>
    scsi: mpi3mr: Split off bus_reset function from host_reset

Edward Cree <ecree.xilinx@gmail.com>
    sfc: fix NULL dereferences in ef100_process_design_param()

Edward Cree <ecree.xilinx@gmail.com>
    sfc: rip out MDIO support

Alex Austin <alex.austin@amd.com>
    sfc: Implement ndo_hwtstamp_(get|set)

Boris Burkov <boris@bur.io>
    btrfs: harden block_group::bg_list against list_del() races

Filipe Manana <fdmanana@suse.com>
    btrfs: stop reserving excessive space for block group item insertions

Filipe Manana <fdmanana@suse.com>
    btrfs: stop reserving excessive space for block group item updates

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless loop from btrfs_update_block_group()

Filipe Manana <fdmanana@suse.com>
    btrfs: stop doing excessive space reservation for csum deletion

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless initialization at btrfs_delayed_refs_rsv_release()

Filipe Manana <fdmanana@suse.com>
    btrfs: reserve space for delayed refs on a per ref basis

Filipe Manana <fdmanana@suse.com>
    btrfs: allow to run delayed refs by bytes to be released instead of count

Yonghong Song <yonghong.song@linux.dev>
    bpf: Fix kmemleak warning for percpu hashmap

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Keep write operations atomic

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Separete common code for file_read/write iter/splice

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use function file_inode to get inode from file

Ming Lei <ming.lei@redhat.com>
    ublk: fix handling recovery & reissue in ublk_abort_queue()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix UAF in decryption with multichannel

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: allocate crypto only for primary server

Frederic Weisbecker <frederic@kernel.org>
    perf: Fix hang while freeing sigtrap event

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Avoid memory leak while enabling statistics

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: Avoid explicit type cast in monitor status parse handler

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: fix incorrect TID updation in DP monitor status path

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath12k: fix struct hal_rx_phyrx_rssi_legacy_info

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: refactor DP Rxdma ring structure

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: avoid explicit HW conversion argument in Rxdma replenish

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: avoid explicit RBM id argument in Rxdma replenish

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: avoid explicit mac id argument in Rxdma replenish

Wu Yunchuan <yunchuan@nfschina.com>
    wifi: ath12k: Remove unnecessary (void*) conversions

Atish Patra <atishp@rivosinc.com>
    RISC-V: KVM: Teardown riscv specific bits after kvm_exit

Mayuresh Chitale <mchitale@ventanamicro.com>
    RISC-V: KVM: Add kvm_vcpu_config

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: update channel list in reg notifier instead reg worker

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath11k: fix misspelling of "dma" in num_rxmda_per_pdev

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: add support to select 6 GHz regulatory type

Chao Yu <chao@kernel.org>
    f2fs: fix potential deadloop in prepare_compress_overwrite()

Chao Yu <chao@kernel.org>
    f2fs: convert f2fs_handle_page_eio() to use folio

Boris Burkov <boris@bur.io>
    btrfs: fix block group refcount race in btrfs_create_pending_block_groups()

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: avoid journaling sb update on error if journal is destroying

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: define ext4_journal_destroy wrapper

Murad Masimov <m.masimov@mt-integration.ru>
    ax25: Remove broken autobind

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Mask the bd_cnt field in the TX BD properly

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Modify TX ring indexing logic.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add completion ring pointer in TX and RX ring structures

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Put the TX producer information in the TX BD opaque field

Christian Schoenebeck <linux_oss@crudebyte.com>
    fs/9p: fix NULL pointer dereference on mkdir

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: convert mkdir to use get_new_inode

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: unshare packets when reassembling

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: fix truesize for mb-xdp-pass case

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: fix potential memory corruption in nvme_tcp_recv_pdu()

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix the recovery flow of the UMR QP

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix a WARN during dereg_mr for DM type

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix the page details for the srq created by kernel consumers

Hou Tao <houtao1@huawei.com>
    bpf: Cancel the running bpf_timer through kworker for PREEMPT_RT

Qu Wenruo <wqu@suse.com>
    btrfs: do proper folio cleanup when cow_file_range() failed

Qu Wenruo <wqu@suse.com>
    btrfs: do proper folio cleanup when run_delalloc_nocow() failed

Kory Maincent <kory.maincent@bootlin.com>
    net: ravb: Fix missing rtnl lock in suspend/resume path

Jakub Kicinski <kuba@kernel.org>
    net: ipv6: fix dst ref loops in rpl, seg6 and ioam6 lwtunnels

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fix race between cancel_hw_scan and hw_scan completion

Guixin Liu <kanie@linux.alibaba.com>
    scsi: mpi3mr: Fix possible crash when setting up bsg fails

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not force clear folio if buffer is referenced

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix implicit ODP use after free

Ryan Roberts <ryan.roberts@arm.com>
    mm: clear uffd-wp PTE/PMD state on mremap()

Hao Lan <lanhao@huawei.com>
    net: hns3: fixed hclge_fetch_pf_reg accesses bar space out of bounds issue

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    rds: sysctl: rds_tcp_{rcv,snd}buf: avoid using current->nsproxy

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Prevent changing BAR size/flags in pci_epc_set_bar()

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: IOMMU incorrectly marks MMIO range in DDW

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/iommu: Move pSeries specific functions to pseries/iommu.c

Stefano Brivio <sbrivio@redhat.com>
    udp: Deal with race between UDP socket address change and rehash

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Remove direct link to net_device

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    PCI: imx6: Fix suspend/resume support on i.MX6QDL

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()

Jann Horn <jannh@google.com>
    udmabuf: fix memory leak on last export_udmabuf() error path

Huan Yang <link@vivo.com>
    udmabuf: change folios array from kmalloc to kvmalloc

Hou Tao <houtao1@huawei.com>
    virtiofs: use pages instead of pointer for kernel direct IO

Lei Huang <lei.huang@linux.intel.com>
    fuse: Fix missing FOLL_PIN for direct-io

Zicheng Qu <quzicheng@huawei.com>
    drm/amd/display: Fix null check for pipe_ctx->plane_state in dcn20_program_pipe

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: check for overflows in io_pin_pages

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix out-of-bounds access of directory entries

Jeff Layton <jlayton@kernel.org>
    exfat: convert to new timestamp accessors

David Howells <dhowells@redhat.com>
    afs: Fix lock recursion

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Implement bounds check for stream encoder creation in DCN401

Eddie James <eajames@linux.ibm.com>
    net/ncsi: Disable the ncsi work before freeing the associated structure

James Chapman <jchapman@katalix.com>
    l2tp: prevent possible tunnel refcount underflow

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before used

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before multiple uses

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for head_pipe in dcn32_acquire_idle_pipe_for_head_pipe_in_layer

Yonghong Song <yonghong.song@linux.dev>
    bpf: Fix a sdiv overflow issue

Peng Fan <peng.fan@nxp.com>
    mm, slub: avoid zeroing kmalloc redzone

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    mm/slub: avoid zeroing outside-object freepointer for single free

Andrey Konovalov <andreyknvl@gmail.com>
    slub, kasan: improve interaction of KASAN and slub_debug poisoning

Leon Hwang <leon.hwang@linux.dev>
    bpf: Prevent tailcall infinite loop caused by freplace

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Avoid overflow from uint32_t to uint8_t

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Change lpfc_vport fc_flag member into a bitmask

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Protect vport fc_nodes list with an explicit spin lock

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Change nlp state statistic counters into atomic_t

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Remove shost_lock protection for fc_host_port shost APIs

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix failure to delete vports when discovery is in progress

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range

Lenko Donchev <lenko.donchev@gmail.com>
    drm/amd/display: Use kcalloc() instead of kzalloc()

Eric Dumazet <edumazet@google.com>
    pktgen: use cpus_read_lock() in pg_net_init()

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix TX fifo corruption

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-test: Make use of cached 'epc_features' in pci_epf_test_core_init()

Gavin Shan <gshan@redhat.com>
    mm/huge_memory: avoid PMD-size page cache if needed

Matthew Wilcox <willy@infradead.org>
    mm: simplify thp_vma_allowable_order

Zach O'Keefe <zokeefe@google.com>
    mm/thp: fix "mm: thp: kill __transhuge_page_enabled()"

Shailend Chand <shailend@google.com>
    gve: Account for stopped queues when reading NIC stats

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe copies of protected- and secure-keys

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: harmonize pkey s390 debug feature calls

Milena Olech <milena.olech@intel.com>
    ice: Fix improper extts handling

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: fix double free err_addr pointer warnings

Jacob Keller <jacob.e.keller@intel.com>
    ice: Don't process extts if PTP is disabled

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_ro() into account with bpf_prog_lock_ro()

Christophe Leroy <christophe.leroy@csgroup.eu>
    bpf: Take return from set_memory_rox() into account with bpf_jit_binary_lock_ro()

Josh Don <joshdon@google.com>
    sched: fix warning in sched_setaffinity

Wander Lairson Costa <wander@redhat.com>
    sched/deadline: Fix task_struct reference leak

Shashank Sharma <shashank.sharma@amd.com>
    drm/amdgpu: change vm->task_info handling

Petr Machata <petrm@nvidia.com>
    net: nexthop: Increase weight to u16

Petr Machata <petrm@nvidia.com>
    net: nexthop: Have all NH notifiers carry NH ID

Paloma Arellano <quic_parellan@quicinc.com>
    drm/msm/dpu: Add mutex lock in control vblank irq

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: shift IRQ indices by 1

Johan Hovold <johan@kernel.org>
    tty: add break_wait kernel-doc

Christian Brauner <brauner@kernel.org>
    namespace: handle mount locking for automounts correctly

Christian Brauner <brauner@kernel.org>
    fcntl: refuse F_SET_RW_HINT on an immutable inode

Christian Brauner <brauner@kernel.org>
    namespace: check the target before walking it in do_mount_setattr()

Christian Brauner <brauner@kernel.org>
    namespace: don't copy an unmounted mount tree

Christian Brauner <brauner@kernel.org>
    namespace: unhash a dentry before detaching the mounts on it

Wentao Liang <vulab@iscas.ac.cn>
    drm/vc4: Fix firmware reference leak in vc4_drm_bind()

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Add debug log for MCQ command timeout

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()

ChanWoo Lee <cw9316.lee@samsung.com>
    scsi: ufs: mcq: Remove unused parameters

Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
    scsi: ch: Do not keep references to data transfer element devices

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ

Shao-Fu Chen <shf.chen@mediatek.com>
    optee: register TEE devices only once fully initialized

Artem Dinaburg <artem@trailofbits.com>
    wifi: ath12k: copy M3 firmware when reusing the buffer

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix reusing m3 memory

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: Ensure DAI widget is valid during params

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: hdac_hda: Fix hlink refcount leak on component registration failure

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Don't add invalid kcontrols to LED layer

Li RongQing <lirongqing@baidu.com>
    ACPI: processor_idle: Mark LPI enter functions as __cpuidle

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Pass netdev to mlx5e_destroy_netdev instead of priv

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: Don't store mlx5e_priv in mlx5e_dev devlink priv

Johan Hovold <johan@kernel.org>
    most: core: fix leak on early registration failure

Navaneeth K <knavaneeth786@gmail.com>
    most: core: fix resource leak in most_register_interface error paths

Christian Brauner <brauner@kernel.org>
    namespace: check the mounts before reading their parents in pivot_root()

Christian Brauner <brauner@kernel.org>
    namespace: don't inherit MNT_UMOUNT in clone_mnt()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: ISO: Serialize concurrent connect calls

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate pitch coming from userspace

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Bluetooth: RFCOMM: connect the session socket without rfcomm_mutex

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix command skb lifetime during scan setup

Weiming Shi <bestswngs@gmail.com>
    net: team: stop reusing skb after queue override

Weiming Shi <bestswngs@gmail.com>
    net: team: fix NULL pointer dereference in team_xmit during mode change

Marc Harvey <marcharvey@google.com>
    net: team: Rename port_disabled team mode op to port_tx_disabled

Marc Harvey <marcharvey@google.com>
    net: team: Remove unused team_mode_op, port_enabled

Felix Fietkau <nbd@nbd.name>
    netfilter: nf_tables: fix bidirectional offload regression

Jann Horn <jannh@google.com>
    apparmor: fix cred UAF caused by begin_current_label_crit_section()

Takashi Iwai <tiwai@suse.de>
    ALSA: mixer: oss: Add card disconnect checkpoints

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: oss: Fix data race at accessing runtime.oss.trigger

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcm: oss: Fix setup list UAF on proc write error

Hannes Reinecke <hare@kernel.org>
    nvme-tcp: sanitize request list handling

NeilBrown <neilb@suse.de>
    llist: add interface to check if a node is on a list.

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Tristan Madani <tristan@talencesecurity.com>
    ice: fix metadata_dst refcount handling on representor teardown

Daehyeon Ko <4ncienth@gmail.com>
    ip6_gre: remove obsolete ERSPAN PMTU update

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Set the trace clock before registering the histogram trigger

Vicki Pfau <vi@endrift.com>
    HID: steam: Clean up locking

Vicki Pfau <vi@endrift.com>
    HID: steam: Refactor registration

Vicki Pfau <vi@endrift.com>
    HID: steam: Rearrange teardown sequence

Vicki Pfau <vi@endrift.com>
    HID: steam: Fully unregister controller when hidraw is opened

Vicki Pfau <vi@endrift.com>
    HID: hid-steam: Make client_opened a counter

Adrian Betschart <adrian.betschart@cinemaone.ch>
    drm/amd/display: Don't replace a sink mode that shares the native totals

Oliver Hartkopp <socketcan@hartkopp.net>
    can: fix unique skb identifier regression under RPS

Ezrak1e <ezrakiez@gmail.com>
    dlm: validate length in dlm_search_rsb_tree

Cristian Papa <pcristian292@gmail.com>
    wifi: mt76: mt7603: initialize global station WCID

Adrian Bente <adibente@gmail.com>
    netfilter: flowtable: fix offloaded ct timeout never being extended

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix erronous removal of offload bit

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: validate transport header presence in set_ipv6_addr

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_flower: Fix port range register leak in tmplt_create()

Li RongQing <lirongqing@baidu.com>
    net/mlx5e: Order ICOSQ cc update after CQ doorbell

Tianyi Gao <tianyi@cloudflare.com>
    veth: fix peer NETDEV_XDP_ACT_NDO_XMIT after GRO is toggled while down

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: reject change with no routing attribute

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of skb->len when computing thoff

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: allow sleepy powerdown GPIOs

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt792x: pick the SAR table layout from the table itself

Junjie Cao <junjie.cao@intel.com>
    wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit

Filipe Manana <fdmanana@suse.com>
    btrfs: fix xattr replace when multiple xattrs are packed in the same item

Sang-Hoon Choi <csh0052@gmail.com>
    nvmet: use the local P2P device on metadata allocation failure

Sang-Hoon Choi <csh0052@gmail.com>
    cxgb4/ch_ktls: disable softirqs around tid_list erases

Omar Ramadan <omar@blockcast.net>
    amt: send the relay's General Query directly from the receive path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: em_text: reject unterminated algo before autoload

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Free the BO cache size list on teardown

Myeonghun Pak <mhun512@gmail.com>
    drm/aspeed: Balance the display clock enable on teardown

Sang-Hoon Choi <csh0052@gmail.com>
    gpio: exar: initialize the ID before registering its cleanup

Oleg Keri <okerixx@gmail.com>
    drm/dp: don't mark the AUX backlight enabled when enabling failed

Christian Brauner <brauner@kernel.org>
    namespace: refuse an automount below a mount that is in no namespace

Christian Brauner <brauner@kernel.org>
    namei: don't reveal overmounted entries in refwalk

Christian Brauner <brauner@kernel.org>
    dcache: don't put a mountpoint on a dentry that's being removed

Christian Brauner <brauner@kernel.org>
    namespace: check a submount for references right before unmounting it

Christian Brauner <brauner@kernel.org>
    fs: refuse fspick() on internal superblocks

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amdgpu: copy debugfs register data outside the GRBM/SRBM locks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make Mac FB workaround generic

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: serialize vblank counter reads against GPU reset

Haojie Li <lihaojie@kylinos.cn>
    drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info

Saleel Kudchadker <Saleel.Kudchadker@amd.com>
    drm/amdkfd: align SDMA doorbell base for shader doorbell writes

Fan Wu <fanwu01@zju.edu.cn>
    drm/vc4: drain the hangcheck timer and works on V3D unbind

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gt: Unmask interrupts only when ACTIVE is true

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gem: Prevent overstepping exec array boundary

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: don't keep a connector without a CRTC as connector_state

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN

Palla Raghunath <raghunathpalla.0209@gmail.com>
    Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown

Maxim Skokov <skokovmaksimevg@gmail.com>
    Bluetooth: RFCOMM: free the skb when the DLC has no owner

Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
    Bluetooth: MGMT: Fix status of pending commands flushed on power off

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sock: Serialize dead-device detachment

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: qedi: Initialize callback state before registration

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: light: Drop ROHM BU27034

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: propagate subdomain add errors

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: fix clock leak on domain probe failure

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: don't ignore clock lookup errors on attach

Ming Qian <ming.qian@oss.nxp.com>
    pmdomain: imx8m-blk-ctrl: Serialize power on/off across sibling domains

Ridham Khurana <khurana.ridham222@gmail.com>
    regulator: tps6594-regulator: Fix n_linear_ranges for TPS65224 BUCK2-4

Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
    regulator: ltc3676: don't read the write-only HRST and CLIRQ registers

Denis V. Lunev <den@openvz.org>
    openvswitch: fix soft lockup in the netlink flow dump

Karl Bonde Torp <k.torp@samsung.com>
    nvme: fix swapped ZRASF zone state values for full and read only

Fredrik Nyberg <fredrik.nyberg@volvocars.com>
    net: usb: ax88179_178a: fix rx frame length for non-last packets

Sebastien Royen <sebastien.royen@armadeus.com>
    net: dsa: microchip: fix KSZ8765 fiber detection

Zixuan Chai <petalzu987@gmail.com>
    net: bridge: avoid recursive multicast port cleanup

Chengfeng Ye <nicoyip.dev@gmail.com>
    net/smc: protect clcsock lifetime in smc_getname

Quchaosheng <quchaosheng000406@163.com>
    net/packet: guard the ll header push in packet_rcv_spkt()

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: sdhci-sprd: disable runtime PM on remove

Yibo Tan <lhfff@tju.edu.cn>
    mmc: mtk-sd: Cancel request timeout work on remove

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: cavium-thunderx: destroy slot platform devices on remove

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: cavium-octeon: destroy slot platform devices on remove

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix reading free memory in do_resume

Ma Xinmeng <1564938642@qq.com>
    dm-snap: reject the transient exception store for snapshot-merge

Ben Cressey <ben@cressey.dev>
    dm-crypt: reject the lmk IV mode with AEAD ciphers

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    memstick: rtsx_usb_ms: complete requests after eject instead of dropping them

Raj Ojha <rajojha047@gmail.com>
    memstick: core: wait for request completion before freeing card

성병찬 <tjdqudcks0424@naver.com>
    KEYS: Fix add_key() race with keyring restriction

Karl Mehltretter <kmehltretter@gmail.com>
    keys: finalize persistent keyring timeout after link attempt

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: fix TX LTB and filter unwind on open-fail

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: h_free logical LAN on open-fail after register

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: xilinx: fix runtime PM leak on request error path

Vishal Badole <Vishal.Badole@amd.com>
    EDAC/amd64: Mask UMC chip select to the four implemented selects

Hui Peng <benquike@gmail.com>
    sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts

Christian Göttsche <cgzones@googlemail.com>
    selinux: fix data race on AVC latest_notif

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: libertas: reject short monitor TX frames"

Chengfeng Ye <nicoyip.dev@gmail.com>
    tipc: hold a reference to nodes found by link name

Yuqi Xu <xuyuqiabc@gmail.com>
    tipc: destroy topsrv workqueues before closing connections

Marek Szyprowski <m.szyprowski@samsung.com>
    swiotlb: fix default_swiotlb_limit() for non-growable default pool

Sabrina Dubroca <sd@queasysnail.net>
    strparser: make sure __strp_recv isn't running before tearing down the parser

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: don't leak the skb when xennet_fill_frags() fails

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in chained work check

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: reject response consumption after intermediate initiation

Ramses de Norre <ramses@well-founded.dev>
    wireguard: queueing: preserve tstamp_type when encapsulating packet

Michele Dionisio <michele.dionisio@gmail.com>
    wifi: brcmfmac: fix P2P device removal race in brcmf_detach()

Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
    usb: f81604: fix struct f81604_int_data size mismatch

Palla Raghunath <raghunathpalla.0209@gmail.com>
    dm ioctl: don't let data_start run past the buffer

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()

Michael Garland <minimelkav@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: irq: exclude the softirq stack switch from KCOV

Krzysztof Furman <krisfur@proton.me>
    Input: xpad - add support for Corsair Novablade Pro

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: do not warn on route notification size race

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: do not warn on route notification size race

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop route notification sizing when nexthop group shrinks

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop PMTU walk when nexthop group shrinks

Eric Biggers <ebiggers@kernel.org>
    crypto: drbg - Fix ineffective sanity check

Karl Mehltretter <kmehltretter@gmail.com>
    netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: hci_event: fix simultaneous discovery stuck in FINDING

Liew Rui Yan <aethernet65535@gmail.com>
    mm/damon/core: fix unconditionally skip last region

SeongJae Park <sj@kernel.org>
    mm/damon/core: do non-safe region walk on kdamond_apply_schemes()

Chao Yu <chao@kernel.org>
    f2fs: fix to reset all pinned status during fggc

Chao Yu <chao@kernel.org>
    f2fs: fix to shrink gc_lock coverage in f2fs_gc_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to reclaim space in f2fs_allocate_pinning_section()

Carlos Llamas <cmllamas@google.com>
    HID: uhid: convert to hid_safe_input_report()

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: introduce hid_safe_input_report()

Wentao Guan <guanwentao@uniontech.com>
    wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()

Pengpeng Hou <hppiscas@163.com>
    iio: cdc: ad7150: fix OF matching and publish module aliases

Paulo Alcantara <pc@manguebit.org>
    smb: client: only require read lease for size-extending preallocate

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32-adc: fix possible division by zero in processed channel

Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
    iio: adc: axp288: Add TS bias override for Haier HV103H

Cong Nguyen <congnt264@gmail.com>
    iio: adc: max1363: sign-extend bipolar differential channel reads

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: aspeed: propagate reset deassert errors

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    iio: adc: aspeed: Simplify with dev_err_probe

Fan Wu <fanwu01@zju.edu.cn>
    iio: adc: ad_sigma_delta: fix use-after-free on unbind

Paulo Alcantara <pc@manguebit.org>
    smb: client: discard post-EOF pagecache when extending a file via zero range

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: set info->band for 802.3 encap offload frames

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: mac80211: Add sta pointer sanity check in ieee80211_8023_xmit()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Use the active VMCB's MSR bitmap when checking if MSR is intercepted

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix avoid_reserve to allow taking folio from subpool

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: remove double CQ cleanup in mana_create_rxq error path

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: Skip WQ object destruction for uninitialized RXQ

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: check xdp_rxq registration before unreg in mana_destroy_rxq()

Jerome Tollet <jtollet@cisco.com>
    net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry

Jerome Tollet <jtollet@cisco.com>
    net/mlx5e: Prevent stale XSK buffer release on refill retry

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs: Free any excess xarray nodes in clear_inode()

Marco Chen <marcochen.dev@gmail.com>
    iio: health: max30102: fix NULL dereference in interrupt handler

Nuno Sa <nuno.sa@analog.com>
    iio: core: add accessors 'masklength'

Zhiling Zou <zhilinz@nebusec.ai>
    wifi: mac80211: count only matching reservations in reserved switch

Zhiling Zou <zhilinz@nebusec.ai>
    wifi: mac80211: keep paired old chanctx alive

Max Kellermann <max.kellermann@ionos.com>
    jbd2: bound shrinker scans by examined checkpoint buffers

Max Kellermann <max.kellermann@ionos.com>
    jbd2: check need_resched() when skipping busy checkpoint buffers

Marco Scardovi <scardracs@disroot.org>
    gpio: rockchip: fix generic IRQ chip leak on remove

Marco Scardovi <scardracs@disroot.org>
    gpio: rockchip: teardown bugs and resource leaks

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unwind TX receiver mailbox setup failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Publish channel state before callbacks

Saurabh Sengar <ssengar@linux.microsoft.com>
    fbdev: hyperv_fb: Allow graceful removal of framebuffer

Saurabh Sengar <ssengar@linux.microsoft.com>
    fbdev: hyperv_fb: Simplify hvfb_putmem

Gao Xiang <xiang@kernel.org>
    erofs: unify lcn as u64 for 32-bit platforms

Gao Xiang <xiang@kernel.org>
    erofs: avoid infinite loops due to corrupted subpage compact indexes

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: topology: Parse DAI type token for dspless mode

Johan Hovold <johan@kernel.org>
    tty: port: fix tty_port_tty_vhangup() race

Eric Dumazet <edumazet@kernel.org>
    bnxt_en: fix DMA mapping length for padded small packets

Han Xu <han.xu@nxp.com>
    mtd: spinand: Enable QE on all dies

Pei Xiao <xiaopei01@kylinos.cn>
    mtd: block2mtd: Fix divide error when erase_size is zero

Yu Kuai <yukuai3@huawei.com>
    block2mtd: prevent direct access of bd_inode

Jan Kara <jack@suse.cz>
    mtd: block2mtd: Convert to bdev_open_by_dev/path()

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: keep fallback association elements alive

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: shut down RX BA session timer on teardown

Nuno Sá <nuno.sa@analog.com>
    mtd: spinand: fix NULL pointer dereference with no ECC engine

Helge Deller <deller@kernel.org>
    apparmor: Fix & Optimize table creation from possibly unaligned memory

Helge Deller <deller@kernel.org>
    AppArmor: Allow apparmor to handle unaligned dfa tables

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Mark DCE 6.4 as not APU

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    i2c: xiic: preserve PEC byte length in SMBus block read setup

Manikanta Guntupalli <manikanta.guntupalli@amd.com>
    i2c: xiic: Relocate xiic_i2c_runtime_suspend and xiic_i2c_runtime_resume to facilitate atomic mode

Aaron Kling <webgeek1234@gmail.com>
    ALSA: hda/tegra: Re-enable SDO workaround for Tegra194

Wentao Liang <vulab@iscas.ac.cn>
    serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: ma35d1: Convert to platform remove callback returning void

Johan Hovold <johan@kernel.org>
    serial: fix TIOCMIWAIT race

Fan Wu <fanwu01@zju.edu.cn>
    tty: serial: max3100: shut down timer before freeing port

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing modem controls after DLCI open in convergence layer type 2

Johan Hovold <johan@kernel.org>
    tty: tty_port: restore TTY_IO_ERROR on activation failure

Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>
    usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41

Arthur Heymans <arthur@aheymans.xyz>
    drm/amd/display: Preserve eDP mode on initial ASSR failure

Runyu Xiao <runyu.xiao@seu.edu.cn>
    USB: dwc2: shut down wakeup timer before freeing HCD state

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-spear: disable controller wakeup on removal

Chen Ni <nichen@iscas.ac.cn>
    usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()

Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>
    drm/amdgpu: reset VI ASIC on MacBookPro14,3

Andre Eikmeyer <dev@deq.rocks>
    drm/amdgpu: reset VI ASIC on MacBookPro15,1

Jiangshan Yi <yijiangshan@kylinos.cn>
    drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend

Eric Biggers <ebiggers@kernel.org>
    fsverity: add dependency on 64K or smaller pages

Mostafa Saleh <smostafa@google.com>
    KVM: arm64: Don't use the VMA to size stage-2 block mappings for VM_PFNMAP

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A725 erratum 3821522 workaround

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Factor out broken AMU const counter cap

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: Serialize SMP remote OOB data access

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize SCO and ISO scheduling with teardown

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Forbid non-streaming SVE payload on SME-only systems

Zhengchuan Liang <zcliangcn@gmail.com>
    perf: Require kernel access for text poke events

Johan Hovold <johan@kernel.org>
    tty: fix saved termios reset race

Jiazi Liu <jiazi.liu1984@gmail.com>
    usb: dwc3: gadget: fix IRQ storm on invalid event buffer count

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fast updates on DCE 8.1

Andrey Albershteyn <aalbersh@kernel.org>
    fs,fsverity: remove check for fsverity being enabled in setattr_prepare()

Christoph Hellwig <hch@lst.de>
    fs,fsverity: reject size changes on fsverity files in setattr_prepare

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: drop RX packets with a short Ethernet header

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: constrain TCPM_SOURCING_VBUS event handling

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpm: fix debug accessory mode detection for sink ports

Neill Kapron <nkapron@google.com>
    usb: gadget: f_fs: Fix Use-After-Free in AIO error path

Gabriel Prostitis <prostitisgabriel@gmail.com>
    USB: gadget: ffs: fix mm lifetime handling

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: gadget: at91_udc: Convert to platform remove callback returning void

Karl Mehltretter <kmehltretter@gmail.com>
    serial: imx: serialize imx_uart_ports[] lifetime

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial: imx: Convert to platform remove callback returning void

Gilberto Conde <gilbertorconde@gmail.com>
    net: usb: qmi_wwan: add Quectel EG120K-EA

Wentao Liang <vulab@iscas.ac.cn>
    wifi: wlcore: Fix runtime PM leak in wlcore_remove()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    wifi: wlcore: Convert to platform remove callback returning void

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent race between disconnect() and rtx

Eric Dumazet <edumazet@google.com>
    tcp: introduce icsk->icsk_keepalive_timer

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages

Yi Yang <yiyang13@huawei.com>
    vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF

Chris Mason <clm@meta.com>
    SUNRPC: reject duplicate CREDS_VALUE options

Chris Mason <clm@meta.com>
    SUNRPC: fix gssx_dec_option_array error path bugs

Asad Kamal <asad.kamal@amd.com>
    drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save

Aditya Dutt <duttaditya18@gmail.com>
    jfs: fix array-index-out-of-bounds read in add_missing_indices

Fan Wu <fanwu01@zju.edu.cn>
    iio: trigger: cancel reenable_work before freeing trigger

Salah Triki <salah.triki@gmail.com>
    iio: proximity: vcnl3020: fix ISR bitmask check in IRQ handler

Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>
    iio: proximity: sx9324: Correct proximity channel resolution

Cong Nguyen <congnt264@gmail.com>
    iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure

Salah Triki <salah.triki@gmail.com>
    iio: proximity: isl29501: Fix return type of isl29501_register_write

Hui Su <sh_def@163.com>
    iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup

Fan Wu <fanwu01@zju.edu.cn>
    iio: light: gp2ap020a00f: drain irq_work after free_irq

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16480: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16400: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: gyro: adis16136: fix unprotected debugfs reads

Salah Triki <salah.triki@gmail.com>
    iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()

Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
    iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.

Jinseob Kim <kimjinseob88@gmail.com>
    iio: buffer: serialize buffer teardown with mode claims

Fan Wu <fanwu01@zju.edu.cn>
    iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind

Felix Gu <ustc.gu@gmail.com>
    iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls

Felix Gu <ustc.gu@gmail.com>
    iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32-adc: fix check on internal channel availability

Salah Triki <salah.triki@gmail.com>
    iio: accel: sca3000: fix frequency divider condition check

Jiale Yao <yaojiale02@163.com>
    iio: accel: kxcjk-1013: reject duplicate event disable

Frank Sorenson <sorenson@redhat.com>
    smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races

Daehyeon Ko <4ncienth@gmail.com>
    thunderbolt: Reject oversized XDomain properties responses

Kurt Lieber <kurt@lieber.org>
    thunderbolt: Disable CL states for the Anker Prime TB5 dock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix KASAN reported use-after-free when request is canceled

Ian Lin <ian.lin@jetone.com.tw>
    USB: serial: option: add Compal EXC-T1 support

Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
    USB: serial: option: add Quectel RG660QB

Ian Lin <jisayme@gmail.com>
    USB: serial: option: add Compal EXM-G1x support

Carlo Szelinsky <github@szelinsky.de>
    USB: serial: option: add Quectel EG060W

Zhao Dongdong <zhaodongdong@kylinos.cn>
    USB: serial: option: add support for SIMCom SIM8260C

Johan Hovold <johan@kernel.org>
    USB: serial: fix ioctl hangup race

Johan Hovold <johan@kernel.org>
    USB: serial: fix driver deregistration order

Johan Hovold <johan@kernel.org>
    USB: serial: fix dynamic id driver deregistration race

Johan Hovold <johan@kernel.org>
    USB: serial: ssu100: fix baud rate overflow

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: fix baud rate overflow

Jérémy Carrat <jeremy.carrat@icloud.com>
    USB: serial: cp210x: add Corsair AX1500i Power Supply

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: mac80211: handle empty FILS association request payload

Zihan Xi <zihanx@nebusec.ai>
    wifi: mac80211: fix mesh fast xmit path deletion UAF

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: release mesh path quota on failed additions

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: mac80211: minstrel_ht: validate fixed rate index

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: account proxy paths against the mesh path limit

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: drain PS delivery work during station teardown

Guangshuo Li <lgs201920130244@gmail.com>
    wifi: iwlegacy: 3945: free EEPROM data on remove

Tianchu Chen <flynnnchen@tencent.com>
    wifi: cw1200: fix TX padding OOB read leaking heap data to device

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bail from shadow walks if the root is invalid or a dummy

Nuno Sá <nuno.sa@analog.com>
    mtd: spinand: fix zero oobavail when no ECC engine is used

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix reads on chips with more than 64 bytes of OOB

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ

Weiming Shi <bestswngs@gmail.com>
    nvmet-auth: fix out-of-bounds write in nvmet_auth_challenge()

Bean Huo <beanhuo@micron.com>
    nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for Micron 4100AT

Daehyeon Ko <4ncienth@gmail.com>
    nvme-multipath: fix underflow in ANA log bounds checks

John Pavlick <jspavlick@posteo.net>
    net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules

Willem de Bruijn <willemb@google.com>
    net: extend IPv6 exthdr detection of tunneled packets

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    HID: multitouch: stop the release timer from being rearmed on remove

Zhiling Zou <zhilinz@nebusec.ai>
    ipvs: bound LBLCR and LBLC cache growth

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel: fix buffer over-read in btintel_hw_error()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize fragmented ISO packet queueing

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize ACL scheduling with channel deletion

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_core: Fix inquiry cache timestamps on 64-bit systems

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_conn: Lock parent access during enhanced SCO setup

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix inquiry cache use-after-free

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix initial port reference race

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    i2c: xiic: don't clobber msg->len to signal block-read completion

Xiang Mei <xmei5@asu.edu>
    ALSA: ua101: reject mismatched capture/playback packet sizes

Kyle Zeng <kylebot@openai.com>
    ALSA: seq: Serialize compat port-info ioctls

Zimeng Li <me@lizi.moe>
    ASoC: qcom: lpass-cpu: use DAI table index for playback constraints

Jiangshan Yi <yijiangshan@kylinos.cn>
    ASoC: codecs: rt1017-sdca-sdw: fix uninitialized stream_config->type

Jiangshan Yi <yijiangshan@kylinos.cn>
    ASoC: codecs: max98363: fix uninitialized stream_config->type

Wentao Liang <vulab@iscas.ac.cn>
    serial: vt8500: Fix clock reference leak in vt8500_serial_probe()

Simon Gassner <simon.gassner@noxsystems.com>
    serial: tegra: don't clear the Tx FIFO on an Rx-only reset

Fan Wu <fanwu01@zju.edu.cn>
    serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()

Johan Hovold <johan@kernel.org>
    tty: abort break signalling on hangup

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    tty: serial: qcom_geni_serial: Keep console RX functional after deep idle

Joshua Rogers <linux@joshua.hu>
    tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup

Joshua Rogers <linux@joshua.hu>
    tty: vcc: zero-initialize control packet in vcc_send_ctl()

Johan Hovold <johan@kernel.org>
    tty: amiserial: fix broken TIOCMIWAIT

Mingyu Wang <25181214217@stu.xidian.edu.cn>
    tty: vt: fix memory leak in vc_allocate()

Jie Deng <dengjie03@kylinos.cn>
    usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe

Fan Wu <fanwu01@zju.edu.cn>
    usb: cdns3: fix use-after-free in cdns3_gadget_exit()

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Current CAM OOB index fixup

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: typec: ucsi: Get the connector fwnode based on reg value

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: recover after failure to start the frs ams

Hui Peng <benquike@gmail.com>
    usb: core: clear both ep_in and ep_out for non-ep0 control endpoints

Myeonghun Pak <mhun512@gmail.com>
    usb: chipidea: tegra: disable runtime PM on resume failure

Yuchao Zhang <ndaugoing@gmail.com>
    usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix wait for outstanding request completions

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: aspeed-vhub: cancel wake work on device removal

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: am62: Fix runtime PM usage count leak on probe error path

Linkai Gong <gonglinkai@kylinos.cn>
    usb: typec: anx7411 - stop the IRQ before destroying the workqueue

Liu Chao <liuc63@xiaopeng.com>
    usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix the jack descriptor array sizes

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-st: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-s3c2410: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-da8xx: disable controller wakeup on cleanup

Orgad Shaneh <orgads@gmail.com>
    usb: octeon-hcd: fix the FIFO-flush timeout computation

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    usb: hub: use shorter 120ms post resume hold for SS root hubs

Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
    usb: storage: sierra_ms: reject short SWoC info transfers

Johan Hovold <johan@kernel.org>
    USB: serial: fix port tear down use-after-free

Yuchao Zhang <ndaugoing@gmail.com>
    USB: cdc-acm: skip URB restart in port_shutdown if disconnected

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy TIOCMIWAIT implementation

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Correct QUP Core ICC vote constants

Yuxiao Wang <yuxiao.wang@certik.com>
    nitro_enclaves: fix use-after-free on SLOT_ALLOC failure

Raphaël Larocque <rlarocque@disroot.org>
    Input: synaptics - limit T440p InterTouch quirk to LEN0036

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490

David Heidelberg <david@ixit.cz>
    Input: s6sy761 - fix resume ordering and restore sensing

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410

Martino Papero <martino.papero@lcb.to.it>
    Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11

Wentao Liang <vulab@iscas.ac.cn>
    kgdboc: Fix tty driver reference leak in configure_kgdboc()

Tomer Pomeranc <tomerpo@gmail.com>
    binder: fix leaked fd fixups on TF_UPDATE_TXN supersede

Tomer Pomeranc <tomerpo@gmail.com>
    binder: fix is_failure flag for superseded transaction cleanup

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix ACP MFD device leak on init failure

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix IP instance memory leak on kobject add failure

Wentao Liang <vulab@iscas.ac.cn>
    drm/mediatek: Fix pdev reference leak in mtk_drm_bind()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/mediatek: Fix ovl adaptor platform device leak

Haojie Li <lihaojie@kylinos.cn>
    drm/mediatek: Add missing IS_ERR check for ovl_adaptor platform device

Imre Kaloz <kaloz@kernel.org>
    drm/radeon: Read the VRAM VBIOS signature with readb()

Willian Oliveira <williandossantosdeoliveira287@gmail.com>
    drm/amdgpu/gfx6: fix firmware leak on teardown

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Fix updating clock limits on AC/DC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC

Nikola Prica <nikola.prica@amd.com>
    PCI: Accept AtomicOps already enabled by the hypervisor

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1712: Fix the error handling via auto-cleanup at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Define auto-cleanup for snd_card_free()

Luo Gengkun <luogengkun2@huawei.com>
    perf: Fix race between perf_event_exit_task() and perf_pending_task()

Hongjian Dai <daihongjian@kylinsec.com.cn>
    i2c: at91: release DMA channels when probe defers

Eric Dumazet <edumazet@kernel.org>
    ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()

Florian Westphal <fw@strlen.de>
    net: add and use skb_get_hash_net

Quentin Freimanis <quentin@q-lab.dev>
    net: sparx5: make ports inherit the switch base mac address type

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: microchip: vcap: stop scanning after deleting key field

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: generalize pending status bit

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: rework offload nf_conn timeout extension logic

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: remove skb argument from nf_ct_refresh

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: bpf: reject invalid NAT manipulation types

Julian Anastasov <ja@ssi.bg>
    ipvs: filter some flags received in the backup server

Julian Anastasov <ja@ssi.bg>
    ipvs: do not create invisible templates

Julian Anastasov <ja@ssi.bg>
    ipvs: fix missing counter decrement in lblc

Jeff Jo <jeffjo@openai.com>
    tcp: refresh TS.Recent for accepted old ACKs

Sandeep Haemoon <sandeeph@loljews.com>
    net: ethernet: mtk_eth_soc: allocate dummy netdev sooner

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: fix NULL dereference in set_coalesce before first open

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_codel: match the no-drop threshold to the packet size

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_codel: match the no-drop threshold to the packet size

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tipc: prevent GCM nonce reuse on peer key changes

Baha Mesleh <baha.mesleh@nokia.com>
    octeontx2-af: mcs: Fix SC resource cleanup loop

Florian Fainelli <florian.fainelli@broadcom.com>
    net: systemport: Fix RUNT MIB counter register offset calculation

Florian Fainelli <florian.fainelli@broadcom.com>
    net: systemport: Fix buffer overflow in bcm_sysport_get_stats()

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_sync: don't drain cmd_sync backlog on unregister

Florian Westphal <fw@strlen.de>
    netfilter: ipset: do not update comments from kernel-side adds

Qishuai Liu <lqs@lqs.me>
    ipv6: fix prefix route expiry in modify_prefix_route()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: reclaim an empty proto on the error path

Binbin Deng <18983559317@163.com>
    net/mctp: publish the mctp_dev only after it is initialised

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel: validate DDC record lengths

Sang-Hoon Choi <csh0052@gmail.com>
    Bluetooth: hci_core: free the HCI ID if naming fails

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt274: Fix format setting for 44100 rate

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt286: Revert delay value for jack setup

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: prevent AP VLAN tx from other interfaces

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: mac80211: Add 802.3 multicast encapsulation offload support

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: mac80211: Add multicast to unicast support for 802.3 path

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: preserve hidden-group beacon IE ownership

Manush Prajwal <manushprajwal555@gmail.com>
    rtc: mpfs: fix unchecked devm_clk_get() error pointer in probe()

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: reset ar->num_stations on hardware start

Sheetal <sheetal@nvidia.com>
    ASoC: tegra: Fix ASRC Stream6 input threshold control

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: wfx: validate MIB read length before copying to caller

HyeongJun An <sammiee5311@gmail.com>
    ASoC: wm8903: Move the DRC QR threshold to the register that holds it

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't create "//" paths for fragments targeting the root

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't leak fragment references when changeset init fails

Julian Sun <sunjunchao@bytedance.com>
    nvmet: preserve device path on allocation failure

Karl Mehltretter <kmehltretter@gmail.com>
    mtd: core: call _get_device() with the master MTD

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: accel: kionix-kx022a: Fix array boundary check

SJ Park <sj@kernel.org>
    mm/damon/core: don't skip damos_adjust_quota() while esz is not zero

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    perf/core: Fix WARN in perf_sigtrap()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/secretmem: properly account locked pages

Xiang Mei <xmei5@asu.edu>
    ALSA: line6: reject oversized playback packets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: caiaq: unregister the input device when probe fails

Zizhi Wo <wozizhi@huawei.com>
    vt: skip screen update for DEC alignment test on backgroup consoles

Maoyi Xie <maoyixie.tju@gmail.com>
    rds_tcp: close NULL deref window in rds_tcp_set_callbacks

Benjamin Berg <benjamin.berg@intel.com>
    wifi: cfg80211: avoid double free if updating BSS fails

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Define lpfc_dmabuf type for ctx_buf ptr

Jiangshan Yi <yijiangshan@kylinos.cn>
    smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions

Jun Yang <junvyyang@tencent.com>
    sctp: check RCV_SHUTDOWN after the sendmsg connect wait

Runyu Xiao <runyu.xiao@seu.edu.cn>
    rtc: spear: initialize IRQ state before requesting alarm IRQ

Aamir Ahmed <elb12345@hotmail.co.uk>
    rtc: ac100: Assign .num before accessing .hws

Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>
    net/packet: prevent TX_RING byte count overflow

Aohan Mei <henrymei@tencent.com>
    netfilter: nft_flow_offload: drop flowtable reference on init error path

Alireza Asgari <alireza@asgari.net>
    net: fix checksum offsets in skb_splice_from_iter()

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: only treat a positive changeset id as registered

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: put property on deadprops only after changeset add succeeds

Wentao Liang <vulab@iscas.ac.cn>
    of/irq: Fix remaining refcount leaks in of_irq_init()

Leon Hwang <leon.hwang@linux.dev>
    kprobes: Skip disarmed probes when checking optkprobe overlap

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    audit: fix exe mark UAF in kill_rules()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices

SJ Park <sj@kernel.org>
    mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()

Darrick J. Wong <djwong@kernel.org>
    xfs: fix cursor and pointer handling when recovering iunlink buckets

Zihan Xi <zihanx@nebusec.ai>
    smb: client: close completed creates on compound wait errors

Zihan Xi <zihanx@nebusec.ai>
    smb: client: close handle after create-context parsing failure

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: pass cifs_open_info_data to SMB2_open()

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: unregister DualPoint Stick input device on remove

Bastien Nocera <hadess@hadess.net>
    HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM

Thomas Weißschuh <linux@weissschuh.net>
    HID: core: remove #ifdef CONFIG_PM from hid_driver

Tibor Harcsa <silurust@gmail.com>
    Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, xdp: move offload check into dev_xdp_install()

Jiakai Xu <jiakaipeanut@gmail.com>
    RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: fix NULL deref unwinding an OP_MAP_SPARSE op

Namjae Jeon <linkinjeon@kernel.org>
    smb: client: use finish_no_open() for non-regular inodes

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix GRT PEBS load/store direction for latency events, to fix sample classification

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Update event constraints and cache_extra_regsfor ADL

Aohan Mei <henrymei@tencent.com>
    netfilter: nf_tables: skip expired catchall elements on insert and delete

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: set->ops->insert returns opaque set element in case of EEXIST

Guangshuo Li <lgs201920130244@gmail.com>
    net: ena: fix MMIO read buffer leak on probe failure

Dr. David Alan Gilbert <linux@treblig.org>
    net: ena: Remove autopolling mode

Puranjay Mohan <puranjay@kernel.org>
    perf/core: Run sched_task() for PMUs with only CPU-wide events

Thomas Richter <tmricht@linux.ibm.com>
    perf/core: Allow list_del during perf_event_overflow()

Puranjay Mohan <puranjay@kernel.org>
    perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()

Kan Liang <kan.liang@linux.intel.com>
    perf: Supply task information to sched_task()

Yuqi Xu <xuyuqiabc@gmail.com>
    net: ipconfig: bound DHCP option construction

Thorsten Blum <thorsten.blum@linux.dev>
    net: ipconfig: Remove outdated comment and indent code block

Liz Fong-Jones <lizf@honeycomb.io>
    PCI: Fix BAR resize for devices on a root bus

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix Resizable BAR restore order

Christian Brauner <brauner@kernel.org>
    super: make iterate_supers_type() deletion-safe

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Serialize IMSIC attributes with vCPU migration

Jiakai Xu <jiakaipeanut@gmail.com>
    RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_rw_attr()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: fix helper UAF due to extensions realloc

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: remove 'add_helper' dead code

Florian Westphal <fw@strlen.de>
    openvswitch: prepare for stolen verdict coming from conntrack and nat engine

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: avoid modifying shared unconfirmed ct entry

Ilya Maximets <i.maximets@ovn.org>
    net/sched: act_ct: fix helper UAF due to extensions realloc

Jaewook You <jaewook376@gmail.com>
    mm/hugetlb: preserve mremap address delta when skipping page tables

Jinjiang Tu <tujinjiang@huawei.com>
    mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau/uvmm: fix UAF in nouveau_uvmm_sm when BO is in TTM_PL_SYSTEM

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix acpi device leak in amdgpu_acpi_enumerate_xcc()

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities

Willem de Bruijn <willemb@google.com>
    tcp: prevent collapsing skbs across boundary in rtx queue

Myeonghun Pak <mhun512@gmail.com>
    bna: prevent IOC timer rearm during teardown

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix reparse buffer bounds in cifs_query_reparse_point()

April Cardenas <april.cardenas@canonical.com>
    smb/client: send lease break ACKs thru correct session for multiuser mounts

Fan Wu <fanwu01@zju.edu.cn>
    wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Yibo Tan <lhfff@tju.edu.cn>
    hwmon: (pwm-fan) Stop RPM timer before freeing tach data

Hongling Zeng <zenghongling@kylinos.cn>
    btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()

Fan Wu <fanwu01@zju.edu.cn>
    smb: client: fix cifsFileInfo reference leak in deferred close

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not reschedule the RTX timer for fallback sockets

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reset retrans_time when ADD_ADDR entry is reused

Qing Luo <luoqing@kylinos.cn>
    mptcp: pm: userspace: fix address ID overflow

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: use sock_kmemdup for address entry

Geliang Tang <tanggeliang@kylinos.cn>
    sock: add sock_kmemdup helper

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: drop match in userspace_pm_append_new_local_addr

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: add sysfs feature entry for xattr prefixes

Nikhil Gurudasani <nikhilgurudasani314@gmail.com>
    erofs: preserve LZMA decoders on resize failure

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release all action references on NEWACTION failure

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_mmio: disable IRQ wake before free_irq

Viresh Kumar <viresh.kumar@linaro.org>
    virtio-mmio: Remove virtqueue list from mmio device

Zihan Xi <zihanx@nebusec.ai>
    ipmr: account multicast table and route memory

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix is_avivo() constant comparison bug

Shixiong Ou <oushixiong@kylinos.cn>
    drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve stride validation

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: simpledrm: Improve panel-size validation

Guanghui Yang <3497809730@qq.com>
    f2fs: fix dentry folio leak in find_in_level

Wenjie Qi <qwjhust@gmail.com>
    f2fs: limit recovery filename logging to stored length

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error path

Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
    media: rkvdec: Propagate platform_get_irq() errors

Johan Hovold <johan@kernel.org>
    media: platform: mtk-mdp3: fix NULL deref on failed SCP lookup

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP

Imran Shaik <imran.shaik@oss.qualcomm.com>
    clk: qcom: Fix test_ctl_hi field for DEFAULT_EVO PLLs

Xu Rao <raoxu@uniontech.com>
    nvme-fabrics: fix DHCHAP secret leak on parse failure

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Synchronize the initialization of ftrace_ops

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix anon_stack check for unnamed bitfields in btf_find_struct_member

Muhammad Bilal <meatuni001@gmail.com>
    staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix use-after-free of master->this

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Do not treat master device as a duplicate target

Can Peng <pengcan@kylinos.cn>
    hwrng: stm32 - Fix runtime PM cleanup on registration failure

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: qcom_battmgr: fix use-after-free

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate max level for set feature

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate parameter for core power state

Fan Wu <fanwu01@zju.edu.cn>
    mmc: via-sdmmc: cancel card-detect work on remove

Oscar Ou <oscarou@synology.com>
    lockd: fix swapped arguments in nlmsvc_match_ip()

Ruoyu Wang <ruoyuw560@gmail.com>
    i2c: mxs: fix DMA channel leak on probe error

Bence Csókás <csokas.bence@prolan.hu>
    dmaengine: Add devm_dma_request_chan()

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    ASoC: codecs: aw88261: only check PLL and clock state at power-up

Val Packett <val@packett.cool>
    ASoC: codecs: aw88261: reduce log spam

Jiacheng Yu <yujiacheng3@huawei.com>
    params: fix charp corruption on allocation failure

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Fix multi-line comment style

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Sort headers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Use size_add() for kmalloc()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    params: Do not go over the limit when getting the string length

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Add locking around AML evaluations

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Split three functions to untangle runtime PM handling

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: TAD: Rearrange RT data validation checking

Haoxiang Li <haoxiang_li2024@163.com>
    cpufreq: apple-soc: Fix OPP table cleanup

Kuan-Wei Chiu <visitorckw@gmail.com>
    coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior

Jeff Layton <jlayton@kernel.org>
    nfsd: fix clock domain mismatch in clients_still_reclaiming()

Jeff Layton <jlayton@kernel.org>
    nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()

Chris Mason <clm@meta.com>
    nfsd: size fh_verify server sockaddr slot by xpt_locallen

Longlong Xia <xialonglong@kylinos.cn>
    zram: fix out-of-bounds access in read_block_state()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: fixup read_block_state()

Chengfeng Ye <nicoyip.dev@gmail.com>
    KEYS: trusted: Fix TPM teardown ordering

Jakub Kicinski <kuba@kernel.org>
    ethtool: fail closed if we can't get max channel used in indirection tables

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: av7110: fix a spectre vulnerability

Christoph Schlameuss <schlameuss@linux.ibm.com>
    kvm: s390: Reject memory region operations for ucontrol VMs

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Add encoder check in hdcp2_get_capability

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Add encoder check in intel_hdcp_get_capability

Ilya Titov <ilya.titov@wirenboard.com>
    pinctrl: sunxi: keep a shadow copy of the data register output latches

Xiang Mei <xmei5@asu.edu>
    vlan: require the MAC header to be present in __vlan_insert_inner_tag()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: fix use-after-free of iface in cifs_try_adding_channels()

Bharath SM <bharathsm@microsoft.com>
    smb: mark the new channel addition log as informational log with cifs_info

Daehyeon Ko <4ncienth@gmail.com>
    wifi: libipw: reject TKIP frames without a full MIC

Xiang Mei <xmei5@asu.edu>
    ALSA: usb-audio: Clamp implicit feedback packet count to URB capacity

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling

Norbert Szetei <norbert@doyensec.com>
    landlock: Fix use-after-free of the source's parent directory

Fan Wu <fanwu01@zju.edu.cn>
    ieee802154: cc2520: fix FIFOP work use-after-free

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: use option bits for CFM/MRP frame handlers

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: end write accounting from ->ki_complete

XingWang Xiang <v3rdant.xiang@gmail.com>
    genetlink: pin family module during policy dump

Xu Rao <raoxu@uniontech.com>
    Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Bluetooth: btqcomsmd: Convert to platform remove callback returning void

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Fix memory corruption from a "STACKTRACE" histogram key

Chao Yu <chao@kernel.org>
    f2fs: embed f2fs_gc_kthread in f2fs_sb_info

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate MOVE_RANGE destination size

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize data structures for inject_pfault_token

Tristan Madani <tristan@talencesecurity.com>
    nvme: add missing SRCU grace period in error path

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Take trace_array reference before accessing its ftrace_ops

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_restruct_wmm_ie()

Vivek BalachandharTN <vivek.balachandhar@gmail.com>
    staging: rtl8723bs: fix spacing around operators

Myeonghun Pak <mhun512@gmail.com>
    usb: storage: realtek_cr: fix use-after-free on disconnect

Jan Kara <jack@suse.cz>
    udf: Fix data loss when converting inline inodes to out of line

Fan Wu <fanwu01@zju.edu.cn>
    wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop

Doruk Tan Ozturk <doruk@0sec.ai>
    ocfs2: validate directory-index entry counts when reading metadata

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: validate dx_root extent list fields during block read

Baul Lee <baul.lee@xbow.com>
    HID: universal-pidff: stop the device when force-feedback init fails

Doruk Tan Ozturk <doruk@0sec.ai>
    HID: sony: fix UAF of ghl_poke_timer / ghl_urb at driver unbind

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()

Sam Edwards <cfsworks@gmail.com>
    ceph: properly decrypt filenames in vmalloc() buffers

Jeff Layton <jlayton@kernel.org>
    nfsd: fix nfsd_file leak on inter-server COPY setup failure

Roger Pau Monne <roger@xenproject.org>
    x86/xen: fix init of balloon stats again

Roger Pau Monne <roger.pau@citrix.com>
    xen/balloon: improve accuracy of initial balloon target for dom0

Hyunwoo Kim <imv4bel@gmail.com>
    apparmor: fix out-of-bounds write when null terminating a label vec

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client

David Arinzon <darinzon@amazon.com>
    net: ena: Add validation for completion descriptors consistency

Shay Drory <shayd@nvidia.com>
    net/mlx5e: Fix netif state handling

Jan Kara <jack@suse.cz>
    ocfs2: Avoid touching renamed directory if parent does not change

Tahera Fahimi <taherafahimi@linux.microsoft.com>
    xfrm: prevent policy_hthresh.work from racing with netns teardown

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    dma-direct: return struct page from dma_direct_alloc_from_pool()

Christoph Hellwig <hch@lst.de>
    dma-direct: simplify the use atomic pool logic in dma_direct_alloc


-------------

Diffstat:

 CREDITS                                            |    5 +
 Documentation/ABI/testing/sysfs-fs-erofs           |    2 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |   47 +-
 Documentation/arch/arm64/silicon-errata.rst        |    2 +
 Documentation/filesystems/ntfs.rst                 |  466 ---
 Documentation/netlink/specs/rt_link.yaml           |    2 +
 Documentation/networking/strparser.rst             |    2 +-
 Documentation/virt/kvm/api.rst                     |    6 +
 MAINTAINERS                                        |   12 +-
 Makefile                                           |   31 +-
 arch/alpha/include/asm/pgtable.h                   |   33 +-
 arch/alpha/include/asm/tlbflush.h                  |    4 +-
 arch/alpha/lib/Makefile                            |    1 -
 arch/alpha/mm/Makefile                             |    4 +-
 arch/alpha/mm/tlbflush.c                           |  112 +
 arch/arm/mm/dump.c                                 |    4 +-
 arch/arm/net/bpf_jit_32.c                          |   25 +-
 arch/arm64/Kconfig                                 |   30 +
 arch/arm64/kernel/Makefile                         |    3 +
 arch/arm64/kernel/cpu_errata.c                     |   24 +-
 arch/arm64/kernel/cpufeature.c                     |    2 +-
 arch/arm64/kernel/ptrace.c                         |   50 +
 arch/arm64/kernel/signal.c                         |   34 +-
 arch/arm64/kernel/topology.c                       |   11 +-
 arch/arm64/kvm/mmu.c                               |   25 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |    8 +
 arch/arm64/kvm/vgic/vgic.c                         |    9 +-
 arch/arm64/net/bpf_jit_comp.c                      |   15 +-
 arch/arm64/tools/cpucaps                           |    2 +-
 arch/loongarch/kernel/Makefile                     |    2 +-
 arch/loongarch/kernel/machine_kexec.c              |    5 +-
 arch/loongarch/kernel/setup.c                      |    1 +
 arch/loongarch/net/bpf_jit.c                       |   34 +-
 arch/mips/Kbuild                                   |    6 -
 arch/mips/kernel/ftrace.c                          |   25 +-
 arch/mips/net/bpf_jit_comp.c                       |    3 +-
 arch/mips/sgi-ip22/ip22-platform.c                 |   32 +
 arch/parisc/net/bpf_jit_core.c                     |    8 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   16 +
 arch/powerpc/include/asm/iommu.h                   |    4 +-
 arch/powerpc/include/asm/xive.h                    |    4 +-
 arch/powerpc/kernel/iommu.c                        |  151 +-
 arch/powerpc/kexec/ranges.c                        |   12 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |   15 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |    2 +-
 arch/powerpc/mm/pgtable-frag.c                     |    1 +
 arch/powerpc/mm/pgtable_64.c                       |    2 +-
 arch/powerpc/net/bpf_jit_comp.c                    |   12 +-
 arch/powerpc/perf/core-book3s.c                    |    8 +-
 arch/powerpc/platforms/powernv/smp.c               |    8 +-
 arch/powerpc/platforms/pseries/iommu.c             |  147 +-
 arch/powerpc/platforms/pseries/smp.c               |    8 +-
 arch/powerpc/sysdev/xive/common.c                  |   10 +-
 arch/riscv/include/asm/kvm_host.h                  |    7 +
 arch/riscv/include/asm/processor.h                 |    1 +
 arch/riscv/kernel/asm-offsets.c                    |    5 +
 arch/riscv/kernel/entry.S                          |    9 +
 arch/riscv/kvm/aia_imsic.c                         |   16 +-
 arch/riscv/kvm/main.c                              |    4 +-
 arch/riscv/kvm/vcpu.c                              |   27 +-
 arch/riscv/kvm/vcpu_vector.c                       |    5 +-
 arch/riscv/kvm/vmid.c                              |    2 +-
 arch/riscv/net/bpf_jit_core.c                      |    6 +-
 arch/s390/boot/vmem.c                              |    2 +-
 arch/s390/include/asm/nmi.h                        |    3 +
 arch/s390/include/asm/pci_insn.h                   |   10 +-
 arch/s390/include/asm/pgtable.h                    |    8 +-
 arch/s390/kernel/nmi.c                             |    5 +-
 arch/s390/kernel/perf_pai_crypto.c                 |    3 +-
 arch/s390/kernel/perf_pai_ext.c                    |    3 +-
 arch/s390/kvm/interrupt.c                          |   24 +-
 arch/s390/kvm/kvm-s390.c                           |    7 +-
 arch/s390/mm/fault.c                               |   13 +-
 arch/s390/mm/gmap.c                                |   12 +-
 arch/s390/mm/hugetlbpage.c                         |    2 +-
 arch/s390/mm/pageattr.c                            |    2 +-
 arch/s390/mm/pgtable.c                             |    6 +-
 arch/s390/mm/vmem.c                                |    6 +-
 arch/s390/net/bpf_jit_comp.c                       |    6 +-
 arch/sparc/kernel/Makefile                         |    1 -
 arch/sparc/lib/Makefile                            |    1 -
 arch/sparc/mm/Makefile                             |    1 -
 arch/sparc/mm/init_64.c                            |    4 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |    6 +-
 arch/sparc/prom/Makefile                           |    1 -
 arch/um/include/linux/time-internal.h              |    2 +
 arch/um/kernel/skas/syscall.c                      |   45 +-
 arch/x86/boot/compressed/ident_map_64.c            |    2 +-
 arch/x86/crypto/Kconfig                            |    4 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |  110 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |  156 +-
 arch/x86/events/amd/brs.c                          |    3 +-
 arch/x86/events/amd/core.c                         |   12 +-
 arch/x86/events/amd/lbr.c                          |    3 +-
 arch/x86/events/core.c                             |    5 +-
 arch/x86/events/intel/core.c                       |   50 +-
 arch/x86/events/intel/ds.c                         |   45 +-
 arch/x86/events/intel/lbr.c                        |    3 +-
 arch/x86/events/intel/pt.c                         |   56 +-
 arch/x86/events/perf_event.h                       |   29 +-
 arch/x86/include/asm/uaccess_64.h                  |    5 +-
 arch/x86/kernel/cpu/amd.c                          |   11 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   19 +-
 arch/x86/kvm/hyperv.c                              |    2 +-
 arch/x86/kvm/mmu/mmu.c                             |    8 +-
 arch/x86/kvm/svm/hyperv.h                          |    7 +
 arch/x86/kvm/svm/nested.c                          |   53 +-
 arch/x86/kvm/svm/sev.c                             |   29 +-
 arch/x86/kvm/svm/svm.c                             |   75 +-
 arch/x86/kvm/vmx/nested.c                          |   31 +-
 arch/x86/kvm/x86.c                                 |   13 +
 arch/x86/kvm/x86.h                                 |    4 +-
 arch/x86/kvm/xen.c                                 |    2 +-
 arch/x86/lib/copy_user_uncached_64.S               |    6 +-
 arch/x86/lib/usercopy_64.c                         |    4 +-
 arch/x86/mm/fault.c                                |    8 +-
 arch/x86/mm/init_32.c                              |    2 +-
 arch/x86/mm/init_64.c                              |    8 +-
 arch/x86/mm/kasan_init_64.c                        |    2 +-
 arch/x86/mm/mem_encrypt_identity.c                 |    4 +-
 arch/x86/mm/pat/set_memory.c                       |    4 +-
 arch/x86/mm/pgtable.c                              |    2 +-
 arch/x86/mm/pti.c                                  |    4 +-
 arch/x86/net/bpf_jit_comp.c                        |    8 +-
 arch/x86/net/bpf_jit_comp32.c                      |    3 +-
 arch/x86/power/hibernate.c                         |    2 +-
 arch/x86/xen/mmu_pv.c                              |    4 +-
 block/bfq-cgroup.c                                 |    9 +-
 block/blk-cgroup.c                                 |    5 +-
 block/blk-cgroup.h                                 |    2 +
 block/blk-iocost.c                                 |   21 +-
 block/blk-iolatency.c                              |   19 +-
 block/blk-throttle.c                               |   15 +-
 crypto/af_alg.c                                    |    2 +
 crypto/algif_skcipher.c                            |    8 +-
 crypto/drbg.c                                      |   11 +-
 drivers/accel/habanalabs/common/device.c           |    2 +-
 drivers/accel/habanalabs/common/memory.c           |   24 +-
 drivers/accel/ivpu/ivpu_fw_log.c                   |   74 +-
 drivers/accel/ivpu/ivpu_gem.h                      |   14 +-
 drivers/accel/ivpu/ivpu_ipc.c                      |    7 +-
 drivers/accel/qaic/mhi_controller.c                |   22 -
 drivers/acpi/acpi_platform.c                       |   16 +-
 drivers/acpi/acpi_tad.c                            |  188 +-
 drivers/acpi/bus.c                                 |   54 +-
 drivers/acpi/processor_idle.c                      |    4 +-
 drivers/android/binder.c                           |    3 +-
 drivers/android/binder_alloc.c                     |    7 +-
 drivers/base/core.c                                |    3 +-
 drivers/base/memory.c                              |    4 +-
 drivers/base/property.c                            |   35 +
 drivers/block/null_blk/main.c                      |   16 +-
 drivers/block/ublk_drv.c                           |   50 +-
 drivers/block/zram/zram_drv.c                      |   25 +-
 drivers/bluetooth/btintel.c                        |   15 +-
 drivers/bluetooth/btqcomsmd.c                      |   10 +-
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   43 +-
 drivers/bus/mhi/host/pci_generic.c                 |   20 +-
 drivers/char/hw_random/core.c                      |  152 +-
 drivers/char/hw_random/stm32-rng.c                 |   12 +-
 drivers/clk/mediatek/clk-pllfh.c                   |   97 +-
 drivers/clk/qcom/gcc-qcm2290.c                     |    6 +-
 drivers/clk/qcom/gcc-sm6115.c                      |    6 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c             |   64 +-
 drivers/clocksource/samsung_pwm_timer.c            |   22 +-
 drivers/cpufreq/acpi-cpufreq.c                     |    4 +-
 drivers/cpufreq/amd-pstate.c                       |    7 +-
 drivers/cpufreq/apple-soc-cpufreq.c                |   40 +-
 drivers/cpufreq/bmips-cpufreq.c                    |    4 +-
 drivers/cpufreq/cppc_cpufreq.c                     |    3 +-
 drivers/cpufreq/cpufreq-dt.c                       |    3 +-
 drivers/cpufreq/e_powersaver.c                     |    3 +-
 drivers/cpufreq/intel_pstate.c                     |    8 +-
 drivers/cpufreq/mediatek-cpufreq-hw.c              |    4 +-
 drivers/cpufreq/mediatek-cpufreq.c                 |    4 +-
 drivers/cpufreq/omap-cpufreq.c                     |    3 +-
 drivers/cpufreq/pasemi-cpufreq.c                   |    6 +-
 drivers/cpufreq/pcc-cpufreq.c                      |    6 -
 drivers/cpufreq/powernow-k6.c                      |    5 +-
 drivers/cpufreq/powernow-k7.c                      |    3 +-
 drivers/cpufreq/powernow-k8.c                      |    6 +-
 drivers/cpufreq/powernv-cpufreq.c                  |    4 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c                  |    3 +-
 drivers/cpufreq/qcom-cpufreq-hw.c                  |    5 +-
 drivers/cpufreq/qoriq-cpufreq.c                    |    4 +-
 drivers/cpufreq/scmi-cpufreq.c                     |    4 +-
 drivers/cpufreq/scpi-cpufreq.c                     |    4 +-
 drivers/cpufreq/sh-cpufreq.c                       |    4 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c               |    3 +-
 drivers/cpufreq/sparc-us3-cpufreq.c                |    3 +-
 drivers/cpufreq/speedstep-centrino.c               |   10 +-
 drivers/cpufreq/tegra194-cpufreq.c                 |    4 +-
 drivers/cpufreq/vexpress-spc-cpufreq.c             |    5 +-
 drivers/crypto/hisilicon/qm.c                      |   38 +-
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   14 +
 drivers/cxl/core/core.h                            |    2 +
 drivers/cxl/core/mbox.c                            |   15 +-
 drivers/cxl/core/pci.c                             |   10 +-
 drivers/cxl/core/port.c                            |   13 +-
 drivers/cxl/core/region.c                          |   84 +-
 drivers/cxl/core/trace.h                           |   12 +-
 drivers/cxl/cxl.h                                  |   22 +-
 drivers/dma-buf/dma-buf.c                          |   15 +
 drivers/dma-buf/dma-heap.c                         |   80 +-
 drivers/dma-buf/udmabuf.c                          |   20 +-
 drivers/dma/dmaengine.c                            |   30 +
 drivers/dma/idxd/init.c                            |   36 +-
 drivers/dma/ti/k3-udma-glue.c                      |   15 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   14 +-
 drivers/edac/amd64_edac.c                          |    4 +-
 drivers/edac/igen6_edac.c                          |    6 +
 drivers/firewire/core-topology.c                   |   30 +-
 drivers/firewire/ohci.c                            |    4 +-
 drivers/firmware/arm_ffa/driver.c                  |    4 +-
 drivers/firmware/arm_scmi/bus.c                    |   36 +-
 drivers/firmware/arm_scmi/driver.c                 |    4 +-
 drivers/firmware/arm_scmi/mailbox.c                |   23 +-
 drivers/firmware/arm_scmi/smc.c                    |   13 +-
 drivers/firmware/qcom_scm-smc.c                    |    2 +-
 drivers/firmware/qcom_scm.c                        |    8 +-
 drivers/firmware/qcom_scm.h                        |    2 +-
 drivers/fpga/dfl.c                                 |    2 +-
 drivers/gpio/gpio-exar.c                           |    2 +-
 drivers/gpio/gpio-mvebu.c                          |    1 +
 drivers/gpio/gpio-pca953x.c                        |   18 +-
 drivers/gpio/gpio-rockchip.c                       |   19 +-
 drivers/gpio/gpio-xilinx.c                         |    9 +-
 drivers/gpu/drm/Makefile                           |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |    9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |   13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |    8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   63 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   26 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   73 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   86 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   61 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c     |  104 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.h     |    9 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h            |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |   15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c            |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h            |    3 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |   46 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |    5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   32 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   32 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  150 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   20 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c            |   28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h            |    1 +
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |    3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |    2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |    9 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |    2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |    8 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   24 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |   23 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   20 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   24 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |    8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c             |    8 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |   14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0_4.c           |   14 +-
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c              |    8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   23 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |   22 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |    4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |    1 +
 drivers/gpu/drm/amd/amdgpu/vi.c                    |   21 +
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   17 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   51 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |    2 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   56 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   10 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   24 +-
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |   18 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   82 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    8 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   10 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |    8 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   69 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |    3 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   22 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   40 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |    3 +
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |    2 +-
 .../amd/display/dc/clk_mgr/dcn201/dcn201_clk_mgr.c |    2 -
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   29 +-
 drivers/gpu/drm/amd/display/dc/core/dc_debug.c     |    2 +
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |   82 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    2 +
 drivers/gpu/drm/amd/display/dc/dc.h                |    1 +
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |   36 +-
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h       |    2 +-
 drivers/gpu/drm/amd/display/dc/dc_helper.c         |    3 +
 drivers/gpu/drm/amd/display/dc/dc_types.h          |    1 +
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |   20 +-
 drivers/gpu/drm/amd/display/dc/dce/dmub_abm_lcd.c  |    2 +-
 .../amd/display/dc/dce110/dce110_hw_sequencer.c    |   14 +-
 .../drm/amd/display/dc/dce112/dce112_resource.c    |    5 +-
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |    1 -
 .../gpu/drm/amd/display/dc/dce80/dce80_resource.c  |    1 +
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hubp.c  |    3 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   22 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hubp.c  |    5 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   27 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_vmid.c  |    3 +
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c  |    2 +
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hwseq.c |    2 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |    2 +
 .../drm/amd/display/dc/dcn301/dcn301_resource.c    |    2 +
 .../drm/amd/display/dc/dcn302/dcn302_resource.c    |    2 +
 .../drm/amd/display/dc/dcn303/dcn303_resource.c    |    2 +
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c |    4 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |    2 +
 .../gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c   |    2 +-
 .../drm/amd/display/dc/dcn314/dcn314_resource.c    |    2 +
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c |    2 +-
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |    7 +-
 .../amd/display/dc/dcn32/dcn32_resource_helpers.c  |   10 +-
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |    2 +-
 .../gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c   |    2 +
 .../drm/amd/display/dc/inc/hw/clk_mgr_internal.h   |    2 +-
 .../amd/display/dc/link/accessories/link_dp_cts.c  |    5 +-
 .../drm/amd/display/dc/link/hwss/link_hwss_dio.c   |    5 +-
 .../drm/amd/display/dc/link/hwss/link_hwss_dpia.c  |    2 +
 .../gpu/drm/amd/display/dc/link/link_detection.c   |    3 +
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |   13 +-
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |    3 +
 .../drm/amd/display/dc/link/protocols/link_ddc.c   |    2 +
 .../display/dc/link/protocols/link_dp_capability.c |    2 +-
 .../dc/link/protocols/link_dp_irq_handler.c        |    2 +
 .../display/dc/link/protocols/link_dp_training.c   |    3 +-
 .../drm/amd/display/dc/link/protocols/link_dpcd.c  |    3 +-
 .../dc/link/protocols/link_edp_panel_control.c     |    3 +
 drivers/gpu/drm/amd/display/dc/os_types.h          |    1 +
 drivers/gpu/drm/amd/display/include/logger_types.h |  142 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |    2 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   39 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c  |   11 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |    4 -
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |    2 -
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    2 -
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |    9 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |    2 -
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c            |    5 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |    4 +-
 drivers/gpu/drm/drm_debugfs.c                      |   16 +-
 drivers/gpu/drm/drm_fb_helper.c                    |    6 +-
 drivers/gpu/drm/{drm_gpuva_mgr.c => drm_gpuvm.c}   |  404 +--
 drivers/gpu/drm/drm_syncobj.c                      |    6 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   13 +-
 drivers/gpu/drm/gud/gud_drv.c                      |    2 +
 drivers/gpu/drm/gud/gud_pipe.c                     |    1 +
 drivers/gpu/drm/i915/display/icl_dsi.c             |    4 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |   36 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |    8 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   14 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |    2 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   19 +-
 drivers/gpu/drm/i915/gt/intel_rps.c                |    3 +-
 drivers/gpu/drm/i915/gvt/interrupt.c               |    2 +-
 drivers/gpu/drm/lima/lima_sched.c                  |   13 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   17 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    5 +-
 .../drm/msm/disp/dpu1/catalog/dpu_3_0_msm8998.h    |    4 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_4_0_sdm845.h |    4 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |    8 -
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |   10 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h |    3 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h |    8 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h |    3 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_3_sm6115.h |    1 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_4_sm6350.h |    3 -
 .../drm/msm/disp/dpu1/catalog/dpu_6_5_qcm2290.h    |    1 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_6_9_sm6375.h |    1 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h |    8 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h |    6 -
 .../drm/msm/disp/dpu1/catalog/dpu_8_0_sc8280xp.h   |   13 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h |   12 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_9_0_sm8550.h |   12 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_irq.h       |    6 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   10 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h   |    8 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |   32 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   33 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h     |   14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c  |   39 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.h  |    6 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   30 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |   22 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |    1 +
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |    4 +-
 drivers/gpu/drm/nouveau/nouveau_bo0039.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo5039.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   36 +-
 drivers/gpu/drm/nouveau/nouveau_chan.h             |    2 -
 drivers/gpu/drm/nouveau/nouveau_dma.c              |    2 +-
 drivers/gpu/drm/nouveau/nouveau_exec.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |   15 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    7 +-
 drivers/gpu/drm/nouveau/nouveau_sched.c            |   12 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   41 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.h             |    6 +-
 drivers/gpu/drm/nouveau/nv17_fence.c               |    6 +-
 drivers/gpu/drm/nouveau/nv50_fence.c               |    2 +-
 drivers/gpu/drm/nouveau/nv84_fence.c               |    8 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |   15 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |    6 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |    8 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |    4 +
 drivers/gpu/drm/scheduler/sched_main.c             |   34 +-
 drivers/gpu/drm/tiny/ofdrm.c                       |    8 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |   59 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |  108 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |    3 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |    5 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |    2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   10 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   20 +
 drivers/gpu/drm/virtio/virtgpu_object.c            |    2 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   26 +-
 drivers/hid/bpf/hid_bpf_dispatch.c                 |    5 +-
 drivers/hid/hid-alps.c                             |   25 +-
 drivers/hid/hid-core.c                             |   38 +-
 drivers/hid/hid-logitech-hidpp.c                   |   27 +-
 drivers/hid/hid-mcp2221.c                          |   17 +-
 drivers/hid/hid-multitouch.c                       |    2 +-
 drivers/hid/hid-nintendo.c                         |   38 +-
 drivers/hid/hid-sony.c                             |   37 +-
 drivers/hid/hid-steam.c                            |  269 +-
 drivers/hid/hid-universal-pidff.c                  |    4 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |    7 +-
 drivers/hid/intel-ish-hid/ishtp/bus.c              |    2 +
 drivers/hid/intel-ish-hid/ishtp/client.c           |    4 +-
 drivers/hid/uhid.c                                 |    8 +-
 drivers/hid/usbhid/hid-core.c                      |   11 +-
 drivers/hv/vmbus_drv.c                             |   58 +-
 drivers/hwmon/lm90.c                               |   26 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   80 +-
 drivers/hwmon/pwm-fan.c                            |   13 +-
 drivers/hwmon/sht3x.c                              |    9 +-
 .../hwtracing/coresight/coresight-etm3x-sysfs.c    |   15 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   89 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |    2 +
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |   16 +
 drivers/i2c/busses/i2c-at91-master.c               |    8 +-
 drivers/i2c/busses/i2c-mxs.c                       |    5 +-
 drivers/i2c/busses/i2c-xiic.c                      |   98 +-
 drivers/i3c/master.c                               |   59 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |    3 +
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   27 +-
 drivers/i3c/master/mipi-i3c-hci/hci.h              |    1 +
 drivers/iio/accel/kionix-kx022a.c                  |    2 +-
 drivers/iio/accel/kxcjk-1013.c                     |    2 +-
 drivers/iio/accel/sca3000.c                        |    2 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   26 +-
 drivers/iio/adc/aspeed_adc.c                       |   13 +-
 drivers/iio/adc/axp288_adc.c                       |    8 +
 drivers/iio/adc/max1363.c                          |    8 +
 drivers/iio/adc/stm32-adc.c                        |   47 +-
 drivers/iio/adc/sun4i-gpadc-iio.c                  |   10 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |    9 +-
 drivers/iio/cdc/ad7150.c                           |    8 +-
 drivers/iio/frequency/admv1013.c                   |  128 +-
 drivers/iio/gyro/adis16136.c                       |    2 +-
 drivers/iio/health/max30102.c                      |   12 +-
 drivers/iio/imu/adis16400.c                        |    2 +-
 drivers/iio/imu/adis16480.c                        |    4 +-
 drivers/iio/industrialio-buffer.c                  |    7 +-
 drivers/iio/industrialio-trigger.c                 |    2 +
 drivers/iio/light/Kconfig                          |   14 -
 drivers/iio/light/Makefile                         |    1 -
 drivers/iio/light/gp2ap020a00f.c                   |    2 +
 drivers/iio/light/ltrf216a.c                       |   13 +-
 drivers/iio/light/rohm-bu27034.c                   | 1528 ----------
 drivers/iio/pressure/bmp280-core.c                 |    2 +-
 drivers/iio/proximity/isl29501.c                   |    2 +-
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |    4 +-
 drivers/iio/proximity/sx9324.c                     |    2 +-
 drivers/iio/proximity/vcnl3020.c                   |   24 +-
 drivers/infiniband/core/counters.c                 |    9 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   38 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |    1 +
 drivers/infiniband/hw/cxgb4/mem.c                  |   46 +-
 drivers/infiniband/hw/efa/efa_com.c                |   28 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |    6 +-
 drivers/infiniband/hw/erdma/erdma_eq.c             |    3 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   23 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |   15 +
 drivers/infiniband/hw/hns/hns_roce_cq.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   43 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |    5 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |    6 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |    2 +-
 drivers/infiniband/hw/irdma/hw.c                   |    7 +-
 drivers/infiniband/hw/irdma/main.h                 |    3 +-
 drivers/infiniband/hw/irdma/utils.c                |   12 +-
 drivers/infiniband/hw/irdma/verbs.c                |   21 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   11 +-
 drivers/infiniband/hw/mlx5/devx.c                  |    2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   75 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    2 +
 drivers/infiniband/hw/mlx5/mr.c                    |    2 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   15 +-
 drivers/infiniband/hw/mlx5/umr.c                   |   87 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |    8 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |    4 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   20 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c        |    2 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.h        |    2 +-
 drivers/infiniband/sw/rxe/rxe_loc.h                |    3 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  285 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |    4 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   58 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   25 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |    6 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   11 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   16 +-
 drivers/infiniband/sw/siw/siw.h                    |    7 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   75 +-
 drivers/infiniband/sw/siw/siw_main.c               |   15 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |   35 +-
 drivers/input/joystick/xpad.c                      |    3 +
 drivers/input/keyboard/atkbd.c                     |    8 +
 drivers/input/keyboard/lkkbd.c                     |    2 +
 drivers/input/mouse/alps.c                         |    2 +
 drivers/input/mouse/synaptics.c                    |    7 +-
 drivers/input/serio/i8042-acpipnpio.h              |    9 +
 drivers/input/touchscreen/s6sy761.c                |   14 +-
 drivers/iommu/amd/init.c                           |    5 +
 drivers/iommu/amd/iommu.c                          |    7 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   65 +-
 drivers/iommu/intel/iommu.c                        |   37 +-
 drivers/iommu/intel/pasid.c                        |   20 +-
 drivers/iommu/iommu-sva.c                          |    3 +-
 drivers/iommu/iommu.c                              |    9 +-
 drivers/iommu/msm_iommu.c                          |    9 +-
 drivers/iommu/s390-iommu.c                         |   23 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |  135 +-
 drivers/md/dm-cache-target.c                       |    4 +-
 drivers/md/dm-clone-target.c                       |    4 +-
 drivers/md/dm-crypt.c                              |    7 +-
 drivers/md/dm-ebs-target.c                         |    2 +-
 drivers/md/dm-era-target.c                         |    4 +-
 drivers/md/dm-integrity.c                          |    2 +-
 drivers/md/dm-ioctl.c                              |   14 +-
 drivers/md/dm-raid.c                               |    4 +-
 drivers/md/dm-snap.c                               |   14 +
 drivers/md/dm-stripe.c                             |   11 +-
 drivers/md/dm-thin.c                               |    6 +-
 drivers/md/dm-verity-fec.c                         |  101 +-
 drivers/md/dm-verity-target.c                      |   10 +-
 drivers/md/dm-zoned-target.c                       |    4 +-
 drivers/md/md.c                                    |  254 +-
 drivers/md/md.h                                    |   43 +-
 drivers/md/persistent-data/dm-array.c              |   37 +-
 drivers/md/raid1.c                                 |   27 +-
 drivers/md/raid10.c                                |  100 +-
 drivers/md/raid5.c                                 |   10 +-
 .../media/platform/mediatek/mdp3/mtk-mdp3-core.c   |    5 +
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |  156 +-
 drivers/media/platform/verisilicon/hantro.h        |    2 +
 drivers/media/platform/verisilicon/hantro_drv.c    |   89 +-
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c  |    8 +
 drivers/media/test-drivers/vivid/vivid-core.c      |    4 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   23 +
 drivers/memstick/core/memstick.c                   |    8 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   31 +-
 drivers/mfd/sm501.c                                |    8 +-
 drivers/misc/ocxl/file.c                           |    2 +-
 drivers/misc/sgi-gru/grufault.c                    |  101 +-
 drivers/misc/sgi-gru/gruprocfs.c                   |    1 -
 drivers/misc/sgi-gru/grutables.h                   |    1 -
 drivers/mmc/host/cavium-octeon.c                   |    5 +-
 drivers/mmc/host/cavium-thunderx.c                 |    5 +-
 drivers/mmc/host/mtk-sd.c                          |    1 +
 drivers/mmc/host/sdhci-sprd.c                      |    4 +
 drivers/mmc/host/via-sdmmc.c                       |    4 +
 drivers/mmc/host/vub300.c                          |   11 +-
 drivers/most/core.c                                |   15 +-
 drivers/mtd/devices/block2mtd.c                    |   53 +-
 drivers/mtd/maps/vmu-flash.c                       |   10 +-
 drivers/mtd/mtdcore.c                              |    2 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |    6 +-
 drivers/mtd/nand/raw/vf610_nfc.c                   |   85 +-
 drivers/mtd/nand/spi/core.c                        |   37 +-
 drivers/net/amt.c                                  |   51 +-
 drivers/net/can/dev/skb.c                          |    2 +
 drivers/net/can/usb/f81604.c                       |    2 +-
 drivers/net/dsa/b53/b53_common.c                   |    8 +-
 drivers/net/dsa/microchip/ksz_common.h             |    2 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |   25 +-
 drivers/net/ethernet/amazon/ena/ena_com.h          |   14 -
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   37 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    3 +
 drivers/net/ethernet/amazon/ena/ena_regs_defs.h    |    1 +
 drivers/net/ethernet/amd/pds_core/core.c           |  102 +-
 drivers/net/ethernet/amd/pds_core/core.h           |    1 +
 drivers/net/ethernet/amd/pds_core/debugfs.c        |    3 +-
 drivers/net/ethernet/amd/pds_core/dev.c            |   16 +
 drivers/net/ethernet/amd/pds_core/main.c           |    5 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        |   21 -
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |    2 -
 drivers/net/ethernet/broadcom/bcmsysport.c         |    8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  138 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   26 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   31 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    5 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   16 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   27 -
 .../net/ethernet/cavium/liquidio/octeon_device.h   |    3 -
 .../net/ethernet/cavium/liquidio/octeon_mailbox.c  |   33 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |    4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   38 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   11 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |    4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_regs.c    |    9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_regs.c  |    9 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   22 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    2 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |   31 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |    2 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |    9 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |    2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |  109 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |    8 +
 drivers/net/ethernet/intel/ice/ice_trace.h         |   64 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   86 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    1 -
 drivers/net/ethernet/intel/igb/igb_main.c          |    2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    5 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   12 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |    4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   79 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   22 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   67 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   20 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   40 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c         |   17 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   16 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |    2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   56 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   55 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    9 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   34 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    1 +
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   17 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |    4 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   30 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |    2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |    9 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |    6 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |    1 +
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |    1 +
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |    1 +
 drivers/net/ethernet/microchip/vcap/vcap_api.c     |    2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   17 +-
 drivers/net/ethernet/mscc/ocelot_stats.c           |    2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |  467 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    3 +-
 drivers/net/ethernet/realtek/r8169_main.c          |    4 -
 drivers/net/ethernet/renesas/ravb_main.c           |    8 +-
 drivers/net/ethernet/renesas/ravb_ptp.c            |   37 +-
 drivers/net/ethernet/sfc/ef10.c                    |    4 +-
 drivers/net/ethernet/sfc/ef100_netdev.c            |    7 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |   47 +-
 drivers/net/ethernet/sfc/efx.c                     |   48 +-
 drivers/net/ethernet/sfc/mcdi_port.c               |   59 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c        |   11 -
 drivers/net/ethernet/sfc/net_driver.h              |    8 +-
 drivers/net/ethernet/sfc/ptp.c                     |   30 +-
 drivers/net/ethernet/sfc/ptp.h                     |    7 +-
 drivers/net/ethernet/sfc/siena/tx_common.c         |    5 +-
 drivers/net/ethernet/sfc/tx_common.c               |    5 +-
 drivers/net/ethernet/sfc/tx_tso.c                  |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   51 +-
 drivers/net/ethernet/sun/sunvnet_common.c          |    4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |    4 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |    2 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |    2 +-
 drivers/net/ieee802154/cc2520.c                    |   10 +-
 drivers/net/netconsole.c                           |    3 +-
 drivers/net/phy/sfp.c                              |   16 +
 drivers/net/tap.c                                  |   55 +-
 drivers/net/team/team_core.c                       |  102 +-
 drivers/net/team/team_mode_loadbalance.c           |    4 +-
 drivers/net/usb/ax88179_178a.c                     |    6 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/veth.c                                 |    1 +
 drivers/net/vxlan/vxlan_core.c                     |   40 +-
 drivers/net/vxlan/vxlan_private.h                  |    4 +-
 drivers/net/wireguard/noise.c                      |    7 +-
 drivers/net/wireguard/queueing.h                   |    2 +
 drivers/net/wireguard/receive.c                    |    2 +-
 drivers/net/wireless/ath/ath11k/core.c             |   18 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |    6 +-
 drivers/net/wireless/ath/ath11k/dp.c               |   12 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   22 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    6 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    4 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   44 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    8 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    7 +
 drivers/net/wireless/ath/ath11k/reg.c              |   92 +-
 drivers/net/wireless/ath/ath11k/reg.h              |    6 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   15 +-
 drivers/net/wireless/ath/ath12k/dp.c               |    6 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   13 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  237 +-
 drivers/net/wireless/ath/ath12k/dp_mon.h           |    4 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  216 +-
 drivers/net/wireless/ath/ath12k/dp_rx.h            |    8 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   10 +-
 drivers/net/wireless/ath/ath12k/hal_rx.c           |   10 +-
 drivers/net/wireless/ath/ath12k/hal_rx.h           |   12 +-
 drivers/net/wireless/ath/ath12k/hw.c               |    6 +
 drivers/net/wireless/ath/ath12k/hw.h               |    2 +
 drivers/net/wireless/ath/ath12k/mhi.c              |    4 -
 drivers/net/wireless/ath/ath12k/pci.c              |    6 +-
 drivers/net/wireless/ath/ath12k/pci.h              |    4 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |   12 +-
 drivers/net/wireless/ath/ath12k/qmi.h              |    3 +
 drivers/net/wireless/ath/ath12k/wmi.c              |   25 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   27 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    4 +
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    1 +
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   47 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   12 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   26 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   46 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    9 +-
 drivers/net/wireless/marvell/libertas/tx.c         |    7 -
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   37 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |    1 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   16 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    5 +
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   33 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    3 +
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    2 +
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.c   |  134 +-
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.h   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |    3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    1 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   19 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |  303 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    2 +
 drivers/net/wireless/realtek/rtw88/main.c          |   20 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    3 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    9 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    7 +-
 drivers/net/wireless/silabs/wfx/hif_tx.c           |    4 +-
 drivers/net/wireless/st/cw1200/bh.c                |    8 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   14 +
 drivers/net/wireless/ti/wl12xx/main.c              |    6 +-
 drivers/net/wireless/ti/wl18xx/main.c              |    2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   10 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |    2 +-
 drivers/net/xen-netfront.c                         |   16 +-
 drivers/ntb/ntb_transport.c                        |   25 +-
 drivers/nvdimm/nd_virtio.c                         |   32 +-
 drivers/nvdimm/pmem.c                              |   12 +-
 drivers/nvdimm/virtio_pmem.h                       |    2 +
 drivers/nvme/host/core.c                           |   61 +-
 drivers/nvme/host/fabrics.c                        |    2 +
 drivers/nvme/host/multipath.c                      |    5 +-
 drivers/nvme/host/pci.c                            |    2 +
 drivers/nvme/host/tcp.c                            |   54 +-
 drivers/nvme/target/admin-cmd.c                    |   31 +-
 drivers/nvme/target/configfs.c                     |    9 +-
 drivers/nvme/target/core.c                         |   94 +-
 drivers/nvme/target/discovery.c                    |   37 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |   40 +-
 drivers/nvme/target/fabrics-cmd.c                  |   45 +-
 drivers/nvme/target/nvmet.h                        |   15 +
 drivers/nvme/target/rdma.c                         |    1 +
 drivers/nvme/target/tcp.c                          |   46 +-
 drivers/nvmem/Kconfig                              |    1 +
 drivers/nvmem/Makefile                             |    2 +
 drivers/nvmem/core.c                               |  176 +-
 drivers/nvmem/internals.h                          |   21 +
 drivers/nvmem/layouts.c                            |  201 ++
 drivers/nvmem/layouts/Kconfig                      |    8 +
 drivers/nvmem/layouts/onie-tlv.c                   |   24 +-
 drivers/nvmem/layouts/sl28vpd.c                    |   24 +-
 drivers/of/device.c                                |   41 +
 drivers/of/irq.c                                   |    2 +
 drivers/of/overlay.c                               |   17 +-
 drivers/of/platform.c                              |   40 -
 drivers/of/unittest.c                              |    7 +-
 drivers/opp/core.c                                 |    5 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   57 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   24 +
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |    5 +
 drivers/pci/endpoint/functions/pci-epf-test.c      |   16 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |    5 +
 drivers/pci/hotplug/pnv_php.c                      |    2 +-
 drivers/pci/hotplug/rpaphp_slot.c                  |    2 +-
 drivers/pci/pci-driver.c                           |  194 +-
 drivers/pci/pci-sysfs.c                            |  153 +-
 drivers/pci/pci.c                                  |   20 +-
 drivers/pci/pci.h                                  |   41 +-
 drivers/pci/probe.c                                |    1 -
 drivers/pci/rebar.c                                |   19 +-
 drivers/pci/search.c                               |    8 +-
 drivers/pci/setup-bus.c                            |   56 +-
 drivers/pci/slot.c                                 |   47 +-
 drivers/perf/riscv_pmu_legacy.c                    |    5 +-
 drivers/perf/riscv_pmu_sbi.c                       |   67 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c           |    6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   14 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |    7 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   88 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.h              |    7 +
 drivers/platform/x86/amd/pmc/pmc.c                 |   40 +-
 drivers/platform/x86/asus-wmi.c                    |   52 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |    2 +-
 drivers/platform/x86/intel/int1092/intel_sar.c     |   39 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   17 +-
 drivers/platform/x86/lg-laptop.c                   |   28 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |   15 +
 drivers/pmdomain/rockchip/pm-domains.c             |   20 +-
 drivers/power/supply/charger-manager.c             |   60 +-
 drivers/power/supply/lp8788-charger.c              |   29 +-
 drivers/power/supply/max17040_battery.c            |   27 +-
 drivers/power/supply/qcom_battmgr.c                |    8 +-
 drivers/ptp/ptp_chardev.c                          |   12 +-
 drivers/ptp/ptp_clock.c                            |   26 +-
 drivers/ptp/ptp_ocp.c                              |    3 +-
 drivers/ptp/ptp_private.h                          |    5 +-
 drivers/ptp/ptp_sysfs.c                            |    8 +-
 drivers/pwm/pwm-samsung.c                          |   22 +-
 drivers/regulator/ltc3676.c                        |   15 +-
 drivers/regulator/tps6594-regulator.c              |    6 +-
 drivers/remoteproc/qcom_wcnss.c                    |   23 +-
 drivers/rtc/dev.c                                  |    2 +-
 drivers/rtc/rtc-ac100.c                            |    3 +-
 drivers/rtc/rtc-mpfs.c                             |    6 +-
 drivers/rtc/rtc-rzn1.c                             |   16 +-
 drivers/rtc/rtc-spear.c                            |   11 +-
 drivers/s390/cio/vfio_ccw_chp.c                    |    2 +-
 drivers/s390/cio/vfio_ccw_drv.c                    |    4 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |    6 +-
 drivers/s390/crypto/pkey_api.c                     |  128 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |   28 +-
 drivers/s390/crypto/zcrypt_api.c                   |    3 +
 drivers/s390/crypto/zcrypt_ccamisc.c               |   64 +-
 drivers/s390/crypto/zcrypt_ccamisc.h               |    6 +-
 drivers/s390/net/ism_drv.c                         |   20 +-
 drivers/scsi/ch.c                                  |   30 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   12 +-
 drivers/scsi/hosts.c                               |    2 +
 drivers/scsi/imm.c                                 |    1 +
 drivers/scsi/lpfc/lpfc.h                           |   77 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  105 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    8 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |  147 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   12 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  391 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  314 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   66 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |    8 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   68 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   34 +-
 drivers/scsi/lpfc/lpfc_sli.h                       |    1 +
 drivers/scsi/lpfc/lpfc_vport.c                     |   46 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   21 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |    7 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  169 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   63 +-
 drivers/scsi/qedi/qedi_main.c                      |    3 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   47 +-
 drivers/scsi/qla2xxx/qla_def.h                     |    2 +
 drivers/scsi/qla2xxx/qla_init.c                    |    1 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   25 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   33 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |    6 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   41 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   10 +
 drivers/scsi/qla2xxx/qla_os.c                      |   35 +-
 drivers/scsi/qla2xxx/qla_target.c                  |    5 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    1 +
 drivers/scsi/scsi_error.c                          |   28 +-
 drivers/scsi/scsi_priv.h                           |    1 +
 drivers/scsi/sd.c                                  |   37 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   31 +-
 drivers/soc/xilinx/zynqmp_power.c                  |   10 +-
 drivers/soundwire/generic_bandwidth_allocation.c   |   36 +-
 drivers/spi/spi-dw-dma.c                           |    2 +-
 drivers/spi/spi-microchip-core-qspi.c              |   79 +-
 drivers/spi/spi-mpc52xx.c                          |   60 +-
 drivers/spi/spi-oc-tiny.c                          |   24 +-
 drivers/spi/spi-tegra210-quad.c                    |   20 +
 drivers/spi/spi.c                                  |   19 +-
 drivers/staging/greybus/raw.c                      |   90 +-
 drivers/staging/greybus/uart.c                     |    3 +-
 drivers/staging/media/atomisp/i2c/atomisp-gc2235.c |   29 +-
 drivers/staging/media/av7110/av7110.h              |    4 +-
 drivers/staging/media/av7110/av7110_ca.c           |   26 +-
 drivers/staging/media/rkvdec/rkvdec.c              |    4 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |  247 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   22 +-
 drivers/staging/sm750fb/sm750.c                    |    2 +-
 drivers/staging/sm750fb/sm750.h                    |    2 +-
 drivers/staging/sm750fb/sm750_accel.c              |    6 +-
 drivers/staging/sm750fb/sm750_accel.h              |    4 +-
 drivers/tee/optee/ffa_abi.c                        |   16 +-
 drivers/tee/optee/smc_abi.c                        |   17 +-
 drivers/thermal/thermal_hwmon.c                    |   89 +-
 drivers/thunderbolt/ctl.c                          |   63 +-
 drivers/thunderbolt/quirks.c                       |    3 +
 drivers/thunderbolt/xdomain.c                      |    4 +
 drivers/tty/amiserial.c                            |    9 +-
 drivers/tty/n_gsm.c                                |   47 +-
 drivers/tty/serial/8250/8250_bcm7271.c             |    2 +-
 drivers/tty/serial/8250/8250_core.c                |  253 +-
 drivers/tty/serial/8250/8250_of.c                  |   43 +
 drivers/tty/serial/imx.c                           |   26 +-
 drivers/tty/serial/ip22zilog.c                     |  388 +--
 drivers/tty/serial/kgdboc.c                        |    9 +
 drivers/tty/serial/ma35d1_serial.c                 |   11 +-
 drivers/tty/serial/max3100.c                       |   13 +-
 drivers/tty/serial/qcom_geni_serial.c              |    5 +-
 drivers/tty/serial/sc16is7xx.c                     |   37 +-
 drivers/tty/serial/serial-tegra.c                  |   18 +-
 drivers/tty/serial/serial_core.c                   |   48 +-
 drivers/tty/serial/vt8500_serial.c                 |    1 +
 drivers/tty/tty_io.c                               |   56 +-
 drivers/tty/tty_port.c                             |   75 +-
 drivers/tty/vcc.c                                  |    5 +-
 drivers/tty/vt/vc_screen.c                         |   25 +-
 drivers/tty/vt/vt.c                                |    5 +-
 drivers/ufs/core/ufs-mcq.c                         |   39 +-
 drivers/ufs/core/ufshcd-priv.h                     |   14 +-
 drivers/ufs/core/ufshcd.c                          |   73 +-
 drivers/ufs/host/ufs-exynos.c                      |   17 +-
 drivers/ufs/host/ufs-exynos.h                      |    3 +-
 drivers/ufs/host/ufs-qcom.c                        |   69 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |    4 +
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |    5 +
 drivers/usb/chipidea/ci_hdrc_tegra.c               |    4 +-
 drivers/usb/chipidea/udc.c                         |    4 +
 drivers/usb/class/cdc-acm.c                        |   41 +-
 drivers/usb/class/cdc-acm.h                        |    1 -
 drivers/usb/core/hub.c                             |    7 +-
 drivers/usb/core/message.c                         |    8 +-
 drivers/usb/dwc2/hcd.c                             |    3 +-
 drivers/usb/dwc3/core.h                            |   22 +-
 drivers/usb/dwc3/dwc3-am62.c                       |    1 +
 drivers/usb/dwc3/ep0.c                             |   11 +-
 drivers/usb/dwc3/gadget.c                          |  236 +-
 drivers/usb/gadget/function/f_ecm.c                |   35 +-
 drivers/usb/gadget/function/f_eem.c                |   59 +-
 drivers/usb/gadget/function/f_fs.c                 |  176 +-
 drivers/usb/gadget/function/f_hid.c                |   17 +-
 drivers/usb/gadget/function/f_mass_storage.c       |    3 +
 drivers/usb/gadget/function/f_midi.c               |    6 +-
 drivers/usb/gadget/function/f_midi2.c              |    4 +-
 drivers/usb/gadget/function/f_rndis.c              |   42 +-
 drivers/usb/gadget/function/f_subset.c             |   57 +-
 drivers/usb/gadget/function/f_uac1.c               |   13 +-
 drivers/usb/gadget/function/f_uac1_legacy.c        |    6 +
 drivers/usb/gadget/function/f_uac2.c               |   13 +-
 drivers/usb/gadget/function/u_ecm.h                |   21 +-
 drivers/usb/gadget/function/u_eem.h                |   21 +-
 drivers/usb/gadget/function/u_gether.h             |   22 +-
 drivers/usb/gadget/function/u_rndis.h              |   31 +-
 drivers/usb/gadget/legacy/inode.c                  |    7 +-
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |    4 +
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |    2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |    5 +-
 drivers/usb/gadget/udc/aspeed-vhub/vhub.h          |    1 +
 drivers/usb/gadget/udc/at91_udc.c                  |   33 +-
 drivers/usb/gadget/udc/core.c                      |    7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |    4 +
 drivers/usb/host/octeon-hcd.c                      |    2 +-
 drivers/usb/host/ohci-da8xx.c                      |    2 +
 drivers/usb/host/ohci-s3c2410.c                    |    1 +
 drivers/usb/host/ohci-spear.c                      |    4 +-
 drivers/usb/host/ohci-st.c                         |    1 +
 drivers/usb/misc/iowarrior.c                       |   57 +-
 drivers/usb/phy/phy-fsl-usb.c                      |    1 +
 drivers/usb/serial/bus.c                           |    6 +-
 drivers/usb/serial/cp210x.c                        |    1 +
 drivers/usb/serial/generic.c                       |   10 +-
 drivers/usb/serial/option.c                        |   14 +
 drivers/usb/serial/quatech2.c                      |   19 +-
 drivers/usb/serial/ssu100.c                        |   18 +-
 drivers/usb/serial/usb-serial.c                    |  127 +-
 drivers/usb/serial/xr_serial.c                     |   10 +-
 drivers/usb/storage/realtek_cr.c                   |    9 +-
 drivers/usb/storage/sierra_ms.c                    |    7 +
 drivers/usb/typec/anx7411.c                        |    5 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   53 +-
 drivers/usb/typec/tipd/core.c                      |    3 +-
 drivers/usb/typec/ucsi/displayport.c               |    9 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   17 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |   32 +
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |    2 +
 drivers/vdpa/mlx5/core/resources.c                 |   11 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    9 +-
 drivers/vdpa/vdpa.c                                |   48 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   10 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |   11 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   10 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |    4 +-
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c             |    6 +-
 drivers/vfio/pci/mlx5/main.c                       |    6 +-
 drivers/vfio/pci/vfio_pci_core.c                   |   10 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   12 +-
 drivers/vfio/platform/vfio_platform_irq.c          |    2 +-
 drivers/vhost/iotlb.c                              |   47 +-
 drivers/vhost/net.c                                |    2 +
 drivers/vhost/vdpa.c                               |   45 +-
 drivers/vhost/vhost.c                              |  183 +-
 drivers/vhost/vhost.h                              |    3 +-
 drivers/vhost/vsock.c                              |    2 +
 drivers/video/fbdev/core/fb_chrdev.c               |    6 +-
 drivers/video/fbdev/core/fbcon.c                   |    2 -
 drivers/video/fbdev/core/fbmem.c                   |   13 +
 drivers/video/fbdev/core/fbsysfs.c                 |    4 +-
 drivers/video/fbdev/hyperv_fb.c                    |   29 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     |   11 +-
 drivers/video/fbdev/ps3fb.c                        |    5 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |    5 +-
 drivers/virt/acrn/ioeventfd.c                      |    2 +-
 drivers/virt/acrn/irqfd.c                          |   75 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c          |    1 +
 drivers/virtio/virtio.c                            |   50 +-
 drivers/virtio/virtio_mmio.c                       |   66 +-
 drivers/virtio/virtio_ring.c                       |   19 +-
 drivers/watchdog/at91sam9_wdt.c                    |    4 +-
 drivers/xen/balloon.c                              |   56 +-
 drivers/xen/gntdev-dmabuf.c                        |   31 +-
 drivers/xen/pvcalls-front.c                        |   88 +-
 drivers/xen/xen-pciback/pci_stub.c                 |    6 +-
 fs/9p/vfs_inode_dotl.c                             |   35 +-
 fs/Kconfig                                         |    1 -
 fs/Makefile                                        |    1 -
 fs/afs/inode.c                                     |    1 +
 fs/afs/internal.h                                  |    2 +
 fs/afs/rxrpc.c                                     |   81 +-
 fs/afs/super.c                                     |    2 +-
 fs/aio.c                                           |    2 +-
 fs/attr.c                                          |   12 +-
 fs/btrfs/acl.c                                     |    3 +
 fs/btrfs/bio.c                                     |    8 +-
 fs/btrfs/block-group.c                             |  172 +-
 fs/btrfs/block-rsv.c                               |   19 +-
 fs/btrfs/defrag.c                                  |   50 +-
 fs/btrfs/delayed-inode.c                           |   20 +-
 fs/btrfs/delayed-ref.c                             |  135 +-
 fs/btrfs/delayed-ref.h                             |   17 +-
 fs/btrfs/dev-replace.c                             |    1 +
 fs/btrfs/disk-io.c                                 |    8 +-
 fs/btrfs/extent-tree.c                             |   92 +-
 fs/btrfs/extent-tree.h                             |    4 +-
 fs/btrfs/file.c                                    |  126 +-
 fs/btrfs/fs.h                                      |   15 +
 fs/btrfs/inode.c                                   |  229 +-
 fs/btrfs/ioctl.c                                   |   12 +-
 fs/btrfs/lzo.c                                     |   13 +-
 fs/btrfs/qgroup.c                                  |   18 +-
 fs/btrfs/reflink.c                                 |   66 +-
 fs/btrfs/relocation.c                              |   87 +-
 fs/btrfs/scrub.c                                   |    4 +-
 fs/btrfs/space-info.c                              |   17 +-
 fs/btrfs/subpage.h                                 |   13 +
 fs/btrfs/transaction.c                             |   34 +-
 fs/btrfs/transaction.h                             |    1 +
 fs/btrfs/tree-log.c                                |  142 +-
 fs/btrfs/volumes.c                                 |  241 +-
 fs/btrfs/xattr.c                                   |    9 +
 fs/btrfs/zoned.c                                   |    6 +-
 fs/btrfs/zstd.c                                    |   11 +-
 fs/ceph/addr.c                                     |    4 +
 fs/ceph/crypto.c                                   |   46 +-
 fs/ceph/debugfs.c                                  |   14 +-
 fs/ceph/dir.c                                      |   20 +-
 fs/ceph/file.c                                     |   10 +-
 fs/ceph/mds_client.c                               |  252 +-
 fs/ceph/mds_client.h                               |   19 +-
 fs/ceph/super.h                                    |    9 +
 fs/configfs/dir.c                                  |   13 +-
 fs/configfs/symlink.c                              |   51 +-
 fs/dcache.c                                        |   12 +-
 fs/dlm/lock.c                                      |    2 +
 fs/erofs/decompressor.c                            |   55 +-
 fs/erofs/decompressor_lzma.c                       |   18 +-
 fs/erofs/internal.h                                |    6 +-
 fs/erofs/sysfs.c                                   |    2 +
 fs/erofs/xattr.c                                   |    1 +
 fs/erofs/zdata.c                                   |   31 +-
 fs/erofs/zmap.c                                    |   54 +-
 fs/eventfd.c                                       |   11 +-
 fs/exfat/exfat_fs.h                                |    1 +
 fs/exfat/file.c                                    |    7 +-
 fs/exfat/inode.c                                   |   31 +-
 fs/exfat/misc.c                                    |    8 +
 fs/exfat/namei.c                                   |   44 +-
 fs/exfat/nls.c                                     |   24 +-
 fs/exfat/super.c                                   |    4 +-
 fs/ext2/inode.c                                    |    3 +-
 fs/ext2/xattr.c                                    |    4 +-
 fs/ext4/ext4.h                                     |    6 +-
 fs/ext4/ext4_jbd2.h                                |   29 +
 fs/ext4/inode.c                                    |   36 +-
 fs/ext4/ioctl.c                                    |    5 +
 fs/ext4/super.c                                    |   34 +-
 fs/ext4/xattr.c                                    |    2 +-
 fs/f2fs/checkpoint.c                               |    2 +-
 fs/f2fs/compress.c                                 |    1 +
 fs/f2fs/data.c                                     |   37 +-
 fs/f2fs/debug.c                                    |    4 -
 fs/f2fs/dir.c                                      |    1 +
 fs/f2fs/f2fs.h                                     |   30 +-
 fs/f2fs/file.c                                     |   20 +-
 fs/f2fs/gc.c                                       |   88 +-
 fs/f2fs/gc.h                                       |   20 -
 fs/f2fs/node.c                                     |   50 +-
 fs/f2fs/recovery.c                                 |   33 +-
 fs/f2fs/segment.c                                  |   23 +-
 fs/f2fs/super.c                                    |    6 +-
 fs/f2fs/sysfs.c                                    |   33 +-
 fs/fcntl.c                                         |    3 +
 fs/fsopen.c                                        |    3 +
 fs/fuse/file.c                                     |   77 +-
 fs/fuse/fuse_i.h                                   |    7 +
 fs/fuse/virtio_fs.c                                |    1 +
 fs/gfs2/inode.c                                    |   15 +
 fs/gfs2/inode.h                                    |    1 +
 fs/gfs2/ops_fstype.c                               |    4 +-
 fs/gfs2/quota.c                                    |    7 +-
 fs/gfs2/super.c                                    |    4 +-
 fs/inode.c                                         |   27 +-
 fs/jbd2/checkpoint.c                               |   44 +-
 fs/jbd2/commit.c                                   |    2 +-
 fs/jfs/jfs_dtree.c                                 |   18 +-
 fs/kernfs/mount.c                                  |    8 +-
 fs/libfs.c                                         |   50 +-
 fs/lockd/clnt4xdr.c                                |   14 +-
 fs/lockd/clntlock.c                                |    2 +-
 fs/lockd/clntproc.c                                |   64 +-
 fs/lockd/clntxdr.c                                 |   14 +-
 fs/lockd/svc.c                                     |    4 +-
 fs/lockd/svc4proc.c                                |   12 +-
 fs/lockd/svclock.c                                 |   66 +-
 fs/lockd/svcproc.c                                 |   12 +-
 fs/lockd/svcsubs.c                                 |   60 +-
 fs/lockd/xdr.c                                     |   14 +-
 fs/lockd/xdr4.c                                    |   14 +-
 fs/locks.c                                         |   18 +-
 fs/mbcache.c                                       |    1 +
 fs/namei.c                                         |   49 +-
 fs/namespace.c                                     |  123 +-
 fs/nfs/blocklayout/dev.c                           |   19 +-
 fs/nfs/callback_xdr.c                              |    6 +-
 fs/nfs/delegation.c                                |   18 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    3 +-
 fs/nfs/nfs42xattr.c                                |    8 +-
 fs/nfs/nfs4proc.c                                  |    4 +-
 fs/nfs/nfs4session.c                               |   16 +-
 fs/nfsd/auth.c                                     |   14 +-
 fs/nfsd/auth.h                                     |    2 +-
 fs/nfsd/export.h                                   |    3 +-
 fs/nfsd/filecache.c                                |   78 +-
 fs/nfsd/lockd.c                                    |    6 +-
 fs/nfsd/netns.h                                    |   24 +-
 fs/nfsd/nfs3proc.c                                 |   40 +
 fs/nfsd/nfs4layouts.c                              |   30 +-
 fs/nfsd/nfs4proc.c                                 |   38 +-
 fs/nfsd/nfs4recover.c                              |   12 +-
 fs/nfsd/nfs4state.c                                |  300 +-
 fs/nfsd/nfs4xdr.c                                  |   48 +-
 fs/nfsd/nfsctl.c                                   |    2 +-
 fs/nfsd/nfsfh.c                                    |    6 +-
 fs/nfsd/nfsproc.c                                  |    9 +-
 fs/nfsd/nfssvc.c                                   |   20 +-
 fs/nfsd/state.h                                    |   40 +-
 fs/nfsd/trace.h                                    |   35 +-
 fs/nfsd/vfs.c                                      |   45 +-
 fs/nfsd/vfs.h                                      |    4 +-
 fs/nfsd/xdr4.h                                     |  113 +-
 fs/nilfs2/page.c                                   |   35 +-
 fs/notify/mark.c                                   |   39 +-
 fs/ntfs/Kconfig                                    |   81 -
 fs/ntfs/Makefile                                   |   15 -
 fs/ntfs/aops.c                                     | 1761 -----------
 fs/ntfs/aops.h                                     |   88 -
 fs/ntfs/attrib.c                                   | 2624 ----------------
 fs/ntfs/attrib.h                                   |  102 -
 fs/ntfs/bitmap.c                                   |  179 --
 fs/ntfs/bitmap.h                                   |  104 -
 fs/ntfs/collate.c                                  |  110 -
 fs/ntfs/collate.h                                  |   36 -
 fs/ntfs/compress.c                                 |  950 ------
 fs/ntfs/debug.c                                    |  159 -
 fs/ntfs/debug.h                                    |   57 -
 fs/ntfs/dir.c                                      | 1539 ----------
 fs/ntfs/dir.h                                      |   34 -
 fs/ntfs/endian.h                                   |   79 -
 fs/ntfs/file.c                                     | 2004 ------------
 fs/ntfs/index.c                                    |  440 ---
 fs/ntfs/index.h                                    |  134 -
 fs/ntfs/inode.c                                    | 3101 -------------------
 fs/ntfs/inode.h                                    |  310 --
 fs/ntfs/layout.h                                   | 2421 ---------------
 fs/ntfs/lcnalloc.c                                 | 1000 ------
 fs/ntfs/lcnalloc.h                                 |  131 -
 fs/ntfs/logfile.c                                  |  849 ------
 fs/ntfs/logfile.h                                  |  295 --
 fs/ntfs/malloc.h                                   |   77 -
 fs/ntfs/mft.c                                      | 2907 ------------------
 fs/ntfs/mft.h                                      |  110 -
 fs/ntfs/mst.c                                      |  189 --
 fs/ntfs/namei.c                                    |  391 ---
 fs/ntfs/ntfs.h                                     |  150 -
 fs/ntfs/quota.c                                    |  103 -
 fs/ntfs/quota.h                                    |   21 -
 fs/ntfs/runlist.c                                  | 1893 ------------
 fs/ntfs/runlist.h                                  |   88 -
 fs/ntfs/super.c                                    | 3202 --------------------
 fs/ntfs/sysctl.c                                   |   59 -
 fs/ntfs/sysctl.h                                   |   27 -
 fs/ntfs/time.h                                     |   89 -
 fs/ntfs/types.h                                    |   55 -
 fs/ntfs/unistr.c                                   |  384 ---
 fs/ntfs/upcase.c                                   |   73 -
 fs/ntfs/usnjrnl.c                                  |   70 -
 fs/ntfs/usnjrnl.h                                  |  191 --
 fs/ntfs/volume.h                                   |  164 -
 fs/ntfs3/bitmap.c                                  |   62 +-
 fs/ntfs3/file.c                                    |  147 +-
 fs/ntfs3/frecord.c                                 |    1 -
 fs/ntfs3/fsntfs.c                                  |    2 +-
 fs/ntfs3/run.c                                     |   19 +-
 fs/ocfs2/cluster/heartbeat.c                       |  168 +-
 fs/ocfs2/cluster/nodemanager.c                     |   19 +-
 fs/ocfs2/cluster/nodemanager.h                     |    2 +
 fs/ocfs2/cluster/tcp.c                             |  105 +-
 fs/ocfs2/cluster/tcp.h                             |    1 +
 fs/ocfs2/dir.c                                     |   71 +-
 fs/ocfs2/inode.c                                   |  131 +
 fs/ocfs2/namei.c                                   |    8 +-
 fs/ocfs2/super.c                                   |    4 +-
 fs/ocfs2/xattr.c                                   |  215 ++
 fs/ocfs2/xattr.h                                   |    2 +
 fs/overlayfs/file.c                                |   19 +-
 fs/proc/task_mmu.c                                 |    9 +-
 fs/smb/client/cifsacl.c                            |   66 +-
 fs/smb/client/cifsencrypt.c                        |    1 -
 fs/smb/client/cifsfs.c                             |    1 +
 fs/smb/client/cifsglob.h                           |   11 +-
 fs/smb/client/cifssmb.c                            |    2 +-
 fs/smb/client/connect.c                            |    5 +
 fs/smb/client/dir.c                                |   39 +-
 fs/smb/client/file.c                               |   93 +-
 fs/smb/client/inode.c                              |   52 +-
 fs/smb/client/link.c                               |   17 +-
 fs/smb/client/misc.c                               |   72 +-
 fs/smb/client/readdir.c                            |   17 +-
 fs/smb/client/sess.c                               |  106 +-
 fs/smb/client/smb1ops.c                            |   23 +-
 fs/smb/client/smb2file.c                           |   19 +-
 fs/smb/client/smb2inode.c                          |    8 +-
 fs/smb/client/smb2misc.c                           |    9 +-
 fs/smb/client/smb2ops.c                            |  116 +-
 fs/smb/client/smb2pdu.c                            |   39 +-
 fs/smb/client/smb2proto.h                          |    2 +-
 fs/smb/client/smbdirect.c                          |   19 +-
 fs/smb/client/transport.c                          |   69 +-
 fs/smb/server/auth.c                               |   21 +-
 fs/smb/server/connection.c                         |   35 +-
 fs/smb/server/connection.h                         |    7 +-
 fs/smb/server/mgmt/share_config.c                  |    7 +-
 fs/smb/server/mgmt/tree_connect.c                  |   20 +-
 fs/smb/server/mgmt/user_config.c                   |   11 +
 fs/smb/server/mgmt/user_session.c                  |   25 +-
 fs/smb/server/mgmt/user_session.h                  |    1 +
 fs/smb/server/misc.c                               |   33 -
 fs/smb/server/misc.h                               |    1 -
 fs/smb/server/oplock.c                             |   83 +-
 fs/smb/server/oplock.h                             |    1 +
 fs/smb/server/smb2pdu.c                            |  150 +-
 fs/smb/server/smbacl.c                             |  244 +-
 fs/smb/server/smbacl.h                             |    2 +-
 fs/smb/server/transport_rdma.c                     |   44 +-
 fs/smb/server/vfs.c                                |   70 +-
 fs/smb/server/vfs_cache.c                          |    8 +-
 fs/super.c                                         |   43 +-
 fs/tracefs/event_inode.c                           |   24 +
 fs/tracefs/internal.h                              |    4 +-
 fs/ubifs/super.c                                   |    2 +-
 fs/udf/inode.c                                     |   42 +-
 fs/userfaultfd.c                                   |    7 +
 fs/verity/Kconfig                                  |    3 +
 fs/verity/open.c                                   |    8 -
 fs/xfs/libxfs/xfs_alloc.c                          |   46 +-
 fs/xfs/libxfs/xfs_attr.c                           |   74 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |   32 +-
 fs/xfs/xfs_buf.c                                   |    6 +-
 fs/xfs/xfs_buf_item.c                              |  299 +-
 fs/xfs/xfs_buf_item.h                              |    3 +-
 fs/xfs/xfs_dquot.c                                 |    2 +-
 fs/xfs/xfs_icache.c                                |    8 +
 fs/xfs/xfs_inode.c                                 |    2 +-
 fs/xfs/xfs_log_recover.c                           |   13 +-
 fs/xfs/xfs_mount.c                                 |    2 +-
 fs/xfs/xfs_qm.c                                    |    2 +-
 include/acpi/acpi_bus.h                            |    6 +
 include/clocksource/samsung_pwm.h                  |    2 +-
 include/drm/drm_debugfs.h                          |    6 +-
 include/drm/{drm_gpuva_mgr.h => drm_gpuvm.h}       |  155 +-
 include/drm/gpu_scheduler.h                        |   29 +-
 include/linux/bpf.h                                |   32 +-
 include/linux/bpf_mprog.h                          |   10 +
 include/linux/bpf_verifier.h                       |   12 +-
 include/linux/can/skb.h                            |    2 +
 include/linux/cgroup.h                             |    1 +
 include/linux/cpufreq.h                            |    2 +-
 include/linux/device/bus.h                         |    3 +
 include/linux/dma-buf.h                            |    1 +
 include/linux/dma/k3-udma-glue.h                   |    3 +-
 include/linux/dmaengine.h                          |    7 +
 include/linux/eventfd.h                            |    4 +-
 include/linux/fb.h                                 |    2 +
 include/linux/filelock.h                           |   90 +-
 include/linux/filter.h                             |   13 +-
 include/linux/fs.h                                 |   11 +-
 include/linux/fsl/mc.h                             |    4 -
 include/linux/fsverity.h                           |   25 -
 include/linux/ftrace.h                             |    5 +-
 include/linux/gfp.h                                |    1 +
 include/linux/hid.h                                |   10 +-
 include/linux/huge_mm.h                            |   29 +-
 include/linux/hw_random.h                          |    2 +
 include/linux/hyperv.h                             |    5 -
 include/linux/i3c/master.h                         |    3 +
 include/linux/ieee80211.h                          |   12 +-
 include/linux/if_team.h                            |    3 +-
 include/linux/if_vlan.h                            |    3 +
 include/linux/igmp.h                               |    7 +-
 include/linux/iio/iio.h                            |   15 +
 include/linux/iommu.h                              |    3 +-
 include/linux/irq_work.h                           |    9 +-
 include/linux/irq_work_types.h                     |   14 +
 include/linux/jbd2.h                               |    4 +-
 include/linux/kasan.h                              |    6 +-
 include/linux/list_lru.h                           |   92 +-
 include/linux/llist.h                              |   42 +
 include/linux/lockd/bind.h                         |   12 +-
 include/linux/lockd/lockd.h                        |   10 +-
 include/linux/memory.h                             |   23 +-
 include/linux/memory_hotplug.h                     |   14 +-
 include/linux/mlx5/cq.h                            |    1 +
 include/linux/mlx5/mlx5_ifc.h                      |   13 +-
 include/linux/mm.h                                 |    2 +-
 include/linux/mount.h                              |    2 +-
 include/linux/namei.h                              |    7 +-
 include/linux/netdevice.h                          |    9 +-
 include/linux/netfilter.h                          |   12 +
 include/linux/netfilter/x_tables.h                 |    1 +
 include/linux/ntb.h                                |   24 +
 include/linux/nvme.h                               |    4 +-
 include/linux/nvmem-consumer.h                     |    7 -
 include/linux/nvmem-provider.h                     |   57 +-
 include/linux/of_device.h                          |    6 +
 include/linux/path.h                               |    9 +
 include/linux/pci.h                                |   21 +-
 include/linux/perf/riscv_pmu.h                     |    2 +-
 include/linux/perf_event.h                         |    3 +-
 include/linux/platform_data/x86/asus-wmi.h         |    3 +
 include/linux/property.h                           |   12 +
 include/linux/rcupdate.h                           |   14 +
 include/linux/rcuwait.h                            |   13 +-
 include/linux/sched.h                              |    2 +-
 include/linux/sched/signal.h                       |    5 +-
 include/linux/sched/user.h                         |    3 +-
 include/linux/skbuff.h                             |   12 +-
 include/linux/skmsg.h                              |   14 -
 include/linux/soc/qcom/geni-se.h                   |   15 +-
 include/linux/spi/spi.h                            |    5 -
 include/linux/srcutiny.h                           |    4 +
 include/linux/string.h                             |    1 +
 include/linux/sunrpc/svc_rdma.h                    |    1 +
 include/linux/tty.h                                |    2 +
 include/linux/tty_driver.h                         |    6 +
 include/linux/tty_port.h                           |   22 +-
 include/linux/types.h                              |   12 +
 include/linux/usb/gadget.h                         |    2 +
 include/linux/usb/serial.h                         |    1 +
 include/linux/userfaultfd_k.h                      |    7 +
 include/linux/vdpa.h                               |    4 -
 include/linux/virtio.h                             |    2 +-
 include/media/v4l2-mem2mem.h                       |   21 +
 include/net/amt.h                                  |    4 -
 include/net/ax25.h                                 |    1 -
 include/net/bluetooth/hci_core.h                   |    7 +-
 include/net/bluetooth/rfcomm.h                     |    1 +
 include/net/cfg80211.h                             |  105 +-
 include/net/dropreason-core.h                      |    3 +
 include/net/inet_connection_sock.h                 |   11 +-
 include/net/ip.h                                   |   16 +-
 include/net/ip6_route.h                            |    2 +-
 include/net/ip6_tunnel.h                           |   12 +
 include/net/ip_tunnels.h                           |   17 +
 include/net/ip_vs.h                                |    2 +-
 include/net/mac80211.h                             |    4 +
 include/net/netfilter/nf_conntrack.h               |   18 +-
 include/net/netfilter/nf_conntrack_expect.h        |   16 +-
 include/net/netfilter/nf_conntrack_timeout.h       |   27 +-
 include/net/netfilter/nf_flow_table.h              |    2 +-
 include/net/netfilter/nf_queue.h                   |    1 +
 include/net/netfilter/nf_tables.h                  |    8 +-
 include/net/netns/mpls.h                           |    2 +
 include/net/netns/xfrm.h                           |    1 +
 include/net/nexthop.h                              |    6 +-
 include/net/pkt_cls.h                              |   14 +-
 include/net/route.h                                |    2 +-
 include/net/sch_generic.h                          |   12 +-
 include/net/sctp/auth.h                            |    3 +
 include/net/secure_seq.h                           |   45 +-
 include/net/sock.h                                 |    8 +-
 include/net/strparser.h                            |   10 +-
 include/net/tcp.h                                  |   12 +-
 include/net/xdp.h                                  |   16 +-
 include/scsi/scsi_host.h                           |   10 +-
 include/sound/core.h                               |    9 +
 include/trace/events/rv.h                          |   60 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |    1 +
 include/uapi/linux/nexthop.h                       |    7 +-
 include/ufs/ufshcd.h                               |    4 -
 init/main.c                                        |   27 +-
 io_uring/io_uring.c                                |   15 +-
 io_uring/io_uring.h                                |    8 +
 io_uring/poll.c                                    |   22 +-
 io_uring/rw.c                                      |   32 +-
 kernel/audit_tree.c                                |   36 +-
 kernel/bpf/arraymap.c                              |   26 +-
 kernel/bpf/btf.c                                   |   31 +-
 kernel/bpf/cgroup.c                                |   19 +-
 kernel/bpf/core.c                                  |   13 +-
 kernel/bpf/hashtab.c                               |    4 +-
 kernel/bpf/helpers.c                               |   29 +-
 kernel/bpf/mmap_unlock_work.h                      |   51 +-
 kernel/bpf/offload.c                               |    9 +-
 kernel/bpf/queue_stack_maps.c                      |    8 +-
 kernel/bpf/stackmap.c                              |   69 +-
 kernel/bpf/syscall.c                               |   11 +-
 kernel/bpf/task_iter.c                             |   14 +-
 kernel/bpf/trampoline.c                            |   54 +-
 kernel/bpf/verifier.c                              |  807 +++--
 kernel/cgroup/Makefile                             |    2 +-
 kernel/cgroup/cgroup.c                             |   24 +-
 kernel/cgroup/cpuset-internal.h                    |  222 ++
 kernel/cgroup/cpuset-v1.c                          |    3 +
 kernel/cgroup/cpuset.c                             |  226 +-
 kernel/cgroup/rstat.c                              |   19 +-
 kernel/dma/direct.c                                |   41 +-
 kernel/dma/swiotlb.c                               |    6 +-
 kernel/events/core.c                               |  117 +-
 kernel/irq/proc.c                                  |    7 +-
 kernel/kprobes.c                                   |    8 +-
 kernel/module/dups.c                               |   66 +-
 kernel/params.c                                    |   60 +-
 kernel/rcu/srcutiny.c                              |   19 +-
 kernel/reboot.c                                    |    3 +-
 kernel/sched/core.c                                |   54 +-
 kernel/sched/deadline.c                            |    6 +-
 kernel/sched/sched.h                               |    1 +
 kernel/signal.c                                    |   12 +
 kernel/sysctl.c                                    |   13 +-
 kernel/time/namespace.c                            |    5 +
 kernel/trace/fgraph.c                              |    1 +
 kernel/trace/ftrace.c                              |   72 +-
 kernel/trace/trace.c                               |  117 +-
 kernel/trace/trace.h                               |    5 +-
 kernel/trace/trace_btf.c                           |   12 +-
 kernel/trace/trace_events_hist.c                   |   41 +-
 kernel/trace/trace_functions.c                     |    2 +-
 kernel/trace/trace_probe.c                         |    2 +-
 kernel/trace/trace_stack.c                         |    2 +-
 kernel/workqueue.c                                 |    2 +-
 mm/damon/core.c                                    |   47 +-
 mm/damon/vaddr.c                                   |    1 +
 mm/filemap.c                                       |    9 -
 mm/huge_memory.c                                   |   54 +-
 mm/hugetlb.c                                       |   54 +-
 mm/kasan/shadow.c                                  |  111 +-
 mm/khugepaged.c                                    |   14 +-
 mm/kmemleak.c                                      |   51 +-
 mm/list_lru.c                                      |   48 +-
 mm/memcontrol.c                                    |   52 +-
 mm/memory.c                                        |    6 +-
 mm/memory_hotplug.c                                |    9 +-
 mm/migrate_device.c                                |    6 +
 mm/mm_init.c                                       |   14 +-
 mm/mmap.c                                          |   31 +-
 mm/mremap.c                                        |   72 +-
 mm/page_alloc.c                                    |   10 +
 mm/page_owner.c                                    |   14 +-
 mm/page_table_check.c                              |   20 +-
 mm/rmap.c                                          |    6 +-
 mm/secretmem.c                                     |  118 +-
 mm/shmem.c                                         |   28 +-
 mm/slub.c                                          |  175 +-
 mm/util.c                                          |   17 +
 mm/vmalloc.c                                       |    4 +-
 mm/vmpressure.c                                    |    2 +-
 mm/vmscan.c                                        |   18 +-
 mm/workingset.c                                    |    4 +-
 net/9p/trans_xen.c                                 |   79 +-
 net/ax25/af_ax25.c                                 |   30 +-
 net/ax25/ax25_route.c                              |   74 -
 net/bluetooth/6lowpan.c                            |   27 +-
 net/bluetooth/eir.c                                |   13 +-
 net/bluetooth/eir.h                                |    2 +-
 net/bluetooth/hci_conn.c                           |   20 +-
 net/bluetooth/hci_core.c                           |   63 +-
 net/bluetooth/hci_debugfs.c                        |    2 +-
 net/bluetooth/hci_event.c                          |  100 +-
 net/bluetooth/hci_sock.c                           |    2 +
 net/bluetooth/hci_sync.c                           |  100 +-
 net/bluetooth/hci_sysfs.c                          |   17 +-
 net/bluetooth/iso.c                                |   97 +-
 net/bluetooth/l2cap_core.c                         |   43 +-
 net/bluetooth/l2cap_sock.c                         |   57 +-
 net/bluetooth/mgmt.c                               |   35 +-
 net/bluetooth/rfcomm/core.c                        |  134 +-
 net/bluetooth/rfcomm/sock.c                        |    5 +-
 net/bluetooth/rfcomm/tty.c                         |    9 +-
 net/bluetooth/smp.c                                |    2 +
 net/bridge/br_arp_nd_proxy.c                       |   24 +-
 net/bridge/br_cfm.c                                |   11 +-
 net/bridge/br_device.c                             |    1 -
 net/bridge/br_input.c                              |   35 +-
 net/bridge/br_mrp.c                                |   13 +-
 net/bridge/br_multicast.c                          |   23 +-
 net/bridge/br_private.h                            |   26 +-
 net/bridge/netfilter/ebt_dnat.c                    |    4 +-
 net/bridge/netfilter/ebt_redirect.c                |   16 +-
 net/bridge/netfilter/ebtable_broute.c              |    2 +-
 net/bridge/netfilter/ebtable_filter.c              |    2 +-
 net/bridge/netfilter/ebtable_nat.c                 |    2 +-
 net/bridge/netfilter/ebtables.c                    |   73 +-
 net/can/af_can.c                                   |    6 +-
 net/can/bcm.c                                      |    2 +
 net/can/isotp.c                                    |   11 +-
 net/can/j1939/socket.c                             |    1 +
 net/can/j1939/transport.c                          |    2 +
 net/can/raw.c                                      |    7 +-
 net/ceph/auth_x.c                                  |    5 +
 net/core/bpf_sk_storage.c                          |   17 +-
 net/core/dev.c                                     |  271 +-
 net/core/filter.c                                  |    4 +-
 net/core/flow_dissector.c                          |   26 +-
 net/core/pktgen.c                                  |    5 +-
 net/core/rtnetlink.c                               |    9 +-
 net/core/secure_seq.c                              |   80 +-
 net/core/skbuff.c                                  |    8 +-
 net/core/sock.c                                    |   35 +-
 net/core/xdp.c                                     |    4 +-
 net/dccp/timer.c                                   |    4 +-
 net/ethtool/channels.c                             |    6 +-
 net/ethtool/common.c                               |   22 +-
 net/ethtool/common.h                               |    2 +-
 net/ethtool/ioctl.c                                |    4 +-
 net/ethtool/rss.c                                  |    4 +-
 net/handshake/handshake-test.c                     |    8 +
 net/handshake/handshake.h                          |    2 +
 net/handshake/netlink.c                            |   21 +-
 net/handshake/request.c                            |   73 +-
 net/ieee802154/core.c                              |    8 +-
 net/ife/ife.c                                      |   14 +-
 net/ipv4/esp4.c                                    |    7 +
 net/ipv4/fib_semantics.c                           |    3 +
 net/ipv4/fib_trie.c                                |    2 -
 net/ipv4/igmp.c                                    |  224 +-
 net/ipv4/inet_connection_sock.c                    |   10 +-
 net/ipv4/inet_diag.c                               |    4 +-
 net/ipv4/ip_tunnel_core.c                          |   13 +
 net/ipv4/ipconfig.c                                |   90 +-
 net/ipv4/ipmr.c                                    |    6 +-
 net/ipv4/ipmr_base.c                               |    2 +-
 net/ipv4/netfilter/arp_tables.c                    |   35 +-
 net/ipv4/netfilter/ip_tables.c                     |   41 +-
 net/ipv4/netfilter/iptable_nat.c                   |    4 +-
 net/ipv4/nexthop.c                                 |   54 +-
 net/ipv4/raw.c                                     |    2 +-
 net/ipv4/route.c                                   |    2 +
 net/ipv4/syncookies.c                              |   11 +-
 net/ipv4/tcp_bpf.c                                 |   17 +-
 net/ipv4/tcp_fastopen.c                            |    7 +-
 net/ipv4/tcp_input.c                               |   14 +-
 net/ipv4/tcp_ipv4.c                                |   43 +-
 net/ipv4/tcp_metrics.c                             |    6 +-
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv4/tcp_output.c                              |    6 +-
 net/ipv4/tcp_timer.c                               |    5 +-
 net/ipv4/udp.c                                     |   56 +
 net/ipv4/udp_bpf.c                                 |    9 +
 net/ipv4/udp_tunnel_nic.c                          |   29 +-
 net/ipv4/xfrm4_input.c                             |    7 +-
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/esp6.c                                    |    7 +
 net/ipv6/exthdrs.c                                 |   36 +-
 net/ipv6/ioam6.c                                   |   32 +-
 net/ipv6/ioam6_iptunnel.c                          |    9 +-
 net/ipv6/ip6_flowlabel.c                           |   20 +
 net/ipv6/ip6_gre.c                                 |    5 -
 net/ipv6/ip6_input.c                               |    1 +
 net/ipv6/ip6_output.c                              |   30 +-
 net/ipv6/ip6mr.c                                   |    5 +-
 net/ipv6/mcast.c                                   |   20 +-
 net/ipv6/netfilter/ip6_tables.c                    |   38 +-
 net/ipv6/netfilter/ip6table_nat.c                  |    4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    4 +-
 net/ipv6/reassembly.c                              |    4 +-
 net/ipv6/route.c                                   |    2 -
 net/ipv6/rpl_iptunnel.c                            |    9 +-
 net/ipv6/seg6_iptunnel.c                           |    2 +-
 net/ipv6/syncookies.c                              |   11 +-
 net/ipv6/tcp_ipv6.c                                |   43 +-
 net/ipv6/udp.c                                     |   50 +
 net/ipv6/xfrm6_input.c                             |    7 +-
 net/kcm/kcmsock.c                                  |   21 +-
 net/l2tp/l2tp_core.c                               |   16 +-
 net/l2tp/l2tp_core.h                               |    3 +-
 net/l2tp/l2tp_debugfs.c                            |    4 +
 net/l2tp/l2tp_netlink.c                            |   20 +-
 net/l2tp/l2tp_ppp.c                                |  151 +-
 net/mac80211/agg-rx.c                              |    2 +-
 net/mac80211/chan.c                                |   37 +-
 net/mac80211/fils_aead.c                           |    8 +
 net/mac80211/ibss.c                                |    9 +-
 net/mac80211/ieee80211_i.h                         |    2 +-
 net/mac80211/mesh_pathtbl.c                        |   30 +-
 net/mac80211/mlme.c                                |   10 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   30 +-
 net/mac80211/rx.c                                  |   16 +-
 net/mac80211/sta_info.c                            |   85 +-
 net/mac80211/tx.c                                  |  128 +-
 net/mac80211/util.c                                |    7 +-
 net/mctp/device.c                                  |    6 +-
 net/mctp/route.c                                   |   10 +-
 net/mctp/test/route-test.c                         |  112 +
 net/mpls/af_mpls.c                                 |   35 +-
 net/mptcp/pm.c                                     |    3 +
 net/mptcp/pm_netlink.c                             |   10 +-
 net/mptcp/pm_userspace.c                           |   32 +-
 net/mptcp/protocol.c                               |   54 +-
 net/mptcp/protocol.h                               |    4 +-
 net/ncsi/ncsi-manage.c                             |    2 +
 net/netfilter/core.c                               |    6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |    3 +
 net/netfilter/ipvs/ip_vs_core.c                    |   11 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |    4 +
 net/netfilter/ipvs/ip_vs_lblcr.c                   |    3 +
 net/netfilter/ipvs/ip_vs_sync.c                    |   33 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   49 +-
 net/netfilter/nf_conntrack_amanda.c                |    2 +-
 net/netfilter/nf_conntrack_bpf.c                   |   86 +-
 net/netfilter/nf_conntrack_broadcast.c             |    2 +-
 net/netfilter/nf_conntrack_core.c                  |   52 +-
 net/netfilter/nf_conntrack_expect.c                |  145 +-
 net/netfilter/nf_conntrack_h323_main.c             |    8 +-
 net/netfilter/nf_conntrack_helper.c                |   10 +-
 net/netfilter/nf_conntrack_netlink.c               |   22 +-
 net/netfilter/nf_conntrack_sip.c                   |   17 +-
 net/netfilter/nf_conntrack_timeout.c               |   27 +-
 net/netfilter/nf_flow_table_core.c                 |  123 +-
 net/netfilter/nf_flow_table_ip.c                   |    3 +
 net/netfilter/nf_flow_table_offload.c              |   14 +-
 net/netfilter/nf_nat_bpf.c                         |    3 +
 net/netfilter/nf_nat_core.c                        |   17 +-
 net/netfilter/nf_synproxy_core.c                   |   40 +-
 net/netfilter/nf_tables_api.c                      |  192 +-
 net/netfilter/nf_tables_core.c                     |    6 +-
 net/netfilter/nf_tables_trace.c                    |    2 +-
 net/netfilter/nfnetlink_cttimeout.c                |  114 +-
 net/netfilter/nfnetlink_log.c                      |   23 +-
 net/netfilter/nfnetlink_queue.c                    |  186 +-
 net/netfilter/nft_ct.c                             |   12 +-
 net/netfilter/nft_dynset.c                         |   25 +-
 net/netfilter/nft_flow_offload.c                   |   11 +-
 net/netfilter/nft_lookup.c                         |   14 +-
 net/netfilter/nft_set_bitmap.c                     |    4 +-
 net/netfilter/nft_set_hash.c                       |    8 +-
 net/netfilter/nft_set_pipapo.c                     |   12 +-
 net/netfilter/nft_set_rbtree.c                     |   10 +-
 net/netfilter/x_tables.c                           |   77 +-
 net/netfilter/xt_CT.c                              |    2 +-
 net/netlink/genetlink.c                            |   21 +-
 net/openvswitch/actions.c                          |    7 +-
 net/openvswitch/conntrack.c                        |   70 +-
 net/openvswitch/datapath.c                         |    8 +
 net/packet/af_packet.c                             |    6 +-
 net/phonet/socket.c                                |   10 +-
 net/qrtr/mhi.c                                     |   61 +-
 net/rds/tcp.c                                      |   48 +-
 net/rxrpc/proc.c                                   |   26 +-
 net/sched/act_api.c                                |    9 +-
 net/sched/act_ct.c                                 |   36 +-
 net/sched/act_ife.c                                |   32 +-
 net/sched/cls_api.c                                |   17 +-
 net/sched/cls_basic.c                              |    6 +-
 net/sched/cls_bpf.c                                |    6 +-
 net/sched/cls_cgroup.c                             |    2 +-
 net/sched/cls_flow.c                               |    2 +-
 net/sched/cls_flower.c                             |    4 +-
 net/sched/cls_fw.c                                 |    4 +-
 net/sched/cls_matchall.c                           |    4 +-
 net/sched/cls_route.c                              |   10 +-
 net/sched/cls_u32.c                                |   18 +-
 net/sched/em_text.c                                |    3 +
 net/sched/sch_cake.c                               |    2 +-
 net/sched/sch_codel.c                              |   14 +-
 net/sched/sch_drr.c                                |    2 +-
 net/sched/sch_ets.c                                |    2 +-
 net/sched/sch_fifo.c                               |   16 +-
 net/sched/sch_fq.c                                 |   48 +-
 net/sched/sch_fq_codel.c                           |   18 +-
 net/sched/sch_fq_pie.c                             |   14 +-
 net/sched/sch_generic.c                            |   54 +-
 net/sched/sch_gred.c                               |    4 +-
 net/sched/sch_hfsc.c                               |    2 +-
 net/sched/sch_hhf.c                                |   12 +-
 net/sched/sch_htb.c                                |    2 +-
 net/sched/sch_multiq.c                             |    2 +-
 net/sched/sch_pie.c                                |   12 +-
 net/sched/sch_plug.c                               |    2 +-
 net/sched/sch_prio.c                               |    2 +-
 net/sched/sch_qfq.c                                |    2 +-
 net/sched/sch_sfb.c                                |    2 +-
 net/sched/sch_sfq.c                                |    2 +-
 net/sctp/auth.c                                    |   76 +
 net/sctp/bind_addr.c                               |   11 +-
 net/sctp/ipv6.c                                    |   10 +-
 net/sctp/protocol.c                                |    5 +-
 net/sctp/sm_make_chunk.c                           |   20 +-
 net/sctp/sm_statefuns.c                            |   36 +-
 net/sctp/socket.c                                  |    8 +-
 net/smc/af_smc.c                                   |   97 +-
 net/smc/smc.h                                      |    6 +-
 net/smc/smc_clc.h                                  |    2 +-
 net/smc/smc_core.c                                 |    2 +-
 net/smc/smc_core.h                                 |    4 +-
 net/strparser/strparser.c                          |    6 +-
 net/sunrpc/auth_gss/gss_krb5_unseal.c              |    3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   15 +-
 net/sunrpc/clnt.c                                  |   24 +-
 net/sunrpc/xprtrdma/svc_rdma_pcl.c                 |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   22 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   31 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   47 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  105 +-
 net/sunrpc/xprtrdma/verbs.c                        |   13 +-
 net/tipc/core.c                                    |    4 +-
 net/tipc/crypto.c                                  |   20 +-
 net/tipc/link.c                                    |    6 +-
 net/tipc/node.c                                    |   10 +-
 net/tipc/topsrv.c                                  |   80 +-
 net/tipc/udp_media.c                               |   75 +-
 net/tls/tls_device.c                               |    4 +-
 net/tls/tls_sw.c                                   |    2 +
 net/unix/af_unix.c                                 |    8 +-
 net/vmw_vsock/af_vsock.c                           |    6 +-
 net/wireless/core.c                                |   38 +-
 net/wireless/core.h                                |    4 +-
 net/wireless/lib80211_crypt_tkip.c                 |   13 +-
 net/wireless/nl80211.c                             |   16 +-
 net/wireless/pmsr.c                                |    8 +-
 net/wireless/scan.c                                |   38 +-
 net/wireless/sme.c                                 |    6 +-
 net/wireless/wext-sme.c                            |    6 +-
 net/xdp/xsk.c                                      |    7 +-
 net/xfrm/xfrm_device.c                             |    8 +
 net/xfrm/xfrm_input.c                              |   25 +-
 net/xfrm/xfrm_policy.c                             |   19 +-
 net/xfrm/xfrm_user.c                               |   10 +-
 samples/vfio-mdev/mtty.c                           |    4 +-
 security/apparmor/domain.c                         |   25 +-
 security/apparmor/include/cred.h                   |    6 +-
 security/apparmor/include/label.h                  |    6 +-
 security/apparmor/include/match.h                  |   12 +-
 security/apparmor/include/policy.h                 |    3 +
 security/apparmor/include/task.h                   |   15 +-
 security/apparmor/match.c                          |   22 +-
 security/apparmor/policy.c                         |   22 +-
 security/apparmor/task.c                           |   27 +
 security/keys/key.c                                |    6 +-
 security/keys/persistent.c                         |   55 +-
 security/keys/trusted-keys/trusted_tpm1.c          |    2 +-
 security/landlock/fs.c                             |   19 +-
 security/selinux/avc.c                             |    5 +-
 security/selinux/hooks.c                           |    9 +-
 security/selinux/selinuxfs.c                       |   27 +-
 security/selinux/ss/policydb.c                     |    4 +
 sound/core/control_led.c                           |    4 +
 sound/core/oss/mixer_oss.c                         |   32 +
 sound/core/oss/pcm_oss.c                           |   53 +-
 sound/core/seq/oss/seq_oss_event.c                 |    6 +-
 sound/core/seq/oss/seq_oss_event.h                 |    3 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |    5 +-
 sound/core/seq/oss/seq_oss_midi.c                  |    6 +-
 sound/core/seq/oss/seq_oss_midi.h                  |    2 +-
 sound/core/seq/oss/seq_oss_readq.c                 |   85 +-
 sound/core/seq/oss/seq_oss_rw.c                    |    5 +-
 sound/core/seq/seq_clientmgr.c                     |   54 +-
 sound/core/seq/seq_compat.c                        |    4 +-
 sound/core/seq/seq_fifo.c                          |   98 +-
 sound/core/seq/seq_fifo.h                          |    1 +
 sound/drivers/mtpav.c                              |    6 +-
 sound/pci/hda/cs35l41_hda.c                        |   73 +-
 sound/pci/hda/cs35l41_hda.h                        |    5 +
 sound/pci/hda/hda_tegra.c                          |    3 +-
 sound/pci/hda/patch_realtek.c                      |   12 +-
 sound/pci/ice1712/ice1712.c                        |    2 +-
 sound/soc/amd/acp/acp-mach-common.c                |   18 +-
 sound/soc/amd/yc/acp6x-mach.c                      |    7 +
 sound/soc/codecs/adau1372.c                        |   18 +-
 sound/soc/codecs/aw88261.c                         |   30 +-
 sound/soc/codecs/aw88261.h                         |    6 -
 sound/soc/codecs/hdac_hda.c                        |    4 +-
 sound/soc/codecs/max98363.c                        |    2 +-
 sound/soc/codecs/rt1017-sdca-sdw.c                 |   27 +-
 sound/soc/codecs/rt274.c                           |    4 +-
 sound/soc/codecs/rt286.c                           |    2 +-
 sound/soc/codecs/wm8903.c                          |    2 +-
 sound/soc/fsl/fsl_audmix.c                         |   24 +-
 sound/soc/intel/avs/pcm.c                          |    5 +-
 sound/soc/qcom/lpass-cpu.c                         |    4 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |    5 +
 sound/soc/samsung/i2s.c                            |    8 +
 sound/soc/sof/intel/hda-dai.c                      |    6 +
 sound/soc/sof/intel/hda.c                          |    5 +
 sound/soc/sof/ipc4-topology.c                      |   13 +-
 sound/soc/sof/sof-audio.h                          |    1 +
 sound/soc/sof/topology.c                           |   11 +
 sound/soc/tegra/tegra186_asrc.c                    |    2 +-
 sound/usb/caiaq/device.c                           |    3 +
 sound/usb/card.h                                   |    3 +-
 sound/usb/endpoint.c                               |   16 +-
 sound/usb/line6/playback.c                         |    7 +
 sound/usb/misc/ua101.c                             |    9 +
 sound/usb/pcm.c                                    |    3 +-
 sound/usb/quirks.c                                 |    4 +-
 sound/usb/usx2y/us122l.c                           |   45 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |   25 +-
 sound/usb/usx2y/usb_stream.c                       |   92 +-
 sound/usb/usx2y/usb_stream.h                       |    1 +
 sound/usb/usx2y/usbusx2y.c                         |   13 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |   67 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                    |   54 +-
 tools/bpf/bpftool/feature.c                        |    3 +-
 tools/lib/bpf/libbpf_probes.c                      |    6 +-
 tools/net/ynl/generated/netdev-user.c              |   19 +
 tools/net/ynl/generated/netdev-user.h              |    3 +
 tools/net/ynl/samples/Makefile                     |    2 +-
 tools/net/ynl/samples/netdev.c                     |    8 +-
 tools/objtool/check.c                              |    2 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |    2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    4 +-
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |    4 +-
 .../bpf/progs/verifier_helper_restricted.c         |    8 +-
 .../bpf/progs/verifier_subprog_precision.c         |   12 +-
 tools/testing/selftests/mm/memfd_secret.c          |   30 +-
 tools/testing/selftests/net/tls.c                  |  549 ++++
 virt/kvm/eventfd.c                                 |    4 +-
 1923 files changed, 29774 insertions(+), 47583 deletions(-)


