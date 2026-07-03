Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5179367B89;
	Fri,  3 Jul 2026 07:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783064159; cv=none; b=V6/49JSpag16q5LCaPabGLs6UI3OPtp+Sm3lE/IiFPdwLI/ujIukvWPe0uqccxNYGQS8xv176dFNlPaDAuNyoQB7qBAB43HyvJzC2C9X3lJAocbLRZ/UOUjoWfAH1N5TUYiRWZjuy3grwsbOE0FEfbWs3RjGONgLuCGLEkWWWEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783064159; c=relaxed/simple;
	bh=3svTl+kDPG/4PTE66LloTHjsudzcs0+CQ3CtQC7NqEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DWzFZxZt9OBmamjG+8lrPPthj/Bm5OydXIPxYumkHCksovnmboC7sceDB+4Ni+5Ha+UGRH+8+//3ZJDwNp7sW7jxzH9RKa3k1nte2rsoUwvjw2Wbd4VI+RCynVznQoaKZvw9TQFOYrHNDFXlO1hv7Bj6inCe37N68ew78H1GmNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3wvXNlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3wvXNlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C171F000E9;
	Fri,  3 Jul 2026 07:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783064157;
	bh=e8+fqaRJ8/l+rAzh6oVXCG0PIc9XJZqAowjHRwgsGJo=;
	h=From:To:Cc:Subject:Date;
	b=s3wvXNlKRBl58gAH4PmXFC0ENK4tZSFaKg1u9GZjU0M+rZ7helJvdza7vlJBr/qlH
	 RY5Wc96YEKAxzNPNdhhkqrqw4mZiQ0Zox7nEycSkxF4Q4TjG5iN2/4yw+NihjpjbQa
	 LCkOtm3wNxPwQTmOmvxdGIUvFsNs/eqGcZ1n42Go=
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
Subject: [PATCH 6.18 000/109] 6.18.38-rc2 review
Date: Fri,  3 Jul 2026 09:36:06 +0200
Message-ID: <20260703072816.644513463@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.38-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.38-rc2
X-KernelTest-Deadline: 2026-07-05T07:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.38 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Jul 2026 07:28:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.38-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.38-rc2

John Johansen <john.johansen@canonical.com>
    apparmor: advertise the tcp fast open fix is applied

HanQuan <eilaimemedsnaimel@gmail.com>
    net/tcp-ao: fix use-after-free of key in del_async path

Stepan Ionichev <sozdayvek@gmail.com>
    serial: 8250_dw: unregister 8250 port if clk_notifier_register() fails

Hem Parekh <hemparekh1596@gmail.com>
    ksmbd: fix out-of-bounds read in smb_check_perm_dacl()

Markus Elfring <elfring@users.sourceforge.net>
    NFS: Prevent resource leak in nfs_alloc_server()

Igor Raits <igor.raits@gmail.com>
    NFSv4: clear exception state on successful mkdir retry

Michael Bommarito <michael.bommarito@gmail.com>
    NFSv4/pNFS: reject zero-length r_addr in nfs4_decode_mp_ds_addr

Michael Bommarito <michael.bommarito@gmail.com>
    NFSv4/flexfiles: reject zero filehandle version count

Jeff Layton <jlayton@kernel.org>
    nfsd: reset write verifier on deferred writeback errors

Jeff Layton <jlayton@kernel.org>
    nfsd: avoid leaking pre-allocated openowner on unconfirmed retry race

Dominik Woźniak <stalion@gmail.com>
    nfsd: check get_user() return when reading princhashlen

Jeff Layton <jlayton@kernel.org>
    nfsd: fix inverted cp_ttl check in async copy reaper

Jeff Layton <jlayton@kernel.org>
    nfsd: fix posix_acl leak on SETACL decode failure

Guannan Wang <wgnbuaa@gmail.com>
    NFSD: Fix SECINFO_NO_NAME decode error cleanup

Johan Hovold <johan@kernel.org>
    i2c: core: fix adapter registration race

