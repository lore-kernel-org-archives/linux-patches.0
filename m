Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5BC24EA85;
	Mon, 23 Jun 2025 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684179; cv=none; b=tGiU8y/8V1kWHS/m/thzKBf6XHQm24JhCHEIrYRVrT6s8b5FYLt8RaWR2IaCJbwMfRp8WGnlHD+kYVCeZmhGLcy0NIfq1UQvJJHbZztUbQzeYpjqibsfrGMdHKlYrpiCPBla8SjX9ExNAeD0noMyQsrw6qx5+cxB9O57guqy4vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684179; c=relaxed/simple;
	bh=a0SB1vAtjdBPr8TfsNMmzHuXd2V3ALiY5fbqJkvwAOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=euD/5f4zMjpHlVg4lbWohbw7zqzHz9ievcsu2L9vF+OGqVS0DYOT39uYo6PEEZo1q2DwT2FejCVZ0GnCjLGj3yk5nkKt3xQwB9fot3QV9pQINlZyMhf9Z1ChiFj8kdOAD4b4IyuskjKY/qyJe7CDOzYzrKLioZtvdITlNytY6U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2R4ElZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2R4ElZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB04C4CEEA;
	Mon, 23 Jun 2025 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684179;
	bh=a0SB1vAtjdBPr8TfsNMmzHuXd2V3ALiY5fbqJkvwAOI=;
	h=From:To:Cc:Subject:Date:From;
	b=r2R4ElZS3Yhi3ntQnkuSS5D1LHw/vudjzGFod4bihMpKiTPogs7ZUHxpVJfgCbc0v
	 tMRxOAI0Ham/ai8dsr/V3/6w/ZcbT19RTZXZgVdCQ1Q1dhdcgAUM+LbxBHLu8Ht5qp
	 UEJLhFwKxXMG5CV2zLTUU/b3On/TSmY9RwePKXTc=
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
Subject: [PATCH 6.6 000/290] 6.6.95-rc1 review
Date: Mon, 23 Jun 2025 15:04:21 +0200
Message-ID: <20250623130626.910356556@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.95-rc1
X-KernelTest-Deadline: 2025-06-25T13:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.95 release.
There are 290 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.95-rc1

Pali Rohár <pali@kernel.org>
    cifs: Remove duplicate fattr->cf_dtype assignment from wsl_to_fattr() function

David Thompson <davthompson@nvidia.com>
    gpio: mlxbf3: only get IRQ for device instance 0

Ian Rogers <irogers@google.com>
    perf evsel: Missed close() when probing hybrid core PMUs

Anup Patel <apatel@ventanamicro.com>
    RISC-V: KVM: Don't treat SBI HFENCE calls as NOPs

Anup Patel <apatel@ventanamicro.com>
    RISC-V: KVM: Fix the size parameter check in SBI SFENCE calls

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()

Tengda Wu <wutengda@huaweicloud.com>
    arm64/ptrace: Fix stack-out-of-bounds read in regs_get_kernel_stack_nth()

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/core: Fix WARN in perf_cgroup_switch()

Peter Zijlstra <peterz@infradead.org>
    perf: Fix cgroup state vs ERROR

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

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: am335x-bone-common: Increase MDIO reset deassert delay to 50ms

Colin Foster <colin.foster@in-advantage.com>
    ARM: dts: am335x-bone-common: Increase MDIO reset deassert time

Renato Caldas <renato@calgera.com>
    platform/x86: ideapad-laptop: add missing Ideapad Pro 5 fn keys

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Increment the runtime usage counter for the earlycon device

Jakub Kicinski <kuba@kernel.org>
    net: make for_each_netdev_dump() a little more bug-proof

Paul Aurich <paul@darkrain42.org>
    smb: Log an error when close_all_cached_dirs fails

Akhil R <akhilrajeev@nvidia.com>
    dt-bindings: i2c: nvidia,tegra20-i2c: Specify the required properties

Avadhut Naik <avadhut.naik@amd.com>
    EDAC/amd64: Correct number of UMCs for family 19h models 70h-7fh

