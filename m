Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8071581E3;
	Tue,  9 Jul 2024 11:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523520; cv=none; b=AAXOX0cvqtQzt/tu0gNIISjZuMVIqn9km/vBf+yv/hsYHBfuvMS7xTZIJAp4xp88mq/Gqlp0A7/c7ZG7efgWJkzMt9RZjUmvbO5O2qPDeDupBzxskiTZCDTB/eCVi5eN4ZNwOfFCOm5CGECdc+vl7HCvkHmFYdRJ5ZGtDg+MAa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523520; c=relaxed/simple;
	bh=Ufk0w9DMvt6BUwJvcynYeVHl0iIQvmWEo+90hsxhP1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M1FWOcBePxunQ8qpuuGrXFn5ji4X/nOx6QqQthJVO1epaDHKY4xumxCv7jhG5AyhSRO7UxN7YaFTVZPSjOrlXFA9l4O/ADQUGv45N0bsypsLZ8QIoBN6dIeLt0Z5POvbyCLCioPGlgPHj+xnLx1aX3DXL2BBR6ERqsJuJG4nUvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYKeaRhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYKeaRhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B025C3277B;
	Tue,  9 Jul 2024 11:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523520;
	bh=Ufk0w9DMvt6BUwJvcynYeVHl0iIQvmWEo+90hsxhP1E=;
	h=From:To:Cc:Subject:Date:From;
	b=cYKeaRhYHd6KfFn7mB1ZHQPfVI9viPvSG6YONOVVukKyT/OASGwgd69YFkYbmD99e
	 Rj5cVPhhL6XLqWIj4b5f5e1dqAhUFdiRD0e+i0hGXcT6b4TOUSjIQXIr1fLn/id5ED
	 UoNPDwQTtzPUd5Aa3VHkoEj/ETvNGLr9PHVDtF+w=
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
Subject: [PATCH 6.6 000/139] 6.6.39-rc1 review
Date: Tue,  9 Jul 2024 13:08:20 +0200
Message-ID: <20240709110658.146853929@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.39-rc1
X-KernelTest-Deadline: 2024-07-11T11:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.39 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.39-rc1

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect inode allocation from reserved inodes

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Do not allow runt zone with zone capacity smaller then zone size

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: silence UBSAN warning

Takashi Iwai <tiwai@suse.de>
    ALSA: ump: Set default protocol when not given explicitly

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

Matt Jan <zoo868e@gmail.com>
    connector: Fix invalid conversion in cn_proc.h

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: find NUMA path only for online numa-node

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Handle vhost_vq_work_queue failures for events

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Mark volume as dirty if xattr is broken

Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
    i2c: pnx: Fix potential deadlock warning from del_timer_sync() call in isr

Pin-yen Lin <treapking@chromium.org>
    clk: mediatek: mt8183: Only enable runtime PM on mt8183-mfgcfg

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: set ALPHA_EN bit for Stromer Plus PLLs

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

Yijie Yang <quic_yijiyang@quicinc.com>
    net: stmmac: dwmac-qcom-ethqos: fix error array size

Val Packett <val@packett.cool>
    mtd: rawnand: rockchip: ensure NVDDR timings are rejected

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Bypass a couple of sanity checks during NAND identification

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Fix the nand_read_data_op() early check

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Ensure ECC configuration is propagated to upper layers

Jinglin Wen <jinglin.wen@shingroup.cn>
    powerpc/64s: Fix unnecessary copy to 0 when kernel is booted at address 0

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries: Fix scv instruction crash with kexec

Frank Oltmanns <frank@oltmanns.dev>
    clk: sunxi-ng: common: Don't call hw_to_ccu_common on hw without common

Md Sadre Alam <quic_mdalam@quicinc.com>
    clk: qcom: gcc-ipq9574: Add BRANCH_HALT_VOTED flag

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

Hector Martin <marcan@marcan.st>
    Bluetooth: hci_bcm4377: Fix msgid release

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

Huacai Chen <chenhuacai@kernel.org>
    cpu: Fix broken cmdline "nosmp" and "maxcpus=0"

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: add polarity quirk for TSC2005

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

Shiji Yang <yangshiji66@outlook.com>
    gpio: mmio: do not calculate bgpio_bits via "ngpios"

Dave Jiang <dave.jiang@intel.com>
    net: ntb_netdev: Move ntb_netdev_rx_handler() to call netif_rx() from __netif_rx()

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: initialize num_q_vectors for MSI/INTx interrupts

Sagi Grimberg <sagi@grimberg.me>
    net: allow skb_datagram_iter to be called from any context

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: fix lookup quirk for MIPS Lantiq

