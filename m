Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5D30DED5;
	Mon, 13 Apr 2026 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098666; cv=none; b=BwmTX8MwWr9Hfppw/iM0u2BtCod6H70YPQ4FqCvoYsHBKUevOd/CS2C0JdimazN+EZk+t4siseF102owx1AL5Y75AWRShmLfm3/xh9Qxnsi1bUuVASsZBUTKca0blPuqZh1WTk71pKSscrXg3XBLW1A2GWgUPUgxn7UsSxJE4lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098666; c=relaxed/simple;
	bh=LBBZ7TQf+t92f6h/4uhBcu/mPECj/nxqeeMAF1jrKno=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PizxIaM3EbKKVxx3lxEM9xTrYrR9Zo5QfsdiXeh0pIoxp10MVW3I8oQRAzVR2PMmMzD06VzpdNDj1FoeRyS4tMROi05UvJwdcvi1q+v0CQsh6/F1HjLLggyN432W4h1e50Nv/ozMKiHvQ7s6AyhB3xsDF5pshn2e2+2TcArOVB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTY6UTz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTY6UTz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF3AC2BCB8;
	Mon, 13 Apr 2026 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098665;
	bh=LBBZ7TQf+t92f6h/4uhBcu/mPECj/nxqeeMAF1jrKno=;
	h=From:To:Cc:Subject:Date:From;
	b=kTY6UTz0DsMSyeleVgEdne9Kbfhu+yQnAkZSpxFyty9l28W+E3HRtmFRohXr+XVOR
	 P3CYTqMedBliyiRRaC2WTaxwHEohvMgtpUN/D1W1YO2EJvdnEicmREQeeaUB8UtCsz
	 dWdqjLjQrY+G5FZzLA3ZlIQxCTVJmKbgvCXjrOkw=
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
Subject: [PATCH 5.10 000/491] 5.10.253-rc1 review
Date: Mon, 13 Apr 2026 17:54:05 +0200
Message-ID: <20260413155819.042779211@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.253-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.253-rc1
X-KernelTest-Deadline: 2026-04-15T15:58+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.253 release.
There are 491 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.253-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.253-rc1

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: correctly handle io_poll_add() return value on update

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    Revert "PCI: Enable ACS after configuring IOMMU for OF platforms"

Yang Yingliang <yangyingliang@huawei.com>
    device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    s390/syscalls: Add spectre boundary for syscall dispatch table

Yang Yang <n05ec@lzu.edu.cn>
    batman-adv: avoid OGM aggregation when skb tailroom is insufficient

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Allow secondary lookup in fwnode_get_next_child_node()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Allow error pointer to be passed to fwnode APIs

Daniel Scally <djrscally@gmail.com>
    device property: Check fwnode->secondary when finding properties

Daniel Scally <djrscally@gmail.com>
    device property: Check fwnode->secondary in fwnode_graph_get_next_endpoint()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    device property: Unify access to of_node

Andy Shevchenko <andy.shevchenko@gmail.com>
    device property: Retrieve fwnode from of_node via accessor

Daniel Scally <djrscally@gmail.com>
    media: device property: Return true in fwnode_device_is_available for NULL ops

Saravana Kannan <saravanak@google.com>
    device property: Add fwnode_is_ancestor_of() and fwnode_get_next_parent_dev()

Jaskaran Singh <jsingh@cloudlinux.com>
    nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()

Jaskaran Singh <jsingh@cloudlinux.com>
    Revert "nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()"

Penghe Geng <pgeng@nvidia.com>
    mmc: core: Avoid bitfield RMW for claim/retune flags

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Drop reference counting of the bus_ops

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Drop superfluous validations in mmc_hw|sw_reset()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Drop redundant member in struct mmc host

Maarten Lankhorst <dev@lankhorst.se>
    drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix accepting multiple L2CAP_ECRED_CONN_REQ

Li Chen <me@linux.beauty>
    ext4: publish jinode after initialization

Baokun Li <libaokun@linux.alibaba.com>
    ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: stop reclaim before pushing AIL during unmount

Yuto Ohnuki <ytohnuki@amazon.com>
    xfs: save ailp before dropping the AIL lock in push callbacks

Zqiang <qiang.zhang@linux.dev>
    ext4: fix the might_sleep() warnings in kvfree()

Jinjiang Tu <tujinjiang@huawei.com>
    mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Kevin Hao <haokexin@gmail.com>
    net: macb: Move devm_{free,request}_irq() out of spin lock area

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: uvc: fix NULL pointer dereference during unbind race

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_ether: Fix race between gether_disconnect and eth_stop

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: move list and spinlock inits from bind to alloc

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rfkill: prevent unlimited numbers of rfkill events from being created

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: separate dst_cache for input and output paths in seg6 lwtunnel

Guangshuo Li <lgs201920130244@gmail.com>
    cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path

Liao Chang <liaochang1@huawei.com>
    cpufreq: governor: Free dbs_data directly when gov->init() fails

Florian Westphal <fw@strlen.de>
    netlink: add nla be16/32 types to minlen array

Jon Hunter <jonathanh@nvidia.com>
    ASoC: tegra: Fix Master Volume Control

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: don't use discriminatory terms on snd_soc_runtime_get_dai_fmt()

GuoHan Zhao <zhaoguohan@kylinos.cn>
    xen/privcmd: unregister xenstore notifier on module exit

David Howells <dhowells@redhat.com>
    rxrpc: Fix key/keyring checks in setsockopt(RXRPC_SECURITY_KEY/KEYRING)

Tyllis Xu <livelycarpet87@gmail.com>
    net: stmmac: fix integer underflow in chain mode

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qualcomm: qca_uart: report the consumed byte on RX skb allocation failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix NULL-deref on disconnect

David Carlier <devnexen@gmail.com>
    net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()

Ruide Cao <caoruide123@gmail.com>
    batman-adv: reject oversized global TT response buffers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: pn533: allocate rx skb before consuming bytes

Shawn Guo <shawnguo@kernel.org>
    arm64: dts: hisilicon: hi3798cv200: Add missing dma-ranges

Shawn Guo <shawnguo@kernel.org>
    arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: brcmsmac: Fix dma_free_coherent() size

Oleh Konko <security@1seal.org>
    tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG

Tuan Do <tuan@calif.io>
    netfilter: nft_ct: fix use-after-free in timeout object destroy

John Johansen <john.johansen@canonical.com>
    apparmor: fix race between freeing data and fs accessing it

John Johansen <john.johansen@canonical.com>
    apparmor: fix race on rawdata dereference

John Johansen <john.johansen@canonical.com>
    apparmor: fix differential encoding verification

John Johansen <john.johansen@canonical.com>
    apparmor: fix unprivileged local user can do privileged policy management

John Johansen <john.johansen@canonical.com>
    apparmor: Fix double free of ns_name in aa_replace_profiles()

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix missing bounds check on DEFAULT table in verify_dfa()

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix side-effect bug in match_char() macro usage

John Johansen <john.johansen@canonical.com>
    apparmor: fix: limit the number of levels of policy namespaces

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: replace recursive profile removal with iterative approach

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix memory leak in verify_header

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: validate DFA start states are in bounds in unpack_pdb

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Use heuristic to find stream entity

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Implement UVC_EXT_GPIO_UNIT

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Allow extra entities

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Move guid to entity

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/rmap: fix two comments related to huge_pmd_unshare()

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix two comments related to huge_pmd_unshare()

David Hildenbrand (Red Hat) <david@kernel.org>
    mm/hugetlb: fix hugetlb_pmd_shared()

Jane Chu <jane.chu@oracle.com>
    mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: make detecting shared pte more reliable

