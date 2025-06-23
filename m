Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30984253953;
	Mon, 23 Jun 2025 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684192; cv=none; b=CLQZB5OdK+1rtX7mhOJOHw8diwuiMQ/HEVwhsutgdw5XtbAGWtJeEP6cdsEEzUwXQV/7txKT5u0vYY9Ps/Y9QjfItfyIMNjBoBvqgc9Ed90/d4gjf52YOF9FH06jqY0dAamKkUYT2vp4VV9UW6M0ccCRTmjod7Fu0urSE/A0KnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684192; c=relaxed/simple;
	bh=YYR5jNGXzltOkz1h//wR5Pzy1DQAf9px7c7WKcGbbaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZI6RFQHbGYGS+SEbDJcfaFBHeP7tNyzA1isgA++8cEslzbmu6PrWO7SyClmMzchXRmUZABFpGnvXijEAlFDGNJcgw3wNAE5VpJLcC9CZylrYciqmKyblPq47zKPCjntLPAHs4RYovncMdvJoBs8HGqvXPsJI3S6Swa2PZk/dHUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmA1B/o7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmA1B/o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A118C4CEEA;
	Mon, 23 Jun 2025 13:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684192;
	bh=YYR5jNGXzltOkz1h//wR5Pzy1DQAf9px7c7WKcGbbaQ=;
	h=From:To:Cc:Subject:Date:From;
	b=RmA1B/o7fFuBoGbMXcRJ/p88lTY7OPlicl+DbB8+hypAVFb4TsFlgY9zUZp+/ah1I
	 oMGP7APeloecCiozw9bRB4mSw/KA6QerfNVWE8JXSGEDjHmZByu3StPNNe6WHud+iX
	 p7c/wv7ey5AnGblkOezXKTEfOLqWGlvWIv70bA1M=
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
	broonie@kernel.org
Subject: [PATCH 5.15 000/411] 5.15.186-rc1 review
Date: Mon, 23 Jun 2025 15:02:24 +0200
Message-ID: <20250623130632.993849527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.186-rc1
X-KernelTest-Deadline: 2025-06-25T13:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.186 release.
There are 411 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.186-rc1

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()

Tengda Wu <wutengda@huaweicloud.com>
    arm64/ptrace: Fix stack-out-of-bounds read in regs_get_kernel_stack_nth()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sample vs do_exit()

Heiko Carstens <hca@linux.ibm.com>
    s390/pci: Fix __pcilg_mio_inuser() inline assembly

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE

Paul Chaignon <paul.chaignon@gmail.com>
    net: Fix checksum update for ILA adj-transport

Jan Kara <jack@suse.cz>
    ext4: avoid remount errors with 'abort' mount option

Jan Kara <jack@suse.cz>
    ext4: make 'abort' mount option handling standard

Gavin Guo <gavinguo@igalia.com>
    mm/huge_memory: fix dereferencing invalid pmd migration entry

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: reject invalid perturb period

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: move the limit validation

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: use a temporary work area for validating configuration

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: don't allow 1 packet limit

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: handle bigger packets

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: annotate data-races around q->perturb_period

James Morse <james.morse@arm.com>
    arm64: proton-pack: Add new CPUs 'k' values for branch mitigation

James Morse <james.morse@arm.com>
    arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users

James Morse <james.morse@arm.com>
    arm64: bpf: Add BHB mitigation to the epilogue for cBPF programs

Liu Song <liusong@linux.alibaba.com>
    arm64: spectre: increase parameters that can be used to turn off bhb mitigation individually

James Morse <james.morse@arm.com>
    arm64: proton-pack: Expose whether the branchy loop k value

James Morse <james.morse@arm.com>
    arm64: proton-pack: Expose whether the platform is mitigated by firmware

James Morse <james.morse@arm.com>
    arm64: insn: Add support for encoding DSB

Hou Tao <houtao1@huawei.com>
    arm64: insn: add encoders for atomic operations

Hou Tao <houtao1@huawei.com>
    arm64: move AARCH64_BREAK_FAULT into insn-def.h

Jon Hunter <jonathanh@nvidia.com>
    Revert "cpufreq: tegra186: Share policy per cluster"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Increment the runtime usage counter for the earlycon device

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: am335x-bone-common: Increase MDIO reset deassert delay to 50ms

Colin Foster <colin.foster@in-advantage.com>
    ARM: dts: am335x-bone-common: Increase MDIO reset deassert time

Shengyu Qu <wiagn233@outlook.com>
    ARM: dts: am335x-bone-common: Add GPIO PHY reset on revision C3 board

Eric Dumazet <edumazet@google.com>
    net: atm: fix /proc/net/atm/lec handling

Eric Dumazet <edumazet@google.com>
    net: atm: add lec_mutex

Kuniyuki Iwashima <kuniyu@google.com>
    calipso: Fix null-ptr-deref in calipso_req_{set,del}attr().

Haixia Qu <hxqu@hillstonenet.com>
    tipc: fix null-ptr-deref when acquiring remote ip of ethernet bearer

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_packet_delayed() for tcp_is_non_sack_preventing_reopen() behavior

Kuniyuki Iwashima <kuniyu@google.com>
    atm: atmtcp: Free invalid length skb in atmtcp_c_send().

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Use rcu_dereference_rtnl() in mpls_route_input_rcu().

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: carl9170: do not ping device which has failed to load firmware

Vladimir Oltean <vladimir.oltean@nxp.com>
    ptp: fix breakage after ptp_vclock_in_use() rework

Krishna Kumar <krikku@gmail.com>
    net: ice: Perform accurate aRFS flow match

Justin Sanders <jsanders.devel@gmail.com>
    aoe: clean device rq_list in aoedev_downdev()

Simon Horman <horms@kernel.org>
    pldmfw: Select CRC32 when PLDMFW is selected

Arnd Bergmann <arnd@arndb.de>
    hwmon: (occ) fix unaligned accesses

Arnd Bergmann <arnd@arndb.de>
    hwmon: (occ) Rework attribute registration for stack usage

Eddie James <eajames@linux.ibm.com>
    hwmon: (occ) Add soft minimum power cap attribute

Jacob Keller <jacob.e.keller@intel.com>
    drm/nouveau/bl: increase buffer size to avoid truncate warning

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate

Gao Xiang <hsiangkao@linux.alibaba.com>
    erofs: remove unused trace event erofs_destroy_inode

Jann Horn <jannh@google.com>
    mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race

Liu Shixin <liushixin2@huawei.com>
    mm: hugetlb: independent PMD page table shared count

Jann Horn <jannh@google.com>
    mm/hugetlb: unshare page tables during VMA split, not before

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: Fix temperature calculation

Jonathan Lane <jon@borg.moe>
    ALSA: hda/realtek: enable headset mic on Latitude 5420 Rugged

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/intel: Add Thinkpad E15 to PM deny list

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: Rename ALSA kcontrol PCM and PCM1 for the KTMicro sound card

