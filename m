Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457F71ABEB5;
	Mon, 14 Oct 2024 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917405; cv=none; b=njEptvcJobw/UJrZg7zRtIO4wjeEdBKS6SGFze9G7sfetWyfPZEzbfpVG8OB/YraF2Lk0mfroYTNtDDbKbP/AZALLh1S79vhn1AtEq4sExY7H5FOomWgBicm6dp0R9wDm2iupfsxNNpEoMWaYMNFF/b6oQ07swdiEKfGDFgchV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917405; c=relaxed/simple;
	bh=lnPl+JFlteBXbnJ1bckfBTHrAsQ/CDi3mjhW503KO0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gcNSgAEE6dlgp60+7yJMmT//7Dahb/CUMXc4AfKZkZ3sGr0B9dPR6kgYouaPSA2QyZsWS5UStmh96KL0IkNnFTwX6x2/h4KHSOoYfIuHe1WpAgcoPNfHd49BKHsQJqmQhmwPu9y2Wo1ngTo7KUcYzwIsJwJt9a8h64MQHJcrx8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OimFpm0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OimFpm0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A21FC4CEC3;
	Mon, 14 Oct 2024 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917405;
	bh=lnPl+JFlteBXbnJ1bckfBTHrAsQ/CDi3mjhW503KO0o=;
	h=From:To:Cc:Subject:Date:From;
	b=OimFpm0SAABWyh2Psd4sQ8DyhK4pTkZvT5neWiTabT5tZcR41T6ErMwuC2FpG4xfz
	 jZ2mWrE+kz3t7gA+Syc+RE/bQP31w2N6fYOZzw8YTs+u5mZ2/d2JGSfn/eqxZMeoDF
	 RY5cQMEwHBSF5lBN+5UYN69bpHUMtd5U16SH/gLk=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.1 000/798] 6.1.113-rc1 review
Date: Mon, 14 Oct 2024 16:09:14 +0200
Message-ID: <20241014141217.941104064@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.113-rc1
X-KernelTest-Deadline: 2024-10-16T14:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.113 release.
There are 798 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.113-rc1

Jack Wang <jinpu.wang@ionos.com>
    Revert "iommu/vt-d: Retrieve IOMMU perfmon capability information"

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix uaf for accessing waker_bfqq after splitting

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf lock: Don't pass an ERR_PTR() directly to perf_session__delete()

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Restore TSO support

Patrick Roy <roypat@amazon.co.uk>
    secretmem: disable memfd_secret() if arch cannot set direct map

Frederic Weisbecker <frederic@kernel.org>
    kthread: unpark only parked kthread

Yonatan Maman <Ymaman@Nvidia.com>
    nouveau/dmem: Fix vulnerability in migrate_to_ram upon copy error

Kun(llfl) <llfl@linux.alibaba.com>
    device-dax: correct pgoff align in dax_set_mapping()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not remove closing subflows

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle consistently DSS corruption

Anatolij Gustschin <agust@denx.de>
    net: dsa: lan9303: ensure chip reset and wait for READY status

Anastasia Kovaleva <a.kovaleva@yadro.com>
    net: Fix an unsafe loop on the list

Ignat Korchagin <ignat@cloudflare.com>
    net: explicitly clear the sk pointer, when pf->create fails

Niklas Cassel <cassel@kernel.org>
    ata: libata: avoid superfluous disk spin down + spin up during hibernation

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fallback when MPTCP opts are dropped after 1st data

Daniel Palmer <daniel@0x0f.com>
    scsi: wd33c93: Don't use stale scsi_pointer value

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Stop the active perfmon before being destroyed

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Stop the active perfmon before being destroyed

SurajSonawane2415 <surajsonawane0215@gmail.com>
    hid: intel-ish-hid: Fix uninitialized variable 'rv' in ish_fw_xfer_direct_dma

John Keeping <jkeeping@inmusicbrands.com>
    usb: gadget: core: force synchronous registration

Icenowy Zheng <uwu@icenowy.me>
    usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip

Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
    usb: xhci: Fix problem with xhci resume from suspend

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: core: Stop processing of pending events if controller is halted

Oliver Neukum <oneukum@suse.com>
    Revert "usb: yurex: Replace snprintf() with the safer scnprintf() variant"

Wade Wang <wade.wang@hp.com>
    HID: plantronics: Workaround for an unexcepted opposite volume key

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Switch to device-managed dmam_alloc_coherent()

Sasha Levin <sashal@kernel.org>
    Revert "net: ibm/emac: allocate dummy net_device dynamically"

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (adt7470) Add missing dependency on REGMAP_I2C

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (adm9240) Add missing dependency on REGMAP_I2C

Guenter Roeck <linux@roeck-us.net>
    hwmon: (tmp513) Add missing dependency on REGMAP_I2C

Kenton Groombridge <concord@gentoo.org>
    wifi: mac80211: Avoid address calculations via out of bounds array indexing

Shay Drory <shayd@nvidia.com>
    net/mlx5: Always drain health in shutdown callback

He Lugang <helugang@uniontech.com>
    HID: multitouch: Add support for lenovo Y9000P Touchpad

Boqun Feng <boqun.feng@gmail.com>
    rust: macros: provide correct provenance when constructing THIS_MODULE

Eric Dumazet <edumazet@google.com>
    slip: make slhc_remember() more robust against malicious packets

Eric Dumazet <edumazet@google.com>
    ppp: fix ppp_async_encode() illegal access

Kuniyuki Iwashima <kuniyu@amazon.com>
    mctp: Handle error of rtnl_register_module().

Kuniyuki Iwashima <kuniyu@amazon.com>
    vxlan: Handle error of rtnl_register_module().

Kuniyuki Iwashima <kuniyu@amazon.com>
    rtnetlink: Add bulk registration helpers for rtnetlink message handlers.

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: add dcr_unmap to _remove

Breno Leitao <leitao@debian.org>
    net: ibm/emac: allocate dummy net_device dynamically

Florian Westphal <fw@strlen.de>
    netfilter: fib: check correct rtable in vrf setups

Florian Westphal <fw@strlen.de>
    netfilter: xtables: avoid NFPROTO_UNSPEC where needed

Xin Long <lucien.xin@gmail.com>
    sctp: ensure sk_state is set to CLOSED if hashing fails in sctp_listen_start

Filipe Manana <fdmanana@suse.com>
    btrfs: zoned: fix missing RCU locking in error message when loading zone info

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: fix wrong goto

Eric Dumazet <edumazet@google.com>
    net/sched: accept TCA_STAB only for root qdisc

Mohamed Khalfella <mkhalfella@purestorage.com>
    igb: Do not bring the device up after non-fatal error

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Fix macvlan leak by synchronizing access to mac_filter_hash

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix netif_is_ice() in Safe Mode

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Use devm_clk api to manage clock source

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Add the flush write to ensure the write complete.

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix jumbo frames on 10/100 ports

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: allow lower MTUs on BCM5325/5365

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix max MTU for BCM5325/BCM5365

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix max MTU for 1g switches

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix jumbo frame mtu check

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: ethernet: adi: adin1110: Fix some error handling path in adin1110_read_fifo()

Jakub Kicinski <kuba@kernel.org>
    Revert "net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled"

Zhang Rui <rui.zhang@intel.com>
    thermal: intel: int340x: processor: Fix warning during module unload

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int340x: processor_thermal: Set feature mask before proc_thermal_add

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: phy: bcm84881: Fix some error handling paths

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: FIX possible deadlock in rfcomm_sk_state_change

Kacper Ludwinski <kac.ludwinski@icloud.com>
    selftests: net: no_forwarding: fix VID for $swp2 in one_bridge_two_pvids() test

Andy Roulin <aroulin@nvidia.com>
    netfilter: br_netfilter: fix panic with metadata_dst skb

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_enter_recovery() to zero retrans_stamp when it's safe

Neal Cardwell <ncardwell@google.com>
    tcp: fix to allow timestamp undo if no retransmits were sent

Ingo van Lil <inguin@gmx.de>
    net: phy: dp83869: fix memory corruption when enabling fiber

Yanjun Zhang <zhangyanjun@cestc.cn>
    NFSv4: Prevent NULL-pointer dereference in nfs42_complete_copies()

Dan Carpenter <dan.carpenter@linaro.org>
    SUNRPC: Fix integer overflow in decode_rc_list()

Dave Ertman <david.m.ertman@intel.com>
    ice: fix VLAN replay after reset

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Mark filecache "down" if init fails

Val Packett <val@packett.cool>
    drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066

Sascha Hauer <s.hauer@pengutronix.de>
    drm/rockchip: vop: limit maximum resolution to hardware capabilities

Andrey Shumilin <shum.sdl@nppct.ru>
    fbdev: sisfb: Fix strbuf array overflow

Qianqiang Liu <qianqiang.liu@163.com>
    fbcon: Fix a NULL pointer dereference issue in fbcon_putcs

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointer before dereferencing se

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Ensure DA_ID handling completion before deleting an NPIV instance

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute

Riyan Dhiman <riyandhiman14@gmail.com>
    staging: vme_user: added bound check to geoid

Zhu Jun <zhujun2@cmss.chinamobile.com>
    tools/iio: Add memory allocation failure check for trigger_name

Philip Chen <philipchen@chromium.org>
    virtio_pmem: Check device status before requesting flush

Simon Horman <horms@kernel.org>
    netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Fix memleak in pci_acpi_scan_root()

Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
    comedi: ni_routing: tools: Check when the file could not be opened

Shawn Shao <shawn.shao@jaguarmicro.com>
    usb: dwc2: Adjust the timing of USB Driver Interrupt Registration in the Crashkernel Scenario

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: enable suspend interrupt after usb reset

Peng Fan <peng.fan@nxp.com>
    clk: imx: Remove CLK_SET_PARENT_GATE for DRAM mux for i.MX7D

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: Use imx specific hook for find_loaded_rsc_table

Yunke Cao <yunkec@chromium.org>
    media: videobuf2-core: clear memory related fields in __vb2_plane_dmabuf_put()

Ying Sun <sunying@isrc.iscas.ac.cn>
    riscv/kexec_file: Fix relocation type R_RISCV_ADD16 and R_RISCV_SUB16 unknown

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Enforce umem boundaries for explicit ODP page faults

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    ntb: ntb_hw_switchtec: Fix use after free vulnerability in switchtec_ntb_remove due to race condition

Jens Axboe <axboe@kernel.dk>
    io_uring: check if we need to reschedule during overflow flush

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Don't have MAX_PHYSMEM_BITS exceed phys_addr_t

Alex Williamson <alex.williamson@redhat.com>
    PCI: Mark Creative Labs EMU20k2 INTx masking as broken

Hans de Goede <hdegoede@redhat.com>
    i2c: i801: Use a different adapter-name for IDF adapters

Subramanian Ananthanarayanan <quic_skananth@quicinc.com>
    PCI: Add ACS quirk for Qualcomm SA8775P

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clk: bcm: bcm53573: fix OF node leak in init

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-srv: Avoid null pointer deref during path establishment

WangYuli <wangyuli@uniontech.com>
    PCI: Add function 0 DMA alias quirk for Glenfly Arise chip

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/mad: Improve handling of timed out WRs of mad agent

Daniel Jordan <daniel.m.jordan@oracle.com>
    ktest.pl: Avoid false positives with grub2 skip regex

Heiko Carstens <hca@linux.ibm.com>
    s390/traps: Handle early warnings gracefully

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Remove WARN_ON_ONCE statements

Wojciech Gładysz <wojciech.gladysz@infogain.com>
    ext4: nested locking for xattr inode

Jan Kara <jack@suse.cz>
    ext4: don't set SB_RDONLY after filesystem errors

Yonghong Song <yonghong.song@linux.dev>
    bpf, x64: Fix a jit convergence issue

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: Add cond_resched() to cmm_alloc/free_pages()

Heiko Carstens <hca@linux.ibm.com>
    s390/facility: Disable compile time optimization for decompressor code

Heiko Carstens <hca@linux.ibm.com>
    s390/boot: Compile all files with the same march flag

Tao Chen <chen.dylane@gmail.com>
    bpf: Check percpu map value size first

Mathias Krause <minipli@grsecurity.net>
    Input: synaptics-rmi4 - fix UAF of IRQ domain on driver removal

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: fix misc probe bugs

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Refactor enum_rstbl to suppress static checker

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix sparse warning in ni_fiemap

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do not call file_modified if collapse range failed

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix usage of __hci_cmd_sync_status

Benjamin Poirier <bpoirier@nvidia.com>
    selftests: net: Remove executable bits from library scripts

Aditya Gupta <adityag@linux.ibm.com>
    libsubcmd: Don't free the usage string

Yang Jihong <yangjihong1@huawei.com>
    perf sched: Move curr_pid and cpu_last_switched initialization to perf_sched__{lat|map|replay}()

Yang Jihong <yangjihong1@huawei.com>
    perf sched: Move curr_thread initialization to perf_sched__map()

Yang Jihong <yangjihong1@huawei.com>
    perf sched: Fix memory leak in perf_sched__map()

Yang Jihong <yangjihong1@huawei.com>
    perf sched: Move start_work_mutex and work_done_wait_mutex initialization to perf_sched__replay()

Ian Rogers <irogers@google.com>
    perf sched: Avoid large stack allocations

Ian Rogers <irogers@google.com>
    perf lock: Dynamically allocate lockhash_table

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix the kerneldoc of _xbc_exit()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have saved_cmdlines arrays all in one allocation

Rob Clark <robdclark@chromium.org>
    drm/crtc: fix uninitialized variable use even harder

Jean-Loïc Charroud <lagiraudiere+linux@free.fr>
    ALSA: hda/realtek: cs35l41: Fix device ID / model name

Jean-Loïc Charroud <lagiraudiere+linux@free.fr>
    ALSA: hda/realtek: cs35l41: Fix order and duplicates in quirks table

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Remove precision vsnprintf() check from print event

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Drop TSO support

Gabriel Krisman Bertazi <krisman@suse.de>
    unicode: Don't special case ignorable code points

Shiyang Ruan <ruansy.fnst@fujitsu.com>
    fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN

Oleksij Rempel <linux@rempel-privat.de>
    clk: imx6ul: fix "failed to get parent" error

Shiyang Ruan <ruansy.fnst@fujitsu.com>
    fsdax: dax_unshare_iter() should return a valid length

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix segfault when 'sym' sort key is not used

Haoran Zhang <wh1sper@zju.edu.cn>
    vhost/scsi: null-ptr-dereference in vhost_scsi_get_req()

Gao Xiang <xiang@kernel.org>
    erofs: fix incorrect symlink detection in fast symlink

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: set block size to the on-disk block size

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: avoid hardcoded blocksize for subpage block support

Gao Xiang <xiang@kernel.org>
    erofs: get rid of z_erofs_do_map_blocks() forward declaration

Gao Xiang <xiang@kernel.org>
    erofs: get rid of erofs_inode_datablocks()

Sumit Semwal <sumit.semwal@linaro.org>
    Revert "arm64: dts: qcom: sm8250: switch UFS QMP PHY to new style of bindings"

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Fix possible crash when unregistering a battery hook

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Simplify battery hook locking

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-sc8180x: Add GPLL9 support

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: add tally counter fields added with RTL8125

Colin Ian King <colin.i.king@gmail.com>
    r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"

David Virag <virag.david003@gmail.com>
    clk: samsung: exynos7885: Update CLKS_NR_FSYS after bindings fix

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clk: samsung: exynos7885: do not define number of clocks in bindings

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x

Manivannan Sadhasivam <mani@kernel.org>
    dt-bindings: clock: qcom: Add missing UFS QREF clocks

Udit Kumar <u-kumar1@ti.com>
    remoteproc: k3-r5: Delay notification of wakeup event

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Acquire mailbox handle during probe routine

Umang Jain <umang.jain@ideasonboard.com>
    media: imx335: Fix reset-gpio handling

Kieran Bingham <kieran.bingham@ideasonboard.com>
    media: i2c: imx335: Enable regulator supplies

Michel Alex <Alex.Michel@wiedemann-group.com>
    clk: imx6ul: fix clock parent for IMX6UL_CLK_ENETx_REF_SEL

Alexander Stein <alexander.stein@ew.tq-group.com>
    clk: imx6ul: retain early UART clocks during kernel init

Oleksij Rempel <linux@rempel-privat.de>
    clk: imx6ul: add ethernet refclock mux support

Oleksij Rempel <linux@rempel-privat.de>
    clk: imx6ul: fix enet1 gate configuration

Johannes Weiner <hannes@cmpxchg.org>
    sched: psi: fix bogus pressure spikes from aggregation race

Wang Yong <wang.yong12@zte.com.cn>
    delayacct: improve the average delay precision of getdelay tool to microsecond

Yanteng Si <siyanteng@loongson.cn>
    docs/zh_CN: Update the translation of delay-accounting to 6.1-rc8

Andrii Nakryiko <andrii@kernel.org>
    lib/buildid: harden build ID parsing logic

Alexey Dobriyan <adobriyan@gmail.com>
    build-id: require program headers to be right after ELF header

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Allow backlight to go below `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`

Yosry Ahmed <yosryahmed@google.com>
    mm: z3fold: deprecate CONFIG_Z3FOLD

Oleg Nesterov <oleg@redhat.com>
    uprobes: fix kernel info leak via "[uprobes]" vma

Jens Axboe <axboe@kernel.dk>
    io_uring/net: harden multishot termination case for recv

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround once more

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-N3 definitions

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64: Add Cortex-715 CPU part definition

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: bcm63xx: Fix missing pm_runtime_disable()

David Virag <virag.david003@gmail.com>
    dt-bindings: clock: exynos7885: Fix duplicated binding

Jinjie Ruan <ruanjinjie@huawei.com>
    i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled

Andi Shyti <andi.shyti@kernel.org>
    i2c: xiic: Use devm_clk_get_enabled()

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: core: Lock address during client device instantiation

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: create debugfs entry per adapter

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix buffer overflow in debug links

Uwe Kleine-König <ukleinek@debian.org>
    cpufreq: intel_pstate: Make hwp_notify_lock a raw spinlock

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix system hang while resume with TBT monitor

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Add locking to drm_sched_entity_modify_sched

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gem: fix bitwise and logical AND mixup

Al Viro <viro@zeniv.linux.org.uk>
    close_range(): fix the logics in descriptor table trimming

Wei Li <liwei391@huawei.com>
    tracing/timerlat: Fix a race during cpuhp processing

Wei Li <liwei391@huawei.com>
    tracing/hwlat: Fix a race during cpuhp processing

Patrick Donnelly <pdonnell@redhat.com>
    ceph: fix cap ref leak via netfs init_request

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    gpio: davinci: fix lazy disable

Filipe Manana <fdmanana@suse.com>
    btrfs: wait for fixup workers before stopping cleaner kthread during umount

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix invalid clone operation for file that got its size decreased

Qu Wenruo <wqu@suse.com>
    btrfs: fix a NULL pointer dereference when failed to start a new trasacntion

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus Vivobook X1704VAP to irq1_level_low_skip_override[]

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix dentry leak in cachefiles_open_file()

Nuno Sa <nuno.sa@analog.com>
    Input: adp5589-keys - fix adp5589_gpio_get_value()

Nuno Sa <nuno.sa@analog.com>
    Input: adp5589-keys - fix NULL pointer dereference

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rtc: at91sam9: fix OF node leak in probe() error path

KhaiWenTan <khai.wen.tan@linux.intel.com>
    net: stmmac: Fix zero-division error when disabling tc cbs

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: fallback to realpath if symlink's pathname does not exist

Willem de Bruijn <willemb@google.com>
    gso: fix udp gso fraglist segmentation after pull from frag_list

Barnabás Czémán <barnabas.czeman@mainlining.org>
    iio: magnetometer: ak8975: Fix reading for ak099xx sensors

wangrong <wangrong@uniontech.com>
    smb: client: use actual path when queryfs

Ajit Pandey <quic_ajipan@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix CAL_L_VAL override for LUCID EVO PLL

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-sc8180x: Fix the sdcc2 and sdcc4 clocks freq table

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix ordering of pm_runtime_enable

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8250: Do not turn off PCIe GDSCs during gdsc_disable()

Zheng Wang <zyytlz.wz@163.com>
    media: venus: fix use after free bug in venus_remove due to race condition

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-sm8150: De-register gcc_cpuss_ahb_clk_src

Mike Tipton <quic_mdtipton@quicinc.com>
    clk: qcom: clk-rpmh: Fix overflow in BCM vote

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8450: Do not turn off PCIe GDSCs during gdsc_disable()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: sun4i_csi: Implement link validate for sun4i_csi subdev

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks

Jan Kiszka <jan.kiszka@siemens.com>
    remoteproc: k3-r5: Fix error handling when power-up failed

Sebastian Reichel <sebastian.reichel@collabora.com>
    clk: rockchip: fix error for unknown clocks

Chun-Yi Lee <joeyli.kernel@gmail.com>
    aoe: fix the potential use-after-free problem in more places

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix NFSv4's PUTPUBFH operation

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: map the EBADMSG to nfserr_io to avoid warning

NeilBrown <neilb@suse.de>
    nfsd: fix delegation_blocked() to block correctly for at least 30 seconds

Matt Fleming <matt@readmodwrite.com>
    perf hist: Update hist symbol when updating maps

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix memory leak in exfat_load_bitmap()

Jisheng Zhang <jszhang@kernel.org>
    riscv: define ILLEGAL_POINTER_VALUE for 64bit

Lizhi Xu <lizhi.xu@windriver.com>
    ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate

Julian Sun <sunjunchao2870@gmail.com>
    ocfs2: fix null-ptr-deref when journal load failed.

Lizhi Xu <lizhi.xu@windriver.com>
    ocfs2: remove unreasonable unlock in ocfs2_read_blocks

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: cancel dqi_sync_work before freeing oinfo

Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
    ocfs2: reserve space for inline xattr before attaching reflink tree

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix uninit-value in ocfs2_get_block()

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix the la space leak when unmounting an ocfs2 volume

Danilo Krummrich <dakr@kernel.org>
    mm: krealloc: consider spare memory for __GFP_ZERO

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: correctly compare tids with tid_geq function in jbd2_fc_begin_commit

Baokun Li <libaokun1@huawei.com>
    jbd2: stop waiting for space when jbd2_cleanup_journal_tail() returns error

Huang Ying <ying.huang@intel.com>
    resource: fix region_intersects() vs add_memory_driver_managed()

Ma Ke <make24@iscas.ac.cn>
    drm: omapdrm: Add missing check for alloc_ordered_workqueue

Andrew Jones <ajones@ventanamicro.com>
    of/irq: Support #msi-cells=<0> in of_msi_get_domain

Val Packett <val@packett.cool>
    drm/rockchip: vop: clear DMA stop bit on RK3066

Helge Deller <deller@gmx.de>
    parisc: Fix stack start for ADDR_NO_RANDOMIZE personality

Helge Deller <deller@kernel.org>
    parisc: Fix 64-bit userspace syscall path

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: mark fc as ineligible using an handle in ext4_xattr_set()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: use handle to mark fc as ineligible in __track_dentry_update()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix fast commit inode enqueueing during a full journal commit

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in jbd2_journal_shrink_checkpoint_list()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()

Baokun Li <libaokun1@huawei.com>
    ext4: update orig_path in ext4_find_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: fix double brelse() the buffer of the extents path

Baokun Li <libaokun1@huawei.com>
    ext4: aovid use-after-free in ext4_ext_insert_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: drop ppath from ext4_ext_replay_update_ex() to avoid double-free

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()

Zhihao Cheng <chengzhihao1@huawei.com>
    ext4: dax: fix overflowing extents beyond inode size when partially writing

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in ext4_fc_mark_ineligible()

Baokun Li <libaokun1@huawei.com>
    ext4: propagate errors from ext4_find_extent() in ext4_insert_range()

Baokun Li <libaokun1@huawei.com>
    ext4: fix slab-use-after-free in ext4_split_extent_at()

yao.ly <yao.ly@linux.alibaba.com>
    ext4: correct encrypted dentry name hash when not casefolded

Edward Adam Davis <eadavis@qq.com>
    ext4: no need to continue when the number of entries is 1

Abhishek Tamboli <abhishektamboli9@gmail.com>
    ALSA: hda/realtek: Add a quirk for HP Pavilion 15z-ec200

Ai Chao <aichao@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9

Hans P. Moller <hmoller@uc.cl>
    ALSA: line6: add hw monitor volume control to POD HD500X

Jan Lalinsky <lalinsky@c4.cz>
    ALSA: usb-audio: Add native DSD support for Luxman D-08u

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for VIVO USB-C HEADSET

Jaroslav Kysela <perex@perex.cz>
    ALSA: core: add isascii() check to card ID generator

Thomas Zimmermann <tzimmermann@suse.de>
    drm: Consistently use struct drm_mode_rect for FB_DAMAGE_CLIPS

Helge Deller <deller@gmx.de>
    parisc: Fix itlb miss handler for 64-bit programs

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/core: Fix small negative period being ignored

Hans de Goede <hdegoede@redhat.com>
    power: supply: hwmon: Fix missing temp1_max_alarm attribute

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: bcm63xx: Fix module autoloading

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    firmware: tegra: bpmp: Drop unused mbox_client_to_bpmp()

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: ar0521: Use cansleep version of gpiod_set_value()

Robert Hancock <robert.hancock@calian.com>
    i2c: xiic: Wait for TX empty to avoid missed TX NAKs

Jinjie Ruan <ruanjinjie@huawei.com>
    i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()

Marek Vasut <marex@denx.de>
    i2c: stm32f7: Do not prepare/unprepare clock during runtime suspend/resume

Zach Wade <zachwade.k@gmail.com>
    platform/x86: ISST: Fix the KASAN report slab-out-of-bounds bug

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda: Conditionally use snooping for AMD HDMI"

Heiko Carstens <hca@linux.ibm.com>
    selftests: vDSO: fix vdso_config for s390

Jens Remus <jremus@linux.ibm.com>
    selftests: vDSO: fix ELF hash table entry size for s390x

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Fix VDSO data access when running in a non-root time namespace

David Hildenbrand <david@redhat.com>
    selftests/mm: fix charge_reserved_hugetlb.sh test

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests: vDSO: fix vDSO symbols lookup for powerpc64

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests: vDSO: fix vdso_config for powerpc

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests: vDSO: fix vDSO name for powerpc

Yifei Liu <yifei.l.liu@oracle.com>
    selftests: breakpoints: use remaining time to check if suspend succeed

Ben Dooks <ben.dooks@codethink.co.uk>
    spi: s3c64xx: fix timeout counters in flush_fifo

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled

Thomas Weißschuh <linux@weissschuh.net>
    blk-integrity: register sysfs attributes on struct device

Thomas Weißschuh <linux@weissschuh.net>
    blk-integrity: convert to struct device_attribute

Thomas Weißschuh <linux@weissschuh.net>
    blk-integrity: use sysfs_emit

Christoph Hellwig <hch@lst.de>
    iomap: handle a post-direct I/O invalidate race in iomap_write_delalloc_release

Artem Sadovnikov <ancowi69@gmail.com>
    ext4: fix i_data_sem unlock order in ext4_ind_migrate()

Baokun Li <libaokun1@huawei.com>
    ext4: avoid use-after-free in ext4_ext_show_leaf()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    ext4: ext4_search_dir should return a proper error

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries: Use correct data types from pseries_hp_errorlog struct

Geert Uytterhoeven <geert+renesas@glider.be>
    of/irq: Refer to actual buffer size in of_irq_parse_one()

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: ensure the fw_info is not null before using it

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/radeon/r100: Handle unknown family in r100_cp_init_microcode()

Finn Thain <fthain@linux-m68k.org>
    scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: fix unchecked return value warning for amdgpu_gfx

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Update PRLO handling in direct attached topology

Kees Cook <kees@kernel.org>
    scsi: aacraid: Rearrange order of struct aac_srb_unit

Andrii Nakryiko <andrii@kernel.org>
    perf,x86: avoid missing caller address in stack traces captured in uprobe