David Hildenbrand (Arm) <david@kernel.org>
    mm/hugetlb: fix skipping of unsharing of pmd page tables

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: uinput - take event lock when submitting FF request "event"

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Input: uinput - fix circular locking dependency with ff-core

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    xfrm_user: fix info leak in build_report()

Johan Hovold <johan@kernel.org>
    wifi: rt2x00usb: fix devres lifetime

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: chacha: Zeroize permuted_state before it leaves scope

Jens Axboe <axboe@kernel.dk>
    io_uring/tctx: work around xa_store() allocation error issue

Taegu Ha <hataegu0826@gmail.com>
    usb: gadget: f_uac1_legacy: validate control request size

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Protect RNDIS options with mutex

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_subset: Fix unbalanced refcnt in geth_free

Cengiz Can <cengiz.can@canonical.com>
    nvmet-tcp: fix use-before-check of sg in bounds validation

Sebastian Urban <surban@surban.net>
    usb: gadget: dummy_hcd: fix premature URB completion when ZLP follows partial transfer

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

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Lock around hardware registers and driver data

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Move IRQ request in probe

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Fix role detection on unbind/bind

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

David Lechner <dlechner@baylibre.com>
    iio: light: vcnl4035: fix scan buffer on big-endian

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: dac: ad5770r: fix error return in ad5770r_read_raw()

Zoltan Illes <zoliviragh@gmail.com>
    Input: xpad - add support for Razer Wolverine V3 Pro

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max 16 Gen10 AMD to i8042 quirk table

Bart Van Assche <bvanassche@acm.org>
    Input: synaptics-rmi4 - fix a locking bug in an error path

JP Hein <jp@jphein.com>
    USB: core: add NO_LPM quirk for Razer Kiyo Pro webcam

Wanquan Zhong <wanquan.zhong@fibocom.com>
    USB: serial: option: add support for Rolling Wireless RW135R-GL

Frej Drejhammar <frej@stacken.kth.se>
    USB: serial: io_edgeport: add support for Blackbox IC135A

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: dp501: Fix initialization of SCU2C

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

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/ioc32: stop speculation on the drm_compat_ioctl path

Paul Walmsley <pjw@kernel.org>
    riscv: kgdb: fix several debug register assignment bugs

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix missing newline in occ_show_extended()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pxe1610) Check return value of page-select write in probe

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar

Sasha Levin <sashal@kernel.org>
    Revert "media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar"

David Jeffery <djeffery@redhat.com>
    scsi: core: Wake up the error handler when final completions race against each other

Sasha Levin <sashal@kernel.org>
    Revert "scsi: core: Wake up the error handler when final completions race against each other"

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add seqno waiter for sync_files

Sasha Levin <sashal@kernel.org>
    Revert "drm/vmwgfx: Add seqno waiter for sync_files"

Ard Biesheuvel <ardb@kernel.org>
    efi/mokvar-table: Avoid repeated map/unmap of the same page

Eric Dumazet <edumazet@google.com>
    ipv6: avoid overflows in ip6_datagram_send_ctl()

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

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: properly unregister fixed rate clocks

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix clk handling on PCI glue driver removal

Weiming Shi <bestswngs@gmail.com>
    rds: ib: reject FRMR registration before IB connection is established

Keenan Dong <keenanat2000@gmail.com>
    Bluetooth: MGMT: validate LTK enc_size on load

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject immediate NF_QUEUE verdict

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP

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

Yochai Eisenrich <echelonh@gmail.com>
    net: ipv6: ndisc: fix ndisc_ra_useropt to initialize nduseropt_padX fields to zero to prevent an info-leak

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak

Loic Poulain <loic.poulain@linaro.org>
    net: qrtr: Release distant nodes along the bridge node

Loic Poulain <loic.poulain@linaro.org>
    net: qrtr: Add GFP flags parameter to qrtr_alloc_ctrl_packet

Norbert Szetei <norbert@doyensec.com>
    crypto: af-alg - fix NULL pointer dereference in scatterwalk

Lee Jones <lee@kernel.org>
    HID: multitouch: Check to ensure report responses match the request

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix Clang jump table detection

Deepanshu Kartikey <kartikey406@gmail.com>
    atm: lec: fix use-after-free in sock_def_readable()

Benoît Sevens <bsevens@google.com>
    HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq

Davidlohr Bueso <dave@stgolabs.net>
    futex: Clear stale exiting pointer in futex_lock_pi() retry path

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    dmaengine: xilinx_dma: Fix reset related timeout with two-channel AXIDMA

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    dmaengine: xilinx_dma: Program interrupt delay timeout

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error when running device stats on multiple devices fs

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

Helen Koike <koike@igalia.com>
    ext4: reject mount if bigalloc with s_first_data_block != 0

Ye Bin <yebin10@huawei.com>
    ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()

Jan Kara <jack@suse.cz>
    ext4: make recently_deleted() properly work with lazy itable initialization

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: convert inline data to extents when truncate exceeds inline size

Milos Nikic <nikic.milos@gmail.com>
    jbd2: gracefully abort on checkpointing state corruptions

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    scsi: ses: Handle positive SCSI error from ses_recv_diag()

Tyllis Xu <livelycarpet87@gmail.com>
    scsi: ibmvfc: Fix OOB access in ibmvfc_discover_targets_done()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    alarmtimer: Fix argument order in alarm_timer_forward()

xietangxin <xietangxin@yeah.net>
    virtio_net: Fix UAF on dst_ops when IFF_XMIT_DST_RELEASE is cleared and napi_tx is false

Yuchan Nam <entropy1110@gmail.com>
    media: mc, v4l2: serialize REINIT and REQBUFS with req_queue_mutex

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: conservative: Reset requested_freq on limits change

Ali Norouzi <ali.norouzi@keysight.com>
    can: gw: fix OOB heap access in cgw_csum_crc8_rel()

Vasily Gorbik <gor@linux.ibm.com>
    s390/barrier: Make array_index_mask_nospec() __always_inline

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-fsl-lpspi: fix teardown order issue (UAF)

Marc Buerg <buermarc@googlemail.com>
    sysctl: fix uninitialized variable in proc_do_large_bitmap

Sanman Pradhan <psanman@juniper.net>
    hwmon: (adm1177) fix sysfs ABI violation and current unit conversion

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

Andy Lutomirski <luto@kernel.org>
    x86/fault: Improve kernel-executing-user-memory handling

Andy Lutomirski <luto@kernel.org>
    x86/fault: Fold mm_fault_error() into do_user_addr_fault()

Yihang Li <liyihang9@huawei.com>
    scsi: scsi_transport_sas: Fix the maximum channel scanning issue

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

Florian Westphal <fw@strlen.de>
    netlink: introduce bigendian integer types

Jakub Kicinski <kuba@kernel.org>
    netlink: hide validation union fields from kdoc

Florian Westphal <fw@strlen.de>
    netfilter: nft_payload: reject out-of-range attributes via policy

Florian Westphal <fw@strlen.de>
    netlink: introduce NLA_POLICY_MAX_BE

Weiming Shi <bestswngs@gmail.com>
    netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: skip expectations in other netns via proc

Ren Wei <n05ec@lzu.edu.cn>
    netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()

Weiming Shi <bestswngs@gmail.com>
    netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Bluetooth: btusb: clamp SCO altsetting table indices

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Fix ERTM re-init and zero pdu_len infinite loop

Miguel Ojeda <ojeda@kernel.org>
    dma-mapping: add missing `inline` for `dma_free_attrs`

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the output issue of 'ethtool --show-ring'

Yochai Eisenrich <echelonh@gmail.com>
    net: fix fanout UAF in packet_release() via NETDEV_UP race

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/olpc: olpc-xo175-ec: Fix overflow error message to print inlen

