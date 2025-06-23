Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF924EF8C;
	Mon, 23 Jun 2025 13:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684171; cv=none; b=FOyLKDb9pWqbFUMfVHMMpwcBqV8vX3idRy4Dj0eE/QZvIN2FPScwjwSd0/17XfbTGfoAnlItsdfbcG6Fpl3fo6uWvT7GWI3wszeuabb9XmAFE77RMn+19g5hQGKMN/ILCJBa8e6/aVIOnS59Vs/YgKhtZa3sGSqoEQXofM81Teo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684171; c=relaxed/simple;
	bh=UUZJc22P47VReW+QmcZ1KOFTFHnBy+yYseLl44ghvJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E224sBydXSYHQxE6Gz0jSismx1Cnyh+ZOXubYHwu9b7Hj1wWsm7ahdaRWEz93hjS/w/Rf4+iiLakT7R2WRdcKqdCQt/h3eA2UgNfKY9y1g5oLU+NCrERVlj08aZmTprHOYHdvqz2F9bGFMlYeKhuqNHDjW86X0iI2JGuQ0KQA3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpeuCBNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpeuCBNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC355C4CEEA;
	Mon, 23 Jun 2025 13:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684170;
	bh=UUZJc22P47VReW+QmcZ1KOFTFHnBy+yYseLl44ghvJA=;
	h=From:To:Cc:Subject:Date:From;
	b=rpeuCBNKS82WTWkrYAYMjcDXqrtcINq/fxMmkhiqU+sxYyQ5euh6XawE6Hp3VSTi1
	 eMYqN5pomaEI0fazuYvz/CM3dv3BC0iPxSXldSB6DhD6P+KYbEZYH9DoSzCwnE+Ym2
	 CG5T/f2ssR2u9JlFLPWNcFqbwb99hS+TYeIjcIJM=
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
Subject: [PATCH 6.12 000/414] 6.12.35-rc1 review
Date: Mon, 23 Jun 2025 15:02:17 +0200
Message-ID: <20250623130642.015559452@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.35-rc1
X-KernelTest-Deadline: 2025-06-25T13:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.35 release.
There are 414 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.35-rc1

Pali Rohár <pali@kernel.org>
    cifs: Remove duplicate fattr->cf_dtype assignment from wsl_to_fattr() function

David Thompson <davthompson@nvidia.com>
    gpio: mlxbf3: only get IRQ for device instance 0

Ian Rogers <irogers@google.com>
    perf test: Directory file descriptor leak

Ian Rogers <irogers@google.com>
    perf evsel: Missed close() when probing hybrid core PMUs

Sascha Hauer <s.hauer@pengutronix.de>
    gpio: pca953x: fix wrong error probe return value

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

Stefan Metzmacher <metze@samba.org>
    smb: client: fix max_sge overflow in smb_extract_folioq_to_rdma()

zhangjian <zhangjian496@huawei.com>
    smb: client: fix first command failure during re-negotiation

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Increment the runtime usage counter for the earlycon device

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Clean sci_ports[0] after at earlycon exit

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

David Thompson <davthompson@nvidia.com>
    mlxbf_gige: return EPROBE_DEFER if PHY IRQ is not available

Kuniyuki Iwashima <kuniyu@google.com>
    calipso: Fix null-ptr-deref in calipso_req_{set,del}attr().

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe/bmg: Update Wa_16023588340

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/gt: Update handling of xe_force_wake_get return

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/xe: Wire up device shutdown handler

Ronnie Sahlberg <rsahlberg@whamcloud.com>
    ublk: santizize the arguments from userspace when adding a device

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    net: lan743x: fix potential out-of-bounds write in lan743x_ptp_io_event_clock_get()

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: avoid double free when failing to DMA-map FW msg

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

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Update MRU and RSS table of RSS contexts on queue reset

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Add a helper function to configure MRU and RSS

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: fix out-of-range access of vnic_info array

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix double invocation of bnxt_ulp_stop()/bnxt_ulp_start()

Mina Almasry <almasrymina@google.com>
    net: netmem: fix skb_ensure_writable with unreadable skbs

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add free_transport ops in ksmbd connection

Chuyi Zhou <zhouchuyi@bytedance.com>
    workqueue: Initialize wq_isolated_cpumask in workqueue_init_early()

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: set fixed clock frequency indication for Nahum 11 and Nahum 13

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix eswitch code memory leak in reset scenario

Krishna Kumar <krikku@gmail.com>
    net: ice: Perform accurate aRFS flow match

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: don't put task_struct on tctx setup failure

Justin Sanders <jsanders.devel@gmail.com>
    aoe: clean device rq_list in aoedev_downdev()

Simon Horman <horms@kernel.org>
    pldmfw: Select CRC32 when PLDMFW is selected

Nuno Sá <nuno.sa@analog.com>
    hwmon: (ltc4282) avoid repeated register write

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

John Keeping <jkeeping@inmusicbrands.com>
    drm/ssd130x: fix ssd132x_clear_screen() columns

Connor Abbott <cwabbott0@gmail.com>
    drm/msm/a7xx: Call CP_RESET_CONTEXT_STATE

Connor Abbott <cwabbott0@gmail.com>
    drm/msm: Fix CP_RESET_CONTEXT_STATE bitfield names

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/dsi_phy_10nm: Fix missing initial VCO rate

James A. MacInnes <james.a.macinnes@gmail.com>
    drm/msm/disp: Correct porch timing for SDM845

Bharath SM <bharathsm@microsoft.com>
    smb: fix secondary channel creation issue with kerberos by populating hostname when adding channels

Willem de Bruijn <willemb@google.com>
    ipv6: replace ipcm6_init calls with ipcm6_init_sk

Willem de Bruijn <willemb@google.com>
    ipv6: remove leftover ip6 cookie initializer