Steffen Persvold <spersvold@gmail.com>
    fbdev: modedb: Fix misaligned fields in the 1920x1080-60 mode

Tuo Li <islituo@gmail.com>
    fbdev: modedb: fix a possible UAF in fb_find_mode()

Ian Bridges <icb@fastmail.org>
    fbdev: Fix fb_new_modelist to prevent null-ptr-deref in fb_videomode_to_var

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: mm: Extract helper mark_new_valid_map()

Wentao Liang <vulab@iscas.ac.cn>
    power: reset: linkstation-poweroff: fix use-after-free in the linkstation_poweroff_init()

Ashutosh Desai <ashutoshdesai993@gmail.com>
    KVM: SVM: Fix page overflow in sev_dbg_crypt() for ENCRYPT path

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: x86: hyper-v: Bound the bank index when querying sparse banks

Jonas Jelonek <jelonek.jonas@gmail.com>
    MIPS: smp: report dying CPU to RCU in stop_this_cpu()

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    9p: avoid putting oldfid in p9_client_walk() error path

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: reject oversized group bitmap descriptors

Yuho Choi <dbgh9129@gmail.com>
    rpmsg: char: Fix use-after-free on probe error path

Wentao Liang <vulab@iscas.ac.cn>
    fpga: region: fix use-after-free in child_regions_with_firmware()

Qingshuang Fu <fuqingshuang@kylinos.cn>
    irqchip/imgpdc: Fix resource leak, add missing chained handler cleanup on remove

Wentao Liang <vulab@iscas.ac.cn>
    pNFS: Fix use-after-free in pnfs_update_layout()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Report dying CPU to RCU in stop_this_cpu()

Doruk Tan Ozturk <doruk@0sec.ai>
    tipc: fix slab-use-after-free Read in tipc_aead_decrypt_done

Michal Koutný <mkoutny@suse.com>
    blk-cgroup: fix UAF in __blkcg_rstat_flush()

Fan Wu <fanwu01@zju.edu.cn>
    hdlc_ppp: sync per-proto timers before freeing hdlc state

Wentao Liang <vulab@iscas.ac.cn>
    pwrseq: core: fix use-after-free in pwrseq_debugfs_seq_next()

Tristan Madani <tristan@talencesecurity.com>
    gfs2: fix use-after-free in gfs2_qd_dealloc

Sam James <sam@gentoo.org>
    crypto: nx - fix nx_crypto_ctx_exit argument

Sean Christopherson <seanjc@google.com>
    KVM: Replace guest-triggerable BUG_ON() in ioeventfd datamatch with get_unaligned()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Ensure hugepage is in by slot before checking max mapping level

Michael Bommarito <michael.bommarito@gmail.com>
    exfat: fix potential use-after-free in exfat_find_dir_entry()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: DEC: Prevent initial console buffer from landing in XKPHYS

Dawei Feng <dawei.feng@seu.edu.cn>
    bpf: use kvfree() for replaced sysctl write buffer

Denis Arefev <arefev@swemel.ru>
    block: Avoid mounting the bdev pseudo-filesystem in userspace

Wenjie Qi <qwjhust@gmail.com>
    f2fs: keep atomic write retry from zeroing original data

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix incorrect FI_NO_EXTENT handling in __destroy_extent_node()

Zhang Cen <rollkingzzc@gmail.com>
    f2fs: validate ACL entry sizes in f2fs_acl_from_disk()

Sunmin Jeong <s_min.jeong@samsung.com>
    f2fs: fix to round down start offset of fallocate for pin file

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate compress cache inode only when enabled

Wenjie Qi <qwjhust@gmail.com>
    f2fs: validate orphan inode entry count

Wenjie Qi <qwjhust@gmail.com>
    f2fs: pass correct iostat type for single node writes

Junrui Luo <moonafterrain@outlook.com>
    wifi: iwlwifi: mld: validate sta_mask before ffs() in BA session handlers

Junjie Cao <junjie.cao@intel.com>
    wifi: iwlwifi: mld: fix race condition in PTP removal

