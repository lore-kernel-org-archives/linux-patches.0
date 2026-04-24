Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D3F3290A5;
	Fri, 24 Apr 2026 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038115; cv=none; b=IuqOQ61bRvGLw0iXLDw6oKsH2Gut3pGChe6g57Oxk7AiVPwWkQAnqxJb4h6dpSH3ss08dnJHRWnIheZJKQaMUCpozTrLw2DEignZhAbcdZ0jdutcc5bZCD0SNb1/tSFth1hGvIQAgUFTZyei3io4CTNDHYtUcmTU90xnx4vLBU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038115; c=relaxed/simple;
	bh=XZ3sFBWErwic4kk9E/jywu+ghezv7r3+U8PVJgTO5EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mL43dGBY9HooiG20JCNBMGNNjOMvV7iSaVVmB4Zd36NVi5bZvPPiToGpKjQFwKeTrCYUyQ4/EyOZ7yVpy9yRsRyV5bUZqaqSY4upldSkJLM3s5DSIHj9LD6TwSwto17GdRUf7KVlXVvD/M7wb0kANaZSIgpDNT8L+m9sbNNUmWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR/LPita; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR/LPita"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5CBC19425;
	Fri, 24 Apr 2026 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038114;
	bh=XZ3sFBWErwic4kk9E/jywu+ghezv7r3+U8PVJgTO5EM=;
	h=From:To:Cc:Subject:Date:From;
	b=ZR/LPita8FF5ZzundFJxY2KjvW6lcISfWMRXENwgWvtUVKiN0opTSMcL/36fhLRbT
	 F8QLXiesR6RLt4famPxtqUWrGlJxuwgXaGMNtiWbyaIl/AIPFxHolLXcU0rZNGef4V
	 IL7NdwDc45V3paly7Z95F2rBLr5LQj2C6ivglO74=
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
Subject: [PATCH 6.18 00/55] 6.18.25-rc1 review
Date: Fri, 24 Apr 2026 15:30:39 +0200
Message-ID: <20260424132430.006424517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.25-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.25-rc1
X-KernelTest-Deadline: 2026-04-26T13:24+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.25 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.25-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.25-rc1

Anderson Nascimento <anderson@allelesecurity.com>
    rxrpc: Fix missing validation of ticket length in non-XDR key preparsing

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Don't attempt to copy ID to userspace if PSP command failed

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Don't attempt to copy PDH cert to userspace if PSP command failed

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Don't attempt to copy CSR to userspace if PSP command failed

Bingquan Chen <patzilla007@gmail.com>
    net/packet: fix TOCTOU race on mmap'd vnet_hdr in tpacket_snd()

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: caiaq: take a reference on the USB device in create_card()

Eric Naim <dnaim@cachyos.org>
    ALSA: hda/realtek: Add quirk for Legion S7 15IMH

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    ALSA: usb-audio: apply quirk for MOONDROP JU Jiu

George Saad <geoo115@gmail.com>
    f2fs: fix use-after-free of sbi in f2fs_compress_write_end_io()

Jan Kara <jack@suse.cz>
    writeback: Fix use after free in inode_switch_wbs_work_fn()

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()

Tristan Madani <tristan@talencesecurity.com>
    ksmbd: use check_add_overflow() to prevent u16 DACL size overflow

Tristan Madani <tristan@talencesecurity.com>
    ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: validate response sizes in ipc_validate_msg()

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: fix OOB read in smb2_ioctl_query_info QUERY_INFO path

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: require a full NFS mode SID before reading mode bits

DaeMyung Kang <charsyam@gmail.com>
    smb: server: fix max_connections off-by-one in tcp accept path

Michael Bommarito <michael.bommarito@gmail.com>
    smb: server: fix active_num_conn leak on transport allocation failure

Michael Bommarito <michael.bommarito@gmail.com>
    ksmbd: require minimum ACE size in smb_check_perm_dacl()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fuse_dev_ioctl_clone() should wait for device file to be initialized

Darrick J. Wong <djwong@kernel.org>
    fuse: quiet down complaints in fuse_conn_limit_write

Bernd Schubert <bschubert@ddn.com>
    fuse: Check for large folio with SPLICE_F_MOVE

Miklos Szeredi <mszeredi@redhat.com>
    fuse: abort on fatal signal during sync init

Samuel Page <sam@bynar.io>
    fuse: reject oversized dirents in page cache

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid uninit-value access in f2fs_sanity_check_node_footer

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid memory leak in f2fs_rename()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on dcc->discard_cmd_cnt conditionally

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fs/ntfs3: validate rec->used in journal-replay file record check

Nathan Chancellor <nathan@kernel.org>
    scripts/dtc: Remove unused dts_version in dtc-lexer.l

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: tests: Drop the default to CRYPTO_SELFTESTS

Eric Biggers <ebiggers@kernel.org>
    kunit: configs: Enable all crypto library tests in all_tests.config

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: tests: Introduce CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: tests: Add a .kunitconfig file

Eric Biggers <ebiggers@kernel.org>
    kunit: configs: Enable all CRC tests in all_tests.config

Eric Biggers <ebiggers@kernel.org>
    lib/crc: tests: Add a .kunitconfig file

Eric Biggers <ebiggers@kernel.org>
    lib/crc: tests: Add CRC_ENABLE_ALL_FOR_KUNIT

Eric Biggers <ebiggers@kernel.org>
    lib/crc: tests: Make crc_kunit test only the enabled CRC variants