Nathan Chancellor <nathan@kernel.org>
    x86/tools: Drop duplicate unlikely() definition in insn_decoder_test.c

Sergio González Collado <sergio.collado@gmail.com>
    Kunit to check the longest symbol length

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Avoid NULL pointer dereference in `v3d_job_update_stats()`

Jeff Layton <jlayton@kernel.org>
    sunrpc: handle SVC_GARBAGE during svc auth processing as auth error

Jeff Layton <jlayton@kernel.org>
    nfsd: use threads array as-is in netlink interface

Gao Xiang <xiang@kernel.org>
    erofs: remove unused trace event erofs_destroy_inode

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Fix L4 csum update on IPv6 in CHECKSUM_COMPLETE

Paul Chaignon <paul.chaignon@gmail.com>
    net: Fix checksum update for ILA adj-transport

Gary Guo <gary@garyguo.net>
    rust: compile libcore with edition 2024 for 1.87+

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust: add rustc-min-version support function

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu: read back register after written for VCN v4.0.5

Jann Horn <jannh@google.com>
    mm/hugetlb: unshare page tables during VMA split, not before

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: Fix temperature calculation

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirk for Asus GU605C

Chris Chiu <chris.chiu@canonical.com>
    ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X513EA

Jonathan Lane <jon@borg.moe>
    ALSA: hda/realtek: enable headset mic on Latitude 5420 Rugged

Edip Hazuri <edip@medip.dev>
    ALSA: hda/realtek - Add mute LED support for HP Victus 16-s1xxx and HP Victus 15-fa1xxx

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/intel: Add Thinkpad E15 to PM deny list

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: Rename ALSA kcontrol PCM and PCM1 for the KTMicro sound card

Dev Jain <dev.jain@arm.com>
    arm64: Restrict pagetable teardown to avoid false warning

Edward Adam Davis <eadavis@qq.com>
    wifi: cfg80211: init wiphy_work before allocating rfkill fails

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    wifi: ath12k: Clear affinity hint before calling ath12k_pci_free_irq() in error path

WangYuli <wangyuli@uniontech.com>
    Input: sparcspkr - avoid unannotated fall-through

Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
    cpufreq/amd-pstate: Add missing NULL ptr check in amd_pstate_update

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: phy: add dummy C2H event handler for report of TAS power

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Revert atm_account_tx() if copy_from_iter_full() fails.

Tejun Heo <tj@kernel.org>
    sched_ext, sched/core: Don't call scx_group_set_weight() prematurely from sched_create_group()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Fail module load when plat_info is NULL

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: fix selinux_xfrm_alloc_user() to set correct ctx_len

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: use usleep_range() for EC polling

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference in destroy_previous_session

Xin Li (Intel) <xin@zytor.com>
    selftests/x86: Add a test to detect infinite SIGTRAP handler loop

Kai Huang <kai.huang@intel.com>
    x86/virt/tdx: Avoid indirect calls to TDX assembly functions

Marek Szyprowski <m.szyprowski@samsung.com>
    udmabuf: use sgtable-based scatterlist wrappers

Ryan Roberts <ryan.roberts@arm.com>
    mm: close theoretical race where stale TLB entries could linger

Jakub Kicinski <kuba@kernel.org>
    net: clear the dst when changing skb protocol

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: reject invalid perturb period

Jens Axboe <axboe@kernel.dk>
    nvme: always punt polled uring_cmd end_io work to task_work

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    LoongArch: vDSO: Correctly use asm parameters in syscall wrappers

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Add backlight power control support

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Unregister generic_sub_drivers on exit

Yao Zi <ziyao@disroot.org>
    platform/loongarch: laptop: Get brightness setting from EC on probe

Andrew Morton <akpm@linux-foundation.org>
    drivers/rapidio/rio_cm.c: prevent possible heap overwrite

Penglei Jiang <superman.xpt@gmail.com>
    io_uring: fix task leak issue in io_wq_create()

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: don't truncate end buffer for multiple buffer peeks

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/eeh: Fix missing PE bridge reconfiguration during VFIO EEH recovery

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Fix build of VDSO32 with pcrel

Stuart Hayes <stuart.w.hayes@gmail.com>
    platform/x86: dell_rbu: Stop overwriting data buffer

Stuart Hayes <stuart.w.hayes@gmail.com>
    platform/x86: dell_rbu: Fix list usage

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmf: Prevent amd_pmf_tee_deinit() from running twice

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

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Harden IP version definer checks

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

Chen Linxuan <chenlinxuan@uniontech.com>
    RDMA/hns: initialize db in update_srq_db()

Rand Deeb <rand.sec96@gmail.com>
    ixgbe: Fix unreachable retry logic in combined and byte I2C write functions

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

Jonas 'Sortie' Termansen <sortie@maxsi.org>
    isofs: fix Y2038 and Y2156 issues in Rock Ridge TF entry

Zijun Hu <quic_zijuhu@quicinc.com>
    software node: Correct a OOB check in software_node_get_reference_args()

Michael Walle <mwalle@kernel.org>
    net: ethernet: ti: am65-cpsw: handle -EPROBE_DEFER

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: using msdu end descriptor to check for rx multicast packets

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Remove unused field "ref_count" in struct bnxt_ulp

Ido Schimmel <idosch@nvidia.com>
    vxlan: Do not treat dst cache initialization errors as fatal

Yong Wang <yongwang@nvidia.com>
    net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions

Yong Wang <yongwang@nvidia.com>
    net: bridge: mcast: update multicast contex when vlan state is changed

Víctor Gonzalo <victor.gonzalo@anddroptable.net>
    wifi: iwlwifi: Add missing MODULE_FIRMWARE for Qu-c0-jf-b0

Toke Høiland-Jørgensen <toke@toke.dk>
    Revert "mac80211: Dynamically set CoDel parameters per station"

