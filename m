Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779B1252912;
	Mon, 23 Jun 2025 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684182; cv=none; b=CDgBSAOd3pHB725m9SEsP8iI8hmTFmDdgQfD8/LWyiTSaPbOZIT/9OumI4xIGqHkfJJ8VTdSab4c5BkvdMDwvvB4R6AE+j6EYTQ+RFkzoP8SKJiByMJHFlYsaJVKQDWfqA2h0jVdHoAkZoaYpnhdfoGTe7ERkJQnG7PWux9is2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684182; c=relaxed/simple;
	bh=H8oY4e+rb3MN1w/SPP5dy1QgswC0xsocSqfoaCdrzW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dTHXrkViG3mvRDR/sAiRyXVIea4OGUITUExycmFZvLz2iHYQYZzB7BjSBeMelMdGyZ+Mpn5ewIC67TBNp2hrinEkyj9AiI3CCgH/Q70X+tfWgXX4IIk2C7tPMiI6hW0oBkbXK+Nq2kJ9XgbCepyjmxv6yTQC7Z4xqg/nb36YXRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmKToVJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmKToVJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6835DC4CEEA;
	Mon, 23 Jun 2025 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684182;
	bh=H8oY4e+rb3MN1w/SPP5dy1QgswC0xsocSqfoaCdrzW8=;
	h=From:To:Cc:Subject:Date:From;
	b=WmKToVJkg7xwgVU9x8RkbuooyguCiNpiU9VICkcugmylxZO1a96UiWXHcvgR8v+rx
	 eHJfUo+RKuUmN6/2vR3XoWHDtij2TgbGbxMhcMv8u+k2Z4XueqYub19tCASM1K1FOf
	 ndQ2ocCyMzPQkxkHnZ2c5Q/7qcnxRPUg1RoqSaGY=
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
Subject: [PATCH 6.1 000/508] 6.1.142-rc1 review
Date: Mon, 23 Jun 2025 15:00:45 +0200
Message-ID: <20250623130645.255320792@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.142-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.142-rc1
X-KernelTest-Deadline: 2025-06-25T13:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.142 release.
There are 508 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Jun 2025 13:05:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.142-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.142-rc1

Anup Patel <apatel@ventanamicro.com>
    RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs

Anup Patel <apatel@ventanamicro.com>
    RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()

Tengda Wu <wutengda@huaweicloud.com>
    arm64/ptrace: Fix stack-out-of-bounds read in regs_get_kernel_stack_nth()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix sample vs do_exit()

Heiko Carstens <hca@linux.ibm.com>
    s390/pci: Fix __pcilg_mio_inuser() inline assembly

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Add backlight power control support

zhangjian <zhangjian496@huawei.com>
    smb: client: fix first command failure during re-negotiation

Jon Hunter <jonathanh@nvidia.com>
    Revert "cpufreq: tegra186: Share policy per cluster"

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Increment the runtime usage counter for the earlycon device

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mm: Drop sd-vsel-gpios from i.MX8M Mini Verdin SoM

Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
    arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: am335x-bone-common: Increase MDIO reset deassert delay to 50ms

Colin Foster <colin.foster@in-advantage.com>
    ARM: dts: am335x-bone-common: Increase MDIO reset deassert time

Shengyu Qu <wiagn233@outlook.com>
    ARM: dts: am335x-bone-common: Add GPIO PHY reset on revision C3 board

Renato Caldas <renato@calgera.com>
    platform/x86: ideapad-laptop: add missing Ideapad Pro 5 fn keys

Akhil R <akhilrajeev@nvidia.com>
    dt-bindings: i2c: nvidia,tegra20-i2c: Specify the required properties

Eric Dumazet <edumazet@google.com>
    net: atm: fix /proc/net/atm/lec handling

Eric Dumazet <edumazet@google.com>
    net: atm: add lec_mutex

Kuniyuki Iwashima <kuniyu@google.com>
    calipso: Fix null-ptr-deref in calipso_req_{set,del}attr().

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()

Rengarajan S <rengarajan.s@microchip.com>
    net: microchip: lan743x: Reduce PTP timeout on HW failure

David Wei <dw@davidwei.uk>
    tcp: fix passive TFO socket having invalid NAPI ID

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
    ptp: allow reading of currently dialed frequency to succeed on free-running clocks

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

Jacob Keller <jacob.e.keller@intel.com>
    drm/nouveau/bl: increase buffer size to avoid truncate warning

Brett Creeley <brett.creeley@amd.com>
    ionic: Prevent driver/fw getting out of sync on devcmd(s)

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate

James A. MacInnes <james.a.macinnes@gmail.com>
    drm/msm/disp: Correct porch timing for SDM845

Gao Xiang <xiang@kernel.org>
    erofs: remove unused trace event erofs_destroy_inode

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE

Paul Chaignon <paul.chaignon@gmail.com>
    net: Fix checksum update for ILA adj-transport

Gavin Guo <gavinguo@igalia.com>
    mm/huge_memory: fix dereferencing invalid pmd migration entry

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

Edward Adam Davis <eadavis@qq.com>
    wifi: cfg80211: init wiphy_work before allocating rfkill fails

WangYuli <wangyuli@uniontech.com>
    Input: sparcspkr - avoid unannotated fall-through

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Revert atm_account_tx() if copy_from_iter_full() fails.

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference in destroy_previous_session

Xin Li (Intel) <xin@zytor.com>
    selftests/x86: Add a test to detect infinite SIGTRAP handler loop

Marek Szyprowski <m.szyprowski@samsung.com>
    udmabuf: use sgtable-based scatterlist wrappers

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: reject invalid perturb period

Peter Oberparleiter <oberpar@linux.ibm.com>
    scsi: s390: zfcp: Ensure synchronous unit_add

Dexuan Cui <decui@microsoft.com>
    scsi: storvsc: Increase the timeouts to storvsc_timeout

Bharath SM <bharathsm.hsk@gmail.com>
    smb: improve directory cache reuse for readdir operations

Fedor Pchelkin <pchelkin@ispras.ru>
    jffs2: check jffs2_prealloc_raw_node_refs() result in few other places

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    jffs2: check that raw node were preallocated before writing summary

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Avoid using $r0/$r1 as "mask" for csrxchg

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Unregister generic_sub_drivers on exit

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Get brightness setting from EC on probe

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

