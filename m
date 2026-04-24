Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F6A78F4A;
	Fri, 24 Apr 2026 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037582; cv=none; b=jAT5gM3p3mzXFRaqmz/cMDtOUqoH2SNDMFFocRbguhKyVoQuMK8rRoCwYsg90MfwS+VBJ4XEJZ9CyvDUrqvkNf3TUBjqpla9l52an3jxSBf5FsdPZ0hPy8y11DYfb7oJgXgvpQpBdNk7G8g5Lg//Z48OPiDrkFcy/+zE1NBfYv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037582; c=relaxed/simple;
	bh=VIWzpAFc0nPhjAD5Ay9KXyy6EEh86JPZZi92K55JpOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=me0bQEdqARHuvDIXQvP1tQiHfxqPPgj9fqOxvshC4V6RZcIwMIpda474lPWAfO4jIEbVipui1oEhHqoaViQMhAmeNfQomJa21aC9469r/PjDvNJpHLcxFcJLn74uFmmH3EmlemnX/MYLlzL5VoMcaN//+C8a4ya8hMUKX/WyA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cf9VXOSB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cf9VXOSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F3BC2BCB9;
	Fri, 24 Apr 2026 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037582;
	bh=VIWzpAFc0nPhjAD5Ay9KXyy6EEh86JPZZi92K55JpOo=;
	h=From:To:Cc:Subject:Date:From;
	b=Cf9VXOSBo+EyZUuaQcYzM0KBKpT9LrGY7+oISZU7x3Bg4OcLsTVY4IAFpgcKwyaHX
	 5esOIdzB+dO42RVeNDNgJWxKELrdeauX6PqyC/yIDxR/sWuGthJN7d2uG7RXdzZGWC
	 pZAAv2bQjd9dttelebg/dFpoU8A5vNHrx8eYM8c0=
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
Subject: [PATCH 7.0 00/42] 7.0.2-rc1 review
Date: Fri, 24 Apr 2026 15:30:25 +0200
Message-ID: <20260424132420.410310336@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.0.2-rc1
X-KernelTest-Deadline: 2026-04-26T13:24+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.0.2 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.0.2-rc1

Naman Jain <namjain@linux.microsoft.com>
    mshv_vtl: Fix vmemmap_shift exceeding MAX_FOLIO_ORDER

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
    smb: client: validate the whole DACL before rewriting it in cifsacl

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: require a full NFS mode SID before reading mode bits

DaeMyung Kang <charsyam@gmail.com>
    smb: server: fix max_connections off-by-one in tcp accept path

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix dir separator in SMB1 UNIX mounts

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

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer.py: define scripts

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate owner of durable handle on reconnect

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __ksmbd_close_fd() via durable scavenger

Dudu Lu <phx0fer@gmail.com>
    crypto: krb5enc - fix async decrypt skipping hash verification

Wesley Atwell <atwellwea@gmail.com>
    crypto: krb5enc - fix sleepable flag handling in encrypt dispatch

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amdgpu: replace PASID IDR with XArray

Miguel Ojeda <ojeda@kernel.org>
    pwm: th1520: fix `CLIPPY=1` warning

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authencesn - Fix src offset when decrypting in-place


-------------

Diffstat:

 Makefile                                |   4 +-
 crypto/authencesn.c                     |   6 +-
 crypto/krb5enc.c                        |  51 ++++++++-----
 drivers/crypto/ccp/sev-dev.c            |  19 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c |  39 +++++-----
 drivers/hv/mshv_vtl_main.c              |  12 ++-
 drivers/pwm/pwm_th1520.rs               |   5 +-
 fs/f2fs/compress.c                      |  14 +++-
 fs/f2fs/data.c                          |   7 +-
 fs/f2fs/f2fs.h                          |   2 +-
 fs/f2fs/namei.c                         |   1 +
 fs/f2fs/segment.c                       |   6 +-
 fs/f2fs/super.c                         |  11 ++-
 fs/fs-writeback.c                       |  36 ++++-----
 fs/fuse/control.c                       |   4 +-
 fs/fuse/dev.c                           |  30 +++++---
 fs/fuse/fuse_i.h                        |   1 +
 fs/fuse/inode.c                         |   1 +
 fs/fuse/readdir.c                       |   4 +
 fs/ntfs3/fslog.c                        |  12 ++-
 fs/smb/client/cifsacl.c                 | 117 +++++++++++++++++++++--------
 fs/smb/client/connect.c                 |  10 +--
 fs/smb/client/smb1ops.c                 |  19 ++---
 fs/smb/client/smb2ops.c                 |   6 ++
 fs/smb/server/connection.c              |   5 +-
 fs/smb/server/mgmt/user_config.c        |   6 --
 fs/smb/server/mgmt/user_session.c       |   8 +-
 fs/smb/server/oplock.c                  |   7 ++
 fs/smb/server/oplock.h                  |   1 +
 fs/smb/server/smb2pdu.c                 |   5 +-
 fs/smb/server/smbacl.c                  |  61 +++++++++++----
 fs/smb/server/transport_ipc.c           |  16 +++-
 fs/smb/server/transport_tcp.c           |   4 +-
 fs/smb/server/vfs_cache.c               | 128 +++++++++++++++++++++++++++-----
 fs/smb/server/vfs_cache.h               |  12 ++-
 include/uapi/linux/mshv.h               |   2 +-
 net/packet/af_packet.c                  |  21 ++++--
 net/rxrpc/key.c                         |   4 +
 scripts/dtc/dtc-lexer.l                 |   3 -
 scripts/generate_rust_analyzer.py       |  14 +++-
 sound/hda/codecs/realtek/alc269.c       |   1 +
 sound/usb/caiaq/device.c                |   4 +-
 sound/usb/mixer.c                       |   7 ++
 43 files changed, 513 insertions(+), 213 deletions(-)