Sabrina Dubroca <sd@queasysnail.net>
    rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size

Qi Tang <tpluszz77@gmail.com>
    net/smc: fix double-free of smc_spd_priv when tee() duplicates splice pipe buffer

Yang Yang <n05ec@lzu.edu.cn>
    openvswitch: validate MPLS set/set_masked payload length

Toke Høiland-Jørgensen <toke@redhat.com>
    net: openvswitch: Avoid releasing netdev before teardown completes

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: fix circular locking dependency in nci_close_device

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    pinctrl: mediatek: common: Fix probe failure for devices without EINT

Helen Koike <koike@igalia.com>
    Bluetooth: L2CAP: Fix null-ptr-deref on l2cap_sock_ready_cb

Anas Iqbal <mohd.abd.6602@gmail.com>
    Bluetooth: hci_ll: Fix firmware leak on error path

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: L2CAP: Validate PDU length before reading SDU length in l2cap_ecred_data_rcv()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: statistics: add missing atomic access in hot path

Eric Dumazet <edumazet@google.com>
    af_key: validate families in pfkey_send_migrate()

Sabrina Dubroca <sd@queasysnail.net>
    esp: fix skb leak with espintcp and async crypto

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Fix the usage of skb->sk

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: call xdo_dev_state_delete during state update

Uzair Mughal <contact@uzair.is-a.dev>
    ALSA: hda/realtek: Add headset jack quirk for Thinkpad X390

Isaac J. Manjarres <isaacmanjarres@google.com>
    dma-buf: Include ioctl.h in UAPI header

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_put_bits()

Mark Brown <broonie@kernel.org>
    ASoC: fsl_easrc: Fix event generation in fsl_easrc_iec958_set_reg()

Romain Sioen <romain.sioen@microchip.com>
    HID: mcp2221: cancel last I2C command on read error

Keith Busch <kbusch@kernel.org>
    nvme-pci: ensure we're polling a polled queue

Hans de Goede <johannes.goede@oss.qualcomm.com>
    platform/x86: touchscreen_dmi: Add quirk for y-inverted Goodix touchscreen on SUPI S10

Leif Skunberg <diamondback@cohunt.app>
    platform/x86: intel-hid: Enable 5-button array on ThinkPad X1 Fold 16 Gen 1

Günther Noack <gnoack@google.com>
    HID: asus: avoid memory leak in asus_report_fixup()

Danilo Krummrich <dakr@kernel.org>
    sh: platform_early: remove pdev->driver_override check

Juergen Gross <jgross@suse.com>
    xen/privcmd: add boot control for restricted usage in domU

Juergen Gross <jgross@suse.com>
    xen/privcmd: restrict usage in unprivileged domU

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: split gc into unlink and reclaim phase

Josh Law <objecting@objecting.org>
    tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: skip DMA during panic write

Kamal Dasu <kdasu.kdev@gmail.com>
    mtd: rawnand: brcmnand: move to polling in pio mode on oops write

Kamal Dasu <kdasu.kdev@gmail.com>
    mtd: rawnand: brcmnand: read/write oob during EDU transfer

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: serialize lock/unlock against other NAND operations

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: fsi: Fix a potential leak in fsi_i2c_probe()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/isl68137) Fix unchecked return value and use sysfs_emit()

Weiming Shi <bestswngs@gmail.com>
    icmp: fix NULL pointer dereference in icmp_tag_validation()

Anas Iqbal <mohd.abd.6602@gmail.com>
    net: dsa: bcm_sf2: fix missing clk_disable_unprepare() in error paths

Weiming Shi <bestswngs@gmail.com>
    nfnetlink_osf: validate individual option lengths in fingerprints

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix NULL deref in bond_debug_rlb_hash_show

Xiang Mei <xmei5@asu.edu>
    udp_tunnel: fix NULL deref caused by udp_sock_create6 when CONFIG_IPV6=n

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix uninitialized rx_fs_lock

Guenter Roeck <linux@roeck-us.net>
    wifi: wlcore: Return -ENOMEM instead of -EAGAIN if there is not enough headroom

Xiang Mei <xmei5@asu.edu>
    wifi: mac80211: fix NULL deref in mesh_matches_local()

Kohei Enju <kohei@enjuk.jp>
    igc: fix missing update of skb->tail in igc_xmit_frame()

Nikola Z. Ivanov <zlatistiv@gmail.com>
    net: usb: aqc111: Do not perform PM inside suspend callback

Bart Van Assche <bvanassche@acm.org>
    PM: runtime: Fix a race condition related to device removal

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Consolidate the handling of two special cases

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: increase WoL poll timeout

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nf_conntrack_h323: check for zero length in DecodeQ931()

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: xt_time: use unsigned int for monthday bit shift

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_CT: drop pending enqueued packets on template removal

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_ct: drop pending enqueued packets on removal

Andrii Melnychenko <a.melnychenko@vyos.io>
    netfilter: nft_ct: add seqadj extension for natted connections

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case

Lukas Johannes Möller <research@johannes-moeller.dev>
    netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: ctnetlink: fix use-after-free in ctnetlink_dump_exp_ct()

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: remove refcounting in expectation dumpers

Jiayuan Chen <jiayuan.chen@shopee.com>
    net/rose: fix NULL pointer dereference in rose_transmit_link on reconnect

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HIDP: Fix possible UAF

Christian Eggers <ceggers@arri.de>
    Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy

Christian Eggers <ceggers@arri.de>
    Bluetooth: LE L2CAP: Disconnect if sum of payload sizes exceed SDU

Christian Eggers <ceggers@arri.de>
    Bluetooth: LE L2CAP: Disconnect if received packet's SDU exceeds IMTU

Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
    wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down

Richard Genoud <richard.genoud@bootlin.com>
    soc: fsl: qbman: fix race condition in qman_destroy_fq

Ethan Tidmore <ethantidmore06@gmail.com>
    staging: rtl8723bs: fix null dereference in find_network

Eric Biggers <ebiggers@kernel.org>
    net/tcp-md5: Fix MAC comparison to be constant-time

Eric Biggers <ebiggers@kernel.org>
    smb: client: Compare MACs in constant time

Mehul Rao <mehulrao@gmail.com>
    ALSA: pcm: fix use-after-free on linked stream runtime in snd_pcm_drain()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: pcm: fix wait_time calculations

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with in-kernel APIC

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): always configure bitrates before starting device

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    usb: gadget: f_tcm: Fix NULL pointer dereferences in nexus handling

Xu Yang <xu.yang_2@nxp.com>
    usb: roles: get usb role switch from parent only for usb-b-connector

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch when turning buffer off

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Increase ASB control timeout

Finn Thain <fthain@linux-m68k.org>
    mtd: Avoid boot crash in RedBoot partition table parser

Corentin Labbe <clabbe@baylibre.com>
    mtd: partitions: redboot: fix style issues

Jeff Layton <jlayton@kernel.org>
    nfsd: fix heap overflow in NFSv4.0 LOCK replay cache

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Hold net reference for the lifetime of /proc/fs/nfs/exports fd

Tom Rix <trix@redhat.com>
    nfsd: define exports_proc_ops with CONFIG_PROC_FS

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mm: Add PTE_DIRTY back to PAGE_KERNEL* to fix kexec/hibernation

Thomas Fourier <fourier.thomas@gmail.com>
    drm/msm: Fix dma_free_attrs() buffer size

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix OOM ->tfm_count leak

Long Li <leo.lilong@huawei.com>
    xfs: fix integer overflow in bmap intent sort comparator

