Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D52A1386D4;
	Tue, 14 May 2024 11:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687016; cv=none; b=WLBe2/1l+jXGtazYC/rVqZ24K0FVayVMlK2S1c23AiRzJzJL4DZpMBF9PEvPuZ9rV9TLZDR1MAdALK/m9uKGwWIrxIzp7uuTugfPfRAZjC+14bsKYjsVS1TPaNWC26bOvzNEgaVEOQ7f0WqjPb0cNaiMf8UyUU9wkHo3S2cVevQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687016; c=relaxed/simple;
	bh=nwXwpKnfca5Ds4u7hMmTrv5+l/ocY87NZZud7D2izi8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QPl+ieYPEfbNkm2yaxbAql8fH/fHBo0AOlrJTNuPfncggU+h87TX5B/oSRhl50DuA8BKhM0HN4u8B9iZJXabH3zDDAc94FNi69uY6wNKN9pi++BUaphyr/NA1z6i/LIOPpYjVzfRjngCggyNOo99uHDGbRZggU48dP8tbSx+3W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBPa0k3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBPa0k3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69874C2BD10;
	Tue, 14 May 2024 11:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687016;
	bh=nwXwpKnfca5Ds4u7hMmTrv5+l/ocY87NZZud7D2izi8=;
	h=From:To:Cc:Subject:Date:From;
	b=yBPa0k3uWg2TDrp/k7uQjsv/qrFcetWVd4ME8WKSlBSTKyHaEm8mqYNQQ8wSic/u9
	 AysWjstxa8S3wp9t7ybEXXdqT3BgT6YpSDZ11HhRUvcY/wfpMs7MSKLJki6RJTGNxM
	 WmajSskQN5QuVLMtm5kcOfzWs8ak0VODr1Kt3oVE=
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
Subject: [PATCH 5.4 00/84] 5.4.276-rc1 review
Date: Tue, 14 May 2024 12:19:11 +0200
Message-ID: <20240514100951.686412426@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.276-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.276-rc1
X-KernelTest-Deadline: 2024-05-16T10:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.276 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.276-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.276-rc1

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix PIN_CONFIG_INPUT_SCHMITT_ENABLE readback

YueHaibing <yuehaibing@huawei.com>
    pinctrl: mediatek: remove set but not used variable 'e'

Dan Carpenter <dan.carpenter@oracle.com>
    pinctrl: mediatek: Fix some off by one bugs

Hsin-Yi Wang <hsinyi@chromium.org>
    pinctrl: mediatek: Fix fallback behavior for bias_set_combo

Johan Hovold <johan+linaro@kernel.org>
    regulator: core: fix debugfs creation regression

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    net: fix out-of-bounds access in ops_init

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix invalid reads in fence signaled events

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix old BUG_ON in >control parser

Paolo Abeni <pabeni@redhat.com>
    tipc: fix UAF in error path

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: f_fs: Fix a race condition when processing setup packets.

Peter Korsgaard <peter@korsgaard.com>
    usb: gadget: composite: fix OS descriptors w_value logic

Thanassis Avgerinos <thanassis.avgerinos@gmail.com>
    firewire: nosy: ensure user_length is taken into account when fetching packet contents

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flower

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: sanitize 'rc' in qede_add_tc_flower_fltr()

Eric Dumazet <edumazet@google.com>
    ipv6: fib6_rules: avoid possible NULL dereference in fib6_rule_action()

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix corrupted ethernet header on multicast-to-unicast

Eric Dumazet <edumazet@google.com>
    phonet: fix rtm_phonet_notify() skb allocation

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

Hsin-Yi Wang <hsinyi@chromium.org>
    pinctrl: mediatek: Fix fallback call path

Vanillan Wang <vanillanwang@163.com>
    net:usb:qmi_wwan: support Rolling modules

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

Jernej Skrabec <jernej.skrabec@gmail.com>
    clk: sunxi-ng: h6: Reparent CPUX during PLL CPUX rate change

Xin Long <lucien.xin@gmail.com>
    tipc: fix a possible memleak in tipc_buf_append

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix multicast-to-unicast with fraglist GSO

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341

Andrew Lunn <andrew@lunn.ch>
    net: dsa: mv88e6xxx: Add number of MACs in the ATU

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: manage formatters in trigger

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-card: make links nonatomic

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flow_spec

David Bauer <mail@david-bauer.net>
    net l2tp: drop flow hash on forward

Kuniyuki Iwashima <kuniyu@amazon.com>
    nsh: Restore skb->{protocol,data,mac_header} for outer header in nsh_gso_segment().

Bui Quang Minh <minhquangbui99@gmail.com>
    bna: ensure the copied buf is NUL terminated

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix clearing storage keys for huge pages

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix storage key clearing for guest huge pages

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
    pinctrl: mediatek: paris: Rework mtk_pinconf_{get,set} switch/case logic

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix PIN_CONFIG_BIAS_* readback

Light Hsieh <light.hsieh@mediatek.com>
    pinctrl: mediatek: remove shadow variable declaration

Light Hsieh <light.hsieh@mediatek.com>
    pinctrl: mediatek: Backward compatible to previous Mediatek's bias-pull usage

Light Hsieh <light.hsieh@mediatek.com>
    pinctrl: mediatek: Refine mtk_pinconf_get()

