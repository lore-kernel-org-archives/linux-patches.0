Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E81280A47;
	Wed, 23 Apr 2025 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419561; cv=none; b=W9e26QQJdia0t8t/3XsCy4h52P87j8VrUu+UW/ILpCIVRWMUbscaHCCIdYDFeSXdKT7QH5+Mgv2aN3gP+3HTiP/XnvaVeBn2jvv6XCFOYZR92jPu2FY5XMWj2buL+vLZIUP8382xYjYKjf2ftjjZtW7DUkza5l/EQpURs9P9C8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419561; c=relaxed/simple;
	bh=5Bj5VkUeY9R4p/VwU1mpKnkzOMtlOkygFdHHwy3OIjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tbunAIxhxvERXXNuY8iYEsOuk7M/vFT7wKyjS39i1XxwqZo3GfclvR89H7lUf9abDPOd5uHanvtcqGc87I7q6ilTpfMioL2DqGq0qEfV6Da0rL7JeEa5fWwtRR04uCeSV/HB/N2tD6z909j3exAPHkNDLNEykjczejRnmxq9Yxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCNDdXnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCNDdXnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8118CC4CEE3;
	Wed, 23 Apr 2025 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419561;
	bh=5Bj5VkUeY9R4p/VwU1mpKnkzOMtlOkygFdHHwy3OIjg=;
	h=From:To:Cc:Subject:Date:From;
	b=kCNDdXnwKMM15fd34eJPXIddO2v7V0gTuPMlejY7m7DbZRP4gNIMlKh0i8e5XPNEA
	 uxwbZhHmCo5p9dy6yCeuxI+LgAv9bXinc+OwbXQI0DvY7wFhz56Yq6ZHnN/cLEnG1N
	 8XybGef9X0jq6BrRqjHQOVVAdKqNlOpdr6IoyvVM=
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
Subject: [PATCH 6.1 000/291] 6.1.135-rc1 review
Date: Wed, 23 Apr 2025 16:39:49 +0200
Message-ID: <20250423142624.409452181@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.135-rc1
X-KernelTest-Deadline: 2025-04-25T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.135 release.
There are 291 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.135-rc1

WangYuli <wangyuli@uniontech.com>
    MIPS: ds1287: Match ds1287_set_base_clock() function types

WangYuli <wangyuli@uniontech.com>
    MIPS: cevt-ds1287: Add missing ds1287.h include

WangYuli <wangyuli@uniontech.com>
    MIPS: dec: Declare which_prom() as static

Jan Stancek <jstancek@redhat.com>
    sign-file,extract-cert: use pkcs11 provider for OPENSSL MAJOR >= 3

Jan Stancek <jstancek@redhat.com>
    sign-file,extract-cert: avoid using deprecated ERR_get_error_line()

Jan Stancek <jstancek@redhat.com>
    sign-file,extract-cert: move common SSL helper functions to a header

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: fix apply_to_existing_page_range()

Li Nan <linan122@huawei.com>
    blk-iocost: do not WARN if iocg was already offlined

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: support to track if policy is online

Xu Kuohai <xukuohai@huawei.com>
    bpf: Prevent tail call between progs attached to different hooks

Andrii Nakryiko <andrii@kernel.org>
    bpf: avoid holding freeze_mutex during mmap operation

Haisu Wang <haisuwang@tencent.com>
    btrfs: fix the length of reserved qgroup to free

Jakub Kicinski <kuba@kernel.org>
    net/sched: act_mirred: don't override retval if we already lost the skb

Paulo Alcantara <pc@cjr.nz>
    cifs: use origin fullpath for automounts

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()

WangYuli <wangyuli@uniontech.com>
    nvmet-fc: Remove unused functions

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "LoongArch: BPF: Fix off-by-one error in build_prologue()"

Mickaël Salaün <mic@digikod.net>
    landlock: Add the errata interface

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Xen/swiotlb: mark xen_swiotlb_fixup() __init"

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix zone finishing with missing devices

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix zone activation with missing devices

Boris Burkov <boris@bur.io>
    btrfs: fix qgroup reserve leaks in cow_file_range

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Eliminate superfluous get_numa_distances_cnt()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()

Ard Biesheuvel <ardb@kernel.org>
    x86/pvh: Call C code via the kernel virtual mapping

Maksim Davydov <davydov-max@yandex-team.ru>
    x86/split_lock: Fix the delayed detection logic

Alex Williamson <alex.williamson@redhat.com>
    mm: Fix is_zero_page() usage in try_grab_page()

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix 'irq_type' to convey the correct type

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting freebind & transparent

Arnd Bergmann <arnd@arndb.de>
    media: mediatek: vcodec: mark vdec_vp9_slice_map_counts_eob_coef noinline

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reference count policy in cpufreq_update_limits()

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Eagerly switch ZCR_EL{1,2}

