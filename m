Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D232EB5CD;
	Tue, 17 Jun 2025 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174118; cv=none; b=CIIS5jbmwAuuJapwJcY2Dba3AsfInPmfOe8VF0PnrHY243Tgrbh2lx0qe3UEM4xLz8m+3LIKjeIfnuJoE9mhMJsqyhjtE/xzLzZRIFbXqZZlLSEEf8j032LdP1E7c+m9WbPN8xdFyHLfwYmffDAAKnzdSrlwXYxJRm32TuOF1fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174118; c=relaxed/simple;
	bh=iWp0k7by3/qLxD9ynyChnXRsPX88WztnjAFJYMKxi4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vv6lx9gdu/g4ZFS4qmW9rCSWS16zfgoOoTBXNyQVSSsjftTe5qj+01NDkngo2z2WCku1hai75YLbkSuqFV2MRwLagYgBJVsa9OSZkuMiQDL1v0XmCSZzOeAp5QRcGjM0pKxugIFKk40HsrOnB3AiZa7MBY+9IEodyjv+LRq+9Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9fc07HS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9fc07HS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A647CC4CEE3;
	Tue, 17 Jun 2025 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174117;
	bh=iWp0k7by3/qLxD9ynyChnXRsPX88WztnjAFJYMKxi4U=;
	h=From:To:Cc:Subject:Date:From;
	b=Y9fc07HSBa0HtKZtlec5X+kJg+Ulp+DoS9JwQsoJ2QzGpREFMIg3ZHxwKnmAp/7EU
	 FFkLp2aVYQzNlAYUvhtMkPxjkIRH54OHkqDrrxRFgqWi+bEQprIOVUjUVnVQnWu1g2
	 UlniyMlPTyOKkWir3OpEJ1v4xuAlQ/mcT+fxNIHo=
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
Subject: [PATCH 6.12 000/512] 6.12.34-rc1 review
Date: Tue, 17 Jun 2025 17:19:26 +0200
Message-ID: <20250617152419.512865572@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.34-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.34-rc1
X-KernelTest-Deadline: 2025-06-19T15:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.34 release.
There are 512 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.34-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.34-rc1

I Hsin Cheng <richard120310@gmail.com>
    drm/meson: Use 1000ULL when operating with mode->clock

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

Eric Dumazet <edumazet@google.com>
    calipso: unlock rcu before returning -EAFNOSUPPORT

Xin Li (Intel) <xin@zytor.com>
    x86/fred/signal: Prevent immediate repeat of single step trap on return from SIGTRAP handler

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

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: usbhid: Eliminate recurrent out-of-bounds bug in usbhid_parse()

David Heimann <d@dmeh.net>
    ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1

Francesco Dolcini <francesco.dolcini@toradex.com>
    Revert "wifi: mwifiex: Fix HT40 bandwidth issue."

Suleiman Souhlal <suleiman@google.com>
    tools/resolve_btfids: Fix build when cross compiling kernel with clang.

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: relax slice condition to cover more `noreturn` Rust functions

Matthew Wilcox (Oracle) <willy@infradead.org>
    block: Fix bvec_set_folio() for very large folios

Matthew Wilcox (Oracle) <willy@infradead.org>
    bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP

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

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: access fcpreq only when holding reqlock

Filipe Manana <fdmanana@suse.com>
    btrfs: exit after state split error at set_extent_bit()

Christian Brauner <brauner@kernel.org>
    gfs2: pass through holder from the VFS for freeze/thaw

Zijun Hu <quic_zijuhu@quicinc.com>
    fs/filesystems: Fix potential unsigned integer underflow in fs_name()

Filipe Manana <fdmanana@suse.com>
    btrfs: exit after state insertion failure at btrfs_convert_extent_bit()

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

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix leak of Geneve TLV option object

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

Michal Luczaj <mhal@rbox.co>
    net: Fix TOCTOU issue in sk_is_readable()

Yunhui Cui <cuiyunhui@bytedance.com>
    ACPI: CPPC: Fix NULL pointer dereference when nosmp is used

Robert Malz <robert.malz@canonical.com>
    i40e: retry VFLR handling if there is ongoing VF reset

Robert Malz <robert.malz@canonical.com>
    i40e: return false from i40e_reset_vf if reset is in progress

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix more rounding issues with 59.94Hz modes

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use vclk_freq instead of pixel_freq in debug print

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix debug log statement when setting the HDMI clocks

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use unsigned long long / Hz for frequency types

Haren Myneni <haren@linux.ibm.com>
    powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: fix a potential crash on gso_skb handling

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: iscsi: Fix incorrect error path labels for flashnode operations

Wojciech Slenska <wojciech.slenska@gmail.com>
    pinctrl: qcom: pinctrl-qcm2290: Add missing pins

Félix Piédallu <felix.piedallu@non.se.com>
    spi: omap2-mcspi: Disable multi-mode when the previous message kept CS asserted

Félix Piédallu <felix.piedallu@non.se.com>
    spi: omap2-mcspi: Disable multi mode when CS should be kept asserted after message

Dan Carpenter <dan.carpenter@linaro.org>
    regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()

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

Easwar Hariharan <eahariha@linux.microsoft.com>
    wifi: ath11k: convert timeouts to secs_to_jiffies()

Caleb Connolly <caleb.connolly@linaro.org>
    ath10k: snoc: fix unbalanced IRQ enable in crash recovery

Jeongjun Park <aha310510@gmail.com>
    ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix untagged traffic sent via cpu tagged with VID 0

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Protect mgmt_pending list with its own lock

Dr. David Alan Gilbert <linux@treblig.org>
    Bluetooth: MGMT: Remove unused mgmt_pending_find_data

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

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Move runtime PM enable to sci_probe_single()

David Lechner <dlechner@baylibre.com>
    dt-bindings: pwm: adi,axi-pwmgen: Fix clocks

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: pwm: Correct indentation and style in DTS example

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    dt-bindings: pwm: adi,axi-pwmgen: Increase #pwm-cells to 3

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: add gs101 specific eint suspend/resume callbacks

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: add dedicated SoC eint suspend/resume callbacks

