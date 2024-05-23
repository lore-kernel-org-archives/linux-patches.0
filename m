Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3387F14AD0C;
	Thu, 23 May 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470599; cv=none; b=mh+fhxifn48VOUt8JJqARVEbYBhUIY9XBioXNZS214avwlwNbGhCHgtSaeZFUTgPppkY7MNJtOCpoeqqvdsaY69JEjLjD81W2Na2RfG1IEXGCqRPbpdeeybfnq6Lq/uelcKbil4FQzt+NiWqQMNQNJhLo4ZuqA+1GoymfiFGlY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470599; c=relaxed/simple;
	bh=OSNsX9KcyJSrBsQyi40BgVh/UcxaLMdvP+OxOICZHG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ghAkuI4lCqHZEgxWjALWIw05mtNz+43luozR4SdqeiwQt+rQjf9xwsqAosWfOXVQWVn9dBCiRQorchWGsnbgTGh9mp1B547UTCy5LcAImMflbE7R98Y/kvXD31zWco5vcJbpjVJ24+2kPYd4AM0d/RaYoU71NxzmI+BDBDH5WIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPrHFJDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPrHFJDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9DDC2BD10;
	Thu, 23 May 2024 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470599;
	bh=OSNsX9KcyJSrBsQyi40BgVh/UcxaLMdvP+OxOICZHG0=;
	h=From:To:Cc:Subject:Date:From;
	b=OPrHFJDn9SlYLQmrgCLGWiNiPxHfj3gcc6eP5PimW9Zgd5fds4KBFrqsLCfcC/IqH
	 /btMIX3tggxFOLhg5hUJYvegf5DWvFHlYuOayOlaVnznfMaHO2dlH7isFJrx+MB2X5
	 OLMe4TKyhlbyvIG8r68zwb/aesMlvsd0WUEAsEA0=
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
Subject: [PATCH 6.6 000/102] 6.6.32-rc1 review
Date: Thu, 23 May 2024 15:12:25 +0200
Message-ID: <20240523130342.462912131@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.32-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.32 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.32-rc1

Christoph Hellwig <hch@lst.de>
    block: add a partscan sysfs attribute for disks

Christoph Hellwig <hch@lst.de>
    block: add a disk_has_partscan helper

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file

Akira Yokosawa <akiyks@gmail.com>
    docs: kernel_include.py: Cope with docutils 0.21

Thomas Weißschuh <linux@weissschuh.net>
    admin-guide/hw-vuln/core-scheduling: fix return type of PR_SCHED_CORE_GET

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Do not use WARN when encode fails

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    remoteproc: mediatek: Make sure IPI buffer fits in L2TCM

Daniel Thompson <daniel.thompson@linaro.org>
    serial: kgdboc: Fix NMI-safety problems from keyboard reset code

Javier Carrasco <javier.carrasco@wolfvision.net>
    usb: typec: tipd: fix event checking for tps6598x

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix potential deadlock

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: fix link status when link is set to down/up

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Wait unconditionally after issuing EndXfer command

Carlos Llamas <cmllamas@google.com>
    binder: fix max_thread type inconsistency

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()

Christian Brauner <brauner@kernel.org>
    erofs: reliably distinguish block based and fscache mode

Baokun Li <libaokun1@huawei.com>
    erofs: get rid of erofs_fs_context

Jiri Olsa <jolsa@kernel.org>
    bpf: Add missing BPF_LINK_TYPE invocations

Mark Brown <broonie@kernel.org>
    kselftest: Add a ksft_perror() helper

Mengqi Zhang <mengqi.zhang@mediatek.com>
    mmc: core: Add HS400 tuning in HS400es initialization

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix memory leak in tpm2_key_encode()

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix slab-use-after-free in l2cap_connect()

Jacob Keller <jacob.e.keller@intel.com>
    ice: remove unnecessary duplicate checks for VF VSI ID

Jacob Keller <jacob.e.keller@intel.com>
    ice: pass VSI pointer into ice_vc_isvalid_q_id

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix another TX stall caused by wrong ISR flag handling

Jose Fernandez <josef@netflix.com>
    drm/amd/display: Fix division by zero in setup_dsc_config

