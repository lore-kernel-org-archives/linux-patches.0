Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417B25A633;
	Tue,  2 Dec 2025 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764689395; cv=none; b=Bf2mk3Ep2123cd75qhkxcXQRxOw7Qy1VfYUrs3Ss+QBkG4QlzAR+ZK8ixPPOzzOC/eDrV6f35EINvFpdtaT+xg1utlhpwRhyKfU6NSxFEZ0SXKp0aMTibe++Bx1O3JACoMed7adENMm9Br/jHrF5ugWXHuOgCqs+/XQBUXzrptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764689395; c=relaxed/simple;
	bh=qiW6hb7XA6CgvkE7qytiD2SONTDf0iTBnUdVXJJTli4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SO8iErlos7V7erh0Kj93Sd/Q6zlnEe9IRhAGh0Mz6EXsIkpljGZ1cn+fmwgR1oXOqHdlXNgubf4IYX0tUA0nc7z4cnBAtVhXEuSjn0W0WdkkYol325aWHrnZzIjwJ7gN1Bv53ci3Y+2+X7MTg8wuBAuqHAie5ulclMf4BUF9pDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJx12ijg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJx12ijg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E3CC4CEF1;
	Tue,  2 Dec 2025 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764689395;
	bh=qiW6hb7XA6CgvkE7qytiD2SONTDf0iTBnUdVXJJTli4=;
	h=From:To:Cc:Subject:Date:From;
	b=TJx12ijg5JpktQnq2rvfQV7/UJ2HTe7VvCgzyCFnsKDuG0KuoTH5Nps3UqO1j4j6a
	 5sM+vGkVI1Z3i8ILsPHsZ21Fli0Pn+L3ApqeUg/mQqbEvk2DA1ME3MQMG2Wt+NjYFz
	 DbgOrH6K5ZBwSTUV8/h3Y8ylBI7cNWHWDBECz/So=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 5.4 000/182] 5.4.302-rc3 review
Date: Tue,  2 Dec 2025 16:29:50 +0100
Message-ID: <20251202152903.637577865@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.302-rc3
X-KernelTest-Deadline: 2025-12-04T15:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.302 release.
There are 182 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Dec 2025 15:28:35 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.302-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.302-rc3

Seungjin Bae <eeodqql09@gmail.com>
    Input: pegasus-notetaker - fix potential out-of-bounds access

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    Input: remove third argument of usb_maxpacket()

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    usb: deprecate the third argument of usb_maxpacket()

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: Fix system suspend for a security locked drive

Wei Yang <albinwyang@tencent.com>
    fs/proc: fix uaf in proc_readdir_de()

Miaoqian Lin <linmq006@gmail.com>
    pmdomain: imx: Fix reference count leak in imx_gpc_remove

Sudeep Holla <sudeep.holla@arm.com>
    pmdomain: arm: scmi: Fix genpd leak on provider registration failure

Breno Leitao <leitao@debian.org>
    net: netpoll: fix incorrect refcount handling causing incorrect cleanup

Nathan Chancellor <nathan@kernel.org>
    net: qede: Initialize qede_ll_ops with designated initializer

Long Li <longli@microsoft.com>
    uio_hv_generic: Set event for all channels on the device

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error

René Rebe <rene@exactco.de>
    ALSA: usb-audio: fix uac2 clock source at terminal parser

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm/page_alloc: fix hash table order logging in alloc_large_system_hash()

Jakub Horký <jakub.git@horky.net>
    kconfig/nconf: Initialize the default locale at startup

Jakub Horký <jakub.git@horky.net>
    kconfig/mconf: Initialize the default locale at startup

Michal Luczaj <mhal@rbox.co>
    vsock: Ignore signal/timeout on connect() if already established

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/ctcm: Fix double-kfree

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove never-working support for setting nsh fields

Zilin Guan <zilin@seu.edu.cn>
    mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix !EVA SOC-it PCI MMIO

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Do not sleep in atomic context

Tzung-Bi Shih <tzungbi@kernel.org>
    Input: cros_ec_keyb - fix an invalid memory access

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: pass wrb_params in case of OS2BMC

Zhang Heng <zhangheng@kylinos.cn>
    HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Handle OCRAM ECC enable after warm reset

Hans de Goede <hansg@kernel.org>
    spi: Try to get ACPI GPIO IRQ earlier

