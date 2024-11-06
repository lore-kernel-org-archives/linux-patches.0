Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BB61EF08F;
	Wed,  6 Nov 2024 12:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897397; cv=none; b=Aoe+acY3VHOM30jk5b1JVqnFwZ6QLMT9gu8jJLUqyNklqFURyowb9D6KWse8V9/XKTT+lSFRJX08JV8oDQ8uUbUho6yhn4arBSudlnKrsWxonSz6AQWL+s54Ruf0Sf9aO3OxfWGjKKGPb8sITAmttDxr1AOFZ3cTdZtLbwYK8Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897397; c=relaxed/simple;
	bh=XTHk9BhBYz7AnJWVVnSbmDNYdfZYFW/9mFGa1o7I3io=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B/aDb52hyUlSAbGxukZ3NG4tX77EHOu5SyGsS9GHKsyHuZ9QtAi21fMvlW8UEpAoHiujudtAwzS2SLpOPbpf/zmMsP7+ObN+uQJaBnELP9+TKZBV/bXCcmPasNxSwN68rkTqCIJJhDJzoOmJRv7jxUmhZpVI9JT9IHV0Rh0LX74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3kvPoK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3kvPoK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413AAC4CED3;
	Wed,  6 Nov 2024 12:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897397;
	bh=XTHk9BhBYz7AnJWVVnSbmDNYdfZYFW/9mFGa1o7I3io=;
	h=From:To:Cc:Subject:Date:From;
	b=R3kvPoK/ylIF04PaegqtOetJZZcvqBdHRdxmjZ2SO7lzUzeEbST1tbqJmqWp1AHID
	 GjXeM0zTqoeM7aFtkkLnGyUzjbnoYvmyC8EXsp3rQwtwIr/NLvKNEUyQL7X2NlwQSi
	 u1PDnQJ693dig6JQ5xyAZkT9MhKAtsiegwYQFuL0=
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
	hagar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 6.6 000/151] 6.6.60-rc1 review
Date: Wed,  6 Nov 2024 13:03:08 +0100
Message-ID: <20241106120308.841299741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.60-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.60-rc1
X-KernelTest-Deadline: 2024-11-08T12:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.60 release.
There are 151 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.60-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.60-rc1

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Sequential field availability check in mi_enum_attr()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null checks for 'stream' and 'plane' before dereferencing

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-control: Add support for ALSA enum control

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-control: Add support for ALSA switch control

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Add definition for generic switch/enum control

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Remove BUG_ON call sites

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: winbond: fix w25q128 regression

David Hildenbrand <david@redhat.com>
    mm: don't install PMD mappings when THPs are disabled by the hw/process/vma

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix 6 GHz scan construction

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of checked flag

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: mac80211: fix NULL dereference at band check in starting tx ba session

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: always lock __io_cqring_overflow_flush

Haibo Chen <haibo.chen@nxp.com>
    arm64: dts: imx8ulp: correct the flexspi compatible string

Gregory Price <gourry@gourry.net>
    vmscan,migrate: fix page count imbalance on node stats when demoting pages

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: fix missing NOWAIT check for O_DIRECT start write

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: remove vmalloc_percpu test

Vitaliy Shevtsov <v.shevtsov@maxima.ru>
    nvmet-auth: assign dh_key to NULL after kfree_sensitive

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/realtek: Fix headset mic on TUXEDO Stellaris 16 Gen6 mb1

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/realtek: Fix headset mic on TUXEDO Gemini 17 Gen3

Christoph Hellwig <hch@lst.de>
    xfs: fix finding a last resort AG in xfs_filestream_pick_ag

Matt Johnston <matt@codeconstruct.com.au>
    mctp i2c: handle NULL header address

Edward Adam Davis <eadavis@qq.com>
    ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow

Sabyrzhan Tasbolatov <snovitoll@gmail.com>
    x86/traps: move kmsan check after instrumentation_begin

Gatlin Newhouse <gatlin.newhouse@gmail.com>
    x86/traps: Enable UBSAN traps on x86

Matt Fleming <mfleming@cloudflare.com>
    mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: use kvmalloc for read buffer

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: init: protect sched with rcu_read_lock

Hugh Dickins <hughd@google.com>
    iov_iter: fix copy_page_from_iter_atomic() if KMAP_LOCAL_FORCE_MAP

Shawn Wang <shawnwang@linux.alibaba.com>
    sched/numa: Fix the potential null pointer dereference in task_numa_work()