Fuad Tabba <tabba@google.com>
    KVM: arm64: Calculate cptr_el2 traps on activating traps

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Mark some header functions as inline

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Refactor exit handlers

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove VHE host restore of CPACR_EL1.ZEN

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Remove host FPSIMD saving for non-protected KVM

Mark Rutland <mark.rutland@arm.com>
    KVM: arm64: Unconditionally save+flush host FPSIMD/SVE/SME state

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Have KVM explicitly say which FP registers to save

Mark Brown <broonie@kernel.org>
    arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE

Mark Brown <broonie@kernel.org>
    KVM: arm64: Discard any SVE state when entering KVM guests

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fix accept multishot handling

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gvt: fix unterminated-string-initialization warning

Rolf Eike Beer <eb@emlix.com>
    drm/sti: remove duplicate object names

Chris Bainbridge <chris.bainbridge@gmail.com>
    drm/nouveau: prime: fix ttm_bo_delayed_delete oops

Matthew Auld <matthew.auld@intel.com>
    drm/amdgpu/dma_buf: fix page_link check

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/vega20_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/swsmu/smu13/smu_v13_0: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay/hwmgr/smu7_thermal: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/smu11: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm/powerplay: Prevent division by zero

Denis Arefev <arefev@swemel.ru>
    drm/amd/pm: Prevent division by zero

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Handle being compiled without SI or CIK support better

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/a6xx: Fix stale rpmh votes from GPU

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/repaper: fix integer overflows in repeat functions

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SPR

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on ICX

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Fix the scale of IIO free running counters on SNR

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Allow to update user space GPRs from PEBS records

Sharath Srinivasan <sharath.srinivasan@oracle.com>
    RDMA/cma: Fix workqueue crash in cma_netevent_work_handler

Peter Griffin <peter.griffin@linaro.org>
    scsi: ufs: exynos: Ensure consistent phy reference counts

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Block zero-length ATA VPD inquiry

Xiangsheng Hou <xiangsheng.hou@mediatek.com>
    virtiofs: add filesystem context source name check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix filter string testing

Peter Collingbourne <pcc@google.com>
    string: Add load_unaligned_zeropad() code path to sized_strscpy()

Chunjie Zhu <chunjie.zhu@cloud.com>
    smb3 client: fix open hardlink on deferred close file error

Nathan Chancellor <nathan@kernel.org>
    riscv: Avoid fortify warning in syscall_get_arguments()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix the warning from __kernel_write_iter

Denis Arefev <arefev@swemel.ru>
    ksmbd: Prevent integer overflow in calculation of deadtime

Sean Heelan <seanheelan@gmail.com>
    ksmbd: Fix dangling pointer in krb_authenticate

Vishal Moola (Oracle) <vishal.moola@gmail.com>
    mm: fix filemap_get_folios_contig returning batches of identical folios

Baoquan He <bhe@redhat.com>
    mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    loop: LOOP_SET_FD: send uevents for partitions

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    loop: properly send KOBJ_CHANGED uevent for disk device

Edward Adam Davis <eadavis@qq.com>
    isofs: Prevent the use of too small fid

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    i2c: cros-ec-tunnel: defer probe if parent EC is not present

Vasiliy Kovalev <kovalev@altlinux.org>
    hfs/hfsplus: fix slab-out-of-bounds in hfs_bnode_read_key

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: caam/qi - Fix drv_ctx refcount bug

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Avoid using inconsistent policy->min and policy->max

Johannes Kimmel <kernel@bareminimum.eu>
    btrfs: correctly escape subvol in btrfs_show_options()

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: decrease sc_count directly if fail to queue dl_recall

Eric Biggers <ebiggers@google.com>
    nfs: add missing selections of CONFIG_CRC32

Jeff Layton <jlayton@kernel.org>
    nfs: move nfs_fhandle_hash to common include file

Denis Arefev <arefev@swemel.ru>
    asus-laptop: Fix an uninitialized variable

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs:lpass-wsa-macro: Fix logic of enabling vi channels

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs:lpass-wsa-macro: Fix vi feedback rate

Alex Williamson <alex.williamson@redhat.com>
    Revert "PCI: Avoid reset when disabled via sysfs"

Andreas Gruenbacher <agruenba@redhat.com>
    writeback: fix false warning in inode_to_wb()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq/sched: Fix the usage of CPUFREQ_NEED_UPDATE_LIMITS

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Remove ".option norvc/.option rvc" for kgdb_compiled_break

WangYuli <wangyuli@uniontech.com>
    riscv: KGDB: Do not inline arch_kgdb_breakpoint()

Björn Töpel <bjorn@rivosinc.com>
    riscv: Properly export reserved regions in /proc/iomem

Sagi Maimon <maimon.sagi@gmail.com>
    ptp: ocp: fix start time alignment in ptp_ocp_signal_set

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: fix -ENOENT when deleting VLANs and MST is unsupported

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: avoid unregistering devlink regions which were never registered

