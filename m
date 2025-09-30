Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20796303A29;
	Tue, 30 Sep 2025 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244499; cv=none; b=RmpbI3LGffyXRoZQpxvM/4gbIkiv8NXGgarzuHWRIINVRGBuTNGBrzKSiEGu2xnLY7xFn+TSxmXz7RQMJoRjIExTJkcjTFo4Ui3K0DH+YwNuMEuI/NKG0rp+1x61sOPh5X1O4f9oNqs7NW4gBxHlIo7S2f/nrvoSMciM3pY3TFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244499; c=relaxed/simple;
	bh=kYy/xMjJZth4liU+How8L/ieNyylVxOA6tPB68ayb4g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cED5gl1IkgHcYQgJlWoZzeFa0FqdQvv8z1NZivoQSJp+7RoHpRz+kjCSkwacp3VRjjMTk8XMC8KdFR58JTcQBuN2i6NAsxWg91wM1Soc5LjrR8TMiEebx1FCMbRZCPMZTzdZGSMQBtY6TyZnA+23kYLvZGqdIEVOEWvZNM9S3Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUegaPk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUegaPk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F9BC4CEF0;
	Tue, 30 Sep 2025 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244499;
	bh=kYy/xMjJZth4liU+How8L/ieNyylVxOA6tPB68ayb4g=;
	h=From:To:Cc:Subject:Date:From;
	b=uUegaPk1Pw4kcPC8kRR8Fix2nbwbpG8LTVLON/P3jjTavAdTuJdDd1HCWoAJLj6A9
	 UMKv2iQKwBOUL0p5SMO1WJUQcLQVslhtvKT1QwRKMNOmdyhllDtBzh83v9t5G9BXoh
	 BGsE/L+41Q7YOdxOE92qYvws2AZ3hm4g0C8Xa+7Y=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 000/143] 6.16.10-rc1 review
Date: Tue, 30 Sep 2025 16:45:24 +0200
Message-ID: <20250930143831.236060637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.10-rc1
X-KernelTest-Deadline: 2025-10-02T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.10 release.
There are 143 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.10-rc1

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Fix race during abort for file descriptors

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-qspi: defer runtime support on socfpga if reset bit is enabled

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: cadence-quadspi: Implement refcount to handle unbind during busy

Andrea Righi <arighi@nvidia.com>
    sched_ext: idle: Handle migration-disabled tasks in BPF code

Andrea Righi <arighi@nvidia.com>
    sched_ext: idle: Make local functions static in ext_idle.c

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: pcie: fix byte count table for some devices

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix byte count table for old devices

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Fix OOB access in font allocation

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    fbcon: fix integer overflow in fbcon_do_set_font

Akinobu Mita <akinobu.mita@gmail.com>
    mm/damon/sysfs: do not ignore callback's return value in damon_sysfs_damon_call()

Jinjiang Tu <tujinjiang@huawei.com>
    mm/hugetlb: fix folio is still mapped when deleted

Alexander Popov <alex.popov@linux.com>
    x86/Kconfig: Reenable PTDUMP on i386

Thomas Gleixner <tglx@linutronix.de>
    x86/topology: Implement topology_is_core_online() to address SMT regression

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Use an atomic xchg in pudp_huge_get_and_clear()

Max Kellermann <max.kellermann@ionos.com>
    netfs: fix reference leak

Eric Biggers <ebiggers@kernel.org>
    kmsan: fix out-of-bounds access to shadow memory

Hans de Goede <hansg@kernel.org>
    gpiolib: Extend software-node support to support secondary software-nodes

Jakub Acs <acsjakub@amazon.de>
    fs/proc/task_mmu: check p->vec_buf for NULL

Zhen Ni <zhen.ni@easystack.cn>
    afs: Fix potential null pointer dereference in afs_put_server

Jason Wang <jasowang@redhat.com>
    vhost-net: flush batched before enabling notifications

Michael S. Tsirkin <mst@redhat.com>
    Revert "vhost/net: Defer TX queue re-enable until after sendmsg"

Christian Marangi <ansuelsmth@gmail.com>
    pinctrl: airoha: fix wrong MDIO function bitmaks

Christian Marangi <ansuelsmth@gmail.com>
    pinctrl: airoha: fix wrong PHY LED mux value for LED1 GPIO46

Matthew Schwartz <matthew.schwartz@linux.dev>
    drm/amd/display: Only restore backlight after amdgpu_dm_init or dm_resume

