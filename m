Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4469225D7;
	Fri, 26 Jul 2024 07:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977968; cv=none; b=Ui7k8YbF0JJpsgLZnLwfS+RSGG9pFdnG+a1QLD9oGsPI+JYEfJ+Qn984tySQJYdIzQvbXWxGZLMK+av2CeM0Jps1CVJXSMtT7jPX3hgXsDNJrGw97gMOtBlU3DFkHFUHerRISgRGVgo3IREiURI0al+YqX8Oug70XQxZWDwVWD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977968; c=relaxed/simple;
	bh=qoBXrqnDIz1zFXImNDIFBu8XHdJm+4DGbRwrf5RCHO8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pR5sEjLWB2vlUE6sXtLDk1lUwNasC7GM2rRg2LY+ThUrS4K44yYcFY2kV8fmPEqw8PrlrolbIE90+bsCAmgkJbHu4X5+rgwwlly38PinQw6JNTyBNT4MJh2sspcs6NBVg5UgJgCp3/bO1u0aAP4rL8lAsgSvSOwmmhGStdgcwBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6xil6uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6xil6uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998AAC32782;
	Fri, 26 Jul 2024 07:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721977968;
	bh=qoBXrqnDIz1zFXImNDIFBu8XHdJm+4DGbRwrf5RCHO8=;
	h=From:To:Cc:Subject:Date:From;
	b=B6xil6uP7CuOcO08CEYaymHb9nZ97TimOw9//7oO/y7oP/X0OfclGg6BRuGzAWqg6
	 eeYasbe/iMLy0xQBdJ3VphaX1AYEda9AuEVNbwoVVa291R/hpdiWZWqzu6QcVx+wIo
	 sTAdnA7X/7gu7J73aTfcZROXUt5x7aObwUx67UIs=
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
Subject: [PATCH 5.15 00/90] 5.15.164-rc2 review
Date: Fri, 26 Jul 2024 09:12:44 +0200
Message-ID: <20240726070557.506802053@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.164-rc2
X-KernelTest-Deadline: 2024-07-28T07:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.164 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 28 Jul 2024 07:05:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.164-rc2

Si-Wei Liu <si-wei.liu@oracle.com>
    tap: add missing verification for short frame

Dongli Zhang <dongli.zhang@oracle.com>
    tun: add missing verification for short frame

Jason A. Donenfeld <Jason@zx2c4.com>
    wifi: rt2x00: use explicitly signed or unsigned types

Jann Horn <jannh@google.com>
    filelock: Fix fcntl/close race recovery compat path

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: pcm_dmaengine: Don't synchronize DMA channel when DMA is paused

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB

Seunghun Han <kkamagui@gmail.com>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo SU C1400

lei lu <llfamsec@gmail.com>
    fs/ntfs3: Validate ff offset

lei lu <llfamsec@gmail.com>
    jfs: don't walk off the end of ealist

lei lu <llfamsec@gmail.com>
    ocfs2: add bounds checking to ocfs2_check_dir_entry()

Paolo Abeni <pabeni@redhat.com>
    net: relax socket state check at accept time.

Linus Torvalds <torvalds@linux-foundation.org>
    Add gitignore file for samples/fanotify/ subdirectory

Gabriel Krisman Bertazi <krisman@collabora.com>
    docs: Fix formatting of literal sections in fanotify docs

Gabriel Krisman Bertazi <krisman@collabora.com>
    samples: Make fs-monitor depend on libc and headers

Gabriel Krisman Bertazi <krisman@collabora.com>
    samples: Add fs error monitoring example

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: disable softirqs for queued frame handling

SeongJae Park <sj@kernel.org>
    mm/damon/core: merge regions aggressively when max_nr_regions is unmet

David Laight <David.Laight@ACULAB.COM>
    minmax: relax check to allow comparison between unsigned arguments and signed constants

David Laight <David.Laight@ACULAB.COM>
    minmax: allow comparisons of 'int' against 'unsigned char/short'

David Laight <David.Laight@ACULAB.COM>
    minmax: allow min()/max()/clamp() if the arguments have the same signedness.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    minmax: fix header inclusions

Jason A. Donenfeld <Jason@zx2c4.com>
    minmax: clamp more efficiently by avoiding extra comparison

Jason A. Donenfeld <Jason@zx2c4.com>
    minmax: sanity check constant bounds when clamping

Bart Van Assche <bvanassche@acm.org>
    tracing: Define the is_signed_type() macro once

David Lechner <dlechner@baylibre.com>
    spi: mux: set ctlr->bits_per_word_mask

Edward Adam Davis <eadavis@qq.com>
    hfsplus: fix uninit-value in copy_name