Muna Sinada <muna.sinada@oss.qualcomm.com>
    wifi: mac80211: VLAN traffic in multicast path

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    bpf: Use proper type to calculate bpf_raw_tp_null_args.mask index

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Fix IP version decision

Joe Damato <jdamato@fastly.com>
    netdevsim: Mark NAPI ID on skb in nsim_rcv

Edward Adam Davis <eadavis@qq.com>
    wifi: mac80211_hwsim: Prevent tsf from setting if beacon is disabled

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: 8922a: fix TX fail with wrong VCO setting

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: pcie: make sure to lock rxq->read

Sean Christopherson <seanjc@google.com>
    iommu/amd: Ensure GA log notifier callbacks finish running before module unload

David Strahan <david.strahan@microchip.com>
    scsi: smartpqi: Add new PCI IDs

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Add identical pointer detection to btf_dedup_is_equiv()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX

Chao Yu <chao@kernel.org>
    f2fs: fix to bail out in get_new_segment()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix beacon CCK flag

Luke D. Jones <luke@ljones.dev>
    hid-asus: check ROG Ally MCU version and warn

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

Mykyta Yatsenko <yatsenko@meta.com>
    libbpf: Check bpf_map_skeleton link for NULL

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_pmx_gpio_set_direction()

Jason Xing <kernelxing@tencent.com>
    net: stmmac: generate software timestamp just before the doorbell

Ilya Leoshkevich <iii@linux.ibm.com>
    bpf: Pass the same orig_call value to trampoline functions

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()

Gabor Juhos <j4g8y7@gmail.com>
    pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()

Jason Xing <kernelxing@tencent.com>
    net: atlantic: generate software timestamp just before the doorbell

Leon Romanovsky <leon@kernel.org>
    xfrm: validate assignment of maximal possible SEQ number

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: page_pool: Don't recycle into cache on PREEMPT_RT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ipv4/route: Use this_cpu_inc() for stats on PREEMPT_RT

Andrew Zaborowski <andrew.zaborowski@intel.com>
    x86/sgx: Prevent attempts to reclaim poisoned pages

Eric Dumazet <edumazet@google.com>
    tcp: add receive queue awareness in tcp_rcv_space_adjust()

Eric Dumazet <edumazet@google.com>
    tcp: fix initial tp->rcvq_space.space value for passive TS enabled flows

Eric Dumazet <edumazet@google.com>
    tcp: remove zero TCP TS samples for autotuning

Eric Dumazet <edumazet@google.com>
    tcp: always seek for minimal rtt in tcp_rcv_rtt_update()

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: leave idle mode when setting WEP encryption for AP mode

Mario Limonciello <mario.limonciello@amd.com>
    iommu/amd: Allow matching ACPI HID devices without matching UIDs

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: ath11k: Fix QMI memory reuse logic

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix a possible dead lock caused by ab->base_lock

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix macro definition HAL_RX_MSDU_PKT_LENGTH_GET

Moon Yeounsu <yyyynoom@gmail.com>
    net: dlink: add synchronization for stats update

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gcc-x1e80100: Set FORCE MEM CORE for UFS clocks

Tali Perry <tali.perry1@gmail.com>
    i2c: npcm: Add clock toggle recovery

Akhil R <akhilrajeev@nvidia.com>
    i2c: tegra: check msg length in SMBUS block read

Mike Tipton <quic_mdtipton@quicinc.com>
    cpufreq: scmi: Skip SCMI devices that aren't used by the CPUs

Alan Maguire <alan.maguire@oracle.com>
    libbpf/btf: Fix string handling to support multi-split BTF

Petr Malat <oss@malat.biz>
    sctp: Do not wake readers in __sctp_write_space()

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: mac80211: validate SCAN_FLAG_AP in scan request during MLO

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7925: introduce thermal protection

Samuel Williams <sam8641@gmail.com>
    wifi: mt76: mt7921: add 160 MHz AP for mt7922 device

Henk Vergonet <henk.vergonet@gmail.com>
    wifi: mt76: mt76x2: Add support for LiteOn WN4516R,WN4519R

Jiande Lu <jiande.lu@mediatek.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3630 for MT7925

Alok Tiwari <alok.a.tiwari@oracle.com>
    emulex/benet: correct command version selection in be_cmd_get_stats()

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: drop fragments with multicast or broadcast RA

Tan En De <ende.tan@starfivetech.com>
    i2c: designware: Invoke runtime suspend on quick slave re-registration

Liwei Sun <sunliweis@126.com>
    Bluetooth: btusb: Add new VID/PID 13d3/3584 for MT7922

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

Svyatoslav Ryhel <clamor95@gmail.com>
    power: supply: max17040: adjust thermal channel scaling

Charan Teja Kalla <quic_charante@quicinc.com>
    PM: runtime: fix denying of auto suspend in pm_suspend_timer_fn()

Peng Fan <peng.fan@nxp.com>
    gpiolib: of: Add polarity quirk for s5m8767

Linus Torvalds <torvalds@linux-foundation.org>
    Make 'cc-option' work correctly for the -Wno-xyzzy pattern

Yuanjun Gong <ruc_gongyuanjun@163.com>
    ASoC: tegra210_ahub: Add check to of_device_get_match_data()

Frank Li <Frank.Li@nxp.com>
    platform-msi: Add msi_remove_device_irq_domain() in platform_device_msi_free_irqs_all()

gldrk <me@rarity.fan>
    ACPICA: utilities: Fix overflow check in vsnprintf()

Ulf Hansson <ulf.hansson@linaro.org>
    pmdomain: core: Reset genpd->states to avoid freeing invalid data

Jerry Lv <Jerry.Lv@axis.com>
    power: supply: bq27xxx: Retrieve again when busy

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda: cs35l41: Fix swapped l/r audio channels for Acer Helios laptops

