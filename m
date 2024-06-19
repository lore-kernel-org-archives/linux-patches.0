Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF9A14D705;
	Wed, 19 Jun 2024 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802689; cv=none; b=aGxMhxPiDDg4lDVGs9zRHs5DhtmTtp3iQdje3WF7wm9ulwFDG2WycxVPBsd7Kqm/Tvt86nM37Wq7XHKB9ogIE+SwOnPeNyGyXzHEdrq9obq0xY1bvkEgGDnhvh39FQdZlmAUH0QLD9ig3vKzNvHlQtqX44Liii9oP6Ul8GBWosA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802689; c=relaxed/simple;
	bh=LvZ1YHfooWFIrqHAQ9E1OYh+wv+GSYxkASIrBGhSnjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Es1WsPYOvkA0a3aj7r/sN/WRE16zWcFSuCWo6HZklUjWpiGj4fjfAucJYn4iUGq3mqRUqg7neTTtZlGQZhqUAsKDQcaWqYkv6jXGZzEgsXe6s0gqFt1B8AXb4U/Su5cki8d/chEe5iQ7JKYJKU5UA7lY67yxgQlJlnypilMfieI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0m6/XCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0m6/XCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183D6C4AF60;
	Wed, 19 Jun 2024 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802688;
	bh=LvZ1YHfooWFIrqHAQ9E1OYh+wv+GSYxkASIrBGhSnjw=;
	h=From:To:Cc:Subject:Date:From;
	b=T0m6/XCmDNS+zquqvqmimkT/KgpM9s/wtO8fkj5hEFRqYkh6umJIaKYu6MShk8hZN
	 u/2Xr1MZpw6/H9Qucfcknq6O0hcJCFSEXfRlYri5irnM7yuMdHKx3x2HkKalowz1UD
	 pyj15MkLXGgiaPz52jqJDVezjnbCWijojux9hmUo=
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
Subject: [PATCH 6.9 000/281] 6.9.6-rc1 review
Date: Wed, 19 Jun 2024 14:52:39 +0200
Message-ID: <20240619125609.836313103@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.6-rc1
X-KernelTest-Deadline: 2024-06-21T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.6 release.
There are 281 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.6-rc1

Oleg Nesterov <oleg@redhat.com>
    zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING

Jean Delvare <jdelvare@suse.de>
    i2c: designware: Fix the functionality flags of the slave-only interface

Jean Delvare <jdelvare@suse.de>
    i2c: at91: Fix the functionality flags of the slave-only interface

Yongzhi Liu <hyperlyzcs@gmail.com>
    misc: microchip: pci1xxxx: Fix a memory leak in the error handling of gp_aux_bus_probe()

Hans de Goede <hdegoede@redhat.com>
    mei: vsc: Fix wrong invocation of ACPI SID method

Shichao Lai <shichaorai@gmail.com>
    usb-storage: alauda: Check whether the media is initialized

Rob Herring (Arm) <robh@kernel.org>
    dt-bindings: usb: realtek,rts5411: Add missing "additionalProperties" on child nodes

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw

Stefan Berger <stefanb@linux.ibm.com>
    ima: Fix use-after-free on a dentry's dname.name

Sicong Huang <congei42@163.com>
    greybus: Fix use-after-free bug in gb_interface_release due to race condition.

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Jump to error handling labels in start/stop errors

Miaohe Lin <linmiaohe@huawei.com>
    mm/huge_memory: don't unpoison huge_zero_folio

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix a crash on 7265

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: support iwl_dev_tx_power_cmd_v8

Filipe Manana <fdmanana@suse.com>
    btrfs: zoned: fix use-after-free due to race with dev replace

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    pmdomain: ti-sci: Fix duplicate PD referrals

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

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix audio component initialization

Vidya Srinivas <vidya.srinivas@intel.com>
    drm/i915/dpt: Make DPT object unshrinkable

Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
    drm/xe: Properly handle alloc_guc_id() failure

Wachowski, Karol <karol.wachowski@intel.com>
    drm/shmem-helper: Fix BUG_ON() on mmap(PROT_WRITE, MAP_PRIVATE)

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Disarm breadcrumbs if engines are already idle

Daniel Bristot de Oliveira <bristot@kernel.org>
    rtla/auto-analysis: Replace \t with spaces

Daniel Bristot de Oliveira <bristot@kernel.org>
    rtla/timerlat: Simplify "no value" printing on top

Nam Cao <namcao@linutronix.de>
    riscv: force PAGE_SIZE linear mapping if debug_pagealloc is enabled

Nam Cao <namcao@linutronix.de>
    riscv: rewrite __kernel_map_pages() to fix sleeping in invalid context

Wayne Lin <Wayne.Lin@amd.com>
    drm/mst: Fix NULL pointer dereference at drm_dp_add_payload_part2

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: invensense: fix interrupt timestamp alignment

Dimitri Fedrau <dima.fedrau@gmail.com>
    iio: temperature: mcp9600: Fix temperature reading for negative values

Nuno Sa <nuno.sa@analog.com>
    iio: adc: axi-adc: make sure AXI clock is enabled

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Do not allow core1 to power up before core0 via sysfs

