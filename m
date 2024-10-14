Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0084A24;
	Mon, 14 Oct 2024 14:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916587; cv=none; b=P4Yj6L2EHWfserxEpTAM8gPMacgOfz3ZznYSHMmuzjOyYbktHGjKSZ0GudfJtu1SLRhpBOoIMA+OUpsvHfCPBHosB9MrXv6eQWzCXK0SW6t8XJ+sDn4rWFWJAsTHersCPY++PMLwqTDWEo5U0OMDoXj+LgPcv/nBGS8CaPmt+No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916587; c=relaxed/simple;
	bh=7dtsCQmh23TotuY2a8ICmea0rl+/iQ4cJILqkOUdIl8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T3G8zJVTlYTs11IZXXh7uBU5lW/I01mh7MB52WgN3ai7v5esrRJ1ZGZZkDwBKTXY6zTcwCP/mz2yeyOAO2O5Rlqo7+b2pzkc+NZgmfAbEleGwW8MdFhyAUfzimfYQ2thjoU5ql4IyCb3+1IzuC5lc16zed1ByV2ue8pFX0Q945s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUtn0WyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUtn0WyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA68C4CEC7;
	Mon, 14 Oct 2024 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916587;
	bh=7dtsCQmh23TotuY2a8ICmea0rl+/iQ4cJILqkOUdIl8=;
	h=From:To:Cc:Subject:Date:From;
	b=sUtn0WyJnSImEyu4BGwQ+p+cm/5nuv8NpYY74C7fFo2y+abtZcKEq4ITUfWZa68d3
	 x6g8f/Ag8ZnqxgJLlzy3Qo5bA0AKxeIVYkOWLkbn+yMf5zuvI597QFa/EZnFJJbLGo
	 +BQb8LF4syA+BJiLmpMgvNMzc6al5XihkITR8SiE=
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
Subject: [PATCH 6.6 000/213] 6.6.57-rc1 review
Date: Mon, 14 Oct 2024 16:18:26 +0200
Message-ID: <20241014141042.954319779@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.57-rc1
X-KernelTest-Deadline: 2024-10-16T14:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.57 release.
There are 213 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.57-rc1

Johan Hovold <johan+linaro@kernel.org>
    scsi: Revert "scsi: sd: Do not repeat the starting disk message"

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: fix force smbus during suspend flow

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Restore TSO support

Patrick Roy <roypat@amazon.co.uk>
    secretmem: disable memfd_secret() if arch cannot set direct map

Alexander Gordeev <agordeev@linux.ibm.com>
    fs/proc/kcore.c: allow translation of physical memory addresses

Frederic Weisbecker <frederic@kernel.org>
    kthread: unpark only parked kthread

Luca Stefani <luca.stefani.ge1@gmail.com>
    btrfs: split remaining space to discard in chunks

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    selftests/rseq: Fix mm_cid test failure

Donet Tom <donettom@linux.ibm.com>
    selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl_tpmi: Fix bogus register reading

Yonatan Maman <Ymaman@Nvidia.com>
    nouveau/dmem: Fix vulnerability in migrate_to_ram upon copy error

Kun(llfl) <llfl@linux.alibaba.com>
    device-dax: correct pgoff align in dax_set_mapping()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not remove closing subflows

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle consistently DSS corruption

Christian Marangi <ansuelsmth@gmail.com>
    net: phy: Remove LED entry from LEDs list on unregister

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

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()

Daniel Palmer <daniel@0x0f.com>
    scsi: wd33c93: Don't use stale scsi_pointer value

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix UAF in hci_enhanced_setup_sync

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: fix connector refcounting

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

He Lugang <helugang@uniontech.com>
    HID: multitouch: Add support for lenovo Y9000P Touchpad

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Switch to device-managed dmam_alloc_coherent()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (adt7470) Add missing dependency on REGMAP_I2C

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (adm9240) Add missing dependency on REGMAP_I2C

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (mc34vr500) Add missing dependency on REGMAP_I2C

Guenter Roeck <linux@roeck-us.net>
    hwmon: (tmp513) Add missing dependency on REGMAP_I2C

