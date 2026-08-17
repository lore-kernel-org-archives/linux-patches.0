Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A91D3D3CE3;
	Mon, 17 Aug 2026 13:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974736; cv=none; b=uQIsrmt3wRFq5RD1XzeKmzpSuJGxF7GTnMx6l7H6WnIT5mwgOwlRtWGcBUWAJJHOAY623/i5tVjK13ZmwL2UL73H4+CUqqbFlSYZ1WMDfJNUypE6VCm4TiMnypv7LdinFpZFMvLPg+Uk2shIKs9mg94hVVpj2AMXw9qAcIcC/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974736; c=relaxed/simple;
	bh=1d3bOuUDwtFHZXPqMjPboxAxIR9JpVHImHdAgtBTydk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SpllE48xO0uWYoGLe0t8pYP/2YNJSXwoeYcqOz+yIL3L04LH/e3MNhbku2RzcxfI3ccAEUnbwtExIxF3z/vQwH+riya/4G0jZWVSHjoW37cO0wpTqvrOJMqWnP8+ad/x1Y5F51vpe0Xp7auSxzIbCyWelkEv1d0ZQh0ZHkNqhD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIxd+XBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIxd+XBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018061F00A3F;
	Mon, 17 Aug 2026 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974726;
	bh=79K6vC6gevzJzzvfGyT3UP2oAdFFdJ28CcMIOflP0pQ=;
	h=From:To:Cc:Subject:Date;
	b=nIxd+XBlRWKhA81Vk9yeDjYZJNqNMT9Wh/vw6I+Rz84Xpc+m6FILNECeyfWgCChvg
	 34PmHC85Ay7hG0yln4w56O+8nsW3lHx2kSTWqwiMZrhx+1GJ+dKDTkoNcdW3tTpcYa
	 iPQxUmHaL4zcx/Uazl+H+HpXwNZmEgGZuZ3xaGws=
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
Subject: [PATCH 6.18 000/250] 6.18.45-rc1 review
Date: Mon, 17 Aug 2026 15:29:21 +0200
Message-ID: <20260817132536.466235697@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.45-rc1
X-KernelTest-Deadline: 2026-08-19T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.45 release.
There are 250 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.45-rc1

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: ensure sufficient headroom in xmit path

Lorenzo Bianconi <lorenzo@kernel.org>
    netfilter: always set route tuple out ifindex

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

Hugh Dickins <hughd@google.com>
    mm/filemap: __filemap_add_folio() restore index before retrying

Mimi Zohar <zohar@linux.ibm.com>
    ima: Instantiate file_truncate and path_truncate hooks

Tejun Heo <tj@kernel.org>
    sched/psi: Create the psimon kthread outside of cgroup_mutex

Tejun Heo <tj@kernel.org>
    sched/psi: Shut down rtpoll_timer in psi_cgroup_free()

Zhan Xusheng <zhanxusheng@xiaomi.com>
    fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_tunnel: clear skb2->cb[] in ip6ip6_err()

Yuejie Shi <syjcnss@gmail.com>
    ipv6: fix Route Information option length validation

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/ptdump: always stabilise against page table freeing using init_mm

Tengda Wu <wutengda@huaweicloud.com>
    ring-buffer: Use current_context for safe per-CPU buffer swap

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Initialise reader page order in rb_allocate_cpu_buffer()

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

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: Serialize accesses to the owner and mirror list with separate lock

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    smb: client: Fix use-after-free in cifs_try_adding_channels()

Jun Yang <junvyyang@tencent.com>
    tipc: read le->link under the node lock in tipc_node_link_down()

chanyoung <ppoo1220@gmail.com>
    tls: don't leave a full plaintext sk_msg ring unpushed

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tls: rx: restore msg_iter before TLS 1.3 optimistic retry

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

Breno Leitao <leitao@debian.org>
    x86/mce: Set up the polling timer before CMCI discovery

Rik van Riel <riel@surriel.com>
    x86/CPU: Add a tlbi= cmdline switch

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    arm64: remove redundant concurrent ptdump UAF mitigation

Hidayath Khan <hidayath@linux.ibm.com>
    dibs: initialise dibs->lock in dibs_dev_alloc()

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

