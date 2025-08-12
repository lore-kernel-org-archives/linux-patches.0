Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB0E2FD1CE;
	Tue, 12 Aug 2025 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020694; cv=none; b=EUraYdQPFbjEjIvJJx704naGP6VME8JaDgUeE1WAs14ZqOT8biCnWeDMp8s0Q43A5XH87KSQ80QKmyfIDRkzTGgn6cGarpx3B+IswRJkuDIwjvZ71x7+qnrWknCHY06sF/OZBIJWZnsp9LvmnV8LwNtgy/j4BqnNDx9jKRCTey8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020694; c=relaxed/simple;
	bh=4sxPYztIFqjYc8ld/1PetXbwa4YkkyjKUcchq/H8vaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ngDxs7xzH7AyM+OJRCXM7F4xzxOptQN6V23dt4anpnKXcWu8rsIBO4vlEoPokpDKCbmP5VTJ/yFid8V+sjjVWfzSDoP/C9v3L9a5+Q15TFi7LCGzTK20eInDmD40ge+2rauDT8u0Q6+iSWhzXjFoLvF5LKZpMGJneJ+m7zNjUJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK+NwXTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK+NwXTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193EAC4CEF0;
	Tue, 12 Aug 2025 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020694;
	bh=4sxPYztIFqjYc8ld/1PetXbwa4YkkyjKUcchq/H8vaE=;
	h=From:To:Cc:Subject:Date:From;
	b=iK+NwXTaoDQ3qmJAlrYufWv1dSEACYPFIxSR4z3BTDlxgKrWJnJgDAwZGtpVJdrbI
	 TphiJ/NjYTdw/T6ppfouqF6ygNryr6zJeYgo2ytuF5CkxF//eh2WBxYccTPkJ54gWk
	 UcoFIKgjk9sp7snnH+d9ZcfFM4Frd3b8wt2kyQ1A=
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
Subject: [PATCH 6.6 000/262] 6.6.102-rc1 review
Date: Tue, 12 Aug 2025 19:26:28 +0200
Message-ID: <20250812172952.959106058@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.102-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.102-rc1
X-KernelTest-Deadline: 2025-08-14T17:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.102 release.
There are 262 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Aug 2025 17:27:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.102-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.102-rc1

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

Zenm Chen <zenmchen@gmail.com>
    Bluetooth: btusb: Add USB ID 3625:010b for TP-LINK Archer TX10UB Nano

Chen Ridong <chenridong@huawei.com>
    sched,freezer: Remove unnecessary warning in __thaw_task

Elliot Berman <quic_eberman@quicinc.com>
    freezer,sched: Clean saved_state when restoring it during thaw

Elliot Berman <quic_eberman@quicinc.com>
    freezer,sched: Do not restore saved_state of a thawed task

Elliot Berman <quic_eberman@quicinc.com>
    freezer,sched: Use saved_state to reduce some spurious wakeups

Elliot Berman <quic_eberman@quicinc.com>
    sched/core: Remove ifdeffery for saved_state

Clément Le Goffic <clement.legoffic@foss.st.com>
    i2c: stm32f7: unmap DMA mapped buffer

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: simplify status messages in case of errors

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: perform most of irq job in threaded handler

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: use dev_err_probe upon calls of devm_request_irq

Andi Shyti <andi.shyti@kernel.org>
    i2c: stm32f7: Use devm_clk_get_enabled()

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

Olga Kornievskaia <okorniev@redhat.com>
    sunrpc: fix handling of server side tls alerts

Stefan Metzmacher <metze@samba.org>
    smb: client: return an error if rdma_connect does not return within 5 seconds

Eric Dumazet <edumazet@google.com>
    pptp: fix pptp_xmit() error path

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() cleanup before notifying the callers.

Stefan Metzmacher <metze@samba.org>
    smb: client: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already

Stefan Metzmacher <metze@samba.org>
    smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of common smbdirect_socket

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: add smbdirect_socket.h

Shen Lichuan <shenlichuan@vivo.com>
    smb: client: Correct typos in multiple comments across various files

Shen Lichuan <shenlichuan@vivo.com>
    smb: client: Use min() macro

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

