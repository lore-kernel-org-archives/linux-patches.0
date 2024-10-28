Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909AA47;
	Mon, 28 Oct 2024 06:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097980; cv=none; b=JFqducwLVOCKqNcHQWeyXtkTMDaF3lyLyvGHGdLff/XXMxuOaRu4BAuwdDyshkg1CZ0y6k4vPbfNpG0HJxEoD9NKMJtQyCOKJrZbzc1+nKx7Z3LdmRwLRd2R1bLZoWBXG0ru7ZwA/z97Ojo700HVW9JYJjLPwYRu4WjPVIsT5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097980; c=relaxed/simple;
	bh=u9p7VSAELRpVvBFz6UMWVcZv82FXTD8tLlfm920pYKc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hJkwqAmQpYAjgcerapMJ99JBwuBidsa3q5z/UeKg/KeNVCyVBUSwQnQTSWCTpCwCCWi+DQ8hW1/iVBWDu0FFl6yF3Wf0vIpiy24wjh3S+uJDUyGygn/kBW47sisYbez0is1/kv+arNOdKQDuOfm9jbt+ceuVDvLcYjRbZI78qfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkDYYj0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkDYYj0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13973C4CEC3;
	Mon, 28 Oct 2024 06:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097980;
	bh=u9p7VSAELRpVvBFz6UMWVcZv82FXTD8tLlfm920pYKc=;
	h=From:To:Cc:Subject:Date:From;
	b=tkDYYj0/vnmJ/sIY1BgwS2QwPxyNouujEcrAM4mZ56L8HpdrCs/wMvbrShHX7RLtu
	 mMgXBNEkjPmoBK1A2I4NIgnLUmWoncVbVr2ReiWt4gKskukAxf90yqLv01i7c3VYIF
	 vtmoDY58yh0wJ82xaCSyeggAn5jB8eOByX1vXIiE=
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
Subject: [PATCH 6.11 000/261] 6.11.6-rc1 review
Date: Mon, 28 Oct 2024 07:22:22 +0100
Message-ID: <20241028062312.001273460@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.6-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.11.6-rc1
X-KernelTest-Deadline: 2024-10-30T06:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.11.6 release.
There are 261 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.6-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.11.6-rc1

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: Select missing common Soundwire module code on SDM845

Dan Carpenter <dan.carpenter@linaro.org>
    ACPI: PRM: Clean up guid type in struct prm_handler_info

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi: Ignore suspend notifications

Linus Torvalds <torvalds@linux-foundation.org>
    x86: fix user address masking non-canonical speculation issue

Linus Torvalds <torvalds@linux-foundation.org>
    x86: fix whitespace in runtime-const assembler output

Linus Torvalds <torvalds@linux-foundation.org>
    x86: support user address masking instead of non-speculative conditional

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    soundwire: intel_ace2x: Send PDI stream number during prepare

Dominique Martinet <asmadeus@codewreck.org>
    Revert "fs/9p: simplify iget to remove unnecessary paths"

Dominique Martinet <asmadeus@codewreck.org>
    Revert "fs/9p: fix uaf in in v9fs_stat2inode_dotl"

Dominique Martinet <asmadeus@codewreck.org>
    Revert "fs/9p: remove redundant pointer v9ses"

Dominique Martinet <asmadeus@codewreck.org>
    Revert " fs/9p: mitigate inode collisions"

Zichen Xie <zichenxie0106@gmail.com>
    ASoC: qcom: Fix NULL Dereference in asoc_qcom_lpass_cpu_platform_probe()

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sdm845: add missing soundwire runtime stream alloc

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: sc7280: Fix missing Soundwire runtime stream alloc

Benjamin Bara <benjamin.bara@skidata.com>
    ASoC: dapm: avoid container_of() to get component

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: ipc4-topology: Do not set ALH node_id for aggregated DAIs

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: Always clean up link DMA during stop

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: Intel: hda: Handle prepare without close for non-HDA DAI's

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: hda-loader: do not wait for HDaudio IOC

Niklas Cassel <cassel@kernel.org>
    ata: libata: Set DID_TIME_OUT for commands that actually timed out

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: temp w/a for DP Link Layer compliance

Xinyu Zhang <xizhang@purestorage.com>
    block: fix sanity checks in blk_rq_map_user_bvec

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: fix race between laundromat and free_stateid

Michel Alex <Alex.Michel@wiedemann-group.com>
    net: phy: dp83822: Fix reset pin definitions

Steven Rostedt <rostedt@goodmis.org>
    fgraph: Change the name of cpuhp state to "fgraph:online"

Li Huafei <lihuafei1@huawei.com>
    fgraph: Fix missing unlock in register_ftrace_graph()

Vamsi Krishna Brahmajosyula <vamsikrishna.brahmajosyula@gmail.com>
    platform/x86/intel/pmc: Fix pmc_core_iounmap to call iounmap for valid addresses

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Disable PSR-SU on Parade 08-01 TCON too

Abel Vesa <abel.vesa@linaro.org>
    drm/bridge: Fix assignment of the of_node of the parent to aux bridge

