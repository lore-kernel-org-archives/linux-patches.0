Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD47B3218C4;
	Tue, 26 Aug 2025 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756206789; cv=none; b=I4N4sJV6VXabWsZgW9FF9/enccQxDsZ1nltp2PkBM5HgLBnqLfO7JKRIiD7Jf895auh7OvmSYQD1oZv/LVbq7n+sScOJ1cKniMfd9LkVjtFxuiLN0W+REqKDk2+8j2u7b04QRj98tDj33nommGY16kqA6Ouln3qXMO44TaraMpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756206789; c=relaxed/simple;
	bh=HbKVwV4CRrEb2eLwqVSBEnJXqLECKkAYWrefi7twEuI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Dmj9eyWbONOGSugvm962XeT8BzGJY8m+opOIk70KzCERAD/eJDlQ96Ysu5qTjCa3beUCtZHVCEtWgW4ke1Klrpe9QKQzQxn/PQJTcCB4aspGGzrCghYtgw3asUDjtqF1doTgFd7FnlYC5h7X7IV6fqr2oLAEdArwkkv2PKXkM/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxefNM58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxefNM58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78688C4CEF1;
	Tue, 26 Aug 2025 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756206789;
	bh=HbKVwV4CRrEb2eLwqVSBEnJXqLECKkAYWrefi7twEuI=;
	h=From:To:Cc:Subject:Date:From;
	b=qxefNM58Ihyw1zNqgtW7PIM4rZl46kPJVfkTz57kooSTK78NiOdL6VMRLd45kUQmz
	 jSsppHKs3oOkXxN9nFnBysXBQp5cKl50XtNdsLnJW5ZdxQ/7qXuny8GvIqffGbwfbl
	 HWulJuB+oq6IEaegvazcioBvzZdKN12ss9DnXxVo=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 000/457] 6.16.4-rc1 review
Date: Tue, 26 Aug 2025 13:04:44 +0200
Message-ID: <20250826110937.289866482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.4-rc1
X-KernelTest-Deadline: 2025-08-28T11:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.4 release.
There are 457 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.4-rc1

Christoph Manszewski <christoph.manszewski@intel.com>
    drm/xe: Fix vm_bind_ioctl double free bug

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe: Move ASID allocation and user PT BO tracking into xe_vm_create

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: don't leak dst refcount for loopback packets

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Enable limited access during lockdown

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Avoid unnecessary ioctl registration in debugfs

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation

Armen Ratner <armeng@nvidia.com>
    net/mlx5e: Preserve shared buffer capacity during headroom updates

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Query FW for buffer ownership

Oren Sidi <osidi@nvidia.com>
    net/mlx5: Add IFC bits and enums for buf_ownership

Daniel Jurgens <danielj@nvidia.com>
    net/mlx5: Base ECVF devlink port attrs from 0

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Skip overlap check for SPI field

Nilay Shroff <nilay@linux.ibm.com>
    block: avoid cpu_hotplug_lock depedency on freeze_lock

Nilay Shroff <nilay@linux.ibm.com>
    block: skip q->rq_qos check in rq_qos_done_bio()

Nilay Shroff <nilay@linux.ibm.com>
    block: decrement block_rq_qos static key in rq_qos_del()

Ming Lei <ming.lei@redhat.com>
    blk-mq: fix lockdep warning in __blk_mq_update_nr_hw_queues

Nilay Shroff <nilay@linux.ibm.com>
    block: fix potential deadlock while running nr_hw_queue update

Nilay Shroff <nilay@linux.ibm.com>
    block: fix lockdep warning caused by lock dependency in elv_iosched_store

Nilay Shroff <nilay@linux.ibm.com>
    block: move elevator queue allocation logic into blk_mq_init_sched

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: ppe: Do not invalid PPE entries in case of SW hash collision

Hangbin Liu <liuhangbin@gmail.com>
    bonding: send LACPDUs periodically in passive mode after receiving partner's LACPDU

Hangbin Liu <liuhangbin@gmail.com>
    bonding: update LACP activity flag after setting lacp_active

Dewei Meng <mengdewei@cqsoftware.com.cn>
    ALSA: timer: fix ida_free call while not allocated

William Liu <will@willsroot.io>
    net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate

William Liu <will@willsroot.io>
    net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix KSZ9477 HSR port setup issue

ValdikSS <iam@valdikss.org.ru>
    igc: fix disabling L1.2 PCI-E link substate on I226 on init

Jason Xing <kernelxing@tencent.com>
    ixgbe: xsk: resolve the negative overflow of budget in ixgbe_xmit_zc

Song Gao <gaosong@loongson.cn>
    LoongArch: KVM: Use kvm_get_vcpu_by_id() instead of kvm_get_vcpu()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Use standard bitops API with eiointc

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Do not map lowcore with identity mapping

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: cs35l56: Remove SoundWire Clock Divider workaround for CS35L63

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Handle new algorithms IDs for CS35L63

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: cs35l56: Update Firmware Addresses for CS35L63 for production silicon

Kanglong Wang <wangkanglong@loongson.cn>
    LoongArch: Optimize module load time by optimizing PLT/GOT counting

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Pass annotate-tablejump option if LTO is enabled

Tiezhu Yang <yangtiezhu@loongson.cn>
    objtool/LoongArch: Get table size correctly if LTO is enabled

Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
    microchip: lan865x: fix missing Timer Increment config for Rev.B0/B1

Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
    microchip: lan865x: fix missing netif_start_queue() call on device open

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: CT: Use the correct counter offset

Alex Vesker <valex@nvidia.com>
    net/mlx5: HWS, Fix table creation UID

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, fix complex rules rehash error flow

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, fix bad parameter in CQ creation

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix UAF on smcsk after smc_listen_out()

Yao Zi <ziyao@disroot.org>
    net: stmmac: thead: Enable TX clock before MAC initialization

Jordan Rhee <jordanrhee@google.com>
    gve: prevent ethtool ops after shutdown

Yuichiro Tsuji <yuichtsu@amazon.com>
    net: usb: asix_devices: Fix PHY address mask in MDIO bus initialization

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix timestamping for vsc8584

David Howells <dhowells@redhat.com>
    cifs: Fix oops due to uninitialised variable

Dan Carpenter <dan.carpenter@linaro.org>
    regulator: tps65219: regulator: tps65219: Fix error codes in probe()

Piotr Piórkowski <piotr.piorkowski@intel.com>
    drm/xe: Assign ioctl xe file handler to vm in xe_vm_create

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix HSR and switch offload Enablement during firwmare reload.

Qingfang Deng <dqfext@gmail.com>
    ppp: fix race conditions in ppp_fill_forward_path

Qingfang Deng <dqfext@gmail.com>
    net: ethernet: mtk_ppe: add RCU lock around dev_fill_forward_path

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: ufs-qcom: Fix ESI null pointer dereference

Bao D. Nguyen <quic_nguyenb@quicinc.com>
    scsi: ufs: ufs-qcom: Update esi_vec_mask for HW major version >= 6

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix IRQ lock inversion for the SCSI host lock

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix lockdep warning during rmmod

Minhong He <heminhong@kylinos.cn>
    ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add

Jakub Ramaseuski <jramaseu@redhat.com>
    net: gso: Forbid IPv6 TSO with extensions on devices with only IPV6_CSUM

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't print errors for nonexistent connectors

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Adjust DCE 8-10 clock, don't overclock by 15%

Chenyuan Yang <chenyuan0y@gmail.com>
    drm/amd/display: Add null pointer check in mod_hdcp_hdcp1_create_session()

Peng Fan <peng.fan@nxp.com>
    regulator: pca9450: Use devm_register_sys_off_handler

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix size validation in convert_chmap_v3()

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix dp and vga cannot show together

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix rare monitors cannot display problem

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix the hibmc loaded failed bug

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix irq_request()'s irq name variable is local

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix the i2c device resource leak when vdac init failed

Miguel Ojeda <ojeda@kernel.org>
    rust: alloc: fix `rusttest` by providing `Cmalloc::aligned_layout` too

Zheng Qixing <zhengqixing@huawei.com>
    md: fix sync_action incorrect display during resync

