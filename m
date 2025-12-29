Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74172155757;
	Mon, 29 Dec 2025 16:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024917; cv=none; b=H3S9lewbgH52bq37ocubdSpSKItnNpDzTV8/7j+uktbzHnsw7QjCBNLO3ecWJXr+BzD/xmgAwfDpEYx5PI7TurliSa7LGmTJJOtyQ20ZKXfCjb64qc2eYAkSEOZB7NJ54Npxqnlf75W9LaYMMf6Cy4pGGzXGa2KToXf823bLWSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024917; c=relaxed/simple;
	bh=AV7yhTFJ06HfXHU3MVDUSi/epQSYFEUWcT0y8DKbOok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cE+ZC3t5bplAHxK1KpHV3GwbCYb5Q43bVTAh6GAmWv8H1qeFpJEIbwyUIP8Zn2vuDVQf3yBwc+Mb19fHoQXSrOlt4ZUm/uw8CzYBXC74kvJpjzT32DyG+GzeGYobYDCzLUu80CshRgAsVxKXiwcEFT62ToY8VKYhPhtz+gG2sfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1nrG/5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1nrG/5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52A9C4CEF7;
	Mon, 29 Dec 2025 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024916;
	bh=AV7yhTFJ06HfXHU3MVDUSi/epQSYFEUWcT0y8DKbOok=;
	h=From:To:Cc:Subject:Date:From;
	b=m1nrG/5yA9MF0m5Jf22zJIOI8ZaOVfcw9htrrGs8/+3AwhIzlPPQ+3ZmKAXaz9zYv
	 tF40aSMMBut8XXOLiZK+xiJRBPhBvcFeuciPzpNGMTiaYWFpUK3iFBKeDv45pQObWK
	 WShCbLQcyVuqGXf3Wc+9ag188f7ts0zGG3BtbvrE=
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
Subject: [PATCH 6.18 000/430] 6.18.3-rc1 review
Date: Mon, 29 Dec 2025 17:06:42 +0100
Message-ID: <20251229160724.139406961@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.3-rc1
X-KernelTest-Deadline: 2025-12-31T16:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.3 release.
There are 430 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.3-rc1

Cheng Ding <cding@ddn.com>
    fuse: missing copy_finish in fuse-over-io-uring argument copies

Joanne Koong <joannelkoong@gmail.com>
    fuse: fix readahead reclaim deadlock

Joanne Koong <joannelkoong@gmail.com>
    fuse: fix io-uring list corruption for terminated non-committed requests

Johan Hovold <johan@kernel.org>
    iommu/mediatek: fix use-after-free on probe deferral

Damien Le Moal <dlemoal@kernel.org>
    block: freeze queue when updating zone resources

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama7g5: fix uart fifo size to 32

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama7d65: fix uart fifo size to 32

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: dts: microchip: sama5d2: fix spi flexcom fifo size to 32

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83l786ng) Convert macros to functions to avoid TOCTOU

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (w83791d) Convert macros to functions to avoid TOCTOU

Johan Hovold <johan@kernel.org>
    hwmon: (max6697) fix regmap leak on probe failure

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use local variable to avoid TOCTOU

Joanne Koong <joannelkoong@gmail.com>
    io_uring/rsrc: fix lost entries after cloned range

Raviteja Laggyshetty <quic_rlaggysh@quicinc.com>
    interconnect: qcom: sdx75: Drop QPIC interconnect and BCM nodes

Ma Ke <make24@iscas.ac.cn>
    i2c: amd-mp2: fix reference leak in MP2 PCI device

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: riscv: Depend on RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    platform/x86: intel: chtwc_int33fe: don't dereference swnode args

Biju Das <biju.das.jz@bp.renesas.com>
    pwm: rzg2l-gpt: Allow checking period_tick cache value only if sibling channel is enabled

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: fix rpmsg device leak

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_bpf: Stop tracing on user latency

Johan Hovold <johan@kernel.org>
    soc: amlogic: canvas: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: apple: mailbox: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: qcom: ocmem: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: qcom: pbs: fix device leak on lookup

Johan Hovold <johan@kernel.org>
    soc: samsung: exynos-pmu: fix device leak on regmap lookup

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix fixed array of synthetic event

Raghavendra Rao Ananta <rananta@google.com>
    vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()

Miaoqian Lin <linmq006@gmail.com>
    virtio: vdpa: Fix reference count leak in octep_sriov_enable()

Damien Le Moal <dlemoal@kernel.org>
    zloop: make the write pointer of full zones invalid

Damien Le Moal <dlemoal@kernel.org>
    zloop: fail zone append operations that are targeting full zones

Johan Hovold <johan@kernel.org>
    amba: tegra-ahb: Fix device leak on SMMU enable

Eric Biggers <ebiggers@kernel.org>
    crypto: arm64/ghash - Fix incorrect output from ghash-neon

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: caam - Add check for kcalloc() in test_len()

Shivani Agarwal <shivani.agarwal@broadcom.com>
    crypto: af_alg - zero initialize memory allocated via sock_kmalloc

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sm8550: Add missing required power-domains and resets

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sm8450: Add missing required power-domains and resets

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sm8350: Add missing required power-domains and resets

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sm8250: Add missing required power-domains and resets

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sm8150: Add missing required power-domains and resets

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sc8280xp: Add missing required power-domains and resets

Krzysztof Kozlowski <krzk@kernel.org>
    dt-bindings: PCI: qcom,pcie-sc7280: Add missing required power-domains and resets

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: pass iter to drm_find_displayid_extension()

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Fix scratch registers offsets for DCN351

Ray Wu <ray.wu@amd.com>
    drm/amd/display: Fix scratch registers offsets for DCN35

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()

Mario Limonciello <mario.limonciello@amd.com>
    Revert "drm/amd/display: Fix pbn to kbps Conversion"

Xi Ruoyao <xry111@xry111.site>
    gpio: loongson: Switch 2K2000/3000 GPIO to BYTE_CTRL_MODE

Askar Safin <safinaskar@gmail.com>
    gpiolib: acpi: Add quirk for Dell Precision 7780

Wentao Guan <guanwentao@uniontech.com>
    gpio: regmap: Fix memleak in error path in gpio_regmap_register()

Sven Schnelle <svens@linux.ibm.com>
    s390/ipl: Clear SBP flag when bootprog is set

Shakeel Butt <shakeel.butt@linux.dev>
    cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated

Filipe Manana <fdmanana@suse.com>
    btrfs: don't log conflicting inode if it's a dir moved in the current transaction

Nysal Jan K.A. <nysal@linux.ibm.com>
    powerpc/kexec: Enable SMT before waking offline CPUs

Joshua Rogers <linux@joshua.hu>
    SUNRPC: svcauth_gss: avoid NULL deref on zero length gss_token in gss_read_proxy_verf

Joshua Rogers <linux@joshua.hu>
    svcrdma: use rc_pageoff for memcpy byte offset

Joshua Rogers <linux@joshua.hu>
    svcrdma: return 0 on success from svc_rdma_copy_inline_range

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    nfsd: Mark variable __maybe_unused to avoid W=1 build break

Joshua Rogers <linux@joshua.hu>
    svcrdma: bound check rq_pages index in inline path

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Convert FLOAT to S32 during blob selection

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clear TIME_DELEG in the suppattr_exclcreat bitmap

Antheas Kapenekakis <lkml@antheas.dev>
    ALSA: hda/realtek: Add Asus quirk for TAS amplifiers

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Prefer 32-bit DMIC blobs for 8-bit formats as well

Chuck Lever <chuck.lever@oracle.com>
    NFSD: NFSv4 file creation neglects setting ACL

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clear SECLABEL in the suppattr_exclcreat bitmap

caoping <caoping@cmss.chinamobile.com>
    net/handshake: restore destructor on submit failure

Amir Goldstein <amir73il@gmail.com>
    fsnotify: do not generate ACCESS/MODIFY events on child for special files

Thorsten Blum <thorsten.blum@linux.dev>
    net: phy: marvell-88q2xxx: Fix clamped value in mv88q2xxx_hwmon_write

René Rebe <rene@exactco.de>
    r8169: fix RTL8117 Wake-on-Lan in DASH mode

Charles Mirabile <cmirabil@redhat.com>
    lib/crypto: riscv: Add poly1305-core.S to .gitignore

Mark Brown <broonie@kernel.org>
    arm64/gcs: Flush the GCS locking state on exec

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not clear needs_force_resume with enabled runtime PM

