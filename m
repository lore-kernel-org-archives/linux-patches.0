Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17FA347517;
	Wed,  8 Apr 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671668; cv=none; b=Yz5kbSsEKLfmy1MYiBVUChn9Ra5a6GpsUfkF7T6PM8e3G9LAA0FxoQ+arLJk8UoyAlIOmytVWOd6A3t5qoQ9hDRyMi82ceQPfBiTksfzhriWkzLslSjpoFN3n8yo3s5wmzDnX1PK1+9u9P5k0fcb/7gxIB7r3SqMI0pNkTovOoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671668; c=relaxed/simple;
	bh=CkKgoZrIS+1WF6cz9mLWw+hoFBv93pqIWsiHxhM4AmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uF1BKW9yFpkpfshVetoV9JY2nh45mhGjaBWi0oqUej0jSJOiLpt00p8Me00KbSYYJPPrYPx9QDQHq0sD4vUTnTJFeBDf0lBje615DUjXUFB+otpWsQNFqFuBFfkeZNTa4vMGIDGcLE86clELMWmYgu9iZIT08y3QiM6H7JBS6BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCVWjh8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCVWjh8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2749C19421;
	Wed,  8 Apr 2026 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671667;
	bh=CkKgoZrIS+1WF6cz9mLWw+hoFBv93pqIWsiHxhM4AmQ=;
	h=From:To:Cc:Subject:Date:From;
	b=iCVWjh8OigDkezfCacUZf+NfW5igTIDmsx5aLPPtKrTWMIT8JvG5PZZoG+yB1aaUV
	 vSypr/Ru9bYZEVPqKjSVo21wFTcSMmHN7EVQO3dw8HRKFKzk07SGbAJnyS4Y9BpcHG
	 d7WBNZLDnaJirCgu8QEw1r5VmAbt0p1x5qmNhG+8=
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
Subject: [PATCH 6.1 000/312] 6.1.168-rc1 review
Date: Wed,  8 Apr 2026 19:58:37 +0200
Message-ID: <20260408175933.715315542@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.168-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.168-rc1
X-KernelTest-Deadline: 2026-04-10T17:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.168 release.
There are 312 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.168-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.168-rc1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Evaluate orphan _REG under EC device

Nathan Chancellor <nathan@kernel.org>
    ext4: fix unused iterator variable warnings

Theodore Ts'o <tytso@mit.edu>
    ext4: fix lost error code reporting in __ext4_fill_super()

Bart Van Assche <bvanassche@acm.org>
    block: Fix the blk_mq_destroy_queue() documentation

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: eir: Fix possible crashes on eir_create_adv_data

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check removing signal+subflow endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: implicit: stop transfer after last check

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix unlikely race in gdlm_put_lock

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phy: fix phy_uses_state_machine()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: allow MDIO bus PM ops to start/stop state machine for phylink-controlled PHY

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: move phy_link_change() prior to mdio_bus_phy_may_suspend()

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: save ailp before dropping the AIL lock in push callbacks

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: avoid dereferencing log items after push callbacks

Denis Arefev <arefev@swemel.ru>
    erofs: Fix the slab-out-of-bounds in drop_buffers()

Gao Xiang <xiang@kernel.org>
    erofs: fix PSI memstall accounting

Gao Xiang <xiang@kernel.org>
    erofs: handle overlapped pclusters out of crafted images properly

Pratyush Yadav <p.yadav@ti.com>
    mtd: spi-nor: core: avoid odd length/address writes in 8D-8D-8D mode

Pratyush Yadav <p.yadav@ti.com>
    mtd: spi-nor: core: avoid odd length/address reads on 8D-8D-8D mode

Guangshuo Li <lgs201920130244@gmail.com>
    cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path

Liao Chang <liaochang1@huawei.com>
    cpufreq: governor: Free dbs_data directly when gov->init() fails

Theodore Ts'o <tytso@mit.edu>
    ext4: handle wraparound when searching for blocks for indirect mapped blocks

Li Xiasong <lixiasong1@huawei.com>
    MPTCP: fix lock class name family in pm_nl_create_listen_socket

Li Chen <me@linux.beauty>
    ext4: publish jinode after initialization

Zqiang <qiang.zhang@linux.dev>
    ext4: fix the might_sleep() warnings in kvfree()

Jason Yan <yanaijie@huawei.com>
    ext4: factor out ext4_flex_groups_free()

