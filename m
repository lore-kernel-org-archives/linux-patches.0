Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B82FDC32;
	Tue, 12 Aug 2025 17:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020261; cv=none; b=TNpkCXpVLNt/7rwNqGgNfxg0rychlGXiC4R4DB31CaOmvkxfpxPo8XS0id5cS+L5Az4Fr6gDuNZT/Fg/vlVJDLV13ceLLDupESwk9ZbPuJ5UdN5rvXhDoRgVgsqr+Egwr+DaYvjwskeEnDBZ6ipUMUw2j6GjzjpK62zbYFct3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020261; c=relaxed/simple;
	bh=be+gABjQ1Kqvb0ryt9ggTAVG8L4LCd23lvmN2zjagYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZJd/UgCCKol1PrLAUHeCiwGy6eSii4coHablEUaUU/UyPZa6xHc6AraltC6gpvshctrT2Gv3azbqF+vDfIcNKnE0YXy4tL//spAFB2DEQFRsXR5qG7hJYhuL0XVlGnuzqzdujS5b07OMq3IRzLjLQEC7pmCkRDjAU7nZrr89kYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWSigUkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWSigUkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5910BC4CEF0;
	Tue, 12 Aug 2025 17:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020261;
	bh=be+gABjQ1Kqvb0ryt9ggTAVG8L4LCd23lvmN2zjagYE=;
	h=From:To:Cc:Subject:Date:From;
	b=BWSigUkZ0eJIdxChFUyRNNf9N8rwt3zUcNkXsQzsZ3SbW9J8VdEFr48JRbIrfxZol
	 ZAzOSpLrCD26819zByy2X+wQTEwRdKGOq98JBG9Wa7I0o3ekdcCJFxOvFi1NAAeukf
	 T+FZ+ye41a3i3yQRa/6nXgU5zHkh/mFMOBpzXnCg=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.1 000/253] 6.1.148-rc1 review
Date: Tue, 12 Aug 2025 19:26:28 +0200
Message-ID: <20250812172948.675299901@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.148-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.148-rc1
X-KernelTest-Deadline: 2025-08-14T17:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.148 release.
There are 253 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.148-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.148-rc1

Tao Xue <xuetao09@huawei.com>
    usb: gadget : fix use-after-free in composite_dev_cleanup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mm: tlb-r4k: Uniquify TLB entries on init

Dave Hansen <dave.hansen@linux.intel.com>
    x86/fpu: Delay instruction pointer fixup until after warning

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()

Thorsten Blum <thorsten.blum@linux.dev>
    ALSA: intel_hdmi: Fix off-by-one error in __hdmi_lpe_audio_probe()

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Evict cache lines during SNP memory validation

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    net: usbnet: Fix the wrong netif_carrier_on() call

John Ernberg <john.ernberg@actia.se>
    net: usbnet: Avoid potential RCU stall on LINK_CHANGE event

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W709

Thorsten Blum <thorsten.blum@linux.dev>
    smb: server: Fix extension string in ksmbd_extract_shortname()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limit repeated connections from clients with the same IP

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix corrupted mtime and ctime in smb2_open

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix Preauh_HashValue race condition

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference error in generate_encryptionkey

Budimir Markovic <markovicbudimir@gmail.com>
    vsock: Do not allow binding to VMADDR_PORT_ANY

Quang Le <quanglex97@gmail.com>
    net/packet: fix a race in packet_set_ring() and packet_notifier()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    selftests/perf_events: Add a mmap() correctness test

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Prevent VMA split of buffer mappings

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Exit early on perf_mmap() fail

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Don't leak AUX buffer refcount on allocation failure

Eric Dumazet <edumazet@google.com>
    pptp: fix pptp_xmit() error path

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() cleanup before notifying the callers.

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() avoid touching data_transfer after cleanup/move

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() consistently call put_recvmsg/smb_direct_disconnect_rdma_connection

Stefan Metzmacher <metze@samba.org>
    smb: server: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already

Stefan Metzmacher <metze@samba.org>
    smb: server: remove separate empty_recvmsg_queue

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()

Arnd Bergmann <arnd@arndb.de>
    irqchip: Build IMX_MU_MSI only on ARM

Michal Schmidt <mschmidt@redhat.com>
    benet: fix BUG when creating VFs

