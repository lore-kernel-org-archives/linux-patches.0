Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7498678B4C;
	Wed,  7 Aug 2024 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043256; cv=none; b=L86WHi0RMYx/FXjPKk9QaRZ8T1R/Raiamm3BBbKI70ftVgFmdQoikSbVuBwF7ju/LicBxwYUvS/dH5Xj0Bo2hDhMeg9vG9OxHSR1mbk4mt2ifPzz5M2ebLwgt/mZ5faNxuTYw+4RASGTb1GDmUtouSvjat1CzKxU6DQExH4v9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043256; c=relaxed/simple;
	bh=xJJ6wLs2xIpEvcVO/xNVFt2DBfAqfOGxGcvvuTmaqgM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VVD3nWYZMPas7KsEvvcKYl9/qb7i73s4YpJ6c3h1jfBy8HHdBUJIZoHKXNSOsrIyWJB2NKHKCUkJSnWD/+49q85jBwVEXGRyskV2uucvPmcbvbk0x+pupbM4L2BO3EJQ4rK1rOz2UaBcRyB7Pr+Ufw5/mDuH4sOE2wgDR0p6wgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mm9AaiI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mm9AaiI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF44AC32781;
	Wed,  7 Aug 2024 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043256;
	bh=xJJ6wLs2xIpEvcVO/xNVFt2DBfAqfOGxGcvvuTmaqgM=;
	h=From:To:Cc:Subject:Date:From;
	b=Mm9AaiI7urKRCVMFxW6cu2WedoNCU4pi0Ah1HnN2EN/tDL2lv2s4Xu6b69MHlw39z
	 HlGC/ZJwg2BUpyH/HtIFlWV9/7KWW2hZyHR8Phjc5zH63nb0utG1x6d064Dv6zGO4y
	 kfcYw39Oa/L+lWiaEhTKdovK9xCjJy7gxzoHFysY=
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
Subject: [PATCH 6.6 000/121] 6.6.45-rc1 review
Date: Wed,  7 Aug 2024 16:58:52 +0200
Message-ID: <20240807150019.412911622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.45-rc1
X-KernelTest-Deadline: 2024-08-09T15:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.45 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 09 Aug 2024 14:59:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.45-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.45-rc1

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent BPF accessing lowat from a subflow socket.

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check backup support in signal endp

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: validate backup in MPJ

Liu Jing <liujing@cmss.chinamobile.com>
    selftests: mptcp: always close input's FD if opened

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix duplicate data handling

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only set request_bkup flag when sending MP_PRIO

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix bad RCVPRUNED mib accounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: mib: count MPJ with backup flag

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix NL PM announced address accounting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: distinguish rcv vs sent backup flag in requests

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix user-space PM announced address accounting

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't increment tx_dropped in case of NETDEV_TX_BUSY

Ma Ke <make24@iscas.ac.cn>
    net: usb: sr9700: fix uninitialized variable use in sr_mdio_read

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/i915: Fix possible int overflow in skl_ddi_calculate_wrpll()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    drm/virtio: Fix type of dma-fence context variable

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix a deadlock in dma buf fence polling

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: operate for period elapse event in process context"

Edmund Raile <edmund.raile@protonmail.com>
    Revert "ALSA: firewire-lib: obsolete workqueue for period update"

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Optimize conversions from SysEx to UMP

Mavroudis Chatzilazaridis <mavchatz@protonmail.com>
    ALSA: hda/realtek: Add quirk for Acer Aspire E5-574G

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Correct surround channels in UAC1 channel map

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sched: check both directions for backup

Al Viro <viro@zeniv.linux.org.uk>
    protect the fetch of ->fd[fd] in do_dup2() from mispredictions

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: do not subtract delalloc from avail bytes

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix zone_unusable accounting on making block group read-write again

Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
    HID: wacom: Modify pen IDs

Patryk Duda <patrykd@google.com>
    platform/chrome: cros_ec_proto: Lock device when updating MKBP version

Alice Ryhl <aliceryhl@google.com>
    rust: SHADOW_CALL_STACK is incompatible with Rust

Will Deacon <will@kernel.org>
    arm64: jump_label: Ensure patched jump_labels are visible to all CPUs

Stuart Menefy <stuart.menefy@codasip.com>
    riscv: Fix linear mapping checks for non-contiguous memory regions

Zhe Qiao <qiaozhe@iscas.ac.cn>
    riscv/mm: Add handling for VM_FAULT_SIGSEGV in mm_fault_error()