Yu Kuai <yukuai3@huawei.com>
    md/raid10: fix null ptr dereference in raid10_size()

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event

Petr Vaganov <p.vaganov@ideco.ru>
    xfrm: fix one more kernel-infoleak in algo dumping

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make KASAN usable for variable cpu_vabits

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Enable IRQ if do_ale() triggered in irq-enabled context

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Get correct cores_per_package for SMT systems

José Relvas <josemonsantorelvas@gmail.com>
    ALSA: hda/realtek: Add subwoofer quirk for Acer Predator G9-593

Eric Biggers <ebiggers@google.com>
    ALSA: hda/tas2781: select CRC32 instead of CRC32_SARWATE

Ashish Kalra <ashish.kalra@amd.com>
    x86/sev: Ensure that RMP table fixups are reserved

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/lam: Disable ADDRESS_MASKING in most cases

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: core: fix invalid port index for parent device

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Don't eagerly teardown the vgic on init error

Ilkka Koskinen <ilkka@os.amperecomputing.com>
    KVM: arm64: Fix shift-out-of-bounds bug

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Unregister redistributor for failed vCPU creation

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Ignore nCR3[4:0] when loading PDPTEs from memory

Aleksa Sarai <cyphar@cyphar.com>
    openat2: explicitly return -E2BIG for (usize > PAGE_SIZE)

Darrick J. Wong <djwong@kernel.org>
    xfs: don't fail repairs on metadata files with no attr fork

Christian Brauner <brauner@kernel.org>
    fs: don't try and remove empty rbtree node

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of buffer delay flag

Shubham Panwar <shubiisp8@gmail.com>
    ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue

Koba Ko <kobak@nvidia.com>
    ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context

Christian Heusel <christian@heusel.eu>
    ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Guard against bad data for ATIF ACPI method

Boris Burkov <boris@bur.io>
    btrfs: fix read corruption due to race with extent map merging

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix zone unusable accounting for freed reserved extent

Qu Wenruo <wqu@suse.com>
    btrfs: reject ro->rw reconfiguration if there are hard ro requirements

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    perf/x86/rapl: Fix the energy-pkg event for AMD CPUs

Richard Gong <richard.gong@amd.com>
    x86/amd_nb: Add new PCI ID for AMD family 1Ah model 20h

Richard Gong <richard.gong@amd.com>
    x86/amd_nb: Add new PCI IDs for AMD family 1Ah model 60h-70h

Yue Haibing <yuehaibing@huawei.com>
    btrfs: fix passing 0 to ERR_PTR in btrfs_search_dir_index_item()

Filipe Manana <fdmanana@suse.com>
    btrfs: clear force-compress on remount when compress mount option is given

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: set a more sane default value for subtree drop threshold

liwei <liwei728@huawei.com>
    cpufreq: CPPC: fix perf_to_khz/khz_to_perf conversion exception

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    PCI/pwrctl: Abandon QCom WCN probe on pre-pwrseq device-trees

Konrad Dybcio <konradybcio@kernel.org>
    PCI/pwrctl: Add WCN6855 support

Ye Bin <yebin10@huawei.com>
    cifs: fix warning when destroy 'cifs_io_request_pool'

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: Handle kstrdup failures for passwords

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Update default depop procedure

Yang Erkun <yangerkun@huaweicloud.com>
    nfsd: cancel nfsd_shrinker_work using sync mode in nfs4_state_shutdown_net

Yuan Can <yuancan@huawei.com>
    powercap: dtpm_devfreq: Fix error check against dev_pm_qos_add_request()

Arnd Bergmann <arnd@arndb.de>
    fbdev: wm8505fb: select CONFIG_FB_IOMEM_FOPS

Andrey Shumilin <shum.sdl@nppct.ru>
    ALSA: firewire-lib: Avoid division by zero in apply_constraint_to_size()

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_micfil: Add a flag to distinguish with different volume control types

Amir Goldstein <amir73il@gmail.com>
    fuse: update inode size after extending passthrough write

Amir Goldstein <amir73il@gmail.com>
    fs: pass offset and result to backing_file end_write() callback

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    PCI: Hold rescan lock while adding devices during host probe

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    ASoC: rsnd: Fix probe failure on HiHope boards due to endpoint parsing

Colin Ian King <colin.i.king@gmail.com>
    ASoC: max98388: Fix missing increment of variable slot_found

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Bump minimal topology ABI version

Binbin Zhou <zhoubinbin@loongson.cn>
    ASoC: loongson: Fix component check failed on FDT systems

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: dt-bindings: davinci-mcasp: Fix interrupt properties

Miquel Raynal <miquel.raynal@bootlin.com>
    ASoC: dt-bindings: davinci-mcasp: Fix interrupts property

Hou Tao <houtao1@huawei.com>
    bpf: Add the missing BPF_LINK_TYPE invocation for sockmap

Shenghao Yang <me@shenghaoyang.info>
    net: dsa: mv88e6xxx: support 4000ps cycle counter period

Shenghao Yang <me@shenghaoyang.info>
    net: dsa: mv88e6xxx: read cycle counter period from hardware

