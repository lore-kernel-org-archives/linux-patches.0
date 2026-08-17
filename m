Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40192C1594;
	Mon, 17 Aug 2026 14:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975445; cv=none; b=AaGfqXpZ3hLmH8dt9+ur/15crAo2UcDRFduC5kMBkbYMECkARvwGW8zyYDcET6kpTwwmkXkcyjWDg/BJVzUQ0xf8fLsuzbwHMKdw5+ukmCGOy4a3RJC1Du9kPGEGuWKsxQMvcT+kvG/ONbrJ6REmR+ZxwCaGmCzPGPquY7Gg3Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975445; c=relaxed/simple;
	bh=WeR5j7hM7pQ70pGmKEPxzqKoCC8vjPnIjO8Uv5pcoy8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J/1lU1i2bAZwXfcWQKx4MS8icTGtDVjpLPcZOPSVCCor81h/rM1NwNUEss8jmJOBCrqKlyPKiVAQLM0CXX7+u9jGW8md7XmSoTkz03HfFP1NYwgNgyYyc6jlSRMT8x+yR+4AeKwc8yZWSya4Fyl8nGXXvCD54pe2/0ina7mUgjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6fuAg7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6fuAg7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AE91F000E9;
	Mon, 17 Aug 2026 14:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975441;
	bh=K/bC2qChTc3l92ms9m3iWbv3tEZsBOofJM6U+Ub/OkM=;
	h=From:To:Cc:Subject:Date;
	b=K6fuAg7jBCeXrqWJseaQOY8W6/MJuOEGsh/q6RVWuUt2GF9xnI0b+TH61/dM+kcRy
	 mRkyTARycF2yDyvBMQo/nnZwveRmByTeH/JDyKXnAaKa+kYPphOkShMA3OKCcGqQcP
	 utNbR3+dvVMVnd6JQjmazQbNhEnmUix4IMjdU4b8=
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
Subject: [PATCH 5.10 000/389] 5.10.265-rc1 review
Date: Mon, 17 Aug 2026 15:27:19 +0200
Message-ID: <20260817132538.796021292@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.265-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.265-rc1
X-KernelTest-Deadline: 2026-08-19T13:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.265 release.
There are 389 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.265-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.265-rc1

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (adt7470) Add missing dependency on REGMAP_I2C

Jonas Gorski <jonas.gorski@bisdn.de>
    prestera: fix fallback to previous version on same major version

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

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_tunnel: clear skb2->cb[] in ip6ip6_err()

Yuejie Shi <syjcnss@gmail.com>
    ipv6: fix Route Information option length validation

Tengda Wu <wutengda@huaweicloud.com>
    ring-buffer: Use current_context for safe per-CPU buffer swap

Jun Yang <junvyyang@tencent.com>
    tipc: read le->link under the node lock in tipc_node_link_down()

Jun Yang <junvyyang@tencent.com>
    vhost: reset the vring metadata cache on vring reconfiguration

Weiming Shi <bestswngs@gmail.com>
    vsock/virtio: avoid refilling the RX queue after teardown

Baul Lee <baul.lee@xbow.com>
    vxlan: do not arm the ageing timer on a device that is down

Yangyu Chen <cyy@cyyself.name>
    net: atlantic: free RX pages of consumed but not refilled buffers

Zhiling Zou <zhilinz@nebusec.ai>
    netfilter: bridge: release template ct on non-IP path

Kyle Zeng <kylebot@openai.com>
    ipv6: prevent in6_dev_get() from resurrecting inet6_dev

Rik van Riel <riel@surriel.com>
    fbdev: bitblit: bound-check glyph index in bit_cursor()

Eddie Lin <eddie.lin@oss.qualcomm.com>
    misc: fastrpc: fix memory leak in fastrpc_channel_ctx_free

Anandu Krishnan E <anandu.e@oss.qualcomm.com>
    misc: fastrpc: fix channel ctx ref leak when session alloc fails

Mariano Baragiola <mbaragiola@linux.com>
    staging: rtl8723bs: validate monitor transmit frame lengths

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_get_wpa_ie()

Cunhao Lu <1579567540@qq.com>
    serial: 8250_dma: Clear stale RX state on shutdown

Chengfeng Ye <nicoyip.dev@gmail.com>
    ipv4: fix use-after-free in fib_nhc_update_mtu()

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Replace mk_users keyring with simple list

Aaron Tomlin <atomlin@atomlin.com>
    mips: sched: Fix CPUMASK_OFFSTACK memory corruption

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix a use-after-free problem in rxe_mmap

Keno Fischer <keno@juliacomputing.com>
    futex: Prevent robust futex exit race some more

Lincoln Wallace <locnnil0@gmail.com>
    ima: fix out-of-bounds read in xattr_verify()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: 6lowpan: Fix using chan->conn as indication to no remote netdev

Marco Elver <elver@google.com>
    Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - fix information leak in evdev_pass_values()