Peter Griffin <peter.griffin@linaro.org>
    pinctrl: samsung: refactor drvdata suspend & resume callbacks

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100: Add GPU cooling

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: x1e80100: Apply consistent critical thermal shutdown

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    mmc: sdhci-of-dwcmshc: add PD workaround on RK3576

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Introduce dev_pm_genpd_rpm_always_on()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi - fix crash with unsupported versions of F34

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for HP Agusta using CS35L41 HDA

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Support mute led function for HP platform

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for various HP Laptops using CS35L41 HDA

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: fix micmute LEDs on HP Laptops with ALC3247

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: fix micmute LEDs on HP Laptops with ALC3315

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu: read back register after written for VCN v4.0.5

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amd/pm: power up or down vcn by instance

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amd/pm: add inst to dpm_set_vcn_enable

Gautham R. Shenoy <gautham.shenoy@amd.com>
    tools/power turbostat: Fix AMD package-energy reporting

Al Viro <viro@zeniv.linux.org.uk>
    do_change_type(): refuse to operate on unmounted/not ours mounts

Al Viro <viro@zeniv.linux.org.uk>
    fix propagation graph breakage by MOVE_MOUNT_SET_GROUP move_mount(2)

Al Viro <viro@zeniv.linux.org.uk>
    path_overmount(): avoid false negatives

Nitesh Shetty <nj.shetty@samsung.com>
    iov_iter: use iov_offset for length calculation in iov_iter_aligned_bvec

Yuuki NAGAO <wf.yn386@gmail.com>
    ASoC: ti: omap-hdmi: Re-add dai_link->platform to fix card init

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Verify content returned by parse_int_array()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: hda: Fix RPM usage count underflow

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: qcom: Prevent calling phy_exit() before phy_init()

Nylon Chen <nylon.chen@sifive.com>
    riscv: misaligned: fix sleeping function called during misaligned access handling

Ido Schimmel <idosch@nvidia.com>
    seg6: Fix validation of nexthop addresses

Mirco Barone <mirco.barone@polito.it>
    wireguard: device: enable threaded NAPI

Daniele Palmas <dnlplm@gmail.com>
    net: wwan: mhi_wwan_mbim: use correct mux_id for multiplexing

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: cfg80211/mac80211: correctly parse S1G beacon optional elements

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not touch DLL_IQQD on bcm53115

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: allow RGMII for bcm63xx RGMII ports

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not enable RGMII delay on bcm63xx

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix swapped TX stats for MII interfaces.

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: also check reverse tuple to obtain clashing entry

Florian Westphal <fw@strlen.de>
    netfilter: nf_set_pipapo_avx2: fix initial map fill

Michael Walle <mwalle@kernel.org>
    drm/panel-simple: fix the warnings for the Evervision VGG644804

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO

Keith Busch <kbusch@kernel.org>
    nvme: fix command limits status code

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix power.is_suspended cleanup for direct-complete devices

Bui Quang Minh <minhquangbui99@gmail.com>
    selftests: net: build net/lib dependency in all target

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: correctly report gso type for UDP tunnels

Jinjian Song <jinjian.song@fibocom.com>
    net: wwan: t7xx: Fix napi rx poll issue

Shiming Cheng <shiming.cheng@mediatek.com>
    net: fix udp gso skb_segment after pull from frag_list

Jesus Narvaez <jesus.narvaez@intel.com>
    drm/i915/guc: Handle race condition where wakeref count drops below 0

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Fix using wrong mask in REG_FIELD_PREP

Jesus Narvaez <jesus.narvaez@intel.com>
    drm/i915/guc: Check if expecting reply before decrementing outstanding_submission_g2h

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

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix shared reset

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-spi: fix shared reset

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
    drm/xe: Make xe_gt_freq part of the Documentation

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

Nicolas Pitre <npitre@baylibre.com>
    vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: prevent deactivate active config while enabling the config

Qasim Ijaz <qasdev00@gmail.com>
    fpga: fix potential null pointer deref in fpga_mgr_test_img_load_sgt()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    counter: interrupt-cnt: Protect enable/disable OPs with mutex

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

Jerome Brunet <jbrunet@baylibre.com>
    PCI: endpoint: Retain fixed-size BAR size as well as aligned size

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: loongson: Add missing alarm notifications for ACPI RTC events

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Log Error Source ID only when valid

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Initialize aer_err_info before using it

Zhe Qiao <qiaozhe@iscas.ac.cn>
    PCI/ACPI: Fix allocated memory release on error in pci_acpi_scan_root()

Henry Martin <bsdhenrymartin@gmail.com>
    dmaengine: ti: Add NULL check in udma_probe()

Chenyuan Yang <chenyuan0y@gmail.com>
    phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug

Mario Limonciello <mario.limonciello@amd.com>
    PCI: Explicitly put devices into D0 when initializing

Hector Martin <marcan@marcan.st>
    PCI: apple: Use gpiod_set_value_cansleep in probe flow

Hans Zhang <18255117159@163.com>
    PCI: cadence: Fix runtime atomic count underflow

Jerome Brunet <jbrunet@baylibre.com>
    PCI: rcar-gen4: set ep BAR4 fixed size

Wilfred Mallawa <wilfred.mallawa@wdc.com>
    PCI: Print the actual delay time in pci_bridge_wait_for_secondary_bus()

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

Anubhav Shelat <ashelat@redhat.com>
    perf trace: Set errpid to false for rseq and set_robust_list

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when remounting nfs

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: clear SB_RDONLY before getting superblock

Anubhav Shelat <ashelat@redhat.com>
    perf trace: Always print return value for syscalls returning a pid

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf record: Fix incorrect --user-regs comments

Ian Rogers <irogers@google.com>
    perf symbol: Fix use-after-free in filename__read_build_id

Jason-JH Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Refine GCE_GCTL_VALUE setting

Peng Fan <peng.fan@nxp.com>
    mailbox: imx: Fix TXDB_V2 sending