Eric Dumazet <edumazet@google.com>
    net: atm: fix /proc/net/atm/lec handling

Eric Dumazet <edumazet@google.com>
    net: atm: add lec_mutex

Kuniyuki Iwashima <kuniyu@google.com>
    calipso: Fix null-ptr-deref in calipso_req_{set,del}attr().

Ronnie Sahlberg <rsahlberg@whamcloud.com>
    ublk: santizize the arguments from userspace when adding a device

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

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: set fixed clock frequency indication for Nahum 11 and Nahum 13

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

Tzung-Bi Shih <tzungbi@kernel.org>
    drm/i915/pmu: Fix build error with GCOV and AutoFDO enabled

Jacob Keller <jacob.e.keller@intel.com>
    drm/nouveau/bl: increase buffer size to avoid truncate warning

Brett Creeley <brett.creeley@amd.com>
    ionic: Prevent driver/fw getting out of sync on devcmd(s)

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate

James A. MacInnes <james.a.macinnes@gmail.com>
    drm/msm/disp: Correct porch timing for SDM845

Bharath SM <bharathsm@microsoft.com>
    smb: fix secondary channel creation issue with kerberos by populating hostname when adding channels

Jeff Layton <jlayton@kernel.org>
    sunrpc: handle SVC_GARBAGE during svc auth processing as auth error

Gao Xiang <xiang@kernel.org>
    erofs: remove unused trace event erofs_destroy_inode

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE

Paul Chaignon <paul.chaignon@gmail.com>
    net: Fix checksum update for ILA adj-transport

Gavin Guo <gavinguo@igalia.com>
    mm/huge_memory: fix dereferencing invalid pmd migration entry

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

Dev Jain <dev.jain@arm.com>
    arm64: Restrict pagetable teardown to avoid false warning

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw89: pci: use DBI function for 8852AE/8852BE/8851BE

Edward Adam Davis <eadavis@qq.com>
    wifi: cfg80211: init wiphy_work before allocating rfkill fails

WangYuli <wangyuli@uniontech.com>
    Input: sparcspkr - avoid unannotated fall-through

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Revert atm_account_tx() if copy_from_iter_full() fails.

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Fail module load when plat_info is NULL

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference in destroy_previous_session

Xin Li (Intel) <xin@zytor.com>
    selftests/x86: Add a test to detect infinite SIGTRAP handler loop

Marek Szyprowski <m.szyprowski@samsung.com>
    udmabuf: use sgtable-based scatterlist wrappers

Jakub Kicinski <kuba@kernel.org>
    net: clear the dst when changing skb protocol

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: reject invalid perturb period

Peter Oberparleiter <oberpar@linux.ibm.com>
    scsi: s390: zfcp: Ensure synchronous unit_add

Dexuan Cui <decui@microsoft.com>
    scsi: storvsc: Increase the timeouts to storvsc_timeout

Bharath SM <bharathsm.hsk@gmail.com>
    smb: improve directory cache reuse for readdir operations

Shyam Prasad N <sprasad@microsoft.com>
    cifs: do not disable interface polling on failure

Shyam Prasad N <sprasad@microsoft.com>
    cifs: serialize other channels when query server interfaces is pending

Shyam Prasad N <sprasad@microsoft.com>
    cifs: deal with the channel loading lag while picking channels

Fedor Pchelkin <pchelkin@ispras.ru>
    jffs2: check jffs2_prealloc_raw_node_refs() result in few other places

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    jffs2: check that raw node were preallocated before writing summary

Tianyang Zhang <zhangtianyang@loongson.cn>
    LoongArch: Fix panic caused by NULL-PMD in huge_pte_offset()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Avoid using $r0/$r1 as "mask" for csrxchg

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Unregister generic_sub_drivers on exit

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Get brightness setting from EC on probe

Andrew Morton <akpm@linux-foundation.org>
    drivers/rapidio/rio_cm.c: prevent possible heap overwrite

Penglei Jiang <superman.xpt@gmail.com>
    io_uring: fix task leak issue in io_wq_create()

