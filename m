Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB73242925;
	Mon, 17 Aug 2026 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978875; cv=none; b=lFiWPLktJ1NFGjOeRJK/dwIhm5nSRsF18wqW/j+0Ql5Jy3M3lNnpKW9Y1LM9sHp85zvDli0ogQbS3zfNdCQcNKo6mPj/9h6yuLR/gn7//7wGaAt9URrLitljA67/1BDA1GyHPmIsjRs4uDJl8267bWRaqFo7vkqCZvMFrJTPTKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978875; c=relaxed/simple;
	bh=P+NOC/RwJVfk9GsJ/ek8cTpBthgo4aZnEGHFgIjqT0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rfsvL+0nqlGkqI2zfTWYB2YJRt03YyYbpG+ZMBOb6MmNKfbDj15mFWqXA6YgueS2iM4Tnzu5UChKqxO8w5ZN+8WIbekph7xYUPe7AZfjt/Tz4sbRaWO3/OFtRqmp5g5p6RmLB/O0ErF8+nlehrXyrSaytDl3eFnAAHMlXgL3fxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSH88u4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSH88u4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6891F000E9;
	Mon, 17 Aug 2026 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978870;
	bh=5+NclRMaDwoD5xFNIwZPrcSCk5fuqUx9IutlJhbud/U=;
	h=From:To:Cc:Subject:Date;
	b=GSH88u4qbOL91xyLJGD2tphGPa7o74+u/CS1BAIJ/5UfwKYA7EoRw+qJ9u9Zfpe/n
	 1wRBVTHEA0RyoD8Qeq46Mu/QUb+SZkacxhGsFkjxvm5YZQcmxZS3gdmNulRpAzUbCj
	 K0AzgLxfQ6vQ05ZV21D3/TcGL0Et2F/4Ox/5ms6A=
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
Subject: [PATCH 6.1 000/609] 6.1.183-rc1 review
Date: Mon, 17 Aug 2026 15:24:56 +0200
Message-ID: <20260817132543.039278408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.183-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.183-rc1
X-KernelTest-Deadline: 2026-08-19T13:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.183 release.
There are 609 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.183-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.183-rc1

Ahmad Khalifa <ahmad@khalifa.ws>
    hwmon: (nct6775) Fix non-existent ALARM warning

Ahmad Khalifa <ahmad@khalifa.ws>
    hwmon: (nct6775) Fix register for nct6799

David Lechner <dlechner@baylibre.com>
    regulator: devres: fix devm_regulator_get_enable_read_voltage() return

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bpf: tcp: fix double sock release on batch realloc

Bryam Vargas <hexlabsecurity@proton.me>
    thunderbolt: Bound the DROM dual link port number before indexing sw->ports

Qing Ming <a0yami@mailbox.org>
    sctp: clear new_transport when removing a peer

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    sctp: fix use-after-free of cached ASCONF chunk

Baul Lee <baul.lee@xbow.com>
    sctp: keep chunk->transport in step with the list it is queued on

Xu Rao <raoxu@uniontech.com>
    scsi: scsi_debug: Negate wrapped memcmp() result

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf, sockmap: Fix sk_redir use-after-free in send verdict

Tejun Heo <tj@kernel.org>
    sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_tunnel: clear skb2->cb[] in ip6ip6_err()

Yuejie Shi <syjcnss@gmail.com>
    ipv6: fix Route Information option length validation

Tengda Wu <wutengda@huaweicloud.com>
    ring-buffer: Use current_context for safe per-CPU buffer swap

Ahmad Byagowi <ahmadexp@gmail.com>
    ptp: ocp: Fix board ID over-read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "thermal/drivers/hwmon: Cleanup coding style a bit"

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: WARN and clear role.invalid when creating a child shadow page

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    smb: client: Fix use-after-free in cifs_try_adding_channels()

Jun Yang <junvyyang@tencent.com>
    tipc: read le->link under the node lock in tipc_node_link_down()

Jun Yang <junvyyang@tencent.com>
    vhost: reset the vring metadata cache on vring reconfiguration

Weiming Shi <bestswngs@gmail.com>
    vsock/virtio: avoid refilling the RX queue after teardown

Weiming Shi <bestswngs@gmail.com>
    vsock/virtio: read virtqueues under worker locks

Baul Lee <baul.lee@xbow.com>
    vxlan: do not arm the ageing timer on a device that is down

Zhiling Zou <zhilinz@nebusec.ai>
    xdp: reject clones that overrun skb_shared_info tailroom

Hyunjung Ko <hj351016@gmail.com>
    net/sched: act_gact, act_police: range check the fallback control action

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free RX pages of consumed but not refilled buffers

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free stranded TX buffers on ring deinit

Zhiling Zou <zhilinz@nebusec.ai>
    netfilter: bridge: release template ct on non-IP path

Kyle Zeng <kylebot@openai.com>
    ipv6: prevent in6_dev_get() from resurrecting inet6_dev

Daming Li <d4n.for.sec@gmail.com>
    net: smc: fix splice entry lifetime imbalance in smc_rx_splice

Rik van Riel <riel@surriel.com>
    fbdev: bitblit: bound-check glyph index in bit_cursor()

Michael Wu <michael@allwinnertech.com>
    tracing: Fix race between update_event_fields and, event_define_fields

Baul Lee <baul.lee@xbow.com>
    ALSA: usx2y: bound the hwdep mmap fault offset

Hui Su <sh_def@163.com>
    ring-buffer: Fix crash passing ERR_PTR to kthread_stop()

Eddie Lin <eddie.lin@oss.qualcomm.com>
    misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free

Anandu Krishnan E <anandu.e@oss.qualcomm.com>
    misc: fastrpc: fix channel ctx ref leak when session alloc fails

Mariano Baragiola <mbaragiola@linux.com>
    staging: rtl8723bs: validate monitor transmit frame lengths

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    staging: rtl8723bs: fix missing shared-key auth challenge length check

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in WMM_param_handler()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_get_wpa_ie()

Cunhao Lu <1579567540@qq.com>
    serial: 8250_dma: Clear stale RX state on shutdown

Chengfeng Ye <nicoyip.dev@gmail.com>
    ipv4: fix use-after-free in fib_nhc_update_mtu()

Zihan Xi <zihanx@nebusec.ai>
    ipv4: Fix fib_nlmsg_size() for RTA_VIA nexthops

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Fail unbound UDP on sockmap update

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Adapt sockmap update error handling

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Replace mk_users keyring with simple list

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix a use-after-free problem in rxe_mmap

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP

Nathan Chancellor <nathan@kernel.org>
    fortify: Disable -Wstringop-overread in tests

Masahiro Yamada <masahiroy@kernel.org>
    fortify: refactor test_fortify Makefile to fix some build problems

Keno Fischer <keno@juliacomputing.com>
    futex: Prevent robust futex exit race some more

Baul Lee <baul.lee@xbow.com>
    net: bridge: mrp: fix uninitialised bytes on the wire

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: ebt_nflog: pin the NFLOG backend

Qihang Tang <q.h.hack.winter@gmail.com>
    net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header

Sergey V. Frolov <Sergey.V.Frolov@kaspersky.com>
    net: octeontx2-pf: Fix UB in shift operation

Zijie Huang <milkory@outlook.com>
    net/sched: reject overly deep qdisc hierarchies

Zhiling Zou <zhilinz@nebusec.ai>
    net: openvswitch: reallocate update replies for mismatched IDs

Doruk Tan Ozturk <doruk@0sec.ai>
    net/packet: reset the MAC header on the packet-socket transmit path

Kyle Zeng <kylebot@openai.com>
    ipvs: clear IPv4 options after rebasing tunnel ICMP errors

Julian Anastasov <ja@ssi.bg>
    ipvs: properly update the overload flag on dest edit

Julian Anastasov <ja@ssi.bg>
    ipvs: add totalconns for dest

Lincoln Wallace <locnnil0@gmail.com>
    ima: fix out-of-bounds read in xattr_verify()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - fix information leak in evdev_pass_values()

Joshua Rogers <linux@joshua.hu>
    vt: stabilize tty reference in kbd_keycode with tty_port_tty_get

Joshua Rogers <linux@joshua.hu>
    vt: add permission check for KDSKBMETA ioctl

Yi Cong <yicong@kylinos.cn>
    net: usb: ax88179_178a: fix skb leak in ax88179_tx_fixup()

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: f_ncm: Use unsigned int for ndp_index

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix incorrect endian conversions for APB timeout register

Xu Rao <raoxu@uniontech.com>
    thunderbolt: icm: Preserve USB4 proxy data-valid bit

Aleksandr Nogikh <nogikh@google.com>
    usb: atm: cxacru: properly kill rcv_urb on error in cxacru_cm()

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix OOB write on Type II inbound URBs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - sanitize event type index when fetching event masks

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Avoid setup_accel logic for DMA transfers

Sean Christopherson <seanjc@google.com>
    KVM: x86: Check for invalid/obsolete root *after* making MMU pages available

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Rename __direct_map() to direct_map()

Qingshuang Fu <fuqingshuang@kylinos.cn>
    hwmon: (ads7828) Fix external VREF regulator handling

David Lechner <dlechner@baylibre.com>
    regulator: devres: add API for reference voltage supplies

Wilken Gottwalt <wilken.gottwalt@posteo.net>
    hwmon: (corsair-psu) fix possible out-of-bounds access on missing string termination

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    tls: don't abort the connection on signal-interrupted sends

Xin Long <lucien.xin@gmail.com>
    sctp: clear control chunk transport if it is being removed

Eric Dumazet <edumazet@google.com>
    net/atm: fix slab-out-of-bounds read in vcc_setsockopt()