Steven Rostedt <rostedt@goodmis.org>
    tracing: Do not register unsupported perf events

Christoph Hellwig <hch@lst.de>
    xfs: validate that zoned RT devices are zone aligned

Darrick J. Wong <djwong@kernel.org>
    xfs: fix a UAF problem in xattr repair

Christoph Hellwig <hch@lst.de>
    xfs: fix the zoned RT growfs check for zone alignment

Darrick J. Wong <djwong@kernel.org>
    xfs: fix stupid compiler warning

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a memory leak in xfs_buf_item_init()

Gavin Shan <gshan@redhat.com>
    KVM: selftests: Add missing "break" in rseq_test's param parsing

Sean Christopherson <seanjc@google.com>
    KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)

Dongli Zhang <dongli.zhang@oracle.com>
    KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit

Sean Christopherson <seanjc@google.com>
    KVM: TDX: Explicitly set user-return MSRs that *may* be clobbered by the TDX-Module

Jim Mattson <jmattson@google.com>
    KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN

Wanpeng Li <wanpengli@tencent.com>
    KVM: Fix last_boosted_vcpu index assignment bug

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Propagate SVM_EXIT_CR0_SEL_WRITE correctly for LMSW emulation

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Forcefully override ARCH from x86_64 to x86

Jim Mattson <jmattson@google.com>
    KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Avoid incorrect injection of SVM_EXIT_CR0_SEL_WRITE

fuqiang wang <fuqiang.wng@gmail.com>
    KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer

fuqiang wang <fuqiang.wng@gmail.com>
    KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()

Sean Christopherson <seanjc@google.com>
    KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0

Finn Thain <fthain@linux-m68k.org>
    powerpc: Add reloc_offset() to font bitmap pointer used for bootx_printf()

Ilya Dryomov <idryomov@gmail.com>
    libceph: make decode_pool() more resilient against corrupted osdmaps

Vivian Wang <wangruikang@iscas.ac.cn>
    lib/crypto: riscv/chacha: Avoid s0/fp register

Dongsheng Yang <dongsheng.yang@linux.dev>
    dm-pcache: advance slot index before writing slot

Helge Deller <deller@gmx.de>
    parisc: Do not reprogram affinitiy on ASP chip

Zhichi Lin <zhichi.lin@vivo.com>
    scs: fix a wrong parameter in __scs_magic

Wangao Wang <wangao.wang@oss.qualcomm.com>
    media: iris: Add sanity check for stop streaming

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: Don't clear async #PF queue when CR0.PG is disabled (e.g. on #SMI)

Prithvi Tambewagh <activprithvi@gmail.com>
    ocfs2: fix kernel BUG in ocfs2_find_victim_chain

Jeongjun Park <aha310510@gmail.com>
    media: vidtv: initialize local pointers upon transfer of memory ownership

Deepanshu Kartikey <kartikey406@gmail.com>
    mm/slub: reset KASAN tag in defer_free() before accessing freed memory

Sean Christopherson <seanjc@google.com>
    KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix ISEL restore on resume

Alison Schofield <alison.schofield@intel.com>
    tools/testing/nvdimm: Use per-DIMM device handle

Chao Yu <chao@kernel.org>
    f2fs: fix return value of f2fs_recover_fsync_data()

Chao Yu <chao@kernel.org>
    f2fs: fix to not account invalid blocks in get_left_section_blocks()

Chao Yu <chao@kernel.org>
    f2fs: fix to detect recoverable inode during dryrun of find_fsync_dnodes()

Xiaole He <hexiaole1994@126.com>
    f2fs: fix uninitialized one_time_gc in victim_sel_policy

Xiaole He <hexiaole1994@126.com>
    f2fs: fix age extent cache insertion skip on counter overflow

Chao Yu <chao@kernel.org>
    f2fs: use global inline_xattr_slab instead of per-sb slab cache

Deepanshu Kartikey <kartikey406@gmail.com>
    f2fs: invalidate dentry cache on failed whiteout creation

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating zero-sized extent in extent cache

Chao Yu <chao@kernel.org>
    f2fs: fix to propagate error from f2fs_enable_checkpoint()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadlock

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid updating compression context during writeback

Jan Prusakowski <jprusakowski@google.com>
    f2fs: ensure node page reads complete before f2fs_put_super() finishes

Seunghwan Baek <sh8267.baek@samsung.com>
    scsi: ufs: core: Add ufshcd_update_evt_hist() for UFS suspend error

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Read missing IOCFacts flag for reply queue full overflow

Andrey Vatoropin <a.vatoropin@crpt.ru>
    scsi: target: Reset t_task_cdb pointer in error case

Dai Ngo <dai.ngo@oracle.com>
    NFSD: use correct reservation type in nfsd4_scsi_fence_client

Junrui Luo <moonafterrain@outlook.com>
    scsi: aic94xx: fix use-after-free in device removal path

Tony Battersby <tonyb@cybernetics.com>
    scsi: Revert "scsi: qla2xxx: Perform lockless command completion in abort path"

Miaoqian Lin <linmq006@gmail.com>
    cpufreq: nforce2: fix reference count leak in nforce2

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: teo: Drop misguided target residency check

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Check that the DMA cookie is valid

j.turek <jakub.turek@elsta.tech>
    serial: xilinx_uartps: fix rs485 delay_rts_after_send

Alexander Stein <alexander.stein@ew.tq-group.com>
    serial: core: Fix serial device initialization

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: core: Restore sysfs fwnode information

Junxiao Chang <junxiao.chang@intel.com>
    mei: gsc: add dependency on Xe driver

Ma Ke <make24@iscas.ac.cn>
    mei: Fix error handling in mei_register

Ma Ke <make24@iscas.ac.cn>
    intel_th: Fix error handling in intel_th_output_open

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    dt-bindings: slimbus: fix warning from example

Tianchu Chen <flynnnchen@tencent.com>
    char: applicom: fix NULL pointer dereference in ac_ioctl

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbgtty: fix device unregister: fixup

Haoxiang Li <haoxiang_li2024@163.com>
    usb: renesas_usbhs: Fix a resource leak in usbhs_pipe_malloc()

Udipto Goswami <udipto.goswami@oss.qualcomm.com>
    usb: dwc3: keep susphy enabled during exit to avoid controller faults

Miaoqian Lin <linmq006@gmail.com>
    usb: dwc3: of-simple: fix clock resource leak in dwc3_of_simple_probe

Johan Hovold <johan@kernel.org>
    usb: gadget: lpc32xx_udc: fix clock imbalance in error path

Johan Hovold <johan@kernel.org>
    usb: phy: isp1301: fix non-OF device reference imbalance

Duoming Zhou <duoming@zju.edu.cn>
    usb: phy: fsl-usb: Fix use-after-free in delayed work during device removal

Ma Ke <make24@iscas.ac.cn>
    USB: lpc32xx_udc: Fix error handling in probe

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    usb: typec: altmodes/displayport: Drop the device reference in dp_altmode_probe()

Arnd Bergmann <arnd@arndb.de>
    usb: typec: ucsi: huawei-gaokin: add DRM dependency

Johan Hovold <johan@kernel.org>
    usb: ohci-nxp: fix device leak on probe failure

Johan Hovold <johan@kernel.org>
    phy: broadcom: bcm63xx-usbh: fix section mismatches

Colin Ian King <colin.i.king@gmail.com>
    media: pvrusb2: Fix incorrect variable used in trace message

Jeongjun Park <aha310510@gmail.com>
    media: dvb-usb: dtv5100: fix out-of-bounds in dtv5100_i2c_msg()

Chen Changcheng <chenchangcheng@kylinos.cn>
    usb: usb-storage: Maintain minimal modifications to the bcdDevice range.

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid deadlock on fallback while reinjecting

Paolo Abeni <pabeni@redhat.com>
    mptcp: schedule rtx timer only after pushing data

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: ensure unknown flags are ignored

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ignore unknown endpoint flags

Harry Yoo <harry.yoo@oracle.com>
    mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction

Hans de Goede <johannes.goede@oss.qualcomm.com>
    dma-mapping: Fix DMA_BIT_MASK() macro being broken

Sourabh Jain <sourabhjain@linux.ibm.com>
    crash: let architecture decide crash memory export to iomem_resource

Jarkko Sakkinen <jarkko@kernel.org>
    tpm2-sessions: Fix tpm2_read_public range checks