Nirmoy Das <nirmoyd@nvidia.com>
    drm/ast: Use msleep instead of mdelay for edid read

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Don't copy pinned kernel bos twice on suspend

Josua Mayer <josua@solid-run.com>
    arm64: dts: marvell: cn9132-clearfog: fix multi-lane pci x2 and x4 ports

Josua Mayer <josua@solid-run.com>
    arm64: dts: marvell: cn9132-clearfog: disable eMMC high-speed modes

Josua Mayer <josua@solid-run.com>
    arm64: dts: marvell: cn913x-solidrun: fix sata ports status

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    ARM: dts: socfpga: sodia: Fix mdio bus probe and PHY address

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: fprobe: Fix to remove recorded module addresses from filter

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: fgraph: Protect return handler from recursion loop

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: dynevent: Add a missing lockdown check on dynevent

Eric Biggers <ebiggers@kernel.org>
    crypto: af_alg - Fix incorrect boolean values in af_alg_ctx

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: improve VF MAC filters accounting

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add mask to apply valid bits for itr_idx

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add max boundary check for VF filters

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix validation of VF state in get resources

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix input validation logic for action_meta

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in config queues msg

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: fix idx validation in i40e_validate_queue_map

Lukasz Czapnik <lukasz.czapnik@intel.com>
    i40e: add validation for ring_len param

Amit Chaudhari <amitchaudhari@mac.com>
    HID: asus: add support for missing PX series fn keys

Xinpeng Sun <xinpeng.sun@intel.com>
    HID: intel-thc-hid: intel-quickspi: Add WCL Device IDs

Wang Liang <wangliang74@huawei.com>
    tracing/osnoise: Fix slab-out-of-bounds in _parse_integer_limit()

Sasha Levin <sashal@kernel.org>
    Revert "drm/xe/guc: Enable extended CAT error reporting"

Sasha Levin <sashal@kernel.org>
    Revert "drm/xe/guc: Set RCS/CCS yield policy"

Sang-Heon Jeon <ekffu200098@gmail.com>
    smb: client: fix wrong index reference in smb2_compound_op()

Daniel Lee <dany97@live.ca>
    platform/x86: lg-laptop: Fix WMAB call in fan_mode_store()

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Defer scheduler entitiy destruction to queue release

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Use correct exit on failure from futex_hash_allocate_default()

Melissa Wen <mwen@igalia.com>
    drm/amd/display: remove output_tf_change flag

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/ddi: Guard reg_val against a INVALID_TRANSCODER

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Fix build with CONFIG_MODULES=n

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/vf: Don't expose sysfs attributes not applicable for VFs

Ioana Ciornei <ioana.ciornei@nxp.com>
    gpio: regmap: fix memory leak of gpio_regmap structure

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    futex: Prevent use-after-free during requeue-PI

Zabelin Nikita <n.zabelin@mt-integration.ru>
    drm/gma500: Fix null dereference in hdmi teardown

Dan Carpenter <dan.carpenter@linaro.org>
    octeontx2-pf: Fix potential use after free in otx2_tc_add_flow()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: suppress -EINVAL errors for bridge FDB entries added to the CPU port

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: lantiq_gswip: move gswip_add_single_port_br() call to port_setup()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix missing FEC RS stats for RS_544_514_INTERLEAVED_QUAD

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, ignore flow level for multi-dest table

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, remove unused create_dest_array parameter

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: fs, fix UAF in flow counter release

Ido Schimmel <idosch@nvidia.com>
    selftests: fib_nexthops: Fix creation of non-FDB nexthops

Ido Schimmel <idosch@nvidia.com>
    nexthop: Forbid FDB status change while nexthop is in a group

Jason Baron <jbaron@akamai.com>
    net: allow alloc_skb_with_frags() to use MAX_SKB_FRAGS

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnxt_en: correct offset handling for IPv6 destination address

Jacob Keller <jacob.e.keller@intel.com>
    broadcom: fix support for PTP_EXTTS_REQUEST2 ioctl

Jacob Keller <jacob.e.keller@intel.com>
    broadcom: fix support for PTP_PEROUT_DUTY_CYCLE

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible UAFs

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    vhost: Take a reference on the task in struct vhost_task.

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix UAF in hci_acl_create_conn_sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix UAF in hci_conn_tx_dequeue

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix hci_resume_advertising_sync

Petr Malat <oss@malat.biz>
    ethernet: rvu-af: Remove slash from the driver name

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix warning in smc_rx_splice() when calling get_page()

