Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EE424DCF6;
	Mon, 13 Apr 2026 16:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096444; cv=none; b=L4utaNRJrwb/s8fL8vnBs8MFFNP5DCwqLM117ejfMXthJBDayzzgraBi60X6ePxkFKE6ChT9ezOBzYQQM7qgYUB+V1Q2mbFXCxjhw8P1KqcjSjFzSwOeo5jMxsVYVbr6Ecs+c6m7KkNWNsSqsAu42j00r4DNraW0PcJMUqoxh5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096444; c=relaxed/simple;
	bh=1ZjeIYHbL5fjpoc5OWZDTgAnPPgacAjDdU+wwNw92Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xd+krZZbhHbjoXlfVbiV++K2JVfQflUtBfsEFvwYkWVPeCLhjE2iJ+9ivjZLvLA9z/rb9ky6nA9wXer/Em/ibdqKDO7CpD99bDCJS/QXP+a3/fLOyvqD1w2GtpEbTqWTkMwbEg/+/zJV+fa/5ksbWMxrG5Awi1en4mAM0dfudIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwJSinE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwJSinE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053BAC2BCAF;
	Mon, 13 Apr 2026 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096444;
	bh=1ZjeIYHbL5fjpoc5OWZDTgAnPPgacAjDdU+wwNw92Ls=;
	h=From:To:Cc:Subject:Date:From;
	b=GwJSinE5SHZkeekgjKo83TaUPCqh12J/AlVJZLq1ocHtcOB4EzScBMuyXPWkykVrY
	 VfMm1Kd5l8/l9jRgyydXB7g7Qr2kAavpj9gXRTn2+y8K875FlLs2jMilruLQA6Rmct
	 qh7aGmtSd2yPb5PrNPuQexn/a+9vJlhYWebbKF5I=
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
Subject: [PATCH 6.18 00/83] 6.18.23-rc1 review
Date: Mon, 13 Apr 2026 17:59:28 +0200
Message-ID: <20260413155731.019638460@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.23-rc1
X-KernelTest-Deadline: 2026-04-15T15:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.23 release.
There are 83 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.23-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.23-rc1

Jiayuan Chen <jiayuan.chen@linux.dev>
    net: skb: fix cross-cache free of KFENCE-allocated skb head

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rxrpc: proc: size address buffers for %pISpc output

Wang Jie <jiewang2024@lzu.edu.cn>
    rxrpc: only handle RESPONSE during service challenge

David Howells <dhowells@redhat.com>
    rxrpc: Fix buffer overread in rxgk_do_verify_authenticator()

David Howells <dhowells@redhat.com>
    rxrpc: Fix leak of rxgk context in rxgk_verify_response()

David Howells <dhowells@redhat.com>
    rxrpc: Fix integer overflow in rxgk_verify_response()

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing error checks for rxkad encryption/decryption failure

David Howells <dhowells@redhat.com>
    rxrpc: Fix key/keyring checks in setsockopt(RXRPC_SECURITY_KEY/KEYRING)

Luxiao Xu <rakukuip@gmail.com>
    rxrpc: fix reference count leak in rxrpc_server_keyring()

Keenan Dong <keenanat2000@gmail.com>
    rxrpc: fix oversized RESPONSE authenticator length check

Keenan Dong <keenanat2000@gmail.com>
    rxrpc: fix RESPONSE authenticator parser OOB read

Yuqi Xu <xuyuqiabc@gmail.com>
    rxrpc: reject undecryptable rxkad response tickets

Douya Le <ldy3087146292@gmail.com>
    rxrpc: Only put the call ref if one was acquired

Marc Dionne <marc.c.dionne@gmail.com>
    rxrpc: Fix to request an ack if window is limited

Anderson Nascimento <anderson@allelesecurity.com>
    rxrpc: Fix key reference count leak from call->key

Alok Tiwari <alok.a.tiwari@oracle.com>
    rxrpc: Fix rack timer warning to report unexpected mode

Alok Tiwari <alok.a.tiwari@oracle.com>
    rxrpc: Fix use of wrong skb when comparing queued RESP challenge serial

Oleh Konko <security@1seal.org>
    rxrpc: Fix RxGK token loading to check bounds

David Howells <dhowells@redhat.com>
    rxrpc: Fix call removal to use RCU safe deletion

David Howells <dhowells@redhat.com>
    rxrpc: Fix anonymous key handling

