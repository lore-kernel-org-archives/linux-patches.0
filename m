Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B555120DD51;
	Mon,  4 May 2026 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902922; cv=none; b=NaZx7VSkoyM41prHwChBtrb5W9wqmtuC39DbLpj9HAc84Lo1bL6ct3KGvkDRGWvkP1a7N0P/0EQxHniJ11FP5itpEI/kk54FAWhLu/QSw450Vusv0Of/1pwQteu4RKi4SjfgxhlgGGmOH5EhIlYd9cWq5X3U4neQIHVlxrOWdnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902922; c=relaxed/simple;
	bh=t/+MMJadGykDH+Rw5XLFIcz5YhaWck0Mo7bANfgT9TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pBQw1aWq7aW3OZi1cBYbPADnpb4K9N/HimulfBgecQB8T3hALOJnn1n4ZKx7DXQhs802KV7DA7ZR6XH5JzQQc/v8urHh2cX3bZeEEyl0OH26r2KmE4tCoqgKB3N40vbBfzVMTABFSJ7bCCHXZCIY73sZ1ymhseChsu2nAD6yFcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJkL3OZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJkL3OZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B581EC2BCB8;
	Mon,  4 May 2026 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902922;
	bh=t/+MMJadGykDH+Rw5XLFIcz5YhaWck0Mo7bANfgT9TQ=;
	h=From:To:Cc:Subject:Date:From;
	b=LJkL3OZSd+hJffFQNQtdbGD/f+LDaXy3NoNy0RahSz8gb6LUvcOCqYVBPmHoOQkfB
	 X204GWuozRKpCHHMpUTlPH6XOR6LeH1oRy7T477TvskytwJT5wcy+iXR7nT3Qw6mXF
	 IdXQQqFZL6vDBJgTHeJTfXfYQkpCzcien0RU1n9E=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 7.0 000/307] 7.0.4-rc1 review
Date: Mon,  4 May 2026 15:48:05 +0200
Message-ID: <20260504135142.814938198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.0.4-rc1
X-KernelTest-Deadline: 2026-05-06T13:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.0.4 release.
There are 307 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.0.4-rc1

Kai Ma <k4729.23098@gmail.com>
    netfilter: reject zero shift in nft_bitwise

Andrea Mayer <andrea.mayer@uniroma2.it>
    net: ipv6: fix NOREF dst use in seg6 and rpl lwtunnels

Harry Yoo (Oracle) <harry@kernel.org>
    mm/slab: return NULL early from kmalloc_nolock() in NMI on UP

Harry Yoo (Oracle) <harry@kernel.org>
    mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP

Marco Elver <elver@google.com>
    vmalloc: fix buffer overflow in vrealloc_node_align()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aloop: Fix peer runtime UAF during format-change stop

Deepanshu Kartikey <kartikey406@gmail.com>
    ALSA: caiaq: fix usb_dev refcount leak on probe failure

Brajesh Gupta <brajesh.gupta@imgtec.com>
    drm/imagination: Fix segfault when updating ftrace mask

Arjan van de Ven <arjan@linux.intel.com>
    drm/amdgpu: fix zero-size GDS range init on RDNA4

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ipv6: rpl: reserve mac_len headroom when recompressed SRH grows

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Don't abort when no input device is available

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path

Douglas Anderson <dianders@chromium.org>
    driver core: Add kernel-doc for DEV_FLAG_COUNT enum value

Yucheng Lu <kanolyc@gmail.com>
    crypto: authencesn - reject short ahash digests during instance creation

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add nova lake point H DID

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: use PCI_DEVICE_DATA macro

Lorenzo Stoakes (Oracle) <ljs@kernel.org>
    mm: avoid deadlock when holding rmap on mmap_prepare error

Lorenzo Stoakes (Oracle) <ljs@kernel.org>
    mm: various small mmap_prepare cleanups

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: fix mt7925u USB WFSYS reset handling

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: describe USB WFSYS reset with a descriptor

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: admv1013: fix NULL pointer dereference on str

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: admv1013: add dev variable

WANG Rui <r@hev.cc>
    perf loongarch: Fix build failure with CONFIG_LIBDW_DWARF_UNWIND

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix seg6 lwtunnel output redirect for L2 reduced encap mode

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails

Andrea Righi <arighi@nvidia.com>
    sched_ext: Documentation: Clarify ops.dispatch() role in task lifecycle

David Howells <dhowells@redhat.com>
    rxgk: Fix potential integer overflow in length check

Keenan Dong <keenanat2000@gmail.com>
    rtmutex: Use waiter::task instead of current in remove_waiter()

Tobias Gaertner <tob.gaertner@me.com>
    ntfs3: fix integer overflow in run_unpack() volume boundary check

Tobias Gaertner <tob.gaertner@me.com>
    ntfs3: add buffer boundary checks to run_unpack()

Tushar Sariya <tushar.97@hotmail.com>
    NFSv4.1: Apply session size limits on clone path

Steven Rostedt <rostedt@goodmis.org>
    ktest: Fix the month in the name of the failure directory

Chen Zhao <chezhao@nvidia.com>
    IB/core: Fix zero dmac race in neighbor resolution

David Carlier <devnexen@gmail.com>
    gtp: disable BH before calling udp_tunnel_xmit_skb()

Max Kellermann <max.kellermann@ionos.com>
    ceph: only d_add() negative dentries when they are unhashed

Sam Edwards <cfsworks@gmail.com>
    ceph: fix num_ops off-by-one when crypto allocation fails

Junrui Luo <moonafterrain@outlook.com>
    erofs: fix unsigned underflow in z_erofs_lz4_handle_overlap()

Junrui Luo <moonafterrain@outlook.com>
    dm mirror: fix integer overflow in create_dirty_log()

