Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2581C2EF655;
	Tue, 17 Jun 2025 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174128; cv=none; b=rHQo+eT02IUYiyhNxYP0HCML9DunntJ8Rmx2t8BqcwzhjOlxsGlZdunWTo1pP+uikBWw3SxiwFsYdccF10YhXkM10VO7bzdHsZCsSL0Gigz2i28Uud2rqDE5FfQMWyZ93XnyhHnXCOjugST20F1EqNAo5jFxflXBi73YPFaeTSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174128; c=relaxed/simple;
	bh=2QAmPucMHolYw3/PQsN2/r3RcRNZyIi3hBHqsUdDiho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tAgCOCgjoBQ3CPNRWAvNPGAfRN2+iSJSXJ3kUSN/1DcnHoC/ao7q2Hn0+FKr+lXxGEXAoNTV27orgyBOpe4FT9wVR8tT7jO4MQMhI7MwerDtyDnUiuR9uyVLYOSEVk9pz+IRf8+Cy2kCfCQEN/pwkYnRQUXr/hP44FZAfeZJmcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPwONmo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPwONmo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96600C4CEE7;
	Tue, 17 Jun 2025 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174127;
	bh=2QAmPucMHolYw3/PQsN2/r3RcRNZyIi3hBHqsUdDiho=;
	h=From:To:Cc:Subject:Date:From;
	b=OPwONmo9vXEBlPGFs0FQ9hRMUa+ckCMOh20oZE21MS2W9+7QPQGGttjBYlTTbcgmS
	 6YxNr0TkDvJDUccX2PI0TF9RSp/EO+0vCZAvu4hioEkEXsLZ6lf3oSrlKSordv5ZGz
	 LAIkF3F2+qIOsnNsZXtX03DB1FUTIy2x/sCWn+Xg=
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
Subject: [PATCH 6.15 000/780] 6.15.3-rc1 review
Date: Tue, 17 Jun 2025 17:15:08 +0200
Message-ID: <20250617152451.485330293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.15.3-rc1
X-KernelTest-Deadline: 2025-06-19T15:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.15.3 release.
There are 780 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.15.3-rc1

Andrew Price <anprice@redhat.com>
    gfs2: Don't clear sb->s_fs_info in gfs2_sys_fs_add

Kees Cook <kees@kernel.org>
    overflow: Introduce __DEFINE_FLEX for having no initializer

Oliver Neukum <oneukum@suse.com>
    net: usb: aqc111: debug info before sanitation

Arnd Bergmann <arnd@arndb.de>
    usb: misc: onboard_usb_dev: fix build warning for CONFIG_USB_ONBOARD_DEV_USB5744=n

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    regulator: dt-bindings: mt6357: Drop fixed compatible requirement

Al Viro <viro@zeniv.linux.org.uk>
    do_move_mount(): split the checks in subtree-of-our-ns and entire-anon cases

Eric Dumazet <edumazet@google.com>
    calipso: unlock rcu before returning -EAFNOSUPPORT

Xin Li (Intel) <xin@zytor.com>
    x86/fred/signal: Prevent immediate repeat of single step trap on return from SIGTRAP handler

Roman Kisel <romank@linux.microsoft.com>
    x86/hyperv: Fix APIC ID and VP index confusion in hv_snp_boot_ap()

Thomas Gleixner <tglx@linutronix.de>
    x86/iopl: Cure TIF_IO_BITMAP inconsistencies

Stefano Stabellini <stefano.stabellini@amd.com>
    xen/arm: call uaccess_ttbr0_enable for dm_op hypercall

Dave Chinner <dchinner@redhat.com>
    xfs: don't assume perags are initialised when trimming AGs

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Move cpus_read_lock() outside of buffer->mutex

Dmitry Antipov <dmantipov@yandex.ru>
    ring-buffer: Fix buffer locking in ring_buffer_subbuf_order_set()

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Do not trigger WARN_ON() due to a commit_overrun

Jens Axboe <axboe@kernel.dk>
    mm/filemap: use filemap_end_dropbehind() for read invalidation

Jens Axboe <axboe@kernel.dk>
    mm/filemap: gate dropbehind invalidate on folio !dirty && !writeback

Al Viro <viro@zeniv.linux.org.uk>
    Don't propagate mounts into detached trees

Matthew Wilcox (Oracle) <willy@infradead.org>
    9p: Add a migrate_folio method

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: move tcpm_queue_vdm_unlocked to asynchronous work

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: Flush altsetting 0 endpoints before reinitializating them after reset.

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with detecting USB 3.2 speed

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with detecting command completion event

Jonathan Stroud <jonathan.stroud@amd.com>
    usb: misc: onboard_usb_dev: Fix usb5744 initialization sequence

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: serial: 8250_omap: fix TX with DMA for am33xx

Wupeng Ma <mawupeng1@huawei.com>
    VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix read_stb function and get_stb ioctl

Peter Korsgaard <peter@korsgaard.com>
    nvmem: zynqmp_nvmem: unbreak driver after cleanup

Oleg Nesterov <oleg@redhat.com>
    posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del()

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/kernel: Fix ppc_save_regs inclusion in build

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: usbhid: Eliminate recurrent out-of-bounds bug in usbhid_parse()

David Heimann <d@dmeh.net>
    ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Kill timer properly at removal

Mike Rapoport (Microsoft) <rppt@kernel.org>
    Revert "mm/execmem: Unify early execmem_cache behaviour"

Francesco Dolcini <francesco.dolcini@toradex.com>
    Revert "wifi: mwifiex: Fix HT40 bandwidth issue."

Suleiman Souhlal <suleiman@google.com>
    tools/resolve_btfids: Fix build when cross compiling kernel with clang.

Mike Yuan <me@yhndnzj.com>
    pidfs: never refuse ppid == 0 in PIDFD_GET_INFO

Benno Lossin <lossin@kernel.org>
    rust: list: fix path of `assert_pinned!`

Gary Guo <gary@garyguo.net>
    rust: compile libcore with edition 2024 for 1.87+

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: relax slice condition to cover more `noreturn` Rust functions

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    uapi: bitops: use UAPI-safe variant of BITS_PER_LONG again

Matthew Wilcox (Oracle) <willy@infradead.org>
    block: Fix bvec_set_folio() for very large folios

Matthew Wilcox (Oracle) <willy@infradead.org>
    bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix perf regression with deferred closes

Keith Busch <kbusch@kernel.org>
    io_uring: consistently use rcu semantics with sqpoll thread

Christoph Hellwig <hch@lst.de>
    block: don't use submit_bio_noacct_nocheck in blk_zone_wplug_bio_work

Penglei Jiang <superman.xpt@gmail.com>
    io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()

Ming Lei <ming.lei@redhat.com>
    block: use q->elevator with ->elevator_lock held in elv_iosched_show()

Peter Zijlstra <peterz@infradead.org>
    perf: Ensure bpf_perf_link path is properly serialized

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix spurious drain flushing

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: access fcpreq only when holding reqlock

Filipe Manana <fdmanana@suse.com>
    btrfs: exit after state split error at set_extent_bit()

Christian Brauner <brauner@kernel.org>
    gfs2: pass through holder from the VFS for freeze/thaw

Filipe Manana <fdmanana@suse.com>
    btrfs: fix fsync of files with no hard links not persisting deletion

Zijun Hu <quic_zijuhu@quicinc.com>
    fs/filesystems: Fix potential unsigned integer underflow in fs_name()

Filipe Manana <fdmanana@suse.com>
    btrfs: exit after state insertion failure at btrfs_convert_extent_bit()

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/lrc: Use a temporary buffer for WA BB

Gal Pressman <gal@nvidia.com>
    net: ethtool: Don't check if RSS context exists in case of context 0

Jakub Kicinski <kuba@kernel.org>
    net: drv: netdevsim: don't napi_complete() from netpoll

Eric Dumazet <edumazet@google.com>
    net_sched: ets: fix a race in ets_qdisc_change()

Eric Dumazet <edumazet@google.com>
    net_sched: tbf: fix a race in tbf_change()

Eric Dumazet <edumazet@google.com>
    net_sched: red: fix a race in __red_change()

Eric Dumazet <edumazet@google.com>
    net_sched: prio: fix a race in prio_tune()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: phy: phy_caps: Don't skip better duplex macth on non-exact match

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix number of lanes to UNKNOWN when using data_rate_oper

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix leak of Geneve TLV option object

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, make sure the uplink is the last destination

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, fix missing ip_version handling in definer

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix return value when searching for existing flow group

Amir Tzin <amirtz@nvidia.com>
    net/mlx5: Fix ECVF vports unload on shutdown flow

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Ensure fw pages are always allocated on same NUMA

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix sparse errors

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: eir: Fix possible crashes on eir_create_adv_data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix NULL pointer deference on eir_get_service_data

Jakub Raczynski <j.raczynski@samsung.com>
    net/mdiobus: Fix potential out-of-bounds clause 45 read/write access

Jakub Raczynski <j.raczynski@samsung.com>
    net/mdiobus: Fix potential out-of-bounds read/write access

Carlos Fernandez <carlos.fernandez@technica-engineering.de>
    macsec: MACsec SCI assignment for ES = 0

Gustavo Luiz Duarte <gustavold@gmail.com>
    netconsole: fix appending sysdata when sysdata_fields == SYSDATA_RELEASE

Michal Luczaj <mhal@rbox.co>
    net: Fix TOCTOU issue in sk_is_readable()

Yunhui Cui <cuiyunhui@bytedance.com>
    ACPI: CPPC: Fix NULL pointer dereference when nosmp is used

Joe Damato <jdamato@fastly.com>
    e1000: Move cancel_work_sync to avoid deadlock

Anton Nadezhdin <anton.nadezhdin@intel.com>
    ice/ptp: fix crosstimestamp reporting

Ahmed Zaki <ahmed.zaki@intel.com>
    iavf: fix reset_task for early reset event

Robert Malz <robert.malz@canonical.com>
    i40e: retry VFLR handling if there is ongoing VF reset

Robert Malz <robert.malz@canonical.com>
    i40e: return false from i40e_reset_vf if reset is in progress

Chen-Yu Tsai <wens@csie.org>
    pinctrl: sunxi: dt: Consider pin base when calculating bank number from pin

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix more rounding issues with 59.94Hz modes

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use vclk_freq instead of pixel_freq in debug print

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix debug log statement when setting the HDMI clocks

Gabriel Dalimonte <gabriel.dalimonte@gmail.com>
    drm/vc4: fix infinite EPROBE_DEFER loop

Haren Myneni <haren@linux.ibm.com>
    powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: fix a potential crash on gso_skb handling

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: iscsi: Fix incorrect error path labels for flashnode operations

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix incorrect PSP firmware size

Wojciech Slenska <wojciech.slenska@gmail.com>
    pinctrl: qcom: pinctrl-qcm2290: Add missing pins

Félix Piédallu <felix.piedallu@non.se.com>
    spi: omap2-mcspi: Disable multi-mode when the previous message kept CS asserted

Félix Piédallu <felix.piedallu@non.se.com>
    spi: omap2-mcspi: Disable multi mode when CS should be kept asserted after message

Dan Carpenter <dan.carpenter@linaro.org>
    regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix uaf in ath12k_core_init()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix GCC_GCC_PCIE_HOT_RST definition for WCN7850

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: refactor ath12k_hw_regs structure

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    wifi: ath11k: validate ath11k_crypto_mode on top of ath11k_core_qmi_firmware_ready

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: move some firmware stats related functions outside of debugfs

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't wait when there is no vdev started

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't use static variables in ath11k_debugfs_fw_stats_process()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()

Caleb Connolly <caleb.connolly@linaro.org>
    ath10k: snoc: fix unbalanced IRQ enable in crash recovery

Jeongjun Park <aha310510@gmail.com>
    ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix untagged traffic sent via cpu tagged with VID 0

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Protect mgmt_pending list with its own lock

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix UAF on mgmt_remove_adv_monitor_complete

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: Reduce driver buffer posting to prevent race condition

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: Increase the tx and rx descriptor count

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Fix driver not posting maximum rx buffers

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_core: fix list_for_each_entry_rcu usage

Sanjeev Yadav <sanjeev.y@mediatek.com>
    scsi: core: ufs: Fix a hang in the error handler

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: add gs101 specific eint suspend/resume callbacks

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: add dedicated SoC eint suspend/resume callbacks

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: refactor drvdata suspend & resume callbacks

Gautham R. Shenoy <gautham.shenoy@amd.com>
    tools/power turbostat: Fix AMD package-energy reporting

Petr Pavlu <petr.pavlu@suse.com>
    genksyms: Fix enum consts from a reference affecting new values

Al Viro <viro@zeniv.linux.org.uk>
    do_change_type(): refuse to operate on unmounted/not ours mounts

Al Viro <viro@zeniv.linux.org.uk>
    clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns

KONDO KAZUMA(近藤　和真) <kazuma-kondo@nec.com>
    fs: allow clone_private_mount() for a path on real rootfs

Al Viro <viro@zeniv.linux.org.uk>
    fix propagation graph breakage by MOVE_MOUNT_SET_GROUP move_mount(2)

Al Viro <viro@zeniv.linux.org.uk>
    finish_automount(): don't leak MNT_LOCKED from parent to child

