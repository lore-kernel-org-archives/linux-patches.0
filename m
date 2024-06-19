Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5316C4D9EA;
	Wed, 19 Jun 2024 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803598; cv=none; b=Hgy6jNutqUjkjsQhKzTwCYT8ui17Lo9Wi/+vnk25Y4gPdcQKrk2/G/l73edqPbufyRb3wVA6RkXjIKHHpOIqPPN1UnDv6U58PSdwYBCoY5Ej/gcUIhT8J5xv19BLhpSJMqsf8l9UkggwvEsVFRoGxsT2mT9rSgzPJ/1EMyjyVxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803598; c=relaxed/simple;
	bh=8AchACpwlGef3fZzdHE6mlKP0d8JsVxYADThM1xxC2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iFh1lE3vQYkaM52qKyXXGLg+nb3KSvFs6tZn1361FxLfLS42OJjJZdwiPnST5vMSymdi2lTuopsmYfT6CwZRz5U6QaSUUuBQs9zR/6Yo5HUPNJ5ZVG7eoH67BlA55RYTZ5LbcOG3bWC5CuxkBeFIuBo8711cFIJOg/xyWPmAy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPYciyuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPYciyuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65103C2BBFC;
	Wed, 19 Jun 2024 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803598;
	bh=8AchACpwlGef3fZzdHE6mlKP0d8JsVxYADThM1xxC2Y=;
	h=From:To:Cc:Subject:Date:From;
	b=FPYciyuEdpbqoVz7FteR4eUmO+0wKATW0HyfGI/qXPRHDmmIbNtLNJ4pYJHUa6rXW
	 eAhkTB+06kYaE5autrzQ3SP+hW2yNu1eLAaSLEUnZ3UNtUsncVLXkPo1R+kHEUxHit
	 PFb8ZWn3R2M26NRYXmQLualK6mkEG2hSfSYj2XYU=
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
Subject: [PATCH 6.1 000/217] 6.1.95-rc1 review
Date: Wed, 19 Jun 2024 14:54:03 +0200
Message-ID: <20240619125556.491243678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.95-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.95-rc1
X-KernelTest-Deadline: 2024-06-21T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.95 release.
There are 217 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.95-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.95-rc1

Oleg Nesterov <oleg@redhat.com>
    zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING

Jean Delvare <jdelvare@suse.de>
    i2c: designware: Fix the functionality flags of the slave-only interface

Jean Delvare <jdelvare@suse.de>
    i2c: at91: Fix the functionality flags of the slave-only interface

Yongzhi Liu <hyperlyzcs@gmail.com>
    misc: microchip: pci1xxxx: Fix a memory leak in the error handling of gp_aux_bus_probe()

Shichao Lai <shichaorai@gmail.com>
    usb-storage: alauda: Check whether the media is initialized

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: core: Add UPIO_UNKNOWN constant for unknown port type

Jisheng Zhang <jszhang@kernel.org>
    serial: 8250_dw: fall back to poll if there's no interrupt

Sicong Huang <congei42@163.com>
    greybus: Fix use-after-free bug in gb_interface_release due to race condition.

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: generalise device address check

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix wcn3991 device address check

David Howells <dhowells@redhat.com>
    cachefiles, erofs: Fix NULL deref in when cachefiles is not doing ondemand-mode

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Jump to error handling labels in start/stop errors

Sam James <sam@gentoo.org>
    Revert "fork: defer linking file vma until vma is fully initialized"

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: update add_addr counters after connect

Doug Brown <doug@schmorgal.com>
    serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level

Miaohe Lin <linmiaohe@huawei.com>
    mm/memory-failure: fix handling of dissolved but not taken off from buddy pages

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory: don't unpoison huge_zero_folio

Oleg Nesterov <oleg@redhat.com>
    tick/nohz_full: Don't abuse smp_call_function_single() in tick_setup_device()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential kernel bug due to lack of writeback flag waiting

Filipe Manana <fdmanana@suse.com>
    btrfs: zoned: fix use-after-free due to race with dev replace

Christoph Hellwig <hch@lst.de>
    btrfs: zoned: factor out DUP bg handling from btrfs_load_block_group_zone_info

