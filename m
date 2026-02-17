Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B881B042E;
	Tue, 17 Feb 2026 20:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361089; cv=none; b=MTO3LFWMvjTIoV0WR0yDXeM6M5xzoLZn8iIRAX6Kw+J8hqbTnkrYrgYwau2VsDwG1jxQO7kX1LMMKOmfZLvI1QQ20iOHtVDLo6YNASXdr+/DTGJOEhKGjELM+VKz4F0l2whOOT0ndW56svkKzuo0655ZWVJ9K/nHLOjDsRStLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361089; c=relaxed/simple;
	bh=vdppFI8A4pqDD1sGY4FIinLgNRDIRNW8cprC+CSORO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=McPYFUeN7rcTYuzBM0rkyCT0B+cH4aKnf+zBAouUWSU3enooACfcfsGf1vt4CiXjmNe31hhlC62DeoN476lNjbheB1CSMKAF6fqlcu+JQPLN3fizZDfXgpvBb4+qTtfSeuqRQ7LGiHumcHsp7OfRGuvNJhfAhYTHQ6BSfn6r0L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2GWXuiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2GWXuiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB218C4CEF7;
	Tue, 17 Feb 2026 20:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361089;
	bh=vdppFI8A4pqDD1sGY4FIinLgNRDIRNW8cprC+CSORO4=;
	h=From:To:Cc:Subject:Date:From;
	b=O2GWXuiEdMKJwOgG6x84n0/3X4j2LhFUcGu+RKwCnZCpBSX4vRLZY/NTgOFsjYV/z
	 jFGXu2rng3DXLp2ljCiyoFRN2E444zS6CaMdbnKkjVJihpj/GoMmvg3Pob86OG8xFp
	 ujb/4J6XrZT3hTez9r+SSPnCMILUvH8J/Neb6Zz4=
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
Subject: [PATCH 5.15 00/39] 5.15.201-rc1 review
Date: Tue, 17 Feb 2026 21:31:09 +0100
Message-ID: <20260217200002.929083107@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.201-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.201-rc1
X-KernelTest-Deadline: 2026-02-19T20:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.201 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.201-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.201-rc1

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit FN920C04 RNDIS compositions

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix out-of-bounds access in sysfs attribute read/write

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_write_end_io()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: smscufx: properly copy ioctl memory to kernelspace

Guangshuo Li <lgs201920130244@gmail.com>
    fbdev: rivafb: fix divide error in nv3_arb()

Liu Song <liu.song13@zte.com.cn>
    PCI: endpoint: Avoid creating sub-groups asynchronously

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: endpoint: Remove unused field in struct pci_epf_group

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Automatically create a function specific attributes group

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Free sp in error path to fix system crash

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Reduce fabric scan duplicate code

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Remove dead code (GNN ID)

Gleb Chesnokov <Chesnokov.G@raidix.com>
    scsi: qla2xxx: Use named initializers for port_[d]state_str

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Fix bsg_done() causing double free

Gui-Dong Han <hanguidong02@gmail.com>
    bus: fsl-mc: fix use-after-free in driver_override_show()

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    bus: fsl-mc: Replace snprintf and sprintf with sysfs_emit in sysfs show functions

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()

Bibo Mao <maobibo@loongson.cn>
    crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req

Eric Dumazet <edumazet@google.com>
    mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: ensure unknown flags are ignored

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: free routing table on probe failure

Paulo Alcantara <pc@manguebit.com>
    smb: client: set correct id, uid and cruid for multiuser automounts

Boris Burkov <boris@bur.io>
    btrfs: fix racy bitfield write in btrfs_clear_space_info_full()

Daniel Borkmann <daniel@iogearbox.net>
    Revert "wireguard: device: enable threaded NAPI"

Alban Bedel <alban.bedel@lht.dlh.de>
    gpiolib: acpi: Fix gpio count with string references

Ziyi Guo <n7l8m4@u.northwestern.edu>
    ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: panasonic-laptop: Fix sysfs group leak in error path

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: classmate-laptop: Add missing NULL pointer checks

Brahmajit Das <listout@listout.xyz>
    drm/tegra: hdmi: sor: Fix error: variable ‘j’ set but not used

Deepanshu Kartikey <kartikey406@gmail.com>
    romfs: check sb_set_blocksize() return value

Xuewen Yan <xuewen.yan@unisoc.com>
    gpio: sprd: Change sprd_gpio lock to raw_spin_lock

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU

Danilo Krummrich <dakr@kernel.org>
    gpio: omap: do not register driver in probe()

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Query FW again before proceeding with login

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Delay module unload while fabric scan in progress

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Validate sp before freeing associated memory

Edward Adam Davis <eadavis@qq.com>
    nilfs2: Fix potential block overflow that cause system hang

Bibo Mao <maobibo@loongson.cn>
    crypto: virtio - Add spinlock protection with virtqueue notification

Kees Cook <kees@kernel.org>
    crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: octeontx - Fix length check to avoid truncation in ucode_load_store


-------------

Diffstat:

 Documentation/PCI/endpoint/pci-ntb-howto.rst      |  11 +-
 Makefile                                          |   4 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                   |  10 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c |   2 +-
 drivers/crypto/omap-crypto.c                      |   2 +-
 drivers/crypto/virtio/virtio_crypto_algs.c        |   2 -
 drivers/crypto/virtio/virtio_crypto_core.c        |   5 +
 drivers/gpio/gpio-omap.c                          |  22 +-
 drivers/gpio/gpio-sprd.c                          |   8 +-
 drivers/gpio/gpiolib-acpi.c                       |   1 +
 drivers/gpu/drm/tegra/hdmi.c                      |   4 +-
 drivers/gpu/drm/tegra/sor.c                       |   4 +-
 drivers/net/wireguard/device.c                    |   1 -
 drivers/pci/endpoint/pci-ep-cfs.c                 |  54 +-
 drivers/platform/x86/classmate-laptop.c           |  32 ++
 drivers/platform/x86/panasonic-laptop.c           |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                    |  25 +-
 drivers/scsi/qla2xxx/qla_def.h                    |  50 +-
 drivers/scsi/qla2xxx/qla_gbl.h                    |   9 +-
 drivers/scsi/qla2xxx/qla_gs.c                     | 586 ++++++++--------------
 drivers/scsi/qla2xxx/qla_init.c                   |  31 +-
 drivers/scsi/qla2xxx/qla_isr.c                    |  29 +-
 drivers/scsi/qla2xxx/qla_os.c                     |  18 +-
 drivers/usb/serial/option.c                       |   6 +
 drivers/video/fbdev/riva/riva_hw.c                |   3 +
 drivers/video/fbdev/smscufx.c                     |   8 +-
 fs/btrfs/block-group.c                            |   6 +-
 fs/btrfs/space-info.c                             |  20 +-
 fs/btrfs/space-info.h                             |   6 +-
 fs/cifs/cifs_dfs_ref.c                            |  16 +
 fs/f2fs/data.c                                    |  12 +-
 fs/f2fs/sysfs.c                                   |  65 ++-
 fs/ksmbd/transport_tcp.c                          |   3 +-
 fs/nilfs2/sufile.c                                |   4 +
 fs/romfs/super.c                                  |   5 +-
 net/dsa/dsa2.c                                    |  21 +-
 net/mptcp/pm_netlink.c                            |  16 +-
 sound/pci/hda/patch_realtek.c                     |   4 +
 sound/soc/fsl/fsl_xcvr.c                          |   3 +
 tools/testing/selftests/net/mptcp/pm_netlink.sh   |   4 +
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c     |  11 +
 41 files changed, 576 insertions(+), 551 deletions(-)


