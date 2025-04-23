Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D921A23B0;
	Wed, 23 Apr 2025 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419551; cv=none; b=GkrUEzzjBNkNJT21z7qtCG1J/bAB3tIPkTmXkL2NlRn/SH1yGgYCfGWpuXnkROjeg9oejk6BBg0Q/XClP2YRxT6MJWTY4BwKyVAhU+QB/rb3kp4qVY7BcdYgaxiXrel0Y9C9D/sRzu8nxNceOJz//B+DLwb5x0+TEr83dt/1cTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419551; c=relaxed/simple;
	bh=k0eSv+K+KkaEcf0+DQMuMuiMePBG6P3znUbEMVQh7SM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HZa0idpbNVTyf0hYts3PgGkiOrf3OTgRNv483kQA4PM6w9GEIR26SM5Ex3aJsTVnbjStgKSBDTKn1VXLE10ONSQ/paWsSQ0TMQIlhNbjsKVVGQKV7DM3D3xTNX3DaAOCK4oPyvoxiT8pu8G6o2CUgucknkS8f+Tu/c9c0W/LMtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cj62K0R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cj62K0R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7813C4CEE2;
	Wed, 23 Apr 2025 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419550;
	bh=k0eSv+K+KkaEcf0+DQMuMuiMePBG6P3znUbEMVQh7SM=;
	h=From:To:Cc:Subject:Date:From;
	b=cj62K0R3htajGueF3Te7ovc5URijvAfojaiv+m4XGLGkHFzuMS/vq/m2XP1FuRPF3
	 9Se+vVl7/O4hrPGt+WYC8TmFeRmhVyHduq2/IbAj0Wjg9anf71pX2Q/b7nRmwiPHzB
	 MP21Q1h7x4P+x4JBiBtArZwbtaOTPSL9ksG0Snxs=
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
Subject: [PATCH 6.6 000/393] 6.6.88-rc1 review
Date: Wed, 23 Apr 2025 16:38:16 +0200
Message-ID: <20250423142643.246005366@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.88-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.88-rc1
X-KernelTest-Deadline: 2025-04-25T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.88 release.
There are 393 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.88-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.88-rc1

Karolina Stolarek <karolina.stolarek@intel.com>
    drm/tests: Build KMS helpers when DRM_KUNIT_TEST_HELPERS is enabled

Haisu Wang <haisuwang@tencent.com>
    btrfs: fix the length of reserved qgroup to free

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

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    xdp: Reset bpf_redirect_info before running a xdp's BPF prog.

WangYuli <wangyuli@uniontech.com>
    nvmet-fc: Remove unused functions

Mickaël Salaün <mic@digikod.net>
    landlock: Add the errata interface

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: disable PCIE wake bit when PCIE deinit

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: add pre_deinit to be called after probe complete

Boris Burkov <boris@bur.io>
    btrfs: fix qgroup reserve leaks in cow_file_range

GONG Ruiqi <gongruiqi1@huawei.com>
    usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()

Dan Carpenter <dan.carpenter@linaro.org>
    usb: typec: fix potential array underflow in ucsi_ccg_sync_control()

Yuli Wang <wangyuli@uniontech.com>
    LoongArch: Eliminate superfluous get_numa_distances_cnt()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: Prevent Spectre v1 gadget construction in sys_rtas()

Chunguang.xu <chunguang.xu@shopee.com>
    nvme-rdma: unquiesce admin_q before destroy it

Maksim Davydov <davydov-max@yandex-team.ru>
    x86/split_lock: Fix the delayed detection logic

Vishal Annapurve <vannapurve@google.com>
    x86/tdx: Fix arch_safe_halt() execution for TDX VMs

Roger Pau Monne <roger.pau@citrix.com>
    x86/xen: fix memblock_reserve() usage on PVH

Roger Pau Monne <roger.pau@citrix.com>
    x86/xen: move xen_reserve_extra_memory()

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    efi/libstub: Bump up EFI_MMAP_NR_SLACK_SLOTS to 32

Piotr Jaroszynski <pjaroszynski@nvidia.com>
    Fix mmu notifiers for range-based invalidates

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix 'irq_type' to convey the correct type

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Fix displaying 'irq_type' after 'request_irq' error

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    misc: pci_endpoint_test: Avoid issue of interrupts remaining after request_irq error

Geliang Tang <geliang.tang@suse.com>
    selftests: mptcp: add mptcp_lib_wait_local_port_listen

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: sockopt: fix getting freebind & transparent

Yu Kuai <yukuai3@huawei.com>
    md: fix mddev uaf while iterating all_mddevs list

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add '-fno-builtin-wcslen'

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reference count policy in cpufreq_update_limits()

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

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/sev: Avoid shared GHCB page for early memory acceptance

Sandipan Das <sandipan.das@amd.com>
    x86/cpu/amd: Fix workaround for erratum 1054

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Extend the SHA check to Zen5, block loading of any unreleased standalone Zen5 microcode patches