Wang Liang <wangliang74@huawei.com>
    net: drop UFO packets in udp_rcv_segment()

Eric Dumazet <edumazet@google.com>
    ipv6: reject malicious packets in ipv6_gso_segment()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_segs when LRO is used

Eric Dumazet <edumazet@google.com>
    pptp: ensure minimal skb length in pptp_xmit()

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix parsing of unicast frames

Jakub Kicinski <kuba@kernel.org>
    netpoll: prevent hanging NAPI when netcons gets enabled

Benjamin Coddington <bcodding@redhat.com>
    NFS: Fixup allocation flags for nfsiod's __GFP_NORETRY

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: another fix for listxattr

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()

NeilBrown <neilb@suse.de>
    sched: Add test_and_clear_wake_up_bit() and atomic_dec_and_wake_up()

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    pNFS/flexfiles: don't attempt pnfs on fatal DS errors

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Fix surprise plug detection and recovery

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Make EEH driver device hotplug safe

Maciej W. Rozycki <macro@orcam.me.uk>
    powerpc/eeh: Rely on dev->link_active_reporting

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Export eeh_unfreeze_pe()

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Work around switches with broken presence detection

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Clean up allocated IRQs on unplug

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix ConfigList::updateListAllforAll()

Salomon Dushimirimana <salomondush@google.com>
    scsi: sd: Make sd shutdown issue START STOP UNIT appropriately

Seunghui Lee <sh043.lee@samsung.com>
    scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume

Li Lingfeng <lilingfeng3@huawei.com>
    scsi: Revert "scsi: iscsi: Fix HW conn removal use after free"

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Fix a fw_event memory leak

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Separate SR-IOV VF dev_set

Chao Yu <chao@kernel.org>
    f2fs: fix to calculate dirty data during has_not_enough_free_secs()

Chao Yu <chao@kernel.org>
    f2fs: fix to update upper_p in __get_secs_required() correctly

Jan Prusakowski <jprusakowski@google.com>
    f2fs: vm_unmap_ram() may be called from an invalid context

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in devs.path

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid panic in f2fs_evict_inode

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_sync_inode_meta()

Chao Yu <chao@kernel.org>
    f2fs: doc: fix wrong quota mount option description

Abinash Singh <abinashlalotra@gmail.com>
    f2fs: fix KMSAN uninit-value in extent_info usage

Brian Masney <bmasney@redhat.com>
    rtc: rv3028: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: pcf8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: pcf85063: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: nct3018y: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: hym8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: ds1307: fix incorrect maximum clock rate handling

Uros Bizjak <ubizjak@gmail.com>
    ucount: fix atomic_long_inc_below() argument type

Petr Pavlu <petr.pavlu@suse.com>
    module: Restore the moduleparam prefix length check

Ryan Lee <ryan.lee@canonical.com>
    apparmor: ensure WB_HISTORY_SIZE value is a power of 2

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Check flow_dissector ctx accesses are aligned

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Fix log flooding with target does not exist errors

Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
    mtd: rawnand: atmel: set pmecc data setup time

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: rockchip: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: atmel: Fix dma_mapping_error() address

Zheng Yu <zheng.yu@northwestern.edu>
    jfs: fix metapage reference count leak in dbAllocCtl

Chenyuan Yang <chenyuan0y@gmail.com>
    fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix seq_file position update in adf_ring_next()

Ben Hutchings <benh@debian.org>
    sh: Do not use hyphen in exported variable name

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: nbpfaxi: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: mv_xor: Fix missing check after DMA map and missing unmap

Dan Carpenter <dan.carpenter@linaro.org>
    fs/orangefs: Allow 2 more characters in do_c_string()

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-vntb: Fix the incorrect usage of __iomem attribute

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: stream: restore params when prepare ports fail

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: img-hash - Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: keembay - Fix dma_unmap_sg() nents value

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    hwrng: mtk - handle devm_pm_runtime_enable errors

Dan Carpenter <dan.carpenter@linaro.org>
    watchdog: ziirave_wdt: check record length in ziirave_firm_verify()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: isci: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: mvsas: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: elx: efct: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value

Paul Kocialkowski <paulk@sys-base.io>
    clk: sunxi-ng: v3s: Fix de clock definition