Dima Ruinskiy <dima.ruinskiy@intel.com>
    e1000e: Fix S0ix residency on corporate systems

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: fix LPSWEY handling

Jakub Kicinski <kuba@kernel.org>
    tcp_metrics: validate source addr length

Pavel Skripkin <paskripkin@gmail.com>
    bluetooth/hci: disallow setting handle bigger than HCI_CONN_HANDLE_MAX

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Check socket flag instead of hcon

Edward Adam Davis <eadavis@qq.com>
    Bluetooth: Ignore too large handle values in BIG

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix setting of unicast qos interval

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Add mqprio_rl cleanup and free in mlx5e_priv_cleanup()

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Create ingress ACL when needed

Neal Cardwell <ncardwell@google.com>
    UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()

Marek Vasut <marex@denx.de>
    net: phy: phy_device: Fix PHY LED blinking code comment

Dmitry Antipov <dmantipov@yandex.ru>
    mac802154: fix time calculation in ieee802154_configure_durations()

Mike Christie <michael.christie@oracle.com>
    vhost_task: Handle SIGKILL by flushing work and exiting

Mike Christie <michael.christie@oracle.com>
    vhost: Release worker mutex during flushes

Mike Christie <michael.christie@oracle.com>
    vhost: Use virtqueue mutex for swapping worker

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

John Hubbard <jhubbard@nvidia.com>
    selftests/net: fix uninitialized variables

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

Benjamin Gray <bgray@linux.ibm.com>
    powerpc/dexcr: Track the DEXCR per-process

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda10048: Fix integer overflow

Ricardo Ribalda <ribalda@chromium.org>
    media: s2255: Use refcount_t instead of atomic_t for num_channels

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda18271c2dd: Remove casting during div

Simon Horman <horms@kernel.org>
    net: dsa: mv88e6xxx: Correct check for empty list

Julien Panis <jpanis@baylibre.com>
    thermal/drivers/mediatek/lvts_thermal: Check NULL ptr on lvts_data

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: add sanity checks for background radar trigger

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

Samuel Holland <samuel.holland@sifive.com>
    riscv: Apply SiFive CIP-1200 workaround to single-ASID sfence.vma

Michael Bunk <micha@freedict.org>
    media: dw2102: Don't translate i2c read into write

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: fix the warning about the expression (int)size - len

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix uninitialized scalar variable warning

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix uninitialized variables in DM

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip finding free audio for unknown engine_id

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check pipe offset before setting vblank

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check index msg_id before read or write

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Initialize timestamp for some legacy SOCs

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdgpu: Using uninitialized value *size when calling amdgpu_vce_cs_reloc

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix uninitialized variable warnings

Fei Shao <fshao@chromium.org>
    media: mediatek: vcodec: Only free buffer VA that is not NULL

Hailey Mothershead <hailmo@amazon.com>
    crypto: aead,cipher - zeroize key buffer after use

Atish Patra <atishp@rivosinc.com>
    RISC-V: KVM: Fix the initial sample period value

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: dummy_st_ops should reject 0 for non-nullable params

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: do not pass NULL for non-nullable params in dummy_st_ops

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: adjust dummy_st_ops_success to detect additional error

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
    leds: an30259a: Use devm_mutex_init() for mutex initialization