Pavel Begunkov <asml.silence@gmail.com>
    net: devmem: prevent net-iov / page mixing

Baul Lee <baul.lee@xbow.com>
    net/x25: fix use-after-free of the socket by its timers

Alexandra Winter <wintera@linux.ibm.com>
    net/dibs: Correct freeing of dmb_clientid_arr

Kyle Zeng <kylebot@openai.com>
    ipv6: prevent in6_dev_get() from resurrecting inet6_dev

Daming Li <d4n.for.sec@gmail.com>
    net: smc: fix splice entry lifetime imbalance in smc_rx_splice

Ahmed Naseef <naseefkm@gmail.com>
    net: phy: mediatek: fix TX blink masks using the RX bits

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: fix huge_zero_pfn race

Hui Su <sh_def@163.com>
    tracing: Fix NULL pointer dereference in module event cache removal

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Prevent subbuf order change when resizing is disabled

Rik van Riel <riel@surriel.com>
    fbdev: bitblit: bound-check glyph index in bit_cursor()

Michael Wu <michael@allwinnertech.com>
    tracing: Fix race between update_event_fields and, event_define_fields

Aditya Chillara <aditya.chillara@oss.qualcomm.com>
    perf/core: Fix group leader use-after-free after sibling detach

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Serialize the scheduler timeout handlers

Baul Lee <baul.lee@xbow.com>
    ALSA: us144mkii: re-anchor capture URBs on resubmission

Xu Rao <raoxu@uniontech.com>
    ALSA: hda/tas2781: fix ACPI reference handling

Baul Lee <baul.lee@xbow.com>
    ALSA: FCP: fix OOB write in fcp_meter_ctl_get()

Baul Lee <baul.lee@xbow.com>
    ALSA: usx2y: bound the hwdep mmap fault offset

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: Fix UAF at delayed release of MIDI2 EPs

SJ Park <sj@kernel.org>
    mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}

SJ Park <sj@kernel.org>
    samples/damon/mtier: error out for zero quota goal target values

liyouhong <liyouhong@kylinos.cn>
    mm/damon/ops-common: putback folios on invalid migrate nid

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

Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
    misc: fastrpc: Fix initial memory allocation for Audio PD memory pool

Mariano Baragiola <mbaragiola@linux.com>
    staging: rtl8723bs: validate monitor transmit frame lengths

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    staging: rtl8723bs: fix missing shared-key auth challenge length check

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in WMM_param_handler()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_get_wpa_ie()

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: synchronize DMA teardown

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: cancel RS485 hrtimers after freeing IRQ

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: fix indefinite RS485 post-send delay

Ryan Wilbur <rwilbur633@gmail.com>
    serial: 8250_of: clear stuck empty-FIFO RX-timeout on LPC32xx

Cunhao Lu <1579567540@qq.com>
    serial: 8250_dma: Clear stale RX state on shutdown

Jan Sebastian Götte <linux@jaseg.de>
    serial: qcom-geni: fix TX DMA buffer flush

Alice Ryhl <aliceryhl@google.com>
    rust_binder: do not query current thread for all ioctls

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    nvmem: layouts: Add fixed-layout driver

Aelin Reidel <aelin@mainlining.org>
    nvmem: apple-spmi-nvmem: wrap regmap calls to satisfy CFI

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

Nils Helmig <nils.helmig@web.de>
    Bluetooth: btusb: Add TP-Link UB600 for Realtek 8761BUV

Alexej Sidorenko <alexej@sidorenko.cz>
    Bluetooth: btrtl: fix RTL8761B/BU broken LE extended scan

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: avoid softlockup warnings in nft_chain_validate

Keno Fischer <keno@juliacomputing.com>
    futex: Prevent robust futex exit race some more

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    iommu/vt-d: Gather the unmapped range before freeing its page tables

Harshal Dev <harshal.dev@oss.qualcomm.com>
    dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk

Matthew Rosato <mjrosato@linux.ibm.com>
    KVM: s390: pci: Fix aisb calculation

Keith Busch <kbusch@kernel.org>
    blk-mq: reinsert cached request to the list

Keith Busch <kbusch@kernel.org>
    blk-mq: pop cached request if it is usable

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amd/display: Fix backlight max_brightness to match exported range"

