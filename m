Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04D3D330A;
	Wed, 25 Feb 2026 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772034721; cv=none; b=FXOvEB9FEBDlhtIe2INWDyABK5Wctphls+xZoyOe6l0qHjWw0LAhYIJFN+Sn/khqbA96+aBrWu560HYmyL660Xgqy3etz/FrKpQ0KRt1pKb7XJ1QuSTX9Uuub8o3deZMPdUUBapDjo6GnNK27zCg0drZYg10HiCT2jxN7KKKbOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772034721; c=relaxed/simple;
	bh=1rdQ82+haPKF5dBdYw3pwl0TISsvnjieMrrWIGRyRaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pU+TUz4gypQ3fOOZ0H9Q3kojE7x9N7KBh1FHLspJDjhTuTKKEmI/IbM5M/EI/ZJuccamo2jVaAOoF76X/YFknlN5gpe/PoXGLXtLRH+5Xdqe7tiINZJi02vf+XGCQdb76ouOCmaZ5T/EfxEBermdzgNi3jg6dLLI8mIscxxMwFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHAGfpMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHAGfpMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A913C116D0;
	Wed, 25 Feb 2026 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772034720;
	bh=1rdQ82+haPKF5dBdYw3pwl0TISsvnjieMrrWIGRyRaA=;
	h=From:To:Cc:Subject:Date:From;
	b=zHAGfpMtfdoqAYfb3hdXTVjJLBKevcakcD3gxc4H5vhXdZ8McppzgP5DR+tBkSP58
	 YhTuxqmqmS7zOgd/z79vfz2ylB1Ex6ssl3Y6rhqyNfs/Q9+LCUv3iJIsRqyt3uI68d
	 7ZFcdR0uAbi7X19wGN+QsXFjW83wDckQm9kX+jiA=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 000/641] 6.18.14-rc2 review
Date: Wed, 25 Feb 2026 07:51:50 -0800
Message-ID: <20260225151847.709818960@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.14-rc2
X-KernelTest-Deadline: 2026-02-27T15:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.14 release.
There are 641 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.14-rc2

Prike Liang <Prike.Liang@amd.com>
    Revert "drm/amdgpu: don't attach the tlb fence for SI"

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Add an hdmi_hpd_debounce_delay_ms module

Huacai Chen <chenhuacai@kernel.org>
    net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Clear HDMI HPD pending work only if it is enabled

Martin KaFai Lau <martin.lau@kernel.org>
    selftests/bpf: Test bpf_skb_check_mtu(BPF_MTU_CHK_SEGS) when transport_header is not set

Joanne Koong <joannelkoong@gmail.com>
    io_uring/rsrc: clean up buffer cloning arg validation

Jan Kiszka <jan.kiszka@siemens.com>
    Drivers: hv: vmbus: Use kthread for vmbus interrupts on PREEMPT_RT

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: fix to avoid directly dereferencing user pointer

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use priv->vidi_dev for ctx lookup in vidi_connection_ioctl()

Lewis Mason <mason8110@gmail.com>
    ALSA: hda/realtek: Add quirk for Samsung Galaxy Book3 Pro 360 (NP965QFG)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314

Eric Naim <dnaim@cachyos.org>
    ALSA: hda/realtek: Add quirk for Gigabyte G5 KF5 (2023)

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: dt-bindings: asahi-kasei,ak5558: Fix the supply names

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: dt-bindings: asahi-kasei,ak4458: Fix the supply names

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: dt-bindings: asahi-kasei,ak4458: set unevaluatedProperties:false

Vikram Sharma <quic_vikramsa@quicinc.com>
    dt-bindings: media: qcom,qcs8300-camss: Add missing power supplies

Abel Vesa <abel.vesa@linaro.org>
    dt-bindings: phy: qcom-edp: Add missing clock for X Elite

Daniel Hodges <git@danielhodges.dev>
    SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: auth_gss: fix memory leaks in XDR decoding error paths

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: avoid Non-NCQ command starvation

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: refactor ata_scsi_translate()

Linus Walleij <linusw@kernel.org>
    ata: pata_ftide010: Fix some DMA timings

Jan Kara <jack@suse.cz>
    ext4: use optimized mballoc scanning regardless of inode format

Jan Kara <jack@suse.cz>
    ext4: always allocate blocks only from groups inode can use

Brian Foster <bfoster@redhat.com>
    ext4: fix dirtyclusters double decrement on fs shutdown

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: fix e4b bitmap inconsistency reports

Zilin Guan <zilin@seu.edu.cn>
    ext4: fix memory leak in ext4_ext_shift_extents()

Zhang Yi <yi.zhang@huawei.com>
    ext4: drop extent cache when splitting extent fails

Zhang Yi <yi.zhang@huawei.com>
    ext4: drop extent cache after doing PARTIAL_VALID1 zeroout

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't cache extent during splitting extent

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't zero the entire extent if EXT4_EXT_DATA_PARTIAL_VALID1

Zhang Yi <yi.zhang@huawei.com>
    ext4: subdivide EXT4_EXT_DATA_VALID1

Yao Zi <me@ziyao.cc>
    MIPS: Work around LLVM bug when gp is used as global register variable

Thomas Richard (TI) <thomas.richard@bootlin.com>
    usb: cdns3: fix role switching during resume

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Use same max plane scaling limits for all 64 bpp formats

Detlev Casanova <detlev.casanova@collabora.com>
    ASoC: rockchip: i2s-tdm: Use param rate if not provided by set_sysclk

Ethan Tidmore <ethantidmore06@gmail.com>
    x86/hyperv: Fix error pointer dereference

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid leaf access in btrfs_quota_enable() if ref key not found

Filipe Manana <fdmanana@suse.com>
    btrfs: use the correct type to initialize block reserve for delayed refs

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    btrfs: reset block group size class when it becomes empty

Filipe Manana <fdmanana@suse.com>
    btrfs: reduce block group critical section in btrfs_free_reserved_bytes()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove fs_info argument from btrfs_try_granting_tickets()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    efi: Fix reservation of unaccepted memory table

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    gpio: amd-fch: ionly return allowed values from amd_fch_gpio_get()

Raag Jadav <raag.jadav@intel.com>
    drm/xe/bo: Redirect faults to dummy page for wedged device

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Make xe_modparam.force_vram_bar_size signed

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/xe2_hpg: Fix handling of Wa_14019988906 & Wa_14019877138

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/mmio: Avoid double-adjust in 64-bit reads

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/configfs: Fix 'parameter name omitted' errors

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/kexec: Make KEXEC_SIG available when CONFIG_MODULES=n

Felix Gu <ustc.gu@gmail.com>
    spi: wpcm-fiu: Fix potential NULL pointer dereference in wpcm_fiu_probe()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix out-of-bounds stream encoder index v3

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Reject cursor plane on DCE when scaled differently than primary

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdkfd: Fix watch_id bounds checking in debug address watch v2

Kai-Heng Feng <kaihengf@nvidia.com>
    PCI: Validate window resource type in pbus_select_window_for_type()

Alexandre Ferrieux <alexandre.ferrieux@orange.com>
    ASoC: codecs: aw88261: Fix erroneous bitmask logic in Awinic init

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    drm/i915/acpi: free _DSM package when no connectors

Ziyi Guo <n7l8m4@u.northwestern.edu>
    ASoC: fsl_xcvr: Revert fix missing lock in fsl_xcvr_mode_put()

Li RongQing <lirongqing@baidu.com>
    mshv: fix SRCU protection in irqfd resampler ack handler

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma6: enable queue resets unconditionally

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5.2: enable queue resets unconditionally

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma5: enable queue resets unconditionally

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move reset debug disable handling

Zilin Guan <zilin@seu.edu.cn>
    drm/amdgpu: Fix memory leak in amdgpu_ras_init()

Zilin Guan <zilin@seu.edu.cn>
    drm/amdgpu: Use kvfree instead of kfree in amdgpu_gmc_get_nps_memranges()

Zilin Guan <zilin@seu.edu.cn>
    drm/amdgpu: Fix memory leak in amdgpu_acpi_enumerate_xcc()

John Johansen <john.johansen@canonical.com>
    apparmor: fix aa_label to return state from compount and component match

Georgia Garcia <georgia.garcia@canonical.com>
    apparmor: fix invalid deref of rawdata when export_binary is unset

Zhengmian Hu <huzhengmian@gmail.com>
    apparmor: avoid per-cpu hold underflow in aa_get_buffer

John Johansen <john.johansen@canonical.com>
    apparmor: make label_match return a consistent value

John Johansen <john.johansen@canonical.com>
    apparmor: remove apply_modes_to_perms from label_match

John Johansen <john.johansen@canonical.com>
    apparmor: fix rlimit for posix cpu timers

John Johansen <john.johansen@canonical.com>
    apparmor: move check for aa_null file to cover all cases

Ryan Lee <ryan.lee@canonical.com>
    apparmor: account for in_atomic removal in common_file_perm

John Johansen <john.johansen@canonical.com>
    apparmor: drop in_atomic flag in common_mmap, and common_file_perm

Ryan Lee <ryan.lee@canonical.com>
    apparmor: fix boolean argument in apparmor_mmap_file

Ryan Lee <ryan.lee@canonical.com>
    apparmor: return -ENOMEM in unpack_perms_table upon alloc failure

Helge Deller <deller@kernel.org>
    apparmor: Fix & Optimize table creation from possibly unaligned memory

Helge Deller <deller@kernel.org>
    AppArmor: Allow apparmor to handle unaligned dfa tables

John Johansen <john.johansen@canonical.com>
    apparmor: fix NULL sock in aa_sock_file_perm

System Administrator <root@localhost>
    apparmor: fix NULL pointer dereference in __unix_needs_revalidation

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Use unsigned for mlx5e_get_max_num_channels

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Fix deadlocks between devlink and netdev instance locks

Gal Pressman <gal@nvidia.com>
    net/mlx5: Fix misidentification of write combining CQE during poll loop

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix multiport device check over light SFs

Hangbin Liu <liuhangbin@gmail.com>
    bonding: alb: fix UAF in rlb_arp_recv during bond up/down

Vikas Gupta <vikas.gupta@broadcom.com>
    bnge: fix reserving resources from FW

Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
    eth: fbnic: Advertise supported XDP features.

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Fix default entries mcam entry action

Eric Dumazet <edumazet@google.com>
    ipv6: icmp: remove obsolete code in icmpv6_xrlim_allow()

Eric Dumazet <edumazet@google.com>
    inet: move icmp_global_{credit,stamp} to a separate cache line

Eric Dumazet <edumazet@google.com>
    icmp: prevent possible overflow in icmp_global_allow()

Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>
    eth: fbnic: Add validation for MTU changes

Eric Dumazet <edumazet@google.com>
    macvlan: observe an RCU grace period in macvlan_common_newlink() error path

Jakub Kicinski <kuba@kernel.org>
    selftests: tc_actions: don't dump 2MB of \0 to stdout

Eric Dumazet <edumazet@google.com>
    ping: annotate data-races in ping_lookup()

Arnd Bergmann <arnd@arndb.de>
    net: psp: select CONFIG_SKB_EXTENSIONS

Jakub Kicinski <kuba@kernel.org>
    bpftool: Fix truncated netlink dumps

Eric Dumazet <edumazet@google.com>
    ipv6: fix a race in ip6_sock_set_v6only()

Inseo An <y0un9sa@gmail.com>
    netfilter: nf_tables: fix use-after-free in nf_tables_addchain()

Pablo Neira Ayuso <pablo@netfilter.org>
    net: remove WARN_ON_ONCE when accessing forward path array

Julian Anastasov <ja@ssi.bg>
    ipvs: do not keep dest_dst if dev is going down

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_h323: don't pass uninitialised l3num value

Aleksei Oladko <aleksey.oladko@virtuozzo.com>
    selftests: forwarding: vxlan_bridge_1d_ipv6: fix test failure with br_netfilter enabled

Aleksei Oladko <aleksey.oladko@virtuozzo.com>
    selftests: forwarding: vxlan_bridge_1d: fix test failure with br_netfilter enabled

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mcast: always update mdb_n_entries for vlan contexts

Allison Henderson <achender@kernel.org>
    net/rds: rds_sendmsg should not discard payload_len

Ziyi Guo <n7l8m4@u.northwestern.edu>
    xen-netback: reject zero-queue configuration from guest

