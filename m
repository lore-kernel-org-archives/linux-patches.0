Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8BC1CDFAC;
	Sun,  7 Sep 2025 20:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275792; cv=none; b=g1Pg9rfCAewBkftnFXDq8jC5cAyD2PdCsBwE3R7n2Dpgdr2xgtoWl+Vc256b9dHOalSAwMG72XFOpC4TqNwEq6PGU+h4f6NG4MxyGro9cZE9n11Fd0GTPSbwHtNnccHuLgLxzeXry7JiZEw0Qm+lELIvzRrzo691ocTIipjCHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275792; c=relaxed/simple;
	bh=qBEG2Bntviw/gJPn/+vDRKi/OUokla7ugr2A7z0kPUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mepMP5qZh9Q9Qt3ZONv8Ja+OrPMtG8RdcTeGxjjYvDfKf1Syw2SN0kdgLSbc/8AKw6Ttsa3Ax6EN6wF6EMVroWifAB7gKJa9y0v9Q07AaNj1Bxy4hwbuRF4kn1rE/Bm6/XZL0twF4cbIlK4tVrds6cpQy4t0Vp9x8D/lHBSZzno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmDKFVgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmDKFVgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE24C4CEF0;
	Sun,  7 Sep 2025 20:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275792;
	bh=qBEG2Bntviw/gJPn/+vDRKi/OUokla7ugr2A7z0kPUE=;
	h=From:To:Cc:Subject:Date:From;
	b=DmDKFVgK1pzTe0PSfIRpQpXGPX+3KLQAXsfbPP5UhBLEL8+B4GMprP88IsYGs13hf
	 qgxrOlKQocrRW109I+lHS5ChC/P5DRPS9SEqZokjabm4KT5LAr0vjYolRs0avZ/MCs
	 WQi13SlkY6LGs/w6/aNfUaxh5fNKLOk3XyybE5H0=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 5.4 00/45] 5.4.299-rc1 review
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195600.953058118@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.299-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.299-rc1
X-KernelTest-Deadline: 2025-09-09T19:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.299 release.
There are 45 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.299-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.299-rc1

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a flag reuse error in mtk_cqdma_tx_status()

Roman Smirnov <r.smirnov@omp.ru>
    cifs: fix integer overflow in match_server()

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Reset FIFO and disable module on transfer abort

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Set correct chip-select polarity bit

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-lpspi: Fix transmissions when using CONT

Wentao Liang <vulab@iscas.ac.cn>
    pcmcia: Add error handling for add_interval() in do_validate_mem()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/hdmi: Add pin fix for another HP EliteDesk 800 G4 model

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Fix attribute addition

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Remove bogus void member

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: update MTU after device quiesce

Jakob Unterwurzacher <jakobunt@gmail.com>
    net: dsa: microchip: linearize skb for tail-tagging switches

Pieter Van Trappen <pieter.van.trappen@cern.ch>
    net: dsa: microchip: update tag_ksz masks for KSZ9477 family

Qiu-ji Chen <chenqiuji666@gmail.com>
    dmaengine: mediatek: Fix a possible deadlock error in mtk_cqdma_tx_status()

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    gpio: pca953x: fix IRQ storm on system wake up

Luca Ceresoli <luca.ceresoli@bootlin.com>
    iio: light: opt3001: fix deadlock due to concurrent flag access

David Lechner <dlechner@baylibre.com>
    iio: chemical: pms7003: use aligned_s64 for timestamp

Sean Christopherson <seanjc@google.com>
    KVM: x86: Take irqfds.lock when adding/deleting IRQ bypass producer

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Explicitly synchronize limits_changed flag handling

Li Qiong <liqiong@nfschina.com>
    mm/slub: avoid accessing metadata when pointer is invalid in object_err()

John Evans <evans1210144@gmail.com>
    scsi: lpfc: Fix buffer free/clear order in deferred receive path

Jann Horn <jannh@google.com>
    mm/khugepaged: fix ->anon_vma race

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: fix heap overflow in e1000_set_eeprom

Stanislav Fort <stanislav.fort@aisle.com>
    batman-adv: fix OOB read/write in network-coding decode

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: drop hw access in non-DC audio fini

Qianfeng Rong <rongqianfeng@vivo.com>
    wifi: mwifiex: Initialize the chan_stats array to zero

Ma Ke <make24@iscas.ac.cn>
    pcmcia: Fix a NULL pointer dereference in __iodyn_find_io_region()

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: Add mute TLV for playback volumes on some devices

Qingfang Deng <dqfext@gmail.com>
    ppp: fix memory leak in pad_compress_skb

