Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A573E025C;
	Mon, 17 Aug 2026 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977930; cv=none; b=kIrEXbBq2aV0Z6meq7fBMOmEr+g7mut+OzSqMOyLTKq1ZCmhQ/0s8YLo4vZluiPStkemMCszNvE9cYx74C+efWhTQLwWWm+40R9fHskaxVdiLgDZYm3/SrBqd02ZnSpqk5rujJYHtveUDzbBfGjFesABNErMZsGJpaPyrQrDNIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977930; c=relaxed/simple;
	bh=604mekeX2dWmeOgtolmE/JbRO6GzRRc5ukX91mmPUTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eZYIHo2RXLJCTPzqnvuZZvdsYsDJUhilzZ6vmQw9cwC7epoGRE4QONvyiWKqdD94EEYavBRPYx0+ArOITLln7PcW3uUQdVLrmCtxmInQSZih238WEKOSNT8KTL1EunmVAf7tYzy8M3/spKaTyzWFa0bE2bY94LtUxrGRA/eKprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spPwm+0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spPwm+0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E26A1F000E9;
	Mon, 17 Aug 2026 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977928;
	bh=gxU2kF85SpSAd70+JKHppnHo1gK5eDP1gpFsgp6WMvw=;
	h=From:To:Cc:Subject:Date;
	b=spPwm+0tN5MhySJ02JolJY1i8GPPLGNPDtM2Sd8NPx4dphV4Y8vmloJMLmDFvmvfp
	 jrEEnidhZK1ApagvkA6Opxywu0VQ+lAdXCb61R/oVH1NL+kkZ/As9DnCVjsiuN4rrM
	 x2FpiMs7Jrc9G+ezy/8kk469C+4564yuMTxVIRS0=
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
Subject: [PATCH 6.12 000/181] 6.12.104-rc1 review
Date: Mon, 17 Aug 2026 15:31:34 +0200
Message-ID: <20260817132535.394764707@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.104-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.104-rc1
X-KernelTest-Deadline: 2026-08-19T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.104 release.
There are 181 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.104-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.104-rc1

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bpf: tcp: fix double sock release on batch realloc

Xu Rao <raoxu@uniontech.com>
    thunderbolt: Fix bandwidth group reservation indexing

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

Eric Biggers <ebiggers@kernel.org>
    fsverity: Fix silent truncation in bpf_get_fsverity_digest()

Eric Biggers <ebiggers@kernel.org>
    fsverity: Fix bpf_get_fsverity_digest() dynptr assumptions

Mimi Zohar <zohar@linux.ibm.com>
    ima: Instantiate file_truncate and path_truncate hooks

Tejun Heo <tj@kernel.org>
    sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

Zhan Xusheng <zhanxusheng@xiaomi.com>
    fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()

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

Steven Rostedt <rostedt@goodmis.org>
    eventfs: Use children field for rcu head and add memory barriers

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    eventfs: Fix use-after-free in eventfs_remove_rec()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: WARN and clear role.invalid when creating a child shadow page

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    smb: client: Fix use-after-free in cifs_try_adding_channels()

Jun Yang <junvyyang@tencent.com>
    tipc: read le->link under the node lock in tipc_node_link_down()

chanyoung <ppoo1220@gmail.com>
    tls: don't leave a full plaintext sk_msg ring unpushed

Jun Yang <junvyyang@tencent.com>
    vhost: reset the vring metadata cache on vring reconfiguration

Sun Jian <sun.jian.kdev@gmail.com>
    veth: fix skb length accounting after XDP frag adjustment

Weiming Shi <bestswngs@gmail.com>
    vsock/virtio: avoid refilling the RX queue after teardown

Weiming Shi <bestswngs@gmail.com>
    vsock/virtio: read virtqueues under worker locks

Baul Lee <baul.lee@xbow.com>
    vxlan: do not arm the ageing timer on a device that is down

Zhiling Zou <zhilinz@nebusec.ai>
    xdp: reject clones that overrun skb_shared_info tailroom

Asad Kamal <asad.kamal@amd.com>
    Revert "drm/amdgpu: fix aperture mapping leak"

Christian Brauner <brauner@kernel.org>
    binfmt_misc: don't warn when the mount is completed from another user namespace

Christian Brauner <brauner@kernel.org>
    ovl: don't warn when the mount is completed from another user namespace

Hyunjung Ko <hj351016@gmail.com>
    net/sched: act_gact, act_police: range check the fallback control action