Breno Leitao <leitao@debian.org>
    Revert "x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2" on v6.6 and older

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/eeh: Fix missing PE bridge reconfiguration during VFIO EEH recovery

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Fix build of VDSO32 with pcrel

Stuart Hayes <stuart.w.hayes@gmail.com>
    platform/x86: dell_rbu: Stop overwriting data buffer

Stuart Hayes <stuart.w.hayes@gmail.com>
    platform/x86: dell_rbu: Fix list usage

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Clear metrics table at start of cycle

Stephen Smalley <stephen.smalley.work@gmail.com>
    fs/xattr.c: fix simple_xattr_list()

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

Suraj P Kizhakkethil <quic_surapk@quicinc.com>
    wifi: ath12k: Pass correct values of center freq1 and center freq2 for 160 MHz

Balamurugan S <quic_bselvara@quicinc.com>
    wifi: ath12k: fix incorrect CE addresses

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: ath12k: fix link valid field initialization in the monitor Rx

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: determine PM policy based on machine model

Wentao Liang <vulab@iscas.ac.cn>
    octeontx2-pf: Add error log forcn10k_map_unmap_rq_policer()

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Use TOE/TSO on all TCP

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix data lost during EAGAIN retries

Chao Yu <chao@kernel.org>
    f2fs: fix to set atomic write status more clear

Krzysztof Hałasa <khalasa@piap.pl>
    usbnet: asix AX88772: leave the carrier control to phylink

Mateusz Pacuszka <mateuszx.pacuszka@intel.com>
    ice: fix check for existing switch rule

Kyungwook Boo <bookyungwook@gmail.com>
    i40e: fix MMIO write access to an invalid page in i40e_clear_hw

Zijun Hu <quic_zijuhu@quicinc.com>
    sock: Correct error checking condition for (assign|release)_proto_idx()

Daniel Wagner <wagi@kernel.org>
    scsi: lpfc: Use memcpy() for BIOS version

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: ath12k: fix failed to set mhi state error during reboot with hardware grouping

Mike Looijmans <mike.looijmans@topic.nl>
    pinctrl: mcp23s08: Reset all pins to input at probe

Zijun Hu <quic_zijuhu@quicinc.com>
    software node: Correct a OOB check in software_node_get_reference_args()

Michael Walle <mwalle@kernel.org>
    net: ethernet: ti: am65-cpsw: handle -EPROBE_DEFER

Ido Schimmel <idosch@nvidia.com>
    vxlan: Do not treat dst cache initialization errors as fatal

Yong Wang <yongwang@nvidia.com>
    net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions

Yong Wang <yongwang@nvidia.com>
    net: bridge: mcast: update multicast contex when vlan state is changed

Víctor Gonzalo <victor.gonzalo@anddroptable.net>
    wifi: iwlwifi: Add missing MODULE_FIRMWARE for Qu-c0-jf-b0

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: mac80211: VLAN traffic in multicast path

Edward Adam Davis <eadavis@qq.com>
    wifi: mac80211_hwsim: Prevent tsf from setting if beacon is disabled

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: pcie: make sure to lock rxq->read

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

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: leave idle mode when setting WEP encryption for AP mode

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: ath11k: Fix QMI memory reuse logic

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix a possible dead lock caused by ab->base_lock

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix macro definition HAL_RX_MSDU_PKT_LENGTH_GET

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

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: drop fragments with multicast or broadcast RA

Tan En De <ende.tan@starfivetech.com>
    i2c: designware: Invoke runtime suspend on quick slave re-registration

Hou Tao <houtao1@huawei.com>
    bpf: Check rcu_read_lock_trace_held() in bpf_map_lookup_percpu_elem()

Chao Yu <chao@kernel.org>
    f2fs: use vmalloc instead of kvmalloc in .init_{,de}compress_ctx

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

Peng Fan <peng.fan@nxp.com>
    gpiolib: of: Add polarity quirk for s5m8767

Yuanjun Gong <ruc_gongyuanjun@163.com>
    ASoC: tegra210_ahub: Add check to of_device_get_match_data()