Peter Zijlstra <peterz@infradead.org>
    sched/debug: Fix avg_vruntime() usage

Catalin Marinas <catalin.marinas@arm.com>
    arm64: errata: Work around early CME DVMSync acknowledgement

Catalin Marinas <catalin.marinas@arm.com>
    arm64: cputype: Add C1-Pro definitions

Catalin Marinas <catalin.marinas@arm.com>
    arm64: tlb: Pass the corresponding mm to __tlbi_sync_s1ish()

Catalin Marinas <catalin.marinas@arm.com>
    arm64: tlb: Introduce __tlbi_sync_s1ish_{kernel,batch}() for TLB maintenance

Mark Rutland <mark.rutland@arm.com>
    arm64: tlb: Optimize ARM64_WORKAROUND_REPEAT_TLBI

Mark Rutland <mark.rutland@arm.com>
    arm64: tlb: Allow XZR argument to TLBI ops

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate owner of durable handle on reconnect

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __ksmbd_close_fd() via durable scavenger

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer.py: define scripts

Dudu Lu <phx0fer@gmail.com>
    crypto: krb5enc - fix async decrypt skipping hash verification

Wesley Atwell <atwellwea@gmail.com>
    crypto: krb5enc - fix sleepable flag handling in encrypt dispatch

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amdgpu: replace PASID IDR with XArray

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: initialize PPE per-tag-layer MTU registers

Minhong He <heminhong@kylinos.cn>
    ipv6: add NULL checks for idev in SRv6 paths

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authencesn - Fix src offset when decrypting in-place


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst  |   2 +
 Makefile                                     |   4 +-
 arch/arm64/Kconfig                           |  12 +++
 arch/arm64/include/asm/cpucaps.h             |   2 +
 arch/arm64/include/asm/cputype.h             |   2 +
 arch/arm64/include/asm/fpsimd.h              |  21 ++++
 arch/arm64/include/asm/tlbbatch.h            |  10 +-
 arch/arm64/include/asm/tlbflush.h            | 143 ++++++++++++++++++++++-----
 arch/arm64/kernel/cpu_errata.c               |  30 ++++++
 arch/arm64/kernel/entry-common.c             |   3 +
 arch/arm64/kernel/fpsimd.c                   |  79 +++++++++++++++
 arch/arm64/kernel/process.c                  |  36 +++++++
 arch/arm64/kernel/sys_compat.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                 |   2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                |   8 +-
 arch/arm64/kvm/hyp/pgtable.c                 |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                 |  10 +-
 arch/arm64/tools/cpucaps                     |   1 +
 crypto/authencesn.c                          |   6 +-
 crypto/krb5enc.c                             |  51 ++++++----
 drivers/crypto/ccp/sev-dev.c                 |  19 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c      |  39 ++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  |  22 ++++-
 drivers/net/ethernet/mediatek/mtk_ppe.c      |  30 ++++++
 drivers/net/ethernet/mediatek/mtk_ppe.h      |   1 +
 fs/f2fs/compress.c                           |  14 ++-
 fs/f2fs/data.c                               |   7 +-
 fs/f2fs/f2fs.h                               |   2 +-
 fs/f2fs/namei.c                              |   1 +
 fs/f2fs/segment.c                            |   6 +-
 fs/f2fs/super.c                              |  11 ++-
 fs/fs-writeback.c                            |  36 +++----
 fs/fuse/control.c                            |   4 +-
 fs/fuse/dev.c                                |  30 +++---
 fs/fuse/fuse_i.h                             |   1 +
 fs/fuse/inode.c                              |   1 +
 fs/fuse/readdir.c                            |   4 +
 fs/ntfs3/fslog.c                             |  12 ++-
 fs/smb/client/cifsacl.c                      |   1 +
 fs/smb/client/smb2ops.c                      |   6 ++
 fs/smb/server/connection.c                   |   5 +-
 fs/smb/server/mgmt/user_config.c             |   6 --
 fs/smb/server/mgmt/user_session.c            |   7 +-
 fs/smb/server/oplock.c                       |   7 ++
 fs/smb/server/oplock.h                       |   1 +
 fs/smb/server/smb2pdu.c                      |   5 +-
 fs/smb/server/smbacl.c                       |  61 +++++++++---
 fs/smb/server/transport_ipc.c                |  16 ++-
 fs/smb/server/transport_tcp.c                |   4 +-
 fs/smb/server/vfs_cache.c                    | 128 ++++++++++++++++++++----
 fs/smb/server/vfs_cache.h                    |  12 ++-
 kernel/sched/debug.c                         |   4 +-
 lib/crc/.kunitconfig                         |   3 +
 lib/crc/Kconfig                              |  21 ++--
 lib/crc/tests/crc_kunit.c                    |  28 ++++--
 lib/crypto/.kunitconfig                      |  11 +++
 lib/crypto/tests/Kconfig                     |  32 ++++--
 net/ipv6/exthdrs.c                           |   4 +
 net/ipv6/seg6_hmac.c                         |   2 +
 net/packet/af_packet.c                       |  21 ++--
 net/rxrpc/key.c                              |   4 +
 scripts/dtc/dtc-lexer.l                      |   3 -
 scripts/generate_rust_analyzer.py            |  14 ++-
 sound/hda/codecs/realtek/alc269.c            |   1 +
 sound/usb/caiaq/device.c                     |   4 +-
 sound/usb/mixer.c                            |   7 ++
 tools/testing/kunit/configs/all_tests.config |   4 +
 67 files changed, 870 insertions(+), 218 deletions(-)


