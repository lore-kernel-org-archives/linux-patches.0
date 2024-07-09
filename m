Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1561586C0;
	Tue,  9 Jul 2024 11:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524565; cv=none; b=GufTo5NNy+wlGNIt/9TahOJZd1eCH8Yz9BwIYXzSne4nCccpaaaB80+VJtb3kI4Erhh+1NUqZL0B5bzN+CBNzmNiMfFhbAv6CYdPO6Sz8ohTD4KmumbOTDrwZp3RRbw3lWNBGK0o/FF3nxppBhkp6ThtFYsiRaMSAF9xl3Cm+1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524565; c=relaxed/simple;
	bh=HOT03tjps7yJWKHhTQVcwQhiv0ML7l+TfpjNn1+7k4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sx2qEAedks1xY/Ttq1Cfk/nK3PVtR/GkJIiK0ZFMslEHO5VOvGskplrFTzLe2NN52a6KfeH5ddrQBA4zzDRdXKP+7EJZrtCsMyhERFP6Oj/tkFlsSORnoV3GemQadvrPQT6viB56KibWz5y43W7vw2czJRjv/zf78njssmR+Ht4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKEcb0jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKEcb0jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0727C3277B;
	Tue,  9 Jul 2024 11:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524565;
	bh=HOT03tjps7yJWKHhTQVcwQhiv0ML7l+TfpjNn1+7k4U=;
	h=From:To:Cc:Subject:Date:From;
	b=DKEcb0jdTF9e2gSMt6Q9mYcURMeS3ckLhUeWNsNAhqN15X7yDWFk4fvN499OiyQKU
	 xXBTm/lSOOZRucuD62BkF/NB4erIaA9DFHfVNvJH4e/Zj6wVTd4WsRZ1hqpljFWd8J
	 4yP+950du/HTG7/yRS4xVLbKmstB9JBhURY8WyPI=
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
Subject: [PATCH 6.1 000/102] 6.1.98-rc1 review
Date: Tue,  9 Jul 2024 13:09:23 +0200
Message-ID: <20240709110651.353707001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.98-rc1
X-KernelTest-Deadline: 2024-07-11T11:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.98 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.98-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.98-rc1

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect inode allocation from reserved inodes

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Do not allow runt zone with zone capacity smaller then zone size

Witold Sadowski <wsadowski@marvell.com>
    spi: cadence: Ensure data lines set to low during dummy-cycle period

Edward Adam Davis <eadavis@qq.com>
    nfc/nci: Add the inconsistency check between the input data length and count

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: fix short log for AS in link-vmlinux.sh

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a possible leak when destroy a ctrl during qp establishment

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for the EZpad 6s Pro

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for GlobalSpace SolT IVW 11.6" tablet

Jim Wylder <jwylder@google.com>
    regmap-i2c: Subtract reg size from max_write

Kundan Kumar <kundan.kumar@samsung.com>
    nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: find NUMA path only for online numa-node

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Mark volume as dirty if xattr is broken

Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
    i2c: pnx: Fix potential deadlock warning from del_timer_sync() call in isr

Pin-yen Lin <treapking@chromium.org>
    clk: mediatek: mt8183: Only enable runtime PM on mt8183-mfgcfg

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: clk-mtk: Register MFG notifier in mtk_clk_simple_probe()

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Fix gpll6* & gpll7 parents

Mauro Carvalho Chehab <mchehab@kernel.org>
    media: dw2102: fix a potential buffer overflow

GUO Zihua <guozihua@huawei.com>
    ima: Avoid blocking in RCU read-side critical section

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Fix the DCDC_REG2 minimum voltage on Quartz64 Model B

Ghadi Elie Rahme <ghadi.rahme@canonical.com>
    bnx2x: Fix multiple UBSAN array-index-out-of-bounds

Val Packett <val@packett.cool>
    mtd: rawnand: rockchip: ensure NVDDR timings are rejected

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Bypass a couple of sanity checks during NAND identification

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Ensure ECC configuration is propagated to upper layers

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries: Fix scv instruction crash with kexec

John Schoenick <johns@valvesoftware.com>
    drm: panel-orientation-quirks: Add quirk for Valve Galileo

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atomfirmware: silence UBSAN warning