Peter Colberg <peter.colberg@intel.com>
    hwmon: intel-m10-bmc-hwmon: relabel Columbiaville to CVL Die Temperature

Kenton Groombridge <concord@gentoo.org>
    wifi: mac80211: Avoid address calculations via out of bounds array indexing

Luke D. Jones <luke@ljones.dev>
    hid-asus: add ROG Ally X prod ID to quirk list

Luke D. Jones <luke@ljones.dev>
    HID: asus: add ROG Z13 lightbar

Luke D. Jones <luke@ljones.dev>
    HID: asus: add ROG Ally N-Key ID and keycodes

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: i2c-hid: Skip SET_POWER SLEEP for Cirque touchpad on system suspend

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Renumber I2C_HID_QUIRK_ defines

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Remove I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV quirk

Johannes Roith <johannes@gnu-linux.rocks>
    HID: mcp2200: added driver for GPIOs of MCP2200

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Fix rcuog wake-up from offline softirq

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Make IRQs disablement symmetric

Eric Dumazet <edumazet@google.com>
    slip: make slhc_remember() more robust against malicious packets

Eric Dumazet <edumazet@google.com>
    ppp: fix ppp_async_encode() illegal access

Kuniyuki Iwashima <kuniyu@amazon.com>
    phonet: Handle error of rtnl_register_module().

Eric Dumazet <edumazet@google.com>
    phonet: no longer hold RTNL in route_dumpit()

Kuniyuki Iwashima <kuniyu@amazon.com>
    mpls: Handle error of rtnl_register_module().

Eric Dumazet <edumazet@google.com>
    mpls: no longer hold RTNL in mpls_netconf_dump_devconf()

Eric Dumazet <edumazet@google.com>
    rtnetlink: add RTNL_FLAG_DUMP_UNLOCKED flag

Eric Dumazet <edumazet@google.com>
    rtnetlink: change nlk->cb_mutex role

Kuniyuki Iwashima <kuniyu@amazon.com>
    mctp: Handle error of rtnl_register_module().

Kuniyuki Iwashima <kuniyu@amazon.com>
    bridge: Handle error of rtnl_register_module().

Kuniyuki Iwashima <kuniyu@amazon.com>
    vxlan: Handle error of rtnl_register_module().

Kuniyuki Iwashima <kuniyu@amazon.com>
    rtnetlink: Add bulk registration helpers for rtnetlink message handlers.

Eric Dumazet <edumazet@google.com>
    net: do not delay dst_entries_add() in dst_release()

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

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: change I219 (19) devices to ADP

Mohamed Khalfella <mkhalfella@purestorage.com>
    igb: Do not bring the device up after non-fatal error

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Fix macvlan leak by synchronizing access to mac_filter_hash

Wojciech Drewek <wojciech.drewek@intel.com>
    ice: Flush FDB entries before reset

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: rename switchdev to eswitch

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix netif_is_ice() in Safe Mode

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl_tpmi: Ignore minor version change

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel/tpmi: Add defines to get version information

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Use devm_clk api to manage clock source

Billy Tsai <billy_tsai@aspeedtech.com>
    gpio: aspeed: Add the flush write to ensure the write complete.

Yonatan Maman <Ymaman@Nvidia.com>
    nouveau/dmem: Fix privileged error in copy engine channel

Ben Skeggs <bskeggs@nvidia.com>
    drm/nouveau: pass cli to nouveau_channel_new() instead of drm+device

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

David Howells <dhowells@redhat.com>
    rxrpc: Fix uninitialised variable in rxrpc_send_data()

Neal Cardwell <ncardwell@google.com>
    tcp: fix TFO SYN_RECV to not zero retrans_stamp with retransmits out

Aananth V <aananthv@google.com>
    tcp: new TCP_INFO stats for RTO events

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

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: set correct dst VSI in only LAN filters

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Mark filecache "down" if init fails

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    x86/amd_nb: Add new PCI IDs for AMD family 1Ah model 60h

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    x86/amd_nb: Add new PCI IDs for AMD family 0x1a

Andrey Shumilin <shum.sdl@nppct.ru>
    fbdev: sisfb: Fix strbuf array overflow

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix UAF in async decryption

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

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Fix double free in driver API bus_register()