Ziyi Guo <n7l8m4@u.northwestern.edu>
    net: usb: catc: enable basic endpoint checking

Antonio Quartulli <antonio@openvpn.net>
    ovpn: tcp - don't deref NULL sk_socket member after tcp_close()

Bobby Eshleman <bobbyeshleman@meta.com>
    eth: fbnic: set DMA_HINT_L4 for all flows

Bobby Eshleman <bobbyeshleman@meta.com>
    eth: fbnic: increase FBNIC_HDR_BYTES_MIN from 128 to 256 bytes

Bobby Eshleman <bobbyeshleman@meta.com>
    eth: fbnic: set FBNIC_QUEUE_RDE_CTL0_EN_HDR_SPLIT on RDE_CTL0

Mohsin Bashir <mohsin.bashr@gmail.com>
    eth: fbnic: Configure RDE settings for pause frame

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Add a map/btf from a fd array more consistently

Anton Protopopov <a.s.protopopov@gmail.com>
    bpf: Fix a potential use-after-free of BTF object

Amery Hung <ameryhung@gmail.com>
    libbpf: Fix invalid write loop logic in bpf_linker__add_buf()

Chengfeng Ye <dg573847474@gmail.com>
    fbnic: close fw_log race between users and teardown

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: fix PTP clock max_adj value

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: Fix out-of-bound access in fib6_add_rt2node().

Pin-yen Lin <treapking@google.com>
    selftests: netconsole: Increase port listening timeout

Andre Carvalho <asantostc@gmail.com>
    selftests: netconsole: remove log noise due to socat exit

Ziyi Guo <n7l8m4@u.northwestern.edu>
    net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()

Ziyi Guo <n7l8m4@u.northwestern.edu>
    net: mscc: ocelot: split xmit into FDMA and register injection paths

Ziyi Guo <n7l8m4@u.northwestern.edu>
    net: mscc: ocelot: extract ocelot_xmit_timestamp() helper

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5/lan969x: fix DWRR cost max to match hardware register width

Jie Zhang <jzhang918@gmail.com>
    net: stmmac: fix oops when split header is enabled

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: replace has_xxxx with core_type

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: stmmac: remove broken PCS code

Yue Haibing <yuehaibing@huawei.com>
    selftests: net: lib: Fix jq parsing error

Ido Schimmel <idosch@nvidia.com>
    selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2

Ralf Lici <ralf@mandelbit.com>
    ovpn: fix VPN TX bytes counting

Ralf Lici <ralf@mandelbit.com>
    ovpn: fix possible use-after-free in ovpn_net_xmit

Ralf Lici <ralf@mandelbit.com>
    ovpn: set sk_user_data before overriding callbacks

Aboorva Devarajan <aboorvad@linux.ibm.com>
    cpuidle: Skip governor when only one idle state is available

Zhai Can <bczhc0@126.com>
    ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO

zhouwenhao <zhouwenhao7600@gmail.com>
    objpool: fix the overestimation of object pooling metadata size

Aristeu Rozanski <aris@redhat.com>
    selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT

Josh Poimboeuf <jpoimboe@kernel.org>
    kbuild: Add objtool to top-level clean target

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    powercap: intel_rapl_tpmi: Remove FW_BUG from invalid version check

Sean V Kelley <skelley@nvidia.com>
    ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: prevent infinite loops caused by the next valid being the same

Bartlomiej Kubik <kubik.bartlomiej@gmail.com>
    fs/ntfs3: Initialize new folios before use

Jens Axboe <axboe@kernel.dk>
    io_uring/cancel: de-unionize file and user_data in struct io_cancel_data

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: delay sqarray static branch disablement

Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
    drbd: always set BLK_FEAT_STABLE_WRITES

Jared Kangas <jkangas@redhat.com>
    dmaengine: fsl-edma: don't explicitly disable clocks in .remove()

Barnabás Czémán <barnabas.czeman@mainlining.org>
    backlight: qcom-wled: Change PM8950 WLED configurations

Barnabás Czémán <barnabas.czeman@mainlining.org>
    backlight: qcom-wled: Support ovp values for PMI8994

Haotian Zhang <vulab@iscas.ac.cn>
    leds: qcom-lpg: Check the return value of regmap_bulk_write()

Duje Mihanović <duje@dujemihanovic.xyz>
    leds: expresswire: Fix chip state breakage

Jiayu Du <jiayu.riscv@isrc.iscas.ac.cn>
    pinctrl: canaan: k230: Fix NULL pointer dereference when parsing devicetree

Wei Li <unsw.weili@gmail.com>
    pinctrl: single: fix refcount leak in pcs_add_gpio_func()

Felix Gu <ustc.gu@gmail.com>
    pinctrl: meson: amlogic-a4: Fix device node reference leak in bank helpers

Luca Weiss <luca.weiss@fairphone.com>
    pinctrl: qcom: sm8250-lpass-lpi: Fix i2s2_data_groups definition

Luca Boccassi <luca.boccassi@gmail.com>
    pidfs: return -EREMOTE when PIDFD_GET_INFO is called on another ns

Randy Dunlap <rdunlap@infradead.org>
    mips: LOONGSON32: drop a dangling Kconfig symbol

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: sca3000: Fix a resource leak in sca3000_probe()

Qing Wang <wangqing7171@gmail.com>
    ovl: Fix uninit-value in ovl_fill_real

Felix Gu <ustc.gu@gmail.com>
    pinctrl: equilibrium: Fix device node reference leak in pinbank_init()

Jose Javier Rodriguez Barbarin <dev-josejavier.rodriguez@duagon.com>
    mcb: fix incorrect sanity check

Randy Dunlap <rdunlap@infradead.org>
    nvmem: an8855: drop an unused Kconfig symbol

Justin Chen <justin.chen@broadcom.com>
    usb: bdc: fix sleep during atomic

Svyatoslav Ryhel <clamor95@gmail.com>
    drivers: iio: mpu3050: use dev_err_probe for regulator request

Robert Marko <robert.marko@sartura.hr>
    mfd: simple-mfd-i2c: Add Delta TN48M CPLD support

Haotian Zhang <vulab@iscas.ac.cn>
    mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"

Yicong Yang <yangyicong@hisilicon.com>
    coresight: tmc-etr: Fix race condition between sysfs and perf mode

Thomas Richard <thomas.richard@bootlin.com>
    phy: freescale: imx8qm-hsio: fix NULL pointer dereference

Antonio Borneo <antonio.borneo@foss.st.com>
    coresight: etm3x: Fix cpulocked warning on cpuhp

Kery Qi <qikeyu2017@gmail.com>
    watchdog: starfive-wdt: Fix PM reference leak in probe error path

Petre Rodan <petre.rodan@subdimension.ro>
    iio: pressure: mprls0025pa: fix pressure calculation

Petre Rodan <petre.rodan@subdimension.ro>
    iio: pressure: mprls0025pa: fix scan_type struct

Petre Rodan <petre.rodan@subdimension.ro>
    iio: pressure: mprls0025pa: fix interrupt flag

Petre Rodan <petre.rodan@subdimension.ro>
    iio: pressure: mprls0025pa: fix SPI CS delay violation

Petre Rodan <petre.rodan@subdimension.ro>
    iio: pressure: mprls0025pa: fix spi_transfer struct initialisation

Matthew Schwartz <matthew.schwartz@linux.dev>
    mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms

Zilin Guan <zilin@seu.edu.cn>
    gpib: Fix memory leak in ni_usb_init()

Dan Carpenter <dan.carpenter@linaro.org>
    gpib: Fix error code in ni_usb_write_registers()

Dan Carpenter <dan.carpenter@linaro.org>
    gpib: Fix error code in ibonline()

Randy Dunlap <rdunlap@infradead.org>
    serial: SH_SCI: improve "DMA support" prompt

Randy Dunlap <rdunlap@infradead.org>
    serial: imx: change SERIAL_IMX_CONSOLE to bool

Chaitanya Mishra <chaitanyamishra.ai@gmail.com>
    staging: greybus: lights: avoid NULL deref

Randy Dunlap <rdunlap@infradead.org>
    usb: typec: ucsi: drop an unused Kconfig symbol

Randy Dunlap <rdunlap@infradead.org>
    iio: test: drop dangling symbol in gain-time-scale helpers

Arnd Bergmann <arnd@arndb.de>
    soundwire: intel_ace2x: add SND_HDA_CORE dependency

Alper Ak <alperyasinak1@gmail.com>
    char: misc: Use IS_ERR() for filp_open() return value

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    phy: rockchip: samsung-hdptx: Pre-compute HDMI PLL config for 461.10125 MHz output

Nuno Sá <nuno.sa@analog.com>
    dma: dma-axi-dmac: fix HW scatter-gather not looking at the queue

Nuno Sá <nuno.sa@analog.com>
    dma: dma-axi-dmac: fix SW cyclic transfers

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    dmaengine: mediatek: uart-apdma: Fix above 4G addressing TX/RX

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    interconnect: mediatek: Aggregate bandwidth with saturating add

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    interconnect: mediatek: Don't hijack parent device

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    clk: zynqmp: pll: Fix zynqmp_clk_divider_determine_rate kerneldoc

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    clk: zynqmp: divider: Fix zynqmp_clk_divider_determine_rate kerneldoc

Haotian Zhang <vulab@iscas.ac.cn>
    clk: mediatek: Fix error handling in runtime PM setup

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    clk: mediatek: Add mfg_eb as parent to mt8196 mfgpll clocks

Sjoerd Simons <sjoerd@collabora.com>
    clk: mediatek: Drop __initconst from gates

Brian Masney <bmasney@redhat.com>
    clk: zynqmp: divider: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: x86: cgu: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: versaclock3: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: stm32: stm32-core: convert from divider_round_rate_parent() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: stm32: stm32-core: convert from divider_ro_round_rate() to divider_ro_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: sprd: div: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: sophgo: sg2042-clkgen: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: nxp: lpc32xx: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: nuvoton: ma35d1-divider: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: milbeaut: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: loongson1: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: hisilicon: clkdivider-hi6220: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: bm1880: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: actions: owl-divider: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: actions: owl-composite: convert from owl_divider_helper_round_rate() to divider_determine_rate()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    clk: qcom: gfx3d: add parent to parent request map

David Heidelberg <david@ixit.cz>
    clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk1_clk_src

Petr Hodina <petr.hodina@protonmail.com>
    clk: qcom: dispcc-sdm845: Enable parents for pixel clocks

Brian Masney <bmasney@redhat.com>
    clk: qcom: regmap-divider: convert from divider_round_rate() to divider_determine_rate()

Brian Masney <bmasney@redhat.com>
    clk: qcom: regmap-divider: convert from divider_ro_round_rate() to divider_ro_determine_rate()

Geert Uytterhoeven <geert@linux-m68k.org>
    clk: Move clk_{save,restore}_context() to COMMON_CLK section

Vladimir Zapolskiy <vz@mleia.com>
    Input: adp5589 - remove a leftover header file

Brian Masney <bmasney@redhat.com>
    clk: microchip: core: remove duplicate determine_rate on pic32_sclk_ops

Miaoqian Lin <linmq006@gmail.com>
    clk: rockchip: Fix error pointer check after rockchip_clk_register_gate_link()

Brian Masney <bmasney@redhat.com>
    clk: qcom: alpha-pll: convert from divider_round_rate() to divider_determine_rate()

George Moussalem <george.moussalem@outlook.com>
    clk: qcom: gcc-ipq5018: flag sleep clock as critical

Barnabás Czémán <barnabas.czeman@mainlining.org>
    clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc

Barnabás Czémán <barnabas.czeman@mainlining.org>
    clk: qcom: gcc-msm8953: Remove ALWAYS_ON flag from cpp_gdsc

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-glymur: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-x1e80100: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-milos: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-sm4450: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-sm8750: Update the SDCC RCGs to use shared_floor_ops

Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
    clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: g12a: Limit the HDMI PLL OD to /4

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: gxbb: Limit the HDMI PLL OD to /4 on GXL/GXM SoCs

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: rcg2: compute 2d using duty fraction directly

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: gcc-sm8650: Use floor ops for SDCC RCGs

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs

Inochi Amaoto <inochiama@gmail.com>
    clk: spacemit: Respect Kconfig setting when building modules