Kees Cook <kees@kernel.org>
    fbcon: Make sure modelist not set on unregistered console

Wentao Liang <vulab@iscas.ac.cn>
    octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Use TOE/TSO on all TCP

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix data lost during EAGAIN retries

Mateusz Pacuszka <mateuszx.pacuszka@intel.com>
    ice: fix check for existing switch rule

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

Yong Wang <yongwang@nvidia.com>
    net: bridge: mcast: update multicast contex when vlan state is changed

Edward Adam Davis <eadavis@qq.com>
    wifi: mac80211_hwsim: Prevent tsf from setting if beacon is disabled

Sean Christopherson <seanjc@google.com>
    iommu/amd: Ensure GA log notifier callbacks finish running before module unload

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Add identical pointer detection to btf_dedup_is_equiv()

Heiko Stuebner <heiko@sntech.de>
    clk: rockchip: rk3036: mark ddrphy as critical

Martin KaFai Lau <martin.lau@kernel.org>
    bpftool: Fix cgroup command to only show cgroup bpf programs

Benjamin Berg <benjamin@sipsolutions.net>
    wifi: mac80211: do not offer a mesh path if forwarding is disabled

Salah Triki <salah.triki@gmail.com>
    wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()

Stefan Wahren <wahrenst@gmx.net>
    net: vertexcom: mse102x: Return code for mse102x_rx_pkt_spi

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

Andrew Zaborowski <andrew.zaborowski@intel.com>
    x86/sgx: Prevent attempts to reclaim poisoned pages

Eric Dumazet <edumazet@google.com>
    tcp: fix initial tp->rcvq_space.space value for passive TS enabled flows

Eric Dumazet <edumazet@google.com>
    tcp: always seek for minimal rtt in tcp_rcv_rtt_update()

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: ath11k: Fix QMI memory reuse logic

Moon Yeounsu <yyyynoom@gmail.com>
    net: dlink: add synchronization for stats update

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Add clock toggle recovery

Akhil R <akhilrajeev@nvidia.com>
    i2c: tegra: check msg length in SMBUS block read

Mike Tipton <quic_mdtipton@quicinc.com>
    cpufreq: scmi: Skip SCMI devices that aren't used by the CPUs

Petr Malat <oss@malat.biz>
    sctp: Do not wake readers in __sctp_write_space()

Samuel Williams <sam8641@gmail.com>
    wifi: mt76: mt7921: add 160 MHz AP for mt7922 device

Henk Vergonet <henk.vergonet@gmail.com>
    wifi: mt76: mt76x2: Add support for LiteOn WN4516R,WN4519R

Alok Tiwari <alok.a.tiwari@oracle.com>
    emulex/benet: correct command version selection in be_cmd_get_stats()

Tan En De <ende.tan@starfivetech.com>
    i2c: designware: Invoke runtime suspend on quick slave re-registration

Hou Tao <houtao1@huawei.com>
    bpf: Check rcu_read_lock_trace_held() in bpf_map_lookup_percpu_elem()

Zilin Guan <zilin@seu.edu.cn>
    tipc: use kfree_sensitive() for aead cleanup

Rengarajan S <rengarajan.s@microchip.com>
    net: lan743x: Modify the EEPROM and OTP size for PCI1xxxx devices

Sergio Perez Gonzalez <sperezglz@gmail.com>
    net: macb: Check return value of dma_set_mask_and_coherent()

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

Erick Shepherd <erick.shepherd@ni.com>
    mmc: Add quirk to disable DDR50 tuning

Guilherme G. Piccoli <gpiccoli@igalia.com>
    clocksource: Fix the CPUs' choice in the watchdog per CPU verification

Talhah Peerbhai <talhah.peerbhai@gmail.com>
    ASoC: amd: yc: Add quirk for Lenovo Yoga Pro 7 14ASP9

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

Shyam Prasad N <sprasad@microsoft.com>
    cifs: reset connections for all channels when reconnect requested

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

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY

Qasim Ijaz <qasdev00@gmail.com>
    net: ch9200: fix uninitialised access during mii_nway_restart

Ye Bin <yebin10@huawei.com>
    ftrace: Fix UAF when lookup kallsym after ftrace disabled

Mikulas Patocka <mpatocka@redhat.com>
    dm-mirror: fix a tiny race condition

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Clear current_vmcb during vCPU free for all *possible* CPUs

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

Helge Deller <deller@gmx.de>
    parisc/unaligned: Fix hex output to show 8 hex chars

Murad Masimov <m.masimov@mt-integration.ru>
    fbdev: Fix fb_set_var to prevent null-ptr-deref in fb_videomode_to_var

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    EDAC/altera: Use correct write width with the INTTEST register

Heiner Kallweit <hkallweit1@gmail.com>
    net: ftgmac100: select FIXED_PHY

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    NFC: nci: uart: Set tty->disc_data only in success path

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sit_bitmap_size

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: prevent kernel warning due to negative i_nlink from corrupted image

Gatien Chevallier <gatien.chevallier@foss.st.com>
    Input: gpio-keys - fix possible concurrent access in gpio_keys_irq_timer()

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

Chen Ridong <chenridong@huawei.com>
    cgroup,freezer: fix incomplete freezing when attaching tasks

Dennis Marttinen <twelho@welho.tech>
    ceph: set superblock s_magic for IMA fsmagic matching

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

Ming Qian <ming.qian@oss.nxp.com>
    media: imx-jpeg: Drop the first error frames

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

Marek Szyprowski <m.szyprowski@samsung.com>
    media: omap3isp: use sgtable-based scatterlist wrappers

Wentao Liang <vulab@iscas.ac.cn>
    media: gspca: Add error handling for stv06xx_read_sensor()

Dmitry Nikiforov <Dm1tryNk@yandex.ru>
    media: davinci: vpif: Fix memory leak in probe error path

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

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix ring-buffer corruption

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix rx completion meta data corruption

Christian Lamparter <chunkeey@gmail.com>
    wifi: p54: prevent buffer-overflow in p54_rx_eeprom_readback()

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: Add error handling in mlx5_query_nic_vport_node_guid()

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5_core: Add error handling inmlx5_query_nic_vport_qkey_viol_cntr()