Long Li <leo.lilong@huawei.com>
    xfs: ensure dquot item is deleted from AIL only after log shutdown

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Enable AUTOSEL_DOM for CCA serialnr sysfs attribute

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix iface port assignment in parse_server_interfaces

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix atomic open with O_DIRECT & O_SYNC

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: light: bh1780: fix PM runtime leak on error path

Maíra Canal <mcanal@igalia.com>
    pmdomain: bcm: bcm2835-power: Fix broken reset status read

Huiwen He <hehuiwen@kylinos.cn>
    tracing: Fix syscall events activation by ensuring refcount hits zero

Darrick J. Wong <djwong@kernel.org>
    iomap: reject delalloc mappings during writeback

Heiko Carstens <hca@linux.ibm.com>
    s390/xor: Fix xor_xc_2() inline assembly constraints

Paul Moses <p@1g4.org>
    net/sched: act_gate: snapshot parameters with RCU on replace

Natalie Vock <natalie.vock@gmx.de>
    drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink

Andrew Lunn <andrew@lunn.ch>
    net: phy: register phy led_triggers during probe to avoid AB-BA deadlock

Thorsten Blum <thorsten.blum@linux.dev>
    smb: client: Don't log plaintext credentials in cifs_set_cifscreds

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()

Vahagn Vardanian <vahagn@redrays.io>
    wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()

Daniel Hodges <git@danielhodges.dev>
    wifi: libertas: fix use-after-free in lbs_free_adapter()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: refactor ata_scsi_translate()

Hannes Reinecke <hare@suse.de>
    ata: libata: remove pointless VPRINTK() calls

Brian Foster <bfoster@redhat.com>
    ext4: fix dirtyclusters double decrement on fs shutdown

Zhang Yi <yi.zhang@huawei.com>
    ext4: drop extent cache when splitting extent fails

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use ctx->lock to protect struct vidi_context member variables related to memory alloc/free

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: fix to avoid directly dereferencing user pointer

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use priv->vidi_dev for ctx lookup in vidi_connection_ioctl()

Ankit Garg <nktgrg@google.com>
    gve: defer interrupt enabling until NAPI registration

Frederic Weisbecker <frederic@kernel.org>
    net: Handle napi_schedule() calls from non-interrupt

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: apply state adjust rules to some additional HAINAN vairants

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Add late synchronize_irq() to shutdown to handle DW UART BUSY

Raul E Rangel <rrangel@chromium.org>
    serial: 8250: Fix TX deadlock when using DMA

Martin Roukala (né Peres) <martin.roukala@mupuf.org>
    serial: 8250_pci: add support for the AX99100

Guanghui Feng <guanghuifeng@linux.alibaba.com>
    iommu/vt-d: Fix intel iommu iotlb sync hardlockup and retry

Chen Ni <nichen@iscas.ac.cn>
    mtd: rawnand: cadence: Fix error check for dma_alloc_coherent() in cadence_nand_init()

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci: fix timing selection for 1-bit bus width

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: sdhci-pci-gli: fix GL9750 DMA write corruption

Lukas Johannes Möller <research@johannes-moeller.dev>
    Bluetooth: L2CAP: Validate L2CAP_INFO_RSP payload length before access

Lukas Johannes Möller <research@johannes-moeller.dev>
    Bluetooth: L2CAP: Fix type confusion in l2cap_ecred_reconf_rsp()

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix use-after-free access to PTP clock

Ian Ray <ian.ray@gehealthcare.com>
    NFC: nxp-nci: allow GPIOs to sleep

Ira Weiny <ira.weiny@intel.com>
    nvdimm/bus: Fix potential use after free in asynchronous initialization

Jeff Layton <jlayton@kernel.org>
    sunrpc: fix cache_request leak in cache_release

Jens Axboe <axboe@kernel.dk>
    io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop

Eric Dumazet <edumazet@google.com>
    l2tp: do not use sock_hold() in pppol2tp_session_get_sock()

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Forget ranges when refining tnum after JSET

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix odr switch to the same value

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-i2c: fix pm_runtime error handling

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: mpu3050-core: fix pm_runtime error handling

Chris Spencer <spencercw@gmail.com>
    iio: chemical: bme680: Fix measurement wait duration calculation

Lukas Schmid <lukas.schmid@netcube.li>
    iio: potentiometer: mcp4131: fix double application of wiper shift

Oleksij Rempel <linux@rempel-privat.de>
    iio: dac: ds4424: reject -128 RAW value

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on failure to update root in the received subvol ioctl

Josh Law <objecting@objecting.org>
    lib/bootconfig: check bounds before writing in __xbc_open_brace()

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix snprintf truncation check in xbc_node_compose_key_after()

Shashank Balaji <shashank.mahadasyam@sony.com>
    x86/apic: Disable x2apic on resume if the kernel expects so

Josh Law <objecting@objecting.org>
    lib/bootconfig: fix off-by-one in xbc_verify_tree() unclosed brace error

Calvin Owens <calvin@wbinvd.org>
    tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G

Alysa Liu <Alysa.Liu@amd.com>
    drm/amdgpu: Fix use-after-free race in VM acquire

Fan Wu <fanwu01@zju.edu.cn>
    net: ethernet: arc: emac: quiesce interrupts before requesting IRQ

Jian Zhang <zhangjian.3032@bytedance.com>
    net: ncsi: fix skb leak in error paths

Helge Deller <deller@gmx.de>
    parisc: Fix initial page table creation for boot

Dave Airlie <airlied@redhat.com>
    nouveau/dpcd: return EBUSY for aux xfer if the device is asleep

Helge Deller <deller@gmx.de>
    parisc: Increase initial mapping to 64 MB with KALLSYMS

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid double-rtnl_lock ELP metric worker

Ariel Silver <arielsilver77@gmail.com>
    media: dvb-net: fix OOB access in ULE extension header tables

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: rtl8723bs: properly validate the data in rtw_get_ie_ex()

Luka Gejak <luka.gejak@linux.dev>
    staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports

Steven Rostedt <rostedt@goodmis.org>
    time/jiffies: Mark jiffies_64_to_clock_t() notrace

Randy Dunlap <rdunlap@infradead.org>
    time: add kernel-doc in time.c

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix i_nlink underrun during async unlink

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in ceph_handle_auth_reply()

Mehul Rao <mehulrao@gmail.com>
    tipc: fix divide-by-zero in tipc_sk_filter_connect()

Felix Gu <ustc.gu@gmail.com>
    mmc: mmci: Fix device_node reference leak in of_get_dml_pipe_index()

Kalesh Singh <kaleshsingh@google.com>
    mm/tracing: rss_stat: ensure curr is false from kthread context

Ziyi Guo <n7l8m4@u.northwestern.edu>
    usb: image: mdc800: kill download URB on timeout

Oliver Neukum <oneukum@suse.com>
    usb: mdc800: handle signal and read racing

Fan Wu <fanwu01@zju.edu.cn>
    usb: renesas_usbhs: fix use-after-free in ISR during device removal

Oliver Neukum <oneukum@suse.com>
    usb: class: cdc-wdm: fix reordering issue in read code path

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Limit the length of unkillable synchronous timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbtmc: Use usb_bulk_msg_killable() with user-specified timeouts

Alan Stern <stern@rowland.harvard.edu>
    USB: usbcore: Introduce usb_bulk_msg_killable()

Marc Zyngier <maz@kernel.org>
    usb: cdc-acm: Restore CAP_BRK functionnality to CH343

Gabor Juhos <j4g8y7@gmail.com>
    usb: core: don't power off roothub PHYs if phy_set_mode() fails

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: misc: uss720: properly clean up reference in uss720_probe()

Oliver Neukum <oneukum@suse.com>
    usb: yurex: fix race in probe