Yao Zi <ziyao@disroot.org>
    clk: thead: th1520-ap: Poll for PLL lock and wait for stability

Felix Gu <ustc.gu@gmail.com>
    fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()

Felix Gu <ustc.gu@gmail.com>
    fbdev: of_display_timing: Fix device node reference leak in of_get_display_timings()

Sudeep Holla <sudeep.holla@arm.com>
    Revert "mailbox/pcc: support mailbox management of the shared buffer"

Shengjiu Wang <shengjiu.wang@nxp.com>
    remoteproc: imx_dsp_rproc: Only reset carveout memory at RPROC_OFFLINE state

Steven Rostedt <rostedt@goodmis.org>
    tracing: Remove duplicate ENABLE_EVENT_STR and DISABLE_EVENT_STR macros

Miaoqian Lin <linmq006@gmail.com>
    tracing: Properly process error handling in event_hist_trigger_parse()

Sagi Grimberg <sagi@grimberg.me>
    fs/nfs: Fix readdir slow-start regression

Li Chen <me@linux.beauty>
    nvdimm: virtio_pmem: serialize flush requests

Colin Ian King <colin.i.king@gmail.com>
    scsi: csiostor: Fix dereference of null pointer rn

Arnd Bergmann <arnd@arndb.de>
    scsi: ufs: host: mediatek: Require CONFIG_PM

Zilin Guan <zilin@seu.edu.cn>
    scsi: smartpqi: Fix memory leak in pqi_report_phys_luns()

Olga Kornievskaia <okorniev@redhat.com>
    pNFS: fix a missing wake up while waiting on NFS_LAYOUT_DRAIN

Yi Liu <liuy22@mails.tsinghua.edu.cn>
    RDMA/uverbs: Add __GFP_NOWARN to ib_uverbs_unmarshall_recv() kmalloc

Val Packett <val@packett.cool>
    power: supply: qcom_battmgr: Recognize "LiP" as lithium-polymer

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: pm8916_lbc: Fix use-after-free for extcon in IRQ handler

Weili Qian <qianweili@huawei.com>
    hisi_acc_vfio_pci: fix VF reset timeout issue

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: Fix kernel doc

Weigang He <geoffreyhe2@gmail.com>
    mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()

Yuxiong Wang <yuxiong.wang@linux.alibaba.com>
    cxl: Fix premature commit_end increment on decoder commit failure

Chuck Lever <chuck.lever@oracle.com>
    RDMA/core: add rdma_rw_max_sge() helper for SQ sizing

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Fix race condition in QP timer handlers

Zilin Guan <zilin@seu.edu.cn>
    RDMA/mlx5: Fix memory leak in GET_DATA_DIRECT_SYSFS_PATH handler

Yi Liu <liuy22@mails.tsinghua.edu.cn>
    RDMA/uverbs: Validate wqe_size before using it in ib_uverbs_post_send

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE

Cheatham, Benjamin <benjamin.cheatham@amd.com>
    cxl/core: Fix cxl_dport debugfs EINJ entries

Mike Snitzer <snitzer@kernel.org>
    NFS/localio: remove -EAGAIN handling in nfs_local_doio()

Mike Snitzer <snitzer@hammerspace.com>
    NFS/localio: use GFP_NOIO and non-memreclaim workqueue in nfs_local_commit

Mike Snitzer <snitzer@hammerspace.com>
    NFS/localio: prevent direct reclaim recursion into NFS via nfs_writepages

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/localio: Handle short writes by retrying

Zilin Guan <zilin@seu.edu.cn>
    mtd: parsers: Fix memory leak in mtd_parser_tplink_safeloader_parse()

Mario Limonciello (AMD) <superm1@kernel.org>
    crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT fails

Mario Limonciello (AMD) <superm1@kernel.org>
    crypto: ccp - Factor out ring destroy handling to a helper

Mario Limonciello (AMD) <superm1@kernel.org>
    crypto: ccp - Add an S4 restore flow

Mario Limonciello (AMD) <superm1@kernel.org>
    crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Prevent TEE errors after hibernate

Anthony Pighin (Nokia) <anthony.pighin@nokia.com>
    vfio/pci: Lock upstream bridge for vfio_pci_core_disable()

Alexander Usyskin <alexander.usyskin@intel.com>
    mtd: intel-dg: Fix accessing regions before setting nregions

Alok Tiwari <alok.a.tiwari@oracle.com>
    mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper

Or Har-Toov <ohartoov@nvidia.com>
    IB/mlx5: Fix port speed query for representors

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/mlx5: Fix UMR hang in LAG error state unload

Malaya Kumar Rout <mrout@redhat.com>
    tools/power/x86/intel-speed-select: Fix file descriptor leak in isolate_cpus()

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: fix platform profile values for Omen 16-wf1xxx

Jacob Moroni <jmoroni@google.com>
    RDMA/iwcm: Fix workqueue list corruption by removing work_list

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    RDMA/rxe: Fix double free in rxe_srq_from_init

Roman Penyaev <r.peniaev@gmail.com>
    RDMA/rtrs-srv: fix SG mapping

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: wm97xx: Fix NULL pointer dereference in power_supply_changed()

Haotian Zhang <vulab@iscas.ac.cn>
    power: supply: bq27xxx: fix wrong errno when bus ops are unsupported

Alexander Koskovich <AKoskovich@pm.me>
    power: reset: nvmem-reboot-mode: respect cell size for nvmem_cell_write

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: sbs-battery: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: rt9455: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: pm8916_lbc: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: pm8916_bms_vm: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: goldfish: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: cpcap-battery: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: bq25980: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: bq256xx: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: act8945a: Fix use-after-free in power_supply_changed()

Waqar Hameed <waqar.hameed@axis.com>
    power: supply: ab8500: Fix use-after-free in power_supply_changed()

Dan Williams <dan.j.williams@intel.com>
    cxl/mem: Fix devm_cxl_memdev_edac_release() confusion

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Fix ucaps init error flow

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Notify ULP of remaining soft-WCs during reset

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix RoCEv1 failure due to DSCP

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix WQ_MEM_RECLAIM warning

Etienne AUJAMES <eaujames@ddn.com>
    IB/cache: update gid cache on client reregister event

Honggang LI <honggangli@163.com>
    RDMA/rtrs: server: remove dead code

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Fix memleak of newsk in unix_stream_connect().

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-pf: Unregister devlink on probe failure

Michael Dege <michael.dege@renesas.com>
    net: renesas: rswitch: fix forwarding offload statemachine

Eric Joyner <eric.joyner@amd.com>
    ionic: Rate limit unknown xcvr type messages

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep_vf: ensure dbell BADDR updation

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep: ensure dbell BADDR updation

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep: disable per ring interrupts

Jiayuan Chen <jiayuan.chen@shopee.com>
    serial: caif: fix use-after-free in caif_serial ldisc_close()

Jiayuan Chen <jiayuan.chen@shopee.com>
    xfrm: fix ip_rt_bug race in icmp_route_lookup reverse path

René Rebe <rene@exactco.de>
    net: sunhme: Fix sbus regression

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: atm: fix crash due to unvalidated vcc pointer in sigd_send()

Stefan Metzmacher <metze@samba.org>
    smb: client: correct value for smbd_max_fragmented_recv_size

Jinliang Zheng <alexjlzheng@tencent.com>
    procfs: fix missing RCU protection when reading real_parent in do_task_stat()

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix double free issue for tx spare buffer

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Fix output pin phase adjustment sign

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Cache all output properties in zl3073x_out

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Split ref, out, and synth logic from core

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Store raw register values instead of parsed state

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: Specify phase adjustment granularity for pins

Ivan Vecera <ivecera@redhat.com>
    dpll: add phase-adjust-gran pin attribute

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: validate open interval overlap

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: validate element belonging to interval

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_rbtree: don't gc elements on insert

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: remove seqcount_rwlock_t

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: use binary search array in get command

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: translate rbtree to array for binary search

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval

Anders Grahn <anders.grahn@gmail.com>
    netfilter: nft_counter: fix reset of counters on 32bit archs

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_hash: fix get operation on big endian

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation

Scott Mitchell <scott.k.mitch1@gmail.com>
    netfilter: nfnetlink_queue: optimize verdict lookup with hash table

Votokina Victoria <Victoria.Votokina@kaspersky.com>
    nfc: hci: shdlc: Stop timers and work before freeing context

Eric Dumazet <edumazet@google.com>
    inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    bonding: only set speed/duplex to unknown, if getting speed failed

Anshumali Gaur <agaur@marvell.com>
    octeontx2-af: Fix PF driver crash with kexec kernel booting

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix receive space timestamp initialization

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not account for OoO in mptcp_rcvbuf_grow()

Tuo Li <islituo@gmail.com>
    of: unittest: fix possible null-pointer dereferences in of_unittest_property_copy()

Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
    tcp: accecn: handle unexpected AccECN negotiation feedback

Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
    tcp: disable RFC3168 fallback identifier for CC modules

Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
    tcp: ECT_1_NEGOTIATION and NEEDS_ACCECN identifiers

Arnd Bergmann <arnd@arndb.de>
    jfs: avoid -Wtautological-constant-out-of-range-compare warning

Ondrej Mosnacek <omosnace@redhat.com>
    ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Ondrej Mosnacek <omosnace@redhat.com>
    ipc: don't audit capability check in ipc_permissions()

Kevin Brodsky <kevin.brodsky@arm.com>
    selftests/mm: fix usage of FORCE_READ() in cow tests

Håkon Bugge <haakon.bugge@oracle.com>
    PCI/ACPI: Restrict program_hpx_type2() to AER bits

Håkon Bugge <haakon.bugge@oracle.com>
    PCI: Initialize RCB from pci_configure_device()

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: clear stale link mapping of ahvif->links_map

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Fix index decrement when array_len is zero

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: add usecase firmware handling based on device compatible

Ziyi Guo <n7l8m4@u.northwestern.edu>
    wifi: ath10k: sdio: add missing lock protection in ath10k_sdio_fw_crashed_dump()

Sergey Shtylyov <s.shtylyov@auroraos.dev>
    PCI: Check parent for NULL in of_pci_bus_release_domain_nr()

Eric Dumazet <edumazet@google.com>
    tcp: tcp_tx_timestamp() must look at the rtx queue

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Remove old_size limit from bridge window sizing

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Stop over-estimating bridge window size

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Rewrite bridge window head alignment function

Zhiyu Zhang <zhiyuzhang999@gmail.com>
    fat: avoid parent link count underflow in rmdir

Alice Ryhl <aliceryhl@google.com>
    rust: task: restrict Task::group_leader() to current

Chaitanya Mishra <chaitanyamishra.ai@gmail.com>
    lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled

Anthony Iliopoulos <ailiop@suse.com>
    nfsd: never defer requests during idmap lookup

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Remove inclusion of nlm4.h header

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Initialize data pointer for zero-length items

Chuck Lever <chuck.lever@oracle.com>
    NFS: NFSERR_INVAL is not defined by NFSv2

Chuck Lever <chuck.lever@oracle.com>
    xdrgen: Fix struct prefix for typedef types in program wrappers

Mikulas Patocka <mpatocka@redhat.com>
    dm: use bio_clone_blkg_association

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down context entry

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Clear Present bit before tearing down PASID entry

Dmytro Maluka <dmaluka@chromium.org>
    iommu/vt-d: Flush cache for PASID table before using it

Zilin Guan <zilin@seu.edu.cn>
    wifi: rtw89: debug: Fix memory leak in __print_txpwr_map()

Jörg Wedekind <joerg@wedekind.de>
    PCI: Mark 3ware-9650SA Root Port Extended Tags as broken

Petr Mladek <pmladek@suse.com>
    kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()

Petr Mladek <pmladek@suse.com>
    module: add helper function for reading module_buildid()

Petr Mladek <pmladek@suse.com>
    kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: fix tracking of connections from localhost

Florian Westphal <fw@strlen.de>
    netfilter: nft_compat: add more restrictions on netlink attributes

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: increase the connection clean up limit to 64

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: reset table validation state on abort

Li Chen <me@linux.beauty>
    ext4: fast commit: make s_fc_lock reclaim-safe

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: cfg80211: stop NAN and P2P in cfg80211_leave

Matt Johnston <matt@codeconstruct.com.au>
    mctp i2c: initialise event handler read bytes