João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>
    regulator: max20086: Change enable gpio to optional

João Paulo Gonçalves <jpaulo.silvagoncalves@gmail.com>
    regulator: max20086: Fix MAX200086 chip id

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries/msi: Avoid reading PCI device registers in reduced power states

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: account drain memory to cgroup

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
    kbuild: Add KBUILD_CPPFLAGS to as-option invocation

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add CLANG_FLAGS to as-instr

Nathan Chancellor <nathan@kernel.org>
    mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation

Nathan Chancellor <nathan@kernel.org>
    drm/amd/display: Do not add '-mhard-float' to dml_ccflags for clang

Oleg Nesterov <oleg@redhat.com>
    posix-cpu-timers: fix race between handle_posix_cpu_timers() and posix_cpu_timer_del()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "io_uring: ensure deferred completions are posted for multishot"

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: usbhid: Eliminate recurrent out-of-bounds bug in usbhid_parse()

David Heimann <d@dmeh.net>
    ALSA: usb-audio: Add implicit feedback quirk for RODE AI-1

Suleiman Souhlal <suleiman@google.com>
    tools/resolve_btfids: Fix build when cross compiling kernel with clang.

Matthew Wilcox (Oracle) <willy@infradead.org>
    bio: Fix bio_first_folio() for SPARSEMEM without VMEMMAP

Peter Zijlstra <peterz@infradead.org>
    perf: Ensure bpf_perf_link path is properly serialized

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: access fcpreq only when holding reqlock

Zijun Hu <quic_zijuhu@quicinc.com>
    fs/filesystems: Fix potential unsigned integer underflow in fs_name()

Eric Dumazet <edumazet@google.com>
    net_sched: ets: fix a race in ets_qdisc_change()

Eric Dumazet <edumazet@google.com>
    net_sched: tbf: fix a race in tbf_change()

Eric Dumazet <edumazet@google.com>
    net_sched: red: fix a race in __red_change()

Eric Dumazet <edumazet@google.com>
    net_sched: prio: fix a race in prio_tune()

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix leak of Geneve TLV option object

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix return value when searching for existing flow group

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Ensure fw pages are always allocated on same NUMA

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix sparse errors

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix NULL pointer deference on eir_get_service_data

Jakub Raczynski <j.raczynski@samsung.com>
    net/mdiobus: Fix potential out-of-bounds read/write access

Andrew Lunn <andrew@lunn.ch>
    net: mdio: C22 is now optional, EOPNOTSUPP if not provided

Carlos Fernandez <carlos.fernandez@technica-engineering.de>
    macsec: MACsec SCI assignment for ES = 0

Michal Luczaj <mhal@rbox.co>
    net: Fix TOCTOU issue in sk_is_readable()

Yunhui Cui <cuiyunhui@bytedance.com>
    ACPI: CPPC: Fix NULL pointer dereference when nosmp is used

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

Wojciech Slenska <wojciech.slenska@gmail.com>
    pinctrl: qcom: pinctrl-qcm2290: Add missing pins

Dan Carpenter <dan.carpenter@linaro.org>
    regulator: max20086: Fix refcount leak in max20086_parse_regulators_dt()

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    wifi: ath11k: validate ath11k_crypto_mode on top of ath11k_core_qmi_firmware_ready

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't wait when there is no vdev started

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't use static variables in ath11k_debugfs_fw_stats_process()

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()

Easwar Hariharan <eahariha@linux.microsoft.com>
    wifi: ath11k: convert timeouts to secs_to_jiffies()

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: ath11k: fix soc_dp_stats debugfs file permission

Govindaraj Saminathan <quic_gsaminat@quicinc.com>
    wifi: ath11k: remove unused function ath11k_tm_event_wmi()

Caleb Connolly <caleb.connolly@linaro.org>
    ath10k: snoc: fix unbalanced IRQ enable in crash recovery

Jeongjun Park <aha310510@gmail.com>
    ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix UAF on mgmt_remove_adv_monitor_complete

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_core: fix list_for_each_entry_rcu usage

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

Gabor Juhos <j4g8y7@gmail.com>
    arm64: dts: marvell: uDPU: define pinctrl state for alarm LEDs

Dan Carpenter <dan.carpenter@linaro.org>
    pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()

Darrick J. Wong <djwong@kernel.org>
    xfs: reset rootdir extent size hint after growfsrt

Darrick J. Wong <djwong@kernel.org>
    xfs: take m_growlock when running growfsrt

Darrick J. Wong <djwong@kernel.org>
    xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code

Zizhi Wo <wozizhi@huawei.com>
    xfs: Fix the owner setting issue for rmap query in xfs fsmap

Darrick J. Wong <djwong@kernel.org>
    xfs: conditionally allow FS_XFLAG_REALTIME changes if S_DAX is set

Darrick J. Wong <djwong@kernel.org>
    xfs: attr forks require attr, not attr2

Julian Sun <sunjunchao2870@gmail.com>
    xfs: remove unused parameter in macro XFS_DQUOT_LOGRES

lei lu <llfamsec@gmail.com>
    xfs: don't walk off the end of a directory data block

John Garry <john.g.garry@oracle.com>
    xfs: Fix xfs_prepare_shift() range for RT

John Garry <john.g.garry@oracle.com>
    xfs: Fix xfs_flush_unmap_range() range for RT

Darrick J. Wong <djwong@kernel.org>
    xfs: create a new helper to return a file's allocation unit

Darrick J. Wong <djwong@kernel.org>
    xfs: declare xfs_file.c symbols in xfs_file.h

Darrick J. Wong <djwong@kernel.org>
    xfs: use consistent uid/gid when grabbing dquots for inodes

Darrick J. Wong <djwong@kernel.org>
    xfs: verify buffer, inode, and dquot items every tx commit

Christoph Hellwig <hch@lst.de>
    xfs: fix the contact address for the sysfs ABI documentation

Darrick J. Wong <djwong@kernel.org>
    xfs: fix an agbno overflow in __xfs_getfsmap_datadev

Darrick J. Wong <djwong@kernel.org>
    xfs: fix xfs_btree_query_range callers to initialize btree rec fully

