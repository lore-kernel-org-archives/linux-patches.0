Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F9E40B6FF;
	Wed,  4 Feb 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218371; cv=none; b=qX7wudag4M1cC0ZMAm3gk1hpApNyjGoZbh/EtsNei+Z87TzCcR1YBe9tMXVor8Stz7kx1iYLzTgon0qFv3b5ELEjqLmyRDqY6Aaglq9Jpkx91QbG6Pzs2iLAPhYlMxz2CLZY+YBLeHybVbdoSwZnoH3CYyL2S4wXpCbvDrhGm5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218371; c=relaxed/simple;
	bh=ecYu3z9wViLfOWMMfq5E58Xbpr+EuHkyp21EtPUWaO0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J38q+1LRIk/dRpvPL1BOsPzaNeZ9R/HRCM61gLQFkmIoqNH4friEY5zH74Ym1a5i+cM+GUKAXVTLhHpsjpojUC726B01aR+x/f6oQB0Ndy9e/vhEvVR8y2TwBiKEq3LlaK6usRzun+7nH1JZrPP2ejVSc8J6v3M63RQB8z2QF/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi4+4P2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi4+4P2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB2EC4CEF7;
	Wed,  4 Feb 2026 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218371;
	bh=ecYu3z9wViLfOWMMfq5E58Xbpr+EuHkyp21EtPUWaO0=;
	h=From:To:Cc:Subject:Date:From;
	b=pi4+4P2pxNGszgFv8b+J5D2Pg6eqkknfcoIE6FYWHs3+KXgI2JMEbztNFPapqs6Fm
	 cAn+t9nv59ogH95FYL3nMY81+08JHrqm2oTFoIIMMre0qSrdhZgmP3PgdSefPgAotU
	 Csk5vsOP9gBoL5BO4pVj4udqxQVMfaDWnSaX06xk=
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
Subject: [PATCH 6.6 00/72] 6.6.123-rc1 review
Date: Wed,  4 Feb 2026 15:40:03 +0100
Message-ID: <20260204143845.603454952@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.123-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.123-rc1
X-KernelTest-Deadline: 2026-02-06T14:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.123 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.123-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.123-rc1

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    bpf/selftests: test_select_reuseport_kern: Remove unused header

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: Remove conditional threaded-NAPI wakeup based on task state."

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: Allow to use SMP threads for backlog NAPI."

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: use udelay rather than fsleep

Eric Dumazet <edumazet@google.com>
    ptr_ring: do not block hard interrupts in ptr_ring_resize_multiple()

Marios Makassikis <mmakassikis@freebox.fr>
    ksmbd: fix recursive locking in RPC handle list access

e.kubanski <e.kubanski@partner.samsung.com>
    xsk: Fix race condition in AF_XDP generic RX path

Jon Doron <jond@wiz.io>
    drm/amdgpu: fix NULL pointer dereference in amdgpu_gmc_filter_faults_remove

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Don't use sw fault filter if retry cam enabled

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    pinctrl: qcom: sm8350-lpass-lpi: Merge with SC7280 to fix I2S2 and SWR TX pins

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: avoid dup SUB_CLOSED events after disconnect

Laveesh Bansal <laveeshb@laveeshbansal.com>
    writeback: fix 100% CPU usage when dirtytime_expire_interval is 0

Steven Rostedt <rostedt@goodmis.org>
    perf: sched: Fix perf crash with new is_user_task() helper

Johan Hovold <johan@kernel.org>
    drm/msm/a6xx: fix bogus hwcg register updates

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: lpass-lpi: implement .get_direction() for the GPIO driver

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing unlock at error path of maxpacksize check

Chen Ni <nichen@iscas.ac.cn>
    net/sched: act_ife: convert comma to semicolon

JP Kobryn <inwardvessel@gmail.com>
    btrfs: prevent use-after-free on page private data in btrfs_subpage_clear_uptodate()

Robert McClinton <rbmccav@gmail.com>
    drm/radeon: delete radeon_fence_process in is_signaled, no deadlock

Nikola Z. Ivanov <zlatistiv@gmail.com>
    team: Move team device type change at the end of team_port_add

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath11k: add srng->lock for ath11k_hal_srng_* in monitor mode

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: move TDLS work to wiphy work

Yunseong Kim <ysk@kzalloc.com>
    ksmbd: Fix race condition in RPC handle list access

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Replace Mutex with Spinlock for RLCG register access to avoid Priority Inversion in SRIOV

Thomas Fourier <fourier.thomas@gmail.com>
    ksmbd: smbd: fix dma_unmap_sg() nents

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: trace: treat reg parameter as string

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Fix restoration of SVE context

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Consistently read FPSIMD context

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Mandate SVE payload for streaming-mode state

Pimyn Girgis <pimyn@google.com>
    mm/kfence: randomize the freelist on initialization

Robin Murphy <robin.murphy@arm.com>
    gpio: rockchip: Stop calling pinctrl for set_direction

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix wptr reset in KGQ init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/soc21: fix xclk for APUs

Johan Hovold <johan@kernel.org>
    drm/imx/tve: fix probe device leak

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer: Add compiler_builtins -> core dep

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