Ma Ke <make24@iscas.ac.cn>
    drm/nouveau: fix null pointer dereference in nouveau_connector_get_modes

Jan Kara <jack@suse.cz>
    Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"

Jan Kara <jack@suse.cz>
    fsnotify: Do not generate events for O_PATH file descriptors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Fix BT enable failure again for QCA6390 after warm reboot

Nathan Chancellor <nathan@kernel.org>
    scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()

Nathan Chancellor <nathan@kernel.org>
    f2fs: Add inline to f2fs_build_fault_attr() stub

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix adding block group to a reclaim list and the unused list during reclaim

Jan Kara <jack@suse.cz>
    mm: avoid overflows in dirty throttling logic

Jinliang Zheng <alexjlzheng@tencent.com>
    mm: optimize the redundant loop of mm_update_owner_next()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: add missing check for inode numbers on directory entries

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix inode number range checks

Sasha Neftin <sasha.neftin@intel.com>
    Revert "igc: fix a log entry using uninitialized netdev"

Armin Wolf <W_Armin@gmx.de>
    platform/x86: toshiba_acpi: Fix quickstart quirk handling

Aleksandr Mishin <amishin@t-argos.ru>
    mlxsw: core_linecards: Fix double memory deallocation in case of invalid INI file

Shigeru Yoshida <syoshida@redhat.com>
    inet_diag: Initialize pad field in struct inet_diag_req_v2

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: make order checking verbose in msg_zerocopy selftest

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: fix OOM in msg_zerocopy selftest

Sam Sun <samsun1006219@gmail.com>
    bonding: Fix out-of-bounds read in bond_option_arp_ip_targets_set()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: unconditionally flush pending work before notifier

Song Shuai <songshuaishuai@tinylab.org>
    riscv: kexec: Avoid deadlock in kexec crash path

Jozef Hopko <jozef.hopko@altana.com>
    wifi: wilc1000: fix ies_len type in connect path

Dave Jiang <dave.jiang@intel.com>
    net: ntb_netdev: Move ntb_netdev_rx_handler() to call netif_rx() from __netif_rx()

Sagi Grimberg <sagi@grimberg.me>
    net: allow skb_datagram_iter to be called from any context

Dima Ruinskiy <dima.ruinskiy@intel.com>
    e1000e: Fix S0ix residency on corporate systems

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: fix LPSWEY handling

Jakub Kicinski <kuba@kernel.org>
    tcp_metrics: validate source addr length

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Add mqprio_rl cleanup and free in mlx5e_priv_cleanup()

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Create ingress ACL when needed

Neal Cardwell <ncardwell@google.com>
    UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()

Dmitry Antipov <dmantipov@yandex.ru>
    mac802154: fix time calculation in ieee802154_configure_durations()

Len Brown <len.brown@intel.com>
    tools/power turbostat: Remember global max_die_id

Justin Stitt <justinstitt@google.com>
    cdrom: rearrange last_media_change check to avoid unintentional overflow

Lu Yao <yaolu@kylinos.cn>
    btrfs: scrub: initialize ret in scrub_simple_mirror() to fix compilation warning

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe sensitive data on failure

Sven Schnelle <svens@linux.ibm.com>
    s390: Mark psw in __load_psw_mask() as __unitialized

Wang Yong <wang.yong12@zte.com.cn>
    jffs2: Fix potential illegal address access in jffs2_free_inode

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    serial: imx: Raise TX trigger level to 8

Tomas Henzl <thenzl@redhat.com>
    scsi: mpi3mr: Sanitise num_phys

Chao Yu <chao@kernel.org>
    f2fs: check validation of fault attrs in f2fs_build_fault_attr()

Jose E. Marchesi <jose.marchesi@oracle.com>
    bpf: Avoid uninitialized value in BPF_CORE_READ_BITFIELD

Corinna Vinschen <vinschen@redhat.com>
    igc: fix a log entry using uninitialized netdev

Greg Kurz <groug@kaod.org>
    powerpc/xmon: Check cpu id in commands "c#", "dp#" and "dx#"

Mickaël Salaün <mic@digikod.net>
    kunit: Handle test faults