Wang Liang <wangliang74@huawei.com>
    net: atm: fix memory leak in atm_register_sysfs when device_register fail

Eric Dumazet <edumazet@google.com>
    ax25: properly unshare skbs in ax25_kiss_rcv()

Dan Carpenter <dan.carpenter@linaro.org>
    ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()

Rosen Penev <rosenp@gmail.com>
    net: thunder_bgx: decrement cleanup index before use

Rosen Penev <rosenp@gmail.com>
    net: thunder_bgx: add a missing of_node_put

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: libertas: cap SSID len in lbs_associate()

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: cw1200: cap SSID length in cw1200_do_join()

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix tx vlan tag for llc packets

Zhen Ni <zhen.ni@easystack.cn>
    i40e: Fix potential invalid access when MAC list is empty

Fabian Bläse <fabian@blaese.de>
    icmp: fix icmp_ndo_send address translation for reply direction

Miaoqian Lin <linmq006@gmail.com>
    mISDN: Fix memory leak in dsp_hwec_enable()

Alok Tiwari <alok.a.tiwari@oracle.com>
    xirc2ps_cs: fix register access when enabling FullDuplex

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix use-after-free in l2cap_sock_cleanup_listen()

Phil Sutter <phil@nwl.cc>
    netfilter: conntrack: helper: Replace -EEXIST by -EBUSY

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: fix use-after-free in cmp_bss()

Nathan Chancellor <nathan@kernel.org>
    powerpc: boot: Remove leading zero in label in udelay()


-------------

Diffstat:

 Makefile                                          |  4 +--
 arch/powerpc/boot/util.S                          |  4 +--
 arch/x86/kvm/x86.c                                | 16 +++++++--
 drivers/dma/mediatek/mtk-cqdma.c                  | 10 +++---
 drivers/gpio/gpio-pca953x.c                       |  5 +++
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c            |  5 ---
 drivers/gpu/drm/amd/amdgpu/dce_v11_0.c            |  5 ---
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c             |  5 ---
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c             |  5 ---
 drivers/iio/chemical/pms7003.c                    |  5 +--
 drivers/iio/light/opt3001.c                       |  5 +--
 drivers/isdn/mISDN/dsp_hwec.c                     |  6 ++--
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 20 +++++++-----
 drivers/net/ethernet/intel/e1000e/ethtool.c       | 10 ++++--
 drivers/net/ethernet/intel/i40e/i40e_client.c     |  4 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c       | 10 +++++-
 drivers/net/ethernet/xircom/xirc2ps_cs.c          |  2 +-
 drivers/net/ppp/ppp_generic.c                     |  6 ++--
 drivers/net/vmxnet3/vmxnet3_drv.c                 |  5 +--
 drivers/net/wireless/marvell/libertas/cfg.c       |  9 +++--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c   |  5 +--
 drivers/net/wireless/marvell/mwifiex/main.c       |  4 +--
 drivers/net/wireless/st/cw1200/sta.c              |  2 +-
 drivers/pcmcia/rsrc_iodyn.c                       |  3 ++
 drivers/pcmcia/rsrc_nonstatic.c                   |  4 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c                    | 10 +++---
 drivers/spi/spi-fsl-lpspi.c                       | 15 +++++----
 fs/cifs/connect.c                                 |  5 +++
 kernel/sched/cpufreq_schedutil.c                  | 28 +++++++++++++---
 mm/khugepaged.c                                   | 14 +++++++-
 mm/slub.c                                         |  7 +++-
 net/atm/resources.c                               |  6 ++--
 net/ax25/ax25_in.c                                |  4 +++
 net/batman-adv/network-coding.c                   |  7 +++-
 net/bluetooth/l2cap_sock.c                        |  3 ++
 net/dsa/tag_ksz.c                                 | 22 ++++++++++---
 net/ipv4/devinet.c                                |  7 ++--
 net/ipv4/icmp.c                                   |  6 ++--
 net/ipv6/ip6_icmp.c                               |  6 ++--
 net/netfilter/nf_conntrack_helper.c               |  4 +--
 net/wireless/scan.c                               |  3 +-
 scripts/gcc-plugins/gcc-common.h                  | 32 ++++++++++++++++++
 scripts/gcc-plugins/randomize_layout_plugin.c     | 40 +++++++----------------
 sound/pci/hda/patch_hdmi.c                        |  1 +
 sound/pci/hda/patch_realtek.c                     |  1 +
 sound/usb/mixer_quirks.c                          |  2 ++
 46 files changed, 250 insertions(+), 132 deletions(-)