Riyan Dhiman <riyandhiman14@gmail.com>
    staging: vme_user: added bound check to geoid

Zhu Jun <zhujun2@cmss.chinamobile.com>
    tools/iio: Add memory allocation failure check for trigger_name

Philip Chen <philipchen@chromium.org>
    virtio_pmem: Check device status before requesting flush

Simon Horman <horms@kernel.org>
    netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Fix memleak in pci_acpi_scan_root()

Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
    comedi: ni_routing: tools: Check when the file could not be opened

Shawn Shao <shawn.shao@jaguarmicro.com>
    usb: dwc2: Adjust the timing of USB Driver Interrupt Registration in the Crashkernel Scenario

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: enable suspend interrupt after usb reset

Wadim Egorov <w.egorov@phytec.de>
    usb: typec: tipd: Free IRQ only if it was requested before

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: protect uart_port_dtr_rts() in uart_shutdown() too

Peng Fan <peng.fan@nxp.com>
    clk: imx: Remove CLK_SET_PARENT_GATE for DRAM mux for i.MX7D

Peng Fan <peng.fan@nxp.com>
    remoteproc: imx_rproc: Use imx specific hook for find_loaded_rsc_table

Yunke Cao <yunkec@chromium.org>
    media: videobuf2-core: clear memory related fields in __vb2_plane_dmabuf_put()

Ying Sun <sunying@isrc.iscas.ac.cn>
    riscv/kexec_file: Fix relocation type R_RISCV_ADD16 and R_RISCV_SUB16 unknown

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: re-check Peripheral status with delayed_work

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Enforce umem boundaries for explicit ODP page faults

Jisheng Zhang <jszhang@kernel.org>
    riscv: avoid Imbalance in RAS

Hans de Goede <hdegoede@redhat.com>
    mfd: intel_soc_pmic_chtwc: Make Lenovo Yoga Tab 3 X90F DMI match less strict

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    ntb: ntb_hw_switchtec: Fix use after free vulnerability in switchtec_ntb_remove due to race condition

Jens Axboe <axboe@kernel.dk>
    io_uring: check if we need to reschedule during overflow flush

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Don't have MAX_PHYSMEM_BITS exceed phys_addr_t

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    i3c: master: cdns: Fix use after free vulnerability in cdns_i3c_master Driver Due to Race Condition

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

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: intel_bus_common: enable interrupts before exiting reset

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/mad: Improve handling of timed out WRs of mad agent

Daniel Jordan <daniel.m.jordan@oracle.com>
    ktest.pl: Avoid false positives with grub2 skip regex

Xu Kuohai <xukuohai@huawei.com>
    bpf: Prevent tail call between progs attached to different hooks

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

Daniel Borkmann <daniel@iogearbox.net>
    selftests/bpf: Fix ARG_PTR_TO_LONG {half-,}uninitialized test

Mathias Krause <minipli@grsecurity.net>
    Input: synaptics-rmi4 - fix UAF of IRQ domain on driver removal

Andrey Skvortsov <andrej.skvortzov@gmail.com>
    zram: don't free statically defined names

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: free secondary algorithms names

Diogo Jahchan Koike <djahchankoike@gmail.com>
    ntfs3: Change to non-blocking allocation in ntfs_d_hash

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: fix misc probe bugs

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Refactor enum_rstbl to suppress static checker

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix sparse warning in ni_fiemap

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do not call file_modified if collapse range failed

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Revert "Check HDCP returned status"

Wenjing Liu <wenjing.liu@amd.com>
    drm/amd/display: Remove a redundant check in authenticated_dp

Paul Menzel <pmenzel@molgen.mpg.de>
    lib/build_OID_registry: avoid non-destructive substitution for Perl < 5.13.2 compat

Randy Dunlap <rdunlap@infradead.org>
    jbd2: fix kernel-doc for j_transaction_overhead_buffers

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix usage of __hci_cmd_sync_status

Benjamin Poirier <bpoirier@nvidia.com>
    selftests: Introduce Makefile variable to list shared bash scripts

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

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    bootconfig: Fix the kerneldoc of _xbc_exit()

