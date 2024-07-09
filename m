Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF105158A01;
	Tue,  9 Jul 2024 11:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523986; cv=none; b=TTaZzjaNTVcjQg2XxINxdBbQDH1elvH7zzDAvqk8yAqGmLL/uoBfVwqijxZ8rmLsvGtZhYWrrLhiPQ4pJsLhlJ9yRGov9R2SwJ7RaENt5zTyFH98hDwGScW67RvT9CJmABBIyvX8kYBbpIJAwjsrFUTi16kqhXoksgvVOS6Ievg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523986; c=relaxed/simple;
	bh=w3YvOehxrA0AlfZIaoGalBkJeKeTcBGnuYEuvjv4jiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fzbnktUvQNQY4e539yqfQi0kJSLmJuee3QVr49Gyyelj204Vey9iKg4Qt2m2/Kbj91qOH2/VjVU7o5hdMNgFY7yGvXUB6csJOPxLL+G8TQsMljZIPZHEvIXuevVQoxrXE1oRQjotn8UB+taT63qJ9CrWJ85rTtMtQV6+MEyKsF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5Gske9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5Gske9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6FEC32786;
	Tue,  9 Jul 2024 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523985;
	bh=w3YvOehxrA0AlfZIaoGalBkJeKeTcBGnuYEuvjv4jiw=;
	h=From:To:Cc:Subject:Date:From;
	b=q5Gske9nFSf5W68A/BxcilS12IKQWg7wmbrqzp4L6xcOcxUV2Ql+g5viLjDvZ2hy3
	 8hCEFqGYju4iKmiLrNkEwesezK0QpQvWaq0/GK62Oj24Oi1CFZqu66ou3xxkWf2mby
	 vAyPQlhfiYQ/k3f4y1t3X723Vpi7RqmkacE+In6U=
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
Subject: [PATCH 6.9 000/197] 6.9.9-rc1 review
Date: Tue,  9 Jul 2024 13:07:34 +0200
Message-ID: <20240709110708.903245467@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.9-rc1
X-KernelTest-Deadline: 2024-07-11T11:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.9 release.
There are 197 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.9-rc1

Andrii Nakryiko <andrii@kernel.org>
    libbpf: don't close(-1) in multi-uprobe feature detector

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Do not allow runt zone with zone capacity smaller then zone size

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add Dell G15 5511 to fan control whitelist

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

Hannes Reinecke <hare@kernel.org>
    block: check for max_hw_sectors underflow

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for the EZpad 6s Pro

hmtheboy154 <buingoc67@gmail.com>
    platform/x86: touchscreen_dmi: Add info for GlobalSpace SolT IVW 11.6" tablet

Jim Wylder <jwylder@google.com>
    regmap-i2c: Subtract reg size from max_write

Andrii Nakryiko <andrii@kernel.org>
    libbpf: detect broken PID filtering logic for multi-uprobe

Kundan Kumar <kundan.kumar@samsung.com>
    nvme: adjust multiples of NVME_CTRL_PAGE_SIZE in offset

Christian Brauner <brauner@kernel.org>
    swap: yield device immediately

Matt Jan <zoo868e@gmail.com>
    connector: Fix invalid conversion in cn_proc.h

Hawking Zhang <Hawking.Zhang@amd.com>
    drm/amdgpu: correct hbm field in boot status

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: avoid needless copy_to_user if benchmark fails

Nilay Shroff <nilay@linux.ibm.com>
    nvme-multipath: find NUMA path only for online numa-node

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Handle vhost_vq_work_queue failures for events

Jian-Hong Pan <jhp@endlessos.org>
    ALSA: hda/realtek: Enable headset mic of JP-IK LEAP W502 with ALC897

Lang Yu <Lang.Yu@amd.com>
    drm/amdkfd: Let VRAM allocations go to GTT domain on small APUs

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

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Fix the DCDC_REG2 minimum voltage on Quartz64 Model B

Mickaël Salaün <mic@digikod.net>
    selftests/harness: Fix tests timeout and race condition

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix invalid dereferencing of indirect CCW data pointer

Ghadi Elie Rahme <ghadi.rahme@canonical.com>
    bnx2x: Fix multiple UBSAN array-index-out-of-bounds

Yijie Yang <quic_yijiyang@quicinc.com>
    net: stmmac: dwmac-qcom-ethqos: fix error array size

Christian Brauner <brauner@kernel.org>
    fs: don't misleadingly warn during thaw operations