WangYuli <wangyuli@uniontech.com>
    Input: sparcspkr - avoid unannotated fall-through

Christoph Hellwig <hch@lst.de>
    block: default BLOCK_LEGACY_AUTOLOAD to y

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: usbhid: Eliminate recurrent out-of-bounds bug in usbhid_parse()

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Revert atm_account_tx() if copy_from_iter_full() fails.

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len

Xin Li (Intel) <xin@zytor.com>
    selftests/x86: Add a test to detect infinite SIGTRAP handler loop

Marek Szyprowski <m.szyprowski@samsung.com>
    udmabuf: use sgtable-based scatterlist wrappers

Peter Oberparleiter <oberpar@linux.ibm.com>
    scsi: s390: zfcp: Ensure synchronous unit_add

Dexuan Cui <decui@microsoft.com>
    scsi: storvsc: Increase the timeouts to storvsc_timeout

Fedor Pchelkin <pchelkin@ispras.ru>
    jffs2: check jffs2_prealloc_raw_node_refs() result in few other places

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    jffs2: check that raw node were preallocated before writing summary

Andrew Morton <akpm@linux-foundation.org>
    drivers/rapidio/rio_cm.c: prevent possible heap overwrite

Breno Leitao <leitao@debian.org>
    Revert "x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2" on v6.6 and older

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/eeh: Fix missing PE bridge reconfiguration during VFIO EEH recovery

Stuart Hayes <stuart.w.hayes@gmail.com>
    platform/x86: dell_rbu: Stop overwriting data buffer

Stuart Hayes <stuart.w.hayes@gmail.com>
    platform/x86: dell_rbu: Fix list usage

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    Revert "bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first"

Jann Horn <jannh@google.com>
    tee: Prevent size calculation wraparound on 32-bit kernels

Sukrut Bellary <sbellary@baylibre.com>
    ARM: OMAP2+: Fix l4ls clk domain handling in STANDBY

Laurentiu Tudor <laurentiu.tudor@nxp.com>
    bus: fsl-mc: increase MC_CMD_COMPLETION_TIMEOUT_MS value

Marcus Folkesson <marcus.folkesson@gmail.com>
    watchdog: da9052_wdt: respect TWDMIN

Wentao Liang <vulab@iscas.ac.cn>
    octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix data lost during EAGAIN retries

Kyungwook Boo <bookyungwook@gmail.com>
    i40e: fix MMIO write access to an invalid page in i40e_clear_hw

Zijun Hu <quic_zijuhu@quicinc.com>
    sock: Correct error checking condition for (assign|release)_proto_idx()

Daniel Wagner <wagi@kernel.org>
    scsi: lpfc: Use memcpy() for BIOS version

Mike Looijmans <mike.looijmans@topic.nl>
    pinctrl: mcp23s08: Reset all pins to input at probe

Zijun Hu <quic_zijuhu@quicinc.com>
    software node: Correct a OOB check in software_node_get_reference_args()

Ido Schimmel <idosch@nvidia.com>
    vxlan: Do not treat dst cache initialization errors as fatal

Yong Wang <yongwang@nvidia.com>
    net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions

Sean Christopherson <seanjc@google.com>
    iommu/amd: Ensure GA log notifier callbacks finish running before module unload

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Add identical pointer detection to btf_dedup_is_equiv()

Heiko Stuebner <heiko@sntech.de>
    clk: rockchip: rk3036: mark ddrphy as critical

Benjamin Berg <benjamin@sipsolutions.net>
    wifi: mac80211: do not offer a mesh path if forwarding is disabled

Jason Xing <kernelxing@tencent.com>
    net: mlx4: add SOF_TIMESTAMPING_TX_SOFTWARE flag when getting ts info

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_pmx_gpio_set_direction()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()

Jason Xing <kernelxing@tencent.com>
    net: atlantic: generate software timestamp just before the doorbell

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT

Eric Dumazet <edumazet@google.com>
    tcp: fix initial tp->rcvq_space.space value for passive TS enabled flows

Eric Dumazet <edumazet@google.com>
    tcp: always seek for minimal rtt in tcp_rcv_rtt_update()

Moon Yeounsu <yyyynoom@gmail.com>
    net: dlink: add synchronization for stats update

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Add clock toggle recovery

Mike Tipton <quic_mdtipton@quicinc.com>
    cpufreq: scmi: Skip SCMI devices that aren't used by the CPUs

Petr Malat <oss@malat.biz>
    sctp: Do not wake readers in __sctp_write_space()

Henk Vergonet <henk.vergonet@gmail.com>
    wifi: mt76: mt76x2: Add support for LiteOn WN4516R,WN4519R

Alok Tiwari <alok.a.tiwari@oracle.com>
    emulex/benet: correct command version selection in be_cmd_get_stats()

Tan En De <ende.tan@starfivetech.com>
    i2c: designware: Invoke runtime suspend on quick slave re-registration

Zilin Guan <zilin@seu.edu.cn>
    tipc: use kfree_sensitive() for aead cleanup

Sergio Perez Gonzalez <sperezglz@gmail.com>
    net: macb: Check return value of dma_set_mask_and_coherent()

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: Force sync policy boost with global boost on sysfs update

George Moussalem <george.moussalem@outlook.com>
    thermal/drivers/qcom/tsens: Update conditions to strictly evaluate for IP v2+

Sukrut Bellary <sbellary@baylibre.com>
    pmdomain: ti: Fix STANDBY handling of PER power domain

Simon Schuster <schuster.simon@siemens-energy.com>
    nios2: force update_mmu_cache on spurious tlb-permission--related pagefaults

Shravan Chippa <shravan.chippa@microchip.com>
    media: i2c: imx334: update mode_3840x2160_regs array

Wentao Liang <vulab@iscas.ac.cn>
    media: platform: exynos4-is: Add hardware sync wait to fimc_is_hw_change_mode()

Hans Verkuil <hverkuil@xs4all.nl>
    media: tc358743: ignore video while HPD is low

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: don't select single flush for active CTL blocks

Dylan Wolff <wolffd@comp.nus.edu.sg>
    jfs: Fix null-ptr-deref in jfs_ioc_trim

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: fix CSIB handling

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx8: fix CSIB handling

Zhang Yi <yi.zhang@huawei.com>
    ext4: prevent stale extent cache entries caused by concurrent get es_cache

Long Li <leo.lilong@huawei.com>
    sunrpc: fix race in cache cleanup causing stale nextcheck time

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: rkvdec: Initialize the m2m context before the controls

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: ti: cal: Fix wrong goto on error path

Aditya Dutt <duttaditya18@gmail.com>
    jfs: fix array-index-out-of-bounds read in add_missing_indices

Zhang Yi <yi.zhang@huawei.com>
    ext4: ext4: unify EXT4_EX_NOCACHE|NOFAIL flags in ext4_ext_remove_space()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx7: fix CSIB handling

Nas Chung <nas.chung@chipsnmedia.com>
    media: uapi: v4l: Change V4L2_TYPE_IS_CAPTURE condition

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs-pll: Better validate VT PLL branch

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix CSIB handling

