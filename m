Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA494E571;
	Mon, 14 Oct 2024 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915898; cv=none; b=aFNzCTDE5rRU4Gpg8+Odt5gcWkSw+/CAvd+H0RZ0RD7J+Or7cX0rqKI223Xq04+q+RxsAtU7h6LqzXnmWBv4List0jFCLj7f9dSS3522Rr0jqt1pwKjVhJMYWPTAPzZlTATjHde665NR0L6rlKZeMJx1X3GQhLtLmfLUu8GCam8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915898; c=relaxed/simple;
	bh=ED020a8pGWqFn5FAnz3TGcuDDpK+viWSaF+nfPgRkkI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KKHiNCfchg2yNEYkugSeHENGGzpym4xrfjYUW7FIrbFivkOSOeBmBfm5tq1VFeZjDugQ2Iue1fn3QfloHlyuCMT78NcT0GZPFp7WVG0qeaTT54RtV55dKHLHWOrNw7ZKEpdpvT1NtO6WnpAxnMagDQTJZHWLitzJgkT9iJ8tGII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1dC9p1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1dC9p1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96139C4CEC3;
	Mon, 14 Oct 2024 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915897;
	bh=ED020a8pGWqFn5FAnz3TGcuDDpK+viWSaF+nfPgRkkI=;
	h=From:To:Cc:Subject:Date:From;
	b=q1dC9p1CNzs3aJII77923JgavwRg1Etc1y4JNvHGOrbaWqyJs3GrVsIBnAVcyjm6E
	 BpnzGbWqGTcjVezPFQPkATTznd+DYeR6f3hCjQWziy1lMWegFVWfsNYGs5YC5+c57k
	 iBryZRBX2zGxeFc5gY1ncvwfTSHKGHhyPGcpkbwY=
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
Subject: [PATCH 6.11 000/214] 6.11.4-rc1 review
Date: Mon, 14 Oct 2024 16:17:43 +0200
Message-ID: <20241014141044.974962104@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.11.4-rc1
X-KernelTest-Deadline: 2024-10-16T14:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.11.4 release.
There are 214 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.11.4-rc1

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: fix cflags posting for single issue multishot read

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: Pass domain number to pci_bus_release_domain_nr() explicitly

Patrick Roy <roypat@amazon.co.uk>
    secretmem: disable memfd_secret() if arch cannot set direct map

Alexander Gordeev <agordeev@linux.ibm.com>
    fs/proc/kcore.c: allow translation of physical memory addresses

Frederic Weisbecker <frederic@kernel.org>
    kthread: unpark only parked kthread

Joshua Hay <joshua.a.hay@intel.com>
    idpf: use actual mbx receive payload length

Ulf Hansson <ulf.hansson@linaro.org>
    PM: domains: Fix alloc/free in dev_pm_domain_attach|detach_list()

Luca Stefani <luca.stefani.ge1@gmail.com>
    btrfs: add cancellation points to trim loops

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

Gui-Dong Han <hanguidong02@outlook.com>
    ice: Fix improper handling of refcount in ice_sriov_set_msix_vec_count()

Gui-Dong Han <hanguidong02@outlook.com>
    ice: Fix improper handling of refcount in ice_dpll_init_rclk_pins()

Kun(llfl) <llfl@linux.alibaba.com>
    device-dax: correct pgoff align in dax_set_mapping()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not remove closing subflows

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle consistently DSS corruption

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: realtek: Fix MMD access on RTL8126A-integrated PHY

Christian Marangi <ansuelsmth@gmail.com>
    net: phy: Remove LED entry from LEDs list on unregister

Anatolij Gustschin <agust@denx.de>
    net: dsa: lan9303: ensure chip reset and wait for READY status

Anastasia Kovaleva <a.kovaleva@yadro.com>
    net: Fix an unsafe loop on the list

Ignat Korchagin <ignat@cloudflare.com>
    net: explicitly clear the sk pointer, when pf->create fails

Dan Carpenter <dan.carpenter@linaro.org>
    OPP: fix error code in dev_pm_opp_set_config()

Niklas Cassel <cassel@kernel.org>
    ata: libata: avoid superfluous disk spin down + spin up during hibernation

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fallback when MPTCP opts are dropped after 1st data