Val Packett <val@packett.cool>
    mtd: rawnand: rockchip: ensure NVDDR timings are rejected

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Bypass a couple of sanity checks during NAND identification

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Fix the nand_read_data_op() early check

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: Ensure ECC configuration is propagated to upper layers

Jann Horn <jannh@google.com>
    filelock: Remove locks reliably when fcntl/close race is detected

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: sysfb: Fix reference count of sysfb parent device

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

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/ttm: Always take the bo delayed cleanup path for imported bos

Matthew Auld <matthew.auld@intel.com>
    drm/xe: fix error handling in xe_migrate_update_pgtables

Jan Kara <jack@suse.cz>
    Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"

Jan Kara <jack@suse.cz>
    fsnotify: Do not generate events for O_PATH file descriptors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Fix BT enable failure again for QCA6390 after warm reboot

Sven Peter <sven@svenpeter.dev>
    Bluetooth: Add quirk to ignore reserved PHY bits in LE Extended Adv Report

Hector Martin <marcan@marcan.st>
    Bluetooth: hci_bcm4377: Fix msgid release

Nathan Chancellor <nathan@kernel.org>
    scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()

Nathan Chancellor <nathan@kernel.org>
    f2fs: Add inline to f2fs_build_fault_attr() stub

Boris Burkov <boris@bur.io>
    btrfs: fix folio refcount in __alloc_dummy_extent_buffer()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: fix adding block group to a reclaim list and the unused list during reclaim

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix calc_available_free_space() for zoned mode

Jan Kara <jack@suse.cz>
    mm: avoid overflows in dirty throttling logic

Jinliang Zheng <alexjlzheng@tencent.com>
    mm: optimize the redundant loop of mm_update_owner_next()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix incorrect inode allocation from reserved inodes

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: add missing check for inode numbers on directory entries

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix inode number range checks

Sasha Neftin <sasha.neftin@intel.com>
    Revert "igc: fix a log entry using uninitialized netdev"

Armin Wolf <W_Armin@gmx.de>
    platform/x86: toshiba_acpi: Fix quickstart quirk handling

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpiolib: of: add polarity quirk for TSC2005

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Fix the resource check condition for RSS contexts

Aleksandr Mishin <amishin@t-argos.ru>
    mlxsw: core_linecards: Fix double memory deallocation in case of invalid INI file

Shigeru Yoshida <syoshida@redhat.com>
    inet_diag: Initialize pad field in struct inet_diag_req_v2

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Don't flag tcp_sk(sk)->rx_opt.saw_unknown for TCP AO.

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/mcr: Avoid clobbering DSS steering

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: make order checking verbose in msg_zerocopy selftest

Zijian Zhang <zijianzhang@bytedance.com>
    selftests: fix OOM in msg_zerocopy selftest

Petr Oros <poros@redhat.com>
    ice: use proper macro for testing bit

Jacob Keller <jacob.e.keller@intel.com>
    ice: Reject pin requests with unsupported flags

Jacob Keller <jacob.e.keller@intel.com>
    ice: Don't process extts if PTP is disabled

Milena Olech <milena.olech@intel.com>
    ice: Fix improper extts handling

Sam Sun <samsun1006219@gmail.com>
    bonding: Fix out-of-bounds read in bond_option_arp_ip_targets_set()

Radu Rendec <rrendec@redhat.com>
    net: rswitch: Avoid use-after-free in rswitch_poll()

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: unconditionally flush pending work before notifier

Song Shuai <songshuaishuai@tinylab.org>
    riscv: kexec: Avoid deadlock in kexec crash path

Jozef Hopko <jozef.hopko@altana.com>
    wifi: wilc1000: fix ies_len type in connect path

Shiji Yang <yangshiji66@outlook.com>
    gpio: mmio: do not calculate bgpio_bits via "ngpios"

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Fix target addresses of TIC CCWs

Furong Xu <0x1207@gmail.com>
    net: stmmac: enable HW-accelerated VLAN stripping for gmac4 only

Thomas Huth <thuth@redhat.com>
    drm/fbdev-generic: Fix framebuffer on big endian devices

Dave Jiang <dave.jiang@intel.com>
    net: ntb_netdev: Move ntb_netdev_rx_handler() to call netif_rx() from __netif_rx()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    net: phy: aquantia: add missing include guards

Qu Wenruo <wqu@suse.com>
    btrfs: always do the basic checks for btrfs_qgroup_inherit structure

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: free isb resources at the right time

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: add extra handle for MSI/INTx into thread irq handle

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: remove separate irq request for MSI and INTx

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

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Approximate IPsec per-SA payload data bytes count

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Present succeeded IPsec SA bytes and packet

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Add mqprio_rl cleanup and free in mlx5e_priv_cleanup()