Dan Williams <dan.j.williams@intel.com>
    cxl/acpi: Ensure ports ready at cxl_acpi_probe() return

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove duplicated GET_RM

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove unused GENERATING_ASM_OFFSETS

WangYuli <wangyuli@uniontech.com>
    riscv: Use '%u' to format the output of 'cpu'

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: efi: Set NX compat flag in PE/COFF header

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Limit internal Mic boost on Dell platform

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: edt-ft5x06 - fix regmap leak when probe fails

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: vdso: Prevent the compiler from inserting calls to memset()

Frank Li <Frank.Li@nxp.com>
    spi: spi-fsl-dspi: Fix crash when not using GPIO chip select

Richard Zhu <hongxing.zhu@nxp.com>
    phy: freescale: imx8m-pcie: Do CMN_RST just before PHY PLL lock check

Chen Ridong <chenridong@huawei.com>
    cgroup/bpf: use a dedicated workqueue for cgroup bpf destruction

Xinyu Zhang <xizhang@purestorage.com>
    block: fix sanity checks in blk_rq_map_user_bvec

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9767: Fix low power mode in the SD Express process

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9767: Fix low power mode on the set clock function

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Fix use-after-free, permit out-of-order decoder shutdown

Gil Fine <gil.fine@linux.intel.com>
    thunderbolt: Honor TMU requirements in the domain when setting TMU mode

Wladislav Wiebe <wladislav.kw@gmail.com>
    tools/mm: -Werror fixes in page-types/slabinfo

Jeongjun Park <aha310510@gmail.com>
    mm: shmem: fix data-race in shmem_getattr()

Yunhui Cui <cuiyunhui@bytedance.com>
    RISC-V: ACPI: fix early_ioremap to early_memremap

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential deadlock with newly created symlinks

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: veml6030: fix microlux value calculation

Jinjie Ruan <ruanjinjie@huawei.com>
    iio: gts-helper: Fix memory leaks in iio_gts_build_avail_scale_table()

Jinjie Ruan <ruanjinjie@huawei.com>
    iio: gts-helper: Fix memory leaks for the error path of iio_gts_build_avail_scale_table()

Zicheng Qu <quzicheng@huawei.com>
    iio: adc: ad7124: fix division by zero in ad7124_set_channel_odr()

Zicheng Qu <quzicheng@huawei.com>
    staging: iio: frequency: ad9832: fix division by zero in ad9832_calc_freqreg()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    wifi: iwlegacy: Clear stale interrupts before resuming device

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: clear wdev->cqm_config pointer on free

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath10k: Fix memory leak in management tx

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower

Edward Liaw <edliaw@google.com>
    Revert "selftests/mm: replace atomic_bool with pthread_barrier_t"

Edward Liaw <edliaw@google.com>
    Revert "selftests/mm: fix deadlock for fork after pthread_create on ARM"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "driver core: Fix uevent_show() vs driver detach race"

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    xhci: Use pm_runtime_get to prevent RPM on unsupported systems

Faisal Hassan <quic_faisalh@quicinc.com>
    xhci: Fix Link TRB DMA in command ring stopped completion event

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom: qmp-usb-legacy: fix NULL-deref on runtime suspend

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom: qmp-usb: fix NULL-deref on runtime suspend

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: typec: qcom-pmic-typec: use fwnode_handle_put() to release fwnodes

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: typec: fix unreleased fwnode_handle in typec_port_register_altmodes()

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: phy: Fix API devm_usb_put_phy() can not release the phy

Zongmin Zhou <zhouzongmin@kylinos.cn>
    usbip: tools: Fix detach_port() invalid port error path

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add quirks for Dell WD19 dock

Zqiang <qiang.zhang1211@gmail.com>
    rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Initialize data to eliminate RCU-tasks/do_exit() deadlocks

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Add data to eliminate RCU-tasks/do_exit() deadlocks

Paul E. McKenney <paulmck@kernel.org>
    rcu-tasks: Pull sampling of ->percpu_dequeue_lim out of loop

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix "task hung" problem

Andrey Konovalov <andreyknvl@gmail.com>
    usb: gadget: dummy_hcd: execute hrtimer callback in softirq context

Marcello Sylvester Bauer <sylv@sylv.io>
    usb: gadget: dummy_hcd: Set transfer interval to 1 microframe

Marcello Sylvester Bauer <sylv@sylv.io>
    usb: gadget: dummy_hcd: Switch to hrtimer transfer scheduler

Dimitri Sivanich <sivanich@hpe.com>
    misc: sgi-gru: Don't disable preemption in GRU driver

