Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000C62EAE5;
	Thu, 12 Dec 2024 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015646; cv=none; b=b5Yf+pmw5KYtOfsjVyXoKmYzcpndRSu8gvYLNL9mTJGZ2OtnwJYTATW/8tbKF0R6KwsQSPq3zqlpFvftnrTAdHEcsqS8/WVR86AQRmGbJaaHumYa8WcHu+l7D33JVhEN1brDQdAj2S0UvhWMl4XXUwx5rxudd4Wgh8qj/g32GmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015646; c=relaxed/simple;
	bh=Upk4colLOk9iyv+g7uyRtdzYn3Vvy31W6tZLP6KsE9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mIWsXANy4DztXrVAe6DPlpgYDl15RQNFPdIToxZ1O4k0/BJcvS4OXevyx0RwRw6b0/L/7/44WEfd10bAFmB6NM8iZtJgyNYHDj+urO5qd4/yR6xrCuE07pltAlM8UI2ii7TUDYnj3qUEkT4M5FwXlnKB2j4oxr/7YjymwPVXAtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9JSd4FH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9JSd4FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8E4C4CECE;
	Thu, 12 Dec 2024 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015645;
	bh=Upk4colLOk9iyv+g7uyRtdzYn3Vvy31W6tZLP6KsE9Q=;
	h=From:To:Cc:Subject:Date:From;
	b=W9JSd4FHQ2s9h2t9jU04dcGlPgZI3eCBMRSRat1XsV8pnNhpZVEkHNsqFoiDie3Wj
	 rD3HBhbwoxBOcugWJH3ENkWEnA74om6SCcEy+sHlPi98DbwdJQkk4pQuq8SkdTorAi
	 ASuWneneK42flFu6I3LuSXsNBXMKncMw3meWAW58=
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
Subject: [PATCH 6.12 000/466] 6.12.5-rc1 review
Date: Thu, 12 Dec 2024 15:52:49 +0100
Message-ID: <20241212144306.641051666@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.5-rc1
X-KernelTest-Deadline: 2024-12-14T14:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.5 release.
There are 466 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.5-rc1

Thomas Gleixner <tglx@linutronix.de>
    clocksource: Make negative motion detection more robust

Colin Ian King <colin.i.king@gmail.com>
    ALSA: hda/realtek: Fix spelling mistake "Firelfy" -> "Firefly"

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix leak of struct zpci_dev when zpci_add_device() fails

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: parse umc_info or vram_info based on ASIC"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix build error without CONFIG_SND_DEBUG

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework resume handling for display (v2)

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Fix return status of avs_pcm_hw_constraints_init()

Sebastian Ott <sebott@redhat.com>
    net/mlx5: unique names for per device caches

Heming Zhao <heming.zhao@suse.com>
    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

Bingbu Cao <bingbu.cao@intel.com>
    media: ipu6: use the IPU6 DMA mapping APIs to do mapping

Richard Weinberger <richard@nod.at>
    jffs2: Fix rtime decompressor

Kinsey Moore <kinsey.moore@oarcorp.com>
    jffs2: Prevent rtime decompress memory corruption

Nikolay Kuratov <kniv@yandex-team.ru>
    KVM: x86/mmu: Ensure that kvm_release_pfn_clean() takes exact pfn from kvm_faultin_pfn()

Hari Bathini <hbathini@linux.ibm.com>
    selftests/ftrace: adjust offset for kprobe syntax error test

Yishai Hadas <yishaih@nvidia.com>
    vfio/mlx5: Align the page tracking max message size with the device capability

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "unicode: Don't special case ignorable code points"

Damien Le Moal <dlemoal@kernel.org>
    x86: Fix build regression with CONFIG_KEXEC_JUMP enabled

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix to release eprobe when failed to add dyn_event

Haoyu Li <lihaoyu499@gmail.com>
    clk: en7523: Initialize num before accessing hws in en7523_register_clocks()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing snapshot drew unlock when root is dead during swap activation

Qu Wenruo <wqu@suse.com>
    btrfs: fix mount failure due to remount races

David Sterba <dsterba@suse.com>
    btrfs: drop unused parameter data from btrfs_fill_super()

David Sterba <dsterba@suse.com>
    btrfs: drop unused parameter options from open_ctree()

Wander Lairson Costa <wander@redhat.com>
    sched/deadline: Fix warning in migrate_enable for boosted tasks

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Prevent wakeup of ksoftirqd during idle load balance

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy

K Prateek Nayak <kprateek.nayak@amd.com>
    sched/core: Remove the unnecessary need_resched() check in nohz_csd_func()

Josh Don <joshdon@google.com>
    sched: fix warning in sched_setaffinity

Sung Lee <Sung.Lee@amd.com>
    drm/amd/display: Add option to retrieve detile buffer size

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Update Interface to Check UCLK DPM

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/devcoredump: Update handling of xe_force_wake_get return

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/forcewake: Add a helper xe_force_wake_ref_has_domain()

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Copy GuC log prior to dumping

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/devcoredump: Add ASCII85 dump helper function

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/devcoredump: Improve section headings and add tile info

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/devcoredump: Use drm_puts and already cached local variables

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: pltfrm: Dellocate HBA during ufshcd_pltfrm_remove()

Jens Axboe <axboe@kernel.dk>
    io_uring/tctx: work around xa_store() allocation error issue

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    setlocalversion: work around "git describe" performance

Paulo Alcantara <pc@manguebit.com>
    smb: client: don't try following DFS links in cifs_tree_connect()

Zhou Wang <wangzhou1@hisilicon.com>
    irqchip/gicv3-its: Add workaround for hip09 ITS erratum 162100801

Nilay Shroff <nilay@linux.ibm.com>
    Revert "nvme: make keep-alive synchronous operation"

Inochi Amaoto <inochiama@gmail.com>
    serial: 8250_dw: Add Sophgo SG2044 quirk

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    rtc: cmos: avoid taking rtc_lock for extended period of time

Parker Newman <pnewman@connecttech.com>
    misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/prom_init: Fixup missing powermac #size-cells

Uwe Kleine-König <ukleinek@debian.org>
    ASoC: amd: yc: Add quirk for microphone on Lenovo Thinkpad T14s Gen 6 21M1CTO1WW

Xi Ruoyao <xry111@xry111.site>
    MIPS: Loongson64: DTS: Really fix PCIe port nodes for ls7a

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu/vcn: reset fw_shared when VCPU buffers corrupted on vcn v4.0.3

Alex Far <anf1980@gmail.com>
    ASoC: amd: yc: fix internal mic on Redmi G 2022

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: glink: be more precise on orientation-aware ports

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: light: ltr501: Add LTER0303 to the supported devices

Nuno Sa <nuno.sa@analog.com>
    iio: adc: ad7192: properly check spi_get_device_match_data()

Saranya Gopal <saranya.gopal@intel.com>
    usb: typec: ucsi: Do not call ACPI _DSM method for UCSI read operations

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: handle USB Error Interrupt if IOC not set

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: create bounce buffer for problem sglist entries if possible

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: limit usb request length to max 16KB

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: add CI_HDRC_HAS_SHORT_PKT_LIMIT flag