Gustavo A. R. Silva <gustavoars@kernel.org>
    crypto: nx - Fix packed layout in struct nx842_crypto_header

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: nx - fix context leak in nx842_crypto_free_ctx

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: nx - fix bounce buffer leaks in nx842_crypto_{alloc,free}_ctx

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix uninitialized data access on OTP read error

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix error codes in OTP reads

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - fix DMA sync direction

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    crypto: ccree - fix a memory leak in cc_mac_digest()

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: hisilicon - Fix dma_unmap_single() direction

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - Release client on allocation failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup

Eric Biggers <ebiggers@kernel.org>
    crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: acomp - fix wrong pointer stored by acomp_save_req()

Johan Hovold <johan@kernel.org>
    can: ucan: fix devres lifetime

Qiang Yu <qiang.yu@oss.qualcomm.com>
    bus: mhi: host: pci_generic: Switch to async power up to avoid boot delays

Shuvam Pandey <shuvampandey1@gmail.com>
    Bluetooth: hci_event: fix potential UAF in SSP passkey handlers

Cengiz Can <cengiz.can@canonical.com>
    apparmor: use target task's context in apparmor_getprocattr()

Pierre Barre <pierre@barre.sh>
    9p: fix access mode flags being ORed instead of replaced

Brian Mak <makb@juniper.net>
    mfd: core: Preserve OF node when ACPI handle is present

Gang Yan <yangang@kylinos.cn>
    mptcp: sync the msk->sndbuf at accept() time

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: set version in TGID exit notifications

Zhenzhong Wu <jt26wzz@gmail.com>
    tcp: call sk_data_ready() after listener migration

Yi Cong <yicong@kylinos.cn>
    wifi: rtl8xxxu: fix potential use of uninitialized value

Rick Edgecombe <rick.p.edgecombe@intel.com>
    x86/shstk: Prevent deadlock during shstk sigreturn

Dave Hansen <dave.hansen@linux.intel.com>
    x86/cpu: Disable FRED when PTI is forced on

Chia-Ming Chang <chiamingc@synology.com>
    inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails

Aditya Garg <gargaditya08@live.com>
    HID: apple: ensure the keyboard backlight is off if suspending

Kairui Song <kasong@tencent.com>
    mm, swap: speed up hibernation allocation and writeout

Arnd Bergmann <arnd@arndb.de>
    check-uapi: link into shared objects

Junrui Luo <moonafterrain@outlook.com>
    md/raid5: validate payload size before accessing journal metadata

Chia-Ming Chang <chiamingc@synology.com>
    md/raid5: fix soft lockup in retry_aligned_read()

Yu Kuai <yukuai@fnnas.com>
    md/md-llbitmap: raise barrier before state machine transition

Yu Kuai <yukuai@fnnas.com>
    md/md-llbitmap: skip reading rdevs that are not in_sync

David (Ming Qiang) Wu <David.Wu3@amd.com>
    amdgpu/jpeg: fix deepsleep register for jpeg 5_0_0 and 5_0_2

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: spinand: winbond: Declare the QE bit on W25NxxJW

Sanjaikumar V S <sanjaikumar.vs@dicortech.com>
    mtd: spi-nor: sst: Fix write enable before AAI sequence

Seohyeon Maeng <bioloidgp@gmail.com>
    udf: fix partition descriptor append bookkeeping

Sohei Koyama <skoyama@ddn.com>
    ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    ring-buffer: Do not double count the reader_page

Brian Ruley <brian.ruley@gehealthcare.com>
    ARM: 9472/1: fix race condition on PG_dcache_clean in __sync_icache_dcache()

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Always intercept VMMCALL when L2 is active

Kevin Cheng <chengkev@google.com>
    KVM: nSVM: Raise #UD if unhandled VMMCALL isn't intercepted by L1

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Add missing consistency check for nCR3 validity

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Drop the non-architectural consistency check for NP_ENABLE

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Triple fault if mapping VMCB12 fails on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Refactor writing vmcb12 on nested #VMEXIT as a helper

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Refactor checking LBRV enablement in vmcb12 into a helper

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Add missing save/restore handling of LBR MSRs

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Switch svm_copy_lbrs() to a macro

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Delay setting soft IRQ RIP tracking fields until vCPU run

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Account for RESx bits in __compute_fgt()

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Delay stuffing L2's current RIP into NextRIP until vCPU run

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts

Kevin Cheng <chengkev@google.com>
    KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state

Sean Christopherson <seanjc@google.com>
    KVM: x86: Defer non-architectural deliver of exception payload to userspace read

Tao Cui <cuitao@kylinos.cn>
    LoongArch: KVM: Use CSR_CRMD_PLV in kvm_arch_vcpu_in_kernel()

Denis M. Karpov <komlomal@gmail.com>
    userfaultfd: allow registration of ranges below mmap_min_addr

SeongJae Park <sj@kernel.org>
    mm/damon/core: disallow non-power of two min_region_sz on damon_start()

SeongJae Park <sj@kernel.org>
    mm/damon/core: disallow time-quota setting zero esz

SeongJae Park <sj@kernel.org>
    mm/damon/core: use time_in_range_open() for damos quota window start

SeongJae Park <sj@kernel.org>
    mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp

SeongJae Park <sj@kernel.org>
    mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp

Jackie Liu <liuyun01@kylinos.cn>
    mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()

Jackie Liu <liuyun01@kylinos.cn>
    mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()

Chenghao Duan <duanchenghao@kylinos.cn>
    mm/memfd_luo: fix physical address conversion in put_folios cleanup

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/vmalloc: take vmap_purge_lock in shrinker

Johan Hovold <johan@kernel.org>
    rtc: ntxec: fix OF node reference imbalance

Jacqueline Wong <jacqwong@google.com>
    tpm: tpm_tis: stop transmit if retries are exhausted

Jacqueline Wong <jacqwong@google.com>
    tpm: tpm_tis: add error logging for data transfer

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm: Use kfree_sensitive() to free auth session in tpm_dev_release()

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm: Fix auth session leak in tpm2_get_random() error path

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm2-sessions: Fix missing tpm_buf_destroy() in tpm2_read_public()