Christoph Hellwig <hch@lst.de>
    btrfs: zoned: factor out single bg handling from btrfs_load_block_group_zone_info

Christoph Hellwig <hch@lst.de>
    btrfs: zoned: factor out per-zone logic from btrfs_load_block_group_zone_info

Christoph Hellwig <hch@lst.de>
    btrfs: zoned: introduce a zone_info struct in btrfs_load_block_group_zone_info

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Lunar Lake support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Sapphire Rapids SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Granite Rapids SOC support

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Granite Rapids support

Vidya Srinivas <vidya.srinivas@intel.com>
    drm/i915/dpt: Make DPT object unshrinkable

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Disarm breadcrumbs if engines are already idle

Nam Cao <namcao@linutronix.de>
    riscv: rewrite __kernel_map_pages() to fix sleeping in invalid context

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs

Apurva Nandan <a-nandan@ti.com>
    remoteproc: k3-r5: Wait for core0 power-up before powering up core1

Nuno Sa <nuno.sa@analog.com>
    dmaengine: axi-dmac: fix possible race in remove()

Rick Wertenbroek <rick.wertenbroek@gmail.com>
    PCI: rockchip-ep: Remove wrong mask on subsys_vendor_id

Su Yue <glass.su@suse.com>
    ocfs2: fix races between hole punching and AIO+DIO

Su Yue <glass.su@suse.com>
    ocfs2: use coarse time for new created files

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore

Trond Myklebust <trond.myklebust@hammerspace.com>
    knfsd: LOOKUP can return an illegal error value

Vamshi Gajjela <vamshigajjela@google.com>
    spmi: hisi-spmi-controller: Do not override device identifier

Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
    vmci: prevent speculation leaks by sanitizing event in event_deliver()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    sock_map: avoid race between sock_map_close and sk_psock_put

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Print correct max open zones limit in null_init_zoned_dev()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/selftests: Fix kprobe event name test for .isra. functions

Nam Cao <namcao@linutronix.de>
    riscv: fix overlap of allocated page and PTR_ERR

Haifeng Xu <haifeng.xu@shopee.com>
    perf/core: Fix missing wakeup when waiting for context reference

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Check for invalid SMN reads

Hagar Hemdan <hagarhem@amazon.com>
    irqchip/gic-v3-its: Fix potential race condition in its_vlpi_prop_update()

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_una is properly initialized on connect

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: hdmi: report safe 640x480 mode as a fallback when no EDID found

Jani Nikula <jani.nikula@intel.com>
    drm/exynos/vidi: fix memory leak in .get_modes()

Dirk Behme <dirk.behme@de.bosch.com>
    drivers: core: synchronize really_probe() and dev_uevent()

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: delete unneeded update watermark call

Marc Ferland <marc.ferland@sonatest.com>
    iio: dac: ad5592r: fix temperature channel scaling value

David Lechner <dlechner@baylibre.com>
    iio: adc: ad9467: fix scan type sign

Benjamin Segall <bsegall@google.com>
    x86/boot: Don't add the EFI stub to targets, again

Yongzhi Liu <hyperlyzcs@gmail.com>
    misc: microchip: pci1xxxx: fix double free in the error handling of gp_aux_bus_probe()

Aleksandr Mishin <amishin@t-argos.ru>
    bnxt_en: Adjust logging of firmware messages in case of released token in __hwrm_send()

Rao Shoaib <Rao.Shoaib@oracle.com>
    af_unix: Read with MSG_PEEK loops if the first unread byte is OOB

Taehee Yoo <ap420073@gmail.com>
    ionic: fix use after netif_napi_del()

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: fix suspicious rcu usage in br_mst_set_state

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: pass vlan group directly to br_mst_vlan_set_state

Petr Pavlu <petr.pavlu@suse.com>
    net/ipv6: Fix the RT cache flush via sysctl using a previous delay

Daniel Wagner <dwagner@suse.de>
    nvmet-passthru: propagate status from id override functions

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: replace priv->speed with the portTransmitRate from the tc-cbs parameters