David Howells <dhowells@redhat.com>
    rxrpc: Fix key parsing memleak

David Howells <dhowells@redhat.com>
    rxrpc: Fix key quota calculation for multitoken keys

David Carlier <devnexen@gmail.com>
    net: lan966x: fix use-after-free and leak in lan966x_fdma_reload()

David Carlier <devnexen@gmail.com>
    net: lan966x: fix page pool leak in error paths

David Carlier <devnexen@gmail.com>
    net: lan966x: fix page_pool error handling in lan966x_fdma_rx_alloc_page_pool()

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: set the payload size before calling the async handler

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: improve locking around idpf_vc_xn_push_free()

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix PREEMPT_RT raw/bh spinlock nesting for async VC handling

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()

Tyllis Xu <livelycarpet87@gmail.com>
    net: stmmac: fix integer underflow in chain mode

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qualcomm: qca_uart: report the consumed byte on RX skb allocation failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix use-after-free on disconnect

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix NULL-deref on disconnect

SeongJae Park <sj@kernel.org>
    mm/damon/stat: deallocate damon_call() failure leaking damon_ctx

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails

Hao Li <hao.li@linux.dev>
    mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug

Alex Dvoretsky <advoretsky@gmail.com>
    igb: remove napi_synchronize() in igb_down()

Jacky Bai <ping.bai@nxp.com>
    pmdomain: imx8mp-blk-ctrl: Keep the NOC_HDCP clock enabled

Michael Guralnik <michaelgur@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Do not use pipe_src as borders for SU area

Sebastian Brzezinka <sebastian.brzezinka@intel.com>
    drm/i915/gt: fix refcount underflow in intel_engine_park_heartbeat

Haoze Xie <royenheart@gmail.com>
    batman-adv: hold claim backbone gateways by reference

David Carlier <devnexen@gmail.com>
    net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()

Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
    net/tls: fix use-after-free in -EBUSY error path of tls_do_encryption

Borislav Petkov (AMD) <bp@alien8.de>
    EDAC/mc: Fix error path ordering in edac_mc_alloc()

Lukas Wunner <lukas@wunner.de>
    X.509: Fix out-of-bounds access when parsing extensions

Ruide Cao <caoruide123@gmail.com>
    batman-adv: reject oversized global TT response buffers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: pn533: allocate rx skb before consuming bytes

Shawn Guo <shawnguo@kernel.org>
    arm64: dts: hisilicon: hi3798cv200: Add missing dma-ranges

Shawn Guo <shawnguo@kernel.org>
    arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: sparrow-hawk: Reserve first 128 MiB of DRAM

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    Revert "arm64: dts: imx8mq-librem5: Set the DVS voltages lower"

Heiko Stuebner <heiko@sntech.de>
    Revert "arm64: dts: rockchip: Further describe the WiFi for the Pinebook Pro"

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Handle autonomous UFS status bit

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Reset core count to 0

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: brcmsmac: Fix dma_free_coherent() size

Oleh Konko <security@1seal.org>
    tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG

Qi Tang <tpluszz77@gmail.com>
    xfrm: hold dev ref until after transport_finish NF_HOOK

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    xfrm: clear trailing padding in build_polexpire()

Nathan Chancellor <nathan@kernel.org>
    modpost: Declare extra_warn with unused attribute

Matthew Brost <matthew.brost@intel.com>
    workqueue: Add pool_workqueue to pending_pwqs list when unplugging multiple inactive works

Michal Wilczynski <m.wilczynski@samsung.com>
    firmware: thead: Fix buffer overflow and use standard endian macros

Tuan Do <tuan@calif.io>
    netfilter: nft_ct: fix use-after-free in timeout object destroy

Anthony Pighin <anthony.pighin@nokia.com>
    i2c: imx: zero-initialize dma_slave_config for eDMA

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Give up GC if MSG_PEEK intervened.

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Simplify GC state.

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Count cyclic SCC.

robbieko <robbieko@synology.com>
    btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless out labels from extent-tree.c

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Rewrite TLB uniquification for the hidden bit feature

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Suppress TLB uniquification on EHINV hardware

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Always record SEGBITS in cpu_data.vmbits

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: uinput - take event lock when submitting FF request "event"

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Input: uinput - fix circular locking dependency with ff-core

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: separate dst_cache for input and output paths in seg6 lwtunnel

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: fix slab-use-after-free in __inet_lookup_established

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    Revert "mptcp: add needs_id for netlink appending addr"

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda/realtek: Add quirk for Gigabyte Technology to fix headphone"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rfkill: prevent unlimited numbers of rfkill events from being created

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    xfrm_user: fix info leak in build_report()

