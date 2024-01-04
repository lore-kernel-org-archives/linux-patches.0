Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F3620305
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 07:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsSBVY+8"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5cec32dedf3so137739a12.0
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 23:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704354914; x=1704959714; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thELQt+jJStLaTs0SK0jv3blwIe6CCuApqMHQi68vpE=;
        b=fsSBVY+84+8kcv/L1PFDJ06CE6zgicLLg9q6QySusfOYr6+XcakyJo2k+wgu9ATMJ5
         1AKZnASdmZud+lGzJ5o8DJR75GprnUO622vdFo92aRghfgtZlblCMRxoV2Q7AgfPB6Vm
         YX/4xRMwkqxy4so/Olzyi8oXrxQ677/uQ2px8LoXbxJ1qrvGXQl74uocNGpDS2RxvZBa
         71D+jj7epcdLj/pznmSJsds9sSGoFvUg6rstsRMrzgdrcR/Xxgc+iTx2rDvmrpXfgIcQ
         QPrNKOVM54csdOOgwBSa8brKEE20UOnQboVjypNDcZD2yDC1TkCGc9ZBdoOrpvrSjMTt
         j8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704354914; x=1704959714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thELQt+jJStLaTs0SK0jv3blwIe6CCuApqMHQi68vpE=;
        b=aykqiVOafMLBvn7l67s6UFopki5h0Bvj4WAY5vE+Mq9pV7S8kb4MNOXuBvnBIvVo9H
         2U/dUkbYFm9vTkhqyHmMaliVofCz+TNdpFuzFGK5bjAKQny3zqYBQoYJ9XO7MTAL8X1X
         x09RqeOJ+bXcUE+pja5+XDB819RS89okXqXkm3Kf3WfGQpEwgC0DBN+W8BNu+rmEiSis
         T98SkL0EF4KbbgZgsoL5fkxiDbI/PmdqP18xJyDBS8jyU8Q2CT6eEUSt9s26y0gLm4F+
         ym60djDjmfE5raVX+kbmzocD2VoBk+7da5xlesi6/OIs2DiCEVMsoZGKpx5D7zTzSiZy
         iUIg==
X-Gm-Message-State: AOJu0Yz9mm3uQqd8aOxw0tzaUAOs4lyZ3acNojGoVql9zb9PWcZy8Cu3
	kFB4yD5xT2pl1JDLVpZbAv8CkHkI2kpMLQPyng0=
X-Google-Smtp-Source: AGHT+IFI73v/6TfZ1EDje8MFqjY1bVatog9mEBZ85DA+lpHsm7Ax9qkxcUELS3xNPe7ldb2qxSp24wzYpP9w75dC8po=
X-Received: by 2002:a05:6a20:12c2:b0:196:4c53:52db with SMTP id
 v2-20020a056a2012c200b001964c5352dbmr157073pzg.47.1704354914365; Wed, 03 Jan
 2024 23:55:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240103164834.970234661@linuxfoundation.org>
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Thu, 4 Jan 2024 07:55:02 +0000
Message-ID: <CADo9pHiP8rXxLrGdsH5o+0KbR0f8XO+G1a=OgNW6UfD0s_hwAQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Luna Jernberg <droidbittin@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tried to follow this guide:
https://wiki.archlinux.org/title/Kernel/Traditional_compilation to
compile it on Crystal Linux based on Arch Linux on a Dell Latitude
7390 laptop with a Intel i5-8350U and did not get it to boot
but the same process worked for the stable 6.6.9 kernel, so guess i
will just wait for the stable 6.6.10 and try when thats out