Jarkko Sakkinen <jarkko@kernel.org>
    tpm2-sessions: Fix out of range indexing in name_size

Wei Yang <richard.weiyang@gmail.com>
    mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l2-mem2mem: Fix outdated documentation

xu xin <xu.xin16@zte.com.cn>
    mm/ksm: fix exec/fork inheritance support for prctl

Bart Van Assche <bvanassche@acm.org>
    block: Remove queue freezing from several sysfs store callbacks

Byungchul Park <byungchul@sk.com>
    jbd2: use a weaker annotation in journal handling

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jbd2: use a per-journal lock_class_key for jbd2_trans_commit_key

Baokun Li <libaokun1@huawei.com>
    ext4: align max orphan file size with e2fsprogs limit

Yongjian Sun <sunyongjian1@huawei.com>
    ext4: fix incorrect group number assertion in mb_check_buddy

Haibo Chen <haibo.chen@nxp.com>
    ext4: clear i_state_flags when alloc inode

Karina Yankevich <k.yankevich@omp.ru>
    ext4: xattr: fix null pointer deref in ext4_raw_inode()

Fedor Pchelkin <pchelkin@ispras.ru>
    ext4: check if mount_opts is NUL-terminated in ext4_ioctl_set_tune_sb()

Fedor Pchelkin <pchelkin@ispras.ru>
    ext4: fix string copying in parse_apply_sb_mount_options()

John Ogness <john.ogness@linutronix.de>
    printk: Avoid irq_work for printk_deferred() on suspend

John Ogness <john.ogness@linutronix.de>
    printk: Allow printk_trigger_flush() to flush all types

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    fs: PM: Fix reverse check in filesystems_freeze_callback()

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Cap the number of PCR banks

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Fix uninitialized var in config-bisect.pl

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: fix mount failure for sparse runs in run_unpack()

Zheng Yejian <zhengyejian@huaweicloud.com>
    kallsyms: Fix wrong "big" kernel symbol type read from procfs

Eric Biggers <ebiggers@kernel.org>
    crypto: scatterwalk - Fix memcpy_sglist() to always succeed

Rene Rebe <rene@exactco.de>
    floppy: fix for PAGE_SIZE != 4KB

Ye Bin <yebin10@huawei.com>
    jbd2: fix the inconsistency between checksum and data in memory for journal sb

Li Chen <chenl311@chinatelecom.cn>
    block: rate-limit capacity change info log

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    gfs2: fix freeze error handling

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't rewrite ret from inode_permission

Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
    wifi: mt76: Fix DTS power-limits on little endian systems

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix gendisk parent after copy pair swap

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit

Ma Ke <make24@iscas.ac.cn>
    perf: arm_cspmu: fix error handling in arm_cspmu_impl_unregister()

Ard Biesheuvel <ardb@kernel.org>
    efi: Add missing static initializer for efi_mm::cpus_allowed_lock

André Draszik <andre.draszik@linaro.org>
    phy: exynos5-usbdrd: fix clock prepare imbalance

Alexey Minnekhanov <alexeymin@postmarketos.org>
    dt-bindings: clock: mmcc-sdm660: Add missing MDSS reset

Sarthak Garg <sarthak.garg@oss.qualcomm.com>
    mmc: sdhci-msm: Avoid early clock doubling during HS400 transition

Avadhut Naik <avadhut.naik@amd.com>
    x86/mce: Do not clear bank's poll bit in mce_poll_banks on AMD SMCA systems

Tejun Heo <tj@kernel.org>
    sched_ext: Fix missing post-enqueue handling in move_local_task_to_local_dsq()

Tejun Heo <tj@kernel.org>
    sched_ext: Fix bypass depth leak on scx_enable() failure

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Fix the memleak for sch->helper objects

Tejun Heo <tj@kernel.org>
    sched_ext: Factor out local_dsq_post_enq() from dispatch_enqueue()

John Ogness <john.ogness@linutronix.de>
    printk: Avoid scheduling irq_work on suspend

Prithvi Tambewagh <activprithvi@gmail.com>
    io_uring: fix filename leak in __io_openat_prep()

Jens Axboe <axboe@kernel.dk>
    io_uring: fix min_wait wakeups for SQPOLL

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: correctly handle io_poll_add() return value on update

Johan Hovold <johan@kernel.org>
    clk: keystone: syscon-clk: fix regmap leak on probe failure

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix a memory leak in tpm2_load_cmd

Alice Ryhl <aliceryhl@google.com>
    rust: io: add typedef for phys_addr_t

Alice Ryhl <aliceryhl@google.com>
    rust: io: move ResourceSize to top-level io module

Alice Ryhl <aliceryhl@google.com>
    rust: io: define ResourceSize as resource_size_t

Marko Turk <mt@markoturk.info>
    samples: rust: fix endianness issue in rust_driver_pci

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: dma: add helpers for architectures without CONFIG_HAS_DMA

Alice Ryhl <aliceryhl@google.com>
    rust_binder: avoid mem::take on delivered_deaths

Lyude Paul <lyude@redhat.com>
    rust/drm/gem: Fix missing header in `Object` rustdoc

Zilin Guan <zilin@seu.edu.cn>
    cifs: Fix memory and information leak in smb3_reconfigure()

Stefano Garzarella <sgarzare@redhat.com>
    vhost/vsock: improve RCU read sections around vhost_vsock_get()

Dan Carpenter <dan.carpenter@linaro.org>
    block: rnbd-clt: Fix signedness bug in init_dev()

Caleb Sander Mateos <csander@purestorage.com>
    ublk: clean up user copy references on ublk server exit

Alok Tiwari <alok.a.tiwari@oracle.com>
    drm/msm/a6xx: move preempt_prepare_postamble after error check

Neil Armstrong <neil.armstrong@linaro.org>
    drm/msm: adreno: fix deferencing ifpc_reglist when not declared

John Garry <john.g.garry@oracle.com>
    scsi: scsi_debug: Fix atomic write enable module param description

Gregory CLEMENT <gregory.clement@bootlin.com>
    MIPS: ftrace: Fix memory corruption when kernel is located beyond 32 bits

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (emc2305) fix double put in emc2305_probe_childs_from_dt

Justin Tee <justintee8345@gmail.com>
    nvme-fabrics: add ENOKEY to no retry criteria for authentication failures

Pei Xiao <xiaopei01@kylinos.cn>
    hwmon: (emc2305) fix device node refcount leak in error path

Daniel Wagner <wagi@kernel.org>
    nvme-fc: don't hold rport lock when putting ctrl

Derek J. Clark <derekjohn.clark@gmail.com>
    platform/x86: wmi-gamezone: Add Legion Go 2 Quirks

Jinhui Guo <guojinhui.liam@bytedance.com>
    i2c: designware: Disable SMBus interrupts to prevent storms from mis-configured firmware

Jens Reidel <adrian@mainlining.org>
    clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk0_clk_src

Ian Rogers <irogers@google.com>
    libperf cpumap: Fix perf_cpu_map__max for an empty/NULL map

Wenhua Lin <Wenhua.Lin@unisoc.com>
    serial: sprd: Return -EPROBE_DEFER when uart clock is not ready

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Don't unchain link TRBs on quirky HCs

Chen Changcheng <chenchangcheng@kylinos.cn>
    usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: xhci: limit run_graceperiod for only usb 3.0 devices

Pei Xiao <xiaopei01@kylinos.cn>
    iio: adc: ti_am335x_adc: Limit step_avg to valid range for gcc complains

Mark Pearson <mpearson-lenovo@squebb.ca>
    usb: typec: ucsi: Handle incorrect num_connectors capability

Lizhi Xu <lizhi.xu@windriver.com>
    usbip: Fix locking bug in RT-enabled kernels

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: zero out post-EOF page cache on file extension

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix remount failure in different process environments

Encrow Thorne <jyc0019@gmail.com>
    reset: fix BIT macro reference

Al Viro <viro@zeniv.linux.org.uk>
    functionfs: fix the open/removal races

Li Qiang <liqiang01@kylinos.cn>
    via_wdt: fix critical boot hang due to unnamed resource allocation

Bernd Schubert <bschubert@ddn.com>
    fuse: Invalidate the page cache after FOPEN_DIRECT_IO write

Bernd Schubert <bschubert@ddn.com>
    fuse: Always flush the page cache before FOPEN_DIRECT_IO write

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Use reinit_completion on mbx_intr_comp

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Fix initiator mode with qlini_mode=exclusive

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Fix lost interrupts with qlini_mode=disabled