Baul Lee <baul.lee@xbow.com>
    net: bridge: mrp: fix uninitialised bytes on the wire

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: ebt_nflog: pin the NFLOG backend

Philipp David <pd-lkml@3b.pm>
    igc: fix netdev not re-attached after resume if interface is down

Zihan Xi <zihanx@nebusec.ai>
    mac802154: fix netdev use-after-free in beacon worker

Zhiling Zou <zhilinz@nebusec.ai>
    inet: frags: publish queues before arming timer

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

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF

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

Jiangshan Yi <yijiangshan@kylinos.cn>
    usb: misc: usbio: check ibuf_len against rxbuf_len in bulk msg

Ishaan Dandekar <ishaan.dandekar@gmail.com>
    usb: quirks: Add ShanWan gamepad to quirk list

Nikhil Solanke <nikhilsolanke5@gmail.com>
    usb: core: Add quirk for 255-bytes initial config read

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix OOB write on Type II inbound URBs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - sanitize event type index when fetching event masks

Dongli Zhang <dongli.zhang@oracle.com>
    net: tap: set skb->dev before parsing virtio net header in tap_get_user_xdp()

Mehmet Fide <mehmet.fide@screeningeagle.com>
    net: fec: do not release NULL pages when RX buffer allocation fails

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

Hongyan Xu <getshell@seu.edu.cn>
    watchdog: at91sam9_wdt: prevent timer rearm during teardown

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    tls: don't abort the connection on signal-interrupted sends

Xin Long <lucien.xin@gmail.com>
    sctp: clear control chunk transport if it is being removed

Eric Dumazet <edumazet@google.com>
    net/atm: fix slab-out-of-bounds read in vcc_setsockopt()

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: Fix UAF of sba and ieq during ism_dev_exit()

Bhargava Marreddy <bhargava.marreddy@broadcom.com>
    bnge: Fix resource leak in bnge_init_nic() error path

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

Eric Dumazet <edumazet@google.com>
    netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: consolidate xmit path

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: fix TFO max_qlen accounting across reuseport migration

Qing Luo <luoqing@kylinos.cn>
    sctp: fix addip_serial increment on ASCONF_ACK allocation failure

Keegan Freyhof <keegan.freyhof@broadcom.com>
    bnxt_en: Fix PTP PPS setting bug

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Disable EOP for TPA on all chips to prevent data corruption

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Refresh VNIC default ring on queue restart if needed

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Determine and store default RX ring in vnic structure

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Move RSS table fill outside __bnxt_hwrm_vnic_set_rss()

Bobby Eshleman <bobbyeshleman@meta.com>
    net/mlx5e: fix BQL reset on SQ re-activation

Alok Tiwari <alok.a.tiwari@oracle.com>
    bnge: use int for bnge_fix_rings_count() return value

Stefan Agner <stefan@agner.ch>
    net: stmmac: resume PHY before hardware setup when opening the interface

Martin Kaiser <martin@kaiser.cx>
    selftests/ftrace: refactor eprobes test to fix argument checks

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/lm25066) Fix PMBus coefficient calculations

Qingshuang Fu <fuqingshuang@kylinos.cn>
    hwmon: (nzxt-smart2) Check return value of init_device() in probe

Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
    drm/xe/uc: Apply RCS/CCS yield policy to SR-IOV VFs

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/openvswitch: check Ethernet header length in key_extract()

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: reject feature changes after endpoint

Linfeng Sun <slf@hdu.edu.cn>
    vhost-scsi: Validate T10 PI scatterlist counts

Toke Høiland-Jørgensen <toke@toke.dk>
    net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    udp: fix potential use-after-free in tunnel segmentation

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: validate metadata when processing requests

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: validate launch-time metadata size

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: clear metadata pointer when no timestamp is requested

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: pass TX metadata pointer by reference

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: require at least 16 bytes of TX metadata

Will Chen <will.chen.tty@gmail.com>
    bnxt: fix memory leak in bnxt_queue_mem_alloc error cases

Pavel Begunkov <asml.silence@gmail.com>
    eth: bnxt: support qcfg provided rx page size

