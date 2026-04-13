Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518A8274B58;
	Mon, 13 Apr 2026 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096679; cv=none; b=nXeWrQRRvuprNoZzsxw+EBKnMxb+WtLpq0V+e93rdHDK6zVJnvbyJ9WZkFAa8UA8iC8rvQ8UgtIsh0jXxGJmzBJD8lQHgbLBANILGM6fCtHVqWtrNTE5C8I7Oap0/t1Npdo8MTGIYPSVOP5BMVCjUa5gQCVyklGTQkPgt3NeAvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096679; c=relaxed/simple;
	bh=kUtavRGZidtGQsDYSwg0yZ18GPcChn9vIDkG2eZDWcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gISPmCXF42FfnkZ/gFT4hWIQC4csmUMrjI8L9vEio5hS9/QZqxy7Yev/5iuIoUvHnXT2U7EIZTt7kCFCcWPv3Qk6PYOF4MXqfYPc6t4ewvgGanJAqMCMfc7OV27cEPsB5qEtFbTHFdy/MGz2lq/kThRo6o5bARwO2W3gXNt9O7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2I29sxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2I29sxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45DDC2BCAF;
	Mon, 13 Apr 2026 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096679;
	bh=kUtavRGZidtGQsDYSwg0yZ18GPcChn9vIDkG2eZDWcA=;
	h=From:To:Cc:Subject:Date:From;
	b=x2I29sxks4+WFWe6eT6PE7mAZvKcP8HzLIRuD44pWQl1VI8zt30mIsHGPoLvF9v79
	 Bf8H+PneIxsG97nenQ91gb6YZ5hNHyDi/0sbeD3VsEUhzdkp5M9sSNJiRP6v/rsCEZ
	 xTn8OTqxVTJGgIFm6pJWnt69rpauZfjS7q9viPXM=
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
Subject: [PATCH 6.12 00/70] 6.12.82-rc1 review
Date: Mon, 13 Apr 2026 17:59:55 +0200
Message-ID: <20260413155728.181580293@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.82-rc1
X-KernelTest-Deadline: 2026-04-15T15:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.82 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.82-rc1

Aaron Erhardt <aer@tuxedocomputers.com>
    ALSA: hda/hdmi: Add quirk for TUXEDO IBS14G6

Jiayuan Chen <jiayuan.chen@linux.dev>
    net: skb: fix cross-cache free of KFENCE-allocated skb head

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing error checks for rxkad encryption/decryption failure

David Howells <dhowells@redhat.com>
    rxrpc: Fix key/keyring checks in setsockopt(RXRPC_SECURITY_KEY/KEYRING)

Luxiao Xu <rakukuip@gmail.com>
    rxrpc: fix reference count leak in rxrpc_server_keyring()

Yuqi Xu <xuyuqiabc@gmail.com>
    rxrpc: reject undecryptable rxkad response tickets

Douya Le <ldy3087146292@gmail.com>
    rxrpc: Only put the call ref if one was acquired

Anderson Nascimento <anderson@allelesecurity.com>
    rxrpc: Fix key reference count leak from call->key

David Howells <dhowells@redhat.com>
    rxrpc: Fix call removal to use RCU safe deletion

David Howells <dhowells@redhat.com>
    rxrpc: Fix anonymous key handling

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

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()

Tyllis Xu <livelycarpet87@gmail.com>
    net: stmmac: fix integer underflow in chain mode

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qualcomm: qca_uart: report the consumed byte on RX skb allocation failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix NULL-deref on disconnect

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

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq-librem5: Bump BUCK1 suspend voltage up to 0.85V

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    Revert "arm64: dts: imx8mq-librem5: Set the DVS voltages lower"

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Handle autonomous UFS status bit

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: brcmsmac: Fix dma_free_coherent() size

Oleh Konko <security@1seal.org>
    tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    xfrm: clear trailing padding in build_polexpire()

Matthew Brost <matthew.brost@intel.com>
    workqueue: Add pool_workqueue to pending_pwqs list when unplugging multiple inactive works

Tuan Do <tuan@calif.io>
    netfilter: nft_ct: fix use-after-free in timeout object destroy

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Handle percpu handler address for ORC unwinder

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Remove unnecessary checks for ORC unwinder

Li Xiasong <lixiasong1@huawei.com>
    mptcp: fix soft lockup in mptcp_recvmsg()

Eric Dumazet <edumazet@google.com>
    net: annotate data-races around sk->sk_{data_ready,write_space}

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    Revert "mptcp: add needs_id for netlink appending addr"

Andrea Righi <arighi@nvidia.com>
    sched_ext: Fix stale direct dispatch state in ddsp_dsq_id

Xingjing Deng <micro6947@gmail.com>
    misc: fastrpc: check qcom_scm_assign_mem() return in rpmsg_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: white-hawk-cpu-common: Add pin control for DSI-eDP IRQ

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: complete pending data exchange on device close