Ben Collins <bcollins@kernel.org>
    powerpc/addnote: Fix overflow on 32-bit builds

Josua Mayer <josua@solid-run.com>
    clk: mvebu: cp110 add CLK_IGNORE_UNUSED to pcie_x10, pcie_x11 & pcie_x4

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix reusing an ndlp that is marked NLP_DROPPED during FLOGI

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Add support for Hurray Data new controller PCI device

Matthias Schiffer <matthias.schiffer@tq-group.com>
    ti-sysc: allow OMAP2 and OMAP4 timers to be reserved on AM33xx

Johannes Berg <johannes.berg@intel.com>
    um: init cpu_tasks[] earlier

Peng Fan <peng.fan@nxp.com>
    firmware: imx: scu-irq: Init workqueue before request mbox channel

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Fix shutdown/suspend race condition

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix __scan_channels() failing to rescan channels

Jinhui Guo <guojinhui.liam@bytedance.com>
    ipmi: Fix the race between __scan_channels() and deliver_response()

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: ops: fix snd_soc_get_volsw for sx controls

Shuming Fan <shumingf@realtek.com>
    ASoC: SDCA: support Q7.8 volume format

Shardul Bankar <shardul.b@mpiricsoftware.com>
    nfsd: fix memory leak in nfsd_create_serv error paths

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: remove the reset operation in probe and remove

Shipei Qu <qu@darknavy.com>
    ALSA: usb-mixer: us16x08: validate meter packet indices

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: vxpocket: Fix resource leak in vxpocket_probe error path

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_sai: Constrain sample rates from audio PLLs only in master mode

Tal Zussman <tz2294@columbia.edu>
    x86/mm/tlb/trace: Export the TLB_REMOTE_WRONG_CPU enum in <trace/events/tlb.h>

Yongxin Liu <yongxin.liu@windriver.com>
    x86/fpu: Fix FPU state core dump truncation on CPUs with no extended xfeatures

Thomas Gleixner <tglx@linutronix.de>
    x86/msi: Make irq_retrigger() functional for posted MSI

Peter Zijlstra <peterz@infradead.org>
    x86/bug: Fix old GCC compile fails

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    net/hsr: fix NULL pointer dereference in prp_get_untagged_frame()

Andrew Jeffery <andrew@codeconstruct.com.au>
    dt-bindings: mmc: sdhci-of-aspeed: Switch ref to sdhci-common.yaml

Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
    mmc: sdhci-of-arasan: Increase CD stable timeout to 2 seconds

Jared Kangas <jkangas@redhat.com>
    mmc: sdhci-esdhc-imx: add alternate ARCH_S32 dependency to Kconfig

Christophe Leroy <christophe.leroy@csgroup.eu>
    spi: fsl-cpm: Check length parity before switching to 16 bit mode

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: CPPC: Fix missing PCC check for guaranteed_perf

Pengjie Zhang <zhangpengjie2@huawei.com>
    ACPI: PCC: Fix race condition by removing static qualifier

Yongxin Liu <yongxin.liu@windriver.com>
    platform/x86: intel_pmc_ipc: fix ACPI buffer memory leak

Kartik Rajput <kkartik@nvidia.com>
    soc/tegra: fuse: Do not register SoC device on ACPI boot

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_can_open(): fix error handling

Christoph Hellwig <hch@lst.de>
    xfs: don't leak a locked dquot when xfs_dquot_attach_buf fails

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table

Duoming Zhou <duoming@zju.edu.cn>
    Input: alps - fix use-after-free bugs caused by dev3_register_work

Minseong Kim <ii4gsp@gmail.com>
    Input: lkkbd - disable pending work before freeing device

Junjie Cao <junjie.cao@intel.com>
    Input: ti_am335x_tsc - fix off-by-one error in wire_order validation

Sanjay Govind <sanjay.govind9@gmail.com>
    Input: xpad - add support for CRKD Guitars

Sasha Finkelstein <fnkl.kernel@gmail.com>
    Input: apple_z2 - fix reading incorrect reports after exiting sleep

Ping Cheng <pinglinux@gmail.com>
    HID: input: map HID_GD_Z to ABS_DISTANCE for stylus/pen

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix buffer validation by including null terminator size in EA length

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: Fix refcount leak when invalid session is found on session lookup

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: skip lock-range check on equal size to avoid size==0 underflow

Nuno Sá <nuno.sa@analog.com>
    hwmon: (ltc4282): Fix reset_history file permissions

Rob Herring (Arm) <robh@kernel.org>
    arm64: dts: mediatek: Apply mt8395-radxa DT overlay at build time

Sairaj Kodilkar <sarunkod@amd.com>
    amd/iommu: Preserve domain ids inside the kdump kernel

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe/oa: Always set OAG_OAGLBCTXCTRL_COUNTER_RESUME

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/oa: Limit num_syncs to prevent oversized allocations

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Limit num_syncs to prevent oversized allocations

Thomas Fourier <fourier.thomas@gmail.com>
    block: rnbd-clt: Fix leaked ID in init_dev()

Ming Lei <ming.lei@redhat.com>
    ublk: fix deadlock when reading partition table

Ming Lei <ming.lei@redhat.com>
    ublk: refactor auto buffer register in ublk_dispatch_req()

Ming Lei <ming.lei@redhat.com>
    ublk: add `union ublk_io_buf` with improved naming

Ming Lei <ming.lei@redhat.com>
    ublk: add parameter `struct io_uring_cmd *` to ublk_prep_auto_buf_reg()

huang-jl <huang-jl@deepseek.com>
    io_uring: fix nr_segs calculation in io_import_kbuf

Anurag Dutta <a-dutta@ti.com>
    spi: cadence-quadspi: Fix clock disable on probe failure path

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix a job->pasid access race in gpu recovery

Jianpeng Chang <jianpeng.chang.cn@windriver.com>
    arm64: kdump: Fix elfcorehdr overlap caused by reserved memory processing reorder

Juergen Gross <jgross@suse.com>
    x86/xen: Fix sparse warning in enlighten_pv.c

Marijn Suijten <marijn.suijten@somainline.org>
    drm/panel: sony-td4353-jdi: Enable prepare_prev_first

Haoxiang Li <haoxiang_li2024@163.com>
    MIPS: Fix a reference leak bug in ip22_check_gio()

Jan Maslak <jan.maslak@intel.com>
    drm/xe: Restore engine registers before restarting schedulers after GT reset

Jagmeet Randhawa <jagmeet.randhawa@intel.com>
    drm/xe: Increase TDF timeout

Junxiao Chang <junxiao.chang@intel.com>
    drm/me/gsc: mei interrupt top half should be in irq disabled context

Arnd Bergmann <arnd@arndb.de>
    drm/xe: fix drm_gpusvm_init() arguments

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Apply Wa_14020316580 in xe_gt_idle_enable_pg()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Fix freq kobject leak on sysfs_create_files failure

Alexey Simakov <bigalex934@gmail.com>
    hwmon: (tmp401) fix overflow caused by default conversion rate value

Junrui Luo <moonafterrain@outlook.com>
    hwmon: (ibmpex) fix use-after-free in high/low store

Denis Sergeev <denserg.edu@gmail.com>
    hwmon: (dell-smm) Limit fan multiplier to avoid overflow

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: mpfs: Fix an error handling path in mpfs_spi_probe()

Prajna Rajendra Kumar <prajna.rajendrakumar@microchip.com>
    spi: microchip: rename driver file and internal identifiers

Ming Lei <ming.lei@redhat.com>
    block: fix race between wbt_enable_default and IO submission

Nilay Shroff <nilay@linux.ibm.com>
    block: use {alloc|free}_sched data methods

Nilay Shroff <nilay@linux.ibm.com>
    block: introduce alloc_sched_data and free_sched_data elevator methods

Nilay Shroff <nilay@linux.ibm.com>
    block: move elevator tags into struct elevator_resources

Nilay Shroff <nilay@linux.ibm.com>
    block: unify elevator tags and type xarrays into struct elv_change_ctx

Ming Lei <ming.lei@redhat.com>
    selftests: ublk: fix overflow in ublk_queue_auto_zc_fallback()

José Expósito <jose.exposito89@gmail.com>
    drm/tests: Handle EDEADLK in set_up_atomic_state()

José Expósito <jose.exposito89@gmail.com>
    drm/tests: Handle EDEADLK in drm_test_check_valid_clones()

