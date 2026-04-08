Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1723A16A0;
	Wed,  8 Apr 2026 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672506; cv=none; b=UT30da5rWb/dND335D1Deix7rglBw/a+AeI3P7HSN17+cb11QGMbK438dI05wC+duTH4KKGKRH0auxcORQkupbhOUitliTq/16AwwSrCI3bbj7eB2hqrINN/e4DeXDxxkqFSZdl7RPovixiiCXTg7Vff0S20oaFS4jSCrZg5tG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672506; c=relaxed/simple;
	bh=9NTVMyL1CgceWBVYZNQFSiptkMZ8dIzpD4Wf6uxTkRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OWoCyiyqFdPDTXWDBNvn5xZEFiUclebpJGvlPQf058xHXA5ubvAY5hI6aP872cUOPePq5HTE2GMNXeXx20zmZLWfRTAWrlQ1AP4SLACaWmlaBjuEKIq7PWo44C5zSawU/m0z0cpmp+VirxDT+ha7ClSC3PQ2eOf2OfYQM/ydESY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLRer8eL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLRer8eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CE9C19421;
	Wed,  8 Apr 2026 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672506;
	bh=9NTVMyL1CgceWBVYZNQFSiptkMZ8dIzpD4Wf6uxTkRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=wLRer8eLpgaQrZY8rbeYzDMF1GlNOrmatiUUOrKIIvOaD3kyRsCrJWJx5kjGvMNHs
	 U5lsEe3FbjsmyKDGu8k0nsrpTq8iDu11iBf/vv6/S5a4N0I+bbjLm+jXb294KIPSzF
	 55Yk6Ts+VFga2GzQCnvGaohSslSH9Jn078vCDc88=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.6 000/160] 6.6.134-rc1 review
Date: Wed,  8 Apr 2026 20:01:27 +0200
Message-ID: <20260408175913.177092714@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.134-rc1
X-KernelTest-Deadline: 2026-04-10T17:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.134 release.
There are 160 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.134-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.134-rc1

Marek Behún <kabel@kernel.org>
    net: sfp: Fix Ubiquiti U-Fiber Instant SFP module on mvneta

Li Xiasong <lixiasong1@huawei.com>
    MPTCP: fix lock class name family in pm_nl_create_listen_socket

Theodore Ts'o <tytso@mit.edu>
    ext4: handle wraparound when searching for blocks for indirect mapped blocks

Li Chen <me@linux.beauty>
    ext4: publish jinode after initialization

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: fix channel parameter config for fixed channel requests

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: change to guard(mutex) within fsl_edma3_xlate()

Nikunj A Dadhania <nikunj@amd.com>
    x86/cpu: Enable FSGSBASE early in cpu_init_exception_handling()

Jinjiang Tu <tujinjiang@huawei.com>
    mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Josef Bacik <josef@toxicpanda.com>
    scsi: target: tcm_loop: Drain commands in target_reset handler

Guangshuo Li <lgs201920130244@gmail.com>
    net: mana: fix use-after-free in add_adev() error path

Willem de Bruijn <willemb@google.com>
    net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback

Kevin Hao <haokexin@gmail.com>
    net: macb: Move devm_{free,request}_irq() out of spin lock area

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch when turning buffer off

Alexander Popov <alex.popov@linux.com>
    wifi: virt_wifi: remove SET_NETDEV_DEV to avoid use-after-free

Taegu Ha <hataegu0826@gmail.com>
    usb: gadget: f_uac1_legacy: validate control request size

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Protect RNDIS options with mutex

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_subset: Fix unbalanced refcnt in geth_free

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: uvc: fix NULL pointer dereference during unbind race

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_ether: Fix race between gether_disconnect and eth_stop

Xi Ruoyao <xry111@xry111.site>
    LoongArch: vDSO: Emit GNU_EH_FRAME correctly

Andrew Price <anprice@redhat.com>
    gfs2: Validate i_depth for exhash directories

Andrew Price <anprice@redhat.com>
    gfs2: Improve gfs2_consist_inode() usage