John Hubbard <jhubbard@nvidia.com>
    selftests/vDSO: fix clang build errors and warnings

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: imx: Don't expect DMA for i.MX{25,35,50,51,53} cspi devices

Puranjay Mohan <puranjay@kernel.org>
    riscv: stacktrace: fix usage of ftrace_graph_ret_addr()

Christian Brauner <brauner@kernel.org>
    fs: better handle deep ancestor chains in is_subdir()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/radeon: check bo_va->bo is non-NULL before using it

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: hci_core: cancel all works upon hci_unregister_dev()

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

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: dmaengine_pcm: terminate dmaengine before synchronize

Aivaz Latypov <reichaivaz@gmail.com>
    ALSA: hda/relatek: Enable Mute LED on HP Laptop 15-gw0xxx

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

Heiko Carstens <hca@linux.ibm.com>
    s390/sclp: Fix sclp_init() cleanup on failure

Chen Ni <nichen@iscas.ac.cn>
    can: kvaser_usb: fix return value for hif_usb_send_regout

Primoz Fiser <primoz.fiser@norik.com>
    ASoC: ti: omap-hdmi: Fix too long driver name

Jai Luthra <j-luthra@ti.com>
    ASoC: ti: davinci-mcasp: Set min period size using FIFO config

Jai Luthra <j-luthra@ti.com>
    ALSA: dmaengine: Synchronize dma channel after drop()

Thomas GENTY <tomlohave@gmail.com>
    bytcr_rt5640 : inverse jack detect for Archos 101 cesium

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    Input: i8042 - add Ayaneo Kun to i8042 quirk table

Jonathan Denose <jdenose@google.com>
    Input: elantech - fix touchpad state on resume for Lenovo N24

Arnd Bergmann <arnd@arndb.de>
    mips: fix compat_sys_lseek syscall

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Add more codec ID to no shutup pins list

Alexey Makhalov <alexey.makhalov@broadcom.com>
    drm/vmwgfx: Fix missing HYPERVISOR_GUEST dependency

Michael Ellerman <mpe@ellerman.id.au>
    KVM: PPC: Book3S HV: Prevent UAF in kvm_spapr_tce_attach_iommu_group()

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: wext: add extra SIOCSIWSCAN data check

Chunguang Xu <chunguang.xu@shopee.com>
    nvme: avoid double free special payload

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: demote client disconnect warning on suspend to debug

Yuntao Wang <yuntao.wang@linux.dev>
    fs/file: fix the check in find_next_fd()

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

Michael Ellerman <mpe@ellerman.id.au>
    selftests/openat2: Fix build warnings on ppc64

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: mac80211: fix UBSAN noise in ieee80211_prep_hw_scan()

Ayala Beker <ayala.beker@intel.com>
    wifi: iwlwifi: mvm: properly set 6 GHz channel direct probe option

Yedidya Benshimol <yedidya.ben.shimol@intel.com>
    wifi: iwlwifi: mvm: Handle BIGTK cipher in kek_kck cmd

Yedidya Benshimol <yedidya.ben.shimol@intel.com>
    wifi: iwlwifi: mvm: d3: fix WoWLAN command version lookup

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: handle tasklet frames before stopping

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: init nonpeer_pm to active by default in mesh sdata

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    tools/power/cpupower: Fix Pstate frequency reporting on AMD Family 1Ah CPUs

Armin Wolf <W_Armin@gmx.de>
    ACPI: EC: Avoid returning AE_OK on errors in address space handler

Armin Wolf <W_Armin@gmx.de>
    ACPI: EC: Abort address space access upon error

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Set qed_slowpath_params to zero before use

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Wait for stag work during unload

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Don't process stag work during unload and recovery

Martin Wilck <martin.wilck@suse.com>
    scsi: core: alua: I/O errors for ALUA state transitions

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a use-after-free

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix overrunning reservations in ringbuf

Kuan-Wei Chiu <visitorckw@gmail.com>
    ACPI: processor_idle: Fix invalid comparison with insertion sort for latency

Masahiro Yamada <masahiroy@kernel.org>
    ARM: 9324/1: fix get_user() broken with veneer

Jann Horn <jannh@google.com>
    filelock: Remove locks reliably when fcntl/close race is detected

Kees Cook <keescook@chromium.org>
    gcc-plugins: Rename last_stmt() for GCC 14+


-------------

