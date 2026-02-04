Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E3541B346;
	Wed,  4 Feb 2026 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218650; cv=none; b=dJpvcbwhCOWWVwi1nWmu54Ov2si8+dzZPKxkv/6lhI6ylFDQGXEt3+09oCqRbrramGOxpAEIAqP+9T1stW+wfluQ25bivzZofH5+xJUDd39nZ6iwAl2kJ5b3pVOtDw+O6K41XQIKYGsJJ53qGsGFWheiPBdAODGtX3UIyAL55Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218650; c=relaxed/simple;
	bh=+p//Sbq2HsqXswlzjdW/YkdbmNegAQKPNqzXkiJrHFM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nf2c3FP/OyEAAPui5nmHFn87ZccIw56CRnmHBt0i19tc8hywp2zzwoMja76BGlFfuThQ/5vMPVp0wBwPRgF4ZgL/PaEM8wPKCIHZHxm3ZBYgurne4GZ1tvQUMwVFX6QlLaDlj71Zin7XspHXStHCfWMzhaeKZK2ybk7mQ5II0mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQddx68/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQddx68/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFECC4CEF7;
	Wed,  4 Feb 2026 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218650;
	bh=+p//Sbq2HsqXswlzjdW/YkdbmNegAQKPNqzXkiJrHFM=;
	h=From:To:Cc:Subject:Date:From;
	b=rQddx68/nQ/YxanxApWbVZrJ22y4U6mdfZE2z2nqZke3Sb3R1Pi6DOaj1tqa3eAGt
	 10CMtXB7mpkus/8PujZWZHP0EvwIaORF/Fs0PE0BFW6lofe2FlcrPq1VmEUbUInS0A
	 UhDLuJ9yycFLEe+7aDvr2XBoNcgbkFSbrQhXOKXE=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 00/87] 6.12.69-rc1 review
Date: Wed,  4 Feb 2026 15:39:58 +0100
Message-ID: <20260204143846.906385641@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.69-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.69-rc1
X-KernelTest-Deadline: 2026-02-06T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.69 release.
There are 87 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.69-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.69-rc1

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    bpf/selftests: test_select_reuseport_kern: Remove unused header

Long Li <longli@microsoft.com>
    RDMA/mana_ib: Handle net event for pointing to the current netdev

Long Li <longli@microsoft.com>
    net: mana: Change the function signature of mana_get_primary_netdev_rcu

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: lpass-lpi: implement .get_direction() for the GPIO driver

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: adjust KGQ reset sequence

Laveesh Bansal <laveeshb@laveeshbansal.com>
    writeback: fix 100% CPU usage when dirtytime_expire_interval is 0

Steven Rostedt <rostedt@goodmis.org>
    perf: sched: Fix perf crash with new is_user_task() helper

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Simplify get_perf_callchain() user logic

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid dup SUB_CLOSED events after disconnect

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    pinctrl: qcom: sm8350-lpass-lpi: Merge with SC7280 to fix I2S2 and SWR TX pins

Chen Ni <nichen@iscas.ac.cn>
    net/sched: act_ife: convert comma to semicolon

JP Kobryn <inwardvessel@gmail.com>
    btrfs: prevent use-after-free on folio private data in btrfs_subpage_clear_uptodate()

John Ogness <john.ogness@linutronix.de>
    Revert "drm/nouveau/disp: Set drm_mode_config_funcs.atomic_(check|commit)"

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath11k: add srng->lock for ath11k_hal_srng_* in monitor mode

Pimyn Girgis <pimyn@google.com>
    mm/kfence: randomize the freelist on initialization

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    libbpf: Fix -Wdiscarded-qualifiers under C23

Thomas Fourier <fourier.thomas@gmail.com>
    ksmbd: smbd: fix dma_unmap_sg() nents

David Howells <dhowells@redhat.com>
    rxrpc: Fix data-race warning and potential load/store tearing

T.J. Mercier <tjmercier@google.com>
    cgroup: Fix kernfs_node UAF in css_free_rwork_fn

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: support `-Cjump-tables=n` for Rust 1.93.0

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: acpi: Fix potential out-of-boundary left shift

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Fix cond_exec handling in amdgpu_ib_schedule()

Jon Doron <jond@wiz.io>
    drm/amdgpu: fix NULL pointer dereference in amdgpu_gmc_filter_faults_remove

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx12: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc21: fix xclk for APUs

Johan Hovold <johan@kernel.org>
    drm/imx/tve: fix probe device leak

Johan Hovold <johan@kernel.org>
    drm/msm/a6xx: fix bogus hwcg register updates

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer: Add compiler_builtins -> core dep

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer: compile sysroot with correct edition

Onur Özkan <work@onurozkan.dev>
    scripts: generate_rust_analyzer: remove sysroot assertion

Jibin Zhang <jibin.zhang@mediatek.com>
    net: fix segmentation of forwarding fraglist GRO