Tamir Duberstein <tamird@gmail.com>
    ACPICA: Apply pack(1) to union aml_resource

Seunghun Han <kkamagui@gmail.com>
    ACPICA: fix acpi parse and parseext cache leaks

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: Add missing prototype for non CONFIG_SUSPEND/CONFIG_X86 case

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Bail out if acpi_kobj registration fails

I Hsin Cheng <richard120310@gmail.com>
    ASoC: intel/sdw_utils: Assign initial value in asoc_sdw_rt_amp_spk_rtd_init()

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

Arthur-Prince <r2.arthur.prince@gmail.com>
    iio: adc: ti-ads1298: Kconfig: add kfifo dependency to fix module build

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7944: mask high bits on direct read

Sean Nyekjaer <sean@geanix.com>
    iio: imu: inv_icm42600: Fix temperature calculation

Jann Horn <jannh@google.com>
    mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race

Thomas Zimmermann <tzimmermann@suse.de>
    dummycon: Trigger redraw when switching consoles with deferred takeover

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix warning in ivpu_gem_bo_free()

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Use dma_resv_lock() instead of a custom mutex

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Use firmware names from upstream repo

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Improve buffer object logging

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: Fix temperature scan element sign

Diederik de Haas <didi.debian@cknow.org>
    PCI: dw-rockchip: Fix PHY function call sequence in rockchip_pcie_phy_deinit()

Shawn Lin <shawn.lin@rock-chips.com>
    PCI: dw-rockchip: Remove PCIE_L0S_ENTRY check from rockchip_pcie_link_up()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix lock symmetry in pci_slot_unlock()

Huacai Chen <chenhuacai@kernel.org>
    PCI: Add ACS quirk for Loongson PCIe

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Correct PBA offset in .set_msix() callback

Niklas Cassel <cassel@kernel.org>
    PCI: cadence-ep: Correct PBA offset in .set_msix() callback

Long Li <longli@microsoft.com>
    uio_hv_generic: Align ring size to system page

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

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-m4: Don't assert reset in detach routine

Xiaolei Wang <xiaolei.wang@windriver.com>
    remoteproc: core: Release rproc->clean_table after rproc_attach() fails

Xiaolei Wang <xiaolei.wang@windriver.com>
    remoteproc: core: Cleanup acquired resources when rproc_handle_resources() fails in rproc_attach()

Wentao Liang <vulab@iscas.ac.cn>
    regulator: max14577: Add error check for max14577_read_reg()

André Almeida <andrealmeid@igalia.com>
    ovl: Fix nested backing file paths

Khem Raj <raj.khem@gmail.com>
    mips: Add -std= flag specified in KBUILD_CFLAGS to vdso CFLAGS

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: iio: ad5933: Correct settling cycles encoding per datasheet

David Lechner <dlechner@baylibre.com>
    pwm: axi-pwmgen: fix missing separate external clock

Thomas Zimmermann <tzimmermann@suse.de>
    video: screen_info: Relocate framebuffers behind PCI bridges

Thomas Zimmermann <tzimmermann@suse.de>
    sysfb: Fix screen_info type check for VGA

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY

Qasim Ijaz <qasdev00@gmail.com>
    net: ch9200: fix uninitialised access during mii_nway_restart

Xu Yang <xu.yang_2@nxp.com>
    phy: fsl-imx8mq-usb: fix phy_tx_vboost_level_from_property()

Mikulas Patocka <mpatocka@redhat.com>
    dm: lock limits when reading them

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

Sibi Sankar <quic_sibis@quicinc.com>
    firmware: arm_scmi: Ensure that the message-id supports fastchannel

Dan Williams <dan.j.williams@intel.com>
    configfs-tsm-report: Fix NULL dereference of tsm_ops

Johan Hovold <johan+linaro@kernel.org>
    soc: qcom: pmic_glink_altmode: fix spurious DP hotplug events

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

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Restore context entry setup order for aliased devices

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

Mikko Korhonen <mjkorhon@gmail.com>
    ata: ahci: Disallow LPM for Asus B550-F motherboard

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Disallow LPM for ASUSPRO-D840SA motherboard

Tasos Sahanidis <tasos@tasossah.com>
    ata: pata_via: Force PIO for ATAPI devices on VT6415/VT6330

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    bus: firewall: Fix missing static inline annotations for stubs

Chen Ridong <chenridong@huawei.com>
    cgroup,freezer: fix incomplete freezing when attaching tasks

Dennis Marttinen <twelho@welho.tech>
    ceph: set superblock s_magic for IMA fsmagic matching

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: avoid kernel BUG for encrypted inode with unaligned file size

Brett Werling <brett.werling@garmin.com>
    can: tcan4x5x: fix power regulator retrieval during probe

Fedor Pchelkin <pchelkin@ispras.ru>
    can: kvaser_pciefd: refine error prone echo_skb_max handling logic

Jeff Hugo <quic_jhugo@quicinc.com>
    bus: mhi: host: Fix conflict between power_up and SYSERR

Sumit Kumar <quic_sumk@quicinc.com>
    bus: mhi: ep: Update read pointer only after buffer is written

Damien Le Moal <dlemoal@kernel.org>
    block: Clear BIO_EMULATES_ZONE_APPEND flag on BIO completion

Jens Axboe <axboe@kernel.dk>
    block: use plug request list tail for one-shot backmerge attempt

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd937x: Drop unused buck_supply

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9375: Fix double free of regulator supplies

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

Hao Yao <hao.yao@intel.com>
    media: ipu6: Remove workaround for Meteor Lake ES2

Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
    media: intel/ipu6: Fix dma mask for non-secure mode

Haoxiang Li <haoxiang_li2024@163.com>
    media: imagination: fix a potential memory leak in e5010_probe()