Chris Mi <cmi@nvidia.com>
    net/mlx5: E-switch, Create ingress ACL when needed

Neal Cardwell <ncardwell@google.com>
    UPSTREAM: tcp: fix DSACK undo in fast recovery to call tcp_try_to_open()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix BSS_CHANGED_UNSOL_BCAST_PROBE_RESP

Marek Vasut <marex@denx.de>
    net: phy: phy_device: Fix PHY LED blinking code comment

Eric Dumazet <edumazet@google.com>
    wifi: cfg80211: restrict NL80211_ATTR_TXQ_QUANTUM values

Dmitry Antipov <dmantipov@yandex.ru>
    mac802154: fix time calculation in ieee802154_configure_durations()

Li Zhang <zhanglikernel@gmail.com>
    virtio-pci: Check if is_avq is NULL

Mike Christie <michael.christie@oracle.com>
    vhost_task: Handle SIGKILL by flushing work and exiting

Mike Christie <michael.christie@oracle.com>
    vhost: Release worker mutex during flushes

Mike Christie <michael.christie@oracle.com>
    vhost: Use virtqueue mutex for swapping worker

Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
    tools/power turbostat: Avoid possible memory corruption due to sparse topology IDs

Len Brown <len.brown@intel.com>
    tools/power turbostat: Remember global max_die_id

Justin Stitt <justinstitt@google.com>
    cdrom: rearrange last_media_change check to avoid unintentional overflow

Lu Yao <yaolu@kylinos.cn>
    btrfs: scrub: initialize ret in scrub_simple_mirror() to fix compilation warning

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe copies of protected- and secure-keys

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe copies of clear-key structures on failure

Holger Dengler <dengler@linux.ibm.com>
    s390/pkey: Wipe sensitive data on failure

Jules Irenge <jbi.octave@gmail.com>
    s390/pkey: Use kfree_sensitive() to fix Coccinelle warnings

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

Shailend Chand <shailend@google.com>
    gve: Account for stopped queues when reading NIC stats

Benjamin Gray <bgray@linux.ibm.com>
    powerpc/dexcr: Track the DEXCR per-process

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - fix for register offset

Ricardo Ribalda <ribalda@chromium.org>
    media: dvb-frontends: tda10048: Fix integer overflow

Ricardo Ribalda <ribalda@chromium.org>
    media: tc358746: Use the correct div_ function

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: st-mipid02: Use the correct div function

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

Kees Cook <keescook@chromium.org>
    kunit/fortify: Do not spam logs with fortify WARNs

Jean Delvare <jdelvare@suse.de>
    firmware: dmi: Stop decoding on broken entry

Erick Archer <erick.archer@outlook.com>
    sctp: prefer struct_size over open coded arithmetic

Mauro Carvalho Chehab <mchehab@kernel.org>
    media: dw2102: fix a potential buffer overflow

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
    drm/amd/display: ASSERT when failing to find index by plane/stream id

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Do not return negative stream id for array

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: update pipe topology log to support subvp

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix overlapping copy within dml_core_mode_programming

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip finding free audio for unknown engine_id

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check pipe offset before setting vblank

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check index msg_id before read or write

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Add NULL pointer check for kzalloc

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: fix double free err_addr pointer warnings

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
    bpf: check bpf_dummy_struct_ops program params for test runs

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: do not pass NULL for non-nullable params in dummy_st_ops

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: adjust dummy_st_ops_success to detect additional error

Eduard Zingerman <eddyz87@gmail.com>
    bpf: mark bpf_dummy_struct_ops.test_1 parameter as nullable

Guanrui Huang <guanrui.huang@linux.alibaba.com>
    irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc

John Meneghini <jmeneghi@redhat.com>
    scsi: qedf: Make qedf_execute_tmf() non-preemptible

Michael Guralnik <michaelgur@nvidia.com>
    IB/core: Implement a limit on UMAD receive List

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Add outer runtime_pm protection to xe_live_ktest@xe_dma_buf

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: fw: scan offload prohibit all 6 GHz channel if no 6 GHz sband

Breno Leitao <leitao@debian.org>
    net: dql: Avoid calling BUG() when WARN() is enough

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
    leds: mlxreg: Use devm_mutex_init() for mutex initialization

George Stark <gnstark@salutedevices.com>
    locking/mutex: Introduce devm_mutex_init()

