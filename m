Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCF143AD7;
	Tue, 14 May 2024 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687239; cv=none; b=k97MwtdgPOutgmfnL99F63W9pY6eM0ag8fhH3+3QEOHMR0PpnUR66lksnYXfUhxQkqPAK7GS5OK4eCQhNpS2y08qBX6ouwXAz8PUblqU637cy6SDND/sMdlOKnKBN3cZ3SCaWf/mbUIPepL1FN107xofiDNDA0pkWONH7yM4C84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687239; c=relaxed/simple;
	bh=RsSqaWRzBTK/u4HJRzLtUiVJZONXpogqxcmlzrrCu80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iB38e8v8fhqNIZsaLzp+XxumPsYldg8qwCtfYOo7b1YBiZULPZtTueFoHL6zNsuSJjsYZHKaMPfxU80T9IykQIqMF6atjk+DBorYKMVfWH4aQbsVnLSfGdbOq7kqsSpQDAusMmsL+55Zg3TN82cWLlq2W920yEPFoQowOJJg9cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX/7SYCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX/7SYCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60A2C2BD10;
	Tue, 14 May 2024 11:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687239;
	bh=RsSqaWRzBTK/u4HJRzLtUiVJZONXpogqxcmlzrrCu80=;
	h=From:To:Cc:Subject:Date:From;
	b=lX/7SYCKvDLlf/Uzu0arueeV+hhXZAr9RwXQhGbLSXKZ+ZmSFW2MNGIhG5B8rrXJ8
	 w9wedNAxM280x9Zy01xXZWuNWDugKic71Jf/ICZa5/JEE5jSmpglns2r72wXKvnWlD
	 p7tbP/ezHtMiBMBOcBDsRUTLBuBMgfuIF2voQPn0=
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
Subject: [PATCH 5.10 000/111] 5.10.217-rc1 review
Date: Tue, 14 May 2024 12:18:58 +0200
Message-ID: <20240514100957.114746054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.217-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.217-rc1
X-KernelTest-Deadline: 2024-05-16T10:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.217 release.
There are 111 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.217-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.217-rc1

Johan Hovold <johan+linaro@kernel.org>
    regulator: core: fix debugfs creation regression

Lakshmi Yadlapati <lakshmiy@us.ibm.com>
    hwmon: (pmbus/ucd9000) Increase delay from 250 to 500us

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    net: fix out-of-bounds access in ops_init

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix invalid reads in fence signaled events

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add lunar lake point M DID

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix old BUG_ON in >control parser

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix DSPK 16-bit playback

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()

Paolo Abeni <pabeni@redhat.com>
    tipc: fix UAF in error path

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Interrupt handling fixes

Ramona Gradinariu <ramona.bolboaca13@gmail.com>
    iio:imu: adis16475: Fix sync mode setting

Aman Dhoot <amandhoot12@gmail.com>
    ALSA: hda/realtek: Fix mute led of HP Laptop 15-da3001TU

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Prevent phy suspend during init

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: xhci-plat: Don't include xhci.h

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: f_fs: Fix a race condition when processing setup packets.

Peter Korsgaard <peter@korsgaard.com>
    usb: gadget: composite: fix OS descriptors w_value logic

Guenter Roeck <linux@roeck-us.net>
    usb: ohci: Prevent missed ohci interrupts

Alan Stern <stern@rowland.harvard.edu>
    usb: Fix regression caused by invalid ep0 maxpacket in virtual SuperSpeed device

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Fix connector check on init

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Check for notifications after init

Rob Herring <robh@kernel.org>
    arm64: dts: qcom: Fix 'interrupt-map' parent address cells

Thanassis Avgerinos <thanassis.avgerinos@gmail.com>
    firewire: nosy: ensure user_length is taken into account when fetching packet contents

Dmitry Antipov <dmantipov@yandex.ru>
    btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: use appropriate barrier function after setting a bit value

Eric Dumazet <edumazet@google.com>
    ipv6: fib6_rules: avoid possible NULL dereference in fib6_rule_action()

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix corrupted ethernet header on multicast-to-unicast

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    kcov: Remove kcov include from sched.h and move it to its users.

