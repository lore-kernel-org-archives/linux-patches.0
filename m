Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8491D1D6DB1;
	Wed, 19 Feb 2025 09:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955946; cv=none; b=gl+Z+OBRFcoKewmUMEnNetGUFtn97efdzf/bk9xQj9q9NQbz2n45hyHL7nLc6qrg8Fde5cNO1kEg8Zbv8SnbRSevzgOen95CUGXwM6q9CdJ/j7nFc/tLmfwupSuaEnvLJCyfP3qaw4q3bZAmXxEgZ3DAYkmmbpO0hPOc/66CcLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955946; c=relaxed/simple;
	bh=GfX7zuSRezLVVZAFrdZfGRu1BdcBBx2e+zzGrshY0sY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Q2XQOKlU6TbMsYg4v8Crnq1NM6bHOH9Qu6w8wLW2m2xu9ccFp3Y429XE/+NUQ6J+6DGROxz7M4a1t0eygSpd5CY0HOSgjsnOdzG8A5QEdlkAHCXOnfxVFxtyubvWhqqd83IzvzGNtf59a93NXwzTtrrJa8YulWT+CmUfx3Yg5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxQnXBO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxQnXBO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74514C4CED1;
	Wed, 19 Feb 2025 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955946;
	bh=GfX7zuSRezLVVZAFrdZfGRu1BdcBBx2e+zzGrshY0sY=;
	h=From:To:Cc:Subject:Date:From;
	b=AxQnXBO2tgKE8qKnnn+Oy2BhnsGn/5EhQ7Ha76RtuiZOIboK2kvDuwCd3XQZdAQWp
	 Lqp9KUtHyjawmq4rovnBadzEmHMeifGiPRUAOoUOHWFevxty9pfktQBKNtdiXvGYic
	 xYbfUXO8HQe3e5P2kuYZK7glihqtHfkoCsYQ76H4=
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
Subject: [PATCH 6.1 000/578] 6.1.129-rc1 review
Date: Wed, 19 Feb 2025 09:20:04 +0100
Message-ID: <20250219082652.891560343@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.129-rc1
X-KernelTest-Deadline: 2025-02-21T08:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.129 release.
There are 578 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.129-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.129-rc1

David Woodhouse <dwmw@amazon.co.uk>
    x86/i8253: Disable PIT timer 0 when not in use

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Add NULL pointer check for kzalloc

Chao Yu <chao@kernel.org>
    f2fs: fix to wait dio completion

Romain Naour <romain.naour@skf.com>
    ARM: dts: dra7: Add bus_dma_limit for l4 cfg bus

Hangbin Liu <liuhangbin@gmail.com>
    selftests: rtnetlink: update netdevsim ipsec output format

Hangbin Liu <liuhangbin@gmail.com>
    netdevsim: print human readable IP address

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix netdev_priv() dereference before check on non-DSA netdevice events

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    parport_pc: add support for ASIX AX99100

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    serial: 8250_pci: add support for ASIX AX99100

Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
    can: ems_pci: move ASIX AX99100 ids to pci_ids.h

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: protect access to buffers with no active references

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not force clear folio if buffer is referenced

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: do not output warnings when clearing dirty buffers

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    i3c: master: cdns: Fix use after free vulnerability in cdns_i3c_master Driver Due to Race Condition

Ivan Kokshaysky <ink@unseen.parts>
    alpha: replace hardcoded stack offsets with autogenerated ones

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: gup: fix infinite loop within __get_longterm_locked

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Fix typo in Tegra234 dce-fabric compatible

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Return right value in iommu_sva_bind_device()

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/static-call: Remove early_boot_irqs_disabled check to fix Xen PVH dom0

John Ogness <john.ogness@linutronix.de>
    kdb: Do not assume write() callback available

Christian Gmeiner <cgmeiner@igalia.com>
    drm/v3d: Stop active perfmon if it is being destroyed

Devarsh Thakkar <devarsht@ti.com>
    drm/tidss: Clear the interrupt status for interrupts being disabled

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Fix issue in irq handling causing irq-flood issue

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: add RCU protection to mld_newpack()

Eric Dumazet <edumazet@google.com>
    ndisc: extend RCU protection in ndisc_send_skb()

Eric Dumazet <edumazet@google.com>
    openvswitch: use RCU protection in ovs_vport_cmd_fill_info()

Eric Dumazet <edumazet@google.com>
    arp: use RCU protection in arp_xmit()

Eric Dumazet <edumazet@google.com>
    neighbour: use RCU protection in __neigh_notify()

Li Zetao <lizetao1@huawei.com>
    neighbour: delete redundant judgment statements

Eric Dumazet <edumazet@google.com>
    ndisc: use RCU protection in ndisc_alloc_skb()

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU protection in ip6_default_advmss()

Eric Dumazet <edumazet@google.com>
    flow_dissector: use RCU protection to fetch dev_net()

Eric Dumazet <edumazet@google.com>
    ipv4: icmp: convert to dev_net_rcu()

Eric Dumazet <edumazet@google.com>
    ipv4: use RCU protection in __ip_rt_update_pmtu()

Vladimir Vdovin <deliran@verdict.gg>
    net: ipv4: Cache pmtu for all packet paths if multipath enabled

Eric Dumazet <edumazet@google.com>
    ipv4: use RCU protection in inet_select_addr()

Eric Dumazet <edumazet@google.com>
    ipv4: use RCU protection in rt_is_expired()

Eric Dumazet <edumazet@google.com>
    ipv4: use RCU protection in ipv4_default_advmss()

Eric Dumazet <edumazet@google.com>
    net: add dev_net_rcu() helper

Jiri Pirko <jiri@nvidia.com>
    net: treat possible_net_t net pointer as an RCU one and add read_pnet_rcu()

Eric Dumazet <edumazet@google.com>
    ipv4: add RCU protection to ip4_dst_hoplimit()

Waiman Long <longman@redhat.com>
    clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context

Waiman Long <longman@redhat.com>
    clocksource: Use pr_info() for "Checking clocksource synchronization" message

Filipe Manana <fdmanana@suse.com>
    btrfs: fix hole expansion when writing at an offset beyond EOF

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: Add return value check for mlxsw_sp_port_get_stats_raw()

Andy-ld Lu <andy-ld.lu@mediatek.com>
    mmc: mtk-sd: Fix register settings for hs400(es) mode

Nathan Chancellor <nathan@kernel.org>
    arm64: Handle .ARM.attributes section in linker scripts

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    regmap-irq: Add missing kfree()

Jann Horn <jannh@google.com>
    partitions: mac: fix handling of bogus partition table

Wentao Liang <vulab@iscas.ac.cn>
    gpio: stmpe: Check return value of stmpe_reg_read in stmpe_gpio_irq_sync_unlock

Mario Limonciello <mario.limonciello@amd.com>
    gpiolib: acpi: Add a quirk for Acer Nitro ANV14

Ivan Kokshaysky <ink@unseen.parts>
    alpha: align stack for page fault and user unaligned trap handlers

John Keeping <jkeeping@inmusicbrands.com>
    serial: 8250: Fix fifo underflow on flush

Shakeel Butt <shakeel.butt@linux.dev>
    cgroup: fix race between fork and cgroup.kill

Ard Biesheuvel <ardb@kernel.org>
    efi: Avoid cold plugged memory for placing the kernel

Ivan Kokshaysky <ink@unseen.parts>
    alpha: make stack 16-byte aligned (most cases)

Alexander Hölzl <alexander.hoelzl@gmx.net>
    can: j1939: j1939_sk_send_loop(): fix unable to send messages with data length zero

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    can: c_can: fix unbalanced runtime PM disable in error path

Fedor Pchelkin <pchelkin@ispras.ru>
    can: ctucanfd: handle skb allocation failure

Johan Hovold <johan@kernel.org>
    USB: serial: option: drop MeiG Smart defines

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: fix Telit Cinterion FN990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990B compositions

Chester A. Unal <chester.a.unal@arinc9.com>
    USB: serial: option: add MeiG Smart SLM828

Jann Horn <jannh@google.com>
    usb: cdc-acm: Fix handling of oversized fragments

Jann Horn <jannh@google.com>
    usb: cdc-acm: Check control transfer buffer size before access

Marek Vasut <marek.vasut+renesas@mailbox.org>
    USB: cdc-acm: Fill in Renesas R-Car D3 USB Download mode quirk

Alan Stern <stern@rowland.harvard.edu>
    USB: hub: Ignore non-compliant devices with too many configs or interfaces

John Keeping <jkeeping@inmusicbrands.com>
    usb: gadget: f_midi: fix MIDI Streaming descriptor lengths

Mathias Nyman <mathias.nyman@linux.intel.com>
    USB: Add USB_QUIRK_NO_LPM quirk for sony xperia xz1 smartphone

Lei Huang <huanglei@kylinos.cn>
    USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    usb: core: fix pipe creation for get_bMaxPacketSize0

Huacai Chen <chenhuacai@kernel.org>
    USB: pci-quirks: Fix HCCPARAMS register error for LS7A EHCI

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    usb: dwc2: gadget: remove of_node reference upon udc_stop

Guo Ren <guoren@kernel.org>
    usb: gadget: udc: renesas_usb3: Fix compiler warning

Elson Roy Serrao <quic_eserrao@quicinc.com>
    usb: roles: set switch registered flag early on

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: Fix timeout issue during controller enter/exit from halt state

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Ensure LBRs are disabled when a CPU is starting

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Enter guest mode before initializing nested NPT MMU

Sean Christopherson <seanjc@google.com>
    KVM: x86: Reject Hyper-V's SEND_IPI hypercalls if local APIC isn't in-kernel

Jiang Liu <gerry@linux.alibaba.com>
    drm/amdgpu: avoid buffer overflow attach in smu_sys_set_pp_table()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Drop unmanaged ELP metric worker

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore neighbor throughput metrics in error case