Zheng Qixing <zhengqixing@huawei.com>
    md: add helper rdev_needs_recovery()

Li Nan <linan122@huawei.com>
    md: rename recovery_cp to resync_offset

Miguel Ojeda <ojeda@kernel.org>
    drm: nova-drm: fix 32-bit arm build

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum: Forward packets with an IPv4 link-local source IP

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not accounting for BIS/CIS/PA links separately

Yang Li <yang.li@amlogic.com>
    Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections

Sergey Shtylyov <s.shtylyov@omp.ru>
    Bluetooth: hci_conn: do return error from hci_enhanced_setup_sync()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: fix MTU for BN == 0 in CIS Established

Yang Li <yang.li@amlogic.com>
    Bluetooth: hci_sync: Prevent unintended PA sync when SID is 0xFF

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix using ll_privacy_capable for current settings

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix using {cis,bis}_capable for current settings

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btmtk: Fix wait_on_bit_timeout interruption during shutdown

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix scan state after PA Sync has been established

Kees Cook <kees@kernel.org>
    iommu/amd: Avoid stack buffer overflow from kernel cmdline

Dan Carpenter <dan.carpenter@linaro.org>
    scsi: qla4xxx: Prevent a potential error pointer dereference

Justin Lai <justinlai0215@realtek.com>
    rtase: Fix Rx descriptor CRC error bit definition

William Liu <will@willsroot.io>
    net/sched: Fix backlog accounting in qdisc_dequeue_internal

Wang Liang <wangliang74@huawei.com>
    net: bridge: fix soft lockup in br_multicast_query_expired()

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Fix RX skb ring management in DMAengine mode

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix dip entries leak on devices newer than hip09

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    RDMA/core: Free pfn_list with appropriate kvfree call

Anantha Prabhu <anantha.prabhu@broadcom.com>
    RDMA/bnxt_re: Fix to initialize the PBL array

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix a possible memory leak in the driver

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix to remove workload check in SRQ limit path

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix to do SRQ armena by default

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix querying wrong SCC context for DIP algorithm

Boshi Yu <boshiyu@linux.alibaba.com>
    RDMA/erdma: Fix unset QPN of GSI QP

Boshi Yu <boshiyu@linux.alibaba.com>
    RDMA/erdma: Fix ignored return value of init_kernel_qp

Suma Hegde <suma.hegde@amd.com>
    platform/x86/amd/hsmp: Ensure sock->metric_tbl_addr is non-NULL

Jocelyn Falempe <jfalempe@redhat.com>
    drm/panic: Add a u64 divide by 10 for arm32

Danilo Krummrich <dakr@kernel.org>
    rust: drm: don't pass the address of drm::Device to drm_dev_put()

Danilo Krummrich <dakr@kernel.org>
    rust: drm: remove pin annotations from drm::Device

Danilo Krummrich <dakr@kernel.org>
    rust: drm: ensure kmalloc() compatible Layout

Danilo Krummrich <dakr@kernel.org>
    rust: alloc: replace aligned_size() with Kmalloc::aligned_layout()

Nitin Gote <nitin.r.gote@intel.com>
    iosys-map: Fix undefined behavior in iosys_map_clear()

José Expósito <jose.exposito89@gmail.com>
    drm/tests: Fix drm_test_fb_xrgb8888_to_xrgb2101010() on big-endian

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tests: Do not use drm_fb_blit() in format-helper tests

José Expósito <jose.exposito89@gmail.com>
    drm/tests: Fix endian warning

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix a partition error with CPU hotplug

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Use static_branch_enable_cpuslocked() on cpusets_insane_config_key

Fanhua Li <lifanhua5@huawei.com>
    drm/nouveau/nvif: Fix potential memory leak in nvif_vmm_ctor().

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: fix calculating of ECC OOB regions' properties

Stefan Wahren <wahrenst@gmx.net>
    spi: spi-fsl-lpspi: Clamp too high speed_hz

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: use correct CW_PER_PAGE value for OOB write

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: change invalid data error to -EBUSY

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: imu: inv_icm42600: Convert to uXX and sXX integer types

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_icm42600: use = { } instead of memset()

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: prevent from unwanted interface name changes

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    devlink: let driver opt out of automatic phys_port_name generation

Sven Eckelmann <sven@narfation.org>
    i2c: rtl9300: Add missing count byte for SMBus Block Ops

Sven Eckelmann <sven@narfation.org>
    i2c: rtl9300: Increase timeout for transfer polling

Harshal Gohel <hg@simonwunderlich.de>
    i2c: rtl9300: Fix multi-byte I2C write

Alex Guo <alexguo1023@gmail.com>
    i2c: rtl9300: Fix out-of-bounds bug in rtl9300_i2c_smbus_xfer

Tianxiang Peng <txpeng@tencent.com>
    x86/cpu/hygon: Add missing resctrl_cpu_detect() in bsp_init helper

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/CPU/AMD: Ignore invalid reset reason value

Jakub Kicinski <kuba@kernel.org>
    tls: fix handling of zero-length records on the rx_list

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: Ensure that dw_pcie_wait_for_link() waits 100 ms after link up

NeilBrown <neil@brown.name>
    ovl: use I_MUTEX_PARENT when locking parent in ovl_create_temp()

Pu Lehui <pulehui@huawei.com>
    tracing: Limit access to parser->buffer when trace_get_user failed

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove unneeded goto out logic

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Wildcat Lake

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Remove WARN_ON for device endpoint command timeouts

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Ignore late xferNotReady event to prevent halt timeout

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: fix host not responding after suspend and resume

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    usb: xhci: Fix slot_id resource race conflict

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: maxim_contaminant: re-enable cc toggle if cc is open and port is clean

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: maxim_contaminant: disable low power mode when reading comparator values

Zenm Chen <zenmchen@gmail.com>
    USB: storage: Ignore driver CD mode for Realtek multi-mode Wi-Fi dongles

Thorsten Blum <thorsten.blum@linux.dev>
    usb: storage: realtek_cr: Use correct byte order for bcs->Residue

Mael GUERIN <mael.guerin@murena.io>
    USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera

Marek Vasut <marek.vasut+renesas@mailbox.org>
    usb: renesas-xhci: Fix External ROM access timeouts

Xu Yang <xu.yang_2@nxp.com>
    usb: core: hcd: fix accessing unmapped memory in SINGLE_STEP_SET_FEATURE test

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix use of uninitialized memory in do_insn_ioctl() and do_insnlist_ioctl()

Edward Adam Davis <eadavis@qq.com>
    comedi: pcl726: Prevent invalid irq number

Ian Abbott <abbotti@mev.co.uk>
    comedi: Make insn_rw_emulate_bits() do insn->n samples

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive

Thorsten Blum <thorsten.blum@linux.dev>
    cdx: Fix off-by-one error in cdx_rpmsg_probe()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    kcov, usb: Don't disable interrupts in kcov_remote_start_usb_softirq()

Miaoqian Lin <linmq006@gmail.com>
    most: core: Drop device reference after usage in get_channel()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    iio: adc: rzg2l: Cleanup suspend/resume path

David Lechner <dlechner@baylibre.com>
    iio: proximity: isl29501: fix buffered read on big-endian systems

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7173: prevent scan if too many setups requested

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: adc: bd79124: Add GPIOLIB dependency

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    iio: adc: rzg2l_adc: Set driver data before enabling runtime PM

Salah Triki <salah.triki@gmail.com>
    iio: pressure: bmp280: Use IS_ERR() in bmp280_common_probe()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: light: as73211: Ensure buffer holes are zeroed

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7124: fix channel lookup in syscalib functions

David Lechner <dlechner@baylibre.com>
    iio: temperature: maxim_thermocouple: use DMA-safe buffer for spi_read()

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Also allocate and copy hash for reading of filter files

David Lechner <dlechner@baylibre.com>
    iio: accel: sca3300: fix uninitialized iio scan data

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7380: fix missing max_conversion_rate_hz on adaq4381-4

Xu Yilun <yilun.xu@linux.intel.com>
    fpga: zynq_fpga: Fix the wrong usage of dma_map_sgtable()

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Restore cached manual clock settings during resume