Jason Yan <yanaijie@huawei.com>
    ext4: use ext4_group_desc_free() in ext4_put_super() to save some duplicated code

Jason Yan <yanaijie@huawei.com>
    ext4: factor out ext4_percpu_param_init() and ext4_percpu_param_destroy()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Add mutex protection for AVS enable sysfs attributes

Eddie James <eajames@linux.ibm.com>
    hwmon: (pmbus/core) Add lock and unlock functions

Luo Haiyang <luo.haiyang@zte.com.cn>
    tracing: Fix potential deadlock in cpu hotplug with osnoise

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix potencial OOB in get_file_all_info() for compound requests

Werner Kasselman <werner@verivus.com>
    ksmbd: fix memory leaks and NULL deref in smb2_lock()

Nikunj A Dadhania <nikunj@amd.com>
    x86/cpu: Enable FSGSBASE early in cpu_init_exception_handling()

Jinjiang Tu <tujinjiang@huawei.com>
    mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Josef Bacik <josef@toxicpanda.com>
    scsi: target: tcm_loop: Drain commands in target_reset handler

Kevin Hao <haokexin@gmail.com>
    net: macb: Move devm_{free,request}_irq() out of spin lock area

Willem de Bruijn <willemb@google.com>
    net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Drop/zap existing present SPTE even when creating an MMIO SPTE

Zheng Qixing <zhengqixing@huawei.com>
    block: fix resource leak in blk_register_queue() error path

Jiayuan Chen <jiayuan.chen@shopee.com>
    ext4: fix use-after-free in update_super_work when racing with umount

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

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: fix PF !of_device_is_available() teardown path

Josh Law <objecting@objecting.org>
    mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]

Ming Lei <ming.lei@redhat.com>
    nvme: fix admin queue leak on controller reset

Keith Busch <kbusch@kernel.org>
    nvme: fix admin request_queue lifetime

Christoph Hellwig <hch@lst.de>
    nvme-pci: put the admin queue in nvme_dev_remove_admin

Christoph Hellwig <hch@lst.de>
    nvme-pci: remove an extra queue reference

Christoph Hellwig <hch@lst.de>
    blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue

Heyne, Maximilian <mheyne@amazon.de>
    Revert "nvme: fix admin request_queue lifetime"

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

Yufan Chen <yufan.chen@linux.dev>
    net: ftgmac100: fix ring allocation unwind on open failure

Yang Yang <n05ec@lzu.edu.cn>
    vxlan: validate ND option lengths in vxlan_na_create

Yifan Wu <yifanwucs@gmail.com>
    netfilter: ipset: drop logically empty buckets in mtype_del

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

Sasha Levin <sashal@kernel.org>
    Revert "ext4: make ext4_es_remove_extent() return void"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: get rid of ppath in ext4_find_extent()"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: get rid of ppath in ext4_ext_create_new_leaf()"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: get rid of ppath in ext4_ext_insert_extent()"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: get rid of ppath in ext4_split_extent_at()"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: subdivide EXT4_EXT_DATA_VALID1"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: don't zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: drop extent cache after doing PARTIAL_VALID1 zeroout"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: drop extent cache when splitting extent fails"

Sasha Levin <sashal@kernel.org>
    Revert "ext4: avoid infinite loops caused by residual data"

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

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix missing newline in occ_show_extended()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (tps53679) Fix device ID comparison and printing in tps53676_identify()

Jamie Gibbons <jamie.gibbons@microchip.com>
    dt-bindings: gpio: fix microchip #interrupt-cells

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pxe1610) Check return value of page-select write in probe

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    netfilter: Reorder fields in 'struct nf_conntrack_expect'

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

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    ASoC: ep93xx: i2s: move enable call to startup callback

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

Norbert Szetei <norbert@doyensec.com>
    crypto: af-alg - fix NULL pointer dereference in scatterwalk

Frank Li <Frank.Li@nxp.com>
    dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning

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

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix bind() regression for v6-only wildcard and v4-mapped-v6 non-wildcard addresses.

Davidlohr Bueso <dave@stgolabs.net>
    futex: Clear stale exiting pointer in futex_lock_pi() retry path

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    dmaengine: xilinx_dma: Fix reset related timeout with two-channel AXIDMA

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    dmaengine: xilinx_dma: Program interrupt delay timeout

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix freeing the allocated ida too late

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: idxd: Remove usage of the deprecated ida_simple_xx() API

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error when running device stats on multiple devices fs

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    btrfs: fix leak of kobject name for sub-group space_info