Xiangsheng Hou <xiangsheng.hou@mediatek.com>
    virtiofs: add filesystem context source name check

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix filter string testing

Peter Collingbourne <pcc@google.com>
    string: Add load_unaligned_zeropad() code path to sized_strscpy()

Chunjie Zhu <chunjie.zhu@cloud.com>
    smb3 client: fix open hardlink on deferred close file error

Mark Brown <broonie@kernel.org>
    selftests/mm: generate a temporary mountpoint for cgroup filesystem

Nathan Chancellor <nathan@kernel.org>
    riscv: Avoid fortify warning in syscall_get_arguments()

Kuniyuki Iwashima <kuniyu@amazon.com>
    Revert "smb: client: fix TCP timers deadlock after rmmod"

Kuniyuki Iwashima <kuniyu@amazon.com>
    Revert "smb: client: Fix netns refcount imbalance causing leaks and use-after-free"

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix the warning from __kernel_write_iter

Denis Arefev <arefev@swemel.ru>
    ksmbd: Prevent integer overflow in calculation of deadtime

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in smb_break_all_levII_oplock()

Sean Heelan <seanheelan@gmail.com>
    ksmbd: Fix dangling pointer in krb_authenticate

Miklos Szeredi <mszeredi@redhat.com>
    ovl: don't allow datadir only

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: fix apply_to_existing_page_range()

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

Kees Cook <kees@kernel.org>
    Bluetooth: vhci: Avoid needless snprintf() calls

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: l2cap: Process valid commands in too long frame

Menglong Dong <menglong8.dong@gmail.com>
    ftrace: fix incorrect hash size in register_ftrace_direct()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: atr: Fix wrong include

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: decrease sc_count directly if fail to queue dl_recall

Eric Biggers <ebiggers@google.com>
    nfs: add missing selections of CONFIG_CRC32

Denis Arefev <arefev@swemel.ru>
    asus-laptop: Fix an uninitialized variable

Evgeny Pimenov <pimenoveu12@gmail.com>
    ASoC: qcom: Fix sc7280 lpass potential buffer overflow

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

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: qemu_configs: SH: Respect kunit cmdline

Björn Töpel <bjorn@rivosinc.com>
    riscv: Properly export reserved regions in /proc/iomem

Bo-Cun Chen <bc-bocun.chen@mediatek.com>
    net: ethernet: mtk_eth_soc: revise QDMA packet scheduler settings

Bo-Cun Chen <bc-bocun.chen@mediatek.com>
    net: ethernet: mtk_eth_soc: correct the max weight of the queue limit for 100Mbps

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Fix possible NULL pointer dereference for perout request

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Add phase offset configuration for perout signal

Meghana Malladi <m-malladi@ti.com>
    net: ti: icss-iep: Add pwidth configuration for perout signal

Sagi Maimon <maimon.sagi@gmail.com>
    ptp: ocp: fix start time alignment in ptp_ocp_signal_set

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: free routing table on probe failure

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: clean up FDB, MDB, VLAN entries on unbind

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: fix -ENOENT when deleting VLANs and MST is unsupported

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: mv88e6xxx: avoid unregistering devlink regions which were never registered

Jonas Gorski <jonas.gorski@gmail.com>
    net: bridge: switchdev: do not notify new brentries as changed

Jonas Gorski <jonas.gorski@gmail.com>
    net: b53: enable BPDU reception for management port

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: rt-link: adjust mctp attribute naming

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: rt-link: add an attr layer around alt-ifname

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: individually free previous values on double set

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: store recursive nests by a pointer

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: re-sort ignoring recursive nests

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: record information about recursive nests

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: track attribute use

Abdun Nihaal <abdun.nihaal@gmail.com>
    cxgb4: fix memory leak in cxgb4_init_ethtool_filters() error path

Niklas Cassel <cassel@kernel.org>
    ata: libata-sata: Save all fields from sense data descriptor

Michael Walle <mwalle@kernel.org>
    net: ethernet: ti: am65-cpsw: fix port_np reference counting

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    net: ethernet: ti: am65-cpsw-nuss: rename phy_node -> port_np

Abdun Nihaal <abdun.nihaal@gmail.com>
    net: ngbe: fix memory leak in ngbe_probe() error path

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix nested key length validation in the set() action

Zheng Qixing <zhengqixing@huawei.com>
    block: fix resource leak in blk_register_queue() error path

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Set SOCK_RCU_FREE

Abdun Nihaal <abdun.nihaal@gmail.com>
    pds_core: fix memory leak in pdsc_debugfs_add_qcq()

Matthew Wilcox (Oracle) <willy@infradead.org>
    test suite: use %zu to print size_t

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: add lock preventing multiple simultaneous PTM transactions

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: cleanup PTP module if probe fails

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: handle the IGC_PTP_ENABLED flag correctly

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: move ktime snapshot into PTM retry loop