Kairui Song <kasong@tencent.com>
    mm/shmem, swap: fix race of truncate and swap entry split

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: teach kill_accessing_process to accept hugetlb tail page pfn

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: fix missing ->mf_stats count in hugetlb poison

Jan Kara <jack@suse.cz>
    flex_proportions: make fprop_new_period() hardirq safe

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: fix local endp not being tracked

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: check subflow errors in close events

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: check no dup close events after error

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: only reset subflow errors when propagated

Andrey Ryabinin <ryabinin.a.a@gmail.com>
    mm/kasan: fix KASAN poisoning in vrealloc()

Robin Murphy <robin.murphy@arm.com>
    gpio: rockchip: Stop calling pinctrl for set_direction

Ming Lei <ming.lei@redhat.com>
    nvmet: fix race in nvmet_bio_done() leading to NULL pointer dereference

Kohei Enju <kohei@enjuk.jp>
    efivarfs: fix error propagation in efivar_entry_get()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla2xxx: edif: Fix dma_free_coherent() size

Martin Larsson <martin.larsson@actia.se>
    gpio: pca953x: mask interrupts in irq shutdown

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for Acer TravelMate P216-41-TCO

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    scsi: be2iscsi: Fix a memory leak in beiscsi_boot_get_sinfo()

Fabio Estevam <festevam@gmail.com>
    ASoC: fsl: imx-card: Do not force slot width to sample width

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: give `--config-path` to `rustfmt` in `.rsi` target

Hang Shu <m18080292938@163.com>
    rust: rbtree: fix documentation typo in CursorMut peek_next method

Han Gao <gaohan@iscas.ac.cn>
    riscv: compat: fix COMPAT_UTS_MACHINE definition

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: meson: mark the GPIO controller as sleeping

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Fix 'stuck' dl_server

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Document dl_server

Sai Sree Kartheek Adivi <s-adivi@ti.com>
    dma/pool: distinguish between missing and exhausted atomic pools

Shida Zhang <zhangshida@kylinos.cn>
    bcache: fix I/O accounting leak in detached_dev_do_request

Shida Zhang <zhangshida@kylinos.cn>
    bcache: use bio cloning for detached device requests

Shida Zhang <zhangshida@kylinos.cn>
    bcache: fix improper use of bi_end_io

Yuhao Huang <nekowong743@gmail.com>
    gpio: virtuser: fix UAF in configfs release path

Denis Sergeev <denserg.edu@gmail.com>
    gpiolib: acpi: use BIT_ULL() for u64 mask in address space handler

Tagir Garaev <tgaraev653@gmail.com>
    ASoC: Intel: sof_es8336: fix headphone GPIO logic inversion

Kery Qi <qikeyu2017@gmail.com>
    scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Skip ESN replay window setup for IPsec crypto offload

Parav Pandit <parav@nvidia.com>
    net/mlx5: Fix vhca_id access call trace use before alloc

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Initialize events outside devlink lock

Shay Drory <shayd@nvidia.com>
    net/mlx5: fs, Fix inverted cap check in tx flow table root disconnect

Wei Fang <wei.fang@nxp.com>
    net: phy: micrel: fix clk warning when removing the driver

Martin Kaiser <martin@kaiser.cx>
    net: bridge: fix static key check

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: nci: Fix race between rfkill and nci_unregister_device().

Mark Bloch <mbloch@nvidia.com>
    net/mlx5e: TC, delete flows only for existing peers

Jesse Brandeburg <jbrandeburg@cloudflare.com>
    ice: stop counting UDP csum mismatch as rx_errors

Aaron Ma <aaron.ma@canonical.com>
    ice: Fix NULL pointer dereference in ice_vsi_set_napi_queues

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: llcp: Fix memleak in nfc_llcp_send_ui_frame().

Kery Qi <qikeyu2017@gmail.com>
    rocker: fix memory leak in rocker_world_port_post_fini()

Kery Qi <qikeyu2017@gmail.com>
    net: wwan: t7xx: fix potential skb->frags overflow in RX path

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: use the right ifindex when replying to icmpv6 from localhost

Zilin Guan <zilin@seu.edu.cn>
    net: mvpp2: cls: Fix memory leak in mvpp2_ethtool_cls_rule_ins()

Eric Dumazet <edumazet@google.com>
    bonding: annotate data-races around slave->last_rx

Zilin Guan <zilin@seu.edu.cn>
    octeon_ep: Fix memory leak in octep_device_setup()

Justin Chen <justin.chen@broadcom.com>
    net: bcmasp: fix early exit leak with fixed phy

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): fix error message

Zilin Guan <zilin@seu.edu.cn>
    net/mlx5: Fix memory leak in esw_acl_ingress_lgcy_setup()

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    Bluetooth: MGMT: Fix memory leak in set_ssp_complete

Jia-Hong Su <s11242586@gmail.com>
    Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work