Mickaël Salaün <mic@digikod.net>
    kunit: Fix timeout message

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix out-of-bounds fsid access

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Set _IO_BASE to POISON_POINTER_DELTA not 0 for CONFIG_PCI=n

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: i801: Annotate apanel_addr as __ro_after_init

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda10048: Fix integer overflow

Ricardo Ribalda <ribalda@chromium.org>
    media: s2255: Use refcount_t instead of atomic_t for num_channels

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda18271c2dd: Remove casting during div

Simon Horman <horms@kernel.org>
    net: dsa: mv88e6xxx: Correct check for empty list

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: replace skb_put with skb_put_zero

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: prevent potential failure in handle_tx_event() for Transfer events without TRB

Erick Archer <erick.archer@outlook.com>
    Input: ff-core - prefer struct_size over open coded arithmetic

Jean Delvare <jdelvare@suse.de>
    firmware: dmi: Stop decoding on broken entry

Erick Archer <erick.archer@outlook.com>
    sctp: prefer struct_size over open coded arithmetic

Michael Bunk <micha@freedict.org>
    media: dw2102: Don't translate i2c read into write

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix uninitialized scalar variable warning

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip finding free audio for unknown engine_id

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check pipe offset before setting vblank

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check index msg_id before read or write

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Initialize timestamp for some legacy SOCs

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix uninitialized variable warnings

Hailey Mothershead <hailmo@amazon.com>
    crypto: aead,cipher - zeroize key buffer after use

Guanrui Huang <guanrui.huang@linux.alibaba.com>
    irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc

John Meneghini <jmeneghi@redhat.com>
    scsi: qedf: Make qedf_execute_tmf() non-preemptible

Michael Guralnik <michaelgur@nvidia.com>
    IB/core: Implement a limit on UMAD receive List

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-usb: dib0700_devices: Add missing release_firmware()

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb: as102-fe: Fix as10x_register_addr packing

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc: Avoid nmi_enter/nmi_exit in real mode interrupt.

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: fix shared irq handling on driver remove

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/debugfs - Fix debugfs uninit process issue