Christopher S M Hall <christopher.s.hall@intel.com>
    igc: increase wait time before retrying PTM

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

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Reset clamp override on jack removal

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix wrong maximum DMA segment size

Yue Haibing <yuehaibing@huawei.com>
    RDMA/usnic: Fix passing zero to PTR_ERR in usnic_ib_pci_probe()

Giuseppe Scrivano <gscrivan@redhat.com>
    ovl: remove unused forward declaration

Henry Martin <bsdhenrymartin@gmail.com>
    ASoC: Intel: avs: Fix null-ptr-deref in avs_component_probe()

Brady Norander <bradynorander@gmail.com>
    ASoC: dwc: always enable/disable i2s irqs

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

Arnd Bergmann <arnd@arndb.de>
    media: mediatek: vcodec: mark vdec_vp9_slice_map_counts_eob_coef noinline

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    x86/e820: Fix handling of subpage regions when calculating nosave ranges in e820__register_nosave_regions()

Yi Liu <yi.l.liu@intel.com>
    iommufd: Fail replace if device has not been attached

Nathan Chancellor <nathan@kernel.org>
    ACPI: platform-profile: Fix CFI violation when accessing sysfs files

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/paravirt: Move halt paravirt calls under CONFIG_PARAVIRT

Douglas Anderson <dianders@chromium.org>
    arm64: errata: Add newer ARM cores to the spectre_bhb_loop_affected() lists

Cong Liu <liucong2@kylinos.cn>
    selftests: mptcp: fix incorrect fd checks in main_loop

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: close fd_in before returning in main_loop

Stephan Gerhold <stephan.gerhold@linaro.org>
    pinctrl: qcom: Clear latched interrupt status when changing IRQ type

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    phy: freescale: imx8m-pcie: assert phy reset and perst in power off

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

Sean Christopherson <seanjc@google.com>
    KVM: x86: Explicitly zero-initialize on-stack CPUID unions

Joshua Washington <joshwash@google.com>
    gve: handle overflow when reporting TX consumed descriptors

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    gpio: zynq: Fix wakeup source leaks on device unbind

Guixin Liu <kanie@linux.alibaba.com>
    gpio: tegra186: fix resource handling in ACPI probe path

zhoumin <teczm@foxmail.com>
    ftrace: Add cond_resched() to ftrace_graph_set_hash()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: coresight: qcom,coresight-tpdm: Fix too many 'reg'

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: coresight: qcom,coresight-tpda: Fix too many 'reg'

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

Ajit Pandey <quic_ajipan@quicinc.com>
    clk: qcom: clk-branch: Fix invert halt status bit check for votable clocks

Pali Rohár <pali@kernel.org>
    cifs: Ensure that all non-client-specific reparse points are processed by the server

Roman Smirnov <r.smirnov@omp.ru>
    cifs: fix integer overflow in match_server()

Alexandra Diupina <adiupina@astralinux.ru>
    cifs: avoid NULL pointer dereference in dbg call

Trevor Woerner <twoerner@gmail.com>
    thermal/drivers/rockchip: Add missing rk3328 mapping entry

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not add length to print format in synthetic events

Roger Pau Monne <roger.pau@citrix.com>
    x86/xen: fix balloon target initialization for PVH dom0

Ricardo Cañuelo Navarro <rcn@igalia.com>
    sctp: detect and prevent references to a freed transport in sendmsg

Marc Herbert <Marc.Herbert@linux.intel.com>
    mm/hugetlb: move hugetlb_sysctl_init() to the __init section

Shuai Xue <xueshuai@linux.alibaba.com>
    mm/hwpoison: do not send SIGBUS to processes with recovered clean pages

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: fix release hang over concurrent GUP

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    mm: add missing release barrier on PGDAT_RECLAIM_LOCKED unlock

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm/mremap: correctly handle partial mremap() of VMA starting at 0

Ryan Roberts <ryan.roberts@arm.com>
    mm: fix lazy mmu docs and usage

Jane Chu <jane.chu@oracle.com>
    mm: make page_mapped_in_vma() hugetlb walk aware

David Hildenbrand <david@redhat.com>
    mm/rmap: reject hugetlb folios in folio_make_device_exclusive()

Ryan Roberts <ryan.roberts@arm.com>
    sparc/mm: avoid calling arch_enter/leave_lazy_mmu() in set_ptes

Ryan Roberts <ryan.roberts@arm.com>
    sparc/mm: disable preemption in lazy mmu mode

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Fix uninitialized rc in iommufd_access_rw()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix zone finishing with missing devices

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix zone activation with missing devices

Filipe Manana <fdmanana@suse.com>
    btrfs: fix non-empty delayed iputs list on unmount due to compressed write workers

Herve Codina <herve.codina@bootlin.com>
    backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()

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

Kartik Rajput <kkartik@nvidia.com>
    mailbox: tegra-hsp: Define dimensioning masks in SoC data

