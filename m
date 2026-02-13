Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF6023645D;
	Fri, 13 Feb 2026 13:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990651; cv=none; b=OoIfHL7nHvDlCufgSPb6yy7iwbaHRJ7QY88jXVXOrRJ+l7iT3QwEQqya4vgukkd3TBg7rUac9DGP0HOe2adCLbKHqjyWSkYhsVPz4qaQnVbmjYMLMSKaL9P9LqS1aBGEUl6OP8f0pUr3XpoGW4TkUMrLu5lxVRPGKsFDsc+f064=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990651; c=relaxed/simple;
	bh=vFafJNMvc0hI6jvS4k9LPLFaepBrZ0cP7VDvbPFQTIE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VOo9JVbAui43eyhN902VRotMCkhazX2SrxHwBTaXC+Dq+xru3QuQyDM3N9Mq2ej6NC46dKKEfKRGa8sREHSwY05Sv4CtHNe4O2TiBeTDi296ZZ6ei28Ho77vVPBarjfPyVdA81Mz4V2HsWJ6mPBSOKlpBsjVYtAAPw06Z/8xMTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWEY9K9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWEY9K9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE5FC116C6;
	Fri, 13 Feb 2026 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990651;
	bh=vFafJNMvc0hI6jvS4k9LPLFaepBrZ0cP7VDvbPFQTIE=;
	h=From:To:Cc:Subject:Date:From;
	b=iWEY9K9DtiXn341PoIEjOIGQm9x9cC/ret97QcbAC7lOXiLrHkpahhhc2em8a0yJB
	 7Qo0jcJD12AK2f0U4Q0D9c5jldA5eCRVN2JgN1+Ro7TY+Pnndp7m5chpJHsV+rnbMM
	 Dm15pCPZvcA5BrSslBRK1kJjdcEFpma5xJK1mHwo=
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
Subject: [PATCH 6.19 00/49] 6.19.1-rc1 review
Date: Fri, 13 Feb 2026 14:47:19 +0100
Message-ID: <20260213134708.713126210@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.19.1-rc1
X-KernelTest-Deadline: 2026-02-15T13:47+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.19.1 release.
There are 49 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.19.1-rc1

Ali Tariq <alitariq45892@gmail.com>
    wifi: rtl8xxxu: fix slab-out-of-bounds in rtl8xxxu_sta_add

Liu Song <liu.song13@zte.com.cn>
    PCI: endpoint: Avoid creating sub-groups asynchronously

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use ctx->lock to protect struct vidi_context member variables related to memory alloc/free

Darrick J. Wong <djwong@kernel.org>
    xfs: fix UAF in xchk_btree_check_block_owner

Chao Yu <chao@kernel.org>
    erofs: fix UAF issue for file-backed mounts w/ directio option

Gui-Dong Han <hanguidong02@gmail.com>
    bus: fsl-mc: fix use-after-free in driver_override_show()

Thomas Gleixner <tglx@kernel.org>
    sched/mmcid: Don't assume CID is CPU owned on mode switch

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Query FW again before proceeding with login

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Free sp in error path to fix system crash

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Delay module unload while fabric scan in progress

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Allow recovery for tape devices

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Validate sp before freeing associated memory

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()

Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
    hfs: ensure sb->s_fs_info is always cleaned up

Edward Adam Davis <eadavis@qq.com>
    nilfs2: Fix potential block overflow that cause system hang

Bibo Mao <maobibo@loongson.cn>
    crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req

Bibo Mao <maobibo@loongson.cn>
    crypto: virtio - Add spinlock protection with virtqueue notification

Kees Cook <kees@kernel.org>
    crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: octeontx - Fix length check to avoid truncation in ucode_load_store

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Add quirk for HP ZBook Studio G4

Zenm Chen <zenmchen@gmail.com>
    Bluetooth: btusb: Add USB ID 7392:e611 for Edimax EW-7611UXB

Gui-Dong Han <hanguidong02@gmail.com>
    driver core: enforce device_lock for driver_match_device()

Stefan Metzmacher <metze@samba.org>
    smb: client: let send_done handle a completion without IB_SEND_SIGNALED

Stefan Metzmacher <metze@samba.org>
    smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()

Stefan Metzmacher <metze@samba.org>
    smb: client: fix last send credit problem causing disconnects

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of smbdirect_socket.send_io.bcredits

Stefan Metzmacher <metze@samba.org>
    smb: client: use smbdirect_send_batch processing

Stefan Metzmacher <metze@samba.org>
    smb: client: introduce and use smbd_{alloc, free}_send_io()

Stefan Metzmacher <metze@samba.org>
    smb: client: split out smbd_ib_post_send()

Stefan Metzmacher <metze@samba.org>
    smb: client: port and use the wait_for_credits logic used by server

Stefan Metzmacher <metze@samba.org>
    smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()

Stefan Metzmacher <metze@samba.org>
    smb: client: remove pointless sc->recv_io.credits.count rollback

Stefan Metzmacher <metze@samba.org>
    smb: client: let smbd_post_send() make use of request->wr

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() queue a refill when the peer is low on credits

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of smbdirect_socket.recv_io.credits.available

Stefan Metzmacher <metze@samba.org>
    smb: server: let send_done handle a completion without IB_SEND_SIGNALED

Stefan Metzmacher <metze@samba.org>
    smb: server: fix last send credit problem causing disconnects

Stefan Metzmacher <metze@samba.org>
    smb: server: make use of smbdirect_socket.send_io.bcredits

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() queue a refill when the peer is low on credits

Stefan Metzmacher <metze@samba.org>
    smb: server: make use of smbdirect_socket.recv_io.credits.available

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add chann_lock to protect ksmbd_chann_list xarray

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: split cached_fid bitfields to avoid shared-byte RMW races

Li Chen <me@linux.beauty>
    io_uring: allow io-wq workers to exit when unused

Li Chen <me@linux.beauty>
    io_uring/io-wq: add exit-on-idle state


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/base/base.h                                |   9 +
 drivers/base/bus.c                                 |   2 +-
 drivers/base/dd.c                                  |   2 +-
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |  12 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |   2 +-
 drivers/crypto/omap-crypto.c                       |   2 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   5 +
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |   2 -
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  38 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   1 +
 drivers/net/wireless/realtek/rtw88/main.c          |   4 +-
 drivers/pci/endpoint/pci-ep-cfs.c                  |  15 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  41 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  28 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  19 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   3 +-
 fs/erofs/fileio.c                                  |   7 +-
 fs/hfs/mdb.c                                       |  35 +-
 fs/hfs/super.c                                     |  10 +-
 fs/nilfs2/sufile.c                                 |   4 +
 fs/smb/client/cached_dir.h                         |   8 +-
 fs/smb/client/smbdirect.c                          | 523 ++++++++++++++++-----
 fs/smb/common/smbdirect/smbdirect_socket.h         |  18 +
 fs/smb/server/mgmt/user_session.c                  |   5 +
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/server.c                             |   6 +-
 fs/smb/server/smb2pdu.c                            |  12 +-
 fs/smb/server/transport_rdma.c                     | 147 +++++-
 fs/smb/server/transport_tcp.c                      |   3 +-
 fs/xfs/scrub/btree.c                               |   7 +-
 io_uring/io-wq.c                                   |  27 +-
 io_uring/io-wq.h                                   |   1 +
 io_uring/tctx.c                                    |  11 +
 kernel/sched/core.c                                |   7 +-
 kernel/sched/sched.h                               |   6 +-
 sound/hda/codecs/conexant.c                        |   1 +
 39 files changed, 788 insertions(+), 248 deletions(-)