Tarang Raval <tarang.raval@siliconsignals.io>
    media: i2c: imx334: Fix runtime PM handling in remove function

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Increase HFI response timeout

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL pointer checks in dm_force_atomic_commit()

Nas Chung <nas.chung@chipsnmedia.com>
    media: uapi: v4l: Fix V4L2_TYPE_IS_OUTPUT condition

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: add runtime PM calls to DDC transfer function

Tarang Raval <tarang.raval@siliconsignals.io>
    media: i2c: imx334: Enable runtime PM before sub-device registration

Ayushi Makhija <quic_amakhija@quicinc.com>
    drm/bridge: anx7625: change the gpiod_set_value API

Namjae Jeon <linkinjeon@kernel.org>
    exfat: fix double free in delayed_free

Damon Ding <damon.ding@rock-chips.com>
    drm/bridge: analogix_dp: Add irq flag IRQF_NO_AUTOEN instead of calling disable_irq()

Long Li <leo.lilong@huawei.com>
    sunrpc: update nextcheck time when adding new cache entries

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx6: fix CSIB handling

Peter Marheine <pmarheine@chromium.org>
    ACPI: battery: negate current when discharging

Charan Teja Kalla <quic_charante@quicinc.com>
    PM: runtime: fix denying of auto suspend in pm_suspend_timer_fn()

Yuanjun Gong <ruc_gongyuanjun@163.com>
    ASoC: tegra210_ahub: Add check to of_device_get_match_data()

gldrk <me@rarity.fan>
    ACPICA: utilities: Fix overflow check in vsnprintf()

Jerry Lv <Jerry.Lv@axis.com>
    power: supply: bq27xxx: Retrieve again when busy

Seunghun Han <kkamagui@gmail.com>
    ACPICA: fix acpi parse and parseext cache leaks

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Bail out if acpi_kobj registration fails

Hector Martin <marcan@marcan.st>
    ASoC: tas2770: Power cycle amp on ISENSE/VSENSE change

Ahmed Salem <x0rw3ll@gmail.com>
    ACPICA: Avoid sequence overread in call to strncmp()

Guilherme G. Piccoli <gpiccoli@igalia.com>
    clocksource: Fix the CPUs' choice in the watchdog per CPU verification

Seunghun Han <kkamagui@gmail.com>
    ACPICA: fix acpi operand cache leak in dswstate.c

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7606_spi: fix reg write value mask

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Fix temperature calculation

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: Fix temperature scan element sign

Diederik de Haas <didi.debian@cknow.org>
    PCI: dw-rockchip: Fix PHY function call sequence in rockchip_pcie_phy_deinit()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix lock symmetry in pci_slot_unlock()

Huacai Chen <chenhuacai@kernel.org>
    PCI: Add ACS quirk for Loongson PCIe

Niklas Cassel <cassel@kernel.org>
    PCI: cadence-ep: Correct PBA offset in .set_msix() callback

Long Li <longli@microsoft.com>
    uio_hv_generic: Use correct size for interrupt and monitor pages

Xiaolei Wang <xiaolei.wang@windriver.com>
    remoteproc: core: Release rproc->clean_table after rproc_attach() fails

Xiaolei Wang <xiaolei.wang@windriver.com>
    remoteproc: core: Cleanup acquired resources when rproc_handle_resources() fails in rproc_attach()

Wentao Liang <vulab@iscas.ac.cn>
    regulator: max14577: Add error check for max14577_read_reg()

Khem Raj <raj.khem@gmail.com>
    mips: Add -std= flag specified in KBUILD_CFLAGS to vdso CFLAGS

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: iio: ad5933: Correct settling cycles encoding per datasheet

Qasim Ijaz <qasdev00@gmail.com>
    net: ch9200: fix uninitialised access during mii_nway_restart

Ye Bin <yebin10@huawei.com>
    ftrace: Fix UAF when lookup kallsym after ftrace disabled

Mikulas Patocka <mpatocka@redhat.com>
    dm-mirror: fix a tiny race condition

Wentao Liang <vulab@iscas.ac.cn>
    mtd: nand: sunxi: Add randomizer configuration before randomizer enable

Wentao Liang <vulab@iscas.ac.cn>
    mtd: rawnand: sunxi: Add randomizer configuration in sunxi_nfc_hw_ecc_write_chunk

Jinliang Zheng <alexjlzheng@tencent.com>
    mm: fix ratelimit_pages update error in dirty_ratio_handler()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    RDMA/iwcm: Fix use-after-free of work objects after cm_id destruction

Jeongjun Park <aha310510@gmail.com>
    ipc: fix to protect IPCS lookups using RCU

Da Xue <da@libre.computer>
    clk: meson-g12a: add missing fclk_div2 to spicc

Arnd Bergmann <arnd@arndb.de>
    parisc: fix building with gcc-15

GONG Ruiqi <gongruiqi1@huawei.com>
    vgacon: Add check for vc_origin address range in vgacon_scroll()

Murad Masimov <m.masimov@mt-integration.ru>
    fbdev: Fix fb_set_var to prevent null-ptr-deref in fb_videomode_to_var

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    EDAC/altera: Use correct write width with the INTTEST register

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    NFC: nci: uart: Set tty->disc_data only in success path

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sit_bitmap_size

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: prevent kernel warning due to negative i_nlink from corrupted image

Dan Carpenter <dan.carpenter@linaro.org>
    Input: ims-pcu - check record size in ims_pcu_flash_firmware()

Zhang Yi <yi.zhang@huawei.com>
    ext4: ensure i_size is smaller than maxbytes

Zhang Yi <yi.zhang@huawei.com>
    ext4: factor out ext4_get_maxbytes()

Jan Kara <jack@suse.cz>
    ext4: fix calculation of credits for extent tree modification

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    ext4: inline: fix len overflow in ext4_prepare_inline_data

Wan Junjie <junjie.wan@inceptio.ai>
    bus: fsl-mc: fix GET/SET_TAILDROP command ids

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: do not add a device-link for the UAPI used DPMCP device

Tasos Sahanidis <tasos@tasossah.com>
    ata: pata_via: Force PIO for ATAPI devices on VT6415/VT6330

Brett Werling <brett.werling@garmin.com>
    can: tcan4x5x: fix power regulator retrieval during probe

Jeff Hugo <quic_jhugo@quicinc.com>
    bus: mhi: host: Fix conflict between power_up and SYSERR

Andreas Kemnade <andreas@kemnade.info>
    ARM: omap: pmic-cpcap: do not mess around without CPCAP or OMAP4

Ross Stutterheim <ross.stutterheim@garmin.com>
    ARM: 9447/1: arm/memremap: fix arch_memremap_can_ram_remap()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix deferred probing error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Send control events for partial succeeds

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Return the number of processed controls

Denis Arefev <arefev@swemel.ru>
    media: vivid: Change the siize of the composing