Hui Wang <hui.wang@canonical.com>
    e1000e: move force SMBUS near the end of enable_ulp function

Tony Nguyen <anthony.l.nguyen@intel.com>
    i40e: Include types.h to some headers

Ivan Vecera <ivecera@redhat.com>
    i40e: Fix ST code value for Clause 45

Damien Le Moal <dlemoal@kernel.org>
    scsi: sd: Do not repeat the starting disk message

Damien Le Moal <dlemoal@kernel.org>
    scsi: Remove scsi device no_start_on_resume flag

Gergo Koteles <soyer@irl.hu>
    ASoC: tas2781: mark dvc_tlv with __maybe_unused

Damien Le Moal <dlemoal@kernel.org>
    ata: ahci: Add mask_port_map module parameter

Carlos Song <carlos.song@nxp.com>
    spi: spi-fsl-lpspi: remove redundant spi_controller_put call

Charlie Jenkins <charlie@rivosinc.com>
    riscv: cpufeature: Fix thead vector hwcap removal

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have saved_cmdlines arrays all in one allocation

Xiubo Li <xiubli@redhat.com>
    libceph: init the cursor when preparing sparse read in msgr2

Shannon Nelson <shannon.nelson@amd.com>
    pds_core: no health-thread in VF path

Geoff Levand <geoff@infradead.org>
    Revert "powerpc/ps3_defconfig: Disable PPC64_BIG_ENDIAN_ELF_ABI_V2"

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Add support for async DMA read operation

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Add support for async DMA write operation

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Introduce async read/write callbacks

Manivannan Sadhasivam <mani@kernel.org>
    bus: mhi: ep: Rename read_from_host() and write_to_host() APIs

Rob Clark <robdclark@chromium.org>
    drm/crtc: fix uninitialized variable use even harder

Jean-Loïc Charroud <lagiraudiere+linux@free.fr>
    ALSA: hda/realtek: cs35l41: Fix device ID / model name

Jean-Loïc Charroud <lagiraudiere+linux@free.fr>
    ALSA: hda/realtek: cs35l41: Fix order and duplicates in quirks table

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Remove precision vsnprintf() check from print event

Cong Yang <yangcong5@huaqin.corp-partner.google.com>
    drm/panel: boe-tv101wum-nl6: Fine tune Himax83102-j02 panel HFP and HBP (again)

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Drop TSO support

Song Shuai <songshuaishuai@tinylab.org>
    riscv: Remove SHADOW_OVERFLOW_STACK_SIZE macro

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Revert "ignore negated quota changes"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: qd_check_sync cleanups

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Revert "introduce qd_bh_get_or_undo"

Abel Vesa <abel.vesa@linaro.org>
    phy: qualcomm: eusb2-repeater: Rework init to drop redundant zero-out loop

Konrad Dybcio <konrad.dybcio@linaro.org>
    phy: qualcomm: phy-qcom-eusb2-repeater: Add tuning overrides

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Load tunings for the correct speaker models

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI/MSI: Provide stubs for IMS functions"

Wei Fang <wei.fang@nxp.com>
    net: fec: don't save PTP state if PTP is unsupported

Gabriel Krisman Bertazi <krisman@suse.de>
    unicode: Don't special case ignorable code points


-------------