Den ons 3 jan. 2024 kl 17:13 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.6.10-rc1
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: skip set commit for deleted/destroyed sets
>
> L=C3=A9o Lam <leo@leolam.fr>
>     wifi: nl80211: fix deadlock in nl80211_set_cqm_rssi (6.6.x)
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: fix CQM for non-range use
>
> Steven Rostedt (Google) <rostedt@goodmis.org>
>     tracing: Fix blocked reader of snapshot buffer
>
> Steven Rostedt (Google) <rostedt@goodmis.org>
>     ftrace: Fix modification of direct_function hash while in use
>
> Steven Rostedt (Google) <rostedt@goodmis.org>
>     ring-buffer: Fix wake ups when buffer_percent is set to 100
>
> Keith Busch <kbusch@kernel.org>
>     Revert "nvme-fc: fix race between error recovery and creating associa=
tion"
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     mm/memory-failure: check the mapcount of the precise page
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     mm/memory-failure: cast index to loff_t before shifting it
>
> Charan Teja Kalla <quic_charante@quicinc.com>
>     mm: migrate high-order folios in swap cache correctly
>
> Baokun Li <libaokun1@huawei.com>
>     mm/filemap: avoid buffered read/write race to read inconsistent data
>
> Muhammad Usama Anjum <usama.anjum@collabora.com>
>     selftests: secretmem: floor the memory size to the multiple of page_s=
ize
>
> Sidhartha Kumar <sidhartha.kumar@oracle.com>
>     maple_tree: do not preallocate nodes for slot stores
>
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>     platform/x86: p2sb: Allow p2sb_bar() calls during PCI device probe
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
>
> David E. Box <david.e.box@linux.intel.com>
>     platform/x86/intel/pmc: Move GBE LTR ignore to suspend callback
>
> David E. Box <david.e.box@linux.intel.com>
>     platform/x86/intel/pmc: Allow reenabling LTRs
>
> David E. Box <david.e.box@linux.intel.com>
>     platform/x86/intel/pmc: Add suspend callback
>
> Christoph Hellwig <hch@lst.de>
>     block: renumber QUEUE_FLAG_HW_WC
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: fix inconsistent state on fastopen race
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: fix possible NULL pointer dereference on close
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: refactor sndbuf auto-tuning
>
> Helge Deller <deller@gmx.de>
>     linux/export: Ensure natural alignment of kcrctab array
>
> Helge Deller <deller@gmx.de>
>     linux/export: Fix alignment for 64-bit ksymtab entries
>
> Arnd Bergmann <arnd@arndb.de>
>     kexec: select CRYPTO from KEXEC_FILE instead of depending on it
>
> Arnd Bergmann <arnd@arndb.de>
>     kexec: fix KEXEC_FILE dependencies
>
> Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>     virtio_ring: fix syncs DMA memory with different direction
>
> Zizhi Wo <wozizhi@huawei.com>
>     fs: cifs: Fix atime update check
>
> Jeff Layton <jlayton@kernel.org>
>     client: convert to new timestamp accessors
>
> Jeff Layton <jlayton@kernel.org>
>     fs: new accessor methods for atime and mtime
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: avoid duplicate opinfo_put() call on error of smb21_lease_brea=
k_ack()
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: lazy v2 lease break on smb2_write()
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: send v2 lease break notification for directory
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: downgrade RWH lease caching state to RH for directory
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: set v2 lease capability
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: set epoch in create context v2 lease
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: don't update ->op_state as OPLOCK_STATE_NONE on error
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: move setting SMB2_FLAGS_ASYNC_COMMAND and AsyncId
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: release interim response after sending status pending response
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: move oplock handling after unlock parent dir
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: separately allocate ci per dentry
>
> Zongmin Zhou <zhouzongmin@kylinos.cn>
>     ksmbd: prevent memory leak on error return
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix kernel-doc comment of ksmbd_vfs_kern_path_locked()
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: no need to wait for binded connection termination at logoff
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: add support for surrogate pair conversion
>
> Kangjing Huang <huangkangjing@gmail.com>
>     ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_c=
apable_netdev()
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix kernel-doc comment of ksmbd_vfs_setxattr()
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: reorganize ksmbd_iov_pin_rsp()
>
> Cheng-Han Wu <hank20010209@gmail.com>
>     ksmbd: Remove unused field in ksmbd_user struct
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                  |   4 +-
>  arch/powerpc/Kconfig                      |   4 +-
>  arch/riscv/Kconfig                        |   4 +-
>  arch/s390/Kconfig                         |   4 +-
>  arch/x86/Kconfig                          |   4 +-
>  drivers/nvme/host/fc.c                    |  21 +--
>  drivers/platform/x86/intel/pmc/adl.c      |   9 +-
>  drivers/platform/x86/intel/pmc/cnp.c      |  26 ++-
>  drivers/platform/x86/intel/pmc/core.c     |  12 +-
>  drivers/platform/x86/intel/pmc/core.h     |   7 +-
>  drivers/platform/x86/intel/pmc/mtl.c      |   9 +-
>  drivers/platform/x86/intel/pmc/tgl.c      |   9 +-
>  drivers/platform/x86/p2sb.c               | 178 ++++++++++++++++-----
>  drivers/virtio/virtio_ring.c              |   6 +-
>  fs/libfs.c                                |  41 +++--
>  fs/smb/client/file.c                      |  18 ++-
>  fs/smb/client/fscache.h                   |   6 +-
>  fs/smb/client/inode.c                     |  17 +-
>  fs/smb/client/smb2ops.c                   |   6 +-
>  fs/smb/common/smb2pdu.h                   |   1 +
>  fs/smb/server/connection.c                |  16 --
>  fs/smb/server/ksmbd_work.c                |  51 +++---
>  fs/smb/server/mgmt/user_config.h          |   1 -
>  fs/smb/server/oplock.c                    | 118 ++++++++++++--
>  fs/smb/server/oplock.h                    |   8 +-
>  fs/smb/server/smb2misc.c                  |  15 +-
>  fs/smb/server/smb2ops.c                   |   9 +-
>  fs/smb/server/smb2pdu.c                   | 258 ++++++++++++++++--------=
------
>  fs/smb/server/transport_rdma.c            |  40 +++--
>  fs/smb/server/unicode.c                   | 187 ++++++++++++++++------
>  fs/smb/server/vfs.c                       |  14 +-
>  fs/smb/server/vfs_cache.c                 |  30 ++--
>  fs/smb/server/vfs_cache.h                 |   9 +-
>  include/linux/blkdev.h                    |   2 +-
>  include/linux/export-internal.h           |   6 +-
>  include/linux/fs.h                        |  85 ++++++++--
>  kernel/Kconfig.kexec                      |   2 +
>  kernel/trace/ftrace.c                     | 100 ++++++------
>  kernel/trace/ring_buffer.c                |  12 +-
>  kernel/trace/trace.c                      |  20 ++-
>  lib/maple_tree.c                          |  11 ++
>  mm/filemap.c                              |   9 ++
>  mm/memory-failure.c                       |   8 +-
>  mm/migrate.c                              |   9 +-
>  net/mptcp/protocol.c                      |  27 +++-
>  net/mptcp/protocol.h                      |  63 +++++++-
>  net/mptcp/sockopt.c                       |   5 +-
>  net/mptcp/subflow.c                       |  29 ++--
>  net/netfilter/nf_tables_api.c             |   2 +-
>  net/wireless/core.h                       |   1 +
>  net/wireless/nl80211.c                    |  56 ++++---
>  tools/testing/radix-tree/maple.c          |   2 +-
>  tools/testing/selftests/mm/memfd_secret.c |   3 +
>  53 files changed, 1070 insertions(+), 524 deletions(-)
>
>
>
