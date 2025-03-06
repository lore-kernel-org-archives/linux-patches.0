Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC05D299;
	Thu,  6 Mar 2025 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741274440; cv=none; b=Y781qFzlN/ZyMxiyPprMs6jkOzFKfCh4ZI6v6ydlmAMhquy8ZJQfbMml1Txj+PcWjobQ4XGt2g3VtwGLMKWutNOA+8IkjSXiJDXvdoHkNZd+kec6xKM/gWLk4Nqwo+fBt1mYJDWA3Jwq51YP+Xvf3mMEY0QuRbSEnLSg7oaIRlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741274440; c=relaxed/simple;
	bh=tUCEc0Xs5wtCJc6N8JqgrAqETxSV5Xj0Jyokpc5POF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PHA3uZToQyNqHxjCGMzRbDhp7svQO05B9nLAvJYkjytxBCsZuNlZKpBE+b2r2dvlWWQubbXVl4AgqAS96zImKtWg+MszUBZ42/i7L89n5XjP2xr/qcIDZ4p943H2gb8K1PWmiCEXwSGLM25ZNN3WuLjPNL2qerXJ42SF7thLm+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhNiJW8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhNiJW8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D59C4CEE0;
	Thu,  6 Mar 2025 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741274439;
	bh=tUCEc0Xs5wtCJc6N8JqgrAqETxSV5Xj0Jyokpc5POF8=;
	h=From:To:Cc:Subject:Date:From;
	b=FhNiJW8bZqJOqs8IntnpmMRvy+0T26v4ayB/faFrcHnhIr2vrgbJ71yQPRqxwKYzG
	 l74gqYyRfII41qI+HVERzRkFZEJ/SXbcE5HXZgli+gDDzcQum8FSmLw+IkkkkstFQa
	 qHDGOGuESYdUw23xQc9nF8IzRISMrirY2AraRw/U=
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
Subject: [PATCH 6.1 000/161] 6.1.130-rc2 review
Date: Thu,  6 Mar 2025 16:20:35 +0100
Message-ID: <20250306151414.484343862@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.130-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.130-rc2
X-KernelTest-Deadline: 2025-03-08T15:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.130 release.
There are 161 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.130-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.130-rc2

Fullway Wang <fullwaywang@outlook.com>
    media: mtk-vcodec: potential null pointer deference in SCP

Quang Le <quanglex97@gmail.com>
    pfifo_tail_enqueue: Drop new packet when sch->limit == 0

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check the inode number is not the invalid value of zero

Jiaxun Yang <jiaxun.yang@flygoat.com>
    mm/memory: Use exception ip to search exception tables

Jiaxun Yang <jiaxun.yang@flygoat.com>
    ptrace: Introduce exception_ip arch hook

Thomas Gleixner <tglx@linutronix.de>
    intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly

chr[] <chris@rudorff.com>
    amdgpu/pm/legacy: fix suspend/resume issues

Sohaib Nadeem <sohaib.nadeem@amd.com>
    drm/amd/display: fixed integer types and null check locations

Andreas Schwab <schwab@suse.de>
    riscv/futex: sign extend compare value in atomic cmpxchg

Thomas Gleixner <tglx@linutronix.de>
    sched/core: Prevent rescheduling when interrupts are disabled

Ard Biesheuvel <ardb@kernel.org>
    vmlinux.lds: Ensure that const vars with relocations are mapped R/O

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: reset when MPTCP opts are dropped after join

Paolo Abeni <pabeni@redhat.com>
    mptcp: always handle address removal under msk socket lock

Kaustabh Chakraborty <kauschluss@disroot.org>
    phy: exynos5-usbdrd: fix MPLL_MULTIPLIER and SSC_REFCLKSEL masks in refclk

BH Hsieh <bhsieh@nvidia.com>
    phy: tegra: xusb: reset VBUS & ID OVERRIDE

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the off-by-one issue in enetc_map_tx_tso_buffs()

Wei Fang <wei.fang@nxp.com>
    net: enetc: correct the xdp_tx statistics

Wei Fang <wei.fang@nxp.com>
    net: enetc: update UDP checksum when updating originTimestamp field

Wei Fang <wei.fang@nxp.com>
    net: enetc: keep track of correct Tx BD count in enetc_map_tx_tso_buffs()