Michal Wilczynski <m.wilczynski@samsung.com>
    mmc: sdhci-of-dwcmshc: Prevent stale command interrupt handling

Linus Walleij <linus.walleij@linaro.org>
    Revert "mmc: mvsdio: Use sg_miter for PIO"

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb()

Martin Wilck <martin.wilck@suse.com>
    scsi: fnic: Move flush_work initialization out of if block

Daniel Palmer <daniel@0x0f.com>
    scsi: wd33c93: Don't use stale scsi_pointer value

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Free tzp copy along with the thermal zone

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Reference count the zone in thermal_zone_get_by_id()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Fix UAF in hci_enhanced_setup_sync

Matthew Auld <matthew.auld@intel.com>
    drm/xe/ct: fix xa_store() error checking

Matthew Auld <matthew.auld@intel.com>
    drm/xe/ct: prevent UAF in send_recv()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: fix connector refcounting

Matthew Auld <matthew.auld@intel.com>
    drm/xe/guc_submit: fix xa_store() error checking

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: fix hibernate entry for DCN35+

Lang Yu <lang.yu@amd.com>
    drm/amdkfd: Fix an eviction fence leak

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Stop the active perfmon before being destroyed

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Stop the active perfmon before being destroyed

Josip Pavic <Josip.Pavic@amd.com>
    drm/amd/display: Clear update flags after update has been applied

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: partially revert powerplay `__counted_by` changes

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Make Asus ExpertBook B2502 matches cover more models

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Make Asus ExpertBook B2402 matches cover more models

SurajSonawane2415 <surajsonawane0215@gmail.com>
    hid: intel-ish-hid: Fix uninitialized variable 'rv' in ish_fw_xfer_direct_dma

John Keeping <jkeeping@inmusicbrands.com>
    usb: gadget: core: force synchronous registration

Roy Luo <royluo@google.com>
    usb: dwc3: re-enable runtime PM after failed resume

Icenowy Zheng <uwu@icenowy.me>
    usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip

Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
    usb: xhci: Fix problem with xhci resume from suspend

Selvarasu Ganesan <selvarasu.g@samsung.com>
    usb: dwc3: core: Stop processing of pending events if controller is halted

Oliver Neukum <oneukum@suse.com>
    Revert "usb: yurex: Replace snprintf() with the safer scnprintf() variant"

Jason Gerecke <jason.gerecke@wacom.com>
    HID: wacom: Hardcode (non-inverted) AES pens as BTN_TOOL_PEN

Wade Wang <wade.wang@hp.com>
    HID: plantronics: Workaround for an unexcepted opposite volume key

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Switch to device-managed dmam_alloc_coherent()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: (ltc2991) Add missing dependency on REGMAP_I2C

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

He Lugang <helugang@uniontech.com>
    HID: multitouch: Add support for lenovo Y9000P Touchpad

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    x86/amd_nb: Add new PCI IDs for AMD family 1Ah model 60h

Frederic Weisbecker <frederic@kernel.org>
    rcu/nocb: Fix rcuog wake-up from offline softirq

Eric Dumazet <edumazet@google.com>
    slip: make slhc_remember() more robust against malicious packets

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix lacks of icsk_syn_mss with IPPROTO_SMC

Eric Dumazet <edumazet@google.com>
    ppp: fix ppp_async_encode() illegal access

Kuniyuki Iwashima <kuniyu@amazon.com>
    phonet: Handle error of rtnl_register_module().

Kuniyuki Iwashima <kuniyu@amazon.com>
    mpls: Handle error of rtnl_register_module().

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

Janne Grunau <j@jannau.net>
    drm/fbdev-dma: Only cleanup deferred I/O if necessary

Breno Leitao <leitao@debian.org>
    net: netconsole: fix wrong warning

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: refuse cross-chip mirroring operations

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: add dcr_unmap to _remove

Florian Westphal <fw@strlen.de>
    netfilter: fib: check correct rtable in vrf setups

Florian Westphal <fw@strlen.de>
    netfilter: xtables: avoid NFPROTO_UNSPEC where needed