Hyunjung Ko <hj351016@gmail.com>
    net/sched: act_ct: fix sk_buff leak when the header checks reject a packet

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free RX pages of consumed but not refilled buffers

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free stranded TX buffers on ring deinit

Zihan Xi <zihanx@nebusec.ai>
    netfilter: nf_conntrack: defer invalid log until after unlock

Zhiling Zou <zhilinz@nebusec.ai>
    netfilter: bridge: release template ct on non-IP path

Kyle Zeng <kylebot@openai.com>
    ipv6: prevent in6_dev_get() from resurrecting inet6_dev

Daming Li <d4n.for.sec@gmail.com>
    net: smc: fix splice entry lifetime imbalance in smc_rx_splice

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: fix huge_zero_pfn race

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Prevent subbuf order change when resizing is disabled

Rik van Riel <riel@surriel.com>
    fbdev: bitblit: bound-check glyph index in bit_cursor()

Michael Wu <michael@allwinnertech.com>
    tracing: Fix race between update_event_fields and, event_define_fields

Baul Lee <baul.lee@xbow.com>
    ALSA: usx2y: bound the hwdep mmap fault offset

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: Fix UAF at delayed release of MIDI2 EPs

Hui Su <sh_def@163.com>
    ring-buffer: Fix crash passing ERR_PTR to kthread_stop()

Eddie Lin <eddie.lin@oss.qualcomm.com>
    misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free

Junrui Luo <moonafterrain@outlook.com>
    misc: fastrpc: take fl->lock when moving mmaps on interrupted invoke

Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
    misc: fastrpc: Remove buffer from list prior to unmap operation

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

Jan Sebastian Götte <linux@jaseg.de>
    serial: qcom-geni: fix TX DMA buffer flush

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    nvmem: layouts: Add fixed-layout driver

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: pull kvfree out of spinlock

Chengfeng Ye <nicoyip.dev@gmail.com>
    ipv4: fix use-after-free in fib_nhc_update_mtu()

Zihan Xi <zihanx@nebusec.ai>
    ipv4: Fix fib_nlmsg_size() for RTA_VIA nexthops

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Adapt sockmap update error handling

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Ensure UDP sockets are bound

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP

Kees Cook <kees@kernel.org>
    kunit/fortify: Add back "volatile" for sizeof() constants

Kees Cook <kees@kernel.org>
    kunit/fortify: Replace "volatile" with OPTIMIZER_HIDE_VAR()

Keno Fischer <keno@juliacomputing.com>
    futex: Prevent robust futex exit race some more

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp - Abort doing SEV INIT if SNP INIT fails

Michael Roth <michael.roth@amd.com>
    crypto: ccp - Fix checks for SNP_VLEK_LOAD input buffer length

Ashish Kalra <ashish.kalra@amd.com>
    KVM: SVM: Add support to initialize SEV/SNP functionality in KVM

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp - Add new SEV/SNP platform shutdown API

Harshal Dev <harshal.dev@oss.qualcomm.com>
    dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk

Keith Busch <kbusch@kernel.org>
    blk-mq: reinsert cached request to the list

Keith Busch <kbusch@kernel.org>
    blk-mq: pop cached request if it is usable

Bart Van Assche <bvanassche@acm.org>
    block: Reorder the request allocation code in blk_mq_submit_bio()

Matthew Rosato <mjrosato@linux.ibm.com>
    KVM: s390: pci: Fix aisb calculation

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix resource leak on IRQ registration failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix missing error codes and memory unaccounting

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix memory accounting for pinned/unpinned pages

Baul Lee <baul.lee@xbow.com>
    net: bridge: mrp: fix uninitialised bytes on the wire

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: ebt_nflog: pin the NFLOG backend

Zihan Xi <zihanx@nebusec.ai>
    mac802154: fix netdev use-after-free in beacon worker

Qihang Tang <q.h.hack.winter@gmail.com>
    net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header

Sergey V. Frolov <Sergey.V.Frolov@kaspersky.com>
    net: octeontx2-pf: Fix UB in shift operation

Zijie Huang <milkory@outlook.com>
    net/sched: reject overly deep qdisc hierarchies

Zhiling Zou <zhilinz@nebusec.ai>
    net: openvswitch: reallocate update replies for mismatched IDs

Sun Jian <sun.jian.kdev@gmail.com>
    net: fix skb length accounting after generic XDP frag adjustment

Zihan Xi <zihanx@nebusec.ai>
    packet: synchronize pressure clearing with ring reconfiguration