Robin Murphy <robin.murphy@arm.com>
    iommu/virtio: Make instance lookup robust

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Remove ops.pgsize_bitmap from drivers that don't use it

Al Viro <viro@zeniv.linux.org.uk>
    use uniform permission checks for all mount propagation changes

Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
    signal: Fix memory leak for PIDFD_SELF* sentinels

Ye Bin <yebin10@huawei.com>
    fs/buffer: fix use-after-free when call bh_read() helper

Stefan Metzmacher <metze@samba.org>
    smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()

Christian Brauner <brauner@kernel.org>
    libfs: massage path_from_stashed() to allow custom stashing behavior

Thomas Bertschinger <tahbertschinger@gmail.com>
    fhandle: do_handle_open() should get FD with user flags

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix data relocation block group reservation

Yuntao Wang <yuntao.wang@linux.dev>
    fs: fix incorrect lflags value in the move_mount syscall

Charalampos Mitrodimas <charmitro@posteo.net>
    debugfs: fix mount options not being applied

Miguel Ojeda <ojeda@kernel.org>
    rust: faux: fix C header link

Christoph Hellwig <hch@lst.de>
    xfs: fix frozen file system assert in xfs_trans_alloc

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()

Liu01 Tong <Tong.Liu01@amd.com>
    drm/amdgpu: fix task hang from failed job submission during process kill

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Set Target Link Speed to 5.0 GT/s before retraining

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Use standard PCIe definitions

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Serialize admin queue BAR writes on 32-bit systems

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fill display clock and vblank time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Find first CRTC and its line time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DP audio DTO1 clock source on DCE 6.

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix Xorg desktop unresponsive on Replay panel

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overclock DCE 6 by 15%

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid a NULL pointer dereference

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+/tc: Convert AUX powered WARN to a debug message

Imre Deak <imre.deak@intel.com>
    drm/i915/lnl+/tc: Use the cached max lane count value

Imre Deak <imre.deak@intel.com>
    drm/i915/lnl+/tc: Fix max lane count HW readout

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+/tc: Cache the max lane count value

Imre Deak <imre.deak@intel.com>
    drm/i915/lnl+/tc: Fix handling of an enabled/disconnected dp-alt sink

Sebastian Brzezinka <sebastian.brzezinka@intel.com>
    drm/i915/gt: Relocate compression repacking WA for JSL/EHL

Qianfeng Rong <rongqianfeng@vivo.com>
    drm/nouveau/gsp: fix mismatched alloc/free for kvmalloc()

Jani Nikula <jani.nikula@intel.com>
    drm/i915: silence rpm wakeref asserts on GEN11_GU_MISC_IIR access

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/swm14: Update power limit logic

Thorsten Blum <thorsten.blum@linux.dev>
    accel/habanalabs/gaudi2: Use kvfree() for memory allocated with kvcalloc()

Jan Beulich <jbeulich@suse.com>
    compiler: remove __ADDRESSABLE_ASM{_STR,}() again

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Check write blocked for ELC

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/sclp: Fix SCCB present check

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Flush delayed SKBs while releasing RXE resources

Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>
    ALSA: hda/realtek: Add support for HP EliteBook x360 830 G6 and EliteBook 830 G6

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: tas2781: Fix wrong reference of tasdevice_priv

David Hildenbrand <david@redhat.com>
    mm/mremap: fix WARN with uffd that has remap events disabled

Jinjiang Tu <tujinjiang@huawei.com>
    mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn

Herton R. Krzesinski <herton@redhat.com>
    mm/debug_vm_pgtable: clear page table entries at destroy_args()

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/damon/core: fix damos_commit_filter not changing allow

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix memory leak in squashfs_fill_super

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix a race when updating an existing write

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Disable HS400 for AM62P SR1.0 and SR1.1

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Rename the gli_set_gl9763e() for consistency

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Fix deadlock by moving removing flag earlier

Pasha Tatashin <pasha.tatashin@soleen.com>
    kho: warn if KHO is disabled due to an error

Pasha Tatashin <pasha.tatashin@soleen.com>
    kho: mm: don't allow deferred struct page with KHO

Pasha Tatashin <pasha.tatashin@soleen.com>
    kho: init new_physxa->phys_bits to fix lockdep

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: Add a new function to simplify the code

Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
    mmc: sdhci-of-arasan: Ensure CD logic stabilization before power-up

Sang-Heon Jeon <ekffu200098@gmail.com>
    mm/damon/core: fix commit_ops_filters by using correct nth function

Nicolin Chen <nicolinc@nvidia.com>
    iommu/arm-smmu-v3: Fix smmu_domain->nr_ats_masters decrement

Dominique Martinet <asmadeus@codewreck.org>
    iov_iter: iterate_folioq: fix handling of offset >= folio size

Jens Axboe <axboe@kernel.dk>
    io_uring/futex: ensure io_futex_wait() cleans up properly on failure

XianLiang Huang <huangxianliang@lanxincomputing.com>
    iommu/riscv: prevent NULL deref in iova_to_phys

Eric Biggers <ebiggers@kernel.org>
    crypto: acomp - Fix CFI failure due to type punning

Geert Uytterhoeven <geert+renesas@glider.be>
    erofs: Do not select tristate symbols from bool symbols

Bo Liu (OpenAnolis) <liubo03@inspur.com>
    erofs: fix build error with CONFIG_EROFS_FS_ZIP_ACCEL=y

Alan Huang <mmpgouride@gmail.com>
    xfs: Remove unused label in xfs_dax_notify_dev_failure

Christoph Hellwig <hch@lst.de>
    xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags

Christoph Hellwig <hch@lst.de>
    xfs: improve the comments in xfs_select_zone_nowait

Christoph Hellwig <hch@lst.de>
    xfs: return the allocated transaction from xfs_trans_alloc_empty

Christoph Hellwig <hch@lst.de>
    xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: subpage: keep TOWRITE tag until folio is cleaned

Qu Wenruo <wqu@suse.com>
    btrfs: rename btrfs_subpage structure

Qu Wenruo <wqu@suse.com>
    btrfs: add comments on the extra btrfs specific subpage bitmaps

Leo Martins <loemra.dev@gmail.com>
    btrfs: fix subpage deadlock in try_release_subpage_extent_buffer()

Filipe Manana <fdmanana@suse.com>
    btrfs: use refcount_t type for the extent buffer reference counter

Filipe Manana <fdmanana@suse.com>
    btrfs: add comment for optimization in free_extent_buffer()

Filipe Manana <fdmanana@suse.com>
    btrfs: reorganize logic at free_extent_buffer() for better readability

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on unexpected eb generation at btrfs_copy_root()

Filipe Manana <fdmanana@suse.com>
    btrfs: always abort transaction on failure to add block group to free space tree

David Sterba <dsterba@suse.com>
    btrfs: move transaction aborts to the error site in add_block_group_free_space()

SeongJae Park <sj@kernel.org>
    mm/damon/ops-common: ignore migration request to invalid nodes

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: sockopt: fix C23 extension warning

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: fix C23 extension warning

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: check flush doesn't reset limits

Geliang Tang <geliang@kernel.org>
    mptcp: disable add_addr retransmission when timeout is 0

Geliang Tang <geliang@kernel.org>
    mptcp: remove duplicate sk_reset_timer call

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: kernel: flush: do not reset ADD_ADDR limit

Christoph Paasch <cpaasch@openai.com>
    mptcp: drop skb if MPTCP skb extension allocation fails

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    ACPI: APEI: EINJ: Fix resource leak by remove callback in .exit.text

Chen Yu <yu.c.chen@intel.com>
    ACPI: pfr_update: Fix the driver update version check

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid selecting states with too much latency

JP Kobryn <inwardvessel@gmail.com>
    cgroup: avoid null de-ref in css_rstat_exit()

Eric Biggers <ebiggers@kernel.org>
    ipv6: sr: Fix MAC comparison to be constant-time

Andrea Righi <arighi@nvidia.com>
    sched/ext: Fix invalid task state transitions on class switch

Jakub Acs <acsjakub@amazon.de>
    net, hsr: reject HSR frame if skb can't hold tag

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Add address alignment check in pch_pic register access

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix stack protector issue in send_ipi_data()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Make function kvm_own_lbt() robust

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Don't overwrite dce60_clk_mgr

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Revert "drm/amd/display: Fix AMDGPU_MAX_BL_LEVEL value"

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Pass up errors for reset GPU that fails to init HW