Shenghao Yang <me@shenghaoyang.info>
    net: dsa: mv88e6xxx: group cycle counter coefficients

Tim Harvey <tharvey@gateworks.com>
    net: dsa: microchip: disable EEE for KSZ879x/KSZ877x/KSZ876x

Andrii Nakryiko <andrii@kernel.org>
    bpf: fix do_misc_fixups() for bpf_get_branch_snapshot()

Jiri Olsa <jolsa@kernel.org>
    bpf,perf: Fix perf_event_detach_bpf_prog error handling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix UAF on iso_sock_timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_sock_timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Disable works on hci_unregister_dev

Jinjie Ruan <ruanjinjie@huawei.com>
    posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: avoid unsolicited interrupts

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: use RCU read-side critical section in taprio_dump()

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: fix use-after-free in taprio_change()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: act_api: deny mismatched skip_sw/skip_hw flags for actions created by classifiers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Remove MEM_UNINIT from skb/xdp MTU helpers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix overloading of MEM_UNINIT's meaning

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add MEM_WRITE attribute

Hou Tao <houtao1@huawei.com>
    bpf: Preserve param->string when parsing mount options

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix name regression

Yuan Can <yuancan@huawei.com>
    mlxsw: spectrum_router: fix xa_store() error checking

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix integer overflow in stats

Eric Dumazet <edumazet@google.com>
    net: fix races in netdev_tx_sent_queue()/dev_watchdog()

Lin Ma <linma@zju.edu.cn>
    net: wwan: fix global oob in wwan_rtnl_policy

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xtables: fix typo causing some targets not to load on IPv6

Aleksandr Mishin <amishin@t-argos.ru>
    fsl/fman: Fix refcount handling of fman-related devices

Aleksandr Mishin <amishin@t-argos.ru>
    fsl/fman: Save device references taken in mac_probe()

Peter Collingbourne <pcc@google.com>
    bpf, arm64: Fix address emission with tag-based KASAN enabled

Peter Rashleigh <peter@rashleigh.ca>
    net: dsa: mv88e6xxx: Fix error when setting port policy on mv88e6393x

Aleksandr Mishin <amishin@t-argos.ru>
    octeon_ep: Add SKB allocation failures handling in __octep_oq_process_rx()

Aleksandr Mishin <amishin@t-argos.ru>
    octeon_ep: Implement helper for iterating packets in Rx queue

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    bnxt_en: replace ptp_lock with irqsave variant

Jakub Boehm <boehm.jakub@gmail.com>
    net: plip: fix break; causing plip to never transmit

Wang Hai <wanghai38@huawei.com>
    be2net: fix potential memory leak in be_xmit()

Wang Hai <wanghai38@huawei.com>
    net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()

Kory Maincent <kory.maincent@bootlin.com>
    net: pse-pd: Fix out of bound for loop

Florian Westphal <fw@strlen.de>
    netfilter: bpf: must hold reference on net namespace

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: validate new SA's prefixlen using SA family when sel.family is unset

Eyal Birger <eyal.birger@gmail.com>
    xfrm: respect ip protocols rules criteria when performing dst lookups

Eyal Birger <eyal.birger@gmail.com>
    xfrm: extract dst lookup parameters into a struct

Leo Yan <leo.yan@arm.com>
    tracing: Consider the NULL character when validating the event length

Mikel Rychliski <mikel@mikelr.com>
    tracing/probes: Fix MAX_TRACE_ARGS limit handling

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: Fix sanity check in dbMount

Viktor Malik <vmalik@redhat.com>
    objpool: fix choosing allocation for percpu slots

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    LoongArch: Don't crash in stack_top() for tasks without vDSO

Crag Wang <crag_wang@dell.com>
    platform/x86: dell-sysman: add support for alienware products

Pali Rohár <pali@kernel.org>
    cifs: Validate content of NFS reparse point buffer

Gustavo Sousa <gustavo.sousa@intel.com>
    drm/xe/mcr: Use Xe2_LPM steering tables for Xe2_HPM

Jan Kara <jack@suse.cz>
    fsnotify: Avoid data race between fsnotify_recalc_mask() and fsnotify_object_watched()

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: add qrb4210-rb2-sndcard compatible string

Gianfranco Trad <gianf.trad@gmail.com>
    udf: fix uninit-value use in udf_get_fileshortad

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor inode_bmap() to handle error

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor udf_next_aext() to handle error

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    udf: refactor udf_current_aext() to handle error

Mark Rutland <mark.rutland@arm.com>
    arm64: Force position-independent veneers

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Enable 'FIFO continue on error' FCONT bit

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: lpass-rx-macro: add missing CDC_RX_BCL_VBAT_RF_PROC2 to default regs values

David Lawrence Glanzman <davidglanzman@yahoo.com>
    ASoC: amd: yc: Add quirk for HP Dragonfly pro one

Hans de Goede <hdegoede@redhat.com>
    drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA

Qiao Ma <mqaio@linux.alibaba.com>
    uprobe: avoid out-of-bounds memory access of fetching args

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: honor usb transfer size boundaries.

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    xhci: dbgtty: use kfifo from tty_port struct

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    xhci: dbgtty: remove kfifo_out() wrapper

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: adc: ti-lmp92064: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig

David Hildenbrand <david@redhat.com>
    mm: don't install PMD mappings when THPs are disabled by the hw/process/vma

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: huge_memory: add vma_thp_disabled() and thp_disabled_by_hw()

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()

Steven Rostedt <rostedt@goodmis.org>
    fgraph: Allocate ret_stack_list with proper size

Josh Poimboeuf <jpoimboe@kernel.org>
    cdrom: Avoid barrier_nospec() in cdrom_ioctl_media_changed()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix print_reg_state's constant scalar dump

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect delta propagation between linked registers

Jordan Rome <linux@jordanrome.com>
    bpf: Fix iter/task tid filtering

Maurizio Lombardi <mlombard@redhat.com>
    nvme-pci: fix race condition between reset and nvme_dev_disable()

Andrea Parri <parri.andrea@gmail.com>
    riscv, bpf: Make BPF_CMPXCHG fully ordered

Michal Luczaj <mhal@rbox.co>
    bpf, vsock: Drop static vsock_bpf_prot initialization

Michal Luczaj <mhal@rbox.co>
    vsock: Update msg_count on read_skb()

Michal Luczaj <mhal@rbox.co>
    vsock: Update rx_bytes on read_skb()

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: SK_DROP on attempted redirects of unsupported af_vsock

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Don't call cleanup on profile rollback failure

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Unregister notifier on eswitch init failure

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix command bitmask initialization

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Check for invalid vector index on EQ creation

Felix Fietkau <nbd@nbd.name>
    net: ethernet: mtk_eth_soc: fix memory corruption during fq dma init

Daniel Borkmann <daniel@iogearbox.net>
    vmxnet3: Fix packet corruption in vmxnet3_xdp_xmit_frame

Ye Bin <yebin10@huawei.com>
    Bluetooth: bnep: fix wild-memory-access in proto_unregister

Tyrone Wu <wudevelops@gmail.com>
    bpf: Fix link info netfilter flags to populate defrag flag

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use bookkeep slots for external BO's in exec IOCTL

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Don't free job in TDR

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Take job list lock in xe_sched_add_pending_job

Matthew Auld <matthew.auld@intel.com>
    drm/xe: fix unbalanced rpm put() with declare_wedged()

Matthew Auld <matthew.auld@intel.com>
    drm/xe: fix unbalanced rpm put() with fence_fini()

Heiko Carstens <hca@linux.ibm.com>
    s390: Initialize psw mask in perf_arch_fetch_caller_regs()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    usb: typec: altmode should keep reference to parent

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix OOBs when building SMB2_IOCTL request

Su Hui <suhui@nfschina.com>
    smb: client: fix possible double free in smb2_set_ea()

Wang Hai <wanghai38@huawei.com>
    scsi: target: core: Fix null-ptr-deref in target_alloc_device()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: vsc73xx: fix reception from VLAN-unaware bridges

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: ravb: Only advertise Rx/Tx timestamps if hardware supports it

Gal Pressman <gal@nvidia.com>
    ravb: Remove setting of RX software timestamp

Eric Dumazet <edumazet@google.com>
    genetlink: hold RCU in genlmsg_mcast()

Peter Rashleigh <peter@rashleigh.ca>
    net: dsa: mv88e6xxx: Fix the max_vid definition for the MV88E6361

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx+: Insert a fence wait before SMMU table update

Wang Hai <wanghai38@huawei.com>
    net: bcmasp: fix potential memory leak in bcmasp_xmit()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: don't always program merge_3d block

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: Don't always set merge_3d pending flush

Fabrizio Castro <fabrizio.castro.jz@renesas.com>
    irqchip/renesas-rzg2l: Fix missing put_device

Wang Hai <wanghai38@huawei.com>
    net: systemport: fix potential memory leak in bcm_sysport_xmit()

Dimitar Kanaliev <dimitar.kanaliev@siteground.com>
    bpf: Fix truncation bug in coerce_reg_to_size_sx()

Wang Hai <wanghai38@huawei.com>
    net: ethernet: rtsn: fix potential memory leak in rtsn_start_xmit()

Wang Hai <wanghai38@huawei.com>
    net: xilinx: axienet: fix potential memory leak in axienet_start_xmit()

Li RongQing <lirongqing@baidu.com>
    net/smc: Fix searching in list of known pnetids in smc_pnet_add_pnetid

Wang Hai <wanghai38@huawei.com>
    net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()

Eric Dumazet <edumazet@google.com>
    netdevsim: use cond_resched() in nsim_dev_trap_report_work()

Sabrina Dubroca <sd@queasysnail.net>
    macsec: don't increment counters for an unrelated SA

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/amdgpu: Fix double unlock in amdgpu_mes_add_ring

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Fix reader locking when changing the sub buffer order

Colin Ian King <colin.i.king@gmail.com>
    octeontx2-af: Fix potential integer overflows on integer shifts