gldrk <me@rarity.fan>
    ACPICA: utilities: Fix overflow check in vsnprintf()

Jerry Lv <Jerry.Lv@axis.com>
    power: supply: bq27xxx: Retrieve again when busy

Seunghun Han <kkamagui@gmail.com>
    ACPICA: fix acpi parse and parseext cache leaks

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: Add missing prototype for non CONFIG_SUSPEND/CONFIG_X86 case

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Bail out if acpi_kobj registration fails

Hector Martin <marcan@marcan.st>
    ASoC: tas2770: Power cycle amp on ISENSE/VSENSE change

Luke Wang <ziniu.wang_1@nxp.com>
    mmc: sdhci-esdhc-imx: Save tuning value when card stays powered in suspend

Ahmed Salem <x0rw3ll@gmail.com>
    ACPICA: Avoid sequence overread in call to strncmp()

Erick Shepherd <erick.shepherd@ni.com>
    mmc: Add quirk to disable DDR50 tuning

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    power: supply: collie: Fix wakeup source leaks on device unbind

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

Jann Horn <jannh@google.com>
    mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race

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

Long Li <longli@microsoft.com>
    Drivers: hv: Allocate interrupt and monitor pages aligned to system page boundary

Ruben Devos <devosruben6@gmail.com>
    smb: client: add NULL check in automount_fullpath

Shyam Prasad N <sprasad@microsoft.com>
    cifs: dns resolution is needed only for primary channel

Shyam Prasad N <sprasad@microsoft.com>
    cifs: update dstaddr whenever channel iface is updated

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

Thomas Zimmermann <tzimmermann@suse.de>
    video: screen_info: Relocate framebuffers behind PCI bridges

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY

Qasim Ijaz <qasdev00@gmail.com>
    net: ch9200: fix uninitialised access during mii_nway_restart

Xu Yang <xu.yang_2@nxp.com>
    phy: fsl-imx8mq-usb: fix phy_tx_vboost_level_from_property()

Ye Bin <yebin10@huawei.com>
    ftrace: Fix UAF when lookup kallsym after ftrace disabled

Md Sadre Alam <quic_mdalam@quicinc.com>
    mtd: rawnand: qcom: Fix read len for onfi param page

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix a memory leak if some arguments are specified multiple times

Mikulas Patocka <mpatocka@redhat.com>
    dm-mirror: fix a tiny race condition

Chao Gao <chao.gao@intel.com>
    KVM: VMX: Flush shadow VMCS on emergency reboot

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

Luo Gengkun <luogengkun@huaweicloud.com>
    watchdog: fix watchdog may detect false positive of softlockup

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

Murad Masimov <m.masimov@mt-integration.ru>
    fbdev: Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var

Heiner Kallweit <hkallweit1@gmail.com>
    net: ftgmac100: select FIXED_PHY

Hyunwoo Kim <imv4bel@gmail.com>
    net/sched: fix use-after-free in taprio_dev_notifier

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    NFC: nci: uart: Set tty->disc_data only in success path

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (ftsteutates) Fix TOCTOU race in fts_read()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on sit_bitmap_size

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: prevent kernel warning due to negative i_nlink from corrupted image

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on ino and xnid

Gatien Chevallier <gatien.chevallier@foss.st.com>
    Input: gpio-keys - fix possible concurrent access in gpio_keys_irq_timer()

Dan Carpenter <dan.carpenter@linaro.org>
    Input: ims-pcu - check record size in ims_pcu_flash_firmware()

Brian Foster <bfoster@redhat.com>
    ext4: only dirty folios when data journaling regular files

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

Sumit Kumar <quic_sumk@quicinc.com>
    bus: mhi: ep: Update read pointer only after buffer is written

Andreas Kemnade <andreas@kemnade.info>
    ARM: omap: pmic-cpcap: do not mess around without CPCAP or OMAP4

Ross Stutterheim <ross.stutterheim@garmin.com>
    ARM: 9447/1: arm/memremap: fix arch_memremap_can_ram_remap()