Stephen Brennan <stephen.s.brennan@oracle.com>
    fs: convert mount flags to enum

Al Viro <viro@zeniv.linux.org.uk>
    path_overmount(): avoid false negatives

Al Viro <viro@zeniv.linux.org.uk>
    fs/fhandle.c: fix a race in call of has_locked_children()

Nitesh Shetty <nj.shetty@samsung.com>
    iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec

Yuuki NAGAO <wf.yn386@gmail.com>
    ASoC: ti: omap-hdmi: Re-add dai_link->platform to fix card init

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Verify content returned by parse_int_array()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Verify kcalloc() status when setting constraints

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Fix paths in MODULE_FIRMWARE hints

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Relocate DSP status registers

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Read HW capabilities when possible

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Ignore Vendor-space manipulation for ACE

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix possible null-ptr-deref when initing hw

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix PPLCxFMT calculation

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: PCM operations for LNL-based platforms

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Allow to fetch hlink by ID

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: hda: Fix RPM usage count underflow

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: qcom: Prevent calling phy_exit() before phy_init()

Can Guo <quic_cang@quicinc.com>
    scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock freq

Ziqi Chen <quic_ziqichen@quicinc.com>
    scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear()

Nylon Chen <nylon.chen@sifive.com>
    riscv: misaligned: fix sleeping function called during misaligned access handling

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/pxp: Clarify PXP queue creation behavior if PXP is not ready

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/pxp: Use the correct define in the set_property_funcs array

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Rework eviction rejection of bound external bos

Arnd Bergmann <arnd@arndb.de>
    drm/xe/vsec: fix CONFIG_INTEL_VSEC dependency

Matthew Auld <matthew.auld@intel.com>
    drm/xe/vm: move xe_svm_init() earlier

Ido Schimmel <idosch@nvidia.com>
    seg6: Fix validation of nexthop addresses

Eric Dumazet <edumazet@google.com>
    net: prevent a NULL deref in rtnl_create_link()

Eric Dumazet <edumazet@google.com>
    net: annotate data-races around cleanup_net_task

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: tso: make bkg() wait for socat to quit

Jakub Kicinski <kuba@kernel.org>
    selftests: drv-net: tso: fix the GRE device name

Mirco Barone <mirco.barone@polito.it>
    wireguard: device: enable threaded NAPI

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: rt-link: decode ip6gre

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: rt-link: add missing byte-order properties

Daniele Palmas <dnlplm@gmail.com>
    net: wwan: mhi_wwan_mbim: use correct mux_id for multiplexing

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: cfg80211/mac80211: correctly parse S1G beacon optional elements

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not touch DLL_IQQD on bcm53115

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: allow RGMII for bcm63xx RGMII ports

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not configure bcm63xx's IMP port interface

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: implement setting ageing time

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable RGMII delay on bcm63xx

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable EEE on bcm63xx

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix swapped TX stats for MII interfaces.

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: also check reverse tuple to obtain clashing entry

Florian Westphal <fw@strlen.de>
    netfilter: nf_set_pipapo_avx2: fix initial map fill

Michael Walle <mwalle@kernel.org>
    drm/panel-simple: fix the warnings for the Evervision VGG644804

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: avoid panic on init failure

Dibin Moolakadan Subrahmanian <dibin.moolakadan.subrahmanian@intel.com>
    drm/i915/display: Fix u32 overflow in SNPS PHY HDMI PLL setup

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO

Pavel Begunkov <asml.silence@gmail.com>
    nvme: fix implicit bool to flags conversion

Keith Busch <kbusch@kernel.org>
    nvme: fix command limits status code

Caleb Sander Mateos <csander@purestorage.com>
    block: flip iter directions in blk_rq_integrity_map_user()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix power.is_suspended cleanup for direct-complete devices

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu/gfx10: Refine Cleaner Shader for GFX10.1.10

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    iavf: get rid of the crit lock

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    iavf: sprinkle netdev_assert_locked() annotations

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    iavf: extract iavf_watchdog_step() out of iavf_watchdog_task()

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    iavf: simplify watchdog_task in terms of adminq task scheduling

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    iavf: centralize watchdog requeueing itself

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    iavf: iavf_suspend(): take RTNL before netdev_lock()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Initialize PPE UPDMEM source-mac table

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add the capability to allocate hfwd descriptors in SRAM

Bui Quang Minh <minhquangbui99@gmail.com>
    selftests: net: build net/lib dependency in all target

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: correctly report gso type for UDP tunnels

Jinjian Song <jinjian.song@fibocom.com>
    net: wwan: t7xx: Fix napi rx poll issue

Shiming Cheng <shiming.cheng@mediatek.com>
    net: fix udp gso skb_segment after pull from frag_list

Yongting Lin <linyongting@gmail.com>
    um: Fix tgkill compile error on old host OSes

Jesus Narvaez <jesus.narvaez@intel.com>
    drm/i915/guc: Handle race condition where wakeref count drops below 0

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Fix using wrong mask in REG_FIELD_PREP

Jesus Narvaez <jesus.narvaez@intel.com>
    drm/i915/guc: Check if expecting reply before decrementing outstanding_submission_g2h

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Clarify the meaning of BPF_F_PSEUDO_HDR

Paul Chaignon <paul.chaignon@gmail.com>
    net: Fix checksum update for ILA adj-transport

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: stmmac: make sure that ptp_rate is not 0 before configuring EST

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: stmmac: make sure that ptp_rate is not 0 before configuring timestamping

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: tag_brcm: legacy: fix pskb_may_pull length

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: avoid mailbox timeout delays during reset

Brian Vazquez <brianvv@google.com>
    idpf: fix a race in txq wakeup

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix rebuilding the Tx scheduler tree for large queue counts

Michal Kubiak <michal.kubiak@intel.com>
    ice: create new Tx scheduler nodes for new queues only

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix Tx scheduler error handling in XDP callback

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: MGMT: reject malformed HCI_CMD_SYNC commands

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix shared reset

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-spi: fix shared reset

Yu Kuai <yukuai3@huawei.com>
    md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Make sure to insert the vlan tags also in host mode

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4_en: Prevent potential integer overflow calculating Hz

Yanqing Wang <ot_yanqing.wang@mediatek.com>
    driver: net: ethernet: mtk_star_emac: fix suspend/resume issue

Charalampos Mitrodimas <charmitro@posteo.net>
    net: tipc: fix refcount warning in tipc_aead_encrypt

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt

Quentin Schulz <quentin.schulz@cherry.de>
    net: stmmac: platform: guarantee uniqueness of bus_id

Dong Chenchen <dongchenchen2@huawei.com>
    page_pool: Fix use-after-free in page_pool_recycle_in_ring

Tengteng Yang <yangtengteng@bytedance.com>
    Fix sock_exceed_buf_limit not being triggered in __sk_mem_raise_allocated

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Add missing documentation of rpa_freq

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Make xe_gt_freq part of the Documentation

Heiko Stuebner <heiko@sntech.de>
    drm/bridge: analogix_dp: Fix clk-disable removal

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Add support to get panel from the DP AUX bus

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Remove CONFIG_PM related check in analogix_dp_bind()/analogix_dp_unbind()

Karol Wachowski <karol.wachowski@intel.com>
    accel/ivpu: Reorder Doorbell Unregister and Command Queue Destruction

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Remove the unnecessary calls to clk_disable_unprepare() during probing

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/connector: only call HDMI audio helper plugged cb if non-null

Ming Lei <ming.lei@redhat.com>
    loop: add file_start_write() and file_end_write()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: typec: fix const issue in typec_match()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: gadget: udc: fix const issue in gadget_match_driver()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: serial: bus: fix const issue in usb_serial_device_match()

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adc: mcp3911: fix device dependent mappings for conversion result registers

Marius Cristea <marius.cristea@microchip.com>
    iio: adc: PAC1934: fix typo in documentation link

Hans de Goede <hdegoede@redhat.com>
    mei: vsc: Cast tx_buf to (__be32 *) when passed to cpu_to_be32_array()

Roxana Nicolescu <nicolescu.roxana@protonmail.com>
    char: tlclk: Fix correct sysfs directory path for tlclk

Roxana Nicolescu <nicolescu.roxana@protonmail.com>
    misc: lis3lv02d: Fix correct sysfs directory path for lis3lv02d

Christian Schrefl <chrisi.schrefl@gmail.com>
    rust: miscdevice: fix typo in MiscDevice::ioctl documentation

Dave Penkler <dpenkler@gmail.com>
    staging: gpib: Fix secondary address restriction

Dave Penkler <dpenkler@gmail.com>
    staging: gpib: Fix PCMCIA config identifier

Nicolas Pitre <npitre@baylibre.com>
    vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: prevent deactivate active config while enabling the config

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: holding cscfg_csdev_lock while removing cscfg from csdev

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight/etm4: fix missing disable active config

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Fix timestamp bit field handling

Mao Jinlong <quic_jinlmao@quicinc.com>
    coresight: tmc: fix failure to disable/enable ETF after reading

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: ad4851: fix ad4858 chan pointer handling

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: adi-axi-dac: fix bus read

Qasim Ijaz <qasdev00@gmail.com>
    fpga: fix potential null pointer deref in fpga_mgr_test_img_load_sgt()

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    counter: interrupt-cnt: Protect enable/disable OPs with mutex

Yabin Cui <yabinc@google.com>
    coresight: core: Disable helpers for devices that fail to enable

Yabin Cui <yabinc@google.com>
    coresight: catu: Introduce refcount and spinlock for enabling/disabling

Junhao He <hejunhao3@huawei.com>
    coresight: Fixes device's owner field for registered using coresight_init_driver()

WangYuli <wangyuli@uniontech.com>
    MIPS: Loongson64: Add missing '#interrupt-cells' for loongson64c_ls7a

Chenyuan Yang <chenyuan0y@gmail.com>
    usb: acpi: Prevent null pointer dereference in usb_acpi_add_usb4_devlink()

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    iio: adc: ad7124: Fix 3dB filter frequency reading

Brian Pellegrino <bpellegrino@arka.org>
    iio: filter: admv8818: Support frequencies >= 2^32

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix range calculation

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix integer overflow

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix band 4, state 15

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Fix a logic error in wake on connect

Henry Martin <bsdhenrymartin@gmail.com>
    serial: Fix potential null-ptr-deref in mlb_usio_probe()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    usb: renesas_usbhs: Reorder clock handling and power management in probe

Andrea Righi <arighi@nvidia.com>
    sched_ext: idle: Skip cross-node search with !CONFIG_NUMA

Jerome Brunet <jbrunet@baylibre.com>
    PCI: endpoint: Retain fixed-size BAR size as well as aligned size

Miguel Ojeda <ojeda@kernel.org>
    rust: pci: fix docs related to missing Markdown code spans

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: loongson: Add missing alarm notifications for ACPI RTC events

Brian Norris <briannorris@google.com>
    PCI/pwrctrl: Cancel outstanding rescan work when unregistering

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Log Error Source ID only when valid

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Initialize aer_err_info before using it

Zhe Qiao <qiaozhe@iscas.ac.cn>
    PCI/ACPI: Fix allocated memory release on error in pci_acpi_scan_root()

Henry Martin <bsdhenrymartin@gmail.com>
    dmaengine: ti: Add NULL check in udma_probe()

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: only compute port params in specific stream states

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    phy: qcom-qusb2: reuse the IPQ6018 settings for IPQ5424

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    Revert "phy: qcom-qusb2: add QUSB2 support for IPQ5424"

Chenyuan Yang <chenyuan0y@gmail.com>
    phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug

Mario Limonciello <mario.limonciello@amd.com>
    PCI: Explicitly put devices into D0 when initializing

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Save and restore the LUT setting during suspend/resume for i.MX95 SoC

Hector Martin <marcan@marcan.st>
    PCI: apple: Use gpiod_set_value_cansleep in probe flow

Hans Zhang <18255117159@163.com>
    PCI: cadence: Fix runtime atomic count underflow

Jerome Brunet <jbrunet@baylibre.com>
    PCI: rcar-gen4: set ep BAR4 fixed size

Jensen Huang <jensenhuang@friendlyarm.com>
    PCI: rockchip: Fix order of rockchip_pci_core_rsts

Wilfred Mallawa <wilfred.mallawa@wdc.com>
    PCI: Print the actual delay time in pci_bridge_wait_for_secondary_bus()

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Ignore Link Down/Up caused by Secondary Bus Reset

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Ignore Presence Detect Changed caused by DPC

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Do no set rk_hdptx_phy->rate in case of errors

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Fix clock ratio setup

Wolfram Sang <wsa+renesas@sang-engineering.com>
    rtc: sh: assign correct interrupts with DT

Danilo Krummrich <dakr@kernel.org>
    rust: alloc: add missing invariant in Vec::set_len()

Pali Rohár <pali@kernel.org>
    cifs: Fix validation of SMB1 query reparse point response

Ian Rogers <irogers@google.com>
    perf callchain: Always populate the addr_location map when adding IP

Amir Goldstein <amir73il@gmail.com>
    exportfs: require ->fh_to_parent() to encode connectable file handles

Pekka Ristola <pekkarr@protonmail.com>
    rust: file: mark `LocalFile` as `repr(transparent)`

Alistair Popple <apopple@nvidia.com>
    fs/dax: Fix "don't skip locked entries when scanning entries"