Shifrin Dmitry <dmitry.shifrin@syntacore.com>
    perf: riscv: Fix selecting counters in legacy mode

Clément Léger <cleger@rivosinc.com>
    riscv: remove unused functions in traps_misaligned.c

Maciej Żenczykowski <maze@google.com>
    ipv6: fix ndisc_is_useropt() handling for PIO

Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
    igc: Fix double reset adapter triggered from a single taprio cmd

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys

Chris Mi <cmi@nvidia.com>
    net/mlx5e: Fix CT entry update leaks of modify header context

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5e: Require mlx5 tc classifier action support for IPsec prio capability

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix missing lock on sync reset reload

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: Lag, don't use the hardcoded value of the first port

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix error handling in irq_pool_request_irq

Shay Drory <shayd@nvidia.com>
    net/mlx5: Always drain health in shutdown callback

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().

Kuniyuki Iwashima <kuniyu@amazon.com>
    netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Conditionally use snooping for AMD HDMI

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: phy: micrel: Fix the KSZ9131 MDI-X status issue

Dan Carpenter <dan.carpenter@linaro.org>
    net: mvpp2: Don't re-use loop iterator

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Fix HDCP2_STREAM_STATUS macro

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: fix use after free in iucv_sock_close()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: add missing WRITE_ONCE when clearing ice_rx_ring::xdp_prog

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: replace synchronize_rcu with synchronize_net

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: don't busy wait for Rx queue disable in ice_qp_dis()

Michal Kubiak <michal.kubiak@intel.com>
    ice: respect netif readiness in AF_XDP ZC related ndo's

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    i915/perf: Remove code to update PWR_CLK_STATE for gen12

Kuniyuki Iwashima <kuniyu@amazon.com>
    rtnetlink: Don't ignore IFLA_TARGET_NETNSID when ifname is specified in rtnl_dellink().

Andy Chiu <andy.chiu@sifive.com>
    net: axienet: start napi before enabling Rx/Tx

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    tcp: Adjust clamping window for applications specifying SO_RCVBUF

Eric Dumazet <edumazet@google.com>
    tcp: annotate data-races around tp->window_clamp

Paolo Abeni <pabeni@redhat.com>
    mptcp: give rcvlowat some love

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix suspending with wrong filter policy

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Fail setup on error

songxiebing <songxiebing@kylinos.cn>
    ALSA: hda: conexant: Fix headset auto detect fail in the polling mode

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: conexant: Reduce CONFIG_PM dependencies

Mark Mentovai <mark@mentovai.com>
    net: phy: realtek: add support for RTL8366S Gigabit PHY

Veerendranath Jakkam <quic_vjakkam@quicinc.com>
    wifi: cfg80211: fix reporting failed MLO links status with cfg80211_connect_done

Eric Dumazet <edumazet@google.com>
    sched: act_ct: take care of padding in struct zones_ht_key

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Trigger a modeset when the screen moves

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix overlay when using Screen Targets

Danilo Krummrich <dakr@kernel.org>
    drm/nouveau: prime: fix refcount underflow

Casey Chen <cachen@purestorage.com>
    perf tool: fix dereferencing NULL al->maps

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Move sensor discovery before HID device initialization

Jinjie Ruan <ruanjinjie@huawei.com>
    ARM: 9406/1: Fix callchain_trace() return value

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix ls2k1000-rtc interrupt

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: dts: loongson: Fix liointc IRQ polarity

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a

Xu Yang <xu.yang_2@nxp.com>
    perf: imx_perf: fix counter start and config sequence

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: change the memory access from local into remote mode in i.MX 8QM

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: clean up unused "fsl,imx8qm-adma" compatible string

Joy Zou <joy.zou@nxp.com>
    dmaengine: fsl-edma: add i.MX8ULP edma support

Frank Li <Frank.Li@nxp.com>
    dmaengine: fsl-edma: add address for channel mux register in fsl_edma_chan

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: assign CURSEG_ALL_DATA_ATGC if blkaddr is valid

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to avoid use SSR allocate when do defragment

Li Zhijian <lizhijian@fujitsu.com>
    mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()

Lucas Stach <l.stach@pengutronix.de>
    mm: page_alloc: control latency caused by zone PCP draining

Huang Ying <ying.huang@intel.com>
    mm: restrict the pcp batch scale factor to avoid too long latency

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: vesafb: Detect VGA compatibility from screen info's VESA attributes