Zilin Guan <zilin@seu.edu.cn>
    can: at91_can: Fix memory leak in at91_can_probe()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/configs/defconfig                       |   1 -
 arch/riscv/include/asm/compat.h                    |   2 +-
 arch/x86/Makefile                                  |   2 +-
 drivers/bluetooth/hci_ldisc.c                      |   4 +-
 drivers/gpio/gpio-pca953x.c                        |   2 +
 drivers/gpio/gpio-rockchip.c                       |   8 -
 drivers/gpio/gpio-virtuser.c                       |   8 +-
 drivers/gpio/gpiolib-acpi-core.c                   |  21 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  47 ++---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   8 +-
 drivers/gpu/drm/imx/ipuv3/imx-tve.c                |  13 ++
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |   2 -
 drivers/gpu/drm/nouveau/nouveau_display.c          |   2 -
 drivers/infiniband/hw/mana/device.c                |  54 +++++-
 drivers/infiniband/hw/mana/mana_ib.h               |   2 +
 drivers/md/bcache/bcache.h                         |   9 +
 drivers/md/bcache/request.c                        |  82 ++++----
 drivers/md/bcache/super.c                          |  12 +-
 drivers/net/bonding/bond_main.c                    |  18 +-
 drivers/net/bonding/bond_options.c                 |   8 +-
 drivers/net/can/at91_can.c                         |   2 +-
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   5 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   1 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  16 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  36 ++--
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 +
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  22 ++-
 drivers/net/ethernet/rocker/rocker_main.c          |   5 +-
 drivers/net/phy/micrel.c                           |  17 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  10 +-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |   9 +-
 drivers/nvme/target/io-cmd-bdev.c                  |   3 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   9 +-
 drivers/pinctrl/qcom/Kconfig                       |  15 +-
 drivers/pinctrl/qcom/Makefile                      |   1 -
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |  17 ++
 drivers/pinctrl/qcom/pinctrl-sc7280-lpass-lpi.c    |   3 +
 drivers/pinctrl/qcom/pinctrl-sm8350-lpass-lpi.c    | 151 ---------------
 drivers/scsi/be2iscsi/be_mgmt.c                    |   1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/target/sbp/sbp_target.c                    |   4 +-
 fs/btrfs/relocation.c                              |  14 ++
 fs/efivarfs/vars.c                                 |   2 +-
 fs/fs-writeback.c                                  |  14 +-
 fs/smb/server/transport_rdma.c                     |  15 +-
 include/linux/kasan.h                              |  14 ++
 include/linux/sched.h                              |   5 +
 include/net/bonding.h                              |  13 +-
 include/net/mana/mana.h                            |   4 +-
 include/net/nfc/nfc.h                              |   2 +
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/dma/pool.c                                  |   7 +-
 kernel/events/callchain.c                          |  20 +-
 kernel/events/core.c                               |   6 +-
 kernel/sched/deadline.c                            | 206 +++++++++++++++++++++
 lib/flex_proportions.c                             |   5 +-
 mm/kasan/common.c                                  |  21 +++
 mm/kfence/core.c                                   |  23 ++-
 mm/memory-failure.c                                |  99 ++++++----
 mm/shmem.c                                         |  45 +++--
 mm/vmalloc.c                                       |   7 +-
 net/bluetooth/mgmt.c                               |   3 +
 net/bridge/br_input.c                              |   2 +-
 net/core/filter.c                                  |   2 +
 net/ipv4/tcp_offload.c                             |   3 +-
 net/ipv4/udp_offload.c                             |   3 +-
 net/ipv6/icmp.c                                    |   4 +-
 net/ipv6/tcpv6_offload.c                           |   3 +-
 net/mptcp/protocol.c                               |  13 +-
 net/nfc/core.c                                     |  27 ++-
 net/nfc/llcp_commands.c                            |  17 +-
 net/nfc/llcp_core.c                                |   4 +-
 net/nfc/nci/core.c                                 |   4 +-
 net/rxrpc/ar-internal.h                            |   9 +-
 net/rxrpc/conn_event.c                             |   2 +-
 net/rxrpc/output.c                                 |  10 +-
 net/rxrpc/peer_event.c                             |  17 +-
 net/rxrpc/proc.c                                   |   4 +-
 net/rxrpc/rxkad.c                                  |   4 +-
 net/sched/act_ife.c                                |   6 +-
 rust/kernel/rbtree.rs                              |   2 +-
 scripts/Makefile.build                             |   2 +-
 scripts/generate_rust_analyzer.py                  |  34 +++-
 sound/soc/amd/yc/acp6x-mach.c                      |   8 +
 sound/soc/fsl/imx-card.c                           |   1 -
 sound/soc/intel/boards/sof_es8336.c                |   2 +-
 tools/lib/bpf/libbpf.c                             |   4 +-
 .../bpf/progs/test_select_reuseport_kern.c         |   1 -
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  81 +++++++-
 104 files changed, 1001 insertions(+), 498 deletions(-)