Darrick J. Wong <djwong@kernel.org>
    xfs: validate fsmap offsets specified in the query keys

Darrick J. Wong <djwong@kernel.org>
    xfs: fix logdev fsmap query result filtering

Darrick J. Wong <djwong@kernel.org>
    xfs: clean up the rtbitmap fsmap backend

Darrick J. Wong <djwong@kernel.org>
    xfs: fix getfsmap reporting past the last rt extent

Darrick J. Wong <djwong@kernel.org>
    xfs: fix integer overflows in the fsmap rtbitmap and logdev backends

Darrick J. Wong <djwong@kernel.org>
    xfs: fix interval filtering in multi-step fsmap queries

Al Viro <viro@zeniv.linux.org.uk>
    do_change_type(): refuse to operate on unmounted/not ours mounts

Al Viro <viro@zeniv.linux.org.uk>
    fix propagation graph breakage by MOVE_MOUNT_SET_GROUP move_mount(2)

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix deadlock when the failing IPC is SET_D0IX

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: hda: Fix RPM usage count underflow

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

Shiming Cheng <shiming.cheng@mediatek.com>
    net: fix udp gso skb_segment after pull from frag_list

Alexis Lothoré <alexis.lothore@bootlin.com>
    net: stmmac: make sure that ptp_rate is not 0 before configuring timestamping

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: tag_brcm: legacy: fix pskb_may_pull length

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix rebuilding the Tx scheduler tree for large queue counts

Michal Kubiak <michal.kubiak@intel.com>
    ice: create new Tx scheduler nodes for new queues only

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not responding with L2CAP_CR_LE_ENCRYPTION

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-hsspi: fix shared reset

Álvaro Fernández Rojas <noltari@gmail.com>
    spi: bcm63xx-spi: fix shared reset

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Make sure to insert the vlan tags also in host mode

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

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: prevent deactivate active config while enabling the config

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    counter: interrupt-cnt: Protect enable/disable OPs with mutex

WangYuli <wangyuli@uniontech.com>
    MIPS: Loongson64: Add missing '#interrupt-cells' for loongson64c_ls7a

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    iio: adc: ad7124: Fix 3dB filter frequency reading

Brian Pellegrino <bpellegrino@arka.org>
    iio: filter: admv8818: Support frequencies >= 2^32

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix range calculation

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix integer overflow

Sam Winchenbach <swinchenbach@arka.org>
    iio: filter: admv8818: fix band 4, state 15

Henry Martin <bsdhenrymartin@gmail.com>
    serial: Fix potential null-ptr-deref in mlb_usio_probe()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    usb: renesas_usbhs: Reorder clock handling and power management in probe

Bjorn Helgaas <bhelgaas@google.com>
    PCI/DPC: Initialize aer_err_info before using it

Henry Martin <bsdhenrymartin@gmail.com>
    dmaengine: ti: Add NULL check in udma_probe()

Chenyuan Yang <chenyuan0y@gmail.com>
    phy: qcom-qmp-usb: Fix an NULL vs IS_ERR() bug

Hector Martin <marcan@marcan.st>
    PCI: apple: Use gpiod_set_value_cansleep in probe flow

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

Siddharth Vadapalli <s-vadapalli@ti.com>
    remoteproc: k3-r5: Drop check performed in k3_r5_rproc_{mbox_callback/kick}

Dan Carpenter <dan.carpenter@linaro.org>
    remoteproc: qcom_wcnss_iris: Add missing put_device() on error in probe

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix pattern matching with Python 3

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix PEBS-via-PT data_src

Alexei Safin <a.safin@rosa.ru>
    hwmon: (asus-ec-sensors) check sensor index in read_string()

Mikhail Arkhipov <m.arhipov@rosa.ru>
    mtd: nand: ecc-mxic: Fix use of uninitialized variable ret

Henry Martin <bsdhenrymartin@gmail.com>
    backlight: pm8941: Add NULL check in wled_configure()

Benjamin Marzinski <bmarzins@redhat.com>
    dm: free table mempools if not used in __bind

Benjamin Marzinski <bmarzins@redhat.com>
    dm: don't change md if dm_table_set_restrictions() fails

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

Joel Stanley <joel@jms.id.au>
    ARM: aspeed: Don't select SRAM

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Rename RTC node to match binding expectations

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou

Vignesh Raman <vignesh.raman@collabora.com>
    arm64: defconfig: mediatek: enable PHY drivers

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ARM: dts: qcom: apq8064 merge hw splinlock into corresponding syscon device

Andre Przywara <andre.przywara@arm.com>
    dt-bindings: vendor-prefixes: Add Liontron name

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

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-lavender: Add missing USB phy supply

Julien Massot <julien.massot@collabora.com>
    arm64: dts: mt6359: Add missing 'compatible' property to regulators node

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix RTC capacitive load

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix RTC capacitive load

Alexey Minnekhanov <alexeymin@postmarketos.org>
    arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8195: Reparent vdec1/2 and venc1 power domains

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: at91sam9263: fix NAND chip selects

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select

Xilin Wu <wuxilin123@gmail.com>
    arm64: dts: qcom: sm8250: Fix CPU7 opp table

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

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: mscc: Fix memory leak when using one step timestamping

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: rename lan743x_reset_phy to lan743x_hw_reset_phy

KaFai Wan <mannkafai@gmail.com>
    bpf: Avoid __bpf_prog_ret0_warn when jit fails

Jack Morgenstein <jackm@nvidia.com>
    RDMA/cma: Fix hang when cma_netevent_callback fails to queue_work

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: aqc111: fix error handling of usbnet read calls

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_tunnel: fix geneve_opt dump

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Avoid using sk_socket after free when sending

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: MGMT: iterate over mesh commands in mgmt_mesh_foreach()

Li RongQing <lirongqing@baidu.com>
    vfio/type1: Fix error unwind in migration dirty bitmap allocation

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy

Michal Koutný <mkoutny@suse.com>
    kernfs: Relax constraint in draining guard

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: ath9k_htc: Abort software beacon handling if disabled

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: add eq and aeq interruption restore

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: fix XQE dma address error

Rolf Eike Beer <eb@emlix.com>
    iommu: remove duplicate selection of DMAR_TABLE

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