Lauri Tirkkonen <lauri@hacktheplanet.fi>
    drm/amd/display: fix initial backlight brightness calculation

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DCE 6.0 and 6.4 PLL programming.

Siyang Liu <Security@tencent.com>
    drm/amd/display: fix a Null pointer dereference vulnerability

Michel Dänzer <mdaenzer@redhat.com>
    drm/amd/display: Add primary plane to commits for correct VRR handling

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: Fix checkpoint-restore on multi-xcc

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Destroy KFD debugfs after destroy KFD wq

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Update supported modes for GC v9.5.0

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update mmhub 4.1.0 client id mappings

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update mmhub 3.3 client id mappings

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: update mmhub 3.0.1 client id mappings

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Update external revid for GC v9.5.0

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: track whether a queue is a kernel queue in amdgpu_mqd_prop

YuanShang <YuanShang.Mao@amd.com>
    drm/amdgpu: Retain job->vm in amdgpu_job_prepare_job

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Initialize data to NULL in imu_v12_0_program_rlc_ram()

Peter Shkenev <mustela@erminea.space>
    drm/amdgpu: check if hubbub is NULL in debugfs/amdgpu_dm_capabilities

Gang Ba <Gang.Ba@amd.com>
    drm/amdgpu: Avoid extra evict-restore process.

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add missing vram lost check for LEGACY RESET

Frank Min <Frank.Min@amd.com>
    drm/amdgpu: add kicker fws loading for gfx12/smu14/psp14

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Restore cached power limit during resume

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/discovery: fix fw based ip discovery

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/amdgpu: fix missing lock for cper.ring->rptr/wptr access

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Defer buffer object shrinker write-backs and GPU waits

Vodapalli, Ravi Kumar <ravi.kumar.vodapalli@intel.com>
    drm/xe/bmg: Add one additional PCI ID

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Remove unnecessary re-initialization of flush completion

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Verify internal buffer release on close

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Update CAPTURE format info based on OUTPUT format

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Track flush responses to prevent premature completion

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Skip flush on first sequence change

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Skip destroying internal buffer if not dequeued

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Send V4L2_BUF_FLAG_ERROR for capture buffers with 0 filled length

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Remove error check for non-zero v4l2 controls

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Remove deprecated property setting to firmware

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Prevent HFI queue writes when core is in deinit state

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix typo in depth variable

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix NULL pointer dereference

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix missing function pointer initialization

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix buffer preparation failure during resolution change

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Drop port check for session property response

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Avoid updating frame size to firmware during reconfig

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: venc: Clamp param smaller than 1fps and bigger than 240

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: protect against spurious interrupts during probe

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: hfi: explicitly release IRQ during teardown

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    media: venus: Fix MSM8998 frequency table

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Add a check for packet size after reading from shared memory

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Remove extraneous -supply postfix on supply names

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: qcom: camss: cleanup media device allocated resource on error path

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: csiphy-3ph: Fix inadvertent dropping of SDM660/SDM670 phy init

Hans de Goede <hansg@kernel.org>
    media: ivsc: Fix crash at shutdown due to missing mei_cldev_disable() calls

Mathis Foerst <mathis.foerst@mt.com>
    media: mt9m114: Fix deadlock in get_frame_interval/set_frame_interval

Zhang Shurong <zhang_shurong@foxmail.com>
    media: ov2659: Fix memory leaks in ov2659_probe()

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: pisp_be: Fix pm_runtime underrun in probe

Gui-Dong Han <hanguidong02@gmail.com>
    media: rainshadow-cec: fix TOCTOU race condition in rain_interrupt()

Ludwig Disterhof <ludwig@disterhof.eu>
    media: usbtv: Lock resolution while streaming

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-ctrls: Don't reset handler's error in v4l2_ctrl_handler_free()

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: verisilicon: Fix AV1 decoder clock frequency

Hans Verkuil <hverkuil@xs4all.nl>
    media: vivid: fix wrong pixel_array control size

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu6: isys: Use correct pads for xlate_streams()

Haoxiang Li <haoxiang_li2024@163.com>
    media: imx: fix a potential memory leak in imx_media_csc_scaler_device_init()

Bingbu Cao <bingbu.cao@intel.com>
    media: hi556: correct the test pattern configuration

Dan Carpenter <dan.carpenter@linaro.org>
    media: gspca: Add bounds checking to firmware parser

John David Anglin <dave.anglin@bell.net>
    parisc: Update comments in make_insert_tlb

John David Anglin <dave.anglin@bell.net>
    parisc: Try to fixup kernel exception in bad_area_nosemaphore path of do_page_fault()

John David Anglin <dave.anglin@bell.net>
    parisc: Revise gateway LWS calls to probe user read access

John David Anglin <dave.anglin@bell.net>
    parisc: Revise __get_user() to probe user read access

John David Anglin <dave.anglin@bell.net>
    parisc: Rename pte_needs_flush() to pte_needs_cache_flush() in cache.c

Randy Dunlap <rdunlap@infradead.org>
    parisc: Makefile: explain that 64BIT requires both 32-bit and 64-bit compilers

John David Anglin <dave.anglin@bell.net>
    parisc: Drop WARN_ON_ONCE() from flush_cache_vmap

John David Anglin <dave.anglin@bell.net>
    parisc: Define and use set_pte_at()

John David Anglin <dave.anglin@bell.net>
    parisc: Check region is readable by user in raw_copy_from_user()

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Ensure power-domains are in a known state

Jialin Wang <wjl.linux@gmail.com>
    proc: proc_maps_open allow proc_mem_open to return NULL

Aleksa Sarai <cyphar@cyphar.com>
    open_tree_attr: do not allow id-mapping changes without OPEN_TREE_CLONE

Simon Richter <Simon.Richter@hogyros.de>
    Mark xe driver as BROKEN if kernel page size is not 4kB

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: use correct linker when mixing clang and GNU ld

Jann Horn <jannh@google.com>
    kasan/test: fix protection against compiler elision

Baokun Li <libaokun1@huawei.com>
    jbd2: prevent softlockup in jbd2_log_do_checkpoint()

Jan Kara <jack@suse.cz>
    iomap: Fix broken data integrity guarantees for O_SYNC writes

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    i2c: qcom-geni: fix I2C frequency table to achieve accurate bus rates

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in dnode page

Julian Sun <sunjunchao2870@gmail.com>
    block: restore default wbt enablement

Muhammad Usama Anjum <usama.anjum@collabora.com>
    ASoC: SOF: amd: acp-loader: Use GFP_KERNEL for DMA allocations in resume context

Xaver Hugl <xaver.hugl@kde.org>
    amdgpu/amdgpu_discovery: increase timeout limit for IFWI init

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    phy: qcom: phy-qcom-m31: Update IPQ5332 M31 USB phy initialization sequence

Will Deacon <will@kernel.org>
    vhost/vsock: Avoid allocating arbitrarily-sized SKBs

Will Deacon <will@kernel.org>
    vsock/virtio: Validate length in packet header before skb_put()

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Delay link start until configfs 'start' written

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Remove apps_reset toggling from imx_pcie_{assert/deassert}_core_reset

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Add IMX8MM_EP and IMX8MP_EP fixed 256-byte BAR 4 in epc_features

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Add IMX8MQ_EP third 64-bit BAR in epc_features

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group removal on driver teardown

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group list head handling

Jiwei Sun <sunjw10@lenovo.com>
    PCI: Fix link speed calculation on retrain failure

Lukas Wunner <lukas@wunner.de>
    PCI/portdrv: Use is_pciehp instead of is_hotplug_bridge

Chi Zhiling <chizhiling@kylinos.cn>
    readahead: fix return value of page_cache_next_miss() when no hole is found

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    mfd: mt6397: Do not use generic name for keypad sub-devices

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: renesas: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: fsmc: Add missing check after DMA map

Gabor Juhos <j4g8y7@gmail.com>
    mtd: spinand: propagate spinand_wait() errors from spinand_write_page()

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: Fix spi_nor_try_unlock_all()

