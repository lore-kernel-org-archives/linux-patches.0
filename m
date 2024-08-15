Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BA044376;
	Thu, 15 Aug 2024 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730888; cv=none; b=mDJHzCrxxep8QkEuHlGjhSJvHpKzjwDInf0tLFxprPgedL3WLSFRRzrYLqCqDRHWUoDPW6sxV2d6dK4nLWwzxZjl5UmLknV25biytEUnDKYrIRwZJgzeQK7gU8XeQEd/MMUB47baX8TwFGxUF0JEuRwr0YpXfgrqKorDw+NyICs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730888; c=relaxed/simple;
	bh=sO5Fu1IQSHMRmhr6SRtoAUjXcr4tRunJnxCP1u2MdCA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=us1vQM5wWjKtJtRb7WZk0vi82Y6aV3Am+eESOWaDAGC7ThcTJP++ksVTibjmseRsdYfCirN7XYBjVXsjZHaBrJlLdoikWEmoQ+tKTphVJi1W4GSR8hjse7V5iqVb0keLh3X44LphWYTGMWvPd7QDUT14yUvr3q4ys1oK0glCgNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mAYpzykH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mAYpzykH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94017C32786;
	Thu, 15 Aug 2024 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730888;
	bh=sO5Fu1IQSHMRmhr6SRtoAUjXcr4tRunJnxCP1u2MdCA=;
	h=From:To:Cc:Subject:Date:From;
	b=mAYpzykHup/2JAIX3ozNDiV4XlwmFWNKKDE4BK8qV8p4OwkltVH2PRWHd2yJLK6af
	 6qX7sJ0pycMQx/FKl40Nv3XBNgd4OHv28VHZikBwETdGd+UTjOlbldun4sOptd8eFK
	 QBbDlG6zVtfPsuDKJMV+kyRFHM+1xhoYmL3WXFWM=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.6 00/67] 6.6.47-rc1 review
Date: Thu, 15 Aug 2024 15:25:14 +0200
Message-ID: <20240815131838.311442229@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.47-rc1
X-KernelTest-Deadline: 2024-08-17T13:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.47 release.
There are 67 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.47-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.47-rc1

Will Deacon <will@kernel.org>
    KVM: arm64: Don't pass a TLBI level hint when zapping table entries

Will Deacon <will@kernel.org>
    KVM: arm64: Don't defer TLB invalidation when zapping table entries

Waiman Long <longman@redhat.com>
    cgroup: Move rcu_head up near the top of cgroup_root

Peter Xu <peterx@redhat.com>
    mm/debug_vm_pgtable: drop RANDOM_ORVALUE trick

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    Revert "Input: bcm5974 - check endpoint type before starting traffic"

Dave Kleikamp <dave.kleikamp@oracle.com>
    Revert "jfs: fix shift-out-of-bounds in dbJoin"

Kees Cook <kees@kernel.org>
    binfmt_flat: Fix corruption when not offsetting data start

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: Fix UBSAN warning in parse_audio_unit()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do copy_to_user out of run_lock

Pei Li <peili.dev@gmail.com>
    jfs: Fix shift-out-of-bounds in dbDiscardAG

Edward Adam Davis <eadavis@qq.com>
    jfs: fix null ptr deref in dtInsertEntry

Willem de Bruijn <willemb@google.com>
    fou: remove warn in gue_gro_receive on unsupported protocol

Chao Yu <chao@kernel.org>
    f2fs: fix to cover read extent cache access with lock

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on F2FS_INLINE_DATA flag in inode during GC

yunshui <jiangyunshui@kylinos.cn>
    bpf, net: Use DEV_STAT_INC()

Wojciech Gładysz <wojciech.gladysz@infogain.com>
    ext4: sanity check for NULL pointer after ext4_force_shutdown

Matthew Wilcox (Oracle) <willy@infradead.org>
    ext4: convert ext4_da_do_write_end() to take a folio

Eric Dumazet <edumazet@google.com>
    wifi: cfg80211: restrict NL80211_ATTR_TXQ_QUANTUM values

Peter Xu <peterx@redhat.com>
    mm/page_table_check: support userfault wr-protect entries

Jan Kara <jack@suse.cz>
    ext4: do not create EA inode under buffer lock

Jan Kara <jack@suse.cz>
    ext4: fold quota accounting into ext4_xattr_inode_lookup_create()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Fix not validating setsockopt user input

Eric Dumazet <edumazet@google.com>
    nfc: llcp: fix nfc_llcp_setsockopt() unsafe copies

Eric Dumazet <edumazet@google.com>
    net: add copy_safe_from_sockptr() helper