Miaoqian Lin <linmq006@gmail.com>
    tracing: Fix error handling in event_trigger_parse()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Rename event_trigger_alloc() to trigger_data_alloc()

Hans Zhang <18255117159@163.com>
    efi/libstub: Describe missing 'out' parameter in efi_load_initrd

Henry Martin <bsdhenrymartin@gmail.com>
    clk: bcm: rpi: Add NULL check in raspberrypi_clk_register()

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gpucc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add *_wait_val values for GDSCs

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: dispcc-sm6350: Add *_wait_val values for GDSCs

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

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk

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
    bpf, sockmap: Fix panic when calling skb_linearize

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: fix duplicated data transmission

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: fix ktls panic with sockmap

Jacob Moroni <jmoroni@google.com>
    IB/cm: use rwlock for MAD agent lock

Stone Zhang <quic_stonez@quicinc.com>
    wifi: ath11k: fix node corruption in ar->arvifs list

Kees Cook <kees@kernel.org>
    scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops

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

Kornel Dulęba <korneld@google.com>
    arm64: Support ARM64_VA_BITS=52 when setting ARCH_MMAP_RND_BITS_MAX

Miaoqian Lin <linmq006@gmail.com>
    firmware: psci: Fix refcount leak in psci_dt_init

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix macintosh_config for Mac II

Kees Cook <kees@kernel.org>
    watchdog: exar: Shorten identity name to fit correctly

Andrey Vatoropin <a.vatoropin@crpt.ru>
    fs/ntfs3: handle hdr_first_de() return value

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: Fix merging of FPSIMD state during signal return

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Discard stale CPU state when handling SME traps

Jonas Karlman <jonas@kwiboo.se>
    media: rkvdec: Fix frame size enumeration

Charles Han <hanchunchao@inspur.com>
    drm/amd/pp: Fix potential NULL pointer dereference in atomctrl_initialize_mc_reg_table

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add seqno waiter for sync_files

Martin Povišer <povik+lin@cutebit.org>
    ASoC: apple: mca: Constrain channels according to TDM mask

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

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: modify chip select (CS) deactivation

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: remove redundant error handling code

Vishwaroop A <va@nvidia.com>
    spi: tegra210-quad: Fix X1_X2_X4 encoding and support x4 transfers

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Fix general protection fault

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Enable main IRQs

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

Eddie James <eajames@linux.ibm.com>
    powerpc/crash: Fix non-smp kexec preparation

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun8i-ss - do not use sg_dma_len before calling DMA functions

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce-cipher - fix error handling in sun8i_ce_cipher_prepare()

Qing Wang <wangqing7171@gmail.com>
    perf/core: Fix broken throttling when max_samples_per_tick=1

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: gfs2_create_inode error handling fix

Sergey Senozhatsky <senozhatsky@chromium.org>
    thunderbolt: Do not double dequeue a configuration request

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix timeout value in get_stb

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    Bluetooth: hci_qca: move the SoC type check to the right place

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

