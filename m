Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82561D63E4
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 05:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771048179; cv=pass; b=RTPiRu6rWuP+2XAWuYTjLPE4a1YOPKvmd89K2BKM9ZWHks3aFeJs8ueu+NXjKndMOhsDqed4KnuteI7cOGK0q3OoEKSnDTrkJP+MiucYX4GI7n/u6JcgeicTABvzaPoyjHVlNBBrnjG1vcPf7Ne2bUH3gUpifRoMviWnC0Ckbsk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771048179; c=relaxed/simple;
	bh=GRavVQhmvwlNCgvONobE5u7Ll0O52KaT/yj4QRQi1qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M/fAiCNFL+9NfGQ2Pxr8c3uqaM1853tUX0MOgp5Bkmvj1lQLw+I0XSYJ1D1nPBMtpGAGtuDZ5AfwZoOLv3853BzMeylJFXRHM86HlSUIlhc2PgwmMiN1AzqGZFm9CVd3ow/SriG01ch4Y/tGn0qYtEWKQjZt76x7Da/kdLH/eAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KamjO5h3; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KamjO5h3"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1274204434bso306345c88.1
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 21:49:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771048176; cv=none;
        d=google.com; s=arc-20240605;
        b=FRK8fQM5bsMhetZNGKj7qbQUHJzpUdG1HxpU81NQ89pK8vi2jHEutBPwW2ibrosYyt
         HamG5Qd1fhKPIcbP594kD5Y+APjd7JMU2bS6Vrola8FE4Jd125VgZ6e90+wD68Ddh71A
         fzqCDC5HWXsSyqRJjY5iXwqtMvP2BwluPXKFQFy+CaGcfYjwnAdgo/gUsTCB6nw8k1K/
         KoYk/jyzPDfccWoobu7HRv6Q/77a3ryY1ZmniI3Fcf5ZT06HTJajLw/lZqDnRdo1Rmhg
         YqPl0cwVY0pB3y8z9TLrDBIZ9uI6u9JeTPAh3gjLKUh4NWmUs2ZYKWjIrtBGjYp46Ns0
         TrNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JwLwqu8ou1Ms5gD688BvI+MOyMsrVQo8AuFKGOKiXGA=;
        fh=N0KLaEGelFM05WzesgoPgYNKcPgGfoCgoZR925c3qwc=;
        b=LZe+85rFTqJiONuphf0cQlLAktUyzztx+veV/UqJf4ofvyjPZbCiScuO1k+Or3Vb0a
         JjA2eOSTI92FIZoVOu7AP3863BgPnssDFccRORgL8l21W1Z8QDzSK6S4UuIeEtL3i4HA
         Lv3UYNmj1NRwfnH+oynIDGLDgQ/ZgxHCj4FmgW1ji+mHk8pIZoVCkHwY4Ox1aZXrD7rO
         jMelvshN+KJjQDHBgCM1/brKPiMQopheKq2dVmLqGj8EDuuO9dM2oR5POkM+LIztIqG6
         VSw4mQZHyzXV9sa87Jrb/ILHzyOAC9Tpu3c/f2vZjSVb1+zmcMiPeD66T+QaAnvrezba
         aaAA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771048176; x=1771652976; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JwLwqu8ou1Ms5gD688BvI+MOyMsrVQo8AuFKGOKiXGA=;
        b=KamjO5h32RenPDuEE948+sgkKyjw4HMcDxb6bsdPhTzNbkZZEdG8FubNxEn6fPNCwE
         N5WjX+xEUqvVg4ES5XQTEC1FmV55S86aAyRyZTb+QbBsavslO3Vp/Pp/aVRX502KQe4a
         kNO1A23usN00NIY8zkytSDqPXze0TKdCx+dHsgm++9iSgDak8WwBlfXMwzW7Kzlni6Ot
         4+A5ZpPdgRGHyR6LmxhXGqsGPcHeSh+ib08Js1QcDEQ0/rXBUzww8wz0x8PXRavFYjs0
         uiiGNzSJlTM7QuG5rKjnIcY2EE09vNTT8IpgvxHcWfygFo9CyZlD81w667gHSu4J+oke
         mCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771048176; x=1771652976;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JwLwqu8ou1Ms5gD688BvI+MOyMsrVQo8AuFKGOKiXGA=;
        b=QmR7JgWU/Thyz3pKRk3pUI1nA4d0GqCPREMWq1FSaLY9LthJ545lLX+U90JxeCXz1j
         KtNtGSY9Nm20PDDa2nTpwHrk8avEBTlHe/3gVznyfGaBmgtrG7uA0dk6eHYUvQK+Eywp
         xtOVv2lvUAWpUXb9se1UNMx6sPPjw63H8/Xs9PlCjWjh2lVQuAjmLaV07yldRrEGbxvU
         Lr4qjr4+BT7VNglYy2FMlMOveBEHtflKs7Ztb64GdkcsbnWduNfCA9JnH2Dqk6As4kkE
         jHivuEgHf8tN2sje7PCxNnfpM0M1i04U13qQHHzvGNDx2VYFQ6U1/Psq2GyGLZKnhld7
         wZfw==
