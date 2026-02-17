Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1DD29A1;
	Tue, 17 Feb 2026 20:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361215; cv=none; b=qo3WhqT4Fs8d8oW7caWuWQWb2HP5RYPqhn7c/JuN+GqO8dBl0RDzgBFpqvzSIKBLb3zAk0nzdnw6+Otwj7xq1xloVeuGbh2NUAmAwv4v98CXZzASuRFM8ke8B50t9zvZqjzgqWDewodgaWW8DGiFwRLIGXxE7mV0gFLYbZbkiVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361215; c=relaxed/simple;
	bh=PHZsXuETlRZSGGOYOQpO69L+do+BOV1l6RJce1ltQRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S4NobFVuBql+Ikuo9gRkxHA4Dkq0vjhDwvN7Fjz4wcGU/LNWEOfN5ynQbHQA6CI7IwT++IzeV7i15F+cLWkca2WNntq+W16dWCsWr6j1/0mBK1hO1zW/nYtQHBTtCmcL+KleIYH6z9XBoA8tGqhmyHV+H5fxPonT41YwKhLGApg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCccVtbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCccVtbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF664C4CEF7;
	Tue, 17 Feb 2026 20:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361214;
	bh=PHZsXuETlRZSGGOYOQpO69L+do+BOV1l6RJce1ltQRk=;
	h=From:To:Cc:Subject:Date:From;
	b=vCccVtboOvk2iVnz/6fw8ZzyG4hEfXLeiUxB54fISJUGxOmeBZM7nXY+Zl/isC2Gx
	 Q0qCDJT6lOUaRIFiKMk7os2YFX3V0kVo4FO0E3/vUOa0ykIrsURw1TppQOqphUkR55
	 fgOuq34ge06cHfx5lwCd1INBexZhmQKX5RQrE+4M=
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
Subject: [PATCH 6.1 00/64] 6.1.164-rc1 review
Date: Tue, 17 Feb 2026 21:30:56 +0100
Message-ID: <20260217200007.505931165@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.164-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.164-rc1
X-KernelTest-Deadline: 2026-02-19T20:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.164 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.164-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.164-rc1

Menglong Dong <menglong8.dong@gmail.com>
    net: tunnel: make skb_vlan_inet_prepare() return drop reasons

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit FN920C04 RNDIS compositions

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix out-of-bounds access in sysfs attribute read/write

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_write_end_io()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix IS_CHECKPOINTED flag inconsistency issue caused by concurrent atomic commit and checkpoint writes

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: smscufx: properly copy ioctl memory to kernelspace

Guangshuo Li <lgs201920130244@gmail.com>
    fbdev: rivafb: fix divide error in nv3_arb()

Chen Ridong <chenridong@huawei.com>
    cpuset: Fix missing adaptation for cpuset_is_populated

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: cfg80211: Add missing lock in cfg80211_check_and_end_cac()

Eric Dumazet <edumazet@google.com>
    mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: free routing table on probe failure

Qingfang Deng <dqfext@gmail.com>
    net: stmmac: Fix accessing freed irq affinity_hint

Shuai Xue <xueshuai@linux.alibaba.com>
    ACPI: APEI: send SIGBUS to current task if synchronous memory error not recovered

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: set ATTR_CTIME flags when setting mtime

Jeff Layton <jlayton@kernel.org>
    nfsd: don't ignore the return code of svc_proc_register()

Bosi Zhang <u201911157@hust.edu.cn>
    clk: mediatek: fix of_iomap memory leak

Shay Drory <shayd@nvidia.com>
    devlink: rate: Unset parent pointer in devl_rate_nodes_destroy

e.kubanski <e.kubanski@partner.samsung.com>
    xsk: Fix race condition in AF_XDP generic RX path

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: fix local endp not being tracked

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: check subflow errors in close events

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: check no dup close events after error

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure context reset on disconnect()

Paolo Abeni <pabeni@redhat.com>
    mptcp: schedule rtx timer only after pushing data

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: ensure unknown flags are ignored

Daniel Borkmann <daniel@iogearbox.net>
    Revert "wireguard: device: enable threaded NAPI"

Alban Bedel <alban.bedel@lht.dlh.de>
    gpiolib: acpi: Fix gpio count with string references

Ziyi Guo <n7l8m4@u.northwestern.edu>
    ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: panasonic-laptop: Fix sysfs group leak in error path

Tagir Garaev <tgaraev653@gmail.com>
    ASoC: Intel: sof_es8336: Add DMI quirk for Huawei BOD-WXX9

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: classmate-laptop: Add missing NULL pointer checks

Brahmajit Das <listout@listout.xyz>
    drm/tegra: hdmi: sor: Fix error: variable ‘j’ set but not used

Deepanshu Kartikey <kartikey406@gmail.com>
    romfs: check sb_set_blocksize() return value

Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
    ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Inspur S14-G1

Xuewen Yan <xuewen.yan@unisoc.com>
    gpio: sprd: Change sprd_gpio lock to raw_spin_lock

Anatolii Shirykalov <pipocavsobake@gmail.com>
    ASoC: amd: yc: Add ASUS ExpertBook PM1503CDA to quirks list

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Remove of_node_put() for fw_token