Edward Adam Davis <eadavis@qq.com>
    media: vidtv: Terminating the subsequent process of initialization failure

Marek Szyprowski <m.szyprowski@samsung.com>
    media: videobuf2: use sgtable-based scatterlist wrappers

Loic Poulain <loic.poulain@oss.qualcomm.com>
    media: venus: Fix probe error handling

Ma Ke <make24@iscas.ac.cn>
    media: v4l2-dev: fix error handling in __video_register_device()

Wentao Liang <vulab@iscas.ac.cn>
    media: gspca: Add error handling for stv06xx_read_sensor()

Edward Adam Davis <eadavis@qq.com>
    media: cxusb: no longer judge rbuf when the write fails

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs-pll: Check for too high VT PLL multiplier in dual PLL case

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs-pll: Correct the upper limit of maximum op_pre_pll_clk_div

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs-pll: Start OP pre-PLL multiplier search from correct value

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs-pll: Start VT pre-PLL multiplier search from correct value

Johan Hovold <johan+linaro@kernel.org>
    media: ov8856: suppress probe deferral errors

Mingcong Bai <jeffbai@aosc.io>
    wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723

Jeongjun Park <aha310510@gmail.com>
    jbd2: fix data-race and null-ptr-deref in jbd2_journal_dirty_metadata()

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: Initialize ssc before laundromat_work to prevent NULL dereference

NeilBrown <neil@brown.name>
    nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request

Christian Lamparter <chunkeey@gmail.com>
    wifi: p54: prevent buffer-overflow in p54_rx_eeprom_readback()

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: Add error handling in mlx5_query_nic_vport_node_guid()

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5_core: Add error handling inmlx5_query_nic_vport_qkey_viol_cntr()

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries/msi: Avoid reading PCI device registers in reduced power states

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: meson-card-utils: use of_property_present() for DT parsing

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: qcom: sdm845: Add error handling in sdm845_slim_snd_hw_params()

Alexander Aring <aahringo@redhat.com>
    gfs2: move msleep to sleepable context

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Do not chain submitted requests

Zijun Hu <quic_zijuhu@quicinc.com>
    configfs: Do not override creating attribute file failure in populate_attrs()

Darrick J. Wong <djwong@kernel.org>
    xfs: allow inode inactivation during a ro mount log recovery

Arnd Bergmann <arnd@arndb.de>
    kbuild: hdrcheck: fix cross build with clang

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kbuild: userprogs: fix bitsize and target detection on clang

I Hsin Cheng <richard120310@gmail.com>
    drm/meson: Use 1000ULL when operating with mode->clock

Oliver Neukum <oneukum@suse.com>
    net: usb: aqc111: debug info before sanitation

Eric Dumazet <edumazet@google.com>
    calipso: unlock rcu before returning -EAFNOSUPPORT

Thomas Gleixner <tglx@linutronix.de>
    x86/iopl: Cure TIF_IO_BITMAP inconsistencies

Stefano Stabellini <stefano.stabellini@amd.com>
    xen/arm: call uaccess_ttbr0_enable for dm_op hypercall

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: Flush altsetting 0 endpoints before reinitializating them after reset.

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with detecting USB 3.2 speed

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with detecting command completion event

Wupeng Ma <mawupeng1@huawei.com>
    VMCI: fix race between vmci_host_setup_notify and vmci_ctx_unset_notify

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix read_stb function and get_stb ioctl

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Do not add '-mhard-float' to dcn2{1,0}_resource.o for clang

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add KBUILD_CPPFLAGS to as-option invocation

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add CLANG_FLAGS to as-instr

Nathan Chancellor <nathan@kernel.org>
    mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Do not add '-mhard-float' to dml_ccflags for clang

Nick Desaulniers <ndesaulniers@google.com>
    kbuild: Update assembler calls to use proper flags and language target

Nathan Chancellor <nathan@kernel.org>
    MIPS: Prefer cc-option for additions to cflags

Nathan Chancellor <nathan@kernel.org>
    MIPS: Move '-Wa,-msoft-float' check from as-option to cc-option

Nick Desaulniers <ndesaulniers@google.com>
    x86/boot/compressed: prefer cc-option for CFLAGS additions

Oleg Nesterov <oleg@redhat.com>
    posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del()

David Heimann <d@dmeh.net>
    ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1

Peter Zijlstra <peterz@infradead.org>
    perf: Ensure bpf_perf_link path is properly serialized

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: access fcpreq only when holding reqlock

Zijun Hu <quic_zijuhu@quicinc.com>
    fs/filesystems: Fix potential unsigned integer underflow in fs_name()

Eric Dumazet <edumazet@google.com>
    net_sched: ets: fix a race in ets_qdisc_change()

Cong Wang <xiyou.wangcong@gmail.com>
    sch_ets: make est_qlen_notify() idempotent

Eric Dumazet <edumazet@google.com>
    net_sched: tbf: fix a race in tbf_change()

Eric Dumazet <edumazet@google.com>
    net_sched: red: fix a race in __red_change()

Eric Dumazet <edumazet@google.com>
    net_sched: prio: fix a race in prio_tune()

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix return value when searching for existing flow group

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Ensure fw pages are always allocated on same NUMA

Jakub Raczynski <j.raczynski@samsung.com>
    net/mdiobus: Fix potential out-of-bounds read/write access

Andrew Lunn <andrew@lunn.ch>
    net: mdio: C22 is now optional, EOPNOTSUPP if not provided

Carlos Fernandez <carlos.fernandez@technica-engineering.de>
    macsec: MACsec SCI assignment for ES = 0

Michal Luczaj <mhal@rbox.co>
    net: Fix TOCTOU issue in sk_is_readable()

Robert Malz <robert.malz@canonical.com>
    i40e: retry VFLR handling if there is ongoing VF reset

Robert Malz <robert.malz@canonical.com>
    i40e: return false from i40e_reset_vf if reset is in progress

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix more rounding issues with 59.94Hz modes

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use vclk_freq instead of pixel_freq in debug print

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: fix debug log statement when setting the HDMI clocks

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    drm/meson: use unsigned long long / Hz for frequency types

Haren Myneni <haren@linux.ibm.com>
    powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: fix a potential crash on gso_skb handling

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: iscsi: Fix incorrect error path labels for flashnode operations

Caleb Connolly <caleb.connolly@linaro.org>
    ath10k: snoc: fix unbalanced IRQ enable in crash recovery

Jeongjun Park <aha310510@gmail.com>
    ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()

Sanjeev Yadav <sanjeev.y@mediatek.com>
    scsi: core: ufs: Fix a hang in the error handler

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Move runtime PM enable to sci_probe_single()

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Check if TX data was written to device in .tx_empty()

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am65-main: Fix sdhci node properties

Nishanth Menon <nm@ti.com>
    arm64: dts: ti: k3-am65-main: Drop deprecated ti,otap-del-sel property

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi - fix crash with unsupported versions of F34