Apurva Nandan <a-nandan@ti.com>
    remoteproc: k3-r5: Wait for core0 power-up before powering up core1

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: aux-hpd-bridge: correct devm_drm_dp_hpd_bridge_add() stub

Nuno Sa <nuno.sa@analog.com>
    dmaengine: axi-dmac: fix possible race in remove()

Rick Wertenbroek <rick.wertenbroek@gmail.com>
    PCI: rockchip-ep: Remove wrong mask on subsys_vendor_id

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: set discard_granularity to logical block size

Su Yue <glass.su@suse.com>
    ocfs2: fix races between hole punching and AIO+DIO

Su Yue <glass.su@suse.com>
    ocfs2: use coarse time for new created files

Su Yue <glass.su@suse.com>
    ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_link

Baoquan He <bhe@redhat.com>
    kexec: fix the unexpected kexec_dprintk() macro

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore

Trond Myklebust <trond.myklebust@hammerspace.com>
    knfsd: LOOKUP can return an illegal error value

Vamshi Gajjela <vamshigajjela@google.com>
    spmi: hisi-spmi-controller: Do not override device identifier

Hagar Gamal Halim Hemdan <hagarhem@amazon.com>
    vmci: prevent speculation leaks by sanitizing event in event_deliver()

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-buf: handle testing kthreads creation failure

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    sock_map: avoid race between sock_map_close and sk_psock_put

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Add ATA_HORKAGE_NOLPM for AMD Radeon S3 SSD

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Add ATA_HORKAGE_NOLPM for Crucial CT240BX500SSD1

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Add ATA_HORKAGE_NOLPM for Apacer AS340

Jason Nader <dev@kayoway.com>
    ata: ahci: Do not apply Intel PCS quirk on Intel Alder Lake

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Print correct max open zones limit in null_init_zoned_dev()

Matthias Maennich <maennich@google.com>
    kheaders: explicitly define file modes for archived headers

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/selftests: Fix kprobe event name test for .isra. functions

Nam Cao <namcao@linutronix.de>
    riscv: fix overlap of allocated page and PTR_ERR

Carlos Llamas <cmllamas@google.com>
    locking/atomic: scripts: fix ${atomic}_sub_and_test() kerneldoc

Johannes Berg <johannes.berg@intel.com>
    wifi: mt76: mt7615: add missing chanctx ops

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: Ignore IEEE80211_CONF_CHANGE_RETRY_LIMITS

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: validate HE operation element parsing

Adrian Hunter <adrian.hunter@intel.com>
    perf script: Show also errors for --insn-trace option

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix multiple use of --itrace option

Haifeng Xu <haifeng.xu@shopee.com>
    perf/core: Fix missing wakeup when waiting for context reference

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Check for invalid SMN reads

David Kaplan <david.kaplan@amd.com>
    x86/kexec: Fix bug with call depth tracking

Hagar Hemdan <hagarhem@amazon.com>
    irqchip/gic-v3-its: Fix potential race condition in its_vlpi_prop_update()

Samuel Holland <samuel.holland@sifive.com>
    irqchip/sifive-plic: Chain to parent IRQ after handlers are ready

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: update add_addr counters after connect

YonglongLi <liyonglong@chinatelecom.cn>
    mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_una is properly initialized on connect

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: hdmi: report safe 640x480 mode as a fallback when no EDID found

Jani Nikula <jani.nikula@intel.com>
    drm/exynos/vidi: fix memory leak in .get_modes()

Jan Beulich <jbeulich@suse.com>
    memblock: make memblock_set_node() also warn about use of MAX_NUMNODES

Jan Beulich <jbeulich@suse.com>
    x86/mm/numa: Use NUMA_NO_NODE when calling memblock_set_node()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: ACPI: Invalidate trip points with temperature of 0 or below

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Force StorageD3Enable on more products

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/ATL: Use system settings for MI300 DRAM to normalized address translation

Yazen Ghannam <yazen.ghannam@amd.com>
    RAS/AMD/ATL: Fix MI300 bank hash

John David Anglin <dave@parisc-linux.org>
    parisc: Try to fix random segmentation faults in package builds

Dirk Behme <dirk.behme@de.bosch.com>
    drivers: core: synchronize really_probe() and dev_uevent()

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: delete unneeded update watermark call

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    iio: temperature: mlx90635: Fix ERR_PTR dereference in mlx90635_probe()

Adam Rizkalla <ajarizzo@gmail.com>
    iio: pressure: bmp280: Fix BMP580 temperature reading

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: invensense: fix odr switching to same value

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: imu: bmi323: Fix trigger notification in case of error

Marc Ferland <marc.ferland@sonatest.com>
    iio: dac: ad5592r: fix temperature channel scaling value

David Lechner <dlechner@baylibre.com>
    iio: adc: ad9467: fix scan type sign

Benjamin Segall <bsegall@google.com>
    x86/boot: Don't add the EFI stub to targets, again

Hans de Goede <hdegoede@redhat.com>
    leds: class: Revert: "If no default trigger is given, make hw_control trigger the default trigger"