Leo Yan <leo.yan@arm.com>
    perf tests switch-tracking: Fix timestamp comparison

Alexey Gladkov <legion@kernel.org>
    mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Fix an error handling path in exynos_lpass_probe()

Dan Carpenter <dan.carpenter@linaro.org>
    rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()

Siddharth Vadapalli <s-vadapalli@ti.com>
    remoteproc: k3-dsp: Drop check performed in k3_dsp_rproc_{mbox_callback/kick}

Siddharth Vadapalli <s-vadapalli@ti.com>
    remoteproc: k3-r5: Drop check performed in k3_r5_rproc_{mbox_callback/kick}

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

Benjamin Marzinski <bmarzins@redhat.com>
    dm-flakey: make corrupting read bios work

Benjamin Marzinski <bmarzins@redhat.com>
    dm-flakey: error all IOs when num_features is absent

Benjamin Marzinski <bmarzins@redhat.com>
    dm: fix dm_blk_report_zones

Ian Rogers <irogers@google.com>
    perf symbol-minimal: Fix double free in filename__read_build_id

Alexei Safin <a.safin@rosa.ru>
    hwmon: (asus-ec-sensors) check sensor index in read_string()

Mikhail Arkhipov <m.arhipov@rosa.ru>
    mtd: nand: ecc-mxic: Fix use of uninitialized variable ret

Sean Christopherson <seanjc@google.com>
    x86/irq: Ensure initial PIR loads are performed exactly once

Henry Martin <bsdhenrymartin@gmail.com>
    backlight: pm8941: Add NULL check in wled_configure()

Benjamin Marzinski <bmarzins@redhat.com>
    dm: free table mempools if not used in __bind

Benjamin Marzinski <bmarzins@redhat.com>
    dm: don't change md if dm_table_set_restrictions() fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui browser hists: Set actions->thread before calling do_zoom_thread()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Warn when libdebuginfod devel files are not available

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Fix attribute addition

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Remove bogus void member

Sergey Shtylyov <s.shtylyov@omp.ru>
    fbdev: core: fbcvt: avoid division by 0 in fb_cvt_hperiod()

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

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qcm2290: fix (some) of QUP interconnects

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou

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

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Update eMMC for NanoPi R5 series

Peter Robinson <pbrobinson@gmail.com>
    arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3566-rock3c

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Add missing 'compatible' property to regulators node

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

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Reparent vdec1/2 and venc1 power domains

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: at91sam9263: fix NAND chip selects

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select

Chukun Pan <amadeus@jmu.edu.cn>
    arm64: dts: rockchip: Move SHMEM memory to reserved memory on rk3588

Varadarajan Narayanan <quic_varada@quicinc.com>
    arm64: dts: qcom: ipq9574: Fix USB vdd info

Stephan Gerhold <stephan.gerhold@linaro.org>
    arm64: dts: qcom: sc8280xp-x13s: Drop duplicate DMIC supplies

Xilin Wu <wuxilin123@gmail.com>
    arm64: dts: qcom: sm8250: Fix CPU7 opp table

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
    arm64: dts: qcom: sm8650: setup gpu thermal with higher temperatures

Mark Kettenis <kettenis@openbsd.org>
    arm64: dts: qcom: x1e80100: Mark usb_2 as dma-coherent

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to correct check conditions in f2fs_cross_rename

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: use d_inode(dentry) cleanup dentry->d_inode

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

Wei Fang <wei.fang@nxp.com>
    net: phy: clear phydev->devlink when the link is deleted

KaFai Wan <mannkafai@gmail.com>
    bpf: Avoid __bpf_prog_ret0_warn when jit fails

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Fix Tx skb circular buffer occupancy check in dmaengine xmit

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Fix 1-step timestamping over ipv4 or ipv6

Jack Morgenstein <jackm@nvidia.com>
    RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: fix `rx_bytes` accounting for stream sockets

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
    wifi: mt76: mt7996: fix RX buffer size of MCU event

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7996: set EHT max ampdu length capability

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

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix not using SID from adv report

Michal Koutný <mkoutny@suse.com>
    kernfs: Relax constraint in draining guard

ping.gao <ping.gao@samsung.com>
    scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort()

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: ath9k_htc: Abort software beacon handling if disabled

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix live migration function without VF device driver

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: add eq and aeq interruption restore

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: fix XQE dma address error

Rajat Soni <quic_rajson@quicinc.com>
    wifi: ath12k: fix memory leak in ath12k_service_ready_ext_event

Rolf Eike Beer <eb@emlix.com>
    iommu: remove duplicate selection of DMAR_TABLE

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw89: fix firmware scan delay unit for WiFi 6 chips

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: rtw88: fix the 'para' buffer size to avoid reading out of bounds

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: enlarge retry times of RX tag to 1000

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

Hans Zhang <18255117159@163.com>
    efi/libstub: Describe missing 'out' parameter in efi_load_initrd

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlfiwi: mvm: Fix the rate reporting

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

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix error flow upon firmware failure for RQ destruction

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

Yi Zhang <yi.zhang@redhat.com>
    scsi: smartpqi: Fix smp_processor_id() call trace for preemptible kernels

Chao Yu <chao@kernel.org>
    f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()

Chao Yu <chao@kernel.org>
    f2fs: clean up w/ fscrypt_is_bounce_page()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: assign random address if device address is same as bond

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Protect against overflow in iommu_pgsize()

Jonathan Wiepert <jonathan.wiepert@gmail.com>
    Use thread-safe function pointer in libbpf_print

Tao Chen <chen.dylane@linux.dev>
    libbpf: Remove sample_period init in perf_buffer

Feng Yang <yangfeng@kylinos.cn>
    libbpf: Fix event name too long error

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h

Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
    wifi: ath12k: fix node corruption in ar->arvifs list

Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>
    wifi: ath12k: Fix the QoS control field offset to build QoS header

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Add MSDU length validation for TKIP MIC error

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: fix invalid access to memory

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtw88: do not ignore hardware read error during DPK