Paritosh Dixit <paritoshd@nvidia.com>
    net: stmmac: dwmac-tegra: Fix link bring-up sequence

Oliver Neukum <oneukum@suse.com>
    net: usb: usbnet: fix race in probe failure

Jean Delvare <jdelvare@suse.de>
    [PATCH} hwmon: (jc42) Properly detect TSE2004-compliant devices again

Kai Shen <KaiShen@linux.alibaba.com>
    net/smc: Fix memory leak when using percpu refs

Justin Chen <justin.chen@broadcom.com>
    firmware: arm_scmi: Queue in scmi layer for mailbox implementation

Douglas Anderson <dianders@chromium.org>
    drm/msm: Allocate memory for disp snapshot with kvzalloc()

Douglas Anderson <dianders@chromium.org>
    drm/msm: Avoid NULL dereference in msm_disp_state_print_regs()

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation

Jonathan Marek <jonathan@marek.ca>
    drm/msm/dsi: improve/fix dsc pclk calculation

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: check for overflow in _dpu_crtc_setup_lm_bounds()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: move CRTC resource assignment to dpu_encoder_virt_atomic_check

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: make sure phys resources are properly initialized

Cong Yang <yangcong5@huaqin.corp-partner.google.com>
    drm/panel: himax-hx83102: Adjust power and gamma to optimize brightness

Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
    accel/qaic: Fix the for loop used to walk SG table

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix the GID table length

Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
    RDMA/bnxt_re: Fix a bug while setting up Level-2 PBL pages

Chandramohan Akula <chandramohan.akula@broadcom.com>
    RDMA/bnxt_re: Change the sequence of updating the CQ toggle value

Hongguang Gao <hongguang.gao@broadcom.com>
    RDMA/bnxt_re: Get the toggle bits from SRQ events

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid CPU lockups due fifo occupancy check loop

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Return more meaningful error

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix incorrect dereference of srq in async event

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix out of bound check

Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
    RDMA/bnxt_re: Fix the max CQ WQEs for older adapters

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: fix source port register when mirroring

Xin Long <lucien.xin@gmail.com>
    ipv4: give an IPv4 dev to blackhole_netdev

Breno Leitao <leitao@debian.org>
    elevator: Remove argument from elevator_find_get

Breno Leitao <leitao@debian.org>
    elevator: do not request_module if elevator exists

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Make slab cache names unique

Alexander Zubkov <green@qrator.net>
    RDMA/irdma: Fix misspelling of "accept*"

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP

Su Hui <suhui@nfschina.com>
    firmware: arm_scmi: Fix the double free in scmi_debugfs_common_setup()

Murad Masimov <m.masimov@maxima.ru>
    ALSA: hda/cs8409: Fix possible NULL dereference

Waiman Long <longman@redhat.com>
    sched/core: Disable page allocation in task_tick_mm_cid()

Tyrone Wu <wudevelops@gmail.com>
    bpf: Fix unpopulated path_size when uprobe_multi fields unset

Tony Ambardar <tony.ambardar@gmail.com>
    selftests/bpf: Fix cross-compiling urandom_read

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Handle possible ENOMEM in vmw_stdu_connector_atomic_check

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: frequency: admv4420: fix missing select REMAP_SPI in Kconfig

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: frequency: {admv4420,adrf6780}: format Kconfig entries

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: fix kfunc btf caching for modules

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Handle PCI error codes other than 0x3a

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Fix possible infinite tailcall when CONFIG_CFI_CLANG is enabled

Tyrone Wu <wudevelops@gmail.com>
    selftests/bpf: fix perf_event link info name_len assertion

Tyrone Wu <wudevelops@gmail.com>
    bpf: fix unpopulated name_len field in perf_event link info

Hou Tao <houtao1@huawei.com>
    bpf: Check the remaining info_cnt before repeating btf fields

Yao Zi <ziyao@disroot.org>
    clk: rockchip: fix finding of maximum clock ID

Florian Klink <flokli@flokli.de>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix HDMI hpd-gpio pin

Martin Kletzander <nert.pinx@gmail.com>
    x86/resctrl: Avoid overflow in MB settings in bw_validate()

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    RDMA/core: Fix ENODEV error for iWARP test over vlan

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Add a check for memory allocation

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Fix incorrect AVID type in WQE structure

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix a possible memory leak

Jiri Olsa <jolsa@kernel.org>
    bpf: Fix memory leak in bpf_core_apply

Timo Grautstueck <timo.grautstueck@web.de>
    lib/Kconfig.debug: fix grammar in RUST_BUILD_ASSERT_ALLOW

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq/amd-pstate: Fix amd_pstate mode switch on shared memory systems

Florian Kauer <florian.kauer@linutronix.de>
    bpf: devmap: provide rxq after redirect

Andrew Jones <ajones@ventanamicro.com>
    irqchip/riscv-imsic: Fix output text of base address

Toke Høiland-Jørgensen <toke@redhat.com>
    bpf: Make sure internal and UAPI bpf_redirect flags don't overlap