Mark Harmstone <mark@harmstone.com>
    btrfs: fix super block offset in error message in btrfs_validate_super()

Marek Vasut <marex@nabladev.com>
    dmaengine: xilinx: xilinx_dma: Fix unmasked residue subtraction

Marek Vasut <marex@nabladev.com>
    dmaengine: xilinx: xilinx_dma: Fix residue calculation for cyclic DMA

Marek Vasut <marex@nabladev.com>
    dmaengine: xilinx: xilinx_dma: Fix dma_device directions

Felix Gu <ustc.gu@gmail.com>
    phy: ti: j721e-wiz: Fix device node reference leak in wiz_get_lane_phy_types()

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix memory leak when a wq is reset

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix not releasing workqueue on .release()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc64/bpf: do not increment tailcall count when prog is NULL

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: imx8mn-tqma8mqnl: fix LDO5 power off

Theodore Ts'o <tytso@mit.edu>
    ext4: always drain queued discard work in ext4_mb_release()

Baokun Li <libaokun@linux.alibaba.com>
    ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths

Helen Koike <koike@igalia.com>
    ext4: reject mount if bigalloc with s_first_data_block != 0

Ye Bin <yebin10@huawei.com>
    ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()

Edward Adam Davis <eadavis@qq.com>
    ext4: avoid infinite loops caused by residual data

Jan Kara <jack@suse.cz>
    ext4: make recently_deleted() properly work with lazy itable initialization

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: convert inline data to extents when truncate exceeds inline size

Simon Weber <simon.weber.39@gmail.com>
    ext4: fix journal credit check when setting fscrypt context

Long Li <leo.lilong@huawei.com>
    xfs: fix ri_total validation in xlog_recover_attri_commit_pass2

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: stop reclaim before pushing AIL during unmount

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Workaround LS2K/LS7A GPU DMA hang bug

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    dmaengine: sh: rz-dmac: Move CHCTRL updates under spinlock

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    dmaengine: sh: rz-dmac: Protect the driver specific lists

Jassi Brar <jassisinghbrar@gmail.com>
    irqchip/qcom-mpm: Add missing mailbox TX done acknowledgment

Milos Nikic <nikic.milos@gmail.com>
    jbd2: gracefully abort on checkpointing state corruptions

Kevin Hao <haokexin@gmail.com>
    net: macb: Use dev_consume_skb_any() to free TX SKBs

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: ses: Handle positive SCSI error from ses_recv_diag()

Tyllis Xu <livelycarpet87@gmail.com>
    scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    alarmtimer: Fix argument order in alarm_timer_forward()

Jiucheng Xu <jiucheng.xu@amlogic.com>
    erofs: add GFP_NOIO in the bio completion if needed

xietangxin <xietangxin@yeah.net>
    virtio_net: Fix UAF on dst_ops when IFF_XMIT_DST_RELEASE is cleared and napi_tx is false

Yuchan Nam <entropy1110@gmail.com>
    media: mc, v4l2: serialize REINIT and REQBUFS with req_queue_mutex

Sanman Pradhan <psanman@juniper.net>
    hwmon: (peci/cputemp) Fix off-by-one in cputemp_is_visible()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (peci/cputemp) Fix crit_hyst returning delta instead of absolute temperature

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Discard PC update state on vcpu reset

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: conservative: Reset requested_freq on limits change

Ali Norouzi <ali.norouzi@keysight.com>
    can: gw: fix OOB heap access in cgw_csum_crc8_rel()

Hyunwoo Kim <imv4bel@gmail.com>
    ksmbd: do not expire session on binding failure

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: replace hardcoded hdr2_len with offsetof() in smb2_calc_max_out_buf_len()

Vasily Gorbik <gor@linux.ibm.com>
    s390/barrier: Make array_index_mask_nospec() __always_inline

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    s390/syscalls: Add spectre boundary for syscall dispatch table

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-fsl-lpspi: fix teardown order issue (UAF)

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: adau1372: Fix clock leak on PLL lock failure

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: adau1372: Fix unchecked clk_prepare_enable() return value

Marc Buerg <buermarc@googlemail.com>
    sysctl: fix uninitialized variable in proc_do_large_bitmap