Pavel Begunkov <asml.silence@gmail.com>
    eth: bnxt: store rx buffer size per queue

Pavel Begunkov <asml.silence@gmail.com>
    net: pass queue rx page size from memory provider

Pavel Begunkov <asml.silence@gmail.com>
    net: add bare bone queue configs

Jakub Kicinski <kuba@kernel.org>
    net: reduce indent of struct netdev_queue_mgmt_ops members

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips

Nathan Gao <zcgao@amazon.com>
    tcp: do not change rcv_ssthresh in tcp_measure_rcv_mss()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix type confusion in notification logic

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus_core) Use guard() for mutex protection

Christian Borntraeger <borntraeger@linux.ibm.com>
    vdpa/mlx5: Fix buffer length in create_direct_keys()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    vhost/vdpa: reject overflowing PA map page counts on 32-bit

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: tcp: Fix use-after-free in bpf_iter_tcp_established_batch()

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
    bpf: Propagate untrusted pointer state in commuted arithmetic

Eduard Zingerman <eddyz87@gmail.com>
    bpf: split check_reg_sane_offset() in two parts

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

Qingfang Deng <qingfang.deng@linux.dev>
    ovpn: fix incorrect use of rcu_access_pointer()

Antonio Quartulli <antonio@openvpn.net>
    ovpn: ensure TCP vars are initialized first

Antonio Quartulli <antonio@openvpn.net>
    ovpn: disable IPv4 redirects on MP interfaces

Antonio Quartulli <antonio@openvpn.net>
    ovpn: hash floated peer by transport identity only

Antonio Quartulli <antonio@openvpn.net>
    ovpn: zero-initialize sockaddr before learning a floated endpoint

Antonio Quartulli <antonio@openvpn.net>
    ovpn: ensure socket is owned by ovpn before deref sk_user_data

Antonio Quartulli <antonio@openvpn.net>
    ovpn: rehash peer in by_transp_addr table on CMD_PEER_SET

Antonio Quartulli <antonio@openvpn.net>
    ovpn: skip rehash for peers already removed from by_id

Rosen Penev <rosenp@gmail.com>
    ARM: dts: BCM5301X: fix PCIe controller 2 second interrupt

Ralf Lici <ralf@mandelbit.com>
    ovpn: add missing rtnl_link_ops->get_size callback

Hans Ulli Kroll <linux@ulli-kroll.de>
    pinctrl: qcom: ipq806x: mark pci reset as a GPIO pin function

Hans Ulli Kroll <linux@ulli-kroll.de>
    pinctrl: qcom: ipq806x: mark gpio as a GPIO pin function

Kuba Piecuch <jpiecuch@google.com>
    selftests/sched_ext: Handle sleeping task affinity changes in numa test

Yuho Choi <dbgh9129@gmail.com>
    ARM: npcm: Fix OF node refcount leaks in SMP setup

Yun Zhou <yun.zhou@windriver.com>
    xfs: handle NULL b_addr in xfs_buf_free

Daniel Drake <dan@reactivated.net>
    arm64: dts: broadcom: bcm2712: Remove non-functional EL2 virtual timer

Anna Schumaker <anna.schumaker@hammerspace.com>
    NFS: Pin the 'struct nfs_server' during a FREE_STATEID call

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sdm850-lenovo-yoga-c630: lower PSCI cluster idle

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    arm64: dts: qcom: purwa: Fix GPU IOMMU property

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: rename x1p42100 to purwa

Aleksandrs Vinarskis <alex@vinarskis.com>
    arm64: dts: qcom: Rework X1-based Asus Zenbook A14's displays

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: rename x1e80100 to hamoa

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Check for tg ops in dce110_set_avmute

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Add AV mute wait frames to dce110_set_avmute

Michal Luczaj <mhal@rbox.co>
    selftests/bpf: Fail unbound UDP on sockmap update

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Revert 6d71a9c61604 ("sched/fair: Fix EEVDF entity placement bug causing scheduling lag")

Ingo Molnar <mingo@kernel.org>
    sched/fair: Separate se->vlag from se->vprot

