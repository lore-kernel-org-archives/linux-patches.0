Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA3433C75C;
	Wed, 17 Sep 2025 13:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114057; cv=none; b=LlsN/PDsrHANPDe0hxUVhKgOfxvELGpVoM/hU2HPOuM4hLF6vNncvRzA+XbBBV7bqplIpaZ+iSOVfmvTqVspwTag+xulF1K/HgXdMZv2ajXn3k0ciX2UwU7Me6wc6WPi4PEBDopc4uo6mmKm+HfF8q5fi0SGp9c+M85/WxpCLXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114057; c=relaxed/simple;
	bh=bqo8ajwo6tzWDZcYu0cZXQ19QYNj9gExS87H4AoDTtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nRUKPFR0XQY33AL9ml9Gaua8Ez3ytFGS+P7jEq8NVJenuq5bQS4j1rKcKYlrAoARE7u4ggXDO81LZlhmuUK4+rGbJKNh8h2xIt4ChXG8GUL938rmgk0+NfeFi6Pz2IZeEqr6wfmtddPfFLPviIVc1rozW3vk0OlNJ/HKMR9d4Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYSsjdww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYSsjdww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27785C4CEF7;
	Wed, 17 Sep 2025 13:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114056;
	bh=bqo8ajwo6tzWDZcYu0cZXQ19QYNj9gExS87H4AoDTtE=;
	h=From:To:Cc:Subject:Date:From;
	b=fYSsjdwwusUrj7pI/UnyjxRyUrQUCJpY6gTHQYVVRTX0jc5RLrETOvs+uvxvblebh
	 BO58u338d51e6KPGE/SIkQHw0ai7LZ/S6OdCn0vPNKFPdsjks0UYQncKp1sFTRUp+g
	 BcgZ8YXcscCBkd3XPi8wgOg7UEmNNwz+3EHo+qbI=
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
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.1 00/78] 6.1.153-rc1 review
Date: Wed, 17 Sep 2025 14:34:21 +0200
Message-ID: <20250917123329.576087662@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.153-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.153-rc1
X-KernelTest-Deadline: 2025-09-19T12:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.153 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.153-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.153-rc1

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Deal with zero e_shentsize

Dan Carpenter <dan.carpenter@linaro.org>
    soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/power: fix size for for_each_set_bit() in abox iteration

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix a memory leak in fence cleanup when unloading

Johan Hovold <johan@kernel.org>
    phy: ti-pipe3: fix device leak at unbind

Johan Hovold <johan@kernel.org>
    phy: tegra: xusb: fix device and OF node leak at probe

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: dw: dmamux: Fix device reference leak in rzn1_dmamux_route_allocate

Stephan Gerhold <stephan.gerhold@linaro.org>
    dmaengine: qcom: bam_dma: Fix DT error handling for num-channels/ees

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hrtimers: Unconditionally update target CPU base after offline timer migration

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    hrtimer: Rename __hrtimer_hres_active() to hrtimer_hres_active()

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    hrtimer: Remove unused function

Andreas Kemnade <akemnade@kernel.org>
    regulator: sy7636a: fix lifecycle of power good gpio

Anders Roxell <anders.roxell@linaro.org>
    dmaengine: ti: edma: Fix memory allocation size for queue_priority_map

Dan Carpenter <dan.carpenter@linaro.org>
    dmaengine: idxd: Fix double free in idxd_setup_wqs()

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use hsr_for_each_port_rtnl in hsr_port_get_hsr

Hangbin Liu <liuhangbin@gmail.com>
    hsr: use rtnl lock when iterating over ports

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add VLAN CTAG filter support

Murali Karicheri <m-karicheri2@ti.com>
    net: hsr: Add support for MC filtering at the slave device

Ravi Gunasekaran <r-gunasekaran@ti.com>
    net: hsr: Disable promiscuous mode in offload mode

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: xilinx_can: xcan_write_frame(): fix use-after-free of transmitted SKB

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_local_ecu_get(): undo increment when j1939_local_ecu_get() fails

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: j1939_sk_bind(): call j1939_priv_put() immediately when j1939_local_ecu_get() failed

Michal Schmidt <mschmidt@redhat.com>
    i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path