Peter Xu <peterx@redhat.com>
    mm/uffd: fix vma operation where start addr cuts part of vma


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-xfs             |   8 +-
 Documentation/admin-guide/kernel-parameters.txt    |   2 -
 .../bindings/i2c/nvidia,tegra20-i2c.yaml           |  24 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 Makefile                                           |   8 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi          |   8 +
 arch/arm/boot/dts/at91sam9263ek.dts                |   2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |  13 +-
 arch/arm/boot/dts/tny_a9263.dts                    |   2 +-
 arch/arm/boot/dts/usb_a9263.dts                    |   4 +-
 arch/arm/mach-aspeed/Kconfig                       |   1 -
 arch/arm/mach-omap2/clockdomain.h                  |   1 +
 arch/arm/mach-omap2/clockdomains33xx_data.c        |   2 +-
 arch/arm/mach-omap2/cm33xx.c                       |  14 +-
 arch/arm/mach-omap2/pmic-cpcap.c                   |   6 +-
 arch/arm/mm/ioremap.c                              |   4 +-
 arch/arm64/Kconfig                                 |   6 +-
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   1 +
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   1 -
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   1 +
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   8 +-
 arch/arm64/boot/dts/mediatek/mt6359.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |  50 ++--
 .../arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts |   2 +
 .../arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts |   3 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   2 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   8 -
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |  20 +-
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |  31 +++
 arch/arm64/configs/defconfig                       |   3 +
 arch/arm64/kernel/fpsimd.c                         |   4 +-
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/xen/hypercall.S                         |  21 +-
 arch/loongarch/include/asm/irqflags.h              |  16 +-
 arch/m68k/mac/config.c                             |   2 +-
 arch/mips/Makefile                                 |   2 +-
 .../boot/dts/loongson/loongson64c_4core_ls7a.dts   |   1 +
 arch/mips/vdso/Makefile                            |   1 +
 arch/parisc/boot/compressed/Makefile               |   1 +
 arch/parisc/kernel/unaligned.c                     |   2 +-
 arch/powerpc/kernel/eeh.c                          |   2 +
 arch/powerpc/kexec/crash.c                         |   5 +-
 arch/powerpc/platforms/book3s/vas-api.c            |   9 +
 arch/powerpc/platforms/powernv/memtrace.c          |   8 +-
 arch/powerpc/platforms/pseries/msi.c               |   7 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   8 +-
 arch/s390/kvm/gaccess.c                            |   8 +-
 arch/s390/net/bpf_jit_comp.c                       |  12 +-
 arch/s390/pci/pci_mmio.c                           |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/cpu/common.c                       |  17 +-
 arch/x86/kernel/cpu/mtrr/generic.c                 |   2 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   2 +
 arch/x86/kernel/ioport.c                           |  13 +-
 arch/x86/kernel/process.c                          |   6 +
 arch/x86/kvm/svm/svm.c                             |   2 +-
 crypto/lrw.c                                       |   4 +-
 crypto/xts.c                                       |   4 +-
 drivers/acpi/acpica/dsutils.c                      |   9 +-
 drivers/acpi/acpica/psobject.c                     |  52 ++--
 drivers/acpi/acpica/utprint.c                      |   7 +-
 drivers/acpi/apei/Kconfig                          |   1 +
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/battery.c                             |  19 +-
 drivers/acpi/bus.c                                 |   6 +-
 drivers/acpi/cppc_acpi.c                           |   2 +-
 drivers/acpi/osi.c                                 |   1 -
 drivers/ata/pata_via.c                             |   3 +-
 drivers/atm/atmtcp.c                               |   4 +-
 drivers/base/power/domain.c                        |   2 +-
 drivers/base/power/main.c                          |   3 +-
 drivers/base/power/runtime.c                       |   2 +-
 drivers/base/swnode.c                              |   2 +-
 drivers/block/aoe/aoedev.c                         |   8 +
 drivers/bluetooth/hci_qca.c                        |  14 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   6 +-
 drivers/bus/fsl-mc/fsl-mc-uapi.c                   |   4 +-
 drivers/bus/fsl-mc/mc-io.c                         |  19 +-
 drivers/bus/fsl-mc/mc-sys.c                        |   2 +-
 drivers/bus/mhi/host/pm.c                          |  18 +-
 drivers/bus/ti-sysc.c                              |  49 ----
 drivers/clk/bcm/clk-raspberrypi.c                  |   2 +
 drivers/clk/meson/g12a.c                           |   1 +
 drivers/clk/qcom/dispcc-sm6350.c                   |   3 +
 drivers/clk/qcom/gcc-msm8939.c                     |   4 +-
 drivers/clk/qcom/gcc-sm6350.c                      |   6 +
 drivers/clk/qcom/gpucc-sm6350.c                    |   6 +
 drivers/clk/rockchip/clk-rk3036.c                  |   1 +
 drivers/counter/interrupt-cnt.c                    |   9 +
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |  36 ++-
 drivers/cpufreq/tegra186-cpufreq.c                 |   7 -
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   7 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/marvell/cesa/cesa.c                 |   2 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   9 +-
 drivers/crypto/marvell/cesa/cipher.c               |   3 +
 drivers/crypto/marvell/cesa/hash.c                 |   2 +-
 drivers/crypto/marvell/cesa/tdma.c                 |  53 ++--
 drivers/dma-buf/udmabuf.c                          |   5 +-
 drivers/dma/ti/k3-udma.c                           |   3 +-
 drivers/edac/altera_edac.c                         |   6 +-
 drivers/edac/skx_common.c                          |   1 +
 drivers/firmware/Kconfig                           |   1 -
 drivers/firmware/arm_sdei.c                        |  11 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |   1 +
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/gpu/drm/amd/display/dc/dml/Makefile        |   3 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   8 +
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/meson/meson_drv.c                  |   2 +-
 drivers/gpu/drm/meson/meson_drv.h                  |   2 +-
 drivers/gpu/drm/meson/meson_encoder_hdmi.c         |  29 ++-
 drivers/gpu/drm/meson/meson_vclk.c                 | 226 +++++++++--------
 drivers/gpu/drm/meson/meson_vclk.h                 |  13 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |  14 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c         |   7 +
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_kms.c              |  10 +-
 drivers/gpu/drm/tegra/rgb.c                        |  14 +-
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  26 ++
 drivers/hid/hid-hyperv.c                           |   4 +-
 drivers/hid/usbhid/hid-core.c                      |  25 +-
 drivers/hwmon/asus-ec-sensors.c                    |   4 +
 drivers/hwmon/occ/common.c                         | 238 ++++++++----------
 drivers/hwtracing/coresight/coresight-config.h     |   2 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |  49 ++--
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  12 +-
 drivers/i2c/busses/i2c-tegra.c                     |   5 +
 drivers/iio/accel/fxls8962af-core.c                |  15 +-
 drivers/iio/adc/ad7124.c                           |   4 +-
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/filter/admv8818.c                      | 230 ++++++++++++-----
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |   8 +-
 drivers/infiniband/core/cm.c                       |  16 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/core/iwcm.c                     |  29 +--
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 -
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 -
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   1 -
 drivers/infiniband/hw/mlx5/qpc.c                   |  30 ++-
 drivers/input/keyboard/gpio_keys.c                 |   2 +
 drivers/input/misc/ims-pcu.c                       |   6 +
 drivers/input/misc/sparcspkr.c                     |  22 +-
 drivers/input/rmi4/rmi_f34.c                       | 133 +++++-----
 drivers/iommu/Kconfig                              |   1 -
 drivers/iommu/amd/iommu.c                          |   8 +
 drivers/iommu/iommu.c                              |   4 +-
 drivers/md/dm-raid1.c                              |   5 +-
 drivers/md/dm.c                                    |  30 +--
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   4 +-
 drivers/media/i2c/ccs-pll.c                        |  11 +-
 drivers/media/i2c/ov8856.c                         |   9 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |  12 +-
 drivers/media/platform/qcom/venus/core.c           |  16 +-
 drivers/media/platform/ti/davinci/vpif.c           |   4 +-
 drivers/media/platform/ti/omap3isp/ispccdc.c       |   8 +-
 drivers/media/platform/ti/omap3isp/ispstat.c       |   6 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |   3 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     |   7 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  23 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  27 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/mfd/exynos-lpass.c                         |   1 -
 drivers/mfd/stmpe-spi.c                            |   2 +-
 drivers/misc/vmw_vmci/vmci_host.c                  |  11 +-
 drivers/mmc/core/card.h                            |   6 +
 drivers/mmc/core/quirks.h                          |  10 +
 drivers/mmc/core/sd.c                              |  32 ++-
 drivers/mtd/nand/ecc-mxic.c                        |   2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +
 drivers/net/can/m_can/tcan4x5x-core.c              |   9 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |   6 +-
 drivers/net/ethernet/cortina/gemini.c              |  37 ++-
 drivers/net/ethernet/dlink/dl2k.c                  |  14 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/faraday/Kconfig               |   1 +
 drivers/net/ethernet/google/gve/gve_main.c         |   2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |   3 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  11 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |  48 ++++
 drivers/net/ethernet/intel/ice/ice_sched.c         | 181 +++++++++++---
 drivers/net/ethernet/intel/ice/ice_switch.c        |   4 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   9 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   4 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  18 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  18 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   4 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |   2 +-
 drivers/net/ethernet/microchip/lan743x_ptp.h       |   5 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   1 +
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   1 +
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |  21 ++
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   5 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   2 +-
 drivers/net/ethernet/vertexcom/mse102x.c           |  15 +-
 drivers/net/macsec.c                               |  40 ++-
 drivers/net/phy/mdio_bus.c                         |  16 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  20 +-
 drivers/net/usb/aqc111.c                           |  10 +-
 drivers/net/usb/ch9200.c                           |   7 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  26 ++
 drivers/net/vxlan/vxlan_core.c                     |   8 +-
 drivers/net/wireguard/device.c                     |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   4 +-
 drivers/net/wireless/ath/ath11k/ce.c               |  11 +-
 drivers/net/wireless/ath/ath11k/core.c             |  37 +--
 drivers/net/wireless/ath/ath11k/core.h             |   4 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |  61 ++---
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  25 +-
 drivers/net/wireless/ath/ath11k/hal.c              |   4 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   4 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   9 +
 drivers/net/wireless/ath/ath11k/testmode.c         |  64 +----
 drivers/net/wireless/ath/ath11k/testmode.h         |   8 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   3 +
 drivers/net/wireless/ath/carl9170/usb.c            |  19 +-
 drivers/net/wireless/intersil/p54/fwio.c           |   2 +
 drivers/net/wireless/intersil/p54/p54.h            |   1 +
 drivers/net/wireless/intersil/p54/txrx.c           |  13 +-
 drivers/net/wireless/mac80211_hwsim.c              |   5 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   2 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   5 +
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  10 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   3 +-
 drivers/nvme/target/fcloop.c                       |  31 +--
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   5 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |  11 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   2 +-
 drivers/pci/controller/pcie-apple.c                |   4 +-
 drivers/pci/pci.c                                  |   3 +-
 drivers/pci/pcie/dpc.c                             |   2 +-
 drivers/pci/quirks.c                               |  23 ++
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   6 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  35 +--
 drivers/pinctrl/pinctrl-at91.c                     |   6 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   8 +
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |   9 +
 drivers/platform/loongarch/loongson-laptop.c       |  87 ++++---
 drivers/platform/x86/dell/dell_rbu.c               |   6 +-
 drivers/platform/x86/ideapad-laptop.c              |   3 +
 drivers/power/reset/at91-reset.c                   |   5 +-
 drivers/power/supply/bq27xxx_battery.c             |   2 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |  13 +-
 drivers/ptp/ptp_clock.c                            |   3 +-
 drivers/ptp/ptp_private.h                          |  12 +-
 drivers/rapidio/rio_cm.c                           |   3 +
 drivers/regulator/max14577-regulator.c             |   5 +-
 drivers/regulator/max20086-regulator.c             |  10 +-
 drivers/remoteproc/qcom_wcnss_iris.c               |   2 +
 drivers/remoteproc/remoteproc_core.c               |   6 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   8 -
 drivers/rpmsg/qcom_smd.c                           |   2 +-
 drivers/rtc/class.c                                |   2 +-
 drivers/rtc/lib.c                                  |  24 +-
 drivers/rtc/rtc-sh.c                               |  12 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   2 +
 drivers/scsi/elx/efct/efct_hw.c                    |   5 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |  29 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/scsi/scsi_transport_iscsi.c                |  11 +-
 drivers/scsi/storvsc_drv.c                         |  10 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  17 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   2 +-
 drivers/spi/spi-bcm63xx.c                          |   2 +-
 drivers/spi/spi-sh-msiof.c                         |  13 +-
 drivers/spi/spi-tegra210-quad.c                    |  24 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   2 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  10 +-
 drivers/tee/tee_core.c                             |  11 +-
 drivers/thunderbolt/ctl.c                          |   5 +
 drivers/tty/serial/milbeaut_usio.c                 |   5 +-
 drivers/tty/serial/sh-sci.c                        |  97 ++++++--
 drivers/tty/vt/vt_ioctl.c                          |   2 -
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/uio/uio_hv_generic.c                       |   4 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  21 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   4 +
 drivers/usb/class/usbtmc.c                         |  21 +-
 drivers/usb/core/hub.c                             |  16 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/gadget/function/f_hid.c                |  12 +-
 drivers/usb/renesas_usbhs/common.c                 |  50 +++-
 drivers/usb/serial/pl2303.c                        |   2 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/tcpm/tcpci_maxim.c               |   3 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |  57 ++++-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |  14 +-
 drivers/vfio/vfio_iommu_type1.c                    |   2 +-
 drivers/video/backlight/qcom-wled.c                |   6 +-
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   7 +-
 drivers/video/fbdev/core/fbcvt.c                   |   2 +-
 drivers/video/fbdev/core/fbmem.c                   |   4 +-
 drivers/watchdog/da9052_wdt.c                      |   1 +
 drivers/watchdog/exar_wdt.c                        |   2 +-
 fs/ceph/super.c                                    |   1 +
 fs/configfs/dir.c                                  |   2 +-
 fs/ext4/ext4.h                                     |   7 +
 fs/ext4/extents.c                                  |  18 +-
 fs/ext4/file.c                                     |   7 +-
 fs/ext4/inline.c                                   |   2 +-
 fs/ext4/inode.c                                    |   3 +-
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
 fs/kernfs/dir.c                                    |   5 +-
 fs/kernfs/file.c                                   |   3 +-
 fs/namespace.c                                     |   6 +-
 fs/nfs/super.c                                     |  19 ++
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfssvc.c                                   |   6 +-
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/direct.c                                 |   3 +
 fs/ntfs3/index.c                                   |   8 +
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/smb/client/cached_dir.h                         |   8 +-
 fs/smb/client/connect.c                            |   8 +
 fs/smb/client/readdir.c                            |  28 ++-
 fs/smb/server/smb2pdu.c                            |  11 +-
 fs/squashfs/super.c                                |   5 +
 fs/userfaultfd.c                                   |   6 +
 fs/xfs/Kconfig                                     |  12 +
 fs/xfs/libxfs/xfs_alloc.c                          |  10 +-
 fs/xfs/libxfs/xfs_dir2_data.c                      |  31 ++-
 fs/xfs/libxfs/xfs_dir2_priv.h                      |   7 +
 fs/xfs/libxfs/xfs_quota_defs.h                     |   2 +-
 fs/xfs/libxfs/xfs_refcount.c                       |  13 +-
 fs/xfs/libxfs/xfs_rmap.c                           |  10 +-
 fs/xfs/libxfs/xfs_trans_resv.c                     |  28 +--
 fs/xfs/scrub/bmap.c                                |   8 +-
 fs/xfs/xfs.h                                       |   4 +
 fs/xfs/xfs_bmap_util.c                             |  22 +-
 fs/xfs/xfs_buf_item.c                              |  32 +++
 fs/xfs/xfs_dquot_item.c                            |  31 +++
 fs/xfs/xfs_file.c                                  |  29 +--
 fs/xfs/xfs_file.h                                  |  15 ++
 fs/xfs/xfs_fsmap.c                                 | 276 ++++++++++++---------
 fs/xfs/xfs_inode.c                                 |  29 ++-
 fs/xfs/xfs_inode.h                                 |   2 +
 fs/xfs/xfs_inode_item.c                            |  32 +++
 fs/xfs/xfs_ioctl.c                                 |  12 +
 fs/xfs/xfs_iops.c                                  |   1 +
 fs/xfs/xfs_iops.h                                  |   3 -
 fs/xfs/xfs_rtalloc.c                               |  78 +++++-
 fs/xfs/xfs_symlink.c                               |   8 +-
 fs/xfs/xfs_trace.h                                 |  25 ++
 include/acpi/actypes.h                             |   2 +-
 include/linux/arm_sdei.h                           |   4 +-
 include/linux/atmdev.h                             |   6 +
 include/linux/bio.h                                |   2 +-
 include/linux/hid.h                                |   3 +-
 include/linux/hugetlb.h                            |   3 +
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mm.h                                 |   3 +
 include/linux/mm_types.h                           |   3 +
 include/linux/mmc/card.h                           |   1 +
 include/net/bluetooth/hci_core.h                   |   1 -
 include/net/checksum.h                             |   2 +-
 include/net/sock.h                                 |   7 +-
 include/trace/events/erofs.h                       |  18 --
 include/uapi/linux/bpf.h                           |   2 +
 io_uring/io_uring.c                                |  10 +-
 ipc/shm.c                                          |   5 +-
 kernel/bpf/core.c                                  |   2 +-
 kernel/bpf/helpers.c                               |   3 +-
 kernel/cgroup/legacy_freezer.c                     |   3 +-
 kernel/events/core.c                               |  57 ++++-
 kernel/exit.c                                      |  17 +-
 kernel/power/wakelock.c                            |   3 +
 kernel/time/clocksource.c                          |   2 +-
 kernel/time/posix-cpu-timers.c                     |   9 +
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/ftrace.c                              |  10 +-
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace.h                               |   8 +-
 kernel/trace/trace_events_hist.c                   |   2 +-
 kernel/trace/trace_events_trigger.c                |  20 +-
 lib/Kconfig                                        |   1 +
 mm/huge_memory.c                                   |  11 +-
 mm/hugetlb.c                                       |  83 +++++--
 mm/mmap.c                                          |   8 +
 mm/page-writeback.c                                |   2 +-
 net/atm/common.c                                   |   1 +
 net/atm/lec.c                                      |  12 +-
 net/atm/raw.c                                      |   2 +-
 net/bluetooth/eir.c                                |  10 +-
 net/bluetooth/hci_core.c                           |  15 +-
 net/bluetooth/hci_sync.c                           |  20 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bluetooth/mgmt.c                               |  39 +--
 net/bluetooth/mgmt_util.c                          |   2 +-
 net/bridge/br_mst.c                                |   4 +-
 net/bridge/br_multicast.c                          | 103 +++++++-
 net/bridge/br_private.h                            |  11 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  12 +-
 net/core/filter.c                                  |   5 +-
 net/core/skmsg.c                                   |  56 +++--
 net/core/sock.c                                    |   4 +-
 net/core/utils.c                                   |   4 +-
 net/dsa/tag_brcm.c                                 |   2 +-
 net/ipv4/route.c                                   |   4 +
 net/ipv4/tcp_fastopen.c                            |   3 +
 net/ipv4/tcp_input.c                               |  63 ++---
 net/ipv4/udp_offload.c                             |   5 +
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
 net/sched/sch_ets.c                                |   2 +-
 net/sched/sch_prio.c                               |   2 +-
 net/sched/sch_red.c                                |   2 +-
 net/sched/sch_sfq.c                                |  15 +-
 net/sched/sch_tbf.c                                |   2 +-
 net/sctp/socket.c                                  |   3 +-
 net/tipc/crypto.c                                  |   8 +-
 net/tipc/udp_media.c                               |   4 +-
 net/tls/tls_sw.c                                   |  15 +-
 net/wireless/core.c                                |   6 +-
 scripts/Makefile.clang                             |   3 +-
 scripts/Makefile.compiler                          |   4 +-
 scripts/gcc-plugins/gcc-common.h                   |  32 +++
 scripts/gcc-plugins/randomize_layout_plugin.c      |  40 +--
 security/selinux/xfrm.c                            |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   9 +-
 sound/soc/apple/mca.c                              |  23 ++
 sound/soc/codecs/hda.c                             |   4 +-
 sound/soc/codecs/tas2764.c                         |   2 +-
 sound/soc/codecs/tas2770.c                         |  30 ++-
 sound/soc/intel/avs/ipc.c                          |   4 +-
 sound/soc/meson/meson-card-utils.c                 |   2 +-
 sound/soc/qcom/sdm845.c                            |   4 +
 sound/soc/tegra/tegra210_ahub.c                    |   2 +
 sound/usb/implicit.c                               |   1 +
 sound/usb/mixer_maps.c                             |  12 +
 tools/bpf/bpftool/cgroup.c                         |  12 +-
 tools/bpf/resolve_btfids/Makefile                  |   2 +-
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
 tools/perf/util/intel-pt.c                         | 205 ++++++++++++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   7 +-
 tools/testing/selftests/x86/Makefile               |   2 +-
 tools/testing/selftests/x86/sigtrap_loop.c         | 101 ++++++++
 usr/include/Makefile                               |   2 +-
 500 files changed, 4451 insertions(+), 2103 deletions(-)