Junjie Cao <junjie.cao@intel.com>
    wifi: iwlwifi: mvm: fix race condition in PTP removal

Luka Gejak <luka.gejak@linux.dev>
    wifi: rtw88: usb: fix memory leaks on USB write failures

Luka Gejak <luka.gejak@linux.dev>
    wifi: rtw88: increase TX report timeout to fix race condition

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8821ae: Fix C2H bit location in RX descriptor

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    wifi: ath11k: fix warning when unbinding

ElXreno <elxreno@gmail.com>
    wifi: mt76: mt7925: don't disable AP BSS when removing TDLS peer

Zenm Chen <zenmchen@gmail.com>
    wifi: mt76: mt76x2u: Add support for ELECOM WDC-867SU3S

Mike Rapoport (Microsoft) <rppt@kernel.org>
    userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing

Shaomin Chen <eeesssooo020@gmail.com>
    keys: Pin request_key_auth payload in instantiate paths

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: fix overflow in keyctl_pkey_params_get_2()

Konstantin Khorenko <khorenko@virtuozzo.com>
    gcov: use atomic counter updates to fix concurrent access crashes

Arnd Bergmann <arnd@arndb.de>
    err.h: use __always_inline on all error pointer helpers

Ard Biesheuvel <ardb@kernel.org>
    KVM: arm64: Omit tag sync on stage-2 mappings of the zero page

Usama Arif <usama.arif@linux.dev>
    block: invalidate cached plug timestamp after task switch

Ian Bridges <icb@fastmail.org>
    fbdev: fix use-after-free in store_modes()

Koichiro Den <den@valinux.co.jp>
    NTB: epf: Avoid pci_iounmap() with offset when PEER_SPAD and CONFIG share BAR

Ruslan Valiyev <linuxoid@gmail.com>
    apparmor: fix use-after-free in rawdata dedup loop

Bryam Vargas <hexlabsecurity@proton.me>
    apparmor: mediate the implicit connect of TCP fast open sendmsg

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip_gre: require CAP_NET_ADMIN in the device netns for changelink

Yiming Qian <yimingqian591@gmail.com>
    net: skmsg: preserve sg.copy across SG transforms

Doruk Tan Ozturk <doruk@0sec.ai>
    mac802154: llsec: add skb_cow_data() before in-place crypto

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Set gc_in_progress to true in unix_gc().

Jiajia Liu <liujiajia@kylinos.cn>
    wifi: mt76: add wcid publish check in mt76_sta_add

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    ntfs3: reject direct userspace writes to reserved $LX* xattrs

Wongi Lee <qw3rtyp0@gmail.com>
    ipv4: account for fraggap on the paged allocation path

Wongi Lee <qw3rtyp0@gmail.com>
    ipv6: account for fraggap on the paged allocation path

Sven Eckelmann <sven@narfation.org>
    batman-adv: tvlv: avoid race of cifsnotfound handler state

Sven Eckelmann <sven@narfation.org>
    batman-adv: tvlv: enforce 2-byte alignment

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: prevent false sharing between VLANs

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: track roam count per VID

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: don't merge change entries with different VIDs

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: handle overlapping packets

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: prevent parallel modifications of last_recv

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: annotate last_recv_time access with READ/WRITE_ONCE

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: restrict number of unacked list entries

Sven Eckelmann <sven@narfation.org>
    batman-adv: v: prevent OGM aggregation on disabled hardif

Sven Eckelmann <sven@narfation.org>
    batman-adv: frag: avoid underflow of TTL

Sven Eckelmann <sven@narfation.org>
    batman-adv: frag: ensure fragment is writable before modifying TTL

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix (m|b)cast csum after decrementing TTL

Sven Eckelmann <sven@narfation.org>
    batman-adv: ensure bcast is writable before modifying TTL

Sven Eckelmann <sven@narfation.org>
    batman-adv: gw: don't deselect gateway with active hardif

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: initialize last_recv_time during init