Joshua Washington <joshwash@google.com>
    gve: ignore nonrelevant GSO type bits when processing TSO headers

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Use EOPNOTSUPP error code instead of ENOTSUPP

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix rejecting L2CAP_CONN_PARAM_UPDATE_REQ

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix features validation check for tunneled UDP (non-VXLAN) packets

Gal Pressman <gal@nvidia.com>
    geneve: Fix incorrect inner network header offset when innerprotoinherit is set

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_v6_syn_recv_sock()

Adam Miotk <adam.miotk@arm.com>
    drm/bridge/panel: Fix runtime warning on panel bridge release

Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>
    drm/komeda: check for error-valued pointer

Aleksandr Mishin <amishin@t-argos.ru>
    liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet

Jie Wang <wangjie125@huawei.com>
    net: hns3: add cond_resched() to hns3 ring buffer init process

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix kernel crash problem in concurrent scenario

Csókás, Bence <csokas.bence@prolan.hu>
    net: sfp: Always call `sfp_sm_mod_remove()` on remove

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Remove STDU logic from generic mode_valid function

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: 3D disabled should not effect STDU memory limits

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Filter modes which exceed graphics memory

Martin Krastev <martin.krastev@broadcom.com>
    drm/vmwgfx: Refactor drm connector probing for display modes

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Port the framebuffer code to drm fb helpers

José Expósito <jose.exposito89@gmail.com>
    HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()

Kun(llfl) <llfl@linux.alibaba.com>
    iommu/amd: Fix sysfs leak in iommu init

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    HID: core: remove unnecessary WARN_ON() in implement()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: fix broken IRQ_TYPE_EDGE_BOTH interrupt type

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: store IRQ trigger type and unmask status separately

Linus Walleij <linus.walleij@linaro.org>
    gpio: tqmx86: Convert to immutable irq_chip

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: introduce shadow register for GPIO output value

Andrei Coardos <aboutphysycs@gmail.com>
    gpio: tqmx86: remove unneeded call to platform_set_drvdata()

Gregor Herburger <gregor.herburger@tq-group.com>
    gpio: tqmx86: fix typo in Kconfig label

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-smbios: Fix wrong token data in sysfs

NeilBrown <neilb@suse.de>
    NFS: add barriers when testing for NFS_FSDATA_BLOCKED

Chen Hanxiao <chenhx.fnst@fujitsu.com>
    SUNRPC: return proper error from gss_wrap_req_priv

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.1 enforce rootpath check in fs_location query

Samuel Holland <samuel.holland@sifive.com>
    clk: sifive: Do not register clkdevs for PRCI clocks

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix to check required event file

Baokun Li <libaokun1@huawei.com>
    cachefiles: flush all requests after setting CACHEFILES_DEAD

Baokun Li <libaokun1@huawei.com>
    cachefiles: defer exposing anon_fd until after copy_to_user() succeeds

Baokun Li <libaokun1@huawei.com>
    cachefiles: never get a new anonymous fd if ondemand_id is valid

Baokun Li <libaokun1@huawei.com>
    cachefiles: remove err_put_fd label in cachefiles_ondemand_daemon_read()

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix slab-use-after-free in cachefiles_ondemand_daemon_read()

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix slab-use-after-free in cachefiles_ondemand_get_fd()

Jia Zhu <zhujia.zj@bytedance.com>
    cachefiles: add restore command to recover inflight ondemand read requests

Baokun Li <libaokun1@huawei.com>
    cachefiles: add spin_lock for cachefiles_ondemand_info

Jia Zhu <zhujia.zj@bytedance.com>
    cachefiles: resend an open request if the read request's object is closed

Jia Zhu <zhujia.zj@bytedance.com>
    cachefiles: extract ondemand info field from cachefiles_object

Jia Zhu <zhujia.zj@bytedance.com>
    cachefiles: introduce object ondemand state

Baokun Li <libaokun1@huawei.com>
    cachefiles: remove requests from xarray during flushing requests

Baokun Li <libaokun1@huawei.com>
    cachefiles: add output string to cachefiles_obj_[get|put]_ondemand_fd

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Add missing vmalloc.h for tools/testing/cxl/test/mem.c

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: try trimming too long modalias strings

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/uaccess: Fix build errors seen with GCC 13/14