Zilin Guan <zilin@seu.edu.cn>
    usb: xhci: Fix memory leak in xhci_disable_slot()

Christoffer Sandberg <cs@tuxedo.de>
    usb/core/quirks: Add Huawei ME906S-device to wakeup quirk

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: skip LTM configuration for LAN7850

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: lan78xx: fix silent drop of packets with checksum errors

Qingye Zhao <zhaoqingye@honor.com>
    cgroup: fix race between task migration and iteration

Casey Connolly <casey.connolly@linaro.org>
    ASoC: detect empty DMI strings

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp3x-rt5682-max9836: Add missing error check for clock acquisition

Ben Dooks <ben.dooks@codethink.co.uk>
    ACPI: OSL: fix __iomem type on return from acpi_os_map_generic_address()

Matt Vollrath <tactii@gmail.com>
    e1000/e1000e: Fix leak in DMA error cleanup

Alok Tiwari <alok.a.tiwari@oracle.com>
    i40e: fix src IP mask checks and memcpy argument names in cloud filter

Sungwoo Kim <iam@sung-woo.kim>
    nvme-pci: Fix slab-out-of-bounds in nvme_dbbuf_set

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    sched: idle: Make skipping governor callbacks more consistent

Peng Fan <peng.fan@nxp.com>
    regulator: pca9450: Correct interrupt type

Frieder Schrempf <frieder.schrempf@kontron.de>
    regulator: pca9450: Make IRQ optional

Yuan Tan <tanyuan98@outlook.com>
    netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()

Hyunwoo Kim <imv4bel@gmail.com>
    netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path

David Dull <monderasdor@gmail.com>
    netfilter: x_tables: guard option walkers against 1-byte tail reads

Jenny Guanni Qu <qguanni@gmail.com>
    netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()

Wenyuan Li <2063309626@qq.com>
    can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    serial: caif: hold tty->link reference in ldisc_open and ser_release

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: flush delayed work before removing DAIs and widgets

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: core: Do not call link_exit() on uninitialized rtd objects

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: core: Exit all links before removing their components

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: accept zero format at snd_soc_runtime_set_dai_fmt()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: add snd_soc_runtime_get_dai_fmt()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: move snd_soc_runtime_set_dai_fmt() to upside

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: don't indicate error message for snd_soc_[pcm_]dai_xxx()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: topology: use inclusive language for bclk and fsync

matteo.cotifava <cotifavamatteo@gmail.com>
    ASoC: soc-core: drop delayed_work_pending() check before flush

Weiming Shi <bestswngs@gmail.com>
    net/sched: teql: fix NULL pointer dereference in iptunnel_xmit on TEQL slave xmit

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix DMA FIFO desync on error CQE SQ recovery

Hangbin Liu <liuhangbin@gmail.com>
    bonding: handle BOND_LINK_FAIL, BOND_LINK_BACK as valid link states

J. Neuschäfer <j.ne@posteo.net>
    powerpc: 83xx: km83xx: Fix keymile vendor prefix

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: sysmon: Correct subsys_name_len type in QMI request

Christophe Leroy (CS GROUP) <chleroy@kernel.org>
    powerpc/uaccess: Fix inline assembly for clang build on PPC32

Tomas Henzl <thenzl@redhat.com>
    scsi: ses: Fix devices attaching to different hosts

Sofia Schneider <sofia@schn.dev>
    ACPI: OSI: Add DMI quirk for Acer Aspire One D255

Al Viro <viro@zeniv.linux.org.uk>
    unshare: fix unshare_fs() handling

Piotr Mazek <pmazek@outlook.com>
    ACPI: PM: Save NVS memory on Lenovo G70-35

Jan Kiszka <jan.kiszka@siemens.com>
    scsi: storvsc: Fix scheduling while atomic on PREEMPT_RT

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop

Fernando Fernandez Mancera <fmancera@suse.de>
    net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled

Fernando Fernandez Mancera <fmancera@suse.de>
    net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled

Jakub Kicinski <kuba@kernel.org>
    nfc: rawsock: cancel tx_work before socket teardown

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: free skb on nci_transceive early error paths

Ian Ray <ian.ray@gehealthcare.com>
    net: nfc: nci: Fix zero-length proprietary notifications

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix sleep while atomic on suspend/resume

Jakub Kicinski <kuba@kernel.org>
    ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()

David Thomson <dt@linux-mail.net>
    xen/acpi-processor: fix _CST detection using undersized evaluation buffer

Eric Dumazet <edumazet@google.com>
    indirect_call_wrapper: do not reevaluate function pointer

Bart Van Assche <bvanassche@acm.org>
    wifi: wlcore: Fix a locking bug

Bart Van Assche <bvanassche@acm.org>
    wifi: cw1200: Fix locking in error paths

Alban Bedel <alban.bedel@lht.dlh.de>
    can: mcp251x: fix deadlock in error path of mcp251x_open

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix locking for bcm_op runtime updates

Jiayuan Chen <jiayuan.chen@shopee.com>
    atm: lec: fix null-ptr-deref in lec_arp_clear_vccs

Chintan Vankar <c-vankar@ti.com>
    net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry handling in ALE table

Jonathan Teh <jonathan.teh@outlook.com>
    platform/x86: thinkpad_acpi: Fix errors reading battery thresholds

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: more stable simult_flows tests

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check metadata block offset is within range

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: fix divide by zero in the offload path

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()

Johannes Berg <johannes.berg@intel.com>
    wifi: radiotap: reject radiotap with unknown bits

Jun Seo <jun.seo.93@proton.me>
    ALSA: usb-audio: Use correct version for UAC3 header validation

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/efi: defer freeing of boot services memory

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: ucan: Fix infinite loop from zero-length messages

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of a message

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: pegasus: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: kalmia: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: kaweth: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nfc: pn533: properly drop the usb interface reference on disconnect

Jens Axboe <axboe@kernel.dk>
    media: dvb-core: fix wrong reinitialization of ringbuffer on reopen

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: arcnet: com20020-pci: fix support for 2.5Mbit cards

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use READ/WRITE_ONCE to avoid compiler optimization induced race

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Add quirk for HP ZBook Studio G4

Johan Hovold <johan@kernel.org>
    clk: tegra: tegra124-emc: fix device leak on set_rate()

Johan Hovold <johan@kernel.org>
    bus: omap-ocp2scp: fix OF populate on driver rebind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    bus: omap-ocp2scp: Convert to platform remove callback returning void

Johan Hovold <johan@kernel.org>
    drm/tegra: dsi: fix device leak on probe

Gui-Dong Han <hanguidong02@gmail.com>
    bus: fsl-mc: fix use-after-free in driver_override_show()

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    bus: fsl-mc: Replace snprintf and sprintf with sysfs_emit in sysfs show functions

Wentao Liang <vulab@iscas.ac.cn>
    ARM: omap2: Fix reference count leaks in omap_control_init()

Wang Qing <wangqing@vivo.com>
    ARM: OMAP2+: add missing of_node_put before break and return

Mark Harmstone <mark@harmstone.com>
    btrfs: fix incorrect key offset in error message in check_dev_extent_item()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Cap the packet size pre-calculations

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume

Mathias Krause <minipli@grsecurity.net>
    scsi: lpfc: Properly set WC for DPP mapping

Ben Hutchings <ben@decadent.org.uk>
    ip6_tunnel: Fix usage of skb_vlan_inet_prepare()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ARM: clean up the memset64() C wrapper


-------------