Johan Hovold <johan@kernel.org>
    wifi: rt2x00usb: fix devres lifetime

Nathan Rebello <nathan.c.rebello@gmail.com>
    usb: typec: ucsi: skip connector validation before init


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../arm64/boot/dts/freescale/imx8mq-librem5-r3.dts |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi  |  24 +-
 .../boot/dts/hisilicon/hi3798cv200-poplar.dts      |   2 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   1 +
 .../boot/dts/renesas/r8a779g3-sparrow-hawk.dts     |  11 +
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |  18 --
 arch/mips/include/asm/cpu-features.h               |   1 -
 arch/mips/include/asm/cpu-info.h                   |   2 -
 arch/mips/include/asm/mipsregs.h                   |   2 +
 arch/mips/kernel/cpu-probe.c                       |  13 +-
 arch/mips/kernel/cpu-r3k-probe.c                   |   2 +
 arch/mips/mm/tlb-r4k.c                             | 285 +++++++++++++++++----
 crypto/asymmetric_keys/x509_cert_parser.c          |   8 +-
 drivers/edac/edac_mc.c                             |   6 +-
 drivers/firmware/thead,th1520-aon.c                |   7 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  30 ++-
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c   |  26 +-
 drivers/i2c/busses/i2c-imx.c                       |   2 +-
 drivers/input/misc/uinput.c                        |  35 ++-
 drivers/mmc/host/vub300.c                          |  19 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   1 +
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |  20 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |   5 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  28 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  11 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/dma.c |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   2 +-
 drivers/nfc/pn533/uart.c                           |  11 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |   2 +
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   8 +-
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c             |   8 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   3 +-
 fs/btrfs/extent-tree.c                             |  24 +-
 include/linux/firmware/thead/thead,th1520-aon.h    |  74 ------
 include/net/netfilter/nf_conntrack_timeout.h       |   1 +
 include/trace/events/rxrpc.h                       |   4 +-
 kernel/workqueue.c                                 |  14 +-
 mm/damon/stat.c                                    |   7 +
 mm/damon/sysfs.c                                   |   3 +-
 mm/filemap.c                                       |  11 +-
 mm/memory_hotplug.c                                |  20 ++
 net/batman-adv/bridge_loop_avoidance.c             |  27 +-
 net/batman-adv/translation-table.c                 |   9 +-
 net/core/skbuff.c                                  |   5 +-
 net/ipv4/xfrm4_input.c                             |   5 +-
 net/ipv6/seg6_iptunnel.c                           |  34 ++-
 net/ipv6/xfrm6_input.c                             |   5 +-
 net/mptcp/pm_kernel.c                              |  24 +-
 net/mptcp/protocol.c                               |   2 +
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |  15 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/rfkill/core.c                                  |  35 ++-
 net/rxrpc/af_rxrpc.c                               |   6 -
 net/rxrpc/ar-internal.h                            |   2 +-
 net/rxrpc/call_object.c                            |  25 +-
 net/rxrpc/conn_event.c                             |  19 +-
 net/rxrpc/input_rack.c                             |   2 +-
 net/rxrpc/io_thread.c                              |   3 +-
 net/rxrpc/key.c                                    |  40 +--
 net/rxrpc/output.c                                 |   2 +
 net/rxrpc/proc.c                                   |  37 +--
 net/rxrpc/rxgk.c                                   |  19 +-
 net/rxrpc/rxkad.c                                  |  63 +++--
 net/rxrpc/sendmsg.c                                |   2 +-
 net/rxrpc/server_key.c                             |   3 +
 net/tipc/group.c                                   |   6 +-
 net/tls/tls_sw.c                                   |  10 +
 net/unix/af_unix.c                                 |   2 +
 net/unix/af_unix.h                                 |   1 +
 net/unix/garbage.c                                 | 125 +++++----
 net/xfrm/xfrm_input.c                              |  18 +-
 net/xfrm/xfrm_user.c                               |   3 +
 scripts/mod/modpost.c                              |   2 +-
 sound/hda/codecs/realtek/alc662.c                  |   9 -
 79 files changed, 838 insertions(+), 490 deletions(-)