Hongyan Xu <getshell@seu.edu.cn>
    ata: pata_sl82c105: fix bridge revision use-after-free

Fan XinRan <shinjiangjiang@gmail.com>
    net: thunderbolt: Tear down DMA paths before stopping the rings

Łukasz Patron <priv.luk@gmail.com>
    net: qrtr: ns: Raise lookup limit to 128

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix TOCTOU race between smc_listen_out() and listener close

Eric Dumazet <edumazet@google.com>
    net: remove WARN_ON_ONCE() from sk_mc_loop()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: prestera: validate firmware header length

Henry Martin <bsdhenrymartin@gmail.com>
    net/ncsi: fix heap OOB read in NCSI_CMD_SEND_CMD payload length

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: fix TFO max_qlen accounting across reuseport migration

Qing Luo <luoqing@kylinos.cn>
    sctp: fix addip_serial increment on ASCONF_ACK allocation failure

Keegan Freyhof <keegan.freyhof@broadcom.com>
    bnxt_en: Fix PTP PPS setting bug

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Disable EOP for TPA on all chips to prevent data corruption

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips

Martin Kaiser <martin@kaiser.cx>
    selftests/ftrace: refactor eprobes test to fix argument checks

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations

Rob Herring <robh@kernel.org>
    hwmon: (lm25066) Use i2c_get_match_data()

Qingshuang Fu <fuqingshuang@kylinos.cn>
    hwmon: (nzxt-smart2) Check return value of init_device() in probe

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/openvswitch: check Ethernet header length in key_extract()

Toke Høiland-Jørgensen <toke@toke.dk>
    net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    udp: fix potential use-after-free in tunnel segmentation

Yousef Alhouseen <alhouseenyousef@gmail.com>
    vhost/vdpa: reject overflowing PA map page counts on 32-bit

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: tcp: Fix use-after-free in bpf_iter_tcp_established_batch()

Jordan Rife <jordan@jrife.io>
    bpf: tcp: Avoid socket skips and repeats during iteration

Jordan Rife <jordan@jrife.io>
    bpf: tcp: Use bpf_tcp_iter_batch_item for bpf_tcp_iter_state batch items

Jordan Rife <jordan@jrife.io>
    bpf: tcp: Get rid of st_bucket_done

Jordan Rife <jordan@jrife.io>
    bpf: tcp: Make sure iter->batch always contains a full bucket snapshot

Jordan Rife <jordan@jrife.io>
    bpf: tcp: Make mem flags configurable through bpf_iter_tcp_realloc_batch

Jian Wen <wenjianhn@gmail.com>
    tcp: add a scheduling point in established_get_first()

Babanpreet Singh <bbnpreetsingh@gmail.com>
    counter: microchip-tcb-capture: Fix DT channel validation

Michael Guralnik <michaelgur@nvidia.com>
    net/mlx5: fw_tracer, return NULL on create error

Jiawen Liu <1298662399@qq.com>
    net: hisilicon: hix5hd2_gmac: remove redundant NAPI delete

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_route: fix fastmap use-after-free on filter

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: fix qentry overwrite for CONFIRM_LINK and ADD_LINK_CONT in smc_llc_event_handler()

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Preserve pointer state for commuted arithmetic

Dmitry Antipov <dmantipov@yandex.ru>
    btrfs: fix memory leak in btrfs_do_encoded_write()

Julian Anastasov <ja@ssi.bg>
    ipvs: return the csum validation for forward hook

Julian Anastasov <ja@ssi.bg>
    ipvs: avoid out-of-bounds write in ip_vs_nat_icmp

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: switch ext_size to atomic64_t

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bonding: alb: re-check primary_is_promisc under RTNL in bond_alb_monitor

Fan Ye <fy15309206903@gmail.com>
    Revert "net: thunderbolt: Enable end-to-end flow control also in transmit"

Yuho Choi <dbgh9129@gmail.com>
    ARM: npcm: Fix OF node refcount leaks in SMP setup

Anna Schumaker <anna.schumaker@hammerspace.com>
    NFS: Pin the 'struct nfs_server' during a FREE_STATEID call

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()

Al Viro <viro@zeniv.linux.org.uk>
    mount: honour SB_NOUSER in the new mount API

David Carlier <devnexen@gmail.com>
    Bluetooth: hci_conn: fix potential UAF in create_big_sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote netdev

Marco Elver <elver@google.com>
    Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref

Junjie Cao <junjie.cao@intel.com>
    gpio: pch: use raw_spinlock_t for the register lock

Tze Yee Ng <tze.yee.ng@altera.com>
    firmware: stratix10-svc: fix memory leaks and list corruption bugs

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during recirculation

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Make ahci_ignore_port() handle empty mask_port_map

Damien Le Moal <dlemoal@kernel.org>
    ata: libahci_platform: Do not set mask_port_map when not needed

HyeongJun An <sammiee5311@gmail.com>
    HID: logitech-dj: Fix maxfield check in DJ short report validation

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: bound DMA command body size against suffix pointer

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate DRAW_PRIMITIVES header size before division

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: drop dma_buf reference on foreign-fd prime import

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: hold event_mutex while checkpointing CRIU events

David Francis <David.Francis@amd.com>
    drm/amdkfd: Handle invalid event type in CRIU event restore

Harkirat Gill <harkirat.gill@amd.com>
    drm/amdgpu: cap GTT size to physical RAM on APUs

Candice Li <candice.li@amd.com>
    drm/amdgpu: restore UMD profile pstate after runtime resume

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Zero the tile state data array before each BIN job

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/vc4: Supply the overflow slot size in BPOS, not the whole bin BO size

Alexander Kaplan <alexander.kaplan@sms-medipool.de>
    drm/dp: Read the PCON max FRL bandwidth only for HDMI DFPs

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: mark error-active controller status valid

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: handle bus error interrupts

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: unmap BAR0 using base address

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: use self-test mode for PRESUME_ACK

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ctucanfd: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: peak_usb: validate uCAN receive record lengths

Maoyi Xie <maoyixie.tju@gmail.com>
    can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error

James Gao <jamesgao5@outlook.com>
    can: peak_usb: add bounds check for USB channel index

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: softing: fw_parse(): validate firmware record spans

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: use netdevice_tracker for j1939_{priv,session,ecu} tracking

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer

Guangshuo Li <lgs201920130244@gmail.com>
    can: etas_es58x: es58x_read_bulk_callback(): fix RX buffer leak on URB resubmit failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ems_usb: validate CPC message lengths

Lucas Martins Alves <lucas.alves@lumal21.com.br>
    can: c_can: c_can_chip_config(): keep controller in init mode until bittiming is configured

Liem <liem16213@gmail.com>
    i2c: imx: Cancel hrtimer before clearing slave pointer

Liem <liem16213@gmail.com>
    i2c: imx: Fix slave registration race and error handling

H. Nikolaus Schaller <hns@goldelico.com>
    i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock

Aaron Ma <aaron.ma@canonical.com>
    ice: wait for reset completion in ice_resume()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during ct

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix potential UAF on meter attach failure

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: keep SERDES scrambler and 8b/10b enabled for USB

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: use read-modify-write for SERDES scrambler bypass

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: fix L0_TM_DISABLE_SCRAMBLE_ENCODER mask

Holger Dengler <dengler@linux.ibm.com>
    s390/zcrypt: Validate length for CCA ECC private key requests

Holger Dengler <dengler@linux.ibm.com>
    s390/zcrypt: Validate length for CCA AES cipher key requests

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix potential NULL pointer dereference

Aswin Karuvally <aswin@linux.ibm.com>
    s390/qeth: Check CAP_NET_ADMIN for private ioctls

Xu Rao <raoxu@uniontech.com>
    power: supply: bq25890: fix the -10 C NTC lookup entry

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()

bui duc phuc <phucduc.bui@gmail.com>
    gpio: pca953x: fix cache_only and IRQ state on restore_context() failure

Myeonghun Pak <mhun512@gmail.com>
    i2c: amd-mp2: Unregister callback on adapter add failure

Hongyan Xu <getshell@seu.edu.cn>
    hwmon: (npcm750-pwm-fan): stop fan timer on device detach

Asim Viladi Oglu Manizada <manizada@pm.me>
    sctp: prevent peer transport count overflow

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    sctp: reject stale cookies with mismatched verification tags

Ibrahim Hashimov <security@auditcode.ai>
    scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/clone3: fix wild pointer access of getline due to missing init

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/filters: Fix false positive match in regex_match_full()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Check return value of __register_event() in trace_module_add_events()

Ming Lei <tom.leiming@gmail.com>
    ublk: reset kernel-owned dev_info fields in ublk_ctrl_add_dev()

Eric Dumazet <edumazet@google.com>
    vxlan: use pskb_network_may_pull() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: use neigh_ha_snapshot() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: unclone skb head before modifying eth header in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: re-fetch eth header after route_shortcircuit()

Michael Bommarito <michael.bommarito@gmail.com>
    um: vector: fix use-after-free in vector_mmsg_rx()

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()

Zhiling Zou <zhilinz@nebusec.ai>
    net: ipv6: clear suppressed fib6 rule result

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: stop fast-leave after deleting a port group

Link Lin <linkl@google.com>
    mm/page_reporting: use system_freezable_wq to fix UAF during suspend

Christian Brauner <brauner@kernel.org>
    binfmt_misc: reject a flag character as the field delimiter

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames

Zihan Xi <zihanx@nebusec.ai>
    tipc: avoid use-after-free in poll trace queue dumps

David Lee <david.lee@trailofbits.com>
    netfilter: ipset: do not update comments from kernel-side hash adds

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/smc: fix socket use-after-free during link group termination