Sanman Pradhan <psanman@juniper.net>
    hwmon: (adm1177) fix sysfs ABI violation and current unit conversion

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix fence put before wait in amdgpu_amdkfd_submit_ib

Weiming Shi <bestswngs@gmail.com>
    ACPI: EC: clean up handlers on probe failure in acpi_ec_setup()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Install address space handler at the namespace root

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Fix ECDT probe ordering issues

Hans de Goede <hdegoede@redhat.com>
    ACPI: EC: Fix EC address space handler unregistration

Hans de Goede <hdegoede@redhat.com>
    ACPICA: Allow address_space_handler Install and _REG execution as 2 separate steps

Hans de Goede <hdegoede@redhat.com>
    ACPICA: include/acpi/acpixf.h: Fix indentation

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Fix the device initialization

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    drm/i915/gmbus: fix spurious timeout on 512-byte burst reads

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size

Yihang Li <liyihang9@huawei.com>
    scsi: scsi_transport_sas: Fix the maximum channel scanning issue

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Return EINVAL for invalid arp index error

Anil Samal <anil.samal@intel.com>
    RDMA/irdma: Fix deadlock during netdev reset with active connections

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()

Ivan Barrera <ivan.d.barrera@intel.com>
    RDMA/irdma: Clean up unnecessary dereference of event->cm_node

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Remove a NOP wait_event() in irdma_modify_qp_roce()

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Update ibqp state to error if QP is already in error state

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Initialize free_qp completion before using it

Chuck Lever <chuck.lever@oracle.com>
    RDMA/rw: Fall back to direct SGE on MR pool exhaustion

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    regmap: Synchronize cache for the page selector

Paolo Valerio <pvalerio@redhat.com>
    net: macb: use the current queue number for stats

David Carlier <devnexen@gmail.com>
    netfilter: ctnetlink: use netlink policy range checks

Florian Westphal <fw@strlen.de>
    netlink: allow be16 and be32 types in all uint policy checks

Weiming Shi <bestswngs@gmail.com>
    netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: skip expectations in other netns via proc

Ren Wei <n05ec@lzu.edu.cn>
    netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()

Weiming Shi <bestswngs@gmail.com>
    netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD

Chuck Lever <chuck.lever@oracle.com>
    tls: Purge async_hold in tls_decrypt_async_wait()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: btusb: clamp SCO altsetting table indices

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Fix ERTM re-init and zero pdu_len infinite loop

Zhang Chen <zhangchen01@kylinos.cn>
    Bluetooth: L2CAP: Fix send LE flow credits in ACL link

Miguel Ojeda <ojeda@kernel.org>
    dma-mapping: add missing `inline` for `dma_free_attrs`

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the output issue of 'ethtool --show-ring'

Martin KaFai Lau <martin.lau@kernel.org>
    udp: Fix wildcard bind conflict check when using hash2

Eric Dumazet <edumazet@google.com>
    tcp: optimize inet_use_bhash2_on_bind()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Rearrange tests in inet_csk_bind_conflict().

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Use bhash2 for v4-mapped-v6 non-wildcard address.

Yochai Eisenrich <echelonh@gmail.com>
    net: fix fanout UAF in packet_release() via NETDEV_UP race

Petr Oros <poros@redhat.com>
    ice: use ice_update_eth_stats() for representor stats

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size

Qi Tang <tpluszz77@gmail.com>
    net/smc: fix double-free of smc_spd_priv when tee() duplicates splice pipe buffer

Yang Yang <n05ec@lzu.edu.cn>
    openvswitch: validate MPLS set/set_masked payload length

Yang Yang <n05ec@lzu.edu.cn>
    openvswitch: defer tunnel netdev_put to RCU release

Hangbin Liu <liuhangbin@gmail.com>
    rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link

Hangbin Liu <liuhangbin@gmail.com>
    net: add new helper unregister_netdevice_many_notify

Hangbin Liu <liuhangbin@gmail.com>
    rtnetlink: pass netlink message header and portid to rtnl_configure_link()

Toke Høiland-Jørgensen <toke@redhat.com>
    net: openvswitch: Avoid releasing netdev before teardown completes

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: fix circular locking dependency in nci_close_device

Mohammad Heib <mheib@redhat.com>
    ionic: fix persistent MAC address override on PF

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    pinctrl: mediatek: common: Fix probe failure for devices without EINT

Helen Koike <koike@igalia.com>
    Bluetooth: L2CAP: Fix null-ptr-deref on l2cap_sock_ready_cb

