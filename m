Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E656C7E574;
	Wed, 28 Aug 2024 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724861019; cv=none; b=J9gg5R6Aad9TyucLxVTd1+teV/7+akN7l0x0QBtTpEith25E6YxqeuWqwXy+IIpsNJ3db0uaTnHzEetdv5+BwQlPYsP5+JDbkn4nYgx1ZNBqAYcpxgEl5niOJByO4VNtBvcUqsjsE5vPDb4HGLWFP14SEckyqmTTB79rZEY4CIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724861019; c=relaxed/simple;
	bh=lsJ7IaVjIfd40n0iRb14pQJqol7b4n3uutXF+kqGRHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p+aEL+refQd4ai8/ryWK0r9hLxqoaAznhVB7XepBnuWnm0mga9eZ2fN5gjKJOrizknk4kZIg8yehLeV6cwUDXA+DwBV4y3Ben2bZBDbkugfely7KdWLgmdME3g6FkXAeZGZDwNpqajzECtF05KUX3J0PGnMo4j2cw2/rKaQnfho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r5apPTMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5apPTMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656D5C4CEC0;
	Wed, 28 Aug 2024 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724861018;
	bh=lsJ7IaVjIfd40n0iRb14pQJqol7b4n3uutXF+kqGRHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5apPTMASunVSvnMKVNWo0uD5YawJNY+l8C6Fv/BjxVKTtsk/xpuSnyJ3uvCLOGOM
	 yE/LYFeBtXsp/5iR9j4LkIKcl+voshefBTyZFwGWsoLjEEWJzHLLGHItYIk5LwcHv/
	 tl3SUs74hB8REuqwxCa9Qu0Jj4Ej47VGnUBlIk8ZrZMO8jPPzErCzAQQ0DK62yiRJP
	 GRSHIofw6+7gO2xWRw73SIneVgUBZV7V07B+9AqWZ+oSVH3MnVeBRlVtaRylyvH1cI
	 vv/C1dJvoMKsmN0qEMxNf55xXsSGdLgwS8pQKWqR6lKfcg2hjCjFfREDbbtyybP75J
	 FZF9PVIdkGoNQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