Doruk Tan Ozturk <doruk@0sec.ai>
    net/packet: reset the MAC header on the packet-socket transmit path

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in TX_RING send path

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in non-ring send paths

Kyle Zeng <kylebot@openai.com>
    ipvs: clear IPv4 options after rebasing tunnel ICMP errors

Julian Anastasov <ja@ssi.bg>
    ipvs: properly update the overload flag on dest edit

Julian Anastasov <ja@ssi.bg>
    ipvs: add totalconns for dest

Zhiling Zou <zhilinz@nebusec.ai>
    ipvs: stop estimator after disabled calc phase

Lincoln Wallace <locnnil0@gmail.com>
    ima: fix out-of-bounds read in xattr_verify()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - fix information leak in evdev_pass_values()

Joshua Rogers <linux@joshua.hu>
    vt: stabilize tty reference in kbd_keycode with tty_port_tty_get

Joshua Rogers <linux@joshua.hu>
    vt: add permission check for KDSKBMETA ioctl

Doruk Tan Ozturk <doruk@0sec.ai>
    net: usb: ipheth: fix carrier_work UAF on disconnect

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

Guillaume Morin <guillaume@morinfr.org>
    swapfile: call cond_resched() before locking si->lock

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    mtd: spinand: repeat reading in regular mode if continuous reading fails

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    mtd: spinand: try a regular dirmap if creating a dirmap for continuous reading fails

Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
    mtd: spinand: fix direct mapping creation sizes

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Avoid setup_accel logic for DMA transfers

Mehmet Fide <mehmet.fide@screeningeagle.com>
    net: fec: do not release NULL pages when RX buffer allocation fails

Zeng Jingxiang <linuszeng@tencent.com>
    mm/vmscan: wake up flushers conditionally to avoid cgroup OOM

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ltc4282) Fix parsing adi,current-limit-sense-microvolt

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ltc4282) Clamp negative current limits

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ltc4282) Avoid overflow in maximum power calculation

Qingshuang Fu <fuqingshuang@kylinos.cn>
    hwmon: (ads7828) Fix external VREF regulator handling

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

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Refresh VNIC default ring on queue restart if needed

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Determine and store default RX ring in vnic structure

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Move RSS table fill outside __bnxt_hwrm_vnic_set_rss()

Martin Kaiser <martin@kaiser.cx>
    selftests/ftrace: refactor eprobes test to fix argument checks

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations

Qingshuang Fu <fuqingshuang@kylinos.cn>
    hwmon: (nzxt-smart2) Check return value of init_device() in probe

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/openvswitch: check Ethernet header length in key_extract()

Toke Høiland-Jørgensen <toke@toke.dk>
    net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    udp: fix potential use-after-free in tunnel segmentation

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: require at least 16 bytes of TX metadata

Nathan Gao <zcgao@amazon.com>
    tcp: do not change rcv_ssthresh in tcp_measure_rcv_mss()

Christian Borntraeger <borntraeger@linux.ibm.com>
    vdpa/mlx5: Fix buffer length in create_direct_keys()

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

Babanpreet Singh <bbnpreetsingh@gmail.com>
    counter: microchip-tcb-capture: Fix DT channel validation

Michael Guralnik <michaelgur@nvidia.com>
    net/mlx5: fw_tracer, return NULL on create error

Or Har-Toov <ohartoov@nvidia.com>
    devlink: fix net namespace reference leak in reload

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

Matti Vaittinen <mazziesaccount@gmail.com>
    watchdog: bd96801_wdt: Fix timeout for enabled WDG

Julian Anastasov <ja@ssi.bg>
    ipvs: return the csum validation for forward hook

Julian Anastasov <ja@ssi.bg>
    ipvs: avoid out-of-bounds write in ip_vs_nat_icmp

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: switch ext_size to atomic64_t

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: cancel pending PCI reset work on AER recovery

Nikhil P. Rao <nikhil.rao@amd.com>
    pds_core: keep the health thread stopped during reset

Shay Drory <shayd@nvidia.com>
    net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock

Satish Kharat <satishkh@cisco.com>
    enic: fix tx_hang_reset use-after-free on device removal

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bonding: alb: re-check primary_is_promisc under RTNL in bond_alb_monitor

Fan Ye <fy15309206903@gmail.com>
    Revert "net: thunderbolt: Enable end-to-end flow control also in transmit"

Jijie Shao <shaojijie@huawei.com>
    net: hns3: fix speed configuration residue after driver reload

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/bridge: ps8640: propagate AUX transfer register errors