Chuang Wang <nashuiliang@gmail.com>
    ipv4: route: Prevent rt_bind_exception() from rebinding stale fnhe

Nate Karstens <nate.karstens@garmin.com>
    strparser: Fix signed/unsigned mismatch bug

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 15

Jakub Acs <acsjakub@amazon.de>
    mm/ksm: fix flag-dropping behavior in ksm_madvise

Haein Lee <lhi0729@kaist.ac.kr>
    ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: cs4271: Fix regulator leak on probe failure

Haotian Zhang <vulab@iscas.ac.cn>
    regulator: fixed: fix GPIO descriptor leak on register failure

Chris Morgan <macromorgan@hotmail.com>
    regulator: fixed: use dev_err_probe for register

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: export l2cap_chan_hold for modules

Eric Dumazet <edumazet@google.com>
    net_sched: limit try_bulk_dequeue_skb() batches

Eric Dumazet <edumazet@google.com>
    net_sched: remove need_resched() from qdisc_run()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix maxrate wraparound in threshold between units

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: skip rate verification for not captured PSDUs

Buday Csaba <buday.csaba@prolan.hu>
    net: mdio: fix resource leak in mdiobus_register_device()

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_mon_reinit_self().

Xin Long <lucien.xin@gmail.com>
    tipc: simplify the finalize work queue

Eric Dumazet <edumazet@google.com>
    sctp: prevent possible shift-out-of-bounds in sctp_transport_update_rto

Xin Long <lucien.xin@gmail.com>
    sctp: get netns from asoc and ep base

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: Don't hold spin lock over sleeping functions

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: fix BDADDR_LE vs ADDR_LE_DEV address type confusion

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: reset link-local header on ipv6 recv path

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF

Wei Fang <wei.fang@nxp.com>
    net: fec: correct rx_bytes statistic for the case SHIFT16 is set

Sharique Mohammad <sharq0406@gmail.com>
    ASoC: max98090/91: fixed max98091 ALSA widget powering up/down

Tristan Lobb <tristan.lobb@it-lobb.de>
    HID: quirks: avoid Cooler Master MM712 dongle wakeup bug

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Fix state renewals missing after boot

Peter Zijlstra <peterz@infradead.org>
    compiler_types: Move unused static inline functions warning to W=2

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Cleanup wakeup source only if it was enabled

Zilin Guan <zilin@seu.edu.cn>
    tracing: Fix memory leaks in create_field_var()

Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
    net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Prevent TOCTOU out-of-bounds write

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold RCU read lock while iterating over address list

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: stop reading ARL entries if search is done

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix enabling ip multicast

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix resetting speed and pause on forced link

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325

Russell King <rmk+kernel@armlinux.org.uk>
    net: dsa/b53: change b53_force_port_config() pause argument

Hangbin Liu <liuhangbin@gmail.com>
    net: vlan: sync VLAN features with lower device

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: add checking of wait_for_completion_killable() return value

Albin Babu Varghese <albinbabuvarghese20@gmail.com>
    fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Return present device nodes only on fwnode interface

Randall P. Embry <rpembry@gmail.com>
    9p: sysfs_init: don't hardcode error to ENOMEM

Randall P. Embry <rpembry@gmail.com>
    9p: fix /sys/fs/9p/caches overwriting itself

Yikang Yue <yikangy2@illinois.edu>
    fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink

Saket Dumbre <saket.dumbre@intel.com>
    ACPICA: Update dsmethod.c to get rid of unused variable warning

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix xattr related buffer overflow...

Dragos Tatulea <dtatulea@nvidia.com>
    page_pool: Clamp pool size to max 16K pages

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: bcsp: receive data only if registered

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_conn_free

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: avoid dealing with endianness in macb_set_hwaddr()

Al Viro <viro@zeniv.linux.org.uk>
    nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing

Anthony Iliopoulos <ailiop@suse.com>
    NFSv4.1: fix mount hang after CREATE_SESSION failure

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4: handle ERR_GRACE on delegation recalls

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid handling handover twice

Koakuma <koachan@protonmail.com>
    sparc/module: Add R_SPARC_UA64 relocation handling

Brahmajit Das <listout@listout.xyz>
    net: intel: fm10k: Fix parameter idx set but not used

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    jfs: fix uninitialized waitqueue in transaction manager

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jfs: Verify inode mode when loading from disk