Andy Strohman <andrew@andrewstrohman.com>
    batman-adv: fix panic during interface removal

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Vexia Edu Atla 10 tablet 5V

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix a oob in orangefs_debug_write

Rik van Riel <riel@fb.com>
    x86/mm/tlb: Only trim the mm_cpumask once a second

Koichiro Den <koichiro.den@canonical.com>
    selftests: gpio: gpio-sim: Fix missing chip disablements

Maksym Planeta <maksym@exostellar.io>
    Grab mm lock before grabbing pt lock

Ramesh Thomas <ramesh.thomas@intel.com>
    vfio/pci: Enable iowrite64 and ioread64 for vfio pci

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Abort event processing on second signal

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Abort event processing on second signal

Guixin Liu <kanie@linux.alibaba.com>
    scsi: ufs: bsg: Set bsg_queue to NULL after removal

Rakesh Babu Saladi <Saladi.Rakeshbabu@microchip.com>
    PCI: switchtec: Add Microchip PCI100X device IDs

Takashi Iwai <tiwai@suse.de>
    PCI/DPC: Quirk PIO log size for Intel Raptor Lake-P

Edward Adam Davis <eadavis@qq.com>
    media: vidtv: Fix a null-ptr-deref in vidtv_mux_stop_thread

Arnd Bergmann <arnd@arndb.de>
    media: cxd2841er: fix 64-bit division on gcc-9

Aaro Koskinen <aaro.koskinen@iki.fi>
    fbdev: omap: use threaded IRQ for LCD DMA

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Reset device on probe failure

Juergen Gross <jgross@suse.com>
    x86/xen: allow larger contiguous memory regions in PV guests

Petr Tesarik <petr.tesarik.ext@huawei.com>
    xen: remove a confusing comment on auto-translated guest I/O

Juergen Gross <jgross@suse.com>
    xen/swiotlb: relax alignment requirements

Artur Weber <aweber.kernel@gmail.com>
    gpio: bcm-kona: Add missing newline to dev_err format string

Artur Weber <aweber.kernel@gmail.com>
    gpio: bcm-kona: Make sure GPIO bits are unlocked when requesting IRQ

Artur Weber <aweber.kernel@gmail.com>
    gpio: bcm-kona: Fix GPIO lock/unlock for banks above bank 0

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/selftests: avoid using uninitialized context

Muhammad Adeel <Muhammad.Adeel@ibm.com>
    cgroup: Remove steal time from usage_usec

Radu Rendec <rrendec@redhat.com>
    arm64: cacheinfo: Avoid out-of-bounds write to cacheinfo array

Eric Dumazet <edumazet@google.com>
    team: better TEAM_OPTION_TYPE_STRING validation

Eric Dumazet <edumazet@google.com>
    vxlan: check vxlan_vnigroup_init() return value

Eric Dumazet <edumazet@google.com>
    vrf: use RCU protection in l3mdev_l3_out()

Eric Dumazet <edumazet@google.com>
    ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()

Murad Masimov <m.masimov@mt-integration.ru>
    ax25: Fix refcount leak caused by setting SO_BINDTODEVICE sockopt

Tulio Fernandes <tuliomf09@gmail.com>
    HID: hid-thrustmaster: fix stack-out-of-bounds read in usb_check_int_endpoints()

Charles Han <hanchunchao@inspur.com>
    HID: multitouch: Add NULL check in mt_input_configured

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: cy8c95x0: Respect IRQ trigger settings from firmware

Dai Ngo <dai.ngo@oracle.com>
    NFSD: fix hang in nfsd4_shutdown_callback

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: clear acl_access/acl_default after releasing them

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid monopolizing a core when activating a swap file

Koichiro Den <koichiro.den@canonical.com>
    Revert "btrfs: avoid monopolizing a core when activating a swap file"

Calvin Owens <calvin@wbinvd.org>
    pps: Fix a use-after-free

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: simplify split calculation

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix static analyser cppcheck issue

Sean Anderson <sean.anderson@linux.dev>
    tty: xilinx_uartps: split sysrq handling

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent excessive coalescing on receive

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only set fullmesh for subflow endp

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix NULL pointer dereference in object->file

Su Yue <glass.su@suse.com>
    ocfs2: check dir i_size in ocfs2_find_entry

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: xilinx: remove excess kernel doc

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: use dev_set_mac_address() for Get MC MAC Address handling

WangYuli <wangyuli@uniontech.com>
    MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rw: commit provided buffer state on async

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_req_prep_async with provided buffers

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix multishots with selected buffers

Michal Simek <michal.simek@amd.com>
    rtc: zynqmp: Fix optional clock name property

Thomas Weißschuh <linux@weissschuh.net>
    ptp: Ensure info->enable callback is always set

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    pinctrl: samsung: fix fwnode refcount cleanup if platform_get_irq_optional() fails

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Stop timerlat tracer on signal

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Stop timerlat tracer on signal

Tomas Glozar <tglozar@redhat.com>
    rtla: Add trace_instance_stop

Tomas Glozar <tglozar@redhat.com>
    rtla/osnoise: Distinguish missing workload option

Milos Reljin <milos_reljin@outlook.com>
    net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: wait for the last response to Deselect Package before configuring channel

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix copy buffer page size

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix registered buffer page address

Anandu Krishnan E <quic_anane@quicinc.com>
    misc: fastrpc: Deregister device nodes properly in error scenarios

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: onenand: Fix uninitialized retlen in do_otp_read()

Nick Chan <towinchenmi@gmail.com>
    irqchip/apple-aic: Only handle PMC interrupt as FIQ when configured so

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix missing 'ret' assignment in set_speed()

Dan Carpenter <dan.carpenter@linaro.org>
    NFC: nci: Add bounds checking in nci_hci_create_pipe()

Pekka Pessi <ppessi@nvidia.com>
    mailbox: tegra-hsp: Clear mailbox before using message

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    nilfs2: fix possible int overflows in nilfs_fiemap()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ocfs2: handle a symlink read error correctly

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix incorrect CPU endianness conversion causing mount failure

Mike Snitzer <snitzer@kernel.org>
    pnfs/flexfiles: retry getting layout segment for reads

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: -f: no reconnect

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Jens Axboe <axboe@kernel.dk>
    io_uring/net: don't retry connect operation on EPOLLERR

Jennifer Berringer <jberring@redhat.com>
    nvmem: core: improve range check for nvmem_cell_write()

Luca Weiss <luca.weiss@fairphone.com>
    nvmem: qcom-spmi-sdam: Set size in struct nvmem_config

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - unregister previously registered algos in error path

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - fix goto jump in error path

Niklas Cassel <cassel@kernel.org>
    ata: libata-sff: Ensure that we cannot write outside the allocated buffer

Catalin Marinas <catalin.marinas@arm.com>
    mm: kmemleak: fix upper boundary check for physical address objects

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove redundant NULL assignment

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix event flags in uvc_ctrl_send_events

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: ccs: Fix cleanup order in ccs_probe()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Fix CCS static data parsing for large block sizes

Sam Bobrowicz <sam@elite-embedded.com>
    media: ov5640: fix get_light_freq on auto

Cosmin Tanislav <demonsingur@gmail.com>
    media: mc: fix endpoint iteration

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: qcom: smem_state: fix missing of_node_put in error path

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: as73211: fix channel handling in only-color triggered buffer

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Clean up parsed CCS static data on parse failure

Marco Elver <elver@google.com>
    kfence: skip __GFP_THISNODE allocations on NUMA systems

Gabriele Monaco <gmonaco@redhat.com>
    rv: Reset per-task monitors also for idle tasks

Aubrey Li <aubrey.li@linux.intel.com>
    ACPI: PRM: Remove unnecessary strict handler address checks

Wentao Liang <vulab@iscas.ac.cn>
    xfs: Add error handling for xfs_reflink_cancel_cow_range

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Disable Tegra234 sce-fabric node

Eric Biggers <ebiggers@google.com>
    crypto: qce - fix priority to be less than ARMv8 CE

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6350: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6350: Fix ADSP memory length

Nathan Chancellor <nathan@kernel.org>
    x86/boot: Use '-std=gnu11' to fix build with GCC 15

Nathan Chancellor <nathan@kernel.org>
    kbuild: Move -Wenum-enum-conversion to W=2

Long Li <longli@microsoft.com>
    scsi: storvsc: Set correct data length for sending SCSI command without payload

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Move FCE Trace buffer allocation to user control

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()

Brad Griffis <bgriffis@nvidia.com>
    arm64: tegra: Fix Tegra234 PCIe interrupt-map

Kuan-Wei Chiu <visitorckw@gmail.com>
    ALSA: hda: Fix headset detection failure due to unstable sort

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo C6400

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Revert "media: uvcvideo: Require entities to have a non-zero unique ID"

Jens Axboe <axboe@kernel.dk>
    block: don't revert iter for -EIOCBQUEUED

Mateusz Jończyk <mat.jonczyk@o2.pl>
    mips/math-emu: fix emulation of the prefx instruction

Hou Tao <houtao1@huawei.com>
    dm-crypt: track tag_offset in convert_context

Hou Tao <houtao1@huawei.com>
    dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/pseries/eeh: Fix get PE state translation

Kexy Biscuit <kexybiscuit@aosc.io>
    MIPS: Loongson64: remove ROM Size unit in boardinfo

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Do not probe the serial port if its slot in sci_ports[] is in use

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Drop __initdata macro for port_cfg

Stephan Gerhold <stephan.gerhold@linaro.org>
    soc: qcom: socinfo: Avoid out of bounds read of serial number

Mario Limonciello <mario.limonciello@amd.com>
    ASoC: acp: Support microphone from Lenovo Go S

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't prepare BOT write request twice

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: ep_autoconfig with fullspeed endpoint

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Decrement command ref count on cleanup

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Translate error to sense