Tim Harvey <tharvey@gateworks.com>
    hwmon: (gsc-hwmon) fix fan pwm setpoint show functions

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Fix duty and period setting

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Handle hardware enable and clock enable separately

Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
    pwm: imx-tpm: Reset counter if CMOD is 0

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix dest ring-buffer corruption when ring is full

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix source ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix dest ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix dest ring-buffer corruption when ring is full

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix source ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix dest ring-buffer corruption

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7173: fix setting ODR in probe

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7173: fix calibration channel

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7173: fix channels index for syscalib_mode

David Lechner <dlechner@baylibre.com>
    iio: adc: ad_sigma_delta: change to buffer predisable

David Lechner <dlechner@baylibre.com>
    iio: imu: bno055: fix OOB access of hw_xlate array

Marek Szyprowski <m.szyprowski@samsung.com>
    zynq_fpga: use sgtable-based scatterlist wrappers

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Ensure we don't read past the ELF header

Igor Pylypiv <ipylypiv@google.com>
    ata: libata-scsi: Fix CDL control

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix default runtime and system PM levels

Archana Patni <archana.patni@intel.com>
    scsi: ufs: ufs-pci: Fix hibernate state transition for Intel MTL-like host controllers

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Return aborted command when missing sense and result TF

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Fix ata_to_sense_error() status handling

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Fix race between config read submit and interrupt completion

André Draszik <andre.draszik@linaro.org>
    scsi: ufs: exynos: Fix programming of HCI_UTRL_NEXUS_TYPE

Macpaul Lin <macpaul.lin@mediatek.com>
    scsi: dt-bindings: mediatek,ufs: Add ufs-disable-mcq flag for UFS host

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    dt-bindings: display: vop2: Add optional PLL clock property for rk3576

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: display: sprd,sharkl3-dsi-host: Fix missing clocks constraints

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: display: sprd,sharkl3-dpu: Fix missing clocks constraints

Helge Deller <deller@gmx.de>
    apparmor: Fix 8-byte alignment for initial dfa blob streams

Sam Edwards <cfsworks@gmail.com>
    arm64: dts: rockchip: Remove workaround that prevented Turing RK1 GPU power regulator control

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: ti: k3-am62-verdin: Enable pull-ups on I2C buses

Kaustabh Chakraborty <kauschluss@disroot.org>
    arm64: dts: exynos7870-on7xelte: reduce memory ranges to base amount

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62*: Move eMMC pinmux to top level board file

Hong Guan <hguan@ti.com>
    arm64: dts: ti: k3-am62a7-sk: fix pinmux for main_uart1

Peter Griffin <peter.griffin@linaro.org>
    arm64: dts: exynos: gs101: ufs: add dma-coherent property

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Enable HDMI PHY clk provider on rk3576

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    arm64: dts: rockchip: Add HDMI PHY PLL clock source to VOP2 on rk3576

Kaustabh Chakraborty <kauschluss@disroot.org>
    arm64: dts: exynos7870: add quirk to disable USB2 LPM in gadget mode

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    arm64: dts: ti: k3-pinctrl: Enable Schmitt Trigger by default

Kaustabh Chakraborty <kauschluss@disroot.org>
    arm64: dts: exynos7870-j6lte: reduce memory ranges to base amount

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support

Nick Chan <towinchenmi@gmail.com>
    arm64: dts: apple: t8012-j132: Include touchbar framebuffer node

Kyoji Ogasawara <sawara04.o@gmail.com>
    btrfs: fix printing of mount info messages for NODATACOW/NODATASUM

Kyoji Ogasawara <sawara04.o@gmail.com>
    btrfs: restore mount option info messages during mount

Kyoji Ogasawara <sawara04.o@gmail.com>
    btrfs: fix incorrect log message for nobarrier mount option

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix write time activation failure for metadata block group

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix hole length calculation overflow in non-extent inodes

Liao Yuanhong <liaoyuanhong@vivo.com>
    ext4: use kmalloc_array() for array space allocation

Theodore Ts'o <tytso@mit.edu>
    ext4: don't try to clear the orphan_present feature block device is r/o

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix reserved gdt blocks handling in fsmap

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix fsmap end of range reporting with bigalloc

Andreas Dilger <adilger@dilger.ca>
    ext4: check fast symlink for ea_inode correctly

Baokun Li <libaokun1@huawei.com>
    ext4: preserve SB_I_VERSION on remount

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: fprobe-event: Sanitize wildcard for fprobe event name

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: extend the connection limiting mechanism to support IPv6

Ziyan Xu <ziyan@securitygossip.com>
    ksmbd: fix refcount leak causing resource not released

Helge Deller <deller@gmx.de>
    Revert "vgacon: Add check for vc_origin address range in vgacon_scroll()"

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: hash - Increase HASH_MAX_DESCSIZE for hmac(sha3-224-s390)

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - Fix address alignment on CN10KB and CN10KA-B0

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - Fix address alignment on CN10K A0/A1 and OcteonTX2

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - Fix address alignment issue on ucode loading

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aegis - Add missing error checks

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - flush misc workqueue during device shutdown

John Ernberg <john.ernberg@actia.se>
    crypto: caam - Prevent crash on suspend with iMX8QM / iMX8ULP

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp - Fix SNP panic notifier unregistration

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - lower priority for skcipher and aead algorithms

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD contexts

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips/chacha: Fix clang build and remove unneeded byteswap

David Howells <dhowells@redhat.com>
    netfs: Fix unbuffered write error handling

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: defkeymap: Map keycodes above 127 to K_HOLE

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: keyboard: Don't process Unicode characters in K_OFF mode

Youssef Samir <quic_yabdulra@quicinc.com>
    bus: mhi: host: Detect events pointing to unexpected TREs

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    bus: mhi: host: Fix endianness of BHI vector table

Johan Hovold <johan@kernel.org>
    usb: dwc3: imx8mp: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    usb: dwc3: meson-g12a: fix device leaks at unbind

Johan Hovold <johan@kernel.org>
    usb: musb: omap2430: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    usb: gadget: udc: renesas_usb3: fix device leak at unbind

Nathan Chancellor <nathan@kernel.org>
    usb: atm: cxacru: Merge cxacru_upload_firmware() into cxacru_heavy_init()

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7173: fix num_slots

Finn Thain <fthain@linux-m68k.org>
    m68k: Fix lost column on framebuffer debug console

Damien Le Moal <dlemoal@kernel.org>
    dm: Check for forbidden splitting of zone write operations

Damien Le Moal <dlemoal@kernel.org>
    dm: dm-crypt: Do not partially accept write BIOs with zoned targets

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Take active children into account in pm_runtime_get_if_in_use()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()

Dan Carpenter <dan.carpenter@linaro.org>
    cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()

Damien Le Moal <dlemoal@kernel.org>
    ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig

Yunhui Cui <cuiyunhui@bytedance.com>
    serial: 8250: fix panic due to PSLVERR


-------------