Oleg Nesterov <oleg@redhat.com>
    tick/nohz_full: Don't abuse smp_call_function_single() in tick_setup_device()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix missing use of get_write in in smb2_set_ea()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: move leading slash check to smb2_get_name()

Yongzhi Liu <hyperlyzcs@gmail.com>
    misc: microchip: pci1xxxx: fix double free in the error handling of gp_aux_bus_probe()

Aleksandr Mishin <amishin@t-argos.ru>
    bnxt_en: Adjust logging of firmware messages in case of released token in __hwrm_send()

Rao Shoaib <Rao.Shoaib@oracle.com>
    af_unix: Read with MSG_PEEK loops if the first unread byte is OOB

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Cap the size of HWRM_PORT_PHY_QCFG forwarded response

Taehee Yoo <ap420073@gmail.com>
    ionic: fix use after netif_napi_del()

Riana Tauro <riana.tauro@intel.com>
    drm/xe: move disable_c6 call

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Remove mem_access from guc_pc calls

Andrzej Hajda <andrzej.hajda@intel.com>
    drm/xe: flush engine buffers before signalling user fence on all engines

Riana Tauro <riana.tauro@intel.com>
    drm/xe/xe_gt_idle: use GT forcewake domain assertion

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: fix suspicious rcu usage in br_mst_set_state

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: pass vlan group directly to br_mst_vlan_set_state

Petr Pavlu <petr.pavlu@suse.com>
    net/ipv6: Fix the RT cache flush via sysctl using a previous delay

Daniel Wagner <dwagner@suse.de>
    nvmet-passthru: propagate status from id override functions

Chengming Zhou <chengming.zhou@linux.dev>
    block: fix request.queuelist usage in flush

Su Hui <suhui@nfschina.com>
    block: sed-opal: avoid possible wrong address reference in read_sed_opal_key()

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: replace priv->speed with the portTransmitRate from the tc-cbs parameters

Joshua Washington <joshwash@google.com>
    gve: ignore nonrelevant GSO type bits when processing TSO headers

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Use EOPNOTSUPP error code instead of ENOTSUPP

Ziqi Chen <quic_ziqichen@quicinc.com>
    scsi: ufs: core: Quiesce request queues before checking pending cmds

Kees Cook <kees@kernel.org>
    x86/uaccess: Fix missed zeroing of ia32 u64 get_user() range checking

Uros Bizjak <ubizjak@gmail.com>
    x86/asm: Use %c/%n instead of %P operand modifier in asm templates

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type

Davide Ornaghi <d.ornaghi97@gmail.com>
    netfilter: nft_inner: validate mandatory meta and payload

Vasily Khoruzhick <anarsoul@gmail.com>
    drm/nouveau: don't attempt to schedule hpd_work on headless cards

Eric Dumazet <edumazet@google.com>
    tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()

Johannes Berg <johannes.berg@intel.com>
    net/sched: initialize noop_qdisc owner

Pauli Virtanen <pav@iki.fi>
    Bluetooth: fix connection setup in l2cap_connect

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix rejecting L2CAP_CONN_PARAM_UPDATE_REQ

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not using correct handle

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix features validation check for tunneled UDP (non-VXLAN) packets

Gal Pressman <gal@nvidia.com>
    geneve: Fix incorrect inner network header offset when innerprotoinherit is set

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    net dsa: qca8k: fix usages of device_get_named_child_node()

Eric Dumazet <edumazet@google.com>
    tcp: fix race in tcp_v6_syn_recv_sock()

Adam Miotk <adam.miotk@arm.com>
    drm/bridge/panel: Fix runtime warning on panel bridge release

Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>
    drm/komeda: check for error-valued pointer

David Wei <dw@davidwei.uk>
    netdevsim: fix backwards compatibility in nsim_get_iflink()

Sagar Cheluvegowda <quic_scheluve@quicinc.com>
    net: stmmac: dwmac-qcom-ethqos: Configure host DMA width

Aleksandr Mishin <amishin@t-argos.ru>
    liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Do not fail cdev registration because of invalid initial state

Jie Wang <wangjie125@huawei.com>
    net: hns3: add cond_resched() to hns3 ring buffer init process

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix kernel crash problem in concurrent scenario

Csókás, Bence <csokas.bence@prolan.hu>
    net: sfp: Always call `sfp_sm_mod_remove()` on remove

Masahiro Yamada <masahiroy@kernel.org>
    modpost: do not warn about missing MODULE_DESCRIPTION() for vmlinux.o

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_state in unix_accept().

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Don't memcmp equivalent pointers

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Remove STDU logic from generic mode_valid function

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: 3D disabled should not effect STDU memory limits

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Filter modes which exceed graphics memory

José Expósito <jose.exposito89@gmail.com>
    HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()

Su Hui <suhui@nfschina.com>
    io_uring/io-wq: avoid garbage value of 'match' in io_wq_enqueue()

Breno Leitao <leitao@debian.org>
    io_uring/io-wq: Use set_bit() and test_bit() at worker->flags