zhang songyi <zhang.songyi@zte.com.cn>
    Input: synaptics-rmi4 - convert to use sysfs_emit() APIs

Dan Carpenter <dan.carpenter@linaro.org>
    pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()

Al Viro <viro@zeniv.linux.org.uk>
    do_change_type(): refuse to operate on unmounted/not ours mounts

Al Viro <viro@zeniv.linux.org.uk>
    fix propagation graph breakage by MOVE_MOUNT_SET_GROUP move_mount(2)

Ido Schimmel <idosch@nvidia.com>
    seg6: Fix validation of nexthop addresses

Mirco Barone <mirco.barone@polito.it>
    wireguard: device: enable threaded NAPI

Florian Westphal <fw@strlen.de>
    netfilter: nf_set_pipapo_avx2: fix initial map fill

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: add missing NULL check for gve_alloc_pending_packet() in TX DQO

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Fix power.is_suspended cleanup for direct-complete devices

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: correctly report gso type for UDP tunnels

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: tag_brcm: legacy: fix pskb_may_pull length

Michal Kubiak <michal.kubiak@intel.com>
    ice: create new Tx scheduler nodes for new queues only

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix shared reset

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-spi: fix shared reset

Dan Carpenter <dan.carpenter@linaro.org>
    net/mlx4_en: Prevent potential integer overflow calculating Hz

Yanqing Wang <ot_yanqing.wang@mediatek.com>
    driver: net: ethernet: mtk_star_emac: fix suspend/resume issue

Charalampos Mitrodimas <charmitro@posteo.net>
    net: tipc: fix refcount warning in tipc_aead_encrypt

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: Fix RX_BUFFERS_POSTED stat to report per-queue fill_cnt

Quentin Schulz <quentin.schulz@cherry.de>
    net: stmmac: platform: guarantee uniqueness of bus_id

Nicolas Pitre <npitre@baylibre.com>
    vt: remove VT_RESIZE and VT_RESIZEX from vt_compat_ioctl()

WangYuli <wangyuli@uniontech.com>
    MIPS: Loongson64: Add missing '#interrupt-cells' for loongson64c_ls7a

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    iio: adc: ad7124: Fix 3dB filter frequency reading

Henry Martin <bsdhenrymartin@gmail.com>
    serial: Fix potential null-ptr-deref in mlb_usio_probe()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    usb: renesas_usbhs: Reorder clock handling and power management in probe

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Initialize aer_err_info before using it

Henry Martin <bsdhenrymartin@gmail.com>
    dmaengine: ti: Add NULL check in udma_probe()

Hans Zhang <18255117159@163.com>
    PCI: cadence: Fix runtime atomic count underflow

Wolfram Sang <wsa+renesas@sang-engineering.com>
    rtc: sh: assign correct interrupts with DT

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: ignore SB_RDONLY when remounting nfs

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: clear SB_RDONLY before getting superblock

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf record: Fix incorrect --user-regs comments

Leo Yan <leo.yan@arm.com>
    perf tests switch-tracking: Fix timestamp comparison

Alexey Gladkov <legion@kernel.org>
    mfd: stmpe-spi: Correct the name used in MODULE_DEVICE_TABLE

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()

Dan Carpenter <dan.carpenter@linaro.org>
    rpmsg: qcom_smd: Fix uninitialized return variable in __qcom_smd_send()

Dan Carpenter <dan.carpenter@linaro.org>
    remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix pattern matching with Python 3

Henry Martin <bsdhenrymartin@gmail.com>
    backlight: pm8941: Add NULL check in wled_configure()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf ui browser hists: Set actions->thread before calling do_zoom_thread()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Warn when libdebuginfod devel files are not available

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Fix attribute addition

Kees Cook <kees@kernel.org>
    randstruct: gcc-plugin: Remove bogus void member

Sergey Shtylyov <s.shtylyov@omp.ru>
    fbdev: core: fbcvt: avoid division by 0 in fb_cvt_hperiod()

Henry Martin <bsdhenrymartin@gmail.com>
    soc: aspeed: Add NULL check in aspeed_lpc_enable_snoop()

Su Hui <suhui@nfschina.com>
    soc: aspeed: lpc: Fix impossible judgment condition

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: fix double-free on mc_dev

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()

Wentao Liang <vulab@iscas.ac.cn>
    nilfs2: add pointer check for nilfs_direct_propagate()

Murad Masimov <m.masimov@mt-integration.ru>
    ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check return result of sb_min_blocksize

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix RTC capacitive load

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix RTC capacitive load

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: at91sam9263: fix NAND chip selects

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to correct check conditions in f2fs_cross_rename

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: use d_inode(dentry) cleanup dentry->d_inode

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: mscc: Stop clearing the the UDPv4 checksum for L2 frames

Faicker Mo <faicker.mo@zenlayer.com>
    net: openvswitch: Fix the dead loop of MPLS parse

Kuniyuki Iwashima <kuniyu@amazon.com>
    calipso: Don't call calipso functions for AF_INET sk.

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy

KaFai Wan <mannkafai@gmail.com>
    bpf: Avoid __bpf_prog_ret0_warn when jit fails

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: aqc111: fix error handling of usbnet read calls

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_tunnel: fix geneve_opt dump

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Avoid using sk_socket after free when sending

Li RongQing <lirongqing@baidu.com>
    vfio/type1: Fix error unwind in migration dirty bitmap allocation

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: ath9k_htc: Abort software beacon handling if disabled

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    wifi: rtw88: fix the 'para' buffer size to avoid reading out of bounds

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Store backchain even for leaf progs

Vincent Knecht <vincent.knecht@mailoo.org>
    clk: qcom: gcc-msm8939: Fix mclk0 & mclk1 for 24 MHz

Tao Chen <chen.dylane@linux.dev>
    bpf: Fix WARN() in get_bpf_raw_tp_regs

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: at91: Fix possible out-of-boundary access

Anton Protopopov <a.s.protopopov@gmail.com>
    libbpf: Use proper errno value in nlattr

Jiayuan Chen <jiayuan.chen@linux.dev>
    ktls, sockmap: Fix missing uncharge operation

Henry Martin <bsdhenrymartin@gmail.com>
    clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix error flow upon firmware failure for RQ destruction

Zhongqiu Duan <dzq.aishenghu0@gmail.com>
    netfilter: nft_quota: match correctly when the quota just depleted

Huajian Yang <huajianyang@asrmicro.com>
    netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it

Anton Protopopov <a.s.protopopov@gmail.com>
    libbpf: Use proper errno value in linker

Chao Yu <chao@kernel.org>
    f2fs: fix to detect gcing page in f2fs_is_cp_guaranteed()

Chao Yu <chao@kernel.org>
    f2fs: clean up w/ fscrypt_is_bounce_page()

Jason Gunthorpe <jgg@ziepe.ca>
    iommu: Protect against overflow in iommu_pgsize()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Include hnae3.h in hns_roce_hw_v2.h

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtw88: do not ignore hardware read error during DPK