X-Forwarded-Encrypted: i=1; AJvYcCXv0+QMlTp3sZ5mWZlNvDiH92Wz1ztj6Iw4wUtXWBZZxZtsxOYpTcUdzkUbMAAAHaRCCde6057b@lists.linux.dev
X-Gm-Message-State: AOJu0YyikHOaIL8miA8RZGG8dWnTM3SjQWokwMZCVOVdWw0kGz8wsDYb
	lmjer0rrpxQtJCMlwYNsH55TFmv++IEI6DCjlaSv/SUNGrQ7YjmCvKSqWd92OgLzi2hbV/1usgz
	4QqsGb9fmpD4z6gcLeB9gNxVdsaR4Tis=
X-Gm-Gg: AZuq6aIziUtYltrNTrKroWcDAH6gppGLBw2PoQC9mAziCMUnhRGx5bD6ALEhi4AjcUK
	x6n5XHTnpUIlDHxCMExwCymeLNNbMNpOCHlKqsMemfC1rY80H2bUn3ayB6j49yqfs4ljSivk1bl
	5i6nwUO6kK5WKQ5rSiIlewdBFOhMAQjO/C/ewrvP1yGnLHymnqrHma6CzZ+jY1XmfW0QbQTRZQt
	TO4rwL6ESTxs3LmwvZ7lgXJT96G9DMYnKXmi27MbpPziyWMu09Y0qbtnuGbAAS5f0xyMpghK3dU
	7s6K1ZkLuzBmYpXNtS4Td8zYKp9yEKw0hFYbHZM7o7f1mHNbI5LR8f5n0jZvHHENjeVuEp9T7MW
	ScCHh1G+rDAWcf9ndv318rapq/Wy/elKkbmTjLmTNVGeN+7jxqhXuoech8jcKlrJ6WmWYDH0bM7
	dF7zZjrnZfl+WPIPIelUw=
X-Received: by 2002:a05:7300:3254:b0:2b8:6896:d0e6 with SMTP id
 5a478bee46e88-2bac7202153mr930808eec.7.1771048175776; Fri, 13 Feb 2026
 21:49:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134708.713126210@linuxfoundation.org>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Sat, 14 Feb 2026 06:49:23 +0100