Marcel Hamer <marcel.hamer@windriver.com>
    wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8821ae: Fix media status report

Heiko Stuebner <heiko@sntech.de>
    HID: hid-sensor-hub: don't use stale platform-data on remove

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Fix using wrong number of cells to get property 'alignment'

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Fix of_find_node_opts_by_path() handling of alias+path+options

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Correct child specifier used as input of the 2nd nexus node

Bao D. Nguyen <quic_nguyenb@quicinc.com>
    scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions

Kuan-Wei Chiu <visitorckw@gmail.com>
    perf bench: Fix undefined behavior in cmpworker()

Nathan Chancellor <nathan@kernel.org>
    efi: libstub: Use '-std=gnu11' to fix build with GCC 15

Zijun Hu <quic_zijuhu@quicinc.com>
    blk-cgroup: Fix class @block_class's subsystem refcount leakage

Anastasia Belova <abelova@astralinux.ru>
    clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: dispcc-sm6350: Add missing parent_map for a clock

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add missing parent_map for two clocks

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: fix alpha mode configuration

Cody Eksal <masterr3c0rd@epochal.quest>
    clk: sunxi-ng: a100: enable MMC clock reparenting

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes

Haoxiang Li <haoxiang_li2024@163.com>
    drm/komeda: Add check for komeda_get_layer_fourcc_list()

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/guc: Debug print LRC state entries only if the context is pinned

Tom Chung <chiahsuan.chung@amd.com>
    Revert "drm/amd/display: Use HW lock mgr for PSR1"

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Mark MM activity as unsupported

Dan Carpenter <dan.carpenter@linaro.org>
    ksmbd: fix integer overflows on 32 bit systems

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: fix some corner-cases when grabbing vsie pages

Sean Christopherson <seanjc@google.com>
    KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()

Jakob Unterwurzacher <jakobunt@gmail.com>
    arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma

Thomas Zimmermann <tzimmermann@suse.de>
    drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()

Dan Carpenter <dan.carpenter@linaro.org>
    binfmt_flat: Fix integer overflow bug on 32 bit systems

Nam Cao <namcao@linutronix.de>
    fs/proc: do_task_stat: Fix ESP not readable during coredump

Thomas Zimmermann <tzimmermann@suse.de>
    m68k: vga: Fix I/O defines

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: Fix FUTEX_OP_ANDN implementation

Meetakshi Setiya <msetiya@microsoft.com>
    smb: client: change lease epoch type from unsigned int to __u16

Maarten Lankhorst <dev@lankhorst.se>
    drm/modeset: Handle tiled displays in pan_display_atomic.

Sebastian Wiese-Wagner <seb@fastmail.to>
    ALSA: hda/realtek: Enable Mute LED on HP Laptop 14s-fq1xxx

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    leds: lp8860: Write full EEPROM, not only half of it

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: s3c64xx: Fix compilation warning

Ido Schimmel <idosch@nvidia.com>
    net: sched: Fix truncation of offloaded action statistics

Willem de Bruijn <willemb@google.com>
    tun: revert fix group permission check

Cong Wang <cong.wang@bytedance.com>
    netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: property: Fix return value for nval == 0 in acpi_data_prop_read()

Juergen Gross <jgross@suse.com>
    x86/xen: add FRAME_END to xen_hypercall_hvm()

Juergen Gross <jgross@suse.com>
    x86/xen: fix xen_hypercall_hvm() to not clobber %rbx

Eric Dumazet <edumazet@google.com>
    net: rose: lock the socket in rose_bind()

Jacob Moroni <mail@jakemoroni.com>
    net: atlantic: fix warning during hot unplug

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: Improve interrupt support

Yan Zhai <yan@cloudflare.com>
    udp: gso: do not drop small packets when PMTU reduces

Lenny Szubowicz <lszubowi@redhat.com>
    tg3: Disable tg3 PCIe AER on system reboot

Hans Verkuil <hverkuil@xs4all.nl>
    gpu: drm_dp_cec: fix broken CEC adapter properties check

Prasad Pandit <pjp@fedoraproject.org>
    firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry

Daniel Wagner <wagi@kernel.org>
    nvme: handle connectivity loss in nvme_set_queue_count

Darrick J. Wong <djwong@kernel.org>
    xfs: don't over-report free space or inodes in statvfs

Darrick J. Wong <djwong@kernel.org>
    xfs: report realtime block quota limits on realtime directories

Sean Anderson <sean.anderson@linux.dev>
    gpio: xilinx: Convert gpio_lock to raw spinlock

Linus Walleij <linus.walleij@linaro.org>
    gpio: xilinx: Convert to immutable irq_chip

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: fix locking in Get MAC Address handling

Peter Delevoryas <peter@pjd.dev>
    net/ncsi: Add NC-SI 1.2 Get MC MAC Address command

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: chipidea/ci_hdrc_imx: Convert to platform remove callback returning void

Paolo Bonzini <pbonzini@redhat.com>
    KVM: e500: always restore irqs

Sean Christopherson <seanjc@google.com>
    KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults

Sean Christopherson <seanjc@google.com>
    KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock

Sean Christopherson <seanjc@google.com>
    KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Ignore AC events

Illia Ostapyshyn <illia@yshyn.com>
    Input: allocate keycode for phone linking

Yu-Chun Lin <eleanor15x@gmail.com>
    ASoC: amd: Add ACPI dependency to fix build error

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-pcm: don't use soc_pcm_ret() on .prepare callback

Hans de Goede <hdegoede@redhat.com>
    platform/x86: int3472: Check for adev == NULL

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu-v3: Clean up more on probe failure

David Woodhouse <dwmw@amazon.co.uk>
    x86/kexec: Allocate PGD for x86_64 transition page tables separately

Liu Ye <liuye@kylinos.cn>
    selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()

Dan Carpenter <dan.carpenter@linaro.org>
    tipc: re-order conditions in tipc_crypto_key_rcv()

Yuanjie Yang <quic_yuanjiey@quicinc.com>
    mmc: sdhci-msm: Correctly set the load for the regulator

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    net: wwan: iosm: Fix hibernation by re-binding the driver around it

Mazin Al Haddad <mazin@getstate.dev>
    Bluetooth: MGMT: Fix slab-use-after-free Read in mgmt_remove_adv_monitor_sync

Borislav Petkov <bp@alien8.de>
    APEI: GHES: Have GHES honor the panic= setting

Randolph Ha <rha051117@gmail.com>
    i2c: Force ELAN06FA touchpad I2C bus freq to 100KHz

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: avoid memory leak

Stefan Dösinger <stefan@codeweavers.com>
    wifi: brcmfmac: Check the return value of of_property_read_string_index()

Vadim Fedorenko <vadfed@meta.com>
    net/mlx5: use do_aux_work for PHC overflow checks

Even Xu <even.xu@intel.com>
    HID: Wacom: Add PCI Wacom device support

Hans de Goede <hdegoede@redhat.com>
    mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: don't emit warning in tomoyo_write_control()

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Respect quirk_max_rate for non-UHS SDIO card

Stas Sergeev <stsp2@yandex.ru>
    tun: fix group permission check

Leo Stone <leocstone@gmail.com>
    safesetid: check size of policy writes

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP CTS compare V matching

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP encryption when R0 ready

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP Bstatus check

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: Change definition MAX_HDCP_DOWN_STREAM_COUNT

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix Mode Cutoff in DSC Passthrough to DP2.1 Monitor

Kuan-Wei Chiu <visitorckw@gmail.com>
    printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX

Dongwon Kim <dongwon.kim@intel.com>
    drm/virtio: New fence for every plane update

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Restrict init function to AMD-based systems

Carlos Llamas <cmllamas@google.com>
    lockdep: Fix upper limit for LOCKDEP_*_BITS configs

Suleiman Souhlal <suleiman@google.com>
    sched: Don't try to catch up excess steal time.

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling

Hao-ran Zheng <zhenghaoran154@gmail.com>
    btrfs: fix data race when accessing the inode's disk_i_size at btrfs_drop_extents()

Kees Cook <kees@kernel.org>
    exec: fix up /proc/pid/comm in the execveat(AT_EMPTY_PATH) case

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Ensure adequate HUGE_MAX_HSTATE

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when attempting to join an aborted transaction

Antonio Borneo <antonio.borneo@foss.st.com>
    pinctrl: stm32: fix array read out of bound

Nathan Chancellor <nathan@kernel.org>
    s390: Add '-std=gnu11' to decompressor and purgatory CFLAGS

Thomas Weißschuh <linux@weissschuh.net>
    ptp: Properly handle compat ioctls

Qu Wenruo <wqu@suse.com>
    btrfs: output the reason for open_ctree() failure

Dan Carpenter <dan.carpenter@linaro.org>
    media: imx-jpeg: Fix potential error pointer dereference in detach_pm()

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    staging: media: max96712: fix kernel oops when removing module

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't free command immediately

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: uvcvideo: Fix double free in error path

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    remoteproc: core: Fix ida_free call while not allocated

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle fastopen disconnect correctly

Paolo Abeni <pabeni@redhat.com>
    mptcp: consolidate suboption status

Kyle Tso <kyletso@google.com>
    usb: typec: tcpci: Prevent Sink disconnection before vPpsShutdown in SPR PPS

Jos Wang <joswang@lenovo.com>
    usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE

Kyle Tso <kyletso@google.com>
    usb: dwc3: core: Defer the probe until USB power supply ready

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    usb: dwc3-am62: Fix an OF node leak in phy_syscon_pll_refclk()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Fix Get/SetInterface return value

Sean Rhodes <sean@starlabs.systems>
    drivers/card_reader/rtsx_usb: Restore interrupt based detection

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix NULL pointer dereference on certain command aborts

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net: usb: rtl8150: enable basic endpoint checking

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro

Ricardo B. Marliere <rbm@suse.com>
    ktest.pl: Check kernelrelease return in get_version

Tim Huang <tim.huang@amd.com>
    drm/amd/display: fix double free issue during amdgpu module unload

Puranjay Mohan <pjy@amazon.com>
    nvme: fix metadata handling in nvme-passthrough

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject mismatching sum of field_len with set key length

Parth Pancholi <parth.pancholi@toradex.com>
    kbuild: switch from lz4c to lz4 for compression

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Reset cb_seq_status after NFS4ERR_DELAY

Daniel Lee <chullee@google.com>
    f2fs: Introduce linear search for dentries

Lin Yujun <linyujun809@huawei.com>
    hexagon: Fix unbalanced spinlock in die()

Willem de Bruijn <willemb@google.com>
    hexagon: fix using plain integer as NULL pointer warning in cmpxchg

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix memory leak in sym_warn_unmet_dep()

Sergey Senozhatsky <senozhatsky@chromium.org>
    kconfig: WERROR unmet symbol dependency

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: deduplicate code in conf_read_simple()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: remove unused code for S_DEF_AUTO in conf_read_simple()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: require a space after '#' for valid input

Sergey Senozhatsky <senozhatsky@chromium.org>
    kconfig: add warn-unknown-symbols sanity check

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix file name in warnings when loading KCONFIG_DEFCONFIG_LIST

Detlev Casanova <detlev.casanova@collabora.com>
    ASoC: rockchip: i2s_tdm: Re-add the set_sysclk callback

Masahiro Yamada <masahiroy@kernel.org>
    genksyms: fix memory leak when the same symbol is read from *.symref file

Masahiro Yamada <masahiroy@kernel.org>
    genksyms: fix memory leak when the same symbol is added from source

Eric Dumazet <edumazet@google.com>
    net: hsr: fix fill_frame_info() regression vs VLAN packets

Kory Maincent <kory.maincent@bootlin.com>
    net: sh_eth: Fix missing rtnl lock in suspend/resume path

Rafał Miłecki <rafal@milecki.pl>
    bgmac: reduce max frame size to support just MTU 1500

Howard Chu <howardchu95@gmail.com>
    perf trace: Fix runtime error of index out of bounds

Chenyuan Yang <chenyuan0y@gmail.com>
    net: davicom: fix UAF in dm9000_drv_remove

Shigeru Yoshida <syoshida@redhat.com>
    vxlan: Fix uninit-value in vxlan_vnifilter_dump()

Jakub Kicinski <kuba@kernel.org>
    net: netdevsim: try to close UDP port harness races

Eric Dumazet <edumazet@google.com>
    net: rose: fix timer races against user threads

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    iavf: allow changing VLAN state without calling PF

Wentao Liang <vulab@iscas.ac.cn>
    PM: hibernate: Add error handling for syscore_suspend()

Eric Dumazet <edumazet@google.com>
    ipmr: do not call mr_mfc_uses_dev() for unres entries

Dheeraj Reddy Jonnalagadda <dheeraj.linuxdev@gmail.com>
    net: fec: implement TSO descriptor cleanup

Ahmad Fatoum <a.fatoum@pengutronix.de>
    gpio: mxc: remove dead code after switch to DT-only

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix oops when unload drivers paralleling

Alexander Stein <alexander.stein@ew.tq-group.com>
    regulator: core: Add missing newline character

pangliyuan <pangliyuan1@huawei.com>
    ubifs: skip dumping tnc tree when zroot is null

Oleksij Rempel <linux@rempel-privat.de>
    rtc: pcf85063: fix potential OOB write in PCF85063 NVMEM read

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    dmaengine: ti: edma: fix OF node reference leaks in edma_driver

Jianbo Liu <jianbol@nvidia.com>
    xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO

Luo Yifan <luoyifan@cmss.chinamobile.com>
    tools/bootconfig: Fix the wrong format specifier

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: mark OFFLOAD_CANCEL MOVEABLE

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix COPY_NOTIFY xdr buf size calculation

John Ogness <john.ogness@linutronix.de>
    serial: 8250: Adjust the timeout for FIFO mode

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    module: Extend the preempt disabled section in dereference_symbol_descriptor().

Su Yue <glass.su@suse.com>
    ocfs2: mark dquot as inactive if failed to start trans while releasing dquot

Guixin Liu <kanie@linux.alibaba.com>
    scsi: ufs: bsg: Delete bsg_dev when setting up bsg fails

Paul Menzel <pmenzel@molgen.mpg.de>
    scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-test: Fix check for DMA MEMCPY test

Damien Le Moal <dlemoal@kernel.org>
    PCI: epf-test: Simplify DMA support checks

Mohamed Khalfella <khalfella@gmail.com>
    PCI: endpoint: pci-epf-test: Set dma_chan_rx pointer to NULL on error

King Dix <kingdix10@qq.com>
    PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    staging: media: imx: fix OF node leak in imx_media_add_of_subdevs()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    mtd: hyperbus: hbmc-am654: fix an OF node reference leak

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mtd: hyperbus: hbmc-am654: Convert to platform remove callback returning void

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Propagate buf->error to userspace

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: camif-core: Add check for clk_enable()

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: mipi-csis: Add check for clk_enable()

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: i2c: ov9282: Correct the exposure offset

Luca Weiss <luca.weiss@fairphone.com>
    media: i2c: imx412: Add missing newline to prints

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    media: marvell: Add check for clk_enable()

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Destroy the EPC device in devm_pci_epc_destroy()

Chen Ni <nichen@iscas.ac.cn>
    media: lmedm04: Handle errors for lme2510_int_read

Oliver Neukum <oneukum@suse.com>
    media: rc: iguanair: handle timeouts

Qasim Ijaz <qasdev00@gmail.com>
    iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to_index()

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix the warning "__rxe_cleanup+0x12c/0x170 [rdma_rxe]"

Randy Dunlap <rdunlap@infradead.org>
    efi: sysfb_efi: fix W=1 warnings when EFI is not set

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Do not make kmemleak ignore freed address

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Fix indirect mkey ODP page count

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    fbdev: omapfb: Fix an OF node leak in dss_of_port_get_parent_device()

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: mediatek: mt7623: fix IR nodename

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8250: Fix interrupt types of camss interrupts

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sdm845: Fix interrupt types of camss interrupts

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    dts: arm64: mediatek: mt8195: Remove MT8183 compatible for OVL

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp: Fix up remoteproc register space sizes

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8150-microsoft-surface-duo: fix typos in da7280 properties

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: sc7180-*: Remove thermal zone polling delays

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: pm6150l: add temp sensor and thermal zone config

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-quackingstick: add missing avee-supply

Nikita Travkin <nikita@trvn.ru>
    arm64: dts: qcom: sc7180: Drop redundant disable in mdp

Nikita Travkin <nikita@trvn.ru>
    arm64: dts: qcom: sc7180: Don't enable lpass clocks by default

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-wormdingler: use just "port" in panel

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180-trogdor-quackingstick: use just "port" in panel

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc7180-idp: use just "port" in panel

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    arm64: dts: qcom: sc7180: Add compat qcom,sc7180-dsi-ctrl

Bryan Brattlof <bb@ti.com>
    arm64: dts: ti: k3-am62a: Remove duplicate GICR reg

Bryan Brattlof <bb@ti.com>
    arm64: dts: ti: k3-am62: Remove duplicate GICR reg

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8450: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8350: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8250: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm6125: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sc7280: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8994: correct sleep clock frequency

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8916: correct sleep clock frequency

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Drop extra qcom,msm-id value

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8994: Describe USB interrupts

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8996: Fix up USB3 interrupts

Marek Vasut <marex@denx.de>
    arm64: dts: qcom: msm8996-xiaomi-gemini: Fix LP5562 LED1 reg property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-kukui-jacuzzi: Drop pp3300_panel voltage settings

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    memory: tegra20-emc: fix an OF node reference bug in tegra_emc_find_node_by_ram_code()

Ma Ke <make_ruc2021@163.com>
    RDMA/srp: Fix error handling in srp_add_port

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mediatek: mt8183: willow: Support second source touchscreen

Hsin-Te Yuan <yuanhsinte@chromium.org>
    arm64: dts: mediatek: mt8183: kenzo: Support second source touchscreen

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm: Fix MT6397 PMIC sub-node names

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-demo: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8195-cherry: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8192-asurada: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-elm: Drop regulator-compatible property

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8173-evb: Drop regulator-compatible property

Dan Carpenter <dan.carpenter@linaro.org>
    rdma/cxgb4: Prevent potential integer overflow on 32bit

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx4: Avoid false error about access to uninitialized gids array

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: reserve 192 KiB for TF-A

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: add i2c clock-div property

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: fix wdt irq type

Val Packett <val@packett.cool>
    arm64: dts: mediatek: mt8516: fix GICv2 range

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8183: set DMIC one-wire mode on Damu

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: change BU Power Switch to automatic mode

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    soc: atmel: fix device_node release in atmel_soc_device_init()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix oops due to unset link speed

Chen Ridong <chenridong@huawei.com>
    padata: avoid UAF for reorder_work

Chen Ridong <chenridong@huawei.com>
    padata: add pd get/put refcnt helper

Chen Ridong <chenridong@huawei.com>
    padata: fix UAF in padata_reorder

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed headphone distorted sound on Acer Aspire A115-31 laptop

Daniel Xu <dxu@dxuuu.xyz>
    bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write

Puranjay Mohan <puranjay@kernel.org>
    bpf: Send signals asynchronously if !preemptible

Mingwei Zheng <zmw12306@gmail.com>
    pinctrl: stm32: Add check for clk_enable()

Ma Ke <make24@iscas.ac.cn>
    pinctrl: stm32: check devm_kasprintf() returned value

