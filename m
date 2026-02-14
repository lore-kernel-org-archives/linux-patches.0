Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCE81D63E4
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 05:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771048147; cv=pass; b=cdSgfTs5nGj8uzvTQRr0tvXmB9YEK5OSKa9AP2wAdZT11GNNcnnowr2GYjJ4oj8korjngj+174QOCCCPRdPTmRjqz2ktEQ0HPA6qGbmHvCDakaYhjBvDtMt9C8X4hiaM3kZfZLpJbHkk9adJ5qWjwUpBF7lDnCpUE4gM4wZg5CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771048147; c=relaxed/simple;
	bh=6JMac4aQGVmaK4xSD2v1MguCqeh8mIw1wC9GX3T+jy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U7p5BuijhjFJhBE0Sa/2nCSBWU65R/EkI5wr+AXI0hNxlLXz2CXGGHQiaYqhq5Jz7a+IJ7xjX/cENv5oyElYExCnoo+CVFbk3IkFxjpMLI32q2zJGbBSZVPesfERPkhJJ88OKbpf0NePSL01koc9MmXs3bSaoJtGBALwzPx9TGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/xO3MDE; arc=pass smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/xO3MDE"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2ba9d13f10eso2841445eec.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 21:49:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771048144; cv=none;
        d=google.com; s=arc-20240605;
        b=e9wWtMma7n4XElgifrRypnzyr/p4k9rz2VzfeY/b0Jy9ze6kn6xQf4zb6Xsvl0mcr/
         Dn3ijulwgHQNh4G1iygkHWZjAkjcm7424SOhuXd+oboIXnGtCbaPLBkXlDlMGuB3jv9l
         HiN9EdQxK2IrqbU4lFANc/yVDWjTKfeMC+/vm8N6ykkZj+wvQIGZHzJ//qXBJUpcNilW
         o/BDwT/eZ68+EsENVJ8PtkqHVkroUcRO1WRlRz3XXDQLeT2XgI0ew3Pn4ikmIwyxyef6
         ax+Qx6aJHzI2Erry+lX6+irjcLQniQ9a6M8ErFYeeg+JGxbHHKCXy8aaObaO42rnkx3I
         UNqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pL/rVbYopYU/xWf3Hc+ezZslblCZtsIBlSm64k0TdYc=;
        fh=NM76TFUDijxHimwdMY1AuW33P2fcvtUfetH3wdKgUN4=;
        b=RBLUv270w4fYQCP9wi64+gDnm8isPz8ly4E26ZJbbK7tLQZRA0/UIkP8ihbJa33VS4
         DYlHMrYjxL4csFA0l/vHj+PdH4ZpWx7TWLw0xhIcayC/S6f3RiQ4jWybP6LPHJTTy/rM
         owMHTIt5ihKRv363vIE9sZy/qmcgqxzPUHDfhaeSq1LvoR9YBowqIjwixFji5w2tVkTO
         qL7huDkUqen0D1mUUDmck28WABGi3eA5u1O4dTFZJ0v5rY1C6cdt2OtM9uNLKF9nGyI2
         CF0rSQA+yCS5FcCY4Mrd2dynXmxtu+hLKOiQmx6P96TbvC02VIBKH2RCrgHoBPFcsvCA
         JUMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771048144; x=1771652944; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pL/rVbYopYU/xWf3Hc+ezZslblCZtsIBlSm64k0TdYc=;
        b=j/xO3MDEllvFJg/hATy2uIoxOqcSmohmy5rZsX0gXiexbkfHiv6fWrrWUSfCZVFdUr
         33VetOieIDCmC9o906IRkCi6qkb1Z5laC3AXSgQFxiB/PeLhb1BdAoK6jYO2S3yPcZR9
         gWhw4uH0W+efMRYDIVMFD9JNzth2VPcE5Cuepf7qh54dqJTIyOJQFplC9iOpuyo+bPoS
         3ac1d72lxmHA9o/N/Q7PFscKFKc8t2bul7VPTSFsFTbxtvh0C6rjPkJVar/KWvxRjXRo
         +ROjR5eWSARdeqp+JHVFBGbs7xhHMMk0Hbdf7bKB0UQAD8PP3/QKG/x+dis29vqz8U7g
         HUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771048144; x=1771652944;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pL/rVbYopYU/xWf3Hc+ezZslblCZtsIBlSm64k0TdYc=;
        b=rmf37HGkpytGVWVVmAX7TBsMXxpVdUD8bcqWopYQKf0dU8UJYfxZpTpEfNCvTqf7TL
         o59rBPCJZ3z9YBwKubE+j/OOQeM4d1BhObiXpqObXLbBgizfIP+thYO66RNUskmOMr6P
         q/vEY/NyXWkCCTJLENJ5Yv21KfyM0ISqkhyFj16PBQMDz4j84w9WWSzdbj+8asTcZVrt
         fZXAt7LZuwSJMTazwmikiCv8lf6eNXA/3IoQJiD7wkk4q/lHsxRS1hT8xh4XkjC6lkbC
         x+G292CsgFdLX002R9JEFlz+FQTkPZkpamhUEi1kaFvNxTFcp+bSzH/GGU4qfpFU8xbr
         vOAw==
