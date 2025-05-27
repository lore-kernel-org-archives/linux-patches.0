Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A31E89C;
	Tue, 27 May 2025 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366296; cv=none; b=s3ZSk1+Scv99XnqP7HzwZnAdy+kxPMR/JotkoSGXFogQ0N3Ns/rZwaRajhyBLZQMCCIOrBD5NERbkmBO6tCsmHrn7lOU0kC+PLyS5hj3G2TWFQdS/OWux+C9scFq/vPsoz4ZKmb6/k4uB9g2sv6VccGJ9TGYVvJL7QoKRQd1jRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366296; c=relaxed/simple;
	bh=iBVHD4ADukYeOyfVRTn+54jsGBLwzp6/dGXnDsEvoec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NGk6P9n2Wcnvi9yc1MKbW23EBfw6+Aqfagmt0DbAh6E1HT2hToMIxra0igbHr0P3DTOx7dQtSeJ8VgzNC3t4AWZAGC219B1Sl2ySMcS1JcN4qa/E35ejsK8QKFv50W6asc8mgK0BlaEooea0dj8RZb0Jc9Sj+izJTQmNXpzMYaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDWh/hmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDWh/hmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF144C4CEE9;
	Tue, 27 May 2025 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366296;
	bh=iBVHD4ADukYeOyfVRTn+54jsGBLwzp6/dGXnDsEvoec=;
	h=From:To:Cc:Subject:Date:From;
	b=gDWh/hmG72oIixXaBROlMedxpNpfDu/gKw30yhjzkJvyuBv8HBj6SfnKgsCctflnG
	 IFDu9y1dUIzIX01LcRKT8ILQNztb7ICKdYFH8AW7AlHNKmgyoBQtsafyAXZuMhZs6Z
	 1APGGgaAbkX4MNENcjTAo0JEmJmxvRHViSi13E3o=
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
Subject: [PATCH 6.14 000/783] 6.14.9-rc1 review
Date: Tue, 27 May 2025 18:16:37 +0200
Message-ID: <20250527162513.035720581@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.14.9-rc1
X-KernelTest-Deadline: 2025-05-29T16:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.14.9 release.
There are 783 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.14.9-rc1

Nathan Chancellor <nathan@kernel.org>
    kbuild: Properly disable -Wunterminated-string-initialization for clang

Linus Torvalds <torvalds@linux-foundation.org>
    Fix mis-uses of 'cc-option' for warning disablement

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-15: disable '-Wunterminated-string-initialization' entirely for now

Linus Torvalds <torvalds@linux-foundation.org>
    gcc-15: make 'unterminated string initialization' just a warning

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu: read back register after written for VCN v4.0.5

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/vcn4.0.5: split code along instances

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Fix determining SST/MST mode during MTP TU state computation

Raag Jadav <raag.jadav@intel.com>
    err.h: move IOMEM_ERR_PTR() to err.h

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe: Use xe_mmio_read32() to read mtcfg register

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: Reset SR flags before sending a new message

Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>
    spi: spi-fsl-dspi: Halt the module after a new message transfer

Larisa Grigore <larisa.grigore@nxp.com>
    spi: spi-fsl-dspi: restrict register range for regmap access

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    spi: use container_of_cont() for to_spi_device()

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Fix attribute name usage for non-compliant items

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix stream write failure

Jernej Skrabec <jernej.skrabec@gmail.com>
    Revert "arm64: dts: allwinner: h6: Use RSB for AXP805 PMIC connection"

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Do close if SDIO card removed without close

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Check function enabled before doing close

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix deadlock warnings caused by lock dependency in init_nilfs()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: restore monitor for outgoing frames

Arnd Bergmann <arnd@arndb.de>
    octeontx2: hide unused label

Kees Cook <kees@kernel.org>
    mm: vmalloc: only zero-init on vrealloc shrink

Kees Cook <kees@kernel.org>
    mm: vmalloc: actually use the in-place vrealloc region

Florent Revest <revest@chromium.org>
    mm: fix VM_UFFD_MINOR == VM_SHADOW_STACK on USERFAULTFD=y && ARM64_GCS=y

Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
    mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled

Wang Yaxin <wang.yaxin@zte.com.cn>
    taskstats: fix struct taskstats breaks backward compatibility since version 15

David Wang <00107082@163.com>
    module: release codetag section when module load fails

Tianyang Zhang <zhangtianyang@loongson.cn>
    mm/page_alloc.c: avoid infinite retries caused by cpuset race

Ge Yang <yangge1116@126.com>
    mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios

Breno Leitao <leitao@debian.org>
    memcg: always call cond_resched() after fn()

Alexander Gordeev <agordeev@linux.ibm.com>
    kasan: avoid sleepable page allocation from atomic context

Matthew Wilcox (Oracle) <willy@infradead.org>
    highmem: add folio_test_partial_kmap()

Suren Baghdasaryan <surenb@google.com>
    alloc_tag: allocate percpu counters for module tags dynamically

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi - fix crash with unsupported versions of F34

Vicki Pfau <vi@endrift.com>
    Input: xpad - add more controllers

Mario Limonciello <mario.limonciello@amd.com>
    Revert "drm/amd: Keep display off while going into S4"

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Reset all search buffer pointers when releasing buffer

Gabor Juhos <j4g8y7@gmail.com>
    arm64: dts: marvell: uDPU: define pinctrl state for alarm LEDs

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Fix use-after-free in cifs_fill_dirent

feijuan.li <feijuan.li@samsung.com>
    drm/edid: fixed the bug that hdr metadata was not reset

Zhang Rui <rui.zhang@intel.com>
    thermal: intel: x86_pkg_temp_thermal: Fix bogus trip temperature

Vladimir Moskovkin <Vladimir.Moskovkin@kaspersky.com>
    platform/x86: dell-wmi-sysman: Avoid buffer overflow in current_password_store()

Dan Carpenter <dan.carpenter@linaro.org>
    pmdomain: core: Fix error checking in genpd_dev_pm_attach_by_id()

Geert Uytterhoeven <geert+renesas@glider.be>
    pmdomain: renesas: rcar: Remove obsolete nullify checks

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add SDHCI_QUIRK2_SUPPRESS_V1P8_ENA quirk to am62 compatible

Ronak Doshi <ronak.doshi@broadcom.com>
    vmxnet3: update MTU after device quiesce

Jakob Unterwurzacher <jakobunt@gmail.com>
    net: dsa: microchip: linearize skb for tail-tagging switches

Jens Axboe <axboe@kernel.dk>
    io_uring/net: only retry recv bundle for a full transfer

Axel Forsman <axfo@kvaser.com>
    can: kvaser_pciefd: Fix echo_skb race

Axel Forsman <axfo@kvaser.com>
    can: kvaser_pciefd: Continue parsing DMA buf after dropped RX

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    llc: fix data loss when reading from a socket in llc_ui_recvmsg()

Ed Burcher <git@edburcher.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14ASP10

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix race of buffer access at PCM OSS layer

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Delay reporting is only supported for playback direction

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoc: SOF: topology: connect DAI to a single DAI link

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-bus: Use PIO mode on ACE2+ platforms

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-control: Use SOF_CTRL_CMD_BINARY as numid for bytes_ext

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add missing rcu read protection for procfs content

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: add locking for bcm_op runtime updates

Carlos Sanchez <carlossanchez@geotab.com>
    can: slcan: allow reception of short error messages

Dominik Grzegorzek <dominik.grzegorzek@oracle.com>
    padata: do not leak refcount in reorder_work

Ivan Pravdin <ipravdin.official@gmail.com>
    crypto: algif_hash - fix double free in hash_accept

André Draszik <andre.draszik@linaro.org>
    clk: s2mps11: initialise clk_hw_onecell_data::num before accessing ::hws[] in probe()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-af: Fix APR entry mapping based on APR_LMT_CFG

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2-af: Set LMT_ENA bit for APR table entries

Wang Liang <wangliang74@huawei.com>
    net/tipc: fix slab-use-after-free Read in tipc_aead_encrypt_done

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Avoid adding dcbnl_ops for LBK and SDP vf

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: AF_XDP zero copy receive support

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Add AF_XDP non-zero copy support

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: use xdp_return_frame() to free xdp buffers

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()

Eric Dumazet <edumazet@google.com>
    idpf: fix idpf_vport_splitq_napi_poll()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix overflow resched cqe reordering

Samiullah Khawaja <skhawaja@google.com>
    xsk: Bring back busy polling support in XDP_COPY

Thangaraj Samynathan <thangaraj.s@microchip.com>
    net: lan743x: Restore SGMII CTRL register on resume

Paul Kocialkowski <paulk@sys-base.io>
    net: dwmac-sun8i: Use parsed internal PHY address instead of 1

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    pinctrl: qcom: switch to devm_register_sys_off_handler()

Christoph Hellwig <hch@lst.de>
    loop: don't require ->write_iter for writable files in loop_configure

Pavan Kumar Linga <pavan.kumar.linga@intel.com>
    idpf: fix null-ptr-deref in idpf_features_check

Dave Ertman <david.m.ertman@intel.com>
    ice: Fix LACP bonds without SRIOV environment

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix vf->num_mac count with port representors

Paolo Abeni <pabeni@redhat.com>
    mr: consolidate the ipmr_can_free_table() checks.

Ido Schimmel <idosch@nvidia.com>
    bridge: netfilter: Fix forwarding of fragmented packets

Sagi Maimon <maimon.sagi@gmail.com>
    ptp: ocp: Limit signal/freq counts in summary output functions

En-Wei Wu <en-wei.wu@canonical.com>
    Bluetooth: btusb: use skb_pull to avoid unsafe access in QCA dump handling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not checking l2cap_chan security level

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel: Fix segfault with PEBS-via-PT with sample_freq

Andrew Bresticker <abrestic@rivosinc.com>
    irqchip/riscv-imsic: Start local sync timer on correct CPU

Tavian Barnes <tavianator@tavianator.com>
    ASoC: SOF: Intel: hda: Fix UAF when reloading module

Raag Jadav <raag.jadav@intel.com>
    devres: Introduce devm_kmemdup_array()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    driver core: Split devres APIs to device/devres.h

Stefan Wahren <wahrenst@gmx.net>
    dmaengine: fsl-edma: Fix return code for unhandled interrupts

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: Fix ->poll() return value

Paul Chaignon <paul.chaignon@gmail.com>
    xfrm: Sanitize marks before insert

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: d1: Add missing divider for MMC mod clocks

Matti Lehtimäki <matti.lehtimaki@gmail.com>
    remoteproc: qcom_wcnss: Fix on platforms without fallback regulators

David Hildenbrand <david@redhat.com>
    kernel/fork: only call untrack_pfn_clear() on VMAs duplicated for fork()

Seongman Lee <augustus92@kaist.ac.kr>
    x86/sev: Fix operator precedence in GHCB_MSR_VMPL_REQ_LEVEL macro

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix allowing write() from different address spaces

Tobias Brunner <tobias@strongswan.org>
    xfrm: Fix UDP GRO handling for some corner cases

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: remove encap socket caching to avoid reference leak

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: fix skb leaks

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: bus: Fix race on the creation of the IRQ domain

Al Viro <viro@zeniv.linux.org.uk>
    __legitimize_mnt(): check for MNT_SYNC_UMOUNT should be under mount_lock

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Call FP Protect Before Mode Programming/Mode Support

Jason Andryuk <jason.andryuk@amd.com>
    xenbus: Allow PVH dom0 a non-local xenstore

Paweł Anikiel <panikiel@google.com>
    x86/Kconfig: make CFI_AUTO_DEFAULT depend on !RUST or Rust >= 1.88

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: add support for Killer on MTL

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    block: only update request sector if needed

David Wei <dw@davidwei.uk>
    tools: ynl-gen: validate 0 len strings from kernel

Qu Wenruo <wqu@suse.com>
    btrfs: avoid NULL pointer dereference if no valid csum tree

Boris Burkov <boris@bur.io>
    btrfs: handle empty eb->folios in num_extent_folios()

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: correct the order of prelim_ref arguments in btrfs__prelim_ref

Kees Cook <kees@kernel.org>
    btrfs: compression: adjust cb->compressed_folios allocation type

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    iio: imu: st_lsm6dsx: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    iio: adc: qcom-spmi-iadc: Fix wakeup source leaks on device unbind

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    iio: accel: fxls8962af: Fix wakeup source leaks on device unbind

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: intel/sdw_utils: Add volume limit to cs35l56 speakers

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: intel/sdw_utils: Add volume limit to cs42l43 speakers

Pali Rohár <pali@kernel.org>
    cifs: Fix changing times and read-only attr over SMB1 smb_set_file_info() function

Pali Rohár <pali@kernel.org>
    cifs: Fix and improve cifs_query_path_info() and cifs_query_file_info()

Jens Axboe <axboe@kernel.dk>
    io_uring/fdinfo: annotate racy sq/cq head/tail reads

Alistair Francis <alistair.francis@wdc.com>
    nvmet-tcp: don't restore null sk_state_change

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix duplicated name in MIDI substream names

Wentao Guan <guanwentao@uniontech.com>
    nvme-pci: add quirks for WDC Blue SN550 15b7:5009

Wentao Guan <guanwentao@uniontech.com>
    nvme-pci: add quirks for device 126f:1001

Sunil Khatri <sunil.khatri@amd.com>
    drm/ttm: fix the warning for hit_low and evict_low

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Spectre x360 15-df1xxx

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5640: Add DMI quirk for Acer Aspire SW3-013

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Disable headphone clamps during type detection

Gašper Nemgar <gasper.nemgar@gmail.com>
    platform/x86: ideapad-laptop: add support for some new buttons

Pavel Nikulin <pavel@noa-labs.com>
    platform/x86: asus-wmi: Disable OOBE state after resume from hibernation

Saranya Gopal <saranya.gopal@intel.com>
    platform/x86/intel: hid: Add Pantherlake support

Salah Triki <salah.triki@gmail.com>
    smb: server: smb2pdu: check return value of xa_store()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    pinctrl: meson: define the pull up/down resistor value as 60 kOhm

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    book3s64/radix: Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n

Chenyuan Yang <chenyuan0y@gmail.com>
    ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()

Eric Dumazet <edumazet@google.com>
    net-sysfs: restore behavior for not running devices

Kate Hsuan <hpa@redhat.com>
    HID: Kconfig: Add LEDS_CLASS_MULTICOLOR dependency to HID_LOGITECH

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Add counter for all monitor interfaces

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix pasid value leak

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdkfd: Fix error handling for missing PASID in 'kfd_process_device_init_vm'

Ovidiu Bunea <Ovidiu.Bunea@amd.com>
    drm/amd/display: Exit idle optimizations before accessing PHY

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Save and restore more registers

Willem de Bruijn <willemb@google.com>
    ipv6: remove leftover ip6 cookie initializer

Eduard Zingerman <eddyz87@gmail.com>
    bpf: abort verification if env->cur_state->loop_entry != NULL

Balbir Singh <balbirs@nvidia.com>
    x86/mm/init: Handle the special case of device private pages in add_pages(), to not increase max_pfn and trigger dma_addressing_limited() bounce buffers

Michael S. Tsirkin <mst@redhat.com>
    virtgpu: don't reset on shutdown

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gem: Internally test import_attach for imported objects

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Correct F8_MODE for gfx950

Arnd Bergmann <arnd@arndb.de>
    watchdog: aspeed: fix 64-bit division

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: tegra: Fix off by one in tegra_pinctrl_get_group()

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: sma1307: Fix error handling in sma1307_setting_loaded()

Nathan Chancellor <nathan@kernel.org>
    i3c: master: svc: Fix implicit fallthrough in svc_i3c_master_ibi_work()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm: Add valid clones check

Douglas Anderson <dianders@chromium.org>
    drm/panel-edp: Add Starry 116KHD024006

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Add locks in gtidle code

Lin.Cao <lincao12@amd.com>
    drm/buddy: fix issue that force_merge cannot free all roots