Leo Yan <leo.yan@arm.com>
    perf tests bp_account: Fix leaked file descriptor

wangzijie <wangzijie1@honor.com>
    proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al

Arnd Bergmann <arnd@arndb.de>
    kernel: trace: preemptirq_delay_test: use offstack cpu mask

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix -Wframe-larger-than issue

Mengbiao Xiong <xisme1998@gmail.com>
    crypto: ccp - Fix crash when rebind ccp device for ccp.ko

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: inside-secure - Fix `dma_unmap_sg()` nents value

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks in 'perf sched latency'

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks for evsel->priv in timehist

Nuno Sá <nuno.sa@analog.com>
    clk: clk-axi-clkgen: fix fpfd_max frequency for zynq

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: sunxi: Fix memory leak on krealloc failure

Jerome Brunet <jbrunet@baylibre.com>
    PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails

Arnd Bergmann <arnd@arndb.de>
    crypto: arm/aes-neonbs - work around gcc-15 warning

Charles Han <hanchunchao@inspur.com>
    power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set

Charles Han <hanchunchao@inspur.com>
    power: supply: cpcap-charger: Fix null check for power_supply_get_by_name

Rohit Visavalia <rohit.visavalia@amd.com>
    clk: xilinx: vcu: unregister pll_post only if registered correctly

James Cowgill <james.cowgill@blaize.com>
    media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check

Henry Martin <bsdhenrymartin@gmail.com>
    clk: davinci: Add NULL check in davinci_lpsc_clk_register()

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: fix possible integer overflow in erase_xfer()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Fix engine load inaccuracy

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - fix nents passed to dma_unmap_sg()

Hans Zhang <18255117159@163.com>
    PCI: rockchip-host: Fix "Unexpected Completion" log message

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf/preload: Don't select USERMODE_DRIVER

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-races around rt->fib6_nsiblings

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible infinite loop in fib6_info_uses_dev()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent infinite loop in rt6_nlmsg_size()

Stanislav Fomichev <sdf@fomichev.me>
    vrf: Drop existing dst reference in vrf_ip6_input_dst

Xiumei Mu <xmu@redhat.com>
    selftests: rtnetlink.sh: remove esp4_offload after test

Florian Westphal <fw@strlen.de>
    netfilter: xt_nfacct: don't assume acct name is null-terminated

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Assign netdev.dev_port based on device channel index

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Store device channel index

Stephane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix USB FD devices potential malfunction

Marco Elver <elver@google.com>
    kcsan: test: Initialize dummy variable

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE

Remi Pommarel <repk@triplefau.lt>
    Reapply "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Don't call fq_flow_idx() for management frames

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Do not schedule stopped TXQs

Murad Masimov <m.masimov@mt-integration.ru>
    wifi: plfxlc: Fix error handling in usb driver probe

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    wifi: mac80211: reject TDLS operations when station is not associated

Thomas Fourier <fourier.thomas@gmail.com>
    mwl8k: Add missing check after DMA map

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: Fix RX skb size for aggregation disabled

Juergen Gross <jgross@suse.com>
    xen/gntdev: remove struct gntdev_copy_batch from stack

Eric Dumazet <edumazet@google.com>
    net_sched: act_ctinfo: use atomic64_t for three counters

William Liu <will@willsroot.io>
    net/sched: Restrict conditions for adding duplicating netems to qdisc tree

Tiwei Bie <tiwei.btw@antgroup.com>
    um: rtc: Avoid shadowing err in uml_rtc_start()

Johan Korsnes <johan.korsnes@gmail.com>
    arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX

Fedor Pchelkin <pchelkin@ispras.ru>
    netfilter: nf_tables: adjust lockdep assertions handling

Shixiong Ou <oushixiong@kylinos.cn>
    fbcon: Fix outdated registered_fb reference in comment

Fedor Pchelkin <pchelkin@ispras.ru>
    drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value

Finn Thain <fthain@linux-m68k.org>
    m68k: Don't unregister boot console needlessly

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix check for setting new VLs in sve-ptrace

Stav Aviram <saviram@nvidia.com>
    net/mlx5: Check device memory pointer before usage

xin.guo <guoxin0309@gmail.com>
    tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range