Matthew Brost <matthew.brost@intel.com>
    drm/printer: Allow NULL data in devcoredump printer

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Initialize get_bytes_per_element's default to 1

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix index out of bounds in DCN30 color transformation

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix index out of bounds in degamma hardware format translation

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix index out of bounds in DCN30 degamma hardware format translation

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check stream before comparing them

Yannick Fertre <yannick.fertre@foss.st.com>
    drm/stm: ltdc: reset plane transparency after plane disable

Ckath <ckath@yandex.ru>
    platform/x86: touchscreen_dmi: add nanote-next quirk

Vishnu Sankar <vishnuocv@gmail.com>
    HID: multitouch: Add support for Thinkpad X12 Gen 2 Kbd Portfolio

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdkfd: Fix resource leak in criu restore queue

Peng Liu <liupeng01@kylinos.cn>
    drm/amdgpu: enable gfxoff quirk on HP 705G4

Peng Liu <liupeng01@kylinos.cn>
    drm/amdgpu: add raven1 gfxoff quirk

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    jfs: Fix uninit-value access of new_ea in ea_buffer

Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
    scsi: smartpqi: correct stream detection

Edward Adam Davis <eadavis@qq.com>
    jfs: check if leafidx greater than num leaves per dmap tree

Edward Adam Davis <eadavis@qq.com>
    jfs: Fix uaf in dbFreeBits

Remington Brasga <rbrasga@uci.edu>
    jfs: UBSAN: shift-out-of-bounds in dbFindBits

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for 'afb' in amdgpu_dm_plane_handle_cursor_update (v2)

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before using dc->clk_mgr

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Handle null 'stream_status' in 'planes_changed_for_existing_stream'

Damien Le Moal <dlemoal@kernel.org>
    ata: sata_sil: Rename sil_blacklist to sil_quirks

Damien Le Moal <dlemoal@kernel.org>
    ata: pata_serverworks: Do not use the term blacklist

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for top_pipe_to_program in commit_planes_for_stream

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit

Katya Orlova <e.orlova@ispras.ru>
    drm/stm: Avoid use-after-free issues with crtc and plane

Sanjay K Kumar <sanjay.k.kumar@intel.com>
    iommu/vt-d: Fix potential lockup if qi_submit_sync called with 0 count

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Always reserve a domain ID for identity setup

Andrew Davis <afd@ti.com>
    power: reset: brcmstb: Do not go into infinite loop if reset fails

Marc Gonzalez <mgonzalez@freebox.fr>
    iommu/arm-smmu-qcom: hide last LPASS SMMU context bank from linux

Paul E. McKenney <paulmck@kernel.org>
    rcuscale: Provide clear error when async specified without primitives

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    fbdev: pxafb: Fix possible use after free in pxafb_task()

Kees Cook <kees@kernel.org>
    x86/syscall: Avoid memcpy() for ia32 syscall_get_arguments()

Thomas Weißschuh <linux@weissschuh.net>
    selftests/nolibc: avoid passing NULL to printf("%s")

Takashi Iwai <tiwai@suse.de>
    ALSA: hdsp: Break infinite MIDI input flush loop

Takashi Iwai <tiwai@suse.de>
    ALSA: asihpi: Fix potential OOB array access

Tao Liu <ltao@redhat.com>
    x86/kexec: Add EFI config table identity mapping for kexec kernel

Ahmed S. Darwish <darwi@linutronix.de>
    tools/x86/kcpuid: Protect against faulty "max subleaf" values

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa883x: Handle reading version failure

Joshua Pius <joshuapius@chromium.org>
    ALSA: usb-audio: Add logitech Audio profile quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Replace complex quirk lines with macros

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Define macros for quirk table entries

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Handle allocation failures gracefully

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add input value sanity checks for standard types

Jinjie Ruan <ruanjinjie@huawei.com>
    nfp: Use IRQF_NO_AUTOEN flag in request_irq()

Gustavo A. R. Silva <gustavoars@kernel.org>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_cmd_802_11_scan_ext()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: hold dev->mt76.mutex while disabling tx worker

Adrian Ratiu <adrian.ratiu@collabora.com>
    proc: add config & param to block forcing mem writes

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    ACPICA: iasl: handle empty connection_node

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix RCU list iterations

Jason Xing <kernelxing@tencent.com>
    tcp: avoid reusing FIN_WAIT2 when trying to find port in connect() process

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: simd - Do not call crypto_alloc_tfm during registration

Simon Horman <horms@kernel.org>
    net: atlantic: Avoid warning about potential string truncation

Ido Schimmel <idosch@nvidia.com>
    ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: correct base HT rate mask for firmware

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).

Simon Horman <horms@kernel.org>
    bnxt_en: Extend maximum length of version string by 1 byte

Simon Horman <horms@kernel.org>
    net: mvpp2: Increase size of queue_name buffer

Simon Horman <horms@kernel.org>
    tipc: guard against string buffer overrun

Pei Xiao <xiaopei01@kylinos.cn>
    ACPICA: check null return of ACPI_ALLOCATE_ZEROED() in acpi_db_convert_to_package()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Do not release locks during operation region accesses

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw88: select WANT_DEV_COREDUMP

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath11k: fix array out-of-bound access in SoC stats

Keith Busch <kbusch@kernel.org>
    nvme-pci: qdepth 1 quirk

Konstantin Ovsepian <ovs@ovs.to>
    blk_iocost: fix more out of bound shifts

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add force_vendor quirk for Panasonic Toughbook CF-18

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0489:0xe122

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: consistently use rcu_replace_pointer() in taprio_change()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: disable tx worker during tx BA session enable/disable

Armin Wolf <W_Armin@gmx.de>
    ACPICA: Fix memory leak if acpi_ps_get_next_field() fails

Armin Wolf <W_Armin@gmx.de>
    ACPICA: Fix memory leak if acpi_ps_get_next_namepath() fails

Seiji Nishikawa <snishika@redhat.com>
    ACPI: PAD: fix crash in exit_round_robin()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    net: hisilicon: hns_mdio: fix OF node leak in probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    net: hisilicon: hip04: fix OF node leak in probe()

Jeongjun Park <aha310510@gmail.com>
    net/xen-netback: prevent UAF in xenvif_flush_hash()

Issam Hamdi <ih@simonwunderlich.de>
    wifi: cfg80211: Set correct chandef when starting CAC

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlwifi: mvm: Fix a race in scan abort flow

Aleksandr Mishin <amishin@t-argos.ru>
    ice: Adjust over allocation of memory in ice_sched_add_root_node() and ice_sched_add_node()

Toke Høiland-Jørgensen <toke@redhat.com>
    wifi: ath9k_htc: Use __skb_set_length() for resetting urb before resubmit

Dmitry Kandybka <d.kandybka@gmail.com>
    wifi: ath9k: fix possible integer overflow in ath9k_get_et_stats()

Jann Horn <jannh@google.com>
    f2fs: Require FMODE_WRITE for atomic write ioctls

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix conflicting quirk for System76 Pangolin

Hui Wang <hui.wang@canonical.com>
    ASoC: imx-card: Set card.owner to avoid a warning calltrace if SND=m

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/generic: Unconditionally prefer preferred_dacs pairs

Oder Chiou <oder_chiou@realtek.com>
    ALSA: hda/realtek: Fix the push button function for the ALC257

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ALSA: mixer_oss: Remove some incorrect kfree_const() usages

Andrei Simion <andrei.simion@microchip.com>
    ASoC: atmel: mchp-pdmc: Skip ALSA restoration if substream runtime is uninitialized

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: usbtv: Remove useless locks in usbtv_video_free()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sock: Fix not validating setsockopt user input

Christoph Hellwig <hch@lst.de>
    loop: don't set QUEUE_FLAG_NOMERGES

Robert Hancock <robert.hancock@calian.com>
    i2c: xiic: Try re-initialization on bus busy timeout

Marc Ferland <marc.ferland@sonatest.com>
    i2c: xiic: improve error message when transfer fails to start

Xin Long <lucien.xin@gmail.com>
    sctp: set sk_state back to CLOSED if autobind fails in sctp_listen_start

Darrick J. Wong <djwong@kernel.org>
    iomap: constrain the file range passed to iomap_file_unshare

Shiyang Ruan <ruansy.fnst@fujitsu.com>
    fsdax,xfs: port unshare to fsdax

Eric Dumazet <edumazet@google.com>
    ppp: do not assume bh is held in ppp_channel_bridge_input()

Anton Danilov <littlesmilingcloud@gmail.com>
    ipv4: ip_gre: Fix drops of small packets in ipgre_xmit

Shenwei Wang <shenwei.wang@nxp.com>
    net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check

Eric Dumazet <edumazet@google.com>
    net: add more sanity checks to qdisc_pkt_len_init()

Eric Dumazet <edumazet@google.com>
    net: avoid potential underflow in qdisc_pkt_len_init() with UFO

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: ethernet: lantiq_etop: fix memory disclosure

Jinjie Ruan <ruanjinjie@huawei.com>
    Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()

Eric Dumazet <edumazet@google.com>
    netfilter: nf_tables: prevent nf_skb_duplicated corruption

Phil Sutter <phil@nwl.cc>
    selftests: netfilter: Fix nft_audit.sh for newer nft binaries

Jinjie Ruan <ruanjinjie@huawei.com>
    net: wwan: qcom_bam_dmux: Fix missing pm_runtime_disable()

Jinjie Ruan <ruanjinjie@huawei.com>
    net: ieee802154: mcr20a: Use IRQF_NO_AUTOEN flag in request_irq()

Phil Sutter <phil@nwl.cc>
    netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED

Elena Salomatkina <esalomatkina@ispras.ru>
    net/mlx5e: Fix NULL deref in mlx5e_tir_builder_alloc()

Mohamed Khalfella <mkhalfella@purestorage.com>
    net/mlx5: Added cond_resched() to crdump collection

Gerd Bayer <gbayer@linux.ibm.com>
    net/mlx5: Fix error path in multi-packet WQE transmit

Aakash Menon <aakash.r.menon@gmail.com>
    net: sparx5: Fix invalid timestamps

Jinjie Ruan <ruanjinjie@huawei.com>
    ieee802154: Fix build error

Xiubo Li <xiubli@redhat.com>
    ceph: remove the incorrect Fw reference check when dirtying pages

Stefan Wahren <wahrenst@gmx.net>
    mailbox: bcm2835: Fix timeout during suspend mode

Liao Chen <liaochen4@huawei.com>
    mailbox: rockchip: fix a typo in module autoloading

Daniel Wagner <dwagner@suse.de>
    scsi: pm8001: Do not overwrite PCI queue mapping

Peter Zijlstra <peterz@infradead.org>
    jump_label: Fix static_key_slow_dec() yet again

Thomas Gleixner <tglx@linutronix.de>
    jump_label: Simplify and clarify static_key_fast_inc_cpus_locked()

Thomas Gleixner <tglx@linutronix.de>
    static_call: Replace pointless WARN_ON() in static_call_module_notify()

Thomas Gleixner <tglx@linutronix.de>
    static_call: Handle module init failure correctly in static_call_del_module()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: do not run mt76_unregister_device() on unregistered hw

Alexey Gladkov (Intel) <legion@kernel.org>
    x86/tdx: Fix "in-kernel MMIO" check

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/PM: Mark devices disconnected if upstream PCIe link is down on resume

Nathan Chancellor <nathan@kernel.org>
    powerpc: Allow CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 with ld.lld 15+

André Apitzsch <git@apitzsch.eu>
    iio: magnetometer: ak8975: Fix 'Unexpected device' error

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Fail DTC counter allocation correctly

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    usb: yurex: Fix inconsistent locking bug in yurex_read()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: isch: Add missed 'else'

Tommy Huang <tommy_huang@aspeedtech.com>
    i2c: aspeed: Update the stop sw state when the bus recovery occurs

Liam R. Howlett <Liam.Howlett@oracle.com>
    mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock

Dmitry Vyukov <dvyukov@google.com>
    module: Fix KCOV-ignored file name

David Gow <davidgow@google.com>
    mm: only enforce minimum stack gap size if it's sensible

Zhiguo Niu <zhiguo.niu@unisoc.com>
    lockdep: fix deadlock issue between lockdep and rcu

Song Liu <song@kernel.org>
    bpf: lsm: Set bpf_lsm_blob_sizes.lbs_task to 0

Eric Dumazet <edumazet@google.com>
    icmp: change the order of rate limits

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    icmp: Add counters for rate limits

Kairui Song <kasong@tencent.com>
    mm/filemap: optimize filemap folio adding

Kairui Song <kasong@tencent.com>
    lib/xarray: introduce a new helper xas_get_order

Kairui Song <kasong@tencent.com>
    mm/filemap: return early if failed to allocate memory for split

Dmitry Vyukov <dvyukov@google.com>
    x86/entry: Remove unwanted instrumentation in common_interrupt()

Xin Li <xin3.li@intel.com>
    x86/idtentry: Incorporate definitions/declarations of the FRED entries

Ma Ke <make24@iscas.ac.cn>
    pps: add an error check in parport_attach

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pps: remove usage of the deprecated ida_simple_xx() API

Pawel Laszczak <pawell@cadence.com>
    usb: xhci: fix loss of data on Cadence xHC

Daehwan Jung <dh10.jung@samsung.com>
    xhci: Add a quirk for writing ERST in high-low order

Lukas Wunner <lukas@wunner.de>
    xhci: Preserve RsvdP bits in ERSTBA register correctly

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Refactor interrupter code for initial multi interrupter support.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: remove xhci_test_trb_in_td_math early development check

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix event ring segment table related masks and variables in header

Oliver Neukum <oneukum@suse.com>
    USB: misc: yurex: fix race between read and write

Lee Jones <lee@kernel.org>
    usb: yurex: Replace snprintf() with the safer scnprintf() variant

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/atomic: Use YZ constraints for DS-form instructions

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Add support to build with prefixed instructions

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64: Option to build big-endian with ELFv2 ABI

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: versatile: realview: fix soc_dev leak during device remove

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: versatile: realview: fix memory leak during device remove