Ziwei Xiao <ziweixiao@google.com>
    gve: Clear napi->skb before dev_kfree_skb_any()

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: sd: Use READ(16) when reading block zero on large capacity disks

Breno Leitao <leitao@debian.org>
    scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Fix ATA NCQ priority support

Aapo Vienamo <aapo.vienamo@linux.intel.com>
    thunderbolt: debugfs: Fix margin debugfs node creation condition

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply broken streams quirk to Etron EJ188 xHCI host

Hector Martin <marcan@marcan.st>
    xhci: Handle TD clearing for multiple streams case

Kuangyi Chiang <ki.chiang65@gmail.com>
    xhci: Apply reset resume quirk to Etron EJ188 xHCI host

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Set correct transferred length for cancelled bulk transfers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    jfs: xattr: fix buffer overflow for invalid xattr

Mickaël Salaün <mic@digikod.net>
    landlock: Fix d_parent walk

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    tty: n_tty: Fix buffer offsets when lookahead is used

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: release irq in mei_me_pci_resume error path

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Ignore received Hard Reset in TOGGLING state

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: fix use-after-free case in tcpm_register_source_caps

John Ernberg <john.ernberg@actia.se>
    USB: xen-hcd: Traverse host/ when CONFIG_USB_XEN_HCD is selected

Alan Stern <stern@rowland.harvard.edu>
    USB: class: cdc-wdm: Fix CPU lockup caused by excessive log messages

Jens Axboe <axboe@kernel.dk>
    io_uring: check for non-NULL file pointer in io_file_can_poll()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix nilfs_empty_dir() misjudgment and long loop on I/O errors

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: return the mapped address from nilfs_get_page()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix leak of qgroup extent records after transaction abort

Filipe Manana <fdmanana@suse.com>
    btrfs: make btrfs_destroy_delayed_refs() return void

Filipe Manana <fdmanana@suse.com>
    btrfs: remove unnecessary prototype declarations at disk-io.c

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: fix QCOM_RPROC_COMMON dependency

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix bogus test success on Aarch64

Mark Brown <broonie@kernel.org>
    selftests/mm: log a consistent test name for check_compaction

Muhammad Usama Anjum <usama.anjum@collabora.com>
    selftests/mm: conform test to TAP format output

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages

Hailong.Liu <hailong.liu@oppo.com>
    mm/vmalloc: fix vmalloc which may return null if called with __GFP_NOFAIL

Michal Hocko <mhocko@suse.com>
    mm, vmalloc: fix high order __GFP_NOFAIL allocations

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    i2c: acpi: Unbind mux adapters before delete

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    i2c: add fwnode APIs

Johan Hovold <johan+linaro@kernel.org>
    HID: i2c-hid: elan: fix reset suspend current leakage

Cong Yang <yangcong5@huaqin.corp-partner.google.com>
    HID: i2c-hid: elan: Add ili9882t timing

Gabor Juhos <j4g8y7@gmail.com>
    firmware: qcom_scm: disable clocks if qcom_scm_bw_enable() fails

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mmc: davinci: Don't strip remove function when driver is builtin

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: replace hardcoded divisor value with BIT() macro

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic-pci: register attributes via pci_driver

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic: deduplicate common code

Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
    arm64: dts: qcom: sa8155p-adp: fix SDHC2 CD pin configuration

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8150: align TLMM pin configuration with DT schema

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix incorrect DSC instance for MST

Alexey Kodanev <aleksei.kodanev@bell-sw.com>
    drm/amd/display: drop unnecessary NULL checks in debugfs

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix MAKE_PC_FROM_RA second argument

Randy Dunlap <rdunlap@infradead.org>
    xtensa: stacktrace: include <asm/ftrace.h> for prototype

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Reset chip on probe() and resume()

Luca Ceresoli <luca.ceresoli@bootlin.com>
    iio: accel: mxc4005: allow module autoloading via OF compatible

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete

John Keeping <john@metanate.com>
    usb: gadget: f_fs: use io_data->status consistently