José Expósito <jose.exposito89@gmail.com>
    drm/tests: hdmi: Handle drm_kunit_helper_enable_crtc_connector() returning EDEADLK

Jian Shen <shenjian15@huawei.com>
    net: hns3: add VLAN id validation before using

Jian Shen <shenjian15@huawei.com>
    net: hns3: using the num_tqps to check whether tqp_index is out of range when vf get ring info from mbx

Jian Shen <shenjian15@huawei.com>
    net: hns3: using the num_tqps in the vf driver to apply for resources

Wei Fang <wei.fang@nxp.com>
    net: enetc: do not transmit redirected XDP frames when the link is down

Scott Mayhew <smayhew@redhat.com>
    net/handshake: duplicate handshake cancellations leak socket

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Don't include PSP in the hard MTU calculations

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Trigger neighbor resolution for unresolved destinations

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Use ip6_dst_lookup instead of ipv6_dst_lookup_flow for MAC init

Shay Drory <shayd@nvidia.com>
    net/mlx5: Serialize firmware reset with devlink

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Handle escaped percent properly

Shay Drory <shayd@nvidia.com>
    net/mlx5: fw_tracer, Validate format string parameters

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Drain firmware reset in shutdown callback

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: fw reset, clear reset requested on drain_fw_reset

Gal Pressman <gal@nvidia.com>
    ethtool: Avoid overflowing userspace buffer on stats query

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: make j1939_sk_bind() fail if device is no longer registered

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd/selftest: Check for overflow in IOMMU_TEST_OP_ADD_RESERVED

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd/selftest: Make it clearer to gcc that the access is not out of bounds

Florian Westphal <fw@strlen.de>
    selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: remove redundant chain validation on register store

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: remove bogus direction check

Dan Carpenter <dan.carpenter@linaro.org>
    nfc: pn533: Fix error code in pn533_acr122_poweron_rdr()

Victor Nogueira <victor@mojatatu.com>
    net/sched: ets: Remove drr class from the active list if it changes to strict

Junrui Luo <moonafterrain@outlook.com>
    caif: fix integer underflow in cffrml_receive()

Florian Westphal <fw@strlen.de>
    selftests: netfilter: prefer xfail in case race wasn't triggered

Slavin Liu <slavin452@gmail.com>
    ipvs: fix ipv4 null-ptr-deref in route error path

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_conncount: fix leaked ct in error paths

Jakub Kicinski <kuba@kernel.org>
    inet: frags: flush pending skbs in fqdir_pre_exit()

Jakub Kicinski <kuba@kernel.org>
    inet: frags: add inet_frag_queue_flush()

Jakub Kicinski <kuba@kernel.org>
    inet: frags: avoid theoretical race in ip_frag_reinit()

Guenter Roeck <linux@roeck-us.net>
    selftests: net: tfo: Fix build warning

Guenter Roeck <linux@roeck-us.net>
    selftests: net: Fix build warnings

Guenter Roeck <linux@roeck-us.net>
    selftest: af_unix: Support compilers without flex-array-member-not-at-end support

Alexey Simakov <bigalex934@gmail.com>
    broadcom: b44: prevent uninitialized value usage

Arnd Bergmann <arnd@arndb.de>
    net: ti: icssg-prueth: add PTP_1588_CLOCK_OPTIONAL dependency

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix middle attribute validation in push_nsh() action

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix XDP_TX path

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_mr: Fix use-after-free when updating multicast route stats

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix neighbour use-after-free

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix possible neighbour reference count leak

Gerd Bayer <gbayer@linux.ibm.com>
    net/mlx5: Fix double unregister of HCA_PORTS component

Dmitry Skorodumov <skorodumov.dmitry@huawei.com>
    ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()

Ivan Galkin <ivan.galkin@axis.com>
    net: phy: RTL8211FVD: Restore disabling of PHY-mode EEE

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: realtek: create rtl8211f_config_phy_eee() helper

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: realtek: eliminate priv->phycr1 variable

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: realtek: allow CLKOUT to be disabled on RTL8211F(D)(I)-VD-CG

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: realtek: eliminate has_phycr2 variable

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: phy: realtek: eliminate priv->phycr2 variable

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Avoid unregistering PSP twice

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: make enable_mpesw idempotent

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: ets: Always remove class from active list before deleting in ets_qdisc_change

Wang Liang <wangliang74@huawei.com>
    netrom: Fix memory leak in nr_sendmsg()

Wei Fang <wei.fang@nxp.com>
    net: fec: ERR007885 Workaround for XDP TX path

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix use of bio_chain

Max Chou <max.chou@realtek.com>
    Bluetooth: btusb: Add new VID/PID 0x0489/0xE12F for RTL8852BE-VT

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: btusb: Add new VID/PID 13d3/3533 for RTL8821CE

Shuai Zhang <quic_shuaz@quicinc.com>
    Bluetooth: btusb: add new custom firmwares

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7920: Add VID/PID 0489/e135

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btusb: MT7922: Add VID/PID 0489/e170

Chingbin Li <liqb365@163.com>
    Bluetooth: btusb: Add new VID/PID 2b89/6275 for RTL8761BUV

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: vfs: fix race on m_flags in vfs_cache

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix return value of smb2_ioctl()

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix "gfs2: Switch to wait_event in gfs2_quotad"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: fix remote evict for read-only filesystems

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/101

Qu Wenruo <wqu@suse.com>
    btrfs: scrub: always update btrfs_scrub_progress::last_physical

Hans de Goede <hansg@kernel.org>
    wifi: brcmfmac: Add DMI nvram filename quirk for Acer A1 840 tablet

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt792x: fix wifi init fail by setting MCU_RUNNING after CLC load

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: use cfg80211_leave() in iftype change

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: stop radar detection in cfg80211_leave()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix HT40 channel config for RTL8192CU, RTL8723AU

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: check for shutdown in fsync

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/073

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    hfsplus: Verify inode mode when loading from disk

Yang Chenzhi <yang.chenzhi@vivo.com>
    hfsplus: fix missing hfs_bnode_get() in __hfs_bnode_create

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix volume corruption issue for generic/070

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ntfs: set dummy blocksize to read boot_block when mounting

Mikhail Malyshev <mike.malyshev@gmail.com>
    kbuild: Use objtree for module signing key path

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Support timestamps prior to epoch

Mario Limonciello (AMD) <superm1@kernel.org>
    crypto: ccp - Add support for PCI device 0x115A

Song Liu <song@kernel.org>
    livepatch: Match old_sympos 0 and 1 in klp_find_func()

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    scripts: kdoc_parser.py: warn about Python version only once

Yu Peng <pengyu@kylinos.cn>
    x86/microcode: Mark early_parse_cmdline() as __init

Aboorva Devarajan <aboorvad@linux.ibm.com>
    cpuidle: menu: Use residency threshold in polling state override decisions

Shuhao Fu <sfual@cse.ust.hk>
    cpufreq: s5pv210: fix refcount leak

Armin Wolf <W_Armin@gmx.de>
    ACPI: fan: Workaround for 64-bit firmware bug

Hal Feng <hal.feng@starfivetech.com>
    cpufreq: dt-platdev: Add JH7110S SOC to the allowlist

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only

Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
    ACPICA: Avoid walking the Namespace if start_node is NULL

Peter Zijlstra <peterz@infradead.org>
    x86/ptrace: Always inline trivial accessors

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Revert max_newidle_lb_cost bump

Doug Berger <opendmb@gmail.com>
    sched/deadline: only set free_cpus for online runqueues

George Kennedy <george.kennedy@oracle.com>
    perf/x86/amd: Check event before enable to avoid GPF

Pankaj Raghav <p.raghav@samsung.com>
    scripts/faddr2line: Fix "Argument list too long" error

Joanne Koong <joannelkoong@gmail.com>
    iomap: account for unaligned end offsets when truncating read range

Joanne Koong <joannelkoong@gmail.com>
    iomap: adjust read range correctly for non-block-aligned positions

Al Viro <viro@zeniv.linux.org.uk>
    shmem: fix recovery on rename failures

Filipe Manana <fdmanana@suse.com>
    btrfs: fix changeset leak on mmap write after failure to reserve metadata

Deepanshu Kartikey <kartikey406@gmail.com>
    btrfs: fix memory leak of fs_devices in degraded seed device path

Shuran Liu <electronlsr@gmail.com>
    bpf: Fix verifier assumptions of bpf_d_path's output buffer

