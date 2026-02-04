Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D108540758D;
	Wed,  4 Feb 2026 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216247; cv=none; b=gM3YEt0N1VORGr8sHHc50VlzoEso96zaK/lFz8x6ufb1Rb4YsTlsYNy6gMZAjdPuLQj9wvoX7iN70yIxPWw5z8JHuim64VH+E2Os+oPWDz8i45FyRO4CzDlAaVcUWf9quo33t9TTzy4hRp6faJ44Vu9F3Jk6JYLvYNTKbIRTuvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216247; c=relaxed/simple;
	bh=tvIbfkmtO8DCZt0uOiaR1tUVecYwzwfbgRh9sGjxgII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lqUEsDnJsVnzqOxwtNcSKKzwMbMsFDrvPyzmDJqpeyccPuB55vnvimZxO25jOPldJWOElP198A/FC0VGQa35gBeC4Tw8KfrysK5CGJLjeBCrl8A6ExIJ5Xf1meXHHXtYZ4KQJv1/zkHYkiA++M3i7Ufnpk4JwjwfXEsz6LFvVVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI/F/42q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI/F/42q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9896FC4CEF7;
	Wed,  4 Feb 2026 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216247;
	bh=tvIbfkmtO8DCZt0uOiaR1tUVecYwzwfbgRh9sGjxgII=;
	h=From:To:Cc:Subject:Date:From;
	b=BI/F/42qXHval0OrtoDPPjsNJ0Ua/IqhWz16noq/FEJrpsZUqVq02XfH5qmTmz0Oh
	 eSQr7Ggi0I4bCN96rQKm5r1jZFZrWEmHajWxXSsn0xSTZSf8oPboGN7DRADakvSLv4
	 Qt2GeKH8649UnWRBofWPxWag967j5Ye/OwfEPG8o=
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
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 5.10 000/161] 5.10.249-rc1 review
Date: Wed,  4 Feb 2026 15:37:43 +0100
Message-ID: <20260204143851.755002596@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.249-rc1
X-KernelTest-Deadline: 2026-02-06T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.249 release.
There are 161 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.249-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.249-rc1

Johan Hovold <johan@kernel.org>
    drm/imx/tve: fix probe device leak

Philipp Zabel <p.zabel@pengutronix.de>
    drm/imx: imx-tve: move initialization into probe

Philipp Zabel <p.zabel@pengutronix.de>
    drm/imx: imx-tve: use local encoder and connector variables

Henry Martin <bsdhenrymartin@gmail.com>
    HID: uclogic: Add NULL check in uclogic_input_configured()

Rahul Rameshbabu <sergeantsagara@protonmail.com>
    HID: uclogic: Correct devm device reference for hidinput input_dev name

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: meson: mark the GPIO controller as sleeping

Laveesh Bansal <laveeshb@laveeshbansal.com>
    writeback: fix 100% CPU usage when dirtytime_expire_interval is 0

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "selftests: Replace sleep with slowwait"

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: typo NULL check in _clone() function

Eric Biggers <ebiggers@kernel.org>
    ipv6: sr: Fix MAC comparison to be constant-time

Rob Herring (Arm) <robh@kernel.org>
    of: platform: Use default match table for /firmware

Marc Kleine-Budde <mkl@pengutronix.de>
    can: esd_usb: esd_usb_read_bulk_callback(): fix URB memory leak

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix getting range information for subdevices 16 to 255

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/amdkfd: fix a memory leak in device_queue_manager_init()

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

David Hildenbrand <david@redhat.com>
    mm/pagewalk: add walk_page_range_vma()

Yang Yingliang <yangyingliang@huawei.com>
    driver core: fix potential null-ptr-deref in device_add()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: trace: treat reg parameter as string

Johan Hovold <johan@kernel.org>
    iio: adc: exynos_adc: fix OF populate on driver rebind

Thorsten Blum <thorsten.blum@linux.dev>
    w1: therm: Fix off-by-one buffer overflow in alarms_store

Yang Guang <yang.guang5@zte.com.cn>
    w1: w1_therm: use swap() to make code cleaner

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    scsi: xen: scsiback: Fix potential memory leak in scsiback_remove()

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix device leak on route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: stm32: dmamux: fix OF node leak on route allocation failure