Eric Dumazet <edumazet@google.com>
    ipv6: np->rxpmtu race annotation

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: xhci: plat: Facilitate using autosuspend for xhci plat devices

Forest Crossman <cyrozap@gmail.com>
    usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs

Al Viro <viro@zeniv.linux.org.uk>
    allow finish_no_open(file, ERR_PTR(-E...))

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Define size of debugfs entry for xri rebalancing

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET

Nai-Chen Cheng <bleach1827@gmail.com>
    selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency

Yafang Shao <laoar.shao@gmail.com>
    net/cls_cgroup: Fix task_get_classid() during qdisc run

David Ahern <dsahern@kernel.org>
    selftests: Replace sleep with slowwait

David Ahern <dsahern@kernel.org>
    selftests: Disable dad for ipv6 in fcnal-test.sh

Qianfeng Rong <rongqianfeng@vivo.com>
    media: redrat3: use int type to store negative error codes

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: sh_eth: Disable WoL if system can not suspend

Harikrishna Shenoy <h-shenoy@ti.com>
    phy: cadence: cdns-dphy: Enable lower resolutions in dphy

William Wu <william.wu@rock-chips.com>
    usb: gadget: f_hid: Fix zero length packet transfer

Eric Dumazet <edumazet@google.com>
    net: call cond_resched() less often in __release_sock()

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: apply quirk for MOONDROP Quark2

Juraj Šarinay <juraj@sarinay.com>
    net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms

Devendra K Verma <devverma@amd.com>
    dmaengine: dw-edma: Set status for callback_result

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: match alloc_wc and free_wc

Thomas Andreatta <thomasandreatta2000@gmail.com>
    dmaengine: sh: setup_xref error handling

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: pm8001: Use int instead of u32 to store error codes

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: xway: sysctrl: rename stp clock

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing device_type in pci node

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing properties to cpu node

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    media: fix uninitialized symbol warnings

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Fix wakeup source leaks on device unbind

Ujwal Kundur <ujwal.kundur@gmail.com>
    rds: Fix endianness annotation for RDS_MPATH_HASH

Sungho Kim <sungho.kim@furiosa.ai>
    PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call

Kuniyuki Iwashima <kuniyu@google.com>
    net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.

Christoph Paasch <cpaasch@openai.com>
    net: When removing nexthops, don't call synchronize_net if it is not necessary

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Does not request module for miscdevice with dynamic minor

raub camaioni <raubcameo@gmail.com>
    usb: gadget: f_ncm: Fix MAC assignment NCM ethernet

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: make send_packet() more robust

Charalampos Mitrodimas <charmitro@posteo.net>
    net: ipv6: fix field-spanning memcpy warning in AH output

Ido Schimmel <idosch@nvidia.com>
    bridge: Redirect to backup port when port is administratively down

Niklas Schnelle <schnelle@linux.ibm.com>
    powerpc/eeh: Use result of error_detected() in uevent

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: pci: ivtv: Don't create fake v4l2_fh

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amdkfd: return -ENOTTY for unsupported IOCTLs

Wake Liu <wakel@google.com>
    selftests/net: Ensure assert() triggers in psock_tpacket.c

Wake Liu <wakel@google.com>
    selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8

Marcos Del Sol Vives <marcos@orca.pet>
    PCI: Disable MSI on RDC PCI to PCIe bridges

Seyediman Seyedarab <imandevel@gmail.com>
    drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()

Arnd Bergmann <arnd@arndb.de>
    mfd: madera: Work around false-positive -Wininitialized warning

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe-i2c: Add missing MODULE_LICENSE

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe: Remove IRQ domain upon removal

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Prefer driver HWP limits

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Enhance HWP enable

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: Fix incorrect size in cpuidle_state_disable()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add support for Dell OptiPlex 7040

Jiri Olsa <jolsa@kernel.org>
    uprobe: Do not emulate/sstep original instruction when ip is changed

Daniel Lezcano <daniel.lezcano@linaro.org>
    clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel

Svyatoslav Ryhel <clamor95@gmail.com>
    video: backlight: lp855x_bl: Set correct EPROM start for LP8556

Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
    tee: allow a driver to allocate a tee_device without a pool

Hans de Goede <hansg@kernel.org>
    ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card

Christian Bruel <christian.bruel@foss.st.com>
    irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment

Kees Cook <kees@kernel.org>
    arc: Fix __fls() const-foldability via __builtin_clzl()

Dennis Beier <nanovim@gmail.com>
    cpufreq/longhaul: handle NULL policy in longhaul_exit

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2

Mario Limonciello (AMD) <superm1@kernel.org>
    ACPI: video: force native for Lenovo 82K8

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Add timeout to prevent indefinite waiting

Biju Das <biju.das.jz@bp.renesas.com>
    mmc: host: renesas_sdhi: Fix the actual clock

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf: Don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    spi: loopback-test: Don't use %pK through printk

Jens Reidel <adrian@mainlining.org>
    soc: qcom: smem: Fix endian-unaware access of num_entries

Owen Gu <guhuinan@xiaomi.com>
    usb: gadget: f_fs: Fix epfile null pointer access after ep enable.

Artem Shimko <a.shimko.dev@gmail.com>
    serial: 8250_dw: handle reset control deassert error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Use devm_add_action_or_reset()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Use devm_clk_get_optional() to get the input clock

Celeste Liu <uwu@coelacanthus.name>
    can: gs_usb: increase max interface to U8_MAX

Maarten Lankhorst <dev@lankhorst.se>
    devcoredump: Fix circular locking dependency with devcd->mutex.

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    net: ravb: Enforce descriptor type ordering

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix crash while sending Action Frames in standalone AP Mode

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    net: phy: dp83867: Disable EEE support as not implemented

Alexey Klimov <alexey.klimov@linaro.org>
    regmap: slimbus: fix bus_context pointer in regmap init calls

Tomeu Vizoso <tomeu@tomeuvizoso.net>
    drm/etnaviv: fix flush sequence logic

Lizhi Xu <lizhi.xu@windriver.com>
    usbnet: Prevents free active kevent

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix memory leak on unsupported WMI command

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qdsp6: q6asm: do not sleep while atomic

Miaoqian Lin <linmq006@gmail.com>
    fbdev: valkyriefb: Fix reference count leak in valkyriefb_init

Florian Fuchs <fuchsfl@gmail.com>
    fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS

Junjie Cao <junjie.cao@intel.com>
    fbdev: bitblit: bound-check glyph index in bit_putcs*

Yuhao Jiang <danisjiang@gmail.com>
    ACPI: video: Fix use-after-free in acpi_video_switch_brightness()

Daniel Palmer <daniel@0x0f.com>
    fbdev: atyfb: Check if pll_ops->init_pll failed

Miaoqian Lin <linmq006@gmail.com>
    net: usb: asix_devices: Check return value of usbnet_get_endpoints