Sergey Senozhatsky <senozhatsky@chromium.org>
    wifi: ath11k: clear initialized flag for deinit-ed srng lists

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iwlwifi: Add missing check for alloc_ordered_workqueue

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: iwlwifi: Fix memory leak in iwl_mvm_init()

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: rtl818x: Kill URBs before clearing tx status queue

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size, again

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure

Petr Machata <petrm@nvidia.com>
    net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix psock incorrectly pointing to sk

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Fix false failure of subsystem event test

Alok Tiwari <alok.a.tiwari@oracle.com>
    staging: nvec: Fix incorrect null termination of battery manufacturer

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: sc8180x: specify num_nodes

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg

Brahmajit Das <listout@listout.xyz>
    samples: mei: Fix building on musl libc

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Init policy->rwsem before it may be possibly used

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Initialize cpufreq-based frequency-invariance later

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode

Lifeng Zheng <zhenglifeng1@huawei.com>
    PM / devfreq: Check governor before using governor->name

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed

Annette Kobou <annette.kobou@kontron.de>
    ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS

Albin Törnqvist <albin.tornqvist@codiax.se>
    arm: dts: ti: omap: Fixup pinheader typo

Lucas De Marchi <lucas.demarchi@intel.com>
    usb: early: xhci-dbc: Fix early_ioremap leak

Sivan Zohar-Kotzer <sivany32@gmail.com>
    powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "vmci: Prevent the dispatching of uninitialized payloads"

Denis OSTERLAND-HEIM <denis.osterland@diehl.com>
    pps: fix poll support

Lizhi Xu <lizhi.xu@windriver.com>
    vmci: Prevent the dispatching of uninitialized payloads

Abdun Nihaal <abdun.nihaal@gmail.com>
    staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()

Charalampos Mitrodimas <charmitro@posteo.net>
    usb: misc: apple-mfi-fastcharge: Make power supply names unique

Seungjin Bae <eeodqql09@gmail.com>
    usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: vfxxx: Correctly use two tuples for timer address

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc7180: Expand IMEM region

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Expand IMEM region

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    soc: qcom: QMI encoding/decoding for big endian

Dmitry Vyukov <dvyukov@google.com>
    selftests: Fix errno checking in syscall_user_dispatch test

Arnd Bergmann <arnd@arndb.de>
    ASoC: ops: dynamically allocate struct snd_ctl_elem_value

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    Revert "fs/ntfs3: Replace inode_trylock with inode_lock"

Yangtao Li <frank.li@vivo.com>
    hfsplus: remove mutex_lock check in hfsplus_free_extents

Caleb Sander Mateos <csander@purestorage.com>
    ublk: use vmalloc for ublk_device's __queues

RubenKelevra <rubenkelevra@gmail.com>
    fs_context: fix parameter name in infofc() macro

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: fix SND_SOC_SOF dependencies

Adam Queler <queler@gmail.com>
    ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx

Arnd Bergmann <arnd@arndb.de>
    ethernet: intel: fix building with large NR_CPUS

Xu Yang <xu.yang_2@nxp.com>
    usb: phy: mxs: disconnect line when USB charger is attached

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: add USB PHY event

Gao Xiang <xiang@kernel.org>
    erofs: address D-cache aliasing

Gao Xiang <xiang@kernel.org>
    erofs: simplify z_erofs_transform_plain()

Gao Xiang <xiang@kernel.org>
    erofs: drop z_erofs_page_mark_eio()

Gao Xiang <xiang@kernel.org>
    erofs: sunset erofs_dbg()

Gao Xiang <xiang@kernel.org>
    erofs: get rid of debug_one_dentry()

Liu Shixin <liushixin2@huawei.com>
    mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x

Daniel Dadap <ddadap@nvidia.com>
    ALSA: hda: Add missing NVIDIA HDA codec IDs

Mohan Kumar D <mkumard@nvidia.com>
    ALSA: hda/tegra: Add Tegra264 support

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: Fix possible deletion of uninitialized timers

Dmitry Antipov <dmantipov@yandex.ru>
    jfs: reject on-disk inodes of an unsupported type

Michael Zhivich <mzhivich@akamai.com>
    x86/bugs: Fix use of possibly uninit value in amd_check_tsa_microcode()

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow switching to mode accessory to mux properly

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: tcpm: allow to use sink in accessory mode

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Don't call mmput from MMU notifier callback