VanGiang Nguyen <vangiang.nguyen@rohde-schwarz.com>
    padata: use integer wrap around to prevent deadlock on seq_nr overflow

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix conversion of system address to physical memory address

Li Lingfeng <lilingfeng3@huawei.com>
    nfs: fix memory leak in error path of nfs4_do_reclaim

Mickaël Salaün <mic@digikod.net>
    fs: Fix file_set_fowner LSM hook inconsistencies

Julian Sun <sunjunchao2870@gmail.com>
    vfs: fix race between evice_inodes() and find_inode()&iput()

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Correct the Pinebook Pro battery design capacity

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Raise Pinebook Pro's panel backlight PWM frequency

Gaosheng Cui <cuigaosheng1@huawei.com>
    hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume

Gaosheng Cui <cuigaosheng1@huawei.com>
    hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init

Guoqing Jiang <guoqing.jiang@canonical.com>
    hwrng: mtk - Use devm_pm_runtime_enable

Chao Yu <chao@kernel.org>
    f2fs: fix to check atomic_file in f2fs ioctl interfaces

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    f2fs: avoid potential int overflow in sanity_check_area_boundary()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    f2fs: prevent possible int overflow in dir_block_index()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    f2fs: fix several potential integer overflows in file offsets

Zhen Lei <thunder.leizhen@huawei.com>
    debugobjects: Fix conditions in fill_pool()

Ma Ke <make24@iscas.ac.cn>
    wifi: mt76: mt7615: check devm_kasprintf() returned value

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: 8822c: Fix reported RX band width

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix sampling synchronization

Ard Biesheuvel <ardb@kernel.org>
    efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption

Werner Sembach <wse@tuxedocomputers.com>
    ACPI: resource: Add another DMI match for the TongFang GMxXGxx

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: sysfs: validate return type of _STR method

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    drbd: Add NULL check for net_conf to prevent dereference in state validation

Qiu-ji Chen <chenqiuji666@gmail.com>
    drbd: Fix atomicity violation in drbd_uuid_set_bm()

Pavan Kumar Paluri <papaluri@amd.com>
    crypto: ccp - Properly unregister /dev/sev on sev PLATFORM_STATUS failure

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.

Florian Fainelli <florian.fainelli@broadcom.com>
    tty: rp2: Fix reset with non forgiving PCIe host bridges

Jann Horn <jannh@google.com>
    firmware_loader: Block path traversal

Fabio Porcedda <fabio.porcedda@gmail.com>
    bus: mhi: host: pci_generic: Fix the name for the Telit FE990A

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    bus: integrator-lm: fix OF node leak in probe()

Tomas Marek <tomas.marek@elrest.cz>
    usb: dwc2: drd: fix clock gating on USB role switch

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix incorrect usb_request status

Oliver Neukum <oneukum@suse.com>
    USB: class: CDC-ACM: fix race between get_serial and set_serial

Oliver Neukum <oneukum@suse.com>
    USB: misc: cypress_cy7c63: check for short transfer

Oliver Neukum <oneukum@suse.com>
    USB: appledisplay: close race between probe and completion handler

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled

Oliver Neukum <oneukum@suse.com>
    usbnet: fix cyclical race on disconnect with work queue

Finn Thain <fthain@linux-m68k.org>
    scsi: mac_scsi: Disallow bus errors during PDMA send

Finn Thain <fthain@linux-m68k.org>
    scsi: mac_scsi: Refactor polling loop

Finn Thain <fthain@linux-m68k.org>
    scsi: mac_scsi: Revise printk(KERN_DEBUG ...) messages

Martin Wilck <mwilck@suse.com>
    scsi: sd: Fix off-by-one error in sd_read_block_characteristics()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: handle caseless file creation

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow write with FILE_APPEND_DATA

Hobin Woo <hobin.woo@samsung.com>
    ksmbd: make __dir_empty() compatible with POSIX

Chuck Lever <chuck.lever@oracle.com>
    fs: Create a generic is_dot_dotdot() utility

Roman Smirnov <r.smirnov@omp.ru>
    KEYS: prevent NULL pointer dereference in find_asymmetric_key()

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Validate backlight caps are sane

Robin Chen <robin.chen@amd.com>
    drm/amd/display: Round calculated vtotal

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Skip Recompute DSC Params if no Stream on Link

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add TUXEDO Stellaris 15 Slim Gen6 AMD to i8042 quirk table

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add TUXEDO Stellaris 16 Gen5 AMD to i8042 quirk table

Nuno Sa <nuno.sa@analog.com>
    Input: adp5588-keys - fix check on return code

Roman Smirnov <r.smirnov@omp.ru>
    Revert "media: tuners: fix error return code of hybrid_tuner_request_state()"

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: versatile: integrator: fix OF node leak in probe() error path

Ma Ke <make24@iscas.ac.cn>
    ASoC: rt5682: Return devm_of_clk_add_hw_provider to transfer the error

Sean Anderson <sean.anderson@linux.dev>
    PCI: xilinx-nwl: Fix off-by-one in INTx IRQ handler

Frank Li <Frank.Li@nxp.com>
    PCI: imx6: Fix missing call to phy_power_off() in error handling

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Remove *.orig pattern from .gitignore

Felix Moessbauer <felix.moessbauer@siemens.com>
    io_uring/sqpoll: do not put cpumask on stack

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: retain test for whether the CPU is valid

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Prevent unmapping active read buffers

Scott Mayhew <smayhew@redhat.com>
    selinux,smack: don't bypass permissions check in inode_setsecctx hook

Ye Bin <yebin10@huawei.com>
    vfio/pci: fix potential memory leak in vfio_intx_enable()

Felix Moessbauer <felix.moessbauer@siemens.com>
    io_uring/io-wq: inherit cpuset of cgroup in io worker

Felix Moessbauer <felix.moessbauer@siemens.com>
    io_uring/io-wq: do not allow pinning outside of cpuset

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination

Felix Moessbauer <felix.moessbauer@siemens.com>
    io_uring/sqpoll: do not allow pinning outside of cpuset

Simon Horman <horms@kernel.org>
    netfilter: ctnetlink: compile ctnetlink_label_size with CONFIG_NF_CONNTRACK_EVENTS

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Keep deleted flowtable hooks until after RCU

Furong Xu <0x1207@gmail.com>
    net: stmmac: set PP_FLAG_DMA_SYNC_DEV only if XDP is enabled

Jiwon Kim <jiwonaid0@gmail.com>
    bonding: Fix unnecessary warnings and logs from bond_xdp_get_xmit_slave()

Youssef Samir <quic_yabdulra@quicinc.com>
    net: qrtr: Update packets cloning when broadcasting

Josh Hunt <johunt@akamai.com>
    tcp: check skb is non-NULL in tcp_rto_delta_us()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    net: ipv6: select DST_CACHE from IPV6_RPL_LWTUNNEL

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    net: seeq: Fix use after free vulnerability in ether3 Driver Due to Race Condition

Eric Dumazet <edumazet@google.com>
    netfilter: nf_reject_ipv6: fix nf_reject_ip6_tcphdr_put()

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix packet counting

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Schedule NAPI in two steps

Mikulas Patocka <mpatocka@redhat.com>
    Revert "dm: requeue IO if mapping table not yet available"

Dan Carpenter <alexander.sverdlin@gmail.com>
    ep93xx: clock: Fix off by one in ep93xx_div_recalc_rate()

Jason Wang <jasowang@redhat.com>
    vhost_vdpa: assign irq bypass producer token correctly

Xie Yongji <xieyongji@bytedance.com>
    vdpa: Add eventfd for the vdpa callback

Yanfei Xu <yanfei.xu@intel.com>
    cxl/pci: Fix to record only non-zero ranges

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Break out range register decoding from cxl_hdm_decode_init()

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: tmc: sg: Do not leak sg_table

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: iio: asahi-kasei,ak8975: drop incorrect AK09116 compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    iio: magnetometer: ak8975: drop incorrect AK09116 compatible

Biju Das <biju.das.jz@bp.renesas.com>
    iio: magnetometer: ak8975: Convert enum->pointer for data in the match tables

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: chemical: bme680: Fix read/write ops to device by adding mutexes

Antoniu Miclaus <antoniu.miclaus@analog.com>
    ABI: testing: fix admv8818 attr description

Guillaume Stols <gstols@baylibre.com>
    iio: adc: ad7606: fix standby gpio state to match the documentation

Guillaume Stols <gstols@baylibre.com>
    iio: adc: ad7606: fix oversampling gpio array

Hannes Reinecke <hare@kernel.org>
    nvme-multipath: system fails to create generic nvme device

Ming Lei <ming.lei@redhat.com>
    lib/sbitmap: define swap_lock as raw_spinlock_t

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: atmel-quadspi: Undo runtime PM changes at driver exit time

Chao Yu <chao@kernel.org>
    f2fs: get rid of online repaire on corrupted directory

Chao Yu <chao@kernel.org>
    f2fs: clean up w/ dotdot_name

Chao Yu <chao@kernel.org>
    f2fs: atomic: fix to truncate pagecache before on-disk metadata truncation

Chao Yu <chao@kernel.org>
    f2fs: fix to wait page writeback before setting gcing flag

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid racing in between read and OPU dio write

Christoph Hellwig <hch@lst.de>
    f2fs: factor the read/write tracing logic into a helper

Chao Yu <chao@kernel.org>
    f2fs: reduce expensive checkpoint trigger frequency

Chao Yu <chao@kernel.org>
    f2fs: remove unneeded check condition in __f2fs_setxattr()

Chao Yu <chao@kernel.org>
    f2fs: fix to update i_ctime in __f2fs_setxattr()

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: return -EINVAL when namelen is 0

Guoqing Jiang <guoqing.jiang@linux.dev>
    nfsd: call cache_put if xdr_reserve_space returns NULL

Dave Jiang <dave.jiang@intel.com>
    ntb: Force physically contiguous allocation of rx ring buffers

Max Hawking <maxahawking@sonnenkinder.org>
    ntb_perf: Fix printk format

Jinjie Ruan <ruanjinjie@huawei.com>
    ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()

Vitaliy Shevtsov <v.shevtsov@maxima.ru>
    RDMA/irdma: fix error message in irdma_modify_qp_roce()

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    RDMA/cxgb4: Added NULL check for lookup_atid

Jinjie Ruan <ruanjinjie@huawei.com>
    riscv: Fix fp alignment bug in perf_callchain_user()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Optimize hem allocation performance

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix 1bit-ECC recovery address in non-4K OS

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix VF triggering PF reset in abnormal interrupt handler

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix spin_unlock_irqrestore() called with IRQs enabled

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix the overflow risk of hem_list_calc_ba_range()

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix Use-After-Free of rsv_qp on HIP08

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Don't modify rq next block addr in HIP09 QPC

Jonas Blixt <jonas.blixt@actia.se>
    watchdog: imx_sc_wdt: Don't disable WDT in suspend

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Return QP state in erdma_query_qp

Alexandra Diupina <adiupina@astralinux.ru>
    PCI: kirin: Fix buffer overflow in kirin_pcie_parse_port()

Patrisious Haddad <phaddad@nvidia.com>
    IB/core: Fix ib_cache_setup_one error flow cleanup

Wang Jianzheng <wangjianzheng@vivo.com>
    pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function

Yangtao Li <frank.li@vivo.com>
    pinctrl: mvebu: Use devm_platform_get_and_ioremap_resource()

Jeff Layton <jlayton@kernel.org>
    nfsd: fix refcount leak when file is unhashed after being found

Jeff Layton <jlayton@kernel.org>
    nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire

David Lechner <dlechner@baylibre.com>
    clk: ti: dra7-atl: Fix leak of of_nodes

Md Haris Iqbal <haris.iqbal@ionos.com>
    RDMA/rtrs-clt: Reset cid to con_num - 1 to stay in bounds

Jack Wang <jinpu.wang@ionos.com>
    RDMA/rtrs: Reset hb_missed_cnt after receiving other traffic from peer

Yang Yingliang <yangyingliang@huawei.com>
    pinctrl: single: fix missing error code in pcs_probe()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/iwcm: Fix WARNING:at_kernel/workqueue.c:#check_flush_dependency

Sean Anderson <sean.anderson@linux.dev>
    PCI: xilinx-nwl: Clean up clock on probe failure/removal

Sean Anderson <sean.anderson@linux.dev>
    PCI: xilinx-nwl: Fix register misspelling

Li Zhijian <lizhijian@fujitsu.com>
    nvdimm: Fix devs leaks in scan_labels()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8250: use special function for Lucid 5LPE PLL

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: keystone: Fix if-statement expression in ks_pcie_quirk()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Wait for Link before restoring Downstream Buses

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/PM: Drop pci_bridge_wait_for_secondary_bus() timeout parameter

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/PM: Increase wait time after resume

Junlin Li <make24@iscas.ac.cn>
    drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error

Junlin Li <make24@iscas.ac.cn>
    drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    Input: ilitek_ts_i2c - add report id message validation

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    Input: ilitek_ts_i2c - avoid wrong input subsystem sync

Jonas Karlman <jonas@kwiboo.se>
    clk: rockchip: Set parent rate for DCLK_VOP clock on RK3228

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: Initialize workqueue earlier

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: Correct ddr alias for i.MX8M

Peng Fan <peng.fan@nxp.com>
    clk: imx: imx8qxp: Parent should be initialized earlier than the clock

Peng Fan <peng.fan@nxp.com>
    clk: imx: imx8qxp: Register dc0_bypass0_clk before disp clk

Zhipeng Wang <zhipeng.wang_1@nxp.com>
    clk: imx: imx8mp: fix clock tree update of TF-A managed clocks

Pengfei Li <pengfei.li_1@nxp.com>
    clk: imx: fracn-gppll: fix fractional part of PLL getting lost

Peng Fan <peng.fan@nxp.com>
    clk: imx: fracn-gppll: support integer pll

Ye Li <ye.li@nxp.com>
    clk: imx: composite-7ulp: Check the PCC present bit

Peng Fan <peng.fan@nxp.com>
    clk: imx: composite-8m: Enable gate clk with mcore_booted