Sven Eckelmann <sven@narfation.org>
    batman-adv: prevent ELP transmission interval underflow

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: annotate lasttime access with READ/WRITE_ONCE

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: add only finished tp_vars to lists

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: handle seqno wrap-around for fast recovery detection

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: fix fast recovery precondition

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: avoid divide-by-zero for dec_cwnd

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: avoid window underflow

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: initialize dec_cwnd explicitly

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: initialize dup_acks explicitly

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: keep unacked list in ascending ordered

NeilBrown <neil@brown.name>
    lockd: fix TEST handling when not all permissions are available.

Sasha Levin <sashal@kernel.org>
    Revert "PCI: qcom: Advertise Hotplug Slot Capability with no Command Completion support"

Paul Moore <paul@paul-moore.com>
    selinux: fix overlayfs mmap() and mprotect() access checks

Paul Moore <paul@paul-moore.com>
    lsm: add backing_file LSM hooks

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Fix shadow paging use-after-free due to unexpected role


-------------

Diffstat:

 Makefile                                           |  31 ++-
 arch/arm64/kvm/mmu.c                               |   5 +
 arch/loongarch/kernel/smp.c                        |   1 +
 arch/mips/dec/prom/console.c                       |   7 +-
 arch/mips/kernel/smp.c                             |   2 +
 arch/riscv/include/asm/cacheflush.h                |  25 +-
 arch/riscv/include/asm/kfence.h                    |   7 +-
 arch/riscv/kernel/entry.S                          |   6 +-
 arch/x86/kvm/hyperv.c                              |   5 +
 arch/x86/kvm/mmu/mmu.c                             |  28 ++-
 arch/x86/kvm/svm/sev.c                             |   1 +
 block/bdev.c                                       |   5 -
 block/blk-cgroup.c                                 |  21 +-
 drivers/crypto/nx/nx.c                             |   6 +-
 drivers/crypto/nx/nx.h                             |   2 +-
 drivers/fpga/of-fpga-region.c                      |   3 +-
 drivers/i2c/i2c-core-base.c                        |   8 +-
 drivers/irqchip/irq-imgpdc.c                       |   6 +
 drivers/net/wan/hdlc_ppp.c                         |  15 +-
 drivers/net/wireless/ath/ath11k/dp.c               |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/agg.c       |   9 +
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c       |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  15 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |   2 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   7 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |  13 +-
 drivers/ntb/hw/epf/ntb_hw_epf.c                    |   3 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  17 +-
 drivers/power/reset/linkstation-poweroff.c         |   2 +-
 drivers/power/sequencing/core.c                    |  14 +-
 drivers/rpmsg/rpmsg_char.c                         |  15 +-
 drivers/tty/serial/8250/8250_dw.c                  |   4 +-
 drivers/video/fbdev/core/fbmem.c                   |  12 +
 drivers/video/fbdev/core/fbsysfs.c                 |  10 +-
 drivers/video/fbdev/core/modedb.c                  |   5 +-
 fs/backing-file.c                                  |  17 +-
 fs/exfat/dir.c                                     |   4 +-
 fs/f2fs/acl.c                                      |  18 +-
 fs/f2fs/checkpoint.c                               |  14 +-
 fs/f2fs/data.c                                     |  16 +-
 fs/f2fs/extent_cache.c                             |  19 +-
 fs/f2fs/file.c                                     |   9 +-
 fs/f2fs/inode.c                                    |   9 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/file_table.c                                    |  27 ++-
 fs/fuse/passthrough.c                              |   2 +-
 fs/gfs2/super.c                                    |   1 +
 fs/internal.h                                      |   3 +-
 fs/lockd/svc4proc.c                                |  13 +-
 fs/lockd/svclock.c                                 |   4 +-
 fs/lockd/svcproc.c                                 |  15 +-
 fs/lockd/svcsubs.c                                 |  35 ++-
 fs/nfs/client.c                                    |   1 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |   4 +
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/nfs/pnfs.c                                      |   2 +-
 fs/nfs/pnfs_nfs.c                                  |   4 +-
 fs/nfsd/nfs2acl.c                                  |  17 +-
 fs/nfsd/nfs3acl.c                                  |  17 +-
 fs/nfsd/nfs4proc.c                                 |   2 +-
 fs/nfsd/nfs4recover.c                              |   3 +-
 fs/nfsd/nfs4state.c                                |   1 +
 fs/nfsd/nfs4xdr.c                                  |   3 +-
 fs/nfsd/vfs.c                                      |   6 +-
 fs/ntfs3/xattr.c                                   |  12 +
 fs/ocfs2/suballoc.c                                |  22 ++
 fs/overlayfs/dir.c                                 |   2 +-
 fs/overlayfs/file.c                                |   2 +-
 fs/smb/server/smbacl.c                             |   4 +-
 fs/userfaultfd.c                                   |   2 +
 include/keys/request_key_auth-type.h               |   2 +
 include/linux/backing-file.h                       |   4 +-
 include/linux/blkdev.h                             |  16 +-
 include/linux/err.h                                |  12 +-
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/fs.h                                 |  13 ++
 include/linux/kvm_host.h                           |   7 +-
 include/linux/lockd/lockd.h                        |   2 +-
 include/linux/lsm_audit.h                          |   2 +-
 include/linux/lsm_hook_defs.h                      |   5 +
 include/linux/lsm_hooks.h                          |   1 +
 include/linux/security.h                           |  22 ++
 include/linux/skmsg.h                              |  15 +-
 include/net/rtnetlink.h                            |   2 +
 kernel/bpf/cgroup.c                                |   2 +-
 kernel/sched/core.c                                |  12 +-
 net/9p/client.c                                    |   3 +-
 net/batman-adv/bat_iv_ogm.c                        |  11 +-
 net/batman-adv/bat_v.c                             |   1 +
 net/batman-adv/bat_v_ogm.c                         |  23 +-
 net/batman-adv/bridge_loop_avoidance.c             |  28 +--
 net/batman-adv/distributed-arp-table.c             |  12 +-
 net/batman-adv/fragmentation.c                     |  22 +-
 net/batman-adv/fragmentation.h                     |   3 +-
 net/batman-adv/hard-interface.c                    |  28 +--
 net/batman-adv/netlink.c                           |  10 +-
 net/batman-adv/routing.c                           |  73 +++++-
 net/batman-adv/tp_meter.c                          | 115 +++++----
 net/batman-adv/translation-table.c                 |  12 +-
 net/batman-adv/tvlv.c                              |  69 +++++-
 net/batman-adv/types.h                             |  21 +-
 net/core/filter.c                                  |  27 +++
 net/core/rtnetlink.c                               |   8 +
 net/core/skmsg.c                                   |   2 +
 net/ipv4/ip_gre.c                                  |   6 +
 net/ipv4/ip_output.c                               |   7 +-
 net/ipv4/tcp_ao.c                                  |   4 +
 net/ipv6/ip6_output.c                              |   9 +-
 net/mac802154/llsec.c                              |  14 ++
 net/tipc/crypto.c                                  |   9 +
 net/tls/tls_sw.c                                   |   4 +
 net/unix/garbage.c                                 |   2 +
 security/apparmor/include/policy_unpack.h          |  19 ++
 security/apparmor/lsm.c                            |  16 +-
 security/apparmor/net.c                            |   2 +
 security/apparmor/policy.c                         |   8 +-
 security/keys/internal.h                           |   2 +
 security/keys/keyctl.c                             |  24 +-
 security/keys/keyctl_pkey.c                        |   9 +-
 security/keys/request_key_auth.c                   |  33 ++-
 security/security.c                                | 109 +++++++++
 security/selinux/hooks.c                           | 256 +++++++++++++++------
 security/selinux/include/objsec.h                  |  11 +
 virt/kvm/eventfd.c                                 |  12 +-
 127 files changed, 1368 insertions(+), 412 deletions(-)