Qu Wenruo <wqu@suse.com>
    btrfs: fix wrong block_start calculation for btrfs_drop_extent_map_range()

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix invalid device address check

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible race in __fib6_drop_pcpu_from()

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_empty_lockless() in unix_release_sock().

Eric Dumazet <edumazet@google.com>
    af_unix: annotate lockless accesses to sk->sk_err

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in UNIX_DIAG.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_stream_read_skb().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in sendmsg() and recvmsg().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_stream_connect().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_state in unix_write_space() and poll().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_inq_len().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annodate data-races around sk->sk_state for writers.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Set sk->sk_state under unix_state_lock() for truly disconencted peer.

Aleksandr Mishin <amishin@t-argos.ru>
    net: wwan: iosm: Fix tainted pointer delete is case of region creation fail

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: remove af_xdp_zc_qps bitmap

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: remove null checks before devm_kfree() calls

Michal Wilczynski <michal.wilczynski@intel.com>
    ice: Introduce new parameters in ice_sched_node

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix iteration of TLVs in Preserved Fields Area

Karol Kolacinski <karol.kolacinski@intel.com>
    ptp: Fix error message on failed pin verification

Eric Dumazet <edumazet@google.com>
    net/sched: taprio: always validate TCA_TAPRIO_ATTR_PRIOMAP

Aleksandr Mishin <amishin@t-argos.ru>
    net/mlx5: Fix tainted pointer delete is case of flow rules creation fail

Shay Drory <shayd@nvidia.com>
    net/mlx5: Always stop health timer during driver removal

Shay Drory <shayd@nvidia.com>
    net/mlx5: Split function_setup() to enable and open functions

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Stop waiting for PCI if pci channel is offline

Moshe Shemesh <moshe@mellanox.com>
    net/mlx5: Stop waiting for PCI up if teardown was triggered

Jason Xing <kernelxing@tencent.com>
    tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Hangyu Hua <hbh25y@gmail.com>
    net: sched: sch_multiq: fix possible OOB write in multiq_tune()

Wen Gu <guwen@linux.alibaba.com>
    net/smc: avoid overwriting when adjusting sock bufsizes

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Always allocate PF entries from low prioriy zone

Jiri Olsa <jolsa@kernel.org>
    bpf: Set run context for rawtp test_run callback

Eric Dumazet <edumazet@google.com>
    ipv6: sr: block BH in seg6_output_core() and seg6_input_core()

Eric Dumazet <edumazet@google.com>
    ipv6: ioam: block BH from ioam6_output()

DelphineCCChiu <delphine_cc_chiu@wiwynn.com>
    net/ncsi: Fix the multi thread manner of NCSI driver

Peter Delevoryas <peter@pjd.dev>
    net/ncsi: Simplify Kconfig/dts control flow

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Replace kfree() in ax25_dev_free() with ax25_dev_put()

Lars Kellogg-Stedman <lars@oddbit.com>
    ax25: Fix refcount imbalance on inbound connections

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: mac80211: correctly parse Spatial Reuse Parameter Set element

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't read past the mfuart notifcation

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: check n_ssids before accessing the ssids

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    wifi: iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64

Lin Ma <linma@zju.edu.cn>
    wifi: cfg80211: pmsr: use correct nla_get_uX functions