X-Forwarded-Encrypted: i=1; AJvYcCVh63Msyvtyr1bsXY6SQlirrbFLmqi1Lo9sZz8OPswMfDnaovA/AwOMrlbgFl0ArhwRc6w+CDC3@lists.linux.dev
X-Gm-Message-State: AOJu0YzRMYKeMwfHKv7mDJGNJMgE4ZM23CubHRFpgEuKCTpErPs3bs/3
	wZfP6klmJkBf6WzI7SO2V4yA6BCmyzQd+hWm9hhIY2df7rIm0kQ8xer0gVS4CHvxMnNoelkO1Sa
	quIJebschUClcbo7g0ykZw+A8V78WmDU=
X-Gm-Gg: AZuq6aIWZgRX0tiSP8eLrxsuu9lbmVpV5YV8UBtYTCRVOxa7YBDRuw0zi/Fpfm6Z0Ua
	P3ejHgfCTnULaRBS6qsmFaFUgptcyZsIuaE8VAIaAoOA/Qkhlt67+S6TSocMTLoGFkspP4rETOP
	7HaPsdy8jERSwxybR2KAcNl2ThjPdjhhmLMN7bUz3Go1WgQDXPDQXXl0zRxzzFe7gHnz9uBNMKJ
	PNWAkQLnOYiaj4W3gZcKNjXRVuPmmFG4PK5eW8S08h9P4YB7JZrM9bReIEuGZzU5AyluTeIyewG
	JtYwE6AjXXckBAINPTE/FdWj9cuX8KuCoaSxxYKLI6juEqU3u9ygJDqdCXrLWltVNHudGg2hrEn
	g7fs6Xbn+AqtUbg6aQuuMU08s5jTBLJri8y3Uro72C64pAdGkFFKTy+3u2oJy+nHRi5eEa2p0xN
	Eh7nKtaKy/BH2QaLnnZL8=
X-Received: by 2002:a05:7301:168e:b0:2b8:6573:2d35 with SMTP id
 5a478bee46e88-2babc42e1f4mr2149557eec.2.1771048143570; Fri, 13 Feb 2026
 21:49:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134708.885500854@linuxfoundation.org>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Sat, 14 Feb 2026 06:48:51 +0100
X-Gm-Features: AaiRm51_Ulrx2MkwQSoBKB2WfT2plhQjy74CL-1H59OXIjjQ59srhznvWjq2yjM
Message-ID: <CADo9pHgnDxeeOuaTDG3se2rrAT8EEMau16ZyjHYZwHC2e-jYWw@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

Tested on: Arch Linux Machine a Dell Micro 3050 with a
model name    : Intel(R) Core(TM) i5-6500T CPU @ 2.50GHz
and works as it should


Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den fre 13 feb. 2026 kl 14:52 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
>     Linux 6.18.11-rc1
>
> Danilo Krummrich <dakr@kernel.org>
>     gpio: omap: do not register driver in probe()
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
>  drivers/gpio/gpio-omap.c                           |  22 +-
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
>  sound/hda/codecs/conexant.c                        |   1 +
>  38 files changed, 799 insertions(+), 246 deletions(-)
>
>
>