Zhen XIN <zhen.xin@nokia-sbell.com>
    wifi: rtw88: sdio: call rtw_sdio_indicate_tx_status unconditionally

Zhen XIN <zhen.xin@nokia-sbell.com>
    wifi: rtw88: sdio: map mgmt frames to queue TX_DESC_QSEL_MGMT

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm: Use xdo.dev instead of xdo.real_dev

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Avoid using xso.real_dev unnecessarily

Viktor Malik <vmalik@redhat.com>
    libbpf: Fix buffer overflow in bpf_object__init_prog

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix GCPS 64-bit member variables

Toke Høiland-Jørgensen <toke@redhat.com>
    page_pool: Track DMA-mapped pages and unmap them when destroying the pool

Toke Høiland-Jørgensen <toke@redhat.com>
    page_pool: Move pp_magic check into helper functions

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sbi->total_valid_block_count

yohan.joung <yohan.joung@sk.com>
    f2fs: prevent the current section from being selected as a victim during GC

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: clean up unnecessary indentation

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: ath12k: Fix buffer overflow in debugfs

Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
    wifi: ath12k: Fix WMI tag for EHT rate in peer assoc

Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
    wifi: ath12k: fix cleanup path after mhi init

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
    bpf: Check link_create.flags parameter for multi_kprobe

Jacob Moroni <jmoroni@google.com>
    IB/cm: use rwlock for MAD agent lock

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix invalid memory access while forming 802.11 header

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix memory leak during vdev_id mismatch

Stone Zhang <quic_stonez@quicinc.com>
    wifi: ath11k: fix node corruption in ar->arvifs list

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

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/a6xx: Disable rgb565_predicator on Adreno 7c3

Terry Tritton <terry.tritton@linaro.org>
    selftests/seccomp: fix negative_ENOSYS tracer tests on arm32

Anand Moon <linux.amoon@gmail.com>
    perf/amlogic: Replace smp_processor_id() with raw_smp_processor_id() in meson_ddr_pmu_create()

Kees Cook <kees@kernel.org>
    scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops

Gustavo A. R. Silva <gustavoars@kernel.org>
    overflow: Fix direct struct member initialization in _DEFINE_FLEX()

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Do not discard modified SVE state

Huang Yiwei <quic_hyiwei@quicinc.com>
    firmware: SDEI: Allow sdei initialization without ACPI_APEI_GHES

Biju Das <biju.das.jz@bp.renesas.com>
    drm/tegra: rgb: Fix the unbound reference count

Kees Cook <kees@kernel.org>
    drm/vkms: Adjust vkms_state->active_planes allocation type

Biju Das <biju.das.jz@bp.renesas.com>
    drm: rcar-du: Fix memory leak in rcar_du_vsps_init()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: enable SmartDMA on SC8180X

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()

Casey Connolly <casey.connolly@linaro.org>
    drm/panel: samsung-sofef00: Drop s6e3fc2x01 support

Hongbo Yao <andy.xu@hj-micro.com>
    perf: arm-ni: Fix missing platform_set_drvdata()

Hongbo Yao <andy.xu@hj-micro.com>
    perf: arm-ni: Unregister PMUs on probe failure

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Update panthor_mmu::irq::mask when needed

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
    drm/vc4: tests: Use return instead of assert

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/d3cold: Set power state to D3Cold during s2idle/s3

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix dumb buffer leak

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    drm/vmwgfx: Add error path for xa_store in vmw_bo_add_detached_resource

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add seqno waiter for sync_files

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: core: fix up bus match const issues.

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Constrain channels according to TDM mask

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: sh-msiof: Fix maximum DMA transfer size

Armin Wolf <W_Armin@gmx.de>
    ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    thermal/drivers/mediatek/lvts: Fix debugfs unregister on failure

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Print PM debug messages during hibernation

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()

Mingcong Bai <jeffbai@aosc.io>
    ACPI: resource: fix a typo for MECHREVO in irq1_edge_low_force_override[]

Zijun Hu <quic_zijuhu@quicinc.com>
    PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: SOF: amd: add missing acp descriptor field

Kees Cook <kees@kernel.org>
    ASoC: SOF: ipc4-pcm: Adjust pipeline_list->pipelines allocation type

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

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/{skx_common,i10nm}: Fix the loss of saved RRL for HBM pseudo channel 0

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Fix general protection fault

Julien Massot <julien.massot@collabora.com>
    ASoC: mediatek: mt8195: Set ETDM1/2 IN/OUT to COMP_DUMMY()

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Enable main IRQs

Jemmy Wong <jemmywong512@gmail.com>
    tools/nolibc/types.h: fix mismatched parenthesis in minor()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: exserial: don't forget to handle FFixedHW opregions for reading

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Redo lookup on EEXIST

Tzung-Bi Shih <tzungbi@kernel.org>
    kunit: Fix wrong parameter to kunit_deactivate_static_stub()

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - move fallback ahash_request to the end of the struct

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Only add ecb if it is not already there

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lrw - Only add ecb if it is not already there

Yongliang Gao <leonylgao@tencent.com>
    rcu/cpu_stall_cputime: fix the hardirq count for x86 architecture

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

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - undo runtime PM changes during driver removal

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
    gfs2: gfs2_create_inode error handling fix

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: replace sd_aspace with sd_inode

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Prevent UMC counters from saturating

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Remove unused 'struct amd_uncore_ctx::node' member

Peter Zijlstra <peterz@infradead.org>
    sched: Fix trace_sched_switch(.prev_state)

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce-hash - fix error handling in sun8i_ce_hash_run()

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/idle: Remove MFENCEs for X86_BUG_CLFLUSH_MONITOR in mwait_idle_with_hints() and prefer_mwait_c1_over_halt()

Ahmed S. Darwish <darwi@linutronix.de>
    tools/x86/kcpuid: Fix error handling


-------------