Markus Elfring <elfring@users.sourceforge.net>
    clk: imx: composite-8m: Less function calls in __imx8m_clk_hw_composite() after error detection

Ian Rogers <irogers@google.com>
    perf time-utils: Fix 32-bit nsec parsing

Yang Jihong <yangjihong@bytedance.com>
    perf sched timehist: Fixed timestamp error when unable to confirm event sched_in time

Yicong Yang <yangyicong@hisilicon.com>
    perf stat: Display iostat headers correctly

Yang Jihong <yangjihong@bytedance.com>
    perf sched timehist: Fix missing free of session in perf_sched__timehist()

Ian Rogers <irogers@google.com>
    perf inject: Fix leader sampling inserting additional samples

Namhyung Kim <namhyung@kernel.org>
    perf mem: Free the allocated sort string, fixing a leak

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Zero former ARG_PTR_TO_{LONG,INT} args in case of error

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Improve check_raw_mode_ok test for MEM_UNINIT-tagged types

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix bpf_strtol and bpf_strtoul helpers for 32bit

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential oob read in nilfs_btree_check_delete()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: determine empty node blocks as corrupted

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    ext4: avoid OOB when system.data xattr changes underneath the filesystem

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    ext4: return error on ext4_find_inline_entry

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: avoid negative min_clusters in find_group_orlov()

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: avoid potential buffer_head leak in __ext4_new_inode()

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: avoid buffer_head leak in ext4_mark_inode_used()

Jiawei Ye <jiawei.ye@foxmail.com>
    smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso

yangerkun <yangerkun@huawei.com>
    ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard

Chen Yu <yu.c.chen@intel.com>
    kthread: fix task state in kthread worker if being frozen

Lasse Collin <lasse.collin@tukaani.org>
    xz: cleanup CRC32 edits from 2018

Eduard Zingerman <eddyz87@gmail.com>
    bpf: correctly handle malformed BPF_CORE_TYPE_ID_LOCAL relos

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix compile if backtrace support missing in libc

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Move test_progs helpers to testing_helpers object

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Replace extract_build_id with read_build_id

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix C++ compile error from missing _Bool type

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix error compiling test_lru_map.c

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix errors compiling cg_storage_multi.h with musl libc

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix compiling core_reloc.c with musl-libc

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix compiling tcp_rtt.c with musl-libc

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix compiling flow_dissector.c with musl-libc

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix compiling kfree_skb.c with musl-libc

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix include of <sys/fcntl.h>

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Add a cgroup prog bpf_get_ns_current_pid_tgid() test

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Refactor out some functions in ns_current_pid_tgid test

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Replace CHECK with ASSERT_* in ns_current_pid_tgid test

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix missing BUILD_BUG_ON() declaration

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix missing UINT_MAX definitions in benchmarks

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix missing ARRAY_SIZE() definition in bench.c

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix error compiling bpf_iter_setsockopt.c with musl libc

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix compile error from rlim_t in sk_storage_map.c

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Use pid_t consistently in test_progs.c

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Workaround strict bpf_lsm return value check.

Roberto Sassu <roberto.sassu@huawei.com>
    selftests/bpf: Add tests for _opts variants of bpf_*_get_fd_by_id()

Yonghong Song <yhs@fb.com>
    selftests/bpf: Add selftest deny_namespace to s390x deny list

Jonathan McDowell <noodles@meta.com>
    tpm: Clean up TPM space after command failure

Juergen Gross <jgross@suse.com>
    xen/swiotlb: fix allocated size

Juergen Gross <jgross@suse.com>
    xen/swiotlb: add alignment check for dma buffers

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Do not warn about dropped packets for first packet

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Support sequence numbers smaller than 16-bit

Juergen Gross <jgross@suse.com>
    xen: use correct end address of kernel for conflict checking

Yuesong Li <liyuesong@vivo.com>
    drivers:drm:exynos_drm_gsc:Fix wrong assignment in gsc_bind()

Sherry Yang <sherry.yang@oracle.com>
    drm/msm: fix %s null argument error

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ipmi: docs: don't advertise deprecated sysfs entries

Vladimir Lypak <vladimir.lypak@gmail.com>
    drm/msm/a5xx: workaround early ring-buffer emptiness check

Vladimir Lypak <vladimir.lypak@gmail.com>
    drm/msm/a5xx: fix races in preemption evaluation stage

Vladimir Lypak <vladimir.lypak@gmail.com>
    drm/msm/a5xx: properly clear preemption records on resume

Vladimir Lypak <vladimir.lypak@gmail.com>
    drm/msm/a5xx: disable preemption in submits by default

Aleksandr Mishin <amishin@t-argos.ru>
    drm/msm: Fix incorrect file name output in adreno_request_fw()

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix kernel vs user address comparison

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Fix initial memory mapping

Fei Shao <fshao@chromium.org>
    drm/mediatek: Use spin_lock_irqsave() for CRTC event lock

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Fix missing configuration flags in mtk_crtc_ddp_config()

Jeongjun Park <aha310510@gmail.com>
    jfs: fix out-of-bounds in dbNextAG() and diAlloc()

Dan Carpenter <dan.carpenter@linaro.org>
    scsi: elx: libefc: Fix potential use after free in efc_nport_vport_del()

Stefan Wahren <wahrenst@gmx.net>
    drm/vc4: hdmi: Handle error case of pm_runtime_resume_and_get

Liu Ying <victor.liu@nxp.com>
    drm/bridge: lontium-lt8912b: Validate mode in drm_bridge_funcs::mode_valid()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/radeon/evergreen_cs: fix int overflow errors in cs track offsets

Jonas Karlman <jonas@kwiboo.se>
    drm/rockchip: dw_hdmi: Fix reading EDID when using a forced mode

Alex Bee <knaerzche@gmail.com>
    drm/rockchip: vop: Allow 4096px width scaling

WangYuli <wangyuli@uniontech.com>
    drm/amd/amdgpu: Properly tune the size of struct

Finn Thain <fthain@linux-m68k.org>
    scsi: NCR5380: Check for phase match during PDMA fixup

Gilbert Wu <Gilbert.Wu@microchip.com>
    scsi: smartpqi: revert propagate-the-multipath-failure-to-SML-quickly

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: properly handle vbios fake edid sizing

Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
    drm/radeon: Replace one-element array with flexible-array member

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: properly handle vbios fake edid sizing

Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
    drm/amdgpu: Replace one-element array with flexible-array member

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for set_output_gamma in dcn30_set_output_transfer_func

Claudiu Beznea <claudiu.beznea@microchip.com>
    drm/stm: ltdc: check memory returned by devm_kzalloc()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/stm: Fix an error handling path in stm_drm_platform_probe()

Geert Uytterhoeven <geert+renesas@glider.be>
    pmdomain: core: Harden inter-column space in debug summary

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: mtk: Fix init error path

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: mtk: Factorize out the logic cleaning mtk chips

Jinjie Ruan <ruanjinjie@huawei.com>
    mtd: rawnand: mtk: Use for_each_child_of_node_scoped()

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Fix RT throttling hrtimer armed from offline CPU

Charles Han <hanchunchao@inspur.com>
    mtd: powernv: Add check devm_kasprintf() returned value

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/amd: Do not set the D bit on AMD v2 table entries

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()

Artur Weber <aweber.kernel@gmail.com>
    power: supply: max17042_battery: Fix SOC threshold calc w/ no current sense

Chris Morgan <macromorgan@hotmail.com>
    power: supply: axp20x_battery: Remove design from min and max voltage

Yuntao Liu <liuyuntao12@huawei.com>
    hwmon: (ntc_thermistor) fix module autoloading

Mirsad Todorovac <mtodorovac69@gmail.com>
    mtd: slram: insert break after errors in parsing the map

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max16065) Fix alarm attributes

Andrew Davis <afd@ti.com>
    hwmon: (max16065) Remove use of i2c_match_id()

Biju Das <biju.das.jz@bp.renesas.com>
    i2c: Add i2c_get_match_data()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (max16065) Fix overflows seen when writing limits

Finn Thain <fthain@linux-m68k.org>
    m68k: Fix kernel_clone_args.flags in m68k_clone()

Yuntao Liu <liuyuntao12@huawei.com>
    ALSA: hda: cs35l41: fix module autoloading

Ma Ke <make24@iscas.ac.cn>
    ASoC: rt5682s: Return devm_of_clk_add_hw_provider to transfer the error

Ankit Agrawal <agrawal.ag.ankit@gmail.com>
    clocksource/drivers/qcom: Add missing iounmap() on errors in msm_dt_timer_init()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    reset: k210: fix OF node leak in probe() error path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    reset: berlin: fix OF node leak in probe() error path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: versatile: fix OF node leak in CPUs prepare

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property

Claudiu Beznea <claudiu.beznea@tuxon.dev>
    ARM: dts: microchip: sama7g5: Fix RTT clock

Andrew Davis <afd@ti.com>
    arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations

Alexander Dahl <ada@thorsis.com>
    ARM: dts: microchip: sam9x60: Fix rtc/rtt clocks

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a07g044: Correct GICD and GICR sizes

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a07g054: Correct GICD and GICR sizes

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    arm64: dts: renesas: r9a07g043u: Correct GICD and GICR sizes

Chen-Yu Tsai <wenst@chromium.org>
    regulator: Return actual error in of_regulator_bulk_get_all()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix double free in OPTEE transport

David Virag <virag.david003@gmail.com>
    arm64: dts: exynos: exynos7885-jackpotlte: Correct RAM amount to 4GB

Ma Ke <make24@iscas.ac.cn>
    spi: ppc4xx: handle irq_of_parse_and_map() errors

Riyan Dhiman <riyandhiman14@gmail.com>
    block: fix potential invalid pointer dereference in blk_add_partition

Christian Heusel <christian@heusel.eu>
    block: print symbolic error name instead of error code

Yu Kuai <yukuai3@huawei.com>
    block, bfq: don't break merge chain in bfq_split_bfqq()

Yu Kuai <yukuai3@huawei.com>
    block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix possible UAF for bfqq->bic with merge chain

Ming Lei <ming.lei@redhat.com>
    nbd: fix race between timeout and normal completion

Eric Dumazet <edumazet@google.com>
    ipv6: avoid possible NULL deref in rt6_uncached_list_flush_dev()

Su Hui <suhui@nfschina.com>
    net: tipc: avoid possible garbage value

Justin Iurman <justin.iurman@uliege.be>
    net: ipv6: rpl_iptunnel: Fix memory leak in rpl_input

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: disable ALDPS per default for RTL8125

Jinjie Ruan <ruanjinjie@huawei.com>
    net: enetc: Use IRQF_NO_AUTOEN flag in request_irq()

Guillaume Nault <gnault@redhat.com>
    bareudp: Pull inner IP header on xmit.

Guillaume Nault <gnault@redhat.com>
    bareudp: Pull inner IP header in bareudp_udp_encap_recv().

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix not handling ZPL/short-transfer

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_close(): stop clocks after device has been shut down

Jake Hamby <Jake.Hamby@Teledyne.com>
    can: m_can: enable NAPI before enabling interrupts

Markus Schneider-Pargmann <msp@baylibre.com>
    can: m_can: Remove repeated check for is_peripheral

Kuniyuki Iwashima <kuniyu@amazon.com>
    can: bcm: Clear bo->bcm_proc_read after remove_proc_entry().

Eric Dumazet <edumazet@google.com>
    sock_map: Add a cond_resched() in sock_hash_free()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Ignore errors from HCI_OP_REMOTE_NAME_REQ_CANCEL

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix sending MGMT_EV_CONNECT_FAILED

Jiawei Ye <jiawei.ye@foxmail.com>
    wifi: wilc1000: fix potential RCU dereference issue in wilc_parse_join_bss_param

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: mac80211: use two-phase skb reclamation in ieee80211_do_stop()

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7915: fix rx filter setting for bfee functionality

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: fix UBSAN noise in cfg80211_wext_siwscan()

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - inject error before stopping queue

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - reset device before enabling it

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - fix coding style issues

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - mask cluster timeout error

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - enable sva error interrupt event

Aaron Lu <aaron.lu@intel.com>
    x86/sgx: Fix deadlock in SGX NUMA node search

Nishanth Menon <nm@ti.com>
    cpufreq: ti-cpufreq: Introduce quirks to handle syscon fails appropriately

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Ensure dtm_idx is big enough

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Refactor node ID handling. Again.

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Improve debugfs pretty-printing for large configs

Robin Murphy <robin.murphy@arm.com>
    perf/arm-cmn: Rework DTC counters (again)

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: remove annotation to access set timeout while holding lock

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject expiration higher than timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject element expiration with no timeout

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire

Clément Léger <cleger@rivosinc.com>
    ACPI: CPPC: Fix MASK_VAL() usage

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: use correct function name in comment

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Actually test SME vector length changes via sigreturn

Yicong Yang <yangyicong@hisilicon.com>
    drivers/perf: hisi_pcie: Record hardware counts correctly

Kamlesh Gurudasani <kamlesh@ti.com>
    padata: Honor the caller's alignment in case of chunk_size 0

Vasily Khoruzhick <anarsoul@gmail.com>
    ACPICA: executer/exsystem: Don't nag user about every Stall() violating the spec

Vasily Khoruzhick <anarsoul@gmail.com>
    ACPICA: Implement ACPI_WARNING_ONCE and ACPI_ERROR_ONCE

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: increase the time between ranging measurements

Ping-Ke Shih <pkshih@realtek.com>
    wifi: mac80211: don't use rate mask for offchannel TX either

Jing Zhang <renyu.zj@linux.alibaba.com>
    drivers/perf: Fix ali_drw_pmu driver interrupt status clearing

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: signal: fix/refactor SVE vector length enumeration

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix enumeration of systems without 128 bit SME for SSVE+ZA

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Verify simultaneous SSVE and ZA context generation

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Don't pass headers to the compiler as source

Olaf Hering <olaf@aepfle.de>
    mount: handle OOM on mnt_warn_timestamp_expiry

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fs/namespace: fnic: Switch to use %ptTd

Andrew Jones <ajones@ventanamicro.com>
    RISC-V: KVM: Fix sbiret init before forwarding to userspace