Thomas Zimmermann <tzimmermann@suse.de>
    firmware/sysfb: Update screen_info for relocated EFI framebuffers

Thomas Zimmermann <tzimmermann@suse.de>
    video: Provide screen_info_get_pci_dev() to find screen_info's PCI device

Thomas Zimmermann <tzimmermann@suse.de>
    video: Add helpers for decoding screen_info

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev/vesafb: Replace references to global screen_info by local pointer

Sui Jingfeng <suijingfeng@loongson.cn>
    PCI: Add pci_get_base_class() helper

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Check for pending posted interrupts when looking for nested events

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Add a helper to get highest pending from Posted Interrupt vector

Jacob Pan <jacob.jun.pan@linux.intel.com>
    KVM: VMX: Move posted interrupt descriptor out of VMX code

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: VMX: Split off vmx_onhyperv.{ch} from hyperv.{ch}

Thomas Weißschuh <linux@weissschuh.net>
    leds: triggers: Flush pending brightness before activating trigger

Hans de Goede <hdegoede@redhat.com>
    leds: trigger: Call synchronize_rcu() before calling trig->activate()

Heiner Kallweit <hkallweit1@gmail.com>
    leds: trigger: Store brightness set by led_trigger_event()

Heiner Kallweit <hkallweit1@gmail.com>
    leds: trigger: Remove unused function led_trigger_rename_static()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    cpufreq: qcom-nvmem: fix memory leaks in probe error paths

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    cpufreq: qcom-nvmem: Simplify driver data allocation

Zhang Yi <yi.zhang@huawei.com>
    ext4: check the extent status again before inserting delalloc block

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out a common helper to query extent map

Zhang Yi <yi.zhang@huawei.com>
    ext4: convert to exclusive lock while inserting delalloc extents

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor ext4_da_map_blocks()

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: always initialize i_uid/i_gid

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: treewide: drop unused argument ctl_table_root::set_ownership(table)

Alexey Gladkov <legion@kernel.org>
    sysctl: allow to change limits for posix messages queues