Joshua Rogers <linux@joshua.hu>
    vt: stabilize tty reference in kbd_keycode with tty_port_tty_get

Joshua Rogers <linux@joshua.hu>
    vt: add permission check for KDSKBMETA ioctl

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: ebt_nflog: pin the NFLOG backend

Qihang Tang <q.h.hack.winter@gmail.com>
    net: remove CAP_SYS_RAWIO zero-padding in dev_validate_header

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

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: f_ncm: Use unsigned int for ndp_index

Aleksandr Nogikh <nogikh@google.com>
    usb: atm: cxacru: properly kill rcv_urb on error in cxacru_cm()

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix OOB write on Type II inbound URBs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: evdev - sanitize event type index when fetching event masks

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Evaluate packsize caps at the right place

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Avoid setup_accel logic for DMA transfers

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    tls: don't abort the connection on signal-interrupted sends

Xin Long <lucien.xin@gmail.com>
    sctp: extract sctp_v4_err_handle function from sctp_v4_err

Xin Long <lucien.xin@gmail.com>
    sctp: extract sctp_v6_err_handle function from sctp_v6_err

Xin Long <lucien.xin@gmail.com>
    sctp: remove the unessessary hold for idev in sctp_v6_err

Xin Long <lucien.xin@gmail.com>
    sctp: clear control chunk transport if it is being removed

Hongyan Xu <getshell@seu.edu.cn>
    ata: pata_sl82c105: fix bridge revision use-after-free

Łukasz Patron <priv.luk@gmail.com>
    net: qrtr: ns: Raise lookup limit to 128

Eric Dumazet <edumazet@google.com>
    net: remove WARN_ON_ONCE() from sk_mc_loop()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: prestera: validate firmware header length

Vadym Kochan <vkochan@marvell.com>
    net: marvell: prestera: try to load previous fw version

Henry Martin <bsdhenrymartin@gmail.com>
    net/ncsi: fix heap OOB read in NCSI_CMD_SEND_CMD payload length

Qing Luo <luoqing@kylinos.cn>
    sctp: fix addip_serial increment on ASCONF_ACK allocation failure

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Disable EOP for TPA on all chips to prevent data corruption

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Do not set EOP on RX AGG BDs on 5760X chips

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/openvswitch: check Ethernet header length in key_extract()

Randy Dunlap <rdunlap@infradead.org>
    net: openvswitch: fix kernel-doc warnings in flow.c

Andrew Lunn <andrew@lunn.ch>
    net: openvswitch: Fix kerneldoc warnings

Toke Høiland-Jørgensen <toke@toke.dk>
    net/sched: sch_cake: drop WARN_ON(1) for malformed packets in ACK filter

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    udp: fix potential use-after-free in tunnel segmentation

Babanpreet Singh <bbnpreetsingh@gmail.com>
    counter: microchip-tcb-capture: Fix DT channel validation

Michael Guralnik <michaelgur@nvidia.com>
    net/mlx5: fw_tracer, return NULL on create error

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Remove second FW tracer check

Jiawen Liu <1298662399@qq.com>
    net: hisilicon: hix5hd2_gmac: remove redundant NAPI delete

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_route: fix fastmap use-after-free on filter

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: fix qentry overwrite for CONFIRM_LINK and ADD_LINK_CONT in smc_llc_event_handler()

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Preserve pointer state for commuted arithmetic

Xiang Mei (Microsoft) <xmei5@asu.edu>
    bonding: alb: re-check primary_is_promisc under RTNL in bond_alb_monitor

Yuho Choi <dbgh9129@gmail.com>
    ARM: npcm: Fix OF node refcount leaks in SMP setup

Anna Schumaker <anna.schumaker@hammerspace.com>
    NFS: Pin the 'struct nfs_server' during a FREE_STATEID call

Scott Mayhew <smayhew@redhat.com>
    nfs4: take a reference on the nfs_client when running FREE_STATEID

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix missing mem scrub at clear key import in cca_clr2cipherkey()

Al Viro <viro@zeniv.linux.org.uk>
    mount: honour SB_NOUSER in the new mount API

Junjie Cao <junjie.cao@intel.com>
    gpio: pch: use raw_spinlock_t for the register lock

Tze Yee Ng <tze.yee.ng@altera.com>
    firmware: stratix10-svc: fix memory leaks and list corruption bugs

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during recirculation

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: SCO: Fix use-after-free in sco_recv_frame() due to missing sock_hold

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_sock_timeout

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

HyeongJun An <sammiee5311@gmail.com>
    HID: logitech-dj: Fix maxfield check in DJ short report validation

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: bound DMA command body size against suffix pointer

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate DRAW_PRIMITIVES header size before division

Harkirat Gill <harkirat.gill@amd.com>
    drm/amdgpu: cap GTT size to physical RAM on APUs

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Zero the tile state data array before each BIN job

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

Oleksij Rempel <linux@rempel-privat.de>
    can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer

H. Nikolaus Schaller <hns@goldelico.com>
    i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock

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

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix potential NULL pointer dereference

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()

Myeonghun Pak <mhun512@gmail.com>
    i2c: amd-mp2: Unregister callback on adapter add failure

Asim Viladi Oglu Manizada <manizada@pm.me>
    sctp: prevent peer transport count overflow

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    sctp: reject stale cookies with mismatched verification tags

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/clone3: fix wild pointer access of getline due to missing init

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/filters: Fix false positive match in regex_match_full()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Check return value of __register_event() in trace_module_add_events()

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

Luxiao Xu <rakukuip@gmail.com>
    audit: fix potential use-after-free in audit_del_rule()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    audit: fix potential integer overflow in audit_log_n_string()

Charles Vosburgh <trilobyte777@gmail.com>
    sctp: validate Adaptation Indication parameter length

Xiangfeng Cai <caixiangfeng@bytedance.com>
    mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan <ziy@nvidia.com>
    mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: bm1880: add missing select GENERIC_PINCONF

Karl Mehltretter <kmehltretter@gmail.com>
    pinctrl: devicetree: don't free uninitialized dev_name on error path

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rhashtable: clear stale iter->p on table restart

Pengfei Zhang <zhangfeionline@gmail.com>
    ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump

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

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix memory leak during adapter release by destroying gid_pn_req

Christian Marangi <ansuelsmth@gmail.com>
    net: phylink: put link_gpio if phylink_create fails

Jiale Yao <yaojiale02@163.com>
    Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value from pmbus_update_byte_data()

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-akebono CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-currituck CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix simpleboot CPU node lookup check

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix PWM auto temp state array and bounds check

Chris Packham <chris.packham@alliedtelesis.co.nz>
    hwmon: (adt7470) Convert to use regmap

Chris Packham <chris.packham@alliedtelesis.co.nz>
    hwmon: (adt7470) Fix some style issues

Chris Packham <chris.packham@alliedtelesis.co.nz>
    hwmon: (adt7470) Create functions for updating readings and limits

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread

Chenguang Zhao <zhaochenguang@kylinos.cn>
    forcedeth: fix UAF of txrx_stats in nv_remove

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Prevent access to unsupported weight registers

Dawei Feng <dawei.feng@seu.edu.cn>
    smb: client: fix buffer leaks in SMB1 read and write

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi_tcp: Bound SCSI Response data segment to the connection buffer

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer

Xiang Mei <xmei5@asu.edu>
    rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: nft_payload: fix mask build for partial field offload

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH

Michael Bommarito <michael.bommarito@gmail.com>
    assoc_array: trim the final shortcut word using the current chunk end

Michael Bommarito <michael.bommarito@gmail.com>
    keys: make keyring key-chunk byte order agree with keyring_diff_objects()

Michael Bommarito <michael.bommarito@gmail.com>
    keys: fix out-of-bounds read in keyring_get_key_chunk()

Xiang Mei <xmei5@asu.edu>
    netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA

Sabrina Dubroca <sd@queasysnail.net>
    tls: separate no-async decryption request handling from async

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

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix sequence number when no EOF

Isaac Scott <isaac.scott@ideasonboard.com>
    media: uvcvideo: Implement dual stream quirk to fix loss of usb packets

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: mpls: initialize rtm_tos in mpls_getroute()

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: vlan: fix global vlan option range dumping

Eric Dumazet <edumazet@google.com>
    raw: fix a typo in raw_icmp_error()

Eric Dumazet <edumazet@google.com>
    raw: remove unused variables from raw6_icmp_error()

Kyle Zeng <kylebot@openai.com>
    openvswitch: fix GSO userspace truncation underflow

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses

Weiming Shi <bestswngs@gmail.com>
    tipc: fix use-after-free of the discoverer in tipc_disc_rcv()

Ce Sun <cesun102@amd.com>
    drm/amdgpu: invoke pm_genpd_remove() before freeing genpd

Boyuan Zhang <boyuan.zhang@amd.com>
    drm/amdgpu: fix division by zero with invalid uvd dimensions

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx8: drop unecessary BUG_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()

Daehyeon Ko <4ncienth@gmail.com>
    tipc: clear sock->sk on the failed-insert path in tipc_sk_create()

Asim Viladi Oglu Manizada <manizada@pm.me>
    pppoe: reload header pointer after dev_hard_header()

Doruk Tan Ozturk <doruk@0sec.ai>
    mac802154: llsec: reject frames shorter than the authentication tag

Michael Bommarito <michael.bommarito@gmail.com>
    ila: reload IPv6 header after pskb_may_pull in checksum adjust

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

Christian Brauner <brauner@kernel.org>
    binfmt_elf_fdpic: only honour the first PT_INTERP

Douya Le <ldy3087146292@gmail.com>
    libceph: remove debugfs files before client teardown