Zhiling Zou <roxy520tt@gmail.com>
    ipvs: do not propagate one-packet flag to synced conns

Matt Vollrath <tactii@gmail.com>
    igbvf: Fix leak in TX DMA error cleanup

Dawei Feng <dawei.feng@seu.edu.cn>
    e1000: fix memory leak in e1000_probe()

Md Sadre Alam <md.alam@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Fix command element mask field for BAM v1.6.0+

Sonali Pradhan <sonalipradhan@google.com>
    ALSA: usb-audio: Clamp frame size in implicit-feedback mode

Sonali Pradhan <sonalipradhan@google.com>
    ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix broken entries in the volume lookup table

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix DVC coefficient write order

Norbert Szetei <norbert@doyensec.com>
    ALSA: pcm: wake linked drain waiters on unlink

Xu Rao <raoxu@uniontech.com>
    ALSA: lx6464es: fix period byte count for 16-bit streams

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix UAF at error handling during probe

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    bpf: lwt: Fix dst reference leak on reroute failure

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: validate numbered report payloads

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: reject frames without a transaction header

Luxiao Xu <rakukuip@gmail.com>
    audit: fix potential use-after-free in audit_del_rule()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    audit: fix potential integer overflow in audit_log_n_string()

Charles Vosburgh <trilobyte777@gmail.com>
    sctp: validate Adaptation Indication parameter length

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Validate AIBV and AISB before pinning guest pages

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix NULL dereference on AIBV allocation failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Reject adapter interrupt forwarding if already enabled

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Update x2APIC MSR intercepts if AVIC is inhibited while L2 is active

Xiangfeng Cai <caixiangfeng@bytedance.com>
    mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan <ziy@nvidia.com>
    mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: bm1880: add missing select GENERIC_PINCONF

Karl Mehltretter <kmehltretter@gmail.com>
    pinctrl: devicetree: don't free uninitialized dev_name on error path

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: microchip-sgpio: add missing select REGMAP_MMIO

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rhashtable: clear stale iter->p on table restart

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Give up GC if MSG_PEEK intervened.

Pengfei Zhang <zhangfeionline@gmail.com>
    ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __close_file_table_ids()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return success for deferred final close

Denis V. Lunev <den@openvz.org>
    qede: sync udp_tunnel ports outside qede_lock in the recovery path

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Set correct sequence for carrier off and tx queue stop

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Reset dropped_count in mmio_reset_data()

Minhong He <heminhong@kylinos.cn>
    can: isotp: check register_netdevice_notifier() error in module init

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: check descriptor ring allocation failures

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: free TX rings on RX allocation failure

Leon Romanovsky <leon@kernel.org>
    scsi: target: Clear cmd_cnt when initial counter enrollment fails

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix memory leak during adapter release by destroying gid_pn_req

Christian Marangi <ansuelsmth@gmail.com>
    net: phylink: put link_gpio if phylink_create fails

Jiale Yao <yaojiale02@163.com>
    Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value from pmbus_update_byte_data()

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate individual TWT params before driver setup

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-akebono CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-currituck CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix simpleboot CPU node lookup check

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix PWM auto temp state array and bounds check

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Use cached PWM frequency value

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix temperature alarm logic in hwmon_temp_read()

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix cache updated before hardware write on I2C error

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors

Chenguang Zhao <zhaochenguang@kylinos.cn>
    forcedeth: fix UAF of txrx_stats in nv_remove

David Corvaglia <david@corvaglia.dev>
    net: bridge: mrp: fix Option TLV length in MRP_Test frames

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Prevent access to unsupported weight registers

Eric Dumazet <edumazet@google.com>
    net: do not send ICMP/NDISC Redirects when peer allocation fails

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nzxt-smart2) DMA-align output buffer

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Only report alarms if driver is ready

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Fix number of temperature registers for NCT6116

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775) Fix access to temperature configuration registers

Ahmad Khalifa <ahmad@khalifa.ws>
    hwmon: (nct6775) Additional TEMP registers for nct6799

Ahmad Khalifa <ahmad@khalifa.ws>
    hwmon: (nct6775) Add support for 18 IN readings for nct6799

Ahmad Khalifa <ahmad@khalifa.ws>
    hwmon: (nct6775) Increase and reorder ALARM/BEEP bits

Ahmad Khalifa <ahmad@khalifa.ws>
    hwmon: (nct6775) Fix IN scaling factors for 6798/6799

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6755) Add support for NCT6799D

Dawei Feng <dawei.feng@seu.edu.cn>
    smb: client: fix buffer leaks in SMB1 read and write

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race

John Garry <john.g.garry@oracle.com>
    scsi: libsas: Delete struct scsi_core

Jason Yan <yanaijie@huawei.com>
    scsi: libsas: Abort all in-flight requests when device is gone

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi_tcp: Bound SCSI Response data segment to the connection buffer

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl-amd: Don't clear S4 wake bits at probe

Xiang Mei <xmei5@asu.edu>
    rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: nft_payload: fix mask build for partial field offload

Julian Anastasov <ja@ssi.bg>
    ipvs: do not mangle ICMP replies for non-first fragments

Julian Anastasov <ja@ssi.bg>
    ipvs: fix places with wrong packet offsets

Julian Anastasov <ja@ssi.bg>
    ipvs: fix the checksum validations

Eric Dumazet <edumazet@google.com>
    ipv6: introduce dst_rt6_info() helper

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH

Michael Bommarito <michael.bommarito@gmail.com>
    assoc_array: trim the final shortcut word using the current chunk end

Michael Bommarito <michael.bommarito@gmail.com>
    keys: make keyring key-chunk byte order agree with keyring_diff_objects()

Michael Bommarito <michael.bommarito@gmail.com>
    keys: fix out-of-bounds read in keyring_get_key_chunk()

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/mediatek: Check CRTC state before freeing

Xiang Mei <xmei5@asu.edu>
    netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix runtime PM leak on probe allocation failure

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix clock error handling in xpsgtr_phy_init()

Mike Looijmans <mike.looijmans@topic.nl>
    phy-zynqmp: Postpone getting clock rate until actually needed

Sean Anderson <sean.anderson@seco.com>
    phy: zynqmp: Allow variation in refclk rate

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()

Damien Le Moal <dlemoal@kernel.org>
    ahci: Introduce ahci_ignore_port() helper

Josua Mayer <josua@solid-run.com>
    ata: libahci_platform: support non-consecutive port numbers

Rosen Penev <rosenp@gmail.com>
    ata: sata_mv: accept 1 or 2 resources in platform probe

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: sc8280xp: Add missing wakeup entries for GPIO143/151

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    net: qrtr: ns: Raise node count limit to 512

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum server registration per node

Benjamin Tissoires <bentiss@kernel.org>
    HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report

Lee Jones <lee@kernel.org>
    HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write

Lee Jones <lee@kernel.org>
    HID: logitech-dj: Standardise hid_report_enum variable nomenclature

Eddie Phillips <eddiephillips@google.com>
    gve: fix Rx queue stall on alloc failure

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix sequence number when no EOF

Isaac Scott <isaac.scott@ideasonboard.com>
    media: uvcvideo: Implement dual stream quirk to fix loss of usb packets

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: mpls: initialize rtm_tos in mpls_getroute()

Lorenzo Bianconi <lorenzo@kernel.org>
    netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: restore helper propagation via expectation

SJ Park <sj@kernel.org>
    mm/damon/core: disallow overlapping input ranges for damon_set_regions()

SJ Park <sj@kernel.org>
    mm/damon/core: validate ranges in damon_set_regions()

Yitang Yang <yi1tang.yang@gmail.com>
    io_uring/rw: fix missing ERESTARTSYS conversion in read paths

Nikunj A Dadhania <nikunj@amd.com>
    KVM: SVM: Bump asid_generation on CPU online to avoid ASID collision after hotplug

Wentao Guan <guanwentao@uniontech.com>
    bpf: drop bpf_lsm_getselfattr from hook list

Namjae Jeon <linkinjeon@kernel.org>
    exfat: validate cluster allocation bits of the allocation bitmap

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Avoid dynamic allocation in fscrypt_get_devices()

Kyle Zeng <kylebot@openai.com>
    openvswitch: fix GSO userspace truncation underflow

Weiming Shi <bestswngs@gmail.com>
    tipc: fix use-after-free of the discoverer in tipc_disc_rcv()

Weiming Shi <bestswngs@gmail.com>
    ipv6: ndisc: fix NULL deref in accept_untracked_na()

Jacob Keller <jacob.e.keller@intel.com>
    i40e: remove read access to debugfs files

Xie Bo <xb@ultrarisc.com>
    RISC-V: KVM: Serialize virtual interrupt pending state updates

Ce Sun <cesun102@amd.com>
    drm/amdgpu: invoke pm_genpd_remove() before freeing genpd

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu: fix division by zero with invalid uvd dimensions

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu/vce: fix integer overflow in image size

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx8: drop unecessary BUG_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: make pp_features read-only when scpm is enabled

Daehyeon Ko <4ncienth@gmail.com>
    tipc: clear sock->sk on the failed-insert path in tipc_sk_create()

Asim Viladi Oglu Manizada <manizada@pm.me>
    pppoe: reload header pointer after dev_hard_header()

Doruk Tan Ozturk <doruk@0sec.ai>
    mctp: serial: handle zero-length frames to prevent rx buffer overflow

Doruk Tan Ozturk <doruk@0sec.ai>
    mac802154: llsec: reject frames shorter than the authentication tag

Michael Bommarito <michael.bommarito@gmail.com>
    ila: reload IPv6 header after pskb_may_pull in checksum adjust

Sergey Temerkhanov <sergey.temerkhanov@intel.com>
    ice: use READ_ONCE() to access cached PHC time