Wei Fang <wei.fang@nxp.com>
    net: enetc: fix the off-by-one issue in enetc_map_tx_buffs()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    usbnet: gl620a: fix endpoint checking in genelink_bind()

Tyrone Ting <kfting@nuvoton.com>
    i2c: npcm: disable interrupt enable bit before devm_request_irq

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix HPD after gpu reset

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Disable PSR-SU on eDP panels

Kan Liang <kan.liang@linux.intel.com>
    perf/core: Fix low freq setting via IOC_PERIOD

Kan Liang <kan.liang@linux.intel.com>
    perf/x86: Fix low freqency setting issue

Dmitry Panchenko <dmitry@d-systems.ee>
    ALSA: usb-audio: Re-add sample rate quirk for Pioneer DJM-900NXS2

Nikolay Kuratov <kniv@yandex-team.ru>
    ftrace: Avoid potential division by zero in function_stat_show()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix bad hist from corrupting named_triggers list

Chukun Pan <amadeus@jmu.edu.cn>
    phy: rockchip: naneng-combphy: compatible reset with old DT

Russell Senior <russell@personaltelco.net>
    x86/CPU: Fix warm boot hang regression on AMD SC1100 SoC systems

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: save msg_control for compat

Tong Tiangen <tongtiangen@huawei.com>
    uprobes: Reject the shared zeropage in uprobe_write_opcode()

David Howells <dhowells@redhat.com>
    mm: Don't pin ZERO_PAGE in pin_user_pages()

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in rpl lwt

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: rpl_iptunnel: mitigate 2-realloc issue

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: fix dst ref loop on input in seg6 lwt

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: seg6_iptunnel: mitigate 2-realloc issue

Justin Iurman <justin.iurman@uliege.be>
    include: net: add static inline dst_dev_overhead() to dst.h

Shay Drory <shayd@nvidia.com>
    net/mlx5: IRQ, Fix null string in debug print

Harshal Chaudhari <hchaudhari@marvell.com>
    net: mvpp2: cls: Fixed Non IP flow, with vlan tag flow defination.

Mohammad Heib <mheib@redhat.com>
    net: Clear old fragment checksum value in napi_reuse_skb

Wang Hai <wanghai38@huawei.com>
    tcp: Defer ts_recent changes until req is owned

Philo Lu <lulie@linux.alibaba.com>
    ipvs: Always clear ipvs_property flag in skb_scrub_packet()

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    ASoC: es8328: fix route from DAC to output

Sean Anderson <sean.anderson@linux.dev>
    net: cadence: macb: Synchronize stats calculations

Eric Dumazet <edumazet@google.com>
    ipvlan: ensure network headers are in skb linear part

Guillaume Nault <gnault@redhat.com>
    ipvlan: Prepare ipvlan_process_v4_outbound() to future .flowi4_tos conversion.

Guillaume Nault <gnault@redhat.com>
    ipv4: Convert ip_route_input() to dscp_t.

Guillaume Nault <gnault@redhat.com>
    ipv4: Convert icmp_route_lookup() to dscp_t.

Ido Schimmel <idosch@nvidia.com>
    ipvlan: Unmask upper DSCP bits in ipvlan_process_v4_outbound()

Ido Schimmel <idosch@nvidia.com>
    ipv4: icmp: Unmask upper DSCP bits in icmp_route_lookup()

Ido Schimmel <idosch@nvidia.com>
    ipv4: icmp: Pass full DS field to ip_route_input()

Peilin He <he.peilin@zte.com.cn>
    net/ipv4: add tracepoint for icmp_send

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    net: set the minimum for net_hotdata.netdev_budget_usecs

Ido Schimmel <idosch@nvidia.com>
    net: loopback: Avoid sending IP packets without an Ethernet header

David Howells <dhowells@redhat.com>
    afs: Fix the server_list to unuse a displaced server rather than putting it

David Howells <dhowells@redhat.com>
    afs: Make it possible to find the volumes that are using a server

Colin Ian King <colin.i.king@gmail.com>
    afs: remove variable nr_servers

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix L2CAP_ECRED_CONN_RSP response

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports

Arnd Bergmann <arnd@arndb.de>
    sunrpc: suppress warnings for unused procfs functions

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix bind QP error cleanup flow

Ye Bin <yebin10@huawei.com>
    scsi: core: Clear driver private data when retrying request

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Prevent looping due to rpc_signal_task() races

Stephen Brennan <stephen.s.brennan@oracle.com>
    SUNRPC: convert RPC_TASK_* constants to enum

Vasiliy Kovalev <kovalev@altlinux.org>
    ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up

Mark Zhang <markzhang@nvidia.com>
    IB/mlx5: Set and get correct qp_num for a DCT QP

Xin Long <lucien.xin@gmail.com>
    netfilter: allow exp not to be removed in nf_ct_find_expectation

Alexander Dahl <ada@thorsis.com>
    spi: atmel-quadspi: Fix wrong register value written to MR

Alexander Dahl <ada@thorsis.com>
    spi: atmel-quadspi: Avoid overwriting delay register settings

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix H264 multi stateless decoder smatch warning

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix bfqq uaf in bfq_limit_depth()

Paolo Valente <paolo.valente@linaro.org>
    block, bfq: split sync bfq_queues on a per-actuator basis

Patrick Bellasi <derkling@google.com>
    x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Do not add duplicate entries in subops manager ops

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ftrace: Correct preemption accounting for function tracing.

Komal Bajaj <quic_kbajaj@quicinc.com>
    EDAC/qcom: Correct interrupt enable register configuration

Haoxiang Li <haoxiang_li2024@163.com>
    smb: client: Add check for next_buffer in receive_encrypted_standard()

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix incorrect device in dma_unmap_single

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: use dma_map_resource for sdma address

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix error code in cadence_nand_init()

Ricardo Cañuelo Navarro <rcn@igalia.com>
    mm,madvise,hugetlb: check for 0-length range after end address adjustment

Christian Brauner <brauner@kernel.org>
    acct: block access to kernel internal filesystems

Christian Brauner <brauner@kernel.org>
    acct: perform last write from workqueue

John Veness <john-linux@pelago.org.uk>
    ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    ASoC: fsl_micfil: Enable default case in micfil_set_quality()

Haoxiang Li <haoxiang_li2024@163.com>
    nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    drop_monitor: fix incorrect initialization order

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix supplicant wait loop

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Make sure all planes in use by the joiner have their crtc included

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: Disable dither in phys encoder cleanup

Yan Zhai <yan@cloudflare.com>
    bpf: skip non exist keys in generic_map_lookup_batch

Caleb Sander Mateos <csander@purestorage.com>
    nvme/ioctl: add missing space in err message

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Don't leak bits_per_component into random DSC_ENC fields

David Hildenbrand <david@redhat.com>
    nouveau/svm: fix missing folio unlock + put after make_device_exclusive_range()

Andrey Vatoropin <a.vatoropin@crpt.ru>
    power: supply: da9150-fg: fix potential overflow

Jiayuan Chen <mrpre@163.com>
    bpf: Fix wrong copied_seq calculation

Jiayuan Chen <mrpre@163.com>
    strparser: Add read_sock callback

Shigeru Yoshida <syoshida@redhat.com>
    bpf, test_run: Fix use-after-free issue in eth_skb_pkt_type()

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    drm/rcar-du: dsi: Fix PHY lock bit check

Devarsh Thakkar <devarsht@ti.com>
    drm/tidss: Fix race condition while handling interrupt registers

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Add simple K2G manual reset

Sabrina Dubroca <sd@queasysnail.net>
    tcp: drop secpath at the same time as we currently drop dst

Nick Hu <nick.hu@sifive.com>
    net: axienet: Set mac_managed_pm

Breno Leitao <leitao@debian.org>
    arp: switch to dev_getbyhwaddr() in arp_req_set_public()

Breno Leitao <leitao@debian.org>
    net: Add non-RCU dev_getbyhwaddr() helper

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix port range key handling in BPF conversion

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix handling of mixed port and port-range keys

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Suppress list corruption splat in geneve_destroy_tunnels().

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Suppress list corruption splat in gtp_net_exit_batch_rtnl().

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Don't reference skb after sending to VIOS

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Add stat for tx direct vs tx batched

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Introduce send sub-crq direct

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Return error code on TX scrq flush fail

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ALSA: hda/cirrus: Correct the full scale volume set logic

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Fix use-after-free in geneve_find_dev().

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/code-patching: Fix KASAN hit by not flagging text patching area as VM_ALLOC

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Fixup ALC225 depop procedure

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/mm: Move __real_pte stubs into hash-4k.h