Anas Iqbal <mohd.abd.6602@gmail.com>
    Bluetooth: hci_ll: Fix firmware leak on error path

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: statistics: add missing atomic access in hot path

Shigeru Yoshida <syoshida@redhat.com>
    dma: swiotlb: add KMSAN annotations to swiotlb_bounce()

Eric Dumazet <edumazet@google.com>
    af_key: validate families in pfkey_send_migrate()

Sabrina Dubroca <sd@queasysnail.net>
    esp: fix skb leak with espintcp and async crypto

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix the usage of skb->sk

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: call xdo_dev_state_delete during state update

Jie Deng <dengjie03@kylinos.cn>
    usb: core: new quirk to handle devices with zero configurations

Uzair Mughal <contact@uzair.is-a.dev>
    ALSA: hda/realtek: Add headset jack quirk for Thinkpad X390

Liucheng Lu <luliucheng100@outlook.com>
    ALSA: hda/realtek: add HP Laptop 14s-dr5xxx mute LED quirk

Boris Burkov <boris@bur.io>
    btrfs: set BTRFS_ROOT_ORPHAN_CLEANUP during subvol create

Günther Noack <gnoack@google.com>
    HID: apple: avoid memory leak in apple_report_fixup()

Isaac J. Manjarres <isaacmanjarres@google.com>
    dma-buf: Include ioctl.h in UAPI header

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_set_reg()

Ihor Solodrai <ihor.solodrai@linux.dev>
    module: Fix kernel panic when a symbol st_shndx is out of bounds

Romain Sioen <romain.sioen@microchip.com>
    HID: mcp2221: cancel last I2C command on read error

Valentin Spreckels <valentin@spreckels.dev>
    net: usb: r8152: add TRENDnet TUC-ET2G

Günther Noack <gnoack@google.com>
    HID: magicmouse: avoid memory leak in magicmouse_report_fixup()

Julius Lehmann <lehmanju@devpi.de>
    HID: magicmouse: fix battery reporting for Apple Magic Trackpad 2

Keith Busch <kbusch@kernel.org>
    nvme-pci: ensure we're polling a polled queue

Hans de Goede <johannes.goede@oss.qualcomm.com>
    platform/x86: touchscreen_dmi: Add quirk for y-inverted Goodix touchscreen on SUPI S10

Leif Skunberg <diamondback@cohunt.app>
    platform/x86: intel-hid: Enable 5-button array on ThinkPad X1 Fold 16 Gen 1

Daniel Hodges <hodgesd@meta.com>
    nvme-fabrics: use kfree_sensitive() for DHCHAP secrets

Keith Busch <kbusch@kernel.org>
    nvme-pci: cap queue creation to used queues

Peter Metz <peter.metz@unarin.com>
    platform/x86: intel-hid: Add Dell 14 Plus 2-in-1 to dmi_vgbs_allow_list

Günther Noack <gnoack@google.com>
    HID: asus: avoid memory leak in asus_report_fixup()

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Release module BTF IDR before module unload