Jian Zhang <zhangjian.3032@bytedance.com>
    net: mctp-i2c: fix duplicate reception of old data

Abhishek Bapat <abhishekbapat@google.com>
    quota: fix livelock between quotactl and freeze_super

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: do WoW offloads only on primary link

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: add OF dependency to AHB

Alistair Popple <apopple@nvidia.com>
    PCI/P2PDMA: Reset page reference count when page mapping fails

Aadityarangan Shridhar Iyengar <adiyenga@cisco.com>
    PCI/PTM: Fix pcie_ptm_create_debugfs() memory leak

Mikulas Patocka <mpatocka@redhat.com>
    dm: use READ_ONCE in dm_blk_report_zones

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix unlocked test for dm_suspended_md

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    PCI/portdrv: Fix potential resource leak

Inochi Amaoto <inochiama@gmail.com>
    PCI: sophgo: Disable L0s and L1 on Sophgo 2044 PCIe Root Ports

Håkon Bugge <haakon.bugge@oracle.com>
    PCI: Do not attempt to set ExtTag for VFs

Shuai Xue <xueshuai@linux.alibaba.com>
    Documentation: tracing: Add PCI tracepoint documentation

Hou Tao <houtao1@huawei.com>
    PCI/P2PDMA: Fix p2pmem_alloc_mmap() warning condition

Hou Tao <houtao1@huawei.com>
    PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails

Huang Chenming <chenming.huang@oss.qualcomm.com>
    wifi: cfg80211: Fix use_for flag update on BSS refresh

Brian Norris <briannorris@google.com>
    PCI/PM: Avoid redundant delays on D3hot->D3cold

Baruch Siach <baruch@tkos.co.il>
    Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors

Haotian Zhang <vulab@iscas.ac.cn>
    PCI: xilinx: Fix INTx IRQ domain leak in error paths

Haotian Zhang <vulab@iscas.ac.cn>
    PCI: mediatek: Fix IRQ domain leak when MSI allocation fails

Carl Lee <carl.lee@amd.com>
    hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification

Guenter Roeck <linux@roeck-us.net>
    Revert "hwmon: (ibmpex) fix use-after-free in high/low store"

Francesco Lavra <flavra@baylibre.com>
    spi: tools: Add include folder to .gitignore

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Handle volatile controls correctly

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Force some SDCA Controls to be volatile

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Remove outdated todo comment

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix incorrect error code returned for failed chain command

Ryan Lin <ryan.lin@intel.com>
    HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients

Zishun Yi <zishun.yi.dev@gmail.com>
    accel/amdxdna: Fix memory leak in amdxdna_ubuf_map

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Stop job scheduling across aie2_release_resource()

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Hold mm structure across iommu_sva_unbind_device()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_lightbar: Fix response size initialization

Sheetal <sheetal@nvidia.com>
    ASoC: tegra: Add AHUB writeable_reg for RX holes

Harry Yoo <harry.yoo@oracle.com>
    mm/slab: fix false lockdep warning in __kfree_rcu_sheaf()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Unregister drm device on probe error

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe/ptl: Disable DCC on PTL

Roberto Sassu <roberto.sassu@huawei.com>
    evm: Use ordered xattrs list to calculate HMAC in evm_init_hmac()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix allocation for small frame sizes

Gokul Praveen <g-praveen@ti.com>
    pwm: tiehrpwm: Enable pwmchip's parent device before setting configuration

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/chrome: cros_typec_switch: Don't touch struct fwnode_handle::dev

Nathan Chancellor <nathan@kernel.org>
    drm/msm/dp: Avoid division by zero in msm_dp_ctrl_config_msa()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: program correct register for UBWC config on DPU 8.x+

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: offset HBB values written to DPU by -13

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/mdss: correct HBB programmed on UBWC 5.x and 6.x devices

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: dw_hdmi_qp: Fix RK3576 HPD interrupt handling

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: Adding reset colorbar cfg in dp init.

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix no showing problem with loading hibmc manually

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: add dp mode valid check

Baihan Li <libaihan@huawei.com>
    drm/hisilicon/hibmc: fix dp probabilistical detect errors after HPD irq

Michał Grzelak <michal.grzelak@intel.com>
    drm/buddy: release free_trees array on buddy mm teardown

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/a2xx: fix pixel shader start on A225

David Heidelberg <david@ixit.cz>
    media: ccs: Accommodate C-PHY into the calculation

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix notifier_wq flushing warning

Brian Masney <bmasney@redhat.com>
    drm/msm/dsi_phy_14nm: convert from divider_round_rate() to divider_determine_rate()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/disp: set num_planes to 1 for interleaved YUV formats

Haotian Zhang <vulab@iscas.ac.cn>
    HID: playstation: Add missing check for input_ff_create_memless

André Draszik <andre.draszik@linaro.org>
    regulator: core: move supply check earlier in set_machine_constraints()

Jani Nikula <jani.nikula@intel.com>
    mei: late_bind: fix struct intel_lb_component_ops kernel-doc

Mani Chandana Ballary Kuntumalla <quic_mkuntuma@quicinc.com>
    drm/msm/dp: Update msm_dp_controller IDs for sa8775p

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: fix WD timer handling on DPU 8.x

Teguh Sobirin <teguh@sobir.in>
    drm/msm/dpu: Set vsync source irrespective of mdp top support

Mahadevan P <mahadevan.p@oss.qualcomm.com>
    drm/msm/disp/dpu: add merge3d support for sc7280

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Use explicit VCN instance 0 in SR-IOV init

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdkfd: Fix signal_eviction_fence() bool return value

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Drop "amdgpu kernel modesetting enabled" message

Zilin Guan <zilin@seu.edu.cn>
    media: chips-media: wave5: Fix memory leak on codec_info allocation failure

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: nau8821: Fixup nau8821_enable_jack_detect()

Konstantin Andreev <andreev@swemel.ru>
    smack: /smack/doi: accept previously used values

Konstantin Andreev <andreev@swemel.ru>
    smack: /smack/doi must be > 0

Ketil Johnsen <ketil.johnsen@arm.com>
    drm/panthor: Evict groups before VM termination

Simon Trimmer <simont@opensource.cirrus.com>
    ASoC: SDCA: Allow sample width wild cards in set_usage()

Takashi Iwai <tiwai@suse.de>
    ALSA: vmaster: Relax __free() variable declarations

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Relax __free() variable declarations

David Heidelberg <david@ixit.cz>
    drm/panel: sw43408: Remove manual invocation of unprepare at remove

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Fix race where send ring appears full due to delayed head update

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix panthor_gpu_coherency_set()

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    workqueue: Process rescuer work items one-by-one using a cursor

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    workqueue: Only assign rescuer work when really needed

Lai Jiangshan <jiangshan.ljs@antgroup.com>
    workqueue: Factor out assign_rescuer_work()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Make sure we resume the tick when new jobs are submitted

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix the logic that decides when to stop ticking

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix immediate ticking on a disabled tick

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix the group priority rotation logic

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Fix the full_tick check

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Recover from panthor_gpu_flush_caches() failures

Junhui Liu <junhui.liu@pigmoral.tech>
    reset: canaan: k230: drop OF dependency and enable by default

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: agatti: Add CX_MEM/DBGC GPU regions

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    arm64: dts: qcom: talos: Drop opp-shared from QUP OPP table

Jonathan Marek <jonathan@marek.ca>
    arm64: dts: qcom: x1e: bus is 40-bits (fix 64GB models)

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: qrb4210-rb2: Fix UART3 wakeup IRQ storm

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: g12: assign the MMC A signal clock

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: g12: assign the MMC B and C signal clocks

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: gx: assign the MMC signal clocks

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: axg: assign the MMC signal clocks

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: c3: assign the MMC signal clocks

Haotian Zhang <vulab@iscas.ac.cn>
    hwspinlock: omap: Handle devm_pm_runtime_enable() errors

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    soc: qcom: ubwc: add missing include

Abhash Kumar Jha <a-kumar2@ti.com>
    arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog instances for j784s4

Abhash Kumar Jha <a-kumar2@ti.com>
    arm64: dts: ti: k3-j784s4-main.dtsi: Move c71_3 node to appropriate order

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: s4: fix mmc clock assignment

Jerome Brunet <jbrunet@baylibre.com>
    arm64: dts: amlogic: s4: assign mmc b clock to 24MHz

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8183-jacuzzi-pico6: Fix typo in pinmux node

Vladimir Zapolskiy <vz@mleia.com>
    arm: dts: lpc32xx: add clocks property to Motor Control PWM device tree node

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: rzt2h-n2h-evk-common: Use GPIO for SD0 write protect

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/eeh: fix recursive pci_lock_rescan_remove locking in EEH event handling

Zilin Guan <zilin@seu.edu.cn>
    soc: mediatek: svs: Fix memory leak in svs_enable_debug_write()

Haotian Zhang <vulab@iscas.ac.cn>
    soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/uaccess: Move barrier_nospec() out of allow_read_{from/write}_user()

Chen-Yu Tsai <wens@kernel.org>
    ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: msm8994-octagon: Fix Analog Devices vendor prefix of AD7147

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: r9a09g047e57-smarc: Remove duplicate SW_LCD_EN

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100: Fix USB combo PHYs SS1 and SS2 ref clocks

Casey Connolly <casey.connolly@linaro.org>
    arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on

Casey Connolly <casey.connolly@linaro.org>
    arm64: dts: qcom: sdm845-oneplus: Don't keep panel regulator always on

Casey Connolly <casey.connolly@linaro.org>
    arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sdm630: fix gpu_speed_bin size

Haotian Zhang <vulab@iscas.ac.cn>
    clk: qcom: Return correct error code in qcom_cc_probe_by_index()

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: tqma8mpql-mba8mp-ras314: Fix HDMI CEC pad control settings

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: tqma8mpql-mba8mpxl: Fix HDMI CEC pad control settings

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Correct 32-bit response handling in NOTIFICATION_INFO_GET

Dan Carpenter <dan.carpenter@linaro.org>
    EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()

Dan Carpenter <dan.carpenter@linaro.org>
    EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    soc: qcom: smem: handle ENOMEM error during probe

Sai Ritvik Tanksalkar <stanksal@purdue.edu>
    pstore/ram: fix buffer overflow in persistent_ram_save_old()

Larysa Zaremba <larysa.zaremba@intel.com>
    selftests/xsk: fix number of Tx frags in invalid packet

Larysa Zaremba <larysa.zaremba@intel.com>
    selftests/xsk: properly handle batch ending in the middle of a packet

Bastien Curutchet (eBPF Foundation) <bastien.curutchet@bootlin.com>
    selftests/bpf: test_xsk: Split xskxceiver

Lianjie Wang <karin0.zst@gmail.com>
    hwrng: core - use RCU and work_struct to fix race condition

Jonathan McDowell <noodles@meta.com>
    hwrng: core - Allow runtime disabling of the HW RNG

Zilin Guan <zilin@seu.edu.cn>
    crypto: starfive - Fix memory leak in starfive_aes_aead_do_one_req()

KP Singh <kpsingh@kernel.org>
    bpf: Require frozen map for calculating map hash

KP Singh <kpsingh@kernel.org>
    bpf: Limit bpf program signature size

Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
    fs/tests: exec: drop duplicate bprm_stack_limits test vectors

Chen Jinghuang <chenjinghuang2@huawei.com>
    sched/rt: Skip currently executing CPU in rto_next_cpu()

Joel Fernandes <joelagnelf@nvidia.com>
    sched/deadline: Clear the defer params

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    media: pci: mg4b: Use IRQF_NO_THREAD

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    mfd: wm8350-core: Use IRQF_ONESHOT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    rtc: amlogic-a4: Remove IRQF_ONESHOT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: typec: fusb302: Remove IRQF_ONESHOT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    EDAC/altera: Remove IRQF_ONESHOT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    scsi: efct: Use IRQF_ONESHOT and default primary handler

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Bluetooth: btintel_pcie: Use IRQF_ONESHOT and default primary handler

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    iommu/amd: Use core's primary handler and set IRQF_ONESHOT

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    platform/x86: int0002: Remove IRQF_ONESHOT from request_irq()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    genirq: Set IRQF_COND_ONESHOT in devm_request_irq().

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Fix bpf_xdp_store_bytes proto for read-only arg

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    crypto: caam - fix netdev memory leak in dpaa2_caam_probe

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/trng - support tfms sharing the device

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Fix kprobe multi stacktrace_ips test