Anubhav Shelat <ashelat@redhat.com>
    perf trace: Set errpid to false for rseq and set_robust_list

NeilBrown <neil@brown.name>
    nfs_localio: change nfsd_file_put_local() to take a pointer to __rcu pointer

NeilBrown <neil@brown.name>
    nfs_localio: protect race between nfs_uuid_put() and nfs_close_local_fh()

NeilBrown <neil@brown.name>
    nfs_localio: duplicate nfs_close_local_fh()

NeilBrown <neil@brown.name>
    nfs_localio: simplify interface to nfsd for getting nfsd_file

NeilBrown <neil@brown.name>
    nfs_localio: always hold nfsd net ref with nfsd_file ref

NeilBrown <neil@brown.name>
    nfs_localio: use cmpxchg() to install new nfs_file_localio

NeilBrown <neil@brown.name>
    nfs: fix incorrect handling of large-number NFS errors in nfs4_do_mkdir()

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when remounting nfs

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: clear SB_RDONLY before getting superblock

Anubhav Shelat <ashelat@redhat.com>
    perf trace: Always print return value for syscalls returning a pid

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf record: Fix incorrect --user-regs comments

David Hildenbrand <david@redhat.com>
    s390/uv: Improve splitting of large folios that cannot be split while dirty

David Hildenbrand <david@redhat.com>
    s390/uv: Always return 0 from s390_wiggle_split_folio() if successful

David Hildenbrand <david@redhat.com>
    s390/uv: Don't return 0 from make_hva_secure() if the operation was not successful

Ian Rogers <irogers@google.com>
    perf symbol: Fix use-after-free in filename__read_build_id

Ian Rogers <irogers@google.com>
    perf pmu: Avoid segv for missing name/alias_name in wildcarding

Jens Axboe <axboe@kernel.dk>
    iomap: don't lose folio dropbehind state for overwrites

Jason-JH Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Refine GCE_GCTL_VALUE setting

Peng Fan <peng.fan@nxp.com>
    mailbox: imx: Fix TXDB_V2 sending

Yue Haibing <yuehaibing@huawei.com>
    mailbox: mchp-ipc-sbi: Fix COMPILE_TEST build error

Leo Yan <leo.yan@arm.com>
    perf tests switch-tracking: Fix timestamp comparison

David Howells <dhowells@redhat.com>
    netfs: Fix undifferentiation of DIO reads from unbuffered reads

Alexey Gladkov <legion@kernel.org>
    mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Fix another error handling path in exynos_lpass_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Fix an error handling path in exynos_lpass_probe()

David Howells <dhowells@redhat.com>
    netfs: Fix wait/wake to be consistent about the waitqueue used

David Howells <dhowells@redhat.com>
    netfs: Fix the request's work item to not require a ref

Paulo Alcantara <pc@manguebit.com>
    netfs: Fix setting of transferred bytes with short DIO reads

David Howells <dhowells@redhat.com>
    netfs: Fix oops in write-retry from mis-resetting the subreq iterator

Dan Carpenter <dan.carpenter@linaro.org>
    rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Refactor sequential core power up/down operations

Siddharth Vadapalli <s-vadapalli@ti.com>
    remoteproc: k3-dsp: Drop check performed in k3_dsp_rproc_{mbox_callback/kick}

Siddharth Vadapalli <s-vadapalli@ti.com>
    remoteproc: k3-r5: Drop check performed in k3_r5_rproc_{mbox_callback/kick}

James Clark <james.clark@linaro.org>
    perf tools: Fix arm64 source package build

Dan Carpenter <dan.carpenter@linaro.org>
    remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix pattern matching with Python 3

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix PEBS-via-PT data_src

Michael Petlan <mpetlan@redhat.com>
    perf tests: Fix 'perf report' tests installation

Namhyung Kim <namhyung@kernel.org>
    perf trace: Fix leaks of 'struct thread' in set_filter_loop_pids()

Namhyung Kim <namhyung@kernel.org>
    perf trace: Fix leaks of 'struct thread' in fprintf_sys_enter()

Benjamin Marzinski <bmarzins@redhat.com>
    dm-flakey: make corrupting read bios work

Benjamin Marzinski <bmarzins@redhat.com>
    dm-flakey: error all IOs when num_features is absent

Benjamin Marzinski <bmarzins@redhat.com>
    dm: limit swapping tables for devices with zone write plugs

Benjamin Marzinski <bmarzins@redhat.com>
    dm: fix dm_blk_report_zones

Ian Rogers <irogers@google.com>
    perf symbol-minimal: Fix double free in filename__read_build_id

Alexei Safin <a.safin@rosa.ru>
    hwmon: (asus-ec-sensors) check sensor index in read_string()

Mikhail Arkhipov <m.arhipov@rosa.ru>
    mtd: nand: ecc-mxic: Fix use of uninitialized variable ret

Thomas Richter <tmricht@linux.ibm.com>
    perf tests metric-only perf stat: Fix tests 84 and 86 s390

Ian Rogers <irogers@google.com>
    perf tool_pmu: Fix aggregation on duration_time

Sean Christopherson <seanjc@google.com>
    x86/irq: Ensure initial PIR loads are performed exactly once

Geert Uytterhoeven <geert+renesas@glider.be>
    HID: HID_APPLETB_BL should depend on X86

Geert Uytterhoeven <geert+renesas@glider.be>
    HID: HID_APPLETB_KBD should depend on X86

Wentao Guan <guanwentao@uniontech.com>
    HID: intel-thc-hid: intel-quicki2c: pass correct arguments to acpi_evaluate_object

Henry Martin <bsdhenrymartin@gmail.com>
    backlight: pm8941: Add NULL check in wled_configure()

Benjamin Marzinski <bmarzins@redhat.com>
    dm: handle failures in dm_table_set_restrictions

Benjamin Marzinski <bmarzins@redhat.com>
    dm: free table mempools if not used in __bind

Benjamin Marzinski <bmarzins@redhat.com>
    dm: don't change md if dm_table_set_restrictions() fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui browser hists: Set actions->thread before calling do_zoom_thread()

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Don't show libbfd build status as it is opt-in

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Warn when libdebuginfod devel files are not available

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Don't show libunwind build status as it is opt-in

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Don't set libunwind as available if test-all.c build succeeds

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Fix attribute addition

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Remove bogus void member

Henry Martin <bsdhenrymartin@gmail.com>
    watchdog: lenovo_se30_wdt: Fix possible devm_ioremap() NULL pointer dereference in lenovo_se30_wdt_probe()

Sergey Shtylyov <s.shtylyov@omp.ru>
    fbdev: core: fbcvt: avoid division by 0 in fb_cvt_hperiod()

Kees Cook <kees@kernel.org>
    ubsan: integer-overflow: depend on BROKEN to keep this out of CI

Henry Martin <bsdhenrymartin@gmail.com>
    soc: aspeed: Add NULL check in aspeed_lpc_enable_snoop()

Su Hui <suhui@nfschina.com>
    soc: aspeed: lpc: Fix impossible judgment condition

Joel Stanley <joel@jms.id.au>
    ARM: aspeed: Don't select SRAM

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Rename RTC node to match binding expectations

Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
    arm64: dts: renesas: white-hawk-ard-audio: Fix TPU0 groups

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: qcs615: Fix up UFS clocks

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8998: Remove mdss_hdmi_phy phandle argument

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: msm8998: Use the header with DSI phy clock IDs

Dmitry Baryshkov <lumag@kernel.org>
    arm64: dts: qcom: qcm2290: fix (some) of QUP interconnects

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma

Pengyu Luo <mitltlatltl@gmail.com>
    arm64: dts: qcom: sm8650: add the missing l2 cache node

Vignesh Raman <vignesh.raman@collabora.com>
    arm64: defconfig: mediatek: enable PHY drivers

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064: move replicator out of soc node

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064: add missing clocks to the timer node

Andre Przywara <andre.przywara@arm.com>
    dt-bindings: vendor-prefixes: Add Liontron name

Robin Murphy <robin.murphy@arm.com>
    bus: fsl_mc: Fix driver_managed_dma check

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: fix double-free on mc_dev

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()

Wentao Liang <vulab@iscas.ac.cn>
    nilfs2: add pointer check for nilfs_direct_propagate()

Murad Masimov <m.masimov@mt-integration.ru>
    ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check return result of sb_min_blocksize

Barnabás Czémán <barnabas.czeman@mainlining.org>
    soc: qcom: smp2p: Fix fallback to qcom,ipc parse

Prasanth Babu Mantena <p-mantena@ti.com>
    arm64: dts: ti: k3-j721e-common-proc-board: Enable OSPI1 on J721E

Aaron Kling <webgeek1234@gmail.com>
    arm64: tegra: Add uartd serial alias for Jetson TX1 module

Aaron Kling <webgeek1234@gmail.com>
    arm64: tegra: Drop remaining serial clock-names and reset-names

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: white-hawk-single: Improve Ethernet TSN description

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Update eMMC for NanoPi R5 series

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: a100: set maximum MMC frequency

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3566-rock3c

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e001de-devkit: Fix pin config for USB0 retimer vregs

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e001de-devkit: Describe USB retimers resets pin configs

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Add missing 'compatible' property to regulators node

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    arm64: dts: mediatek: mt8390-genio-common: Set ssusb2 default dual role mode to host

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    arm64: dts: mediatek: mt6357: Drop regulator-fixed compatibles

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Set SAI5 MCLK direction to output for HDMI audio

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Set SAI5 MCLK direction to output for HDMI audio

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mp-beacon: Fix RTC capacitive load

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix RTC capacitive load

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix RTC capacitive load

Pin-yen Lin <treapking@chromium.org>
    arm64: dts: mt8183: Add port node to mt8183.dtsi

André Draszik <andre.draszik@linaro.org>
    firmware: exynos-acpm: silence EPROBE_DEFER error on boot

André Draszik <andre.draszik@linaro.org>
    firmware: exynos-acpm: fix reading longer results

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Reparent vdec1/2 and venc1 power domains

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8188: Fix IOMMU device for rdma0

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: at91sam9263: fix NAND chip selects

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: Move SHMEM memory to reserved memory on rk3588

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: Add missing uart3 interrupt for RK3528

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm8650: Fix domain-idle-state for CPU2

Tingguo Cheng <quic_tingguoc@quicinc.com>
    arm64: dts: qcom: qcs615: remove disallowed property in spmi bus node

Varadarajan Narayanan <quic_varada@quicinc.com>
    arm64: dts: qcom: ipq9574: Fix USB vdd info

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sc8280xp-x13s: Drop duplicate DMIC supplies

Jyothi Kumar Seerapu <quic_jseerapu@quicinc.com>
    arm64: dts: qcom: sm8750: Correct clocks property for uart14 node

Xilin Wu <wuxilin123@gmail.com>
    arm64: dts: qcom: sm8250: Fix CPU7 opp table

Maulik Shah <maulik.shah@oss.qualcomm.com>
    arm64: dts: qcom: sm8750: Fix cluster hierarchy for idle states

Manikanta Mylavarapu <quic_mmanikan@quicinc.com>
    arm64: dts: qcom: ipq9574: fix the msi interrupt numbers of pcie3

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm8350: Reenable crypto & cryptobam

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: remove excess reserved gpios

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: refactor node order

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: fix usb regulator mistake

Dzmitry Sankouski <dsankouski@gmail.com>
    arm64: dts: qcom: sdm845-starqltechn: remove wifi

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: x1e80100-romulus: Keep L12B and L15B always on

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8650: add missing cpu-cfg interconnect path in the mdss node

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8550: add missing cpu-cfg interconnect path in the mdss node

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8550: use ICC tag for all interconnect phandles

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: qcs8300: Partially revert "arm64: dts: qcom: qcs8300: add QCrypto nodes"

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sa8775p: Partially revert "arm64: dts: qcom: sa8775p: add QCrypto nodes"

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8650: setup gpu thermal with higher temperatures

Mark Kettenis <kettenis@openbsd.org>
    arm64: dts: qcom: x1e80100: Mark usb_2 as dma-coherent

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to correct check conditions in f2fs_cross_rename

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: use d_inode(dentry) cleanup dentry->d_inode

Chao Yu <chao@kernel.org>
    f2fs: fix to skip f2fs_balance_fs() if checkpoint is disabled

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: mscc: Stop clearing the the UDPv4 checksum for L2 frames

Faicker Mo <faicker.mo@zenlayer.com>
    net: openvswitch: Fix the dead loop of MPLS parse

Kuniyuki Iwashima <kuniyu@amazon.com>
    calipso: Don't call calipso functions for AF_INET sk.

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: QOS: Refactor TC_HTB_LEAF_DEL_LAST callback

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: QOS: Perform cache sync on send queue teardown

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: mscc: Fix memory leak when using one step timestamping

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Fix PHY reset handling during initialization and WOL

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: phy: fix up const issues in to_mdio_device() and to_phy_device()

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: start tx queue on netdev open

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: airoha: Fix an error handling path in airoha_alloc_gdm_port()

Wei Fang <wei.fang@nxp.com>
    net: phy: clear phydev->devlink when the link is deleted

Yonghong Song <yonghong.song@linux.dev>
    bpf: Do not include stack ptr register in precision backtracking bookkeeping

KaFai Wan <mannkafai@gmail.com>
    bpf: Avoid __bpf_prog_ret0_warn when jit fails