Diffstat:

 Documentation/dev-tools/kselftest.rst              |   12 +
 Makefile                                           |    4 +-
 arch/loongarch/pci/acpi.c                          |    1 +
 arch/powerpc/configs/ps3_defconfig                 |    1 -
 arch/riscv/include/asm/sbi.h                       |    2 +
 arch/riscv/include/asm/sparsemem.h                 |    2 +-
 arch/riscv/include/asm/thread_info.h               |    1 -
 arch/riscv/kernel/cpu.c                            |   40 +-
 arch/riscv/kernel/cpufeature.c                     |    8 +-
 arch/riscv/kernel/elf_kexec.c                      |    6 +
 arch/riscv/kernel/entry.S                          |    4 +-
 arch/s390/boot/Makefile                            |   19 +-
 arch/s390/include/asm/facility.h                   |    6 +-
 arch/s390/include/asm/io.h                         |    2 +
 arch/s390/kernel/early.c                           |   17 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   12 +-
 arch/s390/mm/cmm.c                                 |   18 +-
 arch/x86/kernel/amd_nb.c                           |    4 +
 arch/x86/net/bpf_jit_comp.c                        |   54 +-
 drivers/ata/ahci.c                                 |   85 +
 drivers/ata/libata-eh.c                            |   18 +-
 drivers/base/bus.c                                 |    8 +-
 drivers/block/zram/zram_drv.c                      |    7 +
 drivers/bus/mhi/ep/internal.h                      |    1 +
 drivers/bus/mhi/ep/main.c                          |  248 +-
 drivers/bus/mhi/ep/ring.c                          |    8 +-
 drivers/char/virtio_console.c                      |   18 +-
 drivers/clk/bcm/clk-bcm53573-ilp.c                 |    2 +-
 drivers/clk/imx/clk-imx7d.c                        |    4 +-
 .../drivers/ni_routing/tools/convert_c_to_py.c     |    5 +
 drivers/dax/device.c                               |    2 +-
 drivers/gpio/gpio-aspeed.c                         |    4 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |    2 +-
 .../drm/amd/display/modules/hdcp/hdcp1_execution.c |   27 +-
 drivers/gpu/drm/drm_crtc.c                         |    1 +
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   10 +-
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   21 +-
 drivers/gpu/drm/nouveau/nouveau_chan.h             |    3 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    4 +-
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c     |    8 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    9 +-
 drivers/gpu/drm/vc4/vc4_perfmon.c                  |    7 +-
 drivers/hid/Kconfig                                |    9 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   14 +-
 drivers/hid/hid-asus.c                             |   14 +-
 drivers/hid/hid-ids.h                              |   10 +
 drivers/hid/hid-mcp2200.c                          |  392 ++
 drivers/hid/hid-multitouch.c                       |    8 +-
 drivers/hid/hid-plantronics.c                      |   23 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   22 +-
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c        |    2 +-
 drivers/hwmon/Kconfig                              |    4 +
 drivers/hwmon/intel-m10-bmc-hwmon.c                |    2 +-
 drivers/hwmon/k10temp.c                            |    1 +
 drivers/i2c/busses/i2c-i801.c                      |    9 +-
 drivers/i3c/master/i3c-master-cdns.c               |    1 +
 drivers/infiniband/core/mad.c                      |   14 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   25 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   13 +-
 drivers/input/rmi4/rmi_driver.c                    |    6 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |    8 +-
 drivers/mfd/intel_soc_pmic_chtwc.c                 |    1 -
 drivers/net/dsa/b53/b53_common.c                   |   17 +-
 drivers/net/dsa/lan9303-core.c                     |   29 +
 drivers/net/ethernet/adi/adin1110.c                |    4 +-
 drivers/net/ethernet/amd/pds_core/main.c           |    6 +
 drivers/net/ethernet/cortina/gemini.c              |   32 +-
 drivers/net/ethernet/freescale/fec_main.c          |    6 +-
 drivers/net/ethernet/ibm/emac/mal.c                |    2 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |    4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   55 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   22 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |    1 +
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |    1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    1 +
 drivers/net/ethernet/intel/i40e/i40e_register.h    |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +
 drivers/net/ethernet/intel/ice/ice.h               |    6 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   63 +-
 drivers/net/ethernet/intel/ice/ice_eswitch_br.c    |   17 +-
 drivers/net/ethernet/intel/ice/ice_eswitch_br.h    |    1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   27 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |    2 -
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   15 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    2 +-
 drivers/net/phy/bcm84881.c                         |    4 +-
 drivers/net/phy/dp83869.c                          |    1 -
 drivers/net/phy/phy_device.c                       |    5 +-
 drivers/net/ppp/ppp_async.c                        |    2 +-
 drivers/net/slip/slhc.c                            |   57 +-
 drivers/net/vxlan/vxlan_core.c                     |    6 +-
 drivers/net/vxlan/vxlan_private.h                  |    2 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   19 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |    1 +
 drivers/nvdimm/nd_virtio.c                         |    9 +
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |    8 +-
 drivers/pci/quirks.c                               |    8 +
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |  145 +-
 drivers/powercap/intel_rapl_tpmi.c                 |   19 +-
 drivers/remoteproc/imx_rproc.c                     |   13 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   12 +
 drivers/scsi/lpfc/lpfc_disc.h                      |    7 +
 drivers/scsi/lpfc/lpfc_els.c                       |    7 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   43 +-
 drivers/scsi/sd.c                                  |    9 +-
 drivers/scsi/wd33c93.c                             |    2 +-
 drivers/soundwire/cadence_master.c                 |   39 +-
 drivers/soundwire/cadence_master.h                 |    5 +
 drivers/soundwire/intel.h                          |    2 +
 drivers/soundwire/intel_auxdevice.c                |    1 +
 drivers/soundwire/intel_bus_common.c               |   35 +-
 drivers/spi/spi-fsl-lpspi.c                        |   14 +-
 drivers/staging/vme_user/vme_fake.c                |    6 +
 drivers/staging/vme_user/vme_tsi148.c              |    6 +
 .../int340x_thermal/processor_thermal_device_pci.c |   23 +-
 drivers/tty/serial/serial_core.c                   |   16 +-
 drivers/ufs/core/ufshcd.c                          |    5 +-
 drivers/usb/chipidea/udc.c                         |    8 +-
 drivers/usb/dwc2/platform.c                        |   26 +-
 drivers/usb/dwc3/core.c                            |   22 +-
 drivers/usb/dwc3/core.h                            |    4 -
 drivers/usb/dwc3/gadget.c                          |   11 -
 drivers/usb/gadget/udc/core.c                      |    1 +
 drivers/usb/host/xhci-pci.c                        |    5 +
 drivers/usb/misc/yurex.c                           |   19 +-
 drivers/usb/storage/unusual_devs.h                 |   11 +
 drivers/usb/typec/tipd/core.c                      |    2 +
 drivers/video/fbdev/core/fbcon.c                   |    2 +
 drivers/video/fbdev/sis/sis_main.c                 |    2 +-
 fs/btrfs/extent-tree.c                             |   19 +-
 fs/btrfs/volumes.h                                 |    6 +
 fs/btrfs/zoned.c                                   |    2 +-
 fs/ext4/super.c                                    |    9 +-
 fs/ext4/xattr.c                                    |    4 +-
 fs/gfs2/quota.c                                    |   59 +-
 fs/nfs/callback_xdr.c                              |    2 +
 fs/nfs/client.c                                    |    1 +
 fs/nfs/nfs42proc.c                                 |    2 +-
 fs/nfs/nfs4state.c                                 |    2 +-
 fs/nfsd/filecache.c                                |    4 +-
 fs/ntfs3/file.c                                    |    4 +-
 fs/ntfs3/frecord.c                                 |   21 +-
 fs/ntfs3/fslog.c                                   |   19 +-
 fs/ntfs3/namei.c                                   |    4 +-
 fs/proc/kcore.c                                    |   36 +-
 fs/smb/client/smb2ops.c                            |   47 +-
 fs/smb/client/smb2pdu.c                            |    6 +
 fs/unicode/mkutf8data.c                            |   70 -
 fs/unicode/utf8data.c_shipped                      | 6703 ++++++++++----------
 include/linux/bpf.h                                |    1 +
 include/linux/intel_tpmi.h                         |    6 +
 include/linux/jbd2.h                               |    2 +-
 include/linux/mhi_ep.h                             |   21 +-
 include/linux/netlink.h                            |    2 +
 include/linux/nfs_fs_sb.h                          |    1 +
 include/linux/pci.h                                |   34 +-
 include/linux/pci_ids.h                            |    4 +
 include/linux/tcp.h                                |    8 +
 include/net/mctp.h                                 |    2 +-
 include/net/rtnetlink.h                            |   18 +
 include/net/sch_generic.h                          |    1 -
 include/net/sock.h                                 |    2 +
 include/scsi/scsi_device.h                         |    1 -
 include/sound/cs35l56.h                            |    1 +
 include/sound/tas2781-tlv.h                        |    2 +-
 include/uapi/linux/tcp.h                           |   12 +
 io_uring/io_uring.c                                |   15 +
 kernel/bpf/arraymap.c                              |    3 +
 kernel/bpf/core.c                                  |   21 +-
 kernel/bpf/hashtab.c                               |    3 +
 kernel/kthread.c                                   |    2 +
 kernel/rcu/tree.c                                  |    9 +-
 kernel/rcu/tree_nocb.h                             |   28 +-
 kernel/trace/trace.c                               |   18 +-
 kernel/trace/trace_output.c                        |    6 +-
 lib/bootconfig.c                                   |    3 +-
 lib/build_OID_registry                             |    4 +-
 mm/secretmem.c                                     |    4 +-
 net/bluetooth/hci_conn.c                           |    3 +
 net/bluetooth/hci_core.c                           |   27 +-
 net/bluetooth/rfcomm/sock.c                        |    2 -
 net/bridge/br_netfilter_hooks.c                    |    5 +
 net/bridge/br_netlink.c                            |    6 +-
 net/bridge/br_private.h                            |    5 +-
 net/bridge/br_vlan.c                               |   19 +-
 net/ceph/messenger_v2.c                            |    3 +
 net/core/dst.c                                     |   17 +-
 net/core/rtnetlink.c                               |   31 +
 net/ipv4/netfilter/nf_reject_ipv4.c                |   10 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |    4 +-
 net/ipv4/tcp.c                                     |    9 +
 net/ipv4/tcp_input.c                               |   57 +-
 net/ipv4/tcp_minisocks.c                           |    4 +
 net/ipv4/tcp_timer.c                               |   17 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |    5 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |    5 +-
 net/mac80211/scan.c                                |   17 +-
 net/mctp/af_mctp.c                                 |    6 +-
 net/mctp/device.c                                  |   32 +-
 net/mctp/neigh.c                                   |   29 +-
 net/mctp/route.c                                   |   33 +-
 net/mpls/af_mpls.c                                 |   87 +-
 net/mptcp/mib.c                                    |    2 +
 net/mptcp/mib.h                                    |    2 +
 net/mptcp/pm_netlink.c                             |    3 +-
 net/mptcp/protocol.c                               |   24 +-
 net/mptcp/subflow.c                                |    6 +-
 net/netfilter/nf_nat_core.c                        |  120 +-
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
 net/netlink/af_netlink.c                           |   38 +-
 net/netlink/af_netlink.h                           |    5 +-
 net/phonet/pn_netlink.c                            |   43 +-
 net/rxrpc/sendmsg.c                                |   10 +-
 net/sched/sch_api.c                                |    7 +-
 net/sctp/socket.c                                  |   18 +-
 net/socket.c                                       |    7 +-
 sound/pci/hda/hda_intel.c                          |    2 +-
 sound/pci/hda/patch_realtek.c                      |    7 +-
 sound/soc/codecs/cs35l56-shared.c                  |   36 +
 sound/soc/codecs/cs35l56.c                         |   32 +-
 sound/soc/codecs/cs35l56.h                         |    1 +
 tools/iio/iio_generic_buffer.c                     |    4 +
 tools/lib/subcmd/parse-options.c                   |    8 +-
 tools/perf/builtin-kmem.c                          |    2 +
 tools/perf/builtin-kvm.c                           |    3 +
 tools/perf/builtin-kwork.c                         |    3 +
 tools/perf/builtin-lock.c                          |    3 +
 tools/perf/builtin-mem.c                           |    3 +
 tools/perf/builtin-sched.c                         |  164 +-
 tools/testing/ktest/ktest.pl                       |    2 +-
 tools/testing/selftests/Makefile                   |    7 +-
 .../testing/selftests/bpf/progs/verifier_int_ptr.c |    5 +-
 tools/testing/selftests/lib.mk                     |   19 +
 tools/testing/selftests/mm/hmm-tests.c             |    2 +-
 .../selftests/net/forwarding/no_forwarding.sh      |    2 +-
 tools/testing/selftests/net/setup_loopback.sh      |    0
 tools/testing/selftests/rseq/rseq.c                |  110 +-
 tools/testing/selftests/rseq/rseq.h                |   10 +-
 260 files changed, 6581 insertions(+), 4716 deletions(-)