Diffstat:

 .../devicetree/bindings/pwm/adi,axi-pwmgen.yaml    |  21 +-
 .../devicetree/bindings/pwm/brcm,bcm7038-pwm.yaml  |   8 +-
 .../devicetree/bindings/pwm/brcm,kona-pwm.yaml     |   8 +-
 .../regulator/mediatek,mt6357-regulator.yaml       |  12 +-
 .../devicetree/bindings/soc/fsl/fsl,qman-fqd.yaml  |   4 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 Documentation/gpu/xe/index.rst                     |   1 +
 Documentation/gpu/xe/xe_gt_freq.rst                |  14 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/at91sam9263ek.dts      |   2 +-
 arch/arm/boot/dts/microchip/tny_a9263.dts          |   2 +-
 arch/arm/boot/dts/microchip/usb_a9263.dts          |   4 +-
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi           |  82 +++---
 arch/arm/mach-aspeed/Kconfig                       |   1 -
 arch/arm64/Kconfig                                 |   6 +-
 .../arm64/boot/dts/freescale/imx8mm-beacon-kit.dts |   1 +
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   1 +
 .../arm64/boot/dts/freescale/imx8mn-beacon-kit.dts |   1 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   1 +
 .../boot/dts/freescale/imx8mp-beacon-som.dtsi      |   1 +
 arch/arm64/boot/dts/mediatek/mt6357.dtsi           |  10 -
 arch/arm64/boot/dts/mediatek/mt6359.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |  10 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   4 +
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |  50 ++--
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |  12 -
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |  12 -
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi     |   1 +
 arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi   |  11 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi              |  16 +-
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |   3 -
 .../arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts |   2 +
 .../arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts |   3 +
 .../boot/dts/qcom/sdm845-samsung-starqltechn.dts   |  16 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |  71 ++---
 .../boot/dts/qcom/x1e80100-microsoft-romulus.dtsi  |   2 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             | 299 +++++++++++----------
 .../r8a779g0-white-hawk-ard-audio-da7212.dtso      |   2 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   8 -
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts    |   1 +
 .../arm64/boot/dts/rockchip/rk3568-nanopi-r5s.dtsi |   5 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |  15 +-
 .../boot/dts/ti/k3-j721e-common-proc-board.dts     |   1 +
 arch/arm64/configs/defconfig                       |   3 +
 arch/arm64/include/asm/esr.h                       |  12 +-
 arch/arm64/include/asm/fpsimd.h                    |   3 +
 arch/arm64/kernel/entry-common.c                   |  46 +++-
 arch/arm64/kernel/fpsimd.c                         |  36 ++-
 arch/arm64/xen/hypercall.S                         |  21 +-
 arch/m68k/mac/config.c                             |   2 +-
 .../boot/dts/loongson/loongson64c_4core_ls7a.dts   |   1 +
 arch/powerpc/kernel/Makefile                       |   2 +-
 arch/powerpc/kexec/crash.c                         |   5 +-
 arch/powerpc/platforms/book3s/vas-api.c            |   9 +
 arch/powerpc/platforms/powernv/memtrace.c          |   8 +-
 arch/powerpc/platforms/pseries/iommu.c             |   2 +-
 arch/riscv/kernel/traps_misaligned.c               |   4 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   4 +-
 arch/s390/net/bpf_jit_comp.c                       |  12 +-
 arch/x86/events/amd/uncore.c                       |  36 ++-
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
 arch/x86/lib/x86-opcode-map.txt                    |  50 ++--
 block/blk-zoned.c                                  |   7 +-
 block/elevator.c                                   |   3 +-
 crypto/api.c                                       |  13 +-
 crypto/lrw.c                                       |   4 +-
 crypto/xts.c                                       |   4 +-
 drivers/acpi/acpica/exserial.c                     |   6 +
 drivers/acpi/apei/Kconfig                          |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/acpi/osi.c                                 |   1 -
 drivers/acpi/resource.c                            |   2 +-
 drivers/base/power/main.c                          |   3 +-
 drivers/block/brd.c                                |  11 +-
 drivers/block/loop.c                               |   8 +-
 drivers/bluetooth/btintel.c                        |  10 +-
 drivers/bluetooth/btintel_pcie.c                   |  31 ++-
 drivers/bluetooth/btintel_pcie.h                   |  10 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +
 drivers/clk/qcom/camcc-sm6350.c                    |  18 ++
 drivers/clk/qcom/dispcc-sm6350.c                   |   3 +
 drivers/clk/qcom/gcc-msm8939.c                     |   4 +-
 drivers/clk/qcom/gcc-sm6350.c                      |   6 +
 drivers/clk/qcom/gpucc-sm6350.c                    |   6 +
 drivers/counter/interrupt-cnt.c                    |   9 +
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   7 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  17 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |  34 ++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/marvell/cesa/cipher.c               |   3 +
 drivers/crypto/marvell/cesa/hash.c                 |   2 +-
 drivers/dma/ti/k3-udma.c                           |   3 +-
 drivers/edac/i10nm_base.c                          |  35 +--
 drivers/edac/skx_common.c                          |   1 +
 drivers/edac/skx_common.h                          |  11 +-
 drivers/firmware/Kconfig                           |   1 -
 drivers/firmware/arm_sdei.c                        |  11 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |   1 +
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/fpga/tests/fpga-mgr-test.c                 |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   8 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   8 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v14_0.h       |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |   4 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  24 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |  19 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_5_ppt.c   |   4 +-
 .../gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c   |   4 +-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c     |  38 ++-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/i915/display/intel_psr_regs.h      |   4 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  19 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  31 ++-
 drivers/gpu/drm/meson/meson_drv.c                  |   2 +-
 drivers/gpu/drm/meson/meson_drv.h                  |   2 +-
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |  29 +-
 drivers/gpu/drm/meson/meson_vclk.c                 | 226 +++++++++-------
 drivers/gpu/drm/meson/meson_vclk.h                 |  13 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   1 -
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |  16 +-
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |  16 +-
 drivers/gpu/drm/panel/panel-samsung-sofef00.c      |  34 +--
 drivers/gpu/drm/panel/panel-simple.c               |   5 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |   1 +
 drivers/gpu/drm/panthor/panthor_regs.h             |   4 +-
 drivers/gpu/drm/renesas/rcar-du/rcar_du_kms.c      |  10 +-
 drivers/gpu/drm/tegra/rgb.c                        |  14 +-
 drivers/gpu/drm/vc4/tests/vc4_mock_output.c        |  36 ++-
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  26 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  34 ++-
 drivers/gpu/drm/xe/xe_gt_freq.c                    |   2 +
 drivers/gpu/drm/xe/xe_pci.c                        |   1 +
 drivers/hid/hid-hyperv.c                           |   4 +-
 drivers/hid/usbhid/hid-core.c                      |  25 +-
 drivers/hwmon/asus-ec-sensors.c                    |   4 +
 drivers/hwtracing/coresight/coresight-catu.c       |  27 +-
 drivers/hwtracing/coresight/coresight-catu.h       |   1 +
 drivers/hwtracing/coresight/coresight-config.h     |   2 +-
 drivers/hwtracing/coresight/coresight-core.c       |   6 +-
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |   3 +-
 drivers/hwtracing/coresight/coresight-funnel.c     |   3 +-
 drivers/hwtracing/coresight/coresight-replicator.c |   3 +-
 drivers/hwtracing/coresight/coresight-stm.c        |   2 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |  49 ++--
 drivers/hwtracing/coresight/coresight-tmc-core.c   |   2 +-
 drivers/hwtracing/coresight/coresight-tpiu.c       |   2 +-
 drivers/iio/adc/ad7124.c                           |   4 +-
 drivers/iio/adc/mcp3911.c                          |  39 ++-
 drivers/iio/adc/pac1934.c                          |   2 +-
 drivers/iio/filter/admv8818.c                      | 230 ++++++++++++----
 drivers/infiniband/core/cm.c                       |  16 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   1 -
 drivers/infiniband/hw/mlx5/qpc.c                   |  30 ++-
 drivers/input/rmi4/rmi_f34.c                       | 133 +++++----
 drivers/iommu/Kconfig                              |   1 -
 drivers/iommu/iommu.c                              |   4 +-
 drivers/mailbox/imx-mailbox.c                      |  21 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |  51 ++--
 drivers/md/dm-core.h                               |   1 +
 drivers/md/dm-flakey.c                             |  70 ++---
 drivers/md/dm-zone.c                               |  25 +-
 drivers/md/dm.c                                    |  30 ++-
 .../media/platform/verisilicon/hantro_postproc.c   |   4 +-
 drivers/mfd/exynos-lpass.c                         |   6 +-
 drivers/mfd/stmpe-spi.c                            |   2 +-
 drivers/misc/mei/vsc-tp.c                          |   4 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |  11 +-
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  40 +++
 drivers/mtd/nand/ecc-mxic.c                        |   2 +-
 drivers/net/bonding/bond_main.c                    |  25 +-
 drivers/net/dsa/b53/b53_common.c                   |  37 +--
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |   3 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  47 +++-
 drivers/net/ethernet/intel/ice/ice_sched.c         | 181 ++++++++++---
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  18 +-
 .../net/ethernet/intel/idpf/idpf_singleq_txrx.c    |   9 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  45 ++--
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   8 -
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   2 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |   1 +
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/qos_sq.c    |  22 ++
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  18 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 .../mlx5/core/steering/hws/mlx5hws_definer.c       |   3 +
 drivers/net/ethernet/microchip/lan743x_main.c      |  15 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   7 +
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   6 +
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |  49 +++-
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |  21 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c   |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/ethernet/ti/icssg/icssg_stats.c        |   8 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   6 +-
 drivers/net/macsec.c                               |  40 ++-
 drivers/net/netdevsim/netdev.c                     |   3 +-
 drivers/net/phy/mdio_bus.c                         |  12 +
 drivers/net/phy/mscc/mscc_ptp.c                    |  20 +-
 drivers/net/phy/phy_device.c                       |   4 +-
 drivers/net/usb/aqc111.c                           |  10 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  26 ++
 drivers/net/wireguard/device.c                     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |  37 +--
 drivers/net/wireless/ath/ath11k/core.h             |   4 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          | 148 +---------
 drivers/net/wireless/ath/ath11k/debugfs.h          |  10 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  92 ++++++-
 drivers/net/wireless/ath/ath11k/mac.h              |   4 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  47 +++-
 drivers/net/wireless/ath/ath12k/core.c             |   8 +-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |   3 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  54 ++--
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   1 +
 drivers/net/wireless/ath/ath12k/hal.c              | 103 +++----
 drivers/net/wireless/ath/ath12k/hal.h              |  64 +++--
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   3 +-
 drivers/net/wireless/ath/ath12k/hw.c               |  35 ++-
 drivers/net/wireless/ath/ath12k/hw.h               |  12 +-
 drivers/net/wireless/ath/ath12k/pci.c              |  12 +-
 drivers/net/wireless/ath/ath12k/pci.h              |   4 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |   3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   3 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   3 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |  10 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   2 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   2 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   9 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c                |  11 +-
 drivers/nvme/host/constants.c                      |   2 +-
 drivers/nvme/host/core.c                           |   1 -
 drivers/nvme/host/pr.c                             |   2 -
 drivers/nvme/target/core.c                         |   9 +-
 drivers/nvme/target/fcloop.c                       |  31 +--
 drivers/nvme/target/io-cmd-bdev.c                  |   9 +-
 drivers/nvmem/zynqmp_nvmem.c                       |   1 +
 drivers/of/unittest.c                              |  10 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |  11 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |   1 +
 drivers/pci/controller/pcie-apple.c                |   4 +-
 drivers/pci/endpoint/pci-epf-core.c                |  22 +-
 drivers/pci/pci-acpi.c                             |  23 +-
 drivers/pci/pci-driver.c                           |   6 -
 drivers/pci/pci.c                                  |  15 +-
 drivers/pci/pci.h                                  |   1 +
 drivers/pci/pcie/dpc.c                             |  66 +++--
 drivers/perf/amlogic/meson_ddr_pmu_core.c          |   2 +-
 drivers/perf/arm-ni.c                              |  40 +--
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   6 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |  13 +-
 drivers/pinctrl/pinctrl-at91.c                     |   6 +-
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |   9 +
 drivers/pinctrl/samsung/pinctrl-exynos-arm64.c     |  52 ++--
 drivers/pinctrl/samsung/pinctrl-exynos.c           | 266 ++++++++++--------
 drivers/pinctrl/samsung/pinctrl-exynos.h           |   8 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  21 +-
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   8 +-
 drivers/pmdomain/core.c                            |  35 +++
 drivers/power/reset/at91-reset.c                   |   5 +-
 drivers/ptp/ptp_private.h                          |  12 +-
 drivers/regulator/max20086-regulator.c             |   6 +-
 drivers/remoteproc/qcom_wcnss_iris.c               |   2 +
 drivers/remoteproc/ti_k3_dsp_remoteproc.c          |   8 -
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   8 -
 drivers/rpmsg/qcom_smd.c                           |   2 +-
 drivers/rtc/rtc-loongson.c                         |   8 +
 drivers/rtc/rtc-sh.c                               |  12 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  29 +-
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  11 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  17 +-
 drivers/soc/qcom/smp2p.c                           |   2 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   2 +-
 drivers/spi/spi-omap2-mcspi.c                      |  30 ++-
 drivers/spi/spi-sh-msiof.c                         |  13 +-
 drivers/spi/spi-tegra210-quad.c                    |  24 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  10 +-
 drivers/thermal/mediatek/lvts_thermal.c            |  16 +-
 drivers/thunderbolt/usb4.c                         |   4 +-
 drivers/tty/serial/8250/8250_omap.c                |  25 +-
 drivers/tty/serial/milbeaut_usio.c                 |   5 +-
 drivers/tty/serial/sh-sci.c                        |  24 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 -
 drivers/ufs/core/ufs-mcq.c                         |   6 -
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/ufs/host/ufs-qcom.c                        |   5 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  21 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   4 +
 drivers/usb/class/usbtmc.c                         |  17 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/usb-acpi.c                        |   2 +
 drivers/usb/gadget/function/f_hid.c                |  12 +-
 drivers/usb/gadget/udc/core.c                      |   2 +-
 drivers/usb/misc/onboard_usb_dev.c                 | 111 ++++++--
 drivers/usb/renesas_usbhs/common.c                 |  50 +++-
 drivers/usb/serial/bus.c                           |   2 +-
 drivers/usb/typec/bus.c                            |   2 +-
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   3 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  91 +++++--
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  79 +++++-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |  14 +-
 drivers/vfio/vfio_iommu_type1.c                    |   2 +-
 drivers/video/backlight/qcom-wled.c                |   6 +-
 drivers/video/fbdev/core/fbcvt.c                   |   2 +-
 drivers/watchdog/exar_wdt.c                        |   2 +-
 drivers/xen/balloon.c                              |  13 +-
 fs/9p/vfs_addr.c                                   |   1 +
 fs/btrfs/extent-io-tree.c                          |   6 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/scrub.c                                   |  34 ++-
 fs/erofs/super.c                                   |  49 +++-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/f2fs.h                                     |  10 +-
 fs/f2fs/gc.c                                       |   3 +
 fs/f2fs/namei.c                                    |  10 +-
 fs/f2fs/segment.h                                  |  43 +--
 fs/f2fs/super.c                                    |   4 +-
 fs/filesystems.c                                   |  14 +-
 fs/gfs2/glock.c                                    |   3 +-
 fs/gfs2/glops.c                                    |   4 +-
 fs/gfs2/incore.h                                   |   9 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/gfs2/meta_io.c                                  |   2 +-
 fs/gfs2/meta_io.h                                  |   4 +-
 fs/gfs2/ops_fstype.c                               |  35 ++-
 fs/gfs2/super.c                                    |  16 +-
 fs/gfs2/sys.c                                      |   1 -
 fs/kernfs/dir.c                                    |   5 +-
 fs/kernfs/file.c                                   |   3 +-
 fs/namespace.c                                     |  25 +-
 fs/nfs/super.c                                     |  19 ++
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/direct.c                                 |   3 +
 fs/ntfs3/index.c                                   |   8 +
 fs/ntfs3/inode.c                                   |   5 +
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/smb/client/cifssmb.c                            |  20 +-
 fs/squashfs/super.c                                |   5 +
 fs/xfs/xfs_discard.c                               |  17 +-
 include/linux/arm_sdei.h                           |   4 +-
 include/linux/bio.h                                |   2 +-
 include/linux/bvec.h                               |   7 +-
 include/linux/coresight.h                          |   2 +-
 include/linux/hid.h                                |   3 +-
 include/linux/ieee80211.h                          |  79 +++++-
 include/linux/mdio.h                               |   5 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |  58 ++++
 include/linux/nvme.h                               |   2 +-
 include/linux/overflow.h                           |  33 ++-
 include/linux/pci-epf.h                            |   3 +
 include/linux/phy.h                                |   5 +-
 include/linux/pm_domain.h                          |   7 +
 include/linux/poison.h                             |   4 +
 include/linux/virtio_vsock.h                       |   1 +
 include/net/bluetooth/hci_core.h                   |   2 +-
 include/net/checksum.h                             |   2 +-
 include/net/netfilter/nft_fib.h                    |   9 +
 include/net/page_pool/types.h                      |   6 +
 include/net/sock.h                                 |   7 +-
 include/sound/hdaudio.h                            |   4 +-
 io_uring/fdinfo.c                                  |  12 +-
 io_uring/io_uring.c                                |   4 +-
 io_uring/register.c                                |   7 +-
 io_uring/sqpoll.c                                  |  43 +--
 io_uring/sqpoll.h                                  |   8 +-
 kernel/bpf/core.c                                  |  29 +-
 kernel/events/core.c                               |  50 +++-
 kernel/power/energy_model.c                        |   4 +
 kernel/power/hibernate.c                           |   5 +
 kernel/power/main.c                                |   3 +-
 kernel/power/power.h                               |   4 +
 kernel/power/wakelock.c                            |   3 +
 kernel/rcu/tree.c                                  |  10 +-
 kernel/rcu/tree.h                                  |   2 +-
 kernel/rcu/tree_stall.h                            |   4 +-
 kernel/sched/core.c                                |  12 +-
 kernel/time/posix-cpu-timers.c                     |   9 +
 kernel/trace/bpf_trace.c                           |   7 +-
 kernel/trace/ring_buffer.c                         |  41 +--
 kernel/trace/trace.h                               |   8 +-
 kernel/trace/trace_events_hist.c                   | 122 +++++++--
 kernel/trace/trace_events_trigger.c                |  20 +-
 lib/iov_iter.c                                     |   2 +-
 lib/kunit/static_stub.c                            |   2 +-
 lib/usercopy_kunit.c                               |   1 +
 mm/page_alloc.c                                    |   8 +-
 net/bluetooth/eir.c                                |  17 +-
 net/bluetooth/eir.h                                |   2 +-
 net/bluetooth/hci_conn.c                           |   2 +
 net/bluetooth/hci_core.c                           |  29 +-
 net/bluetooth/hci_event.c                          |  16 +-
 net/bluetooth/hci_sync.c                           |  76 +++++-
 net/bluetooth/iso.c                                |   9 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bluetooth/mgmt.c                               | 140 +++++-----
 net/bluetooth/mgmt_util.c                          |  51 ++--
 net/bluetooth/mgmt_util.h                          |   8 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  12 +-
 net/core/filter.c                                  |   2 +-
 net/core/netmem_priv.h                             |  33 ++-
 net/core/page_pool.c                               | 108 ++++++--
 net/core/skbuff.c                                  |  16 +-
 net/core/skmsg.c                                   |  53 ++--
 net/core/sock.c                                    |   8 +-
 net/core/utils.c                                   |   4 +-
 net/core/xdp.c                                     |   4 +-
 net/dsa/tag_brcm.c                                 |   2 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |  11 +-
 net/ipv4/udp_offload.c                             |   5 +
 net/ipv6/ila/ila_common.c                          |   6 +-
 net/ipv6/netfilter.c                               |  12 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  17 +-
 net/ipv6/seg6_local.c                              |   6 +-
 net/mac80211/mlme.c                                |   7 +-
 net/mac80211/scan.c                                |  11 +-
 net/ncsi/internal.h                                |  21 +-
 net/ncsi/ncsi-pkt.h                                |  23 +-
 net/ncsi/ncsi-rsp.c                                |  21 +-
 net/netfilter/nf_nat_core.c                        |  12 +-
 net/netfilter/nft_quota.c                          |  20 +-
 net/netfilter/nft_set_pipapo.c                     |  58 +++-
 net/netfilter/nft_set_pipapo_avx2.c                |  21 +-
 net/netfilter/nft_tunnel.c                         |   8 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |   4 +-
 net/netfilter/xt_mark.c                            |   2 +-
 net/netlabel/netlabel_kapi.c                       |   5 +
 net/openvswitch/flow.c                             |   2 +-
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
 net/xfrm/xfrm_device.c                             |   2 -
 net/xfrm/xfrm_state.c                              |   2 -
 rust/kernel/alloc/kvec.rs                          |   3 +
 scripts/gcc-plugins/gcc-common.h                   |  32 +++
 scripts/gcc-plugins/randomize_layout_plugin.c      |  40 +--
 sound/core/seq_device.c                            |   2 +-
 sound/hda/hda_bus_type.c                           |   6 +-
 sound/pci/hda/hda_bind.c                           |   4 +-
 sound/pci/hda/patch_realtek.c                      |  68 ++++-
 sound/soc/apple/mca.c                              |  23 ++
 sound/soc/codecs/hda.c                             |   4 +-
 sound/soc/codecs/tas2764.c                         |   2 +-
 sound/soc/intel/avs/debugfs.c                      |   6 +-
 sound/soc/intel/avs/ipc.c                          |   4 +-
 sound/soc/mediatek/mt8195/mt8195-mt6359.c          |   4 +-
 sound/soc/sof/amd/pci-acp70.c                      |   1 +
 sound/soc/sof/ipc4-pcm.c                           |   3 +-
 sound/soc/ti/omap-hdmi.c                           |   7 +-
 sound/usb/implicit.c                               |   1 +
 tools/arch/x86/kcpuid/kcpuid.c                     |  47 ++--
 tools/arch/x86/lib/x86-opcode-map.txt              |  50 ++--
 tools/bpf/bpftool/cgroup.c                         |   2 +-
 tools/bpf/resolve_btfids/Makefile                  |   2 +-
 tools/include/nolibc/stdlib.h                      |   4 +-
 tools/include/nolibc/types.h                       |   2 +-
 tools/lib/bpf/bpf_core_read.h                      |   6 +
 tools/lib/bpf/libbpf.c                             |  48 ++--
 tools/lib/bpf/linker.c                             |   4 +-
 tools/lib/bpf/nlattr.c                             |  15 +-
 tools/objtool/check.c                              |   3 +-
 tools/perf/Makefile.config                         |   2 +
 tools/perf/Makefile.perf                           |   3 +-
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/builtin-trace.c                         |   9 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |   5 +-
 tools/perf/tests/switch-tracking.c                 |   2 +-
 tools/perf/ui/browsers/hists.c                     |   2 +-
 tools/perf/util/intel-pt.c                         | 205 +++++++++++++-
 tools/perf/util/machine.c                          |   6 +-
 tools/perf/util/symbol-minimal.c                   | 164 +++++------
 tools/perf/util/thread.c                           |   8 +-
 tools/perf/util/thread.h                           |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  41 ++-
 tools/testing/selftests/Makefile                   |   2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   6 +
 tools/testing/selftests/bpf/test_loader.c          |  14 +-
 tools/testing/selftests/cpufreq/cpufreq.sh         |   3 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |  13 +-
 538 files changed, 5609 insertions(+), 3139 deletions(-)