Filipe Manana <fdmanana@suse.com>
    btrfs: do not free data reservation in fallback from inline due to -ENOSPC

Qu Wenruo <wqu@suse.com>
    btrfs: fix the qgroup data free range for inline data extents

Sebastian Urban <surban@surban.net>
    usb: gadget: dummy_hcd: fix premature URB completion when ZLP follows partial transfer

Alan Stern <stern@rowland.harvard.edu>
    USB: dummy-hcd: Fix interrupt synchronization error

Alan Stern <stern@rowland.harvard.edu>
    USB: dummy-hcd: Fix locking/synchronization error

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    thunderbolt: Fix property read in nhi_wake_supported()

Xingjing Deng <micro6947@gmail.com>
    misc: fastrpc: possible double-free of cctx->remote_heap

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix thermal zone device registration error path

Shenwei Wang <shenwei.wang@nxp.com>
    gpio: mxc: map Both Edge pad wakeup to Rising Edge

Guangshuo Li <lgs201920130244@gmail.com>
    cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path

Yufan Chen <yufan.chen@linux.dev>
    net: ftgmac100: fix ring allocation unwind on open failure

Yang Yang <n05ec@lzu.edu.cn>
    vxlan: validate ND option lengths in vxlan_na_create

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    counter: rz-mtu3-cnt: do not use struct rz_mtu3_channel's dev member

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    counter: rz-mtu3-cnt: prevent counter from being toggled multiple times

Yifan Wu <yifanwucs@gmail.com>
    netfilter: ipset: drop logically empty buckets in mtype_del

Christian Eggers <ceggers@arri.de>
    nvmem: imx: assign nvmem_cell_info::raw_len

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: connector: add pd-disable dependency

Ian Abbott <abbotti@mev.co.uk>
    comedi: me4000: Fix potential overrun of firmware buffer

Ian Abbott <abbotti@mev.co.uk>
    comedi: me_daq: Fix potential overrun of firmware buffer

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_atmio16d: Fix invalid clean-up after failed attach

Ian Abbott <abbotti@mev.co.uk>
    comedi: Reinit dev->spinlock between attachments to low-level drivers

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: dt2815: add hardware detection to prevent crash

Oliver Neukum <oneukum@suse.com>
    cdc-acm: new quirk for EPSON HMD

Yang Yang <n05ec@lzu.edu.cn>
    bridge: br_nd_send: validate ND option lengths

Miaohe Lin <linmiaohe@huawei.com>
    fork: defer linking file vma until vma is fully initialized

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Insert full vma on mmap'd MMIO fault

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Use unmap_mapping_range()

Alex Williamson <alex.williamson@redhat.com>
    vfio: Create vfio_fs_type with inode per device

Yongchao Wu <yongchao.wu@autochips.com>
    usb: cdns3: gadget: fix state inconsistency on gadget init failure

Yongchao Wu <yongchao.wu@autochips.com>
    usb: cdns3: gadget: fix NULL pointer dereference in ep_queue

Juno Choi <juno.choi@lge.com>
    usb: dwc2: gadget: Fix spin_lock/unlock mismatch in dwc2_hsotg_udc_stop()

Justin Chen <justin.chen@broadcom.com>
    usb: ehci-brcm: fix sleep during atomic

Heitor Alves de Siqueira <halves@igalia.com>
    usb: usbtmc: Flush anchored URBs in usbtmc_release

Guangshuo Li <lgs201920130244@gmail.com>
    usb: ulpi: fix double free in ulpi_register_interface() error path

Miao Li <limiao@kylinos.cn>
    usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix out-of-sequence free_irq()

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Move iio_device_register() to correct location

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix irq resource leak

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix incorrect free_irq() variable

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Set FIFO ODR for accelerometer and gyroscope only

Josh Poimboeuf <jpoimboe@kernel.org>
    iio: imu: bmi160: Remove potential undefined behavior in bmi160_config_pin()

David Lechner <dlechner@baylibre.com>
    iio: light: vcnl4035: fix scan buffer on big-endian

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: dac: ad5770r: fix error return in ad5770r_read_raw()