Filipe Manana <fdmanana@suse.com>
    btrfs: use smp_mb__after_atomic() when forcing COW in create_pending_snapshot()

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Fix reporting of LFENCE retpoline

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix null-deref in agg_dequeue


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/bitops.h                      |   2 +
 arch/mips/boot/dts/lantiq/danube.dtsi              |   6 +
 arch/mips/lantiq/xway/sysctrl.c                    |   2 +-
 arch/mips/mti-malta/malta-init.c                   |  20 +--
 arch/powerpc/kernel/eeh_driver.c                   |   2 +-
 arch/sparc/include/asm/elf_64.h                    |   1 +
 arch/sparc/kernel/module.c                         |   1 +
 arch/x86/entry/vsyscall/vsyscall_64.c              |  17 ++-
 arch/x86/kernel/cpu/bugs.c                         |   5 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |  10 +-
 drivers/acpi/acpi_video.c                          |   4 +-
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/property.c                            |  24 +++-
 drivers/acpi/video_detect.c                        |   8 ++
 drivers/ata/libata-scsi.c                          |   8 ++
 drivers/base/devcoredump.c                         | 138 +++++++++++++--------
 drivers/base/regmap/regmap-slimbus.c               |   6 +-
 drivers/bluetooth/btusb.c                          |  13 +-
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/char/misc.c                                |   8 +-
 drivers/clocksource/timer-vf-pit.c                 |  22 ++--
 drivers/cpufreq/longhaul.c                         |   3 +
 drivers/dma/dw-edma/dw-edma-core.c                 |  22 ++++
 drivers/dma/mv_xor.c                               |   4 +-
 drivers/dma/sh/shdma-base.c                        |  25 +++-
 drivers/dma/sh/shdmac.c                            |  17 ++-
 drivers/edac/altera_edac.c                         |  22 +++-
 drivers/extcon/extcon-adc-jack.c                   |   2 +
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |  13 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   9 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   2 +-
 drivers/gpu/drm/nouveau/nvkm/core/enum.c           |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   5 +
 drivers/hid/hid-ids.h                              |   7 +-
 drivers/hid/hid-quirks.c                           |  14 ++-
 drivers/hwmon/dell-smm-hwmon.c                     |   7 ++
 drivers/iio/adc/spear_adc.c                        |   9 +-
 drivers/input/keyboard/cros_ec_keyb.c              |   6 +
 drivers/input/misc/ati_remote2.c                   |   2 +-
 drivers/input/misc/cm109.c                         |   2 +-
 drivers/input/misc/powermate.c                     |   2 +-
 drivers/input/misc/yealink.c                       |   2 +-
 drivers/input/tablet/acecad.c                      |   2 +-
 drivers/input/tablet/pegasus_notetaker.c           |  11 +-
 drivers/irqchip/irq-gic-v2m.c                      |  13 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  18 ++-
 drivers/media/i2c/ir-kbd-i2c.c                     |   6 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   2 -
 drivers/media/pci/ivtv/ivtv-driver.h               |   3 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |  18 +--
 drivers/media/pci/ivtv/ivtv-irq.c                  |   4 +-
 drivers/media/rc/imon.c                            |  61 +++++----
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/tuners/xc4000.c                      |   8 +-
 drivers/media/tuners/xc5000.c                      |  12 +-
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/mfd/madera-core.c                          |   4 +-
 drivers/mfd/stmpe-i2c.c                            |   1 +
 drivers/mfd/stmpe.c                                |   3 +
 drivers/mmc/host/renesas_sdhi_core.c               |   6 +-
 drivers/mmc/host/sdhci-msm.c                       |  15 +++
 drivers/net/can/usb/gs_usb.c                       |  23 ++--
 drivers/net/dsa/b53/b53_common.c                   |  57 ++++++---
 drivers/net/dsa/b53/b53_regs.h                     |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   7 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +
 drivers/net/ethernet/intel/fm10k/fm10k_common.c    |   5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.h    |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  15 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   6 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   2 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  16 ++-
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/ethernet/ti/netcp_core.c               |  10 +-
 drivers/net/phy/dp83867.c                          |   6 +
 drivers/net/phy/mdio_bus.c                         |   5 +-
 drivers/net/usb/asix_devices.c                     |  12 +-
 drivers/net/usb/qmi_wwan.c                         |   6 +
 drivers/net/usb/usbnet.c                           |   2 +
 drivers/net/wireless/ath/ath10k/wmi.c              |   1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  21 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   3 +-
 drivers/pci/p2pdma.c                               |   2 +-
 drivers/pci/quirks.c                               |   1 +
 drivers/phy/cadence/cdns-dphy.c                    |   4 +-
 drivers/regulator/fixed.c                          |   6 +-
 drivers/remoteproc/qcom_q6v5.c                     |   5 +
 drivers/s390/net/ctcm_mpc.c                        |   1 -
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   3 +
 drivers/scsi/lpfc/lpfc_scsi.c                      |  14 ++-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   2 +-
 drivers/scsi/sg.c                                  |  10 +-
 drivers/soc/imx/gpc.c                              |   2 +
 drivers/soc/qcom/smem.c                            |   2 +-
 drivers/soc/ti/knav_dma.c                          |  14 +--
 drivers/spi/spi-loopback-test.c                    |  12 +-
 drivers/spi/spi.c                                  |  10 ++
 drivers/target/loopback/tcm_loop.c                 |   3 +
 drivers/tee/tee_core.c                             |   2 +-
 drivers/tty/serial/8250/8250_dw.c                  | 128 +++++++++----------
 drivers/uio/uio_hv_generic.c                       |  21 +++-
 drivers/usb/gadget/function/f_fs.c                 |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   4 +-
 drivers/usb/gadget/function/f_ncm.c                |   3 +-
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/mon/mon_bin.c                          |  14 ++-
 drivers/video/backlight/lp855x_bl.c                |   2 +-
 drivers/video/fbdev/aty/atyfb_base.c               |   8 +-
 drivers/video/fbdev/core/bitblit.c                 |  33 ++++-
 drivers/video/fbdev/pvr2fb.c                       |   2 +-
 drivers/video/fbdev/valkyriefb.c                   |   2 +
 fs/9p/v9fs.c                                       |   9 +-
 fs/btrfs/transaction.c                             |   2 +-
 fs/ceph/locks.c                                    |   5 +-
 fs/hpfs/namei.c                                    |  18 ++-
 fs/jfs/inode.c                                     |   8 +-
 fs/jfs/jfs_txnmgr.c                                |   9 +-
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfs/nfs4state.c                                 |   3 +
 fs/open.c                                          |  10 +-
 fs/orangefs/xattr.c                                |  12 +-
 fs/proc/generic.c                                  |  12 +-
 include/linux/ata.h                                |   1 +
 include/linux/compiler_types.h                     |   5 +-
 include/linux/filter.h                             |   2 +-
 include/linux/mm.h                                 |   2 +-
 include/linux/shdma-base.h                         |   2 +-
 include/linux/usb.h                                |  16 +--
 include/net/cls_cgroup.h                           |   2 +-
 include/net/nfc/nci_core.h                         |   2 +-
 include/net/pkt_sched.h                            |  25 +++-
 kernel/events/uprobes.c                            |   7 ++
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/trace/trace_events_hist.c                   |   6 +-
 mm/page_alloc.c                                    |   2 +-
 net/8021q/vlan.c                                   |   2 +
 net/bluetooth/6lowpan.c                            | 103 ++++++++++-----
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bluetooth/sco.c                                |   7 ++
 net/bridge/br_forward.c                            |   3 +-
 net/core/netpoll.c                                 |   7 +-
 net/core/page_pool.c                               |   6 +-
 net/core/sock.c                                    |  15 ++-
 net/ipv4/nexthop.c                                 |   6 +
 net/ipv4/route.c                                   |   5 +
 net/ipv6/ah6.c                                     |  50 +++++---
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/rx.c                                  |  10 +-
 net/openvswitch/actions.c                          |  68 +---------
 net/openvswitch/flow_netlink.c                     |  64 ++--------
 net/openvswitch/flow_netlink.h                     |   2 -
 net/rds/rds.h                                      |   2 +-
 net/sched/act_ife.c                                |  12 +-
 net/sched/sch_api.c                                |  10 --
 net/sched/sch_generic.c                            |  24 ++--
 net/sched/sch_hfsc.c                               |  16 ---
 net/sched/sch_qfq.c                                |   2 +-
 net/sctp/associola.c                               |  10 +-
 net/sctp/chunk.c                                   |   2 +-
 net/sctp/diag.c                                    |   7 ++
 net/sctp/endpointola.c                             |   6 +-
 net/sctp/input.c                                   |   5 +-
 net/sctp/output.c                                  |   2 +-
 net/sctp/outqueue.c                                |   6 +-
 net/sctp/sm_make_chunk.c                           |   7 +-
 net/sctp/sm_sideeffect.c                           |  16 +--
 net/sctp/sm_statefuns.c                            |   2 +-
 net/sctp/socket.c                                  |  12 +-
 net/sctp/stream.c                                  |   3 +-
 net/sctp/stream_interleave.c                       |  23 ++--
 net/sctp/transport.c                               |  15 ++-
 net/sctp/ulpqueue.c                                |  15 ++-
 net/strparser/strparser.c                          |   2 +-
 net/tipc/core.c                                    |   4 +-
 net/tipc/core.h                                    |   8 +-
 net/tipc/discover.c                                |   4 +-
 net/tipc/link.c                                    |   5 +
 net/tipc/link.h                                    |   1 +
 net/tipc/net.c                                     |  17 +--
 net/vmw_vsock/af_vsock.c                           |  40 ++++--
 scripts/kconfig/mconf.c                            |   3 +
 scripts/kconfig/nconf.c                            |   3 +
 sound/soc/codecs/cs4271.c                          |  10 +-
 sound/soc/codecs/max98090.c                        |   6 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |   2 +-
 sound/usb/mixer.c                                  |  11 +-
 tools/power/cpupower/lib/cpuidle.c                 |   5 +-
 .../x86_energy_perf_policy.c                       |  26 ++--
 tools/testing/selftests/Makefile                   |   2 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |   4 +-
 tools/testing/selftests/net/psock_tpacket.c        |   4 +-
 200 files changed, 1298 insertions(+), 817 deletions(-)