Alexey Gladkov <legion@kernel.org>
    sysctl: allow change system v ipc sysctls inside ipc namespace

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    thermal/drivers/broadcom: Fix race between removal and clock disable

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    thermal: bcm2835: Convert to platform remove callback returning void

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sdm845: Disable SS instance in Parkmode for USB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: switch USB QMP PHY to new style of bindings

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: switch USB+DP QMP PHY to new style of bindings

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq8074: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8998: switch USB QMP PHY to new style of bindings

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sc7280: Disable SuperSpeed instances in park mode

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc7280: switch USB+DP QMP PHY to new style of bindings

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sc7180: Disable SuperSpeed instances in park mode

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc7180: switch USB+DP QMP PHY to new style of bindings


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/kernel/perf_callchain.c                   |   3 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  36 ++--
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  58 ++----
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |  60 ++----
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  98 ++++------
 arch/arm64/include/asm/jump_label.h                |   1 +
 arch/arm64/kernel/jump_label.c                     |  11 +-
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |  81 +++++---
 arch/riscv/kernel/traps_misaligned.c               |  48 +----
 arch/riscv/mm/fault.c                              |  17 +-
 arch/riscv/mm/init.c                               |  15 +-
 arch/x86/include/asm/posted_intr.h                 |  88 +++++++++
 arch/x86/kvm/Makefile                              |   4 +
 arch/x86/kvm/vmx/hyperv.c                          | 139 -------------
 arch/x86/kvm/vmx/hyperv.h                          | 217 ++++++++++-----------
 arch/x86/kvm/vmx/nested.c                          |  41 +++-
 arch/x86/kvm/vmx/posted_intr.h                     | 101 +---------
 arch/x86/kvm/vmx/vmx.c                             |   2 +
 arch/x86/kvm/vmx/vmx.h                             |   2 +-
 arch/x86/kvm/vmx/vmx_onhyperv.c                    |  36 ++++
 arch/x86/kvm/vmx/vmx_onhyperv.h                    | 124 ++++++++++++
 arch/x86/kvm/vmx/vmx_ops.h                         |   2 +-
 drivers/bluetooth/btintel.c                        |   3 +
 drivers/cpufreq/qcom-cpufreq-nvmem.c               |  50 +++--
 drivers/dma/fsl-edma-common.c                      |  31 +--
 drivers/dma/fsl-edma-common.h                      |   6 +-
 drivers/dma/fsl-edma-main.c                        |  25 ++-
 drivers/firmware/Kconfig                           |   1 +
 drivers/firmware/sysfb.c                           |   2 +
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c      |   6 +-
 drivers/gpu/drm/i915/display/intel_hdcp_regs.h     |   2 +-
 drivers/gpu/drm/i915/i915_perf.c                   |  33 ----
 drivers/gpu/drm/nouveau/nouveau_prime.c            |   3 +-
 drivers/gpu/drm/virtio/virtgpu_submit.c            |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c            |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |  29 ++-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |  18 +-
 drivers/hid/wacom_wac.c                            |   3 +-
 drivers/leds/led-triggers.c                        |  32 +--
 drivers/leds/trigger/ledtrig-timer.c               |   5 -
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  19 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  33 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   5 +-
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |   8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/phy/micrel.c                           |  34 ++--
 drivers/net/phy/realtek.c                          |   7 +
 drivers/net/usb/sr9700.c                           |  11 +-
 drivers/pci/search.c                               |  31 +++
 drivers/perf/fsl_imx9_ddr_perf.c                   |   6 +-
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/platform/chrome/cros_ec_proto.c            |   2 +
 drivers/thermal/broadcom/bcm2835_thermal.c         |  25 +--
 drivers/video/Kconfig                              |   4 +
 drivers/video/Makefile                             |   4 +
 drivers/video/fbdev/vesafb.c                       |  66 ++++---
 drivers/video/screen_info_generic.c                | 146 ++++++++++++++
 drivers/video/screen_info_pci.c                    | 136 +++++++++++++
 fs/btrfs/block-group.c                             |  13 +-
 fs/btrfs/extent-tree.c                             |   3 +-
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/space-info.c                              |   5 +-
 fs/btrfs/space-info.h                              |   1 +
 fs/ext4/inode.c                                    |  98 ++++++----
 fs/f2fs/segment.c                                  |   4 +-
 fs/file.c                                          |   1 +
 fs/proc/proc_sysctl.c                              |   8 +-
 include/linux/leds.h                               |  30 ++-
 include/linux/pci.h                                |   5 +
 include/linux/screen_info.h                        | 136 +++++++++++++
 include/linux/sysctl.h                             |   1 -
 include/trace/events/btrfs.h                       |   8 +
 include/trace/events/mptcp.h                       |   2 +-
 init/Kconfig                                       |   1 +
 ipc/ipc_sysctl.c                                   |  36 +++-
 ipc/mq_sysctl.c                                    |  35 ++++
 mm/Kconfig                                         |  11 ++
 mm/page_alloc.c                                    |  19 +-
 net/bluetooth/hci_sync.c                           |  21 ++
 net/core/rtnetlink.c                               |   2 +-
 net/ipv4/netfilter/iptable_nat.c                   |  18 +-
 net/ipv4/syncookies.c                              |   3 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_input.c                               |  36 ++--
 net/ipv4/tcp_output.c                              |  18 +-
 net/ipv6/ndisc.c                                   |  34 ++--
 net/ipv6/netfilter/ip6table_nat.c                  |  14 +-
 net/ipv6/syncookies.c                              |   2 +-
 net/iucv/af_iucv.c                                 |   4 +-
 net/mptcp/mib.c                                    |   2 +
 net/mptcp/mib.h                                    |   2 +
 net/mptcp/options.c                                |   2 +-
 net/mptcp/pm_netlink.c                             |  28 ++-
 net/mptcp/protocol.c                               |  44 ++---
 net/mptcp/protocol.h                               |  21 ++
 net/mptcp/sockopt.c                                |  46 +++++
 net/mptcp/subflow.c                                |  35 +++-
 net/sched/act_ct.c                                 |   4 +-
 net/sysctl_net.c                                   |   1 -
 net/wireless/sme.c                                 |   1 +
 sound/core/seq/seq_ump_convert.c                   |  41 ++--
 sound/firewire/amdtp-stream.c                      |  38 ++--
 sound/firewire/amdtp-stream.h                      |   1 +
 sound/pci/hda/hda_controller.h                     |   2 +-
 sound/pci/hda/hda_intel.c                          |  10 +-
 sound/pci/hda/patch_conexant.c                     |  58 +-----
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/stream.c                                 |   4 +-
 tools/perf/util/callchain.c                        |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   8 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  72 +++++--
 123 files changed, 1922 insertions(+), 1121 deletions(-)