Viorel Suman (OSS) <viorel.suman@oss.nxp.com>
    pwm: imx-tpm: Count the number of enabled channels in probe

Paul Louvel <paul.louvel@bootlin.com>
    crypto: talitos - rename first/last to first_desc/last_desc

Paul Louvel <paul.louvel@bootlin.com>
    crypto: talitos - fix SEC1 32k ahash request limitation

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    firmware: exynos-acpm: Drop fake 'const' on handle pointer

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: google: framebuffer: Do not unregister platform device

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a resource leak in xfs_alloc_buftarg()

Hans Holmberg <hans.holmberg@wdc.com>
    xfs: start gc on zonegc_low_space attribute updates

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix IRQ cleanup on 6xxx probe failure

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: am62-verdin: Enable pullup for eMMC data pins

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Disable clock before DLL configuration

Bin Liu <b-liu@ti.com>
    mmc: block: use single block write in retry

Ryan Roberts <ryan.roberts@arm.com>
    randomize_kstack: Maintain kstack_offset per task

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pt5161l) Fix bugs in pt5161l_read_block_data()

Paul Moore <paul@paul-moore.com>
    selinux: fix overlayfs mmap() and mprotect() access checks

Paul Moore <paul@paul-moore.com>
    lsm: add backing_file LSM hooks

Amir Goldstein <amir73il@gmail.com>
    fs: prepare for adding LSM blob to backing_file

Barnabás Pőcze <barnabas.pocze+renesas@ideasonboard.com>
    media: rzv2h-ivc: Fix AXIRX_VBLANK register write

Daniel Scally <dan.scally+renesas@ideasonboard.com>
    media: rzv2h-ivc: Revise default VBLANK formula

Thomas Weißschuh <linux@weissschuh.net>
    hwmon: (powerz) Avoid cacheline sharing for DMA buffer

Sanman Pradhan <psanman@juniper.net>
    hwmon: (isl28022) Fix integer overflow in power calculation on 32-bit

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    power: supply: axp288_charger: Do not cancel work before initializing it

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: defio: Disconnect deferred I/O from the lifetime of struct fb_info

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Show CPU vulnerabilites correctly

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make arch_irq_work_has_interrupt() true only if IPI HW exist

Arnd Bergmann <arnd@arndb.de>
    tpm: avoid -Wunused-but-set-variable

Nathan Chancellor <nathan@kernel.org>
    extract-cert: Wrap key_pass with '#ifdef USE_PKCS11_ENGINE'

Daniel J Blueman <daniel@quora.org>
    apparmor: Fix string overrun due to missing termination

Johan Hovold <johan@kernel.org>
    spi: fix resource leaks on device setup failure

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()

Ruide Cao <caoruide123@gmail.com>
    ipv4: icmp: validate reply type before using icmp_pointers

Petr Mladek <pmladek@suse.com>
    printf: Compile the kunit test with DISABLE_BRANCH_PROFILING DISABLE_BRANCH_PROFILING

hkbinbin <hkbinbinbin@gmail.com>
    RDMA/rxe: Validate pad and ICRC before payload_size() in rxe_rcv

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/fprobe: Reject registration of a registered fprobe before init

Marco Elver <elver@google.com>
    slub: fix data loss and overflow in krealloc()

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/arcpgu: fix device node leak

Marek Vasut <marex@nabladev.com>
    net: ks8851: Avoid excess softirq scheduling

Yuan Zhaoming <yuanzm2@lenovo.com>
    net: mctp: fix don't require received header reserved bits to be zero

Breno Leitao <leitao@debian.org>
    netconsole: avoid out-of-bounds access on empty string in trim_newline()

Zhengchuan Liang <zcliangcn@gmail.com>
    net: bridge: use a stable FDB dst snapshot in RCU readers

Marek Vasut <marex@nabladev.com>
    net: ks8851: Reinstate disabling of BHs around IRQ handler

Ruijie Li <ruijieli51@gmail.com>
    net/smc: avoid early lgr access in smc_clc_wait_msg

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix firmware version check

Ao Zhou <draw51280@163.com>
    net: rds: fix MR cleanup on copy error

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the total number of nodes

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Free the node during ctrl_cmd_bye()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum number of lookups

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum server registration per node

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: marvell: uDPU: add ethernet aliases

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix RTNL assertion warning when remove module

Yiyang Chen <cyyzero16@gmail.com>
    tools/accounting: handle truncated taskstats netlink messages

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    EDAC/versalnet: Fix memory leak in remove and probe error paths

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxrpc_input_call_event() to only unshare DATA packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix re-decryption of RESPONSE packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix error handling in rxgk_extract_token()

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxkad crypto unalignment handling

David Howells <dhowells@redhat.com>
    rxrpc: Fix conn-level packet handling to unshare RESPONSE packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix memory leaks in rxkad_verify_response()

David Howells <dhowells@redhat.com>
    rxrpc: Fix potential UAF after skb_unshare() failure

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: remove switch to one-shot mode

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: fix one-shot mode data acquisition

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcmtest: Fix resource leaks in module init error paths

Guangshuo Li <lgs201920130244@gmail.com>
    ALSA: pcmtest: fix reference leak on failed device registration

Spencer Payton <spayton681@gmail.com>
    ALSA: hda/realtek - Add mute LED support for HP Victus 15-fa2xxx

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: 6fire: Fix input volume change detection

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Handle probe errors properly

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: caiaq: Fix control_put() result and cache rollback

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix potential data race at fasync handling

Helge Deller <deller@gmx.de>
    module.lds.S: Fix modules on 32-bit parisc architecture

Joe Lawrence <joe.lawrence@redhat.com>
    module.lds,codetag: force 0 sh_addr for sections

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: ensure EPOLL_ONESHOT is propagated for EPOLL_URING_WAKE