Kieran Bingham <kieran.bingham@ideasonboard.com>
    media: i2c: imx335: Fix frame size enumeration

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

Hans de Goede <hdegoede@redhat.com>
    media: ov2740: Move pm-runtime cleanup on probe-errors to proper place

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs-pll: Start VT pre-PLL multiplier search from correct value

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub913: Fix returned fmt from .set_fmt()

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    media: nxp: imx8-isi: better handle the m2m usage_count

Umang Jain <umang.jain@ideasonboard.com>
    media: imx335: Use correct register width for HNUM

Johan Hovold <johan+linaro@kernel.org>
    media: ov5675: suppress probe deferral errors

Johan Hovold <johan+linaro@kernel.org>
    media: ov8856: suppress probe deferral errors

Mingcong Bai <jeffbai@aosc.io>
    wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: usb: Reduce control message timeout to 500 ms

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Unregister the device if svc_rdma_accept() fails

Jeongjun Park <aha310510@gmail.com>
    jbd2: fix data-race and null-ptr-deref in jbd2_journal_dirty_metadata()

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath12k: fix ring-buffer corruption

Max Kellermann <max.kellermann@ionos.com>
    fs/nfs/read: fix double-unlock bug in nfs_return_empty_folio()

Scott Mayhew <smayhew@redhat.com>
    NFSv4: Don't check for OPEN feature support in v4.1

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Prevent hang on NFS mount with xprtsec=[m]tls

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: Initialize ssc before laundromat_work to prevent NULL dereference

NeilBrown <neil@brown.name>
    nfsd: nfsd4_spo_must_allow() must check this is a v4 compound request

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Implement FATTR4_CLONE_BLKSIZE attribute

Maninder Singh <maninder1.s@samsung.com>
    NFSD: fix race between nfsd registration and exports_proc

Maninder Singh <maninder1.s@samsung.com>
    NFSD: unregister filesystem in case genl_register_family() fails

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix ring-buffer corruption

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: usb: Upload the firmware in bigger chunks

Johan Hovold <johan+linaro@kernel.org>
    wifi: ath11k: fix rx completion meta data corruption

Michael Lo <michael.lo@mediatek.com>
    wifi: mt76: mt7925: fix host interrupt register initialization

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

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Serialize device addition and removal

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Allow re-add of a reserved but not yet removed device

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Prevent self deletion in disable_slot()

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Remove redundant bus removal and disable from zpci_release_device()

Gautam Menghani <gautam@linux.ibm.com>
    powerpc/pseries/msi: Avoid reading PCI device registers in reduced power states

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: account ring io_buffer_list memory

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: account drain memory to cgroup

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: sof_amd_sdw: Fix unlikely uninitialized variable use in create_sdw_dailinks()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ASoC: meson: meson-card-utils: use of_property_present() for DT parsing

Wentao Liang <vulab@iscas.ac.cn>
    ASoC: qcom: sdm845: Add error handling in sdm845_slim_snd_hw_params()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add shutdown handler to qat_dh895xcc

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add shutdown handler to qat_c62x

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add shutdown handler to qat_4xxx

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add shutdown handler to qat_420xx

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add shutdown handler to qat_c3xxx

Alexander Aring <aahringo@redhat.com>
    gfs2: move msleep to sleepable context

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Do not chain submitted requests

Zijun Hu <quic_zijuhu@quicinc.com>
    configfs: Do not override creating attribute file failure in populate_attrs()


-------------