Babu Moger <babu.moger@amd.com>
    selftests/resctrl: Fix non-contiguous CBM for AMD


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
 block/blk-settings.c                               |   8 +-
 crypto/aead.c                                      |   3 +-
 crypto/cipher.c                                    |   3 +-
 drivers/base/regmap/regmap-i2c.c                   |   3 +-
 drivers/block/null_blk/zoned.c                     |  11 ++
 drivers/bluetooth/hci_bcm4377.c                    |  10 +-
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
 drivers/crypto/hisilicon/sec2/sec_main.c           |   2 +-
 drivers/firmware/dmi_scan.c                        |  11 ++
 drivers/firmware/sysfb.c                           |  12 +-
 drivers/gpio/gpio-mmio.c                           |   2 -
 drivers/gpio/gpiolib-of.c                          |  22 +++-
 drivers/gpu/drm/amd/amdgpu/aldebaran.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  20 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   8 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/sienna_cichlid.c        |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.h               |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   4 +-
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |   8 ++
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |   8 ++
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  | 106 ++++++++++++-----
 .../drm/amd/display/dc/dml2/display_mode_core.c    |   4 +-
 .../amd/display/dc/dml2/dml2_dc_resource_mgmt.c    |   6 +-
 .../amd/display/dc/irq/dce110/irq_service_dce110.c |   8 +-
 .../amd/display/dc/resource/dcn30/dcn30_resource.c |   3 +
 .../amd/display/dc/resource/dcn31/dcn31_resource.c |   5 +
 .../display/dc/resource/dcn314/dcn314_resource.c   |   5 +
 .../display/dc/resource/dcn315/dcn315_resource.c   |   2 +
 .../display/dc/resource/dcn316/dcn316_resource.c   |   2 +
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |   5 +
 .../display/dc/resource/dcn321/dcn321_resource.c   |   2 +
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |   2 +
 .../display/dc/resource/dcn351/dcn351_resource.c   |   2 +
 .../gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c    |   8 ++
 drivers/gpu/drm/amd/include/atomfirmware.h         |   4 +-
 drivers/gpu/drm/drm_fbdev_generic.c                |   3 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   7 ++
 drivers/gpu/drm/lima/lima_gp.c                     |   2 +
 drivers/gpu/drm/lima/lima_mmu.c                    |   5 +
 drivers/gpu/drm/lima/lima_pp.c                     |   4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |   1 +
 drivers/gpu/drm/xe/tests/xe_dma_buf.c              |   3 +
 drivers/gpu/drm/xe/xe_gt_mcr.c                     |   6 +-
 drivers/gpu/drm/xe/xe_migrate.c                    |   8 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   8 ++
 drivers/i2c/busses/i2c-i801.c                      |   2 +-
 drivers/i2c/busses/i2c-pnx.c                       |  48 ++------
 drivers/infiniband/core/user_mad.c                 |  21 +++-
 drivers/input/ff-core.c                            |   7 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   2 -
 drivers/leds/leds-an30259a.c                       |  14 +--
 drivers/leds/leds-mlxreg.c                         |  14 +--
 drivers/media/dvb-frontends/as102_fe_types.h       |   2 +-
 drivers/media/dvb-frontends/tda10048.c             |   9 +-
 drivers/media/dvb-frontends/tda18271c2dd.c         |   4 +-
 drivers/media/i2c/st-mipid02.c                     |   2 +-
 drivers/media/i2c/tc358746.c                       |   3 +-
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
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  41 ++++++-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 132 ++++++++++-----------
 drivers/net/ethernet/intel/ice/ice_hwmon.c         |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 131 +++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_ptp.h           |   9 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  46 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |  37 ++++--
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |   1 +
 drivers/net/ethernet/renesas/rswitch.c             |   4 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |  10 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   2 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c     | 124 ++++++++-----------
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.h     |   2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   9 +-
 drivers/net/ntb_netdev.c                           |   2 +-
 drivers/net/phy/aquantia/aquantia.h                |   5 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   5 +
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   5 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   3 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   4 +
 drivers/nfc/virtual_ncidev.c                       |   4 +
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/nvme/host/pci.c                            |   3 +-
 drivers/nvme/target/core.c                         |   9 ++
 drivers/platform/x86/toshiba_acpi.c                |  31 +++--
 drivers/platform/x86/touchscreen_dmi.c             |  36 ++++++
 drivers/s390/block/dasd_eckd.c                     |   4 +-
 drivers/s390/block/dasd_fba.c                      |   2 +-
 drivers/s390/cio/vfio_ccw_cp.c                     |   9 +-
 drivers/s390/crypto/pkey_api.c                     | 109 ++++++++---------
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |  10 ++
 drivers/scsi/qedf/qedf_io.c                        |   6 +-
 drivers/spi/spi-cadence-xspi.c                     |  20 +++-
 drivers/thermal/mediatek/lvts_thermal.c            |   2 +
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/usb/host/xhci-ring.c                       |   5 +-
 drivers/vhost/scsi.c                               |  17 ++-
 drivers/vhost/vhost.c                              | 118 ++++++++++++++----
 drivers/vhost/vhost.h                              |   2 +
 drivers/virtio/virtio_pci_common.c                 |   2 +-
 fs/btrfs/block-group.c                             |  13 +-
 fs/btrfs/extent_io.c                               |   2 +-
 fs/btrfs/qgroup.c                                  |  10 +-
 fs/btrfs/scrub.c                                   |   2 +-
 fs/btrfs/space-info.c                              |  24 +++-
 fs/f2fs/f2fs.h                                     |  12 +-
 fs/f2fs/super.c                                    |  27 +++--
 fs/f2fs/sysfs.c                                    |  14 ++-
 fs/jffs2/super.c                                   |   1 +
 fs/locks.c                                         |   9 +-
 fs/nilfs2/alloc.c                                  |  19 ++-
 fs/nilfs2/alloc.h                                  |   4 +-
 fs/nilfs2/dat.c                                    |   2 +-
 fs/nilfs2/dir.c                                    |   6 +
 fs/nilfs2/ifile.c                                  |   7 +-
 fs/nilfs2/nilfs.h                                  |  10 +-
 fs/nilfs2/the_nilfs.c                              |   6 +
 fs/nilfs2/the_nilfs.h                              |   2 +-
 fs/ntfs3/xattr.c                                   |   5 +-
 fs/orangefs/super.c                                |   3 +-
 fs/super.c                                         |  11 +-
 include/kunit/try-catch.h                          |   3 -
 include/linux/dynamic_queue_limits.h               |   3 +-
 include/linux/fsnotify.h                           |   8 +-
 include/linux/mutex.h                              |  27 +++++
 include/linux/phy.h                                |   2 +-
 include/linux/sched/vhost_task.h                   |   3 +-
 include/net/bluetooth/hci.h                        |  11 ++
 include/net/mac80211.h                             |   2 +-
 include/uapi/linux/cn_proc.h                       |   3 +-
 kernel/dma/map_benchmark.c                         |   3 +
 kernel/exit.c                                      |   2 +
 kernel/kthread.c                                   |   1 +
 kernel/locking/mutex-debug.c                       |  12 ++
 kernel/power/swap.c                                |   2 +-
 kernel/vhost_task.c                                |  53 ++++++---
 lib/fortify_kunit.c                                |   9 +-
 lib/kunit/try-catch.c                              |  22 ++--
 mm/page-writeback.c                                |  32 ++++-
 net/bluetooth/hci_conn.c                           |  15 ++-
 net/bluetooth/hci_event.c                          |  33 +++++-
 net/bluetooth/iso.c                                |   3 +-
 net/bpf/bpf_dummy_struct_ops.c                     |  55 ++++++++-
 net/core/datagram.c                                |  19 ++-
 net/ipv4/inet_diag.c                               |   2 +
 net/ipv4/tcp_input.c                               |   9 +-
 net/ipv4/tcp_metrics.c                             |   1 +
 net/mac802154/main.c                               |  14 ++-
 net/netfilter/nf_tables_api.c                      |   3 +-
 net/sctp/socket.c                                  |   7 +-
 net/wireless/nl80211.c                             |   6 +-
 scripts/link-vmlinux.sh                            |   2 +-
 sound/core/ump.c                                   |   8 ++
 sound/pci/hda/patch_realtek.c                      |   9 ++
 tools/lib/bpf/bpf_core_read.h                      |   1 +
 tools/lib/bpf/features.c                           |  32 ++++-
 tools/power/x86/turbostat/turbostat.c              |  35 ++++--
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |  34 +++++-
 .../selftests/bpf/progs/dummy_st_ops_success.c     |  15 ++-
 tools/testing/selftests/kselftest_harness.h        |  43 ++++---
 tools/testing/selftests/net/gro.c                  |   3 +
 tools/testing/selftests/net/ip_local_port_range.c  |   2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   2 +-
 tools/testing/selftests/net/msg_zerocopy.c         |  14 ++-
 tools/testing/selftests/resctrl/cat_test.c         |  32 +++--
 225 files changed, 2001 insertions(+), 883 deletions(-)