Longxuan Yu <ylong030@ucr.edu>
    io_uring/poll: fix signed comparison in io_poll_get_ownership()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: fix user_struct uaf

Jens Axboe <axboe@kernel.dk>
    io_uring/register: fix ring resizing with mixed/large SQEs/CQEs

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-ads7950: use iio_push_to_buffers_with_ts_unaligned()

Naman Jain <namjain@linux.microsoft.com>
    block: relax pgmap check in bio_add_page for compatible zone device pages

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/timeout: check unused sqe fields

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: return back two step unregistration

Damien Le Moal <dlemoal@kernel.org>
    block: fix zone write plugs refcount handling in disk_zone_wplug_schedule_bio_work()

Matthew Brost <matthew.brost@intel.com>
    mm/zone_device: do not touch device folio after calling ->folio_free()

Dawei Feng <dawei.feng@seu.edu.cn>
    rbd: fix null-ptr-deref when device_add_disk() fails

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Skip stale records in audit_match_record()

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fix snprintf truncation checks in audit helpers

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fix format warning for __u64 in net_test

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Drain stale audit records on init

Mickaël Salaün <mic@digikod.net>
    landlock: Allow TSYNC with LOG_SUBDOMAINS_OFF and fd=-1

Mickaël Salaün <mic@digikod.net>
    landlock: Fix LOG_SUBDOMAINS_OFF inheritance across fork()

Simon Liebold <simonlie@amazon.de>
    selftests/mqueue: Fix incorrectly named file

Joseph Salisbury <joseph.salisbury@oracle.com>
    sched: Use u64 for bandwidth ratio calculations

Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
    reset: rzv2h-usb2phy: Keep PHY clock enabled for entire device lifetime

Ben Levinsky <ben.levinsky@amd.com>
    remoteproc: xlnx: Only access buffer information if IPI is buffered

Long Li <longli@microsoft.com>
    RDMA/mana_ib: Disable RX steering on RSS QP destroy

Rong Bao <rong.bao@csmantle.top>
    perf annotate: Use jump__delete when freeing LoongArch jumps

Franz Schnyder <franz.schnyder@toradex.com>
    PCI: imx6: Fix reference clock source selection for i.MX95

Aksh Garg <a-garg7@ti.com>
    PCI: cadence: Use cdns_pcie_read_sz() for byte or word read access

Helge Deller <deller@gmx.de>
    parisc: Drop ip_fast_csum() inline assembly implementation

Helge Deller <deller@gmx.de>
    parisc: _llseek syscall is only available for 32-bit userspace

Robert Beckett <bob.beckett@collabora.com>
    nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set

Robert Beckett <bob.beckett@collabora.com>
    nvme-pci: add NVME_QUIRK_DISABLE_WRITE_ZEROES for Kingston OM3SGP4

James Kim <james010kim@gmail.com>
    mtd: docg3: fix use-after-free in docg3_release()

Thorsten Blum <thorsten.blum@linux.dev>
    mm/hugetlb: fix early boot crash on parameters without '=' separator

SeongJae Park <sj@kernel.org>
    mm/damon/core: fix damos_walk() vs kdamond_fn() exit race

SeongJae Park <sj@kernel.org>
    mm/damon/core: fix damon_call() vs kdamond_fn() exit race

Hao Ge <hao.ge@linux.dev>
    mm/alloc_tag: clear codetag for pages allocated before page_ext initialization

Marek Vasut <marex@nabladev.com>
    mfd: stpmic1: Attempt system shutdown twice in case PMIC is confused

Michael Riesch <michael.riesch@collabora.com>
    media: rockchip: rkcif: comply with minimum number of buffers requirement

Dan Carpenter <dan.carpenter@linaro.org>
    media: rockchip: rkcif: fix off by one bugs

Oliver Neukum <oneukum@suse.com>
    media: rc: igorplugusb: heed coherency rules

Josh Hunt <johunt@akamai.com>
    md/raid10: fix deadlock with check operation and nowait requests

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Fix reserved value WRMSR testcase for multi-feature MSRs

Zhang Yi <yi.zhang@huawei.com>
    jbd2: fix deadlock in jbd2_journal_cancel_revoke()

Corey Minyard <corey@minyard.net>
    ipmi:ssif: Clean up kthread on errors

Gao Xiang <xiang@kernel.org>
    erofs: fix the out-of-bounds nameoff handling for trailing dirents

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq_oss: return full count for successful SEQ_FULLSIZE writes

Harin Lee <me@harin.net>
    ALSA: ctxfi: Add fallback to default RSR for S/PDIF

Thorsten Blum <thorsten.blum@linux.dev>
    ALSA: aoa: Skip devices with no codecs in i2sbus_resume()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aoa: i2sbus: fix OF node lifetime handling

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aoa: i2sbus: clear stale prepared state

Shigeru Yoshida <syoshida@redhat.com>
    mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()

Vasiliy Kovalev <kovalev@altlinux.org>
    ext2: reject inodes with zero i_nlink and valid mode in ext2_iget()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Fix use-after-free in driver remove()

Chen Ni <nichen@iscas.ac.cn>
    media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()

Josh Law <objecting@objecting.org>
    lib/ts_kmp: fix integer overflow in pattern length calculation

Daniel Hodges <git@danielhodges.dev>
    PCI: epf-mhi: Return 0, not remaining timeout, when eDMA ops complete

Elson Serrao <elson.serrao@oss.qualcomm.com>
    phy: qcom: m31-eusb2: clear PLL_EN during init

Rong Zhang <i@rong.moe>
    Revert "ALSA: usb: Increase volume range that triggers a warning"

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-ntb: Remove duplicate resource teardown

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix OTP sysfs read and error handling

Fan Wu <fanwu01@zju.edu.cn>
    media: mtk-jpeg: fix use-after-free in release path due to uncancelled work