Gustavo A. R. Silva <gustavoars@kernel.org>
    smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-end warnings

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add continuous availability share parameter

David Howells <dhowells@redhat.com>
    cifs: Add tracing for the cifs_tcon struct refcounting

Paulo Alcantara <pc@manguebit.com>
    smb: client: instantiate when creating SFU files

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix NULL ptr deref in cifs_mark_open_handles_for_deleted_file()

Steve French <stfrench@microsoft.com>
    smb3: add trace event for mknod

Steve French <stfrench@microsoft.com>
    smb311: additional compression flag defined in updated protocol spec

Steve French <stfrench@microsoft.com>
    smb311: correct incorrect offset field in compression header

Steve French <stfrench@microsoft.com>
    cifs: Move some extern decls from .c files to .h

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potencial out-of-bounds when buffer offset is invalid

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()

Colin Ian King <colin.i.king@gmail.com>
    ksmbd: Fix spelling mistake "connction" -> "connection"

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: fix possible null-deref in smb_lazy_parent_lease_break_close

Bharath SM <bharathsm@microsoft.com>
    cifs: remove redundant variable assignment

Meetakshi Setiya <msetiya@microsoft.com>
    cifs: fixes for get_inode_info

Bharath SM <bharathsm@microsoft.com>
    cifs: defer close file handles having RH lease

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add support for durable handles v1/v2

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: mark SMB2_SESSION_EXPIRED to session when destroying previous session

Enzo Matsumiya <ematsumiya@suse.de>
    smb: common: simplify compression headers

Enzo Matsumiya <ematsumiya@suse.de>
    smb: common: fix fields sizes in compression_pattern_payload_v1

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: negotiate compression algorithms

Steve French <stfrench@microsoft.com>
    smb3: add dynamic trace point for ioctls

Paulo Alcantara <pc@manguebit.com>
    smb: client: return reparse type in /proc/mounts

Paulo Alcantara <pc@manguebit.com>
    smb: client: set correct d_type for reparse DFS/DFSR and mount point

Paulo Alcantara <pc@manguebit.com>
    smb: client: parse uid, gid, mode and dev from WSL reparse points

Steve French <stfrench@microsoft.com>
    smb: client: introduce SMB2_OP_QUERY_WSL_EA

Dan Carpenter <dan.carpenter@linaro.org>
    smb: client: Fix a NULL vs IS_ERR() check in wsl_set_xattrs()

Paulo Alcantara <pc@manguebit.com>
    smb: client: add support for WSL reparse points

Paulo Alcantara <pc@manguebit.com>
    smb: client: reduce number of parameters in smb2_compound_op()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential broken compound request

Paulo Alcantara <pc@manguebit.com>
    smb: client: move most of reparse point handling code to common file

Paulo Alcantara <pc@manguebit.com>
    smb: client: introduce reparse mount option

Meetakshi Setiya <msetiya@microsoft.com>
    smb: client: retry compound request without reusing lease

Steve French <stfrench@microsoft.com>
    smb: client: do not defer close open handles to deleted files

Meetakshi Setiya <msetiya@microsoft.com>
    smb: client: reuse file lease key in compound operations

Paulo Alcantara <pc@manguebit.com>
    smb: client: get rid of smb311_posix_query_path_info()

Steve French <stfrench@microsoft.com>
    smb: client: parse owner/group when creating reparse points

Steve French <stfrench@microsoft.com>
    smb3: update allocation size more accurately on write completion

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle path separator of created SMB symlinks

Steve French <stfrench@microsoft.com>
    cifs: update the same create_guid on replay

Yang Li <yang.lee@linux.alibaba.com>
    ksmbd: Add kernel-doc for ksmbd_extract_sharename() function

Shyam Prasad N <sprasad@microsoft.com>
    cifs: set replay flag for retries of write command

Shyam Prasad N <sprasad@microsoft.com>
    cifs: commands that are retried should have replay flag set

Alexey Dobriyan <adobriyan@gmail.com>
    smb: client: delete "true", "false" defines

Yang Li <yang.lee@linux.alibaba.com>
    smb: Fix some kernel-doc comments

Shyam Prasad N <sprasad@microsoft.com>
    cifs: new mount option called retrans