Chenyuan Yang <chenyuan0y@gmail.com>
    mfd: ene-kb3930: Fix a potential NULL pointer dereference

Abel Vesa <abel.vesa@linaro.org>
    leds: rgb: leds-qcom-lpg: Fix calculation of best period Hi-Res PWMs

Abel Vesa <abel.vesa@linaro.org>
    leds: rgb: leds-qcom-lpg: Fix pwm resolution max for Hi-Res PWMs

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

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    tpm: do not start chip while suspended

Jan Kara <jack@suse.cz>
    udf: Fix inode_getblk() return value

Si-Wei Liu <si-wei.liu@oracle.com>
    vdpa/mlx5: Fix oversized null mkey longer than 32bit

Yeongjin Gil <youngjin.gil@samsung.com>
    f2fs: fix to avoid atomicity corruption of atomic file

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

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: q6apm: add q6apm_get_hw_pointer helper

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

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: imx219: Rectify runtime PM handling in probe and remove

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

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: visl: Fix ERANGE error when setting enum controls

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

Arnd Bergmann <arnd@arndb.de>
    media: mtk-vcodec: venc: avoid -Wenum-compare-conditional warning

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mediatek: vcodec: Fix a resource leak related to the scp device in FW initialization

Alain Volmat <alain.volmat@foss.st.com>
    dt-bindings: media: st,stmipid02: correct lane-polarities maxItems

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: probe-events: Add comments about entry data storing code

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
    drm/amdkfd: debugfs hang_hws skip GPU with MES

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

Brendan Tam <Brendan.Tam@amd.com>
    drm/amd/display: add workaround flag to link to force FFE preset

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

Philipp Hahn <phahn-oss@avm.de>
    cdc_ether|r8152: ThinkPad Hybrid USB-C/A Dock quirk

Bhupesh <bhupesh@igalia.com>
    ext4: ignore xattrs past end

Chao Yu <chao@kernel.org>
    Revert "f2fs: rebuild nat_bits during umount"

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: protect ext4_release_dquot against freezing

Daniel Kral <d.kral@proxmox.com>
    ahci: add PCI ID for Marvell 88SE9215 SATA Controller

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-bounds access in f2fs_truncate_inode_blocks()

Manish Dharanenthiran <quic_mdharane@quicinc.com>
    wifi: ath12k: Fix invalid data access in ath12k_dp_rx_h_undecap_nwifi

Birger Koblitz <mail@birger-koblitz.de>
    net: sfp: add quirk for 2.5G OEM BX SFP

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

Max Schulze <max.schulze@online.de>
    net: usb: asix_devices: add FiberGecko DeviceID

Chaohai Chen <wdhh66@163.com>
    scsi: target: spc: Fix RSOC parameter data header size

Chao Yu <chao@kernel.org>
    f2fs: don't retry IO for corrupted data scenario

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process

Syed Saba kareem <syed.sabakareem@amd.com>
    ASoC: amd: yc: update quirk data for new Lenovo model

keenplify <keenplify@gmail.com>
    ASoC: amd: Add DMI quirk for ACP6X mic support

Ricard Wanderlof <ricard2013@butoba.net>
    ALSA: usb-audio: Fix CME quirk for UF series keyboards

Kaustabh Chakraborty <kauschluss@disroot.org>
    mmc: dw_mmc: add a quirk for accessing 64-bit FIFOs in two halves

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add quirk for Actions UVC05

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: register card device depends on 'dais' property

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Add Lenovo IdeaPad Z570 to probe denylist

Maxim Mikityanskiy <maxtram95@gmail.com>
    ALSA: hda: intel: Fix Optimus when GPU has no sound

Tomasz Pakuła <forest10pl@gmail.com>
    HID: pidff: Fix null pointer dereference in pidff_find_fields

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add PERIODIC_SINE_ONLY quirk

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: Add hid-universal-pidff driver and supported device ids

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add FIX_WHEEL_DIRECTION quirk

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add hid_pidff_init_with_quirks and export as GPL symbol

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add PERMISSIVE_CONTROL quirk

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add MISSING_PBO quirk and its detection

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Add MISSING_DELAY quirk and its detection

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Do not send effect envelope if it's empty

Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
    HID: pidff: Convert infinite length from Linux API to PID standard

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: SOF: topology: Use krealloc_array() to replace krealloc()

Ingo Molnar <mingo@kernel.org>
    zstd: Increase DYNAMIC_BMI2 GCC version cutoff from 4.8 to 11.0 to work around compiler segfault

Kees Cook <kees@kernel.org>
    xen/mcelog: Add __nonstring annotations for unterminated strings

Douglas Anderson <dianders@chromium.org>
    arm64: cputype: Add QCOM_CPU_PART_KRYO_3XX_GOLD

Mark Rutland <mark.rutland@arm.com>
    perf: arm_pmu: Don't disable counter in armpmu_add()