Xin Long <lucien.xin@gmail.com>
    sctp: ensure sk_state is set to CLOSED if hashing fails in sctp_listen_start

Filipe Manana <fdmanana@suse.com>
    btrfs: zoned: fix missing RCU locking in error message when loading zone info

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix race condition for VLAN table access

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: fix wrong goto

Matt Roper <matthew.d.roper@intel.com>
    drm/xe: Make wedged_mode debugfs writable

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Restore GT freq on GSC load error

Eric Dumazet <edumazet@google.com>
    net/sched: accept TCA_STAB only for root qdisc

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: change I219 (19) devices to ADP

Mohamed Khalfella <mkhalfella@purestorage.com>
    igb: Do not bring the device up after non-fatal error

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: Fix macvlan leak by synchronizing access to mac_filter_hash

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix increasing MSI-X on VF

Wojciech Drewek <wojciech.drewek@intel.com>
    ice: Flush FDB entries before reset

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix netif_is_ice() in Safe Mode

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix entering Safe Mode

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl_tpmi: Ignore minor version change

Juergen Gross <jgross@suse.com>
    x86/xen: mark boot CPU of PV guest in MSR_IA32_APICBASE

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

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: fix possible badness in FREE_STATEID

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: phy: bcm84881: Fix some error handling paths

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Don't fail external suspend requests

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: FIX possible deadlock in rfcomm_sk_state_change

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Fix enabled status mismatch

Kacper Ludwinski <kac.ludwinski@icloud.com>
    selftests: net: no_forwarding: fix VID for $swp2 in one_bridge_two_pvids() test

Andy Roulin <aroulin@nvidia.com>
    netfilter: br_netfilter: fix panic with metadata_dst skb

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix reception from VLAN-unaware bridges

David Howells <dhowells@redhat.com>
    rxrpc: Fix uninitialised variable in rxrpc_send_data()

Neal Cardwell <ncardwell@google.com>
    tcp: fix TFO SYN_RECV to not zero retrans_stamp with retransmits out

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_enter_recovery() to zero retrans_stamp when it's safe

Neal Cardwell <ncardwell@google.com>
    tcp: fix to allow timestamp undo if no retransmits were sent

Abhishek Chauhan <quic_abchauha@quicinc.com>
    net: phy: aquantia: remove usage of phy_set_max_speed

Abhishek Chauhan <quic_abchauha@quicinc.com>
    net: phy: aquantia: AQR115c fix up PMA capabilities

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sfc: Don't invoke xdp_do_flush() from netpoll.

Ingo van Lil <inguin@gmx.de>
    net: phy: dp83869: fix memory corruption when enabling fiber

Yanjun Zhang <zhangyanjun@cestc.cn>
    NFSv4: Prevent NULL-pointer dereference in nfs42_complete_copies()

Dan Carpenter <dan.carpenter@linaro.org>
    SUNRPC: Fix integer overflow in decode_rc_list()

Dave Ertman <david.m.ertman@intel.com>
    ice: fix VLAN replay after reset

Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
    ice: disallow DPLL_PIN_STATE_SELECTABLE for dpll output pins

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: fix memleak in ice_init_tx_topology()

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: clear port vlan config during reset

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: set correct dst VSI in only LAN filters

NeilBrown <neilb@suse.de>
    nfsd: nfsd_destroy_serv() must call svc_destroy() even if nfsd_startup_net() failed

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Mark filecache "down" if init fails

Andrey Shumilin <shum.sdl@nppct.ru>
    fbdev: sisfb: Fix strbuf array overflow

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix UAF in async decryption

Qianqiang Liu <qianqiang.liu@163.com>
    fbcon: Fix a NULL pointer dereference issue in fbcon_putcs

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointer before dereferencing se

Christian König <christian.koenig@amd.com>
    drm/amdgpu: nuke the VM PD/PT shadow handling

José Roberto de Souza <jose.souza@intel.com>
    drm/xe/oa: Fix overflow in oa batch buffer

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to KERN_WARNING

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Ensure DA_ID handling completion before deleting an NPIV instance

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute

Zijun Hu <quic_zijuhu@quicinc.com>
    driver core: bus: Fix double free in driver API bus_register()