Pierre Gondois <pierre.gondois@arm.com>
    cacheinfo: Decrement refcount in cache_setup_of_node()

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Free sp in error path to fix system crash

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Reduce fabric scan duplicate code

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Remove dead code (GNN ID)

Gui-Dong Han <hanguidong02@gmail.com>
    bus: fsl-mc: fix use-after-free in driver_override_show()

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    bus: fsl-mc: Replace snprintf and sprintf with sysfs_emit in sysfs show functions

Liu Song <liu.song13@zte.com.cn>
    PCI: endpoint: Avoid creating sub-groups asynchronously

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: endpoint: Remove unused field in struct pci_epf_group

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Automatically create a function specific attributes group

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Fix bsg_done() causing double free

Paulo Alcantara <pc@manguebit.com>
    smb: client: set correct id, uid and cruid for multiuser automounts

Marek Behún <kabel@kernel.org>
    net: sfp: Fix quirk for Ubiquiti U-Fiber Instant SFP module

Boris Burkov <boris@bur.io>
    btrfs: fix racy bitfield write in btrfs_clear_space_info_full()

Danilo Krummrich <dakr@kernel.org>
    gpio: omap: do not register driver in probe()

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Query FW again before proceeding with login

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Delay module unload while fabric scan in progress

Shreyas Deodhar <sdeodhar@marvell.com>
    scsi: qla2xxx: Allow recovery for tape devices

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Validate sp before freeing associated memory

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

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix infinite loop caused by next_smb2_rcv_hdr_off reset in error paths

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: split cached_fid bitfields to avoid shared-byte RMW races


-------------

Diffstat:

 Documentation/PCI/endpoint/pci-ntb-howto.rst       |  11 +-
 Documentation/PCI/endpoint/pci-vntb-howto.rst      |  13 +-
 Makefile                                           |   4 +-
 drivers/acpi/apei/ghes.c                           |  10 +
 drivers/base/cacheinfo.c                           |  19 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  10 +-
 drivers/clk/mediatek/clk-mtk.c                     |   7 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c  |   2 +-
 drivers/crypto/omap-crypto.c                       |   2 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |   5 +
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |   2 -
 drivers/gpio/gpio-omap.c                           |  22 +-
 drivers/gpio/gpio-sprd.c                           |   8 +-
 drivers/gpio/gpiolib-acpi.c                        |   1 +
 drivers/gpu/drm/tegra/hdmi.c                       |   4 +-
 drivers/gpu/drm/tegra/sor.c                        |   4 +-
 drivers/net/bareudp.c                              |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  11 +-
 drivers/net/geneve.c                               |   4 +-
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/wireguard/device.c                     |   1 -
 drivers/pci/endpoint/pci-ep-cfs.c                  |  54 +-
 drivers/platform/x86/classmate-laptop.c            |  32 ++
 drivers/platform/x86/panasonic-laptop.c            |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  28 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  17 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   9 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 589 +++++++--------------
 drivers/scsi/qla2xxx/qla_init.c                    |  40 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  19 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  18 +-
 drivers/usb/serial/option.c                        |   6 +
 drivers/video/fbdev/riva/riva_hw.c                 |   3 +
 drivers/video/fbdev/smscufx.c                      |   8 +-
 fs/btrfs/block-group.c                             |   6 +-
 fs/btrfs/space-info.c                              |  22 +-
 fs/btrfs/space-info.h                              |   6 +-
 fs/f2fs/data.c                                     |  12 +-
 fs/f2fs/node.c                                     |  14 +-
 fs/f2fs/sysfs.c                                    |  61 ++-
 fs/nfsd/nfsctl.c                                   |   9 +-
 fs/nfsd/stats.c                                    |   4 +-
 fs/nfsd/stats.h                                    |   2 +-
 fs/nilfs2/sufile.c                                 |   4 +
 fs/romfs/super.c                                   |   5 +-
 fs/smb/client/cached_dir.h                         |   8 +-
 fs/smb/client/cifs_dfs_ref.c                       |  16 +
 fs/smb/server/server.c                             |   6 +-
 fs/smb/server/smb2pdu.c                            |  10 +-
 fs/smb/server/transport_tcp.c                      |   3 +-
 include/net/ip_tunnels.h                           |  13 +-
 include/net/xdp_sock.h                             |   2 -
 include/net/xsk_buff_pool.h                        |   2 +
 kernel/cgroup/cpuset.c                             |   2 +-
 net/devlink/leftover.c                             |   4 +-
 net/dsa/dsa2.c                                     |  21 +-
 net/mptcp/pm_netlink.c                             |  16 +-
 net/mptcp/protocol.c                               |  24 +-
 net/mptcp/protocol.h                               |   3 +-
 net/wireless/reg.c                                 |   5 +
 net/xdp/xsk.c                                      |   6 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 sound/pci/hda/patch_realtek.c                      |   5 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs35l45.c                         |   2 +-
 sound/soc/fsl/fsl_xcvr.c                           |   3 +
 sound/soc/intel/boards/sof_es8336.c                |   9 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 111 +++-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   4 +
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |  11 +
 70 files changed, 785 insertions(+), 627 deletions(-)