Douya Le <ldy3087146292@gmail.com>
    libceph: reject zero bucket types in crush_decode

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

deepakraog <gaikwad.dcg@gmail.com>
    tracing: Fix resource leak on mmiotrace trace_pipe close

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev

Guangshuo Li <lgs201920130244@gmail.com>
    intel_th: fix MSC output device reference leak

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_parport: deal with premature interrupt

Xu Rao <raoxu@uniontech.com>
    cdrom: fix stack out-of-bounds read in CDROMVOLCTRL

Christian Brauner <brauner@kernel.org>
    binfmt_misc: set have_execfd only once the interpreter is opened

Christian Brauner <brauner@kernel.org>
    exec: fix unsigned loop counter wrap in transfer_args_to_stack()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix session UAF in set_termios

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: make release_scratchbuffers idempotent

Huihui Huang <hhhuang@smu.edu.sg>
    wifi: wilc1000: validate assoc response length before subtracting header

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper

Tristan Madani <tristan@talencesecurity.com>
    wifi: ath6kl: fix OOB access from firmware ADDBA window size

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: vivid: check for vb2_is_busy() when toggling caps

Guangshuo Li <lgs201920130244@gmail.com>
    media: vimc: fix reference leak on failed device registration

Guangshuo Li <lgs201920130244@gmail.com>
    media: vidtv: fix reference leak on failed device registration

Zile Xiong <xiongzile99@gmail.com>
    media: vb2: use ssize_t for vb2_read/vb2_write

Hungyu Lin <dennylin0707@gmail.com>
    media: tegra-video: vi: fix invalid u32 return value in format lookup

Valery Borovsky <vebohr@gmail.com>
    media: sun4i-csi: Return queued buffers on start_streaming() failure

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

Lee Jones <lee@kernel.org>
    can: bcm: defer rx_op deallocation to workqueue to fix thrtimer UAF

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf, sockmap: Fix cork use-after-free in tcp_bpf_sendmsg()

Li RongQing <lirongqing@baidu.com>
    net: ipv6: fix dif and sdif mismatch in raw6_icmp_error

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.0: replace BUG_ON() with WARN_ON()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()

Pavel Ondračka <pavel.ondracka@gmail.com>
    drm/radeon: fix r100_copy_blit for large BOs

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau/acr: fix missing nvkm_done() in error path of nvkm_acr_oneinit()

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    drm/rockchip: cdn-dp: add missing check in cdn_dp_config_video()

Eric Dumazet <edumazet@google.com>
    raw: use more conventional iterators

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
    ipv4: icmp: fill flow parameters in icmp_route_lookup decoy lookup

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: reset residual action in L3L4 filters on delete

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix u16 MTU truncation in media and bearer MTU validation

Harshaka Narayana <harshaka.narayana@broadcom.com>
    vmxnet3: fix BUG_ON in vmxnet3_get_hdr_len() for Geneve packets

Qing Luo <luoqing@kylinos.cn>
    sctp: auth: verify auth requirement when auth_chunk is NULL

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix vlan range dumps starting with pvid

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: vlan: add support for dumping global vlan options

Nikolay Aleksandrov <nikolay@nvidia.com>
    net: bridge: vlan: add support for global options

Shelley Yang <shelley.yang@infineon.com>
    wifi: brcmfmac: fix 802.1X-SHA256 call trace warning

Helen Koike <koike@igalia.com>
    tipc: fix infinite loop in __tipc_nl_compat_dumpit

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    sctp: validate stream count in sctp_process_strreset_inreq()

HanQuan <eilaimemedsnaimel@gmail.com>
    sctp: fix auth_chunk_list capacity check in sctp_auth_ep_add_chunkid

Prashanth Kumar KR <PrashanthKumar.K.R@amd.com>
    amd-xgbe: fix MAC_AUTO_SW handling in CL37 AN

Andrew Pope <andrew.pope@morsemicro.com>
    wifi: mac80211: recalculate TIM when a station enters power save

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iommu/amd: Bound the early ACPI HID map

HE WEI (ギカク) <skyexpoc@gmail.com>
    wifi: mwifiex: bound uAP association event IEs to the event buffer

Ruoyu Wang <ruoyuw560@gmail.com>
    wan: wanxl: Only reset hardware after BAR mapping

Ruoyu Wang <ruoyuw560@gmail.com>
    nfp: Check resource mutex allocation

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    rds: drop incoming messages that cross network namespace boundaries

David Lee <david.lee@trailofbits.com>
    net/packet: avoid fanout hook re-registration after unregister

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    usb: atm: ueagle-atm: reject descriptors that confuse probe and disconnect

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: bt-sco: fix duplicate DAPM widget names for wideband DAI

Jiaxin Yu <jiaxin.yu@mediatek.com>
    ASoC: bt-sco: fix bt-sco-pcm-wb dai widget don't connect to the endpoint

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

Dmitry Morgun <d.morgun@ispras.ru>
    wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop

Cheng Yongkang <teel4res@gmail.com>
    wifi: ath9k: hif_usb: don't dereference hif_dev after re-arming firmware request

Xincheng Zhang <zhangxincheng@ultrarisc.com>
    usb: xhci-pci: Limit VIA VL805 DMA addressing to 36 bits

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix ld_{abs,ind} failure path analysis in subprogs

Doruk Tan Ozturk <doruk@0sec.ai>
    crypto: rsa-pkcs1pad: Don't WARN on an empty digest

Chukun Pan <amadeus@jmu.edu.cn>
    USB: serial: option: add TDTECH MT5710-CN

Sunho Park <shpark061104@gmail.com>
    USB: serial: io_edgeport: cap received transmit credits

Tim Pambor <timpambor@gmail.com>
    USB: serial: ftdi_sio: add support for E+H FXA291

Muhammad Bilal <meatuni001@gmail.com>
    usb: gadget: uvc: clamp SEND_RESPONSE length to the response buffer

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

Shuhao Fu <sfual@cse.ust.hk>
    can: j1939: fix lockless local-destination check

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/i915/gt: use correct selftest config symbol

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: handle overlapping allocated ranges in fallocate

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: fix infinite loop in NCQ tag completion bit-scanning

Colin Ian King <colin.i.king@gmail.com>
    ata: sata_dwc_460ex: remove variable num_processed

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: fix clear_interrupt_bit() clearing all pending interrupts

Rosen Penev <rosenp@gmail.com>
    ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered

Bryam Vargas <hexlabsecurity@proton.me>
    net/iucv: take a reference on the socket found in afiucv_hs_rcv()

Weiming Shi <bestswngs@gmail.com>
    ipv4: fib: free fib_alias with kfree_rcu() on insert error path

Pushpendra Singh <pushpendra.singh@oss.qualcomm.com>
    firmware: arm_scmi: Rate-limit queue-full warnings in IRQ context

Uday Khare <udaykhare77@gmail.com>
    ASoC: tas2562: fix deprecated 'shut-down' GPIO always cleared after lookup

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

Xiang Mei <xmei5@asu.edu>
    wifi: p54: validate RX frame length in p54_rx_eeprom_readback()

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: libertas: fix memory leak in helper_firmware_cb()

Bryam Vargas <hexlabsecurity@proton.me>
    wifi: mac80211_hwsim: clamp virtio RX length before skb_put

Ramon Fontes <ramonreisfontes@gmail.com>
    mac80211_hwsim: add 6GHz channels

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: policy: preallocate inexact bins before xfrm_hash_rebuild reinsert

Danila Chernetsov <listdansp@mail.ru>
    RDMA/hns: Fix potential integer overflow in mhop hem cleanup

Xiang Mei <xmei5@asu.edu>
    btrfs: reject free space cache with more entries than pages

Nikolay Borisov <nborisov@suse.com>
    btrfs: remove crc_check logic from free space

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: nand: mtk-ecc: stop on ECC idle timeouts

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: mtdswap: remove debugfs stats file on teardown

Michael Bommarito <michael.bommarito@gmail.com>
    IB/mad: Drop unmatched RMPP responses before reassembly

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Make vmread_error_trampoline() uncallable from C code

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix logic error in packet reset

Seungjin Bae <eeodqql09@gmail.com>
    Input: ims-pcu - fix heap-buffer-overflow in ims_pcu_process_data()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: serialize TX state transitions under so->rx_lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix use-after-free race with concurrent NETDEV_UNREGISTER

Phil Rosenthal <phil@phil.gs>
    KVM: x86/mmu: Fix use-after-free on vendor module reload

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: nVMX: Hide shadow VMCS right after VMCLEAR

Daehyeon Ko <4ncienth@gmail.com>
    macsec: don't read an unset MAC header in macsec_encrypt()