Danilo Krummrich <dakr@kernel.org>
    sh: platform_early: remove pdev->driver_override check


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 .../bindings/auxdisplay/holtek,ht16k33.yaml        |   2 +-
 .../bindings/gpio/microchip,mpfs-gpio.yaml         |   4 +-
 Documentation/hwmon/adm1177.rst                    |   8 +-
 Documentation/hwmon/peci-cputemp.rst               |  10 +-
 Makefile                                           |   4 +-
 .../boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dts |  13 +-
 .../arm64/boot/dts/freescale/imx8mn-tqma8mqnl.dtsi |  22 ++
 arch/arm64/kvm/reset.c                             |  14 +
 arch/loongarch/pci/pci.c                           |  80 ++++++
 arch/mips/lib/multi3.c                             |   6 +-
 arch/mips/mm/tlb-r4k.c                             |   2 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  23 +-
 arch/riscv/kernel/kgdb.c                           |   7 +-
 arch/s390/include/asm/barrier.h                    |   4 +-
 arch/s390/kernel/syscall.c                         |   2 +
 arch/sh/drivers/platform_early.c                   |   4 -
 arch/x86/kernel/cpu/common.c                       |  18 +-
 arch/x86/kvm/mmu/mmu.c                             |  15 +-
 arch/x86/platform/efi/quirks.c                     |   2 +-
 block/blk-mq.c                                     |   9 +-
 block/blk-sysfs.c                                  |   2 +
 block/bsg-lib.c                                    |   2 +
 crypto/af_alg.c                                    |   4 +-
 drivers/acpi/acpica/acevents.h                     |   4 +
 drivers/acpi/acpica/evregion.c                     |   6 +-
 drivers/acpi/acpica/evxfregn.c                     | 146 +++++++++-
 drivers/acpi/ec.c                                  |  52 +++-
 drivers/base/regmap/regmap.c                       |  30 +-
 drivers/bluetooth/btusb.c                          |   5 +-
 drivers/bluetooth/hci_ll.c                         |   2 +
 drivers/comedi/drivers.c                           |   8 +
 drivers/comedi/drivers/dt2815.c                    |  12 +
 drivers/comedi/drivers/me4000.c                    |  16 +-
 drivers/comedi/drivers/me_daq.c                    |  35 +--
 drivers/comedi/drivers/ni_atmio16d.c               |   3 +-
 drivers/cpufreq/cpufreq_conservative.c             |  12 +
 drivers/cpufreq/cpufreq_governor.c                 |  13 +-
 drivers/cpufreq/cpufreq_governor.h                 |   1 +
 drivers/dma/idxd/cdev.c                            |  10 +-
 drivers/dma/idxd/device.c                          |   3 +-
 drivers/dma/idxd/sysfs.c                           |   1 +
 drivers/dma/sh/rz-dmac.c                           |  68 +++--
 drivers/dma/xilinx/xilinx_dma.c                    |  66 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   4 +-
 drivers/gpu/drm/ast/ast_dp501.c                    |   2 +-
 drivers/gpu/drm/drm_ioc32.c                        |   2 +
 drivers/gpu/drm/i915/display/intel_gmbus.c         |   4 +-
 drivers/hid/hid-apple.c                            |   4 +-
 drivers/hid/hid-asus.c                             |  15 +-
 drivers/hid/hid-magicmouse.c                       |   6 +-
 drivers/hid/hid-mcp2221.c                          |   2 +
 drivers/hid/hid-multitouch.c                       |   7 +
 drivers/hid/wacom_wac.c                            |  10 +
 drivers/hwmon/adm1177.c                            |  54 ++--
 drivers/hwmon/occ/common.c                         |  19 +-
 drivers/hwmon/peci/cputemp.c                       |   4 +-
 drivers/hwmon/pmbus/isl68137.c                     |  21 +-
 drivers/hwmon/pmbus/pmbus.h                        |   2 +
 drivers/hwmon/pmbus/pmbus_core.c                   |  30 ++
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
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   4 +
 drivers/iio/light/vcnl4035.c                       |  18 +-
 drivers/infiniband/core/rw.c                       |  27 +-
 drivers/infiniband/hw/irdma/cm.c                   |  29 +-
 drivers/infiniband/hw/irdma/utils.c                |   2 -
 drivers/infiniband/hw/irdma/verbs.c                |   9 +-
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/rmi4/rmi_f54.c                       |   4 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/irqchip/irq-qcom-mpm.c                     |   3 +
 drivers/media/mc/mc-request.c                      |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   5 +-
 drivers/mtd/spi-nor/core.c                         | 145 +++++++++-
 drivers/net/can/vxcan.c                            |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |  13 +-
 drivers/net/ethernet/cadence/macb_main.c           |  17 +-
 drivers/net/ethernet/cadence/macb_pci.c            |  10 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  28 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  14 +-
 drivers/net/ethernet/intel/ice/ice_repr.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  49 ++--
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  17 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   4 +-
 drivers/net/geneve.c                               |   2 +-
 drivers/net/phy/phy_device.c                       |  58 +++-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/veth.c                                 |   2 +-
 drivers/net/virtio_net.c                           |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   2 +-
 drivers/net/wireless/virt_wifi.c                   |   1 -
 drivers/net/wwan/wwan_core.c                       |   2 +-
 drivers/nfc/pn533/uart.c                           |   3 +
 drivers/nvme/host/apple.c                          |   1 +
 drivers/nvme/host/core.c                           |  16 +-
 drivers/nvme/host/fabrics.c                        |   4 +-
 drivers/nvme/host/pci.c                            |  25 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |   2 +
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   9 +-
 drivers/platform/olpc/olpc-xo175-ec.c              |   2 +-
 drivers/platform/x86/intel/hid.c                   |  13 +
 drivers/platform/x86/touchscreen_dmi.c             |  18 ++
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   3 +-
 drivers/scsi/scsi_sysfs.c                          |   1 +
 drivers/scsi/scsi_transport_sas.c                  |   2 +-
 drivers/scsi/ses.c                                 |   2 +-
 drivers/spi/spi-fsl-lpspi.c                        |   3 +-
 drivers/target/loopback/tcm_loop.c                 |  52 +++-
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/ufs/core/ufshcd.c                          |   2 +
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/usbtmc.c                         |   3 +
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/core/config.c                          |   6 +-
 drivers/usb/core/quirks.c                          |   8 +
 drivers/usb/dwc2/gadget.c                          |   2 +
 drivers/usb/gadget/function/f_rndis.c              |   9 +-
 drivers/usb/gadget/function/f_subset.c             |   6 +
 drivers/usb/gadget/function/f_uac1_legacy.c        |  47 +++-
 drivers/usb/gadget/function/f_uvc.c                |  39 ++-
 drivers/usb/gadget/function/uvc.h                  |   3 +
 drivers/usb/gadget/function/uvc_v4l2.c             |   5 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  42 +--
 drivers/usb/host/ehci-brcm.c                       |   4 +-
 drivers/usb/serial/io_edgeport.c                   |   3 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   4 +
 fs/btrfs/block-group.c                             |   2 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/inode.c                                   |   6 +-
 fs/btrfs/ioctl.c                                   |   7 +
 fs/btrfs/tree-checker.c                            |  17 ++
 fs/btrfs/volumes.c                                 |   5 +-
 fs/btrfs/zoned.c                                   |   6 +-
 fs/erofs/data.c                                    |   2 +
 fs/erofs/zdata.c                                   |  70 ++---
 fs/ext4/crypto.c                                   |   9 +-
 fs/ext4/ext4.h                                     |  10 +-
 fs/ext4/extents.c                                  | 312 +++++++++------------
 fs/ext4/extents_status.c                           |  12 +-
 fs/ext4/extents_status.h                           |   4 +-
 fs/ext4/fast_commit.c                              |  25 +-
 fs/ext4/ialloc.c                                   |   6 +
 fs/ext4/inline.c                                   |  12 +-
 fs/ext4/inode.c                                    |  35 ++-
 fs/ext4/mballoc.c                                  |  30 +-
 fs/ext4/migrate.c                                  |   5 +-
 fs/ext4/move_extent.c                              |   7 +-
 fs/ext4/super.c                                    | 164 +++++------
 fs/ext4/sysfs.c                                    |  10 +-
 fs/gfs2/lock_dlm.c                                 |  10 +-
 fs/jbd2/checkpoint.c                               |  15 +-
 fs/smb/server/smb2pdu.c                            |  72 +++--
 fs/xfs/xfs_attr_item.c                             |   4 +-
 fs/xfs/xfs_dquot_item.c                            |   9 +-
 fs/xfs/xfs_inode_item.c                            |   9 +-
 fs/xfs/xfs_mount.c                                 |   7 +-
 fs/xfs/xfs_trace.c                                 |   1 +
 fs/xfs/xfs_trace.h                                 |  36 ++-
 fs/xfs/xfs_trans_ail.c                             |  26 +-
 include/acpi/acpixf.h                              | 142 +++++-----
 include/linux/dma-mapping.h                        |   4 +-
 include/linux/netdevice.h                          |   2 -
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/rtnetlink.h                          |   9 +-
 include/linux/swapops.h                            |  20 +-
 include/linux/usb/quirks.h                         |   3 +
 include/linux/usb/r8152.h                          |   1 +
 include/net/inet_hashtables.h                      |  14 +
 include/net/netfilter/nf_conntrack_expect.h        |  44 ++-
 include/net/netlink.h                              |  21 +-
 include/net/rtnetlink.h                            |   5 +-
 include/uapi/linux/dma-buf.h                       |   1 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 kernel/bpf/btf.c                                   |  24 +-
 kernel/bpf/verifier.c                              |  10 +-
 kernel/dma/swiotlb.c                               |  21 +-
 kernel/futex/pi.c                                  |   3 +-
 kernel/module/main.c                               |   7 +
 kernel/sysctl.c                                    |   2 +-
 kernel/time/alarmtimer.c                           |   2 +-
 kernel/trace/trace_osnoise.c                       |   8 +-
 lib/nlattr.c                                       |   6 +
 mm/damon/sysfs.c                                   |   3 +
 net/atm/lec.c                                      |  72 +++--
 net/atm/lec.h                                      |   2 +-
 net/bluetooth/eir.c                                |   7 +-
 net/bluetooth/eir.h                                |   2 +-
 net/bluetooth/hci_event.c                          |  33 ++-
 net/bluetooth/hci_sync.c                           |   5 +-
 net/bluetooth/l2cap_core.c                         |  28 +-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/mgmt.c                               |  17 +-
 net/bluetooth/sco.c                                |  40 ++-
 net/bluetooth/smp.c                                |  11 +-
 net/bridge/br_arp_nd_proxy.c                       |  18 +-
 net/can/af_can.c                                   |   4 +-
 net/can/af_can.h                                   |   2 +-
 net/can/gw.c                                       |   6 +-
 net/can/proc.c                                     |   3 +-
 net/core/dev.c                                     |  70 +++--
 net/core/dev.h                                     |   7 +
 net/core/rtnetlink.c                               |  51 ++--
 net/hsr/hsr_device.c                               |  32 ++-
 net/ipv4/esp4.c                                    |  11 +-
 net/ipv4/inet_connection_sock.c                    |  72 +++--
 net/ipv4/inet_hashtables.c                         |   3 +-
 net/ipv4/ip_gre.c                                  |   2 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/datagram.c                                |  10 +
 net/ipv6/esp6.c                                    |  11 +-
 net/ipv6/icmp.c                                    |   3 +
 net/ipv6/ioam6.c                                   |   4 +-
 net/ipv6/ip6_flowlabel.c                           |   5 -
 net/ipv6/ip6_tunnel.c                              |   5 +
 net/ipv6/ndisc.c                                   |   3 +
 net/ipv6/netfilter/ip6t_rt.c                       |   4 +
 net/ipv6/xfrm6_output.c                            |   4 +-
 net/key/af_key.c                                   |  19 +-
 net/mptcp/pm_netlink.c                             |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/nf_conntrack_broadcast.c             |   8 +-
 net/netfilter/nf_conntrack_expect.c                |  29 +-
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  13 +-
 net/netfilter/nf_conntrack_netlink.c               | 103 +++----
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |  18 +-
 net/netfilter/nf_flow_table_offload.c              | 196 ++++++++-----
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nfnetlink_log.c                      |  10 +-
 net/netfilter/x_tables.c                           |  23 ++
 net/netfilter/xt_cgroup.c                          |   6 +
 net/netfilter/xt_rateest.c                         |   5 +
 net/nfc/nci/core.c                                 |  10 +-
 net/openvswitch/flow_netlink.c                     |   2 +
 net/openvswitch/vport-geneve.c                     |   2 +-
 net/openvswitch/vport-gre.c                        |   2 +-
 net/openvswitch/vport-netdev.c                     |  13 +-
 net/openvswitch/vport-vxlan.c                      |   2 +-
 net/packet/af_packet.c                             |   1 +
 net/qrtr/af_qrtr.c                                 |  31 +-
 net/rds/ib_rdma.c                                  |   7 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flow.c                               |  10 +-
 net/sched/cls_fw.c                                 |  14 +-
 net/sched/sch_hfsc.c                               |   4 +-
 net/smc/smc_rx.c                                   |   9 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/x25/x25_in.c                                   |   9 +-
 net/x25/x25_subr.c                                 |   1 +
 net/xfrm/xfrm_interface_core.c                     |   2 +-
 net/xfrm/xfrm_output.c                             |   7 +-
 net/xfrm/xfrm_policy.c                             |   2 +-
 net/xfrm/xfrm_state.c                              |   1 +
 sound/pci/ctxfi/ctdaio.c                           |   1 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/cirrus/ep93xx-i2s.c                      |  40 ++-
 sound/soc/codecs/adau1372.c                        |  34 ++-
 sound/soc/fsl/fsl_easrc.c                          |  14 +-
 sound/soc/intel/catpt/device.c                     |  10 +-
 sound/soc/intel/catpt/dsp.c                        |   3 -
 sound/usb/caiaq/device.c                           |   2 +-
 tools/objtool/check.c                              |   5 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  14 +
 286 files changed, 3071 insertions(+), 1445 deletions(-)