Israel Rukshin <israelr@nvidia.com>
    virtio-pci: Fix result size returned for the admin command completion

Stanislav Fomichev <stfomichev@gmail.com>
    af_packet: move notifier's packet_dev_mc out of rcu critical section

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Fix Tx skb circular buffer occupancy check in dmaengine xmit

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix 1-step timestamping over ipv4 or ipv6

Jack Morgenstein <jackm@nvidia.com>
    RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix `rx_bytes` accounting for stream sockets

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Send Link events one by one

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: aqc111: fix error handling of usbnet read calls

Radim Krčmář <rkrcmar@ventanamicro.com>
    RISC-V: KVM: lock the correct mp_state during reset

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_tunnel: fix geneve_opt dump

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: nft_fib: consistent l3mdev handling

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Avoid using sk_socket after free when sending

Kees Cook <kees@kernel.org>
    Bluetooth: btintel: Check dsbr size from EFI variable

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()

Li RongQing <lirongqing@baidu.com>
    vfio/type1: Fix error unwind in migration dirty bitmap allocation

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy

Florian Westphal <fw@strlen.de>
    netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds

Di Shen <di.shen@unisoc.com>
    bpf: Revert "bpf: remove unnecessary rcu_read_{lock,unlock}() in multi-uprobe attach logic"

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: fix available_antennas setting

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7996: fix RX buffer size of MCU event

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: fix invalid NSS setting when TX path differs from NSS

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: set EHT max ampdu length capability

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7996: fix beamformee SS field

Michael Lo <michael.lo@mediatek.com>
    wifi: mt76: mt7925: ensure all MCU commands wait for response

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: refine the sniffer commnad

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: prevent multiple scan commands

Henry Martin <bsdhenrymartin@gmail.com>
    wifi: mt76: mt7915: Fix null-ptr-deref in mt7915_mmio_wed_init()

Henry Martin <bsdhenrymartin@gmail.com>
    wifi: mt76: mt7996: Fix null-ptr-deref in mt7996_mmio_wed_init()

Feng Jiang <jiangfeng@kylinos.cn>
    wifi: mt76: scan: Fix 'mlink' dereferenced before IS_ERR_OR_NULL check

Pauli Virtanen <pav@iki.fi>
    Bluetooth: separate CIS_LINK and BIS_LINK link types

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix not using SID from adv report

Qasim Ijaz <qasdev00@gmail.com>
    wifi: mt76: mt7996: avoid null deref in mt7996_stop_phy()

Qasim Ijaz <qasdev00@gmail.com>
    wifi: mt76: mt7996: avoid NULL pointer dereference in mt7996_set_monitor()

Qasim Ijaz <qasdev00@gmail.com>
    wifi: mt76: mt7996: prevent uninit return in mt7996_mac_sta_add_links

Charles Han <hanchunchao@inspur.com>
    wifi: mt76: mt7996: Add NULL check in mt7996_thermal_init

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mt76: mt7925: Fix logical vs bitwise typo

Michal Koutný <mkoutny@suse.com>
    kernfs: Relax constraint in draining guard

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix return code of bnxt_re_configure_cc

Gautam R A <gautam-r.a@broadcom.com>
    RDMA/bnxt_re: Fix missing error handling for tx_queue

Gautam R A <gautam-r.a@broadcom.com>
    RDMA/bnxt_re: Fix incorrect display of inactivity_cp in debugfs output

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter() to return IOC pointer

ping.gao <ping.gao@samsung.com>
    scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort()

Hao Chang <ot_chhao.chang@mediatek.com>
    pinctrl: mediatek: Fix the invalid conditions

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: ath9k_htc: Abort software beacon handling if disabled

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix live migration function without VF device driver

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix the problem of uninstalling driver

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix cache write-back issue

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: add eq and aeq interruption restore

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: fix XQE dma address error

Rajat Soni <quic_rajson@quicinc.com>
    wifi: ath12k: fix memory leak in ath12k_service_ready_ext_event

Yingying Tang <quic_yintang@quicinc.com>
    wifi: ath12k: Reorder and relocate the release of resources in ath12k_core_deinit()

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix invalid RSSI values in station dump

Rolf Eike Beer <eb@emlix.com>
    iommu: remove duplicate selection of DMAR_TABLE

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw89: fix firmware scan delay unit for WiFi 6 chips

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: rtw88: fix the 'para' buffer size to avoid reading out of bounds

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: enlarge retry times of RX tag to 1000

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: configure manual DAC mode via PCI config API only

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Store backchain even for leaf progs

Vincent Knecht <vincent.knecht@mailoo.org>
    clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz

Rob Herring (Arm) <robh@kernel.org>
    dt-bindings: soc: fsl,qman-fqd: Fix reserved-memory.yaml reference

Tao Chen <chen.dylane@linux.dev>
    bpf: Fix WARN() in get_bpf_raw_tp_regs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: at91: Fix possible out-of-boundary access

Lijuan Gao <quic_lijuang@quicinc.com>
    pinctrl: qcom: correct the ngpios entry for QCS8300

Lijuan Gao <quic_lijuang@quicinc.com>
    pinctrl: qcom: correct the ngpios entry for QCS615

Anton Protopopov <a.s.protopopov@gmail.com>
    libbpf: Use proper errno value in nlattr

Jiayuan Chen <jiayuan.chen@linux.dev>
    ktls, sockmap: Fix missing uncharge operation

Dan Carpenter <dan.carpenter@linaro.org>
    of: unittest: Unlock on error in unittest_data_add()

Miaoqian Lin <linmq006@gmail.com>
    tracing: Fix error handling in event_trigger_parse()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Rename event_trigger_alloc() to trigger_data_alloc()

Luis Gerhorst <luis.gerhorst@fau.de>
    selftests/bpf: Fix caps for __xlated/jited_unpriv

Peilin Ye <yepeilin@google.com>
    selftests/bpf: Avoid passing out-of-range values to __retval()

Hans Zhang <18255117159@163.com>
    efi/libstub: Describe missing 'out' parameter in efi_load_initrd

Tomas Glozar <tglozar@redhat.com>
    rtla: Define _GNU_SOURCE in timerlat_bpf.c

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlfiwi: mvm: Fix the rate reporting

Richard Fitzgerald <rf@opensource.cirrus.com>
    clk: test: Forward-declare struct of_phandle_args in kunit/clk.h

Henry Martin <bsdhenrymartin@gmail.com>
    clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()

YiFei Zhu <zhuyifei@google.com>
    bpftool: Fix regression of "bpftool cgroup tree" EINVAL on older kernels

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gpucc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: camcc-sm6350: Add *_wait_val values for GDSCs

Steven Rostedt <rostedt@goodmis.org>
    tracing: Move histogram trigger variables from stack to per CPU structure

Qinxin Xia <xiaqinxin@huawei.com>
    iommu/arm-smmu-v3: Fix incorrect return in arm_smmu_attach_dev

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix error flow upon firmware failure for RQ destruction

Vlad Dumitrescu <vdumitrescu@nvidia.com>
    IB/cm: Drop lockdep assert and WARN when freeing old msg

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: prevent overflow in lookup table allocation

Zhongqiu Duan <dzq.aishenghu0@gmail.com>
    netfilter: nft_quota: match correctly when the quota just depleted

Huajian Yang <huajianyang@asrmicro.com>
    netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it

Lorenzo Bianconi <lorenzo@kernel.org>
    bpf: Allow XDP dev-bound programs to perform XDP_REDIRECT into maps

Anton Protopopov <a.s.protopopov@gmail.com>
    libbpf: Use proper errno value in linker

T.J. Mercier <tjmercier@google.com>
    selftests/bpf: Fix kmem_cache iterator draining

David Howells <dhowells@redhat.com>
    crypto/krb5: Fix change to use SG miter to use offset

Yi Zhang <yi.zhang@redhat.com>
    scsi: smartpqi: Fix smp_processor_id() call trace for preemptible kernels

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callbk

Chao Yu <chao@kernel.org>
    f2fs: zone: fix to calculate first_zoned_segno correctly

Chao Yu <chao@kernel.org>
    f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()

Chao Yu <chao@kernel.org>
    f2fs: clean up w/ fscrypt_is_bounce_page()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: assign random address if device address is same as bond

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Protect against overflow in iommu_pgsize()

Arnd Bergmann <arnd@arndb.de>
    iommu/io-pgtable-arm: dynamically allocate selftest device struct

Arnd Bergmann <arnd@arndb.de>
    iommu: ipmmu-vmsa: avoid Wformat-security warning

Jonathan Wiepert <jonathan.wiepert@gmail.com>
    Use thread-safe function pointer in libbpf_print

Tao Chen <chen.dylane@linux.dev>
    libbpf: Remove sample_period init in perf_buffer

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: re-add IWL_AMSDU_8K case

Feng Yang <yangfeng@kylinos.cn>
    libbpf: Fix event name too long error

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix "trying to register non-static key in rxe_qp_do_cleanup" bug

Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
    wifi: ath12k: fix node corruption in ar->arvifs list

Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
    wifi: ath12k: Prevent sending WMI commands to firmware during firmware crash

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath12k: fix wrong handling of CCMP256 and GCMP ciphers

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: replace the usage of rx desc with rx_info

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: add rx_info to capture required field from rx descriptor

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: change the status update in the monitor Rx

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: Replace band define G with GHZ where appropriate

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Avoid fetch Error bitmap and decap format from Rx TLV

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Add extra TLV tag parsing support in monitor Rx path

Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>
    wifi: ath12k: Fix the QoS control field offset to build QoS header

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Add MSDU length validation for TKIP MIC error

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: fix invalid access to memory

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Handle error cases during extended skb allocation

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtw88: do not ignore hardware read error during DPK

Zhen XIN <zhen.xin@nokia-sbell.com>
    wifi: rtw88: sdio: call rtw_sdio_indicate_tx_status unconditionally

Zhen XIN <zhen.xin@nokia-sbell.com>
    wifi: rtw88: sdio: map mgmt frames to queue TX_DESC_QSEL_MGMT

Cosmin Ratiu <cratiu@nvidia.com>
    bonding: Fix multiple long standing offload races

Cosmin Ratiu <cratiu@nvidia.com>
    bonding: Mark active offloaded xfrm_states

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm: Add explicit dev to .xdo_dev_state_{add,delete,free}

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm: Use xdo.dev instead of xdo.real_dev

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Avoid using xso.real_dev unnecessarily

Viktor Malik <vmalik@redhat.com>
    libbpf: Fix buffer overflow in bpf_object__init_prog

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix GCPS 64-bit member variables

Charles Han <hanchunchao@inspur.com>
    pinctrl: qcom: tlmm-test: Fix potential null dereference in tlmm kunit test

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Fix matcher action template attach

Toke Høiland-Jørgensen <toke@redhat.com>
    page_pool: Track DMA-mapped pages and unmap them when destroying the pool

Toke Høiland-Jørgensen <toke@redhat.com>
    page_pool: Move pp_magic check into helper functions

Paolo Abeni <pabeni@redhat.com>
    udp: properly deal with xfrm encap and ADDRFORM

Paolo Abeni <pabeni@redhat.com>
    udp_tunnel: use static call for GRO hooks when possible

Paolo Abeni <pabeni@redhat.com>
    udp_tunnel: create a fastpath GRO lookup.

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sbi->total_valid_block_count

yohan.joung <yohan.joung@sk.com>
    f2fs: prevent the current section from being selected as a victim during GC

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: clean up unnecessary indentation

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: ath12k: fix ATH12K_FLAG_REGISTERED flag handling

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: ath12k: fix SLUB BUG - Object already free in ath12k_reg_free()

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: ath12k: Fix buffer overflow in debugfs

Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
    wifi: ath12k: Fix WMI tag for EHT rate in peer assoc

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Resolve multicast packet drop by populating key_cipher in ath12k_install_key()

Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
    wifi: ath12k: fix cleanup path after mhi init

Christian Marangi <ansuelsmth@gmail.com>
    net: phy: mediatek: permit to compile test GE SOC PHY driver

Chao Yu <chao@kernel.org>
    f2fs: zone: fix to avoid inconsistence in between SIT and SSA

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix panic when calling skb_linearize

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: fix duplicated data transmission

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: fix ktls panic with sockmap

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    selftests/bpf: Fix bpf_nf selftest failure

Tao Chen <chen.dylane@linux.dev>
    bpf: Check link_create.flags parameter for multi_uprobe

Tao Chen <chen.dylane@linux.dev>
    bpf: Check link_create.flags parameter for multi_kprobe

Jacob Moroni <jmoroni@google.com>
    IB/cm: use rwlock for MAD agent lock

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix invalid memory access while forming 802.11 header

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix memory corruption during MLO multicast tx

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix memory leak during vdev_id mismatch

Carlos Llamas <cmllamas@google.com>
    libbpf: Fix implicit memfd_create() for bionic

Stone Zhang <quic_stonez@quicinc.com>
    wifi: ath11k: fix node corruption in ar->arvifs list

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: fix NULL access in assign channel context handler

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Use a decimal fifo to avoid u64 by u64 divide

Miguel Ojeda <ojeda@kernel.org>
    drm/panic: clean Clippy warning

