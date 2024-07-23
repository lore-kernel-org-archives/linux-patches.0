Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CD614A4C9;
	Tue, 23 Jul 2024 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759504; cv=none; b=tmP5/ysX/TjwD7w5BDTWjy3IKT2cXXz+sqUdnBM+OqThfulQTs+j9H1xsN5ghMvXGJwlIH+64+aY9htzM+ix6THNXdBLasgH/8+NmmReKTDpbYnEYW3zayqbnE+zfChEI5V2DAK6NgdMDfmiO58uzKqISZngGzISlh6Ro0swfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759504; c=relaxed/simple;
	bh=s+JoWWs3QcmIawqtkq/nQr5tIzxMAJRJphKiH+x/vlc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VLup/wZdKm9YVz1/iQfUD1isjfe6cwGNCy8LYPtXskp6e0JrYp4UEQU8V0dGrBobZHyDr1mZfRq6svnaDiJ73wjXmxexTQZ4z94nCcg7nXeaXqskJW4PdSX9e2WnL3++Mag32GA8ESMkuMMKf70mflsMU/v+PN31L94Ih8zEZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMwHN+Jb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMwHN+Jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386C9C4AF0A;
	Tue, 23 Jul 2024 18:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759503;
	bh=s+JoWWs3QcmIawqtkq/nQr5tIzxMAJRJphKiH+x/vlc=;
	h=From:To:Cc:Subject:Date:From;
	b=XMwHN+JbO+pziaLbgLiIfnxze3lm8mb4IgOUiyEDS+Dn19WiHM76+TAxcDPvtni/G
	 3hZFRAKSupV9S8GfXX3MPBZxZ/66uIIw7iXYHQ9/Hotblm3mqi1X3jx/EnYOhEQ0QA
	 iney9ejPpY6UgNMbP4q9X/4dhfTEzOIMruWO+3Nk=
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
Subject: [PATCH 6.6 000/129] 6.6.42-rc1 review
Date: Tue, 23 Jul 2024 20:22:28 +0200
Message-ID: <20240723180404.759900207@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.42-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.42-rc1
X-KernelTest-Deadline: 2024-07-25T18:04+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.42 release.
There are 129 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.42-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.42-rc1

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix slab-use-after-free in cachefiles_withdraw_cookie()

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix slab-use-after-free in fscache_withdraw_volume()

Baokun Li <libaokun1@huawei.com>
    netfs, fscache: export fscache_put_volume() and add fscache_try_get_volume()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't wake up rx_sync_waitq upon RFKILL

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: disable softirqs for queued frame handling

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: wext: set ssids=NULL for passive scans

Marc Zyngier <maz@kernel.org>
    of/irq: Disable "interrupt-map" parsing for PASEMI Nemo

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix deadlock

Yang Shi <yang@os.amperecomputing.com>
    mm: page_ref: remove folio_try_get_rcu()

Masahiro Yamada <masahiroy@kernel.org>
    ARM: 9324/1: fix get_user() broken with veneer

Steve French <stfrench@microsoft.com>
    cifs: fix noisy message on copy_file_range

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use imply for suggesting CONFIG_SERIAL_MULTI_INSTANTIATE

David Lechner <dlechner@baylibre.com>
    spi: mux: set ctlr->bits_per_word_mask

Daniel Borkmann <daniel@iogearbox.net>
    selftests/bpf: Extend tcx tests to cover late tcx_entry release

Edward Adam Davis <eadavis@qq.com>
    hfsplus: fix uninit-value in copy_name

John Hubbard <jhubbard@nvidia.com>
    selftests/vDSO: fix clang build errors and warnings

John Hubbard <jhubbard@nvidia.com>
    selftest/timerns: fix clang build failures for abs() calls

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-pcm: Limit the maximum number of periods by MAX_BDL_ENTRIES

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return FILE_DEVICE_DISK instead of super magic

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: imx: Don't expect DMA for i.MX{25,35,50,51,53} cspi devices

Puranjay Mohan <puranjay@kernel.org>
    riscv: stacktrace: fix usage of ftrace_graph_ret_addr()

Samuel Holland <samuel.holland@sifive.com>
    drivers/perf: riscv: Reset the counter to hpmevent mapping while starting cpus

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: properly set WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK

Christian Brauner <brauner@kernel.org>
    fs: better handle deep ancestor chains in is_subdir()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/radeon: check bo_va->bo is non-NULL before using it

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix refresh rate range for some panel

Alvin Lee <alvin.lee2@amd.com>
    drm/amd/display: Account for cursor prefetch BW in DML1 mode support

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Add refresh rate range check

Gao Xiang <xiang@kernel.org>
    erofs: ensure m_llen is reset to 0 if metadata is invalid

Edward Adam Davis <eadavis@qq.com>
    bluetooth/l2cap: sync sock recv cb and release

Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
    Bluetooth: btnxpuart: Enable Power Save feature on startup

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: hci_core: cancel all works upon hci_unregister_dev()

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    tee: optee: ffa: Fix missing-field-initializers warning

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed

Ganesh Goudar <ganeshgr@linux.ibm.com>
    powerpc/eeh: avoid possible crash when edev->pdev changes

Anjali K <anjalik@linux.ibm.com>
    powerpc/pseries: Whitelist dtl slub object for copying to userspace

Yunshui Jiang <jiangyunshui@kylinos.cn>
    net: mac802154: Fix racy device stats updates by DEV_STATS_INC() and DEV_STATS_ADD()

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FN912 compositions

Vyacheslav Frantsishko <itmymaill@gmail.com>
    ASoC: amd: yc: Fix non-functional mic on ASUS M5602RA

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: dmaengine_pcm: terminate dmaengine before synchronize

Aivaz Latypov <reichaivaz@gmail.com>
    ALSA: hda/relatek: Enable Mute LED on HP Laptop 15-gw0xxx

Takashi Iwai <tiwai@suse.de>
    ALSA: PCM: Allow resume only for suspended streams

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Add tx check to prevent skb leak

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix quota root leak after quota disable failure

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Use ACPI device handle when evaluating WMAB/WMBB

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Change ACPI device id

Armin Wolf <W_Armin@gmx.de>
    platform/x86: lg-laptop: Remove LGEX0815 hotkey handling

Armin Wolf <W_Armin@gmx.de>
    platform/x86: wireless-hotkey: Add support for LG Airplane Button

Chen Ni <nichen@iscas.ac.cn>
    platform/mellanox: nvsw-sn2201: Add check for platform_device_add_resources

Heiko Carstens <hca@linux.ibm.com>
    s390/sclp: Fix sclp_init() cleanup on failure

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-pf: Fix coverity and klockwork issues in octeon PF driver

Ian Ray <ian.ray@gehealthcare.com>
    gpio: pca953x: fix pca953x_irq_bus_sync_unlock race

Chen Ni <nichen@iscas.ac.cn>
    can: kvaser_usb: fix return value for hif_usb_send_regout

Alexander Stein <alexander.stein@ew.tq-group.com>
    Input: ads7846 - use spi_device_id table

Boyang Yu <yuboyang@dapustor.com>
    nvme: fix NVME_NS_DEAC may incorrectly identifying the disk as EXT_LBA.

Jack Yu <jack.yu@realtek.com>
    ASoC: rt722-sdca-sdw: add debounce time for type detection

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: sof-audio: Skip unprepare for in-use widgets on error rollback

Primoz Fiser <primoz.fiser@norik.com>
    ASoC: ti: omap-hdmi: Fix too long driver name

Jai Luthra <j-luthra@ti.com>
    ASoC: ti: davinci-mcasp: Set min period size using FIFO config

Jai Luthra <j-luthra@ti.com>
    ALSA: dmaengine: Synchronize dma channel after drop()

Thomas GENTY <tomlohave@gmail.com>
    bytcr_rt5640 : inverse jack detect for Archos 101 cesium

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Do not assign fields that are already set

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Fix references to freed memory

Luke D. Jones <luke@ljones.dev>
    Input: xpad - add support for ASUS ROG RAIKIRI PRO

Jack Yu <jack.yu@realtek.com>
    ASoC: rt722-sdca-sdw: add silence detection register as volatile

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    Input: i8042 - add Ayaneo Kun to i8042 quirk table

Jonathan Denose <jdenose@google.com>
    Input: elantech - fix touchpad state on resume for Lenovo N24

Arnd Bergmann <arnd@arndb.de>
    mips: fix compat_sys_lseek syscall

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l56: Select SERIAL_MULTI_INSTANTIATE

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdgpu: Indicate CU havest info to CP