George Stark <gnstark@salutedevices.com>
    locking/mutex: Introduce devm_mutex_init()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts |   2 +-
 arch/powerpc/include/asm/interrupt.h               |  10 ++
 arch/powerpc/include/asm/io.h                      |   2 +-
 arch/powerpc/include/asm/percpu.h                  |  10 ++
 arch/powerpc/include/asm/processor.h               |   1 +
 arch/powerpc/kernel/head_64.S                      |   5 +-
 arch/powerpc/kernel/process.c                      |  10 ++
 arch/powerpc/kernel/ptrace/ptrace-view.c           |   7 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +
 arch/powerpc/kexec/core_64.c                       |  11 ++
 arch/powerpc/platforms/pseries/kexec.c             |   8 --
 arch/powerpc/platforms/pseries/pseries.h           |   1 -
 arch/powerpc/platforms/pseries/setup.c             |   1 -
 arch/powerpc/xmon/xmon.c                           |   6 +-
 arch/riscv/include/asm/errata_list.h               |  12 +-
 arch/riscv/include/asm/tlbflush.h                  |  19 ++-
 arch/riscv/kernel/machine_kexec.c                  |  10 +-
 arch/riscv/kvm/vcpu_pmu.c                          |   2 +-
 arch/riscv/mm/tlbflush.c                           |  23 ----
 arch/s390/include/asm/kvm_host.h                   |   1 +
 arch/s390/include/asm/processor.h                  |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   1 +
 arch/s390/kvm/kvm-s390.h                           |  15 +++
 arch/s390/kvm/priv.c                               |  32 +++++
 crypto/aead.c                                      |   3 +-
 crypto/cipher.c                                    |   3 +-
 drivers/base/regmap/regmap-i2c.c                   |   3 +-
 drivers/block/null_blk/zoned.c                     |  11 ++
 drivers/bluetooth/hci_bcm4377.c                    |   2 +-
 drivers/bluetooth/hci_qca.c                        |  18 ++-
 drivers/cdrom/cdrom.c                              |   2 +-
 drivers/clk/mediatek/clk-mt8183-mfgcfg.c           |   1 +
 drivers/clk/mediatek/clk-mtk.c                     |  24 ++--
 drivers/clk/mediatek/clk-mtk.h                     |   2 +
 drivers/clk/qcom/clk-alpha-pll.c                   |   3 +
 drivers/clk/qcom/gcc-ipq9574.c                     |  10 +-
 drivers/clk/qcom/gcc-sm6350.c                      |  10 +-
 drivers/clk/sunxi-ng/ccu_common.c                  |  18 ++-
 drivers/crypto/hisilicon/debugfs.c                 |  21 +++-
 drivers/firmware/dmi_scan.c                        |  11 ++
 drivers/gpio/gpio-mmio.c                           |   2 -
 drivers/gpio/gpiolib-of.c                          |  22 +++-
 drivers/gpu/drm/amd/amdgpu/aldebaran.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   8 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c        |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +
 .../amd/display/dc/irq/dce110/irq_service_dce110.c |   8 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   8 ++
 drivers/gpu/drm/amd/include/atomfirmware.h         |   4 +-
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
 drivers/leds/leds-an30259a.c                       |  14 +--
 drivers/media/dvb-frontends/as102_fe_types.h       |   2 +-
 drivers/media/dvb-frontends/tda10048.c             |   9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |   4 +-
 .../vcodec/decoder/vdec/vdec_av1_req_lat_if.c      |  22 ++--
 .../mediatek/vcodec/encoder/venc/venc_h264_if.c    |   5 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |  18 ++-
 drivers/media/usb/dvb-usb/dw2102.c                 | 120 +++++++++++--------
 drivers/media/usb/s2255/s2255drv.c                 |  20 ++--
 drivers/mtd/nand/raw/nand_base.c                   |  68 ++++++-----
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |   6 +-
 drivers/net/bonding/bond_options.c                 |   6 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 132 ++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |  37 ++++--
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |   1 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   2 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   1 +
 drivers/net/ntb_netdev.c                           |   2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   5 +
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   5 +-
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
 drivers/thermal/mediatek/lvts_thermal.c            |   2 +
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/usb/host/xhci-ring.c                       |   5 +-
 drivers/vhost/scsi.c                               |  17 ++-
 drivers/vhost/vhost.c                              | 118 ++++++++++++++----
 drivers/vhost/vhost.h                              |   2 +
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
 include/linux/phy.h                                |   2 +-
 include/linux/sched/vhost_task.h                   |   3 +-
 include/linux/security.h                           |   5 +-
 include/uapi/linux/cn_proc.h                       |   3 +-
 kernel/auditfilter.c                               |   5 +-
 kernel/cpu.c                                       |   3 +
 kernel/dma/map_benchmark.c                         |   3 +
 kernel/exit.c                                      |   2 +
 kernel/kthread.c                                   |   1 +
 kernel/locking/mutex-debug.c                       |  12 ++
 kernel/vhost_task.c                                |  53 ++++++---
 lib/kunit/try-catch.c                              |  22 ++--
 mm/page-writeback.c                                |  32 ++++-
 net/bluetooth/hci_conn.c                           |  15 ++-
 net/bluetooth/hci_event.c                          |  26 +++-
 net/bluetooth/iso.c                                |   3 +-
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
 sound/core/ump.c                                   |   8 ++
 sound/pci/hda/patch_realtek.c                      |   9 ++
 tools/lib/bpf/bpf_core_read.h                      |   1 +
 tools/power/x86/turbostat/turbostat.c              |  10 +-
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |  34 +++++-
 .../selftests/bpf/progs/dummy_st_ops_success.c     |  15 ++-
 tools/testing/selftests/net/gro.c                  |   3 +
 tools/testing/selftests/net/ip_local_port_range.c  |   2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   2 +-
 tools/testing/selftests/net/msg_zerocopy.c         |  14 ++-
 170 files changed, 1283 insertions(+), 570 deletions(-)