Simona Vetter <simona.vetter@ffwll.ch>
    drm/atomic: clarify the rules around drm_atomic_state->allow_modeset

Oak Zeng <oak.zeng@intel.com>
    drm/xe: Reject BO eviction if BO is bound to current VM

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Drop error messages about missing GuC logs

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe: Always setup GT MMIO adjustment data

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/vf: Perform early GT MMIO initialization to read GMDID

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/sa: Always call drm_suballoc_manager_fini()

Ching-Te Ku <ku920601@realtek.com>
    wifi: rtw89: coex: Add protect to avoid A2DP lag while Wi-Fi connecting

Ching-Te Ku <ku920601@realtek.com>
    wifi: rtw89: coex: Separated Wi-Fi connecting event from Wi-Fi scan event

Maarten Lankhorst <dev@lankhorst.se>
    drm/xe: Do not attempt to bootstrap VF in execlists mode

Maarten Lankhorst <dev@lankhorst.se>
    drm/xe: Move suballocator init to after display init

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Hide Gens 1 to 3 TX detection in branch

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath11k: Use dma_alloc_noncoherent for rx_tid buffer allocation

Zhi Wang <zhiw@nvidia.com>
    drm/nouveau: fix the broken marco GSP_MSG_MAX_SIZE

Olivier Moysan <olivier.moysan@foss.st.com>
    drm: bridge: adv7511: fill stream capabilities

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: ath12k: report station mode transmit rate

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: ath12k: report station mode receive rate for IEEE 802.11be

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Fix end offset bit definition in monitor ring descriptor

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Move VFs reprovisioning to worker

Aaradhana Sahu <quic_aarasahu@quicinc.com>
    wifi: ath12k: Fetch regdb.bin file from board-2.bin

Rosen Penev <rosenp@gmail.com>
    wifi: ath9k: return by of_get_mac_address

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Reset GuC VF config when unprovisioning critical resource

Youssef Samir <quic_yabdulra@quicinc.com>
    accel/qaic: Mask out SR-IOV PCI resources

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath12k: fix ath12k_hal_tx_cmd_ext_desc_setup() info1 override

Isaac Scott <isaac.scott@ideasonboard.com>
    regulator: ad5398: Add device tree support

Sean Anderson <sean.anderson@linux.dev>
    spi: zynqmp-gqspi: Always acknowledge interrupts

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: add wiphy_lock() to work that isn't held wiphy_lock() yet

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Don't use static local variable in rtw8822b_set_tx_power_index_by_rate

Soeren Moch <smoch@web.de>
    wifi: rtl8xxxu: retry firmware download on error

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: rzg2l-cpg: Refactor Runtime PM clock validation

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix ->config to sample period calculation for OP PMU

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Fix perf_ibs_op.cnt_mask for CurCnt

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_scmi: Relax duplicate name constraint across protocol ids

Viktor Malik <vmalik@redhat.com>
    bpftool: Fix readlink usage in get_fd_type

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: Use kallsyms to find the function name of a struct_ops's stub function

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Find VBIOS mode from regular display size

Matthew Sakai <msakai@redhat.com>
    dm vdo: use a short static string for thread name prefix

Chung Chung <cchung@redhat.com>
    dm vdo indexer: prevent unterminated string warning

Ken Raeburn <raeburn@redhat.com>
    dm vdo vio-pool: allow variable-sized metadata vios

Vladimir Kondratiev <vladimir.kondratiev@mobileye.com>
    irqchip/riscv-aplic: Add support for hart indexes

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: rt722-sdca: Add some missing readable registers

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Allow for 24-bit in provider mode

Naman Trivedi <naman.trivedimanojbhai@amd.com>
    arm64: zynqmp: add clock-output-names property in clock nodes

junan <junan76@163.com>
    HID: usbkbd: Fix the bit shift number for LED_KANA

Avula Sri Charan <quic_asrichar@quicinc.com>
    wifi: ath12k: Avoid napi_sync() before napi_enable()

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Restore some drive settings after reset

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Reduce log message generation during ELS ring clean up

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Free phba irq in lpfc_sli4_enable_msi() when pci_irq_vector() fails

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine

Konstantin Taranov <kotaranov@microsoft.com>
    net/mana: fix warning in the writer of client oob

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/relay: Don't use GFP_KERNEL for new transactions

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: count combined queues using Rx/Tx count

Peter Zijlstra (Intel) <peterz@infradead.org>
    perf: Avoid the read if the count is already updated

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: fix header guard for rcu_all_qs()

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: handle unstable rdp in rcu_read_unlock_strict()

Ankur Arora <ankur.a.arora@oracle.com>
    rcu: handle quiescent states for PREEMPT_RCU=n, PREEMPT_COUNT=y

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: treat dyn_allowed only as suggestion

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: init flow director before RDMA

Petr Machata <petrm@nvidia.com>
    bridge: mdb: Allow replace of a host-joined group

Eric Dumazet <edumazet@google.com>
    net: flush_backlog() small changes

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: don't scan PHY addresses > 0

Geert Uytterhoeven <geert@linux-m68k.org>
    ipv4: ip_gre: Fix set but not used warning in ipgre_err() if IPv4-only

Ido Schimmel <idosch@nvidia.com>
    vxlan: Annotate FDB data races

Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
    cpufreq: amd-pstate: Remove unnecessary driver_lock in set_boost

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Avoid WARN_ON when configuring MQPRIO with HTB offload enabled

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: don't output external constants

Alexander Duyck <alexanderduyck@meta.com>
    eth: fbnic: set IFF_UNICAST_FLT to avoid enabling promiscuous mode when adding unicast addrs

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: vop2: Improve display modes handling on RK3588 HDMI0

Depeng Shao <quic_depengs@quicinc.com>
    media: qcom: camss: Add default case in vfe_src_pad_code

Depeng Shao <quic_depengs@quicinc.com>
    media: qcom: camss: csid: Only add TPG v4l2 ctrl if TPG hardware is available

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: introduce f2fs_base_attr for global sysfs entries

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Fix PVC RPe and RPa information

Andrey Vatoropin <a.vatoropin@crpt.ru>
    hwmon: (xgene-hwmon) use appropriate type for the latency value

Len Brown <len.brown@intel.com>
    tools/power turbostat: Clustered Uncore MHz counters should honor show/hide options

Jakub Kicinski <kuba@kernel.org>
    net: page_pool: avoid false positive warning if NAPI was never added

Jakub Kicinski <kuba@kernel.org>
    netdevsim: allow normal queue reset while down

Jordan Crouse <jorcrous@amazon.com>
    clk: qcom: camcc-sm8250: Use clk_rcg2_shared_ops for some RCGs

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: adi-axi-dac: add bus mode setup

Angelo Dureghello <adureghello@baylibre.com>
    iio: dac: ad3552r-hs: use instruction mode for configuration

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: call power_on ahead before selecting firmware

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: validate multi-firmware header before accessing

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: validate multi-firmware header before getting its size

Ching-Te Ku <ku920601@realtek.com>
    wifi: rtw89: coex: Assign value over than 0 to avoid firmware timer hang

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix __rtw_download_firmware() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix download_firmware_validate() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Extend rtw_fw_send_ra_info() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_update_sta_info() for RTL8814AU

Zhang Yi <yi.zhang@huawei.com>
    ext4: remove writable userspace mappings before truncating page cache

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't write back data before punch hole in nojournal mode

Marek Vasut <marex@denx.de>
    leds: trigger: netdev: Configure LED blink interval for HW offload

Kees Cook <kees@kernel.org>
    pstore: Change kmsg_bytes storage size to u32

Song Yoong Siang <yoong.siang.song@intel.com>
    igc: Avoid unnecessary link down event in XDP_SETUP_PROG process

David Lechner <dlechner@baylibre.com>
    iio: adc: ad7944: don't use storagebits for sizing

Akihiko Odaki <akihiko.odaki@daynix.com>
    s390/crash: Use note name macros

Aleksander Jan Bajkowski <olek2@wp.pl>
    r8152: add vendor/device ID pair for Dell Alienware AW1022z

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: fib_rules: Fetch net from fib_rule in fib[46]_rule_configure().

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    arch/powerpc/perf: Check the instruction type before creating sample with perf_mem_data_src

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: create DDW for devices with DMA mask less than 64-bits

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: memory notifier incorrectly adds TCEs for pmemory

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Refactor MAC reset to function

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Drop cooked monitor support

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: add HT and VHT basic set verification

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: mac80211: set ieee80211_prep_tx_info::link_id upon Auth Rx

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: remove misplaced drv_mgd_complete_tx() call

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't unconditionally call drv_mgd_complete_tx()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: always send max agg subframe num in strict mode

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: don't warn during reprobe

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: use correct IMR dump variable

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: userspace: flags: clearer msg if no remote addr

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: Update the peer id in PPDU end user stats TLV

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: fix the ampdu id fetch in the HAL_RX_MPDU_START TLV

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: ath12k: use arvif instead of link_conf in ath12k_mac_set_key()

Aaradhana Sahu <quic_aarasahu@quicinc.com>
    wifi: ath12k: Enable MLO setup ready and teardown commands for single split-phy device

Angelo Dureghello <adureghello@baylibre.com>
    iio: adc: ad7606: protect register access

Leon Romanovsky <leon@kernel.org>
    xfrm: prevent high SEQ input in non-ESN mode

Stefan Wahren <wahrenst@gmx.net>
    drm/v3d: Add clock handling

William Tu <witu@nvidia.com>
    net/mlx5e: reduce the max log mpwrq sz for ECPF and reps

William Tu <witu@nvidia.com>
    net/mlx5e: reduce rep rxq depth to 256 for ECPF

William Tu <witu@nvidia.com>
    net/mlx5e: set the tx_queue_len for pfifo_fast

Alexei Lazar <alazar@nvidia.com>
    net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB

Alexei Lazar <alazar@nvidia.com>
    net/mlx5: XDP, Enable TX side XDP multi-buffer support

Chaohai Chen <wdhh66@163.com>
    scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display/dm: drop hw_support check in amdgpu_dm_i2c_xfer()

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Have kfd driver use same PASID values from graphic driver

Shiwu Zhang <shiwu.zhang@amd.com>
    drm/amdgpu: enlarge the VBIOS binary size limit

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Use active umc info from discovery

Dillon Varone <dillon.varone@amd.com>
    drm/amd/display: Populate register address for dentist for dcn401

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Use Nominal vBlank If Provided Instead Of Capping It

Joshua Aberback <joshua.aberback@amd.com>
    drm/amd/display: Increase block_sequence array size

Peterson Guo <peterson.guo@amd.com>
    drm/amd/display: Reverse the visual confirm recouts

Jiang Liu <gerry@linux.alibaba.com>
    amdgpu/soc15: enable asic reset for dGPU in case of suspend abort

Victor Skvortsov <victor.skvortsov@amd.com>
    drm/amdgpu: Skip err_count sysfs creation on VF unsupported RAS blocks

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu/gfx10: Add cleaner shader for GFX10.1.10

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Initial psr_version with correct setting

George Shen <george.shen@amd.com>
    drm/amd/display: Update CR AUX RD interval interpretation

Austin Zheng <Austin.Zheng@amd.com>
    drm/amd/display: Account For OTO Prefetch Bandwidth When Calculating Urgent Bandwidth

Dillon Varone <dillon.varone@amd.com>
    drm/amd/display: Ammend DCPG IP control sequences to align with HW guidance

Dillon Varone <dillon.varone@amd.com>
    drm/amd/display: Fixes for mcache programming in DML21

Brandon Syu <Brandon.Syu@amd.com>
    Revert "drm/amd/display: Exit idle optimizations before attempt to access PHY"

Martin Tsai <Martin.Tsai@amd.com>
    drm/amd/display: Support multiple options during psr entry.

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: Skip P2S load for SMU v13.0.12

Jiang Liu <gerry@linux.alibaba.com>
    drm/amdgpu: reset psp->cmd to NULL after releasing the buffer

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Don't try AUX transactions on disconnected link

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: remove TF check for LLS policy

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: pass calculated dram_speed_mts to dml2

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdgpu: Set snoop bit for SDMA for MI series

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix missing L2 cache info in topology

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mes11: fix set_hw_resources_1 calculation

Bart Van Assche <bvanassche@acm.org>
    scsi: usb: Rename the RESERVE and RELEASE constants

Huacai Chen <chenhuacai@kernel.org>
    net: stmmac: dwmac-loongson: Set correct {tx,rx}_fifo_size

Jan Kara <jack@suse.cz>
    jbd2: Avoid long replay times due to high number or revoke blocks

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: cadence_master: set frame shape and divider based on actual clk freq

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: change the soundwire wake enable/disable sequence

André Draszik <andre.draszik@linaro.org>
    phy: exynos5-usbdrd: fix EDS distribution tuning (gs101)

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: core: don't require set_mode() callback for phy_get_mode() to work

Damon Ding <damon.ding@rock-chips.com>
    phy: phy-rockchip-samsung-hdptx: Swap the definitions of LCPLL_REF and ROPLL_REF

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe/display: Remove hpd cancel work sync from runtime pm path

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Add suspend/resume support for pull up/down

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Update the suspend/resume support

zihan zhou <15645113830zzh@gmail.com>
    sched: Reduce the default slice to avoid tasks getting an extra tick

Peter Zijlstra <peterz@infradead.org>
    x86/boot: Mark start_secondary() with __noendbr

Peter Zijlstra <peterz@infradead.org>
    x86/traps: Cleanup and robustify decode_bug()

Peter Zijlstra <peterz@infradead.org>
    x86/ibt: Handle FineIBT in handle_cfi_failure()

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/debugfs: Add missing xe_pm_runtime_put in wedge_mode_set

Xin Wang <x.wang@intel.com>
    drm/xe/debugfs: fixed the return value of wedged_mode_set

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clk: qcom: clk-alpha-pll: Do not use random stack value for recalc rate

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Refactor hardware context destroy routine

Karl Chan <exxxxkc@getgoogleoff.me>
    clk: qcom: ipq5018: allow it to be bulid on arm32

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Fix xe_tile_init_noalloc() error propagation

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Stop ignoring errors from xe_ttm_stolen_mgr_init()

Kees Cook <kees@kernel.org>
    net/mlx4_core: Avoid impossible mlx4_db_alloc() order value

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Set NPAR 1.2 support when registering with firmware

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: i2c: ov2740: Free control handler on error path

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: csi: add missing pm_runtime_put on error

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: csi: use ARRAY_SIZE to search D-PHY table

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: Memset argument to 0 before calling get_mbus_config pad op

David Plowman <david.plowman@raspberrypi.com>
    media: i2c: imx219: Correct the minimum vblanking value

Brendan Jackman <jackmanb@google.com>
    kunit: tool: Use qboot on QEMU x86_64

Konstantin Andreev <andreev@swemel.ru>
    smack: Revert "smackfs: Added check catlen"

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Release all VFs configs on device removal

Konstantin Andreev <andreev@swemel.ru>
    smack: recognize ipv4 CIPSO w/o categories

Valentin Caron <valentin.caron@foss.st.com>
    pinctrl: devicetree: do not goto err when probing hogs in pinctrl_dt_to_map

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Power up/down amp on mute ops

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Mark SW_RESET as volatile

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Add reg defaults for TAS2764_INT_CLK_CFG

Martin Povišer <povik+lin@cutebit.org>
    ASoC: ops: Enforce platform maximum on initial value

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: sanitise ring params earlier

Caleb Sander Mateos <csander@purestorage.com>
    io_uring: use IO_REQ_LINK_FLAGS more

Siva Durga Prasad Paladugu <siva.durga.prasad.paladugu@amd.com>
    firmware: xilinx: Dont send linux address to get fpga config get status

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Handle the presence of host partition in the partition info

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Reject higher major version as incompatible

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Apply rate-limiting to high temperature warning

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5: Modify LSB bitmask in temperature event to include only the first bit

Amery Hung <ameryhung@gmail.com>
    bpf: Make every prog keep a copy of ctx_arg_info