Eric Dumazet <edumazet@google.com>
    phonet: fix rtm_phonet_notify() skb allocation

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (corsair-cpro) Protect ccp->wait_input_report with a spinlock

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (corsair-cpro) Use a separate buffer for sending commands

Roded Zats <rzats@paloaltonetworks.com>
    rtnetlink: Correct nested IFLA_VF_VLAN_LIST attribute validation

Duoming Zhou <duoming@zju.edu.cn>
    Bluetooth: l2cap: fix null-ptr-deref in l2cap_chan_timeout

Duoming Zhou <duoming@zju.edu.cn>
    Bluetooth: Fix use-after-free bugs caused by sco_sock_timeout

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Use refcount_inc_not_zero() in tcp_twsk_unique().

Eric Dumazet <edumazet@google.com>
    tcp: defer shutdown(SEND_SHUTDOWN) for TCP_SYN_RECV sockets

Paul Davey <paul.davey@alliedtelesis.co.nz>
    xfrm: Preserve vlan tags for transport mode software GRO

Neil Armstrong <narmstrong@baylibre.com>
    ASoC: meson: axg-tdm-interface: Fix formatters in trigger"

Neil Armstrong <narmstrong@baylibre.com>
    ASoC: meson: axg-card: Fix nonatomic links

Vanillan Wang <vanillanwang@163.com>
    net:usb:qmi_wwan: support Rolling modules

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dp: Don't probe eDP ports twice harder

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: drop inodes immediately on non-.L too

Stephen Boyd <sboyd@kernel.org>
    clk: Don't hold prepare_lock when calling kref_put()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: crystalcove: Use -ENOTSUPP consistently

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: wcove: Use -ENOTSUPP consistently

Jeff Layton <jlayton@kernel.org>
    9p: explicitly deny setlease attempts

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: translate O_TRUNC into OTRUNC

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: only translate RWX permissions for plain 9P2000

John Stultz <jstultz@google.com>
    selftests: timers: Fix valid-adjtimex signed left-shift undefined behavior

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: scall: Save thread_info.syscall unconditionally on entry

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Do not setup DMA for virtual devices

Rik van Riel <riel@surriel.com>
    blk-iocost: avoid out of bounds shift

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix SELinux error when systemd-modules loads the target module

Boris Burkov <boris@bur.io>
    btrfs: always clear PERTRANS metadata during commit

Boris Burkov <boris@bur.io>
    btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve

Peng Liu <liupeng17@lenovo.com>
    tools/power turbostat: Fix Bzy_MHz documentation typo

Doug Smythies <dsmythies@telus.net>
    tools/power turbostat: Fix added raw MSR output

Adam Goldman <adamg@pobox.com>
    firewire: ohci: mask bus reset interrupts between ISR and bottom half

Chen Ni <nichen@iscas.ac.cn>
    ata: sata_gemini: Check clk_enable() result

Phil Elwell <phil@raspberrypi.com>
    net: bcmgenet: Reset RBUF on first open

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Zero-initialize message buffers

Anand Jain <anand.jain@oracle.com>
    btrfs: return accurate error code on open failure in open_fs_devices()

Saurav Kashyap <skashyap@marvell.com>
    scsi: bnx2fc: Remove spin_lock_bh while releasing resources after upload

linke li <lilinke99@qq.com>
    net: mark racy access on sk->sk_rcvbuf

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix rdev_dump_mpp() arguments order

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: mac80211: fix ieee80211_bss_*_flags kernel-doc

Andrew Price <anprice@redhat.com>
    gfs2: Fix invalid metadata access in punch_hole

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Update lpfc_ramp_down_queue_handler() logic

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id

Jernej Skrabec <jernej.skrabec@gmail.com>
    clk: sunxi-ng: h6: Reparent CPUX during PLL CPUX rate change

Richard Gobert <richardbgobert@gmail.com>
    net: gro: add flush check in udp_gro_receive_segment

Xin Long <lucien.xin@gmail.com>
    tipc: fix a possible memleak in tipc_buf_append