Jonas Gorski <jonas.gorski@gmail.com>
    net: bridge: switchdev: do not notify new brentries as changed

Jonas Gorski <jonas.gorski@gmail.com>
    net: b53: enable BPDU reception for management port

Abdun Nihaal <abdun.nihaal@gmail.com>
    cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix nested key length validation in the set() action

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Set SOCK_RCU_FREE

Matthew Wilcox (Oracle) <willy@infradead.org>
    test suite: use %zu to print size_t

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: cleanup PTP module if probe fails

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: handle the IGC_PTP_ENABLED flag correctly

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: move ktime snapshot into PTM retry loop

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: fix PTM cycle trigger logic

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: l2cap: Check encryption key size on incoming connection

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: btrtl: Prevent potential NULL dereference

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix sending MGMT_EV_DEVICE_FOUND for invalid address

Shay Drory <shayd@nvidia.com>
    RDMA/core: Silence oversized kvmalloc() warning

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix wrong maximum DMA segment size

Yue Haibing <yuehaibing@huawei.com>
    RDMA/usnic: Fix passing zero to PTR_ERR in usnic_ib_pci_probe()

Zheng Qixing <zhengqixing@huawei.com>
    md/md-bitmap: fix stats collection for external bitmaps

Yu Kuai <yukuai3@huawei.com>
    md/raid10: fix missing discard IO accounting

Miaoqian Lin <linmq006@gmail.com>
    scsi: iscsi: Fix missing scsi_host_put() in error path

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: wl1251: fix memory leak in wl1251_tx_work

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Purge vif txq in ieee80211_do_stop()

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: at76c50x: fix use after free access in at76_disconnect

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Enable force phy when SATA disk directly connected

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    HSI: ssi_protocol: Fix use after free vulnerability in ssi_protocol Driver Due to Race Condition

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: Fix another race during initialization

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    x86/e820: Fix handling of subpage regions when calculating nosave ranges in e820__register_nosave_regions()

Nathan Chancellor <nathan@kernel.org>
    ACPI: platform-profile: Fix CFI violation when accessing sysfs files

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: close fd_in before returning in main_loop

Stephan Gerhold <stephan.gerhold@linaro.org>
    pinctrl: qcom: Clear latched interrupt status when changing IRQ type

Ma Ke <make24@iscas.ac.cn>
    PCI: Fix reference leak in pci_alloc_child_bus()

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakages in of_irq_init()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakages in of_irq_count()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API of_irq_parse_raw()

Zijun Hu <quic_zijuhu@quicinc.com>
    of/irq: Fix device node refcount leakage in API of_irq_parse_one()

Fedor Pchelkin <pchelkin@ispras.ru>
    ntb: use 64-bit arithmetic for the MSI doorbell mask

Sean Christopherson <seanjc@google.com>
    KVM: x86: Acquire SRCU in KVM_GET_MP_STATE to protect guest memory accesses

Joshua Washington <joshwash@google.com>
    gve: handle overflow when reporting TX consumed descriptors

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    gpio: zynq: Fix wakeup source leaks on device unbind

Guixin Liu <kanie@linux.alibaba.com>
    gpio: tegra186: fix resource handling in ACPI probe path

zhoumin <teczm@foxmail.com>
    ftrace: Add cond_resched() to ftrace_graph_set_hash()

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix prefetch-vs-suspend race

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: set ti->error on memory allocation failure

Mikulas Patocka <mpatocka@redhat.com>
    dm-ebs: fix prefetch-vs-suspend race

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Fix check for the primary ASP device

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: gdsc: Set retain_ff before moving to HW CTRL

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gdsc: Capture pm_genpd_add_subdomain result code

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gdsc: Release pm subdomains in reverse add order

Roman Smirnov <r.smirnov@omp.ru>
    cifs: fix integer overflow in match_server()

Alexandra Diupina <adiupina@astralinux.ru>
    cifs: avoid NULL pointer dereference in dbg call

Trevor Woerner <twoerner@gmail.com>
    thermal/drivers/rockchip: Add missing rk3328 mapping entry

Ricardo Cañuelo Navarro <rcn@igalia.com>
    sctp: detect and prevent references to a freed transport in sendmsg

Shuai Xue <xueshuai@linux.alibaba.com>
    mm/hwpoison: do not send SIGBUS to processes with recovered clean pages

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock

David Hildenbrand <david@redhat.com>
    mm/rmap: reject hugetlb folios in folio_make_device_exclusive()

Ryan Roberts <ryan.roberts@arm.com>
    sparc/mm: disable preemption in lazy mmu mode

Filipe Manana <fdmanana@suse.com>
    btrfs: fix non-empty delayed iputs list on unmount due to compressed write workers

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173: Fix disp-pwm compatible string

Zhenhua Huang <quic_zhenhuah@quicinc.com>
    arm64: mm: Correct the update of max_pfn