Aradhya Bhatia <aradhya.bhatia@intel.com>
    drm/xe/guc: Make creation of SLPC debugfs files conditional

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Don't expose GuC privileged debugfs files if VF

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Refactor GuC debugfs initialization

Roger Pau Monne <roger.pau@citrix.com>
    xen/x86: fix initial memory balloon target

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reduce the number of rdma_rw contexts per-QP

Detlev Casanova <detlev.casanova@collabora.com>
    media: verisilicon: Free post processor buffers on error

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_drm_drv: Unbind secondary mmsys components on err

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: Fix kobject put for component sub-drivers

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_drm_drv: Fix kobject put for mtk_mutex device ptr

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Use the correct connector while computing the link BPP limit on MST

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    drm/msm/dp: Prepare for link training per-segment for LTTPRs

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    drm/msm/dp: Account for LTTPRs capabilities

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    drm/msm/dp: Fix support of LTTPR initialization

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/a6xx: Disable rgb565_predicator on Adreno 7c3

Terry Tritton <terry.tritton@linaro.org>
    selftests/seccomp: fix negative_ENOSYS tracer tests on arm32

Anand Moon <linux.amoon@gmail.com>
    perf/amlogic: Replace smp_processor_id() with raw_smp_processor_id() in meson_ddr_pmu_create()

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: synopsys: hdmirx: Count dropped frames

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: synopsys: hdmirx: Renamed frame_idx to sequence

Kees Cook <kees@kernel.org>
    scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops

Gustavo A. R. Silva <gustavoars@kernel.org>
    overflow: Fix direct struct member initialization in _DEFINE_FLEX()

Mark Rutland <mark.rutland@arm.com>
    kselftest/arm64: fp-ptrace: Fix expected FPMR value when PSTATE.SM is changed

Huang Yiwei <quic_hyiwei@quicinc.com>
    firmware: SDEI: Allow sdei initialization without ACPI_APEI_GHES

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Don't check for NULL divisor in fixpt code

Biju Das <biju.das.jz@bp.renesas.com>
    drm/tegra: rgb: Fix the unbound reference count

Kees Cook <kees@kernel.org>
    drm/vkms: Adjust vkms_state->active_planes allocation type

Biju Das <biju.das.jz@bp.renesas.com>
    drm: rcar-du: Fix memory leak in rcar_du_vsps_init()

Dmitry Baryshkov <lumag@kernel.org>
    drm/msm/dpu: remove DSC feature bit for PINGPONG on MSM8953

Dmitry Baryshkov <lumag@kernel.org>
    drm/msm/dpu: remove DSC feature bit for PINGPONG on MSM8917

Dmitry Baryshkov <lumag@kernel.org>
    drm/msm/dpu: remove DSC feature bit for PINGPONG on MSM8937

Dmitry Baryshkov <lumag@kernel.org>
    drm/msm/dpu: enable SmartDMA on SC8180X

Dmitry Baryshkov <lumag@kernel.org>
    drm/msm/dpu: enable SmartDMA on SM8150

Neill Kapron <nkapron@google.com>
    selftests/seccomp: fix syscall_restart test for arm compat

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Avoid warning when sve_to_fpsimd() is unused

Kornel Dulęba <korneld@google.com>
    arm64: Support ARM64_VA_BITS=52 when setting ARCH_MMAP_RND_BITS_MAX

Miaoqian Lin <linmq006@gmail.com>
    firmware: psci: Fix refcount leak in psci_dt_init

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix macintosh_config for Mac II

Kees Cook <kees@kernel.org>
    watchdog: exar: Shorten identity name to fit correctly

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit/usercopy: Disable u64 test on 32-bit SPARC

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Add missing direct_IO in ntfs_aops_cmpr

Andrey Vatoropin <a.vatoropin@crpt.ru>
    fs/ntfs3: handle hdr_first_de() return value

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/v3d: client ranges from axi_ids are different with V3D 7.1

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/v3d: fix client obtained from axi_ids on V3D 4.1

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Associate a V3D tech revision to all supported devices

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()

Casey Connolly <casey.connolly@linaro.org>
    drm/panel: samsung-sofef00: Drop s6e3fc2x01 support

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Refine Cleaner Shader MEC firmware version for GFX10.1.x GPUs

Hongbo Yao <andy.xu@hj-micro.com>
    perf: arm-ni: Fix missing platform_set_drvdata()

Hongbo Yao <andy.xu@hj-micro.com>
    perf: arm-ni: Unregister PMUs on probe failure

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix the panthor_gpu_coherency_init() error path

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix incorrect size of ERT_START_NPU commands

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Update panthor_mmu::irq::mask when needed

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Call panthor_gpu_coherency_init() after PM resume()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix GPU_COHERENCY_ACE[_LITE] definitions

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Fix merging of FPSIMD state during signal return

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Reset FPMR upon exec()

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Avoid clobbering kernel FPSIMD state with SMSTOP

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Don't corrupt FPMR when streaming mode changes

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Discard stale CPU state when handling SME traps

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Avoid RES0 bits in the SME trap handler

Jonas Karlman <jonas@kwiboo.se>
    media: rkvdec: Fix frame size enumeration

Charles Han <hanchunchao@inspur.com>
    drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table

Maxime Ripard <mripard@kernel.org>
    drm/vc4: tests: Retry pv-muxing tests when EDEADLK

Maxime Ripard <mripard@kernel.org>
    drm/vc4: tests: Stop allocating the state in test init

Maxime Ripard <mripard@kernel.org>
    drm/vc4: tests: Use return instead of assert

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/d3cold: Set power state to D3Cold during s2idle/s3

Stefan Wahren <wahrenst@gmx.net>
    drm/vc4: hdmi: Call HDMI hotplug helper on disconnect

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix dumb buffer leak

Vignesh Raman <vignesh.raman@collabora.com>
    drm/ci: fix merge request rules

Arnd Bergmann <arnd@arndb.de>
    drm: xlnx: zynqmp_dpsub: fix Kconfig dependencies for ASoC

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    drm/vmwgfx: Add error path for xa_store in vmw_bo_add_detached_resource

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add seqno waiter for sync_files

Alexandre Ghiti <alexghiti@rivosinc.com>
    ACPI: platform_profile: Avoid initializing on non-ACPI platforms

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: core: fix up bus match const issues.

David Thompson <davthompson@nvidia.com>
    EDAC/bluefield: Don't use bluefield_edac_readl() result on error

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Constrain channels according to TDM mask

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: sh-msiof: Fix maximum DMA transfer size

Armin Wolf <W_Armin@gmx.de>
    ACPI: thermal: Execute _SCP before reading trip points

Armin Wolf <W_Armin@gmx.de>
    ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    thermal/drivers/mediatek/lvts: Fix debugfs unregister on failure

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: validate user/chip specific ECC properties

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: use kmalloc() for OOB buffer allocation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Print PM debug messages during hibernation

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()

Bence Csókás <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Fix unbalanced pm_runtime by using devm_ API

Bence Csókás <csokas.bence@prolan.hu>
    PM: runtime: Add new devm functions

Mingcong Bai <jeffbai@aosc.io>
    ACPI: resource: fix a typo for MECHREVO in irq1_edge_low_force_override[]

Zijun Hu <quic_zijuhu@quicinc.com>
    PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: add missing acp descriptor field

Thorsten Blum <thorsten.blum@linux.dev>
    ASoC: Intel: avs: Fix kcalloc() sizes

Kees Cook <kees@kernel.org>
    ASoC: SOF: ipc4-pcm: Adjust pipeline_list->pipelines allocation type

Benson Leung <bleung@chromium.org>
    platform/chrome: cros_ec_typec: Set Pin Assignment E in DP PORT VDO

Dan Carpenter <dan.carpenter@linaro.org>
    power: supply: max77705: Fix workqueue error handling in probe

Yaxiong Tian <tianyaxiong@kylinos.cn>
    PM: EM: Fix potential division-by-zero error in em_compute_costs()

Alexander Shiyan <eagle.alexander923@gmail.com>
    power: reset: at91-reset: Optimize at91_reset()

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: modify chip select (CS) deactivation

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: remove redundant error handling code

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Fix X1_X2_X4 encoding and support x4 transfers

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: fix integer overflow in i{64,}toa_r() and

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: properly align dirent buffer

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/{skx_common,i10nm}: Fix the loss of saved RRL for HBM pseudo channel 0

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Fix general protection fault

Julien Massot <julien.massot@collabora.com>
    ASoC: mediatek: mt8195: Set ETDM1/2 IN/OUT to COMP_DUMMY()

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Enable main IRQs

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Reinit cache on part reset

Jemmy Wong <jemmywong512@gmail.com>
    tools/nolibc/types.h: fix mismatched parenthesis in minor()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: exserial: don't forget to handle FFixedHW opregions for reading

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Redo lookup on EEXIST

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't start unnecessary transactions during log flush

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move gfs2_trans_add_databufs

Tzung-Bi Shih <tzungbi@kernel.org>
    kunit: Fix wrong parameter to kunit_deactivate_static_stub()

Xuewen Yan <xuewen.yan@unisoc.com>
    sched/fair: Fixup wake_up_sync() vs DELAYED_DEQUEUE

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - move fallback ahash_request to the end of the struct

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Only add ecb if it is not already there

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lrw - Only add ecb if it is not already there

Yongliang Gao <leonylgao@tencent.com>
    rcu/cpu_stall_cputime: fix the hardirq count for x86 architecture

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong start offset for delalloc space release during mmap write

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid data space release when truncating block in NOCOW mode

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: fix a wrong error type when metadata bytenr mismatches

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: update device stats when an error is detected

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: Fix kmemleak in TCE table userspace view

Sheng Yong <shengyong1@xiaomi.com>
    erofs: avoid using multiple devices with different type

Hongbo Li <lihongbo22@huawei.com>
    erofs: fix file handle encoding for 64-bit NIDs

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Avoid empty transfer descriptor

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Handle zero-length skcipher requests

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    kselftest: cpufreq: Get rid of double suspend in rtcwake case

Yu Kuai <yukuai3@huawei.com>
    brd: fix discard end sector

Yu Kuai <yukuai3@huawei.com>
    brd: fix aligned_sector from brd_do_discard()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    x86/insn: Fix opcode map (!REX2) superscript tags

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Sanitize CPUID(0x80000000) output

Zizhi Wo <wozizhi@huawei.com>
    blk-throttle: Fix wrong tg->[bytes/io]_disp update in __tg_update_carryover()

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - undo runtime PM changes during driver removal

Nam Cao <namcao@linutronix.de>
    selftests: coredump: Raise timeout to 2 minutes

Nam Cao <namcao@linutronix.de>
    selftests: coredump: Fix test failure for slow machines

Nam Cao <namcao@linutronix.de>
    selftests: coredump: Properly initialize pointer

Annie Li <jiayanli@google.com>
    x86/microcode/AMD: Do not return error when microcode update is not necessary

John Stultz <jstultz@google.com>
    sched/core: Tweak wait_task_inactive() to force dequeue sched_delayed tasks

Eddie James <eajames@linux.ibm.com>
    powerpc/crash: Fix non-smp kexec preparation

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    powerpc: do not build ppc_save_regs.o always

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce-cipher - fix error handling in sun8i_ce_cipher_prepare()

Qing Wang <wangqing7171@gmail.com>
    perf/core: Fix broken throttling when max_samples_per_tick=1

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: deallocate inodes in gfs2_create_inode

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move GIF_ALLOC_FAILED check out of gfs2_ea_dealloc

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move gfs2_dinode_dealloc

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_create_inode error handling fix

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: replace sd_aspace with sd_inode

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Prevent UMC counters from saturating

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Remove unused 'struct amd_uncore_ctx::node' member

David Gow <davidgow@google.com>
    kunit: qemu_configs: Disable faulting tests on 32-bit SPARC

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: qemu_configs: sparc: Explicitly enable CONFIG_SPARC32=y

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: zynqmp-sha - Add locking

Lukas Wunner <lukas@wunner.de>
    crypto: ecdsa - Fix NIST P521 key size reported by KEYCTL_PKEY_QUERY

Lukas Wunner <lukas@wunner.de>
    crypto: ecdsa - Fix enc/dec size reported by KEYCTL_PKEY_QUERY

Peter Zijlstra <peterz@infradead.org>
    sched: Fix trace_sched_switch(.prev_state)

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce-hash - fix error handling in sun8i_ce_hash_run()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: iaa - Do not clobber req->base.data

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/idle: Remove MFENCEs for X86_BUG_CLFLUSH_MONITOR in mwait_idle_with_hints() and prefer_mwait_c1_over_halt()

Ahmed S. Darwish <darwi@linutronix.de>
    tools/x86/kcpuid: Fix error handling


-------------

