Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E5A2AE77;
	Fri, 15 Nov 2024 12:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731672319; cv=none; b=bkPzmEz4y4awniXGMq42Ltiv0kvTnd+KIVp6hViDwwB2W1w/+/5QcUAzSQNSx+6zvqw5zfeW1I1kbwO9zKZd+6ELJfaTZMuduCUVJ+ZE9pWi2xMZar61EEwxkQ+dxVL0WmdiGqV+5SLlaecA8jYRd4Y3Yk+NUJqQQ1UJcEOYE6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731672319; c=relaxed/simple;
	bh=jJMBoC3J3zzsVHUlXGFrkHpm5E1OUxW61uZ8t3U9hBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=twFBOpYgdncdOh1VTKmbmTE54emRh7gIb5zcIxxsSC0vwXKEA4WENghAPZJftf8Al6XXC7D+ogftTlJuZTSag+w79fGu7kQEtf05hgjsurN/3tWbfzP3+Il/STTFZxqWlSJ5NuykK/4Ne1t4KYynoTYqvfnj/ObW3dIV7EMlT4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iqjk1mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iqjk1mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B17C4CECF;
	Fri, 15 Nov 2024 12:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731672318;
	bh=jJMBoC3J3zzsVHUlXGFrkHpm5E1OUxW61uZ8t3U9hBY=;
	h=From:To:Cc:Subject:Date:From;
	b=1iqjk1moodxLNLsVr8xBHwXqGnVssZ90rL6hJM8T8WvX25gSO0oHeXIUicvNHaDkc
	 AJlIeAlTjV9lYQm6CnPaPLYGpSvobV30V3monB1TS+jjOXIS6FY5BTzyjQ/atnMIER
	 VWZBWz/fhuhgpXPEZMmlfH6dSdjA8Jx9qDzyNLb8=
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
Subject: [PATCH 5.4 00/67] 5.4.286-rc2 review
Date: Fri, 15 Nov 2024 13:05:13 +0100
Message-ID: <20241115120451.517948500@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.286-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.286-rc2
X-KernelTest-Deadline: 2024-11-17T12:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.286 release.
There are 67 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2024 12:04:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.286-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.286-rc2

Linus Torvalds <torvalds@linux-foundation.org>
    mm: avoid leaving partial pfn mappings around in error case

Linus Torvalds <torvalds@linux-foundation.org>
    9p: fix slab cache name creation for real

Christoph Hellwig <hch@lst.de>
    mm: add remap_pfn_range_notrack

Alex Zhang <zhangalex@google.com>
    mm/memory.c: make remap_pfn_range() reject unaligned addr

chenqiwu <chenqiwu@xiaomi.com>
    mm: fix ambiguous comments for better code readability

WANG Wenhu <wenhu.wang@vivo.com>
    mm: clarify a confusing comment for remap_pfn_range()

Li Nan <linan122@huawei.com>
    md/raid10: improve code of mrdev in raid10_sync_request

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

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix possible use-after-free issue in ftrace_location()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix NFSv4's PUTPUBFH operation

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add quirks for Dell WD19 dock

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Support jack detection on Dell dock

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

Michael Walle <michael@walle.cc>
    spi: fix use-after-free of the add_lock mutex

Mark Brown <broonie@kernel.org>
    spi: Fix deadlock when adding SPI controllers on SPI buses

Sean Nyekjaer <sean@geanix.com>
    mtd: rawnand: protect access to rawnand devices while in suspend

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

Erik Schumacher <erik.schumacher@iris-sensing.com>
    pwm: imx-tpm: Use correct MODULO value for EPWM mode

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

Wei Fang <wei.fang@nxp.com>
    net: enetc: set MAC address to the VF net_device

Qinglang Miao <miaoqinglang@huawei.com>
    enetc: simplify the return expression of enetc_vf_set_mac_addr()

Chen Ridong <chenridong@huawei.com>
    security/keys: fix slab-out-of-bounds in key_task_permission

Jiri Kosina <jkosina@suse.com>
    HID: core: zero-initialize the report buffer

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: Fix the spi controller on rk3036

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: drop grf reference from rk3036 hdmi

Heiko Stuebner <heiko@sntech.de>
    ARM: dts: rockchip: fix rk3036 acodec node

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Remove #cooling-cells from fan on Theobroma lion

Heiko Stuebner <heiko@sntech.de>
    arm64: dts: rockchip: Fix bluetooth properties on Rock960 boards

Diederik de Haas <didi.debian@cknow.org>
    arm64: dts: rockchip: Remove hdmi's 2nd interrupt on rk3328

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: rockchip: Fix rt5651 compatible value on rk3399-sapphire-excavator


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/rk3036-kylin.dts                 |   4 +-
 arch/arm/boot/dts/rk3036.dtsi                      |  14 +-
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |   3 +-
 arch/arm64/boot/dts/rockchip/rk3368-lion.dtsi      |   1 -
 arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi   |   2 +-
 .../dts/rockchip/rk3399-sapphire-excavator.dts     |   2 +-
 arch/powerpc/platforms/powernv/opal-irqchip.c      |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/hid/hid-core.c                             |   2 +-
 drivers/hid/hid-multitouch.c                       |   5 +
 drivers/irqchip/irq-gic-v3.c                       |   7 +
 drivers/md/dm-cache-target.c                       |  35 ++---
 drivers/md/dm-unstripe.c                           |   4 +-
 drivers/md/raid10.c                                |  23 +--
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   3 +
 drivers/media/dvb-core/dvb_frontend.c              |   4 +-
 drivers/media/dvb-core/dvbdev.c                    |  17 ++-
 drivers/media/dvb-frontends/cx24116.c              |   7 +-
 drivers/media/dvb-frontends/stb0899_algo.c         |   2 +-
 drivers/media/i2c/adv7604.c                        |  26 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  17 ++-
 drivers/media/usb/uvc/uvc_driver.c                 |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  44 +++---
 drivers/net/can/c_can/c_can.c                      |   7 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |   2 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |   5 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/pwm/pwm-imx-tpm.c                          |   4 +-
 drivers/spi/spi.c                                  |  27 ++--
 drivers/usb/musb/sunxi.c                           |   2 -
 drivers/usb/serial/io_edgeport.c                   |   8 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/usb/serial/qcserial.c                      |   2 +
 fs/btrfs/delayed-ref.c                             |   2 +-
 fs/nfs/inode.c                                     |   1 +
 fs/nfsd/nfs4xdr.c                                  |  10 +-
 fs/ocfs2/file.c                                    |   9 +-
 fs/ocfs2/xattr.c                                   |   3 +-
 fs/proc/vmcore.c                                   |   9 +-
 include/linux/mm.h                                 |   2 +
 include/linux/mm_types.h                           |   4 +-
 include/linux/mtd/rawnand.h                        |   2 +
 include/linux/spi/spi.h                            |   3 +
 kernel/bpf/verifier.c                              |   4 +-
 kernel/trace/ftrace.c                              |  30 ++--
 mm/memory.c                                        |  75 ++++++---
 net/9p/client.c                                    |  12 +-
 net/bridge/br_device.c                             |   5 +
 net/sctp/sm_statefuns.c                            |   2 +-
 net/vmw_vsock/hyperv_transport.c                   |   1 +
 net/vmw_vsock/virtio_transport_common.c            |   1 +
 security/keys/keyring.c                            |   7 +-
 sound/Kconfig                                      |   2 +-
 sound/firewire/tascam/amdtp-tascam.c               |   2 +-
 sound/usb/mixer_quirks.c                           | 170 +++++++++++++++++++++
 57 files changed, 471 insertions(+), 184 deletions(-)