Paulo Alcantara <pc@manguebit.com>
    smb: client: don't clobber ->i_rdev from cached reparse points

Shyam Prasad N <sprasad@microsoft.com>
    cifs: new nt status codes from MS-SMB2

Shyam Prasad N <sprasad@microsoft.com>
    cifs: pick channel for tcon and tdis

Steve French <stfrench@microsoft.com>
    cifs: minor comment cleanup

Colin Ian King <colin.i.king@gmail.com>
    cifs: remove redundant variable tcon_exist

Randy Dunlap <rdunlap@infradead.org>
    ksmbd: vfs: fix all kernel-doc warnings

Randy Dunlap <rdunlap@infradead.org>
    ksmbd: auth: fix most kernel-doc warnings

Steve French <stfrench@microsoft.com>
    cifs: remove unneeded return statement

Paulo Alcantara <pc@manguebit.com>
    cifs: get rid of dup length check in parse_reparse_point()

David Howells <dhowells@redhat.com>
    cifs: Pass unbyteswapped eof value into SMB2_set_eof()

Markus Elfring <elfring@users.sourceforge.net>
    smb3: Improve exception handling in allocate_mr_list()

Steve French <stfrench@microsoft.com>
    cifs: fix in logging in cifs_chan_update_iface

Paulo Alcantara <pc@manguebit.com>
    smb: client: handle special files and symlinks in SMB3 POSIX

Paulo Alcantara <pc@manguebit.com>
    smb: client: cleanup smb2_query_reparse_point()

Paulo Alcantara <pc@manguebit.com>
    smb: client: allow creating symlinks via reparse points

Steve French <stfrench@microsoft.com>
    smb: client: optimise reparse point querying

Steve French <stfrench@microsoft.com>
    smb: client: allow creating special files via reparse points

Steve French <stfrench@microsoft.com>
    smb: client: extend smb2_compound_op() to accept more commands

Pierre Mariani <pierre.mariani@gmail.com>
    smb: client: Fix minor whitespace errors and warnings

Steve French <stfrench@microsoft.com>
    smb: client: introduce cifs_sfu_make_node()

Ritvik Budhiraja <rbudhiraja@microsoft.com>
    cifs: fix use after free for iface while disabling secondary channels

Steve French <stfrench@microsoft.com>
    Missing field not being returned in ioctl CIFS_IOC_GET_MNT_INFO

Steve French <stfrench@microsoft.com>
    smb3: minor cleanup of session handling code

Steve French <stfrench@microsoft.com>
    smb3: more minor cleanups for session handling routines

Steve French <stfrench@microsoft.com>
    smb3: minor RDMA cleanup

Shyam Prasad N <sprasad@microsoft.com>
    cifs: print server capabilities in DebugData

Eric Biggers <ebiggers@google.com>
    smb: use crypto_shash_digest() in symlink_hash()

Steve French <stfrench@microsoft.com>
    Add definition for new smb3.1.1 command type

Steve French <stfrench@microsoft.com>
    SMB3: clarify some of the unused CreateOption flags