Wentao Liang <vulab@iscas.ac.cn>
    mtd: rawnand: Add status chack in r852_ready()

Wentao Liang <vulab@iscas.ac.cn>
    mtd: inftlcore: Add error check for inftl_read_oob()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: only inc MPJoinAckHMacFailure for HMAC failures

Gang Yan <yangang@kylinos.cn>
    mptcp: fix NULL pointer in can_accept_new_subflow

T Pratham <t-pratham@ti.com>
    lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()

Chenyuan Yang <chenyuan0y@gmail.com>
    mfd: ene-kb3930: Fix a potential NULL pointer dereference

Jan Kara <jack@suse.cz>
    jbd2: remove wrong sb->s_sequence check

Manjunatha Venkatesh <manjunatha.venkatesh@nxp.com>
    i3c: Add NULL pointer check in i3c_master_queue_ibi()

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Use readsb helper for reading MDB

Steve French <stfrench@microsoft.com>
    smb311 client: fix missing tcon check when mounting with linux/posix extensions

Chenyuan Yang <chenyuan0y@gmail.com>
    soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix oversized null mkey longer than 32bit

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    ext4: fix off-by-one error in do_split

Jeff Hugo <quic_jhugo@quicinc.com>
    bus: mhi: host: Fix race between unprepare and queue_buf

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qdsp6: q6asm-dai: fix q6asm_dai_compr_set_params error path

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6apm-dai: fix capture pipeline overruns.

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6apm-dai: set 10 ms period and buffer alignment.

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: reject zero sized provided buffers

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    wifi: mac80211: fix integer overflow in hwmp_route_info_get()

Haoxiang Li <haoxiang_li2024@163.com>
    wifi: mt76: Add check for devm_kstrdup()

Alexandre Torgue <alexandre.torgue@foss.st.com>
    clocksource/drivers/stm32-lptimer: Use wakeup capable instead of init wakeup

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Replace kcalloc() with devm_kcalloc()

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: workaround RGMII transmit delay erratum for 6320 family

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    mtd: Add check for devm_kcalloc()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting IPV6_V6ONLY

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: refactor hfi packet parsing logic

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi_parser: add check to avoid out of bound access

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Introduce 1 ms delay between regulators and en GPIO

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov7251: Set enable GPIO low in probe

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ccs: Set the device's runtime PM status correctly in probe

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ccs: Set the device's runtime PM status correctly in remove

Karina Yankevich <k.yankevich@omp.ru>
    media: v4l2-dv-timings: prevent possible overflow in v4l2_detect_gtf()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: platform: stm32: Add check for clk_enable()

Murad Masimov <m.masimov@mt-integration.ru>
    media: streamzap: prevent processing IR data on URB failure

Jonathan McDowell <noodles@meta.com>
    tpm, tpm_tis: Fix timeout handling when waiting for TPM status

Kamal Dasu <kamal.dasu@broadcom.com>
    mtd: rawnand: brcmnand: fix PM resume warning

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: cadence-qspi: Fix probe on AM62A LP SK

Will Deacon <will@kernel.org>
    KVM: arm64: Tear down vGIC on failed vCPU creation

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add KRYO 2XX/3XX/4XX silver cores to Spectre BHB safe list

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Assume that unknown CPUs _are_ vulnerable to Spectre BHB

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add QCOM_KRYO_4XX_GOLD to the spectre_bhb_k24_list

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add MIDR_CORTEX_A76AE

Jan Beulich <jbeulich@suse.com>
    xenfs/xensyms: respect hypervisor's "next" indication

Yuan Can <yuancan@huawei.com>
    media: siano: Fix error handling in smsdvb_module_init()

Matthew Majewski <mattwmajewski@gmail.com>
    media: vim2m: print device name after registering device

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi: add check to handle incorrect queue size

Vikash Garodia <quic_vgarodia@quicinc.com>
    media: venus: hfi: add a check to handle OOB in sfr region

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: i2c: adv748x: Fix test pattern selection mask

Jann Horn <jannh@google.com>
    ext4: don't treat fhandle lookup of ea_inode as FS corruption

Willem de Bruijn <willemb@google.com>
    bpf: support SKF_NET_OFF and SKF_LL_OFF on skb frags

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: fsl-ftm: Handle clk_get_rate() returning 0

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: rcar: Improve register calculation

Josh Poimboeuf <jpoimboe@kernel.org>
    pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()

Jonathan McDowell <noodles@meta.com>
    tpm, tpm_tis: Workaround failed command reception on Infineon devices

Ayush Jain <Ayush.jain3@amd.com>
    ktest: Fix Test Failures Due to Missing LOG_FILE Directories

Leonid Arapov <arapovl839@gmail.com>
    fbdev: omapfb: Add 'plane' value check

Christian König <christian.koenig@amd.com>
    drm/amdgpu: grab an additional reference on the gang fence v2