Eric Dumazet <edumazet@google.com>
    mISDN: fix MISDN_TIME_STAMP handling

Gustavo A. R. Silva <gustavoars@kernel.org>
    fs: Annotate struct file_handle with __counted_by() and use struct_size()

Alexei Starovoitov <ast@kernel.org>
    bpf: Avoid kfree_rcu() under lock in bpf_lpm_trie.

Kees Cook <keescook@chromium.org>
    bpf: Replace bpf_lpm_trie_key 0-length array with flexible array

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    pppoe: Fix memory leak in pppoe_sendmsg()

Dmitry Antipov <dmantipov@yandex.ru>
    net: sctp: fix skb leak in sctp_inq_free()

Allison Henderson <allison.henderson@oracle.com>
    net:rds: Fix possible deadlock in rds_message_put

Jan Kara <jack@suse.cz>
    quota: Detect loops in quota tree

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    Input: bcm5974 - check endpoint type before starting traffic

John Fastabend <john.fastabend@gmail.com>
    net: tls, add test to capture error on large splice

Gao Xiang <xiang@kernel.org>
    erofs: avoid debugging output for (de)compressed data

Edward Adam Davis <eadavis@qq.com>
    reiserfs: fix uninit-value in comp_keys

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix variable overflow triggered by sysbot

Lizhi Xu <lizhi.xu@windriver.com>
    squashfs: squashfs_read_data need to check if the length is 0

Manas Ghandat <ghandatmanas@gmail.com>
    jfs: fix shift-out-of-bounds in dbJoin

Jakub Kicinski <kuba@kernel.org>
    net: don't dump stack on queue timeout

Lizhi Xu <lizhi.xu@windriver.com>
    jfs: fix log->bdev_handle null ptr deref in lbmStartIO

Jan Kara <jack@suse.cz>
    jfs: Convert to bdev_open_by_dev()

Jan Kara <jack@suse.cz>
    fs: Convert to bdev_open_by_dev()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix change_address deadlock during unregister

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: take wiphy lock for MAC addr change

Eric Dumazet <edumazet@google.com>
    tcp_metrics: optimize tcp_metrics_flush_all()

Yafang Shao <laoar.shao@gmail.com>
    cgroup: Make operations on the cgroup root_list RCU safe

Dongli Zhang <dongli.zhang@oracle.com>
    genirq/cpuhotplug: Retry with cpu_online_mask when migration fails

David Stevens <stevensd@chromium.org>
    genirq/cpuhotplug: Skip suspended interrupts when restoring affinity

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Yang Shi <yang@os.amperecomputing.com>
    mm: gup: stop abusing try_grab_folio

Josef Bacik <josef@toxicpanda.com>
    nfsd: make svc_stat per-network namespace instead of global

Josef Bacik <josef@toxicpanda.com>
    nfsd: remove nfsd_stats, make th_cnt a global counter

Josef Bacik <josef@toxicpanda.com>
    nfsd: make all of the nfsd stats per-network namespace

Josef Bacik <josef@toxicpanda.com>
    nfsd: expose /proc/net/sunrpc/nfsd in net namespaces

Josef Bacik <josef@toxicpanda.com>
    nfsd: rename NFSD_NET_* to NFSD_STATS_*

Josef Bacik <josef@toxicpanda.com>
    sunrpc: use the struct net as the svc proc private

Josef Bacik <josef@toxicpanda.com>
    sunrpc: remove ->pg_stats from svc_program

Josef Bacik <josef@toxicpanda.com>
    sunrpc: pass in the sv_stats struct through svc_create_pooled

Josef Bacik <josef@toxicpanda.com>
    nfsd: stop setting ->pg_stats for unused stats

Josef Bacik <josef@toxicpanda.com>
    sunrpc: don't change ->sv_stats if it doesn't exist

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix frame size warning in svc_export_parse()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Rewrite synopsis of nfsd_percpu_counters_init()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Define __ARCH_WANT_NEW_STAT in unistd.h

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Fix route memory corruption

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Clean up route loading

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage


-------------