Lu Baolu <baolu.lu@linux.intel.com>
    iommu: Return right value in iommu_sva_bind_device()

Kun(llfl) <llfl@linux.alibaba.com>
    iommu/amd: Fix sysfs leak in iommu init

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    HID: core: remove unnecessary WARN_ON() in implement()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: fix broken IRQ_TYPE_EDGE_BOTH interrupt type

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: store IRQ trigger type and unmask status separately

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    gpio: tqmx86: introduce shadow register for GPIO output value

Gregor Herburger <gregor.herburger@tq-group.com>
    gpio: tqmx86: fix typo in Kconfig label

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-smbios: Fix wrong token data in sysfs

Chen Ni <nichen@iscas.ac.cn>
    drm/panel: sitronix-st7789v: Add check for of_drm_get_panel_orientation

Weiwen Hu <huweiwen@linux.alibaba.com>
    nvme: fix nvme_pr_* status code parsing

John Hubbard <jhubbard@nvidia.com>
    selftests/futex: don't pass a const char* to asprintf(3)

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/tracing: Fix event filter test to retry up to 10 times

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

Mark Brown <broonie@kernel.org>
    kselftest/alsa: Ensure _GNU_SOURCE is defined

Baokun Li <libaokun1@huawei.com>
    cachefiles: flush all requests after setting CACHEFILES_DEAD

Baokun Li <libaokun1@huawei.com>
    cachefiles: defer exposing anon_fd until after copy_to_user() succeeds

Baokun Li <libaokun1@huawei.com>
    cachefiles: never get a new anonymous fd if ondemand_id is valid

Baokun Li <libaokun1@huawei.com>
    cachefiles: remove err_put_fd label in cachefiles_ondemand_daemon_read()

Baokun Li <libaokun1@huawei.com>
    cachefiles: add spin_lock for cachefiles_ondemand_info

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix slab-use-after-free in cachefiles_ondemand_daemon_read()

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix slab-use-after-free in cachefiles_ondemand_get_fd()

Baokun Li <libaokun1@huawei.com>
    cachefiles: remove requests from xarray during flushing requests

Baokun Li <libaokun1@huawei.com>
    cachefiles: add output string to cachefiles_obj_[get|put]_ondemand_fd

Li Zhijian <lizhijian@fujitsu.com>
    cxl/region: Fix memregion leaks in devm_cxl_add_region()

Dave Jiang <dave.jiang@intel.com>
    cxl/test: Add missing vmalloc.h for tools/testing/cxl/test/mem.c

Chen Ni <nichen@iscas.ac.cn>
    HID: nvidia-shield: Add missing check for input_ff_create_memless

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/uaccess: Fix build errors seen with GCC 13/14

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/85xx: fix compile error without CONFIG_CRASH_DUMP

Ziwei Xiao <ziweixiao@google.com>
    gve: Clear napi->skb before dev_kfree_skb_any()

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: sd: Use READ(16) when reading block zero on large capacity disks

Breno Leitao <leitao@debian.org>
    scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Fix ATA NCQ priority support

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: Disable CDL by default

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Set the RMB bit only for removable media devices

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

Douglas Anderson <dianders@chromium.org>
    serial: port: Don't block system suspend even if bytes are left to xmit

Doug Brown <doug@schmorgal.com>
    serial: 8250_pxa: Configure tx_loadsz to match FIFO IRQ level

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    tty: n_tty: Fix buffer offsets when lookahead is used

Wentong Wu <wentong.wu@intel.com>
    mei: vsc: Don't stop/restart mei device during system suspend/resume

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: release irq in mei_me_pci_resume error path

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Ignore received Hard Reset in TOGGLING state

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: fix use-after-free case in tcpm_register_source_caps

John Ernberg <john.ernberg@actia.se>
    USB: xen-hcd: Traverse host/ when CONFIG_USB_XEN_HCD is selected

Andrey Konovalov <andreyknvl@gmail.com>
    kcov, usb: disable interrupts in kcov_remote_start_usb_softirq

Alan Stern <stern@rowland.harvard.edu>
    USB: class: cdc-wdm: Fix CPU lockup caused by excessive log messages

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix cancellation overwriting req->flags

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rsrc: don't lock while !TASK_RUNNING

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    .editorconfig: remove trim_trailing_whitespace option

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Update all the eventfs_inodes from the events descriptor

Dev Jain <dev.jain@arm.com>
    selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation

Nathan Chancellor <nathan@kernel.org>
    selftests/mm: ksft_exit functions do not return

Dave Hansen <dave.hansen@linux.intel.com>
    x86/cpu: Provide default cache line size if not enumerated

Borislav Petkov (AMD) <bp@alien8.de>
    x86/cpu: Get rid of an unnecessary local variable in get_cpu_address_sizes()

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use ordered WQ for G2H handler

Su Hui <suhui@nfschina.com>
    net: ethtool: fix the error condition in ethtool_get_phy_stats_ethtool()

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible race in __fib6_drop_pcpu_from()

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of sk->sk_shutdown in sk_diag_fill().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use skb_queue_empty_lockless() in unix_release_sock().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Use unix_recvq_full_lockless() in unix_stream_connect().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race of net->unx.sysctl_max_dgram_qlen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-races around sk->sk_sndbuf.

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