James Montgomery <james_montgomery@disroot.org>
    ksmbd: defer destroy_previous_session() until after NTLM authentication

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    rbd: Reset positive result codes to zero in object map update path

Jann Horn <jannh@google.com>
    proc: Fix broken error paths for namespace links

Fan Wu <fanwu01@zju.edu.cn>
    net: hip04: fix RX buffer leak on build_skb failure

David Lee <david.lee@trailofbits.com>
    net/x25: fix use-after-free in x25_kill_by_neigh()

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: fix use-after-free of a severed iucv_path

Hidayath Khan <hidayath@linux.ibm.com>
    net/af_iucv: fix NULL deref in afiucv_hs_callback_syn()

Doruk Tan Ozturk <doruk@0sec.ai>
    geneve: require CAP_NET_ADMIN in the device netns for changelink

Sungmin Kang <726ksm@gmail.com>
    net: slip: serialize receive against buffer reallocation

Doruk Tan Ozturk <doruk@0sec.ai>
    vxlan: require CAP_NET_ADMIN in the device netns for changelink

Breno Leitao <leitao@debian.org>
    phonet: pep: fix use-after-free in pep_get_sb()

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Disallow SVA if page walk is not coherent

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Add global mutex to serialize trace_parser access

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Add missing superblock check in find_or_insert_direct_key()

Christian Brauner <brauner@kernel.org>
    binfmt_elf_fdpic: only honour the first PT_INTERP

Douya Le <ldy3087146292@gmail.com>
    libceph: remove debugfs files before client teardown

Douya Le <ldy3087146292@gmail.com>
    libceph: reject zero bucket types in crush_decode

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Reject monmaps advertising zero monitors

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    libceph: refresh auth->authorizer_buf{,_len} after authorizer update

Zhao Zhang <zzhan461@ucr.edu>
    libceph: guard missing CRUSH type name lookup

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix multiplication overflow in decode_new_up_state_weight()

Douya Le <ldy3087146292@gmail.com>
    libceph: bound get_version reply decode to front len

Bryam Vargas <hexlabsecurity@proton.me>
    ceph: fix pre-auth out-of-bounds read on snaptrace in ceph_handle_caps()

Jun Yang <junvyyang@tencent.com>
    sctp: don't free the ASCONF's own transport in DEL-IP processing

Michael Bommarito <michael.bommarito@gmail.com>
    mptcp: only set DATA_FIN when a mapping is present

Chenguang Zhao <zhaochenguang@kylinos.cn>
    mptcp: decrement subflows counter on failed passive join

Will Deacon <will@kernel.org>
    Revert "arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates"

Will Deacon <will@kernel.org>
    arm64: syscall: Ensure saved x0 is kept in-sync with tracer updates

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Fix potential underflow in LEN_OR_ZERO macro

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Avoid temporary buffer truncation in trace_probe_match_command_args()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()

deepakraog <gaikwad.dcg@gmail.com>
    tracing: Fix resource leak on mmiotrace trace_pipe close

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev

Guangshuo Li <lgs201920130244@gmail.com>
    intel_th: fix MSC output device reference leak

Jiangshan Yi <yijiangshan@kylinos.cn>
    serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: implement gpio get_direction() callback

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_parport: deal with premature interrupt

Nathan Chancellor <nathan@kernel.org>
    x86/boot/compressed: Disable jump tables

Xu Rao <raoxu@uniontech.com>
    cdrom: fix stack out-of-bounds read in CDROMVOLCTRL

Zixing Liu <liushuyu@aosc.io>
    platform/loongarch: laptop: Explicitly reset bl_powered state when suspend

Christian Brauner <brauner@kernel.org>
    binfmt_misc: set have_execfd only once the interpreter is opened

Christian Brauner <brauner@kernel.org>
    exec: fix unsigned loop counter wrap in transfer_args_to_stack()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix session UAF in set_termios

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Protect UUID list traversal

MinJea Kim <qndkdrnl@gmail.com>
    staging: rtl8723bs: fix inverted HT40 secondary channel offset

Moksh Panicker <mokshpanicker.7@gmail.com>
    staging: rtl8723bs: fix OOB reads in rtw_get_wps_ie()

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: make release_scratchbuffers idempotent

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: drop TXRX_NOTIFY on non-mmio buses

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses

Huihui Huang <hhhuang@smu.edu.sg>
    wifi: wilc1000: validate assoc response length before subtracting header

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB access from firmware ADDBA window size

Norbert Szetei <norbert@doyensec.com>
    ALSA: seq: close a re-opened queue timer in the destructor

Johan Hovold <johan@kernel.org>
    media: vpif_capture: fix OF node reference imbalance

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: check for vb2_is_busy() when toggling caps

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: add vivid_update_reduced_fps()

Guangshuo Li <lgs201920130244@gmail.com>
    media: vimc: fix reference leak on failed device registration

Guangshuo Li <lgs201920130244@gmail.com>
    media: vidtv: fix reference leak on failed device registration

Zile Xiong <xiongzile99@gmail.com>
    media: vb2: use ssize_t for vb2_read/vb2_write

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: v4l2-ctrls: validate HEVC active reference counts

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    media: v4l2-ctrls-request: add NULL check in v4l2_ctrl_request_complete()

Myeonghun Pak <mhun512@gmail.com>
    media: ti: vpe: unwind v4l2 device registration on probe error

Hungyu Lin <dennylin0707@gmail.com>
    media: tegra-video: vi: fix invalid u32 return value in format lookup

Valery Borovsky <vebohr@gmail.com>
    media: sun4i-csi: Return queued buffers on start_streaming() failure

Myeonghun Pak <mhun512@gmail.com>
    media: stm32: dcmi: unregister notifier on probe failure

Ma Ke <make24@iscas.ac.cn>
    media: saa7134: Fix a possible memory leak in saa7134_video_init1

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: Return queued buffers on start_streaming() failure

Deepanshu Kartikey <kartikey406@gmail.com>
    media: rtl2832: fix use-after-free in rtl2832_remove()

Myeonghun Pak <mhun512@gmail.com>
    media: radio-si476x: Unregister v4l2_device on probe failure

Valery Borovsky <vebohr@gmail.com>
    media: pwc: Return queued buffers on start_streaming() failure

Valery Borovsky <vebohr@gmail.com>
    media: pwc: Drain fill_buf on start_streaming() failure

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    media: pci: dm1105: Free allocated workqueue

Valery Borovsky <vebohr@gmail.com>
    media: msi2500: Return queued buffers on start_streaming() failure

Anand Moon <linux.amoon@gmail.com>
    media: meson: vdec: Fix memory leak in error path of vdec_open

Guangshuo Li <lgs201920130244@gmail.com>
    media: marvell-cam: fix missing pci_disable_device() on remove

Wang Jun <1742789905@qq.com>
    media: cx23885: add ioremap return check and cleanup

Johan Hovold <johan@kernel.org>
    media: cx231xx: fix devres lifetime

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: cedrus: skip invalid H.264 reference list entries

Samuel Holland <samuel@sholland.org>
    media: cedrus: Fix missing cleanup in error path

Myeonghun Pak <mhun512@gmail.com>
    media: cedrus: clean up media device on probe failure

Myeonghun Pak <mhun512@gmail.com>
    media: cec: seco: unregister adapter on IR probe failure

David Carlier <devnexen@gmail.com>
    media: aspeed: fix missing of_reserved_mem_device_release() on probe failure

Valery Borovsky <vebohr@gmail.com>
    media: airspy: Return queued buffers on start_streaming() failure

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate vmw_surface_metadata::array_size

Zhu Lingshan <lingshan.zhu@amd.com>
    drm/amdgpu: fix bo->pin leaking in amdgpu_bo_create_reserved

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/ci: Don't disable MCLK DPM on Bonaire 0x6658 (R7 260X)

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Fix VFCT bus number matching with soft filter

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Fix NULL deref in I915_CONTEXT_PARAM_SSEU

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Do not leak siblings[] on proto context error

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915: Return NULL on error in active_instance

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma6.0: replace BUG_ON() with WARN_ON()

Bryam Vargas <hexlabsecurity@proton.me>
    drm/virtio: bound EDID block reads to the response buffer

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds in allocate_event_notification_slot

Pavel Ondračka <pavel.ondracka@gmail.com>
    drm/radeon: fix r100_copy_blit for large BOs

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gem: Add missing nospec on parallel submit slot

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Fix amdgpu_bo_move() when old_mem and new_mem are both GTT

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads on 2-byte fields in sideband reply parsers

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix buffer overflows in sideband chunk accumulation

Ashutosh Desai <ashutoshdesai993@gmail.com>
    drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf, sockmap: Fix cork use-after-free in tcp_bpf_sendmsg()

Li RongQing <lirongqing@baidu.com>
    net: ipv6: fix dif and sdif mismatch in raw6_icmp_error

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Report zero bandwidth for non-ETS traffic classes

Yael Chemla <ychemla@nvidia.com>
    net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net: qrtr: restrict socket creation to the initial network namespace

Chenguang Zhao <zhaochenguang@kylinos.cn>
    hinic: remove unused ethtool RSS user configuration buffers

Eric Dumazet <edumazet@google.com>
    ppp: annotate data races in ppp_generic

Qingfang Deng <dqfext@gmail.com>
    ppp: enable TX scatter-gather

Qingfang Deng <dqfext@gmail.com>
    ppp: convert to percpu netstats

Qingfang Deng <dqfext@gmail.com>
    ppp: use IFF_NO_QUEUE in virtual interfaces

Eric Dumazet <edumazet@google.com>
    ipv4: icmp: fill flow parameters in icmp_route_lookup decoy lookup