Adrian Moreno <amorenoz@redhat.com>
    selftests: openvswitch: Set value to nla flags.

Linus Torvalds <torvalds@linux-foundation.org>
    cpumask: limit FORCE_NR_CPUS to just the UP case

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: Fix OCTAL mode support

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Add more codec ID to no shutup pins list

Alexey Makhalov <alexey.makhalov@broadcom.com>
    drm/vmwgfx: Fix missing HYPERVISOR_GUEST dependency

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Prevent UAF in kvm_spapr_tce_attach_iommu_group()

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Support Lenovo Thinkbook 16P Gen 5

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: wext: add extra SIOCSIWSCAN data check

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix lifecycle of codec pointer

Daniel Wagner <dwagner@suse.de>
    nvmet: always initialize cqe.result

Chunguang Xu <chunguang.xu@shopee.com>
    nvme: avoid double free special payload

Douglas Anderson <dianders@chromium.org>
    drm/mediatek: Call drm_atomic_helper_shutdown() at shutdown time

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    drm: panel-orientation-quirks: Add quirk for Aya Neo KUN

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/exynos: dp: drop driver owner initialization

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    iomap: Fix iomap_adjust_read_range for plen calculation

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: demote client disconnect warning on suspend to debug

Yuntao Wang <yuntao.wang@linux.dev>
    fs/file: fix the check in find_next_fd()

Baokun Li <libaokun1@huawei.com>
    cachefiles: make on-demand read killable

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Set object to close if ondemand_id < 0 in copen

Baokun Li <libaokun1@huawei.com>
    cachefiles: add consistency check for copen/cread

Scott Mayhew <smayhew@redhat.com>
    nfs: don't invalidate dentries on transient errors

Jan Kara <jack@suse.cz>
    nfs: Avoid flushing many pages with NFS_FILE_SYNC

Sagi Grimberg <sagi@grimberg.me>
    nfs: propagate readlink errors in nfs_symlink_filler

Dmitry Mastykin <mastichi@gmail.com>
    NFSv4: Fix memory leak in nfs4_set_security_label

Louis Dalibard <ontake@ontake.dev>
    HID: Ignore battery for ELAN touchscreens 2F2C and 4116

Aseda Aboagye <aaboagye@chromium.org>
    input: Add support for "Do Not Disturb"

Aseda Aboagye <aaboagye@chromium.org>
    input: Add event code for accessibility key

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: remove wrong expr_trans_bool()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: give a proper initial state to the Save button

Andreas Hindborg <a.hindborg@samsung.com>
    null_blk: fix validation of block size

Wei Li <liwei391@huawei.com>
    arm64: armv8_deprecated: Fix warning in isndep cpuhp starting process

Eric Dumazet <edumazet@google.com>
    ila: block BH in ila_output()

Eric Dumazet <edumazet@google.com>
    net: ipv6: rpl_iptunnel: block BH in rpl_output() and rpl_input()

Hans de Goede <hdegoede@redhat.com>
    Input: silead - Always support 10 fingers

Rob Herring (Arm) <robh@kernel.org>
    of/irq: Factor out parsing of interrupt-map parent phandle+args from of_irq_parse_raw()

John Hubbard <jhubbard@nvidia.com>
    selftests/futex: pass _GNU_SOURCE without a value to the compiler

Michael Ellerman <mpe@ellerman.id.au>
    selftests/openat2: Fix build warnings on ppc64

Michael Ellerman <mpe@ellerman.id.au>
    selftests: cachestat: Fix build warnings on ppc64

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: mac80211: fix UBSAN noise in ieee80211_prep_hw_scan()

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlwifi: mvm: Fix scan abort handling with HW rfkill

Ayala Beker <ayala.beker@intel.com>
    wifi: iwlwifi: mvm: properly set 6 GHz channel direct probe option

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: handle BA session teardown in RF-kill

Yedidya Benshimol <yedidya.ben.shimol@intel.com>
    wifi: iwlwifi: mvm: Handle BIGTK cipher in kek_kck cmd

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: mvm: remove stale STA link data during restart