Maher Azzouzi <maherazz04@gmail.com>
    net/sched: mqprio: fix stack out-of-bounds write in tc entry parsing

Michal Schmidt <mschmidt@redhat.com>
    benet: fix BUG when creating VFs

Olga Kornievskaia <okorniev@redhat.com>
    sunrpc: fix client side handling of tls alerts

Takamitsu Iwai <takamitz@amazon.co.jp>
    net/sched: taprio: enforce minimum value for picos_per_byte

Wang Liang <wangliang74@huawei.com>
    net: drop UFO packets in udp_rcv_segment()

Eric Dumazet <edumazet@google.com>
    ipv6: reject malicious packets in ipv6_gso_segment()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_segs when LRO is used

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: ethtool: fix module EEPROM input/output arguments

Eric Dumazet <edumazet@google.com>
    pptp: ensure minimal skb length in pptp_xmit()

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: add IPA v5.1 and v5.5 to ipa_version_string()

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix parsing of unicast frames

Jakub Kicinski <kuba@kernel.org>
    netpoll: prevent hanging NAPI when netcons gets enabled

Heming Zhao <heming.zhao@suse.com>
    md/md-cluster: handle REMOVE message earlier

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

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Export eeh_unfreeze_pe()

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Work around switches with broken presence detection

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Clean up allocated IRQs on unplug

Peter Zijlstra <peterz@infradead.org>
    sched/psi: Fix psi_seq initialization

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

Brett Creeley <brett.creeley@amd.com>
    vfio/pds: Fix missing detach_ioas op

Jacob Pan <jacob.pan@linux.microsoft.com>
    vfio: Prevent open_count decrement to negative

Jacob Pan <jacob.pan@linux.microsoft.com>
    vfio: Fix unbalanced vfio_df_close call in no-iommu mode

Chao Yu <chao@kernel.org>
    f2fs: fix to trigger foreground gc during f2fs_map_blocks() in lfs mode

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
    apparmor: fix loop detection used in conflicting attachment resolution

Ryan Lee <ryan.lee@canonical.com>
    apparmor: ensure WB_HISTORY_SIZE value is a power of 2

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Check netfilter ctx accesses are aligned

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

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix DMA direction for compression on GEN2 devices

Chen Pei <cp0613@linux.alibaba.com>
    perf tools: Remove libtraceevent in .gitignore

Ben Hutchings <benh@debian.org>
    sh: Do not use hyphen in exported variable name

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: get channel status data when PHY is not exists

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

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    pinmux: fix race causing mux_owner NULL with active mux_usecount

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

Namhyung Kim <namhyung@kernel.org>
    perf sched: Free thread->priv using priv_destructor

Ian Rogers <irogers@google.com>
    perf dso: Add missed dso__put to dso__load_kcore

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix use-after-free in help_unknown_cmd()

Thomas Fourier <fourier.thomas@gmail.com>
    Fix dma_unmap_sg() nents value

Nuno Sá <nuno.sa@analog.com>
    clk: clk-axi-clkgen: fix fpfd_max frequency for zynq

Amir Goldstein <amir73il@gmail.com>
    fanotify: sanitize handle_type values when reporting fid

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

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - use unmanaged allocation for dc_data

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

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove skb secpath if xfrm state is not found

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Clear Read-Only port buffer size in PBMC before update

Florian Westphal <fw@strlen.de>
    netfilter: xt_nfacct: don't assume acct name is null-terminated

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Assign netdev.dev_port based on device channel index

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Store device channel index

Stephane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix USB FD devices potential malfunction

Gabriele Monaco <gmonaco@redhat.com>
    tools/rv: Do not skip idle in trace

Kuniyuki Iwashima <kuniyu@google.com>
    bpf: Disable migration in nf_hook_run_bpf().

Chris Down <chris@chrisdown.name>
    Bluetooth: hci_event: Mask data status from LE ext adv reports

Marco Elver <elver@google.com>
    kcsan: test: Initialize dummy variable

Kees Cook <kees@kernel.org>
    wifi: mac80211: Write cnt before copying in ieee80211_copy_rnr_beacon()

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: fix endianness handling while accessing wmi service bit

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

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/amd: Fix geometry.aperture_end for V2 tables