Suman Ghosh <sumang@marvell.com>
    octeontx2-vf: set TC flower flag on MCAM entry allocation

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: reset residual action in L3L4 filters on delete

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: fix l3l4 filter rejecting unsupported offload requests

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix u16 MTU truncation in media and bearer MTU validation

Harshaka Narayana <harshaka.narayana@broadcom.com>
    vmxnet3: fix BUG_ON in vmxnet3_get_hdr_len() for Geneve packets

Qing Luo <luoqing@kylinos.cn>
    sctp: auth: verify auth requirement when auth_chunk is NULL

Eric Dumazet <edumazet@google.com>
    net: hsr: fix memory leak on slave unregistration by removing synced VLANs

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix vlan range dumps starting with pvid

Michael Bommarito <michael.bommarito@gmail.com>
    amt: make the head writable before rewriting the L2 header

Michael Bommarito <michael.bommarito@gmail.com>
    amt: re-read skb header pointers after every pull

Shelley Yang <shelley.yang@infineon.com>
    wifi: brcmfmac: fix 802.1X-SHA256 call trace warning

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()

Ruoyu Wang <ruoyuw560@gmail.com>
    wifi: mt76: mt7915: guard HE capability lookups

Helen Koike <koike@igalia.com>
    tipc: fix infinite loop in __tipc_nl_compat_dumpit

Xiang Mei (Microsoft) <xmei5@asu.edu>
    nexthop: initialize extack in nh_res_bucket_migrate()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    gtp: check skb_pull_data() return in gtp1u_send_echo_resp()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: openvswitch: add config file

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: af_unix: add USER_NS config

Kuniyuki Iwashima <kuniyu@amazon.com>
    selftest: af_unix: Add Kconfig file.

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    sctp: validate stream count in sctp_process_strreset_inreq()

HanQuan <eilaimemedsnaimel@gmail.com>
    sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid

Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>
    amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN

Andrew Pope <andrew.pope@morsemicro.com>
    wifi: mac80211: recalculate TIM when a station enters power save

Li RongQing <lirongqing@baidu.com>
    iommu/intel: Fix out-of-bounds memset in dmar_latency_disable()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iommu/amd: Bound the early ACPI HID map

HE WEI (ギカク) <skyexpoc@gmail.com>
    wifi: mwifiex: bound uAP association event IEs to the event buffer

Ruoyu Wang <ruoyuw560@gmail.com>
    wan: wanxl: Only reset hardware after BAR mapping

Ruoyu Wang <ruoyuw560@gmail.com>
    nfp: Check resource mutex allocation

Guangshuo Li <lgs201920130244@gmail.com>
    dpaa2-eth: put MAC endpoint device on disconnect

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call

Guangshuo Li <lgs201920130244@gmail.com>
    dpaa2-switch: put MAC endpoint device on disconnect

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    rds: drop incoming messages that cross network namespace boundaries

Zhaolong Zhang <zhangzl68@chinatelecom.cn>
    bonding: fix devconf_all NULL dereference when IPv6 is disabled

David Lee <david.lee@trailofbits.com>
    net/packet: avoid fanout hook re-registration after unregister

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: occ: validate poll response sensor blocks

Yichong Chen <chenyichong@uniontech.com>
    smb: client: validate DFS referral PathConsumed

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) add missed handle for ENOMEM

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) fix EC read intervals

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) fix looping over banks while reading from EC

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    usb: atm: ueagle-atm: reject descriptors that confuse probe and disconnect

Shahar Tzarfati <shahar.tzarfati@intel.com>
    wifi: iwlwifi: mvm: fix read in wake packet notification handler

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI

Guanghui Yang <3497809730@qq.com>
    btrfs: free mapping node on duplicate reloc root insert

You-Kai Zheng <ykzheng@synology.com>
    btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8

Tristan Madani <tristan@talencesecurity.com>
    wifi: carl9170: fix buffer overflow in rx_stream failover path

Tristan Madani <tristan@talencesecurity.com>
    wifi: carl9170: fix OOB read from off-by-two in TX status handler

Tristan Madani <tristan@talencesecurity.com>
    wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB read from firmware IE lengths in connect event

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler

Ruoyu Wang <ruoyuw560@gmail.com>
    firewire: net: Fix fragmented datagram reassembly

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    wifi: ath11k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET

Dmitry Morgun <d.morgun@ispras.ru>
    wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop

Guenter Roeck <linux@roeck-us.net>
    hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop

Edward Adam Davis <eadavis@qq.com>
    hwmon: (corsair-psu) Stop device IO before calling hid_hw_stop

Gaole Zhang <gaole.zhang@oss.qualcomm.com>
    wifi: ath11k: fix NULL pointer dereference in ath11k_hal_srng_access_begin

Cheng Yongkang <teel4res@gmail.com>
    wifi: ath9k: hif_usb: don't dereference hif_dev after re-arming firmware request

Xincheng Zhang <zhangxincheng@ultrarisc.com>
    usb: xhci-pci: Limit VIA VL805 DMA addressing to 36 bits

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix ld_{abs,ind} failure path analysis in subprogs

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    bpf: Prefer dirty packs for eBPF allocations

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    bpf: Prefer packs that won't trigger an IBPB flush on allocation

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    bpf: Skip redundant IBPB in pack allocator

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    bpf: Restrict JIT predictor flush to cBPF

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Enable IBPB flush on BPF JIT allocation

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    bpf: Support for hardening against JIT spraying

Sasha Levin <sashal@kernel.org>
    Revert "drm/amd/display: Add missing kdoc for ALLM parameters"

Doruk Tan Ozturk <doruk@0sec.ai>
    crypto: rsa-pkcs1pad: Don't WARN on an empty digest

Chukun Pan <amadeus@jmu.edu.cn>
    USB: serial: option: add TDTECH MT5710-CN

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan_pda: fix data loss on receive throttling

Sunho Park <shpark061104@gmail.com>
    USB: serial: io_edgeport: cap received transmit credits

Tim Pambor <timpambor@gmail.com>
    USB: serial: ftdi_sio: add support for E+H FXA291

Muhammad Bilal <meatuni001@gmail.com>
    usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: udc: bdc: free IRQ and drain func_wake_notify before teardown

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: f_ncm: validate datagram bounds in ncm_unwrap_ntb()

Johan Hovold <johan@kernel.org>
    USB: gadget: fsl-udc: fix device name leak on probe failure

Johan Hovold <johan@kernel.org>
    USB: gadget: snps-udc: fix device name leak on probe failure

Melbin K Mathew <mlbnkm1@gmail.com>
    usb: gadget: printer: fix infinite loop in printer_read()

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: f_midi: cancel pending IN work before freeing the midi object

Jinchao Wang <wangjinchao600@gmail.com>
    usb: gadget: dummy_hcd: prevent fifo_req reuse during giveback

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: fix usage_count leak when autosuspend_delay is negative

Huang Wei <huangwei@kylinos.cn>
    USB: storage: add NO_ATA_1X quirk for Longmai USB Key

Huihui Huang <hhhuang@smu.edu.sg>
    wifi: at76c50x-usb: avoid length underflow in at76_guess_freq()

Weiming Shi <bestswngs@gmail.com>
    mpls: fix NULL deref in mpls_valid_fib_dump_req() on CONFIG_INET=n

Xin Long <lucien.xin@gmail.com>
    sctp: fix auth_hmacs array size in struct sctp_cookie

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_tunnel_key: Defer dst_release to RCU callback

Emre Cecanpunar <emreleno@gmail.com>
    drm/i915/selftests: Fix GT PM sort comparators

Xiang Mei (Microsoft) <xmei5@asu.edu>
    ksmbd: validate compound request size before reading StructureSize2

Shuhao Fu <sfual@cse.ust.hk>
    can: j1939: fix lockless local-destination check

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Reject unhashed UDP sockets on sockmap update

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/i915/gt: use correct selftest config symbol

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: handle overlapping allocated ranges in fallocate

Xiang Mei <xmei5@asu.edu>
    Bluetooth: qca: fix NVM tag length underflow in TLV parser

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Skip DSD quirk for Musical Fidelity M6s DAC

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: take a reference on the socket found in afiucv_hs_rcv()

Weiming Shi <bestswngs@gmail.com>
    ipv4: fib: free fib_alias with kfree_rcu() on insert error path

Norbert Szetei <norbert@doyensec.com>
    ppp: defer channel free to an RCU grace period to fix pppol2tp RX UAF

Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>
    firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context

Uday Khare <udaykhare77@gmail.com>
    ASoC: tas2562: fix deprecated 'shut-down' GPIO always cleared after lookup

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: ps: fix wrong ACP version string in pci_request_regions()

Christian Hewitt <christianshewitt@gmail.com>
    ASoC: meson: aiu: fifo-spdif: soft reset the S/PDIF datapath on start/stop

HE WEI (ギカク) <skyexpoc@gmail.com>
    wifi: cfg80211: bound element ID read when checking non-inheritance

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: brcmfmac: initialize SDIO data work before cleanup

Cen Zhang <zzzccc427@gmail.com>
    wifi: mac80211: free AP_VLAN bc_buf SKBs outside IRQ lock

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: reject unsupported PMSR FTM location requests

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate PMSR FTM preamble range

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate PMSR measurement type data

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: validate nested MBSSID IE blobs

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: free RNR data on MBSSID mismatch

Xiang Mei <xmei5@asu.edu>
    wifi: p54: validate RX frame length in p54_rx_eeprom_readback()

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: libertas: fix memory leak in helper_firmware_cb()

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mac80211_hwsim: clamp virtio RX length before skb_put

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()