Remi Pommarel <repk@triplefau.lt>
    wifi: cfg80211: Lock wiphy in cfg80211_get_station

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fully move wiphy work to unbound workqueue

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Fix deadlock in ieee80211_sta_ps_deliver_wakeup()

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: Fix leak of mesh_preq_queue objects


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts           |  86 +--
 .../boot/dts/qcom/sm8150-microsoft-surface-duo.dts |   2 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               | 376 ++++------
 arch/powerpc/include/asm/uaccess.h                 |  15 +-
 arch/riscv/mm/init.c                               |  21 +-
 arch/riscv/mm/pageattr.c                           |  28 +-
 arch/x86/boot/compressed/Makefile                  |   4 +-
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/xtensa/include/asm/processor.h                |   8 +-
 arch/xtensa/include/asm/ptrace.h                   |   2 +-
 arch/xtensa/kernel/process.c                       |   5 +-
 arch/xtensa/kernel/stacktrace.c                    |   4 +-
 drivers/base/core.c                                |   3 +
 drivers/block/null_blk/zoned.c                     |   2 +-
 drivers/bluetooth/btqca.c                          |  46 +-
 drivers/bluetooth/btqca.h                          |   2 +
 drivers/bluetooth/hci_qca.c                        |   2 -
 drivers/clk/sifive/sifive-prci.c                   |   8 -
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/firmware/qcom_scm.c                        |  18 +-
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-tqmx86.c                         | 136 +++-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  | 120 ++-
 .../drm/arm/display/komeda/komeda_pipeline_state.c |   2 +-
 drivers/gpu/drm/bridge/panel.c                     |   7 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   7 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   7 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.h         |   4 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  15 +-
 drivers/gpu/drm/vmwgfx/Kconfig                     |   7 -
 drivers/gpu/drm/vmwgfx/Makefile                    |   2 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  65 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |  38 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 | 831 ---------------------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                | 353 +++------
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h                |  13 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |   5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c               |   5 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |  47 +-
 drivers/greybus/interface.c                        |   1 +
 drivers/hid/hid-core.c                             |   1 -
 drivers/hid/hid-logitech-dj.c                      |   4 +-
 drivers/hid/i2c-hid/i2c-hid-of-elan.c              | 103 ++-
 drivers/hwtracing/intel_th/pci.c                   |  25 +
 drivers/i2c/busses/i2c-at91-slave.c                |   3 +-
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/i2c/i2c-core-acpi.c                        |  30 +-
 drivers/i2c/i2c-core-base.c                        |  98 +++
 drivers/i2c/i2c-core-of.c                          |  66 --
 drivers/iio/accel/mxc4005.c                        |  76 ++
 drivers/iio/adc/ad9467.c                           |   4 +-
 drivers/iio/dac/ad5592r-base.c                     |   2 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   4 -
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   4 -
 drivers/input/input.c                              | 104 ++-
 drivers/iommu/amd/init.c                           |   9 +
 drivers/irqchip/irq-gic-v3-its.c                   |  44 +-
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c      |   9 +-
 drivers/misc/mei/pci-me.c                          |   4 +-
 drivers/misc/pvpanic/pvpanic-mmio.c                |  58 +-
 drivers/misc/pvpanic/pvpanic-pci.c                 |  60 +-
 drivers/misc/pvpanic/pvpanic.c                     |  76 +-
 drivers/misc/pvpanic/pvpanic.h                     |  10 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   6 +-
 drivers/mmc/host/davinci_mmc.c                     |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |   2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  |  11 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   8 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  20 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  21 +-
 drivers/net/ethernet/intel/ice/ice.h               |  32 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   4 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   9 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |   3 +-
 drivers/net/ethernet/intel/ice/ice_flow.c          |  23 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  46 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |  28 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |  90 ++-
 drivers/net/ethernet/intel/ice/ice_sched.h         |  27 +
 drivers/net/ethernet/intel/ice/ice_switch.c        |  19 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   8 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  13 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  12 +
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 116 ++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  25 +-
 drivers/net/geneve.c                               |  10 +-
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 +
 drivers/net/wireless/ath/ath10k/Kconfig            |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  10 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 drivers/net/wwan/iosm/iosm_ipc_devlink.c           |   2 +-
 drivers/nvme/target/passthru.c                     |   6 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   6 +-
 drivers/platform/x86/dell/dell-smbios-base.c       |  92 +--
 drivers/ptp/ptp_chardev.c                          |   3 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |  58 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  62 ++
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  19 +
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   3 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  23 -
 drivers/scsi/scsi_transport_sas.c                  |  23 +
 drivers/scsi/sd.c                                  |  17 +-
 drivers/spmi/hisi-spmi-controller.c                |   1 -
 drivers/thunderbolt/debugfs.c                      |   5 +-
 drivers/tty/n_tty.c                                |  22 +-
 drivers/tty/serial/8250/8250_dw.c                  |   5 +-
 drivers/tty/serial/8250/8250_pxa.c                 |   1 +
 drivers/tty/serial/sc16is7xx.c                     |  25 +-
 drivers/usb/Makefile                               |   1 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/gadget/function/f_fs.c                 |   9 +-
 drivers/usb/host/xhci-pci.c                        |   7 +
 drivers/usb/host/xhci-ring.c                       |  59 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/storage/alauda.c                       |   9 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   5 +-
 fs/btrfs/disk-io.c                                 |  26 +-
 fs/btrfs/extent_map.c                              |   2 +-
 fs/btrfs/zoned.c                                   | 330 ++++----
 fs/cachefiles/daemon.c                             |   4 +-
 fs/cachefiles/interface.c                          |   7 +-
 fs/cachefiles/internal.h                           |  52 +-
 fs/cachefiles/ondemand.c                           | 324 ++++++--
 fs/jfs/xattr.c                                     |   4 +-
 fs/nfs/dir.c                                       |  47 +-
 fs/nfs/nfs4proc.c                                  |  23 +-
 fs/nfsd/nfsfh.c                                    |   4 +-
 fs/nilfs2/dir.c                                    |  59 +-
 fs/nilfs2/segment.c                                |   3 +
 fs/ocfs2/file.c                                    |   2 +
 fs/ocfs2/namei.c                                   |   2 +-
 fs/proc/vmcore.c                                   |   2 +
 include/linux/i2c.h                                |  26 +-
 include/linux/pse-pd/pse.h                         |   4 +-
 include/linux/serial_core.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |  36 +-
 include/net/ip_tunnels.h                           |   5 +-
 include/scsi/scsi_transport_sas.h                  |   2 +
 include/trace/events/cachefiles.h                  |   8 +-
 io_uring/kbuf.c                                    |   3 +-
 kernel/events/core.c                               |  13 +
 kernel/fork.c                                      |  18 +-
 kernel/pid_namespace.c                             |   1 +
 kernel/time/tick-common.c                          |  42 +-
 mm/memory-failure.c                                |  11 +-
 mm/vmalloc.c                                       |  29 +-
 net/ax25/af_ax25.c                                 |   6 +
 net/ax25/ax25_dev.c                                |   2 +-
 net/bluetooth/l2cap_core.c                         |   8 +-
 net/bpf/test_run.c                                 |   6 +
 net/bridge/br_mst.c                                |  13 +-
 net/core/sock_map.c                                |  16 +-
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv6/ioam6_iptunnel.c                          |   8 +-
 net/ipv6/ip6_fib.c                                 |   6 +-
 net/ipv6/route.c                                   |   5 +-
 net/ipv6/seg6_iptunnel.c                           |  14 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/mac80211/he.c                                  |  10 +-
 net/mac80211/mesh_pathtbl.c                        |  13 +
 net/mac80211/sta_info.c                            |   4 +-
 net/mptcp/pm_netlink.c                             |  21 +-
 net/mptcp/protocol.c                               |   1 +
 net/ncsi/internal.h                                |   2 +
 net/ncsi/ncsi-manage.c                             |  95 +--
 net/ncsi/ncsi-rsp.c                                |   4 +-
 net/netfilter/ipset/ip_set_core.c                  |  93 ++-
 net/netfilter/ipset/ip_set_list_set.c              |  30 +-
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_taprio.c                             |  15 +-
 net/smc/af_smc.c                                   |  22 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   4 +-
 net/unix/af_unix.c                                 | 109 ++-
 net/unix/diag.c                                    |  12 +-
 net/wireless/core.c                                |   2 +-
 net/wireless/pmsr.c                                |   8 +-
 net/wireless/sysfs.c                               |   4 +-
 net/wireless/util.c                                |   7 +-
 security/landlock/fs.c                             |  13 +-
 tools/testing/cxl/test/mem.c                       |   1 +
 .../ftrace/test.d/dynevent/test_duplicates.tc      |   2 +-
 .../ftrace/test.d/kprobe/kprobe_eventname.tc       |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   5 +-
 tools/testing/selftests/vm/compaction_test.c       | 108 +--
 197 files changed, 2950 insertions(+), 3037 deletions(-)


