Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E3C18785C;
	Fri, 15 Nov 2024 06:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652872; cv=none; b=fY0sYAum6khaZkTA+n2h8wpywqrzmPEUo/wGc2KsA+UBUYQvwRrM57q7qsy82ISIQfYckbAHIQP1aQ6O5x7/tkp5PlTsmOt91icT72aHjgZu+LkrIJ4ZTna1WOgHhWEmyaOp715/0n6674ellIrbcsxh8whKjqqkdv/WDTLgmG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652872; c=relaxed/simple;
	bh=T3skvMiItFilYNyfuMuMt8PCEcS2K9N6z6N4TxvogQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oGoTj77APhQQRcvgHU567IwMnXD+1mUWQjk6YkG9cJd3iu+XOs99Wqz2YB93gSQzsMPffO40Zq3QizBX2tWvA4VYERTlFQ64vtu0IIUXDlqFKGgFV8Emhk7s5GmtubaS4czy/c4jpGUc+1Zz8mTU/pAYA7/V4vfLPjtQ70WEo50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSdn93fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSdn93fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41221C4CECF;
	Fri, 15 Nov 2024 06:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652871;
	bh=T3skvMiItFilYNyfuMuMt8PCEcS2K9N6z6N4TxvogQg=;
	h=From:To:Cc:Subject:Date:From;
	b=gSdn93fy2WjLuzyYuGBuViLdhXm69+szSrMyRTW0JMa8E+FyvileijiMfYF1UXaR4
	 vJEzHHpPxzm2vtr9OX6sb8ElxTXhniXMeLJklPSoGQRVyboqlJ0xRsqok07SEZ71TH
	 UUQV2q6z/7mDY1pw6LfG6Skx1MMIK3+sFsrrUbJM=
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
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 4.19 00/52] 4.19.324-rc1 review
Date: Fri, 15 Nov 2024 07:37:13 +0100
Message-ID: <20241115063722.845867306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.324-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.324-rc1
X-KernelTest-Deadline: 2024-11-17T06:37+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.324 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.324-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.324-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    9p: fix slab cache name creation for real

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition

Alessandro Zanni <alessandro.zanni87@gmail.com>
    fs: Fix uninitialized value issue in from_kuid and from_kgid

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Free name on error in opal_event_init()

Julian Vetter <jvetter@kalrayinc.com>
    sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML

Rik van Riel <riel@surriel.com>
    bpf: use kvzmalloc to allocate BPF verifier environment

WangYuli <wangyuli@uniontech.com>
    HID: multitouch: Add quirk for HONOR MagicBook Art 14 touchpad

Pedro Falcato <pedro.falcato@gmail.com>
    9p: Avoid creating multiple slab caches with the same name

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add endianness annotations

Hyunwoo Kim <v4bel@theori.io>
    vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans

Hyunwoo Kim <v4bel@theori.io>
    hv_sock: Initializing vsk->trans to NULL to prevent a dangling pointer

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add quirks for Dell WD19 dock

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Support jack detection on Dell dock

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Add custom mixer status quirks for RME CC devices

Ricardo Biehl Pasquali <pasqualirb@gmail.com>
    ALSA: pcm: Return 0 when size < start_threshold in capture

Andrew Kanner <andrew.kanner@gmail.com>
    ocfs2: remove entry once instead of null-ptr-dereference in ocfs2_xa_remove()

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Force propagation of the active state with a read-back

Benoît Monin <benoit.monin@gmx.fr>
    USB: serial: option: add Quectel RG650V

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Fibocom FG132 0x0112 composition

Jack Wu <wojackbb@gmail.com>
    USB: serial: qcserial: add support for Sierra Wireless EM86xx

Dan Carpenter <dan.carpenter@linaro.org>
    USB: serial: io_edgeport: fix use after free in debug printk

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: musb: sunxi: Fix accessing an released usb phy

Qi Xi <xiqi2@huawei.com>
    fs/proc: fix compile warning about variable 'vmcore_mmap_ops'