Harry Yoo <harry.yoo@oracle.com>
    mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover checksum

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: also cover alt modes

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid file types when reading inodes

Marco Elver <elver@google.com>
    kasan: use vmalloc_dump_obj() for vmalloc error reports

Haoxiang Li <haoxiang_li2024@163.com>
    ice: Fix a null pointer dereference in ice_copy_and_init_pkg()

Praveen Kaligineedi <pkaligineedi@google.com>
    gve: Fix stuck TX queue for DQ queue format

Jacek Kowalski <jacek@jacekk.info>
    e1000e: ignore uninitialized checksum word on tgp

Jacek Kowalski <jacek@jacekk.info>
    e1000e: disregard NVM checksum on tgp when valid checksum bit is not set

Ma Ke <make24@iscas.ac.cn>
    dpaa2-switch: Fix device reference count leak in MAC endpoint handling

Ma Ke <make24@iscas.ac.cn>
    dpaa2-eth: Fix device reference count leak in MAC endpoint handling

Dawid Rezler <dawidrezler.patches@gmail.com>
    ALSA: hda/realtek - Add mute LED support for HP Pavilion 15-eg0xxx

Ma Ke <make24@iscas.ac.cn>
    bus: fsl-mc: Fix potential double device reference in fsl_mc_get_endpoint()

Viresh Kumar <viresh.kumar@linaro.org>
    i2c: virtio: Avoid hang by using interruptible completion wait

Akhil R <akhilrajeev@nvidia.com>
    i2c: tegra: Fix reset error handling with ACPI

Yang Xiwen <forbidden405@outlook.com>
    i2c: qup: jump out of the loop in case of timeout

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: Fix kbd backlight not remembered among boots

Jian Shen <shenjian15@huawei.com>
    net: hns3: fixed vf get max channels bug

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: disable interrupt when ptp init failed

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix concurrent setting vlan filter issue

Douglas Anderson <dianders@chromium.org>
    drm/bridge: ti-sn65dsi86: Remove extra semicolon in ti_sn_bridge_probe()

Marc Kleine-Budde <mkl@pengutronix.de>
    can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_restart(): move debug message and stats after successful restart

Marc Kleine-Budde <mkl@pengutronix.de>
    can: dev: can_restart(): reverse logic to remove need for goto

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class

Kito Xu (veritas501) <hxzene@gmail.com>
    net: appletalk: Fix use-after-free in AARP proxy probe

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    i40e: When removing VF MAC filters, only check PF-set MAC

Dennis Chen <dechen@redhat.com>
    i40e: report VF tx_dropped with tx_errors instead of tx_discards

Yajun Deng <yajun.deng@linux.dev>
    i40e: Add rx_missed_errors for buffer exhaustion

Chiara Meiohas <cmeiohas@nvidia.com>
    net/mlx5: Fix memory leak in cmd_exec()

Eyal Birger <eyal.birger@gmail.com>
    xfrm: interface: fix use-after-free after changing collect_md xfrm interface

Stefan Wahren <wahrenst@gmx.net>
    staging: vchiq_arm: Make vchiq_shutdown never fail

Umang Jain <umang.jain@ideasonboard.com>
    staging: vc04_services: Drop VCHIQ_RETRY usage

Umang Jain <umang.jain@ideasonboard.com>
    staging: vc04_services: Drop VCHIQ_ERROR usage

Umang Jain <umang.jain@ideasonboard.com>
    staging: vc04_services: Drop VCHIQ_SUCCESS usage

Nuno Das Neves <nunodasneves@linux.microsoft.com>
    x86/hyperv: Fix usage of cpu_online_mask to get valid cpu

Abdun Nihaal <abdun.nihaal@gmail.com>
    regmap: fix potential memory leak of regmap_bus

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7949: use spi_is_bpw_supported()

Xilin Wu <sophon@radxa.com>
    interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Rate limit GID cache warning messages

Alessandro Carminati <acarmina@redhat.com>
    regulator: core: fix NULL dereference on unbind due to stale coupling data

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    Input: gpio-keys - fix a sleep while atomic with PREEMPT_RT


-------------