Ryan Roberts <ryan.roberts@arm.com>
    arm64/mm: Close theoretical race where stale TLB entry remains valid

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix deferred probing error

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Send control events for partial succeeds

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Return the number of processed controls

Ming Qian <ming.qian@oss.nxp.com>
    media: imx-jpeg: Cleanup after an allocation error

Ming Qian <ming.qian@oss.nxp.com>
    media: imx-jpeg: Reset slot data pointers when freed

Ming Qian <ming.qian@oss.nxp.com>
    media: imx-jpeg: Move mxc_jpeg_free_slot_data() ahead

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

Fei Shao <fshao@chromium.org>
    media: mediatek: vcodec: Correct vsi_core framebuffer size

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

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub913: Fix returned fmt from .set_fmt()

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    media: nxp: imx8-isi: better handle the m2m usage_count

Johan Hovold <johan+linaro@kernel.org>
    media: ov5675: suppress probe deferral errors

Johan Hovold <johan+linaro@kernel.org>
    media: ov8856: suppress probe deferral errors

Mingcong Bai <jeffbai@aosc.io>
    wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: usb: Reduce control message timeout to 500 ms

Jeongjun Park <aha310510@gmail.com>
    jbd2: fix data-race and null-ptr-deref in jbd2_journal_dirty_metadata()

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix ring-buffer corruption