George Stark <gnstark@salutedevices.com>
    locking/mutex: Introduce devm_mutex_init()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts |   2 +-
 arch/powerpc/include/asm/interrupt.h               |  10 ++
 arch/powerpc/include/asm/io.h                      |   2 +-
 arch/powerpc/include/asm/percpu.h                  |  10 ++
 arch/powerpc/kernel/setup_64.c                     |   2 +
 arch/powerpc/kexec/core_64.c                       |  11 ++
 arch/powerpc/platforms/pseries/kexec.c             |   8 --
 arch/powerpc/platforms/pseries/pseries.h           |   1 -
 arch/powerpc/platforms/pseries/setup.c             |   1 -
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/riscv/kernel/machine_kexec.c                  |  10 +-
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/s390/kvm/kvm-s390.h                           |  15 +++
 arch/s390/kvm/priv.c                               |  32 +++++
 crypto/aead.c                                      |   3 +-
 crypto/cipher.c                                    |   3 +-
 drivers/base/regmap/regmap-i2c.c                   |   3 +-
 drivers/block/null_blk/zoned.c                     |  11 ++
 drivers/bluetooth/hci_qca.c                        |  18 ++-
 drivers/cdrom/cdrom.c                              |   2 +-
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c           |   1 +
 drivers/clk/mediatek/clk-mtk.c                     |  32 +++--
 drivers/clk/mediatek/clk-mtk.h                     |   5 +
 drivers/clk/qcom/gcc-sm6350.c                      |  10 +-
 drivers/crypto/hisilicon/debugfs.c                 |  21 +++-
 drivers/firmware/dmi_scan.c                        |  11 ++
 drivers/gpu/drm/amd/amdgpu/aldebaran.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   8 ++
 drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c        |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +
 .../amd/display/dc/irq/dce110/irq_service_dce110.c |   8 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   8 ++
 drivers/gpu/drm/amd/include/atomfirmware.h         |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   7 ++
 drivers/gpu/drm/lima/lima_gp.c                     |   2 +
 drivers/gpu/drm/lima/lima_mmu.c                    |   5 +
 drivers/gpu/drm/lima/lima_pp.c                     |   4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/i2c/busses/i2c-pnx.c                       |  48 ++------
 drivers/infiniband/core/user_mad.c                 |  21 +++-
 drivers/input/ff-core.c                            |   7 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 -
 drivers/media/dvb-frontends/as102_fe_types.h       |   2 +-
 drivers/media/dvb-frontends/tda10048.c             |   9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |   4 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  18 ++-
 drivers/media/usb/dvb-usb/dw2102.c                 | 120 +++++++++++--------
 drivers/media/usb/s2255/s2255drv.c                 |  20 ++--
 drivers/mtd/nand/raw/nand_base.c                   |  66 +++++++----
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |   6 +-
 drivers/net/bonding/bond_options.c                 |   6 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 132 ++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |  37 ++++--
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |   1 +
 drivers/net/ntb_netdev.c                           |   2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   3 +-
 drivers/nfc/virtual_ncidev.c                       |   4 +
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/target/core.c                         |   9 ++
 drivers/platform/x86/toshiba_acpi.c                |  31 +++--
 drivers/platform/x86/touchscreen_dmi.c             |  36 ++++++
 drivers/s390/crypto/pkey_api.c                     |   4 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |  10 ++
 drivers/scsi/qedf/qedf_io.c                        |   6 +-
 drivers/spi/spi-cadence-xspi.c                     |  20 +++-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/usb/host/xhci-ring.c                       |   5 +-
 fs/btrfs/block-group.c                             |  13 +-
 fs/btrfs/scrub.c                                   |   2 +-
 fs/f2fs/f2fs.h                                     |  12 +-
 fs/f2fs/super.c                                    |  27 +++--
 fs/f2fs/sysfs.c                                    |  14 ++-
 fs/jffs2/super.c                                   |   1 +
 fs/nilfs2/alloc.c                                  |  18 ++-
 fs/nilfs2/alloc.h                                  |   4 +-
 fs/nilfs2/dat.c                                    |   2 +-
 fs/nilfs2/dir.c                                    |   6 +
 fs/nilfs2/ifile.c                                  |   7 +-
 fs/nilfs2/nilfs.h                                  |  10 +-
 fs/nilfs2/the_nilfs.c                              |   6 +
 fs/nilfs2/the_nilfs.h                              |   2 +-
 fs/ntfs3/xattr.c                                   |   5 +-
 fs/orangefs/super.c                                |   3 +-
 include/kunit/try-catch.h                          |   3 -
 include/linux/fsnotify.h                           |   8 +-
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/mutex.h                              |  27 +++++
 include/linux/security.h                           |   5 +-
 kernel/auditfilter.c                               |   5 +-
 kernel/dma/map_benchmark.c                         |   3 +
 kernel/exit.c                                      |   2 +
 kernel/kthread.c                                   |   1 +
 kernel/locking/mutex-debug.c                       |  12 ++
 lib/kunit/try-catch.c                              |  22 ++--
 mm/page-writeback.c                                |  32 ++++-
 net/core/datagram.c                                |  19 ++-
 net/ipv4/inet_diag.c                               |   2 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_metrics.c                             |   1 +
 net/mac802154/main.c                               |  14 ++-
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/sctp/socket.c                                  |   7 +-
 scripts/link-vmlinux.sh                            |   2 +-
 security/apparmor/audit.c                          |   6 +-
 security/apparmor/include/audit.h                  |   2 +-
 security/integrity/ima/ima.h                       |   2 +-
 security/integrity/ima/ima_policy.c                |  15 ++-
 security/security.c                                |   6 +-
 security/selinux/include/audit.h                   |   4 +-
 security/selinux/ss/services.c                     |   5 +-
 security/smack/smack_lsm.c                         |   4 +-
 sound/pci/hda/patch_realtek.c                      |   9 ++
 tools/lib/bpf/bpf_core_read.h                      |   1 +
 tools/power/x86/turbostat/turbostat.c              |  10 +-
 tools/testing/selftests/net/msg_zerocopy.c         |  14 ++-
 127 files changed, 918 insertions(+), 421 deletions(-)