Rosen Penev <rosenp@gmail.com>
    ARM: dts: BCM5301X: fix PCIe controller 2 second interrupt

Yuho Choi <dbgh9129@gmail.com>
    ARM: npcm: Fix OF node refcount leaks in SMP setup

Daniel Drake <dan@reactivated.net>
    arm64: dts: broadcom: bcm2712: Remove non-functional EL2 virtual timer

Anna Schumaker <anna.schumaker@hammerspace.com>
    NFS: Pin the 'struct nfs_server' during a FREE_STATEID call

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Check for tg ops in dce110_set_avmute

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Add AV mute wait frames to dce110_set_avmute

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Fail unbound UDP on sockmap update

Al Viro <viro@zeniv.linux.org.uk>
    mount: honour SB_NOUSER in the new mount API


-------------

Diffstat:

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  16 +-
 MAINTAINERS                                        |   5 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi             |   2 +-
 arch/arm/mach-npcm/platsmp.c                       |   2 +
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          |   2 -
 arch/s390/kvm/pci.c                                |  86 ++++--
 arch/s390/kvm/pci.h                                |   2 +
 arch/x86/kvm/mmu/mmu.c                             |   3 +
 arch/x86/kvm/svm/sev.c                             |  12 +
 block/blk-mq.c                                     |  38 +--
 drivers/ata/pata_sl82c105.c                        |   4 +-
 drivers/counter/microchip-tcb-capture.c            |   4 +-
 drivers/crypto/ccp/sev-dev.c                       |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  35 +--
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  24 +-
 drivers/gpu/drm/bridge/parade-ps8640.c             |  27 +-
 drivers/hwmon/ads7828.c                            |  11 +-
 drivers/hwmon/corsair-psu.c                        |   4 +-
 drivers/hwmon/ltc4282.c                            |  20 +-
 drivers/hwmon/nzxt-smart2.c                        |   6 +-
 drivers/hwmon/pmbus/lm25066.c                      |   5 +-
 drivers/input/evdev.c                              |  27 +-
 drivers/misc/fastrpc.c                             |  19 +-
 drivers/misc/mei/client.c                          |  25 +-
 drivers/mtd/nand/spi/core.c                        |  74 ++++--
 drivers/net/bonding/bond_alb.c                     |  10 +-
 drivers/net/ethernet/amd/pds_core/core.h           |   1 +
 drivers/net/ethernet/amd/pds_core/main.c           |  14 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  51 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  50 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   7 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |  11 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 drivers/net/thunderbolt/main.c                     |  33 ++-
 drivers/net/usb/ax88179_178a.c                     |   4 +-
 drivers/net/usb/ipheth.c                           |  11 +-
 drivers/net/veth.c                                 |  22 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/nvmem/core.c                               |  24 +-
 drivers/nvmem/internals.h                          |   2 +
 drivers/nvmem/layouts.c                            |  11 -
 drivers/nvmem/layouts/Makefile                     |   1 +
 drivers/nvmem/layouts/fixed-layout.c               |  58 ++++
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   4 +-
 drivers/ptp/ptp_ocp.c                              |   4 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |  20 +-
 drivers/scsi/scsi_debug.c                          |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |  13 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   3 +
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   2 +-
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |   3 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   4 +
 drivers/thermal/thermal_hwmon.c                    |   3 +-
 drivers/thunderbolt/eeprom.c                       |   9 +-
 drivers/thunderbolt/icm.c                          |   2 +-
 drivers/thunderbolt/tb.c                           |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |  12 +-
 drivers/tty/serial/qcom_geni_serial.c              |  43 +--
 drivers/tty/vt/keyboard.c                          |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 +
 drivers/usb/atm/cxacru.c                           |   2 +
 drivers/usb/cdns3/cdnsp-gadget.c                   |   4 +-
 drivers/usb/gadget/function/f_ncm.c                |   2 +-
 drivers/vdpa/mlx5/core/mr.c                        |   3 +-
 drivers/vhost/vdpa.c                               |   9 +-
 drivers/vhost/vhost.c                              |   8 +
 drivers/video/fbdev/core/bitblit.c                 |   9 +-
 drivers/watchdog/bd96801_wdt.c                     |   5 +-
 fs/binfmt_misc.c                                   |   3 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/crypto/policy.c                                 |   2 +-
 fs/namespace.c                                     |   5 +
 fs/nfs/nfs4proc.c                                  |   5 +
 fs/overlayfs/super.c                               |   3 +-
 fs/smb/client/sess.c                               |   2 +-
 fs/tracefs/event_inode.c                           |  28 +-
 fs/tracefs/internal.h                              |   4 +-
 fs/verity/measure.c                                |  15 +-
 include/linux/netdevice.h                          |  11 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/nvmem-provider.h                     |   6 +
 include/linux/psp-sev.h                            |   3 +
 include/net/act_api.h                              |  19 ++
 include/net/addrconf.h                             |   4 +-
 include/net/ip_vs.h                                |  41 +--
 include/net/route.h                                |   2 +
 include/net/sch_generic.h                          |   1 +
 kernel/bpf/verifier.c                              |  15 +-
 kernel/futex/core.c                                |  85 ++++--
 kernel/sched/psi.c                                 |   6 +
 kernel/trace/ring_buffer.c                         |  12 +-
 kernel/trace/trace_events.c                        |   2 +
 lib/fortify_kunit.c                                | 139 +++++-----
 mm/huge_memory.c                                   |  49 ++--
 mm/swapfile.c                                      |   2 +-
 mm/vmscan.c                                        |  25 +-
 net/atm/common.c                                   |  14 +-
 net/bridge/br_mrp.c                                |   6 +-
 net/bridge/netfilter/ebt_nflog.c                   |  17 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   1 +
 net/core/dev.c                                     |  10 +-
 net/core/sock.c                                    |   1 -
 net/core/xdp.c                                     |   2 +-
 net/devlink/dev.c                                  |   1 +
 net/ipv4/fib_semantics.c                           | 101 ++++---
 net/ipv4/inet_connection_sock.c                    |  20 +-
 net/ipv4/route.c                                   |  29 ++
 net/ipv4/tcp_bpf.c                                 |   2 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                | 293 +++++++++++++++------
 net/ipv4/udp_offload.c                             |   4 +-
 net/ipv6/ip6_tunnel.c                              |   3 +
 net/ipv6/route.c                                   |   8 +-
 net/mac802154/scan.c                               |   4 +
 net/ncsi/ncsi-netlink.c                            |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_core.c                  |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  41 +--
 net/netfilter/ipvs/ip_vs_core.c                    |  70 ++---
 net/netfilter/ipvs/ip_vs_ctl.c                     |  77 +++++-
 net/netfilter/ipvs/ip_vs_est.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   2 -
 net/netfilter/ipvs/ip_vs_sync.c                    |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netfilter/nf_conntrack_proto.c                 |   6 +
 net/netfilter/nf_conntrack_proto_sctp.c            |  12 +-
 net/netfilter/nf_conntrack_proto_tcp.c             | 132 ++++++----
 net/openvswitch/datapath.c                         |  29 +-
 net/openvswitch/flow.c                             |  11 +-
 net/packet/af_packet.c                             |  72 +++--
 net/sched/act_ct.c                                 |  29 +-
 net/sched/act_gact.c                               |   5 +
 net/sched/act_police.c                             |   6 +
 net/sched/cls_api.c                                |  17 +-
 net/sched/cls_route.c                              |  35 ++-
 net/sched/sch_api.c                                |   9 +
 net/sched/sch_cake.c                               |   1 -
 net/sctp/associola.c                               |  11 +-
 net/sctp/outqueue.c                                |   1 +
 net/sctp/sm_make_chunk.c                           |   3 +-
 net/sctp/sm_statefuns.c                            |   6 +-
 net/smc/af_smc.c                                   |   3 +-
 net/smc/smc_llc.c                                  |   3 +-
 net/smc/smc_rx.c                                   |  19 +-
 net/tipc/node.c                                    |  15 +-
 net/tls/tls_sw.c                                   |  16 +-
 net/vmw_vsock/virtio_transport.c                   |  14 +-
 net/xdp/xdp_umem.c                                 |   2 +
 security/integrity/ima/ima_appraise.c              |   9 +-
 security/integrity/ima/ima_main.c                  |  39 +++
 sound/usb/endpoint.c                               |   6 +-
 sound/usb/midi2.c                                  |   9 +
 sound/usb/usx2y/usX2Yhwdep.c                       |   2 +
 sound/usb/usx2y/usx2yhwdeppcm.c                    |   2 +
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   6 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  21 +-
 tools/testing/selftests/bpf/test_maps.c            |  13 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  16 +-
 174 files changed, 1957 insertions(+), 881 deletions(-)