Kohei Enju <enjuk@amazon.com>
    igb: fix link test skipping when interface is admin down

Alex Tran <alex.t.tran@gmail.com>
    docs: networking: can: change bcm_msg_head frames member to support flexible array

Antoine Tenart <atenart@kernel.org>
    tunnels: reset the GSO metadata before reusing the skb

Stefan Wahren <wahrenst@gmx.net>
    net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion LE910C4-WWX new compositions

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A w/audio compositions

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in flow control levels init

Fabian Vogt <fvogt@suse.de>
    tty: hvc_console: Call hvc_kick in hvc_write unconditionally

Paolo Abeni <pabeni@redhat.com>
    Revert "net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups"

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - avoid enabling unused interrupts

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory-failure: fix VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory

Chen Ridong <chenridong@huawei.com>
    kernfs: Fix UAF in polling when open file is released

Wei Yang <richard.weiyang@gmail.com>
    mm/khugepaged: fix the address passed to notifier on testing young

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    mm/khugepaged: convert hpage_collapse_scan_pmd() to use folios

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    mtd: nand: raw: atmel: Respect tAR, tCLR in read setup timing

Alexander Dahl <ada@thorsis.com>
    mtd: nand: raw: atmel: Fix comment in timings preparation

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/lru_sort: avoid divide-by-zero in damon_lru_sort_apply_parameters()

Quanmin Yan <yanquanmin1@huawei.com>
    mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()

Stanislav Fort <stanislav.fort@aisle.com>
    mm/damon/sysfs: fix use-after-free in state_show()

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix invalid accesses to ceph_connection_v1_info

Miklos Szeredi <mszeredi@redhat.com>
    fuse: prevent overflow in copy_file_range return value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: check if copy_file_range() returns larger than requested size

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: fix ECC overwrite

Christophe Kerello <christophe.kerello@foss.st.com>
    mtd: rawnand: stm32_fmc2: avoid overlapping mappings on ECC buffer

Oleksij Rempel <linux@rempel-privat.de>
    net: usb: asix: ax88772: drop phylink use in PM to avoid MDIO runtime PM wakeups

Mark Tinguely <mark.tinguely@oracle.com>
    ocfs2: fix recursive semaphore deadlock in fiemap call

Krister Johansen <kjlx@templeofstupid.com>
    mptcp: sockopt: make sync_socket_options propagate SOCK_KEEPOPEN

Nathan Chancellor <nathan@kernel.org>
    compiler-clang.h: define __SANITIZE_*__ macros only when undefined

Trond Myklebust <trond.myklebust@hammerspace.com>
    Revert "SUNRPC: Don't allow waiting for exiting tasks"

Salah Triki <salah.triki@gmail.com>
    EDAC/altera: Delete an inappropriate dma_free_coherent() call

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Set synthesized TSA CPUID flags

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    KVM: SVM: Return TSA_SQ_NO and TSA_L1_NO bits in __do_cpuid_func()

Kim Phillips <kim.phillips@amd.com>
    KVM: x86: Move open-coded CPUID leaf 0x80000021 EAX bit propagation code

wangzijie <wangzijie1@honor.com>
    proc: fix type confusion in pde_set_flags()

Kuniyuki Iwashima <kuniyu@google.com>
    tcp_bpf: Call sk_msg_free() when tcp_bpf_send_verdict() fails to allocate psock->cork.

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Deny all sampling events by counter PMU

Pu Lehui <pulehui@huawei.com>
    tracing: Silence warning when chunk allocation fails in trace_pid_write

Jonathan Curley <jcurley@purestorage.com>
    NFSv4/flexfiles: Fix layout merge mirror check.

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    ftrace/samples: Fix function size computation

Luo Gengkun <luogengkun@huaweicloud.com>
    tracing: Fix tracing_marker may trigger page fault during preempt_disable

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_XATTR flag if not supported by the server

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Clear the NFS_CAP_FS_LOCATIONS flag if it is not set

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't clear capabilities that won't be reset

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    flexfiles/pNFS: fix NULL checks on result of ff_layout_choose_ds_for_read

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not add length to print format in synthetic events

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix null-ptr-deref by sock_lock_init_class_and_name() and rmmod.