Felix Fietkau <nbd@nbd.name>
    net: core: reject skb_copy(_expand) for fraglist GSO skbs

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix multicast-to-unicast with fraglist GSO

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    cxgb4: Properly lock TX queue for the selftest.

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: cards: select SND_DYNAMIC_MINORS

Geert Uytterhoeven <geert@linux-m68k.org>
    ASoC: Fix 7/8 spaces indentation in Kconfig

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: manage formatters in trigger

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-card: make links nonatomic

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_actions()

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flow_spec

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flower

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: sanitize 'rc' in qede_add_tc_flower_fltr()

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Add CFI for RA register to asm macro vdso_func

David Bauer <mail@david-bauer.net>
    net l2tp: drop flow hash on forward

Kuniyuki Iwashima <kuniyu@amazon.com>
    nsh: Restore skb->{protocol,data,mac_header} for outer header in nsh_gso_segment().

Bui Quang Minh <minhquangbui99@gmail.com>
    octeontx2-af: avoid off-by-one read from userspace

Bui Quang Minh <minhquangbui99@gmail.com>
    bna: ensure the copied buf is NUL terminated

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix clearing storage keys for huge pages

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix storage key clearing for guest huge pages

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    regulator: mt6360: De-capitalize devicetree regulator subnodes

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()

Arnd Bergmann <arnd@arndb.de>
    power: rt9455: hide unused rt9455_boost_voltage_values

Kuniyuki Iwashima <kuniyu@amazon.com>
    nfs: Handle error of rpc_proc_register() in nfs_net_init().

Josef Bacik <josef@toxicpanda.com>
    nfs: make the rpc_stat per net namespace

Josef Bacik <josef@toxicpanda.com>
    nfs: expose /proc/net/sunrpc/nfs in net namespaces

Josef Bacik <josef@toxicpanda.com>
    sunrpc: add a struct rpc_stats arg to rpc_create_args

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix PIN_CONFIG_INPUT_SCHMITT_ENABLE readback

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Rework mtk_pinconf_{get,set} switch/case logic

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: core: delete incorrect free in pinctrl_enable()

Jan Dakinevich <jan.dakinevich@salutedevices.com>
    pinctrl/meson: fix typo in PDM's pin name

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: pinctrl-aspeed-g6: Fix register offset for pinconf of GPIOR-T

Daniel Okazaki <dtokazaki@google.com>
    eeprom: at24: fix memory corruption race condition

Heiner Kallweit <hkallweit1@gmail.com>
    eeprom: at24: Probe for DDR3 thermal sensor in the SPD case

Alexander Stein <alexander.stein@ew.tq-group.com>
    eeprom: at24: Use dev_err_probe for nvmem register failure

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't free NULL coalescing rule

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"