Chen Ni <nichen@iscas.ac.cn>
    pinctrl: stm32: Add check for devm_kcalloc

Valentin Caron <valentin.caron@foss.st.com>
    pinctrl: stm32: set default gpio line names using pin names

Jiachen Zhang <me@jcix.top>
    perf report: Fix misleading help message about --demangle

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix theoretical infinite loop

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf namespaces: Fixup the nsinfo__in_pidns() return type, its bool

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf namespaces: Introduce nsinfo__set_in_pidns()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf top: Don't complain about lack of vmlinux when not resolving some kernel samples

Thomas Weißschuh <linux@weissschuh.net>
    padata: fix sysfs store callback check

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - fix for aead invalid authsize

Wenkai Lin <linwenkai6@hisilicon.com>
    crypto: hisilicon/sec2 - fix for aead icv error

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec2 - optimize the error return process

Ba Jing <bajing@cmss.chinamobile.com>
    ktest.pl: Remove unused declarations in run_bisect_test function

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    ASoC: renesas: rz-ssi: Use only the proper amount of dividers

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf bpf: Fix two memory leakages when calling perf_env__insert_bpf_prog_info()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_prog_info()

Zhongqiu Han <quic_zhonhan@quicinc.com>
    perf header: Fix one memory leakage in process_bpf_btf()

George Lander <lander@jagmn.com>
    ASoC: sun4i-spdif: Add clock multiplier settings

Quentin Monnet <qmo@kernel.org>
    libbpf: Fix segfault due to libelf functions not setting errno

Marco Leogrande <leogrande@google.com>
    tools/testing/selftests/bpf/test_tc_tunnel.sh: Fix wait for server bind

Andrii Nakryiko <andrii@kernel.org>
    libbpf: don't adjust USDT semaphore address if .stapsdt.base addr is missing

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/rose: prevent integer overflows in rose_setsockopt()

Mahdi Arghavani <ma.arghavani@yahoo.com>
    tcp_cubic: fix incorrect HyStart round start detection

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: fix freeing IRQ in am65_cpsw_nuss_remove_tx_chns()

Florian Westphal <fw@strlen.de>
    netfilter: nft_flow_offload: update tcp state flags under lock

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: Disallow replacing of child qdisc from one parent to another

Antoine Tenart <atenart@kernel.org>
    net: avoid race between device unregistration and ethnl ops

Maher Sanalla <msanalla@nvidia.com>
    net/mlxfw: Drop hard coded max FW flash image size

Liu Jian <liujian56@huawei.com>
    net: let net.core.dev_weight always be non-zero

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fix error message

Mingwei Zheng <zmw12306@gmail.com>
    pwm: stm32: Add check for clk_enable()

Bo Gan <ganboing@gmail.com>
    clk: analogbits: Fix incorrect calculation of vco rate delta

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: adjust allocation of colocated AP data

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Handle specific BSSID in 6GHz scanning

Dmitry V. Levin <ldv@strace.io>
    selftests: harness: fix printing of mismatch values in __EXPECT()

Geert Uytterhoeven <geert+renesas@glider.be>
    selftests: timers: clocksource-switch: Adapt progress to kselftest framework

Gautham R. Shenoy <gautham.shenoy@amd.com>
    cpufreq: ACPI: Fix max-frequency computation

Peter Chiu <chui-hao.chiu@mediatek.com>
    wifi: mt76: mt7915: fix register mapping

Michael Lo <michael.lo@mediatek.com>
    wifi: mt76: mt7921: fix using incorrect group cipher after disconnection.

WangYuli <wangyuli@uniontech.com>
    wifi: mt76: mt76u_vendor_request: Do not print error messages when -EPROTO

Mickaël Salaün <mic@digikod.net>
    landlock: Handle weird files

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: fix data error when recvmsg with MSG_PEEK flag

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Fix common size calculation for ML element

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: prohibit deactivating all links

Andreas Kemnade <andreas@kemnade.info>
    wifi: wlcore: fix unbalanced pm_runtime calls

Zichen Xie <zichenxie0106@gmail.com>
    samples/landlock: Fix possible NULL dereference in parse_path()

Rob Herring (Arm) <robh@kernel.org>
    mfd: syscon: Fix race in device_node_get_regmap()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: syscon: Use scoped variables with memory allocators to simplify error paths

Peter Griffin <peter.griffin@linaro.org>
    mfd: syscon: Add of_syscon_register_regmap() API

Peter Griffin <peter.griffin@linaro.org>
    mfd: syscon: Remove extern from function prototypes

Karol Przybylski <karprzy7@gmail.com>
    HID: hid-thrustmaster: Fix warning in thrustmaster_probe by adding endpoint check

Amit Pundir <amit.pundir@linaro.org>
    clk: qcom: gcc-sdm845: Do not use shared clk_ops for QUPs

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    OPP: OF: Fix an OF node leak in _opp_add_static_v2()

Eric Dumazet <edumazet@google.com>
    ax25: rcu protect dev->ax25_ptr

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    regulator: of: Implement the unwind path of of_regulator_match()

Octavian Purdila <tavip@google.com>
    team: prevent adding a device which is already a team device lower

Marek Vasut <marex@denx.de>
    clk: imx8mp: Fix clkout1/2 support

Sultan Alsawaf (unemployed) <sultan@kerneltoast.com>
    cpufreq: schedutil: Fix superfluous updates caused by need_freq_update

Mingwei Zheng <zmw12306@gmail.com>
    pwm: stm32-lp: Add check for clk_enable()

Eric Dumazet <edumazet@google.com>
    inetpeer: do not get a refcount in inet_getpeer()

Eric Dumazet <edumazet@google.com>
    inetpeer: update inetpeer timestamp in inet_getpeer()

Eric Dumazet <edumazet@google.com>
    inetpeer: remove create argument of inet_getpeer()

Eric Dumazet <edumazet@google.com>
    inetpeer: remove create argument of inet_getpeer_v[46]()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()

Matti Vaittinen <mazziesaccount@gmail.com>
    dt-bindings: mfd: bd71815: Fix rsense and typos

He Rongguang <herongguang@linux.alibaba.com>
    cpupower: fix TSC MHz calculation

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    ACPI: fan: cleanup resources in the error path of .probe()

Chen-Yu Tsai <wenst@chromium.org>
    regulator: dt-bindings: mt6315: Drop regulator-compatible property

Jiri Kosina <jkosina@suse.com>
    HID: multitouch: fix support for Goodix PID 0x01e9

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: pci: wait for firmware loading before releasing memory

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix memory leaks and invalid access at probe error path

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: destroy workqueue at rtl_deinit_core

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: remove unused check_buddy_priv

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtlwifi: remove unused dualmac control leftovers

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtlwifi: remove unused timer and related code

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: leds: class-multicolor: Fix path to color definitions

Neil Armstrong <neil.armstrong@linaro.org>
    dt-bindings: mmc: controller: clarify the address-cells description

Mingwei Zheng <zmw12306@gmail.com>
    spi: zynq-qspi: Add check for clk_enable()

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: don't allow 1 packet limit

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: handle bigger packets

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: annotate data-races around q->perturb_period

Barnabás Czémán <barnabas.czeman@mainlining.org>
    wifi: wcn36xx: fix channel survey memory allocation size

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: usb: fix workqueue leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: fix init_sw_vars leak when probe fails

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: wait for firmware loading before releasing memory

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: rtl8192se: rise completion of firmware loading as last step

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    wifi: rtlwifi: do not complete firmware loading needlessly

Balaji Pothunoori <quic_bpothuno@quicinc.com>
    wifi: ath11k: Fix unexpected return buffer manager error for WCN6750/WCN6855

Charles Han <hanchunchao@inspur.com>
    ipmi: ipmb: Add check devm_kasprintf() returned value

Thomas Gleixner <tglx@linutronix.de>
    genirq: Make handle_enforce_irqctx() unconditionally available

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE

Neil Armstrong <neil.armstrong@linaro.org>
    OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized

Neil Armstrong <neil.armstrong@linaro.org>
    OPP: add index check to assert to avoid buffer overflow in _read_freq()

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Reuse dev_pm_opp_get_freq_indexed()

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Add dev_pm_opp_find_freq_exact_indexed()

Manivannan Sadhasivam <mani@kernel.org>
    OPP: Introduce dev_pm_opp_get_freq_indexed() API

Manivannan Sadhasivam <mani@kernel.org>
    OPP: Introduce dev_pm_opp_find_freq_{ceil/floor}_indexed() APIs

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Rearrange entries in pm_opp.h

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Check linear format for Cluster windows on rk3566/8

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the windows switch between different layers

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: set bg dly and prescan dly at vop2_post_config

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Set YUV/RGB overlay mode

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the mixer alpha setup for layer 0

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix cluster windows alpha ctrl regsiters offset

Ivan Stepchenko <sid@itb.spb.ru>
    drm/amdgpu: Fix potential NULL pointer dereference in atomctrl_get_smc_sclk_range_table

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Fix assumption that Resolution Multipliers must be in Logical Collections

Sui Jingfeng <sui.jingfeng@linux.dev>
    drm/etnaviv: Fix page property being used for non writecombine buffers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: set safe_to_exit_level before printing it

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix value reported by hot tasks pulled in /proc/schedstat

Chengming Zhou <zhouchengming@bytedance.com>
    sched/psi: Use task->psi_flags to clear in CPU migration

David Howells <dhowells@redhat.com>
    afs: Fix the fallback handling for the YFS.RemoveFile2 RPC call

Christophe Leroy <christophe.leroy@csgroup.eu>
    select: Fix unbalanced user_access_end()

Randy Dunlap <rdunlap@infradead.org>
    partitions: ldm: remove the initial kernel-doc notation

Michael Ellerman <mpe@ellerman.id.au>
    selftests/powerpc: Fix argument order to timer_sub()