Cen Zhang <zzzccc427@gmail.com>
    wifi: cfg80211: cancel sched scan results work on unregister

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: policy: preallocate inexact bins before xfrm_hash_rebuild reinsert

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm6: clear dst.dev on error to avoid double netdev_put in xfrm6_fill_dst()

Aleksandrova Alyona <aga@itb.spb.ru>
    RDMA/irdma: Prevent overflows in memory contiguity checks

Malaya Kumar Rout <malayarout91@gmail.com>
    selftests/alsa: Fix memory leak in find_controls error path

Ruoyu Wang <ruoyuw560@gmail.com>
    RDMA/siw: publish QP after initialization

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Only check attrs->cap.max_send_wr in siw_create_qp

Danila Chernetsov <listdansp@mail.ru>
    RDMA/hns: Fix potential integer overflow in mhop hem cleanup

Ruoyu Wang <ruoyuw560@gmail.com>
    RDMA/erdma: initialize ret for empty receive WR lists

Or Gerlitz <ogerlitz@ddn.com>
    RDMA/cma: Fix hardware address comparison length in netevent callback

Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
    firmware: arm_ffa: Fix NULL dereference in ffa_partition_info_get()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()

Xiang Mei <xmei5@asu.edu>
    btrfs: reject free space cache with more entries than pages

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: nand: mtk-ecc: stop on ECC idle timeouts

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: mtdswap: remove debugfs stats file on teardown

Michael Bommarito <michael.bommarito@gmail.com>
    IB/mad: Drop unmatched RMPP responses before reassembly

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Fix CPU compatible string to cortex-a78ae on Tegra234

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix logic error in packet reset

Seungjin Bae <eeodqql09@gmail.com>
    Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Clear receive-side ownership pointers on release

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    dmaengine: sh: rz-dmac: Move interrupt request after everything is set up

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: serialize TX state transitions under so->rx_lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix use-after-free race with concurrent NETDEV_UNREGISTER

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: track a single source interface for ANYDEV timeout/throttle ops

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix data race on rx_stamp/rx_ifindex in bcm_rx_handler()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix stale rx/tx ops after device removal

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing device refcount for CAN filter removal

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: validate frame length in bcm_rx_setup() for RTR replies

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: extend bcm_tx_lock usage for data and timer updates

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix CAN frame rx/tx statistics

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add locking when updating filter and timer values

Phil Rosenthal <phil@phil.gs>
    KVM: x86/mmu: Fix use-after-free on vendor module reload

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: nVMX: Hide shadow VMCS right after VMCLEAR

Heiko Carstens <hca@linux.ibm.com>
    seqlock: Allow UBSAN_ALIGNMENT to fail optimizing

Peter Zijlstra <peterz@infradead.org>
    seqlock: Allow KASAN to fail optimizing

Peter Zijlstra <peterz@infradead.org>
    seqlock: Cure some more scoped_seqlock() optimization fails

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/brs: Fix kernel address leakage

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Set gc_in_progress to true in unix_gc().

Guixiong Wei <weiguixiong@bytedance.com>
    platform/x86/intel-uncore-freq: Fix current_freq_khz after CPU hotplug


-------------