Ryo Takakura <ryotkkr98@gmail.com>
    PCI: vmd: Make vmd_dev::cfg_lock a raw_spinlock_t type

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: handle amdgpu_cgs_create_device() errors in amd_powerplay_create()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Explicitly manage TVD clock in power on/off

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Move the input_2p_en bit to platform data

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix pqm_destroy_queue race with GPU reset

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Fix mode1 reset crash issue

David Yat Sin <David.YatSin@amd.com>
    drm/amdkfd: clamp queue size to minimum

Lucas De Marchi <lucas.demarchi@intel.com>
    drivers: base: devres: Allow to release group on device release

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/bridge: panel: forbid initializing a panel with unknown connector type

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add quirk for OneXPlayer Mini (Intel)

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add new quirk for GPD Win 2

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add quirk for AYA NEO Slide

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add quirks for AYA NEO Flip DS and KB

Andrew Wyatt <fewtarius@steamfork.org>
    drm: panel-orientation-quirks: Add support for AYANEO 2S

Zhikai Zhai <zhikai.zhai@amd.com>
    drm/amd/display: Update Cursor request mode to the beginning prefetch always

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm: allow encoder mode_set even when connectors change for crtc

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    Bluetooth: qca: simplify WCN399x NVM loading

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_uart: fix race during initialization

Gabriele Paoloni <gpaoloni@redhat.com>
    tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER

Stanislav Fomichev <sdf@fomichev.me>
    net: vlan: don't propagate flags on open

Icenowy Zheng <uwu@icenowy.me>
    wifi: mt76: mt76x2u: add TP-Link TL-WDN6200 ID to device table

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Fix array overflow in st_setup()

Bhupesh <bhupesh@igalia.com>
    ext4: ignore xattrs past end

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: protect ext4_release_dquot against freezing

Daniel Kral <d.kral@proxmox.com>
    ahci: add PCI ID for Marvell 88SE9215 SATA Controller

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-bounds access in f2fs_truncate_inode_blocks()

Niklas Cassel <cassel@kernel.org>
    ata: libata-eh: Do not use ATAPI DMA for a device limited to PIO mode

Edward Adam Davis <eadavis@qq.com>
    jfs: add sanity check for agwidth in dbMount

Edward Adam Davis <eadavis@qq.com>
    jfs: Prevent copying of nlink with value 0 from disk inode

Rand Deeb <rand.sec96@gmail.com>
    fs/jfs: Prevent integer overflow in AG size calculation

Rand Deeb <rand.sec96@gmail.com>
    fs/jfs: cast inactags to s64 to prevent potential overflow

Zhongqiu Han <quic_zhonhan@quicinc.com>
    jfs: Fix uninit-value access of imap allocated in the diMount() function

Jason Xing <kerneljasonxing@gmail.com>
    page_pool: avoid infinite loop to schedule delayed worker

Chao Yu <chao@kernel.org>
    f2fs: don't retry IO for corrupted data scenario

keenplify <keenplify@gmail.com>
    ASoC: amd: Add DMI quirk for ACP6X mic support

Ricard Wanderlof <ricard2013@butoba.net>
    ALSA: usb-audio: Fix CME quirk for UF series keyboards

Kaustabh Chakraborty <kauschluss@disroot.org>
    mmc: dw_mmc: add a quirk for accessing 64-bit FIFOs in two halves

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: register card device depends on 'dais' property

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Add Lenovo IdeaPad Z570 to probe denylist

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Fix Optimus when GPU has no sound

Tomasz Pakuła <forest10pl@gmail.com>
    HID: pidff: Fix null pointer dereference in pidff_find_fields

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Do not send effect envelope if it's empty

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Convert infinite length from Linux API to PID standard

Kees Cook <kees@kernel.org>
    xen/mcelog: Add __nonstring annotations for unterminated strings

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add QCOM_CPU_PART_KRYO_3XX_GOLD

Mark Rutland <mark.rutland@arm.com>
    perf: arm_pmu: Don't disable counter in armpmu_add()

Max Grobecker <max@grobecker.info>
    x86/cpu: Don't clear X86_FEATURE_LAHF_LM flag in init_amd_k8() on AMD when running in a virtual machine

Zhongqiu Han <quic_zhonhan@quicinc.com>
    pm: cpupower: bench: Prevent NULL dereference on malloc failure

Trond Myklebust <trond.myklebust@hammerspace.com>
    umount: Allow superblock owners to force umount

Mateusz Guzik <mjguzik@gmail.com>
    fs: consistently deref the files table with rcu_dereference_raw()

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    iommu/mediatek: Fix NULL pointer deference in mtk_iommu_device_group

Florian Westphal <fw@strlen.de>
    nft_set_pipapo: fix incorrect avx2 match of 5th field octet

Arnaud Lecomte <contact@arnaud-lcm.com>
    net: ppp: Add bound checking for skb data on ppp_sync_txmung