André Apitzsch <git@apitzsch.eu>
    media: i2c: imx214: Fix link frequency validation

Arnd Bergmann <arnd@arndb.de>
    media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization

Harry Yoo <harry.yoo@oracle.com>
    mm: introduce and use {pgd,p4d}_populate_kernel()

Yeoreum Yun <yeoreum.yun@arm.com>
    kunit: kasan_test: disable fortify string checker on kasan_strings() test


-------------

Diffstat:

 .../bindings/serial/brcm,bcm7271-uart.yaml         |   2 +-
 Documentation/networking/can.rst                   |   2 +-
 Makefile                                           |   4 +-
 arch/s390/kernel/perf_cpum_cf.c                    |   4 +-
 arch/x86/kvm/cpuid.c                               |  33 +++--
 drivers/dma/dw/rzn1-dmamux.c                       |  15 +-
 drivers/dma/idxd/init.c                            |  33 +++--
 drivers/dma/qcom/bam_dma.c                         |   8 +-
 drivers/dma/ti/edma.c                              |   4 +-
 drivers/edac/altera_edac.c                         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   3 -
 drivers/gpu/drm/i915/display/intel_display_power.c |   6 +-
 drivers/input/misc/iqs7222.c                       |   3 +
 drivers/input/serio/i8042-acpipnpio.h              |  14 ++
 drivers/media/i2c/imx214.c                         |  27 +++-
 .../platform/mediatek/vcodec/mtk_vcodec_fw_scp.c   |   4 +-
 .../platform/mediatek/vcodec/venc/venc_h264_if.c   |   6 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |  18 ++-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  46 +++---
 drivers/net/can/xilinx_can.c                       |  16 +-
 drivers/net/ethernet/freescale/fec_main.c          |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   5 +-
 drivers/phy/tegra/xusb-tegra210.c                  |   6 +-
 drivers/phy/ti/phy-ti-pipe3.c                      |  13 ++
 drivers/regulator/sy7636a-regulator.c              |   7 +-
 drivers/soc/qcom/mdt_loader.c                      |  14 +-
 drivers/tty/hvc/hvc_console.c                      |   6 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   8 +-
 drivers/usb/serial/option.c                        |  17 +++
 fs/fuse/file.c                                     |   5 +-
 fs/kernfs/file.c                                   |  54 ++++---
 fs/nfs/client.c                                    |   2 +
 fs/nfs/flexfilelayout/flexfilelayout.c             |  21 ++-
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/ocfs2/extent_map.c                              |  10 +-
 fs/proc/generic.c                                  |   3 +-
 include/linux/compiler-clang.h                     |  31 +++-
 include/linux/pgalloc.h                            |  29 ++++
 include/linux/pgtable.h                            |  13 +-
 include/net/sock.h                                 |  40 ++++-
 kernel/time/hrtimer.c                              |  50 ++-----
 kernel/trace/trace.c                               |  10 +-
 kernel/trace/trace_events_synth.c                  |   2 -
 mm/damon/lru_sort.c                                |   3 +
 mm/damon/reclaim.c                                 |   3 +
 mm/damon/sysfs.c                                   |  14 +-
 mm/kasan/init.c                                    |  12 +-
 mm/kasan/kasan_test.c                              |   1 +
 mm/khugepaged.c                                    |  22 +--
 mm/memory-failure.c                                |   7 +-
 mm/percpu.c                                        |   6 +-
 mm/sparse-vmemmap.c                                |   6 +-
 net/can/j1939/bus.c                                |   5 +-
 net/can/j1939/socket.c                             |   3 +
 net/ceph/messenger.c                               |   7 +-
 net/core/sock.c                                    |   5 +
 net/hsr/hsr_device.c                               | 163 ++++++++++++++++++++-
 net/hsr/hsr_main.c                                 |   4 +-
 net/hsr/hsr_main.h                                 |   4 +
 net/hsr/hsr_slave.c                                |  15 +-
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/tcp_bpf.c                                 |   5 +-
 net/mptcp/sockopt.c                                |  11 +-
 net/sunrpc/sched.c                                 |   2 -
 samples/ftrace/ftrace-direct-modify.c              |   2 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |  28 +++-
 68 files changed, 669 insertions(+), 285 deletions(-)