Light Hsieh <light.hsieh@mediatek.com>
    pinctrl: mediatek: Refine mtk_pinconf_get() and mtk_pinconf_set()

Light Hsieh <light.hsieh@mediatek.com>
    pinctrl: mediatek: Supporting driving setting without mapping current to register value

Light Hsieh <light.hsieh@mediatek.com>
    pinctrl: mediatek: Check gpio pin number and use binary search in mtk_hw_pin_field_lookup()

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: core: delete incorrect free in pinctrl_enable()

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't free NULL coalescing rule

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"

Bumyong Lee <bumyong.lee@samsung.com>
    dmaengine: pl330: issue_pending waits until WFP state


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/mips/include/asm/ptrace.h                   |   2 +-
 arch/mips/kernel/asm-offsets.c                   |   1 +
 arch/mips/kernel/ptrace.c                        |  15 +-
 arch/mips/kernel/scall32-o32.S                   |  23 +-
 arch/mips/kernel/scall64-n32.S                   |   3 +-
 arch/mips/kernel/scall64-n64.S                   |   3 +-
 arch/mips/kernel/scall64-o32.S                   |  33 +--
 arch/s390/mm/gmap.c                              |   2 +-
 arch/s390/mm/hugetlbpage.c                       |   2 +-
 drivers/ata/sata_gemini.c                        |   5 +-
 drivers/clk/clk.c                                |  12 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c             |  19 +-
 drivers/firewire/nosy.c                          |   6 +-
 drivers/firewire/ohci.c                          |   6 +-
 drivers/gpio/gpio-crystalcove.c                  |   2 +-
 drivers/gpio/gpio-wcove.c                        |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c            |   2 +-
 drivers/gpu/host1x/bus.c                         |   8 -
 drivers/net/dsa/mv88e6xxx/chip.c                 |  29 ++-
 drivers/net/dsa/mv88e6xxx/chip.h                 |   6 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   |  16 +-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c  |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c   |  15 +-
 drivers/net/usb/qmi_wwan.c                       |   1 +
 drivers/pinctrl/core.c                           |   8 +-
 drivers/pinctrl/devicetree.c                     |  10 +-
 drivers/pinctrl/mediatek/pinctrl-mt6765.c        |  11 +-
 drivers/pinctrl/mediatek/pinctrl-mt8183.c        |   7 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 268 ++++++++++++++++++++-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h |  16 ++
 drivers/pinctrl/mediatek/pinctrl-paris.c         | 281 +++++++++--------------
 drivers/power/supply/rt9455_charger.c            |   2 +
 drivers/regulator/core.c                         |  27 ++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                 |   2 -
 drivers/scsi/lpfc/lpfc.h                         |   1 -
 drivers/scsi/lpfc/lpfc_scsi.c                    |  13 +-
 drivers/target/target_core_configfs.c            |  12 +
 drivers/usb/gadget/composite.c                   |   6 +-
 drivers/usb/gadget/function/f_fs.c               |   2 +-
 fs/9p/vfs_file.c                                 |   2 +
 fs/9p/vfs_inode.c                                |   5 +-
 fs/9p/vfs_super.c                                |   1 +
 fs/btrfs/inode.c                                 |   2 +-
 fs/btrfs/transaction.c                           |   2 +-
 fs/gfs2/bmap.c                                   |   5 +-
 fs/nfs/client.c                                  |   5 +-
 fs/nfs/inode.c                                   |  13 +-
 fs/nfs/internal.h                                |   2 -
 fs/nfs/netns.h                                   |   2 +
 include/linux/skbuff.h                           |  15 ++
 include/linux/sunrpc/clnt.h                      |   1 +
 include/net/xfrm.h                               |   3 +
 lib/dynamic_debug.c                              |   6 +-
 net/bluetooth/l2cap_core.c                       |   3 +
 net/bluetooth/sco.c                              |   4 +
 net/bridge/br_forward.c                          |   9 +-
 net/core/net_namespace.c                         |  13 +-
 net/core/rtnetlink.c                             |   2 +-
 net/core/sock.c                                  |   4 +-
 net/ipv4/tcp.c                                   |   4 +-
 net/ipv4/tcp_input.c                             |   2 +
 net/ipv4/tcp_ipv4.c                              |   8 +-
 net/ipv4/tcp_output.c                            |   4 +-
 net/ipv4/xfrm4_input.c                           |   6 +-
 net/ipv6/fib6_rules.c                            |   6 +-
 net/ipv6/xfrm6_input.c                           |   6 +-
 net/l2tp/l2tp_eth.c                              |   3 +
 net/mac80211/ieee80211_i.h                       |   4 +-
 net/nsh/nsh.c                                    |  14 +-
 net/phonet/pn_netlink.c                          |   2 +-
 net/sunrpc/clnt.c                                |   5 +-
 net/tipc/msg.c                                   |   8 +-
 net/wireless/nl80211.c                           |   2 +
 net/wireless/trace.h                             |   2 +-
 net/xfrm/xfrm_input.c                            |   8 +
 sound/usb/line6/driver.c                         |   6 +-
 tools/power/x86/turbostat/turbostat.8            |   2 +-
 tools/power/x86/turbostat/turbostat.c            |   7 +-
 tools/testing/selftests/timers/valid-adjtimex.c  |  73 +++---
 80 files changed, 763 insertions(+), 395 deletions(-)