Luxiao Xu <rakukuip@gmail.com>
    net: strparser: fix skb_head leak in strp_abort_strp()

Zhengchuan Liang <zcliangcn@gmail.com>
    net: caif: clear client service pointer on teardown

Ziqing Chen <chenziqing@xiaomi.com>
    ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Fix race between m2m job_abort and device_run

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Skip waiting for L2/L3 Ready on i.MX6SX

Felix Gu <ustc.gu@gmail.com>
    EDAC/versalnet: Fix device_node leak in mc_probe()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (powerz) Fix missing usb_kill_urb() on signal interrupt

Wentao Liang <vulab@iscas.ac.cn>
    of: unittest: fix use-after-free in testdrv_probe()

Wentao Liang <vulab@iscas.ac.cn>
    of: unittest: fix use-after-free in of_unittest_changeset()

Swamil Jain <s-jain1@ti.com>
    dt-bindings: display: ti, am65x-dss: Fix AM62L DSS reg and clock constraints

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix handling of MAY_BACKLOG requests

Douya Le <ldy3087146292@gmail.com>
    crypto: algif_aead - snapshot IV for async AEAD requests

Johan Hovold <johan@kernel.org>
    spi: ch341: fix memory leaks on probe failures

Johan Hovold <johan@kernel.org>
    spi: imx: fix use-after-free on unbind

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix thermal zone governor cleanup issues

Michael Bommarito <michael.bommarito@gmail.com>
    um: drivers: call kernel_strrchr() explicitly in cow_user.c

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    vfio/cdx: Fix NULL pointer dereference in interrupt trigger path

Alex Williamson <alex.williamson@nvidia.com>
    vfio/cdx: Serialize VFIO_DEVICE_SET_IRQS with a per-device mutex

Alex Williamson <alex.williamson@nvidia.com>
    vfio/virtio: Convert list_lock from spinlock to mutex

Michał Winiarski <michal.winiarski@intel.com>
    vfio/xe: Add a missing vfio_pci_core_release_dev()

Manish Honap <mhonap@nvidia.com>
    vfio: selftests: Fix VLA initialisation in vfio_pci_irq_set()

Daniel Hodges <git@danielhodges.dev>
    wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw88: check for PCI upstream bridge existence

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not forget to endio for partial discard requests

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: edt-ft5x06 - fix use-after-free in debugfs teardown

Heming Zhao <heming.zhao@suse.com>
    ocfs2: split transactions in dio completion to avoid credit exhaustion

Lance Yang <lance.yang@linux.dev>
    mm: fix deferred split queue races during migration

Anthony Yznaga <anthony.yznaga@oracle.com>
    mm: prevent droppable mappings from being locked

Usama Arif <usama.arif@linux.dev>
    mm: migrate: requeue destination folio on deferred split queue

Ryan Roberts <ryan.roberts@arm.com>
    arm64: mm: Fix rodata=full block mapping support for realm guests

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Enable batched TLB flush in unmap_hotplug_range()

Alistair Popple <apopple@nvidia.com>
    lib: test_hmm: evict device pages on file close to avoid use-after-free

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: google: framebuffer: Do not mark framebuffer as busy

Lorenzo Stoakes (Oracle) <ljs@kernel.org>
    fs: afs: revert mmap_prepare() change

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust: allow `clippy::uninlined_format_args`

Danilo Krummrich <dakr@kernel.org>
    rust: dma: remove DMA_ATTR_NO_KERNEL_MAPPING from public attrs

David Carlier <devnexen@gmail.com>
    drm/nouveau: fix nvkm_device leak on aperture removal failure

Douglas Anderson <dianders@chromium.org>
    device property: Make modifications of fwnode "flags" thread safe

Douglas Anderson <dianders@chromium.org>
    driver core: Don't let a device probe until it's ready

Thomas Weißschuh <linux@weissschuh.net>
    sysfs: attribute_group: Respect is_visible_const() when changing owner

Tyllis Xu <livelycarpet87@gmail.com>
    ibmasm: fix heap over-read in ibmasm_send_i2o_message()

Tyllis Xu <livelycarpet87@gmail.com>
    ibmasm: fix OOB reads in command_file_write due to missing size checks

Tyllis Xu <livelycarpet87@gmail.com>
    misc: ibmasm: fix OOB MMIO read in ibmasm_handle_mouse_interrupt()

Weigang He <geoffreyhe2@gmail.com>
    greybus: gb-beagleplay: fix sleep in atomic context in hdlc_tx_frames()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    greybus: gb-beagleplay: bound bootloader receive buffering

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    leds: qcom-lpg: Check for array overflow when selecting the high resolution

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/nouveau: fix u32 overflow in pushbuf reloc bounds check

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    LoongArch: Add spectre boundry for syscall dispatch table

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Evaluate packsize caps at the right place

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: allow ci_irq_handler() handle both ID and VBUS change

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: otg: not wait vbus drop if use role_switch

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Avoid false E-MU sample-rate notifications

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES


-------------