John Keeping <jkeeping@inmusicbrands.com>
    ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]

Jill Donahue <jilliandonahue58@gmail.com>
    USB: gadget: f_midi: f_midi_complete to call queue_work

Roy Luo <royluo@google.com>
    usb: gadget: core: flush gadget workqueue after device removal

Roy Luo <royluo@google.com>
    USB: gadget: core: create sysfs link between udc and gadget

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove dangling pointers

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Only save async fh if success

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Refactor iterators

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix crash during unbind if gpio unit is in use

Yang Yingliang <yangyingliang@huawei.com>
    media: Switch to use dev_err_probe() helper

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    soc/mediatek: mtk-devapc: Convert to platform remove callback returning void

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: mediatek: mtk-devapc: Fix leaking IO map on error paths

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    soc: mediatek: mtk-devapc: Switch to devm_clk_get_enabled()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Change to kvalloc() in eventlog/acpi.c

Eddie James <eajames@linux.ibm.com>
    tpm: Use managed allocation for bios event log

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: trim addresses to 8 digits

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Disable DSI display output by default

Igor Pylypiv <ipylypiv@google.com>
    scsi: core: Do not retry I/Os during depopulation

Douglas Gilbert <dgilbert@interlog.com>
    scsi: core: Handle depopulation and restoration in progress

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: renesas: rz-ssi: Add a check for negative sample_space

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-img: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-bdp: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    clk: mediatek: clk-mtk: Add dummy clock ops

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Fix poor RF performance for WCN6855

Cheng Jiang <quic_chejiang@quicinc.com>
    Bluetooth: qca: Update firmware-name to support board specific nvm

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Support downloading board id specific NVM for WCN7850

Bence Csókás <csokas.bence@prolan.hu>
    spi: atmel-qspi: Memory barriers after memory-mapped I/O

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Create `atmel_qspi_ops` to support newer SoC families

Yang Yingliang <yangyingliang@huawei.com>
    spi: atmel-quadspi: switch to use modern name

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: atmel-quadspi: Add support for configuring CS timing

Chen Ridong <chenridong@huawei.com>
    memcg: fix soft lockup in the OOM process

Carlos Galo <carlosgalo@google.com>
    mm: update mark_victim tracepoints fields

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: add 'sync_size' into struct md_bitmap_stats

Yu Kuai <yukuai3@huawei.com>
    md/md-cluster: fix spares warnings for __le64

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: replace md_bitmap_status() with a new helper md_bitmap_get_stats()

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings


-------------