Diffstat:

 Documentation/hwmon/adm1177.rst                    |   8 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/string.h                      |  14 +-
 arch/arm/mach-omap2/cm_common.c                    |   8 +-
 arch/arm/mach-omap2/control.c                      |  29 +-
 arch/arm/mach-omap2/prm_common.c                   |   8 +-
 .../boot/dts/hisilicon/hi3798cv200-poplar.dts      |   2 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   1 +
 arch/arm64/include/asm/pgtable-prot.h              |  10 +-
 arch/mips/lib/multi3.c                             |   6 +-
 arch/parisc/include/asm/pgtable.h                  |   2 +-
 arch/parisc/kernel/head.S                          |   7 +-
 arch/powerpc/include/asm/uaccess.h                 |   2 +-
 arch/powerpc/platforms/83xx/km83xx.c               |   4 +-
 arch/riscv/kernel/kgdb.c                           |   7 +-
 arch/s390/include/asm/barrier.h                    |   4 +-
 arch/s390/kernel/entry.S                           |   7 +-
 arch/s390/lib/xor.c                                |   4 +-
 arch/sh/drivers/platform_early.c                   |   4 -
 arch/x86/include/asm/efi.h                         |   2 +-
 arch/x86/kernel/apic/apic.c                        |   6 +
 arch/x86/kvm/svm/avic.c                            |   2 +-
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/mm/fault.c                                | 118 +++----
 arch/x86/platform/efi/efi.c                        |   2 +-
 arch/x86/platform/efi/quirks.c                     |  55 +++-
 crypto/af_alg.c                                    |   4 +-
 drivers/acpi/acpica/evxfregn.c                     |  92 +++++-
 drivers/acpi/ec.c                                  |  49 ++-
 drivers/acpi/osi.c                                 |  13 +
 drivers/acpi/osl.c                                 |   2 +-
 drivers/acpi/sleep.c                               |   8 +
 drivers/ata/libata-core.c                          |   3 -
 drivers/ata/libata-sata.c                          |   2 -
 drivers/ata/libata-scsi.c                          | 123 +++-----
 drivers/ata/libata-sff.c                           |   4 -
 drivers/ata/libata.h                               |   1 -
 drivers/base/power/runtime.c                       |   1 +
 drivers/base/property.c                            | 205 ++++++++----
 drivers/base/regmap/regmap.c                       |  30 +-
 drivers/block/drbd/drbd_actlog.c                   |  53 ++--
 drivers/block/drbd/drbd_interval.h                 |   5 +-
 drivers/bluetooth/btusb.c                          |   5 +-
 drivers/bluetooth/hci_ll.c                         |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  10 +-
 drivers/bus/omap-ocp2scp.c                         |  19 +-
 drivers/clk/tegra/clk-tegra124-emc.c               |   2 +-
 drivers/cpufreq/cpufreq_conservative.c             |  12 +
 drivers/cpufreq/cpufreq_governor.c                 |  13 +-
 drivers/cpufreq/cpufreq_governor.h                 |   1 +
 drivers/cpuidle/cpuidle.c                          |  10 -
 drivers/crypto/atmel-sha204a.c                     |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  66 ++--
 drivers/firmware/efi/mokvar-table.c                |  20 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   2 +-
 drivers/gpu/drm/ast/ast_dp501.c                    |   2 +-
 drivers/gpu/drm/drm_file.c                         |   5 +-
 drivers/gpu/drm/drm_ioc32.c                        |   2 +
 drivers/gpu/drm/drm_mode_config.c                  |   9 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |   1 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  72 ++++-
 drivers/gpu/drm/i915/display/intel_gmbus.c         |   4 +-
 drivers/gpu/drm/msm/msm_gpummu.c                   |   2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   3 +
 drivers/gpu/drm/radeon/si_dpm.c                    |   4 +-
 drivers/gpu/drm/tegra/dsi.c                        |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   4 +-
 drivers/hid/hid-asus.c                             |  15 +-
 drivers/hid/hid-cmedia.c                           |   2 +-
 drivers/hid/hid-creative-sb0540.c                  |   2 +-
 drivers/hid/hid-mcp2221.c                          |   2 +
 drivers/hid/hid-multitouch.c                       |   7 +
 drivers/hid/hid-zydacron.c                         |   2 +-
 drivers/hid/wacom_wac.c                            |  10 +
 drivers/hwmon/adm1177.c                            |  54 ++--
 drivers/hwmon/max16065.c                           |  26 +-
 drivers/hwmon/occ/common.c                         |  19 +-
 drivers/hwmon/pmbus/isl68137.c                     |   7 +-
 drivers/hwmon/pmbus/pxe1610.c                      |   5 +-
 drivers/i2c/busses/i2c-fsi.c                       |   1 +
 drivers/iio/chemical/bme680_core.c                 |   2 +-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/dac/ds4424.c                           |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  50 ++-
 drivers/iio/gyro/mpu3050-i2c.c                     |   3 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_buffer.c |   3 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   2 +
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   4 +
 drivers/iio/light/bh1780.c                         |   4 +-
 drivers/iio/light/vcnl4035.c                       |  18 +-
 drivers/iio/potentiometer/mcp4131.c                |   2 +-
 drivers/infiniband/core/rw.c                       |  27 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |   5 +-
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/misc/uinput.c                        |  35 ++-
 drivers/input/rmi4/rmi_f54.c                       |   4 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/iommu/intel/dmar.c                         |   3 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   4 +
 drivers/media/dvb-core/dmxdev.c                    |   4 +-
 drivers/media/dvb-core/dvb_net.c                   |   3 +
 drivers/media/dvb-frontends/dib7000p.c             |  10 +-
 drivers/media/mc/mc-request.c                      |   5 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  33 +-
 drivers/media/usb/uvc/uvc_driver.c                 | 234 ++++++++++++--
 drivers/media/usb/uvc/uvc_entity.c                 |   1 +
 drivers/media/usb/uvc/uvcvideo.h                   |  27 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   5 +-
 drivers/mmc/core/block.c                           |   2 +-
 drivers/mmc/core/core.c                            | 110 +------
 drivers/mmc/host/mmci_qcom_dml.c                   |   1 +
 drivers/mmc/host/sdhci-pci-gli.c                   |   9 +
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/vub300.c                          |   2 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |  63 +++-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   2 +-
 drivers/mtd/nand/raw/nand_base.c                   |  14 +-
 drivers/mtd/parsers/redboot.c                      |  71 +++--
 drivers/net/arcnet/com20020-pci.c                  |  16 +-
 drivers/net/bonding/bond_debugfs.c                 |  16 +-
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/caif/caif_serial.c                     |   3 +
 drivers/net/can/spi/hi311x.c                       |   5 +-
 drivers/net/can/spi/mcp251x.c                      |  15 +-
 drivers/net/can/usb/ems_usb.c                      |   7 +-
 drivers/net/can/usb/gs_usb.c                       |  13 +-
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   8 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  10 -
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   3 -
 drivers/net/ethernet/arc/emac_main.c               |  11 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   2 +-
 drivers/net/ethernet/broadcom/tg3.c                |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |  18 +-
 drivers/net/ethernet/cadence/macb_pci.c            |  10 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |   4 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  28 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   2 +
 drivers/net/ethernet/google/gve/gve.h              |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |   5 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |   2 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  14 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  49 ++-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   4 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  11 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |   9 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   4 +-
 drivers/net/phy/phy_device.c                       |  13 +-
 drivers/net/usb/aqc111.c                           |  12 +-
 drivers/net/usb/kalmia.c                           |   7 +
 drivers/net/usb/kaweth.c                           |  13 +
 drivers/net/usb/lan78xx.c                          |   8 +-
 drivers/net/usb/lan78xx.h                          |   3 +
 drivers/net/usb/pegasus.c                          |  13 +-
 drivers/net/virtio_net.c                           |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  11 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/dma.c |   2 +-
 drivers/net/wireless/marvell/libertas/main.c       |   4 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   2 +-
 drivers/net/wireless/st/cw1200/pm.c                |   2 +
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   2 +-
 drivers/nfc/nxp-nci/i2c.c                          |   4 +-
 drivers/nfc/pn533/uart.c                           |  14 +-
 drivers/nfc/pn533/usb.c                            |   1 +
 drivers/nvdimm/bus.c                               |   5 +-
 drivers/nvme/host/fc.c                             |   2 +-
 drivers/nvme/host/pci.c                            |   5 +-
 drivers/nvme/target/tcp.c                          |   6 +-
 drivers/pci/pci-driver.c                           |   8 -
 drivers/pci/pci.c                                  |  10 +-
 drivers/pci/pci.h                                  |   1 -
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           | 122 +++++---
 drivers/phy/ti/phy-j721e-wiz.c                     |   2 +
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   9 +-
 drivers/platform/olpc/olpc-xo175-ec.c              |   2 +-
 drivers/platform/x86/intel-hid.c                   |   7 +
 drivers/platform/x86/thinkpad_acpi.c               |   6 +-
 drivers/platform/x86/touchscreen_dmi.c             |  18 ++
 drivers/regulator/pca9450-regulator.c              |  41 ++-
 drivers/remoteproc/qcom_sysmon.c                   |   2 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |  12 +-
 drivers/s390/crypto/zcrypt_cex4.c                  |   3 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   3 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  36 ++-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   3 +
 drivers/scsi/scsi_lib.c                            |   3 +-
 drivers/scsi/scsi_transport_sas.c                  |   2 +-
 drivers/scsi/ses.c                                 |   7 +-
 drivers/scsi/storvsc_drv.c                         |   5 +-
 drivers/scsi/ufs/ufshcd.c                          |  18 +-
 drivers/soc/bcm/bcm2835-power.c                    |  33 +-
 drivers/soc/fsl/qbman/qman.c                       |  24 +-
 drivers/spi/spi-fsl-lpspi.c                        |   3 +-
 drivers/staging/comedi/drivers.c                   |   8 +
 drivers/staging/comedi/drivers/dt2815.c            |  12 +
 drivers/staging/comedi/drivers/me4000.c            |  16 +-
 drivers/staging/comedi/drivers/me_daq.c            |  35 ++-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   3 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  16 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |  13 +-
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |  15 +
 drivers/tty/serial/8250/8250_pci.c                 |  17 +
 drivers/tty/serial/8250/8250_port.c                |   6 +
 drivers/usb/class/cdc-acm.c                        |  14 +
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/class/usbtmc.c                         |   9 +-
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/core/message.c                         |  97 ++++--
 drivers/usb/core/phy.c                             |   8 +-
 drivers/usb/core/quirks.c                          |   7 +
 drivers/usb/gadget/function/f_hid.c                |  11 +-
 drivers/usb/gadget/function/f_rndis.c              |   3 +
 drivers/usb/gadget/function/f_subset.c             |   7 +
 drivers/usb/gadget/function/f_tcm.c                |  14 +
 drivers/usb/gadget/function/f_uac1_legacy.c        |  47 ++-
 drivers/usb/gadget/function/f_uvc.c                |  46 ++-
 drivers/usb/gadget/function/u_ether.c              |   8 +-
 drivers/usb/gadget/function/uvc.h                  |   3 +
 drivers/usb/gadget/function/uvc_v4l2.c             |  13 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  13 +-
 drivers/usb/host/ehci-brcm.c                       |   4 +-
 drivers/usb/host/xhci.c                            |   4 +-
 drivers/usb/image/mdc800.c                         |   6 +-
 drivers/usb/misc/uss720.c                          |   2 +-
 drivers/usb/misc/yurex.c                           |   2 +-
 drivers/usb/renesas_usbhs/common.c                 |   9 +
 drivers/usb/roles/class.c                          |   7 +-
 drivers/usb/serial/io_edgeport.c                   |   3 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/xen/privcmd.c                              |  76 ++++-
 drivers/xen/xen-acpi-processor.c                   |   7 +-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/ioctl.c                                   |   3 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/volumes.c                                 |   5 +-
 fs/ceph/dir.c                                      |  15 +-
 fs/cifs/cifsencrypt.c                              |   3 +-
 fs/cifs/cifsglob.h                                 |  11 +
 fs/cifs/connect.c                                  |   1 -
 fs/cifs/dir.c                                      |   1 +
 fs/cifs/file.c                                     |  17 +-
 fs/cifs/smb2ops.c                                  |  18 +-
 fs/cifs/smb2transport.c                            |   4 +-
 fs/ext4/extents.c                                  |  22 +-
 fs/ext4/fast_commit.c                              |  17 +-
 fs/ext4/ialloc.c                                   |   6 +
 fs/ext4/inode.c                                    |  27 +-
 fs/ext4/mballoc.c                                  |  37 +--
 fs/ext4/super.c                                    |  13 +-
 fs/iomap/buffered-io.c                             |   7 +-
 fs/jbd2/checkpoint.c                               |  15 +-
 fs/nfsd/nfs4xdr.c                                  |   9 +-
 fs/nfsd/nfsctl.c                                   |  31 +-
 fs/nfsd/state.h                                    |  17 +-
 fs/squashfs/cache.c                                |   3 +
 fs/xfs/xfs_bmap_item.c                             |   3 +-
 fs/xfs/xfs_dquot.c                                 |   8 +-
 fs/xfs/xfs_dquot_item.c                            |   9 +-
 fs/xfs/xfs_inode_item.c                            |   9 +-
 fs/xfs/xfs_mount.c                                 |   7 +-
 include/acpi/acpixf.h                              | 138 +++++----
 include/asm-generic/tlb.h                          |  77 ++++-
 include/linux/dma-mapping.h                        |   4 +-
 include/linux/fwnode.h                             |  10 +-
 include/linux/hugetlb.h                            |  17 +-
 include/linux/indirect_call_wrapper.h              |  18 +-
 include/linux/irqchip/arm-gic-v3.h                 |   1 +
 include/linux/mm_types.h                           |   2 +
 include/linux/mmc/host.h                           |  12 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/property.h                           |   5 +-
 include/linux/security.h                           |   1 +
 include/linux/swapops.h                            |   6 +
 include/linux/usb.h                                |   8 +-
 include/net/netfilter/nf_conntrack_timeout.h       |   1 +
 include/net/netfilter/nf_tables.h                  |   5 +
 include/net/netlink.h                              |  39 ++-
 include/net/tc_act/tc_gate.h                       |  33 +-
 include/net/udp_tunnel.h                           |   2 +-
 include/sound/soc-dai.h                            |  85 ++++-
 include/sound/soc.h                                |   2 +
 include/trace/events/kmem.h                        |   8 +-
 include/uapi/linux/dma-buf.h                       |   1 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 include/uapi/sound/asoc.h                          |  22 +-
 io_uring/io-wq.c                                   |   2 +-
 io_uring/io_uring.c                                |  39 ++-
 kernel/bpf/verifier.c                              |  11 +-
 kernel/cgroup/cgroup.c                             |   1 +
 kernel/fork.c                                      |   2 +-
 kernel/futex/core.c                                |   3 +-
 kernel/sched/idle.c                                |  39 ++-
 kernel/sysctl.c                                    |   2 +-
 kernel/time/alarmtimer.c                           |   2 +-
 kernel/time/time.c                                 | 171 +++++++++-
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_events.c                        |  51 ++-
 lib/bootconfig.c                                   |   6 +-
 lib/crypto/chacha.c                                |   4 +
 lib/nlattr.c                                       |  22 ++
 mm/hugetlb.c                                       | 143 ++++-----
 mm/mmu_gather.c                                    |  36 +++
 mm/rmap.c                                          |  20 +-
 net/atm/lec.c                                      |  98 +++---
 net/atm/lec.h                                      |   2 +-
 net/batman-adv/bat_iv_ogm.c                        |   3 +
 net/batman-adv/bat_v_elp.c                         |  10 +-
 net/batman-adv/hard-interface.c                    |   8 +-
 net/batman-adv/hard-interface.h                    |   1 +
 net/batman-adv/translation-table.c                 |   9 +-
 net/bluetooth/hidp/core.c                          |  16 +-
 net/bluetooth/l2cap_core.c                         |  55 +++-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/mgmt.c                               |   3 +
 net/bluetooth/smp.c                                |  13 +-
 net/bridge/br_arp_nd_proxy.c                       |  18 +-
 net/bridge/br_device.c                             |   2 +-
 net/bridge/br_input.c                              |   2 +-
 net/can/af_can.c                                   |   4 +-
 net/can/af_can.h                                   |   2 +-
 net/can/bcm.c                                      |   1 +
 net/can/gw.c                                       |   6 +-
 net/can/proc.c                                     |   3 +-
 net/ceph/auth.c                                    |   6 +-
 net/core/dev.c                                     |   2 +-
 net/core/rtnetlink.c                               |   9 +-
 net/ipv4/esp4.c                                    |  11 +-
 net/ipv4/icmp.c                                    |   4 +-
 net/ipv4/tcp_ipv4.c                                |   5 +-
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/datagram.c                                |  10 +
 net/ipv6/esp6.c                                    |  11 +-
 net/ipv6/icmp.c                                    |   3 +
 net/ipv6/ip6_flowlabel.c                           |   5 -
 net/ipv6/ip6_tunnel.c                              |   7 +-
 net/ipv6/ndisc.c                                   |   3 +
 net/ipv6/netfilter/ip6t_rt.c                       |   4 +
 net/ipv6/route.c                                   |  11 +-
 net/ipv6/seg6_iptunnel.c                           |  34 +-
 net/ipv6/tcp_ipv6.c                                |   5 +-
 net/ipv6/xfrm6_output.c                            |   4 +-
 net/key/af_key.c                                   |  19 +-
 net/l2tp/l2tp_ppp.c                                |  25 +-
 net/mac80211/mesh.c                                |   6 +
 net/ncsi/ncsi-aen.c                                |   3 +-
 net/ncsi/ncsi-rsp.c                                |  16 +-
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/nf_conntrack_expect.c                |   4 +
 net/netfilter/nf_conntrack_h323_asn1.c             |   4 +
 net/netfilter/nf_conntrack_helper.c                |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |  89 +++---
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |  20 +-
 net/netfilter/nf_tables_api.c                      |  12 +-
 net/netfilter/nfnetlink_cthelper.c                 |   8 +-
 net/netfilter/nfnetlink_log.c                      |  10 +-
 net/netfilter/nfnetlink_osf.c                      |  13 +
 net/netfilter/nfnetlink_queue.c                    |   4 +-
 net/netfilter/nft_ct.c                             |  11 +-
 net/netfilter/nft_payload.c                        |   6 +-
 net/netfilter/nft_set_pipapo.c                     |  46 ++-
 net/netfilter/nft_set_pipapo.h                     |   2 +
 net/netfilter/x_tables.c                           |  23 ++
 net/netfilter/xt_CT.c                              |   4 +
 net/netfilter/xt_IDLETIMER.c                       |   6 +
 net/netfilter/xt_cgroup.c                          |   6 +
 net/netfilter/xt_dccp.c                            |   4 +-
 net/netfilter/xt_rateest.c                         |   5 +
 net/netfilter/xt_tcpudp.c                          |   6 +-
 net/netfilter/xt_time.c                            |   4 +-
 net/nfc/nci/core.c                                 |  31 +-
 net/nfc/nci/data.c                                 |  12 +-
 net/nfc/rawsock.c                                  |  11 +
 net/openvswitch/flow_netlink.c                     |   2 +
 net/openvswitch/vport-netdev.c                     |   9 +-
 net/packet/af_packet.c                             |   1 +
 net/qrtr/af_qrtr.c                                 |  66 ++--
 net/rds/ib_rdma.c                                  |   7 +-
 net/rfkill/core.c                                  |  40 ++-
 net/rose/af_rose.c                                 |   5 +
 net/rxrpc/af_rxrpc.c                               |   6 -
 net/rxrpc/key.c                                    |   2 +-
 net/sched/act_gate.c                               | 264 +++++++++++-----
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flow.c                               |  10 +-
 net/sched/cls_fw.c                                 |  14 +-
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_hfsc.c                               |   4 +-
 net/sched/sch_teql.c                               |   1 +
 net/smc/smc_rx.c                                   |   9 +-
 net/sunrpc/cache.c                                 |  26 +-
 net/tipc/group.c                                   |   6 +-
 net/tipc/socket.c                                  |   2 +
 net/wireless/core.c                                |   1 +
 net/wireless/pmsr.c                                |   1 +
 net/wireless/radiotap.c                            |   4 +-
 net/x25/x25_in.c                                   |   9 +-
 net/x25/x25_subr.c                                 |   1 +
 net/xfrm/xfrm_interface_core.c                     |   2 +-
 net/xfrm/xfrm_output.c                             |   7 +-
 net/xfrm/xfrm_policy.c                             |   2 +-
 net/xfrm/xfrm_state.c                              |   1 +
 net/xfrm/xfrm_user.c                               |   1 +
 security/apparmor/apparmorfs.c                     | 228 ++++++++------
 security/apparmor/include/label.h                  |  16 +-
 security/apparmor/include/lib.h                    |  12 +
 security/apparmor/include/match.h                  |   1 +
 security/apparmor/include/policy.h                 |  13 +-
 security/apparmor/include/policy_ns.h              |   2 +
 security/apparmor/include/policy_unpack.h          |  83 +++--
 security/apparmor/label.c                          |  12 +-
 security/apparmor/match.c                          |  58 +++-
 security/apparmor/policy.c                         |  82 ++++-
 security/apparmor/policy_ns.c                      |   2 +
 security/apparmor/policy_unpack.c                  |  74 +++--
 security/security.c                                |   1 +
 sound/core/pcm_lib.c                               |  11 +-
 sound/core/pcm_native.c                            |  25 +-
 sound/pci/ctxfi/ctdaio.c                           |   1 +
 sound/pci/hda/patch_conexant.c                     |  11 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/acp3x-rt5682-max9836.c               |   9 +-
 sound/soc/fsl/fsl_easrc.c                          |  14 +-
 sound/soc/intel/catpt/device.c                     |  10 +-
 sound/soc/intel/catpt/dsp.c                        |   3 -
 sound/soc/meson/meson-codec-glue.c                 |   3 -
 sound/soc/soc-core.c                               | 344 +++++++++++++++------
 sound/soc/soc-dai.c                                |  63 ++++
 sound/soc/soc-dapm.c                               |  24 +-
 sound/soc/soc-pcm.c                                |  10 +-
 sound/soc/soc-topology.c                           |  24 +-
 sound/soc/soc-utils.c                              |  29 ++
 sound/soc/sof/topology.c                           |   6 +-
 sound/soc/tegra/tegra_pcm.c                        |   3 +
 sound/usb/caiaq/device.c                           |   2 +-
 sound/usb/endpoint.c                               |   3 +
 sound/usb/validate.c                               |   2 +-
 tools/bootconfig/main.c                            |   7 +-
 tools/objtool/check.c                              |   5 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  11 +-
 458 files changed, 5215 insertions(+), 2261 deletions(-)