Max Kellermann <max.kellermann@ionos.com>
    fs/nfs/read: fix double-unlock bug in nfs_return_empty_folio()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Prevent hang on NFS mount with xprtsec=[m]tls

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
    io_uring/kbuf: account ring io_buffer_list memory

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


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 -
 .../bindings/i2c/nvidia,tegra20-i2c.yaml           |  24 ++-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/ti/omap/am335x-bone-common.dtsi  |   2 +-
 arch/arm/mach-omap2/clockdomain.h                  |   1 +
 arch/arm/mach-omap2/clockdomains33xx_data.c        |   2 +-
 arch/arm/mach-omap2/cm33xx.c                       |  14 +-
 arch/arm/mach-omap2/pmic-cpcap.c                   |   6 +-
 arch/arm/mm/ioremap.c                              |   4 +-
 arch/arm64/include/asm/tlbflush.h                  |   9 +-
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/loongarch/include/asm/irqflags.h              |  16 +-
 arch/loongarch/mm/hugetlbpage.c                    |   3 +-
 arch/mips/vdso/Makefile                            |   1 +
 arch/parisc/boot/compressed/Makefile               |   1 +
 arch/parisc/kernel/unaligned.c                     |   2 +-
 arch/powerpc/include/asm/ppc_asm.h                 |   2 +-
 arch/powerpc/kernel/eeh.c                          |   2 +
 arch/powerpc/kernel/vdso/Makefile                  |   2 +-
 arch/powerpc/platforms/pseries/msi.c               |   7 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   8 +-
 arch/s390/kvm/gaccess.c                            |   8 +-
 arch/s390/pci/pci_mmio.c                           |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   2 +
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   5 +-
 drivers/acpi/acpica/dsutils.c                      |   9 +-
 drivers/acpi/acpica/psobject.c                     |  52 ++---
 drivers/acpi/acpica/utprint.c                      |   7 +-
 drivers/acpi/battery.c                             |  19 +-
 drivers/acpi/bus.c                                 |   6 +-
 drivers/ata/pata_via.c                             |   3 +-
 drivers/atm/atmtcp.c                               |   4 +-
 drivers/base/power/runtime.c                       |   2 +-
 drivers/base/swnode.c                              |   2 +-
 drivers/block/aoe/aoedev.c                         |   8 +
 drivers/block/ublk_drv.c                           |   3 +
 drivers/bus/fsl-mc/fsl-mc-uapi.c                   |   4 +-
 drivers/bus/fsl-mc/mc-io.c                         |  19 +-
 drivers/bus/fsl-mc/mc-sys.c                        |   2 +-
 drivers/bus/mhi/ep/ring.c                          |  16 +-
 drivers/bus/mhi/host/pm.c                          |  18 +-
 drivers/bus/ti-sysc.c                              |  49 -----
 drivers/clk/meson/g12a.c                           |   1 +
 drivers/clk/rockchip/clk-rk3036.c                  |   1 +
 drivers/cpufreq/scmi-cpufreq.c                     |  36 +++-
 drivers/cpufreq/tegra186-cpufreq.c                 |   7 -
 drivers/crypto/marvell/cesa/cesa.c                 |   2 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   9 +-
 drivers/crypto/marvell/cesa/tdma.c                 |  53 +++--
 drivers/dma-buf/udmabuf.c                          |   5 +-
 drivers/edac/altera_edac.c                         |   6 +-
 drivers/edac/amd64_edac.c                          |   1 +
 drivers/gpio/gpio-mlxbf3.c                         |  52 +++--
 drivers/gpio/gpiolib-of.c                          |   9 +
 drivers/gpu/drm/i915/i915_pmu.c                    |   4 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |  14 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c         |   7 +
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |   2 +-
 drivers/hv/connection.c                            |  23 +-
 drivers/hwmon/ftsteutates.c                        |   9 +-
 drivers/hwmon/occ/common.c                         | 238 +++++++++------------
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  12 +-
 drivers/i2c/busses/i2c-tegra.c                     |   5 +
 drivers/iio/accel/fxls8962af-core.c                |  15 +-
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |   8 +-
 drivers/infiniband/core/iwcm.c                     |  29 +--
 drivers/input/keyboard/gpio_keys.c                 |   2 +
 drivers/input/misc/ims-pcu.c                       |   6 +
 drivers/input/misc/sparcspkr.c                     |  22 +-
 drivers/iommu/amd/iommu.c                          |   8 +
 drivers/md/dm-raid1.c                              |   5 +-
 drivers/md/dm-verity-fec.c                         |   4 +
 drivers/md/dm-verity-target.c                      |   8 +-
 drivers/md/dm-verity-verify-sig.c                  |  17 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   4 +-
 drivers/media/i2c/ccs-pll.c                        |  11 +-
 drivers/media/i2c/ds90ub913.c                      |   4 +-
 drivers/media/i2c/ov5675.c                         |   5 +-
 drivers/media/i2c/ov8856.c                         |   9 +-
 .../vcodec/decoder/vdec/vdec_hevc_req_multi_if.c   |   2 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |  59 +++--
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c |  14 +-
 drivers/media/platform/qcom/venus/core.c           |  16 +-
 drivers/media/platform/ti/davinci/vpif.c           |   4 +-
 drivers/media/platform/ti/omap3isp/ispccdc.c       |   8 +-
 drivers/media/platform/ti/omap3isp/ispstat.c       |   6 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |   2 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |   3 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     |   7 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  23 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  27 ++-
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/mmc/core/card.h                            |   6 +
 drivers/mmc/core/quirks.h                          |  10 +
 drivers/mmc/core/sd.c                              |  32 ++-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  88 +++++++-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   2 +-
 drivers/mtd/nand/raw/sunxi_nand.c                  |   2 +
 drivers/net/can/m_can/tcan4x5x-core.c              |   9 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |   6 +-
 drivers/net/ethernet/cortina/gemini.c              |  37 +++-
 drivers/net/ethernet/dlink/dl2k.c                  |  14 +-
 drivers/net/ethernet/dlink/dl2k.h                  |   2 +
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/faraday/Kconfig               |   1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  14 +-
 drivers/net/ethernet/intel/e1000e/ptp.c            |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |   7 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |  48 +++++
 drivers/net/ethernet/intel/ice/ice_switch.c        |   4 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   9 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  18 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  18 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |   2 +-
 drivers/net/ethernet/microchip/lan743x_ptp.h       |   5 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   3 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  24 ++-
 drivers/net/ethernet/vertexcom/mse102x.c           |  15 +-
 drivers/net/usb/asix.h                             |   1 -
 drivers/net/usb/asix_common.c                      |  22 --
 drivers/net/usb/asix_devices.c                     |  17 +-
 drivers/net/usb/ch9200.c                           |   7 +-
 drivers/net/vxlan/vxlan_core.c                     |   8 +-
 drivers/net/wireless/ath/ath11k/ce.c               |  11 +-
 drivers/net/wireless/ath/ath11k/core.c             |  55 +++++
 drivers/net/wireless/ath/ath11k/core.h             |   7 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  25 ++-
 drivers/net/wireless/ath/ath11k/hal.c              |   4 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   9 +
 drivers/net/wireless/ath/ath12k/ce.c               |  11 +-
 drivers/net/wireless/ath/ath12k/ce.h               |   6 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   2 +
 drivers/net/wireless/ath/ath12k/hal.c              |   4 +-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   2 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   3 +
 drivers/net/wireless/ath/ath12k/wmi.c              |  20 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  19 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   6 +
 drivers/net/wireless/intersil/p54/fwio.c           |   2 +
 drivers/net/wireless/intersil/p54/p54.h            |   1 +
 drivers/net/wireless/intersil/p54/txrx.c           |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   2 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   5 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   8 +
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  10 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   2 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |   3 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  69 +++++-
 drivers/net/wireless/realtek/rtw89/pci.h           |   1 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   5 +
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   5 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   2 +-
 drivers/pci/pci.c                                  |   3 +-
 drivers/pci/quirks.c                               |  23 ++
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c         |  10 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  21 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   8 +
 drivers/platform/loongarch/loongson-laptop.c       |  87 ++++----
 drivers/platform/x86/amd/pmc/pmc.c                 |   2 +
 drivers/platform/x86/dell/dell_rbu.c               |   6 +-
 drivers/platform/x86/ideapad-laptop.c              |   3 +
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   9 +-
 drivers/power/supply/bq27xxx_battery.c             |   2 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |  13 +-
 drivers/power/supply/collie_battery.c              |   1 +
 drivers/ptp/ptp_clock.c                            |   3 +-
 drivers/ptp/ptp_private.h                          |  22 +-
 drivers/rapidio/rio_cm.c                           |   3 +
 drivers/regulator/max14577-regulator.c             |   5 +-
 drivers/regulator/max20086-regulator.c             |   4 +-
 drivers/remoteproc/remoteproc_core.c               |   6 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   2 +
 drivers/scsi/elx/efct/efct_hw.c                    |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/storvsc_drv.c                         |  10 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   2 +-
 drivers/tee/tee_core.c                             |  11 +-
 drivers/tty/serial/sh-sci.c                        |  16 ++
 drivers/uio/uio_hv_generic.c                       |   4 +-
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   7 +-
 drivers/video/fbdev/core/fbmem.c                   |  22 +-
 drivers/video/screen_info_pci.c                    |  75 ++++---
 drivers/watchdog/da9052_wdt.c                      |   1 +
 fs/ceph/super.c                                    |   1 +
 fs/configfs/dir.c                                  |   2 +-
 fs/ext4/ext4.h                                     |   7 +
 fs/ext4/extents.c                                  |  18 +-
 fs/ext4/file.c                                     |   7 +-
 fs/ext4/inline.c                                   |   2 +-
 fs/ext4/inode.c                                    |  10 +-
 fs/f2fs/compress.c                                 |  23 +-
 fs/f2fs/f2fs.h                                     |   5 +
 fs/f2fs/inode.c                                    |  10 +-
 fs/f2fs/namei.c                                    |   9 +
 fs/f2fs/segment.c                                  |   6 +
 fs/f2fs/super.c                                    |  12 +-
 fs/gfs2/lock_dlm.c                                 |   3 +-
 fs/jbd2/transaction.c                              |   5 +-
 fs/jffs2/erase.c                                   |   4 +-
 fs/jffs2/scan.c                                    |   4 +-
 fs/jffs2/summary.c                                 |   7 +-
 fs/nfs/read.c                                      |   3 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfssvc.c                                   |   6 +-
 fs/smb/client/cached_dir.c                         |  14 +-
 fs/smb/client/cached_dir.h                         |   8 +-
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/connect.c                            |  17 +-
 fs/smb/client/namespace.c                          |   3 +
 fs/smb/client/readdir.c                            |  28 +--
 fs/smb/client/reparse.c                            |   1 -
 fs/smb/client/sess.c                               |   7 +-
 fs/smb/client/smb2pdu.c                            |  33 ++-
 fs/smb/client/transport.c                          |  14 +-
 fs/smb/server/smb2pdu.c                            |  11 +-
 fs/xattr.c                                         |   1 +
 include/acpi/actypes.h                             |   2 +-
 include/linux/acpi.h                               |   9 +-
 include/linux/atmdev.h                             |   6 +
 include/linux/hugetlb.h                            |   3 +
 include/linux/mmc/card.h                           |   1 +
 include/linux/netdevice.h                          |   3 +-
 include/net/checksum.h                             |   2 +-
 include/trace/events/erofs.h                       |  18 --
 include/uapi/linux/bpf.h                           |   2 +
 io_uring/io-wq.c                                   |   4 +-
 io_uring/io_uring.c                                |   2 +-
 io_uring/kbuf.c                                    |   2 +-
 ipc/shm.c                                          |   5 +-
 kernel/bpf/helpers.c                               |   3 +-
 kernel/cgroup/legacy_freezer.c                     |   3 +-
 kernel/events/core.c                               |  80 +++++--
 kernel/exit.c                                      |  17 +-
 kernel/time/clocksource.c                          |   2 +-
 kernel/trace/ftrace.c                              |  10 +-
 kernel/watchdog.c                                  |  41 ++--
 lib/Kconfig                                        |   1 +
 mm/huge_memory.c                                   |  11 +-
 mm/hugetlb.c                                       |  67 ++++--
 mm/mmap.c                                          |   6 +
 mm/page-writeback.c                                |   2 +-
 net/atm/common.c                                   |   1 +
 net/atm/lec.c                                      |  12 +-
 net/atm/raw.c                                      |   2 +-
 net/bridge/br_mst.c                                |   4 +-
 net/bridge/br_multicast.c                          | 103 ++++++++-
 net/bridge/br_private.h                            |  11 +-
 net/core/filter.c                                  |  24 ++-
 net/core/skmsg.c                                   |   3 +-
 net/core/sock.c                                    |   4 +-
 net/core/utils.c                                   |   4 +-
 net/ipv4/route.c                                   |   4 +
 net/ipv4/tcp_fastopen.c                            |   3 +
 net/ipv4/tcp_input.c                               |  63 +++---
 net/ipv6/calipso.c                                 |   8 +
 net/ipv6/ila/ila_common.c                          |   6 +-
 net/mac80211/mesh_hwmp.c                           |   6 +-
 net/mac80211/tx.c                                  |   6 +-
 net/mpls/af_mpls.c                                 |   4 +-
 net/nfc/nci/uart.c                                 |   8 +-
 net/sched/sch_sfq.c                                |  10 +-
 net/sched/sch_taprio.c                             |   6 +-
 net/sctp/socket.c                                  |   3 +-
 net/sunrpc/svc.c                                   |  11 +-
 net/sunrpc/xprtsock.c                              |   5 +
 net/tipc/crypto.c                                  |   2 +-
 net/tipc/udp_media.c                               |   4 +-
 net/wireless/core.c                                |   6 +-
 security/selinux/xfrm.c                            |   2 +-
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   9 +-
 sound/soc/codecs/tas2770.c                         |  30 ++-
 sound/soc/meson/meson-card-utils.c                 |   2 +-
 sound/soc/qcom/sdm845.c                            |   4 +
 sound/soc/tegra/tegra210_ahub.c                    |   2 +
 sound/usb/mixer_maps.c                             |  12 ++
 tools/bpf/bpftool/cgroup.c                         |  12 +-
 tools/include/uapi/linux/bpf.h                     |   2 +
 tools/lib/bpf/btf.c                                |  16 ++
 tools/perf/util/print-events.c                     |   1 +
 tools/testing/selftests/x86/Makefile               |   2 +-
 tools/testing/selftests/x86/sigtrap_loop.c         | 101 +++++++++
 297 files changed, 2410 insertions(+), 1082 deletions(-)