Diffstat:

 Documentation/filesystems/f2fs.rst                 |   6 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-boneblack.dts             |   2 +-
 arch/arm/boot/dts/imx6ul-kontron-bl-common.dtsi    |   1 -
 arch/arm/boot/dts/vfxxx.dtsi                       |   2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   2 +-
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   2 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   2 +
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  10 +-
 arch/m68k/Kconfig.debug                            |   2 +-
 arch/m68k/kernel/early_printk.c                    |  42 +--
 arch/m68k/kernel/head.S                            |   8 +-
 arch/mips/mm/tlb-r4k.c                             |  56 +++-
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/kernel/eeh.c                          |   1 +
 arch/powerpc/kernel/eeh_driver.c                   |  48 ++--
 arch/powerpc/kernel/eeh_pe.c                       |  11 +-
 arch/powerpc/kernel/pci-hotplug.c                  |   3 +
 arch/sh/Makefile                                   |  10 +-
 arch/sh/boot/compressed/Makefile                   |   4 +-
 arch/sh/boot/romimage/Makefile                     |   4 +-
 arch/um/drivers/rtc_user.c                         |   2 +-
 arch/x86/boot/compressed/sev.c                     |   7 +
 arch/x86/boot/cpuflags.c                           |  13 +
 arch/x86/hyperv/irqdomain.c                        |   4 +-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/kernel/cpu/amd.c                          |   2 +
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kernel/sev-shared.c                       |  18 ++
 arch/x86/kernel/sev.c                              |  11 +-
 arch/x86/mm/extable.c                              |   5 +-
 drivers/base/regmap/regmap.c                       |   2 +
 drivers/block/ublk_drv.c                           |   4 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  19 +-
 drivers/char/hw_random/mtk-rng.c                   |   4 +-
 drivers/clk/clk-axi-clkgen.c                       |   2 +-
 drivers/clk/davinci/psc.c                          |   5 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +-
 drivers/clk/xilinx/xlnx_vcu.c                      |   4 +-
 drivers/comedi/drivers/comedi_test.c               |   2 +-
 drivers/cpufreq/cpufreq.c                          |  21 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   4 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   3 +
 drivers/crypto/img-hash.c                          |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 drivers/crypto/keembay/keembay-ocs-hcu-core.c      |   8 +-
 drivers/crypto/marvell/cesa/cipher.c               |   4 +-
 drivers/crypto/marvell/cesa/hash.c                 |   5 +-
 .../crypto/qat/qat_common/adf_transport_debug.c    |   4 +-
 drivers/devfreq/devfreq.c                          |  10 +-
 drivers/dma/mv_xor.c                               |  21 +-
 drivers/dma/nbpfaxi.c                              |  13 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  47 ++--
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c    |   2 +-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   6 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |   9 +-
 drivers/i2c/busses/i2c-qup.c                       |   4 +-
 drivers/i2c/busses/i2c-tegra.c                     |  24 +-
 drivers/i2c/busses/i2c-virtio.c                    |  15 +-
 drivers/iio/adc/ad7949.c                           |   7 +-
 drivers/infiniband/core/cache.c                    |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  15 +-
 drivers/infiniband/hw/mlx5/dm.c                    |   2 +-
 drivers/input/keyboard/gpio_keys.c                 |   4 +-
 drivers/interconnect/qcom/sc7280.c                 |   1 +
 drivers/interconnect/qcom/sc8180x.c                |   6 +
 drivers/interconnect/qcom/sc8280xp.c               |   1 +
 drivers/irqchip/Kconfig                            |   1 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   8 +-
 drivers/mtd/ftl.c                                  |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   6 +
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |  15 ++
 drivers/net/can/dev/dev.c                          |  31 ++-
 drivers/net/can/dev/netlink.c                      |  12 +
 drivers/net/can/kvaser_pciefd.c                    |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  17 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  15 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  15 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  67 ++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  36 +--
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   9 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   6 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   2 +
 drivers/net/ethernet/intel/e1000e/nvm.c            |   6 +
 drivers/net/ethernet/intel/fm10k/fm10k.h           |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  18 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   8 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 -
 drivers/net/phy/mscc/mscc_ptp.c                    |   1 +
 drivers/net/phy/mscc/mscc_ptp.h                    |   1 +
 drivers/net/ppp/pptp.c                             |  18 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireless/ath/ath11k/hal.c              |   4 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
 drivers/net/wireless/marvell/mwl8k.c               |   4 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |  11 +-
 drivers/net/wireless/purelifi/plfxlc/mac.h         |   2 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |  29 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   4 +-
 drivers/pci/hotplug/pnv_php.c                      | 235 ++++++++++++++--
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  11 +-
 drivers/platform/x86/ideapad-laptop.c              |   2 +-
 drivers/power/supply/cpcap-charger.c               |   5 +-
 drivers/power/supply/max14577_charger.c            |   4 +-
 drivers/powercap/dtpm_cpu.c                        |   2 +
 drivers/pps/pps.c                                  |  11 +-
 drivers/regulator/core.c                           |   1 +
 drivers/rtc/rtc-ds1307.c                           |   2 +-
 drivers/rtc/rtc-hym8563.c                          |   2 +-
 drivers/rtc/rtc-nct3018y.c                         |   2 +-
 drivers/rtc/rtc-pcf85063.c                         |   2 +-
 drivers/rtc/rtc-pcf8563.c                          |   2 +-
 drivers/rtc/rtc-rv3028.c                           |   2 +-
 drivers/scsi/elx/efct/efct_lio.c                   |   2 +-
 drivers/scsi/ibmvscsi_tgt/libsrp.c                 |   6 +-
 drivers/scsi/isci/request.c                        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   3 +-
 drivers/scsi/mvsas/mv_sas.c                        |   4 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/soc/qcom/qmi_encdec.c                      |  46 +++-
 drivers/soc/tegra/cbb/tegra234-cbb.c               |   2 +
 drivers/soundwire/stream.c                         |   2 +-
 drivers/staging/fbtft/fbtft-core.c                 |   1 +
 drivers/staging/nvec/nvec_power.c                  |   2 +-
 .../vc04_services/bcm2835-audio/bcm2835-vchiq.c    |   4 +-
 .../include/linux/raspberrypi/vchiq.h              |   2 -
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  79 +++---
 .../vc04_services/interface/vchiq_arm/vchiq_core.c | 172 ++++++------
 .../vc04_services/interface/vchiq_arm/vchiq_dev.c  |  36 +--
 .../staging/vc04_services/vchiq-mmal/mmal-vchiq.c  |   4 +-
 drivers/ufs/core/ufshcd.c                          |  10 +-
 drivers/usb/chipidea/ci.h                          |  18 +-
 drivers/usb/chipidea/udc.c                         |  10 +
 drivers/usb/early/xhci-dbc.c                       |   4 +
 drivers/usb/gadget/composite.c                     |   5 +
 drivers/usb/host/xhci-plat.c                       |   2 +-
 drivers/usb/misc/apple-mfi-fastcharge.c            |  24 +-
 drivers/usb/phy/phy-mxs-usb.c                      |   4 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/typec/tcpm/tcpm.c                      |  64 +++--
 drivers/vfio/pci/vfio_pci_core.c                   |   2 +-
 drivers/vhost/scsi.c                               |   4 +-
 drivers/video/fbdev/core/fbcon.c                   |   4 +-
 drivers/video/fbdev/imxfb.c                        |   9 +-
 drivers/watchdog/ziirave_wdt.c                     |   3 +
 drivers/xen/gntdev-common.h                        |   4 +
 drivers/xen/gntdev.c                               |  71 +++--
 fs/erofs/decompressor.c                            |  23 +-
 fs/erofs/dir.c                                     |  17 --
 fs/erofs/inode.c                                   |   3 -
 fs/erofs/internal.h                                |   2 -
 fs/erofs/namei.c                                   |   9 +-
 fs/erofs/zdata.c                                   |  56 ++--
 fs/erofs/zmap.c                                    |   3 -
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/extent_cache.c                             |   2 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/inode.c                                    |  21 +-
 fs/f2fs/segment.h                                  |   5 +-
 fs/hfsplus/extents.c                               |   3 -
 fs/jfs/jfs_dmap.c                                  |   4 +-
 fs/jfs/jfs_imap.c                                  |  13 +-
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/export.c                                    |  11 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  26 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/internal.h                                  |   9 +-
 fs/nfs/nfs4proc.c                                  |  10 +-
 fs/nilfs2/inode.c                                  |   9 +-
 fs/ntfs3/file.c                                    |   5 +-
 fs/orangefs/orangefs-debugfs.c                     |   6 +-
 fs/proc/generic.c                                  |   2 +
 fs/proc/inode.c                                    |   2 +-
 fs/proc/internal.h                                 |   5 +
 fs/smb/client/smbdirect.c                          |  14 +-
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  22 +-
 fs/smb/server/smb_common.c                         |   2 +-
 fs/smb/server/transport_rdma.c                     |  97 +++----
 fs/smb/server/transport_tcp.c                      |  17 ++
 fs/smb/server/vfs.c                                |   3 +-
 include/linux/fs_context.h                         |   2 +-
 include/linux/moduleparam.h                        |   5 +-
 include/linux/pps_kernel.h                         |   1 +
 include/linux/proc_fs.h                            |   1 +
 include/linux/skbuff.h                             |  23 ++
 include/linux/usb/usbnet.h                         |   1 +
 include/linux/wait_bit.h                           |  60 +++++
 include/net/tc_act/tc_ctinfo.h                     |   6 +-
 include/net/udp.h                                  |  24 +-
 kernel/bpf/preload/Kconfig                         |   1 -
 kernel/events/core.c                               |  20 +-
 kernel/kcsan/kcsan_test.c                          |   2 +-
 kernel/trace/preemptirq_delay_test.c               |  13 +-
 kernel/ucount.c                                    |   2 +-
 mm/hmm.c                                           |   2 +-
 mm/kasan/report.c                                  |   4 +-
 mm/khugepaged.c                                    |   4 +-
 mm/zsmalloc.c                                      |   3 +
 net/appletalk/aarp.c                               |  24 +-
 net/caif/cfctrl.c                                  | 294 ++++++++++-----------
 net/core/filter.c                                  |   3 +
 net/core/netpoll.c                                 |   7 +
 net/core/skmsg.c                                   |   7 +
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv6/ip6_fib.c                                 |  24 +-
 net/ipv6/ip6_offload.c                             |   4 +-
 net/ipv6/ip6mr.c                                   |   3 +-
 net/ipv6/route.c                                   |  60 +++--
 net/mac80211/tdls.c                                |   2 +-
 net/mac80211/tx.c                                  |  14 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 net/packet/af_packet.c                             |  12 +-
 net/sched/act_ctinfo.c                             |  19 +-
 net/sched/sch_netem.c                              |  40 +++
 net/sched/sch_qfq.c                                |   7 +-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/xfrm/xfrm_interface_core.c                     |   7 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 scripts/kconfig/qconf.cc                           |   2 +-
 security/apparmor/include/match.h                  |   3 +-
 security/apparmor/match.c                          |   1 +
 sound/pci/hda/hda_tegra.c                          |  51 +++-
 sound/pci/hda/patch_ca0132.c                       |   5 +-
 sound/pci/hda/patch_hdmi.c                         |  20 ++
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/intel/boards/Kconfig                     |   2 +-
 sound/soc/soc-dai.c                                |  16 +-
 sound/soc/soc-ops.c                                |  28 +-
 sound/usb/mixer_scarlett2.c                        |   7 +
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 tools/bpf/bpftool/net.c                            |  15 +-
 tools/perf/builtin-sched.c                         |  39 ++-
 tools/perf/tests/bp_account.c                      |   1 +
 tools/perf/util/evsel.c                            |  11 +
 tools/perf/util/evsel.h                            |   2 +
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   2 +-
 .../ftrace/test.d/event/subsystem-enable.tc        |  28 +-
 tools/testing/selftests/net/mptcp/Makefile         |   3 +-
 .../selftests/net/mptcp/mptcp_connect_checksum.sh  |   5 +
 .../selftests/net/mptcp/mptcp_connect_mmap.sh      |   5 +
 .../selftests/net/mptcp/mptcp_connect_sendfile.sh  |   5 +
 tools/testing/selftests/net/rtnetlink.sh           |   6 +
 tools/testing/selftests/perf_events/.gitignore     |   1 +
 tools/testing/selftests/perf_events/Makefile       |   2 +-
 tools/testing/selftests/perf_events/mmap.c         | 236 +++++++++++++++++
 .../selftests/syscall_user_dispatch/sud_test.c     |  50 ++--
 271 files changed, 2449 insertions(+), 1170 deletions(-)