Al Viro <viro@zeniv.linux.org.uk>
    mount: honour SB_NOUSER in the new mount API

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix resource leak on IRQ registration failure


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   9 +
 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  16 +-
 MAINTAINERS                                        |   5 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi             |   2 +-
 arch/arm/mach-npcm/platsmp.c                       |   2 +
 arch/arm64/boot/dts/broadcom/bcm2712.dtsi          |   2 -
 arch/arm64/boot/dts/qcom/Makefile                  |   2 +
 arch/arm64/boot/dts/qcom/hamoa-iot-som.dtsi        |   4 +-
 .../qcom/{x1e80100-pmics.dtsi => hamoa-pmics.dtsi} |   0
 .../boot/dts/qcom/{x1e80100.dtsi => hamoa.dtsi}    |   0
 .../boot/dts/qcom/{x1p42100.dtsi => purwa.dtsi}    |   6 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |   4 +
 arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi  |   9 +-
 arch/arm64/boot/dts/qcom/x1-crd.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi        |   2 +-
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts       |   4 +-
 .../dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi    |   4 +-
 .../boot/dts/qcom/x1e80100-asus-vivobook-s15.dts   |   4 +-
 .../boot/dts/qcom/x1e80100-asus-zenbook-a14.dts    |  10 +-
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |   2 +-
 .../qcom/x1e80100-dell-inspiron-14-plus-7441.dts   |   2 +-
 .../boot/dts/qcom/x1e80100-dell-latitude-7455.dts  |   2 +-
 .../boot/dts/qcom/x1e80100-dell-xps13-9345.dts     |   4 +-
 .../boot/dts/qcom/x1e80100-hp-omnibook-x14.dts     |   4 +-
 .../boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts  |   4 +-
 .../boot/dts/qcom/x1e80100-microsoft-romulus.dtsi  |   4 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   4 +-
 .../dts/qcom/x1p42100-asus-zenbook-a14-lcd.dts     |  62 ++++
 .../boot/dts/qcom/x1p42100-asus-zenbook-a14.dts    | 133 +-------
 .../boot/dts/qcom/x1p42100-asus-zenbook-a14.dtsi   | 138 +++++++++
 arch/arm64/boot/dts/qcom/x1p42100-crd.dts          |   2 +-
 .../boot/dts/qcom/x1p42100-hp-omnibook-x14.dts     |   4 +-
 .../boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts |   4 +-
 arch/arm64/include/asm/ptdump.h                    |   2 -
 arch/arm64/mm/mmu.c                                |  43 +--
 arch/arm64/mm/ptdump.c                             |  11 +-
 arch/s390/kvm/pci.c                                |  31 +-
 arch/x86/kernel/cpu/common.c                       |  10 +
 arch/x86/kernel/cpu/mce/core.c                     |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   3 +
 arch/x86/kvm/svm/sev.c                             |  34 ++-
 arch/x86/kvm/svm/svm.h                             |   1 +
 block/blk-mq.c                                     |  34 +--
 drivers/android/binder/process.rs                  |  12 +-
 drivers/ata/pata_sl82c105.c                        |   4 +-
 drivers/bluetooth/btrtl.c                          |  13 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/counter/microchip-tcb-capture.c            |   4 +-
 drivers/dibs/dibs_loopback.c                       |   1 -
 drivers/dibs/dibs_main.c                           |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  35 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   6 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  24 +-
 drivers/gpu/drm/bridge/parade-ps8640.c             |  27 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   6 +
 drivers/gpu/drm/v3d/v3d_sched.c                    |   9 +-
 drivers/gpu/drm/xe/xe_uc.c                         |   7 +-
 drivers/hwmon/ads7828.c                            |  11 +-
 drivers/hwmon/corsair-psu.c                        |   4 +-
 drivers/hwmon/ltc4282.c                            |  20 +-
 drivers/hwmon/nzxt-smart2.c                        |   6 +-
 drivers/hwmon/pmbus/lm25066.c                      |   5 +-
 drivers/hwmon/pmbus/pmbus_core.c                   | 340 +++++++++------------
 drivers/input/evdev.c                              |  27 +-
 drivers/iommu/intel/iommu.c                        |  11 +-
 drivers/misc/fastrpc.c                             |  27 +-
 drivers/misc/mei/client.c                          |  25 +-
 drivers/net/bonding/bond_alb.c                     |  10 +-
 drivers/net/ethernet/amd/pds_core/core.h           |   1 +
 drivers/net/ethernet/amd/pds_core/main.c           |  14 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  51 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h   |   1 +
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   2 +-
 drivers/net/ethernet/broadcom/bnge/bnge_netdev.c   |   2 -
 drivers/net/ethernet/broadcom/bnge/bnge_resc.c     |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 163 +++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   4 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |  11 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   9 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   1 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   6 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  10 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   6 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   3 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  13 +-
 drivers/net/netdevsim/netdev.c                     |   7 +-
 drivers/net/ovpn/main.c                            |  64 ++--
 drivers/net/ovpn/netlink.c                         |   6 +
 drivers/net/ovpn/peer.c                            | 172 ++++++++---
 drivers/net/ovpn/peer.h                            |   1 +
 drivers/net/ovpn/socket.c                          |   9 +
 drivers/net/phy/mediatek/mtk.h                     |   8 +-
 drivers/net/tap.c                                  |  24 +-
 drivers/net/thunderbolt/main.c                     |  33 +-
 drivers/net/usb/ax88179_178a.c                     |   4 +-
 drivers/net/usb/ipheth.c                           |  11 +-
 drivers/net/veth.c                                 |  22 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/nvmem/apple-spmi-nvmem.c                   |  20 +-
 drivers/nvmem/core.c                               |  24 +-
 drivers/nvmem/internals.h                          |   2 +
 drivers/nvmem/layouts.c                            |  11 -
 drivers/nvmem/layouts/Makefile                     |   1 +
 drivers/nvmem/layouts/fixed-layout.c               |  58 ++++
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |   8 +-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |   5 +
 drivers/ptp/ptp_ocp.c                              |   4 +-
 drivers/s390/net/ism_drv.c                         |  19 +-
 drivers/scsi/scsi_debug.c                          |   4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   3 +
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   2 +-
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |   3 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   4 +
 drivers/thermal/thermal_hwmon.c                    |   3 +-
 drivers/thunderbolt/eeprom.c                       |   9 +-
 drivers/thunderbolt/icm.c                          |   2 +-
 drivers/thunderbolt/tb.c                           |   2 +-
 drivers/tty/serial/8250/8250_dma.c                 |  12 +-
 drivers/tty/serial/8250/8250_of.c                  |  38 +++
 drivers/tty/serial/amba-pl011.c                    |  86 ++++--
 drivers/tty/serial/qcom_geni_serial.c              |  43 +--
 drivers/tty/vt/keyboard.c                          |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 +
 drivers/usb/atm/cxacru.c                           |   2 +
 drivers/usb/cdns3/cdnsp-gadget.c                   |   4 +-
 drivers/usb/core/config.c                          |  32 +-
 drivers/usb/core/quirks.c                          |   7 +
 drivers/usb/gadget/function/f_ncm.c                |   2 +-
 drivers/usb/misc/usbio.c                           |   2 +-
 drivers/vdpa/mlx5/core/mr.c                        |   3 +-
 drivers/vhost/scsi.c                               |  17 ++
 drivers/vhost/vdpa.c                               |   9 +-
 drivers/vhost/vhost.c                              |   8 +
 drivers/video/fbdev/core/bitblit.c                 |   9 +-
 drivers/watchdog/at91sam9_wdt.c                    |   4 +-
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
 fs/xfs/xfs_buf.c                                   |   2 +-
 include/linux/dibs.h                               |   2 +-
 include/linux/mmap_lock.h                          |   1 +
 include/linux/netdevice.h                          |  11 +-
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/nvmem-provider.h                     |   6 +
 include/linux/psi.h                                |   4 +-
 include/linux/sched.h                              |  13 +-
 include/linux/usb/quirks.h                         |   3 +
 include/net/act_api.h                              |  19 ++
 include/net/addrconf.h                             |   4 +-
 include/net/ip_vs.h                                |  41 +--
 include/net/libeth/xsk.h                           |   2 +-
 include/net/netdev_queues.h                        |  47 ++-
 include/net/netdev_rx_queue.h                      |   2 +
 include/net/netfilter/nf_flow_table.h              |   1 +
 include/net/page_pool/types.h                      |   1 +
 include/net/route.h                                |   2 +
 include/net/sch_generic.h                          |   1 +
 include/net/xdp_sock.h                             |  47 +--
 include/net/xdp_sock_drv.h                         |  77 ++++-
 kernel/bpf/verifier.c                              |  68 +++--
 kernel/cgroup/cgroup.c                             |  23 +-
 kernel/events/core.c                               |  67 ++--
 kernel/futex/core.c                                |  85 ++++--
 kernel/sched/fair.c                                | 148 +++++++--
 kernel/sched/psi.c                                 |  75 ++++-
 kernel/trace/ring_buffer.c                         |  13 +-
 kernel/trace/trace_events.c                        |   4 +-
 mm/damon/ops-common.c                              |  13 +-
 mm/damon/paddr.c                                   |   2 +
 mm/damon/vaddr.c                                   |   3 +-
 mm/filemap.c                                       |   6 +
 mm/huge_memory.c                                   |  49 +--
 mm/pagewalk.c                                      |  36 ++-
 mm/ptdump.c                                        |   7 +
 mm/vmalloc.c                                       |  40 ++-
 net/atm/common.c                                   |  14 +-
 net/bridge/br_mrp.c                                |   6 +-
 net/bridge/netfilter/ebt_nflog.c                   |  17 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   1 +
 net/core/datagram.c                                |   3 +
 net/core/dev.c                                     |  27 +-
 net/core/netdev_rx_queue.c                         |  21 +-
 net/core/sock.c                                    |   1 -
 net/core/xdp.c                                     |   2 +-
 net/devlink/dev.c                                  |   1 +
 net/ipv4/fib_semantics.c                           | 101 +++---
 net/ipv4/inet_connection_sock.c                    |  20 +-
 net/ipv4/inet_fragment.c                           |  10 +-
 net/ipv4/route.c                                   |  29 ++
 net/ipv4/tcp_bpf.c                                 |   2 +
 net/ipv4/tcp_input.c                               |   2 +-
 net/ipv4/tcp_ipv4.c                                |  43 +--
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
 net/netfilter/ipvs/ip_vs_ctl.c                     |  77 ++++-
 net/netfilter/ipvs/ip_vs_est.c                     |  10 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   2 -
 net/netfilter/ipvs/ip_vs_sync.c                    |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netfilter/nf_conntrack_proto.c                 |   6 +
 net/netfilter/nf_conntrack_proto_sctp.c            |  12 +-
 net/netfilter/nf_conntrack_proto_tcp.c             | 132 +++++---
 net/netfilter/nf_flow_table_core.c                 |   1 +
 net/netfilter/nf_flow_table_ip.c                   |  95 ++++--
 net/netfilter/nf_flow_table_path.c                 |   9 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
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
 net/tls/tls_sw.c                                   |  18 +-
 net/vmw_vsock/virtio_transport.c                   |  14 +-
 net/x25/af_x25.c                                   |   4 +-
 net/x25/x25_timer.c                                |  25 +-
 net/xdp/xdp_umem.c                                 |   2 +
 net/xdp/xsk.c                                      |  11 +-
 net/xdp/xsk_buff_pool.c                            |   6 +-
 samples/damon/mtier.c                              |   3 +
 security/integrity/ima/ima_appraise.c              |   9 +-
 security/integrity/ima/ima_main.c                  |  39 +++
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c     |   3 +-
 sound/usb/endpoint.c                               |   6 +-
 sound/usb/fcp.c                                    |  10 +-
 sound/usb/midi2.c                                  |   9 +
 sound/usb/usx2y/us144mkii_capture.c                |   1 +
 sound/usb/usx2y/usX2Yhwdep.c                       |   2 +
 sound/usb/usx2y/usx2yhwdeppcm.c                    |   2 +
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   6 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  21 +-
 tools/testing/selftests/bpf/test_maps.c            |  13 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  16 +-
 tools/testing/selftests/net/tls.c                  |  57 ++++
 tools/testing/selftests/sched_ext/numa.bpf.c       |  13 +-
 281 files changed, 3279 insertions(+), 1604 deletions(-)