Thomas Fourier <fourier.thomas@gmail.com>
    mwl8k: Add missing check after DMA map

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: Fix RX skb size for aggregation disabled

Eric Dumazet <edumazet@google.com>
    tcp: call tcp_measure_rcv_mss() for ooo packets

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

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Drop dead code from fill_*_info routines

Shixiong Ou <oushixiong@kylinos.cn>
    fbcon: Fix outdated registered_fb reference in comment

Peter Zijlstra <peterz@infradead.org>
    sched/psi: Optimize psi_group_change() cpu_clock() usage

Fedor Pchelkin <pchelkin@ispras.ru>
    drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value

Finn Thain <fthain@linux-m68k.org>
    m68k: Don't unregister boot console needlessly

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dpu: Fill in min_prefill_lines for SC8180X

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix check for setting new VLs in sve-ptrace

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->output

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->input

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

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: avoid NULL dereference when RX problematic packet on unsupported 6 GHz band

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size, again

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Host-Backed userspace on Guest-Backed kernel

Petr Machata <petrm@nvidia.com>
    net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain

Fushuai Wang <wangfushuai@baidu.com>
    selftests/bpf: fix signedness bug in redir_partial()

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

Johan Hovold <johan@kernel.org>
    soc: qcom: pmic_glink: fix OF node leak

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

Clément Le Goffic <clement.legoffic@foss.st.com>
    spi: stm32: Check for cfg availability in stm32_spi_probe

Charalampos Mitrodimas <charmitro@posteo.net>
    usb: misc: apple-mfi-fastcharge: Make power supply names unique

Seungjin Bae <eeodqql09@gmail.com>
    usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: vfxxx: Correctly use two tuples for timer address

André Apitzsch <git@apitzsch.eu>
    arm64: dts: qcom: msm8976: Make blsp_dma controlled-remotely

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc7180: Expand IMEM region

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Expand IMEM region

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    soc: qcom: QMI encoding/decoding for big endian

Dmitry Vyukov <dvyukov@google.com>
    selftests: Fix errno checking in syscall_user_dispatch test

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: use reserved memory or enable buffer pre-allocation

Arnd Bergmann <arnd@arndb.de>
    ASoC: ops: dynamically allocate struct snd_ctl_elem_value

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: No more self recovery

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    Revert "fs/ntfs3: Replace inode_trylock with inode_lock"

Yangtao Li <frank.li@vivo.com>
    hfsplus: remove mutex_lock check in hfsplus_free_extents

Yangtao Li <frank.li@vivo.com>
    hfs: make splice write available again

Yangtao Li <frank.li@vivo.com>
    hfsplus: make splice write available again

Caleb Sander Mateos <csander@purestorage.com>
    ublk: use vmalloc for ublk_device's __queues

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: cancle set bad inode after removing name fails

RubenKelevra <rubenkelevra@gmail.com>
    fs_context: fix parameter name in infofc() macro

Richard Guy Briggs <rgb@redhat.com>
    audit,module: restore audit logging in load failure case

Alexandru Andries <alex.andries.aa@gmail.com>
    ASoC: amd: yc: add DMI quirk for ASUS M6501RM

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: fix SND_SOC_SOF dependencies

Adam Queler <queler@gmail.com>
    ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx

Arnd Bergmann <arnd@arndb.de>
    ethernet: intel: fix building with large NR_CPUS

Lane Odenbach <laodenbach@gmail.com>
    ASoC: amd: yc: Add DMI quirk for HP Laptop 17 cp-2033dx


-------------