Diffstat:

 .../admin-guide/filesystem-monitoring.rst          |  20 +--
 Makefile                                           |   4 +-
 arch/arm/include/asm/uaccess.h                     |  14 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   1 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |   1 +
 arch/arm64/kernel/armv8_deprecated.c               |   3 +
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   2 +-
 arch/powerpc/kernel/eeh_pe.c                       |   7 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  18 ++-
 arch/powerpc/platforms/pseries/setup.c             |   4 +-
 arch/riscv/kernel/stacktrace.c                     |   3 +-
 drivers/acpi/ec.c                                  |   9 +-
 drivers/acpi/processor_idle.c                      |  40 +++---
 drivers/block/null_blk/main.c                      |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   2 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |   2 +-
 drivers/gpu/drm/vmwgfx/Kconfig                     |   2 +-
 drivers/input/mouse/elantech.c                     |  31 +++++
 drivers/input/serio/i8042-acpipnpio.h              |  18 ++-
 drivers/input/touchscreen/silead.c                 |  19 +--
 drivers/misc/mei/main.c                            |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   2 +-
 drivers/net/tap.c                                  |   5 +
 drivers/net/tun.c                                  |   3 +
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  16 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   5 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.h     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  36 +++---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |   8 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   6 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.h       |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.h       |   2 +-
 drivers/nvme/host/core.c                           |   1 +
 drivers/platform/x86/lg-laptop.c                   |  89 +++++--------
 drivers/platform/x86/wireless-hotkey.c             |   2 +
 drivers/s390/char/sclp.c                           |   1 +
 drivers/scsi/device_handler/scsi_dh_alua.c         |  31 +++--
 drivers/scsi/hosts.c                               |  16 ++-
 drivers/scsi/libsas/sas_internal.h                 |  14 ++
 drivers/scsi/qedf/qedf.h                           |   1 +
 drivers/scsi/qedf/qedf_main.c                      |  47 ++++++-
 drivers/scsi/scsi_lib.c                            |   6 +-
 drivers/scsi/scsi_priv.h                           |   2 +-
 drivers/scsi/scsi_scan.c                           |   1 +
 drivers/scsi/scsi_sysfs.c                          |   1 +
 drivers/spi/spi-imx.c                              |   2 +-
 drivers/spi/spi-mux.c                              |   1 +
 fs/btrfs/qgroup.c                                  |   4 +-
 fs/dcache.c                                        |  31 ++---
 fs/file.c                                          |   4 +-
 fs/hfsplus/xattr.c                                 |   2 +-
 fs/jfs/xattr.c                                     |  23 +++-
 fs/locks.c                                         |  18 ++-
 fs/ntfs3/fslog.c                                   |   6 +-
 fs/ocfs2/dir.c                                     |  46 ++++---
 include/linux/compiler.h                           |   6 +
 include/linux/minmax.h                             |  87 +++++++++----
 include/linux/overflow.h                           |   1 -
 include/linux/trace_events.h                       |   2 -
 include/scsi/scsi_host.h                           |   2 +
 include/sound/dmaengine_pcm.h                      |   1 +
 kernel/bpf/ringbuf.c                               |  30 ++++-
 mm/damon/core.c                                    |  21 ++-
 net/bluetooth/hci_core.c                           |   4 +
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv6/ila/ila_lwt.c                             |   7 +-
 net/ipv6/rpl_iptunnel.c                            |  14 +-
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/main.c                                |  11 +-
 net/mac80211/mesh.c                                |   1 +
 net/mac80211/scan.c                                |  14 +-
 net/mac80211/util.c                                |   4 +
 net/mac802154/tx.c                                 |   8 +-
 net/wireless/scan.c                                |   8 +-
 samples/Kconfig                                    |   9 ++
 samples/Makefile                                   |   1 +
 samples/fanotify/.gitignore                        |   1 +
 samples/fanotify/Makefile                          |   5 +
 samples/fanotify/fs-monitor.c                      | 142 +++++++++++++++++++++
 scripts/gcc-plugins/gcc-common.h                   |   4 +
 scripts/kconfig/expr.c                             |  29 -----
 scripts/kconfig/expr.h                             |   1 -
 scripts/kconfig/gconf.c                            |   3 +-
 scripts/kconfig/menu.c                             |   2 -
 sound/core/pcm_dmaengine.c                         |  26 ++++
 sound/pci/hda/patch_realtek.c                      |   7 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  11 ++
 sound/soc/soc-generic-dmaengine-pcm.c              |   8 ++
 sound/soc/ti/davinci-mcasp.c                       |   9 +-
 sound/soc/ti/omap-hdmi.c                           |   6 +-
 tools/power/cpupower/utils/helpers/amd.c           |  26 +++-
 tools/testing/selftests/openat2/openat2_test.c     |   1 +
 tools/testing/selftests/vDSO/parse_vdso.c          |  16 ++-
 .../selftests/vDSO/vdso_standalone_test_x86.c      |  18 ++-
 102 files changed, 867 insertions(+), 365 deletions(-)