Hans Verkuil <hverkuil@xs4all.nl>
    media: test-drivers: vivid: don't call schedule in loop

Andrew Jones <ajones@ventanamicro.com>
    irqchip/riscv-imsic: Set irq_set_affinity() for IMSIC base

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hrtimers: Replace hrtimer_clock_to_base_table with switch-case

Benjamin Segall <bsegall@google.com>
    posix-timers: Invoke cond_resched() during exit_itimers()

Brian Gerst <brgerst@gmail.com>
    x86/boot: Disable stack protector for early boot code

Petr Machata <petrm@nvidia.com>
    vxlan: Join / leave MC group after remote changes

Xiaofei Tan <tanxiaofei@huawei.com>
    ACPI: HED: Always initialize before evged

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Fix old_size lower bound in calculate_iosize() too

Jakub Kicinski <kuba@kernel.org>
    eth: mlx4: don't try to complete XDP frames in netpoll

Eduard Zingerman <eddyz87@gmail.com>
    bpf: copy_verifier_state() should copy 'loop_entry' field

Eduard Zingerman <eddyz87@gmail.com>
    bpf: don't do clean_live_states when state->loop_entry->branches > 0

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    can: c_can: Use of_property_present() to test existence of DT property

Ahmad Fatoum <a.fatoum@pengutronix.de>
    pmdomain: imx: gpcv2: use proper helper for property detection

Michael Margolin <mrgolin@amazon.com>
    RDMA/core: Fix best page size finding when it can cross SG entries

Alexis Lothoré <alexis.lothore@bootlin.com>
    serial: mctrl_gpio: split disable_ms into sync and no_sync APIs

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Don't treat wb connector as physical in create_validate_stream_for_sink

Leo Zeng <Leo.Zeng@amd.com>
    Revert "drm/amd/display: Request HW cursor on DCN3.2 with SubVP"

George Shen <george.shen@amd.com>
    drm/amd/display: Read LTTPR ALPM caps during link cap retrieval

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Fix BT2020 YCbCr limited/full range input

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Guard against setting dispclk low when active

Harry VanZyllDeJong <hvanzyll@amd.com>
    drm/amd/display: Add support for disconnected eDP streams

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Fetch current power limit from PMFW

Marcin Bernatowicz <marcin.bernatowicz@linux.intel.com>
    drm/xe/client: Skip show_run_ticks if unable to read timestamp

Anup Patel <apatel@ventanamicro.com>
    irqchip/riscv-imsic: Separate next and previous pointers in IMSIC vector

Eddie James <eajames@linux.ibm.com>
    eeprom: ee1004: Check chip before probing

Chris Morgan <macromorgan@hotmail.com>
    mfd: axp20x: AXP717: Add AXP717_TS_PIN_CFG to writeable regs

Breno Leitao <leitao@debian.org>
    netdevsim: call napi_schedule from a timer context

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: Flush FIFO before sending Dynamic Address Assignment(DAA)

Arnd Bergmann <arnd@arndb.de>
    EDAC/ie31200: work around false positive build warning

Chris Morgan <macromorgan@hotmail.com>
    power: supply: axp20x_battery: Update temp sensor for AXP717 from device tree

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix access outside of user given buffer in pktgen_thread_write()

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: 8922a: fix incorrect STA-ID in EHT MU PPDU

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: add blacklist to avoid obsolete secure firmware

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: get sb_sel_ver via get_unaligned_le32()

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: fw: propagate error code from rtw89_h2c_tx()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_mac_power_switch() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_desc_to_mcsrate() to handle MCS16-31

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_init_ht_cap() for RTL8814AU

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix rtw_init_vht_cap() for RTL8814AU

Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    scsi: mpt3sas: Send a diag reset if target reset fails

Mrinmay Sarkar <quic_msarkar@quicinc.com>
    PCI: epf-mhi: Update device ID for SA8775P

Paul Burton <paulburton@kernel.org>
    clocksource: mips-gic-timer: Enable counter when CPUs start

Paul Burton <paulburton@kernel.org>
    MIPS: pm-cps: Use per-CPU variables as per-CPU, not per-core

Subramanian Mohan <subramanian.mohan@intel.com>
    pps: generators: replace copy of pps-gen info struct with const pointer

Jason Gunthorpe <jgg@ziepe.ca>
    genirq/msi: Store the IOMMU IOVA directly in msi_desc instead of iommu_cookie

Uros Bizjak <ubizjak@gmail.com>
    x86/locking: Use ALT_OUTPUT_SP() for percpu_{,try_}cmpxchg{64,128}_op()

Rik van Riel <riel@surriel.com>
    x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional

Christian König <christian.koenig@amd.com>
    drm/amdgpu: remove all KFD fences from the BO on release

Bibo Mao <maobibo@loongson.cn>
    MIPS: Use arch specific syscall name match function

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/xe/oa: Ensure that polled read returns latest data

Xiao Liang <shaw.leon@gmail.com>
    rtnetlink: Lookup device in target netns when creating link

Xiao Liang <shaw.leon@gmail.com>
    net: ipv6: Init tunnel link-netns before registering dev

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: skcipher - Zap type in crypto_alloc_sync_skcipher

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: ahash - Set default reqsize from ahash_alg

Balbir Singh <balbirs@nvidia.com>
    x86/kaslr: Reduce KASLR entropy on most x86 systems

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Change POOL_NEXT_SIZE define value and make it global

Philippe Simons <simons.philippe@gmail.com>
    clk: sunxi-ng: h616: Reparent GPU clock during frequency changes

Song Liu <song@kernel.org>
    bpf: arm64: Silence "UBSAN: negation-overflow" warning

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: scsi_debug: First fixes for tapes

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: sanitize the return value of gpio_chip::set_config()

Jinliang Zheng <alexjlzheng@gmail.com>
    dm: fix unconditional IO throttle caused by REQ_PREFLUSH

Michael S. Tsirkin <mst@redhat.com>
    virtio: break and reset virtio devices on device_shutdown()

Nandakumar Edamana <nandakumar@nandakumar.co.in>
    libbpf: Fix out-of-bound read

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    net: stmmac: Correct usage of maximum queue number macros

Christoph Hellwig <hch@lst.de>
    loop: check in LO_FLAGS_DIRECT_IO in loop_default_blocksize

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Update timestamp only for supervisor IOCs

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Add correct match to check IPSec syndromes for switchdev mode

Matthias Fend <matthias.fend@emfend.at>
    media: tc358746: improve calculation of the D-PHY timing registers

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Disable test-pattern control on adv7180

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: menu: Avoid discarding useful information

Konstantin Shkolnyy <kshk@linux.ibm.com>
    vdpa/mlx5: Fix mlx5_vdpa_get_config() endianness on big-endian machines

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Return queue full for page alloc failures during copy

Waiman Long <longman@redhat.com>
    x86/nmi: Add an emergency handler in nmi_desc & use it in nmi_shootdown_cpus()

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt8188: Add reference for dmic clocks

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt8188: Treat DMIC_GAINx_CUR as non-volatile

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: Fix mismatch type comparison in custom_float

Navid Assadian <Navid.Assadian@amd.com>
    drm/amd/display: Add opp recout adjustment

Assadian, Navid <navid.assadian@amd.com>
    drm/amd/display: Fix mismatch type comparison

Samson Tam <Samson.Tam@amd.com>
    drm/amd/display: fix check for identity ratio

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: fix dcn4x init failed

Yihan Zhu <Yihan.Zhu@amd.com>
    drm/amd/display: handle max_downscale_src_width fail check

Nir Lichtman <nir@lichtman.org>
    x86/build: Fix broken copy command in genimage.sh when making isoimage

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: RPM: Register driver with PCI subsys IDs

Amery Hung <amery.hung@bytedance.com>
    bpf: Search and add kfuncs in struct_ops prologue and epilogue

Andrew Davis <afd@ti.com>
    soc: ti: k3-socinfo: Do not use syscon helper to build regmap

Ramasamy Kaliappan <quic_rkaliapp@quicinc.com>
    wifi: ath12k: Improve BSS discovery with hidden SSID in 6 GHz band

Dang Huynh <danct12@riseup.net>
    pinctrl: qcom: msm8917: Add MSM8937 wsa_reset pin

Eric Dumazet <edumazet@google.com>
    tcp: be less liberal in TSEcr received while in SYN_RECV state

Hangbin Liu <liuhangbin@gmail.com>
    bonding: report duplicate MAC address in all situations

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: Parse channel from IE to correct invalid hardware reports during scanning

Roger Quadros <rogerq@kernel.org>
    dmaengine: ti: k3-udma-glue: Drop skip_fdq argument from k3_udma_glue_reset_rx_chn

Arnd Bergmann <arnd@arndb.de>
    net: xgene-v2: remove incorrect ACPI_PTR annotation

Eric Woudstra <ericwouds@gmail.com>
    net: ethernet: mtk_ppe_offload: Allow QinQ, double ETH_P_8021Q only

Lizhi Hou <lizhi.hou@amd.com>
    accel/amdxdna: Check interrupt register before mailbox_rx_worker exits

Yuanjun Gong <ruc_gongyuanjun@163.com>
    leds: pwm-multicolor: Add check for fwnode_property_read_u32

Daniel Gomez <da.gomez@samsung.com>
    drm/xe: xe_gen_wa_oob: replace program_invocation_short_name

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: KFD release_work possible circular locking

Inochi Amaoto <inochiama@gmail.com>
    pinctrl: sophgo: avoid to modify untouched bit when setting cv1800 pinconf

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    driver core: faux: only create the device if probe() succeeds

Kevin Krakauer <krakauer@google.com>
    selftests/net: have `gro.sh -t` return a correct exit code

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Avoid report two health errors on same syndrome

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/pf: Create a link between PF and VF devices

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/vf: Retry sending MMIO request to GUC on timeout error

Viresh Kumar <viresh.kumar@linaro.org>
    firmware: arm_ffa: Set dma_mask for ffa devices

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Add a softdep to MIP MSI-X driver

Stanimir Varbanov <svarbanov@suse.de>
    PCI: brcmstb: Expand inbound window size up to 64GB

Vinith Kumar R <quic_vinithku@quicinc.com>
    wifi: ath12k: Report proper tx completion status to mac80211

Hector Martin <marcan@marcan.st>
    soc: apple: rtkit: Implement OSLog buffers properly

Janne Grunau <j@jannau.net>
    soc: apple: rtkit: Use high prio work queue

Rob Herring (Arm) <robh@kernel.org>
    perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters

Kuhanh Murugasen Krishnan <kuhanh.murugasen.krishnan@intel.com>
    fpga: altera-cvp: Increase credit timeout

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: mtk_dpi: Add checks for reg_h_fre_con existence

Li Bin <bin.li@microchip.com>
    ARM: at91: pm: fix at91_suspend_finish for ZQ calibration

Alexander Stein <alexander.stein@ew.tq-group.com>
    hwmon: (gpio-fan) Add missing mutex locks

Huisong Li <lihuisong@huawei.com>
    hwmon: (acpi_power_meter) Fix the fake power alarm reporting

Breno Leitao <leitao@debian.org>
    x86/bugs: Make spectre user default depend on MITIGATION_SPECTRE_V2

Xu Yang <xu.yang_2@nxp.com>
    PM: sleep: Suppress sleeping parent warning in special case

Ahmad Fatoum <a.fatoum@pengutronix.de>
    clk: imx8mp: inform CCF of maximum frequency of clocks

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Handle uvc menu translation inside uvc_get_le_value

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add sanity check to uvc_ioctl_xu_ctrl_map

Caleb Sander Mateos <csander@purestorage.com>
    ublk: complete command synchronously on error

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    null_blk: generate null_blk configfs features string

Christoph Hellwig <hch@lst.de>
    block: mark bounce buffering as incompatible with integrity

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Add uv swap for cluster window

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: fib: Hold rtnl_net_lock() in ip_rt_ioctl().

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: fib: Move fib_valid_key_len() to rtm_to_fib_config().

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    scsi: logging: Fix scsi_logging_level bounds

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    ALSA: hda/realtek: Enable PC beep passthrough for HP EliteBook 855 G7

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    perf/hw_breakpoint: Return EOPNOTSUPP for unsupported breakpoint type

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix perf_mmap() failure path

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix mpls maximum labels list parsing

Paul Elder <paul.elder@ideasonboard.com>
    media: imx335: Set vblank immediately

Yi Liu <yi.l.liu@intel.com>
    iommufd: Disallow allocating nested parent domain with fault ID

Uday Shankar <ushankar@purestorage.com>
    ublk: enforce ublks_max only for unprivileged devices

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    dpll: Add an assertion to check freq_supported_num

Andrei Botila <andrei.botila@oss.nxp.com>
    net: phy: nxp-c45-tja11xx: add match_phy_device to TJA1103/TJA1104

Lee Trager <lee@trager.us>
    eth: fbnic: Prepend TSENE FW fields with FBNIC_FW

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    net: ethernet: ti: cpsw_new: populate netdev of_node

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: Set possible clones for all encoders

Paul E. McKenney <paulmck@kernel.org>
    rcu: Fix get_state_synchronize_rcu_full() GP-start detection

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Use "unsigned int" instead of bare "unsigned"

Hans Verkuil <hverkuil@xs4all.nl>
    media: cx231xx: set device_caps for 417

Peter Zijlstra <peterz@infradead.org>
    perf/core: Clean up perf_try_init_event()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add offset normalization in VCN v5.0.1

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Avoid HDP flush on JPEG v5.0.1

Aric Cyr <Aric.Cyr@amd.com>
    drm/amd/display: Request HW cursor on DCN3.2 with SubVP

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Fix p-state type when p-state is unsupported

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Fix DMUB reset sequence for DCN401

George Shen <george.shen@amd.com>
    drm/amd/display: Skip checking FRL_MODE bit for PCON BW determination

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Ensure DMCUB idle before reset on DCN31/DCN35

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Reinit FW shared flags on VCN v5.0.1

Victor Lu <victorchengchi.lu@amd.com>
    drm/amdgpu: Do not program AGP BAR regs under SRIOV in gfxhub_v1_0.c

Gustavo Sousa <gustavo.sousa@intel.com>
    drm/xe: Disambiguate GMDID-based IP names

Matti Lehtimäki <matti.lehtimaki@gmail.com>
    remoteproc: qcom_wcnss: Handle platforms with only single power domain

Ming Lei <ming.lei@redhat.com>
    blk-throttle: don't take carryover for prioritized processing of metadata

Choong Yong Liang <yong.liang.choong@linux.intel.com>
    net: phylink: use pl->link_interface in phylink_expects_phy()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/gem: Test for imported GEM buffers with helper

Matthew Wilcox (Oracle) <willy@infradead.org>
    orangefs: Do not truncate file size

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    soc: mediatek: mtk-mutex: Add DPI1 SOF/EOF to MT8188 mutex tables

Ming-Hung Tsai <mtsai@redhat.com>
    dm cache: prevent BUG_ON by blocking retries on failed device resumes

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: set page size to the xHCI-supported size

Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
    media: cec: use us_to_ktime() where appropriate

Markus Elfring <elfring@users.sourceforge.net>
    media: c8sectpfe: Call of_node_put(i2c_bus) only once in c8sectpfe_probe()

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: Switch DSI-B clock parent to PLLD on Tegra114

Arnd Bergmann <arnd@arndb.de>
    soc: samsung: include linux/array_size.h where needed

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Retry BO allocation

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Nuke VM's mapping upon close

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ieee802154: ca8210: Use proper setters and getters for bitwise types

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: ds1307: stop disabling alarms on probe

Michael Jeanson <mjeanson@efficios.com>
    rseq: Fix segfault on registration when rseq_cs is non-zero

Eric Dumazet <edumazet@google.com>
    tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Improve data consistency at polling

Andreas Schwab <schwab@linux-m68k.org>
    powerpc/prom_init: Fixup missing #size-cells on PowerBook6,7

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Resize aperture for the IGX PCIe C5 slot

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator

Emily Deng <Emily.Deng@amd.com>
    drm/amdgpu: Fix missing drain retry fault the last entry

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: increase RAS bad page threshold

Alex Sierra <alex.sierra@amd.com>
    drm/amdkfd: clear F8_MODE for gfx950

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: Set per-process flags only once cik/vi

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdkfd: Set per-process flags only once for gfx9/10/11/12

Sven Schwermer <sven@svenschwermer.de>
    crypto: mxs-dcp - Only set OTP_KEY bit for OTP key

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: lzo - Fix compression buffer overrun

Niklas Cassel <cassel@kernel.org>
    selftests: pci_endpoint: Skip disabled BARs

Niklas Cassel <cassel@kernel.org>
    misc: pci_endpoint_test: Give disabled BARs a distinct error code

Christian Bruel <christian.bruel@foss.st.com>
    PCI: endpoint: pci-epf-test: Fix double free that causes kernel to oops

Chin-Ting Kuo <chin-ting_kuo@aspeedtech.com>
    watchdog: aspeed: Update bootstatus handling

Kyunghwan Seo <khwan.seo@samsung.com>
    watchdog: s3c2410_wdt: Fix PMU register bits for ExynosAutoV920 SoC

Aaron Kling <luceoscutum@gmail.com>
    cpufreq: tegra186: Share policy per cluster

K Prateek Nayak <kprateek.nayak@amd.com>
    fs/pipe: Limit the slots in pipe_resize_ring()

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd/pgtbl_v2: Improve error handling

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/vt-d: Check if SVA is supported when attaching the SVA domain

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: change coresight_trace_id_map's lock type to raw_spinlock_t

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight-etb10: change etb_drvdata spinlock's type to raw_spinlock_t

Nilay Shroff <nilay@linux.ibm.com>
    block: acquire q->limits_lock while reading sysfs attributes

Coly Li <colyli@kernel.org>
    badblocks: Fix a nonsense WARN_ON() which checks whether a u64 variable < 0

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sm8250: explicitly set format in sm8250_be_hw_params_fixup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    auxdisplay: charlcd: Partially revert "Move hwidth and bwidth to struct hd44780_common"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Check for empty queue in run_queue

Leon Huang <Leon.Huang1@amd.com>
    drm/amd/display: Fix incorrect DPCD configs while Replay/PSR switch

Peichen Huang <PeiChen.Huang@amd.com>
    drm/amd/display: not abort link train when bw is low

Zhikai Zhai <zhikai.zhai@amd.com>
    drm/amd/display: calculate the remain segments for all pipes

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: remove minimum Dispclk and apply oem panel timing.

Willem de Bruijn <willemb@google.com>
    ipv6: save dontfrag in cork

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: increase max jumbo packet size on RTL8125/RTL8126

Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: cfg80211: allow IR in 20 MHz configurations

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix U-APSD check in ML reconfiguration

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211_hwsim: Fix MLD address translation

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix warning on disconnect during failed ML reconf

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Update the link address when a link is added

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't include MLE in ML reconf per-STA profile

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: fix the ECKV UEFI variable name

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mark Br device not integrated

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix debug actions order

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: w/a FW SMPS mode selection

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: don't warn when if there is a FW error

Marcos Paulo de Souza <mpdesouza@suse.com>
    printk: Check CON_SUSPEND when unblanking a console

Robin Murphy <robin.murphy@arm.com>
    iommu: Keep dev->iommu state consistent

Kurt Borja <kuurtb@gmail.com>
    hwmon: (dell-smm) Increment the number of fans

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: fix setting the TK when associated

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Don't change the status of stalled TDs on failed Stop EP

Erick Shepherd <erick.shepherd@ni.com>
    mmc: sdhci: Disable SD card clock before changing parameters

Kaustabh Chakraborty <kauschluss@disroot.org>
    mmc: dw_mmc: add exynos7870 DW MMC support

Ryan Roberts <ryan.roberts@arm.com>
    arm64/mm: Check PUD_TYPE_TABLE in pud_bad()

Ryan Roberts <ryan.roberts@arm.com>
    arm64/mm: Check pmd_table() in pmd_trans_huge()

Andy Yan <andy.yan@rock-chips.com>
    phy: rockchip: usbdp: Only verify link rates/lanes/voltage when the corresponding set flags are set

Kees Cook <kees@kernel.org>
    PNP: Expand length of fixup id string

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    netfilter: conntrack: Bound nf_conntrack sysctl writes

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: set force HE TB mode when connecting to 11ax AP

Ching-Te Ku <ku920601@realtek.com>
    wifi: rtw89: coex: Fix coexistence report not show as expected

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    timer_list: Don't use %pK through printk()

Jaakko Karrenpalo <jkarrenpalo@gmail.com>
    net: hsr: Fix PRP duplicate detection

Jonas Karlman <jonas@kwiboo.se>
    net: stmmac: dwmac-rk: Validate GRF and peripheral GRF during probe

Thomas Gleixner <tglx@linutronix.de>
    posix-timers: Ensure that timer initialization is fully visible

Eric Dumazet <edumazet@google.com>
    posix-timers: Add cond_resched() to posix_timer_add() search loop

Maher Sanalla <msanalla@nvidia.com>
    RDMA/uverbs: Propagate errors from rdma_lookup_get_uobject()

Baokun Li <libaokun1@huawei.com>
    ext4: do not convert the unwritten extents if data writeback fails

Baokun Li <libaokun1@huawei.com>
    ext4: reject the 'data_err=abort' option in nojournal mode

Manuel Fombuena <fombuena@outlook.com>
    leds: leds-st1202: Initialize hardware before DT node child operations

Manuel Fombuena <fombuena@outlook.com>
    leds: Kconfig: leds-st1202: Add select for required LEDS_TRIGGER_PATTERN

Taniya Das <quic_tdas@quicinc.com>
    clk: qcom: lpassaudiocc-sc7280: Add support for LPASS resets for QCM6490

Ryan Walklin <ryan@testtoast.com>
    ASoC: sun4i-codec: correct dapm widgets and controls for h616

Ryan Walklin <ryan@testtoast.com>
    ASoC: sun4i-codec: support hp-det-gpios property

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Update SRIOV video codec caps

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: don't read registers in mqd init

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx12: don't read registers in mqd init

Shree Ramamoorthy <s-ramamoorthy@ti.com>
    mfd: tps65219: Remove TPS65219_REG_TI_DEV_ID check

Eder Zulian <ezulian@redhat.com>
    mfd: syscon: Add check for invalid resource size

Prathamesh Shete <pshete@nvidia.com>
    pinctrl-tegra: Restore SFSEL bit when freeing pins

Frediano Ziglio <frediano.ziglio@cloud.com>
    xen: Add support for XenServer 6.1 platform device

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: use the correct ndev to find pnetid by pnetid table

Mikulas Patocka <mpatocka@redhat.com>
    dm: restrict dm device size to 2^63-512 bytes

Shashank Gupta <shashankg@marvell.com>
    crypto: octeontx2 - suppress auth failure screaming due to negative tests

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: do not clear SYMBOL_VALID when reading include/config/auto.conf

Seyediman Seyedarab <imandevel@gmail.com>
    kbuild: fix argument parsing in scripts/config

Yonghong Song <yonghong.song@linux.dev>
    bpf: Allow pre-ordering for bpf cgroup progs

Rae Moar <rmoar@google.com>
    kunit: tool: Fix bug in parsing test plan

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    ASoC: mediatek: mt6359: Add stub for mt6359_accdet_enable_jack_detect

Linus Walleij <linus.walleij@linaro.org>
    ASoC: pcm6240: Drop bogus code handling IRQ as GPIO

Chenyuan Yang <chenyuan0y@gmail.com>
    ASoC: sma1307: Add NULL check in sma1307_setting_loaded()

Sergio Perez Gonzalez <sperezglz@gmail.com>
    spi: spi-mux: Fix coverity issue, unchecked return value

Gao Xiang <xiang@kernel.org>
    erofs: initialize decompression early

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Do not add non-active NVM if NVM upgrade is disabled for retimer

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix error handling inconsistencies in check()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: rv3032: fix EERD location

Ilpo Järvinen <ij@kernel.org>
    tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()

Jan Kara <jack@suse.cz>
    jbd2: do not try to recover wiped journal

Frank Li <Frank.Li@nxp.com>
    PCI: dwc: Use resource start as ioremap() input in dw_pcie_pme_turn_off()

Mykyta Yatsenko <yatsenko@meta.com>
    bpf: Return prog btf_id without capable check

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpftool: Using the right format specifiers

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Handle INTx IRQ_NOTCONNECTED

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: ERASE does not change tape location

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Tighten the page format heuristics with MODE SELECT

Al Viro <viro@zeniv.linux.org.uk>
    hypfs_create_cpu_files(): add missing check for hypfs_mkdir() failure

Christian Göttsche <cgzones@googlemail.com>
    ext4: reorder capability check last

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Call secondary mmu notifier when flushing the tlb

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: add support for thermal sensor event reception

shantiprasad shettar <shantiprasad.shettar@broadcom.com>
    bnxt_en: Query FW parameters when the CAPS_CHANGE bit is set

Jeff Chen <jeff.chen_1@nxp.com>
    wifi: mwifiex: Fix HT40 bandwidth issue.

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5: Preserve rate settings when creating a rate node

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Update min_low_pfn to match changes in uml_reserved

Benjamin Berg <benjamin@sipsolutions.net>
    um: Store full CSGSFS and SS register from mcontext

Nick Hu <nick.hu@sifive.com>
    clocksource/drivers/timer-riscv: Stop stimecmp when cpu hotplug

Ming Lei <ming.lei@redhat.com>
    loop: move vfs_fsync() out of loop_update_dio()

Heming Zhao <heming.zhao@suse.com>
    dlm: make tcp still work in multi-link env

Heiko Carstens <hca@linux.ibm.com>
    s390/tlb: Use mm_has_pgste() instead of mm_alloc_pgste()

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix missing STOP for master request

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: adjust drm_firmware_drivers_only() handling

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't free conflicting apertures for non-display devices

Jing Zhou <Jing.Zhou@amd.com>
    drm/amd/display: Guard against setting dispclk low for dcn31x

Flora Cui <flora.cui@amd.com>
    drm/amdgpu: release xcp_mgr on exit

Chen Linxuan <chenlinxuan@uniontech.com>
    blk-cgroup: improve policy registration error handling

Filipe Manana <fdmanana@suse.com>
    btrfs: send: return -ENAMETOOLONG when attempting a path that is too long

Filipe Manana <fdmanana@suse.com>
    btrfs: get zone unusable bytes while holding lock at btrfs_reclaim_bgs_work()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix non-empty delayed iputs list on unmount due to async workers

Qu Wenruo <wqu@suse.com>
    btrfs: run btrfs_error_commit_super() early

Mark Harmstone <maharmstone@fb.com>
    btrfs: avoid linker error in btrfs_find_create_tree_block()

Boris Burkov <boris@bur.io>
    btrfs: make btrfs_discard_workfn() block_group ref explicit

Vitalii Mordan <mordan@ispras.ru>
    i2c: pxa: fix call balance of i2c->clk handling routines

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    i2c: amd-asf: Set cmd variable when encountering an error

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    i2c: qup: Vote for interconnect bandwidth to DRAM

Philip Redkin <me@rarity.fan>
    x86/mm: Check return value from memblock_phys_alloc_range()

Mario Limonciello <mario.limonciello@amd.com>
    x86/amd_node: Add SMN offsets to exclusive region access

Sohil Mehta <sohil.mehta@intel.com>
    x86/microcode: Update the Intel processor flag scan check

Sohil Mehta <sohil.mehta@intel.com>
    x86/smpboot: Fix INIT delay assignment for extended Intel Families

Ingo Molnar <mingo@kernel.org>
    x86/stackprotector/64: Only export __ref_stack_chk_guard on CONFIG_SMP

Thomas Huth <thuth@redhat.com>
    x86/headers: Replace __ASSEMBLY__ with __ASSEMBLER__ in UAPI headers

Thomas Huth <thuth@redhat.com>
    x86/headers: Replace __ASSEMBLY__ with __ASSEMBLER__ in non-UAPI headers

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: fix fails to enter low power mode in suspend state

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7925: Simplify HIF suspend handling to avoid suspend fail

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: load the appropriate CLC data based on hardware type

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: revise TXS size

Rex Lu <rex.lu@mediatek.com>
    wifi: mt76: mt7996: fix SER reset trigger on WED reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: scan: set vif offchannel link for scanning/roc

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: use the correct vif link for scanning/roc

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: only mark tx-status-failed frames as ACKed on mt76x0/2

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: implement driver specific get_txpower function

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: scan: fix setting tx_info fields

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: Check link_conf pointer in mt76_connac_mcu_sta_basic_tlv()

Eric Dumazet <edumazet@google.com>
    cgroup/rstat: avoid disabling irqs for O(num_cpu)

Victor Skvortsov <victor.skvortsov@amd.com>
    drm/amdgpu: Skip pcie_replay_count sysfs creation for VF

Erick Shepherd <erick.shepherd@ni.com>
    mmc: host: Wait for Vdd to settle on card power off

Stefan Wahren <wahrenst@gmx.net>
    staging: vchiq_arm: Create keep-alive thread during probe

Christian Brauner <brauner@kernel.org>
    pidfs: improve multi-threaded exec and premature thread-group leader exit polling

Robert Richter <rrichter@amd.com>
    libnvdimm/labels: Fix divide error in nd_label_data_init()

Nicolas Bretz <bretznic@gmail.com>
    ext4: on a remount, only log the ro or r/w state when it has changed

Roger Pau Monne <roger.pau@citrix.com>
    xen/pci: Do not register devices with segments >= 0x10000

Roger Pau Monne <roger.pau@citrix.com>
    PCI: vmd: Disable MSI remapping bypass under Xen

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: set precise mem ops caps to disabled for gfx 11 and 12

Christian König <christian.koenig@amd.com>
    drm/amdgpu: use GFP_NOWAIT for memory allocations

Christian König <christian.koenig@amd.com>
    drm/amdgpu: rework how isolation is enforced v2

Christian König <christian.koenig@amd.com>
    drm/amdgpu: rework how the cleaner shader is emitted v3

Flora Cui <flora.cui@amd.com>
    drm/amdgpu/discovery: check ip_discovery fw file available

Trond Myklebust <trond.myklebust@hammerspace.com>
    pNFS/flexfiles: Report ENETDOWN as a connection error

Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
    i2c: qcom-geni: Update i2c frequency table to match hardware guidance

Thippeswamy Havalige <thippeswamy.havalige@amd.com>
    PCI: xilinx-cpm: Add cpm_csr register mapping for CPM5_HOST1 variant

Ian Rogers <irogers@google.com>
    tools/build: Don't pass test log files to linker

ChunHao Lin <hau@realtek.com>
    r8169: disable RTL8126 ZRX-DC timeout

Frank Li <Frank.Li@nxp.com>
    PCI: dwc: ep: Ensure proper iteration over outbound map windows

Mark Zhang <markzhang@nvidia.com>
    net/mlx5e: Use right API to free bitmap memory

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Properly disable uaccess validation

Ryo Takakura <ryotkkr98@gmail.com>
    lockdep: Fix wait context check on softirq for PREEMPT_RT

Jing Su <jingsusu@didiglobal.com>
    dql: Fix dql->limit value when reset.

Conor Dooley <conor.dooley@microchip.com>
    RISC-V: add vector extension validation checks

Pedro Nishiyama <nishiyama.pedro@gmail.com>
    Bluetooth: Disable SCO support if READ_VOICE_SETTING is unsupported/broken

Sean Wang <sean.wang@mediatek.com>
    Bluetooth: btmtksdio: Prevent enabling interrupts after IRQ handler removal

Alice Guo <alice.guo@nxp.com>
    thermal/drivers/qoriq: Power down TMU on system suspend

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    thermal/drivers/mediatek/lvts: Start sensor interrupts disabled