Chaitanya Kulkarni <kch@nvidia.com>
    blktrace: fix __this_cpu_read/write in preemptible context

robbieko <robbieko@synology.com>
    btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless out labels from extent-tree.c

Daniel Vacek <neelx@suse.com>
    btrfs: remove unused flag EXTENT_BUFFER_CORRUPT

Daniel Vacek <neelx@suse.com>
    btrfs: remove unused flag EXTENT_BUFFER_READAHEAD

David Sterba <dsterba@suse.com>
    btrfs: split waiting from read_extent_buffer_pages(), drop parameter wait

David Sterba <dsterba@suse.com>
    btrfs: remove unused define WAIT_PAGE_LOCK for extent io

David Sterba <dsterba@suse.com>
    btrfs: make wait_on_extent_buffer_writeback() static inline

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: simple-card-utils: Don't use __free(device_node) at graph_util_parse_dai()

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

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rfkill: prevent unlimited numbers of rfkill events from being created

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    xfrm_user: fix info leak in build_report()

Johan Hovold <johan@kernel.org>
    wifi: rt2x00usb: fix devres lifetime

Nathan Rebello <nathan.c.rebello@gmail.com>
    usb: typec: ucsi: skip connector validation before init

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: chacha: Zeroize permuted_state before it leaves scope


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../arm64/boot/dts/freescale/imx8mq-librem5-r3.dts |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq-librem5.dtsi  |  24 +-
 .../boot/dts/hisilicon/hi3798cv200-poplar.dts      |   2 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   1 +
 .../boot/dts/renesas/white-hawk-cpu-common.dtsi    |   8 +
 arch/loongarch/include/asm/setup.h                 |   3 +
 arch/loongarch/kernel/unwind_orc.c                 |  28 +-
 arch/mips/include/asm/cpu-features.h               |   1 -
 arch/mips/include/asm/cpu-info.h                   |   2 -
 arch/mips/include/asm/mipsregs.h                   |   2 +
 arch/mips/kernel/cpu-probe.c                       |  13 +-
 arch/mips/kernel/cpu-r3k-probe.c                   |   2 +
 arch/mips/mm/tlb-r4k.c                             | 285 +++++++++++++++++----
 crypto/asymmetric_keys/x509_cert_parser.c          |   8 +-
 drivers/edac/edac_mc.c                             |   6 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  30 ++-
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c   |  26 +-
 drivers/input/misc/uinput.c                        |  35 ++-
 drivers/misc/fastrpc.c                             |   4 +-
 drivers/mmc/host/vub300.c                          |   2 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   1 +
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |  28 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  11 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/dma.c |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   2 +-
 drivers/nfc/pn533/uart.c                           |  11 +-
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   8 +-
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c             |   8 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   3 +-
 fs/btrfs/disk-io.c                                 |  13 +-
 fs/btrfs/extent-tree.c                             |  30 +--
 fs/btrfs/extent_io.c                               |  33 +--
 fs/btrfs/extent_io.h                               |  18 +-
 include/net/netfilter/nf_conntrack_timeout.h       |   1 +
 include/trace/events/rxrpc.h                       |   2 +-
 kernel/sched/ext.c                                 |  48 +++-
 kernel/trace/blktrace.c                            |   4 +-
 kernel/workqueue.c                                 |  14 +-
 lib/crypto/chacha.c                                |   4 +
 mm/filemap.c                                       |  11 +-
 net/batman-adv/bridge_loop_avoidance.c             |  27 +-
 net/batman-adv/translation-table.c                 |   9 +-
 net/core/skbuff.c                                  |   5 +-
 net/core/skmsg.c                                   |  14 +-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv4/tcp_input.c                               |  14 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/udp.c                                     |   3 +-
 net/ipv4/udp_bpf.c                                 |   2 +-
 net/ipv6/seg6_iptunnel.c                           |  34 ++-
 net/mptcp/pm_netlink.c                             |  24 +-
 net/mptcp/protocol.c                               |  13 +-
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |  15 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/nfc/nci/core.c                                 |   9 +
 net/rfkill/core.c                                  |  35 ++-
 net/rxrpc/af_rxrpc.c                               |   6 -
 net/rxrpc/call_object.c                            |  25 +-
 net/rxrpc/io_thread.c                              |   3 +-
 net/rxrpc/key.c                                    |   2 +-
 net/rxrpc/rxkad.c                                  |  63 +++--
 net/rxrpc/sendmsg.c                                |   2 +-
 net/rxrpc/server_key.c                             |   3 +
 net/tipc/group.c                                   |   6 +-
 net/tls/tls_sw.c                                   |  10 +
 net/unix/af_unix.c                                 |   8 +-
 net/xfrm/xfrm_user.c                               |   3 +
 sound/pci/hda/patch_hdmi.c                         |   1 +
 sound/soc/generic/simple-card-utils.c              |   7 +-
 75 files changed, 742 insertions(+), 361 deletions(-)