Diffstat:

 .../bindings/i2c/nvidia,tegra20-i2c.yaml           |  24 ++-
 Documentation/kbuild/makefiles.rst                 |  14 ++
 Makefile                                           |   4 +-
 arch/arm/mach-omap2/clockdomain.h                  |   1 +
 arch/arm/mach-omap2/clockdomains33xx_data.c        |   2 +-
 arch/arm/mach-omap2/cm33xx.c                       |  14 +-
 arch/arm/mach-omap2/pmic-cpcap.c                   |   6 +-
 arch/arm/mm/ioremap.c                              |   4 +-
 arch/arm64/Makefile                                |   2 +-
 arch/arm64/include/asm/tlbflush.h                  |   9 +-
 arch/arm64/kernel/ptrace.c                         |   2 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/loongarch/include/asm/irqflags.h              |  16 +-
 arch/loongarch/include/asm/vdso/getrandom.h        |   2 +-
 arch/loongarch/include/asm/vdso/gettimeofday.h     |   6 +-
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
 arch/s390/pci/pci.c                                |  45 ++--
 arch/s390/pci/pci_bus.h                            |   7 +-
 arch/s390/pci/pci_event.c                          |  22 +-
 arch/s390/pci/pci_mmio.c                           |   2 +-
 arch/x86/include/asm/tdx.h                         |   2 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   2 +
 arch/x86/kvm/svm/svm.c                             |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   5 +-
 arch/x86/tools/insn_decoder_test.c                 |   5 +-
 arch/x86/virt/vmx/tdx/tdx.c                        |   5 +-
 block/blk-merge.c                                  |  26 +--
 block/blk-zoned.c                                  |   1 +
 drivers/accel/ivpu/ivpu_fw.c                       |  12 +-
 drivers/accel/ivpu/ivpu_gem.c                      |  91 ++++----
 drivers/accel/ivpu/ivpu_gem.h                      |   2 +-
 drivers/acpi/acpica/amlresrc.h                     |   8 +-
 drivers/acpi/acpica/dsutils.c                      |   9 +-
 drivers/acpi/acpica/psobject.c                     |  52 ++---
 drivers/acpi/acpica/rsaddr.c                       |  13 +-
 drivers/acpi/acpica/rscalc.c                       |  22 +-
 drivers/acpi/acpica/rslist.c                       |  12 +-
 drivers/acpi/acpica/utprint.c                      |   7 +-
 drivers/acpi/acpica/utresrc.c                      |  14 +-
 drivers/acpi/battery.c                             |  19 +-
 drivers/acpi/bus.c                                 |   6 +-
 drivers/ata/ahci.c                                 |  35 ++-
 drivers/ata/pata_via.c                             |   3 +-
 drivers/atm/atmtcp.c                               |   4 +-
 drivers/base/platform-msi.c                        |   1 +
 drivers/base/power/runtime.c                       |   2 +-
 drivers/base/swnode.c                              |   2 +-
 drivers/block/aoe/aoedev.c                         |   8 +
 drivers/block/ublk_drv.c                           |   3 +
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/bus/fsl-mc/fsl-mc-uapi.c                   |   4 +-
 drivers/bus/fsl-mc/mc-io.c                         |  19 +-
 drivers/bus/fsl-mc/mc-sys.c                        |   2 +-
 drivers/bus/mhi/ep/ring.c                          |  16 +-
 drivers/bus/mhi/host/pm.c                          |  18 +-
 drivers/bus/ti-sysc.c                              |  49 -----
 drivers/clk/meson/g12a.c                           |   1 +
 drivers/clk/qcom/gcc-x1e80100.c                    |   4 +
 drivers/clk/rockchip/clk-rk3036.c                  |   1 +
 drivers/cpufreq/amd-pstate.c                       |   3 +
 drivers/cpufreq/scmi-cpufreq.c                     |  36 +++-
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c       |   8 +
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   8 +
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c       |   8 +
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c        |   8 +
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c    |   8 +
 drivers/crypto/marvell/cesa/cesa.c                 |   2 +-
 drivers/crypto/marvell/cesa/cesa.h                 |   9 +-
 drivers/crypto/marvell/cesa/tdma.c                 |  53 +++--
 drivers/dma-buf/udmabuf.c                          |   5 +-
 drivers/edac/altera_edac.c                         |   6 +-
 drivers/edac/amd64_edac.c                          |   1 +
 drivers/firmware/arm_scmi/driver.c                 |  76 ++++---
 drivers/firmware/arm_scmi/protocols.h              |   2 +
 drivers/firmware/sysfb.c                           |  26 ++-
 drivers/gpio/gpio-mlxbf3.c                         |  52 +++--
 drivers/gpio/gpio-pca953x.c                        |   2 +-
 drivers/gpio/gpiolib-of.c                          |   9 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   8 +
 drivers/gpu/drm/i915/i915_pmu.c                    |   4 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  14 ++
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |  14 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_10nm.c         |   7 +
 .../gpu/drm/msm/registers/adreno/adreno_pm4.xml    |   3 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |   2 +-
 drivers/gpu/drm/solomon/ssd130x.c                  |   2 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   8 +-
 drivers/gpu/drm/xe/display/xe_display.c            |  43 ++++
 drivers/gpu/drm/xe/display/xe_display.h            |   4 +
 drivers/gpu/drm/xe/xe_device.c                     |  40 +++-
 drivers/gpu/drm/xe/xe_gt.c                         | 110 ++++++----
 drivers/gpu/drm/xe/xe_gt.h                         |   1 +
 drivers/hid/hid-asus.c                             | 107 ++++++++-
 drivers/hv/connection.c                            |  23 +-
 drivers/hwmon/ftsteutates.c                        |   9 +-
 drivers/hwmon/ltc4282.c                            |   7 -
 drivers/hwmon/occ/common.c                         | 238 +++++++++------------
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/i2c/busses/i2c-npcm7xx.c                   |  12 +-
 drivers/i2c/busses/i2c-tegra.c                     |   5 +
 drivers/iio/accel/fxls8962af-core.c                |  15 +-
 drivers/iio/adc/Kconfig                            |   1 +
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/adc/ad7944.c                           |   2 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c   |   8 +-
 drivers/infiniband/core/iwcm.c                     |  29 +--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   2 +-
 drivers/input/keyboard/gpio_keys.c                 |   2 +
 drivers/input/misc/ims-pcu.c                       |   6 +
 drivers/input/misc/sparcspkr.c                     |  22 +-
 drivers/iommu/amd/iommu.c                          |  41 +++-
 drivers/iommu/intel/iommu.c                        |  11 +
 drivers/iommu/intel/iommu.h                        |   1 +
 drivers/iommu/intel/nested.c                       |   4 +-
 drivers/md/dm-raid1.c                              |   5 +-
 drivers/md/dm-table.c                              |   8 +-
 drivers/md/dm-verity-fec.c                         |   4 +
 drivers/md/dm-verity-target.c                      |   8 +-
 drivers/md/dm-verity-verify-sig.c                  |  17 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |   4 +-
 drivers/media/i2c/ccs-pll.c                        |  11 +-
 drivers/media/i2c/ds90ub913.c                      |   4 +-
 drivers/media/i2c/imx335.c                         |   5 +-
 drivers/media/i2c/ov2740.c                         |   4 +-
 drivers/media/i2c/ov5675.c                         |   5 +-
 drivers/media/i2c/ov8856.c                         |   9 +-
 drivers/media/pci/intel/ipu6/ipu6-dma.c            |   4 +-
 drivers/media/pci/intel/ipu6/ipu6.c                |   5 -
 .../media/platform/imagination/e5010-jpeg-enc.c    |   9 +-
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
 drivers/net/can/kvaser_pciefd.c                    |   3 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |   9 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |   1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  91 ++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |  29 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h      |   1 -
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
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   6 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |   4 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   9 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   1 +
 .../mlx5/core/steering/hws/mlx5hws_definer.c       |  78 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  18 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |   6 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |   5 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  18 +-
 drivers/net/ethernet/microchip/lan743x_ptp.h       |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   7 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  24 ++-
 drivers/net/ethernet/vertexcom/mse102x.c           |  15 +-
 drivers/net/netdevsim/netdev.c                     |   2 +
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
 drivers/net/wireless/ath/ath12k/hal.c              |  12 +-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   2 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   5 +
 drivers/net/wireless/ath/ath12k/wmi.c              |  20 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  19 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   6 +
 drivers/net/wireless/intersil/p54/fwio.c           |   2 +
 drivers/net/wireless/intersil/p54/p54.h            |   1 +
 drivers/net/wireless/intersil/p54/txrx.c           |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   2 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   5 +
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  20 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |   3 -
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   8 +
 drivers/net/wireless/purelifi/plfxlc/usb.c         |   4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  10 +
 drivers/net/wireless/realtek/rtw88/hci.h           |   8 +
 drivers/net/wireless/realtek/rtw88/mac.c           |  11 +-
 drivers/net/wireless/realtek/rtw88/mac.h           |   2 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   2 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |   2 +
 drivers/net/wireless/realtek/rtw88/usb.c           |  57 ++++-
 drivers/net/wireless/realtek/rtw89/cam.c           |   3 +
 drivers/net/wireless/realtek/rtw89/mac.c           |   4 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  10 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c  |   5 -
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   5 +
 drivers/nvme/host/ioctl.c                          |  21 +-
 drivers/pci/controller/cadence/pcie-cadence-ep.c   |   5 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   5 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   6 +-
 drivers/pci/hotplug/s390_pci_hpc.c                 |   2 +-
 drivers/pci/pci.c                                  |   3 +-
 drivers/pci/quirks.c                               |  23 ++
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c         |  10 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  21 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   8 +
 drivers/platform/loongarch/loongson-laptop.c       |  87 ++++----
 drivers/platform/x86/amd/pmc/pmc.c                 |   2 +
 drivers/platform/x86/amd/pmf/tee-if.c              |  11 +-
 drivers/platform/x86/dell/dell_rbu.c               |   6 +-
 drivers/platform/x86/ideapad-laptop.c              |  19 +-
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   9 +-
 drivers/pmdomain/core.c                            |   4 +-
 drivers/power/supply/bq27xxx_battery.c             |   2 +-
 drivers/power/supply/bq27xxx_battery_i2c.c         |  13 +-
 drivers/power/supply/collie_battery.c              |   1 +
 drivers/power/supply/max17040_battery.c            |   5 +-
 drivers/ptp/ptp_clock.c                            |   3 +-
 drivers/ptp/ptp_private.h                          |  22 +-
 drivers/pwm/pwm-axi-pwmgen.c                       |  23 +-
 drivers/rapidio/rio_cm.c                           |   3 +
 drivers/regulator/max14577-regulator.c             |   5 +-
 drivers/regulator/max20086-regulator.c             |   4 +-
 drivers/remoteproc/remoteproc_core.c               |   6 +-
 drivers/remoteproc/ti_k3_m4_remoteproc.c           |   2 +-
 drivers/s390/scsi/zfcp_sysfs.c                     |   2 +
 drivers/scsi/elx/efct/efct_hw.c                    |   5 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |  84 ++++++++
 drivers/scsi/storvsc_drv.c                         |  10 +-
 drivers/soc/qcom/pmic_glink_altmode.c              |  30 ++-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   2 +-
 drivers/tee/tee_core.c                             |  11 +-
 drivers/tty/serial/sh-sci.c                        |  48 ++++-
 drivers/uio/uio_hv_generic.c                       |   7 +-
 drivers/video/console/dummycon.c                   |  18 +-
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/core/fbcon.c                   |   7 +-
 drivers/video/fbdev/core/fbmem.c                   |  22 +-
 drivers/video/screen_info_pci.c                    |  75 ++++---
 drivers/virt/coco/tsm.c                            |  31 ++-
 drivers/watchdog/da9052_wdt.c                      |   1 +
 fs/ceph/addr.c                                     |   9 +
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
 fs/f2fs/segment.c                                  |  12 +-
 fs/f2fs/super.c                                    |  12 +-
 fs/gfs2/lock_dlm.c                                 |   3 +-
 fs/isofs/inode.c                                   |   7 +-
 fs/isofs/isofs.h                                   |   4 +-
 fs/isofs/rock.c                                    |  40 ++--
 fs/isofs/rock.h                                    |   6 +-
 fs/isofs/util.c                                    |  51 +++--
 fs/jbd2/transaction.c                              |   5 +-
 fs/jffs2/erase.c                                   |   4 +-
 fs/jffs2/scan.c                                    |   4 +-
 fs/jffs2/summary.c                                 |   7 +-
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/nfs/read.c                                      |   3 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfs4xdr.c                                  |  19 +-
 fs/nfsd/nfsctl.c                                   |  26 +--
 fs/nfsd/nfssvc.c                                   |   6 +-
 fs/overlayfs/file.c                                |   4 +-
 fs/smb/client/cached_dir.c                         |  14 +-
 fs/smb/client/cached_dir.h                         |   8 +-
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/connect.c                            |  17 +-
 fs/smb/client/namespace.c                          |   3 +
 fs/smb/client/readdir.c                            |  28 +--
 fs/smb/client/reparse.c                            |   1 -
 fs/smb/client/sess.c                               |   7 +-
 fs/smb/client/smb2pdu.c                            |  33 ++-
 fs/smb/client/smbdirect.c                          |   5 +-
 fs/smb/client/transport.c                          |  14 +-
 fs/smb/server/connection.c                         |   2 +-
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  11 +-
 fs/smb/server/transport_rdma.c                     |  10 +-
 fs/smb/server/transport_tcp.c                      |   3 +-
 fs/xattr.c                                         |   1 +
 include/acpi/actypes.h                             |   2 +-
 include/linux/acpi.h                               |   9 +-
 include/linux/atmdev.h                             |   6 +
 include/linux/bus/stm32_firewall_device.h          |  15 +-
 include/linux/f2fs_fs.h                            |   1 +
 include/linux/hugetlb.h                            |   3 +
 include/linux/mmc/card.h                           |   1 +
 include/linux/tcp.h                                |   2 +-
 include/net/checksum.h                             |   2 +-
 include/net/ipv6.h                                 |   9 -
 include/net/mac80211.h                             |  16 --
 include/trace/events/erofs.h                       |  18 --
 include/uapi/linux/bpf.h                           |   2 +
 io_uring/io-wq.c                                   |   4 +-
 io_uring/io_uring.c                                |   2 +-
 io_uring/kbuf.c                                    |   7 +-
 io_uring/sqpoll.c                                  |   5 +-
 ipc/shm.c                                          |   5 +-
 kernel/bpf/bpf_struct_ops.c                        |   2 +-
 kernel/bpf/btf.c                                   |   4 +-
 kernel/bpf/helpers.c                               |   3 +-
 kernel/cgroup/legacy_freezer.c                     |   3 +-
 kernel/events/core.c                               |  80 +++++--
 kernel/exit.c                                      |  17 +-
 kernel/sched/core.c                                |   4 +-
 kernel/sched/ext.c                                 |   5 +
 kernel/sched/ext.h                                 |   2 +
 kernel/time/clocksource.c                          |   2 +-
 kernel/trace/ftrace.c                              |  10 +-
 kernel/watchdog.c                                  |  41 ++--
 kernel/workqueue.c                                 |   3 +-
 lib/Kconfig                                        |   1 +
 lib/Kconfig.debug                                  |   9 +
 lib/Makefile                                       |   2 +
 lib/longest_symbol_kunit.c                         |  82 +++++++
 mm/hugetlb.c                                       |  67 ++++--
 mm/madvise.c                                       |   2 +
 mm/page-writeback.c                                |   2 +-
 mm/vma.c                                           |   7 +
 mm/vma_internal.h                                  |   1 +
 net/atm/common.c                                   |   1 +
 net/atm/lec.c                                      |  12 +-
 net/atm/raw.c                                      |   2 +-
 net/bridge/br_mst.c                                |   4 +-
 net/bridge/br_multicast.c                          | 103 ++++++++-
 net/bridge/br_private.h                            |  11 +-
 net/core/filter.c                                  |  24 ++-
 net/core/page_pool.c                               |   4 +
 net/core/skbuff.c                                  |   3 -
 net/core/skmsg.c                                   |   3 +-
 net/core/sock.c                                    |   4 +-
 net/core/utils.c                                   |   4 +-
 net/ipv4/route.c                                   |   4 +
 net/ipv4/tcp_fastopen.c                            |   3 +
 net/ipv4/tcp_input.c                               |  79 ++++---
 net/ipv6/calipso.c                                 |   8 +
 net/ipv6/ila/ila_common.c                          |   6 +-
 net/ipv6/ip6_output.c                              |   2 -
 net/ipv6/raw.c                                     |   8 +-
 net/ipv6/udp.c                                     |   7 +-
 net/l2tp/l2tp_ip6.c                                |   8 +-
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/debugfs_sta.c                         |   6 -
 net/mac80211/mesh_hwmp.c                           |   6 +-
 net/mac80211/rate.c                                |   2 -
 net/mac80211/sta_info.c                            |  28 ---
 net/mac80211/sta_info.h                            |  11 -
 net/mac80211/tx.c                                  |  15 +-
 net/mpls/af_mpls.c                                 |   4 +-
 net/netfilter/nft_set_pipapo.c                     |   6 +
 net/nfc/nci/uart.c                                 |   8 +-
 net/sched/sch_sfq.c                                |  10 +-
 net/sched/sch_taprio.c                             |   6 +-
 net/sctp/socket.c                                  |   3 +-
 net/sunrpc/svc.c                                   |  11 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   1 +
 net/sunrpc/xprtsock.c                              |   5 +
 net/tipc/crypto.c                                  |   2 +-
 net/tipc/udp_media.c                               |   4 +-
 net/wireless/core.c                                |   6 +-
 net/xfrm/xfrm_user.c                               |  52 ++++-
 rust/Makefile                                      |  14 +-
 scripts/Makefile.compiler                          |   8 +-
 scripts/generate_rust_analyzer.py                  |  13 +-
 security/selinux/xfrm.c                            |   2 +-
 sound/pci/hda/cs35l41_hda_property.c               |   6 +
 sound/pci/hda/hda_intel.c                          |   2 +
 sound/pci/hda/patch_realtek.c                      |   5 +
 sound/soc/amd/acp/acp-sdw-sof-mach.c               |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   9 +-
 sound/soc/codecs/tas2770.c                         |  30 ++-
 sound/soc/codecs/wcd937x.c                         |   7 +-
 sound/soc/meson/meson-card-utils.c                 |   2 +-
 sound/soc/qcom/sdm845.c                            |   4 +
 sound/soc/sdw_utils/soc_sdw_rt_amp.c               |   2 +-
 sound/soc/tegra/tegra210_ahub.c                    |   2 +
 sound/usb/mixer_maps.c                             |  12 ++
 tools/bpf/bpftool/cgroup.c                         |  12 +-
 tools/include/uapi/linux/bpf.h                     |   2 +
 tools/lib/bpf/btf.c                                |  18 +-
 tools/lib/bpf/libbpf.c                             |   6 +
 tools/perf/tests/tests-scripts.c                   |   1 +
 tools/perf/util/print-events.c                     |   1 +
 tools/testing/selftests/x86/Makefile               |   2 +-
 tools/testing/selftests/x86/sigtrap_loop.c         | 101 +++++++++
 tools/testing/vma/vma_internal.h                   |   2 +
 440 files changed, 3888 insertions(+), 1705 deletions(-)