Dai Ngo <dai.ngo@oracle.com>
    NFS: remove revoked delegation from server's delegation list

Daniel Palmer <daniel@0x0f.com>
    net: amd: mvme147: Fix probe banner message

Zhang Rui <rui.zhang@intel.com>
    thermal: intel: int340x: processor: Add MMIO RAPL PL4 support

Zhang Rui <rui.zhang@intel.com>
    thermal: intel: int340x: processor: Remove MMIO RAPL CPU hotplug support

Pali Rohár <pali@kernel.org>
    cifs: Fix creating native symlinks pointing to current or parent directory

Pali Rohár <pali@kernel.org>
    cifs: Improve creating native symlinks pointing to directory

Benjamin Marzinski <bmarzins@redhat.com>
    scsi: scsi_transport_fc: Allow setting rport state to current state

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Additional check in ntfs_file_release

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix general protection fault in run_is_mapped_full

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Additional check in ni_clear()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix possible deadlock in mi_read

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add rough attr alloc_size check

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Stale inode instead of bad

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix warning possible deadlock in ntfs_set_state

Andrew Ballance <andrewjballance@gmail.com>
    fs/ntfs3: Check if more than chunk-size bytes are written

lei lu <llfamsec@gmail.com>
    ntfs3: Add bounds checking to mi_enum_attr()

Shiju Jose <shiju.jose@huawei.com>
    cxl/events: Fix Trace DRAM Event Record

Paulo Alcantara <pc@manguebit.com>
    smb: client: set correct device number on nfs reparse points

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix parsing of device numbers

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: CPPC: Make rmw_lock a raw_spin_lock

David Howells <dhowells@redhat.com>
    afs: Fix missing subdir edit when renamed between parent dirs

David Howells <dhowells@redhat.com>
    afs: Automatically generate trace tag enums

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()

Marco Elver <elver@google.com>
    kasan: Fix Software Tag-Based KASAN with GCC

Christoph Hellwig <hch@lst.de>
    iomap: turn iomap_want_unshare_iter into an inline function

Darrick J. Wong <djwong@kernel.org>
    fsdax: dax_unshare_iter needs to copy entire blocks

Darrick J. Wong <djwong@kernel.org>
    fsdax: remove zeroing code from dax_unshare_iter

Darrick J. Wong <djwong@kernel.org>
    iomap: share iomap_unshare_iter predicate code with fsdax

Darrick J. Wong <djwong@kernel.org>
    iomap: don't bother unsharing delalloc extents

Christoph Hellwig <hch@lst.de>
    iomap: improve shared block detection in iomap_unshare_iter

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf, test_run: Fix LIVE_FRAME frame update after a page has been recycled

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: sanitize offset and length before calling skb_checksum()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_ipip: Fix memory leak when changing remote IPv6 address

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum_ptp: Add missing verification before pushing Tx header

Benoît Monin <benoit.monin@gmx.fr>
    net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: hci: fix null-ptr-deref in hci_read_supported_codecs

Eric Dumazet <edumazet@google.com>
    netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()

Dong Chenchen <dongchenchen2@huawei.com>
    netfilter: Fix use-after-free in get_info()

Wang Liang <wangliang74@huawei.com>
    net: fix crash when config small gso_max_size/gso_ipv4_max_size

Byeonguk Jeong <jungbu2855@gmail.com>
    bpf: Fix out-of-bounds write in trie_get_next_key()

Zichen Xie <zichenxie0106@gmail.com>
    netdevsim: Add trailing zero to terminate the string in nsim_nexthop_bucket_activity_write()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Force checkpoint when jmp history is too long

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Add bpf_percpu_obj_{new,drop}() macro in bpf_experimental.h

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT

Pablo Neira Ayuso <pablo@netfilter.org>
    gtp: allow -1 to be specified as file description from userspace

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()

Wander Lairson Costa <wander@redhat.com>
    igb: Disable threaded IRQ for igb_msix_other

Furong Xu <0x1207@gmail.com>
    net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data

Ley Foon Tan <leyfoon.tan@starfivetech.com>
    net: stmmac: dwmac4: Fix high address display by updating reg_space[] from register values

Jianbo Liu <jianbol@nvidia.com>
    macsec: Fix use-after-free while sending the offloading packet

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't add default link in fw restart flow

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: disconnect station vifs if recovery failed

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: synchronize the qp-handle table array

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the usage of control path spin locks

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Dump vendor specific QP details

Geert Uytterhoeven <geert@linux-m68k.org>
    wifi: brcm80211: BRCM_TRACING should depend on TRACING