Date: Wed, 28 Aug 2024 18:03:16 +0200
Message-ID: <20240828160322.139406-1-ojeda@kernel.org>
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 27 Aug 2024 16:35:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.7-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Linux 6.10.7-rc1
>
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Input: MT - limit max slots
>
> Namjae Jeon <linkinjeon@kernel.org>
> ksmbd: fix race condition between destroy_previous_session() and smb2 operations()
>
> Yonghong Song <yonghong.song@linux.dev>
> selftests/bpf: Add a test to verify previous stacksafe() fix
>
> Boyuan Zhang <boyuan.zhang@amd.com>
> drm/amdgpu/vcn: not pause dpg for unified queue
>
> Boyuan Zhang <boyuan.zhang@amd.com>
> drm/amdgpu/vcn: identify unified queue in sw init
>
> Christian Brauner <brauner@kernel.org>
> Revert "pidfd: prevent creation of pidfds for kthreads"
>
> Matthew Brost <matthew.brost@intel.com>
> drm/xe: Do not dereference NULL job->fence in trace points
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> selftests: mptcp: join: check re-using ID of closed subflow
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> selftests: mptcp: join: validate fullmesh endp on 1st sf
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: avoid possible UaF when selecting endp
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: fullmesh: select the right ID later
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: only in-kernel cannot have entries with ID 0
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: check add_addr_accept_max before accepting new ADD_ADDR
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: only decrement add_addr_accepted for MPJ req
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: only mark 'subflow' endp as available
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: remove mptcp_pm_remove_subflow()
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: re-using ID of unused flushed subflows
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: re-using ID of unused removed subflows
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> mptcp: pm: re-using ID of unused removed ADD_ADDR
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> thermal: of: Fix OF node leak in of_thermal_zone_find() error paths
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> thermal: of: Fix OF node leak in thermal_of_zone_register()
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> thermal: of: Fix OF node leak in thermal_of_trips_init() error path
>
> Dave Airlie <airlied@redhat.com>
> nouveau/firmware: use dma non-coherent allocator
>
> Peng Fan <peng.fan@nxp.com>
> pmdomain: imx: wait SSAR when i.MX93 power domain on
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
> pmdomain: imx: scu-pd: Remove duplicated clocks
>
> Steve French <stfrench@microsoft.com>
> smb3: fix broken cached reads when posix locks
>
> Ben Whitten <ben.whitten@gmail.com>
> mmc: dw_mmc: allow biu and ciu clocks to defer
>
> Mengqi Zhang <mengqi.zhang@mediatek.com>
> mmc: mtk-sd: receive cmd8 data when hs400 tuning fail
>
> Waiman Long <longman@redhat.com>
> cgroup/cpuset: Clear effective_xcpus on cpus_allowed clearing only if cpus.exclusive not set
>
> Chen Ridong <chenridong@huawei.com>
> cgroup/cpuset: fix panic caused by partcmd_update
>
> Marc Zyngier <maz@kernel.org>
> KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
>
> Zenghui Yu <yuzenghui@huawei.com>
> KVM: arm64: vgic-debug: Don't put unmarked LPIs
>
> Nikolay Kuratov <kniv@yandex-team.ru>
> cxgb4: add forgotten u64 ivlan cast before shift
>
> Michael Ellerman <mpe@ellerman.id.au>
> ata: pata_macio: Fix DMA table overflow
>
> Werner Sembach <wse@tuxedocomputers.com>
> Input: i8042 - use new forcenorestore quirk to replace old buggy quirk combination
>
> Werner Sembach <wse@tuxedocomputers.com>
> Input: i8042 - add forcenorestore quirk to leave controller untouched even on s3
>
> Nicolin Chen <nicolinc@nvidia.com>
> iommufd/device: Fix hwpt at err_unresv in iommufd_device_do_replace()
>
> Jason Gerecke <jason.gerecke@wacom.com>
> HID: wacom: Defer calculation of resolution until resolution_code is known
>
> Jiaxun Yang <jiaxun.yang@flygoat.com>
> MIPS: Loongson64: Set timer mode in cpu-probe
>
> Martin Whitaker <foss@martin-whitaker.me.uk>
> net: dsa: microchip: fix PTP config failure when using multiple ports
>
> Mengyuan Lou <mengyuanlou@net-swift.com>
> net: ngbe: Fix phy mode set to external phy
>
> Harald Freudenberger <freude@linux.ibm.com>
> s390/ap: Refine AP bus bindings complete processing
>
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> platform/x86: ISST: Fix return value on last invalid resource
>
> Hans de Goede <hdegoede@redhat.com>
> platform/x86: dell-uart-backlight: Use acpi_video_get_backlight_type()
>
> Hans de Goede <hdegoede@redhat.com>
> ACPI: video: Add backlight=native quirk for Dell OptiPlex 7760 AIO
>
> Hans de Goede <hdegoede@redhat.com>
> ACPI: video: Add Dell UART backlight controller detection
>
> Alex Deucher <alexander.deucher@amd.com>
> drm/amdgpu/sdma5.2: limit wptr workaround to sdma 5.2.1
>
> Candice Li <candice.li@amd.com>
> drm/amdgpu: Validate TA binary size
>
> Namjae Jeon <linkinjeon@kernel.org>
> ksmbd: the buffer of smb2 query dir response has at least 1 byte
>
> Chaotian Jing <chaotian.jing@mediatek.com>
> scsi: core: Fix the return value of scsi_logical_block_count()
>
> Griffin Kroah-Hartman <griffin@kroah.com>
> Bluetooth: MGMT: Add error handling to pair_device()
>
> Ming Lei <ming.lei@redhat.com>
> nvme: move stopping keep-alive into nvme_uninit_ctrl()
>
> Paulo Alcantara <pc@manguebit.com>
> smb: client: ignore unhandled reparse tags
>
> Alexander Gordeev <agordeev@linux.ibm.com>
> s390/boot: Fix KASLR base offset off by __START_KERNEL bytes
>
> Alexander Gordeev <agordeev@linux.ibm.com>
> s390/boot: Avoid possible physmem_info segment corruption
>
> Yang Ruibin <11162571@vivo.com>
> thermal/debugfs: Fix the NULL vs IS_ERR() confusion in debugfs_create_dir()
>
> Matthew Brost <matthew.brost@intel.com>
> drm/xe: Free job before xe_exec_queue_put
>
> Thomas Hellstr�m <thomas.hellstrom@linux.intel.com>
> drm/xe: Don't initialize fences at xe_sched_job_create()
>
> Thomas Hellstr�m <thomas.hellstrom@linux.intel.com>
> drm/xe: Split lrc seqno fence creation up
>
> Matthew Brost <matthew.brost@intel.com>
> drm/xe: Decouple job seqno and lrc seqno
>
> Rodrigo Vivi <rodrigo.vivi@intel.com>
> drm/xe: Relax runtime pm protection during execution
>
> Stuart Summers <stuart.summers@intel.com>
> drm/xe: Fix missing workqueue destroy in xe_gt_pagefault
>
> Jens Axboe <axboe@kernel.dk>
> io_uring/kbuf: sanitize peek buffer setup
>
> Dan Carpenter <dan.carpenter@linaro.org>
> mmc: mmc_test: Fix NULL dereference on allocation failure
>
> Matthew Brost <matthew.brost@intel.com>
> drm/xe: Fix tile fini sequence
>
> Matthew Auld <matthew.auld@intel.com>
> drm/xe: reset mmio mappings with devm
>
> Matthew Auld <matthew.auld@intel.com>
> drm/xe/mmio: move mmio_fini over to devm
>
> Lucas De Marchi <lucas.demarchi@intel.com>
> drm/xe: Fix opregion leak
>
> Matthew Auld <matthew.auld@intel.com>
> drm/xe/display: stop calling domains_driver_remove twice
>
> Suraj Kandpal <suraj.kandpal@intel.com>
> drm/i915/hdcp: Use correct cp_irq_count
>
> Vignesh Raghavendra <vigneshr@ti.com>
> spi: spi-cadence-quadspi: Fix OSPI NOR failures during system resume
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
> drm/msm: fix the highest_bank_bit for sc7180
>
> Tejun Heo <tj@kernel.org>
> workqueue: Fix spruious data race in __flush_work()
>
> Will Deacon <will@kernel.org>
> workqueue: Fix UBSAN 'subtraction overflow' error in shift_and_mask()
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> drm/msm/dpu: take plane rotation into account for wide planes
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> drm/msm/dpu: relax YUV requirements
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> drm/msm/dpu: limit QCM2290 to RGB formats only
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> drm/msm/dpu: cleanup FB if dpu_format_populate_layout fails
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
> drm/msm/dp: reset the link phy params before link training
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
> drm/msm/dpu: move dpu_encoder's connector assignment to atomic_enable()
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
> drm/msm/dp: fix the max supported bpp logic
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> drm/msm/dpu: don't play tricks with debug macros
>
> Alexandra Winter <wintera@linux.ibm.com>
> s390/iucv: Fix vargs handling in iucv_alloc_device()
>
> Menglong Dong <menglong8.dong@gmail.com>
> net: ovs: fix ovs_drop_reasons error
>
> Sean Anderson <sean.anderson@linux.dev>
> net: xilinx: axienet: Fix dangling multicast addresses
>
> Sean Anderson <sean.anderson@linux.dev>
> net: xilinx: axienet: Always disable promiscuous mode
>
> Bharat Bhushan <bbhushan2@marvell.com>
> octeontx2-af: Fix CPT AF register offset calculation
>
> Pablo Neira Ayuso <pablo@netfilter.org>
> netfilter: flowtable: validate vlan header
>
> Somnath Kotur <somnath.kotur@broadcom.com>
> bnxt_en: Fix double DMA unmapping for XDP_REDIRECT
>
> Eric Dumazet <edumazet@google.com>
> ipv6: prevent possible UAF in ip6_xmit()
>
> Eric Dumazet <edumazet@google.com>
> ipv6: fix possible UAF in ip6_finish_output2()
>
> Eric Dumazet <edumazet@google.com>
> ipv6: prevent UAF in ip6_send_skb()
>
> Ido Schimmel <idosch@nvidia.com>
> selftests: mlxsw: ethtool_lanes: Source ethtool lib from correct path
>
> Felix Fietkau <nbd@nbd.name>
> udp: fix receiving fraglist GSO packets
>
> Stephen Hemminger <stephen@networkplumber.org>
> netem: fix return value if duplicate enqueue fails
>
> Joseph Huang <Joseph.Huang@garmin.com>
> net: dsa: mv88e6xxx: Fix out-of-bound access
>
> Paolo Abeni <pabeni@redhat.com>
> igb: cope with large MAX_SKB_FRAGS
>
> Dan Carpenter <dan.carpenter@linaro.org>
> dpaa2-switch: Fix error checking in dpaa2_switch_seed_bp()
>
> Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ice: use internal pf id instead of function number
>
> Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ice: fix truesize operations for PAGE_SIZE >= 8192
>
> Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ice: fix ICE_LAST_OFFSET formula
>
> Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ice: fix page reuse when PAGE_SIZE is over 8k
>
> Nikolay Aleksandrov <razor@blackwall.org>
> bonding: fix xfrm state handling when clearing active slave
>
> Nikolay Aleksandrov <razor@blackwall.org>
> bonding: fix xfrm real_dev null pointer dereference
>
> Nikolay Aleksandrov <razor@blackwall.org>
> bonding: fix null pointer deref in bond_ipsec_offload_ok
>
> Nikolay Aleksandrov <razor@blackwall.org>
> bonding: fix bond_ipsec_offload_ok return type
>
> Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ip6_tunnel: Fix broken GRO
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
> kcm: Serialise kcm_sendmsg() for the same socket.
>
> Jeremy Kerr <jk@codeconstruct.com.au>
> net: mctp: test: Use correct skb for route input check
>
> Florian Westphal <fw@strlen.de>
> tcp: prevent concurrent execution of tcp_sk_exit_batch
>
> Hangbin Liu <liuhangbin@gmail.com>
> selftests: udpgro: no need to load xdp for gro
>
> Hangbin Liu <liuhangbin@gmail.com>
> selftests: udpgro: report error when receive failed
>
> Simon Horman <horms@kernel.org>
> tc-testing: don't access non-existent variable on exception
>
> Patrisious Haddad <phaddad@nvidia.com>
> net/mlx5: Fix IPsec RoCE MPV trace call
>
> Carolina Jubran <cjubran@nvidia.com>
> net/mlx5e: XPS, Fix oversight of Multi-PF Netdev changes
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
> net: mscc: ocelot: serialize access to the injection/extraction groups
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
> net: mscc: ocelot: fix QoS class for injected packets with "ocelot-8021q"
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
> net: mscc: ocelot: use ocelot_xmit_get_vlan_info() also for FDMA and register injection
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Bluetooth: SMP: Fix assumption of Central always being Initiator
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Bluetooth: hci_core: Fix LE quote calculation
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Bluetooth: HCI: Invert LE State quirk to be opt-out rather then opt-in
>
> Masahiro Yamada <masahiroy@kernel.org>
> kbuild: avoid scripts/kallsyms parsing /dev/null
>
> Masahiro Yamada <masahiroy@kernel.org>
> kbuild: merge temporary vmlinux for BTF and kallsyms
>
> Alexandre Courbot <gnurou@gmail.com>
> Makefile: add $(srctree) to dependency of compile_commands.json target
>
> Takashi Iwai <tiwai@suse.de>
> ALSA: hda/tas2781: Use correct endian conversion
>
> Maximilian Luz <luzmaximilian@gmail.com>
> platform/surface: aggregator: Fix warning when controller is destroyed in probe
>
> Baochen Qiang <quic_bqiang@quicinc.com>
> wifi: ath12k: use 128 bytes aligned iova in transmit path for WCN7850
>
> Mikulas Patocka <mpatocka@redhat.com>
> dm suspend: return -ERESTARTSYS instead of -EINTR
>
> Su Hui <suhui@nfschina.com>
> smb/client: avoid possible NULL dereference in cifs_free_subrequest()
>
> David Howells <dhowells@redhat.com>
> cifs: Add a tracepoint to track credits involved in R/W requests
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> thermal: gov_bang_bang: Use governor_data to reduce overhead
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> thermal: gov_bang_bang: Add .manage() callback
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> thermal: gov_bang_bang: Split bang_bang_control()
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> thermal: gov_bang_bang: Drop unnecessary cooling device target state checks
>
> Mario Limonciello <mario.limonciello@amd.com>
> drm/amd/display: Don't register panel_power_savings on OLED panels
>
> Li Lingfeng <lilingfeng3@huawei.com>
> block: Fix lockdep warning in blk_mq_mark_tag_wait
>
> Samuel Holland <samuel.holland@sifive.com>
> arm64: Fix KASAN random tag seed initialization
>
> Ryo Takakura <takakura@valinux.co.jp>
> printk/panic: Allow cpu backtraces to be written into ringbuffer during panic
>
> Nysal Jan K.A <nysal@linux.ibm.com>
> powerpc/topology: Check if a core is online
>
> Nysal Jan K.A <nysal@linux.ibm.com>
> cpu/SMT: Enable SMT only if a core is online
>
> Olivier Langlois <olivier@trillion01.com>
> io_uring/napi: check napi_enabled in io_napi_add() before proceeding
>
> Pavel Begunkov <asml.silence@gmail.com>
> io_uring/napi: use ktime in busy polling
>
> Thorsten Blum <thorsten.blum@toblux.com>
> io_uring/napi: Remove unnecessary s64 cast
>
> Eric Farman <farman@linux.ibm.com>
> s390/dasd: Remove DMA alignment
>
> Masahiro Yamada <masahiroy@kernel.org>
> rust: fix the default format for CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
>
> Masahiro Yamada <masahiroy@kernel.org>
> rust: suppress error messages from CONFIG_{RUSTC,BINDGEN}_VERSION_TEXT
>
> Miguel Ojeda <ojeda@kernel.org>
> rust: work around `bindgen` 0.69.0 issue
>
> Ma�ra Canal <mcanal@igalia.com>
> drm/v3d: Fix out-of-bounds read in `v3d_csd_job_run()`
>
> Parsa Poorshikhian <parsa.poorsh@gmail.com>
> ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7
>
> Asmaa Mnebhi <asmaa@nvidia.com>
> gpio: mlxbf3: Support shutdown() function
>
> Barak Biber <bbiber@nvidia.com>
> iommu: Restore lost return in iommu_report_device_fault()
>
> Song Liu <song@kernel.org>
> kallsyms: Match symbols exactly with CONFIG_LTO_CLANG
>
> Song Liu <song@kernel.org>
> kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols
>
> Jann Horn <jannh@google.com>
> kallsyms: get rid of code for absolute kallsyms
>
> Masahiro Yamada <masahiroy@kernel.org>
> kbuild: remove PROVIDE() for kallsyms symbols
>
> Masahiro Yamada <masahiroy@kernel.org>
> kbuild: refactor variables in scripts/link-vmlinux.sh
>
> Jie Wang <wangjie125@huawei.com>
> net: hns3: fix a deadlock problem when config TC during resetting
>
> Peiyang Wang <wangpeiyang1@huawei.com>
> net: hns3: use the user's cfg after reset
>
> Jie Wang <wangjie125@huawei.com>
> net: hns3: fix wrong use of semaphore up
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> selftests: net: lib: kill PIDs before del netns
>
> Matthieu Baerts (NGI0) <matttbe@kernel.org>
> selftests: net: lib: ignore possible errors
>
> Cong Wang <cong.wang@bytedance.com>
> vsock: fix recursive ->recvmsg calls
>
> Abhinav Jain <jain.abhinav177@gmail.com>
> selftest: af_unix: Fix kselftest compilation warnings
>
> Phil Sutter <phil@nwl.cc>
> netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
>
> Phil Sutter <phil@nwl.cc>
> netfilter: nf_tables: Introduce nf_tables_getobj_single
>
> Phil Sutter <phil@nwl.cc>
> netfilter: nf_tables: Audit log dump reset after the fact
>
> Florian Westphal <fw@strlen.de>
> netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
>
> Donald Hunter <donald.hunter@gmail.com>
> netfilter: flowtable: initialise extack before use
>
> Donald Hunter <donald.hunter@gmail.com>
> netfilter: nfnetlink: Initialise extack before use in ACKs
>
> Tom Hughes <tom@compton.nu>
> netfilter: allow ipv6 fragments to arrive on different devices
>
> Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
> tcp: Update window clamping condition
>
> Eugene Syromiatnikov <esyr@redhat.com>
> mptcp: correct MPTCP_SUBFLOW_ATTR_SSN_OFFSET reserved size
>
> David Thompson <davthompson@nvidia.com>
> mlxbf_gige: disable RX filters until RX path initialized
>
> Zheng Zhang <everything411@qq.com>
> net: ethernet: mtk_wed: fix use-after-free panic in mtk_wed_setup_tc_block_cb()
>
> Pawel Dembicki <paweldembicki@gmail.com>
> net: dsa: vsc73xx: check busy flag in MDIO operations
>
> Pawel Dembicki <paweldembicki@gmail.com>
> net: dsa: vsc73xx: pass value in phy_write operation
>
> Pawel Dembicki <paweldembicki@gmail.com>
> net: dsa: vsc73xx: fix port MAC configuration in full duplex mode
>
> Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> net: axienet: Fix register defines comment description
>
> Dan Carpenter <dan.carpenter@linaro.org>
> atm: idt77252: prevent use after free in dequeue_rx()
>
> Cosmin Ratiu <cratiu@nvidia.com>
> net/mlx5e: Correctly report errors for ethtool rx flows
>
> Dragos Tatulea <dtatulea@nvidia.com>
> net/mlx5e: Take state lock during tx timeout reporter
>
> Tariq Toukan <tariqt@nvidia.com>
> net/mlx5: SD, Do not query MPIR register if no sd_group
>
> Eric Dumazet <edumazet@google.com>
> gtp: pull network headers in gtp_dev_xmit()
>
> Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
> igc: Fix qbv tx latency by setting gtxoffset
>
> Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
> igc: Fix reset adapter logics when tx mode change
>
> Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
> igc: Fix qbv_config_change_errors logics
>
> Faizal Rahim <faizal.abdul.rahim@linux.intel.com>
> igc: Fix packet still tx after gate close by reducing i226 MAC retry buffer
>
> Naohiro Aota <naohiro.aota@wdc.com>
> btrfs: fix invalid mapping of extent xarray state
>
> Dominique Martinet <asmadeus@codewreck.org>
> 9p: Fix DIO read through netfs
>
> Yonghong Song <yonghong.song@linux.dev>
> bpf: Fix a kernel verifier crash in stacksafe()
>
> Leon Hwang <leon.hwang@linux.dev>
> bpf: Fix updating attached freplace prog in prog_array map
>
> yangerkun <yangerkun@huawei.com>
> libfs: fix infinite directory reads for offset dir
>
> Omar Sandoval <osandov@fb.com>
> filelock: fix name of file_lease slab cache
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
> netfs: Fault in smaller chunks for non-large folio mappings
>
> Claudio Imbrenda <imbrenda@linux.ibm.com>
> s390/uv: Panic for set and remove shared access UVC errors
>
> Christian Brauner <brauner@kernel.org>
> pidfd: prevent creation of pidfds for kthreads
>
> David (Ming Qiang) Wu <David.Wu3@amd.com>
> drm/amd/amdgpu: command submission parser for JPEG
>
> Alex Deucher <alexander.deucher@amd.com>
> drm/amdgpu/jpeg4: properly set atomics vmid field
>
> Alex Deucher <alexander.deucher@amd.com>
> drm/amdgpu/jpeg2: properly set atomics vmid field
>
> Melissa Wen <mwen@igalia.com>
> drm/amd/display: fix cursor offset on rotation 180
>
> Loan Chen <lo-an.chen@amd.com>
> drm/amd/display: Enable otg synchronization logic for DCN321
>
> Hamza Mahfooz <hamza.mahfooz@amd.com>
> drm/amd/display: fix s2idle entry for DCN3.5+
>
> Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> drm/amd/display: Adjust cursor position
>
> Al Viro <viro@zeniv.linux.org.uk>
> memcg_write_event_control(): fix a user-triggerable oops
>
> Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> drm/amdgpu: Actually check flags for all context ops.
>
> Qu Wenruo <wqu@suse.com>
> btrfs: only enable extent map shrinker for DEBUG builds
>
> Qu Wenruo <wqu@suse.com>
> btrfs: tree-checker: add dev extent item checks
>
> Naohiro Aota <naohiro.aota@wdc.com>
> btrfs: zoned: properly take lock to read/update block group's zoned variables
>
> Filipe Manana <fdmanana@suse.com>
> btrfs: only run the extent map shrinker from kswapd tasks
>
> Josef Bacik <josef@toxicpanda.com>
> btrfs: check delayed refs when we're checking if a ref exists
>
> Filipe Manana <fdmanana@suse.com>
> btrfs: send: allow cloning non-aligned extent if it ends at i_size
>
> Qu Wenruo <wqu@suse.com>
> btrfs: tree-checker: reject BTRFS_FT_UNKNOWN dir type
>
> Zi Yan <ziy@nvidia.com>
> mm/numa: no task_numa_fault() call if PTE is changed
>
> Hailong Liu <hailong.liu@oppo.com>
> mm/vmalloc: fix page mapping if vm_area_alloc_pages() with high order fallback to order 0
>
> Zi Yan <ziy@nvidia.com>
> mm/numa: no task_numa_fault() call if PMD is changed
>
> Suren Baghdasaryan <surenb@google.com>
> alloc_tag: introduce clear_page_tag_ref() helper function
>
> Muhammad Usama Anjum <usama.anjum@collabora.com>
> selftests: memfd_secret: don't build memfd_secret test on unsupported arches
>
> Waiman Long <longman@redhat.com>
> mm/memory-failure: use raw_spinlock_t in struct memory_failure_cpu
>
> Suren Baghdasaryan <surenb@google.com>
> alloc_tag: mark pages reserved during CMA activation as not tagged
>
> Zhen Lei <thunder.leizhen@huawei.com>
> selinux: add the processing of the failure of avc_add_xperms_decision()
>
> Zhen Lei <thunder.leizhen@huawei.com>
> selinux: fix potential counting error in avc_add_xperms_decision()
>
> Max Kellermann <max.kellermann@ionos.com>
> fs/netfs/fscache_cookie: add missing "n_accesses" check
>
> Janne Grunau <j@jannau.net>
> wifi: brcmfmac: cfg80211: Handle SSID based pmksa deletion
>
> Long Li <longli@microsoft.com>
> net: mana: Fix doorbell out of order violation and avoid unnecessary doorbell rings
>
> Hans de Goede <hdegoede@redhat.com>
> media: atomisp: Fix streaming no longer working on BYT / ISP2400 devices
>
> Haiyang Zhang <haiyangz@microsoft.com>
> net: mana: Fix RX buf alloc_size alignment and atomic op panic
>
> Yu Kuai <yukuai3@huawei.com>
> md/raid1: Fix data corruption for degraded array with slow disk
>
> David Hildenbrand <david@redhat.com>
> mm/hugetlb: fix hugetlb vs. core-mm PT locking
>
> Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> mm: fix endless reclaim on machines with unaccepted memory
>
> Dan Carpenter <dan.carpenter@linaro.org>
> rtla/osnoise: Prevent NULL dereference in error handling
>
> Pedro Falcato <pedro.falcato@gmail.com>
> mseal: fix is_madv_discard()
>
> Kyle Huey <me@kylehuey.com>
> perf/bpf: Don't call bpf_overflow_handler() for tracing events
>
> Steven Rostedt <rostedt@goodmis.org>
> tracing: Return from tracing_buffers_read() if the file has been closed
>
> Andi Shyti <andi.shyti@kernel.org>
> i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume
>
> Al Viro <viro@zeniv.linux.org.uk>
> fix bitmap corruption on close_range() with CLOSE_RANGE_UNSHARE
>
> Zhihao Cheng <chengzhihao1@huawei.com>
> vfs: Don't evict inode under the inode lru traversing context
>
> Mikulas Patocka <mpatocka@redhat.com>
> dm persistent data: fix memory allocation failure
>
> Khazhismel Kumykov <khazhy@google.com>
> dm resume: don't return EINVAL when signalled
>
> Haibo Xu <haibo1.xu@intel.com>
> arm64: ACPI: NUMA: initialize all values of acpi_early_node_map to NUMA_NO_NODE
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ACPI: EC: Evaluate _REG outside the EC scope more carefully
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ACPICA: Add a depth argument to acpi_execute_reg_methods()
>
> Breno Leitao <leitao@debian.org>
> i2c: tegra: Do not mark ACPI devices as irq safe
>
> Steve French <stfrench@microsoft.com>
> smb3: fix lock breakage for cached writes
>
> Celeste Liu <coelacanthushex@gmail.com>
> riscv: entry: always initialize regs->a0 to -ENOSYS
>
> Nam Cao <namcao@linutronix.de>
> riscv: change XIP's kernel_map.size to be size of the entire kernel
>
> David Gstir <david@sigma-star.at>
> KEYS: trusted: dcp: fix leak of blob encryption key
>
> David Gstir <david@sigma-star.at>
> KEYS: trusted: fix DCP blob payload length assignment
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> thermal: gov_bang_bang: Call __thermal_cdev_update() directly
>
> Michael Mueller <mimu@linux.ibm.com>
> KVM: s390: fix validity interception issue when gisa is switched off
>
> Stefan Haberland <sth@linux.ibm.com>
> s390/dasd: fix error recovery leading to data corruption on ESE devices
>
> Takashi Iwai <tiwai@suse.de>
> ALSA: timer: Relax start tick time check for slave timer elements
>
> Baojun Xu <baojun.xu@ti.com>
> ALSA: hda/tas2781: fix wrong calibrated data order
>
> Mika Westerberg <mika.westerberg@linux.intel.com>
> thunderbolt: Mark XDomain as unplugged when router is removed
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
> xhci: Fix Panther point NULL pointer deref at full-speed re-enumeration
>
> Marc Zyngier <maz@kernel.org>
> usb: xhci: Check for xhci->interrupters being allocated in xhci_mem_clearup()
>
> Hans de Goede <hdegoede@redhat.com>
> usb: misc: ljca: Add Lunar Lake ljca GPIO HID to ljca_gpio_hids[]
>
> Juan Jos� Arboleda <soyjuanarbol@gmail.com>
> ALSA: usb-audio: Support Yamaha P-125 quirk entry
>
> Lianqin Hu <hulianqin@vivo.com>
> ALSA: usb-audio: Add delay quirk for VIVO USB-C-XE710 HEADSET
>
> Eli Billauer <eli.billauer@gmail.com>
> char: xillybus: Check USB endpoints when probing device
>
> Eli Billauer <eli.billauer@gmail.com>
> char: xillybus: Refine workqueue handling
>
> Eli Billauer <eli.billauer@gmail.com>
> char: xillybus: Don't destroy workqueue from work item running on it
>
> Jann Horn <jannh@google.com>
> fuse: Initialize beyond-EOF page contents before setting uptodate
>
> David Howells <dhowells@redhat.com>
> netfs, ceph: Revert "netfs: Remove deprecated use of PG_private_2 as a second writeback flag"
>
> Paul Moore <paul@paul-moore.com>
> selinux: revert our use of vma_is_initial_heap()
>
> Xu Yang <xu.yang_2@nxp.com>
> Revert "usb: typec: tcpm: clear pd_event queue in PORT_RESET"
>
> Griffin Kroah-Hartman <griffin@kroah.com>
> Revert "serial: 8250_omap: Set the console genpd always on if no console suspend"
>
> Griffin Kroah-Hartman <griffin@kroah.com>
> Revert "misc: fastrpc: Restrict untrusted app to attach to privileged PD"
>
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Revert "ACPI: EC: Evaluate orphan _REG under EC device"
>
> Mathieu Othacehe <m.othacehe@gmail.com>
> tty: atmel_serial: use the correct RTS flag.
>
> Peng Fan <peng.fan@nxp.com>
> tty: serial: fsl_lpuart: mark last busy before uart_add_one_port
>
> Masahiro Yamada <masahiroy@kernel.org>
> tty: vt: conmakehash: remove non-portable code printing comment header
>
>
> -------------
>
> Diffstat:
>
> Documentation/ABI/testing/sysfs-devices-system-cpu |   3 +-
> Makefile                                           |   6 +-
> arch/arm64/kernel/acpi_numa.c                      |   2 +-
> arch/arm64/kernel/setup.c                          |   3 -
> arch/arm64/kernel/smp.c                            |   2 +
> arch/arm64/kvm/sys_regs.c                          |   6 +
> arch/arm64/kvm/vgic/vgic-debug.c                   |   2 +-
> arch/arm64/kvm/vgic/vgic.h                         |   7 +
> arch/mips/kernel/cpu-probe.c                       |   4 +
> arch/powerpc/include/asm/topology.h                |  13 ++
> arch/riscv/kernel/traps.c                          |   4 +-
> arch/riscv/mm/init.c                               |   4 +-
> arch/s390/boot/startup.c                           |  55 ++++---
> arch/s390/boot/vmem.c                              |  14 +-
> arch/s390/boot/vmlinux.lds.S                       |   7 +-
> arch/s390/include/asm/page.h                       |   3 +-
> arch/s390/include/asm/uv.h                         |   5 +-
> arch/s390/kernel/vmlinux.lds.S                     |   2 +-
> arch/s390/kvm/kvm-s390.h                           |   7 +-
> arch/s390/tools/relocs.c                           |   2 +-
> block/blk-mq-tag.c                                 |   5 +-
> drivers/acpi/acpica/acevents.h                     |   6 +-
> drivers/acpi/acpica/evregion.c                     |  12 +-
> drivers/acpi/acpica/evxfregn.c                     |  64 +-------
> drivers/acpi/ec.c                                  |  14 +-
> drivers/acpi/internal.h                            |   1 +
> drivers/acpi/scan.c                                |   2 +
> drivers/acpi/video_detect.c                        |  22 +++
> drivers/ata/pata_macio.c                           |  23 ++-
> drivers/atm/idt77252.c                             |   9 +-
> drivers/bluetooth/btintel.c                        |  10 --
> drivers/bluetooth/btintel_pcie.c                   |   3 -
> drivers/bluetooth/btmtksdio.c                      |   3 -
> drivers/bluetooth/btrtl.c                          |   1 -
> drivers/bluetooth/btusb.c                          |   4 +-
> drivers/bluetooth/hci_qca.c                        |   4 +-
> drivers/bluetooth/hci_vhci.c                       |   2 -
> drivers/char/xillybus/xillyusb.c                   |  42 ++++-
> drivers/gpio/gpio-mlxbf3.c                         |  14 ++
> drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   3 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |   8 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |   3 +
> drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            |  53 +++---
> drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   1 +
> drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   4 +-
> drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |  63 ++++++-
> drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h           |   7 +-
> drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c           |   1 +
> drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |  18 +-
> drivers/gpu/drm/amd/amdgpu/soc15d.h                |   6 +
> drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  32 +++-
> .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |   4 +-
> .../display/dc/resource/dcn321/dcn321_resource.c   |   3 +
> drivers/gpu/drm/i915/display/intel_dp_hdcp.c       |   4 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   4 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   4 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_kms.h            |  14 +-
> drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |  20 ++-
> drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   2 +
> drivers/gpu/drm/msm/dp/dp_panel.c                  |  19 ++-
> drivers/gpu/drm/msm/msm_mdss.c                     |   2 +-
> drivers/gpu/drm/nouveau/nvkm/core/firmware.c       |   9 +-
> drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |   6 +
> drivers/gpu/drm/v3d/v3d_sched.c                    |  14 +-
> drivers/gpu/drm/xe/display/xe_display.c            |   6 +-
> drivers/gpu/drm/xe/xe_device.c                     |   4 +-
> drivers/gpu/drm/xe/xe_exec_queue.c                 |  19 ---
> drivers/gpu/drm/xe/xe_exec_queue_types.h           |  10 --
> drivers/gpu/drm/xe/xe_gt_pagefault.c               |  18 +-
> drivers/gpu/drm/xe/xe_guc_submit.c                 |   8 +-
> drivers/gpu/drm/xe/xe_hw_fence.c                   |  59 +++++--
> drivers/gpu/drm/xe/xe_hw_fence.h                   |   7 +-
> drivers/gpu/drm/xe/xe_lrc.c                        |  48 +++++-
> drivers/gpu/drm/xe/xe_lrc.h                        |   3 +
> drivers/gpu/drm/xe/xe_mmio.c                       |  41 ++++-
> drivers/gpu/drm/xe/xe_mmio.h                       |   2 +-
> drivers/gpu/drm/xe/xe_ring_ops.c                   |  22 +--
> drivers/gpu/drm/xe/xe_sched_job.c                  | 182 ++++++++++++---------
> drivers/gpu/drm/xe/xe_sched_job.h                  |   7 +-
> drivers/gpu/drm/xe/xe_sched_job_types.h            |  20 ++-
> drivers/gpu/drm/xe/xe_trace.h                      |  11 +-
> drivers/hid/wacom_wac.c                            |   4 +-
> drivers/i2c/busses/i2c-qcom-geni.c                 |   4 +-
> drivers/i2c/busses/i2c-tegra.c                     |   4 +-
> drivers/input/input-mt.c                           |   3 +
> drivers/input/serio/i8042-acpipnpio.h              |  20 +--
> drivers/input/serio/i8042.c                        |  10 +-
> drivers/iommu/io-pgfault.c                         |   1 +
> drivers/iommu/iommufd/device.c                     |   2 +-
> drivers/md/dm-ioctl.c                              |  22 ++-
> drivers/md/dm.c                                    |   4 +-
> drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
> drivers/md/raid1.c                                 |  14 +-
> drivers/misc/fastrpc.c                             |  22 +--
> drivers/mmc/core/mmc_test.c                        |   9 +-
> drivers/mmc/host/dw_mmc.c                          |   8 +
> drivers/mmc/host/mtk-sd.c                          |   8 +-
> drivers/net/bonding/bond_main.c                    |  21 +--
> drivers/net/bonding/bond_options.c                 |   2 +-
> drivers/net/dsa/microchip/ksz_ptp.c                |   5 +-
> drivers/net/dsa/mv88e6xxx/global1_atu.c            |   3 +-
> drivers/net/dsa/ocelot/felix.c                     |  11 ++
> drivers/net/dsa/vitesse-vsc73xx-core.c             |  45 ++++-
> drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   5 -
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   3 +-
> .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   7 +-
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +
> .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  28 +++-
> .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   3 +
> .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
> .../net/ethernet/intel/ice/devlink/devlink_port.c  |   4 +-
> drivers/net/ethernet/intel/ice/ice_base.c          |  21 ++-
> drivers/net/ethernet/intel/ice/ice_txrx.c          |  47 +-----
> drivers/net/ethernet/intel/igb/igb_main.c          |   1 +
> drivers/net/ethernet/intel/igc/igc_defines.h       |   6 +
> drivers/net/ethernet/intel/igc/igc_main.c          |   8 +-
> drivers/net/ethernet/intel/igc/igc_tsn.c           |  76 +++++++--
> drivers/net/ethernet/intel/igc/igc_tsn.h           |   1 +
> .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  23 ++-
> drivers/net/ethernet/mediatek/mtk_wed.c            |   6 +-
> .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   2 +
> .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   2 +-
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  15 +-
> .../mellanox/mlx5/core/lib/ipsec_fs_roce.c         |   6 +-
> drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c   |  18 +-
> .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |   8 +
> .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |  10 ++
> .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   2 +
> .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c   |  50 +++++-
> drivers/net/ethernet/microsoft/mana/mana_en.c      |  28 +++-
> drivers/net/ethernet/mscc/ocelot.c                 |  91 ++++++++++-
> drivers/net/ethernet/mscc/ocelot_fdma.c            |   3 +-
> drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   4 +
> drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c      |   8 +-
> drivers/net/ethernet/xilinx/xilinx_axienet.h       |  17 +-
> drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  25 +--
> drivers/net/gtp.c                                  |   3 +
> drivers/net/wireless/ath/ath12k/dp_tx.c            |  72 ++++++++
> drivers/net/wireless/ath/ath12k/hw.c               |   6 +
> drivers/net/wireless/ath/ath12k/hw.h               |   4 +
> drivers/net/wireless/ath/ath12k/mac.c              |   1 +
> .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  13 +-
> drivers/nvme/host/core.c                           |   2 +-
> drivers/platform/surface/aggregator/controller.c   |   3 +-
> drivers/platform/x86/dell/Kconfig                  |   1 +
> drivers/platform/x86/dell/dell-uart-backlight.c    |   8 +
> .../x86/intel/speed_select_if/isst_tpmi_core.c     |   3 +-
> drivers/pmdomain/imx/imx93-pd.c                    |   5 +-
> drivers/pmdomain/imx/scu-pd.c                      |   5 -
> drivers/s390/block/dasd.c                          |  36 ++--
> drivers/s390/block/dasd_3990_erp.c                 |  10 +-
> drivers/s390/block/dasd_eckd.c                     |  57 +++----
> drivers/s390/block/dasd_genhd.c                    |   1 -
> drivers/s390/block/dasd_int.h                      |   2 +-
> drivers/s390/crypto/ap_bus.c                       |   7 +-
> drivers/spi/spi-cadence-quadspi.c                  |  14 +-
> .../media/atomisp/pci/ia_css_stream_public.h       |   8 +-
> .../staging/media/atomisp/pci/sh_css_internal.h    |  19 ++-
> drivers/thermal/gov_bang_bang.c                    |  91 ++++++++---
> drivers/thermal/thermal_core.c                     |   3 +-
> drivers/thermal/thermal_debugfs.c                  |   6 +-
> drivers/thermal/thermal_of.c                       |  23 ++-
> drivers/thunderbolt/switch.c                       |   1 +
> drivers/tty/serial/8250/8250_omap.c                |  33 +---
> drivers/tty/serial/atmel_serial.c                  |   2 +-
> drivers/tty/serial/fsl_lpuart.c                    |   1 +
> drivers/tty/vt/conmakehash.c                       |  12 +-
> drivers/usb/host/xhci-mem.c                        |   2 +-
> drivers/usb/host/xhci.c                            |   8 +-
> drivers/usb/misc/usb-ljca.c                        |   1 +
> drivers/usb/typec/tcpm/tcpm.c                      |   1 -
> fs/9p/vfs_addr.c                                   |   3 +-
> fs/afs/file.c                                      |   3 +-
> fs/btrfs/delayed-ref.c                             |  67 ++++++++
> fs/btrfs/delayed-ref.h                             |   2 +
> fs/btrfs/extent-tree.c                             |  51 +++++-
> fs/btrfs/extent_io.c                               |  14 +-
> fs/btrfs/extent_map.c                              |  22 +--
> fs/btrfs/free-space-cache.c                        |  14 +-
> fs/btrfs/send.c                                    |  52 ++++--
> fs/btrfs/super.c                                   |  18 +-
> fs/btrfs/tree-checker.c                            |  74 ++++++++-
> fs/ceph/addr.c                                     |  25 ++-
> fs/file.c                                          |  28 ++--
> fs/fuse/dev.c                                      |   6 +-
> fs/inode.c                                         |  39 ++++-
> fs/libfs.c                                         |  35 ++--
> fs/locks.c                                         |   2 +-
> fs/netfs/buffered_read.c                           |   8 +-
> fs/netfs/buffered_write.c                          |   2 +-
> fs/netfs/fscache_cookie.c                          |   4 +
> fs/netfs/io.c                                      | 161 +++++++++++++++++-
> fs/nfs/fscache.c                                   |   3 +-
> fs/smb/client/cifsglob.h                           |  17 +-
> fs/smb/client/file.c                               |  58 +++++--
> fs/smb/client/reparse.c                            |  11 +-
> fs/smb/client/smb1ops.c                            |   2 +-
> fs/smb/client/smb2ops.c                            |  42 ++++-
> fs/smb/client/smb2pdu.c                            |  40 ++++-
> fs/smb/client/trace.h                              |  55 ++++++-
> fs/smb/client/transport.c                          |   8 +-
> fs/smb/server/connection.c                         |  34 +++-
> fs/smb/server/connection.h                         |   3 +-
> fs/smb/server/mgmt/user_session.c                  |   8 +
> fs/smb/server/smb2pdu.c                            |   5 +-
> include/acpi/acpixf.h                              |   5 +-
> include/acpi/video.h                               |   1 +
> include/asm-generic/vmlinux.lds.h                  |  19 ---
> include/linux/bitmap.h                             |  12 ++
> include/linux/bpf_verifier.h                       |   4 +-
> include/linux/dsa/ocelot.h                         |  47 ++++++
> include/linux/fs.h                                 |   5 +
> include/linux/hugetlb.h                            |  33 +++-
> include/linux/io_uring_types.h                     |   2 +-
> include/linux/mm.h                                 |  11 ++
> include/linux/panic.h                              |   1 +
> include/linux/pgalloc_tag.h                        |  13 ++
> include/linux/thermal.h                            |   1 +
> include/net/af_vsock.h                             |   4 +
> include/net/bluetooth/hci.h                        |  17 +-
> include/net/bluetooth/hci_core.h                   |   2 +-
> include/net/kcm.h                                  |   1 +
> include/net/mana/mana.h                            |   1 +
> include/scsi/scsi_cmnd.h                           |   2 +-
> include/soc/mscc/ocelot.h                          |  12 +-
> include/trace/events/netfs.h                       |   1 +
> include/uapi/misc/fastrpc.h                        |   3 -
> init/Kconfig                                       |  25 +--
> io_uring/io_uring.h                                |   2 +-
> io_uring/kbuf.c                                    |   9 +-
> io_uring/napi.c                                    |  50 +++---
> io_uring/napi.h                                    |   2 +-
> kernel/bpf/verifier.c                              |   5 +-
> kernel/cgroup/cpuset.c                             |   5 +-
> kernel/cpu.c                                       |  12 +-
> kernel/events/core.c                               |   3 +-
> kernel/kallsyms.c                                  |  60 +------
> kernel/kallsyms_internal.h                         |   6 -
> kernel/kallsyms_selftest.c                         |  22 +--
> kernel/panic.c                                     |   8 +-
> kernel/printk/printk.c                             |   2 +-
> kernel/trace/trace.c                               |   2 +-
> kernel/vmcore_info.c                               |   4 -
> kernel/workqueue.c                                 |  47 +++---
> mm/huge_memory.c                                   |  29 ++--
> mm/memcontrol.c                                    |   7 +-
> mm/memory-failure.c                                |  20 ++-
> mm/memory.c                                        |  33 ++--
> mm/mm_init.c                                       |  12 +-
> mm/mseal.c                                         |  14 +-
> mm/page_alloc.c                                    |  51 +++---
> mm/vmalloc.c                                       |  11 +-
> net/bluetooth/hci_core.c                           |  19 +--
> net/bluetooth/hci_event.c                          |   2 +-
> net/bluetooth/mgmt.c                               |   4 +
> net/bluetooth/smp.c                                | 146 ++++++++---------
> net/bridge/br_netfilter_hooks.c                    |   6 +-
> net/dsa/tag_ocelot.c                               |  37 +----
> net/ipv4/tcp_input.c                               |  28 ++--
> net/ipv4/tcp_ipv4.c                                |  14 ++
> net/ipv4/udp_offload.c                             |   3 +-
> net/ipv6/ip6_output.c                              |  10 ++
> net/ipv6/ip6_tunnel.c                              |  12 +-
> net/ipv6/netfilter/nf_conntrack_reasm.c            |   4 +
> net/iucv/iucv.c                                    |   4 +-
> net/kcm/kcmsock.c                                  |   4 +
> net/mctp/test/route-test.c                         |   2 +-
> net/mptcp/diag.c                                   |   2 +-
> net/mptcp/pm.c                                     |  13 --
> net/mptcp/pm_netlink.c                             | 142 ++++++++++------
> net/mptcp/protocol.h                               |   3 -
> net/netfilter/nf_flow_table_inet.c                 |   3 +
> net/netfilter/nf_flow_table_ip.c                   |   3 +
> net/netfilter/nf_flow_table_offload.c              |   2 +-
> net/netfilter/nf_tables_api.c                      | 163 ++++++++++++------
> net/netfilter/nfnetlink.c                          |   5 +-
> net/netfilter/nfnetlink_queue.c                    |  35 +++-
> net/netfilter/nft_counter.c                        |   9 +-
> net/openvswitch/datapath.c                         |   2 +-
> net/sched/sch_netem.c                              |  47 ++++--
> net/vmw_vsock/af_vsock.c                           |  50 +++---
> net/vmw_vsock/vsock_bpf.c                          |   4 +-
> scripts/kallsyms.c                                 | 109 ++++--------
> scripts/link-vmlinux.sh                            | 106 ++++++------
> scripts/rust_is_available.sh                       |   6 +-
> security/keys/trusted-keys/trusted_dcp.c           |  35 ++--
> security/selinux/avc.c                             |   8 +-
> security/selinux/hooks.c                           |  12 +-
> sound/core/timer.c                                 |   2 +-
> sound/pci/hda/patch_realtek.c                      |   1 -
> sound/pci/hda/tas2781_hda_i2c.c                    |  14 +-
> sound/usb/quirks-table.h                           |   1 +
> sound/usb/quirks.c                                 |   2 +
> tools/perf/tests/vmlinux-kallsyms.c                |   1 -
> tools/testing/selftests/bpf/progs/iters.c          |  54 ++++++
> tools/testing/selftests/core/close_range_test.c    |  35 ++++
> .../selftests/drivers/net/mlxsw/ethtool_lanes.sh   |   3 +-
> tools/testing/selftests/mm/Makefile                |   2 +
> tools/testing/selftests/mm/run_vmtests.sh          |   3 +
> tools/testing/selftests/net/af_unix/msg_oob.c      |   2 +-
> tools/testing/selftests/net/lib.sh                 |  11 +-
> tools/testing/selftests/net/mptcp/mptcp_join.sh    |  28 +++-
> tools/testing/selftests/net/udpgro.sh              |  53 +++---
> tools/testing/selftests/tc-testing/tdc.py          |   1 -
> tools/tracing/rtla/src/osnoise_top.c               |  11 +-
> 305 files changed, 3476 insertions(+), 1744 deletions(-)

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