Melody Olvera <quic_molvera@quicinc.com>
    regulator: qcom-rpmh: Update ranges for FTSMPS525

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix case when unmarked clusters intersect with zone

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix warning in ni_fiemap

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix sleeping in atomic context for PREEMPT_RT

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Clean up Asus entries in acpi_quirk_skip_dmi_ids[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 8 A1-840

Chao Yu <chao@kernel.org>
    f2fs: add a sysfs node to limit max read extent count per-inode

Chao Yu <chao@kernel.org>
    f2fs: fix to shrink read extent node in batches

Chao Yu <chao@kernel.org>
    f2fs: print message if fscorrupted was found in f2fs_new_node_page()

Defa Li <defa.li@mediatek.com>
    i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    remoteproc: qcom: pas: enable SAR2130P audio DSP support

Mengyuan Lou <mengyuanlou@net-swift.com>
    PCI: Add ACS quirk for Wangxun FF5xxx NICs

Keith Busch <kbusch@kernel.org>
    PCI: Add 'reset_subordinate' to reset hierarchy below bridge

Mayank Rana <quic_mrana@quicinc.com>
    PCI: starfive: Enable controller runtime PM before probing host bridge

Esther Shimanovich <eshimanovich@chromium.org>
    PCI: Detect and trust built-in Thunderbolt chips

Jian-Hong Pan <jhp@endlessos.org>
    PCI: vmd: Set devices to D0 before enabling PM L1 Substates

Nirmal Patel <nirmal.patel@linux.ntel.com>
    PCI: vmd: Add DID 8086:B06F and 8086:B60B for Intel client SKUs

devi priya <quic_devipriy@quicinc.com>
    PCI: qcom: Add support for IPQ9574

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Mask ring interrupts before ring stop request

Qianqiang Liu <qianqiang.liu@163.com>
    KMSAN: uninit-value in inode_go_dump (5)

Qi Han <hanqi@vivo.com>
    f2fs: fix f2fs_bug_on when uninstalling filesystem call f2fs_evict_inode.

Adam Young <admiyo@os.amperecomputing.com>
    mailbox: pcc: Check before sending MCTP PCC response ACK

Gabriele Monaco <gmonaco@redhat.com>
    verification/dot2: Improve dot parser robustness

furkanonder <furkanonder@protonmail.com>
    tools/rtla: Enhance argument parsing in timerlat_load.py

Tatsuya S <tatsuya.s2862@gmail.com>
    tracing: Fix function name for trampoline

Kees Cook <kees@kernel.org>
    smb: client: memcpy() with surrounding object base address

Yi Yang <yiyang13@huawei.com>
    nvdimm: rectify the illogical code within nd_dax_probe()

Barnabás Czémán <barnabas.czeman@mainlining.org>
    thermal/drivers/qcom/tsens-v1: Add support for MSM8937 tsens

Barnabás Czémán <barnabas.czeman@mainlining.org>
    pinctrl: qcom: spmi-mpp: Add PM8937 compatible

Barnabás Czémán <barnabas.czeman@mainlining.org>
    pinctrl: qcom-pmic-gpio: add support for PM8937

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Don't modify unknown block number in MTIOCGET

Mukesh Ojha <quic_mojha@quicinc.com>
    leds: class: Protect brightness_show() with led_cdev->led_access mutex

Devi Priya <quic_devipriy@quicinc.com>
    clk: qcom: clk-alpha-pll: Add NSS HUAYRA ALPHA PLL support for ipq9574

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8550: enable support for SAR2130P

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: tcsrcc-sm8550: add SAR2130P support

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: rpmh: add support for SAR2130P

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: rcg2: add clk_rcg2_shared_floor_ops

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Prevent NDLP reference count underflow in dev_loss_tmo callback

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check SLI_ACTIVE flag in FDMI cmpl before submitting follow up FDMI

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Call lpfc_sli4_queue_unset() in restart and rmmod paths

Andrii Nakryiko <andrii@kernel.org>
    bpf: put bpf_link's program when link is safe to be deallocated

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/amd: Fix corruption when mapping large pages from 0

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Make DMA mask configuration more flexible

Mukesh Ojha <quic_mojha@quicinc.com>
    pinmux: Use sequential access to access desc->pinmux data

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Limit time with disabled interrupts in rb_check_pages()

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Create all dump files during debugfs initialization

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add cond_resched() for no forced preemption model

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat: Make timerlat_hist_cpu->*_count unsigned long long

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat: Make timerlat_top_cpu->*_count unsigned long long

Jan Stancek <jstancek@redhat.com>
    tools/rtla: fix collision with glibc sched_attr/sched_set_attr

Uros Bizjak <ubizjak@gmail.com>
    tracing: Use atomic64_inc_return() in trace_clock_counter()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    tracing/ftrace: disable preemption in syscall probe

Gabriele Monaco <gmonaco@redhat.com>
    rtla: Fix consistency in getopt_long for timerlat_hist

Esben Haabendal <esben@geanix.com>
    pinctrl: freescale: fix COMPILE_TEST error with PINCTRL_IMX_SCU

Breno Leitao <leitao@debian.org>
    netpoll: Use rcu_access_pointer() in __netpoll_setup

Jakub Kicinski <kuba@kernel.org>
    net/neighbor: clear error in case strict check is not set

Dmitry Antipov <dmantipov@yandex.ru>
    rocker: fix link status detection in rocker_carrier_init()

Jonas Karlman <jonas@kwiboo.se>
    ASoC: hdmi-codec: reorder channel allocation list

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btusb: Add 3 HWIDs for MT7925

Jonathan McCrohan <jmccrohan@gmail.com>
    Bluetooth: btusb: Add new VID/PID 0489/e124 for MT7925

Hao Qin <hao.qin@mediatek.com>
    Bluetooth: btusb: Add new VID/PID 0489/e111 for MT7925

Danil Pylaev <danstiv404@gmail.com>
    Bluetooth: Set quirks for ATS2851

Danil Pylaev <danstiv404@gmail.com>
    Bluetooth: Support new quirks for ATS2851

Danil Pylaev <danstiv404@gmail.com>
    Bluetooth: Add new quirks for ATS2851

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not checking skb length on hci_acldata_packet

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Use disable_delayed_work_sync

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btusb: Add USB HW IDs for MT7920/MT7925

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add RTL8852BE device 0489:e123 to device tables

Markus Elfring <elfring@users.sourceforge.net>
    Bluetooth: hci_conn: Reduce hci_conn_drop() calls in two functions

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i2c: i801: Add support for Intel Panther Lake

Andrew Lunn <andrew@lunn.ch>
    dsa: qca8k: Use nested lock to avoid splat

Dmitry Kandybka <d.kandybka@gmail.com>
    mptcp: fix possible integer overflow in mptcp_reset_tout_timer

Hou Tao <houtao1@huawei.com>
    bpf: Call free_htab_elem() after htab_unlock_bucket()

Norbert van Bolhuis <nvbolhuis@gmail.com>
    wifi: brcmfmac: Fix oops due to NULL pointer dereference in brcmf_sdiod_sglist_rw()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    wifi: ipw2x00: libipw_rx_any(): fix bad alignment

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: set the right AMDGPU sg segment limitation

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Make mic volume workarounds globally applicable

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio-net: fix overflow inside virtnet_rq_alloc

Victor Zhao <Victor.Zhao@amd.com>
    drm/amdgpu: skip amdgpu_device_cache_pci_state under sriov

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Prune Invalid Modes For HDMI Output

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: parse umc_info or vram_info based on ASIC

Ausef Yousof <Ausef.Yousof@amd.com>
    drm/amd/display: Remove hw w/a toggle if on DP2/HPO

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Add ABGR2101010 support

Dmitry Safonov <0x7f454c46@gmail.com>
    net/tcp: Add missing lockdep annotations for TCP-AO hlist traversals

Aleksandr Mishin <amishin@t-argos.ru>
    fsl/fman: Validate cell-index value obtained from Device Tree

Nihar Chaithanya <niharchaithanya@gmail.com>
    jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: fix array-index-out-of-bounds in jfs_readdir

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: fix shift-out-of-bounds in dbSplit

Ghanshyam Agrawal <ghanshyam1898@gmail.com>
    jfs: array-index-out-of-bounds fix in dtReadFirst

Levi Yun <yeoreum.yun@arm.com>
    dma-debug: fix a possible deadlock on radix_lock

Gang Yan <yangang@kylinos.cn>
    mptcp: annotate data-races around subflow->fully_established

Leo Ma <hanghong.ma@amd.com>
    drm/amd/display: Fix underflow when playing 8K video in full screen mode

Mac Chiang <mac.chiang@intel.com>
    ASoC: Intel: soc-acpi-intel-arl-match: Add rt722 and rt1320 support

Mac Chiang <mac.chiang@intel.com>
    ASoC: sdw_utils: Add quirk to exclude amplifier function

Lang Yu <lang.yu@amd.com>
    drm/amdgpu: refine error handling in amdgpu_ttm_tt_pin_userptr

Donald Hunter <donald.hunter@gmail.com>
    netlink: specs: Add missing bitset attrs to ethtool spec

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: Dereference the ATCS ACPI buffer

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for vega20_ih

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/gfx9: Add cleaner shader for GFX9.4.2

Leo Chen <leo.chen@amd.com>
    drm/amd/display: Adding array index check to prevent memory corruption

Philipp Stanner <pstanner@redhat.com>
    drm/sched: memset() 'job' in drm_sched_job_init()

Abhishek Chauhan <quic_abchauha@quicinc.com>
    net: stmmac: Programming sequence for VLAN packets with split header

Shengyu Qu <wiagn233@outlook.com>
    net: sfp: change quirks for Alcatel Lucent G-010S-P

Manikandan Muralidharan <manikandan.m@microchip.com>
    drm/panel: simple: Add Microchip AC69T88A LVDS Display panel

Badal Nilawar <badal.nilawar@intel.com>
    drm/xe/guc/ct: Flush g2h worker in case of g2h response timeout

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add quirks for some new Lenovo laptops

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Add quirk for cs42l43 system using host DMICs

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: sdw_utils: Add a quirk to allow the cs42l43 mic DAI to be ignored

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: sdw_utils: Add support for exclusion DAI quirks

Leon Hwang <leon.hwang@linux.dev>
    bpf: Prevent tailcall infinite loop caused by freplace

Amir Goldstein <amir73il@gmail.com>
    fanotify: allow reporting errors on failure to open fd

Rosen Penev <rosenp@gmail.com>
    wifi: ath5k: add PCI ID for Arcadyan devices

Rosen Penev <rosenp@gmail.com>
    wifi: ath5k: add PCI ID for SX76X

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath10k: avoid NULL pointer error during sdio remove

Ignat Korchagin <ignat@cloudflare.com>
    net: inet6: do not leave a dangling sk pointer in inet6_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: inet: do not leave a dangling sk pointer in inet_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: ieee802154: do not leave a dangling sk pointer in ieee802154_create()

Ignat Korchagin <ignat@cloudflare.com>
    net: af_can: do not leave a dangling sk pointer in can_create()

Ignat Korchagin <ignat@cloudflare.com>
    Bluetooth: RFCOMM: avoid leaving dangling sk pointer in rfcomm_sock_alloc()

Ignat Korchagin <ignat@cloudflare.com>
    Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()

Ignat Korchagin <ignat@cloudflare.com>
    af_packet: avoid erroring out after sock_init_data() in packet_create()

Elena Salomatkina <esalomatkina@ispras.ru>
    net/sched: cbs: Fix integer overflow in cbs_set_port_rate()

Simon Horman <horms@kernel.org>
    net: ethernet: fs_enet: Use %pa to format resource_size_t

Simon Horman <horms@kernel.org>
    net: fec_mpc52xx_phy: Use %pa to format resource_size_t

Leo Chen <leo.chen@amd.com>
    drm/amd/display: Full exit out of IPS2 when all allow signals have been cleared

Jeffrey Hugo <quic_jhugo@quicinc.com>
    accel/qaic: Add AIC080 support

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath12k: fix atomic calls in ath12k_mac_op_set_bitrate_mask()

Zhu Jun <zhujun2@cmss.chinamobile.com>
    samples/bpf: Fix a resource leak

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't apply UDP padding quirk on RTL8126A

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Use codec SSID matching for Lenovo devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Use the new codec SSID matching

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Use own quirk lookup helper

Brahmajit Das <brahmajit.xyz@gmail.com>
    drm/display: Fix building with GCC 15

Gustavo Sousa <gustavo.sousa@intel.com>
    drm/xe/xe3: Add initial set of workarounds

Shekhar Chauhan <shekhar.chauhan@intel.com>
    drm/xe/ptl: L3bank mask is not available on the media GT

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: disable SG displays on cyan skillfish

Zhongwei <Zhongwei.Zhang@amd.com>
    drm/amd/display: Fix garbage or black screen when resetting otg

Fudongwang <Fudong.Wang@amd.com>
    drm/amd/display: skip disable CRTC in seemless bootup case

Alexander Aring <aahringo@redhat.com>
    dlm: fix possible lkb_resource null dereference

Balamurugan C <balamurugan.c@intel.com>
    ASoC: Intel: sof_rt5682: Add HDMI-In capture with rt5682 support for MTL.

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix out-of-bounds access in 'dcn21_link_encoder_create'

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: check return value of ieee80211_probereq_get() for RNR

Liao Chen <liaochen4@huawei.com>
    drm/mcde: Enable module autoloading

Liao Chen <liaochen4@huawei.com>
    drm/bridge: it6505: Enable module autoloading

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO GEEK

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO Founder edition

Joaquín Ignacio Aramendía <samsagax@gmail.com>
    drm: panel-orientation-quirks: Add quirk for AYA NEO 2 model

Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
    drm/xe/pciid: Add new PCI id for ARL

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: use ieee80211_purge_tx_queue() to purge TX skb

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe/pciids: Add PVC's PCI device ID macros

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/vc4: hvs: Set AXI panic modes for the HVS

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: Avoid log spam for audio start failure

Jani Nikula <jani.nikula@intel.com>
    drm/xe/pciids: separate ARL and MTL PCI IDs

Jani Nikula <jani.nikula@intel.com>
    drm/xe/pciids: separate RPL-U and RPL-P PCI IDs

Callahan Kovacs <callahankovacs@gmail.com>
    HID: magicmouse: Apple Magic Trackpad 2 USB-C driver support

Changwoo Min <multics69@gmail.com>
    sched_ext: add a missing rcu_read_lock/unlock pair at scx_select_cpu_dfl()

Reinette Chatre <reinette.chatre@intel.com>
    selftests/resctrl: Protect against array overflow when reading strings

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    regmap: maple: Provide lockdep (sub)class for maple tree's internal lock

Marek Vasut <marex@denx.de>
    soc: imx8m: Probe the SoC driver as platform driver

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    firmware: qcom: scm: Allow QSEECOM on Dell XPS 13 9345

Peng Fan <peng.fan@nxp.com>
    mmc: sdhci-esdhc-imx: enable quirks SDHCI_QUIRK_NO_LED

Keita Aihara <keita.aihara@sony.com>
    mmc: core: Add SD card quirk for broken poweroff notification

Rohan Barar <rohan.barar@gmail.com>
    media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Force UVC version to 1.0a for 0408:4033

David Given <dg@cowlark.com>
    media: uvcvideo: Add a quirk for the Kaiweets KTI-W02 infrared camera

Dmitry Perchanov <dmitry.perchanov@intel.com>
    media: uvcvideo: RealSense D421 Depth module metadata

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: pd-mapper: Add QCM6490 PD maps

Maya Matuszczyk <maccraft123mc@gmail.com>
    firmware: qcom: scm: Allow QSEECOM on Lenovo Yoga Slim 7x

Benjamin Tissoires <bentiss@kernel.org>
    HID: add per device quirk to force bind to hid-generic

Konrad Dybcio <quic_kdybcio@quicinc.com>
    soc: qcom: llcc: Use designated initializers for LLC settings

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Adjust type of scldiv

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: free irqs that are still requested when the chip is being removed

Thomas Gleixner <tglx@linutronix.de>
    timekeeping: Always check for negative motion

Stephen Rothwell <sfr@canb.auug.org.au>
    iio: magnetometer: fix if () scoped_guard() formatting

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    cleanup: Adjust scoped_guard() macros to avoid potential warning

Breno Leitao <leitao@debian.org>
    perf/x86/amd: Warn only on new bits set

Jonathan Denose <jdenose@google.com>
    ACPI: video: force native for Apple MacbookPro11,2 and Air7,2

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add adev NULL check to acpi_quirk_skip_serdev_enumeration()

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Make UART skip quirks work on PCI UARTs without an UID

Sarah Maedel <sarah.maedel@hetzner-cloud.de>
    hwmon: (nct6775) Add 665-ACE/600M-CL to ASUS WMI monitoring list

Marco Elver <elver@google.com>
    kcsan: Turn report_filterlist_lock into a raw_spinlock

Lukas Wunner <lukas@wunner.de>
    crypto: ecdsa - Avoid signed integer overflow on signature decoding

Brian Foster <bfoster@redhat.com>
    ext4: partial zero eof block on unaligned inode size extension

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't leak pipe fds in pac.exec_sign_all()

Boris Burkov <boris@bur.io>
    btrfs: do not clear read-only when adding sprout device

Qu Wenruo <wqu@suse.com>
    btrfs: canonicalize the device path before adding it

Qu Wenruo <wqu@suse.com>
    btrfs: avoid unnecessary device path update for the same device

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't take dev_replace rwsem on task already holding it

Damien Le Moal <dlemoal@kernel.org>
    block: RCU protect disk->conv_zones_bitmap

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Handle CPU hotplug remove during sampling

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Log fp-stress child startup errors to stdout

Christian Brauner <brauner@kernel.org>
    epoll: annotate racy check

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Ignore RID for isolated VFs

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Use topology ID for multi-function devices

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Sort PCI functions prior to creating virtual busses

Gary Guo <gary@garyguo.net>
    rust: enable arbitrary_self_types and remove `Receiver`

Mike Rapoport (Microsoft) <rppt@kernel.org>
    memblock: allow zero threshold in validate_numa_converage()

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: pltfrm: Drop PM runtime reference count after ufshcd_remove()

Kalesh Singh <kaleshsingh@google.com>
    mm: respect mmap hint address when aligning for THP

Andrii Nakryiko <andrii@kernel.org>
    mm: fix vrealloc()'s KASAN poisoning logic

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: open-code page_folio() in dump_page()

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: open-code PageTail in folio_flags() and const_folio_flags()

John Sperbeck <jsperbeck@google.com>
    mm: memcg: declare do_memsw_account inline

Akinobu Mita <akinobu.mita@gmail.com>
    mm/damon: fix order of arguments in damos_before_apply tracepoint

David Woodhouse <dwmw@amazon.co.uk>
    x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables

Fernando Fernandez Mancera <ffmancera@riseup.net>
    x86/cpu/topology: Remove limit of CPUs due to disabled IO/APIC

David Hildenbrand <david@redhat.com>
    mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM

John Hubbard <jhubbard@nvidia.com>
    mm/gup: handle NULL pages in unpin_user_pages()

Jared Kangas <jkangas@redhat.com>
    kasan: make report_lock a raw spinlock

Adrian Huang <ahuang12@lenovo.com>
    sched/numa: fix memory leak due to the overwritten vma->numab_state

Kees Cook <kees@kernel.org>
    lib: stackinit: hide never-taken branch from compiler

Marco Elver <elver@google.com>
    stackdepot: fix stack_depot_save_flags() in NMI context

Wengang Wang <wen.gang.wang@oracle.com>
    ocfs2: update seq_file index in ocfs2_dlm_seq_next

Len Brown <len.brown@intel.com>
    x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Further prevent card detect during shutdown

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-pci: Add DMI quirk for missing CD GPIO on Vexia Edu Atla 10 tablet

Marc Zyngier <maz@kernel.org>
    arch_numa: Restore nid checks before registering a memblock with a node

Cosmin Tanislav <demonsingur@gmail.com>
    regmap: detach regmap from dev on regmap_exit

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: fix OOB map writes when deleting elements

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    dma-fence: Use kernel's sort for merging fences

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    dma-fence: Fix reference leak on fence merge failure path

Christian König <christian.koenig@amd.com>
    dma-buf: fix dma_fence_array_signaled v4

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    bpf: fix OOB devmap writes when deleting elements

David Woodhouse <dwmw@amazon.co.uk>
    x86/kexec: Restore GDT on return from ::preserve_context kexec

Thomas Gleixner <tglx@linutronix.de>
    modpost: Add .irqentry.text to OTHER_SECTIONS

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp5.2: do a posting read when flushing HDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp7.0: do a posting read when flushing HDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp5.0: do a posting read when flushing HDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp4.0: do a posting read when flushing HDP

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp6.0: do a posting read when flushing HDP

Peterson Guo <peterson.guo@amd.com>
    drm/amd/display: Add a left edge pixel if in YCbCr422 or YCbCr420 and odm

Dillon Varone <dillon.varone@amd.com>
    drm/amd/display: Limit VTotal range to max hw cap minus fp

Lo-an Chen <lo-an.chen@amd.com>
    drm/amd/display: Correct prefetch calculation

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix resetting msg rx state after topology removal

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Verify request type in the corresponding down message reply

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/pm: fix and simplify workload handling

Sreekant Somasekharan <sreekant.somasekharan@amd.com>
    drm/amdkfd: add MEC version that supports no PCIe atomics for GFX12

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix MST sideband message body length check

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: hard-code cacheline for gc943,gc944

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    x86/cacheinfo: Delete global num_cache_leaves

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    cacheinfo: Allocate memory during CPU hotplug if not done from the primary CPU

Mark Brown <broonie@kernel.org>
    selftest: hugetlb_dio: fix test naming

Maximilian Heyne <mheyne@amazon.de>
    selftests/damon: add _damon_sysfs.py to TEST_FILES

Shengjiu Wang <shengjiu.wang@nxp.com>
    pmdomain: imx: gpcv2: Adjust delay after power up handshake

Jan Kara <jack@suse.cz>
    Revert "readahead: properly shorten readahead when falling back to do_page_cache_ra()"

Liequan Che <cheliequan@inspur.com>
    bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again

Bernd Schubert <bschubert@ddn.com>
    io_uring: Change res2 parameter type in io_uring_cmd_done

Steve French <stfrench@microsoft.com>
    smb3.1.1: fix posix mounts to older servers

Ralph Boehme <slow@samba.org>
    fs/smb/client: cifs_prime_dcache() for SMB3 POSIX reparse points

Ralph Boehme <slow@samba.org>
    fs/smb/client: Implement new SMB3 POSIX type

Ralph Boehme <slow@samba.org>
    fs/smb/client: avoid querying SMB2_OP_QUERY_WSL_EA for SMB3 POSIX

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Add missing post notify for power mode change

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: pltfrm: Disable runtime PM during removal of glue drivers

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: qcom: Only free platform MSIs when ESI is enabled

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: core: Cancel RTC work during ufshcd_remove()

Gwendal Grignou <gwendal@chromium.org>
    scsi: ufs: core: sysfs: Prevent div by zero

Saurav Kashyap <skashyap@marvell.com>
    scsi: qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free on unload

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Supported speed displayed incorrectly for VPorts

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix NVMe and NPIV connect issue

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix abort in bsg timeout

Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>
    ALSA: hda/realtek: Add support for Samsung Galaxy Book3 360 (NP730QFG)

Nazar Bilinskyi <nbilinskyi@gmail.com>
    ALSA: hda/realtek: Enable mute and micmute LED on HP ProBook 430 G8

Marie Ramlow <me@nycode.dev>
    ALSA: usb-audio: add mixer mapping for Corsair HS80

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: fix micmute LEDs don't work on HP Laptops

Asahi Lina <lina@asahilina.net>
    ALSA: usb-audio: Add extra PID for RME Digiface USB

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix a DMA to stack memory bug

Mark Rutland <mark.rutland@arm.com>
    arm64: ptrace: fix partial SETREGSET for NT_ARM_POE

Mark Rutland <mark.rutland@arm.com>
    arm64: ptrace: fix partial SETREGSET for NT_ARM_FPMR

Mark Rutland <mark.rutland@arm.com>
    arm64: ptrace: fix partial SETREGSET for NT_ARM_TAGGED_ADDR_CTRL

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs

Yang Shi <yang@os.amperecomputing.com>
    arm64: mm: Fix zone_dma_limit calculation

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Fix out_fput in iommufd_fault_alloc()

Shradha Gupta <shradhagupta@linux.microsoft.com>
    net :mana :Request a V2 response version for MANA_QUERY_GF_STAT

Kuan-Wei Chiu <visitorckw@gmail.com>
    tracing: Fix cmp_entries_dup() to respect sort() comparison rules

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_get_tef_len(): work around erratum DS80000789E 6.

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_set_termination(): allow sleeping GPIOs

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    watchdog: rti: of: honor timeout-sec property

Jordy Zomer <jordyzomer@google.com>
    ksmbd: fix Out-of-Bounds Write in ksmbd_vfs_stream_write

Jordy Zomer <jordyzomer@google.com>
    ksmbd: fix Out-of-Bounds Read in ksmbd_vfs_stream_read

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: KVM: Protect kvm_check_requests() with SRCU

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Add architecture specific huge_pte_clear()

WangYuli <wangyuli@uniontech.com>
    HID: wacom: fix when get product name maybe null pointer

Kenny Levinsen <kl@kl.wtf>
    HID: i2c-hid: Revert to using power commands to wake on resume

Miguel Ojeda <ojeda@kernel.org>
    rust: allow `clippy::needless_lifetimes`

Sean Christopherson <seanjc@google.com>
    x86/CPU/AMD: WARN when setting EFER.AUTOIBRS if and only if the WRMSR fails

Hou Tao <houtao1@huawei.com>
    bpf: Fix exact match conditions in trie_get_next_key()

Hou Tao <houtao1@huawei.com>
    bpf: Handle in-place update for full LPM trie correctly

Hou Tao <houtao1@huawei.com>
    bpf: Remove unnecessary kfree(im_node) in lpm_trie_update_elem

Hou Tao <houtao1@huawei.com>
    bpf: Handle BPF_EXIST and BPF_NOEXIST for LPM trie

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential race in cifs_put_tcon()

Jakob Hauser <jahau@rocketmail.com>
    iio: magnetometer: yas530: use signed integer type for clamp limits

Randy Dunlap <rdunlap@infradead.org>
    scatterlist: fix incorrect func name in kernel-doc

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ocfs2: free inode when ocfs2_get_init_inode() fails

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Enable Performance Counters before clearing them

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt8188-mt6359: Remove hardcoded dmic codec

John Garry <john.g.garry@oracle.com>
    scsi: scsi_debug: Fix hrtimer support for ndelay

Suraj Sonawane <surajsonawane0215@gmail.com>
    scsi: sg: Fix slab-use-after-free read in sg_release()

Chunguang.xu <chunguang.xu@shopee.com>
    nvme-rdma: unquiesce admin_q before destroy it

Chunguang.xu <chunguang.xu@shopee.com>
    nvme-tcp: fix the memleak while create new ctrl failed

Maurizio Lombardi <mlombard@redhat.com>
    nvme-fabrics: handle zero MAXCMD without closing the connection

Tao Lyu <tao.lyu@epfl.ch>
    bpf: Fix narrow scalar spill onto 64-bit spilled scalar slots

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Don't mark STACK_INVALID as STACK_MISC in mark_stack_slot_misc

Will Deacon <will@kernel.org>
    drivers/virt: pkvm: Don't fail ioremap() call if MMIO_GUARD fails

Geert Uytterhoeven <geert+renesas@glider.be>
    irqchip/stm32mp-exti: CONFIG_STM32MP_EXTI should not default to y when compile-testing

Tao Lyu <tao.lyu@epfl.ch>
    bpf: Ensure reg is PTR_TO_STACK in process_iter_arg

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    x86/pkeys: Ensure updated PKRU value is XRSTOR'd

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    x86/pkeys: Change caller of update_pkru_in_sigframe()

Christoph Hellwig <hch@lst.de>
    nvme: don't apply NVME_QUIRK_DEALLOCATE_ZEROES when DSM is not supported

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Fix error path in pm_genpd_init() when ida alloc fails

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Add missing put_device()

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: SOF: ipc3-topology: fix resource leaks in sof_ipc3_widget_setup_comp_dai()

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: SOF: ipc3-topology: Convert the topology pin index to ALH dai index

Pei Xiao <xiaopei01@kylinos.cn>
    spi: mpc52xx: Add cancel_work_sync before module remove

Björn Töpel <bjorn@rivosinc.com>
    tools: Override makefile ARCH variable if defined, but empty

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Notify xrun for low-latency mode

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Fix seq port updates per FB info notify

Zijian Zhang <zijianzhang@bytedance.com>
    tcp_bpf: Fix the sk_mem_uncharge logic in tcp_bpf_sendmsg

Pei Xiao <xiaopei01@kylinos.cn>
    drm/sti: Add __iomem for mixer_dbg_mxn's parameter

Amir Mohammadi <amirmohammadi1999.am@gmail.com>
    bpftool: fix potential NULL pointer dereferencing in prog_dump()

Larysa Zaremba <larysa.zaremba@intel.com>
    xsk: always clear DMA mapping information when unmapping the pool

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Invoke proto::close on close()

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Fix poll() missing a queue

Ziqi Chen <quic_ziqichen@quicinc.com>
    scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Always initialize the UIC done completion

Chris Park <chris.park@amd.com>
    drm/amd/display: Ignore scalar validation failure if pipe is phantom

Yihan Zhu <Yihan.Zhu@amd.com>
    drm/amd/display: calculate final viewport before TAP optimization

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix dynamic address leak when 'assigned-address' is present

Frank Li <Frank.Li@nxp.com>
    i3c: master: Extend address status bit to 4 and add I3C_ADDR_SLOT_EXT_DESIRED

Frank Li <Frank.Li@nxp.com>
    i3c: master: Replace hard code 2 with macro I3C_ADDR_SLOT_STATUS_BITS

Chao Yu <chao@kernel.org>
    f2fs: fix to requery extent which cross boundary of inquiry

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to adjust appropriate length for fiemap

Chao Yu <chao@kernel.org>
    f2fs: clean up w/ F2FS_{BLK_TO_BYTES,BTYES_TO_BLK}

Marcelo Dalmas <marcelo.dalmas@ge.com>
    ntp: Remove invalid cast in time offset math

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: clear IDLE flag in mark_idle()

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not mark idle slots that cannot be idle

Avri Altman <avri.altman@wdc.com>
    mmc: core: Use GFP_NOIO in ACMD22

Avri Altman <avri.altman@wdc.com>
    mmc: core: Adjust ACMD22 to SDUC

Avri Altman <avri.altman@wdc.com>
    mmc: sd: SDUC Support Recognition

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix MMC_CAP2_CRYPTO flag setting

Rosen Penev <rosenp@gmail.com>
    mmc: mtk-sd: fix devm_clk_get_optional usage

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix error handle of probe function

Rosen Penev <rosenp@gmail.com>
    mmc: mtk-sd: use devm_mmc_alloc_host

Charles Han <hanchunchao@inspur.com>
    gpio: grgpio: Add NULL check in grgpio_probe

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: grgpio: use a helper variable to store the address of ofdev->dev

Eric Dumazet <edumazet@google.com>
    net: avoid potential UAF in default_operstate()

Konstantin Shkolnyy <kshk@linux.ibm.com>
    vsock/test: fix parameter types in SO_VM_SOCKETS_* calls

Konstantin Shkolnyy <kshk@linux.ibm.com>
    vsock/test: fix failures due to wrong SO_RCVLOWAT parameter

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove workaround to avoid syndrome for internal port

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5e: SD, Use correct mdev to build channel param

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: HWS: Properly set bwc queue locks lock classes

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: HWS: Fix memory leak in mlx5hws_definer_calc_layout

Eric Dumazet <edumazet@google.com>
    geneve: do not assume mac header is set in geneve_xmit_skb()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_acl_flex_keys: Use correct key block on Spectrum-4

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mlxsw: spectrum_acl_flex_keys: Constify struct mlxsw_afk_element_inst

Kory Maincent <kory.maincent@bootlin.com>
    ethtool: Fix wrong mod state in case of verbose and no_mask bitset

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_hash: skip duplicated elements pending gc run

Phil Sutter <phil@nwl.cc>
    netfilter: ipset: Hold module reference while requesting a module

Xin Long <lucien.xin@gmail.com>
    net: sched: fix erspan_opt settings in cls_flower

Fernando Fernandez Mancera <ffmancera@riseup.net>
    Revert "udp: avoid calling sock_def_readable() if possible"

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_inner: incorrect percpu area handling under softirq

Yuan Can <yuancan@huawei.com>
    igb: Fix potential invalid memory access in igb_init_module()

Tore Amundsen <tore@amundsen.org>
    ixgbe: Correct BASE-BX10 compliance code

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: downgrade logging of unsupported VF API version to debug

Jacob Keller <jacob.e.keller@intel.com>
    ixgbevf: stop attempting IPSEC offload on Mailbox API 1.5

Joshua Hay <joshua.a.hay@intel.com>
    idpf: set completion tag for "empty" bufs associated with a packet

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix VLAN pruning in switchdev mode

Przemyslaw Korba <przemyslaw.korba@intel.com>
    ice: fix PHY timestamp extraction for ETH56G

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    ice: fix PHY Clock Recovery availability check

Eric Dumazet <edumazet@google.com>
    net: hsr: must allocate more bytes for RedBox support

Louis Leseur <louis.leseur@gmail.com>
    net/qed: allow old cards not supporting "num_images" to work

Wen Gu <guwen@linux.alibaba.com>
    net/smc: fix LGR and link use-after-free issue

Wen Gu <guwen@linux.alibaba.com>
    net/smc: initialize close_work early to avoid warning

Kuniyuki Iwashima <kuniyu@amazon.com>
    tipc: Fix use-after-free of kernel socket in cleanup_bearer().

Ivan Solodovnikov <solodovnikov.ia@phystech.edu>
    dccp: Fix memory leak in dccp_feat_change_recv

Jiri Wiesner <jwiesner@suse.de>
    net/ipv6: release expired exception dst cached in socket

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: microchip: Reset LAN88xx PHY to ensure clean link state on LAN7800/7850

Armin Wolf <W_Armin@gmx.de>
    platform/x86: asus-wmi: Ignore return value when writing thermal policy

Dmitry Antipov <dmantipov@yandex.ru>
    can: j1939: j1939_session_new(): fix skb reference counting

Eric Dumazet <edumazet@google.com>
    ipv6: avoid possible NULL deref in modify_prefix_route()

Dong Chenchen <dongchenchen2@huawei.com>
    net: Fix icmp host relookup triggering ip_rt_bug

Daniel Xu <dxu@dxuuu.xyz>
    bnxt_en: ethtool: Supply ntuple rss context action

Eric Dumazet <edumazet@google.com>
    net: hsr: avoid potential out-of-bound access in fill_frame_info()

Martin Ottens <martin.ottens@fau.de>
    net/sched: tbf: correct backlog statistic for GSO packets

Ajay Kaher <ajay.kaher@broadcom.com>
    ptp: Add error handling for adjfine callback in ptp_clock_adjtime

Wei Fang <wei.fang@nxp.com>
    net: enetc: Do not configure preemptible TCs if SIs do not support

Maximilian Heyne <mheyne@amazon.de>
    selftests: hid: fix typo and exit code

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level

Dmitry Antipov <dmantipov@yandex.ru>
    netfilter: x_tables: fix LED ID check in led_tg_check()

Jinghao Jia <jinghao7@illinois.edu>
    ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: f81604: f81604_handle_can_bus_errors(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: ems_usb: ems_usb_rx_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sja1000: sja1000_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: hi311x: hi3110_can_ist(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: ifi_canfd: ifi_canfd_handle_lec_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: m_can: m_can_handle_lec_err(): fix {rx,tx}_errors statistics

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: hi311x: hi3110_can_ist(): fix potential use-after-free

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: sun4i_can: sun4i_can_err(): call can_change_state() even if cf is NULL

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    can: c_can: c_can_handle_bus_err(): update statistics if skb allocation fails

Alexander Kozhinov <ak.alexander.kozhinov@gmail.com>
    can: gs_usb: add usb endpoint address detection at driver probe step

Yassine Oudjana <y.oudjana@protonmail.com>
    watchdog: mediatek: Make sure system reset gets asserted in mtk_wdt_restart()

Nick Chan <towinchenmi@gmail.com>
    watchdog: apple: Actually flush writes after requesting watchdog restart

Harini T <harini.t@amd.com>
    watchdog: xilinx_wwdt: Calculate max_hw_heartbeat_ms using clock frequency

Oleksandr Ocheretnyi <oocheret@cisco.com>
    iTCO_wdt: mask NMI_NOW bit for update_no_reboot_bit() call


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-pci            |   11 +
 Documentation/ABI/testing/sysfs-fs-f2fs            |    6 +
 Documentation/accel/qaic/aic080.rst                |   14 +
 Documentation/accel/qaic/index.rst                 |    1 +
 Documentation/arch/arm64/silicon-errata.rst        |    2 +
 Documentation/i2c/busses/i2c-i801.rst              |    1 +
 Documentation/netlink/specs/ethtool.yaml           |    7 +-
 Makefile                                           |    5 +-
 arch/arm64/Kconfig                                 |   11 +
 arch/arm64/kernel/ptrace.c                         |   10 +-
 arch/arm64/mm/context.c                            |    4 +-
 arch/arm64/mm/init.c                               |   17 +-
 arch/loongarch/include/asm/hugetlb.h               |   10 +
 arch/loongarch/kvm/vcpu.c                          |    4 +-
 arch/loongarch/mm/tlb.c                            |    2 +-
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          |   73 +-
 arch/powerpc/kernel/prom_init.c                    |   29 +-
 arch/s390/include/asm/pci.h                        |   14 +-
 arch/s390/include/asm/pci_clp.h                    |    8 +-
 arch/s390/kernel/perf_cpum_sf.c                    |    4 +-
 arch/s390/pci/pci.c                                |   88 +-
 arch/s390/pci/pci_bus.c                            |   48 +-
 arch/s390/pci/pci_clp.c                            |   17 +-
 arch/s390/pci/pci_event.c                          |   19 +-
 arch/x86/Kconfig                                   |    1 -
 arch/x86/events/amd/core.c                         |   10 +-
 arch/x86/include/asm/pgtable_types.h               |    8 +-
 arch/x86/kernel/cpu/amd.c                          |    2 +-
 arch/x86/kernel/cpu/cacheinfo.c                    |   43 +-
 arch/x86/kernel/cpu/intel.c                        |    4 +-
 arch/x86/kernel/cpu/topology.c                     |    6 +-
 arch/x86/kernel/fpu/signal.c                       |   20 +-
 arch/x86/kernel/fpu/xstate.h                       |   27 +-
 arch/x86/kernel/relocate_kernel_64.S               |    8 +
 arch/x86/kvm/mmu/mmu.c                             |   10 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    5 +-
 arch/x86/mm/ident_map.c                            |    6 +-
 arch/x86/mm/pti.c                                  |    2 +-
 arch/x86/pci/acpi.c                                |  119 +
 block/blk-zoned.c                                  |   43 +-
 crypto/ecdsa.c                                     |   19 +-
 drivers/accel/qaic/qaic_drv.c                      |    4 +-
 drivers/acpi/video_detect.c                        |   16 +
 drivers/acpi/x86/utils.c                           |   85 +-
 drivers/base/arch_numa.c                           |    4 +
 drivers/base/cacheinfo.c                           |   14 +-
 drivers/base/regmap/internal.h                     |    1 +
 drivers/base/regmap/regcache-maple.c               |    3 +
 drivers/base/regmap/regmap.c                       |   13 +
 drivers/block/zram/zram_drv.c                      |   29 +-
 drivers/bluetooth/btusb.c                          |   26 +
 drivers/clk/clk-en7523.c                           |    4 +-
 drivers/clk/qcom/Kconfig                           |    4 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   11 +
 drivers/clk/qcom/clk-alpha-pll.h                   |    1 +
 drivers/clk/qcom/clk-rcg.h                         |    1 +
 drivers/clk/qcom/clk-rcg2.c                        |   48 +-
 drivers/clk/qcom/clk-rpmh.c                        |   13 +
 drivers/clk/qcom/dispcc-sm8550.c                   |   18 +-
 drivers/clk/qcom/tcsrcc-sm8550.c                   |   18 +-
 drivers/dma-buf/dma-fence-array.c                  |   28 +-
 drivers/dma-buf/dma-fence-unwrap.c                 |  126 +-
 drivers/firmware/qcom/qcom_scm.c                   |    2 +
 drivers/gpio/gpio-grgpio.c                         |   26 +-
 drivers/gpio/gpiolib.c                             |   41 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   48 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |    5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   12 +
 .../gpu/drm/amd/amdgpu/gfx_v9_0_cleaner_shader.h   |   44 +-
 .../drm/amd/amdgpu/gfx_v9_4_2_cleaner_shader.asm   |  153 +
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c              |   12 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c              |    7 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c              |    6 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c              |    6 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c              |    6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   30 +-
 drivers/gpu/drm/amd/amdgpu/vega20_ih.c             |   27 +
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |    6 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |    3 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   25 +-
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |   17 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   27 +-
 drivers/gpu/drm/amd/display/dc/core/dc_debug.c     |   40 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   57 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |    6 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |    3 +
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |    6 +-
 .../dc/dio/dcn314/dcn314_dio_stream_encoder.c      |   10 +
 .../drm/amd/display/dc/dml2/display_mode_core.c    |    1 +
 .../dc/dml2/dml21/dml21_translation_helper.c       |   29 +-
 .../dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c  |    1 +
 .../drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c  |   20 +-
 drivers/gpu/drm/amd/display/dc/inc/core_status.h   |    2 +
 drivers/gpu/drm/amd/display/dc/inc/core_types.h    |    5 +
 .../amd/display/dc/resource/dcn20/dcn20_resource.c |   23 +
 .../amd/display/dc/resource/dcn21/dcn21_resource.c |    2 +-
 .../amd/display/dc/resource/dcn30/dcn30_resource.c |    1 +
 .../display/dc/resource/dcn302/dcn302_resource.c   |    1 +
 .../display/dc/resource/dcn303/dcn303_resource.c   |    1 +
 .../amd/display/dc/resource/dcn31/dcn31_resource.c |    7 +
 .../amd/display/dc/resource/dcn31/dcn31_resource.h |    3 +
 .../display/dc/resource/dcn314/dcn314_resource.c   |    1 +
 .../display/dc/resource/dcn315/dcn315_resource.c   |    7 +
 .../display/dc/resource/dcn316/dcn316_resource.c   |    1 +
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |    1 +
 .../display/dc/resource/dcn321/dcn321_resource.c   |    1 +
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |    2 +
 .../display/dc/resource/dcn351/dcn351_resource.c   |    2 +
 .../display/dc/resource/dcn401/dcn401_resource.c   |   18 +
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h    |    3 +-
 .../drm/amd/display/modules/freesync/freesync.c    |   13 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |    6 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  148 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   15 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |  190 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |  181 +-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  182 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   41 +-
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c    |   43 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  169 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  152 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  172 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   25 +
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h             |    4 +
 drivers/gpu/drm/bridge/ite-it6505.c                |    1 +
 drivers/gpu/drm/display/drm_dp_dual_mode_helper.c  |    4 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   55 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   18 +
 drivers/gpu/drm/drm_panic.c                        |   10 +
 drivers/gpu/drm/mcde/mcde_drv.c                    |    1 +
 drivers/gpu/drm/panel/panel-simple.c               |   28 +
 drivers/gpu/drm/radeon/r600_cs.c                   |    2 +-
 drivers/gpu/drm/scheduler/sched_main.c             |    8 +
 drivers/gpu/drm/sti/sti_mixer.c                    |    2 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |    2 +-
 drivers/gpu/drm/vc4/vc4_hvs.c                      |   11 +
 drivers/gpu/drm/xe/regs/xe_engine_regs.h           |    1 +
 drivers/gpu/drm/xe/regs/xe_gt_regs.h               |    3 +
 drivers/gpu/drm/xe/xe_devcoredump.c                |  146 +-
 drivers/gpu/drm/xe/xe_devcoredump.h                |    6 +
 drivers/gpu/drm/xe/xe_devcoredump_types.h          |    3 +-
 drivers/gpu/drm/xe/xe_device.c                     |    1 +
 drivers/gpu/drm/xe/xe_force_wake.h                 |   16 +
 drivers/gpu/drm/xe/xe_gt_topology.c                |   14 +
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   18 +
 drivers/gpu/drm/xe/xe_guc_log.c                    |   40 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |    2 +-
 drivers/gpu/drm/xe/xe_hw_engine.c                  |    1 -
 drivers/gpu/drm/xe/xe_pci.c                        |    2 +
 drivers/gpu/drm/xe/xe_query.c                      |   42 +-
 drivers/gpu/drm/xe/xe_wa.c                         |   47 +
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |    2 +
 drivers/hid/hid-core.c                             |    5 +-
 drivers/hid/hid-generic.c                          |    3 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-magicmouse.c                       |   56 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   20 +-
 drivers/hid/wacom_sys.c                            |    3 +-
 drivers/hwmon/nct6775-platform.c                   |    2 +
 drivers/i2c/busses/Kconfig                         |    1 +
 drivers/i2c/busses/i2c-i801.c                      |    6 +
 drivers/i3c/master.c                               |   85 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |    2 +-
 drivers/iio/adc/ad7192.c                           |    3 +
 drivers/iio/light/ltr501.c                         |    2 +
 drivers/iio/magnetometer/af8133j.c                 |    3 +-
 drivers/iio/magnetometer/yamaha-yas530.c           |   13 +-
 drivers/iommu/amd/io_pgtable.c                     |   11 +-
 drivers/iommu/iommufd/fault.c                      |    2 -
 drivers/irqchip/Kconfig                            |    2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   50 +-
 drivers/leds/led-class.c                           |   14 +-
 drivers/mailbox/pcc.c                              |   61 +-
 drivers/md/bcache/super.c                          |    2 +-
 drivers/media/pci/intel/ipu6/Kconfig               |    2 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-queue.c     |   66 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-queue.h     |    1 +
 drivers/media/pci/intel/ipu6/ipu6-isys.c           |   19 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |    2 +
 drivers/media/usb/uvc/uvc_driver.c                 |   31 +
 drivers/misc/eeprom/eeprom_93cx6.c                 |   10 +
 drivers/mmc/core/block.c                           |   26 +-
 drivers/mmc/core/bus.c                             |    6 +-
 drivers/mmc/core/card.h                            |   10 +
 drivers/mmc/core/core.c                            |    3 +
 drivers/mmc/core/quirks.h                          |    9 +
 drivers/mmc/core/sd.c                              |   30 +-
 drivers/mmc/core/sd.h                              |    2 +-
 drivers/mmc/core/sdio.c                            |    2 +-
 drivers/mmc/host/mtk-sd.c                          |   64 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    6 +
 drivers/mmc/host/sdhci-pci-core.c                  |   72 +
 drivers/mmc/host/sdhci-pci.h                       |    1 +
 drivers/net/can/c_can/c_can_main.c                 |   26 +-
 drivers/net/can/dev/dev.c                          |    2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   58 +-
 drivers/net/can/m_can/m_can.c                      |   33 +-
 drivers/net/can/sja1000/sja1000.c                  |   65 +-
 drivers/net/can/spi/hi311x.c                       |   48 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   29 +-
 drivers/net/can/sun4i_can.c                        |   22 +-
 drivers/net/can/usb/ems_usb.c                      |   58 +-
 drivers/net/can/usb/f81604.c                       |   10 +-
 drivers/net/can/usb/gs_usb.c                       |   25 +-
 drivers/net/dsa/qca/qca8k-8xxx.c                   |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    8 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    3 +
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |    1 -
 drivers/net/ethernet/freescale/fman/fman.h         |    3 +
 drivers/net/ethernet/freescale/fman/mac.c          |    5 +
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |    2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   25 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |    8 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |    3 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |    5 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |    1 +
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h    |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h       |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |    1 -
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   32 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    7 +-
 .../mlx5/core/steering/hws/mlx5hws_bwc_complex.c   |    2 +
 .../mellanox/mlx5/core/steering/hws/mlx5hws_send.c |    1 +
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c   |    6 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h   |    2 +-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c        |   72 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |    1 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   14 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |    5 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |    5 +
 drivers/net/geneve.c                               |    2 +-
 drivers/net/phy/microchip.c                        |   21 +
 drivers/net/phy/sfp.c                              |    3 +-
 drivers/net/virtio_net.c                           |   12 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |    6 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   18 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |    6 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |    5 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |    3 +
 drivers/nvdimm/dax_devs.c                          |    4 +-
 drivers/nvdimm/nd.h                                |    7 +
 drivers/nvme/host/core.c                           |   25 +-
 drivers/nvme/host/rdma.c                           |    8 +-
 drivers/nvme/host/tcp.c                            |    2 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |    1 +
 drivers/pci/controller/plda/pcie-starfive.c        |   10 +-
 drivers/pci/controller/vmd.c                       |   17 +-
 drivers/pci/pci-sysfs.c                            |   26 +
 drivers/pci/pci.c                                  |    2 +-
 drivers/pci/pci.h                                  |    1 +
 drivers/pci/probe.c                                |   30 +-
 drivers/pci/quirks.c                               |   15 +-
 drivers/pinctrl/core.c                             |    3 +
 drivers/pinctrl/core.h                             |    1 +
 drivers/pinctrl/freescale/Kconfig                  |    2 +-
 drivers/pinctrl/pinmux.c                           |  173 +-
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           |    2 +
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            |    1 +
 drivers/platform/x86/asus-wmi.c                    |   11 +-
 drivers/pmdomain/core.c                            |   37 +-
 drivers/pmdomain/imx/gpcv2.c                       |    2 +-
 drivers/ptp/ptp_clock.c                            |    3 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   83 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |    1 +
 drivers/rtc/rtc-cmos.c                             |   37 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  100 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   21 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   36 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |   41 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |  124 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |    1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   15 +-
 drivers/scsi/scsi_debug.c                          |    2 +-
 drivers/scsi/sg.c                                  |    2 +-
 drivers/scsi/st.c                                  |   31 +-
 drivers/soc/imx/soc-imx8m.c                        |  107 +-
 drivers/soc/qcom/llcc-qcom.c                       | 2644 +++++++-
 drivers/soc/qcom/qcom_pd_mapper.c                  |    1 +
 drivers/spi/spi-fsl-lpspi.c                        |    7 +-
 drivers/spi/spi-mpc52xx.c                          |    1 +
 drivers/thermal/qcom/tsens-v1.c                    |   21 +-
 drivers/thermal/qcom/tsens.c                       |    3 +
 drivers/thermal/qcom/tsens.h                       |    2 +-
 drivers/tty/serial/8250/8250_dw.c                  |    5 +-
 drivers/ufs/core/ufs-sysfs.c                       |    6 +
 drivers/ufs/core/ufs_bsg.c                         |    2 +-
 drivers/ufs/core/ufshcd-priv.h                     |    1 +
 drivers/ufs/core/ufshcd.c                          |   59 +-
 drivers/ufs/host/cdns-pltfrm.c                     |    4 +-
 drivers/ufs/host/tc-dwc-g210-pltfrm.c              |    5 +-
 drivers/ufs/host/ufs-exynos.c                      |    3 +-
 drivers/ufs/host/ufs-hisi.c                        |    4 +-
 drivers/ufs/host/ufs-mediatek.c                    |    5 +-
 drivers/ufs/host/ufs-qcom.c                        |    7 +-
 drivers/ufs/host/ufs-renesas.c                     |   13 +-
 drivers/ufs/host/ufs-sprd.c                        |    5 +-
 drivers/ufs/host/ufshcd-pltfrm.c                   |   16 +
 drivers/ufs/host/ufshcd-pltfrm.h                   |    1 +
 drivers/usb/chipidea/ci.h                          |    2 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |    1 +
 drivers/usb/chipidea/core.c                        |    2 +
 drivers/usb/chipidea/udc.c                         |  156 +-
 drivers/usb/chipidea/udc.h                         |    2 +
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |   56 +-
 drivers/usb/typec/ucsi/ucsi_glink.c                |   10 +-
 drivers/vfio/pci/mlx5/cmd.c                        |   47 +-
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c      |    6 +-
 drivers/watchdog/apple_wdt.c                       |    2 +-
 drivers/watchdog/iTCO_wdt.c                        |   21 +-
 drivers/watchdog/mtk_wdt.c                         |    6 +
 drivers/watchdog/rti_wdt.c                         |    3 +-
 drivers/watchdog/xilinx_wwdt.c                     |   75 +-
 fs/btrfs/dev-replace.c                             |    2 +
 fs/btrfs/disk-io.c                                 |    3 +-
 fs/btrfs/disk-io.h                                 |    3 +-
 fs/btrfs/fs.h                                      |    2 +
 fs/btrfs/inode.c                                   |    1 +
 fs/btrfs/super.c                                   |   73 +-
 fs/btrfs/volumes.c                                 |  137 +-
 fs/dlm/lock.c                                      |   10 +-
 fs/eventpoll.c                                     |    6 +-
 fs/ext4/extents.c                                  |    7 +-
 fs/ext4/inode.c                                    |   53 +-
 fs/f2fs/data.c                                     |   82 +-
 fs/f2fs/extent_cache.c                             |   74 +-
 fs/f2fs/f2fs.h                                     |    4 +
 fs/f2fs/inode.c                                    |    4 +-
 fs/f2fs/node.c                                     |    7 +-
 fs/f2fs/sysfs.c                                    |   10 +
 fs/gfs2/super.c                                    |    2 +
 fs/jffs2/compr_rtime.c                             |    3 +
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/jfs/jfs_dtree.c                                 |   15 +
 fs/nilfs2/dir.c                                    |    2 +-
 fs/notify/fanotify/fanotify_user.c                 |   85 +-
 fs/ntfs3/attrib.c                                  |    9 +-
 fs/ntfs3/frecord.c                                 |  103 +-
 fs/ntfs3/ntfs_fs.h                                 |    3 +-
 fs/ntfs3/run.c                                     |   40 +-
 fs/ocfs2/dlmglue.c                                 |    1 +
 fs/ocfs2/localalloc.c                              |   19 -
 fs/ocfs2/namei.c                                   |    4 +-
 fs/smb/client/cifsproto.h                          |    1 +
 fs/smb/client/cifssmb.c                            |    2 +-
 fs/smb/client/connect.c                            |    4 +-
 fs/smb/client/dfs.c                                |  188 +-
 fs/smb/client/inode.c                              |   94 +-
 fs/smb/client/readdir.c                            |   54 +-
 fs/smb/client/reparse.c                            |   90 +-
 fs/smb/client/smb2inode.c                          |    3 +-
 fs/smb/server/smb2pdu.c                            |    6 +
 fs/unicode/mkutf8data.c                            |   70 +
 fs/unicode/utf8data.c_shipped                      | 6703 ++++++++++----------
 include/acpi/pcc.h                                 |    7 +
 include/drm/display/drm_dp_mst_helper.h            |    7 +
 include/drm/intel/xe_pciids.h                      |   31 +-
 include/linux/blkdev.h                             |    2 +-
 include/linux/bpf.h                                |   17 +-
 include/linux/cleanup.h                            |   48 +-
 include/linux/clocksource.h                        |    2 +
 include/linux/eeprom_93cx6.h                       |   11 +
 include/linux/eventpoll.h                          |    2 +-
 include/linux/f2fs_fs.h                            |    1 +
 include/linux/fanotify.h                           |    1 +
 include/linux/hid.h                                |    2 +
 include/linux/i3c/master.h                         |    9 +-
 include/linux/io_uring/cmd.h                       |    4 +-
 include/linux/leds.h                               |    2 +-
 include/linux/mmc/card.h                           |    3 +-
 include/linux/mmc/sd.h                             |    1 +
 include/linux/page-flags.h                         |    4 +-
 include/linux/pci.h                                |    6 +
 include/linux/scatterlist.h                        |    2 +-
 include/linux/stackdepot.h                         |    6 +-
 include/linux/usb/chipidea.h                       |    1 +
 include/net/bluetooth/hci.h                        |   14 +
 include/net/bluetooth/hci_core.h                   |   10 +-
 include/net/netfilter/nf_tables_core.h             |    1 +
 include/net/tcp_ao.h                               |    3 +-
 include/sound/soc_sdw_utils.h                      |    2 +
 include/trace/events/damon.h                       |    2 +-
 include/trace/trace_events.h                       |   36 +-
 include/uapi/drm/xe_drm.h                          |    4 +-
 include/uapi/linux/fanotify.h                      |    1 +
 include/ufs/ufshcd.h                               |   19 +-
 io_uring/tctx.c                                    |   13 +-
 io_uring/uring_cmd.c                               |    2 +-
 kernel/bpf/arraymap.c                              |   26 +-
 kernel/bpf/core.c                                  |    1 +
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/hashtab.c                               |   56 +-
 kernel/bpf/lpm_trie.c                              |   55 +-
 kernel/bpf/syscall.c                               |   29 +-
 kernel/bpf/trampoline.c                            |   47 +-
 kernel/bpf/verifier.c                              |   15 +-
 kernel/dma/debug.c                                 |    8 +-
 kernel/kcsan/debugfs.c                             |   74 +-
 kernel/sched/core.c                                |    4 +-
 kernel/sched/deadline.c                            |    1 +
 kernel/sched/ext.c                                 |    9 +
 kernel/sched/fair.c                                |   14 +-
 kernel/sched/syscalls.c                            |    2 +-
 kernel/time/Kconfig                                |    5 -
 kernel/time/clocksource.c                          |   11 +-
 kernel/time/ntp.c                                  |    2 +-
 kernel/time/timekeeping.c                          |    6 +-
 kernel/time/timekeeping_internal.h                 |   15 +-
 kernel/trace/ring_buffer.c                         |   98 +-
 kernel/trace/trace.c                               |   33 +-
 kernel/trace/trace.h                               |    7 +
 kernel/trace/trace_clock.c                         |    2 +-
 kernel/trace/trace_eprobe.c                        |    5 +
 kernel/trace/trace_output.c                        |    4 +
 kernel/trace/trace_syscalls.c                      |   12 +
 kernel/trace/tracing_map.c                         |    6 +-
 lib/stackdepot.c                                   |   10 +-
 lib/stackinit_kunit.c                              |    1 +
 mm/debug.c                                         |    7 +-
 mm/gup.c                                           |   11 +-
 mm/kasan/report.c                                  |    6 +-
 mm/memblock.c                                      |    4 +-
 mm/memcontrol-v1.h                                 |    2 +-
 mm/mempolicy.c                                     |    4 +
 mm/mmap.c                                          |    1 +
 mm/readahead.c                                     |    5 +-
 mm/vmalloc.c                                       |    3 +-
 net/bluetooth/hci_conn.c                           |   19 +-
 net/bluetooth/hci_core.c                           |   13 +-
 net/bluetooth/hci_event.c                          |    7 +
 net/bluetooth/hci_sync.c                           |    9 +-
 net/bluetooth/l2cap_sock.c                         |    1 +
 net/bluetooth/rfcomm/sock.c                        |   10 +-
 net/can/af_can.c                                   |    1 +
 net/can/j1939/transport.c                          |    2 +-
 net/core/link_watch.c                              |    7 +-
 net/core/neighbour.c                               |    1 +
 net/core/netpoll.c                                 |    2 +-
 net/dccp/feat.c                                    |    6 +-
 net/ethtool/bitset.c                               |   48 +-
 net/hsr/hsr_device.c                               |   19 +-
 net/hsr/hsr_forward.c                              |    2 +
 net/ieee802154/socket.c                            |   12 +-
 net/ipv4/af_inet.c                                 |   22 +-
 net/ipv4/icmp.c                                    |    3 +
 net/ipv4/tcp_ao.c                                  |   42 +-
 net/ipv4/tcp_bpf.c                                 |   11 +-
 net/ipv4/tcp_ipv4.c                                |    3 +-
 net/ipv4/udp.c                                     |   14 +-
 net/ipv6/addrconf.c                                |   13 +-
 net/ipv6/af_inet6.c                                |   22 +-
 net/ipv6/route.c                                   |    6 +-
 net/ipv6/tcp_ipv6.c                                |    4 +-
 net/mptcp/diag.c                                   |    2 +-
 net/mptcp/options.c                                |    4 +-
 net/mptcp/protocol.c                               |    6 +-
 net/mptcp/protocol.h                               |    6 +-
 net/mptcp/subflow.c                                |    4 +-
 net/netfilter/ipset/ip_set_core.c                  |    5 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    4 +-
 net/netfilter/nft_inner.c                          |   59 +-
 net/netfilter/nft_set_hash.c                       |   16 +
 net/netfilter/nft_socket.c                         |    2 +-
 net/netfilter/xt_LED.c                             |    4 +-
 net/packet/af_packet.c                             |   12 +-
 net/sched/cls_flower.c                             |    5 +-
 net/sched/sch_cbs.c                                |    2 +-
 net/sched/sch_tbf.c                                |   18 +-
 net/smc/af_smc.c                                   |    6 +-
 net/tipc/udp_media.c                               |    2 +-
 net/vmw_vsock/af_vsock.c                           |   70 +-
 net/xdp/xsk_buff_pool.c                            |    5 +-
 net/xdp/xskmap.c                                   |    2 +-
 rust/kernel/lib.rs                                 |    2 +-
 rust/kernel/list/arc.rs                            |    3 -
 rust/kernel/sync/arc.rs                            |    6 -
 samples/bpf/test_cgrp2_sock.c                      |    4 +-
 scripts/Makefile.build                             |    2 +-
 scripts/mod/modpost.c                              |    2 +-
 scripts/setlocalversion                            |   54 +-
 sound/core/seq/seq_ump_client.c                    |    6 +-
 sound/pci/hda/hda_auto_parser.c                    |   61 +-
 sound/pci/hda/hda_local.h                          |   28 +-
 sound/pci/hda/patch_analog.c                       |    6 +-
 sound/pci/hda/patch_cirrus.c                       |    8 +-
 sound/pci/hda/patch_conexant.c                     |   36 +-
 sound/pci/hda/patch_cs8409-tables.c                |    2 +-
 sound/pci/hda/patch_cs8409.h                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |  126 +-
 sound/pci/hda/patch_sigmatel.c                     |   22 +-
 sound/pci/hda/patch_via.c                          |    2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   14 +
 sound/soc/codecs/hdmi-codec.c                      |  144 +-
 sound/soc/intel/avs/pcm.c                          |    2 +-
 sound/soc/intel/boards/sof_rt5682.c                |    7 +
 sound/soc/intel/boards/sof_sdw.c                   |   41 +
 sound/soc/intel/common/soc-acpi-intel-arl-match.c  |   63 +
 sound/soc/intel/common/soc-acpi-intel-mtl-match.c  |    7 +
 sound/soc/mediatek/mt8188/mt8188-mt6359.c          |    4 +-
 sound/soc/sdw_utils/soc_sdw_utils.c                |    7 +-
 sound/soc/sof/ipc3-topology.c                      |   31 +-
 sound/usb/endpoint.c                               |   14 +-
 sound/usb/mixer.c                                  |   58 +-
 sound/usb/mixer_maps.c                             |   10 +
 sound/usb/mixer_quirks.c                           |    1 +
 sound/usb/quirks-table.h                           |  341 +-
 sound/usb/quirks.c                                 |   75 +-
 sound/usb/usbaudio.h                               |    4 +
 tools/bpf/bpftool/prog.c                           |   17 +-
 tools/scripts/Makefile.arch                        |    4 +-
 tools/testing/selftests/arm64/fp/fp-stress.c       |   15 +-
 tools/testing/selftests/arm64/pauth/pac.c          |    3 +
 .../selftests/bpf/progs/verifier_bits_iter.c       |    4 +-
 tools/testing/selftests/damon/Makefile             |    2 +-
 .../ftrace/test.d/kprobe/kprobe_syntax_errors.tc   |    2 +-
 tools/testing/selftests/hid/run-hid-tools-tests.sh |   16 +-
 tools/testing/selftests/mm/hugetlb_dio.c           |   14 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |    4 +-
 tools/testing/selftests/resctrl/resctrlfs.c        |    2 +-
 tools/testing/vsock/vsock_perf.c                   |   10 +-
 tools/testing/vsock/vsock_test.c                   |   26 +-
 tools/tracing/rtla/sample/timerlat_load.py         |    9 +-
 tools/tracing/rtla/src/timerlat_hist.c             |   20 +-
 tools/tracing/rtla/src/timerlat_top.c              |    8 +-
 tools/tracing/rtla/src/utils.c                     |    4 +-
 tools/tracing/rtla/src/utils.h                     |    2 +
 tools/verification/dot2/automata.py                |   18 +-
 539 files changed, 13136 insertions(+), 7041 deletions(-)