Diffstat:

 .../bindings/display/rockchip/rockchip-vop2.yaml   |  56 ++++-
 .../bindings/display/sprd/sprd,sharkl3-dpu.yaml    |   2 +-
 .../display/sprd/sprd,sharkl3-dsi-host.yaml        |   2 +-
 .../devicetree/bindings/ufs/mediatek,ufs.yaml      |   4 +
 Documentation/networking/mptcp-sysctl.rst          |   2 +
 Makefile                                           |   6 +-
 arch/arm/lib/crypto/poly1305-glue.c                |   3 +-
 arch/arm64/boot/dts/apple/t8012-j132.dts           |   1 +
 arch/arm64/boot/dts/exynos/exynos7870-j6lte.dts    |   2 +-
 arch/arm64/boot/dts/exynos/exynos7870-on7xelte.dts |   2 +-
 arch/arm64/boot/dts/exynos/exynos7870.dtsi         |   1 +
 arch/arm64/boot/dts/exynos/google/gs101.dtsi       |   1 +
 arch/arm64/boot/dts/rockchip/rk3576.dtsi           |   7 +-
 .../arm64/boot/dts/rockchip/rk3588-turing-rk1.dtsi |  11 -
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |  24 ++
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  12 +-
 arch/arm64/boot/dts/ti/k3-am625-sk.dts             |  24 ++
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |   4 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |  24 --
 arch/arm64/boot/dts/ti/k3-pinctrl.h                |  15 +-
 arch/arm64/lib/crypto/poly1305-glue.c              |   3 +-
 arch/loongarch/Makefile                            |   6 +
 arch/loongarch/kernel/module-sections.c            |  38 +--
 arch/loongarch/kvm/intc/eiointc.c                  |  32 +--
 arch/loongarch/kvm/intc/ipi.c                      |   8 +-
 arch/loongarch/kvm/intc/pch_pic.c                  |  10 +
 arch/loongarch/kvm/vcpu.c                          |   8 +-
 arch/m68k/kernel/head.S                            |  31 ++-
 arch/mips/lib/crypto/chacha-core.S                 |  20 +-
 arch/parisc/Makefile                               |   4 +-
 arch/parisc/include/asm/pgtable.h                  |   7 +-
 arch/parisc/include/asm/special_insns.h            |  28 +++
 arch/parisc/include/asm/uaccess.h                  |  21 +-
 arch/parisc/kernel/cache.c                         |   6 +-
 arch/parisc/kernel/entry.S                         |  17 +-
 arch/parisc/kernel/syscall.S                       |  30 ++-
 arch/parisc/lib/memcpy.c                           |  19 +-
 arch/parisc/mm/fault.c                             |   4 +
 arch/s390/boot/vmem.c                              |   3 +
 arch/s390/hypfs/hypfs_dbfs.c                       |  19 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |  40 +++-
 arch/x86/include/asm/xen/hypercall.h               |   5 +-
 arch/x86/kernel/cpu/amd.c                          |   8 +-
 arch/x86/kernel/cpu/hygon.c                        |   3 +
 block/bfq-iosched.c                                |  13 +-
 block/blk-mq-debugfs.c                             |   1 +
 block/blk-mq-sched.c                               | 223 ++++++++++++------
 block/blk-mq-sched.h                               |  12 +-
 block/blk-mq.c                                     |  29 ++-
 block/blk-rq-qos.c                                 |   8 +-
 block/blk-rq-qos.h                                 |  48 ++--
 block/blk-sysfs.c                                  |   2 +-
 block/blk.h                                        |   4 +-
 block/elevator.c                                   |  38 ++-
 block/elevator.h                                   |  16 +-
 block/kyber-iosched.c                              |  11 +-
 block/mq-deadline.c                                |  14 +-
 crypto/deflate.c                                   |   7 +-
 drivers/accel/habanalabs/gaudi2/gaudi2.c           |   2 +-
 drivers/acpi/apei/einj-core.c                      |  12 +-
 drivers/acpi/pfr_update.c                          |   2 +-
 drivers/ata/Kconfig                                |  32 ++-
 drivers/ata/libata-scsi.c                          |  49 ++--
 drivers/base/power/runtime.c                       |  27 ++-
 drivers/bluetooth/btmtk.c                          |   7 +-
 drivers/bus/mhi/host/boot.c                        |   8 +-
 drivers/bus/mhi/host/internal.h                    |   4 +-
 drivers/bus/mhi/host/main.c                        |  12 +-
 drivers/cdx/controller/cdx_rpmsg.c                 |   3 +-
 drivers/comedi/comedi_fops.c                       |   5 +
 drivers/comedi/drivers.c                           |  27 +--
 drivers/comedi/drivers/pcl726.c                    |   3 +-
 drivers/cpufreq/armada-8k-cpufreq.c                |   2 +-
 drivers/cpuidle/governors/menu.c                   |  29 +--
 drivers/crypto/caam/ctrl.c                         |   5 +-
 drivers/crypto/caam/intern.h                       |   1 +
 drivers/crypto/ccp/sev-dev.c                       |  10 +-
 .../crypto/intel/qat/qat_common/adf_common_drv.h   |   1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c     |   1 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c      |   5 +
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |  12 +-
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h | 125 +++++++---
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |  35 +--
 drivers/fpga/zynq-fpga.c                           |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c           |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  76 +++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   7 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  21 +-
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/imu_v12_0.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c          |  57 +++--
 drivers/gpu/drm/amd/amdgpu/mmhub_v3_3.c            | 121 +++++++++-
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c          |  34 ++-
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_module.c            |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |  61 ++++-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  20 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  19 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  28 +++
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c  |   5 +-
 .../gpu/drm/amd/display/dc/bios/command_table.c    |   2 +-
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |   1 -
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |  19 +-
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |  40 ++--
 .../amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |  31 +--
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  34 ++-
 .../amd/display/dc/resource/dce60/dce60_resource.c |  34 +--
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  16 ++
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c     |  11 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  30 ++-
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +-
 drivers/gpu/drm/drm_format_helper.c                | 108 ++++++++-
 drivers/gpu/drm/drm_format_internal.h              |   8 +
 drivers/gpu/drm/drm_panic_qr.rs                    |  22 +-
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_link.c       |  14 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.c    |  22 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_drv.h    |   1 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_i2c.c    |   5 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c   |  11 +-
 drivers/gpu/drm/i915/display/intel_display_irq.c   |   4 +
 drivers/gpu/drm/i915/display/intel_tc.c            |  93 ++++++--
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |  20 +-
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |   3 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c  |   4 +-
 drivers/gpu/drm/nova/file.rs                       |   3 +-
 drivers/gpu/drm/tests/drm_format_helper_test.c     | 111 ++-------
 drivers/gpu/drm/xe/Kconfig                         |   1 +
 drivers/gpu/drm/xe/xe_migrate.c                    |   2 +-
 drivers/gpu/drm/xe/xe_pxp_submit.c                 |   2 +-
 drivers/gpu/drm/xe/xe_shrinker.c                   |  51 +++-
 drivers/gpu/drm/xe/xe_vm.c                         |  48 ++--
 drivers/gpu/drm/xe/xe_vm.h                         |   2 +-
 drivers/hwmon/gsc-hwmon.c                          |   4 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   6 +-
 drivers/i2c/busses/i2c-rtl9300.c                   |  20 +-
 drivers/iio/accel/sca3300.c                        |   2 +-
 drivers/iio/adc/Kconfig                            |   2 +-
 drivers/iio/adc/ad7124.c                           |  14 +-
 drivers/iio/adc/ad7173.c                           | 137 ++++++++---
 drivers/iio/adc/ad7380.c                           |   1 +
 drivers/iio/adc/ad_sigma_delta.c                   |   4 +-
 drivers/iio/adc/rzg2l_adc.c                        |  33 +--
 drivers/iio/imu/bno055/bno055.c                    |  11 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |   8 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |  31 ++-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |  22 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.h |  10 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   |   6 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |  41 ++--
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |  12 +-
 drivers/iio/light/as73211.c                        |   2 +-
 drivers/iio/pressure/bmp280-core.c                 |   9 +-
 drivers/iio/proximity/isl29501.c                   |  14 +-
 drivers/iio/temperature/maxim_thermocouple.c       |  26 ++-
 drivers/infiniband/core/umem_odp.c                 |   4 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   8 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  23 ++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  30 +--
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   2 +
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   6 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   6 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   9 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  29 +--
 drivers/infiniband/sw/rxe/rxe_qp.c                 |   2 +-
 drivers/iommu/amd/init.c                           |   4 +-
 drivers/iommu/apple-dart.c                         |   1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/iommu/intel/iommu.c                        |   1 -
 drivers/iommu/iommufd/selftest.c                   |   1 -
 drivers/iommu/riscv/iommu.c                        |   3 +-
 drivers/iommu/virtio-iommu.c                       |  19 +-
 drivers/md/dm-crypt.c                              |  47 +++-
 drivers/md/dm-raid.c                               |  42 ++--
 drivers/md/dm.c                                    |  17 +-
 drivers/md/md-bitmap.c                             |   8 +-
 drivers/md/md-cluster.c                            |  16 +-
 drivers/md/md.c                                    | 110 ++++++---
 drivers/md/md.h                                    |   2 +-
 drivers/md/raid0.c                                 |   6 +-
 drivers/md/raid1-10.c                              |   2 +-
 drivers/md/raid1.c                                 |  10 +-
 drivers/md/raid10.c                                |  16 +-
 drivers/md/raid5-ppl.c                             |   6 +-
 drivers/md/raid5.c                                 |  30 +--
 drivers/media/cec/usb/rainshadow/rainshadow-cec.c  |   3 +-
 drivers/media/i2c/hi556.c                          |  26 ++-
 drivers/media/i2c/mt9m114.c                        |   8 -
 drivers/media/i2c/ov2659.c                         |   3 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-csi2.c      |  12 +-
 drivers/media/pci/intel/ivsc/mei_ace.c             |   2 +
 drivers/media/pci/intel/ivsc/mei_csi.c             |   2 +
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |   3 +-
 drivers/media/platform/qcom/camss/camss.c          |  20 +-
 drivers/media/platform/qcom/iris/iris_buffer.c     |  20 +-
 drivers/media/platform/qcom/iris/iris_buffer.h     |   3 +-
 drivers/media/platform/qcom/iris/iris_ctrls.c      |   7 +-
 .../platform/qcom/iris/iris_hfi_gen1_command.c     |  27 +--
 .../platform/qcom/iris/iris_hfi_gen1_defines.h     |   1 -
 .../platform/qcom/iris/iris_hfi_gen1_response.c    |  20 +-
 .../platform/qcom/iris/iris_hfi_gen2_command.c     |   4 +-
 .../platform/qcom/iris/iris_hfi_gen2_response.c    |  11 +-
 drivers/media/platform/qcom/iris/iris_hfi_queue.c  |   2 +-
 drivers/media/platform/qcom/iris/iris_instance.h   |   2 +
 .../platform/qcom/iris/iris_platform_common.h      |   2 +-
 .../platform/qcom/iris/iris_platform_sm8250.c      |   9 -
 drivers/media/platform/qcom/iris/iris_state.c      |   2 +-
 drivers/media/platform/qcom/iris/iris_state.h      |   1 +
 drivers/media/platform/qcom/iris/iris_vb2.c        |  15 +-
 drivers/media/platform/qcom/iris/iris_vdec.c       |   9 +-
 drivers/media/platform/qcom/iris/iris_vidc.c       |  33 ++-
 drivers/media/platform/qcom/venus/core.c           |  18 +-
 drivers/media/platform/qcom/venus/core.h           |   2 +
 drivers/media/platform/qcom/venus/hfi_venus.c      |   5 +
 drivers/media/platform/qcom/venus/vdec.c           |   5 +-
 drivers/media/platform/qcom/venus/venc.c           |   5 +-
 drivers/media/platform/raspberrypi/pisp_be/Kconfig |   1 +
 .../media/platform/raspberrypi/pisp_be/pisp_be.c   |   5 +-
 .../media/platform/verisilicon/rockchip_vpu_hw.c   |   9 -
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |   3 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   4 +-
 drivers/media/usb/gspca/vicam.c                    |  10 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   4 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   1 -
 drivers/memstick/core/memstick.c                   |   1 -
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/mfd/mt6397-core.c                          |  12 +-
 drivers/mmc/host/sdhci-of-arasan.c                 |  33 ++-
 drivers/mmc/host/sdhci-pci-gli.c                   |  37 +--
 drivers/mmc/host/sdhci_am654.c                     |  18 ++
 drivers/most/core.c                                |   2 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/renesas-nand-controller.c     |   6 +
 drivers/mtd/nand/spi/core.c                        |   5 +-
 drivers/mtd/spi-nor/swp.c                          |  19 +-
 drivers/net/bonding/bond_3ad.c                     |  67 ++++--
 drivers/net/bonding/bond_options.c                 |   1 +
 drivers/net/dsa/microchip/ksz_common.c             |   6 +
 drivers/net/ethernet/airoha/airoha_ppe.c           |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  14 +-
 drivers/net/ethernet/intel/ixgbe/devlink/devlink.c |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h |   1 -
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  18 +-
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_hmfs.c |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  12 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  20 ++
 .../mellanox/mlx5/core/steering/hws/bwc_complex.c  |  41 ++--
 .../ethernet/mellanox/mlx5/core/steering/hws/cmd.c |   1 +
 .../ethernet/mellanox/mlx5/core/steering/hws/cmd.h |   1 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   1 +
 .../mellanox/mlx5/core/steering/hws/matcher.c      |   5 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h      |   1 +
 .../mellanox/mlx5/core/steering/hws/send.c         |   1 -
 .../mellanox/mlx5/core/steering/hws/table.c        |  13 +-
 .../mellanox/mlx5/core/steering/hws/table.h        |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |   1 +
 drivers/net/ethernet/microchip/lan865x/lan865x.c   |  21 ++
 drivers/net/ethernet/realtek/rtase/rtase.h         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c  |   9 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  72 +++---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   8 +-
 drivers/net/phy/mscc/mscc.h                        |  12 +
 drivers/net/phy/mscc/mscc_main.c                   |  12 +
 drivers/net/phy/mscc/mscc_ptp.c                    |  49 +++-
 drivers/net/ppp/ppp_generic.c                      |  17 +-
 drivers/net/usb/asix_devices.c                     |   2 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   3 -
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 -
 drivers/net/wireless/ath/ath11k/hal.c              |  33 ++-
 drivers/net/wireless/ath/ath12k/ce.c               |   3 -
 drivers/net/wireless/ath/ath12k/hal.c              |  38 ++-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   2 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  12 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   8 +
 drivers/pci/controller/pcie-rockchip-ep.c          |   4 +-
 drivers/pci/controller/pcie-rockchip-host.c        |  49 ++--
 drivers/pci/controller/pcie-rockchip.h             |  12 +-
 drivers/pci/endpoint/pci-ep-cfs.c                  |   1 +
 drivers/pci/endpoint/pci-epf-core.c                |   2 +-
 drivers/pci/pci.h                                  |  32 +--
 drivers/pci/pcie/portdrv.c                         |   2 +-
 drivers/phy/qualcomm/phy-qcom-m31.c                |  14 +-
 drivers/platform/chrome/cros_ec.c                  |   3 +
 drivers/platform/x86/amd/hsmp/hsmp.c               |   5 +
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   5 +
 drivers/pwm/pwm-imx-tpm.c                          |   9 +
 drivers/pwm/pwm-mediatek.c                         |  71 +++---
 drivers/regulator/pca9450-regulator.c              |  13 +-
 drivers/regulator/tps65219-regulator.c             |  12 +-
 drivers/s390/char/sclp.c                           |  11 +-
 drivers/scsi/mpi3mr/mpi3mr.h                       |   6 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  17 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/soc/qcom/mdt_loader.c                      |  43 ++++
 drivers/soc/tegra/pmc.c                            |  51 ++--
 drivers/spi/spi-fsl-lpspi.c                        |   8 +-
 drivers/spi/spi-qpic-snand.c                       |  22 +-
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/vt/defkeymap.c_shipped                 | 112 +++++++++
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/ufs/core/ufshcd.c                          |  10 +-
 drivers/ufs/host/ufs-exynos.c                      |   4 +-
 drivers/ufs/host/ufs-qcom.c                        |  42 ++--
 drivers/ufs/host/ufshcd-pci.c                      |  42 +++-
 drivers/usb/atm/cxacru.c                           | 172 +++++++-------
 drivers/usb/core/hcd.c                             |  20 +-
 drivers/usb/core/quirks.c                          |   1 +
 drivers/usb/dwc3/dwc3-imx8mp.c                     |   7 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/dwc3/ep0.c                             |  20 +-
 drivers/usb/dwc3/gadget.c                          |  19 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   1 +
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-mem.c                        |  22 +-
 drivers/usb/host/xhci-pci-renesas.c                |   7 +-
 drivers/usb/host/xhci-ring.c                       |   9 +-
 drivers/usb/host/xhci.c                            |  23 +-
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/musb/omap2430.c                        |  14 +-
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  29 +++
 drivers/usb/typec/tcpm/maxim_contaminant.c         |  58 +++++
 drivers/usb/typec/tcpm/tcpci_maxim.h               |   1 +
 drivers/vhost/vsock.c                              |   6 +-
 drivers/video/console/vgacon.c                     |   2 +-
 fs/btrfs/ctree.c                                   |  23 +-
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/extent_io.c                               |  94 ++++----
 fs/btrfs/extent_io.h                               |   2 +-
 fs/btrfs/fiemap.c                                  |   2 +-
 fs/btrfs/free-space-tree.c                         |  17 +-
 fs/btrfs/inode.c                                   |   8 +-
 fs/btrfs/print-tree.c                              |   2 +-
 fs/btrfs/qgroup.c                                  |   6 +-
 fs/btrfs/relocation.c                              |   4 +-
 fs/btrfs/subpage.c                                 | 258 +++++++++++----------
 fs/btrfs/subpage.h                                 |  45 +++-
 fs/btrfs/super.c                                   |  13 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/zoned.c                                   |  70 ++++--
 fs/buffer.c                                        |   2 +-
 fs/debugfs/inode.c                                 |  11 +-
 fs/erofs/Kconfig                                   |  18 +-
 fs/ext4/fsmap.c                                    |  23 +-
 fs/ext4/indirect.c                                 |   4 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/orphan.c                                   |   5 +-
 fs/ext4/super.c                                    |   8 +-
 fs/f2fs/node.c                                     |  10 +
 fs/fhandle.c                                       |   2 +-
 fs/internal.h                                      |   3 +
 fs/iomap/direct-io.c                               |  14 +-
 fs/jbd2/checkpoint.c                               |   1 +
 fs/libfs.c                                         |  27 ++-
 fs/namespace.c                                     |  69 +++---
 fs/netfs/read_collect.c                            |   4 +-
 fs/netfs/write_collect.c                           |  10 +-
 fs/netfs/write_issue.c                             |   4 +-
 fs/nfs/pagelist.c                                  |   9 +-
 fs/nfs/write.c                                     |  29 +--
 fs/overlayfs/copy_up.c                             |   2 +-
 fs/proc/task_mmu.c                                 |   4 +-
 fs/smb/client/smb2ops.c                            |   2 +-
 fs/smb/server/connection.c                         |   3 +-
 fs/smb/server/connection.h                         |   7 +-
 fs/smb/server/oplock.c                             |  13 +-
 fs/smb/server/transport_rdma.c                     |   5 +-
 fs/smb/server/transport_rdma.h                     |   4 +-
 fs/smb/server/transport_tcp.c                      |  26 ++-
 fs/splice.c                                        |   3 +
 fs/squashfs/super.c                                |  14 +-
 fs/xfs/libxfs/xfs_refcount.c                       |   4 +-
 fs/xfs/scrub/common.c                              |   3 +-
 fs/xfs/scrub/repair.c                              |  12 +-
 fs/xfs/scrub/scrub.c                               |   5 +-
 fs/xfs/xfs_attr_item.c                             |   5 +-
 fs/xfs/xfs_discard.c                               |  12 +-
 fs/xfs/xfs_fsmap.c                                 |   4 +-
 fs/xfs/xfs_icache.c                                |   5 +-
 fs/xfs/xfs_inode.c                                 |   7 +-
 fs/xfs/xfs_itable.c                                |  24 +-
 fs/xfs/xfs_iwalk.c                                 |  11 +-
 fs/xfs/xfs_notify_failure.c                        |   6 +-
 fs/xfs/xfs_qm.c                                    |  10 +-
 fs/xfs/xfs_rtalloc.c                               |  13 +-
 fs/xfs/xfs_trans.c                                 |  56 ++---
 fs/xfs/xfs_trans.h                                 |   3 +-
 fs/xfs/xfs_zone_alloc.c                            |  10 +-
 fs/xfs/xfs_zone_gc.c                               |   5 +-
 include/crypto/hash.h                              |   2 +-
 include/crypto/internal/acompress.h                |   5 +-
 include/drm/drm_format_helper.h                    |   9 +
 include/drm/intel/pciids.h                         |   1 +
 include/linux/blkdev.h                             |   1 +
 include/linux/compiler.h                           |   8 -
 include/linux/iosys-map.h                          |   7 +-
 include/linux/iov_iter.h                           |  20 +-
 include/linux/kcov.h                               |  47 +---
 include/linux/mlx5/mlx5_ifc.h                      |  14 +-
 include/linux/netfs.h                              |   1 +
 include/linux/nfs_page.h                           |   1 +
 include/net/bluetooth/bluetooth.h                  |   4 +-
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |  54 ++++-
 include/net/bond_3ad.h                             |   1 +
 include/net/devlink.h                              |   6 +-
 include/net/sch_generic.h                          |  11 +-
 include/sound/cs35l56.h                            |   5 +-
 include/trace/events/btrfs.h                       |   2 +-
 include/uapi/linux/pfrut.h                         |   1 +
 include/uapi/linux/raid/md_p.h                     |   2 +-
 io_uring/futex.c                                   |   3 +
 kernel/Kconfig.kexec                               |   1 +
 kernel/cgroup/cpuset.c                             |   9 +-
 kernel/cgroup/rstat.c                              |   3 +
 kernel/kexec_handover.c                            |  29 ++-
 kernel/sched/ext.c                                 |   4 +
 kernel/signal.c                                    |   6 +-
 kernel/trace/ftrace.c                              |  19 +-
 kernel/trace/trace.c                               |  34 ++-
 kernel/trace/trace.h                               |  10 +-
 mm/damon/core.c                                    |  15 +-
 mm/damon/paddr.c                                   |   4 +
 mm/debug_vm_pgtable.c                              |   9 +-
 mm/filemap.c                                       |   3 +-
 mm/kasan/kasan_test_c.c                            |   2 +-
 mm/memory-failure.c                                |   8 +
 mm/mremap.c                                        |  41 ++--
 net/bluetooth/hci_conn.c                           |  17 +-
 net/bluetooth/hci_core.c                           |  27 ++-
 net/bluetooth/hci_event.c                          |  15 +-
 net/bluetooth/hci_sync.c                           |  33 +--
 net/bluetooth/iso.c                                |  20 +-
 net/bluetooth/mgmt.c                               |  13 +-
 net/bridge/br_multicast.c                          |  16 ++
 net/bridge/br_private.h                            |   2 +
 net/core/dev.c                                     |  12 +
 net/devlink/port.c                                 |   2 +-
 net/hsr/hsr_slave.c                                |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   6 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   5 +-
 net/ipv6/seg6_hmac.c                               |   6 +-
 net/mptcp/options.c                                |   6 +-
 net/mptcp/pm.c                                     |  18 +-
 net/mptcp/pm_kernel.c                              |   1 -
 net/sched/sch_cake.c                               |  14 +-
 net/sched/sch_codel.c                              |  12 +-
 net/sched/sch_fq.c                                 |  12 +-
 net/sched/sch_fq_codel.c                           |  12 +-
 net/sched/sch_fq_pie.c                             |  12 +-
 net/sched/sch_hhf.c                                |  12 +-
 net/sched/sch_htb.c                                |   2 +-
 net/sched/sch_pie.c                                |  12 +-
 net/smc/af_smc.c                                   |   3 +-
 net/tls/tls_sw.c                                   |   7 +-
 net/vmw_vsock/virtio_transport.c                   |  12 +-
 rust/kernel/alloc/allocator.rs                     |  30 ++-
 rust/kernel/alloc/allocator_test.rs                |  11 +
 rust/kernel/drm/device.rs                          |  32 ++-
 rust/kernel/faux.rs                                |   2 +-
 security/apparmor/lsm.c                            |   4 +-
 sound/core/timer.c                                 |   4 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/pci/hda/tas2781_hda_i2c.c                    |   2 +-
 sound/soc/codecs/cs35l56-sdw.c                     |  69 ------
 sound/soc/codecs/cs35l56-shared.c                  |  29 ++-
 sound/soc/codecs/cs35l56.c                         |   2 +-
 sound/soc/codecs/cs35l56.h                         |   3 -
 sound/soc/sof/amd/acp-loader.c                     |   6 +-
 sound/usb/stream.c                                 |   2 +-
 sound/usb/validate.c                               |   2 +-
 tools/objtool/arch/loongarch/special.c             |  23 ++
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   5 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c      |   5 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |   5 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   1 +
 498 files changed, 4907 insertions(+), 2746 deletions(-)