Benoit Sevens <bsevens@google.com>
    media: uvcvideo: Skip parsing frames of type UVC_VS_UNDEFINED in uvc_parse_format

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: xmit: make sure we have at least eth header len bytes

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    bonding (gcc13): synchronize bond_{a,t}lb_xmit() types

Filipe Manana <fdmanana@suse.com>
    btrfs: reinitialize delayed ref list after deleting it from the list

Roberto Sassu <roberto.sassu@huawei.com>
    nfs: Fix KMSAN warning in decode_getfattr_attrs()

Zichen Xie <zichenxie0106@gmail.com>
    dm-unstriped: cast an operand to sector_t to prevent potential uint32_t overflow

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix potential out-of-bounds access on the first resume

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: optimize dirty bit checking with find_next_bit when resizing

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: fix out-of-bounds access to the dirty bitset when resizing

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: correct the number of origin blocks to match the target length

Antonio Quartulli <antonio@mandelbit.com>
    drm/amdgpu: prevent NULL pointer dereference if ATIF is not supported

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: v4l2-tpg: prevent the risk of a division by zero

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: cx24116: prevent overflows on SNR calculus

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: s5p-jpeg: prevent buffer overflows

Murad Masimov <m.masimov@maxima.ru>
    ALSA: firewire-lib: fix return value on fail in amdtp_tscm_init()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: adv7604: prevent underflow condition when reporting colorspace

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvb_frontend: don't play tricks with underflow values

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: dvbdev: prevent the risk of out of memory access

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: stb0899_algo: initialize cfr before using it

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: fix kernel crash when uninstalling driver

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: c_can: fix {rx,tx}_errors statistics

Xin Long <lucien.xin@gmail.com>
    sctp: properly validate chunk size in sctp_sf_ootb()

Chen Ridong <chenridong@huawei.com>
    security/keys: fix slab-out-of-bounds in key_task_permission

Jiri Kosina <jkosina@suse.com>
    HID: core: zero-initialize the report buffer

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: drop grf reference from rk3036 hdmi

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: fix rk3036 acodec node

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3036-kylin.dts                 |   4 +-
 arch/arm/boot/dts/rk3036.dtsi                      |   8 +-
 .../dts/rockchip/rk3399-sapphire-excavator.dts     |   2 +-
 arch/powerpc/platforms/powernv/opal-irqchip.c      |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/hid/hid-core.c                             |   2 +-
 drivers/hid/hid-multitouch.c                       |   5 +
 drivers/irqchip/irq-gic-v3.c                       |   7 +
 drivers/md/dm-cache-target.c                       |  35 +-
 drivers/md/dm-unstripe.c                           |   4 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   3 +
 drivers/media/dvb-core/dvb_frontend.c              |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |  17 +-
 drivers/media/dvb-frontends/cx24116.c              |   7 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |   2 +-
 drivers/media/i2c/adv7604.c                        |  26 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  17 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 drivers/net/can/c_can/c_can.c                      |   7 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   5 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/usb/musb/sunxi.c                           |   2 -
 drivers/usb/serial/io_edgeport.c                   |   8 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/qcserial.c                      |   2 +
 fs/btrfs/delayed-ref.c                             |   2 +-
 fs/nfs/inode.c                                     |   1 +
 fs/ocfs2/file.c                                    |   9 +-
 fs/ocfs2/xattr.c                                   |   3 +-
 fs/proc/vmcore.c                                   |   9 +-
 include/net/bond_alb.h                             |   4 +-
 kernel/bpf/verifier.c                              |   4 +-
 net/9p/client.c                                    |  12 +-
 net/bridge/br_device.c                             |   5 +
 net/sctp/sm_statefuns.c                            |   2 +-
 net/vmw_vsock/hyperv_transport.c                   |   1 +
 net/vmw_vsock/virtio_transport_common.c            |   1 +
 security/keys/keyring.c                            |   7 +-
 sound/Kconfig                                      |   2 +-
 sound/core/pcm_lib.c                               |  13 +-
 sound/firewire/tascam/amdtp-tascam.c               |   2 +-
 sound/usb/mixer_quirks.c                           | 551 +++++++++++++++++++++
 44 files changed, 726 insertions(+), 89 deletions(-)