Remi Pommarel <repk@triplefau.lt>
    wifi: ath11k: Fix invalid ring usage in full monitor mode

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys

Geert Uytterhoeven <geert@linux-m68k.org>
    mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING

Ben Hutchings <ben@decadent.org.uk>
    wifi: iwlegacy: Fix "field-spanning write" warning in il_enqueue_hcmd()

Georgi Djakov <djakov@kernel.org>
    spi: geni-qcom: Fix boot warning related to pm_runtime and devres

Xiu Jianfeng <xiujianfeng@huawei.com>
    cgroup: Fix potential overflow issue when checking max_depth

Stefan Kerkmann <s.kerkmann@pengutronix.de>
    Input: xpad - add support for 8BitDo Ultimate 2C Wireless Controller

Brenton Simpson <appsforartists@google.com>
    Input: xpad - sort xpad_device by vendor and product ID

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Free tzp copy along with the thermal zone

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Rework thermal zone availability check

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Make thermal_zone_device_unregister() return after freeing the zone


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi         |   2 +-
 arch/riscv/kernel/acpi.c                           |   4 +-
 arch/riscv/kernel/asm-offsets.c                    |   2 -
 arch/riscv/kernel/cpu-hotplug.c                    |   2 +-
 arch/riscv/kernel/efi-header.S                     |   2 +-
 arch/riscv/kernel/traps_misaligned.c               |   2 -
 arch/riscv/kernel/vdso/Makefile                    |   1 +
 arch/x86/include/asm/bug.h                         |  12 ++
 arch/x86/kernel/traps.c                            |  71 +++++-
 block/blk-map.c                                    |   4 +-
 drivers/acpi/cppc_acpi.c                           |   9 +-
 drivers/base/core.c                                |  48 ++++-
 drivers/base/module.c                              |   4 -
 drivers/cxl/acpi.c                                 |   7 +
 drivers/cxl/core/hdm.c                             |  50 ++++-
 drivers/cxl/core/port.c                            |  13 +-
 drivers/cxl/core/region.c                          |  48 ++---
 drivers/cxl/core/trace.h                           |  17 +-
 drivers/cxl/cxl.h                                  |   3 +-
 drivers/firmware/arm_sdei.c                        |   2 +-
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   3 +
 drivers/iio/adc/ad7124.c                           |   2 +-
 drivers/iio/industrialio-gts-helper.c              |   4 +-
 drivers/iio/light/veml6030.c                       |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |  38 ++--
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   2 +
 drivers/infiniband/hw/cxgb4/provider.c             |   1 +
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +-
 drivers/input/joystick/xpad.c                      |  12 +-
 drivers/input/touchscreen/edt-ft5x06.c             |  19 +-
 drivers/misc/mei/client.c                          |   4 +-
 drivers/misc/sgi-gru/grukservices.c                |   2 -
 drivers/misc/sgi-gru/grumain.c                     |   4 -
 drivers/misc/sgi-gru/grutlbpurge.c                 |   2 -
 drivers/mmc/host/sdhci-pci-gli.c                   |  38 ++--
 drivers/mtd/spi-nor/winbond.c                      |   7 +-
 drivers/net/ethernet/amd/mvme147.c                 |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |  26 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   8 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 drivers/net/gtp.c                                  |  22 +-
 drivers/net/macsec.c                               |   3 +-
 drivers/net/mctp/mctp-i2c.c                        |   3 +
 drivers/net/netdevsim/fib.c                        |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   7 +-
 drivers/net/wireless/broadcom/brcm80211/Kconfig    |   1 +
 drivers/net/wireless/intel/iwlegacy/common.c       |  15 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |  12 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  22 +-
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |  24 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   3 +-
 drivers/nvme/target/auth.c                         |   1 +
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c         |  10 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c     |   1 +
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |   1 +
 drivers/scsi/scsi_transport_fc.c                   |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |   6 +-
 drivers/spi/spi-geni-qcom.c                        |   8 +-
 drivers/staging/iio/frequency/ad9832.c             |   7 +-
 .../intel/int340x_thermal/processor_thermal_rapl.c |  70 +++---
 drivers/thermal/thermal_core.c                     |  25 ++-
 drivers/thunderbolt/tb.c                           |  48 ++++-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  57 +++--
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/host/xhci-ring.c                       |  16 +-
 drivers/usb/phy/phy.c                              |   2 +-
 drivers/usb/typec/class.c                          |   1 +
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c      |   4 +-
 fs/afs/dir.c                                       |  25 +++
 fs/afs/dir_edit.c                                  |  91 +++++++-
 fs/afs/internal.h                                  |   2 +
 fs/dax.c                                           |  49 +++--
 fs/iomap/buffered-io.c                             |   7 +-
 fs/nfs/delegation.c                                |   5 +
 fs/nilfs2/namei.c                                  |   3 +
 fs/nilfs2/page.c                                   |   1 +
 fs/ntfs3/file.c                                    |   9 +-
 fs/ntfs3/frecord.c                                 |   4 +-
 fs/ntfs3/inode.c                                   |  15 +-
 fs/ntfs3/lznt.c                                    |   3 +
 fs/ntfs3/namei.c                                   |   2 +-
 fs/ntfs3/ntfs_fs.h                                 |   2 +-
 fs/ntfs3/record.c                                  |  31 ++-
 fs/ocfs2/file.c                                    |   8 +
 fs/smb/client/cifs_unicode.c                       |  17 +-
 fs/smb/client/reparse.c                            | 174 ++++++++++++++-
 fs/smb/client/reparse.h                            |   9 +-
 fs/smb/client/smb2inode.c                          |   3 +-
 fs/smb/client/smb2proto.h                          |   1 +
 fs/xfs/xfs_filestream.c                            |  23 +-
 fs/xfs/xfs_trace.h                                 |  15 +-
 include/acpi/cppc_acpi.h                           |   2 +-
 include/linux/compiler-gcc.h                       |   4 +
 include/linux/device.h                             |   3 +
 include/linux/huge_mm.h                            |  18 ++
 include/linux/iomap.h                              |  19 ++
 include/linux/sched.h                              |   2 +
 include/linux/thermal.h                            |   2 +
 include/linux/ubsan.h                              |   5 +
 include/net/ip_tunnels.h                           |   2 +-
 include/trace/events/afs.h                         | 240 +++------------------
 init/init_task.c                                   |   1 +
 io_uring/io_uring.c                                |  13 +-
 io_uring/rw.c                                      |  23 +-
 kernel/bpf/cgroup.c                                |  19 +-
 kernel/bpf/lpm_trie.c                              |   2 +-
 kernel/bpf/verifier.c                              |   9 +-
 kernel/cgroup/cgroup.c                             |   4 +-
 kernel/fork.c                                      |   1 +
 kernel/rcu/tasks.h                                 |  90 +++++---
 kernel/sched/fair.c                                |   4 +-
 lib/Kconfig.ubsan                                  |   4 +-
 lib/iov_iter.c                                     |   6 +-
 mm/huge_memory.c                                   |  13 +-
 mm/kasan/kasan_test.c                              |  27 ---
 mm/memory.c                                        |   9 +
 mm/migrate.c                                       |   2 +-
 mm/page_alloc.c                                    |  10 +-
 mm/shmem.c                                         |   2 +
 net/bluetooth/hci_sync.c                           |  18 +-
 net/bpf/test_run.c                                 |   1 +
 net/core/dev.c                                     |   4 +
 net/core/rtnetlink.c                               |   4 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  15 +-
 net/mac80211/Kconfig                               |   2 +-
 net/mac80211/agg-tx.c                              |   4 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/key.c                                 |  42 ++--
 net/mptcp/protocol.c                               |   2 +
 net/netfilter/nft_payload.c                        |   3 +
 net/netfilter/x_tables.c                           |   2 +-
 net/sched/sch_api.c                                |   2 +-
 net/sunrpc/svc.c                                   |   9 +-
 net/wireless/core.c                                |   1 +
 sound/pci/hda/patch_realtek.c                      |  23 +-
 sound/soc/codecs/cs42l51.c                         |   7 +-
 sound/soc/sof/ipc4-control.c                       | 175 ++++++++++++++-
 sound/soc/sof/ipc4-topology.c                      |  49 ++++-
 sound/soc/sof/ipc4-topology.h                      |  19 +-
 sound/usb/mixer_quirks.c                           |   3 +
 tools/mm/page-types.c                              |   9 +-
 tools/mm/slabinfo.c                                |   4 +-
 tools/testing/cxl/test/cxl.c                       |  14 +-
 tools/testing/selftests/bpf/bpf_experimental.h     |  31 +++
 tools/testing/selftests/mm/uffd-common.c           |   5 +-
 tools/testing/selftests/mm/uffd-common.h           |   3 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |  21 +-
 tools/usb/usbip/src/usbip_detach.c                 |   1 +
 155 files changed, 1657 insertions(+), 775 deletions(-)