Diffstat:

 Documentation/core-api/pin_user_pages.rst          |   6 +
 Documentation/networking/strparser.rst             |   9 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   1 +
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   4 +-
 arch/arm64/include/asm/mman.h                      |   9 +-
 arch/mips/include/asm/ptrace.h                     |   2 +
 arch/mips/kernel/ptrace.c                          |   7 +
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |  28 +++
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  26 ---
 arch/powerpc/lib/code-patching.c                   |   2 +-
 arch/riscv/include/asm/futex.h                     |   2 +-
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/events/core.c                             |   2 +-
 arch/x86/kernel/cpu/bugs.c                         |  20 ++-
 arch/x86/kernel/cpu/cyrix.c                        |   4 +-
 block/bfq-cgroup.c                                 |  97 +++++-----
 block/bfq-iosched.c                                | 195 ++++++++++++++-------
 block/bfq-iosched.h                                |  51 ++++--
 drivers/bluetooth/btqca.c                          | 110 +++++++++---
 drivers/char/tpm/eventlog/acpi.c                   |  16 +-
 drivers/char/tpm/eventlog/efi.c                    |  13 +-
 drivers/char/tpm/eventlog/of.c                     |   3 +-
 drivers/char/tpm/tpm-chip.c                        |   1 -
 drivers/clk/mediatek/clk-mt2701-bdp.c              |   1 +
 drivers/clk/mediatek/clk-mt2701-img.c              |   1 +
 drivers/clk/mediatek/clk-mt2701-vdec.c             |   1 +
 drivers/clk/mediatek/clk-mtk.c                     |  16 ++
 drivers/clk/mediatek/clk-mtk.h                     |  19 ++
 drivers/edac/qcom_edac.c                           |   4 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  14 ++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |  16 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |  25 ++-
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c     |   8 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  26 ++-
 drivers/gpu/drm/i915/display/intel_display.c       |  18 ++
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   3 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c         |   3 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   9 +-
 drivers/gpu/drm/rcar-du/rcar_mipi_dsi.c            |   2 +-
 drivers/gpu/drm/rcar-du/rcar_mipi_dsi_regs.h       |   1 -
 drivers/gpu/drm/tidss/tidss_dispc.c                |  22 ++-
 drivers/gpu/drm/tidss/tidss_irq.c                  |   2 +
 drivers/i2c/busses/i2c-npcm7xx.c                   |   7 +
 drivers/idle/intel_idle.c                          |   4 +
 drivers/infiniband/hw/mlx5/counters.c              |   8 +-
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +-
 drivers/md/md-bitmap.c                             |  34 ++--
 drivers/md/md-bitmap.h                             |   9 +-
 drivers/md/md-cluster.c                            |  34 ++--
 drivers/md/md.c                                    |  33 +++-
 drivers/media/cec/platform/stm32/stm32-cec.c       |   9 +-
 drivers/media/i2c/ad5820.c                         |  18 +-
 drivers/media/i2c/imx274.c                         |   5 +-
 drivers/media/i2c/tc358743.c                       |   9 +-
 drivers/media/platform/mediatek/mdp/mtk_mdp_comp.c |   5 +-
 .../platform/mediatek/vcodec/mtk_vcodec_fw_scp.c   |   2 +
 .../mediatek/vcodec/vdec/vdec_h264_req_multi_if.c  |   9 +-
 .../media/platform/samsung/exynos4-is/media-dev.c  |   4 +-
 drivers/media/platform/st/stm32/stm32-dcmi.c       |  27 +--
 drivers/media/platform/ti/omap3isp/isp.c           |   3 +-
 drivers/media/platform/xilinx/xilinx-csi2rxss.c    |   8 +-
 drivers/media/rc/gpio-ir-recv.c                    |  10 +-
 drivers/media/rc/gpio-ir-tx.c                      |   9 +-
 drivers/media/rc/ir-rx51.c                         |   9 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  99 +++++++++--
 drivers/media/usb/uvc/uvc_driver.c                 |  35 ++--
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 +
 drivers/media/usb/uvc/uvcvideo.h                   |  10 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |  42 +++--
 drivers/net/ethernet/cadence/macb.h                |   2 +
 drivers/net/ethernet/cadence/macb_main.c           |  12 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       | 100 ++++++++---
 drivers/net/ethernet/ibm/ibmvnic.c                 |  85 +++++++--
 drivers/net/ethernet/ibm/ibmvnic.h                 |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   1 +
 drivers/net/geneve.c                               |  16 +-
 drivers/net/gtp.c                                  |   5 -
 drivers/net/ipvlan/ipvlan_core.c                   |  24 ++-
 drivers/net/loopback.c                             |  14 ++
 drivers/net/usb/gl620a.c                           |   4 +-
 drivers/nvme/host/ioctl.c                          |   3 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |   5 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |  12 +-
 drivers/phy/tegra/xusb-tegra186.c                  |  11 ++
 drivers/power/supply/da9150-fg.c                   |   4 +-
 drivers/scsi/scsi_lib.c                            |  22 ++-
 drivers/scsi/sd.c                                  |   4 +
 drivers/soc/mediatek/mtk-devapc.c                  |  36 ++--
 drivers/spi/atmel-quadspi.c                        | 172 +++++++++++++-----
 drivers/tee/optee/supp.c                           |  35 +---
 drivers/usb/gadget/function/f_midi.c               |   2 +-
 drivers/usb/gadget/udc/core.c                      |  11 +-
 fs/afs/cell.c                                      |   1 +
 fs/afs/internal.h                                  |  23 ++-
 fs/afs/server.c                                    |   1 +
 fs/afs/server_list.c                               | 114 ++++++++++--
 fs/afs/vl_alias.c                                  |   2 +-
 fs/afs/volume.c                                    |  40 +++--
 fs/overlayfs/copy_up.c                             |   2 +-
 fs/smb/client/smb2ops.c                            |   4 +
 fs/squashfs/inode.c                                |   5 +-
 include/asm-generic/vmlinux.lds.h                  |   2 +-
 include/linux/mm.h                                 |  26 ++-
 include/linux/netdevice.h                          |   2 +
 include/linux/ptrace.h                             |   4 +
 include/linux/skmsg.h                              |   2 +
 include/linux/sunrpc/sched.h                       |  17 +-
 include/net/dst.h                                  |   9 +
 include/net/ip.h                                   |   5 +
 include/net/netfilter/nf_conntrack_expect.h        |   2 +-
 include/net/route.h                                |   5 +-
 include/net/strparser.h                            |   2 +
 include/net/tcp.h                                  |  22 +++
 include/trace/events/icmp.h                        |  67 +++++++
 include/trace/events/oom.h                         |  36 +++-
 include/trace/events/sunrpc.h                      |   3 +-
 io_uring/net.c                                     |   4 +-
 kernel/acct.c                                      | 134 ++++++++------
 kernel/bpf/syscall.c                               |  18 +-
 kernel/events/core.c                               |  17 +-
 kernel/events/uprobes.c                            |   5 +
 kernel/sched/core.c                                |   2 +-
 kernel/trace/ftrace.c                              |  30 ++--
 kernel/trace/trace_events_hist.c                   |  34 ++--
 kernel/trace/trace_functions.c                     |   6 +-
 mm/gup.c                                           |  31 +++-
 mm/madvise.c                                       |  11 +-
 mm/memcontrol.c                                    |   7 +-
 mm/memory.c                                        |   4 +-
 mm/oom_kill.c                                      |  14 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/bpf/test_run.c                                 |   5 +-
 net/bridge/br_netfilter_hooks.c                    |   8 +-
 net/core/dev.c                                     |  37 +++-
 net/core/drop_monitor.c                            |  39 ++---
 net/core/flow_dissector.c                          |  49 +++---
 net/core/gro.c                                     |   1 +
 net/core/skbuff.c                                  |   2 +-
 net/core/skmsg.c                                   |   7 +
 net/core/sysctl_net_core.c                         |   3 +-
 net/ipv4/arp.c                                     |   2 +-
 net/ipv4/icmp.c                                    |  24 +--
 net/ipv4/ip_options.c                              |   3 +-
 net/ipv4/tcp.c                                     |  29 ++-
 net/ipv4/tcp_bpf.c                                 |  36 ++++
 net/ipv4/tcp_fastopen.c                            |   4 +-
 net/ipv4/tcp_input.c                               |   8 +-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_minisocks.c                           |  10 +-
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/ipv6/rpl_iptunnel.c                            |  58 +++---
 net/ipv6/seg6_iptunnel.c                           |  97 ++++++----
 net/mptcp/pm_netlink.c                             |   5 -
 net/mptcp/subflow.c                                |  15 +-
 net/netfilter/nf_conntrack_core.c                  |   2 +-
 net/netfilter/nf_conntrack_expect.c                |   4 +-
 net/netfilter/nft_ct.c                             |   2 +
 net/sched/sch_fifo.c                               |   3 +
 net/strparser/strparser.c                          |  11 +-
 net/sunrpc/cache.c                                 |  10 +-
 net/sunrpc/sched.c                                 |   2 -
 sound/pci/hda/hda_codec.c                          |   4 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_cs8409-tables.c                |   6 +-
 sound/pci/hda/patch_cs8409.c                       |  20 ++-
 sound/pci/hda/patch_cs8409.h                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/es8328.c                          |  15 +-
 sound/soc/fsl/fsl_micfil.c                         |   2 +
 sound/soc/rockchip/rockchip_i2s_tdm.c              |   4 +-
 sound/soc/sh/rz-ssi.c                              |   2 +
 sound/usb/midi.c                                   |   2 +-
 sound/usb/quirks.c                                 |   1 +
 179 files changed, 2160 insertions(+), 955 deletions(-)