Diffstat:

 .../bindings/display/ti/ti,am65x-dss.yaml          |  70 ++--
 Documentation/scheduler/sched-ext.rst              |  14 +-
 Makefile                                           |   5 +-
 arch/Kconfig                                       |   7 +
 arch/arm/mm/flush.c                                |   4 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   5 +
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  20 +-
 arch/arm64/crypto/aes-modes.S                      |   4 +-
 arch/arm64/include/asm/mmu.h                       |   2 +
 arch/arm64/kvm/config.c                            |   4 +-
 arch/arm64/mm/init.c                               |   9 +-
 arch/arm64/mm/mmu.c                                |  81 +++--
 arch/loongarch/include/asm/irq_work.h              |   2 +-
 arch/loongarch/kernel/cpu-probe.c                  |   7 +
 arch/loongarch/kernel/syscall.c                    |   3 +-
 arch/loongarch/kvm/vcpu.c                          |   2 +-
 arch/parisc/Kconfig                                |   4 +
 arch/parisc/include/asm/checksum.h                 |  89 +----
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/parisc/lib/Makefile                           |   2 +-
 arch/parisc/lib/checksum.c                         |  99 ------
 arch/um/drivers/cow_user.c                         |   8 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/kernel/shstk.c                            |  42 +--
 arch/x86/kvm/hyperv.h                              |   8 -
 arch/x86/kvm/svm/hyperv.h                          |   9 +-
 arch/x86/kvm/svm/nested.c                          | 201 +++++++-----
 arch/x86/kvm/svm/svm.c                             | 150 +++++++--
 arch/x86/kvm/svm/svm.h                             |  17 +-
 arch/x86/kvm/x86.c                                 |  65 ++--
 arch/x86/mm/pti.c                                  |   5 +
 block/bio-integrity.c                              |   6 +-
 block/bio.c                                        |   6 +-
 block/blk-zoned.c                                  |  12 +-
 block/blk.h                                        |  19 ++
 certs/extract-cert.c                               |   6 +-
 crypto/acompress.c                                 |   8 +-
 crypto/algif_aead.c                                |  10 +-
 crypto/authencesn.c                                |   5 +
 crypto/pcrypt.c                                    |   7 +-
 drivers/base/core.c                                |  39 ++-
 drivers/base/dd.c                                  |  20 ++
 drivers/block/rbd.c                                |   6 +-
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/bus/imx-weim.c                             |   2 +-
 drivers/bus/mhi/host/pci_generic.c                 |   2 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  13 +-
 drivers/char/tpm/tpm-chip.c                        |   2 +-
 drivers/char/tpm/tpm2-cmd.c                        |   6 +-
 drivers/char/tpm/tpm2-sessions.c                   |   5 +-
 drivers/char/tpm/tpm_tis_core.c                    |  11 +-
 drivers/clk/samsung/clk-acpm.c                     |   4 +-
 drivers/crypto/atmel-aes.c                         |   2 +-
 drivers/crypto/atmel-ecc.c                         |   1 +
 drivers/crypto/atmel-i2c.c                         |   4 +-
 drivers/crypto/atmel-sha204a.c                     |  37 ++-
 drivers/crypto/atmel-tdes.c                        |   8 +-
 drivers/crypto/ccree/cc_hash.c                     |   1 +
 drivers/crypto/hisilicon/sec/sec_algs.c            |   2 +-
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c        |   4 +-
 drivers/crypto/nx/nx-842.c                         |  10 +-
 drivers/crypto/nx/nx-842.h                         |   4 +-
 drivers/crypto/talitos.c                           | 340 ++++++++++++--------
 drivers/edac/versalnet_edac.c                      |   6 +-
 drivers/firmware/google/framebuffer-coreboot.c     |  12 +-
 drivers/firmware/samsung/exynos-acpm-dvfs.c        |   4 +-
 drivers/firmware/samsung/exynos-acpm-dvfs.h        |   4 +-
 drivers/firmware/samsung/exynos-acpm-pmic.c        |  10 +-
 drivers/firmware/samsung/exynos-acpm-pmic.h        |  10 +-
 drivers/firmware/samsung/exynos-acpm.c             |  16 +-
 drivers/firmware/samsung/exynos-acpm.h             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |  52 ++-
 drivers/gpu/drm/imagination/pvr_fw_trace.c         |   2 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +-
 drivers/gpu/drm/tiny/arcpgu.c                      |   3 +-
 drivers/greybus/gb-beagleplay.c                    | 112 ++++++-
 drivers/hid/hid-apple.c                            |   2 +
 drivers/hwmon/isl28022.c                           |   5 +-
 drivers/hwmon/powerz.c                             |  16 +-
 drivers/hwmon/pt5161l.c                            |   4 +-
 drivers/i2c/i2c-core-of.c                          |   2 +-
 drivers/iio/adc/ad7768-1.c                         |  16 +-
 drivers/iio/adc/ti-ads7950.c                       |  11 +-
 drivers/iio/frequency/admv1013.c                   |  90 +++---
 drivers/infiniband/core/addr.c                     |   3 +
 drivers/infiniband/hw/mana/qp.c                    |  15 +
 drivers/infiniband/sw/rxe/rxe_recv.c               |   3 +-
 drivers/input/touchscreen/edt-ft5x06.c             |   3 +
 drivers/leds/rgb/leds-qcom-lpg.c                   |   7 +-
 drivers/md/dm-raid1.c                              |   6 +-
 drivers/md/md-llbitmap.c                           |  11 +-
 drivers/md/raid10.c                                |   4 +-
 drivers/md/raid5-cache.c                           |  48 ++-
 drivers/md/raid5.c                                 |   8 +-
 drivers/media/i2c/imx219.c                         |   3 +
 drivers/media/platform/amphion/vpu_v4l2.c          |   9 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |   1 +
 .../platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c   |   9 +-
 .../media/platform/renesas/rzv2h-ivc/rzv2h-ivc.h   |   2 +-
 .../platform/rockchip/rkcif/rkcif-capture-mipi.c   |  10 +-
 .../media/platform/rockchip/rkcif/rkcif-stream.c   |  44 +--
 drivers/media/rc/igorplugusb.c                     |  16 +-
 drivers/mfd/mfd-core.c                             |  12 +-
 drivers/mfd/sec-acpm.c                             |  10 +-
 drivers/mfd/stpmic1.c                              |  20 +-
 drivers/misc/ibmasm/ibmasmfs.c                     |   7 +
 drivers/misc/ibmasm/lowlevel.c                     |  12 +-
 drivers/misc/ibmasm/remote.c                       |   5 +
 drivers/misc/mei/bus-fixup.c                       |   6 +-
 drivers/misc/mei/hw-me-regs.h                      | 163 +++++-----
 drivers/misc/mei/hw-me.h                           |   6 -
 drivers/misc/mei/pci-me.c                          | 163 +++++-----
 drivers/mmc/core/block.c                           |  12 +-
 drivers/mmc/core/queue.h                           |   3 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  19 +-
 drivers/mtd/devices/docg3.c                        |   3 +-
 drivers/mtd/nand/spi/winbond.c                     |   4 +-
 drivers/mtd/spi-nor/sst.c                          |  13 +
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/ethernet/micrel/ks8851.h               |   6 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  69 ++--
 drivers/net/ethernet/micrel/ks8851_par.c           |  15 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |  11 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  11 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c     |   2 +
 drivers/net/gtp.c                                  |   2 +
 drivers/net/netconsole.c                           |   2 +
 drivers/net/phy/mdio_bus_provider.c                |   4 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/mt792x_regs.h   |   4 +
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |  51 ++-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  28 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   3 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/of/base.c                                  |   2 +-
 drivers/of/dynamic.c                               |   2 +-
 drivers/of/platform.c                              |   2 +-
 drivers/of/unittest.c                              |   4 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |  56 ++--
 drivers/pci/controller/dwc/pci-imx6.c              |   5 +-
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |   4 +
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |  56 +---
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c          |   2 +-
 drivers/power/supply/axp288_charger.c              |  19 +-
 drivers/pwm/pwm-imx-tpm.c                          |   9 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |  20 +-
 drivers/reset/reset-rzv2h-usb2phy.c                |  64 ++--
 drivers/rtc/rtc-ntxec.c                            |   2 +-
 drivers/scsi/sd.c                                  |   1 +
 drivers/spi/spi-ch341.c                            |  36 ++-
 drivers/spi/spi-imx.c                              |   4 +
 drivers/spi/spi.c                                  |  63 ++--
 drivers/thermal/thermal_core.c                     |   7 +-
 drivers/usb/chipidea/core.c                        |  45 +--
 drivers/usb/chipidea/otg.c                         |   7 +-
 drivers/usb/host/xhci.c                            |   1 -
 drivers/vfio/cdx/intr.c                            |  13 +-
 drivers/vfio/cdx/main.c                            |  19 ++
 drivers/vfio/cdx/private.h                         |   3 +
 drivers/vfio/pci/virtio/common.h                   |   2 +-
 drivers/vfio/pci/virtio/migrate.c                  |  33 +-
 drivers/vfio/pci/xe/main.c                         |   1 +
 drivers/video/fbdev/core/fb_defio.c                | 178 +++++++---
 fs/9p/v9fs.c                                       |   4 +
 fs/afs/file.c                                      |  12 +-
 fs/backing-file.c                                  |  18 +-
 fs/ceph/addr.c                                     |   4 +
 fs/ceph/dir.c                                      |   6 +-
 fs/erofs/decompressor.c                            |   1 +
 fs/erofs/dir.c                                     |  28 +-
 fs/erofs/ishare.c                                  |  10 +-
 fs/ext2/inode.c                                    |  14 +-
 fs/ext4/xattr.c                                    |   6 +-
 fs/file_table.c                                    |  43 ++-
 fs/fuse/passthrough.c                              |   2 +-
 fs/internal.h                                      |   3 +-
 fs/jbd2/revoke.c                                   |   8 +-
 fs/nfs/internal.h                                  |   2 +
 fs/nfs/nfs4client.c                                |   4 +-
 fs/nfs/nfs4proc.c                                  |   3 +
 fs/notify/inotify/inotify_user.c                   |   1 +
 fs/ntfs3/run.c                                     |  18 +-
 fs/ocfs2/aops.c                                    |  74 +++--
 fs/overlayfs/dir.c                                 |   2 +-
 fs/overlayfs/file.c                                |   2 +-
 fs/sysfs/group.c                                   |   7 +-
 fs/udf/super.c                                     |   4 +-
 fs/userfaultfd.c                                   |   2 -
 fs/xfs/xfs_buf.c                                   |   1 +
 fs/xfs/xfs_sysfs.c                                 |   7 +-
 fs/xfs/xfs_zone_alloc.h                            |   4 +
 fs/xfs/xfs_zone_gc.c                               |  17 +
 include/asm-generic/codetag.lds.h                  |   2 +-
 include/linux/alloc_tag.h                          |   2 +
 include/linux/backing-file.h                       |   4 +-
 include/linux/damon.h                              |   2 +
 include/linux/device.h                             |  45 +++
 include/linux/fb.h                                 |   4 +-
 .../linux/firmware/samsung/exynos-acpm-protocol.h  |  40 +--
 include/linux/fs.h                                 |  15 +-
 include/linux/fwnode.h                             |  44 ++-
 include/linux/hugetlb_inline.h                     |   2 +-
 include/linux/lsm_audit.h                          |   2 +-
 include/linux/lsm_hook_defs.h                      |   5 +
 include/linux/lsm_hooks.h                          |   1 +
 include/linux/mm.h                                 |   7 +-
 include/linux/pgalloc_tag.h                        |   2 +-
 include/linux/randomize_kstack.h                   |  26 +-
 include/linux/sched.h                              |   4 +
 include/linux/security.h                           |  22 ++
 include/linux/tpm_eventlog.h                       |   9 +-
 include/linux/usb.h                                |   3 +-
 include/net/mana/mana.h                            |   1 +
 include/net/mctp.h                                 |   3 +
 include/trace/events/rxrpc.h                       |   6 +-
 include/uapi/linux/landlock.h                      |   4 +-
 init/main.c                                        |   1 -
 io_uring/io_uring.c                                |   4 +
 io_uring/poll.c                                    |   6 +-
 io_uring/register.c                                |  32 +-
 io_uring/timeout.c                                 |   4 +
 io_uring/zcrx.c                                    |  48 ++-
 io_uring/zcrx.h                                    |   4 +
 kernel/fork.c                                      |   2 +
 kernel/locking/rtmutex.c                           |  13 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/rt.c                                  |   2 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/taskstats.c                                 |   1 +
 kernel/trace/fprobe.c                              |  21 +-
 kernel/trace/ring_buffer.c                         |  13 +-
 lib/alloc_tag.c                                    | 109 +++++++
 lib/test_hmm.c                                     | 112 ++++---
 lib/tests/Makefile                                 |   2 +
 lib/ts_kmp.c                                       |  18 +-
 mm/damon/core.c                                    | 101 +++---
 mm/damon/stat.c                                    |   5 +-
 mm/huge_memory.c                                   |  15 +-
 mm/hugetlb.c                                       |   3 +
 mm/internal.h                                      |  42 ++-
 mm/memfd_luo.c                                     |   7 +-
 mm/memory.c                                        |  53 +--
 mm/mempolicy.c                                     |  23 +-
 mm/memremap.c                                      |   2 +-
 mm/migrate.c                                       |  17 +
 mm/mlock.c                                         |  10 +-
 mm/page_alloc.c                                    |  15 +-
 mm/slub.c                                          |  28 +-
 mm/swapfile.c                                      |  21 +-
 mm/util.c                                          | 131 ++++----
 mm/vma.c                                           |  39 ++-
 mm/vmalloc.c                                       |   3 +-
 mm/zsmalloc.c                                      |   1 +
 net/bluetooth/hci_event.c                          |  18 +-
 net/bridge/br_arp_nd_proxy.c                       |   8 +-
 net/bridge/br_fdb.c                                |  28 +-
 net/caif/cfsrvl.c                                  |  14 +-
 net/ceph/auth.c                                    |   2 +-
 net/ipv4/icmp.c                                    |   5 +-
 net/ipv4/inet_connection_sock.c                    |   3 +
 net/ipv6/exthdrs.c                                 |   9 +-
 net/ipv6/rpl_iptunnel.c                            |   9 +
 net/ipv6/seg6_iptunnel.c                           |  12 +-
 net/mctp/route.c                                   |   8 +-
 net/mptcp/protocol.c                               |   2 +-
 net/netfilter/nft_bitwise.c                        |   3 +-
 net/qrtr/ns.c                                      |  79 ++++-
 net/rds/rdma.c                                     |   4 -
 net/rxrpc/ar-internal.h                            |   1 -
 net/rxrpc/call_event.c                             |  20 +-
 net/rxrpc/conn_event.c                             |  43 ++-
 net/rxrpc/io_thread.c                              |  24 +-
 net/rxrpc/rxgk_app.c                               |   3 +-
 net/rxrpc/rxgk_common.h                            |   1 +
 net/rxrpc/rxkad.c                                  | 112 +++----
 net/rxrpc/skbuff.c                                 |   9 -
 net/smc/smc_clc.c                                  |   4 +-
 net/strparser/strparser.c                          |   8 +
 rust/kernel/dma.rs                                 |   3 -
 scripts/check-uapi.sh                              |   7 +-
 scripts/module.lds.S                               |  14 +-
 security/apparmor/lsm.c                            |  16 +-
 security/apparmor/path.c                           |   8 +-
 security/landlock/cred.c                           |   6 +-
 security/landlock/syscalls.c                       |  14 +-
 security/lsm.h                                     |   1 +
 security/lsm_init.c                                |   9 +
 security/security.c                                | 102 ++++++
 security/selinux/hooks.c                           | 256 +++++++++++----
 security/selinux/include/objsec.h                  |  11 +
 sound/aoa/soundbus/i2sbus/core.c                   |  12 +-
 sound/aoa/soundbus/i2sbus/pcm.c                    |  71 ++--
 sound/core/control.c                               |   4 +
 sound/core/misc.c                                  |  13 +-
 sound/core/seq/oss/seq_oss_rw.c                    |   6 +-
 sound/drivers/aloop.c                              |  43 ++-
 sound/drivers/pcmtest.c                            |  19 +-
 sound/hda/codecs/realtek/alc269.c                  |   1 +
 sound/pci/ctxfi/ctatc.c                            |   3 +-
 sound/usb/6fire/control.c                          |  10 +-
 sound/usb/caiaq/control.c                          |  52 ++-
 sound/usb/caiaq/device.c                           |  35 +-
 sound/usb/caiaq/input.c                            |   2 +-
 sound/usb/endpoint.c                               |   6 +-
 sound/usb/format.c                                 |   2 +-
 sound/usb/mixer.c                                  |   7 +-
 sound/usb/mixer_quirks.c                           |  12 +-
 tools/accounting/getdelays.c                       |  41 ++-
 tools/accounting/procacct.c                        |  40 ++-
 tools/perf/arch/loongarch/util/Build               |   1 -
 tools/perf/util/annotate-arch/annotate-loongarch.c |   1 +
 tools/perf/util/disasm.c                           |   2 +-
 tools/perf/util/disasm.h                           |   2 +
 tools/testing/ktest/ktest.pl                       |   2 +-
 tools/testing/selftests/kvm/x86/msrs_test.c        |   2 +-
 tools/testing/selftests/landlock/audit.h           | 105 ++++--
 tools/testing/selftests/landlock/audit_test.c      | 357 +++++++++++++++++++--
 tools/testing/selftests/landlock/net_test.c        |   2 +-
 tools/testing/selftests/landlock/ptrace_test.c     |   1 -
 .../selftests/landlock/scoped_abstract_unix_test.c |   1 -
 tools/testing/selftests/landlock/tsync_test.c      |  77 +++++
 .../testing/selftests/mqueue/{setting => settings} |   0
 tools/testing/selftests/vfio/lib/vfio_pci_device.c |   4 +-
 tools/testing/vma/include/dup.h                    |   7 +-
 tools/testing/vma/include/stubs.h                  |  13 +-
 329 files changed, 4508 insertions(+), 2269 deletions(-)


