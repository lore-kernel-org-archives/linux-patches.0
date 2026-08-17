Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6AB440A08;
	Mon, 17 Aug 2026 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978457; cv=none; b=EjDuCQbCQKE/dhf7jZSWw7sD/MU1cSRTMe4lwxmxonN3uyzyZxnLxYK4JEQH24srn3Ib5QQwBipQsRbT9c8Ue2ZjBoDLcbj7jada1biQqDVaofQJRx6uruoqizMc7EEeB+LuRFf70eLIfrIPsuMsvJ4c+4pYJuq1JoykPNrX2Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978457; c=relaxed/simple;
	bh=neMQxQZMQgHrzGrttrptOtmK8+G9CBxT4/lxyUqJrIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LfW6JySdLLxFV6TAsyeDVrs1nzXvTk364s2k8oE139viUDZBoWprOq5mq7Nv5auK0Wrdmr/iTKttduib//NNhiBliHeeWTnJAGzcZzpVkrjZYoS0m3UfC6Z1fIx5cQcM/s8qg5NduDmzqpU3jb6Pp/U4GdOTai7w9jxR+vJcy+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wgeaaxno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wgeaaxno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968601F00A3D;
	Mon, 17 Aug 2026 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978453;
	bh=CX4aJgSZn4bZyp+np4ykTN30wB89/mox711DJSJlXIY=;
	h=From:To:Cc:Subject:Date;
	b=WgeaaxnoyMYig2oHm1ssj4Hpk3Z0I7LSNwOSsmo63Uii+AjqsHAi1DBgp0MigwTbi
	 AjnePhYVm+w2qcFowJskIly98DdaSTpgzmeg/cwHSL40pP8lppVxvYCoG7MHOIBGHD
	 jRoSQirkeCq+vZ9yFT6KuX6cUi7tafq+rwV0EbIk=
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
Subject: [PATCH 6.6 000/156] 6.6.152-rc1 review
Date: Mon, 17 Aug 2026 15:32:14 +0200
Message-ID: <20260817132534.666299318@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.152-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.152-rc1
X-KernelTest-Deadline: 2026-08-19T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.152 release.
There are 156 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.152-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.152-rc1

David Lechner <dlechner@baylibre.com>
    regulator: devres: fix devm_regulator_get_enable_read_voltage() return

Dmitry Safonov <0x7f454c46@gmail.com>
    net/tcp_sigpool: Use kref_get_unless_zero()

Dan Carpenter <dan.carpenter@linaro.org>
    net/tcp_sigpool: Fix some off by one bugs

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

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: pull kvfree out of spinlock

Chengfeng Ye <nicoyip.dev@gmail.com>
    ipv4: fix use-after-free in fib_nhc_update_mtu()

Zihan Xi <zihanx@nebusec.ai>
    ipv4: Fix fib_nlmsg_size() for RTA_VIA nexthops

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Adapt sockmap update error handling

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Replace mk_users keyring with simple list

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP

Nathan Chancellor <nathan@kernel.org>
    fortify: Disable -Wstringop-overread in tests

Masahiro Yamada <masahiroy@kernel.org>
    fortify: refactor test_fortify Makefile to fix some build problems

Keno Fischer <keno@juliacomputing.com>
    futex: Prevent robust futex exit race some more

Harshal Dev <harshal.dev@oss.qualcomm.com>
    dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk

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

Mehmet Fide <mehmet.fide@screeningeagle.com>
    net: fec: do not release NULL pages when RX buffer allocation fails

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

Dmitry Safonov <0x7f454c46@gmail.com>
    net/tcp: Add TCP-AO config and structures

Dmitry Safonov <0x7f454c46@gmail.com>
    net/tcp: Prepare tcp_md5sig_pool for TCP-AO

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

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers

Xin Long <lucien.xin@gmail.com>
    net: sched: refine software bypass handling in tc_run

Jianbo Liu <jianbol@nvidia.com>
    net: sched: cls_api: fix slab-use-after-free in fl_dump_key

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: sched: make skip_sw actually skip software

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: sched: cls_api: add filter counter

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: sched: cls_api: add skip_sw counter

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/openvswitch: check Ethernet header length in key_extract()