Sasha Neftin <sasha.neftin@intel.com>
    igc: Fix Energy Efficient Ethernet support declaration

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: map XDP queues to vectors in ice_vsi_map_rings_to_vectors()

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: add flag to distinguish reset from .ndo_bpf in XDP rings config

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: remove af_xdp_zc_qps bitmap

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix reads from NVM Shadow RAM on E830 and E825-C devices

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

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Stop waiting for PCI if pci channel is offline

Frank Wunderlich <frank-w@public-files.de>
    net: ethernet: mtk_eth_soc: handle dma buffer size soc specific

Jakub Kicinski <kuba@kernel.org>
    rtnetlink: make the "split" NLM_DONE handling generic

Jason Xing <kernelxing@tencent.com>
    mptcp: count CLOSE-WAIT sockets for MPTCP_MIB_CURRESTAB

Jason Xing <kernelxing@tencent.com>
    tcp: count CLOSE-WAIT sockets for TCP_MIB_CURRESTAB

Hangyu Hua <hbh25y@gmail.com>
    net: sched: sch_multiq: fix possible OOB write in multiq_tune()

Taehee Yoo <ap420073@gmail.com>
    ionic: fix kernel panic in XDP_TX action

Tristram Ha <tristram.ha@microchip.com>
    net: phy: Micrel KSZ8061: fix errata solution not taking effect problem

Wen Gu <guwen@linux.alibaba.com>
    net/smc: avoid overwriting when adjusting sock bufsizes

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Always allocate PF entries from low prioriy zone

Jiri Olsa <jolsa@kernel.org>
    bpf: Set run context for rawtp test_run callback

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix marking packets as decrypted

Eric Dumazet <edumazet@google.com>
    ipv6: sr: block BH in seg6_output_core() and seg6_input_core()

Eric Dumazet <edumazet@google.com>
    ipv6: ioam: block BH from ioam6_output()

Matthias Stocker <mstocker@barracuda.com>
    vmxnet3: disable rx data ring on dma allocation failure

Ravi Bangoria <ravi.bangoria@amd.com>
    KVM: SEV-ES: Delegate LBR virtualization to the processor

Ravi Bangoria <ravi.bangoria@amd.com>
    KVM: SEV-ES: Disallow SEV-ES guests when X86_FEATURE_LBRV is absent

Cong Wang <cong.wang@bytedance.com>
    bpf: Fix a potential use-after-free in bpf_link_free()

Tristram Ha <tristram.ha@microchip.com>
    net: phy: micrel: fix KSZ9477 PHY issues after suspend/resume

DelphineCCChiu <delphine_cc_chiu@wiwynn.com>
    net/ncsi: Fix the multi thread manner of NCSI driver

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Replace kfree() in ax25_dev_free() with ax25_dev_put()

Lars Kellogg-Stedman <lars@oddbit.com>
    ax25: Fix refcount imbalance on inbound connections

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: fix possible dim status unrecoverable

Quan Zhou <zhouquan@iscas.ac.cn>
    RISC-V: KVM: Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext function

Yong-Xuan Wang <yongxuan.wang@sifive.com>
    RISC-V: KVM: No need to use mask when hart-index-bit is 0

Chanwoo Lee <cw9316.lee@samsung.com>
    scsi: ufs: mcq: Fix error output and clean up ufshcd_mcq_abort()

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: mac80211: correctly parse Spatial Reuse Parameter Set element

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: mac80211: fix Spatial Reuse element size check

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't read past the mfuart notifcation

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: check n_ssids before accessing the ssids

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    wifi: iwlwifi: dbg_ini: move iwl_dbg_tlv_free outside of debugfs ifdef

Mordechay Goodstein <mordechay.goodstein@intel.com>
    wifi: iwlwifi: mvm: set properly mac header

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: revert gen2 TX A-MPDU size to 64

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: don't initialize csa_work twice

Aditya Kumar Singh <quic_adisi@quicinc.com>
    wifi: mac80211: pass proper link id for channel switch started notification

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

Arnd Bergmann <arnd@arndb.de>
    cpufreq: amd-pstate: remove global header file

Perry Yuan <perry.yuan@amd.com>
    cpufreq: amd-pstate: Add quirk for the pstate CPPC capabilities missing

Perry Yuan <perry.yuan@amd.com>
    cpufreq: amd-pstate: Unify computation of {max,min,nominal,lowest_nonlinear}_freq

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: move power type check to ASSOC stage when connecting to 6 GHz AP

Carl Huang <quic_cjhuang@quicinc.com>
    wifi: ath11k: fix WCN6750 firmware crash caused by 17 num_vdevs


-------------