T.J. Mercier <tjmercier@google.com>
    bpf: Fix truncated dmabuf iterator reads

Ondrej Mosnacek <omosnace@redhat.com>
    bpf, arm64: Do not audit capability check in do_jit()

Qu Wenruo <wqu@suse.com>
    btrfs: fix a potential path leak in print_data_reloc_error()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not skip logging new dentries when logging a new name


-------------

Diffstat:

 .../devicetree/bindings/mmc/aspeed,sdhci.yaml      |   2 +-
 .../devicetree/bindings/pci/qcom,pcie-sc7280.yaml  |   5 +
 .../bindings/pci/qcom,pcie-sc8280xp.yaml           |   3 +
 .../devicetree/bindings/pci/qcom,pcie-sm8150.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8250.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8350.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8450.yaml  |   5 +
 .../devicetree/bindings/pci/qcom,pcie-sm8550.yaml  |   5 +
 .../devicetree/bindings/slimbus/slimbus.yaml       |  16 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/sama5d2.dtsi           |  10 +-
 arch/arm/boot/dts/microchip/sama7d65.dtsi          |   6 +-
 arch/arm/boot/dts/microchip/sama7g5.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/Makefile              |   2 +
 arch/arm64/crypto/ghash-ce-glue.c                  |   2 +-
 arch/arm64/kernel/process.c                        |   1 +
 arch/arm64/net/bpf_jit_comp.c                      |   2 +-
 arch/mips/kernel/ftrace.c                          |  25 ++-
 arch/mips/sgi-ip22/ip22-gio.c                      |   3 +-
 arch/powerpc/boot/addnote.c                        |   7 +-
 arch/powerpc/include/asm/crash_reserve.h           |   8 +
 arch/powerpc/kernel/btext.c                        |   3 +-
 arch/powerpc/kexec/core_64.c                       |  19 ++
 arch/riscv/crypto/Kconfig                          |  12 +-
 arch/s390/include/uapi/asm/ipl.h                   |   1 +
 arch/s390/kernel/ipl.c                             |  48 +++--
 arch/um/kernel/process.c                           |   4 +-
 arch/um/kernel/um_arch.c                           |   2 -
 arch/x86/events/amd/core.c                         |   7 +-
 arch/x86/include/asm/bug.h                         |   2 +-
 arch/x86/include/asm/irq_remapping.h               |   7 +
 arch/x86/include/asm/kvm_host.h                    |   1 -
 arch/x86/include/asm/ptrace.h                      |  20 +-
 arch/x86/kernel/cpu/mce/threshold.c                |   3 +-
 arch/x86/kernel/cpu/microcode/core.c               |   2 +-
 arch/x86/kernel/fpu/xstate.c                       |   4 +-
 arch/x86/kernel/irq.c                              |  23 +++
 arch/x86/kvm/cpuid.c                               |  11 +-
 arch/x86/kvm/lapic.c                               |  32 +++-
 arch/x86/kvm/svm/nested.c                          |   6 +-
 arch/x86/kvm/svm/svm.c                             |  54 ++++--
 arch/x86/kvm/svm/svm.h                             |   7 +-
 arch/x86/kvm/vmx/nested.c                          |   3 +-
 arch/x86/kvm/vmx/tdx.c                             |  56 +++---
 arch/x86/kvm/vmx/tdx.h                             |   1 -
 arch/x86/kvm/x86.c                                 |  34 ++--
 arch/x86/xen/enlighten_pv.c                        |   2 +-
 block/bfq-iosched.c                                |   2 +-
 block/blk-mq-sched.c                               | 117 +++++++++---
 block/blk-mq-sched.h                               |  40 +++-
 block/blk-mq.c                                     |  50 ++---
 block/blk-sysfs.c                                  |  28 +--
 block/blk-wbt.c                                    |  20 +-
 block/blk-wbt.h                                    |   5 +
 block/blk-zoned.c                                  |  42 +++--
 block/blk.h                                        |   7 +-
 block/elevator.c                                   |  84 ++++-----
 block/elevator.h                                   |  27 ++-
 block/genhd.c                                      |   2 +-
 crypto/af_alg.c                                    |   5 +-
 crypto/algif_hash.c                                |   3 +-
 crypto/algif_rng.c                                 |   3 +-
 crypto/scatterwalk.c                               |  95 ++++++++--
 drivers/acpi/acpi_pcc.c                            |   2 +-
 drivers/acpi/acpica/nswalk.c                       |   9 +-
 drivers/acpi/cppc_acpi.c                           |   3 +-
 drivers/acpi/fan.h                                 |  33 ++++
 drivers/acpi/fan_hwmon.c                           |  10 +-
 drivers/acpi/property.c                            |   8 +-
 drivers/amba/tegra-ahb.c                           |   1 +
 drivers/android/binder/process.rs                  |   8 +-
 drivers/base/power/runtime.c                       |  22 ++-
 drivers/block/floppy.c                             |   2 +-
 drivers/block/rnbd/rnbd-clt.c                      |  13 +-
 drivers/block/rnbd/rnbd-clt.h                      |   2 +-
 drivers/block/ublk_drv.c                           | 139 +++++++++-----
 drivers/block/zloop.c                              |  12 +-
 drivers/bluetooth/btusb.c                          |  11 ++
 drivers/bus/ti-sysc.c                              |  11 +-
 drivers/char/applicom.c                            |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  20 +-
 drivers/char/tpm/tpm-chip.c                        |   1 -
 drivers/char/tpm/tpm1-cmd.c                        |   5 -
 drivers/char/tpm/tpm2-cmd.c                        |  34 +++-
 drivers/char/tpm/tpm2-sessions.c                   | 194 ++++++++++++-------
 drivers/clk/keystone/syscon-clk.c                  |   2 +-
 drivers/clk/mvebu/cp110-system-controller.c        |  20 ++
 drivers/clk/qcom/dispcc-sm7150.c                   |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/cpufreq/cpufreq-nforce2.c                  |   3 +
 drivers/cpufreq/s5pv210-cpufreq.c                  |   6 +-
 drivers/cpuidle/governors/menu.c                   |   9 +-
 drivers/cpuidle/governors/teo.c                    |   7 +-
 drivers/crypto/caam/caamrng.c                      |   4 +-
 drivers/crypto/ccp/sp-pci.c                        |  19 ++
 drivers/firmware/efi/efi.c                         |   3 +
 drivers/firmware/imx/imx-scu-irq.c                 |   4 +-
 drivers/gpio/gpio-loongson-64bit.c                 |  10 +-
 drivers/gpio/gpio-regmap.c                         |   2 +-
 drivers/gpio/gpiolib-acpi-quirks.c                 |  22 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  10 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  59 +++---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c   |   2 +-
 .../amd/display/dc/resource/dcn35/dcn35_resource.c |   8 +-
 .../display/dc/resource/dcn351/dcn351_resource.c   |   8 +-
 drivers/gpu/drm/drm_displayid.c                    |  19 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  18 +-
 drivers/gpu/drm/msm/adreno/a6xx_preempt.c          |   4 +-
 drivers/gpu/drm/panel/panel-sony-td4353-jdi.c      |   2 +
 drivers/gpu/drm/tests/drm_atomic_state_test.c      |  40 +++-
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 143 ++++++++++++++
 drivers/gpu/drm/xe/xe_device.c                     |   2 +-
 drivers/gpu/drm/xe/xe_exec.c                       |   3 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   7 +-
 drivers/gpu/drm/xe/xe_gt_freq.c                    |   4 +-
 drivers/gpu/drm/xe/xe_gt_idle.c                    |   8 +
 drivers/gpu/drm/xe/xe_heci_gsc.c                   |   4 +-
 drivers/gpu/drm/xe/xe_oa.c                         |  10 +-
 drivers/gpu/drm/xe/xe_svm.h                        |   2 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   3 +
 drivers/gpu/drm/xe/xe_wa.c                         |   8 -
 drivers/gpu/drm/xe/xe_wa_oob.rules                 |   1 +
 drivers/hid/hid-input.c                            |  18 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   9 +
 drivers/hwmon/emc2305.c                            |   8 +-
 drivers/hwmon/ibmpex.c                             |   9 +-
 drivers/hwmon/ltc4282.c                            |   9 +-
 drivers/hwmon/max16065.c                           |   7 +-
 drivers/hwmon/max6697.c                            |   2 +-
 drivers/hwmon/tmp401.c                             |   2 +-
 drivers/hwmon/w83791d.c                            |  19 +-
 drivers/hwmon/w83l786ng.c                          |  26 ++-
 drivers/hwtracing/intel_th/core.c                  |  20 +-
 drivers/i2c/busses/i2c-amd-mp2-pci.c               |   5 +-
 drivers/i2c/busses/i2c-designware-core.h           |   1 +
 drivers/i2c/busses/i2c-designware-master.c         |   7 +
 drivers/iio/adc/ti_am335x_adc.c                    |   2 +-
 drivers/input/joystick/xpad.c                      |   5 +
 drivers/input/keyboard/lkkbd.c                     |   5 +-
 drivers/input/mouse/alps.c                         |   1 +
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/input/touchscreen/apple_z2.c               |   4 +
 drivers/input/touchscreen/ti_am335x_tsc.c          |   2 +-
 drivers/interconnect/qcom/sdx75.c                  |  26 ---
 drivers/interconnect/qcom/sdx75.h                  |   2 -
 drivers/iommu/amd/init.c                           |  23 ++-
 drivers/iommu/intel/irq_remapping.c                |   8 +-
 drivers/iommu/iommufd/selftest.c                   |   8 +-
 drivers/iommu/mtk_iommu.c                          |  25 ++-
 drivers/md/dm-pcache/cache.c                       |   8 +-
 drivers/md/dm-pcache/cache_segment.c               |   8 +-
 drivers/media/platform/qcom/iris/iris_vb2.c        |   8 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   3 +
 drivers/media/usb/dvb-usb/dtv5100.c                |   5 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   2 +-
 drivers/misc/mei/Kconfig                           |   2 +-
 drivers/misc/mei/main.c                            |   1 +
 drivers/mmc/host/Kconfig                           |   4 +-
 drivers/mmc/host/sdhci-msm.c                       |  27 +--
 drivers/mmc/host/sdhci-of-arasan.c                 |   2 +-
 drivers/net/can/usb/gs_usb.c                       |   2 +-
 drivers/net/ethernet/broadcom/b44.c                |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   3 +-
 drivers/net/ethernet/freescale/fec_main.c          |   7 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   5 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  97 ++++++++--
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  48 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  27 +--
 drivers/net/ethernet/realtek/r8169_main.c          |   5 +-
 drivers/net/ethernet/ti/Kconfig                    |   3 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   3 +
 drivers/net/phy/marvell-88q2xxx.c                  |   2 +-
 drivers/net/phy/realtek/realtek_main.c             | 114 ++++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  14 ++
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  37 ++--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   7 +-
 drivers/nfc/pn533/usb.c                            |   2 +-
 drivers/nvme/host/fabrics.c                        |   2 +-
 drivers/nvme/host/fc.c                             |   6 +-
 drivers/of/fdt.c                                   |   2 +-
 drivers/parisc/gsc.c                               |   4 +-
 drivers/perf/arm_cspmu/arm_cspmu.c                 |   4 +-
 drivers/phy/broadcom/phy-bcm63xx-usbh.c            |   6 +-
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |  71 ++++---
 drivers/platform/chrome/cros_ec_ishtp.c            |   1 +
 drivers/platform/x86/intel/chtwc_int33fe.c         |  29 ++-
 drivers/platform/x86/intel/hid.c                   |  12 ++
 drivers/platform/x86/lenovo/wmi-gamezone.c         |  17 +-
 drivers/pwm/pwm-rzg2l-gpt.c                        |  15 +-
 drivers/rpmsg/qcom_glink_native.c                  |   8 +
 drivers/s390/block/dasd_eckd.c                     |   8 +
 drivers/scsi/aic94xx/aic94xx_init.c                |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       |  36 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   4 +-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h                |   1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   2 +
 drivers/scsi/qla2xxx/qla_def.h                     |   1 -
 drivers/scsi/qla2xxx/qla_gbl.h                     |   2 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  32 +---
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +
 drivers/scsi/qla2xxx/qla_mid.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/scsi_debug.c                          |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   4 +
 drivers/soc/amlogic/meson-canvas.c                 |   5 +-
 drivers/soc/apple/mailbox.c                        |  15 +-
 drivers/soc/qcom/ocmem.c                           |   2 +-
 drivers/soc/qcom/qcom-pbs.c                        |   2 +
 drivers/soc/samsung/exynos-pmu.c                   |   2 +
 drivers/soc/tegra/fuse/fuse-tegra.c                |   2 -
 drivers/spi/Kconfig                                |  19 +-
 drivers/spi/Makefile                               |   2 +-
 drivers/spi/spi-cadence-quadspi.c                  |   4 +-
 drivers/spi/spi-fsl-spi.c                          |   2 +-
 drivers/spi/{spi-microchip-core.c => spi-mpfs.c}   | 208 +++++++++++----------
 drivers/target/target_core_transport.c             |   1 +
 drivers/tty/serial/serial_base_bus.c               |  11 +-
 drivers/tty/serial/sh-sci.c                        |   2 +-
 drivers/tty/serial/sprd_serial.c                   |   6 +
 drivers/tty/serial/xilinx_uartps.c                 |  14 +-
 drivers/ufs/core/ufshcd.c                          |   5 +-
 drivers/ufs/host/ufs-mediatek.c                    |   5 +
 drivers/usb/dwc3/dwc3-of-simple.c                  |   7 +-
 drivers/usb/dwc3/gadget.c                          |   2 +-
 drivers/usb/dwc3/host.c                            |   2 +-
 drivers/usb/gadget/function/f_fs.c                 |  53 +++++-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  21 ++-
 drivers/usb/host/ohci-nxp.c                        |   2 +
 drivers/usb/host/xhci-dbgtty.c                     |   2 +-
 drivers/usb/host/xhci-hub.c                        |   2 +-
 drivers/usb/host/xhci-ring.c                       |  27 +--
 drivers/usb/phy/phy-fsl-usb.c                      |   1 +
 drivers/usb/phy/phy-isp1301.c                      |   7 +-
 drivers/usb/renesas_usbhs/pipe.c                   |   2 +
 drivers/usb/storage/unusual_uas.h                  |   2 +-
 drivers/usb/typec/altmodes/displayport.c           |   8 +-
 drivers/usb/typec/ucsi/Kconfig                     |   1 +
 drivers/usb/typec/ucsi/ucsi.c                      |   6 +
 drivers/usb/usbip/vhci_hcd.c                       |   6 +-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c           |   1 +
 drivers/vfio/device_cdev.c                         |   2 +-
 drivers/vhost/vsock.c                              |  15 +-
 drivers/watchdog/via_wdt.c                         |   1 +
 fs/btrfs/file.c                                    |   3 +-
 fs/btrfs/inode.c                                   |   1 +
 fs/btrfs/ioctl.c                                   |   4 +-
 fs/btrfs/scrub.c                                   |   5 +
 fs/btrfs/tree-log.c                                |  46 ++++-
 fs/btrfs/volumes.c                                 |   1 +
 fs/exfat/file.c                                    |   5 +
 fs/exfat/super.c                                   |  19 +-
 fs/ext4/ialloc.c                                   |   1 -
 fs/ext4/inode.c                                    |   1 -
 fs/ext4/ioctl.c                                    |   4 +
 fs/ext4/mballoc.c                                  |   2 +
 fs/ext4/orphan.c                                   |   4 +-
 fs/ext4/super.c                                    |   6 +-
 fs/ext4/xattr.c                                    |   6 +-
 fs/f2fs/compress.c                                 |   5 +-
 fs/f2fs/data.c                                     |  17 ++
 fs/f2fs/extent_cache.c                             |   5 +-
 fs/f2fs/f2fs.h                                     |  13 +-
 fs/f2fs/file.c                                     |  12 +-
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/namei.c                                    |   6 +-
 fs/f2fs/recovery.c                                 |  20 +-
 fs/f2fs/segment.c                                  |   9 +-
 fs/f2fs/segment.h                                  |   8 +-
 fs/f2fs/super.c                                    | 116 +++++-------
 fs/f2fs/xattr.c                                    |  32 ++--
 fs/f2fs/xattr.h                                    |  10 +-
 fs/fuse/dev.c                                      |   2 +-
 fs/fuse/dev_uring.c                                |   6 +-
 fs/fuse/file.c                                     |  37 +++-
 fs/fuse/fuse_dev_i.h                               |   1 +
 fs/gfs2/glops.c                                    |   3 +-
 fs/gfs2/lops.c                                     |   2 +-
 fs/gfs2/quota.c                                    |   2 +-
 fs/gfs2/super.c                                    |   4 +-
 fs/hfsplus/bnode.c                                 |   4 +-
 fs/hfsplus/dir.c                                   |   7 +-
 fs/hfsplus/hfsplus_fs.h                            |   2 +
 fs/hfsplus/inode.c                                 |  41 +++-
 fs/hfsplus/super.c                                 |  87 +++++----
 fs/iomap/buffered-io.c                             |  41 +++-
 fs/jbd2/journal.c                                  |  20 +-
 fs/jbd2/transaction.c                              |   2 +-
 fs/libfs.c                                         |  50 +++--
 fs/nfsd/blocklayout.c                              |   3 +-
 fs/nfsd/export.c                                   |   2 +-
 fs/nfsd/nfs4xdr.c                                  |   5 +
 fs/nfsd/nfsd.h                                     |   8 +-
 fs/nfsd/nfssvc.c                                   |   5 +-
 fs/nfsd/vfs.h                                      |   3 +-
 fs/notify/fsnotify.c                               |   9 +-
 fs/ntfs3/file.c                                    |  14 +-
 fs/ntfs3/ntfs_fs.h                                 |   9 +-
 fs/ntfs3/run.c                                     |   6 +-
 fs/ntfs3/super.c                                   |   5 +
 fs/ocfs2/suballoc.c                                |  10 +
 fs/smb/client/fs_context.c                         |   2 +
 fs/smb/server/mgmt/tree_connect.c                  |  18 +-
 fs/smb/server/mgmt/tree_connect.h                  |   1 -
 fs/smb/server/mgmt/user_session.c                  |   4 +-
 fs/smb/server/smb2pdu.c                            |  16 +-
 fs/smb/server/vfs.c                                |   5 +-
 fs/smb/server/vfs_cache.c                          |  88 ++++++---
 fs/super.c                                         |   2 +-
 fs/xfs/libxfs/xfs_sb.c                             |  15 ++
 fs/xfs/scrub/attr_repair.c                         |   2 +-
 fs/xfs/xfs_attr_item.c                             |   2 +-
 fs/xfs/xfs_buf_item.c                              |   1 +
 fs/xfs/xfs_qm.c                                    |   5 +-
 fs/xfs/xfs_rtalloc.c                               |  14 +-
 include/crypto/scatterwalk.h                       |  52 +++---
 include/dt-bindings/clock/qcom,mmcc-sdm660.h       |   1 +
 include/linux/blkdev.h                             |   2 +-
 include/linux/crash_reserve.h                      |   6 +
 include/linux/dma-mapping.h                        |   2 +-
 include/linux/fs.h                                 |   2 +-
 include/linux/jbd2.h                               |   6 +
 include/linux/ksm.h                                |   4 +-
 include/linux/platform_data/x86/intel_pmc_ipc.h    |   4 +-
 include/linux/reset.h                              |   1 +
 include/linux/slab.h                               |   7 +
 include/linux/tpm.h                                |  21 ++-
 include/media/v4l2-mem2mem.h                       |   3 +-
 include/net/inet_frag.h                            |  18 +-
 include/net/ipv6_frag.h                            |   9 +-
 include/sound/soc.h                                |   1 +
 include/trace/events/tlb.h                         |   5 +-
 include/uapi/drm/xe_drm.h                          |   1 +
 include/uapi/linux/mptcp.h                         |   1 +
 io_uring/io_uring.c                                |   3 +
 io_uring/openclose.c                               |   2 +-
 io_uring/poll.c                                    |   9 +-
 io_uring/rsrc.c                                    |  13 +-
 kernel/bpf/dmabuf_iter.c                           |  56 +++++-
 kernel/cgroup/rstat.c                              |  13 +-
 kernel/crash_reserve.c                             |   3 +
 kernel/kallsyms.c                                  |   5 +-
 kernel/livepatch/core.c                            |   8 +-
 kernel/printk/internal.h                           |   8 +-
 kernel/printk/nbcon.c                              |   9 +-
 kernel/printk/printk.c                             |  83 ++++++--
 kernel/sched/cpudeadline.c                         |  34 +---
 kernel/sched/cpudeadline.h                         |   4 +-
 kernel/sched/deadline.c                            |   8 +-
 kernel/sched/ext.c                                 |  62 ++++--
 kernel/sched/fair.c                                |  19 +-
 kernel/scs.c                                       |   2 +-
 kernel/trace/bpf_trace.c                           |   2 +-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_synth.c                  |   1 -
 lib/crypto/Kconfig                                 |   9 +-
 lib/crypto/riscv/.gitignore                        |   2 +
 lib/crypto/riscv/chacha-riscv64-zvkb.S             |   5 +-
 lib/crypto/x86/blake2s-core.S                      |   4 +-
 mm/huge_memory.c                                   |   2 +-
 mm/ksm.c                                           |  20 +-
 mm/shmem.c                                         |  24 ++-
 mm/slab.h                                          |   1 +
 mm/slab_common.c                                   |  52 ++++--
 mm/slub.c                                          |  59 +++---
 net/caif/cffrml.c                                  |   9 +-
 net/can/j1939/socket.c                             |   6 +
 net/ceph/osdmap.c                                  | 116 ++++++------
 net/ethtool/ioctl.c                                |  30 ++-
 net/handshake/request.c                            |   8 +-
 net/hsr/hsr_forward.c                              |   2 +
 net/ipv4/inet_fragment.c                           |  55 +++++-
 net/ipv4/ip_fragment.c                             |  22 +--
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.c                               |  22 ++-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   3 +
 net/netfilter/nf_conncount.c                       |  25 +--
 net/netfilter/nf_nat_core.c                        |  14 +-
 net/netfilter/nf_tables_api.c                      |  11 --
 net/netrom/nr_out.c                                |   4 +-
 net/openvswitch/flow_netlink.c                     |  13 +-
 net/sched/sch_ets.c                                |   6 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |   3 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   7 +-
 net/wireless/core.c                                |   1 +
 net/wireless/core.h                                |   1 +
 net/wireless/mlme.c                                |  19 ++
 net/wireless/util.c                                |  23 +--
 rust/helpers/dma.c                                 |  21 +++
 rust/kernel/devres.rs                              |  18 +-
 rust/kernel/drm/gem/mod.rs                         |   2 +-
 rust/kernel/io.rs                                  |  26 ++-
 rust/kernel/io/resource.rs                         |  13 +-
 samples/rust/rust_driver_pci.rs                    |   2 +-
 scripts/Makefile.modinst                           |   2 +-
 scripts/faddr2line                                 |  13 +-
 scripts/lib/kdoc/kdoc_parser.py                    |   7 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  35 +++-
 sound/hda/codecs/realtek/alc269.c                  |  11 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c                 |   8 +-
 sound/pcmcia/vx/vxpocket.c                         |   8 +-
 sound/soc/codecs/ak4458.c                          |   4 -
 sound/soc/fsl/fsl_sai.c                            |  10 +-
 sound/soc/sdca/sdca_asoc.c                         |  34 +---
 sound/soc/soc-ops.c                                |  84 +++++++--
 sound/soc/sof/ipc4-topology.c                      |  24 ++-
 sound/usb/mixer_us16x08.c                          |  20 +-
 tools/lib/perf/cpumap.c                            |  10 +-
 tools/testing/ktest/config-bisect.pl               |   4 +-
 tools/testing/nvdimm/test/nfit.c                   |   7 +-
 tools/testing/selftests/iommu/iommufd.c            |   8 +-
 tools/testing/selftests/kvm/Makefile               |   2 +-
 tools/testing/selftests/kvm/rseq_test.c            |   1 +
 tools/testing/selftests/net/af_unix/Makefile       |   7 +-
 tools/testing/selftests/net/lib/ksft.h             |   6 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   4 +
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |  11 ++
 .../selftests/net/netfilter/conntrack_clash.sh     |   9 +-
 .../net/netfilter/conntrack_reverse_clash.c        |  13 +-
 .../net/netfilter/conntrack_reverse_clash.sh       |   2 +
 .../packetdrill/conntrack_syn_challenge_ack.pkt    |   2 +-
 tools/testing/selftests/net/tfo.c                  |   3 +-
 tools/testing/selftests/ublk/kublk.h               |  12 +-
 tools/tracing/rtla/src/timerlat.bpf.c              |   3 +
 virt/kvm/kvm_main.c                                |   4 +-
 441 files changed, 4077 insertions(+), 1949 deletions(-)