Jiri Olsa <jolsa@kernel.org>
    x86/fgraph,bpf: Switch kprobe_multi program stack unwind to hw_regs path

Jiri Olsa <jolsa@kernel.org>
    x86/fgraph: Fix return_to_handler regs.rsp value

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: inside-secure/eip93 - unregister only available algorithm

Ella Ma <alansnape3058@gmail.com>
    crypto: ccp - Fix a crash due to incorrect cleanup usage of kfree

Luis Gerhorst <luis.gerhorst@fau.de>
    bpf: Fix verifier_bug_if to account for BPF_CALL

Guillaume Gonnet <ggonnet.linux@gmail.com>
    bpf: Fix tcx/netkit detach permissions when prog fd isn't given

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix FIONREAD for sockmap

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix incorrect copied_seq calculation

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    rqspinlock: Fix TAS fallback lock entry creation

Aleksander Jan Bajkowski <olek2@wp.pl>
    hwrng: airoha - set rng quality to 900

Tycho Andersen (AMD) <tycho@kernel.org>
    crypto: ccp - narrow scope of snp_range_list

Tom Lendacky <thomas.lendacky@amd.com>
    crypto: ccp - Fix a case where SNP_SHUTDOWN is missed

Aleksander Jan Bajkowski <olek2@wp.pl>
    crypto: inside-secure/eip93 - fix kernel panic in driver detach

Thomas Gleixner <tglx@linutronix.de>
    hrtimer: Fix trace oddity

Kery Qi <qikeyu2017@gmail.com>
    selftests/bpf: Fix resource leak in serial_test_wq on attach failure

Zesen Liu <ftyghome@gmail.com>
    bpf: Fix memory access flags in helper prototypes

Puranjay Mohan <puranjay@kernel.org>
    bpf: Preserve id of register in sync_linked_regs()

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sgl - fix inconsistent map/unmap direction issue

Qi Tao <taoqi10@huawei.com>
    crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware queue unavailable

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - support the hpre algorithm fallback

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon - consolidate qp creation and start in hisi_qm_alloc_qps_node

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/zip - support fallback for zip

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - centralize the sending locks of each module into qm

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - enhance the configuration of req_type in queue attributes

lizhi <lizhi206@huawei.com>
    crypto: hisilicon/hpre: extend tag field to 64 bits for better performance

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec - move backlog management to qp and store sqe in qp for callback

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/zip - adjust the way to obtain the req in the callback function

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: octeontx - fix dma_free_coherent() size

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: cavium - fix dma_free_coherent() size

Gabriele Monaco <gmonaco@redhat.com>
    sched: Fix build for modules using set_tsk_need_resched()

Thomas Gleixner <tglx@kernel.org>
    time/sched_clock: Use ACCESS_PRIVATE() to evaluate hrtimer::function

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ARM: VDSO: Patch out __vdso_clock_getres() if unavailable

Gabriele Monaco <gmonaco@redhat.com>
    sched: Export hidden tracepoints to modules

Varun R Mallya <varunrmallya@gmail.com>
    libbpf: Fix OOB read in btf_dump_get_bitfield_value

Puranjay Mohan <puranjay@kernel.org>
    selftests/bpf: veristat: fix printing order in output_stats()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix warning on adf_pfvf_pf_proto.c

Sandipan Das <sandipan.das@amd.com>
    perf/x86/core: Do not set bit width for unavailable counters

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/cpu/amd: Correct the microcode table for Zenbleed

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: fix memory leak if io_buffer_add_list fails

Salah Triki <salah.triki@gmail.com>
    s390/cio: Fix device lifecycle handling in css_alloc_subchannel()

Gui-Dong Han <hanguidong02@gmail.com>
    PM: sleep: wakeirq: harden dev_pm_clear_wake_irq() against races

Yaxiong Tian <tianyaxiong@kylinos.cn>
    cpufreq: intel_pstate: Enable asym capacity only when CPU SMT is not possible

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Properly set hw.state on failures

Breno Leitao <leitao@debian.org>
    arm64/gcs: Fix error handling in arch_set_shadow_stack_status()

Samuel Wu <wusamuel@google.com>
    PM: wakeup: Handle empty list in wakeup_sources_walk_start()

Xiao Ni <xni@redhat.com>
    md: fix return value of mddev_trylock

Zilin Guan <zilin@seu.edu.cn>
    md/raid1: fix memory leak in raid1_run()

Roger Pau Monne <roger.pau@citrix.com>
    Partial revert "x86/xen: fix balloon target initialization for PVH dom0"

Govindarajulu Varadarajan <govind.varadar@gmail.com>
    ublk: Validate SQE128 flag before accessing the cmd

Caleb Sander Mateos <csander@purestorage.com>
    ublk: restore auto buf unregister refcount optimization

Felix Gu <ustc.gu@gmail.com>
    thermal/of: Fix reference leak in thermal_of_cm_lookup()

Christoph Hellwig <hch@lst.de>
    iomap: fix submission side handling of completion side errors

Felix Gu <ustc.gu@gmail.com>
    cpufreq: scmi: Fix device_node reference leak in scmi_cpu_domain_id()

Aleks Todorov <aleksbgbg@google.com>
    OPP: Return correct value in dev_pm_opp_get_level

Yu Kuai <yukuai@fnnas.com>
    md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout

Yu Kuai <yukuai@fnnas.com>
    md/raid5: fix IO hang with degraded array with llbitmap

Li Nan <linan122@huawei.com>
    md/raid10: fix any_working flag handling in raid10_sync_request

Yu Kuai <yukuai@fnnas.com>
    md/raid5: fix raid5_run() to return error when log_init() fails

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: intel: x86_pkg_temp_thermal: Handle invalid temperature

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Always check timers with tick stopped

Jens Axboe <axboe@kernel.dk>
    io_uring/sync: validate passed in offset

Jens Axboe <axboe@kernel.dk>
    io_uring/eventfd: remove unused ctx->evfd_last_cq_tail member

Alexey Simakov <bigalex934@gmail.com>
    ACPICA: Fix NULL pointer dereference in acpi_ev_address_space_dispatch()

Caleb Sander Mateos <csander@purestorage.com>
    io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED

Teddy Astie <teddy.astie@vates.tech>
    xen/virtio: Don't use grant-dma-ops when running as Dom0

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: Update cpuidle driver check in __acpi_processor_start()

Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
    rnbd-srv: Fix server side setting of bi_size for special IOs

Shyam Prasad N <sprasad@microsoft.com>
    netfs: avoid double increment of retry_count in subreq

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix potential UAF and double free in smb2_open_file()

Gao Xiang <xiang@kernel.org>
    erofs: fix inline data read failure for ztailpacking pclusters

Boris Burkov <boris@bur.io>
    btrfs: fix EEXIST abort due to non-consecutive gaps in chunk allocation

Boris Burkov <boris@bur.io>
    btrfs: fix block_group_tree dirty_list corruption

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: return correct error when deleting qgroup relation item

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't zone append to conventional zone

Qu Wenruo <wqu@suse.com>
    btrfs: introduce btrfs_bio::async_csum

Qu Wenruo <wqu@suse.com>
    btrfs: make sure all btrfs_bio::end_io are called in task context

Qu Wenruo <wqu@suse.com>
    btrfs: remove btrfs_bio::fs_info by extracting it from btrfs_bio::inode

Qu Wenruo <wqu@suse.com>
    btrfs: headers cleanup to remove unnecessary local includes

Gao Xiang <xiang@kernel.org>
    erofs: handle end of filesystem properly for file-backed mounts

Gao Xiang <xiang@kernel.org>
    erofs: get rid of raw bi_end_io() usage

Alper Ak <alperyasinak1@gmail.com>
    tpm: st33zp24: Fix missing cleanup on get_burstcount() error

Alper Ak <alperyasinak1@gmail.com>
    tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure

Zilin Guan <zilin@seu.edu.cn>
    i3c: dw: Fix memory leak in dw_i3c_master_i2c_xfers()

Fredrik Markstrom <fredrik.markstrom@est.tech>
    i3c: dw: Initialize spinlock to avoid upsetting lockdep

Deepanshu Kartikey <kartikey406@gmail.com>
    gfs2: Fix use-after-free in iomap inline data write path

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix slab-use-after-free in qd_put

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Retries missing in gfs2_{rename,exchange}

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Update hot-join flag only on success

Ben Dooks <ben.dooks@codethink.co.uk>
    fs: add <linux/init_task.h> for 'init_fs'

Amir Goldstein <amir73il@gmail.com>
    fs: move initializing f_mode before file_ref_init()

Breno Leitao <leitao@debian.org>
    device_cgroup: remove branch hint after code refactor

Billy Tsai <billy_tsai@aspeedtech.com>
    i3c: Move device name assignment after i3c_bus_init

Xiaochen Shen <shenxiaochen@open-hieco.net>
    selftests/resctrl: Fix a division by zero error on Hygon

Ben Dooks <ben.dooks@codethink.co.uk>
    audit: move the compat_xxx_class[] extern declarations to audit_arch.h

Yao Kai <yaokai34@huawei.com>
    rcu: Fix rcu_read_unlock() deadloop due to softirq

Shardul Bankar <shardul.b@mpiricsoftware.com>
    hfsplus: return error when node already exists in hfs_bnode_create

Thomas Fourier <fourier.thomas@gmail.com>
    auxdisplay: arm-charlcd: fix release_mem_region() size

YunJe Shin <yjshin0438@gmail.com>
    RDMA/umad: Reject negative data_len in ib_umad_write

YunJe Shin <yjshin0438@gmail.com>
    RDMA/siw: Fix potential NULL pointer dereference in header processing


-------------