Valek Andrej <andrej.v@skyrain.eu>
    iio: accel: fix ADXL355 temperature signature value

Zoltan Illes <zoliviragh@gmail.com>
    Input: xpad - add support for Razer Wolverine V3 Pro

Shengyu Qu <wiagn233@outlook.com>
    Input: xpad - add support for BETOP BTP-KP50B/C controller's wireless mode

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max 16 Gen10 AMD to i8042 quirk table

Bart Van Assche <bvanassche@acm.org>
    Input: synaptics-rmi4 - fix a locking bug in an error path

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-adc161s626: use DMA-safe memory for spi_read()

JP Hein <jp@jphein.com>
    USB: core: add NO_LPM quirk for Razer Kiyo Pro webcam

Wanquan Zhong <wanquan.zhong@fibocom.com>
    USB: serial: option: add support for Rolling Wireless RW135R-GL

Frej Drejhammar <frej@stacken.kth.se>
    USB: serial: io_edgeport: add support for Blackbox IC135A

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dp: Use crtc_state->enhanced_framing properly on ivb/hsw CPU eDP

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: dp501: Fix initialization of SCU2C

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-adc161s626: fix buffer read on big-endian

Stefan Wiehler <stefan.wiehler@nokia.com>
    mips: mm: Allocate tlb_vpn array atomically

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix division by zero in occ_show_power_1()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix the GCC version check for `__multi3' workaround

Oleh Konko <security@1seal.org>
    Bluetooth: SMP: force responder MITM requirements before building the pairing response

Oleh Konko <security@1seal.org>
    Bluetooth: SMP: derive legacy responder STK authentication from MITM state

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix missing SPDIFI1 index handling

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: caiaq: fix stack out-of-bounds read in init_card

Ernestas Kulik <ernestas.k@iconn-networks.com>
    USB: serial: option: add MeiG Smart SRM825WN

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/ioc32: stop speculation on the drm_compat_ioctl path

Paul Walmsley <pjw@kernel.org>
    riscv: kgdb: fix several debug register assignment bugs

Shiji Yang <yangshiji66@outlook.com>
    mips: ralink: update CPU clock index

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix missing newline in occ_show_extended()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (tps53679) Fix device ID comparison and printing in tps53676_identify()

Jamie Gibbons <jamie.gibbons@microchip.com>
    dt-bindings: gpio: fix microchip #interrupt-cells

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pxe1610) Check return value of page-select write in probe

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Handle DBC deactivation if the owner went away

David Lechner <dlechner@baylibre.com>
    iio: imu: bno055: fix BNO055_SCAN_CH_COUNT off by one

Qi Tang <tpluszz77@gmail.com>
    bpf: reject direct access to nullable PTR_TO_BUF pointers

Eric Dumazet <edumazet@google.com>
    ipv6: avoid overflows in ip6_datagram_send_ctl()

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: fix VLAN add unwind on slave errors

Xiang Mei <xmei5@asu.edu>
    net/sched: cls_flow: fix NULL pointer dereference on shared blocks

Xiang Mei <xmei5@asu.edu>
    net/sched: cls_fw: fix NULL pointer dereference on shared blocks

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix overflow when accumulating packets

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix potential double free of skb

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: Avoid "No data available" when FW version queries fail

Shay Drory <shayd@nvidia.com>
    net/mlx5: lag: Check for LAG device before creating debugfs

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: properly unregister fixed rate clocks

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix clk handling on PCI glue driver removal

Yucheng Lu <kanolyc@gmail.com>
    net/sched: sch_netem: fix out-of-bounds access in packet corruption

Kuniyuki Iwashima <kuniyu@google.com>
    bpf: sockmap: Fix use-after-free of sk->sk_socket in sk_psock_verdict_data_ready().

Weiming Shi <bestswngs@gmail.com>
    rds: ib: reject FRMR registration before IB connection is established

Keenan Dong <keenanat2000@gmail.com>
    Bluetooth: MGMT: validate mesh send advertising payload length

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: fix potential UAF in hci_le_remote_conn_param_req_evt

Keenan Dong <keenanat2000@gmail.com>
    Bluetooth: MGMT: validate LTK enc_size on load

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: SCO: fix race conditions in sco_sock_connect()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject immediate NF_QUEUE verdict

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: ignore explicit helper on new expectations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: store netns and zone in expectation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use expect->helper

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: honor expectation helper field

Qi Tang <tpluszz77@gmail.com>
    netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent

Qi Tang <tpluszz77@gmail.com>
    netfilter: nf_conntrack_helper: pass helper to expect cleanup

Florian Westphal <fw@strlen.de>
    netfilter: ipset: use nla_strcmp for IPSET_ATTR_NAME attr

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: ensure names are nul-terminated

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: account for netlink header size

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: strictly check for maximum number of actions

Zhengchuan Liang <zcliangcn@gmail.com>
    net: ipv6: flowlabel: defer exclusive option free until RCU teardown

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix regsafe() for pointers to packet

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Correct BD length masks to match AXIDMA IP spec

Pengpeng Hou <pengpeng@iscas.ac.cn>
    NFC: pn533: bound the UART receive buffer

Yochai Eisenrich <echelonh@gmail.com>
    net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak

Paolo Abeni <pabeni@redhat.com>
    ipv6: prevent possible UaF in addrconf_permanent_addr()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: ep93xx: Fix unchecked clk_prepare_enable() and add rollback on failure

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_hfsc: fix divide-by-zero in rtsc_min()

Yang Yang <n05ec@lzu.edu.cn>
    bridge: br_nd_send: linearize skb before parsing ND options

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: clear skb2->cb[] in ip4ip6_err()

Eric Dumazet <edumazet@google.com>
    ipv6: icmp: clear skb2->cb[] in ip6_err_gen_icmpv6_unreach()

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    tg3: Fix race for querying speed/duplex

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net/ipv6: ioam6: prevent schema length wraparound in trace fill

Yochai Eisenrich <echelonh@gmail.com>
    net: ipv6: ndisc: fix ndisc_ra_useropt to initialize nduseropt_padX fields to zero to prevent an info-leak

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak

Buday Csaba <buday.csaba@prolan.hu>
    net: fec: fix the PTP periodic output sysfs interface

Norbert Szetei <norbert@doyensec.com>
    crypto: af-alg - fix NULL pointer dereference in scatterwalk

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix overflow on long hmac keys

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix DMA corruption on long hmac keys

Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
    wifi: ath11k: Pass the correct value of each TID during a stop AMPDU session

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath11k: Use dma_alloc_noncoherent for rx_tid buffer allocation

Venkateswara Naralasetty <quic_vnaralas@quicinc.com>
    wifi: ath11k: skip status ring entry processing

Frank Li <Frank.Li@nxp.com>
    dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: geni-qcom: Check DMA interrupts early in ISR

ZhengYuan Huang <gality369@gmail.com>
    btrfs: reject root items with drop_progress and zero drop_level

Mikko Perttunen <mperttunen@nvidia.com>
    i2c: tegra: Don't mark devices with pins as IRQ safe

Lee Jones <lee@kernel.org>
    HID: multitouch: Check to ensure report responses match the request

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix Clang jump table detection

Paul SAGE <paul.sage@42.fr>
    tg3: replace placeholder MAC address with device property

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't take device_list_mutex when querying zone info

Deepanshu Kartikey <kartikey406@gmail.com>
    atm: lec: fix use-after-free in sock_def_readable()

Benoît Sevens <bsevens@google.com>
    HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq

Pepper Gray <hello@peppergray.xyz>
    arm64/scs: Fix handling of advance_loc4


-------------

Diffstat:

 .../bindings/auxdisplay/holtek,ht16k33.yaml        |   2 +-
 .../bindings/connector/usb-connector.yaml          |   1 +
 .../bindings/gpio/microchip,mpfs-gpio.yaml         |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/patch-scs.c                      |   8 +
 arch/loongarch/include/asm/linkage.h               |  36 +++
 arch/loongarch/include/asm/sigframe.h              |   9 +
 arch/loongarch/kernel/asm-offsets.c                |   2 +
 arch/loongarch/kernel/signal.c                     |   6 +-
 arch/loongarch/vdso/Makefile                       |   4 +-
 arch/loongarch/vdso/sigreturn.S                    |   6 +-
 arch/mips/lib/multi3.c                             |   6 +-
 arch/mips/mm/tlb-r4k.c                             |   2 +-
 arch/mips/ralink/clk.c                             |   8 +-
 arch/riscv/kernel/kgdb.c                           |   7 +-
 arch/x86/kernel/cpu/common.c                       |  18 +-
 crypto/af_alg.c                                    |   4 +-
 drivers/accel/qaic/qaic_control.c                  |  47 +++-
 drivers/comedi/drivers.c                           |   8 +
 drivers/comedi/drivers/dt2815.c                    |  12 +
 drivers/comedi/drivers/me4000.c                    |  16 +-
 drivers/comedi/drivers/me_daq.c                    |  35 +--
 drivers/comedi/drivers/ni_atmio16d.c               |   3 +-
 drivers/counter/rz-mtu3-cnt.c                      |  67 ++---
 drivers/cpufreq/cpufreq_governor.c                 |   6 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   3 +-
 drivers/crypto/caam/caamhash.c                     |   3 +-
 drivers/dma/fsl-edma-main.c                        |  31 +--
 drivers/gpio/gpio-mxc.c                            |  10 +-
 drivers/gpu/drm/ast/ast_dp501.c                    |   2 +-
 drivers/gpu/drm/drm_ioc32.c                        |   2 +
 drivers/gpu/drm/i915/display/g4x_dp.c              |   2 +-
 drivers/hid/hid-multitouch.c                       |   7 +
 drivers/hid/wacom_wac.c                            |  10 +
 drivers/hwmon/occ/common.c                         |  19 +-
 drivers/hwmon/pmbus/pxe1610.c                      |   5 +-
 drivers/hwmon/pmbus/tps53679.c                     |   4 +-
 drivers/i2c/busses/Kconfig                         |   2 +
 drivers/i2c/busses/i2c-tegra.c                     |   5 +-
 drivers/iio/accel/adxl355_core.c                   |   2 +-
 drivers/iio/adc/ti-adc161s626.c                    |  41 ++-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  32 ++-
 drivers/iio/imu/bmi160/bmi160_core.c               |  15 +-
 drivers/iio/imu/bno055/bno055.c                    |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   3 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   4 +
 drivers/iio/light/vcnl4035.c                       |  18 +-
 drivers/input/joystick/xpad.c                      |   5 +
 drivers/input/rmi4/rmi_f54.c                       |   4 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/misc/fastrpc.c                             |   1 +
 drivers/net/ethernet/broadcom/tg3.c                |  13 +-
 drivers/net/ethernet/cadence/macb_main.c           |  13 +-
 drivers/net/ethernet/cadence/macb_pci.c            |  10 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  28 ++-
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 -
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  49 ++--
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   4 +-
 drivers/net/phy/sfp.c                              |   7 +-
 drivers/net/vxlan/vxlan_core.c                     |   6 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            | 210 ++++++++++------
 drivers/net/wireless/ath/ath11k/hal.c              |  16 +-
 drivers/net/wireless/ath/ath11k/hal.h              |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   2 +-
 drivers/net/wireless/virtual/virt_wifi.c           |   1 -
 drivers/nfc/pn533/uart.c                           |   3 +
 drivers/nvmem/imx-ocotp-ele.c                      |   1 +
 drivers/nvmem/imx-ocotp.c                          |   1 +
 drivers/spi/spi-geni-qcom.c                        |   9 +-
 drivers/target/loopback/tcm_loop.c                 |  52 +++-
 drivers/thermal/thermal_core.c                     |   1 +
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/usbtmc.c                         |   3 +
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/gadget.c                          |   2 +
 drivers/usb/gadget/function/f_rndis.c              |   9 +-
 drivers/usb/gadget/function/f_subset.c             |   6 +
 drivers/usb/gadget/function/f_uac1_legacy.c        |  47 +++-
 drivers/usb/gadget/function/f_uvc.c                |  39 ++-
 drivers/usb/gadget/function/u_ether.c              |  10 +-
 drivers/usb/gadget/function/uvc.h                  |   3 +
 drivers/usb/gadget/function/uvc_v4l2.c             |   5 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  42 ++--
 drivers/usb/host/ehci-brcm.c                       |   4 +-
 drivers/usb/serial/io_edgeport.c                   |   3 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/vfio/device_cdev.c                         |   7 +
 drivers/vfio/group.c                               |   7 +
 drivers/vfio/pci/vfio_pci_core.c                   | 277 +++++----------------
 drivers/vfio/vfio_main.c                           |  44 ++++
 fs/btrfs/inode.c                                   |   6 +-
 fs/btrfs/tree-checker.c                            |  17 ++
 fs/btrfs/zoned.c                                   |   6 +-
 fs/ext4/fast_commit.c                              |   4 +-
 fs/ext4/inode.c                                    |  15 +-
 fs/ext4/mballoc.c                                  |   2 +
 fs/gfs2/dir.c                                      |  37 +--
 fs/gfs2/glops.c                                    |  40 +--
 fs/gfs2/xattr.c                                    |  28 ++-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/swapops.h                            |  20 +-
 include/linux/vfio.h                               |   1 +
 include/linux/vfio_pci_core.h                      |   2 -
 include/net/netfilter/nf_conntrack_expect.h        |  20 +-
 kernel/bpf/verifier.c                              |  10 +-
 kernel/fork.c                                      |  29 +--
 net/atm/lec.c                                      |  72 ++++--
 net/atm/lec.h                                      |   2 +-
 net/bluetooth/hci_event.c                          |  33 ++-
 net/bluetooth/hci_sync.c                           |  11 +-
 net/bluetooth/mgmt.c                               |  17 +-
 net/bluetooth/sco.c                                |  30 ++-
 net/bluetooth/smp.c                                |  11 +-
 net/bridge/br_arp_nd_proxy.c                       |  18 +-
 net/core/dev.c                                     |  22 +-
 net/core/skmsg.c                                   |  13 +-
 net/hsr/hsr_device.c                               |  32 +--
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/datagram.c                                |  10 +
 net/ipv6/icmp.c                                    |   3 +
 net/ipv6/ioam6.c                                   |   4 +-
 net/ipv6/ip6_flowlabel.c                           |   5 -
 net/ipv6/ip6_tunnel.c                              |   5 +
 net/ipv6/ndisc.c                                   |   3 +
 net/mptcp/pm_netlink.c                             |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/nf_conntrack_broadcast.c             |   8 +-
 net/netfilter/nf_conntrack_expect.c                |  25 +-
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  13 +-
 net/netfilter/nf_conntrack_netlink.c               |  87 +++----
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_flow_table_offload.c              | 196 ++++++++++-----
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nfnetlink_log.c                      |   2 +-
 net/netfilter/x_tables.c                           |  23 ++
 net/netfilter/xt_cgroup.c                          |   6 +
 net/netfilter/xt_rateest.c                         |   5 +
 net/qrtr/af_qrtr.c                                 |  31 +--
 net/rds/ib_rdma.c                                  |   7 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flow.c                               |  10 +-
 net/sched/cls_fw.c                                 |  14 +-
 net/sched/sch_hfsc.c                               |   4 +-
 net/sched/sch_netem.c                              |   5 +-
 net/x25/x25_in.c                                   |   9 +-
 net/x25/x25_subr.c                                 |   1 +
 sound/pci/ctxfi/ctdaio.c                           |   1 +
 sound/soc/cirrus/ep93xx-i2s.c                      |  34 ++-
 sound/usb/caiaq/device.c                           |   2 +-
 tools/objtool/check.c                              |   5 +-
 165 files changed, 1668 insertions(+), 947 deletions(-)