Max Grobecker <max@grobecker.info>
    x86/cpu: Don't clear X86_FEATURE_LAHF_LM flag in init_amd_k8() on AMD when running in a virtual machine

Xin Li (Intel) <xin@zytor.com>
    x86/ia32: Leave NULL selector values 0~3 unchanged

Matthew Wilcox (Oracle) <willy@infradead.org>
    x86/mm: Clear _PAGE_DIRTY for kernel mappings when we clear _PAGE_RW

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

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/huc: Fix fence not released on early probe errors

Wentao Liang <vulab@iscas.ac.cn>
    ata: sata_sx4: Add error handling in pdc20621_i2c_read()

Chenyuan Yang <chenyuan0y@gmail.com>
    net: libwx: handle page_pool_dev_alloc_pages error

Maxime Ripard <mripard@kernel.org>
    drm/tests: probe-helper: Fix drm_display_mode memory leak

Maxime Ripard <mripard@kernel.org>
    drm/tests: modes: Fix drm_display_mode memory leak

Maxime Ripard <mripard@kernel.org>
    drm/tests: cmdline: Fix drm_display_mode memory leak

Maxime Ripard <mripard@kernel.org>
    drm/tests: helpers: Create kunit helper to destroy a drm_display_mode

Yu-Chun Lin <eleanor15x@gmail.com>
    drm/tests: helpers: Fix compiler warning

Jinjie Ruan <ruanjinjie@huawei.com>
    drm/tests: helpers: Add helper for drm_display_mode_from_cea_vic()

Maxime Ripard <mripard@kernel.org>
    drm/tests: Add helper to create mock crtc

Maxime Ripard <mripard@kernel.org>
    drm/tests: Add helper to create mock plane

Maxime Ripard <mripard@kernel.org>
    drm/tests: helpers: Add atomic helpers

Maxime Ripard <mripard@kernel.org>
    drm/tests: modeset: Fix drm_display_mode memory leak

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

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: qos: fix VF root node parent queue index

Jakub Kicinski <kuba@kernel.org>
    net: tls: explicitly disallow disconnect

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix memory leak in tipc_link_xmit

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix INSN_CONTEXT_SWITCH handling in validate_unret()

Henry Martin <bsdhenrymartin@gmail.com>
    ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()

Badal Nilawar <badal.nilawar@intel.com>
    drm/i915: Disable RPG during live selftest

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/dg2: wait for HuC load completion before running selftests

Harish Chegondi <harish.chegondi@intel.com>
    drm/i915/xelpg: Extend driver code of Xe_LPG to Xe_LPG+

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mocs: use to_gt() instead of direct &i915->gt

Edward Liaw <edliaw@google.com>
    selftests/futex: futex_waitv wouldblock test should fail


-------------