Wang Liang <wangliang74@huawei.com>
    net: tun: Update napi->skb after XDP process

Stéphane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix shift-out-of-bounds issue

Vincent Mailhol <mailhol@kernel.org>
    can: mcba_usb: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: sun4i_can: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: hi311x: populate ndo_change_mtu() to prevent buffer overflow

Vincent Mailhol <mailhol@kernel.org>
    can: etas_es58x: populate ndo_change_mtu() to prevent buffer overflow

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: fix offloading of cross-family tunnels

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: xfrm_alloc_spi shouldn't use 0 as SPI

Leon Hwang <leon.hwang@linux.dev>
    selftests/bpf: Skip timer cases when bpf_timer is not supported

Leon Hwang <leon.hwang@linux.dev>
    bpf: Reject bpf_timer for PREEMPT_RT

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_can: rcar_can_resume(): fix s2ram with PSCI

James Guan <guan_yufei@163.com>
    wifi: virt_wifi: Fix page fault on connect

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: correct mem limit calculation for small APUs

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix p2p links bug in topology

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Protect copy offload and clone against 'eof page pollution'

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Protect against 'eof page pollution'

Mark Harmstone <mark@harmstone.com>
    btrfs: don't allow adding block device of less than 1 MB

Xing Guo <higuoxing@gmail.com>
    selftests/fs/mount-notify: Fix compilation failure.

Jiri Olsa <olsajiri@gmail.com>
    bpf: Check the helper function is valid in get_helper_proto

Stefan Metzmacher <metze@samba.org>
    smb: server: use disable_work_sync in transport_rdma.c

Stefan Metzmacher <metze@samba.org>
    smb: server: don't use delayed_work for post_recv_credits_work

Christian Loehle <christian.loehle@arm.com>
    cpufreq: Initialize cpufreq-based invariance before subsys

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: kirkwood: Fix sound DAI cells for OpenRD clients

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp: Correct thermal sensor index

Peng Fan <peng.fan@nxp.com>
    firmware: imx: Add stub functions for SCMI CPU API

Peng Fan <peng.fan@nxp.com>
    firmware: imx: Add stub functions for SCMI LMM API

Peng Fan <peng.fan@nxp.com>
    firmware: imx: Add stub functions for SCMI MISC API

Jimmy Hon <honyuenkwun@gmail.com>
    arm64: dts: rockchip: Fix the headphone detection on the orangepi 5

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Add sync across amd sfh work functions

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    HID: cp2112: fix setter callbacks return value

Or Har-Toov <ohartoov@nvidia.com>
    IB/mlx5: Fix obj_type mismatch for SRQ event subscriptions

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: sfp: add quirk for FLYPRO copper SFP+ module

qaqland <anguoli@uniontech.com>
    ALSA: usb-audio: Add mute TLV for playback volumes on more devices

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: move mixer_quirks' min_mute into common quirk

Mario Limonciello (AMD) <superm1@kernel.org>
    gpiolib: acpi: Add quirk for ASUS ProArt PX13

noble.yang <noble.yang@comtrue-inc.com>
    ALSA: usb-audio: Add DSD support for Comtrue USB Audio device

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Add support for OneXPlayer X1 Mini Pro (Strix Point)

Balamurugan C <balamurugan.c@intel.com>
    ASoC: Intel: sof_rt5682: Add HDMI-In capture with rt5682 support for PTL.

Balamurugan C <balamurugan.c@intel.com>
    ASoC: Intel: soc-acpi: Add entry for HDMI_In capture support in PTL match table

Balamurugan C <balamurugan.c@intel.com>
    ASoC: Intel: soc-acpi: Add entry for sof_es8336 in PTL match table.

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    i2c: designware: Add quirk for Intel Xe

Benoît Monin <benoit.monin@bootlin.com>
    mmc: sdhci-cadence: add Mobileye eyeQ support

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    drm/panfrost: Add support for Mali on the MT8370 SoC

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    drm/panfrost: Commonize Mediatek power domain array definitions

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    drm/panfrost: Drop duplicated Mediatek supplies arrays

Chris Morgan <macromorgan@hotmail.com>
    net: sfp: add quirk for Potron SFP+ XGSPON ONU Stick

Marc Kleine-Budde <mkl@pengutronix.de>
    net: fec: rename struct fec_devinfo fec_imx6x_info -> fec_imx6sx_info

Jiayi Li <lijiayi@kylinos.cn>
    usb: core: Add 0x prefix to quirks debug output

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix build with CONFIG_INPUT=n

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for ASUS NUC using CS35L41 HDA