Hans-Frieder Vogt <hfdevel@gmx.net>
    net: tn40xx: create swnode for mdio and aqr105 phy and add to mdiobus

Hans-Frieder Vogt <hfdevel@gmx.net>
    net: tn40xx: add pci-id of the aqr105-based Tehuti TN4010 cards

Daniel Hsu <d486250@gmail.com>
    mctp: Fix incorrect tx flow invalidation condition in mctp-i2c

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa883x: Correct VI sense channel mask

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa884x: Correct VI sense channel mask

Luis de Arquer <luis.dearquer@inertim.com>
    spi-rockchip: Fix register out of bounds access

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpcbind should never reset the port to the value '0'

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: rpc_clnt_set_transport() must not change the autobind setting

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Treat ENETUNREACH errors as fatal for state recovery

Pali Rohár <pali@kernel.org>
    cifs: Check if server supports reparse points before using them

Pali Rohár <pali@kernel.org>
    cifs: Fix getting DACL-only xattr system.cifs_acl and system.smb3_acl

Pali Rohár <pali@kernel.org>
    cifs: Fix establishing NetBIOS session for SMB2+ connection

Namjae Jeon <linkinjeon@kernel.org>
    cifs: add validation check for the fields in smb_aces

Pali Rohár <pali@kernel.org>
    cifs: Set default Netbios RFC1001 server name to hostname in UNC

Zsolt Kajtar <soci@c64.rulez.org>
    fbdev: core: tileblit: Implement missing margin clearing for tileblit

Zsolt Kajtar <soci@c64.rulez.org>
    fbcon: Use correct erase colour for clearing in fbcon

Shixiong Ou <oushixiong@kylinos.cn>
    fbdev: fsl-diu-fb: add missing device_remove_file()

Samuel Holland <samuel.holland@sifive.com>
    riscv: Allow NOMMU kernels to access all of RAM

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: use error ret code of of_parse_phandle_with_args()

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: pcc: Use acpi_os_ioremap() instead of ioremap()

Jonathan McDowell <noodles@meta.com>
    tpm: Convert warn to dbg in tpm2_start_auth_session()

Diogo Ivo <diogo.ivo@siemens.com>
    ACPI: PNP: Add Intel OC Watchdog IDs to non-PNP device list

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    tracing: Mark binary printing functions with __printf() attribute

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Use kaslr address instead of text delta

Yi Liu <yi.l.liu@intel.com>
    iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability

Jinqian Yang <yangjinqian1@huawei.com>
    arm64: Add support for HIP09 Spectre-BHB mitigation

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Don't allow waiting for exiting tasks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't allow waiting for exiting tasks

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/msg: initialise msg request opcode

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: call bh_read in get_block only when necessary

Matt Johnston <matt@codeconstruct.com.au>
    fuse: Return EPERM rather than ENOSYS from link()

Wang Zhaolong <wangzhaolong1@huawei.com>
    smb: client: Store original IO parameters and prevent zero IO sizes

Pali Rohár <pali@kernel.org>
    cifs: Fix negotiate retry functionality

Pali Rohár <pali@kernel.org>
    cifs: Fix access_flags_to_smbopen_mode

Pali Rohár <pali@kernel.org>
    cifs: Fix querying and creating MF symlinks over SMB1

Pali Rohár <pali@kernel.org>
    cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix no AP queue sharing allowed message written to kernel log

Xin Li (Intel) <xin@zytor.com>
    x86/fred: Fix system hang during S4 resume with FRED enabled

Daniel Gomez <da.gomez@samsung.com>
    kconfig: merge_config: use an empty file as initfile

Haoran Jiang <jianghaoran@kylinos.cn>
    samples/bpf: Fix compilation failure for samples/bpf on LoongArch Fedora

Brandon Kammerdiener <brandon.kammerdiener@intel.com>
    bpf: fix possible endless loop in BPF map iteration

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't duplicate flushing in io_req_post_cqe

Darrick J. Wong <djwong@kernel.org>
    block: hoist block size validation code to a separate function

Darrick J. Wong <djwong@kernel.org>
    block: fix race between set_blocksize and read paths

Ihor Solodrai <ihor.solodrai@linux.dev>
    selftests/bpf: Mitigate sockmap_ktls disconnect_after_delete failure

Felix Kuehling <felix.kuehling@amd.com>
    drm/amdgpu: Allow P2P access through XGMI

Nicholas Susanto <nsusanto@amd.com>
    drm/amd/display: Enable urgent latency adjustment on DCN35

Davidlohr Bueso <dave@stgolabs.net>
    fs/ext4: use sleeping version of sb_find_get_block()

Davidlohr Bueso <dave@stgolabs.net>
    fs/jbd2: use sleeping version of __find_get_block()

Davidlohr Bueso <dave@stgolabs.net>
    fs/ocfs2: use sleeping version of __find_get_block()

Davidlohr Bueso <dave@stgolabs.net>
    fs/buffer: use sleeping version of __find_get_block()

Davidlohr Bueso <dave@stgolabs.net>
    fs/buffer: introduce sleeping flavors for pagecache lookups

Davidlohr Bueso <dave@stgolabs.net>
    fs/buffer: split locking for pagecache lookups

Frederick Lawler <fred@cloudflare.com>
    ima: process_measurement() needlessly takes inode_lock() on MAY_READ

Balbir Singh <balbirs@nvidia.com>
    dma-mapping: Fix warning reported for missing prototype

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpi3mr: Add level check to control event logging

Dongli Zhang <dongli.zhang@oracle.com>
    vhost-scsi: protect vq->log_used with vq->mutex

Stefano Garzarella <sgarzare@redhat.com>
    vhost_task: fix vhost_task_create() documentation

gaoxu <gaoxu2@honor.com>
    cgroup: Fix compilation issue due to cgroup_mutex not being exported

David Sterba <dsterba@suse.com>
    btrfs: tree-checker: adjust error code for header level check

Marek Szyprowski <m.szyprowski@samsung.com>
    dma-mapping: avoid potential unused data compilation warning

Hans de Goede <hdegoede@redhat.com>
    mei: vsc: Use struct vsc_tp_packet as vsc-tp tx_buf and rx_buf type

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    intel_th: avoid using deprecated page->mapping, index fields

Balbir Singh <balbirs@nvidia.com>
    dma/mapping.c: dev_dbg support for dma_addressing_limited

Zhongqiu Han <quic_zhonhan@quicinc.com>
    virtio_ring: Fix data race by tagging event_triggered as racy for KCSAN

Manish Pandey <quic_mapa@quicinc.com>
    scsi: ufs: Introduce quirk to extend PA_HIBERN8TIME for UFS devices

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Fix timeout on deleted connection

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: qfprom: switch to 4-byte aligned reads

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: core: update raw_len if the bit reading is required

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: core: verify cell's raw_len

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    nvmem: core: fix bit offsets of more than one byte

Heiko Stuebner <heiko@sntech.de>
    nvmem: rockchip-otp: add rk3576 variant data

Heiko Stuebner <heiko@sntech.de>
    nvmem: rockchip-otp: Move read-offset into variant-data

Pengyu Luo <mitltlatltl@gmail.com>
    cpufreq: Add SM8650 to cpufreq-dt-platdev blocklist

Damien Le Moal <dlemoal@kernel.org>
    nvmet: pci-epf: clear completion queue IRQ flag on delete

Damien Le Moal <dlemoal@kernel.org>
    nvmet: pci-epf: Keep completion queues mapped

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Assert PLL reset on PHY power off

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Lock around hardware registers and driver data

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Move IRQ request in probe

John Olender <john.olender@gmail.com>
    drm/amd/display: Defer BW-optimization-blocked DRR adjustments

Zhongwei Zhang <Zhongwei.Zhang@amd.com>
    drm/amd/display: Correct timing_adjust_pending flag setting.