Ido Schimmel <idosch@nvidia.com>
    ipv6: Align behavior across nexthops during path selection

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: move the limit validation

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: use a temporary work area for validating configuration

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: swap list_add_tail arguments

Wentao Liang <vulab@iscas.ac.cn>
    ata: sata_sx4: Add error handling in pdc20621_i2c_read()

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: ethtool: Don't call .cleanup_data when prepare_data fails

Toke Høiland-Jørgensen <toke@redhat.com>
    tc: Ensure we have enough buffer space when sending filter netlink notifications

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: cls_api: conditional notification of events

Victor Nogueira <victor@mojatatu.com>
    rtnl: add helper to check if a notification is needed

Jamal Hadi Salim <jhs@mojatatu.com>
    rtnl: add helper to check if rtnl group has listeners

Jakub Kicinski <kuba@kernel.org>
    net: tls: explicitly disallow disconnect

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix memory leak in tipc_link_xmit

Henry Martin <bsdhenrymartin@gmail.com>
    ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()

Edward Liaw <edliaw@google.com>
    selftests/futex: futex_waitv wouldblock test should fail


-------------

Diffstat:

 MAINTAINERS                                        |   1 +
 Makefile                                           |   7 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   6 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/include/asm/fpsimd.h                    |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |  19 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   1 +
 arch/arm64/include/asm/processor.h                 |   7 +
 arch/arm64/include/asm/spectre.h                   |   1 -
 arch/arm64/kernel/fpsimd.c                         |  69 +++++--
 arch/arm64/kernel/process.c                        |   2 +
 arch/arm64/kernel/proton-pack.c                    | 208 +++++++++++----------
 arch/arm64/kernel/ptrace.c                         |   3 +
 arch/arm64/kernel/signal.c                         |   7 +-
 arch/arm64/kvm/arm.c                               |   7 +-
 arch/arm64/kvm/fpsimd.c                            |  92 +++------
 arch/arm64/kvm/hyp/entry.S                         |   5 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 106 +++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  17 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  91 +++++----
 arch/arm64/kvm/hyp/vhe/switch.c                    |  12 +-
 arch/arm64/kvm/reset.c                             |   3 +
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/loongarch/kernel/acpi.c                       |  12 --
 arch/loongarch/net/bpf_jit.c                       |   2 -
 arch/loongarch/net/bpf_jit.h                       |   5 -
 arch/mips/dec/prom/init.c                          |   2 +-
 arch/mips/include/asm/ds1287.h                     |   2 +-
 arch/mips/kernel/cevt-ds1287.c                     |   1 +
 arch/powerpc/kernel/rtas.c                         |   4 +
 arch/riscv/include/asm/kgdb.h                      |   9 +-
 arch/riscv/include/asm/syscall.h                   |   7 +-
 arch/riscv/kernel/kgdb.c                           |   6 +
 arch/riscv/kernel/setup.c                          |  36 +++-
 arch/sparc/mm/tlb.c                                |   5 +-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/uncore_snbep.c               | 107 +----------
 arch/x86/kernel/cpu/amd.c                          |   2 +-
 arch/x86/kernel/cpu/intel.c                        |  20 +-
 arch/x86/kernel/e820.c                             |  17 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/platform/pvh/head.S                       |   7 +-
 block/blk-cgroup.c                                 |  24 ++-
 block/blk-cgroup.h                                 |   1 +
 block/blk-iocost.c                                 |   7 +-
 certs/Makefile                                     |   2 +-
 certs/extract-cert.c                               | 138 +++++++-------
 drivers/acpi/platform_profile.c                    |  20 +-
 drivers/ata/ahci.c                                 |   2 +
 drivers/ata/libata-eh.c                            |  11 +-
 drivers/ata/pata_pxa.c                             |   6 +
 drivers/ata/sata_sx4.c                             |  13 +-
 drivers/base/devres.c                              |   7 +
 drivers/block/loop.c                               |   7 +-
 drivers/bluetooth/btqca.c                          |  13 +-
 drivers/bluetooth/btrtl.c                          |   2 +
 drivers/bluetooth/hci_ldisc.c                      |  19 +-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/bus/mhi/host/main.c                        |  16 +-
 drivers/char/tpm/tpm_tis_core.c                    |  20 +-
 drivers/char/tpm/tpm_tis_core.h                    |   1 +
 drivers/clk/qcom/gdsc.c                            |  61 +++---
 drivers/clocksource/timer-stm32-lp.c               |   4 +-
 drivers/cpufreq/cpufreq.c                          |  40 +++-
 drivers/crypto/caam/qi.c                           |   6 +-
 drivers/crypto/ccp/sp-pci.c                        |  15 +-
 drivers/gpio/gpio-tegra186.c                       |  25 +--
 drivers/gpio/gpio-zynq.c                           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  44 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  17 ++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  14 +-
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  22 +--
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c  |   2 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |   5 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_thermal.c  |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |   4 +-
 .../drm/amd/pm/powerplay/hwmgr/vega20_thermal.c    |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   3 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   2 +-
 drivers/gpu/drm/drm_atomic_helper.c                |   2 +-
 drivers/gpu/drm/drm_panel.c                        |   5 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  46 ++++-
 drivers/gpu/drm/i915/gvt/opregion.c                |   7 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  23 ++-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  82 ++++----
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 -
 drivers/gpu/drm/sti/Makefile                       |   2 -
 drivers/gpu/drm/tiny/repaper.c                     |   4 +-
 drivers/hid/usbhid/hid-pidff.c                     |  60 ++++--
 drivers/hsi/clients/ssi_protocol.c                 |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   3 +
 drivers/i3c/master.c                               |   3 +
 drivers/i3c/master/svc-i3c-master.c                |   2 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/umem_odp.c                 |   6 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  14 +-
 drivers/iommu/mtk_iommu.c                          |  26 +--
 drivers/md/dm-ebs-target.c                         |   7 +
 drivers/md/dm-integrity.c                          |   3 +
 drivers/md/dm-verity-target.c                      |   8 +
 drivers/md/md-bitmap.c                             |   5 +-
 drivers/md/raid10.c                                |   1 +
 drivers/media/common/siano/smsdvb-main.c           |   2 +
 drivers/media/i2c/adv748x/adv748x.h                |   2 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 .../mediatek/vcodec/vdec/vdec_vp9_req_lat_if.c     |   3 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     | 100 +++++++---
 drivers/media/platform/qcom/venus/hfi_venus.c      |  18 +-
 drivers/media/platform/st/stm32/dma2d/dma2d.c      |   3 +-
 drivers/media/rc/streamzap.c                       |  68 ++++---
 drivers/media/test-drivers/vim2m.c                 |   6 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ene-kb3930.c                           |   2 +-
 drivers/misc/pci_endpoint_test.c                   |   6 +-
 drivers/mmc/host/dw_mmc.c                          |  94 +++++++++-
 drivers/mmc/host/dw_mmc.h                          |  27 +++
 drivers/mtd/inftlcore.c                            |   9 +-
 drivers/mtd/mtdpstore.c                            |  12 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/r852.c                        |   3 +
 drivers/net/dsa/b53/b53_common.c                   |  10 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  30 ++-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   1 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   4 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  93 +++++----
 drivers/net/ppp/ppp_synctty.c                      |   5 +
 drivers/net/wireless/atmel/at76c50x-usb.c          |   2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   4 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/ti/wl1251/tx.c                |   4 +-
 drivers/ntb/ntb_transport.c                        |   2 +-
 drivers/nvme/target/fc.c                           |  14 --
 drivers/nvme/target/fcloop.c                       |   2 +-
 drivers/of/irq.c                                   |  78 ++++----
 drivers/pci/controller/pcie-brcmstb.c              |  13 +-
 drivers/pci/controller/vmd.c                       |  12 +-
 drivers/pci/pci.c                                  |   4 -
 drivers/pci/probe.c                                |   5 +-
 drivers/perf/arm_pmu.c                             |   8 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  12 +-
 drivers/platform/x86/asus-laptop.c                 |   9 +-
 drivers/ptp/ptp_ocp.c                              |   1 +
 drivers/pwm/pwm-fsl-ftm.c                          |   6 +
 drivers/pwm/pwm-mediatek.c                         |   8 +-
 drivers/pwm/pwm-rcar.c                             |  24 +--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   9 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  14 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   9 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   5 +-
 drivers/scsi/scsi_transport_iscsi.c                |   7 +-
 drivers/scsi/st.c                                  |   2 +-
 drivers/soc/samsung/exynos-chipid.c                |   2 +
 drivers/spi/spi-cadence-quadspi.c                  |   6 +
 drivers/thermal/rockchip_thermal.c                 |   1 +
 drivers/ufs/host/ufs-exynos.c                      |   6 +
 drivers/vdpa/mlx5/core/mr.c                        |   7 +-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   6 +-
 drivers/xen/swiotlb-xen.c                          |   2 +-
 drivers/xen/xenfs/xensyms.c                        |   4 +-
 fs/Kconfig                                         |   1 +
 fs/btrfs/disk-io.c                                 |  12 ++
 fs/btrfs/inode.c                                   |   6 +-
 fs/btrfs/super.c                                   |   3 +-
 fs/btrfs/zoned.c                                   |   6 +
 fs/ext4/inode.c                                    |  68 +++++--
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/super.c                                    |  17 ++
 fs/ext4/xattr.c                                    |  11 +-
 fs/f2fs/inode.c                                    |   4 +
 fs/f2fs/node.c                                     |   9 +-
 fs/file.c                                          |  26 ++-
 fs/fuse/virtio_fs.c                                |   3 +
 fs/hfs/bnode.c                                     |   6 +
 fs/hfsplus/bnode.c                                 |   6 +
 fs/isofs/export.c                                  |   2 +-
 fs/jbd2/journal.c                                  |   1 -
 fs/jfs/jfs_dmap.c                                  |  10 +-
 fs/jfs/jfs_imap.c                                  |   4 +-
 fs/namespace.c                                     |   3 +-
 fs/nfs/Kconfig                                     |   2 +-
 fs/nfs/internal.h                                  |  22 ---
 fs/nfs/nfs4session.h                               |   4 -
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfsfh.h                                    |   7 -
 fs/smb/client/cifs_dfs_ref.c                       |  34 +++-
 fs/smb/client/cifsproto.h                          |  23 +++
 fs/smb/client/connect.c                            |   2 +
 fs/smb/client/dir.c                                |  21 ++-
 fs/smb/client/file.c                               |  28 +++
 fs/smb/client/fs_context.c                         |   5 +
 fs/smb/client/smb2misc.c                           |   9 +-
 fs/smb/server/oplock.c                             |   2 +-
 fs/smb/server/smb2pdu.c                            |   6 +-
 fs/smb/server/transport_ipc.c                      |   7 +-
 fs/smb/server/vfs.c                                |   3 +-
 include/linux/backing-dev.h                        |   1 +
 include/linux/bpf.h                                |   1 +
 include/linux/nfs.h                                |  13 ++
 include/linux/rtnetlink.h                          |  22 +++
 include/linux/tpm.h                                |   1 +
 include/net/sctp/structs.h                         |   3 +-
 include/uapi/linux/kfd_ioctl.h                     |   2 +
 include/uapi/linux/landlock.h                      |   2 +
 include/xen/interface/xen-mca.h                    |   2 +-
 io_uring/kbuf.c                                    |   2 +
 io_uring/net.c                                     |   2 +
 kernel/bpf/core.c                                  |  19 +-
 kernel/bpf/syscall.c                               |  17 +-
 kernel/locking/lockdep.c                           |   3 +
 kernel/sched/cpufreq_schedutil.c                   |  18 +-
 kernel/trace/ftrace.c                              |   1 +
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   4 +-
 lib/sg_split.c                                     |   2 -
 lib/string.c                                       |  13 +-
 mm/filemap.c                                       |   1 +
 mm/gup.c                                           |   6 +-
 mm/memory-failure.c                                |  11 +-
 mm/memory.c                                        |   4 +-
 mm/rmap.c                                          |   2 +-
 mm/vmscan.c                                        |   2 +-
 net/8021q/vlan_dev.c                               |  31 +--
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/l2cap_core.c                         |   3 +-
 net/bridge/br_vlan.c                               |   4 +-
 net/core/filter.c                                  |  80 ++++----
 net/core/page_pool.c                               |   8 +-
 net/dsa/tag_8021q.c                                |   2 +-
 net/ethtool/netlink.c                              |   8 +-
 net/ipv6/route.c                                   |   8 +-
 net/mac80211/iface.c                               |   3 +
 net/mac80211/mesh_hwmp.c                           |  14 +-
 net/mctp/af_mctp.c                                 |   3 +
 net/mptcp/sockopt.c                                |  28 +++
 net/mptcp/subflow.c                                |  19 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   3 +-
 net/openvswitch/flow_netlink.c                     |   3 +-
 net/sched/act_mirred.c                             |  20 +-
 net/sched/cls_api.c                                |  74 ++++++--
 net/sched/sch_codel.c                              |   5 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_sfq.c                                |  66 +++++--
 net/sctp/socket.c                                  |  22 ++-
 net/sctp/transport.c                               |   2 +
 net/tipc/link.c                                    |   1 +
 net/tls/tls_main.c                                 |   6 +
 scripts/sign-file.c                                | 132 ++++++-------
 scripts/ssl-common.h                               |  32 ++++
 security/landlock/errata.h                         |  87 +++++++++
 security/landlock/setup.c                          |  30 +++
 security/landlock/setup.h                          |   3 +
 security/landlock/syscalls.c                       |  22 ++-
 sound/pci/hda/hda_intel.c                          |  44 ++++-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/lpass-wsa-macro.c                 | 139 +++++++++-----
 sound/soc/fsl/fsl_audmix.c                         |  16 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   9 +-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 +-
 sound/usb/midi.c                                   |  80 +++++++-
 tools/power/cpupower/bench/parse.c                 |   4 +
 tools/testing/ktest/ktest.pl                       |   8 +
 tools/testing/radix-tree/linux.c                   |   4 +-
 .../futex/functional/futex_wait_wouldblock.c       |   2 +-
 tools/testing/selftests/landlock/base_test.c       |  46 ++++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   7 +-
 278 files changed, 2913 insertions(+), 1414 deletions(-)