Ken Raeburn <raeburn@redhat.com>
    dm vdo: don't refer to dedupe_context after releasing it

Abhishek Tamboli <abhishektamboli9@gmail.com>
    usb: gadget: uvc: Fix ERR_PTR dereference in uvc_v4l2.c

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

Frank Li <Frank.Li@nxp.com>
    usb: host: xhci-plat: Parse xhci-missing_cas_quirk and apply quirk

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Fix STALL transfer event handling

Shawn Shao <shawn.shao@jaguarmicro.com>
    usb: dwc2: Adjust the timing of USB Driver Interrupt Registration in the Crashkernel Scenario

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: enable suspend interrupt after usb reset

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: Don't truncate the reads

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

Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
    soundwire: cadence: re-check Peripheral status with delayed_work

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: endpoint: Assign PCI domain number for endpoint controllers

Prudhvi Yarlagadda <quic_pyarlaga@quicinc.com>
    PCI: qcom: Disable mirroring of DBI and iATU register space in BAR region

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Enforce umem boundaries for explicit ODP page faults

Jisheng Zhang <jszhang@kernel.org>
    riscv: avoid Imbalance in RAS

Samuel Holland <samuel.holland@sifive.com>
    riscv: Omit optimized string routines when using KASAN

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mfd: intel-lpss: Add Intel Panther Lake LPSS PCI IDs

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    mfd: intel-lpss: Add Intel Arrow Lake-H LPSS PCI IDs

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

Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
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

Hou Tao <houtao1@huawei.com>
    bpf: Call the missed btf_record_free() when map creation fails

Andrey Skvortsov <andrej.skvortzov@gmail.com>
    zram: don't free statically defined names

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: free secondary algorithms names

Yang Jihong <yangjihong@bytedance.com>
    perf build: Fix build feature-dwarf_getlocations fail for old libdw

Yang Jihong <yangjihong@bytedance.com>
    perf build: Fix static compilation error when libdw is not installed

Diogo Jahchan Koike <djahchankoike@gmail.com>
    ntfs3: Change to non-blocking allocation in ntfs_d_hash

Ian Rogers <irogers@google.com>
    perf vdso: Missed put on 32-bit dsos

Michael S. Tsirkin <mst@redhat.com>
    virtio_console: fix misc probe bugs

Srujana Challa <schalla@marvell.com>
    vdpa/octeon_ep: Fix format specifier for pointers in debug messages

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Refactor enum_rstbl to suppress static checker

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix sparse warning in ni_fiemap

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix sparse warning for bigendian

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Optimize large writes into sparse file

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Do not call file_modified if collapse range failed

Wei Fang <wei.fang@nxp.com>
    net: fec: don't save PTP state if PTP is unsupported

Gabriel Krisman Bertazi <krisman@suse.de>
    unicode: Don't special case ignorable code points


-------------