Diffstat:

 Documentation/bpf/map_lpm_trie.rst               |   2 +-
 Documentation/mm/page_table_check.rst            |   9 +-
 Makefile                                         |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                     |  12 +-
 arch/loongarch/include/uapi/asm/unistd.h         |   1 +
 arch/x86/include/asm/pgtable.h                   |  18 +-
 drivers/isdn/mISDN/socket.c                      |  10 +-
 drivers/net/ppp/pppoe.c                          |  23 +--
 drivers/nvme/host/pci.c                          |   7 +
 fs/binfmt_flat.c                                 |   4 +-
 fs/buffer.c                                      |   2 +
 fs/cramfs/inode.c                                |   2 +-
 fs/erofs/decompressor.c                          |   8 +-
 fs/exec.c                                        |   8 +-
 fs/ext4/inode.c                                  |  24 ++-
 fs/ext4/xattr.c                                  | 155 +++++++-------
 fs/f2fs/extent_cache.c                           |  50 ++---
 fs/f2fs/f2fs.h                                   |   2 +-
 fs/f2fs/gc.c                                     |  10 +
 fs/f2fs/inode.c                                  |  10 +-
 fs/fhandle.c                                     |   6 +-
 fs/jfs/jfs_dmap.c                                |   2 +
 fs/jfs/jfs_dtree.c                               |   2 +
 fs/jfs/jfs_logmgr.c                              |  33 +--
 fs/jfs/jfs_logmgr.h                              |   2 +-
 fs/jfs/jfs_mount.c                               |   3 +-
 fs/lockd/svc.c                                   |   3 -
 fs/nfs/callback.c                                |   3 -
 fs/nfsd/cache.h                                  |   2 -
 fs/nfsd/export.c                                 |  32 ++-
 fs/nfsd/export.h                                 |   4 +-
 fs/nfsd/netns.h                                  |  25 ++-
 fs/nfsd/nfs4proc.c                               |   6 +-
 fs/nfsd/nfs4state.c                              |   3 +-
 fs/nfsd/nfscache.c                               |  40 +---
 fs/nfsd/nfsctl.c                                 |  16 +-
 fs/nfsd/nfsd.h                                   |   1 +
 fs/nfsd/nfsfh.c                                  |   3 +-
 fs/nfsd/nfssvc.c                                 |  14 +-
 fs/nfsd/stats.c                                  |  54 ++---
 fs/nfsd/stats.h                                  |  88 +++-----
 fs/nfsd/vfs.c                                    |   6 +-
 fs/ntfs3/frecord.c                               |  75 ++++++-
 fs/quota/quota_tree.c                            | 128 +++++++++---
 fs/quota/quota_v2.c                              |  15 +-
 fs/reiserfs/stree.c                              |   2 +-
 fs/romfs/super.c                                 |   2 +-
 fs/squashfs/block.c                              |   2 +-
 fs/squashfs/file.c                               |   3 +-
 fs/squashfs/file_direct.c                        |   6 +-
 fs/super.c                                       |  15 +-
 include/linux/cgroup-defs.h                      |   7 +-
 include/linux/fs.h                               |   3 +-
 include/linux/sockptr.h                          |  25 +++
 include/linux/sunrpc/svc.h                       |   5 +-
 include/uapi/linux/bpf.h                         |  19 +-
 kernel/bpf/lpm_trie.c                            |  33 +--
 kernel/cgroup/cgroup-internal.h                  |   3 +-
 kernel/cgroup/cgroup.c                           |  23 ++-
 kernel/irq/cpuhotplug.c                          |  27 ++-
 kernel/irq/manage.c                              |  12 +-
 mm/debug_vm_pgtable.c                            |  31 +--
 mm/gup.c                                         | 251 ++++++++++++-----------
 mm/huge_memory.c                                 |   6 +-
 mm/hugetlb.c                                     |   2 +-
 mm/internal.h                                    |   4 +-
 mm/page_table_check.c                            |  30 +++
 net/bluetooth/rfcomm/sock.c                      |  14 +-
 net/core/filter.c                                |   8 +-
 net/ipv4/fou_core.c                              |   2 +-
 net/ipv4/tcp_metrics.c                           |   7 +-
 net/mac80211/iface.c                             |  27 ++-
 net/nfc/llcp_sock.c                              |  12 +-
 net/rds/recv.c                                   |  13 +-
 net/sched/sch_generic.c                          |   5 +-
 net/sctp/inqueue.c                               |  14 +-
 net/sunrpc/stats.c                               |   2 +-
 net/sunrpc/svc.c                                 |  39 ++--
 net/wireless/nl80211.c                           |   6 +-
 samples/bpf/map_perf_test_user.c                 |   2 +-
 samples/bpf/xdp_router_ipv4_user.c               |   2 +-
 sound/soc/soc-topology.c                         |  32 +--
 sound/usb/mixer.c                                |   7 +
 tools/include/uapi/linux/bpf.h                   |  19 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c |   2 +-
 tools/testing/selftests/bpf/test_lpm_map.c       |  18 +-
 tools/testing/selftests/net/tls.c                |  14 ++
 87 files changed, 987 insertions(+), 696 deletions(-)