Chen Ni <nichen@iscas.ac.cn>
    ALSA: usb-audio: Convert comma to semicolon

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: specify that Apple Touch Bar is direct

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: take cls->maxcontacts into account for Apple Touch Bar even without a HID_DG_CONTACTMAX field

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: support getting the tip state from HID_DG_TOUCH fields in Apple Touch Bar

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: Get the contact ID from HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Add mixer quirk for Sony DualSense PS5

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Remove unneeded wmb() in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Simplify NULL comparison in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid multiple assignments in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix block comments in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix whitespace & blank line issues in mixer_quirks

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Fix code alignment in mixer_quirks

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix overlooked update of subsystem ABI version

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE


-------------

Diffstat:

 Documentation/admin-guide/laptops/lg-laptop.rst    |   4 +-
 Makefile                                           |   4 +-
 .../dts/intel/socfpga/socfpga_cyclone5_sodia.dts   |   6 +-
 .../boot/dts/marvell/kirkwood-openrd-client.dts    |   2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi          |   4 +-
 arch/arm64/boot/dts/marvell/cn9130-cf.dtsi         |   7 +-
 arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts |   6 +-
 arch/arm64/boot/dts/marvell/cn9132-clearfog.dts    |  22 +-
 arch/arm64/boot/dts/marvell/cn9132-sr-cex7.dtsi    |   8 +
 .../boot/dts/rockchip/rk3588s-orangepi-5.dtsi      |   3 +-
 arch/riscv/include/asm/pgtable.h                   |  17 +
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/topology.h                    |  10 +
 arch/x86/kernel/cpu/topology.c                     |  13 +
 drivers/cpufreq/cpufreq.c                          |  20 +-
 drivers/firewire/core-cdev.c                       |   2 +-
 drivers/gpio/gpio-regmap.c                         |   2 +-
 drivers/gpio/gpiolib-acpi-quirks.c                 |  14 +
 drivers/gpio/gpiolib.c                             |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  44 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  12 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   7 +
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 -
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   6 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   6 +-
 drivers/gpu/drm/ast/ast_dp.c                       |   2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi.c             |   2 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |   5 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c            |  61 ++-
 drivers/gpu/drm/panthor/panthor_sched.c            |   8 +-
 drivers/gpu/drm/xe/abi/guc_actions_abi.h           |   5 -
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h              |  40 --
 drivers/gpu/drm/xe/xe_bo_evict.c                   |   4 +-
 drivers/gpu/drm/xe/xe_configfs.c                   |   2 +-
 drivers/gpu/drm/xe/xe_device_sysfs.c               |   2 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   3 +-
 drivers/gpu/drm/xe/xe_guc.c                        |  62 +--
 drivers/gpu/drm/xe/xe_guc.h                        |   1 -
 drivers/gpu/drm/xe/xe_guc_submit.c                 |  87 +---
 drivers/gpu/drm/xe/xe_guc_submit.h                 |   2 -
 drivers/gpu/drm/xe/xe_uc.c                         |   4 -
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |  12 +-
 drivers/hid/amd-sfh-hid/amd_sfh_common.h           |   3 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   4 +
 drivers/hid/hid-asus.c                             |   3 +
 drivers/hid/hid-cp2112.c                           |  10 +-
 drivers/hid/hid-multitouch.c                       |  45 +-
 .../intel-thc-hid/intel-quickspi/pci-quickspi.c    |   2 +
 .../intel-thc-hid/intel-quickspi/quickspi-dev.h    |   2 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |   7 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   1 +
 drivers/iommu/iommufd/eventq.c                     |   9 +-
 drivers/iommu/iommufd/main.c                       |  35 +-
 drivers/mmc/host/sdhci-cadence.c                   |  11 +
 drivers/net/can/rcar/rcar_can.c                    |   8 +-
 drivers/net/can/spi/hi311x.c                       |   1 +
 drivers/net/can/sun4i_can.c                        |   1 +
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   3 +-
 drivers/net/can/usb/mcba_usb.c                     |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/dsa/lantiq_gswip.c                     |  21 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 110 ++--
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  25 +-
 .../mellanox/mlx5/core/steering/hws/action.c       |   7 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |  18 +-
 .../mellanox/mlx5/core/steering/hws/fs_hws_pools.c |   8 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h      |   7 +-
 drivers/net/phy/bcm-phy-ptp.c                      |   6 +-
 drivers/net/phy/sfp.c                              |  24 +-
 drivers/net/tun.c                                  |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   3 +-
 drivers/net/wireless/virtual/virt_wifi.c           |   4 +-
 drivers/pinctrl/mediatek/pinctrl-airoha.c          |  31 +-
 drivers/platform/x86/lg-laptop.c                   |  34 +-
 drivers/platform/x86/oxpec.c                       |   7 +
 drivers/spi/spi-cadence-quadspi.c                  |  90 +++-
 drivers/ufs/core/ufs-mcq.c                         |   4 +-
 drivers/usb/core/quirks.c                          |   2 +-
 drivers/vhost/net.c                                |  33 +-
 drivers/video/fbdev/core/fbcon.c                   |  13 +-
 fs/afs/server.c                                    |   3 +-
 fs/btrfs/volumes.c                                 |   5 +
 fs/hugetlbfs/inode.c                               |  10 +-
 fs/netfs/buffered_read.c                           |  10 +-
 fs/netfs/direct_read.c                             |   7 +-
 fs/netfs/direct_write.c                            |   6 +-
 fs/netfs/internal.h                                |   1 +
 fs/netfs/objects.c                                 |  30 +-
 fs/netfs/read_pgpriv2.c                            |   2 +-
 fs/netfs/read_single.c                             |   2 +-
 fs/netfs/write_issue.c                             |   3 +-
 fs/nfs/file.c                                      |  33 ++
 fs/nfs/inode.c                                     |   9 +-
 fs/nfs/internal.h                                  |   2 +
 fs/nfs/nfs42proc.c                                 |  33 +-
 fs/nfs/nfstrace.h                                  |   1 +
 fs/proc/task_mmu.c                                 |   3 +
 fs/smb/client/smb2inode.c                          |   2 +-
 fs/smb/server/transport_rdma.c                     |  22 +-
 include/crypto/if_alg.h                            |   2 +-
 include/linux/firmware/imx/sm.h                    |  47 ++
 include/linux/mlx5/fs.h                            |   2 +
 include/net/bluetooth/hci_core.h                   |  21 +
 kernel/bpf/core.c                                  |   5 +-
 kernel/bpf/verifier.c                              |   6 +-
 kernel/fork.c                                      |   2 +-
 kernel/futex/requeue.c                             |   6 +-
 kernel/sched/ext_idle.c                            |  52 +-
 kernel/sched/ext_idle.h                            |   7 -
 kernel/trace/fgraph.c                              |  12 +
 kernel/trace/fprobe.c                              |   7 +-
 kernel/trace/trace_dynevent.c                      |   4 +
 kernel/trace/trace_osnoise.c                       |   3 +-
 kernel/vhost_task.c                                |   3 +-
 mm/damon/sysfs.c                                   |   4 +-
 mm/kmsan/core.c                                    |  10 +-
 mm/kmsan/kmsan_test.c                              |  16 +
 net/bluetooth/hci_event.c                          |  30 +-
 net/bluetooth/hci_sync.c                           |   7 +
 net/bluetooth/mgmt.c                               | 259 +++++++---
 net/bluetooth/mgmt_util.c                          |  46 ++
 net/bluetooth/mgmt_util.h                          |   3 +
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/nexthop.c                                 |   7 +
 net/smc/smc_loopback.c                             |  14 +-
 net/xfrm/xfrm_device.c                             |   2 +-
 net/xfrm/xfrm_state.c                              |   3 +
 sound/pci/hda/patch_realtek.c                      |  11 +
 sound/soc/intel/boards/sof_es8336.c                |  10 +
 sound/soc/intel/boards/sof_rt5682.c                |   7 +
 sound/soc/intel/common/soc-acpi-intel-ptl-match.c  |  32 ++
 sound/usb/mixer_quirks.c                           | 571 +++++++++++++++------
 sound/usb/quirks.c                                 |  24 +-
 sound/usb/usbaudio.h                               |   4 +
 .../testing/selftests/bpf/prog_tests/free_timer.c  |   4 +
 tools/testing/selftests/bpf/prog_tests/timer.c     |   4 +
 .../testing/selftests/bpf/prog_tests/timer_crash.c |   4 +
 .../selftests/bpf/prog_tests/timer_lockup.c        |   4 +
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |   4 +
 .../filesystems/mount-notify/mount-notify_test.c   |  17 +-
 .../mount-notify/mount-notify_test_ns.c            |  18 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  12 +-
 153 files changed, 1833 insertions(+), 852 deletions(-)