Diffstat:

 Makefile                                           |    4 +-
 arch/loongarch/pci/acpi.c                          |    1 +
 arch/riscv/include/asm/sparsemem.h                 |    2 +-
 arch/riscv/include/asm/string.h                    |    2 +
 arch/riscv/kernel/elf_kexec.c                      |    6 +
 arch/riscv/kernel/entry.S                          |    4 +-
 arch/riscv/kernel/riscv_ksyms.c                    |    3 -
 arch/riscv/lib/Makefile                            |    2 +
 arch/riscv/lib/strcmp.S                            |    1 +
 arch/riscv/lib/strlen.S                            |    1 +
 arch/riscv/lib/strncmp.S                           |    1 +
 arch/riscv/purgatory/Makefile                      |    2 +
 arch/s390/boot/Makefile                            |   19 +-
 arch/s390/include/asm/facility.h                   |    6 +-
 arch/s390/include/asm/io.h                         |    2 +
 arch/s390/kernel/early.c                           |   17 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   12 +-
 arch/s390/mm/cmm.c                                 |   18 +-
 arch/x86/kernel/amd_nb.c                           |    3 +
 arch/x86/net/bpf_jit_comp.c                        |   54 +-
 arch/x86/xen/enlighten_pv.c                        |    4 +
 drivers/acpi/resource.c                            |   29 +-
 drivers/ata/libata-eh.c                            |   18 +-
 drivers/base/bus.c                                 |    8 +-
 drivers/base/power/common.c                        |   25 +-
 drivers/block/zram/zram_drv.c                      |    7 +
 drivers/bluetooth/btusb.c                          |   20 +-
 drivers/char/virtio_console.c                      |   18 +-
 drivers/clk/bcm/clk-bcm53573-ilp.c                 |    2 +-
 drivers/clk/imx/clk-imx7d.c                        |    4 +-
 .../drivers/ni_routing/tools/convert_c_to_py.c     |    5 +
 drivers/dax/device.c                               |    2 +-
 drivers/gpio/gpio-aspeed.c                         |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |    4 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   87 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   67 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h         |   21 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   17 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   56 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    7 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   47 +-
 drivers/gpu/drm/amd/pm/powerplay/inc/hwmgr.h       |   26 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    |    3 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          |   10 +-
 drivers/gpu/drm/nouveau/dispnv04/crtc.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    2 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   21 +-
 drivers/gpu/drm/nouveau/nouveau_chan.h             |    3 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    4 +-
 drivers/gpu/drm/v3d/v3d_perfmon.c                  |    9 +-
 drivers/gpu/drm/vc4/vc4_perfmon.c                  |    7 +-
 drivers/gpu/drm/xe/xe_bb.c                         |    3 +-
 drivers/gpu/drm/xe/xe_debugfs.c                    |    2 +-
 drivers/gpu/drm/xe/xe_gt.c                         |    4 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   44 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 |    9 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |   14 +-
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/hid-multitouch.c                       |    8 +-
 drivers/hid/hid-plantronics.c                      |   23 +
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c        |    2 +-
 drivers/hid/wacom_wac.c                            |    2 +
 drivers/hwmon/Kconfig                              |    5 +
 drivers/hwmon/intel-m10-bmc-hwmon.c                |    2 +-
 drivers/hwmon/k10temp.c                            |    1 +
 drivers/i2c/busses/i2c-i801.c                      |    9 +-
 drivers/i3c/master/i3c-master-cdns.c               |    1 +
 drivers/infiniband/core/mad.c                      |   14 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   25 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   13 +-
 drivers/md/dm-vdo/dedupe.c                         |    3 +
 drivers/media/common/videobuf2/videobuf2-core.c    |    8 +-
 drivers/mfd/intel-lpss-pci.c                       |   39 +
 drivers/mfd/intel_soc_pmic_chtwc.c                 |    1 -
 drivers/mmc/host/mvsdio.c                          |   71 +-
 drivers/mmc/host/sdhci-of-dwcmshc.c                |    8 +
 drivers/net/dsa/b53/b53_common.c                   |   17 +-
 drivers/net/dsa/lan9303-core.c                     |   29 +
 drivers/net/dsa/sja1105/sja1105_main.c             |    1 -
 drivers/net/ethernet/adi/adin1110.c                |    4 +-
 drivers/net/ethernet/freescale/fec_main.c          |    6 +-
 drivers/net/ethernet/ibm/emac/mal.c                |    4 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |    4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +
 drivers/net/ethernet/intel/ice/ice_ddp.c           |   58 +-
 drivers/net/ethernet/intel/ice/ice_ddp.h           |    4 +-
 drivers/net/ethernet/intel/ice/ice_dpll.c          |    6 +-
 drivers/net/ethernet/intel/ice/ice_eswitch_br.c    |    5 +-
 drivers/net/ethernet/intel/ice/ice_eswitch_br.h    |    1 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   39 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   19 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |    2 -
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   11 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |    9 +-
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |    1 -
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c  |   57 +
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h  |    1 +
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |    9 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    4 +
 drivers/net/ethernet/sfc/efx_channels.c            |    3 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c      |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    2 +-
 drivers/net/ethernet/ti/icssg/icssg_config.c       |    2 +
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |    1 +
 drivers/net/ethernet/ti/icssg/icssg_prueth.h       |    2 +
 drivers/net/netconsole.c                           |    8 +-
 drivers/net/phy/aquantia/aquantia_main.c           |   51 +-
 drivers/net/phy/bcm84881.c                         |    4 +-
 drivers/net/phy/dp83869.c                          |    1 -
 drivers/net/phy/phy_device.c                       |    5 +-
 drivers/net/phy/realtek.c                          |   24 +-
 drivers/net/ppp/ppp_async.c                        |    2 +-
 drivers/net/pse-pd/pse_core.c                      |   11 +
 drivers/net/slip/slhc.c                            |   57 +-
 drivers/net/vxlan/vxlan_core.c                     |    6 +-
 drivers/net/vxlan/vxlan_private.h                  |    2 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |   19 +-
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c             |    1 +
 drivers/nvdimm/nd_virtio.c                         |    9 +
 drivers/opp/core.c                                 |    4 +-
 drivers/pci/controller/dwc/pcie-designware.c       |    2 +
 drivers/pci/controller/dwc/pcie-designware.h       |    2 +
 drivers/pci/controller/dwc/pcie-qcom.c             |   72 +-
 drivers/pci/endpoint/pci-epc-core.c                |   14 +
 drivers/pci/pci.c                                  |   14 +-
 drivers/pci/probe.c                                |    2 +-
 drivers/pci/quirks.c                               |    8 +
 drivers/pci/remove.c                               |    2 +-
 drivers/powercap/intel_rapl_tpmi.c                 |   19 +-
 drivers/remoteproc/imx_rproc.c                     |   13 +-
 drivers/scsi/fnic/fnic_main.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   22 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |    7 +
 drivers/scsi/lpfc/lpfc_els.c                       |  132 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   43 +-
 drivers/scsi/wd33c93.c                             |    2 +-
 drivers/soundwire/cadence_master.c                 |   39 +-
 drivers/soundwire/cadence_master.h                 |    5 +
 drivers/soundwire/intel.h                          |    2 +
 drivers/soundwire/intel_auxdevice.c                |    1 +
 drivers/soundwire/intel_bus_common.c               |   35 +-
 drivers/staging/vme_user/vme_fake.c                |    6 +
 drivers/staging/vme_user/vme_tsi148.c              |    6 +
 .../int340x_thermal/processor_thermal_device_pci.c |    2 -
 drivers/thermal/thermal_core.c                     |    5 +-
 drivers/thermal/thermal_core.h                     |    3 +
 drivers/thermal/thermal_netlink.c                  |    9 +-
 drivers/tty/serial/serial_core.c                   |   16 +-
 drivers/ufs/core/ufshcd.c                          |    5 +-
 drivers/usb/chipidea/udc.c                         |    8 +-
 drivers/usb/dwc2/platform.c                        |   26 +-
 drivers/usb/dwc3/core.c                            |   30 +-
 drivers/usb/dwc3/core.h                            |    4 -
 drivers/usb/dwc3/gadget.c                          |   11 -
 drivers/usb/gadget/function/uvc_v4l2.c             |   12 +-
 drivers/usb/gadget/udc/core.c                      |    1 +
 drivers/usb/host/xhci-dbgcap.c                     |  133 +-
 drivers/usb/host/xhci-dbgcap.h                     |    2 +-
 drivers/usb/host/xhci-pci.c                        |    5 +
 drivers/usb/host/xhci-plat.c                       |    6 +
 drivers/usb/misc/yurex.c                           |   19 +-
 drivers/usb/storage/unusual_devs.h                 |   11 +
 drivers/usb/typec/tipd/core.c                      |    3 +-
 drivers/usb/typec/ucsi/ucsi.c                      |    8 +-
 drivers/usb/typec/ucsi/ucsi.h                      |    2 +
 drivers/vdpa/octeon_ep/octep_vdpa_hw.c             |   12 +-
 drivers/video/fbdev/core/fbcon.c                   |    2 +
 drivers/video/fbdev/sis/sis_main.c                 |    2 +-
 fs/btrfs/extent-tree.c                             |   26 +-
 fs/btrfs/free-space-cache.c                        |    4 +-
 fs/btrfs/free-space-cache.h                        |    6 +
 fs/btrfs/volumes.h                                 |    6 +
 fs/btrfs/zoned.c                                   |    2 +-
 fs/ext4/super.c                                    |    9 +-
 fs/ext4/xattr.c                                    |    4 +-
 fs/nfs/callback_xdr.c                              |    2 +
 fs/nfs/client.c                                    |    1 +
 fs/nfs/nfs42proc.c                                 |    2 +-
 fs/nfs/nfs4state.c                                 |    2 +-
 fs/nfsd/filecache.c                                |    4 +-
 fs/nfsd/nfs4state.c                                |    1 +
 fs/nfsd/nfssvc.c                                   |    6 +-
 fs/ntfs3/file.c                                    |   40 +-
 fs/ntfs3/frecord.c                                 |   21 +-
 fs/ntfs3/fslog.c                                   |   19 +-
 fs/ntfs3/namei.c                                   |    4 +-
 fs/ntfs3/super.c                                   |    3 +-
 fs/proc/kcore.c                                    |   36 +-
 fs/smb/client/smb2ops.c                            |   47 +-
 fs/smb/client/smb2pdu.c                            |    6 +
 fs/unicode/mkutf8data.c                            |   70 -
 fs/unicode/utf8data.c_shipped                      | 6703 ++++++++++----------
 include/linux/bpf.h                                |    1 +
 include/linux/nfs_fs_sb.h                          |    1 +
 include/linux/pci-epc.h                            |    2 +
 include/linux/pci.h                                |    2 +-
 include/linux/pci_ids.h                            |    3 +
 include/net/mctp.h                                 |    2 +-
 include/net/rtnetlink.h                            |   17 +
 include/net/sch_generic.h                          |    1 -
 include/net/sock.h                                 |    2 +
 io_uring/io_uring.c                                |   15 +
 io_uring/rw.c                                      |   19 +-
 kernel/bpf/arraymap.c                              |    3 +
 kernel/bpf/core.c                                  |   21 +-
 kernel/bpf/hashtab.c                               |    3 +
 kernel/bpf/syscall.c                               |   19 +-
 kernel/kthread.c                                   |    2 +
 kernel/rcu/tree_nocb.h                             |    8 +-
 mm/secretmem.c                                     |    4 +-
 net/bluetooth/hci_conn.c                           |    3 +
 net/bluetooth/rfcomm/sock.c                        |    2 -
 net/bridge/br_netfilter_hooks.c                    |    5 +
 net/bridge/br_netlink.c                            |    6 +-
 net/bridge/br_private.h                            |    5 +-
 net/bridge/br_vlan.c                               |   19 +-
 net/core/dst.c                                     |   17 +-
 net/core/rtnetlink.c                               |   29 +
 net/dsa/user.c                                     |   11 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   10 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |    4 +-
 net/ipv4/tcp_input.c                               |   42 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |    5 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |    5 +-
 net/mctp/af_mctp.c                                 |    6 +-
 net/mctp/device.c                                  |   32 +-
 net/mctp/neigh.c                                   |   29 +-
 net/mctp/route.c                                   |   33 +-
 net/mpls/af_mpls.c                                 |   32 +-
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
 net/netlink/af_netlink.c                           |    3 +-
 net/phonet/pn_netlink.c                            |   28 +-
 net/rxrpc/sendmsg.c                                |   10 +-
 net/sched/sch_api.c                                |    7 +-
 net/sctp/socket.c                                  |   18 +-
 net/smc/smc_inet.c                                 |   11 +
 net/socket.c                                       |    7 +-
 sound/pci/hda/hda_intel.c                          |    2 +-
 tools/build/feature/Makefile                       |    5 +-
 tools/iio/iio_generic_buffer.c                     |    4 +
 tools/perf/Makefile.config                         |    7 +-
 tools/perf/util/vdso.c                             |    4 +-
 tools/testing/ktest/ktest.pl                       |    2 +-
 .../testing/selftests/bpf/progs/verifier_int_ptr.c |    5 +-
 tools/testing/selftests/mm/hmm-tests.c             |    2 +-
 .../selftests/net/forwarding/no_forwarding.sh      |    2 +-
 tools/testing/selftests/rseq/rseq.c                |  110 +-
 tools/testing/selftests/rseq/rseq.h                |   10 +-
 276 files changed, 5984 insertions(+), 4832 deletions(-)