Eduard Zingerman <eddyz87@gmail.com>
    bpf: sync_linked_regs() must preserve subreg_def

Changhuang Liang <changhuang.liang@starfivetech.com>
    reset: starfive: jh71x0: Fix accessing the empty member on JH7110 SoC

Mikhail Lobanov <m.lobanov@rosalinux.ru>
    iio: accel: bma400: Fix uninitialized variable field_value in tap event handling.

Wander Lairson Costa <wander.lairson@gmail.com>
    bpf: Use raw_spinlock_t in ringbuf


-------------

Diffstat:

 .../bindings/sound/davinci-mcasp-audio.yaml        |  18 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/broadcom/bcm2837-rpi-cm3-io3.dts |   2 +-
 arch/arm64/Makefile                                |   2 +-
 arch/arm64/kvm/arm.c                               |   3 +
 arch/arm64/kvm/sys_regs.c                          |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  28 ++-
 arch/arm64/net/bpf_jit_comp.c                      |  12 +-
 arch/loongarch/include/asm/bootinfo.h              |   4 +
 arch/loongarch/include/asm/kasan.h                 |   2 +-
 arch/loongarch/kernel/process.c                    |  14 +-
 arch/loongarch/kernel/setup.c                      |   3 +-
 arch/loongarch/kernel/traps.c                      |   5 +
 arch/riscv/net/bpf_jit_comp64.c                    |   8 +-
 arch/s390/include/asm/perf_event.h                 |   1 +
 arch/s390/pci/pci_event.c                          |  17 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/events/rapl.c                             |  47 ++++-
 arch/x86/include/asm/runtime-const.h               |   4 +-
 arch/x86/include/asm/uaccess_64.h                  |  45 +++--
 arch/x86/kernel/amd_nb.c                           |   6 +
 arch/x86/kernel/cpu/common.c                       |  10 +
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c          |  23 ++-
 arch/x86/kernel/vmlinux.lds.S                      |   1 +
 arch/x86/kvm/svm/nested.c                          |   6 +-
 arch/x86/lib/getuser.S                             |   9 +-
 arch/x86/virt/svm/sev.c                            |   2 +
 block/blk-map.c                                    |   4 +-
 block/elevator.c                                   |  17 +-
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/accel/qaic/qaic_data.c                     |   6 +-
 drivers/acpi/button.c                              |  11 ++
 drivers/acpi/cppc_acpi.c                           |  22 ++-
 drivers/acpi/prmt.c                                |  29 ++-
 drivers/acpi/resource.c                            |   7 +
 drivers/ata/libata-eh.c                            |   1 +
 drivers/cdrom/cdrom.c                              |   2 +-
 drivers/clk/rockchip/clk.c                         |   2 +-
 drivers/cpufreq/amd-pstate.c                       |  10 +
 drivers/firewire/core-topology.c                   |   2 +-
 drivers/firmware/arm_scmi/driver.c                 |   4 +-
 drivers/firmware/arm_scmi/mailbox.c                |  32 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   5 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |  13 ++
 .../drm/amd/display/modules/power/power_helpers.c  |   2 +
 drivers/gpu/drm/bridge/aux-bridge.c                |   3 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  16 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c           |  20 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  68 ++++---
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   |   7 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   5 +-
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c  |  19 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   4 +-
 drivers/gpu/drm/panel/panel-himax-hx83102.c        |  12 +-
 drivers/gpu/drm/vboxvideo/hgsmi_base.c             |  10 +-
 drivers/gpu/drm/vboxvideo/vboxvideo.h              |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_stdu.c               |   4 +
 drivers/gpu/drm/xe/xe_device.c                     |   4 +-
 drivers/gpu/drm/xe/xe_exec.c                       |  12 +-
 drivers/gpu/drm/xe/xe_gpu_scheduler.h              |   2 +
 drivers/gpu/drm/xe/xe_gt_mcr.c                     |   2 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |  29 ++-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h        |   1 -
 drivers/gpu/drm/xe/xe_guc_submit.c                 |   7 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   8 +-
 drivers/hwmon/jc42.c                               |   2 +-
 drivers/iio/accel/bma400_core.c                    |   3 +-
 drivers/iio/adc/Kconfig                            |   2 +
 drivers/iio/frequency/Kconfig                      |  31 ++--
 drivers/infiniband/core/addr.c                     |   2 +
 drivers/infiniband/hw/bnxt_re/hw_counters.c        |   2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |   1 +
 drivers/infiniband/hw/bnxt_re/main.c               |  29 ++-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  16 ++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   3 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |  21 +--
 drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  11 +-
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |   1 +
 drivers/infiniband/hw/cxgb4/cm.c                   |   9 +-
 drivers/infiniband/hw/irdma/cm.c                   |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  80 ++++++--
 drivers/irqchip/irq-renesas-rzg2l.c                |  16 +-
 drivers/irqchip/irq-riscv-imsic-platform.c         |   2 +-
 drivers/md/raid10.c                                |   7 +-
 drivers/net/dsa/microchip/ksz_common.c             |  21 ++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |   1 +
 drivers/net/dsa/mv88e6xxx/ptp.c                    | 108 +++++++----
 drivers/net/dsa/vitesse-vsc73xx-core.c             |   1 -
 drivers/net/ethernet/aeroflex/greth.c              |   3 +-
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   1 +
 drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  22 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  70 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |  12 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |  10 +-
 drivers/net/ethernet/freescale/fman/mac.c          |  68 +++++--
 drivers/net/ethernet/freescale/fman/mac.h          |   6 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   1 +
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |  82 ++++++---
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   9 +-
 .../net/ethernet/microchip/sparx5/sparx5_mirror.c  |  12 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  25 ++-
 drivers/net/ethernet/renesas/rtsn.c                |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |  18 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +
 drivers/net/hyperv/netvsc_drv.c                    |  30 +++
 drivers/net/macsec.c                               |  18 --
 drivers/net/netdevsim/dev.c                        |  15 +-
 drivers/net/phy/dp83822.c                          |   4 +-
 drivers/net/plip/plip.c                            |   2 +-
 drivers/net/pse-pd/pse_core.c                      |   4 +-
 drivers/net/usb/usbnet.c                           |   4 +-
 drivers/net/virtio_net.c                           |   2 +-
 drivers/net/vmxnet3/vmxnet3_xdp.c                  |   2 +-
 drivers/net/wwan/wwan_core.c                       |   2 +-
 drivers/nvme/host/pci.c                            |  19 +-
 drivers/pci/probe.c                                |   2 +
 drivers/pci/pwrctl/pci-pwrctl-pwrseq.c             |  58 +++++-
 drivers/platform/x86/dell/dell-wmi-base.c          |   9 +
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |   1 +
 drivers/platform/x86/intel/pmc/core_ssram.c        |   4 +-
 drivers/powercap/dtpm_devfreq.c                    |   2 +-
 drivers/reset/starfive/reset-starfive-jh71x0.c     |   3 +
 drivers/soundwire/intel_ace2x.c                    |  19 +-
 drivers/target/target_core_device.c                |   2 +-
 drivers/target/target_core_user.c                  |   2 +-
 drivers/usb/host/xhci-dbgcap.h                     |   2 +-
 drivers/usb/host/xhci-dbgtty.c                     |  71 ++++++--
 drivers/usb/typec/class.c                          |   3 +
 drivers/video/fbdev/Kconfig                        |   1 +
 fs/9p/v9fs.h                                       |  34 +++-
 fs/9p/v9fs_vfs.h                                   |   2 +-
 fs/9p/vfs_inode.c                                  | 129 ++++++++-----
 fs/9p/vfs_inode_dotl.c                             | 112 ++++++++----
 fs/9p/vfs_super.c                                  |   2 +-
 fs/backing-file.c                                  |   8 +-
 fs/btrfs/block-group.c                             |   2 +
 fs/btrfs/dir-item.c                                |   4 +-
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent_map.c                              |  31 ++--
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/qgroup.c                                  |   2 +-
 fs/btrfs/qgroup.h                                  |   2 +
 fs/btrfs/super.c                                   |  12 +-
 fs/fuse/passthrough.c                              |   8 +-
 fs/jfs/jfs_dmap.c                                  |   2 +-
 fs/namespace.c                                     |   4 +-
 fs/nfsd/nfs4state.c                                |  50 ++++-
 fs/nfsd/state.h                                    |   2 +
 fs/nilfs2/page.c                                   |   6 +-
 fs/notify/fsnotify.c                               |  21 ++-
 fs/notify/inotify/inotify_user.c                   |   2 +-
 fs/notify/mark.c                                   |   8 +-
 fs/open.c                                          |   2 +
 fs/overlayfs/file.c                                |   9 +-
 fs/select.c                                        |   4 +-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/smb/client/fs_context.c                         |   7 +
 fs/smb/client/reparse.c                            |  23 +++
 fs/smb/client/smb2ops.c                            |   3 +-
 fs/smb/client/smb2pdu.c                            |   9 +
 fs/udf/balloc.c                                    |  38 ++--
 fs/udf/directory.c                                 |  23 ++-
 fs/udf/inode.c                                     | 202 ++++++++++++++-------
 fs/udf/partition.c                                 |   6 +-
 fs/udf/super.c                                     |   3 +-
 fs/udf/truncate.c                                  |  43 ++++-
 fs/udf/udfdecl.h                                   |  15 +-
 fs/xfs/scrub/repair.c                              |   8 +-
 include/linux/backing-file.h                       |   2 +-
 include/linux/bpf.h                                |  14 +-
 include/linux/bpf_types.h                          |   1 +
 include/linux/huge_mm.h                            |  18 ++
 include/linux/netdevice.h                          |  12 ++
 include/linux/shmem_fs.h                           |  11 +-
 include/linux/task_work.h                          |   5 +-
 include/linux/uaccess.h                            |   7 +
 include/net/bluetooth/bluetooth.h                  |   1 +
 include/net/genetlink.h                            |   3 +-
 include/net/sock.h                                 |   5 +
 include/net/xfrm.h                                 |  28 +--
 include/uapi/linux/bpf.h                           |  16 +-
 include/uapi/sound/asoc.h                          |   2 +-
 kernel/bpf/btf.c                                   |  15 +-
 kernel/bpf/devmap.c                                |  11 +-
 kernel/bpf/helpers.c                               |  10 +-
 kernel/bpf/inode.c                                 |   5 +-
 kernel/bpf/log.c                                   |   3 +-
 kernel/bpf/ringbuf.c                               |  14 +-
 kernel/bpf/syscall.c                               |  33 +++-
 kernel/bpf/task_iter.c                             |   2 +-
 kernel/bpf/verifier.c                              | 107 ++++++-----
 kernel/sched/core.c                                |   4 +-
 kernel/task_work.c                                 |  15 +-
 kernel/time/posix-clock.c                          |   6 +-
 kernel/trace/bpf_trace.c                           |  42 ++---
 kernel/trace/fgraph.c                              |  15 +-
 kernel/trace/ring_buffer.c                         |  44 +++--
 kernel/trace/trace_eprobe.c                        |   7 +-
 kernel/trace/trace_fprobe.c                        |   6 +-
 kernel/trace/trace_kprobe.c                        |   6 +-
 kernel/trace/trace_probe.c                         |   2 +-
 kernel/trace/trace_uprobe.c                        |  13 +-
 lib/Kconfig.debug                                  |   2 +-
 lib/objpool.c                                      |   2 +-
 lib/strncpy_from_user.c                            |   9 +
 lib/strnlen_user.c                                 |   9 +
 mm/huge_memory.c                                   |  24 +--
 mm/memory.c                                        |   9 +
 mm/shmem.c                                         |  55 +++---
 net/bluetooth/af_bluetooth.c                       |  22 +++
 net/bluetooth/bnep/core.c                          |   3 +-
 net/bluetooth/hci_core.c                           |  24 ++-
 net/bluetooth/hci_sync.c                           |  12 +-
 net/bluetooth/iso.c                                |  18 +-
 net/bluetooth/sco.c                                |  18 +-
 net/core/filter.c                                  |  50 ++---
 net/core/sock_map.c                                |   8 +
 net/ipv4/devinet.c                                 |  35 +++-
 net/ipv4/inet_connection_sock.c                    |  21 ++-
 net/ipv4/xfrm4_policy.c                            |  38 ++--
 net/ipv6/xfrm6_policy.c                            |  31 ++--
 net/l2tp/l2tp_netlink.c                            |   4 +-
 net/netfilter/nf_bpf_link.c                        |   7 +-
 net/netfilter/xt_NFLOG.c                           |   2 +-
 net/netfilter/xt_TRACE.c                           |   1 +
 net/netfilter/xt_mark.c                            |   2 +-
 net/netlink/genetlink.c                            |  28 +--
 net/sched/act_api.c                                |  23 ++-
 net/sched/sch_generic.c                            |   8 +-
 net/sched/sch_taprio.c                             |  21 ++-
 net/smc/smc_pnet.c                                 |   2 +-
 net/smc/smc_wr.c                                   |   6 +-
 net/vmw_vsock/virtio_transport_common.c            |  14 +-
 net/vmw_vsock/vsock_bpf.c                          |   8 -
 net/wireless/nl80211.c                             |   8 +-
 net/xfrm/xfrm_device.c                             |  11 +-
 net/xfrm/xfrm_policy.c                             |  50 +++--
 net/xfrm/xfrm_user.c                               |  10 +-
 sound/firewire/amdtp-stream.c                      |   3 +
 sound/pci/hda/Kconfig                              |   2 +-
 sound/pci/hda/patch_cs8409.c                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |  48 ++---
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/lpass-rx-macro.c                  |   2 +-
 sound/soc/codecs/max98388.c                        |   1 +
 sound/soc/fsl/fsl_micfil.c                         |  43 ++++-
 sound/soc/fsl/fsl_sai.c                            |   5 +-
 sound/soc/fsl/fsl_sai.h                            |   1 +
 sound/soc/loongson/loongson_card.c                 |   1 +
 sound/soc/qcom/Kconfig                             |   2 +
 sound/soc/qcom/lpass-cpu.c                         |   2 +
 sound/soc/qcom/sc7280.c                            |  10 +-
 sound/soc/qcom/sdm845.c                            |   7 +-
 sound/soc/qcom/sm8250.c                            |   1 +
 sound/soc/sh/rcar/core.c                           |   7 +-
 sound/soc/soc-dapm.c                               |   4 +-
 sound/soc/sof/intel/hda-dai-ops.c                  |  23 +--
 sound/soc/sof/intel/hda-dai.c                      |  37 +++-
 sound/soc/sof/intel/hda-loader.c                   |  17 --
 sound/soc/sof/ipc4-topology.c                      |  15 +-
 tools/include/uapi/linux/bpf.h                     |   3 +
 tools/testing/selftests/bpf/Makefile               |   2 +-
 .../selftests/bpf/prog_tests/fill_link_info.c      |   9 +-
 275 files changed, 2655 insertions(+), 1271 deletions(-)