Toke Høiland-Jørgensen <toke@toke.dk>
    net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    udp: fix potential use-after-free in tunnel segmentation

Nathan Gao <zcgao@amazon.com>
    tcp: do not change rcv_ssthresh in tcp_measure_rcv_mss()

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

Julian Anastasov <ja@ssi.bg>
    ipvs: return the csum validation for forward hook

Julian Anastasov <ja@ssi.bg>
    ipvs: avoid out-of-bounds write in ip_vs_nat_icmp

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: switch ext_size to atomic64_t

Shay Drory <shayd@nvidia.com>
    net/mlx5e: TC, Check if flow is PEER before acquiring devcom lock

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bonding: alb: re-check primary_is_promisc under RTNL in bond_alb_monitor

Fan Ye <fy15309206903@gmail.com>
    Revert "net: thunderbolt: Enable end-to-end flow control also in transmit"

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/bridge: ps8640: propagate AUX transfer register errors

Rosen Penev <rosenp@gmail.com>
    ARM: dts: BCM5301X: fix PCIe controller 2 second interrupt

Yuho Choi <dbgh9129@gmail.com>
    ARM: npcm: Fix OF node refcount leaks in SMP setup

Anna Schumaker <anna.schumaker@hammerspace.com>
    NFS: Pin the 'struct nfs_server' during a FREE_STATEID call

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Fail unbound UDP on sockmap update

Al Viro <viro@zeniv.linux.org.uk>
    mount: honour SB_NOUSER in the new mount API


-------------