Viktor Malik <vmalik@redhat.com>
    libbpf: Fix buffer overflow in bpf_object__init_prog

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix GCPS 64-bit member variables

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sbi->total_valid_block_count

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: fix duplicated data transmission

Jacob Moroni <jmoroni@google.com>
    IB/cm: use rwlock for MAD agent lock

Stone Zhang <quic_stonez@quicinc.com>
    wifi: ath11k: fix node corruption in ar->arvifs list

Huang Yiwei <quic_hyiwei@quicinc.com>
    firmware: SDEI: Allow sdei initialization without ACPI_APEI_GHES

Biju Das <biju.das.jz@bp.renesas.com>
    drm/tegra: rgb: Fix the unbound reference count

Kees Cook <kees@kernel.org>
    drm/vkms: Adjust vkms_state->active_planes allocation type

Biju Das <biju.das.jz@bp.renesas.com>
    drm: rcar-du: Fix memory leak in rcar_du_vsps_init()

Neill Kapron <nkapron@google.com>
    selftests/seccomp: fix syscall_restart test for arm compat

Miaoqian Lin <linmq006@gmail.com>
    firmware: psci: Fix refcount leak in psci_dt_init

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix macintosh_config for Mac II

Andrey Vatoropin <a.vatoropin@crpt.ru>
    fs/ntfs3: handle hdr_first_de() return value

Jonas Karlman <jonas@kwiboo.se>
    media: rkvdec: Fix frame size enumeration

Charles Han <hanchunchao@inspur.com>
    drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: sh-msiof: Fix maximum DMA transfer size

Armin Wolf <W_Armin@gmx.de>
    ACPI: OSI: Stop advertising support for "3.0 _SCP Extensions"

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()

Zijun Hu <quic_zijuhu@quicinc.com>
    PM: wakeup: Delete space in the end of string shown by pm_show_wakelocks()

Alexander Shiyan <eagle.alexander923@gmail.com>
    power: reset: at91-reset: Optimize at91_reset()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Fix general protection fault

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - move fallback ahash_request to the end of the struct

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: xts - Only add ecb if it is not already there

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lrw - Only add ecb if it is not already there

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Avoid empty transfer descriptor

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Handle zero-length skcipher requests

Ahmed S. Darwish <darwi@linutronix.de>
    x86/cpu: Sanitize CPUID(0x80000000) output

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions

Qing Wang <wangqing7171@gmail.com>
    perf/core: Fix broken throttling when max_samples_per_tick=1

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_create_inode error handling fix

Sergey Senozhatsky <senozhatsky@chromium.org>
    thunderbolt: Do not double dequeue a configuration request

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix timeout value in get_stb

Charles Yeh <charlesyeh522@gmail.com>
    USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: storage: Ignore UAS driver for SanDisk 3.2 Gen2 storage device

Jiayi Li <lijiayi@kylinos.cn>
    usb: quirks: Add NO_LPM quirk for SanDisk Extreme 55AE

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Fix offset calculation for .start_secs < 0

Alexandre Mergnat <amergnat@baylibre.com>
    rtc: Make rtc_time64_to_tm() support dates before 1970

Gautham R. Shenoy <gautham.shenoy@amd.com>
    acpi-cpufreq: Fix nominal_freq units to KHz in get_max_boost_ratio()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: set GPIO output value before setting direction

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: use correct OUTPUT_VAL register for GPIOs > 31