Bradley Morgan <include@grrlz.net>
    cpu: hotplug: Bound hotplug states sysfs output

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: Fix potential UAF when ddgst mismatch


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/mach-npcm/platsmp.c                       |   2 +
 arch/mips/kernel/mips-mt-fpaff.c                   |  28 +-
 arch/powerpc/boot/simpleboot.c                     |   2 +-
 arch/powerpc/boot/treeboot-akebono.c               |   2 +-
 arch/powerpc/boot/treeboot-currituck.c             |   2 +-
 arch/powerpc/platforms/ps3/mm.c                    |   1 +
 arch/um/drivers/vector_kern.c                      |   3 +
 arch/x86/kvm/mmu/mmu.c                             |   2 +
 arch/x86/kvm/vmx/nested.c                          |  11 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |  16 +-
 crypto/rsa-pkcs1pad.c                              |   2 +-
 drivers/ata/pata_sl82c105.c                        |   4 +-
 drivers/ata/sata_dwc_460ex.c                       |  21 +-
 drivers/block/rbd.c                                |   7 +-
 drivers/cdrom/cdrom.c                              |   1 +
 drivers/counter/microchip-tcb-capture.c            |   4 +-
 drivers/cpufreq/powernow-k8.c                      |   1 +
 drivers/dma/sun6i-dma.c                            |  11 +-
 drivers/firewire/net.c                             |  37 +-
 drivers/firmware/arm_scmi/notify.c                 |   6 +-
 drivers/firmware/stratix10-svc.c                   |   9 +-
 drivers/gpio/gpio-pch.c                            |  28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |  45 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  12 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   8 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   3 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   4 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/hwmgr.c     |   7 +-
 drivers/gpu/drm/i915/gt/intel_engine_user.c        |   2 +-
 drivers/gpu/drm/i915/gt/selftest_gt_pm.c           |   8 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/acr/base.c     |   1 +
 drivers/gpu/drm/radeon/r100.c                      |  13 +-
 drivers/gpu/drm/rockchip/cdn-dp-reg.c              |   2 +
 drivers/gpu/drm/vc4/vc4_validate.c                 |  29 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  14 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_surface.c            |  22 +-
 drivers/hid/hid-logitech-dj.c                      |  28 +-
 drivers/hwmon/Kconfig                              |   1 +
 drivers/hwmon/adt7470.c                            | 605 +++++++++++++--------
 drivers/hwmon/corsair-cpro.c                       |   1 +
 drivers/hwmon/nct6775.c                            |  12 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   2 +-
 drivers/hwtracing/intel_th/core.c                  |  10 -
 drivers/hwtracing/intel_th/msu.c                   |   2 +
 drivers/i2c/busses/i2c-amd-mp2-plat.c              |   4 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/infiniband/core/mad.c                      |  30 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   2 +-
 drivers/infiniband/sw/rxe/rxe_mmap.c               |  19 +-
 drivers/input/evdev.c                              |  27 +-
 drivers/input/misc/ims-pcu.c                       |  32 +-
 drivers/iommu/amd/init.c                           |   6 +
 drivers/iommu/intel/svm.c                          |   2 +-
 drivers/media/cec/platform/seco/seco-cec.c         |   6 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |  12 +-
 drivers/media/dvb-frontends/rtl2832.c              |   4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  19 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  14 +-
 drivers/media/pci/dm1105/dm1105.c                  |   1 +
 drivers/media/pci/saa7134/saa7134-video.c          |  25 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c |   6 +-
 drivers/media/radio/radio-si476x.c                 |   1 +
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |   1 +
 drivers/media/test-drivers/vivid/vivid-ctrls.c     |  12 +
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   6 +
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |   6 +
 drivers/media/usb/airspy/airspy.c                  |   8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  16 +-
 drivers/media/usb/msi2500/msi2500.c                |  32 +-
 drivers/media/usb/pwc/pwc-if.c                     |  13 +-
 drivers/media/usb/uvc/uvc_video.c                  |  78 ++-
 drivers/media/usb/uvc/uvcvideo.h                   |   4 +
 drivers/misc/fastrpc.c                             |   3 +-
 drivers/mtd/mtdswap.c                              |   5 +-
 drivers/mtd/nand/raw/mtk_ecc.c                     |  16 +-
 drivers/net/bonding/bond_alb.c                     |  10 +-
 drivers/net/can/softing/softing_fw.c               |  46 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  13 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  40 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  20 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  11 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |  22 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/hisilicon/hip04_eth.c         |  11 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |   1 -
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |   2 -
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |  21 -
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   2 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   2 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |  87 ++-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  15 +
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   7 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_resource.c  |   3 +
 drivers/net/ethernet/nvidia/forcedeth.c            |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  44 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   1 +
 drivers/net/geneve.c                               |   3 +
 drivers/net/macsec.c                               |   2 +-
 drivers/net/phy/phylink.c                          |  29 +-
 drivers/net/ppp/pppoe.c                            |   1 +
 drivers/net/slip/slip.c                            |   4 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  22 +-
 drivers/net/vxlan/vxlan_core.c                     |  20 +-
 drivers/net/wan/wanxl.c                            |   3 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   3 +
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
 drivers/net/wireless/intersil/p54/txrx.c           |   8 +
 drivers/net/wireless/mac80211_hwsim.c              |  75 ++-
 drivers/net/wireless/marvell/libertas/firmware.c   |   1 +
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/tdls.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |  24 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   4 +
 drivers/net/wireless/microchip/wilc1000/hif.c      |   5 +
 drivers/nvme/target/tcp.c                          |   4 +-
 drivers/phy/xilinx/phy-zynqmp.c                    |  37 +-
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/pinctrl/devicetree.c                       |   4 +
 drivers/s390/block/dasd_ioctl.c                    |   2 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |  26 +-
 drivers/s390/scsi/zfcp_aux.c                       |   1 +
 drivers/scsi/libiscsi.c                            |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   8 +-
 drivers/scsi/scsi_debug.c                          |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |  13 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |  13 +-
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   6 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   3 +
 drivers/staging/media/tegra-video/vi.c             |   4 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   3 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   4 +
 drivers/thunderbolt/eeprom.c                       |   9 +-
 drivers/tty/serial/8250/8250_dma.c                 |  12 +-
 drivers/tty/vt/keyboard.c                          |   5 +-
 drivers/tty/vt/vt_ioctl.c                          |   2 +
 drivers/usb/atm/cxacru.c                           |   2 +
 drivers/usb/atm/ueagle-atm.c                       |  17 +
 drivers/usb/chipidea/core.c                        |   1 +
 drivers/usb/gadget/function/f_midi.c               |   1 +
 drivers/usb/gadget/function/f_ncm.c                |  19 +-
 drivers/usb/gadget/function/f_printer.c            |  23 +-
 drivers/usb/gadget/function/uvc_v4l2.c             |   2 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |  40 +-
 drivers/usb/gadget/udc/fsl_udc_core.c              |   1 -
 drivers/usb/gadget/udc/snps_udc_core.c             |   1 -
 drivers/usb/host/xhci-pci.c                        |   1 +
 drivers/usb/host/xhci.c                            |  15 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   5 +
 drivers/usb/serial/io_edgeport.c                   |   3 +-
 drivers/usb/serial/option.c                        |   1 +
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/vhost/vhost.c                              |   8 +
 drivers/video/fbdev/core/bitblit.c                 |   9 +-
 drivers/watchdog/watchdog_pretimeout.c             |   2 +
 fs/binfmt_elf_fdpic.c                              |   4 +
 fs/binfmt_misc.c                                   |   9 +-
 fs/btrfs/free-space-cache.c                        |  38 +-
 fs/btrfs/free-space-cache.h                        |   1 -
 fs/ceph/caps.c                                     |   1 +
 fs/cifs/cifssmb.c                                  |  12 +-
 fs/cifs/smb2ops.c                                  |  25 +-
 fs/crypto/fscrypt_private.h                        |  32 +-
 fs/crypto/keyring.c                                | 212 ++++----
 fs/exec.c                                          |   2 +-
 fs/namespace.c                                     |   5 +
 fs/nfs/nfs4proc.c                                  |  13 +
 fs/proc/namespaces.c                               |   4 +-
 include/linux/dma/qcom_bam_dma.h                   |  21 +-
 include/linux/netdevice.h                          |   5 -
 include/linux/netfilter/nf_conntrack_sip.h         |   2 +-
 include/media/videobuf2-core.h                     |   8 +-
 include/net/addrconf.h                             |   4 +-
 include/net/bluetooth/bluetooth.h                  |   1 +
 include/net/bluetooth/l2cap.h                      |   1 +
 include/net/bluetooth/rfcomm.h                     |   3 +
 include/net/ip_vs.h                                |  20 +-
 include/net/raw.h                                  |   5 +-
 include/net/rawv6.h                                |   6 +-
 include/net/route.h                                |   2 +
 include/net/sctp/structs.h                         |   3 +-
 include/uapi/linux/if_bridge.h                     |  14 +
 kernel/audit.c                                     |  11 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/bpf/verifier.c                              |  31 +-
 kernel/cpu.c                                       |   9 +-
 kernel/futex/core.c                                |  82 ++-
 kernel/trace/ring_buffer.c                         |   8 +-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   3 +
 kernel/trace/trace_mmiotrace.c                     |   5 +-
 kernel/trace/trace_probe.c                         |  13 +-
 lib/assoc_array.c                                  |   3 +-
 lib/rhashtable.c                                   |   1 +
 mm/huge_memory.c                                   |  16 +-
 mm/hugetlb.c                                       |   2 +-
 mm/page_reporting.c                                |   6 +-
 mm/percpu-km.c                                     |   2 +-
 net/bluetooth/6lowpan.c                            |  18 +-
 net/bluetooth/af_bluetooth.c                       |  22 +
 net/bluetooth/hidp/core.c                          |   5 +-
 net/bluetooth/l2cap_core.c                         |  41 +-
 net/bluetooth/rfcomm/core.c                        |  17 +
 net/bluetooth/rfcomm/tty.c                         |   7 +-
 net/bluetooth/sco.c                                |  27 +-
 net/bridge/br_multicast.c                          |   1 +
 net/bridge/br_netlink_tunnel.c                     |   3 +-
 net/bridge/br_private.h                            |  14 +-
 net/bridge/br_vlan.c                               |  64 ++-
 net/bridge/br_vlan_options.c                       | 119 +++-
 net/bridge/netfilter/ebt_nflog.c                   |  17 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |   1 +
 net/can/bcm.c                                      | 564 ++++++++++++++-----
 net/can/isotp.c                                    | 295 +++++++---
 net/can/j1939/transport.c                          |  20 +-
 net/ceph/auth_x.c                                  |   9 +-
 net/ceph/ceph_common.c                             |   4 +-
 net/ceph/mon_client.c                              |   2 +-
 net/ceph/osdmap.c                                  |  12 +-
 net/core/lwt_bpf.c                                 |   4 +-
 net/core/sock.c                                    |   1 -
 net/ipv4/fib_semantics.c                           |  34 +-
 net/ipv4/fib_trie.c                                |   2 +-
 net/ipv4/icmp.c                                    |  18 +-
 net/ipv4/raw.c                                     |  91 ++--
 net/ipv4/raw_diag.c                                |  33 +-
 net/ipv4/route.c                                   |  29 +
 net/ipv4/tcp_bpf.c                                 |   4 +-
 net/ipv4/udp_offload.c                             |   4 +-
 net/ipv6/fib6_rules.c                              |   1 +
 net/ipv6/ila/ila_common.c                          |  12 +
 net/ipv6/ip6_fib.c                                 |  17 +-
 net/ipv6/ip6_tunnel.c                              |   3 +
 net/ipv6/raw.c                                     | 102 ++--
 net/ipv6/route.c                                   |   8 +-
 net/iucv/af_iucv.c                                 |  21 +-
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/rx.c                                  |   2 +
 net/mac802154/llsec.c                              |   5 +
 net/mpls/af_mpls.c                                 |   4 +
 net/ncsi/ncsi-netlink.c                            |   4 +
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  44 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   1 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |  77 ++-
 net/netfilter/ipvs/ip_vs_lc.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   2 -
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   2 -
 net/netfilter/ipvs/ip_vs_sync.c                    |   7 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_nat_sip.c                         |   2 +-
 net/netfilter/nft_payload.c                        |  12 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 net/openvswitch/actions.c                          |  26 +-
 net/openvswitch/datapath.c                         |  54 +-
 net/openvswitch/datapath.h                         |   2 +-
 net/openvswitch/flow.c                             |  28 +-
 net/openvswitch/meter.c                            |  33 +-
 net/openvswitch/vport.c                            |   6 +-
 net/packet/af_packet.c                             |  13 +-
 net/phonet/pep.c                                   |   2 +
 net/qrtr/af_qrtr.c                                 |   8 +
 net/qrtr/ns.c                                      |  33 +-
 net/rds/ib.c                                       |   4 +
 net/rds/ib_cm.c                                    |   4 +
 net/rds/recv.c                                     |  15 +
 net/rds/tcp.c                                      |  14 +-
 net/sched/act_tunnel_key.c                         |  14 +-
 net/sched/cls_route.c                              |  35 +-
 net/sched/sch_cake.c                               |   1 -
 net/sctp/associola.c                               |  14 +-
 net/sctp/auth.c                                    |   2 +-
 net/sctp/input.c                                   | 108 ++--
 net/sctp/ipv6.c                                    |  94 ++--
 net/sctp/outqueue.c                                |   1 +
 net/sctp/sm_make_chunk.c                           |  26 +-
 net/sctp/sm_statefuns.c                            |   8 +-
 net/sctp/stream.c                                  |   6 +-
 net/smc/smc_core.c                                 |   2 +-
 net/smc/smc_llc.c                                  |   3 +-
 net/tipc/core.c                                    |   5 +
 net/tipc/discover.c                                |  14 +-
 net/tipc/netlink.c                                 |   6 +-
 net/tipc/netlink_compat.c                          |   4 +
 net/tipc/node.c                                    |  15 +-
 net/tipc/socket.c                                  |   3 +-
 net/tls/tls_sw.c                                   |  19 +-
 net/vmw_vsock/virtio_transport.c                   |   3 +-
 net/wireless/nl80211.c                             |   4 +-
 net/wireless/pmsr.c                                |  21 +-
 net/wireless/scan.c                                |   2 +-
 net/x25/af_x25.c                                   |   8 +-
 net/xfrm/xfrm_policy.c                             |   4 +-
 security/integrity/ima/ima_appraise.c              |   9 +-
 security/keys/keyring.c                            |  14 +-
 sound/core/pcm_native.c                            |   7 +
 sound/pci/lx6464es/lx6464es.c                      |   5 +-
 sound/pci/lx6464es/lx_core.c                       |   5 +-
 sound/soc/codecs/bt-sco.c                          |  18 +-
 sound/soc/codecs/max98090.c                        |   5 +-
 sound/soc/codecs/max98095.c                        |   5 +-
 sound/soc/codecs/tas2562.c                         |  35 +-
 sound/soc/meson/aiu-fifo-spdif.c                   |   5 +
 sound/usb/6fire/chip.c                             |   4 +
 sound/usb/endpoint.c                               |  23 +-
 sound/usb/midi.c                                   |   2 +
 sound/usb/pcm.c                                    |   7 +
 tools/testing/selftests/clone3/clone3_set_tid.c    |   2 +-
 333 files changed, 3984 insertions(+), 1839 deletions(-)