Han Gao <gaohan@iscas.ac.cn>
    riscv: compat: fix COMPAT_UTS_MACHINE definition

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    pinctrl: meson: mark the GPIO controller as sleeping

Sai Sree Kartheek Adivi <s-adivi@ti.com>
    dma/pool: distinguish between missing and exhausted atomic pools

Denis Sergeev <denserg.edu@gmail.com>
    gpiolib: acpi: use BIT_ULL() for u64 mask in address space handler

Tagir Garaev <tgaraev653@gmail.com>
    ASoC: Intel: sof_es8336: fix headphone GPIO logic inversion

Kery Qi <qikeyu2017@gmail.com>
    scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Skip ESN replay window setup for IPsec crypto offload

Martin Kaiser <martin@kaiser.cx>
    net: bridge: fix static key check

Kuniyuki Iwashima <kuniyu@google.com>
    nfc: nci: Fix race between rfkill and nci_unregister_device().

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Account for netdev stats in ndo_get_stats64

Yafang Shao <laoar.shao@gmail.com>
    net/mlx5e: Report rx_discards_phy via rx_dropped

Mark Bloch <mbloch@nvidia.com>
    net/mlx5e: TC, delete flows only for existing peers

Jesse Brandeburg <jbrandeburg@cloudflare.com>
    ice: stop counting UDP csum mismatch as rx_errors

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

Jia-Hong Su <s11242586@gmail.com>
    Bluetooth: hci_uart: fix null-ptr-deref in hci_uart_write_work


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/kernel/signal.c                         |  92 ++++++-----
 arch/riscv/include/asm/compat.h                    |   2 +-
 drivers/bluetooth/hci_ldisc.c                      |   4 +-
 drivers/gpio/gpio-pca953x.c                        |   2 +
 drivers/gpio/gpio-rockchip.c                       |   8 -
 drivers/gpio/gpiolib-acpi.c                        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |   8 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   2 +-
 drivers/gpu/drm/imx/ipuv3/imx-tve.c                |  13 ++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   2 -
 drivers/gpu/drm/radeon/radeon_fence.c              |   8 -
 drivers/misc/mei/mei-trace.h                       |  18 +--
 drivers/net/bonding/bond_main.c                    |  18 ++-
 drivers/net/bonding/bond_options.c                 |   8 +-
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   1 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  19 ++-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   2 +-
 drivers/net/ethernet/rocker/rocker_main.c          |   5 +-
 drivers/net/tap.c                                  |   6 +-
 drivers/net/team/team.c                            |  23 ++-
 drivers/net/tun.c                                  |   6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  10 +-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |   9 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   9 +-
 drivers/pinctrl/qcom/Kconfig                       |  15 +-
 drivers/pinctrl/qcom/Makefile                      |   1 -
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c           |  17 ++
 drivers/pinctrl/qcom/pinctrl-sc7280-lpass-lpi.c    |   3 +
 drivers/pinctrl/qcom/pinctrl-sm8350-lpass-lpi.c    | 167 --------------------
 drivers/scsi/be2iscsi/be_mgmt.c                    |   1 +
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/target/sbp/sbp_target.c                    |   4 +-
 fs/btrfs/relocation.c                              |  13 ++
 fs/efivarfs/vars.c                                 |   2 +-
 fs/fs-writeback.c                                  |  14 +-
 fs/smb/server/mgmt/user_session.c                  |  21 ++-
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/transport_ipc.c                      |  12 ++
 fs/smb/server/transport_rdma.c                     |  15 +-
 include/linux/ptr_ring.h                           |  17 +-
 include/linux/sched.h                              |   5 +
 include/linux/skb_array.h                          |  14 +-
 include/net/bonding.h                              |  13 +-
 include/net/nfc/nfc.h                              |   2 +
 include/net/xdp_sock.h                             |   3 -
 include/net/xsk_buff_pool.h                        |   2 +
 kernel/dma/pool.c                                  |   7 +-
 kernel/events/callchain.c                          |   2 +-
 kernel/events/core.c                               |   6 +-
 lib/flex_proportions.c                             |   5 +-
 mm/kfence/core.c                                   |  23 ++-
 net/bridge/br_input.c                              |   2 +-
 net/core/dev.c                                     | 172 +++++++--------------
 net/ipv6/icmp.c                                    |   4 +-
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mac80211/mlme.c                                |   7 +-
 net/mac80211/tdls.c                                |  11 +-
 net/mptcp/protocol.c                               |  13 +-
 net/nfc/core.c                                     |  27 +++-
 net/nfc/llcp_commands.c                            |  17 +-
 net/nfc/llcp_core.c                                |   4 +-
 net/nfc/nci/core.c                                 |   4 +-
 net/sched/act_ife.c                                |   6 +-
 net/sched/sch_generic.c                            |   4 +-
 net/xdp/xsk.c                                      |   6 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 scripts/Makefile.build                             |   2 +-
 scripts/generate_rust_analyzer.py                  |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   8 +
 sound/soc/fsl/imx-card.c                           |   1 -
 sound/soc/intel/boards/sof_es8336.c                |   2 +-
 sound/usb/endpoint.c                               |   3 +-
 .../bpf/progs/test_select_reuseport_kern.c         |   1 -
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  81 +++++++++-
 88 files changed, 576 insertions(+), 543 deletions(-)