Diffstat:

 Documentation/filesystems/f2fs.rst                 |   6 +-
 Documentation/netlink/specs/ethtool.yaml           |   6 +-
 Makefile                                           |   4 +-
 .../boot/dts/nxp/imx/imx6ul-kontron-bl-common.dtsi |   1 -
 arch/arm/boot/dts/nxp/vf/vfxxx.dtsi                |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-boneblack.dts     |   2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   2 +-
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   2 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   2 +
 arch/arm64/boot/dts/qcom/msm8976.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  10 +-
 arch/m68k/Kconfig.debug                            |   2 +-
 arch/m68k/kernel/early_printk.c                    |  42 +--
 arch/m68k/kernel/head.S                            |   8 +-
 arch/mips/mm/tlb-r4k.c                             |  56 +++-
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/kernel/eeh.c                          |   1 +
 arch/powerpc/kernel/eeh_driver.c                   |  48 ++--
 arch/powerpc/kernel/eeh_pe.c                       |  10 +-
 arch/powerpc/kernel/pci-hotplug.c                  |   3 +
 arch/sh/Makefile                                   |  10 +-
 arch/sh/boot/compressed/Makefile                   |   4 +-
 arch/sh/boot/romimage/Makefile                     |   4 +-
 arch/um/drivers/rtc_user.c                         |   2 +-
 arch/x86/boot/compressed/sev.c                     |   7 +
 arch/x86/boot/cpuflags.c                           |  13 +
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kernel/sev-shared.c                       |  36 +++
 arch/x86/kernel/sev.c                              |  11 +-
 arch/x86/mm/extable.c                              |   5 +-
 drivers/block/ublk_drv.c                           |   4 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/char/hw_random/mtk-rng.c                   |   4 +-
 drivers/clk/clk-axi-clkgen.c                       |   2 +-
 drivers/clk/davinci/psc.c                          |   5 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +-
 drivers/clk/xilinx/xlnx_vcu.c                      |   4 +-
 drivers/cpufreq/cpufreq.c                          |  21 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   4 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   3 +
 drivers/crypto/img-hash.c                          |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   8 +-
 .../intel/qat/qat_common/adf_transport_debug.c     |   4 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.c       |   6 +-
 .../crypto/intel/qat/qat_common/qat_compression.c  |   8 +-
 drivers/crypto/marvell/cesa/cipher.c               |   4 +-
 drivers/crypto/marvell/cesa/hash.c                 |   5 +-
 drivers/devfreq/devfreq.c                          |  10 +-
 drivers/dma/mv_xor.c                               |  21 +-
 drivers/dma/nbpfaxi.c                              |  13 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c    |   2 +-
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   2 +-
 drivers/i2c/busses/i2c-stm32f7.c                   | 215 ++++++---------
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  15 +-
 drivers/infiniband/hw/mlx5/dm.c                    |   2 +-
 drivers/interconnect/qcom/sc8180x.c                |   6 +
 drivers/interconnect/qcom/sc8280xp.c               |   1 +
 drivers/iommu/amd/iommu.c                          |  17 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/md/md.c                                    |   9 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   8 +-
 drivers/mtd/ftl.c                                  |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   6 +
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |  15 +
 drivers/net/can/kvaser_pciefd.c                    |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  17 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k.h           |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   3 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   3 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 -
 drivers/net/ipa/ipa_sysfs.c                        |   6 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |   1 +
 drivers/net/phy/mscc/mscc_ptp.h                    |   1 +
 drivers/net/ppp/pptp.c                             |  18 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireless/ath/ath11k/hal.c              |   4 +
 drivers/net/wireless/ath/ath12k/wmi.c              |  12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
 drivers/net/wireless/marvell/mwl8k.c               |   4 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |  11 +-
 drivers/net/wireless/purelifi/plfxlc/mac.h         |   2 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |  29 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   5 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   4 +-
 drivers/pci/hotplug/pnv_php.c                      | 235 ++++++++++++++--
 drivers/pinctrl/pinmux.c                           |  20 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  11 +-
 drivers/power/supply/cpcap-charger.c               |   5 +-
 drivers/power/supply/max14577_charger.c            |   4 +-
 drivers/powercap/dtpm_cpu.c                        |   2 +
 drivers/pps/pps.c                                  |  11 +-
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
 drivers/soc/qcom/pmic_glink.c                      |   9 +-
 drivers/soc/qcom/qmi_encdec.c                      |  46 ++-
 drivers/soc/tegra/cbb/tegra234-cbb.c               |   2 +
 drivers/soundwire/stream.c                         |   2 +-
 drivers/spi/spi-stm32.c                            |   8 +-
 drivers/staging/fbtft/fbtft-core.c                 |   1 +
 drivers/staging/nvec/nvec_power.c                  |   2 +-
 drivers/ufs/core/ufshcd.c                          |  10 +-
 drivers/usb/early/xhci-dbc.c                       |   4 +
 drivers/usb/gadget/composite.c                     |   5 +
 drivers/usb/host/xhci-plat.c                       |   2 +-
 drivers/usb/misc/apple-mfi-fastcharge.c            |  24 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/vfio/group.c                               |   7 +-
 drivers/vfio/iommufd.c                             |   4 +
 drivers/vfio/pci/pds/vfio_dev.c                    |   1 +
 drivers/vfio/pci/vfio_pci_core.c                   |   2 +-
 drivers/vfio/vfio_main.c                           |   3 +-
 drivers/vhost/scsi.c                               |   4 +-
 drivers/video/fbdev/core/fbcon.c                   |   4 +-
 drivers/video/fbdev/imxfb.c                        |   9 +-
 drivers/watchdog/ziirave_wdt.c                     |   3 +
 drivers/xen/gntdev-common.h                        |   4 +
 drivers/xen/gntdev.c                               |  71 +++--
 fs/f2fs/data.c                                     |   7 +-
 fs/f2fs/extent_cache.c                             |   2 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/inode.c                                    |  21 +-
 fs/f2fs/segment.h                                  |   5 +-
 fs/gfs2/util.c                                     |  37 +--
 fs/hfs/inode.c                                     |   1 +
 fs/hfsplus/extents.c                               |   3 -
 fs/hfsplus/inode.c                                 |   1 +
 fs/jfs/jfs_dmap.c                                  |   4 +-
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/export.c                                    |  11 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  26 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/internal.h                                  |   9 +-
 fs/nfs/nfs4proc.c                                  |  10 +-
 fs/notify/fanotify/fanotify.c                      |   8 +-
 fs/ntfs3/file.c                                    |   5 +-
 fs/ntfs3/frecord.c                                 |   7 +-
 fs/ntfs3/namei.c                                   |  10 +-
 fs/ntfs3/ntfs_fs.h                                 |   3 +-
 fs/orangefs/orangefs-debugfs.c                     |   6 +-
 fs/proc/generic.c                                  |   2 +
 fs/proc/inode.c                                    |   2 +-
 fs/proc/internal.h                                 |   5 +
 fs/smb/client/cifs_debug.c                         |   2 +-
 fs/smb/client/cifsacl.c                            |   2 +-
 fs/smb/client/cifsacl.h                            |   2 +-
 fs/smb/client/cifsencrypt.c                        |   2 +-
 fs/smb/client/cifsfs.c                             |   4 +-
 fs/smb/client/cifsglob.h                           |   2 +-
 fs/smb/client/cifspdu.h                            |   4 +-
 fs/smb/client/cifssmb.c                            |   6 +-
 fs/smb/client/file.c                               |   2 +-
 fs/smb/client/fs_context.h                         |   2 +-
 fs/smb/client/misc.c                               |   2 +-
 fs/smb/client/netmisc.c                            |   2 +-
 fs/smb/client/readdir.c                            |   4 +-
 fs/smb/client/smb2ops.c                            |   4 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/client/smb2transport.c                      |   2 +-
 fs/smb/client/smbdirect.c                          | 307 ++++++++++++---------
 fs/smb/client/smbdirect.h                          |  12 +-
 fs/smb/common/smbdirect/smbdirect_socket.h         |  41 +++
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  22 +-
 fs/smb/server/smb_common.c                         |   2 +-
 fs/smb/server/transport_rdma.c                     |  97 +++----
 fs/smb/server/transport_tcp.c                      |  17 ++
 fs/smb/server/vfs.c                                |   3 +-
 include/linux/audit.h                              |   9 +-
 include/linux/fs_context.h                         |   2 +-
 include/linux/moduleparam.h                        |   5 +-
 include/linux/pps_kernel.h                         |   1 +
 include/linux/proc_fs.h                            |   1 +
 include/linux/psi_types.h                          |   6 +-
 include/linux/sched.h                              |   2 -
 include/linux/skbuff.h                             |  23 ++
 include/linux/usb/usbnet.h                         |   1 +
 include/linux/wait_bit.h                           |  60 ++++
 include/net/bluetooth/hci.h                        |   1 +
 include/net/dst.h                                  |   4 +-
 include/net/lwtunnel.h                             |   8 +-
 include/net/tc_act/tc_ctinfo.h                     |   6 +-
 include/net/udp.h                                  |  24 +-
 kernel/audit.h                                     |   2 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/bpf/preload/Kconfig                         |   1 -
 kernel/events/core.c                               |  20 +-
 kernel/freezer.c                                   |  51 ++--
 kernel/kcsan/kcsan_test.c                          |   2 +-
 kernel/module/main.c                               |   6 +-
 kernel/sched/core.c                                |  31 +--
 kernel/sched/psi.c                                 | 123 +++++----
 kernel/trace/preemptirq_delay_test.c               |  13 +-
 kernel/ucount.c                                    |   2 +-
 mm/hmm.c                                           |   2 +-
 net/bluetooth/hci_event.c                          |   8 +-
 net/caif/cfctrl.c                                  | 294 ++++++++++----------
 net/core/dst.c                                     |   4 +-
 net/core/filter.c                                  |   3 +
 net/core/netpoll.c                                 |   7 +
 net/core/skmsg.c                                   |   7 +
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_input.c                               |   4 +-
 net/ipv6/ip6_fib.c                                 |  24 +-
 net/ipv6/ip6_offload.c                             |   4 +-
 net/ipv6/ip6mr.c                                   |   3 +-
 net/ipv6/route.c                                   |  60 ++--
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/tdls.c                                |   2 +-
 net/mac80211/tx.c                                  |  14 +-
 net/netfilter/nf_bpf_link.c                        |   5 +-
 net/netfilter/nf_tables_api.c                      |  29 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 net/packet/af_packet.c                             |  12 +-
 net/sched/act_ctinfo.c                             |  19 +-
 net/sched/sch_mqprio.c                             |   2 +-
 net/sched/sch_netem.c                              |  40 +++
 net/sched/sch_taprio.c                             |  21 +-
 net/sunrpc/svcsock.c                               |  43 ++-
 net/sunrpc/xprtsock.c                              |  40 ++-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |   3 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 scripts/kconfig/qconf.cc                           |   2 +-
 security/apparmor/include/match.h                  |   8 +-
 security/apparmor/match.c                          |  23 +-
 sound/pci/hda/patch_ca0132.c                       |   5 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  21 ++
 sound/soc/fsl/fsl_xcvr.c                           |  20 ++
 sound/soc/intel/boards/Kconfig                     |   2 +-
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
 sound/soc/mediatek/common/mtk-base-afe.h           |   1 +
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8186/mt8186-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |   7 +
 sound/soc/soc-dai.c                                |  16 +-
 sound/soc/soc-ops.c                                |  28 +-
 sound/usb/mixer_scarlett2.c                        |   7 +
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 tools/bpf/bpftool/net.c                            |  15 +-
 tools/lib/subcmd/help.c                            |  12 +-
 tools/perf/.gitignore                              |   2 -
 tools/perf/builtin-sched.c                         |  41 ++-
 tools/perf/tests/bp_account.c                      |   1 +
 tools/perf/util/evsel.c                            |  11 +
 tools/perf/util/evsel.h                            |   2 +
 tools/perf/util/symbol.c                           |   1 +
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   2 +
 .../ftrace/test.d/event/subsystem-enable.tc        |  28 +-
 tools/testing/selftests/net/rtnetlink.sh           |   6 +
 tools/testing/selftests/perf_events/.gitignore     |   1 +
 tools/testing/selftests/perf_events/Makefile       |   2 +-
 tools/testing/selftests/perf_events/mmap.c         | 236 ++++++++++++++++
 .../selftests/syscall_user_dispatch/sud_test.c     |  50 ++--
 tools/verification/rv/src/in_kernel.c              |   4 +-
 287 files changed, 2632 insertions(+), 1290 deletions(-)