Diffstat:

 .editorconfig                                      |   3 -
 .../devicetree/bindings/usb/realtek,rts5411.yaml   |   1 +
 MAINTAINERS                                        |   1 -
 Makefile                                           |   4 +-
 arch/parisc/include/asm/cacheflush.h               |  15 +-
 arch/parisc/include/asm/pgtable.h                  |  27 +-
 arch/parisc/kernel/cache.c                         | 421 +++++++++++++--------
 arch/powerpc/include/asm/uaccess.h                 |  16 +
 arch/powerpc/platforms/85xx/smp.c                  |   9 +-
 arch/riscv/kvm/aia_device.c                        |   7 +-
 arch/riscv/kvm/vcpu_onereg.c                       |   4 +-
 arch/riscv/mm/init.c                               |  24 +-
 arch/riscv/mm/pageattr.c                           |  28 +-
 arch/x86/boot/compressed/Makefile                  |   4 +-
 arch/x86/boot/main.c                               |   4 +-
 arch/x86/include/asm/alternative.h                 |  22 +-
 arch/x86/include/asm/atomic64_32.h                 |   2 +-
 arch/x86/include/asm/cpufeature.h                  |   2 +-
 arch/x86/include/asm/irq_stack.h                   |   2 +-
 arch/x86/include/asm/uaccess.h                     |   6 +-
 arch/x86/kernel/amd_nb.c                           |   9 +-
 arch/x86/kernel/cpu/common.c                       |  21 +-
 arch/x86/kernel/machine_kexec_64.c                 |  11 +-
 arch/x86/kvm/svm/sev.c                             |  19 +-
 arch/x86/kvm/svm/svm.c                             |  24 +-
 arch/x86/kvm/svm/svm.h                             |   4 +-
 arch/x86/lib/getuser.S                             |   6 +-
 arch/x86/mm/numa.c                                 |   6 +-
 block/blk-flush.c                                  |   3 +-
 block/sed-opal.c                                   |   2 +-
 drivers/acpi/thermal.c                             |   8 +-
 drivers/acpi/x86/utils.c                           |  24 +-
 drivers/ata/ahci.c                                 |   1 -
 drivers/ata/libata-core.c                          |   9 +-
 drivers/ata/libata-scsi.c                          |   8 +-
 drivers/base/core.c                                |   3 +
 drivers/block/null_blk/zoned.c                     |   2 +-
 drivers/clk/sifive/sifive-prci.c                   |   8 -
 drivers/cpufreq/amd-pstate-ut.c                    |   3 +-
 drivers/cpufreq/amd-pstate.c                       | 209 ++++++----
 {include/linux => drivers/cpufreq}/amd-pstate.h    |  27 --
 drivers/cxl/core/region.c                          |  18 +-
 drivers/dma-buf/st-dma-fence.c                     |   6 +
 drivers/dma/dma-axi-dmac.c                         |   2 +-
 drivers/gpio/Kconfig                               |   2 +-
 drivers/gpio/gpio-tqmx86.c                         | 110 ++++--
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   2 +-
 .../drm/arm/display/komeda/komeda_pipeline_state.c |   2 +-
 drivers/gpu/drm/bridge/panel.c                     |   7 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   4 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c             |   3 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   7 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   7 +-
 drivers/gpu/drm/i915/display/intel_audio.c         |  32 +-
 drivers/gpu/drm/i915/display/intel_audio.h         |   1 +
 .../gpu/drm/i915/display/intel_display_driver.c    |   2 +
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.h         |   4 +-
 drivers/gpu/drm/i915/gt/intel_breadcrumbs.c        |  15 +-
 drivers/gpu/drm/nouveau/dispnv04/disp.c            |   2 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |   6 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |   1 +
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c     |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |   7 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |   3 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  28 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |  45 ++-
 drivers/gpu/drm/xe/xe_gt_idle.c                    |   9 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   4 +
 drivers/gpu/drm/xe/xe_guc_pc.c                     |  70 +---
 drivers/gpu/drm/xe/xe_guc_submit.c                 |   1 +
 drivers/gpu/drm/xe/xe_ring_ops.c                   |  18 +-
 drivers/greybus/interface.c                        |   1 +
 drivers/hid/hid-core.c                             |   1 -
 drivers/hid/hid-logitech-dj.c                      |   4 +-
 drivers/hid/hid-nvidia-shield.c                    |   4 +-
 drivers/hwtracing/intel_th/pci.c                   |  25 ++
 drivers/i2c/busses/i2c-at91-slave.c                |   3 +-
 drivers/i2c/busses/i2c-designware-slave.c          |   2 +-
 drivers/iio/adc/ad9467.c                           |   4 +-
 drivers/iio/adc/adi-axi-adc.c                      |   5 +
 .../iio/common/inv_sensors/inv_sensors_timestamp.c |  15 +-
 drivers/iio/dac/ad5592r-base.c                     |   2 +-
 drivers/iio/imu/bmi323/bmi323_core.c               |   5 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c  |   4 -
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c   |   4 -
 drivers/iio/pressure/bmp280-core.c                 |  10 +-
 drivers/iio/temperature/mcp9600.c                  |   3 +-
 drivers/iio/temperature/mlx90635.c                 |   6 +-
 drivers/iommu/amd/init.c                           |   9 +
 drivers/irqchip/irq-gic-v3-its.c                   |  44 +--
 drivers/irqchip/irq-sifive-plic.c                  |  34 +-
 drivers/leds/led-class.c                           |   6 -
 drivers/md/dm-integrity.c                          |   1 +
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gp.c      |   9 +-
 drivers/misc/mei/pci-me.c                          |   4 +-
 drivers/misc/mei/platform-vsc.c                    |  39 +-
 drivers/misc/mei/vsc-fw-loader.c                   |   2 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   6 +-
 drivers/net/dsa/qca/qca8k-leds.c                   |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  51 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |  12 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c  |  11 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |   8 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |  20 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   4 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  21 +-
 drivers/net/ethernet/intel/ice/ice.h               |  44 ++-
 drivers/net/ethernet/intel/ice/ice_base.c          |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  29 +-
 drivers/net/ethernet/intel/ice/ice_main.c          | 144 ++++---
 drivers/net/ethernet/intel/ice/ice_nvm.c           | 116 +++++-
 drivers/net/ethernet/intel/ice/ice_type.h          |  14 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  13 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   9 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  33 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 106 ++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   8 +
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   8 +-
 .../net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c  |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   4 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   1 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   4 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  25 +-
 drivers/net/geneve.c                               |  10 +-
 drivers/net/netdevsim/netdev.c                     |   3 +-
 drivers/net/phy/micrel.c                           | 104 ++++-
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/virtio_net.c                           |   2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   2 +-
 drivers/net/wireless/ath/ath11k/core.c             |   2 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  38 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  30 ++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |   2 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   4 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |  15 -
 drivers/net/wwan/iosm/iosm_ipc_devlink.c           |   2 +-
 drivers/nvme/host/pr.c                             |   2 +-
 drivers/nvme/target/passthru.c                     |   6 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   6 +-
 drivers/platform/x86/dell/dell-smbios-base.c       |  92 ++---
 drivers/pmdomain/ti/ti_sci_pm_domains.c            |  20 +-
 drivers/ptp/ptp_chardev.c                          |   3 +-
 drivers/ras/amd/atl/internal.h                     |   2 +-
 drivers/ras/amd/atl/system.c                       |   2 +-
 drivers/ras/amd/atl/umc.c                          | 160 +++++---
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |  58 ++-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |  62 +++
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  19 +
 drivers/scsi/mpt3sas/mpt3sas_base.h                |   3 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  23 --
 drivers/scsi/scsi.c                                |   7 +
 drivers/scsi/scsi_transport_sas.c                  |  23 ++
 drivers/scsi/sd.c                                  |  17 +-
 drivers/spmi/hisi-spmi-controller.c                |   1 -
 drivers/thermal/thermal_core.c                     |  13 +-
 drivers/thunderbolt/debugfs.c                      |   5 +-
 drivers/tty/n_tty.c                                |  22 +-
 drivers/tty/serial/8250/8250_dw.c                  |   9 +-
 drivers/tty/serial/8250/8250_dwlib.c               |   3 +-
 drivers/tty/serial/8250/8250_dwlib.h               |   3 +-
 drivers/tty/serial/8250/8250_pxa.c                 |   1 +
 drivers/tty/serial/serial_port.c                   |   7 +
 drivers/ufs/core/ufs-mcq.c                         |  17 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/usb/Makefile                               |   1 +
 drivers/usb/class/cdc-wdm.c                        |   4 +-
 drivers/usb/core/hcd.c                             |  12 +-
 drivers/usb/host/xhci-pci.c                        |   7 +
 drivers/usb/host/xhci-ring.c                       |  59 ++-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/usb/storage/alauda.c                       |   9 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   5 +-
 fs/btrfs/zoned.c                                   |  13 +-
 fs/cachefiles/daemon.c                             |   3 +-
 fs/cachefiles/internal.h                           |   5 +
 fs/cachefiles/ondemand.c                           | 165 +++++---
 fs/jfs/xattr.c                                     |   4 +-
 fs/nfs/dir.c                                       |  47 ++-
 fs/nfs/nfs4proc.c                                  |  23 +-
 fs/nfsd/nfsfh.c                                    |   4 +-
 fs/ocfs2/file.c                                    |   2 +
 fs/ocfs2/namei.c                                   |   4 +-
 fs/proc/vmcore.c                                   |   2 +
 fs/smb/server/smb2pdu.c                            |  22 +-
 fs/smb/server/vfs.c                                |  17 +-
 fs/smb/server/vfs.h                                |   3 +-
 fs/smb/server/vfs_cache.c                          |   3 +-
 fs/tracefs/event_inode.c                           |  59 ++-
 include/drm/bridge/aux-bridge.h                    |   2 +-
 include/drm/display/drm_dp_mst_helper.h            |   1 -
 include/linux/atomic/atomic-arch-fallback.h        |   6 +-
 include/linux/atomic/atomic-instrumented.h         |   8 +-
 include/linux/atomic/atomic-long.h                 |   4 +-
 include/linux/io_uring_types.h                     |   3 +-
 include/linux/iommu.h                              |   2 +-
 include/linux/kcov.h                               |  47 ++-
 include/linux/kexec.h                              |   6 +-
 include/linux/pse-pd/pse.h                         |   4 +-
 include/net/bluetooth/hci_core.h                   |  36 +-
 include/net/ip_tunnels.h                           |   5 +-
 include/net/rtnetlink.h                            |   1 +
 include/scsi/scsi_transport_sas.h                  |   2 +
 include/trace/events/cachefiles.h                  |   8 +-
 io_uring/cancel.h                                  |   4 +-
 io_uring/io-wq.c                                   |  57 +--
 io_uring/io_uring.c                                |   1 +
 io_uring/rsrc.c                                    |   1 +
 kernel/bpf/syscall.c                               |  11 +-
 kernel/events/core.c                               |  13 +
 kernel/gen_kheaders.sh                             |   2 +-
 kernel/pid_namespace.c                             |   1 +
 kernel/time/tick-common.c                          |  42 +-
 mm/memblock.c                                      |   4 +
 mm/memory-failure.c                                |   7 +
 net/ax25/af_ax25.c                                 |   6 +
 net/ax25/ax25_dev.c                                |   2 +-
 net/bluetooth/hci_sync.c                           |   2 +-
 net/bluetooth/l2cap_core.c                         |  12 +-
 net/bpf/test_run.c                                 |   6 +
 net/bridge/br_mst.c                                |  13 +-
 net/core/rtnetlink.c                               |  44 ++-
 net/core/sock_map.c                                |  16 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/fib_frontend.c                            |   7 +-
 net/ipv4/tcp.c                                     |   9 +-
 net/ipv4/tcp_timer.c                               |   6 +-
 net/ipv6/ioam6_iptunnel.c                          |   8 +-
 net/ipv6/ip6_fib.c                                 |   6 +-
 net/ipv6/route.c                                   |   5 +-
 net/ipv6/seg6_iptunnel.c                           |  14 +-
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/mac80211/cfg.c                                 |   4 +-
 net/mac80211/he.c                                  |  10 +-
 net/mac80211/mesh_pathtbl.c                        |  13 +
 net/mac80211/parse.c                               |   2 +-
 net/mac80211/sta_info.c                            |   4 +-
 net/mptcp/pm_netlink.c                             |  21 +-
 net/mptcp/protocol.c                               |  10 +-
 net/ncsi/internal.h                                |   2 +
 net/ncsi/ncsi-manage.c                             |  75 ++--
 net/ncsi/ncsi-rsp.c                                |   4 +-
 net/netfilter/ipset/ip_set_core.c                  |  93 +++--
 net/netfilter/ipset/ip_set_list_set.c              |  30 +-
 net/netfilter/nft_meta.c                           |   3 +
 net/netfilter/nft_payload.c                        |   4 +
 net/sched/sch_generic.c                            |   1 +
 net/sched/sch_multiq.c                             |   2 +-
 net/sched/sch_taprio.c                             |  15 +-
 net/smc/af_smc.c                                   |  22 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   4 +-
 net/unix/af_unix.c                                 | 108 +++---
 net/unix/diag.c                                    |  12 +-
 net/wireless/core.c                                |   2 +-
 net/wireless/pmsr.c                                |   8 +-
 net/wireless/scan.c                                |   3 +-
 net/wireless/sysfs.c                               |   4 +-
 net/wireless/util.c                                |   7 +-
 scripts/atomic/kerneldoc/sub_and_test              |   2 +-
 scripts/mod/modpost.c                              |   5 +-
 security/integrity/ima/ima_api.c                   |  16 +-
 security/integrity/ima/ima_template_lib.c          |  17 +-
 security/landlock/fs.c                             |  13 +-
 tools/perf/builtin-script.c                        |   2 +-
 tools/perf/util/auxtrace.c                         |   4 +-
 tools/testing/cxl/test/mem.c                       |   1 +
 tools/testing/selftests/alsa/Makefile              |   2 +-
 .../ftrace/test.d/dynevent/test_duplicates.tc      |   2 +-
 .../ftrace/test.d/filter/event-filter-function.tc  |  20 +-
 .../ftrace/test.d/kprobe/kprobe_eventname.tc       |   3 +-
 .../selftests/futex/functional/futex_requeue_pi.c  |   2 +-
 tools/testing/selftests/mm/compaction_test.c       |  77 ++--
 tools/testing/selftests/mm/cow.c                   |   2 +-
 tools/testing/selftests/mm/gup_longterm.c          |   2 +-
 tools/testing/selftests/mm/gup_test.c              |   4 +-
 tools/testing/selftests/mm/ksm_functional_tests.c  |   2 +-
 tools/testing/selftests/mm/madv_populate.c         |   2 +-
 tools/testing/selftests/mm/mkdirty.c               |   2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |   4 +-
 tools/testing/selftests/mm/soft-dirty.c            |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   5 +-
 tools/tracing/rtla/src/timerlat_aa.c               | 109 +++---
 tools/tracing/rtla/src/timerlat_top.c              |  17 +-
 299 files changed, 3209 insertions(+), 1761 deletions(-)