Danny Wang <danny.wang@amd.com>
    drm/amd/display: Do not enable replay when vtotal update is pending.


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   2 +
 Documentation/driver-api/pps.rst                   |   3 +-
 Documentation/driver-api/serial/driver.rst         |   2 +-
 Documentation/hwmon/dell-smm-hwmon.rst             |  14 +-
 Documentation/networking/net_cachelines/snmp.rst   |   1 +
 Makefile                                           |   8 +-
 arch/arm/boot/dts/nvidia/tegra114.dtsi             |   2 +-
 arch/arm/mach-at91/pm.c                            |  21 +-
 .../boot/dts/allwinner/sun50i-h6-beelink-gs1.dts   |  38 +-
 .../boot/dts/allwinner/sun50i-h6-orangepi-3.dts    |  14 +-
 .../boot/dts/allwinner/sun50i-h6-orangepi.dtsi     |  22 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   8 +-
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi     |   2 +-
 .../dts/nvidia/tegra234-p3740-0002+p3701-0008.dts  |  10 +
 arch/arm64/boot/dts/xilinx/zynqmp-clk-ccf.dtsi     |  15 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/pgtable.h                   |  27 +-
 arch/arm64/kernel/proton-pack.c                    |   1 +
 arch/arm64/net/bpf_jit_comp.c                      |   6 +-
 arch/loongarch/kernel/Makefile                     |   8 +-
 arch/loongarch/kvm/Makefile                        |   2 +-
 arch/mips/include/asm/ftrace.h                     |  16 +
 arch/mips/kernel/pm-cps.c                          |  30 +-
 arch/powerpc/include/asm/mmzone.h                  |   1 +
 arch/powerpc/kernel/prom_init.c                    |   4 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   3 +-
 arch/powerpc/mm/numa.c                             |   2 +-
 arch/powerpc/perf/core-book3s.c                    |  20 +
 arch/powerpc/perf/isa207-common.c                  |   4 +-
 arch/powerpc/platforms/pseries/iommu.c             | 139 ++++--
 arch/riscv/include/asm/cpufeature.h                |   3 +
 arch/riscv/include/asm/page.h                      |  12 +-
 arch/riscv/include/asm/pgtable.h                   |   2 +-
 arch/riscv/kernel/Makefile                         |   4 +-
 arch/riscv/kernel/cpufeature.c                     |  60 ++-
 arch/riscv/mm/tlbflush.c                           |  37 +-
 arch/s390/hypfs/hypfs_diag_fs.c                    |   2 +
 arch/s390/include/asm/tlb.h                        |   2 +-
 arch/s390/kernel/crash_dump.c                      |  62 +--
 arch/um/kernel/mem.c                               |   1 +
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/boot/boot.h                               |   4 +-
 arch/x86/boot/genimage.sh                          |   5 +-
 arch/x86/entry/entry.S                             |   2 +-
 arch/x86/entry/vdso/extable.h                      |   2 +-
 arch/x86/events/amd/ibs.c                          |  20 +-
 arch/x86/events/intel/ds.c                         |   9 +-
 arch/x86/include/asm/alternative.h                 |   6 +-
 arch/x86/include/asm/asm.h                         |  10 +-
 arch/x86/include/asm/boot.h                        |   2 +-
 arch/x86/include/asm/bug.h                         |   5 +-
 arch/x86/include/asm/cfi.h                         |  11 +
 arch/x86/include/asm/cpufeature.h                  |   4 +-
 arch/x86/include/asm/cpumask.h                     |   4 +-
 arch/x86/include/asm/current.h                     |   4 +-
 arch/x86/include/asm/desc_defs.h                   |   4 +-
 arch/x86/include/asm/dwarf2.h                      |   2 +-
 arch/x86/include/asm/fixmap.h                      |   4 +-
 arch/x86/include/asm/frame.h                       |  10 +-
 arch/x86/include/asm/fred.h                        |   4 +-
 arch/x86/include/asm/fsgsbase.h                    |   4 +-
 arch/x86/include/asm/ftrace.h                      |   8 +-
 arch/x86/include/asm/hw_irq.h                      |   4 +-
 arch/x86/include/asm/ibt.h                         |  16 +-
 arch/x86/include/asm/idtentry.h                    |   6 +-
 arch/x86/include/asm/inst.h                        |   2 +-
 arch/x86/include/asm/intel-family.h                |   1 +
 arch/x86/include/asm/irqflags.h                    |  10 +-
 arch/x86/include/asm/jump_label.h                  |   4 +-
 arch/x86/include/asm/kasan.h                       |   2 +-
 arch/x86/include/asm/kexec.h                       |   4 +-
 arch/x86/include/asm/linkage.h                     |   6 +-
 arch/x86/include/asm/mem_encrypt.h                 |   4 +-
 arch/x86/include/asm/msr.h                         |   4 +-
 arch/x86/include/asm/nmi.h                         |   2 +
 arch/x86/include/asm/nops.h                        |   2 +-
 arch/x86/include/asm/nospec-branch.h               |   6 +-
 arch/x86/include/asm/orc_types.h                   |   4 +-
 arch/x86/include/asm/page.h                        |   4 +-
 arch/x86/include/asm/page_32.h                     |   4 +-
 arch/x86/include/asm/page_32_types.h               |   4 +-
 arch/x86/include/asm/page_64.h                     |   4 +-
 arch/x86/include/asm/page_64_types.h               |   2 +-
 arch/x86/include/asm/page_types.h                  |   4 +-
 arch/x86/include/asm/paravirt.h                    |  14 +-
 arch/x86/include/asm/paravirt_types.h              |   4 +-
 arch/x86/include/asm/percpu.h                      |  32 +-
 arch/x86/include/asm/perf_event.h                  |   1 +
 arch/x86/include/asm/pgtable-2level_types.h        |   4 +-
 arch/x86/include/asm/pgtable-3level_types.h        |   4 +-
 arch/x86/include/asm/pgtable-invert.h              |   4 +-
 arch/x86/include/asm/pgtable.h                     |  12 +-
 arch/x86/include/asm/pgtable_32.h                  |   4 +-
 arch/x86/include/asm/pgtable_32_areas.h            |   2 +-
 arch/x86/include/asm/pgtable_64.h                  |   6 +-
 arch/x86/include/asm/pgtable_64_types.h            |   4 +-
 arch/x86/include/asm/pgtable_types.h               |  10 +-
 arch/x86/include/asm/prom.h                        |   4 +-
 arch/x86/include/asm/pti.h                         |   4 +-
 arch/x86/include/asm/ptrace.h                      |   4 +-
 arch/x86/include/asm/purgatory.h                   |   4 +-
 arch/x86/include/asm/pvclock-abi.h                 |   4 +-
 arch/x86/include/asm/realmode.h                    |   4 +-
 arch/x86/include/asm/segment.h                     |   8 +-
 arch/x86/include/asm/setup.h                       |   6 +-
 arch/x86/include/asm/setup_data.h                  |   4 +-
 arch/x86/include/asm/sev-common.h                  |   2 +-
 arch/x86/include/asm/shared/tdx.h                  |   4 +-
 arch/x86/include/asm/shstk.h                       |   4 +-
 arch/x86/include/asm/signal.h                      |   8 +-
 arch/x86/include/asm/smap.h                        |   6 +-
 arch/x86/include/asm/smp.h                         |   4 +-
 arch/x86/include/asm/tdx.h                         |   4 +-
 arch/x86/include/asm/thread_info.h                 |  12 +-
 arch/x86/include/asm/unwind_hints.h                |   4 +-
 arch/x86/include/asm/vdso/getrandom.h              |   4 +-
 arch/x86/include/asm/vdso/gettimeofday.h           |   4 +-
 arch/x86/include/asm/vdso/processor.h              |   4 +-
 arch/x86/include/asm/vdso/vsyscall.h               |   4 +-
 arch/x86/include/asm/xen/interface.h               |  10 +-
 arch/x86/include/asm/xen/interface_32.h            |   4 +-
 arch/x86/include/asm/xen/interface_64.h            |   4 +-
 arch/x86/include/uapi/asm/bootparam.h              |   4 +-
 arch/x86/include/uapi/asm/e820.h                   |   4 +-
 arch/x86/include/uapi/asm/ldt.h                    |   4 +-
 arch/x86/include/uapi/asm/msr.h                    |   4 +-
 arch/x86/include/uapi/asm/ptrace-abi.h             |   6 +-
 arch/x86/include/uapi/asm/ptrace.h                 |   4 +-
 arch/x86/include/uapi/asm/setup_data.h             |   4 +-
 arch/x86/include/uapi/asm/signal.h                 |   8 +-
 arch/x86/kernel/Makefile                           |   2 +
 arch/x86/kernel/alternative.c                      |  30 ++
 arch/x86/kernel/amd_node.c                         |  41 ++
 arch/x86/kernel/cfi.c                              |  22 +-
 arch/x86/kernel/cpu/bugs.c                         |  10 +-
 arch/x86/kernel/cpu/microcode/intel.c              |   2 +-
 arch/x86/kernel/nmi.c                              |  42 ++
 arch/x86/kernel/paravirt.c                         |  17 +-
 arch/x86/kernel/reboot.c                           |  10 +-
 arch/x86/kernel/smpboot.c                          |   9 +-
 arch/x86/kernel/traps.c                            |  82 +++-
 arch/x86/math-emu/control_w.h                      |   2 +-
 arch/x86/math-emu/exception.h                      |   6 +-
 arch/x86/math-emu/fpu_emu.h                        |   6 +-
 arch/x86/math-emu/status_w.h                       |   6 +-
 arch/x86/mm/init.c                                 |   9 +-
 arch/x86/mm/init_64.c                              |  15 +-
 arch/x86/mm/kaslr.c                                |  10 +-
 arch/x86/mm/pgtable.c                              |  27 +-
 arch/x86/power/cpu.c                               |  14 +
 arch/x86/realmode/rm/realmode.h                    |   4 +-
 arch/x86/realmode/rm/wakeup.h                      |   2 +-
 arch/x86/um/os-Linux/mcontext.c                    |   3 +-
 block/badblocks.c                                  |   5 +-
 block/bdev.c                                       |  50 ++-
 block/blk-cgroup.c                                 |  30 +-
 block/blk-settings.c                               |   5 +
 block/blk-sysfs.c                                  | 102 +++--
 block/blk-throttle.c                               |  15 +-
 block/blk-zoned.c                                  |   5 +-
 block/blk.h                                        |   3 +-
 block/bounce.c                                     |   2 -
 block/fops.c                                       |  16 +
 block/ioctl.c                                      |   6 +
 crypto/ahash.c                                     |   4 +
 crypto/algif_hash.c                                |   4 -
 crypto/lzo-rle.c                                   |   2 +-
 crypto/lzo.c                                       |   2 +-
 crypto/skcipher.c                                  |   1 +
 drivers/accel/amdxdna/aie2_ctx.c                   |  37 +-
 drivers/accel/amdxdna/amdxdna_ctx.c                |   2 +
 drivers/accel/amdxdna/amdxdna_ctx.h                |   3 +
 drivers/accel/amdxdna/amdxdna_mailbox.c            |  17 +-
 drivers/accel/qaic/qaic_drv.c                      |   2 +-
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/acpi_pnp.c                            |   2 +
 drivers/acpi/hed.c                                 |   7 +-
 drivers/auxdisplay/charlcd.c                       |   5 +-
 drivers/auxdisplay/charlcd.h                       |   5 +-
 drivers/auxdisplay/hd44780.c                       |   2 +-
 drivers/auxdisplay/lcd2s.c                         |   2 +-
 drivers/auxdisplay/panel.c                         |   2 +-
 drivers/base/faux.c                                |  15 +-
 drivers/base/power/main.c                          |   7 +
 drivers/block/loop.c                               |  25 +-
 drivers/block/null_blk/main.c                      |  90 ++--
 drivers/block/ublk_drv.c                           |  53 ++-
 drivers/bluetooth/btmtksdio.c                      |  15 +-
 drivers/bluetooth/btusb.c                          |  98 ++---
 drivers/char/tpm/tpm2-sessions.c                   |   2 +-
 drivers/clk/clk-s2mps11.c                          |   3 +-
 drivers/clk/imx/clk-imx8mp.c                       | 151 +++++++
 drivers/clk/qcom/Kconfig                           |   2 +-
 drivers/clk/qcom/camcc-sm8250.c                    |  56 +--
 drivers/clk/qcom/clk-alpha-pll.c                   |  52 ++-
 drivers/clk/qcom/lpassaudiocc-sc7280.c             |  23 +-
 drivers/clk/renesas/rzg2l-cpg.c                    | 106 ++---
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c               |  42 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c             |  36 +-
 drivers/clk/sunxi-ng/ccu_mp.h                      |  22 +
 drivers/clocksource/mips-gic-timer.c               |   6 +-
 drivers/clocksource/timer-riscv.c                  |   6 +
 drivers/cpufreq/amd-pstate.c                       |   1 -
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 +
 drivers/cpufreq/tegra186-cpufreq.c                 |   7 +
 drivers/cpuidle/governors/menu.c                   |  13 +-
 .../crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c   |   7 +-
 drivers/crypto/mxs-dcp.c                           |   8 +-
 drivers/dma/fsl-edma-main.c                        |   2 +-
 drivers/dma/idxd/cdev.c                            |   9 +
 drivers/dma/ti/k3-udma-glue.c                      |  15 +-
 drivers/dpll/dpll_core.c                           |   5 +-
 drivers/edac/ie31200_edac.c                        |  28 +-
 drivers/firmware/arm_ffa/bus.c                     |   1 +
 drivers/firmware/arm_ffa/driver.c                  |  12 +
 drivers/firmware/arm_scmi/bus.c                    |  19 +-
 drivers/firmware/xilinx/zynqmp.c                   |   6 +-
 drivers/fpga/altera-cvp.c                          |   2 +-
 drivers/gpio/gpiolib.c                             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   | 102 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         | 143 ++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  31 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |  54 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ih.h             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  38 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c           |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.h           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_umc.c            |  42 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  41 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   1 -
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  14 +
 .../gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h  |  35 ++
 .../drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm | 126 ++++++
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  47 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  48 ++-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c           |  10 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   1 -
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.h           |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c            |  25 ++
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_8.c            |  27 ++
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c            |  31 ++
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  16 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   8 +-
 drivers/gpu/drm/amd/amdgpu/soc21.c                 |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |  14 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.h            |   9 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            | 474 +++++++++++----------
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            |  48 ++-
 drivers/gpu/drm/amd/amdkfd/cik_event_interrupt.c   |  18 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  25 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c             |  14 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  | 126 ++----
 .../drm/amd/amdkfd/kfd_device_queue_manager_cik.c  |  69 ++-
 .../drm/amd/amdkfd/kfd_device_queue_manager_v10.c  |  43 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_v11.c  |  45 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_v12.c  |  45 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_v9.c   |  38 +-
 .../drm/amd/amdkfd/kfd_device_queue_manager_vi.c   |  77 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  43 +-
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c   |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c    |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_vi.c |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           | 137 +++---
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  21 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |  23 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  41 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   2 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   6 +-
 drivers/gpu/drm/amd/display/dc/basics/dc_common.c  |   3 +-
 .../gpu/drm/amd/display/dc/bios/command_table2.c   |   9 -
 .../amd/display/dc/bios/command_table_helper2.c    |   3 +-
 .../amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |  22 +-
 .../amd/display/dc/clk_mgr/dcn316/dcn316_clk_mgr.c |  15 +-
 .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |  13 +-
 .../amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  22 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |  21 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  71 ++-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |  50 +--
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h       |  12 +
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h       |   5 +-
 drivers/gpu/drm/amd/display/dc/dc_types.h          |   7 +
 .../drm/amd/display/dc/dce/dce_stream_encoder.c    |   3 +-
 drivers/gpu/drm/amd/display/dc/dce/dmub_psr.c      |   4 +
 .../display/dc/dio/dcn10/dcn10_stream_encoder.c    |   3 +-
 .../dc/dio/dcn401/dcn401_dio_stream_encoder.c      |   3 +-
 .../gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c   |   6 +-
 .../gpu/drm/amd/display/dc/dml/dcn351/dcn351_fpu.c |   1 +
 .../drm/amd/display/dc/dml2/dml21/dml21_utils.c    |   1 -
 .../drm/amd/display/dc/dml2/dml21/dml21_wrapper.c  |  22 +-
 .../amd/display/dc/dml2/dml21/inc/dml_top_types.h  |   1 +
 .../dc/dml2/dml21/src/dml2_core/dml2_core_dcn4.c   |  30 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |  33 +-
 .../dml21/src/dml2_core/dml2_core_shared_types.h   |   5 +
 .../dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c  |  21 +
 .../dc/dml2/dml21/src/dml2_top/dml2_top_soc15.c    |   8 -
 drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h |   1 +
 .../gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c   |  11 +-
 .../dc/hpo/dcn31/dcn31_hpo_dp_stream_encoder.c     |   3 +-
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  10 +-
 .../drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c    |  55 +--
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |  22 +-
 .../drm/amd/display/dc/hwss/dcn31/dcn31_hwseq.c    |   4 +-
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   3 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |  92 ++--
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h  |   3 +
 .../drm/amd/display/dc/hwss/dcn401/dcn401_init.c   |   2 +-
 drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h |   6 +
 drivers/gpu/drm/amd/display/dc/inc/core_types.h    |   2 +-
 .../drm/amd/display/dc/inc/hw/clk_mgr_internal.h   |   1 +
 drivers/gpu/drm/amd/display/dc/inc/hw/dpp.h        |   6 +-
 drivers/gpu/drm/amd/display/dc/inc/resource.h      |   2 +
 .../display/dc/link/protocols/link_dp_capability.c |  42 +-
 .../amd/display/dc/link/protocols/link_dp_phy.c    |   8 +-
 .../display/dc/link/protocols/link_dp_training.c   |   5 +-
 .../dc/link/protocols/link_dp_training_8b_10b.c    |   7 +-
 .../dc/link/protocols/link_edp_panel_control.c     |  25 +-
 .../display/dc/resource/dcn315/dcn315_resource.c   |  40 +-
 drivers/gpu/drm/amd/display/dc/spl/dc_spl.c        |  87 ++--
 drivers/gpu/drm/amd/display/dc/spl/dc_spl_types.h  |  12 +-
 .../gpu/drm/amd/display/dc/spl/spl_fixpt31_32.c    |   2 +-
 .../gpu/drm/amd/display/dc/spl/spl_fixpt31_32.h    |   4 +-
 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h    |   6 +
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c  |  17 +-
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c  |   4 +-
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.c |  47 +-
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.h |   3 +-
 .../amd/display/modules/info_packet/info_packet.c  |   4 +-
 .../include/asic_reg/mmhub/mmhub_9_4_1_offset.h    |  32 ++
 .../include/asic_reg/mmhub/mmhub_9_4_1_sh_mask.h   |  48 +++
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   1 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c   |   5 +-
 drivers/gpu/drm/ast/ast_main.c                     |  30 +-
 drivers/gpu/drm/ast/ast_mode.c                     |  10 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |   2 +
 drivers/gpu/drm/drm_atomic_helper.c                |  28 ++
 drivers/gpu/drm/drm_buddy.c                        |   5 +-
 drivers/gpu/drm/drm_edid.c                         |   1 +
 drivers/gpu/drm/drm_gem.c                          |   4 +-
 drivers/gpu/drm/i915/display/intel_dp_mst.c        |   3 +-
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   5 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |  32 ++
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.h        |   2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   7 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |   2 +-
 drivers/gpu/drm/panel/panel-edp.c                  |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  40 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   3 +-
 drivers/gpu/drm/v3d/v3d_drv.c                      |  25 +-
 drivers/gpu/drm/virtio/virtgpu_drv.c               |   9 +
 drivers/gpu/drm/xe/display/xe_display.c            |   3 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  22 +
 drivers/gpu/drm/xe/xe_debugfs.c                    |   3 +-
 drivers/gpu/drm/xe/xe_device.c                     |  10 +-
 drivers/gpu/drm/xe/xe_drm_client.c                 |   8 +
 drivers/gpu/drm/xe/xe_gen_wa_oob.c                 |   6 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   3 +
 drivers/gpu/drm/xe/xe_gt_idle.c                    |  23 +-
 drivers/gpu/drm/xe/xe_gt_idle.h                    |   1 +
 drivers/gpu/drm/xe/xe_gt_idle_types.h              |   3 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c                |  49 ++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c         |  66 ++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h         |   1 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h          |  10 +
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c                |  12 +-
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c        |  22 +
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h        |   2 +
 drivers/gpu/drm/xe/xe_guc_log.c                    |   8 +-
 drivers/gpu/drm/xe/xe_guc_pc.c                     |  22 +-
 drivers/gpu/drm/xe/xe_guc_relay.c                  |   2 +-
 drivers/gpu/drm/xe/xe_mmio.c                       |  10 +-
 drivers/gpu/drm/xe/xe_oa.c                         |   1 +
 drivers/gpu/drm/xe/xe_pci.c                        |  37 +-
 drivers/gpu/drm/xe/xe_pci_sriov.c                  |  51 +++
 drivers/gpu/drm/xe/xe_pci_types.h                  |   1 +
 drivers/gpu/drm/xe/xe_pt.c                         |  14 +
 drivers/gpu/drm/xe/xe_pt.h                         |   3 +
 drivers/gpu/drm/xe/xe_sa.c                         |   3 +-
 drivers/gpu/drm/xe/xe_tile.c                       |  12 +-
 drivers/gpu/drm/xe/xe_tile.h                       |   1 +
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c             |  17 +-
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.h             |   2 +-
 drivers/gpu/drm/xe/xe_vm.c                         |  32 ++
 drivers/hid/Kconfig                                |   1 +
 drivers/hid/usbhid/usbkbd.c                        |   2 +-
 drivers/hwmon/acpi_power_meter.c                   |   8 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   5 +-
 drivers/hwmon/gpio-fan.c                           |  16 +-
 drivers/hwmon/xgene-hwmon.c                        |   2 +-
 drivers/hwtracing/coresight/coresight-core.c       |   2 +-
 drivers/hwtracing/coresight/coresight-etb10.c      |  26 +-
 drivers/hwtracing/coresight/coresight-trace-id.c   |  22 +-
 drivers/hwtracing/intel_th/Kconfig                 |   1 +
 drivers/hwtracing/intel_th/msu.c                   |  31 +-
 drivers/i2c/busses/i2c-amd-asf-plat.c              |   2 +-
 drivers/i2c/busses/i2c-pxa.c                       |   5 +-
 drivers/i2c/busses/i2c-qcom-geni.c                 |   6 +-
 drivers/i2c/busses/i2c-qup.c                       |  36 ++
 drivers/i3c/master/svc-i3c-master.c                |   4 +
 drivers/iio/accel/fxls8962af-core.c                |   7 +-
 drivers/iio/adc/ad7606.c                           |  10 +
 drivers/iio/adc/ad7944.c                           |  16 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |   4 +-
 drivers/iio/dac/ad3552r-hs.c                       |  29 +-
 drivers/iio/dac/ad3552r-hs.h                       |   8 +
 drivers/iio/dac/adi-axi-dac.c                      |  22 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   7 +-
 drivers/infiniband/core/umem.c                     |  36 +-
 drivers/infiniband/core/uverbs_cmd.c               | 144 ++++---
 drivers/infiniband/core/verbs.c                    |  11 +-
 drivers/input/joystick/xpad.c                      |   3 +
 drivers/input/rmi4/rmi_f34.c                       | 133 +++---
 drivers/iommu/amd/io_pgtable_v2.c                  |   2 +-
 drivers/iommu/dma-iommu.c                          |  28 +-
 drivers/iommu/intel/iommu.c                        |  37 +-
 drivers/iommu/intel/svm.c                          |  43 ++
 drivers/iommu/iommu-priv.h                         |   2 +
 drivers/iommu/iommu.c                              |   2 +-
 drivers/iommu/iommufd/device.c                     |  34 +-
 drivers/iommu/iommufd/hw_pagetable.c               |   3 +
 drivers/iommu/of_iommu.c                           |   6 +-
 drivers/irqchip/irq-riscv-aplic-direct.c           |  24 +-
 drivers/irqchip/irq-riscv-imsic-early.c            |   8 +-
 drivers/irqchip/irq-riscv-imsic-platform.c         |  16 +-
 drivers/irqchip/irq-riscv-imsic-state.c            |  96 +++--
 drivers/irqchip/irq-riscv-imsic-state.h            |   7 +-
 drivers/leds/Kconfig                               |   1 +
 drivers/leds/leds-st1202.c                         |   4 +-
 drivers/leds/rgb/leds-pwm-multicolor.c             |   5 +-
 drivers/leds/trigger/ledtrig-netdev.c              |  16 +-
 drivers/mailbox/mailbox.c                          |   7 +-
 drivers/mailbox/pcc.c                              |   8 +-
 drivers/md/dm-cache-target.c                       |  24 ++
 drivers/md/dm-table.c                              |   4 +
 drivers/md/dm-vdo/indexer/index-layout.c           |   5 +-
 drivers/md/dm-vdo/io-submitter.c                   |   6 +-
 drivers/md/dm-vdo/io-submitter.h                   |  18 +-
 drivers/md/dm-vdo/types.h                          |   3 +
 drivers/md/dm-vdo/vdo.c                            |  11 +-
 drivers/md/dm-vdo/vio.c                            |  36 +-
 drivers/md/dm-vdo/vio.h                            |   2 +
 drivers/md/dm.c                                    |   8 +-
 drivers/media/cec/core/cec-pin.c                   |  11 +-
 drivers/media/i2c/adv7180.c                        |  34 +-
 drivers/media/i2c/imx219.c                         |   2 +-
 drivers/media/i2c/imx335.c                         |  21 +-
 drivers/media/i2c/ov2740.c                         |   4 +-
 drivers/media/i2c/tc358746.c                       |  19 +-
 drivers/media/platform/qcom/camss/camss-csid.c     |  64 +--
 drivers/media/platform/qcom/camss/camss-vfe.c      |   4 +
 .../platform/st/sti/c8sectpfe/c8sectpfe-core.c     |   3 +-
 drivers/media/platform/st/stm32/stm32-csi.c        |  36 +-
 .../media/test-drivers/vivid/vivid-kthread-cap.c   |  11 +-
 .../media/test-drivers/vivid/vivid-kthread-out.c   |  11 +-
 .../media/test-drivers/vivid/vivid-kthread-touch.c |  11 +-
 drivers/media/test-drivers/vivid/vivid-sdr-cap.c   |  11 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |  77 ++--
 drivers/media/usb/uvc/uvc_v4l2.c                   |   6 +
 drivers/media/v4l2-core/v4l2-subdev.c              |   2 +
 drivers/message/fusion/mptscsih.c                  |   4 +-
 drivers/mfd/axp20x.c                               |   1 +
 drivers/mfd/syscon.c                               |   9 +-
 drivers/mfd/tps65219.c                             |   7 -
 drivers/misc/eeprom/ee1004.c                       |   4 +
 drivers/misc/mei/vsc-tp.c                          |  14 +-
 drivers/misc/pci_endpoint_test.c                   |   6 +-
 drivers/mmc/host/dw_mmc-exynos.c                   |  41 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   6 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/sdhci_am654.c                     |  35 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/can/c_can/c_can_platform.c             |   2 +-
 drivers/net/can/kvaser_pciefd.c                    | 101 +++--
 drivers/net/can/slcan/slcan-core.c                 |  26 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/freescale/fec_main.c          |  52 ++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   3 +-
 drivers/net/ethernet/intel/ice/ice_irq.c           |  25 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |   6 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   6 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   1 -
 drivers/net/ethernet/intel/idpf/idpf.h             |   2 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |  10 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  18 +-
 drivers/net/ethernet/intel/igc/igc_xdp.c           |  19 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   4 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |  24 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  11 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |   7 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 114 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  10 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  34 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 124 ++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   7 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  21 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_xsk.c  | 182 ++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_xsk.h  |  21 +
 .../net/ethernet/marvell/octeontx2/nic/qos_sq.c    |   2 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   3 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  16 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   1 -
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  53 +--
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  28 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  40 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c |  13 +
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h |   5 +
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.c   |   6 +-
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.h   |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   1 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   3 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         |  16 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.h         |   8 +-
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   2 +
 drivers/net/ethernet/microchip/lan743x_main.c      |  19 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |  32 ++
 drivers/net/ethernet/stmicro/stmmac/common.h       |   4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  21 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   7 +-
 drivers/net/ethernet/tehuti/tn40.c                 |   9 +-
 drivers/net/ethernet/tehuti/tn40.h                 |  33 ++
 drivers/net/ethernet/tehuti/tn40_mdio.c            |  82 +++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   4 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   1 +
 drivers/net/ethernet/ti/icssg/icssg_common.c       |   2 +-
 drivers/net/ieee802154/ca8210.c                    |   9 +-
 drivers/net/mctp/mctp-i2c.c                        |   2 +-
 drivers/net/netdevsim/netdev.c                     |  31 +-
 drivers/net/netdevsim/netdevsim.h                  |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c                  |  54 ++-
 drivers/net/phy/phylink.c                          |   2 +-
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   5 +-
 drivers/net/vxlan/vxlan_core.c                     |  36 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            | 117 +++--
 drivers/net/wireless/ath/ath12k/core.c             |  45 +-
 drivers/net/wireless/ath/ath12k/core.h             |   4 +
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  19 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  22 +-
 drivers/net/wireless/ath/ath12k/dp_rx.h            |   5 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            | 145 ++++++-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |   2 +-
 drivers/net/wireless/ath/ath12k/hal_rx.h           |   8 +-
 drivers/net/wireless/ath/ath12k/hal_tx.h           |  10 +-
 drivers/net/wireless/ath/ath12k/mac.c              | 102 ++++-
 drivers/net/wireless/ath/ath12k/mac.h              |   5 +-
 drivers/net/wireless/ath/ath12k/pci.c              |  13 +-
 drivers/net/wireless/ath/ath12k/rx_desc.h          |   5 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |   4 +-
 drivers/net/wireless/ath/ath9k/init.c              |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c        |   2 -
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   8 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  15 +
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |   6 +-
 drivers/net/wireless/mediatek/mt76/channel.c       |   3 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   3 +
 .../net/wireless/mediatek/mt76/mt76_connac3_mac.h  |   3 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  76 +++-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   3 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  44 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  30 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/scan.c          |  21 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   3 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  17 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |  15 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   1 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   7 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  54 ++-
 drivers/net/wireless/realtek/rtw88/main.h          |   1 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |  14 +-
 drivers/net/wireless/realtek/rtw88/util.c          |   3 +-
 drivers/net/wireless/realtek/rtw89/coex.c          | 107 +++--
 drivers/net/wireless/realtek/rtw89/coex.h          |   2 +
 drivers/net/wireless/realtek/rtw89/core.c          |  67 ++-
 drivers/net/wireless/realtek/rtw89/core.h          |   6 +-
 drivers/net/wireless/realtek/rtw89/fw.c            | 101 ++++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  12 +
 drivers/net/wireless/realtek/rtw89/mac.c           |  55 ++-
 drivers/net/wireless/realtek/rtw89/mac.h           |   3 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   1 +
 drivers/net/wireless/realtek/rtw89/reg.h           |   4 +
 drivers/net/wireless/realtek/rtw89/regd.c          |   2 +
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |   8 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   8 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   8 +
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c     |   8 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   8 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c      |   2 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   4 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |  14 +-
 drivers/nvdimm/label.c                             |   3 +-
 drivers/nvme/host/pci.c                            |   6 +
 drivers/nvme/target/pci-epf.c                      |  66 ++-
 drivers/nvme/target/tcp.c                          |   3 +
 drivers/nvmem/core.c                               |  40 +-
 drivers/nvmem/qfprom.c                             |  26 +-
 drivers/nvmem/rockchip-otp.c                       |  17 +-
 drivers/pci/Kconfig                                |   6 +
 drivers/pci/ats.c                                  |  33 ++
 drivers/pci/controller/dwc/pcie-designware-ep.c    |   2 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |   5 +-
 drivers/pci/controller/pcie-xilinx-cpm.c           |   3 +-
 drivers/pci/controller/vmd.c                       |  20 +
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   2 +
 drivers/pci/setup-bus.c                            |   6 +-
 drivers/perf/arm_pmuv3.c                           |   4 +-
 drivers/phy/phy-core.c                             |   7 +-
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           |  95 +++--
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c  |   4 +-
 drivers/phy/rockchip/phy-rockchip-usbdp.c          | 105 +++--
 drivers/phy/samsung/phy-exynos5-usbdrd.c           |   7 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |  44 +-
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/meson/pinctrl-meson.c              |   2 +-
 drivers/pinctrl/qcom/Kconfig.msm                   |   4 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  23 +-
 drivers/pinctrl/qcom/pinctrl-msm8917.c             |   8 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |  19 +-
 drivers/pinctrl/sophgo/pinctrl-cv18xx.c            |  33 +-
 drivers/pinctrl/tegra/pinctrl-tegra.c              |  59 ++-
 drivers/pinctrl/tegra/pinctrl-tegra.h              |   6 +
 drivers/platform/x86/asus-wmi.c                    |  11 +-
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |   2 +-
 drivers/platform/x86/ideapad-laptop.c              |  16 +
 drivers/platform/x86/intel/hid.c                   |  21 +-
 drivers/platform/x86/think-lmi.c                   |  26 +-
 drivers/platform/x86/think-lmi.h                   |   1 +
 drivers/pmdomain/core.c                            |   2 +-
 drivers/pmdomain/imx/gpcv2.c                       |   2 +-
 drivers/pmdomain/renesas/rcar-gen4-sysc.c          |   5 -
 drivers/pmdomain/renesas/rcar-sysc.c               |   5 -
 drivers/power/supply/axp20x_battery.c              |  21 +
 drivers/pps/generators/pps_gen-dummy.c             |   2 +-
 drivers/pps/generators/pps_gen.c                   |  14 +-
 drivers/pps/generators/sysfs.c                     |   6 +-
 drivers/ptp/ptp_ocp.c                              |  24 +-
 drivers/regulator/ad5398.c                         |  12 +-
 drivers/remoteproc/qcom_wcnss.c                    |  34 +-
 drivers/rtc/rtc-ds1307.c                           |   4 +-
 drivers/rtc/rtc-rv3032.c                           |   2 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |  72 ++--
 drivers/scsi/aacraid/aachba.c                      |   4 +-
 drivers/scsi/arm/acornscsi.c                       |   2 +-
 drivers/scsi/ips.c                                 |   8 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  16 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  29 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/megaraid.c                            |  10 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |  10 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  12 +-
 drivers/scsi/scsi_debug.c                          |  55 ++-
 drivers/scsi/scsi_sysctl.c                         |   4 +-
 drivers/scsi/st.c                                  |  29 +-
 drivers/scsi/st.h                                  |   2 +
 drivers/soc/apple/rtkit-internal.h                 |   1 +
 drivers/soc/apple/rtkit.c                          |  58 ++-
 drivers/soc/mediatek/mtk-mutex.c                   |   6 +
 drivers/soc/samsung/exynos-asv.c                   |   1 +
 drivers/soc/samsung/exynos-chipid.c                |   1 +
 drivers/soc/samsung/exynos-pmu.c                   |   1 +
 drivers/soc/samsung/exynos-usi.c                   |   1 +
 drivers/soc/samsung/exynos3250-pmu.c               |   1 +
 drivers/soc/samsung/exynos5250-pmu.c               |   1 +
 drivers/soc/samsung/exynos5420-pmu.c               |   1 +
 drivers/soc/ti/k3-socinfo.c                        |  13 +-
 drivers/soundwire/amd_manager.c                    |   2 +
 drivers/soundwire/bus.c                            |   9 +-
 drivers/soundwire/cadence_master.c                 |  22 +-
 drivers/spi/spi-fsl-dspi.c                         |  46 +-
 drivers/spi/spi-mux.c                              |   4 +-
 drivers/spi/spi-rockchip.c                         |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  22 +-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  69 ++-
 drivers/target/iscsi/iscsi_target.c                |   2 +-
 drivers/target/target_core_device.c                |   8 +-
 drivers/target/target_core_pr.c                    |   6 +-
 drivers/target/target_core_spc.c                   |  34 +-
 drivers/thermal/intel/x86_pkg_temp_thermal.c       |   1 +
 drivers/thermal/mediatek/lvts_thermal.c            |   3 +-
 drivers/thermal/qoriq_thermal.c                    |  13 +
 drivers/thunderbolt/retimer.c                      |   8 +-
 drivers/tty/serial/8250/8250_port.c                |   2 +-
 drivers/tty/serial/atmel_serial.c                  |   2 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |  34 +-
 drivers/tty/serial/serial_mctrl_gpio.h             |  17 +-
 drivers/tty/serial/sh-sci.c                        |  98 ++++-
 drivers/tty/serial/stm32-usart.c                   |   2 +-
 drivers/ufs/core/ufshcd.c                          |  29 ++
 drivers/usb/gadget/function/f_mass_storage.c       |   4 +-
 drivers/usb/host/xhci-mem.c                        |  34 +-
 drivers/usb/host/xhci-ring.c                       |  12 +-
 drivers/usb/host/xhci.h                            |   8 +-
 drivers/usb/storage/debug.c                        |   4 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   3 +
 drivers/vfio/pci/vfio_pci_config.c                 |   3 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  10 +-
 drivers/vfio/pci/vfio_pci_intrs.c                  |   2 +-
 drivers/vhost/scsi.c                               |  23 +-
 drivers/video/fbdev/core/bitblit.c                 |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |  10 +-
 drivers/video/fbdev/core/fbcon.h                   |  38 +-
 drivers/video/fbdev/core/fbcon_ccw.c               |   5 +-
 drivers/video/fbdev/core/fbcon_cw.c                |   5 +-
 drivers/video/fbdev/core/fbcon_ud.c                |   5 +-
 drivers/video/fbdev/core/tileblit.c                |  45 +-
 drivers/video/fbdev/fsl-diu-fb.c                   |   1 +
 drivers/virtio/virtio.c                            |  35 ++
 drivers/virtio/virtio_ring.c                       |   2 +-
 drivers/watchdog/aspeed_wdt.c                      |  81 +++-
 drivers/watchdog/s3c2410_wdt.c                     |  10 +-
 drivers/xen/pci.c                                  |  32 ++
 drivers/xen/platform-pci.c                         |   4 +
 drivers/xen/xenbus/xenbus_probe.c                  |  14 +-
 fs/btrfs/block-group.c                             |  18 +-
 fs/btrfs/compression.c                             |   2 +-
 fs/btrfs/discard.c                                 |  34 +-
 fs/btrfs/disk-io.c                                 |  28 +-
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/extent_io.h                               |   2 +
 fs/btrfs/scrub.c                                   |   4 +-
 fs/btrfs/send.c                                    |   6 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/buffer.c                                        |  61 ++-
 fs/dlm/lowcomms.c                                  |   4 +-
 fs/erofs/internal.h                                |   4 +-
 fs/erofs/super.c                                   |  46 +-
 fs/erofs/zdata.c                                   |   4 +-
 fs/exfat/inode.c                                   | 169 ++++----
 fs/ext4/balloc.c                                   |   4 +-
 fs/ext4/ext4.h                                     |   5 +-
 fs/ext4/extents.c                                  |  19 +-
 fs/ext4/inode.c                                    |  81 +++-
 fs/ext4/mballoc.c                                  |   3 +-
 fs/ext4/page-io.c                                  |  16 +-
 fs/ext4/super.c                                    |  19 +-
 fs/f2fs/sysfs.c                                    |  74 +++-
 fs/fuse/dir.c                                      |   2 +
 fs/gfs2/glock.c                                    |  11 +-
 fs/jbd2/recovery.c                                 |  69 ++-
 fs/jbd2/revoke.c                                   |  23 +-
 fs/namespace.c                                     |   6 +-
 fs/nfs/delegation.c                                |   3 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |   1 +
 fs/nfs/inode.c                                     |   2 +
 fs/nfs/internal.h                                  |   5 +
 fs/nfs/nfs3proc.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |   9 +-
 fs/nfs/nfs4state.c                                 |  10 +-
 fs/nilfs2/the_nilfs.c                              |   3 -
 fs/ocfs2/journal.c                                 |   2 +-
 fs/orangefs/inode.c                                |   7 +-
 fs/pidfs.c                                         |   9 +-
 fs/pipe.c                                          |   4 +
 fs/pstore/inode.c                                  |   2 +-
 fs/pstore/internal.h                               |   4 +-
 fs/pstore/platform.c                               |  11 +-
 fs/smb/client/cifsacl.c                            |  21 +-
 fs/smb/client/cifspdu.h                            |   5 +-
 fs/smb/client/cifsproto.h                          |   7 +
 fs/smb/client/cifssmb.c                            |  93 +++-
 fs/smb/client/connect.c                            |  30 +-
 fs/smb/client/fs_context.c                         |  13 +
 fs/smb/client/fs_context.h                         |   3 +
 fs/smb/client/link.c                               |  11 +-
 fs/smb/client/readdir.c                            |   7 +-
 fs/smb/client/smb1ops.c                            | 228 ++++++++--
 fs/smb/client/smb2file.c                           |  11 +-
 fs/smb/client/smb2inode.c                          |   8 +
 fs/smb/client/smb2ops.c                            |  34 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/client/transport.c                          |   2 +-
 fs/smb/client/xattr.c                              |  15 +-
 fs/smb/common/smb2pdu.h                            |   3 +
 fs/smb/server/smb2pdu.c                            |   9 +-
 fs/smb/server/vfs.c                                |  14 +-
 include/crypto/hash.h                              |   3 +
 include/drm/drm_atomic.h                           |  23 +-
 include/drm/drm_gem.h                              |  13 +
 include/linux/alloc_tag.h                          |  12 +
 include/linux/blkdev.h                             |   1 +
 include/linux/bpf-cgroup.h                         |   1 +
 include/linux/bpf.h                                |   7 +-
 include/linux/buffer_head.h                        |   8 +
 include/linux/codetag.h                            |   8 +-
 include/linux/coresight.h                          |   2 +-
 include/linux/device.h                             | 119 +-----
 include/linux/device/devres.h                      | 129 ++++++
 include/linux/dma-mapping.h                        |  12 +-
 include/linux/dma/k3-udma-glue.h                   |   3 +-
 include/linux/err.h                                |   3 +
 include/linux/gpio/driver.h                        |   3 +-
 include/linux/highmem.h                            |  10 +-
 include/linux/io.h                                 |   2 -
 include/linux/ipv6.h                               |   1 +
 include/linux/jbd2.h                               |   2 +
 include/linux/lzo.h                                |   8 +
 include/linux/mfd/axp20x.h                         |   1 +
 include/linux/mlx4/device.h                        |   2 +-
 include/linux/mlx5/eswitch.h                       |   2 +
 include/linux/mlx5/fs.h                            |   2 +
 include/linux/mm.h                                 |   2 +-
 include/linux/mman.h                               |   2 +
 include/linux/mroute_base.h                        |   5 +
 include/linux/msi.h                                |  33 +-
 include/linux/objtool.h                            |   4 +-
 include/linux/page-flags.h                         |   7 +
 include/linux/pci-ats.h                            |   3 +
 include/linux/percpu.h                             |   4 -
 include/linux/perf_event.h                         |   8 +-
 include/linux/pnp.h                                |   2 +-
 include/linux/pps_gen_kernel.h                     |   4 +-
 include/linux/rcupdate.h                           |   2 +-
 include/linux/rcutree.h                            |   2 +-
 include/linux/ring_buffer.h                        |   3 +-
 include/linux/spi/spi.h                            |   5 +-
 include/linux/tcp.h                                |   2 +
 include/linux/trace.h                              |   4 +-
 include/linux/trace_seq.h                          |   8 +-
 include/linux/usb/r8152.h                          |   1 +
 include/linux/virtio.h                             |   3 +
 include/media/v4l2-subdev.h                        |   4 +-
 include/net/cfg80211.h                             |   4 +
 include/net/dropreason.h                           |   6 -
 include/net/mac80211.h                             |   4 +-
 include/net/xfrm.h                                 |   1 -
 include/rdma/uverbs_std_types.h                    |   2 +-
 include/scsi/scsi_proto.h                          |   4 +-
 include/sound/hda_codec.h                          |   1 +
 include/sound/pcm.h                                |   2 +
 include/sound/soc_sdw_utils.h                      |   1 +
 include/trace/events/btrfs.h                       |   2 +-
 include/trace/events/scsi.h                        |   4 +-
 include/trace/events/target.h                      |   4 +-
 include/uapi/linux/bpf.h                           |   1 +
 include/uapi/linux/iommufd.h                       |  14 +-
 include/uapi/linux/nl80211.h                       |  52 ++-
 include/uapi/linux/snmp.h                          |   1 +
 include/uapi/linux/taskstats.h                     |  47 +-
 include/ufs/ufs_quirks.h                           |   6 +
 io_uring/fdinfo.c                                  |   4 +-
 io_uring/io_uring.c                                |  96 +++--
 io_uring/msg_ring.c                                |   1 +
 io_uring/net.c                                     |  14 +-
 kernel/bpf/bpf_iter.c                              |  13 +-
 kernel/bpf/bpf_struct_ops.c                        |  98 ++---
 kernel/bpf/cgroup.c                                |  33 +-
 kernel/bpf/disasm.c                                |   4 +-
 kernel/bpf/hashtab.c                               |   2 +-
 kernel/bpf/syscall.c                               |   8 +-
 kernel/bpf/verifier.c                              |  56 ++-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/cgroup/rstat.c                              |  12 +-
 kernel/dma/mapping.c                               |  27 +-
 kernel/events/core.c                               | 104 +++--
 kernel/events/hw_breakpoint.c                      |   5 +-
 kernel/events/ring_buffer.c                        |   1 +
 kernel/exit.c                                      |   6 +-
 kernel/fork.c                                      |   9 +-
 kernel/module/main.c                               |   1 +
 kernel/padata.c                                    |   3 +-
 kernel/printk/printk.c                             |  14 +-
 kernel/rcu/rcu.h                                   |   2 +-
 kernel/rcu/tree.c                                  |  15 +-
 kernel/rcu/tree_plugin.h                           |  22 +-
 kernel/rseq.c                                      |  60 ++-
 kernel/sched/fair.c                                |   6 +-
 kernel/signal.c                                    |   3 +-
 kernel/softirq.c                                   |  18 +
 kernel/time/hrtimer.c                              |  29 +-
 kernel/time/posix-timers.c                         |  26 +-
 kernel/time/timer_list.c                           |   4 +-
 kernel/trace/ring_buffer.c                         |  31 +-
 kernel/trace/trace.c                               |  41 +-
 kernel/trace/trace.h                               |  25 +-
 kernel/vhost_task.c                                |   2 +-
 lib/alloc_tag.c                                    |  87 +++-
 lib/codetag.c                                      |   5 +-
 lib/dynamic_queue_limits.c                         |   2 +-
 lib/lzo/Makefile                                   |   2 +-
 lib/lzo/lzo1x_compress.c                           | 102 +++--
 lib/lzo/lzo1x_compress_safe.c                      |  18 +
 mm/hugetlb.c                                       |   8 +
 mm/kasan/shadow.c                                  |  92 +++-
 mm/memcontrol.c                                    |   6 +-
 mm/page_alloc.c                                    |   8 +
 mm/vmalloc.c                                       |  13 +-
 net/bluetooth/hci_event.c                          |   3 +
 net/bluetooth/l2cap_core.c                         |  15 +-
 net/bridge/br_mdb.c                                |   2 +-
 net/bridge/br_nf_core.c                            |   7 +-
 net/bridge/br_private.h                            |   1 +
 net/can/bcm.c                                      |  79 ++--
 net/core/dev.c                                     |  12 +-
 net/core/dev.h                                     |  12 +
 net/core/net-sysfs.c                               |   5 +-
 net/core/page_pool.c                               |   7 +-
 net/core/pktgen.c                                  |  13 +-
 net/core/rtnetlink.c                               |  10 +-
 net/dsa/tag_ksz.c                                  |  19 +-
 net/hsr/hsr_device.c                               |   2 +
 net/hsr/hsr_forward.c                              |   4 +-
 net/hsr/hsr_framereg.c                             |  95 ++++-
 net/hsr/hsr_framereg.h                             |   8 +-
 net/hsr/hsr_main.h                                 |   2 +
 net/ipv4/esp4.c                                    |  53 +--
 net/ipv4/fib_frontend.c                            |  28 +-
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fib_trie.c                                |  22 -
 net/ipv4/inet_hashtables.c                         |  37 +-
 net/ipv4/ip_gre.c                                  |  16 +-
 net/ipv4/ipmr.c                                    |  12 +-
 net/ipv4/proc.c                                    |   1 +
 net/ipv4/syncookies.c                              |   1 +
 net/ipv4/tcp_input.c                               |  57 +--
 net/ipv4/tcp_minisocks.c                           |  26 +-
 net/ipv4/tcp_output.c                              |   6 +
 net/ipv4/xfrm4_input.c                             |  18 +-
 net/ipv6/esp6.c                                    |  53 +--
 net/ipv6/fib6_rules.c                              |   4 +-
 net/ipv6/ip6_gre.c                                 |   2 -
 net/ipv6/ip6_output.c                              |  11 +-
 net/ipv6/ip6_tunnel.c                              |   3 +-
 net/ipv6/ip6_vti.c                                 |   3 +-
 net/ipv6/ip6mr.c                                   |  12 +-
 net/ipv6/sit.c                                     |   8 +-
 net/ipv6/xfrm6_input.c                             |  18 +-
 net/llc/af_llc.c                                   |   8 +-
 net/mac80211/agg-tx.c                              |   5 +-
 net/mac80211/cfg.c                                 |  14 +-
 net/mac80211/driver-ops.h                          |   3 +-
 net/mac80211/drop.h                                |  21 +-
 net/mac80211/ethtool.c                             |   2 +-
 net/mac80211/ieee80211_i.h                         |  13 +-
 net/mac80211/iface.c                               |  60 ++-
 net/mac80211/main.c                                |  16 +-
 net/mac80211/mlme.c                                | 150 ++++++-
 net/mac80211/rx.c                                  | 194 +++------
 net/mac80211/status.c                              |  32 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/util.c                                |   3 +-
 net/mptcp/pm_userspace.c                           |   8 +-
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/sched/sch_hfsc.c                               |   6 +-
 net/smc/smc_pnet.c                                 |   8 +-
 net/sunrpc/clnt.c                                  |   3 -
 net/sunrpc/rpcb_clnt.c                             |   5 +-
 net/sunrpc/sched.c                                 |   2 +
 net/tipc/crypto.c                                  |   5 +
 net/wireless/chan.c                                |   8 +-
 net/wireless/mlme.c                                |   4 +
 net/wireless/nl80211.c                             |   4 +
 net/wireless/reg.c                                 |   4 +-
 net/xdp/xsk.c                                      |   2 +-
 net/xfrm/espintcp.c                                |   4 +-
 net/xfrm/xfrm_policy.c                             |   3 +
 net/xfrm/xfrm_state.c                              |   6 +-
 net/xfrm/xfrm_user.c                               |  12 +
 samples/bpf/Makefile                               |   2 +-
 scripts/Makefile.extrawarn                         |  11 +-
 scripts/config                                     |  26 +-
 scripts/kconfig/confdata.c                         |  19 +-
 scripts/kconfig/merge_config.sh                    |   4 +-
 security/integrity/ima/ima_main.c                  |   4 +-
 security/smack/smackfs.c                           |  21 +-
 sound/core/oss/pcm_oss.c                           |   3 +-
 sound/core/pcm_native.c                            |  11 +
 sound/core/seq/seq_clientmgr.c                     |   5 +-
 sound/core/seq/seq_memory.c                        |   1 +
 sound/pci/hda/hda_beep.c                           |  15 +-
 sound/pci/hda/patch_realtek.c                      |  77 +++-
 sound/soc/codecs/cs42l43-jack.c                    |   7 +
 sound/soc/codecs/mt6359-accdet.h                   |   9 +
 sound/soc/codecs/pcm3168a.c                        |   6 +-
 sound/soc/codecs/pcm6240.c                         |  28 +-
 sound/soc/codecs/pcm6240.h                         |   7 +-
 sound/soc/codecs/rt722-sdca-sdw.c                  |  49 ++-
 sound/soc/codecs/sma1307.c                         |  27 +-
 sound/soc/codecs/tas2764.c                         |  53 +--
 sound/soc/codecs/wsa883x.c                         |   2 +-
 sound/soc/codecs/wsa884x.c                         |   2 +-
 sound/soc/fsl/imx-card.c                           |   2 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |  13 +
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c         |   8 +
 sound/soc/mediatek/mt8188/mt8188-afe-clk.h         |   8 +
 sound/soc/mediatek/mt8188/mt8188-afe-pcm.c         |   4 -
 sound/soc/qcom/sm8250.c                            |   3 +
 sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c       |   4 +
 sound/soc/sdw_utils/soc_sdw_cs42l43.c              |  10 +
 sound/soc/sdw_utils/soc_sdw_cs_amp.c               |  24 ++
 sound/soc/soc-dai.c                                |   8 +-
 sound/soc/soc-ops.c                                |  29 +-
 sound/soc/sof/intel/hda-bus.c                      |   2 +-
 sound/soc/sof/intel/hda.c                          |  16 +-
 sound/soc/sof/ipc4-control.c                       |  11 +-
 sound/soc/sof/ipc4-pcm.c                           |   3 +-
 sound/soc/sof/topology.c                           |  18 +-
 sound/soc/sunxi/sun4i-codec.c                      |  56 ++-
 sound/usb/midi.c                                   |  16 +-
 tools/arch/x86/include/asm/asm.h                   |   8 +-
 tools/arch/x86/include/asm/nops.h                  |   2 +-
 tools/arch/x86/include/asm/orc_types.h             |   4 +-
 tools/arch/x86/include/asm/pvclock-abi.h           |   4 +-
 tools/bpf/bpftool/btf.c                            |  14 +-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/cgroup.c                         |   2 +-
 tools/bpf/bpftool/common.c                         |   7 +-
 tools/bpf/bpftool/jit_disasm.c                     |   3 +-
 tools/bpf/bpftool/map_perf_ring.c                  |   6 +-
 tools/bpf/bpftool/net.c                            |   4 +-
 tools/bpf/bpftool/netlink_dumper.c                 |   6 +-
 tools/bpf/bpftool/prog.c                           |  12 +-
 tools/bpf/bpftool/tracelog.c                       |   2 +-
 tools/bpf/bpftool/xlated_dumper.c                  |   6 +-
 tools/build/Makefile.build                         |   6 +-
 tools/include/uapi/linux/bpf.h                     |   1 +
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/net/ynl/lib/ynl.c                            |   2 +-
 tools/net/ynl/pyynl/ynl_gen_c.py                   |   3 +
 tools/objtool/check.c                              |  21 +-
 tools/power/x86/turbostat/turbostat.8              |   1 +
 tools/power/x86/turbostat/turbostat.c              |  13 +-
 tools/testing/kunit/kunit_parser.py                |   9 +-
 tools/testing/kunit/qemu_configs/x86_64.py         |   4 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |   1 -
 tools/testing/selftests/iommu/iommufd.c            |   4 +
 .../testing/selftests/net/forwarding/bridge_mdb.sh |   2 +-
 tools/testing/selftests/net/gro.sh                 |   3 +-
 tools/testing/selftests/net/nl_netdev.py           |  18 +-
 .../selftests/pci_endpoint/pci_endpoint_test.c     |   2 +
 1089 files changed, 12544 insertions(+), 5911 deletions(-)