Yedidya Benshimol <yedidya.ben.shimol@intel.com>
    wifi: iwlwifi: mvm: d3: fix WoWLAN command version lookup

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix 6 GHz scan request building

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: handle tasklet frames before stopping

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: apply mcast rate only if interface is up

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: init nonpeer_pm to active by default in mesh sdata

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    tools/power/cpupower: Fix Pstate frequency reporting on AMD Family 1Ah CPUs

Armin Wolf <W_Armin@gmx.de>
    ACPI: EC: Avoid returning AE_OK on errors in address space handler

Armin Wolf <W_Armin@gmx.de>
    ACPI: EC: Abort address space access upon error

Nathan Chancellor <nathan@kernel.org>
    efi/libstub: zboot.lds: Discard .discard sections

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Set qed_slowpath_params to zero before use

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Wait for stag work during unload

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Don't process stag work during unload and recovery

Justin Stitt <justinstitt@google.com>
    scsi: sr: Fix unintentional arithmetic wraparound

Martin Wilck <martin.wilck@suse.com>
    scsi: core: alua: I/O errors for ALUA state transitions

Jann Horn <jannh@google.com>
    filelock: Remove locks reliably when fcntl/close race is detected


-------------

Diffstat:

 Documentation/cdrom/cdrom-standard.rst             |   4 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/uaccess.h                     |  14 +-
 arch/arm64/kernel/armv8_deprecated.c               |   3 +
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   2 +-
 arch/powerpc/kernel/eeh_pe.c                       |   7 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  18 ++-
 arch/powerpc/platforms/pseries/setup.c             |   4 +-
 arch/riscv/kernel/stacktrace.c                     |   3 +-
 drivers/acpi/ec.c                                  |   9 +-
 drivers/block/null_blk/main.c                      |   4 +-
 drivers/bluetooth/btnxpuart.c                      |   2 +-
 drivers/firmware/efi/libstub/zboot.lds             |   1 +
 drivers/gpio/gpio-pca953x.c                        |   2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |  15 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  52 +++++++-
 .../amd/display/dc/dml/dcn32/display_mode_vba_32.c |   3 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/exynos/exynos_dp.c                 |   1 -
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |   8 ++
 drivers/gpu/drm/radeon/radeon_gem.c                |   2 +-
 drivers/gpu/drm/vmwgfx/Kconfig                     |   2 +-
 drivers/hid/hid-debug.c                            |   2 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-input.c                            |  13 ++
 drivers/input/joystick/xpad.c                      |   1 +
 drivers/input/mouse/elantech.c                     |  31 +++++
 drivers/input/serio/i8042-acpipnpio.h              |  18 ++-
 drivers/input/touchscreen/ads7846.c                |  12 +-
 drivers/input/touchscreen/silead.c                 |  19 +--
 drivers/misc/mei/main.c                            |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  12 ++
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  10 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  55 ++++----
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  16 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  47 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   5 +
 drivers/nvme/host/core.c                           |   1 +
 drivers/nvme/host/nvme.h                           |   2 +-
 drivers/nvme/target/core.c                         |   1 +
 drivers/nvme/target/fabrics-cmd-auth.c             |   3 -
 drivers/nvme/target/fabrics-cmd.c                  |   6 -
 drivers/of/irq.c                                   | 143 +++++++++++----------
 drivers/of/of_private.h                            |   3 +
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/platform/mellanox/nvsw-sn2201.c            |   5 +-
 drivers/platform/x86/lg-laptop.c                   |  89 +++++--------
 drivers/platform/x86/wireless-hotkey.c             |   2 +
 drivers/s390/char/sclp.c                           |   1 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |  31 +++--
 drivers/scsi/libsas/sas_internal.h                 |  14 ++
 drivers/scsi/qedf/qedf.h                           |   1 +
 drivers/scsi/qedf/qedf_main.c                      |  47 ++++++-
 drivers/scsi/sr.h                                  |   2 +-
 drivers/scsi/sr_ioctl.c                            |   5 +-
 drivers/spi/spi-imx.c                              |   2 +-
 drivers/spi/spi-mux.c                              |   1 +
 drivers/spi/spi.c                                  |   6 +-
 drivers/tee/optee/ffa_abi.c                        |  12 +-
 fs/afs/write.c                                     |   2 +-
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/cachefiles/cache.c                              |  45 ++++++-
 fs/cachefiles/ondemand.c                           |  74 ++++++++---
 fs/cachefiles/volume.c                             |   1 -
 fs/dcache.c                                        |  31 ++---
 fs/erofs/zmap.c                                    |   2 +
 fs/file.c                                          |   4 +-
 fs/fscache/internal.h                              |   2 -
 fs/fscache/volume.c                                |  14 ++
 fs/hfsplus/xattr.c                                 |   2 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/locks.c                                         |   9 +-
 fs/nfs/dir.c                                       |  27 ++--
 fs/nfs/nfs4proc.c                                  |   1 +
 fs/nfs/pagelist.c                                  |   5 +
 fs/nfs/symlink.c                                   |   2 +-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/smb/client/file.c                               |   4 +-
 fs/smb/common/smb2pdu.h                            |  34 +++++
 fs/smb/server/smb2pdu.c                            |   9 +-
 include/linux/cdrom.h                              |   2 +-
 include/linux/fscache-cache.h                      |   6 +
 include/linux/page_ref.h                           |  49 +------
 include/linux/spi/spi.h                            |   5 +-
 include/net/bluetooth/hci_sync.h                   |   2 +
 include/sound/dmaengine_pcm.h                      |   1 +
 include/trace/events/fscache.h                     |   4 +
 include/uapi/linux/input-event-codes.h             |   2 +
 lib/Kconfig                                        |   8 +-
 mm/filemap.c                                       |  10 +-
 mm/gup.c                                           |   2 +-
 net/bluetooth/hci_core.c                           |  76 ++++-------
 net/bluetooth/hci_sync.c                           |  13 ++
 net/bluetooth/l2cap_core.c                         |   3 +
 net/bluetooth/l2cap_sock.c                         |  14 +-
 net/ipv6/ila/ila_lwt.c                             |   7 +-
 net/ipv6/rpl_iptunnel.c                            |  14 +-
 net/mac80211/cfg.c                                 |   5 +-
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/main.c                                |  11 +-
 net/mac80211/mesh.c                                |   1 +
 net/mac80211/scan.c                                |  14 +-
 net/mac80211/util.c                                |   4 +
 net/mac802154/tx.c                                 |   8 +-
 net/wireless/rdev-ops.h                            |   6 +-
 net/wireless/scan.c                                |  59 ++++++---
 scripts/kconfig/expr.c                             |  29 -----
 scripts/kconfig/expr.h                             |   1 -
 scripts/kconfig/gconf.c                            |   3 +-
 scripts/kconfig/menu.c                             |   2 -
 sound/core/pcm_dmaengine.c                         |  22 ++++
 sound/core/pcm_native.c                            |   2 +
 sound/pci/hda/Kconfig                              |   2 +
 sound/pci/hda/cs35l56_hda.c                        |   5 +
 sound/pci/hda/patch_realtek.c                      |   7 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/rt722-sdca-sdw.c                  |   4 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  11 ++
 sound/soc/soc-generic-dmaengine-pcm.c              |   8 ++
 sound/soc/soc-topology.c                           |  29 +++--
 sound/soc/sof/intel/hda-pcm.c                      |   6 +
 sound/soc/sof/sof-audio.c                          |   2 +-
 sound/soc/ti/davinci-mcasp.c                       |   9 +-
 sound/soc/ti/omap-hdmi.c                           |   6 +-
 tools/power/cpupower/utils/helpers/amd.c           |  26 +++-
 tools/testing/selftests/bpf/config                 |   3 +
 tools/testing/selftests/bpf/prog_tests/tc_links.c  |  61 +++++++++
 tools/testing/selftests/cachestat/test_cachestat.c |   1 +
 tools/testing/selftests/futex/functional/Makefile  |   2 +-
 .../testing/selftests/net/openvswitch/ovs-dpctl.py |   2 +-
 tools/testing/selftests/openat2/openat2_test.c     |   1 +
 tools/testing/selftests/timens/exec.c              |   6 +-
 tools/testing/selftests/timens/timer.c             |   2 +-
 tools/testing/selftests/timens/timerfd.c           |   2 +-
 tools/testing/selftests/timens/vfork_exec.c        |   4 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |  16 ++-
 .../selftests/vDSO/vdso_standalone_test_x86.c      |  18 ++-
 144 files changed, 1168 insertions(+), 568 deletions(-)


