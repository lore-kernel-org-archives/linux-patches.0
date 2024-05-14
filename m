Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B33D7F48C;
	Tue, 14 May 2024 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686789; cv=none; b=utB+4SuqcGaLXCT9LGaJx8YrZd2SiMKKjWIQq6I1zy+bSbg6B1LtB0c3PBIG7QBO2gAS0u0dwGcu96kOaQ3WfLvbgP21u4Se9D7IKrl0t+pt8CqXpTKmKlJrR5kNKiYMpsUKcP0qzpxRv5KffhzPGWKWPW7Ncs93EC0pCUCr5mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686789; c=relaxed/simple;
	bh=1ZsRzflD5acHvr6gzb2NV4QwJsYapE5gHfNJyROmabE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aD/YQ9VoRMJtPQJm70dFMBKZyHv+iH5bGaMjJgnrYfC0nQoB4qxXB1zRQ8NaEAUQeo5WIffqkaIRTutDIGSsWbNV3TDxNlr0oqGzH4VCizXazK0JwSHg8/r4VKinOJ9qZwcGcB/YzyM88SEubYff9UHFsJ5uZ7nRCYno9VviVNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWpt3zRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWpt3zRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79520C2BD10;
	Tue, 14 May 2024 11:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686789;
	bh=1ZsRzflD5acHvr6gzb2NV4QwJsYapE5gHfNJyROmabE=;
	h=From:To:Cc:Subject:Date:From;
	b=MWpt3zRIpIBnp7f/nIhYISpZS1yxIcAeq3zfzjqwKx5QgL6XhJ7i6cachulVa+M4f
	 ykbdiOo/C77gRYPs6D4spEj9YGK4zW39b2C7zxVdz3W9mLgsU5U5fU7NAvgdNDkEUU
	 YAhZ1cXLVzx9BT1A4TotiaPteHJ7J+LvJXAIr8+8=
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
Subject: [PATCH 4.19 00/63] 4.19.314-rc1 review
Date: Tue, 14 May 2024 12:19:21 +0200
Message-ID: <20240514100948.010148088@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.314-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.314-rc1
X-KernelTest-Deadline: 2024-05-16T10:09+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.314 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.314-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.314-rc1

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Suppress false-positive lockdep splat for spin_lock() in __unix_gc().

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

Michal Luczaj <mhal@rbox.co>
    af_unix: Fix garbage collector racing against connect()

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Do not use atomic ops for unix_sk(sk)->inflight.

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

Colin Ian King <colin.king@canonical.com>
    tcp: remove redundant check on tskb

Neil Armstrong <narmstrong@baylibre.com>
    ASoC: meson: axg-tdm-interface: Fix formatters in trigger"

Vanillan Wang <vanillanwang@163.com>
    net:usb:qmi_wwan: support Rolling modules

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: drop inodes immediately on non-.L too

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

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: mac80211: fix ieee80211_bss_*_flags kernel-doc

Andrew Price <anprice@redhat.com>
    gfs2: Fix invalid metadata access in punch_hole

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Update lpfc_ramp_down_queue_handler() logic

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

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: core: delete incorrect free in pinctrl_enable()

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    ethernet: Add helper for assigning packet type when dest address does not match device address

Jakub Kicinski <kuba@kernel.org>
    ethernet: add a helper for assigning port addresses

Li RongQing <lirongqing@baidu.com>
    net: slightly optimize eth_type_trans

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdgpu: Fix leak when GPU memory allocation fails

Eric Huang <JinhuiEric.Huang@amd.com>
    drm/amdkfd: change system memory overcommit limit

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't free NULL coalescing rule

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"

Bumyong Lee <bumyong.lee@samsung.com>
    dmaengine: pl330: issue_pending waits until WFP state


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/s390/mm/gmap.c                              |   2 +-
 arch/s390/mm/hugetlbpage.c                       |   2 +-
 drivers/ata/sata_gemini.c                        |   5 +-
 drivers/firewire/nosy.c                          |   6 +-
 drivers/firewire/ohci.c                          |   6 +-
 drivers/gpio/gpio-crystalcove.c                  |   2 +-
 drivers/gpio/gpio-wcove.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 100 +++++++++++++----------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c            |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                 |  29 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.h                 |   6 ++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c   |  16 +++-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c  |   4 +-
 drivers/net/usb/qmi_wwan.c                       |   1 +
 drivers/pinctrl/core.c                           |   8 +-
 drivers/pinctrl/devicetree.c                     |  10 ++-
 drivers/power/supply/rt9455_charger.c            |   2 +
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                 |   2 -
 drivers/scsi/lpfc/lpfc.h                         |   1 -
 drivers/scsi/lpfc/lpfc_scsi.c                    |  13 +--
 drivers/target/target_core_configfs.c            |  12 +++
 drivers/usb/gadget/composite.c                   |   6 +-
 drivers/usb/gadget/function/f_fs.c               |   2 +-
 fs/9p/vfs_file.c                                 |   2 +
 fs/9p/vfs_inode.c                                |   5 +-
 fs/9p/vfs_super.c                                |   1 +
 fs/btrfs/inode.c                                 |   2 +-
 fs/btrfs/transaction.c                           |   2 +-
 fs/gfs2/bmap.c                                   |   5 +-
 include/linux/etherdevice.h                      |  46 +++++++++++
 include/net/af_unix.h                            |   5 +-
 lib/dynamic_debug.c                              |   6 +-
 net/bluetooth/l2cap_core.c                       |   3 +
 net/bluetooth/sco.c                              |   4 +
 net/bridge/br_forward.c                          |   9 +-
 net/core/net_namespace.c                         |  13 ++-
 net/core/rtnetlink.c                             |   2 +-
 net/core/sock.c                                  |   4 +-
 net/ethernet/eth.c                               |  10 +--
 net/ipv4/tcp.c                                   |   4 +-
 net/ipv4/tcp_input.c                             |   2 +
 net/ipv4/tcp_ipv4.c                              |   8 +-
 net/ipv4/tcp_output.c                            |  11 ++-
 net/ipv6/fib6_rules.c                            |   6 +-
 net/l2tp/l2tp_eth.c                              |   3 +
 net/mac80211/ieee80211_i.h                       |   4 +-
 net/nsh/nsh.c                                    |  14 ++--
 net/phonet/pn_netlink.c                          |   2 +-
 net/tipc/msg.c                                   |   8 +-
 net/unix/af_unix.c                               |   4 +-
 net/unix/garbage.c                               |  35 +++++---
 net/unix/scm.c                                   |   8 +-
 net/wireless/nl80211.c                           |   2 +
 sound/usb/line6/driver.c                         |   6 +-
 tools/power/x86/turbostat/turbostat.8            |   2 +-
 tools/power/x86/turbostat/turbostat.c            |   7 +-
 tools/testing/selftests/timers/valid-adjtimex.c  |  73 ++++++++---------
 58 files changed, 370 insertions(+), 191 deletions(-)