Diffstat:

 .../regulator/mediatek,mt6357-regulator.yaml       |  12 +-
 .../devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml  |   4 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 Documentation/gpu/xe/index.rst                     |   1 +
 Documentation/gpu/xe/xe_gt_freq.rst                |  14 +
 Documentation/misc-devices/lis3lv02d.rst           |   6 +-
 Documentation/netlink/specs/rt_link.yaml           |  68 +++-
 Documentation/networking/xfrm_device.rst           |  10 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/at91sam9263ek.dts      |   2 +-
 arch/arm/boot/dts/microchip/tny_a9263.dts          |   2 +-
 arch/arm/boot/dts/microchip/usb_a9263.dts          |   4 +-
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi           |  82 +++--
 arch/arm/mach-aspeed/Kconfig                       |   1 -
 arch/arm64/Kconfig                                 |   6 +-
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi     |   3 +
 .../arm64/boot/dts/freescale/imx8mm-beacon-kit.dts |   1 +
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   1 +
 .../arm64/boot/dts/freescale/imx8mn-beacon-kit.dts |   1 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   1 +
 .../boot/dts/freescale/imx8mp-beacon-som.dtsi      |   1 +
 arch/arm64/boot/dts/mediatek/mt6357.dtsi           |  10 -
 arch/arm64/boot/dts/mediatek/mt6359.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |  10 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   4 +
 arch/arm64/boot/dts/mediatek/mt8188.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |  50 +--
 .../boot/dts/mediatek/mt8390-genio-common.dtsi     |  12 +-
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |  12 -
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |  12 -
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   1 +
 arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi   |  11 +-
 arch/arm64/boot/dts/qcom/ipq9574.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  19 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/qcs615.dtsi               |  17 +-
 arch/arm64/boot/dts/qcom/qcs8300.dtsi              |  12 -
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              |  11 -
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |   3 -
 .../arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts |   2 +
 .../arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts |   3 +
 .../boot/dts/qcom/sdm845-samsung-starqltechn.dts   |  16 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               | 391 ++++++++++++++-------
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |  82 +++--
 arch/arm64/boot/dts/qcom/sm8750.dtsi               |  26 +-
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts       |  44 +++
 .../boot/dts/qcom/x1e80100-microsoft-romulus.dtsi  |   2 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   2 +
 .../dts/renesas/white-hawk-ard-audio-da7212.dtso   |   2 +-
 arch/arm64/boot/dts/renesas/white-hawk-single.dtsi |   8 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   8 -
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |  12 -
 arch/arm64/boot/dts/rockchip/rk3528.dtsi           |   3 +-
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts    |   1 +
 .../arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi |   5 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |  15 +-
 .../boot/dts/ti/k3-j721e-common-proc-board.dts     |   1 +
 arch/arm64/configs/defconfig                       |   3 +
 arch/arm64/include/asm/esr.h                       |  12 +-
 arch/arm64/kernel/fpsimd.c                         |  21 +-
 arch/arm64/xen/hypercall.S                         |  21 +-
 arch/m68k/mac/config.c                             |   2 +-
 .../boot/dts/loongson/loongson64c_4core_ls7a.dts   |   1 +
 arch/powerpc/kernel/Makefile                       |   2 -
 arch/powerpc/kexec/crash.c                         |   5 +-
 arch/powerpc/platforms/book3s/vas-api.c            |   9 +
 arch/powerpc/platforms/powernv/memtrace.c          |   8 +-
 arch/powerpc/platforms/pseries/iommu.c             |   2 +-
 arch/riscv/kernel/traps_misaligned.c               |   4 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   4 +-
 arch/s390/kernel/uv.c                              |  85 ++++-
 arch/s390/net/bpf_jit_comp.c                       |  12 +-
 arch/um/os-Linux/sigio.c                           |   3 +-
 arch/x86/events/amd/uncore.c                       |  36 +-
 arch/x86/hyperv/hv_init.c                          |  33 ++
 arch/x86/hyperv/hv_vtl.c                           |  44 +--
 arch/x86/hyperv/ivm.c                              |  22 +-
 arch/x86/include/asm/mshyperv.h                    |   6 +-
 arch/x86/include/asm/mwait.h                       |   9 +-
 arch/x86/include/asm/sighandling.h                 |  22 ++
 arch/x86/kernel/cpu/common.c                       |  17 +-
 arch/x86/kernel/cpu/microcode/core.c               |   2 +
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/ioport.c                           |  13 +-
 arch/x86/kernel/irq.c                              |   2 +-
 arch/x86/kernel/process.c                          |  15 +-
 arch/x86/kernel/signal_32.c                        |   4 +
 arch/x86/kernel/signal_64.c                        |   4 +
 arch/x86/lib/x86-opcode-map.txt                    |  50 +--
 arch/x86/mm/init_32.c                              |   3 -
 arch/x86/mm/init_64.c                              |   3 -
 block/blk-integrity.c                              |   7 +-
 block/blk-throttle.c                               |  22 +-
 block/blk-zoned.c                                  |   7 +-
 block/elevator.c                                   |   3 +-
 crypto/api.c                                       |  13 +-
 crypto/asymmetric_keys/public_key.c                |  13 +-
 crypto/ecdsa-p1363.c                               |   6 +-
 crypto/ecdsa-x962.c                                |   5 +-
 crypto/ecdsa.c                                     |   2 +-
 crypto/ecrdsa.c                                    |   2 +-
 crypto/krb5/rfc3961_simplified.c                   |   1 +
 crypto/lrw.c                                       |   4 +-
 crypto/rsassa-pkcs1.c                              |   2 +-
 crypto/sig.c                                       |   9 +-
 crypto/xts.c                                       |   4 +-
 drivers/accel/amdxdna/aie2_message.c               |   6 +-
 drivers/accel/amdxdna/aie2_msg_priv.h              |  10 +-
 drivers/accel/amdxdna/aie2_psp.c                   |   4 +-
 drivers/accel/ivpu/ivpu_job.c                      |   8 +-
 drivers/acpi/acpica/exserial.c                     |   6 +
 drivers/acpi/apei/Kconfig                          |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/acpi/osi.c                                 |   1 -
 drivers/acpi/platform_profile.c                    |   3 +
 drivers/acpi/resource.c                            |   2 +-
 drivers/acpi/thermal.c                             |  10 +-
 drivers/base/power/main.c                          |   3 +-
 drivers/base/power/runtime.c                       |  44 +++
 drivers/block/brd.c                                |  11 +-
 drivers/block/loop.c                               |   8 +-
 drivers/bluetooth/btintel.c                        |  10 +-
 drivers/bluetooth/btintel_pcie.c                   |  31 +-
 drivers/bluetooth/btintel_pcie.h                   |  10 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  12 +-
 drivers/char/Kconfig                               |   2 +-
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +
 drivers/clk/qcom/camcc-sm6350.c                    |  18 +
 drivers/clk/qcom/dispcc-sm6350.c                   |   3 +
 drivers/clk/qcom/gcc-msm8939.c                     |   4 +-
 drivers/clk/qcom/gcc-sm6350.c                      |   6 +
 drivers/clk/qcom/gpucc-sm6350.c                    |   6 +
 drivers/counter/interrupt-cnt.c                    |   9 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   7 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  17 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |  34 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |   6 +-
 drivers/crypto/marvell/cesa/cipher.c               |   3 +
 drivers/crypto/marvell/cesa/hash.c                 |   2 +-
 drivers/crypto/xilinx/zynqmp-sha.c                 |  18 +-
 drivers/dma/ti/k3-udma.c                           |   3 +-
 drivers/edac/bluefield_edac.c                      |  20 +-
 drivers/edac/i10nm_base.c                          |  35 +-
 drivers/edac/skx_common.c                          |   1 +
 drivers/edac/skx_common.h                          |  11 +-
 drivers/firmware/Kconfig                           |   1 -
 drivers/firmware/arm_sdei.c                        |  11 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |   1 +
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/firmware/samsung/exynos-acpm-pmic.c        |  16 +-
 drivers/firmware/samsung/exynos-acpm.c             |  11 +-
 drivers/fpga/tests/fpga-mgr-test.c                 |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 .../gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h  |   6 +-
 .../drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm |  13 +-
 drivers/gpu/drm/amd/display/dc/basics/fixpt31_32.c |   5 -
 .../gpu/drm/amd/display/dc/sspl/spl_fixpt31_32.c   |   4 -
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   8 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  58 +--
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/ci/gitlab-ci.yml                   |  19 +-
 drivers/gpu/drm/display/drm_hdmi_audio_helper.c    |   3 +-
 drivers/gpu/drm/drm_panic_qr.rs                    |  71 ++--
 drivers/gpu/drm/i915/display/intel_dp.c            |   7 +-
 drivers/gpu/drm/i915/display/intel_dp.h            |   1 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   5 +-
 drivers/gpu/drm/i915/display/intel_psr_regs.h      |   4 +-
 drivers/gpu/drm/i915/display/intel_snps_hdmi_pll.c |  16 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  19 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  31 +-
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |   2 +-
 drivers/gpu/drm/meson/meson_vclk.c                 |  55 +--
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   1 -
 .../drm/msm/disp/dpu1/catalog/dpu_1_14_msm8937.h   |   2 -
 .../drm/msm/disp/dpu1/catalog/dpu_1_15_msm8917.h   |   1 -
 .../drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h   |   2 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |  16 +-
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |  16 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |  27 +-
 drivers/gpu/drm/msm/dp/dp_link.h                   |   4 +
 drivers/gpu/drm/msm/dp/dp_panel.c                  |  12 +-
 drivers/gpu/drm/panel/panel-samsung-sofef00.c      |  34 +-
 drivers/gpu/drm/panel/panel-simple.c               |   5 +-
 drivers/gpu/drm/panthor/panthor_device.c           |   8 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |   1 +
 drivers/gpu/drm/panthor/panthor_regs.h             |   4 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c      |  10 +-
 drivers/gpu/drm/tegra/rgb.c                        |  14 +-
 drivers/gpu/drm/v3d/v3d_debugfs.c                  | 116 +++---
 drivers/gpu/drm/v3d/v3d_drv.c                      |  22 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |  11 +-
 drivers/gpu/drm/v3d/v3d_gem.c                      |  10 +-
 drivers/gpu/drm/v3d/v3d_irq.c                      |  64 +++-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |   4 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   6 +-
 drivers/gpu/drm/vc4/tests/vc4_mock_output.c        |  36 +-
 drivers/gpu/drm/vc4/tests/vc4_test_pv_muxing.c     | 154 +++++++-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  16 +-
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  26 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  34 +-
 drivers/gpu/drm/xe/Kconfig                         |   3 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  48 ++-
 drivers/gpu/drm/xe/xe_gt_freq.c                    |   5 +
 drivers/gpu/drm/xe/xe_guc_debugfs.c                | 167 +++++----
 drivers/gpu/drm/xe/xe_lrc.c                        |  24 +-
 drivers/gpu/drm/xe/xe_pci.c                        |   1 +
 drivers/gpu/drm/xe/xe_pxp.c                        |   8 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  19 +-
 drivers/gpu/drm/xe/xe_vm.h                         |  69 ++++
 drivers/gpu/drm/xe/xe_vm_types.h                   |   8 +
 drivers/gpu/drm/xlnx/Kconfig                       |   1 +
 drivers/hid/Kconfig                                |   2 +
 drivers/hid/hid-hyperv.c                           |   4 +-
 .../intel-thc-hid/intel-quicki2c/pci-quicki2c.c    |   7 +-
 drivers/hid/usbhid/hid-core.c                      |  25 +-
 drivers/hwmon/asus-ec-sensors.c                    |   4 +
 drivers/hwtracing/coresight/coresight-catu.c       |  27 +-
 drivers/hwtracing/coresight/coresight-catu.h       |   1 +
 drivers/hwtracing/coresight/coresight-config.h     |   2 +-
 drivers/hwtracing/coresight/coresight-core.c       |  21 +-
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |   3 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   5 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   4 +-
 drivers/hwtracing/coresight/coresight-funnel.c     |   3 +-
 drivers/hwtracing/coresight/coresight-replicator.c |   3 +-
 drivers/hwtracing/coresight/coresight-stm.c        |   2 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |  51 ++-
 drivers/hwtracing/coresight/coresight-tmc-core.c   |   2 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  11 +-
 drivers/hwtracing/coresight/coresight-tpiu.c       |   2 +-
 drivers/iio/adc/ad4851.c                           |  14 +-
 drivers/iio/adc/ad7124.c                           |   4 +-
 drivers/iio/adc/mcp3911.c                          |  39 +-
 drivers/iio/adc/pac1934.c                          |   2 +-
 drivers/iio/dac/adi-axi-dac.c                      |   8 +
 drivers/iio/filter/admv8818.c                      | 230 +++++++++---
 drivers/infiniband/core/cm.c                       |  19 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/hw/bnxt_re/debugfs.c            |  20 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   1 -
 drivers/infiniband/hw/mlx5/qpc.c                   |  30 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   7 +-
 drivers/iommu/Kconfig                              |   1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/iommu/io-pgtable-arm.c                     |  13 +-
 drivers/iommu/iommu.c                              |   4 +-
 drivers/iommu/ipmmu-vmsa.c                         |   3 +-
 drivers/mailbox/Kconfig                            |   4 +-
 drivers/mailbox/imx-mailbox.c                      |  21 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  51 ++-
 drivers/md/dm-core.h                               |   1 +
 drivers/md/dm-flakey.c                             |  70 ++--
 drivers/md/dm-table.c                              |  67 +++-
 drivers/md/dm-zone.c                               |  86 +++--
 drivers/md/dm.c                                    |  36 +-
 drivers/md/dm.h                                    |   6 +
 drivers/md/raid1-10.c                              |  10 +
 drivers/md/raid1.c                                 |  19 +-
 drivers/md/raid10.c                                |  11 +-
 .../media/platform/synopsys/hdmirx/snps_hdmirx.c   |  14 +-
 .../media/platform/verisilicon/hantro_postproc.c   |   4 +-
 drivers/mfd/exynos-lpass.c                         |  31 +-
 drivers/mfd/stmpe-spi.c                            |   2 +-
 drivers/misc/lis3lv02d/Kconfig                     |   4 +-
 drivers/misc/mei/vsc-tp.c                          |   4 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |  11 +-
 drivers/mtd/nand/ecc-mxic.c                        |   2 +-
 drivers/net/bonding/bond_main.c                    | 144 ++++----
 drivers/net/dsa/b53/b53_common.c                   |  92 ++---
 drivers/net/dsa/b53/b53_priv.h                     |   1 +
 drivers/net/dsa/b53/b53_regs.h                     |   7 +
 drivers/net/dsa/bcm_sf2.c                          |   1 +
 drivers/net/ethernet/airoha/airoha_eth.c           |  23 +-
 drivers/net/ethernet/airoha/airoha_eth.h           |  10 +
 drivers/net/ethernet/airoha/airoha_ppe.c           |  32 +-
 drivers/net/ethernet/airoha/airoha_regs.h          |  10 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  20 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c    |  18 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |   3 +
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 -
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  29 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 302 ++++++----------
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  17 +
 drivers/net/ethernet/intel/ice/ice_main.c          |  47 ++-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   1 +
 drivers/net/ethernet/intel/ice/ice_sched.c         | 181 ++++++++--
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  18 +-
 .../net/ethernet/intel/idpf/idpf_singleq_txrx.c    |   9 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  45 +--
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   8 -
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |  41 ++-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |  21 +-
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_rep.c    |   2 +
 .../ethernet/marvell/octeontx2/nic/cn10k_ipsec.c   |  18 +-
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/qos_sq.c    |  22 ++
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  28 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 .../mellanox/mlx5/core/steering/hws/action.c       |  14 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c |  55 ++-
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.h |   9 +-
 .../mellanox/mlx5/core/steering/hws/definer.c      |   3 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   3 +
 .../mellanox/mlx5/core/steering/hws/matcher.c      |  48 ++-
 .../mellanox/mlx5/core/steering/hws/matcher.h      |   4 +
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h      |   6 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  15 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   7 +
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   6 +
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |  49 ++-
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |  21 ++
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c   |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/ethernet/ti/icssg/icssg_stats.c        |   8 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   6 +-
 drivers/net/macsec.c                               |  40 ++-
 drivers/net/mctp/mctp-usb.c                        |   2 +
 drivers/net/netconsole.c                           |   3 +-
 drivers/net/netdevsim/ipsec.c                      |  15 +-
 drivers/net/netdevsim/netdev.c                     |   3 +-
 drivers/net/phy/mdio_bus.c                         |  12 +
 drivers/net/phy/mediatek/Kconfig                   |   3 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  20 +-
 drivers/net/phy/phy_caps.c                         |  18 +-
 drivers/net/phy/phy_device.c                       |   4 +-
 drivers/net/usb/aqc111.c                           |  10 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  26 ++
 drivers/net/wireguard/device.c                     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |  37 +-
 drivers/net/wireless/ath/ath11k/core.h             |   4 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          | 148 +-------
 drivers/net/wireless/ath/ath11k/debugfs.h          |  10 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  92 ++++-
 drivers/net/wireless/ath/ath11k/mac.h              |   4 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  47 ++-
 drivers/net/wireless/ath/ath12k/core.c             |  28 +-
 drivers/net/wireless/ath/ath12k/core.h             |  19 +-
 drivers/net/wireless/ath/ath12k/debugfs.c          |   4 +-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |   3 +
 drivers/net/wireless/ath/ath12k/dp.h               |   2 +
 drivers/net/wireless/ath/ath12k/dp_mon.c           | 351 +++++++++++++++---
 drivers/net/wireless/ath/ath12k/dp_mon.h           |   4 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            | 234 ++++++------
 drivers/net/wireless/ath/ath12k/dp_rx.h            |  29 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |  23 +-
 drivers/net/wireless/ath/ath12k/hal.c              | 103 +++---
 drivers/net/wireless/ath/ath12k/hal.h              |  64 ++--
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   3 +-
 drivers/net/wireless/ath/ath12k/hal_rx.h           |  15 +-
 drivers/net/wireless/ath/ath12k/hw.c               |  35 +-
 drivers/net/wireless/ath/ath12k/hw.h               |  12 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  86 +++--
 drivers/net/wireless/ath/ath12k/mhi.c              |   7 +-
 drivers/net/wireless/ath/ath12k/pci.c              |  17 +-
 drivers/net/wireless/ath/ath12k/pci.h              |   4 +-
 drivers/net/wireless/ath/ath12k/reg.c              |   4 +
 drivers/net/wireless/ath/ath12k/wmi.c              |  39 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |  16 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.c       |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 drivers/net/wireless/mediatek/mt76/channel.c       |   4 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   1 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  14 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  23 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   4 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |  10 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |  36 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   9 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c                |  11 +-
 drivers/nvme/host/constants.c                      |   2 +-
 drivers/nvme/host/core.c                           |   1 -
 drivers/nvme/host/ioctl.c                          |   2 +-
 drivers/nvme/host/pr.c                             |   2 -
 drivers/nvme/target/core.c                         |   9 +-
 drivers/nvme/target/fcloop.c                       |  31 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   9 +-
 drivers/nvmem/zynqmp_nvmem.c                       |   1 +
 drivers/of/unittest.c                              |  10 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |  11 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  47 +++
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |   1 +
 drivers/pci/controller/pcie-apple.c                |   4 +-
 drivers/pci/controller/pcie-rockchip.h             |   7 +-
 drivers/pci/endpoint/pci-epf-core.c                |  22 +-
 drivers/pci/hotplug/pci_hotplug_core.c             |  69 ++++
 drivers/pci/hotplug/pciehp.h                       |   1 +
 drivers/pci/hotplug/pciehp_core.c                  |  29 --
 drivers/pci/hotplug/pciehp_hpc.c                   |  78 ++--
 drivers/pci/pci-acpi.c                             |  23 +-
 drivers/pci/pci-driver.c                           |   6 -
 drivers/pci/pci.c                                  |  15 +-
 drivers/pci/pci.h                                  |   4 +
 drivers/pci/pcie/dpc.c                             |  66 ++--
 drivers/pci/pwrctrl/core.c                         |   2 +
 drivers/perf/amlogic/meson_ddr_pmu_core.c          |   2 +-
 drivers/perf/arm-ni.c                              |  40 ++-
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   6 +-
 drivers/phy/qualcomm/phy-qcom-qusb2.c              |  27 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |  13 +-
 drivers/pinctrl/mediatek/mtk-eint.c                |   4 +-
 drivers/pinctrl/mediatek/mtk-eint.h                |   2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   7 +-
 drivers/pinctrl/pinctrl-at91.c                     |   6 +-
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |   9 +
 drivers/pinctrl/qcom/pinctrl-qcs615.c              |   2 +-
 drivers/pinctrl/qcom/pinctrl-qcs8300.c             |   2 +-
 drivers/pinctrl/qcom/tlmm-test.c                   |   1 +
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c     |  52 +--
 drivers/pinctrl/samsung/pinctrl-exynos.c           | 266 ++++++++------
 drivers/pinctrl/samsung/pinctrl-exynos.h           |   8 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  21 +-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   8 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c           |   8 +-
 drivers/platform/chrome/cros_ec_typec.c            |   6 +-
 drivers/power/reset/at91-reset.c                   |   5 +-
 drivers/power/supply/max77705_charger.c            |  20 +-
 drivers/ptp/ptp_private.h                          |  12 +-
 drivers/regulator/max20086-regulator.c             |   6 +-
 drivers/remoteproc/qcom_wcnss_iris.c               |   2 +
 drivers/remoteproc/ti_k3_dsp_remoteproc.c          |   8 -
 drivers/remoteproc/ti_k3_r5_remoteproc.c           | 118 ++++---
 drivers/rpmsg/qcom_smd.c                           |   2 +-
 drivers/rtc/rtc-loongson.c                         |   8 +
 drivers/rtc/rtc-sh.c                               |  12 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  29 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  32 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   3 +-
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  11 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  17 +-
 drivers/soc/qcom/smp2p.c                           |   2 +-
 drivers/soundwire/generic_bandwidth_allocation.c   |   7 +
 drivers/spi/atmel-quadspi.c                        |  17 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   2 +-
 drivers/spi/spi-omap2-mcspi.c                      |  30 +-
 drivers/spi/spi-qpic-snand.c                       |  44 ++-
 drivers/spi/spi-sh-msiof.c                         |  13 +-
 drivers/spi/spi-tegra210-quad.c                    |  24 +-
 drivers/staging/gpib/ines/ines_gpib.c              |   2 +-
 drivers/staging/gpib/uapi/gpib_user.h              |   2 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  10 +-
 drivers/thermal/mediatek/lvts_thermal.c            |  16 +-
 drivers/thunderbolt/usb4.c                         |   4 +-
 drivers/tty/serial/8250/8250_omap.c                |  25 +-
 drivers/tty/serial/milbeaut_usio.c                 |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 -
 drivers/ufs/core/ufs-mcq.c                         |   6 -
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/ufs/host/ufs-qcom.c                        |  92 ++++-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  21 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   4 +
 drivers/usb/class/usbtmc.c                         |  17 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/usb-acpi.c                        |   2 +
 drivers/usb/gadget/function/f_hid.c                |  12 +-
 drivers/usb/gadget/udc/core.c                      |   2 +-
 drivers/usb/misc/onboard_usb_dev.c                 | 111 +++++-
 drivers/usb/renesas_usbhs/common.c                 |  50 ++-
 drivers/usb/serial/bus.c                           |   2 +-
 drivers/usb/typec/bus.c                            |   2 +-
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   3 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  91 +++--
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  94 +++--
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |  14 +-
 drivers/vfio/vfio_iommu_type1.c                    |   2 +-
 drivers/video/backlight/qcom-wled.c                |   6 +-
 drivers/video/fbdev/core/fbcvt.c                   |   2 +-
 drivers/virtio/virtio_pci_modern.c                 |  13 +-
 drivers/watchdog/exar_wdt.c                        |   2 +-
 drivers/watchdog/lenovo_se30_wdt.c                 |   2 +
 drivers/xen/balloon.c                              |  13 +-
 fs/9p/vfs_addr.c                                   |   6 +-
 fs/afs/write.c                                     |   9 +-
 fs/btrfs/extent-io-tree.c                          |   6 +-
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/scrub.c                                   |  34 +-
 fs/btrfs/tree-log.c                                |  24 +-
 fs/cachefiles/io.c                                 |  16 +-
 fs/ceph/addr.c                                     |   6 +-
 fs/dax.c                                           |   2 +-
 fs/erofs/fscache.c                                 |   6 +-
 fs/erofs/super.c                                   |  49 ++-
 fs/f2fs/data.c                                     |   6 +-
 fs/f2fs/f2fs.h                                     |  46 ++-
 fs/f2fs/gc.c                                       |   3 +
 fs/f2fs/namei.c                                    |  10 +-
 fs/f2fs/segment.c                                  |  12 +-
 fs/f2fs/segment.h                                  |  43 ++-
 fs/f2fs/super.c                                    |  45 ++-
 fs/filesystems.c                                   |  14 +-
 fs/gfs2/aops.c                                     |  54 +--
 fs/gfs2/aops.h                                     |   3 +-
 fs/gfs2/bmap.c                                     |   3 +-
 fs/gfs2/glock.c                                    |   3 +-
 fs/gfs2/glops.c                                    |   4 +-
 fs/gfs2/incore.h                                   |   9 +-
 fs/gfs2/inode.c                                    |  98 +++++-
 fs/gfs2/inode.h                                    |   1 +
 fs/gfs2/log.c                                      |   7 +-
 fs/gfs2/meta_io.c                                  |   2 +-
 fs/gfs2/meta_io.h                                  |   4 +-
 fs/gfs2/ops_fstype.c                               |  35 +-
 fs/gfs2/super.c                                    |  90 +----
 fs/gfs2/sys.c                                      |   1 -
 fs/gfs2/trans.c                                    |  21 ++
 fs/gfs2/trans.h                                    |   2 +
 fs/gfs2/xattr.c                                    |  11 +-
 fs/gfs2/xattr.h                                    |   2 +-
 fs/iomap/buffered-io.c                             |   2 +
 fs/kernfs/dir.c                                    |   5 +-
 fs/kernfs/file.c                                   |   3 +-
 fs/mount.h                                         |   5 -
 fs/namespace.c                                     | 122 ++++---
 fs/netfs/buffered_read.c                           |  32 +-
 fs/netfs/buffered_write.c                          |   2 +-
 fs/netfs/direct_read.c                             |  13 +-
 fs/netfs/direct_write.c                            |  12 +-
 fs/netfs/fscache_io.c                              |  10 +-
 fs/netfs/internal.h                                |  42 ++-
 fs/netfs/main.c                                    |   1 +
 fs/netfs/misc.c                                    | 219 ++++++++++++
 fs/netfs/objects.c                                 |  48 +--
 fs/netfs/read_collect.c                            | 185 ++--------
 fs/netfs/read_pgpriv2.c                            |   4 +-
 fs/netfs/read_retry.c                              |  26 +-
 fs/netfs/read_single.c                             |   6 +-
 fs/netfs/write_collect.c                           |  81 ++---
 fs/netfs/write_issue.c                             |  38 +-
 fs/netfs/write_retry.c                             |  19 +-
 fs/nfs/fscache.c                                   |   1 +
 fs/nfs/localio.c                                   |  45 +--
 fs/nfs/nfs4proc.c                                  |  32 +-
 fs/nfs/super.c                                     |  19 +
 fs/nfs_common/nfslocalio.c                         | 101 ++++--
 fs/nfsd/filecache.c                                |  32 +-
 fs/nfsd/filecache.h                                |   3 +-
 fs/nfsd/localio.c                                  |  70 +++-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/direct.c                                 |   3 +
 fs/ntfs3/index.c                                   |   8 +
 fs/ntfs3/inode.c                                   |   5 +
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/pidfs.c                                         |   2 +-
 fs/pnode.c                                         |   4 +-
 fs/smb/client/cifsproto.h                          |   3 +-
 fs/smb/client/cifssmb.c                            |  24 +-
 fs/smb/client/file.c                               |  19 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/squashfs/super.c                                |   5 +
 fs/xfs/xfs_aops.c                                  |  22 +-
 fs/xfs/xfs_discard.c                               |  17 +-
 include/crypto/sig.h                               |   2 +-
 include/hyperv/hvgdk_mini.h                        |   2 +-
 include/kunit/clk.h                                |   1 +
 include/linux/arm_sdei.h                           |   4 +-
 include/linux/bio.h                                |   2 +-
 include/linux/bpf_verifier.h                       |  12 +-
 include/linux/bvec.h                               |   7 +-
 include/linux/coresight.h                          |   2 +-
 include/linux/execmem.h                            |   8 +-
 include/linux/exportfs.h                           |  10 +
 include/linux/fscache.h                            |   2 +-
 include/linux/hid.h                                |   3 +-
 include/linux/ieee80211.h                          |  79 ++++-
 include/linux/iomap.h                              |   5 +-
 include/linux/mdio.h                               |   5 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |  58 +++
 include/linux/mount.h                              |  78 ++--
 include/linux/netdevice.h                          |  10 +-
 include/linux/netfs.h                              |  15 +-
 include/linux/nfslocalio.h                         |  26 +-
 include/linux/nvme.h                               |   2 +-
 include/linux/overflow.h                           |  33 +-
 include/linux/pci-epf.h                            |   3 +
 include/linux/pci.h                                |   8 +
 include/linux/phy.h                                |   5 +-
 include/linux/pm_runtime.h                         |   4 +
 include/linux/poison.h                             |   4 +
 include/linux/udp.h                                |  16 +
 include/linux/virtio_vsock.h                       |   1 +
 include/net/bluetooth/hci.h                        |   3 +-
 include/net/bluetooth/hci_core.h                   |  50 ++-
 include/net/checksum.h                             |   2 +-
 include/net/netfilter/nft_fib.h                    |   9 +
 include/net/netns/ipv4.h                           |  11 +
 include/net/page_pool/types.h                      |   6 +
 include/net/sock.h                                 |   7 +-
 include/net/udp.h                                  |   1 +
 include/net/udp_tunnel.h                           |  15 +
 include/net/xfrm.h                                 |  11 +
 include/sound/hdaudio.h                            |   4 +-
 include/sound/hdaudio_ext.h                        |   6 +
 include/trace/events/netfs.h                       |   8 +-
 include/uapi/drm/xe_drm.h                          |   5 +
 include/uapi/linux/bits.h                          |   4 +-
 include/uapi/linux/bpf.h                           |   4 +-
 io_uring/fdinfo.c                                  |  12 +-
 io_uring/io_uring.c                                |  18 +-
 io_uring/register.c                                |   7 +-
 io_uring/sqpoll.c                                  |  43 ++-
 io_uring/sqpoll.h                                  |   8 +-
 kernel/bpf/core.c                                  |  29 +-
 kernel/bpf/verifier.c                              |  18 +-
 kernel/events/core.c                               |  50 ++-
 kernel/power/energy_model.c                        |   4 +
 kernel/power/hibernate.c                           |   5 +
 kernel/power/main.c                                |   3 +-
 kernel/power/power.h                               |   4 +
 kernel/power/wakelock.c                            |   3 +
 kernel/rcu/tree.c                                  |  10 +-
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_stall.h                            |   4 +-
 kernel/sched/core.c                                |  12 +-
 kernel/sched/ext_idle.c                            |   8 +
 kernel/sched/fair.c                                |  13 +-
 kernel/time/posix-cpu-timers.c                     |   9 +
 kernel/trace/bpf_trace.c                           |  10 +-
 kernel/trace/ring_buffer.c                         |  41 ++-
 kernel/trace/trace.h                               |   8 +-
 kernel/trace/trace_events_hist.c                   | 122 ++++++-
 kernel/trace/trace_events_trigger.c                |  20 +-
 lib/Kconfig.ubsan                                  |   2 +
 lib/iov_iter.c                                     |   2 +-
 lib/kunit/static_stub.c                            |   2 +-
 lib/tests/usercopy_kunit.c                         |   1 +
 mm/execmem.c                                       |  40 +--
 mm/filemap.c                                       |  20 +-
 mm/page_alloc.c                                    |   8 +-
 net/9p/client.c                                    |   6 +-
 net/bluetooth/eir.c                                |  17 +-
 net/bluetooth/eir.h                                |   2 +-
 net/bluetooth/hci_conn.c                           |  46 ++-
 net/bluetooth/hci_core.c                           |  50 +--
 net/bluetooth/hci_event.c                          |  40 ++-
 net/bluetooth/hci_sync.c                           |  90 ++++-
 net/bluetooth/iso.c                                |  13 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bluetooth/mgmt.c                               | 146 ++++----
 net/bluetooth/mgmt_util.c                          |  34 +-
 net/bluetooth/mgmt_util.h                          |   4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  12 +-
 net/core/dev.c                                     |   2 +-
 net/core/filter.c                                  |   5 +-
 net/core/net_namespace.c                           |   4 +-
 net/core/netmem_priv.h                             |  33 +-
 net/core/page_pool.c                               | 108 ++++--
 net/core/rtnetlink.c                               |   2 +-
 net/core/skbuff.c                                  |  16 +-
 net/core/skmsg.c                                   |  53 +--
 net/core/sock.c                                    |   8 +-
 net/core/utils.c                                   |   4 +-
 net/core/xdp.c                                     |   4 +-
 net/dsa/tag_brcm.c                                 |   2 +-
 net/ethtool/ioctl.c                                |   3 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |  11 +-
 net/ipv4/udp.c                                     |  44 ++-
 net/ipv4/udp_offload.c                             | 177 +++++++++-
 net/ipv4/udp_tunnel_core.c                         |  15 +
 net/ipv6/ila/ila_common.c                          |   6 +-
 net/ipv6/netfilter.c                               |  12 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  17 +-
 net/ipv6/seg6_local.c                              |   6 +-
 net/ipv6/udp.c                                     |   2 +
 net/ipv6/udp_offload.c                             |   5 +
 net/mac80211/mlme.c                                |   7 +-
 net/mac80211/scan.c                                |  11 +-
 net/ncsi/internal.h                                |  21 +-
 net/ncsi/ncsi-pkt.h                                |  23 +-
 net/ncsi/ncsi-rsp.c                                |  21 +-
 net/netfilter/nf_nat_core.c                        |  12 +-
 net/netfilter/nft_quota.c                          |  20 +-
 net/netfilter/nft_set_pipapo.c                     |  58 ++-
 net/netfilter/nft_set_pipapo_avx2.c                |  21 +-
 net/netfilter/nft_tunnel.c                         |   8 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |   4 +-
 net/netfilter/xt_mark.c                            |   2 +-
 net/netlabel/netlabel_kapi.c                       |   5 +
 net/openvswitch/flow.c                             |   2 +-
 net/packet/af_packet.c                             |  21 +-
 net/packet/internal.h                              |   1 +
 net/sched/sch_ets.c                                |   2 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sched/sch_red.c                                |   2 +-
 net/sched/sch_sfq.c                                |   5 +-
 net/sched/sch_tbf.c                                |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  14 +-
 net/tipc/crypto.c                                  |   6 +-
 net/tls/tls_sw.c                                   |  15 +-
 net/vmw_vsock/virtio_transport_common.c            |  26 +-
 net/wireless/scan.c                                |  18 +-
 net/xfrm/xfrm_device.c                             |   6 +-
 net/xfrm/xfrm_state.c                              |  16 +-
 rust/Makefile                                      |  14 +-
 rust/kernel/alloc/kvec.rs                          |   3 +
 rust/kernel/fs/file.rs                             |   1 +
 rust/kernel/list/arc.rs                            |   2 +-
 rust/kernel/miscdevice.rs                          |   2 +-
 rust/kernel/pci.rs                                 |  15 +-
 scripts/gcc-plugins/gcc-common.h                   |  32 ++
 scripts/gcc-plugins/randomize_layout_plugin.c      |  40 +--
 scripts/generate_rust_analyzer.py                  |  13 +-
 scripts/genksyms/genksyms.c                        |  27 +-
 sound/core/seq_device.c                            |   2 +-
 sound/hda/ext/hdac_ext_controller.c                |  19 +
 sound/hda/hda_bus_type.c                           |   6 +-
 sound/pci/hda/hda_bind.c                           |   4 +-
 sound/soc/apple/mca.c                              |  23 ++
 sound/soc/codecs/hda.c                             |   4 +-
 sound/soc/codecs/tas2764.c                         |   5 +-
 sound/soc/intel/avs/avs.h                          |   4 +-
 sound/soc/intel/avs/core.c                         |  51 ++-
 sound/soc/intel/avs/debugfs.c                      |   6 +-
 sound/soc/intel/avs/ipc.c                          |   4 +-
 sound/soc/intel/avs/loader.c                       |  11 +-
 sound/soc/intel/avs/path.c                         |   8 +-
 sound/soc/intel/avs/pcm.c                          | 129 +++++--
 sound/soc/intel/avs/registers.h                    |   2 +-
 sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   4 +-
 sound/soc/sof/amd/pci-acp70.c                      |   1 +
 sound/soc/sof/ipc4-pcm.c                           |   3 +-
 sound/soc/ti/omap-hdmi.c                           |   7 +-
 sound/usb/implicit.c                               |   1 +
 sound/usb/midi.c                                   |   3 +-
 tools/arch/x86/kcpuid/kcpuid.c                     |  47 ++-
 tools/arch/x86/lib/x86-opcode-map.txt              |  50 +--
 tools/bpf/bpftool/cgroup.c                         |   2 +-
 tools/bpf/resolve_btfids/Makefile                  |   2 +-
 tools/build/Makefile.feature                       |   4 -
 tools/include/nolibc/dirent.h                      |   3 +-
 tools/include/nolibc/stdlib.h                      |   4 +-
 tools/include/nolibc/types.h                       |   2 +-
 tools/include/uapi/linux/bpf.h                     |   4 +-
 tools/lib/bpf/bpf_core_read.h                      |   6 +
 tools/lib/bpf/libbpf.c                             |  57 +--
 tools/lib/bpf/libbpf_internal.h                    |   9 +
 tools/lib/bpf/linker.c                             |   6 +-
 tools/lib/bpf/nlattr.c                             |  15 +-
 tools/objtool/check.c                              |   3 +-
 tools/perf/MANIFEST                                |   6 +
 tools/perf/Makefile.config                         |   6 +-
 tools/perf/Makefile.perf                           |   3 +-
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-trace.c                         |  11 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |   5 +-
 tools/perf/tests/shell/lib/stat_output.sh          |   5 +
 tools/perf/tests/shell/stat+json_output.sh         |   5 +
 tools/perf/tests/switch-tracking.c                 |   2 +-
 tools/perf/ui/browsers/hists.c                     |   2 +-
 tools/perf/util/intel-pt.c                         | 205 ++++++++++-
 tools/perf/util/machine.c                          |   6 +-
 tools/perf/util/pmu.c                              |   3 +
 tools/perf/util/symbol-minimal.c                   | 164 ++++-----
 tools/perf/util/thread.c                           |   8 +-
 tools/perf/util/thread.h                           |   2 +-
 tools/perf/util/tool_pmu.c                         |   8 +-
 tools/power/x86/turbostat/turbostat.c              |  41 ++-
 tools/testing/kunit/qemu_configs/sparc.py          |   2 +
 tools/testing/selftests/Makefile                   |   2 +-
 tools/testing/selftests/arm64/fp/fp-ptrace.c       |  14 +-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   6 +
 .../selftests/bpf/prog_tests/kmem_cache_iter.c     |   2 +-
 .../selftests/bpf/progs/verifier_load_acquire.c    |  40 ++-
 .../selftests/bpf/progs/verifier_store_release.c   |  32 +-
 tools/testing/selftests/bpf/test_loader.c          |  14 +-
 tools/testing/selftests/coredump/stackdump_test.c  |  10 +-
 tools/testing/selftests/cpufreq/cpufreq.sh         |   3 +-
 tools/testing/selftests/drivers/net/hw/tso.py      |   4 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  13 +-
 tools/tracing/rtla/src/timerlat_bpf.c              |   1 +
 818 files changed, 10103 insertions(+), 5457 deletions(-)