Diffstat:

 .../bindings/arm/qcom,coresight-tpda.yaml          |   3 +-
 .../bindings/arm/qcom,coresight-tpdm.yaml          |   3 +-
 .../bindings/media/i2c/st,st-mipid02.yaml          |   2 +-
 Documentation/netlink/specs/rt_link.yaml           |  14 +-
 MAINTAINERS                                        |   1 +
 Makefile                                           |   7 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   6 +-
 arch/arm64/include/asm/cputype.h                   |   4 +
 arch/arm64/include/asm/spectre.h                   |   1 -
 arch/arm64/include/asm/tlbflush.h                  |  22 ++-
 arch/arm64/kernel/proton-pack.c                    | 208 +++++++++++---------
 arch/arm64/kvm/arm.c                               |   6 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/loongarch/kernel/acpi.c                       |  12 --
 arch/mips/dec/prom/init.c                          |   2 +-
 arch/mips/include/asm/ds1287.h                     |   2 +-
 arch/mips/kernel/cevt-ds1287.c                     |   1 +
 arch/powerpc/kernel/rtas.c                         |   4 +
 arch/riscv/include/asm/kgdb.h                      |   9 +-
 arch/riscv/include/asm/syscall.h                   |   7 +-
 arch/riscv/kernel/kgdb.c                           |   6 +
 arch/riscv/kernel/setup.c                          |  36 +++-
 arch/sparc/include/asm/pgtable_64.h                |   2 -
 arch/sparc/mm/tlb.c                                |   5 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/boot/compressed/mem.c                     |   5 +-
 arch/x86/boot/compressed/sev.c                     |  67 ++-----
 arch/x86/boot/compressed/sev.h                     |   2 +
 arch/x86/coco/tdx/tdx.c                            |  26 ++-
 arch/x86/events/intel/ds.c                         |   8 +-
 arch/x86/events/intel/uncore_snbep.c               | 107 +----------
 arch/x86/include/asm/irqflags.h                    |  40 ++--
 arch/x86/include/asm/paravirt.h                    |  20 +-
 arch/x86/include/asm/paravirt_types.h              |   3 +-
 arch/x86/include/asm/tdx.h                         |   4 +-
 arch/x86/include/asm/xen/hypervisor.h              |   5 -
 arch/x86/kernel/cpu/amd.c                          |  21 +-
 arch/x86/kernel/cpu/intel.c                        |  20 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   9 +-
 arch/x86/kernel/e820.c                             |  17 +-
 arch/x86/kernel/paravirt.c                         |  14 +-
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/kernel/signal_32.c                        |  62 ++++--
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/x86.c                                 |   4 +
 arch/x86/mm/pat/set_memory.c                       |   6 +-
 arch/x86/platform/pvh/enlighten.c                  |   3 -
 arch/x86/xen/enlighten.c                           |  10 +
 arch/x86/xen/enlighten_pvh.c                       |  93 +++++----
 arch/x86/xen/setup.c                               |   3 -
 block/blk-sysfs.c                                  |   2 +
 certs/Makefile                                     |   2 +-
 certs/extract-cert.c                               | 138 ++++++-------
 drivers/acpi/platform_profile.c                    |  20 +-
 drivers/ata/ahci.c                                 |   2 +
 drivers/ata/libata-eh.c                            |  11 +-
 drivers/ata/libata-sata.c                          |  15 ++
 drivers/ata/pata_pxa.c                             |   6 +
 drivers/ata/sata_sx4.c                             |  13 +-
 drivers/base/devres.c                              |   7 +
 drivers/block/loop.c                               |   7 +-
 drivers/bluetooth/btqca.c                          |  13 +-
 drivers/bluetooth/btrtl.c                          |   2 +
 drivers/bluetooth/hci_ldisc.c                      |  19 +-
 drivers/bluetooth/hci_uart.h                       |   1 +
 drivers/bluetooth/hci_vhci.c                       |  10 +-
 drivers/bus/mhi/host/main.c                        |  16 +-
 drivers/char/tpm/tpm-chip.c                        |   5 +
 drivers/char/tpm/tpm-interface.c                   |   7 -
 drivers/char/tpm/tpm_tis_core.c                    |  20 +-
 drivers/char/tpm/tpm_tis_core.h                    |   1 +
 drivers/clk/qcom/clk-branch.c                      |   4 +-
 drivers/clk/qcom/gdsc.c                            |  61 +++---
 drivers/clocksource/timer-stm32-lp.c               |   4 +-
 drivers/cpufreq/cpufreq.c                          |  40 +++-
 drivers/crypto/caam/qi.c                           |   6 +-
 drivers/crypto/ccp/sp-pci.c                        |  15 +-
 drivers/firmware/efi/libstub/efistub.h             |   2 +-
 drivers/gpio/gpio-tegra186.c                       |  25 +--
 drivers/gpio/gpio-zynq.c                           |   1 +
 drivers/gpu/drm/Kconfig                            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  44 +++--
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   5 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  17 ++
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  14 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   2 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  22 +--
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c  |   2 +-
 .../display/dc/link/protocols/link_dp_training.c   |   2 +
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
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   3 +-
 drivers/gpu/drm/i915/gt/intel_mocs.c               |   4 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |  19 +-
 drivers/gpu/drm/i915/gt/uc/intel_huc.c             |  11 +-
 drivers/gpu/drm/i915/gt/uc/intel_huc.h             |   1 +
 drivers/gpu/drm/i915/gt/uc/intel_uc.c              |   1 +
 drivers/gpu/drm/i915/gvt/opregion.c                |   7 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |   2 +-
 drivers/gpu/drm/i915/selftests/i915_selftest.c     |  54 +++++-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |  23 ++-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |  82 ++++----
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 -
 drivers/gpu/drm/sti/Makefile                       |   2 -
 drivers/gpu/drm/tests/drm_client_modeset_test.c    |   3 +
 drivers/gpu/drm/tests/drm_cmdline_parser_test.c    |  10 +-
 drivers/gpu/drm/tests/drm_kunit_helpers.c          | 213 +++++++++++++++++++++
 drivers/gpu/drm/tests/drm_modes_test.c             |  22 +++
 drivers/gpu/drm/tests/drm_probe_helper_test.c      |   8 +-
 drivers/gpu/drm/tiny/repaper.c                     |   4 +-
 drivers/hid/Kconfig                                |  14 ++
 drivers/hid/Makefile                               |   1 +
 drivers/hid/hid-ids.h                              |  31 +++
 drivers/hid/hid-universal-pidff.c                  | 197 +++++++++++++++++++
 drivers/hid/usbhid/hid-pidff.c                     | 173 ++++++++++++-----
 drivers/hsi/clients/ssi_protocol.c                 |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c            |   3 +
 drivers/i2c/i2c-atr.c                              |   2 +-
 drivers/i3c/master.c                               |   3 +
 drivers/i3c/master/svc-i3c-master.c                |   2 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/umem_odp.c                 |   6 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  14 +-
 drivers/iommu/iommufd/device.c                     |  18 +-
 drivers/iommu/mtk_iommu.c                          |  26 +--
 drivers/leds/rgb/leds-qcom-lpg.c                   |   8 +-
 drivers/mailbox/tegra-hsp.c                        |  72 +++++--
 drivers/md/dm-ebs-target.c                         |   7 +
 drivers/md/dm-integrity.c                          |   3 +
 drivers/md/dm-verity-target.c                      |   8 +
 drivers/md/md-bitmap.c                             |   5 +-
 drivers/md/md.c                                    |  22 ++-
 drivers/md/raid10.c                                |   1 +
 drivers/media/common/siano/smsdvb-main.c           |   2 +
 drivers/media/i2c/adv748x/adv748x.h                |   2 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/imx219.c                         |  13 +-
 drivers/media/i2c/ov7251.c                         |   4 +-
 .../mediatek/vcodec/common/mtk_vcodec_fw_scp.c     |   5 +-
 .../vcodec/decoder/vdec/vdec_vp9_req_lat_if.c      |   3 +-
 .../mediatek/vcodec/encoder/venc/venc_h264_if.c    |   6 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     | 100 +++++++---
 drivers/media/platform/qcom/venus/hfi_venus.c      |  18 +-
 drivers/media/platform/st/stm32/dma2d/dma2d.c      |   3 +-
 drivers/media/rc/streamzap.c                       |  68 ++++---
 drivers/media/test-drivers/vim2m.c                 |   6 +-
 drivers/media/test-drivers/visl/visl-core.c        |  12 ++
 drivers/media/usb/uvc/uvc_driver.c                 |   9 +
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   4 +-
 drivers/mfd/ene-kb3930.c                           |   2 +-
 drivers/misc/pci_endpoint_test.c                   |   6 +-
 drivers/mmc/host/dw_mmc.c                          |  94 ++++++++-
 drivers/mmc/host/dw_mmc.h                          |  27 +++
 drivers/mtd/inftlcore.c                            |   9 +-
 drivers/mtd/mtdpstore.c                            |  12 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   2 +-
 drivers/mtd/nand/raw/r852.c                        |   3 +
 drivers/net/dsa/b53/b53_common.c                   |  10 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  30 ++-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   3 +-
 drivers/net/ethernet/amd/pds_core/debugfs.c        |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   1 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   4 +-
 drivers/net/ethernet/intel/igc/igc.h               |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   6 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c           | 113 +++++++----
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   5 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  10 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  19 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |   2 +-
 drivers/net/ethernet/ti/icssg/icss_iep.c           | 150 ++++++++++-----
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   3 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   3 +-
 drivers/net/phy/sfp.c                              |   2 +
 drivers/net/ppp/ppp_synctty.c                      |   5 +
 drivers/net/usb/asix_devices.c                     |  17 ++
 drivers/net/usb/cdc_ether.c                        |   7 +
 drivers/net/usb/r8152.c                            |   6 +
 drivers/net/usb/r8153_ecm.c                        |   6 +
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   2 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  42 +++-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   2 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   4 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 drivers/net/wireless/realtek/rtw89/core.c          |   2 +
 drivers/net/wireless/realtek/rtw89/core.h          |   6 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  10 +
 drivers/net/wireless/ti/wl1251/tx.c                |   4 +-
 drivers/ntb/ntb_transport.c                        |   2 +-
 drivers/nvme/host/rdma.c                           |   8 +-
 drivers/nvme/target/fc.c                           |  14 --
 drivers/nvme/target/fcloop.c                       |   2 +-
 drivers/of/irq.c                                   |  78 ++++----
 drivers/pci/controller/pcie-brcmstb.c              |  13 +-
 drivers/pci/controller/vmd.c                       |  12 +-
 drivers/pci/pci.c                                  |   4 -
 drivers/pci/probe.c                                |   5 +-
 drivers/perf/arm_pmu.c                             |   8 +-
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |  11 ++
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
 drivers/target/target_core_spc.c                   |   2 +-
 drivers/thermal/rockchip_thermal.c                 |   1 +
 drivers/ufs/host/ufs-exynos.c                      |   6 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
 drivers/vdpa/mlx5/core/mr.c                        |   7 +-
 drivers/video/backlight/led_bl.c                   |   5 +-
 drivers/video/fbdev/omap2/omapfb/dss/dispc.c       |   6 +-
 drivers/xen/balloon.c                              |  34 +++-
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
 fs/f2fs/checkpoint.c                               |  21 +-
 fs/f2fs/f2fs.h                                     |  32 +++-
 fs/f2fs/inode.c                                    |   8 +-
 fs/f2fs/node.c                                     | 110 +++--------
 fs/f2fs/super.c                                    |   4 +
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
 fs/nfs/internal.h                                  |   7 -
 fs/nfs/nfs4session.h                               |   4 -
 fs/nfsd/Kconfig                                    |   1 +
 fs/nfsd/nfs4state.c                                |   2 +-
 fs/nfsd/nfsfh.h                                    |   7 -
 fs/overlayfs/overlayfs.h                           |   2 -
 fs/overlayfs/super.c                               |   5 +
 fs/smb/client/cifsproto.h                          |   2 +
 fs/smb/client/connect.c                            |  36 ++--
 fs/smb/client/file.c                               |  28 +++
 fs/smb/client/fs_context.c                         |   5 +
 fs/smb/client/inode.c                              |  10 +
 fs/smb/client/reparse.c                            |   4 -
 fs/smb/client/smb2misc.c                           |   9 +-
 fs/smb/server/oplock.c                             |  29 +--
 fs/smb/server/oplock.h                             |   1 -
 fs/smb/server/smb2pdu.c                            |   4 +-
 fs/smb/server/transport_ipc.c                      |   7 +-
 fs/smb/server/vfs.c                                |   3 +-
 fs/udf/inode.c                                     |   1 +
 fs/userfaultfd.c                                   |  51 +++--
 include/drm/drm_kunit_helpers.h                    |  28 +++
 include/linux/backing-dev.h                        |   1 +
 include/linux/hid.h                                |   9 +
 include/linux/nfs.h                                |   7 -
 include/linux/pgtable.h                            |  14 +-
 include/linux/rtnetlink.h                          |  22 +++
 include/linux/tpm.h                                |   1 +
 include/net/sctp/structs.h                         |   3 +-
 include/net/xdp.h                                  |   9 +-
 include/uapi/linux/kfd_ioctl.h                     |   2 +
 include/uapi/linux/landlock.h                      |   2 +
 include/xen/interface/xen-mca.h                    |   2 +-
 io_uring/kbuf.c                                    |   2 +
 io_uring/net.c                                     |   2 +
 kernel/locking/lockdep.c                           |   3 +
 kernel/sched/cpufreq_schedutil.c                   |  18 +-
 kernel/trace/ftrace.c                              |   8 +-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   4 +-
 kernel/trace/trace_events_synth.c                  |   1 -
 kernel/trace/trace_probe.c                         |  28 +++
 lib/sg_split.c                                     |   2 -
 lib/string.c                                       |  13 +-
 lib/zstd/common/portability_macros.h               |   2 +-
 mm/filemap.c                                       |   1 +
 mm/gup.c                                           |   4 +-
 mm/hugetlb.c                                       |   2 +-
 mm/memory-failure.c                                |  11 +-
 mm/memory.c                                        |   4 +-
 mm/mremap.c                                        |  10 +-
 mm/page_vma_mapped.c                               |  13 +-
 mm/rmap.c                                          |   2 +-
 mm/vmscan.c                                        |   2 +-
 net/8021q/vlan_dev.c                               |  31 +--
 net/bluetooth/hci_event.c                          |   5 +-
 net/bluetooth/l2cap_core.c                         |  21 +-
 net/bridge/br_vlan.c                               |   4 +-
 net/core/filter.c                                  |  80 ++++----
 net/core/page_pool.c                               |   8 +-
 net/dsa/dsa.c                                      |  59 +++++-
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
 net/sched/cls_api.c                                |  74 +++++--
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
 sound/soc/amd/yc/acp6x-mach.c                      |  14 ++
 sound/soc/codecs/cs42l43-jack.c                    |   3 +
 sound/soc/codecs/lpass-wsa-macro.c                 | 139 +++++++++-----
 sound/soc/dwc/dwc-i2s.c                            |  13 +-
 sound/soc/fsl/fsl_audmix.c                         |  16 +-
 sound/soc/intel/avs/pcm.c                          |   3 +-
 sound/soc/qcom/lpass.h                             |   3 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   9 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |  18 +-
 sound/soc/qcom/qdsp6/q6apm.h                       |   3 +
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  19 +-
 sound/soc/sof/topology.c                           |   4 +-
 sound/usb/midi.c                                   |  80 +++++++-
 tools/net/ynl/ynl-gen-c.py                         | 165 ++++++++++++----
 tools/objtool/check.c                              |   5 +
 tools/power/cpupower/bench/parse.c                 |   4 +
 tools/testing/ktest/ktest.pl                       |   8 +
 tools/testing/kunit/qemu_configs/sh.py             |   4 +-
 tools/testing/radix-tree/linux.c                   |   4 +-
 .../futex/functional/futex_wait_wouldblock.c       |   2 +-
 tools/testing/selftests/landlock/base_test.c       |  46 ++++-
 .../selftests/mm/charge_reserved_hugetlb.sh        |   4 +-
 .../selftests/mm/hugetlb_reparenting_test.sh       |   2 +-
 tools/testing/selftests/net/mptcp/diag.sh          |  23 +--
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  11 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |  19 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  20 +-
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  18 ++
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  19 +-
 376 files changed, 4360 insertions(+), 1914 deletions(-)