Diffstat:

 Documentation/PCI/endpoint/pci-vntb-howto.rst      |   14 +-
 .../bindings/media/qcom,qcs8300-camss.yaml         |   13 +
 .../devicetree/bindings/phy/qcom,edp-phy.yaml      |   28 +-
 .../bindings/sound/asahi-kasei,ak4458.yaml         |    6 +-
 .../bindings/sound/asahi-kasei,ak5558.yaml         |    4 +-
 Documentation/driver-api/dpll.rst                  |   36 +-
 Documentation/netlink/specs/dpll.yaml              |    7 +
 Documentation/networking/ip-sysctl.rst             |    7 +-
 Documentation/trace/events-pci.rst                 |   74 +
 Documentation/trace/index.rst                      |    1 +
 Makefile                                           |   15 +-
 arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts |    1 +
 arch/arm/boot/dts/nxp/lpc/lpc32xx.dtsi             |    1 +
 arch/arm/kernel/vdso.c                             |    1 +
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi        |    7 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |    6 +
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |    9 +
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi        |    9 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi         |    9 +
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi          |   13 +-
 .../freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts   |    2 +-
 .../dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts    |    2 +-
 .../dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts    |    2 +-
 .../boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi  |    2 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi              |    8 +-
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts           |    2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |    4 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |    8 +-
 .../arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi |    3 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm6150.dtsi               |    1 -
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |    8 +-
 arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts |    1 -
 .../boot/dts/renesas/rzt2h-n2h-evk-common.dtsi     |    4 +-
 .../boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi  |   36 -
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi         |   58 +-
 arch/arm64/mm/gcs.c                                |    4 +-
 arch/arm64/net/bpf_jit_comp.c                      |    2 +-
 arch/loongarch/net/bpf_jit.c                       |    2 +-
 arch/mips/Kconfig                                  |    1 -
 arch/mips/kernel/relocate.c                        |   13 +
 arch/powerpc/include/asm/eeh.h                     |    2 +
 arch/powerpc/include/asm/kup.h                     |    2 -
 arch/powerpc/include/asm/uaccess.h                 |    4 +
 arch/powerpc/kernel/eeh_driver.c                   |   11 +-
 arch/powerpc/kernel/eeh_pe.c                       |   74 +-
 arch/powerpc/net/bpf_jit_comp.c                    |    2 +-
 arch/s390/Kconfig                                  |    3 +-
 arch/x86/events/core.c                             |    4 +-
 arch/x86/hyperv/hv_vtl.c                           |    8 +-
 arch/x86/include/asm/ftrace.h                      |    2 +-
 arch/x86/kernel/cpu/amd.c                          |   30 +-
 arch/x86/kernel/ftrace_64.S                        |    5 +-
 arch/x86/xen/enlighten.c                           |    2 +-
 drivers/accel/amdxdna/aie2_ctx.c                   |    8 +-
 drivers/accel/amdxdna/amdxdna_mailbox.c            |   27 +-
 drivers/accel/amdxdna/amdxdna_pci_drv.c            |    5 +-
 drivers/accel/amdxdna/amdxdna_pci_drv.h            |    1 +
 drivers/accel/amdxdna/amdxdna_ubuf.c               |   10 +-
 drivers/acpi/acpica/evregion.c                     |    4 +-
 drivers/acpi/cppc_acpi.c                           |    4 +-
 drivers/acpi/power.c                               |   13 +
 drivers/acpi/processor_driver.c                    |    2 +-
 drivers/ata/libata-core.c                          |    5 +
 drivers/ata/libata-eh.c                            |    6 +
 drivers/ata/libata-scsi.c                          |  174 +-
 drivers/ata/libata.h                               |    2 +
 drivers/ata/pata_ftide010.c                        |    6 +-
 drivers/auxdisplay/arm-charlcd.c                   |    2 +-
 drivers/base/power/wakeirq.c                       |   11 +-
 drivers/base/power/wakeup.c                        |    4 +-
 drivers/block/drbd/drbd_main.c                     |    3 -
 drivers/block/drbd/drbd_nl.c                       |   20 +-
 drivers/block/rnbd/rnbd-srv.c                      |   33 +-
 drivers/block/ublk_drv.c                           |   10 +-
 drivers/bluetooth/btintel_pcie.c                   |    9 +-
 drivers/char/hw_random/airoha-trng.c               |    1 +
 drivers/char/hw_random/core.c                      |  173 +-
 drivers/char/misc_minor_kunit.c                    |    2 +-
 drivers/char/tpm/st33zp24/st33zp24.c               |    6 +-
 drivers/char/tpm/tpm_i2c_infineon.c                |    6 +-
 drivers/clk/actions/owl-composite.c                |   11 +-
 drivers/clk/actions/owl-divider.c                  |   17 +-
 drivers/clk/actions/owl-divider.h                  |    5 -
 drivers/clk/clk-bm1880.c                           |    5 +-
 drivers/clk/clk-loongson1.c                        |    5 +-
 drivers/clk/clk-milbeaut.c                         |    5 +-
 drivers/clk/clk-versaclock3.c                      |    7 +-
 drivers/clk/hisilicon/clkdivider-hi6220.c          |    6 +-
 drivers/clk/mediatek/clk-mt7981-eth.c              |    6 +-
 drivers/clk/mediatek/clk-mt8196-mfg.c              |   13 +-
 drivers/clk/mediatek/clk-mt8516.c                  |    2 +-
 drivers/clk/mediatek/clk-mtk.c                     |   12 +-
 drivers/clk/mediatek/clk-pll.c                     |    3 +
 drivers/clk/mediatek/clk-pll.h                     |    1 +
 drivers/clk/meson/g12a.c                           |   17 +-
 drivers/clk/meson/gxbb.c                           |   17 +-
 drivers/clk/microchip/clk-core.c                   |   10 -
 drivers/clk/nuvoton/clk-ma35d1-divider.c           |    7 +-
 drivers/clk/nxp/clk-lpc32xx.c                      |    6 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   21 +-
 drivers/clk/qcom/clk-rcg2.c                        |    7 +-
 drivers/clk/qcom/clk-regmap-divider.c              |   16 +-
 drivers/clk/qcom/common.c                          |    2 +-
 drivers/clk/qcom/dispcc-sdm845.c                   |    4 +-
 drivers/clk/qcom/dispcc-sm7150.c                   |    2 +-
 drivers/clk/qcom/gcc-glymur.c                      |    4 +-
 drivers/clk/qcom/gcc-ipq5018.c                     |    1 +
 drivers/clk/qcom/gcc-milos.c                       |    6 +-
 drivers/clk/qcom/gcc-msm8917.c                     |    1 -
 drivers/clk/qcom/gcc-msm8953.c                     |    1 -
 drivers/clk/qcom/gcc-qdu1000.c                     |    4 +-
 drivers/clk/qcom/gcc-sdx75.c                       |    4 +-
 drivers/clk/qcom/gcc-sm4450.c                      |    6 +-
 drivers/clk/qcom/gcc-sm8450.c                      |    4 +-
 drivers/clk/qcom/gcc-sm8550.c                      |    4 +-
 drivers/clk/qcom/gcc-sm8650.c                      |    4 +-
 drivers/clk/qcom/gcc-sm8750.c                      |    4 +-
 drivers/clk/qcom/gcc-x1e80100.c                    |    4 +-
 drivers/clk/rockchip/clk.c                         |    2 +-
 drivers/clk/sophgo/clk-sg2042-clkgen.c             |   15 +-
 drivers/clk/spacemit/Makefile                      |    9 +-
 drivers/clk/spacemit/ccu-k1.c                      |    1 +
 drivers/clk/spacemit/ccu_common.c                  |    6 +
 drivers/clk/spacemit/ccu_ddn.c                     |    1 +
 drivers/clk/spacemit/ccu_mix.c                     |    9 +
 drivers/clk/spacemit/ccu_pll.c                     |    1 +
 drivers/clk/sprd/div.c                             |    6 +-
 drivers/clk/stm32/clk-stm32-core.c                 |   42 +-
 drivers/clk/thead/clk-th1520-ap.c                  |   34 +-
 drivers/clk/x86/clk-cgu.c                          |    6 +-
 drivers/clk/zynqmp/divider.c                       |   10 +-
 drivers/clk/zynqmp/pll.c                           |    5 +-
 drivers/cpufreq/intel_pstate.c                     |    2 +-
 drivers/cpufreq/scmi-cpufreq.c                     |    1 +
 drivers/cpuidle/cpuidle.c                          |   10 +
 drivers/cpuidle/governors/menu.c                   |   22 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   27 +-
 drivers/crypto/caam/caamalg_qi2.h                  |    2 +
 drivers/crypto/cavium/cpt/cptvf_main.c             |    3 +-
 drivers/crypto/ccp/ccp-ops.c                       |    2 +-
 drivers/crypto/ccp/psp-dev.c                       |   11 +
 drivers/crypto/ccp/sev-dev.c                       |   59 +-
 drivers/crypto/ccp/sp-dev.c                        |   12 +
 drivers/crypto/ccp/sp-dev.h                        |    3 +
 drivers/crypto/ccp/sp-pci.c                        |   16 +-
 drivers/crypto/ccp/tee-dev.c                       |   56 +-
 drivers/crypto/ccp/tee-dev.h                       |    1 +
 drivers/crypto/hisilicon/Kconfig                   |    1 +
 drivers/crypto/hisilicon/hpre/hpre.h               |    5 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  418 ++--
 drivers/crypto/hisilicon/hpre/hpre_main.c          |    2 +-
 drivers/crypto/hisilicon/qm.c                      |  112 +-
 drivers/crypto/hisilicon/sec2/sec.h                |    7 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  163 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   21 +-
 drivers/crypto/hisilicon/sgl.c                     |    2 +-
 drivers/crypto/hisilicon/trng/trng.c               |  123 +-
 drivers/crypto/hisilicon/zip/zip.h                 |    2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c          |  133 +-
 drivers/crypto/hisilicon/zip/zip_main.c            |    4 +-
 drivers/crypto/inside-secure/eip93/eip93-main.c    |   94 +-
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c       |   10 +
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   |    3 +-
 drivers/crypto/starfive/jh7110-aes.c               |    9 +-
 drivers/cxl/core/edac.c                            |   64 +-
 drivers/cxl/core/hdm.c                             |    3 +-
 drivers/cxl/core/memdev.c                          |    1 -
 drivers/cxl/core/port.c                            |    8 +-
 drivers/cxl/cxlmem.h                               |    5 +-
 drivers/dma/dma-axi-dmac.c                         |   11 +-
 drivers/dma/fsl-edma-main.c                        |    1 -
 drivers/dma/mediatek/mtk-uart-apdma.c              |   10 +-
 drivers/dpll/dpll_netlink.c                        |   12 +-
 drivers/dpll/zl3073x/Makefile                      |    3 +-
 drivers/dpll/zl3073x/core.c                        |  225 --
 drivers/dpll/zl3073x/core.h                        |  167 +-
 drivers/dpll/zl3073x/dpll.c                        |  436 +---
 drivers/dpll/zl3073x/out.c                         |  157 ++
 drivers/dpll/zl3073x/out.h                         |   93 +
 drivers/dpll/zl3073x/prop.c                        |   19 +-
 drivers/dpll/zl3073x/ref.c                         |  112 +
 drivers/dpll/zl3073x/ref.h                         |   66 +
 drivers/dpll/zl3073x/synth.c                       |   87 +
 drivers/dpll/zl3073x/synth.h                       |   72 +
 drivers/edac/altera_edac.c                         |   11 +-
 drivers/edac/i5000_edac.c                          |    1 +
 drivers/edac/i5400_edac.c                          |    2 +-
 drivers/firmware/arm_ffa/driver.c                  |   33 +-
 drivers/firmware/efi/efi.c                         |    8 +-
 drivers/gpio/gpio-amd-fch.c                        |    7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |    8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |    3 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |    4 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |    3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |    6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |    3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |    2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |    6 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |    8 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   14 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   20 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |   14 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |    3 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   45 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |   20 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   36 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    5 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |    5 +
 .../display/dc/resource/dcn315/dcn315_resource.c   |    8 +-
 .../display/dc/resource/dcn316/dcn316_resource.c   |    8 +-
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |    8 +-
 .../display/dc/resource/dcn321/dcn321_resource.c   |    8 +-
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |    8 +-
 .../display/dc/resource/dcn351/dcn351_resource.c   |    8 +-
 drivers/gpu/drm/drm_buddy.c                        |    1 +
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |    1 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   36 +-
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h       |    4 +
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_config.h     |    2 +
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c         |   38 +-
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h         |    8 +
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_reg.h        |    3 +
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c     |   71 +-
 drivers/gpu/drm/i915/display/intel_acpi.c          |    1 +
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c              |    5 +-
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h |   14 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   18 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |    7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c        |   49 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h        |    3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c        |   35 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c         |    7 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h        |    7 +
 drivers/gpu/drm/msm/disp/mdp_format.c              |    8 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   24 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |    4 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c         |    7 +-
 drivers/gpu/drm/msm/msm_mdss.c                     |    2 +-
 drivers/gpu/drm/panel/panel-lg-sw43408.c           |    4 -
 drivers/gpu/drm/panthor/panthor_gpu.c              |   21 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |    4 +
 drivers/gpu/drm/panthor/panthor_sched.c            |  169 +-
 drivers/gpu/drm/panthor/panthor_sched.h            |    1 +
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c     |    7 +-
 drivers/gpu/drm/xe/xe_bo.c                         |    2 +-
 drivers/gpu/drm/xe/xe_configfs.h                   |   12 +-
 drivers/gpu/drm/xe/xe_device.c                     |    1 +
 drivers/gpu/drm/xe/xe_guc_pc.c                     |   34 +
 drivers/gpu/drm/xe/xe_mmio.c                       |   10 +-
 drivers/gpu/drm/xe/xe_module.h                     |    2 +-
 drivers/gpu/drm/xe/xe_wa.c                         |   18 +-
 drivers/hid/hid-playstation.c                      |    4 +-
 drivers/hid/intel-ish-hid/ishtp/bus.c              |    2 +-
 drivers/hv/mshv_eventfd.c                          |    5 +-
 drivers/hv/vmbus_drv.c                             |   66 +-
 drivers/hwmon/ibmpex.c                             |    9 +-
 drivers/hwmon/pmbus/mpq8785.c                      |   28 +
 drivers/hwspinlock/omap_hwspinlock.c               |    4 +-
 drivers/hwtracing/coresight/coresight-etm3x-core.c |   12 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |   13 +
 drivers/i3c/master.c                               |    6 +-
 drivers/i3c/master/dw-i3c-master.c                 |    3 +
 drivers/iio/accel/sca3000.c                        |    6 +-
 drivers/iio/gyro/mpu3050-core.c                    |    6 +-
 drivers/iio/pressure/mprls0025pa.c                 |   36 +-
 drivers/iio/pressure/mprls0025pa.h                 |    2 -
 drivers/iio/pressure/mprls0025pa_spi.c             |   19 +-
 drivers/iio/test/Kconfig                           |    1 -
 drivers/infiniband/core/cache.c                    |    3 +-
 drivers/infiniband/core/iwcm.c                     |   56 +-
 drivers/infiniband/core/iwcm.h                     |    1 -
 drivers/infiniband/core/rw.c                       |   53 +-
 drivers/infiniband/core/user_mad.c                 |    8 +-
 drivers/infiniband/core/uverbs_cmd.c               |    7 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c            |   23 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   54 +-
 drivers/infiniband/hw/mlx5/main.c                  |  101 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    2 +
 drivers/infiniband/hw/mlx5/std_types.c             |    4 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |    3 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  285 ++-
 drivers/infiniband/sw/rxe/rxe_req.c                |    3 +
 drivers/infiniband/sw/rxe/rxe_srq.c                |    6 +-
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   10 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |    3 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   33 +-
 drivers/interconnect/mediatek/icc-emi.c            |    9 +-
 drivers/iommu/amd/amd_iommu.h                      |    1 -
 drivers/iommu/amd/init.c                           |   12 +-
 drivers/iommu/amd/iommu.c                          |    5 -
 drivers/iommu/intel/iommu.c                        |    4 +-
 drivers/iommu/intel/iommu.h                        |   21 +-
 drivers/iommu/intel/pasid.c                        |   18 +-
 drivers/iommu/intel/pasid.h                        |   14 +
 drivers/leds/leds-expresswire.c                    |   24 +-
 drivers/leds/rgb/leds-qcom-lpg.c                   |    8 +-
 drivers/mailbox/pcc.c                              |  102 +-
 drivers/mcb/mcb-core.c                             |    9 +-
 drivers/md/dm-zone.c                               |   11 +-
 drivers/md/dm.c                                    |    2 +
 drivers/md/md-llbitmap.c                           |    4 +-
 drivers/md/md.h                                    |    4 +-
 drivers/md/raid1.c                                 |    1 +
 drivers/md/raid10.c                                |    2 +-
 drivers/md/raid5.c                                 |   10 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   16 +-
 drivers/media/pci/mgb4/mgb4_trigger.c              |    2 +-
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |    4 +-
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |    4 +-
 drivers/media/usb/uvc/uvc_video.c                  |    3 +-
 drivers/mfd/Kconfig                                |   11 +
 drivers/mfd/arizona-core.c                         |    2 +-
 drivers/mfd/simple-mfd-i2c.c                       |    1 +
 drivers/mtd/devices/mtd_intel_dg.c                 |    9 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |    2 +-
 drivers/mtd/parsers/ofpart_core.c                  |   16 +-
 drivers/mtd/parsers/tplink_safeloader.c            |    1 +
 drivers/net/bonding/bond_main.c                    |   21 +-
 drivers/net/caif/caif_serial.c                     |    5 +-
 drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c |    2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   11 +-
 .../net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c |   21 +-
 .../net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c |   64 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.h    |    2 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h         |    1 +
 .../marvell/octeon_ep/octep_regs_cnxk_pf.h         |    1 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |    8 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c  |    3 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_cnxk.c  |   39 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_main.h  |    2 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_rx.c    |    8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   11 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   41 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   14 -
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   13 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   52 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   40 -
 drivers/net/ethernet/mellanox/mlx5/core/wc.c       |   14 +-
 drivers/net/ethernet/meta/fbnic/fbnic_ethtool.c    |    3 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw_log.c     |    3 -
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   20 +
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.h     |    2 +
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   19 +-
 drivers/net/ethernet/meta/fbnic/fbnic_phylink.c    |    3 +
 drivers/net/ethernet/meta/fbnic/fbnic_rpc.c        |    5 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   43 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h       |    3 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |    2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_qos.h |    2 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |   89 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |    7 +-
 drivers/net/ethernet/renesas/rswitch_l2.c          |   15 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |    5 +
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |    5 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |    6 +-
 .../net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c    |    2 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |    6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-s32.c    |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |   73 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c   |    4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   68 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   63 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |    4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    4 +-
 drivers/net/ethernet/sun/sunhme.c                  |    3 +
 drivers/net/macvlan.c                              |    5 +
 drivers/net/mctp/mctp-i2c.c                        |    9 +
 drivers/net/ovpn/io.c                              |   57 +-
 drivers/net/ovpn/socket.c                          |   41 +-
 drivers/net/ovpn/tcp.c                             |   23 +-
 drivers/net/ovpn/udp.c                             |    1 +
 drivers/net/usb/catc.c                             |   37 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |    6 +
 drivers/net/wireless/ath/ath11k/core.c             |   27 +
 drivers/net/wireless/ath/ath11k/core.h             |    4 +
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |    8 +-
 drivers/net/wireless/ath/ath12k/mac.c              |    4 +-
 drivers/net/wireless/ath/ath12k/wow.c              |   16 +
 drivers/net/wireless/ath/ath9k/Kconfig             |    2 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    8 +-
 drivers/net/xen-netback/xenbus.c                   |    5 +-
 drivers/nvdimm/nd_virtio.c                         |    3 +-
 drivers/nvdimm/virtio_pmem.c                       |    1 +
 drivers/nvdimm/virtio_pmem.h                       |    4 +
 drivers/nvmem/Kconfig                              |    2 +-
 drivers/of/unittest.c                              |    6 +-
 drivers/opp/core.c                                 |    2 +-
 drivers/pci/controller/dwc/pcie-sophgo.c           |   18 +
 drivers/pci/controller/pcie-mediatek.c             |    4 +-
 drivers/pci/controller/pcie-xilinx.c               |    9 +-
 drivers/pci/p2pdma.c                               |   10 +-
 drivers/pci/pci-acpi.c                             |   59 +-
 drivers/pci/pci.c                                  |    5 +-
 drivers/pci/pci.h                                  |    3 +
 drivers/pci/pcie/aer.c                             |    3 -
 drivers/pci/pcie/portdrv.c                         |    6 +-
 drivers/pci/pcie/ptm.c                             |    5 +-
 drivers/pci/probe.c                                |   35 +-
 drivers/pci/quirks.c                               |    5 +
 drivers/pci/setup-bus.c                            |  138 +-
 drivers/perf/arm_spe_pmu.c                         |   18 +-
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c        |    2 +-
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |    2 +
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c         |   10 +-
 drivers/pinctrl/pinctrl-equilibrium.c              |    1 +
 drivers/pinctrl/pinctrl-k230.c                     |    7 +-
 drivers/pinctrl/pinctrl-single.c                   |    2 +
 drivers/pinctrl/qcom/pinctrl-sm8250-lpass-lpi.c    |    2 +-
 drivers/platform/chrome/cros_ec_lightbar.c         |    2 +-
 drivers/platform/chrome/cros_typec_switch.c        |    6 +-
 drivers/platform/x86/amd/pmf/core.c                |   62 +-
 drivers/platform/x86/amd/pmf/pmf.h                 |   10 +
 drivers/platform/x86/amd/pmf/tee-if.c              |   12 +-
 drivers/platform/x86/hp/hp-wmi.c                   |  179 +-
 drivers/platform/x86/intel/int0002_vgpio.c         |    4 +-
 drivers/power/reset/nvmem-reboot-mode.c            |   15 +-
 drivers/power/supply/ab8500_charger.c              |   40 +-
 drivers/power/supply/act8945a_charger.c            |   16 +-
 drivers/power/supply/bq256xx_charger.c             |   12 +-
 drivers/power/supply/bq25980_charger.c             |   12 +-
 drivers/power/supply/bq27xxx_battery.c             |    6 +-
 drivers/power/supply/cpcap-battery.c               |    8 +-
 drivers/power/supply/goldfish_battery.c            |   12 +-
 drivers/power/supply/pm8916_bms_vm.c               |   18 +-
 drivers/power/supply/pm8916_lbc.c                  |   18 +-
 drivers/power/supply/qcom_battmgr.c                |    3 +-
 drivers/power/supply/rt9455_charger.c              |   17 +-
 drivers/power/supply/sbs-battery.c                 |   36 +-
 drivers/power/supply/wm97xx_battery.c              |   34 +-
 drivers/powercap/intel_rapl_tpmi.c                 |    2 +-
 drivers/pwm/pwm-tiehrpwm.c                         |    6 +-
 drivers/regulator/core.c                           |   55 +-
 drivers/remoteproc/imx_dsp_rproc.c                 |    8 +-
 drivers/reset/Kconfig                              |    2 +-
 drivers/rtc/rtc-amlogic-a4.c                       |    2 +-
 drivers/s390/cio/css.c                             |    2 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    3 +-
 drivers/scsi/elx/efct/efct_driver.c                |    8 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   13 +-
 drivers/soc/mediatek/mtk-svs.c                     |    5 +-
 drivers/soc/qcom/cmd-db.c                          |    7 +-
 drivers/soc/qcom/smem.c                            |    4 +-
 drivers/soundwire/Kconfig                          |    1 +
 drivers/spi/spi-wpcm-fiu.c                         |    2 +-
 drivers/staging/gpib/common/iblib.c                |    5 +-
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c          |   14 +-
 drivers/staging/greybus/light.c                    |    8 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c       |    3 +
 drivers/thermal/thermal_of.c                       |    4 +-
 drivers/tty/serial/Kconfig                         |    8 +-
 drivers/ufs/host/Kconfig                           |    1 +
 drivers/ufs/host/ufs-mediatek.c                    |   12 +-
 drivers/usb/cdns3/core.c                           |    2 +-
 drivers/usb/gadget/udc/bdc/bdc_core.c              |    4 +-
 drivers/usb/typec/tcpm/fusb302.c                   |    3 +-
 drivers/usb/typec/ucsi/Kconfig                     |    1 -
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   24 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h     |    2 +
 drivers/vfio/pci/vfio_pci_core.c                   |   17 +-
 drivers/video/backlight/qcom-wled.c                |   42 +-
 drivers/video/fbdev/au1200fb.c                     |    6 +-
 drivers/video/of_display_timing.c                  |    6 +-
 drivers/watchdog/starfive-wdt.c                    |    2 +-
 drivers/xen/balloon.c                              |   19 +-
 drivers/xen/grant-dma-ops.c                        |    3 +-
 drivers/xen/unpopulated-alloc.c                    |    3 +
 fs/btrfs/accessors.h                               |    1 +
 fs/btrfs/bio.c                                     |  157 +-
 fs/btrfs/bio.h                                     |   28 +-
 fs/btrfs/block-group.c                             |   31 +-
 fs/btrfs/block-rsv.c                               |    9 +-
 fs/btrfs/btrfs_inode.h                             |    8 +-
 fs/btrfs/compression.c                             |    6 +-
 fs/btrfs/compression.h                             |    6 +-
 fs/btrfs/ctree.h                                   |    2 -
 fs/btrfs/defrag.c                                  |    1 +
 fs/btrfs/dir-item.c                                |    1 +
 fs/btrfs/direct-io.c                               |    6 +-
 fs/btrfs/disk-io.c                                 |    1 +
 fs/btrfs/disk-io.h                                 |    3 +-
 fs/btrfs/extent-tree.c                             |    1 +
 fs/btrfs/extent_io.c                               |   22 +-
 fs/btrfs/extent_io.h                               |    1 -
 fs/btrfs/extent_map.h                              |    3 +-
 fs/btrfs/file-item.c                               |   64 +-
 fs/btrfs/file-item.h                               |    4 +-
 fs/btrfs/inode.c                                   |    8 +-
 fs/btrfs/qgroup.c                                  |   15 +-
 fs/btrfs/scrub.c                                   |   51 +-
 fs/btrfs/space-info.c                              |   15 +-
 fs/btrfs/space-info.h                              |    5 +-
 fs/btrfs/subpage.h                                 |    1 -
 fs/btrfs/transaction.c                             |   11 +-
 fs/btrfs/transaction.h                             |    4 -
 fs/btrfs/tree-log.c                                |    1 +
 fs/btrfs/tree-log.h                                |    3 +-
 fs/btrfs/volumes.c                                 |  243 +-
 fs/btrfs/zoned.c                                   |    4 +-
 fs/btrfs/zoned.h                                   |    1 -
 fs/erofs/fileio.c                                  |   22 +-
 fs/erofs/fscache.c                                 |    4 +-
 fs/erofs/zdata.c                                   |   30 +-
 fs/ext4/ext4.h                                     |   16 +
 fs/ext4/extents.c                                  |   54 +-
 fs/ext4/fast_commit.c                              |   51 +-
 fs/ext4/mballoc-test.c                             |    2 +-
 fs/ext4/mballoc.c                                  |   73 +-
 fs/fat/namei_msdos.c                               |    7 +-
 fs/fat/namei_vfat.c                                |    7 +-
 fs/file_table.c                                    |   10 +-
 fs/fs_struct.c                                     |    1 +
 fs/gfs2/bmap.c                                     |   13 +-
 fs/gfs2/glock.c                                    |   36 +-
 fs/gfs2/glock.h                                    |    3 +-
 fs/gfs2/inode.c                                    |   18 +-
 fs/gfs2/quota.c                                    |    1 +
 fs/hfsplus/bnode.c                                 |    2 +-
 fs/iomap/direct-io.c                               |   10 +-
 fs/jfs/jfs_dtree.c                                 |    4 +-
 fs/netfs/write_retry.c                             |    1 -
 fs/nfs/dir.c                                       |    4 +-
 fs/nfs/localio.c                                   |   92 +-
 fs/nfs/pnfs.c                                      |    3 +-
 fs/nfsd/nfs2acl.c                                  |    2 +-
 fs/nfsd/nfs4idmap.c                                |   48 +-
 fs/nfsd/nfs4proc.c                                 |    2 -
 fs/nfsd/nfs4xdr.c                                  |   16 +
 fs/nfsd/nfsproc.c                                  |    2 +-
 fs/ntfs3/file.c                                    |   10 +-
 fs/ntfs3/fslog.c                                   |    3 +
 fs/overlayfs/readdir.c                             |    2 +-
 fs/pidfs.c                                         |    2 +-
 fs/proc/array.c                                    |    2 +-
 fs/pstore/ram_core.c                               |   11 +
 fs/quota/quota.c                                   |    1 +
 fs/smb/client/smb2file.c                           |    2 +
 fs/smb/client/smbdirect.c                          |   19 +-
 fs/tests/exec_kunit.c                              |    6 -
 include/acpi/pcc.h                                 |   29 -
 include/asm-generic/rqspinlock.h                   |    2 +-
 include/drm/intel/intel_lb_mei_interface.h         |    3 +-
 include/linux/audit.h                              |    6 -
 include/linux/audit_arch.h                         |    7 +
 include/linux/bpf.h                                |    5 +
 include/linux/bpf_mprog.h                          |   10 +
 include/linux/capability.h                         |    6 +
 include/linux/clk.h                                |   48 +-
 include/linux/device_cgroup.h                      |    2 +-
 include/linux/dpll.h                               |    1 +
 include/linux/filter.h                             |   26 +-
 include/linux/ftrace.h                             |    6 +-
 include/linux/hisi_acc_qm.h                        |   13 +-
 include/linux/hw_random.h                          |    2 +
 include/linux/input/adp5589.h                      |  180 --
 include/linux/interrupt.h                          |    2 +-
 include/linux/io_uring_types.h                     |    7 +-
 include/linux/leds-expresswire.h                   |    3 -
 include/linux/libata.h                             |    3 +
 include/linux/mfd/wm8350/core.h                    |    2 +-
 include/linux/mlx5/driver.h                        |    4 +-
 include/linux/module.h                             |    9 +
 include/linux/mtd/spinand.h                        |    2 +-
 include/linux/psp.h                                |    1 +
 include/linux/skmsg.h                              |   70 +-
 include/linux/soc/qcom/ubwc.h                      |    1 +
 include/linux/stmmac.h                             |   12 +-
 include/linux/sunrpc/xdrgen/_builtins.h            |   20 +-
 include/linux/u64_stats_sync.h                     |   10 +
 include/net/inet_ecn.h                             |   20 +-
 include/net/ipv6.h                                 |   11 +-
 include/net/netfilter/nf_conntrack_count.h         |    1 +
 include/net/netfilter/nf_queue.h                   |    4 +
 include/net/netfilter/nf_tables.h                  |    4 +
 include/net/netns/ipv4.h                           |    9 +-
 include/net/tcp.h                                  |   31 +-
 include/net/tcp_ecn.h                              |   66 +-
 include/rdma/rw.h                                  |    2 +
 include/sound/sdca_function.h                      |    1 +
 include/uapi/linux/dpll.h                          |    1 +
 include/uapi/linux/nfs.h                           |    2 +-
 include/ufs/ufshcd.h                               |    4 -
 include/xen/xen.h                                  |    2 +
 io_uring/cancel.h                                  |    6 +-
 io_uring/io_uring.c                                |   14 +-
 io_uring/kbuf.c                                    |    5 +-
 io_uring/msg_ring.c                                |   12 +-
 io_uring/register.c                                |    3 +-
 io_uring/rsrc.c                                    |   27 +-
 io_uring/sync.c                                    |    2 +
 ipc/ipc_sysctl.c                                   |    2 +-
 kernel/bpf/core.c                                  |    4 +-
 kernel/bpf/helpers.c                               |    2 +-
 kernel/bpf/rqspinlock.c                            |    7 +-
 kernel/bpf/syscall.c                               |   19 +-
 kernel/bpf/verifier.c                              |   66 +-
 kernel/kallsyms.c                                  |    9 +-
 kernel/module/kallsyms.c                           |    9 +-
 kernel/rcu/tree.h                                  |    2 +-
 kernel/rcu/tree_plugin.h                           |   15 +-
 kernel/sched/core.c                                |    4 +
 kernel/sched/deadline.c                            |    3 +
 kernel/sched/rt.c                                  |    5 +
 kernel/time/hrtimer.c                              |    2 +-
 kernel/time/sched_clock.c                          |    2 +-
 kernel/trace/bpf_trace.c                           |    6 +-
 kernel/trace/ftrace.c                              |    5 +-
 kernel/trace/trace_events.c                        |    5 -
 kernel/trace/trace_events_hist.c                   |    2 +-
 kernel/ucount.c                                    |    2 +-
 kernel/workqueue.c                                 |   92 +-
 lib/kstrtox.c                                      |    4 +-
 lib/objpool.c                                      |    2 +-
 mm/slub.c                                          |   20 +
 net/atm/signaling.c                                |   56 +-
 net/bridge/br_multicast.c                          |   45 +-
 net/core/dev.c                                     |    2 +-
 net/core/filter.c                                  |   22 +-
 net/core/skmsg.c                                   |   30 +-
 net/ipv4/icmp.c                                    |   32 +-
 net/ipv4/ping.c                                    |   33 +-
 net/ipv4/tcp.c                                     |    3 +
 net/ipv4/tcp_bpf.c                                 |   25 +-
 net/ipv4/tcp_cong.c                                |    5 +-
 net/ipv4/tcp_input.c                               |    5 +-
 net/ipv4/tcp_minisocks.c                           |    7 +-
 net/ipv4/udp_bpf.c                                 |   23 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/icmp.c                                    |   13 +-
 net/ipv6/ip6_fib.c                                 |    2 +-
 net/mptcp/protocol.c                               |   14 +-
 net/mptcp/protocol.h                               |    5 +
 net/netfilter/ipvs/ip_vs_xmit.c                    |   46 +-
 net/netfilter/nf_conncount.c                       |   54 +-
 net/netfilter/nf_conntrack_h323_main.c             |   10 +-
 net/netfilter/nf_tables_api.c                      |   34 +-
 net/netfilter/nfnetlink_queue.c                    |  267 ++-
 net/netfilter/nft_compat.c                         |   13 +-
 net/netfilter/nft_connlimit.c                      |    7 +-
 net/netfilter/nft_counter.c                        |    4 +-
 net/netfilter/nft_set_hash.c                       |    9 +-
 net/netfilter/nft_set_rbtree.c                     |  794 +++++--
 net/nfc/hci/llc_shdlc.c                            |    8 +
 net/psp/Kconfig                                    |    1 +
 net/rds/send.c                                     |    6 +-
 net/sunrpc/auth_gss/auth_gss.c                     |    3 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   82 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |    8 +-
 net/unix/af_unix.c                                 |   11 +-
 net/wireless/core.c                                |    4 +-
 net/wireless/scan.c                                |    2 +-
 rust/kernel/task.rs                                |   24 +-
 security/apparmor/apparmorfs.c                     |    9 +
 security/apparmor/file.c                           |   15 +-
 security/apparmor/include/match.h                  |   12 +-
 security/apparmor/label.c                          |   33 +-
 security/apparmor/lsm.c                            |   33 +-
 security/apparmor/match.c                          |   22 +-
 security/apparmor/net.c                            |    6 +-
 security/apparmor/policy_unpack.c                  |    6 +-
 security/apparmor/resource.c                       |    5 +
 security/integrity/evm/evm_crypto.c                |   14 +-
 security/smack/smackfs.c                           |   79 +-
 sound/core/pcm.c                                   |    4 +-
 sound/core/pcm_compat.c                            |    9 +-
 sound/core/pcm_native.c                            |   50 +-
 sound/core/vmaster.c                               |   12 +-
 sound/hda/codecs/conexant.c                        |   10 +
 sound/hda/codecs/realtek/alc269.c                  |    2 +
 sound/soc/codecs/aw88261.c                         |    3 +-
 sound/soc/codecs/nau8821.c                         |    5 +
 sound/soc/codecs/nau8821.h                         |    1 +
 sound/soc/fsl/fsl_xcvr.c                           |    3 -
 sound/soc/rockchip/rockchip_i2s_tdm.c              |   10 +
 sound/soc/sdca/sdca_asoc.c                         |   54 +-
 sound/soc/sdca/sdca_functions.c                    |   62 +-
 sound/soc/sdca/sdca_regmap.c                       |    9 +-
 sound/soc/tegra/tegra210_ahub.c                    |   57 +
 sound/soc/tegra/tegra210_ahub.h                    |   30 +
 tools/bpf/bpftool/net.c                            |    5 +-
 tools/lib/bpf/btf_dump.c                           |    9 +
 tools/lib/bpf/linker.c                             |    2 +-
 tools/lib/bpf/netlink.c                            |    4 +-
 tools/net/sunrpc/xdrgen/generators/__init__.py     |    3 +-
 .../xdrgen/templates/C/program/decoder/argument.j2 |    4 +
 .../xdrgen/templates/C/program/encoder/result.j2   |    6 +
 .../sunrpc/xdrgen/templates/C/source_top/client.j2 |    1 -
 tools/objtool/Makefile                             |    2 +
 tools/power/x86/intel-speed-select/isst-config.c   |    2 +
 tools/spi/.gitignore                               |    1 +
 tools/testing/selftests/bpf/Makefile               |    2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |   23 +-
 .../selftests/bpf/prog_tests/stacktrace_ips.c      |   19 +-
 tools/testing/selftests/bpf/prog_tests/wq.c        |    5 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   12 +
 tools/testing/selftests/bpf/test_xsk.c             | 2422 +++++++++++++++++++
 tools/testing/selftests/bpf/test_xsk.h             |  297 +++
 tools/testing/selftests/bpf/veristat.c             |    2 +-
 tools/testing/selftests/bpf/xskxceiver.c           | 2497 +-------------------
 tools/testing/selftests/bpf/xskxceiver.h           |  156 --
 .../selftests/drivers/net/lib/sh/lib_netcons.sh    |    6 +-
 .../selftests/drivers/net/mlxsw/tc_restrictions.sh |    4 +-
 tools/testing/selftests/memfd/memfd_test.c         |  113 +-
 tools/testing/selftests/mm/cow.c                   |   16 +-
 .../testing/selftests/net/forwarding/tc_actions.sh |    2 +-
 .../selftests/net/forwarding/vxlan_bridge_1d.sh    |   26 +-
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh         |    2 +-
 tools/testing/selftests/net/lib.sh                 |    2 +-
 tools/testing/selftests/resctrl/resctrlfs.c        |   10 +
 725 files changed, 11596 insertions(+), 7568 deletions(-)