Diffstat:

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  16 +-
 Documentation/driver-api/driver-model/devres.rst   |   1 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi             |   2 +-
 arch/arm/mach-npcm/platsmp.c                       |   2 +
 arch/s390/kvm/pci.c                                |  86 +++--
 arch/s390/kvm/pci.h                                |   2 +
 arch/x86/kvm/mmu/mmu.c                             |   3 +
 drivers/ata/pata_sl82c105.c                        |   4 +-
 drivers/counter/microchip-tcb-capture.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  35 +-
 drivers/gpu/drm/bridge/parade-ps8640.c             |  27 +-
 drivers/hwmon/ads7828.c                            |  11 +-
 drivers/hwmon/corsair-psu.c                        |   4 +-
 drivers/hwmon/nzxt-smart2.c                        |   6 +-
 drivers/hwmon/pmbus/lm25066.c                      |  19 +-
 drivers/input/evdev.c                              |  27 +-
 drivers/misc/fastrpc.c                             |  19 +-
 drivers/misc/mei/client.c                          |  25 +-
 drivers/net/bonding/bond_alb.c                     |  10 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  51 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   7 +-
 drivers/net/ethernet/freescale/fec_main.c          |  11 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   1 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 drivers/net/thunderbolt/main.c                     |  33 +-
 drivers/net/usb/ax88179_178a.c                     |   4 +-
 drivers/net/veth.c                                 |  22 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   4 +-
 drivers/ptp/ptp_ocp.c                              |   4 +-
 drivers/regulator/devres.c                         |  59 ++++
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
 drivers/tty/serial/8250/8250_dma.c                 |  12 +-
 drivers/tty/vt/keyboard.c                          |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 +
 drivers/usb/atm/cxacru.c                           |   2 +
 drivers/usb/cdns3/cdnsp-gadget.c                   |   4 +-
 drivers/usb/gadget/function/f_ncm.c                |   2 +-
 drivers/vhost/vdpa.c                               |   9 +-
 drivers/vhost/vhost.c                              |   8 +
 drivers/video/fbdev/core/bitblit.c                 |   9 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/crypto/fscrypt_private.h                        |  32 +-
 fs/crypto/keyring.c                                | 212 +++++------
 fs/crypto/policy.c                                 |   2 +-
 fs/namespace.c                                     |   5 +
 fs/nfs/nfs4proc.c                                  |   5 +
 fs/overlayfs/super.c                               |   3 +-
 fs/smb/client/sess.c                               |   2 +-
 fs/tracefs/event_inode.c                           |  28 +-
 fs/tracefs/internal.h                              |   4 +-
 include/linux/netdevice.h                          |  11 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/regulator/consumer.h                 |   7 +
 include/linux/tcp.h                                |   9 +-
 include/net/act_api.h                              |  19 +
 include/net/addrconf.h                             |   4 +-
 include/net/ip_vs.h                                |  41 +--
 include/net/pkt_cls.h                              |  18 +
 include/net/route.h                                |   2 +
 include/net/sch_generic.h                          |   4 +
 include/net/tcp.h                                  |  58 +--
 include/net/tcp_ao.h                               |  90 +++++
 include/uapi/linux/tcp.h                           |   2 +
 kernel/bpf/verifier.c                              |  15 +-
 kernel/futex/core.c                                |  82 +++--
 kernel/sched/psi.c                                 |   6 +
 kernel/trace/ring_buffer.c                         |  10 +-
 kernel/trace/trace_events.c                        |   2 +
 lib/.gitignore                                     |   2 -
 lib/Makefile                                       |  34 +-
 lib/test_fortify/.gitignore                        |   2 +
 lib/test_fortify/Makefile                          |  29 ++
 net/atm/common.c                                   |  14 +-
 net/bridge/br_mrp.c                                |   6 +-
 net/bridge/netfilter/ebt_nflog.c                   |  17 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   1 +
 net/core/dev.c                                     |  13 +
 net/core/sock.c                                    |   1 -
 net/core/xdp.c                                     |   2 +-
 net/devlink/dev.c                                  |   1 +
 net/ipv4/Kconfig                                   |  17 +
 net/ipv4/Makefile                                  |   1 +
 net/ipv4/fib_semantics.c                           | 101 +++---
 net/ipv4/inet_connection_sock.c                    |  20 +-
 net/ipv4/route.c                                   |  29 ++
 net/ipv4/tcp.c                                     | 145 ++------
 net/ipv4/tcp_bpf.c                                 |   2 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                | 390 ++++++++++++++-------
 net/ipv4/tcp_minisocks.c                           |  21 +-
 net/ipv4/tcp_sigpool.c                             | 357 +++++++++++++++++++
 net/ipv4/udp_offload.c                             |   4 +-
 net/ipv6/ip6_tunnel.c                              |   3 +
 net/ipv6/route.c                                   |   8 +-
 net/ipv6/tcp_ipv6.c                                |  60 ++--
 net/mac802154/scan.c                               |   4 +
 net/ncsi/ncsi-netlink.c                            |   4 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_core.c                  |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  41 +--
 net/netfilter/ipvs/ip_vs_core.c                    |  70 ++--
 net/netfilter/ipvs/ip_vs_ctl.c                     |  77 +++-
 net/netfilter/ipvs/ip_vs_est.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   2 -
 net/netfilter/ipvs/ip_vs_sync.c                    |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netfilter/nf_conntrack_proto.c                 |   6 +
 net/netfilter/nf_conntrack_proto_sctp.c            |  12 +-
 net/netfilter/nf_conntrack_proto_tcp.c             | 132 ++++---
 net/openvswitch/datapath.c                         |  29 +-
 net/openvswitch/flow.c                             |  11 +-
 net/packet/af_packet.c                             |  72 ++--
 net/sched/act_ct.c                                 |  29 +-
 net/sched/act_gact.c                               |   5 +
 net/sched/act_police.c                             |   6 +
 net/sched/cls_api.c                                |  47 ++-
 net/sched/cls_bpf.c                                |   2 +
 net/sched/cls_flower.c                             |   2 +
 net/sched/cls_matchall.c                           |   2 +
 net/sched/cls_route.c                              |  35 +-
 net/sched/cls_u32.c                                |   4 +
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
 scripts/remove-stale-files                         |   2 +
 security/integrity/ima/ima_appraise.c              |   9 +-
 sound/usb/endpoint.c                               |   6 +-
 sound/usb/midi2.c                                  |   9 +
 sound/usb/usx2y/usX2Yhwdep.c                       |   2 +
 sound/usb/usx2y/usx2yhwdeppcm.c                    |   2 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  21 +-
 tools/testing/selftests/bpf/test_maps.c            |  13 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  16 +-
 166 files changed, 2407 insertions(+), 1036 deletions(-)