Keisuke Nishimura <keisuke.nishimura@inria.fr>
    nvme: Add error check for xa_store in nvme_get_effects_log

Eugen Hristev <eugen.hristev@linaro.org>
    pstore/blk: trivial typo fixes

Yu Kuai <yukuai3@huawei.com>
    nbd: don't allow reconnect after disconnect

Yang Erkun <yangerkun@huawei.com>
    block: retry call probe after request_module in blk_request_module

Jinliang Zheng <alexjlzheng@gmail.com>
    fs: fix proc_handler for sysctl_nr_open

David Howells <dhowells@redhat.com>
    afs: Fix directory format encoding struct

David Howells <dhowells@redhat.com>
    afs: Fix EEXIST error returned from afs_rmdir() to be ENOTEMPTY

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/book3s64/hugetlb: Fix disabling hugetlb when fadump is active


-------------

Diffstat:

 .../bindings/leds/leds-class-multicolor.yaml       |   2 +-
 .../devicetree/bindings/mfd/rohm,bd71815-pmic.yaml |  20 +--
 .../devicetree/bindings/mmc/mmc-controller.yaml    |   2 +-
 .../bindings/regulator/mt6315-regulator.yaml       |   6 -
 Documentation/kbuild/kconfig.rst                   |   9 ++
 Makefile                                           |   6 +-
 arch/alpha/include/uapi/asm/ptrace.h               |   2 +
 arch/alpha/kernel/asm-offsets.c                    |   2 +
 arch/alpha/kernel/entry.S                          |  24 ++-
 arch/alpha/kernel/traps.c                          |   2 +-
 arch/alpha/mm/fault.c                              |   4 +-
 arch/arm/boot/dts/dra7-l4.dtsi                     |   2 +
 arch/arm/boot/dts/mt7623.dtsi                      |   2 +-
 arch/arm/mach-at91/pm.c                            |  31 ++--
 arch/arm64/boot/dts/mediatek/mt8173-elm.dtsi       |  29 +---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |  25 +---
 .../dts/mediatek/mt8183-kukui-jacuzzi-damu.dts     |   4 +
 .../dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts    |  15 ++
 .../dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi  |  15 ++
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi.dtsi    |   2 -
 arch/arm64/boot/dts/mediatek/mt8192-asurada.dtsi   |   3 -
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi    |   2 -
 arch/arm64/boot/dts/mediatek/mt8195-demo.dts       |   9 --
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt8516.dtsi           |  11 +-
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   2 -
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   6 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |  11 +-
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts |   2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |   9 +-
 arch/arm64/boot/dts/qcom/pm6150.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/pm6150l.dtsi              |  35 +++++
 arch/arm64/boot/dts/qcom/sc7180-idp.dts            |  15 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi |   1 -
 .../boot/dts/qcom/sc7180-trogdor-homestar.dtsi     |   1 -
 .../arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi |   7 +-
 .../dts/qcom/sc7180-trogdor-quackingstick.dtsi     |  12 +-
 .../boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi  |  12 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |   9 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  34 +----
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |   6 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  20 +--
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   2 +-
 .../boot/dts/qcom/sm8150-microsoft-surface-duo.dts |   4 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  30 ++--
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   4 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi           |   1 -
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi          |   1 -
 arch/arm64/kernel/cacheinfo.c                      |  12 +-
 arch/arm64/kernel/vdso/vdso.lds.S                  |   1 +
 arch/arm64/kernel/vmlinux.lds.S                    |   1 +
 arch/arm64/mm/hugetlbpage.c                        |  12 ++
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/kernel/traps.c                        |   4 +-
 arch/m68k/include/asm/vga.h                        |   8 +-
 arch/mips/kernel/ftrace.c                          |   2 +-
 arch/mips/loongson64/boardinfo.c                   |   2 -
 arch/mips/math-emu/cp1emu.c                        |   2 +-
 arch/powerpc/include/asm/hugetlb.h                 |   9 ++
 arch/powerpc/kvm/e500_mmu_host.c                   |  21 +--
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   6 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/include/asm/futex.h                      |   2 +-
 arch/s390/kvm/vsie.c                               |  25 +++-
 arch/s390/purgatory/Makefile                       |   2 +-
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/events/intel/core.c                       |   5 +-
 arch/x86/include/asm/kexec.h                       |  18 ++-
 arch/x86/include/asm/mmu.h                         |   2 +
 arch/x86/include/asm/mmu_context.h                 |   1 +
 arch/x86/include/asm/msr-index.h                   |   3 +-
 arch/x86/include/asm/tlbflush.h                    |   1 +
 arch/x86/kernel/amd_nb.c                           |   4 +
 arch/x86/kernel/i8253.c                            |  11 +-
 arch/x86/kernel/machine_kexec_64.c                 |  45 +++---
 arch/x86/kernel/static_call.c                      |   1 -
 arch/x86/kvm/hyperv.c                              |   6 +-
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/svm/nested.c                          |  10 +-
 arch/x86/mm/tlb.c                                  |  35 ++++-
 arch/x86/xen/mmu_pv.c                              |  79 ++++++++--
 arch/x86/xen/xen-head.S                            |   5 +-
 block/blk-cgroup.c                                 |   1 +
 block/fops.c                                       |   5 +-
 block/genhd.c                                      |  22 ++-
 block/partitions/ldm.h                             |   2 +-
 block/partitions/mac.c                             |  18 ++-
 drivers/acpi/apei/ghes.c                           |  10 +-
 drivers/acpi/fan_core.c                            |  10 +-
 drivers/acpi/prmt.c                                |   4 +-
 drivers/acpi/property.c                            |  10 +-
 drivers/ata/libata-sff.c                           |  18 ++-
 drivers/base/regmap/regmap-irq.c                   |   2 +
 drivers/block/nbd.c                                |   1 +
 drivers/char/ipmi/ipmb_dev_int.c                   |   3 +
 drivers/clk/analogbits/wrpll-cln28hpc.c            |   2 +-
 drivers/clk/imx/clk-imx8mp.c                       |   5 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
 drivers/clk/qcom/clk-rpmh.c                        |   2 +-
 drivers/clk/qcom/dispcc-sm6350.c                   |   7 +-
 drivers/clk/qcom/gcc-mdm9607.c                     |   2 +-
 drivers/clk/qcom/gcc-sdm845.c                      |  32 ++--
 drivers/clk/qcom/gcc-sm6350.c                      |  22 ++-
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c             |   6 +-
 drivers/clocksource/i8253.c                        |  13 +-
 drivers/cpufreq/acpi-cpufreq.c                     |  36 +++--
 drivers/cpufreq/s3c64xx-cpufreq.c                  |  11 +-
 drivers/crypto/hisilicon/sec2/sec.h                |   3 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         | 164 ++++++++++-----------
 drivers/crypto/hisilicon/sec2/sec_crypto.h         |  11 --
 drivers/crypto/ixp4xx_crypto.c                     |   3 +
 drivers/crypto/qce/aead.c                          |   2 +-
 drivers/crypto/qce/core.c                          |  13 +-
 drivers/crypto/qce/sha.c                           |   2 +-
 drivers/crypto/qce/skcipher.c                      |   2 +-
 drivers/dma/ti/edma.c                              |   3 +-
 drivers/firmware/Kconfig                           |   2 +-
 drivers/firmware/efi/efi.c                         |   6 +-
 drivers/firmware/efi/libstub/Makefile              |   2 +-
 drivers/firmware/efi/libstub/randomalloc.c         |   3 +
 drivers/firmware/efi/libstub/relocate.c            |   3 +
 drivers/firmware/efi/sysfb_efi.c                   |   2 +-
 drivers/gpio/gpio-bcm-kona.c                       |  71 +++++++--
 drivers/gpio/gpio-mxc.c                            |   3 +-
 drivers/gpio/gpio-pca953x.c                        |  19 ---
 drivers/gpio/gpio-stmpe.c                          |  15 +-
 drivers/gpio/gpio-xilinx.c                         |  56 +++----
 drivers/gpio/gpiolib-acpi.c                        |  14 ++
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   6 +-
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |   8 +
 .../amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c   |   8 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   2 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |   3 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   3 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   5 +
 .../drm/amd/display/dc/dcn314/dcn314_resource.c    |   5 +
 .../drm/amd/display/dc/dcn315/dcn315_resource.c    |   2 +
 .../drm/amd/display/dc/dcn316/dcn316_resource.c    |   2 +
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   5 +
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |   2 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |   2 +
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   1 -
 .../drm/arm/display/komeda/komeda_wb_connector.c   |   4 +
 drivers/gpu/drm/bridge/ite-it6505.c                |  65 ++++----
 drivers/gpu/drm/display/drm_dp_cec.c               |  14 +-
 drivers/gpu/drm/drm_fb_helper.c                    |  14 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c              |  16 +-
 drivers/gpu/drm/i915/display/skl_universal_plane.c |   4 -
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  20 ++-
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c      |   4 +-
 drivers/gpu/drm/msm/dp/dp_audio.c                  |   2 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   9 +-
 drivers/gpu/drm/rockchip/rockchip_drm_drv.h        |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       | 120 +++++++++++----
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.h       |   1 +
 drivers/gpu/drm/tidss/tidss_dispc.c                |  22 +--
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |   5 +
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   7 +
 drivers/gpu/drm/virtio/virtgpu_plane.c             |  58 +++++---
 drivers/hid/hid-core.c                             |   2 +
 drivers/hid/hid-multitouch.c                       |   7 +-
 drivers/hid/hid-sensor-hub.c                       |  21 ++-
 drivers/hid/hid-thrustmaster.c                     |   8 +
 drivers/hid/wacom_wac.c                            |   5 +
 drivers/i2c/i2c-core-acpi.c                        |  22 +++
 drivers/i3c/master.c                               |   2 +-
 drivers/i3c/master/i3c-master-cdns.c               |   1 +
 drivers/iio/light/as73211.c                        |  24 ++-
 drivers/infiniband/hw/cxgb4/device.c               |   6 +-
 drivers/infiniband/hw/efa/efa_main.c               |   9 +-
 drivers/infiniband/hw/mlx4/main.c                  |   6 +-
 drivers/infiniband/hw/mlx5/odp.c                   |  32 ++--
 drivers/infiniband/sw/rxe/rxe_pool.c               |  11 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   1 -
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  17 ++-
 drivers/irqchip/irq-apple-aic.c                    |   3 +-
 drivers/leds/leds-lp8860.c                         |   2 +-
 drivers/leds/leds-netxbig.c                        |   1 +
 drivers/mailbox/tegra-hsp.c                        |   6 +-
 drivers/md/dm-crypt.c                              |  27 ++--
 drivers/media/dvb-frontends/cxd2841er.c            |   8 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/ccs/ccs-data.c                   |  14 +-
 drivers/media/i2c/imx412.c                         |  42 +++---
 drivers/media/i2c/ov5640.c                         |   1 +
 drivers/media/i2c/ov9282.c                         |   2 +-
 drivers/media/platform/marvell/mcam-core.c         |   7 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |   7 +-
 .../media/platform/samsung/exynos4-is/mipi-csis.c  |  10 +-
 .../media/platform/samsung/s3c-camif/camif-core.c  |  13 +-
 drivers/media/rc/iguanair.c                        |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   8 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |  12 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   8 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  70 ++++-----
 drivers/media/usb/uvc/uvc_queue.c                  |   3 +-
 drivers/media/usb/uvc/uvc_status.c                 |   1 +
 drivers/media/v4l2-core/v4l2-mc.c                  |   2 +-
 drivers/memory/tegra/tegra20-emc.c                 |   8 +-
 drivers/mfd/lpc_ich.c                              |   3 +-
 drivers/mfd/syscon.c                               |  81 +++++++---
 drivers/misc/cardreader/rtsx_usb.c                 |  15 ++
 drivers/misc/fastrpc.c                             |   8 +-
 drivers/mmc/core/sdio.c                            |   2 +
 drivers/mmc/host/mtk-sd.c                          |  31 ++--
 drivers/mmc/host/sdhci-msm.c                       |  53 ++++++-
 drivers/mtd/hyperbus/hbmc-am654.c                  |  25 ++--
 drivers/mtd/nand/onenand/onenand_base.c            |   1 +
 drivers/net/can/c_can/c_can_platform.c             |   5 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |  10 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   4 +-
 drivers/net/ethernet/broadcom/bgmac.h              |   3 +-
 drivers/net/ethernet/broadcom/tg3.c                |  58 ++++++++
 drivers/net/ethernet/davicom/dm9000.c              |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |  31 +++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.c        |  15 ++
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   2 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  19 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  24 +--
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |   2 -
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   4 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/netdevsim/ipsec.c                      |  12 +-
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/netdevsim/udp_tunnels.c                |  23 +--
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +
 drivers/net/team/team.c                            |  11 +-
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/rtl8150.c                          |  22 +++
 drivers/net/vxlan/vxlan_core.c                     |   7 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   5 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   3 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   8 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   4 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  29 +---
 drivers/net/wireless/realtek/rtlwifi/base.h        |   2 -
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  66 ++-------
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  12 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  23 ---
 drivers/net/wireless/ti/wlcore/main.c              |  10 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  56 ++++++-
 drivers/nvme/host/core.c                           |  16 +-
 drivers/nvme/host/ioctl.c                          |   8 +-
 drivers/nvme/host/pci.c                            |   4 +-
 drivers/nvmem/core.c                               |   2 +
 drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
 drivers/of/base.c                                  |   8 +-
 drivers/of/of_reserved_mem.c                       |   7 +-
 drivers/opp/core.c                                 | 156 ++++++++++++++++----
 drivers/opp/of.c                                   |   4 +-
 drivers/parport/parport_pc.c                       |   5 +
 drivers/pci/controller/pcie-rcar-ep.c              |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  51 +++----
 drivers/pci/endpoint/pci-epc-core.c                |   2 +-
 drivers/pci/endpoint/pci-epf-core.c                |   1 +
 drivers/pci/quirks.c                               |  12 ++
 drivers/pci/switch/switchtec.c                     |  26 ++++
 drivers/pinctrl/pinctrl-cy8c95x0.c                 |   2 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              | 105 +++++++++----
 drivers/platform/x86/acer-wmi.c                    |   4 +
 drivers/platform/x86/intel/int3472/discrete.c      |   3 +
 drivers/platform/x86/intel/int3472/tps68470.c      |   3 +
 drivers/pps/clients/pps-gpio.c                     |   4 +-
 drivers/pps/clients/pps-ktimer.c                   |   4 +-
 drivers/pps/clients/pps-ldisc.c                    |   6 +-
 drivers/pps/clients/pps_parport.c                  |   4 +-
 drivers/pps/kapi.c                                 |  10 +-
 drivers/pps/kc.c                                   |  10 +-
 drivers/pps/pps.c                                  | 127 ++++++++--------
 drivers/ptp/ptp_chardev.c                          |   4 +
 drivers/ptp/ptp_clock.c                            |   8 +
 drivers/ptp/ptp_ocp.c                              |   2 +-
 drivers/pwm/pwm-stm32-lp.c                         |   8 +-
 drivers/pwm/pwm-stm32.c                            |   7 +-
 drivers/regulator/core.c                           |   2 +-
 drivers/regulator/of_regulator.c                   |  14 +-
 drivers/remoteproc/remoteproc_core.c               |  14 +-
 drivers/rtc/rtc-pcf85063.c                         |  11 +-
 drivers/rtc/rtc-zynqmp.c                           |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   3 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_dfs.c                     | 122 ++++++++++++---
 drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +
 drivers/scsi/qla2xxx/qla_init.c                    |  28 ++--
 drivers/scsi/storvsc_drv.c                         |   1 +
 drivers/soc/atmel/soc.c                            |   2 +-
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/spi/spi-zynq-qspi.c                        |  13 +-
 drivers/staging/media/imx/imx-media-of.c           |   8 +-
 drivers/staging/media/max96712/max96712.c          |   4 +-
 drivers/tty/serial/8250/8250.h                     |   2 +
 drivers/tty/serial/8250/8250_dma.c                 |  16 ++
 drivers/tty/serial/8250/8250_pci.c                 |  10 ++
 drivers/tty/serial/8250/8250_port.c                |  41 +++++-
 drivers/tty/serial/sh-sci.c                        |  25 +++-
 drivers/tty/serial/xilinx_uartps.c                 |  10 +-
 drivers/ufs/core/ufs_bsg.c                         |   2 +
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  31 ++--
 drivers/usb/class/cdc-acm.c                        |  28 +++-
 drivers/usb/core/hub.c                             |  14 +-
 drivers/usb/core/quirks.c                          |   6 +
 drivers/usb/dwc2/gadget.c                          |   1 +
 drivers/usb/dwc3/core.c                            |  30 ++--
 drivers/usb/dwc3/dwc3-am62.c                       |   1 +
 drivers/usb/dwc3/gadget.c                          |  34 +++++
 drivers/usb/gadget/function/f_midi.c               |   8 +-
 drivers/usb/gadget/function/f_tcm.c                |  66 ++++-----
 drivers/usb/gadget/udc/renesas_usb3.c              |   2 +-
 drivers/usb/host/pci-quirks.c                      |   9 ++
 drivers/usb/host/xhci-ring.c                       |   3 +-
 drivers/usb/roles/class.c                          |   5 +-
 drivers/usb/serial/option.c                        |  49 +++---
 drivers/usb/typec/tcpm/tcpci.c                     |  13 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  10 +-
 drivers/vfio/iova_bitmap.c                         |   2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |   1 +
 drivers/vfio/platform/vfio_platform_common.c       |  10 ++
 drivers/video/fbdev/omap/lcd_dma.c                 |   4 +-
 drivers/video/fbdev/omap2/omapfb/dss/dss-of.c      |   1 +
 drivers/xen/swiotlb-xen.c                          |  20 ++-
 fs/afs/dir.c                                       |   7 +-
 fs/afs/xdr_fs.h                                    |   2 +-
 fs/afs/yfsclient.c                                 |   5 +-
 fs/binfmt_flat.c                                   |   2 +-
 fs/btrfs/file.c                                    |   6 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/super.c                                   |   2 +-
 fs/btrfs/transaction.c                             |   4 +-
 fs/cachefiles/interface.c                          |  14 +-
 fs/cachefiles/ondemand.c                           |  30 +++-
 fs/exec.c                                          |  29 +++-
 fs/f2fs/dir.c                                      |  53 +++++--
 fs/f2fs/f2fs.h                                     |   6 +-
 fs/f2fs/file.c                                     |  13 ++
 fs/f2fs/inline.c                                   |   5 +-
 fs/file_table.c                                    |   2 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  27 +++-
 fs/nfs/nfs42proc.c                                 |   2 +-
 fs/nfs/nfs42xdr.c                                  |   2 +
 fs/nfsd/nfs2acl.c                                  |   2 +
 fs/nfsd/nfs3acl.c                                  |   2 +
 fs/nfsd/nfs4callback.c                             |   8 +-
 fs/nilfs2/inode.c                                  |  10 +-
 fs/nilfs2/mdt.c                                    |   6 +-
 fs/nilfs2/page.c                                   |  55 ++++---
 fs/nilfs2/page.h                                   |   4 +-
 fs/nilfs2/segment.c                                |   4 +-
 fs/ocfs2/dir.c                                     |  25 +++-
 fs/ocfs2/quota_global.c                            |   5 +
 fs/ocfs2/super.c                                   |   2 +-
 fs/ocfs2/symlink.c                                 |   5 +-
 fs/orangefs/orangefs-debugfs.c                     |   4 +-
 fs/proc/array.c                                    |   2 +-
 fs/pstore/blk.c                                    |   4 +-
 fs/select.c                                        |   4 +-
 fs/smb/client/cifsglob.h                           |  14 +-
 fs/smb/client/smb1ops.c                            |   2 +-
 fs/smb/client/smb2ops.c                            |  21 +--
 fs/smb/client/smb2pdu.c                            |   2 +-
 fs/smb/client/smb2proto.h                          |   2 +-
 fs/smb/server/transport_ipc.c                      |   9 ++
 fs/ubifs/debug.c                                   |  22 +--
 fs/xfs/xfs_inode.c                                 |   7 +-
 fs/xfs/xfs_qm_bhv.c                                |  41 ++++--
 fs/xfs/xfs_super.c                                 |  11 +-
 include/linux/binfmts.h                            |   4 +-
 include/linux/cgroup-defs.h                        |   6 +-
 include/linux/efi.h                                |   1 +
 include/linux/i8253.h                              |   1 +
 include/linux/ieee80211.h                          |  11 +-
 include/linux/iommu.h                              |   2 +-
 include/linux/kallsyms.h                           |   2 +-
 include/linux/kvm_host.h                           |   9 ++
 include/linux/mfd/syscon.h                         |  33 +++--
 include/linux/mlx5/driver.h                        |   1 -
 include/linux/netdevice.h                          |   8 +-
 include/linux/pci_ids.h                            |   4 +
 include/linux/pm_opp.h                             |  72 ++++++---
 include/linux/pps_kernel.h                         |   3 +-
 include/linux/sched.h                              |   4 +-
 include/linux/sched/task.h                         |   1 +
 include/linux/usb/tcpm.h                           |   3 +-
 include/net/ax25.h                                 |  10 +-
 include/net/inetpeer.h                             |  12 +-
 include/net/l3mdev.h                               |   2 +
 include/net/net_namespace.h                        |  15 +-
 include/net/route.h                                |   9 +-
 include/net/sch_generic.h                          |   2 +-
 include/rv/da_monitor.h                            |   4 +
 include/uapi/linux/input-event-codes.h             |   1 +
 include/ufs/ufs.h                                  |   4 +-
 io_uring/io_uring.c                                |   5 +-
 io_uring/net.c                                     |   5 +
 io_uring/poll.c                                    |   4 +
 io_uring/rw.c                                      |  10 ++
 kernel/cgroup/cgroup.c                             |  20 ++-
 kernel/cgroup/rstat.c                              |   1 -
 kernel/debug/kdb/kdb_io.c                          |   2 +
 kernel/irq/internals.h                             |   9 +-
 kernel/padata.c                                    |  45 ++++--
 kernel/power/hibernate.c                           |   7 +-
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/core.c                                |   8 +-
 kernel/sched/cpufreq_schedutil.c                   |   4 +-
 kernel/sched/fair.c                                |  17 ++-
 kernel/sched/stats.h                               |  22 +--
 kernel/time/clocksource.c                          |   9 +-
 kernel/trace/bpf_trace.c                           |   2 +-
 lib/Kconfig.debug                                  |   8 +-
 lib/maple_tree.c                                   |  22 +--
 mm/gup.c                                           |  14 +-
 mm/kfence/core.c                                   |   2 +
 mm/kmemleak.c                                      |   2 +-
 net/ax25/af_ax25.c                                 |  23 ++-
 net/ax25/ax25_dev.c                                |   4 +-
 net/ax25/ax25_ip.c                                 |   3 +-
 net/ax25/ax25_out.c                                |  22 ++-
 net/ax25/ax25_route.c                              |   2 +
 net/batman-adv/bat_v.c                             |   2 -
 net/batman-adv/bat_v_elp.c                         | 122 ++++++++++-----
 net/batman-adv/bat_v_elp.h                         |   2 -
 net/batman-adv/types.h                             |   3 -
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/bluetooth/mgmt.c                               |  12 +-
 net/can/j1939/socket.c                             |   4 +-
 net/can/j1939/transport.c                          |   5 +-
 net/core/filter.c                                  |   2 +-
 net/core/flow_dissector.c                          |  21 +--
 net/core/neighbour.c                               |  11 +-
 net/core/sysctl_net_core.c                         |   5 +-
 net/dsa/slave.c                                    |   7 +-
 net/ethtool/netlink.c                              |   2 +-
 net/hsr/hsr_forward.c                              |   7 +-
 net/ipv4/arp.c                                     |   4 +-
 net/ipv4/devinet.c                                 |   3 +-
 net/ipv4/icmp.c                                    |  40 ++---
 net/ipv4/inetpeer.c                                |  31 +---
 net/ipv4/ip_fragment.c                             |  15 +-
 net/ipv4/ipmr_base.c                               |   3 -
 net/ipv4/route.c                                   |  56 +++++--
 net/ipv4/tcp_cubic.c                               |   8 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/icmp.c                                    |   6 +-
 net/ipv6/ip6_output.c                              |   6 +-
 net/ipv6/mcast.c                                   |  14 +-
 net/ipv6/ndisc.c                                   |  36 +++--
 net/ipv6/route.c                                   |   7 +-
 net/ipv6/udp.c                                     |   4 +-
 net/mac80211/debugfs_netdev.c                      |   2 +-
 net/mptcp/options.c                                |  13 +-
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.c                               |   5 +-
 net/mptcp/protocol.h                               |  30 ++--
 net/ncsi/internal.h                                |   2 +
 net/ncsi/ncsi-cmd.c                                |   3 +-
 net/ncsi/ncsi-manage.c                             |  38 +++--
 net/ncsi/ncsi-pkt.h                                |  10 ++
 net/ncsi/ncsi-rsp.c                                |  58 ++++++--
 net/netfilter/nf_tables_api.c                      |   8 +-
 net/netfilter/nft_flow_offload.c                   |  16 +-
 net/nfc/nci/hci.c                                  |   2 +
 net/openvswitch/datapath.c                         |  12 +-
 net/rose/af_rose.c                                 |  40 +++--
 net/rose/rose_timer.c                              |  15 ++
 net/sched/sch_api.c                                |   4 +
 net/sched/sch_netem.c                              |   2 +-
 net/sched/sch_sfq.c                                |  58 ++++----
 net/smc/af_smc.c                                   |   2 +-
 net/smc/smc_rx.c                                   |  37 +++--
 net/smc/smc_rx.h                                   |   8 +-
 net/tipc/crypto.c                                  |   4 +-
 net/wireless/scan.c                                |  35 +++++
 net/xfrm/xfrm_replay.c                             |  10 +-
 samples/landlock/sandboxer.c                       |   7 +
 scripts/Makefile.extrawarn                         |   5 +-
 scripts/Makefile.lib                               |   4 +-
 scripts/genksyms/genksyms.c                        |  11 +-
 scripts/genksyms/genksyms.h                        |   2 +-
 scripts/genksyms/parse.y                           |  18 ++-
 scripts/kconfig/conf.c                             |   6 +
 scripts/kconfig/confdata.c                         | 102 ++++++-------
 scripts/kconfig/lkc_proto.h                        |   2 +
 scripts/kconfig/symbol.c                           |  10 ++
 security/landlock/fs.c                             |  11 +-
 security/safesetid/securityfs.c                    |   3 +
 security/tomoyo/common.c                           |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   8 +-
 sound/pci/hda/hda_auto_parser.h                    |   1 +
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/amd/Kconfig                              |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  28 ++++
 sound/soc/intel/avs/apl.c                          |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  17 ++-
 sound/soc/rockchip/rockchip_i2s_tdm.c              |  31 +++-
 sound/soc/sh/rz-ssi.c                              |   3 +-
 sound/soc/soc-pcm.c                                |  31 +++-
 sound/soc/sunxi/sun4i-spdif.c                      |   7 +
 sound/usb/quirks.c                                 |   2 +
 tools/bootconfig/main.c                            |   4 +-
 tools/lib/bpf/linker.c                             |  22 +--
 tools/lib/bpf/usdt.c                               |   2 +-
 tools/perf/bench/epoll-wait.c                      |   7 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-top.c                           |   2 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/util/bpf-event.c                        |  10 +-
 tools/perf/util/env.c                              |  13 +-
 tools/perf/util/env.h                              |   4 +-
 tools/perf/util/header.c                           |   8 +-
 tools/perf/util/namespaces.c                       |   7 +-
 tools/perf/util/namespaces.h                       |   3 +-
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |  15 +-
 tools/testing/ktest/ktest.pl                       |   7 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   1 +
 .../drivers/net/netdevsim/udp_tunnel_nic.sh        |  16 +-
 tools/testing/selftests/gpio/gpio-sim.sh           |  31 +++-
 tools/testing/selftests/kselftest_harness.h        |  24 +--
 tools/testing/selftests/landlock/fs_test.c         |   3 +-
 tools/testing/selftests/net/ipsec.c                |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   2 +-
 tools/testing/selftests/net/pmtu.sh                | 112 +++++++++++---
 tools/testing/selftests/net/rtnetlink.sh           |   4 +-
 tools/testing/selftests/net/udpgso.c               |  26 ++++
 .../selftests/powerpc/benchmarks/gettimeofday.c    |   2 +-
 .../testing/selftests/timers/clocksource-switch.c  |   6 +-
 tools/tracing/rtla/src/osnoise.c                   |   2 +-
 tools/tracing/rtla/src/timerlat_hist.c             |  19 ++-
 tools/tracing/rtla/src/timerlat_top.c              |  20 ++-
 tools/tracing/rtla/src/trace.c                     |   8 +
 tools/tracing/rtla/src/trace.h                     |   1 +
 553 files changed, 4631 insertions(+), 2332 deletions(-)