Meetakshi Setiya <msetiya@microsoft.com>
    cifs: Add client version details to NTLM authenticate message


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-block               |   10 +
 .../admin-guide/hw-vuln/core-scheduling.rst        |    4 +-
 Documentation/admin-guide/mm/damon/usage.rst       |    2 +-
 Documentation/sphinx/kernel_include.py             |    1 -
 Makefile                                           |    4 +-
 block/genhd.c                                      |   15 +-
 block/partitions/core.c                            |    5 +-
 drivers/android/binder.c                           |    2 +-
 drivers/android/binder_internal.h                  |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |    3 +
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c        |    7 +-
 drivers/mmc/core/mmc.c                             |    9 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   22 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |    3 -
 drivers/net/ethernet/micrel/ks8851_common.c        |   18 +-
 drivers/net/usb/ax88179_178a.c                     |   37 +-
 drivers/remoteproc/mtk_scp.c                       |   10 +-
 drivers/tty/serial/kgdboc.c                        |   30 +-
 drivers/usb/dwc3/gadget.c                          |    4 +-
 drivers/usb/typec/tipd/core.c                      |   45 +-
 drivers/usb/typec/tipd/tps6598x.h                  |   11 +
 drivers/usb/typec/ucsi/displayport.c               |    4 -
 fs/erofs/internal.h                                |    7 -
 fs/erofs/super.c                                   |  124 +-
 fs/smb/client/Makefile                             |    2 +-
 fs/smb/client/cached_dir.c                         |   24 +-
 fs/smb/client/cifs_debug.c                         |   38 +-
 fs/smb/client/cifsfs.c                             |   10 +-
 fs/smb/client/cifsglob.h                           |   93 +-
 fs/smb/client/cifsproto.h                          |   39 +-
 fs/smb/client/cifssmb.c                            |   18 +-
 fs/smb/client/connect.c                            |   57 +-
 fs/smb/client/dir.c                                |   14 +-
 fs/smb/client/file.c                               |   39 +-
 fs/smb/client/fs_context.c                         |   43 +-
 fs/smb/client/fs_context.h                         |   13 +-
 fs/smb/client/fscache.c                            |    7 +
 fs/smb/client/inode.c                              |  235 ++--
 fs/smb/client/ioctl.c                              |    6 +
 fs/smb/client/link.c                               |   41 +-
 fs/smb/client/misc.c                               |   47 +-
 fs/smb/client/ntlmssp.h                            |    4 +-
 fs/smb/client/readdir.c                            |   32 +-
 fs/smb/client/reparse.c                            |  532 ++++++++
 fs/smb/client/reparse.h                            |  113 ++
 fs/smb/client/sess.c                               |   73 +-
 fs/smb/client/smb1ops.c                            |   80 +-
 fs/smb/client/smb2glob.h                           |   27 +-
 fs/smb/client/smb2inode.c                          | 1402 +++++++++++++-------
 fs/smb/client/smb2maperror.c                       |    2 +
 fs/smb/client/smb2misc.c                           |   10 +-
 fs/smb/client/smb2ops.c                            |  603 ++++-----
 fs/smb/client/smb2pdu.c                            |  340 ++++-
 fs/smb/client/smb2pdu.h                            |   46 +-
 fs/smb/client/smb2proto.h                          |   37 +-
 fs/smb/client/smb2status.h                         |    2 +
 fs/smb/client/smb2transport.c                      |    2 +
 fs/smb/client/smbdirect.c                          |    4 +-
 fs/smb/client/smbencrypt.c                         |    7 -
 fs/smb/client/trace.h                              |  137 +-
 fs/smb/common/smb2pdu.h                            |  122 +-
 fs/smb/common/smbfsctl.h                           |    6 -
 fs/smb/server/auth.c                               |   14 +-
 fs/smb/server/ksmbd_netlink.h                      |   36 +-
 fs/smb/server/mgmt/user_session.c                  |   28 +-
 fs/smb/server/mgmt/user_session.h                  |    3 +
 fs/smb/server/misc.c                               |    1 +
 fs/smb/server/oplock.c                             |   96 +-
 fs/smb/server/oplock.h                             |    7 +-
 fs/smb/server/smb2misc.c                           |   26 +-
 fs/smb/server/smb2ops.c                            |    6 +
 fs/smb/server/smb2pdu.c                            |  338 ++++-
 fs/smb/server/smb2pdu.h                            |   31 +-
 fs/smb/server/transport_tcp.c                      |    2 +
 fs/smb/server/vfs.c                                |   28 +-
 fs/smb/server/vfs_cache.c                          |  137 +-
 fs/smb/server/vfs_cache.h                          |    9 +
 include/linux/blkdev.h                             |   13 +
 include/linux/bpf_types.h                          |    3 +
 include/net/bluetooth/hci.h                        |    9 +
 include/net/bluetooth/hci_core.h                   |    1 +
 net/bluetooth/hci_conn.c                           |   71 +-
 net/bluetooth/hci_event.c                          |   31 +-
 net/bluetooth/iso.c                                |    2 +-
 net/bluetooth/l2cap_core.c                         |   38 +-
 net/bluetooth/sco.c                                |    6 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   25 +-
 tools/testing/selftests/kselftest.h                |   14 +
 88 files changed, 3923 insertions(+), 1738 deletions(-)