Pan Taixi <pantaixi@huaweicloud.com>
    tracing: Fix compilation warning on arm32


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   7 +-
 Makefile                                           |   8 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi          |   8 +
 arch/arm/boot/dts/at91sam9263ek.dts                |   2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |  13 +-
 arch/arm/boot/dts/tny_a9263.dts                    |   2 +-
 arch/arm/boot/dts/usb_a9263.dts                    |   4 +-
 arch/arm/mach-omap2/clockdomain.h                  |   1 +
 arch/arm/mach-omap2/clockdomains33xx_data.c        |   2 +-
 arch/arm/mach-omap2/cm33xx.c                       |  14 +-
 arch/arm/mach-omap2/pmic-cpcap.c                   |   6 +-
 arch/arm/mm/ioremap.c                              |   4 +-
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   1 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   1 +
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   8 -
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |  20 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/debug-monitors.h            |  12 -
 arch/arm64/include/asm/insn-def.h                  |  14 ++
 arch/arm64/include/asm/insn.h                      |  81 ++++++-
 arch/arm64/include/asm/spectre.h                   |   3 +
 arch/arm64/kernel/proton-pack.c                    |  21 +-
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/lib/insn.c                              | 199 +++++++++++++++--
 arch/arm64/net/bpf_jit.h                           |  11 +-
 arch/arm64/net/bpf_jit_comp.c                      |  58 ++++-
 arch/arm64/xen/hypercall.S                         |  21 +-
 arch/m68k/mac/config.c                             |   2 +-
 arch/mips/Makefile                                 |   6 +-
 .../boot/dts/loongson/loongson64c_4core_ls7a.dts   |   1 +
 arch/mips/loongson2ef/Platform                     |   2 +-
 arch/mips/vdso/Makefile                            |   1 +
 arch/nios2/include/asm/pgtable.h                   |  16 ++
 arch/parisc/boot/compressed/Makefile               |   1 +
 arch/powerpc/kernel/eeh.c                          |   2 +
 arch/powerpc/platforms/book3s/vas-api.c            |   9 +
 arch/powerpc/platforms/powernv/memtrace.c          |   8 +-
 arch/powerpc/platforms/pseries/msi.c               |   7 +-
 arch/s390/net/bpf_jit_comp.c                       |  12 +-
 arch/s390/pci/pci_mmio.c                           |   2 +-
 arch/x86/boot/compressed/Makefile                  |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/cpu/common.c                       |  17 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/ioport.c                           |  13 +-
 arch/x86/kernel/process.c                          |   6 +
 block/Kconfig                                      |   8 +-
 block/bdev.c                                       |   2 +-
 crypto/lrw.c                                       |   4 +-
 crypto/xts.c                                       |   4 +-
 drivers/acpi/acpica/dsutils.c                      |   9 +-
 drivers/acpi/acpica/psobject.c                     |  52 ++---
 drivers/acpi/acpica/utprint.c                      |   7 +-
 drivers/acpi/apei/Kconfig                          |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/battery.c                             |  19 +-
 drivers/acpi/bus.c                                 |   6 +-
 drivers/acpi/osi.c                                 |   1 -
 drivers/ata/pata_via.c                             |   3 +-
 drivers/atm/atmtcp.c                               |   4 +-
 drivers/base/power/domain.c                        |   2 +-
 drivers/base/power/main.c                          |   3 +-
 drivers/base/power/runtime.c                       |   2 +-
 drivers/base/swnode.c                              |   2 +-
 drivers/block/aoe/aoedev.c                         |   8 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/bus/fsl-mc/fsl-mc-uapi.c                   |   4 +-
 drivers/bus/fsl-mc/mc-io.c                         |  19 +-
 drivers/bus/fsl-mc/mc-sys.c                        |   2 +-
 drivers/bus/mhi/host/pm.c                          |  18 +-
 drivers/bus/ti-sysc.c                              |  49 ----
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +
 drivers/clk/meson/g12a.c                           |   1 +
 drivers/clk/qcom/gcc-msm8939.c                     |   4 +-
 drivers/clk/qcom/gcc-sm6350.c                      |   6 +
 drivers/clk/rockchip/clk-rk3036.c                  |   1 +
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/cpufreq.c                          |   6 +-
 drivers/cpufreq/scmi-cpufreq.c                     |  36 ++-
 drivers/cpufreq/tegra186-cpufreq.c                 |   7 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/marvell/cesa/cesa.c                 |   2 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   9 +-
 drivers/crypto/marvell/cesa/cipher.c               |   3 +
 drivers/crypto/marvell/cesa/hash.c                 |   2 +-
 drivers/crypto/marvell/cesa/tdma.c                 |  53 +++--
 drivers/dma-buf/udmabuf.c                          |   5 +-
 drivers/dma/ti/k3-udma.c                           |   3 +-
 drivers/edac/altera_edac.c                         |   6 +-
 drivers/edac/skx_common.c                          |   1 +
 drivers/firmware/Kconfig                           |   1 -
 drivers/firmware/arm_sdei.c                        |  11 +-
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c              |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 -
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   4 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  18 +-
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile      |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile      |   2 +-
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   3 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   8 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |   5 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   8 +-
 drivers/gpu/drm/meson/meson_drv.c                  |   2 +-
 drivers/gpu/drm/meson/meson_drv.h                  |   2 +-
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |  29 +--
 drivers/gpu/drm/meson/meson_vclk.c                 | 226 ++++++++++---------
 drivers/gpu/drm/meson/meson_vclk.h                 |  13 +-
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c              |   2 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   3 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c         |   7 +
 drivers/gpu/drm/msm/hdmi/hdmi_i2c.c                |  14 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |  10 +-
 drivers/gpu/drm/tegra/rgb.c                        |  14 +-
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   2 +-
 drivers/hid/hid-hyperv.c                           |   5 +-
 drivers/hid/usbhid/hid-core.c                      |  25 ++-
 drivers/hwmon/occ/common.c                         | 247 +++++++++------------
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  12 +-
 drivers/iio/accel/fxls8962af-core.c                |  15 +-
 drivers/iio/adc/ad7124.c                           |   4 +-
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |   8 +-
 drivers/infiniband/core/cm.c                       |  16 +-
 drivers/infiniband/core/iwcm.c                     |  29 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   1 -
 drivers/infiniband/hw/mlx5/qpc.c                   |  30 ++-
 drivers/input/misc/ims-pcu.c                       |   6 +
 drivers/input/misc/sparcspkr.c                     |  22 +-
 drivers/input/rmi4/rmi_f34.c                       | 135 ++++++-----
 drivers/iommu/amd/iommu.c                          |   8 +
 drivers/iommu/iommu.c                              |   4 +-
 drivers/md/dm-raid1.c                              |   5 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   4 +-
 drivers/media/i2c/ccs-pll.c                        |  23 +-
 drivers/media/i2c/imx334.c                         |  18 +-
 drivers/media/i2c/ov8856.c                         |   9 +-
 drivers/media/i2c/tc358743.c                       |   4 +
 drivers/media/platform/exynos4-is/fimc-is-regs.c   |   1 +
 drivers/media/platform/qcom/venus/core.c           |  16 +-
 drivers/media/platform/ti-vpe/cal-video.c          |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |   3 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     |   7 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  23 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  27 ++-
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/mfd/exynos-lpass.c                         |   1 -
 drivers/mfd/stmpe-spi.c                            |   2 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |  11 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +
 drivers/net/can/m_can/tcan4x5x-core.c              |   9 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |   6 +-
 drivers/net/ethernet/dlink/dl2k.c                  |  14 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |   3 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |  48 ++++
 drivers/net/ethernet/intel/ice/ice_sched.c         |  11 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   9 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  18 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  11 +-
 drivers/net/macsec.c                               |  40 +++-
 drivers/net/phy/mdio_bus.c                         |  16 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |   4 +-
 drivers/net/usb/aqc111.c                           |  10 +-
 drivers/net/usb/ch9200.c                           |   7 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  26 +++
 drivers/net/vxlan/vxlan_core.c                     |   8 +-
 drivers/net/wireguard/device.c                     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   3 +
 drivers/net/wireless/ath/carl9170/usb.c            |  19 +-
 drivers/net/wireless/intersil/p54/fwio.c           |   2 +
 drivers/net/wireless/intersil/p54/p54.h            |   1 +
 drivers/net/wireless/intersil/p54/txrx.c           |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   2 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  13 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  10 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   3 +-
 drivers/nvme/target/fcloop.c                       |  31 +--
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   5 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |  11 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   2 +-
 drivers/pci/pci.c                                  |   3 +-
 drivers/pci/pcie/dpc.c                             |   2 +-
 drivers/pci/quirks.c                               |  23 ++
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  35 +--
 drivers/pinctrl/pinctrl-at91.c                     |   6 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   8 +
 drivers/platform/x86/dell/dell_rbu.c               |   6 +-
 drivers/power/reset/at91-reset.c                   |   5 +-
 drivers/power/supply/bq27xxx_battery.c             |   2 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |  13 +-
 drivers/ptp/ptp_private.h                          |  12 +-
 drivers/rapidio/rio_cm.c                           |   3 +
 drivers/regulator/max14577-regulator.c             |   5 +-
 drivers/remoteproc/qcom_wcnss_iris.c               |   2 +
 drivers/remoteproc/remoteproc_core.c               |   6 +-
 drivers/rpmsg/qcom_smd.c                           |   2 +-
 drivers/rtc/class.c                                |   2 +-
 drivers/rtc/lib.c                                  |  24 +-
 drivers/rtc/rtc-sh.c                               |  12 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   2 +
 drivers/scsi/elx/efct/efct_hw.c                    |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/scsi_transport_iscsi.c                |  11 +-
 drivers/scsi/storvsc_drv.c                         |  10 +-
 drivers/scsi/ufs/ufshcd.c                          |   7 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  17 +-
 drivers/soc/ti/omap_prm.c                          |   8 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   2 +-
 drivers/spi/spi-sh-msiof.c                         |  13 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   2 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  24 +-
 drivers/tee/tee_core.c                             |  11 +-
 drivers/thermal/qcom/tsens.c                       |  10 +-
 drivers/thunderbolt/ctl.c                          |   5 +
 drivers/tty/serial/milbeaut_usio.c                 |   5 +-
 drivers/tty/serial/sh-sci.c                        |  97 ++++++--
 drivers/tty/vt/vt_ioctl.c                          |   2 -
 drivers/uio/uio_hv_generic.c                       |   4 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  21 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   4 +
 drivers/usb/class/usbtmc.c                         |  21 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/function/f_hid.c                |  12 +-
 drivers/usb/renesas_usbhs/common.c                 |  50 ++++-
 drivers/usb/serial/pl2303.c                        |   2 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/tcpm/tcpci_maxim.c               |   3 +-
 drivers/vfio/vfio_iommu_type1.c                    |   2 +-
 drivers/video/backlight/qcom-wled.c                |   6 +-
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/core/fbcvt.c                   |   2 +-
 drivers/video/fbdev/core/fbmem.c                   |   4 +-
 drivers/watchdog/da9052_wdt.c                      |   1 +
 fs/configfs/dir.c                                  |   2 +-
 fs/exfat/nls.c                                     |   1 +
 fs/ext4/ext4.h                                     |   8 +
 fs/ext4/extents.c                                  |  39 ++--
 fs/ext4/file.c                                     |   7 +-
 fs/ext4/inline.c                                   |   2 +-
 fs/ext4/inode.c                                    |   3 +-
 fs/ext4/ioctl.c                                    |   8 +-
 fs/ext4/super.c                                    |  15 +-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/f2fs.h                                     |  10 +-
 fs/f2fs/namei.c                                    |  19 +-
 fs/f2fs/super.c                                    |  12 +-
 fs/filesystems.c                                   |  14 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/gfs2/lock_dlm.c                                 |   3 +-
 fs/jbd2/transaction.c                              |   5 +-
 fs/jffs2/erase.c                                   |   4 +-
 fs/jffs2/scan.c                                    |   4 +-
 fs/jffs2/summary.c                                 |   7 +-
 fs/jfs/jfs_discard.c                               |   3 +-
 fs/jfs/jfs_dtree.c                                 |  18 +-
 fs/namespace.c                                     |   6 +-
 fs/nfs/super.c                                     |  19 ++
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfssvc.c                                   |   6 +-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/direct.c                                 |   3 +
 fs/ntfs3/index.c                                   |   8 +
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/squashfs/super.c                                |   5 +
 fs/xfs/xfs_inode.c                                 |  15 +-
 include/acpi/actypes.h                             |   2 +-
 include/linux/arm_sdei.h                           |   4 +-
 include/linux/atmdev.h                             |   6 +
 include/linux/hid.h                                |   3 +-
 include/linux/hugetlb.h                            |   3 +
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |   3 +
 include/linux/mm_types.h                           |   3 +
 include/net/checksum.h                             |   2 +-
 include/net/sock.h                                 |   7 +-
 include/trace/events/erofs.h                       |  18 --
 include/uapi/linux/bpf.h                           |   2 +
 include/uapi/linux/videodev2.h                     |  12 +-
 ipc/shm.c                                          |   5 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/events/core.c                               |  57 ++++-
 kernel/exit.c                                      |  17 +-
 kernel/power/wakelock.c                            |   3 +
 kernel/time/clocksource.c                          |   2 +-
 kernel/time/posix-cpu-timers.c                     |   9 +
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/ftrace.c                              |  10 +-
 kernel/trace/trace.c                               |   2 +-
 lib/Kconfig                                        |   1 +
 mm/huge_memory.c                                   |   2 +-
 mm/hugetlb.c                                       |  81 +++++--
 mm/mmap.c                                          |   8 +
 mm/page-writeback.c                                |   2 +-
 net/atm/common.c                                   |   1 +
 net/atm/lec.c                                      |  12 +-
 net/atm/raw.c                                      |   2 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bridge/br_multicast.c                          |  77 ++++++-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  12 +-
 net/core/filter.c                                  |   5 +-
 net/core/skmsg.c                                   |  25 ++-
 net/core/sock.c                                    |   4 +-
 net/core/utils.c                                   |   4 +-
 net/dsa/tag_brcm.c                                 |   2 +-
 net/ipv4/route.c                                   |   4 +
 net/ipv4/tcp_input.c                               |  63 +++---
 net/ipv6/calipso.c                                 |   8 +
 net/ipv6/ila/ila_common.c                          |   6 +-
 net/ipv6/netfilter.c                               |  12 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  13 +-
 net/ipv6/seg6_local.c                              |   6 +-
 net/mac80211/mesh_hwmp.c                           |   6 +-
 net/mpls/af_mpls.c                                 |   4 +-
 net/ncsi/internal.h                                |  21 +-
 net/ncsi/ncsi-pkt.h                                |  23 +-
 net/ncsi/ncsi-rsp.c                                |  21 +-
 net/netfilter/nft_quota.c                          |  20 +-
 net/netfilter/nft_set_pipapo_avx2.c                |  21 +-
 net/netfilter/nft_tunnel.c                         |   8 +-
 net/netlabel/netlabel_kapi.c                       |   5 +
 net/nfc/nci/uart.c                                 |   8 +-
 net/openvswitch/flow.c                             |   2 +-
 net/sched/sch_ets.c                                |  10 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sched/sch_red.c                                |   2 +-
 net/sched/sch_sfq.c                                | 121 ++++++----
 net/sched/sch_tbf.c                                |   2 +-
 net/sctp/socket.c                                  |   3 +-
 net/sunrpc/cache.c                                 |  17 +-
 net/tipc/crypto.c                                  |   8 +-
 net/tipc/udp_media.c                               |   4 +-
 net/tls/tls_sw.c                                   |   7 +
 scripts/Kconfig.include                            |   2 +-
 scripts/Makefile.clang                             |   3 +-
 scripts/Makefile.compiler                          |   8 +-
 scripts/as-version.sh                              |   2 +-
 scripts/gcc-plugins/gcc-common.h                   |  32 +++
 scripts/gcc-plugins/randomize_layout_plugin.c      |  40 +---
 security/selinux/xfrm.c                            |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/tas2770.c                         |  30 ++-
 sound/soc/meson/meson-card-utils.c                 |   2 +-
 sound/soc/qcom/sdm845.c                            |   4 +
 sound/soc/tegra/tegra210_ahub.c                    |   2 +
 sound/usb/implicit.c                               |   1 +
 sound/usb/mixer_maps.c                             |  12 +
 tools/include/uapi/linux/bpf.h                     |   2 +
 tools/lib/bpf/bpf_core_read.h                      |   6 +
 tools/lib/bpf/btf.c                                |  16 ++
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/lib/bpf/linker.c                             |   4 +-
 tools/lib/bpf/nlattr.c                             |  15 +-
 tools/perf/Makefile.config                         |   2 +
 tools/perf/builtin-record.c                        |   2 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |   5 +-
 tools/perf/tests/switch-tracking.c                 |   2 +-
 tools/perf/ui/browsers/hists.c                     |   2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   7 +-
 tools/testing/selftests/x86/Makefile               |   2 +-
 tools/testing/selftests/x86/sigtrap_loop.c         | 101 +++++++++
 usr/include/Makefile                               |   2 +-
 392 files changed, 3155 insertions(+), 1436 deletions(-)