X-Gm-Features: AaiRm53UMLsiqobZsnT_Q2ppNv6fWh8Upz83jKoUfWr08gT4yPgG3SV5Ee9db1o
Message-ID: <CADo9pHgVziA9Sa-yEZcoMxzGnCQD5BxSiS-=73b7jmZzNXMhOg@mail.gmail.com>
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den fre 13 feb. 2026 kl 14:51 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
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
>     Linux 6.19.1-rc1
>
> Ali Tariq <alitariq45892@gmail.com>
>     wifi: rtl8xxxu: fix slab-out-of-bounds in rtl8xxxu_sta_add
>
> Liu Song <liu.song13@zte.com.cn>
>     PCI: endpoint: Avoid creating sub-groups asynchronously
>
> Jeongjun Park <aha310510@gmail.com>
>     drm/exynos: vidi: use ctx->lock to protect struct vidi_context member variables related to memory alloc/free
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: fix UAF in xchk_btree_check_block_owner
>
> Chao Yu <chao@kernel.org>
>     erofs: fix UAF issue for file-backed mounts w/ directio option
>
> Gui-Dong Han <hanguidong02@gmail.com>
>     bus: fsl-mc: fix use-after-free in driver_override_show()
>
> Thomas Gleixner <tglx@kernel.org>
>     sched/mmcid: Don't assume CID is CPU owned on mode switch
>
> Anil Gurumurthy <agurumurthy@marvell.com>
>     scsi: qla2xxx: Query FW again before proceeding with login
>
> Anil Gurumurthy <agurumurthy@marvell.com>
>     scsi: qla2xxx: Free sp in error path to fix system crash
>
> Anil Gurumurthy <agurumurthy@marvell.com>
>     scsi: qla2xxx: Delay module unload while fabric scan in progress
>
> Shreyas Deodhar <sdeodhar@marvell.com>
>     scsi: qla2xxx: Allow recovery for tape devices
>
> Anil Gurumurthy <agurumurthy@marvell.com>
>     scsi: qla2xxx: Validate sp before freeing associated memory
>
> Bitterblue Smith <rtl8821cerfe2@gmail.com>
>     wifi: rtw88: Fix alignment fault in rtw_core_enable_beacon()
>
> Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
>     hfs: ensure sb->s_fs_info is always cleaned up
>
> Edward Adam Davis <eadavis@qq.com>
>     nilfs2: Fix potential block overflow that cause system hang
>
> Bibo Mao <maobibo@loongson.cn>
>     crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
>
> Bibo Mao <maobibo@loongson.cn>
>     crypto: virtio - Add spinlock protection with virtqueue notification
>
> Kees Cook <kees@kernel.org>
>     crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly
>
> Thorsten Blum <thorsten.blum@linux.dev>
>     crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
>
> Thorsten Blum <thorsten.blum@linux.dev>
>     crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/conexant: Add quirk for HP ZBook Studio G4
>
> Zenm Chen <zenmchen@gmail.com>
>     Bluetooth: btusb: Add USB ID 7392:e611 for Edimax EW-7611UXB
>
> Gui-Dong Han <hanguidong02@gmail.com>
>     driver core: enforce device_lock for driver_match_device()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: let send_done handle a completion without IB_SEND_SIGNALED
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: fix last send credit problem causing disconnects
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: make use of smbdirect_socket.send_io.bcredits
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: use smbdirect_send_batch processing
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: introduce and use smbd_{alloc, free}_send_io()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: split out smbd_ib_post_send()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: port and use the wait_for_credits logic used by server
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: remove pointless sc->recv_io.credits.count rollback
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: let smbd_post_send() make use of request->wr
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: let recv_done() queue a refill when the peer is low on credits
>
> Stefan Metzmacher <metze@samba.org>
>     smb: client: make use of smbdirect_socket.recv_io.credits.available
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: let send_done handle a completion without IB_SEND_SIGNALED
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: fix last send credit problem causing disconnects
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: make use of smbdirect_socket.send_io.bcredits
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: let recv_done() queue a refill when the peer is low on credits
>
> Stefan Metzmacher <metze@samba.org>
>     smb: server: make use of smbdirect_socket.recv_io.credits.available
>
> Stefan Metzmacher <metze@samba.org>
>     smb: smbdirect: introduce smbdirect_socket.send_io.bcredits.*
>
> Stefan Metzmacher <metze@samba.org>
>     smb: smbdirect: introduce smbdirect_socket.recv_io.credits.available
>
> Henrique Carvalho <henrique.carvalho@suse.com>
>     smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: add chann_lock to protect ksmbd_chann_list xarray
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths
>
> Henrique Carvalho <henrique.carvalho@suse.com>
>     smb: client: split cached_fid bitfields to avoid shared-byte RMW races
>
> Li Chen <me@linux.beauty>
>     io_uring: allow io-wq workers to exit when unused
>
> Li Chen <me@linux.beauty>
>     io_uring/io-wq: add exit-on-idle state
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  drivers/base/base.h                                |   9 +
>  drivers/base/bus.c                                 |   2 +-
>  drivers/base/dd.c                                  |   2 +-
>  drivers/bluetooth/btusb.c                          |   2 +
>  drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
>  drivers/crypto/intel/iaa/iaa_crypto_main.c         |  12 +-
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |   2 +-
>  drivers/crypto/omap-crypto.c                       |   2 +-
>  drivers/crypto/virtio/virtio_crypto_core.c         |   5 +
>  .../crypto/virtio/virtio_crypto_skcipher_algs.c    |   2 -
>  drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  38 +-
>  drivers/net/wireless/realtek/rtl8xxxu/core.c       |   1 +
>  drivers/net/wireless/realtek/rtw88/main.c          |   4 +-
>  drivers/pci/endpoint/pci-ep-cfs.c                  |  15 +-
>  drivers/scsi/qla2xxx/qla_gs.c                      |  41 +-
>  drivers/scsi/qla2xxx/qla_init.c                    |  28 +-
>  drivers/scsi/qla2xxx/qla_isr.c                     |  19 +-
>  drivers/scsi/qla2xxx/qla_os.c                      |   3 +-
>  fs/erofs/fileio.c                                  |   7 +-
>  fs/hfs/mdb.c                                       |  35 +-
>  fs/hfs/super.c                                     |  10 +-
>  fs/nilfs2/sufile.c                                 |   4 +
>  fs/smb/client/cached_dir.h                         |   8 +-
>  fs/smb/client/smbdirect.c                          | 523 ++++++++++++++++-----
>  fs/smb/common/smbdirect/smbdirect_socket.h         |  18 +
>  fs/smb/server/mgmt/user_session.c                  |   5 +
>  fs/smb/server/mgmt/user_session.h                  |   1 +
>  fs/smb/server/server.c                             |   6 +-
>  fs/smb/server/smb2pdu.c                            |  12 +-
>  fs/smb/server/transport_rdma.c                     | 147 +++++-
>  fs/smb/server/transport_tcp.c                      |   3 +-
>  fs/xfs/scrub/btree.c                               |   7 +-
>  io_uring/io-wq.c                                   |  27 +-
>  io_uring/io-wq.h                                   |   1 +
>  io_uring/tctx.c                                    |  11 +
>  kernel/sched/core.c                                |   7 +-
>  kernel/sched/sched.h                               |   6 +-
>  sound/hda/codecs/conexant.c                        |   1 +
>  39 files changed, 788 insertions(+), 248 deletions(-)
>
>
>