Bumyong Lee <bumyong.lee@samsung.com>
    dmaengine: pl330: issue_pending waits until WFP state


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |   8 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  16 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  12 +-
 arch/mips/include/asm/ptrace.h                     |   2 +-
 arch/mips/kernel/asm-offsets.c                     |   1 +
 arch/mips/kernel/ptrace.c                          |  15 +-
 arch/mips/kernel/scall32-o32.S                     |  23 +--
 arch/mips/kernel/scall64-n32.S                     |   3 +-
 arch/mips/kernel/scall64-n64.S                     |   3 +-
 arch/mips/kernel/scall64-o32.S                     |  33 ++--
 arch/s390/include/asm/dwarf.h                      |   1 +
 arch/s390/kernel/vdso64/vdso_user_wrapper.S        |   2 +
 arch/s390/mm/gmap.c                                |   2 +-
 arch/s390/mm/hugetlbpage.c                         |   2 +-
 block/blk-iocost.c                                 |   7 +-
 drivers/ata/sata_gemini.c                          |   5 +-
 drivers/clk/clk.c                                  |  12 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |  19 ++-
 drivers/firewire/nosy.c                            |   6 +-
 drivers/firewire/ohci.c                            |   6 +-
 drivers/gpio/gpio-crystalcove.c                    |   2 +-
 drivers/gpio/gpio-wcove.c                          |   2 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |   2 +-
 drivers/gpu/host1x/bus.c                           |   8 -
 drivers/hwmon/corsair-cpro.c                       |  43 +++--
 drivers/hwmon/pmbus/ucd9000.c                      |   6 +-
 drivers/iio/accel/mxc4005.c                        |  24 ++-
 drivers/iio/imu/adis16475.c                        |   4 +-
 drivers/misc/eeprom/at24.c                         |  46 +++++-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  20 ++-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c    |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   3 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  14 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  34 ++--
 drivers/pinctrl/core.c                             |   8 +-
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           | 180 +++++++++------------
 drivers/pinctrl/meson/pinctrl-meson-a1.c           |   6 +-
 drivers/power/supply/rt9455_charger.c              |   2 +
 drivers/regulator/core.c                           |  27 ++--
 drivers/regulator/mt6360-regulator.c               |  32 ++--
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   2 -
 drivers/scsi/lpfc/lpfc.h                           |   1 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |  13 +-
 drivers/target/target_core_configfs.c              |  12 ++
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/dwc3/core.c                            |  90 +++++------
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/gadget.c                          |   2 +
 drivers/usb/dwc3/host.c                            |  27 ++++
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/function/f_fs.c                 |   2 +-
 drivers/usb/host/ohci-hcd.c                        |   8 +
 drivers/usb/host/xhci-plat.h                       |   4 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  12 +-
 drivers/usb/usbip/usbip_common.h                   |   1 +
 fs/9p/vfs_file.c                                   |   2 +
 fs/9p/vfs_inode.c                                  |   5 +-
 fs/9p/vfs_super.c                                  |   1 +
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/send.c                                    |   4 +-
 fs/btrfs/transaction.c                             |   2 +-
 fs/btrfs/volumes.c                                 |  17 +-
 fs/gfs2/bmap.c                                     |   5 +-
 fs/nfs/client.c                                    |   5 +-
 fs/nfs/inode.c                                     |  13 +-
 fs/nfs/internal.h                                  |   2 -
 fs/nfs/netns.h                                     |   2 +
 include/linux/kcov.h                               |   1 +
 include/linux/sched.h                              |   1 -
 include/linux/skbuff.h                             |  15 ++
 include/linux/sunrpc/clnt.h                        |   1 +
 include/net/xfrm.h                                 |   3 +
 lib/dynamic_debug.c                                |   6 +-
 net/bluetooth/l2cap_core.c                         |   3 +
 net/bluetooth/sco.c                                |   4 +
 net/bridge/br_forward.c                            |   9 +-
 net/core/net_namespace.c                           |  13 +-
 net/core/rtnetlink.c                               |   2 +-
 net/core/skbuff.c                                  |  28 +++-
 net/core/sock.c                                    |   4 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv4/tcp_ipv4.c                                |   8 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/udp_offload.c                             |  12 +-
 net/ipv4/xfrm4_input.c                             |   6 +-
 net/ipv6/fib6_rules.c                              |   6 +-
 net/ipv6/xfrm6_input.c                             |   6 +-
 net/l2tp/l2tp_eth.c                                |   3 +
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mac80211/iface.c                               |   1 +
 net/mac80211/rx.c                                  |   1 +
 net/nsh/nsh.c                                      |  14 +-
 net/phonet/pn_netlink.c                            |   2 +-
 net/sunrpc/clnt.c                                  |   5 +-
 net/tipc/msg.c                                     |   8 +-
 net/wireless/nl80211.c                             |   2 +
 net/wireless/trace.h                               |   2 +-
 net/xfrm/xfrm_input.c                              |   8 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/Kconfig                           |  18 +--
 sound/soc/generic/Kconfig                          |   2 +-
 sound/soc/intel/boards/Kconfig                     |   2 +-
 sound/soc/meson/Kconfig                            |   3 +-
 sound/soc/pxa/Kconfig                              |  14 +-
 sound/soc/tegra/tegra186_dspk.c                    |   7 +-
 sound/usb/line6/driver.c                           |   6 +-
 tools/power/x86/turbostat/turbostat.8              |   2 +-
 tools/power/x86/turbostat/turbostat.c              |   7 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |  73 +++++----
 120 files changed, 754 insertions(+), 509 deletions(-)