Dmitry Kandybka <d.kandybka@gmail.com>
    wifi: rtw88: remove CPT execution branch never used

Yanteng Si <siyanteng@loongson.cn>
    net: stmmac: dwmac-loongson: Init ref and PTP clocks rate

Toke Høiland-Jørgensen <toke@redhat.com>
    wifi: ath9k: Remove error checks when creating debugfs entries

Minjie Du <duminjie@vivo.com>
    wifi: ath9k: fix parameter check in ath9k_init_debug()

Aleksandr Mishin <amishin@t-argos.ru>
    ACPI: PMIC: Remove unneeded check in tps68470_pmic_opregion_probe()

Helge Deller <deller@kernel.org>
    crypto: xor - fix template benchmarking

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtw88: always wait for both firmware loading attempts

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    EDAC/synopsys: Fix error injection on Zynq UltraScale+

Serge Semin <fancer.lancer@gmail.com>
    EDAC/synopsys: Fix ECC status and IRQ control race condition


-------------

Diffstat:

 .gitignore                                         |    1 -
 .../ABI/testing/sysfs-bus-iio-filter-admv8818      |    2 +-
 Documentation/accounting/delay-accounting.rst      |   14 +-
 Documentation/admin-guide/kernel-parameters.txt    |   10 +
 Documentation/arm64/silicon-errata.rst             |    4 +
 .../iio/magnetometer/asahi-kasei,ak8975.yaml       |    1 -
 Documentation/driver-api/ipmi.rst                  |    2 +-
 .../zh_CN/accounting/delay-accounting.rst          |   17 +-
 Makefile                                           |    4 +-
 arch/arm/boot/dts/imx7d-zii-rmu2.dts               |    2 +-
 arch/arm/boot/dts/sam9x60.dtsi                     |    4 +-
 arch/arm/boot/dts/sama7g5.dtsi                     |    2 +-
 arch/arm/crypto/aes-ce-glue.c                      |    2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |    2 +-
 arch/arm/mach-ep93xx/clock.c                       |    2 +-
 arch/arm/mach-versatile/platsmp-realview.c         |    1 +
 arch/arm64/Kconfig                                 |    2 +
 .../boot/dts/exynos/exynos7885-jackpotlte.dts      |    2 +-
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |    1 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   20 +-
 arch/arm64/boot/dts/renesas/r9a07g043u.dtsi        |    4 +-
 arch/arm64/boot/dts/renesas/r9a07g044.dtsi         |    4 +-
 arch/arm64/boot/dts/renesas/r9a07g054.dtsi         |    4 +-
 .../boot/dts/rockchip/rk3399-pinebook-pro.dts      |    4 +-
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |    4 +-
 arch/arm64/include/asm/cputype.h                   |    4 +
 arch/arm64/kernel/cpu_errata.c                     |    2 +
 arch/loongarch/configs/loongson3_defconfig         |    1 -
 arch/loongarch/pci/acpi.c                          |    1 +
 arch/m68k/kernel/process.c                         |    2 +-
 arch/parisc/kernel/entry.S                         |    6 +-
 arch/parisc/kernel/syscall.S                       |   14 +-
 arch/powerpc/Kconfig                               |   23 +
 arch/powerpc/Makefile                              |    4 +
 arch/powerpc/include/asm/asm-compat.h              |    6 +
 arch/powerpc/include/asm/atomic.h                  |   25 +-
 arch/powerpc/include/asm/io.h                      |   37 +
 arch/powerpc/include/asm/uaccess.h                 |   33 +-
 arch/powerpc/include/asm/vdso_datapage.h           |   15 +
 arch/powerpc/kernel/asm-offsets.c                  |    2 +
 arch/powerpc/kernel/head_8xx.S                     |    6 +-
 arch/powerpc/kernel/trace/ftrace.c                 |    2 +
 arch/powerpc/kernel/vdso/cacheflush.S              |    2 +-
 arch/powerpc/kernel/vdso/datapage.S                |    4 +-
 arch/powerpc/mm/nohash/8xx.c                       |    4 +-
 arch/powerpc/platforms/Kconfig.cputype             |   24 +-
 arch/powerpc/platforms/pseries/dlpar.c             |   17 -
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   16 +-
 arch/powerpc/platforms/pseries/pmem.c              |    2 +-
 arch/riscv/Kconfig                                 |    5 +
 arch/riscv/include/asm/sparsemem.h                 |    2 +-
 arch/riscv/kernel/elf_kexec.c                      |    6 +
 arch/riscv/kernel/perf_callchain.c                 |    2 +-
 arch/riscv/kvm/vcpu_sbi.c                          |    4 +-
 arch/s390/boot/Makefile                            |   19 +-
 arch/s390/include/asm/facility.h                   |    6 +-
 arch/s390/kernel/early.c                           |   17 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   12 +-
 arch/s390/mm/cmm.c                                 |   18 +-
 arch/x86/coco/tdx/tdx.c                            |    6 +
 arch/x86/events/core.c                             |   63 +
 arch/x86/events/intel/pt.c                         |   15 +-
 arch/x86/include/asm/hardirq.h                     |    8 +-
 arch/x86/include/asm/idtentry.h                    |   73 +-
 arch/x86/include/asm/syscall.h                     |    7 +-
 arch/x86/kernel/apic/io_apic.c                     |   46 +-
 arch/x86/kernel/cpu/sgx/main.c                     |   27 +-
 arch/x86/kernel/machine_kexec_64.c                 |   27 +
 arch/x86/kvm/lapic.c                               |   35 +-
 arch/x86/net/bpf_jit_comp.c                        |   54 +-
 arch/x86/xen/setup.c                               |    2 +-
 block/bfq-iosched.c                                |   44 +-
 block/blk-integrity.c                              |  175 +-
 block/blk-iocost.c                                 |    8 +-
 block/blk.h                                        |   10 +-
 block/genhd.c                                      |   12 +-
 block/partitions/core.c                            |    8 +-
 crypto/asymmetric_keys/asymmetric_type.c           |    7 +-
 crypto/simd.c                                      |   76 +-
 crypto/xor.c                                       |   31 +-
 drivers/acpi/acpi_pad.c                            |    6 +-
 drivers/acpi/acpica/dbconvert.c                    |    2 +
 drivers/acpi/acpica/exprep.c                       |    3 +
 drivers/acpi/acpica/exsystem.c                     |   11 +-
 drivers/acpi/acpica/psargs.c                       |   47 +
 drivers/acpi/battery.c                             |   28 +-
 drivers/acpi/cppc_acpi.c                           |   43 +-
 drivers/acpi/device_sysfs.c                        |    5 +-
 drivers/acpi/ec.c                                  |   55 +-
 drivers/acpi/pmic/tps68470_pmic.c                  |    6 +-
 drivers/acpi/resource.c                            |   20 +
 drivers/acpi/video_detect.c                        |    8 +
 drivers/ata/libata-eh.c                            |   18 +-
 drivers/ata/pata_serverworks.c                     |   16 +-
 drivers/ata/sata_sil.c                             |   12 +-
 drivers/base/bus.c                                 |    6 +-
 drivers/base/firmware_loader/main.c                |   30 +
 drivers/base/power/domain.c                        |    2 +-
 drivers/block/aoe/aoecmd.c                         |   13 +-
 drivers/block/drbd/drbd_main.c                     |    8 +-
 drivers/block/drbd/drbd_state.c                    |    2 +-
 drivers/block/loop.c                               |   15 +-
 drivers/block/nbd.c                                |   13 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    3 +-
 drivers/bluetooth/btusb.c                          |    7 +-
 drivers/bus/arm-integrator-lm.c                    |    1 +
 drivers/bus/mhi/host/pci_generic.c                 |   13 +-
 drivers/char/hw_random/bcm2835-rng.c               |    4 +-
 drivers/char/hw_random/cctrng.c                    |    1 +
 drivers/char/hw_random/mtk-rng.c                   |    2 +-
 drivers/char/tpm/tpm-dev-common.c                  |    2 +
 drivers/char/tpm/tpm2-space.c                      |    3 +
 drivers/char/virtio_console.c                      |   18 +-
 drivers/clk/bcm/clk-bcm53573-ilp.c                 |    2 +-
 drivers/clk/imx/clk-composite-7ulp.c               |    7 +
 drivers/clk/imx/clk-composite-8m.c                 |   61 +-
 drivers/clk/imx/clk-fracn-gppll.c                  |   72 +-
 drivers/clk/imx/clk-imx6ul.c                       |   37 +-
 drivers/clk/imx/clk-imx7d.c                        |    4 +-
 drivers/clk/imx/clk-imx8mp.c                       |    4 +-
 drivers/clk/imx/clk-imx8qxp.c                      |   10 +-
 drivers/clk/imx/clk.h                              |    7 +
 drivers/clk/qcom/clk-alpha-pll.c                   |   54 +-
 drivers/clk/qcom/clk-alpha-pll.h                   |    2 +
 drivers/clk/qcom/clk-rpmh.c                        |    2 +
 drivers/clk/qcom/dispcc-sm8250.c                   |   12 +-
 drivers/clk/qcom/gcc-sc8180x.c                     |   88 +-
 drivers/clk/qcom/gcc-sm8250.c                      |    6 +-
 drivers/clk/qcom/gcc-sm8450.c                      |    4 +-
 drivers/clk/rockchip/clk-rk3228.c                  |    2 +-
 drivers/clk/rockchip/clk.c                         |    3 +-
 drivers/clk/samsung/clk-exynos7885.c               |   14 +-
 drivers/clk/ti/clk-dra7-atl.c                      |    1 +
 drivers/clocksource/timer-qcom.c                   |    7 +-
 .../drivers/ni_routing/tools/convert_c_to_py.c     |    5 +
 drivers/cpufreq/intel_pstate.c                     |   20 +-
 drivers/cpufreq/ti-cpufreq.c                       |   10 +-
 drivers/crypto/ccp/sev-dev.c                       |    2 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   57 +-
 drivers/crypto/hisilicon/qm.c                      |  180 +-
 drivers/crypto/hisilicon/sec2/sec_main.c           |   16 +-
 drivers/crypto/hisilicon/sgl.c                     |    1 -
 drivers/crypto/hisilicon/zip/zip_main.c            |   23 +-
 drivers/cxl/core/pci.c                             |   60 +-
 drivers/dax/device.c                               |    2 +-
 drivers/edac/igen6_edac.c                          |    2 +-
 drivers/edac/synopsys_edac.c                       |   85 +-
 drivers/firmware/arm_scmi/optee.c                  |    7 +
 drivers/firmware/efi/libstub/tpm.c                 |    2 +-
 drivers/firmware/tegra/bpmp.c                      |    6 -
 drivers/gpio/gpio-aspeed.c                         |    4 +-
 drivers/gpio/gpio-davinci.c                        |    8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   18 +-
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h        |    4 +-
 drivers/gpu/drm/amd/amdgpu/atombios_encoders.c     |   26 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |    4 +
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |    1 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   22 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |    5 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |    3 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |    8 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    6 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |    2 +
 .../gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |    4 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    6 +-
 .../dc/dml/dcn20/display_rq_dlg_calc_20v2.c        |    2 +-
 .../display/dc/dml/dcn21/display_rq_dlg_calc_21.c  |    2 +-
 .../drm/amd/display/modules/freesync/freesync.c    |    2 +-
 drivers/gpu/drm/amd/include/atombios.h             |    2 +-
 .../drm/amd/pm/powerplay/hwmgr/processpptables.c   |    2 +
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |   35 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |    2 +-
 drivers/gpu/drm/drm_crtc.c                         |    1 +
 drivers/gpu/drm/drm_print.c                        |   13 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |    2 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   32 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   12 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.h              |    2 +
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c          |   30 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |    2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c           |    2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |    2 +-
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    5 +
 drivers/gpu/drm/radeon/atombios.h                  |    2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |   62 +-
 drivers/gpu/drm/radeon/r100.c                      |   70 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   26 +-
 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c        |    2 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   20 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |    7 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.h       |    5 -
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c        |   20 +
 drivers/gpu/drm/scheduler/sched_entity.c           |    2 +
 drivers/gpu/drm/stm/drv.c                          |    7 +-
 drivers/gpu/drm/stm/ltdc.c                         |   78 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    9 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |    8 +-
 drivers/gpu/drm/vc4/vc4_perfmon.c                  |    7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |   12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    3 +
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   14 +-
 drivers/hid/hid-ids.h                              |    4 +
 drivers/hid/hid-multitouch.c                       |   14 +-
 drivers/hid/hid-plantronics.c                      |   23 +
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c        |    2 +-
 drivers/hid/wacom_wac.c                            |   13 +-
 drivers/hid/wacom_wac.h                            |    2 +-
 drivers/hwmon/Kconfig                              |    3 +
 drivers/hwmon/max16065.c                           |   27 +-
 drivers/hwmon/ntc_thermistor.c                     |    1 +
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |    2 +-
 drivers/i2c/busses/i2c-aspeed.c                    |   16 +-
 drivers/i2c/busses/i2c-i801.c                      |    9 +-
 drivers/i2c/busses/i2c-isch.c                      |    3 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |    4 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |    6 +-
 drivers/i2c/busses/i2c-xiic.c                      |   89 +-
 drivers/i2c/i2c-core-base.c                        |   58 +
 drivers/iio/adc/ad7606.c                           |    8 +-
 drivers/iio/adc/ad7606_spi.c                       |    5 +-
 drivers/iio/chemical/bme680_core.c                 |    7 +
 drivers/iio/magnetometer/ak8975.c                  |  117 +-
 drivers/infiniband/core/cache.c                    |    4 +-
 drivers/infiniband/core/iwcm.c                     |    2 +-
 drivers/infiniband/core/mad.c                      |   14 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    5 +
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   25 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   22 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   29 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   16 +-
 drivers/infiniband/hw/irdma/verbs.c                |    2 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   25 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |    9 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   14 +-
 drivers/input/keyboard/adp5588-keys.c              |    2 +-
 drivers/input/keyboard/adp5589-keys.c              |   22 +-
 drivers/input/rmi4/rmi_driver.c                    |    6 +-
 drivers/input/serio/i8042-acpipnpio.h              |   37 +
 drivers/input/touchscreen/ilitek_ts_i2c.c          |   18 +-
 drivers/iommu/amd/io_pgtable_v2.c                  |    2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |    7 +
 drivers/iommu/intel/Kconfig                        |   11 -
 drivers/iommu/intel/Makefile                       |    1 -
 drivers/iommu/intel/dmar.c                         |   23 +-
 drivers/iommu/intel/iommu.c                        |    6 +-
 drivers/iommu/intel/iommu.h                        |   43 +-
 drivers/iommu/intel/perfmon.c                      |  172 -
 drivers/iommu/intel/perfmon.h                      |   40 -
 drivers/mailbox/bcm2835-mailbox.c                  |    3 +-
 drivers/mailbox/rockchip-mailbox.c                 |    2 +-
 drivers/md/dm-rq.c                                 |    4 +-
 drivers/md/dm.c                                    |   11 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |    8 +-
 drivers/media/dvb-frontends/rtl2830.c              |    2 +-
 drivers/media/dvb-frontends/rtl2832.c              |    2 +-
 drivers/media/i2c/ar0521.c                         |    5 +-
 drivers/media/i2c/imx335.c                         |   43 +-
 drivers/media/platform/qcom/camss/camss.c          |    5 +-
 drivers/media/platform/qcom/venus/core.c           |    1 +
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c |    5 +
 drivers/media/tuners/tuner-i2c.h                   |    4 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    7 -
 drivers/mtd/devices/powernv_flash.c                |    3 +
 drivers/mtd/devices/slram.c                        |    2 +
 drivers/mtd/nand/raw/mtk_nand.c                    |   36 +-
 drivers/net/bareudp.c                              |   26 +-
 drivers/net/bonding/bond_main.c                    |    6 +-
 drivers/net/can/m_can/m_can.c                      |   18 +-
 drivers/net/dsa/b53/b53_common.c                   |   17 +-
 drivers/net/dsa/lan9303-core.c                     |   29 +
 drivers/net/ethernet/adi/adin1110.c                |    4 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    2 +-
 drivers/net/ethernet/cortina/gemini.c              |   32 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    3 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |    1 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    1 +
 drivers/net/ethernet/hisilicon/hns_mdio.c          |    1 +
 drivers/net/ethernet/ibm/emac/mal.c                |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +
 drivers/net/ethernet/intel/ice/ice_main.c          |    3 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |    6 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |    2 -
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/lantiq_etop.c                 |    4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |    1 -
 .../net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c  |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    2 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |    1 +
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |    6 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   31 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |    2 +
 drivers/net/ethernet/seeq/ether3.c                 |    2 +
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |    3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |    1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   37 +-
 drivers/net/ieee802154/Kconfig                     |    1 +
 drivers/net/ieee802154/mcr20a.c                    |    5 +-
 drivers/net/phy/bcm84881.c                         |    4 +-
 drivers/net/phy/dp83869.c                          |    1 -
 drivers/net/ppp/ppp_async.c                        |    2 +-
 drivers/net/ppp/ppp_generic.c                      |    4 +-
 drivers/net/slip/slhc.c                            |   57 +-
 drivers/net/usb/usbnet.c                           |   37 +-
 drivers/net/vxlan/vxlan_core.c                     |    6 +-
 drivers/net/vxlan/vxlan_private.h                  |    2 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   19 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    6 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c     |    2 -
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   13 +
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   42 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    3 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    8 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    3 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   10 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |    1 +
 drivers/net/wireless/realtek/rtw88/coex.c          |   38 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    7 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   12 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |    4 +-
 drivers/net/wwan/qcom_bam_dmux.c                   |   11 +-
 drivers/net/xen-netback/hash.c                     |    5 +-
 drivers/ntb/hw/intel/ntb_hw_gen1.c                 |    2 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |    1 +
 drivers/ntb/ntb_transport.c                        |   23 +-
 drivers/ntb/test/ntb_perf.c                        |    2 +-
 drivers/nvdimm/namespace_devs.c                    |   34 +-
 drivers/nvdimm/nd_virtio.c                         |    9 +
 drivers/nvme/host/multipath.c                      |    2 +-
 drivers/nvme/host/nvme.h                           |    5 +
 drivers/nvme/host/pci.c                            |   18 +-
 drivers/of/irq.c                                   |   38 +-
 drivers/pci/controller/dwc/pci-imx6.c              |    7 +-
 drivers/pci/controller/dwc/pci-keystone.c          |    2 +-
 drivers/pci/controller/dwc/pcie-kirin.c            |    4 +-
 drivers/pci/controller/pcie-xilinx-nwl.c           |   39 +-
 drivers/pci/pci-driver.c                           |   15 +-
 drivers/pci/pci.c                                  |   26 +-
 drivers/pci/pci.h                                  |    9 +-
 drivers/pci/pcie/dpc.c                             |    3 +-
 drivers/pci/quirks.c                               |    8 +
 drivers/perf/alibaba_uncore_drw_pmu.c              |    2 +-
 drivers/perf/arm-cmn.c                             |  232 +-
 drivers/perf/hisilicon/hisi_pcie_pmu.c             |   14 +
 drivers/pinctrl/mvebu/pinctrl-dove.c               |   45 +-
 drivers/pinctrl/pinctrl-single.c                   |    3 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |    4 +-
 drivers/platform/x86/touchscreen_dmi.c             |   26 +
 drivers/power/reset/brcmstb-reboot.c               |    3 -
 drivers/power/supply/axp20x_battery.c              |   16 +-
 drivers/power/supply/max17042_battery.c            |    5 +-
 drivers/power/supply/power_supply_hwmon.c          |    3 +-
 drivers/pps/clients/pps_parport.c                  |   14 +-
 drivers/regulator/of_regulator.c                   |    2 +-
 drivers/remoteproc/imx_rproc.c                     |   19 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   86 +-
 drivers/reset/reset-berlin.c                       |    3 +-
 drivers/reset/reset-k210.c                         |    3 +-
 drivers/rtc/rtc-at91sam9.c                         |    1 +
 drivers/scsi/NCR5380.c                             |   82 +-
 drivers/scsi/aacraid/aacraid.h                     |    2 +-
 drivers/scsi/elx/libefc/efc_nport.c                |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   12 +
 drivers/scsi/lpfc/lpfc_disc.h                      |    7 +
 drivers/scsi/lpfc/lpfc_els.c                       |   34 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   22 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   43 +-
 drivers/scsi/mac_scsi.c                            |  166 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    6 +-
 drivers/scsi/sd.c                                  |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   22 +-
 drivers/scsi/wd33c93.c                             |    2 +-
 drivers/soc/versatile/soc-integrator.c             |    1 +
 drivers/soc/versatile/soc-realview.c               |   20 +-
 drivers/spi/atmel-quadspi.c                        |    1 +
 drivers/spi/spi-bcm63xx.c                          |    9 +-
 drivers/spi/spi-fsl-lpspi.c                        |    1 +
 drivers/spi/spi-imx.c                              |    2 +-
 drivers/spi/spi-ppc4xx.c                           |    7 +-
 drivers/spi/spi-s3c64xx.c                          |    4 +-
 drivers/staging/vme_user/vme_fake.c                |    6 +
 drivers/staging/vme_user/vme_tsi148.c              |    6 +
 .../int340x_thermal/processor_thermal_device_pci.c |   23 +-
 drivers/tty/serial/rp2.c                           |    2 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |    6 +-
 drivers/usb/cdns3/host.c                           |    4 +-
 drivers/usb/chipidea/udc.c                         |    8 +-
 drivers/usb/class/cdc-acm.c                        |    2 +
 drivers/usb/dwc2/drd.c                             |    9 +
 drivers/usb/dwc2/platform.c                        |   26 +-
 drivers/usb/dwc3/core.c                            |   22 +-
 drivers/usb/dwc3/core.h                            |    4 -
 drivers/usb/dwc3/gadget.c                          |   11 -
 drivers/usb/gadget/udc/core.c                      |    1 +
 drivers/usb/host/xhci-debugfs.c                    |    2 +-
 drivers/usb/host/xhci-mem.c                        |  331 +-
 drivers/usb/host/xhci-pci.c                        |   22 +-
 drivers/usb/host/xhci-ring.c                       |   82 +-
 drivers/usb/host/xhci.c                            |   54 +-
 drivers/usb/host/xhci.h                            |   32 +-
 drivers/usb/misc/appledisplay.c                    |   15 +-
 drivers/usb/misc/cypress_cy7c63.c                  |    4 +
 drivers/usb/misc/yurex.c                           |    5 +-
 drivers/usb/storage/unusual_devs.h                 |   11 +
 drivers/vfio/pci/vfio_pci_intrs.c                  |    4 +-
 drivers/vhost/scsi.c                               |   25 +-
 drivers/vhost/vdpa.c                               |   18 +-
 drivers/video/fbdev/core/fbcon.c                   |    2 +
 drivers/video/fbdev/hpfb.c                         |    1 +
 drivers/video/fbdev/pxafb.c                        |    1 +
 drivers/video/fbdev/sis/sis_main.c                 |    2 +-
 drivers/virtio/virtio_vdpa.c                       |    1 +
 drivers/watchdog/imx_sc_wdt.c                      |   24 -
 drivers/xen/swiotlb-xen.c                          |   10 +-
 fs/btrfs/disk-io.c                                 |   11 +
 fs/btrfs/relocation.c                              |    2 +-
 fs/btrfs/send.c                                    |   23 +-
 fs/btrfs/zoned.c                                   |    2 +-
 fs/cachefiles/namei.c                              |    7 +-
 fs/ceph/addr.c                                     |    6 +-
 fs/crypto/fname.c                                  |    8 +-
 fs/dax.c                                           |   62 +
 fs/ecryptfs/crypto.c                               |   10 -
 fs/erofs/data.c                                    |   50 +-
 fs/erofs/decompressor.c                            |    6 +-
 fs/erofs/decompressor_lzma.c                       |    4 +-
 fs/erofs/dir.c                                     |   22 +-
 fs/erofs/erofs_fs.h                                |    5 +-
 fs/erofs/fscache.c                                 |    7 +-
 fs/erofs/inode.c                                   |   37 +-
 fs/erofs/internal.h                                |   34 +-
 fs/erofs/namei.c                                   |   30 +-
 fs/erofs/super.c                                   |   72 +-
 fs/erofs/xattr.c                                   |   40 +-
 fs/erofs/xattr.h                                   |   10 +-
 fs/erofs/zdata.c                                   |   16 +-
 fs/erofs/zmap.c                                    |  263 +-
 fs/exec.c                                          |    3 +-
 fs/exfat/balloc.c                                  |   10 +-
 fs/ext4/dir.c                                      |   14 +-
 fs/ext4/extents.c                                  |   55 +-
 fs/ext4/fast_commit.c                              |   49 +-
 fs/ext4/file.c                                     |    8 +-
 fs/ext4/ialloc.c                                   |   14 +-
 fs/ext4/inline.c                                   |   35 +-
 fs/ext4/inode.c                                    |   11 +-
 fs/ext4/mballoc.c                                  |   10 +-
 fs/ext4/migrate.c                                  |    2 +-
 fs/ext4/move_extent.c                              |    1 -
 fs/ext4/namei.c                                    |   14 +-
 fs/ext4/super.c                                    |    9 +-
 fs/ext4/xattr.c                                    |    7 +-
 fs/f2fs/dir.c                                      |    3 +-
 fs/f2fs/extent_cache.c                             |    4 +-
 fs/f2fs/f2fs.h                                     |   24 +-
 fs/f2fs/file.c                                     |   96 +-
 fs/f2fs/namei.c                                    |   69 -
 fs/f2fs/super.c                                    |    4 +-
 fs/f2fs/xattr.c                                    |   18 +-
 fs/fcntl.c                                         |   14 +-
 fs/file.c                                          |   93 +-
 fs/inode.c                                         |    4 +
 fs/iomap/buffered-io.c                             |   16 +-
 fs/jbd2/checkpoint.c                               |   21 +-
 fs/jbd2/journal.c                                  |    4 +-
 fs/jfs/jfs_discard.c                               |   11 +-
 fs/jfs/jfs_dmap.c                                  |   11 +-
 fs/jfs/jfs_imap.c                                  |    2 +-
 fs/jfs/xattr.c                                     |    2 +
 fs/namei.c                                         |    6 +-
 fs/namespace.c                                     |   21 +-
 fs/nfs/callback_xdr.c                              |    2 +
 fs/nfs/client.c                                    |    1 +
 fs/nfs/nfs42proc.c                                 |    2 +-
 fs/nfs/nfs4state.c                                 |    3 +-
 fs/nfsd/filecache.c                                |    7 +-
 fs/nfsd/nfs4idmap.c                                |   13 +-
 fs/nfsd/nfs4recover.c                              |    8 +
 fs/nfsd/nfs4state.c                                |    5 +-
 fs/nfsd/nfs4xdr.c                                  |   10 +-
 fs/nfsd/vfs.c                                      |    1 +
 fs/nilfs2/btree.c                                  |   12 +-
 fs/ntfs3/file.c                                    |    4 +-
 fs/ntfs3/frecord.c                                 |   21 +-
 fs/ntfs3/fslog.c                                   |   19 +-
 fs/ocfs2/aops.c                                    |    5 +-
 fs/ocfs2/buffer_head_io.c                          |    4 +-
 fs/ocfs2/journal.c                                 |    7 +-
 fs/ocfs2/localalloc.c                              |   19 +
 fs/ocfs2/quota_local.c                             |    8 +-
 fs/ocfs2/refcounttree.c                            |   26 +-
 fs/ocfs2/xattr.c                                   |   11 +-
 fs/proc/base.c                                     |   61 +-
 fs/smb/client/cifsfs.c                             |   13 +-
 fs/smb/client/cifsglob.h                           |    2 +-
 fs/smb/client/smb1ops.c                            |    2 +-
 fs/smb/client/smb2ops.c                            |   19 +-
 fs/smb/server/vfs.c                                |   19 +-
 fs/unicode/mkutf8data.c                            |   70 -
 fs/unicode/utf8data.c_shipped                      | 6703 ++++++++++----------
 fs/xfs/xfs_reflink.c                               |    8 +-
 include/acpi/acoutput.h                            |    5 +
 include/acpi/cppc_acpi.h                           |    2 +
 include/crypto/internal/simd.h                     |   12 +-
 include/drm/drm_print.h                            |   54 +-
 include/dt-bindings/clock/exynos7885.h             |    4 +-
 include/dt-bindings/clock/imx6ul-clock.h           |    7 +-
 include/dt-bindings/clock/qcom,gcc-sc8180x.h       |    3 +
 include/linux/blkdev.h                             |    3 -
 include/linux/dax.h                                |    2 +
 include/linux/f2fs_fs.h                            |    2 +-
 include/linux/fdtable.h                            |    8 +-
 include/linux/fs.h                                 |   11 +
 include/linux/i2c.h                                |    7 +
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |    6 +-
 include/linux/nfs_fs_sb.h                          |    1 +
 include/linux/pci_ids.h                            |    2 +
 include/linux/sbitmap.h                            |    2 +-
 include/linux/uprobes.h                            |    2 +
 include/linux/usb/usbnet.h                         |   15 +
 include/linux/vdpa.h                               |    6 +
 include/linux/xarray.h                             |    6 +
 include/net/bluetooth/hci_core.h                   |    4 +-
 include/net/ip.h                                   |    2 +
 include/net/mac80211.h                             |    7 +-
 include/net/mctp.h                                 |    2 +-
 include/net/rtnetlink.h                            |   17 +
 include/net/sch_generic.h                          |    1 -
 include/net/sock.h                                 |    2 +
 include/net/tcp.h                                  |   21 +-
 include/trace/events/erofs.h                       |    4 +-
 include/trace/events/f2fs.h                        |    3 +-
 include/uapi/linux/cec.h                           |    6 +-
 include/uapi/linux/netfilter/nf_tables.h           |    2 +-
 include/uapi/linux/snmp.h                          |    3 +
 io_uring/io-wq.c                                   |   33 +-
 io_uring/io_uring.c                                |   15 +
 io_uring/net.c                                     |    4 +-
 io_uring/sqpoll.c                                  |   12 +
 kernel/bpf/arraymap.c                              |    3 +
 kernel/bpf/btf.c                                   |    8 +
 kernel/bpf/hashtab.c                               |    3 +
 kernel/bpf/helpers.c                               |    6 +-
 kernel/bpf/syscall.c                               |    1 +
 kernel/bpf/verifier.c                              |   16 +-
 kernel/events/core.c                               |    6 +-
 kernel/events/uprobes.c                            |    4 +-
 kernel/fork.c                                      |   30 +-
 kernel/jump_label.c                                |   52 +-
 kernel/kthread.c                                   |   12 +-
 kernel/locking/lockdep.c                           |   50 +-
 kernel/module/Makefile                             |    2 +-
 kernel/padata.c                                    |    6 +-
 kernel/rcu/rcuscale.c                              |    4 +-
 kernel/rcu/tree_nocb.h                             |    5 +-
 kernel/resource.c                                  |   58 +-
 kernel/sched/psi.c                                 |   26 +-
 kernel/static_call_inline.c                        |   13 +-
 kernel/trace/trace.c                               |   18 +-
 kernel/trace/trace_hwlat.c                         |    2 +
 kernel/trace/trace_osnoise.c                       |    2 +
 kernel/trace/trace_output.c                        |    6 +-
 lib/bootconfig.c                                   |    3 +-
 lib/buildid.c                                      |   88 +-
 lib/debugobjects.c                                 |    5 +-
 lib/sbitmap.c                                      |    4 +-
 lib/test_xarray.c                                  |   93 +
 lib/xarray.c                                       |   53 +-
 lib/xz/xz_crc32.c                                  |    2 +-
 lib/xz/xz_private.h                                |    4 -
 mm/Kconfig                                         |   25 +-
 mm/damon/vaddr.c                                   |    2 +
 mm/filemap.c                                       |   50 +-
 mm/secretmem.c                                     |    4 +-
 mm/slab_common.c                                   |    7 +
 mm/util.c                                          |    2 +-
 net/bluetooth/hci_conn.c                           |    6 +-
 net/bluetooth/hci_core.c                           |   27 +-
 net/bluetooth/hci_event.c                          |   13 +-
 net/bluetooth/hci_sock.c                           |   21 +-
 net/bluetooth/hci_sync.c                           |    5 +-
 net/bluetooth/mgmt.c                               |   13 +-
 net/bluetooth/rfcomm/sock.c                        |    2 -
 net/bridge/br_netfilter_hooks.c                    |    5 +
 net/can/bcm.c                                      |    4 +-
 net/can/j1939/transport.c                          |    8 +-
 net/core/dev.c                                     |   12 +-
 net/core/filter.c                                  |   44 +-
 net/core/rtnetlink.c                               |   29 +
 net/core/sock_map.c                                |    1 +
 net/ipv4/devinet.c                                 |    6 +-
 net/ipv4/fib_frontend.c                            |    2 +-
 net/ipv4/icmp.c                                    |  106 +-
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/netfilter/nf_dup_ipv4.c                   |    7 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   10 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |    4 +-
 net/ipv4/proc.c                                    |    8 +-
 net/ipv4/tcp_input.c                               |   31 +-
 net/ipv4/tcp_ipv4.c                                |    3 +
 net/ipv4/udp_offload.c                             |   22 +-
 net/ipv6/Kconfig                                   |    1 +
 net/ipv6/icmp.c                                    |   32 +-
 net/ipv6/netfilter/nf_dup_ipv6.c                   |    7 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |   19 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |    5 +-
 net/ipv6/proc.c                                    |    1 +
 net/ipv6/route.c                                   |    2 +-
 net/ipv6/rpl_iptunnel.c                            |   12 +-
 net/mac80211/chan.c                                |    4 +-
 net/mac80211/iface.c                               |   17 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/offchannel.c                          |    1 +
 net/mac80211/rate.c                                |    2 +-
 net/mac80211/scan.c                                |   21 +-
 net/mac80211/tx.c                                  |    2 +-
 net/mac80211/util.c                                |    4 +-
 net/mctp/af_mctp.c                                 |    6 +-
 net/mctp/device.c                                  |   32 +-
 net/mctp/neigh.c                                   |   29 +-
 net/mctp/route.c                                   |   33 +-
 net/mptcp/mib.c                                    |    2 +
 net/mptcp/mib.h                                    |    2 +
 net/mptcp/pm_netlink.c                             |    3 +-
 net/mptcp/protocol.c                               |   24 +-
 net/mptcp/subflow.c                                |    6 +-
 net/netfilter/nf_conntrack_netlink.c               |    7 +-
 net/netfilter/nf_tables_api.c                      |   14 +-
 net/netfilter/xt_CHECKSUM.c                        |   33 +-
 net/netfilter/xt_CLASSIFY.c                        |   16 +-
 net/netfilter/xt_CONNSECMARK.c                     |   36 +-
 net/netfilter/xt_CT.c                              |  148 +-
 net/netfilter/xt_IDLETIMER.c                       |   59 +-
 net/netfilter/xt_LED.c                             |   39 +-
 net/netfilter/xt_NFLOG.c                           |   36 +-
 net/netfilter/xt_RATEEST.c                         |   39 +-
 net/netfilter/xt_SECMARK.c                         |   27 +-
 net/netfilter/xt_TRACE.c                           |   35 +-
 net/netfilter/xt_addrtype.c                        |   15 +-
 net/netfilter/xt_cluster.c                         |   33 +-
 net/netfilter/xt_connbytes.c                       |    4 +-
 net/netfilter/xt_connlimit.c                       |   39 +-
 net/netfilter/xt_connmark.c                        |   28 +-
 net/netfilter/xt_mark.c                            |   42 +-
 net/netlink/af_netlink.c                           |    3 +-
 net/qrtr/af_qrtr.c                                 |    2 +-
 net/sched/sch_api.c                                |    7 +-
 net/sched/sch_taprio.c                             |    4 +-
 net/sctp/socket.c                                  |   20 +-
 net/socket.c                                       |    7 +-
 net/tipc/bcast.c                                   |    2 +-
 net/tipc/bearer.c                                  |    8 +-
 net/wireless/nl80211.c                             |   18 +-
 net/wireless/scan.c                                |    6 +-
 net/wireless/sme.c                                 |    3 +-
 rust/macros/module.rs                              |    6 +-
 scripts/kconfig/qconf.cc                           |    2 +-
 security/Kconfig                                   |   32 +
 security/bpf/hooks.c                               |    1 -
 security/selinux/hooks.c                           |    4 +-
 security/smack/smack_lsm.c                         |    4 +-
 security/smack/smackfs.c                           |    2 +-
 security/tomoyo/domain.c                           |    9 +-
 sound/core/init.c                                  |   14 +-
 sound/core/oss/mixer_oss.c                         |    4 +-
 sound/pci/asihpi/hpimsgx.c                         |    2 +-
 sound/pci/hda/cs35l41_hda_spi.c                    |    1 +
 sound/pci/hda/hda_controller.h                     |    2 +-
 sound/pci/hda/hda_generic.c                        |    4 +-
 sound/pci/hda/hda_intel.c                          |   12 +-
 sound/pci/hda/patch_conexant.c                     |   24 +-
 sound/pci/hda/patch_realtek.c                      |   10 +-
 sound/pci/rme9652/hdsp.c                           |    6 +-
 sound/pci/rme9652/hdspm.c                          |    6 +-
 sound/soc/atmel/mchp-pdmc.c                        |    3 +
 sound/soc/codecs/rt5682.c                          |    4 +-
 sound/soc/codecs/rt5682s.c                         |    4 +-
 sound/soc/codecs/wsa883x.c                         |   16 +-
 sound/soc/fsl/imx-card.c                           |    1 +
 sound/usb/card.c                                   |    6 +
 sound/usb/line6/podhd.c                            |    2 +-
 sound/usb/mixer.c                                  |   35 +-
 sound/usb/mixer.h                                  |    1 +
 sound/usb/quirks-table.h                           | 2283 ++-----
 sound/usb/quirks.c                                 |    4 +
 tools/accounting/getdelays.c                       |   24 +-
 tools/arch/x86/kcpuid/kcpuid.c                     |   12 +-
 tools/iio/iio_generic_buffer.c                     |    4 +
 tools/lib/subcmd/parse-options.c                   |    8 +-
 tools/perf/builtin-inject.c                        |    1 +
 tools/perf/builtin-kmem.c                          |    2 +
 tools/perf/builtin-kvm.c                           |    3 +
 tools/perf/builtin-kwork.c                         |    3 +
 tools/perf/builtin-lock.c                          |   24 +-
 tools/perf/builtin-mem.c                           |    4 +
 tools/perf/builtin-sched.c                         |  160 +-
 tools/perf/util/hist.c                             |    7 +-
 tools/perf/util/session.c                          |    3 +
 tools/perf/util/stat-display.c                     |    3 +-
 tools/perf/util/time-utils.c                       |    4 +-
 tools/perf/util/tool.h                             |    1 +
 tools/testing/ktest/ktest.pl                       |    2 +-
 tools/testing/selftests/arm64/signal/Makefile      |    8 +-
 tools/testing/selftests/arm64/signal/sve_helpers.c |   56 +
 tools/testing/selftests/arm64/signal/sve_helpers.h |   21 +
 .../testcases/fake_sigreturn_sme_change_vl.c       |   46 +-
 .../testcases/fake_sigreturn_sve_change_vl.c       |   30 +-
 .../selftests/arm64/signal/testcases/ssve_regs.c   |   36 +-
 .../arm64/signal/testcases/ssve_za_regs.c          |  146 +
 .../selftests/arm64/signal/testcases/sve_regs.c    |   32 +-
 .../selftests/arm64/signal/testcases/za_no_regs.c  |   32 +-
 .../selftests/arm64/signal/testcases/za_regs.c     |   36 +-
 tools/testing/selftests/bpf/DENYLIST.s390x         |    2 +
 tools/testing/selftests/bpf/bench.c                |    1 +
 tools/testing/selftests/bpf/bench.h                |    1 +
 .../selftests/bpf/map_tests/sk_storage_map.c       |    2 +-
 .../selftests/bpf/prog_tests/bpf_iter_setsockopt.c |    2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    1 +
 .../selftests/bpf/prog_tests/flow_dissector.c      |    1 +
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |    1 +
 .../bpf/prog_tests/libbpf_get_fd_by_id_opts.c      |   87 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |  156 +-
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |   19 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   17 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |    1 +
 .../selftests/bpf/prog_tests/user_ringbuf.c        |    1 +
 .../testing/selftests/bpf/progs/cg_storage_multi.h |    2 -
 .../bpf/progs/test_libbpf_get_fd_by_id_opts.c      |   37 +
 .../selftests/bpf/progs/test_ns_current_pid_tgid.c |   17 +-
 tools/testing/selftests/bpf/test_cpp.cpp           |    4 +
 tools/testing/selftests/bpf/test_lru_map.c         |    3 +-
 tools/testing/selftests/bpf/test_progs.c           |  110 +-
 tools/testing/selftests/bpf/test_progs.h           |    2 -
 tools/testing/selftests/bpf/testing_helpers.c      |   63 +
 tools/testing/selftests/bpf/testing_helpers.h      |    9 +
 .../breakpoints/step_after_suspend_test.c          |    5 +-
 .../selftests/net/forwarding/no_forwarding.sh      |    2 +-
 tools/testing/selftests/net/net_helper.sh          |    0
 tools/testing/selftests/net/setup_loopback.sh      |    0
 tools/testing/selftests/netfilter/nft_audit.sh     |   57 +-
 tools/testing/selftests/nolibc/nolibc-test.c       |    4 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |   17 +-
 tools/testing/selftests/vDSO/vdso_config.h         |   10 +-
 .../testing/selftests/vDSO/vdso_test_correctness.c |    6 +
 .../selftests/vm/charge_reserved_hugetlb.sh        |    2 +-
 tools/testing/selftests/vm/write_to_hugetlbfs.c    |   23 +-
 762 files changed, 11900 insertions(+), 9631 deletions(-)