Brian Foster <bfoster@redhat.com>
    xfs: set max_agbno to allow sparse alloc of last full inode chunk

Nilay Shroff <nilay@linux.ibm.com>
    nvme: fix PCIe subsystem reset controller state transition

Keith Busch <kbusch@kernel.org>
    nvme-pci: do not directly handle subsys reset fallout

Daniel Wagner <dwagner@suse.de>
    nvme-fc: rename free_ctrl callback to match name pattern

Chen Ni <nichen@iscas.ac.cn>
    net/sched: act_ife: convert comma to semicolon

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()

Sai Sree Kartheek Adivi <s-adivi@ti.com>
    dma/pool: distinguish between missing and exhausted atomic pools

Kery Qi <qikeyu2017@gmail.com>
    scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()

Martin Kaiser <martin@kaiser.cx>
    net: bridge: fix static key check

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: nci: Fix race between rfkill and nci_unregister_device().

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Account for netdev stats in ndo_get_stats64

Yafang Shao <laoar.shao@gmail.com>
    net/mlx5e: Report rx_discards_phy via rx_dropped

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Expose rx_oversize_pkts_buffer counter

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: Add HW definitions of vport debug counters

Jesse Brandeburg <jbrandeburg@cloudflare.com>
    ice: stop counting UDP csum mismatch as rx_errors

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: llcp: Fix memleak in nfc_llcp_send_ui_frame().

Kery Qi <qikeyu2017@gmail.com>
    rocker: fix memory leak in rocker_world_port_post_fini()

Zilin Guan <zilin@seu.edu.cn>
    net: mvpp2: cls: Fix memory leak in mvpp2_ethtool_cls_rule_ins()

Zilin Guan <zilin@seu.edu.cn>
    net/mlx5: Fix memory leak in esw_acl_ingress_lgcy_setup()

Jia-Hong Su <s11242586@gmail.com>
    Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    fbcon: always restore the old font data in fbcon_do_set_font()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: fbcon: release buffer when fbcon_do_set_font() failed

Shigeru Yoshida <syoshida@redhat.com>
    fbdev: fbcon: Properly revert changes when vc_resize() failed

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject narrower access to pointer ctx fields

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Do not let BPF test infra emit invalid GSO types to stack

Matthew Wilcox (Oracle) <willy@infradead.org>
    migrate: correct lock ordering for hugetlb file folios

Marc Kleine-Budde <mkl@pengutronix.de>
    can: usb_8dev: usb_8dev_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcba_usb: mcba_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: kvaser_usb: kvaser_usb_read_bulk_callback(): fix URB memory leak

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ems_usb: ems_usb_read_bulk_callback(): fix URB memory leak

Arnd Bergmann <arnd@arndb.de>
    irqchip/gic-v3-its: Avoid truncating memory addresses

Fernand Sieber <sieberf@amazon.com>
    perf/x86/intel: Do not enable BTS for guests

Jeongjun Park <aha310510@gmail.com>
    netrom: fix double-free in nr_route_frame()

Chenghai Huang <huangchenghai2@huawei.com>
    uacce: ensure safe queue release with state management

Yang Shen <shenyang39@huawei.com>
    uacce: implement mremap in uacce_vm_ops to return -EPERM

Wenkai Lin <linwenkai6@hisilicon.com>
    uacce: fix cdev handling in the cleanup path

Johan Hovold <johan@kernel.org>
    intel_th: fix device leak on output open()

Johan Hovold <johan@kernel.org>
    slimbus: core: fix device reference leak on report present

Johan Hovold <johan@kernel.org>
    slimbus: core: fix runtime PM imbalance on report present

Thomas Fourier <fourier.thomas@gmail.com>
    octeontx2: Fix otx2_dma_map_page() error return code

Marek Vasut <marex@nabladev.com>
    wifi: rsi: Fix memory corruption due to not set vif driver data size

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: ath10k: fix dma_free_coherent() pointer

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: rtsx_pci_sdmmc: implement sdmmc_card_busy function

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix potential OOB access in audio mixer handling

Kübrich, Andreas <andreas.kuebrich@spektra-dresden.de>
    iio: dac: ad5686: add AD5695R to ad5686_chip_info_tbl

Pei Xiao <xiaopei01@kylinos.cn>
    iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver

Tomas Melin <tomas.melin@vaisala.com>
    iio: adc: ad9467: fix ad9434 vref mask

Weigang He <geoffreyhe2@gmail.com>
    of: fix reference count leak in of_alias_scan()

Hans de Goede <johannes.goede@oss.qualcomm.com>
    leds: led-class: Only Add LED to leds_list when it is fully ready

Eric Dumazet <edumazet@google.com>
    net/sched: act_ife: avoid possible NULL deref

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: Fix error handling

Eric Dumazet <edumazet@google.com>
    bonding: provide a net pointer to __skb_flow_dissect()

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: Fix NULL pointer dereference in be_cmd_get_mac_from_list

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Workaround SI powertune issue on Radeon 430 (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Don't clear SI SMC table when setting power limit

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Use managed PCI functions

Laurent Vivier <lvivier@redhat.com>
    usbnet: limit max_mtu based on device's hard_mtu

Eric Dumazet <edumazet@google.com>
    mISDN: annotate data-race around dev->work

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M

Arun Raghavan <arunr@valvesoftware.com>
    ALSA: usb: Increase volume range that triggers a warning

David Jeffery <djeffery@redhat.com>
    scsi: core: Wake up the error handler when final completions race against each other

Cheng-Yu Lee <cylee12@realtek.com>
    regmap: Fix race condition in hwspinlock irqsave routine

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    iio: adc: ad7280a: handle spi_setup() errors in probe()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    staging:iio:adc:ad7280a: Register define cleanup.

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: fix iio_chan_spec for sensors without event detection

Long Li <longli@microsoft.com>
    scsi: storvsc: Process unsupported MODE_SENSE_10

feng <alec.jiang@gmail.com>
    Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA

gongqi <550230171hxy@gmail.com>
    Input: i8042 - add quirks for MECHREVO Wujie 15X Pro

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    w1: fix redundant counter decrement in w1_attach_slave_device()

Ian Abbott <abbotti@mev.co.uk>
    comedi: dmm32at: serialize use of paged registers

Taeyang Lee <0wn@theori.io>
    crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: qfq: Use cl_is_active to determine whether class is active in qfq_rm_from_ag

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Enforce that teql can only be used as root qdisc

Dmitry Skorodumov <dskr99@gmail.com>
    ipvlan: Make the addrs_lock be per port

Eric Dumazet <edumazet@google.com>
    l2tp: avoid one data-race in l2tp_tunnel_del_work()

Kuniyuki Iwashima <kuniyu@google.com>
    fou: Don't allow 0 for FOU_ATTR_IPPROTO.

Jakub Kicinski <kuba@kernel.org>
    net: fou: use policy and operation tables generated from the spec

Jakub Kicinski <kuba@kernel.org>
    net: fou: rename the source for linking

Jakub Kicinski <kuba@kernel.org>
    netlink: add a proto specification for FOU

Kuniyuki Iwashima <kuniyu@google.com>
    gue: Fix skb memleak with inner IP protocol 0.

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: avoid misleading per-packet error log

Xin Long <lucien.xin@gmail.com>
    sctp: move SCTP_CMD_ASSOC_SHKEY right after SCTP_CMD_PEER_INIT

Zheng Yongjun <zhengyongjun3@huawei.com>
    sctp: sm_statefuns: Fix spelling mistakes

Ricardo B. Marlière <rbm@suse.com>
    selftests: net: fib-onlink-tests: Convert to use namespaces by default

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net: convert fib-onlink-tests.sh to run it in unique namespace

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: dm9601: remove broken SR9700 support

Wojtek Wasko <wwasko@nvidia.com>
    ptp: Add PHC file mode checks. Allow RO adjtime() without FMODE_WRITE.

Wojtek Wasko <wwasko@nvidia.com>
    posix-clock: Store file pointer in struct posix_clock_context

Linus Torvalds <torvalds@linux-foundation.org>
    Fix memory leak in posix_clock_open()

Xabier Marquiegui <reibax@gmail.com>
    posix-clock: introduce posix_clock_context concept

Martin Willi <martin@strongswan.org>
    macvlan: Fix leaking skb in source mode with nodst option

Robbie Ko <robbieko@synology.com>
    btrfs: fix deadlock in wait_current_trans() due to ignored transaction type

Johan Hovold <johan@kernel.org>
    dmaengine: ti: k3-udma: fix device leak on udma lookup

Johan Hovold <johan@kernel.org>
    dmaengine: ti: dma-crossbar: fix device leak on am335x route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: lpc18xx-dmamux: fix device leak on route allocation

Johan Hovold <johan@kernel.org>
    dmaengine: bcm-sba-raid: fix device leak on probe

Johan Hovold <johan@kernel.org>
    dmaengine: at_hdmac: fix device leak on of_dma_xlate()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    drm/vmwgfx: Fix an error return check in vmw_compat_shader_add()

Marek Vasut <marex@nabladev.com>
    drm/panel-simple: fix connector type for DataImage SCF0700C48GGU18 panel

Lyude Paul <lyude@redhat.com>
    drm/nouveau/disp/nv50-: Set lock_core in curs507a_prepare

Xiaochen Shen <shenxiaochen@open-hieco.net>
    x86/resctrl: Add missing resctrl initialization for Hygon

Xiaochen Shen <shenxiaochen@open-hieco.net>
    x86/resctrl: Fix memory bandwidth counter width for Hygon

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    EDAC/i3200: Fix a resource leak in i3200_probe1()

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    EDAC/x38: Fix a resource leak in x38_probe1()

Yang Erkun <yangerkun@huawei.com>
    ext4: fix iloc.bh leak in ext4_xattr_inode_update_ref

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    USB: serial: ftdi_sio: add support for PICAXE AXE027 cable

Ulrich Mohr <u.mohr@semex-engcon.com>
    USB: serial: option: add Telit LE910 MBIM composition

Huacai Chen <chenhuacai@loongson.cn>
    USB: OHCI/UHCI: Add soft dependencies on ehci_platform

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: Check for USB4 IP_NAME

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Explicitly configure HS_DISCON_LEVEL to 0x7

Louis Chauvet <louis.chauvet@bootlin.com>
    phy: rockchip: inno-usb2: fix disconnection in gadget mode

Luca Ceresoli <luca.ceresoli@bootlin.com>
    phy: rockchip: inno-usb2: fix communication disruption in gadget mode

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: can: j1939: j1939_xtp_rx_rts_session_active(): deactivate session upon receiving the second rts

Jaroslav Kysela <perex@perex.cz>
    ALSA: pcm: Improve the fix for race of buffer access at PCM OSS layer

Benjamin Tissoires <bentiss@kernel.org>
    HID: usbhid: paper over wrong bNumDescriptor field

Haotian Zhang <vulab@iscas.ac.cn>
    dmaengine: omap-dma: fix dma_pool resource leak in error paths

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    phy: broadcom: ns-usb3: Fix Wvoid-pointer-to-enum-cast warning (again)

Dan Carpenter <dan.carpenter@linaro.org>
    phy: stm32-usphyc: Fix off by one in probe()

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix uninitialized addr_width when "xlnx,addrwidth" property is missing

Sheetal <sheetal@nvidia.com>
    dmaengine: tegra-adma: Fix use-after-free

Bagas Sanjaya <bagasdotme@gmail.com>
    textsearch: describe @list member in ts_ops search

Emil Svendsen <emas@bang-olufsen.dk>
    ASoC: tlv320adcx140: fix word length

Eric Dumazet <edumazet@google.com>
    net/sched: sch_qfq: do not free existing class in qfq_change_class()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/test: add a final full barrier after run all tests

Eric Dumazet <edumazet@google.com>
    ipv4: ip_gre: make ipgre_header() robust

Eric Dumazet <edumazet@google.com>
    macvlan: fix possible UAF in macvlan_forward_source()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    macvlan: Use 'hash' iterators to simplify code

Jethro Beekman <kernel@jbeekman.nl>
    macvlan: Add nodst option to macvlan type source

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: use skb_vlan_inet_prepare() in __ip6_tnl_rcv()

Qu Wenruo <wqu@suse.com>
    btrfs: send: check for inline extents in range_is_hole_in_parent()

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvme-tcp: fix NULL pointer dereferences in nvmet_tcp_build_pdu_iovec

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: remove boilerplate code

Zilin Guan <zilin@seu.edu.cn>
    pnfs/flexfiles: Fix memory leak in nfs4_ff_alloc_deviceid_node()


-------------

Diffstat:

 Documentation/netlink/specs/fou.yaml               | 130 ++++++++++
 Makefile                                           |   4 +-
 arch/x86/events/perf_event.h                       |  13 +-
 arch/x86/kernel/cpu/resctrl/core.c                 |  21 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   3 +
 crypto/authencesn.c                                |   6 +
 drivers/base/core.c                                |   1 +
 drivers/base/regmap/regmap.c                       |   4 +-
 drivers/bluetooth/hci_ldisc.c                      |   4 +-
 drivers/dma/at_hdmac.c                             |   9 +-
 drivers/dma/bcm-sba-raid.c                         |   6 +-
 drivers/dma/lpc18xx-dmamux.c                       |  19 +-
 drivers/dma/stm32-dmamux.c                         |  22 +-
 drivers/dma/tegra210-adma.c                        |  10 +-
 drivers/dma/ti/dma-crossbar.c                      |  18 +-
 drivers/dma/ti/k3-udma-private.c                   |   2 +-
 drivers/dma/ti/omap-dma.c                          |   4 +
 drivers/dma/xilinx/xilinx_dma.c                    |   7 +-
 drivers/edac/i3200_edac.c                          |  11 +-
 drivers/edac/x38_edac.c                            |   9 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  18 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |  23 +-
 drivers/gpu/drm/imx/imx-tve.c                      |  70 ++---
 drivers/gpu/drm/nouveau/dispnv50/curs507a.c        |   1 +
 drivers/gpu/drm/panel/panel-simple.c               |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   4 +-
 drivers/hid/hid-uclogic-core.c                     |  12 +-
 drivers/hid/usbhid/hid-core.c                      |  17 +-
 drivers/hwtracing/intel_th/core.c                  |  19 +-
 drivers/iio/adc/ad9467.c                           |   2 +-
 drivers/iio/adc/at91-sama5d2_adc.c                 |   1 +
 drivers/iio/adc/exynos_adc.c                       |  13 +-
 drivers/iio/dac/ad5686.c                           |   6 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |  15 +-
 drivers/input/serio/i8042-acpipnpio.h              |  18 ++
 drivers/irqchip/irq-gic-v3-its.c                   |   8 +-
 drivers/isdn/mISDN/timerdev.c                      |  13 +-
 drivers/leds/led-class.c                           |  10 +-
 drivers/misc/mei/mei-trace.h                       |  18 +-
 drivers/misc/uacce/uacce.c                         |  42 ++-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  41 +++
 drivers/net/bonding/bond_main.c                    |   5 +-
 drivers/net/can/usb/ems_usb.c                      |   8 +-
 drivers/net/can/usb/esd_usb2.c                     |   9 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   9 +-
 drivers/net/can/usb/mcba_usb.c                     |   8 +-
 drivers/net/can/usb/usb_8dev.c                     |   8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   5 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   1 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  86 +++++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   4 +
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 drivers/net/ethernet/rocker/rocker_main.c          |   5 +-
 drivers/net/ipvlan/ipvlan.h                        |   2 +-
 drivers/net/ipvlan/ipvlan_core.c                   |  16 +-
 drivers/net/ipvlan/ipvlan_main.c                   |  49 ++--
 drivers/net/macvlan.c                              |  84 +++---
 drivers/net/usb/dm9601.c                           |   4 -
 drivers/net/usb/usbnet.c                           |   9 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  16 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 drivers/nvme/host/fabrics.c                        |  15 ++
 drivers/nvme/host/fabrics.h                        |   1 +
 drivers/nvme/host/fc.c                             |   5 +-
 drivers/nvme/host/nvme.h                           |  14 +-
 drivers/nvme/host/pci.c                            |  39 +++
 drivers/nvme/host/rdma.c                           |   1 +
 drivers/nvme/host/tcp.c                            |   1 +
 drivers/nvme/target/tcp.c                          |  28 +-
 drivers/of/base.c                                  |   8 +-
 drivers/of/platform.c                              |   2 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |   2 +-
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c      |  12 +-
 drivers/phy/st/phy-stm32-usbphyc.c                 |   2 +-
 drivers/phy/tegra/xusb-tegra186.c                  |   3 +
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/ptp/ptp_chardev.c                          |  37 ++-
 drivers/ptp/ptp_private.h                          |  16 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  20 +-
 drivers/scsi/scsi_error.c                          |  11 +-
 drivers/scsi/scsi_lib.c                            |   8 +
 drivers/scsi/storvsc_drv.c                         |   3 +-
 drivers/slimbus/core.c                             |  19 +-
 drivers/staging/comedi/comedi.h                    |   2 +-
 drivers/staging/comedi/comedi_fops.c               |   2 +-
 drivers/staging/comedi/drivers/dmm32at.c           |  32 ++-
 drivers/staging/comedi/range.c                     |   2 +-
 drivers/staging/iio/adc/ad7280a.c                  | 283 +++++++++++----------
 drivers/target/sbp/sbp_target.c                    |   4 +-
 drivers/usb/dwc3/core.c                            |   2 +
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/host/ohci-platform.c                   |   1 +
 drivers/usb/host/uhci-platform.c                   |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   2 +
 drivers/usb/serial/option.c                        |   1 +
 drivers/video/fbdev/core/fbcon.c                   |  34 ++-
 drivers/w1/slaves/w1_therm.c                       |  67 ++---
 drivers/w1/w1.c                                    |   2 -
 drivers/xen/xen-scsiback.c                         |   1 +
 fs/btrfs/send.c                                    |   2 +
 fs/btrfs/transaction.c                             |  11 +-
 fs/ext4/xattr.c                                    |   1 +
 fs/fs-writeback.c                                  |  14 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  11 +-
 include/linux/mlx5/mlx5_ifc.h                      |  27 +-
 include/linux/nvme.h                               |   3 +
 include/linux/pagewalk.h                           |   3 +
 include/linux/posix-clock.h                        |  39 ++-
 include/linux/textsearch.h                         |   1 +
 include/net/nfc/nfc.h                              |   2 +
 include/sound/pcm.h                                |   2 +-
 include/uapi/linux/if_link.h                       |   1 +
 kernel/bpf/cgroup.c                                |   8 +-
 kernel/dma/pool.c                                  |   7 +-
 kernel/time/posix-clock.c                          |  53 ++--
 mm/ksm.c                                           | 115 ++++++++-
 mm/migrate.c                                       |  14 +-
 mm/pagewalk.c                                      |  20 ++
 net/bpf/test_run.c                                 |   5 +
 net/bridge/br_input.c                              |   2 +-
 net/can/j1939/transport.c                          |  10 +-
 net/core/filter.c                                  |  25 +-
 net/ipv4/Makefile                                  |   1 +
 net/ipv4/{fou.c => fou_core.c}                     |  50 +---
 net/ipv4/fou_nl.c                                  |  48 ++++
 net/ipv4/fou_nl.h                                  |  25 ++
 net/ipv4/ip_gre.c                                  |  11 +-
 net/ipv6/ip6_tunnel.c                              |   2 +-
 net/ipv6/seg6_hmac.c                               |   3 +-
 net/l2tp/l2tp_core.c                               |   4 +-
 net/netfilter/nft_connlimit.c                      |   2 +-
 net/netrom/nr_route.c                              |  13 +-
 net/nfc/core.c                                     |  27 +-
 net/nfc/llcp_commands.c                            |  17 +-
 net/nfc/llcp_core.c                                |   4 +-
 net/nfc/nci/core.c                                 |   4 +-
 net/sched/act_ife.c                                |  12 +-
 net/sched/sch_qfq.c                                |   8 +-
 net/sched/sch_teql.c                               |   5 +
 net/sctp/sm_statefuns.c                            |  36 +--
 sound/core/oss/pcm_oss.c                           |   4 +-
 sound/core/pcm_native.c                            |   9 +-
 sound/pci/ctxfi/ctamixer.c                         |   2 +
 sound/soc/codecs/tlv320adcx140.c                   |   4 +-
 sound/usb/mixer.c                                  |  22 +-
 tools/testing/selftests/net/fcnal-test.sh          |   2 +-
 tools/testing/selftests/net/fib-onlink-tests.sh    |  76 +++---
 tools/testing/vsock/util.c                         |  12 +
 159 files changed, 1751 insertions(+), 769 deletions(-)