Diffstat:

 Documentation/driver-api/driver-model/devres.rst   |   1 +
 Makefile                                           |   4 +-
 arch/arm/mach-npcm/platsmp.c                       |   2 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |  24 +-
 arch/powerpc/boot/simpleboot.c                     |   2 +-
 arch/powerpc/boot/treeboot-akebono.c               |   2 +-
 arch/powerpc/boot/treeboot-currituck.c             |   2 +-
 arch/powerpc/platforms/ps3/mm.c                    |   1 +
 arch/riscv/include/asm/kvm_host.h                  |  10 +-
 arch/riscv/kvm/vcpu.c                              |  78 ++-
 arch/s390/kvm/pci.c                                |  28 +-
 arch/um/drivers/vector_kern.c                      |   3 +
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/events/amd/brs.c                          |  10 +-
 arch/x86/include/asm/nospec-branch.h               |   4 +
 arch/x86/kernel/cpu/bugs.c                         |  50 +-
 arch/x86/kvm/mmu/mmu.c                             |  73 +--
 arch/x86/kvm/mmu/mmu_internal.h                    |   3 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |  14 +-
 arch/x86/kvm/svm/avic.c                            |   8 -
 arch/x86/kvm/svm/svm.c                             |   7 +-
 arch/x86/kvm/vmx/nested.c                          |  11 +-
 arch/x86/net/bpf_jit_comp.c                        |   3 +-
 crypto/rsa-pkcs1pad.c                              |   2 +-
 drivers/ata/ahci.h                                 |  17 +-
 drivers/ata/ahci_brcm.c                            |   3 +
 drivers/ata/ahci_ceva.c                            |  24 +-
 drivers/ata/libahci.c                              |   1 +
 drivers/ata/libahci_platform.c                     |  38 +-
 drivers/ata/pata_sl82c105.c                        |   4 +-
 drivers/ata/sata_dwc_460ex.c                       |   8 +-
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/block/rbd.c                                |   7 +-
 drivers/block/ublk_drv.c                           |   9 +
 drivers/bluetooth/btqca.c                          |   2 +-
 drivers/cdrom/cdrom.c                              |   1 +
 drivers/comedi/drivers/comedi_parport.c            |  13 +-
 drivers/counter/microchip-tcb-capture.c            |   4 +-
 drivers/cpufreq/powernow-k8.c                      |   1 +
 drivers/dma/sh/rz-dmac.c                           |  96 ++--
 drivers/dma/sun6i-dma.c                            |  11 +-
 drivers/firewire/net.c                             |  37 +-
 drivers/firmware/arm_ffa/driver.c                  |   2 +-
 drivers/firmware/arm_scmi/notify.c                 |   6 +-
 drivers/firmware/stratix10-svc.c                   |  10 +-
 drivers/gpio/gpio-pca953x.c                        |  15 +-
 drivers/gpio/gpio-pch.c                            |  28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |  45 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  30 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c            |  17 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   3 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  26 +-
 .../amd/display/modules/info_packet/info_packet.c  |   2 -
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |   5 +
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c     |   7 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |  12 +
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  32 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |  25 +-
 drivers/gpu/drm/i915/gt/intel_engine_user.c        |   2 +-
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   8 +-
 drivers/gpu/drm/i915/i915_active.c                 |   7 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   6 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c     |   1 +
 drivers/gpu/drm/radeon/r100.c                      |  13 +-
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +
 drivers/gpu/drm/vc4/vc4_irq.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_validate.c                 |  29 +-
 drivers/gpu/drm/virtio/virtgpu_vq.c                |   3 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  22 +-
 drivers/gpu/host1x/bus.c                           |   4 +-
 drivers/hid/hid-logitech-dj.c                      |  28 +-
 drivers/hwmon/ads7828.c                            |  11 +-
 drivers/hwmon/adt7470.c                            | 131 +++--
 drivers/hwmon/asus-ec-sensors.c                    |  18 +-
 drivers/hwmon/corsair-cpro.c                       |   1 +
 drivers/hwmon/corsair-psu.c                        |   5 +-
 drivers/hwmon/lm90.c                               |   4 +-
 drivers/hwmon/nct6775-core.c                       | 435 ++++++++++++-----
 drivers/hwmon/nct6775-i2c.c                        |   2 +
 drivers/hwmon/nct6775-platform.c                   |  41 +-
 drivers/hwmon/nct6775.h                            |  33 +-
 drivers/hwmon/npcm750-pwm-fan.c                    |  11 +
 drivers/hwmon/nzxt-smart2.c                        |  10 +-
 drivers/hwmon/occ/common.c                         |  38 +-
 drivers/hwmon/pmbus/lm25066.c                      |  19 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   2 +-
 drivers/hwtracing/intel_th/core.c                  |  10 -
 drivers/hwtracing/intel_th/msu.c                   |   2 +
 drivers/i2c/busses/i2c-amd-mp2-plat.c              |   4 +-
 drivers/i2c/busses/i2c-imx.c                       |   9 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/infiniband/core/addr.c                     |   6 +-
 drivers/infiniband/core/cma.c                      |   2 +-
 drivers/infiniband/core/mad.c                      |  30 ++
 drivers/infiniband/hw/erdma/erdma_qp.c             |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   2 +-
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c               |  19 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  62 ++-
 drivers/input/evdev.c                              |  27 +-
 drivers/input/misc/ims-pcu.c                       |  32 +-
 drivers/iommu/amd/init.c                           |   6 +
 drivers/iommu/intel/perf.c                         |   2 +-
 drivers/iommu/intel/svm.c                          |   2 +-
 drivers/media/cec/platform/seco/seco-cec.c         |   6 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |  12 +-
 drivers/media/dvb-frontends/rtl2832.c              |   4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  19 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  14 +-
 drivers/media/pci/dm1105/dm1105.c                  |   1 +
 drivers/media/pci/saa7134/saa7134-video.c          |  25 +-
 drivers/media/platform/aspeed/aspeed-video.c       |   1 +
 drivers/media/platform/marvell/cafe-driver.c       |   1 +
 drivers/media/platform/st/stm32/stm32-dcmi.c       |   1 +
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c |   6 +-
 drivers/media/platform/ti/davinci/vpif_capture.c   |   2 +-
 drivers/media/platform/ti/vpe/vpe.c                |   3 +-
 drivers/media/radio/radio-si476x.c                 |   1 +
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |   1 +
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |  15 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |  38 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.h   |   1 +
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |   6 +
 drivers/media/usb/airspy/airspy.c                  |   8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  16 +-
 drivers/media/usb/msi2500/msi2500.c                |  32 +-
 drivers/media/usb/pwc/pwc-if.c                     |  13 +-
 drivers/media/usb/uvc/uvc_video.c                  |  76 ++-
 drivers/media/usb/uvc/uvcvideo.h                   |   4 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  13 +
 drivers/media/v4l2-core/v4l2-ctrls-request.c       |  14 +-
 drivers/misc/fastrpc.c                             |   3 +-
 drivers/mtd/mtdswap.c                              |   5 +-
 drivers/mtd/nand/ecc-mtk.c                         |  16 +-
 drivers/net/amt.c                                  |  87 +++-
 drivers/net/bonding/bond_alb.c                     |  10 +-
 drivers/net/bonding/bond_main.c                    |   3 +-
 drivers/net/can/c_can/c_can_main.c                 |   8 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |  14 +-
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |   3 +-
 drivers/net/can/softing/softing_fw.c               |  46 +-
 drivers/net/can/usb/ems_usb.c                      |  43 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   1 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  13 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  40 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  20 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  11 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  51 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   7 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  22 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   1 +
 drivers/net/ethernet/google/gve/gve.h              |   3 +
 drivers/net/ethernet/google/gve/gve_main.c         |   3 +
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  33 ++
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  11 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   1 -
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |   2 -
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |  21 -
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     | 121 +----
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   2 -
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  15 +
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   2 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_resource.c  |   3 +
 drivers/net/ethernet/nvidia/forcedeth.c            |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  44 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  35 ++
 drivers/net/geneve.c                               |   3 +
 drivers/net/gtp.c                                  |   5 +-
 drivers/net/mctp/mctp-serial.c                     |   2 +-
 drivers/net/phy/phylink.c                          |  29 +-
 drivers/net/ppp/ppp_generic.c                      | 154 +++---
 drivers/net/ppp/pppoe.c                            |   2 +
 drivers/net/ppp/pptp.c                             |   1 +
 drivers/net/slip/slip.c                            |   4 +
 drivers/net/thunderbolt.c                          |  33 +-
 drivers/net/usb/ax88179_178a.c                     |   4 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  22 +-
 drivers/net/vrf.c                                  |   2 +-
 drivers/net/vxlan/vxlan_core.c                     |  22 +-
 drivers/net/wan/wanxl.c                            |   3 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +
 drivers/net/wireless/ath/ath11k/pci.c              |   4 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  11 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |  10 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  20 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   7 +-
 drivers/net/wireless/ath/carl9170/rx.c             |   7 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   3 +-
 drivers/net/wireless/intersil/p54/txrx.c           |   8 +
 drivers/net/wireless/mac80211_hwsim.c              |   1 +
 drivers/net/wireless/marvell/libertas/firmware.c   |   1 +
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   6 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  10 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   5 +
 drivers/phy/xilinx/phy-zynqmp.c                    | 127 +++--
 drivers/pinctrl/Kconfig                            |   2 +
 drivers/pinctrl/devicetree.c                       |   4 +
 drivers/pinctrl/pinctrl-amd.c                      |   3 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |  21 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   4 +-
 drivers/platform/loongarch/loongson-laptop.c       |   1 +
 .../uncore-frequency/uncore-frequency-common.c     |  11 +-
 drivers/power/supply/bq25890_charger.c             |   2 +-
 drivers/ptp/ptp_ocp.c                              |   4 +-
 drivers/regulator/devres.c                         |  59 +++
 drivers/s390/block/dasd_ioctl.c                    |   2 +-
 drivers/s390/crypto/zcrypt_api.c                   |   2 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |  26 +-
 drivers/s390/net/qeth_core.h                       |   4 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/scsi/zfcp_aux.c                       |   1 +
 drivers/scsi/aic94xx/aic94xx_hwi.c                 |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  16 +-
 drivers/scsi/isci/host.h                           |   2 +-
 drivers/scsi/isci/init.c                           |   4 +-
 drivers/scsi/libiscsi.c                            |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   8 +-
 drivers/scsi/libsas/sas_ata.c                      |   8 +-
 drivers/scsi/libsas/sas_discover.c                 |  35 +-
 drivers/scsi/libsas/sas_expander.c                 |   2 +-
 drivers/scsi/libsas/sas_host_smp.c                 |   4 +-
 drivers/scsi/libsas/sas_init.c                     |  51 +-
 drivers/scsi/libsas/sas_phy.c                      |   8 +-
 drivers/scsi/libsas/sas_port.c                     |   6 +-
 drivers/scsi/libsas/sas_scsi_host.c                |  14 +-
 drivers/scsi/mvsas/mv_init.c                       |   4 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   2 +-
 drivers/scsi/scsi_debug.c                          |  12 +-
 drivers/spi/spi-fsl-dspi.c                         |  13 +-
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   6 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   3 +
 drivers/staging/media/tegra-video/vi.c             |   4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |  12 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   2 +-
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |   3 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   6 +-
 drivers/target/target_core_transport.c             |  12 +-
 drivers/thermal/thermal_hwmon.c                    |   3 +-
 drivers/thunderbolt/eeprom.c                       |   9 +-
 drivers/thunderbolt/icm.c                          |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |  12 +-
 drivers/tty/serial/8250/8250_mid.c                 |  14 +-
 drivers/tty/serial/sc16is7xx.c                     |  12 +
 drivers/tty/vt/keyboard.c                          |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 +
 drivers/usb/atm/cxacru.c                           |   2 +
 drivers/usb/atm/ueagle-atm.c                       |  17 +
 drivers/usb/cdns3/cdnsp-gadget.c                   |   4 +-
 drivers/usb/chipidea/core.c                        |   1 +
 drivers/usb/gadget/function/f_midi.c               |   1 +
 drivers/usb/gadget/function/f_ncm.c                |  19 +-
 drivers/usb/gadget/function/f_printer.c            |  23 +-
 drivers/usb/gadget/function/uvc_v4l2.c             |   2 +
 drivers/usb/gadget/udc/bdc/bdc_core.c              |  20 +
 drivers/usb/gadget/udc/bdc/bdc_udc.c               |   7 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  40 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   1 -
 drivers/usb/gadget/udc/snps_udc_core.c             |   1 -
 drivers/usb/host/xhci-pci.c                        |   1 +
 drivers/usb/host/xhci.c                            |  15 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/io_edgeport.c                   |   3 +-
 drivers/usb/serial/keyspan_pda.c                   |  44 +-
 drivers/usb/serial/option.c                        |   1 +
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/vhost/vdpa.c                               |   9 +-
 drivers/vhost/vhost.c                              |   8 +
 drivers/video/fbdev/core/bitblit.c                 |   9 +-
 drivers/watchdog/watchdog_pretimeout.c             |   2 +
 fs/binfmt_elf_fdpic.c                              |   4 +
 fs/binfmt_misc.c                                   |   9 +-
 fs/btrfs/free-space-cache.c                        |   3 +
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/relocation.c                              |   2 +
 fs/ceph/caps.c                                     |   1 +
 fs/crypto/fscrypt_private.h                        |  32 +-
 fs/crypto/inline_crypt.c                           |  57 +--
 fs/crypto/keyring.c                                | 212 ++++-----
 fs/crypto/keysetup_v1.c                            |   8 +-
 fs/exec.c                                          |   2 +-
 fs/exfat/balloc.c                                  |  54 ++-
 fs/f2fs/super.c                                    |  25 +-
 fs/namespace.c                                     |   5 +
 fs/nfs/nfs4proc.c                                  |   5 +
 fs/proc/namespaces.c                               |   4 +-
 fs/smb/client/cifssmb.c                            |  12 +-
 fs/smb/client/misc.c                               |  34 +-
 fs/smb/client/sess.c                               |   2 +-
 fs/smb/client/smb2ops.c                            |  25 +-
 fs/smb/server/smb2misc.c                           |   5 +
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/vfs_cache.c                          |   6 +-
 include/linux/dma/qcom_bam_dma.h                   |  21 +-
 include/linux/filter.h                             |  15 +-
 include/linux/fscrypt.h                            |  18 +-
 include/linux/netdevice.h                          |   5 -
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/netfilter/nf_conntrack_sip.h         |   2 +-
 include/linux/ppp_channel.h                        |   3 +-
 include/linux/regulator/consumer.h                 |   7 +
 include/linux/seqlock.h                            |  10 +-
 include/media/videobuf2-core.h                     |   8 +-
 include/net/act_api.h                              |  19 +
 include/net/addrconf.h                             |   4 +-
 include/net/af_unix.h                              |   1 +
 include/net/bluetooth/hci_core.h                   |  18 +
 include/net/bluetooth/l2cap.h                      |   1 +
 include/net/bluetooth/rfcomm.h                     |   3 +
 include/net/ip6_fib.h                              |   6 +-
 include/net/ip6_route.h                            |  11 +-
 include/net/ip_vs.h                                |  56 ++-
 include/net/neighbour.h                            |   8 +-
 include/net/netfilter/nf_conntrack_expect.h        |   5 +-
 include/net/route.h                                |   2 +
 include/net/sch_generic.h                          |   1 +
 include/net/sctp/structs.h                         |   3 +-
 include/scsi/libsas.h                              |   8 +-
 include/uapi/linux/btrfs.h                         |   2 +-
 io_uring/rw.c                                      |  28 +-
 kernel/audit.c                                     |  11 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/bpf/bpf_lsm.c                               |   1 -
 kernel/bpf/core.c                                  |  68 ++-
 kernel/bpf/dispatcher.c                            |   2 +-
 kernel/bpf/verifier.c                              |  32 +-
 kernel/futex/core.c                                |  82 +++-
 kernel/sched/psi.c                                 |   6 +
 kernel/trace/ftrace.c                              |  13 +
 kernel/trace/ring_buffer.c                         |  10 +-
 kernel/trace/trace_eprobe.c                        |   3 +-
 kernel/trace/trace_events.c                        |   6 +-
 kernel/trace/trace_events_filter.c                 |   3 +
 kernel/trace/trace_mmiotrace.c                     |   5 +-
 kernel/trace/trace_probe.c                         |  13 +-
 lib/.gitignore                                     |   2 -
 lib/Makefile                                       |  34 +-
 lib/assoc_array.c                                  |   3 +-
 lib/rhashtable.c                                   |   1 +
 lib/test_fortify/.gitignore                        |   2 +
 lib/test_fortify/Makefile                          |  29 ++
 mm/damon/core.c                                    |  13 +
 mm/huge_memory.c                                   |  16 +-
 mm/hugetlb.c                                       |  20 +-
 mm/page_reporting.c                                |   6 +-
 mm/percpu-km.c                                     |   2 +-
 net/atm/common.c                                   |  14 +-
 net/bluetooth/6lowpan.c                            |  20 +-
 net/bluetooth/hci_conn.c                           |  19 +-
 net/bluetooth/hci_sync.c                           |  13 +-
 net/bluetooth/hidp/core.c                          |  30 +-
 net/bluetooth/l2cap_core.c                         |  38 +-
 net/bluetooth/rfcomm/core.c                        |  17 +
 net/bluetooth/rfcomm/tty.c                         |   7 +-
 net/bridge/br_mrp.c                                |   8 +-
 net/bridge/br_multicast.c                          |   1 +
 net/bridge/br_netfilter_hooks.c                    |   6 +-
 net/bridge/br_netlink_tunnel.c                     |   3 +-
 net/bridge/br_private.h                            |   6 +-
 net/bridge/br_vlan.c                               |  10 +-
 net/bridge/br_vlan_options.c                       |   3 +-
 net/bridge/netfilter/ebt_nflog.c                   |  17 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   1 +
 net/can/bcm.c                                      | 528 +++++++++++++++------
 net/can/isotp.c                                    | 295 +++++++++---
 net/can/j1939/bus.c                                |   2 +
 net/can/j1939/j1939-priv.h                         |   3 +
 net/can/j1939/main.c                               |   8 +-
 net/can/j1939/transport.c                          |  22 +-
 net/ceph/auth_x.c                                  |   9 +-
 net/ceph/ceph_common.c                             |   4 +-
 net/ceph/mon_client.c                              |   4 +-
 net/ceph/osdmap.c                                  |  12 +-
 net/core/dst_cache.c                               |   2 +-
 net/core/filter.c                                  |   2 +-
 net/core/lwt_bpf.c                                 |   4 +-
 net/core/sock.c                                    |   1 -
 net/core/sock_map.c                                |   2 +
 net/core/xdp.c                                     |   2 +-
 net/hsr/hsr_slave.c                                |   2 +
 net/ipv4/fib_semantics.c                           | 101 ++--
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/icmp.c                                    |  18 +-
 net/ipv4/inet_connection_sock.c                    |  20 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/route.c                                   |  31 +-
 net/ipv4/tcp_bpf.c                                 |   4 +-
 net/ipv4/tcp_ipv4.c                                | 296 +++++++++---
 net/ipv4/udp_offload.c                             |   4 +-
 net/ipv6/fib6_rules.c                              |   1 +
 net/ipv6/icmp.c                                    |   8 +-
 net/ipv6/ila/ila_common.c                          |  12 +
 net/ipv6/ila/ila_lwt.c                             |   4 +-
 net/ipv6/ip6_fib.c                                 |  17 +-
 net/ipv6/ip6_output.c                              |  20 +-
 net/ipv6/ip6_tunnel.c                              |   3 +
 net/ipv6/ip6mr.c                                   |   2 +-
 net/ipv6/ndisc.c                                   |  12 +-
 net/ipv6/ping.c                                    |   2 +-
 net/ipv6/raw.c                                     |   6 +-
 net/ipv6/route.c                                   |  36 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/ipv6/udp.c                                     |  11 +-
 net/ipv6/xfrm6_policy.c                            |   3 +-
 net/iucv/af_iucv.c                                 |  21 +-
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/l2tp/l2tp_ppp.c                                |   1 +
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/rx.c                                  |   2 +
 net/mac80211/s1g.c                                 |   4 +
 net/mac802154/llsec.c                              |   5 +
 net/mpls/af_mpls.c                                 |   4 +
 net/mpls/mpls_iptunnel.c                           |   2 +-
 net/mptcp/options.c                                |  12 +-
 net/mptcp/protocol.c                               |   1 +
 net/ncsi/ncsi-netlink.c                            |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_core.c                  |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   4 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  44 +-
 net/netfilter/ipvs/ip_vs_core.c                    | 232 +++++----
 net/netfilter/ipvs/ip_vs_ctl.c                     |  77 ++-
 net/netfilter/ipvs/ip_vs_lc.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  21 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  50 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |  54 +--
 net/netfilter/ipvs/ip_vs_sync.c                    |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  56 ++-
 net/netfilter/nf_conntrack_broadcast.c             |   1 +
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_conntrack_expect.c                |   1 +
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |   5 +
 net/netfilter/nf_conntrack_netlink.c               |  18 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_flow_table_core.c                 |   8 +-
 net/netfilter/nf_flow_table_ip.c                   |   4 +-
 net/netfilter/nf_nat_sip.c                         |   2 +-
 net/netfilter/nft_payload.c                        |  12 +-
 net/netfilter/nft_rt.c                             |   2 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 net/openvswitch/actions.c                          |  26 +-
 net/openvswitch/datapath.c                         |  54 ++-
 net/openvswitch/datapath.h                         |   2 +-
 net/openvswitch/flow.c                             |  11 +-
 net/openvswitch/meter.c                            |  33 +-
 net/openvswitch/vport.c                            |   2 +-
 net/packet/af_packet.c                             |  13 +-
 net/phonet/pep.c                                   |   2 +
 net/qrtr/af_qrtr.c                                 |   8 +
 net/qrtr/ns.c                                      |  33 +-
 net/rds/ib.c                                       |   4 +
 net/rds/ib_cm.c                                    |   4 +
 net/rds/recv.c                                     |  15 +
 net/rds/tcp.c                                      |  14 +-
 net/sched/act_gact.c                               |   5 +
 net/sched/act_police.c                             |   6 +
 net/sched/act_tunnel_key.c                         |  14 +-
 net/sched/cls_route.c                              |  35 +-
 net/sched/sch_api.c                                |   9 +
 net/sched/sch_cake.c                               |   1 -
 net/sctp/associola.c                               |  14 +-
 net/sctp/auth.c                                    |   2 +-
 net/sctp/ipv6.c                                    |   2 +-
 net/sctp/outqueue.c                                |   1 +
 net/sctp/sm_make_chunk.c                           |  26 +-
 net/sctp/sm_statefuns.c                            |   8 +-
 net/sctp/stream.c                                  |   6 +-
 net/smc/af_smc.c                                   |   3 +-
 net/smc/smc_core.c                                 |   2 +-
 net/smc/smc_llc.c                                  |   3 +-
 net/smc/smc_rx.c                                   |  19 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   4 +
 net/sunrpc/xprtrdma/verbs.c                        |  12 +-
 net/tipc/core.c                                    |   5 +
 net/tipc/discover.c                                |  14 +-
 net/tipc/netlink.c                                 |   6 +-
 net/tipc/netlink_compat.c                          |   4 +
 net/tipc/node.c                                    |  15 +-
 net/tipc/socket.c                                  |   3 +-
 net/tls/tls_sw.c                                   |   2 +-
 net/unix/af_unix.c                                 |   2 +
 net/unix/garbage.c                                 |  81 ++--
 net/vmw_vsock/virtio_transport.c                   |  14 +-
 net/wireless/core.c                                |   1 +
 net/wireless/nl80211.c                             |  20 +-
 net/wireless/pmsr.c                                |  21 +-
 net/wireless/scan.c                                |   2 +-
 net/x25/af_x25.c                                   |   8 +-
 net/xfrm/xfrm_policy.c                             |   7 +-
 scripts/remove-stale-files                         |   2 +
 security/integrity/ima/ima_appraise.c              |   9 +-
 security/keys/keyring.c                            |  14 +-
 sound/core/pcm_native.c                            |   7 +
 sound/core/seq/seq_timer.c                         |  13 +-
 sound/pci/lx6464es/lx6464es.c                      |   5 +-
 sound/pci/lx6464es/lx_core.c                       |   5 +-
 sound/soc/amd/ps/pci-ps.c                          |   2 +-
 sound/soc/codecs/bt-sco.c                          |  10 +-
 sound/soc/codecs/max98090.c                        |   5 +-
 sound/soc/codecs/max98095.c                        |   5 +-
 sound/soc/codecs/tas2562.c                         |  35 +-
 sound/soc/meson/aiu-fifo-spdif.c                   |   5 +
 sound/usb/6fire/chip.c                             |   4 +
 sound/usb/endpoint.c                               |  20 +-
 sound/usb/midi.c                                   |   2 +
 sound/usb/quirks.c                                 |   2 +
 sound/usb/usx2y/usX2Yhwdep.c                       |   2 +
 sound/usb/usx2y/usx2yhwdeppcm.c                    |   2 +
 tools/testing/selftests/alsa/mixer-test.c          |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  21 +-
 tools/testing/selftests/bpf/test_maps.c            |  13 +-
 tools/testing/selftests/clone3/clone3_set_tid.c    |   2 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  16 +-
 tools/testing/selftests/net/af_unix/config         |   4 +
 tools/testing/selftests/net/openvswitch/config     |  16 +
 563 files changed, 6112 insertions(+), 2862 deletions(-)


